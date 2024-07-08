import 'package:intl/intl.dart' as intl;

import 'l10n.dart';

/// The translations for Estonian (`et`).
class AppLocalizationsEt extends AppLocalizations {
  AppLocalizationsEt([String locale = 'et']) : super(locale);

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
  String get activityActivity => 'Aktiivsus';

  @override
  String get activityHostedALiveStream => 'Tegi otseülekannet';

  @override
  String activityRankedInSwissTournament(String param1, String param2) {
    return 'Saavutas $param1. koha mängus $param2';
  }

  @override
  String get activitySignedUp => 'Registreerus lehel lichess.org';

  @override
  String activitySupportedNbMonths(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Toeta Lichess.org\'i $count kuud $param2',
      one: 'Toeta Lichess.org\'i $count kuu $param2',
    );
    return '$_temp0';
  }

  @override
  String activityPracticedNbPositions(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Harjutas $count seisu teemas $param2',
      one: 'Harjutas $count seisu teemas $param2',
    );
    return '$_temp0';
  }

  @override
  String activitySolvedNbPuzzles(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Lahendas $count taktikalist puslet',
      one: 'Lahendas $count taktikalise pusle',
    );
    return '$_temp0';
  }

  @override
  String activityPlayedNbGames(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Mängis $count $param2 mängu',
      one: 'Mängis $count $param2 mängu',
    );
    return '$_temp0';
  }

  @override
  String activityPostedNbMessages(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Postitas $count sõnumit foorumis $param2',
      one: 'Postitas $count sõnumi foorumis $param2',
    );
    return '$_temp0';
  }

  @override
  String activityPlayedNbMoves(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Mängis $count käiku',
      one: 'Mängis $count käigu',
    );
    return '$_temp0';
  }

  @override
  String activityInNbCorrespondenceGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'lõpetas $count kirjavahetusmängu',
      one: 'lõpetas $count kirjavahetusmängu',
    );
    return '$_temp0';
  }

  @override
  String activityCompletedNbGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Lõpetas $count kirjavahetusmängu',
      one: 'Lõpetas $count kirjavahetusmängu',
    );
    return '$_temp0';
  }

  @override
  String activityFollowedNbPlayers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Hakkas jälgima $count mängijat',
      one: 'Hakkas jälgima $count mängijat',
    );
    return '$_temp0';
  }

  @override
  String activityGainedNbFollowers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Sai $count uut jälgijat',
      one: 'Sai $count uue jälgija',
    );
    return '$_temp0';
  }

  @override
  String activityHostedNbSimuls(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Korraldas $count simultaani',
      one: 'Korraldas $count simultaani',
    );
    return '$_temp0';
  }

  @override
  String activityJoinedNbSimuls(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Osales $count simultaanis',
      one: 'Osales $count simultaanis',
    );
    return '$_temp0';
  }

  @override
  String activityCreatedNbStudies(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Lõi $count uut õpet',
      one: 'Lõi $count uue õppe',
    );
    return '$_temp0';
  }

  @override
  String activityCompetedInNbTournaments(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Võistles $count turniiril',
      one: 'Võistles $count turniiril',
    );
    return '$_temp0';
  }

  @override
  String activityRankedInTournament(int count, String param2, String param3, String param4) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Saavutas #$count koha (parima $param2% seas) $param3 mänguga turniiril $param4',
      one: 'Saavutas #$count koha (parima $param2% seas) $param3 mänguga turniiril $param4',
    );
    return '$_temp0';
  }

  @override
  String activityCompetedInNbSwissTournaments(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Võistles $count šveitsi turniiril',
      one: 'Võistles $count šveitsi turniiril',
    );
    return '$_temp0';
  }

  @override
  String activityJoinedNbTeams(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Liitus $count rühmaga',
      one: 'Liitus $count rühmaga',
    );
    return '$_temp0';
  }

  @override
  String get broadcastBroadcasts => 'Otseülekanded';

  @override
  String get broadcastLiveBroadcasts => 'Otseülekanded turniirilt';

  @override
  String challengeChallengesX(String param1) {
    return 'Challenges: $param1';
  }

  @override
  String get challengeChallengeToPlay => 'Väljakutse mängule';

  @override
  String get challengeChallengeDeclined => 'Väljakutse tagasi lükatud';

  @override
  String get challengeChallengeAccepted => 'Väljakutse vastu võetud!';

  @override
  String get challengeChallengeCanceled => 'Väljakutse tühistatud.';

  @override
  String get challengeRegisterToSendChallenges => 'Palun registreeri, et väljakutseid saata.';

  @override
  String challengeYouCannotChallengeX(String param) {
    return 'Sa ei saa väljakutset esitada mängijale $param.';
  }

  @override
  String challengeXDoesNotAcceptChallenges(String param) {
    return 'Mängija $param ei võta väljakutseid vastu.';
  }

  @override
  String challengeYourXRatingIsTooFarFromY(String param1, String param2) {
    return 'Sinu $param1 reiting on liiga kaugel mängija $param2 omast.';
  }

  @override
  String challengeCannotChallengeDueToProvisionalXRating(String param) {
    return 'Ei saa väljakutset esitada ajutise $param reitingu tõttu.';
  }

  @override
  String challengeXOnlyAcceptsChallengesFromFriends(String param) {
    return '$param võtab väljakutseid vastu ainult sõpradelt.';
  }

  @override
  String get challengeDeclineGeneric => 'Ma ei võta hetkel väljakutseid vastu.';

  @override
  String get challengeDeclineLater => 'Praegu ei sobi minule, palun küsi hiljem uuesti.';

  @override
  String get challengeDeclineTooFast => 'See ajakontroll on liiga kiire minu jaoks, palun esita väljakutse aeglasemale mängule.';

  @override
  String get challengeDeclineTooSlow => 'See ajakontroll on liiga aeglane minu jaoks, palun esita väljakutse kiiremale mängule.';

  @override
  String get challengeDeclineTimeControl => 'Ma ei võta selle ajakontrolliga väljakutseid vastu.';

  @override
  String get challengeDeclineRated => 'Palun saada mulle väljakutse reitinguga mängule.';

  @override
  String get challengeDeclineCasual => 'Palun saada mulle väljakutse reitinguta mängule.';

  @override
  String get challengeDeclineStandard => 'Ma ei võta hetkel vastu väljakutseid variant-mängudele.';

  @override
  String get challengeDeclineVariant => 'Ma ei taha mängida seda varianti praegu.';

  @override
  String get challengeDeclineNoBot => 'Ma ei võta vastu väljakutseid bottidelt.';

  @override
  String get challengeDeclineOnlyBot => 'Ma võtan väljakutseid vastu ainult bottidelt.';

  @override
  String get challengeInviteLichessUser => 'Või kutsu Lichessi kasutaja:';

  @override
  String get contactContact => 'Kontakt';

  @override
  String get contactContactLichess => 'Kontakteerumine';

  @override
  String get patronDonate => 'Anneta';

  @override
  String get patronLichessPatron => 'Lichessi toetaja';

  @override
  String perfStatPerfStats(String param) {
    return '$param statistika';
  }

  @override
  String get perfStatViewTheGames => 'Vaata mängud';

  @override
  String get perfStatProvisional => 'ajutine';

  @override
  String get perfStatNotEnoughRatedGames => 'Pole mängitud piisavalt reitinguga mänge, et luua usaldusväärset reitingut.';

  @override
  String perfStatProgressOverLastXGames(String param) {
    return 'Areng viimase $param mängu jooksul:';
  }

  @override
  String perfStatRatingDeviation(String param) {
    return 'Reitingunihe: $param.';
  }

  @override
  String perfStatRatingDeviationTooltip(String param1, String param2, String param3) {
    return 'Väiksem väärtus tähendab, et reiting on stabiilsem. Rohkem kui $param1 tähendab ajutist reitingut. Rankingu saamiseks see väärtus peab olema väiksem kui $param2 (tavamale) või $param3 (variandid).';
  }

  @override
  String get perfStatTotalGames => 'Mänge kokku';

  @override
  String get perfStatRatedGames => 'Reitinguga mängu';

  @override
  String get perfStatTournamentGames => 'Turniirimänge';

  @override
  String get perfStatBerserkedGames => 'Berserk mänge';

  @override
  String get perfStatTimeSpentPlaying => 'Mängimiseks kulutatud aeg';

  @override
  String get perfStatAverageOpponent => 'Keskmine vastane';

  @override
  String get perfStatVictories => 'Võite';

  @override
  String get perfStatDefeats => 'Kaotusi';

  @override
  String get perfStatDisconnections => 'Ühendus kaotatud';

  @override
  String get perfStatNotEnoughGames => 'Ei ole piisavalt palju mängitud';

  @override
  String perfStatHighestRating(String param) {
    return 'Kõrgeim reiting: $param';
  }

  @override
  String perfStatLowestRating(String param) {
    return 'Madalaim reiting: $param';
  }

  @override
  String perfStatFromXToY(String param1, String param2) {
    return 'ajavahemikus $param1 - $param2';
  }

  @override
  String get perfStatWinningStreak => 'Võitude seeria';

  @override
  String get perfStatLosingStreak => 'Kaotuste seeria';

  @override
  String perfStatLongestStreak(String param) {
    return 'Pikim seeria: $param';
  }

  @override
  String perfStatCurrentStreak(String param) {
    return 'Praegune seeria: $param';
  }

  @override
  String get perfStatBestRated => 'Parimad reitinguga võidud';

  @override
  String get perfStatGamesInARow => 'Järjestikusi mänge';

  @override
  String get perfStatLessThanOneHour => 'Mängude vahel vähem kui tund';

  @override
  String get perfStatMaxTimePlaying => 'Pikim aeg mängimas';

  @override
  String get perfStatNow => 'nüüd';

  @override
  String get preferencesPreferences => 'Sätted';

  @override
  String get preferencesDisplay => 'Kuva';

  @override
  String get preferencesPrivacy => 'Privaatsus';

  @override
  String get preferencesNotifications => 'Teavitused';

  @override
  String get preferencesPieceAnimation => 'Malendite liikumine';

  @override
  String get preferencesMaterialDifference => 'Materjali erinevus';

  @override
  String get preferencesBoardHighlights => 'Rõhutata viimast käiku ja tuld';

  @override
  String get preferencesPieceDestinations => 'Malendi sihtkohad (reeglipärased käigud ja eelkäigud)';

  @override
  String get preferencesBoardCoordinates => 'Laua koordinaadid (A-H, 1-8)';

  @override
  String get preferencesMoveListWhilePlaying => 'Käikude loend mängides';

  @override
  String get preferencesPgnPieceNotation => 'Käikude notatsioon';

  @override
  String get preferencesChessPieceSymbol => 'Malendi sümbol';

  @override
  String get preferencesPgnLetter => 'Täht (K, Q, R, B, N)';

  @override
  String get preferencesZenMode => 'Keskendumis mood';

  @override
  String get preferencesShowPlayerRatings => 'Kuva mängijate reitingud';

  @override
  String get preferencesShowFlairs => 'Show player flairs';

  @override
  String get preferencesExplainShowPlayerRatings => 'Kui valid \"Ei\", siis peidetakse kõikide mängijate reitingud, et saaksid paremini malele keskenduda. Partiidel on ikka reitingud, muutub ainult mida kuvatakse.';

  @override
  String get preferencesDisplayBoardResizeHandle => 'Näita laua suuruse muutmis suvandit';

  @override
  String get preferencesOnlyOnInitialPosition => 'Ainult algasendis';

  @override
  String get preferencesInGameOnly => 'In-game only';

  @override
  String get preferencesChessClock => 'Malekell';

  @override
  String get preferencesTenthsOfSeconds => 'Kümnendikku sekundit';

  @override
  String get preferencesWhenTimeRemainingLessThanTenSeconds => 'Kui aega on jäänud < 10 sekundit';

  @override
  String get preferencesHorizontalGreenProgressBars => 'Horisontaalne roheline progressi riba';

  @override
  String get preferencesSoundWhenTimeGetsCritical => 'Heli kui aeg hakkab lõppema';

  @override
  String get preferencesGiveMoreTime => 'Anna lisaaega';

  @override
  String get preferencesGameBehavior => 'Mängu seaded';

  @override
  String get preferencesHowDoYouMovePieces => 'Kuidas malendeid liigutada?';

  @override
  String get preferencesClickTwoSquares => 'Vajuta kahele ruudule';

  @override
  String get preferencesDragPiece => 'Lohista malendit';

  @override
  String get preferencesBothClicksAndDrag => 'Mõlemad';

  @override
  String get preferencesPremovesPlayingDuringOpponentTurn => 'Eelkäik (käigu tegemine vastase käigu ajal)';

  @override
  String get preferencesTakebacksWithOpponentApproval => 'Tagasivõtmised (vastase nõusolekul)';

  @override
  String get preferencesInCasualGamesOnly => 'Ainult ilma reitinguta mängudes';

  @override
  String get preferencesPromoteToQueenAutomatically => 'Automaatselt edenda lipuks';

  @override
  String get preferencesExplainPromoteToQueenAutomatically => 'Hoia edendamise ajal <ctrl> klahvi all, et ajutiselt keelata automaatne edendamine';

  @override
  String get preferencesWhenPremoving => 'Eelkäiguga';

  @override
  String get preferencesClaimDrawOnThreefoldRepetitionAutomatically => 'Kuuluta viik kolmekordsel kordusel automaatselt';

  @override
  String get preferencesWhenTimeRemainingLessThanThirtySeconds => 'Kui aega on jäänud < 30 sekundit';

  @override
  String get preferencesMoveConfirmation => 'Käigu kinnitus';

  @override
  String get preferencesExplainCanThenBeTemporarilyDisabled => 'Can be disabled during a game with the board menu';

  @override
  String get preferencesInCorrespondenceGames => 'Kirjavahetus mängud';

  @override
  String get preferencesCorrespondenceAndUnlimited => 'Kirjavahetus ja piiramatu';

  @override
  String get preferencesConfirmResignationAndDrawOffers => 'Kinnita alistumise ja viigi pakkumised';

  @override
  String get preferencesCastleByMovingTheKingTwoSquaresOrOntoTheRook => 'Vangerdamise meetod';

  @override
  String get preferencesCastleByMovingTwoSquares => 'Liiguta kuningat kaks ruutu';

  @override
  String get preferencesCastleByMovingOntoTheRook => 'Liiguta kuningas vankri peale';

  @override
  String get preferencesInputMovesWithTheKeyboard => 'Sisesta käigud klaviatuuril';

  @override
  String get preferencesInputMovesWithVoice => 'Input moves with your voice';

  @override
  String get preferencesSnapArrowsToValidMoves => 'Liiguta nooled kehtivate käikude juurde';

  @override
  String get preferencesSayGgWpAfterLosingOrDrawing => 'Ütle kaotuse või viigi korral \"Good game, well played\" (Hea mäng, hästi mängitud)';

  @override
  String get preferencesYourPreferencesHaveBeenSaved => 'Teie eelistused on salvestatud.';

  @override
  String get preferencesScrollOnTheBoardToReplayMoves => 'Käikude kordamiseks keri laual';

  @override
  String get preferencesCorrespondenceEmailNotification => 'Igapäevane e-kiri, mis sisaldab pooleliolevaid kirjavahetusmänge';

  @override
  String get preferencesNotifyStreamStart => 'Striimija alustab otseülekannet';

  @override
  String get preferencesNotifyInboxMsg => 'Postkastis on uus sõnum';

  @override
  String get preferencesNotifyForumMention => 'Mainimised foorumis';

  @override
  String get preferencesNotifyInvitedStudy => 'Kutse uuringule';

  @override
  String get preferencesNotifyGameEvent => 'Kirimale mängu uuendused';

  @override
  String get preferencesNotifyChallenge => 'Väljakutsed';

  @override
  String get preferencesNotifyTournamentSoon => 'Turniir algab peatselt';

  @override
  String get preferencesNotifyTimeAlarm => 'Kirimale aeg hakkab lõppema';

  @override
  String get preferencesNotifyBell => 'Lichessi teavitus kellukesega';

  @override
  String get preferencesNotifyPush => 'Mobiiliteavitus, kui oled Lichessist eemal';

  @override
  String get preferencesNotifyWeb => 'Brauser';

  @override
  String get preferencesNotifyDevice => 'Seade';

  @override
  String get preferencesBellNotificationSound => 'Teavituste heli';

  @override
  String get puzzlePuzzles => 'Pusled';

  @override
  String get puzzlePuzzleThemes => 'Pusle teemad';

  @override
  String get puzzleRecommended => 'Soovitame';

  @override
  String get puzzlePhases => 'Etapid';

  @override
  String get puzzleMotifs => 'Motiivid';

  @override
  String get puzzleAdvanced => 'Edasijõudnutele';

  @override
  String get puzzleLengths => 'Pikkused';

  @override
  String get puzzleMates => 'Matid';

  @override
  String get puzzleGoals => 'Eesmärgid';

  @override
  String get puzzleOrigin => 'Allikas';

  @override
  String get puzzleSpecialMoves => 'Erilised käigud';

  @override
  String get puzzleDidYouLikeThisPuzzle => 'Kas sulle meeldis see pusle?';

  @override
  String get puzzleVoteToLoadNextOne => 'Hääleta, nii saad edasi!';

  @override
  String get puzzleUpVote => 'Hääleta poolt';

  @override
  String get puzzleDownVote => 'Hääleta vastu';

  @override
  String get puzzleYourPuzzleRatingWillNotChange => 'Teie pusle reiting ei muutu. Pidage meeles, et pusled ei ole võistlus. Teie reiting aitab valida kõige sobilikumad pusled olenevalt teie oskustele.';

  @override
  String get puzzleFindTheBestMoveForWhite => 'Leia parim käik valgele.';

  @override
  String get puzzleFindTheBestMoveForBlack => 'Leia parim käik mustale.';

  @override
  String get puzzleToGetPersonalizedPuzzles => 'Saa personaalseid puslesid:';

  @override
  String puzzlePuzzleId(String param) {
    return '$param ülesanne';
  }

  @override
  String get puzzlePuzzleOfTheDay => 'Päevaülesanne';

  @override
  String get puzzleDailyPuzzle => 'Päeva pusle';

  @override
  String get puzzleClickToSolve => 'Lahendamiseks vajuta';

  @override
  String get puzzleGoodMove => 'Hea käik';

  @override
  String get puzzleBestMove => 'Parim käik!';

  @override
  String get puzzleKeepGoing => 'Jätka samas vaimus…';

  @override
  String get puzzlePuzzleSuccess => 'Edukas!';

  @override
  String get puzzlePuzzleComplete => 'Pusle lahendatud!';

  @override
  String get puzzleByOpenings => 'By openings';

  @override
  String get puzzlePuzzlesByOpenings => 'Puzzles by openings';

  @override
  String get puzzleOpeningsYouPlayedTheMost => 'Openings you played the most in rated games';

  @override
  String get puzzleUseFindInPage => 'Use \"Find in page\" in the browser menu to find your favourite opening!';

  @override
  String get puzzleUseCtrlF => 'Use Ctrl+f to find your favourite opening!';

  @override
  String get puzzleNotTheMove => 'See ei ole õige käik!';

  @override
  String get puzzleTrySomethingElse => 'Proovi midagi muud.';

  @override
  String puzzleRatingX(String param) {
    return 'Reiting: $param';
  }

  @override
  String get puzzleHidden => 'peidetud';

  @override
  String puzzleFromGameLink(String param) {
    return '$param mängust';
  }

  @override
  String get puzzleContinueTraining => 'Jätka harjutamist';

  @override
  String get puzzleDifficultyLevel => 'Raskusaste';

  @override
  String get puzzleNormal => 'Tavaline';

  @override
  String get puzzleEasier => 'Kerge';

  @override
  String get puzzleEasiest => 'Väga kerge';

  @override
  String get puzzleHarder => 'Raske';

  @override
  String get puzzleHardest => 'Väga raske';

  @override
  String get puzzleExample => 'Näide';

  @override
  String get puzzleAddAnotherTheme => 'Lisa teine teema';

  @override
  String get puzzleNextPuzzle => 'Järgmine pusle';

  @override
  String get puzzleJumpToNextPuzzleImmediately => 'Mine kohe järgmise pusle juurde';

  @override
  String get puzzlePuzzleDashboard => 'Puslepaneel';

  @override
  String get puzzleImprovementAreas => 'Paranda neid';

  @override
  String get puzzleStrengths => 'Tugevused';

  @override
  String get puzzleHistory => 'Puslede ajalugu';

  @override
  String get puzzleSolved => 'lahendatud';

  @override
  String get puzzleFailed => 'ebaõnnestus';

  @override
  String get puzzleStreakDescription => 'Lahenda järjest keerukamaid puslesid ja suurenda oma võitude seeriat. Kella ei ole, seega võta rahulikult. Üks vale samm ja on mäng läbi! Kuid sa võid ühe käigu sessiooni kohta vahele jätta.';

  @override
  String puzzleYourStreakX(String param) {
    return 'Praegune seeria: $param';
  }

  @override
  String get puzzleStreakSkipExplanation => 'Jäta see käik vahele, et säilitada oma seeria! Toimib ainult üks kord sessiooni kohta.';

  @override
  String get puzzleContinueTheStreak => 'Jätka seeriat';

  @override
  String get puzzleNewStreak => 'Uus seeria';

  @override
  String get puzzleFromMyGames => 'Minu mängudest';

  @override
  String get puzzleLookupOfPlayer => 'Otsi puslesid mängija partiidest';

  @override
  String puzzleFromXGames(String param) {
    return 'Pusled $param mängudest';
  }

  @override
  String get puzzleSearchPuzzles => 'Otsi puslesid';

  @override
  String get puzzleFromMyGamesNone => 'Sul ei ole puslesid andmebaasis, aga oled Lichessile ikkagi tähtis.\n\nMängi kiirmalet või klassikalist malet tõstmaks võimalusi, et lisatakse pusle sinu mängust!';

  @override
  String puzzleFromXGamesFound(String param1, String param2) {
    return '$param1 puslet leitud $param2 mängudes';
  }

  @override
  String get puzzlePuzzleDashboardDescription => 'Treeni, analüüsi, täiusta';

  @override
  String puzzlePercentSolved(String param) {
    return '$param lahendatud';
  }

  @override
  String get puzzleNoPuzzlesToShow => 'Midagi pole näidata, lahenda ennem mõned pusled!';

  @override
  String get puzzleImprovementAreasDescription => 'Harjuta neid, et optimeerida oma edusamme!';

  @override
  String get puzzleStrengthDescription => 'Sa lahendad kõige paremini neid teemasid';

  @override
  String puzzlePlayedXTimes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Mängitud $count korda',
      one: 'Mängitud $count kord',
    );
    return '$_temp0';
  }

  @override
  String puzzleNbPointsBelowYourPuzzleRating(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count points below your puzzle rating',
      one: 'One point below your puzzle rating',
    );
    return '$_temp0';
  }

  @override
  String puzzleNbPointsAboveYourPuzzleRating(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count points above your puzzle rating',
      one: 'One point above your puzzle rating',
    );
    return '$_temp0';
  }

  @override
  String puzzleNbPlayed(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count mängitud',
      one: '$count mängitud',
    );
    return '$_temp0';
  }

  @override
  String puzzleNbToReplay(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count kodamiseks',
      one: '$count kodamiseks',
    );
    return '$_temp0';
  }

  @override
  String get puzzleThemeAdvancedPawn => 'Arenenud ettur';

  @override
  String get puzzleThemeAdvancedPawnDescription => 'Üks etturitest on sügaval vastase poolel, võib-olla kohe valmis muunduma.';

  @override
  String get puzzleThemeAdvantage => 'Eelis';

  @override
  String get puzzleThemeAdvantageDescription => 'Haara võimalusest kinni, et saavutada otsustav edu. (200cp ≤ eval ≤ 600cp)';

  @override
  String get puzzleThemeAnastasiaMate => 'Anastasia matt';

  @override
  String get puzzleThemeAnastasiaMateDescription => 'Ratsu ja vanker või lipp teevad koostööd, et panna vastase kuningas lõksu laua ääre ja oma malendi vahele.';

  @override
  String get puzzleThemeArabianMate => 'Araabia matt';

  @override
  String get puzzleThemeArabianMateDescription => 'Ratsu ja vanker teevad koostööd vastase kuninga lõksu saamiseks laua nurgas.';

  @override
  String get puzzleThemeAttackingF2F7 => 'Rünnak f2 või f7';

  @override
  String get puzzleThemeAttackingF2F7Description => 'f2 või f7 etturile suunatud rünnak, sarnaselt fried liver avangule.';

  @override
  String get puzzleThemeAttraction => 'Ahvatlus';

  @override
  String get puzzleThemeAttractionDescription => 'An exchange or sacrifice encouraging or forcing an opponent piece to a square that allows a follow-up tactic.';

  @override
  String get puzzleThemeBackRankMate => 'Tagumise rea matt';

  @override
  String get puzzleThemeBackRankMateDescription => 'Checkmate the king on the home rank, when it is trapped there by its own pieces.';

  @override
  String get puzzleThemeBishopEndgame => 'Odalõppmäng';

  @override
  String get puzzleThemeBishopEndgameDescription => 'Lõppmäng ainult odade ja etturitega.';

  @override
  String get puzzleThemeBodenMate => 'Bodeni matt';

  @override
  String get puzzleThemeBodenMateDescription => 'Kaks ründavat oda ristuvatel diagonaalidel tekitavad matiseisundi kuningale, mille liikumist takistavad omad malendid.';

  @override
  String get puzzleThemeCastling => 'Vangerdus';

  @override
  String get puzzleThemeCastlingDescription => 'Too kuningas ohust eemale ja valmista vanker rünnakuks ette.';

  @override
  String get puzzleThemeCapturingDefender => 'Capture the defender';

  @override
  String get puzzleThemeCapturingDefenderDescription => 'Removing a piece that is critical to defence of another piece, allowing the now undefended piece to be captured on a following move.';

  @override
  String get puzzleThemeCrushing => 'Crushing';

  @override
  String get puzzleThemeCrushingDescription => 'Spot the opponent blunder to obtain a crushing advantage. (eval ≥ 600cp)';

  @override
  String get puzzleThemeDoubleBishopMate => 'Kahe oda matt';

  @override
  String get puzzleThemeDoubleBishopMateDescription => 'Kaks ründavat oda kõrvalistel diagonaalidel tekitavad matiseisundi kuningale, kelle liikumist takistavad omad vigurid.';

  @override
  String get puzzleThemeDovetailMate => 'Cozio matt';

  @override
  String get puzzleThemeDovetailMateDescription => 'A queen delivers mate to an adjacent king, whose only two escape squares are obstructed by friendly pieces.';

  @override
  String get puzzleThemeEquality => 'Võrdsus';

  @override
  String get puzzleThemeEqualityDescription => 'Come back from a losing position, and secure a draw or a balanced position. (eval ≤ 200cp)';

  @override
  String get puzzleThemeKingsideAttack => 'Kuningapoolne rünnak';

  @override
  String get puzzleThemeKingsideAttackDescription => 'Rünnak vastase kuningale pärast vastase vangerdamist kuningapoolele.';

  @override
  String get puzzleThemeClearance => 'Clearance';

  @override
  String get puzzleThemeClearanceDescription => 'A move, often with tempo, that clears a square, file or diagonal for a follow-up tactical idea.';

  @override
  String get puzzleThemeDefensiveMove => 'Kaitsev käik';

  @override
  String get puzzleThemeDefensiveMoveDescription => 'Täpne käik või mitu käiku, mis on vaja vältimaks materiali kaotamist või teist eelist.';

  @override
  String get puzzleThemeDeflection => 'Deflection';

  @override
  String get puzzleThemeDeflectionDescription => 'A move that distracts an opponent piece from another duty that it performs, such as guarding a key square. Sometimes also called \"overloading\".';

  @override
  String get puzzleThemeDiscoveredAttack => 'Discovered attack';

  @override
  String get puzzleThemeDiscoveredAttackDescription => 'Moving a piece (such as a knight), that previously blocked an attack by a long range piece (such as a rook), out of the way of that piece.';

  @override
  String get puzzleThemeDoubleCheck => 'Topelt tuli';

  @override
  String get puzzleThemeDoubleCheckDescription => 'Checking with two pieces at once, as a result of a discovered attack where both the moving piece and the unveiled piece attack the opponent\'s king.';

  @override
  String get puzzleThemeEndgame => 'Lõppmäng';

  @override
  String get puzzleThemeEndgameDescription => 'Taktika mängu viimases faasis.';

  @override
  String get puzzleThemeEnPassantDescription => 'Taktika, kus rakendatakse en passant reeglit, kus ettur saab lüüa mööda läinud vastase etturit kasutades algset kahe ruutu käiku.';

  @override
  String get puzzleThemeExposedKing => 'Paljas kuningas';

  @override
  String get puzzleThemeExposedKingDescription => 'Taktika seoses kuningaga kellel on vähe kaitsjaid enda ümber, lõpeb tihti mattiga.';

  @override
  String get puzzleThemeFork => 'Kahvel';

  @override
  String get puzzleThemeForkDescription => 'Käik, millega mängija ründab oma malendiga korraga mitut vastase malendit.';

  @override
  String get puzzleThemeHangingPiece => 'Kaitseta malend';

  @override
  String get puzzleThemeHangingPieceDescription => 'Taktika, kus vastase malend on kaitsetu või halvasti kaitstud ja tasuta löödav.';

  @override
  String get puzzleThemeHookMate => 'Hook mate';

  @override
  String get puzzleThemeHookMateDescription => 'Checkmate with a rook, knight, and pawn along with one enemy pawn to limit the enemy king\'s escape.';

  @override
  String get puzzleThemeInterference => 'Interference';

  @override
  String get puzzleThemeInterferenceDescription => 'Moving a piece between two opponent pieces to leave one or both opponent pieces undefended, such as a knight on a defended square between two rooks.';

  @override
  String get puzzleThemeIntermezzo => 'Intermezzo';

  @override
  String get puzzleThemeIntermezzoDescription => 'Instead of playing the expected move, first interpose another move posing an immediate threat that the opponent must answer. Also known as \"Zwischenzug\" or \"In between\".';

  @override
  String get puzzleThemeKnightEndgame => 'Ratsulõppmäng';

  @override
  String get puzzleThemeKnightEndgameDescription => 'Lõppmäng ainult ratsude ja etturitega.';

  @override
  String get puzzleThemeLong => 'Pikk ülesanne';

  @override
  String get puzzleThemeLongDescription => 'Kolm käiku võiduni.';

  @override
  String get puzzleThemeMaster => 'Meistrite mängud';

  @override
  String get puzzleThemeMasterDescription => 'Ülesanded mängudest, mida on mänginud tiitlitega mängijad.';

  @override
  String get puzzleThemeMasterVsMaster => 'Meister meistri vastu';

  @override
  String get puzzleThemeMasterVsMasterDescription => 'Ülesanded kahe tiitli saanud mängija vahelistest mängudest.';

  @override
  String get puzzleThemeMate => 'Matt';

  @override
  String get puzzleThemeMateDescription => 'Võida mäng stiiliga.';

  @override
  String get puzzleThemeMateIn1 => 'Matt 1 käiguga';

  @override
  String get puzzleThemeMateIn1Description => 'Soorita matt ühe käiguga.';

  @override
  String get puzzleThemeMateIn2 => 'Matt 2 käiguga';

  @override
  String get puzzleThemeMateIn2Description => 'Soorita matt kahe käiguga.';

  @override
  String get puzzleThemeMateIn3 => 'Matt 3 käiguga';

  @override
  String get puzzleThemeMateIn3Description => 'Soorita matt kolme käiguga.';

  @override
  String get puzzleThemeMateIn4 => 'Matt 4 käiguga';

  @override
  String get puzzleThemeMateIn4Description => 'Soorita matt nelja käiguga.';

  @override
  String get puzzleThemeMateIn5 => 'Matt 5+ käiguga';

  @override
  String get puzzleThemeMateIn5Description => 'Leia mitme käiguga matt.';

  @override
  String get puzzleThemeMiddlegame => 'Keskmäng';

  @override
  String get puzzleThemeMiddlegameDescription => 'Taktika mängu teises faasis.';

  @override
  String get puzzleThemeOneMove => 'Ühekäiguline ülesanne';

  @override
  String get puzzleThemeOneMoveDescription => 'Ülesanne, mille lahendamiseks on vaja ainult ühte liigutust.';

  @override
  String get puzzleThemeOpening => 'Avang';

  @override
  String get puzzleThemeOpeningDescription => 'Taktika mängu esimeses faasis.';

  @override
  String get puzzleThemePawnEndgame => 'Etturilõppmäng';

  @override
  String get puzzleThemePawnEndgameDescription => 'Lõppmäng ainult etturitega.';

  @override
  String get puzzleThemePin => 'Sidumine';

  @override
  String get puzzleThemePinDescription => 'Taktika, kus malendi tulejoonel oleva vastaspoole malend ei saa liikuda, sest ära liikumise korral satub tulejoone alla väärtuslikum malend.';

  @override
  String get puzzleThemePromotion => 'Muundamine';

  @override
  String get puzzleThemePromotionDescription => 'Muunda oma ettur lipuks või teiseks viguriks.';

  @override
  String get puzzleThemeQueenEndgame => 'Lipulõppmäng';

  @override
  String get puzzleThemeQueenEndgameDescription => 'Lõppmäng ainult lippude ja etturitega.';

  @override
  String get puzzleThemeQueenRookEndgame => 'Lipp ja vanker';

  @override
  String get puzzleThemeQueenRookEndgameDescription => 'Lõppmäng ainult lippude, vankrite ja etturitega.';

  @override
  String get puzzleThemeQueensideAttack => 'Lipupoolne rünnak';

  @override
  String get puzzleThemeQueensideAttackDescription => 'Rünnak vastase kuningale pärast vastase vangerdamist lipupoolele.';

  @override
  String get puzzleThemeQuietMove => 'Quiet move';

  @override
  String get puzzleThemeQuietMoveDescription => 'A move that does neither make a check or capture, nor an immediate threat to capture, but does prepare a more hidden unavoidable threat for a later move.';

  @override
  String get puzzleThemeRookEndgame => 'Vankrilõppmäng';

  @override
  String get puzzleThemeRookEndgameDescription => 'Lõppmäng ainult vankrite ja etturitega.';

  @override
  String get puzzleThemeSacrifice => 'Ohverdus';

  @override
  String get puzzleThemeSacrificeDescription => 'Taktika, mis põhineb malendi äraandmisel. Eesmärk on saavutada eelis mõne sunnitud käigu järel.';

  @override
  String get puzzleThemeShort => 'Lühike ülesanne';

  @override
  String get puzzleThemeShortDescription => 'Kaks käiku võiduni.';

  @override
  String get puzzleThemeSkewer => 'Tagurpidisidumine';

  @override
  String get puzzleThemeSkewerDescription => 'A motif involving a high value piece being attacked, moving out the way, and allowing a lower value piece behind it to be captured or attacked, the inverse of a pin.';

  @override
  String get puzzleThemeSmotheredMate => 'Umbmatt';

  @override
  String get puzzleThemeSmotheredMateDescription => 'A checkmate delivered by a knight in which the mated king is unable to move because it is surrounded (or smothered) by its own pieces.';

  @override
  String get puzzleThemeSuperGM => 'Supersuurmeistrite mängud';

  @override
  String get puzzleThemeSuperGMDescription => 'Ülesanded mängudest maailma parimate mängijate vahel.';

  @override
  String get puzzleThemeTrappedPiece => 'Lõksus malend';

  @override
  String get puzzleThemeTrappedPieceDescription => 'A piece is unable to escape capture as it has limited moves.';

  @override
  String get puzzleThemeUnderPromotion => 'Underpromotion';

  @override
  String get puzzleThemeUnderPromotionDescription => 'Promotion to a knight, bishop, or rook.';

  @override
  String get puzzleThemeVeryLong => 'Väga pikk ülesanne';

  @override
  String get puzzleThemeVeryLongDescription => 'Four moves or more to win.';

  @override
  String get puzzleThemeXRayAttack => 'X-Ray attack';

  @override
  String get puzzleThemeXRayAttackDescription => 'A piece attacks or defends a square, through an enemy piece.';

  @override
  String get puzzleThemeZugzwang => 'Vahekäik';

  @override
  String get puzzleThemeZugzwangDescription => 'Vastasel on piiratud võimalused teha lubatud käike ja kõik halvendavad vastase olukorda.';

  @override
  String get puzzleThemeHealthyMix => 'Tervislik segu';

  @override
  String get puzzleThemeHealthyMixDescription => 'Natuke kõike. Kunagi ei tea mida oodata ehk ole valmis kõigeks! Täpselt nagu päris mängudes.';

  @override
  String get puzzleThemePlayerGames => 'Player games';

  @override
  String get puzzleThemePlayerGamesDescription => 'Lookup puzzles generated from your games, or from another player\'s games.';

  @override
  String puzzleThemePuzzleDownloadInformation(String param) {
    return 'These puzzles are in the public domain, and can be downloaded from $param.';
  }

  @override
  String get searchSearch => 'Otsi';

  @override
  String get settingsSettings => 'Seaded';

  @override
  String get settingsCloseAccount => 'Sulge konto';

  @override
  String get settingsManagedAccountCannotBeClosed => 'Sinu konto on valve all ja seda ei saa sulgeda.';

  @override
  String get settingsClosingIsDefinitive => 'Sulgemist ei saa tagasi võtta. Oled sa kindel?';

  @override
  String get settingsCantOpenSimilarAccount => 'Uut samanimelist kontot ei saa luua, isegi kui sümbolite register on erinev.';

  @override
  String get settingsChangedMindDoNotCloseAccount => 'Ma muutsin meelt, ärge sulgege kontot';

  @override
  String get settingsCloseAccountExplanation => 'Kas olete kindel, et soovite oma konto sulgeda? Konto sulgemine on pöördumatu. Sellesse EI SAA ENAM KUNAGI siseneda.';

  @override
  String get settingsThisAccountIsClosed => 'See konto on suletud.';

  @override
  String get playWithAFriend => 'Mängi sõbraga';

  @override
  String get playWithTheMachine => 'Mängi arvuti vastu';

  @override
  String get toInviteSomeoneToPlayGiveThisUrl => 'Et kutsuda kedagi mängima, anna talle see URL';

  @override
  String get gameOver => 'Mäng läbi';

  @override
  String get waitingForOpponent => 'Ootan vastast';

  @override
  String get orLetYourOpponentScanQrCode => 'Or let your opponent scan this QR code';

  @override
  String get waiting => 'Ootan vastust';

  @override
  String get yourTurn => 'Sinu käik';

  @override
  String aiNameLevelAiLevel(String param1, String param2) {
    return '$param1 tase $param2';
  }

  @override
  String get level => 'Tase';

  @override
  String get strength => 'Tugevus';

  @override
  String get toggleTheChat => 'Luba vestlust';

  @override
  String get chat => 'Saada sõnum';

  @override
  String get resign => 'Alistu';

  @override
  String get checkmate => 'Matt';

  @override
  String get stalemate => 'Patt';

  @override
  String get white => 'Valge';

  @override
  String get black => 'Must';

  @override
  String get asWhite => 'valgena';

  @override
  String get asBlack => 'mustana';

  @override
  String get randomColor => 'Juhuslik värv';

  @override
  String get createAGame => 'Loo mäng';

  @override
  String get whiteIsVictorious => 'Võitis valge';

  @override
  String get blackIsVictorious => 'Võitis must';

  @override
  String get youPlayTheWhitePieces => 'Sa mängid valgete malenditega';

  @override
  String get youPlayTheBlackPieces => 'Sa mängid mustade malenditega';

  @override
  String get itsYourTurn => 'Sinu kord!';

  @override
  String get cheatDetected => 'Sohk tuvastatud';

  @override
  String get kingInTheCenter => 'Kuningas jõudis keskele';

  @override
  String get threeChecks => 'Kolm tuld';

  @override
  String get raceFinished => 'Võiduajamine lõpetatud';

  @override
  String get variantEnding => 'Variandi lõpp';

  @override
  String get newOpponent => 'Uus vastane';

  @override
  String get yourOpponentWantsToPlayANewGameWithYou => 'Sinu vastane soovib mängida sinuga uut mängu';

  @override
  String get joinTheGame => 'Ühine mänguga';

  @override
  String get whitePlays => 'Valge mängib';

  @override
  String get blackPlays => 'Must mängib';

  @override
  String get opponentLeftChoices => 'Vastane on lahkunud mängust. Võid sundida mängijat alistuma või ootadata.';

  @override
  String get forceResignation => 'Sunni alistuma';

  @override
  String get forceDraw => 'Sunni viiki';

  @override
  String get talkInChat => 'Palun käitu vestluses viisakalt!';

  @override
  String get theFirstPersonToComeOnThisUrlWillPlayWithYou => 'Esimene inimene kes selle URLi peale tuleb, mängib sinuga.';

  @override
  String get whiteResigned => 'Valge alistus';

  @override
  String get blackResigned => 'Must alistus';

  @override
  String get whiteLeftTheGame => 'Valge lahkus mängust';

  @override
  String get blackLeftTheGame => 'Must lahkus mängust';

  @override
  String get whiteDidntMove => 'Valge ei sooritanud käiku';

  @override
  String get blackDidntMove => 'Must ei sooritanud käiku';

  @override
  String get requestAComputerAnalysis => 'Nõua arvuti analüüsi';

  @override
  String get computerAnalysis => 'Arvuti analüüs';

  @override
  String get computerAnalysisAvailable => 'Arvuti analüüs saadaval';

  @override
  String get computerAnalysisDisabled => 'Arvutianalüüs keelatud';

  @override
  String get analysis => 'Analüüs';

  @override
  String depthX(String param) {
    return 'Käik number $param';
  }

  @override
  String get usingServerAnalysis => 'Kasutusel serveri analüüs';

  @override
  String get loadingEngine => 'Laen analüüsi...';

  @override
  String get calculatingMoves => 'Käikude arvutamine...';

  @override
  String get engineFailed => 'Arvuti laadimine ebaõnnestus';

  @override
  String get cloudAnalysis => 'Pilve analüüs';

  @override
  String get goDeeper => 'Vaata põhjalikumalt';

  @override
  String get showThreat => 'Näita ohtu';

  @override
  String get inLocalBrowser => 'Kohalikus veebis';

  @override
  String get toggleLocalEvaluation => 'Lülita kohalik hindamine';

  @override
  String get promoteVariation => 'Edenda varient';

  @override
  String get makeMainLine => 'Tee põhiliiniks';

  @override
  String get deleteFromHere => 'Kustuta alates siit';

  @override
  String get collapseVariations => 'Collapse variations';

  @override
  String get expandVariations => 'Expand variations';

  @override
  String get forceVariation => 'Tee variatsiooniks';

  @override
  String get copyVariationPgn => 'Copy variation PGN';

  @override
  String get move => 'Käik';

  @override
  String get variantLoss => 'Variandi kaotus';

  @override
  String get variantWin => 'Variant võidab';

  @override
  String get insufficientMaterial => 'Pole piisavalt materjali';

  @override
  String get pawnMove => 'Etturi käik';

  @override
  String get capture => 'Võta';

  @override
  String get close => 'Sulge';

  @override
  String get winning => 'Võidab';

  @override
  String get losing => 'Kaotav';

  @override
  String get drawn => 'Viik';

  @override
  String get unknown => 'Teadmatu';

  @override
  String get database => 'Andmebaas';

  @override
  String get whiteDrawBlack => 'Valge / Viik / Must';

  @override
  String averageRatingX(String param) {
    return 'Keskmine reiting: $param';
  }

  @override
  String get recentGames => 'Hiljutised mängud';

  @override
  String get topGames => 'Parimad mängud';

  @override
  String masterDbExplanation(String param1, String param2, String param3) {
    return 'Kaks miljonit päriselumängu $param1+ FIDE hinnatud mängijat alates $param2 kuni $param3';
  }

  @override
  String get dtzWithRounding => 'DTZ50\'\' ümardatult, põhineb poolkäikude arvul kuni järgmise löögi või etturi käiguni';

  @override
  String get noGameFound => 'Ühtegi mängu ei leitud';

  @override
  String get maxDepthReached => 'Max depth reached!';

  @override
  String get maybeIncludeMoreGamesFromThePreferencesMenu => 'Kas kaasata eelistuste menüüst rohkem mänge?';

  @override
  String get openings => 'Avangud';

  @override
  String get openingExplorer => 'Avamiste otsija';

  @override
  String get openingEndgameExplorer => 'Avangu/lõppmängu uurija';

  @override
  String xOpeningExplorer(String param) {
    return '$param avamiste otsija';
  }

  @override
  String get playFirstOpeningEndgameExplorerMove => 'Play first opening/endgame-explorer move';

  @override
  String get winPreventedBy50MoveRule => '50 käigu reegel ei lase võita';

  @override
  String get lossSavedBy50MoveRule => '50 käigu reegel päästis kaotusest';

  @override
  String get winOr50MovesByPriorMistake => 'Võit või 50 käiku eelneva vea tõttu';

  @override
  String get lossOr50MovesByPriorMistake => 'Kaotus või 50 käiku eelneva vea tõttu';

  @override
  String get unknownDueToRounding => 'Võit/kaotus on tagatud ainult siis, kui on järgitud andmebaasi soovitatud käikude järjekorda alates viimasest löömisest või etturi käigust, sest Syzygy andmebaaside DTZ väärtused võivad olla ümardatud.';

  @override
  String get allSet => 'Valmis!';

  @override
  String get importPgn => 'Impordi PGN';

  @override
  String get delete => 'Kustuta';

  @override
  String get deleteThisImportedGame => 'Kustuta imporditud mäng?';

  @override
  String get replayMode => 'Kordusrežiim';

  @override
  String get realtimeReplay => 'Reaalajas';

  @override
  String get byCPL => 'CPL järgi';

  @override
  String get openStudy => 'Ava uuring';

  @override
  String get enable => 'Luba';

  @override
  String get bestMoveArrow => 'Parima käigu nool';

  @override
  String get showVariationArrows => 'Show variation arrows';

  @override
  String get evaluationGauge => 'Hinnangunäidik';

  @override
  String get multipleLines => 'Mitu liini';

  @override
  String get cpus => 'CPU-d';

  @override
  String get memory => 'Mälu';

  @override
  String get infiniteAnalysis => 'Lõputu analüüs';

  @override
  String get removesTheDepthLimit => 'Eemaldab sügavuslimiidi ja hoiab arvuti soojana';

  @override
  String get engineManager => 'Engine manager';

  @override
  String get blunder => 'Viga';

  @override
  String get mistake => 'Eksimus';

  @override
  String get inaccuracy => 'Ebatäpsus';

  @override
  String get moveTimes => 'Aeg käigu tegemisel';

  @override
  String get flipBoard => 'Keera lauda';

  @override
  String get threefoldRepetition => 'Kolmekordne kordus';

  @override
  String get claimADraw => 'Võta viik';

  @override
  String get offerDraw => 'Paku viiki';

  @override
  String get draw => 'Viik';

  @override
  String get drawByMutualAgreement => 'Viik kokkuleppel';

  @override
  String get fiftyMovesWithoutProgress => '50 käiku ilma edusammudeta';

  @override
  String get currentGames => 'Hetkel mängitavad mängud';

  @override
  String get viewInFullSize => 'Vaata täisekraanil';

  @override
  String get logOut => 'Logi välja';

  @override
  String get signIn => 'Logi sisse';

  @override
  String get rememberMe => 'Jää sisselogituks';

  @override
  String get youNeedAnAccountToDoThat => 'Sa vajad kasutajat, et seda teha';

  @override
  String get signUp => 'Registreeri';

  @override
  String get computersAreNotAllowedToPlay => 'Arvutid ja arvutiabi kasutavad mängijad on keelatud mängimast. Palun ära kasuta mängides maleprogrammide, andmebaaside ja teiste mängijate abi. Mitme kasutaja tegemine on ebasoositud ja räige mitme kasutaja kasutamine võib lõppeda kasutaja kinnipanemisega.';

  @override
  String get games => 'Mängud';

  @override
  String get forum => 'Foorum';

  @override
  String xPostedInForumY(String param1, String param2) {
    return '$param1 postitas teemasse $param2';
  }

  @override
  String get latestForumPosts => 'Viimased foorumi postitused';

  @override
  String get players => 'Maletajad';

  @override
  String get friends => 'Sõbrad';

  @override
  String get discussions => 'Vestlused';

  @override
  String get today => 'Täna';

  @override
  String get yesterday => 'Eile';

  @override
  String get minutesPerSide => 'Minutit poole kohta';

  @override
  String get variant => 'Variant';

  @override
  String get variants => 'variandid';

  @override
  String get timeControl => 'Aja kontroll';

  @override
  String get realTime => 'Reaalajas';

  @override
  String get correspondence => 'Kirimale';

  @override
  String get daysPerTurn => 'Päevi käiguks';

  @override
  String get oneDay => 'Üks päev';

  @override
  String get time => 'Aeg';

  @override
  String get rating => 'Reiting';

  @override
  String get ratingStats => 'Reitingu statistika';

  @override
  String get username => 'Kasutaja nimi';

  @override
  String get usernameOrEmail => 'Kasutajanimi või email';

  @override
  String get changeUsername => 'Muuda kasutajanime';

  @override
  String get changeUsernameNotSame => 'Muuta saab ainult tähe suurust. Näiteks \"karlsuur\" ja \"KarlSuur\".';

  @override
  String get changeUsernameDescription => 'Muuda kasutajanime. Seda saad teha ainult korra ning muuta on võimalik ainult kasutajanimes leiduvate tähtede suurust.';

  @override
  String get signupUsernameHint => 'Vali kasutajanimi mis oleks kõigile sobilik, isegi lastele. Seda ei saa hiljem muuta, ning kõik sobimatute nimedega kontod suletakse!';

  @override
  String get signupEmailHint => 'Seda kasutatakse ainult parooli lähtestamiseks.';

  @override
  String get password => 'Parool';

  @override
  String get changePassword => 'Muuda parooli';

  @override
  String get changeEmail => 'Muuda email';

  @override
  String get email => 'Email';

  @override
  String get passwordReset => 'Parooli lähtestamine';

  @override
  String get forgotPassword => 'Unustasid parooli?';

  @override
  String get error_weakPassword => 'See parool on väga levinud ning liiga lihtne arvata.';

  @override
  String get error_namePassword => 'Palun ära kasuta oma kasutajanime paroolina.';

  @override
  String get blankedPassword => 'Olete kasutanud sama parooli mõnel teisel kompromiseeritud lehel. Teie Lichess konto turvalisuse kaitsmiseks palume teil seada uus parool. Tänan mõistva suhtumise eest.';

  @override
  String get youAreLeavingLichess => 'Lahkud Lichessist';

  @override
  String get neverTypeYourPassword => 'Ära kirjuta oma Lichessi parooli teisele leheküljele!';

  @override
  String proceedToX(String param) {
    return 'Proceed to $param';
  }

  @override
  String get passwordSuggestion => 'Ära kasuta kellegi teise poolt soovitatud parooli. Nad võivad su konto kaaperdada.';

  @override
  String get emailSuggestion => 'Ära kasuta kellegi teise poolt soovitatud e-maili aadressi. Nad võivad su konto kaaperdada.';

  @override
  String get emailConfirmHelp => 'Abi emaili kinnitamisega';

  @override
  String get emailConfirmNotReceived => 'Ei saanud pärast registreerumist kinnitust?';

  @override
  String get whatSignupUsername => 'Mis kasutajanime registreerimisel kasutasid?';

  @override
  String usernameNotFound(String param) {
    return 'Ei suutnud leida kasutajat nimega $param.';
  }

  @override
  String get usernameCanBeUsedForNewAccount => 'Seda kasutajanime saab kasutada uue konto loomisel';

  @override
  String emailSent(String param) {
    return 'Saatsime kirja aadressile $param.';
  }

  @override
  String get emailCanTakeSomeTime => 'Sellega võib minna mõni hetk aega.';

  @override
  String get refreshInboxAfterFiveMinutes => 'Oodake 5 minutit ja värskendage postkasti.';

  @override
  String get checkSpamFolder => 'Kiri võib sattuda ka rämpsposti kausta. Sel juhul palun märkige see mitte rämpspostina.';

  @override
  String get emailForSignupHelp => 'Kui kõik muu ei õnnestu, saatke meile see e-kiri:';

  @override
  String copyTextToEmail(String param) {
    return 'Kopeerige ülaltoodud tekst ja saatke see aadressile $param';
  }

  @override
  String get waitForSignupHelp => 'Me võtame teiega peagi ühendust, et aidata teil registreerimist lõpule viia.';

  @override
  String accountConfirmed(String param) {
    return 'Kasutaja $param on edukalt kinnitatud.';
  }

  @override
  String accountCanLogin(String param) {
    return 'Saate praegu sisse logida kui $param.';
  }

  @override
  String get accountConfirmationEmailNotNeeded => 'Te ei vaja kinnitusmeili.';

  @override
  String accountClosed(String param) {
    return 'Konto $param on suletud.';
  }

  @override
  String accountRegisteredWithoutEmail(String param) {
    return 'Konto $param registreeriti ilma e-posti aadressita.';
  }

  @override
  String get rank => 'Koht';

  @override
  String rankX(String param) {
    return 'Koht: $param';
  }

  @override
  String get gamesPlayed => 'Mänge mängitud';

  @override
  String get cancel => 'Katkesta';

  @override
  String get whiteTimeOut => 'Valge aeg sai läbi';

  @override
  String get blackTimeOut => 'Musta aeg sai läbi';

  @override
  String get drawOfferSent => 'Viigi pakkumine saadetud';

  @override
  String get drawOfferAccepted => 'Viigi pakkumine vastu võetud';

  @override
  String get drawOfferCanceled => 'Viigi pakkumine tühistatud';

  @override
  String get whiteOffersDraw => 'Valge pakub viiki';

  @override
  String get blackOffersDraw => 'Must pakub viiki';

  @override
  String get whiteDeclinesDraw => 'Valge keeldub viigist';

  @override
  String get blackDeclinesDraw => 'Must keeldub viigist';

  @override
  String get yourOpponentOffersADraw => 'Su vastane pakub viiki';

  @override
  String get accept => 'Nõustu';

  @override
  String get decline => 'Keeldu';

  @override
  String get playingRightNow => 'Mängimas praegu';

  @override
  String get eventInProgress => 'Praegu mängimas';

  @override
  String get finished => 'Lõpetatud';

  @override
  String get abortGame => 'Katkesta mäng';

  @override
  String get gameAborted => 'Mäng katkestatud';

  @override
  String get standard => 'Standard';

  @override
  String get customPosition => 'Custom position';

  @override
  String get unlimited => 'Piiramatu';

  @override
  String get mode => 'Variant';

  @override
  String get casual => 'Reitinguta';

  @override
  String get rated => 'Reitinguga';

  @override
  String get casualTournament => 'Reitinguta';

  @override
  String get ratedTournament => 'Reitinguga';

  @override
  String get thisGameIsRated => 'See mäng on reitinguga';

  @override
  String get rematch => 'Kordusmäng';

  @override
  String get rematchOfferSent => 'Kordusmängu pakkumine';

  @override
  String get rematchOfferAccepted => 'Kordusmäng vastu võetud';

  @override
  String get rematchOfferCanceled => 'Kordusmängu pakkumine tühistatud';

  @override
  String get rematchOfferDeclined => 'Kordusmäng tagasilükatud';

  @override
  String get cancelRematchOffer => 'Tühista kordusmängu pakkumine';

  @override
  String get viewRematch => 'Vaata kordusmängu';

  @override
  String get confirmMove => 'Kinnita käik';

  @override
  String get play => 'Mängi';

  @override
  String get inbox => 'Postkast';

  @override
  String get chatRoom => 'Jututuba';

  @override
  String get loginToChat => 'Vestlemiseks logi sisse';

  @override
  String get youHaveBeenTimedOut => 'Olete välja logitud.';

  @override
  String get spectatorRoom => 'Pealtvaatajate tuba';

  @override
  String get composeMessage => 'Koosta sõnum';

  @override
  String get subject => 'Teema';

  @override
  String get send => 'Saada';

  @override
  String get incrementInSeconds => 'Lisatavad sekundid';

  @override
  String get freeOnlineChess => 'Tasuta interneti male';

  @override
  String get exportGames => 'Ekspordi mängud';

  @override
  String get ratingRange => 'Reitingu vahemik';

  @override
  String get thisAccountViolatedTos => 'Selle konto kasutaja rikkus Lichessi teenusetingimusi';

  @override
  String get openingExplorerAndTablebase => 'Avangute uurija & lõppmängude andmebaas';

  @override
  String get takeback => 'Tagasivõtt';

  @override
  String get proposeATakeback => 'Paku tagasivõttu';

  @override
  String get takebackPropositionSent => 'Tagasivõtu ettepanek esitatud';

  @override
  String get takebackPropositionDeclined => 'Tagasivõtu ettepanekust keeldumine';

  @override
  String get takebackPropositionAccepted => 'Tagasivõtu ettepanek vastuvõetud';

  @override
  String get takebackPropositionCanceled => 'Tagasivõtu ettepanek tühistatud';

  @override
  String get yourOpponentProposesATakeback => 'Vastane teeb ettepaneku tagasivõtuks';

  @override
  String get bookmarkThisGame => 'Lisa see mäng järjehoidjasse';

  @override
  String get tournament => 'Turniir';

  @override
  String get tournaments => 'Turniirid';

  @override
  String get tournamentPoints => 'Turniiri punktid';

  @override
  String get viewTournament => 'Vaata turniiri';

  @override
  String get backToTournament => 'Tagasi turniirile';

  @override
  String get noDrawBeforeSwissLimit => 'You cannot draw before 30 moves are played in a Swiss tournament.';

  @override
  String get thematic => 'Temaatiline';

  @override
  String yourPerfRatingIsProvisional(String param) {
    return 'Teie $param reiting on liiga madal/kõrge';
  }

  @override
  String yourPerfRatingIsTooHigh(String param1, String param2) {
    return 'Teie $param1 reiting ($param2) on liiga kõrge';
  }

  @override
  String yourTopWeeklyPerfRatingIsTooHigh(String param1, String param2) {
    return 'Teie parim nädalane $param1 reiting ($param2) on liiga kõrge';
  }

  @override
  String yourPerfRatingIsTooLow(String param1, String param2) {
    return 'Teie $param1 reiting ($param2) on liiga madal';
  }

  @override
  String ratedMoreThanInPerf(String param1, String param2) {
    return 'Reiting ≥ $param1 $param2';
  }

  @override
  String ratedLessThanInPerf(String param1, String param2) {
    return 'Reiting ≤ $param1 $param2';
  }

  @override
  String mustBeInTeam(String param) {
    return 'Sa pead olema $param tiimis';
  }

  @override
  String youAreNotInTeam(String param) {
    return 'Sa ei ole $param tiimi liige';
  }

  @override
  String get backToGame => 'Tagasi mängu';

  @override
  String get siteDescription => 'Tasuta online male. Mängi malet nüüd puhtas kasutajaliideses. Pole registreerimist, pole reklaami, pole pluginaid vaja. Mängi malet arvuti, sõprade või juhusliku vastasega.';

  @override
  String xJoinedTeamY(String param1, String param2) {
    return '$param1 liitus võistkonnaga $param2';
  }

  @override
  String xCreatedTeamY(String param1, String param2) {
    return '$param1 tegi tiimi $param2';
  }

  @override
  String get startedStreaming => 'alustas otseülekannet';

  @override
  String xStartedStreaming(String param) {
    return '$param alustas otseülekannet';
  }

  @override
  String get averageElo => 'Keskmine Elo';

  @override
  String get location => 'Asukoht';

  @override
  String get filterGames => 'Filtreeri mänge';

  @override
  String get reset => 'Lähtesta';

  @override
  String get apply => 'Rakenda';

  @override
  String get save => 'Salvesta';

  @override
  String get leaderboard => 'Edetabel';

  @override
  String get screenshotCurrentPosition => 'Tee kuvatõmmis praegusest seisust';

  @override
  String get gameAsGIF => 'Salvesta mäng GIF-ina';

  @override
  String get pasteTheFenStringHere => 'Aseta FEN kood siia';

  @override
  String get pasteThePgnStringHere => 'Aseta PGN kood siia';

  @override
  String get orUploadPgnFile => 'Või lae üles PGN fail';

  @override
  String get fromPosition => 'Positsioonilt';

  @override
  String get continueFromHere => 'Jätka siit';

  @override
  String get toStudy => 'Uuri';

  @override
  String get importGame => 'Impordi mäng';

  @override
  String get importGameExplanation => 'Mängu PGN-i kleepimisel saate vaadeldava korduse,\narvutianalüüsi, mängu jututoa ning jagatava URL-i.';

  @override
  String get importGameCaveat => 'Variations will be erased. To keep them, import the PGN via a study.';

  @override
  String get importGameDataPrivacyWarning => 'This PGN can be accessed by the public. To import a game privately, use a study.';

  @override
  String get thisIsAChessCaptcha => 'See on male CAPTCHA';

  @override
  String get clickOnTheBoardToMakeYourMove => 'Tee käik ja tõesta, et oled inimene.';

  @override
  String get captcha_fail => 'Palun lahendage male robotilõks.';

  @override
  String get notACheckmate => 'See pole matt';

  @override
  String get whiteCheckmatesInOneMove => 'Valge teeb mati ühe käiguga';

  @override
  String get blackCheckmatesInOneMove => 'Must teeb mati ühe käiguga';

  @override
  String get retry => 'Proovi uuesti';

  @override
  String get reconnecting => 'Taasühendamine';

  @override
  String get noNetwork => 'Offline';

  @override
  String get favoriteOpponents => 'Lemmikvastased';

  @override
  String get follow => 'Jälgi';

  @override
  String get following => 'Jälgitakse';

  @override
  String get unfollow => 'Lõpeta jälgimine';

  @override
  String followX(String param) {
    return 'Jälgi $param';
  }

  @override
  String unfollowX(String param) {
    return 'Lõpeta $param jälgimine';
  }

  @override
  String get block => 'Blokeeri';

  @override
  String get blocked => 'Blokeeritud';

  @override
  String get unblock => 'Tühista blokeering';

  @override
  String get followsYou => 'Jälgib sind';

  @override
  String xStartedFollowingY(String param1, String param2) {
    return '$param1 hakkas jälgima $param2';
  }

  @override
  String get more => 'Rohkem';

  @override
  String get memberSince => 'Liitunud';

  @override
  String lastSeenActive(String param) {
    return 'Viimati nähtud $param';
  }

  @override
  String get player => 'Mängija';

  @override
  String get list => 'Nimekiri';

  @override
  String get graph => 'Graafik';

  @override
  String get required => 'Nõutud';

  @override
  String get openTournaments => 'Avatud turniirid';

  @override
  String get duration => 'Kestvus';

  @override
  String get winner => 'Võitja';

  @override
  String get standing => 'Tulemus';

  @override
  String get createANewTournament => 'Loo uus turniir';

  @override
  String get tournamentCalendar => 'Turniiride kalender';

  @override
  String get conditionOfEntry => 'Sisenemise tingimus:';

  @override
  String get advancedSettings => 'Täpsemad seaded';

  @override
  String get safeTournamentName => 'Vali turniirile sobiv nimi.';

  @override
  String get inappropriateNameWarning => 'Isegi pisut kohatu nimi võib tähendada sinu konto sulgemist.';

  @override
  String get emptyTournamentName => 'Jäta tühjaks, et nimetada turniir juhusliku suurmeistri järgi.';

  @override
  String get makePrivateTournament => 'Tee turniir privaatseks ja piira juurdepääsu parooliga';

  @override
  String get join => 'Liitu';

  @override
  String get withdraw => 'Loobu';

  @override
  String get points => 'Punktid';

  @override
  String get wins => 'Võidud';

  @override
  String get losses => 'Kaotused';

  @override
  String get createdBy => 'Loodud';

  @override
  String get tournamentIsStarting => 'Turniir algab';

  @override
  String get tournamentPairingsAreNowClosed => 'Turniiri paaride loomine on nüüd lõppenud.';

  @override
  String standByX(String param) {
    return 'Palun oodake $param, loome mängijate paare, olge valmis!';
  }

  @override
  String get pause => 'Peata';

  @override
  String get resume => 'Jätka';

  @override
  String get youArePlaying => 'Te mängite!';

  @override
  String get winRate => 'Võidumäär';

  @override
  String get berserkRate => 'Berserk määr';

  @override
  String get performance => 'Sooritus';

  @override
  String get tournamentComplete => 'Turniir lõppenud';

  @override
  String get movesPlayed => 'Tehtud käikude arv';

  @override
  String get whiteWins => 'Valge võite';

  @override
  String get blackWins => 'Musta võite';

  @override
  String get drawRate => 'Draw rate';

  @override
  String get draws => 'Viike';

  @override
  String nextXTournament(String param) {
    return 'Järgmine $param turniir:';
  }

  @override
  String get averageOpponent => 'Keskmine vastane';

  @override
  String get boardEditor => 'Muudetav laud';

  @override
  String get setTheBoard => 'Seadista lauda';

  @override
  String get popularOpenings => 'Populaarsed avangud';

  @override
  String get endgamePositions => 'Lõppmängu seisud';

  @override
  String chess960StartPosition(String param) {
    return 'Male960 algpositsioon: $param';
  }

  @override
  String get startPosition => 'Algseis';

  @override
  String get clearBoard => 'Puhasta laud';

  @override
  String get loadPosition => 'Lae seis';

  @override
  String get isPrivate => 'Privaatne';

  @override
  String reportXToModerators(String param) {
    return 'Teata kasutajast $param moderaatoritele';
  }

  @override
  String profileCompletion(String param) {
    return 'Profiili täidetud: $param';
  }

  @override
  String xRating(String param) {
    return '$param reiting';
  }

  @override
  String get ifNoneLeaveEmpty => 'Kui pole, jäta tühjaks';

  @override
  String get profile => 'Profiil';

  @override
  String get editProfile => 'Muuda profiili';

  @override
  String get realName => 'Real name';

  @override
  String get setFlair => 'Set your flair';

  @override
  String get flair => 'Flair';

  @override
  String get youCanHideFlair => 'There is a setting to hide all user flairs across the entire site.';

  @override
  String get biography => 'Kirjeldus';

  @override
  String get countryRegion => 'Country or region';

  @override
  String get thankYou => 'Aitäh!';

  @override
  String get socialMediaLinks => 'Sotsiaalmeedia lingid';

  @override
  String get oneUrlPerLine => 'Üks URL iga rea kohta.';

  @override
  String get inlineNotation => 'Tekstisisene notatsioon';

  @override
  String get makeAStudy => 'Hoiustamiseks ja jagamiseks kaalutle uuringu koostamist.';

  @override
  String get clearSavedMoves => 'Tühista käigud';

  @override
  String get previouslyOnLichessTV => 'Eelnevalt Lichess TV-s';

  @override
  String get onlinePlayers => 'Mängijad kohal';

  @override
  String get activePlayers => 'Aktiivsed mängijad';

  @override
  String get bewareTheGameIsRatedButHasNoClock => 'Tähelepanu, mäng on reitinguga aga ajakontrollita!';

  @override
  String get success => 'Edukas';

  @override
  String get automaticallyProceedToNextGameAfterMoving => 'Liigu automaatselt järgmise mängu juurde pärast käiku';

  @override
  String get autoSwitch => 'Automaatne siirdumine';

  @override
  String get puzzles => 'Pusled';

  @override
  String get onlineBots => 'Online bots';

  @override
  String get name => 'Nimi';

  @override
  String get description => 'Kirjeldus';

  @override
  String get descPrivate => 'Privaatne kirjeldus';

  @override
  String get descPrivateHelp => 'Tekst mida näevad ainult võistkonna liikmed. Kui on valitud siis asendatakse avalik kirjeldus võistkonna liikmetele.';

  @override
  String get no => 'Ei';

  @override
  String get yes => 'Jah';

  @override
  String get help => 'Abi:';

  @override
  String get createANewTopic => 'Loo uus teema';

  @override
  String get topics => 'Teemad';

  @override
  String get posts => 'Postitused';

  @override
  String get lastPost => 'Viimane postitus';

  @override
  String get views => 'Vaatamisi';

  @override
  String get replies => 'Vastused';

  @override
  String get replyToThisTopic => 'Vasta sellele teemale';

  @override
  String get reply => 'Vasta';

  @override
  String get message => 'Sõnum';

  @override
  String get createTheTopic => 'Loo teema';

  @override
  String get reportAUser => 'Teata kasutajast';

  @override
  String get user => 'Kasutaja';

  @override
  String get reason => 'Põhjus';

  @override
  String get whatIsIheMatter => 'Milles asi?';

  @override
  String get cheat => 'Sohk';

  @override
  String get troll => 'Troll';

  @override
  String get other => 'Muu';

  @override
  String get reportDescriptionHelp => 'Kleebi link mängu(de)st ja selgita, mis on valesti selle kasutaja käitumises. Ära ütle lihtsalt \"ta teeb sohki\", vaid seleta, kuidas sa selle järelduseni jõudsid. Sõnum käsitletakse kiiremini kui see on kirjutatud inglise keeles.';

  @override
  String get error_provideOneCheatedGameLink => 'Palun andke vähemalt üks link pettust sisaldavale mängule.';

  @override
  String by(String param) {
    return 'autor $param';
  }

  @override
  String importedByX(String param) {
    return 'Importis $param';
  }

  @override
  String get thisTopicIsNowClosed => 'See teema on nüüd lõpetatud.';

  @override
  String get blog => 'Blogi';

  @override
  String get notes => 'Märkmed';

  @override
  String get typePrivateNotesHere => 'Siia võib kirjutada märkmeid';

  @override
  String get writeAPrivateNoteAboutThisUser => 'Kirjuta privaatne märge selle kasutaja kohta';

  @override
  String get noNoteYet => 'Märkmed veel puuduvad';

  @override
  String get invalidUsernameOrPassword => 'Vale kasutajanimi või parool';

  @override
  String get incorrectPassword => 'Vale parool';

  @override
  String get invalidAuthenticationCode => 'Väär autentimise kood';

  @override
  String get emailMeALink => 'Saada mulle link meilile';

  @override
  String get currentPassword => 'Praegune parool';

  @override
  String get newPassword => 'Uus parool';

  @override
  String get newPasswordAgain => 'Uus parool (uuesti)';

  @override
  String get newPasswordsDontMatch => 'Uued paroolid ei ühti';

  @override
  String get newPasswordStrength => 'Parooli tugevus';

  @override
  String get clockInitialTime => 'Põhiaeg';

  @override
  String get clockIncrement => 'Kella juurdekasv';

  @override
  String get privacy => 'Privaatsus';

  @override
  String get privacyPolicy => 'Privaatsuspolitiika';

  @override
  String get letOtherPlayersFollowYou => 'Luba teistel mängijatel sind jälgida';

  @override
  String get letOtherPlayersChallengeYou => 'Luba teistel mängijatel sulle väljakutseid esitada';

  @override
  String get letOtherPlayersInviteYouToStudy => 'Lase teistel mängijatel sind õppima kutsuda';

  @override
  String get sound => 'Heli';

  @override
  String get none => 'Väljas';

  @override
  String get fast => 'Kiire';

  @override
  String get normal => 'Tavaline';

  @override
  String get slow => 'Aeglane';

  @override
  String get insideTheBoard => 'Laua sees';

  @override
  String get outsideTheBoard => 'Lauast väljas';

  @override
  String get allSquaresOfTheBoard => 'All squares of the board';

  @override
  String get onSlowGames => 'Aeglastes mängudes';

  @override
  String get always => 'Alati';

  @override
  String get never => 'Mitte kunagi';

  @override
  String xCompetesInY(String param1, String param2) {
    return '$param1 võtab osa turniirist $param2';
  }

  @override
  String get victory => 'Võit';

  @override
  String get defeat => 'Kaotus';

  @override
  String victoryVsYInZ(String param1, String param2, String param3) {
    return '$param1 vs $param2 kategoorias $param3';
  }

  @override
  String defeatVsYInZ(String param1, String param2, String param3) {
    return '$param1 vs $param2 kategoorias $param3';
  }

  @override
  String drawVsYInZ(String param1, String param2, String param3) {
    return '$param1 vs $param2 kategoorias $param3';
  }

  @override
  String get timeline => 'Ajatelg';

  @override
  String get starting => 'Algab:';

  @override
  String get allInformationIsPublicAndOptional => 'Kõik andmed on avalikud ja vabatahtlikud.';

  @override
  String get biographyDescription => 'Räägi endast, oma huvidest, mis meeldib male juures, lemmikavangud, -mängijad, ...';

  @override
  String get listBlockedPlayers => 'Kuva blokeeritud kasutajad';

  @override
  String get human => 'Inimene';

  @override
  String get computer => 'Arvuti';

  @override
  String get side => 'Pool';

  @override
  String get clock => 'Malekell';

  @override
  String get opponent => 'Vastane';

  @override
  String get learnMenu => 'Õpi';

  @override
  String get studyMenu => 'Uuri';

  @override
  String get practice => 'Harjuta';

  @override
  String get community => 'Kogukond';

  @override
  String get tools => 'Tööriistad';

  @override
  String get increment => 'Lisaaeg';

  @override
  String get error_unknown => 'Vale väärtus';

  @override
  String get error_required => 'See väli on kohustuslik';

  @override
  String get error_email => 'See e-posti aadress ei ole kehtiv';

  @override
  String get error_email_acceptable => 'See e-posti aadress ei ole vastuvõetav. Palun kontrolli see üle ja proovi uuesti.';

  @override
  String get error_email_unique => 'E-posti aadress vigane või juba kasutusel';

  @override
  String get error_email_different => 'See on juba su e-posti aadress';

  @override
  String error_minLength(String param) {
    return 'Peab olema vähemalt $param märki';
  }

  @override
  String error_maxLength(String param) {
    return 'Peab olema alla $param märgi';
  }

  @override
  String error_min(String param) {
    return 'Peab olema vähemalt $param';
  }

  @override
  String error_max(String param) {
    return 'Ei tohi olla üle $param';
  }

  @override
  String ifRatingIsPlusMinusX(String param) {
    return 'Kui reiting on ± $param';
  }

  @override
  String get ifRegistered => 'Registreeritud kasutajad';

  @override
  String get onlyExistingConversations => 'Ainult olemasolevad vestlused';

  @override
  String get onlyFriends => 'Ainult sõbrad';

  @override
  String get menu => 'Menüü';

  @override
  String get castling => 'Vangerdus';

  @override
  String get whiteCastlingKingside => 'Valge O-O';

  @override
  String get blackCastlingKingside => 'Must O-O';

  @override
  String tpTimeSpentPlaying(String param) {
    return 'Mängimiseks kulutatud aeg: $param';
  }

  @override
  String get watchGames => 'Vaata mänge';

  @override
  String tpTimeSpentOnTV(String param) {
    return 'Aeg Lichess TV-s: $param';
  }

  @override
  String get watch => 'Vaata';

  @override
  String get videoLibrary => 'Videod';

  @override
  String get streamersMenu => 'Striimijad';

  @override
  String get mobileApp => 'Mobiilirakendus';

  @override
  String get webmasters => 'Veebimeistritele';

  @override
  String get about => 'Info';

  @override
  String aboutX(String param) {
    return 'Info $param kohta';
  }

  @override
  String xIsAFreeYLibreOpenSourceChessServer(String param1, String param2) {
    return '$param1 on täiesti tasuta ($param2), reklaamivaba, avatud lähtekoodiga male server.';
  }

  @override
  String get really => 'päriselt';

  @override
  String get contribute => 'Panusta';

  @override
  String get termsOfService => 'Kasutajatingimused';

  @override
  String get sourceCode => 'Lähtekood';

  @override
  String get simultaneousExhibitions => 'Simultaanid';

  @override
  String get host => 'Korraldaja';

  @override
  String hostColorX(String param) {
    return 'Korraldaja värv: $param';
  }

  @override
  String get yourPendingSimuls => 'Your pending simuls';

  @override
  String get createdSimuls => 'Hiljuti loodud simultaanid';

  @override
  String get hostANewSimul => 'Korralda uus simultaan';

  @override
  String get signUpToHostOrJoinASimul => 'Sign up to host or join a simul';

  @override
  String get noSimulFound => 'Simultaani ei leitud';

  @override
  String get noSimulExplanation => 'Seda simultaani ei ole olemas.';

  @override
  String get returnToSimulHomepage => 'Tagasi simultaanide lehele';

  @override
  String get aboutSimul => 'Simultaanides mängib üks maletaja samaaegselt paljude teiste vastu.';

  @override
  String get aboutSimulImage => 'Fischer võitis simultaani 50 partiist 47, viigistas kaks ja kaotas ühe.';

  @override
  String get aboutSimulRealLife => 'See mõiste on võetud reaalsest elust. Päris elus simultaani andja liigub laualt lauale, et teha ühte käiku.';

  @override
  String get aboutSimulRules => 'Simultaani algades, iga mängija alustab mängu korraldajaga, kes mängib valgete nuppudega. Simultaan lõpeb kui kõik mängud on mängitud.';

  @override
  String get aboutSimulSettings => 'Simultaanid on alati ilma reitinguta. Kordusmäng, käikude tagasivõtmised ning aja lisamine on keelatud.';

  @override
  String get create => 'Loo';

  @override
  String get whenCreateSimul => 'Kui lood simultaani, saad mängida samaaegselt mitme vastasega.';

  @override
  String get simulVariantsHint => 'Kui valid mitu varianti, saab iga mängija valida ise millist mängida.';

  @override
  String get simulClockHint => 'Fischeri ajakontroll. Mida rohkemate mängijate vastu mängida, seda enam aega võib vaja minna.';

  @override
  String get simulAddExtraTime => 'Võid lisada kellale lisaaega, et simultaaniga paremini hakkama saada.';

  @override
  String get simulHostExtraTime => 'Sinultaani korraldaja lisaaeg';

  @override
  String get simulAddExtraTimePerPlayer => 'Add initial time to your clock for each player joining the simul.';

  @override
  String get simulHostExtraTimePerPlayer => 'Host extra clock time per player';

  @override
  String get lichessTournaments => 'Lichessi turniirid';

  @override
  String get tournamentFAQ => 'Areeni turniiride KKK';

  @override
  String get timeBeforeTournamentStarts => 'Aega turniiri alguseni';

  @override
  String get averageCentipawnLoss => 'Keskmine kaotus käigu kohta sajandiketturites';

  @override
  String get accuracy => 'Täpsus';

  @override
  String get keyboardShortcuts => 'Kiirklahvid';

  @override
  String get keyMoveBackwardOrForward => 'liigu tagasi/edasi';

  @override
  String get keyGoToStartOrEnd => 'mine algusesse/lõppu';

  @override
  String get keyCycleSelectedVariation => 'Cycle selected variation';

  @override
  String get keyShowOrHideComments => 'näita/peida kommentaarid';

  @override
  String get keyEnterOrExitVariation => 'lisa/eemalda variatsioon';

  @override
  String get keyRequestComputerAnalysis => 'Request computer analysis, Learn from your mistakes';

  @override
  String get keyNextLearnFromYourMistakes => 'Next (Learn from your mistakes)';

  @override
  String get keyNextBlunder => 'Next blunder';

  @override
  String get keyNextMistake => 'Järgmine viga';

  @override
  String get keyNextInaccuracy => 'Järgmine ebatäpsus';

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
  String get newTournament => 'Uus turniir';

  @override
  String get tournamentHomeTitle => 'Maleturniirid koos erinevate ajakontrollide ja variantidega';

  @override
  String get tournamentHomeDescription => 'Mängi kiireid turniire males! Liitu ametliku turniiriga või loo oma turniir. Võimalik on valida supervälkmale, välkmale, kiirmale, klassikalise male, Chess960, King of the Hill, Threecheck ja teiste mängutüüpide vahel, et rõõm malest kunagi ei lõpeks!';

  @override
  String get tournamentNotFound => 'Turniiri ei leitud';

  @override
  String get tournamentDoesNotExist => 'Seda turniiri pole olemas.';

  @override
  String get tournamentMayHaveBeenCanceled => 'Turniir võidakse tühistada, kui kõik mängijad lahkuvad enne selle algust.';

  @override
  String get returnToTournamentsHomepage => 'Tagasi turniirilehele';

  @override
  String weeklyPerfTypeRatingDistribution(String param) {
    return 'Nädalane $param reitingu jaotus';
  }

  @override
  String yourPerfTypeRatingIsRating(String param1, String param2) {
    return 'Sinu $param1 reiting on $param2.';
  }

  @override
  String youAreBetterThanPercentOfPerfTypePlayers(String param1, String param2) {
    return 'Oled parem kui $param1 $param2 mängijatest.';
  }

  @override
  String userIsBetterThanPercentOfPerfTypePlayers(String param1, String param2, String param3) {
    return '$param1 on parem kui $param2 $param3 mängijatest.';
  }

  @override
  String betterThanPercentPlayers(String param1, String param2) {
    return 'Better than $param1 of $param2 players';
  }

  @override
  String youDoNotHaveAnEstablishedPerfTypeRating(String param) {
    return 'Sul ei ole veel usaldusväärset $param reitingut.';
  }

  @override
  String get yourRating => 'Sinu reiting';

  @override
  String get cumulative => 'Kumulatiivne';

  @override
  String get glicko2Rating => 'Glicko-2 reiting';

  @override
  String get checkYourEmail => 'Kontrolli oma e-posti';

  @override
  String get weHaveSentYouAnEmailClickTheLink => 'Saatsime sulle e-maili. Konto aktiveerimiseks kliki e-mailis olevale lingile.';

  @override
  String get ifYouDoNotSeeTheEmailCheckOtherPlaces => 'Kui sa ei näe e-maili, vaata ka teised kohad üle nagu rämpspost ja muud kaustad.';

  @override
  String weHaveSentYouAnEmailTo(String param) {
    return 'Saatsime e-maili $param. Parooli uuendamiseks kliki e-mailis olevale lingile.';
  }

  @override
  String byRegisteringYouAgreeToBeBoundByOur(String param) {
    return 'Registreerides nõustute $param.';
  }

  @override
  String readAboutOur(String param) {
    return 'Lugege rohkem: $param.';
  }

  @override
  String get networkLagBetweenYouAndLichess => 'Võrguviivitus sinu ja Lichessi vahel';

  @override
  String get timeToProcessAMoveOnLichessServer => 'Käigu töötlemise aeg Lichessi serveril';

  @override
  String get downloadAnnotated => 'Lae alla kommentaaridega';

  @override
  String get downloadRaw => 'Lae alla kommentaarideta';

  @override
  String get downloadImported => 'Lae imporditud PNG';

  @override
  String get crosstable => 'Skoor';

  @override
  String get youCanAlsoScrollOverTheBoardToMoveInTheGame => 'Samuti võid kerida käike laua peal hiirega skrollides.';

  @override
  String get scrollOverComputerVariationsToPreviewThem => 'Vii hiir arvutivariandi kohale, et saada eelvaade.';

  @override
  String get analysisShapesHowTo => 'Vajuta shift + click või paremat hiirenuppu, et joonistada lauale ringe ja nooli.';

  @override
  String get letOtherPlayersMessageYou => 'Luba teistel mängijatel saata sulle sõnumeid';

  @override
  String get receiveForumNotifications => 'Saa teateid, kui sind foorumis mainitakse';

  @override
  String get shareYourInsightsData => 'Jaga oma Chess Insights andmeid';

  @override
  String get withNobody => 'Mitte kellegagi';

  @override
  String get withFriends => 'Sõpradega';

  @override
  String get withEverybody => 'Kõigiga';

  @override
  String get kidMode => 'Lapserežiim';

  @override
  String get kidModeIsEnabled => 'Kid mode is enabled.';

  @override
  String get kidModeExplanation => 'See on seotud turvalisusega. Lapserežiimis igasugune suhtlemine sellel lehel on välja lülitatud. Aktiveerige see režiim, et kaitsta lapsi ja kooliõpilasi teiste kasutajate eest.';

  @override
  String inKidModeTheLichessLogoGetsIconX(String param) {
    return 'Lapserežiimis Lichessi logole lisandub $param ikoon, mis tähendab, et lapserežiim on aktiveeritud.';
  }

  @override
  String get askYourChessTeacherAboutLiftingKidMode => 'Sinu konto on valve all. Küsi maleõpetajalt valve eemaldamist.';

  @override
  String get enableKidMode => 'Aktiveeri lapserežiim';

  @override
  String get disableKidMode => 'Deaktiveeri lapserežiim';

  @override
  String get security => 'Turvalisus';

  @override
  String get sessions => 'Sessioonid';

  @override
  String get revokeAllSessions => 'lõpetada kõik sessioonid';

  @override
  String get playChessEverywhere => 'Mängi malet kõikjal';

  @override
  String get asFreeAsLichess => 'Tasuta nagu Lichess';

  @override
  String get builtForTheLoveOfChessNotMoney => 'Ehitatud armastusest male, mitte raha vastu';

  @override
  String get everybodyGetsAllFeaturesForFree => 'Kõik funktsioonid on kõigile tasuta';

  @override
  String get zeroAdvertisement => 'Mitte ühtegi reklaami';

  @override
  String get fullFeatured => 'Kõik omadused';

  @override
  String get phoneAndTablet => 'Telefon ja tahvelarvuti';

  @override
  String get bulletBlitzClassical => 'Bullet, blitz, klassikaline';

  @override
  String get correspondenceChess => 'Kirimale';

  @override
  String get onlineAndOfflinePlay => 'Online ja offline mängud';

  @override
  String get viewTheSolution => 'Vaata lahendust';

  @override
  String get followAndChallengeFriends => 'Jälgi sõpru ja esita väljakutseid';

  @override
  String get gameAnalysis => 'Mängu analüüs';

  @override
  String xHostsY(String param1, String param2) {
    return '$param1 korraldab $param2';
  }

  @override
  String xJoinsY(String param1, String param2) {
    return '$param1 liitus $param2';
  }

  @override
  String xLikesY(String param1, String param2) {
    return 'Mängijale $param1 meeldib $param2';
  }

  @override
  String get quickPairing => 'Kiirelt mängu';

  @override
  String get lobby => 'Ooteruum';

  @override
  String get anonymous => 'Anonüümne';

  @override
  String yourScore(String param) {
    return 'Sinu skoor: $param';
  }

  @override
  String get language => 'Keel';

  @override
  String get background => 'Taust';

  @override
  String get light => 'Hele';

  @override
  String get dark => 'Tume';

  @override
  String get transparent => 'Läbipaistev';

  @override
  String get deviceTheme => 'Seadme teema';

  @override
  String get backgroundImageUrl => 'Taustapildi URL:';

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
  String get pieceSet => 'Malendite kujundus';

  @override
  String get embedInYourWebsite => 'Sängita oma veebilehel';

  @override
  String get usernameAlreadyUsed => 'See kasutajanimi on juba olemas, proovi midagi muud.';

  @override
  String get usernamePrefixInvalid => 'Kasutajanimi peab algama tähega.';

  @override
  String get usernameSuffixInvalid => 'Kasutajanimi peab lõppema numbri või tähega.';

  @override
  String get usernameCharsInvalid => 'Kasutajanimi peab sisaldama ainult tähti, numbreid, alakriipse ja sidekriipse. Järjestikused alakriipsud ega sidekriipsud ei ole lubatud.';

  @override
  String get usernameUnacceptable => 'See kasutajanimi ei ole lubatud.';

  @override
  String get playChessInStyle => 'Mängi malet stiilselt';

  @override
  String get chessBasics => 'Male põhitõed';

  @override
  String get coaches => 'Treenerid';

  @override
  String get invalidPgn => 'Väär PGN';

  @override
  String get invalidFen => 'Väär FEN';

  @override
  String get custom => 'Kohandatud';

  @override
  String get notifications => 'Teavitused';

  @override
  String notificationsX(String param1) {
    return 'Märguanded: $param1';
  }

  @override
  String perfRatingX(String param) {
    return 'Reiting: $param';
  }

  @override
  String get practiceWithComputer => 'Harjuta arvutiga';

  @override
  String anotherWasX(String param) {
    return 'Samuti on hea $param';
  }

  @override
  String bestWasX(String param) {
    return 'Parim oli $param';
  }

  @override
  String get youBrowsedAway => 'Sa lahkusid eemale';

  @override
  String get resumePractice => 'Jätka harjutamist';

  @override
  String get drawByFiftyMoves => 'Mäng on viigistatud viiekümne käigu reegli alusel.';

  @override
  String get theGameIsADraw => 'See mäng on viik.';

  @override
  String get computerThinking => 'Arvuti mõtleb ...';

  @override
  String get seeBestMove => 'Vaata parimat käiku';

  @override
  String get hideBestMove => 'Peida parim käik';

  @override
  String get getAHint => 'Vaata vihjet';

  @override
  String get evaluatingYourMove => 'Sinu käigu hindamine ...';

  @override
  String get whiteWinsGame => 'Valge võitis';

  @override
  String get blackWinsGame => 'Must võitis';

  @override
  String get learnFromYourMistakes => 'Õpi oma vigadest';

  @override
  String get learnFromThisMistake => 'Õpi sellest veast';

  @override
  String get skipThisMove => 'Jäta see käik vahele';

  @override
  String get next => 'Järgmine';

  @override
  String xWasPlayed(String param) {
    return '$param mängiti';
  }

  @override
  String get findBetterMoveForWhite => 'Leia parem käik valgele';

  @override
  String get findBetterMoveForBlack => 'Leia parem käik mustale';

  @override
  String get resumeLearning => 'Jätka õppimist';

  @override
  String get youCanDoBetter => 'Suudad paremini';

  @override
  String get tryAnotherMoveForWhite => 'Proovi teist käiku valgele';

  @override
  String get tryAnotherMoveForBlack => 'Proovi teist käiku mustale';

  @override
  String get solution => 'Lahendus';

  @override
  String get waitingForAnalysis => 'Analüüsimine';

  @override
  String get noMistakesFoundForWhite => 'Valge eksimusi ei leitud';

  @override
  String get noMistakesFoundForBlack => 'Musta eksimusi ei leitud';

  @override
  String get doneReviewingWhiteMistakes => 'Valge vead on üle vaadatud';

  @override
  String get doneReviewingBlackMistakes => 'Musta vead on üle vaadatud';

  @override
  String get doItAgain => 'Vaata veelkord üle';

  @override
  String get reviewWhiteMistakes => 'Vaata üle valge vead';

  @override
  String get reviewBlackMistakes => 'Vaata üle musta vead';

  @override
  String get advantage => 'Eelis';

  @override
  String get opening => 'Avang';

  @override
  String get middlegame => 'Keskmäng';

  @override
  String get endgame => 'Lõppmäng';

  @override
  String get conditionalPremoves => 'Tingimuslikud eelkäigud';

  @override
  String get addCurrentVariation => 'Lisa praegune variatsioon';

  @override
  String get playVariationToCreateConditionalPremoves => 'Tingimuslike eelkäikude loomiseks mängi variatsioon';

  @override
  String get noConditionalPremoves => 'Tingimuslikud eelkäigud puuduvad';

  @override
  String playX(String param) {
    return 'Käi $param';
  }

  @override
  String get showUnreadLichessMessage => 'You have received a private message from Lichess.';

  @override
  String get clickHereToReadIt => 'Click here to read it';

  @override
  String get sorry => 'Vabandust :(';

  @override
  String get weHadToTimeYouOutForAWhile => 'Me pidime su natukeseks ära blokeerima.';

  @override
  String get why => 'Miks?';

  @override
  String get pleasantChessExperience => 'Me tahame pakkuda häid malekogemusi kõigile.';

  @override
  String get goodPractice => 'Selleks peame olema kindlad, et kõik meie kasutajad järgivad reegleid.';

  @override
  String get potentialProblem => 'Kui potentsiaalne probleem on avastatud siis me näitame seda sõnumit.';

  @override
  String get howToAvoidThis => 'Kuidas seda vältida?';

  @override
  String get playEveryGame => 'Mängi igat alustatud mängu.';

  @override
  String get tryToWin => 'Proovi võita (või vähemalt viigistada) iga mäng mida mängid.';

  @override
  String get resignLostGames => 'Alistu kaotatud mängud (ära lase kellal joosta lõpuni).';

  @override
  String get temporaryInconvenience => 'Me vabandame ajutise ebamugavuse pärast,';

  @override
  String get wishYouGreatGames => 'ja soovime häid mänge lichess.org-is.';

  @override
  String get thankYouForReading => 'Aitäh lugemast!';

  @override
  String get lifetimeScore => 'Kõikide mängude skoor';

  @override
  String get currentMatchScore => 'Praeguste mängude skoor';

  @override
  String get agreementAssistance => 'Ma nõustun, et mängin ilma abivahenditeta (ilma malearvuti, raamatu, andmebaasi või teise inimese abita).';

  @override
  String get agreementNice => 'Ma nõustun, et olen alati lugupidav teiste mängijate suhtes.';

  @override
  String agreementMultipleAccounts(String param) {
    return 'Nõustun, et ei loo mitu kontot (välja arvatud põhjustel, mis seletatud $param).';
  }

  @override
  String get agreementPolicy => 'Ma nõustun, et järgin kõiki Lichessi eeskirju.';

  @override
  String get searchOrStartNewDiscussion => 'Otsi või alusta uut vestlust';

  @override
  String get edit => 'Muuda';

  @override
  String get bullet => 'Bullet';

  @override
  String get blitz => 'Välkmale';

  @override
  String get rapid => 'Kiirmale';

  @override
  String get classical => 'Klassikaline';

  @override
  String get ultraBulletDesc => 'Ultrakiired mängud: vähem kui 30 sekundit';

  @override
  String get bulletDesc => 'Ülikiired mängud: vähem kui 3 minutit';

  @override
  String get blitzDesc => 'Väga kiired mängud: 3 kuni 8 minutit';

  @override
  String get rapidDesc => 'Kiired mängud: 8 kuni 25 minutit';

  @override
  String get classicalDesc => 'Klassikalised mängud: 25 minutit ja kauem';

  @override
  String get correspondenceDesc => 'Kirjavahetusmängud: üks või enam päeva käigu kohta';

  @override
  String get puzzleDesc => 'Taktikaharjutus';

  @override
  String get important => 'Tähtis';

  @override
  String yourQuestionMayHaveBeenAnswered(String param1) {
    return 'Sinu küsimusele võib juba vastus leiduda $param1';
  }

  @override
  String get inTheFAQ => 'KKK-s.';

  @override
  String toReportSomeoneForCheatingOrBadBehavior(String param1) {
    return 'Et teatada sohitegijast või halvast käitumisest, $param1';
  }

  @override
  String get useTheReportForm => 'kasuta selleks ettenähtud vormi';

  @override
  String toRequestSupport(String param1) {
    return 'Abi saamiseks, $param1';
  }

  @override
  String get tryTheContactPage => 'proovi kontakti lehte';

  @override
  String makeSureToRead(String param1) {
    return 'Loe ka kindlasti $param1';
  }

  @override
  String get theForumEtiquette => 'foorumi etikett';

  @override
  String get thisTopicIsArchived => 'See teema on arhiveeritud ja sellele ei saa enam vastata.';

  @override
  String joinTheTeamXToPost(String param1) {
    return 'Ühine $param1-ga et sellesse foorumisse postitada';
  }

  @override
  String teamNamedX(String param1) {
    return '$param1 võistkond';
  }

  @override
  String get youCannotPostYetPlaySomeGames => 'Sa ei saa veel foorumisse postitada. Mängi enne paar mängu!';

  @override
  String get subscribe => 'Telli';

  @override
  String get unsubscribe => 'Tühista tellimus';

  @override
  String mentionedYouInX(String param1) {
    return 'mainis sind sõnumis \"$param1\".';
  }

  @override
  String xMentionedYouInY(String param1, String param2) {
    return '$param1 mainis sind sõnumis \"$param2\".';
  }

  @override
  String invitedYouToX(String param1) {
    return 'kutsus sind \"$param1\".';
  }

  @override
  String xInvitedYouToY(String param1, String param2) {
    return '$param1 kutsus sind \"$param2\".';
  }

  @override
  String get youAreNowPartOfTeam => 'Sa oled nüüd võistkonna liige.';

  @override
  String youHaveJoinedTeamX(String param1) {
    return 'Oled liitunud meeskonnaga \"$param1\".';
  }

  @override
  String get someoneYouReportedWasBanned => 'Keegi, kellest sa teatasid, sai mängukeelu';

  @override
  String get congratsYouWon => 'Palju õnne, sa võitsid!';

  @override
  String gameVsX(String param1) {
    return 'Mängus $param1 vastu';
  }

  @override
  String resVsX(String param1, String param2) {
    return '$param1 vs $param2';
  }

  @override
  String get lostAgainstTOSViolator => 'Sa kaotasid kellegile, kes rikkus Lichessi teenusetingimusi';

  @override
  String refundXpointsTimeControlY(String param1, String param2) {
    return 'Tagastus: $param1 $param2 reitingupunkti.';
  }

  @override
  String get timeAlmostUp => 'Aeg on peaaegu otsas!';

  @override
  String get clickToRevealEmailAddress => '[Vajuta e-maili aadressi nägemiseks]';

  @override
  String get download => 'Lae alla';

  @override
  String get coachManager => 'Treeneri seaded';

  @override
  String get streamerManager => 'Striimeri seaded';

  @override
  String get cancelTournament => 'Tühista turniir';

  @override
  String get tournDescription => 'Turniiri kirjeldus';

  @override
  String get tournDescriptionHelp => 'Kas soovid osalejatele midagi erilist öelda? Püüa hoida see lühike. Markdown lingid on saadaval: [name](https://url)';

  @override
  String get ratedFormHelp => 'Mängud on reitinguga\nja mõjutavad mängijate reitinguid';

  @override
  String get onlyMembersOfTeam => 'Ainult võistkonnaliikmed';

  @override
  String get noRestriction => 'Piiranguta';

  @override
  String get minimumRatedGames => 'Minimaalne reitinguga mängude arv';

  @override
  String get minimumRating => 'Minimaalne reiting';

  @override
  String get maximumWeeklyRating => 'Minimaalne nädalane reiting';

  @override
  String positionInputHelp(String param) {
    return 'Sisesta kehtiv FEN, et alustada iga mängu antud positsioonilt.\nSee töötab ainult standardmängude, mitte variantide puhul.\nFEN-i genereerimiseks on kasutada $param, seejärel saab selle siia kleepida.\nJäta tühjaks, et alustada mänge tavalisest algpositsioonist.';
  }

  @override
  String get cancelSimul => 'Tühista simultaan';

  @override
  String get simulHostcolor => 'Korraldaja värv igas mängus';

  @override
  String get estimatedStart => 'Eeldatav algusaeg';

  @override
  String simulFeatured(String param) {
    return 'Näita leheküljel $param';
  }

  @override
  String simulFeaturedHelp(String param) {
    return 'Näita oma simultaan kõigile $param-s. Lülita välja privaatseks simultaaniks.';
  }

  @override
  String get simulDescription => 'Simultaani kirjeldus';

  @override
  String get simulDescriptionHelp => 'Tahad osalejatele midagi öelda?';

  @override
  String markdownAvailable(String param) {
    return '$param on saadaval täiendavate vormindusvõimaluste jaoks.';
  }

  @override
  String get embedsAvailable => 'Aseta mängu URL või uuringu peatüki URL et seda sängitada.';

  @override
  String get inYourLocalTimezone => 'Kohalikus ajavööndis';

  @override
  String get tournChat => 'Turniiri vestlus';

  @override
  String get noChat => 'Vestluseta';

  @override
  String get onlyTeamLeaders => 'Ainult võistkonnajuhid';

  @override
  String get onlyTeamMembers => 'Ainult võistkonnaliikmed';

  @override
  String get navigateMoveTree => 'Navigeeri käiguloendis';

  @override
  String get mouseTricks => 'Hiiretrikid';

  @override
  String get toggleLocalAnalysis => 'Lülita kohalik arvuti analüüs sisse/välja';

  @override
  String get toggleAllAnalysis => 'Lülita täielik arvuti analüüs sisse/välja';

  @override
  String get playComputerMove => 'Tee parim arvutikäik';

  @override
  String get analysisOptions => 'Analüüsi seaded';

  @override
  String get focusChat => 'Fokuseeri vestlus';

  @override
  String get showHelpDialog => 'Näita seda abiakent';

  @override
  String get reopenYourAccount => 'Ava oma konto uuesti';

  @override
  String get closedAccountChangedMind => 'Kui sulgesid oma konto, kuid oled vahepeal ümber mõelnud, on sul üks võimalus oma konto tagasi saada.';

  @override
  String get onlyWorksOnce => 'See töötab ainult ühe korra.';

  @override
  String get cantDoThisTwice => 'Kui sa sulged oma konto teist korda, ei ole seda võimalik taastada.';

  @override
  String get emailAssociatedToaccount => 'Kontoga seotud e-posti aadress';

  @override
  String get sentEmailWithLink => 'Saatsime teile lingiga e-kirja.';

  @override
  String get tournamentEntryCode => 'Turniiri osavõtukood';

  @override
  String get hangOn => 'Oota!';

  @override
  String gameInProgress(String param) {
    return 'Mäng kasutajaga $param on veel pooleli.';
  }

  @override
  String get abortTheGame => 'Katkesta mäng';

  @override
  String get resignTheGame => 'Alistu';

  @override
  String get youCantStartNewGame => 'Uut mängu ei saa alustada enne, kui see mäng on lõpetatud.';

  @override
  String get since => 'Alates';

  @override
  String get until => 'Kuni';

  @override
  String get lichessDbExplanation => 'Reitinguga mängud kõikidelt Lichessi mängijatelt';

  @override
  String get switchSides => 'Vaheta pooli';

  @override
  String get closingAccountWithdrawAppeal => 'Konto sulgemine tühistab teie kaebuse';

  @override
  String get ourEventTips => 'Meie nõuanded ürituste korraldamiseks';

  @override
  String get instructions => 'Instructions';

  @override
  String get showMeEverything => 'Show me everything';

  @override
  String get lichessPatronInfo => 'Lichess on heategevuslik ja täiesti tasuta avatud lähtekoodiga tarkvara.\nKõik tegevuskulud, arendus ja sisu rahastatakse ainult kasutajate annetustest.';

  @override
  String get nothingToSeeHere => 'Nothing to see here at the moment.';

  @override
  String opponentLeftCounter(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Vastane lahkus mängust. Saad kuulutada ennast võitjaks $count sekundi pärast.',
      one: 'Vastane lahkus mängust. Saate panna vastase alistuma $count sekundi pärast.',
    );
    return '$_temp0';
  }

  @override
  String mateInXHalfMoves(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Šahh ja matt $count käiguga',
      one: 'Šahh ja Matt $count käiguga',
    );
    return '$_temp0';
  }

  @override
  String nbBlunders(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count prohmakat',
      one: '$count prohmakas',
    );
    return '$_temp0';
  }

  @override
  String nbMistakes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count viga',
      one: '$count viga',
    );
    return '$_temp0';
  }

  @override
  String nbInaccuracies(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ebatäpsust',
      one: '$count ebatäpsus',
    );
    return '$_temp0';
  }

  @override
  String nbPlayers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count mängijat',
      one: '$count mängija',
    );
    return '$_temp0';
  }

  @override
  String nbGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count mängu',
      one: '$count mäng',
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
      other: '$count mängude järjehoidjad',
      one: '$count mängu järjehoidja',
    );
    return '$_temp0';
  }

  @override
  String nbDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count päeva',
      one: '$count päev',
    );
    return '$_temp0';
  }

  @override
  String nbHours(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count tundi',
      one: '$count tund',
    );
    return '$_temp0';
  }

  @override
  String nbMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count minutit',
      one: '$count minut',
    );
    return '$_temp0';
  }

  @override
  String rankIsUpdatedEveryNbMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Reitingut uuendatakse iga $count minuti tagant',
      one: 'Reitingut uuendatakse iga minuti tagant',
    );
    return '$_temp0';
  }

  @override
  String nbPuzzles(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ülesannet',
      one: '$count ülesanne',
    );
    return '$_temp0';
  }

  @override
  String nbGamesWithYou(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count mängu sinuga',
      one: '$count mäng sinuga',
    );
    return '$_temp0';
  }

  @override
  String nbRated(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count reitinguga',
      one: '$count reitinguga',
    );
    return '$_temp0';
  }

  @override
  String nbWins(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count võitu',
      one: '$count võit',
    );
    return '$_temp0';
  }

  @override
  String nbLosses(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count kaotust',
      one: '$count kaotus',
    );
    return '$_temp0';
  }

  @override
  String nbDraws(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count viiki',
      one: '$count viik',
    );
    return '$_temp0';
  }

  @override
  String nbPlaying(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count mängimas',
      one: '$count mängimas',
    );
    return '$_temp0';
  }

  @override
  String giveNbSeconds(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Lisa $count sekundit',
      one: 'Lisa $count sekund',
    );
    return '$_temp0';
  }

  @override
  String nbTournamentPoints(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count turniiri punkti',
      one: '$count turniiri punkt',
    );
    return '$_temp0';
  }

  @override
  String nbStudies(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count uuringut',
      one: '$count uuring',
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
      other: '≥ $count reitinguga mängu',
      one: '≥ $count reitinguga mäng',
    );
    return '$_temp0';
  }

  @override
  String moreThanNbPerfRatedGames(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '≥ $count $param2 reitinguga mängu',
      one: '≥ $count $param2 reitinguga mäng',
    );
    return '$_temp0';
  }

  @override
  String needNbMorePerfGames(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Peate mängima veel $count $param2 reitinguga mängu',
      one: 'Peate mängima veel $count $param2 reitinguga mängu',
    );
    return '$_temp0';
  }

  @override
  String needNbMoreGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Peate veel mängima $count reitinguga mängu',
      one: 'Peate veel mängima $count reitinguga mängu',
    );
    return '$_temp0';
  }

  @override
  String nbImportedGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Imporditud mängu',
      one: '$count Imporditud mäng',
    );
    return '$_temp0';
  }

  @override
  String nbFriendsOnline(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count sõpra on kohal',
      one: '$count sõber on kohal',
    );
    return '$_temp0';
  }

  @override
  String nbFollowers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count jälgijat',
      one: '$count jälgija',
    );
    return '$_temp0';
  }

  @override
  String nbFollowing(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count jälgimist',
      one: '$count jälgimine',
    );
    return '$_temp0';
  }

  @override
  String lessThanNbMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Alla $count minuti',
      one: 'Alla $count minuti',
    );
    return '$_temp0';
  }

  @override
  String nbGamesInPlay(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count mängu pooleli',
      one: '$count mäng pooleli',
    );
    return '$_temp0';
  }

  @override
  String maximumNbCharacters(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Maksimum: $count märki.',
      one: 'Maksimum: $count märk.',
    );
    return '$_temp0';
  }

  @override
  String blocks(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count blokeeritud kasutajat',
      one: '$count blokeeritud kasutaja',
    );
    return '$_temp0';
  }

  @override
  String nbForumPosts(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count foorumipostitust',
      one: '$count foorumipostitus',
    );
    return '$_temp0';
  }

  @override
  String nbPerfTypePlayersThisWeek(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count $param2 mängijat sellel nädalal.',
      one: '$count $param2 mängija sellel nädalal.',
    );
    return '$_temp0';
  }

  @override
  String availableInNbLanguages(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Saadaval $count keeles!',
      one: 'Saadaval $count keeles!',
    );
    return '$_temp0';
  }

  @override
  String nbSecondsToPlayTheFirstMove(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count sekundit, et teha esimene käik',
      one: '$count sekund, et teha esimene käik',
    );
    return '$_temp0';
  }

  @override
  String nbSeconds(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count sekundit',
      one: '$count sekund',
    );
    return '$_temp0';
  }

  @override
  String andSaveNbPremoveLines(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'ja salvesta $count ettekäigu variendid',
      one: 'ja salvesta $count ettekäigu variendid',
    );
    return '$_temp0';
  }

  @override
  String get stormMoveToStart => 'Alusta käiguga';

  @override
  String get stormYouPlayTheWhitePiecesInAllPuzzles => 'Sa mängid kõigis pusledes valgete nuppudega';

  @override
  String get stormYouPlayTheBlackPiecesInAllPuzzles => 'Sa mängid kõigis pusledes mustade nuppudega';

  @override
  String get stormPuzzlesSolved => 'lahendatud ülesannet';

  @override
  String get stormNewDailyHighscore => 'Päeva parim tulemus!';

  @override
  String get stormNewWeeklyHighscore => 'Nädala parim tulemus!';

  @override
  String get stormNewMonthlyHighscore => 'Kuu parim tulemus!';

  @override
  String get stormNewAllTimeHighscore => 'Uus kõikide aegade rekord!';

  @override
  String stormPreviousHighscoreWasX(String param) {
    return 'Eelmine rekord oli $param';
  }

  @override
  String get stormPlayAgain => 'Mängi uuesti';

  @override
  String stormHighscoreX(String param) {
    return 'Rekord: $param';
  }

  @override
  String get stormScore => 'Punktid';

  @override
  String get stormMoves => 'Käike';

  @override
  String get stormAccuracy => 'Täpsus';

  @override
  String get stormCombo => 'Kombo';

  @override
  String get stormTime => 'Aeg';

  @override
  String get stormTimePerMove => 'Aeg käigu kohta';

  @override
  String get stormHighestSolved => 'Kõrgeim lahendatud';

  @override
  String get stormPuzzlesPlayed => 'Mängitud pusled';

  @override
  String get stormNewRun => 'Uus mäng (kiirklahv: tühikuklahv)';

  @override
  String get stormEndRun => 'Lõpeta mäng (kiirklahv: Enter)';

  @override
  String get stormHighscores => 'Rekordid';

  @override
  String get stormViewBestRuns => 'Vaata parimad mängud';

  @override
  String get stormBestRunOfDay => 'Päeva parim mäng';

  @override
  String get stormRuns => 'Mänge';

  @override
  String get stormGetReady => 'Ole valmis!';

  @override
  String get stormWaitingForMorePlayers => 'Oodatakse rohkem mängiaid liituma...';

  @override
  String get stormRaceComplete => 'Võistlus on läbi!';

  @override
  String get stormSpectating => 'Vaatamas';

  @override
  String get stormJoinTheRace => 'Liitu võistlusega!';

  @override
  String get stormStartTheRace => 'Alusta võistlus';

  @override
  String stormYourRankX(String param) {
    return 'Sinu koht: $param';
  }

  @override
  String get stormWaitForRematch => 'Oota kordusmängu';

  @override
  String get stormNextRace => 'Järgmine võistlus';

  @override
  String get stormJoinRematch => 'Liitu kordusmängu';

  @override
  String get stormWaitingToStart => 'Oodetakse algust';

  @override
  String get stormCreateNewGame => 'Loo uus mäng';

  @override
  String get stormJoinPublicRace => 'Liitu avaliku võistlusega';

  @override
  String get stormRaceYourFriends => 'Võistle oma sõpradega';

  @override
  String get stormSkip => 'jäta vahele';

  @override
  String get stormSkipHelp => 'Iga võistluse korral võid jätta ühe käigu vahele:';

  @override
  String get stormSkipExplanation => 'Jäta see käik vahele, et säilitada oma seeria! Töötab ainul kord ühes võistluses.';

  @override
  String get stormFailedPuzzles => 'Ebaõnnestunud pusled';

  @override
  String get stormSlowPuzzles => 'Aeglased pusled';

  @override
  String get stormSkippedPuzzle => 'Vahele jäetud pusled';

  @override
  String get stormThisWeek => 'Sellel nädalal';

  @override
  String get stormThisMonth => 'Sellel kuul';

  @override
  String get stormAllTime => 'Kõige parem';

  @override
  String get stormClickToReload => 'Kliki uuesti laadimiseks';

  @override
  String get stormThisRunHasExpired => 'See mäng on aegunud!';

  @override
  String get stormThisRunWasOpenedInAnotherTab => 'See mäng avati teises vahelehes!';

  @override
  String stormXRuns(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count mängu',
      one: '1 mäng',
    );
    return '$_temp0';
  }

  @override
  String stormPlayedNbRunsOfPuzzleStorm(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Mängis $count mängu ${param2}i',
      one: 'Mängis ühe mängu ${param2}i',
    );
    return '$_temp0';
  }

  @override
  String get streamerLichessStreamers => 'Lichessi striimijad';

  @override
  String get studyShareAndExport => 'Jaga & ekspordi';

  @override
  String get studyStart => 'Alusta';
}
