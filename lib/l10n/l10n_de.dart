import 'package:intl/intl.dart' as intl;

import 'l10n.dart';

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get mobileHomeTab => 'Startseite';

  @override
  String get mobilePuzzlesTab => 'Aufgaben';

  @override
  String get mobileToolsTab => 'Werkzeuge';

  @override
  String get mobileWatchTab => 'Zuschauen';

  @override
  String get mobileSettingsTab => 'Einstellungen';

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
  String get activityActivity => 'Verlauf';

  @override
  String get activityHostedALiveStream => 'Hat live gestreamt';

  @override
  String activityRankedInSwissTournament(String param1, String param2) {
    return 'Hat Platz #$param1 im Turnier $param2 belegt';
  }

  @override
  String get activitySignedUp => 'Hat sich bei Lichess angemeldet';

  @override
  String activitySupportedNbMonths(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Unterstützt lichess.org seit $count Monaten als $param2',
      one: 'Unterstützt lichess.org seit $count Monat als $param2',
    );
    return '$_temp0';
  }

  @override
  String activityPracticedNbPositions(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Hat $count Stellungen bei $param2 geübt',
      one: 'Hat $count Stellung bei $param2 geübt',
    );
    return '$_temp0';
  }

  @override
  String activitySolvedNbPuzzles(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Hat $count Taktikaufgaben gelöst',
      one: 'Hat $count Taktikaufgabe gelöst',
    );
    return '$_temp0';
  }

  @override
  String activityPlayedNbGames(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Hat $count Partien $param2 gespielt',
      one: 'Hat $count Partie $param2 gespielt',
    );
    return '$_temp0';
  }

  @override
  String activityPostedNbMessages(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Hat $count Nachrichten in $param2 geschrieben',
      one: 'Hat $count Nachricht in $param2 geschrieben',
    );
    return '$_temp0';
  }

  @override
  String activityPlayedNbMoves(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Spielte $count Züge',
      one: 'Spielte $count Zug',
    );
    return '$_temp0';
  }

  @override
  String activityInNbCorrespondenceGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'in $count Fernschachpartien',
      one: 'in $count Fernschachpartie',
    );
    return '$_temp0';
  }

  @override
  String activityCompletedNbGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Hat $count Fernschachpartien gespielt',
      one: 'Hat $count Fernschachpartie gespielt',
    );
    return '$_temp0';
  }

  @override
  String activityFollowedNbPlayers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Folgt $count Spielern',
      one: 'Folgt $count Spieler',
    );
    return '$_temp0';
  }

  @override
  String activityGainedNbFollowers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Hat $count neue Follower',
      one: 'Hat $count neuen Follower',
    );
    return '$_temp0';
  }

  @override
  String activityHostedNbSimuls(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Hat $count Simultanvorstellungen gegeben',
      one: 'Hat $count Simultanvorstellung gegeben',
    );
    return '$_temp0';
  }

  @override
  String activityJoinedNbSimuls(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Hat an $count Simultanvorstellungen teilgenommen',
      one: 'Hat an $count Simultanvorstellung teilgenommen',
    );
    return '$_temp0';
  }

  @override
  String activityCreatedNbStudies(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Hat $count neue Studien erstellt',
      one: 'Hat $count neue Studie erstellt',
    );
    return '$_temp0';
  }

  @override
  String activityCompetedInNbTournaments(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Hat an $count Turnieren teilgenommen',
      one: 'Hat an $count Turnier teilgenommen',
    );
    return '$_temp0';
  }

  @override
  String activityRankedInTournament(int count, String param2, String param3, String param4) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Hat Platz #$count (obere $param2%) mit $param3 Spielen in $param4 erreicht',
      one: 'Hat Platz #$count (obere $param2%) mit $param3 Spiel in $param4 erreicht',
    );
    return '$_temp0';
  }

  @override
  String activityCompetedInNbSwissTournaments(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Hat an $count Turnieren nach Schweizer System teilgenommen',
      one: 'Hat an $count Turnier nach Schweizer System teilgenommen',
    );
    return '$_temp0';
  }

  @override
  String activityJoinedNbTeams(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Ist $count Teams beigetreten',
      one: 'Ist $count Team beigetreten',
    );
    return '$_temp0';
  }

  @override
  String get broadcastBroadcasts => 'Übertragungen';

  @override
  String get broadcastStartDate => 'Startdatum in deiner eigenen Zeitzone';

  @override
  String challengeChallengesX(String param1) {
    return 'Herausforderungen: $param1';
  }

  @override
  String get challengeChallengeToPlay => 'Zu einer Partie herausfordern';

  @override
  String get challengeChallengeDeclined => 'Herausforderung abgelehnt';

  @override
  String get challengeChallengeAccepted => 'Herausforderung angenommen!';

  @override
  String get challengeChallengeCanceled => 'Herausforderung abgebrochen.';

  @override
  String get challengeRegisterToSendChallenges => 'Bitte registriere dich, um Herausforderungen an diesen Benutzer zu senden.';

  @override
  String challengeYouCannotChallengeX(String param) {
    return 'Du kannst $param nicht herausfordern.';
  }

  @override
  String challengeXDoesNotAcceptChallenges(String param) {
    return '$param nimmt keine Herausforderungen an.';
  }

  @override
  String challengeYourXRatingIsTooFarFromY(String param1, String param2) {
    return 'Deine $param1 Wertung ist zu weit von $param2 entfernt.';
  }

  @override
  String challengeCannotChallengeDueToProvisionalXRating(String param) {
    return 'Herausforderung wegen provisorischer $param Wertung nicht möglich.';
  }

  @override
  String challengeXOnlyAcceptsChallengesFromFriends(String param) {
    return '$param nimmt Herausforderungen nur von Freunden an.';
  }

  @override
  String get challengeDeclineGeneric => 'Ich nehme derzeit keine Herausforderungen an.';

  @override
  String get challengeDeclineLater => 'Ich nehme momentan keine Herausforderungen an, bitte frage später noch einmal.';

  @override
  String get challengeDeclineTooFast => 'Diese Bedenkzeit ist zu gering für mich, bitte fordere mich erneut mit einer höheren Bedenkzeit heraus.';

  @override
  String get challengeDeclineTooSlow => 'Diese Bedenkzeit ist zu lang für mich, bitte fordere mich mit weniger Bedenkzeit heraus.';

  @override
  String get challengeDeclineTimeControl => 'Ich nehme keine Herausforderungen mit dieser Bedenkzeit an.';

  @override
  String get challengeDeclineRated => 'Bitte fordere mich stattdessen zu einer gewerteten Partie heraus.';

  @override
  String get challengeDeclineCasual => 'Bitte fordere mich stattdessen zu einer ungewerteten Partie heraus.';

  @override
  String get challengeDeclineStandard => 'Ich nehme derzeit keine Herausforderungen für andere Spielvarianten an.';

  @override
  String get challengeDeclineVariant => 'Ich bin derzeit nicht bereit, diese Variante zu spielen.';

  @override
  String get challengeDeclineNoBot => 'Ich nehme keine Herausforderungen von Bots an.';

  @override
  String get challengeDeclineOnlyBot => 'Ich nehme nur Herausforderungen von Bots an.';

  @override
  String get challengeInviteLichessUser => 'Oder lade einen Lichess-Benutzer ein:';

  @override
  String get contactContact => 'Kontakt';

  @override
  String get contactContactLichess => 'Lichess kontaktieren';

  @override
  String get patronDonate => 'Spenden';

  @override
  String get patronLichessPatron => 'Lichess Patron';

  @override
  String perfStatPerfStats(String param) {
    return '$param-Statistiken';
  }

  @override
  String get perfStatViewTheGames => 'Spiele anzeigen';

  @override
  String get perfStatProvisional => 'provisorisch';

  @override
  String get perfStatNotEnoughRatedGames => 'Nicht genügend gewertete Partien gespielt, um eine verlässliche Wertung zu erzielen.';

  @override
  String perfStatProgressOverLastXGames(String param) {
    return 'Fortschritt über die letzten $param Spiele:';
  }

  @override
  String perfStatRatingDeviation(String param) {
    return 'Wertungsabweichung: $param.';
  }

  @override
  String perfStatRatingDeviationTooltip(String param1, String param2, String param3) {
    return 'Ein niedriger Wert bedeutet, dass die Wertungszahl stabiler ist. Über $param1 wird die Wertung als vorläufig betrachtet. Um in die Rangliste aufgenommen zu werden, sollte dieser Wert unter $param2 (Standardschach) oder $param3 (Varianten) liegen.';
  }

  @override
  String get perfStatTotalGames => 'Insgesamte Spiele';

  @override
  String get perfStatRatedGames => 'Gewertete Spiele';

  @override
  String get perfStatTournamentGames => 'Turnierspiele';

  @override
  String get perfStatBerserkedGames => 'Berserker-Partien';

  @override
  String get perfStatTimeSpentPlaying => 'Gesamtspielzeit';

  @override
  String get perfStatAverageOpponent => 'Durchschnittliche Gegnerwertung';

  @override
  String get perfStatVictories => 'Siege';

  @override
  String get perfStatDefeats => 'Niederlagen';

  @override
  String get perfStatDisconnections => 'Verbindungsabbrüche';

  @override
  String get perfStatNotEnoughGames => 'Nicht genügend Spiele gespielt';

  @override
  String perfStatHighestRating(String param) {
    return 'Höchste Wertungszahl: $param';
  }

  @override
  String perfStatLowestRating(String param) {
    return 'Niedrigste Wertungszahl: $param';
  }

  @override
  String perfStatFromXToY(String param1, String param2) {
    return 'von $param1 zu $param2';
  }

  @override
  String get perfStatWinningStreak => 'Siegesserie';

  @override
  String get perfStatLosingStreak => 'Niederlagenserie';

  @override
  String perfStatLongestStreak(String param) {
    return 'Längste Serie: $param';
  }

  @override
  String perfStatCurrentStreak(String param) {
    return 'Aktuelle Serie: $param';
  }

  @override
  String get perfStatBestRated => 'Beste gewertete Siege';

  @override
  String get perfStatGamesInARow => 'In Folge gespielte Spiele';

  @override
  String get perfStatLessThanOneHour => 'Weniger als eine Stunde zwischen den Spielen';

  @override
  String get perfStatMaxTimePlaying => 'Maximale Spielzeit';

  @override
  String get perfStatNow => 'jetzt';

  @override
  String get preferencesPreferences => 'Einstellungen';

  @override
  String get preferencesDisplay => 'Anzeige';

  @override
  String get preferencesPrivacy => 'Privatsphäre';

  @override
  String get preferencesNotifications => 'Benachrichtigungen';

  @override
  String get preferencesPieceAnimation => 'Figurenanimation';

  @override
  String get preferencesMaterialDifference => 'Materialunterschied';

  @override
  String get preferencesBoardHighlights => 'Markierungen auf dem Brett (letzter Zug und Schach)';

  @override
  String get preferencesPieceDestinations => 'Zielfelder markieren (gültige Züge und Vorauszüge)';

  @override
  String get preferencesBoardCoordinates => 'Brettkoordinaten (A-H, 1-8)';

  @override
  String get preferencesMoveListWhilePlaying => 'Notation während des Spiels anzeigen';

  @override
  String get preferencesPgnPieceNotation => 'Zugnotation';

  @override
  String get preferencesChessPieceSymbol => 'Schachfigurensymbol';

  @override
  String get preferencesPgnLetter => 'Buchstaben (K, Q, R, B, N)';

  @override
  String get preferencesZenMode => 'Zen-Modus';

  @override
  String get preferencesShowPlayerRatings => 'Wertungszahl von Spielern anzeigen';

  @override
  String get preferencesShowFlairs => 'Spieler-Flairs anzeigen';

  @override
  String get preferencesExplainShowPlayerRatings => 'Versteckt alle Wertungen auf der Website, damit du dich voll auf das Schach zu konzentrieren kannst. Partien können immer noch gewertet sein, es geht nur darum, was du zu sehen bekommst.';

  @override
  String get preferencesDisplayBoardResizeHandle => 'Regler zum Ändern der Brettgröße anzeigen';

  @override
  String get preferencesOnlyOnInitialPosition => 'Nur in der Anfangsstellung';

  @override
  String get preferencesInGameOnly => 'Nur während einer Partie';

  @override
  String get preferencesChessClock => 'Schachuhr';

  @override
  String get preferencesTenthsOfSeconds => 'Zehntelsekunden';

  @override
  String get preferencesWhenTimeRemainingLessThanTenSeconds => 'Wenn Restzeit < 10 Sekunden';

  @override
  String get preferencesHorizontalGreenProgressBars => 'Horizontale grüne Fortschrittsbalken';

  @override
  String get preferencesSoundWhenTimeGetsCritical => 'Ton, wenn die Zeit knapp wird';

  @override
  String get preferencesGiveMoreTime => 'Mehr Zeit geben';

  @override
  String get preferencesGameBehavior => 'Spielverhalten';

  @override
  String get preferencesHowDoYouMovePieces => 'Wie möchtest du die Figuren bewegen?';

  @override
  String get preferencesClickTwoSquares => 'Zwei Felder anklicken';

  @override
  String get preferencesDragPiece => 'Die Figur ziehen';

  @override
  String get preferencesBothClicksAndDrag => 'Klicken oder ziehen';

  @override
  String get preferencesPremovesPlayingDuringOpponentTurn => 'Vorauszüge (Premoves), während der Gegner am Zug ist';

  @override
  String get preferencesTakebacksWithOpponentApproval => 'Zugrücknahme (mit Erlaubnis des Gegners)';

  @override
  String get preferencesInCasualGamesOnly => 'Nur in ungewerteten Partien';

  @override
  String get preferencesPromoteToQueenAutomatically => 'Automatische Umwandlung zur Dame';

  @override
  String get preferencesExplainPromoteToQueenAutomatically => 'Halte die <ctrl> Taste während der Umwandlung um vorübergehend die automatische Umwandlung zu deaktivieren';

  @override
  String get preferencesWhenPremoving => 'Bei Vorauszug';

  @override
  String get preferencesClaimDrawOnThreefoldRepetitionAutomatically => 'Reklamiere automatisch Remis bei dreifacher Stellungswiederholung';

  @override
  String get preferencesWhenTimeRemainingLessThanThirtySeconds => 'Wenn Restzeit < 30 Sekunden';

  @override
  String get preferencesMoveConfirmation => 'Zugbestätigung';

  @override
  String get preferencesExplainCanThenBeTemporarilyDisabled => 'Kann während einer Partie mittels Brettmenü deaktiviert werden';

  @override
  String get preferencesInCorrespondenceGames => 'Im Fernschach';

  @override
  String get preferencesCorrespondenceAndUnlimited => 'Fernschach und unbegrenzt';

  @override
  String get preferencesConfirmResignationAndDrawOffers => 'Aufgabe und Remis-Angebote bestätigen';

  @override
  String get preferencesCastleByMovingTheKingTwoSquaresOrOntoTheRook => 'Rochade-Methode';

  @override
  String get preferencesCastleByMovingTwoSquares => 'Ziehe den König zwei Felder weit';

  @override
  String get preferencesCastleByMovingOntoTheRook => 'Ziehe den König auf den Turm';

  @override
  String get preferencesInputMovesWithTheKeyboard => 'Züge mit der Tastatur eingeben';

  @override
  String get preferencesInputMovesWithVoice => 'Züge per Spracheingabe eingeben';

  @override
  String get preferencesSnapArrowsToValidMoves => 'Pfeile markieren immer mögliche Züge';

  @override
  String get preferencesSayGgWpAfterLosingOrDrawing => 'Sage  \"Good game, well played\" (Gute Partie, gut gespielt) nach einer Niederlage oder einem Remis';

  @override
  String get preferencesYourPreferencesHaveBeenSaved => 'Deine Einstellungen wurden gespeichert.';

  @override
  String get preferencesScrollOnTheBoardToReplayMoves => 'Auf dem Brett scrollen, um Züge durchzugehen';

  @override
  String get preferencesCorrespondenceEmailNotification => 'Tägliche E-Mail-Benachrichtigung, die deine Fernschachpartien auflistet';

  @override
  String get preferencesNotifyStreamStart => 'Streamer ist live';

  @override
  String get preferencesNotifyInboxMsg => 'Neue Nachricht im Posteingang';

  @override
  String get preferencesNotifyForumMention => 'Forenkommentar erwähnt dich';

  @override
  String get preferencesNotifyInvitedStudy => 'Einladung zu Studie';

  @override
  String get preferencesNotifyGameEvent => 'Neuigkeiten in Fernschachpartie';

  @override
  String get preferencesNotifyChallenge => 'Herausforderungen';

  @override
  String get preferencesNotifyTournamentSoon => 'Turnier beginnt bald';

  @override
  String get preferencesNotifyTimeAlarm => 'Zeit in Fernschachpartie neigt sich dem Ende zu';

  @override
  String get preferencesNotifyBell => 'Benachrichtigungs-Glocke auf Lichess';

  @override
  String get preferencesNotifyPush => 'Geräte-Benachrichtigung wenn du nicht auf Lichess bist';

  @override
  String get preferencesNotifyWeb => 'Browser';

  @override
  String get preferencesNotifyDevice => 'Gerät';

  @override
  String get preferencesBellNotificationSound => 'Glocken-Benachrichtigungston';

  @override
  String get puzzlePuzzles => 'Taktikaufgaben';

  @override
  String get puzzlePuzzleThemes => 'Aufgabenthemen';

  @override
  String get puzzleRecommended => 'Empfohlen';

  @override
  String get puzzlePhases => 'Phasen';

  @override
  String get puzzleMotifs => 'Motive';

  @override
  String get puzzleAdvanced => 'Fortgeschritten';

  @override
  String get puzzleLengths => 'Längen';

  @override
  String get puzzleMates => 'Matts';

  @override
  String get puzzleGoals => 'Ziele';

  @override
  String get puzzleOrigin => 'Herkunft';

  @override
  String get puzzleSpecialMoves => 'Besondere Züge';

  @override
  String get puzzleDidYouLikeThisPuzzle => 'Hat dir diese Aufgabe gefallen?';

  @override
  String get puzzleVoteToLoadNextOne => 'Stimme ab, um die nächste zu laden!';

  @override
  String get puzzleUpVote => 'Die Aufgabe gut bewerten';

  @override
  String get puzzleDownVote => 'Die Aufgabe schlecht bewerten';

  @override
  String get puzzleYourPuzzleRatingWillNotChange => 'Deine Aufgabenwertung wird sich nicht ändern. Beachte, dass Aufgaben kein Wettbewerb sind. Deine Wertung hilft, die geeignetsten Aufgaben für deine aktuelle Spielstärke auszuwählen.';

  @override
  String get puzzleFindTheBestMoveForWhite => 'Finde den besten Zug für Weiß.';

  @override
  String get puzzleFindTheBestMoveForBlack => 'Finde den besten Zug für Schwarz.';

  @override
  String get puzzleToGetPersonalizedPuzzles => 'Um personalisierte Aufgaben zu erhalten:';

  @override
  String puzzlePuzzleId(String param) {
    return 'Aufgabe $param';
  }

  @override
  String get puzzlePuzzleOfTheDay => 'Aufgabe des Tages';

  @override
  String get puzzleDailyPuzzle => 'Aufgabe des Tages';

  @override
  String get puzzleClickToSolve => 'Zum Lösen klicken';

  @override
  String get puzzleGoodMove => 'Guter Zug';

  @override
  String get puzzleBestMove => 'Bester Zug!';

  @override
  String get puzzleKeepGoing => 'Mach weiter…';

  @override
  String get puzzlePuzzleSuccess => 'Korrekt!';

  @override
  String get puzzlePuzzleComplete => 'Aufgabe abgeschlossen!';

  @override
  String get puzzleByOpenings => 'Nach Eröffnungen';

  @override
  String get puzzlePuzzlesByOpenings => 'Aufgaben nach Eröffnungen';

  @override
  String get puzzleOpeningsYouPlayedTheMost => 'Eröffnungen, die du am meisten in gewerteten Spielen gespielt hast';

  @override
  String get puzzleUseFindInPage => 'Benutze \"Suche in Seite\" im Browser-Menü, um deine Lieblingseröffnung zu finden!';

  @override
  String get puzzleUseCtrlF => 'Mit <Strg>+<f> findest du deine Lieblingseröffnung!';

  @override
  String get puzzleNotTheMove => 'Das ist nicht der Zug!';

  @override
  String get puzzleTrySomethingElse => 'Versuche etwas anderes.';

  @override
  String puzzleRatingX(String param) {
    return 'Wertung: $param';
  }

  @override
  String get puzzleHidden => 'versteckt';

  @override
  String puzzleFromGameLink(String param) {
    return 'Aus der Partie $param';
  }

  @override
  String get puzzleContinueTraining => 'Training fortsetzen';

  @override
  String get puzzleDifficultyLevel => 'Schwierigkeitsgrad';

  @override
  String get puzzleNormal => 'Normal';

  @override
  String get puzzleEasier => 'Einfacher';

  @override
  String get puzzleEasiest => 'Am einfachsten';

  @override
  String get puzzleHarder => 'Schwieriger';

  @override
  String get puzzleHardest => 'Am schwierigsten';

  @override
  String get puzzleExample => 'Beispiel';

  @override
  String get puzzleAddAnotherTheme => 'Ein weiteres Motiv hinzufügen';

  @override
  String get puzzleNextPuzzle => 'Nächste Aufgabe';

  @override
  String get puzzleJumpToNextPuzzleImmediately => 'Sofort zur nächsten Aufgabe springen';

  @override
  String get puzzlePuzzleDashboard => 'Aufgabenübersicht';

  @override
  String get puzzleImprovementAreas => 'Verbesserungsbereiche';

  @override
  String get puzzleStrengths => 'Stärken';

  @override
  String get puzzleHistory => 'Aufgabenverlauf';

  @override
  String get puzzleSolved => 'gelöst';

  @override
  String get puzzleFailed => 'falsch';

  @override
  String get puzzleStreakDescription => 'Löse schwieriger werdende Aufgaben und baue eine Erfolgsserie auf. Es gibt keine Uhr, also nimm dir Zeit. Ein falscher Zug und es ist vorbei! Du kannst jedoch einen Zug pro Sitzung überspringen.';

  @override
  String puzzleYourStreakX(String param) {
    return 'Deine Erfolgsserie: $param';
  }

  @override
  String get puzzleStreakSkipExplanation => 'Überspringe diesen Zug, um deine Antwortserie zu bewahren! Dies funktioniert nur einmal pro Durchlauf.';

  @override
  String get puzzleContinueTheStreak => 'Erfolgsserie fortsetzen';

  @override
  String get puzzleNewStreak => 'Neue Erfolgsserie';

  @override
  String get puzzleFromMyGames => 'Aus meinen Partien';

  @override
  String get puzzleLookupOfPlayer => 'Suche Aufgaben aus den Partien eines Spielers';

  @override
  String puzzleFromXGames(String param) {
    return 'Aufgaben aus Partien von $param';
  }

  @override
  String get puzzleSearchPuzzles => 'Aufgaben suchen';

  @override
  String get puzzleFromMyGamesNone => 'Es befinden sich keine Aufgaben aus deinen Partien in der Datenbank, aber Lichess schätzt dich immer noch sehr.\n\nSpiele Schnellschach und klassische Partien, um deine Chancen zu erhöhen, dass eine Aufgabe aus deinen Partien hinzugefügt wird!';

  @override
  String puzzleFromXGamesFound(String param1, String param2) {
    return '$param1 Aufgaben in $param2 Partien gefunden';
  }

  @override
  String get puzzlePuzzleDashboardDescription => 'Trainiere, analysiere, verbessere';

  @override
  String puzzlePercentSolved(String param) {
    return '$param gelöst';
  }

  @override
  String get puzzleNoPuzzlesToShow => 'Es gibt nichts zu zeigen, löse zuerst ein paar Aufgaben!';

  @override
  String get puzzleImprovementAreasDescription => 'Übe das, um deinen Fortschritt zu optimieren!';

  @override
  String get puzzleStrengthDescription => 'Bei diesen Themen schneiden Sie am besten ab';

  @override
  String puzzlePlayedXTimes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count mal gespielt',
      one: '$count mal gespielt',
    );
    return '$_temp0';
  }

  @override
  String puzzleNbPointsBelowYourPuzzleRating(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Punkte unter deiner Aufgabenwertung',
      one: 'Ein Punkt unter deiner Aufgaben-Wertung',
    );
    return '$_temp0';
  }

  @override
  String puzzleNbPointsAboveYourPuzzleRating(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Punkte über deiner Aufgabenwertung',
      one: 'Ein Punkt über deiner Aufgabenwertung',
    );
    return '$_temp0';
  }

  @override
  String puzzleNbPlayed(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count gespielt',
      one: '$count gespielt',
    );
    return '$_temp0';
  }

  @override
  String puzzleNbToReplay(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count zu wiederholen',
      one: '$count zu wiederholen',
    );
    return '$_temp0';
  }

  @override
  String get puzzleThemeAdvancedPawn => 'Vorgerückter Bauer';

  @override
  String get puzzleThemeAdvancedPawnDescription => 'Einer deiner Bauern ist tief in die gegnerischen Stellung vorgerückt und droht möglicherweise umzuwandeln.';

  @override
  String get puzzleThemeAdvantage => 'Vorteil';

  @override
  String get puzzleThemeAdvantageDescription => 'Nutze deine Chance, um einen entscheidenden Vorteil zu erlangen. (200 Hundertstel-Bauern ≤ Bewertung ≤ 600 Hundertstel-Bauern)';

  @override
  String get puzzleThemeAnastasiaMate => 'Anastasia-Matt';

  @override
  String get puzzleThemeAnastasiaMateDescription => 'Ein Springer und ein Turm bzw. eine Dame arbeiten zusammen, um den gegnerischen König zwischen dem Brettrand und einer seiner eigenen Figuren einzuschließen.';

  @override
  String get puzzleThemeArabianMate => 'Arabisches Matt';

  @override
  String get puzzleThemeArabianMateDescription => 'Ein Springer und ein Turm arbeiten zusammen, um den gegnerischen König in einer Ecke des Bretts matt zu setzen.';

  @override
  String get puzzleThemeAttackingF2F7 => 'Angriff auf f2 oder f7';

  @override
  String get puzzleThemeAttackingF2F7Description => 'Ein Angriff, der sich auf den Bauern auf f2 oder f7 konzentriert, wie z. B. bei der Fegatello-Variante.';

  @override
  String get puzzleThemeAttraction => 'Hinlenkung oder \"Magnet\"';

  @override
  String get puzzleThemeAttractionDescription => 'Ein Abtausch oder Opfer, der eine gegnerische Figur auf ein Feld einlädt oder zwingt, was eine Folgetaktik erlaubt.';

  @override
  String get puzzleThemeBackRankMate => 'Grundreihenmatt';

  @override
  String get puzzleThemeBackRankMateDescription => 'Setze den König auf der Grundreihe matt, wenn er dort durch seine eigenen Figuren blockiert wird.';

  @override
  String get puzzleThemeBishopEndgame => 'Läuferendspiel';

  @override
  String get puzzleThemeBishopEndgameDescription => 'Ein Endspiel nur mit Läufern und Bauern.';

  @override
  String get puzzleThemeBodenMate => 'Boden-Matt';

  @override
  String get puzzleThemeBodenMateDescription => 'Zwei angreifende Läufer auf sich kreuzenden Diagonalen setzen den König matt, der durch eigene Figuren behindert wird.';

  @override
  String get puzzleThemeCastling => 'Rochade';

  @override
  String get puzzleThemeCastlingDescription => 'Bringe deinen König in Sicherheit und den Turm in Angriffsposition.';

  @override
  String get puzzleThemeCapturingDefender => 'Schlage den Verteidiger';

  @override
  String get puzzleThemeCapturingDefenderDescription => 'Ein Verteidiger einer Figur (oder eines Feldes) wird geschlagen, wodurch das eigentliche Ziel die Deckung verliert.';

  @override
  String get puzzleThemeCrushing => 'Vernichtend';

  @override
  String get puzzleThemeCrushingDescription => 'Finde den gegnerischen Patzer, um einen vernichtenden Vorteil zu erhalten. (Bewertung ≥ 600 Hundertstel-Bauern)';

  @override
  String get puzzleThemeDoubleBishopMate => 'Läuferpaarmatt';

  @override
  String get puzzleThemeDoubleBishopMateDescription => 'Zwei angreifende Läufer auf nebeneinander liegenden Diagonalen setzen den König matt, der durch eigene Figuren behindert wird.';

  @override
  String get puzzleThemeDovetailMate => 'Sternmatt';

  @override
  String get puzzleThemeDovetailMateDescription => 'Eine Dame setzt den nebenstehenden König matt, dessen einzigen zwei Fluchtfelder durch eigene Figuren verstellt sind.';

  @override
  String get puzzleThemeEquality => 'Ausgleich';

  @override
  String get puzzleThemeEqualityDescription => 'Komme aus einer verlorenen Stellung zurück und sichere dir ein Remis oder eine ausgeglichene Stellung. (Bewertung ≤ 200 Hundertstel-Bauern)';

  @override
  String get puzzleThemeKingsideAttack => 'Angriff auf den Königsflügel';

  @override
  String get puzzleThemeKingsideAttackDescription => 'Ein Angriff auf den gegnerischen König, nachdem dieser auf den Königsflügel rochiert hat.';

  @override
  String get puzzleThemeClearance => 'Räumung';

  @override
  String get puzzleThemeClearanceDescription => 'Ein Zug, oft mit Tempo, der ein Feld, eine Linie oder Diagonale für ein nachfolgendes taktisches Motiv öffnet.';

  @override
  String get puzzleThemeDefensiveMove => 'Verteidigungszug';

  @override
  String get puzzleThemeDefensiveMoveDescription => 'Ein präziser Zug oder eine Zugfolge, die benötigt wird, um kein Material oder einen anderen Vorteil zu verlieren.';

  @override
  String get puzzleThemeDeflection => 'Ablenkung';

  @override
  String get puzzleThemeDeflectionDescription => 'Ein Zug, der eine gegnerische Figur von einer anderen Aufgabe ablenkt, wie zum Beispiel dem Schutz eines wichtigen Felds. Manchmal auch \"Überlastung\" genannt.';

  @override
  String get puzzleThemeDiscoveredAttack => 'Abzugsangriff';

  @override
  String get puzzleThemeDiscoveredAttackDescription => 'Ziehe eine Figur, die zuvor einen Angriff durch eine andere langschrittige Figur blockierte, wie einen Springer aus dem Weg eines Turms.';

  @override
  String get puzzleThemeDoubleCheck => 'Doppelschach';

  @override
  String get puzzleThemeDoubleCheckDescription => 'Schachgebot mit zwei Figuren gleichzeitig als Ergebnis eines Abzugsangriffs, bei dem sowohl die abziehende als auch die zuvor blockierte Figur den gegnerischen König angreifen.';

  @override
  String get puzzleThemeEndgame => 'Endspiel';

  @override
  String get puzzleThemeEndgameDescription => 'Eine Taktik in der letzten Phase der Partie.';

  @override
  String get puzzleThemeEnPassantDescription => 'Eine Taktik, die die Schachregel \"en passant\" einbezieht, bei der ein Bauer einen gegnerischen Bauer schlagen kann, der an ihm mit seinem Doppelschritt aus der Ausgangsstellung vorbeigegangen ist.';

  @override
  String get puzzleThemeExposedKing => 'Exponierter König';

  @override
  String get puzzleThemeExposedKingDescription => 'Eine Taktik, bei der der König nur von wenigen Figuren verteidigt wird, was oft zum Matt führt.';

  @override
  String get puzzleThemeFork => 'Gabel';

  @override
  String get puzzleThemeForkDescription => 'Ein Zug, bei dem die gezogene Figur zwei gegnerische Figuren auf einmal angreift.';

  @override
  String get puzzleThemeHangingPiece => 'Hängende Figur';

  @override
  String get puzzleThemeHangingPieceDescription => 'Eine Taktik, bei der eine gegnerische Figur nicht oder nur unzureichend gedeckt ist und deshalb mit Vorteil geschlagen werden kann.';

  @override
  String get puzzleThemeHookMate => 'Hakenmatt';

  @override
  String get puzzleThemeHookMateDescription => 'Matt mit Turm, Springer und Bauer, zusammen mit einem gegnerischen Bauern, der dessen König ein Fluchtfeld nimmt.';

  @override
  String get puzzleThemeInterference => 'Unterbrechung';

  @override
  String get puzzleThemeInterferenceDescription => 'Eine Figur zwischen zwei gegnerischen Figuren ziehen, um eine oder beide gegnerische Figuren ungedeckt zu lassen, wie etwa einen Springer auf einem gedeckten Feld zwischen zwei Türmen.';

  @override
  String get puzzleThemeIntermezzo => 'Zwischenzug';

  @override
  String get puzzleThemeIntermezzoDescription => 'Anstatt den erwarteten Zug zu spielen, schiebe einen anderen Zug dazwischen, der eine sofortige Drohung aufstellt, welche der Gegner beantworten muss.';

  @override
  String get puzzleThemeKnightEndgame => 'Springerendspiel';

  @override
  String get puzzleThemeKnightEndgameDescription => 'Ein Endspiel nur mit Springern und Bauern.';

  @override
  String get puzzleThemeLong => 'Mehrzügige Aufgabe';

  @override
  String get puzzleThemeLongDescription => 'Drei Züge zum Sieg.';

  @override
  String get puzzleThemeMaster => 'Meisterpartien';

  @override
  String get puzzleThemeMasterDescription => 'Aufgaben aus Partien von Spielern mit Titel.';

  @override
  String get puzzleThemeMasterVsMaster => 'Partien von Meistern gegen Meister';

  @override
  String get puzzleThemeMasterVsMasterDescription => 'Aufgaben aus Partien zwischen zwei Spielern mit Titel.';

  @override
  String get puzzleThemeMate => 'Matt';

  @override
  String get puzzleThemeMateDescription => 'Gewinne die Partie mit Stil.';

  @override
  String get puzzleThemeMateIn1 => 'Matt in 1';

  @override
  String get puzzleThemeMateIn1Description => 'Mattsetzen in einem Zug.';

  @override
  String get puzzleThemeMateIn2 => 'Matt in 2';

  @override
  String get puzzleThemeMateIn2Description => 'Mattsetzen in zwei Zügen.';

  @override
  String get puzzleThemeMateIn3 => 'Matt in 3';

  @override
  String get puzzleThemeMateIn3Description => 'Mattsetzen in drei Zügen.';

  @override
  String get puzzleThemeMateIn4 => 'Matt in 4';

  @override
  String get puzzleThemeMateIn4Description => 'Mattsetzen in vier Zügen.';

  @override
  String get puzzleThemeMateIn5 => 'Matt in 5 oder mehr';

  @override
  String get puzzleThemeMateIn5Description => 'Finde eine lange, mattsetzende Zugfolge.';

  @override
  String get puzzleThemeMiddlegame => 'Mittelspiel';

  @override
  String get puzzleThemeMiddlegameDescription => 'Eine Taktik in der zweiten Phase des Spiels.';

  @override
  String get puzzleThemeOneMove => 'Einzügige Aufgabe';

  @override
  String get puzzleThemeOneMoveDescription => 'Eine Aufgabe, die nur einen Zug erfordert.';

  @override
  String get puzzleThemeOpening => 'Eröffnung';

  @override
  String get puzzleThemeOpeningDescription => 'Eine Taktik in der ersten Phase der Partie.';

  @override
  String get puzzleThemePawnEndgame => 'Bauernendspiel';

  @override
  String get puzzleThemePawnEndgameDescription => 'Ein Endspiel nur mit Bauern.';

  @override
  String get puzzleThemePin => 'Fesselung';

  @override
  String get puzzleThemePinDescription => 'Eine Taktik mit Fesselung, bei der eine Figur sich nicht bewegen kann, ohne einen Angriff auf eine höherwertige Figur zuzulassen.';

  @override
  String get puzzleThemePromotion => 'Bauernumwandlung';

  @override
  String get puzzleThemePromotionDescription => 'Ein Bauer verwandelt sich in eine Figur (Dame, Turm, Springer oder Läufer).';

  @override
  String get puzzleThemeQueenEndgame => 'Damenendspiel';

  @override
  String get puzzleThemeQueenEndgameDescription => 'Ein Endspiel nur mit Damen und Bauern.';

  @override
  String get puzzleThemeQueenRookEndgame => 'Damen- und Turmendspiel';

  @override
  String get puzzleThemeQueenRookEndgameDescription => 'Ein Endspiel nur mit Damen, Türmen und Bauern.';

  @override
  String get puzzleThemeQueensideAttack => 'Angriff auf den Damenflügel';

  @override
  String get puzzleThemeQueensideAttackDescription => 'Ein Angriff auf den gegnerischen König, nachdem dieser auf den Damenflügel rochiert hat.';

  @override
  String get puzzleThemeQuietMove => 'Stiller Zug';

  @override
  String get puzzleThemeQuietMoveDescription => 'Ein Zug, der weder Schach gibt noch schlägt noch unmittelbar zu schlagen droht, aber eine versteckte unvermeidliche Bedrohung durch einen späteren Zug vorbereitet.';

  @override
  String get puzzleThemeRookEndgame => 'Turmendspiel';

  @override
  String get puzzleThemeRookEndgameDescription => 'Ein Endspiel nur mit Türmen und Bauern.';

  @override
  String get puzzleThemeSacrifice => 'Opfer';

  @override
  String get puzzleThemeSacrificeDescription => 'Eine Taktik mit kurzfristigem Materialverlust, um nach einer erzwungenen Zugfolge wieder einen Vorteil zu erlangen.';

  @override
  String get puzzleThemeShort => 'Kurze Aufgabe';

  @override
  String get puzzleThemeShortDescription => 'Zwei Züge zum Sieg.';

  @override
  String get puzzleThemeSkewer => 'Spieß (Hinterstellung)';

  @override
  String get puzzleThemeSkewerDescription => 'Ein Motiv mit einer angegriffenen, hochwertigen Figur, deren Wegziehen erlaubt, dass eine niederwertige Figur hinter ihr geschlagen oder angegriffen werden kann, das Gegenteil einer Fesselung.';

  @override
  String get puzzleThemeSmotheredMate => 'Ersticktes Matt';

  @override
  String get puzzleThemeSmotheredMateDescription => 'Ein Matt durch einen Springer, in dem der mattgesetzte König sich nicht bewegen kann, weil er von seinen eigenen Figuren umgeben (also erstickt) wird.';

  @override
  String get puzzleThemeSuperGM => 'Super-Großmeister-Partien';

  @override
  String get puzzleThemeSuperGMDescription => 'Aufgaben aus Partien, die von den besten Spielern der Welt bestritten wurden.';

  @override
  String get puzzleThemeTrappedPiece => 'Gefangene Figur';

  @override
  String get puzzleThemeTrappedPieceDescription => 'Eine Figur kann dem Schlagen nicht entgehen, weil ihre Zugmöglichkeiten begrenzt wurden.';

  @override
  String get puzzleThemeUnderPromotion => 'Unterverwandlung';

  @override
  String get puzzleThemeUnderPromotionDescription => 'Umwandlung in einen Springer, Läufer oder Turm.';

  @override
  String get puzzleThemeVeryLong => 'Sehr lange Aufgabe';

  @override
  String get puzzleThemeVeryLongDescription => 'Vier oder mehr Züge zum Gewinn.';

  @override
  String get puzzleThemeXRayAttack => 'Röntgen-Angriff';

  @override
  String get puzzleThemeXRayAttackDescription => 'Eine Figur attackiert oder verteidigt ein Feld durch eine gegnerische Figur hindurch.';

  @override
  String get puzzleThemeZugzwang => 'Zugzwang';

  @override
  String get puzzleThemeZugzwangDescription => 'Der Gegner ist in der Anzahl seiner Züge limitiert und jeder seiner Züge verschlechtert seine Stellung.';

  @override
  String get puzzleThemeHealthyMix => 'Gesunder Mix';

  @override
  String get puzzleThemeHealthyMixDescription => 'Ein bisschen von Allem. Du weißt nicht, was dich erwartet, deshalb bleibst du auf alles vorbereitet! Genau wie in echten Partien.';

  @override
  String get puzzleThemePlayerGames => 'Partien von Spielern';

  @override
  String get puzzleThemePlayerGamesDescription => 'Suche Aufgaben, die aus deinen Partien, oder den Partien eines anderen Spielers generiert wurden.';

  @override
  String puzzleThemePuzzleDownloadInformation(String param) {
    return 'Diese Aufgaben sind öffentlich zugänglich und können unter $param heruntergeladen werden.';
  }

  @override
  String get searchSearch => 'Suche';

  @override
  String get settingsSettings => 'Einstellungen';

  @override
  String get settingsCloseAccount => 'Benutzerkonto schließen';

  @override
  String get settingsManagedAccountCannotBeClosed => 'Dein Konto wird verwaltet und kann nicht geschlossen werden.';

  @override
  String get settingsClosingIsDefinitive => 'Die Kontoschließung ist endgültig. Es gibt kein Zurück. Bist du sicher?';

  @override
  String get settingsCantOpenSimilarAccount => 'Du darfst kein neues Benutzerkonto mit dem gleichen Namen eröffnen, selbst wenn die Groß-/Kleinschreibung unterschiedlich ist.';

  @override
  String get settingsChangedMindDoNotCloseAccount => 'Ich habe meine Meinung geändert, mein Benutzerkonto doch nicht schließen';

  @override
  String get settingsCloseAccountExplanation => 'Bist du dir sicher, dass du dein Benutzerkonto schließen möchtest? Das ist eine endgültige Entscheidung. Du wirst NIE mehr in der Lage sein dich JEMALS wieder einzuloggen.';

  @override
  String get settingsThisAccountIsClosed => 'Dieses Benutzerkonto ist geschlossen.';

  @override
  String get playWithAFriend => 'Spiele mit einem Freund';

  @override
  String get playWithTheMachine => 'Spiele mit dem Computer';

  @override
  String get toInviteSomeoneToPlayGiveThisUrl => 'Versende diese URL, um jemanden zum Spiel einzuladen';

  @override
  String get gameOver => 'Partie beendet';

  @override
  String get waitingForOpponent => 'Auf den Gegner warten';

  @override
  String get orLetYourOpponentScanQrCode => 'Oder lass deinen Gegner diesen QR-Code scannen';

  @override
  String get waiting => 'Warten';

  @override
  String get yourTurn => 'Du bist am Zug';

  @override
  String aiNameLevelAiLevel(String param1, String param2) {
    return '$param1 Stufe $param2';
  }

  @override
  String get level => 'Stufe';

  @override
  String get strength => 'Spielstärke';

  @override
  String get toggleTheChat => 'Chat ein-/ausblenden';

  @override
  String get chat => 'Chat';

  @override
  String get resign => 'Aufgeben';

  @override
  String get checkmate => 'Schachmatt';

  @override
  String get stalemate => 'Patt';

  @override
  String get white => 'Weiß';

  @override
  String get black => 'Schwarz';

  @override
  String get asWhite => 'mit Weiß';

  @override
  String get asBlack => 'mit Schwarz';

  @override
  String get randomColor => 'Zufällige Farbe';

  @override
  String get createAGame => 'Neue Partie';

  @override
  String get whiteIsVictorious => 'Weiß gewinnt';

  @override
  String get blackIsVictorious => 'Schwarz gewinnt';

  @override
  String get youPlayTheWhitePieces => 'Du spielst mit den weißen Figuren';

  @override
  String get youPlayTheBlackPieces => 'Du spielst mit den schwarzen Figuren';

  @override
  String get itsYourTurn => 'Du bist am Zug!';

  @override
  String get cheatDetected => 'Betrug erkannt';

  @override
  String get kingInTheCenter => 'König im Zentrum';

  @override
  String get threeChecks => 'Dreimal Schach gegeben';

  @override
  String get raceFinished => 'Rennen beendet';

  @override
  String get variantEnding => 'Ende der Variante';

  @override
  String get newOpponent => 'Neuer Gegner';

  @override
  String get yourOpponentWantsToPlayANewGameWithYou => 'Dein Gegner möchte eine neue Partie mit dir spielen';

  @override
  String get joinTheGame => 'Der Partie beitreten';

  @override
  String get whitePlays => 'Weiß am Zug';

  @override
  String get blackPlays => 'Schwarz am Zug';

  @override
  String get opponentLeftChoices => 'Dein Gegner hat die Partie verlassen. Du kannst den Sieg beanspruchen, das Spiel Remis erklären oder warten.';

  @override
  String get forceResignation => 'Sieg beanspruchen';

  @override
  String get forceDraw => 'Remis erklären';

  @override
  String get talkInChat => 'Bitte sei freundlich im Chat!';

  @override
  String get theFirstPersonToComeOnThisUrlWillPlayWithYou => 'Die erste Person, die diese URL aufruft, wird dein Gegner.';

  @override
  String get whiteResigned => 'Weiß hat aufgegeben';

  @override
  String get blackResigned => 'Schwarz hat aufgegeben';

  @override
  String get whiteLeftTheGame => 'Weiß hat die Partie verlassen';

  @override
  String get blackLeftTheGame => 'Schwarz hat die Partie verlassen';

  @override
  String get whiteDidntMove => 'Weiß hat nicht gezogen';

  @override
  String get blackDidntMove => 'Schwarz hat nicht gezogen';

  @override
  String get requestAComputerAnalysis => 'Computer-Analyse anfordern';

  @override
  String get computerAnalysis => 'Computer-Analyse';

  @override
  String get computerAnalysisAvailable => 'Computeranalyse verfügbar';

  @override
  String get computerAnalysisDisabled => 'Computeranalyse deaktiviert';

  @override
  String get analysis => 'Analysebrett';

  @override
  String depthX(String param) {
    return 'Tiefe: $param';
  }

  @override
  String get usingServerAnalysis => 'Serveranalyse wird verwendet';

  @override
  String get loadingEngine => 'Engine wird geladen ...';

  @override
  String get calculatingMoves => 'Berechne Züge...';

  @override
  String get engineFailed => 'Fehler beim Laden der Engine';

  @override
  String get cloudAnalysis => 'Cloud-Analyse';

  @override
  String get goDeeper => 'Tiefe erhöhen';

  @override
  String get showThreat => 'Bedrohungen anzeigen';

  @override
  String get inLocalBrowser => 'im lokalen Browser';

  @override
  String get toggleLocalEvaluation => 'Lokale Auswertung an-/ausschalten';

  @override
  String get promoteVariation => 'Variante aufwerten';

  @override
  String get makeMainLine => 'Zur Hauptvariante machen';

  @override
  String get deleteFromHere => 'Ab hier löschen';

  @override
  String get collapseVariations => 'Varianten einklappen';

  @override
  String get expandVariations => 'Varianten ausklappen';

  @override
  String get forceVariation => 'Variante erzwingen';

  @override
  String get copyVariationPgn => 'PGN-Variante kopieren';

  @override
  String get move => 'Zug';

  @override
  String get variantLoss => 'Variante verloren';

  @override
  String get variantWin => 'Variante gewonnen';

  @override
  String get insufficientMaterial => 'Ungenügendes Material';

  @override
  String get pawnMove => 'Bauernzug';

  @override
  String get capture => 'Schlagzug';

  @override
  String get close => 'Schließen';

  @override
  String get winning => 'Gewinnt';

  @override
  String get losing => 'Verliert';

  @override
  String get drawn => 'Remis';

  @override
  String get unknown => 'Unbekannt';

  @override
  String get database => 'Datenbank';

  @override
  String get whiteDrawBlack => 'Weiß / Remis / Schwarz';

  @override
  String averageRatingX(String param) {
    return 'Durchschnittliche Wertungszahl: $param';
  }

  @override
  String get recentGames => 'Neueste Partien';

  @override
  String get topGames => 'Spitzenpartien';

  @override
  String masterDbExplanation(String param1, String param2, String param3) {
    return 'Zwei Millionen OTB-Partien von Spielern mit einer Wertungszahl über $param1 FIDE aus den Jahren $param2 bis $param3';
  }

  @override
  String get dtzWithRounding => 'DTZ50\'\' mit Rundung, basierend auf der Anzahl der Halbzüge bis zum nächsten Schlag- oder Bauernzug';

  @override
  String get noGameFound => 'Kein Spiel gefunden';

  @override
  String get maxDepthReached => 'Maximale Tiefe erreicht!';

  @override
  String get maybeIncludeMoreGamesFromThePreferencesMenu => 'Vielleicht sollten mehr Partien über das \"Einstellungen\"-Menü einbezogen werden?';

  @override
  String get openings => 'Eröffnungen';

  @override
  String get openingExplorer => 'Eröffnungsdatenbank';

  @override
  String get openingEndgameExplorer => 'Eröffnungs-/Endspiel Explorer';

  @override
  String xOpeningExplorer(String param) {
    return '$param Eröffnungsbuch';
  }

  @override
  String get playFirstOpeningEndgameExplorerMove => 'Spiele den ersten Eröffnungs/Endspiel-Explorer Zug';

  @override
  String get winPreventedBy50MoveRule => 'Sieg durch 50-Züge-Regel verhindert';

  @override
  String get lossSavedBy50MoveRule => 'Verlust durch 50-Züge-Regel verhindert';

  @override
  String get winOr50MovesByPriorMistake => 'Sieg oder 50 Züge durch vorherigen Fehler';

  @override
  String get lossOr50MovesByPriorMistake => 'Verlust oder 50 Züge durch vorherigen Fehler';

  @override
  String get unknownDueToRounding => 'Gewinn/Verlust ist nur garantiert, falls die empfohlene Datenbank-Zugfolge seit dem letzten Schlag- oder Bauernzug befolgt wurde, da möglicherweise DTZ-Werte in den Syzygy-Datenbanken gerundet sind.';

  @override
  String get allSet => 'Fertig!';

  @override
  String get importPgn => 'PGN importieren';

  @override
  String get delete => 'Löschen';

  @override
  String get deleteThisImportedGame => 'Dieses importierte Spiel löschen?';

  @override
  String get replayMode => 'Wiedergabemodus';

  @override
  String get realtimeReplay => 'Echtzeit';

  @override
  String get byCPL => 'Nach CPL';

  @override
  String get openStudy => 'Studie öffnen';

  @override
  String get enable => 'Einschalten';

  @override
  String get bestMoveArrow => 'Pfeil für besten Zug';

  @override
  String get showVariationArrows => 'Varianten-Pfeile anzeigen';

  @override
  String get evaluationGauge => 'Bewertungsanzeige';

  @override
  String get multipleLines => 'Mehrere Varianten';

  @override
  String get cpus => 'CPUs';

  @override
  String get memory => 'Arbeitsspeicher';

  @override
  String get infiniteAnalysis => 'Endlose Analyse';

  @override
  String get removesTheDepthLimit => 'Entfernt die Tiefenbegrenzung und hält deinen Computer warm';

  @override
  String get engineManager => 'Engineverwaltung';

  @override
  String get blunder => 'Grober Patzer';

  @override
  String get mistake => 'Fehler';

  @override
  String get inaccuracy => 'Ungenauigkeit';

  @override
  String get moveTimes => 'Zugzeiten';

  @override
  String get flipBoard => 'Brett drehen';

  @override
  String get threefoldRepetition => 'Dreifache Stellungswiederholung';

  @override
  String get claimADraw => 'Remis beanspruchen';

  @override
  String get offerDraw => 'Remis anbieten';

  @override
  String get draw => 'Remis';

  @override
  String get drawByMutualAgreement => 'Remis durch Einigung';

  @override
  String get fiftyMovesWithoutProgress => '50 Züge ohne Spielfortschritt';

  @override
  String get currentGames => 'Laufende Partien';

  @override
  String get viewInFullSize => 'In voller Größe anzeigen';

  @override
  String get logOut => 'Abmelden';

  @override
  String get signIn => 'Einloggen';

  @override
  String get rememberMe => 'Angemeldet bleiben';

  @override
  String get youNeedAnAccountToDoThat => 'Dazu brauchst du ein Benutzerkonto';

  @override
  String get signUp => 'Registrieren';

  @override
  String get computersAreNotAllowedToPlay => 'Unterstützung von Schachprogrammen, Datenbanken oder anderen Spielern ist während einer Partie nicht erlaubt. Bitte beachte auch, dass die Erstellung mehrerer Benutzerkonten ungern gesehen ist und die Missachtung dieser Regel, bis auf Kulanz von Seiten des Teams, zum Ausschluss aller betroffenen Konten führt.';

  @override
  String get games => 'Partien';

  @override
  String get forum => 'Forum';

  @override
  String xPostedInForumY(String param1, String param2) {
    return '$param1 postete im Thread $param2';
  }

  @override
  String get latestForumPosts => 'Neueste Forenbeiträge';

  @override
  String get players => 'Spieler';

  @override
  String get friends => 'Freunde';

  @override
  String get discussions => 'Konversationen';

  @override
  String get today => 'Heute';

  @override
  String get yesterday => 'Gestern';

  @override
  String get minutesPerSide => 'Minuten pro Spieler';

  @override
  String get variant => 'Variante';

  @override
  String get variants => 'Varianten';

  @override
  String get timeControl => 'Bedenkzeit';

  @override
  String get realTime => 'Normale Bedenkzeit';

  @override
  String get correspondence => 'Fernschach';

  @override
  String get daysPerTurn => 'Tage pro Zug';

  @override
  String get oneDay => 'Ein Tag';

  @override
  String get time => 'Zeit';

  @override
  String get rating => 'Wertungszahl';

  @override
  String get ratingStats => 'Wertungsstatistiken';

  @override
  String get username => 'Benutzername';

  @override
  String get usernameOrEmail => 'Benutzername oder E-Mail';

  @override
  String get changeUsername => 'Benutzernamen ändern';

  @override
  String get changeUsernameNotSame => 'Nur die Groß-/Kleinschreibung kann geändert werden, z.B. \"jondoe\" zu \"JonDoe\".';

  @override
  String get changeUsernameDescription => 'Ändere deinen Benutzernamen. Dies ist nur einmalig möglich und bezieht sich lediglich auf Anpassungen der Groß- und Kleinschreibung deines Benutzernamens.';

  @override
  String get signupUsernameHint => 'Bitte wähle einen familienfreundlichen Benutzernamen. Du kannst ihn später nicht mehr ändern und Konten mit unpassenden Benutzernamen werden geschlossen!';

  @override
  String get signupEmailHint => 'Wir werden sie nur zum Zurücksetzen deines Passworts verwenden.';

  @override
  String get password => 'Passwort';

  @override
  String get changePassword => 'Passwort ändern';

  @override
  String get changeEmail => 'E-Mail-Adresse ändern';

  @override
  String get email => 'E-Mail';

  @override
  String get passwordReset => 'Passwort vergessen';

  @override
  String get forgotPassword => 'Passwort vergessen?';

  @override
  String get error_weakPassword => 'Dieses Passwort wird extrem oft verwendet und ist zu einfach zu erraten.';

  @override
  String get error_namePassword => 'Verwende bitte nicht deinen Benutzernamen als Passwort.';

  @override
  String get blankedPassword => 'Du hast das gleiche Passwort auf einer anderen Seite verwendet und diese Seite wurde kompromittiert. Um die Sicherheit deines Lichess-Kontos zu gewährleisten, musst du ein neues Passwort setzen. Danke für dein Verständnis.';

  @override
  String get youAreLeavingLichess => 'Du verlässt Lichess';

  @override
  String get neverTypeYourPassword => 'Gib dein Lichess-Passwort niemals auf einer anderen Seite ein!';

  @override
  String proceedToX(String param) {
    return 'Weiter zu $param';
  }

  @override
  String get passwordSuggestion => 'Benutze kein Passwort, welches jemand anderes vorgeschlagen hat. Man wird versuchen dein Konto zu stehlen.';

  @override
  String get emailSuggestion => 'Benutze keine E-Mail Adresse, welche jemand anderes vorgeschlagen hat. Man wird versuchen dein Konto zu stehlen.';

  @override
  String get emailConfirmHelp => 'Hilfe bei der E-Mail-Bestätigung';

  @override
  String get emailConfirmNotReceived => 'Hast du die Bestätigungs-E-Mail nach der Anmeldung nicht erhalten?';

  @override
  String get whatSignupUsername => 'Mit welchem Benutzernamen hast du dich registriert?';

  @override
  String usernameNotFound(String param) {
    return 'Wir konnten keinen Benutzer mit folgendem Namen finden: $param.';
  }

  @override
  String get usernameCanBeUsedForNewAccount => 'Du kannst diesen Benutzernamen zur Erstellung eines neuen Kontos benutzen';

  @override
  String emailSent(String param) {
    return 'Wir haben eine E-Mail an $param gesendet.';
  }

  @override
  String get emailCanTakeSomeTime => 'Es kann etwas dauern, bis sie ankommt.';

  @override
  String get refreshInboxAfterFiveMinutes => 'Warte 5 Minuten und aktualisiere dein E-Mail-Postfach.';

  @override
  String get checkSpamFolder => 'Überprüfe auch dein Spam-Verzeichnis, sie könnte darin gelandet sein. Falls dem so ist, markiere sie als kein Spam.';

  @override
  String get emailForSignupHelp => 'Falls alles andere fehlschlägt, dann sende uns folgende E-Mail:';

  @override
  String copyTextToEmail(String param) {
    return 'Kopiere den obigen Text, füge ihn hier ein und sende alles an $param';
  }

  @override
  String get waitForSignupHelp => 'Wir werden uns bald mit dir in Verbindung setzen, um deine Registrierung abzuschließen.';

  @override
  String accountConfirmed(String param) {
    return 'Der Benutzer $param ist erfolgreich bestätigt.';
  }

  @override
  String accountCanLogin(String param) {
    return 'Du kannst dich ab sofort als $param einloggen.';
  }

  @override
  String get accountConfirmationEmailNotNeeded => 'Du benötigst keine Bestätigungs-E-Mail.';

  @override
  String accountClosed(String param) {
    return 'Das Benutzerkonto $param ist geschlossen.';
  }

  @override
  String accountRegisteredWithoutEmail(String param) {
    return 'Das Benutzerkonto $param wurde ohne eine E-Mail-Adresse angelegt.';
  }

  @override
  String get rank => 'Rang';

  @override
  String rankX(String param) {
    return 'Platz: $param';
  }

  @override
  String get gamesPlayed => 'Gespielte Partien';

  @override
  String get cancel => 'Abbrechen';

  @override
  String get whiteTimeOut => 'Zeitüberschreitung von Weiß';

  @override
  String get blackTimeOut => 'Zeitüberschreitung von Schwarz';

  @override
  String get drawOfferSent => 'Remisangebot gesendet';

  @override
  String get drawOfferAccepted => 'Remisangebot angenommen';

  @override
  String get drawOfferCanceled => 'Remisangebot zurückgezogen';

  @override
  String get whiteOffersDraw => 'Weiß bietet Remis';

  @override
  String get blackOffersDraw => 'Schwarz bietet Remis';

  @override
  String get whiteDeclinesDraw => 'Weiß lehnt Remis ab';

  @override
  String get blackDeclinesDraw => 'Schwarz lehnt Remis ab';

  @override
  String get yourOpponentOffersADraw => 'Dein Gegner bietet Remis an';

  @override
  String get accept => 'Annehmen';

  @override
  String get decline => 'Ablehnen';

  @override
  String get playingRightNow => 'Partie läuft';

  @override
  String get eventInProgress => 'Laufende Partien';

  @override
  String get finished => 'Beendet';

  @override
  String get abortGame => 'Partie abbrechen';

  @override
  String get gameAborted => 'Partie abgebrochen';

  @override
  String get standard => 'Standard';

  @override
  String get customPosition => 'Benutzerdefinierte Stellung';

  @override
  String get unlimited => 'Unbegrenzt';

  @override
  String get mode => 'Modus';

  @override
  String get casual => 'Ungewertet';

  @override
  String get rated => 'Gewertet';

  @override
  String get casualTournament => 'Ungewertet';

  @override
  String get ratedTournament => 'Gewertet';

  @override
  String get thisGameIsRated => 'Dieses Spiel wird gewertet';

  @override
  String get rematch => 'Revanche';

  @override
  String get rematchOfferSent => 'Angebot zur Revanche gesendet';

  @override
  String get rematchOfferAccepted => 'Angebot zur Revanche angenommen';

  @override
  String get rematchOfferCanceled => 'Angebot zur Revanche zurückgezogen';

  @override
  String get rematchOfferDeclined => 'Angebot zur Revanche abgelehnt';

  @override
  String get cancelRematchOffer => 'Angebot zur Revanche zurückziehen';

  @override
  String get viewRematch => 'Revanche ansehen';

  @override
  String get confirmMove => 'Zug bestätigen';

  @override
  String get play => 'Spielen';

  @override
  String get inbox => 'Posteingang';

  @override
  String get chatRoom => 'Chatraum';

  @override
  String get loginToChat => 'Logge dich ein, um zu chatten';

  @override
  String get youHaveBeenTimedOut => 'Dir wurde eine Auszeit verordnet.';

  @override
  String get spectatorRoom => 'Zuschauerraum';

  @override
  String get composeMessage => 'Nachricht verfassen';

  @override
  String get subject => 'Betreff';

  @override
  String get send => 'Senden';

  @override
  String get incrementInSeconds => 'Inkrement in Sekunden';

  @override
  String get freeOnlineChess => 'Kostenloses Online-Schach';

  @override
  String get exportGames => 'Partien exportieren';

  @override
  String get ratingRange => 'Wertungsbereich';

  @override
  String get thisAccountViolatedTos => 'Dieses Konto hat gegen die Lichess-Nutzungsbedingungen verstoßen';

  @override
  String get openingExplorerAndTablebase => 'Eröffnungsbuch & Tablebase';

  @override
  String get takeback => 'Zugrücknahme';

  @override
  String get proposeATakeback => 'Zugrücknahme vorschlagen';

  @override
  String get takebackPropositionSent => 'Zugrücknahme vorgeschlagen';

  @override
  String get takebackPropositionDeclined => 'Zugrücknahme abgelehnt';

  @override
  String get takebackPropositionAccepted => 'Zugrücknahme angenommen';

  @override
  String get takebackPropositionCanceled => 'Zugrücknahme zurückgezogen';

  @override
  String get yourOpponentProposesATakeback => 'Dein Gegner möchte den letzten Zug zurücknehmen';

  @override
  String get bookmarkThisGame => 'Als Lesezeichen speichern';

  @override
  String get tournament => 'Turnier';

  @override
  String get tournaments => 'Turniere';

  @override
  String get tournamentPoints => 'Turnierpunkte';

  @override
  String get viewTournament => 'Turnier anschauen';

  @override
  String get backToTournament => 'Zurück zum Turnier';

  @override
  String get noDrawBeforeSwissLimit => 'Du kannst in einem Turnier nach Schweizer System nicht vor dem Erreichen des 30. Zugs Remis anbieten.';

  @override
  String get thematic => 'Thematisch';

  @override
  String yourPerfRatingIsProvisional(String param) {
    return 'Deine $param Wertung ist provisorisch';
  }

  @override
  String yourPerfRatingIsTooHigh(String param1, String param2) {
    return 'Deine $param1 Wertung ($param2) ist zu hoch';
  }

  @override
  String yourTopWeeklyPerfRatingIsTooHigh(String param1, String param2) {
    return 'Deine beste wöchentliche $param1 Wertung ($param2) ist zu hoch';
  }

  @override
  String yourPerfRatingIsTooLow(String param1, String param2) {
    return 'Deine $param1 Wertung ($param2) ist zu niedrig';
  }

  @override
  String ratedMoreThanInPerf(String param1, String param2) {
    return 'Wertung ≥ $param1 in $param2';
  }

  @override
  String ratedLessThanInPerf(String param1, String param2) {
    return 'Wertung ≤ $param1 im $param2 diese Woche';
  }

  @override
  String mustBeInTeam(String param) {
    return 'Du musst zum Team $param gehören';
  }

  @override
  String youAreNotInTeam(String param) {
    return 'Du gehörst nicht zum Team $param';
  }

  @override
  String get backToGame => 'Zurück zur Partie';

  @override
  String get siteDescription => 'Kostenloser Online-Schach-Server. Spiele jetzt auf einer übersichtlichen Benutzeroberfläche Schach! Keine Registrierung und keine Plugins erforderlich, komplett ohne Werbung. Spiele gegen den Computer, Freunde oder zufällige Gegner!';

  @override
  String xJoinedTeamY(String param1, String param2) {
    return '$param1 trat dem Team $param2 bei';
  }

  @override
  String xCreatedTeamY(String param1, String param2) {
    return '$param1 hat das Team $param2 gegründet';
  }

  @override
  String get startedStreaming => 'hat einen Stream gestartet';

  @override
  String xStartedStreaming(String param) {
    return '$param hat einen Stream gestartet';
  }

  @override
  String get averageElo => 'Durchschnittswertung';

  @override
  String get location => 'Ort';

  @override
  String get filterGames => 'Partien filtern';

  @override
  String get reset => 'Zurücksetzen';

  @override
  String get apply => 'Anwenden';

  @override
  String get save => 'Speichern';

  @override
  String get leaderboard => 'Rangliste';

  @override
  String get screenshotCurrentPosition => 'Eine Bildschirmaufnahme der aktuellen Stellung anfertigen';

  @override
  String get gameAsGIF => 'Partie als GIF';

  @override
  String get pasteTheFenStringHere => 'Füge den FEN-Text hier ein';

  @override
  String get pasteThePgnStringHere => 'Füge den PGN-Text hier ein';

  @override
  String get orUploadPgnFile => 'Oder lade eine PGN-Datei hoch';

  @override
  String get fromPosition => 'Von Stellung';

  @override
  String get continueFromHere => 'Von hier aus weiterspielen';

  @override
  String get toStudy => 'Studie';

  @override
  String get importGame => 'Partie importieren';

  @override
  String get importGameExplanation => 'Wenn du ein PGN einfügst, hast du Zugriff auf eine Spielwiederholung, eine Computeranalyse, einen Spielchat und eine teilbare URL.';

  @override
  String get importGameCaveat => 'Varianten werden gelöscht. Importiere die PGN mittels einer Studie, um sie zu behalten.';

  @override
  String get importGameDataPrivacyWarning => 'Diese PGN ist öffentlich zugänglich. Nutze eine Studie, um eine Partie nur für dich zu importieren.';

  @override
  String get thisIsAChessCaptcha => 'Dies ist ein Schach-CAPTCHA.';

  @override
  String get clickOnTheBoardToMakeYourMove => 'Mach einen Zug, um zu beweisen, dass du ein Mensch bist.';

  @override
  String get captcha_fail => 'Bitte löse die Schachaufgabe.';

  @override
  String get notACheckmate => 'Kein Matt';

  @override
  String get whiteCheckmatesInOneMove => 'Weiß setzt in einem Zug Matt';

  @override
  String get blackCheckmatesInOneMove => 'Schwarz setzt in einem Zug Matt';

  @override
  String get retry => 'Erneut versuchen';

  @override
  String get reconnecting => 'Wiederverbinden';

  @override
  String get noNetwork => 'Offline';

  @override
  String get favoriteOpponents => 'Häufigste Gegner';

  @override
  String get follow => 'Folgen';

  @override
  String get following => 'Folge ich';

  @override
  String get unfollow => 'Nicht mehr folgen';

  @override
  String followX(String param) {
    return '$param folgen';
  }

  @override
  String unfollowX(String param) {
    return '$param nicht mehr folgen';
  }

  @override
  String get block => 'Blockieren';

  @override
  String get blocked => 'Blockiert';

  @override
  String get unblock => 'Nicht mehr blockieren';

  @override
  String get followsYou => 'Folgt dir';

  @override
  String xStartedFollowingY(String param1, String param2) {
    return '$param1 folgt jetzt $param2';
  }

  @override
  String get more => 'Mehr';

  @override
  String get memberSince => 'Mitglied seit';

  @override
  String lastSeenActive(String param) {
    return 'Zuletzt aktiv $param';
  }

  @override
  String get player => 'Spieler';

  @override
  String get list => 'Liste';

  @override
  String get graph => 'Graph';

  @override
  String get required => 'Pflichtfeld.';

  @override
  String get openTournaments => 'Offene Turniere';

  @override
  String get duration => 'Dauer';

  @override
  String get winner => 'Gewinner';

  @override
  String get standing => 'Tabelle';

  @override
  String get createANewTournament => 'Neues Turnier erstellen';

  @override
  String get tournamentCalendar => 'Turnierkalender';

  @override
  String get conditionOfEntry => 'Teilnahmebedingung:';

  @override
  String get advancedSettings => 'Erweiterte Einstellungen';

  @override
  String get safeTournamentName => 'Wähle einen äußerst sicheren Namen für das Turnier.';

  @override
  String get inappropriateNameWarning => 'Sämtliche unangemessene Inhalte können zur Schließung deines Benutzerkontos führen.';

  @override
  String get emptyTournamentName => 'Frei lassen, um das Turnier nach einem zufälligen Großmeister zu benennen.';

  @override
  String get makePrivateTournament => 'Stelle das Turnier auf privat und beschränke den Zugang durch ein Passwort';

  @override
  String get join => 'Teilnehmen';

  @override
  String get withdraw => 'Verlassen';

  @override
  String get points => 'Punkte';

  @override
  String get wins => 'Siege';

  @override
  String get losses => 'Niederlagen';

  @override
  String get createdBy => 'Erstellt von';

  @override
  String get tournamentIsStarting => 'Das Turnier beginnt';

  @override
  String get tournamentPairingsAreNowClosed => 'Es werden keine neuen Turnierspiele mehr gestartet.';

  @override
  String standByX(String param) {
    return 'Die Turnier-Paarungen werden zugeteilt. Fertig machen zum Start, $param!';
  }

  @override
  String get pause => 'Pausieren';

  @override
  String get resume => 'Fortsetzen';

  @override
  String get youArePlaying => 'Dein Spiel beginnt!';

  @override
  String get winRate => 'Gewinnrate';

  @override
  String get berserkRate => 'Berserkrate';

  @override
  String get performance => 'Turnierleistung';

  @override
  String get tournamentComplete => 'Turnier beendet';

  @override
  String get movesPlayed => 'Gespielte Züge';

  @override
  String get whiteWins => 'Weiße Siege';

  @override
  String get blackWins => 'Schwarze Siege';

  @override
  String get drawRate => 'Remisquote';

  @override
  String get draws => 'Remisen';

  @override
  String nextXTournament(String param) {
    return 'Nächstes $param Turnier:';
  }

  @override
  String get averageOpponent => 'Durchschnittlicher Gegner';

  @override
  String get boardEditor => 'Stellung aufbauen';

  @override
  String get setTheBoard => 'Brett aufbauen';

  @override
  String get popularOpenings => 'Beliebte Eröffnungen';

  @override
  String get endgamePositions => 'Endspielstellungen';

  @override
  String chess960StartPosition(String param) {
    return 'Schach960 Anfangsstellung: $param';
  }

  @override
  String get startPosition => 'Anfangsposition';

  @override
  String get clearBoard => 'Brett räumen';

  @override
  String get loadPosition => 'Stellung laden';

  @override
  String get isPrivate => 'Privat';

  @override
  String reportXToModerators(String param) {
    return 'Melde $param den Moderatoren';
  }

  @override
  String profileCompletion(String param) {
    return 'Profil vollständig zu $param';
  }

  @override
  String xRating(String param) {
    return '$param Wertungszahl';
  }

  @override
  String get ifNoneLeaveEmpty => 'Nur falls vorhanden';

  @override
  String get profile => 'Profil';

  @override
  String get editProfile => 'Profil bearbeiten';

  @override
  String get realName => 'Echter Name';

  @override
  String get setFlair => 'Setze dein Flair';

  @override
  String get flair => 'Flair';

  @override
  String get youCanHideFlair => 'Es existiert eine Einstellungsmöglichkeit, um alle Benutzerflairs auf der gesamten Seite zu verbergen.';

  @override
  String get biography => 'Profiltext';

  @override
  String get countryRegion => 'Land oder Region';

  @override
  String get thankYou => 'Vielen Dank!';

  @override
  String get socialMediaLinks => 'Social-Media-Links';

  @override
  String get oneUrlPerLine => 'Eine URL pro Zeile.';

  @override
  String get inlineNotation => 'Inline-Notation';

  @override
  String get makeAStudy => 'Zur Sicherheit und zum Teilen, überlege, ob du eine Studie anlegen möchtest.';

  @override
  String get clearSavedMoves => 'Züge löschen';

  @override
  String get previouslyOnLichessTV => 'Zuletzt auf Lichess TV';

  @override
  String get onlinePlayers => 'Spieler online';

  @override
  String get activePlayers => 'Aktive Spieler';

  @override
  String get bewareTheGameIsRatedButHasNoClock => 'Achtung! Das Spiel wird gewertet, aber ohne Uhr gespielt!';

  @override
  String get success => 'Gespeichert';

  @override
  String get automaticallyProceedToNextGameAfterMoving => 'Nach dem Zug automatisch zur nächsten Partie gehen';

  @override
  String get autoSwitch => 'Automatischer Wechsel';

  @override
  String get puzzles => 'Aufgaben';

  @override
  String get onlineBots => 'Online-Bots';

  @override
  String get name => 'Name';

  @override
  String get description => 'Beschreibung';

  @override
  String get descPrivate => 'Interne Beschreibung';

  @override
  String get descPrivateHelp => 'Text, den nur Teammitglieder lesen können. Wenn ausgefüllt, ersetzt er für Teammitglieder die öffentliche Beschreibung.';

  @override
  String get no => 'Nein';

  @override
  String get yes => 'Ja';

  @override
  String get help => 'Hilfe:';

  @override
  String get createANewTopic => 'Erstelle ein neues Thema';

  @override
  String get topics => 'Themen';

  @override
  String get posts => 'Beiträge';

  @override
  String get lastPost => 'Letzter Beitrag';

  @override
  String get views => 'Besuche';

  @override
  String get replies => 'Antworten';

  @override
  String get replyToThisTopic => 'Auf dieses Thema antworten';

  @override
  String get reply => 'Antworten';

  @override
  String get message => 'Nachricht';

  @override
  String get createTheTopic => 'Thema erstellen';

  @override
  String get reportAUser => 'Benutzer melden';

  @override
  String get user => 'Benutzer';

  @override
  String get reason => 'Grund';

  @override
  String get whatIsIheMatter => 'Was ist das Problem?';

  @override
  String get cheat => 'Betrug';

  @override
  String get troll => 'Troll';

  @override
  String get other => 'Sonstiges';

  @override
  String get reportDescriptionHelp => 'Füge den Link zu einer oder mehreren Partien ein und erkläre die Auffälligkeiten bezüglich des Spielerverhaltens. Bitte schreibe nicht einfach nur „dieser Spieler betrügt“, sondern begründe auch, wie Du zu diesem Schluss kommst. Dein Bericht wird schneller bearbeitet, wenn er in englischer Sprache verfasst ist.';

  @override
  String get error_provideOneCheatedGameLink => 'Bitte gib mindestens einen Link zu einem Spiel an, in dem betrogen wurde.';

  @override
  String by(String param) {
    return 'von $param';
  }

  @override
  String importedByX(String param) {
    return 'Importiert von $param';
  }

  @override
  String get thisTopicIsNowClosed => 'Dieses Thema wurde geschlossen.';

  @override
  String get blog => 'Blog';

  @override
  String get notes => 'Notizen';

  @override
  String get typePrivateNotesHere => 'Private Notizen hier eingeben';

  @override
  String get writeAPrivateNoteAboutThisUser => 'Verfasse eine private Notiz über diesen Benutzer';

  @override
  String get noNoteYet => 'Noch keine Notiz';

  @override
  String get invalidUsernameOrPassword => 'Ungültiger Benutzername oder Passwort';

  @override
  String get incorrectPassword => 'Falsches Passwort';

  @override
  String get invalidAuthenticationCode => 'Ungültiger Authentifizierungscode';

  @override
  String get emailMeALink => 'Schicke mir einen Link per E-Mail';

  @override
  String get currentPassword => 'Derzeitiges Passwort';

  @override
  String get newPassword => 'Neues Passwort';

  @override
  String get newPasswordAgain => 'Neues Passwort (wiederholen)';

  @override
  String get newPasswordsDontMatch => 'Die neuen Passwörter stimmen nicht überein';

  @override
  String get newPasswordStrength => 'Passwortstärke';

  @override
  String get clockInitialTime => 'Grundbedenkzeit';

  @override
  String get clockIncrement => 'Zeit-Inkrement';

  @override
  String get privacy => 'Privatsphäre';

  @override
  String get privacyPolicy => 'Datenschutzbestimmungen';

  @override
  String get letOtherPlayersFollowYou => 'Anderen erlauben, mir zu folgen';

  @override
  String get letOtherPlayersChallengeYou => 'Anderen erlauben, mich herauszufordern';

  @override
  String get letOtherPlayersInviteYouToStudy => 'Erlaube anderen Spielern, dich zu einer Studie einzuladen';

  @override
  String get sound => 'Ton';

  @override
  String get none => 'Keine';

  @override
  String get fast => 'Schnell';

  @override
  String get normal => 'Mittel';

  @override
  String get slow => 'Langsam';

  @override
  String get insideTheBoard => 'Auf dem Brett';

  @override
  String get outsideTheBoard => 'Neben dem Brett';

  @override
  String get allSquaresOfTheBoard => 'Alle Felder auf dem Brett';

  @override
  String get onSlowGames => 'Bei langsamen Spielen';

  @override
  String get always => 'Immer';

  @override
  String get never => 'Nie';

  @override
  String xCompetesInY(String param1, String param2) {
    return '$param1 nimmt teil bei $param2';
  }

  @override
  String get victory => 'Sieg';

  @override
  String get defeat => 'Niederlage';

  @override
  String victoryVsYInZ(String param1, String param2, String param3) {
    return '$param1 gegen $param2 in $param3';
  }

  @override
  String defeatVsYInZ(String param1, String param2, String param3) {
    return '$param1 gegen $param2 in $param3';
  }

  @override
  String drawVsYInZ(String param1, String param2, String param3) {
    return '$param1 gegen $param2 in $param3';
  }

  @override
  String get timeline => 'Verlauf';

  @override
  String get starting => 'Beginnt:';

  @override
  String get allInformationIsPublicAndOptional => 'Alle Informationen sind öffentlich und freiwillig.';

  @override
  String get biographyDescription => 'Erzähl über dich, was du an Schach magst, deine Lieblingseröffnungen, Partien, Spieler, …';

  @override
  String get listBlockedPlayers => 'Liste der gesperrten Spieler';

  @override
  String get human => 'Mensch';

  @override
  String get computer => 'Computer';

  @override
  String get side => 'Farbe';

  @override
  String get clock => 'Uhr';

  @override
  String get opponent => 'Gegner';

  @override
  String get learnMenu => 'Lernen';

  @override
  String get studyMenu => 'Studien';

  @override
  String get practice => 'Trainieren';

  @override
  String get community => 'Gemeinschaft';

  @override
  String get tools => 'Werkzeuge';

  @override
  String get increment => 'Inkrement';

  @override
  String get error_unknown => 'Ungültiger Wert';

  @override
  String get error_required => 'Dieses Feld muss ausgefüllt werden';

  @override
  String get error_email => 'Diese E-Mail-Adresse ist ungültig';

  @override
  String get error_email_acceptable => 'Diese E-Mail-Adresse wird nicht akzeptiert. Bitte überprüfe sie und versuche es erneut.';

  @override
  String get error_email_unique => 'E-Mail-Adresse ungültig oder bereits vergeben';

  @override
  String get error_email_different => 'Dies ist bereits deine E-Mail Adresse';

  @override
  String error_minLength(String param) {
    return 'Mindestlänge beträgt $param Zeichen';
  }

  @override
  String error_maxLength(String param) {
    return 'Maximallänge beträgt $param Zeichen';
  }

  @override
  String error_min(String param) {
    return 'Muss mindestens $param sein';
  }

  @override
  String error_max(String param) {
    return 'Darf höchstens $param sein';
  }

  @override
  String ifRatingIsPlusMinusX(String param) {
    return 'Nur, wenn die Wertungszahl ± $param ist';
  }

  @override
  String get ifRegistered => 'Wenn registriert';

  @override
  String get onlyExistingConversations => 'Nur bestehende Konversationen';

  @override
  String get onlyFriends => 'Nur Freunde';

  @override
  String get menu => 'Menü';

  @override
  String get castling => 'Rochade';

  @override
  String get whiteCastlingKingside => 'Weiß O-O';

  @override
  String get blackCastlingKingside => 'Schwarz O-O';

  @override
  String tpTimeSpentPlaying(String param) {
    return 'Gesamte Spielzeit: $param';
  }

  @override
  String get watchGames => 'Partien ansehen';

  @override
  String tpTimeSpentOnTV(String param) {
    return 'Gesamtzeit TV: $param';
  }

  @override
  String get watch => 'Zuschauen';

  @override
  String get videoLibrary => 'Video-Bibliothek';

  @override
  String get streamersMenu => 'Streamer';

  @override
  String get mobileApp => 'Mobile App';

  @override
  String get webmasters => 'Webmaster';

  @override
  String get about => 'Über';

  @override
  String aboutX(String param) {
    return 'Über $param';
  }

  @override
  String xIsAFreeYLibreOpenSourceChessServer(String param1, String param2) {
    return '$param1 ist ein freier, quelloffener Schachserver. Kostenlos ($param2) und ohne Werbung.';
  }

  @override
  String get really => 'wirklich';

  @override
  String get contribute => 'Mitmachen';

  @override
  String get termsOfService => 'AGB';

  @override
  String get sourceCode => 'Quellcode';

  @override
  String get simultaneousExhibitions => 'Simultanschach';

  @override
  String get host => 'Veranstalter';

  @override
  String hostColorX(String param) {
    return 'Farbe des Ausrichters: $param';
  }

  @override
  String get yourPendingSimuls => 'Deine ausstehenden Simultanpartien';

  @override
  String get createdSimuls => 'Neue Simultanspiele';

  @override
  String get hostANewSimul => 'Ein Simultan veranstalten';

  @override
  String get signUpToHostOrJoinASimul => 'Melde dich an, um eine Simultanpartie auszutragen oder sich einer anzuschließen';

  @override
  String get noSimulFound => 'Simultan nicht gefunden';

  @override
  String get noSimulExplanation => 'Dieses Simultan existiert nicht.';

  @override
  String get returnToSimulHomepage => 'Zurück zur Simultan Homepage';

  @override
  String get aboutSimul => 'Beim Simultan spielt ein Spieler gleichzeitig gegen mehrere Gegner.';

  @override
  String get aboutSimulImage => 'Gegen 50 Gegner gewann Fischer 47 Partien, remisierte zwei und verlor eine.';

  @override
  String get aboutSimulRealLife => 'Das Konzept ähnelt dem bei echten Simultanveranstaltungen, wo sich der Alleinspieler von Brett zu Brett bewegt.';

  @override
  String get aboutSimulRules => 'Beim Start des Simultan beginnt der Alleinspieler mit Weiß und spielt so lange mit wechselnden Gegnern, bis alle Partien beendet sind.';

  @override
  String get aboutSimulSettings => 'Simultane sind immer ungewertet. Revanchen, Zugrücknahme und zusätzliche Zeit sind deaktiviert.';

  @override
  String get create => 'Erstellen';

  @override
  String get whenCreateSimul => 'Wenn du ein Simultan erstellst, spielst du mit mehreren Gegnern gleichzeitig.';

  @override
  String get simulVariantsHint => 'Wurden mehrere Varianten gewählt, kann jeder Spieler sich eine Variante aussuchen.';

  @override
  String get simulClockHint => 'Fischer Bedenkzeit. Je mehr Gegner du hast, desto mehr Zeit wirst du benötigen.';

  @override
  String get simulAddExtraTime => 'Du kannst dir selbst zusätzliche Zeit hinzufügen, um mit dem Simultan zurechtzukommen.';

  @override
  String get simulHostExtraTime => 'Extra Bedenkzeit des Ausrichters';

  @override
  String get simulAddExtraTimePerPlayer => 'Füge deiner Uhr für jeden Spieler, der deinem Simultan beitritt, zu Beginn zusätzliche Bedenkzeit hinzu.';

  @override
  String get simulHostExtraTimePerPlayer => 'Teile jedem Spieler zusätzliche Bedenkzeit zu';

  @override
  String get lichessTournaments => 'Lichess Turniere';

  @override
  String get tournamentFAQ => 'Arena FAQ';

  @override
  String get timeBeforeTournamentStarts => 'Zeit bis zum Start des Turniers';

  @override
  String get averageCentipawnLoss => 'Durchschnittlicher Zentibauer-Verlust';

  @override
  String get accuracy => 'Genauigkeit';

  @override
  String get keyboardShortcuts => 'Tastenkürzel';

  @override
  String get keyMoveBackwardOrForward => 'Zug zurück/vor';

  @override
  String get keyGoToStartOrEnd => 'zum Anfang/Ende';

  @override
  String get keyCycleSelectedVariation => 'Durch die ausgewählte Variante schalten';

  @override
  String get keyShowOrHideComments => 'zeige/verberge Kommentare';

  @override
  String get keyEnterOrExitVariation => 'Variante wählen/verlassen';

  @override
  String get keyRequestComputerAnalysis => 'Hole dir eine Computer-Analyse, lerne aus deinen Fehlern';

  @override
  String get keyNextLearnFromYourMistakes => 'Als Nächstes (Lerne aus deinen Fehlern)';

  @override
  String get keyNextBlunder => 'Der nächste grobe Patzer';

  @override
  String get keyNextMistake => 'Der nächste Fehler';

  @override
  String get keyNextInaccuracy => 'Die nächste Ungenauigkeit';

  @override
  String get keyPreviousBranch => 'Vorherige Verzweigung';

  @override
  String get keyNextBranch => 'Nächste Verzweigung';

  @override
  String get toggleVariationArrows => 'Variantenpfeile ein-/auschalten';

  @override
  String get cyclePreviousOrNextVariation => 'Durch vorherige/nächste Variante schalten';

  @override
  String get toggleGlyphAnnotations => 'Schalten der Zeichen-Anmerkungen';

  @override
  String get togglePositionAnnotations => 'Positionsanmerkungen umschalten';

  @override
  String get variationArrowsInfo => 'Mit Variantenpfeilen navigierst du durch die Zugliste.';

  @override
  String get playSelectedMove => 'den ausgewählten Zug ausführen';

  @override
  String get newTournament => 'Neues Turnier';

  @override
  String get tournamentHomeTitle => 'Schachturnier mit verschiedenen Zeitkontrollen und Schachvarianten';

  @override
  String get tournamentHomeDescription => 'Spiele rasante Turniere! Trete einem geplanten Turnier bei oder erstelle ein neues. Bullet, Blitz, Klassisch, Chess960, King of the Hill, Threecheck und weitere Schachvarianten für grenzenlosen Spaß.';

  @override
  String get tournamentNotFound => 'Turnier nicht gefunden';

  @override
  String get tournamentDoesNotExist => 'Dieses Turnier existiert nicht.';

  @override
  String get tournamentMayHaveBeenCanceled => 'Womöglich wurde es abgesagt, weil zu Turnierbeginn kein Spieler (mehr) registriert war.';

  @override
  String get returnToTournamentsHomepage => 'Zurück zur Turnier-Homepage';

  @override
  String weeklyPerfTypeRatingDistribution(String param) {
    return 'Wöchentliche $param-Wertungsverteilung';
  }

  @override
  String yourPerfTypeRatingIsRating(String param1, String param2) {
    return 'Deine $param1-Wertungszahl ist $param2.';
  }

  @override
  String youAreBetterThanPercentOfPerfTypePlayers(String param1, String param2) {
    return 'Du bist besser als $param1 aller $param2-Spieler.';
  }

  @override
  String userIsBetterThanPercentOfPerfTypePlayers(String param1, String param2, String param3) {
    return '$param1 ist besser als $param2 der $param3-Spieler.';
  }

  @override
  String betterThanPercentPlayers(String param1, String param2) {
    return 'Besser als $param1 aller $param2-Spieler';
  }

  @override
  String youDoNotHaveAnEstablishedPerfTypeRating(String param) {
    return 'Du hast keine feststehende $param-Wertung.';
  }

  @override
  String get yourRating => 'Deine Wertungszahl';

  @override
  String get cumulative => 'Summiert';

  @override
  String get glicko2Rating => 'Glicko-2 Wertung';

  @override
  String get checkYourEmail => 'Prüfe deine E-Mails';

  @override
  String get weHaveSentYouAnEmailClickTheLink => 'Wir haben dir eine E-Mail gesendet. Klicke den Link in der Email, um deinen Account zu aktivieren.';

  @override
  String get ifYouDoNotSeeTheEmailCheckOtherPlaces => 'Wenn du die E-Mail nicht findest, prüfe in deinem E-Mail-Konto, ob sie in einem anderen Ordner wie z.B. dem Spamordner oder dem Papierkorb ist.';

  @override
  String weHaveSentYouAnEmailTo(String param) {
    return 'Wir haben dir eine Email an $param gesendet. Klicke auf den Link in der E-Mail, um dein Passwort zurück zu setzen.';
  }

  @override
  String byRegisteringYouAgreeToBeBoundByOur(String param) {
    return 'Durch die Anmeldung wird den $param zugestimmt.';
  }

  @override
  String readAboutOur(String param) {
    return 'Lies unsere $param.';
  }

  @override
  String get networkLagBetweenYouAndLichess => 'Netzwerkverzögerung zwischen dir und Lichess';

  @override
  String get timeToProcessAMoveOnLichessServer => 'Zeit, um einen Zug auf dem Lichess-Server zu verarbeiten';

  @override
  String get downloadAnnotated => 'Download kommentiert';

  @override
  String get downloadRaw => 'Download unkommentiert';

  @override
  String get downloadImported => 'Importiertes Spiel herunterladen';

  @override
  String get crosstable => 'Matchverlauf';

  @override
  String get youCanAlsoScrollOverTheBoardToMoveInTheGame => 'Du kannst auch auf dem Brett scrollen, um die Partie durchzugehen.';

  @override
  String get scrollOverComputerVariationsToPreviewThem => 'Bewege den Mauszeiger über Computervarianten, um eine Vorschau zu erhalten.';

  @override
  String get analysisShapesHowTo => 'Drücke Shift+Mausklick oder Rechtsklick, um Kreise und Pfeile auf dem Brett zu zeichnen.';

  @override
  String get letOtherPlayersMessageYou => 'Erlaube anderen Spielern dich zu kontaktieren';

  @override
  String get receiveForumNotifications => 'Benachrichtigungen erhalten, wenn du im Forum erwähnt wirst';

  @override
  String get shareYourInsightsData => 'Deine persönlichen Spielerstatistiken teilen';

  @override
  String get withNobody => 'Mit niemandem';

  @override
  String get withFriends => 'Mit deinen Freunden';

  @override
  String get withEverybody => 'Mit jedem';

  @override
  String get kidMode => 'Kindermodus';

  @override
  String get kidModeIsEnabled => 'Kindermodus ist aktiviert.';

  @override
  String get kidModeExplanation => 'Dies ist eine Sicherheitseinstellung. Im Kindermodus sind alle Kommunikationsmöglichkeiten deaktiviert. Aktiviere diese Option, um Kinder und Schüler vor anderen Internetbenutzern zu schützen.';

  @override
  String inKidModeTheLichessLogoGetsIconX(String param) {
    return 'Im Kindermodus erhält das Lichess-Logo ein $param-Icon, an dem erkennen kannst, dass deine Kinder geschützt sind.';
  }

  @override
  String get askYourChessTeacherAboutLiftingKidMode => 'Dein Konto wird verwaltet. Bitte deinen Schachlehrer den Kindermodus aufzuheben.';

  @override
  String get enableKidMode => 'Kindermodus aktivieren';

  @override
  String get disableKidMode => 'Kindermodus deaktivieren';

  @override
  String get security => 'Sicherheit';

  @override
  String get sessions => 'Sitzungen';

  @override
  String get revokeAllSessions => 'alle Sitzungen beenden';

  @override
  String get playChessEverywhere => 'Spiele Schach überall';

  @override
  String get asFreeAsLichess => 'Frei wie Lichess';

  @override
  String get builtForTheLoveOfChessNotMoney => 'Aus Liebe zum Schach';

  @override
  String get everybodyGetsAllFeaturesForFree => 'Jeder erhält alle Funktionen völlig kostenlos';

  @override
  String get zeroAdvertisement => 'Keine Werbung';

  @override
  String get fullFeatured => 'Keine Einschränkungen';

  @override
  String get phoneAndTablet => 'Handy und Tablet';

  @override
  String get bulletBlitzClassical => 'Bullet, Blitz, Klassisch';

  @override
  String get correspondenceChess => 'Fernschach';

  @override
  String get onlineAndOfflinePlay => 'Spiele online und offline';

  @override
  String get viewTheSolution => 'Lösung ansehen';

  @override
  String get followAndChallengeFriends => 'Folge deinen Freunden und fordere sie heraus';

  @override
  String get gameAnalysis => 'Spielanalyse';

  @override
  String xHostsY(String param1, String param2) {
    return '$param1 hat $param2 erstellt';
  }

  @override
  String xJoinsY(String param1, String param2) {
    return '$param1 ist $param2 beigetreten';
  }

  @override
  String xLikesY(String param1, String param2) {
    return '$param1 gefällt $param2';
  }

  @override
  String get quickPairing => 'Schnelles Spiel';

  @override
  String get lobby => 'Lobby';

  @override
  String get anonymous => 'Anonym';

  @override
  String yourScore(String param) {
    return 'Punktestand: $param';
  }

  @override
  String get language => 'Sprache';

  @override
  String get background => 'Hintergrund';

  @override
  String get light => 'Hell';

  @override
  String get dark => 'Dunkel';

  @override
  String get transparent => 'Transparent';

  @override
  String get deviceTheme => 'Mit Gerät synchronisieren';

  @override
  String get backgroundImageUrl => 'Hintergrundbild-URL:';

  @override
  String get board => 'Brett';

  @override
  String get size => 'Größe';

  @override
  String get opacity => 'Transparenz';

  @override
  String get brightness => 'Helligkeit';

  @override
  String get hue => 'Farbton';

  @override
  String get boardReset => 'Farben auf Standardwerte zurücksetzen';

  @override
  String get pieceSet => 'Figurenstil';

  @override
  String get embedInYourWebsite => 'In Webseite einbetten';

  @override
  String get usernameAlreadyUsed => 'Dieser Benutzername ist bereits vergeben. Bitte versuche es mit einem anderen.';

  @override
  String get usernamePrefixInvalid => 'Der Benutzername muss mit einem Buchstaben beginnen.';

  @override
  String get usernameSuffixInvalid => 'Der Benutzername muss mit einem Buchstaben oder einer Zahl enden.';

  @override
  String get usernameCharsInvalid => 'Der Benutzername darf nur Buchstaben, Zahlen, Unterstriche und Bindestriche beinhalten. Aufeinanderfolgende Unterstriche und Bindestriche sind nicht erlaubt.';

  @override
  String get usernameUnacceptable => 'Dieser Benutzername ist nicht akzeptabel.';

  @override
  String get playChessInStyle => 'Schachspielen mit Style';

  @override
  String get chessBasics => 'Grundlagen';

  @override
  String get coaches => 'Trainer';

  @override
  String get invalidPgn => 'Fehlerhaftes PGN';

  @override
  String get invalidFen => 'FEN ungültig';

  @override
  String get custom => 'Andere Spielzeit';

  @override
  String get notifications => 'Benachrichtigungen';

  @override
  String notificationsX(String param1) {
    return 'Benachrichtigungen: $param1';
  }

  @override
  String perfRatingX(String param) {
    return 'Wertung: $param';
  }

  @override
  String get practiceWithComputer => 'Übe mit dem Computer';

  @override
  String anotherWasX(String param) {
    return 'Auch möglich war $param';
  }

  @override
  String bestWasX(String param) {
    return 'Am besten war $param';
  }

  @override
  String get youBrowsedAway => 'Du hast weg geblättert';

  @override
  String get resumePractice => 'Übung fortsetzen';

  @override
  String get drawByFiftyMoves => 'Die Partie wurde aufgrund der 50-Züge-Regel Remis erklärt.';

  @override
  String get theGameIsADraw => 'Das Spiel ist Remis.';

  @override
  String get computerThinking => 'Computer überlegt ...';

  @override
  String get seeBestMove => 'Zeige den besten Zug';

  @override
  String get hideBestMove => 'Den besten Zug ausblenden';

  @override
  String get getAHint => 'Hinweis anzeigen';

  @override
  String get evaluatingYourMove => 'Zug wird bewertet ...';

  @override
  String get whiteWinsGame => 'Weiß gewinnt';

  @override
  String get blackWinsGame => 'Schwarz gewinnt';

  @override
  String get learnFromYourMistakes => 'Lerne aus deinen Fehlern';

  @override
  String get learnFromThisMistake => 'Lerne aus diesem Fehler';

  @override
  String get skipThisMove => 'Überspringe diesen Zug';

  @override
  String get next => 'Nächster';

  @override
  String xWasPlayed(String param) {
    return '$param wurde gespielt';
  }

  @override
  String get findBetterMoveForWhite => 'Finde einen besseren Zug für Weiß';

  @override
  String get findBetterMoveForBlack => 'Finde einen besseren Zug für Schwarz';

  @override
  String get resumeLearning => 'Mit dem Lernen fortfahren';

  @override
  String get youCanDoBetter => 'Finde eine bessere Variante';

  @override
  String get tryAnotherMoveForWhite => 'Versuche einen anderen Zug für Weiß';

  @override
  String get tryAnotherMoveForBlack => 'Versuche einen anderen Zug für Schwarz';

  @override
  String get solution => 'Lösung';

  @override
  String get waitingForAnalysis => 'Warte auf Analyse';

  @override
  String get noMistakesFoundForWhite => 'Keine Fehler bei Weiß gefunden';

  @override
  String get noMistakesFoundForBlack => 'Keine Fehler bei Schwarz gefunden';

  @override
  String get doneReviewingWhiteMistakes => 'Überprüfen der Fehler von Weiß abgeschlossen';

  @override
  String get doneReviewingBlackMistakes => 'Überprüfen der Fehler von Schwarz abgeschlossen';

  @override
  String get doItAgain => 'Wiederholen';

  @override
  String get reviewWhiteMistakes => 'Fehler von Weiß überprüfen';

  @override
  String get reviewBlackMistakes => 'Fehler von Schwarz überprüfen';

  @override
  String get advantage => 'Vorteil';

  @override
  String get opening => 'Eröffnung';

  @override
  String get middlegame => 'Mittelspiel';

  @override
  String get endgame => 'Endspiel';

  @override
  String get conditionalPremoves => 'Bedingte Vorauszüge';

  @override
  String get addCurrentVariation => 'Aktuelle Variante hinzufügen';

  @override
  String get playVariationToCreateConditionalPremoves => 'Spiele eine Variante, um bedingte Vorauszüge hinzuzufügen';

  @override
  String get noConditionalPremoves => 'Keine bedingten Vorauszüge';

  @override
  String playX(String param) {
    return 'Spiele $param';
  }

  @override
  String get showUnreadLichessMessage => 'Du hast eine private Nachricht von Lichess erhalten.';

  @override
  String get clickHereToReadIt => 'Hier klicken zum Lesen';

  @override
  String get sorry => 'Entschuldigung :(';

  @override
  String get weHadToTimeYouOutForAWhile => 'Wir haben dich mit einer vorübergehenden Spielsperre belegt.';

  @override
  String get why => 'Warum?';

  @override
  String get pleasantChessExperience => 'Wir möchten allen eine möglichst gute Schach-Erfahrung bieten.';

  @override
  String get goodPractice => 'Um dies zu erreichen, müssen wir sicherstellen, dass sich alle Spieler korrekt verhalten.';

  @override
  String get potentialProblem => 'Wir zeigen diese Nachricht an, wenn ein mögliches Problem erkannt wurde.';

  @override
  String get howToAvoidThis => 'Wie kann das verhindert werden?';

  @override
  String get playEveryGame => 'Spiele jedes Spiel, das du beginnst.';

  @override
  String get tryToWin => 'Versuche, jedes Spiel zu gewinnen (oder zumindest ein Remis zu erreichen).';

  @override
  String get resignLostGames => 'Gib verlorene Spiele auf (lasse die Uhr nicht herunterlaufen).';

  @override
  String get temporaryInconvenience => 'Wir entschuldigen uns für die vorübergehenden Unannehmlichkeiten,';

  @override
  String get wishYouGreatGames => 'und wünschen Dir tolle Spiele auf lichess.org.';

  @override
  String get thankYouForReading => 'Vielen Dank für’s Lesen!';

  @override
  String get lifetimeScore => 'Ewiger Spielstand';

  @override
  String get currentMatchScore => 'Aktueller Spielstand';

  @override
  String get agreementAssistance => 'Ich stimme zu, dass ich zu keiner Zeit während meiner Partien Hilfe in Anspruch nehmen werde (durch einen Schachcomputer, Buch, Datenbank oder eine andere Person).';

  @override
  String get agreementNice => 'Ich stimme zu, dass ich anderen Spielern immer respektvoll gegenübertreten werde.';

  @override
  String agreementMultipleAccounts(String param) {
    return 'Ich stimme zu, dass ich nicht mehrere Konten erstellen werde (außer aus den in den $param angegebenen Gründen).';
  }

  @override
  String get agreementPolicy => 'Ich stimme zu, dass ich allen Lichess-Richtlinien folgen werde.';

  @override
  String get searchOrStartNewDiscussion => 'Suche oder beginne eine neue Konversation';

  @override
  String get edit => 'Bearbeiten';

  @override
  String get bullet => 'Bullet';

  @override
  String get blitz => 'Blitz';

  @override
  String get rapid => 'Schnellschach';

  @override
  String get classical => 'Klassisch';

  @override
  String get ultraBulletDesc => 'Wahnsinnig schnelle Spiele: Weniger als 30 Sekunden';

  @override
  String get bulletDesc => 'Sehr schnelle Partien: Weniger als 3 Minuten';

  @override
  String get blitzDesc => 'Schnelle Spiele: 3 bis 8 Minuten';

  @override
  String get rapidDesc => 'Schnellschachpartien: 8 bis 25 Minuten';

  @override
  String get classicalDesc => 'Klassische Partien: 25 Minuten und mehr';

  @override
  String get correspondenceDesc => 'Fernschachspiele: Ein oder mehrere Tage pro Zug';

  @override
  String get puzzleDesc => 'Schachtaktik-Trainer';

  @override
  String get important => 'Wichtig';

  @override
  String yourQuestionMayHaveBeenAnswered(String param1) {
    return 'Deine Frage könnte bereits $param1 beantwortet worden sein';
  }

  @override
  String get inTheFAQ => 'in den F.A.Q.';

  @override
  String toReportSomeoneForCheatingOrBadBehavior(String param1) {
    return 'Um einen Nutzer wegen Betrugs oder schlechten Verhaltens zu melden, $param1';
  }

  @override
  String get useTheReportForm => 'nutze das Meldeformular';

  @override
  String toRequestSupport(String param1) {
    return 'Um Hilfe zu erhalten, $param1';
  }

  @override
  String get tryTheContactPage => 'probiere die Kontaktseite aus';

  @override
  String makeSureToRead(String param1) {
    return 'Bitte lies unbedingt: $param1';
  }

  @override
  String get theForumEtiquette => 'die Forumsetikette';

  @override
  String get thisTopicIsArchived => 'Dieses Thema wurde archiviert und kann nicht mehr beantwortet werden.';

  @override
  String joinTheTeamXToPost(String param1) {
    return 'Tritt $param1 bei, um in diesem Forum schreiben zu können';
  }

  @override
  String teamNamedX(String param1) {
    return '$param1 Team';
  }

  @override
  String get youCannotPostYetPlaySomeGames => 'Du kannst noch nichts in den Foren schreiben. Spiel ein paar Partien!';

  @override
  String get subscribe => 'Abonnieren';

  @override
  String get unsubscribe => 'Abonnement beenden';

  @override
  String mentionedYouInX(String param1) {
    return 'erwähnte dich in \"$param1\".';
  }

  @override
  String xMentionedYouInY(String param1, String param2) {
    return '$param1 erwähnte dich in \"$param2\".';
  }

  @override
  String invitedYouToX(String param1) {
    return 'hat dich zu \"$param1\" eingeladen.';
  }

  @override
  String xInvitedYouToY(String param1, String param2) {
    return '$param1 hat dich zu \"$param2\" eingeladen.';
  }

  @override
  String get youAreNowPartOfTeam => 'Du bist nun Teammitglied.';

  @override
  String youHaveJoinedTeamX(String param1) {
    return 'Du bist \"$param1\" beigetreten.';
  }

  @override
  String get someoneYouReportedWasBanned => 'Jemand, den du gemeldet hast, wurde gebannt';

  @override
  String get congratsYouWon => 'Glückwunsch, du hast gewonnen!';

  @override
  String gameVsX(String param1) {
    return 'Partie gegen $param1';
  }

  @override
  String resVsX(String param1, String param2) {
    return '$param1 gegen $param2';
  }

  @override
  String get lostAgainstTOSViolator => 'Du hast Elo an jemanden verloren, der gegen die Lichess-AGB verstoßen hat';

  @override
  String refundXpointsTimeControlY(String param1, String param2) {
    return 'Rückerstattung: $param1 $param2 Wertungspunkte.';
  }

  @override
  String get timeAlmostUp => 'Deine Zeit ist fast abgelaufen!';

  @override
  String get clickToRevealEmailAddress => '[Klicke, um die E-Mail-Adresse anzuzeigen]';

  @override
  String get download => 'Herunterladen';

  @override
  String get coachManager => 'Trainerverwaltung';

  @override
  String get streamerManager => 'Streamerverwaltung';

  @override
  String get cancelTournament => 'Turnier abbrechen';

  @override
  String get tournDescription => 'Turnierbeschreibung';

  @override
  String get tournDescriptionHelp => 'Etwas Besonderes, was du den Teilnehmern mitteilen möchtest? Versuche es kurz zu halten. Markdown-Links sind verfügbar: [name](https://url)';

  @override
  String get ratedFormHelp => 'Partien sind gewertet\nund beeinflussen die Wertungszahl der Spieler';

  @override
  String get onlyMembersOfTeam => 'Nur Teammitglieder';

  @override
  String get noRestriction => 'Keine Einschränkung';

  @override
  String get minimumRatedGames => 'Mindestanzahl gewerteter Partien';

  @override
  String get minimumRating => 'Niedrigste Wertungszahl';

  @override
  String get maximumWeeklyRating => 'Höchste Wertungszahl in dieser Woche';

  @override
  String positionInputHelp(String param) {
    return 'Füge eine gültige FEN ein, um jede Partie aus einer gegebenen Stellung zu beginnen.\nDas funktioniert nur für Standardspiele, nicht für Varianten.\nDu kannst den $param verwenden, um eine FEN-Stellung zu generieren und diese dann hier einfügen.\nLeer lassen, um Partien von der normalen Ausgangsstellung aus zu starten.';
  }

  @override
  String get cancelSimul => 'Die Simultan-Veranstaltung abbrechen';

  @override
  String get simulHostcolor => 'Farbe des Gastgebers für jede Partie';

  @override
  String get estimatedStart => 'Voraussichtliche Startzeit';

  @override
  String simulFeatured(String param) {
    return 'Auf $param zeigen';
  }

  @override
  String simulFeaturedHelp(String param) {
    return 'Zeige allen auf $param deine Simultan-Veranstaltung. Für private Simultan-Veranstaltungen deaktivieren.';
  }

  @override
  String get simulDescription => 'Simultan Beschreibung';

  @override
  String get simulDescriptionHelp => 'Möchtest du den Teilnehmern etwas mitteilen?';

  @override
  String markdownAvailable(String param) {
    return '$param ist für erweiterte Formatierung verfügbar.';
  }

  @override
  String get embedsAvailable => 'Füge eine Partie-URL oder eine Studienkapitel-URL ein, um sie einzubetten.';

  @override
  String get inYourLocalTimezone => 'In deiner eigenen lokalen Zeitzone';

  @override
  String get tournChat => 'Turnierchat';

  @override
  String get noChat => 'Kein Chat';

  @override
  String get onlyTeamLeaders => 'Nur Teamleiter';

  @override
  String get onlyTeamMembers => 'Nur Teammitglieder';

  @override
  String get navigateMoveTree => 'Durch den Zugbaum navigieren';

  @override
  String get mouseTricks => 'Maus-Tricks';

  @override
  String get toggleLocalAnalysis => 'Lokale Computeranalyse aktivieren/deaktivieren';

  @override
  String get toggleAllAnalysis => 'Alle Computeranalysen aktivieren/deaktivieren';

  @override
  String get playComputerMove => 'Spiele den besten Computerzug';

  @override
  String get analysisOptions => 'Analyseoptionen';

  @override
  String get focusChat => 'Chat-Eingabefeld fokussieren';

  @override
  String get showHelpDialog => 'Diesen Hilfedialog anzeigen';

  @override
  String get reopenYourAccount => 'Wiedereröffnung deines Kontos';

  @override
  String get closedAccountChangedMind => 'Wenn du dein Konto geschlossen, aber danach deine Meinung geändert hast, hast du eine Chance, dein Konto zurückzuerhalten.';

  @override
  String get onlyWorksOnce => 'Das funktioniert nur einmal.';

  @override
  String get cantDoThisTwice => 'Wenn du dein Konto ein zweites Mal schließt, wird es keine Möglichkeit geben, es wiederherzustellen.';

  @override
  String get emailAssociatedToaccount => 'E-Mail-Adresse deines Kontos';

  @override
  String get sentEmailWithLink => 'Wir haben dir eine E-Mail mit einem Link geschickt.';

  @override
  String get tournamentEntryCode => 'Turnierbeitrittscode';

  @override
  String get hangOn => 'Moment mal!';

  @override
  String gameInProgress(String param) {
    return 'Du hast noch eine laufende Partie mit $param.';
  }

  @override
  String get abortTheGame => 'Partie abbrechen';

  @override
  String get resignTheGame => 'Partie aufgeben';

  @override
  String get youCantStartNewGame => 'Du kannst keine neue Partie starten, bevor diese beendet ist.';

  @override
  String get since => 'Seit';

  @override
  String get until => 'Bis';

  @override
  String get lichessDbExplanation => 'Aus gewerteten Partien aller Lichess-Spieler';

  @override
  String get switchSides => 'andere Farbe';

  @override
  String get closingAccountWithdrawAppeal => 'Dein Benutzerkonto zu schließen wird auch deinen Einspruch zurückziehen';

  @override
  String get ourEventTips => 'Unsere Tipps für die Organisation von Veranstaltungen';

  @override
  String get instructions => 'Anleitung';

  @override
  String get showMeEverything => 'Alles zeigen';

  @override
  String get lichessPatronInfo => 'Lichess ist eine Wohltätigkeitsorganisation und eine völlig kostenlose/freie Open-Source-Software.\nAlle Betriebskosten, Entwicklung und Inhalte werden ausschließlich durch Benutzerspenden finanziert.';

  @override
  String get nothingToSeeHere => 'Im Moment gibt es hier nichts zu sehen.';

  @override
  String opponentLeftCounter(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Dein Gegner hat die Partie verlassen. Du kannst in $count Sekunden den Sieg beanspruchen.',
      one: 'Dein Gegner hat die Partie verlassen. Du kannst in $count Sekunde den Sieg beanspruchen.',
    );
    return '$_temp0';
  }

  @override
  String mateInXHalfMoves(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Matt in $count Halbzügen',
      one: 'Matt in $count Halbzug',
    );
    return '$_temp0';
  }

  @override
  String nbBlunders(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count grobe Patzer',
      one: '$count grober Patzer',
    );
    return '$_temp0';
  }

  @override
  String nbMistakes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Fehler',
      one: '$count Fehler',
    );
    return '$_temp0';
  }

  @override
  String nbInaccuracies(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Ungenauigkeiten',
      one: '$count Ungenauigkeit',
    );
    return '$_temp0';
  }

  @override
  String nbPlayers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Spieler',
      one: '$count Spieler',
    );
    return '$_temp0';
  }

  @override
  String nbGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Partien',
      one: '$count Partie',
    );
    return '$_temp0';
  }

  @override
  String ratingXOverYGames(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count-Wertung aus $param2 Partien',
      one: '$count-Wertung aus $param2 Partien',
    );
    return '$_temp0';
  }

  @override
  String nbBookmarks(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Lesezeichen',
      one: '$count Lesezeichen',
    );
    return '$_temp0';
  }

  @override
  String nbDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Tage',
      one: '$count Tag',
    );
    return '$_temp0';
  }

  @override
  String nbHours(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Stunden',
      one: '$count Stunde',
    );
    return '$_temp0';
  }

  @override
  String nbMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Minuten',
      one: '$count Minute',
    );
    return '$_temp0';
  }

  @override
  String rankIsUpdatedEveryNbMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Platzierung wird alle $count Minuten aktualisiert',
      one: 'Platzierung wird minütlich aktualisiert',
    );
    return '$_temp0';
  }

  @override
  String nbPuzzles(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Aufgaben',
      one: '$count Aufgabe',
    );
    return '$_temp0';
  }

  @override
  String nbGamesWithYou(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Partien mit dir',
      one: '$count Partie mit dir',
    );
    return '$_temp0';
  }

  @override
  String nbRated(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count gewertet',
      one: '$count gewertet',
    );
    return '$_temp0';
  }

  @override
  String nbWins(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Siege',
      one: '$count Sieg',
    );
    return '$_temp0';
  }

  @override
  String nbLosses(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Niederlagen',
      one: '$count Niederlage',
    );
    return '$_temp0';
  }

  @override
  String nbDraws(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Remis',
      one: '$count Remis',
    );
    return '$_temp0';
  }

  @override
  String nbPlaying(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count laufende Partien',
      one: '$count laufende Partie',
    );
    return '$_temp0';
  }

  @override
  String giveNbSeconds(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Dem Gegner $count Sekunden geben',
      one: 'Dem Gegner $count Sekunde geben',
    );
    return '$_temp0';
  }

  @override
  String nbTournamentPoints(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Turnierpunkte',
      one: '$count Turnierpunkt',
    );
    return '$_temp0';
  }

  @override
  String nbStudies(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Studien',
      one: '$count Studie',
    );
    return '$_temp0';
  }

  @override
  String nbSimuls(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Simultanpartien',
      one: '$count Simultanschach',
    );
    return '$_temp0';
  }

  @override
  String moreThanNbRatedGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '≥ $count gewertete Spiele',
      one: '≥ $count gewertetes Spiel',
    );
    return '$_temp0';
  }

  @override
  String moreThanNbPerfRatedGames(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '≥ $count gewertete $param2 Spiele',
      one: '≥ $count gewertetes $param2 Spiel',
    );
    return '$_temp0';
  }

  @override
  String needNbMorePerfGames(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Du musst noch $count gewertete Partien mehr $param2 spielen',
      one: 'Du musst noch $count gewertete Partie mehr $param2 spielen',
    );
    return '$_temp0';
  }

  @override
  String needNbMoreGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Du musst noch $count gewertete Spiele mehr spielen',
      one: 'Du musst noch $count gewertetes Spiel mehr spielen',
    );
    return '$_temp0';
  }

  @override
  String nbImportedGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count importierte Partien',
      one: '$count importierte Partie',
    );
    return '$_temp0';
  }

  @override
  String nbFriendsOnline(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Freunde online',
      one: '$count Freund online',
    );
    return '$_temp0';
  }

  @override
  String nbFollowers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Follower',
      one: '$count Follower',
    );
    return '$_temp0';
  }

  @override
  String nbFollowing(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count folgend',
      one: '$count folgend',
    );
    return '$_temp0';
  }

  @override
  String lessThanNbMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Weniger als $count Minuten',
      one: 'Weniger als $count Minute',
    );
    return '$_temp0';
  }

  @override
  String nbGamesInPlay(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count laufende Partien',
      one: '$count laufende Partie',
    );
    return '$_temp0';
  }

  @override
  String maximumNbCharacters(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Höchstens $count Zeichen.',
      one: 'Höchstens $count Zeichen.',
    );
    return '$_temp0';
  }

  @override
  String blocks(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count gesperrte Spieler',
      one: '$count gesperrter Spieler',
    );
    return '$_temp0';
  }

  @override
  String nbForumPosts(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Forenbeiträge',
      one: '$count Forenbeitrag',
    );
    return '$_temp0';
  }

  @override
  String nbPerfTypePlayersThisWeek(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count $param2 Spieler diese Woche.',
      one: '$count $param2 Spieler diese Woche.',
    );
    return '$_temp0';
  }

  @override
  String availableInNbLanguages(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Verfügbar in $count Sprachen!',
      one: 'Verfügbar in $count Sprache!',
    );
    return '$_temp0';
  }

  @override
  String nbSecondsToPlayTheFirstMove(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Sekunden, um den ersten Zug zu machen',
      one: '$count Sekunde, um den ersten Zug zu machen',
    );
    return '$_temp0';
  }

  @override
  String nbSeconds(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Sekunden',
      one: '$count Sekunde',
    );
    return '$_temp0';
  }

  @override
  String andSaveNbPremoveLines(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'und speichere $count Varianten im Voraus',
      one: 'und speichere $count Variante im Voraus',
    );
    return '$_temp0';
  }

  @override
  String get stormMoveToStart => 'Ziehe, um zu beginnen';

  @override
  String get stormYouPlayTheWhitePiecesInAllPuzzles => 'Du spielst in allen Aufgaben mit den weißen Figuren';

  @override
  String get stormYouPlayTheBlackPiecesInAllPuzzles => 'Du spielst in allen Aufgaben mit den schwarzen Figuren';

  @override
  String get stormPuzzlesSolved => 'Aufgaben gelöst';

  @override
  String get stormNewDailyHighscore => 'Neuer Tagesrekord!';

  @override
  String get stormNewWeeklyHighscore => 'Neuer Wochenrekord!';

  @override
  String get stormNewMonthlyHighscore => 'Neuer Monatsrekord!';

  @override
  String get stormNewAllTimeHighscore => 'Neuer Allzeit-Rekord!';

  @override
  String stormPreviousHighscoreWasX(String param) {
    return 'Dein vorheriger Rekord war $param';
  }

  @override
  String get stormPlayAgain => 'Erneut spielen';

  @override
  String stormHighscoreX(String param) {
    return 'Rekord: $param';
  }

  @override
  String get stormScore => 'Punktestand';

  @override
  String get stormMoves => 'Züge';

  @override
  String get stormAccuracy => 'Genauigkeit';

  @override
  String get stormCombo => 'Combo';

  @override
  String get stormTime => 'Zeit';

  @override
  String get stormTimePerMove => 'Zeit pro Zug';

  @override
  String get stormHighestSolved => 'Schwierigste gelöste Aufgabe';

  @override
  String get stormPuzzlesPlayed => 'Gespielte Aufgaben';

  @override
  String get stormNewRun => 'Neuer Durchlauf (drücke: Leertaste)';

  @override
  String get stormEndRun => 'Beende den Durchlauf (drücke: Eingabetaste)';

  @override
  String get stormHighscores => 'Rekorde';

  @override
  String get stormViewBestRuns => 'Beste Durchläufe anzeigen';

  @override
  String get stormBestRunOfDay => 'Bester Durchlauf des Tages';

  @override
  String get stormRuns => 'Durchläufe';

  @override
  String get stormGetReady => 'Mach dich bereit!';

  @override
  String get stormWaitingForMorePlayers => 'Warte auf weitere Teilnehmer...';

  @override
  String get stormRaceComplete => 'Rennen abgeschlossen!';

  @override
  String get stormSpectating => 'Zuschauen';

  @override
  String get stormJoinTheRace => 'Nimm am Rennen teil!';

  @override
  String get stormStartTheRace => 'Starte das Rennen';

  @override
  String stormYourRankX(String param) {
    return 'Deine Platzierung: $param';
  }

  @override
  String get stormWaitForRematch => 'Warte auf ein neues Rennen';

  @override
  String get stormNextRace => 'Nächstes Rennen';

  @override
  String get stormJoinRematch => 'Am nächsten Rennen teilnehmen';

  @override
  String get stormWaitingToStart => 'Warte auf den Start';

  @override
  String get stormCreateNewGame => 'Ein neues Rennen erstellen';

  @override
  String get stormJoinPublicRace => 'An einem öffentlichen Rennen teilnehmen';

  @override
  String get stormRaceYourFriends => 'Spiele ein Rennen mit deinen Freunden';

  @override
  String get stormSkip => 'überspringen';

  @override
  String get stormSkipHelp => 'Du kannst einen Zug pro Rennen überspringen:';

  @override
  String get stormSkipExplanation => 'Überspringe diesen Zug, um deine Kombination beizubehalten! Du kannst das nur einmal pro Rennen machen.';

  @override
  String get stormFailedPuzzles => 'Fehlgeschlagene Aufgaben';

  @override
  String get stormSlowPuzzles => 'Langsame Aufgaben';

  @override
  String get stormSkippedPuzzle => 'Übersprungene Aufgabe';

  @override
  String get stormThisWeek => 'Diese Woche';

  @override
  String get stormThisMonth => 'Dieser Monat';

  @override
  String get stormAllTime => 'Insgesamt';

  @override
  String get stormClickToReload => 'Klicke, um neu zu laden';

  @override
  String get stormThisRunHasExpired => 'Dieser Durchgang ist abgelaufen!';

  @override
  String get stormThisRunWasOpenedInAnotherTab => 'Dieser Durchgang wurde in einem anderen Fenster geöffnet!';

  @override
  String stormXRuns(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Durchläufe',
      one: '1 Durchlauf',
    );
    return '$_temp0';
  }

  @override
  String stormPlayedNbRunsOfPuzzleStorm(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Hat $count Durchläufe von $param2 gespielt',
      one: 'Hat einen Durchlauf von $param2 gespielt',
    );
    return '$_temp0';
  }

  @override
  String get streamerLichessStreamers => 'Lichess Streamer';

  @override
  String get studyShareAndExport => 'Teilen und exportieren';

  @override
  String get studyStart => 'Start';
}
