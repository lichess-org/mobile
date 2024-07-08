import 'package:intl/intl.dart' as intl;

import 'l10n.dart';

/// The translations for Hungarian (`hu`).
class AppLocalizationsHu extends AppLocalizations {
  AppLocalizationsHu([String locale = 'hu']) : super(locale);

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
  String get activityActivity => 'Aktivitás';

  @override
  String get activityHostedALiveStream => 'Élőben közvetített';

  @override
  String activityRankedInSwissTournament(String param1, String param2) {
    return 'Helyezés: $param1 / $param2';
  }

  @override
  String get activitySignedUp => 'Regisztrált a lichess.org-ra';

  @override
  String activitySupportedNbMonths(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'A lichess.org támogatója $count hónapja $param2-ként',
      one: 'A lichess.org támogatója $count hónapja $param2-ként',
    );
    return '$_temp0';
  }

  @override
  String activityPracticedNbPositions(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count $param2 állást gyakorolt',
      one: '$count $param2 állást gyakorolt',
    );
    return '$_temp0';
  }

  @override
  String activitySolvedNbPuzzles(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Befejezett $count taktikai feladványt',
      one: 'Megoldott $count taktikai feladványt',
    );
    return '$_temp0';
  }

  @override
  String activityPlayedNbGames(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count $param2 partit játszott',
      one: '$count $param2 partit játszott',
    );
    return '$_temp0';
  }

  @override
  String activityPostedNbMessages(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count üzenetet írt a $param2 témába',
      one: '$count üzenetet írt a $param2 témába',
    );
    return '$_temp0';
  }

  @override
  String activityPlayedNbMoves(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count lépést tett',
      one: '$count lépést tett',
    );
    return '$_temp0';
  }

  @override
  String activityInNbCorrespondenceGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count levelező játszmában',
      one: '$count levelező játszmában',
    );
    return '$_temp0';
  }

  @override
  String activityCompletedNbGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Befejezett $count levelező sakk játszmát',
      one: 'Befejezett $count levelező sakk játszmát',
    );
    return '$_temp0';
  }

  @override
  String activityFollowedNbPlayers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count játékost kezdett követni',
      one: '$count játékost kezdett követni',
    );
    return '$_temp0';
  }

  @override
  String activityGainedNbFollowers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count új követőt szerzett',
      one: '$count új követőt szerzett',
    );
    return '$_temp0';
  }

  @override
  String activityHostedNbSimuls(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count szimultán bemutatót rendezett',
      one: '$count szimultán bemutatót rendezett',
    );
    return '$_temp0';
  }

  @override
  String activityJoinedNbSimuls(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count szimultán bemutatón vett részt',
      one: '$count szimultán bemutatón vett részt',
    );
    return '$_temp0';
  }

  @override
  String activityCreatedNbStudies(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count új tanulmány',
      one: '$count új tanulmányt készített',
    );
    return '$_temp0';
  }

  @override
  String activityCompetedInNbTournaments(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count versenyen vett részt',
      one: '$count versenyen vett részt',
    );
    return '$_temp0';
  }

  @override
  String activityRankedInTournament(int count, String param2, String param3, String param4) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$param4 #$count. helyezés (felső $param2%) $param3 játszmából',
      one: '$param4 #$count. helyezés (felső $param2%) $param3 játszmából',
    );
    return '$_temp0';
  }

  @override
  String activityCompetedInNbSwissTournaments(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count svájci rendszerű versenyen vett részt',
      one: '$count svájci rendszerű versenyen vett részt',
    );
    return '$_temp0';
  }

  @override
  String activityJoinedNbTeams(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count csapathoz csatlakozott',
      one: '$count csapathoz csatlakozott',
    );
    return '$_temp0';
  }

  @override
  String get broadcastBroadcasts => 'Versenyközvetítések';

  @override
  String get broadcastLiveBroadcasts => 'Közvetítések élő versenyekről';

  @override
  String challengeChallengesX(String param1) {
    return 'Kihívások: $param1';
  }

  @override
  String get challengeChallengeToPlay => 'Kihívás játszmára';

  @override
  String get challengeChallengeDeclined => 'Kihívás elutasítva';

  @override
  String get challengeChallengeAccepted => 'Kihívás elfogadva!';

  @override
  String get challengeChallengeCanceled => 'Kihívás visszavonva.';

  @override
  String get challengeRegisterToSendChallenges => 'A kihíváshoz regisztráció szükséges.';

  @override
  String challengeYouCannotChallengeX(String param) {
    return '$param nem kihívható.';
  }

  @override
  String challengeXDoesNotAcceptChallenges(String param) {
    return '$param nem fogad kihívásokat.';
  }

  @override
  String challengeYourXRatingIsTooFarFromY(String param1, String param2) {
    return 'Túl nagy az eltérés $param2 és a te $param1 pontszámod között.';
  }

  @override
  String challengeCannotChallengeDueToProvisionalXRating(String param) {
    return 'Nem kihívható az ideiglenes $param pontszám miatt.';
  }

  @override
  String challengeXOnlyAcceptsChallengesFromFriends(String param) {
    return '$param csak barátoktól fogad kihívást.';
  }

  @override
  String get challengeDeclineGeneric => 'Jelenleg nem fogadok kihívásokat.';

  @override
  String get challengeDeclineLater => 'Számomra ez nem a legmegfelelőbb időpont, talán majd máskor.';

  @override
  String get challengeDeclineTooFast => 'Ez az időkorlát nekem túl gyors, kérlek küldj egy új kihívást lassabb játszmára.';

  @override
  String get challengeDeclineTooSlow => 'Ez az időkorlát nekem túl lassú, kérlek küldj egy új kihívást gyorsabb játszmára.';

  @override
  String get challengeDeclineTimeControl => 'Nem fogadok el kihívásokat ezzel az időkorláttal.';

  @override
  String get challengeDeclineRated => 'Kérlek inkább értékelt játszmára küldj kihívást.';

  @override
  String get challengeDeclineCasual => 'Kérlek inkább nem értékelt játszmára küldj kihívást.';

  @override
  String get challengeDeclineStandard => 'Jelenleg nem fogadok kihívásokat variáns játszmákra.';

  @override
  String get challengeDeclineVariant => 'Most nincs kedvem ezt a variánst játszani.';

  @override
  String get challengeDeclineNoBot => 'Nem fogadok el kihívást botoktól.';

  @override
  String get challengeDeclineOnlyBot => 'Csak botoktól fogadok el kihívást.';

  @override
  String get challengeInviteLichessUser => 'Vagy hívj meg egy Lichess Felhasználót:';

  @override
  String get contactContact => 'Kapcsolat';

  @override
  String get contactContactLichess => 'Lépj velünk kapcsolatba';

  @override
  String get patronDonate => 'Adakozz';

  @override
  String get patronLichessPatron => 'Lichess Patron';

  @override
  String perfStatPerfStats(String param) {
    return '$param statisztika';
  }

  @override
  String get perfStatViewTheGames => 'Mutasd a játszmákat';

  @override
  String get perfStatProvisional => 'becsült';

  @override
  String get perfStatNotEnoughRatedGames => 'Nincs elegendő értékelt játszmád megbízható értékszám meghatározásához.';

  @override
  String perfStatProgressOverLastXGames(String param) {
    return 'Az utolsó $param játszma szerinti alakulás:';
  }

  @override
  String perfStatRatingDeviation(String param) {
    return 'Pontszám eltérés: $param.';
  }

  @override
  String perfStatRatingDeviationTooltip(String param1, String param2, String param3) {
    return 'Az alacsonyabb érték azt jelenti, hogy a minősítés stabilabb. $param1 feletti pontszám ideiglenesnek tekintendő. A ranglistán való szerepléshez ennek az értéknek $param2 (szokásos sakk) vagy $param3 (sakk változatok) alatt kell lennie.';
  }

  @override
  String get perfStatTotalGames => 'Összes játszma';

  @override
  String get perfStatRatedGames => 'Rangsorolt játszma';

  @override
  String get perfStatTournamentGames => 'Verseny játszma';

  @override
  String get perfStatBerserkedGames => 'Berserk játszma';

  @override
  String get perfStatTimeSpentPlaying => 'Játékkal töltött idő';

  @override
  String get perfStatAverageOpponent => 'Ellenfelek átlaga';

  @override
  String get perfStatVictories => 'Győzelmek';

  @override
  String get perfStatDefeats => 'Vereségek';

  @override
  String get perfStatDisconnections => 'Szétkapcsolások';

  @override
  String get perfStatNotEnoughGames => 'Nincs elegendő játszma';

  @override
  String perfStatHighestRating(String param) {
    return 'Legmagasabb pontszám: $param';
  }

  @override
  String perfStatLowestRating(String param) {
    return 'Legalacsonyabb pontszám: $param';
  }

  @override
  String perfStatFromXToY(String param1, String param2) {
    return '$param1-tól $param2-ig';
  }

  @override
  String get perfStatWinningStreak => 'Győztes sorozat';

  @override
  String get perfStatLosingStreak => 'Vesztes sorozat';

  @override
  String perfStatLongestStreak(String param) {
    return 'Leghosszabb sorozat: $param';
  }

  @override
  String perfStatCurrentStreak(String param) {
    return 'Jelenlegi sorozat: $param';
  }

  @override
  String get perfStatBestRated => 'Legjobb győzelmek';

  @override
  String get perfStatGamesInARow => 'Egymás után játszott partik';

  @override
  String get perfStatLessThanOneHour => 'Kevesebb, mint egy óra játszmák között';

  @override
  String get perfStatMaxTimePlaying => 'Legtöbb játékkal töltött idő';

  @override
  String get perfStatNow => 'most';

  @override
  String get preferencesPreferences => 'Testreszabás';

  @override
  String get preferencesDisplay => 'Megjelenés';

  @override
  String get preferencesPrivacy => 'Adatvédelem';

  @override
  String get preferencesNotifications => 'Értesítések';

  @override
  String get preferencesPieceAnimation => 'Bábuk animációja';

  @override
  String get preferencesMaterialDifference => 'Bábuk közötti különbség';

  @override
  String get preferencesBoardHighlights => 'Kiemelés a táblán (utolsó lépés és sakk)';

  @override
  String get preferencesPieceDestinations => 'A figurák érkezési mezői (érvényes lépések és előre bevitt lépések)';

  @override
  String get preferencesBoardCoordinates => 'Tábla koordináták (A-H, 1-8)';

  @override
  String get preferencesMoveListWhilePlaying => 'Lépéslista játék közben';

  @override
  String get preferencesPgnPieceNotation => 'Lépés jelölése';

  @override
  String get preferencesChessPieceSymbol => 'Sakkbábu ikonja';

  @override
  String get preferencesPgnLetter => 'Betű (K, Q, R, B, N)';

  @override
  String get preferencesZenMode => 'Zen mód';

  @override
  String get preferencesShowPlayerRatings => 'Játékosok értékszámának megjelenítése';

  @override
  String get preferencesShowFlairs => 'Show player flairs';

  @override
  String get preferencesExplainShowPlayerRatings => 'Elrejthető a játékosok értékszáma, hogy könnyebb legyen a játékra koncentrálni. A játszmák ettől függetlenül lehetnek értékeltek, ez csak a megjelenítésre vonatkozik.';

  @override
  String get preferencesDisplayBoardResizeHandle => 'Átméretező sarok mutatása';

  @override
  String get preferencesOnlyOnInitialPosition => 'Csak kezdőállásnál';

  @override
  String get preferencesInGameOnly => 'Csak játék közben';

  @override
  String get preferencesChessClock => 'Sakkóra';

  @override
  String get preferencesTenthsOfSeconds => 'Tizedmásodpercek';

  @override
  String get preferencesWhenTimeRemainingLessThanTenSeconds => 'Amikor a hátralévő idő < 10 másodperc';

  @override
  String get preferencesHorizontalGreenProgressBars => 'Vízszintes zöld folyamatjelző';

  @override
  String get preferencesSoundWhenTimeGetsCritical => 'Figyelmeztető hang, ha nagyon kevés idő maradt';

  @override
  String get preferencesGiveMoreTime => 'Több idő adása';

  @override
  String get preferencesGameBehavior => 'Játék működése';

  @override
  String get preferencesHowDoYouMovePieces => 'Hogyan mozgatod a bábukat?';

  @override
  String get preferencesClickTwoSquares => 'Kattintással';

  @override
  String get preferencesDragPiece => 'Egérhúzással';

  @override
  String get preferencesBothClicksAndDrag => 'Mindkettő';

  @override
  String get preferencesPremovesPlayingDuringOpponentTurn => 'Előre megadott lépések (amíg az ellenfél van soron)';

  @override
  String get preferencesTakebacksWithOpponentApproval => 'Visszalépés (az ellenfél beleegyezésével)';

  @override
  String get preferencesInCasualGamesOnly => 'Csak rangosorolás nélküli játékok esetén';

  @override
  String get preferencesPromoteToQueenAutomatically => 'Gyalog automatikus előléptetése vezérré';

  @override
  String get preferencesExplainPromoteToQueenAutomatically => 'Gyalogátváltozáskor tartsd lenyomva a <ctrl> billentyűt, hogy a gyalog ne változzon át automatikusan';

  @override
  String get preferencesWhenPremoving => 'Előre meghatározott lépés esetén';

  @override
  String get preferencesClaimDrawOnThreefoldRepetitionAutomatically => 'Háromszori ismétlés esetén automatikus döntetlen igénylése';

  @override
  String get preferencesWhenTimeRemainingLessThanThirtySeconds => 'Ha a hátralévő idő < 30 másodperc';

  @override
  String get preferencesMoveConfirmation => 'Lépés jóváhagyatása';

  @override
  String get preferencesExplainCanThenBeTemporarilyDisabled => 'Játék közben a tábla melletti menüvel kikapcsolható';

  @override
  String get preferencesInCorrespondenceGames => 'Levelező mérkőzés';

  @override
  String get preferencesCorrespondenceAndUnlimited => 'Távjáték és korlátlan';

  @override
  String get preferencesConfirmResignationAndDrawOffers => 'Feladás és döntetlen kérelem megerősítése';

  @override
  String get preferencesCastleByMovingTheKingTwoSquaresOrOntoTheRook => 'Sáncolás módja';

  @override
  String get preferencesCastleByMovingTwoSquares => 'Király mozog két mezőt';

  @override
  String get preferencesCastleByMovingOntoTheRook => 'Király mozog a bástyára';

  @override
  String get preferencesInputMovesWithTheKeyboard => 'Lépések bevitele a billentyűzettel';

  @override
  String get preferencesInputMovesWithVoice => 'Lépj a hangod segítségével';

  @override
  String get preferencesSnapArrowsToValidMoves => 'Nyilak illesztése a szabályos lépésekhez';

  @override
  String get preferencesSayGgWpAfterLosingOrDrawing => '\"Good game, well played\" üzenet küldése döntetlen vagy vereség esetén';

  @override
  String get preferencesYourPreferencesHaveBeenSaved => 'Beállítások elmentve.';

  @override
  String get preferencesScrollOnTheBoardToReplayMoves => 'Lépések visszajátszása görgetéssel';

  @override
  String get preferencesCorrespondenceEmailNotification => 'Napi email a folyamatban lévő levelezős játszmákról';

  @override
  String get preferencesNotifyStreamStart => 'Egy streamer műsort ad';

  @override
  String get preferencesNotifyInboxMsg => 'Új üzenet';

  @override
  String get preferencesNotifyForumMention => 'Megemlítenek a fórumon';

  @override
  String get preferencesNotifyInvitedStudy => 'Meghívó tanulmányba';

  @override
  String get preferencesNotifyGameEvent => 'Levelező mérkőzés';

  @override
  String get preferencesNotifyChallenge => 'Kihívás';

  @override
  String get preferencesNotifyTournamentSoon => 'Hamarosan kezdődő verseny';

  @override
  String get preferencesNotifyTimeAlarm => 'Hamarosan lejár az idő levelezős játszmában';

  @override
  String get preferencesNotifyBell => 'Hangjelzés a Lichessen belül';

  @override
  String get preferencesNotifyPush => 'Értesítés mobileszközön, amikor nem vagy fenn Lichessen';

  @override
  String get preferencesNotifyWeb => 'Böngésző';

  @override
  String get preferencesNotifyDevice => 'Eszköz';

  @override
  String get preferencesBellNotificationSound => 'Hangjelzés';

  @override
  String get puzzlePuzzles => 'Feladványok';

  @override
  String get puzzlePuzzleThemes => 'Feladvány témák';

  @override
  String get puzzleRecommended => 'Ajánlott';

  @override
  String get puzzlePhases => 'Szakaszok';

  @override
  String get puzzleMotifs => 'Motívumok';

  @override
  String get puzzleAdvanced => 'Haladó';

  @override
  String get puzzleLengths => 'Hossz';

  @override
  String get puzzleMates => 'Matt';

  @override
  String get puzzleGoals => 'Célok';

  @override
  String get puzzleOrigin => 'Forrás';

  @override
  String get puzzleSpecialMoves => 'Különleges lépések';

  @override
  String get puzzleDidYouLikeThisPuzzle => 'Tetszett ez a feladvány?';

  @override
  String get puzzleVoteToLoadNextOne => 'Szavazz egy újért cserébe!';

  @override
  String get puzzleUpVote => 'Tetszett';

  @override
  String get puzzleDownVote => 'Nem tetszett';

  @override
  String get puzzleYourPuzzleRatingWillNotChange => 'A feladvány értékelésed nem fog változni. Ne feledd, a feladványoknak nincs tétje. Az értékelésed csupán segít kiválasztani az aktuális szintednek legjobban megfelelőket.';

  @override
  String get puzzleFindTheBestMoveForWhite => 'Találd meg világos legjobb lépését.';

  @override
  String get puzzleFindTheBestMoveForBlack => 'Találd meg sötét legjobb lépését.';

  @override
  String get puzzleToGetPersonalizedPuzzles => 'Személyre szóló feladványok:';

  @override
  String puzzlePuzzleId(String param) {
    return '$param. feladvány';
  }

  @override
  String get puzzlePuzzleOfTheDay => 'Napi feladvány';

  @override
  String get puzzleDailyPuzzle => 'Napi feladvány';

  @override
  String get puzzleClickToSolve => 'Katt a megoldáshoz';

  @override
  String get puzzleGoodMove => 'Jó lépés';

  @override
  String get puzzleBestMove => 'A legjobb lépés!';

  @override
  String get puzzleKeepGoing => 'Folytasd…';

  @override
  String get puzzlePuzzleSuccess => 'Siker!';

  @override
  String get puzzlePuzzleComplete => 'Kész a feladvány!';

  @override
  String get puzzleByOpenings => 'Megnyitások szerint';

  @override
  String get puzzlePuzzlesByOpenings => 'Feladványok megnyitások szerint';

  @override
  String get puzzleOpeningsYouPlayedTheMost => 'A leggyakoribb megnyitások az értékelt játszmáidból';

  @override
  String get puzzleUseFindInPage => 'Használd a böngésző \"Keresés az oldalon\" funkcióját, hogy megtaláld a kedvenc megnyitásod!';

  @override
  String get puzzleUseCtrlF => 'Ctrl+f a kedvenc megnyitásod megtalálásához!';

  @override
  String get puzzleNotTheMove => 'Nem a legjobb lépés!';

  @override
  String get puzzleTrySomethingElse => 'Próbálkozz mással.';

  @override
  String puzzleRatingX(String param) {
    return 'Pontszám: $param';
  }

  @override
  String get puzzleHidden => 'rejtett';

  @override
  String puzzleFromGameLink(String param) {
    return '$param játszmából';
  }

  @override
  String get puzzleContinueTraining => 'Gyakorlás folytatása';

  @override
  String get puzzleDifficultyLevel => 'Nehézségi szint';

  @override
  String get puzzleNormal => 'Közepes';

  @override
  String get puzzleEasier => 'Könnyű';

  @override
  String get puzzleEasiest => 'Nagyon könnyű';

  @override
  String get puzzleHarder => 'Nehéz';

  @override
  String get puzzleHardest => 'Nagyon nehéz';

  @override
  String get puzzleExample => 'Példa';

  @override
  String get puzzleAddAnotherTheme => 'Másik téma hozzáadása';

  @override
  String get puzzleNextPuzzle => 'Következő feladvány';

  @override
  String get puzzleJumpToNextPuzzleImmediately => 'Rögtön a következő feladányhoz ugrás';

  @override
  String get puzzlePuzzleDashboard => 'Feladvány áttekintő';

  @override
  String get puzzleImprovementAreas => 'Fejleszthető témák';

  @override
  String get puzzleStrengths => 'Erősségek';

  @override
  String get puzzleHistory => 'Korábbi feladványok';

  @override
  String get puzzleSolved => 'megoldva';

  @override
  String get puzzleFailed => 'sikertelen';

  @override
  String get puzzleStreakDescription => 'Oldj meg egyre nehezedő feladványokat nyerő széria építéséhez. Nincs időkorlát, szánd rá az időt. Egyetlen hibás lépés és a játéknak vége. Viszont mindig egyet átugorhatsz.';

  @override
  String puzzleYourStreakX(String param) {
    return 'Nyerő szériád: $param';
  }

  @override
  String get puzzleStreakSkipExplanation => 'Ugord át ezt a lépést a szériád megőrzéséhez! Egy menetben csak egyszer működik.';

  @override
  String get puzzleContinueTheStreak => 'Széria folytatása';

  @override
  String get puzzleNewStreak => 'Új széria';

  @override
  String get puzzleFromMyGames => 'Saját játszmáimból';

  @override
  String get puzzleLookupOfPlayer => 'Feladványok keresése más játszmáiból';

  @override
  String puzzleFromXGames(String param) {
    return 'Feladványok $param játszmáiból';
  }

  @override
  String get puzzleSearchPuzzles => 'Feladványok keresése';

  @override
  String get puzzleFromMyGamesNone => 'Nincsenek feladványaid az adatbázisban, de ez semmi rosszat nem jelent.\nJátssz rapid vagy klasszikus partikat, így nagyobb eséllyel szerepelhetnek a te játszmáid feladványai is!';

  @override
  String puzzleFromXGamesFound(String param1, String param2) {
    return '$param1 feladvány található $param2 játszmái között';
  }

  @override
  String get puzzlePuzzleDashboardDescription => 'Gyakorolj, elemezz, fejlődj';

  @override
  String puzzlePercentSolved(String param) {
    return '$param sikeres';
  }

  @override
  String get puzzleNoPuzzlesToShow => 'Oldj meg néhány feladványt a statisztika megjelenítéséhez!';

  @override
  String get puzzleImprovementAreasDescription => 'Gyakorolj ezekben a témákban, hogy erősítsd a tudásod!';

  @override
  String get puzzleStrengthDescription => 'Ezekben a témákban teljesítesz a legjobban';

  @override
  String puzzlePlayedXTimes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count beküldött megfejtés',
      one: '$count beküldött megfejtés',
    );
    return '$_temp0';
  }

  @override
  String puzzleNbPointsBelowYourPuzzleRating(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ponttal az értékszámod alatt',
      one: 'Egy ponttal az értékszámod alatt',
    );
    return '$_temp0';
  }

  @override
  String puzzleNbPointsAboveYourPuzzleRating(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ponttal az értékszámod felett',
      one: 'Egy ponttal az értékszámod felett',
    );
    return '$_temp0';
  }

  @override
  String puzzleNbPlayed(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count játszott',
      one: '$count játszott',
    );
    return '$_temp0';
  }

  @override
  String puzzleNbToReplay(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count újra',
      one: '$count újra',
    );
    return '$_temp0';
  }

  @override
  String get puzzleThemeAdvancedPawn => 'Előretört gyalog';

  @override
  String get puzzleThemeAdvancedPawnDescription => 'Egy gyalogod előretört az ellenfél térfelére és át is változhat.';

  @override
  String get puzzleThemeAdvantage => 'Előny';

  @override
  String get puzzleThemeAdvantageDescription => 'Ragadd meg a lehetőséget a döntő előny megszerzéséhez. (200cp ≤ eval ≤ 600cp)';

  @override
  String get puzzleThemeAnastasiaMate => 'Anasztázia mattja';

  @override
  String get puzzleThemeAnastasiaMateDescription => 'Egy huszár és egy bástya vagy a vezér közösen csapdába ejtik az ellenfél királyát a tábla széle és egy figurája között.';

  @override
  String get puzzleThemeArabianMate => 'Arab matt';

  @override
  String get puzzleThemeArabianMateDescription => 'Egy huszár és egy bástya közösen sarokba szorítják az ellenfél királyát.';

  @override
  String get puzzleThemeAttackingF2F7 => 'Az f2 vagy f7 támadása';

  @override
  String get puzzleThemeAttackingF2F7Description => 'Az f2 vagy f7 gyalog ellen irányuló támadás, mint például a \"sültmáj\" megnyitás.';

  @override
  String get puzzleThemeAttraction => 'Ráterelés';

  @override
  String get puzzleThemeAttractionDescription => 'Csere vagy áldozat ami elmozdítja az ellenfél figuráját egy olyan mezőre ahol újabb taktika alkalmazható.';

  @override
  String get puzzleThemeBackRankMate => 'Matt a hátsó soron';

  @override
  String get puzzleThemeBackRankMateDescription => 'Adj mattot az alapsoron ragadt királynak, mikor a saját figurái ejtik csapdába.';

  @override
  String get puzzleThemeBishopEndgame => 'Futó végjáték';

  @override
  String get puzzleThemeBishopEndgameDescription => 'Végjáték csak futókkal és gyalogokkal.';

  @override
  String get puzzleThemeBodenMate => 'Boden mattja';

  @override
  String get puzzleThemeBodenMateDescription => 'Két támadó futó az átlókat keresztezve adnak mattot a saját figurái által akadályozott királynak.';

  @override
  String get puzzleThemeCastling => 'Sáncolás';

  @override
  String get puzzleThemeCastlingDescription => 'Helyezd a királyt biztonságba és mozgósítsd a bástyát.';

  @override
  String get puzzleThemeCapturingDefender => 'A védő leütése';

  @override
  String get puzzleThemeCapturingDefenderDescription => 'Egy másik védelméhez elengedhetetlen figura leütése, így a védtelen figura a következő lépésben szabadon levehető.';

  @override
  String get puzzleThemeCrushing => 'Megsemmisítés';

  @override
  String get puzzleThemeCrushingDescription => 'Az ellenfél sakkvakságának kihasználása elsöprő előnnyé fordítható. (> 600cp)';

  @override
  String get puzzleThemeDoubleBishopMate => 'Futópár matt';

  @override
  String get puzzleThemeDoubleBishopMateDescription => 'A két futó szomszédos átlókon ad mattot a saját figurája által akadályozott királynak.';

  @override
  String get puzzleThemeDovetailMate => 'Fecskefark matt';

  @override
  String get puzzleThemeDovetailMateDescription => 'A vezér mattot ad a szomszédos mezőn álló királynak, aminek mindkét menekülési útját saját figurái foglalják el.';

  @override
  String get puzzleThemeEquality => 'Egyenlőség';

  @override
  String get puzzleThemeEqualityDescription => 'Visszatérés egy rosszabb állásból és a döntetlen vagy kiegyensúlyozott állás bebiztosítása.';

  @override
  String get puzzleThemeKingsideAttack => 'Királyszárnytámadás';

  @override
  String get puzzleThemeKingsideAttackDescription => 'Királyszárnyra sáncolt király ellen indított támadás.';

  @override
  String get puzzleThemeClearance => 'Felszabadítás';

  @override
  String get puzzleThemeClearanceDescription => 'Egy lépés, általában tempóval, amely felszabadít egy mezőt, vonalat vagy átlót egy taktika kedvéért.';

  @override
  String get puzzleThemeDefensiveMove => 'Védekező lépés';

  @override
  String get puzzleThemeDefensiveMoveDescription => 'Olyan precíz lépés vagy lépéssorozat amivel elkerülhető anyagveszteség vagy más hátrányos helyzet.';

  @override
  String get puzzleThemeDeflection => 'Elterelés';

  @override
  String get puzzleThemeDeflectionDescription => 'Egy lépés amivel az ellenfél figurája kimozdítható aktuális feladatából, például egy kulcsmező felügyelete.';

  @override
  String get puzzleThemeDiscoveredAttack => 'Felfedés';

  @override
  String get puzzleThemeDiscoveredAttackDescription => 'Egy figura mozgatása ami előzőleg egy másik figura tűzvonalában állt, például huszár elléptetése a bástya útjából.';

  @override
  String get puzzleThemeDoubleCheck => 'Kettős sakk';

  @override
  String get puzzleThemeDoubleCheckDescription => 'Két figurával történő egyidejű sakkadás amikor felfedés után az elmozdított és a korábban akadályozott figura is támadja az ellenfél királyát.';

  @override
  String get puzzleThemeEndgame => 'Végjáték';

  @override
  String get puzzleThemeEndgameDescription => 'Taktikák a játszma utolsó fázisában.';

  @override
  String get puzzleThemeEnPassantDescription => 'Az en passant szabályt kihasználó taktika, mikor egy gyalog leütheti a mellette elhaladó, alapállásból kettőt lépő ellenfél gyalogját.';

  @override
  String get puzzleThemeExposedKing => 'Kiszolgáltatott király';

  @override
  String get puzzleThemeExposedKingDescription => 'Olyan taktika, ami kihasználja a király körüli kevés védőt, gyakran matthoz vezet.';

  @override
  String get puzzleThemeFork => 'Villa';

  @override
  String get puzzleThemeForkDescription => 'Olyan lépés amivel a mozgatott figura egyszerre két ellenséges figurát támad.';

  @override
  String get puzzleThemeHangingPiece => 'Lógó figura';

  @override
  String get puzzleThemeHangingPieceDescription => 'Azok a taktikák amik védtelen vagy elégtelenül bevédett, ezért szabadon levehető figurákon alapulnak.';

  @override
  String get puzzleThemeHookMate => 'Horog matt';

  @override
  String get puzzleThemeHookMateDescription => 'Egy bástya, huszár és gyalog az ellenfél, gyalogja által akadályozott királyát körbevéve adnak mattot.';

  @override
  String get puzzleThemeInterference => 'Akadályozás';

  @override
  String get puzzleThemeInterferenceDescription => 'Egy figura mozgatása két ellenséges figura közé az egyiket vagy mindkettőt védtelenné téve, például egy huszárral belépni egy védett mezőre két bástya közé.';

  @override
  String get puzzleThemeIntermezzo => 'Köztes lépés';

  @override
  String get puzzleThemeIntermezzoDescription => 'A várt lépés megtétele helyett egy olyan lépés beszúrása, amely fenyegetésére az ellenfélnek rögtön válaszolnia kell. Ismert még \"Zwischenzug\"-nak vagy \"Intermezzo\"-nak.';

  @override
  String get puzzleThemeKnightEndgame => 'Huszár végjáték';

  @override
  String get puzzleThemeKnightEndgameDescription => 'Végjáték csak huszárokkal és gyalogokkal.';

  @override
  String get puzzleThemeLong => 'Hosszú feladvány';

  @override
  String get puzzleThemeLongDescription => 'Három lépés a megoldás.';

  @override
  String get puzzleThemeMaster => 'Mesterjátszmák';

  @override
  String get puzzleThemeMasterDescription => 'Feladványok mesterek játszmáiból.';

  @override
  String get puzzleThemeMasterVsMaster => 'Mesterek egymás ellen';

  @override
  String get puzzleThemeMasterVsMasterDescription => 'Feladványok két mester egymás elleni játszmáiból.';

  @override
  String get puzzleThemeMate => 'Matt';

  @override
  String get puzzleThemeMateDescription => 'Vidd a játszmát stílusosan.';

  @override
  String get puzzleThemeMateIn1 => 'Matt 1 lépésben';

  @override
  String get puzzleThemeMateIn1Description => 'Adj mattot egy lépésben.';

  @override
  String get puzzleThemeMateIn2 => 'Matt 2 lépésben';

  @override
  String get puzzleThemeMateIn2Description => 'Adj mattot két lépésben.';

  @override
  String get puzzleThemeMateIn3 => 'Matt 3 lépésben';

  @override
  String get puzzleThemeMateIn3Description => 'Adj mattot három lépésben.';

  @override
  String get puzzleThemeMateIn4 => 'Matt 4 lépésben';

  @override
  String get puzzleThemeMateIn4Description => 'Adj mattot négy lépésben.';

  @override
  String get puzzleThemeMateIn5 => 'Matt 5 vagy több lépésben';

  @override
  String get puzzleThemeMateIn5Description => 'Találd meg a matthoz vezető hosszabb lépéssorozatot.';

  @override
  String get puzzleThemeMiddlegame => 'Középjáték';

  @override
  String get puzzleThemeMiddlegameDescription => 'Taktikák a játszma második fázisában.';

  @override
  String get puzzleThemeOneMove => 'Egy lépéses feladvány';

  @override
  String get puzzleThemeOneMoveDescription => 'Csupán egy lépésből álló feladvány.';

  @override
  String get puzzleThemeOpening => 'Megnyitás';

  @override
  String get puzzleThemeOpeningDescription => 'Taktikák a játszma kezdeti fázisában.';

  @override
  String get puzzleThemePawnEndgame => 'Gyalogvégjáték';

  @override
  String get puzzleThemePawnEndgameDescription => 'Végjáték csak gyalogokkal.';

  @override
  String get puzzleThemePin => 'Kötés';

  @override
  String get puzzleThemePinDescription => 'A kötés, mikor egy figura nem tud ellépni anélkül, hogy felfedné az ellenfél támadását egy értékesebb figura felé.';

  @override
  String get puzzleThemePromotion => 'Átváltozás';

  @override
  String get puzzleThemePromotionDescription => 'Átváltozó vagy átváltozással fenyegető gyalog kulcsfontosságú taktika.';

  @override
  String get puzzleThemeQueenEndgame => 'Vezér végjáték';

  @override
  String get puzzleThemeQueenEndgameDescription => 'Végjáték csak vezérekkel és gyalogokkal.';

  @override
  String get puzzleThemeQueenRookEndgame => 'Vezér és bástya';

  @override
  String get puzzleThemeQueenRookEndgameDescription => 'Végjáték vezérekkel, bástyákkal és gyalogokkal.';

  @override
  String get puzzleThemeQueensideAttack => 'Vezérszárnytámadás';

  @override
  String get puzzleThemeQueensideAttackDescription => 'Vezérszárnyra sáncolt király ellen indított támadás.';

  @override
  String get puzzleThemeQuietMove => 'Csendes lépés';

  @override
  String get puzzleThemeQuietMoveDescription => 'Olyan lépés ami nem ad sakkot és nem is ütés, de védhetetlen fenyegetést készít elő egy későbbi lépéshez.';

  @override
  String get puzzleThemeRookEndgame => 'Bástya végjáték';

  @override
  String get puzzleThemeRookEndgameDescription => 'Végjáték csak bástyákkal és gyalogokkal.';

  @override
  String get puzzleThemeSacrifice => 'Áldozat';

  @override
  String get puzzleThemeSacrificeDescription => 'Olyan taktika ami enged leütni egy figurát annak érdekében, hogy később előnyre tegyen szert kényszerítő lépések által.';

  @override
  String get puzzleThemeShort => 'Rövid feladvány';

  @override
  String get puzzleThemeShortDescription => 'Két lépés a megoldás.';

  @override
  String get puzzleThemeSkewer => 'Nyárs';

  @override
  String get puzzleThemeSkewerDescription => 'Az a motívum mikor egy magasabb értékű figurát támadva az kénytelen ellépni szabaddá téve így az utat a kisebb értékű figura leütéséhez. A kötés fordítottja.';

  @override
  String get puzzleThemeSmotheredMate => 'Fojtott matt';

  @override
  String get puzzleThemeSmotheredMateDescription => 'Olyan huszárral adott matt, ahol a sakkot kapó király nem tud lépni, mert saját figurái veszik körül (fojtják meg).';

  @override
  String get puzzleThemeSuperGM => 'Szupernagymesteri játszmák';

  @override
  String get puzzleThemeSuperGMDescription => 'Feladványok a világ legjobb játékosai közötti összecsapásokból.';

  @override
  String get puzzleThemeTrappedPiece => 'Csapda';

  @override
  String get puzzleThemeTrappedPieceDescription => 'Egy figura leütése nem elkerülhető, ha nincs menekülési útja.';

  @override
  String get puzzleThemeUnderPromotion => 'Minor-átváltozás';

  @override
  String get puzzleThemeUnderPromotionDescription => 'Gyalog átváltozása huszár, futó vagy bástyára.';

  @override
  String get puzzleThemeVeryLong => 'Nagyon hosszú feladvány';

  @override
  String get puzzleThemeVeryLongDescription => 'Négy vagy több lépés a megoldáshoz.';

  @override
  String get puzzleThemeXRayAttack => 'Röntgen támadás';

  @override
  String get puzzleThemeXRayAttackDescription => 'Figura ami egy ellenséges figurán áthatolva véd vagy támad egy mezőt.';

  @override
  String get puzzleThemeZugzwang => 'Lépéskényszer';

  @override
  String get puzzleThemeZugzwangDescription => 'Az ellenfélnek kevés lehetséges lépése van, és mind csak tovább rontja a pozícióját.';

  @override
  String get puzzleThemeHealthyMix => 'Vegyes mix';

  @override
  String get puzzleThemeHealthyMixDescription => 'Egy kicsit mindenből. Nem tudod mire számíthatsz, ezért állj készen bármire! Akár egy valódi játszmában.';

  @override
  String get puzzleThemePlayerGames => 'Felhasználók játszmái';

  @override
  String get puzzleThemePlayerGamesDescription => 'A saját vagy mások játszmáiból generált feladványok keresése.';

  @override
  String puzzleThemePuzzleDownloadInformation(String param) {
    return 'Ezek a feladványok közkincsnek minősülnek és innen letölthetők: $param.';
  }

  @override
  String get searchSearch => 'Keresés';

  @override
  String get settingsSettings => 'Beállítások';

  @override
  String get settingsCloseAccount => 'Fiók zárolása';

  @override
  String get settingsManagedAccountCannotBeClosed => 'A felhasználói fiókod felügyelet alatt áll, ezért nem zárolható.';

  @override
  String get settingsClosingIsDefinitive => 'A fiók törlése végleges. Nem lehet visszavonni. Biztos vagy benne?';

  @override
  String get settingsCantOpenSimilarAccount => 'Nem fogsz tudni új fiókot nyitni ugyanezzel a névvel, még eltérő kis- és nagybetűkkel sem.';

  @override
  String get settingsChangedMindDoNotCloseAccount => 'Meggondoltam magam, mégsem zárolom a fiókomat';

  @override
  String get settingsCloseAccountExplanation => 'Biztos, hogy zárolni akarod a fiókod? A döntés végleges és visszavonhatatlan. Nem fogsz tudni belépni SOHA TÖBBÉ.';

  @override
  String get settingsThisAccountIsClosed => 'Ez a fiók zárolva van.';

  @override
  String get playWithAFriend => 'Játék egy ismerőssel';

  @override
  String get playWithTheMachine => 'Játék a gép ellen';

  @override
  String get toInviteSomeoneToPlayGiveThisUrl => 'Küldd el ezt a linket annak, akivel játszani szeretnél';

  @override
  String get gameOver => 'Játszma vége';

  @override
  String get waitingForOpponent => 'Várakozás az ellenfélre';

  @override
  String get orLetYourOpponentScanQrCode => 'Ellenfeled az itt látható QR-kód beolvasásával is csatlakozhat.';

  @override
  String get waiting => 'Várakozás';

  @override
  String get yourTurn => 'Te következel';

  @override
  String aiNameLevelAiLevel(String param1, String param2) {
    return '$param1 szint: $param2';
  }

  @override
  String get level => 'Szint';

  @override
  String get strength => 'Nehézség';

  @override
  String get toggleTheChat => 'Csevegő ki-be';

  @override
  String get chat => 'Csevegés';

  @override
  String get resign => 'Feladás';

  @override
  String get checkmate => 'Sakk-matt';

  @override
  String get stalemate => 'Patt';

  @override
  String get white => 'Világos';

  @override
  String get black => 'Sötét';

  @override
  String get asWhite => 'világossal';

  @override
  String get asBlack => 'sötéttel';

  @override
  String get randomColor => 'Véletlen szín';

  @override
  String get createAGame => 'Játék létrehozása';

  @override
  String get whiteIsVictorious => 'Világos nyert';

  @override
  String get blackIsVictorious => 'Sötét nyert';

  @override
  String get youPlayTheWhitePieces => 'Világossal fogsz játszani';

  @override
  String get youPlayTheBlackPieces => 'Sötéttel fogsz játszani';

  @override
  String get itsYourTurn => 'Te következel!';

  @override
  String get cheatDetected => 'Csalás észlelve';

  @override
  String get kingInTheCenter => 'Király a centrumban';

  @override
  String get threeChecks => 'Három sakk';

  @override
  String get raceFinished => 'A verseny befejeződött';

  @override
  String get variantEnding => 'Variáns vége';

  @override
  String get newOpponent => 'Új ellenfél';

  @override
  String get yourOpponentWantsToPlayANewGameWithYou => 'Az ellenfeled visszavágót szeretne';

  @override
  String get joinTheGame => 'Csatlakozás a játékhoz';

  @override
  String get whitePlays => 'Világos lép';

  @override
  String get blackPlays => 'Sötét lép';

  @override
  String get opponentLeftChoices => 'Úgy tűnik, az ellenfeled kilépett. Győzelmet vagy döntetlent igényelhetsz, esetleg várhatsz rá.';

  @override
  String get forceResignation => 'Győzelem igénylése';

  @override
  String get forceDraw => 'Döntetlen felajánlása';

  @override
  String get talkInChat => 'Légy udvarias másokkal!';

  @override
  String get theFirstPersonToComeOnThisUrlWillPlayWithYou => 'Az első ember, aki felkeresi ezt a címet, az lesz az ellenfeled.';

  @override
  String get whiteResigned => 'Világos feladta';

  @override
  String get blackResigned => 'Sötét feladta';

  @override
  String get whiteLeftTheGame => 'Világos elhagyta a játékot';

  @override
  String get blackLeftTheGame => 'Sötét elhagyta a játékot';

  @override
  String get whiteDidntMove => 'Világos nem lépett';

  @override
  String get blackDidntMove => 'Sötét nem lépett';

  @override
  String get requestAComputerAnalysis => 'Számítógépes elemzés kérése';

  @override
  String get computerAnalysis => 'Számítógépes elemzés';

  @override
  String get computerAnalysisAvailable => 'Számítógépes elemzés elérhető';

  @override
  String get computerAnalysisDisabled => 'Számítógépes elemzés letiltva';

  @override
  String get analysis => 'Elemzőtábla';

  @override
  String depthX(String param) {
    return '$param mélység';
  }

  @override
  String get usingServerAnalysis => 'A szerver elemzését használja';

  @override
  String get loadingEngine => 'Motor betöltése...';

  @override
  String get calculatingMoves => 'Lépések kiszámítása...';

  @override
  String get engineFailed => 'Hiba a motor betöltésekor';

  @override
  String get cloudAnalysis => 'Elemzés felhőben';

  @override
  String get goDeeper => 'Mélyebben';

  @override
  String get showThreat => 'Fenyegetés mutatása';

  @override
  String get inLocalBrowser => 'a böngészőben';

  @override
  String get toggleLocalEvaluation => 'Helyi elemzés bekapcsolása';

  @override
  String get promoteVariation => 'Változat feljebb léptetése';

  @override
  String get makeMainLine => 'Legyen ez a főváltozat';

  @override
  String get deleteFromHere => 'Törlés innentől';

  @override
  String get collapseVariations => 'Collapse variations';

  @override
  String get expandVariations => 'Expand variations';

  @override
  String get forceVariation => 'Mentés változatként';

  @override
  String get copyVariationPgn => 'PGN másolása';

  @override
  String get move => 'Lépés';

  @override
  String get variantLoss => 'Vesztő';

  @override
  String get variantWin => 'Nyerő';

  @override
  String get insufficientMaterial => 'Nincs mattadó figura';

  @override
  String get pawnMove => 'Gyaloglépés';

  @override
  String get capture => 'Ütés';

  @override
  String get close => 'Bezár';

  @override
  String get winning => 'Nyerő';

  @override
  String get losing => 'Vesztő';

  @override
  String get drawn => 'Döntetlen';

  @override
  String get unknown => 'Ismeretlen';

  @override
  String get database => 'Adatbázis';

  @override
  String get whiteDrawBlack => 'Világos / Döntetlen / Sötét';

  @override
  String averageRatingX(String param) {
    return 'Átlagos értékszám: $param';
  }

  @override
  String get recentGames => 'Legutóbbi játszmák';

  @override
  String get topGames => 'Legjobb játszmák';

  @override
  String masterDbExplanation(String param1, String param2, String param3) {
    return 'Kétmillió táblán játszott parti $param2 és $param3 között $param1 fölött rangsorolt FIDE játékosoktól';
  }

  @override
  String get dtzWithRounding => 'DTZ50\'\' kerekítéssel, a következő ütésig vagy gyalog lépésig megtett féllépések száma alapján';

  @override
  String get noGameFound => 'Nem található játszma';

  @override
  String get maxDepthReached => 'Maximális mélység elérve!';

  @override
  String get maybeIncludeMoreGamesFromThePreferencesMenu => 'Próbáltál több játszmát hozzáadni a beállítások menüben?';

  @override
  String get openings => 'Megnyitások';

  @override
  String get openingExplorer => 'Megnyitás böngésző';

  @override
  String get openingEndgameExplorer => 'Megnyitás/végjáték böngésző';

  @override
  String xOpeningExplorer(String param) {
    return '$param megnyitás böngésző';
  }

  @override
  String get playFirstOpeningEndgameExplorerMove => 'Lépd meg az első megnyitás/végjáték felfedező lépést';

  @override
  String get winPreventedBy50MoveRule => 'Az 50 lépés szabály miatt nem nyert';

  @override
  String get lossSavedBy50MoveRule => 'Az 50 lépés szabály miatt nem vesztett';

  @override
  String get winOr50MovesByPriorMistake => 'Győzelem, vagy 50 lépéses szabály korábbi hiba alapján';

  @override
  String get lossOr50MovesByPriorMistake => 'Vereség, vagy 50 lépéses szabály korábbi hiba alapján';

  @override
  String get unknownDueToRounding => 'Győzelem/vereség csak akkor garantált, ha az adatbázis által ajánlott lépéssort követték az utolsó ütés vagy gyaloglépés óta, a Syzygy tábla DTZ értékeinek lehetséges kerekítései miatt.';

  @override
  String get allSet => 'Mehet!';

  @override
  String get importPgn => 'PGN importálás';

  @override
  String get delete => 'Töröl';

  @override
  String get deleteThisImportedGame => 'Törlöd ezt az importált játszmát?';

  @override
  String get replayMode => 'Visszajátszás';

  @override
  String get realtimeReplay => 'Valós idejű';

  @override
  String get byCPL => 'CPL';

  @override
  String get openStudy => 'Tanulmány megnyitása';

  @override
  String get enable => 'Engedélyezve';

  @override
  String get bestMoveArrow => 'Legjobb lépés mutatása';

  @override
  String get showVariationArrows => 'Változatok nyilainak megjelenítése';

  @override
  String get evaluationGauge => 'Állásértékelő oldaljelzés';

  @override
  String get multipleLines => 'Több változat';

  @override
  String get cpus => 'Processzorok';

  @override
  String get memory => 'Memória';

  @override
  String get infiniteAnalysis => 'Végtelen elemzés';

  @override
  String get removesTheDepthLimit => 'Feloldja a mélységi korlátot, és melegen tartja a számítógéped';

  @override
  String get engineManager => 'Motor menedzser';

  @override
  String get blunder => 'Baklövés';

  @override
  String get mistake => 'Hiba';

  @override
  String get inaccuracy => 'Pontatlanság';

  @override
  String get moveTimes => 'Lépésidő';

  @override
  String get flipBoard => 'Tábla megfordítása';

  @override
  String get threefoldRepetition => 'Háromszori állásismétlés';

  @override
  String get claimADraw => 'Döntetlen igénylése';

  @override
  String get offerDraw => 'Döntetlen felajánlása';

  @override
  String get draw => 'Döntetlen';

  @override
  String get drawByMutualAgreement => 'Döntetlen közös megegyezés alapján';

  @override
  String get fiftyMovesWithoutProgress => 'Ötven lépés fejlemény nélkül';

  @override
  String get currentGames => 'Futó játékok';

  @override
  String get viewInFullSize => 'Teljes méret';

  @override
  String get logOut => 'Kijelentkezés';

  @override
  String get signIn => 'Bejelentkezés';

  @override
  String get rememberMe => 'Maradjak bejelentkezve';

  @override
  String get youNeedAnAccountToDoThat => 'Ehhez szükséged van egy fiókra';

  @override
  String get signUp => 'Regisztráció';

  @override
  String get computersAreNotAllowedToPlay => 'Számítógépek és számítógép segítségét igénybe vevő játékosok nem játszhatnak. Kérünk játék közben ne vegyél igénybe segítséget sakk programoktól, adatbázisoktól, vagy más játékosoktól. Több fiók készítése és használata egyszerre az oldalról való kitiltást vonja maga után.';

  @override
  String get games => 'Játszmák';

  @override
  String get forum => 'Fórum';

  @override
  String xPostedInForumY(String param1, String param2) {
    return '$param1 írt a következő témába: $param2';
  }

  @override
  String get latestForumPosts => 'Friss bejegyzések';

  @override
  String get players => 'Játékosok';

  @override
  String get friends => 'Barátok';

  @override
  String get discussions => 'Beszélgetések';

  @override
  String get today => 'Ma';

  @override
  String get yesterday => 'Tegnap';

  @override
  String get minutesPerSide => 'Perc játékosonként';

  @override
  String get variant => 'Variáns';

  @override
  String get variants => 'Variánsok';

  @override
  String get timeControl => 'Játékidő';

  @override
  String get realTime => 'Valós idő';

  @override
  String get correspondence => 'Levelező';

  @override
  String get daysPerTurn => 'Nap lépésenként';

  @override
  String get oneDay => 'Egy nap';

  @override
  String get time => 'Játékidő';

  @override
  String get rating => 'Értékszám';

  @override
  String get ratingStats => 'Értékszám statisztika';

  @override
  String get username => 'Felhasználónév';

  @override
  String get usernameOrEmail => 'Felhasználónév vagy email';

  @override
  String get changeUsername => 'Felhasználónév váltás';

  @override
  String get changeUsernameNotSame => 'Csak a kis- és nagybetűket cserélheted a névben. Például: \"gipszjakab\" - \"GipszJakab\".';

  @override
  String get changeUsernameDescription => 'Változtasd meg a felhasználó nevet. Ezt csak egyszer teheted meg és csak a kis- és nagybetű váltás engedélyezett a felhasználónévben.';

  @override
  String get signupUsernameHint => 'Mindenképpen családbarát felhasználónevet válassz. Később már nem tudod megváltoztatni, a nem helyénvaló felhasználónevek fiókját zároljuk!';

  @override
  String get signupEmailHint => 'Csak jelszó-visszaállításhoz használjuk.';

  @override
  String get password => 'Jelszó';

  @override
  String get changePassword => 'Jelszó megváltoztatása';

  @override
  String get changeEmail => 'E-mail cím megváltoztatása';

  @override
  String get email => 'E-mail cím';

  @override
  String get passwordReset => 'Jelszó visszaállítása';

  @override
  String get forgotPassword => 'Elfelejtetted a jelszavad?';

  @override
  String get error_weakPassword => 'Ez a jelszó rettentő gyakori és túl könnyű kitalálni.';

  @override
  String get error_namePassword => 'Kérjük, ne a felhasználónevedet add meg jelszónak.';

  @override
  String get blankedPassword => 'Ugyanezt a jelszót már használtad egy másik webhelyen, ami veszélybe került. A Lichess fiókod biztonsága érdekében új jelszót kell megadnod. Köszönjük megértésed.';

  @override
  String get youAreLeavingLichess => 'Elhagyja a Lichess-t';

  @override
  String get neverTypeYourPassword => 'Soha ne írja be a Lichess jelszavát más oldalon!';

  @override
  String proceedToX(String param) {
    return 'Tovább a(z) $param oldalra';
  }

  @override
  String get passwordSuggestion => 'Ne állítson be olyan jelszót, amit más ajánlott. Arra használhatják, hogy ellopják a fiókját.';

  @override
  String get emailSuggestion => 'Ne állítson be olyan email címet, amit más ajánlott. Arra használhatják, hogy ellopják a fiókját.';

  @override
  String get emailConfirmHelp => 'Segítség az e-mail megerősítéshez';

  @override
  String get emailConfirmNotReceived => 'Nem kaptad meg a megerősítő e-mailt a regisztráció után?';

  @override
  String get whatSignupUsername => 'Milyen felhasználónévvel regisztráltál?';

  @override
  String usernameNotFound(String param) {
    return 'Nem találtunk ilyen nevű felhasználót: $param.';
  }

  @override
  String get usernameCanBeUsedForNewAccount => 'Használhatod ezt a felhasználónevet új fiók létrehozásához';

  @override
  String emailSent(String param) {
    return 'Üzenetet küldtünk a $param címre.';
  }

  @override
  String get emailCanTakeSomeTime => 'Eltarthat egy ideig, amíg megérkezik.';

  @override
  String get refreshInboxAfterFiveMinutes => 'Várj 5 percet, és frissítsd az e-mail postafiókodat.';

  @override
  String get checkSpamFolder => 'Kérlek ellenőrizd a levélszemét mappát is, talán oda kerül, ebben az esetben jelöld meg nem levélszemétként.';

  @override
  String get emailForSignupHelp => 'Ha mindezek ellenére nem sikerül, küldj nekünk egy e-mailt:';

  @override
  String copyTextToEmail(String param) {
    return 'Másold ki és illeszd be a fenti szöveget, és küld el a $param címre';
  }

  @override
  String get waitForSignupHelp => 'Rövid időn belül fel fogjuk venni veled a kapcsolatot a regisztrációd befejezéséhez.';

  @override
  String accountConfirmed(String param) {
    return '$param felhasználó sikeresen megerősítve.';
  }

  @override
  String accountCanLogin(String param) {
    return 'A $param felhasználói fiókkal most már bejelentkezhetsz.';
  }

  @override
  String get accountConfirmationEmailNotNeeded => 'Az e-mail címet nem szükséges megerősíteni.';

  @override
  String accountClosed(String param) {
    return '$param felhasználói fiók zárolva van.';
  }

  @override
  String accountRegisteredWithoutEmail(String param) {
    return 'A(z) $param felhasználói fiók e-mail-cím nélkül lett regisztrálva.';
  }

  @override
  String get rank => 'Rang';

  @override
  String rankX(String param) {
    return 'Helyezés: $param';
  }

  @override
  String get gamesPlayed => 'Lejátszott játszmák';

  @override
  String get cancel => 'Mégse';

  @override
  String get whiteTimeOut => 'Világos ideje lejárt';

  @override
  String get blackTimeOut => 'Sötét ideje lejárt';

  @override
  String get drawOfferSent => 'Döntetlen felajánlva';

  @override
  String get drawOfferAccepted => 'Döntetlen elfogadva';

  @override
  String get drawOfferCanceled => 'Döntetlen ajánlás elvetve';

  @override
  String get whiteOffersDraw => 'Világos döntetlent ajánl';

  @override
  String get blackOffersDraw => 'Sötét döntetlent ajánl';

  @override
  String get whiteDeclinesDraw => 'Világos elutasította a döntetlen ajánlatot';

  @override
  String get blackDeclinesDraw => 'Sötét elutasította a döntetlen ajánlatot';

  @override
  String get yourOpponentOffersADraw => 'Az ellenfeled döntetlent ajánl';

  @override
  String get accept => 'Elfogad';

  @override
  String get decline => 'Elutasít';

  @override
  String get playingRightNow => 'Játszma folyamatban';

  @override
  String get eventInProgress => 'Éppen zajlik';

  @override
  String get finished => 'Befejezett';

  @override
  String get abortGame => 'Játszma elvetése';

  @override
  String get gameAborted => 'Játszma elvetve';

  @override
  String get standard => 'Hagyományos';

  @override
  String get customPosition => 'Tetszőleges állás';

  @override
  String get unlimited => 'Végtelen';

  @override
  String get mode => 'Mód';

  @override
  String get casual => 'Nem rangsorolt';

  @override
  String get rated => 'Rangsorolt';

  @override
  String get casualTournament => 'Nem rangsorolt';

  @override
  String get ratedTournament => 'Rangsorolt';

  @override
  String get thisGameIsRated => 'Ez egy rangsorolt játszma';

  @override
  String get rematch => 'Visszavágó';

  @override
  String get rematchOfferSent => 'Visszavágó felajánlva';

  @override
  String get rematchOfferAccepted => 'Visszavágó elfogadva';

  @override
  String get rematchOfferCanceled => 'Visszavágó lemondva';

  @override
  String get rematchOfferDeclined => 'Visszavágó elutasítva';

  @override
  String get cancelRematchOffer => 'Visszavágó lemondása';

  @override
  String get viewRematch => 'Visszavágó megtekintése';

  @override
  String get confirmMove => 'Erősítsd meg a lépést';

  @override
  String get play => 'Játék';

  @override
  String get inbox => 'Üzenetek';

  @override
  String get chatRoom => 'Csevegő';

  @override
  String get loginToChat => 'Jelentkezz be a csevegéshez';

  @override
  String get youHaveBeenTimedOut => 'Lenémítottak egy időre.';

  @override
  String get spectatorRoom => 'Figyelőszoba';

  @override
  String get composeMessage => 'Új üzenet';

  @override
  String get subject => 'Tárgy';

  @override
  String get send => 'Küldés';

  @override
  String get incrementInSeconds => 'Többletidő (másodpercben)';

  @override
  String get freeOnlineChess => 'Ingyenes Online Sakk';

  @override
  String get exportGames => 'Játszmák exportálása';

  @override
  String get ratingRange => 'Értékszámtartomány';

  @override
  String get thisAccountViolatedTos => 'Ez a fiók megsértette a Lichess Felhasználási Feltételeit';

  @override
  String get openingExplorerAndTablebase => 'Megnyitás- és állásböngésző';

  @override
  String get takeback => 'Visszalépés';

  @override
  String get proposeATakeback => 'Visszalépés kérése';

  @override
  String get takebackPropositionSent => 'Visszalépés elküldve';

  @override
  String get takebackPropositionDeclined => 'Visszalépés elutasítva';

  @override
  String get takebackPropositionAccepted => 'Visszalépés elfogadva';

  @override
  String get takebackPropositionCanceled => 'Visszalépés elvetve';

  @override
  String get yourOpponentProposesATakeback => 'Az ellenfeled vissza szeretne lépni';

  @override
  String get bookmarkThisGame => 'Játszma könyvjelzőzése';

  @override
  String get tournament => 'Verseny';

  @override
  String get tournaments => 'Versenyek';

  @override
  String get tournamentPoints => 'Verseny pont';

  @override
  String get viewTournament => 'Verseny megtekintése';

  @override
  String get backToTournament => 'Vissza a versenyhez';

  @override
  String get noDrawBeforeSwissLimit => 'Nem ajánlhatsz döntetlent 30 lépés előtt egy svájci rendszerű versenyen.';

  @override
  String get thematic => 'Tematikus';

  @override
  String yourPerfRatingIsProvisional(String param) {
    return 'A $param pontszámod ideiglenes';
  }

  @override
  String yourPerfRatingIsTooHigh(String param1, String param2) {
    return 'A $param1 pontszámod ($param2) túl magas';
  }

  @override
  String yourTopWeeklyPerfRatingIsTooHigh(String param1, String param2) {
    return 'A $param1 heti csúcs pontszámod ($param2) túl magas';
  }

  @override
  String yourPerfRatingIsTooLow(String param1, String param2) {
    return 'A $param1 pontszámod ($param2) túl alacsony';
  }

  @override
  String ratedMoreThanInPerf(String param1, String param2) {
    return '$param2 pontszám ≥ $param1';
  }

  @override
  String ratedLessThanInPerf(String param1, String param2) {
    return '$param2 pontszám ≤ $param1';
  }

  @override
  String mustBeInTeam(String param) {
    return 'Csak $param tagoknak';
  }

  @override
  String youAreNotInTeam(String param) {
    return 'Nem vagy a $param csapatban';
  }

  @override
  String get backToGame => 'Vissza a játékhoz';

  @override
  String get siteDescription => 'Ingyenes online sakkszerver letisztult kezelőfelülettel. Nem szükséges regisztráció, nincsenek hirdetések, sem telepítendő bővítmények. Játssz számítógép ellen, barátokkal vagy ismeretlen ellenfelekkel.';

  @override
  String xJoinedTeamY(String param1, String param2) {
    return '$param1 csatlakozott a következő csapathoz: $param2';
  }

  @override
  String xCreatedTeamY(String param1, String param2) {
    return '$param1 elkészítette a következő csapatot: $param2';
  }

  @override
  String get startedStreaming => 'közvetítések kezdete';

  @override
  String xStartedStreaming(String param) {
    return '$param élő műsort ad';
  }

  @override
  String get averageElo => 'Átlag értékszám';

  @override
  String get location => 'Hely';

  @override
  String get filterGames => 'Játékok szűrése';

  @override
  String get reset => 'Alaphelyzet';

  @override
  String get apply => 'Mentés';

  @override
  String get save => 'Mentés';

  @override
  String get leaderboard => 'Ranglista';

  @override
  String get screenshotCurrentPosition => 'Képernyőkép készítése a jelenlegi állásról';

  @override
  String get gameAsGIF => 'Játszma GIF-ként';

  @override
  String get pasteTheFenStringHere => 'Másold ide a FEN szöveget';

  @override
  String get pasteThePgnStringHere => 'Másold ide a PGN szöveget';

  @override
  String get orUploadPgnFile => 'Vagy tölts fel egy PGN fájlt';

  @override
  String get fromPosition => 'Adott állásból';

  @override
  String get continueFromHere => 'Folytatás innen';

  @override
  String get toStudy => 'Tanulmány';

  @override
  String get importGame => 'Játszma importálása';

  @override
  String get importGameExplanation => 'Ha PGN formátumban adsz hozzá játszmát, visszanézheted a partit, elemezheted számítógéppel, chatelhetsz és linkkel meg tudod osztani másokkal.';

  @override
  String get importGameCaveat => 'A változatok törlődnek. Ha meg akarod tartani, akkor importáld a PGN-t egy tanulmányban.';

  @override
  String get importGameDataPrivacyWarning => 'Az itt importált PGN fájl mindenki számára elérhetővé válik. Ha privátan szeretnéd a partidat importálni, akkor használd a Tanulmányok menüpontot.';

  @override
  String get thisIsAChessCaptcha => 'Ez egy sakkos CAPTCHA.';

  @override
  String get clickOnTheBoardToMakeYourMove => 'Kattints a táblára és lépj - innen tudjuk, hogy ember vagy.';

  @override
  String get captcha_fail => 'Kérünk, oldd meg a sakk captchát.';

  @override
  String get notACheckmate => 'Ez nem matt';

  @override
  String get whiteCheckmatesInOneMove => 'Világos egy lépésben mattot ad';

  @override
  String get blackCheckmatesInOneMove => 'Sötét egy lépésben mattot ad';

  @override
  String get retry => 'Újra';

  @override
  String get reconnecting => 'Újrakapcsolódás';

  @override
  String get noNetwork => 'Offline';

  @override
  String get favoriteOpponents => 'Kedvenc ellenfelek';

  @override
  String get follow => 'Követés';

  @override
  String get following => 'Követve';

  @override
  String get unfollow => 'Követés vége';

  @override
  String followX(String param) {
    return '$param követése';
  }

  @override
  String unfollowX(String param) {
    return '$param követésének kikapcsolása';
  }

  @override
  String get block => 'Letiltás';

  @override
  String get blocked => 'Letiltva';

  @override
  String get unblock => 'Letiltás feloldása';

  @override
  String get followsYou => 'Követ téged';

  @override
  String xStartedFollowingY(String param1, String param2) {
    return '$param1 $param2 követője lett';
  }

  @override
  String get more => 'Több';

  @override
  String get memberSince => 'Tagság kezdete:';

  @override
  String lastSeenActive(String param) {
    return 'Utoljára aktív: $param';
  }

  @override
  String get player => 'Játékos';

  @override
  String get list => 'Lista';

  @override
  String get graph => 'Grafikon';

  @override
  String get required => 'Kötelező.';

  @override
  String get openTournaments => 'Nyílt versenyek';

  @override
  String get duration => 'Időtartam';

  @override
  String get winner => 'Győztes';

  @override
  String get standing => 'Állás';

  @override
  String get createANewTournament => 'Új verseny indítása';

  @override
  String get tournamentCalendar => 'Versenynaptár';

  @override
  String get conditionOfEntry => 'Nevezés feltétele:';

  @override
  String get advancedSettings => 'Haladó beállítások';

  @override
  String get safeTournamentName => 'Válassz egy nevet a versenyednek.';

  @override
  String get inappropriateNameWarning => 'Akár a legkisebb pontatlanság is a fiókod zárolását eredményezheti.';

  @override
  String get emptyTournamentName => 'Hagyd üresen, ha azt szeretnéd, hogy a versenyed egy nagymesterről kapjon nevet.';

  @override
  String get makePrivateTournament => 'A torna priváttá tétele a fenti jelszóval';

  @override
  String get join => 'Csatlakozás';

  @override
  String get withdraw => 'Visszavon';

  @override
  String get points => 'Pont';

  @override
  String get wins => 'Győzelmek';

  @override
  String get losses => 'Vereségek';

  @override
  String get createdBy => 'Készítette';

  @override
  String get tournamentIsStarting => 'A verseny kezdődik';

  @override
  String get tournamentPairingsAreNowClosed => 'A verseny párosításai lezárultak.';

  @override
  String standByX(String param) {
    return 'Állj készen $param, hamarosan ellenfelet kapsz!';
  }

  @override
  String get pause => 'Szünet';

  @override
  String get resume => 'Folytatás';

  @override
  String get youArePlaying => 'Te következel!';

  @override
  String get winRate => 'Győzelmi arány';

  @override
  String get berserkRate => 'Berserk arány';

  @override
  String get performance => 'Teljesítmény';

  @override
  String get tournamentComplete => 'Verseny összefoglaló';

  @override
  String get movesPlayed => 'Lépések száma';

  @override
  String get whiteWins => 'Világos győzelmek';

  @override
  String get blackWins => 'Sötét győzelmek';

  @override
  String get drawRate => 'Döntetlenek aránya:';

  @override
  String get draws => 'Döntetlenek';

  @override
  String nextXTournament(String param) {
    return 'Következő $param verseny:';
  }

  @override
  String get averageOpponent => 'Ellenfelek átlaga';

  @override
  String get boardEditor => 'Táblaszerkesztő';

  @override
  String get setTheBoard => 'Táblaállás';

  @override
  String get popularOpenings => 'Népszerű megnyitások';

  @override
  String get endgamePositions => 'Végjáték állások';

  @override
  String chess960StartPosition(String param) {
    return 'Chess960 kezdőállás: $param';
  }

  @override
  String get startPosition => 'Alapállás';

  @override
  String get clearBoard => 'Tábla törlése';

  @override
  String get loadPosition => 'Állás betöltése';

  @override
  String get isPrivate => 'Privát';

  @override
  String reportXToModerators(String param) {
    return '$param jelentése a moderátoroknak';
  }

  @override
  String profileCompletion(String param) {
    return 'Profil teljessége: $param';
  }

  @override
  String xRating(String param) {
    return '$param értékszám';
  }

  @override
  String get ifNoneLeaveEmpty => 'Ha nincs, hagyd üresen';

  @override
  String get profile => 'Profil';

  @override
  String get editProfile => 'Profil szerkesztése';

  @override
  String get realName => 'Real name';

  @override
  String get setFlair => 'Állítsd be az ikonod';

  @override
  String get flair => 'Ikon';

  @override
  String get youCanHideFlair => 'Van egy beállítás amivel elrejtheted az összes felhasználói ikont az egész oldalon.';

  @override
  String get biography => 'Bemutatkozás';

  @override
  String get countryRegion => 'Országod vagy régiód:';

  @override
  String get thankYou => 'Köszönjük!';

  @override
  String get socialMediaLinks => 'Közösségi média';

  @override
  String get oneUrlPerLine => 'Egy URL soronként.';

  @override
  String get inlineNotation => 'Megjegyzések beszúrása';

  @override
  String get makeAStudy => 'A biztonság kedvéért és a későbbi megosztás lehetőségéért fontold meg egy tanulmány létrehozását.';

  @override
  String get clearSavedMoves => 'Lépések törlése';

  @override
  String get previouslyOnLichessTV => 'A Lichess TV korábbi műsorai';

  @override
  String get onlinePlayers => 'Online játékosok';

  @override
  String get activePlayers => 'Aktív játékosok';

  @override
  String get bewareTheGameIsRatedButHasNoClock => 'A játszma értékelt, de nincs időmérés!';

  @override
  String get success => 'Sikerült!';

  @override
  String get automaticallyProceedToNextGameAfterMoving => 'Lépés után ugrás a következő játékra';

  @override
  String get autoSwitch => 'Automatikus váltás';

  @override
  String get puzzles => 'Feladvány';

  @override
  String get onlineBots => 'Internetes botok';

  @override
  String get name => 'Név';

  @override
  String get description => 'Leírás';

  @override
  String get descPrivate => 'Privát leírás';

  @override
  String get descPrivateHelp => 'Szöveg, amit csak a csapattagok láthatnak. Kitöltés esetén lecseréli a nyilvános leírást a csapattagok számára.';

  @override
  String get no => 'Nem';

  @override
  String get yes => 'Igen';

  @override
  String get help => 'Segítség';

  @override
  String get createANewTopic => 'Új téma létrehozása';

  @override
  String get topics => 'Témák';

  @override
  String get posts => 'Hozzászólások';

  @override
  String get lastPost => 'Utolsó hozzászólás';

  @override
  String get views => 'Megtekintések';

  @override
  String get replies => 'Hozzászólások';

  @override
  String get replyToThisTopic => 'Hozzászólás';

  @override
  String get reply => 'Hozzászólás küldése';

  @override
  String get message => 'Üzenet';

  @override
  String get createTheTopic => 'Téma létrehozása';

  @override
  String get reportAUser => 'Felhasználó jelentése';

  @override
  String get user => 'Felhasználó';

  @override
  String get reason => 'Ok';

  @override
  String get whatIsIheMatter => 'Probléma meghatározása';

  @override
  String get cheat => 'Csalás';

  @override
  String get troll => 'Trollkodás';

  @override
  String get other => 'Egyéb';

  @override
  String get reportDescriptionHelp => 'Másold be a játék(ok) linkjét, és mondd el, mi a gond a játékos viselkedésével. Ne csak annyit írj, hogy \"csalt\", hanem próbáld elmondani, miből gondolod ezt. A jelentésedet hamarabb feldolgozzák, ha angolul írod.';

  @override
  String get error_provideOneCheatedGameLink => 'Kérünk, legalább adj meg linket legalább egy csalt játszmához.';

  @override
  String by(String param) {
    return 'Létrehozta: $param';
  }

  @override
  String importedByX(String param) {
    return 'Importálva $param által';
  }

  @override
  String get thisTopicIsNowClosed => 'Lezárt téma.';

  @override
  String get blog => 'Blog';

  @override
  String get notes => 'Jegyzetek';

  @override
  String get typePrivateNotesHere => 'Ide írd a saját jegyzeteidet';

  @override
  String get writeAPrivateNoteAboutThisUser => 'Jegyzet hozzáadása';

  @override
  String get noNoteYet => 'Nincsenek jegyzetek';

  @override
  String get invalidUsernameOrPassword => 'Érvénytelen felhasználónév vagy jelszó';

  @override
  String get incorrectPassword => 'Hibás jelszó';

  @override
  String get invalidAuthenticationCode => 'Érvénytelen hitelesítő kód';

  @override
  String get emailMeALink => 'Link küldése e-mailben';

  @override
  String get currentPassword => 'Jelenlegi jelszó';

  @override
  String get newPassword => 'Új jelszó';

  @override
  String get newPasswordAgain => 'Új jelszó (ismét)';

  @override
  String get newPasswordsDontMatch => 'A megadott jelszavak nem egyeznek';

  @override
  String get newPasswordStrength => 'Jelszó erőssége';

  @override
  String get clockInitialTime => 'Kiindulási idő';

  @override
  String get clockIncrement => 'Növekmény';

  @override
  String get privacy => 'Adatvédelem';

  @override
  String get privacyPolicy => 'Adatvédelmi irányelvek';

  @override
  String get letOtherPlayersFollowYou => 'Mások követhetnek téged';

  @override
  String get letOtherPlayersChallengeYou => 'Mások kihívhatnak egy játszmára';

  @override
  String get letOtherPlayersInviteYouToStudy => 'Mások meghívhatnak játszma tanulmányozásra';

  @override
  String get sound => 'Hang';

  @override
  String get none => 'Nincs';

  @override
  String get fast => 'Gyors';

  @override
  String get normal => 'Normál';

  @override
  String get slow => 'Lassú';

  @override
  String get insideTheBoard => 'A táblán belül';

  @override
  String get outsideTheBoard => 'A táblán kívül';

  @override
  String get allSquaresOfTheBoard => 'All squares of the board';

  @override
  String get onSlowGames => 'Lassú játékok esetén';

  @override
  String get always => 'Mindig';

  @override
  String get never => 'Soha';

  @override
  String xCompetesInY(String param1, String param2) {
    return '$param1 részt vett ezen a versenyen: $param2';
  }

  @override
  String get victory => 'Győzelem';

  @override
  String get defeat => 'Vereség';

  @override
  String victoryVsYInZ(String param1, String param2, String param3) {
    return '$param1 $param2 ellen $param3 játszmában';
  }

  @override
  String defeatVsYInZ(String param1, String param2, String param3) {
    return '$param1 $param2 ellen $param3 játszmában';
  }

  @override
  String drawVsYInZ(String param1, String param2, String param3) {
    return '$param1 $param2 ellen $param3 játszmában';
  }

  @override
  String get timeline => 'Idővonal';

  @override
  String get starting => 'Kezdés:';

  @override
  String get allInformationIsPublicAndOptional => 'Minden adat nyilvános, megadása nem kötelező.';

  @override
  String get biographyDescription => 'Írj valamit magadról, mit szeretsz a sakkban, melyek a kedvenc megnyitásaid, játszmáid, játékosaid…';

  @override
  String get listBlockedPlayers => 'Letiltott játékosok listázása';

  @override
  String get human => 'Ember';

  @override
  String get computer => 'Számítógép';

  @override
  String get side => 'Szín';

  @override
  String get clock => 'Óra';

  @override
  String get opponent => 'Ellenfél';

  @override
  String get learnMenu => 'Tanulás';

  @override
  String get studyMenu => 'Tanulmányok';

  @override
  String get practice => 'Gyakorlás';

  @override
  String get community => 'Közösség';

  @override
  String get tools => 'Eszközök';

  @override
  String get increment => 'Többletidő';

  @override
  String get error_unknown => 'Érvénytelen érték';

  @override
  String get error_required => 'A mező kitöltése kötelező';

  @override
  String get error_email => 'Ez az email cím érvénytelen';

  @override
  String get error_email_acceptable => 'A megadott email cím nem használható. Kérjük ellenőrizd és próbáld újra.';

  @override
  String get error_email_unique => 'Érvénytelen vagy már foglalt email cím';

  @override
  String get error_email_different => 'Már ez az email címed';

  @override
  String error_minLength(String param) {
    return 'Legalább $param karakter';
  }

  @override
  String error_maxLength(String param) {
    return 'Legfeljebb $param karakter';
  }

  @override
  String error_min(String param) {
    return 'Nagyobbnak vagy egyenlőnek kell lennie mint $param';
  }

  @override
  String error_max(String param) {
    return 'Kisebbnek vagy egyenlőnek kell lennie mint $param';
  }

  @override
  String ifRatingIsPlusMinusX(String param) {
    return 'Ha a pontszám ± $param';
  }

  @override
  String get ifRegistered => 'Csak regisztrált';

  @override
  String get onlyExistingConversations => 'Csak megkezdett csevegések';

  @override
  String get onlyFriends => 'Csak ismerősöktől';

  @override
  String get menu => 'Menü';

  @override
  String get castling => 'Sáncolás';

  @override
  String get whiteCastlingKingside => 'Világos rövidre sáncolhat';

  @override
  String get blackCastlingKingside => 'Sötét rövidre sáncolhat';

  @override
  String tpTimeSpentPlaying(String param) {
    return 'Játékkal töltött idő: $param';
  }

  @override
  String get watchGames => 'Játszmák megtekintése';

  @override
  String tpTimeSpentOnTV(String param) {
    return 'TV-n töltött idő: $param';
  }

  @override
  String get watch => 'Műsor';

  @override
  String get videoLibrary => 'Videó könyvtár';

  @override
  String get streamersMenu => 'Közvetítők';

  @override
  String get mobileApp => 'Mobil alkalmazás';

  @override
  String get webmasters => 'Webmester';

  @override
  String get about => 'Rólunk';

  @override
  String aboutX(String param) {
    return '$param névjegy';
  }

  @override
  String xIsAFreeYLibreOpenSourceChessServer(String param1, String param2) {
    return 'A $param1 egy ingyenes ($param2), szabad, reklámmentes, nyílt forráskódú sakkszerver.';
  }

  @override
  String get really => 'tényleg';

  @override
  String get contribute => 'Hozzájárul';

  @override
  String get termsOfService => 'Felhasználási feltételek';

  @override
  String get sourceCode => 'Forráskód';

  @override
  String get simultaneousExhibitions => 'Szimultán játékok';

  @override
  String get host => 'Létrehozó';

  @override
  String hostColorX(String param) {
    return 'Szimultánt adó színe: $param';
  }

  @override
  String get yourPendingSimuls => 'Folyamatban lévő szimultánjaid';

  @override
  String get createdSimuls => 'Új szimultán játékok';

  @override
  String get hostANewSimul => 'Új szimultán csata létrehozása';

  @override
  String get signUpToHostOrJoinASimul => 'Új szimultán indításához vagy egy már futóba becsatlakozáshoz regisztrálnod szükséges';

  @override
  String get noSimulFound => 'Szimultán csata nem található';

  @override
  String get noSimulExplanation => 'Ez a szimultán játék nem létezik.';

  @override
  String get returnToSimulHomepage => 'Visszatérés a szimultán játékok főoldalára';

  @override
  String get aboutSimul => 'A szimultán játékban egy játékos játszik több ellen.';

  @override
  String get aboutSimulImage => '50 ellenfél ellen, Fisher 47-szer nyert, kétszer játszott döntetlent és egyszer vesztett';

  @override
  String get aboutSimulRealLife => 'Ez a fejlesztés a való életre alapoz, ahol a szimultán játékos táblától tábláig megy és egy lépést tesz.';

  @override
  String get aboutSimulRules => 'Minden játékos a szimultánt adó játékos ellen játszik, aki a világos bábukat vezeti. A szimultán akkor ér véget, amikor az összes játszma befejeződik.';

  @override
  String get aboutSimulSettings => 'A szimultán játékok mindig fixáltak. Visszavágó, visszalépés és több idő adás funkciók nem elérhetőek.';

  @override
  String get create => 'Létrehozás';

  @override
  String get whenCreateSimul => 'Ha egy szimultánt hozol létre, több játékos ellen fogsz játszani.';

  @override
  String get simulVariantsHint => 'Ha több variánst hozol létre, minden játékos eldöntheti mihez csatlakozik.';

  @override
  String get simulClockHint => 'Fisher óra beállítás. Minél több játékossal játszol, annál több időre lesz szükség';

  @override
  String get simulAddExtraTime => 'Plusz időt adhatsz az órához, hogy a szimultán könnyebb legyen.';

  @override
  String get simulHostExtraTime => 'Időbónusz';

  @override
  String get simulAddExtraTimePerPlayer => 'A beállított idő hozzáadása az órádhoz minden szimultánhoz csatlakozó játékos után.';

  @override
  String get simulHostExtraTimePerPlayer => 'Játékosonként extra idő az órához';

  @override
  String get lichessTournaments => 'Lichess versenyek';

  @override
  String get tournamentFAQ => 'Aréna verseny GYIK';

  @override
  String get timeBeforeTournamentStarts => 'Kezdés ennyi perc múlva';

  @override
  String get averageCentipawnLoss => 'Átlagos gyalogveszteség';

  @override
  String get accuracy => 'Pontosság';

  @override
  String get keyboardShortcuts => 'Billentyű kombinációk';

  @override
  String get keyMoveBackwardOrForward => 'lépj előre/hátra';

  @override
  String get keyGoToStartOrEnd => 'menjen az elejére/végére';

  @override
  String get keyCycleSelectedVariation => 'Cycle selected variation';

  @override
  String get keyShowOrHideComments => 'kommentek megjelenítése/elrejtése';

  @override
  String get keyEnterOrExitVariation => 'ki/belépés változatba';

  @override
  String get keyRequestComputerAnalysis => 'Kérelmezz számítógépes elemzést és tanulj a hibáidból';

  @override
  String get keyNextLearnFromYourMistakes => 'Következő (Tanulj a hibáidból)';

  @override
  String get keyNextBlunder => 'Következő baklövés';

  @override
  String get keyNextMistake => 'Következő hiba';

  @override
  String get keyNextInaccuracy => 'Következő pontatlanság';

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
  String get newTournament => 'Új torna';

  @override
  String get tournamentHomeTitle => 'A sakk bajnokságokban lehetőség van különböző időbeállítások és változatok beállítására';

  @override
  String get tournamentHomeDescription => 'Vegyél részt pörgős versenyeken! Csatlakozz hivatalos versenyekhez, vagy hozz létre egyet saját magad. Bullet, Blitz, Hagyományos, Chess960, King of the Hill, Threecheck és sok más lehetőség elérhető, hogy minél jobban élvezd a sakkot.';

  @override
  String get tournamentNotFound => 'A verseny nem található';

  @override
  String get tournamentDoesNotExist => 'Ez a torna nem létezik.';

  @override
  String get tournamentMayHaveBeenCanceled => 'A versenyt törölték, mivel az összes játékos kilépett, mielőtt elkezdődött volna.';

  @override
  String get returnToTournamentsHomepage => 'Térj vissza a torna oldalára';

  @override
  String weeklyPerfTypeRatingDistribution(String param) {
    return 'Az e havi $param pontszámok eloszlása';
  }

  @override
  String yourPerfTypeRatingIsRating(String param1, String param2) {
    return 'A te $param1 pontszámod $param2';
  }

  @override
  String youAreBetterThanPercentOfPerfTypePlayers(String param1, String param2) {
    return 'Jobb vagy, mint a $param2 játékosok $param1-a.';
  }

  @override
  String userIsBetterThanPercentOfPerfTypePlayers(String param1, String param2, String param3) {
    return '$param1 jobb, mint a $param3 játékosok $param2-a.';
  }

  @override
  String betterThanPercentPlayers(String param1, String param2) {
    return 'Jobb vagy, mint a $param2 játékosok $param1 -a';
  }

  @override
  String youDoNotHaveAnEstablishedPerfTypeRating(String param) {
    return 'Még nincs meghatározott $param pontszámod.';
  }

  @override
  String get yourRating => 'Értékszámod';

  @override
  String get cumulative => 'Összesített';

  @override
  String get glicko2Rating => 'Glicko-2 pontszám';

  @override
  String get checkYourEmail => 'Ellenőrizd az email fiókod.';

  @override
  String get weHaveSentYouAnEmailClickTheLink => 'Küldtünk neked egy email-t. A fiókod aktiválásához kattints az email-ben lévő linkre.';

  @override
  String get ifYouDoNotSeeTheEmailCheckOtherPlaces => 'Ha nem látod az email-t, ellenőrizd, hogy nincs-e a szemetes, a spam vagy a közösségi mappában, vagy egyéb mappákban.';

  @override
  String weHaveSentYouAnEmailTo(String param) {
    return 'Üzenetet küldtünk a(z) $param e-mail-címre.   \nJelszavad megváltoztatásához kattints az üzenetben lévő linkre.';
  }

  @override
  String byRegisteringYouAgreeToBeBoundByOur(String param) {
    return 'A regisztrációval elfogadod a $param-t';
  }

  @override
  String readAboutOur(String param) {
    return 'Itt olvashatók az $param.';
  }

  @override
  String get networkLagBetweenYouAndLichess => 'Hálózati késleltetés a számítógéped és a Lichess szervere között';

  @override
  String get timeToProcessAMoveOnLichessServer => 'Az az idő, amíg a Lichess szerver egy lépést feldolgoz';

  @override
  String get downloadAnnotated => 'Letöltés elemzéssel';

  @override
  String get downloadRaw => 'Letöltés elemzés nélkül';

  @override
  String get downloadImported => 'Importált PGN letöltése';

  @override
  String get crosstable => 'Eredménytábla';

  @override
  String get youCanAlsoScrollOverTheBoardToMoveInTheGame => 'Görgess az egérgörgővel a tábla felett, hogy láthasd lépéseket.';

  @override
  String get scrollOverComputerVariationsToPreviewThem => 'Vidd a kurzort a számítógép variációk fölé az előnézethez.';

  @override
  String get analysisShapesHowTo => 'Shift-kattintva vagy jobb egérgombbal rajzolhatsz karikákat és nyilakat a táblára';

  @override
  String get letOtherPlayersMessageYou => 'Mások küldhetnek neked üzenetet';

  @override
  String get receiveForumNotifications => 'Értesítést kérek, ha megemlítenek a fórumban';

  @override
  String get shareYourInsightsData => 'Éleslátó adatbepillantás megosztása másokkal';

  @override
  String get withNobody => 'Senkivel';

  @override
  String get withFriends => 'Barátokkal';

  @override
  String get withEverybody => 'Mindenkivel';

  @override
  String get kidMode => 'Gyereküzemmód';

  @override
  String get kidModeIsEnabled => 'Gyermek mód aktiválva van.';

  @override
  String get kidModeExplanation => 'A Gyereküzemmód a biztonságról szól. A mód bekapcsolásával az összes kommunikáció megszűnik a többi játékossal, így megvédheted a gyermekeid vagy a diákjaid a többi felhasználó elől.';

  @override
  String inKidModeTheLichessLogoGetsIconX(String param) {
    return 'Gyereküzemmódban a Lichess logón megjelenik egy $param ikon, így tudhatod, hogy gyermekeid biztonságos felületen játszanak.';
  }

  @override
  String get askYourChessTeacherAboutLiftingKidMode => 'A felhasználói fiókodat a tanárod felügyeli. Kérd meg, hogy inaktiválja a gyerek módot.';

  @override
  String get enableKidMode => 'Gyereküzemmód bekapcsolása';

  @override
  String get disableKidMode => 'Gyereküzemmód kikapcsolása';

  @override
  String get security => 'Biztonság';

  @override
  String get sessions => 'Munkamenetek';

  @override
  String get revokeAllSessions => 'eltávolíthatod az összes eszközt';

  @override
  String get playChessEverywhere => 'Sakkozz bárhol!';

  @override
  String get asFreeAsLichess => 'Olyannyira ingyenes mint a Lichess';

  @override
  String get builtForTheLoveOfChessNotMoney => 'A sakk szeretetéért építettük, nem a pénzért';

  @override
  String get everybodyGetsAllFeaturesForFree => 'Az összes funkció ingyenes, mindenki számára';

  @override
  String get zeroAdvertisement => 'Nincsenek hirdetések';

  @override
  String get fullFeatured => 'Teljeskörű funkciók';

  @override
  String get phoneAndTablet => 'Telefon vagy táblagép';

  @override
  String get bulletBlitzClassical => 'Bullet, blitz, klasszikus';

  @override
  String get correspondenceChess => 'Levelező sakk';

  @override
  String get onlineAndOfflinePlay => 'Játssz adatkapcsolattal vagy adatkapcsolat nélkül';

  @override
  String get viewTheSolution => 'Megoldás megtekintése';

  @override
  String get followAndChallengeFriends => 'Kövesd és hívd ki  a barátaidat';

  @override
  String get gameAnalysis => 'Játék elemzés';

  @override
  String xHostsY(String param1, String param2) {
    return '$param1 létrehozta a $param2-t';
  }

  @override
  String xJoinsY(String param1, String param2) {
    return '$param1 csatlakozott a ${param2}hoz';
  }

  @override
  String xLikesY(String param1, String param2) {
    return '$param1 kedvel egy tanulmányt: $param2';
  }

  @override
  String get quickPairing => 'Gyors játszma';

  @override
  String get lobby => 'Lobbi';

  @override
  String get anonymous => 'Névtelen';

  @override
  String yourScore(String param) {
    return 'A te eredményed: $param';
  }

  @override
  String get language => 'Nyelv';

  @override
  String get background => 'Háttér';

  @override
  String get light => 'Világos';

  @override
  String get dark => 'Sötét';

  @override
  String get transparent => 'Áttetsző';

  @override
  String get deviceTheme => 'Operációs rendszer';

  @override
  String get backgroundImageUrl => 'Háttérkép URL címe:';

  @override
  String get board => 'Sakktábla';

  @override
  String get size => 'Méret';

  @override
  String get opacity => 'Átlátszóság';

  @override
  String get brightness => 'Kontraszt';

  @override
  String get hue => 'Árnyalat';

  @override
  String get boardReset => 'Színek visszaállítása az alapértékre';

  @override
  String get pieceSet => 'Figurakészlet';

  @override
  String get embedInYourWebsite => 'Beágyazás weboldalba';

  @override
  String get usernameAlreadyUsed => 'Ez a felhasználónév már foglalt, kérjük válassz másikat.';

  @override
  String get usernamePrefixInvalid => 'A felhasználói névnek betűvel kell kezdődnie.';

  @override
  String get usernameSuffixInvalid => 'A felhasználói névnek betűvel vagy számmal kell végződnie.';

  @override
  String get usernameCharsInvalid => 'A felhasználói névben nem szerepelhet más mint betűk, számok, aláhúzás- és kötőjel.';

  @override
  String get usernameUnacceptable => 'A felhasználói név nem megfelelő.';

  @override
  String get playChessInStyle => 'Sakkozz stílusosan';

  @override
  String get chessBasics => 'A sakk alapjai';

  @override
  String get coaches => 'Edzők';

  @override
  String get invalidPgn => 'Hibás PGN';

  @override
  String get invalidFen => 'Hibás FEN';

  @override
  String get custom => 'Egyéni';

  @override
  String get notifications => 'Értesítések';

  @override
  String notificationsX(String param1) {
    return 'Értesítések: $param1';
  }

  @override
  String perfRatingX(String param) {
    return 'Pontszám: $param';
  }

  @override
  String get practiceWithComputer => 'Gyakorlás a géppel';

  @override
  String anotherWasX(String param) {
    return 'Ez is jó lett volna: $param';
  }

  @override
  String bestWasX(String param) {
    return 'Legjobb lépés: $param';
  }

  @override
  String get youBrowsedAway => 'Elnavigáltál';

  @override
  String get resumePractice => 'Gyakorlás folytatása';

  @override
  String get drawByFiftyMoves => 'Az 50 lépéses szabály értelmében a játszma döntetlen.';

  @override
  String get theGameIsADraw => 'A játék döntetlen.';

  @override
  String get computerThinking => 'A gép gondolkodik...';

  @override
  String get seeBestMove => 'A legjobb lépés mutatása';

  @override
  String get hideBestMove => 'A legjobb lépés elrejtése';

  @override
  String get getAHint => 'Tipp kérése';

  @override
  String get evaluatingYourMove => 'Lépés értékelése ...';

  @override
  String get whiteWinsGame => 'Világos nyert';

  @override
  String get blackWinsGame => 'Sötét nyert';

  @override
  String get learnFromYourMistakes => 'Tanulj a hibáidból';

  @override
  String get learnFromThisMistake => 'Tanulok a hibámból';

  @override
  String get skipThisMove => 'Lépés kihagyása';

  @override
  String get next => 'Tovább';

  @override
  String xWasPlayed(String param) {
    return 'lépés: $param';
  }

  @override
  String get findBetterMoveForWhite => 'Találj egy jobb lépést világosnak';

  @override
  String get findBetterMoveForBlack => 'Találj egy jobb lépést sötétnek';

  @override
  String get resumeLearning => 'Tanulás folytatása';

  @override
  String get youCanDoBetter => 'Van jobb lépés is';

  @override
  String get tryAnotherMoveForWhite => 'Próbálj mást lépni világossal';

  @override
  String get tryAnotherMoveForBlack => 'Próbálj mást lépni feketével';

  @override
  String get solution => 'Megoldás';

  @override
  String get waitingForAnalysis => 'Készül az analízis';

  @override
  String get noMistakesFoundForWhite => 'Nem talált hibát világos játékában';

  @override
  String get noMistakesFoundForBlack => 'Nem talált hibát sötét játékában';

  @override
  String get doneReviewingWhiteMistakes => 'Világos hibáinak elemzése befejeződött';

  @override
  String get doneReviewingBlackMistakes => 'Sötét hibáinak elemzése befejeződött';

  @override
  String get doItAgain => 'Újra';

  @override
  String get reviewWhiteMistakes => 'Világos hibáinak áttekintése';

  @override
  String get reviewBlackMistakes => 'Sötét hibáinak áttekintése';

  @override
  String get advantage => 'Előny';

  @override
  String get opening => 'Megnyitás';

  @override
  String get middlegame => 'Középjáték';

  @override
  String get endgame => 'Végjáték';

  @override
  String get conditionalPremoves => 'Feltételes előre megadott lépések';

  @override
  String get addCurrentVariation => 'Változat hozzáadása';

  @override
  String get playVariationToCreateConditionalPremoves => 'Egy változat megjátszásával, hozzáadható feltételes előre megadott lépés';

  @override
  String get noConditionalPremoves => 'Nincs feltételes előre megadott lépés';

  @override
  String playX(String param) {
    return '$param megjátszása';
  }

  @override
  String get showUnreadLichessMessage => 'Üzeneted jött Lichesstől!';

  @override
  String get clickHereToReadIt => 'Katt ide az olvasáshoz';

  @override
  String get sorry => 'Sajnáljuk';

  @override
  String get weHadToTimeYouOutForAWhile => 'Kénytelenek vagyunk egy kis időre visszatartani.';

  @override
  String get why => 'Miért?';

  @override
  String get pleasantChessExperience => 'Célunk mindenki számára jó felhasználói élményt biztosítani.';

  @override
  String get goodPractice => 'Ennek érdekében minden játékosnak követnie kell megfelelő magatartást.';

  @override
  String get potentialProblem => 'Akkor mutatjuk ezt az üzenetet, ha potenciális problémát észlelünk.';

  @override
  String get howToAvoidThis => 'Hogyan kerülhető el mindez?';

  @override
  String get playEveryGame => 'Játssz végig minden megkezdett partit.';

  @override
  String get tryToWin => 'Minden játszmát próbálj megnyerni, vagy legalább döntetlent kihozni.';

  @override
  String get resignLostGames => 'Az elveszett játszmákat add fel (ne hagyd lejárni az időt).';

  @override
  String get temporaryInconvenience => 'Elnézést kérünk az átmeneti kellemetlenségért';

  @override
  String get wishYouGreatGames => 'és további sok jó játékot kívánunk a lichess.org-on.';

  @override
  String get thankYouForReading => 'Köszönjük, hogy elolvastad!';

  @override
  String get lifetimeScore => 'Mindenkori pontszám';

  @override
  String get currentMatchScore => 'Jelenlegi pontszám';

  @override
  String get agreementAssistance => 'Elfogadom, hogy játék közben soha semmilyen segítséget (sakkprogram, könyv, adatbázis vagy másik személy) nem használok fel.';

  @override
  String get agreementNice => 'Elfogadom, hogy tisztelettudó leszek a többi játékossal szemben.';

  @override
  String agreementMultipleAccounts(String param) {
    return 'Beleegyezem, hogy nem fogok egynél több felhasználói fiókot létrehozni (kivéve a $param között ismertetett okok miatt).';
  }

  @override
  String get agreementPolicy => 'Elfogadom, hogy követni fogom a Lichess szabályait.';

  @override
  String get searchOrStartNewDiscussion => 'Keresés, vagy új beszélgetés indítása';

  @override
  String get edit => 'Szerkeszt';

  @override
  String get bullet => 'Bullet';

  @override
  String get blitz => 'Blitz';

  @override
  String get rapid => 'Rapid';

  @override
  String get classical => 'Klasszikus';

  @override
  String get ultraBulletDesc => 'Rendkívül gyors játszmák: kevesebb, mint 30 másodperc';

  @override
  String get bulletDesc => 'Nagyon gyors játszmák: kevesebb, mint 3 perc';

  @override
  String get blitzDesc => 'Gyors játszmák: 3 és 8 perc között';

  @override
  String get rapidDesc => 'Rapid játszmák: 8 és 25 perc között';

  @override
  String get classicalDesc => 'Klasszikus játszmák: 25 perc vagy több';

  @override
  String get correspondenceDesc => 'Levelező játszmák: egy vagy több nap lépésenként';

  @override
  String get puzzleDesc => 'Taktikai edző';

  @override
  String get important => 'Fontos';

  @override
  String yourQuestionMayHaveBeenAnswered(String param1) {
    return 'A kérdésedre talán megtalálod a választ a $param1';
  }

  @override
  String get inTheFAQ => 'GY.I.K. oldalon.';

  @override
  String toReportSomeoneForCheatingOrBadBehavior(String param1) {
    return 'Felhasználó jelentése csalás vagy nem megfelelő magatartás miatt $param1';
  }

  @override
  String get useTheReportForm => 'ezen az oldalon';

  @override
  String toRequestSupport(String param1) {
    return 'Segítségért $param1';
  }

  @override
  String get tryTheContactPage => 'lépjen velünk kapcsolatba';

  @override
  String makeSureToRead(String param1) {
    return 'Olvasd el $param1';
  }

  @override
  String get theForumEtiquette => 'a fórum etikettet';

  @override
  String get thisTopicIsArchived => 'Ezt a témát archiváltuk, ezért nem lehet már hozzászólni.';

  @override
  String joinTheTeamXToPost(String param1) {
    return 'Csatlakozz $param1 csapathoz, hogy írhass ebbe a fórumba.';
  }

  @override
  String teamNamedX(String param1) {
    return '$param1 csapat';
  }

  @override
  String get youCannotPostYetPlaySomeGames => 'Még nem írhatsz a fórumokba. Játssz néhány partit!';

  @override
  String get subscribe => 'Feliratkozás';

  @override
  String get unsubscribe => 'Leiratkozás';

  @override
  String mentionedYouInX(String param1) {
    return 'megemlített itt: \"$param1\".';
  }

  @override
  String xMentionedYouInY(String param1, String param2) {
    return '$param1 megemlített itt: \"$param2\".';
  }

  @override
  String invitedYouToX(String param1) {
    return 'meghívott ide: \"$param1\".';
  }

  @override
  String xInvitedYouToY(String param1, String param2) {
    return '$param1 meghívott ide: \"$param2\".';
  }

  @override
  String get youAreNowPartOfTeam => 'Most már a csapat tagja vagy.';

  @override
  String youHaveJoinedTeamX(String param1) {
    return 'Csatlakoztál ide: \"$param1\".';
  }

  @override
  String get someoneYouReportedWasBanned => 'Letiltottak valakit, akit korábban jelentettél';

  @override
  String get congratsYouWon => 'Gratulálunk, nyertél!';

  @override
  String gameVsX(String param1) {
    return 'Játszma $param1 ellen';
  }

  @override
  String resVsX(String param1, String param2) {
    return '$param1 $param2 ellen';
  }

  @override
  String get lostAgainstTOSViolator => 'Vesztettél valaki ellen, aki megszegte a Lichess szabályait';

  @override
  String refundXpointsTimeControlY(String param1, String param2) {
    return 'Visszakaptál $param1 $param2 pontot.';
  }

  @override
  String get timeAlmostUp => 'Hamarosan lejár az idő!';

  @override
  String get clickToRevealEmailAddress => '[Kattints az email cím megtekintéséhez]';

  @override
  String get download => 'Letöltés';

  @override
  String get coachManager => 'Edzői vezérlőpult';

  @override
  String get streamerManager => 'Közvetítői vezérlőpult';

  @override
  String get cancelTournament => 'Versenykiírás törlése';

  @override
  String get tournDescription => 'Verseny leírása';

  @override
  String get tournDescriptionHelp => 'Bármi különleges amit a résztvevőkkel közölnél? Próbáld rövidre fogni. Markdown linkek elérhetőek: [name](https://url)';

  @override
  String get ratedFormHelp => 'Rangsorolt játszmák amik\nbefolyásolják a játékosok értékszámát';

  @override
  String get onlyMembersOfTeam => 'Kizárólag csapattagoknak';

  @override
  String get noRestriction => 'Korlátozás nélkül';

  @override
  String get minimumRatedGames => 'Legkevesebb értékelt játszma';

  @override
  String get minimumRating => 'Legalacsonyabb értékszám';

  @override
  String get maximumWeeklyRating => 'Legmagasabb heti értékszám';

  @override
  String positionInputHelp(String param) {
    return 'Illessz be egy FEN sort, hogy minden játszma adott állásból induljon.\nCsak hagyományos játszmákkal működik, variánsokkal nem.\nHasználhatod a $param a FEN készítésére, azt illeszd be ide.\nHagyd üresen és a játszmák a kezdőállásból indulnak.';
  }

  @override
  String get cancelSimul => 'Szimultán törlése';

  @override
  String get simulHostcolor => 'Szimultánt adó színe minden játszmában';

  @override
  String get estimatedStart => 'Kezdés becsült ideje';

  @override
  String simulFeatured(String param) {
    return 'Közzététel $param';
  }

  @override
  String simulFeaturedHelp(String param) {
    return 'Szimultán közzététele $param oldalon. Kapcsold ki privát szimultánhoz.';
  }

  @override
  String get simulDescription => 'Szimultán leírása';

  @override
  String get simulDescriptionHelp => 'Van bármi amit elmondanál a résztvevőknek?';

  @override
  String markdownAvailable(String param) {
    return '$param is elérhető a haladó szerkesztéshez.';
  }

  @override
  String get embedsAvailable => 'Illeszd be a játék vagy a tanulmány URL-jét a beágyazáshoz.';

  @override
  String get inYourLocalTimezone => 'Saját időzónád szerint';

  @override
  String get tournChat => 'Verseny csevegő';

  @override
  String get noChat => 'Nincs csevegő';

  @override
  String get onlyTeamLeaders => 'Csak csapatvezetőknek';

  @override
  String get onlyTeamMembers => 'Csak csapattagoknak';

  @override
  String get navigateMoveTree => 'Navigálj a lépések közt';

  @override
  String get mouseTricks => 'Trükkök az egérrel';

  @override
  String get toggleLocalAnalysis => 'Helyi számítógépes elemzés engedélyezése';

  @override
  String get toggleAllAnalysis => 'Összes számítógépes elemzés engedélyezése';

  @override
  String get playComputerMove => 'Számítógép szerinti legjobb lépés megjátszása';

  @override
  String get analysisOptions => 'Elemzés beállításai';

  @override
  String get focusChat => 'Fókusz a csevegőre';

  @override
  String get showHelpDialog => 'Mutasd ezt a súgót';

  @override
  String get reopenYourAccount => 'Fiók újranyitása';

  @override
  String get closedAccountChangedMind => 'Ha lezártad a fiókod, de azóta meggondoltad magad, van egy lehetőséged visszakapni a régi fiókod.';

  @override
  String get onlyWorksOnce => 'Ez csak egyszer működik.';

  @override
  String get cantDoThisTwice => 'Ha lezárod a fiókod másodszor is, utána már nincs lehetőség a visszaállításra.';

  @override
  String get emailAssociatedToaccount => 'A fiókhoz rendelt email cím';

  @override
  String get sentEmailWithLink => 'Küldtünk neked egy linket emailben.';

  @override
  String get tournamentEntryCode => 'Verseny belépési kód';

  @override
  String get hangOn => 'Várj csak!';

  @override
  String gameInProgress(String param) {
    return 'Van egy folyamatban lévő játszmád $param ellen.';
  }

  @override
  String get abortTheGame => 'Játszma elvetése';

  @override
  String get resignTheGame => 'Játszma feladása';

  @override
  String get youCantStartNewGame => 'Nem kezdhetsz új játszmát amíg ezt be nem fejezted.';

  @override
  String get since => 'Ettől';

  @override
  String get until => 'Eddig';

  @override
  String get lichessDbExplanation => 'A Lichess játékosok értékelt játszmáiból összeállítva';

  @override
  String get switchSides => 'Oldal megfordítása';

  @override
  String get closingAccountWithdrawAppeal => 'A fiókod lezárása visszavonja a fellebbezésed';

  @override
  String get ourEventTips => 'Tippjeink események szervezéséhez';

  @override
  String get instructions => 'Használati útmutató';

  @override
  String get showMeEverything => 'Az összes parancs megjelenítése';

  @override
  String get lichessPatronInfo => 'A Lichess egy jótékonysági szervezet és teljesen ingyenes/szabad nyílt forrású szoftver.\nMinden működési költséget, fejlesztést és tartalmat felhasználói adományokból fedezünk.';

  @override
  String get nothingToSeeHere => 'Itt nincs semmi látnivaló jelenleg.';

  @override
  String opponentLeftCounter(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Az ellenfeled elhagyta a játékot, $count másodperc múlva győzelmet igényelhetsz.',
      one: 'Az ellenfeled elhagyta a játékot, $count másodperc múlva győzelmet igényelhetsz.',
    );
    return '$_temp0';
  }

  @override
  String mateInXHalfMoves(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Matt $count féllépésben',
      one: 'Matt $count féllépésben',
    );
    return '$_temp0';
  }

  @override
  String nbBlunders(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count súlyos hiba',
      one: '$count súlyos hiba',
    );
    return '$_temp0';
  }

  @override
  String nbMistakes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count hiba',
      one: '$count hiba',
    );
    return '$_temp0';
  }

  @override
  String nbInaccuracies(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count pontatlanság',
      one: '$count pontatlanság',
    );
    return '$_temp0';
  }

  @override
  String nbPlayers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count játékos',
      one: '$count játékos',
    );
    return '$_temp0';
  }

  @override
  String nbGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count játszma',
      one: '$count játszma',
    );
    return '$_temp0';
  }

  @override
  String ratingXOverYGames(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count pontszám $param2 játszma alapján',
      one: '$count pontszám $param2 játszma alapján',
    );
    return '$_temp0';
  }

  @override
  String nbBookmarks(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count kedvenc',
      one: '$count kedvenc',
    );
    return '$_temp0';
  }

  @override
  String nbDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count nap',
      one: '$count nap',
    );
    return '$_temp0';
  }

  @override
  String nbHours(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count óra',
      one: '$count óra',
    );
    return '$_temp0';
  }

  @override
  String nbMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count perc',
      one: '$count perc',
    );
    return '$_temp0';
  }

  @override
  String rankIsUpdatedEveryNbMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'A helyezés minden $count percben frissül',
      one: 'A helyezés minden percben frissül',
    );
    return '$_temp0';
  }

  @override
  String nbPuzzles(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count feladvány',
      one: '$count feladvány',
    );
    return '$_temp0';
  }

  @override
  String nbGamesWithYou(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count játék veled',
      one: '$count játszma veled',
    );
    return '$_temp0';
  }

  @override
  String nbRated(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count rangsorolt',
      one: '$count rangsorolt',
    );
    return '$_temp0';
  }

  @override
  String nbWins(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count győzelem',
      one: '$count győzelem',
    );
    return '$_temp0';
  }

  @override
  String nbLosses(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count vereség',
      one: '$count vereség',
    );
    return '$_temp0';
  }

  @override
  String nbDraws(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count döntetlen',
      one: '$count döntetlen',
    );
    return '$_temp0';
  }

  @override
  String nbPlaying(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count folyamatban',
      one: '$count folyamatban',
    );
    return '$_temp0';
  }

  @override
  String giveNbSeconds(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Adj $count másodpercet',
      one: 'Adj $count másodpercet',
    );
    return '$_temp0';
  }

  @override
  String nbTournamentPoints(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count versenypont',
      one: '$count versenypont',
    );
    return '$_temp0';
  }

  @override
  String nbStudies(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count tanulmány',
      one: '$count tanulmány',
    );
    return '$_temp0';
  }

  @override
  String nbSimuls(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count szimultán',
      one: '$count szimultán',
    );
    return '$_temp0';
  }

  @override
  String moreThanNbRatedGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '≥ $count értékelt játszma',
      one: '≥ $count értékelt játszma',
    );
    return '$_temp0';
  }

  @override
  String moreThanNbPerfRatedGames(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '≥ $count értékelt $param2 játszma',
      one: '≥ $count értékelt $param2 játszma',
    );
    return '$_temp0';
  }

  @override
  String needNbMorePerfGames(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Még $count további $param2 rangsorolt játszma szükséges',
      one: 'Még $count további $param2 rangsorolt játszma szükséges',
    );
    return '$_temp0';
  }

  @override
  String needNbMoreGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Még $count további rangsorolt játszma szükséges',
      one: 'Még $count további rangsorolt játszma szükséges',
    );
    return '$_temp0';
  }

  @override
  String nbImportedGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Importált játszma',
      one: '$count importált játszma',
    );
    return '$_temp0';
  }

  @override
  String nbFriendsOnline(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count barát online',
      one: '$count barát online',
    );
    return '$_temp0';
  }

  @override
  String nbFollowers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count követő',
      one: '$count követő',
    );
    return '$_temp0';
  }

  @override
  String nbFollowing(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count követve',
      one: '$count követve',
    );
    return '$_temp0';
  }

  @override
  String lessThanNbMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Kevesebb mint $count perc',
      one: 'Kevesebb mint $count perc',
    );
    return '$_temp0';
  }

  @override
  String nbGamesInPlay(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count játszma fut',
      one: '$count játszma fut',
    );
    return '$_temp0';
  }

  @override
  String maximumNbCharacters(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Legfeljebb $count karakter.',
      one: 'Legfeljebb $count karakter.',
    );
    return '$_temp0';
  }

  @override
  String blocks(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count letiltott játékos',
      one: '$count letiltott játékos',
    );
    return '$_temp0';
  }

  @override
  String nbForumPosts(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count fórumbejegyzés',
      one: '$count fórumbejegyzés',
    );
    return '$_temp0';
  }

  @override
  String nbPerfTypePlayersThisWeek(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count $param2 játékos ezen a héten.',
      one: '$count $param2 játékos ezen a héten.',
    );
    return '$_temp0';
  }

  @override
  String availableInNbLanguages(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Elérhető $count nyelven',
      one: 'Elérhető $count nyelven',
    );
    return '$_temp0';
  }

  @override
  String nbSecondsToPlayTheFirstMove(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count másodperc a kezdőlépés megtételére',
      one: '$count másodperc a kezdőlépés megtételére',
    );
    return '$_temp0';
  }

  @override
  String nbSeconds(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count másodperc',
      one: '$count másodperc',
    );
    return '$_temp0';
  }

  @override
  String andSaveNbPremoveLines(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'és $count változat mentése',
      one: 'és $count változat mentése',
    );
    return '$_temp0';
  }

  @override
  String get stormMoveToStart => 'Lépj a kezdéshez';

  @override
  String get stormYouPlayTheWhitePiecesInAllPuzzles => 'Világossal játszol az összes feladványban';

  @override
  String get stormYouPlayTheBlackPiecesInAllPuzzles => 'Sötéttel játszol az összes feladványban';

  @override
  String get stormPuzzlesSolved => 'megoldott feladványok';

  @override
  String get stormNewDailyHighscore => 'Új napi rekord!';

  @override
  String get stormNewWeeklyHighscore => 'Új heti rekord!';

  @override
  String get stormNewMonthlyHighscore => 'Új havi rekord!';

  @override
  String get stormNewAllTimeHighscore => 'Új abszolút rekord!';

  @override
  String stormPreviousHighscoreWasX(String param) {
    return 'Az előző rekordod $param volt';
  }

  @override
  String get stormPlayAgain => 'Játssz újra';

  @override
  String stormHighscoreX(String param) {
    return 'Rekord: $param';
  }

  @override
  String get stormScore => 'Pontszám';

  @override
  String get stormMoves => 'Lépések';

  @override
  String get stormAccuracy => 'Pontosság';

  @override
  String get stormCombo => 'Széria';

  @override
  String get stormTime => 'Idő';

  @override
  String get stormTimePerMove => 'Idő lépésenként';

  @override
  String get stormHighestSolved => 'Legnehezebb megoldott';

  @override
  String get stormPuzzlesPlayed => 'Játszott feladványok';

  @override
  String get stormNewRun => 'Új futam (gyorsbill.: Szóköz)';

  @override
  String get stormEndRun => 'Futam vége (gyorsbillentyű: Enter)';

  @override
  String get stormHighscores => 'Legjobb pontszámaid';

  @override
  String get stormViewBestRuns => 'Napi legjobb futamjaid';

  @override
  String get stormBestRunOfDay => 'Napi legjobb futam';

  @override
  String get stormRuns => 'Futamok';

  @override
  String get stormGetReady => 'Felkészülni!';

  @override
  String get stormWaitingForMorePlayers => 'További játékosok csatlakozására várunk...';

  @override
  String get stormRaceComplete => 'Vége a versenynek!';

  @override
  String get stormSpectating => 'Megfigyelés';

  @override
  String get stormJoinTheRace => 'Csatlakozz a versenyhez!';

  @override
  String get stormStartTheRace => 'Kezdés';

  @override
  String stormYourRankX(String param) {
    return 'Helyezésed: $param';
  }

  @override
  String get stormWaitForRematch => 'Várj az újrajátszásig';

  @override
  String get stormNextRace => 'Következő futam';

  @override
  String get stormJoinRematch => 'Csatlakozás';

  @override
  String get stormWaitingToStart => 'Várakozás a kezdésig';

  @override
  String get stormCreateNewGame => 'Új játék létrehozása';

  @override
  String get stormJoinPublicRace => 'Csatlakozás egy nyilvános versenyhez';

  @override
  String get stormRaceYourFriends => 'Versenyezz a barátaiddal';

  @override
  String get stormSkip => 'kihagy';

  @override
  String get stormSkipHelp => 'Kihagyhatsz egy lépést versenyenként:';

  @override
  String get stormSkipExplanation => 'Ugord át ezt a lépést a szériád megőrzéséhez! Egy menetben csak egyszer működik.';

  @override
  String get stormFailedPuzzles => 'Sikertelen feladványok';

  @override
  String get stormSlowPuzzles => 'Lassú megfejtések';

  @override
  String get stormSkippedPuzzle => 'Kihagyott feladvány';

  @override
  String get stormThisWeek => 'Ezen a héten';

  @override
  String get stormThisMonth => 'Ebben a hónapban';

  @override
  String get stormAllTime => 'Mindenkori';

  @override
  String get stormClickToReload => 'Kattints az újratöltéshez';

  @override
  String get stormThisRunHasExpired => 'Ez a futam lejárt!';

  @override
  String get stormThisRunWasOpenedInAnotherTab => 'Ez a futam egy másik lapon nyílt meg!';

  @override
  String stormXRuns(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count futam',
      one: '1 futam',
    );
    return '$_temp0';
  }

  @override
  String stormPlayedNbRunsOfPuzzleStorm(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count $param2 futamot játszott',
      one: 'Egy $param2 futamot játszott',
    );
    return '$_temp0';
  }

  @override
  String get streamerLichessStreamers => 'Lichess streamerek';

  @override
  String get studyShareAndExport => 'Megosztás és exportálás';

  @override
  String get studyStart => 'Mehet';
}
