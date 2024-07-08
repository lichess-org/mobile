import 'package:intl/intl.dart' as intl;

import 'l10n.dart';

/// The translations for Dutch Flemish (`nl`).
class AppLocalizationsNl extends AppLocalizations {
  AppLocalizationsNl([String locale = 'nl']) : super(locale);

  @override
  String get mobileHomeTab => 'Startscherm';

  @override
  String get mobilePuzzlesTab => 'Puzzels';

  @override
  String get mobileToolsTab => 'Gereedschap';

  @override
  String get mobileWatchTab => 'Kijken';

  @override
  String get mobileSettingsTab => 'Instellingen';

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
  String get activityActivity => 'Activiteit';

  @override
  String get activityHostedALiveStream => 'Heeft een live stream gehost';

  @override
  String activityRankedInSwissTournament(String param1, String param2) {
    return 'Eindigde #$param1 in $param2';
  }

  @override
  String get activitySignedUp => 'Geregistreerd op lichess.org';

  @override
  String activitySupportedNbMonths(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Steunde lichess.org voor $count maanden als $param2',
      one: 'Steunde lichess.org voor $count maand als $param2',
    );
    return '$_temp0';
  }

  @override
  String activityPracticedNbPositions(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Beoefende $count posities van $param2',
      one: 'Beoefende $count positie van $param2',
    );
    return '$_temp0';
  }

  @override
  String activitySolvedNbPuzzles(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count tactische puzzels opgelost',
      one: '$count tactische puzzel opgelost',
    );
    return '$_temp0';
  }

  @override
  String activityPlayedNbGames(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Speelde $count $param2 partijen',
      one: 'Speelde $count $param2 partij',
    );
    return '$_temp0';
  }

  @override
  String activityPostedNbMessages(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Plaatste $count berichten in $param2',
      one: 'Plaatste $count bericht in $param2',
    );
    return '$_temp0';
  }

  @override
  String activityPlayedNbMoves(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Speelde $count zet',
      one: 'Speelde $count zet',
    );
    return '$_temp0';
  }

  @override
  String activityInNbCorrespondenceGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'in $count correspondentiepartijen',
      one: 'in $count correspondentiepartij',
    );
    return '$_temp0';
  }

  @override
  String activityCompletedNbGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Voltooide $count correspondentiepartijen',
      one: 'Voltooide $count correspondentiepartijen',
    );
    return '$_temp0';
  }

  @override
  String activityFollowedNbPlayers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Begon $count spelers te volgen',
      one: 'Begon $count speler te volgen',
    );
    return '$_temp0';
  }

  @override
  String activityGainedNbFollowers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count nieuwe volgers verworven',
      one: '$count nieuwe volger verworven',
    );
    return '$_temp0';
  }

  @override
  String activityHostedNbSimuls(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Gaf $count simultanen',
      one: 'Gaf $count simultaan',
    );
    return '$_temp0';
  }

  @override
  String activityJoinedNbSimuls(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Nam deel in $count simultanen',
      one: 'Nam deel in $count simultaan',
    );
    return '$_temp0';
  }

  @override
  String activityCreatedNbStudies(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count nieuwe studies aangemaakt',
      one: '$count nieuwe studie aangemaakt',
    );
    return '$_temp0';
  }

  @override
  String activityCompetedInNbTournaments(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Nam deel in $count toernooien',
      one: 'Nam deel in $count toernooi',
    );
    return '$_temp0';
  }

  @override
  String activityRankedInTournament(int count, String param2, String param3, String param4) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Eindigde #$count (top $param2%) met $param3 partijen in $param4',
      one: 'Eindigde #$count (top $param2%) met $param3 partij in $param4',
    );
    return '$_temp0';
  }

  @override
  String activityCompetedInNbSwissTournaments(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Nam deel aan $count Zwitserse toernooien',
      one: 'Nam deel aan $count Zwitsers toernooi',
    );
    return '$_temp0';
  }

  @override
  String activityJoinedNbTeams(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Sloot zich aan bij $count teams',
      one: 'Sloot zich aan bij $count team',
    );
    return '$_temp0';
  }

  @override
  String get broadcastBroadcasts => 'Uitzendingen';

  @override
  String get broadcastLiveBroadcasts => 'Live toernooi uitzendingen';

  @override
  String challengeChallengesX(String param1) {
    return 'Uitdagingen: $param1';
  }

  @override
  String get challengeChallengeToPlay => 'Uitdagen voor een partij';

  @override
  String get challengeChallengeDeclined => 'Uitdaging geweigerd';

  @override
  String get challengeChallengeAccepted => 'Uitdaging aangenomen!';

  @override
  String get challengeChallengeCanceled => 'Uitdaging geannuleerd.';

  @override
  String get challengeRegisterToSendChallenges => 'Gelieve te registreren om uitdagingen te versturen.';

  @override
  String challengeYouCannotChallengeX(String param) {
    return 'Je kunt $param niet uitdagen.';
  }

  @override
  String challengeXDoesNotAcceptChallenges(String param) {
    return '$param neemt geen uitdagingen aan.';
  }

  @override
  String challengeYourXRatingIsTooFarFromY(String param1, String param2) {
    return 'Je rating van $param1 wijkt te veel af van $param2.';
  }

  @override
  String challengeCannotChallengeDueToProvisionalXRating(String param) {
    return 'Uitdagen niet mogelijk vanwege voorlopige $param-rating.';
  }

  @override
  String challengeXOnlyAcceptsChallengesFromFriends(String param) {
    return '$param neemt alleen uitdagingen aan van vrienden.';
  }

  @override
  String get challengeDeclineGeneric => 'Momenteel neem ik geen uitdagingen aan.';

  @override
  String get challengeDeclineLater => 'Op dit moment neem ik geen uitdagingen aan, probeer het later nog eens.';

  @override
  String get challengeDeclineTooFast => 'Dit tempo is mij te snel, daag me a.u.b. uit voor een langzamere partij.';

  @override
  String get challengeDeclineTooSlow => 'Dit tempo is mij te traag, daag me a.u.b. uit voor een snellere partij.';

  @override
  String get challengeDeclineTimeControl => 'Ik neem geen uitdagingen aan met dit tempo.';

  @override
  String get challengeDeclineRated => 'Stuur me a.u.b. een uitdaging met rating.';

  @override
  String get challengeDeclineCasual => 'Stuur me a.u.b. een uitdaging zonder rating.';

  @override
  String get challengeDeclineStandard => 'Momenteel neem ik geen uitdagingen aan voor varianten.';

  @override
  String get challengeDeclineVariant => 'Momenteel voel ik er niet voor om deze variant te spelen.';

  @override
  String get challengeDeclineNoBot => 'Ik neem geen uitdagingen van bots aan.';

  @override
  String get challengeDeclineOnlyBot => 'Ik neem alleen uitdagingen van bots aan.';

  @override
  String get challengeInviteLichessUser => 'Of nodig een Lichess-gebruiker uit:';

  @override
  String get contactContact => 'Contact';

  @override
  String get contactContactLichess => 'Contact met Lichess';

  @override
  String get patronDonate => 'Doneer';

  @override
  String get patronLichessPatron => 'Lichess Patroon';

  @override
  String perfStatPerfStats(String param) {
    return '$param-statistieken';
  }

  @override
  String get perfStatViewTheGames => 'Bekijk de partijen';

  @override
  String get perfStatProvisional => 'voorlopig';

  @override
  String get perfStatNotEnoughRatedGames => 'Er zijn niet genoeg partijen met rating gespeeld om een betrouwbare rating vast te stellen.';

  @override
  String perfStatProgressOverLastXGames(String param) {
    return 'Voortgang in de laatste $param partijen:';
  }

  @override
  String perfStatRatingDeviation(String param) {
    return 'Rating deviatie: $param.';
  }

  @override
  String perfStatRatingDeviationTooltip(String param1, String param2, String param3) {
    return 'Een lagere waarde betekent dat de rating stabieler is. Boven $param1 wordt de rating als voorlopig beschouwd. Om in de ranglijsten te worden opgenomen, moet deze waarde lager zijn dan $param2 (standaard schaken) of $param3 (varianten).';
  }

  @override
  String get perfStatTotalGames => 'Totaal aantal partijen';

  @override
  String get perfStatRatedGames => 'Partijen met rating';

  @override
  String get perfStatTournamentGames => 'Toernooipartijen';

  @override
  String get perfStatBerserkedGames => 'Berserk partijen';

  @override
  String get perfStatTimeSpentPlaying => 'Tijd schakend besteed';

  @override
  String get perfStatAverageOpponent => 'Gemiddelde tegenstander';

  @override
  String get perfStatVictories => 'Overwinningen';

  @override
  String get perfStatDefeats => 'Nederlagen';

  @override
  String get perfStatDisconnections => 'Verbroken verbindingen';

  @override
  String get perfStatNotEnoughGames => 'Niet genoeg partijen gespeeld';

  @override
  String perfStatHighestRating(String param) {
    return 'Hoogste rating: $param';
  }

  @override
  String perfStatLowestRating(String param) {
    return 'Laagste rating: $param';
  }

  @override
  String perfStatFromXToY(String param1, String param2) {
    return 'van $param1 tot $param2';
  }

  @override
  String get perfStatWinningStreak => 'Overwinningsreeks';

  @override
  String get perfStatLosingStreak => 'Verliesreeks';

  @override
  String perfStatLongestStreak(String param) {
    return 'Langste reeks: $param';
  }

  @override
  String perfStatCurrentStreak(String param) {
    return 'Huidige reeks: $param';
  }

  @override
  String get perfStatBestRated => 'Grootste overwinningen';

  @override
  String get perfStatGamesInARow => 'Aaneengesloten partijen';

  @override
  String get perfStatLessThanOneHour => 'Minder dan een uur tussen de partijen';

  @override
  String get perfStatMaxTimePlaying => 'Langste schaakpartij';

  @override
  String get perfStatNow => 'nu';

  @override
  String get preferencesPreferences => 'Voorkeuren';

  @override
  String get preferencesDisplay => 'Weergave';

  @override
  String get preferencesPrivacy => 'Privacy';

  @override
  String get preferencesNotifications => 'Meldingen';

  @override
  String get preferencesPieceAnimation => 'Stukanimatie';

  @override
  String get preferencesMaterialDifference => 'Materiaalverschil';

  @override
  String get preferencesBoardHighlights => 'Bord laten oplichten (laatste zet en schaak)';

  @override
  String get preferencesPieceDestinations => 'Bestemming van het stuk (geldige zetten en premoves)';

  @override
  String get preferencesBoardCoordinates => 'Bordcoördinaten (A-H, 1-8)';

  @override
  String get preferencesMoveListWhilePlaying => 'Zetnotatie zichtbaar tijdens partij';

  @override
  String get preferencesPgnPieceNotation => 'Stuknotatie in PGN';

  @override
  String get preferencesChessPieceSymbol => 'Schaakstuksymbool';

  @override
  String get preferencesPgnLetter => 'PGN-letter (K, D, T, L, P)';

  @override
  String get preferencesZenMode => 'Zenmodus';

  @override
  String get preferencesShowPlayerRatings => 'Toon de rating van de spelers';

  @override
  String get preferencesShowFlairs => 'Geef de flairs van de spelers weer';

  @override
  String get preferencesExplainShowPlayerRatings => 'Deze instelling zorgt ervoor dat alle ratings op de website verborgen blijven zodat je je kunt concentreren op het schaken. Partijen kunnen nog steeds met rating zijn; dit gaat alleen om wat je te zien krijgt.';

  @override
  String get preferencesDisplayBoardResizeHandle => 'Toon de knop om het bordformaat te wijzigen';

  @override
  String get preferencesOnlyOnInitialPosition => 'Enkel tijdens de beginstelling';

  @override
  String get preferencesInGameOnly => 'Alleen tijdens partij';

  @override
  String get preferencesChessClock => 'Schaakklok';

  @override
  String get preferencesTenthsOfSeconds => 'Tienden van seconden';

  @override
  String get preferencesWhenTimeRemainingLessThanTenSeconds => 'Wanneer resterende tijd < 10 seconden';

  @override
  String get preferencesHorizontalGreenProgressBars => 'Horizontale groene voortgangsbalk';

  @override
  String get preferencesSoundWhenTimeGetsCritical => 'Geluidssignaal als tijd opraakt';

  @override
  String get preferencesGiveMoreTime => 'Meer tijd geven';

  @override
  String get preferencesGameBehavior => 'Spelgedrag';

  @override
  String get preferencesHowDoYouMovePieces => 'Hoe zet je stukken?';

  @override
  String get preferencesClickTwoSquares => 'Klik twee vakjes';

  @override
  String get preferencesDragPiece => 'Sleep een stuk';

  @override
  String get preferencesBothClicksAndDrag => 'Beide';

  @override
  String get preferencesPremovesPlayingDuringOpponentTurn => 'Vooraf-zetten (spelen tijdens beurt tegenstander)';

  @override
  String get preferencesTakebacksWithOpponentApproval => 'Terugnames (met goedkeuring van tegenstander)';

  @override
  String get preferencesInCasualGamesOnly => 'Alleen bij partijen zonder rating';

  @override
  String get preferencesPromoteToQueenAutomatically => 'Automatisch promoveren tot dame';

  @override
  String get preferencesExplainPromoteToQueenAutomatically => 'Houd de <Ctrl> toets ingedrukt om auto-promotie tijdelijk uit te zetten';

  @override
  String get preferencesWhenPremoving => 'Bij vooraf-zetten';

  @override
  String get preferencesClaimDrawOnThreefoldRepetitionAutomatically => 'Eis automatisch remise op bij driemaal dezelfde stelling';

  @override
  String get preferencesWhenTimeRemainingLessThanThirtySeconds => 'Wanneer resterende tijd < 30 seconden';

  @override
  String get preferencesMoveConfirmation => 'Zetbevestiging';

  @override
  String get preferencesExplainCanThenBeTemporarilyDisabled => 'Kan tijdens een partij uitgeschakeld worden met het bordmenu';

  @override
  String get preferencesInCorrespondenceGames => 'Bij correspondentiepartijen';

  @override
  String get preferencesCorrespondenceAndUnlimited => 'Correspondentiepartij en zonder klok';

  @override
  String get preferencesConfirmResignationAndDrawOffers => 'Opgave en remise-aanbod bevestigen';

  @override
  String get preferencesCastleByMovingTheKingTwoSquaresOrOntoTheRook => 'Rokeren';

  @override
  String get preferencesCastleByMovingTwoSquares => 'Verplaats de koning twee velden';

  @override
  String get preferencesCastleByMovingOntoTheRook => 'Verplaats de koning naar de toren';

  @override
  String get preferencesInputMovesWithTheKeyboard => 'Zetten invoeren met het toetsenbord';

  @override
  String get preferencesInputMovesWithVoice => 'Voer zetten in met je stem';

  @override
  String get preferencesSnapArrowsToValidMoves => 'Geldige zetten markeren met pijlen';

  @override
  String get preferencesSayGgWpAfterLosingOrDrawing => 'Zeg \"Goede partij, goed gespeeld\" bij verlies of remise';

  @override
  String get preferencesYourPreferencesHaveBeenSaved => 'Uw voorkeuren werden opgeslagen.';

  @override
  String get preferencesScrollOnTheBoardToReplayMoves => 'Scroll op het bord om zetten opnieuw af te spelen';

  @override
  String get preferencesCorrespondenceEmailNotification => 'Dagelijkse e-mailmeldingen met de lijst van jouw correspondentiepartijen';

  @override
  String get preferencesNotifyStreamStart => 'Streamer gaat live';

  @override
  String get preferencesNotifyInboxMsg => 'Nieuw bericht inbox';

  @override
  String get preferencesNotifyForumMention => 'Opmerking op het forum noemt u';

  @override
  String get preferencesNotifyInvitedStudy => 'Studie uitnodiging';

  @override
  String get preferencesNotifyGameEvent => 'Spelupdates voor correspondentiepartijen';

  @override
  String get preferencesNotifyChallenge => 'Uitdagingen';

  @override
  String get preferencesNotifyTournamentSoon => 'Toernooi begint binnenkort';

  @override
  String get preferencesNotifyTimeAlarm => 'Klok met correspondentie bijna leeg';

  @override
  String get preferencesNotifyBell => 'Bel melding binnen Lichess';

  @override
  String get preferencesNotifyPush => 'Apparaatmelding wanneer je niet op Lichess bent';

  @override
  String get preferencesNotifyWeb => 'Browser';

  @override
  String get preferencesNotifyDevice => 'Apparaat';

  @override
  String get preferencesBellNotificationSound => 'Meldingsgeluid';

  @override
  String get puzzlePuzzles => 'Puzzels';

  @override
  String get puzzlePuzzleThemes => 'Puzzelthema\'s';

  @override
  String get puzzleRecommended => 'Aanbevolen';

  @override
  String get puzzlePhases => 'Fasen';

  @override
  String get puzzleMotifs => 'Motieven';

  @override
  String get puzzleAdvanced => 'Geavanceerd';

  @override
  String get puzzleLengths => 'Duur';

  @override
  String get puzzleMates => 'Schaakmat';

  @override
  String get puzzleGoals => 'Doelen';

  @override
  String get puzzleOrigin => 'Herkomst';

  @override
  String get puzzleSpecialMoves => 'Speciale zetten';

  @override
  String get puzzleDidYouLikeThisPuzzle => 'Vond je deze puzzel leuk?';

  @override
  String get puzzleVoteToLoadNextOne => 'Stem om de volgende te laden!';

  @override
  String get puzzleUpVote => 'Puzzel leuk vinden';

  @override
  String get puzzleDownVote => 'Puzzel niet leuk vinden';

  @override
  String get puzzleYourPuzzleRatingWillNotChange => 'Je puzzelrating zal niet veranderen: puzzels zijn geen competitie. De rating helpt bij het selecteren van de beste puzzels voor je huidige vaardigheid.';

  @override
  String get puzzleFindTheBestMoveForWhite => 'Vind de beste zet voor wit.';

  @override
  String get puzzleFindTheBestMoveForBlack => 'Vind de beste zet voor zwart.';

  @override
  String get puzzleToGetPersonalizedPuzzles => 'Om gepersonaliseerde puzzels te krijgen:';

  @override
  String puzzlePuzzleId(String param) {
    return 'Puzzel $param';
  }

  @override
  String get puzzlePuzzleOfTheDay => 'Puzzel van de dag';

  @override
  String get puzzleDailyPuzzle => 'Dagelijkse Puzzel';

  @override
  String get puzzleClickToSolve => 'Klik om op te lossen';

  @override
  String get puzzleGoodMove => 'Goede zet';

  @override
  String get puzzleBestMove => 'Beste zet!';

  @override
  String get puzzleKeepGoing => 'Ga zo door…';

  @override
  String get puzzlePuzzleSuccess => 'Perfect!';

  @override
  String get puzzlePuzzleComplete => 'Puzzel voltooid!';

  @override
  String get puzzleByOpenings => 'Per opening';

  @override
  String get puzzlePuzzlesByOpenings => 'Puzzels per opening';

  @override
  String get puzzleOpeningsYouPlayedTheMost => 'Openingen die je het meest hebt gespeeld in partijen met rating';

  @override
  String get puzzleUseFindInPage => 'Gebruik \"In pagina zoeken\" in het browsermenu om je favoriete opening te vinden!';

  @override
  String get puzzleUseCtrlF => 'Gebruik Ctrl+F om je favoriete opening te vinden!';

  @override
  String get puzzleNotTheMove => 'Dat is niet de juiste zet!';

  @override
  String get puzzleTrySomethingElse => 'Probeer iets anders.';

  @override
  String puzzleRatingX(String param) {
    return 'Rating: $param';
  }

  @override
  String get puzzleHidden => 'verborgen';

  @override
  String puzzleFromGameLink(String param) {
    return 'Van partij $param';
  }

  @override
  String get puzzleContinueTraining => 'Ga verder met de training';

  @override
  String get puzzleDifficultyLevel => 'Moeilijkheidsgraad';

  @override
  String get puzzleNormal => 'Standaard';

  @override
  String get puzzleEasier => 'Makkelijk';

  @override
  String get puzzleEasiest => 'Makkelijker';

  @override
  String get puzzleHarder => 'Moeilijk';

  @override
  String get puzzleHardest => 'Moeilijker';

  @override
  String get puzzleExample => 'Voorbeeld';

  @override
  String get puzzleAddAnotherTheme => 'Voeg nog een thema toe';

  @override
  String get puzzleNextPuzzle => 'Volgende puzzel';

  @override
  String get puzzleJumpToNextPuzzleImmediately => 'Ga direct door naar volgende puzzel';

  @override
  String get puzzlePuzzleDashboard => 'Puzzeldashboard';

  @override
  String get puzzleImprovementAreas => 'Verbeterpunten';

  @override
  String get puzzleStrengths => 'Sterke punten';

  @override
  String get puzzleHistory => 'Puzzelscore';

  @override
  String get puzzleSolved => 'opgelost';

  @override
  String get puzzleFailed => 'niet opgelost';

  @override
  String get puzzleStreakDescription => 'Los steeds moeilijker wordende puzzels op en bouw aan een succesreeks. Er is geen klok, dus neem de tijd. Eén foute zet en het spel is uit! Per sessie kun je één zet overslaan.';

  @override
  String puzzleYourStreakX(String param) {
    return 'Uw reeks: $param';
  }

  @override
  String get puzzleStreakSkipExplanation => 'Sla deze zet over om je reeks te behouden! Werkt maar eenmaal per sessie.';

  @override
  String get puzzleContinueTheStreak => 'Doorgaan met de reeks';

  @override
  String get puzzleNewStreak => 'Nieuwe reeks';

  @override
  String get puzzleFromMyGames => 'Van mijn partijen';

  @override
  String get puzzleLookupOfPlayer => 'Zoek puzzels uit partijen van een specifieke speler';

  @override
  String puzzleFromXGames(String param) {
    return 'Puzzels uit de partijen van $param';
  }

  @override
  String get puzzleSearchPuzzles => 'Puzzels zoeken';

  @override
  String get puzzleFromMyGamesNone => 'Je hebt geen puzzels in de database staan, maar Lichess waardeert je nog steeds heel erg.\nSpeel rapid en klassieke partijen om de kans te vergroten dat een puzzel uit jouw partijen wordt toegevoegd!';

  @override
  String puzzleFromXGamesFound(String param1, String param2) {
    return '$param1 puzzels gevonden in $param2 partijen';
  }

  @override
  String get puzzlePuzzleDashboardDescription => 'Train, analyseer, verbeter';

  @override
  String puzzlePercentSolved(String param) {
    return '$param opgelost';
  }

  @override
  String get puzzleNoPuzzlesToShow => 'Niets te tonen, speel eerst wat puzzels!';

  @override
  String get puzzleImprovementAreasDescription => 'Train deze om je voortgang te optimaliseren!';

  @override
  String get puzzleStrengthDescription => 'Je presteert het beste in deze thema\'s';

  @override
  String puzzlePlayedXTimes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count keer gespeeld',
      one: '$count keer gespeeld',
    );
    return '$_temp0';
  }

  @override
  String puzzleNbPointsBelowYourPuzzleRating(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count punten onder je puzzelrating',
      one: 'Eén punt onder je puzzelrating',
    );
    return '$_temp0';
  }

  @override
  String puzzleNbPointsAboveYourPuzzleRating(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count punten boven je puzzelrating',
      one: 'Eén punt boven je puzzelrating',
    );
    return '$_temp0';
  }

  @override
  String puzzleNbPlayed(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count gespeeld',
      one: '$count gespeeld',
    );
    return '$_temp0';
  }

  @override
  String puzzleNbToReplay(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count om te herhalen',
      one: '$count om te herhalen',
    );
    return '$_temp0';
  }

  @override
  String get puzzleThemeAdvancedPawn => 'Opgerukte pion';

  @override
  String get puzzleThemeAdvancedPawnDescription => 'Een pion die promoveert of dreigt te promoveren is hier cruciaal.';

  @override
  String get puzzleThemeAdvantage => 'Voordeel';

  @override
  String get puzzleThemeAdvantageDescription => 'Grijp je kans om een doorslaggevend voordeel te verkrijgen. (200cp ≤ eval ≤ 600 cp)';

  @override
  String get puzzleThemeAnastasiaMate => 'Mat van Anastasia';

  @override
  String get puzzleThemeAnastasiaMateDescription => 'Een paard werkt samen met een toren of dame om de koning van de tegenstander tussen de zijkant van het bord en een eigen stuk te vangen.';

  @override
  String get puzzleThemeArabianMate => 'Arabisch mat';

  @override
  String get puzzleThemeArabianMateDescription => 'Een paard en een toren werken samen om de koning van de tegenstander in een hoek van het bord in te sluiten.';

  @override
  String get puzzleThemeAttackingF2F7 => 'f2 of f7 aanvallen';

  @override
  String get puzzleThemeAttackingF2F7Description => 'Een aanval gericht op de f2 of de f7-pion, zoals in de Fegatello-opening.';

  @override
  String get puzzleThemeAttraction => 'Lokken';

  @override
  String get puzzleThemeAttractionDescription => 'Een afruil of offer om een vijandelijk stuk naar een veld te lokken of te dwingen waardoor een tactisch vervolg mogelijk wordt gemaakt.';

  @override
  String get puzzleThemeBackRankMate => 'Mat op de achterste rij';

  @override
  String get puzzleThemeBackRankMateDescription => 'Zet de koning mat op de achterste rij, ingesloten door zijn eigen stukken.';

  @override
  String get puzzleThemeBishopEndgame => 'Lopereindspel';

  @override
  String get puzzleThemeBishopEndgameDescription => 'Een eindspel met alleen lopers en pionnen.';

  @override
  String get puzzleThemeBodenMate => 'Mat van Boden';

  @override
  String get puzzleThemeBodenMateDescription => 'Twee lopers op kruisende diagonalen zetten een koning mat die wordt belemmerd door de eigen stukken.';

  @override
  String get puzzleThemeCastling => 'Rokeren';

  @override
  String get puzzleThemeCastlingDescription => 'Breng de koning in veiligheid en zet de toren in voor een aanval.';

  @override
  String get puzzleThemeCapturingDefender => 'De verdediger slaan';

  @override
  String get puzzleThemeCapturingDefenderDescription => 'Een stuk slaan dat essentieel is voor de verdediging van een ander stuk, waardoor vervolgens het nu onverdedigde stuk een volgende zet kan worden geslagen.';

  @override
  String get puzzleThemeCrushing => 'Verpletteren';

  @override
  String get puzzleThemeCrushingDescription => 'Zie de blunder van de tegenstander om een verpletterend voordeel te verkrijgen. (eval ≥ 600cp)';

  @override
  String get puzzleThemeDoubleBishopMate => 'Mat met twee lopers';

  @override
  String get puzzleThemeDoubleBishopMateDescription => 'Twee lopers op belendende diagonalen zetten een koning mat die wordt belemmerd door de eigen stukken.';

  @override
  String get puzzleThemeDovetailMate => 'Zwaluwstaartmat';

  @override
  String get puzzleThemeDovetailMateDescription => 'Een dame zet mat naast de koning, wiens vluchtvelden geblokkeerd zijn door eigen stukken.';

  @override
  String get puzzleThemeEquality => 'Evenwicht';

  @override
  String get puzzleThemeEqualityDescription => 'Terugkomen uit een verloren stelling en een remise veiligstellen of een gelijkwaardige stelling bereiken. (eval ≤ 200cp)';

  @override
  String get puzzleThemeKingsideAttack => 'Koningsaanval';

  @override
  String get puzzleThemeKingsideAttackDescription => 'Een aanval op de vijandelijke koning na een korte rokade.';

  @override
  String get puzzleThemeClearance => 'Breekzet';

  @override
  String get puzzleThemeClearanceDescription => 'Een zet, vaak met tempo, die een veld, lijn of diagonaal vrijmaakt voor een tactisch vervolg.';

  @override
  String get puzzleThemeDefensiveMove => 'Verdedigende zet';

  @override
  String get puzzleThemeDefensiveMoveDescription => 'Een nauwkeurige zet of reeks zetten die nodig zijn om verlies van materiaal of een ander voordeel te voorkomen.';

  @override
  String get puzzleThemeDeflection => 'Weglokken';

  @override
  String get puzzleThemeDeflectionDescription => 'Een zet die een vijandelijk stuk afleidt van een andere taak die het uitoefent, zoals het bewaken van een belangrijk veld.';

  @override
  String get puzzleThemeDiscoveredAttack => 'Aftrekaanval';

  @override
  String get puzzleThemeDiscoveredAttackDescription => 'Een stuk verplaatsen dat daarvoor een aanval van een ander lange afstandsstuk blokkeerde, bijvoorbeeld een paard dat opzij gaat voor een toren.';

  @override
  String get puzzleThemeDoubleCheck => 'Dubbelschaak';

  @override
  String get puzzleThemeDoubleCheckDescription => 'Schaak geven met twee stukken tegelijk als gevolg van een aftrekaanval waarbij zowel het verplaatste als het geactiveerde stuk de koning van de tegenstander aanvalt.';

  @override
  String get puzzleThemeEndgame => 'Eindspel';

  @override
  String get puzzleThemeEndgameDescription => 'Tactiek in de slotfase van de partij.';

  @override
  String get puzzleThemeEnPassantDescription => 'Tactiek met betrekking tot de en passant-regel, waarbij een pion een vijandelijke pion die vanuit zijn beginpositie twee velden tegelijk wordt opgespeeld, kan slaan.';

  @override
  String get puzzleThemeExposedKing => 'Onveilige koning';

  @override
  String get puzzleThemeExposedKingDescription => 'Een stelling met een koning met weinig verdedigers, vaak leidend tot schaakmat.';

  @override
  String get puzzleThemeFork => 'Vork';

  @override
  String get puzzleThemeForkDescription => 'Een zet waarbij het gespeelde stuk twee vijandelijke stukken tegelijk aanvalt.';

  @override
  String get puzzleThemeHangingPiece => 'Ongedekt stuk';

  @override
  String get puzzleThemeHangingPieceDescription => 'Een situatie waarin een vijandelijk stuk niet of onvoldoende verdedigd wordt en daarom ongestraft geslagen kan worden.';

  @override
  String get puzzleThemeHookMate => 'Haakmat';

  @override
  String get puzzleThemeHookMateDescription => 'Mat met een toren, paard en pion tezamen met een vijandelijke pion om de vluchtvelden van de koning in te perken.';

  @override
  String get puzzleThemeInterference => 'Tussenplaatsing';

  @override
  String get puzzleThemeInterferenceDescription => 'Een stuk plaatsen tussen twee vijandelijke stukken om één of beide stukken onverdedigd te laten, zoals een paard op een verdedigd veld tussen twee torens.';

  @override
  String get puzzleThemeIntermezzo => 'Tussenzet';

  @override
  String get puzzleThemeIntermezzoDescription => 'In plaats van de verwachte zet, eerst een andere zet doen met een directe dreiging die de tegenstander eerst moet beantwoorden. Ook wel bekend als \"Zwischenzug\" of \"In between\".';

  @override
  String get puzzleThemeKnightEndgame => 'Paardeneindspel';

  @override
  String get puzzleThemeKnightEndgameDescription => 'Een eindspel met alleen paarden en pionnen.';

  @override
  String get puzzleThemeLong => 'Lange puzzel';

  @override
  String get puzzleThemeLongDescription => 'Winnen in drie zetten.';

  @override
  String get puzzleThemeMaster => 'Partijen van meesters';

  @override
  String get puzzleThemeMasterDescription => 'Puzzels van partijen met één titelhouder.';

  @override
  String get puzzleThemeMasterVsMaster => 'Partijen van meesters onderling';

  @override
  String get puzzleThemeMasterVsMasterDescription => 'Puzzels van partijen met twee titelhouders.';

  @override
  String get puzzleThemeMate => 'Mat';

  @override
  String get puzzleThemeMateDescription => 'De partij in stijl winnen.';

  @override
  String get puzzleThemeMateIn1 => 'Mat in 1';

  @override
  String get puzzleThemeMateIn1Description => 'Zet schaakmat in één zet.';

  @override
  String get puzzleThemeMateIn2 => 'Mat in 2';

  @override
  String get puzzleThemeMateIn2Description => 'Zet schaakmat in twee zetten.';

  @override
  String get puzzleThemeMateIn3 => 'Mat in 3';

  @override
  String get puzzleThemeMateIn3Description => 'Zet schaakmat in drie zetten.';

  @override
  String get puzzleThemeMateIn4 => 'Mat in 4';

  @override
  String get puzzleThemeMateIn4Description => 'Zet schaakmat in vier zetten.';

  @override
  String get puzzleThemeMateIn5 => 'Mat in 5 of meer';

  @override
  String get puzzleThemeMateIn5Description => 'Bedenk een langere reeks zetten.';

  @override
  String get puzzleThemeMiddlegame => 'Middenspel';

  @override
  String get puzzleThemeMiddlegameDescription => 'Tactiek in de tweede fase van de partij.';

  @override
  String get puzzleThemeOneMove => 'Eén-zet puzzel';

  @override
  String get puzzleThemeOneMoveDescription => 'Een puzzel die maar één zet vereist.';

  @override
  String get puzzleThemeOpening => 'Opening';

  @override
  String get puzzleThemeOpeningDescription => 'Tactiek in de eerste fase van de partij.';

  @override
  String get puzzleThemePawnEndgame => 'Pionneneindspel';

  @override
  String get puzzleThemePawnEndgameDescription => 'Een eindspel met alleen pionnen.';

  @override
  String get puzzleThemePin => 'Penning';

  @override
  String get puzzleThemePinDescription => 'Tactiek waarbij een stuk niet verzet kan worden op straffe van een aanval op een stuk van hogere waarde.';

  @override
  String get puzzleThemePromotion => 'Promotie';

  @override
  String get puzzleThemePromotionDescription => 'Een pion die promoveert of dreigt te promoveren is hier cruciaal.';

  @override
  String get puzzleThemeQueenEndgame => 'Dame-eindspel';

  @override
  String get puzzleThemeQueenEndgameDescription => 'Een eindspel met alleen dame en pionnen.';

  @override
  String get puzzleThemeQueenRookEndgame => 'Dame-toreneindspel';

  @override
  String get puzzleThemeQueenRookEndgameDescription => 'Een eindspel met alleen dame, torens en pionnen.';

  @override
  String get puzzleThemeQueensideAttack => 'Dameaanval';

  @override
  String get puzzleThemeQueensideAttackDescription => 'Een aanval op de vijandelijke koning na een lange rokade.';

  @override
  String get puzzleThemeQuietMove => 'Stille zet';

  @override
  String get puzzleThemeQuietMoveDescription => 'Een zet die niet schaak geeft of een stuk slaat, maar een onvermijdelijke dreiging door een latere zet voorbereidt.';

  @override
  String get puzzleThemeRookEndgame => 'Toreneindspel';

  @override
  String get puzzleThemeRookEndgameDescription => 'Een eindspel met alleen torens en pionnen.';

  @override
  String get puzzleThemeSacrifice => 'Offer';

  @override
  String get puzzleThemeSacrificeDescription => 'Tactiek waarbij op korte termijn materiaal wordt opgegeven om voordeel te verkrijgen na een aantal gedwongen zetten.';

  @override
  String get puzzleThemeShort => 'Korte puzzel';

  @override
  String get puzzleThemeShortDescription => 'Winnen in twee zetten.';

  @override
  String get puzzleThemeSkewer => 'Röntgenaanval';

  @override
  String get puzzleThemeSkewerDescription => 'Een motief waarbij een waardevol stuk wordt aangevallen en vervolgens wordt verplaatst, waardoor een lichter stuk erachter kan worden geslagen of aangevallen. Het omgekeerde van een penning.';

  @override
  String get puzzleThemeSmotheredMate => 'Stikmat';

  @override
  String get puzzleThemeSmotheredMateDescription => 'Schaakmat met een paard waarbij de aangevallen koning geen zet kan doen omdat hij ingesloten is (of verstikt) door zijn eigen stukken.';

  @override
  String get puzzleThemeSuperGM => 'Partijen van topschakers';

  @override
  String get puzzleThemeSuperGMDescription => 'Puzzels van partijen gespeeld door de beste schakers ter wereld.';

  @override
  String get puzzleThemeTrappedPiece => 'Ingesloten stuk';

  @override
  String get puzzleThemeTrappedPieceDescription => 'Een stuk kan niet meer ontsnappen omdat het geen velden meer heeft.';

  @override
  String get puzzleThemeUnderPromotion => 'Minorpromotie';

  @override
  String get puzzleThemeUnderPromotionDescription => 'Promotie tot paard, loper of toren.';

  @override
  String get puzzleThemeVeryLong => 'Zeer lange puzzel';

  @override
  String get puzzleThemeVeryLongDescription => 'Winnen in vier of meer zetten.';

  @override
  String get puzzleThemeXRayAttack => 'Röntgenaanval';

  @override
  String get puzzleThemeXRayAttackDescription => 'Een stuk valt een veld aan of verdedigt een veld, door een vijandelijk stuk heen.';

  @override
  String get puzzleThemeZugzwang => 'Zetdwang';

  @override
  String get puzzleThemeZugzwangDescription => 'De tegenstander is beperkt in de zetten die hij kan doen, en elke zet verslechtert zijn stelling.';

  @override
  String get puzzleThemeHealthyMix => 'Gezonde mix';

  @override
  String get puzzleThemeHealthyMixDescription => 'Van alles wat. Je weet niet wat je te wachten staat, je moet dus op alles voorbereid zijn! Net als in echte partijen.';

  @override
  String get puzzleThemePlayerGames => 'Eigen partijen';

  @override
  String get puzzleThemePlayerGamesDescription => 'Zoek puzzels gegenereerd uit jouw partijen, of uit partijen van een andere speler.';

  @override
  String puzzleThemePuzzleDownloadInformation(String param) {
    return 'Deze puzzels zijn beschikbaar in het publieke domein en kunnen worden gedownload op $param.';
  }

  @override
  String get searchSearch => 'Zoek';

  @override
  String get settingsSettings => 'Instellingen';

  @override
  String get settingsCloseAccount => 'Verwijder account';

  @override
  String get settingsManagedAccountCannotBeClosed => 'Je account wordt beheerd, en kan niet verwijderd worden.';

  @override
  String get settingsClosingIsDefinitive => 'Verwijderen is definitief. Er is geen weg terug. Weet je het zeker?';

  @override
  String get settingsCantOpenSimilarAccount => 'Het is niet toegestaan om een nieuw account met dezelfde naam aan te maken, ook al is het hoofdlettergebruik anders.';

  @override
  String get settingsChangedMindDoNotCloseAccount => 'Ik ben van gedachten veranderd; sluit mijn account niet';

  @override
  String get settingsCloseAccountExplanation => 'Weet je zeker dat je het account wilt verwijderen? Het verwijderen van je account is een permanente beslissing. Je kunt NOOIT meer op dit account inloggen.';

  @override
  String get settingsThisAccountIsClosed => 'Dit account is gesloten.';

  @override
  String get playWithAFriend => 'Speel tegen een vriend';

  @override
  String get playWithTheMachine => 'Speel tegen de computer';

  @override
  String get toInviteSomeoneToPlayGiveThisUrl => 'Deel deze link als u iemand wil uitnodigen om met u te spelen';

  @override
  String get gameOver => 'Partij afgelopen';

  @override
  String get waitingForOpponent => 'Wachten op een tegenstander';

  @override
  String get orLetYourOpponentScanQrCode => 'Of laat je tegenstander deze QR-code scannen';

  @override
  String get waiting => 'Even geduld a.u.b.';

  @override
  String get yourTurn => 'U bent aan zet';

  @override
  String aiNameLevelAiLevel(String param1, String param2) {
    return '$param1 niveau $param2';
  }

  @override
  String get level => 'Niveau';

  @override
  String get strength => 'Speelsterkte';

  @override
  String get toggleTheChat => 'Chat aan-/uitzetten';

  @override
  String get chat => 'Chat';

  @override
  String get resign => 'Geef op';

  @override
  String get checkmate => 'Schaakmat';

  @override
  String get stalemate => 'Pat';

  @override
  String get white => 'Wit';

  @override
  String get black => 'Zwart';

  @override
  String get asWhite => 'met wit';

  @override
  String get asBlack => 'met zwart';

  @override
  String get randomColor => 'Willekeurige kleur';

  @override
  String get createAGame => 'Start een nieuwe partij';

  @override
  String get whiteIsVictorious => 'Wit heeft gewonnen';

  @override
  String get blackIsVictorious => 'Zwart heeft gewonnen';

  @override
  String get youPlayTheWhitePieces => 'Je speelt met wit';

  @override
  String get youPlayTheBlackPieces => 'Je speelt met zwart';

  @override
  String get itsYourTurn => 'Je bent aan zet!';

  @override
  String get cheatDetected => 'Valsspelen gedetecteerd';

  @override
  String get kingInTheCenter => 'Koning in het centrum';

  @override
  String get threeChecks => 'Drie keer schaak';

  @override
  String get raceFinished => 'De race is voorbij';

  @override
  String get variantEnding => 'Einde van de variant';

  @override
  String get newOpponent => 'Nieuwe tegenstander';

  @override
  String get yourOpponentWantsToPlayANewGameWithYou => 'Uw tegenstander wil een nieuwe partij met u spelen';

  @override
  String get joinTheGame => 'Speel mee';

  @override
  String get whitePlays => 'Wit aan zet';

  @override
  String get blackPlays => 'Zwart aan zet';

  @override
  String get opponentLeftChoices => 'De andere speler is weggegaan. U kunt de winst opeisen, remise claimen of wachten.';

  @override
  String get forceResignation => 'Eis de overwinning op';

  @override
  String get forceDraw => 'Dwing remise af';

  @override
  String get talkInChat => 'Wees a.u.b. vriendelijk in de chat!';

  @override
  String get theFirstPersonToComeOnThisUrlWillPlayWithYou => 'Degene die als eerste op deze link klikt, zal met u spelen.';

  @override
  String get whiteResigned => 'Wit geeft op';

  @override
  String get blackResigned => 'Zwart geeft op';

  @override
  String get whiteLeftTheGame => 'Wit is weggegaan';

  @override
  String get blackLeftTheGame => 'Zwart is weggegaan';

  @override
  String get whiteDidntMove => 'Wit heeft niet gezet';

  @override
  String get blackDidntMove => 'Zwart heeft niet gezet';

  @override
  String get requestAComputerAnalysis => 'Verzoek een computeranalyse';

  @override
  String get computerAnalysis => 'Analyse door de computer';

  @override
  String get computerAnalysisAvailable => 'Computeranalyse beschikbaar';

  @override
  String get computerAnalysisDisabled => 'Computeranalyse uitgeschakeld';

  @override
  String get analysis => 'Analyse';

  @override
  String depthX(String param) {
    return 'Diepte $param';
  }

  @override
  String get usingServerAnalysis => 'Met serveranalyse';

  @override
  String get loadingEngine => 'Laden van computer...';

  @override
  String get calculatingMoves => 'Zetten berekenen...';

  @override
  String get engineFailed => 'Fout bij laden engine';

  @override
  String get cloudAnalysis => 'Cloud-analyse';

  @override
  String get goDeeper => 'Dieper gaan';

  @override
  String get showThreat => 'Toon dreiging';

  @override
  String get inLocalBrowser => 'in lokale browser';

  @override
  String get toggleLocalEvaluation => 'Lokale evaluatie aan-/uitzetten';

  @override
  String get promoteVariation => 'Promoveer variant';

  @override
  String get makeMainLine => 'Maak hoofdvariant';

  @override
  String get deleteFromHere => 'Verwijder vanaf hier';

  @override
  String get collapseVariations => 'Varianten verbergen';

  @override
  String get expandVariations => 'Varianten weergeven';

  @override
  String get forceVariation => 'Forceer variatie';

  @override
  String get copyVariationPgn => 'Kopieer variatie PGN';

  @override
  String get move => 'Zet';

  @override
  String get variantLoss => 'Variantverlies';

  @override
  String get variantWin => 'Variantoverwinning';

  @override
  String get insufficientMaterial => 'Onvoldoende materiaal';

  @override
  String get pawnMove => 'Pionzet';

  @override
  String get capture => 'Slagzet';

  @override
  String get close => 'Sluit';

  @override
  String get winning => 'Winnend';

  @override
  String get losing => 'Verliest';

  @override
  String get drawn => 'Remise';

  @override
  String get unknown => 'Onbekend';

  @override
  String get database => 'Databank';

  @override
  String get whiteDrawBlack => 'Wit / Remise / Zwart';

  @override
  String averageRatingX(String param) {
    return 'Gemiddelde rating: $param';
  }

  @override
  String get recentGames => 'Recente partijen';

  @override
  String get topGames => 'Toppartijen';

  @override
  String masterDbExplanation(String param1, String param2, String param3) {
    return 'Twee miljoen OTB-partijen van $param1+ FIDE-gerankte spelers van $param2 tot $param3';
  }

  @override
  String get dtzWithRounding => 'DTZ50\'\' met afronding, gebaseerd op het aantal halfzetten tot de volgende stukwinst of pionzet';

  @override
  String get noGameFound => 'Geen partij gevonden';

  @override
  String get maxDepthReached => 'Maximale diepte bereikt!';

  @override
  String get maybeIncludeMoreGamesFromThePreferencesMenu => 'Misschien meer partijen toevoegen via het voorkeuren-menu?';

  @override
  String get openings => 'Openingen';

  @override
  String get openingExplorer => 'Openingverkenner';

  @override
  String get openingEndgameExplorer => 'Opening-/eindspelverkenner';

  @override
  String xOpeningExplorer(String param) {
    return '$param openingsverkenner';
  }

  @override
  String get playFirstOpeningEndgameExplorerMove => 'Speel de eerste zet/eindverkenner';

  @override
  String get winPreventedBy50MoveRule => 'Winst voorkomen door vijftig-zetten regel';

  @override
  String get lossSavedBy50MoveRule => 'Verlies gered door vijftig-zetten regel';

  @override
  String get winOr50MovesByPriorMistake => 'Winst of 50 zetten door een voorafgaande fout';

  @override
  String get lossOr50MovesByPriorMistake => 'Verlies of 50 zetten door voorafgaande fout';

  @override
  String get unknownDueToRounding => 'Winst/verlies alleen gegarandeerd als aanbevolen tablebase-regel is gevolgd sinds het meest recente stukwinst of de meest recente pionzet, ten gevolge van eventuele afronding.';

  @override
  String get allSet => 'Klaar!';

  @override
  String get importPgn => 'PGN importeren';

  @override
  String get delete => 'Verwijderen';

  @override
  String get deleteThisImportedGame => 'Deze geïmporteerde partij verwijderen?';

  @override
  String get replayMode => 'Terugspeelmodus';

  @override
  String get realtimeReplay => 'Realtime';

  @override
  String get byCPL => 'Door CPL';

  @override
  String get openStudy => 'Open Study';

  @override
  String get enable => 'Aanzetten';

  @override
  String get bestMoveArrow => 'Beste zet-pijl';

  @override
  String get showVariationArrows => 'Toon variantpijlen';

  @override
  String get evaluationGauge => 'Evaluatiemeter';

  @override
  String get multipleLines => 'Meerdere varianten';

  @override
  String get cpus => 'CPUs';

  @override
  String get memory => 'Geheugen';

  @override
  String get infiniteAnalysis => 'Oneindige analyse';

  @override
  String get removesTheDepthLimit => 'Verwijdert de dieptelimiet, en houdt je computer warm';

  @override
  String get engineManager => 'Engine-beheer';

  @override
  String get blunder => 'Blunder';

  @override
  String get mistake => 'Fout';

  @override
  String get inaccuracy => 'Onnauwkeurigheid';

  @override
  String get moveTimes => 'Tijdsgebruik van zetten';

  @override
  String get flipBoard => 'Bord draaien';

  @override
  String get threefoldRepetition => 'Driemaal dezelfde stelling';

  @override
  String get claimADraw => 'Remise opeisen';

  @override
  String get offerDraw => 'Remise aanbieden';

  @override
  String get draw => 'Remise';

  @override
  String get drawByMutualAgreement => 'Remise overeengekomen';

  @override
  String get fiftyMovesWithoutProgress => 'Vijftig zetten zonder voortgang';

  @override
  String get currentGames => 'Lopende partijen';

  @override
  String get viewInFullSize => 'Bekijk op volledige grootte';

  @override
  String get logOut => 'Afmelden';

  @override
  String get signIn => 'Aanmelden';

  @override
  String get rememberMe => 'Mijn gegevens onthouden';

  @override
  String get youNeedAnAccountToDoThat => 'Je hebt een account nodig om dat te doen';

  @override
  String get signUp => 'Registreren';

  @override
  String get computersAreNotAllowedToPlay => 'Computers en spelers met ondersteuning van schaakengines mogen hier niet spelen. Maak a.u.b. geen gebruik van schaakengines, databases of de hulp van andere spelers terwijl je je partijen speelt.';

  @override
  String get games => 'Partijen';

  @override
  String get forum => 'Forum';

  @override
  String xPostedInForumY(String param1, String param2) {
    return '$param1 plaatste een bericht in topic $param2';
  }

  @override
  String get latestForumPosts => 'Recente forumberichten';

  @override
  String get players => 'Spelers';

  @override
  String get friends => 'Vrienden';

  @override
  String get discussions => 'Discussies';

  @override
  String get today => 'Vandaag';

  @override
  String get yesterday => 'Gisteren';

  @override
  String get minutesPerSide => 'Minuten per speler';

  @override
  String get variant => 'Variant';

  @override
  String get variants => 'Varianten';

  @override
  String get timeControl => 'Speelduur';

  @override
  String get realTime => 'Live';

  @override
  String get correspondence => 'Correspondentie';

  @override
  String get daysPerTurn => 'Dagen per zet';

  @override
  String get oneDay => 'Eén dag';

  @override
  String get time => 'Tijd';

  @override
  String get rating => 'Rating';

  @override
  String get ratingStats => 'Ratingsstatistieken';

  @override
  String get username => 'Gebruikersnaam';

  @override
  String get usernameOrEmail => 'Gebruikersnaam of email';

  @override
  String get changeUsername => 'Wijzig gebruikersnaam';

  @override
  String get changeUsernameNotSame => 'Enkel de hoofdlettergevoeligheid van de letters kan veranderen. Bijvoorbeeld van \"janjansen\" naar \"JanJansen\".';

  @override
  String get changeUsernameDescription => 'Wijzig je gebruikersnaam. Dit kan slechts eenmaal worden gedaan en je kunt alleen het hoofdlettergebruik van je gebruikersnaam veranderen.';

  @override
  String get signupUsernameHint => 'Zorg ervoor dat u een gezinsvriendelijke gebruikersnaam kiest. U kunt het later niet meer wijzigen en alle accounts met ongepaste gebruikersnamen zullen gesloten worden!';

  @override
  String get signupEmailHint => 'We zullen het alleen gebruiken om het wachtwoord opnieuw in te stellen.';

  @override
  String get password => 'Wachtwoord';

  @override
  String get changePassword => 'Wijzig wachtwoord';

  @override
  String get changeEmail => 'Verander email';

  @override
  String get email => 'Email';

  @override
  String get passwordReset => 'Nieuw wachtwoord';

  @override
  String get forgotPassword => 'Wachtwoord vergeten?';

  @override
  String get error_weakPassword => 'Dit wachtwoord komt heel vaak voor en is te gemakkelijk te raden.';

  @override
  String get error_namePassword => 'Gebruik uw gebruikersnaam niet als wachtwoord.';

  @override
  String get blankedPassword => 'Je hebt hetzelfde wachtwoord gebruikt op een andere site en die site heeft een datalek gehad. Om de veiligheid van je Lichess-account te garanderen, dien je een nieuw wachtwoord in te stellen. Bedankt voor je begrip.';

  @override
  String get youAreLeavingLichess => 'Je verlaat Lichess';

  @override
  String get neverTypeYourPassword => 'Voer je Lichess-wachtwoord nooit in op een andere website!';

  @override
  String proceedToX(String param) {
    return 'Ga naar $param';
  }

  @override
  String get passwordSuggestion => 'Stel geen wachtwoord in dat iemand anders voorstelt. Ze kunnen het gebruiken om je account te stelen.';

  @override
  String get emailSuggestion => 'Stel geen e-mailadres in dat iemand anders voorstelt. Ze kunnen het gebruiken om je account te stelen.';

  @override
  String get emailConfirmHelp => 'Hulp met e-mailbevestiging';

  @override
  String get emailConfirmNotReceived => 'Geen bevestigingsmail ontvangen na aanmelden?';

  @override
  String get whatSignupUsername => 'Welke gebruikersnaam heb je gebruikt om je aan te melden?';

  @override
  String usernameNotFound(String param) {
    return 'We konden geen gebruiker vinden met deze naam: $param.';
  }

  @override
  String get usernameCanBeUsedForNewAccount => 'U kunt deze gebruikersnaam gebruiken om een nieuw account aan te maken';

  @override
  String emailSent(String param) {
    return 'We hebben een e-mail gestuurd naar $param.';
  }

  @override
  String get emailCanTakeSomeTime => 'Het kan even duren voordat de mail binnenkomt.';

  @override
  String get refreshInboxAfterFiveMinutes => 'Wacht 5 minuten en vernieuw uw e-mail inbox.';

  @override
  String get checkSpamFolder => 'Controleer ook uw spammap, het kan daar terechtkomen. Als dat zo is, markeer het als geen spam.';

  @override
  String get emailForSignupHelp => 'Als niks anders lukt, stuur ons dan deze e-mail:';

  @override
  String copyTextToEmail(String param) {
    return 'Kopieer en plak de bovenstaande tekst en stuur het naar $param';
  }

  @override
  String get waitForSignupHelp => 'We nemen binnenkort contact op om te helpen bij het afronden van de inschrijving.';

  @override
  String accountConfirmed(String param) {
    return 'Gebruiker $param is succesvol bevestigd.';
  }

  @override
  String accountCanLogin(String param) {
    return 'Je kunt nu inloggen als $param.';
  }

  @override
  String get accountConfirmationEmailNotNeeded => 'Je hebt geen bevestigingsmail nodig.';

  @override
  String accountClosed(String param) {
    return 'Account $param is gesloten.';
  }

  @override
  String accountRegisteredWithoutEmail(String param) {
    return 'Account $param is geregistreerd zonder e-mail.';
  }

  @override
  String get rank => 'Positie';

  @override
  String rankX(String param) {
    return 'Positie: $param';
  }

  @override
  String get gamesPlayed => 'Gespeelde partijen';

  @override
  String get cancel => 'Annuleren';

  @override
  String get whiteTimeOut => 'Tijd om voor wit';

  @override
  String get blackTimeOut => 'Tijd om voor zwart';

  @override
  String get drawOfferSent => 'Remiseaanbod verstuurd';

  @override
  String get drawOfferAccepted => 'Remiseaanbod geaccepteerd';

  @override
  String get drawOfferCanceled => 'Remiseaanbod geannuleerd';

  @override
  String get whiteOffersDraw => 'Wit biedt remise aan';

  @override
  String get blackOffersDraw => 'Zwart biedt remise aan';

  @override
  String get whiteDeclinesDraw => 'Wit weigert remise';

  @override
  String get blackDeclinesDraw => 'Zwart weigert remise';

  @override
  String get yourOpponentOffersADraw => 'Uw tegenstander biedt remise aan';

  @override
  String get accept => 'Accepteren';

  @override
  String get decline => 'Afwijzen';

  @override
  String get playingRightNow => 'Nu aan het spelen';

  @override
  String get eventInProgress => 'Nu aan het spelen';

  @override
  String get finished => 'Afgelopen';

  @override
  String get abortGame => 'Partij afbreken';

  @override
  String get gameAborted => 'Partij afgebroken';

  @override
  String get standard => 'Standaard';

  @override
  String get customPosition => 'Custom position';

  @override
  String get unlimited => 'Onbeperkt';

  @override
  String get mode => 'Instelling';

  @override
  String get casual => 'Vrijblijvend';

  @override
  String get rated => 'Met rating';

  @override
  String get casualTournament => 'Zonder rating';

  @override
  String get ratedTournament => 'Met rating';

  @override
  String get thisGameIsRated => 'Deze partij telt mee voor rating';

  @override
  String get rematch => 'Opnieuw spelen';

  @override
  String get rematchOfferSent => 'Uitnodiging voor nieuwe partij verstuurd';

  @override
  String get rematchOfferAccepted => 'Uitnodiging voor nieuwe partij geaccepteerd';

  @override
  String get rematchOfferCanceled => 'Uitnodiging voor nieuwe partij geannuleerd';

  @override
  String get rematchOfferDeclined => 'Uitnodiging voor nieuwe partij geweigerd';

  @override
  String get cancelRematchOffer => 'Uitnodiging voor nieuwe partij annuleren';

  @override
  String get viewRematch => 'Herkansingspartij bekijken';

  @override
  String get confirmMove => 'Bevestig zet';

  @override
  String get play => 'Spelen';

  @override
  String get inbox => 'Postvak IN';

  @override
  String get chatRoom => 'Chatruimte';

  @override
  String get loginToChat => 'Meld je aan om te chatten';

  @override
  String get youHaveBeenTimedOut => 'Je mag even niet chatten.';

  @override
  String get spectatorRoom => 'Toeschouwersruimte';

  @override
  String get composeMessage => 'Een nieuw bericht schrijven';

  @override
  String get subject => 'Onderwerp';

  @override
  String get send => 'Verstuur';

  @override
  String get incrementInSeconds => 'Seconden extra per zet';

  @override
  String get freeOnlineChess => 'Gratis online schaken';

  @override
  String get exportGames => 'Partijen exporteren';

  @override
  String get ratingRange => 'Ratingbereik';

  @override
  String get thisAccountViolatedTos => 'Dit account heeft de Lichess Servicevoorwaarden geschonden';

  @override
  String get openingExplorerAndTablebase => 'Openingsverkenner & tablebase';

  @override
  String get takeback => 'Neem zet terug';

  @override
  String get proposeATakeback => 'Stel zet terugnemen voor';

  @override
  String get takebackPropositionSent => 'Terugname-voorstel verstuurd';

  @override
  String get takebackPropositionDeclined => 'Terugname-voorstel geweigerd';

  @override
  String get takebackPropositionAccepted => 'Terugname-voorstel geaccepteerd';

  @override
  String get takebackPropositionCanceled => 'Terugname-voorstel geannuleerd';

  @override
  String get yourOpponentProposesATakeback => 'Uw tegenstander stelt een terugname voor';

  @override
  String get bookmarkThisGame => 'Voeg deze partij toe aan uw favorieten';

  @override
  String get tournament => 'Toernooi';

  @override
  String get tournaments => 'Toernooien';

  @override
  String get tournamentPoints => 'Toernooipunten';

  @override
  String get viewTournament => 'Bekijk het toernooi';

  @override
  String get backToTournament => 'Terug naar het toernooi';

  @override
  String get noDrawBeforeSwissLimit => 'In een Zwitsers toernooi kun je pas na 30 zetten remise aanbieden.';

  @override
  String get thematic => 'Thematisch';

  @override
  String yourPerfRatingIsProvisional(String param) {
    return 'Je $param rating is een voorlopige';
  }

  @override
  String yourPerfRatingIsTooHigh(String param1, String param2) {
    return 'Je rating $param1 ($param2) is te hoog';
  }

  @override
  String yourTopWeeklyPerfRatingIsTooHigh(String param1, String param2) {
    return 'Je beste hoogste rating deze week $param1 ($param2) is te hoog';
  }

  @override
  String yourPerfRatingIsTooLow(String param1, String param2) {
    return 'Je rating $param1 ($param2) is te laag';
  }

  @override
  String ratedMoreThanInPerf(String param1, String param2) {
    return 'Met rating ≥ $param1 in $param2';
  }

  @override
  String ratedLessThanInPerf(String param1, String param2) {
    return 'Met rating ≤ $param1 in $param2';
  }

  @override
  String mustBeInTeam(String param) {
    return 'Je moet in team $param zitten';
  }

  @override
  String youAreNotInTeam(String param) {
    return 'Je zit niet in het team $param';
  }

  @override
  String get backToGame => 'Terug naar partij';

  @override
  String get siteDescription => 'Gratis online schaken. Schaak nu met een heldere vormgeving. Geen registratie nodig, geen advertenties, geen plug-ins vereist. Schaak tegen de computer, vrienden of willekeurige tegenstanders.';

  @override
  String xJoinedTeamY(String param1, String param2) {
    return '$param1 sloot zich bij team $param2 aan';
  }

  @override
  String xCreatedTeamY(String param1, String param2) {
    return '$param1 heeft team $param2 opgericht';
  }

  @override
  String get startedStreaming => 'is begonnen met streamen';

  @override
  String xStartedStreaming(String param) {
    return '$param is begonnen met streamen';
  }

  @override
  String get averageElo => 'Gemiddelde rating';

  @override
  String get location => 'Plaats';

  @override
  String get filterGames => 'Partijen filteren';

  @override
  String get reset => 'Herstel';

  @override
  String get apply => 'Toepassen';

  @override
  String get save => 'Bewaar';

  @override
  String get leaderboard => 'Ranglijst';

  @override
  String get screenshotCurrentPosition => 'Schermafbeelding huidige stelling';

  @override
  String get gameAsGIF => 'Download partij als GIF';

  @override
  String get pasteTheFenStringHere => 'Plak de FEN-code hier';

  @override
  String get pasteThePgnStringHere => 'Plak de PGN-code hier';

  @override
  String get orUploadPgnFile => 'Of upload een PGN-bestand';

  @override
  String get fromPosition => 'Vanuit een stelling';

  @override
  String get continueFromHere => 'Ga vanaf hier verder';

  @override
  String get toStudy => 'Studie';

  @override
  String get importGame => 'Importeer partij';

  @override
  String get importGameExplanation => 'Als je een PGN in het venster plakt, krijg je een doorzoekbare replay, een computeranalyse, een chatbox bij de partij en een deelbare URL.';

  @override
  String get importGameCaveat => 'Variaties worden gewist. Om ze te behouden, importeer de PGN via een studie.';

  @override
  String get importGameDataPrivacyWarning => 'Deze PGN kan toegankelijk zijn voor iedereen. Gebruik een studie om een partij privé te importeren.';

  @override
  String get thisIsAChessCaptcha => 'Dit is een schaak CAPTCHA.';

  @override
  String get clickOnTheBoardToMakeYourMove => 'Klik op het bord om je zet te spelen en te bewijzen dat je een mens bent.';

  @override
  String get captcha_fail => 'Gelieve de schaak-captcha op te lossen.';

  @override
  String get notACheckmate => 'Dit is geen schaakmat';

  @override
  String get whiteCheckmatesInOneMove => 'Wit zet schaakmat in één zet';

  @override
  String get blackCheckmatesInOneMove => 'Zwart zet schaakmat in één zet';

  @override
  String get retry => 'Probeer het opnieuw';

  @override
  String get reconnecting => 'Opnieuw aan het verbinden';

  @override
  String get noNetwork => 'Offline';

  @override
  String get favoriteOpponents => 'Favoriete tegenstanders';

  @override
  String get follow => 'Volgen';

  @override
  String get following => 'Volgend';

  @override
  String get unfollow => 'Stop met volgen';

  @override
  String followX(String param) {
    return 'Volg $param';
  }

  @override
  String unfollowX(String param) {
    return '$param ontvolgen';
  }

  @override
  String get block => 'Blokkeren';

  @override
  String get blocked => 'Geblokkeerd';

  @override
  String get unblock => 'Deblokkeren';

  @override
  String get followsYou => 'Volgt u';

  @override
  String xStartedFollowingY(String param1, String param2) {
    return '$param1 volgt nu $param2';
  }

  @override
  String get more => 'Meer';

  @override
  String get memberSince => 'Lid sinds';

  @override
  String lastSeenActive(String param) {
    return '$param voor het laatst gezien';
  }

  @override
  String get player => 'Speler';

  @override
  String get list => 'Lijst';

  @override
  String get graph => 'Grafiek';

  @override
  String get required => 'Vereist.';

  @override
  String get openTournaments => 'Open toernooien';

  @override
  String get duration => 'Tijdsduur';

  @override
  String get winner => 'Winnaar';

  @override
  String get standing => 'Ranglijst';

  @override
  String get createANewTournament => 'Start een nieuw toernooi';

  @override
  String get tournamentCalendar => 'Toernooikalender';

  @override
  String get conditionOfEntry => 'Voorwaarde voor deelname:';

  @override
  String get advancedSettings => 'Geavanceerde instellingen';

  @override
  String get safeTournamentName => 'Kies een zeer veilige naam voor het toernooi.';

  @override
  String get inappropriateNameWarning => 'Bij zelfs het minste vermoeden van een misplaatst gekozen naam, kan uw account gesloten worden.';

  @override
  String get emptyTournamentName => 'Laat het veld leeg om het toernooi naar een willekeurige grootmeester te vernoemen.';

  @override
  String get makePrivateTournament => 'Maak het toernooi privé en beperk de toegang met een wachtwoord';

  @override
  String get join => 'Neem deel';

  @override
  String get withdraw => 'Trek terug';

  @override
  String get points => 'Punten';

  @override
  String get wins => 'Gewonnen';

  @override
  String get losses => 'Verloren';

  @override
  String get createdBy => 'Gemaakt door';

  @override
  String get tournamentIsStarting => 'Het toernooi begint';

  @override
  String get tournamentPairingsAreNowClosed => 'De toernooiparingen zijn nu gesloten.';

  @override
  String standByX(String param) {
    return 'Sta klaar $param, spelers worden gepaard, maak je gereed!';
  }

  @override
  String get pause => 'Pauzeren';

  @override
  String get resume => 'Hervatten';

  @override
  String get youArePlaying => 'Je bent aan het spelen!';

  @override
  String get winRate => 'Win percentage';

  @override
  String get berserkRate => 'Berserk-percentage';

  @override
  String get performance => 'Prestatierating';

  @override
  String get tournamentComplete => 'Toernooi voltooid';

  @override
  String get movesPlayed => 'Gespeelde zetten';

  @override
  String get whiteWins => 'Overwinningen met wit';

  @override
  String get blackWins => 'Overwinningen met zwart';

  @override
  String get drawRate => 'Remisepercentage';

  @override
  String get draws => 'Remises';

  @override
  String nextXTournament(String param) {
    return 'Volgend $param-toernooi:';
  }

  @override
  String get averageOpponent => 'Gemiddelde tegenstander';

  @override
  String get boardEditor => 'Bordbewerker';

  @override
  String get setTheBoard => 'Zet het bord op';

  @override
  String get popularOpenings => 'Populaire openingen';

  @override
  String get endgamePositions => 'Eindspel posities';

  @override
  String chess960StartPosition(String param) {
    return 'Beginstelling Chess960: $param';
  }

  @override
  String get startPosition => 'Beginstelling';

  @override
  String get clearBoard => 'Maak het bord leeg';

  @override
  String get loadPosition => 'Laad een stelling';

  @override
  String get isPrivate => 'Privé';

  @override
  String reportXToModerators(String param) {
    return 'Rapporteer $param aan de toezichthouders';
  }

  @override
  String profileCompletion(String param) {
    return 'Voltooiing profiel: $param';
  }

  @override
  String xRating(String param) {
    return '$param-rating';
  }

  @override
  String get ifNoneLeaveEmpty => 'Leeg indien n.v.t.';

  @override
  String get profile => 'Profiel';

  @override
  String get editProfile => 'Pas profiel aan';

  @override
  String get realName => 'Echte naam';

  @override
  String get setFlair => 'Stel je flair in';

  @override
  String get flair => 'Symbool';

  @override
  String get youCanHideFlair => 'Er bestaat een instelling om alle gebruikersflairs over de hele site te verbergen.';

  @override
  String get biography => 'Biografie';

  @override
  String get countryRegion => 'Land of regio';

  @override
  String get thankYou => 'Bedankt!';

  @override
  String get socialMediaLinks => 'Links naar sociale media';

  @override
  String get oneUrlPerLine => 'Eén URL per regel.';

  @override
  String get inlineNotation => 'Geïntegreerde notatie';

  @override
  String get makeAStudy => 'Maak een studie aan om ze te bewaren en/of te delen.';

  @override
  String get clearSavedMoves => 'Zetten wissen';

  @override
  String get previouslyOnLichessTV => 'Voorheen op Lichess TV';

  @override
  String get onlinePlayers => 'Online spelers';

  @override
  String get activePlayers => 'Actieve spelers';

  @override
  String get bewareTheGameIsRatedButHasNoClock => 'Let op, de partij is met rating maar heeft geen klok!';

  @override
  String get success => 'Succes';

  @override
  String get automaticallyProceedToNextGameAfterMoving => 'Na je zet direct doorgaan naar de volgende partij';

  @override
  String get autoSwitch => 'Automatische switch';

  @override
  String get puzzles => 'Puzzels';

  @override
  String get onlineBots => 'Online bots';

  @override
  String get name => 'Naam';

  @override
  String get description => 'Beschrijving';

  @override
  String get descPrivate => 'Interne beschrijving';

  @override
  String get descPrivateHelp => 'Tekst die alleen de teamleden zien. Indien ingesteld, vervangt deze de openbare beschrijving voor teamleden.';

  @override
  String get no => 'Nee';

  @override
  String get yes => 'Ja';

  @override
  String get help => 'Help:';

  @override
  String get createANewTopic => 'Maak een nieuw onderwerp';

  @override
  String get topics => 'Onderwerpen';

  @override
  String get posts => 'Berichten';

  @override
  String get lastPost => 'Laatste bericht';

  @override
  String get views => 'Weergaven';

  @override
  String get replies => 'Reacties';

  @override
  String get replyToThisTopic => 'Reageer op dit onderwerp';

  @override
  String get reply => 'Reageer';

  @override
  String get message => 'Bericht';

  @override
  String get createTheTopic => 'Maak een nieuw onderwerp';

  @override
  String get reportAUser => 'Gebruiker melden';

  @override
  String get user => 'Gebruiker';

  @override
  String get reason => 'Reden';

  @override
  String get whatIsIheMatter => 'Wat is er aan de hand?';

  @override
  String get cheat => 'Valsspelen';

  @override
  String get troll => 'Provoceren';

  @override
  String get other => 'Anders';

  @override
  String get reportDescriptionHelp => 'Plak de link naar de partij(en) en leg uit wat er mis is met het gedrag van de gebruiker. Zeg niet alleen \'hij speelt vals\', maar vertel ons hoe u bent gekomen op deze conclusie. Uw rapportage zal sneller worden verwerkt als het in het Engels is geschreven.';

  @override
  String get error_provideOneCheatedGameLink => 'Geef ten minste één link naar een partij waarin vals gespeeld is.';

  @override
  String by(String param) {
    return 'door $param';
  }

  @override
  String importedByX(String param) {
    return 'Geïmporteerd door $param';
  }

  @override
  String get thisTopicIsNowClosed => 'Dit onderwerp is nu gesloten.';

  @override
  String get blog => 'Blog';

  @override
  String get notes => 'Notities';

  @override
  String get typePrivateNotesHere => 'Type privénotities hier';

  @override
  String get writeAPrivateNoteAboutThisUser => 'Maak een privé-notitie over deze gebruiker';

  @override
  String get noNoteYet => 'Nog geen notities';

  @override
  String get invalidUsernameOrPassword => 'Ongeldige gebruikersnaam of wachtwoord';

  @override
  String get incorrectPassword => 'Onjuist wachtwoord';

  @override
  String get invalidAuthenticationCode => 'Ongeldige authenticatiecode';

  @override
  String get emailMeALink => 'Email me een link';

  @override
  String get currentPassword => 'Huidig wachtwoord';

  @override
  String get newPassword => 'Nieuw wachtwoord';

  @override
  String get newPasswordAgain => 'Nieuw wachtwoord (opnieuw)';

  @override
  String get newPasswordsDontMatch => 'De nieuwe wachtwoorden komen niet overeen';

  @override
  String get newPasswordStrength => 'Wachtwoordsterkte';

  @override
  String get clockInitialTime => 'Oorspronkelijke kloktijd';

  @override
  String get clockIncrement => 'Bijtelling';

  @override
  String get privacy => 'Privacy';

  @override
  String get privacyPolicy => 'privacybeleid';

  @override
  String get letOtherPlayersFollowYou => 'Andere spelers mogen je volgen';

  @override
  String get letOtherPlayersChallengeYou => 'Andere spelers mogen je uitdagen';

  @override
  String get letOtherPlayersInviteYouToStudy => 'Laat andere spelers je uitnodigen voor een Study';

  @override
  String get sound => 'Geluid';

  @override
  String get none => 'Geen';

  @override
  String get fast => 'Snel';

  @override
  String get normal => 'Normaal';

  @override
  String get slow => 'Traag';

  @override
  String get insideTheBoard => 'Binnen het bord';

  @override
  String get outsideTheBoard => 'Buiten het bord';

  @override
  String get allSquaresOfTheBoard => 'Alle velden van het bord';

  @override
  String get onSlowGames => 'Alleen bij langzame partijen';

  @override
  String get always => 'Altijd';

  @override
  String get never => 'Nooit';

  @override
  String xCompetesInY(String param1, String param2) {
    return '$param1 neemt deel aan $param2';
  }

  @override
  String get victory => 'Overwinning';

  @override
  String get defeat => 'Nederlaag';

  @override
  String victoryVsYInZ(String param1, String param2, String param3) {
    return '$param1 vs. $param2 in $param3';
  }

  @override
  String defeatVsYInZ(String param1, String param2, String param3) {
    return '$param1 vs $param2 in $param3';
  }

  @override
  String drawVsYInZ(String param1, String param2, String param3) {
    return '$param1 vs. $param2 in $param3';
  }

  @override
  String get timeline => 'Tijdslijn';

  @override
  String get starting => 'Startend:';

  @override
  String get allInformationIsPublicAndOptional => 'Alle informatie is publiek toegankelijk en optioneel.';

  @override
  String get biographyDescription => 'Vertel over jezelf, wat je aantrekt in schaken, je favoriete openingen, partijen, spelers…';

  @override
  String get listBlockedPlayers => 'Toon lijst geblokkeerde spelers';

  @override
  String get human => 'Menselijke speler';

  @override
  String get computer => 'Computer';

  @override
  String get side => 'Kleur';

  @override
  String get clock => 'Klok';

  @override
  String get opponent => 'Tegenstander';

  @override
  String get learnMenu => 'Leren';

  @override
  String get studyMenu => 'Studie';

  @override
  String get practice => 'Oefenen';

  @override
  String get community => 'Gemeenschap';

  @override
  String get tools => 'Gereedschap';

  @override
  String get increment => 'Extra tijd';

  @override
  String get error_unknown => 'Ongeldige waarde';

  @override
  String get error_required => 'Dit invullen is verplicht';

  @override
  String get error_email => 'Dit e-mailadres is ongeldig';

  @override
  String get error_email_acceptable => 'Dit e-mailadres is niet acceptabel. Controleer het nogmaals en probeer het opnieuw.';

  @override
  String get error_email_unique => 'E-mailadres ongeldig of al in gebruik';

  @override
  String get error_email_different => 'Dit is al uw e-mailadres';

  @override
  String error_minLength(String param) {
    return 'Minimumlengte is $param tekens';
  }

  @override
  String error_maxLength(String param) {
    return 'Maximumlengte is $param tekens';
  }

  @override
  String error_min(String param) {
    return 'Moet groter dan of gelijk zijn aan $param';
  }

  @override
  String error_max(String param) {
    return 'Moet kleiner dan of gelijk zijn aan $param';
  }

  @override
  String ifRatingIsPlusMinusX(String param) {
    return 'Indien de rating ± $param is';
  }

  @override
  String get ifRegistered => 'Indien geregistreerd';

  @override
  String get onlyExistingConversations => 'Alleen bestaande gesprekken';

  @override
  String get onlyFriends => 'Alleen vrienden';

  @override
  String get menu => 'Menu';

  @override
  String get castling => 'Rokeren';

  @override
  String get whiteCastlingKingside => 'Wit O-O';

  @override
  String get blackCastlingKingside => 'Zwart O-O';

  @override
  String tpTimeSpentPlaying(String param) {
    return 'Tijd schakend besteed: $param';
  }

  @override
  String get watchGames => 'Bekijk partijen';

  @override
  String tpTimeSpentOnTV(String param) {
    return 'Tijd op TV: $param';
  }

  @override
  String get watch => 'Kijken';

  @override
  String get videoLibrary => 'Videobibliotheek';

  @override
  String get streamersMenu => 'Streamers';

  @override
  String get mobileApp => 'Mobiele app';

  @override
  String get webmasters => 'Webmasters';

  @override
  String get about => 'Over ons';

  @override
  String aboutX(String param) {
    return 'Over $param';
  }

  @override
  String xIsAFreeYLibreOpenSourceChessServer(String param1, String param2) {
    return '$param1 is een gratis ($param2), vrije, advertentie-loze open source schaakserver.';
  }

  @override
  String get really => 'echt waar';

  @override
  String get contribute => 'Draag bij';

  @override
  String get termsOfService => 'Algemene voorwaarden';

  @override
  String get sourceCode => 'Broncode';

  @override
  String get simultaneousExhibitions => 'Simultaans';

  @override
  String get host => 'Simultaangever';

  @override
  String hostColorX(String param) {
    return 'Kleur simultaangever: $param';
  }

  @override
  String get yourPendingSimuls => 'Jouw wachtende simultaans';

  @override
  String get createdSimuls => 'Nieuwe simultaans';

  @override
  String get hostANewSimul => 'Geef een nieuwe simultaan';

  @override
  String get signUpToHostOrJoinASimul => 'Meld je aan om een simul te geven of eraan deel te nemen';

  @override
  String get noSimulFound => 'Simultaan niet gevonden';

  @override
  String get noSimulExplanation => 'Deze simultaan bestaat niet.';

  @override
  String get returnToSimulHomepage => 'Ga terug naar de Simultaan hoofdpagina';

  @override
  String get aboutSimul => 'Bij simultanen speelt één speler tegen meerdere spelers tegelijk.';

  @override
  String get aboutSimulImage => 'Van de 50 tegenstanders won Fischer 47 partijen, speelde hij 2 keer remise en verloor hij 1 keer.';

  @override
  String get aboutSimulRealLife => 'Dit concept bestaat ook als evenement in de echte wereld. Dan beweegt de simultaangever van tafel naar tafel om steeds één zet te spelen.';

  @override
  String get aboutSimulRules => 'Wanneer de simultaan begint, begint iedere partij met de simultaangever. De simultaangever speelt iedere partij met wit en de simultaan eindigt wanneer alle partijen afgerond zijn.';

  @override
  String get aboutSimulSettings => 'Simultanen zijn altijd zonder rating. Extra partijen, extra tijd en terugzetten is niet mogelijk.';

  @override
  String get create => 'Creëer';

  @override
  String get whenCreateSimul => 'Wanneer je een simultaan creëert, kun je tegen meerdere spelers tegelijk spelen.';

  @override
  String get simulVariantsHint => 'Als je meerdere varianten selecteert, kan iedere speler kiezen welke variant hij wil spelen.';

  @override
  String get simulClockHint => 'Fischer-speeltempo. Hoe meer tegenstanders er zijn, hoe meer tijd je nodig hebt.';

  @override
  String get simulAddExtraTime => 'Je mag extra tijd aan je eigen klok toevoegen om beter met de simultaan om te kunnen gaan.';

  @override
  String get simulHostExtraTime => 'Extra tijd voor de simultaangever';

  @override
  String get simulAddExtraTimePerPlayer => 'Voeg extra tijd toe aan de klok voor elke speler die meedoet aan de simultaan.';

  @override
  String get simulHostExtraTimePerPlayer => 'Extra tijd voor de simultaangever per deelnemer';

  @override
  String get lichessTournaments => 'Lichess toernooien';

  @override
  String get tournamentFAQ => 'Veelgestelde vragen over Arena toernooien';

  @override
  String get timeBeforeTournamentStarts => 'Tijd voordat het toernooi start';

  @override
  String get averageCentipawnLoss => 'Gemiddeld centipionverlies';

  @override
  String get accuracy => 'Nauwkeurigheid';

  @override
  String get keyboardShortcuts => 'Toetsenbordsnelkoppelingen';

  @override
  String get keyMoveBackwardOrForward => 'zet achteruit/vooruit';

  @override
  String get keyGoToStartOrEnd => 'ga naar het begin/eind';

  @override
  String get keyCycleSelectedVariation => 'Bekijk geselecteerde variant';

  @override
  String get keyShowOrHideComments => 'toon/verberg opmerkingen';

  @override
  String get keyEnterOrExitVariation => 'vermeld/stop variant';

  @override
  String get keyRequestComputerAnalysis => 'Verzoek om computeranalyse, Leer van je fouten';

  @override
  String get keyNextLearnFromYourMistakes => 'Volgende (leer van je fouten)';

  @override
  String get keyNextBlunder => 'Volgende blunder';

  @override
  String get keyNextMistake => 'Volgende fout';

  @override
  String get keyNextInaccuracy => 'Volgende onnauwkeurigheid';

  @override
  String get keyPreviousBranch => 'Vorige vertakking';

  @override
  String get keyNextBranch => 'Volgende vertakking';

  @override
  String get toggleVariationArrows => 'Schakel variatiepijlen in/uit';

  @override
  String get cyclePreviousOrNextVariation => 'Bekijk vorige/volgende variant';

  @override
  String get toggleGlyphAnnotations => 'Zet glyph-aantekeningen aan of uit';

  @override
  String get togglePositionAnnotations => 'Zet stellingsaantekeningen aan of uit';

  @override
  String get variationArrowsInfo => 'Met de variantpijlen kunt u navigeren zonder de zettenlijst te gebruiken.';

  @override
  String get playSelectedMove => 'speel geselecteerde zet';

  @override
  String get newTournament => 'Nieuw toernooi';

  @override
  String get tournamentHomeTitle => 'Schaaktoernooi met verschillende speelduur en varianten';

  @override
  String get tournamentHomeDescription => 'Speel snelle schaaktoernooien! Neem deel aan een officieel gepland toernooi, of maak er zelf een. Bullet, Blitz, Classical, Chess960, King of the Hill, Threecheck, en meer opties verkrijgbaar voor eindeloos schaakplezier.';

  @override
  String get tournamentNotFound => 'Toernooi niet gevonden';

  @override
  String get tournamentDoesNotExist => 'Dit toernooi bestaat niet.';

  @override
  String get tournamentMayHaveBeenCanceled => 'Het is mogelijk afgelast, indien alle spelers zijn weggegaan voordat het toernooi gestart was.';

  @override
  String get returnToTournamentsHomepage => 'Ga terug naar de startpagina van de toernooien';

  @override
  String weeklyPerfTypeRatingDistribution(String param) {
    return 'Maandelijkse $param rating distributie';
  }

  @override
  String yourPerfTypeRatingIsRating(String param1, String param2) {
    return 'Je ${param1}rating is $param2.';
  }

  @override
  String youAreBetterThanPercentOfPerfTypePlayers(String param1, String param2) {
    return 'Je bent beter dan $param1 van de $param2 spelers.';
  }

  @override
  String userIsBetterThanPercentOfPerfTypePlayers(String param1, String param2, String param3) {
    return '$param1 is beter dan $param2 van alle $param3 spelers.';
  }

  @override
  String betterThanPercentPlayers(String param1, String param2) {
    return 'Beter dan $param1 van de ${param2}spelers';
  }

  @override
  String youDoNotHaveAnEstablishedPerfTypeRating(String param) {
    return 'Je hebt geen vastgestelde ${param}rating.';
  }

  @override
  String get yourRating => 'Jouw rating';

  @override
  String get cumulative => 'Cumulatief';

  @override
  String get glicko2Rating => 'Glicko-2 rating';

  @override
  String get checkYourEmail => 'Controleer je email';

  @override
  String get weHaveSentYouAnEmailClickTheLink => 'We hebben je een email gestuurd. Klik op de link in de email om je account te activeren.';

  @override
  String get ifYouDoNotSeeTheEmailCheckOtherPlaces => 'Als je de email niet ziet, kijk dan op andere plaatsen, zoals je spam of andere mappen.';

  @override
  String weHaveSentYouAnEmailTo(String param) {
    return 'We hebben een email verstuurd naar $param. Klik op de link in de email om je wachtwoord te resetten.';
  }

  @override
  String byRegisteringYouAgreeToBeBoundByOur(String param) {
    return 'Door je registratie ben je gebonden aan onze $param.';
  }

  @override
  String readAboutOur(String param) {
    return 'Lees meer over ons $param.';
  }

  @override
  String get networkLagBetweenYouAndLichess => 'Netwerkvertraging tussen u en Lichess';

  @override
  String get timeToProcessAMoveOnLichessServer => 'Tijd om een zet te verwerken op de lichess server';

  @override
  String get downloadAnnotated => 'Download de geannoteerde partij';

  @override
  String get downloadRaw => 'Download PGN';

  @override
  String get downloadImported => 'Download de geïmporteerde partij';

  @override
  String get crosstable => 'Onderlinge partijen';

  @override
  String get youCanAlsoScrollOverTheBoardToMoveInTheGame => 'Je kunt ook over het bord scrollen om je zetten uit te voeren.';

  @override
  String get scrollOverComputerVariationsToPreviewThem => 'Beweeg de muis over computervarianten om ze te bekijken.';

  @override
  String get analysisShapesHowTo => 'Druk op shift+linkermuisknop of rechtermuisknop om cirkels en pijlen op het bord te tekenen.';

  @override
  String get letOtherPlayersMessageYou => 'Andere spelers mogen je berichten zenden';

  @override
  String get receiveForumNotifications => 'Ontvang meldingen wanneer je genoemd wordt op het forum';

  @override
  String get shareYourInsightsData => 'Deel de data van je partijen';

  @override
  String get withNobody => 'Met niemand';

  @override
  String get withFriends => 'Met vrienden';

  @override
  String get withEverybody => 'Met iedereen';

  @override
  String get kidMode => 'Kindvriendelijke modus';

  @override
  String get kidModeIsEnabled => 'Kindvriendelijke modus is ingeschakeld.';

  @override
  String get kidModeExplanation => 'Dit gaat over veiligheid. In kindvriendelijke modus, worden alle communicatiemogelijkheden op de website uitgeschakeld. Activeer dit voor kinderen en scholieren, om hen te beschermen tegen andere internetgebruikers.';

  @override
  String inKidModeTheLichessLogoGetsIconX(String param) {
    return 'In kindvriendelijke modus, krijgt het Lichess-logo een $param-icoontje, zodat je weet dat je kinderen veilig zijn.';
  }

  @override
  String get askYourChessTeacherAboutLiftingKidMode => 'Je account wordt beheerd. Vraag je schaakdocent om de kindermodus uit te zetten.';

  @override
  String get enableKidMode => 'Activeer Kindermodus';

  @override
  String get disableKidMode => 'Deactiveer Kindermodus';

  @override
  String get security => 'Beveiliging';

  @override
  String get sessions => 'Sessies';

  @override
  String get revokeAllSessions => 'alle sessies intrekken';

  @override
  String get playChessEverywhere => 'Schaak overal';

  @override
  String get asFreeAsLichess => 'Zo gratis als lichess';

  @override
  String get builtForTheLoveOfChessNotMoney => 'Gemaakt met liefde voor het schaken, niet voor geld';

  @override
  String get everybodyGetsAllFeaturesForFree => 'Iedereen krijgt gratis alle mogelijkheden';

  @override
  String get zeroAdvertisement => 'Geen advertenties';

  @override
  String get fullFeatured => 'Volledig geïntegreerd';

  @override
  String get phoneAndTablet => 'Telefoon en tablet';

  @override
  String get bulletBlitzClassical => 'Bullet, blitz, klassiek';

  @override
  String get correspondenceChess => 'Correspondentiepartijen';

  @override
  String get onlineAndOfflinePlay => 'Online en offline spelen';

  @override
  String get viewTheSolution => 'Bekijk de oplossing';

  @override
  String get followAndChallengeFriends => 'Volg vrienden en daag ze uit';

  @override
  String get gameAnalysis => 'Partijanalyse';

  @override
  String xHostsY(String param1, String param2) {
    return '$param1 organiseert $param2';
  }

  @override
  String xJoinsY(String param1, String param2) {
    return '$param1 neemt deel aan $param2';
  }

  @override
  String xLikesY(String param1, String param2) {
    return '$param1 vindt $param2 leuk';
  }

  @override
  String get quickPairing => 'Snel koppelen';

  @override
  String get lobby => 'Lobby';

  @override
  String get anonymous => 'Anoniem';

  @override
  String yourScore(String param) {
    return 'Uw score: $param';
  }

  @override
  String get language => 'Taal';

  @override
  String get background => 'Achtergrond';

  @override
  String get light => 'Licht';

  @override
  String get dark => 'Donker';

  @override
  String get transparent => 'Transparant';

  @override
  String get deviceTheme => 'Apparaatthema';

  @override
  String get backgroundImageUrl => 'Achtergrondafbeelding URL:';

  @override
  String get board => 'Bord';

  @override
  String get size => 'Grootte';

  @override
  String get opacity => 'Transparantie';

  @override
  String get brightness => 'Helderheid';

  @override
  String get hue => 'Kleurschakering';

  @override
  String get boardReset => 'Kleuren terugzetten naar standaard';

  @override
  String get pieceSet => 'Schaakstukken';

  @override
  String get embedInYourWebsite => 'Insluiten in uw website';

  @override
  String get usernameAlreadyUsed => 'Deze naam is al in gebruik, probeer a.u.b. een andere naam.';

  @override
  String get usernamePrefixInvalid => 'De gebruikersnaam moet met een letter beginnen.';

  @override
  String get usernameSuffixInvalid => 'De gebruikersnaam moet eindigen met een letter of een cijfer.';

  @override
  String get usernameCharsInvalid => 'De gebruikersnaam mag alleen letters, cijfers, underscores, en koppeltekens bevatten.';

  @override
  String get usernameUnacceptable => 'Deze gebruikersnaam is niet acceptabel.';

  @override
  String get playChessInStyle => 'Speel schaken in stijl';

  @override
  String get chessBasics => 'Basis schaken';

  @override
  String get coaches => 'Coaches';

  @override
  String get invalidPgn => 'Ongeldige PGN';

  @override
  String get invalidFen => 'Ongeldige FEN';

  @override
  String get custom => 'Aangepast';

  @override
  String get notifications => 'Meldingen';

  @override
  String notificationsX(String param1) {
    return 'Meldingen: $param1';
  }

  @override
  String perfRatingX(String param) {
    return 'Rating: $param';
  }

  @override
  String get practiceWithComputer => 'Oefen met de computer';

  @override
  String anotherWasX(String param) {
    return 'Ook mogelijk was $param';
  }

  @override
  String bestWasX(String param) {
    return 'De beste zet was $param';
  }

  @override
  String get youBrowsedAway => 'U was op een ander tabblad bezig';

  @override
  String get resumePractice => 'Hervat oefenen';

  @override
  String get drawByFiftyMoves => 'De partij is in remise geëindigd vanwege de 50-zettenregel.';

  @override
  String get theGameIsADraw => 'De partij eindigt in remise.';

  @override
  String get computerThinking => 'De computer denkt na ...';

  @override
  String get seeBestMove => 'Toon de beste zet';

  @override
  String get hideBestMove => 'Verberg de beste zet';

  @override
  String get getAHint => 'Een hint vragen';

  @override
  String get evaluatingYourMove => 'De evaluatie van je zet...';

  @override
  String get whiteWinsGame => 'Wit wint';

  @override
  String get blackWinsGame => 'Zwart wint';

  @override
  String get learnFromYourMistakes => 'Leren van je fouten';

  @override
  String get learnFromThisMistake => 'Leer van deze fout';

  @override
  String get skipThisMove => 'Deze zet overslaan';

  @override
  String get next => 'Volgende';

  @override
  String xWasPlayed(String param) {
    return '$param werd gespeeld';
  }

  @override
  String get findBetterMoveForWhite => 'Vind een betere zet voor wit';

  @override
  String get findBetterMoveForBlack => 'Vind een betere zet voor zwart';

  @override
  String get resumeLearning => 'Ga door met leren';

  @override
  String get youCanDoBetter => 'Je kunt het beter doen';

  @override
  String get tryAnotherMoveForWhite => 'Probeer een andere zet voor wit';

  @override
  String get tryAnotherMoveForBlack => 'Probeer een andere zet voor zwart';

  @override
  String get solution => 'Oplossing';

  @override
  String get waitingForAnalysis => 'Wachten op analyse';

  @override
  String get noMistakesFoundForWhite => 'Geen fouten gevonden voor wit';

  @override
  String get noMistakesFoundForBlack => 'Geen fouten gevonden voor zwart';

  @override
  String get doneReviewingWhiteMistakes => 'Klaar met analyseren van fouten van wit';

  @override
  String get doneReviewingBlackMistakes => 'Klaar met analyseren van fouten van zwart';

  @override
  String get doItAgain => 'Probeer het opnieuw';

  @override
  String get reviewWhiteMistakes => 'Bekijk fouten van wit';

  @override
  String get reviewBlackMistakes => 'Bekijk fouten van zwart';

  @override
  String get advantage => 'Voordeel';

  @override
  String get opening => 'Opening';

  @override
  String get middlegame => 'Middenspel';

  @override
  String get endgame => 'Eindspel';

  @override
  String get conditionalPremoves => 'Voorwaardelijke zetten vooruit';

  @override
  String get addCurrentVariation => 'Voeg huidige variant toe';

  @override
  String get playVariationToCreateConditionalPremoves => 'Speel een variant om voorwaardelijke zetten vooruit te maken';

  @override
  String get noConditionalPremoves => 'Geen voorwaardelijke zetten vooruit';

  @override
  String playX(String param) {
    return 'Speel $param';
  }

  @override
  String get showUnreadLichessMessage => 'Je hebt een privébericht van Lichess ontvangen.';

  @override
  String get clickHereToReadIt => 'Klik hier om het te bekijken';

  @override
  String get sorry => 'Sorry :(';

  @override
  String get weHadToTimeYouOutForAWhile => 'We moesten je voor een korte tijd een time-out geven.';

  @override
  String get why => 'Waarom?';

  @override
  String get pleasantChessExperience => 'Wij streven ernaar om iedereen een prettige schaakervaring te bieden.';

  @override
  String get goodPractice => 'Daarom moeten we ervoor zorgen dat alle spelers goede praktijken volgen.';

  @override
  String get potentialProblem => 'Wanneer een mogelijk probleem is gedetecteerd, tonen we dit bericht.';

  @override
  String get howToAvoidThis => 'Hoe kunnen we dit voorkomen?';

  @override
  String get playEveryGame => 'Speel elk partij die je start.';

  @override
  String get tryToWin => 'Probeer elke partij die je speelt te winnen (of tenminste gelijk te spelen).';

  @override
  String get resignLostGames => 'Geef verloren partijen op (laat de klok niet tot 0 lopen).';

  @override
  String get temporaryInconvenience => 'Onze excuses voor het tijdelijke ongemak,';

  @override
  String get wishYouGreatGames => 'en wij wensen u veel goede partijen op lichess.org.';

  @override
  String get thankYouForReading => 'Bedankt voor het lezen!';

  @override
  String get lifetimeScore => 'Levenslange score';

  @override
  String get currentMatchScore => 'Huidige wedstrijd score';

  @override
  String get agreementAssistance => 'Ik ga ermee akkoord dat ik tijdens mijn partijen geen hulp krijg (van een schaakcomputer, -boek, -database of ander persoon).';

  @override
  String get agreementNice => 'Ik ga ermee akkoord dat ik altijd respectvol tegenover andere spelers zal zijn.';

  @override
  String agreementMultipleAccounts(String param) {
    return 'Ik ga ermee akkoord dat ik niet meerdere accounts zal aanmaken (behalve om de redenen die in de $param zijn vermeld).';
  }

  @override
  String get agreementPolicy => 'Ik ga ermee akkoord dat ik de Lichess-regels zal volgen.';

  @override
  String get searchOrStartNewDiscussion => 'Zoek of start een nieuwe discussie';

  @override
  String get edit => 'Wijzigen';

  @override
  String get bullet => 'Bullet';

  @override
  String get blitz => 'Blitz';

  @override
  String get rapid => 'Rapid';

  @override
  String get classical => 'Klassiek';

  @override
  String get ultraBulletDesc => 'Extreem snelle partijen: minder dan 30 seconden';

  @override
  String get bulletDesc => 'Zeer snelle partijen: minder dan 3 minuten';

  @override
  String get blitzDesc => 'Snelle partijen: 3 tot 8 minuten';

  @override
  String get rapidDesc => 'Korte partijen: 8 tot 25 minuten';

  @override
  String get classicalDesc => 'Klassieke partijen: 25 minuten en meer';

  @override
  String get correspondenceDesc => 'Correspondentiepartijen: een of meer dagen per zet';

  @override
  String get puzzleDesc => 'Schaaktactieken trainer';

  @override
  String get important => 'Belangrijk';

  @override
  String yourQuestionMayHaveBeenAnswered(String param1) {
    return 'Je vraag heeft mogelijk al een antwoord $param1';
  }

  @override
  String get inTheFAQ => 'in de veelgestelde vragen';

  @override
  String toReportSomeoneForCheatingOrBadBehavior(String param1) {
    return 'Om een gebruiker te rapporteren voor vals spelen of slecht gedrag, $param1';
  }

  @override
  String get useTheReportForm => 'gebruik het meldingsformulier';

  @override
  String toRequestSupport(String param1) {
    return 'Om ondersteuning aan te vragen, $param1';
  }

  @override
  String get tryTheContactPage => 'probeer de contactpagina';

  @override
  String makeSureToRead(String param1) {
    return 'Lees zeker $param1';
  }

  @override
  String get theForumEtiquette => 'de regels van het forum';

  @override
  String get thisTopicIsArchived => 'Dit onderwerp is gearchiveerd; er kan niet meer op worden gereageerd.';

  @override
  String joinTheTeamXToPost(String param1) {
    return 'Neem deel aan $param1, om in dit forum te posten';
  }

  @override
  String teamNamedX(String param1) {
    return 'team $param1';
  }

  @override
  String get youCannotPostYetPlaySomeGames => 'Je kunt nog geen post in de forums plaatsen. Speel eerst een paar partijen!';

  @override
  String get subscribe => 'Abonneren';

  @override
  String get unsubscribe => 'Abonnement opzeggen';

  @override
  String mentionedYouInX(String param1) {
    return 'heeft je genoemd in \"$param1\".';
  }

  @override
  String xMentionedYouInY(String param1, String param2) {
    return '$param1 heeft je genoemd in \"$param2\".';
  }

  @override
  String invitedYouToX(String param1) {
    return 'heeft je uitgenodigd voor \"$param1\".';
  }

  @override
  String xInvitedYouToY(String param1, String param2) {
    return '$param1 heeft je uitgenodigd voor \"$param2\".';
  }

  @override
  String get youAreNowPartOfTeam => 'Je maakt nu deel uit van het team.';

  @override
  String youHaveJoinedTeamX(String param1) {
    return 'Je bent nu lid van \"$param1\".';
  }

  @override
  String get someoneYouReportedWasBanned => 'Iemand die je hebt gerapporteerd is geband';

  @override
  String get congratsYouWon => 'Gefeliciteerd, je hebt gewonnen!';

  @override
  String gameVsX(String param1) {
    return 'Partij tegen $param1';
  }

  @override
  String resVsX(String param1, String param2) {
    return '$param1 tegen $param2';
  }

  @override
  String get lostAgainstTOSViolator => 'Je hebt verloren van iemand die de Lichess voorwaarden heeft geschonden';

  @override
  String refundXpointsTimeControlY(String param1, String param2) {
    return 'Teruggekregen: $param1 $param2 ratingpunten.';
  }

  @override
  String get timeAlmostUp => 'De tijd is bijna om!';

  @override
  String get clickToRevealEmailAddress => '[Klik om het e-mailadres te tonen]';

  @override
  String get download => 'Downloaden';

  @override
  String get coachManager => 'Coach manager';

  @override
  String get streamerManager => 'Streamer manager';

  @override
  String get cancelTournament => 'Toernooi annuleren';

  @override
  String get tournDescription => 'Toernooibeschrijving';

  @override
  String get tournDescriptionHelp => 'Iets bijzonders dat je de deelnemers wilt vertellen? Probeer het kort te houden. Markdown-links zijn beschikbaar: [name](https://url)';

  @override
  String get ratedFormHelp => 'Partijen worden met rating gespeeld \nen hebben effect op de rating van de spelers';

  @override
  String get onlyMembersOfTeam => 'Alleen leden van het team';

  @override
  String get noRestriction => 'Geen restrictie';

  @override
  String get minimumRatedGames => 'Minimumaantal partijen met rating';

  @override
  String get minimumRating => 'Minimumrating';

  @override
  String get maximumWeeklyRating => 'Maximale wekelijkse rating';

  @override
  String positionInputHelp(String param) {
    return 'Plak een geldige FEN-code om een partij te beginnen vanaf een bepaalde stelling.\nHet werkt alleen voor standaardpartijen, niet met varianten.\nU kunt de $param gebruiken om een FEN-code te genereren en deze hier plakken.\nLaat leeg om partijen te starten vanaf de normale beginstelling.';
  }

  @override
  String get cancelSimul => 'Simultaan annuleren';

  @override
  String get simulHostcolor => 'Kleur van de simultaangever voor elk spel';

  @override
  String get estimatedStart => 'Geschatte starttijd';

  @override
  String simulFeatured(String param) {
    return 'Simultaan tonen op $param';
  }

  @override
  String simulFeaturedHelp(String param) {
    return 'De simultaan voor iedereen weergeven op $param. Schakel dit uit voor privésimultaans.';
  }

  @override
  String get simulDescription => 'Omschrijving van de simultaan';

  @override
  String get simulDescriptionHelp => 'Is er nog iets wat de deelnemers moeten weten?';

  @override
  String markdownAvailable(String param) {
    return '$param is beschikbaar voor meer geavanceerde opmaak.';
  }

  @override
  String get embedsAvailable => 'Plak de URL van een partij of een studie om deze in te voegen.';

  @override
  String get inYourLocalTimezone => 'In je eigen lokale tijdzone';

  @override
  String get tournChat => 'Toernooichat';

  @override
  String get noChat => 'Geen chat';

  @override
  String get onlyTeamLeaders => 'Alleen teamleiders';

  @override
  String get onlyTeamMembers => 'Alleen teamleden';

  @override
  String get navigateMoveTree => 'Navigeer door de zettenlijst';

  @override
  String get mouseTricks => 'Muistrucs';

  @override
  String get toggleLocalAnalysis => 'Lokale computeranalyse in-/uitschakelen';

  @override
  String get toggleAllAnalysis => 'Alle computeranalyses in-/uitschakelen';

  @override
  String get playComputerMove => 'Doe de beste computerzet';

  @override
  String get analysisOptions => 'Analyse opties';

  @override
  String get focusChat => 'Selecteer chat';

  @override
  String get showHelpDialog => 'Help-dialoogvenster weergeven';

  @override
  String get reopenYourAccount => 'Account heropenen';

  @override
  String get closedAccountChangedMind => 'Als je je account had gesloten, maar sindsdien van gedachten veranderd bent, krijg je één kans om je account te herstellen.';

  @override
  String get onlyWorksOnce => 'Dit werkt maar eenmaal.';

  @override
  String get cantDoThisTwice => 'Als je je account voor de tweede keer sluit, is er geen manier om deze te herstellen.';

  @override
  String get emailAssociatedToaccount => 'E-mailadres gekoppeld aan het account';

  @override
  String get sentEmailWithLink => 'We hebben je een e-mail gestuurd met een link.';

  @override
  String get tournamentEntryCode => 'Toernooi toegangscode';

  @override
  String get hangOn => 'Wacht even!';

  @override
  String gameInProgress(String param) {
    return 'Je speelt nog een partij tegen $param.';
  }

  @override
  String get abortTheGame => 'Partij afbreken';

  @override
  String get resignTheGame => 'Partij opgeven';

  @override
  String get youCantStartNewGame => 'Je kunt geen nieuwe partij beginnen voordat deze is afgelopen.';

  @override
  String get since => 'Vanaf';

  @override
  String get until => 'Tot';

  @override
  String get lichessDbExplanation => 'Partijen met rating gespeeld op Lichess';

  @override
  String get switchSides => 'Van kleur wisselen';

  @override
  String get closingAccountWithdrawAppeal => 'Met het sluiten van je account wordt je beroep ingetrokken';

  @override
  String get ourEventTips => 'Onze tips voor het organiseren van evenementen';

  @override
  String get instructions => 'Instructies';

  @override
  String get showMeEverything => 'Alles tonen';

  @override
  String get lichessPatronInfo => 'Lichess is een organisatie zonder winstoogmerk en is volledig open en gratis (libre).\nAlle exploitatiekosten, ontwikkeling en inhoud worden enkel gefinancierd door donaties van gebruikers.';

  @override
  String get nothingToSeeHere => 'Hier is momenteel niets te zien.';

  @override
  String opponentLeftCounter(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Je tegenstander speelt niet verder. Je kunt de overwinning opeisen over $count seconden.',
      one: 'Je tegenstander heeft het spel verlaten. Je kan de overwinning opeisen over $count seconde.',
    );
    return '$_temp0';
  }

  @override
  String mateInXHalfMoves(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Schaakmat in $count halfzetten',
      one: 'Schaakmat in $count halfzet',
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
  String nbMistakes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count fouten',
      one: '$count fout',
    );
    return '$_temp0';
  }

  @override
  String nbInaccuracies(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count imperfecties',
      one: '$count imperfectie',
    );
    return '$_temp0';
  }

  @override
  String nbPlayers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count spelers',
      one: '$count speler',
    );
    return '$_temp0';
  }

  @override
  String nbGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count partijen',
      one: '$count partij',
    );
    return '$_temp0';
  }

  @override
  String ratingXOverYGames(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count rating na $param2 partijen',
      one: '$count rating na $param2 partij',
    );
    return '$_temp0';
  }

  @override
  String nbBookmarks(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count favorieten',
      one: '$count favoriet',
    );
    return '$_temp0';
  }

  @override
  String nbDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count dagen',
      one: '$count dag',
    );
    return '$_temp0';
  }

  @override
  String nbHours(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count uren',
      one: '$count uur',
    );
    return '$_temp0';
  }

  @override
  String nbMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count minuten',
      one: '$count minuut',
    );
    return '$_temp0';
  }

  @override
  String rankIsUpdatedEveryNbMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Positie wordt elke $count minuten bijgewerkt',
      one: 'Positie wordt elke minuut bijgewerkt',
    );
    return '$_temp0';
  }

  @override
  String nbPuzzles(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count puzzels',
      one: '$count puzzel',
    );
    return '$_temp0';
  }

  @override
  String nbGamesWithYou(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count partijen met u',
      one: '$count partij met u',
    );
    return '$_temp0';
  }

  @override
  String nbRated(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count met rating',
      one: '$count met rating',
    );
    return '$_temp0';
  }

  @override
  String nbWins(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count gewonnen',
      one: '$count gewonnen',
    );
    return '$_temp0';
  }

  @override
  String nbLosses(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count verloren',
      one: '$count verloren',
    );
    return '$_temp0';
  }

  @override
  String nbDraws(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count remise',
      one: '$count remise',
    );
    return '$_temp0';
  }

  @override
  String nbPlaying(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count bezig',
      one: '$count bezig',
    );
    return '$_temp0';
  }

  @override
  String giveNbSeconds(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Geef $count seconden',
      one: 'Geef $count seconde',
    );
    return '$_temp0';
  }

  @override
  String nbTournamentPoints(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count toernooipunten',
      one: '$count toernooipunt',
    );
    return '$_temp0';
  }

  @override
  String nbStudies(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count studies',
      one: '$count studie',
    );
    return '$_temp0';
  }

  @override
  String nbSimuls(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count simultaans',
      one: '$count simultaan',
    );
    return '$_temp0';
  }

  @override
  String moreThanNbRatedGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '≥ $count partijen met rating',
      one: '≥ $count partij met rating',
    );
    return '$_temp0';
  }

  @override
  String moreThanNbPerfRatedGames(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '≥ $count $param2 partijen met rating',
      one: '≥ $count $param2 partij met rating',
    );
    return '$_temp0';
  }

  @override
  String needNbMorePerfGames(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Je moet $count $param2 partijen meer met rating spelen',
      one: 'Je moet $count extra $param2 partij met rating spelen',
    );
    return '$_temp0';
  }

  @override
  String needNbMoreGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Je moet $count partijen meer met rating spelen',
      one: 'Je moet $count partij meer met rating spelen',
    );
    return '$_temp0';
  }

  @override
  String nbImportedGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Geïmporteerde partijen',
      one: '$count Geïmporteerde partij',
    );
    return '$_temp0';
  }

  @override
  String nbFriendsOnline(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count vrienden online',
      one: '$count vriend online',
    );
    return '$_temp0';
  }

  @override
  String nbFollowers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count volgers',
      one: '$count volger',
    );
    return '$_temp0';
  }

  @override
  String nbFollowing(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count volgend',
      one: '$count volgend',
    );
    return '$_temp0';
  }

  @override
  String lessThanNbMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Minder dan $count minuten',
      one: 'Minder dan $count minuut',
    );
    return '$_temp0';
  }

  @override
  String nbGamesInPlay(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count partijen bezig',
      one: '$count partij bezig',
    );
    return '$_temp0';
  }

  @override
  String maximumNbCharacters(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Maximaal: $count tekens.',
      one: 'Maximaal: $count teken.',
    );
    return '$_temp0';
  }

  @override
  String blocks(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count blokkades',
      one: '$count blokkade',
    );
    return '$_temp0';
  }

  @override
  String nbForumPosts(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Forumberichten',
      one: '$count Forumbericht',
    );
    return '$_temp0';
  }

  @override
  String nbPerfTypePlayersThisWeek(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count $param2 spelers deze week.',
      one: 'Eén $param2 speler deze week.',
    );
    return '$_temp0';
  }

  @override
  String availableInNbLanguages(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Beschikbaar in $count talen!',
      one: 'Beschikbaar in $count taal!',
    );
    return '$_temp0';
  }

  @override
  String nbSecondsToPlayTheFirstMove(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count seconden om de eerste zet te spelen',
      one: '$count seconde om de eerste zet te spelen',
    );
    return '$_temp0';
  }

  @override
  String nbSeconds(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count seconden',
      one: '$count seconde',
    );
    return '$_temp0';
  }

  @override
  String andSaveNbPremoveLines(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'en bewaar $count premove-varianten',
      one: 'en bewaar $count premove-variant',
    );
    return '$_temp0';
  }

  @override
  String get stormMoveToStart => 'Doe een zet om te beginnen';

  @override
  String get stormYouPlayTheWhitePiecesInAllPuzzles => 'In alle puzzels speel je met de witte stukken';

  @override
  String get stormYouPlayTheBlackPiecesInAllPuzzles => 'In alle puzzels speel je met de zwarte stukken';

  @override
  String get stormPuzzlesSolved => 'puzzels opgelost';

  @override
  String get stormNewDailyHighscore => 'Nieuwe dagelijkse topscore!';

  @override
  String get stormNewWeeklyHighscore => 'Nieuwe wekelijkse topscore!';

  @override
  String get stormNewMonthlyHighscore => 'Nieuwe maandelijkse topscore!';

  @override
  String get stormNewAllTimeHighscore => 'Nieuwe topscore aller tijden!';

  @override
  String stormPreviousHighscoreWasX(String param) {
    return 'Vorige topscore was $param';
  }

  @override
  String get stormPlayAgain => 'Speel opnieuw';

  @override
  String stormHighscoreX(String param) {
    return 'Topscore: $param';
  }

  @override
  String get stormScore => 'Score';

  @override
  String get stormMoves => 'Zetten';

  @override
  String get stormAccuracy => 'Nauwkeurigheid';

  @override
  String get stormCombo => 'Combo';

  @override
  String get stormTime => 'Tijd';

  @override
  String get stormTimePerMove => 'Tijd per zet';

  @override
  String get stormHighestSolved => 'Hoogste rating';

  @override
  String get stormPuzzlesPlayed => 'Gespeelde puzzels';

  @override
  String get stormNewRun => 'Nieuwe sessie (sneltoets: Spatiebalk)';

  @override
  String get stormEndRun => 'Sessie stoppen (sneltoets: Enter)';

  @override
  String get stormHighscores => 'Topscores';

  @override
  String get stormViewBestRuns => 'Bekijk beste sessies';

  @override
  String get stormBestRunOfDay => 'Beste sessie van de dag';

  @override
  String get stormRuns => 'Sessies';

  @override
  String get stormGetReady => 'Houd je gereed!';

  @override
  String get stormWaitingForMorePlayers => 'Wachten op meer deelnemers...';

  @override
  String get stormRaceComplete => 'Wedstrijd afgelopen!';

  @override
  String get stormSpectating => 'Toeschouwer';

  @override
  String get stormJoinTheRace => 'Doe mee aan de wedstrijd!';

  @override
  String get stormStartTheRace => 'Start de race';

  @override
  String stormYourRankX(String param) {
    return 'Jouw plaats: $param';
  }

  @override
  String get stormWaitForRematch => 'Wacht op nieuwe wedstrijd';

  @override
  String get stormNextRace => 'Volgende wedstrijd';

  @override
  String get stormJoinRematch => 'Neem deel aan rematch';

  @override
  String get stormWaitingToStart => 'Wachten op de start';

  @override
  String get stormCreateNewGame => 'Maak een nieuwe wedstrijd';

  @override
  String get stormJoinPublicRace => 'Meedoen aan een openbare race';

  @override
  String get stormRaceYourFriends => 'Racen tegen vrienden';

  @override
  String get stormSkip => 'sla over';

  @override
  String get stormSkipHelp => 'Je kunt één zet per race overslaan:';

  @override
  String get stormSkipExplanation => 'Sla deze zet over om je combo te behouden! Werkt maar eenmaal per race.';

  @override
  String get stormFailedPuzzles => 'Mislukte puzzels';

  @override
  String get stormSlowPuzzles => 'Trage puzzels';

  @override
  String get stormSkippedPuzzle => 'Overgeslagen puzzel';

  @override
  String get stormThisWeek => 'Deze week';

  @override
  String get stormThisMonth => 'Deze maand';

  @override
  String get stormAllTime => 'Record';

  @override
  String get stormClickToReload => 'Klik om te herladen';

  @override
  String get stormThisRunHasExpired => 'Deze sessie is verlopen!';

  @override
  String get stormThisRunWasOpenedInAnotherTab => 'Deze sessie is geopend in een ander tabblad!';

  @override
  String stormXRuns(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count sessies',
      one: '1 sessie',
    );
    return '$_temp0';
  }

  @override
  String stormPlayedNbRunsOfPuzzleStorm(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count sessies $param2 gespeeld',
      one: 'Eén sessie $param2 gespeeld',
    );
    return '$_temp0';
  }

  @override
  String get streamerLichessStreamers => 'Lichess streamers';

  @override
  String get studyShareAndExport => 'Deel & exporteer';

  @override
  String get studyStart => 'Start';
}
