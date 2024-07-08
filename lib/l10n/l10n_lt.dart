import 'package:intl/intl.dart' as intl;

import 'l10n.dart';

/// The translations for Lithuanian (`lt`).
class AppLocalizationsLt extends AppLocalizations {
  AppLocalizationsLt([String locale = 'lt']) : super(locale);

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
  String get activityActivity => 'Veikla';

  @override
  String get activityHostedALiveStream => 'Organizavo transliaciją';

  @override
  String activityRankedInSwissTournament(String param1, String param2) {
    return 'Reitinguotas #$param1 iš $param2';
  }

  @override
  String get activitySignedUp => 'Užsiregistravo „Lichess“';

  @override
  String activitySupportedNbMonths(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Remia lichess.org $count mėn. kaip „$param2“',
      many: 'Remia lichess.org $count mėn. kaip „$param2“',
      few: 'Remia lichess.org $count mėn. kaip „$param2“',
      one: 'Remia lichess.org $count mėn. kaip „$param2“',
    );
    return '$_temp0';
  }

  @override
  String activityPracticedNbPositions(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Praktikavosi $count pozicijų per „$param2“',
      many: 'Praktikavosi $count pozicijų per „$param2“',
      few: 'Praktikavosi $count pozicijas per „$param2“',
      one: 'Praktikavosi $count poziciją per „$param2“',
    );
    return '$_temp0';
  }

  @override
  String activitySolvedNbPuzzles(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Išsprendė $count taktinių užduočių',
      many: 'Išsprendė $count taktinių užduočių',
      few: 'Išsprendė $count taktines užduotis',
      one: 'Išsprendė $count taktinę užduotį',
    );
    return '$_temp0';
  }

  @override
  String activityPlayedNbGames(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Sužaidė $count „$param2“ partijų',
      many: 'Sužaidė $count „$param2“ partijų',
      few: 'Sužaidė $count „$param2“ partijas',
      one: 'Sužaidė $count „$param2“ partiją',
    );
    return '$_temp0';
  }

  @override
  String activityPostedNbMessages(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Parašė $count žinučių temoje „$param2“',
      many: 'Parašė $count žinučių temoje „$param2“',
      few: 'Parašė $count žinutes temoje „$param2“',
      one: 'Parašė $count žinutę temoje „$param2“',
    );
    return '$_temp0';
  }

  @override
  String activityPlayedNbMoves(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Sužaidė $count ėjimų',
      many: 'Sužaidė $count ėjimų',
      few: 'Sužaidė $count ėjimus',
      one: 'Sužaidė $count ėjimą',
    );
    return '$_temp0';
  }

  @override
  String activityInNbCorrespondenceGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'per $count korespondencinių partijų',
      many: 'per $count korespondencinių partijų',
      few: 'per $count korespondencines partijas',
      one: 'per $count korespondencinę partiją',
    );
    return '$_temp0';
  }

  @override
  String activityCompletedNbGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Užbaigė $count korespondencinių partijų',
      many: 'Užbaigė $count korespondencinių partijų',
      few: 'Užbaigė $count korespondencines partijas',
      one: 'Užbaigė $count korespondencinę partiją',
    );
    return '$_temp0';
  }

  @override
  String activityFollowedNbPlayers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Pradėjo sekti $count žaidėjų',
      many: 'Pradėjo sekti $count žaidėjų',
      few: 'Pradėjo sekti $count žaidėjus',
      one: 'Pradėjo sekti $count žaidėją',
    );
    return '$_temp0';
  }

  @override
  String activityGainedNbFollowers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Sulaukė $count sekėjų',
      many: 'Sulaukė $count sekėjų',
      few: 'Sulaukė $count sekėjų',
      one: 'Sulaukė $count sekėjo',
    );
    return '$_temp0';
  }

  @override
  String activityHostedNbSimuls(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Organizavo $count simulų',
      many: 'Organizavo $count simulų',
      few: 'Organizavo $count simulus',
      one: 'Organizavo $count simulą',
    );
    return '$_temp0';
  }

  @override
  String activityJoinedNbSimuls(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Dalyvavo $count-yje simulų',
      many: 'Dalyvavo $count-yje simulų',
      few: 'Dalyvavo $count-se simuluose',
      one: 'Dalyvavo $count-me simule',
    );
    return '$_temp0';
  }

  @override
  String activityCreatedNbStudies(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Sukūrė $count naujų studijų',
      many: 'Sukūrė $count naujų studijų',
      few: 'Sukūrė $count naujas studijas',
      one: 'Sukūrė $count naują studiją',
    );
    return '$_temp0';
  }

  @override
  String activityCompetedInNbTournaments(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Varžėsi $count-yje turnyrų',
      many: 'Varžėsi $count-yje turnyrų',
      few: 'Varžėsi $count-uose turnyruose',
      one: 'Varžėsi $count-ame turnyre',
    );
    return '$_temp0';
  }

  @override
  String activityRankedInTournament(int count, String param2, String param3, String param4) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Užėmė #$count (tarp $param2% geriausiųjų) su $param3 partijų, žaidžiant „$param4“',
      many: 'Užėmė #$count (tarp $param2% geriausiųjų) su $param3 partijų, žaidžiant „$param4“',
      few: 'Užėmė #$count (tarp $param2% geriausiųjų) su $param3 partijomis, žaidžiant „$param4“',
      one: 'Užėmė #$count (tarp $param2% geriausiųjų) su $param3 partija, žaidžiant „$param4“',
    );
    return '$_temp0';
  }

  @override
  String activityCompetedInNbSwissTournaments(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Dalyvavo $count šveicariškų turnyrų',
      many: 'Dalyvavo $count šveicariško turnyro',
      few: 'Dalyvavo $count šveicariškuose turnyruose',
      one: 'Dalyvavo $count šveicariškame turnyre',
    );
    return '$_temp0';
  }

  @override
  String activityJoinedNbTeams(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Prisijungė prie $count komandų',
      many: 'Prisijungė prie $count komandų',
      few: 'Prisijungė prie $count komandų',
      one: 'Prisijungė prie $count komandos',
    );
    return '$_temp0';
  }

  @override
  String get broadcastBroadcasts => 'Transliacijos';

  @override
  String get broadcastLiveBroadcasts => 'Vykstančios turnyrų transliacijos';

  @override
  String challengeChallengesX(String param1) {
    return 'Iššūkiai: $param1';
  }

  @override
  String get challengeChallengeToPlay => 'Iškelti iššūkį';

  @override
  String get challengeChallengeDeclined => 'Iššūkis atmestas';

  @override
  String get challengeChallengeAccepted => 'Iššūkis priimtas!';

  @override
  String get challengeChallengeCanceled => 'Iššūkis atšauktas.';

  @override
  String get challengeRegisterToSendChallenges => 'Norėdami kurti iššūkius užsiregistruokite.';

  @override
  String challengeYouCannotChallengeX(String param) {
    return 'Negalite kelti iššūkio $param.';
  }

  @override
  String challengeXDoesNotAcceptChallenges(String param) {
    return '$param nepriima iššūkių.';
  }

  @override
  String challengeYourXRatingIsTooFarFromY(String param1, String param2) {
    return 'Jūsų $param1 reitingas per toli nuo $param2.';
  }

  @override
  String challengeCannotChallengeDueToProvisionalXRating(String param) {
    return 'Negalima sukurti iššūkio dėl laikino $param reitingo.';
  }

  @override
  String challengeXOnlyAcceptsChallengesFromFriends(String param) {
    return '$param priima iššūkius tik iš draugų.';
  }

  @override
  String get challengeDeclineGeneric => 'Šiuo metu iššūkių nepriimu.';

  @override
  String get challengeDeclineLater => 'Šiuo metu nepriimu iššūkių, pabandykite dar kartą vėliau.';

  @override
  String get challengeDeclineTooFast => 'Ši laiko kontrolė man per greita, kitame iššūkyje nurodykite lėtesnį žaidimą.';

  @override
  String get challengeDeclineTooSlow => 'Ši laiko kontrolė man per lėta, kitame iššūkyje nurodykite greitesnį žaidimą.';

  @override
  String get challengeDeclineTimeControl => 'Nepriimu iššūkių su šia laiko kontrole.';

  @override
  String get challengeDeclineRated => 'Vietoje šio iššūkio atsiųskite vertinamą iššūkį.';

  @override
  String get challengeDeclineCasual => 'Vietoje šio iššūkio atsiųskite nevertinamą iššūkį.';

  @override
  String get challengeDeclineStandard => 'Šiuo metu nepriimu variantų iššūkių.';

  @override
  String get challengeDeclineVariant => 'Šiuo metu nenoriu žaisti šio varianto.';

  @override
  String get challengeDeclineNoBot => 'Nepriimu iššūkių iš programų.';

  @override
  String get challengeDeclineOnlyBot => 'Priimu iššūkius tik iš programų.';

  @override
  String get challengeInviteLichessUser => 'Arba pakvieskite Lichess vartotoją:';

  @override
  String get contactContact => 'Susisiekite';

  @override
  String get contactContactLichess => 'Susisiekite su „Lichess“';

  @override
  String get patronDonate => 'Paremti';

  @override
  String get patronLichessPatron => 'Lichess Rėmėjas';

  @override
  String perfStatPerfStats(String param) {
    return '$param statistika';
  }

  @override
  String get perfStatViewTheGames => 'Peržiūrėti partijas';

  @override
  String get perfStatProvisional => 'laikinas';

  @override
  String get perfStatNotEnoughRatedGames => 'Kol kas nesužaista pakankamai reitinguotų partijų, kad būtų sudarytas patikimas reitingas.';

  @override
  String perfStatProgressOverLastXGames(String param) {
    return 'Progresas per paskutines $param partijas:';
  }

  @override
  String perfStatRatingDeviation(String param) {
    return 'Reitingo paklaida: $param.';
  }

  @override
  String perfStatRatingDeviationTooltip(String param1, String param2, String param3) {
    return 'Žemesnė vertė reiškia, kad reitingas stabilesnis. Reikšmei esant virš $param1, reitingas laikomas laikinuoju. Norint būti paskelbtam reitingavimuose, ši reikšmė turi būti mažesnė, nei $param2 (standartiniuose šachmatuose) ar $param3 (variantuose).';
  }

  @override
  String get perfStatTotalGames => 'Viso partijų';

  @override
  String get perfStatRatedGames => 'Reitinguotų partijų';

  @override
  String get perfStatTournamentGames => 'Turnyrinių partijų';

  @override
  String get perfStatBerserkedGames => 'Įsiučio partijų';

  @override
  String get perfStatTimeSpentPlaying => 'Laiko praleista žaidžiant';

  @override
  String get perfStatAverageOpponent => 'Vidutinis priešininkas';

  @override
  String get perfStatVictories => 'Pergalių';

  @override
  String get perfStatDefeats => 'Pralaimėjimų';

  @override
  String get perfStatDisconnections => 'Atsijungimų';

  @override
  String get perfStatNotEnoughGames => 'Žaista nepakankamai partijų';

  @override
  String perfStatHighestRating(String param) {
    return 'Aukščiausias reitingas: $param';
  }

  @override
  String perfStatLowestRating(String param) {
    return 'Žemiausias reitingas: $param';
  }

  @override
  String perfStatFromXToY(String param1, String param2) {
    return 'nuo $param1 iki $param2';
  }

  @override
  String get perfStatWinningStreak => 'Pergalių iš eilės';

  @override
  String get perfStatLosingStreak => 'Pralaimėjimų iš eilės';

  @override
  String perfStatLongestStreak(String param) {
    return 'Daugiausia iš eilės: $param';
  }

  @override
  String perfStatCurrentStreak(String param) {
    return 'Kol kas iš eilės: $param';
  }

  @override
  String get perfStatBestRated => 'Geriausios reitinguotos pergalės';

  @override
  String get perfStatGamesInARow => 'Partijų žaista iš eilės';

  @override
  String get perfStatLessThanOneHour => 'Mažiau negu valanda tarp partijų';

  @override
  String get perfStatMaxTimePlaying => 'Daugiausia laiko praleista žaidžiant';

  @override
  String get perfStatNow => 'dabar';

  @override
  String get preferencesPreferences => 'Nuostatos';

  @override
  String get preferencesDisplay => 'Rodymas';

  @override
  String get preferencesPrivacy => 'Privatumas';

  @override
  String get preferencesNotifications => 'Pranešimai';

  @override
  String get preferencesPieceAnimation => 'Figūrų animacija';

  @override
  String get preferencesMaterialDifference => 'Figūrų vertės skirtumas';

  @override
  String get preferencesBoardHighlights => 'Lentos paryškinimai (paskutinis ėjimas ir šachas)';

  @override
  String get preferencesPieceDestinations => 'Leistini (galimi) ėjimai';

  @override
  String get preferencesBoardCoordinates => 'Lentos koordinatės (A-H, 1-8)';

  @override
  String get preferencesMoveListWhilePlaying => 'Ėjimų sąrašas žaidžiant';

  @override
  String get preferencesPgnPieceNotation => 'Ėjimų žymėjimas';

  @override
  String get preferencesChessPieceSymbol => 'Šachmatų figūrų simboliai';

  @override
  String get preferencesPgnLetter => 'Raidės (K, Q, R, B, N)';

  @override
  String get preferencesZenMode => '„Zen“ režimas';

  @override
  String get preferencesShowPlayerRatings => 'Rodyti žaidėjų reitingus';

  @override
  String get preferencesShowFlairs => 'Show player flairs';

  @override
  String get preferencesExplainShowPlayerRatings => 'Tai leidžia iš svetainės paslėpti visus reitingus ir padeda susifokusuoti ties šachmatais. Partijos vis dar gali būti reitinguojamos. Šis pasirinkimas skirtas tik nustatyti, ką galite matyti.';

  @override
  String get preferencesDisplayBoardResizeHandle => 'Rodyti lentos dydžio keitimo simbolį';

  @override
  String get preferencesOnlyOnInitialPosition => 'Tik pradinėje padėtyje';

  @override
  String get preferencesInGameOnly => 'Tik žaidimo metu';

  @override
  String get preferencesChessClock => 'Žaidimo laikrodis';

  @override
  String get preferencesTenthsOfSeconds => 'Dešimtosios sekundės dalys';

  @override
  String get preferencesWhenTimeRemainingLessThanTenSeconds => 'Kai lieka mažiau nei 10 sekundžių';

  @override
  String get preferencesHorizontalGreenProgressBars => 'Horizontalios, žalios eigos juostos';

  @override
  String get preferencesSoundWhenTimeGetsCritical => 'Garsas pasiekus kritinę laiko ribą';

  @override
  String get preferencesGiveMoreTime => 'Duoti daugiau laiko';

  @override
  String get preferencesGameBehavior => 'Žaidimo elgsena';

  @override
  String get preferencesHowDoYouMovePieces => 'Kaip jūs darote ėjimus?';

  @override
  String get preferencesClickTwoSquares => 'Spustelėjant du langelius';

  @override
  String get preferencesDragPiece => 'Tempiant figūrą';

  @override
  String get preferencesBothClicksAndDrag => 'Abu';

  @override
  String get preferencesPremovesPlayingDuringOpponentTurn => 'Išankstiniai ėjimai (ėjimas varžovo ėjimo metu)';

  @override
  String get preferencesTakebacksWithOpponentApproval => 'Ėjimų atšaukimas (su varžovo sutikimu)';

  @override
  String get preferencesInCasualGamesOnly => 'Tik nevertinamose partijose';

  @override
  String get preferencesPromoteToQueenAutomatically => 'Automatiškai paaukštinti į valdovę';

  @override
  String get preferencesExplainPromoteToQueenAutomatically => 'Norėdami laikinai sulaikyti automatinį paaukšinimą paaušktindami laikykite <ctrl> klavišą';

  @override
  String get preferencesWhenPremoving => 'Per išankstinį ėjimą';

  @override
  String get preferencesClaimDrawOnThreefoldRepetitionAutomatically => 'Automatiškai įskaityti lygiąsias pozicijai pasikartojus tris kartus';

  @override
  String get preferencesWhenTimeRemainingLessThanThirtySeconds => 'Kai lieka mažiau nei 30 sekundžių';

  @override
  String get preferencesMoveConfirmation => 'Ėjimo patvirtinimas';

  @override
  String get preferencesExplainCanThenBeTemporarilyDisabled => 'Gali būti išjungta partijos metu per lentos meniu';

  @override
  String get preferencesInCorrespondenceGames => 'Korespondenciniuose';

  @override
  String get preferencesCorrespondenceAndUnlimited => 'Korespondenciniai ir neriboti';

  @override
  String get preferencesConfirmResignationAndDrawOffers => 'Patvirtinti pasidavimo ir lygiųjų pasiūlymus';

  @override
  String get preferencesCastleByMovingTheKingTwoSquaresOrOntoTheRook => 'Rokiruotės būdas';

  @override
  String get preferencesCastleByMovingTwoSquares => 'Eiti su karaliumi per du langelius';

  @override
  String get preferencesCastleByMovingOntoTheRook => 'Eiti su karaliumi ant bokšto';

  @override
  String get preferencesInputMovesWithTheKeyboard => 'Ėjimų įvedimas su klaviatūra';

  @override
  String get preferencesInputMovesWithVoice => 'Įvesti ėjimus balsu';

  @override
  String get preferencesSnapArrowsToValidMoves => 'Rodykles užfiksuoti ties leistinais ėjimais';

  @override
  String get preferencesSayGgWpAfterLosingOrDrawing => 'Nepamirškite nugalėti ar po lygiųjų pasakyti, \"Gera partija, ačiū\"';

  @override
  String get preferencesYourPreferencesHaveBeenSaved => 'Jūsų nuostatos buvo išsaugotos.';

  @override
  String get preferencesScrollOnTheBoardToReplayMoves => 'Sukite ratuką ant lentos norėdami dar kartą pamatyti ėjimus';

  @override
  String get preferencesCorrespondenceEmailNotification => 'Kasdieniame laiške pateikti korespondensinių žaidimų išrašus';

  @override
  String get preferencesNotifyStreamStart => 'Transliuotojas pradeda transliaciją';

  @override
  String get preferencesNotifyInboxMsg => 'Nauja žinutė';

  @override
  String get preferencesNotifyForumMention => 'Jūs paminėti forumo komentare';

  @override
  String get preferencesNotifyInvitedStudy => 'Studijos pakvietimas';

  @override
  String get preferencesNotifyGameEvent => 'Korespondencinių partijų naujienos';

  @override
  String get preferencesNotifyChallenge => 'Iššūkiai';

  @override
  String get preferencesNotifyTournamentSoon => 'Greitai prasideda turnyras';

  @override
  String get preferencesNotifyTimeAlarm => 'Baigiasi korespondencinės partijos laikmatis';

  @override
  String get preferencesNotifyBell => 'Varpelio pranešimai Lichess';

  @override
  String get preferencesNotifyPush => 'Pranešimai prietaisuose kai nesate Lichess';

  @override
  String get preferencesNotifyWeb => 'Naršyklėje';

  @override
  String get preferencesNotifyDevice => 'Įrenginyje';

  @override
  String get preferencesBellNotificationSound => 'Pranešimų varpelio garsas';

  @override
  String get puzzlePuzzles => 'Užduotys';

  @override
  String get puzzlePuzzleThemes => 'Užduočių temos';

  @override
  String get puzzleRecommended => 'Rekomenduojama';

  @override
  String get puzzlePhases => 'Fazės';

  @override
  String get puzzleMotifs => 'Motyvai';

  @override
  String get puzzleAdvanced => 'Pažengusiems';

  @override
  String get puzzleLengths => 'Ilgiai';

  @override
  String get puzzleMates => 'Matai';

  @override
  String get puzzleGoals => 'Tikslai';

  @override
  String get puzzleOrigin => 'Kilmė';

  @override
  String get puzzleSpecialMoves => 'Ypatingi ėjimai';

  @override
  String get puzzleDidYouLikeThisPuzzle => 'Ar jums patiko ši užduotis?';

  @override
  String get puzzleVoteToLoadNextOne => 'Nubalsuokite norėdami pakrauti kitą!';

  @override
  String get puzzleUpVote => 'Prabalsuoti už';

  @override
  String get puzzleDownVote => 'Prabalsuoti prieš';

  @override
  String get puzzleYourPuzzleRatingWillNotChange => 'Jūsų galvosūkių reitingas nesikeis. Pažymėtina, kad galvosūkiai nėra rungtynės. Reitingas padeda išrinkti tinkamiausius galvosūkius pagal jūsų gebėjimus.';

  @override
  String get puzzleFindTheBestMoveForWhite => 'Raskite geriausią ėjimą baltiems.';

  @override
  String get puzzleFindTheBestMoveForBlack => 'Raskite geriausią ėjimą juodiems.';

  @override
  String get puzzleToGetPersonalizedPuzzles => 'Norėdami gauti suasmenintas užduotis:';

  @override
  String puzzlePuzzleId(String param) {
    return 'Užduotis $param';
  }

  @override
  String get puzzlePuzzleOfTheDay => 'Dienos užduotis';

  @override
  String get puzzleDailyPuzzle => 'Dienos Galvosūkis';

  @override
  String get puzzleClickToSolve => 'Norėdami spręsti spustelkite';

  @override
  String get puzzleGoodMove => 'Geras ėjimas';

  @override
  String get puzzleBestMove => 'Geriausias ėjimas!';

  @override
  String get puzzleKeepGoing => 'Toliau…';

  @override
  String get puzzlePuzzleSuccess => 'Pavyko!';

  @override
  String get puzzlePuzzleComplete => 'Užduotis išspręsta!';

  @override
  String get puzzleByOpenings => 'Pagal debiutus';

  @override
  String get puzzlePuzzlesByOpenings => 'Galvosūkiai pagal debiutus';

  @override
  String get puzzleOpeningsYouPlayedTheMost => 'Debiutai, kuriuos žaidėte paskutinėse reitinguotose partijose';

  @override
  String get puzzleUseFindInPage => 'Naudokite \"Rasti puslapyje\" savo naršyklės meniu norėdami rasti savo mėgiamiausią debiutą!';

  @override
  String get puzzleUseCtrlF => 'Naudokite Ctrl+f norėdami rasti savo mėgiamiausią debiutą!';

  @override
  String get puzzleNotTheMove => 'Ne toks ėjimas!';

  @override
  String get puzzleTrySomethingElse => 'Bandykite kitką.';

  @override
  String puzzleRatingX(String param) {
    return 'Reitingas: $param';
  }

  @override
  String get puzzleHidden => 'paslėpta';

  @override
  String puzzleFromGameLink(String param) {
    return 'Iš žaidimo $param';
  }

  @override
  String get puzzleContinueTraining => 'Tęsti treniruotę';

  @override
  String get puzzleDifficultyLevel => 'Sudėtingumo lygis';

  @override
  String get puzzleNormal => 'Įprastas';

  @override
  String get puzzleEasier => 'Lengvesnis';

  @override
  String get puzzleEasiest => 'Lengviausias';

  @override
  String get puzzleHarder => 'Sunkesnis';

  @override
  String get puzzleHardest => 'Sunkiausias';

  @override
  String get puzzleExample => 'Pavyzdys';

  @override
  String get puzzleAddAnotherTheme => 'Pridėti dar vieną temą';

  @override
  String get puzzleNextPuzzle => 'Kitas uždavinys';

  @override
  String get puzzleJumpToNextPuzzleImmediately => 'Iš karto pereiti į kitą užduotį';

  @override
  String get puzzlePuzzleDashboard => 'Užduočių centras';

  @override
  String get puzzleImprovementAreas => 'Vietos tobulėjimui';

  @override
  String get puzzleStrengths => 'Striprybės';

  @override
  String get puzzleHistory => 'Užduočių istorija';

  @override
  String get puzzleSolved => 'išspręsta';

  @override
  String get puzzleFailed => 'nepavyko';

  @override
  String get puzzleStreakDescription => 'Spręskite vis sunkėjančias užduotis ir kaupkite pergalių seriją. Galite neskubėti, kadangi nėra laikrodžio. Vienas neteisingas ėjimas ir žaidimas baigtas! Per sesiją galite praleisti vieną ėjimą.';

  @override
  String puzzleYourStreakX(String param) {
    return 'Jūsų serija: $param';
  }

  @override
  String get puzzleStreakSkipExplanation => 'Praleiskite ėjimą norėdami išsaugoti savo seriją! Veikia tik vieną kartą per bandymą.';

  @override
  String get puzzleContinueTheStreak => 'Tęsti seriją';

  @override
  String get puzzleNewStreak => 'Nauja serija';

  @override
  String get puzzleFromMyGames => 'Iš mano partijų';

  @override
  String get puzzleLookupOfPlayer => 'Peržiūrėti galvosūkius iš žaidėjo partijų';

  @override
  String puzzleFromXGames(String param) {
    return 'Galvosūkiai iš \'$param\' partijų';
  }

  @override
  String get puzzleSearchPuzzles => 'Ieškoti galvosūkių';

  @override
  String get puzzleFromMyGamesNone => 'Jūs galvosūkių duomenų bazėje neturite, bet Lichess vis tiek jus labai myli.\nŽaiskite greituosius ir klasikinius žaidimus ir taip padidinkite šansus, kad bus pridėtas galvosūkis iš jūsų partijos!';

  @override
  String puzzleFromXGamesFound(String param1, String param2) {
    return '$param1 galvosūkių rasta $param2 partijose';
  }

  @override
  String get puzzlePuzzleDashboardDescription => 'Treniruokitės, analizuokite, tobulinkitės';

  @override
  String puzzlePercentSolved(String param) {
    return '$param išspręsta';
  }

  @override
  String get puzzleNoPuzzlesToShow => 'Nėra ką rodyti, pirma išspręskite galvosūkių!';

  @override
  String get puzzleImprovementAreasDescription => 'Treniruokitės su šiomis norėdami pagerinti savo progresą!';

  @override
  String get puzzleStrengthDescription => 'Jums geriausiai sekasi šiose temose';

  @override
  String puzzlePlayedXTimes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Žaista $count kartų',
      many: 'Žaista $count kartą',
      few: 'Žaista $count kartus',
      one: 'Žaista $count kartą',
    );
    return '$_temp0';
  }

  @override
  String puzzleNbPointsBelowYourPuzzleRating(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count taškų aukščiau jūsų užduočių reitingo',
      many: '$count taško aukščiau jūsų užduočių reitingo',
      few: '$count taškais aukščiau jūsų užduočių reitingo',
      one: 'Vienu tašku aukščiau jūsų užduočių reitingo',
    );
    return '$_temp0';
  }

  @override
  String puzzleNbPointsAboveYourPuzzleRating(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count taškų aukščiau jūsų užduočių reitingo',
      many: '$count taško aukščiau jūsų užduočių reitingo',
      few: '$count taškais aukščiau jūsų užduočių reitingo',
      one: 'Vienu tašku aukščiau jūsų užduočių reitingo',
    );
    return '$_temp0';
  }

  @override
  String puzzleNbPlayed(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count sužaista',
      many: '$count sužaista',
      few: '$count sužaisti',
      one: '$count sužaistas',
    );
    return '$_temp0';
  }

  @override
  String puzzleNbToReplay(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count sužaisti',
      many: '$count sužaisti',
      few: '$count sužaisti',
      one: '$count sužaisti',
    );
    return '$_temp0';
  }

  @override
  String get puzzleThemeAdvancedPawn => 'Pažengęs pėstininkas';

  @override
  String get puzzleThemeAdvancedPawnDescription => 'Pėstininkas, kuris keičiamas kita figūra, ar tuoj tai darys, čia yra esminė taktika.';

  @override
  String get puzzleThemeAdvantage => 'Pranašumas';

  @override
  String get puzzleThemeAdvantageDescription => 'Pasinaudokite proga įgauti esminį pranašumą. (200cp ≤ eval ≤ 600cp)';

  @override
  String get puzzleThemeAnastasiaMate => 'Anastasijos matas';

  @override
  String get puzzleThemeAnastasiaMateDescription => 'Žirgas ir valdovė arba bokštas bendromis jėgomis įkalina priešininko karalių tarp lentos krašto ir kitos figūros.';

  @override
  String get puzzleThemeArabianMate => 'Arabiškasis matas';

  @override
  String get puzzleThemeArabianMateDescription => 'Žirgas ir bokštas suvienija jėgas įkalindami priešininko karalių lentos kampe.';

  @override
  String get puzzleThemeAttackingF2F7 => 'f2 arba f7 puolimas';

  @override
  String get puzzleThemeAttackingF2F7Description => 'Puolimas, koncentruotas ties f2 ar f7 pėstininkais, panašiai kaip keptų kepenų debiute.';

  @override
  String get puzzleThemeAttraction => 'Trauka';

  @override
  String get puzzleThemeAttractionDescription => 'Apsikeitimas ar paaukojimas, skatinantis ar priverčiantis priešininko figūrą pajudėti į langelį, kuris leidžia kitą taktiką.';

  @override
  String get puzzleThemeBackRankMate => 'Paskutinės eilės matas';

  @override
  String get puzzleThemeBackRankMateDescription => 'Matas karaliui, esančiam namų eilėje, kai jis užblokuotas savo paties figūrų.';

  @override
  String get puzzleThemeBishopEndgame => 'Rikių endšpilis';

  @override
  String get puzzleThemeBishopEndgameDescription => 'Endšpilis tik su rikiais ir pėstininkais.';

  @override
  String get puzzleThemeBodenMate => 'Bodeno matas';

  @override
  String get puzzleThemeBodenMateDescription => 'Du puolantys rikiai susikryžiojančiose įstrižainėse atlieka matą priešininko karaliui, įkalintam draugiškų figūrų.';

  @override
  String get puzzleThemeCastling => 'Rokiruotės';

  @override
  String get puzzleThemeCastlingDescription => 'Parveskite karalių į saugią vietą ir panaudokite atakai bokštą.';

  @override
  String get puzzleThemeCapturingDefender => 'Nukirskite gynėją';

  @override
  String get puzzleThemeCapturingDefenderDescription => 'Pašalinkite figūrą, kuri yra kritiškai svarbi kitos figūros gynybai, paruošdami naujai neapsaugotą figūrą kirtimui kitu ėjimu.';

  @override
  String get puzzleThemeCrushing => 'Suspaudimas';

  @override
  String get puzzleThemeCrushingDescription => 'Pastebėkite priešininko klaidą ir įgaukite ryškią persvarą. (eval ≥ 600cp)';

  @override
  String get puzzleThemeDoubleBishopMate => 'Dvigubų rikių matas';

  @override
  String get puzzleThemeDoubleBishopMateDescription => 'Du gretimose įstrižainėse puolantys rikiai atlieka matą priešininko karaliui, įkalintam draugiškų figūrų.';

  @override
  String get puzzleThemeDovetailMate => 'Kozio matas';

  @override
  String get puzzleThemeDovetailMateDescription => 'Valdovė atlieka matą greta esančiam priešininko karaliui, kurio vieninteliai pabėgimo langeliai užimti draugiškų figūrų.';

  @override
  String get puzzleThemeEquality => 'Lygybė';

  @override
  String get puzzleThemeEqualityDescription => 'Grįžkite iš pralaiminčios pozicijos ir užsitikrinkite lygiąsias arba balansuotą poziciją. (eval ≤ 200cp)';

  @override
  String get puzzleThemeKingsideAttack => 'Karaliaus pusės ataka';

  @override
  String get puzzleThemeKingsideAttackDescription => 'Ataka į priešininko karalių po to, kai jis rokiravosi karaliaus pusėje.';

  @override
  String get puzzleThemeClearance => 'Išvalymas';

  @override
  String get puzzleThemeClearanceDescription => 'Ėjimas, dažnai su tempu, kuris išvalo langelį, eilutę ar įstrižainę kitai taktinei idėjai.';

  @override
  String get puzzleThemeDefensiveMove => 'Apsisaugantis ėjimas';

  @override
  String get puzzleThemeDefensiveMoveDescription => 'Tikslus ėjimas ar ėjimų seka kuri skirta išvengti figūrų praradimo ar kito priešininko pranašumo.';

  @override
  String get puzzleThemeDeflection => 'Atmušimas';

  @override
  String get puzzleThemeDeflectionDescription => 'Ėjimas, kuris nukreipia priešininko figūros dėmesį nuo kitos svarbios jos rolės, pavyzdžiui: langelio šalia karaliaus saugojimo.';

  @override
  String get puzzleThemeDiscoveredAttack => 'Atidengimo ataka';

  @override
  String get puzzleThemeDiscoveredAttackDescription => 'Blokuojančios figūros patraukimas nuo ilgų distancijų figūros, pavyzdžiui žirgo patraukimas nuo bokšto trajektorijos.';

  @override
  String get puzzleThemeDoubleCheck => 'Dvigubas šachas';

  @override
  String get puzzleThemeDoubleCheckDescription => 'Šachas dviem figūrom vienu metu. Įvyksta po atidengimo atakos, kai ir perkelta figūra ir atidengta figūra puola priešininko karalių.';

  @override
  String get puzzleThemeEndgame => 'Endšpilis';

  @override
  String get puzzleThemeEndgameDescription => 'Taktika, skirta paskutinei žaidimo fazei.';

  @override
  String get puzzleThemeEnPassantDescription => 'Taktika susijusi su kirtimu prasilenkiant (en passant). Pėstininkas gali nukirsti priešininko pėstininką, kuris \"aplenkė\" pirmąjį perkeltas per du langelius.';

  @override
  String get puzzleThemeExposedKing => 'Atidengtas karalius';

  @override
  String get puzzleThemeExposedKingDescription => 'Taktika, susijusi su karaliumi, kuris neturi daug gynejų aplink save. Tai dažnai priveda prie mato.';

  @override
  String get puzzleThemeFork => 'Šakutė';

  @override
  String get puzzleThemeForkDescription => 'Ėjimas, kurio metu perkelta figūra puola dvi ar daugiau priešininko figūrų vienu metu.';

  @override
  String get puzzleThemeHangingPiece => 'Kabanti figūra';

  @override
  String get puzzleThemeHangingPieceDescription => 'Taktika, susijusi su neapginta ar nepakankamai apginta ir lengvai nukertama priešininko figūra.';

  @override
  String get puzzleThemeHookMate => 'Kablio matas';

  @override
  String get puzzleThemeHookMateDescription => 'Matas su bokštu, žirgu ir pėstininku palei vieną iš priešininko pėstininkų, apribojančių priešininko karaliaus pabėgimą.';

  @override
  String get puzzleThemeInterference => 'Trukdymas';

  @override
  String get puzzleThemeInterferenceDescription => 'Figūros perkėlimas tarp dviejų priešininko figūrų, paliekant vieną ar abi jų neapgintas. Pavyzdžiui: perkeliant žirgą į apgintą laukelį tarp dviejų bokštų.';

  @override
  String get puzzleThemeIntermezzo => 'Tarpinis ėjimas';

  @override
  String get puzzleThemeIntermezzoDescription => 'Vietoje to, kad būtų padarytas ėjimas, kurio tikėtasi, įterpiamas kitas ėjimas, kuris apgaulingai pateikiamas kaip staigi ataka priešininkui, į kurią jis turi atsakyti. Dar žinomas kaip \"intermezzo\" ar \"zwischenzug\".';

  @override
  String get puzzleThemeKnightEndgame => 'Žirgų endšpilis';

  @override
  String get puzzleThemeKnightEndgameDescription => 'Endšpilis tik su žirgais ir pėstininkais.';

  @override
  String get puzzleThemeLong => 'Ilgas galvosūkis';

  @override
  String get puzzleThemeLongDescription => 'Trys ėjimai laimėti.';

  @override
  String get puzzleThemeMaster => 'Meistrų partijos';

  @override
  String get puzzleThemeMasterDescription => 'Užduotys iš tituluotų žaidėjų partijų.';

  @override
  String get puzzleThemeMasterVsMaster => 'Meistrų prieš meistrus partijos';

  @override
  String get puzzleThemeMasterVsMasterDescription => 'Užduotys iš partijų tarp tituluotų žaidėjų.';

  @override
  String get puzzleThemeMate => 'Matas';

  @override
  String get puzzleThemeMateDescription => 'Laimėkite žaidimą su klase.';

  @override
  String get puzzleThemeMateIn1 => 'Matas vienu ėjimu';

  @override
  String get puzzleThemeMateIn1Description => 'Atlikite matą vienu ėjimu.';

  @override
  String get puzzleThemeMateIn2 => 'Matas dviem ėjimais';

  @override
  String get puzzleThemeMateIn2Description => 'Atlikite matą dviem ėjimais.';

  @override
  String get puzzleThemeMateIn3 => 'Matas trimis ėjimais';

  @override
  String get puzzleThemeMateIn3Description => 'Atlikite matą trimis ėjimais.';

  @override
  String get puzzleThemeMateIn4 => 'Matas keturiais ėjimais';

  @override
  String get puzzleThemeMateIn4Description => 'Atlikite matą keturiais ėjimais.';

  @override
  String get puzzleThemeMateIn5 => 'Matas penkiais ar daugiau ėjimų';

  @override
  String get puzzleThemeMateIn5Description => 'Atskleiskite ilgą seką vedančią iki mato.';

  @override
  String get puzzleThemeMiddlegame => 'Mitelšpilis';

  @override
  String get puzzleThemeMiddlegameDescription => 'Taktikos skirtos antrai žaidimo fazei.';

  @override
  String get puzzleThemeOneMove => 'Vieno ėjimo galvosūkiai';

  @override
  String get puzzleThemeOneMoveDescription => 'Tik vieno ėjimo galvosūkiai.';

  @override
  String get puzzleThemeOpening => 'Debiutai';

  @override
  String get puzzleThemeOpeningDescription => 'Taktika, kuri galioja pirmoje žaidimo fazėje.';

  @override
  String get puzzleThemePawnEndgame => 'Pėstininkų endšpilis';

  @override
  String get puzzleThemePawnEndgameDescription => 'Endšpilis tik su pėstininkais.';

  @override
  String get puzzleThemePin => 'Surišimas';

  @override
  String get puzzleThemePinDescription => 'Taktika susijusi su surišimais, kai figūra negali pajudėti neatidengdama atakos į kitą, vertingesnę figūrą.';

  @override
  String get puzzleThemePromotion => 'Paaukštinimas';

  @override
  String get puzzleThemePromotionDescription => 'Pėstininkas, kuris pasiaukština ar kėsinasi pasiaukštinti yra raktas šiai taktikai.';

  @override
  String get puzzleThemeQueenEndgame => 'Valdovės endšpilis';

  @override
  String get puzzleThemeQueenEndgameDescription => 'Endšpilis tik su valdovėmis ir pėstininkais.';

  @override
  String get puzzleThemeQueenRookEndgame => 'Valdovės ir bokšto endšpilis';

  @override
  String get puzzleThemeQueenRookEndgameDescription => 'Endšpilis tik su valdovėmis, bokštais ir pėstininkais.';

  @override
  String get puzzleThemeQueensideAttack => 'Valdovės pusės ataka';

  @override
  String get puzzleThemeQueensideAttackDescription => 'Ataka priešininko karaliui po to, kai jis atliko rokiruotę valdovės pusėje.';

  @override
  String get puzzleThemeQuietMove => 'Tylus ėjimas';

  @override
  String get puzzleThemeQuietMoveDescription => 'Ėjimas, kuris nei atlieka šachą, nei kerta, tačiau paruošia neišvengiamam pavojui vėliasneme ėjime.';

  @override
  String get puzzleThemeRookEndgame => 'Bokštų endšpilis';

  @override
  String get puzzleThemeRookEndgameDescription => 'Endšpilis tik su bokštais ir pėstininkais.';

  @override
  String get puzzleThemeSacrifice => 'Auka';

  @override
  String get puzzleThemeSacrificeDescription => 'Taktika, susijusi su figūrų atidavimu dabar, bei gautu pranašumu vėliau po priverstų ėjimų sekos.';

  @override
  String get puzzleThemeShort => 'Trumpas galvosūkis';

  @override
  String get puzzleThemeShortDescription => 'Du ėjimai laimėti.';

  @override
  String get puzzleThemeSkewer => 'Pradūrimas';

  @override
  String get puzzleThemeSkewerDescription => 'Motyvas įtraukiantis brangią figūrą, kuri puolama. Jai pasitraukiant atveriamas kelias nukirsti už jos stovinčią mažiau brangią figūrą.';

  @override
  String get puzzleThemeSmotheredMate => 'Uždusintas matas';

  @override
  String get puzzleThemeSmotheredMateDescription => 'Matas, kurį atlieka žirgas, kai matuojamas karalius negali pajudėti nes yra apsuptas savo paties figūrų.';

  @override
  String get puzzleThemeSuperGM => 'Super GM partijos';

  @override
  String get puzzleThemeSuperGMDescription => 'Užduotys iš partijų, kurias žaidė geriausi pasaulio žaidėjai.';

  @override
  String get puzzleThemeTrappedPiece => 'Įkalinta figūra';

  @override
  String get puzzleThemeTrappedPieceDescription => 'Figūra negali pabėgti, nes turi ribotą skaičių ėjimų.';

  @override
  String get puzzleThemeUnderPromotion => 'Žemesnis paaukštinimas';

  @override
  String get puzzleThemeUnderPromotionDescription => 'Paaukštinimas į žirgą, rikį ar bokštą.';

  @override
  String get puzzleThemeVeryLong => 'Labai ilgas galvosūkis';

  @override
  String get puzzleThemeVeryLongDescription => 'Keturi ar daugiau ėjimai laimėti.';

  @override
  String get puzzleThemeXRayAttack => 'Spindulio ataka';

  @override
  String get puzzleThemeXRayAttackDescription => 'Figūra puola ar gina laukelį kiaurai priešininko figūros.';

  @override
  String get puzzleThemeZugzwang => 'Priverstinis ėjimas';

  @override
  String get puzzleThemeZugzwangDescription => 'Priešininkas apribotas ėjimais, kuriuos gali padaryti, ir visi jo ėjimai tik pabloginą jo poziciją.';

  @override
  String get puzzleThemeHealthyMix => 'Visko po truputį';

  @override
  String get puzzleThemeHealthyMixDescription => 'Nežinote ko tikėtis, todėl būkite pasiruošę bet kam! Visai kaip tikruose žaidimuose.';

  @override
  String get puzzleThemePlayerGames => 'Žaidėjų žaidimai';

  @override
  String get puzzleThemePlayerGamesDescription => 'Galvosūkiai sugeneruoti iš jūsų partijų ar iš kitų žaidėjų partijų.';

  @override
  String puzzleThemePuzzleDownloadInformation(String param) {
    return 'Šie galvosūkiai yra laisvai prieinami ir gali būti parsisiųsti iš $param.';
  }

  @override
  String get searchSearch => 'Ieškoti';

  @override
  String get settingsSettings => 'Nuostatos';

  @override
  String get settingsCloseAccount => 'Uždaryti paskyrą';

  @override
  String get settingsManagedAccountCannotBeClosed => 'Jūsų paskyra yra valdoma ir negali būti uždaryta.';

  @override
  String get settingsClosingIsDefinitive => 'Uždarymas yra galutinis. Kelio atgal nebus. Ar tikrai to norite?';

  @override
  String get settingsCantOpenSimilarAccount => 'Negalėsite susikurti kitos paskyros su tokiu pačiu vardu, net jeigu skirsis didžiosios / mažosios raidės.';

  @override
  String get settingsChangedMindDoNotCloseAccount => 'Persigalvojau, neuždarykite mano paskyros';

  @override
  String get settingsCloseAccountExplanation => 'Ar tikrai norite uždaryti savo paskyrą? Uždarymas yra galutinis veiksmas. Daugiau NIEKADA nebegalėsite prisijungti.';

  @override
  String get settingsThisAccountIsClosed => 'Ši paskyra uždaryta.';

  @override
  String get playWithAFriend => 'Žaisti su draugu';

  @override
  String get playWithTheMachine => 'Žaisti su kompiuteriu';

  @override
  String get toInviteSomeoneToPlayGiveThisUrl => 'Norėdami pakviesti varžovą, pasidalinkite šiuo adresu';

  @override
  String get gameOver => 'Partija baigta';

  @override
  String get waitingForOpponent => 'Laukiama varžovo';

  @override
  String get orLetYourOpponentScanQrCode => 'Arba leiskite priešininkui nuskanuoti šį QR kodą';

  @override
  String get waiting => 'Laukiama';

  @override
  String get yourTurn => 'Jūsų ėjimas';

  @override
  String aiNameLevelAiLevel(String param1, String param2) {
    return '$param1 lygis Nr. $param2';
  }

  @override
  String get level => 'Lygis';

  @override
  String get strength => 'Stiprumas';

  @override
  String get toggleTheChat => 'Įjungti / išjungti pokalbį';

  @override
  String get chat => 'Pokalbis';

  @override
  String get resign => 'Pasiduoti';

  @override
  String get checkmate => 'Šachas ir matas';

  @override
  String get stalemate => 'Patas';

  @override
  String get white => 'Baltieji';

  @override
  String get black => 'Juodieji';

  @override
  String get asWhite => 'kaip baltieji';

  @override
  String get asBlack => 'kaip juodieji';

  @override
  String get randomColor => 'Atsitiktinė spalva';

  @override
  String get createAGame => 'Kurti žaidimą';

  @override
  String get whiteIsVictorious => 'Baltieji laimėjo';

  @override
  String get blackIsVictorious => 'Juodieji laimėjo';

  @override
  String get youPlayTheWhitePieces => 'Žaidžiate baltomis figūromis';

  @override
  String get youPlayTheBlackPieces => 'Žaidžiate juodomis figūromis';

  @override
  String get itsYourTurn => 'Jūsų ėjimas!';

  @override
  String get cheatDetected => 'Aptiktas sukčiavimas';

  @override
  String get kingInTheCenter => 'Karalius centre';

  @override
  String get threeChecks => 'Trys šachai';

  @override
  String get raceFinished => 'Lenktynės baigėsi';

  @override
  String get variantEnding => 'Variantinė pabaiga';

  @override
  String get newOpponent => 'Naujas varžovas';

  @override
  String get yourOpponentWantsToPlayANewGameWithYou => 'Jūsų varžovas norėtų sužaisti dar kartą';

  @override
  String get joinTheGame => 'Prisijungti prie žaidimo';

  @override
  String get whitePlays => 'Baltųjų ėjimas';

  @override
  String get blackPlays => 'Juodųjų ėjimas';

  @override
  String get opponentLeftChoices => 'Panašu, kad varžovas paliko žaidimą. Galite pasiimti pergalę, lygiąsias, arba palaukti.';

  @override
  String get forceResignation => 'Pasiimti pergalę';

  @override
  String get forceDraw => 'Įskaityti lygiąsias';

  @override
  String get talkInChat => 'Pokalbyje būkite malonūs!';

  @override
  String get theFirstPersonToComeOnThisUrlWillPlayWithYou => 'Pirmasis šiuo adresu atėjęs žmogus taps jūsų varžovu.';

  @override
  String get whiteResigned => 'Baltieji pasidavė';

  @override
  String get blackResigned => 'Juodieji pasidavė';

  @override
  String get whiteLeftTheGame => 'Baltieji paliko žaidimą';

  @override
  String get blackLeftTheGame => 'Juodieji paliko žaidimą';

  @override
  String get whiteDidntMove => 'Baltieji nepajudėjo';

  @override
  String get blackDidntMove => 'Juodieji nepajudėjo';

  @override
  String get requestAComputerAnalysis => 'Užsakyti kompiuterio analizę';

  @override
  String get computerAnalysis => 'Kompiuterio analizė';

  @override
  String get computerAnalysisAvailable => 'Galima kompiuterio analizė';

  @override
  String get computerAnalysisDisabled => 'Kompiuterinė analizė išjungta';

  @override
  String get analysis => 'Analizės lenta';

  @override
  String depthX(String param) {
    return 'Gylis: $param';
  }

  @override
  String get usingServerAnalysis => 'Naudojama serverio analizė';

  @override
  String get loadingEngine => 'Įkeliamas variklis...';

  @override
  String get calculatingMoves => 'Apskaičiuojami ėjimai...';

  @override
  String get engineFailed => 'Klaida kraunant variklį';

  @override
  String get cloudAnalysis => 'Analizė debesyje';

  @override
  String get goDeeper => 'Eiti gilyn';

  @override
  String get showThreat => 'Rodyti grėsmę';

  @override
  String get inLocalBrowser => 'vietinėje naršyklėje';

  @override
  String get toggleLocalEvaluation => 'Perjungti vietinį įvertinimą';

  @override
  String get promoteVariation => 'Paaukštinimo varijacija';

  @override
  String get makeMainLine => 'Padaryti pagrindine linija';

  @override
  String get deleteFromHere => 'Ištrinti nuo čia';

  @override
  String get collapseVariations => 'Collapse variations';

  @override
  String get expandVariations => 'Expand variations';

  @override
  String get forceVariation => 'Rodyti kaip variaciją';

  @override
  String get copyVariationPgn => 'Kopijuoti variacijos PGN';

  @override
  String get move => 'Ėjimas';

  @override
  String get variantLoss => 'Variantinis pralaimėjimas';

  @override
  String get variantWin => 'Variantinė pergalė';

  @override
  String get insufficientMaterial => 'Nepakanka figūrų vertės';

  @override
  String get pawnMove => 'Ėjimas pėstininku';

  @override
  String get capture => 'Kirtimas';

  @override
  String get close => 'Užverti';

  @override
  String get winning => 'Laimintis';

  @override
  String get losing => 'Pralaimintis';

  @override
  String get drawn => 'Lygiosios';

  @override
  String get unknown => 'Nežinomas';

  @override
  String get database => 'Duomenų bazė';

  @override
  String get whiteDrawBlack => 'Baltieji / Lygiosios / Juodieji';

  @override
  String averageRatingX(String param) {
    return 'Vidutinis reitingas: $param';
  }

  @override
  String get recentGames => 'Paskiausios partijos';

  @override
  String get topGames => 'Geriausios partijos';

  @override
  String masterDbExplanation(String param1, String param2, String param3) {
    return 'Du milijonai OTB (prie lentos) partijų, sužaistų $param1+ FIDE vertinamų žaidėjų, nuo $param2 iki $param3 m.';
  }

  @override
  String get dtzWithRounding => 'DTZ50\" su apvalinimu remiantis pusėjimių iki kito kirtimo ar pėstininko ėjimo skaičiumi';

  @override
  String get noGameFound => 'Partijų nerasta';

  @override
  String get maxDepthReached => 'Pasiektas didžiausias gylis!';

  @override
  String get maybeIncludeMoreGamesFromThePreferencesMenu => 'Galbūt įtraukti daugiau partijų iš parinkčių meniu?';

  @override
  String get openings => 'Debiutai';

  @override
  String get openingExplorer => 'Debiutų naršyklė';

  @override
  String get openingEndgameExplorer => 'Debiutų/endšpilių naršyklė';

  @override
  String xOpeningExplorer(String param) {
    return '$param debiutų naršyklė';
  }

  @override
  String get playFirstOpeningEndgameExplorerMove => 'Žaisti pirmą debiuto/endšpilių naršyklės ėjimą';

  @override
  String get winPreventedBy50MoveRule => 'Pergalei sukliudė 50-ies ėjimų taisyklė';

  @override
  String get lossSavedBy50MoveRule => 'Pralaimėjimo išvengta dėl 50-ies ėjimų taisyklės';

  @override
  String get winOr50MovesByPriorMistake => 'Pergalė arba 50 ėjimų pagal ankstesnę klaidą';

  @override
  String get lossOr50MovesByPriorMistake => 'Pralaimėjimas arba 50 ėjimų pagal ankstesnę klaidą';

  @override
  String get unknownDueToRounding => 'Pergalė/pralaimėjimas dėl galimo apvalinimo garantuojami jei rekomenduojama linija iš duomenų bazės buvo sekama nuo paskutinio kirtimo ar pėstininko ėjimo.';

  @override
  String get allSet => 'Viskas paruošta!';

  @override
  String get importPgn => 'Įkelti PGN';

  @override
  String get delete => 'Šalinti';

  @override
  String get deleteThisImportedGame => 'Pašalinti šią importuotą partiją?';

  @override
  String get replayMode => 'Peržiūros režimas';

  @override
  String get realtimeReplay => 'Realiu laiku';

  @override
  String get byCPL => 'Pagal įvertį';

  @override
  String get openStudy => 'Atverti studiją';

  @override
  String get enable => 'Įjungti';

  @override
  String get bestMoveArrow => 'Geriausio ėjimo rodyklė';

  @override
  String get showVariationArrows => 'Rodyti variacijų rodykles';

  @override
  String get evaluationGauge => 'Vertinimo matuoklis';

  @override
  String get multipleLines => 'Keletas linijų';

  @override
  String get cpus => 'Procesoriai';

  @override
  String get memory => 'Atmintinė';

  @override
  String get infiniteAnalysis => 'Neribota analizė';

  @override
  String get removesTheDepthLimit => 'Panaikina gylio limitą ir neleidžia kompiuteriui atvėsti';

  @override
  String get engineManager => 'Variklių valdymas';

  @override
  String get blunder => 'Šiurkšti klaida';

  @override
  String get mistake => 'Klaida';

  @override
  String get inaccuracy => 'Netikslumas';

  @override
  String get moveTimes => 'Ėjimų trukmė';

  @override
  String get flipBoard => 'Apsukti lentą';

  @override
  String get threefoldRepetition => 'Pozicijos pasikartojimas tris kartus';

  @override
  String get claimADraw => 'Įskaityti lygiąsias';

  @override
  String get offerDraw => 'Siūlyti lygiąsias';

  @override
  String get draw => 'Lygiosios';

  @override
  String get drawByMutualAgreement => 'Lygiosios sutarimu';

  @override
  String get fiftyMovesWithoutProgress => 'Penkiasdešimt ėjimų be progreso';

  @override
  String get currentGames => 'Vykstančios partijos';

  @override
  String get viewInFullSize => 'Žiūrėti visu dydžiu';

  @override
  String get logOut => 'Atsijungti';

  @override
  String get signIn => 'Prisijungti';

  @override
  String get rememberMe => 'Likti prisijungus';

  @override
  String get youNeedAnAccountToDoThat => 'Norėdami tai atlikti, turite turėti paskyrą';

  @override
  String get signUp => 'Registruotis';

  @override
  String get computersAreNotAllowedToPlay => 'Kompiuteriams ir kompiuterių padedamiems žaidėjams žaisti draudžiama. Prašome nesinaudoti šachmatų programomis, duomenų bazėmis ar kitų žaidėjų pagalba partijos metu. Kartu norime pažymėti, kad keleto paskyrų turėjimas yra nepatartinas, o dėl perdėto jų naudojimo būsite užblokuoti.';

  @override
  String get games => 'Partijos';

  @override
  String get forum => 'Diskusijos';

  @override
  String xPostedInForumY(String param1, String param2) {
    return '$param1 parašė temoje „$param2“';
  }

  @override
  String get latestForumPosts => 'Naujausi diskusijų pranešimai';

  @override
  String get players => 'Žaidėjai';

  @override
  String get friends => 'Draugai';

  @override
  String get discussions => 'Diskusijos';

  @override
  String get today => 'Šiandien';

  @override
  String get yesterday => 'Vakar';

  @override
  String get minutesPerSide => 'Minučių žaidėjui';

  @override
  String get variant => 'Variantas';

  @override
  String get variants => 'Variantai';

  @override
  String get timeControl => 'Laiko kontrolė';

  @override
  String get realTime => 'Realiu laiku';

  @override
  String get correspondence => 'Korespondencija';

  @override
  String get daysPerTurn => 'Dienų ėjimui';

  @override
  String get oneDay => 'Viena diena';

  @override
  String get time => 'Laikas';

  @override
  String get rating => 'Reitingas';

  @override
  String get ratingStats => 'Reitingų statistika';

  @override
  String get username => 'Vartotojo vardas';

  @override
  String get usernameOrEmail => 'Vartotojo vardas ar el. pašto adresas';

  @override
  String get changeUsername => 'Keisti vartotojo vardą';

  @override
  String get changeUsernameNotSame => 'Galima keisti tik raidžių dydį. Pvz., „vardaspav“ į „VardasPav“.';

  @override
  String get changeUsernameDescription => 'Pasikeiskite naudotojo vardą. Tai gali būti atlikta tik kartą, ir keisti galite tik raidžių dydį.';

  @override
  String get signupUsernameHint => 'Įsitikinkite, kad jūsų vartotojo vardas yra tinkamas visų amžių auditorijai. Jo vėliau pasikeisti negalėsite. Bet kokie netinkami vartotojų vardai bus uždaryti!';

  @override
  String get signupEmailHint => 'Jį naudosime tik atkurti slaptažodžiui.';

  @override
  String get password => 'Slaptažodis';

  @override
  String get changePassword => 'Keisti slaptažodį';

  @override
  String get changeEmail => 'Keisti el. pašto adresą';

  @override
  String get email => 'El. pašto adresas';

  @override
  String get passwordReset => 'Slaptažodžio atkūrimas';

  @override
  String get forgotPassword => 'Pamiršote slaptažodį?';

  @override
  String get error_weakPassword => 'Šis slaptažodis itin dažnas ir jį pernelyg lengva atspėti.';

  @override
  String get error_namePassword => 'Prašome nenaudoti savo vartotojo vardo kaip slaptažodžio.';

  @override
  String get blankedPassword => 'Jūs jau panaudojote šį slaptažodį kitoje svetainėje, kurios saugumas buvo pažeistas. Norėdami užtikrinti jūsų Lichess paskyros saugumą turime paprašyti nustatyti naują slaptažodį. Dėkojame už supratingumą.';

  @override
  String get youAreLeavingLichess => 'Jūs paliekate Lichess';

  @override
  String get neverTypeYourPassword => 'Niekada netalpinkite savo Lichess slaptažodžio kitoje svetainėje!';

  @override
  String proceedToX(String param) {
    return 'Eiti į $param';
  }

  @override
  String get passwordSuggestion => 'Nenaudokite slaptažodžio, kurį jums pasiūlė kas nors kitas. Tuo galima pasinaudoti pavogiant jūsų paskyrą.';

  @override
  String get emailSuggestion => 'Nenaudokite el. pašto adreso, kurį jums pasiūlė kas nors kitas. Tuo galima pasinaudoti pavogiant jūsų paskyrą.';

  @override
  String get emailConfirmHelp => 'Pagalba dėl el. pašto adreso patvirtinimo';

  @override
  String get emailConfirmNotReceived => 'Prisijungę negavote savo patvirtinimo el. laiško?';

  @override
  String get whatSignupUsername => 'Kokiu vartotojo vardu registravotės?';

  @override
  String usernameNotFound(String param) {
    return 'Nepavyko rasti vartotojo šiuo vardu: $param.';
  }

  @override
  String get usernameCanBeUsedForNewAccount => 'Galite naudoti šį vartotojo vardą susikurdami naują paskyrą';

  @override
  String emailSent(String param) {
    return 'Išsiuntėme el. laišką į $param.';
  }

  @override
  String get emailCanTakeSomeTime => 'Atvykimas gali šiek tiek užtrukti.';

  @override
  String get refreshInboxAfterFiveMinutes => 'Palaukite penkias minutes ir atnaujinkite savo el. pašto dėžutę.';

  @override
  String get checkSpamFolder => 'Pasitikrinkite šlamtšo aplanką, laiškas galėjo atsirasti ir ten. Jei taip įvyko - pažymėkite kaip ne šlamštą.';

  @override
  String get emailForSignupHelp => 'Jei niekas nepavyko, atsiųskite mums tokį laišką:';

  @override
  String copyTextToEmail(String param) {
    return 'Nukopijuokite tekstą viršuje ir atsiųskite į $param';
  }

  @override
  String get waitForSignupHelp => 'Ne už ilgo susisieksime su jumis ir padėsime užbaigti prisijungimo procesą.';

  @override
  String accountConfirmed(String param) {
    return 'Vartotojas $param sėkmingai patvirtintas.';
  }

  @override
  String accountCanLogin(String param) {
    return 'Šiuo metu negalite prisijungti kaip $param.';
  }

  @override
  String get accountConfirmationEmailNotNeeded => 'Jums nereikia patvirtinimo laiško.';

  @override
  String accountClosed(String param) {
    return 'Paskyra $param - uždaryta.';
  }

  @override
  String accountRegisteredWithoutEmail(String param) {
    return 'Paskyra $param buvo sukurta su el. pašto adresu.';
  }

  @override
  String get rank => 'Rangas';

  @override
  String rankX(String param) {
    return 'Reitingas: $param';
  }

  @override
  String get gamesPlayed => 'sužaistos partijos';

  @override
  String get cancel => 'Atšaukti';

  @override
  String get whiteTimeOut => 'Baigėsi laikas baltiesiems';

  @override
  String get blackTimeOut => 'Baigėsi laikas juodiesiems';

  @override
  String get drawOfferSent => 'Lygiųjų pasiūlymas išsiųstas';

  @override
  String get drawOfferAccepted => 'Lygiųjų pasiūlymas priimtas';

  @override
  String get drawOfferCanceled => 'Lygiųjų pasiūlymas atšauktas';

  @override
  String get whiteOffersDraw => 'Baltieji siūlo lygiąsias';

  @override
  String get blackOffersDraw => 'Juodieji siūlo lygiąsias';

  @override
  String get whiteDeclinesDraw => 'Baltieji atsisako lygiųjų';

  @override
  String get blackDeclinesDraw => 'Juodieji atsisako lygiųjų';

  @override
  String get yourOpponentOffersADraw => 'Jūsų varžovas siūlo lygiąsias';

  @override
  String get accept => 'Sutikti';

  @override
  String get decline => 'Atmesti';

  @override
  String get playingRightNow => 'Vyksta šiuo metu';

  @override
  String get eventInProgress => 'Vyksta šiuo metu';

  @override
  String get finished => 'Baigėsi';

  @override
  String get abortGame => 'Nutraukti partiją';

  @override
  String get gameAborted => 'Partija nutraukta';

  @override
  String get standard => 'Standartinis';

  @override
  String get customPosition => 'Pasirinkta pozicija';

  @override
  String get unlimited => 'Neribota';

  @override
  String get mode => 'Tipas';

  @override
  String get casual => 'Nevertinamas';

  @override
  String get rated => 'Vertinamas';

  @override
  String get casualTournament => 'Nevertinamas';

  @override
  String get ratedTournament => 'Vertinamas';

  @override
  String get thisGameIsRated => 'Ši partija yra vertinama';

  @override
  String get rematch => 'Revanšas';

  @override
  String get rematchOfferSent => 'Revanšo pasiūlymas išsiųstas';

  @override
  String get rematchOfferAccepted => 'Revanšo pasiūlymas priimtas';

  @override
  String get rematchOfferCanceled => 'Revanšo pasiūlymas atšauktas';

  @override
  String get rematchOfferDeclined => 'Revanšo pasiūlymas atmestas';

  @override
  String get cancelRematchOffer => 'Atšaukti revanšo pasiūlymą';

  @override
  String get viewRematch => 'Peržiūrėti revanšą';

  @override
  String get confirmMove => 'Patvirtinkite ėjimą';

  @override
  String get play => 'Žaisk';

  @override
  String get inbox => 'Žinutės';

  @override
  String get chatRoom => 'Pokalbis';

  @override
  String get loginToChat => 'Prisijunkite pokalbiui';

  @override
  String get youHaveBeenTimedOut => 'Jums buvo suteikta pokalbio pertrauka.';

  @override
  String get spectatorRoom => 'Žiūrovų kambarys';

  @override
  String get composeMessage => 'Rašyti žinutę';

  @override
  String get subject => 'Tema';

  @override
  String get send => 'Siųsti';

  @override
  String get incrementInSeconds => 'Sekundžių prieaugis';

  @override
  String get freeOnlineChess => 'Nemokami šachmatai internete';

  @override
  String get exportGames => 'Eksportuoti partijas';

  @override
  String get ratingRange => 'Reitingo rėžis';

  @override
  String get thisAccountViolatedTos => 'Ši paskyra pažeidė „Lichess“ naudojimo sąlygas';

  @override
  String get openingExplorerAndTablebase => 'Debiutų naršyklė ir pozicijų duomenų bazė';

  @override
  String get takeback => 'Atsiimti ėjimą';

  @override
  String get proposeATakeback => 'Prašyti leidimo atšaukti ėjimą';

  @override
  String get takebackPropositionSent => 'Ėjimo atšaukimo prašymas išsiųstas';

  @override
  String get takebackPropositionDeclined => 'Ėjimo atšaukimo prašymas atmestas';

  @override
  String get takebackPropositionAccepted => 'Ėjimo atšaukimo prašymas priimtas';

  @override
  String get takebackPropositionCanceled => 'Ėjimo atšaukimo prašymas atšauktas';

  @override
  String get yourOpponentProposesATakeback => 'Varžovas prašo atšaukti ėjimą';

  @override
  String get bookmarkThisGame => 'Pasižymėti šią partiją';

  @override
  String get tournament => 'Turnyras';

  @override
  String get tournaments => 'Turnyrai';

  @override
  String get tournamentPoints => 'Turnyro taškai';

  @override
  String get viewTournament => 'Stebėti turnyrą';

  @override
  String get backToTournament => 'Grįžti į turnyrą';

  @override
  String get noDrawBeforeSwissLimit => 'Šveicariškame turnyre negalite skelbti lygiųjų neatlikę bent 30 ėjimų.';

  @override
  String get thematic => 'Tematinis';

  @override
  String yourPerfRatingIsProvisional(String param) {
    return 'Jūsų $param reitingas yra laikinas';
  }

  @override
  String yourPerfRatingIsTooHigh(String param1, String param2) {
    return 'Jūsų „$param1“ reitingas ($param2) yra per aukštas';
  }

  @override
  String yourTopWeeklyPerfRatingIsTooHigh(String param1, String param2) {
    return 'Jūsų geriausias savaitinis „$param1“ reitingas ($param2) yra per aukštas';
  }

  @override
  String yourPerfRatingIsTooLow(String param1, String param2) {
    return 'Jūsų „$param1“ reitingas ($param2) yra per žemas';
  }

  @override
  String ratedMoreThanInPerf(String param1, String param2) {
    return '≥ $param1 $param2 reitingas';
  }

  @override
  String ratedLessThanInPerf(String param1, String param2) {
    return '≤ $param1 $param2 reitingas';
  }

  @override
  String mustBeInTeam(String param) {
    return 'Turite būti komandos „$param“ nariu';
  }

  @override
  String youAreNotInTeam(String param) {
    return 'Jūs nesate komandos „$param“ narys';
  }

  @override
  String get backToGame => 'Grįžti į partiją';

  @override
  String get siteDescription => 'Nemokamas šachmatų žaidimas internete. Žaiskite šachmatais patrauklioje sąsajoje. Nebūtina registracija, nėra reklamų, nereikia jokių priedų. Žaiskite šachmatais prieš kompiuterį, draugus arba atsitiktinius varžovus.';

  @override
  String xJoinedTeamY(String param1, String param2) {
    return '$param1 prisijungė prie „$param2“ komandos';
  }

  @override
  String xCreatedTeamY(String param1, String param2) {
    return '$param1 sukūrė „$param2“ komandą';
  }

  @override
  String get startedStreaming => 'pradėjo transliuoti';

  @override
  String xStartedStreaming(String param) {
    return '$param pradėjo transliaciją';
  }

  @override
  String get averageElo => 'Reitingo vidurkis';

  @override
  String get location => 'Vietovė';

  @override
  String get filterGames => 'Filtruoti partijas';

  @override
  String get reset => 'Atstatyti';

  @override
  String get apply => 'Pritaikyti';

  @override
  String get save => 'Įrašyti';

  @override
  String get leaderboard => 'Lyderiai';

  @override
  String get screenshotCurrentPosition => 'Nufotografuoti esamą poziciją';

  @override
  String get gameAsGIF => 'Žaidimas kaip GIF animacija';

  @override
  String get pasteTheFenStringHere => 'FEN tekstą įrašykite čia';

  @override
  String get pasteThePgnStringHere => 'PGN tekstą įrašykite čia';

  @override
  String get orUploadPgnFile => 'Arba įkelkite PGN failą';

  @override
  String get fromPosition => 'Nuo pozicijos';

  @override
  String get continueFromHere => 'Tęsti nuo čia';

  @override
  String get toStudy => 'Studijuoti';

  @override
  String get importGame => 'Importuoti partiją';

  @override
  String get importGameExplanation => 'Įkeldami partijos PGN gausite naršomą peržiūrą,\nkompiuterinę analizę, partijos pokalbį bei URL dalinimuisi.';

  @override
  String get importGameCaveat => 'Variacijos bus ištrintos. Norėdami jas pasilikti importuokite PGN per studiją.';

  @override
  String get importGameDataPrivacyWarning => 'Šis PGN failas yra prieinamas visiems. Jei norite įkelti partiją privačiai, naudokite studijas.';

  @override
  String get thisIsAChessCaptcha => 'Tai yra šachmatinė „CAPTCHA“.';

  @override
  String get clickOnTheBoardToMakeYourMove => 'Spustelėkite ant lentos norėdami atlikti ėjimą ir įrodyti, kad esate žmogus.';

  @override
  String get captcha_fail => 'Prašome išspręsti šachmatų galvosūkį.';

  @override
  String get notACheckmate => 'Tai ne šachas ir matas';

  @override
  String get whiteCheckmatesInOneMove => 'Baltųjų šachas ir matas vienu ėjimu';

  @override
  String get blackCheckmatesInOneMove => 'Juodųjų šachas ir matas vienu ėjimu';

  @override
  String get retry => 'Kartoti';

  @override
  String get reconnecting => 'Jungiamasi';

  @override
  String get noNetwork => 'Neprisijungta';

  @override
  String get favoriteOpponents => 'Dažniausi varžovai';

  @override
  String get follow => 'Sekti';

  @override
  String get following => 'Sekamas';

  @override
  String get unfollow => 'Nebesekti';

  @override
  String followX(String param) {
    return 'Sekti $param';
  }

  @override
  String unfollowX(String param) {
    return 'Nebesekti $param';
  }

  @override
  String get block => 'Blokuoti';

  @override
  String get blocked => 'Užblokuotas';

  @override
  String get unblock => 'Atblokuoti';

  @override
  String get followsYou => 'Seka jus';

  @override
  String xStartedFollowingY(String param1, String param2) {
    return '$param1 pradėjo sekti $param2';
  }

  @override
  String get more => 'Daugiau';

  @override
  String get memberSince => 'Narys nuo';

  @override
  String lastSeenActive(String param) {
    return 'Paskutinis prisijungimas $param';
  }

  @override
  String get player => 'Žaidėjas';

  @override
  String get list => 'Sąrašas';

  @override
  String get graph => 'Grafikas';

  @override
  String get required => 'Privaloma.';

  @override
  String get openTournaments => 'Atviri turnyrai';

  @override
  String get duration => 'Trukmė';

  @override
  String get winner => 'Nugalėtojas';

  @override
  String get standing => 'Turmyrinė lentelė';

  @override
  String get createANewTournament => 'Sukurti naują turnyrą';

  @override
  String get tournamentCalendar => 'Turnyrų kalendorius';

  @override
  String get conditionOfEntry => 'Dalyvavimo sąlyga:';

  @override
  String get advancedSettings => 'Papildomos nuostatos';

  @override
  String get safeTournamentName => 'Pasirinkite labai saugų turnyro pavadinimą.';

  @override
  String get inappropriateNameWarning => 'Kas nors bent kiek netinkamo gali lemti jūsų paskyros uždarymą.';

  @override
  String get emptyTournamentName => 'Palikus tuščią, turnyras bus pavadintas pagal atsitiktinį didmeistrį.';

  @override
  String get makePrivateTournament => 'Padaryti turnyrą privačiu, ir apriboti patekimą su slaptažodžiu';

  @override
  String get join => 'Prisijungti';

  @override
  String get withdraw => 'Pasitraukti';

  @override
  String get points => 'Taškai';

  @override
  String get wins => 'Pergalės';

  @override
  String get losses => 'Pralaimėjimai';

  @override
  String get createdBy => 'Sukūrė';

  @override
  String get tournamentIsStarting => 'Turnyras prasideda';

  @override
  String get tournamentPairingsAreNowClosed => 'Suporavimai turnyrui jau baigėsi.';

  @override
  String standByX(String param) {
    return '$param, būkite pasiruošę, suporuojami žaidėjai!';
  }

  @override
  String get pause => 'Pristabdyti';

  @override
  String get resume => 'Tęsti';

  @override
  String get youArePlaying => 'Jūs žaidžiate!';

  @override
  String get winRate => 'Pergalių proc.';

  @override
  String get berserkRate => 'Įsiūčio proc.';

  @override
  String get performance => 'Pasirodymo lygis';

  @override
  String get tournamentComplete => 'Turnyras baigtas';

  @override
  String get movesPlayed => 'Atlikta ėjimų';

  @override
  String get whiteWins => 'Baltųjų pergalės';

  @override
  String get blackWins => 'Juodųjų pergalės';

  @override
  String get drawRate => 'Lygiųjų dažnumas';

  @override
  String get draws => 'Lygiosios';

  @override
  String nextXTournament(String param) {
    return 'Kitas $param turnyras:';
  }

  @override
  String get averageOpponent => 'Vidutinis varžovas';

  @override
  String get boardEditor => 'Lentos rengyklė';

  @override
  String get setTheBoard => 'Paruošti lentą';

  @override
  String get popularOpenings => 'Populiarūs debiutai';

  @override
  String get endgamePositions => 'Endšpilio pozicijos';

  @override
  String chess960StartPosition(String param) {
    return 'Chess960 pradinė pozicija: $param';
  }

  @override
  String get startPosition => 'Pradinė pozicija';

  @override
  String get clearBoard => 'Išvalyti lentą';

  @override
  String get loadPosition => 'Įkelti poziciją';

  @override
  String get isPrivate => 'Privatus';

  @override
  String reportXToModerators(String param) {
    return 'Pranešti apie $param moderatoriams';
  }

  @override
  String profileCompletion(String param) {
    return 'Profilio užbaigimas: $param';
  }

  @override
  String xRating(String param) {
    return '$param reitingas';
  }

  @override
  String get ifNoneLeaveEmpty => 'Jei neturite, palikite tuščią';

  @override
  String get profile => 'Profilis';

  @override
  String get editProfile => 'Redaguoti profilį';

  @override
  String get realName => 'Real name';

  @override
  String get setFlair => 'Pasirinkite savo atskiriamąjį ženklą - avatarą';

  @override
  String get flair => 'Atskiriamasis ženklas';

  @override
  String get youCanHideFlair => 'Yra nustatymas leidžiantis atjungti visų žaidėjų skiriamuosius ženklus.';

  @override
  String get biography => 'Aprašymas';

  @override
  String get countryRegion => 'Šalis ar regionas';

  @override
  String get thankYou => 'Ačiū!';

  @override
  String get socialMediaLinks => 'Socialinių tinklų nuorodos';

  @override
  String get oneUrlPerLine => 'Vienas adresas per eilutę.';

  @override
  String get inlineNotation => 'Įterptas žymėjimas';

  @override
  String get makeAStudy => 'Norėdami pasiekti vėliau ar pasidalinti sukurkite studiją.';

  @override
  String get clearSavedMoves => 'Išvalyti ėjimus';

  @override
  String get previouslyOnLichessTV => 'Anksčiau per „lichess TV“';

  @override
  String get onlinePlayers => 'Prisijungę žaidėjai';

  @override
  String get activePlayers => 'Aktyvumas';

  @override
  String get bewareTheGameIsRatedButHasNoClock => 'Dėmesio, partija yra vertinama, tačiau neturi laikrodžio!';

  @override
  String get success => 'Pavyko';

  @override
  String get automaticallyProceedToNextGameAfterMoving => 'Po ėjimo automatiškai pereiti prie kitos partijos';

  @override
  String get autoSwitch => 'Automatinis perjungimas';

  @override
  String get puzzles => 'Užduotys';

  @override
  String get onlineBots => 'Prisijungę robotai';

  @override
  String get name => 'Pavadinimas';

  @override
  String get description => 'Aprašymas';

  @override
  String get descPrivate => 'Privatus aprašymas';

  @override
  String get descPrivateHelp => 'Tekstas, kurį gali matyti tik komandos nariai. Jei nustatytas, komandos nariams pakeičia viešą aprašymą.';

  @override
  String get no => 'Ne';

  @override
  String get yes => 'Taip';

  @override
  String get help => 'Pagalba:';

  @override
  String get createANewTopic => 'Sukurti naują temą';

  @override
  String get topics => 'Temos';

  @override
  String get posts => 'Pranešimai';

  @override
  String get lastPost => 'Paskutinis pranešimas';

  @override
  String get views => 'Peržiūrų';

  @override
  String get replies => 'Atsakymų';

  @override
  String get replyToThisTopic => 'Atsakyti šioje temoje';

  @override
  String get reply => 'Atsakyti';

  @override
  String get message => 'Pranešimas';

  @override
  String get createTheTopic => 'Sukurti temą';

  @override
  String get reportAUser => 'Pranešti apie vartotoją';

  @override
  String get user => 'Vartotojas';

  @override
  String get reason => 'Priežastis';

  @override
  String get whatIsIheMatter => 'Kas nutiko?';

  @override
  String get cheat => 'Sukčiaviavo';

  @override
  String get troll => '„Troll\'ino“';

  @override
  String get other => 'Kita';

  @override
  String get reportDescriptionHelp => 'Įdėkite nuorodą į partiją(-as) ir paaiškinkite, kas netinkamo yra šio vartotojo elgsenoje. Paminėkite, kaip priėjote prie tokios išvados. Jūsų pranešimas bus apdorotas greičiau, jei bus pateiktas anglų kalba.';

  @override
  String get error_provideOneCheatedGameLink => 'Pateikite bent vieną nuorodą į partiją, kurioje buvo sukčiauta.';

  @override
  String by(String param) {
    return 'nuo $param';
  }

  @override
  String importedByX(String param) {
    return 'Importavo $param';
  }

  @override
  String get thisTopicIsNowClosed => 'Ši tema yra uždaryta.';

  @override
  String get blog => 'Tinklaraštis';

  @override
  String get notes => 'Užrašai';

  @override
  String get typePrivateNotesHere => 'Čia galite rašytis asmeninius užrašus';

  @override
  String get writeAPrivateNoteAboutThisUser => 'Parašykite privatų užrašą apie šį vartotoją';

  @override
  String get noNoteYet => 'Kol kas nėra užrašų';

  @override
  String get invalidUsernameOrPassword => 'Neteisingas prisijungimo vardas arba slaptažodis';

  @override
  String get incorrectPassword => 'Neteisingas slaptažodis';

  @override
  String get invalidAuthenticationCode => 'Neteisingas patvirtinimo kodas';

  @override
  String get emailMeALink => 'Atsiųsti nuorodą el. paštu';

  @override
  String get currentPassword => 'Esamas slaptažodis';

  @override
  String get newPassword => 'Naujas slaptažodis';

  @override
  String get newPasswordAgain => 'Naujas slaptažodis (vėl)';

  @override
  String get newPasswordsDontMatch => 'Nesutampa nauji slaptažodžiai';

  @override
  String get newPasswordStrength => 'Slaptažodžio stiprumas';

  @override
  String get clockInitialTime => 'Laikrodžio pradinis laikas';

  @override
  String get clockIncrement => 'Laikrodžio prieaugis';

  @override
  String get privacy => 'Privatumas';

  @override
  String get privacyPolicy => 'privatumo politiką';

  @override
  String get letOtherPlayersFollowYou => 'Leisti kitiems žaidėjams jus sekti';

  @override
  String get letOtherPlayersChallengeYou => 'Leisti kitiems žaidėjams pakviesti jus partijai';

  @override
  String get letOtherPlayersInviteYouToStudy => 'Leisti kitiems žaidėjams pakviesti jus į studiją';

  @override
  String get sound => 'Garsas';

  @override
  String get none => 'Jokia';

  @override
  String get fast => 'Greita';

  @override
  String get normal => 'Vidutinė';

  @override
  String get slow => 'Lėta';

  @override
  String get insideTheBoard => 'Ant lentos';

  @override
  String get outsideTheBoard => 'Šalia lentos';

  @override
  String get allSquaresOfTheBoard => 'All squares of the board';

  @override
  String get onSlowGames => 'Lėtose partijose';

  @override
  String get always => 'Visada';

  @override
  String get never => 'Niekada';

  @override
  String xCompetesInY(String param1, String param2) {
    return '$param1 varžosi „$param2“ turnyre';
  }

  @override
  String get victory => 'Pergalė';

  @override
  String get defeat => 'Pralaimėjimas';

  @override
  String victoryVsYInZ(String param1, String param2, String param3) {
    return '$param1 prieš $param2 žaidžiant $param3';
  }

  @override
  String defeatVsYInZ(String param1, String param2, String param3) {
    return '$param1 prieš $param2 žaidžiant $param3';
  }

  @override
  String drawVsYInZ(String param1, String param2, String param3) {
    return '$param1 su $param2 žaidžiant $param3';
  }

  @override
  String get timeline => 'Veikla';

  @override
  String get starting => 'Prasideda:';

  @override
  String get allInformationIsPublicAndOptional => 'Visa informacija yra vieša ir neprivaloma.';

  @override
  String get biographyDescription => 'Papasakokite apie save, kodėl mėgstate šachmatus, kokie jūsų mėgstamiausi debiutai, žaidėjai…';

  @override
  String get listBlockedPlayers => 'Parodyti jūsų užblokuotus žaidėjus';

  @override
  String get human => 'Žmogus';

  @override
  String get computer => 'Kompiuteris';

  @override
  String get side => 'Pusė';

  @override
  String get clock => 'Laikrodis';

  @override
  String get opponent => 'Varžovas';

  @override
  String get learnMenu => 'Išmok';

  @override
  String get studyMenu => 'Studijos';

  @override
  String get practice => 'Praktika';

  @override
  String get community => 'Bendruomenė';

  @override
  String get tools => 'Įrankiai';

  @override
  String get increment => 'Prieaugis';

  @override
  String get error_unknown => 'Netinkama reikšmė';

  @override
  String get error_required => 'Šį laukelį būtina užpildyti';

  @override
  String get error_email => 'Neteisingas el. pašto adresas';

  @override
  String get error_email_acceptable => 'Nepriimtinas el. pašto adresas. Patikrinkite ir bandykite dar kartą.';

  @override
  String get error_email_unique => 'El. pašto adresas neteisingas arba jau užimtas';

  @override
  String get error_email_different => 'Tai jau yra jūsų el. pašto adresas';

  @override
  String error_minLength(String param) {
    return 'Minimalus ilgis yra $param';
  }

  @override
  String error_maxLength(String param) {
    return 'Maksimalus ilgis yra $param';
  }

  @override
  String error_min(String param) {
    return 'Turi būti didesnis arba lygus $param';
  }

  @override
  String error_max(String param) {
    return 'Turi būti mažesnis arba lygus $param';
  }

  @override
  String ifRatingIsPlusMinusX(String param) {
    return 'Jei reitingas yra ± $param';
  }

  @override
  String get ifRegistered => 'Jei jau užsiregistravote';

  @override
  String get onlyExistingConversations => 'Tik esami pokalbiai';

  @override
  String get onlyFriends => 'Tik draugai';

  @override
  String get menu => 'Meniu';

  @override
  String get castling => 'Rokiruotė';

  @override
  String get whiteCastlingKingside => 'Baltieji O-O';

  @override
  String get blackCastlingKingside => 'Juodieji O-O';

  @override
  String tpTimeSpentPlaying(String param) {
    return 'Laikas, praleistas žaidžiant: $param';
  }

  @override
  String get watchGames => 'Stebėti partijas';

  @override
  String tpTimeSpentOnTV(String param) {
    return 'Laikas, praleistas stebint: $param';
  }

  @override
  String get watch => 'Žiūrėk';

  @override
  String get videoLibrary => 'Video biblioteka';

  @override
  String get streamersMenu => 'Transliuotojai';

  @override
  String get mobileApp => 'Mobilioji programėlė';

  @override
  String get webmasters => 'Svetainių kūrėjams';

  @override
  String get about => 'Apie';

  @override
  String aboutX(String param) {
    return 'Apie $param';
  }

  @override
  String xIsAFreeYLibreOpenSourceChessServer(String param1, String param2) {
    return '$param1 yra nemokamas ($param2), laisvas, neturintis reklamų, atviro kodo šachmatų serveris.';
  }

  @override
  String get really => 'tikrai';

  @override
  String get contribute => 'Prisidėkite';

  @override
  String get termsOfService => 'Naudojimosi sąlygos';

  @override
  String get sourceCode => 'Pirminis kodas';

  @override
  String get simultaneousExhibitions => 'Simultanai';

  @override
  String get host => 'Šeimininkas';

  @override
  String hostColorX(String param) {
    return 'Šeimininko spalva: $param';
  }

  @override
  String get yourPendingSimuls => 'Jūsų laukiantys simulai';

  @override
  String get createdSimuls => 'Naujai sukurti simultanai';

  @override
  String get hostANewSimul => 'Kurti nauji simultaną';

  @override
  String get signUpToHostOrJoinASimul => 'Prisijunkite norėdami sukurti ar prisijungti prie simulo';

  @override
  String get noSimulFound => 'Simultanas nerastas';

  @override
  String get noSimulExplanation => 'Šis simultanas neegzistuoja.';

  @override
  String get returnToSimulHomepage => 'Grįžti į simultanų pradžią';

  @override
  String get aboutSimul => 'Simultanai yra vieno žaidėjo partijos prieš keletą kitų žaidėjų vienu metu.';

  @override
  String get aboutSimulImage => 'Iš 50 varžovų, Fišeris laimėjo 47 partijas, lygiosiomis baigė 2 ir pralaimėjo 1.';

  @override
  String get aboutSimulRealLife => 'Idėja yra paimta iš tikro pasaulio įvykių. Tikrame gyvenime, simultano šeiminkas vaikščioja nuo stalo prie stalo atlikdamas po vieną ėjimą.';

  @override
  String get aboutSimulRules => 'Prasidėjus simultanui, kiekvienas žaidėjas pradeda partiją su šeimininku, kuris gauna baltuosius. Simultanas baigiasi kai užbaigiamos visos partijos.';

  @override
  String get aboutSimulSettings => 'Simulai visada yra nevertinami. Revanšai, ėjimų atšaukimai ir „daugiau laiko“ yra negalimi.';

  @override
  String get create => 'Sukurti';

  @override
  String get whenCreateSimul => 'Sukūrę simultaną, turite galimybę žaisti su keletu žaidėjų vienu metu.';

  @override
  String get simulVariantsHint => 'Jei pasirinksite keletą variantų, kiekvienas žaidėjas galės nuspręsti kurį norės žaisti.';

  @override
  String get simulClockHint => 'Fišerio laikrodžio nustatymas. Prieš kuo daugiau žaidėjų rungsitės, tuo daugiau laiko jums gali prireikti.';

  @override
  String get simulAddExtraTime => 'Galite pridėti papildomo laiko savo laikrodžiui, kad būtų lengviau žaisti simultane.';

  @override
  String get simulHostExtraTime => 'Papildomas laikas šeimininkui';

  @override
  String get simulAddExtraTimePerPlayer => 'Pridėti pradinio laiko prie jūsų laikrodžio už kiekvieną prie simultano prisijungiantį žaidėją.';

  @override
  String get simulHostExtraTimePerPlayer => 'Papildomas laikas šeimininkui už kiekvieną žaidėją';

  @override
  String get lichessTournaments => '„lichess“ turnyrai';

  @override
  String get tournamentFAQ => 'Arenos turnyrų DUK';

  @override
  String get timeBeforeTournamentStarts => 'Laikas iki turnyro pradžios';

  @override
  String get averageCentipawnLoss => 'Vidutinis centi-pėstininkų nuostolis';

  @override
  String get accuracy => 'Tikslumas';

  @override
  String get keyboardShortcuts => 'Spartieji klavišai';

  @override
  String get keyMoveBackwardOrForward => 'judėti pirmyn/atgal';

  @override
  String get keyGoToStartOrEnd => 'eiti į pradžią/pabaigą';

  @override
  String get keyCycleSelectedVariation => 'Pereiti pasirinktą variantą';

  @override
  String get keyShowOrHideComments => 'rodyti/slėpti komentarus';

  @override
  String get keyEnterOrExitVariation => 'įeiti/išeiti iš variacijos';

  @override
  String get keyRequestComputerAnalysis => 'Paprašyti kompiuterio analizės, pasimokykite iš savo klaidų';

  @override
  String get keyNextLearnFromYourMistakes => 'Toliau (pasimokyti iš savo klaidų)';

  @override
  String get keyNextBlunder => 'Kita šiurkšti klaida';

  @override
  String get keyNextMistake => 'Kita klaida';

  @override
  String get keyNextInaccuracy => 'Kitas netiklsumas';

  @override
  String get keyPreviousBranch => 'Praeita atšaka';

  @override
  String get keyNextBranch => 'Kita atšaka';

  @override
  String get toggleVariationArrows => 'Rodyti variacijų rodykles';

  @override
  String get cyclePreviousOrNextVariation => 'Eiti į praeitą/sekantį variantą';

  @override
  String get toggleGlyphAnnotations => 'Įjungti ėjimų komentarus';

  @override
  String get togglePositionAnnotations => 'Įjungti pozicijos komentarus';

  @override
  String get variationArrowsInfo => 'Variacijų rodyklės leidžia jums naviguoti nenaudojant ėjimų lentelės.';

  @override
  String get playSelectedMove => 'padaryti pasirinktą ėjimą';

  @override
  String get newTournament => 'Naujas turnyras';

  @override
  String get tournamentHomeTitle => 'Šachmatų turnyras su įvairiomis laiko kontrolėmis ir variantais';

  @override
  String get tournamentHomeDescription => 'Žaiskite aukšto tempo šachmatų turnyruose! Prisijunkite prie oficialaus suplanuoto turnyro arba sukurkite savo.';

  @override
  String get tournamentNotFound => 'Turnyras nerastas';

  @override
  String get tournamentDoesNotExist => 'Turnyras neegzistuoja.';

  @override
  String get tournamentMayHaveBeenCanceled => 'Jis galėjo būti atšauktas, jeigu iki jo pradžios išėjo visi žaidėjai.';

  @override
  String get returnToTournamentsHomepage => 'Grįžti į pradinį turnyrų puslapį';

  @override
  String weeklyPerfTypeRatingDistribution(String param) {
    return 'Savaitinis „$param“ reitingų pasiskirstymas';
  }

  @override
  String yourPerfTypeRatingIsRating(String param1, String param2) {
    return 'Jūsų „$param1“ reitingas yra $param2.';
  }

  @override
  String youAreBetterThanPercentOfPerfTypePlayers(String param1, String param2) {
    return 'Jūs esate geresni už $param1 iš $param2 žaidėjų.';
  }

  @override
  String userIsBetterThanPercentOfPerfTypePlayers(String param1, String param2, String param3) {
    return '$param1 yra geresnis už $param2 iš $param3 žaidėjų.';
  }

  @override
  String betterThanPercentPlayers(String param1, String param2) {
    return 'Geriau nei $param1 $param2 žaidėjų';
  }

  @override
  String youDoNotHaveAnEstablishedPerfTypeRating(String param) {
    return 'Jūs neturite nusistovėjusio „$param“ reitingo.';
  }

  @override
  String get yourRating => 'Jūsų reitingas';

  @override
  String get cumulative => 'Iš viso';

  @override
  String get glicko2Rating => 'Glicko-2 reitingas';

  @override
  String get checkYourEmail => 'Pasitikrinkite el. paštą';

  @override
  String get weHaveSentYouAnEmailClickTheLink => 'Išsiuntėme jums laišką. Spustelėję jame esančią nuorodą aktyvuosite savo paskyrą.';

  @override
  String get ifYouDoNotSeeTheEmailCheckOtherPlaces => 'Jei nematote laiško, patikrinkite kitas galimas vietas: šlamšto, šiukšlių, socialinius ar kitus aplankus.';

  @override
  String weHaveSentYouAnEmailTo(String param) {
    return 'Išsiuntėme laišką į $param. Spustelėję jame esančią nurodą galėsite atstatyti savo slaptažodį.';
  }

  @override
  String byRegisteringYouAgreeToBeBoundByOur(String param) {
    return 'Registruodamiesi sutinkate su mūsų $param.';
  }

  @override
  String readAboutOur(String param) {
    return 'Skaitykite daugiau apie mūsų $param.';
  }

  @override
  String get networkLagBetweenYouAndLichess => 'Tinklo delsa tarp jūsų ir „lichess“';

  @override
  String get timeToProcessAMoveOnLichessServer => 'Laikas, per kurį „lichess“ serveris apdoroja ėjimą';

  @override
  String get downloadAnnotated => 'Siųstis anotuotą';

  @override
  String get downloadRaw => 'Siųstis neapdorotą';

  @override
  String get downloadImported => 'Siųstis importuotą';

  @override
  String get crosstable => 'Susitikimai';

  @override
  String get youCanAlsoScrollOverTheBoardToMoveInTheGame => 'Judėti partijoje taip pat galite naudodamiesi pelės ratuku virš lentos.';

  @override
  String get scrollOverComputerVariationsToPreviewThem => 'Užveskite ant kompiuterio variacijų norėdami jas peržiūrėti.';

  @override
  String get analysisShapesHowTo => 'Spustelėkite Shift + kairįjį pelės klavišą arba dešinįjį pelės klavišą norėdami piešti ant lentos.';

  @override
  String get letOtherPlayersMessageYou => 'Leisti kitiems žaidėjams jums parašyti';

  @override
  String get receiveForumNotifications => 'Gaukite pranešimus, kai esate paminėti forume';

  @override
  String get shareYourInsightsData => 'Bendrinti jūsų statistiką';

  @override
  String get withNobody => 'Su niekuo';

  @override
  String get withFriends => 'Su draugais';

  @override
  String get withEverybody => 'Su visais';

  @override
  String get kidMode => 'Vaiko veiksena';

  @override
  String get kidModeIsEnabled => 'Vaiko funkcija įjungta.';

  @override
  String get kidModeExplanation => 'Tai yra dėl saugumo. Vaiko veiksenoje išjungiamas visas bendravimas svetainėje. Įjunkite tai savo vaikams bei moksleiviams, norėdami juos apsaugoti nuo kitų interneto naudotojų.';

  @override
  String inKidModeTheLichessLogoGetsIconX(String param) {
    return 'Vaiko veiksenoje „lichess“ logotipas gauna $param piktogramą tam, kad žinotumėte, jog jūsų vaikai yra saugūs.';
  }

  @override
  String get askYourChessTeacherAboutLiftingKidMode => 'Jūsų paskyra yra valdoma. Norėdami pašalinti vaiko režimą kreipkitės į savo šachmatų mokytoją.';

  @override
  String get enableKidMode => 'Įjungti vaiko veikseną';

  @override
  String get disableKidMode => 'Išjungti vaiko veikseną';

  @override
  String get security => 'Saugumas';

  @override
  String get sessions => 'Sesijos';

  @override
  String get revokeAllSessions => 'atšaukti visus seansus';

  @override
  String get playChessEverywhere => 'Žaiskite šachmatais visur';

  @override
  String get asFreeAsLichess => 'Nemokama, kaip ir „lichess“';

  @override
  String get builtForTheLoveOfChessNotMoney => 'Sukurta iš meilės šachmatams, ne dėl pinigų';

  @override
  String get everybodyGetsAllFeaturesForFree => 'Kiekvienas gauna visas galimybes už dyką';

  @override
  String get zeroAdvertisement => 'Jokių reklamų';

  @override
  String get fullFeatured => 'Visiškai parengta';

  @override
  String get phoneAndTablet => 'Telefonui ir planšetei';

  @override
  String get bulletBlitzClassical => 'Žaibo, blic, klasikiniai';

  @override
  String get correspondenceChess => 'Korespondenciniai';

  @override
  String get onlineAndOfflinePlay => 'Žaidimas su ir be interneto';

  @override
  String get viewTheSolution => 'Parodyti sprendimą';

  @override
  String get followAndChallengeFriends => 'Sekti ir žaisti su draugais';

  @override
  String get gameAnalysis => 'Partijos analizė';

  @override
  String xHostsY(String param1, String param2) {
    return '$param1 veda $param2';
  }

  @override
  String xJoinsY(String param1, String param2) {
    return '$param1 prisijungė prie $param2';
  }

  @override
  String xLikesY(String param1, String param2) {
    return '$param1 patiko $param2';
  }

  @override
  String get quickPairing => 'Greitas suporavimas';

  @override
  String get lobby => 'Laukiamasis';

  @override
  String get anonymous => 'Anonimas';

  @override
  String yourScore(String param) {
    return 'Jūsų rezultatas: $param';
  }

  @override
  String get language => 'Kalba';

  @override
  String get background => 'Fonas';

  @override
  String get light => 'Šviesus';

  @override
  String get dark => 'Tamsus';

  @override
  String get transparent => 'Permatomas';

  @override
  String get deviceTheme => 'Įrenginio tema';

  @override
  String get backgroundImageUrl => 'Fono paveikslo URL:';

  @override
  String get board => 'Lenta';

  @override
  String get size => 'Dydis';

  @override
  String get opacity => 'Skaidrumas';

  @override
  String get brightness => 'Ryškumas';

  @override
  String get hue => 'Atspalvis';

  @override
  String get boardReset => 'Atstatyti spalvas į pradines';

  @override
  String get pieceSet => 'Figūrų rinkinys';

  @override
  String get embedInYourWebsite => 'Įterpto jūsų svetainėje';

  @override
  String get usernameAlreadyUsed => 'Šis vartotojo vardas jau naudojamas, pabandykite kitą.';

  @override
  String get usernamePrefixInvalid => 'Vartotojo vardas turi prasidėti raide.';

  @override
  String get usernameSuffixInvalid => 'Vartotojo vardas turi baigtis raide arba skaičiumi.';

  @override
  String get usernameCharsInvalid => 'Vartotojo vardui naudokite tik raides, skaičius, pabraukimo brūkšnius ir brūkšnelius.';

  @override
  String get usernameUnacceptable => 'Šis vartotojo vardas yra netinkamas.';

  @override
  String get playChessInStyle => 'Žaiskite šachmatais stilingai';

  @override
  String get chessBasics => 'Šachmatų pagrindai';

  @override
  String get coaches => 'Treneriai';

  @override
  String get invalidPgn => 'Netinkamas PGN';

  @override
  String get invalidFen => 'Netinkamas FEN';

  @override
  String get custom => 'Kitoks';

  @override
  String get notifications => 'Pranešimai';

  @override
  String notificationsX(String param1) {
    return 'Pranešimai: $param1';
  }

  @override
  String perfRatingX(String param) {
    return 'Reitingas: $param';
  }

  @override
  String get practiceWithComputer => 'Treniruotė su kompiuteriu';

  @override
  String anotherWasX(String param) {
    return 'Dar vienas buvo $param';
  }

  @override
  String bestWasX(String param) {
    return 'Geriausias buvo $param';
  }

  @override
  String get youBrowsedAway => 'Jūs naršėte kitur';

  @override
  String get resumePractice => 'Pratęsti treniruotę';

  @override
  String get drawByFiftyMoves => 'Žaidimas pasibaigė lygiosiomis dėl penkiasdešimties ėjimų taisyklės.';

  @override
  String get theGameIsADraw => 'Partija baigėsi lygiosiomis.';

  @override
  String get computerThinking => 'Kompiuteris mąsto...';

  @override
  String get seeBestMove => 'Rodyti geriausią ėjimą';

  @override
  String get hideBestMove => 'Slėpti geriausią ėjimą';

  @override
  String get getAHint => 'Gauti užuominą';

  @override
  String get evaluatingYourMove => 'Vertinamas jūsų ėjimas...';

  @override
  String get whiteWinsGame => 'Laimėjo baltieji';

  @override
  String get blackWinsGame => 'Laimėjo juodieji';

  @override
  String get learnFromYourMistakes => 'Mokykitės iš savo klaidų';

  @override
  String get learnFromThisMistake => 'Pasimokykite iš šios klaidos';

  @override
  String get skipThisMove => 'Praleisti šį ėjimą';

  @override
  String get next => 'Toliau';

  @override
  String xWasPlayed(String param) {
    return 'Buvo sužaistas $param';
  }

  @override
  String get findBetterMoveForWhite => 'Suraskite geresnį ėjimą baltiesiems';

  @override
  String get findBetterMoveForBlack => 'Suraskite geresnį ėjimą juodiesiems';

  @override
  String get resumeLearning => 'Pratęsti mokymąsi';

  @override
  String get youCanDoBetter => 'Galite ir geriau';

  @override
  String get tryAnotherMoveForWhite => 'Pabandykite kitą ėjimą baltiesiems';

  @override
  String get tryAnotherMoveForBlack => 'Pabandykite kitą ėjimą juodiesiems';

  @override
  String get solution => 'Sprendimas';

  @override
  String get waitingForAnalysis => 'Laukiama analizės';

  @override
  String get noMistakesFoundForWhite => 'Nerasta klaidų baltiesiems';

  @override
  String get noMistakesFoundForBlack => 'Nerasta klaidų juodiesiems';

  @override
  String get doneReviewingWhiteMistakes => 'Baltųjų klaidos peržiūrėtos';

  @override
  String get doneReviewingBlackMistakes => 'Juodųjų klaidos peržiūrėtos';

  @override
  String get doItAgain => 'Atlikti dar kartą';

  @override
  String get reviewWhiteMistakes => 'Peržiūrėti baltųjų klaidas';

  @override
  String get reviewBlackMistakes => 'Peržiūrėti juodųjų klaidas';

  @override
  String get advantage => 'Pranašumas';

  @override
  String get opening => 'Debiutas';

  @override
  String get middlegame => 'Mitelšpilis';

  @override
  String get endgame => 'Endšpilis';

  @override
  String get conditionalPremoves => 'Sąlyginiai išankstiniai ėjimai';

  @override
  String get addCurrentVariation => 'Pridėti dabartinę variaciją';

  @override
  String get playVariationToCreateConditionalPremoves => 'Sužaiskite variaciją, norėdami sukurti sąlyginius išankstinius ėjimus';

  @override
  String get noConditionalPremoves => 'Nėra sąlyginių išankstinių ėjimų';

  @override
  String playX(String param) {
    return 'Žaiskite $param';
  }

  @override
  String get showUnreadLichessMessage => 'Jūs gavote privačią žinutę iš Lichess.';

  @override
  String get clickHereToReadIt => 'Spustelėkite čia, kad peržiūrėtumėte';

  @override
  String get sorry => 'Atsiprašome :(';

  @override
  String get weHadToTimeYouOutForAWhile => 'Turėjome jus laikinai apriboti.';

  @override
  String get why => 'Kodėl?';

  @override
  String get pleasantChessExperience => 'Mes stengiamės suteikti galimybę visiems patirti šachmatų malonumą.';

  @override
  String get goodPractice => 'Dėl to turime užtikrinti, kad visi žaidėjai laikytųsi gerųjų praktikų.';

  @override
  String get potentialProblem => 'Kai aptinkama galima problema, mes parodome šį pranešimą.';

  @override
  String get howToAvoidThis => 'Kaip to išvengti?';

  @override
  String get playEveryGame => 'Užbaikite kiekvieną pradėtą partiją.';

  @override
  String get tryToWin => 'Kiekvieną kartą stenkitės laimėti, ar bent sužaisti lygiosiomis.';

  @override
  String get resignLostGames => 'Pasiduokite pralaimėtose partijose (nelaukite kol pasibaigs laikas).';

  @override
  String get temporaryInconvenience => 'Atsiprašome dėl laikinų nepatogumų,';

  @override
  String get wishYouGreatGames => 'ir linkime jums puikių partijų per lichess.org.';

  @override
  String get thankYouForReading => 'Ačiū, kad perskaitėte!';

  @override
  String get lifetimeScore => 'Visų laikų rezultatas';

  @override
  String get currentMatchScore => 'Dabartinės partijos rezultatas';

  @override
  String get agreementAssistance => 'Pasižadu niekada savo partijų metu nesinaudoti kompiuterio, knygos, duomenų bazės ar kito žmogaus pagalba.';

  @override
  String get agreementNice => 'Pasižadu visada būti pagarbus kitiems žaidėjams.';

  @override
  String agreementMultipleAccounts(String param) {
    return 'Aš sutinku, kad nekursiu daugiau nei vienos paskyros (išskyrus priežastis nurodytas $param).';
  }

  @override
  String get agreementPolicy => 'Pasižadu laikytis visų „Lichess“ nuostatų.';

  @override
  String get searchOrStartNewDiscussion => 'Ieškokite, arba pradėkite naują diskusiją';

  @override
  String get edit => 'Keisti';

  @override
  String get bullet => 'Naujiena';

  @override
  String get blitz => 'Blitz';

  @override
  String get rapid => 'Greitieji';

  @override
  String get classical => 'Klasikiniai';

  @override
  String get ultraBulletDesc => 'Be proto greitos partijos: mažiau nei 30 sekundžių';

  @override
  String get bulletDesc => 'Labai greitos partijos: mažiau nei 3 minutės';

  @override
  String get blitzDesc => 'Blic partijos: nuo 3 iki 8 minučių';

  @override
  String get rapidDesc => 'Greitosios partijos: nuo 8 iki 25 minučių';

  @override
  String get classicalDesc => 'Klasikinės partijos: 25 minutės ir daugiau';

  @override
  String get correspondenceDesc => 'Korespondencinės partijos: viena ar kelios dienos ėjimui';

  @override
  String get puzzleDesc => 'Šachmatų taktikų treniruotė';

  @override
  String get important => 'Dėmesio';

  @override
  String yourQuestionMayHaveBeenAnswered(String param1) {
    return 'Jūsų klausimas jau gali būti atsakytas $param1';
  }

  @override
  String get inTheFAQ => 'per D.U.K.';

  @override
  String toReportSomeoneForCheatingOrBadBehavior(String param1) {
    return 'Norėdami pranešti apie sukčiaujantį žaidėją arba blogą elgesį, $param1';
  }

  @override
  String get useTheReportForm => 'naudokitės skundų forma';

  @override
  String toRequestSupport(String param1) {
    return 'Norėdami gauti pagalbos, $param1';
  }

  @override
  String get tryTheContactPage => 'aplankykite kontaktų skiltį';

  @override
  String makeSureToRead(String param1) {
    return 'Įsitikinkite, kad perskaitėte $param1';
  }

  @override
  String get theForumEtiquette => 'forumo etiketą';

  @override
  String get thisTopicIsArchived => 'Ši tema yra suarchyvuota, tad nauji atsakymai negalimi.';

  @override
  String joinTheTeamXToPost(String param1) {
    return 'Norėdami rašyti šiame forume, prisijunkite prie „$param1“';
  }

  @override
  String teamNamedX(String param1) {
    return '$param1 komanda';
  }

  @override
  String get youCannotPostYetPlaySomeGames => 'Diskutuoti forume dar negalite. Sužaiskite keletą partijų!';

  @override
  String get subscribe => 'Prenumeruoti';

  @override
  String get unsubscribe => 'Atsisakyti prenumeratos';

  @override
  String mentionedYouInX(String param1) {
    return 'paminėjo jus \"$param1\".';
  }

  @override
  String xMentionedYouInY(String param1, String param2) {
    return '$param1 paminėjo jus \"$param2\".';
  }

  @override
  String invitedYouToX(String param1) {
    return 'pakvietė jus į \"$param1\".';
  }

  @override
  String xInvitedYouToY(String param1, String param2) {
    return '$param1 pakvietė jus į \"$param2\".';
  }

  @override
  String get youAreNowPartOfTeam => 'Jūs jau esate komandos dalis.';

  @override
  String youHaveJoinedTeamX(String param1) {
    return 'Jūs prisijungėte prie \"$param1\".';
  }

  @override
  String get someoneYouReportedWasBanned => 'Kažkas, apie ką pranešėte, buvo užblokuotas';

  @override
  String get congratsYouWon => 'Sveikiname, jūs laimėjote!';

  @override
  String gameVsX(String param1) {
    return 'Žaidimas prieš $param1';
  }

  @override
  String resVsX(String param1, String param2) {
    return '$param1 prieš $param2';
  }

  @override
  String get lostAgainstTOSViolator => 'Jūs pralaimėjote prieš žmogų, kuris pažeidė Lichess taisykles';

  @override
  String refundXpointsTimeControlY(String param1, String param2) {
    return 'Grąžinimas: $param1 $param2 reitingo taškų.';
  }

  @override
  String get timeAlmostUp => 'Laikas beveik baigėsi!';

  @override
  String get clickToRevealEmailAddress => '[spustelėkite norėdami pamatyti el. pašto adresą]';

  @override
  String get download => 'Atsisiųsti';

  @override
  String get coachManager => 'Trenerių valdymas';

  @override
  String get streamerManager => 'Transliuotojų valdymas';

  @override
  String get cancelTournament => 'Atšaukti turnyrą';

  @override
  String get tournDescription => 'Turnyro aprašymas';

  @override
  String get tournDescriptionHelp => 'Yra kažkas, ką turi žinoti dalyviai? Stenkitės perteikti trumpai. Galimos Markdown nuorodos: [pavadinimas](https://url)';

  @override
  String get ratedFormHelp => 'Partijos reitinguotos\nir daro įtaką žaidėjų reitingams';

  @override
  String get onlyMembersOfTeam => 'Tik komandos nariai';

  @override
  String get noRestriction => 'Jokių apribojimų';

  @override
  String get minimumRatedGames => 'Mažiausiai įvertintos partijos';

  @override
  String get minimumRating => 'Minimalus reitingas';

  @override
  String get maximumWeeklyRating => 'Maksimalus savaitinis reitingas';

  @override
  String positionInputHelp(String param) {
    return 'Norėdami pradėti žaidimą nuo specifinės pozicijos, įklijuokite teisingą FEN.\nVeikia tik standartiniams žaidimams, ne variantams.\nNorėdami sugeneruoti FEN poziciją galite naudotis $param, tada ją įklijuokite čia.\nPalikite tuščią norėdami pradėti žaidimą nuo įprastos pradinės pozicijos.';
  }

  @override
  String get cancelSimul => 'Atšaukti simultaną';

  @override
  String get simulHostcolor => 'Šeimininko spalva kiekvienam žaidimui';

  @override
  String get estimatedStart => 'Numatytas pradžios laikas';

  @override
  String simulFeatured(String param) {
    return 'Rodyti $param';
  }

  @override
  String simulFeaturedHelp(String param) {
    return 'Rodyti simultaną visiems $param. Neįjungta privatiems simultanams.';
  }

  @override
  String get simulDescription => 'Simultano aprašymas';

  @override
  String get simulDescriptionHelp => 'Ar norite ką nors pranešti dalyviams?';

  @override
  String markdownAvailable(String param) {
    return '$param prieinama norint naudoti sudėtingesnę sintaksę.';
  }

  @override
  String get embedsAvailable => 'Įklijuokite partijos adresą arba studijos skyriaus adresą norėdami juos įterpti.';

  @override
  String get inYourLocalTimezone => 'Jūsų laiko zonoje';

  @override
  String get tournChat => 'Turnyro pokalbis';

  @override
  String get noChat => 'Jokio pokalbio';

  @override
  String get onlyTeamLeaders => 'Tik komandų kapitonams';

  @override
  String get onlyTeamMembers => 'Tik komandos nariams';

  @override
  String get navigateMoveTree => 'Keliauti per ėjimų medį';

  @override
  String get mouseTricks => 'Triukai pele';

  @override
  String get toggleLocalAnalysis => 'Įjungti/išjungti vietinę kompiuterio analizę';

  @override
  String get toggleAllAnalysis => 'Įjungti/išjungti visą kompiuterio analizę';

  @override
  String get playComputerMove => 'Žaisti geriausią kompiuterio ėjimą';

  @override
  String get analysisOptions => 'Analizės nustatymai';

  @override
  String get focusChat => 'Perjungti į pokalbį';

  @override
  String get showHelpDialog => 'Rodyti šį pagalbos dialogą';

  @override
  String get reopenYourAccount => 'Atidaryti uždarytą paskyrą';

  @override
  String get closedAccountChangedMind => 'Jei uždarėte savo paskyrą, tačiau apsigalvojote, turite vieną šansą ją atgauti.';

  @override
  String get onlyWorksOnce => 'Tai suveiks tik kartą.';

  @override
  String get cantDoThisTwice => 'Jei uždarysite savo paskyrą antrą kartą nebebus jokio būdo ją atkurti.';

  @override
  String get emailAssociatedToaccount => 'Elektroninio pašto adresas susietas su paskyra';

  @override
  String get sentEmailWithLink => 'Меs jums išsiuntėme laišką su nuoroda.';

  @override
  String get tournamentEntryCode => 'Įėjimo į turnyrą kodas';

  @override
  String get hangOn => 'Ei!';

  @override
  String gameInProgress(String param) {
    return 'Jūs jau turite vykstančią partiją su $param.';
  }

  @override
  String get abortTheGame => 'Atšaukti partiją';

  @override
  String get resignTheGame => 'Pasiduoti';

  @override
  String get youCantStartNewGame => 'Jūs negalite pradėti naujos partijos kol nepabaigta ši.';

  @override
  String get since => 'Nuo';

  @override
  String get until => 'Iki';

  @override
  String get lichessDbExplanation => 'Reitinguoti žaidimai paimti iš visų Lichess žaidėjų';

  @override
  String get switchSides => 'Pakeisti puses';

  @override
  String get closingAccountWithdrawAppeal => 'paskyras';

  @override
  String get ourEventTips => 'Mūsų patarimai organizuojant renginius';

  @override
  String get instructions => 'Instrukcijos';

  @override
  String get showMeEverything => 'Rodyti viską';

  @override
  String get lichessPatronInfo => 'Lichess yra labdara ir pilnai atviro kodo/libre projektas.\nVisos veikimo išlaidos, programavimas ir turinys yra padengti išskirtinai tik vartotojų parama.';

  @override
  String get nothingToSeeHere => 'Nieko naujo.';

  @override
  String opponentLeftCounter(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Jūsų varžovas paliko partiją. Galėsite prisiimti pergalę už $count sekundžių.',
      many: 'Jūsų varžovas paliko partiją. Galėsite prisiimti pergalę už $count sekundžių.',
      few: 'Jūsų varžovas paliko partiją. Galėsite prisiimti pergalę už $count sekundžių.',
      one: 'Jūsų varžovas paliko partiją. Galėsite prisiimti pergalę už $count sekundės.',
    );
    return '$_temp0';
  }

  @override
  String mateInXHalfMoves(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Matas už $count pus-ėjimų',
      many: 'Matas už $count pus-ėjimų',
      few: 'Matas už $count pus-ėjimų',
      one: 'Matas už $count pus-ėjimo',
    );
    return '$_temp0';
  }

  @override
  String nbBlunders(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count šiurkščių klaidų',
      many: '$count šiurkščios klaidos',
      few: '$count šiurkščios klaidos',
      one: '$count šiurkšti klaida',
    );
    return '$_temp0';
  }

  @override
  String nbMistakes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count klaidų',
      many: '$count klaidos',
      few: '$count klaidos',
      one: '$count klaida',
    );
    return '$_temp0';
  }

  @override
  String nbInaccuracies(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count netikslumų',
      many: '$count netikslumo',
      few: '$count netikslumai',
      one: '$count netikslumas',
    );
    return '$_temp0';
  }

  @override
  String nbPlayers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count žaidėjų',
      many: '$count žaidėjų',
      few: '$count žaidėjai',
      one: '$count žaidėjas',
    );
    return '$_temp0';
  }

  @override
  String nbGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count partijų',
      many: '$count partijų',
      few: '$count partijos',
      one: '$count partija',
    );
    return '$_temp0';
  }

  @override
  String ratingXOverYGames(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count reitingas per $param2 partijų',
      many: '$count reitingas per $param2 partijos',
      few: '$count reitingas per $param2 partijas',
      one: '$count reitingas per $param2 partiją',
    );
    return '$_temp0';
  }

  @override
  String nbBookmarks(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count įrašų',
      many: '$count įrašų',
      few: '$count įrašai',
      one: '$count įrašas',
    );
    return '$_temp0';
  }

  @override
  String nbDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count dienų',
      many: '$count dienų',
      few: '$count dienos',
      one: '$count diena',
    );
    return '$_temp0';
  }

  @override
  String nbHours(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count valandų',
      many: '$count valandų',
      few: '$count valandos',
      one: '$count valanda',
    );
    return '$_temp0';
  }

  @override
  String nbMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count minučių',
      many: '$count minutės',
      few: '$count minutės',
      one: '$count minutė',
    );
    return '$_temp0';
  }

  @override
  String rankIsUpdatedEveryNbMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Reitingas atnaujinamas kas $count minučių',
      many: 'Reitingas atnaujinamas kas $count minučių',
      few: 'Reitingas atnaujinamas kas $count minutes',
      one: 'Reitingas atnaujinamas kas minutę',
    );
    return '$_temp0';
  }

  @override
  String nbPuzzles(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count užduočių',
      many: '$count užduočių',
      few: '$count užduotys',
      one: '$count užduotis',
    );
    return '$_temp0';
  }

  @override
  String nbGamesWithYou(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count partijų su jumis',
      many: '$count partijų su jumis',
      few: '$count partijos su jumis',
      one: '$count partija su jumis',
    );
    return '$_temp0';
  }

  @override
  String nbRated(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count vertinamų',
      many: '$count vertinamų',
      few: '$count vertinamos',
      one: '$count vertinama',
    );
    return '$_temp0';
  }

  @override
  String nbWins(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count pergalių',
      many: '$count pergalių',
      few: '$count pergalės',
      one: '$count pergalė',
    );
    return '$_temp0';
  }

  @override
  String nbLosses(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count pralaimėjimų',
      many: '$count pralaimėjimų',
      few: '$count pralaimėjimai',
      one: '$count pralaimėjimas',
    );
    return '$_temp0';
  }

  @override
  String nbDraws(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count lygiųjų',
      many: '$count lygiųjų',
      few: '$count lygiosios',
      one: '$count lygiosios',
    );
    return '$_temp0';
  }

  @override
  String nbPlaying(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count žaidžiamų',
      many: '$count žaidžiamų',
      few: '$count žaidžiami',
      one: '$count žaidžiamas',
    );
    return '$_temp0';
  }

  @override
  String giveNbSeconds(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Duoti $count sekundžių',
      many: 'Duoti $count sekundžių',
      few: 'Duoti $count sekundes',
      one: 'Duoti $count sekundę',
    );
    return '$_temp0';
  }

  @override
  String nbTournamentPoints(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count turnyro taškų',
      many: '$count turnyro taškų',
      few: '$count turnyro taškai',
      one: '$count turnyro taškas',
    );
    return '$_temp0';
  }

  @override
  String nbStudies(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count studijų',
      many: '$count studijų',
      few: '$count studijos',
      one: '$count studija',
    );
    return '$_temp0';
  }

  @override
  String nbSimuls(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count simultanų',
      many: '$count simultano',
      few: '$count simultanai',
      one: '$count simultanas',
    );
    return '$_temp0';
  }

  @override
  String moreThanNbRatedGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '≥ $count vertinamų partijų',
      many: '≥ $count vertinamų partijų',
      few: '≥ $count vertinamos partijos',
      one: '≥ $count vertinama partija',
    );
    return '$_temp0';
  }

  @override
  String moreThanNbPerfRatedGames(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '≥ $count vertinamų „$param2“ partijų',
      many: '≥ $count vertinamų „$param2“ partijų',
      few: '≥ $count vertinamos „$param2“ partijos',
      one: '≥ $count vertinama „$param2“ partija',
    );
    return '$_temp0';
  }

  @override
  String needNbMorePerfGames(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Jums reikia sužaisti dar $count vertinamų „$param2“ partijų',
      many: 'Jums reikia sužaisti dar $count vertinamų „$param2“ partijų',
      few: 'Jums reikia sužaisti dar $count vertinamas „$param2“ partijas',
      one: 'Jums reikia sužaisti dar $count vertinamą „$param2“ partiją',
    );
    return '$_temp0';
  }

  @override
  String needNbMoreGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Jums reikia sužaisti dar $count vertinamų partijų',
      many: 'Jums reikia sužaisti dar $count vertinamų partijų',
      few: 'Jums reikia sužaisti dar $count vertinamas partijas',
      one: 'Jums reikia sužaisti dar $count vertinamą partiją',
    );
    return '$_temp0';
  }

  @override
  String nbImportedGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count importuotų žaidimų',
      many: '$count importuotų žaidimų',
      few: '$count importuoti žaidimai',
      one: '$count importuotas žaidimas',
    );
    return '$_temp0';
  }

  @override
  String nbFriendsOnline(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count prisijungusių draugų',
      many: '$count prisijungusių draugų',
      few: '$count prisijungę draugai',
      one: '$count prisijungęs draugas',
    );
    return '$_temp0';
  }

  @override
  String nbFollowers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count sekėjų',
      many: '$count sekėjų',
      few: '$count sekėjai',
      one: '$count sekėjas',
    );
    return '$_temp0';
  }

  @override
  String nbFollowing(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count sekamų',
      many: '$count sekamų',
      few: '$count sekami',
      one: '$count sekamas',
    );
    return '$_temp0';
  }

  @override
  String lessThanNbMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Mažiau nei $count minučių',
      many: 'Mažiau nei $count minučių',
      few: 'Mažiau nei $count minutės',
      one: 'Mažiau nei $count minutė',
    );
    return '$_temp0';
  }

  @override
  String nbGamesInPlay(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count vykstančių partijų',
      many: '$count vykstančių partijų',
      few: '$count vykstančios partijos',
      one: '$count vykstanti partija',
    );
    return '$_temp0';
  }

  @override
  String maximumNbCharacters(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Daugiausiai: $count simbolių.',
      many: 'Daugiausiai: $count simbolių.',
      few: 'Daugiausiai: $count simboliai.',
      one: 'Daugiausiai: $count simbolis.',
    );
    return '$_temp0';
  }

  @override
  String blocks(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count užblokuotų',
      many: '$count užblokuotų',
      few: '$count užblokuoti',
      one: '$count užblokuotas',
    );
    return '$_temp0';
  }

  @override
  String nbForumPosts(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count forumo pranešimų',
      many: '$count forumo pranešimų',
      few: '$count forumo pranešimai',
      one: '$count forumo pranešimas',
    );
    return '$_temp0';
  }

  @override
  String nbPerfTypePlayersThisWeek(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count $param2 žaidėjų šią savaitę.',
      many: '$count $param2 žaidėjų šią savaitę.',
      few: '$count $param2 žaidėjai šią savaitę.',
      one: '$count $param2 žaidėjas šią savaitę.',
    );
    return '$_temp0';
  }

  @override
  String availableInNbLanguages(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Galima rinktis iš $count kalbų!',
      many: 'Galima rinktis iš $count kalbų!',
      few: 'Galima rinktis iš $count kalbų!',
      one: 'Galima rinktis iš $count kalbos!',
    );
    return '$_temp0';
  }

  @override
  String nbSecondsToPlayTheFirstMove(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count sekundžių atlikti pirmąjį ėjimą',
      many: '$count sekundžių atlikti pirmąjį ėjimą',
      few: '$count sekundės atlikti pirmąjį ėjimą',
      one: '$count sekundė atlikti pirmąjį ėjimą',
    );
    return '$_temp0';
  }

  @override
  String nbSeconds(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count sekundžių',
      many: '$count sekundžių',
      few: '$count sekundės',
      one: '$count sekundė',
    );
    return '$_temp0';
  }

  @override
  String andSaveNbPremoveLines(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'ir sutaupykite $count išankstinio ėjimo linijų',
      many: 'ir sutaupykite $count išankstinio ėjimo linijų',
      few: 'ir sutaupykite $count išankstinio ėjimo linijas',
      one: 'ir sutaupykite $count išankstinio ėjimo liniją',
    );
    return '$_temp0';
  }

  @override
  String get stormMoveToStart => 'Norėdami pradėti padarykite ėjimą';

  @override
  String get stormYouPlayTheWhitePiecesInAllPuzzles => 'Visose užduotyse žaidžiate baltaisiais';

  @override
  String get stormYouPlayTheBlackPiecesInAllPuzzles => 'Visose užduotyse žaidžiate juodaisiais';

  @override
  String get stormPuzzlesSolved => 'išspręsta užduočių';

  @override
  String get stormNewDailyHighscore => 'Naujas kasdieninis rekordas!';

  @override
  String get stormNewWeeklyHighscore => 'Naujas savaitinis rekordas!';

  @override
  String get stormNewMonthlyHighscore => 'Naujas mėnesinis rekordas!';

  @override
  String get stormNewAllTimeHighscore => 'Naujas visų laikų rekordas!';

  @override
  String stormPreviousHighscoreWasX(String param) {
    return 'Praėjęs rekordas buvo $param';
  }

  @override
  String get stormPlayAgain => 'Žaisti dar';

  @override
  String stormHighscoreX(String param) {
    return 'Rekordas: $param';
  }

  @override
  String get stormScore => 'Taškų';

  @override
  String get stormMoves => 'Ėjimų';

  @override
  String get stormAccuracy => 'Tikslumas';

  @override
  String get stormCombo => 'Iš eilės';

  @override
  String get stormTime => 'Laikas';

  @override
  String get stormTimePerMove => 'Laiko per ėjimą';

  @override
  String get stormHighestSolved => 'Daugiausia išspręsta';

  @override
  String get stormPuzzlesPlayed => 'Sužaista galvosūkių';

  @override
  String get stormNewRun => 'Nauja eilė (klavišas: tarpas)';

  @override
  String get stormEndRun => 'Baigti eilę (klavišas: įvesti)';

  @override
  String get stormHighscores => 'Geriausi rezultatai';

  @override
  String get stormViewBestRuns => 'Peržiūrėti geriausias eiles';

  @override
  String get stormBestRunOfDay => 'Geriausia dienos eilė';

  @override
  String get stormRuns => 'Eilės';

  @override
  String get stormGetReady => 'Pasiruoškite!';

  @override
  String get stormWaitingForMorePlayers => 'Laukiama daugiau žaidėjų...';

  @override
  String get stormRaceComplete => 'Lenktynės baigtos!';

  @override
  String get stormSpectating => 'Stebima';

  @override
  String get stormJoinTheRace => 'Prisijungti prie lenktynių!';

  @override
  String get stormStartTheRace => 'Pradėti lenktynes';

  @override
  String stormYourRankX(String param) {
    return 'Jūsų reitingas: $param';
  }

  @override
  String get stormWaitForRematch => 'Laukti revanšo';

  @override
  String get stormNextRace => 'Kitos lenktynės';

  @override
  String get stormJoinRematch => 'Prisijungti revanšui';

  @override
  String get stormWaitingToStart => 'Laukiama pradžios';

  @override
  String get stormCreateNewGame => 'Kurti naują žaidimą';

  @override
  String get stormJoinPublicRace => 'Prisijungti prie viešų lenktynių';

  @override
  String get stormRaceYourFriends => 'Lenktyniauti su draugais';

  @override
  String get stormSkip => 'praleisti';

  @override
  String get stormSkipHelp => 'NAUJA! Per lenktynes galite praleisti vieną ėjimą:';

  @override
  String get stormSkipExplanation => 'Praleiskite ėjimą norėdami išlaikyti seką! Veikia tik kartą per lenktynes.';

  @override
  String get stormFailedPuzzles => 'Nepavykę galvosūkiai';

  @override
  String get stormSlowPuzzles => 'Lėti galvosūkiai';

  @override
  String get stormSkippedPuzzle => 'Praleista užduotis';

  @override
  String get stormThisWeek => 'Šią savaitę';

  @override
  String get stormThisMonth => 'Šį mėnesį';

  @override
  String get stormAllTime => 'Visų laikų';

  @override
  String get stormClickToReload => 'Spauskite norėdami perkrauti';

  @override
  String get stormThisRunHasExpired => 'Ši eilė pasibaigė!';

  @override
  String get stormThisRunWasOpenedInAnotherTab => 'Ši eilė atidaryta kitoje kortelėje!';

  @override
  String stormXRuns(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count eilių',
      many: '$count eilės',
      few: '$count eilės',
      one: '1 eilė',
    );
    return '$_temp0';
  }

  @override
  String stormPlayedNbRunsOfPuzzleStorm(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Žaista $count $param2 eilių',
      many: 'Žaista $count $param2 eilės',
      few: 'Žaistos $count $param2 eilės',
      one: 'Žaista viena $param2 eilė',
    );
    return '$_temp0';
  }

  @override
  String get streamerLichessStreamers => 'Lichess transliuotojai';

  @override
  String get studyShareAndExport => 'Dalintis ir eksportuoti';

  @override
  String get studyStart => 'Pradėti';
}
