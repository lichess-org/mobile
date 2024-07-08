import 'package:intl/intl.dart' as intl;

import 'l10n.dart';

/// The translations for Azerbaijani (`az`).
class AppLocalizationsAz extends AppLocalizations {
  AppLocalizationsAz([String locale = 'az']) : super(locale);

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
  String get activityActivity => 'Aktivlik';

  @override
  String get activityHostedALiveStream => 'Canlı yayım etdi';

  @override
  String activityRankedInSwissTournament(String param1, String param2) {
    return '$param2 turnirində $param1-ci oldu';
  }

  @override
  String get activitySignedUp => 'lichess.org\'a üzv oldu';

  @override
  String activitySupportedNbMonths(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Lichess.org\'u $count aylığına $param2 olaraq dəstəklədi',
      one: 'Lichess.org\'u $count aylığına $param2 olaraq dəstəklədi',
    );
    return '$_temp0';
  }

  @override
  String activityPracticedNbPositions(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$param2 mövzusunda $count pozisiya məşq etdi',
      one: '$param2 mövzusunda $count pozisiya məşq etdi',
    );
    return '$_temp0';
  }

  @override
  String activitySolvedNbPuzzles(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count taktiki tapmaca həll etdi',
      one: '$count taktiki tapmaca həll etdi',
    );
    return '$_temp0';
  }

  @override
  String activityPlayedNbGames(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count dəfə $param2 oynadı',
      one: '$count dəfə $param2 oynadı',
    );
    return '$_temp0';
  }

  @override
  String activityPostedNbMessages(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$param2 mövzusunda $count mesaj paylaşdı',
      one: '$param2 mövzusunda $count mesaj paylaşdı',
    );
    return '$_temp0';
  }

  @override
  String activityPlayedNbMoves(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count gediş etdi',
      one: '$count gediş etdi',
    );
    return '$_temp0';
  }

  @override
  String activityInNbCorrespondenceGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count yazışmalı oyunda',
      one: '$count yazışmalı oyunda',
    );
    return '$_temp0';
  }

  @override
  String activityCompletedNbGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count yazışmalı oyun tamamladı',
      one: '$count yazışmalı oyun tamamladı',
    );
    return '$_temp0';
  }

  @override
  String activityFollowedNbPlayers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count oyunçunu izləməyə başladı',
      one: '$count oyunçunu izləməyə başladı',
    );
    return '$_temp0';
  }

  @override
  String activityGainedNbFollowers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count yeni izləyici qazandı',
      one: '$count yeni izləyici qazandı',
    );
    return '$_temp0';
  }

  @override
  String activityHostedNbSimuls(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count sinxron seansa ev sahibliyi etdi',
      one: '$count sinxron seansa ev sahibliyi etdi',
    );
    return '$_temp0';
  }

  @override
  String activityJoinedNbSimuls(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count sinxron seansda iştirak etdi',
      one: '$count sinxron seansda iştirak etdi',
    );
    return '$_temp0';
  }

  @override
  String activityCreatedNbStudies(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count yeni çalışma yaratdı',
      one: '$count yeni çalışma yaratdı',
    );
    return '$_temp0';
  }

  @override
  String activityCompetedInNbTournaments(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count taktiki tapmaca həll etdi',
      one: '$count turnirə qatıldı',
    );
    return '$_temp0';
  }

  @override
  String activityRankedInTournament(int count, String param2, String param3, String param4) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$param3 oyun oynayaraq $param4 turnirində $count. oldu (en yaxşı$param2% içində)',
      one: '$param3 oyun oynayaraq $param4 turnirində $count. oldu (en yaxşı$param2% içində)',
    );
    return '$_temp0';
  }

  @override
  String activityCompetedInNbSwissTournaments(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count İsveçrə sistemli turnirə qatıldı',
      one: '$count İsveçrə sistemli turnirə qatıldı',
    );
    return '$_temp0';
  }

  @override
  String activityJoinedNbTeams(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count komandasına qatıldı',
      one: '$count komandasına qatıldı',
    );
    return '$_temp0';
  }

  @override
  String get broadcastBroadcasts => 'Yayım';

  @override
  String get broadcastLiveBroadcasts => 'Canlı turnir yayımları';

  @override
  String challengeChallengesX(String param1) {
    return 'Challenges: $param1';
  }

  @override
  String get challengeChallengeToPlay => 'Oyuna çağırış';

  @override
  String get challengeChallengeDeclined => 'Çağırış rədd edildi.';

  @override
  String get challengeChallengeAccepted => 'Çağırış qəbul edildi!';

  @override
  String get challengeChallengeCanceled => 'Çağırışdan imtina edildi.';

  @override
  String get challengeRegisterToSendChallenges => 'Çağırış göndərmək üçün lütfən qeydiyyatdan keçin.';

  @override
  String challengeYouCannotChallengeX(String param) {
    return '$param istifadəçisinə çağırış edə bilməzsiz.';
  }

  @override
  String challengeXDoesNotAcceptChallenges(String param) {
    return '$param çağırışları qəbul etmir.';
  }

  @override
  String challengeYourXRatingIsTooFarFromY(String param1, String param2) {
    return 'Sizin $param1 reytinqiniz $param2-in reytinqindən çox uzaqdır.';
  }

  @override
  String challengeCannotChallengeDueToProvisionalXRating(String param) {
    return 'Müvəqqəti $param reytinqi səbəbilə çağırış edə bilməzsiz.';
  }

  @override
  String challengeXOnlyAcceptsChallengesFromFriends(String param) {
    return '$param yalnız dostlarından çağırış qəbul edir.';
  }

  @override
  String get challengeDeclineGeneric => 'Hal-hazırda çağırışları qəbul etmirəm.';

  @override
  String get challengeDeclineLater => 'Bu mənim üçün uyğun vaxt deyil, lütfən sonra yenidən soruşun.';

  @override
  String get challengeDeclineTooFast => 'Bu vaxt nəzarəti mənim üçün çox sürətlidir, lütfən daha yavaş bir oyunla yenidən çağırış edin.';

  @override
  String get challengeDeclineTooSlow => 'Bu vaxt nəzarəti mənim üçün çox yavaşdır lütfən daha sürətli bir oyunla yenidən çağırış edin.';

  @override
  String get challengeDeclineTimeControl => 'Bu vaxt nəzarətilə olan çağırışları qəbul etmirəm.';

  @override
  String get challengeDeclineRated => 'Zəhmət olmasa mənə reytinqli bir çağırış göndərin.';

  @override
  String get challengeDeclineCasual => 'Zəhmət olmasa mənə reytinqsiz bir çağırış göndərin.';

  @override
  String get challengeDeclineStandard => 'Hal-hazırda qeyri-ənənəvi şahmat variantları çağırışlarını qəbul etmirəm.';

  @override
  String get challengeDeclineVariant => 'Hazırda bu variantı oynamaq istəmirəm.';

  @override
  String get challengeDeclineNoBot => 'Botlardan gələn çağırışları qəbul etmirəm.';

  @override
  String get challengeDeclineOnlyBot => 'Yalnız botlardan gələn çağırışları qəbul edirəm.';

  @override
  String get challengeInviteLichessUser => 'Or invite a Lichess user:';

  @override
  String get contactContact => 'Əlaqə';

  @override
  String get contactContactLichess => 'Lichess ilə əlaqə';

  @override
  String get patronDonate => 'İanə verin';

  @override
  String get patronLichessPatron => 'Lichess Dəstəkçisi';

  @override
  String perfStatPerfStats(String param) {
    return '$param statistikası';
  }

  @override
  String get perfStatViewTheGames => 'Oyunlara bax';

  @override
  String get perfStatProvisional => 'müvəqqəti';

  @override
  String get perfStatNotEnoughRatedGames => 'Etibarlı reytinq yaratmaq üçün kifayət qədər reytinqli oyun oynanılmayıb.';

  @override
  String perfStatProgressOverLastXGames(String param) {
    return 'Son $param oyundakı irəliləyiş:';
  }

  @override
  String perfStatRatingDeviation(String param) {
    return 'Xal yayınma dəyəri: $param.';
  }

  @override
  String perfStatRatingDeviationTooltip(String param1, String param2, String param3) {
    return 'Aşağı dəyər reytinqin daha sabit olduğunu bildirir. $param1-dan yuxarı olan reytinq müvəqqəti hesab olunur. Reytinqlərə daxil olmaq üçün bu dəyər $param2-dan (standart şahmat) və ya $param3-dan (variantlardan) aşağı olmalıdır.';
  }

  @override
  String get perfStatTotalGames => 'Cəmi oyunlar';

  @override
  String get perfStatRatedGames => 'Reytinqli oyunlar';

  @override
  String get perfStatTournamentGames => 'Turnir oyunları';

  @override
  String get perfStatBerserkedGames => 'Berserk oyunları';

  @override
  String get perfStatTimeSpentPlaying => 'Cəmi oynama müddəti';

  @override
  String get perfStatAverageOpponent => 'Ortalama rəqib';

  @override
  String get perfStatVictories => 'Qələbələr';

  @override
  String get perfStatDefeats => 'Məğlubiyyətlər';

  @override
  String get perfStatDisconnections => 'Bağlantı kəsilmələri';

  @override
  String get perfStatNotEnoughGames => 'Yetərli sayda oyun oynanılmayıb';

  @override
  String perfStatHighestRating(String param) {
    return 'Ən yüksək reytinq: $param';
  }

  @override
  String perfStatLowestRating(String param) {
    return 'Ən aşağı reytinq: $param';
  }

  @override
  String perfStatFromXToY(String param1, String param2) {
    return '$param1 tarixindən $param2 tarixinə qədər';
  }

  @override
  String get perfStatWinningStreak => 'Qalibiyyət seriyası';

  @override
  String get perfStatLosingStreak => 'Məğlubiyyət seriyası';

  @override
  String perfStatLongestStreak(String param) {
    return 'Ən uzun seriya: $param';
  }

  @override
  String perfStatCurrentStreak(String param) {
    return 'Hazırkı seriya: $param';
  }

  @override
  String get perfStatBestRated => 'Ən yüksək reytinqli qələbələr';

  @override
  String get perfStatGamesInARow => 'Ardıcıl oynanılan oyunlar';

  @override
  String get perfStatLessThanOneHour => 'Oyunlar arasında bir saatdan az ara olmalıdır';

  @override
  String get perfStatMaxTimePlaying => 'Oyun üçün xərclənən ən uzun vaxt';

  @override
  String get perfStatNow => 'indi';

  @override
  String get preferencesPreferences => 'Tərcihlər';

  @override
  String get preferencesDisplay => 'Display';

  @override
  String get preferencesPrivacy => 'Privacy';

  @override
  String get preferencesNotifications => 'Notifications';

  @override
  String get preferencesPieceAnimation => 'Fiqur animasiyası';

  @override
  String get preferencesMaterialDifference => 'Material fərqi';

  @override
  String get preferencesBoardHighlights => 'Lövhə xəbərdarlıqları (son gediş və şah vermə)';

  @override
  String get preferencesPieceDestinations => 'Fiqurun gedə biləcəyi xanalar (qanuni gediş və öngedişlər)';

  @override
  String get preferencesBoardCoordinates => 'Lövhə koordinantları (A-H, 1-8)';

  @override
  String get preferencesMoveListWhilePlaying => 'Oyun zamanı notasiyanı göstər';

  @override
  String get preferencesPgnPieceNotation => 'Şahmat notasiyası';

  @override
  String get preferencesChessPieceSymbol => 'Şahmat fiqur simvolu';

  @override
  String get preferencesPgnLetter => 'Hərf (K, Q, R, B, N)';

  @override
  String get preferencesZenMode => 'Zen rejimi';

  @override
  String get preferencesShowPlayerRatings => 'Show player ratings';

  @override
  String get preferencesShowFlairs => 'Show player flairs';

  @override
  String get preferencesExplainShowPlayerRatings => 'This hides all ratings from Lichess, to help focus on the chess. Rated games still impact your rating, this is only about what you get to see.';

  @override
  String get preferencesDisplayBoardResizeHandle => 'Lövhə ölçüləndirmə tutacağını göstər';

  @override
  String get preferencesOnlyOnInitialPosition => 'Yalnız başlanğıc pozisiyada';

  @override
  String get preferencesInGameOnly => 'In-game only';

  @override
  String get preferencesChessClock => 'Şahmat saatı';

  @override
  String get preferencesTenthsOfSeconds => 'Saniyənin onda biri';

  @override
  String get preferencesWhenTimeRemainingLessThanTenSeconds => '10 saniyədən az vaxt qalanda';

  @override
  String get preferencesHorizontalGreenProgressBars => 'Üfüqi yaşıl inkişaf sətri';

  @override
  String get preferencesSoundWhenTimeGetsCritical => 'Zaman azaldığında səslə xəbərdarlıq';

  @override
  String get preferencesGiveMoreTime => 'Vaxt ver';

  @override
  String get preferencesGameBehavior => 'Oyun seçimləri';

  @override
  String get preferencesHowDoYouMovePieces => 'Fiqurları necə hərəkət etdirəcəksiniz?';

  @override
  String get preferencesClickTwoSquares => 'İki xanaya klikləyərək';

  @override
  String get preferencesDragPiece => 'Fiquru sürüşdürərək';

  @override
  String get preferencesBothClicksAndDrag => 'Hər ikisi';

  @override
  String get preferencesPremovesPlayingDuringOpponentTurn => 'Öngedişlər (oyun növbəsi rəqibdə olarkən oyna)';

  @override
  String get preferencesTakebacksWithOpponentApproval => 'Geri qaytarma (rəqib razılığı ilə)';

  @override
  String get preferencesInCasualGamesOnly => 'Yalnız reytinqsiz oyunlarda';

  @override
  String get preferencesPromoteToQueenAutomatically => 'Avtomatik Vəzirə çıx';

  @override
  String get preferencesExplainPromoteToQueenAutomatically => 'Hold the <ctrl> key while promoting to temporarily disable auto-promotion';

  @override
  String get preferencesWhenPremoving => 'Ön gediş edərkən';

  @override
  String get preferencesClaimDrawOnThreefoldRepetitionAutomatically => 'Üç dəfə təkrarlanan oyunda avtomatik heç-heçə təklif et';

  @override
  String get preferencesWhenTimeRemainingLessThanThirtySeconds => 'Qalan vaxt 30 saniyədən az olanda';

  @override
  String get preferencesMoveConfirmation => 'Gediş təsdiqi';

  @override
  String get preferencesExplainCanThenBeTemporarilyDisabled => 'Can be disabled during a game with the board menu';

  @override
  String get preferencesInCorrespondenceGames => 'Yazışmalı oyunlar';

  @override
  String get preferencesCorrespondenceAndUnlimited => 'Yazışmalı və vaxtsız';

  @override
  String get preferencesConfirmResignationAndDrawOffers => 'Məğlubiyyət və heç-heçə təkliflərini təsdiqlə';

  @override
  String get preferencesCastleByMovingTheKingTwoSquaresOrOntoTheRook => 'Qala qurma metodu';

  @override
  String get preferencesCastleByMovingTwoSquares => 'Şahı iki xana hərəkət etdirərək';

  @override
  String get preferencesCastleByMovingOntoTheRook => 'Şahı topa tərəf gətirərək';

  @override
  String get preferencesInputMovesWithTheKeyboard => 'Gedişləri klaviatura ilə daxil et';

  @override
  String get preferencesInputMovesWithVoice => 'Input moves with your voice';

  @override
  String get preferencesSnapArrowsToValidMoves => 'Etibarlı gedişlər üçün oxları göstər';

  @override
  String get preferencesSayGgWpAfterLosingOrDrawing => 'Məğlub olduqda və ya heç-heçə etdikdə \"Yaxşı oyun idi, yaxşı oynadın\" deyin';

  @override
  String get preferencesYourPreferencesHaveBeenSaved => 'Tərcihləriniz saxlanıldı.';

  @override
  String get preferencesScrollOnTheBoardToReplayMoves => 'Scroll on the board to replay moves';

  @override
  String get preferencesCorrespondenceEmailNotification => 'Daily email listing your correspondence games';

  @override
  String get preferencesNotifyStreamStart => 'Streamer goes live';

  @override
  String get preferencesNotifyInboxMsg => 'New inbox message';

  @override
  String get preferencesNotifyForumMention => 'Forum comment mentions you';

  @override
  String get preferencesNotifyInvitedStudy => 'Study invite';

  @override
  String get preferencesNotifyGameEvent => 'Correspondence game updates';

  @override
  String get preferencesNotifyChallenge => 'Challenges';

  @override
  String get preferencesNotifyTournamentSoon => 'Tournament starting soon';

  @override
  String get preferencesNotifyTimeAlarm => 'Correspondence clock running out';

  @override
  String get preferencesNotifyBell => 'Bell notification within Lichess';

  @override
  String get preferencesNotifyPush => 'Device notification when you\'re not on Lichess';

  @override
  String get preferencesNotifyWeb => 'Browser';

  @override
  String get preferencesNotifyDevice => 'Device';

  @override
  String get preferencesBellNotificationSound => 'Bell notification sound';

  @override
  String get puzzlePuzzles => 'Tapmacalar';

  @override
  String get puzzlePuzzleThemes => 'Tapmaca mövzuları';

  @override
  String get puzzleRecommended => 'Tövsiyə edilən';

  @override
  String get puzzlePhases => 'Mərhələlər';

  @override
  String get puzzleMotifs => 'Motivlər';

  @override
  String get puzzleAdvanced => 'Ətraflı';

  @override
  String get puzzleLengths => 'Uzunluq';

  @override
  String get puzzleMates => 'Matlar';

  @override
  String get puzzleGoals => 'Hədəflər';

  @override
  String get puzzleOrigin => 'Mənşəyi';

  @override
  String get puzzleSpecialMoves => 'Xüsusi gedişlər';

  @override
  String get puzzleDidYouLikeThisPuzzle => 'Bu tapmacanı bəyəndiniz?';

  @override
  String get puzzleVoteToLoadNextOne => 'Sıradakına keçmək üçün səs verin!';

  @override
  String get puzzleUpVote => 'Up vote puzzle';

  @override
  String get puzzleDownVote => 'Down vote puzzle';

  @override
  String get puzzleYourPuzzleRatingWillNotChange => 'Your puzzle rating will not change. Note that puzzles are not a competition. Your rating helps selecting the best puzzles for your current skill.';

  @override
  String get puzzleFindTheBestMoveForWhite => 'Ağlar üçün ən yaxşı gedişi tapın.';

  @override
  String get puzzleFindTheBestMoveForBlack => 'Qaralar üçün ən yaxşı gedişi tapın.';

  @override
  String get puzzleToGetPersonalizedPuzzles => 'Fərdiləşdirilmiş tapmacalar üçün:';

  @override
  String puzzlePuzzleId(String param) {
    return 'Tapmaca $param';
  }

  @override
  String get puzzlePuzzleOfTheDay => 'Günün tapmacası';

  @override
  String get puzzleDailyPuzzle => 'Daily Puzzle';

  @override
  String get puzzleClickToSolve => 'Həll etmək üçün kliklə';

  @override
  String get puzzleGoodMove => 'Yaxşı gediş';

  @override
  String get puzzleBestMove => 'Ən yaxşı gediş!';

  @override
  String get puzzleKeepGoing => 'Davam edin…';

  @override
  String get puzzlePuzzleSuccess => 'Uğurlu!';

  @override
  String get puzzlePuzzleComplete => 'Tapmaca tamamlandı!';

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
  String get puzzleNotTheMove => 'Düzgün gediş deyil!';

  @override
  String get puzzleTrySomethingElse => 'Başqa bir şey yoxlayın.';

  @override
  String puzzleRatingX(String param) {
    return 'Reytinq: $param';
  }

  @override
  String get puzzleHidden => 'gizli';

  @override
  String puzzleFromGameLink(String param) {
    return '$param oyunundan';
  }

  @override
  String get puzzleContinueTraining => 'Təlimə davam et';

  @override
  String get puzzleDifficultyLevel => 'Çətinlik səviyyəsi';

  @override
  String get puzzleNormal => 'Normal';

  @override
  String get puzzleEasier => 'Daha asan';

  @override
  String get puzzleEasiest => 'Ən asan';

  @override
  String get puzzleHarder => 'Daha çətin';

  @override
  String get puzzleHardest => 'Ən çətin';

  @override
  String get puzzleExample => 'Nümunə';

  @override
  String get puzzleAddAnotherTheme => 'Başqa mövzu artırın';

  @override
  String get puzzleNextPuzzle => 'Next puzzle';

  @override
  String get puzzleJumpToNextPuzzleImmediately => 'Dərhal növbəti tapmacaya keçin';

  @override
  String get puzzlePuzzleDashboard => 'Tapmaca paneli';

  @override
  String get puzzleImprovementAreas => 'Təkmilləşdirmə sahələri';

  @override
  String get puzzleStrengths => 'Güc';

  @override
  String get puzzleHistory => 'Tapmaca keçmişi';

  @override
  String get puzzleSolved => 'həll edilmiş';

  @override
  String get puzzleFailed => 'uğursuz oldu';

  @override
  String get puzzleStreakDescription => 'Getdikcə çətinləşən pazlları yerinə yetir və qələbə seriyası yarat. Zaman məhdudiyyəri yoxdur, odur ki, tələsmə. Bir səhv gediş və oyun bitdi! Amma hər sessiyada bir gedişi buraxa bilərsən.';

  @override
  String puzzleYourStreakX(String param) {
    return 'Qələbə seriyan: $param';
  }

  @override
  String get puzzleStreakSkipExplanation => 'Qələbə seriyanı qorumaq üçün bu gedişi keç! Oyun başına yalnız bir dəfə işləyir.';

  @override
  String get puzzleContinueTheStreak => 'Qələbə seriyanı davam et';

  @override
  String get puzzleNewStreak => 'Yeni qələbə seriyası';

  @override
  String get puzzleFromMyGames => 'Oyunlarımdan';

  @override
  String get puzzleLookupOfPlayer => 'Bir oyunçunun oyunlarından tapmacalar';

  @override
  String puzzleFromXGames(String param) {
    return '$param\' oyunlarından yapbozlar';
  }

  @override
  String get puzzleSearchPuzzles => 'Tapmaca axtar';

  @override
  String get puzzleFromMyGamesNone => 'Verilənlər bazasında heç bir tapmaca yoxdur, amma Lichess hələ də səni çox sevir.\nBir tapmaca əlavə etmək şansınızı artırmaq üçün sürətli və klassik oyunlar oynayın!';

  @override
  String puzzleFromXGamesFound(String param1, String param2) {
    return '$param1 oyunlarında tapılan$param2 tapmacalar';
  }

  @override
  String get puzzlePuzzleDashboardDescription => 'Təlim edin, təhlil edin, təkmilləşdirmə edin';

  @override
  String puzzlePercentSolved(String param) {
    return '$param həll edildi';
  }

  @override
  String get puzzleNoPuzzlesToShow => 'Göstərəcək bir şey yoxdur, əvvəlcə bəzi tapmacalar oynayın!';

  @override
  String get puzzleImprovementAreasDescription => 'irəliləmənizi yoxlamaq üçün bunları optimize edin!';

  @override
  String get puzzleStrengthDescription => 'Bu mövzularda ən yaxşı performansı göstərirsiniz';

  @override
  String puzzlePlayedXTimes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count dəfə həll edildi',
      one: '$count dəfə həll edildi',
    );
    return '$_temp0';
  }

  @override
  String puzzleNbPointsBelowYourPuzzleRating(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Sizin tapmaca reytinqinizdən $count bal aşağı',
      one: 'Sizin tapmaca reytinqinizdən bir bal aşağı',
    );
    return '$_temp0';
  }

  @override
  String puzzleNbPointsAboveYourPuzzleRating(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Sizin tapmaca reytinqinizdən $count bal yuxarı',
      one: 'Sizin tapmaca reytinqinizdən bir bal yuxarı',
    );
    return '$_temp0';
  }

  @override
  String puzzleNbPlayed(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count played',
    );
    return '$_temp0';
  }

  @override
  String puzzleNbToReplay(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count to replay',
    );
    return '$_temp0';
  }

  @override
  String get puzzleThemeAdvancedPawn => 'Keçid piyadası';

  @override
  String get puzzleThemeAdvancedPawnDescription => 'Çevrilən və ya çevrilməyə yaxın bir piyada taktikanın açarıdır.';

  @override
  String get puzzleThemeAdvantage => 'Üstünlük';

  @override
  String get puzzleThemeAdvantageDescription => 'Həlledici üstünlük əldə etmək üçün fürsətdən istifadə edin. (200-600sp arası)';

  @override
  String get puzzleThemeAnastasiaMate => 'Anastasiya matı';

  @override
  String get puzzleThemeAnastasiaMateDescription => 'Bir atın köməyilə top və ya vəzir, rəqib şahını lövhənin kənarında digər bir rəqib fiquru ilə mat edir.';

  @override
  String get puzzleThemeArabianMate => 'Ərəb matı';

  @override
  String get puzzleThemeArabianMateDescription => 'At və top, rəqib şahını lövhənin bir küncünə sıxışdırıb mat edir.';

  @override
  String get puzzleThemeAttackingF2F7 => 'f2 və ya f7 hücumu';

  @override
  String get puzzleThemeAttackingF2F7Description => 'Qızardılmış qaraciyər (feqatello) hücumunda olduğu kimi, f2-f7 piyadasına hədəflənmiş hücum.';

  @override
  String get puzzleThemeAttraction => 'Cəlbetmə';

  @override
  String get puzzleThemeAttractionDescription => 'Rəqib fiqurunu müxtəlif taktikalara imkan verən xanaya getməyə məcbur edən, dəyişmə və ya qurban.';

  @override
  String get puzzleThemeBackRankMate => 'Arxa xətdə mat';

  @override
  String get puzzleThemeBackRankMateDescription => 'Öz fiqurları arasında sıxılıb qalmış şahı mat et.';

  @override
  String get puzzleThemeBishopEndgame => 'Fil sonluğu';

  @override
  String get puzzleThemeBishopEndgameDescription => 'Yalnız fillər və piyadalardan ibarət oyun sonu.';

  @override
  String get puzzleThemeBodenMate => 'Boden matı';

  @override
  String get puzzleThemeBodenMateDescription => 'İki fil, öz fiqurları tərəfindən bloklanan şahı çarpaz diaqonallardan hücum edərək mat edir.';

  @override
  String get puzzleThemeCastling => 'Qalaqurma';

  @override
  String get puzzleThemeCastlingDescription => 'Şahı təhlükəsiz yerə gətirin və hücum üçün topu hazırlayın.';

  @override
  String get puzzleThemeCapturingDefender => 'Müdafiəçini vurmaq';

  @override
  String get puzzleThemeCapturingDefenderDescription => 'Bir fiquru müdafiə edən başqa bir fiquru ələ keçirərək, müdafiəsiz qalan digər fiquru da növbəti gedişdə ələ keçirin.';

  @override
  String get puzzleThemeCrushing => 'Əzici üstünlük';

  @override
  String get puzzleThemeCrushingDescription => 'Əzici üstünlük əldə etmək üçün rəqibin kobud səhvini müəyyənləşdirin. (600sp və ondan yüksək)';

  @override
  String get puzzleThemeDoubleBishopMate => 'İki fil matı';

  @override
  String get puzzleThemeDoubleBishopMateDescription => 'İki fil, öz fiqurları tərəfindən bloklanan şahı bitişik diaqonallardan hücum edərək mat edir.';

  @override
  String get puzzleThemeDovetailMate => 'Koziyo matı';

  @override
  String get puzzleThemeDovetailMateDescription => 'İki qaçış xanası da öz fiqurları tərəfindən tutulan şaha çarpaz bitişik diaqonaldan vəzirlə edilən mat.';

  @override
  String get puzzleThemeEquality => 'Bərabərləşmə';

  @override
  String get puzzleThemeEqualityDescription => 'İtirilmiş bir pozisiyadan çıxın, heç-heçə və ya balanslı bir mövqe əldə edin. (200sp və daha az)';

  @override
  String get puzzleThemeKingsideAttack => 'Şah cinahında hücum';

  @override
  String get puzzleThemeKingsideAttackDescription => 'Qısa qalaqurma edən rəqib şahına hücum.';

  @override
  String get puzzleThemeClearance => 'Xətt açmaq';

  @override
  String get puzzleThemeClearanceDescription => 'Bir xananı və ya bir xətti qarşıdan gələn bir taktika üçün açan, əksər hallarda tempo qazandıran gedişlər.';

  @override
  String get puzzleThemeDefensiveMove => 'Müdafiə gedişi';

  @override
  String get puzzleThemeDefensiveMoveDescription => 'Material və ya başqa bir üstünlüyü itirməmək üçün lazım olan dəqiq bir gediş və ya gedişlər ardıcıllığı.';

  @override
  String get puzzleThemeDeflection => 'Yayındırma';

  @override
  String get puzzleThemeDeflectionDescription => 'Rəqib fiqurunu, yerinə yetirdiyi başqa bir vəzifədən, məsələn, vacib bir xananı qorumaqdan yayındıran bir gediş. Bəzən \"həddindən artıq yükləmə\" də deyilir.';

  @override
  String get puzzleThemeDiscoveredAttack => 'Açaraq hücum';

  @override
  String get puzzleThemeDiscoveredAttackDescription => 'Uzaq mənzilli bir fiqurun yolunu kəsən digər bir fiquru oynayaraq edilən hücum, atı oynayaraq topla hücum etmək kimi.';

  @override
  String get puzzleThemeDoubleCheck => 'İkiqat şah';

  @override
  String get puzzleThemeDoubleCheckDescription => 'Bir gedişdə, həm gediş edilən həm də açaraq hücumun ardından yolu açılan fiqur ilə eyni anda şah vermək.';

  @override
  String get puzzleThemeEndgame => 'Endşpil';

  @override
  String get puzzleThemeEndgameDescription => 'Oyunun son mərhələsindəki taktikalar.';

  @override
  String get puzzleThemeEnPassantDescription => 'Başlanğıcda iki xana irəli gedən piyadanın, rəqib piyada ilə yan yana gəlməsindən sonra, keçiddə götürmə qaydasına əsasən, vurulan piyadanı əhatə edən taktikalar.';

  @override
  String get puzzleThemeExposedKing => 'Müdafiəsiz şah';

  @override
  String get puzzleThemeExposedKingDescription => 'Ətrafında az müdafiəçisi olan şahın olduğu və əksər hallarda mat ilə nəticələnən taktikalar.';

  @override
  String get puzzleThemeFork => 'Çəngəl';

  @override
  String get puzzleThemeForkDescription => 'Bir fiqurun eyni anda iki rəqib fiquruna hücum etdiyi gediş.';

  @override
  String get puzzleThemeHangingPiece => 'Qorunmasız fiqur';

  @override
  String get puzzleThemeHangingPieceDescription => 'Rəqib fiqurunun müdafiəsiz və ya kifayət qədər müdafiə olunmadığı və vurulmağa hazır olduğunu əhatə edən bir taktika.';

  @override
  String get puzzleThemeHookMate => 'Qarmaq matı';

  @override
  String get puzzleThemeHookMateDescription => 'Top, at, piyada və rəqib şahının qaçışını məhdudlaşdırmaq üçün bir rəqib piyadası ilə birlikdə edilən mat.';

  @override
  String get puzzleThemeInterference => 'Yolukəsmə';

  @override
  String get puzzleThemeInterferenceDescription => 'Bir və ya hər iki rəqib fiqurunu müdafiəsiz buraxmaq üçün iki rəqib fiquru arasına öz fiqurunu qoymaq, məsələn, iki top arasındakı müdafiə olunan bir xanaya bir at qoymaq.';

  @override
  String get puzzleThemeIntermezzo => 'İntermezzo';

  @override
  String get puzzleThemeIntermezzoDescription => 'Gözlənilən bir gedişi oynamaq əvəzinə əvvəlcə rəqibin cavab verməyə məcbur olduğu, başqa bir gediş edin. Buna \"Zwischenzug\" və ya \"Ara gediş\" deyilir.';

  @override
  String get puzzleThemeKnightEndgame => 'At sonluğu';

  @override
  String get puzzleThemeKnightEndgameDescription => 'Yalnız atlar və piyadalardan ibarət oyun sonu.';

  @override
  String get puzzleThemeLong => 'Uzun tapmaca';

  @override
  String get puzzleThemeLongDescription => '3 gedişə qələbə.';

  @override
  String get puzzleThemeMaster => 'Usta oyunları';

  @override
  String get puzzleThemeMasterDescription => 'Titullu oyunçuların oynadığı oyunlardan tapmacalar.';

  @override
  String get puzzleThemeMasterVsMaster => 'Usta vs Usta oyunları';

  @override
  String get puzzleThemeMasterVsMasterDescription => 'İki titullu oyunçu arasındakı oyunlardan tapmacalar.';

  @override
  String get puzzleThemeMate => 'Mat';

  @override
  String get puzzleThemeMateDescription => 'Oyunu üslubuyla qazanın.';

  @override
  String get puzzleThemeMateIn1 => '1 Gedişə Mat';

  @override
  String get puzzleThemeMateIn1Description => 'Bir gedişə mat edin.';

  @override
  String get puzzleThemeMateIn2 => '2 Gedişə Mat';

  @override
  String get puzzleThemeMateIn2Description => 'İki gedişə mat edin.';

  @override
  String get puzzleThemeMateIn3 => '3 Gedişə Mat';

  @override
  String get puzzleThemeMateIn3Description => 'Üç gedişə mat et.';

  @override
  String get puzzleThemeMateIn4 => '4 Gedişə Mat';

  @override
  String get puzzleThemeMateIn4Description => 'Dörd gedişə mat et.';

  @override
  String get puzzleThemeMateIn5 => '5 və ya daha çox gedişə mat';

  @override
  String get puzzleThemeMateIn5Description => 'Uzun mat ardıcıllığını həll etməyə çalışın.';

  @override
  String get puzzleThemeMiddlegame => 'Mittelşpil';

  @override
  String get puzzleThemeMiddlegameDescription => 'Oyunun ikinci mərhələsindəki taktikalar.';

  @override
  String get puzzleThemeOneMove => 'Bir gedişlik tapmaca';

  @override
  String get puzzleThemeOneMoveDescription => 'Bir gedişlik tapmacalar.';

  @override
  String get puzzleThemeOpening => 'Debüt';

  @override
  String get puzzleThemeOpeningDescription => 'Oyunun ilk mərhələsindəki taktikalar.';

  @override
  String get puzzleThemePawnEndgame => 'Piyada sonluğu';

  @override
  String get puzzleThemePawnEndgameDescription => 'Sadəcə piyadalardan ibarət oyun sonu.';

  @override
  String get puzzleThemePin => 'Bağlama';

  @override
  String get puzzleThemePinDescription => 'Hərəkət edəcəyi təqdirdə, özündən daha dəyərli bir fiqur hücuma məruz qalacağı üçün, yerindən tərpənə bilməyən, bağlanmış fiqurları əhatə edən taktikalar.';

  @override
  String get puzzleThemePromotion => 'Çevrilmə';

  @override
  String get puzzleThemePromotionDescription => 'Çevrilən və ya çevrilməyə yaxın bir piyada taktikanın açarıdır.';

  @override
  String get puzzleThemeQueenEndgame => 'Vəzir sonluğu';

  @override
  String get puzzleThemeQueenEndgameDescription => 'Yalnız vəzirlər və piyadalardan ibarət oyun sonu.';

  @override
  String get puzzleThemeQueenRookEndgame => 'Vəzir və Top';

  @override
  String get puzzleThemeQueenRookEndgameDescription => 'Yalnız vəzirlər, toplar və piyadalardan ibarət oyun sonu.';

  @override
  String get puzzleThemeQueensideAttack => 'Vəzir cinahında hücum';

  @override
  String get puzzleThemeQueensideAttackDescription => 'Uzun qalaqurma edən rəqib şahına hücum.';

  @override
  String get puzzleThemeQuietMove => 'Sakit gediş';

  @override
  String get puzzleThemeQuietMoveDescription => 'Şah verməyən və ya fiqur ələ keçirməyən, lakin sonrakı gedişdə üçün qarşısıalınmaz bir təhdid hazırlayan gediş.';

  @override
  String get puzzleThemeRookEndgame => 'Top sonluğu';

  @override
  String get puzzleThemeRookEndgameDescription => 'Sadəcə top və piyadaların olduğu oyun sonluğu.';

  @override
  String get puzzleThemeSacrifice => 'Qurban';

  @override
  String get puzzleThemeSacrificeDescription => 'Məcburi gedişlər seriyasından sonra yenidən üstünlük qazanmaq üçün qısa müddətdə materialdan imtina etməyi əhatə edən bir taktika.';

  @override
  String get puzzleThemeShort => 'Qısa tapmaca';

  @override
  String get puzzleThemeShortDescription => '2 gedişə qələbə.';

  @override
  String get puzzleThemeSkewer => 'Şiş';

  @override
  String get puzzleThemeSkewerDescription => 'Dəyərli bir fiqurun hüuma məruz qaldığı, hərəkət edəcəyi halda daha az dəyərli bir fiqurun itiriləcəyi və ya təhlükəyə düşəcəyi motivlər. Bağlamanın tərsi.';

  @override
  String get puzzleThemeSmotheredMate => 'Boğma matı';

  @override
  String get puzzleThemeSmotheredMateDescription => 'Öz fiqurları tərəfindən əhatələndiyi (və ya boğulduğu) üçün hərəkət edə bilməyən şahın at ilə mat edilməsi.';

  @override
  String get puzzleThemeSuperGM => 'Super GM oyunları';

  @override
  String get puzzleThemeSuperGMDescription => 'Dünyanın ən yaxşı oyunçularının oynadığı oyunlardan tapmacalar.';

  @override
  String get puzzleThemeTrappedPiece => 'Tələyə düşmüş fiqur';

  @override
  String get puzzleThemeTrappedPieceDescription => 'Gedəcək təhlükəsiz bir xanası olmadığı üçün fiqur vurulmaqdan qaça bilmir.';

  @override
  String get puzzleThemeUnderPromotion => 'Zəifə Çevrilmə';

  @override
  String get puzzleThemeUnderPromotionDescription => 'Ata, filə və ya topa çevrilmə.';

  @override
  String get puzzleThemeVeryLong => 'Çox uzun tapmaca';

  @override
  String get puzzleThemeVeryLongDescription => '4 və daha çox gedişə qələbə.';

  @override
  String get puzzleThemeXRayAttack => 'Rentgen hücumu';

  @override
  String get puzzleThemeXRayAttackDescription => 'Fiqur, bir xanaya rəqib fiquru üzərindən hücum edir və ya müdafiə edir.';

  @override
  String get puzzleThemeZugzwang => 'Suqsvanq';

  @override
  String get puzzleThemeZugzwangDescription => 'Rəqibin edə biləcəyi gediş sayı məhduddur və istənilən gediş vəziyyəti daha da pisləşdirir.';

  @override
  String get puzzleThemeHealthyMix => 'Həftəbecər';

  @override
  String get puzzleThemeHealthyMixDescription => 'Hər şeydən bir az. Nə gözləyəcəyini bilmirsən, ona görə hər şeyə hazır olursan! Eynilə həqiqi oyunlarda olduğu kimi.';

  @override
  String get puzzleThemePlayerGames => 'Player games';

  @override
  String get puzzleThemePlayerGamesDescription => 'Lookup puzzles generated from your games, or from another player\'s games.';

  @override
  String puzzleThemePuzzleDownloadInformation(String param) {
    return 'These puzzles are in the public domain, and can be downloaded from $param.';
  }

  @override
  String get searchSearch => 'Axtar';

  @override
  String get settingsSettings => 'Tənzimləmələr';

  @override
  String get settingsCloseAccount => 'Hesabı bağla';

  @override
  String get settingsManagedAccountCannotBeClosed => 'Your account is managed, and cannot be closed.';

  @override
  String get settingsClosingIsDefinitive => 'Hesabı bağlama əməliyyatının geri dönüşü yoxdur. Əminsiniz?';

  @override
  String get settingsCantOpenSimilarAccount => 'Böyük kiçik hərf dəyişiklikləri etsəniz belə eyni istifadəçi adı ilə yeni hesab açmağınıza icazə verilməyəcək.';

  @override
  String get settingsChangedMindDoNotCloseAccount => 'Fikrimi dəyişdirdim, hesabımı bağlamaq istəmirəm';

  @override
  String get settingsCloseAccountExplanation => 'Hesabınızı bağlamaq istədiyinizə əminsiniz? Bu birdəfəlik əməliyyatdır. BİR DƏ HEÇ VAXT giriş edə bilməyəcəksiniz.';

  @override
  String get settingsThisAccountIsClosed => 'Hesab bağlanıldı.';

  @override
  String get playWithAFriend => 'Bir dostunla oyna';

  @override
  String get playWithTheMachine => 'Kompüterlə oyna';

  @override
  String get toInviteSomeoneToPlayGiveThisUrl => 'Kimisə oyuna dəvət etmək üçün, bu URL-i göndərin';

  @override
  String get gameOver => 'Oyun Bitdi';

  @override
  String get waitingForOpponent => 'Rəqib gözlənilir';

  @override
  String get orLetYourOpponentScanQrCode => 'Or let your opponent scan this QR code';

  @override
  String get waiting => 'Gözlənilir';

  @override
  String get yourTurn => 'Sizin növbənizdir';

  @override
  String aiNameLevelAiLevel(String param1, String param2) {
    return '$param1 səviyyə $param2';
  }

  @override
  String get level => 'Səviyyə';

  @override
  String get strength => 'Güc';

  @override
  String get toggleTheChat => 'Söhbəti aç/bağla';

  @override
  String get chat => 'Mesaj göndər';

  @override
  String get resign => 'Tərk et';

  @override
  String get checkmate => 'Mat';

  @override
  String get stalemate => 'Pat';

  @override
  String get white => 'Ağ';

  @override
  String get black => 'Qara';

  @override
  String get asWhite => 'ağ olaraq';

  @override
  String get asBlack => 'qara olaraq';

  @override
  String get randomColor => 'Təsadüfi rəng';

  @override
  String get createAGame => 'Bir oyun yarat';

  @override
  String get whiteIsVictorious => 'Ağlar qalib gəldi';

  @override
  String get blackIsVictorious => 'Qaralar qalib gəldi';

  @override
  String get youPlayTheWhitePieces => 'Ağlarla oynayırsınız';

  @override
  String get youPlayTheBlackPieces => 'Qaralarla oynayırsınız';

  @override
  String get itsYourTurn => 'Sizin növbənizdir!';

  @override
  String get cheatDetected => '\"Cheat\" aşkarlandı';

  @override
  String get kingInTheCenter => 'Şah mərkəzdə';

  @override
  String get threeChecks => 'Üç şah';

  @override
  String get raceFinished => 'Yarış bitdi';

  @override
  String get variantEnding => 'Variant bitdi';

  @override
  String get newOpponent => 'Yeni rəqib';

  @override
  String get yourOpponentWantsToPlayANewGameWithYou => 'Rəqibiniz sizinlə yeni bir oyun oynamaq istəyir';

  @override
  String get joinTheGame => 'Oyuna qoşul';

  @override
  String get whitePlays => 'Gediş ağlarındır';

  @override
  String get blackPlays => 'Gediş qaralarındır';

  @override
  String get opponentLeftChoices => 'Rəqibiniz oyunu tərk etdi. Qələbə, heç-heçə tələb edə və ya gözləyə bilərsiniz.';

  @override
  String get forceResignation => 'Qələbə tələb et';

  @override
  String get forceDraw => 'Heç-heçə elan et';

  @override
  String get talkInChat => 'Söhbət zamanı nəzakətli olun!';

  @override
  String get theFirstPersonToComeOnThisUrlWillPlayWithYou => 'URL-ə ilk müraciət edən sizin rəqibiniz olacaq.';

  @override
  String get whiteResigned => 'Ağlar tərk etdi';

  @override
  String get blackResigned => 'Qaralar tərk etdi';

  @override
  String get whiteLeftTheGame => 'Ağlar oyunu tərk etdi';

  @override
  String get blackLeftTheGame => 'Qaralar oyunu tərk etdi';

  @override
  String get whiteDidntMove => 'Ağlar gediş oynamadı';

  @override
  String get blackDidntMove => 'Qaralar gediş oynamadı';

  @override
  String get requestAComputerAnalysis => 'Kompüter təhlilini tələb et';

  @override
  String get computerAnalysis => 'Kompüter təhlili';

  @override
  String get computerAnalysisAvailable => 'Kompüter təhlili mövcuddur';

  @override
  String get computerAnalysisDisabled => 'Kompüter təhlili deaktiv edildi';

  @override
  String get analysis => 'Təhlil lövhəsi';

  @override
  String depthX(String param) {
    return 'Dərinlik $param';
  }

  @override
  String get usingServerAnalysis => 'Server analizi edilir';

  @override
  String get loadingEngine => 'Mühərrik yüklənir ...';

  @override
  String get calculatingMoves => 'Gedişlər hesablanır...';

  @override
  String get engineFailed => 'Mühərrik yüklənərkən xəta yarandı';

  @override
  String get cloudAnalysis => 'Bulud təhlili';

  @override
  String get goDeeper => 'Daha dərinə get';

  @override
  String get showThreat => 'Təhdidi göstər';

  @override
  String get inLocalBrowser => 'bu brauzerdə';

  @override
  String get toggleLocalEvaluation => 'Yerli qiymətləndirməni aç/bağla';

  @override
  String get promoteVariation => 'Variasiyanı irəli çək';

  @override
  String get makeMainLine => 'Ana davam yolu et';

  @override
  String get deleteFromHere => 'Buradan sil';

  @override
  String get collapseVariations => 'Collapse variations';

  @override
  String get expandVariations => 'Expand variations';

  @override
  String get forceVariation => 'Əsas variasiya et';

  @override
  String get copyVariationPgn => 'PGN variasiyasını kopyalayın';

  @override
  String get move => 'Gediş';

  @override
  String get variantLoss => 'Uduzduracaq variant';

  @override
  String get variantWin => 'Qazandıracaq variant';

  @override
  String get insufficientMaterial => 'Yetərsiz fiqur';

  @override
  String get pawnMove => 'Piyada gedişi';

  @override
  String get capture => 'Vurma';

  @override
  String get close => 'Bağla';

  @override
  String get winning => 'Qazandıran';

  @override
  String get losing => 'Uduzduran';

  @override
  String get drawn => 'Heç-heçə';

  @override
  String get unknown => 'Bilinməyən';

  @override
  String get database => 'Verilənlər bazası';

  @override
  String get whiteDrawBlack => 'Ağlar / Heç-heçə / Qaralar';

  @override
  String averageRatingX(String param) {
    return 'Ortalama reytinq: $param';
  }

  @override
  String get recentGames => 'Son oyunlar';

  @override
  String get topGames => 'Ən yaxşı oyunlar';

  @override
  String masterDbExplanation(String param1, String param2, String param3) {
    return '$param1+ FIDE reytinqli oyunçuların $param2 ildən $param3 ilə qədər lövhə üzərində oynadığı iki milyon oyun';
  }

  @override
  String get dtzWithRounding => 'DTZ50\" növbəti alış və ya piyada gedişinə qədər yarım hərəkətlərin sayına əsasən yuvarlaqlaşdırıldı';

  @override
  String get noGameFound => 'Oyun tapılmadı';

  @override
  String get maxDepthReached => 'Maksimum dərinliyə çatdın!';

  @override
  String get maybeIncludeMoreGamesFromThePreferencesMenu => 'Bəlkə tərcihlər menyusunda daha çox oyunun daxil edilməsini seçəsiniz?';

  @override
  String get openings => 'Açılışlar';

  @override
  String get openingExplorer => 'Debüt tədqiqatçısı';

  @override
  String get openingEndgameExplorer => 'Debüt/Endşpil tədqiqatçısı';

  @override
  String xOpeningExplorer(String param) {
    return '$param debüt bazası';
  }

  @override
  String get playFirstOpeningEndgameExplorerMove => 'İlk açılış/oyun sonu-kəşfiyyatçı hərəkətini oynayın';

  @override
  String get winPreventedBy50MoveRule => 'Qələbə 50 gediş qaydasına görə hesaba alınmadı';

  @override
  String get lossSavedBy50MoveRule => 'Məğlubiyyət 50 gediş qaydasına görə hesaba alınmadı';

  @override
  String get winOr50MovesByPriorMistake => 'Qələbə və ya əvvəlki səhvlə 50 gediş';

  @override
  String get lossOr50MovesByPriorMistake => 'Məğlubiyyət və ya əvvəlki səhvlə 50 gediş';

  @override
  String get unknownDueToRounding => 'Qalib gəlmək/Məğlub olmaq, Syzygy cədvəl bazalarında DTZ dəyərlərinin mümkün yuvarlaqlaşdırılması səbəbiylə, yalnızca sonuncu alış və ya piyada gedişindən sonra tövsiyyə olunan cədvəl bazası xətti izləndiyinə zəmanət verilir.';

  @override
  String get allSet => 'Hər şey hazır!';

  @override
  String get importPgn => 'PGN daxil et';

  @override
  String get delete => 'Sil';

  @override
  String get deleteThisImportedGame => 'Daxil edilmiş bu oyun silinsin?';

  @override
  String get replayMode => 'Təkrar rejimi';

  @override
  String get realtimeReplay => 'Gerçək zamanlı';

  @override
  String get byCPL => 'CPL üzrə';

  @override
  String get openStudy => 'Çalışmanı aç';

  @override
  String get enable => 'Aktiv et';

  @override
  String get bestMoveArrow => 'Ən yaxşı gedişi göstər';

  @override
  String get showVariationArrows => 'Variasiya oxlarını göstərin';

  @override
  String get evaluationGauge => 'Dəyərləndirmə çubuğu';

  @override
  String get multipleLines => 'Oxların sayı';

  @override
  String get cpus => 'CPU sayı';

  @override
  String get memory => 'RAM';

  @override
  String get infiniteAnalysis => 'Sonsuz təhlil';

  @override
  String get removesTheDepthLimit => 'Dərinlik limitini ləğv edir və kompüterinizi isti saxlayır';

  @override
  String get engineManager => 'Mühərrik meneceri';

  @override
  String get blunder => 'Kobud Səhv';

  @override
  String get mistake => 'Səhv';

  @override
  String get inaccuracy => 'Qeyri-dəqiqlik';

  @override
  String get moveTimes => 'Gediş müddəti';

  @override
  String get flipBoard => 'Lövhəni fırlat';

  @override
  String get threefoldRepetition => 'Üçqat təkrar';

  @override
  String get claimADraw => 'Heç-heçə tələb et';

  @override
  String get offerDraw => 'Heç-heçə təklif et';

  @override
  String get draw => 'Heç-heçə';

  @override
  String get drawByMutualAgreement => 'Qarşılıqlı razılıq əsasında heç-heçə';

  @override
  String get fiftyMovesWithoutProgress => 'İrəliləyiş olmadan əlli həmlə';

  @override
  String get currentGames => 'Cari oyunlar';

  @override
  String get viewInFullSize => 'Tam ölçüdə bax';

  @override
  String get logOut => 'Hesabdan çıx';

  @override
  String get signIn => 'Giriş';

  @override
  String get rememberMe => 'Məni yadda saxla';

  @override
  String get youNeedAnAccountToDoThat => 'Bunun üçün bir hesaba ehtiyacınız var';

  @override
  String get signUp => 'Üzv ol';

  @override
  String get computersAreNotAllowedToPlay => 'Kompüterlərin və kompüter dəstəkli oyunçuların oynamasına icazə verilmir. Xahiş edirik oynayarkən şahmat mühərriklərindən, məlumat bazalarından və ya digər oyunçulardan kömək almayın. Həm də qeyd edək ki, birdən çox hesabın açılması ciddi şəkildə yoxlanılır və həddindən artıq çox hesabın açılması hesabınızın ban olunmasına səbəb olacaqdır.';

  @override
  String get games => 'Oyunlar';

  @override
  String get forum => 'Forum';

  @override
  String xPostedInForumY(String param1, String param2) {
    return '$param1 $param2 mövzusunda şərh yazdı';
  }

  @override
  String get latestForumPosts => 'Forumdakı sonuncu mesajlar';

  @override
  String get players => 'Oyunçular';

  @override
  String get friends => 'Dostlar';

  @override
  String get discussions => 'Söhbətlərlər';

  @override
  String get today => 'Bu gün';

  @override
  String get yesterday => 'Dünən';

  @override
  String get minutesPerSide => 'Oyunçu başına dəqiqə';

  @override
  String get variant => 'Variant';

  @override
  String get variants => 'Variantlar';

  @override
  String get timeControl => 'Vaxta nəzarət';

  @override
  String get realTime => 'Real vaxt';

  @override
  String get correspondence => 'Yazışmalı';

  @override
  String get daysPerTurn => 'Gediş başına gün';

  @override
  String get oneDay => 'Bir gün';

  @override
  String get time => 'Vaxt';

  @override
  String get rating => 'Reytinq';

  @override
  String get ratingStats => 'Reytinq statistikaları';

  @override
  String get username => 'İstifadəçi adı';

  @override
  String get usernameOrEmail => 'İstifadəçi adı və ya e-poçt';

  @override
  String get changeUsername => 'İstifadəçi adını dəyiş';

  @override
  String get changeUsernameNotSame => 'Sadəcə istifadəçi adınızdakı böyük/kiçik hərfləri dəyişdirə bilərsiniz. Məsələn \"johndoe\" ilə \"JohnDoe\" kimi.';

  @override
  String get changeUsernameDescription => 'İstifadəçi adını dəyişdir. Bu prosesi sadəcə bir dəfə edə bilərsən və sadəcə mövcud istifadəçi adındakı hərfləri böyük və ya kiçik edə bilərsən.';

  @override
  String get signupUsernameHint => 'Ailə dostu bir istifadəçi adı seçdiyinizdən əmin olun. Siz onu daha sonra dəyişə bilməzsiniz və uyğun olmayan istifadəçi adları olan hesablar bağlanacaq!';

  @override
  String get signupEmailHint => 'Biz onu yalnız parol sıfırlanması üçün istifadə edəcəyik.';

  @override
  String get password => 'Şifrə';

  @override
  String get changePassword => 'Şifrəni dəyiş';

  @override
  String get changeEmail => 'E-poçtu dəyiş';

  @override
  String get email => 'E-poçt';

  @override
  String get passwordReset => 'Şifrəni yenilə';

  @override
  String get forgotPassword => 'Şifrəni unutmusuz?';

  @override
  String get error_weakPassword => 'Bu parol olduqca yayğındır və təxmin etmək çox asandır.';

  @override
  String get error_namePassword => 'Zəhmət olmasa istifadəçi adınızı şifrə kimi istifadə etməyin.';

  @override
  String get blankedPassword => 'Siz eyni parolu başqa saytda istifadə etmisiniz və həmin sayt oğurlanıb. Lichess hesabınızın təhlükəsizliyini təmin etmək üçün sizə yeni parol təyin etməyimiz lazımdır. Anlayışınız üçün təşəkkür edirik.';

  @override
  String get youAreLeavingLichess => 'Lichessdən ayrılırsınız';

  @override
  String get neverTypeYourPassword => 'Lichess parolunuzu heç vaxt başqa saytda yazmayın!';

  @override
  String proceedToX(String param) {
    return '$param ilə davam edin';
  }

  @override
  String get passwordSuggestion => 'Başqasının təklif etdiyi parolu təyin etməyin. Hesabınızı oğurlamaq üçün istifadə edə bilərlər.';

  @override
  String get emailSuggestion => 'Başqasının təklif etdiyi e-poçt ünvanını təyin etməyin. Hesabınızı oğurlamaq üçün istifadə edəcəklər.';

  @override
  String get emailConfirmHelp => 'Email təsdiqi üçün yardım';

  @override
  String get emailConfirmNotReceived => 'Qeydiyyatdan keçdikdən sonra doğrulama maili almadınız?';

  @override
  String get whatSignupUsername => 'Hansı istifadəçi adıyla qeydiyyatdan keçmisən?';

  @override
  String usernameNotFound(String param) {
    return 'Bu adla olan bir istifadəçi tapa bilmədik: $param.';
  }

  @override
  String get usernameCanBeUsedForNewAccount => 'Bu istifadəçi adıyla yeni bir hesab yarada bilərsən';

  @override
  String emailSent(String param) {
    return 'Biz $param adlı ünvana email yollamışıq.';
  }

  @override
  String get emailCanTakeSomeTime => 'Bu biraz vaxt ala bilər.';

  @override
  String get refreshInboxAfterFiveMinutes => '5 dəqiqə gözləyin və email qutunuzu yenidən yoxlayın.';

  @override
  String get checkSpamFolder => 'Spam qutusunu da yoxlayın, məktub oradada ola bilər. Elədirsə, zəhmət olmasa qeyri-spam kimi qeyd edin.';

  @override
  String get emailForSignupHelp => 'Əgər heç nə alınmırsa, bizə email yollayın:';

  @override
  String copyTextToEmail(String param) {
    return 'Yuxarıdakı mətni kopyalayıb yapışdırıb $param ünvanına göndərin';
  }

  @override
  String get waitForSignupHelp => 'Qeydiyyatınızı tamamlamağınıza kömək etmək üçün tezliklə sizinlə əlaqə saxlayacağıq.';

  @override
  String accountConfirmed(String param) {
    return '$param istifadəçisi uğurla təsdiqləndi.';
  }

  @override
  String accountCanLogin(String param) {
    return 'Siz indi $param kimi daxil ola bilərsiniz.';
  }

  @override
  String get accountConfirmationEmailNotNeeded => 'Təsdiq e-poçtuna ehtiyacınız yoxdur.';

  @override
  String accountClosed(String param) {
    return '$param hesabı bağlanıb.';
  }

  @override
  String accountRegisteredWithoutEmail(String param) {
    return '$param hesabı e-poçt olmadan qeydiyyatdan keçdi.';
  }

  @override
  String get rank => 'Sıralama';

  @override
  String rankX(String param) {
    return 'Sıralama: $param';
  }

  @override
  String get gamesPlayed => 'Oynadığı oyunlar';

  @override
  String get cancel => 'Ləğv et';

  @override
  String get whiteTimeOut => 'Ağların vaxtı bitdi';

  @override
  String get blackTimeOut => 'Qaraların vaxtı bitdi';

  @override
  String get drawOfferSent => 'Heç-heçə təklifi göndərildi';

  @override
  String get drawOfferAccepted => 'Heç-heçə təklifi qəbul edildi';

  @override
  String get drawOfferCanceled => 'Heç-heçə təklifi ləğv edildi';

  @override
  String get whiteOffersDraw => 'Ağlar heç-heçə təklif edir';

  @override
  String get blackOffersDraw => 'Qaralar heç-heçə təklif edir';

  @override
  String get whiteDeclinesDraw => 'Ağlar heç-heçə təklifini rədd edir';

  @override
  String get blackDeclinesDraw => 'Qaralar heç-heçə təklifini rədd edir';

  @override
  String get yourOpponentOffersADraw => 'Rəqibiniz heç-heçə təklif edir';

  @override
  String get accept => 'Qəbul et';

  @override
  String get decline => 'Rədd et';

  @override
  String get playingRightNow => 'Hal-hazırda oyundadır';

  @override
  String get eventInProgress => 'Hal-hazırda oynayır';

  @override
  String get finished => 'Bitdi';

  @override
  String get abortGame => 'Oyunu ləğv et';

  @override
  String get gameAborted => 'Oyun ləğv olundu';

  @override
  String get standard => 'Standart';

  @override
  String get customPosition => 'Custom position';

  @override
  String get unlimited => 'Limitsiz';

  @override
  String get mode => 'Növ';

  @override
  String get casual => 'Reytinqsiz';

  @override
  String get rated => 'Reytinqli';

  @override
  String get casualTournament => 'Reytinqsiz';

  @override
  String get ratedTournament => 'Reytinqli';

  @override
  String get thisGameIsRated => 'Bu, reytinqli oyundur';

  @override
  String get rematch => 'Revanş';

  @override
  String get rematchOfferSent => 'Revanş təklifi göndərildi';

  @override
  String get rematchOfferAccepted => 'Revanş qəbul edildi';

  @override
  String get rematchOfferCanceled => 'Revanş təklifi ləğv edildi';

  @override
  String get rematchOfferDeclined => 'Revanş təklifi rədd edildi';

  @override
  String get cancelRematchOffer => 'Revanş təklifini ləğv et';

  @override
  String get viewRematch => 'Revanş oyununu göstər';

  @override
  String get confirmMove => 'Gedişi təsdiq et';

  @override
  String get play => 'Oyna';

  @override
  String get inbox => 'Gələnlər qutusu';

  @override
  String get chatRoom => 'Söhbət otağı';

  @override
  String get loginToChat => 'Yazışmaq üçün daxil olun';

  @override
  String get youHaveBeenTimedOut => 'Yazışmadan uzaqlaşdırıldınız.';

  @override
  String get spectatorRoom => 'Tamaşaçı otağı';

  @override
  String get composeMessage => 'Məktub yaz';

  @override
  String get subject => 'Mövzu';

  @override
  String get send => 'Göndər';

  @override
  String get incrementInSeconds => 'Gediş başına saniyə';

  @override
  String get freeOnlineChess => 'Pulsuz Onlayn Şahmat';

  @override
  String get exportGames => 'Oyunları yüklə';

  @override
  String get ratingRange => 'Reytinq aralığı';

  @override
  String get thisAccountViolatedTos => 'Bu hesab Lichess İstifadə Şərtlərini pozmuşdur';

  @override
  String get openingExplorerAndTablebase => 'Debüt & endşpil bazası';

  @override
  String get takeback => 'Dala qaytarma';

  @override
  String get proposeATakeback => 'Dala qaytarma təklif et';

  @override
  String get takebackPropositionSent => 'Dala qaytarma təklifi göndərildi';

  @override
  String get takebackPropositionDeclined => 'Dala qaytarma rədd edildi';

  @override
  String get takebackPropositionAccepted => 'Dala qaytarma təklifi qəbul olundu';

  @override
  String get takebackPropositionCanceled => 'Dala qaytarma təklifi ləğv edildi';

  @override
  String get yourOpponentProposesATakeback => 'Rəqibiniz dala qaytarma təklifi edir';

  @override
  String get bookmarkThisGame => 'Bu oyunu yadda saxla';

  @override
  String get tournament => 'Turnir';

  @override
  String get tournaments => 'Turnirlər';

  @override
  String get tournamentPoints => 'Turnir xalları';

  @override
  String get viewTournament => 'Turnirə baxmaq';

  @override
  String get backToTournament => 'Turnirə qayıt';

  @override
  String get noDrawBeforeSwissLimit => 'İsveçrə turnirində 30 hərəkət oynanmazdan əvvəl heç-heçə edə bilməzsiniz.';

  @override
  String get thematic => 'Tematik';

  @override
  String yourPerfRatingIsProvisional(String param) {
    return '$param reytinqiniz müvəqqətidir';
  }

  @override
  String yourPerfRatingIsTooHigh(String param1, String param2) {
    return 'Sizin $param1 reytinqiniz ($param2) çox yüksəkdir';
  }

  @override
  String yourTopWeeklyPerfRatingIsTooHigh(String param1, String param2) {
    return 'Həftəlik $param1 reytinqiniz ($param2) çox yüksəkdir';
  }

  @override
  String yourPerfRatingIsTooLow(String param1, String param2) {
    return 'Sizin $param1 reytinqiniz ($param2) çox aşağıdır';
  }

  @override
  String ratedMoreThanInPerf(String param1, String param2) {
    return '$param2 reytinqi ≥ $param1 olmalıdır';
  }

  @override
  String ratedLessThanInPerf(String param1, String param2) {
    return '$param2 reytinqi ≤ $param1 olmalıdır';
  }

  @override
  String mustBeInTeam(String param) {
    return '$param adlı komandada olmalısan';
  }

  @override
  String youAreNotInTeam(String param) {
    return '$param komandasının üzvü deyilsiniz';
  }

  @override
  String get backToGame => 'Oyuna qayıt';

  @override
  String get siteDescription => 'Pulsuz onlayn şahmat serveridir. Təmiz bir interfeysdə şahmat oynayın. Heç bir qeydiyyat, reklam və plagin tələb olunmur. Kompüter, dostlar və ya təsadüfi rəqiblərlə şahmat oynayın.';

  @override
  String xJoinedTeamY(String param1, String param2) {
    return '$param1 $param2 komandasına üzv oldu';
  }

  @override
  String xCreatedTeamY(String param1, String param2) {
    return '$param1 $param2 komandasını yaratdı';
  }

  @override
  String get startedStreaming => 'canlı yayım başlatdı';

  @override
  String xStartedStreaming(String param) {
    return '$param canlı yayım başlatdı';
  }

  @override
  String get averageElo => 'Orta reytinq';

  @override
  String get location => 'Yer';

  @override
  String get filterGames => 'Oyunları filtrlə';

  @override
  String get reset => 'Sıfırla';

  @override
  String get apply => 'Tətbiq et';

  @override
  String get save => 'Saxla';

  @override
  String get leaderboard => 'Liderlik cədvəli';

  @override
  String get screenshotCurrentPosition => 'Cari mövqe Ekran görüntüsü';

  @override
  String get gameAsGIF => 'GIF kimi oyun';

  @override
  String get pasteTheFenStringHere => 'FEN mətnini bura yapışdırın';

  @override
  String get pasteThePgnStringHere => 'PGN mətnini bura yapışdırın';

  @override
  String get orUploadPgnFile => 'Və ya PGN faylı yükləyin';

  @override
  String get fromPosition => 'Pozisiyadan';

  @override
  String get continueFromHere => 'Buradan davam edin';

  @override
  String get toStudy => 'Çalışma';

  @override
  String get importGame => 'Oyun daxil edin';

  @override
  String get importGameExplanation => 'Göz gəzdiriləbilən bir oyun təkrarı, kompüter analizi, oyun söhbəti və paylaşılabilən bir URL əldə etmək üçün bir oyun PGN-si daxil edin.';

  @override
  String get importGameCaveat => 'Variasiyalar silinəcək. Onları saxlamaq üçün PGN-ni araşdırma vasitəsilə idxal edin.';

  @override
  String get importGameDataPrivacyWarning => 'This PGN can be accessed by the public. To import a game privately, use a study.';

  @override
  String get thisIsAChessCaptcha => 'Bu, şahmat təsdiqləmə sistemidir.';

  @override
  String get clickOnTheBoardToMakeYourMove => 'Lövhədə bir gediş edin və robot olmadığınızı təsdiq edin.';

  @override
  String get captcha_fail => 'Lütfən şahmat doğrulamasını həll edin.';

  @override
  String get notACheckmate => 'Mat deyil';

  @override
  String get whiteCheckmatesInOneMove => 'Ağlar bir gedişə mat edir';

  @override
  String get blackCheckmatesInOneMove => 'Qaralar bir gedişə mat edir';

  @override
  String get retry => 'Yenidən sına';

  @override
  String get reconnecting => 'Yenidən qoşulur';

  @override
  String get noNetwork => 'Offline';

  @override
  String get favoriteOpponents => 'Sevimli rəqiblər';

  @override
  String get follow => 'İzlə';

  @override
  String get following => 'İzlənən';

  @override
  String get unfollow => 'İzləmədən çıx';

  @override
  String followX(String param) {
    return '$param-i izləyin';
  }

  @override
  String unfollowX(String param) {
    return '$param təqibindən çıxar';
  }

  @override
  String get block => 'Blok';

  @override
  String get blocked => 'Bloklanıb';

  @override
  String get unblock => 'Blokdan çıxart';

  @override
  String get followsYou => 'Səni izləyir';

  @override
  String xStartedFollowingY(String param1, String param2) {
    return '$param1 $param2 adlı oyunçunu izləməyə başladı';
  }

  @override
  String get more => 'Daha çox';

  @override
  String get memberSince => 'Üzvlük tarixi';

  @override
  String lastSeenActive(String param) {
    return 'Aktiv $param';
  }

  @override
  String get player => 'Oyunçu';

  @override
  String get list => 'List';

  @override
  String get graph => 'Qrafik';

  @override
  String get required => 'Tələb olunur.';

  @override
  String get openTournaments => 'Mövcud turnirlər';

  @override
  String get duration => 'Vaxt';

  @override
  String get winner => 'Qalib';

  @override
  String get standing => 'Sıralama';

  @override
  String get createANewTournament => 'Yeni turnir yaradın';

  @override
  String get tournamentCalendar => 'Turnir təqvimi';

  @override
  String get conditionOfEntry => 'Qatılma şərtləri:';

  @override
  String get advancedSettings => 'Ətraflı tənzimləmələr';

  @override
  String get safeTournamentName => 'Turnir üçün çox etibarlı bir ad seçin.';

  @override
  String get inappropriateNameWarning => 'Hər hansı uyğunsuz bir ad, hesabınızın bağlanmasına yol aça bilər.';

  @override
  String get emptyTournamentName => 'Turnirə görkəmli bir şahmatçının adını vermək üçün boş buraxın.';

  @override
  String get makePrivateTournament => 'Turniri özəl et və şifrə qoyaraq müraciəti məhdudlaşdır';

  @override
  String get join => 'Qoşul';

  @override
  String get withdraw => 'Tərk et';

  @override
  String get points => 'Xallar';

  @override
  String get wins => 'Qələbələr';

  @override
  String get losses => 'Məğlubiyyətlər';

  @override
  String get createdBy => 'tərəfindən yaradılıb.';

  @override
  String get tournamentIsStarting => 'Turnir başlayır';

  @override
  String get tournamentPairingsAreNowClosed => 'Turnir qoşulmaları indi bağlıdır.';

  @override
  String standByX(String param) {
    return 'Hazır ol $param, oyunçular qoşulur!';
  }

  @override
  String get pause => 'Fasilə ver';

  @override
  String get resume => 'Davam et';

  @override
  String get youArePlaying => 'Oyundasınız!';

  @override
  String get winRate => 'Qazanma əmsalı';

  @override
  String get berserkRate => 'Berserk əmsalı';

  @override
  String get performance => 'Reytinq';

  @override
  String get tournamentComplete => 'Turnir tamamlandı';

  @override
  String get movesPlayed => 'Oynanılan gediş';

  @override
  String get whiteWins => 'Ağların qələbəsi';

  @override
  String get blackWins => 'Qaraların qələbəsi';

  @override
  String get drawRate => 'Draw rate';

  @override
  String get draws => 'Heç-heçələr';

  @override
  String nextXTournament(String param) {
    return 'Növbəti $param turniri:';
  }

  @override
  String get averageOpponent => 'Ortalama rəqib';

  @override
  String get boardEditor => 'Lövhə redaktoru';

  @override
  String get setTheBoard => 'Lövhəni tənzimlə';

  @override
  String get popularOpenings => 'Məşhur debütlər';

  @override
  String get endgamePositions => 'Oyun sonu vəziyəti';

  @override
  String chess960StartPosition(String param) {
    return 'Şahmat960 başlanğıc vəziyət: $param';
  }

  @override
  String get startPosition => 'Başlanğıc pozisiyası';

  @override
  String get clearBoard => 'Lövhəni təmizlə';

  @override
  String get loadPosition => 'Pozisiyanı yüklə';

  @override
  String get isPrivate => 'Özəl';

  @override
  String reportXToModerators(String param) {
    return '$param haqqında moderatorlara şikayət bildir.';
  }

  @override
  String profileCompletion(String param) {
    return 'Profil tamamlama: $param';
  }

  @override
  String xRating(String param) {
    return '$param reytinqi';
  }

  @override
  String get ifNoneLeaveEmpty => 'Əgər yoxdursa, boş qoyun';

  @override
  String get profile => 'Profil';

  @override
  String get editProfile => 'Profili redaktə et';

  @override
  String get realName => 'Real name';

  @override
  String get setFlair => 'Set your flair';

  @override
  String get flair => 'Flair';

  @override
  String get youCanHideFlair => 'There is a setting to hide all user flairs across the entire site.';

  @override
  String get biography => 'Özü haqqında';

  @override
  String get countryRegion => 'Country or region';

  @override
  String get thankYou => 'Təşəkkürlər!';

  @override
  String get socialMediaLinks => 'Sosial media linkləri';

  @override
  String get oneUrlPerLine => 'Hər sətirə bir URL.';

  @override
  String get inlineNotation => 'Sətirarası notasiya';

  @override
  String get makeAStudy => 'Saxlamaq və paylaşmaq üçün araşdırma aparmağı düşünün.';

  @override
  String get clearSavedMoves => 'Clear moves';

  @override
  String get previouslyOnLichessTV => 'Daha öncə Lichess TV-də';

  @override
  String get onlinePlayers => 'Onlayn oyunçular';

  @override
  String get activePlayers => 'Aktiv oyunçular';

  @override
  String get bewareTheGameIsRatedButHasNoClock => 'Ehtiyatlı olun, oyunda vaxt limiti olmasa da, reytinqlidir!';

  @override
  String get success => 'Müvəffəqiyyət';

  @override
  String get automaticallyProceedToNextGameAfterMoving => 'Gedişdən sonra növbəti oyuna avtomatik keçid';

  @override
  String get autoSwitch => 'Avtomatik dəyiş';

  @override
  String get puzzles => 'Tapmacalar';

  @override
  String get onlineBots => 'Online bots';

  @override
  String get name => 'Ad';

  @override
  String get description => 'Açıqlama';

  @override
  String get descPrivate => 'Özəl açıqlama';

  @override
  String get descPrivateHelp => 'Yalnız komanda üzvlərinin görəcəyi mətn. Təyin olunarsa, komanda üzvləri üçün olan açıqlamanı əvəz edir.';

  @override
  String get no => 'Xeyr';

  @override
  String get yes => 'Bəli';

  @override
  String get help => 'Kömək:';

  @override
  String get createANewTopic => 'Yeni mövzu yarat';

  @override
  String get topics => 'Mövzular';

  @override
  String get posts => 'Mesajlar';

  @override
  String get lastPost => 'Son Mesaj';

  @override
  String get views => 'Baxışlar';

  @override
  String get replies => 'Rəylər';

  @override
  String get replyToThisTopic => 'Mövzuya rəy yaz';

  @override
  String get reply => 'Rəy';

  @override
  String get message => 'Mesaj';

  @override
  String get createTheTopic => 'Mövzu yarat';

  @override
  String get reportAUser => 'Istifadəçi şikayət et';

  @override
  String get user => 'İstifadəçi';

  @override
  String get reason => 'Səbəb';

  @override
  String get whatIsIheMatter => 'Problem nədir?';

  @override
  String get cheat => 'Hiylə';

  @override
  String get troll => 'Trol';

  @override
  String get other => 'Digər';

  @override
  String get reportDescriptionHelp => 'Oyunun və ya oyunların linkini yapışdırın və bu istifadəçinin davranışında nəyin səhv olduğunu izah edin. Yalnız \"hiylə edirlər\" deməyin, necə bu nəticəyə gəldiyinizi bizə deyin. İngilis dilində yazıldığı təqdirdə hesabat daha sürətli işlənəcəkdir.';

  @override
  String get error_provideOneCheatedGameLink => 'Lütfən ən azı bir hiyləli oyun linki daxil edin.';

  @override
  String by(String param) {
    return '$param tərəfindən';
  }

  @override
  String importedByX(String param) {
    return 'Imported by $param';
  }

  @override
  String get thisTopicIsNowClosed => 'Mövzu bağlandı.';

  @override
  String get blog => 'Blog';

  @override
  String get notes => 'Qeydlər';

  @override
  String get typePrivateNotesHere => 'Burada xüsusi qeydlər yazın';

  @override
  String get writeAPrivateNoteAboutThisUser => 'Write a private note about this user';

  @override
  String get noNoteYet => 'No note yet';

  @override
  String get invalidUsernameOrPassword => 'Yanlış istifadəçi adı və ya şifrə';

  @override
  String get incorrectPassword => 'Yanlış şifrə';

  @override
  String get invalidAuthenticationCode => 'Etibarsız kimlik təsdiqləmə kodu';

  @override
  String get emailMeALink => 'E-poçt ilə giriş linki göndər';

  @override
  String get currentPassword => 'Cari şifrə';

  @override
  String get newPassword => 'Yeni şifrə';

  @override
  String get newPasswordAgain => 'Yeni şifrə (təkrar)';

  @override
  String get newPasswordsDontMatch => 'Yeni şifrələr uyğun gəlmir';

  @override
  String get newPasswordStrength => 'Etibarlı şifrə';

  @override
  String get clockInitialTime => 'Saatın başlanğıc vaxtı';

  @override
  String get clockIncrement => 'Vaxt artırma';

  @override
  String get privacy => 'Gizlilik';

  @override
  String get privacyPolicy => 'Gizlilik siyasəti';

  @override
  String get letOtherPlayersFollowYou => 'Digər oyunçuların səni izləməsinə icazə ver';

  @override
  String get letOtherPlayersChallengeYou => 'Digər oyunçuların sənə oyun təklif etməsinə icazə ver';

  @override
  String get letOtherPlayersInviteYouToStudy => 'Digər oyunçular səni çalışmaya dəvət edə bilsin';

  @override
  String get sound => 'Səs';

  @override
  String get none => 'Heç biri';

  @override
  String get fast => 'Sürətli';

  @override
  String get normal => 'Normal';

  @override
  String get slow => 'Yavaş';

  @override
  String get insideTheBoard => 'Lövhə daxilində';

  @override
  String get outsideTheBoard => 'Lövhə xaricində';

  @override
  String get allSquaresOfTheBoard => 'All squares of the board';

  @override
  String get onSlowGames => 'Yavaş oyunlarda';

  @override
  String get always => 'Həmişə';

  @override
  String get never => 'Heç vaxt';

  @override
  String xCompetesInY(String param1, String param2) {
    return '$param1, $param2 turnirinə qoşuldu';
  }

  @override
  String get victory => 'Qələbə';

  @override
  String get defeat => 'Məğlubiyyət';

  @override
  String victoryVsYInZ(String param1, String param2, String param3) {
    return '$param2 adlı oyunçuya qarşı $param3 oyununda $param1';
  }

  @override
  String defeatVsYInZ(String param1, String param2, String param3) {
    return '$param2 adlı oyunçuya qarşı $param3 oyununda $param1';
  }

  @override
  String drawVsYInZ(String param1, String param2, String param3) {
    return '$param2 adlı oyunçuya qarşı $param3 oyununda $param1';
  }

  @override
  String get timeline => 'Xronologiya';

  @override
  String get starting => 'Başlayır:';

  @override
  String get allInformationIsPublicAndOptional => 'Bütün məlumatlar hər kəsə açıq və istəyə bağlıdır.';

  @override
  String get biographyDescription => 'Özünüz haqqında danışın, maraqlarınız, şahmatda nəyi bəyəndiyiniz, sevimli debütləriniz, oyunçular və s...';

  @override
  String get listBlockedPlayers => 'Blok edilmiş şəxslərin siyahısı';

  @override
  String get human => 'İnsan';

  @override
  String get computer => 'Kompüter';

  @override
  String get side => 'Tərəf';

  @override
  String get clock => 'Saat';

  @override
  String get opponent => 'Rəqib';

  @override
  String get learnMenu => 'Öyrən';

  @override
  String get studyMenu => 'Çalışma';

  @override
  String get practice => 'Məşq';

  @override
  String get community => 'Cəmiyyət';

  @override
  String get tools => 'Alətlər';

  @override
  String get increment => 'Artım';

  @override
  String get error_unknown => 'Invalid value';

  @override
  String get error_required => 'Bu xananın doldurulması məcburidir';

  @override
  String get error_email => 'This email address is invalid';

  @override
  String get error_email_acceptable => 'This email address is not acceptable. Please double-check it, and try again.';

  @override
  String get error_email_unique => 'Email address invalid or already taken';

  @override
  String get error_email_different => 'This is already your email address';

  @override
  String error_minLength(String param) {
    return 'Must be at least $param characters long';
  }

  @override
  String error_maxLength(String param) {
    return 'Must be at most $param characters long';
  }

  @override
  String error_min(String param) {
    return 'Must be at least $param';
  }

  @override
  String error_max(String param) {
    return 'Must be at most $param';
  }

  @override
  String ifRatingIsPlusMinusX(String param) {
    return 'Əgər reytinq ± $param olarsa';
  }

  @override
  String get ifRegistered => 'If registered';

  @override
  String get onlyExistingConversations => 'Yalnız mövcud söhbətlər';

  @override
  String get onlyFriends => 'Yalnız dostlar';

  @override
  String get menu => 'Menyu';

  @override
  String get castling => 'Qalaqurma';

  @override
  String get whiteCastlingKingside => 'Ağlar O-O';

  @override
  String get blackCastlingKingside => 'Qaralar O-O';

  @override
  String tpTimeSpentPlaying(String param) {
    return 'Oynamağa sərf olunmuş zaman: $param';
  }

  @override
  String get watchGames => 'Oyunları izlə';

  @override
  String tpTimeSpentOnTV(String param) {
    return 'TV-də keçirilimiş zaman: $param';
  }

  @override
  String get watch => 'İzlə';

  @override
  String get videoLibrary => 'Video kitabxana';

  @override
  String get streamersMenu => 'Yayımçılar';

  @override
  String get mobileApp => 'Mobil Tətbiq';

  @override
  String get webmasters => 'Vebmasterlər';

  @override
  String get about => 'Haqqında';

  @override
  String aboutX(String param) {
    return '$param haqqında';
  }

  @override
  String xIsAFreeYLibreOpenSourceChessServer(String param1, String param2) {
    return '$param1 ödənişsiz ($param2), sərbəst, reklamsız, açıq mənbəli şahmat serveridir.';
  }

  @override
  String get really => 'həqiqətən';

  @override
  String get contribute => 'Töhfə ver';

  @override
  String get termsOfService => 'Xidmət şərtləri';

  @override
  String get sourceCode => 'Mənbə kodu';

  @override
  String get simultaneousExhibitions => 'Sinxron seanslar';

  @override
  String get host => 'Ev sahibi';

  @override
  String hostColorX(String param) {
    return 'Ev sahibi rəngi: $param';
  }

  @override
  String get yourPendingSimuls => 'Your pending simuls';

  @override
  String get createdSimuls => 'Yeni yaradılmış sinxron seanslar';

  @override
  String get hostANewSimul => 'Yeni sinxron seansa ev sahibliyi edin';

  @override
  String get signUpToHostOrJoinASimul => 'Sign up to host or join a simul';

  @override
  String get noSimulFound => 'Sinxron seans tapılmadı';

  @override
  String get noSimulExplanation => 'Bu sinxron seans mövcud deyil.';

  @override
  String get returnToSimulHomepage => 'Sinxron seansın ana səhifəsinə qayıdın';

  @override
  String get aboutSimul => 'Sinxron seanslar, bir oyunçunun bir neçə oyunçuyla eyni zamanda üz-üzə gəlməsidir.';

  @override
  String get aboutSimulImage => '50 rəqib içindən, Fischer 47 oyunu qazandı, 2 heç-heçə etdi, və 1 dəfə məğlub oldu.';

  @override
  String get aboutSimulRealLife => 'Konsept real dünyadan götürülmüşdür. Real həyatda, sinxron seans edən ev sahibi bir masadan digərinə keçərək bir-bir gedişlər edir.';

  @override
  String get aboutSimulRules => 'Sinxron seansda iştirak edən hər bir oyunçu, ağlarla oynayan ev sahibi ilk gedişi etdikdən sonra oyuna başlayır. Seans bütün oyunlar başa çatdıqda bitir.';

  @override
  String get aboutSimulSettings => 'Sinxron seanslar adətən reytinqsizdir. Revanşlar, dala qaytarmalar və əlavə vaxt qadağan edilmişdir.';

  @override
  String get create => 'Yarat';

  @override
  String get whenCreateSimul => 'Bir Seans yaratdığınızda eyni anda bir neçə oyunçu ilə oynamağa başlayırsınız.';

  @override
  String get simulVariantsHint => 'Əgər bir neçə oyun variantı seçsəniz, hər bir oyunçu oynamaq istədiyi variantı seçə biləcək.';

  @override
  String get simulClockHint => 'Fişer Saatını quraşdırma. Daha çox oyunçu götürsəniz, daha çox vaxta ehtiyacınız ola bilər.';

  @override
  String get simulAddExtraTime => 'Sinxron seansla başa çıxmaq üçün öz saatınıza əlavə vaxtlar artıra bilərsiniz.';

  @override
  String get simulHostExtraTime => 'Ev sahibinin əlavə vaxtı';

  @override
  String get simulAddExtraTimePerPlayer => 'Add initial time to your clock for each player joining the simul.';

  @override
  String get simulHostExtraTimePerPlayer => 'Host extra clock time per player';

  @override
  String get lichessTournaments => 'Lichess turnirləri';

  @override
  String get tournamentFAQ => 'Arena turnirinin TSS-i';

  @override
  String get timeBeforeTournamentStarts => 'Turnir başlamasına qalan vaxt';

  @override
  String get averageCentipawnLoss => 'Ortalama santipiyada itkisi';

  @override
  String get accuracy => 'Accuracy';

  @override
  String get keyboardShortcuts => 'Klaviatura qısayolları';

  @override
  String get keyMoveBackwardOrForward => 'İrəliyə/arxaya gediş';

  @override
  String get keyGoToStartOrEnd => 'Əvvələ/sona get';

  @override
  String get keyCycleSelectedVariation => 'Cycle selected variation';

  @override
  String get keyShowOrHideComments => 'Rəyləri göstər/gizlə';

  @override
  String get keyEnterOrExitVariation => 'giriş/çıxış variasiyası';

  @override
  String get keyRequestComputerAnalysis => 'Request computer analysis, Learn from your mistakes';

  @override
  String get keyNextLearnFromYourMistakes => 'Next (Learn from your mistakes)';

  @override
  String get keyNextBlunder => 'Next blunder';

  @override
  String get keyNextMistake => 'Next mistake';

  @override
  String get keyNextInaccuracy => 'Next inaccuracy';

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
  String get newTournament => 'Yeni turnir';

  @override
  String get tournamentHomeTitle => 'Müxtəlif zaman kontrollu və variantlı şahmat turnirləri';

  @override
  String get tournamentHomeDescription => 'Sürətli şahmat turnirləri oyna! Rəsmi təyin olunmuş turnirlərə qoşul və ya özün turnir yarat. Bullet, Blitz, Klassik, Chess960, King of the Hill, Threecheck və digər sonsuz şahmat əyləncəsi.';

  @override
  String get tournamentNotFound => 'Turnir tapılmadı';

  @override
  String get tournamentDoesNotExist => 'Bu turnir mövcud deyil';

  @override
  String get tournamentMayHaveBeenCanceled => 'Əgər turnir başlamadan öncə bütün oyunçular turniri tərk edərsə, turnir ləğv oluna bilər.';

  @override
  String get returnToTournamentsHomepage => 'Turnirin ana səhifəsinə qayıt';

  @override
  String weeklyPerfTypeRatingDistribution(String param) {
    return 'Həftəlik $param reytinq əyrisi';
  }

  @override
  String yourPerfTypeRatingIsRating(String param1, String param2) {
    return 'Sənin $param1 reytinqin $param2-dir';
  }

  @override
  String youAreBetterThanPercentOfPerfTypePlayers(String param1, String param2) {
    return 'Sən $param1 oyunçulardan $param2 daha yaxşısan.';
  }

  @override
  String userIsBetterThanPercentOfPerfTypePlayers(String param1, String param2, String param3) {
    return '$param1 $param3 oyunçularından $param2 daha yaxşıdır.';
  }

  @override
  String betterThanPercentPlayers(String param1, String param2) {
    return 'Better than $param1 of $param2 players';
  }

  @override
  String youDoNotHaveAnEstablishedPerfTypeRating(String param) {
    return 'Sən müəyyən olunmuş $param reytinqinə malik deyilsən.';
  }

  @override
  String get yourRating => 'Sizin reytinq';

  @override
  String get cumulative => 'Məcmu';

  @override
  String get glicko2Rating => 'Glicko-2 reytinqi';

  @override
  String get checkYourEmail => 'E-poçtunu yoxla';

  @override
  String get weHaveSentYouAnEmailClickTheLink => 'Biz sənə e-poçt göndərdik. Hesabını aktivləşdirmək üçün linkə kliklə.';

  @override
  String get ifYouDoNotSeeTheEmailCheckOtherPlaces => 'Əgər e-poçtu görmürsünzsə, onun ola biləcəyi digər yerləri, məsələn, zibil qutusu, spam, sosial və digər qovluqları nəzərdən keçirin.';

  @override
  String weHaveSentYouAnEmailTo(String param) {
    return 'Biz $param ünvanına e-poçt göndərdik. Şifrəni yeniləmək üçün e-poçtunuzdakı linkə klikləyin.';
  }

  @override
  String byRegisteringYouAgreeToBeBoundByOur(String param) {
    return 'Qeydiyyatdan keçməklə siz, bizim $param ilə razılaşırsınız.';
  }

  @override
  String readAboutOur(String param) {
    return '$param haqqında oxuyun.';
  }

  @override
  String get networkLagBetweenYouAndLichess => 'Siz və lichess arasında şəbəkə gecikməsi';

  @override
  String get timeToProcessAMoveOnLichessServer => 'Lichess serverində gedişi emal etmə zamanı';

  @override
  String get downloadAnnotated => 'Annotasiyanı endir.';

  @override
  String get downloadRaw => 'Annotasiyasız endir';

  @override
  String get downloadImported => 'Daxil edilmiş oyunu endir';

  @override
  String get crosstable => 'Çarpaz cədvəl';

  @override
  String get youCanAlsoScrollOverTheBoardToMoveInTheGame => 'Bundan başqa mouse təkəri vasitəsilə də gediş etmək olar.';

  @override
  String get scrollOverComputerVariationsToPreviewThem => 'Kompüter variantlarına baxmaq üçün yuxarı sürüşdür.';

  @override
  String get analysisShapesHowTo => 'Lövhədə çevrə və ya oxlar çəkmək üçün shift+sol klik və ya sağ klikə toxunun.';

  @override
  String get letOtherPlayersMessageYou => 'Digər oyunçuların sizə mesaj göndərməsinə icazə ver';

  @override
  String get receiveForumNotifications => 'Receive notifications when mentioned in the forum';

  @override
  String get shareYourInsightsData => 'Şahmat oyun məlumatlarınızı paylaşın';

  @override
  String get withNobody => 'Heç kim ilə';

  @override
  String get withFriends => 'Dostlar ilə';

  @override
  String get withEverybody => 'Hər kəs ilə';

  @override
  String get kidMode => 'Uşaq rejimi';

  @override
  String get kidModeIsEnabled => 'Kid mode is enabled.';

  @override
  String get kidModeExplanation => 'Bu təhlükəsizliklə bağlıdır. Uşaq rejimində bütün sayt əlaqələri deaktivdir. Uşaqlarınız və məktəb şagirdləriniz üçün, onları digər internet istifadəçilərindən qorumaq üçün bunu aktiv edin.';

  @override
  String inKidModeTheLichessLogoGetsIconX(String param) {
    return 'Uşaq rejimində, Lichess loqosu $param işarəsini alır, beləliklə uşaqlarınızın təhlükəsiz olduğunu bilirsiniz.';
  }

  @override
  String get askYourChessTeacherAboutLiftingKidMode => 'Your account is managed. Ask your chess teacher about lifting kid mode.';

  @override
  String get enableKidMode => 'Uşaq rejimini aktivləşdir';

  @override
  String get disableKidMode => 'Uşaq rejimini deaktiv et';

  @override
  String get security => 'Təhlükəsizlik';

  @override
  String get sessions => 'Sessions';

  @override
  String get revokeAllSessions => 'bütün sessiyaları ləğv et';

  @override
  String get playChessEverywhere => 'Şahmatı hər yerdə oyna';

  @override
  String get asFreeAsLichess => 'Lichess kimi azad';

  @override
  String get builtForTheLoveOfChessNotMoney => 'Pula görə deyil, şahmat sevgisinə görə yaradılmışdır';

  @override
  String get everybodyGetsAllFeaturesForFree => 'Hər kəs bütün özəllikləri pulsuz əldə edir';

  @override
  String get zeroAdvertisement => 'Sıfır reklam';

  @override
  String get fullFeatured => 'Tam özəllikli';

  @override
  String get phoneAndTablet => 'Telefon və tablet';

  @override
  String get bulletBlitzClassical => 'Bullet, blitz, klassik';

  @override
  String get correspondenceChess => 'Yazışmalı şahmat';

  @override
  String get onlineAndOfflinePlay => 'Onlayn və oflayn oyun';

  @override
  String get viewTheSolution => 'Həllə bax';

  @override
  String get followAndChallengeFriends => 'Dostlarını izlə və oyuna çağır';

  @override
  String get gameAnalysis => 'Oyun təhlili';

  @override
  String xHostsY(String param1, String param2) {
    return '$param1 ev sahibi: $param2';
  }

  @override
  String xJoinsY(String param1, String param2) {
    return '$param1 qoşuldu: $param2';
  }

  @override
  String xLikesY(String param1, String param2) {
    return '$param1 bəyəndi: $param2';
  }

  @override
  String get quickPairing => 'Sürətli qoşulma';

  @override
  String get lobby => 'Lobbi';

  @override
  String get anonymous => 'Anonim';

  @override
  String yourScore(String param) {
    return 'Hesab: $param';
  }

  @override
  String get language => 'Dil';

  @override
  String get background => 'Arxa fon';

  @override
  String get light => 'Yüngül';

  @override
  String get dark => 'Qaranlıq';

  @override
  String get transparent => 'Şəffaf';

  @override
  String get deviceTheme => 'Device theme';

  @override
  String get backgroundImageUrl => 'Arxa fon rəsm URL-i:';

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
  String get pieceSet => 'Fiqur seti';

  @override
  String get embedInYourWebsite => 'Saytınıza yerləşdirin';

  @override
  String get usernameAlreadyUsed => 'Bu istifadəçi adı artıq istifadə olunur, lütfən başqasını sınayın.';

  @override
  String get usernamePrefixInvalid => 'İstifadəçi adı hərflə başlamalıdır.';

  @override
  String get usernameSuffixInvalid => 'İstifadəçi adı hərf və ya rəqəmlə bitməlidir.';

  @override
  String get usernameCharsInvalid => 'İstifadəçi adı yalnız hərflər, rəqəmlər, alt xətlər və tirelərdən ibarət olmalıdır. Ardıcıl alt xətlər və tire işarələrinə icazə verilmir.';

  @override
  String get usernameUnacceptable => 'Bu istifadəçi adı qəbuledilməzdir.';

  @override
  String get playChessInStyle => 'Şahmatı tərz ilə oyna';

  @override
  String get chessBasics => 'Şahmatın təməl prinsipləri';

  @override
  String get coaches => 'Məşqçilər';

  @override
  String get invalidPgn => 'Yanlış PGN';

  @override
  String get invalidFen => 'Yanlış FEN';

  @override
  String get custom => 'Özəl';

  @override
  String get notifications => 'Bildirişlər';

  @override
  String notificationsX(String param1) {
    return 'Notifications: $param1';
  }

  @override
  String perfRatingX(String param) {
    return 'Reytinq: $param';
  }

  @override
  String get practiceWithComputer => 'Kompüterlə məşq';

  @override
  String anotherWasX(String param) {
    return 'Digər variant: $param';
  }

  @override
  String bestWasX(String param) {
    return 'Ən yaxşı gediş: $param';
  }

  @override
  String get youBrowsedAway => 'Əlaqə kəsildi';

  @override
  String get resumePractice => 'Məşqə davam edin';

  @override
  String get drawByFiftyMoves => 'The game has been drawn by the fifty move rule.';

  @override
  String get theGameIsADraw => 'Oyun heç-heçədir.';

  @override
  String get computerThinking => 'Kompüter fikirləşir ...';

  @override
  String get seeBestMove => 'Ən yaxşı gedişə bax';

  @override
  String get hideBestMove => 'Ən yaxşı gedişi gizlət';

  @override
  String get getAHint => 'İpucu Al';

  @override
  String get evaluatingYourMove => 'Gedişiniz dəyərləndirilir ...';

  @override
  String get whiteWinsGame => 'Ağlar qazandı';

  @override
  String get blackWinsGame => 'Qaralar qazandı';

  @override
  String get learnFromYourMistakes => 'Səhvlərinizdən öyrənin';

  @override
  String get learnFromThisMistake => 'Bu səhvdən öyrən';

  @override
  String get skipThisMove => 'Bu gedişi keç';

  @override
  String get next => 'Növbəti';

  @override
  String xWasPlayed(String param) {
    return '$param oynanıldı';
  }

  @override
  String get findBetterMoveForWhite => 'Ağlar üçün daha yaxşı gedişi tapın';

  @override
  String get findBetterMoveForBlack => 'Qaralar üçün daha yaxşı gedişi tapın';

  @override
  String get resumeLearning => 'Öyrənməyə davam';

  @override
  String get youCanDoBetter => 'Daha yaxşısını bacara bilərsən';

  @override
  String get tryAnotherMoveForWhite => 'Ağlar üçün başqa bir gediş yoxlayın';

  @override
  String get tryAnotherMoveForBlack => 'Qaralar üçün başqa bir gediş yoxlayın';

  @override
  String get solution => 'Həll';

  @override
  String get waitingForAnalysis => 'Analiz üçün gözlənilir';

  @override
  String get noMistakesFoundForWhite => 'Ağlar üçün səhv tapılmadı';

  @override
  String get noMistakesFoundForBlack => 'Qaralar üçün səhv tapılmadı';

  @override
  String get doneReviewingWhiteMistakes => 'Ağların səhvləri nəzərdən keçirildi';

  @override
  String get doneReviewingBlackMistakes => 'Qaraların səhvləri nəzərdən keçirildi';

  @override
  String get doItAgain => 'Təkrar et';

  @override
  String get reviewWhiteMistakes => 'Ağların səhvlərini nəzərdən keçirin';

  @override
  String get reviewBlackMistakes => 'Qaraların səhvlərini nəzərdən keçirin';

  @override
  String get advantage => 'Üstünlük';

  @override
  String get opening => 'Debüt';

  @override
  String get middlegame => 'Mittelşpil';

  @override
  String get endgame => 'Endşpil';

  @override
  String get conditionalPremoves => 'Şərtli öngediş';

  @override
  String get addCurrentVariation => 'Cari variasiyanı əlavə et';

  @override
  String get playVariationToCreateConditionalPremoves => 'Şərtli öngedişlər etmək üçün bir variasiya oynayın';

  @override
  String get noConditionalPremoves => 'Şərtli öngedişsiz';

  @override
  String playX(String param) {
    return '$param oyna';
  }

  @override
  String get showUnreadLichessMessage => 'You have received a private message from Lichess.';

  @override
  String get clickHereToReadIt => 'Click here to read it';

  @override
  String get sorry => 'Təəssüf :(';

  @override
  String get weHadToTimeYouOutForAWhile => 'Sizi bir müddətlik oyunlardan xaric etmək məcburiyyətində qaldıq.';

  @override
  String get why => 'Niyə?';

  @override
  String get pleasantChessExperience => 'Biz hər kəs üçün xoş bir şahmat təcrübəsi təmin etməyi hədəfləyirik.';

  @override
  String get goodPractice => 'Bunun üçün bütün oyunçuların düzgün təcrübəni izləməsini təmin etməliyik.';

  @override
  String get potentialProblem => 'Potensial bir problem aşkar edildikdə, bu mesajı göstəririk.';

  @override
  String get howToAvoidThis => 'Bunun qarşısını necə almaq olar?';

  @override
  String get playEveryGame => 'Başladığınız hər oyunu oynayın.';

  @override
  String get tryToWin => 'Oynadığınız hər oyunda qalib gəlməyə (və ya heç olmasa heç-heçə etməyə) çalışın.';

  @override
  String get resignLostGames => 'İtirəcəyiniz oyunları tərk edin(vaxtın bitməsinə imkan verməyin).';

  @override
  String get temporaryInconvenience => 'Müvəqqəti narahatlığa görə üzr istəyirik,';

  @override
  String get wishYouGreatGames => 'və sizə lichess.org saytında əla oyunlar arzulayırıq.';

  @override
  String get thankYouForReading => 'Oxuduğunuz üçün təşəkkür edirik!';

  @override
  String get lifetimeScore => 'Toplam hesab';

  @override
  String get currentMatchScore => 'Cari matç hesabı';

  @override
  String get agreementAssistance => 'Razıyam ki, heç vaxt oyunlarım zamanı (şahmat kompüterindən, kitabdan, məlumat bazasından və ya başqa bir şəxsdən) kömək almayacağam.';

  @override
  String get agreementNice => 'Həmişə digər oyunçulara hörmətlə yanaşacağımla razıyam.';

  @override
  String agreementMultipleAccounts(String param) {
    return 'I agree that I will not create multiple accounts (except for the reasons stated in the $param).';
  }

  @override
  String get agreementPolicy => 'Bütün Lichess qaydalarına riayət edəcəyimlə razıyam.';

  @override
  String get searchOrStartNewDiscussion => 'Axtarış edin və ya yeni söhbətə başlayın';

  @override
  String get edit => 'Redaktə et';

  @override
  String get bullet => 'Bullet';

  @override
  String get blitz => 'İldırım';

  @override
  String get rapid => 'Rapid';

  @override
  String get classical => 'Klassik';

  @override
  String get ultraBulletDesc => 'İnanılmaz sürətli oyunlar: 30 saniyədən az';

  @override
  String get bulletDesc => 'Çox sürətli oyunlar: 3 dəqiqədən az';

  @override
  String get blitzDesc => 'Sürətli oyunlar: 3-8 dəqiqə';

  @override
  String get rapidDesc => 'Rapid oyunlar: 8-25 dəqiqə';

  @override
  String get classicalDesc => 'Klassik oyunlar: 25 dəqiqə və daha artıq';

  @override
  String get correspondenceDesc => 'Yazışmalı oyunlar: gediş başına bir və ya bir neçə gün';

  @override
  String get puzzleDesc => 'Şahmat taktika məşqçisi';

  @override
  String get important => 'Önəmli';

  @override
  String yourQuestionMayHaveBeenAnswered(String param1) {
    return 'Sizin sualınız $param1 cavablanmış ola bilər.';
  }

  @override
  String get inTheFAQ => 'T.S.S bölməsində.';

  @override
  String toReportSomeoneForCheatingOrBadBehavior(String param1) {
    return 'Bir istifadəçini aldatma və ya pis davranışa görə bildirmək üçün, $param1';
  }

  @override
  String get useTheReportForm => 'şikayət formundan istifadə edin';

  @override
  String toRequestSupport(String param1) {
    return 'Dəstək almaq üçün, $param1';
  }

  @override
  String get tryTheContactPage => 'əlaqə səhifəsindən istifadə edin';

  @override
  String makeSureToRead(String param1) {
    return 'Make sure to read $param1';
  }

  @override
  String get theForumEtiquette => 'the forum etiquette';

  @override
  String get thisTopicIsArchived => 'Bu mövzu arxivləşdirilib və artıq cavab verilə bilməz.';

  @override
  String joinTheTeamXToPost(String param1) {
    return 'Bu forumda yazı göndərmək üçün, $param1 komandasına qoşulun';
  }

  @override
  String teamNamedX(String param1) {
    return '$param1 komandası';
  }

  @override
  String get youCannotPostYetPlaySomeGames => 'Hələ forumlarda yazı göndərə bilməzsiniz. Biraz oyun oynayın!';

  @override
  String get subscribe => 'Abunə ol';

  @override
  String get unsubscribe => 'Abunəlikdən çıxın';

  @override
  String mentionedYouInX(String param1) {
    return 'erwähnte dich in \"$param1\".';
  }

  @override
  String xMentionedYouInY(String param1, String param2) {
    return '$param1 səni \"$param2\"-da səni qeyd etdi.';
  }

  @override
  String invitedYouToX(String param1) {
    return 'səni \"$param1\"-ə dəvət etdi.';
  }

  @override
  String xInvitedYouToY(String param1, String param2) {
    return '$param1 səni \"$param2\"-ə dəvət etdi.';
  }

  @override
  String get youAreNowPartOfTeam => 'Siz artıq komandanın üzvüsünüz.';

  @override
  String youHaveJoinedTeamX(String param1) {
    return '\"$param1\"-yə qatıldın.';
  }

  @override
  String get someoneYouReportedWasBanned => 'Şikayət etdiyiniz şəxsin hesabı ban edilmişdir';

  @override
  String get congratsYouWon => 'Təbriklər, siz qalib gəldiniz!';

  @override
  String gameVsX(String param1) {
    return '$param1-ya qarşı oyun';
  }

  @override
  String resVsX(String param1, String param2) {
    return '$param1 vs $param2';
  }

  @override
  String get lostAgainstTOSViolator => '\"Liches\" xidmət şərtlərini pozana qarşı uduzdun';

  @override
  String refundXpointsTimeControlY(String param1, String param2) {
    return 'Geri qaytarma: \"$param2\"-də $param1 reytinq xalı.';
  }

  @override
  String get timeAlmostUp => 'Vaxt bitmək üzrədir!';

  @override
  String get clickToRevealEmailAddress => '[E-poçt ünvanını görmək üçün klikləyin]';

  @override
  String get download => 'Endir';

  @override
  String get coachManager => 'Coach manager';

  @override
  String get streamerManager => 'Streamer manager';

  @override
  String get cancelTournament => 'Müsabiqəni ləğv et';

  @override
  String get tournDescription => 'Turnir açıqlaması';

  @override
  String get tournDescriptionHelp => 'Anything special you want to tell the participants? Try to keep it short. Markdown links are available: [name](https://url)';

  @override
  String get ratedFormHelp => 'Games are rated and impact players ratings';

  @override
  String get onlyMembersOfTeam => 'Yalnız qrup üzvləri';

  @override
  String get noRestriction => 'Məhdudiyyət yoxdur';

  @override
  String get minimumRatedGames => 'Minimum reytinqli oyunlar';

  @override
  String get minimumRating => 'Minimum reyting';

  @override
  String get maximumWeeklyRating => 'Maksimum həftəlik reyting';

  @override
  String positionInputHelp(String param) {
    return 'Paste a valid FEN to start every game from a given position.\nIt only works for standard games, not with variants.\nYou can use the $param to generate a FEN position, then paste it here.\nLeave empty to start games from the normal initial position.';
  }

  @override
  String get cancelSimul => 'Simulu ləğv et';

  @override
  String get simulHostcolor => 'Host colour for each game';

  @override
  String get estimatedStart => 'Estimated start time';

  @override
  String simulFeatured(String param) {
    return 'Feature on $param';
  }

  @override
  String simulFeaturedHelp(String param) {
    return 'Show your simul to everyone on $param. Disable for private simuls.';
  }

  @override
  String get simulDescription => 'Simul description';

  @override
  String get simulDescriptionHelp => 'Anything you want to tell the participants?';

  @override
  String markdownAvailable(String param) {
    return '$param is available for more advanced syntax.';
  }

  @override
  String get embedsAvailable => 'Paste a game URL or a study chapter URL to embed it.';

  @override
  String get inYourLocalTimezone => 'In your own local timezone';

  @override
  String get tournChat => 'Turnir mesajı';

  @override
  String get noChat => 'Söhbətsiz';

  @override
  String get onlyTeamLeaders => 'Yalnız qrup lideri';

  @override
  String get onlyTeamMembers => 'Ancaq klub üzvləri';

  @override
  String get navigateMoveTree => 'Navigate the move tree';

  @override
  String get mouseTricks => 'Mouse tricks';

  @override
  String get toggleLocalAnalysis => 'Toggle local computer analysis';

  @override
  String get toggleAllAnalysis => 'Toggle all computer analysis';

  @override
  String get playComputerMove => 'Ən yaxşı komputer gedişlərini oyna';

  @override
  String get analysisOptions => 'Analysis options';

  @override
  String get focusChat => 'Focus chat';

  @override
  String get showHelpDialog => 'Show this help dialog';

  @override
  String get reopenYourAccount => 'Reopen your account';

  @override
  String get closedAccountChangedMind => 'If you closed your account, but have since changed your mind, you get one chance of getting your account back.';

  @override
  String get onlyWorksOnce => 'This will only work once.';

  @override
  String get cantDoThisTwice => 'If you close your account a second time, there will be no way of recovering it.';

  @override
  String get emailAssociatedToaccount => 'Email address associated to the account';

  @override
  String get sentEmailWithLink => 'We\'ve sent you an email with a link.';

  @override
  String get tournamentEntryCode => 'Turnirə giriş kodu';

  @override
  String get hangOn => 'Hang on!';

  @override
  String gameInProgress(String param) {
    return 'You have a game in progress with $param.';
  }

  @override
  String get abortTheGame => 'Abort the game';

  @override
  String get resignTheGame => 'Resign the game';

  @override
  String get youCantStartNewGame => 'You can\'t start a new game until this one is finished.';

  @override
  String get since => 'Since';

  @override
  String get until => 'Until';

  @override
  String get lichessDbExplanation => 'Rated games played on Lichess';

  @override
  String get switchSides => 'Switch sides';

  @override
  String get closingAccountWithdrawAppeal => 'Closing your account will withdraw your appeal';

  @override
  String get ourEventTips => 'Our tips for organising events';

  @override
  String get instructions => 'Instructions';

  @override
  String get showMeEverything => 'Show me everything';

  @override
  String get lichessPatronInfo => 'Lichess is a charity and entirely free/libre open source software.\nAll operating costs, development, and content are funded solely by user donations.';

  @override
  String get nothingToSeeHere => 'Nothing to see here at the moment.';

  @override
  String opponentLeftCounter(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Rəqibiniz oyunu tərk etdi. $count saniyə sonra qələbə tələb edə bilərsiniz.',
      one: 'Rəqibiniz oyunu tərk etdi. $count saniyə sonra qələbə tələb edə bilərsiniz.',
    );
    return '$_temp0';
  }

  @override
  String mateInXHalfMoves(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count yarımgedişə mat',
      one: '$count yarımgedişə mat',
    );
    return '$_temp0';
  }

  @override
  String nbBlunders(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count kobud səhv',
      one: '$count kobud səhv',
    );
    return '$_temp0';
  }

  @override
  String nbMistakes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count səhv',
      one: '$count səhv',
    );
    return '$_temp0';
  }

  @override
  String nbInaccuracies(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count qeyri-dəqiqlik',
      one: '$count qeyri-dəqiqlik',
    );
    return '$_temp0';
  }

  @override
  String nbPlayers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count oyunçu',
      one: '$count oyunçu',
    );
    return '$_temp0';
  }

  @override
  String nbGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count oyun',
      one: '$count oyun',
    );
    return '$_temp0';
  }

  @override
  String ratingXOverYGames(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$param2 oyunlardan çox $count reytinqi',
      one: '$param2 oyunundan çox $count reytinqi',
    );
    return '$_temp0';
  }

  @override
  String nbBookmarks(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count yadda saxlanılmış oyun',
      one: '$count yadda saxlanılmış oyun',
    );
    return '$_temp0';
  }

  @override
  String nbDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count gün',
      one: '$count gün',
    );
    return '$_temp0';
  }

  @override
  String nbHours(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count saat',
      one: '$count saat',
    );
    return '$_temp0';
  }

  @override
  String nbMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count dəqiqələr',
      one: '$count dəqiqə',
    );
    return '$_temp0';
  }

  @override
  String rankIsUpdatedEveryNbMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Sıralama hər $count dəqiqədə bir yenilənir',
      one: 'Sıralama hər $count dəqiqədə bir yenilənir',
    );
    return '$_temp0';
  }

  @override
  String nbPuzzles(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count məsələ',
      one: '$count tapmaca',
    );
    return '$_temp0';
  }

  @override
  String nbGamesWithYou(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count sizinlə oynadığı oyun sayı',
      one: '$count sizinlə oynadığı oyun sayı',
    );
    return '$_temp0';
  }

  @override
  String nbRated(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count reytinqli',
      one: '$count reytinqli',
    );
    return '$_temp0';
  }

  @override
  String nbWins(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count qələbə',
      one: '$count qələbə',
    );
    return '$_temp0';
  }

  @override
  String nbLosses(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count məğlubiyyət',
      one: '$count məğlubiyyət',
    );
    return '$_temp0';
  }

  @override
  String nbDraws(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count heç-heçə',
      one: '$count heç-heçə',
    );
    return '$_temp0';
  }

  @override
  String nbPlaying(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count oynayır',
      one: '$count oynanılır',
    );
    return '$_temp0';
  }

  @override
  String giveNbSeconds(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count saniyə ver',
      one: '$count saniyə ver',
    );
    return '$_temp0';
  }

  @override
  String nbTournamentPoints(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count turnir xalı',
      one: '$count turnir xalı',
    );
    return '$_temp0';
  }

  @override
  String nbStudies(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count çalışma',
      one: '$count çalışma',
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
      other: '≥ $count reytinqli oyun',
      one: '≥ $count reytinqli oyun',
    );
    return '$_temp0';
  }

  @override
  String moreThanNbPerfRatedGames(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '≥ $count reytinqli $param2 oyunu',
      one: '≥ $count reytinqli $param2 oyunu',
    );
    return '$_temp0';
  }

  @override
  String needNbMorePerfGames(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count dənə daha reytinqli $param2 oyunu oynamalısınız',
      one: '$count dənə daha reytinqli $param2 oyunu oynamalısınız',
    );
    return '$_temp0';
  }

  @override
  String needNbMoreGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count dənə daha reytinqli  oynamanız gərəklidir',
      one: '$count dənə daha reytinqli oyun oynamalısınız',
    );
    return '$_temp0';
  }

  @override
  String nbImportedGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count oyun daxil edildi',
      one: '$count oyun daxil edildi',
    );
    return '$_temp0';
  }

  @override
  String nbFriendsOnline(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count dost onlayn',
      one: '$count onlayn dost',
    );
    return '$_temp0';
  }

  @override
  String nbFollowers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count izləyici',
      one: '$count izləyici',
    );
    return '$_temp0';
  }

  @override
  String nbFollowing(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count izlənilən',
      one: '$count izləyici',
    );
    return '$_temp0';
  }

  @override
  String lessThanNbMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count dəqiqədən daha az',
      one: '$count dəqiqədən daha az',
    );
    return '$_temp0';
  }

  @override
  String nbGamesInPlay(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count oyun oynanılır',
      one: '$count oyun oynanılır',
    );
    return '$_temp0';
  }

  @override
  String maximumNbCharacters(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Ən çox: $count xarakter',
      one: 'Ən çox: $count simvol.',
    );
    return '$_temp0';
  }

  @override
  String blocks(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count şəxs əngəlləndi',
      one: '$count şəxs əngəlləndi',
    );
    return '$_temp0';
  }

  @override
  String nbForumPosts(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Forum Mesajları',
      one: '$count forum mesajları',
    );
    return '$_temp0';
  }

  @override
  String nbPerfTypePlayersThisWeek(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Bu həftə $count $param2 oyunçusu.',
      one: 'Bu həftə $count $param2 oyunçusu.',
    );
    return '$_temp0';
  }

  @override
  String availableInNbLanguages(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count dildə mövcuddur!',
      one: '$count dildə mövcuddur!',
    );
    return '$_temp0';
  }

  @override
  String nbSecondsToPlayTheFirstMove(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'ilk gedişi etmək üçün son $count saniyə',
      one: 'ilk gedişi etmək üçün son $count saniyə',
    );
    return '$_temp0';
  }

  @override
  String nbSeconds(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count saniyə',
      one: '$count saniyə',
    );
    return '$_temp0';
  }

  @override
  String andSaveNbPremoveLines(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'və $count öngediş variantını saxla',
      one: 'və $count öngediş variantını saxla',
    );
    return '$_temp0';
  }

  @override
  String get stormMoveToStart => 'Başlamaq üçün gediş edin';

  @override
  String get stormYouPlayTheWhitePiecesInAllPuzzles => 'Hər pazlda ağ hissələrlə oynay';

  @override
  String get stormYouPlayTheBlackPiecesInAllPuzzles => 'Hər pazlda qara hissələrlə oyna';

  @override
  String get stormPuzzlesSolved => 'həll edilən tapmaca';

  @override
  String get stormNewDailyHighscore => 'Günlük ən yüksək nəticə!';

  @override
  String get stormNewWeeklyHighscore => 'Həftəlik ən yüksək nəticə!';

  @override
  String get stormNewMonthlyHighscore => 'Aylıq ən yüksək nəticə!';

  @override
  String get stormNewAllTimeHighscore => 'Bütün zamanların ən yüksək nəticəsi!';

  @override
  String stormPreviousHighscoreWasX(String param) {
    return 'Əvvəlki ən yüksək nəticə: $param';
  }

  @override
  String get stormPlayAgain => 'Yenidən oyna';

  @override
  String stormHighscoreX(String param) {
    return 'Ən yüksək nəticə: $param';
  }

  @override
  String get stormScore => 'Hesab';

  @override
  String get stormMoves => 'Gediş sayı';

  @override
  String get stormAccuracy => 'Dəqiqlik';

  @override
  String get stormCombo => 'Kombo';

  @override
  String get stormTime => 'Vaxt';

  @override
  String get stormTimePerMove => 'Gediş başına vaxt';

  @override
  String get stormHighestSolved => 'Ən çətin tapmaca';

  @override
  String get stormPuzzlesPlayed => 'Ən çətin tapmaca';

  @override
  String get stormNewRun => 'Yeni tur (qısayol: Boşluq düyməsi)';

  @override
  String get stormEndRun => 'Turu bitir (qısayol: Enter)';

  @override
  String get stormHighscores => 'Ən yüksək ballar';

  @override
  String get stormViewBestRuns => 'Ən yaxşı cəhdləri göstər';

  @override
  String get stormBestRunOfDay => 'Günün ən yaxşı cəhdi';

  @override
  String get stormRuns => 'Cəhdlərin sayı';

  @override
  String get stormGetReady => 'Hazır ol!';

  @override
  String get stormWaitingForMorePlayers => 'Daha çox oyunçunun qatılması üçün gözləmə...';

  @override
  String get stormRaceComplete => 'Yarış tamamlandı!';

  @override
  String get stormSpectating => 'Tamaşaçı';

  @override
  String get stormJoinTheRace => 'Yarışa qatıl!';

  @override
  String get stormStartTheRace => 'Yarışı başlat';

  @override
  String stormYourRankX(String param) {
    return 'Sənin rank $param';
  }

  @override
  String get stormWaitForRematch => 'Yeni oyun üçün gözlə';

  @override
  String get stormNextRace => 'Növbəti yarış';

  @override
  String get stormJoinRematch => 'Yeni oyuna qatıl';

  @override
  String get stormWaitingToStart => 'Başlamaq üçün gözlə';

  @override
  String get stormCreateNewGame => 'Yeni oyun yarat';

  @override
  String get stormJoinPublicRace => 'Təsadüfi yarışa qatıl';

  @override
  String get stormRaceYourFriends => 'Dostlarınla yarış';

  @override
  String get stormSkip => 'keç';

  @override
  String get stormSkipHelp => 'Hər yarışda bir gedişi keçə bilərsən:';

  @override
  String get stormSkipExplanation => 'Kombonu qorumaq üçün bu gedişi keç! Hər yarışda sadəcə bir dəfə işləyir.';

  @override
  String get stormFailedPuzzles => 'Failed puzzles';

  @override
  String get stormSlowPuzzles => 'Slow puzzles';

  @override
  String get stormSkippedPuzzle => 'Skipped puzzle';

  @override
  String get stormThisWeek => 'This week';

  @override
  String get stormThisMonth => 'This month';

  @override
  String get stormAllTime => 'All-time';

  @override
  String get stormClickToReload => 'Click to reload';

  @override
  String get stormThisRunHasExpired => 'This run has expired!';

  @override
  String get stormThisRunWasOpenedInAnotherTab => 'This run was opened in another tab!';

  @override
  String stormXRuns(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count cəhd',
      one: '1 cəhd',
    );
    return '$_temp0';
  }

  @override
  String stormPlayedNbRunsOfPuzzleStorm(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count dəfə $param2 oynadı',
      one: 'Bir dəfə $param2 oynadı',
    );
    return '$_temp0';
  }

  @override
  String get streamerLichessStreamers => 'Lichess yayımçıları';

  @override
  String get studyShareAndExport => 'Paylaş və yüklə';

  @override
  String get studyStart => 'Başlat';
}
