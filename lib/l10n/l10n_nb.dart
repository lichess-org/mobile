import 'package:intl/intl.dart' as intl;

import 'l10n.dart';

/// The translations for Norwegian Bokmål (`nb`).
class AppLocalizationsNb extends AppLocalizations {
  AppLocalizationsNb([String locale = 'nb']) : super(locale);

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
  String get activityActivity => 'Aktivitet';

  @override
  String get activityHostedALiveStream => 'Startet en direktestrøm';

  @override
  String activityRankedInSwissTournament(String param1, String param2) {
    return 'Ble nummer $param1 i $param2';
  }

  @override
  String get activitySignedUp => 'Er registrert hos Lichess';

  @override
  String activitySupportedNbMonths(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Har støttet lichess.org i $count måneder som $param2',
      one: 'Har støttet lichess.org i $count måned som $param2',
    );
    return '$_temp0';
  }

  @override
  String activityPracticedNbPositions(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Har trent $count stillinger på $param2',
      one: 'Praktiserte $count stilling på $param2',
    );
    return '$_temp0';
  }

  @override
  String activitySolvedNbPuzzles(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Har løst $count sjakknøtter',
      one: 'Har løst $count sjakknøtt',
    );
    return '$_temp0';
  }

  @override
  String activityPlayedNbGames(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Har spilt $count $param2-partier',
      one: 'Har spilt $count $param2-parti',
    );
    return '$_temp0';
  }

  @override
  String activityPostedNbMessages(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Har skrevet $count innlegg i $param2',
      one: 'Har skrevet $count innlegg i $param2',
    );
    return '$_temp0';
  }

  @override
  String activityPlayedNbMoves(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Har spilt $count trekk',
      one: 'Har spilt $count trekk',
    );
    return '$_temp0';
  }

  @override
  String activityInNbCorrespondenceGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'i $count fjernsjakkpartier',
      one: 'i $count fjernsjakkparti',
    );
    return '$_temp0';
  }

  @override
  String activityCompletedNbGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Har spilt ferdig $count fjernsjakkpartier',
      one: 'Har spilt ferdig $count fjernsjakkparti',
    );
    return '$_temp0';
  }

  @override
  String activityFollowedNbPlayers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Følger $count spillere',
      one: 'Følger $count spiller',
    );
    return '$_temp0';
  }

  @override
  String activityGainedNbFollowers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Har $count nye følgere',
      one: 'Har $count ny følger',
    );
    return '$_temp0';
  }

  @override
  String activityHostedNbSimuls(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Har vært vertskap for $count simultanoppvisninger',
      one: 'Har vært vertskap for $count simultanoppvisning',
    );
    return '$_temp0';
  }

  @override
  String activityJoinedNbSimuls(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Har deltatt i $count simultanoppvisninger',
      one: 'Har deltatt i $count simultanoppvisning',
    );
    return '$_temp0';
  }

  @override
  String activityCreatedNbStudies(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Har laget $count nye studier',
      one: 'Har laget $count ny studie',
    );
    return '$_temp0';
  }

  @override
  String activityCompetedInNbTournaments(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Har deltatt i $count arenaturneringer',
      one: 'Har deltatt i $count arenaturnering',
    );
    return '$_temp0';
  }

  @override
  String activityRankedInTournament(int count, String param2, String param3, String param4) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Ble nummer $count (øverste $param2%) med $param3 partier i $param4',
      one: 'Ble nummer $count (øverste $param2%) med $param3 parti i $param4',
    );
    return '$_temp0';
  }

  @override
  String activityCompetedInNbSwissTournaments(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Har deltatt i $count sveitserturneringer',
      one: 'Har deltatt i $count sveitserturnering',
    );
    return '$_temp0';
  }

  @override
  String activityJoinedNbTeams(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Er medlem av $count lag',
      one: 'Er medlem av $count lag',
    );
    return '$_temp0';
  }

  @override
  String get broadcastBroadcasts => 'Overføringer';

  @override
  String get broadcastLiveBroadcasts => 'Direkteoverføringer av turneringer';

  @override
  String challengeChallengesX(String param1) {
    return 'Utfordringer: $param1';
  }

  @override
  String get challengeChallengeToPlay => 'Utfordre til et parti';

  @override
  String get challengeChallengeDeclined => 'Utfordring avslått';

  @override
  String get challengeChallengeAccepted => 'Utfordring godtatt!';

  @override
  String get challengeChallengeCanceled => 'Utfordring avbrutt.';

  @override
  String get challengeRegisterToSendChallenges => 'Du må registrere deg for å kunne utfordre denne brukeren.';

  @override
  String challengeYouCannotChallengeX(String param) {
    return 'Du kan ikke utfordre $param.';
  }

  @override
  String challengeXDoesNotAcceptChallenges(String param) {
    return '$param godtar ikke utfordringer.';
  }

  @override
  String challengeYourXRatingIsTooFarFromY(String param1, String param2) {
    return 'Ratingen din i $param1 er for langt unna $param2.';
  }

  @override
  String challengeCannotChallengeDueToProvisionalXRating(String param) {
    return 'Kan ikke utfordre på grunn av provisorisk rating i $param.';
  }

  @override
  String challengeXOnlyAcceptsChallengesFromFriends(String param) {
    return '$param godtar bare utfordringer fra venner.';
  }

  @override
  String get challengeDeclineGeneric => 'Jeg godtar ikke utfordringer for øyeblikket.';

  @override
  String get challengeDeclineLater => 'Det passer ikke akkurat nå, spør senere.';

  @override
  String get challengeDeclineTooFast => 'Denne tidskontrollen er for rask for meg, send en ny utfordring til et tregere parti.';

  @override
  String get challengeDeclineTooSlow => 'Denne tidskontrollen er for treg for meg, send en ny utfordring til et raskere parti.';

  @override
  String get challengeDeclineTimeControl => 'Jeg godtar ikke utfordringer med denne tidskontrollen.';

  @override
  String get challengeDeclineRated => 'Send meg en utfordring til et ratet parti i stedet.';

  @override
  String get challengeDeclineCasual => 'Send meg en utfordring til et uformelt parti i stedet.';

  @override
  String get challengeDeclineStandard => 'Jeg godtar ikke utfordringer til varianter for øyeblikket.';

  @override
  String get challengeDeclineVariant => 'Jeg ønsker ikke å spille denne varianten for øyeblikket.';

  @override
  String get challengeDeclineNoBot => 'Jeg godtar ikke utfordringer fra boter.';

  @override
  String get challengeDeclineOnlyBot => 'Jeg godtar bare utfordringer fra boter.';

  @override
  String get challengeInviteLichessUser => 'Eller inviter en Lichess-bruker:';

  @override
  String get contactContact => 'Kontakt';

  @override
  String get contactContactLichess => 'Ta kontakt med Lichess';

  @override
  String get patronDonate => 'Bidra';

  @override
  String get patronLichessPatron => 'Lichess-patron';

  @override
  String perfStatPerfStats(String param) {
    return '$param-statistikk';
  }

  @override
  String get perfStatViewTheGames => 'Vis partiene';

  @override
  String get perfStatProvisional => 'provisorisk';

  @override
  String get perfStatNotEnoughRatedGames => 'For få ratede partier til å kunne beregne en stabil rating.';

  @override
  String perfStatProgressOverLastXGames(String param) {
    return 'Forandring over de siste $param partiene:';
  }

  @override
  String perfStatRatingDeviation(String param) {
    return 'Ratingavvik: $param.';
  }

  @override
  String perfStatRatingDeviationTooltip(String param1, String param2, String param3) {
    return 'Lavere verdi betyr at ratingen er mer stabil. Over $param1 er ratingen provisorisk. For å komme på rangeringslistene må verdien være under $param2 (standard sjakk) eller $param3 (varianter).';
  }

  @override
  String get perfStatTotalGames => 'Totalt antall partier';

  @override
  String get perfStatRatedGames => 'Ratede partier';

  @override
  String get perfStatTournamentGames => 'Turneringspartier';

  @override
  String get perfStatBerserkedGames => 'Berserkpartier';

  @override
  String get perfStatTimeSpentPlaying => 'Tid brukt på å spille';

  @override
  String get perfStatAverageOpponent => 'Gjennomsnittlig motstanderrating';

  @override
  String get perfStatVictories => 'Seire';

  @override
  String get perfStatDefeats => 'Tap';

  @override
  String get perfStatDisconnections => 'Frakoblinger';

  @override
  String get perfStatNotEnoughGames => 'For få spilte partier';

  @override
  String perfStatHighestRating(String param) {
    return 'Høyeste oppnådde rating: $param';
  }

  @override
  String perfStatLowestRating(String param) {
    return 'Laveste oppnådde rating: $param';
  }

  @override
  String perfStatFromXToY(String param1, String param2) {
    return 'fra $param1 til $param2';
  }

  @override
  String get perfStatWinningStreak => 'Seiersrekke';

  @override
  String get perfStatLosingStreak => 'Tapsrekke';

  @override
  String perfStatLongestStreak(String param) {
    return 'Lengste rekke: $param';
  }

  @override
  String perfStatCurrentStreak(String param) {
    return 'Nåværende rekke: $param';
  }

  @override
  String get perfStatBestRated => 'Beste seire';

  @override
  String get perfStatGamesInARow => 'Partier spilt på rad';

  @override
  String get perfStatLessThanOneHour => 'Mindre enn én time mellom partiene';

  @override
  String get perfStatMaxTimePlaying => 'Maks tid brukt på å spille';

  @override
  String get perfStatNow => 'nå';

  @override
  String get preferencesPreferences => 'Innstillinger';

  @override
  String get preferencesDisplay => 'Visning';

  @override
  String get preferencesPrivacy => 'Personvern';

  @override
  String get preferencesNotifications => 'Varsler';

  @override
  String get preferencesPieceAnimation => 'Brikke animasjon';

  @override
  String get preferencesMaterialDifference => 'Materiell forskjell';

  @override
  String get preferencesBoardHighlights => 'Feltmarkering (siste trekk og sjakk)';

  @override
  String get preferencesPieceDestinations => 'Brikkedestinasjoner (gyldige trekk og forhåndstrekk)';

  @override
  String get preferencesBoardCoordinates => 'Brettkoordinater (A-H, 1-8)';

  @override
  String get preferencesMoveListWhilePlaying => 'Notasjonsliste mens du spiller';

  @override
  String get preferencesPgnPieceNotation => 'Notasjon';

  @override
  String get preferencesChessPieceSymbol => 'Brikkesymbol';

  @override
  String get preferencesPgnLetter => 'Bokstav (K, Q, R, B, N)';

  @override
  String get preferencesZenMode => 'Zen-modus';

  @override
  String get preferencesShowPlayerRatings => 'Vis spillerratinger';

  @override
  String get preferencesShowFlairs => 'Vis spillerflairer';

  @override
  String get preferencesExplainShowPlayerRatings => 'Denne innstillingen skjuler alle ratingene på nettstedet, slik at du kan fokusere på sjakken. Du kan fortsatt spille ratede partier.';

  @override
  String get preferencesDisplayBoardResizeHandle => 'Vis håndtak for brettstørrelse';

  @override
  String get preferencesOnlyOnInitialPosition => 'Kun for utgangsstillingen';

  @override
  String get preferencesInGameOnly => 'Bare under partier';

  @override
  String get preferencesChessClock => 'Sjakkur';

  @override
  String get preferencesTenthsOfSeconds => 'Tidels sekunder';

  @override
  String get preferencesWhenTimeRemainingLessThanTenSeconds => 'Når gjenværende tid < 10 sekunder';

  @override
  String get preferencesHorizontalGreenProgressBars => 'Horisontal grønn progresjonslinje';

  @override
  String get preferencesSoundWhenTimeGetsCritical => 'Lyd når tiden blir kritisk';

  @override
  String get preferencesGiveMoreTime => 'Gi mer tid';

  @override
  String get preferencesGameBehavior => 'Spilloppførsel';

  @override
  String get preferencesHowDoYouMovePieces => 'Hvordan flytte brikker?';

  @override
  String get preferencesClickTwoSquares => 'Klikk to felt';

  @override
  String get preferencesDragPiece => 'Dra brikke';

  @override
  String get preferencesBothClicksAndDrag => 'Begge';

  @override
  String get preferencesPremovesPlayingDuringOpponentTurn => 'Forhåndstrekk (gjør trekk når det er motstanders trekk)';

  @override
  String get preferencesTakebacksWithOpponentApproval => 'Angre trekk (med motstanders godkjennelse)';

  @override
  String get preferencesInCasualGamesOnly => 'Bare for uformelle partier';

  @override
  String get preferencesPromoteToQueenAutomatically => 'Forvandle til dronning automatisk';

  @override
  String get preferencesExplainPromoteToQueenAutomatically => 'Hold <ctrl>-tasten nede under bondeforvandlingen for å unngå auto-dronning';

  @override
  String get preferencesWhenPremoving => 'Ved bruk av førtrekk';

  @override
  String get preferencesClaimDrawOnThreefoldRepetitionAutomatically => 'Krev remis ved trekkgjentakelse automatisk';

  @override
  String get preferencesWhenTimeRemainingLessThanThirtySeconds => 'Når gjenværende tid < 30 sekunder';

  @override
  String get preferencesMoveConfirmation => 'Trekkbekreftelse';

  @override
  String get preferencesExplainCanThenBeTemporarilyDisabled => 'Kan skrus av under partiene med menyen på brettet';

  @override
  String get preferencesInCorrespondenceGames => 'I fjernsjakk';

  @override
  String get preferencesCorrespondenceAndUnlimited => 'Korrespondanse og ubegrenset';

  @override
  String get preferencesConfirmResignationAndDrawOffers => 'Bekreft når du gir opp eller tilbyr remis';

  @override
  String get preferencesCastleByMovingTheKingTwoSquaresOrOntoTheRook => 'Metode for å rokere';

  @override
  String get preferencesCastleByMovingTwoSquares => 'Flytt kongen to felter';

  @override
  String get preferencesCastleByMovingOntoTheRook => 'Sett kongen på tårnet';

  @override
  String get preferencesInputMovesWithTheKeyboard => 'Skriv trekk med tastaturet';

  @override
  String get preferencesInputMovesWithVoice => 'Gi trekk med stemmen';

  @override
  String get preferencesSnapArrowsToValidMoves => 'Piler viser gyldige trekk';

  @override
  String get preferencesSayGgWpAfterLosingOrDrawing => 'Si «Good game, well played» («Godt parti, bra spilt») etter tap eller remis';

  @override
  String get preferencesYourPreferencesHaveBeenSaved => 'Innstillingene dine er lagret.';

  @override
  String get preferencesScrollOnTheBoardToReplayMoves => 'Bruk musehjulet for å spille av trekk';

  @override
  String get preferencesCorrespondenceEmailNotification => 'Daglig oversikt over fjernsjakkpartiene dine tilsendt på e-post';

  @override
  String get preferencesNotifyStreamStart => 'Strømmer begynner å strømme';

  @override
  String get preferencesNotifyInboxMsg => 'Ny melding i innboksen';

  @override
  String get preferencesNotifyForumMention => 'Forumkommentar nevner deg';

  @override
  String get preferencesNotifyInvitedStudy => 'Invitasjon til studie';

  @override
  String get preferencesNotifyGameEvent => 'Oppdateringer for fjernsjakkpartier';

  @override
  String get preferencesNotifyChallenge => 'Utfordringer';

  @override
  String get preferencesNotifyTournamentSoon => 'Turnering starter snart';

  @override
  String get preferencesNotifyTimeAlarm => 'Fjernsjakkur i ferd med å løpe ut';

  @override
  String get preferencesNotifyBell => 'Bjellevarsel innenfor Lichess';

  @override
  String get preferencesNotifyPush => 'Enhetsvarsel utenfor Lichess';

  @override
  String get preferencesNotifyWeb => 'Nettleser';

  @override
  String get preferencesNotifyDevice => 'Enhet';

  @override
  String get preferencesBellNotificationSound => 'Bjellevarsel med lyd';

  @override
  String get puzzlePuzzles => 'Sjakknøtter';

  @override
  String get puzzlePuzzleThemes => 'Temaer for sjakknøtter';

  @override
  String get puzzleRecommended => 'Anbefalt';

  @override
  String get puzzlePhases => 'Faser';

  @override
  String get puzzleMotifs => 'Motiver';

  @override
  String get puzzleAdvanced => 'For viderekomne';

  @override
  String get puzzleLengths => 'Varighet';

  @override
  String get puzzleMates => 'Mattstillinger';

  @override
  String get puzzleGoals => 'Mål';

  @override
  String get puzzleOrigin => 'Opphav';

  @override
  String get puzzleSpecialMoves => 'Spesialtrekk';

  @override
  String get puzzleDidYouLikeThisPuzzle => 'Likte du denne sjakknøtten?';

  @override
  String get puzzleVoteToLoadNextOne => 'Stem for å laste den neste!';

  @override
  String get puzzleUpVote => 'Bra sjakknøtt';

  @override
  String get puzzleDownVote => 'Mindre bra sjakknøtt';

  @override
  String get puzzleYourPuzzleRatingWillNotChange => 'Ratingen din for sjakknøtter vil ikke endre seg. Husk at sjakknøtter ikke er en konkurranse. Ratingen din hjelper til med å finne de sjakknøttene som passer ferdighetene dine.';

  @override
  String get puzzleFindTheBestMoveForWhite => 'Finn det beste trekket for hvit.';

  @override
  String get puzzleFindTheBestMoveForBlack => 'Finn det beste trekket for svart.';

  @override
  String get puzzleToGetPersonalizedPuzzles => 'For tilpassede sjakknøtter:';

  @override
  String puzzlePuzzleId(String param) {
    return 'Sjakknøtt $param';
  }

  @override
  String get puzzlePuzzleOfTheDay => 'Dagens nøtt';

  @override
  String get puzzleDailyPuzzle => 'Dagens nøtt';

  @override
  String get puzzleClickToSolve => 'Klikk for å løse';

  @override
  String get puzzleGoodMove => 'Bra trekk';

  @override
  String get puzzleBestMove => 'Beste trekk!';

  @override
  String get puzzleKeepGoing => 'Fortsett…';

  @override
  String get puzzlePuzzleSuccess => 'Korrekt!';

  @override
  String get puzzlePuzzleComplete => 'Ferdigknekt nøtt!';

  @override
  String get puzzleByOpenings => 'Etter åpninger';

  @override
  String get puzzlePuzzlesByOpenings => 'Sjakknøtter etter åpninger';

  @override
  String get puzzleOpeningsYouPlayedTheMost => 'Åpningene du spiller mest av i ratede partier';

  @override
  String get puzzleUseFindInPage => 'Bruk søkefunksjonen i nettleseren for å finne favorittåpningen din!';

  @override
  String get puzzleUseCtrlF => 'Bruk Ctrl+f for å finne favorittåpningen din!';

  @override
  String get puzzleNotTheMove => 'Det der er ikke trekket!';

  @override
  String get puzzleTrySomethingElse => 'Prøv noe annet.';

  @override
  String puzzleRatingX(String param) {
    return 'Rating: $param';
  }

  @override
  String get puzzleHidden => 'skjult';

  @override
  String puzzleFromGameLink(String param) {
    return 'Fra parti $param';
  }

  @override
  String get puzzleContinueTraining => 'Fortsett å øve';

  @override
  String get puzzleDifficultyLevel => 'Vanskelighetsgrad';

  @override
  String get puzzleNormal => 'Vanlig';

  @override
  String get puzzleEasier => 'Lettere';

  @override
  String get puzzleEasiest => 'Lettest';

  @override
  String get puzzleHarder => 'Vanskelig';

  @override
  String get puzzleHardest => 'Vanskeligst';

  @override
  String get puzzleExample => 'Eksempel';

  @override
  String get puzzleAddAnotherTheme => 'Legg til tema';

  @override
  String get puzzleNextPuzzle => 'Neste sjakknøtt';

  @override
  String get puzzleJumpToNextPuzzleImmediately => 'Gå til neste sjakknøtt med én gang';

  @override
  String get puzzlePuzzleDashboard => 'Panel for sjakknøtter';

  @override
  String get puzzleImprovementAreas => 'Forbedringsområder';

  @override
  String get puzzleStrengths => 'Styrker';

  @override
  String get puzzleHistory => 'Historikk for sjakknøtter';

  @override
  String get puzzleSolved => 'løst';

  @override
  String get puzzleFailed => 'feil';

  @override
  String get puzzleStreakDescription => 'Løs verre og verre sjakknøtter og bygg en seiersrekke. Det er ingen klokke, så ta den tiden du trenger. Ett galt trekk og det er slutt! Du kan imidlertid hoppe over ett trekk for hver runde.';

  @override
  String puzzleYourStreakX(String param) {
    return 'Din rekke: $param';
  }

  @override
  String get puzzleStreakSkipExplanation => 'Hopp over dette trekket for å bevare rekken din! Funker bare én gang for hver runde.';

  @override
  String get puzzleContinueTheStreak => 'Fortsett rekken';

  @override
  String get puzzleNewStreak => 'Ny rekke';

  @override
  String get puzzleFromMyGames => 'Fra mine partier';

  @override
  String get puzzleLookupOfPlayer => 'Søk etter sjakknøtter fra en spillers partier';

  @override
  String puzzleFromXGames(String param) {
    return 'Sjakknøtter fra partier med $param';
  }

  @override
  String get puzzleSearchPuzzles => 'Søk etter sjakknøtter';

  @override
  String get puzzleFromMyGamesNone => 'Du har ingen sjakknøtter i databasen, men Lichess setter like fullt umåtelig stor pris på deg.\nSpill partier i hurtigsjakk og klassisk sjakk for å øke sjansen for å få med en sjakknøtt!';

  @override
  String puzzleFromXGamesFound(String param1, String param2) {
    return '$param1 sjakknøtter funnet i partier med $param2';
  }

  @override
  String get puzzlePuzzleDashboardDescription => 'Øv, analyser, bli bedre';

  @override
  String puzzlePercentSolved(String param) {
    return '$param løst';
  }

  @override
  String get puzzleNoPuzzlesToShow => 'Ingenting å vise, løs noen sjakknøtter først!';

  @override
  String get puzzleImprovementAreasDescription => 'Øv på disse for å optimalisere framgangen din!';

  @override
  String get puzzleStrengthDescription => 'Du gjør det best i disse temaene';

  @override
  String puzzlePlayedXTimes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Spilt $count ganger',
      one: 'Spilt $count gang',
    );
    return '$_temp0';
  }

  @override
  String puzzleNbPointsBelowYourPuzzleRating(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count poeng under sjakknøttratingen din',
      one: 'Ett poeng under sjakknøttratingen din',
    );
    return '$_temp0';
  }

  @override
  String puzzleNbPointsAboveYourPuzzleRating(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count poeng over sjakknøttratingen din',
      one: 'Ett poeng over sjakknøttratingen din',
    );
    return '$_temp0';
  }

  @override
  String puzzleNbPlayed(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count spilt',
      one: '$count spilt',
    );
    return '$_temp0';
  }

  @override
  String puzzleNbToReplay(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count å gjenta',
      one: '$count å gjenta',
    );
    return '$_temp0';
  }

  @override
  String get puzzleThemeAdvancedPawn => 'Framskutt bonde';

  @override
  String get puzzleThemeAdvancedPawnDescription => 'En bonde står dypt inne i motstanderens stilling, muligens med trussel om bondeforvandling.';

  @override
  String get puzzleThemeAdvantage => 'Fordel';

  @override
  String get puzzleThemeAdvantageDescription => 'Grip sjansen til en avgjørende fordel. (200cp ≤ eval ≤ 600cp)';

  @override
  String get puzzleThemeAnastasiaMate => 'Anastasias matt';

  @override
  String get puzzleThemeAnastasiaMateDescription => 'Tårn eller dronning slår seg sammen med springer for å fange motstanderens konge mellom kanten av brettet og egen brikke.';

  @override
  String get puzzleThemeArabianMate => 'Arabisk matt';

  @override
  String get puzzleThemeArabianMateDescription => 'Springer og tårn slår seg sammen for å fange motstanderens konge i hjørnet av brettet.';

  @override
  String get puzzleThemeAttackingF2F7 => 'Angrep mot f2 eller f7';

  @override
  String get puzzleThemeAttackingF2F7Description => 'Et angrep med fokus på bonden på f2 eller f7, slik som i fegatello-angrepet.';

  @override
  String get puzzleThemeAttraction => 'Magnetoffer';

  @override
  String get puzzleThemeAttractionDescription => 'Et bytte eller offer som lokker eller tvinger motstanderens brikke til et felt som gjør en oppfølgingstaktikk mulig.';

  @override
  String get puzzleThemeBackRankMate => 'Sekkematt';

  @override
  String get puzzleThemeBackRankMateDescription => 'Sett kongen sjakk matt på sisteraden, når den er fanget der av egne brikker.';

  @override
  String get puzzleThemeBishopEndgame => 'Løpersluttspill';

  @override
  String get puzzleThemeBishopEndgameDescription => 'Et sluttspill med kun løpere og bønder.';

  @override
  String get puzzleThemeBodenMate => 'Bodens matt';

  @override
  String get puzzleThemeBodenMateDescription => 'To angripende løpere på kryssende diagonaler setter matt, da kongen er blokkert av egne brikker.';

  @override
  String get puzzleThemeCastling => 'Rokade';

  @override
  String get puzzleThemeCastlingDescription => 'Få kongen i sikkerhet og gjør tårnet klart for angrep.';

  @override
  String get puzzleThemeCapturingDefender => 'Slå forsvareren';

  @override
  String get puzzleThemeCapturingDefenderDescription => 'Ta en brikke som gir avgjørende dekning for en annen brikke, slik at den nå udekkede brikken kan slås senere.';

  @override
  String get puzzleThemeCrushing => 'Knusende';

  @override
  String get puzzleThemeCrushingDescription => 'Oppdag motstanderens bukk og oppnå en knusende fordel. (eval ≥ 600cp)';

  @override
  String get puzzleThemeDoubleBishopMate => 'Dobbeltløpermatt';

  @override
  String get puzzleThemeDoubleBishopMateDescription => 'To angripende løpere på tilstøtende diagonaler setter matt, da kongen er blokkert av egne brikker.';

  @override
  String get puzzleThemeDovetailMate => 'Halematt';

  @override
  String get puzzleThemeDovetailMateDescription => 'Dronning setter tilstøtende konge matt, da de to eneste fluktfeltene er blokkert av egne brikker.';

  @override
  String get puzzleThemeEquality => 'Utligning';

  @override
  String get puzzleThemeEqualityDescription => 'Vend en tapt stilling til remis eller lik stilling. (eval ≤ 200cp)';

  @override
  String get puzzleThemeKingsideAttack => 'Angrep på kongefløyen';

  @override
  String get puzzleThemeKingsideAttackDescription => 'Et angrep mot motstanderens konge etter kort rokade.';

  @override
  String get puzzleThemeClearance => 'Feltrømming';

  @override
  String get puzzleThemeClearanceDescription => 'Et trekk, gjerne med tempo, som åpner et felt, en linje eller en diagonal for en påfølgende taktisk idé.';

  @override
  String get puzzleThemeDefensiveMove => 'Forsvarstrekk';

  @override
  String get puzzleThemeDefensiveMoveDescription => 'Et trekk eller en trekkrekke som er nøyaktig det som trengs for å unngå å tape materiell eller en annen fordel.';

  @override
  String get puzzleThemeDeflection => 'Avledning';

  @override
  String get puzzleThemeDeflectionDescription => 'Et trekk som leder en motstanderbrikke vekk fra en rolle den har, for eksempel å dekke et nøkkelfelt. Noen ganger også kalt «overbelastning».';

  @override
  String get puzzleThemeDiscoveredAttack => 'Avdekker';

  @override
  String get puzzleThemeDiscoveredAttackDescription => 'Å flytte en brikke som blokkerer angrep fra en annen langtrekkende brikke, for eksempel å flytte en springer ut av veien for et tårn.';

  @override
  String get puzzleThemeDoubleCheck => 'Dobbeltsjakk';

  @override
  String get puzzleThemeDoubleCheckDescription => 'Å gi sjakk med to brikker samtidig, gjennom en avdekker der både brikken som flyttes, og brikken som avdekkes, angriper motstanderens konge.';

  @override
  String get puzzleThemeEndgame => 'Sluttspill';

  @override
  String get puzzleThemeEndgameDescription => 'En taktikk i den siste fasen av partiet.';

  @override
  String get puzzleThemeEnPassantDescription => 'En taktikk som utnytter en passant-regelen, der en bonde kan slå en motstanderbonde som har passert den ved å flytte to felt.';

  @override
  String get puzzleThemeExposedKing => 'Utsatt konge';

  @override
  String get puzzleThemeExposedKingDescription => 'En taktikk som utnytter en konge med få forsvarsbrikker rundt seg, noe som ofte leder til sjakk matt.';

  @override
  String get puzzleThemeFork => 'Gaffel';

  @override
  String get puzzleThemeForkDescription => 'Et trekk der brikken som ble flyttet, angriper to av motstanderens brikker samtidig.';

  @override
  String get puzzleThemeHangingPiece => 'Hengende brikke';

  @override
  String get puzzleThemeHangingPieceDescription => 'En taktikk som utnytter at en motstanderbrikke er udekket eller ikke tilstrekkelig dekket og kan slås.';

  @override
  String get puzzleThemeHookMate => 'Krokmatt';

  @override
  String get puzzleThemeHookMateDescription => 'Tårn, springer og bonde setter sjakk matt i en stilling der motstanderens bonde avskjærer kongens flukt.';

  @override
  String get puzzleThemeInterference => 'Interferens';

  @override
  String get puzzleThemeInterferenceDescription => 'Å flytte en brikke mellom to motstanderbrikker slik at en av eller begge motstanderbrikkene er udekket, for eksempel en springer på et dekket felt mellom to tårn.';

  @override
  String get puzzleThemeIntermezzo => 'Mellomtrekk';

  @override
  String get puzzleThemeIntermezzoDescription => 'I stedet for å foreta det forventede trekket utføres først et annet trekk som utgjør en umiddelbar trussel, som motstanderen må svare på.';

  @override
  String get puzzleThemeKnightEndgame => 'Springersluttspill';

  @override
  String get puzzleThemeKnightEndgameDescription => 'Et sluttspill med kun springere og bønder.';

  @override
  String get puzzleThemeLong => 'Lang sjakknøtt';

  @override
  String get puzzleThemeLongDescription => 'Tre trekk til vinst.';

  @override
  String get puzzleThemeMaster => 'Mesterpartier';

  @override
  String get puzzleThemeMasterDescription => 'Sjakknøtter fra partier med spillere som har sjakktittel.';

  @override
  String get puzzleThemeMasterVsMaster => 'Mestermøter';

  @override
  String get puzzleThemeMasterVsMasterDescription => 'Sjakknøtter fra partier mellom to spillere som har sjakktittel.';

  @override
  String get puzzleThemeMate => 'Matt';

  @override
  String get puzzleThemeMateDescription => 'Vinn partiet med stil.';

  @override
  String get puzzleThemeMateIn1 => 'Matt i 1';

  @override
  String get puzzleThemeMateIn1Description => 'Sett sjakk matt i ett trekk.';

  @override
  String get puzzleThemeMateIn2 => 'Matt i 2';

  @override
  String get puzzleThemeMateIn2Description => 'Sett sjakk matt i to trekk.';

  @override
  String get puzzleThemeMateIn3 => 'Matt i 3';

  @override
  String get puzzleThemeMateIn3Description => 'Sett sjakk matt i tre trekk.';

  @override
  String get puzzleThemeMateIn4 => 'Matt i 4';

  @override
  String get puzzleThemeMateIn4Description => 'Sett sjakk matt i fire trekk.';

  @override
  String get puzzleThemeMateIn5 => 'Matt i 5 eller flere';

  @override
  String get puzzleThemeMateIn5Description => 'Finn en lang trekkrekke som gir matt.';

  @override
  String get puzzleThemeMiddlegame => 'Midtspill';

  @override
  String get puzzleThemeMiddlegameDescription => 'En taktikk i den andre fasen av partiet.';

  @override
  String get puzzleThemeOneMove => 'Ett-trekks sjakknøtt';

  @override
  String get puzzleThemeOneMoveDescription => 'En sjakknøtt på bare ett trekk.';

  @override
  String get puzzleThemeOpening => 'Åpning';

  @override
  String get puzzleThemeOpeningDescription => 'En taktikk i den første fasen av partiet.';

  @override
  String get puzzleThemePawnEndgame => 'Bondesluttspill';

  @override
  String get puzzleThemePawnEndgameDescription => 'Et sluttspill med kun bønder.';

  @override
  String get puzzleThemePin => 'Binding';

  @override
  String get puzzleThemePinDescription => 'En taktikk som utnytter bindinger, der en brikke ikke kan flyttes uten at en brikke med høyere verdi trues.';

  @override
  String get puzzleThemePromotion => 'Bondeforvandling';

  @override
  String get puzzleThemePromotionDescription => 'Bytt ut bonde med dronning, tårn, løper eller springer.';

  @override
  String get puzzleThemeQueenEndgame => 'Dronningsluttspill';

  @override
  String get puzzleThemeQueenEndgameDescription => 'Et sluttspill med kun dronninger og bønder.';

  @override
  String get puzzleThemeQueenRookEndgame => 'Dronning- og tårnsluttspill';

  @override
  String get puzzleThemeQueenRookEndgameDescription => 'Et sluttspill med kun dronninger, tårn og bønder.';

  @override
  String get puzzleThemeQueensideAttack => 'Angrep på dronningfløyen';

  @override
  String get puzzleThemeQueensideAttackDescription => 'Et angrep mot motstanderens konge etter lang rokade.';

  @override
  String get puzzleThemeQuietMove => 'Rolig trekk';

  @override
  String get puzzleThemeQuietMoveDescription => 'Et trekk som ikke gir sjakk eller slår en brikke, men som forbereder en uunngåelig trussel i et senere trekk.';

  @override
  String get puzzleThemeRookEndgame => 'Tårnsluttspill';

  @override
  String get puzzleThemeRookEndgameDescription => 'Et sluttspill med kun tårn og bønder.';

  @override
  String get puzzleThemeSacrifice => 'Offer';

  @override
  String get puzzleThemeSacrificeDescription => 'En taktikk der man gir fra seg materiell på kort sikt, for å oppnå en fordel etter en tvungen trekkrekke.';

  @override
  String get puzzleThemeShort => 'Kort sjakknøtt';

  @override
  String get puzzleThemeShortDescription => 'To trekk til vinst.';

  @override
  String get puzzleThemeSkewer => 'Spidding';

  @override
  String get puzzleThemeSkewerDescription => 'Et motiv der en brikke med høy verdi er under angrep og må flyttes, noe som tillater at en brikke med lavere verdi som står bak den, blir slått eller angrepet, det motsatte av en binding.';

  @override
  String get puzzleThemeSmotheredMate => 'Kvelermatt';

  @override
  String get puzzleThemeSmotheredMateDescription => 'En stilling der en springer setter sjakk matt, og kongen ikke kan flyttes fordi den er omgitt (eller kvalt) av egne brikker.';

  @override
  String get puzzleThemeSuperGM => 'Super-GM-partier';

  @override
  String get puzzleThemeSuperGMDescription => 'Sjakknøtter fra partier med verdens beste spillere.';

  @override
  String get puzzleThemeTrappedPiece => 'Fanget brikke';

  @override
  String get puzzleThemeTrappedPieceDescription => 'En brikke kan ikke unnslippe, siden den har få mulige trekk.';

  @override
  String get puzzleThemeUnderPromotion => 'Underforvandling';

  @override
  String get puzzleThemeUnderPromotionDescription => 'Bondeforvandling til springer, løper eller tårn.';

  @override
  String get puzzleThemeVeryLong => 'Veldig lang sjakknøtt';

  @override
  String get puzzleThemeVeryLongDescription => 'Fire trekk eller flere til vinst.';

  @override
  String get puzzleThemeXRayAttack => 'Røntgenangrep';

  @override
  String get puzzleThemeXRayAttackDescription => 'En brikke angriper eller dekker et felt indirekte, gjennom en av motstanderens brikker.';

  @override
  String get puzzleThemeZugzwang => 'Trekktvang';

  @override
  String get puzzleThemeZugzwangDescription => 'Motstanderen kan bare utføre trekk som forverrer egen stilling.';

  @override
  String get puzzleThemeHealthyMix => 'Frisk blanding';

  @override
  String get puzzleThemeHealthyMixDescription => 'Litt av alt. Du vet ikke hva du får, så du er klar for alt! Akkurat som i virkelige partier.';

  @override
  String get puzzleThemePlayerGames => 'Spillerpartier';

  @override
  String get puzzleThemePlayerGamesDescription => 'Finn sjakknøtter generert fra dine eller andres partier.';

  @override
  String puzzleThemePuzzleDownloadInformation(String param) {
    return 'Disse sjakknøttene er offentlig eiendom og kan lastes ned fra $param.';
  }

  @override
  String get searchSearch => 'Søk';

  @override
  String get settingsSettings => 'Innstillinger';

  @override
  String get settingsCloseAccount => 'Avslutt konto';

  @override
  String get settingsManagedAccountCannotBeClosed => 'Kontoen din er forvaltet og kan ikke avsluttes.';

  @override
  String get settingsClosingIsDefinitive => 'Å lukke kontoen er en beslutning som ikke kan reverseres. Er du helt sikker?';

  @override
  String get settingsCantOpenSimilarAccount => 'Du har ikke mulighet til å opprette en ny konto med samme brukernavn, selv om du endrer små bokstaver til STORE, eller STORE bokstaver til små.';

  @override
  String get settingsChangedMindDoNotCloseAccount => 'Jeg angrer, ikke avslutt kontoen min';

  @override
  String get settingsCloseAccountExplanation => 'Er du helt sikker på at du vil lukke denne kontoen? Det er en permanent beslutning. Du vil ikke ha mulighet til å logge inn igjen noen gang.';

  @override
  String get settingsThisAccountIsClosed => 'Denne kontoen er avsluttet.';

  @override
  String get playWithAFriend => 'Spill mot en venn';

  @override
  String get playWithTheMachine => 'Spill mot maskinen';

  @override
  String get toInviteSomeoneToPlayGiveThisUrl => 'For å invitere noen til å spille, gi dem denne lenken';

  @override
  String get gameOver => 'Partiet er avsluttet';

  @override
  String get waitingForOpponent => 'Venter på motstander';

  @override
  String get orLetYourOpponentScanQrCode => 'Eller få motstanderen din til å skanne denne QR-koden';

  @override
  String get waiting => 'Venter';

  @override
  String get yourTurn => 'Ditt trekk';

  @override
  String aiNameLevelAiLevel(String param1, String param2) {
    return '$param1 på nivå $param2';
  }

  @override
  String get level => 'Nivå';

  @override
  String get strength => 'Styrke';

  @override
  String get toggleTheChat => 'Chat av/på';

  @override
  String get chat => 'Chat';

  @override
  String get resign => 'Gi opp';

  @override
  String get checkmate => 'Sjakk matt';

  @override
  String get stalemate => 'Patt';

  @override
  String get white => 'Hvit';

  @override
  String get black => 'Sort';

  @override
  String get asWhite => 'som hvit';

  @override
  String get asBlack => 'som svart';

  @override
  String get randomColor => 'Tilfeldig side';

  @override
  String get createAGame => 'Start et parti';

  @override
  String get whiteIsVictorious => 'Hvit har vunnet';

  @override
  String get blackIsVictorious => 'Sort har vunnet';

  @override
  String get youPlayTheWhitePieces => 'Du spiller med de hvite brikkene';

  @override
  String get youPlayTheBlackPieces => 'Du spiller med de svarte brikkene';

  @override
  String get itsYourTurn => 'Det er ditt trekk!';

  @override
  String get cheatDetected => 'Juks oppdaget';

  @override
  String get kingInTheCenter => 'Kongen i sentrum';

  @override
  String get threeChecks => 'Tre sjakker';

  @override
  String get raceFinished => 'Målgang';

  @override
  String get variantEnding => 'Variantavslutning';

  @override
  String get newOpponent => 'Ny motstander';

  @override
  String get yourOpponentWantsToPlayANewGameWithYou => 'Din motstander vil spille et nytt parti med deg';

  @override
  String get joinTheGame => 'Bli med';

  @override
  String get whitePlays => 'Hvit i trekket';

  @override
  String get blackPlays => 'Sort i trekket';

  @override
  String get opponentLeftChoices => 'Den andre spilleren kan ha forlatt partiet. Du kan kreve seier, erklære remis, eller vente.';

  @override
  String get forceResignation => 'Krev seier';

  @override
  String get forceDraw => 'Erklær remis';

  @override
  String get talkInChat => 'Vær respektfull i chatten!';

  @override
  String get theFirstPersonToComeOnThisUrlWillPlayWithYou => 'Den første personen som kommer til denne lenken vil spille mot deg.';

  @override
  String get whiteResigned => 'Hvit ga opp';

  @override
  String get blackResigned => 'Sort ga opp';

  @override
  String get whiteLeftTheGame => 'Hvit forlot partiet';

  @override
  String get blackLeftTheGame => 'Sort forlot partiet';

  @override
  String get whiteDidntMove => 'Hvit flyttet ikke';

  @override
  String get blackDidntMove => 'Svart flyttet ikke';

  @override
  String get requestAComputerAnalysis => 'Be om computeranalyse';

  @override
  String get computerAnalysis => 'Computeranalyse';

  @override
  String get computerAnalysisAvailable => 'Datamaskinanalyse tilgjengelig';

  @override
  String get computerAnalysisDisabled => 'Maskinanalyse er skrudd av';

  @override
  String get analysis => 'Analysebrett';

  @override
  String depthX(String param) {
    return 'Dybde $param';
  }

  @override
  String get usingServerAnalysis => 'Bruker serveranalyse';

  @override
  String get loadingEngine => 'Laster sjakkmotor ...';

  @override
  String get calculatingMoves => 'Beregner trekk...';

  @override
  String get engineFailed => 'Kunne ikke laste sjakkmotor';

  @override
  String get cloudAnalysis => 'Skyanalyse';

  @override
  String get goDeeper => 'Gå dypere';

  @override
  String get showThreat => 'Vis trussel';

  @override
  String get inLocalBrowser => 'i nettleser';

  @override
  String get toggleLocalEvaluation => 'Lokal evaluering';

  @override
  String get promoteVariation => 'Forfrem variant';

  @override
  String get makeMainLine => 'Gjør til hovedvariant';

  @override
  String get deleteFromHere => 'Slett herfra';

  @override
  String get collapseVariations => 'Skjul varianter';

  @override
  String get expandVariations => 'Vis varianter';

  @override
  String get forceVariation => 'Vis som variant';

  @override
  String get copyVariationPgn => 'Kopier variant-PGN';

  @override
  String get move => 'Trekk';

  @override
  String get variantLoss => 'Variant tap';

  @override
  String get variantWin => 'Variant seier';

  @override
  String get insufficientMaterial => 'Utilstrekkelig materiell';

  @override
  String get pawnMove => 'Bondetrekk';

  @override
  String get capture => 'Slag';

  @override
  String get close => 'Lukk';

  @override
  String get winning => 'Vinner';

  @override
  String get losing => 'Taper';

  @override
  String get drawn => 'Remis';

  @override
  String get unknown => 'Ukjent';

  @override
  String get database => 'Database';

  @override
  String get whiteDrawBlack => 'Hvit / Remis / Svart';

  @override
  String averageRatingX(String param) {
    return 'Gjennomsnittsrating: $param';
  }

  @override
  String get recentGames => 'Nylige partier';

  @override
  String get topGames => 'Topp-partier';

  @override
  String masterDbExplanation(String param1, String param2, String param3) {
    return 'Brettsjakkpartier med spillere som har FIDE-rating $param1+ fra $param2 til $param3';
  }

  @override
  String get dtzWithRounding => 'DTZ50\'\' med avrunding, basert på antall halvtrekk til neste slag eller bondetrekk';

  @override
  String get noGameFound => 'Intet parti funnet';

  @override
  String get maxDepthReached => 'Maks dybde nådd!';

  @override
  String get maybeIncludeMoreGamesFromThePreferencesMenu => 'Kanskje inkludere flere parti fra preferansemenyen?';

  @override
  String get openings => 'Åpninger';

  @override
  String get openingExplorer => 'Åpningsutforsker';

  @override
  String get openingEndgameExplorer => 'Åpnings-/sluttspillsutforsker';

  @override
  String xOpeningExplorer(String param) {
    return 'Åpningsutforsker for $param';
  }

  @override
  String get playFirstOpeningEndgameExplorerMove => 'Utfør det første trekket fra åpnings-/sluttspillsutforskeren';

  @override
  String get winPreventedBy50MoveRule => 'Seier hindret av 50-trekksregelen';

  @override
  String get lossSavedBy50MoveRule => 'Tap forhindret av 50-trekkregelen';

  @override
  String get winOr50MovesByPriorMistake => 'Seier eller 50 trekk etter tidligere feil';

  @override
  String get lossOr50MovesByPriorMistake => 'Tap eller 50 trekk etter tidligere feil';

  @override
  String get unknownDueToRounding => 'Seier/tap bare garantert dersom anbefalte trekk fra tabellbasen er fulgt siden siste slag eller bondetrekk, grunnet mulig avrunding av DTZ-verdier i Syzygy-tabellbaser.';

  @override
  String get allSet => 'Alt klart!';

  @override
  String get importPgn => 'Importér PGN-fil';

  @override
  String get delete => 'Slett';

  @override
  String get deleteThisImportedGame => 'Slette dette importerte partiet?';

  @override
  String get replayMode => 'Gjennomspilling';

  @override
  String get realtimeReplay => 'Sanntid';

  @override
  String get byCPL => 'Etter CBT';

  @override
  String get openStudy => 'Åpne studie';

  @override
  String get enable => 'Aktiver';

  @override
  String get bestMoveArrow => 'Pil for beste trekk';

  @override
  String get showVariationArrows => 'Vis variantpiler';

  @override
  String get evaluationGauge => 'Evalueringsmåler';

  @override
  String get multipleLines => 'Flere varianter';

  @override
  String get cpus => 'Prosessorer';

  @override
  String get memory => 'Minne';

  @override
  String get infiniteAnalysis => 'Uendelig analyse';

  @override
  String get removesTheDepthLimit => 'Fjerner dybdebegrensning, og holder maskinen din varm';

  @override
  String get engineManager => 'Innstillinger for sjakkmotorer';

  @override
  String get blunder => 'Bukk';

  @override
  String get mistake => 'Feil';

  @override
  String get inaccuracy => 'Unøyaktighet';

  @override
  String get moveTimes => 'Tidsbruk';

  @override
  String get flipBoard => 'Snu brettet';

  @override
  String get threefoldRepetition => 'Trekkgjentakelse';

  @override
  String get claimADraw => 'Krev remis';

  @override
  String get offerDraw => 'Tilby remis';

  @override
  String get draw => 'Remis';

  @override
  String get drawByMutualAgreement => 'Remis ved overenskomst';

  @override
  String get fiftyMovesWithoutProgress => 'Femti trekk uten framgang';

  @override
  String get currentGames => 'Partier som spilles nå';

  @override
  String get viewInFullSize => 'Se i full størrelse';

  @override
  String get logOut => 'Logg ut';

  @override
  String get signIn => 'Logg inn';

  @override
  String get rememberMe => 'Hold meg innlogget';

  @override
  String get youNeedAnAccountToDoThat => 'Du trenger en konto for å gjøre det';

  @override
  String get signUp => 'Registrer brukerkonto';

  @override
  String get computersAreNotAllowedToPlay => 'Datamaskiner og spillere som får hjelp av datamaskiner har ikke lov til å spille. Vennligst ikke ta imot hjelp fra sjakkmaskiner, databaser eller andre spillere under partiene. Merk også at det er sterkt frarådet å opprette flere brukerkontoer, og kan lede til at du blir utstengt.';

  @override
  String get games => 'Partier';

  @override
  String get forum => 'Forum';

  @override
  String xPostedInForumY(String param1, String param2) {
    return '$param1 postet i innlegg $param2';
  }

  @override
  String get latestForumPosts => 'Nyeste foruminnlegg';

  @override
  String get players => 'Spillere';

  @override
  String get friends => 'Venner';

  @override
  String get discussions => 'Samtaler';

  @override
  String get today => 'I dag';

  @override
  String get yesterday => 'I går';

  @override
  String get minutesPerSide => 'Minutter per spiller';

  @override
  String get variant => 'Variant';

  @override
  String get variants => 'Varianter';

  @override
  String get timeControl => 'Tidskontroll';

  @override
  String get realTime => 'Sanntid';

  @override
  String get correspondence => 'Fjernsjakk';

  @override
  String get daysPerTurn => 'Dager per trekk';

  @override
  String get oneDay => 'Én dag';

  @override
  String get time => 'Tid';

  @override
  String get rating => 'Rating';

  @override
  String get ratingStats => 'Ratingstatistikk';

  @override
  String get username => 'Brukernavn';

  @override
  String get usernameOrEmail => 'Brukernavn eller e-post';

  @override
  String get changeUsername => 'Endre brukernavn';

  @override
  String get changeUsernameNotSame => 'Du kan bare endre små bokstaver til store eller store til små. For eksempel \"olanordmann\" til \"OlaNordmann\".';

  @override
  String get changeUsernameDescription => 'Endre brukernavnet ditt. Dette kan bare gjøres én gang, og du bare kan endre små bokstaver til store eller store til små.';

  @override
  String get signupUsernameHint => 'Velg et sømmelig brukernavn. Det kan ikke endres, og alle kontoer med usømmelige brukernavn vil bli avsluttet.';

  @override
  String get signupEmailHint => 'Vi bruker den bare når du tilbakestiller passordet ditt.';

  @override
  String get password => 'Passord';

  @override
  String get changePassword => 'Bytt passord';

  @override
  String get changeEmail => 'Endre e-postadresse';

  @override
  String get email => 'E-post';

  @override
  String get passwordReset => 'Tilbakestill passord';

  @override
  String get forgotPassword => 'Glemt passord?';

  @override
  String get error_weakPassword => 'Passordet er svært vanlig og for lett å gjette.';

  @override
  String get error_namePassword => 'Ikke bruk navnet ditt som passord.';

  @override
  String get blankedPassword => 'Du har brukt likt passord på en kompromittert nettside. Du må lage nytt passord.';

  @override
  String get youAreLeavingLichess => 'Du forlater Lichess';

  @override
  String get neverTypeYourPassword => 'Ikke bruk Lichess-passordet ditt andre steder!';

  @override
  String proceedToX(String param) {
    return 'Fortsett til $param';
  }

  @override
  String get passwordSuggestion => 'Ikke bruk passord foreslått av andre. Kontoen din vil bli stjålet.';

  @override
  String get emailSuggestion => 'Ikke bruk e-postadresse foreslått av andre. Kontoen din vil bli stjålet.';

  @override
  String get emailConfirmHelp => 'Hjelp med å bekrefte e-posten';

  @override
  String get emailConfirmNotReceived => 'Mottok du ikke bekreftelsesmelding etter at du registrerte deg?';

  @override
  String get whatSignupUsername => 'Hvilket brukernavn registrerte du deg med?';

  @override
  String usernameNotFound(String param) {
    return 'Vi finner ikke dette brukernavnet: $param.';
  }

  @override
  String get usernameCanBeUsedForNewAccount => 'Du kan opprette en ny konto med dette brukernavnet';

  @override
  String emailSent(String param) {
    return 'Vi har sendt en melding til $param.';
  }

  @override
  String get emailCanTakeSomeTime => 'Det kan ta litt tid.';

  @override
  String get refreshInboxAfterFiveMinutes => 'Vent fem minutter før du oppdaterer innboksen.';

  @override
  String get checkSpamFolder => 'Sjekk om meldingen havnet i søppelpostmappen. Merk i tilfelle meldingen som ikke søppelpost.';

  @override
  String get emailForSignupHelp => 'Send denne meldingen til oss som siste utvei:';

  @override
  String copyTextToEmail(String param) {
    return 'Kopier og lim inn teksten ovenfor og send den til $param';
  }

  @override
  String get waitForSignupHelp => 'Vi tar snart kontakt og hjelper deg med registreringen.';

  @override
  String accountConfirmed(String param) {
    return 'Brukeren $param er bekreftet.';
  }

  @override
  String accountCanLogin(String param) {
    return 'Du kan nå logge inn som $param.';
  }

  @override
  String get accountConfirmationEmailNotNeeded => 'Du trenger ikke bekreftelsesmelding.';

  @override
  String accountClosed(String param) {
    return 'Kontoen $param er avsluttet.';
  }

  @override
  String accountRegisteredWithoutEmail(String param) {
    return 'Kontoen $param ble registrert uten e-post.';
  }

  @override
  String get rank => 'Rangering';

  @override
  String rankX(String param) {
    return 'Plassering: $param';
  }

  @override
  String get gamesPlayed => 'partier spilt';

  @override
  String get cancel => 'Avbryt';

  @override
  String get whiteTimeOut => 'Tiden er ute for hvit';

  @override
  String get blackTimeOut => 'Tiden er ute for svart';

  @override
  String get drawOfferSent => 'Remistilbud sendt';

  @override
  String get drawOfferAccepted => 'Remistilbud godtatt';

  @override
  String get drawOfferCanceled => 'Remistilbud trukket tilbake';

  @override
  String get whiteOffersDraw => 'Hvit tilbyr remis';

  @override
  String get blackOffersDraw => 'Sort tilbyr remis';

  @override
  String get whiteDeclinesDraw => 'Hvit avslår remis';

  @override
  String get blackDeclinesDraw => 'Sort avslår remis';

  @override
  String get yourOpponentOffersADraw => 'Din motstander tilbyr remis';

  @override
  String get accept => 'Godta';

  @override
  String get decline => 'Avslå';

  @override
  String get playingRightNow => 'Pågår';

  @override
  String get eventInProgress => 'Pågår';

  @override
  String get finished => 'Ferdig';

  @override
  String get abortGame => 'Avbryt partiet';

  @override
  String get gameAborted => 'Partiet er avbrutt';

  @override
  String get standard => 'Standard';

  @override
  String get customPosition => 'Brukerdefinert stilling';

  @override
  String get unlimited => 'Ubegrenset';

  @override
  String get mode => 'Modus';

  @override
  String get casual => 'Urangert';

  @override
  String get rated => 'Rangert';

  @override
  String get casualTournament => 'Uformell';

  @override
  String get ratedTournament => 'Ratet';

  @override
  String get thisGameIsRated => 'Dette partiet er rangert';

  @override
  String get rematch => 'Omkamp';

  @override
  String get rematchOfferSent => 'Tilbud om omkamp sendt';

  @override
  String get rematchOfferAccepted => 'Tilbud om omkamp godtatt';

  @override
  String get rematchOfferCanceled => 'Tilbud om omkamp trukket tilbake';

  @override
  String get rematchOfferDeclined => 'Tilbud om omkamp avslått';

  @override
  String get cancelRematchOffer => 'Avbryt tilbud om omkamp';

  @override
  String get viewRematch => 'Se omkamp';

  @override
  String get confirmMove => 'Bekreft trekk';

  @override
  String get play => 'Spill';

  @override
  String get inbox => 'Innboks';

  @override
  String get chatRoom => 'Chatterom';

  @override
  String get loginToChat => 'Logg inn for samtale';

  @override
  String get youHaveBeenTimedOut => 'Du har fått timeout.';

  @override
  String get spectatorRoom => 'Tilskuerrom';

  @override
  String get composeMessage => 'Skriv melding';

  @override
  String get subject => 'Emne';

  @override
  String get send => 'Send';

  @override
  String get incrementInSeconds => 'Tillegg i sekunder per trekk';

  @override
  String get freeOnlineChess => 'Gratis nettsjakk';

  @override
  String get exportGames => 'Eksporter partier';

  @override
  String get ratingRange => 'Ratingspenn';

  @override
  String get thisAccountViolatedTos => 'Denne kontoen brøt vilkårene for å bruke Lichess';

  @override
  String get openingExplorerAndTablebase => 'Åpningsutforsker og tabellbase';

  @override
  String get takeback => 'Angre';

  @override
  String get proposeATakeback => 'Foreslå å angre';

  @override
  String get takebackPropositionSent => 'Angreforslag sendt';

  @override
  String get takebackPropositionDeclined => 'Angreforslag avslått';

  @override
  String get takebackPropositionAccepted => 'Angreforslag godtatt';

  @override
  String get takebackPropositionCanceled => 'Angreforslag trukket tilbake';

  @override
  String get yourOpponentProposesATakeback => 'Din motstander foreslår å angre';

  @override
  String get bookmarkThisGame => 'Bokmerk dette partiet';

  @override
  String get tournament => 'Turnering';

  @override
  String get tournaments => 'Turneringer';

  @override
  String get tournamentPoints => 'Turneringspoeng';

  @override
  String get viewTournament => 'Vis turnering';

  @override
  String get backToTournament => 'Tilbake til turneringen';

  @override
  String get noDrawBeforeSwissLimit => 'Ingen remis før 30 trekk i sveitserturneringer.';

  @override
  String get thematic => 'Tematisk';

  @override
  String yourPerfRatingIsProvisional(String param) {
    return '$param-ratingen din er provisorisk';
  }

  @override
  String yourPerfRatingIsTooHigh(String param1, String param2) {
    return 'Ratingen din i $param1 ($param2) er for høy';
  }

  @override
  String yourTopWeeklyPerfRatingIsTooHigh(String param1, String param2) {
    return 'Den beste ukeratingen din i $param1 ($param2) er for høy';
  }

  @override
  String yourPerfRatingIsTooLow(String param1, String param2) {
    return 'Ratingen din i $param1 ($param2) er for lav';
  }

  @override
  String ratedMoreThanInPerf(String param1, String param2) {
    return 'Ratet ≥ $param1 i $param2';
  }

  @override
  String ratedLessThanInPerf(String param1, String param2) {
    return 'Ratet ≤ $param1 i $param2 den foregående uken';
  }

  @override
  String mustBeInTeam(String param) {
    return 'Du må være med i laget $param';
  }

  @override
  String youAreNotInTeam(String param) {
    return 'Du er ikke med i teamet $param';
  }

  @override
  String get backToGame => 'Tilbake til partiet';

  @override
  String get siteDescription => 'Gratis nettsjakk. Spill sjakk nå, i et enkelt og rent format. Ingen registrering, ingen reklame, ingen programtillegg er nødvendig. Spill sjakk mot datamaskinen, venner, eller tilfeldige motstandere.';

  @override
  String xJoinedTeamY(String param1, String param2) {
    return '$param1 ble med på laget $param2';
  }

  @override
  String xCreatedTeamY(String param1, String param2) {
    return '$param1 opprettet laget $param2';
  }

  @override
  String get startedStreaming => 'begynte å strømme';

  @override
  String xStartedStreaming(String param) {
    return '$param begynte å strømme';
  }

  @override
  String get averageElo => 'Snittrating';

  @override
  String get location => 'Sted';

  @override
  String get filterGames => 'Filtrer partier';

  @override
  String get reset => 'Tilbakestill';

  @override
  String get apply => 'Bruk';

  @override
  String get save => 'Lagre';

  @override
  String get leaderboard => 'Ledertabell';

  @override
  String get screenshotCurrentPosition => 'Skjermbilde av stillingen';

  @override
  String get gameAsGIF => 'Parti som gif';

  @override
  String get pasteTheFenStringHere => 'Lim inn FEN-teksten her';

  @override
  String get pasteThePgnStringHere => 'Lim inn PGN-teksten her';

  @override
  String get orUploadPgnFile => 'Eller last opp en PGN-fil';

  @override
  String get fromPosition => 'Fra stilling';

  @override
  String get continueFromHere => 'Fortsett herfra';

  @override
  String get toStudy => 'Studie';

  @override
  String get importGame => 'Importer parti';

  @override
  String get importGameExplanation => 'Lim inn PGN for gjennomblaing, maskinanalyse, partisamtale og delbar URL.';

  @override
  String get importGameCaveat => 'Varianter importeres ikke. Bruk en studie for å importere PGN med varianter.';

  @override
  String get importGameDataPrivacyWarning => 'Denne PGN-en er offentlig tilgjengelig. Bruk en studie for å importere et parti privat.';

  @override
  String get thisIsAChessCaptcha => 'Dette er en sjakk-CAPTCHA.';

  @override
  String get clickOnTheBoardToMakeYourMove => 'Klikk på brettet for å gjøre et trekk og bevise at du er et menneske.';

  @override
  String get captcha_fail => 'Vennligst løs sjakk-captchaen.';

  @override
  String get notACheckmate => 'Ikke sjakk matt';

  @override
  String get whiteCheckmatesInOneMove => 'Hvit setter matt i ett trekk';

  @override
  String get blackCheckmatesInOneMove => 'Svart setter matt i ett trekk';

  @override
  String get retry => 'Prøv igjen';

  @override
  String get reconnecting => 'Gjenoppretter forbindelsen';

  @override
  String get noNetwork => 'Frakoblet';

  @override
  String get favoriteOpponents => 'Favorittmotstandere';

  @override
  String get follow => 'Følg';

  @override
  String get following => 'Følger';

  @override
  String get unfollow => 'Slutt å følge';

  @override
  String followX(String param) {
    return 'Følg $param';
  }

  @override
  String unfollowX(String param) {
    return 'Slutt å følge $param';
  }

  @override
  String get block => 'Blokker';

  @override
  String get blocked => 'Blokkert';

  @override
  String get unblock => 'Fjern blokkering';

  @override
  String get followsYou => 'Følger deg';

  @override
  String xStartedFollowingY(String param1, String param2) {
    return '$param1 begynte å følge $param2';
  }

  @override
  String get more => 'Mer';

  @override
  String get memberSince => 'Medlem siden';

  @override
  String lastSeenActive(String param) {
    return 'Forrige pålogging $param';
  }

  @override
  String get player => 'Spiller';

  @override
  String get list => 'Liste';

  @override
  String get graph => 'Graf';

  @override
  String get required => 'Påkrevd.';

  @override
  String get openTournaments => 'Åpne turneringer';

  @override
  String get duration => 'Varighet';

  @override
  String get winner => 'Vinner';

  @override
  String get standing => 'Resultatliste';

  @override
  String get createANewTournament => 'Opprett en ny turnering';

  @override
  String get tournamentCalendar => 'Turneringskalender';

  @override
  String get conditionOfEntry => 'Betingelse for å delta:';

  @override
  String get advancedSettings => 'Avanserte innstillinger';

  @override
  String get safeTournamentName => 'Velg et veldig trygt navn for turneringen.';

  @override
  String get inappropriateNameWarning => 'Upassende innhold kan føre til at brukerkontoen din blir stengt.';

  @override
  String get emptyTournamentName => 'La stå tomt for at turneringa skal få navn etter en tilfeldig stormester.';

  @override
  String get makePrivateTournament => 'Gjør turneringen privat og begrens tilgang med et passord';

  @override
  String get join => 'Bli med';

  @override
  String get withdraw => 'Trekk deg';

  @override
  String get points => 'Poeng';

  @override
  String get wins => 'Seire';

  @override
  String get losses => 'Tap';

  @override
  String get createdBy => 'Opprettet av';

  @override
  String get tournamentIsStarting => 'Turneringen begynner';

  @override
  String get tournamentPairingsAreNowClosed => 'Oppsettet av turneringen er nå lukket.';

  @override
  String standByX(String param) {
    return 'Vent litt $param, kobler sammen spillere, vær klar!';
  }

  @override
  String get pause => 'Pause';

  @override
  String get resume => 'Fortsett';

  @override
  String get youArePlaying => 'Du spiller!';

  @override
  String get winRate => 'Seierprosent';

  @override
  String get berserkRate => 'Berserkprosent';

  @override
  String get performance => 'Prestasjon';

  @override
  String get tournamentComplete => 'Turnering fullført';

  @override
  String get movesPlayed => 'Spilte trekk';

  @override
  String get whiteWins => 'Hvit vinner';

  @override
  String get blackWins => 'Svart vinner';

  @override
  String get drawRate => 'Remisrate';

  @override
  String get draws => 'Remis';

  @override
  String nextXTournament(String param) {
    return 'Neste $param turnering:';
  }

  @override
  String get averageOpponent => 'Gjennomsnittlig motstand';

  @override
  String get boardEditor => 'Oppsett';

  @override
  String get setTheBoard => 'Still opp brett';

  @override
  String get popularOpenings => 'Populære åpninger';

  @override
  String get endgamePositions => 'Sluttspillstillinger';

  @override
  String chess960StartPosition(String param) {
    return 'Fischersjakkutgangsstilling: $param';
  }

  @override
  String get startPosition => 'Utgangsstilling';

  @override
  String get clearBoard => 'Tøm brett';

  @override
  String get loadPosition => 'Last stilling';

  @override
  String get isPrivate => 'Privat';

  @override
  String reportXToModerators(String param) {
    return 'Rapporter $param til moderatorene';
  }

  @override
  String profileCompletion(String param) {
    return 'Profil fullført: $param';
  }

  @override
  String xRating(String param) {
    return '$param rating';
  }

  @override
  String get ifNoneLeaveEmpty => 'Hvis ingen, la stå tom';

  @override
  String get profile => 'Profil';

  @override
  String get editProfile => 'Rediger profil';

  @override
  String get realName => 'Virkelig navn';

  @override
  String get setFlair => 'Velg flair';

  @override
  String get flair => 'Flair';

  @override
  String get youCanHideFlair => 'Det finnes en innstilling for å skjule alle brukerflairer på hele nettstedet.';

  @override
  String get biography => 'Biografi';

  @override
  String get countryRegion => 'Land eller region';

  @override
  String get thankYou => 'Takk!';

  @override
  String get socialMediaLinks => 'Lenker til sosiale medier';

  @override
  String get oneUrlPerLine => 'Én URL per linje.';

  @override
  String get inlineNotation => 'Innebygd notasjon';

  @override
  String get makeAStudy => 'Du kan lage en studie for å bevare og dele trekkene.';

  @override
  String get clearSavedMoves => 'Fjern trekk';

  @override
  String get previouslyOnLichessTV => 'Tidligere på Lichess TV';

  @override
  String get onlinePlayers => 'Påloggede spillere';

  @override
  String get activePlayers => 'Aktive spillere';

  @override
  String get bewareTheGameIsRatedButHasNoClock => 'Legg merke til at partiet er ratet, men ikke tidsbegrenset!';

  @override
  String get success => 'Vellykket';

  @override
  String get automaticallyProceedToNextGameAfterMoving => 'Fortsett automatisk til neste parti etter utført trekk';

  @override
  String get autoSwitch => 'Autosyklus';

  @override
  String get puzzles => 'Sjakknøtter';

  @override
  String get onlineBots => 'Påloggede boter';

  @override
  String get name => 'Navn';

  @override
  String get description => 'Beskrivelse';

  @override
  String get descPrivate => 'Privat beskrivelse';

  @override
  String get descPrivateHelp => 'Tekst som lagmedlemmene ser i stedet for den offentlige beskrivelsen.';

  @override
  String get no => 'Nei';

  @override
  String get yes => 'Ja';

  @override
  String get help => 'Hjelp:';

  @override
  String get createANewTopic => 'Opprett nytt emne';

  @override
  String get topics => 'Emner';

  @override
  String get posts => 'Innlegg';

  @override
  String get lastPost => 'Siste innlegg';

  @override
  String get views => 'Visninger';

  @override
  String get replies => 'Svar';

  @override
  String get replyToThisTopic => 'Svar på dette emnet';

  @override
  String get reply => 'Svar';

  @override
  String get message => 'Melding';

  @override
  String get createTheTopic => 'Opprett emnet';

  @override
  String get reportAUser => 'Rapporter en bruker';

  @override
  String get user => 'Bruker';

  @override
  String get reason => 'Årsak';

  @override
  String get whatIsIheMatter => 'Hva gjelder det?';

  @override
  String get cheat => 'Juks';

  @override
  String get troll => 'Troll';

  @override
  String get other => 'Annet';

  @override
  String get reportDescriptionHelp => 'Kopier lenken til partiet/partiene og forklar hva som er galt med denne brukerens oppførsel.';

  @override
  String get error_provideOneCheatedGameLink => 'Oppgi minst én lenke til et jukseparti.';

  @override
  String by(String param) {
    return 'av $param';
  }

  @override
  String importedByX(String param) {
    return 'Importert av $param';
  }

  @override
  String get thisTopicIsNowClosed => 'Dette emnet er nå lukket.';

  @override
  String get blog => 'Blogg';

  @override
  String get notes => 'Notater';

  @override
  String get typePrivateNotesHere => 'Skriv private notater her';

  @override
  String get writeAPrivateNoteAboutThisUser => 'Skriv et privat notat om denne brukeren';

  @override
  String get noNoteYet => 'Intet notat ennå';

  @override
  String get invalidUsernameOrPassword => 'Ugyldig brukernavn eller passord';

  @override
  String get incorrectPassword => 'Feil passord';

  @override
  String get invalidAuthenticationCode => 'Ugyldig autentiseringskode';

  @override
  String get emailMeALink => 'Send meg en lenke';

  @override
  String get currentPassword => 'Nåværende passord';

  @override
  String get newPassword => 'Nytt passord';

  @override
  String get newPasswordAgain => 'Nytt passord (igjen)';

  @override
  String get newPasswordsDontMatch => 'De nye passordene er ikke like';

  @override
  String get newPasswordStrength => 'Passordstyrke';

  @override
  String get clockInitialTime => 'Starttid på klokken';

  @override
  String get clockIncrement => 'Inkrement';

  @override
  String get privacy => 'Personvern';

  @override
  String get privacyPolicy => 'personvernerklæringen';

  @override
  String get letOtherPlayersFollowYou => 'La andre spillere følge deg';

  @override
  String get letOtherPlayersChallengeYou => 'La andre spillere utfordre deg';

  @override
  String get letOtherPlayersInviteYouToStudy => 'La andre spillere invitere deg til studier';

  @override
  String get sound => 'Lyd';

  @override
  String get none => 'Ingen';

  @override
  String get fast => 'Rask';

  @override
  String get normal => 'Normal';

  @override
  String get slow => 'Sakte';

  @override
  String get insideTheBoard => 'Innenfor brettet';

  @override
  String get outsideTheBoard => 'Utenfor brettet';

  @override
  String get allSquaresOfTheBoard => 'All squares of the board';

  @override
  String get onSlowGames => 'På lange partier';

  @override
  String get always => 'Alltid';

  @override
  String get never => 'Aldri';

  @override
  String xCompetesInY(String param1, String param2) {
    return '$param1 deltar i $param2';
  }

  @override
  String get victory => 'Seier';

  @override
  String get defeat => 'Tap';

  @override
  String victoryVsYInZ(String param1, String param2, String param3) {
    return '$param1 mot $param2 i $param3';
  }

  @override
  String defeatVsYInZ(String param1, String param2, String param3) {
    return '$param1 mot $param2 i $param3';
  }

  @override
  String drawVsYInZ(String param1, String param2, String param3) {
    return '$param1 mot $param2 i $param3';
  }

  @override
  String get timeline => 'Tidslinje';

  @override
  String get starting => 'Starter:';

  @override
  String get allInformationIsPublicAndOptional => 'All informasjon er offentlig og valgfri.';

  @override
  String get biographyDescription => 'Fortell litt om deg selv, hva du liker med sjakk, din favorittåpning, partier, spillere…';

  @override
  String get listBlockedPlayers => 'Vis spillere du har blokkert';

  @override
  String get human => 'Menneske';

  @override
  String get computer => 'Datamaskin';

  @override
  String get side => 'Farge';

  @override
  String get clock => 'Klokke';

  @override
  String get opponent => 'Motstander';

  @override
  String get learnMenu => 'Lær';

  @override
  String get studyMenu => 'Studier';

  @override
  String get practice => 'Øvelser';

  @override
  String get community => 'Fellesskap';

  @override
  String get tools => 'Verktøy';

  @override
  String get increment => 'Tilleggstid';

  @override
  String get error_unknown => 'Ugyldig verdi';

  @override
  String get error_required => 'Dette feltet er påkrevet';

  @override
  String get error_email => 'Denne e-postadressen er ugyldig';

  @override
  String get error_email_acceptable => 'Denne e-postadressen godtas ikke. Dobbeltsjekk den og prøv på nytt.';

  @override
  String get error_email_unique => 'E-postadressen er ugyldig eller allerede registrert';

  @override
  String get error_email_different => 'Dette er allerede e-postadressen din';

  @override
  String error_minLength(String param) {
    return 'Må være minst $param tegn';
  }

  @override
  String error_maxLength(String param) {
    return 'Må være maks $param tegn';
  }

  @override
  String error_min(String param) {
    return 'Må være minst $param';
  }

  @override
  String error_max(String param) {
    return 'Må være maks $param';
  }

  @override
  String ifRatingIsPlusMinusX(String param) {
    return 'Hvis rating er ± $param';
  }

  @override
  String get ifRegistered => 'Hvis registrert';

  @override
  String get onlyExistingConversations => 'Bare eksisterende samtaler';

  @override
  String get onlyFriends => 'Bare venner';

  @override
  String get menu => 'Meny';

  @override
  String get castling => 'Rokade';

  @override
  String get whiteCastlingKingside => 'Hvit 0-0';

  @override
  String get blackCastlingKingside => 'Svart O-O';

  @override
  String tpTimeSpentPlaying(String param) {
    return 'Tid brukt på å spille: $param';
  }

  @override
  String get watchGames => 'Observer partier';

  @override
  String tpTimeSpentOnTV(String param) {
    return 'Tid på TV: $param';
  }

  @override
  String get watch => 'Observer';

  @override
  String get videoLibrary => 'Videobibliotek';

  @override
  String get streamersMenu => 'Strømminger';

  @override
  String get mobileApp => 'Mobilapplikasjon';

  @override
  String get webmasters => 'Webadministratorer';

  @override
  String get about => 'Om';

  @override
  String aboutX(String param) {
    return 'Om $param';
  }

  @override
  String xIsAFreeYLibreOpenSourceChessServer(String param1, String param2) {
    return '$param1 er en fritt tilgjengelig ($param2), libre, annonsefri, åpen kildekode sjakk-server.';
  }

  @override
  String get really => 'virkelig';

  @override
  String get contribute => 'Bidra';

  @override
  String get termsOfService => 'Tjenestevilkår';

  @override
  String get sourceCode => 'Kildekode';

  @override
  String get simultaneousExhibitions => 'Simultanoppvisninger';

  @override
  String get host => 'Vert';

  @override
  String hostColorX(String param) {
    return 'Vertsfarge: $param';
  }

  @override
  String get yourPendingSimuls => 'Dine ventende simultaner';

  @override
  String get createdSimuls => 'Nylig opprettede simultaner';

  @override
  String get hostANewSimul => 'Opprett en simultan';

  @override
  String get signUpToHostOrJoinASimul => 'Registrer deg for å være vert for eller deltaker i en simultan';

  @override
  String get noSimulFound => 'Simultan ikke funnet';

  @override
  String get noSimulExplanation => 'Denne simultanoppvisningen eksisterer ikke.';

  @override
  String get returnToSimulHomepage => 'Returner til simultanhjemmesiden';

  @override
  String get aboutSimul => 'Simultaner består av en enkelt spiller som spiller mot flere spillere samtidig.';

  @override
  String get aboutSimulImage => 'Mot 50 motstandere vant Fischer 47 partier, spilte to remis og tapte ett.';

  @override
  String get aboutSimulRealLife => 'Konseptet er tatt fra virkelige oppvisninger. I disse oppvisningene beveger den som gjør oppvisning seg fra brett til brett for å gjøre enkelttrekk.';

  @override
  String get aboutSimulRules => 'Når simultanen begynner, starter hver spiller et parti med verten. Simultanen avsluttes når alle partiene er ferdige.';

  @override
  String get aboutSimulSettings => 'Simultaner er alltid uformelle. Omkamper, angring og ekstra tid er ikke lov.';

  @override
  String get create => 'Opprett';

  @override
  String get whenCreateSimul => 'Når du oppretter en simultan, får du spille mot flere spillere samtidig.';

  @override
  String get simulVariantsHint => 'Hvis du velger flere varianter får hver spiller anledning til å velge hvilken de vil spille.';

  @override
  String get simulClockHint => 'Fischeroppsett. Desto flere spillere som spiller mot deg, jo mer tid vil du antageligvis trenge.';

  @override
  String get simulAddExtraTime => 'Du kan legge til ekstra tid på klokken din for å makte simultanen.';

  @override
  String get simulHostExtraTime => 'Ekstra tid for verten';

  @override
  String get simulAddExtraTimePerPlayer => 'Legg til ekstra tid på klokken din for hver deltaker.';

  @override
  String get simulHostExtraTimePerPlayer => 'Ekstra tenketid som simultanverten får for hver spiller';

  @override
  String get lichessTournaments => 'Lichessturneringer';

  @override
  String get tournamentFAQ => 'Arenaturneringsspørsmål';

  @override
  String get timeBeforeTournamentStarts => 'Tid før turnering starter';

  @override
  String get averageCentipawnLoss => 'Gjennomsnittlig centibondetap';

  @override
  String get accuracy => 'Presisjon';

  @override
  String get keyboardShortcuts => 'Tastatursnarveier';

  @override
  String get keyMoveBackwardOrForward => 'Gå bakover/fremover';

  @override
  String get keyGoToStartOrEnd => 'Gå til start/slutt';

  @override
  String get keyCycleSelectedVariation => 'Endre valgt variant';

  @override
  String get keyShowOrHideComments => 'Vis/skjul kommentarer';

  @override
  String get keyEnterOrExitVariation => 'Gå inn i/ut av variant';

  @override
  String get keyRequestComputerAnalysis => 'Be om maskinanalyse, lær av feilene dine';

  @override
  String get keyNextLearnFromYourMistakes => 'Neste (lær av feilene dine)';

  @override
  String get keyNextBlunder => 'Neste bukk';

  @override
  String get keyNextMistake => 'Neste feil';

  @override
  String get keyNextInaccuracy => 'Neste unøyaktighet';

  @override
  String get keyPreviousBranch => 'Forrige gren';

  @override
  String get keyNextBranch => 'Neste gren';

  @override
  String get toggleVariationArrows => 'Skru variantpiler av eller på';

  @override
  String get cyclePreviousOrNextVariation => 'Endre til forrige/neste variant';

  @override
  String get toggleGlyphAnnotations => 'Skru symboler i kommentarer av eller på';

  @override
  String get togglePositionAnnotations => 'Skru kommentarer for stillinger av eller på';

  @override
  String get variationArrowsInfo => 'Variantpiler lar deg navigere uten å bruke notasjonslisten.';

  @override
  String get playSelectedMove => 'spill valgt trekk';

  @override
  String get newTournament => 'Ny turnering';

  @override
  String get tournamentHomeTitle => 'Sjakkturneringer med ulike tidskontroller og varianter';

  @override
  String get tournamentHomeDescription => 'Spill fartsfylte sjakkturneringer! Delta i offisielle, faste turneringer eller lag din egen. Lynsjakk, hurtigsjakk, og andre varianter er tilgjengelig for endeløs sjakkunderholdning.';

  @override
  String get tournamentNotFound => 'Finner ikke turneringen';

  @override
  String get tournamentDoesNotExist => 'Turneringen eksisterer ikke.';

  @override
  String get tournamentMayHaveBeenCanceled => 'Den kan ha blitt avlyst fordi alle spillerne trakk seg før den startet.';

  @override
  String get returnToTournamentsHomepage => 'Tilbake til turneringsoversikt';

  @override
  String weeklyPerfTypeRatingDistribution(String param) {
    return 'Ukentlig $param-ratingfordeling';
  }

  @override
  String yourPerfTypeRatingIsRating(String param1, String param2) {
    return '$param1-ratingen din er $param2.';
  }

  @override
  String youAreBetterThanPercentOfPerfTypePlayers(String param1, String param2) {
    return 'Du er bedre enn $param1 av $param2-spillerne.';
  }

  @override
  String userIsBetterThanPercentOfPerfTypePlayers(String param1, String param2, String param3) {
    return '$param1 er bedre enn $param2 av $param3-spillerne.';
  }

  @override
  String betterThanPercentPlayers(String param1, String param2) {
    return 'Bedre enn $param1 av spillerne i $param2';
  }

  @override
  String youDoNotHaveAnEstablishedPerfTypeRating(String param) {
    return 'Du har ikke fått en etablert $param-rating.';
  }

  @override
  String get yourRating => 'Din rating';

  @override
  String get cumulative => 'Akkumulert';

  @override
  String get glicko2Rating => 'Glicko-2-rating';

  @override
  String get checkYourEmail => 'Sjekk e-posten din';

  @override
  String get weHaveSentYouAnEmailClickTheLink => 'Vi har sendt en e-post til deg. Klikk på lenken i e-posten for å aktivere kontoen din.';

  @override
  String get ifYouDoNotSeeTheEmailCheckOtherPlaces => 'Om du ikke ser e-posten, sjekk andre steder den kan være, som søppel, spam, sosial, eller andre mapper.';

  @override
  String weHaveSentYouAnEmailTo(String param) {
    return 'Vi har sendt en e-post til $param. Klikk på lenken i e-posten for å tilbakestille passordet ditt.';
  }

  @override
  String byRegisteringYouAgreeToBeBoundByOur(String param) {
    return 'Ved å registrere deg godtar du våre $param.';
  }

  @override
  String readAboutOur(String param) {
    return 'Les $param vår.';
  }

  @override
  String get networkLagBetweenYouAndLichess => 'Nettverksforsinkelsen mellom deg og lichess';

  @override
  String get timeToProcessAMoveOnLichessServer => 'Tiden det tar å behandle et trekk på lichess-serveren';

  @override
  String get downloadAnnotated => 'Last ned kommentert';

  @override
  String get downloadRaw => 'Last ned rådata';

  @override
  String get downloadImported => 'Last ned importen';

  @override
  String get crosstable => 'Krysstabell';

  @override
  String get youCanAlsoScrollOverTheBoardToMoveInTheGame => 'Du kan også skrolle over brettet for å flytte i partiet.';

  @override
  String get scrollOverComputerVariationsToPreviewThem => 'Hold muspekeren over maskinvarianter for å forhåndsvise dem.';

  @override
  String get analysisShapesHowTo => 'Trykk shift+klikk eller høyreklikk for å tegne sirkler og piler på brettet.';

  @override
  String get letOtherPlayersMessageYou => 'La andre spillere kontakte deg.';

  @override
  String get receiveForumNotifications => 'Bli varslet når nevnt i forumet';

  @override
  String get shareYourInsightsData => 'Del dataene dine for sjakkinnsikt';

  @override
  String get withNobody => 'Med ingen';

  @override
  String get withFriends => 'Med venner';

  @override
  String get withEverybody => 'Med alle';

  @override
  String get kidMode => 'Barnemodus';

  @override
  String get kidModeIsEnabled => 'Barnemodus er aktivert.';

  @override
  String get kidModeExplanation => 'Dette handler om sikkerhet. I barnemodus blir all kommunikasjon skrudd av. Bruk dette for å skjerme barn og skole-elever mot brukere på Internett.';

  @override
  String inKidModeTheLichessLogoGetsIconX(String param) {
    return 'I barnemodus får lichess-logoen et $param symbol, så du vet at barna dine er trygge.';
  }

  @override
  String get askYourChessTeacherAboutLiftingKidMode => 'Kontoen din er forvaltet. Be sjakklæreren din fjerne barnemodus.';

  @override
  String get enableKidMode => 'Skru på barnemodus';

  @override
  String get disableKidMode => 'Skru av barnemodus';

  @override
  String get security => 'Sikkerhet';

  @override
  String get sessions => 'Økter';

  @override
  String get revokeAllSessions => 'lukke alle økter';

  @override
  String get playChessEverywhere => 'Spill sjakk overalt';

  @override
  String get asFreeAsLichess => 'Like gratis som lichess';

  @override
  String get builtForTheLoveOfChessNotMoney => 'Bygget for kjærlighet til sjakk, ikke penger';

  @override
  String get everybodyGetsAllFeaturesForFree => 'Alle får alle funksjoner gratis';

  @override
  String get zeroAdvertisement => 'Ingen reklame';

  @override
  String get fullFeatured => 'Fullspekket';

  @override
  String get phoneAndTablet => 'Mobil og nettbrett';

  @override
  String get bulletBlitzClassical => 'Lyn, hurtig og klassisk';

  @override
  String get correspondenceChess => 'Fjernsjakk';

  @override
  String get onlineAndOfflinePlay => 'Online og offline spill';

  @override
  String get viewTheSolution => 'Se løsning';

  @override
  String get followAndChallengeFriends => 'Følg og utfordre venner';

  @override
  String get gameAnalysis => 'Analyse av parti';

  @override
  String xHostsY(String param1, String param2) {
    return '$param1 opprettet $param2';
  }

  @override
  String xJoinsY(String param1, String param2) {
    return '$param1 ble med på $param2';
  }

  @override
  String xLikesY(String param1, String param2) {
    return '$param1 liker $param2';
  }

  @override
  String get quickPairing => 'Raskt parti';

  @override
  String get lobby => 'Lobby';

  @override
  String get anonymous => 'Anonym';

  @override
  String yourScore(String param) {
    return 'Din poengsum: $param';
  }

  @override
  String get language => 'Språk';

  @override
  String get background => 'Bakgrunn';

  @override
  String get light => 'Lys';

  @override
  String get dark => 'Mørk';

  @override
  String get transparent => 'Gjennomsiktig';

  @override
  String get deviceTheme => 'Enhetstema';

  @override
  String get backgroundImageUrl => 'URL for bakgrunnsbilde:';

  @override
  String get board => 'Brett';

  @override
  String get size => 'Størrelse';

  @override
  String get opacity => 'Ugjennomsiktighet';

  @override
  String get brightness => 'Lysstyrke';

  @override
  String get hue => 'Fargetone';

  @override
  String get boardReset => 'Tilbake til standardfarger';

  @override
  String get pieceSet => 'Brikkesett';

  @override
  String get embedInYourWebsite => 'Bygg inn på nettstedet ditt';

  @override
  String get usernameAlreadyUsed => 'Brukernavnet er allerede i bruk, prøv et annet et.';

  @override
  String get usernamePrefixInvalid => 'Det første tegnet i brukernavnet må være en bokstav.';

  @override
  String get usernameSuffixInvalid => 'Det siste tegnet i brukernavnet må være en bokstav eller et tall.';

  @override
  String get usernameCharsInvalid => 'Brukernavnet kan bare bestå av bokstaver, tall, understrekingstegn og bindestreker. Det er ikke lov med flere understrekingstegn eller bindestreker på rad.';

  @override
  String get usernameUnacceptable => 'Dette brukernavnet er ikke akseptabelt.';

  @override
  String get playChessInStyle => 'Spill sjakk med stil';

  @override
  String get chessBasics => 'Grunnleggende sjakk';

  @override
  String get coaches => 'Trenere';

  @override
  String get invalidPgn => 'Ugyldig PGN';

  @override
  String get invalidFen => 'Ugyldig FEN';

  @override
  String get custom => 'Tilpasset';

  @override
  String get notifications => 'Varsler';

  @override
  String notificationsX(String param1) {
    return 'Varsler: $param1';
  }

  @override
  String perfRatingX(String param) {
    return 'Rating: $param';
  }

  @override
  String get practiceWithComputer => 'Øv med maskinen';

  @override
  String anotherWasX(String param) {
    return 'Et annet var $param';
  }

  @override
  String bestWasX(String param) {
    return 'Best var $param';
  }

  @override
  String get youBrowsedAway => 'Du bladde vekk';

  @override
  String get resumePractice => 'Gjenoppta øving';

  @override
  String get drawByFiftyMoves => 'Partiet er remis etter femtitrekksregelen.';

  @override
  String get theGameIsADraw => 'Partiet er remis.';

  @override
  String get computerThinking => 'Maskinen tenker ...';

  @override
  String get seeBestMove => 'Vis beste trekk';

  @override
  String get hideBestMove => 'Skjul beste trekk';

  @override
  String get getAHint => 'Få et hint';

  @override
  String get evaluatingYourMove => 'Vurderer trekket ditt...';

  @override
  String get whiteWinsGame => 'Hvit vinner';

  @override
  String get blackWinsGame => 'Svart vinner';

  @override
  String get learnFromYourMistakes => 'Lær av dine feil';

  @override
  String get learnFromThisMistake => 'Lær av denne feilen';

  @override
  String get skipThisMove => 'Hopp over dette trekket';

  @override
  String get next => 'Neste';

  @override
  String xWasPlayed(String param) {
    return '$param ble spilt';
  }

  @override
  String get findBetterMoveForWhite => 'Finn et bedre trekk for hvit';

  @override
  String get findBetterMoveForBlack => 'Finn et bedre trekk for svart';

  @override
  String get resumeLearning => 'Fortsett læring';

  @override
  String get youCanDoBetter => 'Du kan gjøre det bedre';

  @override
  String get tryAnotherMoveForWhite => 'Prøv et annet trekk for hvit';

  @override
  String get tryAnotherMoveForBlack => 'Prøv et annet trekk for svart';

  @override
  String get solution => 'Løsning';

  @override
  String get waitingForAnalysis => 'Venter på analyse';

  @override
  String get noMistakesFoundForWhite => 'Ingen feil funnet for hvit';

  @override
  String get noMistakesFoundForBlack => 'Ingen feil funnet for svart';

  @override
  String get doneReviewingWhiteMistakes => 'Ferdig med gjennomgang av hvits feil';

  @override
  String get doneReviewingBlackMistakes => 'Ferdig med gjennomgang av svarts feil';

  @override
  String get doItAgain => 'Gjenta';

  @override
  String get reviewWhiteMistakes => 'Gå gjennom hvits feil';

  @override
  String get reviewBlackMistakes => 'Gå gjennom svarts feil';

  @override
  String get advantage => 'Fordel';

  @override
  String get opening => 'Åpning';

  @override
  String get middlegame => 'Midtspill';

  @override
  String get endgame => 'Sluttspill';

  @override
  String get conditionalPremoves => 'Betingede forhåndstrekk';

  @override
  String get addCurrentVariation => 'Føy til gjeldende variant';

  @override
  String get playVariationToCreateConditionalPremoves => 'Spill en variant for å lage betingede forhåndstrekk';

  @override
  String get noConditionalPremoves => 'Ingen betingede forhåndstrekk';

  @override
  String playX(String param) {
    return 'Spill $param';
  }

  @override
  String get showUnreadLichessMessage => 'Du har mottatt en privat melding fra Lichess.';

  @override
  String get clickHereToReadIt => 'Klikk her for å lese den';

  @override
  String get sorry => 'Beklager :(';

  @override
  String get weHadToTimeYouOutForAWhile => 'Vi måtte gi deg en timeout.';

  @override
  String get why => 'Hvorfor?';

  @override
  String get pleasantChessExperience => 'Vi forsøker å gi alle en god sjakkopplevelse.';

  @override
  String get goodPractice => 'For å oppnå det må vi sikre at alle spillere følger god praksis.';

  @override
  String get potentialProblem => 'Når et potensielt problem oppdages, viser vi denne meldingen.';

  @override
  String get howToAvoidThis => 'Hvordan unngå dette?';

  @override
  String get playEveryGame => 'Spill alle partier du starter.';

  @override
  String get tryToWin => 'Forsøk å vinne (eller i det minste oppnå remis) i alle partier du spiller.';

  @override
  String get resignLostGames => 'Gi opp tapte stillinger (ikke la tiden løpe ut).';

  @override
  String get temporaryInconvenience => 'Vi beklager det midlertidige bryet,';

  @override
  String get wishYouGreatGames => 'og håper du får gode partier på lichess.org.';

  @override
  String get thankYouForReading => 'Takk for at du leste!';

  @override
  String get lifetimeScore => 'Livstidsscore';

  @override
  String get currentMatchScore => 'Gjeldende kampscore';

  @override
  String get agreementAssistance => 'Jeg lover at jeg aldri vil motta hjelp under partiene mine, hverken fra maskiner, bøker, databaser eller andre personer.';

  @override
  String get agreementNice => 'Jeg lover å alltid være høflig mot andre spillere.';

  @override
  String agreementMultipleAccounts(String param) {
    return 'Jeg godtar å ikke opprette flere kontoer (med unntak for grunnene nevnt i våre $param).';
  }

  @override
  String get agreementPolicy => 'Jeg lover å respektere alle Lichess\' retningslinjer.';

  @override
  String get searchOrStartNewDiscussion => 'Søk eller start en ny diskusjon';

  @override
  String get edit => 'Rediger';

  @override
  String get bullet => 'Bullet';

  @override
  String get blitz => 'Blitz';

  @override
  String get rapid => 'Hurtigsjakk';

  @override
  String get classical => 'Klassisk';

  @override
  String get ultraBulletDesc => 'Superraske partier: under 30 sekunder';

  @override
  String get bulletDesc => 'Veldig raske partier: under 3 minutter';

  @override
  String get blitzDesc => 'Raske partier: 3 til 8 minutter';

  @override
  String get rapidDesc => 'Hurtige partier: 8 til 25 minutter';

  @override
  String get classicalDesc => 'Klassiske partier: 25 minutter eller mer';

  @override
  String get correspondenceDesc => 'Fjernsjakkpartier: ett eller flere døgn pr. trekk';

  @override
  String get puzzleDesc => 'Sjakktaktikktrener';

  @override
  String get important => 'Viktig';

  @override
  String yourQuestionMayHaveBeenAnswered(String param1) {
    return 'Spørsmålet ditt har kanskje allerede et svar $param1';
  }

  @override
  String get inTheFAQ => 'i FAQ-en';

  @override
  String toReportSomeoneForCheatingOrBadBehavior(String param1) {
    return 'For å rapportere en bruker for juks eller dårlig oppførsel, $param1';
  }

  @override
  String get useTheReportForm => 'bruk rapportskjemaet';

  @override
  String toRequestSupport(String param1) {
    return 'For å få hjelp, $param1';
  }

  @override
  String get tryTheContactPage => 'prøv kontaktsiden';

  @override
  String makeSureToRead(String param1) {
    return 'Pass på å lese $param1';
  }

  @override
  String get theForumEtiquette => 'forumetiketten';

  @override
  String get thisTopicIsArchived => 'Dette emnet er arkivert og kan ikke lenger besvares.';

  @override
  String joinTheTeamXToPost(String param1) {
    return 'Bli med i $param1 for å skrive innlegg i dette forumet';
  }

  @override
  String teamNamedX(String param1) {
    return 'laget $param1';
  }

  @override
  String get youCannotPostYetPlaySomeGames => 'Du kan ikke skrive innlegg i forumene ennå. Spill noen partier!';

  @override
  String get subscribe => 'Abonner';

  @override
  String get unsubscribe => 'Avslutt abonnement';

  @override
  String mentionedYouInX(String param1) {
    return 'nevnte deg i «$param1».';
  }

  @override
  String xMentionedYouInY(String param1, String param2) {
    return '$param1 nevnte deg i «$param2».';
  }

  @override
  String invitedYouToX(String param1) {
    return 'inviterte deg til «$param1».';
  }

  @override
  String xInvitedYouToY(String param1, String param2) {
    return '$param1 inviterte deg til «$param2».';
  }

  @override
  String get youAreNowPartOfTeam => 'Du er nå med på laget.';

  @override
  String youHaveJoinedTeamX(String param1) {
    return 'Du har blitt med i «$param1».';
  }

  @override
  String get someoneYouReportedWasBanned => 'Noen du rapporterte, ble utestengt';

  @override
  String get congratsYouWon => 'Gratulerer, du vant!';

  @override
  String gameVsX(String param1) {
    return 'Parti mot $param1';
  }

  @override
  String resVsX(String param1, String param2) {
    return '$param1 mot $param2';
  }

  @override
  String get lostAgainstTOSViolator => 'Du tapte ratingpoeng mot noen som brøt vilkårene våre';

  @override
  String refundXpointsTimeControlY(String param1, String param2) {
    return 'Refusjon: $param1 ratingpoeng i $param2.';
  }

  @override
  String get timeAlmostUp => 'Tiden er nesten ute!';

  @override
  String get clickToRevealEmailAddress => '[Klikk for å vise e-postadresse]';

  @override
  String get download => 'Last ned';

  @override
  String get coachManager => 'Innstillinger for trenere';

  @override
  String get streamerManager => 'Innstillinger for strømmere';

  @override
  String get cancelTournament => 'Avlys turneringen';

  @override
  String get tournDescription => 'Turneringsbeskrivelse';

  @override
  String get tournDescriptionHelp => 'Noe du vil si til deltakerne? Vær kortfattet. Markdown-lenker kan brukes: [name](https://url)';

  @override
  String get ratedFormHelp => 'Partiene er ratet\nog påvirker spillernes rating';

  @override
  String get onlyMembersOfTeam => 'Kun lagmedlemmer';

  @override
  String get noRestriction => 'Ingen begrensning';

  @override
  String get minimumRatedGames => 'Minimum ratede partier';

  @override
  String get minimumRating => 'Minimum rating';

  @override
  String get maximumWeeklyRating => 'Maksimum ukerating';

  @override
  String positionInputHelp(String param) {
    return 'Lim inn gyldig FEN for å begynne hvert parti fra gitt stilling.\nDet fungerer bare for standardpartier, ikke for varianter.\nDu kan bruke $param for å generere en FEN-stilling, som du limer inn her.\nLa feltet stå tomt for å begynne partiene fra den normale utgangsstillingen.';
  }

  @override
  String get cancelSimul => 'Avbryt simultanen';

  @override
  String get simulHostcolor => 'Vertsfarge for hvert parti';

  @override
  String get estimatedStart => 'Forventet starttidspunkt';

  @override
  String simulFeatured(String param) {
    return 'Vis på $param';
  }

  @override
  String simulFeaturedHelp(String param) {
    return 'Vis simultanen din til alle på $param. Skru av for private simultaner.';
  }

  @override
  String get simulDescription => 'Beskrivelse av simultanen';

  @override
  String get simulDescriptionHelp => 'Er det noe du vil si til deltakerne?';

  @override
  String markdownAvailable(String param) {
    return '$param er tilgjengelig for utforming.';
  }

  @override
  String get embedsAvailable => 'Lim inn en URL til et parti eller et kapittel i en studie for å bygge det inn.';

  @override
  String get inYourLocalTimezone => 'I tidssonen din';

  @override
  String get tournChat => 'Turneringssamtale';

  @override
  String get noChat => 'Ingen samtale';

  @override
  String get onlyTeamLeaders => 'Bare lagledere';

  @override
  String get onlyTeamMembers => 'Bare lagmedlemmer';

  @override
  String get navigateMoveTree => 'Naviger i trekktreet';

  @override
  String get mouseTricks => 'Musetriks';

  @override
  String get toggleLocalAnalysis => 'Skru av eller på lokal maskinanalyse';

  @override
  String get toggleAllAnalysis => 'Skru av eller på all maskinanalyse';

  @override
  String get playComputerMove => 'Spill det beste maskintrekket';

  @override
  String get analysisOptions => 'Analysevalg';

  @override
  String get focusChat => 'Fokus på samtale';

  @override
  String get showHelpDialog => 'Vis denne hjelpedialogen';

  @override
  String get reopenYourAccount => 'Gjenopprett kontoen din';

  @override
  String get closedAccountChangedMind => 'Hvis du har avsluttet kontoen din og så ombestemt deg, får du én sjanse til å gjenopprette kontoen din.';

  @override
  String get onlyWorksOnce => 'Dette fungerer bare én gang.';

  @override
  String get cantDoThisTwice => 'Hvis du avslutter kontoen din for andre gang, er den tapt for alltid.';

  @override
  String get emailAssociatedToaccount => 'E-postadresse tilknyttet kontoen';

  @override
  String get sentEmailWithLink => 'Vi har sendt deg en e-post med en lenke.';

  @override
  String get tournamentEntryCode => 'Turneringsadgangskode';

  @override
  String get hangOn => 'Vent litt!';

  @override
  String gameInProgress(String param) {
    return 'Du har et parti på gang med $param.';
  }

  @override
  String get abortTheGame => 'Avbryt partiet';

  @override
  String get resignTheGame => 'Gi opp partiet';

  @override
  String get youCantStartNewGame => 'Du kan ikke starte et nytt parti før dette er avsluttet.';

  @override
  String get since => 'Fra';

  @override
  String get until => 'Til';

  @override
  String get lichessDbExplanation => 'Ratede partier spilt hos Lichess';

  @override
  String get switchSides => 'Skift side';

  @override
  String get closingAccountWithdrawAppeal => 'Klagen din blir trukket hvis du stenger kontoen din';

  @override
  String get ourEventTips => 'Tips for arrangementer';

  @override
  String get instructions => 'Instruksjoner';

  @override
  String get showMeEverything => 'Vis meg alt';

  @override
  String get lichessPatronInfo => 'Lichess er en ideell forening, basert på fri programvare med åpen kildekode.\nAlle kostnader for drift, utvikling og innhold finansieres utelukkende av brukerbidrag.';

  @override
  String get nothingToSeeHere => 'Ingenting her for nå.';

  @override
  String opponentLeftCounter(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Motspilleren din har forlatt partiet. Du kan kreve seier om $count sekunder.',
      one: 'Motspilleren din har forlatt partiet. Du kan kreve seier om $count sekund.',
    );
    return '$_temp0';
  }

  @override
  String mateInXHalfMoves(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Matt om $count halvtrekk',
      one: 'Matt om $count halvtrekk',
    );
    return '$_temp0';
  }

  @override
  String nbBlunders(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count bukker',
      one: '$count bukk',
    );
    return '$_temp0';
  }

  @override
  String nbMistakes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count feil',
      one: '$count feil',
    );
    return '$_temp0';
  }

  @override
  String nbInaccuracies(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count unøyaktigheter',
      one: '$count unøyaktighet',
    );
    return '$_temp0';
  }

  @override
  String nbPlayers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count spillere',
      one: '$count spiller',
    );
    return '$_temp0';
  }

  @override
  String nbGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count partier',
      one: '$count parti',
    );
    return '$_temp0';
  }

  @override
  String ratingXOverYGames(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count-rating over $param2 partier',
      one: '$count-rating over $param2 parti',
    );
    return '$_temp0';
  }

  @override
  String nbBookmarks(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count bokmerker',
      one: '$count bokmerke',
    );
    return '$_temp0';
  }

  @override
  String nbDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count dager',
      one: '$count dag',
    );
    return '$_temp0';
  }

  @override
  String nbHours(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count timer',
      one: '$count time',
    );
    return '$_temp0';
  }

  @override
  String nbMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count minutter',
      one: '$count minutt',
    );
    return '$_temp0';
  }

  @override
  String rankIsUpdatedEveryNbMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Rangeringen blir oppdatert hvert $count. minutt',
      one: 'Rangeringen blir oppdatert hvert minutt',
    );
    return '$_temp0';
  }

  @override
  String nbPuzzles(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count nøtter',
      one: '$count nøtt',
    );
    return '$_temp0';
  }

  @override
  String nbGamesWithYou(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count partier mot deg',
      one: '$count partier mot deg',
    );
    return '$_temp0';
  }

  @override
  String nbRated(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ratede',
      one: '$count ratet',
    );
    return '$_temp0';
  }

  @override
  String nbWins(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count seire',
      one: '$count seier',
    );
    return '$_temp0';
  }

  @override
  String nbLosses(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count tap',
      one: '$count tap',
    );
    return '$_temp0';
  }

  @override
  String nbDraws(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count remis',
      one: '$count remis',
    );
    return '$_temp0';
  }

  @override
  String nbPlaying(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count pågår',
      one: '$count pågår',
    );
    return '$_temp0';
  }

  @override
  String giveNbSeconds(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Gi $count sekunder',
      one: 'Gi $count sekund',
    );
    return '$_temp0';
  }

  @override
  String nbTournamentPoints(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count turneringspoeng',
      one: '$count turneringspoeng',
    );
    return '$_temp0';
  }

  @override
  String nbStudies(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count studier',
      one: '$count studie',
    );
    return '$_temp0';
  }

  @override
  String nbSimuls(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count simultaner',
      one: '$count simultan',
    );
    return '$_temp0';
  }

  @override
  String moreThanNbRatedGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '≥ $count ratede partier',
      one: '≥ $count ratet parti',
    );
    return '$_temp0';
  }

  @override
  String moreThanNbPerfRatedGames(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '≥ $count ratede $param2-partier',
      one: '≥ $count ratet $param2-parti',
    );
    return '$_temp0';
  }

  @override
  String needNbMorePerfGames(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Du må spille enda $count ratede $param2-partier',
      one: 'Du må spille enda $count ratet $param2-parti',
    );
    return '$_temp0';
  }

  @override
  String needNbMoreGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Du må spille enda $count ratede partier',
      one: 'Du må spille enda $count ratet parti',
    );
    return '$_temp0';
  }

  @override
  String nbImportedGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count importerte partier',
      one: '$count importert parti',
    );
    return '$_temp0';
  }

  @override
  String nbFriendsOnline(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count venner online',
      one: '$count venn online',
    );
    return '$_temp0';
  }

  @override
  String nbFollowers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count følgere',
      one: '$count følger',
    );
    return '$_temp0';
  }

  @override
  String nbFollowing(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'følger $count',
      one: '$count følger',
    );
    return '$_temp0';
  }

  @override
  String lessThanNbMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Mindre enn $count minutter',
      one: 'Mindre enn $count minutter',
    );
    return '$_temp0';
  }

  @override
  String nbGamesInPlay(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count partier spilles',
      one: '$count parti spilles',
    );
    return '$_temp0';
  }

  @override
  String maximumNbCharacters(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Maksimum: $count bokstaver.',
      one: 'Maksimum: $count bokstav.',
    );
    return '$_temp0';
  }

  @override
  String blocks(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count blokkeringer',
      one: '$count blokkering',
    );
    return '$_temp0';
  }

  @override
  String nbForumPosts(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Foruminnlegg',
      one: '$count Foruminnlegg',
    );
    return '$_temp0';
  }

  @override
  String nbPerfTypePlayersThisWeek(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count $param2-spillere denne uken.',
      one: '$count $param2-spiller denne uken.',
    );
    return '$_temp0';
  }

  @override
  String availableInNbLanguages(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Tilgjengelig på $count språk!',
      one: 'Tilgjengelig på $count språk!',
    );
    return '$_temp0';
  }

  @override
  String nbSecondsToPlayTheFirstMove(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count sekunder til å ta det første trekket',
      one: '$count sekund til å ta det første trekket',
    );
    return '$_temp0';
  }

  @override
  String nbSeconds(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count sekunder',
      one: '$count sekund',
    );
    return '$_temp0';
  }

  @override
  String andSaveNbPremoveLines(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'og lagre $count forhåndstrekkvarianter',
      one: 'og lagre $count forhåndstrekkvariant',
    );
    return '$_temp0';
  }

  @override
  String get stormMoveToStart => 'Trekk for å begynne';

  @override
  String get stormYouPlayTheWhitePiecesInAllPuzzles => 'Du spiller med de hvite brikkene i alle sjakknøttene';

  @override
  String get stormYouPlayTheBlackPiecesInAllPuzzles => 'Du spiller med de svarte brikkene i alle sjakknøttene';

  @override
  String get stormPuzzlesSolved => 'sjakknøtter løst';

  @override
  String get stormNewDailyHighscore => 'Ny rekord for dagen!';

  @override
  String get stormNewWeeklyHighscore => 'Ny rekord for uken!';

  @override
  String get stormNewMonthlyHighscore => 'Ny rekord for måneden!';

  @override
  String get stormNewAllTimeHighscore => 'Ny rekord noensinne!';

  @override
  String stormPreviousHighscoreWasX(String param) {
    return 'Forrige rekord var $param';
  }

  @override
  String get stormPlayAgain => 'Spill igjen';

  @override
  String stormHighscoreX(String param) {
    return 'Rekord: $param';
  }

  @override
  String get stormScore => 'Poengsum';

  @override
  String get stormMoves => 'Trekk';

  @override
  String get stormAccuracy => 'Presisjon';

  @override
  String get stormCombo => 'Kombo';

  @override
  String get stormTime => 'Tid';

  @override
  String get stormTimePerMove => 'Tid per trekk';

  @override
  String get stormHighestSolved => 'Beste løsning';

  @override
  String get stormPuzzlesPlayed => 'Spilte sjakknøtter';

  @override
  String get stormNewRun => 'Ny runde (hurtigtast: mellomrom)';

  @override
  String get stormEndRun => 'Avslutt runden (hurtigtast: linjeskift)';

  @override
  String get stormHighscores => 'Rekorder';

  @override
  String get stormViewBestRuns => 'Vis beste runder';

  @override
  String get stormBestRunOfDay => 'Dagens beste runde';

  @override
  String get stormRuns => 'Runder';

  @override
  String get stormGetReady => 'Gjør deg klar!';

  @override
  String get stormWaitingForMorePlayers => 'Venter på flere deltakere...';

  @override
  String get stormRaceComplete => 'Løpet er fullført!';

  @override
  String get stormSpectating => 'Tilskuer';

  @override
  String get stormJoinTheRace => 'Delta i løpet!';

  @override
  String get stormStartTheRace => 'Start løpet';

  @override
  String stormYourRankX(String param) {
    return 'Din plassering: $param';
  }

  @override
  String get stormWaitForRematch => 'Vent på nytt løp';

  @override
  String get stormNextRace => 'Neste løp';

  @override
  String get stormJoinRematch => 'Delta i nytt løp';

  @override
  String get stormWaitingToStart => 'Venter på start';

  @override
  String get stormCreateNewGame => 'Lag et nytt løp';

  @override
  String get stormJoinPublicRace => 'Delta i et offentlig løp';

  @override
  String get stormRaceYourFriends => 'Prøv deg mot vennene dine';

  @override
  String get stormSkip => 'hopp over';

  @override
  String get stormSkipHelp => 'Du kan hoppe over ett trekk for hvert løp:';

  @override
  String get stormSkipExplanation => 'Hopp over dette trekket for å bevare komboen din! Funker bare én gang for hvert løp.';

  @override
  String get stormFailedPuzzles => 'Mislykkede sjakknøtter';

  @override
  String get stormSlowPuzzles => 'Trege sjakknøtter';

  @override
  String get stormSkippedPuzzle => 'Sjakknøtt som ble hoppet over';

  @override
  String get stormThisWeek => 'Denne uken';

  @override
  String get stormThisMonth => 'Denne måneden';

  @override
  String get stormAllTime => 'Noensinne';

  @override
  String get stormClickToReload => 'Klikk for å laste inn på nytt';

  @override
  String get stormThisRunHasExpired => 'Denne runden er utløpt!';

  @override
  String get stormThisRunWasOpenedInAnotherTab => 'Denne runden ble åpnet i en annen fane!';

  @override
  String stormXRuns(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count runder',
      one: '1 runde',
    );
    return '$_temp0';
  }

  @override
  String stormPlayedNbRunsOfPuzzleStorm(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Har spilt $count runder med $param2',
      one: 'Har spilt én runde med $param2',
    );
    return '$_temp0';
  }

  @override
  String get streamerLichessStreamers => 'Lichess-strømmere';

  @override
  String get studyShareAndExport => 'Del og eksporter';

  @override
  String get studyStart => 'Start';
}
