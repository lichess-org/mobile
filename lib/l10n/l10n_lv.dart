import 'package:intl/intl.dart' as intl;

import 'l10n.dart';

/// The translations for Latvian (`lv`).
class AppLocalizationsLv extends AppLocalizations {
  AppLocalizationsLv([String locale = 'lv']) : super(locale);

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
  String get activityActivity => 'Aktivitāte';

  @override
  String get activityHostedALiveStream => 'Rīkoja tiešsaistes straumi';

  @override
  String activityRankedInSwissTournament(String param1, String param2) {
    return 'Ieguva $param1. vietu turnīrā $param2';
  }

  @override
  String get activitySignedUp => 'Reģistrējās lichess.org';

  @override
  String activitySupportedNbMonths(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count mēnešus atbalstīja lichess.org kā $param2',
      one: '$count mēnesi atbalstīja lichess.org kā $param2',
      zero: '$count mēnešus atbalstīja lichess.org kā $param2',
    );
    return '$_temp0';
  }

  @override
  String activityPracticedNbPositions(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Mācījās no $count pozīcijām sadaļā $param2',
      one: 'Mācījās no $count pozīcijas sadaļā $param2',
      zero: 'Mācījās no $count pozīcijām sadaļā $param2',
    );
    return '$_temp0';
  }

  @override
  String activitySolvedNbPuzzles(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Atrisināja $count taktikas uzdevumus',
      one: 'Atrisināja $count taktikas uzdevumu',
      zero: 'Atrisināja $count taktikas uzdevumus',
    );
    return '$_temp0';
  }

  @override
  String activityPlayedNbGames(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Izspēlēja $count $param2 spēles',
      one: 'Izspēlēja $count $param2 spēli',
      zero: 'Izspēlēja $count $param2 spēles',
    );
    return '$_temp0';
  }

  @override
  String activityPostedNbMessages(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Publicēja $count ziņojumus $param2',
      one: 'Publicēja $count ziņojumu $param2',
      zero: 'Publicēja $count ziņojumus $param2',
    );
    return '$_temp0';
  }

  @override
  String activityPlayedNbMoves(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Izspēlēja $count gājienus',
      one: 'Izspēlēja $count gājienus',
      zero: 'Izspēlēja $count gājienus',
    );
    return '$_temp0';
  }

  @override
  String activityInNbCorrespondenceGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count korespondencšaha spēlēs',
      one: '$count korespondencšaha spēlē',
      zero: '$count korespondencšaha spēlēs',
    );
    return '$_temp0';
  }

  @override
  String activityCompletedNbGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Pabeidza $count korespondencšaha spēles',
      one: 'Pabeidza $count korespondencšaha spēli',
      zero: 'Pabeidza $count korespondencšaha spēles',
    );
    return '$_temp0';
  }

  @override
  String activityFollowedNbPlayers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Sāka sekot $count spēlētājiem',
      one: 'Sāka sekot $count spēlētājam',
      zero: 'Sāka sekot $count spēlētājiem',
    );
    return '$_temp0';
  }

  @override
  String activityGainedNbFollowers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Ieguva $count jaunus sekotājus',
      one: 'Ieguva $count jaunu sekotāju',
      zero: 'Ieguva $count jaunus sekotājus',
    );
    return '$_temp0';
  }

  @override
  String activityHostedNbSimuls(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Sarīkoja $count simultānseansus',
      one: 'Sarīkoja $count simultānseansu',
      zero: 'Sarīkoja $count simultānseansus',
    );
    return '$_temp0';
  }

  @override
  String activityJoinedNbSimuls(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Piedalījās $count simultānseansos',
      one: 'Piedalījās $count simultānseansā',
      zero: 'Piedalījās $count simultānseansos',
    );
    return '$_temp0';
  }

  @override
  String activityCreatedNbStudies(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Izveidoja $count jaunas izpētes',
      one: 'Izveidoja $count jaunu izpēti',
      zero: 'Izveidoja $count jaunas izpētes',
    );
    return '$_temp0';
  }

  @override
  String activityCompetedInNbTournaments(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Sacentās $count turnīros',
      one: 'Sacentās $count turnīrā',
      zero: 'Sacentās $count turnīros',
    );
    return '$_temp0';
  }

  @override
  String activityRankedInTournament(int count, String param2, String param3, String param4) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count. vieta (labākajos $param2%) spēlējot $param3 spēles $param4',
      one: '$count. vieta (labākajos $param2%) spēlējot $param3 spēli $param4',
      zero: '$count. vieta (labākajos $param2%) spēlējot $param3 spēles $param4',
    );
    return '$_temp0';
  }

  @override
  String activityCompetedInNbSwissTournaments(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Sacentās $count Šveices turnīros',
      one: 'Sacentās $count Šveices turnīrā',
      zero: 'Sacentās $count Šveices turnīros',
    );
    return '$_temp0';
  }

  @override
  String activityJoinedNbTeams(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Pievienojās $count komandām',
      one: 'Pievienojās $count komandai',
      zero: 'Pievienojās $count komandām',
    );
    return '$_temp0';
  }

  @override
  String get broadcastBroadcasts => 'Raidījumi';

  @override
  String get broadcastLiveBroadcasts => 'Reāllaika turnīru raidījumi';

  @override
  String challengeChallengesX(String param1) {
    return 'Izaicinājumi: $param1';
  }

  @override
  String get challengeChallengeToPlay => 'Izaicināt uz spēli';

  @override
  String get challengeChallengeDeclined => 'Izaicinājums noraidīts';

  @override
  String get challengeChallengeAccepted => 'Izaicinājums pieņemts!';

  @override
  String get challengeChallengeCanceled => 'Izaicinājums atcelts.';

  @override
  String get challengeRegisterToSendChallenges => 'Lūdzu reģistrējieties, lai sūtītu izaicinājumus.';

  @override
  String challengeYouCannotChallengeX(String param) {
    return 'Nevarat izaicināt $param.';
  }

  @override
  String challengeXDoesNotAcceptChallenges(String param) {
    return '$param nepieņem izaicinājumus.';
  }

  @override
  String challengeYourXRatingIsTooFarFromY(String param1, String param2) {
    return 'Jūsu $param1 reitings ir par tālu no $param2.';
  }

  @override
  String challengeCannotChallengeDueToProvisionalXRating(String param) {
    return 'Nevar izaicināt pagaidu $param reitinga dēļ.';
  }

  @override
  String challengeXOnlyAcceptsChallengesFromFriends(String param) {
    return '$param pieņem izaicinājumus tikai no draugiem.';
  }

  @override
  String get challengeDeclineGeneric => 'Pašlaik nepieņemu izaicinājumus.';

  @override
  String get challengeDeclineLater => 'Šis laiks man neder, lūdzu piedāvājiet vēlāk.';

  @override
  String get challengeDeclineTooFast => 'Šī laika kontrole man ir par ātru, lūdzu izaiciniet mani ar lēnāku spēli.';

  @override
  String get challengeDeclineTooSlow => 'Šī laika kontrole man ir par lēnu, lūdzu izaiciniet mani ar ātrāku spēli.';

  @override
  String get challengeDeclineTimeControl => 'Pašlaik nepieņemu izaicinājumus ar šo laika kontroli.';

  @override
  String get challengeDeclineRated => 'Labāk lūdzu atsūtiet vērtētu izaicinājumu.';

  @override
  String get challengeDeclineCasual => 'Labāk lūdzu atsūtiet nevērtētu izaicinājumu.';

  @override
  String get challengeDeclineStandard => 'Šobrīd nepieņemu variantu izaicinājumus.';

  @override
  String get challengeDeclineVariant => 'Šobrīd nevēlos spēlēt šo variantu.';

  @override
  String get challengeDeclineNoBot => 'Pašlaik nepieņemu izaicinājumus no botiem.';

  @override
  String get challengeDeclineOnlyBot => 'Pieņemu izaicinājumus tikai no botiem.';

  @override
  String get challengeInviteLichessUser => 'Vai uzaicināt Lichess lietotāju:';

  @override
  String get contactContact => 'Kontakti';

  @override
  String get contactContactLichess => 'Sazināties ar Lichess';

  @override
  String get patronDonate => 'Ziedot';

  @override
  String get patronLichessPatron => 'Lichess Sponsors';

  @override
  String perfStatPerfStats(String param) {
    return '$param statistika';
  }

  @override
  String get perfStatViewTheGames => 'Skatīt spēles';

  @override
  String get perfStatProvisional => 'pagaidu';

  @override
  String get perfStatNotEnoughRatedGames => 'Nav spēlēts pietiekami vērtētu spēļu, lai izveidotu uzticamu reitingu.';

  @override
  String perfStatProgressOverLastXGames(String param) {
    return 'Attīstība pēdējo $param spēļu laikā:';
  }

  @override
  String perfStatRatingDeviation(String param) {
    return 'Reitinga novirze: $param.';
  }

  @override
  String perfStatRatingDeviationTooltip(String param1, String param2, String param3) {
    return 'Zemākas vērtības nozīmē, ka reitings ir stabilāks. Vērtības virs $param1 piemīt tikai pagaidu reitingiem. Tabulās iekļauj tikai spēlētājus, kam šī vērtība ir zem $param2 parastajā šahā vai $param3 variantos.';
  }

  @override
  String get perfStatTotalGames => 'Spēles kopumā';

  @override
  String get perfStatRatedGames => 'Vērtētās spēles';

  @override
  String get perfStatTournamentGames => 'Turnīru spēles';

  @override
  String get perfStatBerserkedGames => 'Dullās spēles';

  @override
  String get perfStatTimeSpentPlaying => 'Spēlējot pavadītais laiks';

  @override
  String get perfStatAverageOpponent => 'Vidējais pretinieks';

  @override
  String get perfStatVictories => 'Uzvaras';

  @override
  String get perfStatDefeats => 'Zaudējumi';

  @override
  String get perfStatDisconnections => 'Atvienošanās';

  @override
  String get perfStatNotEnoughGames => 'Nav spēlēts pietiekami spēļu';

  @override
  String perfStatHighestRating(String param) {
    return 'Augstākais reitings: $param';
  }

  @override
  String perfStatLowestRating(String param) {
    return 'Zemākais reitings: $param';
  }

  @override
  String perfStatFromXToY(String param1, String param2) {
    return 'no $param1 līdz $param2';
  }

  @override
  String get perfStatWinningStreak => 'Uzvaras pēc kārtas';

  @override
  String get perfStatLosingStreak => 'Zaudējumi pēc kārtas';

  @override
  String perfStatLongestStreak(String param) {
    return 'Garākā sērija: $param';
  }

  @override
  String perfStatCurrentStreak(String param) {
    return 'Pašreizējā sērija: $param';
  }

  @override
  String get perfStatBestRated => 'Labākās vērtētās uzvaras';

  @override
  String get perfStatGamesInARow => 'Pēc kārtas spēlētās spēles';

  @override
  String get perfStatLessThanOneHour => 'Mazāk par stundu starp spēlēm';

  @override
  String get perfStatMaxTimePlaying => 'Ilgākais spēlējot pavadītais laiks';

  @override
  String get perfStatNow => 'tagad';

  @override
  String get preferencesPreferences => 'Uzstādījumi';

  @override
  String get preferencesDisplay => 'Izskats';

  @override
  String get preferencesPrivacy => 'Privātums';

  @override
  String get preferencesNotifications => 'Paziņojumi';

  @override
  String get preferencesPieceAnimation => 'Figūru animācija';

  @override
  String get preferencesMaterialDifference => 'Materiāla starpība';

  @override
  String get preferencesBoardHighlights => 'Lauciņu izcelšana (pēdējais gājiens vai piesakot šahu)';

  @override
  String get preferencesPieceDestinations => 'Figūru galamērķi (atļauti gājieni vai priekšgājieni)';

  @override
  String get preferencesBoardCoordinates => 'Galdiņa koordinātas (A-H, 1-8)';

  @override
  String get preferencesMoveListWhilePlaying => 'Gājienu saraksts spēles laikā';

  @override
  String get preferencesPgnPieceNotation => 'Gājienu notācija';

  @override
  String get preferencesChessPieceSymbol => 'Šaha figūras simbols';

  @override
  String get preferencesPgnLetter => 'Burts (K, Q, R, B, N)';

  @override
  String get preferencesZenMode => 'Zen režīms';

  @override
  String get preferencesShowPlayerRatings => 'Rādīt spēlētāju reitingus';

  @override
  String get preferencesShowFlairs => 'Show player flairs';

  @override
  String get preferencesExplainShowPlayerRatings => 'Šī iespēja ļauj slēpt visus reitingus mājaslapā, lai palīdzētu koncentrēties uz pašu šahu. Spēles joprojām var būt vērtētas – šis attiecas tikai uz to, ko jūs redzat.';

  @override
  String get preferencesDisplayBoardResizeHandle => 'Rādīt galdiņa izmēra maiņas rīku';

  @override
  String get preferencesOnlyOnInitialPosition => 'Tikai sākotnējajā pozīcijā';

  @override
  String get preferencesInGameOnly => 'In-game only';

  @override
  String get preferencesChessClock => 'Šaha pulkstenis';

  @override
  String get preferencesTenthsOfSeconds => 'Sekunžu desmitdaļas';

  @override
  String get preferencesWhenTimeRemainingLessThanTenSeconds => 'Ja atlicis < 10 sekundēm';

  @override
  String get preferencesHorizontalGreenProgressBars => 'Zaļā horizontālā izpildes josla';

  @override
  String get preferencesSoundWhenTimeGetsCritical => 'Signalizēt, kad laika pavisam maz';

  @override
  String get preferencesGiveMoreTime => 'Dot vairāk laika';

  @override
  String get preferencesGameBehavior => 'Spēles uzvedība';

  @override
  String get preferencesHowDoYouMovePieces => 'Kā pārvietot figūras?';

  @override
  String get preferencesClickTwoSquares => 'Klikšķinot uz diviem lauciņiem';

  @override
  String get preferencesDragPiece => 'Velkot figūru';

  @override
  String get preferencesBothClicksAndDrag => 'Jebkurā veidā';

  @override
  String get preferencesPremovesPlayingDuringOpponentTurn => 'Priekšgājieni (izdarīti pretinieka gājienā)';

  @override
  String get preferencesTakebacksWithOpponentApproval => 'Gājienu atsaukšana (ar pretinieka piekrišanu)';

  @override
  String get preferencesInCasualGamesOnly => 'Tikai nevērtētajās spēlēs';

  @override
  String get preferencesPromoteToQueenAutomatically => 'Automātiski pārvērst par Dāmu';

  @override
  String get preferencesExplainPromoteToQueenAutomatically => 'Turiet nospiestu taustiņu <ctrl>, kad paaugstinat bandinieku, lai īslaicīgi atspējotu automātisko paaugstināšanu';

  @override
  String get preferencesWhenPremoving => 'Tikai priekšgājienos';

  @override
  String get preferencesClaimDrawOnThreefoldRepetitionAutomatically => 'Automātiski pieprasīt trīskāršās atkārtošanās neizšķirtu';

  @override
  String get preferencesWhenTimeRemainingLessThanThirtySeconds => 'Ja atlicis < 30 sekundēm';

  @override
  String get preferencesMoveConfirmation => 'Gājiena apstiprināšana';

  @override
  String get preferencesExplainCanThenBeTemporarilyDisabled => 'Izslēdzams spēles laikā no galdiņa izvēlnes';

  @override
  String get preferencesInCorrespondenceGames => 'Korespondencšaha spēlēs';

  @override
  String get preferencesCorrespondenceAndUnlimited => 'Korespondencšaha un bezgalīgajās spēlēs';

  @override
  String get preferencesConfirmResignationAndDrawOffers => 'Apstiprināt padošanos un neizšķirta piedāvājumus';

  @override
  String get preferencesCastleByMovingTheKingTwoSquaresOrOntoTheRook => 'Rokādes metode';

  @override
  String get preferencesCastleByMovingTwoSquares => 'Pārvietot karali par diviem lauciņiem';

  @override
  String get preferencesCastleByMovingOntoTheRook => 'Pārvietot karali virsū tornim';

  @override
  String get preferencesInputMovesWithTheKeyboard => 'Ievadīt gājienus ar tastatūru';

  @override
  String get preferencesInputMovesWithVoice => 'Input moves with your voice';

  @override
  String get preferencesSnapArrowsToValidMoves => 'Pievilkt bultas pie iespējamiem gājieniem';

  @override
  String get preferencesSayGgWpAfterLosingOrDrawing => 'Sūtīt \"Good game, well played\" (angļ. val. \"Laba partija, labi nospēlēta\") pēc uzvaras vai neizšķirta';

  @override
  String get preferencesYourPreferencesHaveBeenSaved => 'Jūsu uzstādījumi ir saglabāti.';

  @override
  String get preferencesScrollOnTheBoardToReplayMoves => 'Ritiniet peli virs galdiņa, lai skatītu spēles gaitu';

  @override
  String get preferencesCorrespondenceEmailNotification => 'E-pasta ziņojums reizi dienā par jūsu korespondencšaha spēlēm';

  @override
  String get preferencesNotifyStreamStart => 'Straumētājs sāk tiešraidi';

  @override
  String get preferencesNotifyInboxMsg => 'Jauna ziņa iesūtnē';

  @override
  String get preferencesNotifyForumMention => 'Foruma ziņa jūs piemin';

  @override
  String get preferencesNotifyInvitedStudy => 'Izpētes ielūgums';

  @override
  String get preferencesNotifyGameEvent => 'Notikumi Korespondencšahā';

  @override
  String get preferencesNotifyChallenge => 'Izaicinājumi';

  @override
  String get preferencesNotifyTournamentSoon => 'Turnīra sākums tuvojas';

  @override
  String get preferencesNotifyTimeAlarm => 'Korespondencšaha laiks izsīkst';

  @override
  String get preferencesNotifyBell => 'Zvana paziņojumi Lichess programmā';

  @override
  String get preferencesNotifyPush => 'Ierīces paziņojumi, kad neesat platformā Lichess';

  @override
  String get preferencesNotifyWeb => 'Pārlūkprogrammā';

  @override
  String get preferencesNotifyDevice => 'Ierīcē';

  @override
  String get preferencesBellNotificationSound => 'Paziņojumu skaņa';

  @override
  String get puzzlePuzzles => 'Uzdevumi';

  @override
  String get puzzlePuzzleThemes => 'Uzdevumu temati';

  @override
  String get puzzleRecommended => 'Ieteikumi';

  @override
  String get puzzlePhases => 'Posmi';

  @override
  String get puzzleMotifs => 'Motīvi';

  @override
  String get puzzleAdvanced => 'Lietpratējiem';

  @override
  String get puzzleLengths => 'Garumi';

  @override
  String get puzzleMates => 'Mati';

  @override
  String get puzzleGoals => 'Mērķi';

  @override
  String get puzzleOrigin => 'Izcelsme';

  @override
  String get puzzleSpecialMoves => 'Īpaši gājieni';

  @override
  String get puzzleDidYouLikeThisPuzzle => 'Vai patika šis uzdevums?';

  @override
  String get puzzleVoteToLoadNextOne => 'Balsojiet, lai ielādētu nākamo!';

  @override
  String get puzzleUpVote => 'Patīk puzle';

  @override
  String get puzzleDownVote => 'Nepatīk puzle';

  @override
  String get puzzleYourPuzzleRatingWillNotChange => 'Jūsu uzdevumu reitings nemainīsies. Ievērojiet, ka uzdevumu risināšana nav sacensības. Reitings mums palīdz atlasīt labākos uzdevumus jūsu prasmju līmenim.';

  @override
  String get puzzleFindTheBestMoveForWhite => 'Atrodiet labāko gājienu baltajiem.';

  @override
  String get puzzleFindTheBestMoveForBlack => 'Atrodiet labāko gājienu melnajiem.';

  @override
  String get puzzleToGetPersonalizedPuzzles => 'Lai iegūtu pielāgotus uzdevumus:';

  @override
  String puzzlePuzzleId(String param) {
    return 'Uzdevums $param';
  }

  @override
  String get puzzlePuzzleOfTheDay => 'Dienas uzdevums';

  @override
  String get puzzleDailyPuzzle => 'Šodienas uzdevums';

  @override
  String get puzzleClickToSolve => 'Klikšķiniet, lai atrisinātu';

  @override
  String get puzzleGoodMove => 'Labs gājiens';

  @override
  String get puzzleBestMove => 'Vislabākais gājiens!';

  @override
  String get puzzleKeepGoing => 'Turpiniet…';

  @override
  String get puzzlePuzzleSuccess => 'Izdevās!';

  @override
  String get puzzlePuzzleComplete => 'Uzdevums atrisināts!';

  @override
  String get puzzleByOpenings => 'Pa atklātnēm';

  @override
  String get puzzlePuzzlesByOpenings => 'Puzles pa atklātnēm';

  @override
  String get puzzleOpeningsYouPlayedTheMost => 'Visvairāk spēlētās atklātnes spēlēs ar reitingu';

  @override
  String get puzzleUseFindInPage => 'Lieto \"Find in page\" no pārlūka izvēlnes lai atrastu savu mīļāko atklātni!';

  @override
  String get puzzleUseCtrlF => 'Lieto Ctrl+f lai atrastu savu mīļāko atklātni!';

  @override
  String get puzzleNotTheMove => 'Tas nav īstais gājiens!';

  @override
  String get puzzleTrySomethingElse => 'Izmēģiniet ko citu.';

  @override
  String puzzleRatingX(String param) {
    return 'Reitings: $param';
  }

  @override
  String get puzzleHidden => 'slēpts';

  @override
  String puzzleFromGameLink(String param) {
    return 'No spēles $param';
  }

  @override
  String get puzzleContinueTraining => 'Turpināt treniņu';

  @override
  String get puzzleDifficultyLevel => 'Grūtības pakāpe';

  @override
  String get puzzleNormal => 'Parasta';

  @override
  String get puzzleEasier => 'Vieglāka';

  @override
  String get puzzleEasiest => 'Visvieglākā';

  @override
  String get puzzleHarder => 'Grūtāka';

  @override
  String get puzzleHardest => 'Visgrūtākā';

  @override
  String get puzzleExample => 'Piemērs';

  @override
  String get puzzleAddAnotherTheme => 'Pievienot jaunu tēmu';

  @override
  String get puzzleNextPuzzle => 'Nākamais uzdevums';

  @override
  String get puzzleJumpToNextPuzzleImmediately => 'Uzreiz pārslēgties uz nākamo uzdevumu';

  @override
  String get puzzlePuzzleDashboard => 'Uzdevumu panelis';

  @override
  String get puzzleImprovementAreas => 'Uzlabojamās jomas';

  @override
  String get puzzleStrengths => 'Uzdevumi, kas padodas';

  @override
  String get puzzleHistory => 'Uzdevumu vēsture';

  @override
  String get puzzleSolved => 'atrisināts';

  @override
  String get puzzleFailed => 'neizdevās';

  @override
  String get puzzleStreakDescription => 'Atrisiniet aizvien grūtākus uzdevumus un veidojiet uzvaru sēriju. Varat domāt, cik ilgi vēlaties, jo laiks nav ierobežots. Viens nepareizs gājiens, un spēle galā! Taču varat izlaist vienu gājienu katrā sesijā.';

  @override
  String puzzleYourStreakX(String param) {
    return 'Jūsu uzvaru posms: $param';
  }

  @override
  String get puzzleStreakSkipExplanation => 'Izlaist gājienu, lai paturētu uzvaru sēriju. Darbojas tikai vienreiz katrā spēlē.';

  @override
  String get puzzleContinueTheStreak => 'Turpināt uzvaru sēriju';

  @override
  String get puzzleNewStreak => 'Jauna uzvaru sērija';

  @override
  String get puzzleFromMyGames => 'No manām spēlēm';

  @override
  String get puzzleLookupOfPlayer => 'Meklēt uzdevumus no kāda spēlētāja spēlēm';

  @override
  String puzzleFromXGames(String param) {
    return 'Uzdevumi no spēlētāja $param spēlēm';
  }

  @override
  String get puzzleSearchPuzzles => 'Meklēt uzdevumus';

  @override
  String get puzzleFromMyGamesNone => 'Mums ļoti žēl, bet jums nav neviena uzdevuma datu bāzē.\n\nSpēlējiet ātrās vai klasiskajās spēlēs, lai paaugstinātu varbūtību, ka no tām tiks izveidots uzdevums!';

  @override
  String puzzleFromXGamesFound(String param1, String param2) {
    return 'Atrasti $param1 uzdevumi no $param2 spēlēm';
  }

  @override
  String get puzzlePuzzleDashboardDescription => 'Trenēties, izpētīt un uzlabot prasmes';

  @override
  String puzzlePercentSolved(String param) {
    return '$param atrisinātas';
  }

  @override
  String get puzzleNoPuzzlesToShow => 'Nav ko parādīt; vispirms izspēlējiet kādu uzdevumu!';

  @override
  String get puzzleImprovementAreasDescription => 'Apgūstiet šīs tēmas, lai ātrāk uzlabotu prasmes!';

  @override
  String get puzzleStrengthDescription => 'Vislabāk jums padodas šīs prasmes';

  @override
  String puzzlePlayedXTimes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Spēlēts $count reizes',
      one: 'Spēlēts $count reizi',
      zero: 'Spēlēts $count reizes',
    );
    return '$_temp0';
  }

  @override
  String puzzleNbPointsBelowYourPuzzleRating(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count punkti zem jūsu uzdevumu reitinga',
      one: '$count punkts zem jūsu pužļu reitinga',
      zero: '$count punktu zem jūsu uzdevumu reitinga',
    );
    return '$_temp0';
  }

  @override
  String puzzleNbPointsAboveYourPuzzleRating(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count punkti virs jūsu uzdevumu reitinga',
      one: '$count punkts virs jūsu uzdevumu reitinga',
      zero: '$count punktu virs jūsu uzdevumu reitinga',
    );
    return '$_temp0';
  }

  @override
  String puzzleNbPlayed(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count izspēlētas',
      one: '$count izspēlēta',
      zero: '$count izspēlētas',
    );
    return '$_temp0';
  }

  @override
  String puzzleNbToReplay(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count jāatkārto',
      one: '$count jāatkārto',
      zero: '$count jāatkārto',
    );
    return '$_temp0';
  }

  @override
  String get puzzleThemeAdvancedPawn => 'Brīvbandinieks';

  @override
  String get puzzleThemeAdvancedPawnDescription => 'Kāds no jūsu bandiniekiem nonācis dziļi pretinieka pozīcijā, iespējams draudot ar paaugstināšanu.';

  @override
  String get puzzleThemeAdvantage => 'Pārsvars';

  @override
  String get puzzleThemeAdvantageDescription => 'Izmantojiet iespēju iegūt noteicošu pārsvaru. (200cp ≤ vērtējums ≤ 600cp)';

  @override
  String get puzzleThemeAnastasiaMate => 'Anastāsijas mats';

  @override
  String get puzzleThemeAnastasiaMateDescription => 'Zirdziņš ar torni vai dāmu iesprosto pretinieka karali starp galdiņa malu un viņa paša figūru.';

  @override
  String get puzzleThemeArabianMate => 'Arābu mats';

  @override
  String get puzzleThemeArabianMateDescription => 'Zirdziņš ar torni kopīgi iesprosto pretinieka karali galdiņa stūrī.';

  @override
  String get puzzleThemeAttackingF2F7 => 'Uzbrukums f2 vai f7';

  @override
  String get puzzleThemeAttackingF2F7Description => 'Uzbrukums, kas koncentrējas uz f2 vai f7 bandinieku, līdzīgi \"fried liver\" (angļ. val. \"cepto aknu\") atklātnei.';

  @override
  String get puzzleThemeAttraction => 'Ievilkšana';

  @override
  String get puzzleThemeAttractionDescription => 'Apmaiņa vai upuris, kas mudina vai piespiež pretinieka figūru ieņemt kādu lauciņu, darot iespējamu taktikas turpinājumu.';

  @override
  String get puzzleThemeBackRankMate => 'Līnijmats';

  @override
  String get puzzleThemeBackRankMateDescription => 'Piesakiet matu karalim, kuru savā rindā iesprostojušas paša figūras.';

  @override
  String get puzzleThemeBishopEndgame => 'Laidņu galotne';

  @override
  String get puzzleThemeBishopEndgameDescription => 'Beigu spēle, kurā iesaistīti tikai laidņi un bandinieki.';

  @override
  String get puzzleThemeBodenMate => 'Bodena mats';

  @override
  String get puzzleThemeBodenMateDescription => 'Divi laidņi uz pretēju krāsu krusteniskām diagonālēm piesaka matu karalim, kura izbēgšanu traucē paša figūras.';

  @override
  String get puzzleThemeCastling => 'Rokāde';

  @override
  String get puzzleThemeCastlingDescription => 'Nogādājiet karali drošībā un novietojiet torni uzbrukuma pozīcijā.';

  @override
  String get puzzleThemeCapturingDefender => 'Sargājošas figūras nosišana';

  @override
  String get puzzleThemeCapturingDefenderDescription => 'Nosist figūru, kas nepieciešama citas figūras aizsardzībai, padarot iespējamu neaizsargātās figūras nosišanu nākamajā gājienā.';

  @override
  String get puzzleThemeCrushing => 'Graušana';

  @override
  String get puzzleThemeCrushingDescription => 'Ieraugiet pretinieka rupjo kļūdu, lai iegūtu graujošu pārsvaru. (vērtējums > 600cp)';

  @override
  String get puzzleThemeDoubleBishopMate => 'Dubultlaidņa mats';

  @override
  String get puzzleThemeDoubleBishopMateDescription => 'Divi laidņi uz blakus diagonālēm piesaka matu karalim, ko ierobežo paša figūras.';

  @override
  String get puzzleThemeDovetailMate => 'Kozio mats';

  @override
  String get puzzleThemeDovetailMateDescription => 'Dāma piesaka matu nostājoties pie pretinieka karaļa tā, ka tā abi neapdraudētie lauciņi ir aizņemti ar paša figūrām.';

  @override
  String get puzzleThemeEquality => 'Vienlīdzība';

  @override
  String get puzzleThemeEqualityDescription => 'Atgriezieties no zaudējošas pozīcijas, un iegūstiet neizšķirtu vai vienlīdzīgu pozīciju. (vērtējums ≤ 200cp)';

  @override
  String get puzzleThemeKingsideAttack => 'Karaļa puses uzbrukums';

  @override
  String get puzzleThemeKingsideAttackDescription => 'Uzbrukums pretinieka karalim pēc rokādes karaļa pusē.';

  @override
  String get puzzleThemeClearance => 'Atbrīvošana';

  @override
  String get puzzleThemeClearanceDescription => 'Gājiens, kas atbrīvo lauciņu, rindu vai diagonāli un bieži iegūst tempu, ļaujot turpināt taktisko ideju.';

  @override
  String get puzzleThemeDefensiveMove => 'Aizsargājošs gājiens';

  @override
  String get puzzleThemeDefensiveMoveDescription => 'Precīzs gājiens vai gājienu virkne, kas nepieciešama, lai nezaudētu materiālu vai citu priekšrocību.';

  @override
  String get puzzleThemeDeflection => 'Novirze';

  @override
  String get puzzleThemeDeflectionDescription => 'Gājiens, kas novērš pretinieka figūras uzmanību no kāda lauciņa sargāšanas vai cita uzdevuma.';

  @override
  String get puzzleThemeDiscoveredAttack => 'Atklāts uzbrukums';

  @override
  String get puzzleThemeDiscoveredAttackDescription => 'Figūras, kas iepriekš bloķēja slīdošas figūras uzbrukumu, izkustināšana — piemēram zirdziņa aizkustināšana no torņa ceļa.';

  @override
  String get puzzleThemeDoubleCheck => 'Dubultais šahs';

  @override
  String get puzzleThemeDoubleCheckDescription => 'Atklāta uzbrukuma rezultātā pieteikts šahs ar abām figūrām vienlaikus: gan ar atklāto figūru, gan ar izkustināto figūru.';

  @override
  String get puzzleThemeEndgame => 'Beigu spēle';

  @override
  String get puzzleThemeEndgameDescription => 'Sēles noslēdzošā posma taktika.';

  @override
  String get puzzleThemeEnPassantDescription => 'Stratēģija, kas iesaista garāmejošā sitiena noteikumu, kurš nosaka, ka bandinieks var nosist pretinieka bandinieku, ja tas tikko nostājies blakus ar sākotnējo divu lauciņu gājienu.';

  @override
  String get puzzleThemeExposedKing => 'Atklāts karalis';

  @override
  String get puzzleThemeExposedKingDescription => 'Uzbrukums karalim, kam ir maz aizsargājošu figūru; šis bieži noved pie mata.';

  @override
  String get puzzleThemeFork => 'Dakša';

  @override
  String get puzzleThemeForkDescription => 'Gājiens, pēc kura kustinātā figūra uzbrūk diviem pretiniekiem reizē.';

  @override
  String get puzzleThemeHangingPiece => 'Neapsargāta figūra';

  @override
  String get puzzleThemeHangingPieceDescription => 'Taktika, ar kuru var par brīvu nosist pretinieka figūru, kas ir neapsargāta vai nepietiekami apsargāta.';

  @override
  String get puzzleThemeHookMate => 'Āķa mats';

  @override
  String get puzzleThemeHookMateDescription => 'Mats ar torni, zirdziņu un bandinieku, kurā iesaistīts viens pretinieka bandinieks, kas ierobežo karaļa izbēgšanu.';

  @override
  String get puzzleThemeInterference => 'Iejaukšanās';

  @override
  String get puzzleThemeInterferenceDescription => 'Figūras novietošana starp divām pretinieka figūrām tā, lai vismaz viena no tām būtu neapsargāta — piemēram zirdziņa novietošana uz apsargāta lauciņa starp torņiem.';

  @override
  String get puzzleThemeIntermezzo => 'Intermezzo';

  @override
  String get puzzleThemeIntermezzoDescription => 'Tā vietā lai izspēlētu sagaidīto gājienu, vispirms iestarpiniet citu gājienu, kas radīs neatliekamus draudus, par kuriem pretiniekam būs jārūpējas. Pazīstams arī kā \"Zwischenzug\" vai kā gājiens \"pa vidu\".';

  @override
  String get puzzleThemeKnightEndgame => 'Zirdziņu beigu spēle';

  @override
  String get puzzleThemeKnightEndgameDescription => 'Beigu spēle, kurā iesaistīti tikai zirdziņi un bandinieki.';

  @override
  String get puzzleThemeLong => 'Garš uzdevums';

  @override
  String get puzzleThemeLongDescription => 'Trīs gājieni līdz uzvarai.';

  @override
  String get puzzleThemeMaster => 'Meistaru spēles';

  @override
  String get puzzleThemeMasterDescription => 'Puzles no spēlēm, ko spēlējuši spēlētāji ar tituliem.';

  @override
  String get puzzleThemeMasterVsMaster => 'Meistaru spēles pret meistariem';

  @override
  String get puzzleThemeMasterVsMasterDescription => 'Puzles no spēlēm, kurās abiem spēlētājiem ir tituli.';

  @override
  String get puzzleThemeMate => 'Mats';

  @override
  String get puzzleThemeMateDescription => 'Uzvariet spēli ar stilu.';

  @override
  String get puzzleThemeMateIn1 => 'Mats vienā gājienā';

  @override
  String get puzzleThemeMateIn1Description => 'Piesakiet matu vienā gājienā.';

  @override
  String get puzzleThemeMateIn2 => 'Mats 2 gājienos';

  @override
  String get puzzleThemeMateIn2Description => 'Piesakiet matu divos gājienos.';

  @override
  String get puzzleThemeMateIn3 => 'Mats 3 gājienos';

  @override
  String get puzzleThemeMateIn3Description => 'Piesakiet matu trīs gājienos.';

  @override
  String get puzzleThemeMateIn4 => 'Mats 4 gājienos';

  @override
  String get puzzleThemeMateIn4Description => 'Piesakiet matu četros gājienos.';

  @override
  String get puzzleThemeMateIn5 => 'Mats 5 vai vairāk gājienos';

  @override
  String get puzzleThemeMateIn5Description => 'Izdomājiet garu gājienu virkni, kas beidzas ar matu.';

  @override
  String get puzzleThemeMiddlegame => 'Vidusspēle';

  @override
  String get puzzleThemeMiddlegameDescription => 'Spēles otrā posma taktika.';

  @override
  String get puzzleThemeOneMove => 'Viena gājiena uzdevums';

  @override
  String get puzzleThemeOneMoveDescription => 'Uzdevums, kas ilgst tikai vienu gājienu.';

  @override
  String get puzzleThemeOpening => 'Atklātne';

  @override
  String get puzzleThemeOpeningDescription => 'Atklātnes posma taktika.';

  @override
  String get puzzleThemePawnEndgame => 'Bandinieku beigu spēle';

  @override
  String get puzzleThemePawnEndgameDescription => 'Beigu spēle, kurā iesaistīti tikai bandinieki.';

  @override
  String get puzzleThemePin => 'Piespraušana';

  @override
  String get puzzleThemePinDescription => 'Taktika, kas iesaista piespraušanu – pozīciju, kurā figūra nevar izkustēties bez uzbrukuma atklāšanas augstākas vērtības figūrai.';

  @override
  String get puzzleThemePromotion => 'Paaugstināšana';

  @override
  String get puzzleThemePromotionDescription => 'Paaugstiniet bandinieku par dāmu vai citu figūru.';

  @override
  String get puzzleThemeQueenEndgame => 'Dāmu beigu spēle';

  @override
  String get puzzleThemeQueenEndgameDescription => 'Beigu spēle, kurā iesaistīti tikai bandinieki un dāmas.';

  @override
  String get puzzleThemeQueenRookEndgame => 'Dāmu un torņu beigu spēle';

  @override
  String get puzzleThemeQueenRookEndgameDescription => 'Beigu spēle, kurā iesaistīti tikai bandinieki, torņi un dāmas.';

  @override
  String get puzzleThemeQueensideAttack => 'Dāmas puses uzbrukums';

  @override
  String get puzzleThemeQueensideAttackDescription => 'Uzbrukums pretinieka karalim pēc rokādes dāmas pusē.';

  @override
  String get puzzleThemeQuietMove => 'Klusais gājiens';

  @override
  String get puzzleThemeQuietMoveDescription => 'Gājiens, kas nepiesaka šahu un nenosit nevienu figūru, tomēr sagatavo nenovēršamus draudus kādā sekojošā gājienā.';

  @override
  String get puzzleThemeRookEndgame => 'Torņu beigu spēle';

  @override
  String get puzzleThemeRookEndgameDescription => 'Beigu spēle, kurā iesaistīti tikai torņi un bandinieki.';

  @override
  String get puzzleThemeSacrifice => 'Upuris';

  @override
  String get puzzleThemeSacrificeDescription => 'Stratēģija, kurā īstermiņā atdod materiālu, lai atkal iegūtu pārsvaru pēc piespiestu gājienu virknes.';

  @override
  String get puzzleThemeShort => 'Īss uzdevums';

  @override
  String get puzzleThemeShortDescription => 'Divi gājieni līdz uzvarai.';

  @override
  String get puzzleThemeSkewer => 'Iesms';

  @override
  String get puzzleThemeSkewerDescription => 'Šis motīvs iesaista augstas vērtības figūru, kurai jāizkustās, lai izvairītos no uzbrukuma, atļaujot vai nu uzbrukumu mazākas vērtības figūrai, kas atrodas aiz tās, vai arī šīs figūras nosišanu – pretējais piespraušanai.';

  @override
  String get puzzleThemeSmotheredMate => 'Smacējošais mats';

  @override
  String get puzzleThemeSmotheredMateDescription => 'Zirdziņa pieteikts mats karalim, kas nevar kustēties dēļ paša figūrām, kas to ielenkušas (nosmacējušas).';

  @override
  String get puzzleThemeSuperGM => 'Super-Lielmeistaru spēles';

  @override
  String get puzzleThemeSuperGMDescription => 'Uzdevumi no labāko pasaules spēlētāju spēlēm.';

  @override
  String get puzzleThemeTrappedPiece => 'Iesprostota figūra';

  @override
  String get puzzleThemeTrappedPieceDescription => 'Figūra nevar izbēgt nosišanu, jo ierobežoti tās gājieni.';

  @override
  String get puzzleThemeUnderPromotion => 'Pieticīga paaugstināšana';

  @override
  String get puzzleThemeUnderPromotionDescription => 'Paaugstināšana par zirdziņu, laidni vai torni.';

  @override
  String get puzzleThemeVeryLong => 'Ļoti garš uzdevums';

  @override
  String get puzzleThemeVeryLongDescription => 'Vismaz četri gājieni līdz uzvarai.';

  @override
  String get puzzleThemeXRayAttack => 'Rentgena uzbrukums';

  @override
  String get puzzleThemeXRayAttackDescription => 'Figūra uzbrūk vai apsargā lauciņu caur pretinieka figūru.';

  @override
  String get puzzleThemeZugzwang => 'Zugzwang';

  @override
  String get puzzleThemeZugzwangDescription => 'Pretiniekam ir ierobežoti iespējamie gājieni, un visi no tiem pasliktina pretinieka pozīciju.';

  @override
  String get puzzleThemeHealthyMix => 'Veselīgs sajaukums';

  @override
  String get puzzleThemeHealthyMixDescription => 'Mazliet no visa kā. Nezināsiet, ko sagaidīt, tāpēc paliksiet gatavs jebkam! Tieši kā īstās spēlēs.';

  @override
  String get puzzleThemePlayerGames => 'Spēlētāja spēles';

  @override
  String get puzzleThemePlayerGamesDescription => 'Meklējiet uzdevumus, kas radīti no jūsu vai cita spēlētāja spēlēm.';

  @override
  String puzzleThemePuzzleDownloadInformation(String param) {
    return 'Šie uzdevumi ir neaizsargājami darbi, un tos var lejupielādēt lapā $param.';
  }

  @override
  String get searchSearch => 'Meklēt';

  @override
  String get settingsSettings => 'Iestatījumi';

  @override
  String get settingsCloseAccount => 'Slēgt kontu';

  @override
  String get settingsManagedAccountCannotBeClosed => 'Jūsu konts tiek pārvaldīts, un to nevar slēgt.';

  @override
  String get settingsClosingIsDefinitive => 'Slēgšana ir galīga. Atpakaļceļa nav. Vai esat pārliecināts?';

  @override
  String get settingsCantOpenSimilarAccount => 'Nevarēsiet atvērt jaunu kontu ar to pašu vārdu, pat ja burtu lielumi atšķirsies.';

  @override
  String get settingsChangedMindDoNotCloseAccount => 'Es pārdomāju, neslēdziet manu kontu';

  @override
  String get settingsCloseAccountExplanation => 'Vai esat pārliecināts, ka vēlaties slēgt kontu? Konta slēgšanu nevar atsaukt. Jūs vairs nekad nevarēsiet ierakstīties.';

  @override
  String get settingsThisAccountIsClosed => 'Šis konts ir slēgts.';

  @override
  String get playWithAFriend => 'Spēlēt ar draugu';

  @override
  String get playWithTheMachine => 'Spēlēt ar datoru';

  @override
  String get toInviteSomeoneToPlayGiveThisUrl => 'Lai uzaicinātu kādu spēlēt, iedod šo saiti';

  @override
  String get gameOver => 'Spēle galā';

  @override
  String get waitingForOpponent => 'Gaidām pretinieku';

  @override
  String get orLetYourOpponentScanQrCode => 'Or let your opponent scan this QR code';

  @override
  String get waiting => 'Gaida';

  @override
  String get yourTurn => 'Jūsu gājiens';

  @override
  String aiNameLevelAiLevel(String param1, String param2) {
    return '$param1 $param2. līmenis';
  }

  @override
  String get level => 'Līmenis';

  @override
  String get strength => 'Stiprums';

  @override
  String get toggleTheChat => 'Ieslēgt/izslēgt sarunu';

  @override
  String get chat => 'Saruna';

  @override
  String get resign => 'Padoties';

  @override
  String get checkmate => 'Šahs un mats';

  @override
  String get stalemate => 'Pats';

  @override
  String get white => 'Baltie';

  @override
  String get black => 'Melnie';

  @override
  String get asWhite => 'ar baltajiem';

  @override
  String get asBlack => 'ar melnajiem';

  @override
  String get randomColor => 'Nejauša krāsa';

  @override
  String get createAGame => 'Izveidot spēli';

  @override
  String get whiteIsVictorious => 'Baltie ir uzvarējuši';

  @override
  String get blackIsVictorious => 'Melnie ir uzvarējuši';

  @override
  String get youPlayTheWhitePieces => 'Jūs spēlējat ar baltajiem';

  @override
  String get youPlayTheBlackPieces => 'Jūs spēlējat ar melnajiem';

  @override
  String get itsYourTurn => 'Jūsu gājiens!';

  @override
  String get cheatDetected => 'Konstatēta šmaukšanās';

  @override
  String get kingInTheCenter => 'Karalis vidū';

  @override
  String get threeChecks => 'Trīs šahi';

  @override
  String get raceFinished => 'Sacīkstes beigušās';

  @override
  String get variantEnding => 'Beigas saskaņā ar speciālajiem noteikumiem';

  @override
  String get newOpponent => 'Ar jaunu pretinieku';

  @override
  String get yourOpponentWantsToPlayANewGameWithYou => 'Pretinieks vēlas ar jums spēlēt jaunu spēli';

  @override
  String get joinTheGame => 'Pievienoties spēlei';

  @override
  String get whitePlays => 'Gājiens baltajiem';

  @override
  String get blackPlays => 'Gājiens melnajiem';

  @override
  String get opponentLeftChoices => 'Jūsu pretinieks pametis spēli. Varat pieprasīt uzvaru, pabeigt spēli neizšķirtu vai gaidīt.';

  @override
  String get forceResignation => 'Pieprasīt uzvaru';

  @override
  String get forceDraw => 'Pieprasīt neizšķirtu';

  @override
  String get talkInChat => 'Tērzējot, lūdzu, esiet pieklājīgi!';

  @override
  String get theFirstPersonToComeOnThisUrlWillPlayWithYou => 'Pirmais, kurš izmantos šo saiti, spēlēs ar jums.';

  @override
  String get whiteResigned => 'Baltie padevās';

  @override
  String get blackResigned => 'Melnie padevās';

  @override
  String get whiteLeftTheGame => 'Baltie pameta spēli';

  @override
  String get blackLeftTheGame => 'Melnie pameta spēli';

  @override
  String get whiteDidntMove => 'Baltie neveica gājienu';

  @override
  String get blackDidntMove => 'Melnie neveica gājienu';

  @override
  String get requestAComputerAnalysis => 'Pieprasīt datoranalīzi';

  @override
  String get computerAnalysis => 'Datoranalīze';

  @override
  String get computerAnalysisAvailable => 'Pieejama datoranalīze';

  @override
  String get computerAnalysisDisabled => 'Datora analīze atspējota';

  @override
  String get analysis => 'Analīze';

  @override
  String depthX(String param) {
    return 'Dziļums $param';
  }

  @override
  String get usingServerAnalysis => 'Izmanto servera analīzi';

  @override
  String get loadingEngine => 'Ielādē dzinēju...';

  @override
  String get calculatingMoves => 'Aprēķina gājienus...';

  @override
  String get engineFailed => 'Kļūda ielādējot dzinēju';

  @override
  String get cloudAnalysis => 'Mākoņanalīze';

  @override
  String get goDeeper => 'Dziļāka analīze';

  @override
  String get showThreat => 'Parādīt draudus';

  @override
  String get inLocalBrowser => 'savā pārlūkprogrammā';

  @override
  String get toggleLocalEvaluation => 'Ieslēgt/izslēgt vērtēšanu pārlūkprogrammā';

  @override
  String get promoteVariation => 'Izvēlēties variantu';

  @override
  String get makeMainLine => 'Pārvērst par pamatvariantu';

  @override
  String get deleteFromHere => 'Dzēst šo un turpmākos gājienus';

  @override
  String get collapseVariations => 'Collapse variations';

  @override
  String get expandVariations => 'Expand variations';

  @override
  String get forceVariation => 'Rādīt kā variantu';

  @override
  String get copyVariationPgn => 'Copy variation PGN';

  @override
  String get move => 'Gājiens';

  @override
  String get variantLoss => 'Variācijas zaudējums';

  @override
  String get variantWin => 'Variācijas uzvara';

  @override
  String get insufficientMaterial => 'Nepietiekams materiāls';

  @override
  String get pawnMove => 'Bandinieka gājiens';

  @override
  String get capture => 'Sitiens';

  @override
  String get close => 'Aizvērt';

  @override
  String get winning => 'Uzvarošs';

  @override
  String get losing => 'Zaudējošs';

  @override
  String get drawn => 'Neizšķirts';

  @override
  String get unknown => 'Neskaidrs';

  @override
  String get database => 'Datubāze';

  @override
  String get whiteDrawBlack => 'Baltie / Neizšķirts / Melnie';

  @override
  String averageRatingX(String param) {
    return 'Vidējais reitings: $param';
  }

  @override
  String get recentGames => 'Nesenas spēles';

  @override
  String get topGames => 'Labākās spēles';

  @override
  String masterDbExplanation(String param1, String param2, String param3) {
    return 'Divi miljoni reālu spēļu, ko spēlējuši spēlētāji ar $param1+ FIDE reitingu laika posmā no $param2 līdz $param3';
  }

  @override
  String get dtzWithRounding => 'DTZ50\'\' ar noapaļošanu, balstīts uz pusgājienu skaita līdz nākamajam sitienam vai bandinieka gājienam';

  @override
  String get noGameFound => 'Neviena spēle nav atrasta';

  @override
  String get maxDepthReached => 'Sasniegts dziļuma ierobežojums!';

  @override
  String get maybeIncludeMoreGamesFromThePreferencesMenu => 'Varbūt iekļaujiet vairāk spēļu uzstādījumu izvēlnē?';

  @override
  String get openings => 'Atklātnes';

  @override
  String get openingExplorer => 'Atklātņu pārlūks';

  @override
  String get openingEndgameExplorer => 'Atklātņu un beigu spēļu pārlūks';

  @override
  String xOpeningExplorer(String param) {
    return '$param atklātņu pārlūks';
  }

  @override
  String get playFirstOpeningEndgameExplorerMove => 'Izdarīt pirmo atklātņu/galotņu pārlūka gājienu';

  @override
  String get winPreventedBy50MoveRule => '50 gājienu noteikums novērsa uzvaru';

  @override
  String get lossSavedBy50MoveRule => '50 gājienu likums novērš zaudējumu';

  @override
  String get winOr50MovesByPriorMistake => 'Uzvara vai 50-gājienu neizšķirts iepriekšējas kļūdas dēļ';

  @override
  String get lossOr50MovesByPriorMistake => 'Zaudējums vai 50-gājienu neizšķirts iepriekšējas kļūdas dēļ';

  @override
  String get unknownDueToRounding => 'Uzvara/zaudējums garantēts tikai tad, ja veikti ieteiktie gājieni kopš pēdējā sitiena vai bandinieka gājiena tādēļ, ka iespējama DTZ vērtību noapaļošana \"Syzygy\" tabulās.';

  @override
  String get allSet => 'Gatavs!';

  @override
  String get importPgn => 'Importēt PGN';

  @override
  String get delete => 'Dzēst';

  @override
  String get deleteThisImportedGame => 'Dzēst šo ielādēto spēli?';

  @override
  String get replayMode => 'Atkārtojuma režīms';

  @override
  String get realtimeReplay => 'Reāllaikā';

  @override
  String get byCPL => 'Pēc CPL';

  @override
  String get openStudy => 'Atvērt izpēti';

  @override
  String get enable => 'Iespējot';

  @override
  String get bestMoveArrow => 'Labākā gājiena bulta';

  @override
  String get showVariationArrows => 'Show variation arrows';

  @override
  String get evaluationGauge => 'Novērtējuma rādītājs';

  @override
  String get multipleLines => 'Vairāki varianti';

  @override
  String get cpus => 'Procesori';

  @override
  String get memory => 'Atmiņa';

  @override
  String get infiniteAnalysis => 'Bezgalīga analīze';

  @override
  String get removesTheDepthLimit => 'Noņem dziļuma ierobežojumu un uztur tavu datoru siltu';

  @override
  String get engineManager => 'Dzinēja pārvaldnieks';

  @override
  String get blunder => 'Rupja kļūda';

  @override
  String get mistake => 'Kļūda';

  @override
  String get inaccuracy => 'Neprecizitāte';

  @override
  String get moveTimes => 'Gājienu ilgumi';

  @override
  String get flipBoard => 'Apgriezt galdiņu';

  @override
  String get threefoldRepetition => 'Trīskārša atkārtošanās';

  @override
  String get claimADraw => 'Pieprasīt neizšķirtu';

  @override
  String get offerDraw => 'Piedāvāt neizšķirtu';

  @override
  String get draw => 'Neizšķirts';

  @override
  String get drawByMutualAgreement => 'Spēlētāji vienojās par neizšķirtu';

  @override
  String get fiftyMovesWithoutProgress => 'Piecdesmit gājieni bez attīstības';

  @override
  String get currentGames => 'Pašreizējās spēles';

  @override
  String get viewInFullSize => 'Skatīt pilnā izmērā';

  @override
  String get logOut => 'Izrakstīties';

  @override
  String get signIn => 'Pierakstīties';

  @override
  String get rememberMe => 'Ierakstīties pastāvīgi';

  @override
  String get youNeedAnAccountToDoThat => 'Lai veiktu šo darbību, nepieciešams konts';

  @override
  String get signUp => 'Reģistrēties';

  @override
  String get computersAreNotAllowedToPlay => 'Datoriem un spēlētājiem, kuri izmanto datoru palīdzību, nav atļauts spēlēt. Lūdzu, spēlējot neizmantojiet šaha programmu, datubāžu vai citu spēlētāju palīdzību. Aicinām neizmantot vairākus kontus - tas var novest pie piekļuves pārtraukšanas.';

  @override
  String get games => 'Spēles';

  @override
  String get forum => 'Forums';

  @override
  String xPostedInForumY(String param1, String param2) {
    return '$param1 publicēja ziņu forumā \"$param2\"';
  }

  @override
  String get latestForumPosts => 'Jaunākie foruma paziņojumi';

  @override
  String get players => 'Spēlētāji';

  @override
  String get friends => 'Draugi';

  @override
  String get discussions => 'Sarunas';

  @override
  String get today => 'Šodien';

  @override
  String get yesterday => 'Vakar';

  @override
  String get minutesPerSide => 'Minūtes katram spēlētājam';

  @override
  String get variant => 'Variants';

  @override
  String get variants => 'Varianti';

  @override
  String get timeControl => 'Laika kontrole';

  @override
  String get realTime => 'Reāllaikā';

  @override
  String get correspondence => 'Korespondencšahs';

  @override
  String get daysPerTurn => 'Dienu skaits uz gājienu';

  @override
  String get oneDay => 'Viena diena';

  @override
  String get time => 'Laiks';

  @override
  String get rating => 'Reitings';

  @override
  String get ratingStats => 'Reitinga statistika';

  @override
  String get username => 'Lietotājvārds';

  @override
  String get usernameOrEmail => 'Lietotājvārds vai e-pasta adrese';

  @override
  String get changeUsername => 'Mainīt lietotājvārdu';

  @override
  String get changeUsernameNotSame => 'Drīkst mainīt tikai burtu lielumu. Piemēram \"jānisbērziņš\" var mainīt uz \"JānisBērziņš\".';

  @override
  String get changeUsernameDescription => 'Mainīt lietotājvārdu. To var izdarīt tikai vienreiz, un ir atļauts mainīt tikai lielo burtu lietojumu lietotājvārdā.';

  @override
  String get signupUsernameHint => 'Atcerieties izvēlēties pieklājīgu lietotājvārdu. To nav iespējams mainīt, un konti ar nepiedienīgiem lietotājvārdiem tiks slēgti!';

  @override
  String get signupEmailHint => 'Mēs to izmantosim tikai paroles atiestatīšanai.';

  @override
  String get password => 'Parole';

  @override
  String get changePassword => 'Mainīt paroli';

  @override
  String get changeEmail => 'Mainīt e-pasta adresi';

  @override
  String get email => 'E-pasta adrese';

  @override
  String get passwordReset => 'Atiestatīt paroli';

  @override
  String get forgotPassword => 'Aizmirsāt paroli?';

  @override
  String get error_weakPassword => 'Šī parole ir ļoti bieži izmantota, un viegli uzminama.';

  @override
  String get error_namePassword => 'Lūdzu, neizmantojiet savu lietotājvārdu kā paroli.';

  @override
  String get blankedPassword => 'Šī parole tikusi izmantota citā vietnē, kas tika kompromitēta. Lai nodrošinātu sava konta drošību, jums jāiestata jauna parole. Paldies par sapratni!';

  @override
  String get youAreLeavingLichess => 'Jūs pārejat uz vietni ārpus Lichess';

  @override
  String get neverTypeYourPassword => 'Nekad neievadiet savu Lichess paroli citā vietnē!';

  @override
  String proceedToX(String param) {
    return 'Virzīties uz $param';
  }

  @override
  String get passwordSuggestion => 'Neizmantojiet paroli, ko ieteicis kāds cits. To var izmantot, lai gūtu piekļuvi jūsu kontam.';

  @override
  String get emailSuggestion => 'Neizmantojiet e-pasta adresi, ko ieteicis kāds cits. To var izmantot, lai gūtu piekļuvi jūsu kontam.';

  @override
  String get emailConfirmHelp => 'Palīdzība ar epasta apstiprinājumu';

  @override
  String get emailConfirmNotReceived => 'Nesaņēmāt apstiprinājuma epastu pēc reģistrēšanās?';

  @override
  String get whatSignupUsername => 'Kādu lietotājvārdu izmantojāt, kad reģistrējāties?';

  @override
  String usernameNotFound(String param) {
    return 'Nevarējām atrast nevienu lietotāju ar šādu vārdu: $param.';
  }

  @override
  String get usernameCanBeUsedForNewAccount => 'Varat izmantot šo lietotājvārdu jaunam kontam';

  @override
  String emailSent(String param) {
    return 'Esam nosūtījuši epastu uz $param.';
  }

  @override
  String get emailCanTakeSomeTime => 'Iespējams, paies kāds laiks, līdz to saņemsiet.';

  @override
  String get refreshInboxAfterFiveMinutes => 'Pagaidiet 5 minūtes, un atsvaidziniet savu epasta iesūtni.';

  @override
  String get checkSpamFolder => 'Pārbaudiet arī mēstuļu nodalījumu – iespējams, mūsu ziņa tur nonākusi. Tādā gadījumā, lūdzu atzīmējiet, ka tā nav mēstule.';

  @override
  String get emailForSignupHelp => 'Ja nekas cits neizdodas, nosūtiet mums šo epastu:';

  @override
  String copyTextToEmail(String param) {
    return 'Kopējiet augšup esošo tekstu un sūtiet to $param';
  }

  @override
  String get waitForSignupHelp => 'Drīz mēs jums pievērsīsimies un palīdzēsim pabeigt reģistrāciju.';

  @override
  String accountConfirmed(String param) {
    return 'Lietotājs $param ir veiksmīgi apstiprināts.';
  }

  @override
  String accountCanLogin(String param) {
    return 'Tagad varat ierakstīties kā $param.';
  }

  @override
  String get accountConfirmationEmailNotNeeded => 'Jums nav nepieciešams apstiprinājuma epasts.';

  @override
  String accountClosed(String param) {
    return 'Lietotāja $param konts ir slēgts.';
  }

  @override
  String accountRegisteredWithoutEmail(String param) {
    return 'Konts $param tika reģistrēts bez epasta.';
  }

  @override
  String get rank => 'Vieta';

  @override
  String rankX(String param) {
    return 'Vieta: $param';
  }

  @override
  String get gamesPlayed => 'Izspēlētās spēles';

  @override
  String get cancel => 'Atcelt';

  @override
  String get whiteTimeOut => 'Baltajiem beidzās laiks';

  @override
  String get blackTimeOut => 'Melnajiem beidzās laiks';

  @override
  String get drawOfferSent => 'Neizšķirta piedāvājums nosūtīts';

  @override
  String get drawOfferAccepted => 'Neizšķirta piedāvājums pieņemts';

  @override
  String get drawOfferCanceled => 'Neizšķirta piedāvājums atcelts';

  @override
  String get whiteOffersDraw => 'Baltie piedāvā neizšķirtu';

  @override
  String get blackOffersDraw => 'Melnie piedāvā neizšķirtu';

  @override
  String get whiteDeclinesDraw => 'Baltie noraida neizšķirtu';

  @override
  String get blackDeclinesDraw => 'Melnie noraida neizšķirtu';

  @override
  String get yourOpponentOffersADraw => 'Jūsu pretinieks piedāvā neizšķirtu';

  @override
  String get accept => 'Pieņemt';

  @override
  String get decline => 'Noraidīt';

  @override
  String get playingRightNow => 'Šobrīd spēlē';

  @override
  String get eventInProgress => 'Šobrīd notiek';

  @override
  String get finished => 'Beidzies';

  @override
  String get abortGame => 'Atcelt spēli';

  @override
  String get gameAborted => 'Spēle atcelta';

  @override
  String get standard => 'Standarta';

  @override
  String get customPosition => 'Custom position';

  @override
  String get unlimited => 'Neierobežots';

  @override
  String get mode => 'Veids';

  @override
  String get casual => 'Draudzīga';

  @override
  String get rated => 'Vērtēta';

  @override
  String get casualTournament => 'Draudzīga';

  @override
  String get ratedTournament => 'Vērtēta';

  @override
  String get thisGameIsRated => 'Šī spēle ir vērtēta';

  @override
  String get rematch => 'Spēlēt atkal';

  @override
  String get rematchOfferSent => 'Revanša piedāvājums nosūtīts';

  @override
  String get rematchOfferAccepted => 'Revanša piedāvājums pieņemts';

  @override
  String get rematchOfferCanceled => 'Revanša piedāvājums atcelts';

  @override
  String get rematchOfferDeclined => 'Revanša piedāvājums noraidīts';

  @override
  String get cancelRematchOffer => 'Atcelt revanša piedāvājumu';

  @override
  String get viewRematch => 'Skatīties revanšu';

  @override
  String get confirmMove => 'Apstiprināt gājienu';

  @override
  String get play => 'Spēlēt';

  @override
  String get inbox => 'Iesūtne';

  @override
  String get chatRoom => 'Sarunu istaba';

  @override
  String get loginToChat => 'Pieslēdzieties lai tērzētu';

  @override
  String get youHaveBeenTimedOut => 'Jūs esat uz laiku izraidīts.';

  @override
  String get spectatorRoom => 'Skatītāju istaba';

  @override
  String get composeMessage => 'Rakstīt ziņu';

  @override
  String get subject => 'Temats';

  @override
  String get send => 'Sūtīt';

  @override
  String get incrementInSeconds => 'Pieaugums sekundēs';

  @override
  String get freeOnlineChess => 'Bezmaksas šahs tiešsaistē';

  @override
  String get exportGames => 'Eksportēt spēles';

  @override
  String get ratingRange => 'Reitinga diapazons';

  @override
  String get thisAccountViolatedTos => 'Šis konts pārkāpa Lichess Pakalpojuma Noteikumus';

  @override
  String get openingExplorerAndTablebase => 'Atklātņu pārlūks & datubāze';

  @override
  String get takeback => 'Gājiena atsaukšana';

  @override
  String get proposeATakeback => 'Piedāvāt gājiena atsaukšanu';

  @override
  String get takebackPropositionSent => 'Piedāvāta gājiena atsaukšana';

  @override
  String get takebackPropositionDeclined => 'Gājiena atsaukšana atteikta';

  @override
  String get takebackPropositionAccepted => 'Gājiena atsaukšana pieņemta';

  @override
  String get takebackPropositionCanceled => 'Gājiena atsaukšanas piedāvājums atcelts';

  @override
  String get yourOpponentProposesATakeback => 'Jūsu pretinieks piedāvā atsaukt gājienu';

  @override
  String get bookmarkThisGame => 'Atzīmēt šo spēli';

  @override
  String get tournament => 'Turnīrs';

  @override
  String get tournaments => 'Turnīri';

  @override
  String get tournamentPoints => 'Turnīra punkti';

  @override
  String get viewTournament => 'Skatīt turnīru';

  @override
  String get backToTournament => 'Atgriezties turnīrā';

  @override
  String get noDrawBeforeSwissLimit => 'Šveices turnīrā neizšķirts nav iespējams pirms izdarīti 30 gājieni.';

  @override
  String get thematic => 'Tematisks';

  @override
  String yourPerfRatingIsProvisional(String param) {
    return 'Jūsu pagaidu reitings ir $param';
  }

  @override
  String yourPerfRatingIsTooHigh(String param1, String param2) {
    return 'Tavs $param1 reitings ($param2) ir pārāk augsts';
  }

  @override
  String yourTopWeeklyPerfRatingIsTooHigh(String param1, String param2) {
    return 'Jūsu nedēļas augstākais $param1 reitings ($param2) ir pārāk augsts';
  }

  @override
  String yourPerfRatingIsTooLow(String param1, String param2) {
    return 'Tavs $param1 reitings ($param2) ir pārāk zems';
  }

  @override
  String ratedMoreThanInPerf(String param1, String param2) {
    return '$param2 reitings ≥ $param1';
  }

  @override
  String ratedLessThanInPerf(String param1, String param2) {
    return '$param2 reitings ≤ $param1';
  }

  @override
  String mustBeInTeam(String param) {
    return 'Jābūt komandas \"$param\" dalībniekam';
  }

  @override
  String youAreNotInTeam(String param) {
    return 'Tu neesi komandas \"$param\" dalībnieks';
  }

  @override
  String get backToGame => 'Atgriezties spēlē';

  @override
  String get siteDescription => 'Bezmaksas šahs tiešsaistē. Spēlē šahu lakoniskā saskarnē tagad: bez reģistrācijas, reklāmām, vai papildus programmatūras! Spēlē pret datoru, draugiem vai nejaušiem pretiniekiem.';

  @override
  String xJoinedTeamY(String param1, String param2) {
    return '$param1 pievienojās komandai \"$param2\"';
  }

  @override
  String xCreatedTeamY(String param1, String param2) {
    return '$param1 izveidoja komandu \"$param2\"';
  }

  @override
  String get startedStreaming => 'sāka straumēt';

  @override
  String xStartedStreaming(String param) {
    return '$param sāka straumēt';
  }

  @override
  String get averageElo => 'Vidējais reitings';

  @override
  String get location => 'Atrašanās vieta';

  @override
  String get filterGames => 'Atlasīt spēles';

  @override
  String get reset => 'Atiestatīt';

  @override
  String get apply => 'Apstiprināt';

  @override
  String get save => 'Saglabāt';

  @override
  String get leaderboard => 'Labāko spēlētāju saraksts';

  @override
  String get screenshotCurrentPosition => 'Uzņemt pašreizējās pozīcijas attēlu';

  @override
  String get gameAsGIF => 'Spēle GIF formātā';

  @override
  String get pasteTheFenStringHere => 'Ielīmējiet FEN tekstu šeit';

  @override
  String get pasteThePgnStringHere => 'Ielīmējiet PGN tekstu šeit';

  @override
  String get orUploadPgnFile => 'Augšuplādēt PGN datni';

  @override
  String get fromPosition => 'No pozīcijas';

  @override
  String get continueFromHere => 'Turpināt no šejienes';

  @override
  String get toStudy => 'Izpētīt';

  @override
  String get importGame => 'Importēt spēli';

  @override
  String get importGameExplanation => 'Ielīmējiet spēles PGN, lai iegūtu pārskatāmu atkārtojumu, datoranalīzi, spēles sarunu un URL ar ko dalīties.';

  @override
  String get importGameCaveat => 'Variācijas tiks izdzēstas. Lai tās paturētu, importē PGN izmantot izpētes rīku.';

  @override
  String get importGameDataPrivacyWarning => 'This PGN can be accessed by the public. To import a game privately, use a study.';

  @override
  String get thisIsAChessCaptcha => 'Šis ir šaha CAPTCHA.';

  @override
  String get clickOnTheBoardToMakeYourMove => 'Noklikšķiniet uz laukuma, lai izdarītu gājienu un pierādītu, ka esat cilvēks.';

  @override
  String get captcha_fail => 'Lūdzu, atrisiniet šaha cilvēktestu.';

  @override
  String get notACheckmate => 'Nav šahs un mats';

  @override
  String get whiteCheckmatesInOneMove => 'Baltie pieteiks matu vienā gājienā';

  @override
  String get blackCheckmatesInOneMove => 'Melnie pieteiks matu vienā gājienā';

  @override
  String get retry => 'Mēģināt vēlreiz';

  @override
  String get reconnecting => 'Atjauno savienojumu';

  @override
  String get noNetwork => 'Offline';

  @override
  String get favoriteOpponents => 'Biežākie pretinieki';

  @override
  String get follow => 'Sekot';

  @override
  String get following => 'Sekotie';

  @override
  String get unfollow => 'Beigt sekot';

  @override
  String followX(String param) {
    return 'Sekot $param';
  }

  @override
  String unfollowX(String param) {
    return 'Nesekot $param';
  }

  @override
  String get block => 'Bloķēt';

  @override
  String get blocked => 'Bloķētie';

  @override
  String get unblock => 'Atbloķēt';

  @override
  String get followsYou => 'Sekotāji';

  @override
  String xStartedFollowingY(String param1, String param2) {
    return '$param1 sāka sekot $param2';
  }

  @override
  String get more => 'Vairāk';

  @override
  String get memberSince => 'Dalībnieks kopš';

  @override
  String lastSeenActive(String param) {
    return 'Aktīvs $param';
  }

  @override
  String get player => 'Spēlētājs';

  @override
  String get list => 'Saraksts';

  @override
  String get graph => 'Grafiks';

  @override
  String get required => 'Obligāts.';

  @override
  String get openTournaments => 'Atvērtie turnīri';

  @override
  String get duration => 'Ilgums';

  @override
  String get winner => 'Uzvarētājs';

  @override
  String get standing => 'Pozīcija';

  @override
  String get createANewTournament => 'Izveidot jaunu turnīru';

  @override
  String get tournamentCalendar => 'Turnīru kalendārs';

  @override
  String get conditionOfEntry => 'Dalības prasības:';

  @override
  String get advancedSettings => 'Uzstādījumi lietpratējiem';

  @override
  String get safeTournamentName => 'Izvēlieties drošu turnīra nosaukumu.';

  @override
  String get inappropriateNameWarning => 'Jebkas kaut nedaudz nepiedienīgs var novest pie jūsu konta slēgšanas.';

  @override
  String get emptyTournamentName => 'Atstājiet neaizpildītu, lai nosauktu turnīru kāda ievērojama šahista vārdā.';

  @override
  String get makePrivateTournament => 'Padarīt turnīru privātu, un ierobežot piekļuvi ar paroli';

  @override
  String get join => 'Pievienoties';

  @override
  String get withdraw => 'Izstāties';

  @override
  String get points => 'Punkti';

  @override
  String get wins => 'Uzvaras';

  @override
  String get losses => 'Zaudējumi';

  @override
  String get createdBy => 'Izveidoja';

  @override
  String get tournamentIsStarting => 'Turnīrs sākas';

  @override
  String get tournamentPairingsAreNowClosed => 'Turnīra pārošana ir beigusies.';

  @override
  String standByX(String param) {
    return 'Lūdzu, uzgaidiet, $param, sapāro spēlētājus, esiet gatavs!';
  }

  @override
  String get pause => 'Pauzēt';

  @override
  String get resume => 'Atsākt';

  @override
  String get youArePlaying => 'Jūs spēlējat!';

  @override
  String get winRate => 'Uzvaru attiecība';

  @override
  String get berserkRate => 'Dullo spēļu biežums';

  @override
  String get performance => 'Sniegums';

  @override
  String get tournamentComplete => 'Turnīrs beidzies';

  @override
  String get movesPlayed => 'Izspēlēti gājieni';

  @override
  String get whiteWins => 'Balto uzvaras';

  @override
  String get blackWins => 'Melno uzvaras';

  @override
  String get drawRate => 'Draw rate';

  @override
  String get draws => 'Neizšķirti';

  @override
  String nextXTournament(String param) {
    return 'Nākamais $param turnīrs:';
  }

  @override
  String get averageOpponent => 'Vidējais pretinieks';

  @override
  String get boardEditor => 'Galdiņa redaktors';

  @override
  String get setTheBoard => 'Uzstādīt galdiņu';

  @override
  String get popularOpenings => 'Populāras atklātnes';

  @override
  String get endgamePositions => 'Spēļu beigu pozīcijas';

  @override
  String chess960StartPosition(String param) {
    return '960-šaha sākumpozīcija: $param';
  }

  @override
  String get startPosition => 'Sākuma pozīcija';

  @override
  String get clearBoard => 'Notīrīt lauciņu';

  @override
  String get loadPosition => 'Ielādēt pozīciju';

  @override
  String get isPrivate => 'Privāts';

  @override
  String reportXToModerators(String param) {
    return 'Ziņot par $param moderatoriem';
  }

  @override
  String profileCompletion(String param) {
    return 'Profils aizpildīts: $param';
  }

  @override
  String xRating(String param) {
    return '$param reitings';
  }

  @override
  String get ifNoneLeaveEmpty => 'Ja nav piešķirts, atstājiet tukšu';

  @override
  String get profile => 'Profils';

  @override
  String get editProfile => 'Labot profilu';

  @override
  String get realName => 'Real name';

  @override
  String get setFlair => 'Set your flair';

  @override
  String get flair => 'Flair';

  @override
  String get youCanHideFlair => 'There is a setting to hide all user flairs across the entire site.';

  @override
  String get biography => 'Biogrāfija';

  @override
  String get countryRegion => 'Country or region';

  @override
  String get thankYou => 'Paldies!';

  @override
  String get socialMediaLinks => 'Sociālo mediju saites';

  @override
  String get oneUrlPerLine => 'Katrā rindā vienu URL.';

  @override
  String get inlineNotation => 'Iekļautā notācija';

  @override
  String get makeAStudy => 'Lai saglabātu un dalītos, varat izveidot izpēti.';

  @override
  String get clearSavedMoves => 'Dzēst gājienus';

  @override
  String get previouslyOnLichessTV => 'Iepriekš pārraidīts Lichess TV';

  @override
  String get onlinePlayers => 'Spēlētāji tiešsaistē';

  @override
  String get activePlayers => 'Aktīvākie spēlētāji';

  @override
  String get bewareTheGameIsRatedButHasNoClock => 'Uzmanību! Spēle ir vērtēta bet bez laika limita!';

  @override
  String get success => 'Izdevās';

  @override
  String get automaticallyProceedToNextGameAfterMoving => 'Pēc gājiena automātiski pāriet uz nākamo spēli';

  @override
  String get autoSwitch => 'Pašpārslēgšanās';

  @override
  String get puzzles => 'Uzdevumi';

  @override
  String get onlineBots => 'Online bots';

  @override
  String get name => 'Nosaukums';

  @override
  String get description => 'Apraksts';

  @override
  String get descPrivate => 'Privātais apraksts';

  @override
  String get descPrivateHelp => 'Teksts, ko, ja norādīsiet, komandas dalībnieki redzēs publiskā apraksta vietā.';

  @override
  String get no => 'Nē';

  @override
  String get yes => 'Jā';

  @override
  String get help => 'Palīdzība:';

  @override
  String get createANewTopic => 'Izveidot jaunu tematu';

  @override
  String get topics => 'Temati';

  @override
  String get posts => 'Ieraksti';

  @override
  String get lastPost => 'Pēdējais ieraksts';

  @override
  String get views => 'Skatījumi';

  @override
  String get replies => 'Atbildes';

  @override
  String get replyToThisTopic => 'Atbildēt šajā forumā';

  @override
  String get reply => 'Atbilde';

  @override
  String get message => 'Ziņojums';

  @override
  String get createTheTopic => 'Izveidot tematu';

  @override
  String get reportAUser => 'Ziņot par lietotāju';

  @override
  String get user => 'Lietotājs';

  @override
  String get reason => 'Iemesls';

  @override
  String get whatIsIheMatter => 'Kas par lietu?';

  @override
  String get cheat => 'Krāpšanās';

  @override
  String get troll => 'Troļļošana';

  @override
  String get other => 'Cits';

  @override
  String get reportDescriptionHelp => 'Ielīmējiet spēles saiti un paskaidrojiet, kas nav kārtībā ar lietotāja uzvedību. Nepietiks, ja tikai norādīsiet, ka \"lietotājs krāpjas\" — lūdzu, pastāstiet, kā nonācāt pie šī secinājuma. Ja jūsu ziņojums būs rakstīts angliski, par to varēsim parūpēties ātrāk.';

  @override
  String get error_provideOneCheatedGameLink => 'Lūdzu, norādiet vismaz vienu saiti uz spēli, kurā pretinieks ir krāpies.';

  @override
  String by(String param) {
    return 'no $param';
  }

  @override
  String importedByX(String param) {
    return 'Importēja $param';
  }

  @override
  String get thisTopicIsNowClosed => 'Šis temats tagad ir slēgts.';

  @override
  String get blog => 'Blogs';

  @override
  String get notes => 'Piezīmes';

  @override
  String get typePrivateNotesHere => 'Personīgās piezīmes rakstiet šeit';

  @override
  String get writeAPrivateNoteAboutThisUser => 'Izveidot privātu piezīmi par šo lietotāju';

  @override
  String get noNoteYet => 'Nav piezīmes';

  @override
  String get invalidUsernameOrPassword => 'Nepareizs lietotājvārds vai parole';

  @override
  String get incorrectPassword => 'Nepareiza parole';

  @override
  String get invalidAuthenticationCode => 'Nederīgs autentifikācijas kods';

  @override
  String get emailMeALink => 'Atsūtīt saiti epastā';

  @override
  String get currentPassword => 'Esošā parole';

  @override
  String get newPassword => 'Jaunā parole';

  @override
  String get newPasswordAgain => 'Jaunā parole (atkārtoti)';

  @override
  String get newPasswordsDontMatch => 'Jaunās paroles nesaskan';

  @override
  String get newPasswordStrength => 'Paroles stiprums';

  @override
  String get clockInitialTime => 'Sākotnējais pulksteņa laiks';

  @override
  String get clockIncrement => 'Laika pieaugums';

  @override
  String get privacy => 'Privātums';

  @override
  String get privacyPolicy => 'Privātuma politiku';

  @override
  String get letOtherPlayersFollowYou => 'Ļaut citiem jums sekot';

  @override
  String get letOtherPlayersChallengeYou => 'Ļaut citiem jūs izaicināt';

  @override
  String get letOtherPlayersInviteYouToStudy => 'Ļaut citiem jūs uzaicināt uz izpēti';

  @override
  String get sound => 'Skaņa';

  @override
  String get none => 'Nekāda';

  @override
  String get fast => 'Ātra';

  @override
  String get normal => 'Normāls';

  @override
  String get slow => 'Lēna';

  @override
  String get insideTheBoard => 'Galdiņa iekšpusē';

  @override
  String get outsideTheBoard => 'Galdiņa ārpusē';

  @override
  String get allSquaresOfTheBoard => 'All squares of the board';

  @override
  String get onSlowGames => 'Lēnajās spēlēs';

  @override
  String get always => 'Vienmēr';

  @override
  String get never => 'Nekad';

  @override
  String xCompetesInY(String param1, String param2) {
    return '$param1 piedalās $param2';
  }

  @override
  String get victory => 'Uzvara';

  @override
  String get defeat => 'Zaudējums';

  @override
  String victoryVsYInZ(String param1, String param2, String param3) {
    return '$param1 pret $param2 $param3 spēlē';
  }

  @override
  String defeatVsYInZ(String param1, String param2, String param3) {
    return '$param1 pret $param2 $param3 spēlē';
  }

  @override
  String drawVsYInZ(String param1, String param2, String param3) {
    return '$param1 pret $param2 $param3 spēlē';
  }

  @override
  String get timeline => 'Laika grafiks';

  @override
  String get starting => 'Sāksies:';

  @override
  String get allInformationIsPublicAndOptional => 'Visa informācija ir publiska un nav obligāta.';

  @override
  String get biographyDescription => 'Pastāstiet par sevi un savām interesēm, mīļākajām atklātnēm, spēlētājiem, kāpēc jums patīk šahs...';

  @override
  String get listBlockedPlayers => 'Rādīt bloķēto spēlētāju sarakstu';

  @override
  String get human => 'Cilvēks';

  @override
  String get computer => 'Dators';

  @override
  String get side => 'Krāsa';

  @override
  String get clock => 'Pulkstenis';

  @override
  String get opponent => 'Pretinieks';

  @override
  String get learnMenu => 'Apgūt';

  @override
  String get studyMenu => 'Izpētīt';

  @override
  String get practice => 'Trenēties';

  @override
  String get community => 'Kopiena';

  @override
  String get tools => 'Rīki';

  @override
  String get increment => 'Pieaugums';

  @override
  String get error_unknown => 'Nederīga vērtība';

  @override
  String get error_required => 'Šis lauks ir obligāts';

  @override
  String get error_email => 'Šī e-pasta adrese nav derīga';

  @override
  String get error_email_acceptable => 'Šī e-pasta adrese nav pieņemama. Lūdzu pārbaudiet to un mēģiniet vēlreiz.';

  @override
  String get error_email_unique => 'E-pasta adrese jau ir aizņemta vai nav derīga';

  @override
  String get error_email_different => 'Šī jau ir jūsu e-pasta adrese';

  @override
  String error_minLength(String param) {
    return 'Minimālais garums ir $param';
  }

  @override
  String error_maxLength(String param) {
    return 'Maksimālais garums ir $param';
  }

  @override
  String error_min(String param) {
    return 'Jābūt vismaz $param';
  }

  @override
  String error_max(String param) {
    return 'Nedrīkst būt lielāks par $param';
  }

  @override
  String ifRatingIsPlusMinusX(String param) {
    return 'Ja reitings ir ± $param';
  }

  @override
  String get ifRegistered => 'Registrētie lietotāji';

  @override
  String get onlyExistingConversations => 'Tikai iesāktajās sarunās';

  @override
  String get onlyFriends => 'Tikai draugi';

  @override
  String get menu => 'Izvēlne';

  @override
  String get castling => 'Rokāde';

  @override
  String get whiteCastlingKingside => 'Baltajiem O-O';

  @override
  String get blackCastlingKingside => 'Melnajiem O-O';

  @override
  String tpTimeSpentPlaying(String param) {
    return 'Spēlējot pavadītais laiks: $param';
  }

  @override
  String get watchGames => 'Skatīties spēles';

  @override
  String tpTimeSpentOnTV(String param) {
    return 'TV laiks: $param';
  }

  @override
  String get watch => 'Skatīties';

  @override
  String get videoLibrary => 'Video bibliotēka';

  @override
  String get streamersMenu => 'Straumētāji';

  @override
  String get mobileApp => 'Mobilā aplikācija';

  @override
  String get webmasters => 'Tīmekļa pārziņi';

  @override
  String get about => 'Par';

  @override
  String aboutX(String param) {
    return 'Par $param';
  }

  @override
  String xIsAFreeYLibreOpenSourceChessServer(String param1, String param2) {
    return '$param1 ir bezmaksas ($param2), bez reklāmu, brīva un atvērta koda šaha serveris.';
  }

  @override
  String get really => 'patiešām';

  @override
  String get contribute => 'Dot ieguldījumu';

  @override
  String get termsOfService => 'Pakalpojuma noteikumi';

  @override
  String get sourceCode => 'Pirmkods';

  @override
  String get simultaneousExhibitions => 'Simultānseansi';

  @override
  String get host => 'Vadītājs';

  @override
  String hostColorX(String param) {
    return 'Vadītāja krāsa: $param';
  }

  @override
  String get yourPendingSimuls => 'Your pending simuls';

  @override
  String get createdSimuls => 'Jaunie simultānseansi';

  @override
  String get hostANewSimul => 'Vadīt jaunu simultānseansu';

  @override
  String get signUpToHostOrJoinASimul => 'Sign up to host or join a simul';

  @override
  String get noSimulFound => 'Simultānseanss nav atrasts';

  @override
  String get noSimulExplanation => 'Šāds simultānseanss neeksistē.';

  @override
  String get returnToSimulHomepage => 'Atgriesties uz simultānseansu sākumlapu';

  @override
  String get aboutSimul => 'Simultānseansos viens spēlētājs spēlē ar vairākiem citiem vienlaicīgi.';

  @override
  String get aboutSimulImage => 'Fišers 50 spēlēs uzvarēja 47, zaudēja 1 un 2 beidzās neizšķirti.';

  @override
  String get aboutSimulRealLife => 'Princips ir aizgūts no reāliem pasākumiem. Reālajā dzīvē simultānseansa vadītājs staigā no galdiņa pie galdiņa un veic pa vienam gājienam.';

  @override
  String get aboutSimulRules => 'Simultānseansam sākoties, katrs spēlētājs sāk spēli ar vadītāju, kurš spēlē ar baltajām figūrām. Seanss beidzas, kad visas spēles ir beigušās.';

  @override
  String get aboutSimulSettings => 'Simultānseansi nekad nav vērtēti. Revanšu, gājienu atsaukšanas un laika pievienošanas iespējas ir atspējotas.';

  @override
  String get create => 'Izveidot';

  @override
  String get whenCreateSimul => 'Izveidojot simultānseansu, spēlēsiet ar vairākiem pretiniekiem vienlaicīgi.';

  @override
  String get simulVariantsHint => 'Ja atlasīsiet vairākus variantus, katrs spēlētājs varēs izvēlēties kuru spēlēt.';

  @override
  String get simulClockHint => 'Fišera pulksteņa uzstādīšana. Jo vairāk pretinieku, jo vairāk laika jums varētu vajadzēt.';

  @override
  String get simulAddExtraTime => 'Varat pievienot papildus laiku savam pulkstenim, lai vieglāk tiktu galā ar simultānseansu.';

  @override
  String get simulHostExtraTime => 'Papildu laiks vadītājam';

  @override
  String get simulAddExtraTimePerPlayer => 'Pievienot papildu laiku jūsu pulkstenim par katru spēlētāju, kas pievienojas simultānseansam.';

  @override
  String get simulHostExtraTimePerPlayer => 'Papildus laiks vadītājam par katru spēlētāju';

  @override
  String get lichessTournaments => 'Lichess turnīri';

  @override
  String get tournamentFAQ => 'Arena turnīru BUJ';

  @override
  String get timeBeforeTournamentStarts => 'Laiks līdz turnīra sākumam';

  @override
  String get averageCentipawnLoss => 'Vidējais centibandinieka zudums';

  @override
  String get accuracy => 'Precizitāte';

  @override
  String get keyboardShortcuts => 'Tastatūras saīsnes';

  @override
  String get keyMoveBackwardOrForward => 'pārvietoties uz priekšu/atpakaļ';

  @override
  String get keyGoToStartOrEnd => 'iet uz sākumu/beigām';

  @override
  String get keyCycleSelectedVariation => 'Cycle selected variation';

  @override
  String get keyShowOrHideComments => 'slēpt/rādīt komentārus';

  @override
  String get keyEnterOrExitVariation => 'ieiet/iziet variācijā';

  @override
  String get keyRequestComputerAnalysis => 'Pieprasi datora analīzi, Mācies no savām kļūdām';

  @override
  String get keyNextLearnFromYourMistakes => 'Nākamais (Mācies no savām kļūdām)';

  @override
  String get keyNextBlunder => 'Nākamā rupjā kļūda';

  @override
  String get keyNextMistake => 'Nākamā kļūda';

  @override
  String get keyNextInaccuracy => 'Nākamā neprecizitāte';

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
  String get newTournament => 'Jauns turnīrs';

  @override
  String get tournamentHomeTitle => 'Šaha turnīri ar dažādām laika kontrolēm un variantiem';

  @override
  String get tournamentHomeDescription => 'Piedalieties ātra tempa šaha turnīros! Pievienojieties oficiāli organizētā turnīrā, vai izveidojiet savu turnīru. Pieejamas Bullet, Blitz, Classical, Chess960, King of the Hill, Threecheck un citas iespējas nebeidzamiem šaha priekiem.';

  @override
  String get tournamentNotFound => 'Turnīrs nav atrasts';

  @override
  String get tournamentDoesNotExist => 'Šāds turnīrs neeksistē.';

  @override
  String get tournamentMayHaveBeenCanceled => 'Iespējams, tas tika atcelts, ja visi spēlētāji pameta turnīru pirms tā sākuma.';

  @override
  String get returnToTournamentsHomepage => 'Atgriezties turnīru lapā';

  @override
  String weeklyPerfTypeRatingDistribution(String param) {
    return 'Mēneša $param reitingu sadalījums';
  }

  @override
  String yourPerfTypeRatingIsRating(String param1, String param2) {
    return 'Jūsu $param1 reitings ir $param2.';
  }

  @override
  String youAreBetterThanPercentOfPerfTypePlayers(String param1, String param2) {
    return 'Esat labāks par $param1 no $param2 spēlētājiem.';
  }

  @override
  String userIsBetterThanPercentOfPerfTypePlayers(String param1, String param2, String param3) {
    return '$param1 ir labāks par $param2 $param3 spēlētāju.';
  }

  @override
  String betterThanPercentPlayers(String param1, String param2) {
    return 'Better than $param1 of $param2 players';
  }

  @override
  String youDoNotHaveAnEstablishedPerfTypeRating(String param) {
    return 'Jums vēl nav stabila $param reitinga.';
  }

  @override
  String get yourRating => 'Jūsu reitings';

  @override
  String get cumulative => 'Kumulatīvais';

  @override
  String get glicko2Rating => '\"Glicko-2\" reitings';

  @override
  String get checkYourEmail => 'Pārbaudiet e-pastu';

  @override
  String get weHaveSentYouAnEmailClickTheLink => 'Esam jums aizsūtījuši e-pastu. Klikšķiniet uz saņemtās saites, lai aktivizētu savu kontu.';

  @override
  String get ifYouDoNotSeeTheEmailCheckOtherPlaces => 'Ja nevarat atrast e-pastu, pārbaudiet citas vietas, kur tas varētu būt, piemēram, mēstulēs, atkritnē, sociālo tīklu sadaļā vai citās mapēs.';

  @override
  String weHaveSentYouAnEmailTo(String param) {
    return 'Esam aizsūtījuši e-pastu uz $param. Klikšķiniet uz saites e-pastā, lai atjaunotu savu paroli.';
  }

  @override
  String byRegisteringYouAgreeToBeBoundByOur(String param) {
    return 'Reģistrējoties, jums jāpiekrīt saistībām atbilstoši mūsu $param.';
  }

  @override
  String readAboutOur(String param) {
    return 'Lasiet par mūsu $param.';
  }

  @override
  String get networkLagBetweenYouAndLichess => 'Tīkla aizture starp jums un Lichess';

  @override
  String get timeToProcessAMoveOnLichessServer => 'Gājiena apstrādei nepieciešamais laiks Lichess serverī';

  @override
  String get downloadAnnotated => 'Lejupielādēt anotētu';

  @override
  String get downloadRaw => 'Lejupielādēt neapstrādātu';

  @override
  String get downloadImported => 'Lejupielādēt importēto';

  @override
  String get crosstable => 'Šķērstabula';

  @override
  String get youCanAlsoScrollOverTheBoardToMoveInTheGame => 'Varat arī ritināt virs galdiņa, lai pārvietotos spēlē.';

  @override
  String get scrollOverComputerVariationsToPreviewThem => 'Virziet kursoru uz datoranalīzes variācijām, lai tās skatītu.';

  @override
  String get analysisShapesHowTo => 'Klikšķiniet, turot pārslēgšanas taustiņu, vai klikšķiniet ar labo taustiņu uz galdiņa, lai zīmētu riņķus un bultas.';

  @override
  String get letOtherPlayersMessageYou => 'Ļaut citiem spēlētājiem jums sūtīt ziņas';

  @override
  String get receiveForumNotifications => 'Saņemt paziņojumus, kad esmu minēts forumā';

  @override
  String get shareYourInsightsData => 'Dalīties ar saviem šaha ieskatu datiem';

  @override
  String get withNobody => 'Ar nevienu';

  @override
  String get withFriends => 'Ar draugiem';

  @override
  String get withEverybody => 'Ar visiem';

  @override
  String get kidMode => 'Bērnu režīms';

  @override
  String get kidModeIsEnabled => 'Kid mode is enabled.';

  @override
  String get kidModeExplanation => 'Runa ir par drošību. Bērnu režīmā jebkāda saziņa ir atspējota. Ieslēdziet šo režīmu, lai pasargātu savus bērnus un skolēnus no citiem interneta lietotājiem.';

  @override
  String inKidModeTheLichessLogoGetsIconX(String param) {
    return 'Bērnu režīmā Lichess logo tiek pievienota $param ikona, lai jūs zinātu, ka jūsu bērni ir drošībā.';
  }

  @override
  String get askYourChessTeacherAboutLiftingKidMode => 'Jūsu konts tiek pārvaldīts. Prasiet savam šaha skolotājam, ja vēlaties noņemt bērnu režīmu.';

  @override
  String get enableKidMode => 'Iespējot Bērnu režīmu';

  @override
  String get disableKidMode => 'Atspējot Bērnu režīmu';

  @override
  String get security => 'Drošība';

  @override
  String get sessions => 'Sesijas';

  @override
  String get revokeAllSessions => 'dzēst visas sesijas';

  @override
  String get playChessEverywhere => 'Spēlējiet šahu jebkur';

  @override
  String get asFreeAsLichess => 'Bezmaksas kā Lichess';

  @override
  String get builtForTheLoveOfChessNotMoney => 'Radīts šaha mīlestības - ne naudas dēļ';

  @override
  String get everybodyGetsAllFeaturesForFree => 'Visas iespējas ir pieejamas jebkuram bez maksas';

  @override
  String get zeroAdvertisement => 'Nekādu reklāmu';

  @override
  String get fullFeatured => 'Pilnas iespējas';

  @override
  String get phoneAndTablet => 'Telefonam un planšetei';

  @override
  String get bulletBlitzClassical => 'Bullet, blics, klasiskais';

  @override
  String get correspondenceChess => 'Korespondencšahs';

  @override
  String get onlineAndOfflinePlay => 'Spēles tiešsaistē un bezsaistē';

  @override
  String get viewTheSolution => 'Skatīt atrisinājumu';

  @override
  String get followAndChallengeFriends => 'Sekojiet draugiem un izaiciniet tos';

  @override
  String get gameAnalysis => 'Spēles analīze';

  @override
  String xHostsY(String param1, String param2) {
    return '$param1 vada $param2';
  }

  @override
  String xJoinsY(String param1, String param2) {
    return '$param1 pievienojas $param2';
  }

  @override
  String xLikesY(String param1, String param2) {
    return '$param1 patīk $param2';
  }

  @override
  String get quickPairing => 'Ātrais pāris';

  @override
  String get lobby => 'Vestibils';

  @override
  String get anonymous => 'Anonīms';

  @override
  String yourScore(String param) {
    return 'Jūsu rezultāts: $param';
  }

  @override
  String get language => 'Valoda';

  @override
  String get background => 'Fons';

  @override
  String get light => 'Gaišs';

  @override
  String get dark => 'Tumšs';

  @override
  String get transparent => 'Caurspīdīgs';

  @override
  String get deviceTheme => 'Saskaņot ar sistēmu';

  @override
  String get backgroundImageUrl => 'Fona attēla URL:';

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
  String get pieceSet => 'Figūru komplekts';

  @override
  String get embedInYourWebsite => 'Iegult savā mājaslapā';

  @override
  String get usernameAlreadyUsed => 'Lietotājvārds ir aizņemts, lūdzu mēģiniet citu.';

  @override
  String get usernamePrefixInvalid => 'Lietotājvārdam jāsākas ar burtu.';

  @override
  String get usernameSuffixInvalid => 'Lietotājvārdam jābeidzas ar burtu vai ciparu.';

  @override
  String get usernameCharsInvalid => 'Lietotājvārds drīkst saturēt tikai burtus, ciparus, pasvītras un defises.';

  @override
  String get usernameUnacceptable => 'Šāds lietotājvārds nav pieņemams.';

  @override
  String get playChessInStyle => 'Spēlējiet šahu ar eleganci';

  @override
  String get chessBasics => 'Šaha pamati';

  @override
  String get coaches => 'Treneri';

  @override
  String get invalidPgn => 'Nepareizs PGN';

  @override
  String get invalidFen => 'Nepareizs FEN';

  @override
  String get custom => 'Pielāgota';

  @override
  String get notifications => 'Paziņojumi';

  @override
  String notificationsX(String param1) {
    return 'Paziņojumi: $param1';
  }

  @override
  String perfRatingX(String param) {
    return 'Reitings: $param';
  }

  @override
  String get practiceWithComputer => 'Treniņš ar datoru';

  @override
  String anotherWasX(String param) {
    return 'Varēja arī $param';
  }

  @override
  String bestWasX(String param) {
    return 'Labākais bija $param';
  }

  @override
  String get youBrowsedAway => 'Aizvirzījāties prom';

  @override
  String get resumePractice => 'Atsākt treniņu';

  @override
  String get drawByFiftyMoves => 'Spēle ir neizšķirta 50 gājienu noteikuma dēļ.';

  @override
  String get theGameIsADraw => 'Spēle ir neizšķirta.';

  @override
  String get computerThinking => 'Dators domā ...';

  @override
  String get seeBestMove => 'Rādīt labāko gājienu';

  @override
  String get hideBestMove => 'Nerādīt labāko gājienu';

  @override
  String get getAHint => 'Saņemt padomu';

  @override
  String get evaluatingYourMove => 'Novērtē jūsu gājienu...';

  @override
  String get whiteWinsGame => 'Baltie uzvar';

  @override
  String get blackWinsGame => 'Melnie uzvar';

  @override
  String get learnFromYourMistakes => 'Mācīties no savām kļūdām';

  @override
  String get learnFromThisMistake => 'Mācīties no šīs kļūdas';

  @override
  String get skipThisMove => 'Izlaist šo gājienu';

  @override
  String get next => 'Nākamais';

  @override
  String xWasPlayed(String param) {
    return '$param tika izspēlēts';
  }

  @override
  String get findBetterMoveForWhite => 'Atrodiet labāku gājienu baltajiem';

  @override
  String get findBetterMoveForBlack => 'Atrodiet labāku gājienu melnajiem';

  @override
  String get resumeLearning => 'Atsākt mācības';

  @override
  String get youCanDoBetter => 'Varat atrast labāku gājienu';

  @override
  String get tryAnotherMoveForWhite => 'Izmēģiniet citu gājienu ar baltajām';

  @override
  String get tryAnotherMoveForBlack => 'Izmēģiniet citu gājienu ar melnajām';

  @override
  String get solution => 'Risinājums';

  @override
  String get waitingForAnalysis => 'Gaida analīzi';

  @override
  String get noMistakesFoundForWhite => 'Baltajiem kļūdas netika atrastas';

  @override
  String get noMistakesFoundForBlack => 'Melnajiem kļūdas netika atrastas';

  @override
  String get doneReviewingWhiteMistakes => 'Balto kļūdu pārskatīšana pabeigta';

  @override
  String get doneReviewingBlackMistakes => 'Melno kļūdu pārskatīšana pabeigta';

  @override
  String get doItAgain => 'Atkārtot';

  @override
  String get reviewWhiteMistakes => 'Pārskatīt balto kļūdas';

  @override
  String get reviewBlackMistakes => 'Pārskatīt melno kļūdas';

  @override
  String get advantage => 'Pārsvars';

  @override
  String get opening => 'Atklātne';

  @override
  String get middlegame => 'Vidusspēle';

  @override
  String get endgame => 'Galotne';

  @override
  String get conditionalPremoves => 'Nosacījumu priekšgājieni';

  @override
  String get addCurrentVariation => 'Pievienot pašreizējo variantu';

  @override
  String get playVariationToCreateConditionalPremoves => 'Izspēlējiet variantu, lai izveidotu nosacījumu priekšgājienus';

  @override
  String get noConditionalPremoves => 'Nav nosacījumu priekšgājienu';

  @override
  String playX(String param) {
    return 'Spēlēt $param';
  }

  @override
  String get showUnreadLichessMessage => 'You have received a private message from Lichess.';

  @override
  String get clickHereToReadIt => 'Click here to read it';

  @override
  String get sorry => 'Lūdzu piedodiet :(';

  @override
  String get weHadToTimeYouOutForAWhile => 'Mums nācās jūs apturēt uz laiku.';

  @override
  String get why => 'Kāpēc?';

  @override
  String get pleasantChessExperience => 'Mēs cenšamies visiem piedāvāt patīkamu šaha pieredzi.';

  @override
  String get goodPractice => 'Līdz ar to, mums jānodrošina, lai visi spēlētāji pieturas pie labas prakses.';

  @override
  String get potentialProblem => 'Kad atklāta iespējama problēma, mēs rādām šo ziņojumu.';

  @override
  String get howToAvoidThis => 'Kā no šī izvairīties?';

  @override
  String get playEveryGame => 'Izspēlējiet katru spēli, ko iesākat.';

  @override
  String get tryToWin => 'Mēģiniet uzvarēt (vai vismaz panākt neizšķirtu) katrā spēlē, ko spēlējat.';

  @override
  String get resignLostGames => 'Padodieties zaudētajās spēlēs (neļaujiet laikam beigties).';

  @override
  String get temporaryInconvenience => 'Mēs atvainojamies par īslaicīgajām neērtībām,';

  @override
  String get wishYouGreatGames => 'un novēlam jums lieliskas spēles mājaslapā lichess.org.';

  @override
  String get thankYouForReading => 'Paldies, ka izlasījāt!';

  @override
  String get lifetimeScore => 'Visu laiku rezultāts';

  @override
  String get currentMatchScore => 'Pašreizējais spēļu reitings';

  @override
  String get agreementAssistance => 'Piekrītu spēlējot nevienā brīdī nesaņemt palīdzību (no šaha programmas, grāmatas, datubāzes vai cita cilvēka).';

  @override
  String get agreementNice => 'Piekrītu vienmēr izturēties pieklājīgi pret citiem spēlētājiem.';

  @override
  String agreementMultipleAccounts(String param) {
    return 'Piekrītu neizveidot vairākus kontus (izņemot gadījumos, kad to attaisno $param).';
  }

  @override
  String get agreementPolicy => 'Piekrītu ievērot visus Lichess noteikumus.';

  @override
  String get searchOrStartNewDiscussion => 'Meklēt vai uzsākt sarunu';

  @override
  String get edit => 'Rediģēt';

  @override
  String get bullet => 'Bullet';

  @override
  String get blitz => 'Blitz';

  @override
  String get rapid => 'Ātrais';

  @override
  String get classical => 'Klasiskais';

  @override
  String get ultraBulletDesc => 'Neprātīgi ātras spēles—mazāk kā 30 sekundes';

  @override
  String get bulletDesc => 'Ļoti ātras spēles — mazāk kā 3 minūtes';

  @override
  String get blitzDesc => 'Ātras spēles — 3 līdz 8 minūtes';

  @override
  String get rapidDesc => 'Ātras spēles — 8 līdz 25 minūtes';

  @override
  String get classicalDesc => 'Klasiskas spēles — ne mazāk par 25 minūtēm';

  @override
  String get correspondenceDesc => 'Korespondencšaha spēles — viena vai vairākas dienas katram gājienam';

  @override
  String get puzzleDesc => 'Šaha taktikas treneris';

  @override
  String get important => 'Svarīgi';

  @override
  String yourQuestionMayHaveBeenAnswered(String param1) {
    return 'Jūsu jautājums, iespējams, jau ir atbildēts $param1';
  }

  @override
  String get inTheFAQ => 'bieži uzdoto jautājumu sadaļā';

  @override
  String toReportSomeoneForCheatingOrBadBehavior(String param1) {
    return 'Lai ziņotu par negodīgu vai sliktu uzvešanos, $param1';
  }

  @override
  String get useTheReportForm => 'izmantojiet ziņošanas veidni';

  @override
  String toRequestSupport(String param1) {
    return 'Lai lūgtu atbalstu, $param1';
  }

  @override
  String get tryTheContactPage => 'izmēģiniet kontaktu sadaļu';

  @override
  String makeSureToRead(String param1) {
    return 'Pārliecinies, ka izlasīji $param1';
  }

  @override
  String get theForumEtiquette => 'foruma etiķeti';

  @override
  String get thisTopicIsArchived => 'Šis temats ir arhivēts un šeit vairs nevar atbildēt.';

  @override
  String joinTheTeamXToPost(String param1) {
    return 'Pievienojieties $param1, lai rakstītu šajā forumā';
  }

  @override
  String teamNamedX(String param1) {
    return 'komanda \"$param1\"';
  }

  @override
  String get youCannotPostYetPlaySomeGames => 'Vēl nevarat rakstīt forumos. Uzspēlējiet dažas spēles!';

  @override
  String get subscribe => 'Abonēt';

  @override
  String get unsubscribe => 'Atcelt abonēšanu';

  @override
  String mentionedYouInX(String param1) {
    return 'jūs minēja ziņojumā \"$param1\".';
  }

  @override
  String xMentionedYouInY(String param1, String param2) {
    return '$param1 jūs minēja ziņojumā \"$param2\".';
  }

  @override
  String invitedYouToX(String param1) {
    return 'jūs uzaicināja uz \"$param1\".';
  }

  @override
  String xInvitedYouToY(String param1, String param2) {
    return '$param1 jūs uzaicināja uz \"$param2\".';
  }

  @override
  String get youAreNowPartOfTeam => 'Tagad esat komandas dalībnieks.';

  @override
  String youHaveJoinedTeamX(String param1) {
    return 'Pievienojāties \"$param1\".';
  }

  @override
  String get someoneYouReportedWasBanned => 'Lietotājam, ko nosūdzējāt, tika slēgts konts';

  @override
  String get congratsYouWon => 'Apsveicam ar uzvaru!';

  @override
  String gameVsX(String param1) {
    return 'Spēle pret $param1';
  }

  @override
  String resVsX(String param1, String param2) {
    return '$param1 pret $param2';
  }

  @override
  String get lostAgainstTOSViolator => 'Zaudējāt pretiniekam, kas pārkāpa Lichess noteikumus';

  @override
  String refundXpointsTimeControlY(String param1, String param2) {
    return 'Atlīdzība: $param1 $param2 reitinga punkti.';
  }

  @override
  String get timeAlmostUp => 'Laiks gandrīz beidzies!';

  @override
  String get clickToRevealEmailAddress => '[Noklikšķiniet, lai atklātu e-pasta adresi]';

  @override
  String get download => 'Lejupielādēt';

  @override
  String get coachManager => 'Trenera iestatījumi';

  @override
  String get streamerManager => 'Straumētāja iestatījumi';

  @override
  String get cancelTournament => 'Atcelt turnīru';

  @override
  String get tournDescription => 'Turnīra apraksts';

  @override
  String get tournDescriptionHelp => 'Vai vēlaties dalībniekiem teikt ko īpašu? Centieties izteikties īsi! Iespējams ievietot Markdown saites: [nosaukums](https://url)';

  @override
  String get ratedFormHelp => 'Spēles ir vērtētas un ietekmē spēlētāju reitingu';

  @override
  String get onlyMembersOfTeam => 'Tikai komandas dalībnieki';

  @override
  String get noRestriction => 'Bez ierobežojumiem';

  @override
  String get minimumRatedGames => 'Minimālais vērtēto spēļu skaits';

  @override
  String get minimumRating => 'Minimālais reitings';

  @override
  String get maximumWeeklyRating => 'Maksimālais nedēļas reitings';

  @override
  String positionInputHelp(String param) {
    return 'Ielīmējiet derīgu FEN, lai sāktu katru spēli no dotās pozīcijas.\nŠis darbojas tikai ar standarta spēlēm nevis variantiem.\nVarat izmantot rīku \"$param\", lai izveidotu FEN pozīciju, tad ielīmējiet to šeit.\nAtstājiet tukšu, lai spēles sāktos no parastās pozīcijas.';
  }

  @override
  String get cancelSimul => 'Atcelt simultānseansu';

  @override
  String get simulHostcolor => 'Uzņemošā spēlētāja krāsa katrā spēlē';

  @override
  String get estimatedStart => 'Paredzētais sākuma laiks';

  @override
  String simulFeatured(String param) {
    return 'Rādīt $param';
  }

  @override
  String simulFeaturedHelp(String param) {
    return 'Visiem rādīt simultānseansu $param. Atspējojiet šo opciju privātiem simultānseansiem.';
  }

  @override
  String get simulDescription => 'Simultānseansa apraksts';

  @override
  String get simulDescriptionHelp => 'Vai vēlaties ko teikt dalībniekiem?';

  @override
  String markdownAvailable(String param) {
    return 'Papildu formatējumam pieejams $param.';
  }

  @override
  String get embedsAvailable => 'Ievietojiet spēles vai izpētes nodaļas URL lai to iegultu.';

  @override
  String get inYourLocalTimezone => 'Jūsu vietējā laika zonā';

  @override
  String get tournChat => 'Turnīra saruna';

  @override
  String get noChat => 'Nav sarunas';

  @override
  String get onlyTeamLeaders => 'Tikai komandas vadītāji';

  @override
  String get onlyTeamMembers => 'Tikai komandas dalībnieki';

  @override
  String get navigateMoveTree => 'Izskatīt gājienu koku';

  @override
  String get mouseTricks => 'Peles kontroles';

  @override
  String get toggleLocalAnalysis => 'Ieslēgt/izslēgt ierīces datoranalīzi';

  @override
  String get toggleAllAnalysis => 'Ieslēgt/izslēgt visu datoranalīzi';

  @override
  String get playComputerMove => 'Izspēlēt labāko datora gājienu';

  @override
  String get analysisOptions => 'Analīzes iespējas';

  @override
  String get focusChat => 'Fokusēt sarunu';

  @override
  String get showHelpDialog => 'Rādīt šo palīdzības dialoglodziņu';

  @override
  String get reopenYourAccount => 'Atgūt savu kontu';

  @override
  String get closedAccountChangedMind => 'Ja esat slēdzis kontu, bet pārdomājāt, jums ir viena iespēja atgūt kontu.';

  @override
  String get onlyWorksOnce => 'Tā darbosies tikai vienu reizi.';

  @override
  String get cantDoThisTwice => 'Ja slēgsiet kontu otrreiz, nebūs iespēju to atgūt.';

  @override
  String get emailAssociatedToaccount => 'Ar kontu saistītais epasts';

  @override
  String get sentEmailWithLink => 'Esam jums nosūtījuši epastu ar saiti.';

  @override
  String get tournamentEntryCode => 'Turnīra pievienošanās kods';

  @override
  String get hangOn => 'Uzmanību!';

  @override
  String gameInProgress(String param) {
    return 'Jums ir nepageigta spēle ar $param.';
  }

  @override
  String get abortTheGame => 'Atcelt spēli';

  @override
  String get resignTheGame => 'Padoties';

  @override
  String get youCantStartNewGame => 'Kamēr neesat pabeidzis šo spēli, nevarat sākt jaunu partiju.';

  @override
  String get since => 'Kopš';

  @override
  String get until => 'Līdz';

  @override
  String get lichessDbExplanation => 'Vērtērtu spēļu paraugi no visiem Lichess spēlētājiem';

  @override
  String get switchSides => 'Mainīties ar pusēm';

  @override
  String get closingAccountWithdrawAppeal => 'Konta slēgšana atsauks jūsu iesniegumu';

  @override
  String get ourEventTips => 'Pasākumu organizēšanas ieteikumi';

  @override
  String get instructions => 'Instructions';

  @override
  String get showMeEverything => 'Show me everything';

  @override
  String get lichessPatronInfo => 'Lichess ir labdarības organizācija un pilnībā bezmaksas/brīva atvērtā koda programmatūra.\nVisas izmaksas, izstrādāšanu un saturu finansē vienīgi lietotāju ziedojumi.';

  @override
  String get nothingToSeeHere => 'Nothing to see here at the moment.';

  @override
  String opponentLeftCounter(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Jūsu pretinieks pametis spēli. Varēsiet pieprasīt uzvaru pēc $count sekundēm.',
      one: 'Jūsu pretinieks pametis spēli. Varēsiet pieprasīt uzvaru pēc $count sekundes.',
      zero: 'Jūsu pretinieks pametis spēli. Varēsiet pieprasīt uzvaru pēc $count sekundēm.',
    );
    return '$_temp0';
  }

  @override
  String mateInXHalfMoves(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Mats $count pusgājienos',
      one: 'Mats $count pusgājienā',
      zero: 'Mats $count pusgājienos',
    );
    return '$_temp0';
  }

  @override
  String nbBlunders(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count rupjas kļūdas',
      one: '$count rupja kļūda',
      zero: '$count rupju kļūdu',
    );
    return '$_temp0';
  }

  @override
  String nbMistakes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count kļūdas',
      one: '$count kļūda',
      zero: '$count kļūdu',
    );
    return '$_temp0';
  }

  @override
  String nbInaccuracies(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count neprecizitātes',
      one: '$count neprecizitāte',
      zero: '$count neprecizitāšu',
    );
    return '$_temp0';
  }

  @override
  String nbPlayers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count spēlētāji',
      one: '$count spēlētājs',
      zero: '$count spēlētāji',
    );
    return '$_temp0';
  }

  @override
  String nbGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count spēles',
      one: '$count spēles',
      zero: '$count spēles',
    );
    return '$_temp0';
  }

  @override
  String ratingXOverYGames(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count reitings, ņemot vērā $param2 spēles',
      one: '$count reitings, ņemot vērā $param2 spēli',
      zero: '$count reitings, ņemot vērā $param2 spēles',
    );
    return '$_temp0';
  }

  @override
  String nbBookmarks(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count grāmatzīmes',
      one: '$count grāmatzīme',
      zero: '$count grāmatzīmes',
    );
    return '$_temp0';
  }

  @override
  String nbDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count dienas',
      one: '$count diena',
      zero: '$count dienas',
    );
    return '$_temp0';
  }

  @override
  String nbHours(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count stundas',
      one: '$count stunda',
      zero: '$count stundas',
    );
    return '$_temp0';
  }

  @override
  String nbMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count minūtes',
      one: '$count minūte',
      zero: '$count minūšu',
    );
    return '$_temp0';
  }

  @override
  String rankIsUpdatedEveryNbMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Rangs tiek atjaunots ik pēc $count minūtēm',
      one: 'Rangs tiek atjaunots katru minūti',
      zero: 'Rangs tiek atjaunots ik pēc $count minūtēm',
    );
    return '$_temp0';
  }

  @override
  String nbPuzzles(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count uzdevumi',
      one: '$count uzdevums',
      zero: '$count uzdevumi',
    );
    return '$_temp0';
  }

  @override
  String nbGamesWithYou(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count savstarpējas spēles',
      one: '$count savstarpēja spēle',
      zero: '$count savstarpējās spēles',
    );
    return '$_temp0';
  }

  @override
  String nbRated(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count vērtētas',
      one: '$count vērtēta',
      zero: '$count vērtētas',
    );
    return '$_temp0';
  }

  @override
  String nbWins(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count uzvaras',
      one: '$count uzvara',
      zero: '$count uzvaras',
    );
    return '$_temp0';
  }

  @override
  String nbLosses(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count zaudējumi',
      one: '$count zaudējums',
      zero: '$count zaudējumi',
    );
    return '$_temp0';
  }

  @override
  String nbDraws(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count neizšķirti',
      one: '$count neizšķirts',
      zero: '$count neizšķirti',
    );
    return '$_temp0';
  }

  @override
  String nbPlaying(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count notiek',
      one: '$count notiek',
      zero: '$count notiek',
    );
    return '$_temp0';
  }

  @override
  String giveNbSeconds(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Piešķirt $count sekundes',
      one: 'Piešķirt $count sekundi',
      zero: 'Piešķirt $count sekundes',
    );
    return '$_temp0';
  }

  @override
  String nbTournamentPoints(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count turnīra punkti',
      one: '$count turnīra punkts',
      zero: '$count turnīra punkti',
    );
    return '$_temp0';
  }

  @override
  String nbStudies(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count izpētes',
      one: '$count izpēte',
      zero: '$count izpētes',
    );
    return '$_temp0';
  }

  @override
  String nbSimuls(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count simultānspēles',
      one: '$count simultānspēle',
      zero: '$count simultānspēles',
    );
    return '$_temp0';
  }

  @override
  String moreThanNbRatedGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '≥ $count vērtētas spēles',
      one: '≥ $count vērtēta spēle',
      zero: '≥ $count vērtētas spēles',
    );
    return '$_temp0';
  }

  @override
  String moreThanNbPerfRatedGames(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '≥ $count vērtētas \"$param2\" spēles',
      one: '≥ $count vērtēta \"$param2\" spēle',
      zero: '≥ $count vērtētas \"$param2\" spēles',
    );
    return '$_temp0';
  }

  @override
  String needNbMorePerfGames(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Jums jāizspēlē vēl $count vērtētas \"$param2\" spēles',
      one: 'Jums jāizspēlē vēl $count vērtēta \"$param2\" spēle',
      zero: 'Jums jāizspēlē vēl $count vērtētas \"$param2\" spēles',
    );
    return '$_temp0';
  }

  @override
  String needNbMoreGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Jums jāizspēlē vēl $count vērtētas spēles',
      one: 'Jums jāizspēlē vēl $count vērtēta spēle',
      zero: 'Jums jāizspēlē vēl $count vērtētas spēles',
    );
    return '$_temp0';
  }

  @override
  String nbImportedGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count importētas spēles',
      one: '$count importēta spēles',
      zero: '$count importētas spēles',
    );
    return '$_temp0';
  }

  @override
  String nbFriendsOnline(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count draugi tiešsaistē',
      one: '$count draugs tiešsaistē',
      zero: '$count draugu tiešsaistē',
    );
    return '$_temp0';
  }

  @override
  String nbFollowers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count sekotāji',
      one: '$count sekotājs',
      zero: '$count sekotāji',
    );
    return '$_temp0';
  }

  @override
  String nbFollowing(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count sekotie',
      one: '$count sekotais',
      zero: '$count sekotie',
    );
    return '$_temp0';
  }

  @override
  String lessThanNbMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Mazāk kā $count minūtes',
      one: 'Mazāk kā $count minūte',
      zero: 'Mazāk kā $count minūtes',
    );
    return '$_temp0';
  }

  @override
  String nbGamesInPlay(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Pašlaik norisinās $count spēles',
      one: 'Pašlaik norisinās $count spēle',
      zero: 'Pašlaik norisinās $count spēles',
    );
    return '$_temp0';
  }

  @override
  String maximumNbCharacters(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Maksimums: $count simboli.',
      one: 'Maksimums: $count simbols.',
      zero: 'Maksimums: $count simboli.',
    );
    return '$_temp0';
  }

  @override
  String blocks(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count bloķētie',
      one: '$count bloķētais',
      zero: '$count bloķētie',
    );
    return '$_temp0';
  }

  @override
  String nbForumPosts(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count foruma ieraksti',
      one: '$count foruma ieraksts',
      zero: '$count foruma ieraksti',
    );
    return '$_temp0';
  }

  @override
  String nbPerfTypePlayersThisWeek(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count $param2 spēlētāji šonedēļ.',
      one: '$count $param2 spēlētājs šonedēļ.',
      zero: '$count $param2 spēlētāji šonedēļ.',
    );
    return '$_temp0';
  }

  @override
  String availableInNbLanguages(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Pieejama $count valodās!',
      one: 'Pieejama $count valodā!',
      zero: 'Pieejama $count valodās!',
    );
    return '$_temp0';
  }

  @override
  String nbSecondsToPlayTheFirstMove(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count sekundes, lai izdarītu pirmo gājienu',
      one: '$count sekunde, lai izdarītu pirmo gājienu',
      zero: '$count sekundes, lai izdarītu pirmo gājienu',
    );
    return '$_temp0';
  }

  @override
  String nbSeconds(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count sekundes',
      one: '$count sekunde',
      zero: '$count sekundes',
    );
    return '$_temp0';
  }

  @override
  String andSaveNbPremoveLines(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'un saglabāt $count priekšgājienu variantus',
      one: 'un saglabāt $count priekšgājienu variantu',
      zero: 'un saglabāt $count priekšgājienu variantus',
    );
    return '$_temp0';
  }

  @override
  String get stormMoveToStart => 'Izdariet gājienu, lai sāktu';

  @override
  String get stormYouPlayTheWhitePiecesInAllPuzzles => 'Visos uzdevumos spēlējat ar baltajiem';

  @override
  String get stormYouPlayTheBlackPiecesInAllPuzzles => 'Visos uzdevumos spēlējat ar melnajiem';

  @override
  String get stormPuzzlesSolved => 'atrisināti uzdevumi';

  @override
  String get stormNewDailyHighscore => 'Jauns dienas labākais rezultāts!';

  @override
  String get stormNewWeeklyHighscore => 'Jauns nedēļas labākais rezultāts!';

  @override
  String get stormNewMonthlyHighscore => 'Jauns mēneša labākais rezultāts!';

  @override
  String get stormNewAllTimeHighscore => 'Jauns visu laiku labākais rezultāts!';

  @override
  String stormPreviousHighscoreWasX(String param) {
    return 'Iepriekšējais sasniegums bija $param';
  }

  @override
  String get stormPlayAgain => 'Spēlēt vēlreiz';

  @override
  String stormHighscoreX(String param) {
    return 'Labākais rezultāts: $param';
  }

  @override
  String get stormScore => 'Rezultāts';

  @override
  String get stormMoves => 'Gājieni';

  @override
  String get stormAccuracy => 'Precizitāte';

  @override
  String get stormCombo => 'Kombinācija';

  @override
  String get stormTime => 'Laiks';

  @override
  String get stormTimePerMove => 'Laiks uz gājienu';

  @override
  String get stormHighestSolved => 'Labākais atrisinātais';

  @override
  String get stormPuzzlesPlayed => 'Izspēlētie uzdevumi';

  @override
  String get stormNewRun => 'Spēlēt vēl (taustiņš: atstarpe)';

  @override
  String get stormEndRun => 'Beigt spēli (ievadīšanas taustiņš)';

  @override
  String get stormHighscores => 'Labākie rezultāti';

  @override
  String get stormViewBestRuns => 'Skatīt labākos mēģinājumus';

  @override
  String get stormBestRunOfDay => 'Dienas labākais mēģinājums';

  @override
  String get stormRuns => 'Mēģinājumi';

  @override
  String get stormGetReady => 'Sagatavojieties!';

  @override
  String get stormWaitingForMorePlayers => 'Gaida papildu spēlētāju pievienošanos...';

  @override
  String get stormRaceComplete => 'Sacīkstes beigušās!';

  @override
  String get stormSpectating => 'Skatās';

  @override
  String get stormJoinTheRace => 'Pievienoties sacīkstēm!';

  @override
  String get stormStartTheRace => 'Sākt sacīkstes';

  @override
  String stormYourRankX(String param) {
    return 'Jūsu vieta: $param';
  }

  @override
  String get stormWaitForRematch => 'Gaidiet nākamo spēli';

  @override
  String get stormNextRace => 'Nākamā spēle';

  @override
  String get stormJoinRematch => 'Pievienoties revanšam';

  @override
  String get stormWaitingToStart => 'Gaida sākumu';

  @override
  String get stormCreateNewGame => 'Izveidot jaunu spēli';

  @override
  String get stormJoinPublicRace => 'Pievienoties publiskām sacīkstēm';

  @override
  String get stormRaceYourFriends => 'Sacensties ar draugiem';

  @override
  String get stormSkip => 'izlaist';

  @override
  String get stormSkipHelp => 'Varat izlaist vienu gājienu katrās sacīkstēs:';

  @override
  String get stormSkipExplanation => 'Izlaist gājienu, lai paturētu kombināciju! Darbojas tikai vienreiz katrās sacensībās.';

  @override
  String get stormFailedPuzzles => 'Neizdevušies uzdevumi';

  @override
  String get stormSlowPuzzles => 'Lēni atrisinātie';

  @override
  String get stormSkippedPuzzle => 'Izlaista puzle';

  @override
  String get stormThisWeek => 'Šonedēļ';

  @override
  String get stormThisMonth => 'Šomēnes';

  @override
  String get stormAllTime => 'Visa laika';

  @override
  String get stormClickToReload => 'Klikšķiniet, lai pārlādētu';

  @override
  String get stormThisRunHasExpired => 'Šai pužļu spēlei beidzies termiņš!';

  @override
  String get stormThisRunWasOpenedInAnotherTab => 'Šī pužļu spēle tikusi atvērta citā cilnē!';

  @override
  String stormXRuns(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count izspēlēšanas',
      one: '$count izspēlēšana',
      zero: '$count izspēlēšanas',
    );
    return '$_temp0';
  }

  @override
  String stormPlayedNbRunsOfPuzzleStorm(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Izspēlēja $param2 $count reizes',
      one: 'Izspēlēja $param2 $count reizi',
      zero: 'Izspēlēja $param2 $count reizes',
    );
    return '$_temp0';
  }

  @override
  String get streamerLichessStreamers => 'Lichess straumētāji';

  @override
  String get studyShareAndExport => 'Koplietot & eksportēt';

  @override
  String get studyStart => 'Sākt';
}
