import 'package:intl/intl.dart' as intl;

import 'l10n.dart';

/// The translations for Bosnian (`bs`).
class AppLocalizationsBs extends AppLocalizations {
  AppLocalizationsBs([String locale = 'bs']) : super(locale);

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
  String get activityHostedALiveStream => 'Bio/la domaćin emitovanja uživo';

  @override
  String activityRankedInSwissTournament(String param1, String param2) {
    return '#$param1 u $param2';
  }

  @override
  String get activitySignedUp => 'Registrovao/la se na lichess';

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
      other: 'Vježbao/la $count pozicije na $param2',
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
      other: 'Odigrao/la $count $param2 partija',
      few: 'Odigrao/la $count $param2 partije',
      one: 'Odigrao/la $count $param2 partiju',
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
      few: 'Igrao/la $count poteza',
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
      few: 'Dobio/la $count novih pratitelja',
      one: 'Dobio/la $count novog pratitelja',
    );
    return '$_temp0';
  }

  @override
  String activityHostedNbSimuls(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Bio/la domaćin $count simultanki',
      few: 'Bio/la domaćin $count simultanke',
      one: 'Bio/la domaćin $count simultanke',
    );
    return '$_temp0';
  }

  @override
  String activityJoinedNbSimuls(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Učestvovao/la u $count simultanki',
      few: 'Učestvovao/la u $count simultanke',
      one: 'Učestvovao/la u $count simultanki',
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
      other: 'Rangiran/a #$count (prvih $param2%) sa $param3 odigranih partija u turniru $param4',
      few: 'Rangiran/a #$count (prvih $param2%) sa $param3 odigrane partijeu turniru $param4',
      one: 'Rangiran/a #$count (prvih $param2%) sa $param3 odigranom partijom u turniru $param4',
    );
    return '$_temp0';
  }

  @override
  String activityCompetedInNbSwissTournaments(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Takmičili se u $count turnirima po švicarskom sistemu',
      few: 'Takmičili se u $count turnirima po švicarskom sistemu',
      one: 'Takmičio se u $count turnirima po švicarskom sistemu',
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
  String get broadcastBroadcasts => 'Emitovanja';

  @override
  String get broadcastLiveBroadcasts => 'Prenos turnira uživo';

  @override
  String challengeChallengesX(String param1) {
    return 'Izazovi: $param1';
  }

  @override
  String get challengeChallengeToPlay => 'Izazov na partiju';

  @override
  String get challengeChallengeDeclined => 'Izazov odbijen';

  @override
  String get challengeChallengeAccepted => 'Izazov prihvaćen!';

  @override
  String get challengeChallengeCanceled => 'Izazov otkazan.';

  @override
  String get challengeRegisterToSendChallenges => 'Molimo, registrirajte se da biste mogli slati izazove.';

  @override
  String challengeYouCannotChallengeX(String param) {
    return 'Ne možete izazvati $param.';
  }

  @override
  String challengeXDoesNotAcceptChallenges(String param) {
    return '$param ne prihvata izazove.';
  }

  @override
  String challengeYourXRatingIsTooFarFromY(String param1, String param2) {
    return 'Vaš $param1 rejting predaleko je od $param2.';
  }

  @override
  String challengeCannotChallengeDueToProvisionalXRating(String param) {
    return 'Nemoguće izazvati zbog privremenog $param rejtinga.';
  }

  @override
  String challengeXOnlyAcceptsChallengesFromFriends(String param) {
    return '$param prihvata samo izazove od prijatelja.';
  }

  @override
  String get challengeDeclineGeneric => 'Trenutno ne prihvatam izazove.';

  @override
  String get challengeDeclineLater => 'Ne odgovara mi ovaj trenutak; molim, izazovite me ponovo kasnije.';

  @override
  String get challengeDeclineTooFast => 'Ova kontrola vremena je prebrza za mene, molim vas ponovo izazovite sporijom igrom.';

  @override
  String get challengeDeclineTooSlow => 'Ova kontrola vremena je prespora za mene, molim vas ponovo izazovite bržom igrom.';

  @override
  String get challengeDeclineTimeControl => 'Ne prihvatam izazove sa ovom kontrolom vremena.';

  @override
  String get challengeDeclineRated => 'Umjesto toga, pošaljite mi ocijenjeni izazov.';

  @override
  String get challengeDeclineCasual => 'Umjesto toga, pošaljite mi usputni izazov.';

  @override
  String get challengeDeclineStandard => 'Trenutno ne prihvatam varijantne izazove.';

  @override
  String get challengeDeclineVariant => 'Trenutno nisam voljan da igram ovu varijantu.';

  @override
  String get challengeDeclineNoBot => 'Ne prihvatam izazove od botova.';

  @override
  String get challengeDeclineOnlyBot => 'Prihvatam izazove samo od botova.';

  @override
  String get challengeInviteLichessUser => 'Ili pozovite korisnika Lichessa:';

  @override
  String get contactContact => 'Kontakti';

  @override
  String get contactContactLichess => 'Kontaktirajte Lichess';

  @override
  String get patronDonate => 'Donirajte';

  @override
  String get patronLichessPatron => 'Lichess Pokrovitelj';

  @override
  String perfStatPerfStats(String param) {
    return '$param statistika';
  }

  @override
  String get perfStatViewTheGames => 'Pregledajte partije';

  @override
  String get perfStatProvisional => 'privremen';

  @override
  String get perfStatNotEnoughRatedGames => 'Nije odigrano dovoljno partija za retjing bodove da bi se uspostavio pouzdani rejting.';

  @override
  String perfStatProgressOverLastXGames(String param) {
    return 'Napredak u poslednjih $param partija:';
  }

  @override
  String perfStatRatingDeviation(String param) {
    return 'Rejting devijacija: $param.';
  }

  @override
  String perfStatRatingDeviationTooltip(String param1, String param2, String param3) {
    return 'Niža vrijednost znači da je rejting stabilniji. Pri vrijednostima višim od $param1 za rejting se smatra da je privremen. Za uvrštavanje na rang-liste ova vrijednost trebala bi biti niža od $param2 (u običnom šahu) ili od $param3 (u drugim varijantama šaha).';
  }

  @override
  String get perfStatTotalGames => 'Ukupno partija';

  @override
  String get perfStatRatedGames => 'Partije za rejting bodove';

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
  String get perfStatDisconnections => 'Prekinute partije';

  @override
  String get perfStatNotEnoughGames => 'Nedovoljno partija odigrano';

  @override
  String perfStatHighestRating(String param) {
    return 'Najveći rejting: $param';
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
  String get perfStatWinningStreak => 'Pobjednički Niz';

  @override
  String get perfStatLosingStreak => 'Gubitnički Niz';

  @override
  String perfStatLongestStreak(String param) {
    return 'Najduži niz: $param';
  }

  @override
  String perfStatCurrentStreak(String param) {
    return 'Trenutni niz: $param';
  }

  @override
  String get perfStatBestRated => 'Pobjede protiv protivnika visokog rejtinga';

  @override
  String get perfStatGamesInARow => 'Broj odigranih partija u nizu';

  @override
  String get perfStatLessThanOneHour => 'Manje od jednog sata između partija';

  @override
  String get perfStatMaxTimePlaying => 'Maksimalno vrijeme provedeno igrajući';

  @override
  String get perfStatNow => 'sada';

  @override
  String get preferencesPreferences => 'Postavke';

  @override
  String get preferencesDisplay => 'Prikaz';

  @override
  String get preferencesPrivacy => 'Privatnost';

  @override
  String get preferencesNotifications => 'Obavještenja';

  @override
  String get preferencesPieceAnimation => 'Animacija figura';

  @override
  String get preferencesMaterialDifference => 'Razlika materijala';

  @override
  String get preferencesBoardHighlights => 'Označi na ploči zadnji potez i šah';

  @override
  String get preferencesPieceDestinations => 'Dostupna polja (mogući potezi i predpotezi)';

  @override
  String get preferencesBoardCoordinates => 'Oznake na ploči (A-H, 1-8)';

  @override
  String get preferencesMoveListWhilePlaying => 'Popis poteza za vrijeme partije';

  @override
  String get preferencesPgnPieceNotation => 'PGN notacija figura';

  @override
  String get preferencesChessPieceSymbol => 'Simbol šahovske figure';

  @override
  String get preferencesPgnLetter => 'PGN slovo (K, Q, R, B, N)';

  @override
  String get preferencesZenMode => 'Zen način';

  @override
  String get preferencesShowPlayerRatings => 'Pokažite igračeve ocjene';

  @override
  String get preferencesShowFlairs => 'Show player flairs';

  @override
  String get preferencesExplainShowPlayerRatings => 'Omogućuje sakrivanje svih rejtinga sa sajta da bi fokus bio na šahu. Partije i dalje mogu biti bodovane; postavka utječe samo na prikaz.';

  @override
  String get preferencesDisplayBoardResizeHandle => 'Prikažite ručicu za promjenu veličine ploče';

  @override
  String get preferencesOnlyOnInitialPosition => 'Samo na početku partije';

  @override
  String get preferencesInGameOnly => 'Samo unutar igre';

  @override
  String get preferencesChessClock => 'Sat';

  @override
  String get preferencesTenthsOfSeconds => 'Desetinke sekundi';

  @override
  String get preferencesWhenTimeRemainingLessThanTenSeconds => 'Kada je ostalo < 10 sekundi';

  @override
  String get preferencesHorizontalGreenProgressBars => 'Vodoravna zelena linija napretka';

  @override
  String get preferencesSoundWhenTimeGetsCritical => 'Zvučno upozorenje pred istek vremena';

  @override
  String get preferencesGiveMoreTime => 'Dodajte više vremena';

  @override
  String get preferencesGameBehavior => 'Način igre';

  @override
  String get preferencesHowDoYouMovePieces => 'Kako želite pomicati figure?';

  @override
  String get preferencesClickTwoSquares => 'Klikom na dva polja';

  @override
  String get preferencesDragPiece => 'Povlačenjem figure';

  @override
  String get preferencesBothClicksAndDrag => 'Na oba načina';

  @override
  String get preferencesPremovesPlayingDuringOpponentTurn => 'Potezi unaprijed (povlačenje poteza dok je još uvijek red na protivnika)';

  @override
  String get preferencesTakebacksWithOpponentApproval => 'Vraćanje poteza (ako se protivnik složi)';

  @override
  String get preferencesInCasualGamesOnly => 'Samo u prijateljskim partijama';

  @override
  String get preferencesPromoteToQueenAutomatically => 'Auto-promocija u kraljicu';

  @override
  String get preferencesExplainPromoteToQueenAutomatically => 'Držite tipku <ctrl> prilikom promocije pješaka da biste privremeno onemogućili automatsku promociju u damu';

  @override
  String get preferencesWhenPremoving => 'Kada odigram potez unaprijed';

  @override
  String get preferencesClaimDrawOnThreefoldRepetitionAutomatically => 'Automatski proglasi remi po trostrukom ponavljanju pozicije';

  @override
  String get preferencesWhenTimeRemainingLessThanThirtySeconds => 'Kada je preostalo vrijeme < 30 sekundi';

  @override
  String get preferencesMoveConfirmation => 'Potvrda poteza';

  @override
  String get preferencesExplainCanThenBeTemporarilyDisabled => 'Može se isključiti tokom partije u izborniku za tablu';

  @override
  String get preferencesInCorrespondenceGames => 'U dopisnim partijama';

  @override
  String get preferencesCorrespondenceAndUnlimited => 'Prepiska i neograničeno';

  @override
  String get preferencesConfirmResignationAndDrawOffers => 'Potvrdite predaju partije i ponudu za remi';

  @override
  String get preferencesCastleByMovingTheKingTwoSquaresOrOntoTheRook => 'Način igranja rokade';

  @override
  String get preferencesCastleByMovingTwoSquares => 'Pomicanjem kralja za dva polja';

  @override
  String get preferencesCastleByMovingOntoTheRook => 'Pomicanjem kralja na topa';

  @override
  String get preferencesInputMovesWithTheKeyboard => 'Omogućite unos poteza tastaturom';

  @override
  String get preferencesInputMovesWithVoice => 'Unesite poteze glasom';

  @override
  String get preferencesSnapArrowsToValidMoves => 'Skačite strelice na važeće poteze';

  @override
  String get preferencesSayGgWpAfterLosingOrDrawing => 'Kažite \"Dobra partija, dobro odigrano\" nakon poraza ili remija';

  @override
  String get preferencesYourPreferencesHaveBeenSaved => 'Vaše postavke su sačuvane.';

  @override
  String get preferencesScrollOnTheBoardToReplayMoves => 'Pomaknite kotačić miša na ploči da biste ponovili poteze';

  @override
  String get preferencesCorrespondenceEmailNotification => 'Dnevne obavijesti e-poštom sa spiskom Vaših dopisnih partija';

  @override
  String get preferencesNotifyStreamStart => 'Strimer ide uživo';

  @override
  String get preferencesNotifyInboxMsg => 'Nova poruka';

  @override
  String get preferencesNotifyForumMention => 'Spomenuti ste u komentaru na forumu';

  @override
  String get preferencesNotifyInvitedStudy => 'Poziv na studiju';

  @override
  String get preferencesNotifyGameEvent => 'Ažuriranja u dopisnim partijama';

  @override
  String get preferencesNotifyChallenge => 'Izazovi';

  @override
  String get preferencesNotifyTournamentSoon => 'Turnir počinje uskoro';

  @override
  String get preferencesNotifyTimeAlarm => 'Istječe vrijeme za dopisnu partiju';

  @override
  String get preferencesNotifyBell => 'Zvučno obavještenje na Lichessu';

  @override
  String get preferencesNotifyPush => 'Obavještenje na uređaju kad niste na Lichessu';

  @override
  String get preferencesNotifyWeb => 'Preglednik';

  @override
  String get preferencesNotifyDevice => 'Uređaj';

  @override
  String get preferencesBellNotificationSound => 'Zvuk obavještenja';

  @override
  String get puzzlePuzzles => 'Problemi';

  @override
  String get puzzlePuzzleThemes => 'Teme problema';

  @override
  String get puzzleRecommended => 'Preporučeno';

  @override
  String get puzzlePhases => 'Faze';

  @override
  String get puzzleMotifs => 'Motivi';

  @override
  String get puzzleAdvanced => 'Napredno';

  @override
  String get puzzleLengths => 'Dužine';

  @override
  String get puzzleMates => 'Matovi';

  @override
  String get puzzleGoals => 'Ciljevi';

  @override
  String get puzzleOrigin => 'Porijeklo';

  @override
  String get puzzleSpecialMoves => 'Specijalni potezi';

  @override
  String get puzzleDidYouLikeThisPuzzle => 'Je li Vam se svidio ovaj problem?';

  @override
  String get puzzleVoteToLoadNextOne => 'Glasajte da učitate sljedeći!';

  @override
  String get puzzleUpVote => 'Pozitivno ocijenite problem';

  @override
  String get puzzleDownVote => 'Negativno ocijenite problem';

  @override
  String get puzzleYourPuzzleRatingWillNotChange => 'Vaša ocjena slagalice se neće promijeniti. Imajte na umu da zagonetke nisu takmičenje. Vaša ocjena pomaže u odabiru najboljih zagonetki za vašu trenutnu vještinu.';

  @override
  String get puzzleFindTheBestMoveForWhite => 'Nađite najbolji potez za bijelog.';

  @override
  String get puzzleFindTheBestMoveForBlack => 'Nađite najbolji potez za crnog.';

  @override
  String get puzzleToGetPersonalizedPuzzles => 'Kako biste dobili personalizirane probleme:';

  @override
  String puzzlePuzzleId(String param) {
    return 'Problem $param';
  }

  @override
  String get puzzlePuzzleOfTheDay => 'Problem dana';

  @override
  String get puzzleDailyPuzzle => 'Problem dana';

  @override
  String get puzzleClickToSolve => 'Kliknite da riješite';

  @override
  String get puzzleGoodMove => 'Dobar potez';

  @override
  String get puzzleBestMove => 'Najbolji potez!';

  @override
  String get puzzleKeepGoing => 'Nastavite…';

  @override
  String get puzzlePuzzleSuccess => 'Uspješno!';

  @override
  String get puzzlePuzzleComplete => 'Problem završen!';

  @override
  String get puzzleByOpenings => 'Po otvorima';

  @override
  String get puzzlePuzzlesByOpenings => 'Zagonetke po otvorima';

  @override
  String get puzzleOpeningsYouPlayedTheMost => 'Otvaranja koja ste najviše igrali u ocenjenim igrama';

  @override
  String get puzzleUseFindInPage => 'Koristite \"Pronađi na stranici\" u meniju pretraživača da pronađete svoje omiljeno otvaranje!';

  @override
  String get puzzleUseCtrlF => 'Koristite Ctrl+f da pronađete svoj omiljeni otvor!';

  @override
  String get puzzleNotTheMove => 'To nije traženi potez!';

  @override
  String get puzzleTrySomethingElse => 'Pokušajte nešto drugo.';

  @override
  String puzzleRatingX(String param) {
    return 'Rejting: $param';
  }

  @override
  String get puzzleHidden => 'skriven';

  @override
  String puzzleFromGameLink(String param) {
    return 'Iz $param igre';
  }

  @override
  String get puzzleContinueTraining => 'Nastavite trening';

  @override
  String get puzzleDifficultyLevel => 'Nivo težine';

  @override
  String get puzzleNormal => 'Normalni';

  @override
  String get puzzleEasier => 'Lakši';

  @override
  String get puzzleEasiest => 'Najlakši';

  @override
  String get puzzleHarder => 'Teži';

  @override
  String get puzzleHardest => 'Najteži';

  @override
  String get puzzleExample => 'Primjer';

  @override
  String get puzzleAddAnotherTheme => 'Dodajte drugu temu';

  @override
  String get puzzleNextPuzzle => 'Sljedeći problem';

  @override
  String get puzzleJumpToNextPuzzleImmediately => 'Odmah skočite na sljedeći problem';

  @override
  String get puzzlePuzzleDashboard => 'Kontrolna tabla za probleme';

  @override
  String get puzzleImprovementAreas => 'Područja za poboljšanje';

  @override
  String get puzzleStrengths => 'Jake strane';

  @override
  String get puzzleHistory => 'Istorija slagalice';

  @override
  String get puzzleSolved => 'riješeno';

  @override
  String get puzzleFailed => 'nepravilno';

  @override
  String get puzzleStreakDescription => 'Rješavajte progresivno teže probleme i napravite niz pobjeda. Nema vremenskog ograničenja, pa uzmite vremena. Jedan pogrešan potez i igra je gotova! No, možete preskočiti jedan potez po sesiji.';

  @override
  String puzzleYourStreakX(String param) {
    return 'Vaš niz: $param';
  }

  @override
  String get puzzleStreakSkipExplanation => 'Preskočite ovaj potez da sačuvate niz! To možete samo jednom po rundi.';

  @override
  String get puzzleContinueTheStreak => 'Nastavite niz';

  @override
  String get puzzleNewStreak => 'Novi niz';

  @override
  String get puzzleFromMyGames => 'Iz mojih partija';

  @override
  String get puzzleLookupOfPlayer => 'Potražite probleme u igračevim partijama';

  @override
  String puzzleFromXGames(String param) {
    return 'Problemi iz partija $param';
  }

  @override
  String get puzzleSearchPuzzles => 'Pretražite probleme';

  @override
  String get puzzleFromMyGamesNone => 'Nemate probleme u bazi podataka, ali Vas Lichess i dalje mnogo voli.\nIgrajte ubrzani i klasični šah kako biste povećali šanse da bude dodan Vaš problem!';

  @override
  String puzzleFromXGamesFound(String param1, String param2) {
    return 'Pronađeno $param1 problema u partijama $param2';
  }

  @override
  String get puzzlePuzzleDashboardDescription => 'Trenirajte, analizirajte, usavršavajte se';

  @override
  String puzzlePercentSolved(String param) {
    return '$param riješeno';
  }

  @override
  String get puzzleNoPuzzlesToShow => 'Ništa za pokazati, idite prvo da igrate neke zagonetke!';

  @override
  String get puzzleImprovementAreasDescription => 'Trenirajte ove da biste usavršili svoj napredak!';

  @override
  String get puzzleStrengthDescription => 'U ovim temama najbolje učestvujete';

  @override
  String puzzlePlayedXTimes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Igrano $count puta',
      few: 'Igrano $count puta',
      one: 'Igrano $count put',
    );
    return '$_temp0';
  }

  @override
  String puzzleNbPointsBelowYourPuzzleRating(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count bodova ispod vašeg rejtinga u problemima',
      few: '$count boda ispod vašeg rejtinga u problemima',
      one: 'Bod ispod vašeg rejtinga u problemima',
    );
    return '$_temp0';
  }

  @override
  String puzzleNbPointsAboveYourPuzzleRating(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count bodova iznad vašeg rejtinga u problemima',
      few: '$count boda iznad vašeg rejtinga u problemima',
      one: 'Bod iznad vašeg rejtinga u problemima',
    );
    return '$_temp0';
  }

  @override
  String puzzleNbPlayed(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count igrano',
      few: '$count igrane',
      one: '$count igrana',
    );
    return '$_temp0';
  }

  @override
  String puzzleNbToReplay(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count da ponovite',
      few: '$count da ponovite',
      one: '$count da ponovite',
    );
    return '$_temp0';
  }

  @override
  String get puzzleThemeAdvancedPawn => 'Napredni pijun';

  @override
  String get puzzleThemeAdvancedPawnDescription => 'Jedan od vaših pijuna je duboko u poziciji protivnika, možda prijeti promocijom.';

  @override
  String get puzzleThemeAdvantage => 'Prednost';

  @override
  String get puzzleThemeAdvantageDescription => 'Iskoristite svoju šansu da ostvarite odlučujuću prednost. (200cp ≤ eval ≤ 600cp)';

  @override
  String get puzzleThemeAnastasiaMate => 'Anastasijin mat';

  @override
  String get puzzleThemeAnastasiaMateDescription => 'Skakač se udružuje s topom ili damom kako bi zarobili protivničkog kralja između ivice table i prijateljske figure.';

  @override
  String get puzzleThemeArabianMate => 'Arapski mat';

  @override
  String get puzzleThemeArabianMateDescription => 'Vitez i top se udružuju da zarobe protivničkog kralja na uglu ploče.';

  @override
  String get puzzleThemeAttackingF2F7 => 'Napada f2 ili f7';

  @override
  String get puzzleThemeAttackingF2F7Description => 'Napad fokusiran na pješaka f2 ili f7, kao što je otvor pržene jetre.';

  @override
  String get puzzleThemeAttraction => 'Atrakcija';

  @override
  String get puzzleThemeAttractionDescription => 'Razmjena ili žrtvovanje kojim se ohrabruje ili tjera protivnička figura na polje koja omogućava taktiku praćenja.';

  @override
  String get puzzleThemeBackRankMate => 'Mat na posljednjem redu';

  @override
  String get puzzleThemeBackRankMateDescription => 'Matirajte kralja na njegovom početnom redu kad je zarobljen od vlastitih figura.';

  @override
  String get puzzleThemeBishopEndgame => 'Lovačka završnica';

  @override
  String get puzzleThemeBishopEndgameDescription => 'Lovačko-pješačka završnica.';

  @override
  String get puzzleThemeBodenMate => 'Bodenov mat';

  @override
  String get puzzleThemeBodenMateDescription => 'Dva napadačka biskupa na ukrštenim dijagonalama isporučuju partnera kralju spriječenom prijateljskim figurama.';

  @override
  String get puzzleThemeCastling => 'Rokada';

  @override
  String get puzzleThemeCastlingDescription => 'Sklonite kralja na sigurno i razvijte topa za napad.';

  @override
  String get puzzleThemeCapturingDefender => 'Uzmite figuru koja brani drugu';

  @override
  String get puzzleThemeCapturingDefenderDescription => 'Uklanjanje figure koja je ključna za odbranu druge figure, što omogućuje da sada nebranjena figura bude uzeta u sljedećem potezu.';

  @override
  String get puzzleThemeCrushing => 'Uništavanje';

  @override
  String get puzzleThemeCrushingDescription => 'Uočite protivnikov grubi previd kako biste stekli razornu prednost (≥ 600 cp)';

  @override
  String get puzzleThemeDoubleBishopMate => 'Dvostruki biskupski mat';

  @override
  String get puzzleThemeDoubleBishopMateDescription => 'Dva napadačka biskupa na susjednim dijagonalama isporučuju partnera kralju spriječenom prijateljskim figurama.';

  @override
  String get puzzleThemeDovetailMate => 'Mat lastinog repa';

  @override
  String get puzzleThemeDovetailMateDescription => 'Kraljica isporučuje partnera susjednom kralju, čija su samo dva polja za bijeg spriječena prijateljskim figurama.';

  @override
  String get puzzleThemeEquality => 'Izjednačenost';

  @override
  String get puzzleThemeEqualityDescription => 'Vratite se iz izgubljene pozicije i osigurajte remi ili izjednačenu poziciju (≤ 200 cp)';

  @override
  String get puzzleThemeKingsideAttack => 'Napad na kraljevom krilu';

  @override
  String get puzzleThemeKingsideAttackDescription => 'Napad na protivničkog kralja nakon što se on rokirao na kraljevo krilo.';

  @override
  String get puzzleThemeClearance => 'Raščišćavanje';

  @override
  String get puzzleThemeClearanceDescription => 'Potez, često s tempom, koji raščišćava polje, liniju ili dijagonalu za izvođenje taktičke ideje.';

  @override
  String get puzzleThemeDefensiveMove => 'Odbrambeni potez';

  @override
  String get puzzleThemeDefensiveMoveDescription => 'Precizan potez ili niz poteza potreban da se izbjegne gubitak materijala ili neke druge prednosti.';

  @override
  String get puzzleThemeDeflection => 'Odvlačenje';

  @override
  String get puzzleThemeDeflectionDescription => 'Potez koji odvlači protivničku figuru od obavljanja njene trenutne dužnosti, kao što je čuvanje ključnog polja.';

  @override
  String get puzzleThemeDiscoveredAttack => 'Otkriveni napad';

  @override
  String get puzzleThemeDiscoveredAttackDescription => 'Pomjeranje figure koja je dotad blokirala napad druge dalekometne figure, kao, npr., sklanjanje skakača ispred topa.';

  @override
  String get puzzleThemeDoubleCheck => 'Dvostruki šah';

  @override
  String get puzzleThemeDoubleCheckDescription => 'Šahiranje dvjema figurama istovremeno, kao rezultat otkrivenog napada, kad i otkrivena figura i ona koja ju je zaklanjala napadaju protivničkog kralja.';

  @override
  String get puzzleThemeEndgame => 'Završnica';

  @override
  String get puzzleThemeEndgameDescription => 'Taktika tokom posljednje faze partije.';

  @override
  String get puzzleThemeEnPassantDescription => 'Taktika koja uključuje pravilo \"en passant\", gdje pješak može uhvatiti protivničkog pješaka koji ga je zaobišao koristeći svoj početni potez u dva kvadrata.';

  @override
  String get puzzleThemeExposedKing => 'Izloženi kralj';

  @override
  String get puzzleThemeExposedKingDescription => 'Taktika koja uključuje mali broj figura koje brane kralja, što često dovodi do mata.';

  @override
  String get puzzleThemeFork => 'Viljuška';

  @override
  String get puzzleThemeForkDescription => 'Potez kojim pomjerena figura istovremeno napada dvije protivničke.';

  @override
  String get puzzleThemeHangingPiece => 'Viseća figura';

  @override
  String get puzzleThemeHangingPieceDescription => 'Taktika koja uključuje da je protivnička figura nebranjena ili nedovoljno branjena i slobodna za hvatanje.';

  @override
  String get puzzleThemeHookMate => 'Zakačni mat';

  @override
  String get puzzleThemeHookMateDescription => 'Šah-mat s topom, vitezom i pješakom zajedno s jednim neprijateljskim pješakom da ograničite bijeg neprijateljskog kralja.';

  @override
  String get puzzleThemeInterference => 'Smjetnja';

  @override
  String get puzzleThemeInterferenceDescription => 'Premještanje figura između dvije protivničke figure da jedna ili obje protivničke figure ostanu nebranjene, kao što je vitez na branjenom polju između dva topa.';

  @override
  String get puzzleThemeIntermezzo => 'Intermezzo';

  @override
  String get puzzleThemeIntermezzoDescription => 'Umjesto igranja očekivanog poteza, prvo ubacite drugi potez koji predstavlja neposrednu prijetnju na koju protivnik mora odgovoriti. Poznat i kao \"Zwischenzug\" ili \"Između\".';

  @override
  String get puzzleThemeKnightEndgame => 'Vitezova krajnica';

  @override
  String get puzzleThemeKnightEndgameDescription => 'Završno kolo sa samo vitezovima i pijunima.';

  @override
  String get puzzleThemeLong => 'Duga slagalica';

  @override
  String get puzzleThemeLongDescription => 'Tri poteza za pobjedu.';

  @override
  String get puzzleThemeMaster => 'Majstorske igre';

  @override
  String get puzzleThemeMasterDescription => 'Zagonetke iz igara koje igraju titulani igrači.';

  @override
  String get puzzleThemeMasterVsMaster => 'Igre Naprednika protiv Naprednika';

  @override
  String get puzzleThemeMasterVsMasterDescription => 'Zagonetke iz igara između dva naslovljena igrača.';

  @override
  String get puzzleThemeMate => 'Šah-mat';

  @override
  String get puzzleThemeMateDescription => 'Pobijedite igru sa stilom.';

  @override
  String get puzzleThemeMateIn1 => 'Mat u jednom';

  @override
  String get puzzleThemeMateIn1Description => 'Dajte mat u jednom potezu.';

  @override
  String get puzzleThemeMateIn2 => 'Mat u dvoje';

  @override
  String get puzzleThemeMateIn2Description => 'Dajte mat u dva poteza.';

  @override
  String get puzzleThemeMateIn3 => 'Mat u troje';

  @override
  String get puzzleThemeMateIn3Description => 'Dajte mat u tri poteza.';

  @override
  String get puzzleThemeMateIn4 => 'Mat u četvero';

  @override
  String get puzzleThemeMateIn4Description => 'Dajte mat u četiri poteza.';

  @override
  String get puzzleThemeMateIn5 => 'Mat u petero ili više';

  @override
  String get puzzleThemeMateIn5Description => 'Odredite dugi niz matanja.';

  @override
  String get puzzleThemeMiddlegame => 'Sredokolo';

  @override
  String get puzzleThemeMiddlegameDescription => 'Taktika u drugoj fazi igre.';

  @override
  String get puzzleThemeOneMove => 'Slagalica u jednom pokretu';

  @override
  String get puzzleThemeOneMoveDescription => 'Slagalica koja traje samo jedan potez.';

  @override
  String get puzzleThemeOpening => 'Otvaranje';

  @override
  String get puzzleThemeOpeningDescription => 'Taktika u prvoj fazi igre.';

  @override
  String get puzzleThemePawnEndgame => 'Pijunska krajnica';

  @override
  String get puzzleThemePawnEndgameDescription => 'Završno kolo sa samo pijunima.';

  @override
  String get puzzleThemePin => 'Značka';

  @override
  String get puzzleThemePinDescription => 'Taktika koja uključuje značke, gdje se figura ne može pomaknuti a da ne otkrije napad na figuru veće vrijednosti.';

  @override
  String get puzzleThemePromotion => 'Promaknuče';

  @override
  String get puzzleThemePromotionDescription => 'Promaknite jednog svog pijuna u kraljicu ili sporednu figuru.';

  @override
  String get puzzleThemeQueenEndgame => 'Kraljičina krajnica';

  @override
  String get puzzleThemeQueenEndgameDescription => 'Završno kolo sa samo kraljicama I pijunima.';

  @override
  String get puzzleThemeQueenRookEndgame => 'Završnica s damom i topom';

  @override
  String get puzzleThemeQueenRookEndgameDescription => 'Završnica samo s damama, topovima i pješacima.';

  @override
  String get puzzleThemeQueensideAttack => 'Napad sa kraljičine strane';

  @override
  String get puzzleThemeQueensideAttackDescription => 'Napad protivničkog kralja, nakon što su se bacali na kraljičinu stranu.';

  @override
  String get puzzleThemeQuietMove => 'Tihi potez';

  @override
  String get puzzleThemeQuietMoveDescription => 'Potez kojim se ne daje šah niti uzima figura, ali kojim se priprema neizbježna prijetnja u nekom kasnijem potezu.';

  @override
  String get puzzleThemeRookEndgame => 'Topovska završnica';

  @override
  String get puzzleThemeRookEndgameDescription => 'Završnica samo s topovima i pješacima.';

  @override
  String get puzzleThemeSacrifice => 'Žrtvovanje';

  @override
  String get puzzleThemeSacrificeDescription => 'Taktika kojom se kratkoročno žrtvuje materijal kako bi se kasnije ponovo stekla prednost nakon forsiranog niza poteza.';

  @override
  String get puzzleThemeShort => 'Kratki problem';

  @override
  String get puzzleThemeShortDescription => 'Pobjeda u dva poteza.';

  @override
  String get puzzleThemeSkewer => 'Ražanj';

  @override
  String get puzzleThemeSkewerDescription => 'Motiv u kojem se napada neka teška figura, čije sklanjanje od napada omogućuje uzimanje neke lahke figure koja je iza nje ili napad na nju; obratno od svezivanja.';

  @override
  String get puzzleThemeSmotheredMate => 'Ugušeni mat';

  @override
  String get puzzleThemeSmotheredMateDescription => 'Mat skakačem u poziciji kad protivnički kralj nema slobodnih polja jer je okružen (ili ugušen) vlastitim figurama.';

  @override
  String get puzzleThemeSuperGM => 'Supervelemajstorske partije';

  @override
  String get puzzleThemeSuperGMDescription => 'Problemi iz partija najboljih svjetskih igrača.';

  @override
  String get puzzleThemeTrappedPiece => 'Zarobljena figura';

  @override
  String get puzzleThemeTrappedPieceDescription => 'Figura ne može izbjeći da bude uzeta jer su joj potezi ograničeni.';

  @override
  String get puzzleThemeUnderPromotion => 'Potpromocija';

  @override
  String get puzzleThemeUnderPromotionDescription => 'Promocija pješaka u skakača, lovca ili topa.';

  @override
  String get puzzleThemeVeryLong => 'Vrlo dug problem';

  @override
  String get puzzleThemeVeryLongDescription => 'Pobjeda u četiri ili više poteza.';

  @override
  String get puzzleThemeXRayAttack => 'Rendgenski napad';

  @override
  String get puzzleThemeXRayAttackDescription => 'Figura napada ili brani polje kroz protivničku figuru.';

  @override
  String get puzzleThemeZugzwang => 'Iznudica';

  @override
  String get puzzleThemeZugzwangDescription => 'Protivnik ima ograničen broj poteza, a svaki od njih pogoršava mu poziciju.';

  @override
  String get puzzleThemeHealthyMix => 'Zdrava mješavina';

  @override
  String get puzzleThemeHealthyMixDescription => 'Svega pomalo. Ne znate šta možete očekivati, pa ostajete spremni na sve! Baš kao u pravim partijama.';

  @override
  String get puzzleThemePlayerGames => 'Igračke igre';

  @override
  String get puzzleThemePlayerGamesDescription => 'Potražite zagonetke stvorene iz vaših igara ili iz igara drugog igrača.';

  @override
  String puzzleThemePuzzleDownloadInformation(String param) {
    return 'Ove zagonetke su u javnoj domeni i mogu se preuzeti sa $param.';
  }

  @override
  String get searchSearch => 'Traži';

  @override
  String get settingsSettings => 'Postavke';

  @override
  String get settingsCloseAccount => 'Zatvorite račun';

  @override
  String get settingsManagedAccountCannotBeClosed => 'Vaš je račun pod administracijom i ne može biti zatvoren.';

  @override
  String get settingsClosingIsDefinitive => 'Zatvaranje računa je trajno! Nakon ovog koraka nema povratka. Jeste li sigurni da želite zatvoriti Vaš korisnički račun?';

  @override
  String get settingsCantOpenSimilarAccount => 'Neće vam biti dopušteno kreiranje novog računa sa istim imenom, čak i ako je veličina slova drugačija.';

  @override
  String get settingsChangedMindDoNotCloseAccount => 'Predomislio/la sam se, ne zatvarajte moj korisnički račun';

  @override
  String get settingsCloseAccountExplanation => 'Jeste li sigurni da želite zatvoriti Vaš korisnički račun? Zatvaranje vašeg računa je trajna odluka. Više se NIKADA nećete moći prijaviti na svoj račun.';

  @override
  String get settingsThisAccountIsClosed => 'Ovaj račun je zatvoren.';

  @override
  String get playWithAFriend => 'Igrajte protiv prijatelja';

  @override
  String get playWithTheMachine => 'Igrajte protiv računara';

  @override
  String get toInviteSomeoneToPlayGiveThisUrl => 'Da bi ste pozvali nekoga na partiju, pošaljite ovaj link';

  @override
  String get gameOver => 'Partija je gotova';

  @override
  String get waitingForOpponent => 'Čekanje na protivnika';

  @override
  String get orLetYourOpponentScanQrCode => 'Or let your opponent scan this QR code';

  @override
  String get waiting => 'Čekanje';

  @override
  String get yourTurn => 'Vi ste na potezu';

  @override
  String aiNameLevelAiLevel(String param1, String param2) {
    return '$param1 nivo $param2';
  }

  @override
  String get level => 'Nivo';

  @override
  String get strength => 'Jačina';

  @override
  String get toggleTheChat => 'Uključite/isključite dopisivanje';

  @override
  String get chat => 'Dopisivanje';

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
  String get randomColor => 'Slučajna boja';

  @override
  String get createAGame => 'Kreiraj partiju';

  @override
  String get whiteIsVictorious => 'Bijeli je pobjednik';

  @override
  String get blackIsVictorious => 'Crni je pobjednik';

  @override
  String get youPlayTheWhitePieces => 'Igrate bijelim figurama';

  @override
  String get youPlayTheBlackPieces => 'Igrate crnim figurama';

  @override
  String get itsYourTurn => 'Vi Ste na Potezu!';

  @override
  String get cheatDetected => 'Otkriveno varanje';

  @override
  String get kingInTheCenter => 'Kralj u centru';

  @override
  String get threeChecks => 'Tri šaha';

  @override
  String get raceFinished => 'Utrka je završena';

  @override
  String get variantEnding => 'Kraj varijacije';

  @override
  String get newOpponent => 'Novi protivnik';

  @override
  String get yourOpponentWantsToPlayANewGameWithYou => 'Vaš protivnik želi da igra novu partiju sa vama';

  @override
  String get joinTheGame => 'Pridružite se partiji';

  @override
  String get whitePlays => 'Bijeli je na potezu';

  @override
  String get blackPlays => 'Crni je na potezu';

  @override
  String get opponentLeftChoices => 'Vaš protivnik je možda napustio partiju. Možete proglasiti svoju pobjedu ili remi, ili nastaviti sa čekanjem.';

  @override
  String get forceResignation => 'Proglasite pobjedu';

  @override
  String get forceDraw => 'Proglasite remi';

  @override
  String get talkInChat => 'Ponašajte se pristojno kada se dopisujete!';

  @override
  String get theFirstPersonToComeOnThisUrlWillPlayWithYou => 'Prva osoba koja dođe na ovaj link će igrati sa vama.';

  @override
  String get whiteResigned => 'Bijeli je predao';

  @override
  String get blackResigned => 'Crni je predao';

  @override
  String get whiteLeftTheGame => 'Bijeli je napustio partiju';

  @override
  String get blackLeftTheGame => 'Crni je napustio partiju';

  @override
  String get whiteDidntMove => 'Bijeli nije odigrao potez';

  @override
  String get blackDidntMove => 'Crni nije odigrao potez';

  @override
  String get requestAComputerAnalysis => 'Zatražite računarsku analizu';

  @override
  String get computerAnalysis => 'Računarska analiza';

  @override
  String get computerAnalysisAvailable => 'Računarska analiza je dostupna';

  @override
  String get computerAnalysisDisabled => 'Računarska analiza onemogućena';

  @override
  String get analysis => 'Ploča za analizu';

  @override
  String depthX(String param) {
    return 'Dubina $param';
  }

  @override
  String get usingServerAnalysis => 'Koristi se serverska analiza';

  @override
  String get loadingEngine => 'Učitavanje računara ...';

  @override
  String get calculatingMoves => 'Računanje poteza...';

  @override
  String get engineFailed => 'Greška pri učitavanju programa';

  @override
  String get cloudAnalysis => 'Analiza u oblaku';

  @override
  String get goDeeper => 'Idi dublje';

  @override
  String get showThreat => 'Pokaži prijetnju';

  @override
  String get inLocalBrowser => 'u lokalnom pretraživaču';

  @override
  String get toggleLocalEvaluation => 'Uključite/isključite lokalnu evaluaciju';

  @override
  String get promoteVariation => 'Promovišite varijaciju';

  @override
  String get makeMainLine => 'Napravi glavnu liniju';

  @override
  String get deleteFromHere => 'Izbrišite od ovog poteza';

  @override
  String get collapseVariations => 'Collapse variations';

  @override
  String get expandVariations => 'Expand variations';

  @override
  String get forceVariation => 'Forsirajte varijaciju';

  @override
  String get copyVariationPgn => 'Copy variation PGN';

  @override
  String get move => 'Potez';

  @override
  String get variantLoss => 'Gubitnički potez';

  @override
  String get variantWin => 'Pobjednički potez';

  @override
  String get insufficientMaterial => 'Nedovoljno materijala';

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
  String get drawn => 'Remi';

  @override
  String get unknown => 'Nepoznat ishod';

  @override
  String get database => 'Baza podataka';

  @override
  String get whiteDrawBlack => 'Bijeli / Remi / Crni';

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
    return 'Dva miliona OTB partija igranih od $param1+ FIDE rangiranih igrača u periodu od $param2 do $param3 godine';
  }

  @override
  String get dtzWithRounding => 'DTZ50\'\' sa zaokruživanjem, na osnovi broja polu-poteza do idućeg uzimanja figure ili poteza sa pijunom';

  @override
  String get noGameFound => 'Nije pronađena nijedna partija';

  @override
  String get maxDepthReached => 'Dostignuta maksimalna dubina!';

  @override
  String get maybeIncludeMoreGamesFromThePreferencesMenu => 'Možda da probate uključiti više partija u postavkama pretraživača otvaranja?';

  @override
  String get openings => 'Otvaranja';

  @override
  String get openingExplorer => 'Pretraživač otvaranja';

  @override
  String get openingEndgameExplorer => 'Istraživač otvaranja/završnica';

  @override
  String xOpeningExplorer(String param) {
    return '$param pretraživač otvaranja';
  }

  @override
  String get playFirstOpeningEndgameExplorerMove => 'Odigrajte prvi potez u pretraživaču za otvaranja / završnice';

  @override
  String get winPreventedBy50MoveRule => 'Pobjeda spriječena zbog pravila o 50 poteza bez pomjeranja ijednog pješaka i bez ikakvog uzimanja figura';

  @override
  String get lossSavedBy50MoveRule => 'Poraz spriječen zbog pravila o 50 poteza bez pomjeranja ijednog pješaka i bez ikakvog uzimanja figura';

  @override
  String get winOr50MovesByPriorMistake => 'Pobjeda ili pravilo 50 poteza zbog prijašnje greške';

  @override
  String get lossOr50MovesByPriorMistake => 'Poraz ili pravilo 50 poteza zbog prijašnje greške';

  @override
  String get unknownDueToRounding => 'Pobjeda/poraz garantovani jedino ako se pratila preporučena linija iz baze podataka od zadnjeg uzimanja figure ili poteza pijuna, zbog mogućeg zaokruživanja DTZ vrijednosti u Syzygy bazi podataka.';

  @override
  String get allSet => 'Sve spremno!';

  @override
  String get importPgn => 'Unesi PGN';

  @override
  String get delete => 'Izbriši';

  @override
  String get deleteThisImportedGame => 'Želite li izbrisati ovu unesenu partiju?';

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
  String get showVariationArrows => 'Prikaži strelice za varijante';

  @override
  String get evaluationGauge => 'Mjerilo evaluacije';

  @override
  String get multipleLines => 'Više varijacija';

  @override
  String get cpus => 'Procesora';

  @override
  String get memory => 'Memorija';

  @override
  String get infiniteAnalysis => 'Neprekidna analiza';

  @override
  String get removesTheDepthLimit => 'Uklanja granicu do koje računar može analizirati, i održava toplinu računara';

  @override
  String get engineManager => 'Upravitelj šahovskog programa';

  @override
  String get blunder => 'Grubi previd';

  @override
  String get mistake => 'Greška';

  @override
  String get inaccuracy => 'Nepreciznost';

  @override
  String get moveTimes => 'Vrijeme za potez';

  @override
  String get flipBoard => 'Okrenite ploču';

  @override
  String get threefoldRepetition => 'Trostruko ponavljanje pozicije';

  @override
  String get claimADraw => 'Proglasite remi';

  @override
  String get offerDraw => 'Ponudite remi';

  @override
  String get draw => 'Remi';

  @override
  String get drawByMutualAgreement => 'Remi po dogovoru';

  @override
  String get fiftyMovesWithoutProgress => 'Pedeset poteza bez napretka';

  @override
  String get currentGames => 'Partije u toku';

  @override
  String get viewInFullSize => 'Pogledajte u punoj veličini';

  @override
  String get logOut => 'Odjava';

  @override
  String get signIn => 'Prijava';

  @override
  String get rememberMe => 'Zapamti me';

  @override
  String get youNeedAnAccountToDoThat => 'Treba Vam korisnički račun da biste to uradili';

  @override
  String get signUp => 'Registrujte se';

  @override
  String get computersAreNotAllowedToPlay => 'Računarima i igračima koji koriste pomoć računara nije dozvoljeno igrati. Molimo Vas da ne koristite pomoć šahovskih programa, baza podataka ili drugih igrača dok igrate. Takođe, korištenje više korisničkih računa se strogo kontroliše i pretjerano njihovo korištenje vodi blokadi svih računa.';

  @override
  String get games => 'Partije';

  @override
  String get forum => 'Forum';

  @override
  String xPostedInForumY(String param1, String param2) {
    return '$param1 je pisao u forumskoj temi $param2';
  }

  @override
  String get latestForumPosts => 'Najnovije objave na forumu';

  @override
  String get players => 'Igrači';

  @override
  String get friends => 'Prijatelji';

  @override
  String get discussions => 'Diskusije';

  @override
  String get today => 'Danas';

  @override
  String get yesterday => 'Juče';

  @override
  String get minutesPerSide => 'Minuta po igraču';

  @override
  String get variant => 'Varijanta';

  @override
  String get variants => 'Varijante';

  @override
  String get timeControl => 'Vremenska kontrola';

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
  String get usernameOrEmail => 'Korisničko ime ili e-mail';

  @override
  String get changeUsername => 'Promijeni korisničko ime';

  @override
  String get changeUsernameNotSame => 'Jedino se veličina slova može promijeniti. Na primjer, \'\'johndoe\'\' u \'\'JohnDoe\'\'.';

  @override
  String get changeUsernameDescription => 'Promijenite korisničko ime. Ovo možete učiniti samo jednom i samo možete promijeniti veličinu slova svog korisničkog imena.';

  @override
  String get signupUsernameHint => 'Odaberite pristojno korisničko ime. Kasnije ga ne možete promijeniti, a bilo koji račun s neprimjerenim korisničkim imenom bit će zatvoren!';

  @override
  String get signupEmailHint => 'Koristit ćemo ga samo za ponovno postavljanje lozinke.';

  @override
  String get password => 'Lozinka';

  @override
  String get changePassword => 'Promijeni lozinku';

  @override
  String get changeEmail => 'Promijenite e-mail';

  @override
  String get email => 'E-mail';

  @override
  String get passwordReset => 'Resetujte lozinku';

  @override
  String get forgotPassword => 'Zaboravio/la si lozinku?';

  @override
  String get error_weakPassword => 'Ova lozinka izuzetno je česta i prelahka za pogađanje.';

  @override
  String get error_namePassword => 'Molimo da ne upotrebljavate Vaše korisničko ime kao lozinku.';

  @override
  String get blankedPassword => 'Upotrijebili ste istu lozinku na drugom sajtu, a taj je sajt kompromitiran. Da bismo omogućili sigurnost Vašeg računa na Lichessu, trebate postaviti novu lozinku. Hvala na razumijevanju.';

  @override
  String get youAreLeavingLichess => 'Napuštate Lichess';

  @override
  String get neverTypeYourPassword => 'Nikada nemojte unijeti Vašu lozinku za Lichess na nekom drugom sajtu!';

  @override
  String proceedToX(String param) {
    return 'Idite na $param';
  }

  @override
  String get passwordSuggestion => 'Nemojte postavljati lozinku koju je predložio netko drugi. Mogu je iskoristiti za krađu vašeg računa.';

  @override
  String get emailSuggestion => 'Nemojte postavljati e-mail adresu koju je predložio netko drugi. Mogu je iskoristiti za krađu vašeg računa.';

  @override
  String get emailConfirmHelp => 'Pomoć za potvrdu e-pošte';

  @override
  String get emailConfirmNotReceived => 'Niste primili e-poštu za potvrdu nakon prijavljivanja?';

  @override
  String get whatSignupUsername => 'Koje ste korisničko ime upotrijebili za prijavu?';

  @override
  String usernameNotFound(String param) {
    return 'Nismo mogli pronaći nijednog korisnika pod ovim imenom: $param.';
  }

  @override
  String get usernameCanBeUsedForNewAccount => 'Možete upotrijebiti ovo korisničko ime da napravite novi račun';

  @override
  String emailSent(String param) {
    return 'Poslali smo e-poštu na $param.';
  }

  @override
  String get emailCanTakeSomeTime => 'Može potrajati neko vrijeme dok stigne.';

  @override
  String get refreshInboxAfterFiveMinutes => 'Pričekajte pet minuta i osvježite pristiglu poštu.';

  @override
  String get checkSpamFolder => 'Također provjerite neželjenu poštu, možda je poruka završila tamo. Ako jest, označite da nije neželjena.';

  @override
  String get emailForSignupHelp => 'Ako ništa drugo ne uspije, pošaljite nam ovu poruku:';

  @override
  String copyTextToEmail(String param) {
    return 'Kopirajte i zalijepite gornji tekst i pošaljite ga $param';
  }

  @override
  String get waitForSignupHelp => 'Ubrzo ćemo Vam se javiti i pomoći Vam da završite Vašu registraciju.';

  @override
  String accountConfirmed(String param) {
    return 'Korisnik $param uspješno je potvrđen.';
  }

  @override
  String accountCanLogin(String param) {
    return 'Možete se prijaviti odmah kao $param.';
  }

  @override
  String get accountConfirmationEmailNotNeeded => 'Nije Vam potrebna e-poruka za potvrdu.';

  @override
  String accountClosed(String param) {
    return 'Račun $param zatvoren je.';
  }

  @override
  String accountRegisteredWithoutEmail(String param) {
    return 'Račun $param registriran je bez e-pošte.';
  }

  @override
  String get rank => 'Rang';

  @override
  String rankX(String param) {
    return 'Rang: $param';
  }

  @override
  String get gamesPlayed => 'Odigrane partije';

  @override
  String get cancel => 'Odustani';

  @override
  String get whiteTimeOut => 'Isteklo vrijeme bijelome';

  @override
  String get blackTimeOut => 'Isteklo vrijeme crnome';

  @override
  String get drawOfferSent => 'Ponuda za remi poslana';

  @override
  String get drawOfferAccepted => 'Ponuda za remi prihvaćena';

  @override
  String get drawOfferCanceled => 'Ponuda za remi povučena';

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
  String get abortGame => 'Otkažite partiju';

  @override
  String get gameAborted => 'Partija otkazana';

  @override
  String get standard => 'Standardna';

  @override
  String get customPosition => 'Custom position';

  @override
  String get unlimited => 'Neograničeno';

  @override
  String get mode => 'Tip';

  @override
  String get casual => 'Prijateljska';

  @override
  String get rated => 'Za rejting bodove';

  @override
  String get casualTournament => 'Prijateljska';

  @override
  String get ratedTournament => 'Za rejting bodove';

  @override
  String get thisGameIsRated => 'Ovo partija je za rejting bodove';

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
  String get viewRematch => 'Pogledajte revanš';

  @override
  String get confirmMove => 'Potvrdite potez';

  @override
  String get play => 'Igraj';

  @override
  String get inbox => 'Dolazna pošta';

  @override
  String get chatRoom => 'Soba za dopisivanje';

  @override
  String get loginToChat => 'Prijavite se za dopisivanje';

  @override
  String get youHaveBeenTimedOut => 'Trenutno se ne možete dopisivati.';

  @override
  String get spectatorRoom => 'Soba za gledatelje';

  @override
  String get composeMessage => 'Napiši poruku';

  @override
  String get subject => 'Tema';

  @override
  String get send => 'Pošaljite';

  @override
  String get incrementInSeconds => 'Dodatak u sekundama';

  @override
  String get freeOnlineChess => 'Besplatni Internetski Šah';

  @override
  String get exportGames => 'Izvezite odigrane partije';

  @override
  String get ratingRange => 'Raspon rejtinga';

  @override
  String get thisAccountViolatedTos => 'Korisnik ovog računa prekršio je Lichessove uvjete korištenja';

  @override
  String get openingExplorerAndTablebase => 'Pretraživač otvaranja & baza pozicija u završnici';

  @override
  String get takeback => 'Vratite potez';

  @override
  String get proposeATakeback => 'Predložite vraćanje poteza';

  @override
  String get takebackPropositionSent => 'Prijedlog za vraćanje poteza poslan';

  @override
  String get takebackPropositionDeclined => 'Prijedlog za vraćanje poteza odbijen';

  @override
  String get takebackPropositionAccepted => 'Prijedlog za vraćanje poteza prihvaćen';

  @override
  String get takebackPropositionCanceled => 'Prijedlog za vraćanje poteza otkazan';

  @override
  String get yourOpponentProposesATakeback => 'Vaš protivnik predlaže vraćanje poteza';

  @override
  String get bookmarkThisGame => 'Zabilježite partiju';

  @override
  String get tournament => 'Turnir';

  @override
  String get tournaments => 'Turniri';

  @override
  String get tournamentPoints => 'Turnirski bodovi';

  @override
  String get viewTournament => 'Pogledajte turnir';

  @override
  String get backToTournament => 'Povratak na turnir';

  @override
  String get noDrawBeforeSwissLimit => 'Ne možete ponuditi remi u turniru po švicarskom sistemu prije nego što bude odigrano 30 poteza.';

  @override
  String get thematic => 'Tematski';

  @override
  String yourPerfRatingIsProvisional(String param) {
    return 'Vaš $param rejting je privremen';
  }

  @override
  String yourPerfRatingIsTooHigh(String param1, String param2) {
    return 'Vaš $param1 rejting ($param2) je previsok';
  }

  @override
  String yourTopWeeklyPerfRatingIsTooHigh(String param1, String param2) {
    return 'Vaš najviši sedmični $param1 rejting ($param2) je previsok';
  }

  @override
  String yourPerfRatingIsTooLow(String param1, String param2) {
    return 'Vaš $param1 rejting ($param2) je prenizak';
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
    return 'Morate biti u timu $param';
  }

  @override
  String youAreNotInTeam(String param) {
    return 'Niste u timu $param';
  }

  @override
  String get backToGame => 'Natrag na partiju';

  @override
  String get siteDescription => 'Besplatni internetski šah. Igrajte odmah u jednostavnom interfejsu. Registracija nije obavezna, nema reklama i ne trebaju nikakvi dodaci za vaš pretraživač. Igrajte šah protiv računara, prijatelja ili slučajno odabranih protivnika.';

  @override
  String xJoinedTeamY(String param1, String param2) {
    return '$param1 se pridružio timu $param2';
  }

  @override
  String xCreatedTeamY(String param1, String param2) {
    return '$param1 je osnovao tim $param2';
  }

  @override
  String get startedStreaming => 'počeo emitovanje';

  @override
  String xStartedStreaming(String param) {
    return '$param počeo/la emitovanje';
  }

  @override
  String get averageElo => 'Prosječni rejting';

  @override
  String get location => 'Lokacija';

  @override
  String get filterGames => 'Filtriraj partije';

  @override
  String get reset => 'Resetujte postavke na originalne';

  @override
  String get apply => 'Primijeni';

  @override
  String get save => 'Sačuvaj';

  @override
  String get leaderboard => 'Tabela rezultata';

  @override
  String get screenshotCurrentPosition => 'Snimite ekran s trenutnom pozicijom';

  @override
  String get gameAsGIF => 'Sačuvati kao GIF';

  @override
  String get pasteTheFenStringHere => 'Zalijepi FEN tekst ovdje';

  @override
  String get pasteThePgnStringHere => 'Zalijepi PGN tekst ovdje';

  @override
  String get orUploadPgnFile => 'Ili postavite PGN datoteku';

  @override
  String get fromPosition => 'Od pozicije';

  @override
  String get continueFromHere => 'Nastavite odavde';

  @override
  String get toStudy => 'Prostudiraj';

  @override
  String get importGame => 'Unesite partiju';

  @override
  String get importGameExplanation => 'Kada zalijepite PGN neke partije, dobijate reprizu partije koju možete detaljno pregledati, \nračunarsku analizu, mogućnost dopisivanja i link za slanje drugima.';

  @override
  String get importGameCaveat => 'Varijante će biti izbrisane. Da ih sačuvate, uvezite PGN posredstvom studije.';

  @override
  String get importGameDataPrivacyWarning => 'This PGN can be accessed by the public. To import a game privately, use a study.';

  @override
  String get thisIsAChessCaptcha => 'Ovo je šahovski CAPTCHA.';

  @override
  String get clickOnTheBoardToMakeYourMove => 'Kliknite na ploču, povucite potez i dokažite da ste čovjek.';

  @override
  String get captcha_fail => 'Molimo riješite šahovski Captcha.';

  @override
  String get notACheckmate => 'Nije mat';

  @override
  String get whiteCheckmatesInOneMove => 'Bijeli matira u jednom potezu';

  @override
  String get blackCheckmatesInOneMove => 'Crni matira u jednom potezu';

  @override
  String get retry => 'Pokušajte ponovo';

  @override
  String get reconnecting => 'Ponovno spajanje';

  @override
  String get noNetwork => 'Offline';

  @override
  String get favoriteOpponents => 'Omiljeni protivnici';

  @override
  String get follow => 'Pratite';

  @override
  String get following => 'Pratite';

  @override
  String get unfollow => 'Prestanite pratiti';

  @override
  String followX(String param) {
    return 'Prati $param';
  }

  @override
  String unfollowX(String param) {
    return 'Prestani pratiti $param';
  }

  @override
  String get block => 'Blokirajte';

  @override
  String get blocked => 'Blokiran';

  @override
  String get unblock => 'Odblokiraj';

  @override
  String get followsYou => 'Prati vas';

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
  String get required => 'Obavezno.';

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
  String get conditionOfEntry => 'Uslov za učestvovanje:';

  @override
  String get advancedSettings => 'Napredne postavke';

  @override
  String get safeTournamentName => 'Odaberite vrlo siguran naziv za turnir.';

  @override
  String get inappropriateNameWarning => 'Sve što je imalo neprikladno može dovesti do trajnog zatvaranja vašeg profila.';

  @override
  String get emptyTournamentName => 'Ako ostavite prazno, turnir će se nazvati po slučajno odabranom šahovskom igraču.';

  @override
  String get makePrivateTournament => 'Učinite turnir privatnim i ograničite pristup lozinkom';

  @override
  String get join => 'Pridružite se';

  @override
  String get withdraw => 'Odustanite';

  @override
  String get points => 'Bodovi';

  @override
  String get wins => 'Pobjede';

  @override
  String get losses => 'Porazi';

  @override
  String get createdBy => 'Kreirao/la';

  @override
  String get tournamentIsStarting => 'Turnir počinje';

  @override
  String get tournamentPairingsAreNowClosed => 'Turnirska uparivanja su završena.';

  @override
  String standByX(String param) {
    return 'Pričekajte $param, uparivanje igrača je u toku, pripremite se za igru!';
  }

  @override
  String get pause => 'Pauza';

  @override
  String get resume => 'Nastavite';

  @override
  String get youArePlaying => 'Igrate!';

  @override
  String get winRate => 'Postotak pobjeda';

  @override
  String get berserkRate => 'Postotak berserka';

  @override
  String get performance => 'Performans';

  @override
  String get tournamentComplete => 'Turnir završen';

  @override
  String get movesPlayed => 'Poteza odigrano';

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
  String get boardEditor => 'Namjestite ploču';

  @override
  String get setTheBoard => 'Postavite ploču';

  @override
  String get popularOpenings => 'Popularna otvaranja';

  @override
  String get endgamePositions => 'Završne pozicije';

  @override
  String chess960StartPosition(String param) {
    return 'Početna pozicija u šahu 960: $param';
  }

  @override
  String get startPosition => 'Početna pozicija';

  @override
  String get clearBoard => 'Očistite ploču';

  @override
  String get loadPosition => 'Učitajte poziciju';

  @override
  String get isPrivate => 'Privatno';

  @override
  String reportXToModerators(String param) {
    return 'Prijavi $param moderatorima';
  }

  @override
  String profileCompletion(String param) {
    return 'Profil je $param završen';
  }

  @override
  String xRating(String param) {
    return '$param rejting';
  }

  @override
  String get ifNoneLeaveEmpty => 'Ako nemate rejting, ostavite polje prazno';

  @override
  String get profile => 'Profil';

  @override
  String get editProfile => 'Uredite profil';

  @override
  String get realName => 'Real name';

  @override
  String get setFlair => 'Set your flair';

  @override
  String get flair => 'Flair';

  @override
  String get youCanHideFlair => 'There is a setting to hide all user flairs across the entire site.';

  @override
  String get biography => 'Biografija';

  @override
  String get countryRegion => 'Country or region';

  @override
  String get thankYou => 'Hvala!';

  @override
  String get socialMediaLinks => 'Linkovi na društvene mreže';

  @override
  String get oneUrlPerLine => 'Jedan link po redu.';

  @override
  String get inlineNotation => 'Kompaktnija notacija';

  @override
  String get makeAStudy => 'Radi čuvanja i dijeljenja razmislite o izradi studije.';

  @override
  String get clearSavedMoves => 'Očistite poteze';

  @override
  String get previouslyOnLichessTV => 'Prethodno na Lichess TV-u';

  @override
  String get onlinePlayers => 'Online igrači';

  @override
  String get activePlayers => 'Aktivni igrači';

  @override
  String get bewareTheGameIsRatedButHasNoClock => 'Oprez, igra se za rejting bodove, ali bez ograničenog vremena!';

  @override
  String get success => 'Uspjeh';

  @override
  String get automaticallyProceedToNextGameAfterMoving => 'Automatski prebaci na narednu partiju nakon odigranog poteza';

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
  String get descPrivateHelp => 'Tekst koji će vidjeti samo članovi tima. Ako se postavi, mijenja javni opis za članove tima.';

  @override
  String get no => 'Ne';

  @override
  String get yes => 'Da';

  @override
  String get help => 'Pomoć:';

  @override
  String get createANewTopic => 'Kreirajte novu temu';

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
  String get createTheTopic => 'Kreirajte temu';

  @override
  String get reportAUser => 'Prijavite korisnika';

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
  String get reportDescriptionHelp => 'Zalijepite link na partiju ili partije u pitanju i objasnite što nije bilo u redu sa ponašanjem korisnika. Nemojte samo reći \"varao je\", nego objasnite kako ste došli do tog zaključka. Vaša prijava će biti brže obrađena ukoliko je napišete na engleskom jeziku.';

  @override
  String get error_provideOneCheatedGameLink => 'Molimo navedite barem jedan link na partiju u kojoj je igrač varao.';

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
  String get notes => 'Bilješke';

  @override
  String get typePrivateNotesHere => 'Ovdje upišite privatne bilješke';

  @override
  String get writeAPrivateNoteAboutThisUser => 'Napišite privatnu bilješku o ovom korisniku';

  @override
  String get noNoteYet => 'Još nema bilješki';

  @override
  String get invalidUsernameOrPassword => 'Pogrešno korisničko ime ili lozinka';

  @override
  String get incorrectPassword => 'Netačna lozinka';

  @override
  String get invalidAuthenticationCode => 'Nevažeći kod pri provjeri autentičnosti';

  @override
  String get emailMeALink => 'Pošaljite mi link e-mail porukom';

  @override
  String get currentPassword => 'Trenutna lozinka';

  @override
  String get newPassword => 'Nova lozinka';

  @override
  String get newPasswordAgain => 'Ponovi novu lozinku';

  @override
  String get newPasswordsDontMatch => 'Nove se lozinke ne podudaraju';

  @override
  String get newPasswordStrength => 'Jačina lozinke';

  @override
  String get clockInitialTime => 'Početno vrijeme sata';

  @override
  String get clockIncrement => 'Dodatak satu';

  @override
  String get privacy => 'Privatnost';

  @override
  String get privacyPolicy => 'Politici privatnosti';

  @override
  String get letOtherPlayersFollowYou => 'Dopustite da vas drugi igrači prate';

  @override
  String get letOtherPlayersChallengeYou => 'Dopustite da vas drugi igrači izazovu';

  @override
  String get letOtherPlayersInviteYouToStudy => 'Dopustite da vas drugi igrači pozovu u studiju';

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
    return '$param1 se takmiči u $param2';
  }

  @override
  String get victory => 'Pobjeda';

  @override
  String get defeat => 'Poraz';

  @override
  String victoryVsYInZ(String param1, String param2, String param3) {
    return '$param1 protiv $param2 u $param3';
  }

  @override
  String defeatVsYInZ(String param1, String param2, String param3) {
    return '$param1 protiv $param2 u $param3';
  }

  @override
  String drawVsYInZ(String param1, String param2, String param3) {
    return '$param1 protiv $param2 u $param3';
  }

  @override
  String get timeline => 'Vremenska crta';

  @override
  String get starting => 'Počinje:';

  @override
  String get allInformationIsPublicAndOptional => 'Sve informacije su javne i neobavezne.';

  @override
  String get biographyDescription => 'Nešto više o Vama, Vašim interesima, što volite u šahu, Vaša omiljena otvaranja, omiljeni igrači ...';

  @override
  String get listBlockedPlayers => 'Popis blokiranih igrača';

  @override
  String get human => 'Osobe';

  @override
  String get computer => 'Računar';

  @override
  String get side => 'Strana';

  @override
  String get clock => 'Sat';

  @override
  String get opponent => 'Protivnik';

  @override
  String get learnMenu => 'Uči';

  @override
  String get studyMenu => 'Prostudiraj';

  @override
  String get practice => 'Vježbaj';

  @override
  String get community => 'Zajednica';

  @override
  String get tools => 'Alati';

  @override
  String get increment => 'Dodatak';

  @override
  String get error_unknown => 'Neispravne vrijednosti';

  @override
  String get error_required => 'Ovo polje je obavezno';

  @override
  String get error_email => 'Ova je adresa e-pošte nevažeća';

  @override
  String get error_email_acceptable => 'Ova adresa e-pošte nije prihvatljiva. Molimo, provjerite je i pokušajte opet.';

  @override
  String get error_email_unique => 'Adresa e-pošte nevažeća ili već zauzeta';

  @override
  String get error_email_different => 'Već koristite ovu adresu e-pošte';

  @override
  String error_minLength(String param) {
    return 'Mora sadržavati minimalno $param znakova';
  }

  @override
  String error_maxLength(String param) {
    return 'Mora sadržavati najviše $param znakova';
  }

  @override
  String error_min(String param) {
    return 'Mora biti najmanje $param';
  }

  @override
  String error_max(String param) {
    return 'Mora biti najviše $param';
  }

  @override
  String ifRatingIsPlusMinusX(String param) {
    return 'Ukoliko je rejting ± $param';
  }

  @override
  String get ifRegistered => 'Ako su registrovani';

  @override
  String get onlyExistingConversations => 'Samo već postojeći razgovori';

  @override
  String get onlyFriends => 'Samo prijatelji';

  @override
  String get menu => 'Meni';

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
  String get videoLibrary => 'Video biblioteka';

  @override
  String get streamersMenu => 'Emiteri';

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
    return '$param1 je besplatni ($param2) šah server, bez oglasa, koji koristi otvoreni kod.';
  }

  @override
  String get really => 'stvarno';

  @override
  String get contribute => 'Doprinesite';

  @override
  String get termsOfService => 'Uslovi korištenja';

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
  String get aboutSimulImage => 'Od 50 protivnika, Fischer je pobijedio 47 partija, remizirao 2 i izgubio 1.';

  @override
  String get aboutSimulRealLife => 'Koncept je preuzet iz stvarnog života. U stvarnom životu, domaćin simultanke ide od ploče do ploče da odigra pojedinačni potez.';

  @override
  String get aboutSimulRules => 'Kada simultanka započne, svaki igrač započinje partiju protiv domaćina, koji dobiva bijele figure. Simultanka se završava tek kada se završe sve partije.';

  @override
  String get aboutSimulSettings => 'Simultanke su uvijek prijateljske. Opcije za revanš, vraćanje poteza i dodavanje vremena su isključene.';

  @override
  String get create => 'Kreiraj';

  @override
  String get whenCreateSimul => 'Kada kreirate simultanku, igrate protiv više igrača istovremeno.';

  @override
  String get simulVariantsHint => 'Ako izaberete nekoliko varijanti, svaki igrač može da odabere koju varijantu želi da igra.';

  @override
  String get simulClockHint => 'Fischer podešavanje sata. Što više igrača primite, više će Vam vremena trebati.';

  @override
  String get simulAddExtraTime => 'Možete dodati više vremena na svoj sat kako bi Vam to pomoglo tokom igranja simultanke.';

  @override
  String get simulHostExtraTime => 'Dodatno vrijeme domaćina';

  @override
  String get simulAddExtraTimePerPlayer => 'Dodajte početno vrijeme na Vaš sat za svakog igrača koji se pridruži simultanci.';

  @override
  String get simulHostExtraTimePerPlayer => 'Dodatno vrijeme po igraču za domaćina simultanke';

  @override
  String get lichessTournaments => 'Lichess turniri';

  @override
  String get tournamentFAQ => 'Najčešće postavljana pitanja o Arena turnirima';

  @override
  String get timeBeforeTournamentStarts => 'Vrijeme do početka turnira';

  @override
  String get averageCentipawnLoss => 'Prosječni gubitak u stotim dijelovima pješaka';

  @override
  String get accuracy => 'Preciznost';

  @override
  String get keyboardShortcuts => 'Prečice za tastaturu';

  @override
  String get keyMoveBackwardOrForward => 'idi natrag/naprijed';

  @override
  String get keyGoToStartOrEnd => 'idi na početak/kraj';

  @override
  String get keyCycleSelectedVariation => 'Cycle selected variation';

  @override
  String get keyShowOrHideComments => 'pokaži/sakrij komentare';

  @override
  String get keyEnterOrExitVariation => 'otvori/zatvori varijaciju';

  @override
  String get keyRequestComputerAnalysis => 'Zatražite računarsku analizu, učite na svojim greškama';

  @override
  String get keyNextLearnFromYourMistakes => 'Sljedeće (Učite na svojim greškama)';

  @override
  String get keyNextBlunder => 'Sljedeći grubi previd';

  @override
  String get keyNextMistake => 'Sljedeća greška';

  @override
  String get keyNextInaccuracy => 'Sljedeća nepreciznost';

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
  String get tournamentHomeTitle => 'Šahovski turniri sa različitim vremenskim kontrolama i varijantama';

  @override
  String get tournamentHomeDescription => 'Igrajte brze turnire! Pridružite se zvaničnom turniru ili kreirajte svoj turnir. Bullet, Blitz, Klasični šah, Šah 960, Kralj u centru, Tri šaha, i još više opcija za neograničenu šahovsku zabavu.';

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
    return 'Sedmični pregled $param rejtinga';
  }

  @override
  String yourPerfTypeRatingIsRating(String param1, String param2) {
    return 'Vaš $param1 rejting je $param2.';
  }

  @override
  String youAreBetterThanPercentOfPerfTypePlayers(String param1, String param2) {
    return 'Bolji ste od $param1 od $param2 igrača.';
  }

  @override
  String userIsBetterThanPercentOfPerfTypePlayers(String param1, String param2, String param3) {
    return '$param1 je bolji od $param2 $param3 igrača.';
  }

  @override
  String betterThanPercentPlayers(String param1, String param2) {
    return 'Bolje od $param1 igrača $param2';
  }

  @override
  String youDoNotHaveAnEstablishedPerfTypeRating(String param) {
    return 'Nemate utvrđen $param rejting.';
  }

  @override
  String get yourRating => 'Vaš rejting';

  @override
  String get cumulative => 'Kumulativno';

  @override
  String get glicko2Rating => 'Glicko-2 rejting';

  @override
  String get checkYourEmail => 'Provjerite Vaš e-mail';

  @override
  String get weHaveSentYouAnEmailClickTheLink => 'Mi smo Vam poslali e-mail. Kliknite na link u e-mailu da biste aktivirali svoj račun.';

  @override
  String get ifYouDoNotSeeTheEmailCheckOtherPlaces => 'Ako ne vidite našu e-mail poruku u Vašem odijelu za dolaznu e-mail poštu, provjerite na drugim mjestima, kao što su junk i spam.';

  @override
  String weHaveSentYouAnEmailTo(String param) {
    return 'Poslali smo e-mail na $param. Kliknite na link u e-mail poruci kako biste resetovali vašu lozinku.';
  }

  @override
  String byRegisteringYouAgreeToBeBoundByOur(String param) {
    return 'Registracijom prihvatate naše $param.';
  }

  @override
  String readAboutOur(String param) {
    return 'Pročitajte o našoj $param.';
  }

  @override
  String get networkLagBetweenYouAndLichess => 'Mrežno kašnjenje između Vas i lichess-a';

  @override
  String get timeToProcessAMoveOnLichessServer => 'Vrijeme potrebno da se odigra potez na lichess serveru';

  @override
  String get downloadAnnotated => 'Preuzmite sa bilješkama';

  @override
  String get downloadRaw => 'Preuzmite bez bilješki';

  @override
  String get downloadImported => 'Preuzmite uneseno';

  @override
  String get crosstable => 'Tabela rezultata';

  @override
  String get youCanAlsoScrollOverTheBoardToMoveInTheGame => 'Možete koristiti točak od Vašeg miša da brže pređete preko poteza za vrijeme analize partije.';

  @override
  String get scrollOverComputerVariationsToPreviewThem => 'Zadržite miš na računarskim varijantama da ih pregledate.';

  @override
  String get analysisShapesHowTo => 'Pritisnite shift + lijevi ili desni klik miša kako bi ste nacrtali krugove i strelice na ploči.';

  @override
  String get letOtherPlayersMessageYou => 'Dopustite drugim igračima da Vam mogu poslati poruku';

  @override
  String get receiveForumNotifications => 'Primajte obavijesti kad budete spomenuti na forumu';

  @override
  String get shareYourInsightsData => 'Podijelite Vašu šahovsku analitiku';

  @override
  String get withNobody => 'Ni sa kime';

  @override
  String get withFriends => 'Sa prijateljima';

  @override
  String get withEverybody => 'Sa svima';

  @override
  String get kidMode => 'Dječji režim';

  @override
  String get kidModeIsEnabled => 'Kid mode is enabled.';

  @override
  String get kidModeExplanation => 'Ova opcija se nudi zbog sigurnosti. U dječjem režimu, sve komunikacije na stranici su ukinute. Omogućite ovu opciju za Vašu djecu i učenike, kako bi ste ih zaštitili od drugih internet korisnika.';

  @override
  String inKidModeTheLichessLogoGetsIconX(String param) {
    return 'U dječjem režimu, logo lichess-a dobiva $param ikonu, tako da znate da su Vaša djeca sigurna.';
  }

  @override
  String get askYourChessTeacherAboutLiftingKidMode => 'Vaš je račun pod administracijom. Upitajte Vašeg učitelja šaha o isključivanju načina za djecu.';

  @override
  String get enableKidMode => 'Uključite dječji režim';

  @override
  String get disableKidMode => 'Isključite dječji režim';

  @override
  String get security => 'Sigurnost';

  @override
  String get sessions => 'Sesije';

  @override
  String get revokeAllSessions => 'opozvati sve sesije';

  @override
  String get playChessEverywhere => 'Igrajte šah svugdje';

  @override
  String get asFreeAsLichess => 'Besplatno kao i lichess';

  @override
  String get builtForTheLoveOfChessNotMoney => 'Napravljeno iz ljubavi prema šahu, ne novcu';

  @override
  String get everybodyGetsAllFeaturesForFree => 'Svi dobijaju sve mogućnosti besplatno';

  @override
  String get zeroAdvertisement => 'Bez reklama';

  @override
  String get fullFeatured => 'Sa svim mogućnostima';

  @override
  String get phoneAndTablet => 'Mobitel i tablet';

  @override
  String get bulletBlitzClassical => 'Bullet, blitz, klasični šah';

  @override
  String get correspondenceChess => 'Dopisni šah';

  @override
  String get onlineAndOfflinePlay => 'Igrajte sa i bez mreže';

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
    return 'Vaš rezultat: $param';
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
  String get backgroundImageUrl => 'Llink pozadinske slike:';

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
  String get embedInYourWebsite => 'Ugradite u svoju internet stranicu';

  @override
  String get usernameAlreadyUsed => 'Ovo korisničko ime se već koristi, molimo probajte neko drugo.';

  @override
  String get usernamePrefixInvalid => 'Korisničko ime mora započeti sa slovom.';

  @override
  String get usernameSuffixInvalid => 'Korisničko ime mora završiti sa slovom ili brojem.';

  @override
  String get usernameCharsInvalid => 'Korisničko ime može sadržavati samo slova, brojeve, podvlake i crtice.';

  @override
  String get usernameUnacceptable => 'Ovo korisničko ime nije prihvatljivo.';

  @override
  String get playChessInStyle => 'Igrajte šah u stilu';

  @override
  String get chessBasics => 'Šahovske osnove';

  @override
  String get coaches => 'Treneri';

  @override
  String get invalidPgn => 'Neispravan PGN';

  @override
  String get invalidFen => 'Neispiravan FEN';

  @override
  String get custom => 'Prilagođeno';

  @override
  String get notifications => 'Obavijesti';

  @override
  String notificationsX(String param1) {
    return 'Obavještenja: $param1';
  }

  @override
  String perfRatingX(String param) {
    return 'Rejting: $param';
  }

  @override
  String get practiceWithComputer => 'Vježbajte sa računarom';

  @override
  String anotherWasX(String param) {
    return 'Drugi potez je bio $param';
  }

  @override
  String bestWasX(String param) {
    return 'Najbolji potez je bio $param';
  }

  @override
  String get youBrowsedAway => 'Otišli ste daleko';

  @override
  String get resumePractice => 'Nastavite vježbu';

  @override
  String get drawByFiftyMoves => 'Partija je neriješena po pravilu 50 poteza.';

  @override
  String get theGameIsADraw => 'Partija završava remijem.';

  @override
  String get computerThinking => 'Računar razmišlja ...';

  @override
  String get seeBestMove => 'Vidite najbolji potez';

  @override
  String get hideBestMove => 'Sakrijte najbolji potez';

  @override
  String get getAHint => 'Treba mi pomoć';

  @override
  String get evaluatingYourMove => 'Procjena Vašeg poteza ...';

  @override
  String get whiteWinsGame => 'Bijeli pobjeđuje';

  @override
  String get blackWinsGame => 'Crni pobjeđuje';

  @override
  String get learnFromYourMistakes => 'Naučite iz svojih grešaka';

  @override
  String get learnFromThisMistake => 'Naučite iz ove greške';

  @override
  String get skipThisMove => 'Preskočite ovaj potez';

  @override
  String get next => 'Dalje';

  @override
  String xWasPlayed(String param) {
    return '$param je odigrano';
  }

  @override
  String get findBetterMoveForWhite => 'Pronađite bolji potez za bijelog';

  @override
  String get findBetterMoveForBlack => 'Pronađite bolji potez za crnog';

  @override
  String get resumeLearning => 'Nastavite učenje';

  @override
  String get youCanDoBetter => 'Možete bolje';

  @override
  String get tryAnotherMoveForWhite => 'Probajte drugi potez za bijelog';

  @override
  String get tryAnotherMoveForBlack => 'Probajte drugi potez za crnog';

  @override
  String get solution => 'Rješenje';

  @override
  String get waitingForAnalysis => 'Analiza u toku';

  @override
  String get noMistakesFoundForWhite => 'Nisu pronađene greške bijelog';

  @override
  String get noMistakesFoundForBlack => 'Nisu pronađene greške crnog';

  @override
  String get doneReviewingWhiteMistakes => 'Završeno pregledavanje grešaka bijelog';

  @override
  String get doneReviewingBlackMistakes => 'Završeno pregledavanje grešaka crnog';

  @override
  String get doItAgain => 'Pokušajte ponovno';

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
  String get conditionalPremoves => 'Uslovni potezi unaprijed';

  @override
  String get addCurrentVariation => 'Dodajte trenutnu varijaciju';

  @override
  String get playVariationToCreateConditionalPremoves => 'Odigrajte varijaciju da stvorite uslovni potez unaprijed';

  @override
  String get noConditionalPremoves => 'Nema uslovnih poteza unaprijed';

  @override
  String playX(String param) {
    return 'Igraj $param';
  }

  @override
  String get showUnreadLichessMessage => 'You have received a private message from Lichess.';

  @override
  String get clickHereToReadIt => 'Click here to read it';

  @override
  String get sorry => 'Izvinjavamo se :(';

  @override
  String get weHadToTimeYouOutForAWhile => 'Morali smo Vam staviti privremenu zabranu na igranje.';

  @override
  String get why => 'Zašto?';

  @override
  String get pleasantChessExperience => 'Naš cilj je da svima pružimo ugodno šahovsko iskustvo.';

  @override
  String get goodPractice => 'Zbog toga, moramo osigurati da svi igrači ispravno postupaju.';

  @override
  String get potentialProblem => 'Kada se otkrije potencijalni problem, prikazujemo ovu poruku.';

  @override
  String get howToAvoidThis => 'Kako to izbjeći?';

  @override
  String get playEveryGame => 'Odigrajte svaku partiju ​​koju započnete.';

  @override
  String get tryToWin => 'Pokušajte pobijediti (ili barem izboriti neriješen rezultat) svaku partiju ​​koju igrate.';

  @override
  String get resignLostGames => 'Predajte izgubljenu partiju (ne čekajte da vrijeme istekne).';

  @override
  String get temporaryInconvenience => 'Izvinjavamo se zbog privremene neugodnosti,';

  @override
  String get wishYouGreatGames => 'i želimo Vam odlične partije na lichess.org.';

  @override
  String get thankYouForReading => 'Hvala Vam na čitanju!';

  @override
  String get lifetimeScore => 'Ukupni rezultat';

  @override
  String get currentMatchScore => 'Rezultat sadašnjeg meča';

  @override
  String get agreementAssistance => 'Slažem se da ni u jednom trenutku neću primati pomoć za vrijeme svojih igara (od šahovskog računara, knjige, baze podataka ili neke druge osobe).';

  @override
  String get agreementNice => 'Slažem se da ću uvijek poštovati druge igrače.';

  @override
  String agreementMultipleAccounts(String param) {
    return 'Slažem se da neću napraviti više računa (osim zbog razloga navedenih u $param).';
  }

  @override
  String get agreementPolicy => 'Slažem se da ću se pridržavati svih Lichess pravila.';

  @override
  String get searchOrStartNewDiscussion => 'Traži ili pokrenite novu diskusiju';

  @override
  String get edit => 'Uredite';

  @override
  String get bullet => 'Bullet';

  @override
  String get blitz => 'Blic';

  @override
  String get rapid => 'Ubrzani šah';

  @override
  String get classical => 'Klasični šah';

  @override
  String get ultraBulletDesc => 'Ludo brze partije: manje od 30 sekundi';

  @override
  String get bulletDesc => 'Vrlo brze partije: manje od tri minute';

  @override
  String get blitzDesc => 'Brze partije: od tri do osam minuta';

  @override
  String get rapidDesc => 'Ubrzane partije: od osam do 25 minuta';

  @override
  String get classicalDesc => 'Klasične partije: 25 minuta i više';

  @override
  String get correspondenceDesc => 'Dopisne partije: jedan ili više dana po potezu';

  @override
  String get puzzleDesc => 'Vježbanje šahovske taktike';

  @override
  String get important => 'Važno';

  @override
  String yourQuestionMayHaveBeenAnswered(String param1) {
    return 'Na Vaše pitanje možda već postoji odgovor $param1';
  }

  @override
  String get inTheFAQ => 'u FAQ-u';

  @override
  String toReportSomeoneForCheatingOrBadBehavior(String param1) {
    return 'Da prijavite korisnika zbog varanja ili lošeg ponašanja, $param1';
  }

  @override
  String get useTheReportForm => 'koristite formular za prijavu';

  @override
  String toRequestSupport(String param1) {
    return 'Da zatražite podršku, $param1';
  }

  @override
  String get tryTheContactPage => 'pokušajte na stranici za kontakt';

  @override
  String makeSureToRead(String param1) {
    return 'Obavezno pročitajte $param1';
  }

  @override
  String get theForumEtiquette => 'forumski bonton';

  @override
  String get thisTopicIsArchived => 'Ova je tema arhivirana i na nju se više ne može odgovarati.';

  @override
  String joinTheTeamXToPost(String param1) {
    return 'Pridružite se ${param1}u da biste objavljivali na ovom forumu';
  }

  @override
  String teamNamedX(String param1) {
    return '$param1 tim';
  }

  @override
  String get youCannotPostYetPlaySomeGames => 'Još ne možete objavljivati na forumima. Odigrajte nekoliko partija!';

  @override
  String get subscribe => 'Pretplatite se';

  @override
  String get unsubscribe => 'Odjavite pretplatu';

  @override
  String mentionedYouInX(String param1) {
    return 'spomenuo Vas je u \"$param1\".';
  }

  @override
  String xMentionedYouInY(String param1, String param2) {
    return '$param1 vas je spomenuo u \"$param2\".';
  }

  @override
  String invitedYouToX(String param1) {
    return 'vas je pozvao u \"$param1\".';
  }

  @override
  String xInvitedYouToY(String param1, String param2) {
    return '$param1 vas je pozvao u \"$param2\".';
  }

  @override
  String get youAreNowPartOfTeam => 'Sada ste dio tima.';

  @override
  String youHaveJoinedTeamX(String param1) {
    return 'Pridružili ste se \"$param1\".';
  }

  @override
  String get someoneYouReportedWasBanned => 'Neko koga ste prijavili dobio je zabranu';

  @override
  String get congratsYouWon => 'Čestitamo, pobijedili ste!';

  @override
  String gameVsX(String param1) {
    return 'Partija protiv $param1';
  }

  @override
  String resVsX(String param1, String param2) {
    return '$param1 protiv $param2';
  }

  @override
  String get lostAgainstTOSViolator => 'Izgubili ste od nekoga ko je prekršio Lichessove uvjete upotrebe';

  @override
  String refundXpointsTimeControlY(String param1, String param2) {
    return 'Povrat: $param1 $param2 rejting-bodova.';
  }

  @override
  String get timeAlmostUp => 'Vrijeme je pri kraju!';

  @override
  String get clickToRevealEmailAddress => '[Kliknite da otkrijete adresu e-pošte]';

  @override
  String get download => 'Preuzmite';

  @override
  String get coachManager => 'Postavke za trenera';

  @override
  String get streamerManager => 'Postavke za strimera';

  @override
  String get cancelTournament => 'Otkaži turnir';

  @override
  String get tournDescription => 'Opis turnira';

  @override
  String get tournDescriptionHelp => 'Postoji li nešto posebno što bi htjeli reći učesnicima? Pokušajte biti kratki.\nMarkdown linkovi su dostupni: [name](https://url)';

  @override
  String get ratedFormHelp => 'Igre se ocjenjuju\ni utječu na ocjenu igrača';

  @override
  String get onlyMembersOfTeam => 'Samo članovi tima';

  @override
  String get noRestriction => 'Bez ograničenja';

  @override
  String get minimumRatedGames => 'Minimalan broj ocijenjenih igri';

  @override
  String get minimumRating => 'Minimalna ocjena';

  @override
  String get maximumWeeklyRating => 'Maksimalna sedmična ocjena';

  @override
  String positionInputHelp(String param) {
    return 'Zalijepite važeći FEN da biste započeli svaku igru sa određene pozicije.\nRadi samo za standardne igre, ne sa vrstama.\nMožete koristiti $param za generisanje FEN pozicije, a zatim ga zalijepite ovdje.\nOstavite prazno za početak igre sa normalne početne pozicije.';
  }

  @override
  String get cancelSimul => 'Otkažite simultanku';

  @override
  String get simulHostcolor => 'Boja domaćina u svakoj igri';

  @override
  String get estimatedStart => 'Procijenuto početno vrijeme';

  @override
  String simulFeatured(String param) {
    return 'Istečaj na $param';
  }

  @override
  String simulFeaturedHelp(String param) {
    return 'Pokažite svoju simulaciju svima na $param. Onemogući za privatne simulacije.';
  }

  @override
  String get simulDescription => 'Opis simultanke';

  @override
  String get simulDescriptionHelp => 'Želite li nešto reći učesnicima?';

  @override
  String markdownAvailable(String param) {
    return '$param je dostupan za više napredniju sintaksu.';
  }

  @override
  String get embedsAvailable => 'Zalijepite URL igre ili URL poglavlja studije da biste ga ugradili.';

  @override
  String get inYourLocalTimezone => 'U vlastitoj vremenskoj zoni';

  @override
  String get tournChat => 'Turnirski razgovor';

  @override
  String get noChat => 'Nema razgovora';

  @override
  String get onlyTeamLeaders => 'Samo vođe timova';

  @override
  String get onlyTeamMembers => 'Samo članovi timova';

  @override
  String get navigateMoveTree => 'Za kretanje po premještajnom stablu';

  @override
  String get mouseTricks => 'Trikovi s mišem';

  @override
  String get toggleLocalAnalysis => 'Uključite analizu lokalnog računara';

  @override
  String get toggleAllAnalysis => 'Uključite sve računarske analize';

  @override
  String get playComputerMove => 'Igraj najbolji potez računara';

  @override
  String get analysisOptions => 'Postavke analize';

  @override
  String get focusChat => 'Usredsredi razgovor';

  @override
  String get showHelpDialog => 'Prikaži ovaj pomoćni dijalog';

  @override
  String get reopenYourAccount => 'Iznova otvorite vaš račun';

  @override
  String get closedAccountChangedMind => 'Ako ste zatvorili svoj račun, a predomislili ste se, imate jednu šansu da vratite svoj račun.';

  @override
  String get onlyWorksOnce => 'Ovo će samo jednom uspjeti.';

  @override
  String get cantDoThisTwice => 'Ako drugi put zatvorite svoj račun, nećete ga ni moći oporaviti.';

  @override
  String get emailAssociatedToaccount => 'Mejl adresa povezana s računom';

  @override
  String get sentEmailWithLink => 'Poslali smo vam mejl s vezom.';

  @override
  String get tournamentEntryCode => 'Lozinka za ulaz u turnir';

  @override
  String get hangOn => 'Stani malo!';

  @override
  String gameInProgress(String param) {
    return 'Još igrate u trenu sa $param.';
  }

  @override
  String get abortTheGame => 'Prekinite igru';

  @override
  String get resignTheGame => 'Odustanite od igre';

  @override
  String get youCantStartNewGame => 'Ne možete započeti novu igru dok se ova ne završi.';

  @override
  String get since => 'Od';

  @override
  String get until => 'Do';

  @override
  String get lichessDbExplanation => 'Odabrane bodovane partije svih igrača na Lichessu';

  @override
  String get switchSides => 'Zamijenite strane';

  @override
  String get closingAccountWithdrawAppeal => 'Zatvaranje Vašeg računa povući će Vašu žalbu';

  @override
  String get ourEventTips => 'Naši savjeti za organiziranje događajâ';

  @override
  String get instructions => 'Instructions';

  @override
  String get showMeEverything => 'Show me everything';

  @override
  String get lichessPatronInfo => 'Lichess je dobrotvorni i potpuno besplatan softver otvorenog koda.\nSvi operativni troškovi, razvoj i sadržaj finansiraju se isključivo od donacija korisnikâ.';

  @override
  String get nothingToSeeHere => 'Nothing to see here at the moment.';

  @override
  String opponentLeftCounter(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Vaš protivnik je napustio partiju. Možete proglasiti pobjedu za $count sekundi.',
      few: 'Vaš protivnik je napustio partiju. Možete proglasiti pobjedu za $count sekunde.',
      one: 'Vaš protivnik je napustio partiju. Možete proglasiti pobjedu za $count sekundu.',
    );
    return '$_temp0';
  }

  @override
  String mateInXHalfMoves(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Mat u $count poteza, računajući poteze i bijelog i crnog',
      few: 'Mat u $count poteza, računajući poteze i bijelog i crnog',
      one: 'Mat u $count potezu',
    );
    return '$_temp0';
  }

  @override
  String nbBlunders(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count velike greške',
      few: '$count velike greške',
      one: '$count velika greška',
    );
    return '$_temp0';
  }

  @override
  String nbMistakes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count greške',
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
      few: '$count partija',
      one: '$count partija',
    );
    return '$_temp0';
  }

  @override
  String ratingXOverYGames(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count rejting na osnovu $param2 partija',
      few: '$count rejting na osnovu $param2 partija',
      one: '$count rejting na osnovu $param2 partije',
    );
    return '$_temp0';
  }

  @override
  String nbBookmarks(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count zabilježenih partija',
      few: '$count zabilježenih partija',
      one: '$count zabilježena partija',
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
      few: '$count sati',
      one: '$count sat',
    );
    return '$_temp0';
  }

  @override
  String nbMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count minute',
      few: '$count minuta',
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
      few: 'Rang se ažurira svakih $count minuta',
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
      few: '$count odigranih partija s tobom',
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
      few: '$count pobjeda',
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
      other: '$count u toku',
      few: '$count u toku',
      one: '$count u toku',
    );
    return '$_temp0';
  }

  @override
  String giveNbSeconds(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Dodajte protivniku $count sekundi',
      few: 'Dodajte protivniku $count sekundi',
      one: 'Dodajte protivniku $count sekundu',
    );
    return '$_temp0';
  }

  @override
  String nbTournamentPoints(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count turnirskih bodova',
      few: '$count turnirskih bodova',
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
      other: '$count simula',
      few: '$count simula',
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
      other: 'Trebate igrati još $count više $param2 partija za rejting bodove',
      few: 'Trebate igrati još $count više $param2 partija za rejting bodove',
      one: 'Trebate igrati još $count više $param2 partiju za rejting bodove',
    );
    return '$_temp0';
  }

  @override
  String needNbMoreGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Trebate odigrati još $count partija za rejting bodove',
      few: 'Trebate odigrati još $count partija za rejting bodove',
      one: 'Trebate igrati još $count partiju za rejting bodove',
    );
    return '$_temp0';
  }

  @override
  String nbImportedGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count unesenih partija',
      few: '$count unesenih partija',
      one: '$count unesena partija',
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
      few: 'Manje od $count minuta',
      one: 'Manje od $count minute',
    );
    return '$_temp0';
  }

  @override
  String nbGamesInPlay(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count partija u toku',
      few: '$count partija u toku',
      one: '$count partija u toku',
    );
    return '$_temp0';
  }

  @override
  String maximumNbCharacters(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Maksimalno: $count znakova.',
      few: 'Maksimalno: $count znakova.',
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
      few: '$count blokiranih igrača',
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
      few: '$count forumskih poruka',
      one: '$count forumska poruka',
    );
    return '$_temp0';
  }

  @override
  String nbPerfTypePlayersThisWeek(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count $param2 igrača ove sedmice.',
      few: '$count $param2 igrača ove sedmice.',
      one: '$count $param2 igrač ove sedmice.',
    );
    return '$_temp0';
  }

  @override
  String availableInNbLanguages(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Dostupno u $count jezika!',
      few: 'Dostupno u $count jezika!',
      one: 'Dostupno u $count jezika!',
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
      few: '$count sekundi',
      one: '$count sekunda',
    );
    return '$_temp0';
  }

  @override
  String andSaveNbPremoveLines(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'i snimi $count poteza unaprijed',
      few: 'i snimi $count poteza unaprijed',
      one: 'i snimi $count potez unaprijed',
    );
    return '$_temp0';
  }

  @override
  String get stormMoveToStart => 'Povucite potez da biste počeli';

  @override
  String get stormYouPlayTheWhitePiecesInAllPuzzles => 'Igrate bijelim figurama u svim problemima';

  @override
  String get stormYouPlayTheBlackPiecesInAllPuzzles => 'Igrate crnim figurama u svim problemima';

  @override
  String get stormPuzzlesSolved => 'riješeni problemi';

  @override
  String get stormNewDailyHighscore => 'Novi najbolji dnevni rezultat!';

  @override
  String get stormNewWeeklyHighscore => 'Novi sedmični najbolji rezultat!';

  @override
  String get stormNewMonthlyHighscore => 'Novi mjesečni najbolji rezultat!';

  @override
  String get stormNewAllTimeHighscore => 'Novi najbolji rezultat sveukupno!';

  @override
  String stormPreviousHighscoreWasX(String param) {
    return 'Prethodni najbolji rezultat bio je $param';
  }

  @override
  String get stormPlayAgain => 'Igrajte ponovo';

  @override
  String stormHighscoreX(String param) {
    return 'Najbolji rezultat: $param';
  }

  @override
  String get stormScore => 'Rezultat';

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
  String get stormHighscores => 'Najbolji rezultati';

  @override
  String get stormViewBestRuns => 'Pogledajte najbolje ture';

  @override
  String get stormBestRunOfDay => 'Najbolja tura dana';

  @override
  String get stormRuns => 'Ture';

  @override
  String get stormGetReady => 'Spremite se!';

  @override
  String get stormWaitingForMorePlayers => 'Čekamo da se pridruži više igrača...';

  @override
  String get stormRaceComplete => 'Utrka završena!';

  @override
  String get stormSpectating => 'Posmatram';

  @override
  String get stormJoinTheRace => 'Pridružite se utrci!';

  @override
  String get stormStartTheRace => 'Započni trku';

  @override
  String stormYourRankX(String param) {
    return 'Vaš plasman: $param';
  }

  @override
  String get stormWaitForRematch => 'Pričekajte revanš';

  @override
  String get stormNextRace => 'Sljedeća utrka';

  @override
  String get stormJoinRematch => 'Pridružite se revanšu';

  @override
  String get stormWaitingToStart => 'Čekamo na početak';

  @override
  String get stormCreateNewGame => 'Kreirajte novu partiju';

  @override
  String get stormJoinPublicRace => 'Pridružite se javnoj utrci';

  @override
  String get stormRaceYourFriends => 'Utrkujte se s prijateljima';

  @override
  String get stormSkip => 'preskočite';

  @override
  String get stormSkipHelp => 'Možete preskočiti jedan potez po utrci:';

  @override
  String get stormSkipExplanation => 'Preskočite ovaj potez da sačuvate niz! Možete to samo jednom po utrci.';

  @override
  String get stormFailedPuzzles => 'Neuspješne zagonetke';

  @override
  String get stormSlowPuzzles => 'Spore zagonetke';

  @override
  String get stormSkippedPuzzle => 'Preskočeni problem';

  @override
  String get stormThisWeek => 'Ove sedmice';

  @override
  String get stormThisMonth => 'Ovog mjeseca';

  @override
  String get stormAllTime => 'Sve-vremeno';

  @override
  String get stormClickToReload => 'Kliknite da ponovno učitate';

  @override
  String get stormThisRunHasExpired => 'Ova runda je istekla!';

  @override
  String get stormThisRunWasOpenedInAnotherTab => 'Ova runda je otvorena u drugoj kartici!';

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
  String get studyShareAndExport => 'Podijelite i izvezite';

  @override
  String get studyStart => 'Pokreni';
}
