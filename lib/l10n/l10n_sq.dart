import 'package:intl/intl.dart' as intl;

import 'l10n.dart';

/// The translations for Albanian (`sq`).
class AppLocalizationsSq extends AppLocalizations {
  AppLocalizationsSq([String locale = 'sq']) : super(locale);

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
  String get activityActivity => 'Aktiviteti';

  @override
  String get activityHostedALiveStream => 'Priti një transmetim të drejtpërdrejtë';

  @override
  String activityRankedInSwissTournament(String param1, String param2) {
    return 'Renditur #$param1 në $param2';
  }

  @override
  String get activitySignedUp => 'Regjistruar në lichess.org';

  @override
  String activitySupportedNbMonths(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Mbështeti lichess.org për $count muaj si $param2',
      one: 'Mbështeti lichess.org për $count muaj si $param2',
    );
    return '$_temp0';
  }

  @override
  String activityPracticedNbPositions(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Ushtroi $count pozicione në $param2',
      one: 'U praktikua pozicioni $count në $param2',
    );
    return '$_temp0';
  }

  @override
  String activitySolvedNbPuzzles(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Zgjidhi $count ushtrime taktike',
      one: 'Zgjidhet enigma taktike $count',
    );
    return '$_temp0';
  }

  @override
  String activityPlayedNbGames(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Luajti $count lojëra $param2',
      one: 'Luajti lojë $count $param2',
    );
    return '$_temp0';
  }

  @override
  String activityPostedNbMessages(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Postoi $count mesazhe në $param2',
      one: 'Postuar $count mesazh në $param2',
    );
    return '$_temp0';
  }

  @override
  String activityPlayedNbMoves(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Bëri $count lëvizje',
      one: 'Luajti lëvizje $count',
    );
    return '$_temp0';
  }

  @override
  String activityInNbCorrespondenceGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'në $count lojëra korrespondence',
      one: 'në lojën e korrespondencës $count',
    );
    return '$_temp0';
  }

  @override
  String activityCompletedNbGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Plotësoi $count lojëra me korrespondencë',
      one: 'Përfundoi lojën e korrespondencës $count',
    );
    return '$_temp0';
  }

  @override
  String activityFollowedNbPlayers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Filloi të ndjekë $count lojtarë',
      one: 'Filloi të ndjek lojtarin $count',
    );
    return '$_temp0';
  }

  @override
  String activityGainedNbFollowers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Përfitoi $count ndjekës të ri',
      one: 'Fitoi %një ndjekës të ri',
    );
    return '$_temp0';
  }

  @override
  String activityHostedNbSimuls(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Zhvilloi $count lojëra të njëkohësishme',
      one: 'Zhvilloi $count lojëra të njëkohësishme',
    );
    return '$_temp0';
  }

  @override
  String activityJoinedNbSimuls(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Mori pjesë në $count ndeshje të njëkohësishme',
      one: 'Mori pjesë në $count ndeshje të njëkohësishme',
    );
    return '$_temp0';
  }

  @override
  String activityCreatedNbStudies(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Krijoi $count mësime të reja',
      one: 'Krijoi $count studim të ri',
    );
    return '$_temp0';
  }

  @override
  String activityCompetedInNbTournaments(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Ndeshur në $count turne Arenë',
      one: 'Konkuroi në turneun $count Arena',
    );
    return '$_temp0';
  }

  @override
  String activityRankedInTournament(int count, String param2, String param3, String param4) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'U rendit i $count ($param2% kryesuesit) me $param3 lojëra në $param4',
      one: 'U rendit i $count ($param2% kryesuesit) me $param3 lojë në $param4',
    );
    return '$_temp0';
  }

  @override
  String activityCompetedInNbSwissTournaments(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Ndeshur në $count turne zviceranë',
      one: 'Konkuroi në turneun zviceran $count',
    );
    return '$_temp0';
  }

  @override
  String activityJoinedNbTeams(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'U bë pjesë e $count ekipive',
      one: 'U bashkua me ekipin $count',
    );
    return '$_temp0';
  }

  @override
  String get broadcastBroadcasts => 'Transmetime';

  @override
  String get broadcastLiveBroadcasts => 'Transmetime të drejtpërdrejta turnesh';

  @override
  String challengeChallengesX(String param1) {
    return 'Challenges: $param1';
  }

  @override
  String get challengeChallengeToPlay => 'Sfidoni në një lojë';

  @override
  String get challengeChallengeDeclined => 'Sfida u refuzua';

  @override
  String get challengeChallengeAccepted => 'Sfida u pranua!';

  @override
  String get challengeChallengeCanceled => 'Sfida u anulua.';

  @override
  String get challengeRegisterToSendChallenges => 'Që të dërgoni sfidë, ju lutemi, regjistrohuni.';

  @override
  String challengeYouCannotChallengeX(String param) {
    return 'S’mund të sfidoni $param.';
  }

  @override
  String challengeXDoesNotAcceptChallenges(String param) {
    return '$param nuk pranon sfida.';
  }

  @override
  String challengeYourXRatingIsTooFarFromY(String param1, String param2) {
    return 'Vlerësimi juaj prej $param1 është shumë larg nga $param2.';
  }

  @override
  String challengeCannotChallengeDueToProvisionalXRating(String param) {
    return 'S’mund të jepni sfida, për shkak vlerësimi të përkohshëm $param.';
  }

  @override
  String challengeXOnlyAcceptsChallengesFromFriends(String param) {
    return '$param pranon sfida vetëm nga shokë.';
  }

  @override
  String get challengeDeclineGeneric => 'Hëpërhë s’pranoj sfida.';

  @override
  String get challengeDeclineLater => 'S’është koha e duhur për mua, ju lutemi, pyetni më vonë.';

  @override
  String get challengeDeclineTooFast => 'Ky kontroll kohe është shumë i shpejtë për mua, ju lutemi, ribëni sfidë me një lojë më të ngadaltë.';

  @override
  String get challengeDeclineTooSlow => 'Ky kontroll kohe është shumë i ngadaltë për mua, ju lutemi, ribëni sfidë me një lojë më të ngadaltë.';

  @override
  String get challengeDeclineTimeControl => 'Nuk pranoj sfida me këtë kontroll kohe.';

  @override
  String get challengeDeclineRated => 'Të lutem më dërgo një sfide të vlerësuar.';

  @override
  String get challengeDeclineCasual => 'Të lutem më dërgo një sfide të pa vlerësuar.';

  @override
  String get challengeDeclineStandard => 'Tani për tani s’pranoj sfida variantesh.';

  @override
  String get challengeDeclineVariant => 'Tani për tani s’kam dëshirë të luaj këtë variant.';

  @override
  String get challengeDeclineNoBot => 'S’pranoj sfida prej robotësh.';

  @override
  String get challengeDeclineOnlyBot => 'Pranoj vetëm sfida prej robotësh.';

  @override
  String get challengeInviteLichessUser => 'Ose ftoni një Përdorues Lichess-i:';

  @override
  String get contactContact => 'Kontakt';

  @override
  String get contactContactLichess => 'Kontaktoni me Lichess-in';

  @override
  String get patronDonate => 'Dhuroni';

  @override
  String get patronLichessPatron => 'Bamirës Lichess-i';

  @override
  String perfStatPerfStats(String param) {
    return 'Statistika për $param';
  }

  @override
  String get perfStatViewTheGames => 'Shihni lojëra';

  @override
  String get perfStatProvisional => 'i përkohshëm';

  @override
  String get perfStatNotEnoughRatedGames => 'S’janë luajtur lojëra të mjaftueshme për të vendosur një klasifikim të besueshëm.';

  @override
  String perfStatProgressOverLastXGames(String param) {
    return 'Ecuria përgjatë $param lojërave të fundit:';
  }

  @override
  String perfStatRatingDeviation(String param) {
    return 'Shmangie vlerësimi: $param.';
  }

  @override
  String perfStatRatingDeviationTooltip(String param1, String param2, String param3) {
    return 'Një vlerë e ulët do të thotë se vlerësimi është më i qëndrueshëm. Mbi $param1, vlerësimi konsiderohet i përkohshëm. Që të përfshiheni në klasifikime, kjo vlerë duhet të jetë $param2 (shah standard), ose $param3 (variante).';
  }

  @override
  String get perfStatTotalGames => 'Lojëra gjithsej';

  @override
  String get perfStatRatedGames => 'Lojë të vlerësuara';

  @override
  String get perfStatTournamentGames => 'Lojëra turneu';

  @override
  String get perfStatBerserkedGames => 'Lojëra berserk';

  @override
  String get perfStatTimeSpentPlaying => 'Kohë e shpenzuar në lojë';

  @override
  String get perfStatAverageOpponent => 'Kundërshtari mesatar';

  @override
  String get perfStatVictories => 'Fitore';

  @override
  String get perfStatDefeats => 'Humbje';

  @override
  String get perfStatDisconnections => 'Shkëputje';

  @override
  String get perfStatNotEnoughGames => 'Numër i pamjaftueshëm lojërash';

  @override
  String perfStatHighestRating(String param) {
    return 'Vlerësimi më i lartë: $param';
  }

  @override
  String perfStatLowestRating(String param) {
    return 'Vlerësimi më i ulet: $param';
  }

  @override
  String perfStatFromXToY(String param1, String param2) {
    return 'nga $param1 deri $param2';
  }

  @override
  String get perfStatWinningStreak => 'Fitore radhazi';

  @override
  String get perfStatLosingStreak => 'Humbje radhazi';

  @override
  String perfStatLongestStreak(String param) {
    return 'Vijimësia më e gjatë: $param';
  }

  @override
  String perfStatCurrentStreak(String param) {
    return 'Vijimësi aktuale: $param';
  }

  @override
  String get perfStatBestRated => 'Fitoret më të mira';

  @override
  String get perfStatGamesInARow => 'Lojëra radhazi';

  @override
  String get perfStatLessThanOneHour => 'Më pak se një orë mes lojërave';

  @override
  String get perfStatMaxTimePlaying => 'Maksimum kohe shpenzuar në lojë';

  @override
  String get perfStatNow => 'tani';

  @override
  String get preferencesPreferences => 'Parapëlqime';

  @override
  String get preferencesDisplay => 'Shfaqje';

  @override
  String get preferencesPrivacy => 'Privatësi';

  @override
  String get preferencesNotifications => 'Njoftime';

  @override
  String get preferencesPieceAnimation => 'Animimi i figurave';

  @override
  String get preferencesMaterialDifference => 'Ndryshimi në material';

  @override
  String get preferencesBoardHighlights => 'Thekso fushën, (lëvizjen e fundit dhe shah)';

  @override
  String get preferencesPieceDestinations => 'Vendmbërritja e figurave (lëvizje të vlefshme dhe të paracaktuara)';

  @override
  String get preferencesBoardCoordinates => 'Koordinatat e fushës (A-H, 1-8)';

  @override
  String get preferencesMoveListWhilePlaying => 'Listë lëvizjesh teksa luhet';

  @override
  String get preferencesPgnPieceNotation => 'Shënime lëvizjesh';

  @override
  String get preferencesChessPieceSymbol => 'Simboli i figurës së shahut';

  @override
  String get preferencesPgnLetter => 'Shkronja (K, Q, R, B, N)';

  @override
  String get preferencesZenMode => 'Mënyra Zen';

  @override
  String get preferencesShowPlayerRatings => 'Shfaq klasifikim lojtarësh';

  @override
  String get preferencesShowFlairs => 'Show player flairs';

  @override
  String get preferencesExplainShowPlayerRatings => 'Kjo lejon të bëhet fshehja e krejt klasifikimeve në sajt, për të ndihmuar përqendrimin në shah. Lojërat prapë mund të vlerësohen, kjo ka të bëjë vetëm me ato çka shihni.';

  @override
  String get preferencesDisplayBoardResizeHandle => 'Shfaq mundësi ripërmasimi fushe';

  @override
  String get preferencesOnlyOnInitialPosition => 'Vetëm në pozicionin fillestar';

  @override
  String get preferencesInGameOnly => 'In-game only';

  @override
  String get preferencesChessClock => 'Ora e shahut';

  @override
  String get preferencesTenthsOfSeconds => 'Të dhjeta të sekondës';

  @override
  String get preferencesWhenTimeRemainingLessThanTenSeconds => 'Kur koha e mbetur <10 sekonda';

  @override
  String get preferencesHorizontalGreenProgressBars => 'Shtyllë ecurie horizontale e gjelbër';

  @override
  String get preferencesSoundWhenTimeGetsCritical => 'Tingull kur koha i afrohet kritikes';

  @override
  String get preferencesGiveMoreTime => 'Jep më shumë kohë';

  @override
  String get preferencesGameBehavior => 'Sjellje loje';

  @override
  String get preferencesHowDoYouMovePieces => 'Si i lëvizni figurat?';

  @override
  String get preferencesClickTwoSquares => 'Klikoni dy kuadrate';

  @override
  String get preferencesDragPiece => 'Tërhiqni një figurë';

  @override
  String get preferencesBothClicksAndDrag => 'Cilëndo';

  @override
  String get preferencesPremovesPlayingDuringOpponentTurn => 'Lëvizje e paracaktuar (luajtur gjatë radhës së kundërshtarit)';

  @override
  String get preferencesTakebacksWithOpponentApproval => 'Marrje mbrapsht (me miratimin e kundërshtarit)';

  @override
  String get preferencesInCasualGamesOnly => 'Vetëm në lojëra të rastësishme';

  @override
  String get preferencesPromoteToQueenAutomatically => 'Dalja automatike në mbretëreshë';

  @override
  String get preferencesExplainPromoteToQueenAutomatically => 'Mbani të shtypur tastin <Ctrl> gjatë daljes, për të çaktivizuar përkohësisht daljet e automatizuara';

  @override
  String get preferencesWhenPremoving => 'Kur bëhet lëvizje e paracaktuar';

  @override
  String get preferencesClaimDrawOnThreefoldRepetitionAutomatically => 'Kërko automatikisht barazim pas përsëritjeje të trefishtë';

  @override
  String get preferencesWhenTimeRemainingLessThanThirtySeconds => 'Kur koha e mbetur <30 sekonda';

  @override
  String get preferencesMoveConfirmation => 'Ripohim lëvizjesh';

  @override
  String get preferencesExplainCanThenBeTemporarilyDisabled => 'Mund të çaktivizohet gjatë një loje me menu tabele';

  @override
  String get preferencesInCorrespondenceGames => 'Lojëra me korrespondencë';

  @override
  String get preferencesCorrespondenceAndUnlimited => 'Me korrespondencë dhe e pakufizuar';

  @override
  String get preferencesConfirmResignationAndDrawOffers => 'Ripoho dorëzimin dhe ofrime barazimi';

  @override
  String get preferencesCastleByMovingTheKingTwoSquaresOrOntoTheRook => 'Metodë rokade';

  @override
  String get preferencesCastleByMovingTwoSquares => 'Lëvize mbretin dy kuadrate';

  @override
  String get preferencesCastleByMovingOntoTheRook => 'Lëvize mbretin tek torra';

  @override
  String get preferencesInputMovesWithTheKeyboard => 'Jepni lëvizje përmes tastiere';

  @override
  String get preferencesInputMovesWithVoice => 'Kryeni lëvizje përmes zërit tuaj';

  @override
  String get preferencesSnapArrowsToValidMoves => 'Snap arrows to valid moves';

  @override
  String get preferencesSayGgWpAfterLosingOrDrawing => 'Shkruaj “Lojë e mirë, bukur luajtët” pas barazimit ose humbjes';

  @override
  String get preferencesYourPreferencesHaveBeenSaved => 'Parapëlqimet tuaja u ruajtën.';

  @override
  String get preferencesScrollOnTheBoardToReplayMoves => 'Rrëshqitni nëpër tabelë që të riluhen lëvizje';

  @override
  String get preferencesCorrespondenceEmailNotification => 'Njoftim i përditshëm me email, që paraqet lojërat tuaja me korrespondencë';

  @override
  String get preferencesNotifyStreamStart => 'Streamer goes live';

  @override
  String get preferencesNotifyInboxMsg => 'Mesazh i ri te Të marrë';

  @override
  String get preferencesNotifyForumMention => 'Koment forumi ku përmendeni';

  @override
  String get preferencesNotifyInvitedStudy => 'Ftesë për ushtrim';

  @override
  String get preferencesNotifyGameEvent => 'Përditësime loje me korrespondencë';

  @override
  String get preferencesNotifyChallenge => 'Challenges';

  @override
  String get preferencesNotifyTournamentSoon => 'Turne që fillon së shpejti';

  @override
  String get preferencesNotifyTimeAlarm => 'Correspondence clock running out';

  @override
  String get preferencesNotifyBell => 'Njoftim zileje brenda Lichess-it';

  @override
  String get preferencesNotifyPush => 'Njoftim pajisjeje kur s’gjendeni në Lichess';

  @override
  String get preferencesNotifyWeb => 'Shfletues';

  @override
  String get preferencesNotifyDevice => 'Pajisje';

  @override
  String get preferencesBellNotificationSound => 'Tingull zileje njoftimesh';

  @override
  String get puzzlePuzzles => 'Ushtrime';

  @override
  String get puzzlePuzzleThemes => 'Tema ushtrimesh';

  @override
  String get puzzleRecommended => 'Të rekomanduara';

  @override
  String get puzzlePhases => 'Faza';

  @override
  String get puzzleMotifs => 'Motive';

  @override
  String get puzzleAdvanced => 'Të mëtejshme';

  @override
  String get puzzleLengths => 'Gjatësi';

  @override
  String get puzzleMates => 'Mate';

  @override
  String get puzzleGoals => 'Objektiva';

  @override
  String get puzzleOrigin => 'Origjinë';

  @override
  String get puzzleSpecialMoves => 'Lëvizje speciale';

  @override
  String get puzzleDidYouLikeThisPuzzle => 'Ju pëlqeu ky ushtrim?';

  @override
  String get puzzleVoteToLoadNextOne => 'Votojeni, që të ngarkohet pasuesi!';

  @override
  String get puzzleUpVote => 'Jepini një votë ushtrimit';

  @override
  String get puzzleDownVote => 'Hiqini një votë ushtrimit';

  @override
  String get puzzleYourPuzzleRatingWillNotChange => 'Vlerësimi juaj për ushtrimet nuk do të ndryshojë. Kini parasysh se ushtrimet nuk janë garë. Vlerësimi juaj ndihmon në përzgjedhjen e ushtrimeve më të mira për aftësitë tuaja të tanishme.';

  @override
  String get puzzleFindTheBestMoveForWhite => 'Gjej lëvizjen më të mirë për të bardhin.';

  @override
  String get puzzleFindTheBestMoveForBlack => 'Gjej lëvizjen më të mirë për të ziun.';

  @override
  String get puzzleToGetPersonalizedPuzzles => 'Për të marrë ushtrime të personalizuara:';

  @override
  String puzzlePuzzleId(String param) {
    return 'Ushtrimi $param';
  }

  @override
  String get puzzlePuzzleOfTheDay => 'Ushtrimi i ditës';

  @override
  String get puzzleDailyPuzzle => 'Daily Puzzle';

  @override
  String get puzzleClickToSolve => 'Klikoni për t’a zgjidhur';

  @override
  String get puzzleGoodMove => 'Lëvizje e mirë';

  @override
  String get puzzleBestMove => 'Lëvizja më e mirë!';

  @override
  String get puzzleKeepGoing => 'Vazhdoni…';

  @override
  String get puzzlePuzzleSuccess => 'Sukses!';

  @override
  String get puzzlePuzzleComplete => 'Ushtrimi u plotësua!';

  @override
  String get puzzleByOpenings => 'Sipas hapjesh';

  @override
  String get puzzlePuzzlesByOpenings => 'Puzzles by openings';

  @override
  String get puzzleOpeningsYouPlayedTheMost => 'Hapje që bëtë në lojërat më të vlerësuara';

  @override
  String get puzzleUseFindInPage => 'Që të gjeni hapen tuaj të parapëlqyer, përdorni “Gjej në faqe” te menuja e shfletuesit!';

  @override
  String get puzzleUseCtrlF => 'Që të gjeni hapjen tuaj të parapëlqyer, përdorni Ctrl+f!';

  @override
  String get puzzleNotTheMove => 'S’është lëvizja e duhur!';

  @override
  String get puzzleTrySomethingElse => 'Provoni diçka tjetër.';

  @override
  String puzzleRatingX(String param) {
    return 'Vlerësimi: $param';
  }

  @override
  String get puzzleHidden => 'i fshehur';

  @override
  String puzzleFromGameLink(String param) {
    return 'Prej lojës $param';
  }

  @override
  String get puzzleContinueTraining => 'Vazhdoni trajnimin';

  @override
  String get puzzleDifficultyLevel => 'Shkallë vështirësie';

  @override
  String get puzzleNormal => 'Normale';

  @override
  String get puzzleEasier => 'Më e lehtë';

  @override
  String get puzzleEasiest => 'Më e lehta';

  @override
  String get puzzleHarder => 'Më e vështirë';

  @override
  String get puzzleHardest => 'Më e vështira';

  @override
  String get puzzleExample => 'Shembull';

  @override
  String get puzzleAddAnotherTheme => 'Shtoni temë tjetër';

  @override
  String get puzzleNextPuzzle => 'Ushtrimi pasues';

  @override
  String get puzzleJumpToNextPuzzleImmediately => 'Kalo menjëherë në ushtrimin pasues';

  @override
  String get puzzlePuzzleDashboard => 'Pult Ushtrimesh';

  @override
  String get puzzleImprovementAreas => 'Fusha përmirësimi';

  @override
  String get puzzleStrengths => 'Vështirësi';

  @override
  String get puzzleHistory => 'Historik ushtrimesh';

  @override
  String get puzzleSolved => 'të zgjidhura';

  @override
  String get puzzleFailed => 'të pazgjidhura';

  @override
  String get puzzleStreakDescription => 'Zgjidh ushtrime që bëhen më të vështira. Nuk ka kufizim kohe, kështu qe mendohu mirë, një lëvizje e gabuar, dhe humb! Mund ta kapërcesh vetëm një ushtrim.';

  @override
  String puzzleYourStreakX(String param) {
    return 'Rrezultati juaj: $param';
  }

  @override
  String get puzzleStreakSkipExplanation => 'Kapërce këtë lëvizje qe te ruash kombinimet! Bën vetëm një herë per garë.';

  @override
  String get puzzleContinueTheStreak => 'Vazhdoje raundin';

  @override
  String get puzzleNewStreak => 'Raund i ri';

  @override
  String get puzzleFromMyGames => 'Nga lojërat e mia';

  @override
  String get puzzleLookupOfPlayer => 'Kërkoni te ushtrime prej lojërave të një lojtari';

  @override
  String puzzleFromXGames(String param) {
    return 'Ushtrime nga lojërat e $param';
  }

  @override
  String get puzzleSearchPuzzles => 'Kërkoni në ushtrime';

  @override
  String get puzzleFromMyGamesNone => 'S’keni ushtrime te baza e të dhënave, por Lichess-i prapë ju do fort.\n\nLuani lojëra të shpejta dhe klasike, që të rriten shanset tuaja për të pasur një ushtrim nga tuajt të shtuar atje!';

  @override
  String puzzleFromXGamesFound(String param1, String param2) {
    return 'U gjetën $param1 ushtrime në $param2 lojëra';
  }

  @override
  String get puzzlePuzzleDashboardDescription => 'Stërvituni, analizoni, përmirësohuni';

  @override
  String puzzlePercentSolved(String param) {
    return '$param të zgjidhur';
  }

  @override
  String get puzzleNoPuzzlesToShow => 'S’ka gjë për shfaqje, shkoni e luani ca ushtrime, së pari!';

  @override
  String get puzzleImprovementAreasDescription => 'Stërvituni me këto, që të optimizoni përparimin tuaj!';

  @override
  String get puzzleStrengthDescription => 'Dilni më mirë në këto tema';

  @override
  String puzzlePlayedXTimes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Luajtur $count herë',
      one: 'Luajtur $count herë',
    );
    return '$_temp0';
  }

  @override
  String puzzleNbPointsBelowYourPuzzleRating(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count pikë nën vlerësimin tuaj në ushtrime',
      one: 'Një pikë nën vlerësimin tuaj në ushtrime',
    );
    return '$_temp0';
  }

  @override
  String puzzleNbPointsAboveYourPuzzleRating(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count pikë mbi vlerësimin tuaj në ushtrime',
      one: 'Një pikë mbi vlerësimin tuaj në ushtrime',
    );
    return '$_temp0';
  }

  @override
  String puzzleNbPlayed(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count të luajtur',
      one: '$count i luajtur',
    );
    return '$_temp0';
  }

  @override
  String puzzleNbToReplay(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count për t’u riluajtur',
      one: '$count për t’u riluajtur',
    );
    return '$_temp0';
  }

  @override
  String get puzzleThemeAdvancedPawn => 'Ushtar i përparuar';

  @override
  String get puzzleThemeAdvancedPawnDescription => 'Një nga ushtarët tuaj ka hyrë thellë në territorin e kundërshtarit, ndoshta duke kërcënuar të gradohet.';

  @override
  String get puzzleThemeAdvantage => 'Avantazh';

  @override
  String get puzzleThemeAdvantageDescription => 'Shfrytëzoni shansin tuaj që të përfitoni një avantazh vendimtar. (200cp ≤ vlerë ≤ 600cp)';

  @override
  String get puzzleThemeAnastasiaMate => 'Mati i Anastasisë';

  @override
  String get puzzleThemeAnastasiaMateDescription => 'Një kalë dhe torrë ose mbretëreshë bëhen tok për të bllokuar mbretin kundërshtar mes anës së fushës dhe një guri miqësor.';

  @override
  String get puzzleThemeArabianMate => 'Mat arab';

  @override
  String get puzzleThemeArabianMateDescription => 'Një kalë dhe një torrë bëhen tok për të bllokuar mbretin kundërshtar në një cep të fushës.';

  @override
  String get puzzleThemeAttackingF2F7 => 'Sulmim i f2-shit ose f7-s';

  @override
  String get puzzleThemeAttackingF2F7Description => 'Një sulm që synon ushtarin në f2 ose f7, si te hapja “mëlçi të skuqura”.';

  @override
  String get puzzleThemeAttraction => 'Tërheqje';

  @override
  String get puzzleThemeAttractionDescription => 'Një shkëmbim ose sakrificë që e nxit ose e detyron një gur të kundërshtarit të shkojë në një kuadrat që lejon më pas një lëvizje taktike.';

  @override
  String get puzzleThemeBackRankMate => 'Mat në rreshtin e fundit';

  @override
  String get puzzleThemeBackRankMateDescription => 'Jepini mat mbretin në rreshtin e tij, kur ai është bllokuar atje nga gurë të vetët.';

  @override
  String get puzzleThemeBishopEndgame => 'Fund loje me oficer';

  @override
  String get puzzleThemeBishopEndgameDescription => 'Fund loje me vetëm oficerë dhe ushtarë.';

  @override
  String get puzzleThemeBodenMate => 'Mati i Bodenit';

  @override
  String get puzzleThemeBodenMateDescription => 'Dy fila sulmues në diagonalet kryqëzuese i bëjne mat një mbreti të penguar nga figura miqësore.';

  @override
  String get puzzleThemeCastling => 'Rokadë';

  @override
  String get puzzleThemeCastlingDescription => 'Siguroni mbretin dhe futeni torrën në sulm.';

  @override
  String get puzzleThemeCapturingDefender => 'Merrni mbrojtësin';

  @override
  String get puzzleThemeCapturingDefenderDescription => 'Heqja e një pjese që është kritike për mbrojtjen e një pjese tjetër, çka tani lejon që pjesa e pambrojtur të merret me një lëvizje vijuese.';

  @override
  String get puzzleThemeCrushing => 'Shkatërrim';

  @override
  String get puzzleThemeCrushingDescription => 'Shfrytëzoni gafën e kundërshtarit për të përfituar një avantazh shkatërrues. (vlera ≥ 600 cp)';

  @override
  String get puzzleThemeDoubleBishopMate => 'Mat me dy oficerë';

  @override
  String get puzzleThemeDoubleBishopMateDescription => 'Dy oficerë në sulm, në diagonale krah njëra-tjetrës, i japin mat mbretit të penguar nga figura miqësore.';

  @override
  String get puzzleThemeDovetailMate => 'Mati bishtpëllumb';

  @override
  String get puzzleThemeDovetailMateDescription => 'Një mbretëreshë i jep mat një mbretit afër, dy kuadratet e vetme të shpëtimit të të cilit janë zënë nga gurë të vetët.';

  @override
  String get puzzleThemeEquality => 'Barazim';

  @override
  String get puzzleThemeEqualityDescription => 'Kthehuni nga një pozicion humbës dhe siguroni një barazim ose një pozicion të ekuilibruar. (vlera ≤ 200cp)';

  @override
  String get puzzleThemeKingsideAttack => 'Sulmi nga ana e mbretit';

  @override
  String get puzzleThemeKingsideAttackDescription => 'Një sulm në anë të mbretit, pasi bëri rrokade në anë te mbretit.';

  @override
  String get puzzleThemeClearance => 'Largim';

  @override
  String get puzzleThemeClearanceDescription => 'Një lëvizje, shpesh me tempo, që pastron një katror, kolonë ose diagonale për një ide taktike vijuese.';

  @override
  String get puzzleThemeDefensiveMove => 'Lëvizje mbrojtëse';

  @override
  String get puzzleThemeDefensiveMoveDescription => 'Një lëvizje apo varg lëvizjesh të sakta që janë të nevojshme për të shmangur humbje materiali, apo për avantazh tjetër.';

  @override
  String get puzzleThemeDeflection => 'Shmangie';

  @override
  String get puzzleThemeDeflectionDescription => 'Një lëvizje që tërheq vëmendjen e një figure të kundërshtarit nga një detyrë tjetër që ajo kryen, siç është ruajtja e një sheshi kryesor. Ndonjëherë quhet edhe \"mbingarkesë\".';

  @override
  String get puzzleThemeDiscoveredAttack => 'Sulm me zbulim';

  @override
  String get puzzleThemeDiscoveredAttackDescription => 'Lëvizja e një figure (për shembull një kalë) që më parë bllokoi një sulm nga një figurë me distancë të gjatë (për shembull një torre), nga rruga e asaj figure.';

  @override
  String get puzzleThemeDoubleCheck => 'Shah i dyfishtë';

  @override
  String get puzzleThemeDoubleCheckDescription => 'Shah me dy figura njëherësh, si pasojë e një sulmi me zbulim, kur që të dy, guri që lëviz dhe guri i pazbuluar sulmojnë mbretin e kundërshtarit.';

  @override
  String get puzzleThemeEndgame => 'Fund loje';

  @override
  String get puzzleThemeEndgameDescription => 'Një taktikë gjatë fazës së fundit të lojës.';

  @override
  String get puzzleThemeEnPassantDescription => 'Një taktikë që përfshin rregullin “me prerje”, ku një ushtar mund të marrë një ushtar kundërshtar që e ka kaluar atë duke përdorur lëvizjen e vet fillestare të dy kuadrateve.';

  @override
  String get puzzleThemeExposedKing => 'Mbreti i ekspozuar';

  @override
  String get puzzleThemeExposedKingDescription => 'Një taktikë që përfshin një mbret me pak mbrojtës rreth tij, që shpesh çon në shah mat.';

  @override
  String get puzzleThemeFork => 'Sfurk';

  @override
  String get puzzleThemeForkDescription => 'Një lëvizje ku guri i lëvizur sulmon njëherësh dy gurë të kundërshtarit.';

  @override
  String get puzzleThemeHangingPiece => 'Gur i pambrojtur';

  @override
  String get puzzleThemeHangingPieceDescription => 'Një taktikë që përfshin një gur të pambrojtur të kundërshtarit, ose të mbrojtur në mënyrë të pamjaftueshme dhe që është i lirë të marrë gurë.';

  @override
  String get puzzleThemeHookMate => 'Mati Huk';

  @override
  String get puzzleThemeHookMateDescription => 'Shat mat me një torrë, kalë dhe një ushtar, tok me një ushtar të kundërshtarit, për të kufizuar arratisjen e mbretit të kundërshtarit.';

  @override
  String get puzzleThemeInterference => 'Ndërhyrje';

  @override
  String get puzzleThemeInterferenceDescription => 'Lëvizja e një guri mes dy gurësh të kundërshtarit për të lënë të pambrojtur një ose të dy gurët e kundërshtarit, bie fjala, një kalë në një kuadrat mes dy torresh.';

  @override
  String get puzzleThemeIntermezzo => 'Ndërmjetësim';

  @override
  String get puzzleThemeIntermezzoDescription => 'Në vend që të luhet lëvizja e pritshme, së pari ndërhyni një lëvizje tjetër që paraqet një kërcënim të menjëhershëm, që kundërshtari duhet t\'i përgjigjet. Njihet gjithashtu si \"Zwischenzug\" ose \"Në mes\".';

  @override
  String get puzzleThemeKnightEndgame => 'Fund loje me kalë';

  @override
  String get puzzleThemeKnightEndgameDescription => 'Një fund loje vetëm me kuaj dhe ushtarë.';

  @override
  String get puzzleThemeLong => 'Ushtrim i gjatë';

  @override
  String get puzzleThemeLongDescription => 'Tri lëvizje për të fituar.';

  @override
  String get puzzleThemeMaster => 'Lojëra Mjeshtrash';

  @override
  String get puzzleThemeMasterDescription => 'Ushtrime nga lojëra të luajtura nga lojtarë me tituj.';

  @override
  String get puzzleThemeMasterVsMaster => 'Lojëra mjeshtër kundër mjeshtri';

  @override
  String get puzzleThemeMasterVsMasterDescription => 'Ushtrime nga lojëra të luajtura mes dy lojtarësh me tituj.';

  @override
  String get puzzleThemeMate => 'Shat mat';

  @override
  String get puzzleThemeMateDescription => 'Fitojeni lojën me stil.';

  @override
  String get puzzleThemeMateIn1 => 'Mat me 1';

  @override
  String get puzzleThemeMateIn1Description => 'Jepni shah-mat me një lëvizje.';

  @override
  String get puzzleThemeMateIn2 => 'Mat me 2';

  @override
  String get puzzleThemeMateIn2Description => 'Jepni shah-mat me dy lëvizje.';

  @override
  String get puzzleThemeMateIn3 => 'Mat me 3';

  @override
  String get puzzleThemeMateIn3Description => 'Jepni shah-mat me tre lëvizje.';

  @override
  String get puzzleThemeMateIn4 => 'Mat me 4';

  @override
  String get puzzleThemeMateIn4Description => 'Jepni shah-mat me katër lëvizje.';

  @override
  String get puzzleThemeMateIn5 => 'Mat me 5 ose më tepër';

  @override
  String get puzzleThemeMateIn5Description => 'Gjeni një varg të gjatë lëvizjesh për mat.';

  @override
  String get puzzleThemeMiddlegame => 'Lojë e mesme';

  @override
  String get puzzleThemeMiddlegameDescription => 'Një taktikë gjatë fazës së dytë të lojës.';

  @override
  String get puzzleThemeOneMove => 'Ushtrime me një lëvizje';

  @override
  String get puzzleThemeOneMoveDescription => 'Një ushtrim që zgjidhet me një lëvizje.';

  @override
  String get puzzleThemeOpening => 'Hapje';

  @override
  String get puzzleThemeOpeningDescription => 'Një taktikë gjatë fazës së parë të lojës.';

  @override
  String get puzzleThemePawnEndgame => 'Fund loje me ushtar';

  @override
  String get puzzleThemePawnEndgameDescription => 'Një fund loje vetëm me ushtarë.';

  @override
  String get puzzleThemePin => 'Mbërthimi';

  @override
  String get puzzleThemePinDescription => 'Një taktikë që përfshin mbërthim, ku një pjesë s’është në gjendje të lëvizë pa zbuluar një sulm ndaj një guri me vlerë më të lartë.';

  @override
  String get puzzleThemePromotion => 'Gradim';

  @override
  String get puzzleThemePromotionDescription => 'Gradoni një nga ushtarët tuaj si mbretëreshë ose një gur më të ulët.';

  @override
  String get puzzleThemeQueenEndgame => 'Fund loje me mbretëreshë';

  @override
  String get puzzleThemeQueenEndgameDescription => 'Një fund loje me vetëm mbretëresha dhe ushtarë.';

  @override
  String get puzzleThemeQueenRookEndgame => 'Mbretëreshë dhe Torrë';

  @override
  String get puzzleThemeQueenRookEndgameDescription => 'Një fund loje me vetëm mbretëresha, torra dhe ushtarë.';

  @override
  String get puzzleThemeQueensideAttack => 'Sulm më anë të mbretëreshës';

  @override
  String get puzzleThemeQueensideAttackDescription => 'Sulm ndaj mbretit të kundërshtarit, pas rokade më anë të mbretëreshësh.';

  @override
  String get puzzleThemeQuietMove => 'Lëvizje e qetë';

  @override
  String get puzzleThemeQuietMoveDescription => 'Një lëvizje që s’jep shah ose kap gur, as edhe përbën kërcënim imediat për kapje guri, por përgatit një kërcënim më të fshehur, të pashmangshëm për një lëvizje të mëvonshme.';

  @override
  String get puzzleThemeRookEndgame => 'Fund loje me torre';

  @override
  String get puzzleThemeRookEndgameDescription => 'Një fund loje vetëm me torra dhe ushtarë.';

  @override
  String get puzzleThemeSacrifice => 'Sakrifikim';

  @override
  String get puzzleThemeSacrificeDescription => 'Një taktikë që përfshin heqjen dorë për pak kohë nga materiali, për të fituar sërish avantazh pas një vargu të detyruar lëvizjesh.';

  @override
  String get puzzleThemeShort => 'Ushtrim i shkurtër';

  @override
  String get puzzleThemeShortDescription => 'Dy lëvizje për të fituar.';

  @override
  String get puzzleThemeSkewer => 'Hell';

  @override
  String get puzzleThemeSkewerDescription => 'Një motiv që përfshin një gur me vlerë të madhe i cili ngaqë po sulmohet, hap rrugën dhe lejon të hahet ose të sulmohet një gur me vlerë më të vogël prapa tij, e kundërta e mbërthimit.';

  @override
  String get puzzleThemeSmotheredMate => 'Mat i mbuluar';

  @override
  String get puzzleThemeSmotheredMateDescription => 'Një shah-mat dhënë me kalë, në të cilin mbreti i zënë mat s’është në gjendje të lëvizë ngaqë është i rrethuar (i mbuluar) nga gurët e vet.';

  @override
  String get puzzleThemeSuperGM => 'Lojëra Super Mjeshtërash të Mëdhenj';

  @override
  String get puzzleThemeSuperGMDescription => 'Ushtrime prej lojërash të luajtura nga lojtarët më të mirë të botës.';

  @override
  String get puzzleThemeTrappedPiece => 'Gur i bllokuar';

  @override
  String get puzzleThemeTrappedPieceDescription => 'Një gur s’është në gjendje t’i shpëtojë marrjes, pasi ka lëvizje të kufizuara.';

  @override
  String get puzzleThemeUnderPromotion => 'Nëngradim';

  @override
  String get puzzleThemeUnderPromotionDescription => 'Gradim si kalë, oficer, ose torrë.';

  @override
  String get puzzleThemeVeryLong => 'Ushtrim shumë i gjatë';

  @override
  String get puzzleThemeVeryLongDescription => 'Katër ose më tepër lëvizje për të fituar.';

  @override
  String get puzzleThemeXRayAttack => 'Sulm Rreze-X';

  @override
  String get puzzleThemeXRayAttackDescription => 'Një gur sulmon ose mbron një kuadrat, përmes një guri të kundërshtarit.';

  @override
  String get puzzleThemeZugzwang => 'Zugzwang';

  @override
  String get puzzleThemeZugzwangDescription => 'Kundërshtari është i kufizuar në lëvizjet që mund të bëjë dhe krejt lëvizjet përkeqësojnë pozicionin e tij.';

  @override
  String get puzzleThemeHealthyMix => 'Përzierje e ushtrimeve';

  @override
  String get puzzleThemeHealthyMixDescription => 'Pak nga të gjitha. S’dini ç’të prisni, ndaj mbeteni gati për gjithçka! Mu si në lojëra të njëmendta.';

  @override
  String get puzzleThemePlayerGames => 'Lojëra të lojëtarit';

  @override
  String get puzzleThemePlayerGamesDescription => 'Lookup puzzles generated from your games, or from another player\'s games.';

  @override
  String puzzleThemePuzzleDownloadInformation(String param) {
    return 'Këto ushtrime janë nën përkatësi publike dhe mund të shkarkohen nga $param.';
  }

  @override
  String get searchSearch => 'Kërko';

  @override
  String get settingsSettings => 'Rregullime';

  @override
  String get settingsCloseAccount => 'Mbyll llogarinë';

  @override
  String get settingsManagedAccountCannotBeClosed => 'Llogaria juaj administrohet dhe nuk mund të mbyllet.';

  @override
  String get settingsClosingIsDefinitive => 'Mbyllja është përfundimtare. Nuk ka kthim prapa. A jeni i sigurt?';

  @override
  String get settingsCantOpenSimilarAccount => 'S’do të lejoheni të hapni një llogari të re me të njëjtin emër, edhe nëse ndryshohet një nga shkronjat.';

  @override
  String get settingsChangedMindDoNotCloseAccount => 'Ndryshova mendje, mos e mbyll llogarinë time';

  @override
  String get settingsCloseAccountExplanation => 'Jeni i sigurt se doni të mbyllet llogaria juaj? Mbyllja e llogarisë tuaj është një vendim përfundimtar. S’do të jeni MË KURRË në gjendje të ribëni hyrjen.';

  @override
  String get settingsThisAccountIsClosed => 'Kjo llogari është e mbyllur';

  @override
  String get playWithAFriend => 'Luani me një shok';

  @override
  String get playWithTheMachine => 'Luaj me kompjuterin';

  @override
  String get toInviteSomeoneToPlayGiveThisUrl => 'Për të ftuar dikë të luajë, jepni këtë URL';

  @override
  String get gameOver => 'Loja mbaroi';

  @override
  String get waitingForOpponent => 'Në pritje të kundërshtarit';

  @override
  String get orLetYourOpponentScanQrCode => 'Ose lëreni kundërshtarin tuaj të skanojë këtë kod QR';

  @override
  String get waiting => 'Në pritje';

  @override
  String get yourTurn => 'Radha juaj';

  @override
  String aiNameLevelAiLevel(String param1, String param2) {
    return '$param1 niveli $param2';
  }

  @override
  String get level => 'Niveli';

  @override
  String get strength => 'Vështirësia';

  @override
  String get toggleTheChat => 'Shfaqni/Fshihni bisedën';

  @override
  String get chat => 'Bisedo';

  @override
  String get resign => 'Dorëzohu';

  @override
  String get checkmate => 'Shah mat';

  @override
  String get stalemate => 'Pat';

  @override
  String get white => 'I bardhi';

  @override
  String get black => 'I ziu';

  @override
  String get asWhite => 'me gurë të bardhë';

  @override
  String get asBlack => 'me gurë të zinj';

  @override
  String get randomColor => 'Ngjyrë e rastësishme';

  @override
  String get createAGame => 'Krijo një lojë';

  @override
  String get whiteIsVictorious => 'I bardhi është fitues';

  @override
  String get blackIsVictorious => 'I ziu është fitues';

  @override
  String get youPlayTheWhitePieces => 'Ju luani me të bardhët';

  @override
  String get youPlayTheBlackPieces => 'Ju luani me të zinjtë';

  @override
  String get itsYourTurn => 'Është radha juaj!';

  @override
  String get cheatDetected => 'U pikas Hile';

  @override
  String get kingInTheCenter => 'Mbreti në qendër';

  @override
  String get threeChecks => 'Tre herë shah';

  @override
  String get raceFinished => 'Gara mbaroi';

  @override
  String get variantEnding => 'Varianti mbaroi';

  @override
  String get newOpponent => 'Kundërshtar i ri';

  @override
  String get yourOpponentWantsToPlayANewGameWithYou => 'Kundërshtari juaj dëshiron të luajë lojë të re me ju';

  @override
  String get joinTheGame => 'Hyni në lojë';

  @override
  String get whitePlays => 'I bardhi luan';

  @override
  String get blackPlays => 'Radha e të Ziut';

  @override
  String get opponentLeftChoices => 'Kundërshtari juaj la lojën. Mund të kërkoni fitoren, ta shpallni lojën barazim, ose të prisni.';

  @override
  String get forceResignation => 'Kërko fitoren';

  @override
  String get forceDraw => 'Shpalle barazim';

  @override
  String get talkInChat => 'Ju lutem jini të sjellshëm në bisedë!';

  @override
  String get theFirstPersonToComeOnThisUrlWillPlayWithYou => 'Personi i parë që do të vijë në këtë URL do të luajë me ju.';

  @override
  String get whiteResigned => 'I bardhi u dorëzua';

  @override
  String get blackResigned => 'I ziu u dorëzua';

  @override
  String get whiteLeftTheGame => 'I bardhi e la lojën';

  @override
  String get blackLeftTheGame => 'I ziu e la lojën';

  @override
  String get whiteDidntMove => 'I bardhi s’bëri lëvizje';

  @override
  String get blackDidntMove => 'I ziu s’bëri lëvizje';

  @override
  String get requestAComputerAnalysis => 'Kërko analizë kompjuterike';

  @override
  String get computerAnalysis => 'Analizë kompjuterike';

  @override
  String get computerAnalysisAvailable => 'Analiza kompjuterike është gati';

  @override
  String get computerAnalysisDisabled => 'Analiza kompjuterike u çaktivizua';

  @override
  String get analysis => 'Bordi i analizës';

  @override
  String depthX(String param) {
    return 'Thellësia $param';
  }

  @override
  String get usingServerAnalysis => 'Duke përdorur analizën e shërbyesit';

  @override
  String get loadingEngine => 'Po ngarkohet programi analizues …';

  @override
  String get calculatingMoves => 'Po përllogariten lëvizje…';

  @override
  String get engineFailed => 'Gabim në ngarkim mekanizmi';

  @override
  String get cloudAnalysis => 'Analiza cloud';

  @override
  String get goDeeper => 'Më thellë';

  @override
  String get showThreat => 'Shfaq rrezikun';

  @override
  String get inLocalBrowser => 'në shfletues vendor';

  @override
  String get toggleLocalEvaluation => 'Aktivizoni/Çaktivizoni vlerësim vendor';

  @override
  String get promoteVariation => 'Promovoni variacion';

  @override
  String get makeMainLine => 'Bëje variantin kryesor';

  @override
  String get deleteFromHere => 'Fshije nga këtu';

  @override
  String get collapseVariations => 'Tkurri variantet';

  @override
  String get expandVariations => 'Shfaqi variantet';

  @override
  String get forceVariation => 'Detyro variant';

  @override
  String get copyVariationPgn => 'Kopjo PGN varianti';

  @override
  String get move => 'Lëvizje';

  @override
  String get variantLoss => 'Varianti humb';

  @override
  String get variantWin => 'Varianti fiton';

  @override
  String get insufficientMaterial => 'Material i pamjaftueshëm';

  @override
  String get pawnMove => 'Lëvizje ushtari';

  @override
  String get capture => 'Kapje';

  @override
  String get close => 'Mbylle';

  @override
  String get winning => 'Fitues';

  @override
  String get losing => 'Humbës';

  @override
  String get drawn => 'Barazim';

  @override
  String get unknown => 'I panjohur';

  @override
  String get database => 'Bazë të dhënash';

  @override
  String get whiteDrawBlack => 'I bardhi / Barazim / I ziu';

  @override
  String averageRatingX(String param) {
    return 'Vlerësim mesatar: $param';
  }

  @override
  String get recentGames => 'Lojëra së fundi';

  @override
  String get topGames => 'Lojërat më të mira';

  @override
  String masterDbExplanation(String param1, String param2, String param3) {
    return 'Dy milionë lojëra OTB nga $param1 + lojëtarë me klasifikim FIDE nga $param2 në $param3';
  }

  @override
  String get dtzWithRounding => 'DTZ50\'\' me rrumbullakim, bazuar në numrin e gjysmë-lëvizjeve deri në kapjen ose lëvizjen tjetër të pengut';

  @override
  String get noGameFound => 'S’u gjet lojë';

  @override
  String get maxDepthReached => 'U mbërrit në thellësinë maksimum!';

  @override
  String get maybeIncludeMoreGamesFromThePreferencesMenu => 'Ndoshta të përfshihen më tepër lojëra nga menuja e parapëlqimeve?';

  @override
  String get openings => 'Hapje';

  @override
  String get openingExplorer => 'Eksplorues hapjesh';

  @override
  String get openingEndgameExplorer => 'Eksplorues hapjesh/mbylljesh loje';

  @override
  String xOpeningExplorer(String param) {
    return 'Eksploruesi i hapjeve $param';
  }

  @override
  String get playFirstOpeningEndgameExplorerMove => 'Luaj lëvizjen e parë të eksploruesit të hapjeve/mbylljeve të lojës';

  @override
  String get winPreventedBy50MoveRule => 'Fitore e parandaluar nga rregulli i 50 lëvizjeve';

  @override
  String get lossSavedBy50MoveRule => 'Humbje e parandaluar nga rregulli i 50 lëvizjeve';

  @override
  String get winOr50MovesByPriorMistake => 'Fitore ose 50 lëvizje me gabim të mëparshëm';

  @override
  String get lossOr50MovesByPriorMistake => 'Humbje ose 50 lëvizje me gabim të mëparshëm';

  @override
  String get unknownDueToRounding => 'Fitorja/humbja garantohet vetëm nëse vija e rekomanduar e bazës së tavolinës është ndjekur që nga kapja e fundit ose lëvizja e pengut, për shkak të rrumbullakimit të mundshëm të vlerave të DTZ në bazat e tabelave Syzygy.';

  @override
  String get allSet => 'Gjithçka gati!';

  @override
  String get importPgn => 'Importo PGN';

  @override
  String get delete => 'Fshije';

  @override
  String get deleteThisImportedGame => 'Të fshihet kjo lojë e importuar?';

  @override
  String get replayMode => 'Mënyra përsëritje';

  @override
  String get realtimeReplay => 'Aty për aty';

  @override
  String get byCPL => 'nga CPL';

  @override
  String get openStudy => 'Studim i hapur';

  @override
  String get enable => 'Aktivizoje';

  @override
  String get bestMoveArrow => 'Shigjetë e lëvizjes më të mirë';

  @override
  String get showVariationArrows => 'Shfaq shigjeta variacionesh';

  @override
  String get evaluationGauge => 'Matësi i vlerësimit';

  @override
  String get multipleLines => 'Linja të shumta';

  @override
  String get cpus => 'Procesorë';

  @override
  String get memory => 'Kujtesë';

  @override
  String get infiniteAnalysis => 'Analizë e pafundme';

  @override
  String get removesTheDepthLimit => 'Heq kufirin e thellësisë dhe e mban të ngrohtë kompjuterin tuaj';

  @override
  String get engineManager => 'Engine manager';

  @override
  String get blunder => 'Gafë';

  @override
  String get mistake => 'Gabim';

  @override
  String get inaccuracy => 'Pasaktësi';

  @override
  String get moveTimes => 'Koha e lëvizjeve';

  @override
  String get flipBoard => 'Kthe fushën';

  @override
  String get threefoldRepetition => 'Përsëritje trefishe';

  @override
  String get claimADraw => 'Kërko barazim';

  @override
  String get offerDraw => 'Ofro barazim';

  @override
  String get draw => 'Barazim';

  @override
  String get drawByMutualAgreement => 'Barazim me marrëveshje';

  @override
  String get fiftyMovesWithoutProgress => 'Pesëdhjetë lëvizje pa përparim';

  @override
  String get currentGames => 'Lojëra tani';

  @override
  String get viewInFullSize => 'Shiheni në madhësi të plotë';

  @override
  String get logOut => 'Dilni';

  @override
  String get signIn => 'Hyni';

  @override
  String get rememberMe => 'Mbamë të futur';

  @override
  String get youNeedAnAccountToDoThat => 'Ju nevojitet një llogari për ta bërë këtë';

  @override
  String get signUp => 'Regjistrohuni';

  @override
  String get computersAreNotAllowedToPlay => 'Kompjuterat dhe lojtarët e ndihmuar nga kompjuteri nuk lejohet të luajnë. Ju lutemi, mos merrni ndihmë nga motorë shahu, baza të dhënash, apo nga lojtarët e tjerë, kur jeni duke luajtur. Vini re gjithashtu se nuk nxitet krijimi i disa llogarive dhe se teprimi në krijimin e disa llogarive do të sjellë dëbim.';

  @override
  String get games => 'Lojëra';

  @override
  String get forum => 'Forum';

  @override
  String xPostedInForumY(String param1, String param2) {
    return '$param1 postoi te tema $param2';
  }

  @override
  String get latestForumPosts => 'Postimet më të reja në forum';

  @override
  String get players => 'Lojtarë';

  @override
  String get friends => 'Miqtë';

  @override
  String get discussions => 'Biseda';

  @override
  String get today => 'Sot';

  @override
  String get yesterday => 'Dje';

  @override
  String get minutesPerSide => 'Minuta për palë';

  @override
  String get variant => 'Variant';

  @override
  String get variants => 'Variante';

  @override
  String get timeControl => 'Kontroll kohe';

  @override
  String get realTime => 'Kohë reale';

  @override
  String get correspondence => 'Korrespondencë';

  @override
  String get daysPerTurn => 'Ditë për lëvizje';

  @override
  String get oneDay => 'Një ditë';

  @override
  String get time => 'Koha';

  @override
  String get rating => 'Vlerësimi';

  @override
  String get ratingStats => 'Statistika vlerësimi';

  @override
  String get username => 'Emri i përdoruesit';

  @override
  String get usernameOrEmail => 'Emër përdoruesi ose email';

  @override
  String get changeUsername => 'Ndryshoni emrin e përdoruesit';

  @override
  String get changeUsernameNotSame => 'Mund të bëhet vetëm ndryshim nga shkronjë e madhe në të vogël dhe anasjelltas. Për shembull, “neshatbishti” në “NeshatBishti”.';

  @override
  String get changeUsernameDescription => 'Ndryshoni emrin tuaj të përdoruesit. Kjo mund të bëhet vetëm një herë edhe ju lejohet vetëm të ndryshoni shkronja të vogla në të mëdha dhe anasjelltas te emri juaj i përdoruesit.';

  @override
  String get signupUsernameHint => 'Sigurohuni se zgjidhni një emër përdoruesi të përshtatshëm për familje. S’mund ta ndryshoni më vonë dhe cilado llogari me emra përdoruesish të papërshtatshëm do të mbyllet!';

  @override
  String get signupEmailHint => 'Do ta përdorim vetëm për ricaktim fjalëkalimi.';

  @override
  String get password => 'Fjalëkalim';

  @override
  String get changePassword => 'Ndryshoni fjalëkalimin';

  @override
  String get changeEmail => 'Ndryshoni email-in';

  @override
  String get email => 'Email';

  @override
  String get passwordReset => 'Ricaktim fjalëkalimi';

  @override
  String get forgotPassword => 'Harruat fjalëkalimin?';

  @override
  String get error_weakPassword => 'Ky fjalëkalim është tejet i rëndomtë dhe shumë i kollajtë të merret me mend.';

  @override
  String get error_namePassword => 'Ju lutemi, mos përdorni si fjalëkalim tuajin emrin tuaj të përdoruesit.';

  @override
  String get blankedPassword => 'Keni përdorur të njëjtin fjalëkalim si në një sajt tjetër dhe ai sajt është komprometuar. Për të garantuar sigurinë e llogarisë tuaj Lichess, na duhet t’ju caktojmë një fjalëkalim të ri. Faleminderit për mirëkuptimin.';

  @override
  String get youAreLeavingLichess => 'Po ikni nga Lichess';

  @override
  String get neverTypeYourPassword => 'Mos shtypni kurrë fjalëkalimin tuaj për në Lichess te një sajt tjetër!';

  @override
  String proceedToX(String param) {
    return 'Vazhdo te $param';
  }

  @override
  String get passwordSuggestion => 'Mos caktoni si fjalëkalim diçka të sugjeruar nga dikush tjetër. Do ta përdorin për t’ju grabitur llogarinë tuaj.';

  @override
  String get emailSuggestion => 'Mos caktoni si adresë email diçka të sugjeruar nga dikush tjetër. Do ta përdorin për t’ju grabitur llogarinë tuaj.';

  @override
  String get emailConfirmHelp => 'Ndihmë për ripohim email-i';

  @override
  String get emailConfirmNotReceived => 'S’e morët email-in tuaj të ripohimit, pas regjistrimit?';

  @override
  String get whatSignupUsername => 'Ç’emër përdoruesi përdorët për t’u regjistruar?';

  @override
  String usernameNotFound(String param) {
    return 'S’gjetëm dot ndonjë përdorues me këtë emër: $param.';
  }

  @override
  String get usernameCanBeUsedForNewAccount => 'Mund të përdorni këtë emër përdoruesi për të krijuar një llogari të re';

  @override
  String emailSent(String param) {
    return 'Kemi dërguar një email te $param.';
  }

  @override
  String get emailCanTakeSomeTime => 'Mund të duhet pak kohë që të mbërrijë.';

  @override
  String get refreshInboxAfterFiveMinutes => 'Pritni 5 minuta dhe rifreksoni “Të marrët” tuaj';

  @override
  String get checkSpamFolder => 'Shihni gjithashtu edhe te dosja juaj e të padëshiruarve, mund të përfundojë atje. Në ndodhtë kështu, i hiqni shenjën si i padëshiruar.';

  @override
  String get emailForSignupHelp => 'Nëse gjithçka tjetër dështon, atëherë dërgonani këtë email:';

  @override
  String copyTextToEmail(String param) {
    return 'Kopjoni dhe ngjitni tekstin më poshtë dhe dërgojeni te $param';
  }

  @override
  String get waitForSignupHelp => 'Do të lidhemi me ju së shpejti, për t’ju ndihmuar të plotësoni regjistrimin tuaj.';

  @override
  String accountConfirmed(String param) {
    return 'Përdoruesi $param u ripohua me sukses.';
  }

  @override
  String accountCanLogin(String param) {
    return 'Mund të bëni hyrjen mu tani si $param.';
  }

  @override
  String get accountConfirmationEmailNotNeeded => 'S’ju duhe një email ripohimi.';

  @override
  String accountClosed(String param) {
    return 'Llogaria $param është mbyllur.';
  }

  @override
  String accountRegisteredWithoutEmail(String param) {
    return 'Llogaria $param qe regjistruar pa email.';
  }

  @override
  String get rank => 'Renditje';

  @override
  String rankX(String param) {
    return 'Renditja: $param';
  }

  @override
  String get gamesPlayed => 'Lojëra të luajtura';

  @override
  String get cancel => 'Anuloje';

  @override
  String get whiteTimeOut => 'Të bardhit i mbaroi koha';

  @override
  String get blackTimeOut => 'Të ziut i mbaroi koha';

  @override
  String get drawOfferSent => 'U dërgua ofertë për barazim';

  @override
  String get drawOfferAccepted => 'Oferta për barazim u pranua';

  @override
  String get drawOfferCanceled => 'Oferta për barazim u anulua';

  @override
  String get whiteOffersDraw => 'I bardhi ofron barazim';

  @override
  String get blackOffersDraw => 'I ziu ofron barazim';

  @override
  String get whiteDeclinesDraw => 'I bardhi hedh poshtë barazimin';

  @override
  String get blackDeclinesDraw => 'I ziu hedh poshtë barazimin';

  @override
  String get yourOpponentOffersADraw => 'Kundërshtari ju ofron barazim';

  @override
  String get accept => 'Prano';

  @override
  String get decline => 'Refuzojeni';

  @override
  String get playingRightNow => 'Po luhet tani';

  @override
  String get eventInProgress => 'Po luhet tani';

  @override
  String get finished => 'Përfundoi';

  @override
  String get abortGame => 'Ndërprite lojën';

  @override
  String get gameAborted => 'Loja u ndërpre';

  @override
  String get standard => 'Standard';

  @override
  String get customPosition => 'Pozicion vetjak';

  @override
  String get unlimited => 'E pakufizuar';

  @override
  String get mode => 'Lloji';

  @override
  String get casual => 'Rastësore';

  @override
  String get rated => 'Me vlerësim';

  @override
  String get casualTournament => 'Pa vlerësim';

  @override
  String get ratedTournament => 'Me vlerësim';

  @override
  String get thisGameIsRated => 'Kjo lojë është me vlerësësim';

  @override
  String get rematch => 'Lojë rishtas';

  @override
  String get rematchOfferSent => 'Oferta për lojë rishtas u dërgua';

  @override
  String get rematchOfferAccepted => 'Oferta për lojë rishtas u pranua';

  @override
  String get rematchOfferCanceled => 'Oferta për lojë rishtas u anulua';

  @override
  String get rematchOfferDeclined => 'Oferta për lojë rishtas u refuzua';

  @override
  String get cancelRematchOffer => 'Anulo ofertën për lojë rishtas';

  @override
  String get viewRematch => 'Shihni lojën rishtas';

  @override
  String get confirmMove => 'Konfirmo lëvizjen';

  @override
  String get play => 'Luaj';

  @override
  String get inbox => 'Mesazhet';

  @override
  String get chatRoom => 'Dhomë bisedash';

  @override
  String get loginToChat => 'Që të bisedoni, bëni hyrjen';

  @override
  String get youHaveBeenTimedOut => 'Ju mbaroi koha.';

  @override
  String get spectatorRoom => 'Dhoma e shikuesve';

  @override
  String get composeMessage => 'Hartoni mesazh';

  @override
  String get subject => 'Subjekti';

  @override
  String get send => 'Dërgoje';

  @override
  String get incrementInSeconds => 'Koha shtesë në sekonda';

  @override
  String get freeOnlineChess => 'Shah Falas Në Internet';

  @override
  String get exportGames => 'Eksporto lojërat';

  @override
  String get ratingRange => 'Shtrirja e vlerësimit';

  @override
  String get thisAccountViolatedTos => 'Kjo llogari ka shkelur Kushtet e Shërbimit të Lichess';

  @override
  String get openingExplorerAndTablebase => 'Eksploruesi i hapjeve & tabela e fundlojës';

  @override
  String get takeback => 'Kthim lëvizjeje mbrapsht';

  @override
  String get proposeATakeback => 'Propozoni një kthim lëvizjeje mbrapsht';

  @override
  String get takebackPropositionSent => 'Kërkesa për kthim lëvizjeje mbrapsht u dërgua';

  @override
  String get takebackPropositionDeclined => 'Kërkesa për kthim lëvizjeje mbrapsht u hodh poshtë';

  @override
  String get takebackPropositionAccepted => 'Kërkesa për kthim lëvizjeje mbrapsht u pranua';

  @override
  String get takebackPropositionCanceled => 'Kërkesa për kthim lëvizjeje mbrapsht u anulua';

  @override
  String get yourOpponentProposesATakeback => 'Kundërshtari juaj propozon kthim lëvizjeje mbrapsht';

  @override
  String get bookmarkThisGame => 'Faqeruani këtë lojë';

  @override
  String get tournament => 'Turne';

  @override
  String get tournaments => 'Turne';

  @override
  String get tournamentPoints => 'Pikë nga turnetë';

  @override
  String get viewTournament => 'Shihni turneun';

  @override
  String get backToTournament => 'Kthehu në turne';

  @override
  String get noDrawBeforeSwissLimit => 'Në një turne zviceran, s’mund të dilni barazim para se të jenë luajtur 30 lëvizje.';

  @override
  String get thematic => 'Tematik';

  @override
  String yourPerfRatingIsProvisional(String param) {
    return 'Vlerësimi juaj $param është i përkohshëm';
  }

  @override
  String yourPerfRatingIsTooHigh(String param1, String param2) {
    return 'Vlerësimi juaj ($param2) në $param1 është më i lartë seç duhet';
  }

  @override
  String yourTopWeeklyPerfRatingIsTooHigh(String param1, String param2) {
    return 'Vlerësimi juaj javor më i madh ($param2) në $param1 është më i lartë seç duhet';
  }

  @override
  String yourPerfRatingIsTooLow(String param1, String param2) {
    return 'Vlerësimi juaj ($param2) në $param1 është më i ulët seç duhet';
  }

  @override
  String ratedMoreThanInPerf(String param1, String param2) {
    return 'Vlerësuar ≥ $param1 në $param2';
  }

  @override
  String ratedLessThanInPerf(String param1, String param2) {
    return 'Vlerësuar ≤ $param1 në $param2 për javën e fundit';
  }

  @override
  String mustBeInTeam(String param) {
    return 'Duhet të jeni në ekipin $param';
  }

  @override
  String youAreNotInTeam(String param) {
    return 'S’jeni në ekipin $param';
  }

  @override
  String get backToGame => 'Mbrapsht te loja';

  @override
  String get siteDescription => 'Shërbyes shahu internetor falas. Luani shah përmes një ndërfaqeje të pastër. Pa regjistrim, pa reklama, pa u dashur shtojca. Luani shah me kompjuterin, shokë ose kundërshtarë të rastësishëm.';

  @override
  String xJoinedTeamY(String param1, String param2) {
    return '$param1 u bë pjesë e ekipit $param2';
  }

  @override
  String xCreatedTeamY(String param1, String param2) {
    return '$param1 krijoi ekipin $param2';
  }

  @override
  String get startedStreaming => 'filloi transmetim';

  @override
  String xStartedStreaming(String param) {
    return '$param filloi transmetimin';
  }

  @override
  String get averageElo => 'Vlerësimi mesatar';

  @override
  String get location => 'Vendndodhja';

  @override
  String get filterGames => 'Filtro lojrat';

  @override
  String get reset => 'Riktheje te parazgjedhjet';

  @override
  String get apply => 'Parashtroje';

  @override
  String get save => 'Ruaje';

  @override
  String get leaderboard => 'Tabelë klasifikimi';

  @override
  String get screenshotCurrentPosition => 'Bëj foto ekrani të pozicionit të tanishëm';

  @override
  String get gameAsGIF => 'GIF i lojës';

  @override
  String get pasteTheFenStringHere => 'Ngjitni këtu tekstin FEN';

  @override
  String get pasteThePgnStringHere => 'Ngjitni këtu tekstin PGN';

  @override
  String get orUploadPgnFile => 'Ose ngarkoni një kartelë PGN';

  @override
  String get fromPosition => 'Nga pozicioni';

  @override
  String get continueFromHere => 'Vazhdoni nga këtu';

  @override
  String get toStudy => 'Mësim';

  @override
  String get importGame => 'Importo lojën';

  @override
  String get importGameExplanation => 'Ngjitni një PGN loje, që të merrni një përsëritje\ntë lojës në shfletues, analizë kompjuterike, bisedë\nloje dhe URL për ta ndarë me të tjerë.';

  @override
  String get importGameCaveat => 'Variacionet do të fshihen. Për t\'i mbajtur ato, importoni PGN përmes një studimi.';

  @override
  String get importGameDataPrivacyWarning => 'Kjo PGN mund të shihet nga publiku. Që të importoni privatisht një lojë, përdorni një ushtrim.';

  @override
  String get thisIsAChessCaptcha => 'Kjo është një CAPTCHA shahu.';

  @override
  String get clickOnTheBoardToMakeYourMove => 'Klikoni mbi fushën për të bërë lëvizjen tuaj dhe të dëshmoni se jeni qenie njerëzore.';

  @override
  String get captcha_fail => 'Ju lutemi, zgjidhni captcha-n e shahut.';

  @override
  String get notACheckmate => 'S’është shah-mat';

  @override
  String get whiteCheckmatesInOneMove => 'I bardhi në shah-mat me një lëvizje';

  @override
  String get blackCheckmatesInOneMove => 'I ziu në shah-mat me një lëvizje';

  @override
  String get retry => 'Riprovoni';

  @override
  String get reconnecting => 'Po rilidhet';

  @override
  String get noNetwork => 'Jashtë linje';

  @override
  String get favoriteOpponents => 'Kundërshtarë të preferuar';

  @override
  String get follow => 'Ndiqeni';

  @override
  String get following => 'Ndiqet';

  @override
  String get unfollow => 'Ndalo së ndjekuri';

  @override
  String followX(String param) {
    return 'Ndiq $param';
  }

  @override
  String unfollowX(String param) {
    return 'Mos e ndiq më $param';
  }

  @override
  String get block => 'Bllokoje';

  @override
  String get blocked => 'I bllokuar';

  @override
  String get unblock => 'Zhbllokoje';

  @override
  String get followsYou => 'Ju ndjek juve';

  @override
  String xStartedFollowingY(String param1, String param2) {
    return '$param1 nisi të ndjekë $param2';
  }

  @override
  String get more => 'Më shumë';

  @override
  String get memberSince => 'Anëtar që prej';

  @override
  String lastSeenActive(String param) {
    return 'Aktiv $param';
  }

  @override
  String get player => 'Lojtar';

  @override
  String get list => 'Listë';

  @override
  String get graph => 'Grafik';

  @override
  String get required => 'E domosdoshme.';

  @override
  String get openTournaments => 'Turne të hapur';

  @override
  String get duration => 'Kohëzgjatja';

  @override
  String get winner => 'Fituesi';

  @override
  String get standing => 'Pozicionet';

  @override
  String get createANewTournament => 'Krijoni një turne të ri';

  @override
  String get tournamentCalendar => 'Kalendari i turneut';

  @override
  String get conditionOfEntry => 'Domosdoshmëri Pjesëmarrjeje:';

  @override
  String get advancedSettings => 'Rregullime të thelluara';

  @override
  String get safeTournamentName => 'Zgjidhni një emër shumë të sigurt për turneun.';

  @override
  String get inappropriateNameWarning => 'Çfarëdo gjëje qoftë edhe pakëz e papërshtatshme mund të sjellë mbylljen e llogarisë tuaj.';

  @override
  String get emptyTournamentName => 'Për ta emërtuar turneun me emrin e një lojtari të njohur shahu, lëreni të zbrazët.';

  @override
  String get makePrivateTournament => 'Bëjeni turneun privat dhe kufizojeni hyrjen me një fjalëkalim';

  @override
  String get join => 'Merrni pjesë';

  @override
  String get withdraw => 'Tërhiquni';

  @override
  String get points => 'Pikë';

  @override
  String get wins => 'Fitore';

  @override
  String get losses => 'Humbje';

  @override
  String get createdBy => 'Krijuar nga';

  @override
  String get tournamentIsStarting => 'Turneu po fillon';

  @override
  String get tournamentPairingsAreNowClosed => 'Çiftimet e turnet tani u mbyllën.';

  @override
  String standByX(String param) {
    return 'Mos u largoni nga $param, çiftimi i lojtarëve po bëhet, bëhuni gati!';
  }

  @override
  String get pause => 'Pauzë';

  @override
  String get resume => 'Rifillo';

  @override
  String get youArePlaying => 'Po luani!';

  @override
  String get winRate => 'Përqindje fitoresh';

  @override
  String get berserkRate => 'Perqindja e berserkeve';

  @override
  String get performance => 'Sukseshmëri';

  @override
  String get tournamentComplete => 'Turneu mbaroi';

  @override
  String get movesPlayed => 'Lëvizje të luajtura';

  @override
  String get whiteWins => 'I bardhi fiton';

  @override
  String get blackWins => 'I ziu fiton';

  @override
  String get drawRate => 'Draw rate';

  @override
  String get draws => 'Barazime';

  @override
  String nextXTournament(String param) {
    return 'Turneu $param i radhës:';
  }

  @override
  String get averageOpponent => 'Kundërshtari mesatar';

  @override
  String get boardEditor => 'Përpunues fushe';

  @override
  String get setTheBoard => 'Rregulloni fushën';

  @override
  String get popularOpenings => 'Hapje popullore';

  @override
  String get endgamePositions => 'Pozicione fundi loje';

  @override
  String chess960StartPosition(String param) {
    return 'Pozicion nisjeje Chess960: $param';
  }

  @override
  String get startPosition => 'Pozicioni fillestar';

  @override
  String get clearBoard => 'Spastro fushën';

  @override
  String get loadPosition => 'Ngarko pozicionin';

  @override
  String get isPrivate => 'Privat';

  @override
  String reportXToModerators(String param) {
    return 'Raportojeni $param tek moderatorët';
  }

  @override
  String profileCompletion(String param) {
    return 'Plotësim profili: $param';
  }

  @override
  String xRating(String param) {
    return '$param vlerësim';
  }

  @override
  String get ifNoneLeaveEmpty => 'Në mos pastë, lëreni të zbrazët';

  @override
  String get profile => 'Profil';

  @override
  String get editProfile => 'Përpunoni profilin';

  @override
  String get realName => 'Emër i njëmendtë';

  @override
  String get setFlair => 'Set your flair';

  @override
  String get flair => 'Flair';

  @override
  String get youCanHideFlair => 'There is a setting to hide all user flairs across the entire site.';

  @override
  String get biography => 'Jetëshkrim';

  @override
  String get countryRegion => 'Vend ose rajon';

  @override
  String get thankYou => 'Faleminderit!';

  @override
  String get socialMediaLinks => 'Lidhje mediash shoqërore';

  @override
  String get oneUrlPerLine => 'Një URL për rresht.';

  @override
  String get inlineNotation => 'Shënim brendazi';

  @override
  String get makeAStudy => 'Për ruajtje të sigurt dhe për ndarje me të tjerët, shihni mundësinë e krijimit të një studimi.';

  @override
  String get clearSavedMoves => 'Spastroji lëvizjet';

  @override
  String get previouslyOnLichessTV => 'Herën e fundit në Lichess TV';

  @override
  String get onlinePlayers => 'Lojtarë në linjë';

  @override
  String get activePlayers => 'Lojëtarë aktivë';

  @override
  String get bewareTheGameIsRatedButHasNoClock => 'Kujdes, loja është e vlerësuar, por s’ka sahat!';

  @override
  String get success => 'Sukses';

  @override
  String get automaticallyProceedToNextGameAfterMoving => 'Kalo automatikisht në lojën tjetër pas lëvizjes';

  @override
  String get autoSwitch => 'Kalim automatik';

  @override
  String get puzzles => 'Ushtrime';

  @override
  String get onlineBots => 'Robotë internetorë';

  @override
  String get name => 'Emër';

  @override
  String get description => 'Përshkrim';

  @override
  String get descPrivate => 'Përshkrim privat';

  @override
  String get descPrivateHelp => 'Tekst që do ta shohin vetëm anëtarët e ekipit. Në u dhëntë, zëvendëson përshkrimin publik për anëtarët e ekipit.';

  @override
  String get no => 'Jo';

  @override
  String get yes => 'Po';

  @override
  String get help => 'Ndihmë:';

  @override
  String get createANewTopic => 'Krijoni një temë të re';

  @override
  String get topics => 'Temat';

  @override
  String get posts => 'Postimet';

  @override
  String get lastPost => 'Postimi i fundit';

  @override
  String get views => 'Shikime';

  @override
  String get replies => 'Përgjigje';

  @override
  String get replyToThisTopic => 'Përgjigjuni tek kjo temë';

  @override
  String get reply => 'Përgjigjuni';

  @override
  String get message => 'Mesazh';

  @override
  String get createTheTopic => 'Krijoje temën';

  @override
  String get reportAUser => 'Raportoni një përdorues';

  @override
  String get user => 'Përdorues';

  @override
  String get reason => 'Arsye';

  @override
  String get whatIsIheMatter => 'Si është puna?';

  @override
  String get cheat => 'Hile';

  @override
  String get troll => 'Troll';

  @override
  String get other => 'Tjetër';

  @override
  String get reportDescriptionHelp => 'Ngjitni lidhjen për te loja(ra) dhe shpjegoni çfarë nuk shkon me sjelljen e këtij përdoruesi. Mos shkruani thjesht “mashtrojnë”, por na tregoni si mbërritët në këtë përfundim. Raportimi juaj do të përpunohet më shpejt, nëse shkruhet në anglisht.';

  @override
  String get error_provideOneCheatedGameLink => 'Ju lutemi, jepni të paktën një lidhje te një lojë me hile.';

  @override
  String by(String param) {
    return 'nga $param';
  }

  @override
  String importedByX(String param) {
    return 'Importuar nga $param';
  }

  @override
  String get thisTopicIsNowClosed => 'Kjo temë është e mbyllur tani.';

  @override
  String get blog => 'Blog';

  @override
  String get notes => 'Shënime';

  @override
  String get typePrivateNotesHere => 'Shkruani shënime private këtu';

  @override
  String get writeAPrivateNoteAboutThisUser => 'Shkruani një shënim privat rreth këtij përdoruesi';

  @override
  String get noNoteYet => 'Ende pa shënim';

  @override
  String get invalidUsernameOrPassword => 'Emër përdorues ose fjalëkalim i pavlefshëm';

  @override
  String get incorrectPassword => 'Fjalëkalim i pasaktë';

  @override
  String get invalidAuthenticationCode => 'Kod i pavlefshëm mirëfilltësimi';

  @override
  String get emailMeALink => 'Dërgomëni lidhjen me email';

  @override
  String get currentPassword => 'Fjalëkalimi i tanishëm';

  @override
  String get newPassword => 'Fjalëkalimi i ri';

  @override
  String get newPasswordAgain => 'Fjalëkalimi i ri (sërish)';

  @override
  String get newPasswordsDontMatch => 'Fjalëkalimet e reja nuk përputhen';

  @override
  String get newPasswordStrength => 'Fortësia e fjalëkalimit';

  @override
  String get clockInitialTime => 'Koha fillestare e sahatit';

  @override
  String get clockIncrement => 'Hap sahati';

  @override
  String get privacy => 'Privatësi';

  @override
  String get privacyPolicy => 'Rregulla privatësie';

  @override
  String get letOtherPlayersFollowYou => 'Lejoni lojtarë të tjerë t’ju ndjekin';

  @override
  String get letOtherPlayersChallengeYou => 'Lejoni lojtarë të tjerë t’ju sfidojnë';

  @override
  String get letOtherPlayersInviteYouToStudy => 'Lejoni lojtarë të tjerë t’’ju ftojnë të studioni';

  @override
  String get sound => 'Zë';

  @override
  String get none => 'Asnjë';

  @override
  String get fast => 'Shpejt';

  @override
  String get normal => 'Normal';

  @override
  String get slow => 'Ngadalë';

  @override
  String get insideTheBoard => 'Brenda fushës';

  @override
  String get outsideTheBoard => 'Jashtë fushës';

  @override
  String get allSquaresOfTheBoard => 'Në krejt katrorët e fushës';

  @override
  String get onSlowGames => 'Në lojëra të ngadalta';

  @override
  String get always => 'Përherë';

  @override
  String get never => 'Kurrë';

  @override
  String xCompetesInY(String param1, String param2) {
    return '$param1 konkurron në $param2';
  }

  @override
  String get victory => 'Fitore';

  @override
  String get defeat => 'Humbje';

  @override
  String victoryVsYInZ(String param1, String param2, String param3) {
    return '$param1 vs $param2 në $param3';
  }

  @override
  String defeatVsYInZ(String param1, String param2, String param3) {
    return '$param1 vs $param2 në $param3';
  }

  @override
  String drawVsYInZ(String param1, String param2, String param3) {
    return '$param1 vs $param2 në $param3';
  }

  @override
  String get timeline => 'Rrjedhë kohore';

  @override
  String get starting => 'Fillon:';

  @override
  String get allInformationIsPublicAndOptional => 'Krejt informacioni është publik dhe opsional.';

  @override
  String get biographyDescription => 'Tregoni për veten, interesat tuaja, ç’ju pëlqen tek shahu, hapjet tuaja të preferuara, lojtarët…';

  @override
  String get listBlockedPlayers => 'Radhitni lojtarët që keni bllokuar';

  @override
  String get human => 'Njeri';

  @override
  String get computer => 'Kompjuter';

  @override
  String get side => 'Pala';

  @override
  String get clock => 'Sahat';

  @override
  String get opponent => 'Kundërshtari';

  @override
  String get learnMenu => 'Mësoni';

  @override
  String get studyMenu => 'Studioni';

  @override
  String get practice => 'Ushtrohuni';

  @override
  String get community => 'Bashkësia';

  @override
  String get tools => 'Mjete';

  @override
  String get increment => 'Hap';

  @override
  String get error_unknown => 'Vlerë e pavlefshme';

  @override
  String get error_required => 'Kjo fushë është e domosdoshme';

  @override
  String get error_email => 'Kjo adresë email është e pavlefshme';

  @override
  String get error_email_acceptable => 'Kjo adresë email është e papranueshme. Ju lutemi, rikontrollojeni dhe riprovoni.';

  @override
  String get error_email_unique => 'Adresë email e pavlefshme, ose e përdorur tashmë';

  @override
  String get error_email_different => 'Kjo është tashmë adresa juaj email';

  @override
  String error_minLength(String param) {
    return 'Duhet të jetë e pakta $param shenja e gjatë';
  }

  @override
  String error_maxLength(String param) {
    return 'Duhet të jetë e shumta $param shenja e gjatë';
  }

  @override
  String error_min(String param) {
    return 'Duhet të jetë të paktën $param';
  }

  @override
  String error_max(String param) {
    return 'Duhet të jetë e shumta $param';
  }

  @override
  String ifRatingIsPlusMinusX(String param) {
    return 'Nëse vlerësimi është ± $param';
  }

  @override
  String get ifRegistered => 'Nëse jeni të regjistruar';

  @override
  String get onlyExistingConversations => 'Vetëm bisedat ekzistuese';

  @override
  String get onlyFriends => 'Vetëm shokë';

  @override
  String get menu => 'Menu';

  @override
  String get castling => 'Rokadë';

  @override
  String get whiteCastlingKingside => 'I bardhi O-O';

  @override
  String get blackCastlingKingside => 'I ziu O-O';

  @override
  String tpTimeSpentPlaying(String param) {
    return 'Kohë e shpenzuar në lojë: $param';
  }

  @override
  String get watchGames => 'Shihni lojëra';

  @override
  String tpTimeSpentOnTV(String param) {
    return 'Kohë pranie në TV: $param';
  }

  @override
  String get watch => 'Shiheni';

  @override
  String get videoLibrary => 'Videoteka';

  @override
  String get streamersMenu => 'Streamerit';

  @override
  String get mobileApp => 'Aplikacion Për Celular';

  @override
  String get webmasters => 'Webmasters';

  @override
  String get about => 'Mbi';

  @override
  String aboutX(String param) {
    return 'Mbi $param';
  }

  @override
  String xIsAFreeYLibreOpenSourceChessServer(String param1, String param2) {
    return '$param1 është një shërbyes shahu i lirë ($param2), “libre”, pa reklama, me burim të hapët.';
  }

  @override
  String get really => 'për vërtetë';

  @override
  String get contribute => 'Jepni ndihmesë';

  @override
  String get termsOfService => 'Kushte Shërbimi';

  @override
  String get sourceCode => 'Kod Burim';

  @override
  String get simultaneousExhibitions => 'Simultane';

  @override
  String get host => 'Organizatori';

  @override
  String hostColorX(String param) {
    return 'Ngjyra e organizatorit: $param';
  }

  @override
  String get yourPendingSimuls => 'Your pending simuls';

  @override
  String get createdSimuls => 'Simultane të krijuara së fundi';

  @override
  String get hostANewSimul => 'Organizoni një simultane të re';

  @override
  String get signUpToHostOrJoinASimul => 'Sign up to host or join a simul';

  @override
  String get noSimulFound => 'S’u gjet simultane';

  @override
  String get noSimulExplanation => 'Kjo simultane s’ekziston.';

  @override
  String get returnToSimulHomepage => 'Kthehu në faqen kryesore të simultaneve';

  @override
  String get aboutSimul => 'Në simultane një lojtar luan njëherësh kundër disa lojtarëve.';

  @override
  String get aboutSimulImage => 'Nga 50 kundërshtarë, Fisher fitoi 47 lojëra, barazoi 2 dhe humbi 1.';

  @override
  String get aboutSimulRealLife => 'Koncepti është marrë nga veprimtari të njëmendta. Në praktikë, kjo përkthehet në kalimin e organizuesit të simultanes nga një tavolinë në tjetrën duke bërë një lëvizje në secilën.';

  @override
  String get aboutSimulRules => 'Kur fillon simultaneja, çdo lojtar fillon lojën me pritësin, i cili luan me gurët e bardhë. Simultaneja mbaron kur mbarojnë të gjitha lojërat.';

  @override
  String get aboutSimulSettings => 'Simultanet janë gjithmonë të pavlerësuara. Revansh, marrje mbrapsht dhe \"më shumë kohë\" janë të çaktivizuara.';

  @override
  String get create => 'Krijoje';

  @override
  String get whenCreateSimul => 'Kur krijon një simultane, luan kundër disa lojtarëve njëkohësisht.';

  @override
  String get simulVariantsHint => 'Nëse përzgjidhni disa variante, çdo lojtar zgjedh vetë cilin variant të luajë.';

  @override
  String get simulClockHint => 'Ujdisje Fisher për sahatin. Sa më shumë lojtarë pranoni, aq më shumë kohë mund t’ju nevojitet.';

  @override
  String get simulAddExtraTime => 'Ju mund të shtoni kohë shtesë për t\'i bërë ballë simultanes.';

  @override
  String get simulHostExtraTime => 'Kohë shtesë për organizatorin';

  @override
  String get simulAddExtraTimePerPlayer => 'Shtoni kohë fillestare te sahati juaj për çdo lojtar që hyn në simultane.';

  @override
  String get simulHostExtraTimePerPlayer => 'Kohë ekstra sahati organizatori për lojtar';

  @override
  String get lichessTournaments => 'Turne Lichess';

  @override
  String get tournamentFAQ => 'PBR për turne Arenë';

  @override
  String get timeBeforeTournamentStarts => 'Koha deri sa të fillojë turneu';

  @override
  String get averageCentipawnLoss => 'Humbja mesatare në centiushtar';

  @override
  String get accuracy => 'Saktësi';

  @override
  String get keyboardShortcuts => 'Shkurtore tastiere';

  @override
  String get keyMoveBackwardOrForward => 'lëviz mbrapa/para';

  @override
  String get keyGoToStartOrEnd => 'shko në fillim/fund';

  @override
  String get keyCycleSelectedVariation => 'Cycle selected variation';

  @override
  String get keyShowOrHideComments => 'shfaq/fshih komentet';

  @override
  String get keyEnterOrExitVariation => 'hyr/dil nga varianti';

  @override
  String get keyRequestComputerAnalysis => 'Kërkoni analizim nga kompjuteri, Mësoni nga gabimet tuaja';

  @override
  String get keyNextLearnFromYourMistakes => 'Pasuesi (Mësoni nga gabimet tuaja)';

  @override
  String get keyNextBlunder => 'Gafa pasuese';

  @override
  String get keyNextMistake => 'Gabimi pasues';

  @override
  String get keyNextInaccuracy => 'Pasaktësia pasuese';

  @override
  String get keyPreviousBranch => 'Dega e mëparshme';

  @override
  String get keyNextBranch => 'Dega pasuese';

  @override
  String get toggleVariationArrows => 'Shfaq/fshih shigjeta variantesh';

  @override
  String get cyclePreviousOrNextVariation => 'Cycle previous/next variation';

  @override
  String get toggleGlyphAnnotations => 'Toggle move annotations';

  @override
  String get togglePositionAnnotations => 'Toggle position annotations';

  @override
  String get variationArrowsInfo => 'Variation arrows let you navigate without using the move list.';

  @override
  String get playSelectedMove => 'luaj lëvizjen e përzgjedhur';

  @override
  String get newTournament => 'Turne i ri';

  @override
  String get tournamentHomeTitle => 'Turne shahu me kontrolle kohore dhe variante të ndryshme';

  @override
  String get tournamentHomeDescription => 'Luani turne shahu me ritëm të shpejtë! Merrni pjesë në një turne zyrtar të planifikuar, ose krijoni tuajin. Plumb, Blic, Klasik, Shah960, Mbreti i Kodrës, Treshah dhe më tepër mundësi të gatshme, për argëtim të pafund në shah.';

  @override
  String get tournamentNotFound => 'Turneu s’u gjet';

  @override
  String get tournamentDoesNotExist => 'Ky turne nuk ekziston.';

  @override
  String get tournamentMayHaveBeenCanceled => 'Turneu mund të jetë anuluar, nëse tërë lojtarët ikën para se të fillonte.';

  @override
  String get returnToTournamentsHomepage => 'Kthehu në faqen kryesore të turneve';

  @override
  String weeklyPerfTypeRatingDistribution(String param) {
    return 'Shpërndarje javore e vlerësimit në $param';
  }

  @override
  String yourPerfTypeRatingIsRating(String param1, String param2) {
    return 'Vlerësimi juaj në $param1 është $param2.';
  }

  @override
  String youAreBetterThanPercentOfPerfTypePlayers(String param1, String param2) {
    return 'Ju jeni më mirë se $param1 nga $param2 lojtarë.';
  }

  @override
  String userIsBetterThanPercentOfPerfTypePlayers(String param1, String param2, String param3) {
    return '$param1 është më mirë se $param2 nga $param3 lojtarë.';
  }

  @override
  String betterThanPercentPlayers(String param1, String param2) {
    return 'Më mirë se $param1 nga $param2 lojtarë gjithsej';
  }

  @override
  String youDoNotHaveAnEstablishedPerfTypeRating(String param) {
    return 'S’keni një vlerësim të caktuar në $param.';
  }

  @override
  String get yourRating => 'Vlerësimi juaj';

  @override
  String get cumulative => 'Gjithsej';

  @override
  String get glicko2Rating => 'Vlerësim Glicko-2';

  @override
  String get checkYourEmail => 'Kontrolloni Email-in tuaj';

  @override
  String get weHaveSentYouAnEmailClickTheLink => 'Ju dërguam një email. Që të aktivizoni llogarinë tuaj, klikoni lidhjen te email-i.';

  @override
  String get ifYouDoNotSeeTheEmailCheckOtherPlaces => 'Nëse nuk e shihni email-in, kontrolloni në vendet e tjera ku mund të jetë, bie fjala dosje të pavlerash, hedhurinash, shoqërore, ose dosje të tjera.';

  @override
  String weHaveSentYouAnEmailTo(String param) {
    return 'Kemi dërguar një email te $param. Që të ricaktoni fjalëkalimin tuaj, klikoni mbi lidhjen te email-i.';
  }

  @override
  String byRegisteringYouAgreeToBeBoundByOur(String param) {
    return 'Duke u regjistruar, pajtoheni me $param.';
  }

  @override
  String readAboutOur(String param) {
    return 'Lexoni rreth $param tona.';
  }

  @override
  String get networkLagBetweenYouAndLichess => 'Vonesë rrjeti mes jush dhe Lichess';

  @override
  String get timeToProcessAMoveOnLichessServer => 'Kohë për përpunimin e një lëvizje në shërbyesin e Lichess-it';

  @override
  String get downloadAnnotated => 'Shkarkoje me shënimet';

  @override
  String get downloadRaw => 'Shkarkoje shqeto';

  @override
  String get downloadImported => 'Shkarko të importuarën';

  @override
  String get crosstable => 'Kryqtryeza';

  @override
  String get youCanAlsoScrollOverTheBoardToMoveInTheGame => 'Ju mund edhe të rrotulloni rrotën mbi fushë për të lëvizur gjatë lojës.';

  @override
  String get scrollOverComputerVariationsToPreviewThem => 'Lëviz tek variacionet e kompjuterit t\'i shikosh paraprakisht.';

  @override
  String get analysisShapesHowTo => 'Që të vizatoni rrathë dhe shigjeta në fushë, shtypni shift+klikim, ose djathtasklikoni.';

  @override
  String get letOtherPlayersMessageYou => 'Lejoni lojtarë të tjerë t’ju dërgojnë mesazh';

  @override
  String get receiveForumNotifications => 'Merrni njoftime kur përmendeni te forumi';

  @override
  String get shareYourInsightsData => 'Shpërndani të dhënat tuaja të depërtuara.';

  @override
  String get withNobody => 'Me askënd';

  @override
  String get withFriends => 'Me shokët';

  @override
  String get withEverybody => 'Me gjithkënd';

  @override
  String get kidMode => 'Mënyra për fëmijë';

  @override
  String get kidModeIsEnabled => 'Mënyra për fëmijë është e aktivizuar.';

  @override
  String get kidModeExplanation => 'Kjo është për sigurinë. Nën mënyrën për fëmijë, krejt komunikimet në sajt janë të çaktivizuara. Aktivizojeni këtë për fëmijët dhe nxënësit tuaj të shkollave, për t’i mbrojtur ata nga të tjerë përdorues të internetit.';

  @override
  String inKidModeTheLichessLogoGetsIconX(String param) {
    return 'Nën mënyrën për fëmijë, stemës së Lichess-it i vihet një ikonë $param, që ta dini se fëmijët tuaj janë të parrezik.';
  }

  @override
  String get askYourChessTeacherAboutLiftingKidMode => 'Llogaria juaj administrohet. Rreth heqjes së mënyrës “fëmijë” pyetni mëuesin tuaj të shahut.';

  @override
  String get enableKidMode => 'Aktivizo mënyrën për Fëmijë';

  @override
  String get disableKidMode => 'Çaktivizo mënyrën për Fëmijë';

  @override
  String get security => 'Siguri';

  @override
  String get sessions => 'Sesione';

  @override
  String get revokeAllSessions => 'shfuqizoji krejt sesionet';

  @override
  String get playChessEverywhere => 'Luani shah kudo';

  @override
  String get asFreeAsLichess => 'I lirë, si Lichess-i';

  @override
  String get builtForTheLoveOfChessNotMoney => 'Ndërtuar nga dashuria për shahun, jo për paranë';

  @override
  String get everybodyGetsAllFeaturesForFree => 'Gjithkush merr falas krejt veçoritë';

  @override
  String get zeroAdvertisement => 'Zero reklama';

  @override
  String get fullFeatured => 'I plotë';

  @override
  String get phoneAndTablet => 'Telefon dhe tablet';

  @override
  String get bulletBlitzClassical => 'Plumb, blic, klasik';

  @override
  String get correspondenceChess => 'Shah në korrespodencë';

  @override
  String get onlineAndOfflinePlay => 'Lojë në internet dhe jashtë tij';

  @override
  String get viewTheSolution => 'Shihni zgjidhjen';

  @override
  String get followAndChallengeFriends => 'Ndiqni dhe sfidoni shokë';

  @override
  String get gameAnalysis => 'Analiza e lojës';

  @override
  String xHostsY(String param1, String param2) {
    return '$param1 organizon $param2';
  }

  @override
  String xJoinsY(String param1, String param2) {
    return '$param1 merr pjesë në $param2';
  }

  @override
  String xLikesY(String param1, String param2) {
    return '$param1 pëlqen $param2';
  }

  @override
  String get quickPairing => 'Çiftim i shpejtë';

  @override
  String get lobby => 'Holli';

  @override
  String get anonymous => 'Anonim';

  @override
  String yourScore(String param) {
    return 'Rezultati juaj: $param';
  }

  @override
  String get language => 'Gjuha';

  @override
  String get background => 'Sfond';

  @override
  String get light => 'I çelët';

  @override
  String get dark => 'I errët';

  @override
  String get transparent => 'I tejdukshëm';

  @override
  String get deviceTheme => 'Temën e pajisjes';

  @override
  String get backgroundImageUrl => 'URL figure sfondi:';

  @override
  String get board => 'Fushë';

  @override
  String get size => 'Madhësi';

  @override
  String get opacity => 'Patejdukshmëri';

  @override
  String get brightness => 'Ndriçim';

  @override
  String get hue => 'Ngjyrim';

  @override
  String get boardReset => 'Riktheji ngjyrat te parazgjedhjet';

  @override
  String get pieceSet => 'Figura';

  @override
  String get embedInYourWebsite => 'Trupëzojeni në sajtin tuaj';

  @override
  String get usernameAlreadyUsed => 'Ky emër përdoruesi është tashmë në përdorim, ju lutemi, provoni një tjetër.';

  @override
  String get usernamePrefixInvalid => 'Emri i përdoruesit duhet të fillojë me një shkronjë.';

  @override
  String get usernameSuffixInvalid => 'Emri i përdoruesit duhet të përfundojë me një letër ose një numër.';

  @override
  String get usernameCharsInvalid => 'Emri i përdorues duhet të përmbajë vetëm shkronja, numra, nënvija dhe vija ndarëse. Nuk lejohen nënvija, as vija ndarëse të njëpasnjëshme.';

  @override
  String get usernameUnacceptable => 'Ky emër përdoruesi s’është i pranueshëm.';

  @override
  String get playChessInStyle => 'Luani shah me stil';

  @override
  String get chessBasics => 'Bazat e shahut';

  @override
  String get coaches => 'Trajnerë';

  @override
  String get invalidPgn => 'PGN e pavlefshme';

  @override
  String get invalidFen => 'FEN e pavlefshme';

  @override
  String get custom => 'Vetjake';

  @override
  String get notifications => 'Njoftime';

  @override
  String notificationsX(String param1) {
    return 'Njoftime: $param1';
  }

  @override
  String perfRatingX(String param) {
    return 'Vlerësimi: $param';
  }

  @override
  String get practiceWithComputer => 'Ushtrohuni me kompjuterin';

  @override
  String anotherWasX(String param) {
    return 'Një tjetër ishte $param';
  }

  @override
  String bestWasX(String param) {
    return 'Më i miri ishte $param';
  }

  @override
  String get youBrowsedAway => 'Levizja jote është shumë larg';

  @override
  String get resumePractice => 'Vazhdoni ushtrimin';

  @override
  String get drawByFiftyMoves => 'Loja ka dalë barazim sipas rregullit të pesëdhjetë lëvizjeve.';

  @override
  String get theGameIsADraw => 'Loja është remi.';

  @override
  String get computerThinking => 'Kompjuteri po mendohet …';

  @override
  String get seeBestMove => 'Shihni lëvizjen më të mirë';

  @override
  String get hideBestMove => 'Fshihe lëvizjen më të mirë';

  @override
  String get getAHint => 'Merrni një ndihmëz';

  @override
  String get evaluatingYourMove => 'Po vlerësohet lëvizja juaj …';

  @override
  String get whiteWinsGame => 'I bardhi fiton';

  @override
  String get blackWinsGame => 'I ziu fiton';

  @override
  String get learnFromYourMistakes => 'Mësoni nga gabimet tuaja';

  @override
  String get learnFromThisMistake => 'Mësoni nga ky gabim';

  @override
  String get skipThisMove => 'Anashkaloje këtë lëvizje';

  @override
  String get next => 'Pasuesja';

  @override
  String xWasPlayed(String param) {
    return '$param u luajt';
  }

  @override
  String get findBetterMoveForWhite => 'Gjej një lëvizje më të mirë për të bardhin';

  @override
  String get findBetterMoveForBlack => 'Gjej një lëvizje më të mirë për të ziun';

  @override
  String get resumeLearning => 'Vazhdoni mësimin';

  @override
  String get youCanDoBetter => 'Mundeni për më mirë';

  @override
  String get tryAnotherMoveForWhite => 'Provoni një tjetër lëvizje për të bardhin';

  @override
  String get tryAnotherMoveForBlack => 'Provoni një tjetër lëvizje për të ziun';

  @override
  String get solution => 'Zgjidhje';

  @override
  String get waitingForAnalysis => 'Po pritet për analizë';

  @override
  String get noMistakesFoundForWhite => 'S’u gjetën gabime për të bardhin';

  @override
  String get noMistakesFoundForBlack => 'S’u gjetën gabime për të ziun';

  @override
  String get doneReviewingWhiteMistakes => 'U bë shqyrtimi i gabimeve të të bardhit';

  @override
  String get doneReviewingBlackMistakes => 'U bë shqyrtimi i gabimeve të të ziut';

  @override
  String get doItAgain => 'Ribëje';

  @override
  String get reviewWhiteMistakes => 'Shqyrtoni gabimet e të bardhit';

  @override
  String get reviewBlackMistakes => 'Shqyrtoni gabimet e të ziut';

  @override
  String get advantage => 'Avantazh';

  @override
  String get opening => 'Hapje';

  @override
  String get middlegame => 'Lojë e mesme';

  @override
  String get endgame => 'Fund loje';

  @override
  String get conditionalPremoves => 'Condizionale lëvizje';

  @override
  String get addCurrentVariation => 'Shto variantin e tanishëm';

  @override
  String get playVariationToCreateConditionalPremoves => 'Që të krijohen lëvizje paraprake të kushtëzuara, luani një variant';

  @override
  String get noConditionalPremoves => 'Nuk ka premove condicionale';

  @override
  String playX(String param) {
    return 'Luani $param';
  }

  @override
  String get showUnreadLichessMessage => 'Morët një mesazh privat nga Lichess.';

  @override
  String get clickHereToReadIt => 'Klikoni këtu që ta lexoni';

  @override
  String get sorry => 'Na ndjeni :(';

  @override
  String get weHadToTimeYouOutForAWhile => 'Na u desh t’ju ndalnim për ca kohë.';

  @override
  String get why => 'Pse?';

  @override
  String get pleasantChessExperience => 'Synojmë të ofrojmë përvojë të këndshme me shahun për këdo.';

  @override
  String get goodPractice => 'Për këtë qëllim, duhet të garantojmë që krejt tarët të ndjekin praktikat e mira.';

  @override
  String get potentialProblem => 'Kur pikaset një problem i mundshëm, shfaqim këtë mesazh.';

  @override
  String get howToAvoidThis => 'Si të shmanget ky?';

  @override
  String get playEveryGame => 'Luani çdo lojë që filloni.';

  @override
  String get tryToWin => 'Përpiquni të fitoni (ose të paktën të barazoni) çdo lojë që luani.';

  @override
  String get resignLostGames => 'Në lojëra të humbura, dorëzohuni (mos lini të përfundojë koha).';

  @override
  String get temporaryInconvenience => 'Kërkojmë ndjesë për bezdisjen e përkohshme,';

  @override
  String get wishYouGreatGames => 'edhe ju urojmë lojëra të shkëlqyera në lichess.org.';

  @override
  String get thankYouForReading => 'Faleminderit për leximin!';

  @override
  String get lifetimeScore => 'Rezultati i jetës';

  @override
  String get currentMatchScore => 'Rezultati i ndeshjes së tanishme';

  @override
  String get agreementAssistance => 'Pranoj se s’do të marr kurrë asistencë gjatë lojërave të mia (nga një kompjuter, libër apo bazë të dhënash shahu, ose nga persona tjetër).';

  @override
  String get agreementNice => 'Pranoj se do të tregoj përherë respekt për lojtarët e tjerë.';

  @override
  String agreementMultipleAccounts(String param) {
    return 'Pranoj se nuk do të krijoj disa llogari (hiq për arsyet e deklaruara te $param).';
  }

  @override
  String get agreementPolicy => 'Jam dakord se do të ndjek krejt rregullat e Lichess-it.';

  @override
  String get searchOrStartNewDiscussion => 'Kërkoni ose filloni bisedë të re';

  @override
  String get edit => 'Përpunojeni';

  @override
  String get bullet => 'Bullet';

  @override
  String get blitz => 'Blitz';

  @override
  String get rapid => 'E shpejtë';

  @override
  String get classical => 'Klasike';

  @override
  String get ultraBulletDesc => 'Lojëra marrëzisht të shpejta: më pak se 30 sekonda';

  @override
  String get bulletDesc => 'Lojëra shumë të shpejta: më pak se 3 minuta';

  @override
  String get blitzDesc => 'Lojëra të shpejta: 3 deri në 8 minuta';

  @override
  String get rapidDesc => 'Lojëra të shpejta: 8 deri në 25 minuta';

  @override
  String get classicalDesc => 'Lojëra klasike: 25 minuta dhe më';

  @override
  String get correspondenceDesc => 'Lojëra me korrespondencë: një ose disa ditë për lëvizje';

  @override
  String get puzzleDesc => 'Trajner taktikash shahu';

  @override
  String get important => 'E rëndësishme';

  @override
  String yourQuestionMayHaveBeenAnswered(String param1) {
    return 'Pyetja juaj mund të ketë tashmë një përgjigje $param1';
  }

  @override
  String get inTheFAQ => 'te PBR';

  @override
  String toReportSomeoneForCheatingOrBadBehavior(String param1) {
    return 'Për të raportuar një përdorues për hile ose sjellje të keqe, $param1';
  }

  @override
  String get useTheReportForm => 'përdorni formularin e raportimeve';

  @override
  String toRequestSupport(String param1) {
    return 'Për të kërkuar asistencë, $param1';
  }

  @override
  String get tryTheContactPage => 'provoni faqen e kontaktit';

  @override
  String makeSureToRead(String param1) {
    return 'Mos harroni të lexoni $param1';
  }

  @override
  String get theForumEtiquette => 'rregullat e etiketës në forum';

  @override
  String get thisTopicIsArchived => 'Kjo temë është arkivuar dhe në të s’mund të përgjigjen më.';

  @override
  String joinTheTeamXToPost(String param1) {
    return 'Që të postoni në këtë forum, bëhuni pjesë e $param1';
  }

  @override
  String teamNamedX(String param1) {
    return 'Ekipi $param1';
  }

  @override
  String get youCannotPostYetPlaySomeGames => 'S’mund të postoni ende në forumet. Luani ca lojëra!';

  @override
  String get subscribe => 'Pajtohuni';

  @override
  String get unsubscribe => 'Shpajtohuni';

  @override
  String mentionedYouInX(String param1) {
    return 'ju përmendi te “$param1”.';
  }

  @override
  String xMentionedYouInY(String param1, String param2) {
    return '$param1 ju përmendi te “$param2”.';
  }

  @override
  String invitedYouToX(String param1) {
    return 'ju ftoi në studimin \"$param1\".';
  }

  @override
  String xInvitedYouToY(String param1, String param2) {
    return '$param1 ju ftoi në “$param2”.';
  }

  @override
  String get youAreNowPartOfTeam => 'Tani jeni pjesë e ekipit.';

  @override
  String youHaveJoinedTeamX(String param1) {
    return 'U bëtë pjesë e “$param1”.';
  }

  @override
  String get someoneYouReportedWasBanned => 'Dikush që raportuat, u dëbua';

  @override
  String get congratsYouWon => 'Urime, fituat!';

  @override
  String gameVsX(String param1) {
    return 'Lojë kundër $param1';
  }

  @override
  String resVsX(String param1, String param2) {
    return '$param1 kundër $param2';
  }

  @override
  String get lostAgainstTOSViolator => 'Humbët ndaj dikujt që shkeli Kushtet e Shërbimit të Lichess-it';

  @override
  String refundXpointsTimeControlY(String param1, String param2) {
    return 'Kompensim: $param1 pikë $param2.';
  }

  @override
  String get timeAlmostUp => 'Koha gati mbaroi!';

  @override
  String get clickToRevealEmailAddress => '[Klikoni që të zbulohet adresa email]';

  @override
  String get download => 'Shkarkoje';

  @override
  String get coachManager => 'Trajner';

  @override
  String get streamerManager => 'Përgjegjës transmetimesh';

  @override
  String get cancelTournament => 'Anulojeni turneun';

  @override
  String get tournDescription => 'Përshkrim turneu';

  @override
  String get tournDescriptionHelp => 'Ndonjë gjë e veçantë që dëshironi t’u thoni pjesëmarrësve? Përpiquni të jetë me pak fjalë. Mund të përdoren lidhje Markdown: [name](https://url)';

  @override
  String get ratedFormHelp => 'Lojërat vlerësohen\ndhe ndikojnë te vlerësimet e lojëtarëve';

  @override
  String get onlyMembersOfTeam => 'Vetëm pjesëmarrës të ekipit';

  @override
  String get noRestriction => 'Pa kufizim';

  @override
  String get minimumRatedGames => 'Lojëra të vlerësuara në minimum';

  @override
  String get minimumRating => 'Vlerësim minimum';

  @override
  String get maximumWeeklyRating => 'Vlerësimi më i madh javor';

  @override
  String positionInputHelp(String param) {
    return 'Ngjitni një FEN të vlefshëm, që çdo lojë të niset prej një pozicioni të dhënë.\nFunksionon vetëm për lojëra standarde, jo me variante.\nMund të përdorni $param për të prodhuar një pozicion FEN, mandej ta ngjitni këtu.\nQë lojërat të fillojnë nga pozicioni fillestar normal, lëreni të zbrazët.';
  }

  @override
  String get cancelSimul => 'Anuloje simultanen';

  @override
  String get simulHostcolor => 'Ngjyrë organizatori për çdo lojë';

  @override
  String get estimatedStart => 'Kohë fillimi përafërsisht';

  @override
  String simulFeatured(String param) {
    return 'Shfaqe në $param';
  }

  @override
  String simulFeaturedHelp(String param) {
    return 'Shfaqeni simultanen tuaj për këdo, në $param. Për simultane private, çaktivizojeni.';
  }

  @override
  String get simulDescription => 'Përshkrim simultaneje';

  @override
  String get simulDescriptionHelp => 'Ndonjë gjë që doni t’u thoni pjesëmarrësve?';

  @override
  String markdownAvailable(String param) {
    return 'Për sintaksë më të thelluar mund të përdoret $param-i.';
  }

  @override
  String get embedsAvailable => 'Ngjitni një URL loje ose URL kapitulli mësimi, për ta trupëzuar.';

  @override
  String get inYourLocalTimezone => 'Në zonën tuaj kohore vendore';

  @override
  String get tournChat => 'Fjalosje turneu';

  @override
  String get noChat => 'Pa fjalosje';

  @override
  String get onlyTeamLeaders => 'Vetëm kapitenët e ekipeve';

  @override
  String get onlyTeamMembers => 'Vetëm anëtarët e ekipeve';

  @override
  String get navigateMoveTree => 'Lëvizni nëpër pemën e lëvizjeve';

  @override
  String get mouseTricks => 'Gjeste miu';

  @override
  String get toggleLocalAnalysis => 'Aktivizo/Çaktivizo analizë kompjuterike';

  @override
  String get toggleAllAnalysis => 'Aktivizo/Çaktivizo krejt analizat kompjuterike';

  @override
  String get playComputerMove => 'Bëj lëvizjen më të mirë të kompjuterit';

  @override
  String get analysisOptions => 'Mundësi analize';

  @override
  String get focusChat => 'Vëmendjen te fjalosja';

  @override
  String get showHelpDialog => 'Shfaq këtë dialog ndihme';

  @override
  String get reopenYourAccount => 'Rihapni llogarinë tuaj';

  @override
  String get closedAccountChangedMind => 'Nëse e mbyllët llogarinë tuaj, por prej atëherë keni ndërruar mendje, mund t’ju jepet një shans për të rimarrë llogarinë tuaj.';

  @override
  String get onlyWorksOnce => 'Kjo do të funksionojë vetëm një herë.';

  @override
  String get cantDoThisTwice => 'Nëse e mbyllni llogarinë tuaj për herë të dytë, s’do të ketë mënyrë për ta rimarrë.';

  @override
  String get emailAssociatedToaccount => 'Adresë email përshoqëruar llogarisë';

  @override
  String get sentEmailWithLink => 'Ju dërguam një email me një lidhje.';

  @override
  String get tournamentEntryCode => 'Kod hyrjeje në turne';

  @override
  String get hangOn => 'Pritni!';

  @override
  String gameInProgress(String param) {
    return 'Keni një lojë në ecuri e sipër me $param.';
  }

  @override
  String get abortTheGame => 'Ndërpriteni lojën';

  @override
  String get resignTheGame => 'Dorëzohuni';

  @override
  String get youCantStartNewGame => 'S’mund të filloni një lojë të re pa mbaruar këtë lojë.';

  @override
  String get since => 'Që nga';

  @override
  String get until => 'Deri më';

  @override
  String get lichessDbExplanation => 'Lojëra me vlerësim, marrë nga krejt lojëtarët e Lichess-it';

  @override
  String get switchSides => 'Ndërroni palët';

  @override
  String get closingAccountWithdrawAppeal => 'Mbyllja e llogarisë tuaj do të sjellë tërheqjen e apelimit tuaj';

  @override
  String get ourEventTips => 'Këshillat tona për organizim veprimtarish';

  @override
  String get instructions => 'Udhëzime';

  @override
  String get showMeEverything => 'Shfaqmë gjithçka';

  @override
  String get lichessPatronInfo => 'Lichess është një program bamirësie dhe krejtësisht falas/libre, me burim të hapët.\nKrejt kostot operative, zhvillimi dhe lënda financohen vetëm me dhurime nga përdoruesit.';

  @override
  String get nothingToSeeHere => 'S’ka ç’shihet këtu tani.';

  @override
  String opponentLeftCounter(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Kundërshtari juaj la lojën. Mund të kërkoni fitoren pas $count sekondash.',
      one: 'Kundërshtari juaj la lojën. Mund të kërkoni fitoren pas $count sekondash.',
    );
    return '$_temp0';
  }

  @override
  String mateInXHalfMoves(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Mat në $count gjysmë lëvizje',
      one: 'Mat në $count gjysmë lëvizje',
    );
    return '$_temp0';
  }

  @override
  String nbBlunders(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count gafa',
      one: '$count gafë',
    );
    return '$_temp0';
  }

  @override
  String nbMistakes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count gabime',
      one: '$count gabim',
    );
    return '$_temp0';
  }

  @override
  String nbInaccuracies(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count pasaktësi',
      one: '$count pasaktësi',
    );
    return '$_temp0';
  }

  @override
  String nbPlayers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count lojtarë',
      one: '$count lojtar',
    );
    return '$_temp0';
  }

  @override
  String nbGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count lojëra',
      one: '$count lojë',
    );
    return '$_temp0';
  }

  @override
  String ratingXOverYGames(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Vlerësuar me $count për $param2 lojëra',
      one: 'Vlerësuar me $count për $param2 lojë',
    );
    return '$_temp0';
  }

  @override
  String nbBookmarks(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count faqerojtës',
      one: '$count faqerojtës',
    );
    return '$_temp0';
  }

  @override
  String nbDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ditë',
      one: '$count ditë',
    );
    return '$_temp0';
  }

  @override
  String nbHours(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count orë',
      one: '$count orë',
    );
    return '$_temp0';
  }

  @override
  String nbMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count minuta',
      one: '$count minutë',
    );
    return '$_temp0';
  }

  @override
  String rankIsUpdatedEveryNbMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Renditja përditësohet çdo $count minuta',
      one: 'Renditja përditësohet çdo minutë',
    );
    return '$_temp0';
  }

  @override
  String nbPuzzles(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ushtrime',
      one: '$count ushtrimi',
    );
    return '$_temp0';
  }

  @override
  String nbGamesWithYou(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count lojëra me ju',
      one: '$count lojë me ju',
    );
    return '$_temp0';
  }

  @override
  String nbRated(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count të vlerësuara',
      one: '$count e vlerësuar',
    );
    return '$_temp0';
  }

  @override
  String nbWins(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count fitore',
      one: '$count fitore',
    );
    return '$_temp0';
  }

  @override
  String nbLosses(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count humbje',
      one: '$count humbje',
    );
    return '$_temp0';
  }

  @override
  String nbDraws(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count barazime',
      one: '$count barazim',
    );
    return '$_temp0';
  }

  @override
  String nbPlaying(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count duke luajtur',
      one: '$count po luan',
    );
    return '$_temp0';
  }

  @override
  String giveNbSeconds(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Dhuro $count sekonda',
      one: 'Jep $count sekondë',
    );
    return '$_temp0';
  }

  @override
  String nbTournamentPoints(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count pikë nga turnetë',
      one: '$count pikë nga turnetë',
    );
    return '$_temp0';
  }

  @override
  String nbStudies(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count studime',
      one: '$count studim',
    );
    return '$_temp0';
  }

  @override
  String nbSimuls(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count simultane',
      one: '$count simultane',
    );
    return '$_temp0';
  }

  @override
  String moreThanNbRatedGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Lojëra të vlerësuara me ≥ $count',
      one: 'Lojë e vlerësuar me ≥ $count',
    );
    return '$_temp0';
  }

  @override
  String moreThanNbPerfRatedGames(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Lojëra të vlerësuara me ≥ $count $param2',
      one: 'Lojë e vlerësuar me ≥ $count $param2',
    );
    return '$_temp0';
  }

  @override
  String needNbMorePerfGames(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Lypset të luani edhe $count lojëra të vlerësuara me $param2',
      one: 'Lypset të luani edhe $count lojë të vlerësuar me $param2',
    );
    return '$_temp0';
  }

  @override
  String needNbMoreGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Lypset të luani edhe $count lojëra të vlerësuara',
      one: 'Lypset të luani edhe $count lojë të vlerësuar',
    );
    return '$_temp0';
  }

  @override
  String nbImportedGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count lojëra të importuara',
      one: '$count lojë e importuar',
    );
    return '$_temp0';
  }

  @override
  String nbFriendsOnline(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count shokë në linjë',
      one: '$count shok në linjë',
    );
    return '$_temp0';
  }

  @override
  String nbFollowers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ndjekës',
      one: '$count ndjekës',
    );
    return '$_temp0';
  }

  @override
  String nbFollowing(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count që ndiqen',
      one: '$count që ndiqet',
    );
    return '$_temp0';
  }

  @override
  String lessThanNbMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Më pak se $count minuta',
      one: 'Më pak se $count minutë',
    );
    return '$_temp0';
  }

  @override
  String nbGamesInPlay(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count lojëra duke u luajtur',
      one: '$count lojë duke u luajtur',
    );
    return '$_temp0';
  }

  @override
  String maximumNbCharacters(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'E shumta:$count shenja.',
      one: 'E shumta:$count shenjë.',
    );
    return '$_temp0';
  }

  @override
  String blocks(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count bllokime',
      one: '$count bllokim',
    );
    return '$_temp0';
  }

  @override
  String nbForumPosts(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count postime forumi',
      one: '$count postim forumi',
    );
    return '$_temp0';
  }

  @override
  String nbPerfTypePlayersThisWeek(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count $param2 lojtarë këtë javë.',
      one: '$count $param2 lojtar këtë javë.',
    );
    return '$_temp0';
  }

  @override
  String availableInNbLanguages(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'I përdorshëm në $count gjuhë!',
      one: 'I përdorshëm në $count gjuhë!',
    );
    return '$_temp0';
  }

  @override
  String nbSecondsToPlayTheFirstMove(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count sekonda për kryerjen e lëvizjes së parë',
      one: '$count sekondë për kryerjen e lëvizjes së parë',
    );
    return '$_temp0';
  }

  @override
  String nbSeconds(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count sekonda',
      one: '$count sekondë',
    );
    return '$_temp0';
  }

  @override
  String andSaveNbPremoveLines(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'edhe ruaj $count linja premove',
      one: 'edhe ruaj $count linja premove',
    );
    return '$_temp0';
  }

  @override
  String get stormMoveToStart => 'Bëni një lëvizje, që të fillohet';

  @override
  String get stormYouPlayTheWhitePiecesInAllPuzzles => 'Ju luani me gurët e bardhë në krejt ushtrimet';

  @override
  String get stormYouPlayTheBlackPiecesInAllPuzzles => 'Ju luani me gurët e zinj në krejt ushtrimet';

  @override
  String get stormPuzzlesSolved => 'ushtrime të zgjidhura';

  @override
  String get stormNewDailyHighscore => 'Rekord i ri ditor!';

  @override
  String get stormNewWeeklyHighscore => 'Rekord i ri javor!';

  @override
  String get stormNewMonthlyHighscore => 'Rekord i ri mujor!';

  @override
  String get stormNewAllTimeHighscore => 'Rekord i ri i përgjithshëm!';

  @override
  String stormPreviousHighscoreWasX(String param) {
    return 'Rekordi i mëhershëm ishte $param';
  }

  @override
  String get stormPlayAgain => 'Luani sërish';

  @override
  String stormHighscoreX(String param) {
    return 'Rekord: $param';
  }

  @override
  String get stormScore => 'Përfundimi';

  @override
  String get stormMoves => 'Lëvizje';

  @override
  String get stormAccuracy => 'Saktësi';

  @override
  String get stormCombo => 'Kombinime';

  @override
  String get stormTime => 'Kohë';

  @override
  String get stormTimePerMove => 'Kohë për lëvizje';

  @override
  String get stormHighestSolved => 'Më e vështira e zgjidhur';

  @override
  String get stormPuzzlesPlayed => 'Ushtrime të luajtura';

  @override
  String get stormNewRun => 'Raund i ri (shtype: Space)';

  @override
  String get stormEndRun => 'Mbylle raundin (shtype: Enter)';

  @override
  String get stormHighscores => 'Rekorde';

  @override
  String get stormViewBestRuns => 'Shiko raundet më të mira';

  @override
  String get stormBestRunOfDay => 'Raundi më i mire i ditës';

  @override
  String get stormRuns => 'Raunde';

  @override
  String get stormGetReady => 'Bëhuni gati!';

  @override
  String get stormWaitingForMorePlayers => 'Po pritet të vijnë më tepër lojtarë…';

  @override
  String get stormRaceComplete => 'Gara përfundoi!';

  @override
  String get stormSpectating => 'Shikues';

  @override
  String get stormJoinTheRace => 'Merrni pjesë në garë!';

  @override
  String get stormStartTheRace => 'Nisni garën';

  @override
  String stormYourRankX(String param) {
    return 'Renditja juaj: $param';
  }

  @override
  String get stormWaitForRematch => 'Prit për revansh';

  @override
  String get stormNextRace => 'Gara pasuese';

  @override
  String get stormJoinRematch => 'Bashkohu revanshës';

  @override
  String get stormWaitingToStart => 'Po pritet të fillohet';

  @override
  String get stormCreateNewGame => 'Krijoni lojë të re';

  @override
  String get stormJoinPublicRace => 'Merrni pjesë në një garë publike';

  @override
  String get stormRaceYourFriends => 'Garoni kundër shokëve';

  @override
  String get stormSkip => 'anashkaloje';

  @override
  String get stormSkipHelp => 'Mundeni të anashkaloni një lëvizje për garë:';

  @override
  String get stormSkipExplanation => 'Anashkalojeni këtë lëvizje që të ruani kombinimin tuaj! Mund të kryet një herë për garë.';

  @override
  String get stormFailedPuzzles => 'Ushtrime të dështuara';

  @override
  String get stormSlowPuzzles => 'Ushtrime të ngadalta';

  @override
  String get stormSkippedPuzzle => 'Ushtrimi i kapërcyer';

  @override
  String get stormThisWeek => 'Këtë javë';

  @override
  String get stormThisMonth => 'Këtë muaj';

  @override
  String get stormAllTime => 'Për krejt kohën';

  @override
  String get stormClickToReload => 'Klikoni të ringarkohet';

  @override
  String get stormThisRunHasExpired => 'Ky raund ka skaduar!';

  @override
  String get stormThisRunWasOpenedInAnotherTab => 'Ky raund qe hapur në një tjetër skedë!';

  @override
  String stormXRuns(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count raunde',
      one: '1 raund',
    );
    return '$_temp0';
  }

  @override
  String stormPlayedNbRunsOfPuzzleStorm(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Luajti $count raunde nga $param2',
      one: 'Luajti një raund nga $param2',
    );
    return '$_temp0';
  }

  @override
  String get streamerLichessStreamers => 'Transmetues Lichess-i';

  @override
  String get studyShareAndExport => 'Ndajeni me të tjerë & eksportoni';

  @override
  String get studyStart => 'Fillo';
}
