import 'package:intl/intl.dart' as intl;

import 'l10n.dart';

/// The translations for Danish (`da`).
class AppLocalizationsDa extends AppLocalizations {
  AppLocalizationsDa([String locale = 'da']) : super(locale);

  @override
  String get mobileHomeTab => 'Hjem';

  @override
  String get mobilePuzzlesTab => 'Opgaver';

  @override
  String get mobileToolsTab => 'Værktøjer';

  @override
  String get mobileWatchTab => 'Se';

  @override
  String get mobileSettingsTab => 'Indstillinger';

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
  String get activityHostedALiveStream => 'Hostede en livestream';

  @override
  String activityRankedInSwissTournament(String param1, String param2) {
    return 'Rangeret #$param1 i $param2';
  }

  @override
  String get activitySignedUp => 'Tilmeldte sig lichess.org';

  @override
  String activitySupportedNbMonths(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Har støttet lichess.org i $count måneder som en $param2',
      one: 'Har støttet lichess.org i $count måneder som en $param2',
    );
    return '$_temp0';
  }

  @override
  String activityPracticedNbPositions(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Øvede $count stillinger i $param2',
      one: 'Øvede $count stilling i $param2',
    );
    return '$_temp0';
  }

  @override
  String activitySolvedNbPuzzles(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Løste $count taktiske opgaver',
      one: 'Løste $count taktisk opgave',
    );
    return '$_temp0';
  }

  @override
  String activityPlayedNbGames(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Spillede $count $param2 partier',
      one: 'Spillede $count $param2 parti',
    );
    return '$_temp0';
  }

  @override
  String activityPostedNbMessages(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Lavede $count indlæg i $param2',
      one: 'Lavede $count indlæg i $param2',
    );
    return '$_temp0';
  }

  @override
  String activityPlayedNbMoves(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Spillede $count træk',
      one: 'Spillede $count træk',
    );
    return '$_temp0';
  }

  @override
  String activityInNbCorrespondenceGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'i $count korrespondancepartier',
      one: 'i $count korrespondanceparti',
    );
    return '$_temp0';
  }

  @override
  String activityCompletedNbGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Afsluttede $count korrespondancepartier',
      one: 'Afsluttede $count korrespondanceparti',
    );
    return '$_temp0';
  }

  @override
  String activityFollowedNbPlayers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Begyndte at følge $count spillere',
      one: 'Begyndte at følge $count spiller',
    );
    return '$_temp0';
  }

  @override
  String activityGainedNbFollowers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Fik $count nye følgere',
      one: 'Fik $count ny følger',
    );
    return '$_temp0';
  }

  @override
  String activityHostedNbSimuls(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Var vært for $count simultanskakarrangementer',
      one: 'Var vært for $count simultanskakarrangement',
    );
    return '$_temp0';
  }

  @override
  String activityJoinedNbSimuls(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Deltog i $count simultanskakarrangementer',
      one: 'Deltog i $count simultanskakarrangement',
    );
    return '$_temp0';
  }

  @override
  String activityCreatedNbStudies(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Oprettede $count nye studier',
      one: 'Oprettede $count nyt studie',
    );
    return '$_temp0';
  }

  @override
  String activityCompetedInNbTournaments(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Deltog i $count turneringer',
      one: 'Deltog i $count turnering',
    );
    return '$_temp0';
  }

  @override
  String activityRankedInTournament(int count, String param2, String param3, String param4) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Rangeret #$count (top $param2%) med $param3 partier i $param4',
      one: 'Rangeret #$count (top $param2%) med $param3 parti i $param4',
    );
    return '$_temp0';
  }

  @override
  String activityCompetedInNbSwissTournaments(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Deltog i $count schweizerturneringer',
      one: 'Deltog i $count schweizerturnering',
    );
    return '$_temp0';
  }

  @override
  String activityJoinedNbTeams(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Blev medlem af $count hold',
      one: 'Blev medlem af $count hold',
    );
    return '$_temp0';
  }

  @override
  String get broadcastBroadcasts => 'Udsendelser';

  @override
  String get broadcastLiveBroadcasts => 'Live turnerings-udsendelser';

  @override
  String challengeChallengesX(String param1) {
    return 'Udfordringer: $param1';
  }

  @override
  String get challengeChallengeToPlay => 'Udfordr til et spil';

  @override
  String get challengeChallengeDeclined => 'Udfordring afvist';

  @override
  String get challengeChallengeAccepted => 'Udfordring accepteret!';

  @override
  String get challengeChallengeCanceled => 'Udfordring annulleret.';

  @override
  String get challengeRegisterToSendChallenges => 'Opret en konto for at sende udfordringer.';

  @override
  String challengeYouCannotChallengeX(String param) {
    return 'Du kan ikke udfordre $param.';
  }

  @override
  String challengeXDoesNotAcceptChallenges(String param) {
    return '$param accepterer ikke udfordringer.';
  }

  @override
  String challengeYourXRatingIsTooFarFromY(String param1, String param2) {
    return 'Din $param1 rating er for langt fra $param2.';
  }

  @override
  String challengeCannotChallengeDueToProvisionalXRating(String param) {
    return 'Kan ikke udfordre på grund af provisorisk $param rating.';
  }

  @override
  String challengeXOnlyAcceptsChallengesFromFriends(String param) {
    return '$param accepterer kun udfordringer fra venner.';
  }

  @override
  String get challengeDeclineGeneric => 'Jeg accepterer ikke udfordringer i øjeblikket.';

  @override
  String get challengeDeclineLater => 'Det er ikke et godt tidspunkt for mig, spørg gerne igen senere.';

  @override
  String get challengeDeclineTooFast => 'Denne tidskontrol er for hurtig for mig. Udfordr mig gerne igen med et langsommere spil.';

  @override
  String get challengeDeclineTooSlow => 'Denne tidskontrol er for langsom for mig. Udfordr mig gerne igen med et hurtigere spil.';

  @override
  String get challengeDeclineTimeControl => 'Jeg accepterer ikke udfordringer med denne tidskontrol.';

  @override
  String get challengeDeclineRated => 'Send mig gerne en ratet udfordring i stedet.';

  @override
  String get challengeDeclineCasual => 'Send mig gerne en ikke-ratet udfordring i stedet.';

  @override
  String get challengeDeclineStandard => 'Jeg accepterer ikke variantudfordringer lige nu.';

  @override
  String get challengeDeclineVariant => 'Jeg er ikke villig til at spille denne variant lige nu.';

  @override
  String get challengeDeclineNoBot => 'Jeg accepterer ikke udfordringer fra bots.';

  @override
  String get challengeDeclineOnlyBot => 'Jeg accepterer kun udfordringer fra bots.';

  @override
  String get challengeInviteLichessUser => 'Eller inviter en Lichess-bruger:';

  @override
  String get contactContact => 'Kontakt';

  @override
  String get contactContactLichess => 'Kontakt Lichess';

  @override
  String get patronDonate => 'Donér';

  @override
  String get patronLichessPatron => 'Lichess Protektor';

  @override
  String perfStatPerfStats(String param) {
    return '$param statistik';
  }

  @override
  String get perfStatViewTheGames => 'Se partierne';

  @override
  String get perfStatProvisional => 'provisorisk';

  @override
  String get perfStatNotEnoughRatedGames => 'Der er ikke spillet nok ratede partier til at fastlægge en pålidelig rating.';

  @override
  String perfStatProgressOverLastXGames(String param) {
    return 'Udvikling over de sidste $param partier:';
  }

  @override
  String perfStatRatingDeviation(String param) {
    return 'Rating afvigelse: $param.';
  }

  @override
  String perfStatRatingDeviationTooltip(String param1, String param2, String param3) {
    return 'Lavere værdi betyder, at ratingen er mere stabil. Over $param1 anses ratingen for foreløbig. For at blive inkluderet i rangeringen skal denne værdi være under $param2 (standard skak) eller $param3 (varianter).';
  }

  @override
  String get perfStatTotalGames => 'Alle partier';

  @override
  String get perfStatRatedGames => 'Ratede partier';

  @override
  String get perfStatTournamentGames => 'Turneringspartier';

  @override
  String get perfStatBerserkedGames => 'Bersærkede partier';

  @override
  String get perfStatTimeSpentPlaying => 'Tid brugt på at spille';

  @override
  String get perfStatAverageOpponent => 'Gennemsnitlig modstander';

  @override
  String get perfStatVictories => 'Sejre';

  @override
  String get perfStatDefeats => 'Nederlag';

  @override
  String get perfStatDisconnections => 'Afbrydelser af forbindelse';

  @override
  String get perfStatNotEnoughGames => 'Ikke nok partier spillet';

  @override
  String perfStatHighestRating(String param) {
    return 'Højeste rating: $param';
  }

  @override
  String perfStatLowestRating(String param) {
    return 'Laveste rating: $param';
  }

  @override
  String perfStatFromXToY(String param1, String param2) {
    return 'fra $param1 til $param2';
  }

  @override
  String get perfStatWinningStreak => 'Sejrsstime';

  @override
  String get perfStatLosingStreak => 'Tabsstime';

  @override
  String perfStatLongestStreak(String param) {
    return 'Længste stime: $param';
  }

  @override
  String perfStatCurrentStreak(String param) {
    return 'Aktuel stime: $param';
  }

  @override
  String get perfStatBestRated => 'Bedst ratede sejre';

  @override
  String get perfStatGamesInARow => 'Partier spillet i træk';

  @override
  String get perfStatLessThanOneHour => 'Mindre end en time mellem partier';

  @override
  String get perfStatMaxTimePlaying => 'Maks tid brugt på at spille';

  @override
  String get perfStatNow => 'nu';

  @override
  String get preferencesPreferences => 'Indstillinger';

  @override
  String get preferencesDisplay => 'Udseende';

  @override
  String get preferencesPrivacy => 'Privatliv';

  @override
  String get preferencesNotifications => 'Notifikationer';

  @override
  String get preferencesPieceAnimation => 'Animation af brikkerne';

  @override
  String get preferencesMaterialDifference => 'Materialeforskel';

  @override
  String get preferencesBoardHighlights => 'Fremhævninger på brættet (af sidste træk og skak)';

  @override
  String get preferencesPieceDestinations => 'Brikdestinationer (gyldige træk og forhånds-træk)';

  @override
  String get preferencesBoardCoordinates => 'Brætkoordinater (A-H, 1-8)';

  @override
  String get preferencesMoveListWhilePlaying => 'Trækliste mens der spilles';

  @override
  String get preferencesPgnPieceNotation => 'Notation';

  @override
  String get preferencesChessPieceSymbol => 'Skakbrik-symbol';

  @override
  String get preferencesPgnLetter => 'Bogstaver (K, Q, R, B, N)';

  @override
  String get preferencesZenMode => 'Zentilstand';

  @override
  String get preferencesShowPlayerRatings => 'Vis spilleres ratings';

  @override
  String get preferencesShowFlairs => 'Vis spilleres ikoner';

  @override
  String get preferencesExplainShowPlayerRatings => 'Dette gør det muligt at skjule alle ratings på hjemmesiden, så du kan fokusere på skakspillet. Partier kan stadig være ratede, det handler kun om, hvad du får at se.';

  @override
  String get preferencesDisplayBoardResizeHandle => 'Vis brætstørrelse justering';

  @override
  String get preferencesOnlyOnInitialPosition => 'Kun ved indledende position';

  @override
  String get preferencesInGameOnly => 'Kun i spillet';

  @override
  String get preferencesChessClock => 'Skakur';

  @override
  String get preferencesTenthsOfSeconds => 'Tiendedele sekunder';

  @override
  String get preferencesWhenTimeRemainingLessThanTenSeconds => 'Når resterende tid < 10 sekunder';

  @override
  String get preferencesHorizontalGreenProgressBars => 'Horisontale grønne statuslinjer';

  @override
  String get preferencesSoundWhenTimeGetsCritical => 'Lyd, når tiden bliver kritisk';

  @override
  String get preferencesGiveMoreTime => 'Give mere tid';

  @override
  String get preferencesGameBehavior => 'Spiladfærd';

  @override
  String get preferencesHowDoYouMovePieces => 'Hvordan flytter du brikker?';

  @override
  String get preferencesClickTwoSquares => 'Klik på to felter';

  @override
  String get preferencesDragPiece => 'Træk brik';

  @override
  String get preferencesBothClicksAndDrag => 'Begge dele';

  @override
  String get preferencesPremovesPlayingDuringOpponentTurn => 'Forhåndstræk (spilles på modstanderens tur)';

  @override
  String get preferencesTakebacksWithOpponentApproval => 'Fortrydelse af træk (med modstanderens accept)';

  @override
  String get preferencesInCasualGamesOnly => 'Kun i ikke-ratede spil';

  @override
  String get preferencesPromoteToQueenAutomatically => 'Forfrem til Dronning automatisk';

  @override
  String get preferencesExplainPromoteToQueenAutomatically => 'Hold <ctrl>-tasten nede, mens du forfremmer for midlertidigt at deaktivere auto-forfremmelse';

  @override
  String get preferencesWhenPremoving => 'Ved forhåndstræk';

  @override
  String get preferencesClaimDrawOnThreefoldRepetitionAutomatically => 'Kræv automatisk remis ved trækgentagelse';

  @override
  String get preferencesWhenTimeRemainingLessThanThirtySeconds => 'Når tilbageværende tid < 30 sekunder';

  @override
  String get preferencesMoveConfirmation => 'Bekræft træk';

  @override
  String get preferencesExplainCanThenBeTemporarilyDisabled => 'Kan deaktiveres i løbet af et parti med brætmenuen';

  @override
  String get preferencesInCorrespondenceGames => 'I korrespondancepartier';

  @override
  String get preferencesCorrespondenceAndUnlimited => 'Korrespondance og ubegrænset';

  @override
  String get preferencesConfirmResignationAndDrawOffers => 'Bekræft opgivelse og tilbud om remis';

  @override
  String get preferencesCastleByMovingTheKingTwoSquaresOrOntoTheRook => 'Rokade-metode';

  @override
  String get preferencesCastleByMovingTwoSquares => 'Flyt kongen to felter';

  @override
  String get preferencesCastleByMovingOntoTheRook => 'Flyt kongen over på tårn';

  @override
  String get preferencesInputMovesWithTheKeyboard => 'Lav træk med tastaturet';

  @override
  String get preferencesInputMovesWithVoice => 'Angiv træk med din stemme';

  @override
  String get preferencesSnapArrowsToValidMoves => 'Markér lovlige træk med pile';

  @override
  String get preferencesSayGgWpAfterLosingOrDrawing => 'Sig \"Good game, well played\" (Godt parti, godt spillet) ved nederlag eller remis';

  @override
  String get preferencesYourPreferencesHaveBeenSaved => 'Dine præferencer er blevet gemt.';

  @override
  String get preferencesScrollOnTheBoardToReplayMoves => 'Brug musens scrollhjul på brættet for at afspille træk';

  @override
  String get preferencesCorrespondenceEmailNotification => 'Daglig e-mailnotifikation med dine korrespondance-spil';

  @override
  String get preferencesNotifyStreamStart => 'Streamer går live';

  @override
  String get preferencesNotifyInboxMsg => 'Ny besked i indbakke';

  @override
  String get preferencesNotifyForumMention => 'Kommentar i forum nævner dig';

  @override
  String get preferencesNotifyInvitedStudy => 'Invitation til studie';

  @override
  String get preferencesNotifyGameEvent => 'Opdateringer af korrespondancepartier';

  @override
  String get preferencesNotifyChallenge => 'Udfordringer';

  @override
  String get preferencesNotifyTournamentSoon => 'Turneringsstart nærmer sig';

  @override
  String get preferencesNotifyTimeAlarm => 'Ur i korrespondance er ved at løbe ud';

  @override
  String get preferencesNotifyBell => 'Klokkenotifikation i Lichess';

  @override
  String get preferencesNotifyPush => 'Notifikation på enhed, når du ikke er på Lichess';

  @override
  String get preferencesNotifyWeb => 'Browser';

  @override
  String get preferencesNotifyDevice => 'Enhed';

  @override
  String get preferencesBellNotificationSound => 'Notifikationslyd';

  @override
  String get puzzlePuzzles => 'Taktikopgaver';

  @override
  String get puzzlePuzzleThemes => 'Opgavetemaer';

  @override
  String get puzzleRecommended => 'Anbefalet';

  @override
  String get puzzlePhases => 'Faser';

  @override
  String get puzzleMotifs => 'Motiv';

  @override
  String get puzzleAdvanced => 'Avanceret';

  @override
  String get puzzleLengths => 'Længder';

  @override
  String get puzzleMates => 'Matter';

  @override
  String get puzzleGoals => 'Mål';

  @override
  String get puzzleOrigin => 'Oprindelse';

  @override
  String get puzzleSpecialMoves => 'Særlige træk';

  @override
  String get puzzleDidYouLikeThisPuzzle => 'Kunne du lide denne opgave?';

  @override
  String get puzzleVoteToLoadNextOne => 'Stem for at indlæse den næste!';

  @override
  String get puzzleUpVote => 'Stem opgave op';

  @override
  String get puzzleDownVote => 'Stem opgave ned';

  @override
  String get puzzleYourPuzzleRatingWillNotChange => 'Din opgave-rating vil ikke ændre sig. Bemærk at opgaver ikke er en konkurrence. Rating hjælper med at vælge de bedste opgaver i forhold til dine nuværende færdigheder.';

  @override
  String get puzzleFindTheBestMoveForWhite => 'Find det bedste træk for hvid.';

  @override
  String get puzzleFindTheBestMoveForBlack => 'Find det bedste træk for sort.';

  @override
  String get puzzleToGetPersonalizedPuzzles => 'For at få personlige taktikopgaver:';

  @override
  String puzzlePuzzleId(String param) {
    return 'Taktikopgave $param';
  }

  @override
  String get puzzlePuzzleOfTheDay => 'Dagens opgave';

  @override
  String get puzzleDailyPuzzle => 'Daglig taktikopgave';

  @override
  String get puzzleClickToSolve => 'Klik for at løse';

  @override
  String get puzzleGoodMove => 'Godt træk';

  @override
  String get puzzleBestMove => 'Bedste træk!';

  @override
  String get puzzleKeepGoing => 'Bliv ved…';

  @override
  String get puzzlePuzzleSuccess => 'Korrekt!';

  @override
  String get puzzlePuzzleComplete => 'Taktikpgave løst!';

  @override
  String get puzzleByOpenings => 'Efter åbninger';

  @override
  String get puzzlePuzzlesByOpenings => 'Taktikopgaver efter åbninger';

  @override
  String get puzzleOpeningsYouPlayedTheMost => 'Åbninger du har spillet mest i ratede partier';

  @override
  String get puzzleUseFindInPage => 'Brug \"Find på side\" i browsermenuen til at finde din foretrukne åbning!';

  @override
  String get puzzleUseCtrlF => 'Brug Ctrl+f til at finde din foretrukne åbning!';

  @override
  String get puzzleNotTheMove => 'Ikke det rigtige træk!';

  @override
  String get puzzleTrySomethingElse => 'Prøv noget andet.';

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
  String get puzzleContinueTraining => 'Fortsæt træning';

  @override
  String get puzzleDifficultyLevel => 'Sværhedsgrad';

  @override
  String get puzzleNormal => 'Normal';

  @override
  String get puzzleEasier => 'Nemmere';

  @override
  String get puzzleEasiest => 'Nemmest';

  @override
  String get puzzleHarder => 'Sværere';

  @override
  String get puzzleHardest => 'Sværest';

  @override
  String get puzzleExample => 'Eksempel';

  @override
  String get puzzleAddAnotherTheme => 'Tilføj et andet tema';

  @override
  String get puzzleNextPuzzle => 'Næste taktikopgave';

  @override
  String get puzzleJumpToNextPuzzleImmediately => 'Spring straks videre til næste taktikopgave';

  @override
  String get puzzlePuzzleDashboard => 'Opgave-kontrolpanel';

  @override
  String get puzzleImprovementAreas => 'Forbedringsområder';

  @override
  String get puzzleStrengths => 'Styrke';

  @override
  String get puzzleHistory => 'Opgavehistorik';

  @override
  String get puzzleSolved => 'løst';

  @override
  String get puzzleFailed => 'mislykket';

  @override
  String get puzzleStreakDescription => 'Løs taktikopgaver af stigende sværhedsgrad og opbyg en sejrsstime. Der er intet ur, så tag dig god tid. Ét forkert træk og spillet er ovre! Men du kan springe ét træk over per session.';

  @override
  String puzzleYourStreakX(String param) {
    return 'Din stime: $param';
  }

  @override
  String get puzzleStreakSkipExplanation => 'Spring dette træk over for at bevare din stime! Virker kun én gang per gennemløb.';

  @override
  String get puzzleContinueTheStreak => 'Fortsæt stimen';

  @override
  String get puzzleNewStreak => 'Ny stime';

  @override
  String get puzzleFromMyGames => 'Fra mine partier';

  @override
  String get puzzleLookupOfPlayer => 'Søg taktikopgaver fra en spillers partier';

  @override
  String puzzleFromXGames(String param) {
    return 'Taktikopgaver fra $param\' partier';
  }

  @override
  String get puzzleSearchPuzzles => 'Søg taktikopgaver';

  @override
  String get puzzleFromMyGamesNone => 'Du har ingen taktikopgaver i databasen, men Lichess elsker dig alligevel.\nSpil hurtige (rapid) og klassiske (classical) partier for at forøge chancerne for at en af dine taktikopgave tilføjes!';

  @override
  String puzzleFromXGamesFound(String param1, String param2) {
    return '$param1 taktikopgaver fundet i $param2 partier';
  }

  @override
  String get puzzlePuzzleDashboardDescription => 'Træn, analysér, forbedr';

  @override
  String puzzlePercentSolved(String param) {
    return '$param løst';
  }

  @override
  String get puzzleNoPuzzlesToShow => 'Intet at vise, løs først nogle opgaver!';

  @override
  String get puzzleImprovementAreasDescription => 'Træn disse for at optimere dine fremskridt!';

  @override
  String get puzzleStrengthDescription => 'Du klarer dig bedst i disse temaer';

  @override
  String puzzlePlayedXTimes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Spillet $count gange',
      one: 'Spillet $count gang',
    );
    return '$_temp0';
  }

  @override
  String puzzleNbPointsBelowYourPuzzleRating(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count points under din opgave-rating',
      one: 'Ét point under din opgave-rating',
    );
    return '$_temp0';
  }

  @override
  String puzzleNbPointsAboveYourPuzzleRating(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count points over din opgave-rating',
      one: 'Ét point over din opgave-rating',
    );
    return '$_temp0';
  }

  @override
  String puzzleNbPlayed(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count spillede',
      one: '$count spillet',
    );
    return '$_temp0';
  }

  @override
  String puzzleNbToReplay(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count at spille igen',
      one: '$count at spille igen',
    );
    return '$_temp0';
  }

  @override
  String get puzzleThemeAdvancedPawn => 'Fremskudt bonde';

  @override
  String get puzzleThemeAdvancedPawnDescription => 'En bonde, der forvandles eller truer med at forvandle, er nøglen til taktikken.';

  @override
  String get puzzleThemeAdvantage => 'Fordel';

  @override
  String get puzzleThemeAdvantageDescription => 'Grib chancen for at få en afgørende fordel. (200cb ≤ eval ≤ 600cb)';

  @override
  String get puzzleThemeAnastasiaMate => 'Anastasias mat';

  @override
  String get puzzleThemeAnastasiaMateDescription => 'En springer og et tårn eller en dronning går sammen om at fange modstanderens konge mellem side af brættet og en venligsindet brik.';

  @override
  String get puzzleThemeArabianMate => 'Arabisk mat';

  @override
  String get puzzleThemeArabianMateDescription => 'En springer og et tårn samarbejder om at fange modstanderens konge i et af brættets hjørner.';

  @override
  String get puzzleThemeAttackingF2F7 => 'Angreb på f2 eller f7';

  @override
  String get puzzleThemeAttackingF2F7Description => 'Et angreb som er fokuseret på f2 eller f7 bonden, som det kendes fra Fegatello-angrebet (\"Fried Liver Attack\").';

  @override
  String get puzzleThemeAttraction => 'Lokkedue';

  @override
  String get puzzleThemeAttractionDescription => 'En udveksling eller et offer som lokker eller tvinger en af modstanderens brikker til et felt, der giver mulighed for en opfølgende taktik.';

  @override
  String get puzzleThemeBackRankMate => 'Baglinjemat';

  @override
  String get puzzleThemeBackRankMateDescription => 'Sæt kongen skakmat på baglinjen, når den er fanget der af sine egne brikker.';

  @override
  String get puzzleThemeBishopEndgame => 'Løberslutspil';

  @override
  String get puzzleThemeBishopEndgameDescription => 'Et slutspil med kun løbere og bønder.';

  @override
  String get puzzleThemeBodenMate => 'Bodens mat';

  @override
  String get puzzleThemeBodenMateDescription => 'To angribende løbere på krydsende diagonaler giver mat til en konge, som er blokeret af egne brikker.';

  @override
  String get puzzleThemeCastling => 'Rokade';

  @override
  String get puzzleThemeCastlingDescription => 'Bring din konge i sikkerhed og gør dit tårn klar til angreb.';

  @override
  String get puzzleThemeCapturingDefender => 'Tag forsvareren';

  @override
  String get puzzleThemeCapturingDefenderDescription => 'Tag en brik som er kritisk i forsvaret af en anden brik, så det er muligt at tage den uforsvarede brik på et efterfølgende træk.';

  @override
  String get puzzleThemeCrushing => 'Knusende';

  @override
  String get puzzleThemeCrushingDescription => 'Spot modstanderens brøler for at opnå en knusende fordel. (eval ≥ 600cb)';

  @override
  String get puzzleThemeDoubleBishopMate => 'Dobbelt løbermat';

  @override
  String get puzzleThemeDoubleBishopMateDescription => 'To angribende løbere på tilstødende diagonaler giver mat til en konge, som er blokeret af egne brikker.';

  @override
  String get puzzleThemeDovetailMate => 'Duehale-mat';

  @override
  String get puzzleThemeDovetailMateDescription => 'En dronning sætter en tilstødende konge mat, da dennes eneste to felter til flugt er blokeret af egne brikker.';

  @override
  String get puzzleThemeEquality => 'Udligning';

  @override
  String get puzzleThemeEqualityDescription => 'Vend en tabende stilling til en remis eller en lige stilling. (eval ≤ 200cb)';

  @override
  String get puzzleThemeKingsideAttack => 'Angreb på kongesiden';

  @override
  String get puzzleThemeKingsideAttackDescription => 'Et angreb på modstanderens konge efter der er rokeret kort.';

  @override
  String get puzzleThemeClearance => 'Rydning';

  @override
  String get puzzleThemeClearanceDescription => 'Et træk, ofte med tempo, som rydder et felt, en linje eller diagonal til en opfølgende taktisk idé.';

  @override
  String get puzzleThemeDefensiveMove => 'Defensivt træk';

  @override
  String get puzzleThemeDefensiveMoveDescription => 'Et nøjagtigt træk eller trækserie, der er nødvendig for at undgå at miste materiale eller en anden fordel.';

  @override
  String get puzzleThemeDeflection => 'Afledning';

  @override
  String get puzzleThemeDeflectionDescription => 'Et træk der distraherer en modstanders brik fra at udføre en anden funktion, såsom bevogtning af et vigtigt felt.';

  @override
  String get puzzleThemeDiscoveredAttack => 'Afdækkertræk';

  @override
  String get puzzleThemeDiscoveredAttackDescription => 'Flytning af en brik, som tidligere blokerede for et angreb fra en langtrækkende brik. For eksempel en springer flyttet for et tårn.';

  @override
  String get puzzleThemeDoubleCheck => 'Dobbeltskak';

  @override
  String get puzzleThemeDoubleCheckDescription => 'Skak med to brikker på samme tid som resultat af et afdækket angreb, hvor både den flyttede brik og den afdækkede brik giver skak til modstanderens konge.';

  @override
  String get puzzleThemeEndgame => 'Slutspil';

  @override
  String get puzzleThemeEndgameDescription => 'En taktik i den sidste fase af spillet.';

  @override
  String get puzzleThemeEnPassantDescription => 'En taktik som inkluderer En passant-reglen, hvor en bonde kan tage en modstanderbonde, der er flyttet forbi med dens første to-felts-træk.';

  @override
  String get puzzleThemeExposedKing => 'Eksponeret konge';

  @override
  String get puzzleThemeExposedKingDescription => 'En taktik der involverer en konge med få forsvarere omkring sig, hvilket ofte fører til skakmat.';

  @override
  String get puzzleThemeFork => 'Gaffel';

  @override
  String get puzzleThemeForkDescription => 'Et træk hvor den flyttede brik angriber to af modstanderens brikker på én gang.';

  @override
  String get puzzleThemeHangingPiece => 'Hængende brik';

  @override
  String get puzzleThemeHangingPieceDescription => 'En taktik der indebærer, at en af modstanderens brikker, der ikke forsvares eller ikke forsvares tilstrækkeligt, frit kan tages.';

  @override
  String get puzzleThemeHookMate => 'Krog-mat';

  @override
  String get puzzleThemeHookMateDescription => 'Skakmat med tårn, springer og bonde, som sammen med en fjendtlig bonde hindrer modstanderens konge i at undslippe.';

  @override
  String get puzzleThemeInterference => 'Obstruktion';

  @override
  String get puzzleThemeInterferenceDescription => 'Flytte en brik ind mellem to af modstanderens brikker, så den ene eller begge er uden forsvar, såsom en springer på et forsvaret felt mellem to tårne.';

  @override
  String get puzzleThemeIntermezzo => 'Mellemtræk';

  @override
  String get puzzleThemeIntermezzoDescription => 'I stedet for at spille det forventede træk foretages først et andet træk, som udgør en umiddelbar trussel, som modstanderen må besvare. Også kendt som \"Zwischenzug\" eller \"In between\".';

  @override
  String get puzzleThemeKnightEndgame => 'Springerslutspil';

  @override
  String get puzzleThemeKnightEndgameDescription => 'Et slutspil med kun springere og bønder.';

  @override
  String get puzzleThemeLong => 'Lang opgave';

  @override
  String get puzzleThemeLongDescription => 'Tre træk for at vinde.';

  @override
  String get puzzleThemeMaster => 'Mesterpartier';

  @override
  String get puzzleThemeMasterDescription => 'Taktikopgaver fra partier af spillere med titel.';

  @override
  String get puzzleThemeMasterVsMaster => 'Mester mod mester partier';

  @override
  String get puzzleThemeMasterVsMasterDescription => 'Taktikopgaver fra partier mellem to spillere med titel.';

  @override
  String get puzzleThemeMate => 'Mat';

  @override
  String get puzzleThemeMateDescription => 'Vind spillet med stil.';

  @override
  String get puzzleThemeMateIn1 => 'Mat i 1';

  @override
  String get puzzleThemeMateIn1Description => 'Sæt skakmat i ét træk.';

  @override
  String get puzzleThemeMateIn2 => 'Mat i 2';

  @override
  String get puzzleThemeMateIn2Description => 'Sæt skakmat med to træk.';

  @override
  String get puzzleThemeMateIn3 => 'Mat i 3';

  @override
  String get puzzleThemeMateIn3Description => 'Sæt skakmat med tre træk.';

  @override
  String get puzzleThemeMateIn4 => 'Mat i 4';

  @override
  String get puzzleThemeMateIn4Description => 'Sæt skakmat i fire træk.';

  @override
  String get puzzleThemeMateIn5 => 'Mat i 5 eller flere';

  @override
  String get puzzleThemeMateIn5Description => 'Find en lang træksekvens, som fører til mat.';

  @override
  String get puzzleThemeMiddlegame => 'Midtspil';

  @override
  String get puzzleThemeMiddlegameDescription => 'En taktik i den anden fase af spillet.';

  @override
  String get puzzleThemeOneMove => 'Et-træks opgave';

  @override
  String get puzzleThemeOneMoveDescription => 'En taktikopgave der kun er ét træk lang.';

  @override
  String get puzzleThemeOpening => 'Åbning';

  @override
  String get puzzleThemeOpeningDescription => 'En taktik i den første fase af spillet.';

  @override
  String get puzzleThemePawnEndgame => 'Bondeslutspil';

  @override
  String get puzzleThemePawnEndgameDescription => 'Et slutspil kun med bønder.';

  @override
  String get puzzleThemePin => 'Binding';

  @override
  String get puzzleThemePinDescription => 'En taktik med bindinger, hvor en brik er ude af stand til at bevæge sig uden at afdække et angreb på en brik af højere værdi.';

  @override
  String get puzzleThemePromotion => 'Bondeforvandling';

  @override
  String get puzzleThemePromotionDescription => 'En bonde, der forvandles eller truer med at forvandle, er nøglen til taktikken.';

  @override
  String get puzzleThemeQueenEndgame => 'Dronningeslutspil';

  @override
  String get puzzleThemeQueenEndgameDescription => 'Et slutspil med kun dronninger og bønder.';

  @override
  String get puzzleThemeQueenRookEndgame => 'Dronning og tårn-slutspil';

  @override
  String get puzzleThemeQueenRookEndgameDescription => 'Et slutspil med kun dronninger, tårne og bønder.';

  @override
  String get puzzleThemeQueensideAttack => 'Angreb på dronningesiden';

  @override
  String get puzzleThemeQueensideAttackDescription => 'Et angreb på modstanderens konge efter der er rokeret langt.';

  @override
  String get puzzleThemeQuietMove => 'Stille træk';

  @override
  String get puzzleThemeQuietMoveDescription => 'Et træk som ikke sætter skak eller tager en brik, men som forbereder en uundgåelig trussel ved et senere træk.';

  @override
  String get puzzleThemeRookEndgame => 'Tårnslutspil';

  @override
  String get puzzleThemeRookEndgameDescription => 'Et slutspil med kun tårne og bønder.';

  @override
  String get puzzleThemeSacrifice => 'Offer';

  @override
  String get puzzleThemeSacrificeDescription => 'En taktik der består i at opgive materiale på kort sigt for igen at få en fordel efter en tvungen træksekvens.';

  @override
  String get puzzleThemeShort => 'Kort taktikopgave';

  @override
  String get puzzleThemeShortDescription => 'To træk for at vinde.';

  @override
  String get puzzleThemeSkewer => 'Spid';

  @override
  String get puzzleThemeSkewerDescription => 'En manøvre hvor en brik af høj værdi angribes og må flyttes, hvorved en brik af lavere værdi bagved kan tages eller trues. Det omvendte af en binding.';

  @override
  String get puzzleThemeSmotheredMate => 'Kvalt mat';

  @override
  String get puzzleThemeSmotheredMateDescription => 'En skakmat leveret af en springer, hvor den matte konge er ude af stand til at bevæge sig, fordi den er omgivet (eller kvalt) af sine egne brikker.';

  @override
  String get puzzleThemeSuperGM => 'Superstormester-partier';

  @override
  String get puzzleThemeSuperGMDescription => 'Taktikopgaver fra partier spillet af verdens bedste spillere.';

  @override
  String get puzzleThemeTrappedPiece => 'Fastlåste brikker';

  @override
  String get puzzleThemeTrappedPieceDescription => 'En brik er ude af stand til at undslippe fangst, da den har begrænsede trækmuligheder.';

  @override
  String get puzzleThemeUnderPromotion => 'Underforvandling';

  @override
  String get puzzleThemeUnderPromotionDescription => 'Forvandling til en springer, løber eller tårn.';

  @override
  String get puzzleThemeVeryLong => 'Meget lang taktikopgave';

  @override
  String get puzzleThemeVeryLongDescription => 'Fire træk eller mere for at vinde.';

  @override
  String get puzzleThemeXRayAttack => 'Røngtenangreb';

  @override
  String get puzzleThemeXRayAttackDescription => 'En brik angriber eller forsvarer et felt gennem en af modstanderens brikker.';

  @override
  String get puzzleThemeZugzwang => 'Træktvang';

  @override
  String get puzzleThemeZugzwangDescription => 'Modstanderen har begrænsede muligheder for træk, og ethvert træk vil forværre positionen.';

  @override
  String get puzzleThemeHealthyMix => 'Sund blanding';

  @override
  String get puzzleThemeHealthyMixDescription => 'Lidt af hvert. Du kan ikke vide, hvad du skal forvente, så du skal være klar til alt! Præcis som i rigtige spil.';

  @override
  String get puzzleThemePlayerGames => 'Spiller-partier';

  @override
  String get puzzleThemePlayerGamesDescription => 'Find taktikopgaver lavet ud fra dine egne partier eller fra en anden spillers partier.';

  @override
  String puzzleThemePuzzleDownloadInformation(String param) {
    return 'Disse opgaver er i offentligt domæne og kan downloades fra $param.';
  }

  @override
  String get searchSearch => 'Søg';

  @override
  String get settingsSettings => 'Indstillinger';

  @override
  String get settingsCloseAccount => 'Luk konto';

  @override
  String get settingsManagedAccountCannotBeClosed => 'Din konto er under administration og kan ikke lukkes.';

  @override
  String get settingsClosingIsDefinitive => 'Lukning er uigenkaldelig. Der er ingen fortrydelsesret. Er du sikker?';

  @override
  String get settingsCantOpenSimilarAccount => 'Du vil ikke få lov til at åbne en ny konto med det samme navn, selv hvis du ændrer på store og små bogstaver.';

  @override
  String get settingsChangedMindDoNotCloseAccount => 'Jeg har skiftet mening, lad være med at lukke min konto';

  @override
  String get settingsCloseAccountExplanation => 'Er du sikker på, at du vil lukke din konto? Lukning af din konto er en permanent beslutning. Du vil ALDRIG kunne logge ind igen.';

  @override
  String get settingsThisAccountIsClosed => 'Denne konto er lukket.';

  @override
  String get playWithAFriend => 'Spil mod en ven';

  @override
  String get playWithTheMachine => 'Spil mod computeren';

  @override
  String get toInviteSomeoneToPlayGiveThisUrl => 'Invitér en til at spille ved at oplyse denne URL';

  @override
  String get gameOver => 'Spillet er slut';

  @override
  String get waitingForOpponent => 'Venter på modstander';

  @override
  String get orLetYourOpponentScanQrCode => 'Eller lad din modstander scanne denne QR-kode';

  @override
  String get waiting => 'Venter';

  @override
  String get yourTurn => 'Din tur';

  @override
  String aiNameLevelAiLevel(String param1, String param2) {
    return '$param1 niveau $param2';
  }

  @override
  String get level => 'Niveau';

  @override
  String get strength => 'Styrke';

  @override
  String get toggleTheChat => 'Skjul/Vis chat';

  @override
  String get chat => 'Chat';

  @override
  String get resign => 'Giv op';

  @override
  String get checkmate => 'Skakmat';

  @override
  String get stalemate => 'Pat';

  @override
  String get white => 'Hvid';

  @override
  String get black => 'Sort';

  @override
  String get asWhite => 'som hvid';

  @override
  String get asBlack => 'som sort';

  @override
  String get randomColor => 'Tilfældig farve';

  @override
  String get createAGame => 'Opret et parti';

  @override
  String get whiteIsVictorious => 'Hvid har vundet';

  @override
  String get blackIsVictorious => 'Sort har vundet';

  @override
  String get youPlayTheWhitePieces => 'Du spiller med de hvide brikker';

  @override
  String get youPlayTheBlackPieces => 'Du spiller med de sorte brikker';

  @override
  String get itsYourTurn => 'Det er din tur!';

  @override
  String get cheatDetected => 'Snyd detekteret';

  @override
  String get kingInTheCenter => 'Konge i centrum';

  @override
  String get threeChecks => 'Tre skakker';

  @override
  String get raceFinished => 'Race færdigt';

  @override
  String get variantEnding => 'Variantafslutning';

  @override
  String get newOpponent => 'Ny modstander';

  @override
  String get yourOpponentWantsToPlayANewGameWithYou => 'Din modstander vil gerne spille et nyt parti';

  @override
  String get joinTheGame => 'Deltag i partiet';

  @override
  String get whitePlays => 'Hvid i trækket';

  @override
  String get blackPlays => 'Sort i trækket';

  @override
  String get opponentLeftChoices => 'Din modstander har forladt partiet. Du kan fremtvinge modstanderens kapitulation eller vente.';

  @override
  String get forceResignation => 'Kræv sejr';

  @override
  String get forceDraw => 'Kræv remis';

  @override
  String get talkInChat => 'Husk den gode tone i chatten!';

  @override
  String get theFirstPersonToComeOnThisUrlWillPlayWithYou => 'Den første person der bruger denne URL, vil blive din modstander.';

  @override
  String get whiteResigned => 'Hvid opgav';

  @override
  String get blackResigned => 'Sort opgav';

  @override
  String get whiteLeftTheGame => 'Hvid forlod partiet';

  @override
  String get blackLeftTheGame => 'Sort forlod partiet';

  @override
  String get whiteDidntMove => 'Hvid flyttede ikke';

  @override
  String get blackDidntMove => 'Sort flyttede ikke';

  @override
  String get requestAComputerAnalysis => 'Anmod om en computeranalyse';

  @override
  String get computerAnalysis => 'Computeranalyse';

  @override
  String get computerAnalysisAvailable => 'Computeranalyse klar';

  @override
  String get computerAnalysisDisabled => 'Computeranalyse deaktiveret';

  @override
  String get analysis => 'Analysebræt';

  @override
  String depthX(String param) {
    return 'Dybde $param';
  }

  @override
  String get usingServerAnalysis => 'Ved brug af serveranalyse';

  @override
  String get loadingEngine => 'Indlæser skakprogram...';

  @override
  String get calculatingMoves => 'Beregner træk...';

  @override
  String get engineFailed => 'Fejl under indlæsning af skakprogram';

  @override
  String get cloudAnalysis => 'Cloud-analyse';

  @override
  String get goDeeper => 'Analysér dybere';

  @override
  String get showThreat => 'Vis trussel';

  @override
  String get inLocalBrowser => 'i din egen browser';

  @override
  String get toggleLocalEvaluation => 'Skift til lokal evaluering';

  @override
  String get promoteVariation => 'Forfrem variant';

  @override
  String get makeMainLine => 'Gør til hovedlinjen';

  @override
  String get deleteFromHere => 'Slet herfra';

  @override
  String get collapseVariations => 'Fold variationer sammen';

  @override
  String get expandVariations => 'Udvid variationer';

  @override
  String get forceVariation => 'Gennemtving variation';

  @override
  String get copyVariationPgn => 'Kopiér variant-PGN';

  @override
  String get move => 'Træk';

  @override
  String get variantLoss => 'Variant tab';

  @override
  String get variantWin => 'Variant sejr';

  @override
  String get insufficientMaterial => 'Utilstrækkeligt materiale';

  @override
  String get pawnMove => 'Bondetræk';

  @override
  String get capture => 'Slag';

  @override
  String get close => 'Luk';

  @override
  String get winning => 'Vindende';

  @override
  String get losing => 'Tabende';

  @override
  String get drawn => 'Remis';

  @override
  String get unknown => 'Ukendt';

  @override
  String get database => 'Database';

  @override
  String get whiteDrawBlack => 'Hvid / Remis / Sort';

  @override
  String averageRatingX(String param) {
    return 'Gennemsnitlig rating: $param';
  }

  @override
  String get recentGames => 'Seneste partier';

  @override
  String get topGames => 'Top-partier';

  @override
  String masterDbExplanation(String param1, String param2, String param3) {
    return 'To millioner ikke-online partier af $param1+ FIDE-ratede spillere fra $param2 til $param3';
  }

  @override
  String get dtzWithRounding => 'DTZ50\'\' med afrunding, baseret på antallet af halv-træk indtil næste fangst eller bondetræk';

  @override
  String get noGameFound => 'Intet parti fundet';

  @override
  String get maxDepthReached => 'Maks dybde nået!';

  @override
  String get maybeIncludeMoreGamesFromThePreferencesMenu => 'Prøv eventuelt at inkludere flere partier fra præferencemenuen?';

  @override
  String get openings => 'Åbninger';

  @override
  String get openingExplorer => 'Åbningsbog';

  @override
  String get openingEndgameExplorer => 'Åbning/slutspilsbog';

  @override
  String xOpeningExplorer(String param) {
    return '$param åbningsbog';
  }

  @override
  String get playFirstOpeningEndgameExplorerMove => 'Spil det første træk fra åbnings- og slutspilsbog';

  @override
  String get winPreventedBy50MoveRule => 'Sejr forhindret af 50-træks reglen';

  @override
  String get lossSavedBy50MoveRule => 'Nederlag undgået på grund af 50-træks reglen';

  @override
  String get winOr50MovesByPriorMistake => 'Sejr eller 50 træk efter tidligere fejl';

  @override
  String get lossOr50MovesByPriorMistake => 'Nederlag eller 50 træk efter tidligere fejl';

  @override
  String get unknownDueToRounding => 'Sejr/nederlag kun garanteret, hvis den anbefalede tabelbase-linje er blevet fulgt siden sidste fangst eller bondetræk, på grund af mulig afrunding.';

  @override
  String get allSet => 'Ok!';

  @override
  String get importPgn => 'Importer PGN';

  @override
  String get delete => 'Slet';

  @override
  String get deleteThisImportedGame => 'Slet dette importerede spil?';

  @override
  String get replayMode => 'Genafspilning';

  @override
  String get realtimeReplay => 'Realtid';

  @override
  String get byCPL => 'CBT';

  @override
  String get openStudy => 'Åben studie';

  @override
  String get enable => 'Aktivér';

  @override
  String get bestMoveArrow => 'Bedste træk pil';

  @override
  String get showVariationArrows => 'Vis variantpile';

  @override
  String get evaluationGauge => 'Evalueringsindikator';

  @override
  String get multipleLines => 'Flere linjer';

  @override
  String get cpus => 'CPU\'er';

  @override
  String get memory => 'Hukommelse';

  @override
  String get infiniteAnalysis => 'Uendelig analyse';

  @override
  String get removesTheDepthLimit => 'Fjerner dybdegrænsen, og holder din computer varm';

  @override
  String get engineManager => 'Administration af skakprogram';

  @override
  String get blunder => 'Brøler';

  @override
  String get mistake => 'Fejl';

  @override
  String get inaccuracy => 'Unøjagtighed';

  @override
  String get moveTimes => 'Træktider';

  @override
  String get flipBoard => 'Vend bræt';

  @override
  String get threefoldRepetition => 'Trækgentagelse';

  @override
  String get claimADraw => 'Kræv remis';

  @override
  String get offerDraw => 'Tilbyd remis';

  @override
  String get draw => 'Remis';

  @override
  String get drawByMutualAgreement => 'Remis efter fælles aftale';

  @override
  String get fiftyMovesWithoutProgress => 'Halvtreds træk uden fremskridt';

  @override
  String get currentGames => 'Igangværende partier';

  @override
  String get viewInFullSize => 'Se i fuldskærm';

  @override
  String get logOut => 'Log ud';

  @override
  String get signIn => 'Log ind';

  @override
  String get rememberMe => 'Husk mig';

  @override
  String get youNeedAnAccountToDoThat => 'Du skal have en konto for at gøre dette';

  @override
  String get signUp => 'Registrer';

  @override
  String get computersAreNotAllowedToPlay => 'Computere og computerassisterede spillere har ikke lov til at spille. Du må ikke få hjælp fra skakprogrammer, databaser eller fra andre spillere, mens du spiller. Bemærk også, at det kraftigt frarådes at oprette flere konti, og at overdreven brug af flere konti vil føre til udelukkelse.';

  @override
  String get games => 'Partier';

  @override
  String get forum => 'Forum';

  @override
  String xPostedInForumY(String param1, String param2) {
    return '$param1 skrev i forum $param2';
  }

  @override
  String get latestForumPosts => 'Seneste debatindlæg';

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
  String get timeControl => 'Tidskontrol';

  @override
  String get realTime => 'Realtid';

  @override
  String get correspondence => 'Korrespondance';

  @override
  String get daysPerTurn => 'Dage per træk';

  @override
  String get oneDay => 'En dag';

  @override
  String get time => 'Tid';

  @override
  String get rating => 'Rating';

  @override
  String get ratingStats => 'Ratingstatistik';

  @override
  String get username => 'Brugernavn';

  @override
  String get usernameOrEmail => 'Brugernavn eller e-mail';

  @override
  String get changeUsername => 'Ændr brugernavn';

  @override
  String get changeUsernameNotSame => 'Kun størrelsen af bogstaverne kan ændres. For eksempel \"bentlarsen\" til \"BentLarsen\".';

  @override
  String get changeUsernameDescription => 'Ændr dit brugernavn. Dette kan kun gøres én gang, og du kan kun ændre størrelsen på bogstaverne i dit brugernavn.';

  @override
  String get signupUsernameHint => 'Sørg for at vælge et familievenligt brugernavn. Du kan ikke ændre det senere, og alle konti med upassende brugernavne vil blive lukket!';

  @override
  String get signupEmailHint => 'Vi vil kun bruge det til nulstilling af adgangskode.';

  @override
  String get password => 'Adgangskode';

  @override
  String get changePassword => 'Skift adgangskode';

  @override
  String get changeEmail => 'Skift e-mail';

  @override
  String get email => 'E-mail';

  @override
  String get passwordReset => 'Nulstil adgangskode';

  @override
  String get forgotPassword => 'Glemt adgangskode?';

  @override
  String get error_weakPassword => 'Denne adgangskode er ekstremt almindelig og for let at gætte.';

  @override
  String get error_namePassword => 'Brug ikke dit brugernavn som din adgangskode.';

  @override
  String get blankedPassword => 'Du har brugt den samme adgangskode på et andet websted, og dette websted er blevet kompromitteret. For at sikre din Lichess-konto skal du angive en ny adgangskode. Tak for din forståelse.';

  @override
  String get youAreLeavingLichess => 'Du forlader Lichess';

  @override
  String get neverTypeYourPassword => 'Indtast aldrig din Lichess-adgangskode på et andet websted!';

  @override
  String proceedToX(String param) {
    return 'Fortsæt til $param';
  }

  @override
  String get passwordSuggestion => 'Angiv ikke en adgangskode, som er foreslået af en anden person. De vil bruge den til at stjæle din konto.';

  @override
  String get emailSuggestion => 'Angiv ikke en e-mailadresse, som er foreslået af en anden person. De vil bruge den til at stjæle din konto.';

  @override
  String get emailConfirmHelp => 'Hjælp med bekræftelse af e-mail';

  @override
  String get emailConfirmNotReceived => 'Har du ikke modtaget din bekræftelsesmail efter tilmelding?';

  @override
  String get whatSignupUsername => 'Hvilket brugernavn brugte du til at tilmelde dig?';

  @override
  String usernameNotFound(String param) {
    return 'Vi kunne ikke finde nogen bruger med dette navn: $param.';
  }

  @override
  String get usernameCanBeUsedForNewAccount => 'Du kan bruge dette brugernavn til at oprette en ny konto';

  @override
  String emailSent(String param) {
    return 'Vi har sendt en e-mail til $param.';
  }

  @override
  String get emailCanTakeSomeTime => 'Det kan tage lidt tid for den at ankomme.';

  @override
  String get refreshInboxAfterFiveMinutes => 'Vent 5 minutter og opdater din e-mails indbakke.';

  @override
  String get checkSpamFolder => 'Tjek også din spam-mappe, det kan være, at den havner der. Hvis det er tilfældet, skal du markere den som ikke-spam.';

  @override
  String get emailForSignupHelp => 'Hvis alt andet mislykkes, så send os denne e-mail:';

  @override
  String copyTextToEmail(String param) {
    return 'Kopier og indsæt ovenstående tekst og send det til $param';
  }

  @override
  String get waitForSignupHelp => 'Vi vil snart vende tilbage til dig for at hjælpe dig med at fuldføre din tilmelding.';

  @override
  String accountConfirmed(String param) {
    return 'Brugeren $param er blevet bekræftet.';
  }

  @override
  String accountCanLogin(String param) {
    return 'Du kan nu logge ind som $param.';
  }

  @override
  String get accountConfirmationEmailNotNeeded => 'Du behøver ikke en bekræftelsesmail.';

  @override
  String accountClosed(String param) {
    return 'Kontoen $param er lukket.';
  }

  @override
  String accountRegisteredWithoutEmail(String param) {
    return 'Kontoen $param blev registreret uden en e-mail.';
  }

  @override
  String get rank => 'Rang';

  @override
  String rankX(String param) {
    return 'Rangering: $param';
  }

  @override
  String get gamesPlayed => 'Antal partier spillet';

  @override
  String get cancel => 'Annuller';

  @override
  String get whiteTimeOut => 'Tid udløbet for hvid';

  @override
  String get blackTimeOut => 'Tid udløbet for sort';

  @override
  String get drawOfferSent => 'Remistilbud afsendt';

  @override
  String get drawOfferAccepted => 'Remistilbud accepteret';

  @override
  String get drawOfferCanceled => 'Remistilbud trukket tilbage';

  @override
  String get whiteOffersDraw => 'Hvid tilbyder remis';

  @override
  String get blackOffersDraw => 'Sort tilbyder remis';

  @override
  String get whiteDeclinesDraw => 'Hvid afslår remis';

  @override
  String get blackDeclinesDraw => 'Sort afslår remis';

  @override
  String get yourOpponentOffersADraw => 'Din modstander tilbyder remis';

  @override
  String get accept => 'Accepter';

  @override
  String get decline => 'Afslå';

  @override
  String get playingRightNow => 'Spilles lige nu';

  @override
  String get eventInProgress => 'Spilles lige nu';

  @override
  String get finished => 'Afsluttet';

  @override
  String get abortGame => 'Afbryd parti';

  @override
  String get gameAborted => 'Partiet blev afbrudt';

  @override
  String get standard => 'Standard';

  @override
  String get customPosition => 'Brugerdefineret stilling';

  @override
  String get unlimited => 'Ubegrænset';

  @override
  String get mode => 'Variant';

  @override
  String get casual => 'Uformelt';

  @override
  String get rated => 'Ratet';

  @override
  String get casualTournament => 'Uformel';

  @override
  String get ratedTournament => 'Ratet';

  @override
  String get thisGameIsRated => 'Dette parti er ratet';

  @override
  String get rematch => 'Revanche';

  @override
  String get rematchOfferSent => 'Tilbud om revanche sendt';

  @override
  String get rematchOfferAccepted => 'Tilbud om revanche accepteret';

  @override
  String get rematchOfferCanceled => 'Tilbud om revanche trukket tilbage';

  @override
  String get rematchOfferDeclined => 'Tilbud om revanche afslået';

  @override
  String get cancelRematchOffer => 'Træk revanchetilbud tilbage';

  @override
  String get viewRematch => 'Se revanchekamp';

  @override
  String get confirmMove => 'Bekræft træk';

  @override
  String get play => 'Spil';

  @override
  String get inbox => 'Indbakke';

  @override
  String get chatRoom => 'Chatrum';

  @override
  String get loginToChat => 'Log ind for at chatte';

  @override
  String get youHaveBeenTimedOut => 'Du er sat til timeout.';

  @override
  String get spectatorRoom => 'Tilskuerrum';

  @override
  String get composeMessage => 'Skriv besked';

  @override
  String get subject => 'Emne';

  @override
  String get send => 'Send';

  @override
  String get incrementInSeconds => 'Tillæg i sekunder';

  @override
  String get freeOnlineChess => 'Gratis Online-skak';

  @override
  String get exportGames => 'Eksporter spil';

  @override
  String get ratingRange => 'Rating-interval';

  @override
  String get thisAccountViolatedTos => 'Denne konto overtrådte Lichess servicevilkår';

  @override
  String get openingExplorerAndTablebase => 'Åbner åbnings- og slutspilsbog';

  @override
  String get takeback => 'Omtræk';

  @override
  String get proposeATakeback => 'Anmod om omtræk';

  @override
  String get takebackPropositionSent => 'Anmodning om omtræk sendt';

  @override
  String get takebackPropositionDeclined => 'Anmodning om omtræk afslået';

  @override
  String get takebackPropositionAccepted => 'Anmodning om omtræk accepteret';

  @override
  String get takebackPropositionCanceled => 'Anmodning om omtræk annulleret';

  @override
  String get yourOpponentProposesATakeback => 'Din modstander anmoder om omtræk';

  @override
  String get bookmarkThisGame => 'Bogmærk dette spil';

  @override
  String get tournament => 'Turnering';

  @override
  String get tournaments => 'Turneringer';

  @override
  String get tournamentPoints => 'Turneringspoint';

  @override
  String get viewTournament => 'Se turneringen';

  @override
  String get backToTournament => 'Tilbage til turneringen';

  @override
  String get noDrawBeforeSwissLimit => 'Du kan ikke spille remis i en schweizerturnering, før der er lavet 30 træk.';

  @override
  String get thematic => 'Tematisk';

  @override
  String yourPerfRatingIsProvisional(String param) {
    return 'Din $param rating er provisorisk';
  }

  @override
  String yourPerfRatingIsTooHigh(String param1, String param2) {
    return 'Din $param1 rating ($param2) er for høj';
  }

  @override
  String yourTopWeeklyPerfRatingIsTooHigh(String param1, String param2) {
    return 'Din ugentlige $param1 toprating ($param2) er for høj';
  }

  @override
  String yourPerfRatingIsTooLow(String param1, String param2) {
    return 'Din $param1 rating ($param2) er for lav';
  }

  @override
  String ratedMoreThanInPerf(String param1, String param2) {
    return 'Ratet ≥ $param1 i $param2';
  }

  @override
  String ratedLessThanInPerf(String param1, String param2) {
    return 'Ratet ≤ $param1 i $param2';
  }

  @override
  String mustBeInTeam(String param) {
    return 'Skal være medlem af holdet $param';
  }

  @override
  String youAreNotInTeam(String param) {
    return 'Du er ikke på holdet $param';
  }

  @override
  String get backToGame => 'Tilbage til partiet';

  @override
  String get siteDescription => 'Gratis online skakserver. Spil skak med et rent design. Ingen registrering, ingen reklamer, ingen plugins nødvendige. Spil skak mod computeren, venner eller tilfældige modstandere.';

  @override
  String xJoinedTeamY(String param1, String param2) {
    return '$param1 blev medlem af $param2';
  }

  @override
  String xCreatedTeamY(String param1, String param2) {
    return '$param1 oprettede holdet $param2';
  }

  @override
  String get startedStreaming => 'begyndte at streame';

  @override
  String xStartedStreaming(String param) {
    return '$param begyndte at streame';
  }

  @override
  String get averageElo => 'Gennemsnitlig rating';

  @override
  String get location => 'Sted';

  @override
  String get filterGames => 'Filtrér partier';

  @override
  String get reset => 'Nulstil';

  @override
  String get apply => 'Anvend';

  @override
  String get save => 'Gem';

  @override
  String get leaderboard => 'Rangliste';

  @override
  String get screenshotCurrentPosition => 'Tag et skræmbillede af den aktuelle stilling';

  @override
  String get gameAsGIF => 'Parti som GIF';

  @override
  String get pasteTheFenStringHere => 'Indsæt FEN-teksten her';

  @override
  String get pasteThePgnStringHere => 'Indsæt PGN-teksten her';

  @override
  String get orUploadPgnFile => 'Eller upload en PGN-fil';

  @override
  String get fromPosition => 'Fra stilling';

  @override
  String get continueFromHere => 'Fortsæt herfra';

  @override
  String get toStudy => 'Studér';

  @override
  String get importGame => 'Importér parti';

  @override
  String get importGameExplanation => 'Når du indsætter et partis PGN, får du en afspillelig gengivelse, en computeranalyse, en spilchat og en URL til deling.';

  @override
  String get importGameCaveat => 'Varianter vil blive slettet. Hvis du vil beholde dem, skal du importere PGN\'en via et studie.';

  @override
  String get importGameDataPrivacyWarning => 'Denne PGN kan tilgås af offentligheden. For at importere et parti privat, skal du bruge et studie.';

  @override
  String get thisIsAChessCaptcha => 'Dette er en skak-CAPTCHA.';

  @override
  String get clickOnTheBoardToMakeYourMove => 'Klik på brættet for at foretage dit træk, og bevis at du ikke er en robot.';

  @override
  String get captcha_fail => 'Løs venligst denne skak-captcha.';

  @override
  String get notACheckmate => 'Ikke en mat';

  @override
  String get whiteCheckmatesInOneMove => 'Hvid sætter mat i ét træk';

  @override
  String get blackCheckmatesInOneMove => 'Sort sætter mat i ét træk';

  @override
  String get retry => 'Prøv igen';

  @override
  String get reconnecting => 'Genopretter forbindelsen';

  @override
  String get noNetwork => 'Offline';

  @override
  String get favoriteOpponents => 'Favoritmodstandere';

  @override
  String get follow => 'Følg';

  @override
  String get following => 'Følger';

  @override
  String get unfollow => 'Ophør med at følge';

  @override
  String followX(String param) {
    return 'Følg $param';
  }

  @override
  String unfollowX(String param) {
    return 'Følg ikke længere $param';
  }

  @override
  String get block => 'Blokér';

  @override
  String get blocked => 'Blokeret';

  @override
  String get unblock => 'Stop blokering';

  @override
  String get followsYou => 'Følger dig';

  @override
  String xStartedFollowingY(String param1, String param2) {
    return '$param1 følger nu $param2';
  }

  @override
  String get more => 'Mere';

  @override
  String get memberSince => 'Medlem siden';

  @override
  String lastSeenActive(String param) {
    return 'Sidst logget ind $param';
  }

  @override
  String get player => 'Spiller';

  @override
  String get list => 'Liste';

  @override
  String get graph => 'Graf';

  @override
  String get required => 'Påkrævet';

  @override
  String get openTournaments => 'Åben turnering';

  @override
  String get duration => 'Varighed';

  @override
  String get winner => 'Vinder';

  @override
  String get standing => 'Stilling';

  @override
  String get createANewTournament => 'Opret en ny turnering';

  @override
  String get tournamentCalendar => 'Turneringskalender';

  @override
  String get conditionOfEntry => 'Betingelser for deltagelse:';

  @override
  String get advancedSettings => 'Avancerede indstillinger';

  @override
  String get safeTournamentName => 'Vælg et meget ufarligt navn til turneringen.';

  @override
  String get inappropriateNameWarning => 'Selv noget lidt upassende kan resultere i at din konto lukkes.';

  @override
  String get emptyTournamentName => 'Lad stå tomt for at navngive turneringen efter en tilfældig stormester.';

  @override
  String get makePrivateTournament => 'Gør turneringen privat og begræns adgang med en adgangskode';

  @override
  String get join => 'Deltag';

  @override
  String get withdraw => 'Frameld';

  @override
  String get points => 'Points';

  @override
  String get wins => 'Gevinster';

  @override
  String get losses => 'Tabte';

  @override
  String get createdBy => 'Oprettet af';

  @override
  String get tournamentIsStarting => 'Turneringen er begyndt';

  @override
  String get tournamentPairingsAreNowClosed => 'Pardannelsen til turneringen er nu lukket.';

  @override
  String standByX(String param) {
    return 'Et øjeblik $param, parrer spillere – gør dig klar!';
  }

  @override
  String get pause => 'Sæt på pause';

  @override
  String get resume => 'Genoptag';

  @override
  String get youArePlaying => 'Du spiller nu!';

  @override
  String get winRate => 'Sejrsrate';

  @override
  String get berserkRate => 'Bersærk-rate';

  @override
  String get performance => 'Præstation';

  @override
  String get tournamentComplete => 'Turnering afsluttet';

  @override
  String get movesPlayed => 'Spillede træk';

  @override
  String get whiteWins => 'Hvid vinder';

  @override
  String get blackWins => 'Sort vinder';

  @override
  String get drawRate => 'Remis-rate';

  @override
  String get draws => 'Remiser';

  @override
  String nextXTournament(String param) {
    return 'Næste $param turnering:';
  }

  @override
  String get averageOpponent => 'Gennemsnitlig modstander';

  @override
  String get boardEditor => 'Opstilling';

  @override
  String get setTheBoard => 'Opstil bræt';

  @override
  String get popularOpenings => 'Populære åbninger';

  @override
  String get endgamePositions => 'Slutspilsstillinger';

  @override
  String chess960StartPosition(String param) {
    return 'Chess960 startposition: $param';
  }

  @override
  String get startPosition => 'Startopstilling';

  @override
  String get clearBoard => 'Fjern alle brikker';

  @override
  String get loadPosition => 'Indlæs stilling';

  @override
  String get isPrivate => 'Privat';

  @override
  String reportXToModerators(String param) {
    return 'Rapporter $param til administratorer';
  }

  @override
  String profileCompletion(String param) {
    return 'Profil færdiggørelse: $param';
  }

  @override
  String xRating(String param) {
    return '$param rating';
  }

  @override
  String get ifNoneLeaveEmpty => 'Hvis ingen, lad den være tom';

  @override
  String get profile => 'Profil';

  @override
  String get editProfile => 'Redigér profil';

  @override
  String get realName => 'Rigtige navn';

  @override
  String get setFlair => 'Indstil dit ikon';

  @override
  String get flair => 'Ikon';

  @override
  String get youCanHideFlair => 'Der er en indstilling til at skjule alle brugerikoner på tværs af hele webstedet.';

  @override
  String get biography => 'Biografi';

  @override
  String get countryRegion => 'Land eller region';

  @override
  String get thankYou => 'Tak!';

  @override
  String get socialMediaLinks => 'Links til sociale medier';

  @override
  String get oneUrlPerLine => 'En URL pr. linje.';

  @override
  String get inlineNotation => 'Notation uden linjeskift';

  @override
  String get makeAStudy => 'Overvej at lave et studie for sikker opbevaring og deling.';

  @override
  String get clearSavedMoves => 'Ryd træk';

  @override
  String get previouslyOnLichessTV => 'Tidligere på Lichess TV';

  @override
  String get onlinePlayers => 'Online spillere';

  @override
  String get activePlayers => 'Aktive spillere';

  @override
  String get bewareTheGameIsRatedButHasNoClock => 'Bemærk: Partiet er ratet, men er uden tidsbegrænsning!';

  @override
  String get success => 'Fuldført';

  @override
  String get automaticallyProceedToNextGameAfterMoving => 'Automatisk videre til næste spil efter træk';

  @override
  String get autoSwitch => 'Autoskift';

  @override
  String get puzzles => 'Taktikopgaver';

  @override
  String get onlineBots => 'Online bots';

  @override
  String get name => 'Navn';

  @override
  String get description => 'Beskrivelse';

  @override
  String get descPrivate => 'Privat beskrivelse';

  @override
  String get descPrivateHelp => 'Tekst som kun holddeltagere vil se. Hvis den er udfyldt, erstatter den for holddeltagere den offentlige beskrivelse.';

  @override
  String get no => 'Nej';

  @override
  String get yes => 'Ja';

  @override
  String get help => 'Hjælp:';

  @override
  String get createANewTopic => 'Opret et nyt emne';

  @override
  String get topics => 'Emner';

  @override
  String get posts => 'Opslag';

  @override
  String get lastPost => 'Seneste opslag';

  @override
  String get views => 'Visninger';

  @override
  String get replies => 'Svar';

  @override
  String get replyToThisTopic => 'Svar på dette emne';

  @override
  String get reply => 'Svar';

  @override
  String get message => 'Meddelelse';

  @override
  String get createTheTopic => 'Opret emnet';

  @override
  String get reportAUser => 'Anmeld en bruger';

  @override
  String get user => 'Bruger';

  @override
  String get reason => 'Årsag';

  @override
  String get whatIsIheMatter => 'Hvad drejer henvendelsen sig om?';

  @override
  String get cheat => 'Snyd';

  @override
  String get troll => 'Troll';

  @override
  String get other => 'Andet';

  @override
  String get reportDescriptionHelp => 'Indsæt et link til partiet (eller partierne) og forklar hvad der er i vejen med brugerens opførsel.';

  @override
  String get error_provideOneCheatedGameLink => 'Angiv mindst ét link til et parti med snyd.';

  @override
  String by(String param) {
    return 'Af $param';
  }

  @override
  String importedByX(String param) {
    return 'Importeret af $param';
  }

  @override
  String get thisTopicIsNowClosed => 'Dette emne er nu lukket';

  @override
  String get blog => 'Blog';

  @override
  String get notes => 'Noter';

  @override
  String get typePrivateNotesHere => 'Lav private noter her';

  @override
  String get writeAPrivateNoteAboutThisUser => 'Skriv en privat note om denne bruger';

  @override
  String get noNoteYet => 'Ingen note endnu';

  @override
  String get invalidUsernameOrPassword => 'Ugyldigt brugernavn eller adgangskode';

  @override
  String get incorrectPassword => 'Forkert adgangskode';

  @override
  String get invalidAuthenticationCode => 'Ugyldig godkendelseskode';

  @override
  String get emailMeALink => 'E-mail mig et link';

  @override
  String get currentPassword => 'Nuværende adgangskode';

  @override
  String get newPassword => 'Ny adgangskode';

  @override
  String get newPasswordAgain => 'Ny adgangskode (igen)';

  @override
  String get newPasswordsDontMatch => 'De nye adgangskode stemmer ikke overens';

  @override
  String get newPasswordStrength => 'Adgangskodens styrke';

  @override
  String get clockInitialTime => 'Indledende tid på ur';

  @override
  String get clockIncrement => 'Ur-forøgelse';

  @override
  String get privacy => 'Privatliv';

  @override
  String get privacyPolicy => 'Privatlivspolitik';

  @override
  String get letOtherPlayersFollowYou => 'Lad andre spillere følge dig';

  @override
  String get letOtherPlayersChallengeYou => 'Lad andre spillere udfordre dig';

  @override
  String get letOtherPlayersInviteYouToStudy => 'Lad andre spillere invitere dig til at studere';

  @override
  String get sound => 'Lyd';

  @override
  String get none => 'Ingen';

  @override
  String get fast => 'Hurtig';

  @override
  String get normal => 'Normal';

  @override
  String get slow => 'Langsom';

  @override
  String get insideTheBoard => 'På brættet';

  @override
  String get outsideTheBoard => 'Uden for brættet';

  @override
  String get allSquaresOfTheBoard => 'Alle felter på brættet';

  @override
  String get onSlowGames => 'I langsomme spil';

  @override
  String get always => 'Altid';

  @override
  String get never => 'Aldrig';

  @override
  String xCompetesInY(String param1, String param2) {
    return '$param1 konkurrerer i $param2';
  }

  @override
  String get victory => 'Sejr';

  @override
  String get defeat => 'Nederlag';

  @override
  String victoryVsYInZ(String param1, String param2, String param3) {
    return '$param1 mod $param2 i $param3';
  }

  @override
  String defeatVsYInZ(String param1, String param2, String param3) {
    return '$param1 mod $param2 i $param3';
  }

  @override
  String drawVsYInZ(String param1, String param2, String param3) {
    return '$param1 mod $param2 i $param3';
  }

  @override
  String get timeline => 'Tidslinje';

  @override
  String get starting => 'Begynder:';

  @override
  String get allInformationIsPublicAndOptional => 'Al information er offentlig og valgfri.';

  @override
  String get biographyDescription => 'Fortæl om dig selv, dine interesser, hvad kan du lide ved skak, dine favoritåbninger, spillere, ...';

  @override
  String get listBlockedPlayers => 'Vis spillere du har blokeret';

  @override
  String get human => 'Menneske';

  @override
  String get computer => 'Computer';

  @override
  String get side => 'Side';

  @override
  String get clock => 'Ur';

  @override
  String get opponent => 'Modstander';

  @override
  String get learnMenu => 'Lær';

  @override
  String get studyMenu => 'Studie';

  @override
  String get practice => 'Øvelser';

  @override
  String get community => 'Fællesskab';

  @override
  String get tools => 'Værktøjer';

  @override
  String get increment => 'Forøgelse';

  @override
  String get error_unknown => 'Ugyldig værdi';

  @override
  String get error_required => 'Dette felt skal udfyldes';

  @override
  String get error_email => 'Denne e-mailadresse er ugyldig';

  @override
  String get error_email_acceptable => 'Denne e-mailadresse kan ikke accepteres. Dobbelttjek den, og prøv igen.';

  @override
  String get error_email_unique => 'E-mailadresse ugyldig eller allerede brugt';

  @override
  String get error_email_different => 'Dette er allerede din e-mailadresse';

  @override
  String error_minLength(String param) {
    return 'Minimumslængde er $param';
  }

  @override
  String error_maxLength(String param) {
    return 'Maksimumslængde er $param';
  }

  @override
  String error_min(String param) {
    return 'Skal være større eller lig med $param';
  }

  @override
  String error_max(String param) {
    return 'Skal være mindre end eller lig med $param';
  }

  @override
  String ifRatingIsPlusMinusX(String param) {
    return 'Hvis ratingen er ± $param';
  }

  @override
  String get ifRegistered => 'Hvis registreret';

  @override
  String get onlyExistingConversations => 'Kun eksisterende samtaler';

  @override
  String get onlyFriends => 'Kun venner';

  @override
  String get menu => 'Menu';

  @override
  String get castling => 'Rokade';

  @override
  String get whiteCastlingKingside => 'Hvid O-O';

  @override
  String get blackCastlingKingside => 'Sort O-O';

  @override
  String tpTimeSpentPlaying(String param) {
    return 'Spilletid: $param';
  }

  @override
  String get watchGames => 'Se partier';

  @override
  String tpTimeSpentOnTV(String param) {
    return 'Tid på TV: $param';
  }

  @override
  String get watch => 'Se';

  @override
  String get videoLibrary => 'Videobibliotek';

  @override
  String get streamersMenu => 'Streamere';

  @override
  String get mobileApp => 'Mobil App';

  @override
  String get webmasters => 'Webmasters';

  @override
  String get about => 'Om';

  @override
  String aboutX(String param) {
    return 'Om $param';
  }

  @override
  String xIsAFreeYLibreOpenSourceChessServer(String param1, String param2) {
    return '$param1 er en gratis ($param2), uafhængig, reklamefri, open source skak-server.';
  }

  @override
  String get really => 'det er sandt';

  @override
  String get contribute => 'Bidrag';

  @override
  String get termsOfService => 'Servicevilkår';

  @override
  String get sourceCode => 'Kildekode';

  @override
  String get simultaneousExhibitions => 'Simultanskak';

  @override
  String get host => 'Bliv vært';

  @override
  String hostColorX(String param) {
    return 'Værtsfarve: $param';
  }

  @override
  String get yourPendingSimuls => 'Dine ventende simultaner';

  @override
  String get createdSimuls => 'Nyligt oprettede simultanspil';

  @override
  String get hostANewSimul => 'Bliv vært for nyt simultanspil';

  @override
  String get signUpToHostOrJoinASimul => 'Tilmeld dig for at være vært eller deltage i en simultan';

  @override
  String get noSimulFound => 'Simultanspil ikke fundet';

  @override
  String get noSimulExplanation => 'Dette simultanspil eksisterer ikke.';

  @override
  String get returnToSimulHomepage => 'Vend tilbage til Simultan-forsiden';

  @override
  String get aboutSimul => 'Simultanskak er, når en enkelt spiller dyster mod adskillige andre på én gang.';

  @override
  String get aboutSimulImage => 'Ud af 50 modstandere, vandt Fischer 47 partier, spillede 2 remis og tabte 1.';

  @override
  String get aboutSimulRealLife => 'Konceptet stammer fra virkelighedens verden. Her bevæger simultanspilleren sig fra bræt til bræt for at spille ét træk ad gangen.';

  @override
  String get aboutSimulRules => 'I begyndelsen af spillet starter alle deltagere et parti med værten, der får lov at spille med hvide brikker. Simultanspillet er slut, når alle partier er færdige.';

  @override
  String get aboutSimulSettings => 'Simultanspil er altid \"uformelle\". Revanche, omtræk og \"ekstra tid\" er deaktiverede.';

  @override
  String get create => 'Opret';

  @override
  String get whenCreateSimul => 'Når du opretter et simultanspil, spiller du mod adskillige modstandere på én gang.';

  @override
  String get simulVariantsHint => 'Hvis du vælger flere varianter, kan hver enkelt spiller vælge, hvilken der skal spilles.';

  @override
  String get simulClockHint => 'Fischer Clock opsætning. Jo flere spillere du udfordrer, jo mere tid kan være nødvendig.';

  @override
  String get simulAddExtraTime => 'Du kan tilføje ekstra tid til dit ur for at hjælpe med at klare simultanspillet.';

  @override
  String get simulHostExtraTime => 'Ekstra tid til værtsuret';

  @override
  String get simulAddExtraTimePerPlayer => 'Læg den indledende tid til dit ur igen for hver spiller, der melder sig til simultanspillet.';

  @override
  String get simulHostExtraTimePerPlayer => 'Ekstra tid på arrangørens ur pr. spiller';

  @override
  String get lichessTournaments => 'Lichess-turneringer';

  @override
  String get tournamentFAQ => 'Arenaturnering FAQ';

  @override
  String get timeBeforeTournamentStarts => 'Tid før turnering starter';

  @override
  String get averageCentipawnLoss => 'Gennemsnitligt centibonde-tab';

  @override
  String get accuracy => 'Præcision';

  @override
  String get keyboardShortcuts => 'Tastaturgenveje';

  @override
  String get keyMoveBackwardOrForward => 'ryk tilbage/frem';

  @override
  String get keyGoToStartOrEnd => 'gå til start/slut';

  @override
  String get keyCycleSelectedVariation => 'Gennemgå den valgte variant';

  @override
  String get keyShowOrHideComments => 'vis/skjul kommentar';

  @override
  String get keyEnterOrExitVariation => 'Start/slut variant';

  @override
  String get keyRequestComputerAnalysis => 'Anmod om computeranalyse, Lær af dine fejl';

  @override
  String get keyNextLearnFromYourMistakes => 'Næste (Lær af dine fejl)';

  @override
  String get keyNextBlunder => 'Næste brøler';

  @override
  String get keyNextMistake => 'Næste fejl';

  @override
  String get keyNextInaccuracy => 'Næste unøjagtighed';

  @override
  String get keyPreviousBranch => 'Forrige gren';

  @override
  String get keyNextBranch => 'Næste gren';

  @override
  String get toggleVariationArrows => 'Slå variantpile til/fra';

  @override
  String get cyclePreviousOrNextVariation => 'Gennemgå forrige/næste variant';

  @override
  String get toggleGlyphAnnotations => 'Slå træk-annotationer til/fra';

  @override
  String get togglePositionAnnotations => 'Slå positionsannotationer til/fra';

  @override
  String get variationArrowsInfo => 'Variantpile lader dig navigere uden at bruge træklisten.';

  @override
  String get playSelectedMove => 'spil valgte træk';

  @override
  String get newTournament => 'Ny turnering';

  @override
  String get tournamentHomeTitle => 'Skakturnering med forskellige tidskontroller og varianter';

  @override
  String get tournamentHomeDescription => 'Spil tempofyldte skakturneringer! Meld dig til en officielt organiseret turnering eller opret din egen. Bullet, Blitz, Classical, Chess960, King of the Hill, Tre-check og andre muligheder for ubegrænset skaksjov.';

  @override
  String get tournamentNotFound => 'Turnering ikke fundet';

  @override
  String get tournamentDoesNotExist => 'Denne turnering eksisterer ikke.';

  @override
  String get tournamentMayHaveBeenCanceled => 'Den kan være blevet aflyst, hvis alle spillere forlod den før turneringsstart.';

  @override
  String get returnToTournamentsHomepage => 'Vend tilbage til turnerings-forsiden';

  @override
  String weeklyPerfTypeRatingDistribution(String param) {
    return 'Månedlig $param rating fordeling';
  }

  @override
  String yourPerfTypeRatingIsRating(String param1, String param2) {
    return 'Din $param1 rating er $param2';
  }

  @override
  String youAreBetterThanPercentOfPerfTypePlayers(String param1, String param2) {
    return 'Du er bedre end $param1 af $param2 spillere';
  }

  @override
  String userIsBetterThanPercentOfPerfTypePlayers(String param1, String param2, String param3) {
    return '$param1 er bedre end $param2 af $param3 spillere.';
  }

  @override
  String betterThanPercentPlayers(String param1, String param2) {
    return 'Bedre end $param1 af $param2 spillere';
  }

  @override
  String youDoNotHaveAnEstablishedPerfTypeRating(String param) {
    return 'Du har ikke en fastsat $param rating';
  }

  @override
  String get yourRating => 'Din rating';

  @override
  String get cumulative => 'Akkumuleret';

  @override
  String get glicko2Rating => 'Glicko-2 rating';

  @override
  String get checkYourEmail => 'Tjek din e-mail';

  @override
  String get weHaveSentYouAnEmailClickTheLink => 'Vi har sendt dig en e-mail. Klik på linket i e-mailen for at aktivere din konto.';

  @override
  String get ifYouDoNotSeeTheEmailCheckOtherPlaces => 'Hvis du ikke kan se e-mailen, bør du kontrollere andre steder den kan være endt, som i din junk, spam eller andre mapper.';

  @override
  String weHaveSentYouAnEmailTo(String param) {
    return 'Vi har sendt en e-mail til $param. Klik på linket i e-mailen for at nulstille din adgangskode.';
  }

  @override
  String byRegisteringYouAgreeToBeBoundByOur(String param) {
    return 'Ved at registrere, accepterer du at være bundet af vores $param.';
  }

  @override
  String readAboutOur(String param) {
    return 'Læs om vores $param.';
  }

  @override
  String get networkLagBetweenYouAndLichess => 'Netværksforsinkelse mellem dig og lichess';

  @override
  String get timeToProcessAMoveOnLichessServer => 'Tid til at behandle et træk på Lichess-server';

  @override
  String get downloadAnnotated => 'Download kommenteret';

  @override
  String get downloadRaw => 'Download rå';

  @override
  String get downloadImported => 'Download importeret';

  @override
  String get crosstable => 'Krydstabel';

  @override
  String get youCanAlsoScrollOverTheBoardToMoveInTheGame => 'Brug musens scrollhjul på brættet til at skifte mellem træk i partiet.';

  @override
  String get scrollOverComputerVariationsToPreviewThem => 'Scroll over computervarianter for at få en forhåndsvisning af dem.';

  @override
  String get analysisShapesHowTo => 'Tryk shift + klik eller højreklik for at tegne cirkler og pile på brættet.';

  @override
  String get letOtherPlayersMessageYou => 'Lad andre spillere sende en besked til dig';

  @override
  String get receiveForumNotifications => 'Modtag notifikationer, når du bliver nævnt i forummet';

  @override
  String get shareYourInsightsData => 'Del din \"insigts\" data';

  @override
  String get withNobody => 'Med ingen';

  @override
  String get withFriends => 'Med venner';

  @override
  String get withEverybody => 'Med alle';

  @override
  String get kidMode => 'Børnetilstand';

  @override
  String get kidModeIsEnabled => 'Børnetilstand er aktiveret.';

  @override
  String get kidModeExplanation => 'Dette angår sikkerhed. I børnetilstand er alt kommunikation deaktiveret. Aktivér dette for dine børn eller skoleelever for at beskytte dem mod andre internetbrugere.';

  @override
  String inKidModeTheLichessLogoGetsIconX(String param) {
    return 'I børnetilstand vil Lichess-logoet få et $param ikon, så du ved, at dine børn er sikret.';
  }

  @override
  String get askYourChessTeacherAboutLiftingKidMode => 'Din konto er under administration. Spørg din skaklærer om at ophæve børnetilstanden.';

  @override
  String get enableKidMode => 'Aktiver børnetilstand';

  @override
  String get disableKidMode => 'Deaktiver børnetilstand';

  @override
  String get security => 'Sikkerhed';

  @override
  String get sessions => 'Sessioner';

  @override
  String get revokeAllSessions => 'annuller alle sessioner';

  @override
  String get playChessEverywhere => 'Spil skak hvor som helst';

  @override
  String get asFreeAsLichess => 'Gratis som Lichess';

  @override
  String get builtForTheLoveOfChessNotMoney => 'Bygget af kærlighed til skak, ikke penge';

  @override
  String get everybodyGetsAllFeaturesForFree => 'Alle får alle funktioner gratis';

  @override
  String get zeroAdvertisement => 'Ingen reklamer';

  @override
  String get fullFeatured => 'Alle funktioner';

  @override
  String get phoneAndTablet => 'Telefon og tablet';

  @override
  String get bulletBlitzClassical => 'Bullet, lyn, klassisk';

  @override
  String get correspondenceChess => 'Korrespondanceskak';

  @override
  String get onlineAndOfflinePlay => 'Online og offline spil';

  @override
  String get viewTheSolution => 'Se løsningen';

  @override
  String get followAndChallengeFriends => 'Følg og udfordre dine venner';

  @override
  String get gameAnalysis => 'Spilanalyse';

  @override
  String xHostsY(String param1, String param2) {
    return '$param1 er vært for $param2';
  }

  @override
  String xJoinsY(String param1, String param2) {
    return '$param1 melder sig til $param2';
  }

  @override
  String xLikesY(String param1, String param2) {
    return '$param1 synes godt om $param2';
  }

  @override
  String get quickPairing => 'Hurtig parring';

  @override
  String get lobby => 'Lobbyen';

  @override
  String get anonymous => 'Anonym';

  @override
  String yourScore(String param) {
    return 'Din score: $param';
  }

  @override
  String get language => 'Sprog';

  @override
  String get background => 'Baggrund';

  @override
  String get light => 'Lys';

  @override
  String get dark => 'Mørk';

  @override
  String get transparent => 'Gennemsigtigt';

  @override
  String get deviceTheme => 'Enhedstema';

  @override
  String get backgroundImageUrl => 'Baggrundsbillede URL:';

  @override
  String get board => 'Bræt';

  @override
  String get size => 'Størrelse';

  @override
  String get opacity => 'Uigennemsigtighed';

  @override
  String get brightness => 'Lysstyrke';

  @override
  String get hue => 'Farvetone';

  @override
  String get boardReset => 'Nulstil farver til standard';

  @override
  String get pieceSet => 'Brikker';

  @override
  String get embedInYourWebsite => 'Indlejr på din hjemmeside';

  @override
  String get usernameAlreadyUsed => 'Dette brugernavn er allerede i brug. Vælg et andet og prøv igen.';

  @override
  String get usernamePrefixInvalid => 'Brugernavnet skal begynde med et bogstav.';

  @override
  String get usernameSuffixInvalid => 'Brugernavnet skal afsluttes med et bogstav eller et tal.';

  @override
  String get usernameCharsInvalid => 'Brugernavnet må kun indeholde bogstaver, tal, underscore og bindestreger.';

  @override
  String get usernameUnacceptable => 'Dette brugernavn er ikke acceptabelt.';

  @override
  String get playChessInStyle => 'Spil skak med stil';

  @override
  String get chessBasics => 'Grundlæggende skak';

  @override
  String get coaches => 'Skaktrænere';

  @override
  String get invalidPgn => 'Ugyldig PGN';

  @override
  String get invalidFen => 'Ugyldig FEN';

  @override
  String get custom => 'Tilpasset';

  @override
  String get notifications => 'Notifikationer';

  @override
  String notificationsX(String param1) {
    return 'Notifikationer: $param1';
  }

  @override
  String perfRatingX(String param) {
    return 'Rating: $param';
  }

  @override
  String get practiceWithComputer => 'Træn med computer';

  @override
  String anotherWasX(String param) {
    return 'Et andet var $param';
  }

  @override
  String bestWasX(String param) {
    return 'Bedste var $param';
  }

  @override
  String get youBrowsedAway => 'Du browsede væk';

  @override
  String get resumePractice => 'Genoptag træning';

  @override
  String get drawByFiftyMoves => 'Partiet er endt med remis efter reglen om halvtreds træk.';

  @override
  String get theGameIsADraw => 'Partiet ender med remis.';

  @override
  String get computerThinking => 'Computer tænker...';

  @override
  String get seeBestMove => 'Se bedste træk';

  @override
  String get hideBestMove => 'Skjul bedste træk';

  @override
  String get getAHint => 'Få et hint';

  @override
  String get evaluatingYourMove => 'Vurderer dit træk ...';

  @override
  String get whiteWinsGame => 'Hvid vinder';

  @override
  String get blackWinsGame => 'Sort vinder';

  @override
  String get learnFromYourMistakes => 'Lær af dine fejl';

  @override
  String get learnFromThisMistake => 'Lær af denne fejl';

  @override
  String get skipThisMove => 'Spring dette træk over';

  @override
  String get next => 'Næste';

  @override
  String xWasPlayed(String param) {
    return '$param blev spillet';
  }

  @override
  String get findBetterMoveForWhite => 'Find et bedre træk for hvid';

  @override
  String get findBetterMoveForBlack => 'Find et bedre træk for sort';

  @override
  String get resumeLearning => 'Fortsæt læring';

  @override
  String get youCanDoBetter => 'Du kan gøre det bedre';

  @override
  String get tryAnotherMoveForWhite => 'Prøv et andet træk for hvid';

  @override
  String get tryAnotherMoveForBlack => 'Prøv et andet træk for sort';

  @override
  String get solution => 'Løsning';

  @override
  String get waitingForAnalysis => 'Venter på analyse';

  @override
  String get noMistakesFoundForWhite => 'Ingen fejl fundet for hvid';

  @override
  String get noMistakesFoundForBlack => 'Ingen fejl fundet for sort';

  @override
  String get doneReviewingWhiteMistakes => 'Færdig med gennemgang af fejl for hvid';

  @override
  String get doneReviewingBlackMistakes => 'Færdig med gennemgang af fejl for sort';

  @override
  String get doItAgain => 'Gentag';

  @override
  String get reviewWhiteMistakes => 'Gennemgå hvide fejl';

  @override
  String get reviewBlackMistakes => 'Gennemgå sorte fejl';

  @override
  String get advantage => 'Fordel';

  @override
  String get opening => 'Åbningsspil';

  @override
  String get middlegame => 'Midtspil';

  @override
  String get endgame => 'Slutspil';

  @override
  String get conditionalPremoves => 'Betingede forhåndstræk';

  @override
  String get addCurrentVariation => 'Tilføj nuværende variant';

  @override
  String get playVariationToCreateConditionalPremoves => 'Spil en variant for at lave betingede forhåndstræk';

  @override
  String get noConditionalPremoves => 'Ingen betingede forhåndstræk';

  @override
  String playX(String param) {
    return 'Spil $param';
  }

  @override
  String get showUnreadLichessMessage => 'Du har modtaget en privat besked fra Lichess.';

  @override
  String get clickHereToReadIt => 'Klik her for at læse den';

  @override
  String get sorry => 'Beklager :(';

  @override
  String get weHadToTimeYouOutForAWhile => 'Vi måtte give dig en timeout.';

  @override
  String get why => 'Hvorfor?';

  @override
  String get pleasantChessExperience => 'Vi tilstræber at give alle en behagelig skakoplevelse.';

  @override
  String get goodPractice => 'I den forbindelse må vi sikre, at alle spillere følger god praksis.';

  @override
  String get potentialProblem => 'Når et potentielt problem opdages, viser vi denne besked.';

  @override
  String get howToAvoidThis => 'Hvordan undgås dette?';

  @override
  String get playEveryGame => 'Spil alle partier du starter.';

  @override
  String get tryToWin => 'Forsøg at vinde (eller i det mindre opnå remis) alle partier du spiller.';

  @override
  String get resignLostGames => 'Kapituler ved tabende position (lad ikke tiden løbe ud).';

  @override
  String get temporaryInconvenience => 'Vi undskylder for den midlertidige ulejlighed,';

  @override
  String get wishYouGreatGames => 'og ønsker dig gode kampe på lichess.org.';

  @override
  String get thankYouForReading => 'Tak for at læse!';

  @override
  String get lifetimeScore => 'Livstidsscore';

  @override
  String get currentMatchScore => 'Nuværende kampscore';

  @override
  String get agreementAssistance => 'Jeg lover, at jeg på intet tidspunkt i løbet af mine partier vil modtage assistance (fra en skakcomputer, bog, database eller anden person).';

  @override
  String get agreementNice => 'Jeg lover, at jeg altid vil være respektfuld mod andre spillere.';

  @override
  String agreementMultipleAccounts(String param) {
    return 'Jeg er indforstået med, at jeg ikke opretter flere konti (undtagen af de grunde, der er angivet i $param).';
  }

  @override
  String get agreementPolicy => 'Jeg lover, at jeg vil overholde alle Lichess-politikker.';

  @override
  String get searchOrStartNewDiscussion => 'Søg eller start ny diskussion';

  @override
  String get edit => 'Rediger';

  @override
  String get bullet => 'Bullet';

  @override
  String get blitz => 'Blitz';

  @override
  String get rapid => 'Rapid';

  @override
  String get classical => 'Classical';

  @override
  String get ultraBulletDesc => 'Vanvittigt hurtige spil: mindre end 30 sekunder';

  @override
  String get bulletDesc => 'Meget hurtige spil: mindre end 3 minutter';

  @override
  String get blitzDesc => 'Hurtige spil: 3 til 8 minutter';

  @override
  String get rapidDesc => 'Hurtige spil: 8 til 25 minutter';

  @override
  String get classicalDesc => 'Klassiske spil: 25 minutter eller mere';

  @override
  String get correspondenceDesc => 'Korrespondancepartier: en eller adskillige dage per træk';

  @override
  String get puzzleDesc => 'Skaktaktik-træner';

  @override
  String get important => 'Vigtigt';

  @override
  String yourQuestionMayHaveBeenAnswered(String param1) {
    return 'Der findes måske allerede et svar på dit spørgsmål $param1';
  }

  @override
  String get inTheFAQ => 'i vores F.A.Q.';

  @override
  String toReportSomeoneForCheatingOrBadBehavior(String param1) {
    return 'For at anmelde en bruger for snyd eller dårlig opførsel, $param1';
  }

  @override
  String get useTheReportForm => 'brug anmeldelsesformularen';

  @override
  String toRequestSupport(String param1) {
    return 'For at få support, $param1';
  }

  @override
  String get tryTheContactPage => 'prøv kontakt-siden';

  @override
  String makeSureToRead(String param1) {
    return 'Sørg for at læse $param1';
  }

  @override
  String get theForumEtiquette => 'forummets etikette';

  @override
  String get thisTopicIsArchived => 'Dette emne er arkiveret og kan ikke længere besvares.';

  @override
  String joinTheTeamXToPost(String param1) {
    return 'Meld dig til $param1, for at lave opslag i dette forum';
  }

  @override
  String teamNamedX(String param1) {
    return '$param1 hold';
  }

  @override
  String get youCannotPostYetPlaySomeGames => 'Du kan endnu ikke lave oplag i foraene. Spil nogle partier!';

  @override
  String get subscribe => 'Abonnér';

  @override
  String get unsubscribe => 'Ophæv abonnement';

  @override
  String mentionedYouInX(String param1) {
    return 'nævnte dig i \"$param1\".';
  }

  @override
  String xMentionedYouInY(String param1, String param2) {
    return '$param1 nævnte dig i \"$param2\".';
  }

  @override
  String invitedYouToX(String param1) {
    return 'inviterede dig til \"$param1\".';
  }

  @override
  String xInvitedYouToY(String param1, String param2) {
    return '$param1 inviterede dig til \"$param2\".';
  }

  @override
  String get youAreNowPartOfTeam => 'Du er nu en del af holdet.';

  @override
  String youHaveJoinedTeamX(String param1) {
    return 'Du har sluttet dig til \"$param1\".';
  }

  @override
  String get someoneYouReportedWasBanned => 'Nogen du rapporterede blev udelukket';

  @override
  String get congratsYouWon => 'Tillykke, du vandt!';

  @override
  String gameVsX(String param1) {
    return 'Parti mod $param1';
  }

  @override
  String resVsX(String param1, String param2) {
    return '$param1 mod $param2';
  }

  @override
  String get lostAgainstTOSViolator => 'Du tabte til en person, der overtrådte Lichess brugerbetingelserne';

  @override
  String refundXpointsTimeControlY(String param1, String param2) {
    return 'Refunderet: $param1 $param2 ratingpoint.';
  }

  @override
  String get timeAlmostUp => 'Tiden er næsten udløbet!';

  @override
  String get clickToRevealEmailAddress => '[Klik for at vise e-mailadresse]';

  @override
  String get download => 'Download';

  @override
  String get coachManager => 'Træner-administration';

  @override
  String get streamerManager => 'Streamer-administration';

  @override
  String get cancelTournament => 'Aflys turneringen';

  @override
  String get tournDescription => 'Turneringsbeskrivelse';

  @override
  String get tournDescriptionHelp => 'Noget særligt du ønsker at fortælle deltagerne? Prøv at holde det kort. Markdown-links er tilgængelige: [name](https://url)';

  @override
  String get ratedFormHelp => 'Partier er ratede\nog påvirker spilleres ratings';

  @override
  String get onlyMembersOfTeam => 'Kun medlemmer af hold';

  @override
  String get noRestriction => 'Ingen restriktion';

  @override
  String get minimumRatedGames => 'Minimum ratede partier';

  @override
  String get minimumRating => 'Minimum rating';

  @override
  String get maximumWeeklyRating => 'Maksimal ugentlig rating';

  @override
  String positionInputHelp(String param) {
    return 'Indsæt en gyldig FEN for at starte hvert parti fra en given stilling.\nDet virker kun for standardspil, ikke med varianter.\nDu kan bruge $param til at generere en FEN-stilling og derefter indsætte den her.\nLad stå tomt for at starte partier fra den normale udgangsstilling.';
  }

  @override
  String get cancelSimul => 'Annuller simultanen';

  @override
  String get simulHostcolor => 'Værtsfarve for hvert parti';

  @override
  String get estimatedStart => 'Anslået starttidspunkt';

  @override
  String simulFeatured(String param) {
    return 'Vis på $param';
  }

  @override
  String simulFeaturedHelp(String param) {
    return 'Vis din simultan til alle på $param. Deaktivér for private simultaner.';
  }

  @override
  String get simulDescription => 'Simultanbeskrivelse';

  @override
  String get simulDescriptionHelp => 'Noget du ønsker at fortælle deltagerne?';

  @override
  String markdownAvailable(String param) {
    return '$param er tilgængelig for mere avanceret syntaks.';
  }

  @override
  String get embedsAvailable => 'Indsæt URL på et parti eller på et studiekaptitel for at indlejre det.';

  @override
  String get inYourLocalTimezone => 'I din egen lokale tidszone';

  @override
  String get tournChat => 'Turneringschat';

  @override
  String get noChat => 'Ingen chat';

  @override
  String get onlyTeamLeaders => 'Kun holdledere';

  @override
  String get onlyTeamMembers => 'Kun holdmedlemmer';

  @override
  String get navigateMoveTree => 'Navigér i træk-træet';

  @override
  String get mouseTricks => 'Tricks med mus';

  @override
  String get toggleLocalAnalysis => 'Slå lokal computeranalyse til/fra';

  @override
  String get toggleAllAnalysis => 'Slå al computeranalyse til/fra';

  @override
  String get playComputerMove => 'Spil det bedste computertræk';

  @override
  String get analysisOptions => 'Analysemuligheder';

  @override
  String get focusChat => 'Fokusér chat';

  @override
  String get showHelpDialog => 'Vis denne hjælpedialog';

  @override
  String get reopenYourAccount => 'Genåbn din konto';

  @override
  String get closedAccountChangedMind => 'Hvis du har lukket din konto, men siden ombestemt dig, har du én chance for at få din konto tilbage.';

  @override
  String get onlyWorksOnce => 'Det vil kun fungere én gang.';

  @override
  String get cantDoThisTwice => 'Hvis du lukker din konto for anden gang, vil der ikke være nogen mulighed for at gendanne den.';

  @override
  String get emailAssociatedToaccount => 'E-mailadresse tilknyttet kontoen';

  @override
  String get sentEmailWithLink => 'Vi har sendt dig en e-mail med et link.';

  @override
  String get tournamentEntryCode => 'Turneringadgangskode';

  @override
  String get hangOn => 'Vent lidt!';

  @override
  String gameInProgress(String param) {
    return 'Du har et parti i gang med $param.';
  }

  @override
  String get abortTheGame => 'Afbryd partiet';

  @override
  String get resignTheGame => 'Giv op i partiet';

  @override
  String get youCantStartNewGame => 'Du kan ikke starte et nyt parti, før dette er afsluttet.';

  @override
  String get since => 'Siden';

  @override
  String get until => 'Indtil';

  @override
  String get lichessDbExplanation => 'Ratede partier indsamlet fra alle Lichess-spillere';

  @override
  String get switchSides => 'Skift side';

  @override
  String get closingAccountWithdrawAppeal => 'Hvis du lukker din konto, vil din appel blive trukket tilbage';

  @override
  String get ourEventTips => 'Tips til organisering af begivenheder';

  @override
  String get instructions => 'Instruktioner';

  @override
  String get showMeEverything => 'Vis mig alt';

  @override
  String get lichessPatronInfo => 'Lichess er en velgørenhedsorganisation og helt gratis/libre open source-software.\nAlle driftsomkostninger, udvikling og indhold finansieres udelukkende af brugerdonationer.';

  @override
  String get nothingToSeeHere => 'Intet at se her i øjeblikket.';

  @override
  String opponentLeftCounter(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Din modstander har forladt partiet. Du kan kræve at få tildelt sejren om $count sekunder.',
      one: 'Din modstander har forladt partiet. Du kan kræve at få tildelt sejren om $count sekund.',
    );
    return '$_temp0';
  }

  @override
  String mateInXHalfMoves(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Mat i $count halv-træk',
      one: 'Mat i $count halv-træk',
    );
    return '$_temp0';
  }

  @override
  String nbBlunders(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count brølere',
      one: '$count brøler',
    );
    return '$_temp0';
  }

  @override
  String nbMistakes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count fejl',
      one: '$count fejl',
    );
    return '$_temp0';
  }

  @override
  String nbInaccuracies(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count unøjagtigheder',
      one: '$count unøjagtighed',
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
      other: '$count rating over $param2 partier',
      one: '$count rating over $param2 parti',
    );
    return '$_temp0';
  }

  @override
  String nbBookmarks(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count bogmærker',
      one: '$count bogmærke',
    );
    return '$_temp0';
  }

  @override
  String nbDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count dage',
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
      one: '$count minut',
    );
    return '$_temp0';
  }

  @override
  String rankIsUpdatedEveryNbMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Ranking opdateres hvert $count minut',
      one: 'Ranking opdateres hvert minut',
    );
    return '$_temp0';
  }

  @override
  String nbPuzzles(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count taktikopgaver',
      one: '$count taktikopgave',
    );
    return '$_temp0';
  }

  @override
  String nbGamesWithYou(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count partier med dig',
      one: '$count parti med dig',
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
      other: '$count sejre',
      one: '$count sejr',
    );
    return '$_temp0';
  }

  @override
  String nbLosses(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count nederlag',
      one: '$count nederlag',
    );
    return '$_temp0';
  }

  @override
  String nbDraws(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count remiser',
      one: '$count remis',
    );
    return '$_temp0';
  }

  @override
  String nbPlaying(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count spil i gang',
      one: '$count spil i gang',
    );
    return '$_temp0';
  }

  @override
  String giveNbSeconds(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Giv $count sekunder',
      one: 'Giv $count sekund',
    );
    return '$_temp0';
  }

  @override
  String nbTournamentPoints(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count turneringspoint',
      one: '$count turneringspoint',
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
      other: '≥ $count ratede $param2 partier',
      one: '≥ $count ratet $param2 parti',
    );
    return '$_temp0';
  }

  @override
  String needNbMorePerfGames(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Du er nødt til at spille $count ratede $param2 partier mere',
      one: 'Du er nødt til at spille $count ratet $param2 parti mere',
    );
    return '$_temp0';
  }

  @override
  String needNbMoreGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Du er nødt til at spille $count ratede partier mere',
      one: 'Du er nødt til at spille $count ratet parti mere',
    );
    return '$_temp0';
  }

  @override
  String nbImportedGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count importerede spil',
      one: '$count importerede spil',
    );
    return '$_temp0';
  }

  @override
  String nbFriendsOnline(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count venner online',
      one: '$count ven online',
    );
    return '$_temp0';
  }

  @override
  String nbFollowers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count følgere',
      one: '$count som følger',
    );
    return '$_temp0';
  }

  @override
  String nbFollowing(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count følger',
      one: '$count følger',
    );
    return '$_temp0';
  }

  @override
  String lessThanNbMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Mindre end $count minutter',
      one: 'Mindre end $count minut',
    );
    return '$_temp0';
  }

  @override
  String nbGamesInPlay(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count partier i gang',
      one: '$count parti i gang',
    );
    return '$_temp0';
  }

  @override
  String maximumNbCharacters(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Maximum: $count tegn.',
      one: 'Maximum: $count tegn.',
    );
    return '$_temp0';
  }

  @override
  String blocks(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count blokerede spillere',
      one: '$count blokeret spiller',
    );
    return '$_temp0';
  }

  @override
  String nbForumPosts(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count forum-opslag',
      one: '$count forum-opslag',
    );
    return '$_temp0';
  }

  @override
  String nbPerfTypePlayersThisWeek(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count $param2 spillere denne uge.',
      one: '$count $param2 spiller denne uge.',
    );
    return '$_temp0';
  }

  @override
  String availableInNbLanguages(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Tilgængelig på $count sprog!',
      one: 'Tilgængelig på $count sprog!',
    );
    return '$_temp0';
  }

  @override
  String nbSecondsToPlayTheFirstMove(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count sekunder til at lave det første træk',
      one: '$count sekund til at lave det første træk',
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
      other: 'og gem $count serier af forhåndstræk',
      one: 'og gem $count serie af forhåndstræk',
    );
    return '$_temp0';
  }

  @override
  String get stormMoveToStart => 'Ryk for at starte';

  @override
  String get stormYouPlayTheWhitePiecesInAllPuzzles => 'Du har de hvide brikker i alle opgaver';

  @override
  String get stormYouPlayTheBlackPiecesInAllPuzzles => 'Du har de sorte brikker i alle opgaver';

  @override
  String get stormPuzzlesSolved => 'taktikopgaver løst';

  @override
  String get stormNewDailyHighscore => 'Ny dagsrekord!';

  @override
  String get stormNewWeeklyHighscore => 'Ny ugerekord!';

  @override
  String get stormNewMonthlyHighscore => 'Ny månedsrekord!';

  @override
  String get stormNewAllTimeHighscore => 'Ny rekord for alle tider!';

  @override
  String stormPreviousHighscoreWasX(String param) {
    return 'Tidligere rekord var $param';
  }

  @override
  String get stormPlayAgain => 'Spil igen';

  @override
  String stormHighscoreX(String param) {
    return 'Rekord: $param';
  }

  @override
  String get stormScore => 'Score';

  @override
  String get stormMoves => 'Træk';

  @override
  String get stormAccuracy => 'Nøjagtighed';

  @override
  String get stormCombo => 'Kombo';

  @override
  String get stormTime => 'Tid';

  @override
  String get stormTimePerMove => 'Tid per træk';

  @override
  String get stormHighestSolved => 'Sværeste løst';

  @override
  String get stormPuzzlesPlayed => 'Spillede taktikopgaver';

  @override
  String get stormNewRun => 'Ny runde (genvejstast: Mellemrum)';

  @override
  String get stormEndRun => 'Afslut runde (genvejstast: Enter)';

  @override
  String get stormHighscores => 'Rekorder';

  @override
  String get stormViewBestRuns => 'Se de bedste runder';

  @override
  String get stormBestRunOfDay => 'Dagens bedste runde';

  @override
  String get stormRuns => 'Runder';

  @override
  String get stormGetReady => 'Gør dig klar!';

  @override
  String get stormWaitingForMorePlayers => 'Venter på at flere spillere slutter sig til...';

  @override
  String get stormRaceComplete => 'Race fuldført!';

  @override
  String get stormSpectating => 'Tilskuere';

  @override
  String get stormJoinTheRace => 'Deltag i racet!';

  @override
  String get stormStartTheRace => 'Start racet';

  @override
  String stormYourRankX(String param) {
    return 'Din rang: $param';
  }

  @override
  String get stormWaitForRematch => 'Vent på omkamp';

  @override
  String get stormNextRace => 'Næste race';

  @override
  String get stormJoinRematch => 'Deltag i omkamp';

  @override
  String get stormWaitingToStart => 'Venter på at starte';

  @override
  String get stormCreateNewGame => 'Opret et nyt spil';

  @override
  String get stormJoinPublicRace => 'Deltag i et åbent race';

  @override
  String get stormRaceYourFriends => 'Race mod dine venner';

  @override
  String get stormSkip => 'spring over';

  @override
  String get stormSkipHelp => 'NYT! Du kan springe ét træk over pr. race:';

  @override
  String get stormSkipExplanation => 'Spring dette træk over for at bevare din kombo! Virker kun én gang pr. race.';

  @override
  String get stormFailedPuzzles => 'Mislykkede taktikopgaver';

  @override
  String get stormSlowPuzzles => 'Langsomme taktikopgaver';

  @override
  String get stormSkippedPuzzle => 'Oversprunget taktikopgave';

  @override
  String get stormThisWeek => 'Denne uge';

  @override
  String get stormThisMonth => 'Denne måned';

  @override
  String get stormAllTime => 'Alle tiders';

  @override
  String get stormClickToReload => 'Klik for at genindlæse';

  @override
  String get stormThisRunHasExpired => 'Denne runde er afsluttet!';

  @override
  String get stormThisRunWasOpenedInAnotherTab => 'Denne runde blev åbnet i en anden fane!';

  @override
  String stormXRuns(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count runder',
      one: 'Første runde',
    );
    return '$_temp0';
  }

  @override
  String stormPlayedNbRunsOfPuzzleStorm(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Spillede $count runder af $param2',
      one: 'Spillede en runde af $param2',
    );
    return '$_temp0';
  }

  @override
  String get streamerLichessStreamers => 'Lichess-streamere';

  @override
  String get studyShareAndExport => 'Del & eksport';

  @override
  String get studyStart => 'Start';
}
