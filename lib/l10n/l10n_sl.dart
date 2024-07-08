import 'package:intl/intl.dart' as intl;

import 'l10n.dart';

/// The translations for Slovenian (`sl`).
class AppLocalizationsSl extends AppLocalizations {
  AppLocalizationsSl([String locale = 'sl']) : super(locale);

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
  String get activityHostedALiveStream => 'Gostil prenos v živo';

  @override
  String activityRankedInSwissTournament(String param1, String param2) {
    return 'Uvrščen #$param1 v $param2';
  }

  @override
  String get activitySignedUp => 'Prijavljen na lichess';

  @override
  String activitySupportedNbMonths(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count mesecev podpira lichess.org kot $param2',
      few: '$count mesece podpira lichess.org kot $param2',
      two: '$count meseca podpira lichess.org kot $param2',
      one: '$count mesec podpira lichess.org kot $param2',
    );
    return '$_temp0';
  }

  @override
  String activityPracticedNbPositions(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Treniral $count pozicij na $param2',
      few: 'Treniral $count pozicije na $param2',
      two: 'Treniral $count pozicij na $param2',
      one: 'Treniral $count pozicijo na $param2',
    );
    return '$_temp0';
  }

  @override
  String activitySolvedNbPuzzles(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Rešil $count taktičnih problemov',
      few: 'Rešil $count taktične probleme',
      two: 'Rešil $count taktična problema',
      one: 'Rešil $count taktični problem',
    );
    return '$_temp0';
  }

  @override
  String activityPlayedNbGames(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Odigral $count $param2 partij',
      few: 'Odigral $count $param2 partije',
      two: 'Odigral $count $param2 partiji',
      one: 'Odigral $count $param2 partijo',
    );
    return '$_temp0';
  }

  @override
  String activityPostedNbMessages(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Objavil $count sporočil v $param2',
      few: 'Objavil $count sporočila v $param2',
      two: 'Objavil $count sporočili v $param2',
      one: 'Objavil $count sporočilo v $param2',
    );
    return '$_temp0';
  }

  @override
  String activityPlayedNbMoves(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Potegnil $count potez',
      few: 'Potegnil $count poteze',
      two: 'Potegnil $count potezi',
      one: 'Potegnil $count potezo',
    );
    return '$_temp0';
  }

  @override
  String activityInNbCorrespondenceGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'v $count dopisnih partijah',
      few: 'v $count dopisnih partijah',
      two: 'v $count dopisnih partijah',
      one: 'v $count dopisni partiji',
    );
    return '$_temp0';
  }

  @override
  String activityCompletedNbGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Končal $count dopisnih partij',
      few: 'Končal $count dopisne partije',
      two: 'Končal $count dopisni partiji',
      one: 'Končal $count dopisno partijo',
    );
    return '$_temp0';
  }

  @override
  String activityFollowedNbPlayers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Sledi $count igralcem',
      few: 'Sledi $count igralcem',
      two: 'Sledi $count igralcem',
      one: 'Sledi $count igralcu',
    );
    return '$_temp0';
  }

  @override
  String activityGainedNbFollowers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Ima $count novih sledilcev',
      few: 'Ima $count nove sledilce',
      two: 'Ima $count nova sledilca',
      one: 'Ima $count novega sledilca',
    );
    return '$_temp0';
  }

  @override
  String activityHostedNbSimuls(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Gostil $count simultank',
      few: 'Gostil $count simultanke',
      two: 'Gostil $count simultanki',
      one: 'Gostil $count simultanko',
    );
    return '$_temp0';
  }

  @override
  String activityJoinedNbSimuls(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Sodeloval pri $count simultankah',
      few: 'Sodeloval pri $count simultankah',
      two: 'Sodeloval pri $count simultankah',
      one: 'Sodeloval pri $count simultanki',
    );
    return '$_temp0';
  }

  @override
  String activityCreatedNbStudies(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Ustvaril $count novih študijev',
      few: 'Ustvaril $count nove študije',
      two: 'Ustvaril $count novi študiji',
      one: 'Ustvaril $count nov študij',
    );
    return '$_temp0';
  }

  @override
  String activityCompetedInNbTournaments(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Končal $count turnirjev',
      few: 'Končal $count turnirje',
      two: 'Končal $count turnirja',
      one: 'Končal $count turnir',
    );
    return '$_temp0';
  }

  @override
  String activityRankedInTournament(int count, String param2, String param3, String param4) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '#$count na lestvici (najboljših $param2%) v $param3 partijah tekmovanja $param4',
      few: '#$count na lestvici (najboljših $param2%) v $param3 partijah tekmovanja $param4',
      two: '#$count na lestvici (najboljših $param2%) v $param3 partijah tekmovanja $param4',
      one: '#$count na lestvici (najboljših $param2%) v $param3 partiji tekmovanja $param4',
    );
    return '$_temp0';
  }

  @override
  String activityCompetedInNbSwissTournaments(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Tekmoval na $count švicarskih turnirjih',
      few: 'Tekmoval na $count švicarskih turnirjih',
      two: 'Tekmoval na $count švicarskih turnirjih',
      one: 'Tekmoval na $count švicarskem turnirju',
    );
    return '$_temp0';
  }

  @override
  String activityJoinedNbTeams(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Pridružen $count ekipam',
      few: 'Pridružen $count ekipam',
      two: 'Pridružen $count ekipam',
      one: 'Pridružen $count ekipi',
    );
    return '$_temp0';
  }

  @override
  String get broadcastBroadcasts => 'Prenosi';

  @override
  String get broadcastLiveBroadcasts => 'Prenos turnirjev v živo';

  @override
  String challengeChallengesX(String param1) {
    return 'Izzivi:$param1';
  }

  @override
  String get challengeChallengeToPlay => 'Izzovi na partijo';

  @override
  String get challengeChallengeDeclined => 'Izziv zavrnjen';

  @override
  String get challengeChallengeAccepted => 'Izziv je sprejet!';

  @override
  String get challengeChallengeCanceled => 'Izziv je preklican.';

  @override
  String get challengeRegisterToSendChallenges => 'Če želite poslati izziv, se, prosim, registrirajte.';

  @override
  String challengeYouCannotChallengeX(String param) {
    return 'Ne morete izzvati $param.';
  }

  @override
  String challengeXDoesNotAcceptChallenges(String param) {
    return '$param ne sprejema izzivov.';
  }

  @override
  String challengeYourXRatingIsTooFarFromY(String param1, String param2) {
    return 'Vaš $param1 rating je predaleč od ratinga igralca $param2.';
  }

  @override
  String challengeCannotChallengeDueToProvisionalXRating(String param) {
    return 'Izzivanje ni mogoče, zaradi začasnega $param ratinga.';
  }

  @override
  String challengeXOnlyAcceptsChallengesFromFriends(String param) {
    return '$param sprejema izzive samo od prijateljev.';
  }

  @override
  String get challengeDeclineGeneric => 'Sedaj ne sprejemam izzivov.';

  @override
  String get challengeDeclineLater => 'Zdaj ni pravi čas, posimo vprašajte kasneje.';

  @override
  String get challengeDeclineTooFast => 'Tokratna kontrola je zame prehitra, prosim, ponovno izzivajte s počasnejšo igro.';

  @override
  String get challengeDeclineTooSlow => 'Tokratna kontrola je zame prepočasna, prosim, znova izzivajte s hitrejšo igro.';

  @override
  String get challengeDeclineTimeControl => 'S tem časovnim nadzorom ne sprejemam izzivov.';

  @override
  String get challengeDeclineRated => 'Prosim, pošljite mi rangirani izziv.';

  @override
  String get challengeDeclineCasual => 'Prosim, pošljite mi nerangirani izziv.';

  @override
  String get challengeDeclineStandard => 'Trenutno ne sprejemam variantnih izzivov.';

  @override
  String get challengeDeclineVariant => 'Trenutno nisem pripravljen igrati te različice.';

  @override
  String get challengeDeclineNoBot => 'Izzivov od robotov ne sprejemam.';

  @override
  String get challengeDeclineOnlyBot => 'Sprejemam le izzive od robotov.';

  @override
  String get challengeInviteLichessUser => 'Ali pa povabite Lichess uporabnika:';

  @override
  String get contactContact => 'Kontakt';

  @override
  String get contactContactLichess => 'Kontaktiraj lichess';

  @override
  String get patronDonate => 'Donirajte';

  @override
  String get patronLichessPatron => 'Lichess pokrovitelj';

  @override
  String perfStatPerfStats(String param) {
    return '$param statistika';
  }

  @override
  String get perfStatViewTheGames => 'Ogled iger';

  @override
  String get perfStatProvisional => 'začasen';

  @override
  String get perfStatNotEnoughRatedGames => 'Za zanesljiv rejting je bilo odigranih premalo rangiranih iger.';

  @override
  String perfStatProgressOverLastXGames(String param) {
    return 'Napredek v zadnjih $param igrah:';
  }

  @override
  String perfStatRatingDeviation(String param) {
    return 'Odstopanje od rejtinga: $param.';
  }

  @override
  String perfStatRatingDeviationTooltip(String param1, String param2, String param3) {
    return 'Nižja vrednost pomeni, da je rejting stabilnejši. Nad $param1 se smatra, da je rejting začasen. Za uvrstitev med rangirane, mora biti ta vrednost pod $param2 (standardni šah) ali $param3 (različice).';
  }

  @override
  String get perfStatTotalGames => 'Vse igre';

  @override
  String get perfStatRatedGames => 'Rangirane partije';

  @override
  String get perfStatTournamentGames => 'Turnirske partije';

  @override
  String get perfStatBerserkedGames => 'Partije, pri katerih je igralec kliknil gumb za norenje';

  @override
  String get perfStatTimeSpentPlaying => 'Čas igranja';

  @override
  String get perfStatAverageOpponent => 'Povprečen nasprotnik';

  @override
  String get perfStatVictories => 'Zmage';

  @override
  String get perfStatDefeats => 'Porazi';

  @override
  String get perfStatDisconnections => 'Prekinjanje povezave';

  @override
  String get perfStatNotEnoughGames => 'Ni dovolj igranih partij';

  @override
  String perfStatHighestRating(String param) {
    return 'Najvišji rejting: $param';
  }

  @override
  String perfStatLowestRating(String param) {
    return 'Najnižji rejting: $param';
  }

  @override
  String perfStatFromXToY(String param1, String param2) {
    return 'od $param1 do $param2';
  }

  @override
  String get perfStatWinningStreak => 'Zmagovalni niz';

  @override
  String get perfStatLosingStreak => 'Niz porazov';

  @override
  String perfStatLongestStreak(String param) {
    return 'Najdaljši niz: $param';
  }

  @override
  String perfStatCurrentStreak(String param) {
    return 'Trenutni niz: $param';
  }

  @override
  String get perfStatBestRated => 'Najbolj rangirane zmage';

  @override
  String get perfStatGamesInARow => 'Odigrane partije v vrsti';

  @override
  String get perfStatLessThanOneHour => 'Manj kot 1 ura med partijami';

  @override
  String get perfStatMaxTimePlaying => 'Najdaljši čas igranja';

  @override
  String get perfStatNow => 'zdaj';

  @override
  String get preferencesPreferences => 'Nastavitve';

  @override
  String get preferencesDisplay => 'Prikaz';

  @override
  String get preferencesPrivacy => 'Zasebnost';

  @override
  String get preferencesNotifications => 'Obvestila';

  @override
  String get preferencesPieceAnimation => 'Animacija figur';

  @override
  String get preferencesMaterialDifference => 'Materialna prednost';

  @override
  String get preferencesBoardHighlights => 'Osvetlitev šahovnice (zadnja poteza in kralj v šahu)';

  @override
  String get preferencesPieceDestinations => 'Možne poteze (legalne in vnaprej določene)';

  @override
  String get preferencesBoardCoordinates => 'Koordinate na šahovnici (A-H, 1-8)';

  @override
  String get preferencesMoveListWhilePlaying => 'Seznam potez med igro';

  @override
  String get preferencesPgnPieceNotation => 'Zapis potez';

  @override
  String get preferencesChessPieceSymbol => 'Simbol figur';

  @override
  String get preferencesPgnLetter => 'Črke (K, Q, R, B, N)';

  @override
  String get preferencesZenMode => 'Zen način';

  @override
  String get preferencesShowPlayerRatings => 'Pokaži igralčeve ratinge';

  @override
  String get preferencesShowFlairs => 'Show player flairs';

  @override
  String get preferencesExplainShowPlayerRatings => 'Omogoča skrivanje vseh ratingov na spletnem mestu, da se osredotočite na igro. Igre same so še vedno lahko ratingirane, to je zgolj povezano z videzom.';

  @override
  String get preferencesDisplayBoardResizeHandle => 'Prikaži ročico za spremembo velikosti šahovnice';

  @override
  String get preferencesOnlyOnInitialPosition => 'Samo ob začetni poziciji';

  @override
  String get preferencesInGameOnly => 'In-game only';

  @override
  String get preferencesChessClock => 'Šahovska ura';

  @override
  String get preferencesTenthsOfSeconds => 'Desetinke sekunde';

  @override
  String get preferencesWhenTimeRemainingLessThanTenSeconds => 'Če je preostanek časa pod 10 sekundami';

  @override
  String get preferencesHorizontalGreenProgressBars => 'Vodoravna zelena prečka';

  @override
  String get preferencesSoundWhenTimeGetsCritical => 'Zvočni signal ko čas postane kritičen';

  @override
  String get preferencesGiveMoreTime => 'Dajte več časa';

  @override
  String get preferencesGameBehavior => 'Posebnosti igre';

  @override
  String get preferencesHowDoYouMovePieces => 'Kako premikate figure?';

  @override
  String get preferencesClickTwoSquares => 'Klikni dve polji';

  @override
  String get preferencesDragPiece => 'Potegni figuro';

  @override
  String get preferencesBothClicksAndDrag => 'Katerokoli';

  @override
  String get preferencesPremovesPlayingDuringOpponentTurn => 'Predpremik poteze';

  @override
  String get preferencesTakebacksWithOpponentApproval => 'Popravljanje potez (z dovoljenjem nasprotnika)';

  @override
  String get preferencesInCasualGamesOnly => 'Samo pri nerangiranih partijah';

  @override
  String get preferencesPromoteToQueenAutomatically => 'Vedno promoviraj v damo';

  @override
  String get preferencesExplainPromoteToQueenAutomatically => 'Pridržite ctrl med promocijo, da začasno onemogočite samodejno promocijo';

  @override
  String get preferencesWhenPremoving => 'Pri predpremiku poteze';

  @override
  String get preferencesClaimDrawOnThreefoldRepetitionAutomatically => 'Avtomatično zahtevaj remi on ponovitvi treh istih pozicij';

  @override
  String get preferencesWhenTimeRemainingLessThanThirtySeconds => 'Če je preostanek časa manj kot 30 sekund';

  @override
  String get preferencesMoveConfirmation => 'Potrditev poteze';

  @override
  String get preferencesExplainCanThenBeTemporarilyDisabled => 'Can be disabled during a game with the board menu';

  @override
  String get preferencesInCorrespondenceGames => 'V korespondenčnih partijah';

  @override
  String get preferencesCorrespondenceAndUnlimited => 'Dopisno in neomejeno';

  @override
  String get preferencesConfirmResignationAndDrawOffers => 'Potrdi predajo in ponudbo remija';

  @override
  String get preferencesCastleByMovingTheKingTwoSquaresOrOntoTheRook => 'Način rokade';

  @override
  String get preferencesCastleByMovingTwoSquares => 'Premakni kralja za dve polji';

  @override
  String get preferencesCastleByMovingOntoTheRook => 'Premakni kralja na trdnjavo';

  @override
  String get preferencesInputMovesWithTheKeyboard => 'Vnos potez prek tipkovnice';

  @override
  String get preferencesInputMovesWithVoice => 'Vnos potez z vašim glasom';

  @override
  String get preferencesSnapArrowsToValidMoves => 'Postavi puščice po veljavnih potezah';

  @override
  String get preferencesSayGgWpAfterLosingOrDrawing => 'Reci \"Dobra igra, dobro odigrano\" ob porazu ali remiju';

  @override
  String get preferencesYourPreferencesHaveBeenSaved => 'Nastavitve so bile shranjene.';

  @override
  String get preferencesScrollOnTheBoardToReplayMoves => 'Pomaknite se po plošči za predvajanje potez';

  @override
  String get preferencesCorrespondenceEmailNotification => 'Dnevno obvestilo po pošti z naštevanjem vaših korespondenčnih iger';

  @override
  String get preferencesNotifyStreamStart => 'Streamer je začel oddajati v živo';

  @override
  String get preferencesNotifyInboxMsg => 'Novo prispelo sporočilo';

  @override
  String get preferencesNotifyForumMention => 'Omenili so vas v komentarju na forumu';

  @override
  String get preferencesNotifyInvitedStudy => 'Povabilo k študiji';

  @override
  String get preferencesNotifyGameEvent => 'Novo v korespondenčnih partijah';

  @override
  String get preferencesNotifyChallenge => 'Izzivi';

  @override
  String get preferencesNotifyTournamentSoon => 'Turnir se bo kmalu začel';

  @override
  String get preferencesNotifyTimeAlarm => 'Potekel vam bo čas';

  @override
  String get preferencesNotifyBell => 'Zvočno obvestilo znotraj Lichess';

  @override
  String get preferencesNotifyPush => 'Obvestilo naprave, ko niste na Lichessu';

  @override
  String get preferencesNotifyWeb => 'Brskalnik';

  @override
  String get preferencesNotifyDevice => 'Naprava';

  @override
  String get preferencesBellNotificationSound => 'Zvok obvestila zvonca';

  @override
  String get puzzlePuzzles => 'Šahovski problemi';

  @override
  String get puzzlePuzzleThemes => 'Teme ugank';

  @override
  String get puzzleRecommended => 'Priporočeno';

  @override
  String get puzzlePhases => 'Faze';

  @override
  String get puzzleMotifs => 'Motivi';

  @override
  String get puzzleAdvanced => 'Napredno';

  @override
  String get puzzleLengths => 'Dolžine';

  @override
  String get puzzleMates => 'Mati';

  @override
  String get puzzleGoals => 'Cilji';

  @override
  String get puzzleOrigin => 'Izvor';

  @override
  String get puzzleSpecialMoves => 'Posebne poteze';

  @override
  String get puzzleDidYouLikeThisPuzzle => 'Ali ti je všeč šahovski problem?';

  @override
  String get puzzleVoteToLoadNextOne => 'Glasujte za nalaganje naslednjega!';

  @override
  String get puzzleUpVote => 'Glas ZA uganko';

  @override
  String get puzzleDownVote => 'Glas PROTI uganki';

  @override
  String get puzzleYourPuzzleRatingWillNotChange => 'Vaša ocena uganke se ne bo spremenila. Upoštevajte, da uganke niso tekmovanje. Ocena pomaga izbrati najboljše uganke za vaše trenutno znanje.';

  @override
  String get puzzleFindTheBestMoveForWhite => 'Poišči najboljšo potezo za belega.';

  @override
  String get puzzleFindTheBestMoveForBlack => 'Poišči najboljšo potezo za črnega.';

  @override
  String get puzzleToGetPersonalizedPuzzles => 'Če želite prejeti uganke po meri:';

  @override
  String puzzlePuzzleId(String param) {
    return 'Uganka $param';
  }

  @override
  String get puzzlePuzzleOfTheDay => 'Uganka dneva';

  @override
  String get puzzleDailyPuzzle => 'Uganka dneva';

  @override
  String get puzzleClickToSolve => 'Kliknite za rešitev';

  @override
  String get puzzleGoodMove => 'Dobra poteza';

  @override
  String get puzzleBestMove => 'Najboljša poteza!';

  @override
  String get puzzleKeepGoing => 'Nadaljuj…';

  @override
  String get puzzlePuzzleSuccess => 'Prenos uspešen!';

  @override
  String get puzzlePuzzleComplete => 'Uganka rešena!';

  @override
  String get puzzleByOpenings => 'Po otvoritvah';

  @override
  String get puzzlePuzzlesByOpenings => 'Uganke po otvoritvah';

  @override
  String get puzzleOpeningsYouPlayedTheMost => 'Otvoritve, ki ste jih največ igrali v rangiranih igrah';

  @override
  String get puzzleUseFindInPage => 'Uporabite \"Poišči na strani\" v meniju brskalnika, da poiščete svoje najljubšo otvoritev!';

  @override
  String get puzzleUseCtrlF => 'Uporabite Ctrl+f, da najdete vašo najljubšo otvoritev!';

  @override
  String get puzzleNotTheMove => 'To ni pravilna poteza!';

  @override
  String get puzzleTrySomethingElse => 'Poskusite kakšno drugo potezo.';

  @override
  String puzzleRatingX(String param) {
    return 'Uvrstitev: $param';
  }

  @override
  String get puzzleHidden => 'skrit';

  @override
  String puzzleFromGameLink(String param) {
    return 'Iz partije $param';
  }

  @override
  String get puzzleContinueTraining => 'Nadaljuj z reševanjem';

  @override
  String get puzzleDifficultyLevel => 'Stopnja težavnosti';

  @override
  String get puzzleNormal => 'Običajno';

  @override
  String get puzzleEasier => 'Lažje';

  @override
  String get puzzleEasiest => 'Najlažje';

  @override
  String get puzzleHarder => 'Težje';

  @override
  String get puzzleHardest => 'Najtežje';

  @override
  String get puzzleExample => 'Primer';

  @override
  String get puzzleAddAnotherTheme => 'Dodaj novo temo';

  @override
  String get puzzleNextPuzzle => 'Naslednja uganka';

  @override
  String get puzzleJumpToNextPuzzleImmediately => 'Takoj skočite k naslednji uganki';

  @override
  String get puzzlePuzzleDashboard => 'Nadzorna plošča za uganke';

  @override
  String get puzzleImprovementAreas => 'Področja izboljšav';

  @override
  String get puzzleStrengths => 'Prednosti';

  @override
  String get puzzleHistory => 'Zgodovina ugank';

  @override
  String get puzzleSolved => 'rešeno';

  @override
  String get puzzleFailed => 'neuspešno';

  @override
  String get puzzleStreakDescription => 'Rešujte vedno težje uganke in ustvarite zmagovalni niz. Vzemite si čas, saj ni časovne omejitve. Ena napačna poteza in igre je konec! Lahko pa v posamezni lekciji preskočite eno potezo.';

  @override
  String puzzleYourStreakX(String param) {
    return 'Vaš niz: $param';
  }

  @override
  String get puzzleStreakSkipExplanation => 'Preskočite to potezo, da ohranite svoj niz! V posameznem poskusu je to mogoče samo enkrat.';

  @override
  String get puzzleContinueTheStreak => 'Nadaljujte niz';

  @override
  String get puzzleNewStreak => 'Nov niz';

  @override
  String get puzzleFromMyGames => 'Iz mojih iger';

  @override
  String get puzzleLookupOfPlayer => 'Iskanje ugank iz igralčevih iger';

  @override
  String puzzleFromXGames(String param) {
    return 'Uganke iz ${param}evih iger';
  }

  @override
  String get puzzleSearchPuzzles => 'Išči uganke';

  @override
  String get puzzleFromMyGamesNone => 'V bazi podatkov nimate ugank, vendar vas ima Lichess še vedno zelo rad.\nIgrajte hitre in klasične igre, da povečate možnosti za dodajanje svoje uganke!';

  @override
  String puzzleFromXGamesFound(String param1, String param2) {
    return 'Najdenih $param1 ugank v $param2 igrah';
  }

  @override
  String get puzzlePuzzleDashboardDescription => 'Trenirajte, analizirajte, izboljšajte';

  @override
  String puzzlePercentSolved(String param) {
    return '$param rešenih';
  }

  @override
  String get puzzleNoPuzzlesToShow => 'Nič za pokazati, najprej pojdite igrati uganke!';

  @override
  String get puzzleImprovementAreasDescription => 'Trenirajte jih, da optimizirate svoj napredek!';

  @override
  String get puzzleStrengthDescription => 'V teh temah se najbolje odrežete';

  @override
  String puzzlePlayedXTimes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Odigrano $count krat',
      few: 'Odigrano $count krat',
      two: 'Odigrano $count krat',
      one: 'Odigrano $count krat',
    );
    return '$_temp0';
  }

  @override
  String puzzleNbPointsBelowYourPuzzleRating(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count točk pod ratingom uganke',
      few: '$count točke pod ratingom uganke',
      two: '$count točki pod ratingom uganke',
      one: 'Ena točka pod ratingom uganke',
    );
    return '$_temp0';
  }

  @override
  String puzzleNbPointsAboveYourPuzzleRating(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count točk nad ratingom uganke',
      few: '$count točke nad ratingom uganke',
      two: '$count točki nad ratingom uganke',
      one: 'Ena točka nad ratingom uganke',
    );
    return '$_temp0';
  }

  @override
  String puzzleNbPlayed(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count igranih',
      few: '$count igrani',
      two: '$count igrani',
      one: '$count igrana',
    );
    return '$_temp0';
  }

  @override
  String puzzleNbToReplay(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count za predvajanje',
      few: '$count za predvajanje',
      two: '$count za predvajanje',
      one: '$count za predvajanje',
    );
    return '$_temp0';
  }

  @override
  String get puzzleThemeAdvancedPawn => 'Promovirani kmet';

  @override
  String get puzzleThemeAdvancedPawnDescription => '85 / 5000\nTranslation results\nEden od vaših kmetov je globoko na nasprotnikovem področju in ima morda možnost za promocijo.';

  @override
  String get puzzleThemeAdvantage => 'Prednost';

  @override
  String get puzzleThemeAdvantageDescription => 'Izkoristite priložnost in si pridobite odločilno prednost (ocena pozicije med 200 in 600 stotinov kmeta)';

  @override
  String get puzzleThemeAnastasiaMate => 'Anastasijin mat';

  @override
  String get puzzleThemeAnastasiaMateDescription => 'Skakač in trdnjava ali dama sodelujejo, da ujamejo nasprotnega kralja ob rob šahovnice in prijateljsko figuro v past.';

  @override
  String get puzzleThemeArabianMate => 'Arabski mat';

  @override
  String get puzzleThemeArabianMateDescription => 'Skakač in trdnjava s skupnimi močmi ujameta nasprotnega kralja v kotu šahovnice.';

  @override
  String get puzzleThemeAttackingF2F7 => 'Napad na f2 ali f7';

  @override
  String get puzzleThemeAttackingF2F7Description => 'Napad, osredotočen na kmeta na poljih f2 ali f7, kot na primer pri \"fried liver\" napadu.';

  @override
  String get puzzleThemeAttraction => 'Privlačnost';

  @override
  String get puzzleThemeAttractionDescription => 'Izmenjava ali žrtvovanje, ki spodbuja ali sili nasprotnika na polje, ki omogoča nadaljevanje taktike.';

  @override
  String get puzzleThemeBackRankMate => 'Mat zadnje vrste';

  @override
  String get puzzleThemeBackRankMateDescription => 'Matiranje kralja, ko je še na začetni vrsti, ujet s svojimi figurami.';

  @override
  String get puzzleThemeBishopEndgame => 'Končnica lovcev';

  @override
  String get puzzleThemeBishopEndgameDescription => 'Končnica s samo lovci in kmeti.';

  @override
  String get puzzleThemeBodenMate => 'Bodenov mat';

  @override
  String get puzzleThemeBodenMateDescription => 'Lovca na križajočih se diagonalah matirata kralja, ki ga ovirajo njegove figure.';

  @override
  String get puzzleThemeCastling => 'Rokada';

  @override
  String get puzzleThemeCastlingDescription => 'Umik kralja na varno in razporeditev trdnjave za napad.';

  @override
  String get puzzleThemeCapturingDefender => 'Zajem branilca';

  @override
  String get puzzleThemeCapturingDefenderDescription => 'Odstranitev figure, ki je ključna za obrambo druge figure, kar omogoča, da se nezaščitena figura zajame z naslednjo potezo.';

  @override
  String get puzzleThemeCrushing => 'Odločilna prednost';

  @override
  String get puzzleThemeCrushingDescription => 'Spoznanje nasprotnikove napake, za odločilno prednost. (ocena ≥ 600sk)';

  @override
  String get puzzleThemeDoubleBishopMate => 'Mat z lovcema';

  @override
  String get puzzleThemeDoubleBishopMateDescription => 'Lovca na sosednjih diagonalah matirata kralja, ki ga ovirajo njegove figure.';

  @override
  String get puzzleThemeDovetailMate => 'Coziov mat';

  @override
  String get puzzleThemeDovetailMateDescription => 'Dama matira kralja, ki mu njegovi figuri zasedata edini polji za umik.';

  @override
  String get puzzleThemeEquality => 'Izenačenje';

  @override
  String get puzzleThemeEqualityDescription => 'Vrnite se iz izgubljenega položaja in si zagotovite neodločen ali uravnotežen položaj. (vrednotenje ≤ 200 sk)';

  @override
  String get puzzleThemeKingsideAttack => 'Napad po kraljevi strani';

  @override
  String get puzzleThemeKingsideAttackDescription => 'Napad nasprotnikovega kralja, potem ko je rokiral na kraljevo stran.';

  @override
  String get puzzleThemeClearance => 'Potrditev';

  @override
  String get puzzleThemeClearanceDescription => 'Poteza, pogosto s tempom, ki počisti polje, kolono ali diagonalo za nadaljnjo taktično idejo.';

  @override
  String get puzzleThemeDefensiveMove => 'Obrambna poteza';

  @override
  String get puzzleThemeDefensiveMoveDescription => 'Natančna poteza ali zaporedje potez, ki je potrebno, da se izognete izgubi materiala ali drugi prednosti.';

  @override
  String get puzzleThemeDeflection => 'Odklon';

  @override
  String get puzzleThemeDeflectionDescription => 'Poteza, ki nasprotnikovo figuro odvrne od druge dolžnosti, ki jo opravlja, na primer varovanja ključnega polja. Včasih se imenuje tudi \"preobremenitev\".';

  @override
  String get puzzleThemeDiscoveredAttack => 'Odkrit napad';

  @override
  String get puzzleThemeDiscoveredAttackDescription => 'Premikanje figure (na primer skakača), ki je prej blokiral napad s figure velikega dosega (na primer trdnjava), stran od te figure.';

  @override
  String get puzzleThemeDoubleCheck => 'Dvojni šah';

  @override
  String get puzzleThemeDoubleCheckDescription => 'Napad na kralja z dvema figurama naenkrat, kot rezultat odkritega napada, kjer tako premikajoča se figura kot tudi razkrita figura napadata nasprotnikovega kralja.';

  @override
  String get puzzleThemeEndgame => 'Končnica';

  @override
  String get puzzleThemeEndgameDescription => 'Taktika v zadnji fazi partije.';

  @override
  String get puzzleThemeEnPassantDescription => 'Taktika, ki vključuje pravilo en passant, kjer lahko kmet zajame nasprotnega kmeta, ki ga je z napredovanjem za dve polji zaobšel.';

  @override
  String get puzzleThemeExposedKing => 'Izpostavljeni kralj';

  @override
  String get puzzleThemeExposedKingDescription => 'Taktika, ki vključuje kralja s premalo obrambe, kar pogosto vodi v mat.';

  @override
  String get puzzleThemeFork => 'Dvojni napad (vilice)';

  @override
  String get puzzleThemeForkDescription => 'Poteza, pri kateri figura napade dve nasprotnikovi figuri hkrati.';

  @override
  String get puzzleThemeHangingPiece => 'Nezaščitena figura';

  @override
  String get puzzleThemeHangingPieceDescription => 'Taktika, ki vključuje, da nasprotnikova figura ni oziroma je premalo zaščitena in jo je mogoče zajeti.';

  @override
  String get puzzleThemeHookMate => 'Kljukast mat';

  @override
  String get puzzleThemeHookMateDescription => 'Mat s trdnjavo, skakačem in kmetom ob nasprotnikovem kmetu, ki omejuje pobeg nasprotnikovega kralja.';

  @override
  String get puzzleThemeInterference => 'Vpletanje';

  @override
  String get puzzleThemeInterferenceDescription => 'Premik figure med dve nasprotnikovi tako, da obe nasprotnikovi figuri postaneta nebranjeni, naprimer poteza skakača na branjeno polje med dve trdnjavi.';

  @override
  String get puzzleThemeIntermezzo => 'Intermezzo';

  @override
  String get puzzleThemeIntermezzoDescription => 'Namesto pričakovane poteze, vrinemo drugo potezo ki predstavlja takojšnjo grožnjo na katero mora nasprotnik odgovorit. Z drugim imenom tudi kot \"Zwischenzug\" ali medpoteza.';

  @override
  String get puzzleThemeKnightEndgame => 'Končnica skakačev';

  @override
  String get puzzleThemeKnightEndgameDescription => 'Končnica s skakači in s kmeti.';

  @override
  String get puzzleThemeLong => 'Dolga uganka';

  @override
  String get puzzleThemeLongDescription => 'Tri poteze za zmago.';

  @override
  String get puzzleThemeMaster => 'Igre mojstrov';

  @override
  String get puzzleThemeMasterDescription => 'Igre, ki so jih odigrali igralci z nazivom.';

  @override
  String get puzzleThemeMasterVsMaster => 'Igre mojster proti mojstru';

  @override
  String get puzzleThemeMasterVsMasterDescription => 'Uganke iz iger med igralci z nazivom.';

  @override
  String get puzzleThemeMate => 'Mat';

  @override
  String get puzzleThemeMateDescription => 'Zmagati igro v stilu.';

  @override
  String get puzzleThemeMateIn1 => 'Mat v 1';

  @override
  String get puzzleThemeMateIn1Description => 'Matirajte v eni potezi.';

  @override
  String get puzzleThemeMateIn2 => 'Mat v 2';

  @override
  String get puzzleThemeMateIn2Description => 'Matirajte v dveh potezah.';

  @override
  String get puzzleThemeMateIn3 => 'Mat v 3';

  @override
  String get puzzleThemeMateIn3Description => 'Matirajte v treh potezah.';

  @override
  String get puzzleThemeMateIn4 => 'Mat v 4';

  @override
  String get puzzleThemeMateIn4Description => 'Matirajte v štirih potezah.';

  @override
  String get puzzleThemeMateIn5 => 'Mat v 5';

  @override
  String get puzzleThemeMateIn5Description => 'Razvozlajte dolgo zaporedje potez do mata.';

  @override
  String get puzzleThemeMiddlegame => 'Središčnica';

  @override
  String get puzzleThemeMiddlegameDescription => 'Taktika v drugi fazi partije.';

  @override
  String get puzzleThemeOneMove => 'Eno potezna uganka';

  @override
  String get puzzleThemeOneMoveDescription => 'Uganka, ki ima eno potezo.';

  @override
  String get puzzleThemeOpening => 'Otvoritev';

  @override
  String get puzzleThemeOpeningDescription => 'Taktika v prvi fazi partije.';

  @override
  String get puzzleThemePawnEndgame => 'Končnica s kmeti';

  @override
  String get puzzleThemePawnEndgameDescription => 'Končnica samo s kmeti.';

  @override
  String get puzzleThemePin => 'Vezava';

  @override
  String get puzzleThemePinDescription => 'Taktika, ki vključuje vezavo, kjer se figura ne more premakniti, ne da bi razkrila napad na figuro višje vrednosti.';

  @override
  String get puzzleThemePromotion => 'Promocija';

  @override
  String get puzzleThemePromotionDescription => 'Promovirajte enega svojega kmeta v kraljico ali lahko figuro.';

  @override
  String get puzzleThemeQueenEndgame => 'Končnica z damo';

  @override
  String get puzzleThemeQueenEndgameDescription => 'Končina samo z damama in kmeti.';

  @override
  String get puzzleThemeQueenRookEndgame => 'Končnica z damo in trdnjavo';

  @override
  String get puzzleThemeQueenRookEndgameDescription => 'Končnica z damami, trdnjavami in kmeti.';

  @override
  String get puzzleThemeQueensideAttack => 'Napad po daminem krilu';

  @override
  String get puzzleThemeQueensideAttackDescription => 'Napad nasprotnikovega kralja, po rokadi na damino krilo.';

  @override
  String get puzzleThemeQuietMove => 'Tiha poteza';

  @override
  String get puzzleThemeQuietMoveDescription => 'Poteza ki ne naredi šah ali požre figure ali pa ne predstavlja direktne grožnje za napad, vendar pripravi skrito grožnjo, ki se izvede v kasneje in je ni mogoče ubranit.';

  @override
  String get puzzleThemeRookEndgame => 'Končnica s trdnjavo';

  @override
  String get puzzleThemeRookEndgameDescription => 'Končina samo s trdnjavami in kmeti.';

  @override
  String get puzzleThemeSacrifice => 'Žrtvovanje';

  @override
  String get puzzleThemeSacrificeDescription => 'Taktika, ki vključuje kratkoročno žrtvovanje materiala, da bi po prisilnem zaporedju potez znova pridobili prednost.';

  @override
  String get puzzleThemeShort => 'Kratka uganka';

  @override
  String get puzzleThemeShortDescription => 'Dve potezi za zmago.';

  @override
  String get puzzleThemeSkewer => 'Nabodalo';

  @override
  String get puzzleThemeSkewerDescription => 'Napad na vredno figuro, ki z umikom omogoči, da se požre figuro nižje vrednostjo, ki stoji za njo. Obratno kot vezava.';

  @override
  String get puzzleThemeSmotheredMate => 'Zadušitveni mat';

  @override
  String get puzzleThemeSmotheredMateDescription => 'Mat s skakačem, kjer se kralj ne more premakniti, ker je obkrožen (oziroma zadušen) z lastnimi figurami.';

  @override
  String get puzzleThemeSuperGM => 'Partije super VM';

  @override
  String get puzzleThemeSuperGMDescription => 'Uganke iz partij, ki so jih igrali najboljši šahisti na svetu.';

  @override
  String get puzzleThemeTrappedPiece => 'Ujeta figura';

  @override
  String get puzzleThemeTrappedPieceDescription => 'Figura ne more pobegnit napadu, ker ima omejeno gibanje.';

  @override
  String get puzzleThemeUnderPromotion => 'Podpromocija';

  @override
  String get puzzleThemeUnderPromotionDescription => 'Promocija v lovca, skakača ali v trdnjavo.';

  @override
  String get puzzleThemeVeryLong => 'Zelo dolga uganka';

  @override
  String get puzzleThemeVeryLongDescription => 'Štiri poteze do zmage.';

  @override
  String get puzzleThemeXRayAttack => 'Rentgenski napad';

  @override
  String get puzzleThemeXRayAttackDescription => 'Figura napada ali brani polje skozi nasprotnikovo figuro.';

  @override
  String get puzzleThemeZugzwang => 'Nujnica';

  @override
  String get puzzleThemeZugzwangDescription => 'Nasprotnik ima omejene poteze in vsaka poslabša njegovo pozicijo.';

  @override
  String get puzzleThemeHealthyMix => 'Zdrava mešanica';

  @override
  String get puzzleThemeHealthyMixDescription => 'Vsega po malo. Ne veste, kaj pričakovati, zato bodite pripravljeni na vse! Kot pri resničnih partijah.';

  @override
  String get puzzleThemePlayerGames => 'Igralske igre';

  @override
  String get puzzleThemePlayerGamesDescription => 'Iskanje ugank, ustvarjenih iz vaših iger ali iz iger drugega igralca.';

  @override
  String puzzleThemePuzzleDownloadInformation(String param) {
    return 'Te uganke so v javni lasti in jih je mogoče prenesti s spletnega mesta $param.';
  }

  @override
  String get searchSearch => 'Iskanje';

  @override
  String get settingsSettings => 'Nastavitve';

  @override
  String get settingsCloseAccount => 'Zapri račun';

  @override
  String get settingsManagedAccountCannotBeClosed => 'Vaš račun je upravljan in ga ni mogoče zapreti.';

  @override
  String get settingsClosingIsDefinitive => 'Zapora je dokončna. Ni poti nazaj. Ali ste prepričani?';

  @override
  String get settingsCantOpenSimilarAccount => 'Računa z enakim imenom ne boste mogli odpreti, tudi če z drugačnimi velikostmi črk.';

  @override
  String get settingsChangedMindDoNotCloseAccount => 'Premislil sem si, ne želim zapreti računa';

  @override
  String get settingsCloseAccountExplanation => 'Ali ste prepričani da želti zapreti svoj račun? Zaprtje računa je trajna odločitev. NIKOLI se ne boste mogli prijaviti VEČ.';

  @override
  String get settingsThisAccountIsClosed => 'Račun je zaprt.';

  @override
  String get playWithAFriend => 'Igraj s prijateljem';

  @override
  String get playWithTheMachine => 'Igraj proti računalniku';

  @override
  String get toInviteSomeoneToPlayGiveThisUrl => 'Kopiraj URL in povabi prijatelja k igri';

  @override
  String get gameOver => 'Konec igre';

  @override
  String get waitingForOpponent => 'Čakam nasprotnika';

  @override
  String get orLetYourOpponentScanQrCode => 'Ali pa naj vaš nasprotnik skenira to QR kodo';

  @override
  String get waiting => 'Čakam';

  @override
  String get yourTurn => 'Ti si na potezi';

  @override
  String aiNameLevelAiLevel(String param1, String param2) {
    return '$param1, stopnja: $param2';
  }

  @override
  String get level => 'Stopnja';

  @override
  String get strength => 'Moč';

  @override
  String get toggleTheChat => 'Preklopi klepet';

  @override
  String get chat => 'Klepet';

  @override
  String get resign => 'Predaj';

  @override
  String get checkmate => 'Mat';

  @override
  String get stalemate => 'Pat';

  @override
  String get white => 'Beli';

  @override
  String get black => 'Črni';

  @override
  String get asWhite => 'kot beli';

  @override
  String get asBlack => 'kot črni';

  @override
  String get randomColor => 'Naključna stran';

  @override
  String get createAGame => 'Nova igra';

  @override
  String get whiteIsVictorious => 'Beli je zmagal';

  @override
  String get blackIsVictorious => 'Črni je zmagal';

  @override
  String get youPlayTheWhitePieces => 'Igrate z belimi figurami';

  @override
  String get youPlayTheBlackPieces => 'Igrate s črnimi figurami';

  @override
  String get itsYourTurn => 'Na potezi ste!';

  @override
  String get cheatDetected => 'Zaznana goljufija';

  @override
  String get kingInTheCenter => 'Kralj v sredini';

  @override
  String get threeChecks => 'Trojni šah';

  @override
  String get raceFinished => 'Dirka končana';

  @override
  String get variantEnding => 'Varianta končnice';

  @override
  String get newOpponent => 'Nov nasprotnik';

  @override
  String get yourOpponentWantsToPlayANewGameWithYou => 'Nasprotnik želi s teboj igrati še eno igro';

  @override
  String get joinTheGame => 'Pridruži se igri';

  @override
  String get whitePlays => 'Beli na potezi';

  @override
  String get blackPlays => 'Črni na potezi';

  @override
  String get opponentLeftChoices => 'Nasprotnik je zapustil igro. Vsili predajo ali počakaj nanj.';

  @override
  String get forceResignation => 'Prijavi zmago';

  @override
  String get forceDraw => 'Prijavi remi';

  @override
  String get talkInChat => 'Prosimo, bodite prijazni v klepetu!';

  @override
  String get theFirstPersonToComeOnThisUrlWillPlayWithYou => 'S teboj bo igrala prva oseba, ki pride na ta naslov.';

  @override
  String get whiteResigned => 'Beli je predal';

  @override
  String get blackResigned => 'Črni je predal';

  @override
  String get whiteLeftTheGame => 'Beli je zapustil igro';

  @override
  String get blackLeftTheGame => 'Črni je zapustil igro';

  @override
  String get whiteDidntMove => 'Beli ni naredil poteze';

  @override
  String get blackDidntMove => 'Črni ni naredil poteze';

  @override
  String get requestAComputerAnalysis => 'Zahtevaj računalniško analizo';

  @override
  String get computerAnalysis => 'Računalniška analiza';

  @override
  String get computerAnalysisAvailable => 'Računalniška analiza je na voljo';

  @override
  String get computerAnalysisDisabled => 'Računalniška analiza ni na voljo';

  @override
  String get analysis => 'Analiza';

  @override
  String depthX(String param) {
    return 'Globina $param';
  }

  @override
  String get usingServerAnalysis => 'Z analizo strežnika';

  @override
  String get loadingEngine => 'Nalaganje motorja ...';

  @override
  String get calculatingMoves => 'Računanje potez...';

  @override
  String get engineFailed => 'Napaka pri nalaganju motorja';

  @override
  String get cloudAnalysis => 'Analiza v oblaku';

  @override
  String get goDeeper => 'Pojdi globje';

  @override
  String get showThreat => 'Prikaži grožnjo';

  @override
  String get inLocalBrowser => 'v lokalnem brskalniku';

  @override
  String get toggleLocalEvaluation => 'Preklopi lokalno analizo';

  @override
  String get promoteVariation => 'Promoviraj variacijo';

  @override
  String get makeMainLine => 'Nastavite kot glavno varianto';

  @override
  String get deleteFromHere => 'Izbriši od tukaj';

  @override
  String get collapseVariations => 'Strni različice';

  @override
  String get expandVariations => 'Razširite različice';

  @override
  String get forceVariation => 'Vsili varianto';

  @override
  String get copyVariationPgn => 'Kopiraj različico PGN';

  @override
  String get move => 'Poteza';

  @override
  String get variantLoss => 'Izgubljena varianta';

  @override
  String get variantWin => 'Dobljena varianta';

  @override
  String get insufficientMaterial => 'Premalo materiala';

  @override
  String get pawnMove => 'Poteza kmeta';

  @override
  String get capture => 'Vzemanje';

  @override
  String get close => 'Zapri';

  @override
  String get winning => 'Dobljeno';

  @override
  String get losing => 'Izgubljeno';

  @override
  String get drawn => 'Remi';

  @override
  String get unknown => 'Neznano';

  @override
  String get database => 'Baza';

  @override
  String get whiteDrawBlack => 'Beli / Remi / Črni';

  @override
  String averageRatingX(String param) {
    return 'Povprečni rating: $param';
  }

  @override
  String get recentGames => 'Nedavne igre';

  @override
  String get topGames => 'Najboljše partije';

  @override
  String masterDbExplanation(String param1, String param2, String param3) {
    return 'Dva milijona iger na šahovnici med igralci s FIDE ratingom $param1 ali več od leta $param2 do $param3';
  }

  @override
  String get dtzWithRounding => 'DTZ50 \'\' z zaokroževanjem, odvisno od števila pol-potez do naslednjega zajema ali poteze kmeta';

  @override
  String get noGameFound => 'Igra ni najdena';

  @override
  String get maxDepthReached => 'Največja globina je dosežena!';

  @override
  String get maybeIncludeMoreGamesFromThePreferencesMenu => 'Bi vključili več partij v meniju nastavitev?';

  @override
  String get openings => 'Otvoritve';

  @override
  String get openingExplorer => 'Raziskovalec otvoritev';

  @override
  String get openingEndgameExplorer => 'Raziskovalec otovoritev/končnic';

  @override
  String xOpeningExplorer(String param) {
    return '$param raziskovalec otvoritev';
  }

  @override
  String get playFirstOpeningEndgameExplorerMove => 'Odigrajte prvo potezo raziskovalca na začetku/koncu igre';

  @override
  String get winPreventedBy50MoveRule => 'Zmago preprečilo pravilo 50 potez';

  @override
  String get lossSavedBy50MoveRule => 'Poraz rešilo pravilo 50 potez';

  @override
  String get winOr50MovesByPriorMistake => 'Zmagajte ali 50 potez po predhodni napaki';

  @override
  String get lossOr50MovesByPriorMistake => 'Izguba ali 50 potez po predhodni napaki';

  @override
  String get unknownDueToRounding => 'Zmaga/poraz je zagotovljen le, če je bila od možnega zaokroževanja upoštevana priporočena vrstica mize.';

  @override
  String get allSet => 'Vse pripravljeno!';

  @override
  String get importPgn => 'Uvozi PGN';

  @override
  String get delete => 'Izbriši';

  @override
  String get deleteThisImportedGame => 'Izbriši to uvoženo partijo?';

  @override
  String get replayMode => 'Način predvajanja';

  @override
  String get realtimeReplay => 'Realnočasovno';

  @override
  String get byCPL => 'Za stotinko kmeta';

  @override
  String get openStudy => 'Odpri študij';

  @override
  String get enable => 'Omogoči';

  @override
  String get bestMoveArrow => 'Puščica najboljše poteze';

  @override
  String get showVariationArrows => 'Show variation arrows';

  @override
  String get evaluationGauge => 'Kazalnik ocene';

  @override
  String get multipleLines => 'Več variant';

  @override
  String get cpus => 'CPU-ji';

  @override
  String get memory => 'Spomin';

  @override
  String get infiniteAnalysis => 'Neskončna analiza';

  @override
  String get removesTheDepthLimit => 'Odstrani omejitev globine in ohrani računalnik topel';

  @override
  String get engineManager => 'Vodja motorja';

  @override
  String get blunder => 'Spodrsljaj';

  @override
  String get mistake => 'Napaka';

  @override
  String get inaccuracy => 'Nenatančnost';

  @override
  String get moveTimes => 'Časi za poteze';

  @override
  String get flipBoard => 'Obrni igralno desko';

  @override
  String get threefoldRepetition => 'Trikratna ponovitev';

  @override
  String get claimADraw => 'Zahtevaj remi';

  @override
  String get offerDraw => 'Ponudi remi';

  @override
  String get draw => 'Remi';

  @override
  String get drawByMutualAgreement => 'Remi po dogovoru';

  @override
  String get fiftyMovesWithoutProgress => '50 potez brez napredka';

  @override
  String get currentGames => 'Trenutno igrane igre';

  @override
  String get viewInFullSize => 'Pogled v polni velikosti';

  @override
  String get logOut => 'Odjava';

  @override
  String get signIn => 'Prijava';

  @override
  String get rememberMe => 'Zapomni si me';

  @override
  String get youNeedAnAccountToDoThat => 'Za to dejanje potrebuješ račun';

  @override
  String get signUp => 'Registracija';

  @override
  String get computersAreNotAllowedToPlay => 'Računalniška pomoč ni dovoljena. Prosimo da med igro ne uporabljate računalniških programov, baz ali pridobivate pomoč ostalih igralcev. Uporabnik, ki ustvarja več zaporednih uporabniških računov bo onemogočen.';

  @override
  String get games => 'Igre';

  @override
  String get forum => 'Forum';

  @override
  String xPostedInForumY(String param1, String param2) {
    return '$param1 poslal v temo $param2';
  }

  @override
  String get latestForumPosts => 'Zadnje objave na forumu';

  @override
  String get players => 'Igralci';

  @override
  String get friends => 'Prijatelji';

  @override
  String get discussions => 'Pogovori';

  @override
  String get today => 'Danes';

  @override
  String get yesterday => 'Včeraj';

  @override
  String get minutesPerSide => 'Minut na igralca';

  @override
  String get variant => 'Različica';

  @override
  String get variants => 'Različice';

  @override
  String get timeControl => 'Ura';

  @override
  String get realTime => 'Standardno';

  @override
  String get correspondence => 'Dopisno';

  @override
  String get daysPerTurn => 'Število dni na potezo';

  @override
  String get oneDay => 'En dan';

  @override
  String get time => 'Čas';

  @override
  String get rating => 'Ocena';

  @override
  String get ratingStats => 'Statistika ratinga';

  @override
  String get username => 'Uporabniško ime';

  @override
  String get usernameOrEmail => 'Uporabniško ime ali elektronski naslov';

  @override
  String get changeUsername => 'Spremenite uporabniško ime';

  @override
  String get changeUsernameNotSame => 'Črkam je mogoče le zamenjati velikost v male ali velike tiskane. Naprimer \"janeznovak\" v \"JanezNovak\".';

  @override
  String get changeUsernameDescription => 'Spremenite svoje uporabniško ime. To je mogoče opraviti le enkrat in spremiti samo velikost tiskanih črk v male ali velike.';

  @override
  String get signupUsernameHint => 'Ne pozabite izbrati družini prijaznega uporabniškega imena. Pozneje ga ne morete spremeniti in vsa neprimerna uporabniška imena bodo zaprta!';

  @override
  String get signupEmailHint => 'Uporabljali ga bomo samo za ponastavitev gesla.';

  @override
  String get password => 'Geslo';

  @override
  String get changePassword => 'Zamenjaj geslo';

  @override
  String get changeEmail => 'Zamenjaj E-poštnega naslova';

  @override
  String get email => 'E-poštni naslov';

  @override
  String get passwordReset => 'Ponovna nastavitev gesla';

  @override
  String get forgotPassword => 'Ste pozabili geslo?';

  @override
  String get error_weakPassword => 'To geslo je zelo pogosto in ga je prelahko uganiti.';

  @override
  String get error_namePassword => 'Prosimo, ne uporabljajte svojega uporabniškega imena kot gesla.';

  @override
  String get blankedPassword => 'Isto geslo ste uporabili na drugem spletnem mestu in to spletno mesto je bilo prizadeto. Da bi zagotovili varnost vašega računa Lichess, morate določiti novo geslo. Zahvaljujemo se vam za razumevanje.';

  @override
  String get youAreLeavingLichess => 'Zapuščate Lichess';

  @override
  String get neverTypeYourPassword => 'Nikoli ne vnesite svojega gesla za Lichess na drugem mestu!';

  @override
  String proceedToX(String param) {
    return 'Nadaljujte na $param';
  }

  @override
  String get passwordSuggestion => 'Ne nastavite gesla, ki ga predlaga nekdo drug. Uporabili ga bodo za krajo vašega računa.';

  @override
  String get emailSuggestion => 'Ne nastavite e-poštnega naslova, ki ga predlaga nekdo drug. Uporabili ga bodo za krajo vašega računa.';

  @override
  String get emailConfirmHelp => 'Pomoč za potrditev naslova elektronske pošte';

  @override
  String get emailConfirmNotReceived => 'Niste prejeli potrditvenega e-poštnega sporočila po prijavi?';

  @override
  String get whatSignupUsername => 'S katerim uporabniškim imenom ste se prijavili?';

  @override
  String usernameNotFound(String param) {
    return 'Nismo našli nobenega uporabnika s tem imenom: $param.';
  }

  @override
  String get usernameCanBeUsedForNewAccount => 'To uporabniško ime lahko uporabite za ustvarjanje novega računa';

  @override
  String emailSent(String param) {
    return 'Na naslov $param smo poslali e-poštno sporočilo.';
  }

  @override
  String get emailCanTakeSomeTime => 'Do prihoda lahko preteče nekaj časa.';

  @override
  String get refreshInboxAfterFiveMinutes => 'Počakajte 5 minut in osvežite e-poštni predal.';

  @override
  String get checkSpamFolder => 'Preverite tudi mapo za neželeno pošto, morda se znajde tam. Če je tako, jo označite kot zaželeno.';

  @override
  String get emailForSignupHelp => 'Če vse drugo ne uspe, nam pošljite to e-poštno sporočilo:';

  @override
  String copyTextToEmail(String param) {
    return 'Kopirajte in prilepite zgornje besedilo ter ga pošljite na naslov $param';
  }

  @override
  String get waitForSignupHelp => 'Kmalu vas bomo kontaktirali in vam pomagali dokončati prijavo.';

  @override
  String accountConfirmed(String param) {
    return 'Uporabnik $param je uspešno potrjen.';
  }

  @override
  String accountCanLogin(String param) {
    return 'Zdaj se lahko prijavite kot $param.';
  }

  @override
  String get accountConfirmationEmailNotNeeded => 'Ne potrebujete potrditvenega e-poštnega sporočila.';

  @override
  String accountClosed(String param) {
    return 'Račun $param je zaprt.';
  }

  @override
  String accountRegisteredWithoutEmail(String param) {
    return 'Račun $param je bil registriran brez e-pošte.';
  }

  @override
  String get rank => 'Uvrstitev';

  @override
  String rankX(String param) {
    return 'Uvrstitev: $param';
  }

  @override
  String get gamesPlayed => 'Odigranih iger';

  @override
  String get cancel => 'Prekliči';

  @override
  String get whiteTimeOut => 'Belemu se je čas iztekel';

  @override
  String get blackTimeOut => 'Črnemu se je čas iztekel';

  @override
  String get drawOfferSent => 'Predlog za remi poslan';

  @override
  String get drawOfferAccepted => 'Predlog za remi sprejet';

  @override
  String get drawOfferCanceled => 'Predlog za remi preklican';

  @override
  String get whiteOffersDraw => 'Beli predlaga remi';

  @override
  String get blackOffersDraw => 'Črni predlaga remi';

  @override
  String get whiteDeclinesDraw => 'Beli zavrnil remi';

  @override
  String get blackDeclinesDraw => 'Črni zavrnil remi';

  @override
  String get yourOpponentOffersADraw => 'Nasprotnik predlaga remi';

  @override
  String get accept => 'Sprejmi';

  @override
  String get decline => 'Zavrni';

  @override
  String get playingRightNow => 'Trenutno se igra';

  @override
  String get eventInProgress => 'Pravkar poteka';

  @override
  String get finished => 'Končano';

  @override
  String get abortGame => 'Opusti igro';

  @override
  String get gameAborted => 'Igra je opuščena';

  @override
  String get standard => 'Običajno';

  @override
  String get customPosition => 'Položaj po meri';

  @override
  String get unlimited => 'Neomejeno';

  @override
  String get mode => 'Način';

  @override
  String get casual => 'Nerangirano';

  @override
  String get rated => 'Rangirano';

  @override
  String get casualTournament => 'Nerangiran';

  @override
  String get ratedTournament => 'Rangiran';

  @override
  String get thisGameIsRated => 'Igra je rangirana';

  @override
  String get rematch => 'Revanša';

  @override
  String get rematchOfferSent => 'Ponudba za revanšo poslana';

  @override
  String get rematchOfferAccepted => 'Ponudba za revanšo sprejeta';

  @override
  String get rematchOfferCanceled => 'Ponudba za revanšo prekinjena';

  @override
  String get rematchOfferDeclined => 'Ponudba za revanšo zavnjena';

  @override
  String get cancelRematchOffer => 'Prekliči ponudbo za revanšo';

  @override
  String get viewRematch => 'Poglej revanšo';

  @override
  String get confirmMove => 'Potrdite potezo';

  @override
  String get play => 'Igraj';

  @override
  String get inbox => 'Sporočila';

  @override
  String get chatRoom => 'Klepetalnica';

  @override
  String get loginToChat => 'Prijavi se v klepet';

  @override
  String get youHaveBeenTimedOut => 'Dostop do klepeta je trenutno zavrnjen.';

  @override
  String get spectatorRoom => 'Soba za gledalce';

  @override
  String get composeMessage => 'Sestavi sporočilo';

  @override
  String get subject => 'Zadeva';

  @override
  String get send => 'Pošlji';

  @override
  String get incrementInSeconds => 'Dodan čas na potezo v sekundah';

  @override
  String get freeOnlineChess => 'Brezplačni internetni šah';

  @override
  String get exportGames => 'Izvozi igre';

  @override
  String get ratingRange => 'Razpon ocene';

  @override
  String get thisAccountViolatedTos => 'Uporabnik tega računa je kršil pogoje uporabe Lichessa';

  @override
  String get openingExplorerAndTablebase => 'Odpri brskalnik otvoritev & baz';

  @override
  String get takeback => 'Popravek poteze';

  @override
  String get proposeATakeback => 'Zaprosi za popravek poteze';

  @override
  String get takebackPropositionSent => 'Prošnja za popravek poteze poslana';

  @override
  String get takebackPropositionDeclined => 'Prošnja za popravek poteze zavrnjena';

  @override
  String get takebackPropositionAccepted => 'Prošnja za popravek poteze sprejeta';

  @override
  String get takebackPropositionCanceled => 'Prošnja za popravek poteze preklicana';

  @override
  String get yourOpponentProposesATakeback => 'Nasprotnik prosi za popravek poteze';

  @override
  String get bookmarkThisGame => 'Označi partijo';

  @override
  String get tournament => 'Turnir';

  @override
  String get tournaments => 'Turnirji';

  @override
  String get tournamentPoints => 'Turnirske točke';

  @override
  String get viewTournament => 'Glej turnir';

  @override
  String get backToTournament => 'Nazaj k turnirju';

  @override
  String get noDrawBeforeSwissLimit => 'V Švicarskem turnirju ni mogoče remizirati pred 30. potezo.';

  @override
  String get thematic => 'Tematski';

  @override
  String yourPerfRatingIsProvisional(String param) {
    return 'Vaš $param rating je začasen';
  }

  @override
  String yourPerfRatingIsTooHigh(String param1, String param2) {
    return 'Vaš $param1 rating ($param2) je previsok';
  }

  @override
  String yourTopWeeklyPerfRatingIsTooHigh(String param1, String param2) {
    return 'Vaš najvišji $param1 rating ($param2) v tem tednu, je previsok';
  }

  @override
  String yourPerfRatingIsTooLow(String param1, String param2) {
    return 'Vaš $param1 rating ($param2) je prenizek';
  }

  @override
  String ratedMoreThanInPerf(String param1, String param2) {
    return 'Rating ≥ $param1 v $param2';
  }

  @override
  String ratedLessThanInPerf(String param1, String param2) {
    return 'Rating ≤ $param1 v $param2';
  }

  @override
  String mustBeInTeam(String param) {
    return 'Morate biti v ekipi $param';
  }

  @override
  String youAreNotInTeam(String param) {
    return 'Niste v ekipi $param';
  }

  @override
  String get backToGame => 'Vrni se v igro';

  @override
  String get siteDescription => 'Brezplačni internetni šah. Igraj šah na enostavnem vmesniku. Brez registracije, brez reklam in brez dodatnih vtičnikov. Igraj šah proti računalniku, prijatelju ali naključnemu nasprotniku.';

  @override
  String xJoinedTeamY(String param1, String param2) {
    return '$param1 se je pridružil ekipi $param2';
  }

  @override
  String xCreatedTeamY(String param1, String param2) {
    return '$param1 je ustvaril ekipo $param2';
  }

  @override
  String get startedStreaming => 'je pričel s prenosom';

  @override
  String xStartedStreaming(String param) {
    return '$param je pričel z prenosom';
  }

  @override
  String get averageElo => 'Povprečen rating';

  @override
  String get location => 'Lokacija';

  @override
  String get filterGames => 'Filtriraj igre';

  @override
  String get reset => 'Ponastavi';

  @override
  String get apply => 'Uporabi';

  @override
  String get save => 'Shrani';

  @override
  String get leaderboard => 'Lestvica';

  @override
  String get screenshotCurrentPosition => 'Zajemi sliko trenutne pozicije';

  @override
  String get gameAsGIF => 'Partija kot GIF';

  @override
  String get pasteTheFenStringHere => 'Prilepi FEN niz sem';

  @override
  String get pasteThePgnStringHere => 'Prilepi PGN niz sem';

  @override
  String get orUploadPgnFile => 'Ali pa naložite datoteko PGN';

  @override
  String get fromPosition => 'Nastavljena pozicija';

  @override
  String get continueFromHere => 'Nadaljuj od tukaj';

  @override
  String get toStudy => 'Študiraj';

  @override
  String get importGame => 'Uvozi igro';

  @override
  String get importGameExplanation => 'Ko prilepite PGN partijo imate na voljo brskanje partije, računalniško analizo, klepet o igri in povezavo, ki jo lahko delite.';

  @override
  String get importGameCaveat => 'Variante bodo izbrisane. Če jih želite obdržat, uvozite PGN kot študijo.';

  @override
  String get importGameDataPrivacyWarning => 'Ta PGN je javno dostopen. Za zasebni uvoz igre uporabite študijo.';

  @override
  String get thisIsAChessCaptcha => 'To je test, ki loči ljudi od računalnikov';

  @override
  String get clickOnTheBoardToMakeYourMove => 'Odigraj potezo in dokaži, da nisi robot';

  @override
  String get captcha_fail => 'Prosimo, rešite ta test.';

  @override
  String get notACheckmate => 'To ni mat';

  @override
  String get whiteCheckmatesInOneMove => 'Beli matira v eni potezi';

  @override
  String get blackCheckmatesInOneMove => 'Črni matira v eni potezi';

  @override
  String get retry => 'Poskusi ponovno';

  @override
  String get reconnecting => 'Ponovno vzpostavljanje povezave';

  @override
  String get noNetwork => 'Brez povezave';

  @override
  String get favoriteOpponents => 'Priljubljeni nasprotniki';

  @override
  String get follow => 'Sledi';

  @override
  String get following => 'Igralcu že sledite';

  @override
  String get unfollow => 'Nehajte slediti';

  @override
  String followX(String param) {
    return 'Sledite $param';
  }

  @override
  String unfollowX(String param) {
    return 'Prenehaj spremljati $param';
  }

  @override
  String get block => 'Blokiraj';

  @override
  String get blocked => 'Blokiran';

  @override
  String get unblock => 'Odblokiraj';

  @override
  String get followsYou => 'Sledi vam';

  @override
  String xStartedFollowingY(String param1, String param2) {
    return '$param1 je začel slediti $param2';
  }

  @override
  String get more => 'Več';

  @override
  String get memberSince => 'Član od';

  @override
  String lastSeenActive(String param) {
    return 'Zadnja prijava $param';
  }

  @override
  String get player => 'Igralec';

  @override
  String get list => 'Seznam';

  @override
  String get graph => 'Graf';

  @override
  String get required => 'Zahtevano';

  @override
  String get openTournaments => 'Odprti turnirji';

  @override
  String get duration => 'Trajanje';

  @override
  String get winner => 'Zmagovalec';

  @override
  String get standing => 'Lestvica';

  @override
  String get createANewTournament => 'Ustvari turnir';

  @override
  String get tournamentCalendar => 'Turnirski koledar';

  @override
  String get conditionOfEntry => 'Vstopni pogoji:';

  @override
  String get advancedSettings => 'Napredne nastavitve';

  @override
  String get safeTournamentName => 'Izberite zelo varno ime za turnir.';

  @override
  String get inappropriateNameWarning => 'Že zelo majhna neprimernost lahko povzroči ukinitev vašega računa.';

  @override
  String get emptyTournamentName => 'Pustite prazno, da bo turnir imenovan po naključnem velemojstru.';

  @override
  String get makePrivateTournament => 'Naredi turnir zaseben in zaščiti dostop z geslom';

  @override
  String get join => 'Pridruži se';

  @override
  String get withdraw => 'Zapusti turnir';

  @override
  String get points => 'Točke';

  @override
  String get wins => 'Zmage';

  @override
  String get losses => 'Porazi';

  @override
  String get createdBy => 'Ustvaril';

  @override
  String get tournamentIsStarting => 'Turnir se začenja';

  @override
  String get tournamentPairingsAreNowClosed => 'Pari turnirja so zaključeni.';

  @override
  String standByX(String param) {
    return '$param počakajte. Delajo se pari, bodite pripravljeni!';
  }

  @override
  String get pause => 'Premor';

  @override
  String get resume => 'Nadaljuj';

  @override
  String get youArePlaying => 'Igraš!';

  @override
  String get winRate => 'Delež zmag';

  @override
  String get berserkRate => 'Delež divjanja';

  @override
  String get performance => 'Izkazan rating';

  @override
  String get tournamentComplete => 'Turnir je zaključen';

  @override
  String get movesPlayed => 'Odigranih potez';

  @override
  String get whiteWins => 'Belih zmag';

  @override
  String get blackWins => 'Črnih zmag';

  @override
  String get drawRate => 'Stopnja remija';

  @override
  String get draws => 'Odstotek remijev';

  @override
  String nextXTournament(String param) {
    return 'Naslednji $param turnir:';
  }

  @override
  String get averageOpponent => 'Povprečen nasprotnik';

  @override
  String get boardEditor => 'Urejevalec igralne površine';

  @override
  String get setTheBoard => 'Uredi šahovnico';

  @override
  String get popularOpenings => 'Popularne otvoritve';

  @override
  String get endgamePositions => 'Položaji končnice';

  @override
  String chess960StartPosition(String param) {
    return 'Šah 960 začetna pozicija: $param';
  }

  @override
  String get startPosition => 'Začetna pozicija';

  @override
  String get clearBoard => 'Počisti igralno površino';

  @override
  String get loadPosition => 'Naloži pozicijo';

  @override
  String get isPrivate => 'Zasebno';

  @override
  String reportXToModerators(String param) {
    return 'Prijavi $param moderatorjem';
  }

  @override
  String profileCompletion(String param) {
    return 'Profil zaključen: $param';
  }

  @override
  String xRating(String param) {
    return '$param rating';
  }

  @override
  String get ifNoneLeaveEmpty => 'Če ni, pustite prazno';

  @override
  String get profile => 'Profil';

  @override
  String get editProfile => 'Uredi profil';

  @override
  String get realName => 'Real name';

  @override
  String get setFlair => 'Določite svoj okus';

  @override
  String get flair => 'Simbol';

  @override
  String get youCanHideFlair => 'Obstaja nastavitev za skrivanje vseh uporabniških čustev na celotnem spletnem mestu.';

  @override
  String get biography => 'Biografija';

  @override
  String get countryRegion => 'Država ali regija';

  @override
  String get thankYou => 'Hvala!';

  @override
  String get socialMediaLinks => 'Povezava za sledenje na družabnih omrežjih';

  @override
  String get oneUrlPerLine => 'En URL na vrstico.';

  @override
  String get inlineNotation => 'Dodatna notacija';

  @override
  String get makeAStudy => 'Za varno shranjevanje in deljenje razmislite o tem, da bi naredili študijo.';

  @override
  String get clearSavedMoves => 'Počisti poteze';

  @override
  String get previouslyOnLichessTV => 'Nazadnje na Lichess TV';

  @override
  String get onlinePlayers => 'Prijavljeni igralci';

  @override
  String get activePlayers => 'Aktivni igralci';

  @override
  String get bewareTheGameIsRatedButHasNoClock => 'Pozor, igra je rangirana, vendar ni časovno omejena!';

  @override
  String get success => 'Uspešno';

  @override
  String get automaticallyProceedToNextGameAfterMoving => 'Po vsaki potezi samodejno preklopi na naslednjo partijo';

  @override
  String get autoSwitch => 'Samodejno preklopi';

  @override
  String get puzzles => 'Šahovski problemi';

  @override
  String get onlineBots => 'Spletni roboti';

  @override
  String get name => 'Ime';

  @override
  String get description => 'Opis';

  @override
  String get descPrivate => 'Zasebni opis';

  @override
  String get descPrivateHelp => 'Besedilo, ki ga bodo videli samo člani ekipe. Če je nastavljen, nadomesti javni opis za člane ekipe.';

  @override
  String get no => 'Ne';

  @override
  String get yes => 'Da';

  @override
  String get help => 'Pomoč:';

  @override
  String get createANewTopic => 'Ustvari novo temo';

  @override
  String get topics => 'Teme';

  @override
  String get posts => 'Objave';

  @override
  String get lastPost => 'Zadnja objava';

  @override
  String get views => 'Ogledi';

  @override
  String get replies => 'Odgovori';

  @override
  String get replyToThisTopic => 'Objavi odgovor v tej temi';

  @override
  String get reply => 'Odgovori';

  @override
  String get message => 'Sporočilo';

  @override
  String get createTheTopic => 'Ustvari temo';

  @override
  String get reportAUser => 'Prijavi uporabnika';

  @override
  String get user => 'Uporabnik';

  @override
  String get reason => 'Razlog';

  @override
  String get whatIsIheMatter => 'Kaj je narobe?';

  @override
  String get cheat => 'Goljufija';

  @override
  String get troll => 'Provokacija';

  @override
  String get other => 'Drugo';

  @override
  String get reportDescriptionHelp => 'Prilepite povezave do igre (ali iger) in pojasnite kaj je narobe z obnašanjem uporabnika. Ne napišite samo \"uporabnik goljufa\" temveč pojasnite zakaj mislite tako. Prijava bo obdelana hitreje če bo napisana v angleščini.';

  @override
  String get error_provideOneCheatedGameLink => 'Navedite vsaj eno povezavo do igre s primerom goljufanja.';

  @override
  String by(String param) {
    return 'od $param';
  }

  @override
  String importedByX(String param) {
    return 'Uvozil je $param';
  }

  @override
  String get thisTopicIsNowClosed => 'Tema je zaprta';

  @override
  String get blog => 'Blog';

  @override
  String get notes => 'Beležke';

  @override
  String get typePrivateNotesHere => 'Piši zasebne beležke tukaj';

  @override
  String get writeAPrivateNoteAboutThisUser => 'Napišite zasebno opombo o tem uporabniku';

  @override
  String get noNoteYet => 'Ni opombe še';

  @override
  String get invalidUsernameOrPassword => 'Napačno uporabniško ime ali geslo';

  @override
  String get incorrectPassword => 'Nepravilno geslo';

  @override
  String get invalidAuthenticationCode => 'Nepravilna avtentikacijska koda';

  @override
  String get emailMeALink => 'Pošlji mi povezavo po elektronski pošti';

  @override
  String get currentPassword => 'Trenutno geslo';

  @override
  String get newPassword => 'Novo geslo';

  @override
  String get newPasswordAgain => 'Novo geslo (ponovno)';

  @override
  String get newPasswordsDontMatch => 'Novi gesli se ne ujemata';

  @override
  String get newPasswordStrength => 'Moč gesla';

  @override
  String get clockInitialTime => 'Začetni čas';

  @override
  String get clockIncrement => 'Dodatek k času';

  @override
  String get privacy => 'Zasebnost';

  @override
  String get privacyPolicy => 'Politika zasebnosti';

  @override
  String get letOtherPlayersFollowYou => 'Dovolite da vam sledijo';

  @override
  String get letOtherPlayersChallengeYou => 'Dovolite da vas izzovejo na partijo';

  @override
  String get letOtherPlayersInviteYouToStudy => 'Dovoli igralcem, da te povabijo na študij';

  @override
  String get sound => 'Zvok';

  @override
  String get none => 'Brez';

  @override
  String get fast => 'Hitro';

  @override
  String get normal => 'Normalno';

  @override
  String get slow => 'Počasno';

  @override
  String get insideTheBoard => 'Znotraj šahovnice';

  @override
  String get outsideTheBoard => 'Zunaj šahovnice';

  @override
  String get allSquaresOfTheBoard => 'All squares of the board';

  @override
  String get onSlowGames => 'Pri počasnih igrah';

  @override
  String get always => 'Vedno';

  @override
  String get never => 'Nikoli';

  @override
  String xCompetesInY(String param1, String param2) {
    return '$param1 tekmuje v $param2';
  }

  @override
  String get victory => 'Zmaga';

  @override
  String get defeat => 'Poraz';

  @override
  String victoryVsYInZ(String param1, String param2, String param3) {
    return '$param1 proti $param2 v $param3';
  }

  @override
  String defeatVsYInZ(String param1, String param2, String param3) {
    return '$param1 proti $param2 v $param3';
  }

  @override
  String drawVsYInZ(String param1, String param2, String param3) {
    return '$param1 proti $param2 v $param3';
  }

  @override
  String get timeline => 'Časovni trak';

  @override
  String get starting => 'Začetek:';

  @override
  String get allInformationIsPublicAndOptional => 'Vsi podatki so vidni in niso obvezni.';

  @override
  String get biographyDescription => 'Povej o sebi, kaj ti je všeč pri šahu, najljubše otvoritve, partije, igralci…';

  @override
  String get listBlockedPlayers => 'Seznam igralcev, ki si jih blokiral';

  @override
  String get human => 'Človek';

  @override
  String get computer => 'Računalnik';

  @override
  String get side => 'Stran';

  @override
  String get clock => 'Ura';

  @override
  String get opponent => 'Nasprotnik';

  @override
  String get learnMenu => 'Treniraj';

  @override
  String get studyMenu => 'Študiraj';

  @override
  String get practice => 'Vaja';

  @override
  String get community => 'Skupnost';

  @override
  String get tools => 'Orodja';

  @override
  String get increment => 'Dodatek';

  @override
  String get error_unknown => 'Neveljavna vrednost';

  @override
  String get error_required => 'To polje je obvezno';

  @override
  String get error_email => 'E-poštni naslov ni veljaven';

  @override
  String get error_email_acceptable => 'Elektronski naslov ni sprejemljiv. Prosim, preverite ga in poskusite ponovno.';

  @override
  String get error_email_unique => 'E-poštni naslov je že zaseden';

  @override
  String get error_email_different => 'To je že vaš e-poštni naslov';

  @override
  String error_minLength(String param) {
    return 'Mora imeti vsaj $param znakov';
  }

  @override
  String error_maxLength(String param) {
    return 'Mora imeti vsaj $param znakov';
  }

  @override
  String error_min(String param) {
    return 'Biti mora vsaj $param';
  }

  @override
  String error_max(String param) {
    return 'Mora biti največ $param';
  }

  @override
  String ifRatingIsPlusMinusX(String param) {
    return 'Če je rating ± $param';
  }

  @override
  String get ifRegistered => 'Registrirani';

  @override
  String get onlyExistingConversations => 'Samo obstoječi pogovori';

  @override
  String get onlyFriends => 'Samo prijatelji';

  @override
  String get menu => 'Meni';

  @override
  String get castling => 'Rokada';

  @override
  String get whiteCastlingKingside => 'Beli O-O';

  @override
  String get blackCastlingKingside => 'Črni O-O';

  @override
  String tpTimeSpentPlaying(String param) {
    return 'Čas igranja: $param';
  }

  @override
  String get watchGames => 'Glej partije';

  @override
  String tpTimeSpentOnTV(String param) {
    return 'Čas na TV: $param';
  }

  @override
  String get watch => 'Glej';

  @override
  String get videoLibrary => 'Videoteka';

  @override
  String get streamersMenu => 'Voditelji prenosov';

  @override
  String get mobileApp => 'Mobilna aplikacija';

  @override
  String get webmasters => 'Razvijalci';

  @override
  String get about => 'O';

  @override
  String aboutX(String param) {
    return 'O $param';
  }

  @override
  String xIsAFreeYLibreOpenSourceChessServer(String param1, String param2) {
    return '$param1 je brezplačen ($param2), svoboden, brez oglasov, odprtokoden šahovski strežnik.';
  }

  @override
  String get really => 'resnično';

  @override
  String get contribute => 'Prispevaj';

  @override
  String get termsOfService => 'Pogoji uporabe';

  @override
  String get sourceCode => 'Izvorna koda';

  @override
  String get simultaneousExhibitions => 'Simultanke';

  @override
  String get host => 'Gostitelj';

  @override
  String hostColorX(String param) {
    return 'Gostiteljeva barva:$param';
  }

  @override
  String get yourPendingSimuls => 'Vaše čakajoče simultanke';

  @override
  String get createdSimuls => 'Novo ustvarjene simultanke';

  @override
  String get hostANewSimul => 'Gostuj novo simultanko';

  @override
  String get signUpToHostOrJoinASimul => 'Prijavite se za gostovanje ali se pridružite simultanki';

  @override
  String get noSimulFound => 'Simultanka ni najdena';

  @override
  String get noSimulExplanation => 'Ta simultanka ne obstaja.';

  @override
  String get returnToSimulHomepage => 'Vrni se na domačo stran simultanke';

  @override
  String get aboutSimul => 'Simultanka je igra enega proti več igralcem hkrati.';

  @override
  String get aboutSimulImage => 'Proti 50 nasprotnikom, je Fischer zabeležil 47 zmag, 2 remija ter 1 poraz.';

  @override
  String get aboutSimulRealLife => 'Koncept je vzet iz vsakdanjega življenja. V realnem svetu se igralec premika od šahovnice do šahovnice in odigra eno potezo.';

  @override
  String get aboutSimulRules => 'V simultanki ima igralec-gostitelj zmeraj bele figure. Simultanka se zaključi, ko so vse partije končane.';

  @override
  String get aboutSimulSettings => 'Simultanke so zmeraj nerangirane. Revanše, popravki potez in dodajanje časa niso možni.';

  @override
  String get create => 'Ustvari';

  @override
  String get whenCreateSimul => 'Ko ustvariš simultanko, boš igral z več nasprotniki hkrati.';

  @override
  String get simulVariantsHint => 'Če si izbral več variant, vsak igralec izbere katero varianto bo igral.';

  @override
  String get simulClockHint => 'Fischerjeva nastavitev ure. Več igralcev kot sprejmeš, več časa boš morda potreboval.';

  @override
  String get simulAddExtraTime => 'Uri lahko dodaš več časa v pomoč pri igranju simultanke.';

  @override
  String get simulHostExtraTime => 'Dodaten čas za gostitelja';

  @override
  String get simulAddExtraTimePerPlayer => 'Dodajte začetni čas svoji uri za vsakega igralca, ki se pridruži simultanki.';

  @override
  String get simulHostExtraTimePerPlayer => 'Gostite dodatni čas na igralca';

  @override
  String get lichessTournaments => 'Lichess turnirji';

  @override
  String get tournamentFAQ => 'Turnirji - odgovori na pogosta vprašanja';

  @override
  String get timeBeforeTournamentStarts => 'Čas do začetka turnirja';

  @override
  String get averageCentipawnLoss => 'Povprečna izguba stotin kmeta';

  @override
  String get accuracy => 'Natančnost';

  @override
  String get keyboardShortcuts => 'Bližnjice na tipkovnici';

  @override
  String get keyMoveBackwardOrForward => 'pomik naprej/nazaj';

  @override
  String get keyGoToStartOrEnd => 'pojdi na začetek/konec';

  @override
  String get keyCycleSelectedVariation => 'Cycle selected variation';

  @override
  String get keyShowOrHideComments => 'pokaži/skrij komentarje';

  @override
  String get keyEnterOrExitVariation => 'vstopi/izstopi v varianto';

  @override
  String get keyRequestComputerAnalysis => 'Zahtevajte računalniško analizo, učite se iz svojih napak';

  @override
  String get keyNextLearnFromYourMistakes => 'Naslednji (Učite se iz svojih napak)';

  @override
  String get keyNextBlunder => 'Naslednji spodrsljaj';

  @override
  String get keyNextMistake => 'Naslednja napaka';

  @override
  String get keyNextInaccuracy => 'Naslednja nepravilnost';

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
  String get togglePositionAnnotations => 'Preklop opomb o položaju';

  @override
  String get variationArrowsInfo => 'Variation arrows let you navigate without using the move list.';

  @override
  String get playSelectedMove => 'play selected move';

  @override
  String get newTournament => 'Nov turnir';

  @override
  String get tournamentHomeTitle => 'Turnir z možnostjo različnih variant in različnih igralnih časov';

  @override
  String get tournamentHomeDescription => 'Igraj turnirje z hitrim tempom! Pridruži se uradnemu turnirju ali ustvari svoj turnir. Hitropotezno, Pospešeno, Klasično, Šah960, Trojni šah in ostale možnosti so na voljo za neskončno šahovsko zabavo.';

  @override
  String get tournamentNotFound => 'Turnir ni najden';

  @override
  String get tournamentDoesNotExist => 'Ta turnir ne obstaja.';

  @override
  String get tournamentMayHaveBeenCanceled => 'Lahko je odpovedan, če so vsi igralci zapustili turnir preden se je začel.';

  @override
  String get returnToTournamentsHomepage => 'Vrni se na domačo stran turnirjev';

  @override
  String weeklyPerfTypeRatingDistribution(String param) {
    return 'Mesečna porazdelitev $param ratinga';
  }

  @override
  String yourPerfTypeRatingIsRating(String param1, String param2) {
    return 'Tvoj $param1 rating je $param2.';
  }

  @override
  String youAreBetterThanPercentOfPerfTypePlayers(String param1, String param2) {
    return 'Boljši si od $param1 $param2 igralcev.';
  }

  @override
  String userIsBetterThanPercentOfPerfTypePlayers(String param1, String param2, String param3) {
    return '$param1 je boljši od $param2 igralcev $param3.';
  }

  @override
  String betterThanPercentPlayers(String param1, String param2) {
    return 'Bolje kot $param1 od $param2 igralcev';
  }

  @override
  String youDoNotHaveAnEstablishedPerfTypeRating(String param) {
    return 'Tvoj $param rating še ni uveljavljen.';
  }

  @override
  String get yourRating => 'Vaš rating';

  @override
  String get cumulative => 'Skupno';

  @override
  String get glicko2Rating => 'Glicko-2 rating';

  @override
  String get checkYourEmail => 'Preveri svoj poštni nabiralnik';

  @override
  String get weHaveSentYouAnEmailClickTheLink => 'Poslali smo ti elektronsko sporočilo. Klikni na povezavo v sporočilu za aktiviranje računa.';

  @override
  String get ifYouDoNotSeeTheEmailCheckOtherPlaces => 'Če ne vidite elektronskega sporočila, preverite druga mesta, kjer bi lahko bilo, npr. v smetnjaku ali v drugih mapah.';

  @override
  String weHaveSentYouAnEmailTo(String param) {
    return 'Elektronsko pošto smo poslali na $param. Kliknite na povezavo v emailu, da obnovite svoje geslo.';
  }

  @override
  String byRegisteringYouAgreeToBeBoundByOur(String param) {
    return 'Z registracijo se strinjate z našimi $param.';
  }

  @override
  String readAboutOur(String param) {
    return 'Preberite o naši $param.';
  }

  @override
  String get networkLagBetweenYouAndLichess => 'Omrežna zakasnitev med vami in lichessom';

  @override
  String get timeToProcessAMoveOnLichessServer => 'Čas za obdelavo poteze na lichess strežniku';

  @override
  String get downloadAnnotated => 'Prenesi s komentarji';

  @override
  String get downloadRaw => 'Prenesi brez komentarjev';

  @override
  String get downloadImported => 'Prenesi uvoženo PGN datoteko';

  @override
  String get crosstable => 'Medsebojni dvoboji';

  @override
  String get youCanAlsoScrollOverTheBoardToMoveInTheGame => 'Lahko se skozi partijo pomikaš tudi z miško';

  @override
  String get scrollOverComputerVariationsToPreviewThem => 'Za predogled variant računalniške analize podrsajte z miškinim koleščkom.';

  @override
  String get analysisShapesHowTo => 'Pritisni shift+klik ali desni klik za risanje krožcev in puščic po šahovnici';

  @override
  String get letOtherPlayersMessageYou => 'Dovoli drugim, da ti pišejo sporočila';

  @override
  String get receiveForumNotifications => 'Prejemajte obvestila, ko so omenjena na forumu';

  @override
  String get shareYourInsightsData => 'Deli svoje statistične podatke';

  @override
  String get withNobody => 'Z nikomer';

  @override
  String get withFriends => 'S prijatelji';

  @override
  String get withEverybody => 'Z vsemi';

  @override
  String get kidMode => 'Način za otroke';

  @override
  String get kidModeIsEnabled => 'Otroški način je omogočen.';

  @override
  String get kidModeExplanation => 'To je o varnosti. V načinu za otroke so vsi pogovori onemogočeni. Omogočite ta način, da otroke in šolarje zaščitite pred drugimi uporabniki na internetu.';

  @override
  String inKidModeTheLichessLogoGetsIconX(String param) {
    return 'V načinu za otroke ima lichess ikono $param in označuje da so otroci varni.';
  }

  @override
  String get askYourChessTeacherAboutLiftingKidMode => 'Vaš račun je upravljan. Vprašajte svojega učitelja šaha o dvigovalnem otroškem načinu.';

  @override
  String get enableKidMode => 'Vključite otroški način';

  @override
  String get disableKidMode => 'Izključite otroški način';

  @override
  String get security => 'Varnost';

  @override
  String get sessions => 'Seje';

  @override
  String get revokeAllSessions => 'preklic vseh sej';

  @override
  String get playChessEverywhere => 'Igraj šah kjerkoli';

  @override
  String get asFreeAsLichess => 'Brezplačen kot lichess';

  @override
  String get builtForTheLoveOfChessNotMoney => 'Razvit zaradi ljubezni do šaha, ne denarja';

  @override
  String get everybodyGetsAllFeaturesForFree => 'Vsak dobi vse funkcije zastonj';

  @override
  String get zeroAdvertisement => 'Brez oglasov';

  @override
  String get fullFeatured => 'Polna funkcionalnost';

  @override
  String get phoneAndTablet => 'Telefon in tablica';

  @override
  String get bulletBlitzClassical => 'Hitropotezno, pospešeno, klasično';

  @override
  String get correspondenceChess => 'Dopisni šah';

  @override
  String get onlineAndOfflinePlay => 'Igranje s povezavo ali brez povezave';

  @override
  String get viewTheSolution => 'Poglej rešitev';

  @override
  String get followAndChallengeFriends => 'Sledi in izzovi prijatelje';

  @override
  String get gameAnalysis => 'Analiza igre';

  @override
  String xHostsY(String param1, String param2) {
    return '$param1 gostuje $param2';
  }

  @override
  String xJoinsY(String param1, String param2) {
    return '$param1 se pridruži $param2';
  }

  @override
  String xLikesY(String param1, String param2) {
    return '$param1 všečka $param2';
  }

  @override
  String get quickPairing => 'Hitri pari';

  @override
  String get lobby => 'Dvorana';

  @override
  String get anonymous => 'Anonimen';

  @override
  String yourScore(String param) {
    return 'Vaš rezultat: $param';
  }

  @override
  String get language => 'Jezik';

  @override
  String get background => 'Ozadje';

  @override
  String get light => 'Svetla';

  @override
  String get dark => 'Temna';

  @override
  String get transparent => 'Prosojna';

  @override
  String get deviceTheme => 'Tema naprave';

  @override
  String get backgroundImageUrl => 'URL slike ozadja:';

  @override
  String get board => 'Šahovnica';

  @override
  String get size => 'Velikost';

  @override
  String get opacity => 'Prosojnost';

  @override
  String get brightness => 'Svetlost';

  @override
  String get hue => 'Odtenek';

  @override
  String get boardReset => 'Ponastavi barve na privzete';

  @override
  String get pieceSet => 'Figure';

  @override
  String get embedInYourWebsite => 'Vstavite v vašo internetno stran';

  @override
  String get usernameAlreadyUsed => 'Uporabniško ime je že v uporabi, prosimo izberite si drugo.';

  @override
  String get usernamePrefixInvalid => 'Uporabniško ime se mora začeti s črko.';

  @override
  String get usernameSuffixInvalid => 'Uporabniško ime se mora končati s črko ali s številko.';

  @override
  String get usernameCharsInvalid => 'Uporabniško ime sme vsebovati le črke, številke, podčrtaje in vezaje.';

  @override
  String get usernameUnacceptable => 'To uporabniško ime ni sprejemljivo.';

  @override
  String get playChessInStyle => 'Šahirajte v slogu';

  @override
  String get chessBasics => 'Šahovske osnove';

  @override
  String get coaches => 'Trenerji';

  @override
  String get invalidPgn => 'Neveljaven PGN';

  @override
  String get invalidFen => 'Neveljaven FEN';

  @override
  String get custom => 'Po meri';

  @override
  String get notifications => 'Obvestila';

  @override
  String notificationsX(String param1) {
    return 'Obvestila: $param1';
  }

  @override
  String perfRatingX(String param) {
    return 'Rating: $param';
  }

  @override
  String get practiceWithComputer => 'Vadi z računalnikom';

  @override
  String anotherWasX(String param) {
    return 'Alternativna poteza je bila tudi $param';
  }

  @override
  String bestWasX(String param) {
    return 'Najboljša poteza je bila $param';
  }

  @override
  String get youBrowsedAway => 'Odtavali ste';

  @override
  String get resumePractice => 'Nadaljujte vadbo';

  @override
  String get drawByFiftyMoves => 'Igra je bila remi po pravilu petdesetih potez.';

  @override
  String get theGameIsADraw => 'Rezultat partije je remi.';

  @override
  String get computerThinking => 'Računalnik razmišlja...';

  @override
  String get seeBestMove => 'Poglej najboljšo potezo';

  @override
  String get hideBestMove => 'Skrij najboljšo potezo';

  @override
  String get getAHint => 'Namig';

  @override
  String get evaluatingYourMove => 'Ocenjevanje poteze ...';

  @override
  String get whiteWinsGame => 'Beli je zmagal';

  @override
  String get blackWinsGame => 'Črni je zmagal';

  @override
  String get learnFromYourMistakes => 'Naučite se iz svojih napak';

  @override
  String get learnFromThisMistake => 'Naučite se iz te napake';

  @override
  String get skipThisMove => 'Preskočite to potezo';

  @override
  String get next => 'Naprej';

  @override
  String xWasPlayed(String param) {
    return '$param je igral/a';
  }

  @override
  String get findBetterMoveForWhite => 'Poišči boljšo potezo za belega';

  @override
  String get findBetterMoveForBlack => 'Poišči boljšo potezo za črnega';

  @override
  String get resumeLearning => 'Nadaljuj z učenjem';

  @override
  String get youCanDoBetter => 'Obstaja boljša poteza';

  @override
  String get tryAnotherMoveForWhite => 'Poskusi drugo potezo za belega';

  @override
  String get tryAnotherMoveForBlack => 'Poskusi drugo potezo za črnega';

  @override
  String get solution => 'Rešitev';

  @override
  String get waitingForAnalysis => 'Čakanje na analizo';

  @override
  String get noMistakesFoundForWhite => 'Za belega ni bilo najdenih napak';

  @override
  String get noMistakesFoundForBlack => 'Za črnega ni bilo najdenih napak';

  @override
  String get doneReviewingWhiteMistakes => 'Pregledovanje napak belega je končano';

  @override
  String get doneReviewingBlackMistakes => 'Pregledovanje napak črnega je končano';

  @override
  String get doItAgain => 'Naredi še enkrat';

  @override
  String get reviewWhiteMistakes => 'Pregled napak belega';

  @override
  String get reviewBlackMistakes => 'Pregled napak črnega';

  @override
  String get advantage => 'Prednost';

  @override
  String get opening => 'Otvoritev';

  @override
  String get middlegame => 'Sredina igre';

  @override
  String get endgame => 'Končnica';

  @override
  String get conditionalPremoves => 'Pogojne predpoteze';

  @override
  String get addCurrentVariation => 'Dodaj trenutno varianto';

  @override
  String get playVariationToCreateConditionalPremoves => 'Igrajte varianto, za ustvarjanje pogojnih predpotez';

  @override
  String get noConditionalPremoves => 'Ni pogojnih predpotez';

  @override
  String playX(String param) {
    return 'Odigrajte $param';
  }

  @override
  String get showUnreadLichessMessage => 'Prejeli ste zasebno sporočilo od Lichess.';

  @override
  String get clickHereToReadIt => 'Kliknite tukaj, če ga želite prebrati';

  @override
  String get sorry => 'Oprostite :(';

  @override
  String get weHadToTimeYouOutForAWhile => 'Morali smo vas za nekaj časa onemogočiti.';

  @override
  String get why => 'Zakaj?';

  @override
  String get pleasantChessExperience => 'Želimo, da imajo z igranjem vsi prijetno izkušnjo.';

  @override
  String get goodPractice => 'Da bi to dosegli, moramo zagotoviti, da se vsi igralci držijo dobre prakse.';

  @override
  String get potentialProblem => 'Ko zaznamo možno težavo, se prikaže to sporočilo.';

  @override
  String get howToAvoidThis => 'Kako se izogniti temu?';

  @override
  String get playEveryGame => 'Odigrajte vsako igro, ki jo začnete.';

  @override
  String get tryToWin => 'Poskusite zmagati (ali vsaj remizirati) vsako igro, ki jo igrate.';

  @override
  String get resignLostGames => 'Predajte izgubljene partije (ne čakajte, da se šahovska ura izteče).';

  @override
  String get temporaryInconvenience => 'Opravičujemo se vam za začasno neprijetnost,';

  @override
  String get wishYouGreatGames => 'in vam želimo prijetno igranje na lichess.org.';

  @override
  String get thankYouForReading => 'Hvala vam za branje!';

  @override
  String get lifetimeScore => 'Dosedanji rezultat';

  @override
  String get currentMatchScore => 'Rezultat trenutne tekme';

  @override
  String get agreementAssistance => 'Strinjam se, da ne bom nikoli uporabljal pomoči med partijo (od računalnika, knjige, podatkovne baze ali od druge osebe).';

  @override
  String get agreementNice => 'Strinjam se, da bom do drugih vedno prijazen.';

  @override
  String agreementMultipleAccounts(String param) {
    return 'Strinjam se, da ne bom ustvaril več računov (razen iz razlogov, navedenih v $param).';
  }

  @override
  String get agreementPolicy => 'Strinjam se, da bom spoštoval vsa pravila Lichess strani.';

  @override
  String get searchOrStartNewDiscussion => 'Poišči ali prični nov pogovor';

  @override
  String get edit => 'Uredi';

  @override
  String get bullet => 'Hitri šah';

  @override
  String get blitz => 'Hitropotezni šah';

  @override
  String get rapid => 'Pospešeni';

  @override
  String get classical => 'Klasični šah';

  @override
  String get ultraBulletDesc => 'Noro hitre igre: manj kot 30 sekund';

  @override
  String get bulletDesc => 'Zelo hitre igre: manj kot 3 minute';

  @override
  String get blitzDesc => 'Hitre igre: med 3 in 8 minutami';

  @override
  String get rapidDesc => 'Pospešene igre: od 8 do 25 minut';

  @override
  String get classicalDesc => 'Klasične partije: 25 minut in več';

  @override
  String get correspondenceDesc => 'Dopisne igre: dan ali več za potezo';

  @override
  String get puzzleDesc => 'Trening šahovskih taktik';

  @override
  String get important => 'Pomembno';

  @override
  String yourQuestionMayHaveBeenAnswered(String param1) {
    return 'Odgovor na vaše vprašanje, je lahko že v $param1';
  }

  @override
  String get inTheFAQ => 'v odgovorih na pogosta vprašanja.';

  @override
  String toReportSomeoneForCheatingOrBadBehavior(String param1) {
    return 'Za prijavo uporabnika zaradi goljufanja ali neprimernega vedenja, $param1';
  }

  @override
  String get useTheReportForm => 'uporabi prijavni obrazec';

  @override
  String toRequestSupport(String param1) {
    return 'Za zahtevo podpore, $param1';
  }

  @override
  String get tryTheContactPage => 'poskusi s stranjo za stike';

  @override
  String makeSureToRead(String param1) {
    return 'Ne pozabite prebrati $param1';
  }

  @override
  String get theForumEtiquette => 'forumski bonton';

  @override
  String get thisTopicIsArchived => 'Ta tema je arhivirana in nanjo ni mogoče več odgovarjati.';

  @override
  String joinTheTeamXToPost(String param1) {
    return 'Pridruži se ekipi $param1, da boš lahko objavljal sporočila na forumu';
  }

  @override
  String teamNamedX(String param1) {
    return 'ekipa $param1';
  }

  @override
  String get youCannotPostYetPlaySomeGames => 'Ne moreš še objavljati na forumu. Igraj nekaj iger!';

  @override
  String get subscribe => 'Naroči se';

  @override
  String get unsubscribe => 'Odjava';

  @override
  String mentionedYouInX(String param1) {
    return 'vas je omenil v \"$param1\".';
  }

  @override
  String xMentionedYouInY(String param1, String param2) {
    return '$param1 vas je omenil v \"$param2\".';
  }

  @override
  String invitedYouToX(String param1) {
    return 'vas vabi k \"$param1\".';
  }

  @override
  String xInvitedYouToY(String param1, String param2) {
    return '$param1 vas vabi v \"$param2\".';
  }

  @override
  String get youAreNowPartOfTeam => 'Zdaj ste del ekipe.';

  @override
  String youHaveJoinedTeamX(String param1) {
    return 'Pridružili ste se \"$param1\".';
  }

  @override
  String get someoneYouReportedWasBanned => 'Nekdo, za katerega ste poročali, je bil prepovedan';

  @override
  String get congratsYouWon => 'Čestitke, zmagali ste!';

  @override
  String gameVsX(String param1) {
    return 'Igra proti $param1';
  }

  @override
  String resVsX(String param1, String param2) {
    return '$param1 proti $param2';
  }

  @override
  String get lostAgainstTOSViolator => 'Izgubili ste z nekom, ki je kršil Pogoje storitev Lichess';

  @override
  String refundXpointsTimeControlY(String param1, String param2) {
    return 'Vračilo: $param1 $param2 ocenjevalne točke.';
  }

  @override
  String get timeAlmostUp => 'Čas je skoraj pošel!';

  @override
  String get clickToRevealEmailAddress => '[Kliknite, da razkrijete elektronski naslov]';

  @override
  String get download => 'Prenos';

  @override
  String get coachManager => 'Nastavitve za trenerja';

  @override
  String get streamerManager => 'Nastavitve upravitelja pretočnega predvajanja';

  @override
  String get cancelTournament => 'Prekini turnir';

  @override
  String get tournDescription => 'Opis turnirja';

  @override
  String get tournDescriptionHelp => 'Kaj posebnega želite povedati udeležencem? Poskusite, da bo kratek. Na voljo so povezave do oznak: [name] (https://url)';

  @override
  String get ratedFormHelp => 'Igre so rangirane\nin vplivajo na rejtinge igralcev';

  @override
  String get onlyMembersOfTeam => 'Samo člani ekipe';

  @override
  String get noRestriction => 'Brez omejitev';

  @override
  String get minimumRatedGames => 'Najmanjše število rangiranih iger';

  @override
  String get minimumRating => 'Najmanjši rejting';

  @override
  String get maximumWeeklyRating => 'Najvišji tedenski rejting';

  @override
  String positionInputHelp(String param) {
    return 'Prilepite veljaven FEN, da začnete vsako igro z določenega položaja.\nDeluje samo za standardne igre, ne pa tudi z različicami.\n$param lahko ustvarite položaj FEN, nato pa ga prilepite sem.\nPustite prazno, da začnete igre iz običajnega začetnega položaja.';
  }

  @override
  String get cancelSimul => 'Prekliči simultanko';

  @override
  String get simulHostcolor => 'Barva gostitelja za vsako igro';

  @override
  String get estimatedStart => 'Predvideni čas začetka';

  @override
  String simulFeatured(String param) {
    return 'Funkcija v $param';
  }

  @override
  String simulFeaturedHelp(String param) {
    return 'Pokažite svojo simultanko vsem na $param. Onemogoči za zasebne simulacije.';
  }

  @override
  String get simulDescription => 'Opis simultanke';

  @override
  String get simulDescriptionHelp => 'Kaj želite povedati udeležencem?';

  @override
  String markdownAvailable(String param) {
    return '$param je na voljo za naprednejšo skladnjo.';
  }

  @override
  String get embedsAvailable => 'Prilepite URL igre ali URL poglavja študije, da ga vdelate.';

  @override
  String get inYourLocalTimezone => 'V svojem lokalnem časovnem pasu';

  @override
  String get tournChat => 'Turnirski klepet';

  @override
  String get noChat => 'Brez klepeta';

  @override
  String get onlyTeamLeaders => 'Dovoljeno samo voditeljem ekip';

  @override
  String get onlyTeamMembers => 'Dovoljeno samo članom ekip';

  @override
  String get navigateMoveTree => 'Krmarite po drevesu potez';

  @override
  String get mouseTricks => 'Možnosti miške';

  @override
  String get toggleLocalAnalysis => 'Preklopi lokalno računalniško analizo';

  @override
  String get toggleAllAnalysis => 'Preklopi vso računalniško analizo';

  @override
  String get playComputerMove => 'Igraj najboljšo računalniško potezo';

  @override
  String get analysisOptions => 'Možnosti analize';

  @override
  String get focusChat => 'Fokus klepet';

  @override
  String get showHelpDialog => 'Show this help dialog';

  @override
  String get reopenYourAccount => 'Znova odprite svoj račun';

  @override
  String get closedAccountChangedMind => 'Če ste si premislili po zaprtju računa, imate eno možnost, da svoj račun pridobite nazaj.';

  @override
  String get onlyWorksOnce => 'To bo delovalo samo enkrat.';

  @override
  String get cantDoThisTwice => 'Če boste račun zaprli še drugič, ga ne boste mogli obnoviti.';

  @override
  String get emailAssociatedToaccount => 'E-naslov, povezan z računom';

  @override
  String get sentEmailWithLink => 'Poslali smo vam e-poštno sporočilo s povezavo.';

  @override
  String get tournamentEntryCode => 'Koda za vstop na turnir';

  @override
  String get hangOn => 'Počakaj!';

  @override
  String gameInProgress(String param) {
    return 'V teku je igra z $param.';
  }

  @override
  String get abortTheGame => 'Prekinite igro';

  @override
  String get resignTheGame => 'Predaj igro';

  @override
  String get youCantStartNewGame => 'Ne morete začeti nove igre, dokler se ta ne konča.';

  @override
  String get since => 'Od';

  @override
  String get until => 'Do';

  @override
  String get lichessDbExplanation => 'Rangirane igre, vzorčene od vseh igralcev Lichess';

  @override
  String get switchSides => 'Zamenjaj strani';

  @override
  String get closingAccountWithdrawAppeal => 'Z zaprtjem računa bo vaša pritožba umaknjena';

  @override
  String get ourEventTips => 'Naši nasveti za organizacijo dogodkov';

  @override
  String get instructions => 'Instructions';

  @override
  String get showMeEverything => 'Show me everything';

  @override
  String get lichessPatronInfo => 'Lichess je dobrodelna in popolnoma brezplačna odprtokodna programska oprema.\nVsi operativni stroški, razvoj in vsebina se financirajo izključno iz donacij uporabnikov.';

  @override
  String get nothingToSeeHere => 'Tukaj trenutno ni ničesar za videti.';

  @override
  String opponentLeftCounter(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Vaš nasprotnik je zapustil igro. Čez $count sekund lahko proglasite zmago.',
      few: 'Vaš nasprotnik je zapustil igro. Čez $count sekunde lahko proglasite zmago.',
      two: 'Vaš nasprotnik je zapustil igro. Čez $count sekundi lahko proglasite zmago.',
      one: 'Vaš nasprotnik je zapustil igro. Čez $count sekundo lahko proglasite zmago.',
    );
    return '$_temp0';
  }

  @override
  String mateInXHalfMoves(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Mat v $count pol-potezah',
      few: 'Mat v $count pol-potezah',
      two: 'Mat v $count pol-potezah',
      one: 'Mat v $count pol-potezi',
    );
    return '$_temp0';
  }

  @override
  String nbBlunders(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count napak',
      few: '$count napake',
      two: '$count napaki',
      one: '$count napaka',
    );
    return '$_temp0';
  }

  @override
  String nbMistakes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count napakic',
      few: '$count napakice',
      two: '$count napakici',
      one: '$count napakica',
    );
    return '$_temp0';
  }

  @override
  String nbInaccuracies(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count nenatančnosti',
      few: '$count nenatančnosti',
      two: '$count nenatančnosti',
      one: '$count nenatančnost',
    );
    return '$_temp0';
  }

  @override
  String nbPlayers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count igralcev',
      few: '$count igralci',
      two: '$count igralca',
      one: '$count igralec',
    );
    return '$_temp0';
  }

  @override
  String nbGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count partij',
      few: '$count partij',
      two: '$count partiji',
      one: '$count partija',
    );
    return '$_temp0';
  }

  @override
  String ratingXOverYGames(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count rating v $param2 igrah',
      few: '$count rating v $param2 igrah',
      two: '$count rating v $param2 igrah',
      one: '$count rating v $param2 igri',
    );
    return '$_temp0';
  }

  @override
  String nbBookmarks(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count zaznamki',
      few: '$count zaznamki',
      two: '$count zaznamka',
      one: '$count zaznamek',
    );
    return '$_temp0';
  }

  @override
  String nbDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count dni',
      few: '$count dni',
      two: '$count dneva',
      one: '$count dan',
    );
    return '$_temp0';
  }

  @override
  String nbHours(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ur',
      few: '$count ure',
      two: '$count uri',
      one: '$count ura',
    );
    return '$_temp0';
  }

  @override
  String nbMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count minut',
      few: '$count minute',
      two: '$count minuti',
      one: '$count minuta',
    );
    return '$_temp0';
  }

  @override
  String rankIsUpdatedEveryNbMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Uvrstitev se posodablja vsakih $count minut',
      few: 'Uvrstitev se posodablja vsake $count minute',
      two: 'Uvrstitev se posodablja vsaki $count minuti',
      one: 'Uvrstitev se posodablja vsako minuto',
    );
    return '$_temp0';
  }

  @override
  String nbPuzzles(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count problemov',
      few: '$count probleme',
      two: '$count problema',
      one: '$count problem',
    );
    return '$_temp0';
  }

  @override
  String nbGamesWithYou(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count partij s teboj',
      few: '$count partije s teboj',
      two: '$count partiji s teboj',
      one: '$count partija s teboj',
    );
    return '$_temp0';
  }

  @override
  String nbRated(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count rangiranih',
      few: '$count rangirani',
      two: '$count rangirana',
      one: '$count rangiran',
    );
    return '$_temp0';
  }

  @override
  String nbWins(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count zmag',
      few: '$count zmage',
      two: '$count zmagi',
      one: '$count zmaga',
    );
    return '$_temp0';
  }

  @override
  String nbLosses(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count porazov',
      few: '$count poraze',
      two: '$count poraza',
      one: '$count poraz',
    );
    return '$_temp0';
  }

  @override
  String nbDraws(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count remijev',
      few: '$count remije',
      two: '$count remija',
      one: '$count remi',
    );
    return '$_temp0';
  }

  @override
  String nbPlaying(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count v teku',
      few: '$count v teku',
      two: '$count v teku',
      one: '$count v teku',
    );
    return '$_temp0';
  }

  @override
  String giveNbSeconds(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Dodaj $count sekund',
      few: 'Dodaj $count sekunde',
      two: 'Dodaj $count sekundi',
      one: 'Dodaj $count sekundo',
    );
    return '$_temp0';
  }

  @override
  String nbTournamentPoints(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count turnirskih točk',
      few: '$count turnirske točke',
      two: '$count turnirski točki',
      one: '$count turnirska točko',
    );
    return '$_temp0';
  }

  @override
  String nbStudies(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count študij',
      few: '$count študije',
      two: '$count študiji',
      one: '$count študija',
    );
    return '$_temp0';
  }

  @override
  String nbSimuls(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count simultank',
      few: '$count simultanke',
      two: '$count simultanki',
      one: '$count simultanka',
    );
    return '$_temp0';
  }

  @override
  String moreThanNbRatedGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '≥ $count rangiranih partij',
      few: '≥ $count rangirane partije',
      two: '≥ $count rangirani partiji',
      one: '≥ $count rangirana partija',
    );
    return '$_temp0';
  }

  @override
  String moreThanNbPerfRatedGames(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '≥ $count $param2 rangiranih partij',
      few: '≥ $count $param2 rangirane partije',
      two: '≥ $count $param2 rangirani partiji',
      one: '≥ $count $param2 rangirana partija',
    );
    return '$_temp0';
  }

  @override
  String needNbMorePerfGames(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Odigrati morate še $count rangiranih partij $param2',
      few: 'Odigrati morate še $count rangiranih partij $param2',
      two: 'Morate odigrati še $count rangirani partiji $param2',
      one: 'Odigrati morate še $count rangiranih partij $param2',
    );
    return '$_temp0';
  }

  @override
  String needNbMoreGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Morate odigrati še $count rangiranih partij',
      few: 'Morate odigrati še $count rangirane partije',
      two: 'Morate odigrati še $count rangirani partiji',
      one: 'Morate odigrati še $count rangirano partijo',
    );
    return '$_temp0';
  }

  @override
  String nbImportedGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count uvoženih iger',
      few: '$count uvožene igre',
      two: '$count uvoženi igri',
      one: '$count uvožena igra',
    );
    return '$_temp0';
  }

  @override
  String nbFriendsOnline(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'št. prijateljev: $count',
      few: 'št. prijateljev: $count',
      two: 'Ni prijavljenih prijateljev',
      one: '$count prijatelj je prijavljen',
    );
    return '$_temp0';
  }

  @override
  String nbFollowers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count sledilcev',
      few: '$count sledilci',
      two: '$count sledilca',
      one: 'Št. sledilcev: $count',
    );
    return '$_temp0';
  }

  @override
  String nbFollowing(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count sledijo',
      few: '$count sledijo',
      two: '$count sledita',
      one: '$count sledi',
    );
    return '$_temp0';
  }

  @override
  String lessThanNbMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Manj kot $count minut',
      few: 'Manj kot $count minute',
      two: 'Manj kot $count minuti',
      one: 'Manj kot $count minuta',
    );
    return '$_temp0';
  }

  @override
  String nbGamesInPlay(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count igranih partij',
      few: '$count igrane partije',
      two: '$count igrani partiji',
      one: '$count igrana partija',
    );
    return '$_temp0';
  }

  @override
  String maximumNbCharacters(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Največ: $count znakov.',
      few: 'Največ: $count znake.',
      two: 'Največ: $count znaka.',
      one: 'Največ: $count znak.',
    );
    return '$_temp0';
  }

  @override
  String blocks(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count blokira',
      few: '$count blokirajo',
      two: '$count blokirata',
      one: '$count blokira',
    );
    return '$_temp0';
  }

  @override
  String nbForumPosts(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count zapisov na forumu',
      few: '$count zapisi na forumu',
      two: '$count zapisa na forumu',
      one: '$count zapis na forumu',
    );
    return '$_temp0';
  }

  @override
  String nbPerfTypePlayersThisWeek(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count $param2 igralcev v tem tednu.',
      few: '$count $param2 igralci v tem tednu.',
      two: '$count $param2 igralca v tem tednu.',
      one: '$count $param2 igralec v tem tednu.',
    );
    return '$_temp0';
  }

  @override
  String availableInNbLanguages(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Na voljo v $count jezikih!',
      few: 'Na voljo v $count jezikih!',
      two: 'Na voljo v $count jezikih!',
      one: 'Na voljo v $count jeziku!',
    );
    return '$_temp0';
  }

  @override
  String nbSecondsToPlayTheFirstMove(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count sekund za prvo potezo',
      few: '$count sekunde za prvo potezo',
      two: '$count sekundi za prvo potezo',
      one: '$count sekund za prvo potezo',
    );
    return '$_temp0';
  }

  @override
  String nbSeconds(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count sekunde',
      few: '$count sekund',
      two: '$count sekundi',
      one: '$count sekunda',
    );
    return '$_temp0';
  }

  @override
  String andSaveNbPremoveLines(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'in shranite $count predpoteznih variant',
      few: 'in shranite $count predpotezne variante',
      two: 'in shranite $count predpotezni varianti',
      one: 'in shranite $count predpotezno varianto',
    );
    return '$_temp0';
  }

  @override
  String get stormMoveToStart => 'Premaknite za začetek';

  @override
  String get stormYouPlayTheWhitePiecesInAllPuzzles => 'Bele figure igrate v vseh ugankah';

  @override
  String get stormYouPlayTheBlackPiecesInAllPuzzles => 'Črne figure igrate v vseh ugankah';

  @override
  String get stormPuzzlesSolved => 'uganke rešene';

  @override
  String get stormNewDailyHighscore => 'Nov dnevni rekord!';

  @override
  String get stormNewWeeklyHighscore => 'Nov tedenski rekord!';

  @override
  String get stormNewMonthlyHighscore => 'Nov mesečni rekord!';

  @override
  String get stormNewAllTimeHighscore => 'Nov rekord vseh časov!';

  @override
  String stormPreviousHighscoreWasX(String param) {
    return 'Prejšnji rekord je bil $param';
  }

  @override
  String get stormPlayAgain => 'Igrajte ponovno';

  @override
  String stormHighscoreX(String param) {
    return 'Rekord: $param';
  }

  @override
  String get stormScore => 'Rezultat';

  @override
  String get stormMoves => 'Poteze';

  @override
  String get stormAccuracy => 'Točnost';

  @override
  String get stormCombo => 'Zaporedje pravilnih potez';

  @override
  String get stormTime => 'Čas';

  @override
  String get stormTimePerMove => 'Čas na potezo';

  @override
  String get stormHighestSolved => 'Rejting najtežje pravilno rešene uganke';

  @override
  String get stormPuzzlesPlayed => 'Igrane uganke';

  @override
  String get stormNewRun => 'Nova igra (bližnjična tipka: preslednica)';

  @override
  String get stormEndRun => 'Konec igre (bližnjična tipka: vnašalka)';

  @override
  String get stormHighscores => 'Nojboljši rezultati';

  @override
  String get stormViewBestRuns => 'Ogled najboljših iger';

  @override
  String get stormBestRunOfDay => 'Najboljša igra dneva';

  @override
  String get stormRuns => 'Igre';

  @override
  String get stormGetReady => 'Pripravite se!';

  @override
  String get stormWaitingForMorePlayers => 'Čakanje, da se pridruži več igralcev...';

  @override
  String get stormRaceComplete => 'Dirka končana!';

  @override
  String get stormSpectating => 'Gledanje';

  @override
  String get stormJoinTheRace => 'Pridruži se dirki!';

  @override
  String get stormStartTheRace => 'Začnite dirko';

  @override
  String stormYourRankX(String param) {
    return 'Tvoj rang: $param';
  }

  @override
  String get stormWaitForRematch => 'Počakajte na revanšo';

  @override
  String get stormNextRace => 'Naslednja dirka';

  @override
  String get stormJoinRematch => 'Pridružite se revanši';

  @override
  String get stormWaitingToStart => 'Čakanje na začetek';

  @override
  String get stormCreateNewGame => 'Ustvari novo igro';

  @override
  String get stormJoinPublicRace => 'Pridružite se javni tekmi';

  @override
  String get stormRaceYourFriends => 'Dirka s prijatelji';

  @override
  String get stormSkip => 'preskoči';

  @override
  String get stormSkipHelp => 'NOVO! Lahko preskočite eno potezo na dirko:';

  @override
  String get stormSkipExplanation => 'Preskočite to potezo, da ohranite svojo kombinacijo! Deluje samo enkrat na dirko.';

  @override
  String get stormFailedPuzzles => 'Neuspele uganke';

  @override
  String get stormSlowPuzzles => 'Počasne uganke';

  @override
  String get stormSkippedPuzzle => 'Skipped puzzle';

  @override
  String get stormThisWeek => 'Te teden';

  @override
  String get stormThisMonth => 'Ta mesec';

  @override
  String get stormAllTime => 'Ves čas';

  @override
  String get stormClickToReload => 'Klikni za ponovno nalaganje';

  @override
  String get stormThisRunHasExpired => 'Ta tek je potekel!';

  @override
  String get stormThisRunWasOpenedInAnotherTab => 'Ta tek je odprt v drugem zavihku!';

  @override
  String stormXRuns(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count poskusov',
      few: '$count poskusi',
      two: '$count poskusa',
      one: '1 poskus',
    );
    return '$_temp0';
  }

  @override
  String stormPlayedNbRunsOfPuzzleStorm(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Opravljenih $count poskusov $param2',
      few: 'Opravljeni $count poskusi $param2',
      two: 'Opravljena $count poskusa $param2',
      one: 'Opravljen en poskus $param2',
    );
    return '$_temp0';
  }

  @override
  String get streamerLichessStreamers => 'Lichess voditelji prenosa';

  @override
  String get studyShareAndExport => 'Deli in Izvozi podatke';

  @override
  String get studyStart => 'Začni';
}
