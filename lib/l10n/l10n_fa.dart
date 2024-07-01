import 'package:intl/intl.dart' as intl;

import 'l10n.dart';

/// The translations for Persian (`fa`).
class AppLocalizationsFa extends AppLocalizations {
  AppLocalizationsFa([String locale = 'fa']) : super(locale);

  @override
  String get activityActivity => 'فعالیت';

  @override
  String get activityHostedALiveStream => 'یک پخش زنده میزبانی کرد';

  @override
  String activityRankedInSwissTournament(String param1, String param2) {
    return 'رتبه #$param1 را در $param2 به دست آورد';
  }

  @override
  String get activitySignedUp => 'در لیچس ثبت نام کرد';

  @override
  String activitySupportedNbMonths(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'به عنوان $param2 برای $count ماه از lichess.org حمایت کرد',
      one: 'به عنوان $param2 برای $count ماه از lichess.org حمایت کرد',
      zero: 'به عنوان $param2 برای $count ماه از lichess.org حمایت کرد',
    );
    return '$_temp0';
  }

  @override
  String activityPracticedNbPositions(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count پوزیسیون را در $param2 تمرین کرد',
      one: '$count وضعیت را در $param2 تمرین کرد',
      zero: '$count وضعیت را در $param2 تمرین کرد',
    );
    return '$_temp0';
  }

  @override
  String activitySolvedNbPuzzles(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count مساله تاکتیکی را حل کرد',
      one: '$count معمای آموزشی را حل کرد',
      zero: '$count معمای آموزشی را حل کرد',
    );
    return '$_temp0';
  }

  @override
  String activityPlayedNbGames(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count بازی $param2 را انجام داد',
      one: '$count بازی $param2 را انجام داد',
      zero: '$count بازی $param2 را انجام داد',
    );
    return '$_temp0';
  }

  @override
  String activityPostedNbMessages(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count پیام را در $param2 ارسال کرد',
      one: '$count پیام را در $param2 ارسال کرد',
      zero: '$count پیام را در $param2 ارسال کرد',
    );
    return '$_temp0';
  }

  @override
  String activityPlayedNbMoves(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count حرکت انجام داد',
      one: '$count حرکت انجام داد',
      zero: '$count حرکت انجام داد',
    );
    return '$_temp0';
  }

  @override
  String activityInNbCorrespondenceGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'در $count بازی مکاتبه‌ای',
      one: 'در $count بازی مکاتبه‌ای',
      zero: 'در $count بازی مکاتبه‌ای',
    );
    return '$_temp0';
  }

  @override
  String activityCompletedNbGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count بازی مکاتبه‌ای را به پایان رساند',
      one: '$count بازی مکاتبه‌ای را به پایان رساند',
      zero: '$count بازی مکاتبه‌ای را به پایان رساند',
    );
    return '$_temp0';
  }

  @override
  String activityFollowedNbPlayers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count بازیکن را دنبال کرد',
      one: '$count بازیکن را دنبال کرد',
      zero: '$count بازیکن را دنبال کرد',
    );
    return '$_temp0';
  }

  @override
  String activityGainedNbFollowers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count دنبال کننده جدید به دست آورد',
      one: '$count دنبال کننده جدید به دست آورد',
      zero: '$count دنبال کننده جدید به دست آورد',
    );
    return '$_temp0';
  }

  @override
  String activityHostedNbSimuls(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count مسابقه هم‌زمان برگزار کرد',
      one: '$count مسابقه هم‌زمان برگزار کرد',
      zero: '$count مسابقه هم‌زمان برگزار کرد',
    );
    return '$_temp0';
  }

  @override
  String activityJoinedNbSimuls(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'در $count مسابقه هم‌زمان شرکت کرد',
      one: 'در $count مسابقه هم‌زمان شرکت کرد',
      zero: 'در $count مسابقه هم‌زمان شرکت کرد',
    );
    return '$_temp0';
  }

  @override
  String activityCreatedNbStudies(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count درس جدید ساخت',
      one: '$count درس جدید ساخت',
      zero: '$count درس جدید ساخت',
    );
    return '$_temp0';
  }

  @override
  String activityCompetedInNbTournaments(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'در $count مسابقه آرنا رقابت کرد',
      one: 'در $count مسابقه آرنا رقابت کرد',
      zero: 'در $count مسابقه آرنا رقابت کرد',
    );
    return '$_temp0';
  }

  @override
  String activityRankedInTournament(int count, String param2, String param3, String param4) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'رتبه #$count ($param2% برتر) با $param3 بازی در $param4',
      one: 'رتبه #$count ($param2% برتر) با $param3 بازی در $param4',
      zero: 'رتبه #$count ($param2% برتر) با $param3 بازی در $param4',
    );
    return '$_temp0';
  }

  @override
  String activityCompetedInNbSwissTournaments(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'در $count مسابقه سوئیسی رقابت کرد',
      one: 'در $count مسابقه سوئیسی رقابت کرد',
      zero: 'در $count مسابقه سوئیسی رقابت کرد',
    );
    return '$_temp0';
  }

  @override
  String activityJoinedNbTeams(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'به $count تیم پیوست',
      one: 'به $count تیم پیوست',
      zero: 'به $count تیم پیوست',
    );
    return '$_temp0';
  }

  @override
  String get broadcastBroadcasts => 'پخش همگانی';

  @override
  String get broadcastStartDate => 'تاریخ شروع، در منطقه زمانی خودتان';

  @override
  String challengeChallengesX(String param1) {
    return 'پیشنهاد بازی: $param1';
  }

  @override
  String get challengeChallengeToPlay => 'پیشنهاد بازی دادن';

  @override
  String get challengeChallengeDeclined => 'پیشنهاد بازی رد شد.';

  @override
  String get challengeChallengeAccepted => 'پیشنهاد بازی پذیرفته شد!';

  @override
  String get challengeChallengeCanceled => 'پیشنهاد بازی لغو شد.';

  @override
  String get challengeRegisterToSendChallenges => 'برای پیشنهاد بازی دادن به این کاربر، لطفا نام‌نویسی کنید.';

  @override
  String challengeYouCannotChallengeX(String param) {
    return 'شما نمی‌توانید به $param پیشنهاد بازی دهید.';
  }

  @override
  String challengeXDoesNotAcceptChallenges(String param) {
    return '$param پیشنهاد بازی را نپذیرفت.';
  }

  @override
  String challengeYourXRatingIsTooFarFromY(String param1, String param2) {
    return 'درجه‌بندی $param1 شما با $param2 اختلاف زیادی دارد.';
  }

  @override
  String challengeCannotChallengeDueToProvisionalXRating(String param) {
    return 'به‌خاطر داشتن درجه‌بندی $param موقت، نمی‌توانید پیشنهاد بازی دهید.';
  }

  @override
  String challengeXOnlyAcceptsChallengesFromFriends(String param) {
    return '$param فقط پیشنهاد بازی از دوستانش را می‌پذیرد.';
  }

  @override
  String get challengeDeclineGeneric => 'من فعلا پیشنهاد بازی نمی‌پذیرم.';

  @override
  String get challengeDeclineLater => 'الان زمان مناسبی برای من نیست، لطفا بعدا دوباره درخواست دهید.';

  @override
  String get challengeDeclineTooFast => 'این زمان‌بندی برایم خیلی کم است، لطفا دوباره با زمان‌بندی بیشتر پیشنهاد بازی دهید.';

  @override
  String get challengeDeclineTooSlow => 'این زمان‌بندی برایم خیلی زیاد است، لطفا دوباره با زمان‌بندی کمتر پیشنهاد بازی دهید.';

  @override
  String get challengeDeclineTimeControl => 'من با این زمان‌بندی، پیشنهاد بازی را نمی‌پذیرم.';

  @override
  String get challengeDeclineRated => 'لطفا به جایش، پیشنهاد بازی رسمی بده.';

  @override
  String get challengeDeclineCasual => 'لطفا به جایش، پیشنهاد بازی غیررسمی بده.';

  @override
  String get challengeDeclineStandard => 'الان پیشنهاد بازی‌های شطرنج‌گونه را نمی‌پذیرم.';

  @override
  String get challengeDeclineVariant => 'الان مایل نیستم این شطرنج‌گونه را بازی کنم.';

  @override
  String get challengeDeclineNoBot => 'من پیشنهاد بازی از ربات‌ها را نمی‌پذیرم.';

  @override
  String get challengeDeclineOnlyBot => 'من فقط پیشنهاد بازی از ربات‌ها را می‌پذیرم.';

  @override
  String get challengeInviteLichessUser => 'یا یک کاربر Lichess را دعوت کنید:';

  @override
  String get contactContact => 'ارتباط با ما';

  @override
  String get contactContactLichess => 'ارتباط با Lichess';

  @override
  String get patronDonate => 'کمک مالی';

  @override
  String get patronLichessPatron => 'پشتیبانِ Lichess';

  @override
  String perfStatPerfStats(String param) {
    return 'وضعیت $param';
  }

  @override
  String get perfStatViewTheGames => 'بازی ها را تماشا کنید';

  @override
  String get perfStatProvisional => 'موقت';

  @override
  String get perfStatNotEnoughRatedGames => 'بازی های رسمی کافی برای تعیین کردن یک درجه‌بندی قابل‌اتکا انجام نشده است.';

  @override
  String perfStatProgressOverLastXGames(String param) {
    return 'پیشرفت در آخرین $param بازی ها:';
  }

  @override
  String perfStatRatingDeviation(String param) {
    return 'انحراف درجه‌بندی: $param.';
  }

  @override
  String perfStatRatingDeviationTooltip(String param1, String param2, String param3) {
    return 'مقدار کمتر به این معنی است که درجه‌بندی پایدارتر است. بالاتر از $param1، درجه‌بندی موقت در نظر گرفته می‌شود. برای قرار گرفتن در درجه‌بندی‌ها، این مقدار باید کم‌تر از $param2 (در شطرنج استاندارد) یا $param3 (در شطرنج‌گونه‌ها) باشد.';
  }

  @override
  String get perfStatTotalGames => 'تمام بازی ها';

  @override
  String get perfStatRatedGames => 'بازی های رسمی';

  @override
  String get perfStatTournamentGames => 'بازی های مسابقه ای';

  @override
  String get perfStatBerserkedGames => 'بازی‌های جنون آمیز';

  @override
  String get perfStatTimeSpentPlaying => 'مدت زمان بازی کردن';

  @override
  String get perfStatAverageOpponent => 'حریف معمولی';

  @override
  String get perfStatVictories => 'پیروزی ها';

  @override
  String get perfStatDefeats => 'شکست ها';

  @override
  String get perfStatDisconnections => 'قطع ارتباطها';

  @override
  String get perfStatNotEnoughGames => 'تعداد بازی های انجام شده کافی نیست';

  @override
  String perfStatHighestRating(String param) {
    return 'بالاترین درجه‌بندی: $param';
  }

  @override
  String perfStatLowestRating(String param) {
    return 'پایین‌ترین درجه‌بندی: $param';
  }

  @override
  String perfStatFromXToY(String param1, String param2) {
    return 'از $param1 تا $param2';
  }

  @override
  String get perfStatWinningStreak => 'بردهای متوالی';

  @override
  String get perfStatLosingStreak => 'باخت‌های متوالی';

  @override
  String perfStatLongestStreak(String param) {
    return 'طولانی‌ترین توالی: $param';
  }

  @override
  String perfStatCurrentStreak(String param) {
    return 'توالی فعلی: $param';
  }

  @override
  String get perfStatBestRated => 'بهترین پیروزی های رسمی';

  @override
  String get perfStatGamesInARow => 'بازی های متوالی انجام شده';

  @override
  String get perfStatLessThanOneHour => 'کمتر از یک ساعت بین بازی‌ها';

  @override
  String get perfStatMaxTimePlaying => 'بیشترین زمانی که صرف بازی شده است';

  @override
  String get perfStatNow => 'حالا';

  @override
  String get preferencesPreferences => 'تنظیمات';

  @override
  String get preferencesDisplay => 'صفحه نمایش';

  @override
  String get preferencesPrivacy => 'امنیت و حریم شخصی';

  @override
  String get preferencesNotifications => 'اعلانات';

  @override
  String get preferencesPieceAnimation => 'حرکت مهره ها';

  @override
  String get preferencesMaterialDifference => 'تفاوت مُهره‌ها';

  @override
  String get preferencesBoardHighlights => 'رنگ‌نمایی صفحه (آخرین حرکت و کیش)';

  @override
  String get preferencesPieceDestinations => 'مقصد مهره(حرکت معتبر و پیش حرکت )';

  @override
  String get preferencesBoardCoordinates => 'مختصات صفحه(A-H، 1-8)';

  @override
  String get preferencesMoveListWhilePlaying => 'لیست حرکات هنگام بازی کردن';

  @override
  String get preferencesPgnPieceNotation => 'نشانه‌گذاری حرکات';

  @override
  String get preferencesChessPieceSymbol => 'نماد مهره';

  @override
  String get preferencesPgnLetter => 'حرف (K, Q, R, B, N)';

  @override
  String get preferencesZenMode => 'حالت ذن';

  @override
  String get preferencesShowPlayerRatings => 'نشان دادن درجه‌بندی بازیکنان';

  @override
  String get preferencesShowFlairs => 'نمایش نشان بازیکنان';

  @override
  String get preferencesExplainShowPlayerRatings => 'این گزینه همه درجه‌بندی‌ها در Lichess را پنهان می‌کند تا کمک کند روی شطرنج تمرکز کنید. بازی‌های رسمی همچنان بر درجه‌بندی‌تان تاثیر می‌گذارند، این گزینه فقط مربوط به دیدن/ندیدن درجه‌بندی‌هاست.';

  @override
  String get preferencesDisplayBoardResizeHandle => 'نمایش دستگیره برای تغییر اندازه صفحه';

  @override
  String get preferencesOnlyOnInitialPosition => 'فقط در آغاز بازی';

  @override
  String get preferencesInGameOnly => 'تنها در بازی';

  @override
  String get preferencesChessClock => 'ساعت شطرنج';

  @override
  String get preferencesTenthsOfSeconds => 'دهم ثانیه';

  @override
  String get preferencesWhenTimeRemainingLessThanTenSeconds => 'وقتی زمان باقی مانده کمتر از ده ثانیه می باشد';

  @override
  String get preferencesHorizontalGreenProgressBars => 'نمودار زمان سبز رنگ افقی';

  @override
  String get preferencesSoundWhenTimeGetsCritical => 'صدا در هنگام زمان بحرانی زده می شود';

  @override
  String get preferencesGiveMoreTime => 'افزایش زمان حریف';

  @override
  String get preferencesGameBehavior => 'تنظیمات بازی';

  @override
  String get preferencesHowDoYouMovePieces => 'تمایل دارید که چگونه مهره ها را حرکت دهید؟';

  @override
  String get preferencesClickTwoSquares => 'انتخاب دو مربع مبدا و مقصد';

  @override
  String get preferencesDragPiece => 'کشیدن یک مهره';

  @override
  String get preferencesBothClicksAndDrag => 'هر دو';

  @override
  String get preferencesPremovesPlayingDuringOpponentTurn => 'پیش حرکت (بازی در نوبت حریف)';

  @override
  String get preferencesTakebacksWithOpponentApproval => 'پس گرفتن حرکت (با تایید حریف)';

  @override
  String get preferencesInCasualGamesOnly => 'در بازی های غیررسمی';

  @override
  String get preferencesPromoteToQueenAutomatically => 'ترفیع کردن به وزیر به صورت خودکار';

  @override
  String get preferencesExplainPromoteToQueenAutomatically => '<ctrl> را در هنگام تبلیغ بزنید تا به طور موقت تبلیغات خودکار را غیرفعال کنید';

  @override
  String get preferencesWhenPremoving => 'در زمان پیش حرکت';

  @override
  String get preferencesClaimDrawOnThreefoldRepetitionAutomatically => 'ادعای تساوی در تکرار سه گانه به طور خودکار';

  @override
  String get preferencesWhenTimeRemainingLessThanThirtySeconds => 'وقتی زمان باقی مانده کمتر از سی ثانیه است';

  @override
  String get preferencesMoveConfirmation => 'تایید حرکت';

  @override
  String get preferencesExplainCanThenBeTemporarilyDisabled => 'می‌توانید در طول بازی منوی تخته را غیرفعال کنید';

  @override
  String get preferencesInCorrespondenceGames => 'در حال بازی مکاتبه ای';

  @override
  String get preferencesCorrespondenceAndUnlimited => 'مکاتبه ای و نامحدود';

  @override
  String get preferencesConfirmResignationAndDrawOffers => 'نیاز به تایید دوباره؛ زمانی که تسلیم می شوید یا پیشنهاد تساوی می دهید';

  @override
  String get preferencesCastleByMovingTheKingTwoSquaresOrOntoTheRook => 'روش انجام شاه قلعه';

  @override
  String get preferencesCastleByMovingTwoSquares => 'به وسیله ی دو خانه حرکت دادن شاه';

  @override
  String get preferencesCastleByMovingOntoTheRook => 'به وسیله ی حرکت دادن شاه روی خانه رخ';

  @override
  String get preferencesInputMovesWithTheKeyboard => 'ورود حرکات با استفاده از صفحه کلید';

  @override
  String get preferencesInputMovesWithVoice => 'حرکات را با صدای خود وارد کنید';

  @override
  String get preferencesSnapArrowsToValidMoves => 'چسبیدن پیکان‌ها به حرکت‌های ممکن';

  @override
  String get preferencesSayGgWpAfterLosingOrDrawing => 'گفتن \"بازی خوبی بود، خوب بازی کردی\" در هنگام باخت یا تساوی';

  @override
  String get preferencesYourPreferencesHaveBeenSaved => 'تغییرات شما ذخیره شده است';

  @override
  String get preferencesScrollOnTheBoardToReplayMoves => 'اسکرول کردن روی صفحه برای مشاهده مجدد حرکت‌ها';

  @override
  String get preferencesCorrespondenceEmailNotification => 'ایمیل های روزانه که بازی های شبیه شما را به صورت لیست درمی‌آورند';

  @override
  String get preferencesNotifyStreamStart => 'استریمر شروع به فعالیت کرد';

  @override
  String get preferencesNotifyInboxMsg => 'پیام جدید';

  @override
  String get preferencesNotifyForumMention => 'در کامنتی نام شما ذکر شده است';

  @override
  String get preferencesNotifyInvitedStudy => 'دعوت به مطالعه';

  @override
  String get preferencesNotifyGameEvent => 'اعلان به روزرسانی بازی';

  @override
  String get preferencesNotifyChallenge => 'پیشنهاد بازی';

  @override
  String get preferencesNotifyTournamentSoon => 'تورنمت به زودی آغاز می شود';

  @override
  String get preferencesNotifyTimeAlarm => 'هشدار تنگی زمان';

  @override
  String get preferencesNotifyBell => 'زنگوله اعلانات لیچس';

  @override
  String get preferencesNotifyPush => 'اعلانات برای زمانی که شما در لیچس نیستید';

  @override
  String get preferencesNotifyWeb => 'مرورگر';

  @override
  String get preferencesNotifyDevice => 'دستگاه';

  @override
  String get preferencesBellNotificationSound => 'زنگ اعلان';

  @override
  String get puzzlePuzzles => 'معماها';

  @override
  String get puzzlePuzzleThemes => 'معماهای دسته‌بندی شده';

  @override
  String get puzzleRecommended => 'توصیه شده';

  @override
  String get puzzlePhases => 'مرحله‌ها';

  @override
  String get puzzleMotifs => 'موضوعات';

  @override
  String get puzzleAdvanced => 'پیشرفته';

  @override
  String get puzzleLengths => 'تعداد حرکات';

  @override
  String get puzzleMates => 'مات‌ها';

  @override
  String get puzzleGoals => 'اهداف';

  @override
  String get puzzleOrigin => 'خاستگاه';

  @override
  String get puzzleSpecialMoves => 'حرکات ویژه';

  @override
  String get puzzleDidYouLikeThisPuzzle => 'این معما را دوست داشتید؟';

  @override
  String get puzzleVoteToLoadNextOne => 'موافقت برای بارگذاری معمای بعدی!';

  @override
  String get puzzleUpVote => 'معمای خوبی بود';

  @override
  String get puzzleDownVote => 'معمای بدی بود';

  @override
  String get puzzleYourPuzzleRatingWillNotChange => 'درجه‌بندی معمایی شما تغییری نخواهد کرد. توجه داشته باشید که معماها یک رقابت نیستند. درجه‌بندی‌تان به انتخاب بهترین معماها برای سطح مهارت فعلی‌تان کمک می‌کند.';

  @override
  String get puzzleFindTheBestMoveForWhite => 'بهترین حرکت برای سفید را پیدا کنید.';

  @override
  String get puzzleFindTheBestMoveForBlack => 'بهترین حرکت برای سیاه را پیدا کنید.';

  @override
  String get puzzleToGetPersonalizedPuzzles => 'دریافت معماهای شخصی‌سازی‌شده:';

  @override
  String puzzlePuzzleId(String param) {
    return 'معمای $param';
  }

  @override
  String get puzzlePuzzleOfTheDay => 'معمای روز';

  @override
  String get puzzleDailyPuzzle => 'معمای روزانه';

  @override
  String get puzzleClickToSolve => 'برای حل کلیک کنید';

  @override
  String get puzzleGoodMove => 'حرکت خوب';

  @override
  String get puzzleBestMove => 'بهترین حرکت!';

  @override
  String get puzzleKeepGoing => 'ادامه دهید…';

  @override
  String get puzzlePuzzleSuccess => 'موفق شدید!';

  @override
  String get puzzlePuzzleComplete => 'معما تکمیل شد!';

  @override
  String get puzzleByOpenings => 'بر اساس گشایش‌ها';

  @override
  String get puzzlePuzzlesByOpenings => 'معماها بر اساس گشایش‌ها';

  @override
  String get puzzleOpeningsYouPlayedTheMost => 'گشایش‌هایی که بیش از همه در بازی‌های امتیازی کرده‌اید';

  @override
  String get puzzleUseFindInPage => 'با استفاده از قابلیت \"جستجو در صفحه\" مرورگر خود گشایش محبوب خود را پیدا کنید!';

  @override
  String get puzzleUseCtrlF => 'از Ctrl+f برای پیدا کردن گشایش مورد علاقه خود استفاده کنید!';

  @override
  String get puzzleNotTheMove => 'این حرکت نیست!';

  @override
  String get puzzleTrySomethingElse => 'چیز دیگری پیدا کنید';

  @override
  String puzzleRatingX(String param) {
    return 'درجه‌بندی: $param';
  }

  @override
  String get puzzleHidden => 'پنهان';

  @override
  String puzzleFromGameLink(String param) {
    return 'برگرفته شده از بازی $param';
  }

  @override
  String get puzzleContinueTraining => 'ادامه دادن تمرین';

  @override
  String get puzzleDifficultyLevel => 'میزان سختی';

  @override
  String get puzzleNormal => 'متوسط';

  @override
  String get puzzleEasier => 'آسان‌تر';

  @override
  String get puzzleEasiest => 'آسان‌ترین';

  @override
  String get puzzleHarder => 'سخت‌تر';

  @override
  String get puzzleHardest => 'سخت‌ترین';

  @override
  String get puzzleExample => 'مثال';

  @override
  String get puzzleAddAnotherTheme => 'افزودن موضوعی دیگر';

  @override
  String get puzzleNextPuzzle => 'معمای بعدی';

  @override
  String get puzzleJumpToNextPuzzleImmediately => 'فوراً به معمای بعدی بروید';

  @override
  String get puzzlePuzzleDashboard => 'پیشخوان معماها';

  @override
  String get puzzleImprovementAreas => 'نقاط ضعف';

  @override
  String get puzzleStrengths => 'نقاط قوت';

  @override
  String get puzzleHistory => 'پیشینه معماها';

  @override
  String get puzzleSolved => 'حل شده';

  @override
  String get puzzleFailed => 'شکست!';

  @override
  String get puzzleStreakDescription => 'به تدریج معماهای سخت‌تری را حل کنید و یک دنباله بُرد بسازید. محدویت زمانی وجود ندارد، پس عجله نکنید. با یک حرکت اشتباه، بازی تمام می‌شود! در هر دور، می‌توانید یک حرکت را رَد کنید.';

  @override
  String puzzleYourStreakX(String param) {
    return 'رکورد شما: $param';
  }

  @override
  String get puzzleStreakSkipExplanation => 'این حرکت را رد کنید تا رکورد خود را حفظ کنید! فقط یک بار در هر دور امکان‌پذیر است.';

  @override
  String get puzzleContinueTheStreak => 'توالی را ادامه دهید';

  @override
  String get puzzleNewStreak => 'رکورد جدید';

  @override
  String get puzzleFromMyGames => 'از بازی های من';

  @override
  String get puzzleLookupOfPlayer => 'به دنبال معماهای برگرفته‌شده از بازی‌های یک بازیکن مشخص، بگردید';

  @override
  String puzzleFromXGames(String param) {
    return 'معماهای برگرفته‌شده از بازی‌های $param';
  }

  @override
  String get puzzleSearchPuzzles => 'جستجوی معماها';

  @override
  String get puzzleFromMyGamesNone => 'شما هیچ معمایی در پایگاه‌داده ندارید، اما Lichess همچنان شما را بسیار دوست دارد.\n\nبازی‌های سریع و مرسوم را انجام دهید تا بَختِتان را برای اضافه کردن یک معما از خودتان افزایش دهید!';

  @override
  String puzzleFromXGamesFound(String param1, String param2) {
    return '$param1 معما در بازی‌های $param2 پیدا شد';
  }

  @override
  String get puzzlePuzzleDashboardDescription => 'تمرین کن، تحلیل کن، پیشرفت کن';

  @override
  String puzzlePercentSolved(String param) {
    return '$param حل شده';
  }

  @override
  String get puzzleNoPuzzlesToShow => 'هیچ موردی برای نمایش وجود ندارد، بروید و ابتدا چند معما حل کنید!';

  @override
  String get puzzleImprovementAreasDescription => 'این‌ها را تمرین کنید تا روند پیشرفت خود را بهبود ببخشید!';

  @override
  String get puzzleStrengthDescription => 'شما در این زمینه‌ها بهترین عملکرد را دارید';

  @override
  String puzzlePlayedXTimes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count بار بازی شده',
      one: '$count بار بازی شده است',
      zero: '$count بار بازی شده است',
    );
    return '$_temp0';
  }

  @override
  String puzzleNbPointsBelowYourPuzzleRating(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count امتیاز پایین‌تر از امتیاز شما در معماها',
      one: 'یک امتیاز پایین‌تر از امتیاز شما در معماها',
      zero: 'یک امتیاز پایین‌تر از امتیاز شما در معماها',
    );
    return '$_temp0';
  }

  @override
  String puzzleNbPointsAboveYourPuzzleRating(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count امتیاز بالاتر از درجه‌بندی معمایی‌تان',
      one: 'یک امتیاز بالاتر از درجه‌بندی معمایی‌تان',
      zero: 'یک امتیاز بالاتر از درجه‌بندی معمایی‌تان',
    );
    return '$_temp0';
  }

  @override
  String puzzleNbPlayed(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count نفر بازی کردند',
      one: '$count بررسی شده',
      zero: '$count بررسی شده',
    );
    return '$_temp0';
  }

  @override
  String puzzleNbToReplay(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count مورد برای بازبینی',
      one: '$count برای بازبینی',
      zero: '$count برای بازبینی',
    );
    return '$_temp0';
  }

  @override
  String get puzzleThemeAdvancedPawn => 'پیاده پیش رفته';

  @override
  String get puzzleThemeAdvancedPawnDescription => 'یکی از پیاده های شما در زمین حریف پیشروی کرده، گویی تهدید به ارتقا میکنه.';

  @override
  String get puzzleThemeAdvantage => 'برتری';

  @override
  String get puzzleThemeAdvantageDescription => 'از شانس خود برای بدست اوردن برتری قطعی استفاده کنید. (200cp ≤ eval ≤ 600cp)';

  @override
  String get puzzleThemeAnastasiaMate => 'مات آناستازیا';

  @override
  String get puzzleThemeAnastasiaMateDescription => 'یک اسب و یک رخ به همدیگر کمک میکنند تا شاه حریف را بین گوشه های زمین و یک مهره از حریف زندانی کنند.';

  @override
  String get puzzleThemeArabianMate => 'مات عربی';

  @override
  String get puzzleThemeArabianMateDescription => 'یک اسب و یک رخ برای به دام انداختن شاه حریف در گوشه صفحه همکاری می کنند.';

  @override
  String get puzzleThemeAttackingF2F7 => 'حمله به خانه f2 یا f7';

  @override
  String get puzzleThemeAttackingF2F7Description => 'حمله ای که در آن روی پیاده های f2 و f7 تمرکز می شود، مانند دفاع دو اسب.';

  @override
  String get puzzleThemeAttraction => 'جلب کردن';

  @override
  String get puzzleThemeAttractionDescription => 'تبادل یا فداکاری یک مهره برای تشویق یا وادار کردن حریف به حرکتی که امکان تاکتیک بعدی را فراهم میکند.';

  @override
  String get puzzleThemeBackRankMate => 'مات عرض آخر';

  @override
  String get puzzleThemeBackRankMateDescription => 'به دام انداختن شاه حریف در عرض اولیه خود زمانی که با مهره های خودی به دام افتاده است.';

  @override
  String get puzzleThemeBishopEndgame => 'آخربازی فیل';

  @override
  String get puzzleThemeBishopEndgameDescription => 'آخربازی، تنها با فیل‌ها و پیاده‌ها.';

  @override
  String get puzzleThemeBodenMate => 'مات بودِن یا دوشمشیر';

  @override
  String get puzzleThemeBodenMateDescription => 'دو فیل به حالت ضربدری که به گوشه زمین حمله می کنند یک شاه که راهش با مهره های خودش سد شده را مات می کنند.';

  @override
  String get puzzleThemeCastling => 'قلعه رفتن';

  @override
  String get puzzleThemeCastlingDescription => 'شاه خود را ایمن کنید و رخ خود را برای حمله مستقر کنید.';

  @override
  String get puzzleThemeCapturingDefender => 'مهره دفاع کننده را بگیرید';

  @override
  String get puzzleThemeCapturingDefenderDescription => 'گرفتن یک مهره که برای دفاع از یک مهره دیگر حیاتی است، اجازه می دهد مهره ای که اکنون بدون دفاع است در حرکت بعدی گرفته شود.';

  @override
  String get puzzleThemeCrushing => 'تخریب';

  @override
  String get puzzleThemeCrushingDescription => 'استفاده از اشتباه حریف برای بدست آوردن مزیتی کوچک. (eval ≥ 600cp)';

  @override
  String get puzzleThemeDoubleBishopMate => 'مات با دو فیل';

  @override
  String get puzzleThemeDoubleBishopMateDescription => 'دو فیل که همزمان به گوشه های مجاور حمله می کنند، شاهی که راهش با مهره های خودش سد شده را مات می کنند.';

  @override
  String get puzzleThemeDovetailMate => 'مات بوسه ای';

  @override
  String get puzzleThemeDovetailMateDescription => 'وزیری که شاه مجاور خودش را که تنها دو خانه ای که برای فرارش باقی مانده توسط مهره های خودش سد شده، مات می کند.';

  @override
  String get puzzleThemeEquality => 'برابری';

  @override
  String get puzzleThemeEqualityDescription => 'تغییر وضعیت بازنده، و تضمین تساوی یا وضعیت متعادل. (eval ≤ 200cp)';

  @override
  String get puzzleThemeKingsideAttack => 'حمله به جناه شاه';

  @override
  String get puzzleThemeKingsideAttackDescription => 'حمله به شاه حریف زمانی که در جناه شاه قلعه رفته است.';

  @override
  String get puzzleThemeClearance => 'پاکسازی';

  @override
  String get puzzleThemeClearanceDescription => 'حرکتی، اغلب سریع، برای پاک کردن صفحه جهت دنبال کردن ایده های تاکتیکی بعدی.';

  @override
  String get puzzleThemeDefensiveMove => 'حرکت تدافعی';

  @override
  String get puzzleThemeDefensiveMoveDescription => 'حرکت یا دنباله ای از حرکات که برای جلوگیری از دست دادن مهره یا مزیت لازم است.';

  @override
  String get puzzleThemeDeflection => 'منحرف کردن';

  @override
  String get puzzleThemeDeflectionDescription => 'حرکتی که حواس مهره حریف را از وظیفه ای که دارد پرت کند (مانند نگهبانی از یک خانه). گاهی اوقات \"بارگذاری بیش از حد\" نیز نامیده می شود.';

  @override
  String get puzzleThemeDiscoveredAttack => 'حمله برخاست';

  @override
  String get puzzleThemeDiscoveredAttackDescription => 'حرکت دادن یک مهره (مانند اسب)، که قبلا جلوی حمله مهره خودمان به یکی از مهره های دور حریف (مانند رخ)، از جلوی راه مهره حمله کننده.';

  @override
  String get puzzleThemeDoubleCheck => 'کیش دوگانه';

  @override
  String get puzzleThemeDoubleCheckDescription => 'کیش دادن به حریف با دو مهره به صورت هم زمان در نتیجهء یک حمله برخاستی که در آن هم مهره برخاست کننده و هم مهره پشت سر آن به شاه حریف حمله می کنند.';

  @override
  String get puzzleThemeEndgame => 'آخربازی';

  @override
  String get puzzleThemeEndgameDescription => 'یک تاکتیک در لحظات آخر بازی.';

  @override
  String get puzzleThemeEnPassantDescription => 'گرفتن پیاده در حال عبور با پیاده دیگر.';

  @override
  String get puzzleThemeExposedKing => 'شاه در معرض خطر';

  @override
  String get puzzleThemeExposedKingDescription => 'تاکتیکی که در آن شاه مدافعان زیادی ندارد،اغلب این تاکتیک به مات ختم می شود.';

  @override
  String get puzzleThemeFork => 'چنگال';

  @override
  String get puzzleThemeForkDescription => 'حرکتی که در آن مهره ای که حرکت می کند دو مهره حریف را به صورت همزمان مورد حمله قرار می دهد.';

  @override
  String get puzzleThemeHangingPiece => 'مهره بی دفاع';

  @override
  String get puzzleThemeHangingPieceDescription => 'تاکتیکی که در آن مهره های حریف برای گرفتن، بدون دفاع یا با دفاع ناکافی است.';

  @override
  String get puzzleThemeHookMate => 'مات قُلاب';

  @override
  String get puzzleThemeHookMateDescription => 'مات با یک رخ، اسب و یک پیاده در برابر یک پیاده حریف برای محدود کردن راه های فرار شاه دشمن.';

  @override
  String get puzzleThemeInterference => 'چنگال';

  @override
  String get puzzleThemeInterferenceDescription => 'حرکت دادن یک مهره و حمله کردن به دو مهره هم زمان که بتوان یکی از مهره ها را گرفت، مانند حمله یک اسب به به دو تا رخ بصورت هم زمان.';

  @override
  String get puzzleThemeIntermezzo => 'زوگزوانگ';

  @override
  String get puzzleThemeIntermezzoDescription => 'به جای انجام حرکت مورد انتظار، ابتدا حرکت دیگری را وارد کنید که تهدیدی فوری است که حریف باید به آن پاسخ دهد. به عنوان \"Zwischenzug\" شناخته میشود.';

  @override
  String get puzzleThemeKnightEndgame => 'آخربازی اسب';

  @override
  String get puzzleThemeKnightEndgameDescription => 'آخربازی، تنها با اسب‌ها و پیاده‌ها.';

  @override
  String get puzzleThemeLong => 'معمای طولانی';

  @override
  String get puzzleThemeLongDescription => 'سه حرکت برای پیروزی.';

  @override
  String get puzzleThemeMaster => 'بازی‌های استادان';

  @override
  String get puzzleThemeMasterDescription => 'معماهای برگرفته‌شده از بازی‌های بازیکنان عنوان‌دار.';

  @override
  String get puzzleThemeMasterVsMaster => 'بازی‌های استادان برابر هم';

  @override
  String get puzzleThemeMasterVsMasterDescription => 'معماهای برگرفته‌شده از بازی‌های بین دو بازیکن عنوان‌دار.';

  @override
  String get puzzleThemeMate => 'کیش و مات';

  @override
  String get puzzleThemeMateDescription => 'بازی را با سبک خاصی ببرید.';

  @override
  String get puzzleThemeMateIn1 => 'مات در یک حرکت';

  @override
  String get puzzleThemeMateIn1Description => 'در یک حرکت کیش و مات کنید.';

  @override
  String get puzzleThemeMateIn2 => 'مات در دو حرکت';

  @override
  String get puzzleThemeMateIn2Description => 'در دو حرکت کیش و مات کنید.';

  @override
  String get puzzleThemeMateIn3 => 'مات در سه حرکت';

  @override
  String get puzzleThemeMateIn3Description => 'در سه حرکت کیش و مات کنید.';

  @override
  String get puzzleThemeMateIn4 => 'مات در چهار حرکت';

  @override
  String get puzzleThemeMateIn4Description => 'در چهار حرکت کیش و مات کنید.';

  @override
  String get puzzleThemeMateIn5 => 'مات در پنج حرکت یا بیشتر';

  @override
  String get puzzleThemeMateIn5Description => 'کشف یک مات طولانی و متوالی.';

  @override
  String get puzzleThemeMiddlegame => 'وسط بازی';

  @override
  String get puzzleThemeMiddlegameDescription => 'تاکتیکی در لحظات آخر بازی.';

  @override
  String get puzzleThemeOneMove => 'معمای یک-حرکتی';

  @override
  String get puzzleThemeOneMoveDescription => 'یک معما که فقط یک حرکت طول می‌کشد.';

  @override
  String get puzzleThemeOpening => 'گشایش';

  @override
  String get puzzleThemeOpeningDescription => 'تاکتیک در مرحله اول بازی.';

  @override
  String get puzzleThemePawnEndgame => 'آخربازی پیاده';

  @override
  String get puzzleThemePawnEndgameDescription => 'آخربازی، تنها با پیاده‌ها.';

  @override
  String get puzzleThemePin => 'آچمزی';

  @override
  String get puzzleThemePinDescription => 'راهکنش آچمزی، که یک مهره نمی‌تواند حرکت کند، مگر اینکه به مهره ارزشمندتر پشتش حمله می‌شود.';

  @override
  String get puzzleThemePromotion => 'ترفیع';

  @override
  String get puzzleThemePromotionDescription => 'یکی از پیاده های خود را به وزیر یا مهره دیگر ارتقا دهید.';

  @override
  String get puzzleThemeQueenEndgame => 'آخربازی وزیر';

  @override
  String get puzzleThemeQueenEndgameDescription => 'آخربازی، تنها با وزیرها و پیاده‌ها.';

  @override
  String get puzzleThemeQueenRookEndgame => 'وزیر و رخ';

  @override
  String get puzzleThemeQueenRookEndgameDescription => 'آخربازی، تنها با وزیرها، رُخ‌ها و پیاده‌ها.';

  @override
  String get puzzleThemeQueensideAttack => 'حمله به جناه وزیر';

  @override
  String get puzzleThemeQueensideAttackDescription => 'یک حمله به شاه حریف، زمانی که در جناه وزیر قلعه رفته است.';

  @override
  String get puzzleThemeQuietMove => 'حرکت آرام';

  @override
  String get puzzleThemeQuietMoveDescription => 'حرکتی که نه کیش ایجاد می کند و نه مهره ای را می گیرد و نه تهدید فوری را در پی دارد اما یک تهدید غیر قابل پیشگیری را در حرکات بعد به همراه دارد.';

  @override
  String get puzzleThemeRookEndgame => 'آخربازی رخ';

  @override
  String get puzzleThemeRookEndgameDescription => 'آخربازی، تنها با رخ‌ها و پیاده‌ها.';

  @override
  String get puzzleThemeSacrifice => 'قربانی';

  @override
  String get puzzleThemeSacrificeDescription => 'یک تاکتیک شامل کنار از دست دادن مهره در کوتاه مدت، برای به دست آوردن مزیت دوباره پس از یک سری حرکات اجباری.';

  @override
  String get puzzleThemeShort => 'معمای کوتاه';

  @override
  String get puzzleThemeShortDescription => 'دو حرکت تا پیروزی.';

  @override
  String get puzzleThemeSkewer => 'سیخ‌کشی یا سیخ‌کباب';

  @override
  String get puzzleThemeSkewerDescription => 'سیخ‌کشی، که به یک مهره باارزش حمله شده، به گونه‌ای جابجا می‌شود، و حالا امکان می‌دهد که مهره کم‌ارزش پشتش زده شود یا زیر ضرب قرار گیرد. برعکس آچمزی است.';

  @override
  String get puzzleThemeSmotheredMate => 'مات مختنق';

  @override
  String get puzzleThemeSmotheredMateDescription => 'ماتی که توسط یک اسب انجام می شود که در آن پادشاه قادر به حرکت نیست زیرا توسط مهره های خود احاطه شده.';

  @override
  String get puzzleThemeSuperGM => 'بازی اَبَر استاد بزرگان';

  @override
  String get puzzleThemeSuperGMDescription => 'معماهای برگرفته‌شده از بازی‌های بهترین بازیکنان جهان.';

  @override
  String get puzzleThemeTrappedPiece => 'مهره به‌دام‌افتاده';

  @override
  String get puzzleThemeTrappedPieceDescription => 'یک مهره قادر به فرار کردن از زده شدن نیست چون حرکات محدودی دارد.';

  @override
  String get puzzleThemeUnderPromotion => 'ارتقا به غیر از وزیر';

  @override
  String get puzzleThemeUnderPromotionDescription => 'ارتقا به اسب، فیل یا رخ.';

  @override
  String get puzzleThemeVeryLong => 'معمای خیلی طولانی';

  @override
  String get puzzleThemeVeryLongDescription => 'چهار حرکت یا بیشتر برای برنده شدن.';

  @override
  String get puzzleThemeXRayAttack => 'حمله پیکانی';

  @override
  String get puzzleThemeXRayAttackDescription => 'یک مهره از طریق مهره حریف به یک خانه حمله میکند یا از آن دفاع می کند.';

  @override
  String get puzzleThemeZugzwang => 'زوگزوانگ';

  @override
  String get puzzleThemeZugzwangDescription => 'حریف حرکات محدودی برای انجام دادن دارد و تمام حرکات ممکن موقعیت حریف را بدتر میکند.';

  @override
  String get puzzleThemeHealthyMix => 'ترکیب سالم';

  @override
  String get puzzleThemeHealthyMixDescription => 'یک ذره از همه چیز. شما نمی دانید چه چیزی پیش روی شماست، بنابراین شما باید برای هر چیزی آماده باشید! دقیقا مثل بازی های واقعی.';

  @override
  String get puzzleThemePlayerGames => 'بازی‌های بازیکن';

  @override
  String get puzzleThemePlayerGamesDescription => 'دنبال معماهای ایجادشده از بازی‌های خودتان یا بازی‌های سایر بازیکنان، بگردید.';

  @override
  String puzzleThemePuzzleDownloadInformation(String param) {
    return 'این معماها به صورت همگانی هستند و می‌توانید از $param بارگیریدشان.';
  }

  @override
  String get searchSearch => 'جستجو';

  @override
  String get settingsSettings => 'تنظیمات';

  @override
  String get settingsCloseAccount => 'بستن حساب';

  @override
  String get settingsManagedAccountCannotBeClosed => 'اکانت شما مدیریت شده است و نمی تواند بسته شود.';

  @override
  String get settingsClosingIsDefinitive => 'بعد از بستن حسابتان دیگر نمی توانید به آن دسترسی پیدا کنید. آیا مطمئن هستید؟';

  @override
  String get settingsCantOpenSimilarAccount => 'شما نمی توانید حساب جدیدی با این نام کاربری باز کنید، حتی اگر با دستگاه دیگری وارد شوید.';

  @override
  String get settingsChangedMindDoNotCloseAccount => 'نظرم را عوض کردم اکانتم را نمی بندم';

  @override
  String get settingsCloseAccountExplanation => 'آیا مطمئنید که می خواهید حساب خود را ببندید؟ بستن حساب یک تصمیم دائمی است. شما هرگز نمی توانید دوباره وارد حساب خود شوید.';

  @override
  String get settingsThisAccountIsClosed => 'این حساب بسته شده است';

  @override
  String get playWithAFriend => 'بازی با دوستان';

  @override
  String get playWithTheMachine => 'بازی با رایانه';

  @override
  String get toInviteSomeoneToPlayGiveThisUrl => 'برای دعوت کردن حریف این لینک را برای او بفرستید';

  @override
  String get gameOver => 'پایان بازی';

  @override
  String get waitingForOpponent => 'انتطار برای حریف';

  @override
  String get orLetYourOpponentScanQrCode => 'یا اجازه دهید حریف شما این QR کد را پویش کند';

  @override
  String get waiting => 'در حال انتظار';

  @override
  String get yourTurn => 'نوبت شماست';

  @override
  String aiNameLevelAiLevel(String param1, String param2) {
    return '$param1 سطح $param2';
  }

  @override
  String get level => 'سطح';

  @override
  String get strength => 'قدرت';

  @override
  String get toggleTheChat => 'گپ روشن/خاموش';

  @override
  String get chat => 'گپ';

  @override
  String get resign => 'تسلیم شدن';

  @override
  String get checkmate => 'کیش و مات';

  @override
  String get stalemate => 'پات';

  @override
  String get white => 'سفید';

  @override
  String get black => 'سیاه';

  @override
  String get asWhite => 'به عنوان سفید';

  @override
  String get asBlack => 'به عنوان سیاه';

  @override
  String get randomColor => 'رنگ تصادفی';

  @override
  String get createAGame => 'ایجاد بازی';

  @override
  String get whiteIsVictorious => 'سفید برنده است';

  @override
  String get blackIsVictorious => 'سیاه برنده است';

  @override
  String get youPlayTheWhitePieces => 'شما با مهره سفید بازی میکنید';

  @override
  String get youPlayTheBlackPieces => 'شما با مهره سیاه بازی می کنید';

  @override
  String get itsYourTurn => 'نوبت شماست!';

  @override
  String get cheatDetected => 'تقلب تشخیص داده شد';

  @override
  String get kingInTheCenter => 'شاه روی تپه';

  @override
  String get threeChecks => 'سه کیش';

  @override
  String get raceFinished => 'مسابقه تمام شد';

  @override
  String get variantEnding => 'پایان شطرنج‌گونه';

  @override
  String get newOpponent => 'حریف جدید';

  @override
  String get yourOpponentWantsToPlayANewGameWithYou => 'حریف شما می خواهد که دوباره با شما بازی کند';

  @override
  String get joinTheGame => 'به بازی بپیوندید';

  @override
  String get whitePlays => 'نوبت سفید';

  @override
  String get blackPlays => 'نوبت سیاه';

  @override
  String get opponentLeftChoices => 'ممکن است حریف شما بازی را ترک کرده باشد. شما می توانید ادعای پیروزی کنید, اعلام تساوی کنید یا منتظر او بمانید.';

  @override
  String get forceResignation => 'ادعای پیروزی';

  @override
  String get forceDraw => 'اعلام تساوی';

  @override
  String get talkInChat => 'لطفا در گپ‌زنی بااَدب باشید!';

  @override
  String get theFirstPersonToComeOnThisUrlWillPlayWithYou => 'نخستین کسی که به این وب‌نشانی آید با شما بازی خواهد کرد.';

  @override
  String get whiteResigned => 'سفید تسلیم شد';

  @override
  String get blackResigned => 'سیاه تسلیم شد';

  @override
  String get whiteLeftTheGame => 'سفید بازی را ترک کرد';

  @override
  String get blackLeftTheGame => 'سیاه بازی را ترک کرد';

  @override
  String get whiteDidntMove => 'سفید تکان نخورد';

  @override
  String get blackDidntMove => 'مشکی تکان نخورد';

  @override
  String get requestAComputerAnalysis => 'درخواست تحلیل رایانه‌ای';

  @override
  String get computerAnalysis => 'تحليل رایانه‌ای';

  @override
  String get computerAnalysisAvailable => 'تحلیل رایانه‌ای موجود است';

  @override
  String get computerAnalysisDisabled => 'تحلیل رایانه‌ای غیرفعال شد';

  @override
  String get analysis => 'تحلیل بازی';

  @override
  String depthX(String param) {
    return 'عمق بررسی تا $param حرکت';
  }

  @override
  String get usingServerAnalysis => 'استفاده از کارساز برای تحلیل';

  @override
  String get loadingEngine => 'در حال بارگذاری پردازشگر شطرنج...';

  @override
  String get calculatingMoves => 'در حال محاسبه حرکات...';

  @override
  String get engineFailed => 'خطا در بارگذاری پردازشگر شطرنج';

  @override
  String get cloudAnalysis => 'تحلیل ابری';

  @override
  String get goDeeper => 'عمق و تعداد بیشتری از حرکتها را بررسی نمایید';

  @override
  String get showThreat => 'تهدید را نمایش بدهید';

  @override
  String get inLocalBrowser => 'در مرورگر محلی';

  @override
  String get toggleLocalEvaluation => 'کلید ارزیابی محلی';

  @override
  String get promoteVariation => 'افزایش عمق شاخه اصلی';

  @override
  String get makeMainLine => 'خط کنونی را به خط اصلی تبدیل کنید';

  @override
  String get deleteFromHere => 'از اینجا به بعد را پاک کنید';

  @override
  String get collapseVariations => 'بستن شاخه‌ها';

  @override
  String get expandVariations => 'باز کردن شاخه‌ها';

  @override
  String get forceVariation => 'نتیجه تحلیل را به عنوان یکی از تنوعهای بازی انتخاب نمایید';

  @override
  String get copyVariationPgn => 'کپی PGN این شاخه';

  @override
  String get move => 'انتقال بدهید';

  @override
  String get variantLoss => 'حرکت بازنده';

  @override
  String get variantWin => 'حرکت برنده';

  @override
  String get insufficientMaterial => 'مُهره کافی برای مات کردن وجود ندارد';

  @override
  String get pawnMove => 'حرکت پیاده';

  @override
  String get capture => 'گرفتن مهره';

  @override
  String get close => 'بستن';

  @override
  String get winning => 'حرکت پیروزی‌بخش';

  @override
  String get losing => 'حرکت بازنده';

  @override
  String get drawn => 'حرکت تساوی‌دهنده';

  @override
  String get unknown => 'ناشناخته';

  @override
  String get database => 'پایگاه داده';

  @override
  String get whiteDrawBlack => 'سفید / مساوی / سیاه';

  @override
  String averageRatingX(String param) {
    return 'میانگین درجه‌بندی: $param';
  }

  @override
  String get recentGames => 'بازی‌های اخیر';

  @override
  String get topGames => 'بازی‌های برتر';

  @override
  String masterDbExplanation(String param1, String param2, String param3) {
    return 'دو میلیون بازی حقیقی بازیکنان دارای امتیاز بیشتر از $param1 در درجه‌بندی فیده از $param2 تا $param3';
  }

  @override
  String get dtzWithRounding => 'DTZ50\'\' با گرد کردن، بر اساس تعداد حرکات نیمه تا زمان دستگیری یا حرکت پیاده بعدی';

  @override
  String get noGameFound => 'هیچ بازی یافت نشد';

  @override
  String get maxDepthReached => 'عمق به حداکثر رسیده!';

  @override
  String get maybeIncludeMoreGamesFromThePreferencesMenu => 'شاید بازی‌های بیشتری با توجه به گزینگان ترجیحات، وجود داشته باشه؟';

  @override
  String get openings => 'گشایش';

  @override
  String get openingExplorer => 'جستجوگر گشایش‌';

  @override
  String get openingEndgameExplorer => 'جستجوگر گشایش/آخربازی';

  @override
  String xOpeningExplorer(String param) {
    return 'جستجوگر گشایش $param';
  }

  @override
  String get playFirstOpeningEndgameExplorerMove => 'اولین حرکت گشایش/آخربازی را برو';

  @override
  String get winPreventedBy50MoveRule => 'قانون پنجاه حرکت از پیروزی جلوگیری کرد';

  @override
  String get lossSavedBy50MoveRule => 'قانون ۵۰ حرکت از شکست جلوگیری کرد';

  @override
  String get winOr50MovesByPriorMistake => 'برد یا ۵٠ حرکت بعد از اشتباه قبلی';

  @override
  String get lossOr50MovesByPriorMistake => 'باخت یا ۵٠ حرکت از اشتباه قبلی';

  @override
  String get unknownDueToRounding => 'برد یا باخت تنها زمانی تضمین شده است که شاخه پیشنهاد شده توسط دیتابیس پس از آخرین گرفتن مهره یا حرکت پیاده اجرا شود. علت رند کردن احتمالی مقدار های DTZ در دیتابیس است.';

  @override
  String get allSet => 'همه چیز آماده است!';

  @override
  String get importPgn => 'PGN را وارد کنید';

  @override
  String get delete => 'حذف';

  @override
  String get deleteThisImportedGame => 'آیا این بازیِ درونبُرده پاک شود؟';

  @override
  String get replayMode => 'حالت پخش';

  @override
  String get realtimeReplay => 'مشابه بازی';

  @override
  String get byCPL => 'درنگ حین اشتباهات';

  @override
  String get openStudy => 'مطالعه را شروع نمایید';

  @override
  String get enable => 'فعال سازی';

  @override
  String get bestMoveArrow => 'فلش نشان دهنده بهترین حرکت';

  @override
  String get showVariationArrows => 'نمایش پیکان‌های شاخه اصلی';

  @override
  String get evaluationGauge => 'میله ارزیابی';

  @override
  String get multipleLines => 'شاخه های متعدد';

  @override
  String get cpus => 'پردازنده(ها)';

  @override
  String get memory => 'حافظه';

  @override
  String get infiniteAnalysis => 'آنالیز بی پایان';

  @override
  String get removesTheDepthLimit => 'محدودیت عمق بررسی را بر می دارد که به گرم شدن کامپیوتر شما منجر می شود';

  @override
  String get engineManager => 'مدیر موتور شطرنج';

  @override
  String get blunder => 'اشتباه فاحش';

  @override
  String get mistake => 'اشتباه';

  @override
  String get inaccuracy => 'بی دقتی';

  @override
  String get moveTimes => 'مدت حركت‌ها';

  @override
  String get flipBoard => 'چرخاندن صفحه';

  @override
  String get threefoldRepetition => 'تکرار سه گانه';

  @override
  String get claimADraw => 'ادعای تساوی';

  @override
  String get offerDraw => 'پیشنهاد مساوی';

  @override
  String get draw => 'مساوی';

  @override
  String get drawByMutualAgreement => 'تساوی با توافق طرفین';

  @override
  String get fiftyMovesWithoutProgress => 'قانون ۵۰ حرکت';

  @override
  String get currentGames => 'بازی های در جریان';

  @override
  String get viewInFullSize => 'نمایش در اندازه کامل';

  @override
  String get logOut => 'خروج';

  @override
  String get signIn => 'ورود';

  @override
  String get rememberMe => 'مرا به خاطر بسپار';

  @override
  String get youNeedAnAccountToDoThat => 'شما برای انجام این کار به یک حساب کاربری نیاز دارید.';

  @override
  String get signUp => 'نام نویسی';

  @override
  String get computersAreNotAllowedToPlay => 'كامپيوتر و بازيكناني كه از كامپيوتر كمك مي گيرند،مجاز به بازی نیستند.لطفا از انجین شطرنج يا دیتابیس شطرنج و يا بازيكنان ديگر كمک نگيريد. همچنین توجه کنید که داشتن چند حساب کاربری به شدت نهی شده است. استفاده فزاینده از چند حساب منجر به مسدود شدن حساب شما خواهد شد.';

  @override
  String get games => 'بازی ها';

  @override
  String get forum => 'انجمن';

  @override
  String xPostedInForumY(String param1, String param2) {
    return '$param1 در انجمن،موضوع $param2 را پست کرد.';
  }

  @override
  String get latestForumPosts => 'آخرین پست های انجمن';

  @override
  String get players => 'بازیکنان';

  @override
  String get friends => 'دوستان';

  @override
  String get discussions => 'مکالمات';

  @override
  String get today => 'امروز';

  @override
  String get yesterday => 'دیروز';

  @override
  String get minutesPerSide => 'زمان برای هر بازیکن(به دقیقه)';

  @override
  String get variant => 'گونه';

  @override
  String get variants => 'گونه‌ها';

  @override
  String get timeControl => 'زمان';

  @override
  String get realTime => 'زمان محدود';

  @override
  String get correspondence => 'مکاتبه ای';

  @override
  String get daysPerTurn => 'روز برای هر حرکت';

  @override
  String get oneDay => 'یک روز';

  @override
  String get time => 'زمان';

  @override
  String get rating => 'درجه‌بندی';

  @override
  String get ratingStats => 'آماره‌های درجه‌بندی';

  @override
  String get username => 'نام کاربری';

  @override
  String get usernameOrEmail => 'نام کاربری یا ایمیل';

  @override
  String get changeUsername => 'تغییر نام کاربری';

  @override
  String get changeUsernameNotSame => 'تنها اندازه حروف میتوانند تغییر کنند. برای مثال \"johndoe\" به \"JohnDoe\".';

  @override
  String get changeUsernameDescription => 'نام کاربری خود را تغییر دهید. این تنها یک بار انجام پذیر است و شما تنها مجازید اندازه حروف نام کاربری‌تان را تغییر دهید.';

  @override
  String get signupUsernameHint => 'مطمئن شوید که یک نام کاربری مناسب انتخاب میکنید. بعداً نمی توانید آن را تغییر دهید و هر حسابی با نام کاربری نامناسب بسته می شود!';

  @override
  String get signupEmailHint => 'ما فقط از آن برای تنظیم مجدد رمز عبور استفاده خواهیم کرد.';

  @override
  String get password => 'رمز عبور';

  @override
  String get changePassword => 'تغییر کلمه عبور';

  @override
  String get changeEmail => 'تغییر ایمیل';

  @override
  String get email => 'ایمیل';

  @override
  String get passwordReset => 'بازیابی کلمه عبور';

  @override
  String get forgotPassword => 'آیا کلمه عبور را فراموش کرده اید؟';

  @override
  String get error_weakPassword => 'این رمز به شدت معمول و قابل حدس است.';

  @override
  String get error_namePassword => 'لطفا رمز خود را متفاوت از نام کاربری خود انتخاب کنید.';

  @override
  String get blankedPassword => 'شما از همین رمز عبور در سایت دیگری استفاده کرده اید و آن سایت در معرض خطر قرار گرفته است. برای اطمینان از ایمنی حساب لیچس خود، لازم است که شما یک رمز عبور جدید ایجاد کنید. ممنون از همکاری شما.';

  @override
  String get youAreLeavingLichess => 'در حال ترک lichess هستید';

  @override
  String get neverTypeYourPassword => 'هرگز رمز خود را در سایت دیگر وارد نکنید!';

  @override
  String proceedToX(String param) {
    return 'بروید به $param';
  }

  @override
  String get passwordSuggestion => 'از رمز عبور پیشنهاد شده از شخص دیگر استفاده نکنید. در این صورت احتمال سرقت حساب شما وجود دارد.';

  @override
  String get emailSuggestion => 'از ایمیلی که از شخص دیگر به شما پیشنهاد داده است استفاده نکنید. در این صورت احتمال سرقت حساب شما وجود دارد.';

  @override
  String get emailConfirmHelp => 'کمک با تائید ایمیل';

  @override
  String get emailConfirmNotReceived => 'آیا ایمیل تائید بعد از ثبت نام را دریافت نکرده اید؟';

  @override
  String get whatSignupUsername => 'از چه نام کاربری برای ثبت نام استفاده کردید؟';

  @override
  String usernameNotFound(String param) {
    return 'ما هیچ کابری با این نام نیافتیم: $param.';
  }

  @override
  String get usernameCanBeUsedForNewAccount => 'شما می توانید از این نام کاربری برای ایجاد یک حساب کاربری جدید استفاده کنید';

  @override
  String emailSent(String param) {
    return 'ما یک ایمیل به آدرس $param ارسال کرده ایم.';
  }

  @override
  String get emailCanTakeSomeTime => 'ممکن است کمی طول بکشد تا برسد.';

  @override
  String get refreshInboxAfterFiveMinutes => '5 دقیقه صبر کنید و صندوق ورودی ایمیل خود را تازه کنید.';

  @override
  String get checkSpamFolder => 'پوشه هرزنامه خود را نیز بررسی کنید، ممکن است در آنجا باشد. اگر چنین است، آن را به عنوان غیر هرزنامه علامت‌گذاری کنید.';

  @override
  String get emailForSignupHelp => 'اگر تمام موارد ناموفق بود، این ایمیل را برای ما ارسال کنید:';

  @override
  String copyTextToEmail(String param) {
    return 'متن بالا را کپی و پیست کرده و به آدرس زیر ارسال کنید $param';
  }

  @override
  String get waitForSignupHelp => 'ما به زودی با شما تماس خواهیم گرفت تا به شما کمک کنیم ثبت نام خود را تکمیل کنید.';

  @override
  String accountConfirmed(String param) {
    return 'کاربر با نام $param با موفقیت تایید شده است.';
  }

  @override
  String accountCanLogin(String param) {
    return 'شما می توانید همین الان با نام $param وارد شوید.';
  }

  @override
  String get accountConfirmationEmailNotNeeded => 'شما نیازی به ایمیل تایید ندارید.';

  @override
  String accountClosed(String param) {
    return 'حساب کاربری $param بسته شده است.';
  }

  @override
  String accountRegisteredWithoutEmail(String param) {
    return 'حساب کاربری $param بدون ایمیل ثبت نام شده بود.';
  }

  @override
  String get rank => 'رتبه';

  @override
  String rankX(String param) {
    return 'رتبه:$param';
  }

  @override
  String get gamesPlayed => 'تعداد بازی های انجام شده';

  @override
  String get cancel => 'لغو';

  @override
  String get whiteTimeOut => 'زمان سفید تمام شد';

  @override
  String get blackTimeOut => 'زمان سیاه تمام شد';

  @override
  String get drawOfferSent => 'پیشنهاد تساوی ارسال شد';

  @override
  String get drawOfferAccepted => 'پیشنهاد تساوی پذیرفته شد';

  @override
  String get drawOfferCanceled => 'پیشنهاد تساوی لغو شد';

  @override
  String get whiteOffersDraw => 'سفید پیشنهاد تساوی می دهد';

  @override
  String get blackOffersDraw => 'سیاه پیشنهاد تساوی می دهد';

  @override
  String get whiteDeclinesDraw => 'سفید تساوی را نمی پذیرد';

  @override
  String get blackDeclinesDraw => 'سیاه تساوی را نمی پذیرد';

  @override
  String get yourOpponentOffersADraw => 'حریف شما پیشنهاد تساوی می دهد';

  @override
  String get accept => 'پذیرفتن';

  @override
  String get decline => 'رد کردن';

  @override
  String get playingRightNow => 'بازی در حال انجام';

  @override
  String get eventInProgress => 'بازی در حال انجام';

  @override
  String get finished => 'تمام شده';

  @override
  String get abortGame => 'انصراف از بازی';

  @override
  String get gameAborted => 'بازی لغو شد';

  @override
  String get standard => 'استاندارد';

  @override
  String get customPosition => 'وضعیت به‌دلخواه';

  @override
  String get unlimited => 'نامحدود';

  @override
  String get mode => 'نوع';

  @override
  String get casual => 'غیر رسمی';

  @override
  String get rated => 'رسمی';

  @override
  String get casualTournament => 'غیر رسمی';

  @override
  String get ratedTournament => 'رسمی';

  @override
  String get thisGameIsRated => 'این بازی رسمی است';

  @override
  String get rematch => 'بازی دوباره';

  @override
  String get rematchOfferSent => 'درخواست بازی دوباره فرستاده شد';

  @override
  String get rematchOfferAccepted => 'درخواست بازی دوباره پذیرفته شد';

  @override
  String get rematchOfferCanceled => 'پیشنهاد بازی دوباره لغو شد';

  @override
  String get rematchOfferDeclined => 'پیشنهاد بازی دوباره رد شد';

  @override
  String get cancelRematchOffer => 'لغو کردن پیشنهاد بازی دوباره';

  @override
  String get viewRematch => 'بازتماشای بازی';

  @override
  String get confirmMove => 'تایید حرکت';

  @override
  String get play => 'بازی';

  @override
  String get inbox => 'صندوق پیام';

  @override
  String get chatRoom => 'گپ‌سرا';

  @override
  String get loginToChat => 'برای گپ زدن، وارد حساب‌تان شوید';

  @override
  String get youHaveBeenTimedOut => 'زمان شما به پایان رسید.';

  @override
  String get spectatorRoom => 'اتاق تماشاچیان';

  @override
  String get composeMessage => 'نوشتن پیام';

  @override
  String get subject => 'عنوان';

  @override
  String get send => 'ارسال';

  @override
  String get incrementInSeconds => 'پاداش زمانی(به ثانیه)';

  @override
  String get freeOnlineChess => 'شطرنج بَرخط رایگان';

  @override
  String get exportGames => 'برون‏بُرد بازی‌ها';

  @override
  String get ratingRange => 'محدوده درجه‌بندی';

  @override
  String get thisAccountViolatedTos => 'این حساب قوانین را نقض کرده است';

  @override
  String get openingExplorerAndTablebase => 'جستجوگر گشایش و آخربازی';

  @override
  String get takeback => 'پس گرفتن حرکت';

  @override
  String get proposeATakeback => 'پیشنهاد پس گرفتن حرکت';

  @override
  String get takebackPropositionSent => 'پیشنهاد پس گرفتن حرکت فرستاده شد';

  @override
  String get takebackPropositionDeclined => 'پیشنهاد پس گرفتن حرکت رد شد';

  @override
  String get takebackPropositionAccepted => 'پیشنهاد پس گرفتن حرکت پذیرفته شد';

  @override
  String get takebackPropositionCanceled => 'پیشنهاد پس گرفتن حرکت لغو شد';

  @override
  String get yourOpponentProposesATakeback => 'حریف پیشنهاد پس گرفتن حرکت می دهد';

  @override
  String get bookmarkThisGame => 'نشان گذاری بازی';

  @override
  String get tournament => 'مسابقه';

  @override
  String get tournaments => 'مسابقات';

  @override
  String get tournamentPoints => 'مجموع امتیازات مسابقات';

  @override
  String get viewTournament => 'مشاهده مسابقات';

  @override
  String get backToTournament => 'برگشت به مسابقه';

  @override
  String get noDrawBeforeSwissLimit => 'شما نمی‌توانید در مسابقات سوییس تا قبل از حرکت ۳۰ام بازی را مساوی کنید.';

  @override
  String get thematic => 'واریانتی';

  @override
  String yourPerfRatingIsProvisional(String param) {
    return 'درجه‌بندی $param شما موقتی است';
  }

  @override
  String yourPerfRatingIsTooHigh(String param1, String param2) {
    return 'درجه‌بندی $param1 شما ($param2) بیش از حد بالاست';
  }

  @override
  String yourTopWeeklyPerfRatingIsTooHigh(String param1, String param2) {
    return 'درجه‌بندی $param1 هفتگی‌تان ($param2) بیش از حد بالاست';
  }

  @override
  String yourPerfRatingIsTooLow(String param1, String param2) {
    return 'درجه‌بندی $param1 شما ($param2) بیش از حد پایین است';
  }

  @override
  String ratedMoreThanInPerf(String param1, String param2) {
    return 'امتیاز $param2 بالاتر از $param1 لازم است.';
  }

  @override
  String ratedLessThanInPerf(String param1, String param2) {
    return 'برای ورود،امتیاز$param2 شما باید کمتر از$param1 باشد.';
  }

  @override
  String mustBeInTeam(String param) {
    return 'باید در تیم $param باشید';
  }

  @override
  String youAreNotInTeam(String param) {
    return 'شما در تیم $param نیستید';
  }

  @override
  String get backToGame => 'بازگشت به بازی';

  @override
  String get siteDescription => 'شطرنج آنلاین رایگان. همین حالا شطرنج بازی کنید. بدون نیاز به ثبت نام، بدون تبلیغات، بدون نیاز به افزونه. بازی با کامپیوتر، دوستان و یا حریفان تصادفی.';

  @override
  String xJoinedTeamY(String param1, String param2) {
    return '$param1 به تیم $param2 پیوست';
  }

  @override
  String xCreatedTeamY(String param1, String param2) {
    return '$param1 تیم $param2 را ایجاد کرد';
  }

  @override
  String get startedStreaming => 'شروع به استریم کرده است';

  @override
  String xStartedStreaming(String param) {
    return '$param شروع به استریم کرده است';
  }

  @override
  String get averageElo => 'میانگین درجه‌بندی';

  @override
  String get location => 'محل';

  @override
  String get filterGames => 'دستچین کردن بازی‌ها';

  @override
  String get reset => 'تنظیم مجدد';

  @override
  String get apply => 'تایید';

  @override
  String get save => 'ذخیره';

  @override
  String get leaderboard => 'جدول رده‌بندی';

  @override
  String get screenshotCurrentPosition => 'از وضعیت فعلی نماگرفت بگیرید';

  @override
  String get gameAsGIF => 'بارگیری GIF بازی';

  @override
  String get pasteTheFenStringHere => 'پوزیشن دلخواه(FEN) را در این قسمت وارد کنید';

  @override
  String get pasteThePgnStringHere => 'متن PGN را در این قسمت وارد کنید';

  @override
  String get orUploadPgnFile => 'یا یک فایل PGN بارگذاری کنید';

  @override
  String get fromPosition => 'شروع از پوزیشن';

  @override
  String get continueFromHere => 'از اینجا ادامه دهید';

  @override
  String get toStudy => 'مطالعه';

  @override
  String get importGame => 'بارگذاری بازی';

  @override
  String get importGameExplanation => 'برای دریافت بازپخش مرورپذیر، واکاوی رایانه‌ای، گپ‌های بازی، و وب‌نشانی همگانی همرسانی‌پذیر، PGN یک بازی را جای‌گذاری کنید.';

  @override
  String get importGameCaveat => 'تغییرات پاک خواهند شد. برای حفظ آنها، PGN را از طریق مطالعه وارد کنید.';

  @override
  String get importGameDataPrivacyWarning => 'این PGN برای عموم در دسترس است، برای وارد کردن یک بازی خصوصی، از *مطالعه* استفاده کنید.';

  @override
  String get thisIsAChessCaptcha => 'این یک کپچا [کد امنیتی] شطرنجی است';

  @override
  String get clickOnTheBoardToMakeYourMove => 'برای اثبات اینکه کامپیوتر نیستید، روی صفحه کلیک کنید تا حرکت خود را انجام دهید';

  @override
  String get captcha_fail => 'لطفا captcha را حل کنید';

  @override
  String get notACheckmate => 'این یک کیش و مات نیست';

  @override
  String get whiteCheckmatesInOneMove => 'سفید در یک حرکت مات می‌کند';

  @override
  String get blackCheckmatesInOneMove => 'سیاه در یک حرکت مات می‌کند';

  @override
  String get retry => 'تلاش دوباره';

  @override
  String get reconnecting => 'در حال اتصال دوباره';

  @override
  String get noNetwork => 'بُرون‌خط';

  @override
  String get favoriteOpponents => 'رقبای مورد علاقه';

  @override
  String get follow => 'دنبال کردن';

  @override
  String get following => 'افرادی که دنبال می کنید';

  @override
  String get unfollow => 'لغو دنبال کردن';

  @override
  String followX(String param) {
    return 'دنبال کردن $param';
  }

  @override
  String unfollowX(String param) {
    return 'لغو دنبال کردن $param';
  }

  @override
  String get block => 'مسدود کن';

  @override
  String get blocked => 'مسدود شده';

  @override
  String get unblock => 'لغو انسداد';

  @override
  String get followsYou => 'افرادی که شما را دنبال می کنند';

  @override
  String xStartedFollowingY(String param1, String param2) {
    return '$param1 $param2 را فالو کرد';
  }

  @override
  String get more => 'بیشتر';

  @override
  String get memberSince => 'عضویت از تاریخ';

  @override
  String lastSeenActive(String param) {
    return 'آخرین ورود $param';
  }

  @override
  String get player => 'بازیکن';

  @override
  String get list => 'فهرست';

  @override
  String get graph => 'نمودار';

  @override
  String get required => 'مورد نیاز است';

  @override
  String get openTournaments => 'باز کردن مسابقه';

  @override
  String get duration => 'مدت';

  @override
  String get winner => 'برنده';

  @override
  String get standing => 'رتبه بندی';

  @override
  String get createANewTournament => 'درست کردن یک مسابقه ی جدید';

  @override
  String get tournamentCalendar => 'برنامه ی مسابقات';

  @override
  String get conditionOfEntry => 'شرایط ورود:';

  @override
  String get advancedSettings => 'تنظیمات پیشرفته';

  @override
  String get safeTournamentName => 'یک نام بسیار امن برای مسابقات انتخاب کنید.';

  @override
  String get inappropriateNameWarning => 'هرچیز حتی کمی نامناسب ممکن است باعث بسته شدن حساب کاربری شما بشود.';

  @override
  String get emptyTournamentName => 'این مکان را خالی بگذارید تا به صورت تصادفی اسم یک استاد بزرگ برای مسابقات انتخاب شود.';

  @override
  String get makePrivateTournament => 'تورنومنت را به حالت خصوصی در بیاورید و دسترسی را محدود به داشتن پسورد کنید';

  @override
  String get join => 'ملحق شدن';

  @override
  String get withdraw => 'منصرف شدن';

  @override
  String get points => 'امتیازها';

  @override
  String get wins => 'بردها';

  @override
  String get losses => 'باخت‌ها';

  @override
  String get createdBy => 'ساخته شده توسط';

  @override
  String get tournamentIsStarting => 'مسابقه در حال شروع است';

  @override
  String get tournamentPairingsAreNowClosed => 'تعین حریف به اتمام رسیده است.';

  @override
  String standByX(String param) {
    return 'حریف $param است،آماده باشید!';
  }

  @override
  String get pause => 'توقف';

  @override
  String get resume => 'ادامه دادن';

  @override
  String get youArePlaying => 'شما بازی میکنید!';

  @override
  String get winRate => 'درصد برد';

  @override
  String get berserkRate => 'میزان جنون';

  @override
  String get performance => 'عملکرد';

  @override
  String get tournamentComplete => 'مسابقات به پایان رسید';

  @override
  String get movesPlayed => 'حرکات انجام شده';

  @override
  String get whiteWins => 'پیروزی با مهره سفید';

  @override
  String get blackWins => 'سیاه برنده شد';

  @override
  String get drawRate => 'نرخ تساوی';

  @override
  String get draws => 'مساوی';

  @override
  String nextXTournament(String param) {
    return 'مسابقه ی $param بعدی:';
  }

  @override
  String get averageOpponent => 'میانگین امتیاز حریف ها';

  @override
  String get boardEditor => 'مُهره‌چینی';

  @override
  String get setTheBoard => 'مهره‌ها را بچینید';

  @override
  String get popularOpenings => 'گشایش‌های محبوب';

  @override
  String get endgamePositions => 'آخربازی';

  @override
  String chess960StartPosition(String param) {
    return 'پوزیشن ابتدایی شطرنج960: $param';
  }

  @override
  String get startPosition => 'موقعیت شروع';

  @override
  String get clearBoard => 'پاک کردن صفحه';

  @override
  String get loadPosition => 'بارگذاری موقعیت';

  @override
  String get isPrivate => 'خصوصی';

  @override
  String reportXToModerators(String param) {
    return 'گزارش $param به مدیران سایت';
  }

  @override
  String profileCompletion(String param) {
    return 'میزان تکمیل رُخ‌نما: $param';
  }

  @override
  String xRating(String param) {
    return 'درجه‌‏بندی $param';
  }

  @override
  String get ifNoneLeaveEmpty => 'اگر ندارید، خالی گذارید';

  @override
  String get profile => 'رُخ‌نما';

  @override
  String get editProfile => 'ویرایش رُخ‌نما';

  @override
  String get realName => 'نام راستین';

  @override
  String get setFlair => 'تعیین کردن شکلک';

  @override
  String get flair => 'نشان';

  @override
  String get youCanHideFlair => 'تنظیماتی برای مخفی کردن همه شکلک‌های کاربر در کل ویگاه وجود دارد.';

  @override
  String get biography => 'شرح‌حال';

  @override
  String get countryRegion => 'کشور یا منطقه';

  @override
  String get thankYou => 'ممنون!';

  @override
  String get socialMediaLinks => 'لینک های رسانه های اجتماعی';

  @override
  String get oneUrlPerLine => 'یک نشانی در هر خط.';

  @override
  String get inlineNotation => 'نشانه‌گذاری خطی';

  @override
  String get makeAStudy => 'برای نگهداری مطمئن و اشتراک‌گذاری، ایجاد یک مطالعه را در نظر بگیرید.';

  @override
  String get clearSavedMoves => 'حرکت های واضح';

  @override
  String get previouslyOnLichessTV => 'بازی پیشین در Lichess';

  @override
  String get onlinePlayers => 'بازیکنان بَرخط';

  @override
  String get activePlayers => 'بازیکنان فعال';

  @override
  String get bewareTheGameIsRatedButHasNoClock => 'مراقب باشید،این بازی رتبه بندی میشود اما بدون ساعت!';

  @override
  String get success => 'موفق شدید';

  @override
  String get automaticallyProceedToNextGameAfterMoving => 'حرکت کردن اتوماتیک برای بازی بعدی بعد از حرکت کردن';

  @override
  String get autoSwitch => 'تعویض خودکار';

  @override
  String get puzzles => 'معماها';

  @override
  String get onlineBots => 'ربات‌های بَرخط';

  @override
  String get name => 'نام';

  @override
  String get description => 'شرح';

  @override
  String get descPrivate => 'توضیحات خصوصی';

  @override
  String get descPrivateHelp => 'متنی که فقط اعضای تیم مشاهده خواهند کرد. در صورت تعیین، جایگزین توضیحات عمومی برای اعضای تیم خواهد شد.';

  @override
  String get no => 'نه';

  @override
  String get yes => 'بله';

  @override
  String get help => 'راهنما:';

  @override
  String get createANewTopic => 'ایجاد یک موضوع جدید';

  @override
  String get topics => 'مباحث';

  @override
  String get posts => 'پست ها';

  @override
  String get lastPost => 'آخرین ارسال';

  @override
  String get views => 'نمایش ها';

  @override
  String get replies => 'پاسخ ها';

  @override
  String get replyToThisTopic => 'پاسخ به این موضوع';

  @override
  String get reply => 'پاسخ';

  @override
  String get message => 'پیام';

  @override
  String get createTheTopic => 'ایجاد موضوع';

  @override
  String get reportAUser => 'گزارش یک کاربر';

  @override
  String get user => 'کاربر';

  @override
  String get reason => 'دلیل';

  @override
  String get whatIsIheMatter => 'موضوع';

  @override
  String get cheat => 'تقلب';

  @override
  String get troll => 'ترول';

  @override
  String get other => 'موضوعات دیگر';

  @override
  String get reportDescriptionHelp => 'لینک بازی های این کاربر را قرار دهید و توضیع دهید خطای رفتار این بازیکن چه بوده است';

  @override
  String get error_provideOneCheatedGameLink => 'لطفآ حداقل یک نمونه تقلب در بازی را مطرح کنید.';

  @override
  String by(String param) {
    return 'توسط $param';
  }

  @override
  String importedByX(String param) {
    return '$param آن را وارد کرده';
  }

  @override
  String get thisTopicIsNowClosed => 'این موضوع بسته شده است';

  @override
  String get blog => 'بلاگ';

  @override
  String get notes => 'یادداشت ها';

  @override
  String get typePrivateNotesHere => 'یادداشت خصوصی را اینجا وارد کنید';

  @override
  String get writeAPrivateNoteAboutThisUser => 'یک یادداشت خصوصی درباره این کاربر بنویسید';

  @override
  String get noNoteYet => 'تا الان، بدون یادداشت';

  @override
  String get invalidUsernameOrPassword => 'نام کاربری یا رمز عبور نادرست است';

  @override
  String get incorrectPassword => 'رمزعبور اشتباه';

  @override
  String get invalidAuthenticationCode => 'کد اصالت سنجی نامعتبر';

  @override
  String get emailMeALink => 'یک لینک به من ایمیل کنید';

  @override
  String get currentPassword => 'رمز جاری';

  @override
  String get newPassword => 'رمز جدید';

  @override
  String get newPasswordAgain => '(رمز جدید(برای دومین بار';

  @override
  String get newPasswordsDontMatch => 'کلمه‌های عبور وارد شده مطابقت ندارند';

  @override
  String get newPasswordStrength => 'استحکام کلمه عبور';

  @override
  String get clockInitialTime => 'مقدار زمان اولیه';

  @override
  String get clockIncrement => 'مقدار زمان اضافی به ازای هر حرکت';

  @override
  String get privacy => 'حریم شخصی';

  @override
  String get privacyPolicy => 'سیاست حریم شخصی';

  @override
  String get letOtherPlayersFollowYou => 'بقیه بازیکنان شما را دنبال کنند';

  @override
  String get letOtherPlayersChallengeYou => 'اجازه دهید بازیکنان دیگر به شما پیشنهاد بازی دهند';

  @override
  String get letOtherPlayersInviteYouToStudy => 'اجازه دهید دیگر بازیکن شما را به مطالعه دعوت کنند';

  @override
  String get sound => 'صدا';

  @override
  String get none => 'هیچ کدام';

  @override
  String get fast => 'سریع';

  @override
  String get normal => 'متوسط';

  @override
  String get slow => 'آرام';

  @override
  String get insideTheBoard => 'در صفحه';

  @override
  String get outsideTheBoard => 'بیرون صفحه';

  @override
  String get allSquaresOfTheBoard => 'همه خانه‌های صفحه';

  @override
  String get onSlowGames => 'در بازی های آرام';

  @override
  String get always => 'همیشه';

  @override
  String get never => 'هرگز';

  @override
  String xCompetesInY(String param1, String param2) {
    return '$param1 در $param2 رقابت می‌کند.';
  }

  @override
  String get victory => 'پیروزی!';

  @override
  String get defeat => 'شکست!';

  @override
  String victoryVsYInZ(String param1, String param2, String param3) {
    return '$param1 مقابل $param2 در $param3';
  }

  @override
  String defeatVsYInZ(String param1, String param2, String param3) {
    return '$param1 vs $param2 in $param3';
  }

  @override
  String drawVsYInZ(String param1, String param2, String param3) {
    return '$param1 vs $param2 in $param3';
  }

  @override
  String get timeline => 'جدول زمانی';

  @override
  String get starting => 'شروع';

  @override
  String get allInformationIsPublicAndOptional => 'تمامی اطلاعات عمومی و اختیاری است.';

  @override
  String get biographyDescription => 'درباره ی خودتان بگویید - به چه چیزی در شطرنج علاقه داریدو گشایش ها - بازی ها و بازیکنان مورد علاقه تان…';

  @override
  String get listBlockedPlayers => 'لیست بازیکنانی که شما مسدود کرده اید';

  @override
  String get human => 'شخص واقعی';

  @override
  String get computer => 'رایانه';

  @override
  String get side => 'چه رنگی؟';

  @override
  String get clock => 'ساعت';

  @override
  String get opponent => 'حریف';

  @override
  String get learnMenu => 'یادگیری';

  @override
  String get studyMenu => 'مطالعه‌ها';

  @override
  String get practice => 'تمرین کردن';

  @override
  String get community => 'انجمن';

  @override
  String get tools => 'ابزارها';

  @override
  String get increment => 'افزایش زمان';

  @override
  String get error_unknown => 'مقدار نامعتبر';

  @override
  String get error_required => 'حتماً باید این خانه را پر کنید';

  @override
  String get error_email => 'آدرس ایمیل غیر معتبر است';

  @override
  String get error_email_acceptable => 'این آدرس ایمیل قابل قبول نیست. لطفا آدرس وارد شده را چک کنید و دوباره امتحان کنید.';

  @override
  String get error_email_unique => 'آدرس ایمیل نامعتبر است یا قبلا در سیستم ثبت شده است';

  @override
  String get error_email_different => 'اکنون، این نشانی رایانامه‌تان شما است';

  @override
  String error_minLength(String param) {
    return 'باید حداقل $param حرف داشته باشد';
  }

  @override
  String error_maxLength(String param) {
    return 'باید حداقل دارای $param حرف باشد';
  }

  @override
  String error_min(String param) {
    return 'باید حداقل $param باشد';
  }

  @override
  String error_max(String param) {
    return 'باید حداکثر $param باشد';
  }

  @override
  String ifRatingIsPlusMinusX(String param) {
    return 'اگر درجه‌بندی‌شان $param± است';
  }

  @override
  String get ifRegistered => 'اگر نام‌نویسی‌کرده';

  @override
  String get onlyExistingConversations => 'تنها مکالمات موجود';

  @override
  String get onlyFriends => 'فقط دوستان';

  @override
  String get menu => 'فهرست';

  @override
  String get castling => 'قلعه رفتن';

  @override
  String get whiteCastlingKingside => 'سفید O-O';

  @override
  String get blackCastlingKingside => 'سیاه O-O';

  @override
  String tpTimeSpentPlaying(String param) {
    return 'زمان بازی کردن: $param';
  }

  @override
  String get watchGames => 'تماشای بازی ها';

  @override
  String tpTimeSpentOnTV(String param) {
    return 'مدت زمان سپری شده در تلویزیون: $param';
  }

  @override
  String get watch => 'نگاه کردن';

  @override
  String get videoLibrary => 'فیلم ها';

  @override
  String get streamersMenu => 'بَرخَط-محتواسازها';

  @override
  String get mobileApp => 'برنامه ی موبایل';

  @override
  String get webmasters => 'وبداران';

  @override
  String get about => 'درباره ما';

  @override
  String aboutX(String param) {
    return 'درباره $param';
  }

  @override
  String xIsAFreeYLibreOpenSourceChessServer(String param1, String param2) {
    return '$param1 کاملا رایگان($param2)، آزاد، بدون تبلیغات و سرور متن باز است.';
  }

  @override
  String get really => 'واقعاً';

  @override
  String get contribute => 'مشارکت';

  @override
  String get termsOfService => 'قوانین';

  @override
  String get sourceCode => 'منبع کد لایچس';

  @override
  String get simultaneousExhibitions => 'نمایش هم زمان';

  @override
  String get host => 'میزبان';

  @override
  String hostColorX(String param) {
    return 'رنگ میزبان: $param';
  }

  @override
  String get yourPendingSimuls => 'بازی های سیمولتانه در جریان شما';

  @override
  String get createdSimuls => 'نمایش هم زمان  به تازگی ایجاد شده';

  @override
  String get hostANewSimul => 'میزبانی نمایش همزمان جدید';

  @override
  String get signUpToHostOrJoinASimul => 'ثبت‌نام کنید تا در بازی های سیمولتانه شرکت، یا برگزار کنید';

  @override
  String get noSimulFound => 'نمایش هم زمان پیدا نشد';

  @override
  String get noSimulExplanation => 'نمایش همزمان برای نمایش وجود ندارد';

  @override
  String get returnToSimulHomepage => 'برگشت به صحفه اصلی نمایش های همزمان';

  @override
  String get aboutSimul => 'نمایش هم زمان، بازی هم زمان یک نفر با چندین حریف است.';

  @override
  String get aboutSimulImage => 'از ۵۰ بازی فیشر موفق به کسب ۴۷ برد و ۲ تساوی و یک باخت شد.';

  @override
  String get aboutSimulRealLife => 'این مفهوم از رویدادهای واقعی الهام گرفته شده است. در آن جا میزبان میز به میز برای انجام حرکت خود، حرکت می کند.';

  @override
  String get aboutSimulRules => 'وقتی نمایش همزمان شروع شود، هر بازیکن یک بازی را با میزبان که با مهره سفید بازی میکند آغاز میکند. نمایش وقتی تمام می شود که تمام بازی ها تمام شده باشند.';

  @override
  String get aboutSimulSettings => 'نمایش های همزمان همیشه غیر رسمی هستند. بازی دوباره، پس گرفتن حرکت و اضافه کردن زمان غیرفعال شده اند.';

  @override
  String get create => 'ساختن';

  @override
  String get whenCreateSimul => 'وقتی یک نمایش همزمان ایجاد میکنید باید با چند نفر همزمان بازی کنید.';

  @override
  String get simulVariantsHint => 'اگر چندین گونه را انتخاب کنید، هر بازیکن می‌تواند انتخاب کند که کدام یک را بازی کند.';

  @override
  String get simulClockHint => 'تنظیم ساعت فیشر. هرچه از بازیکنان بیشتری برنده شوید، زمان بیشتری نیاز دارید';

  @override
  String get simulAddExtraTime => 'برای کمک به شما میتوانید برای خود زمان اضافی در نظر بگیرید.';

  @override
  String get simulHostExtraTime => 'زمان اضافی میزبان';

  @override
  String get simulAddExtraTimePerPlayer => 'به ازای پیوستن هر بازیکن، به زمان اولیه خود اضافه کنید.';

  @override
  String get simulHostExtraTimePerPlayer => 'زمان اضافه میزبان به ازای بازیکن';

  @override
  String get lichessTournaments => 'مسابقات لی چس';

  @override
  String get tournamentFAQ => 'سوالات متداول مسابقات';

  @override
  String get timeBeforeTournamentStarts => 'زمان باقی مانده به شروع مسابقه';

  @override
  String get averageCentipawnLoss => 'میانگین سرباز از دست داده';

  @override
  String get accuracy => 'دقت';

  @override
  String get keyboardShortcuts => 'میانبر های صفحه کلید';

  @override
  String get keyMoveBackwardOrForward => 'حرکت به عقب/جلو';

  @override
  String get keyGoToStartOrEnd => 'رفتن به آغاز/پایان';

  @override
  String get keyCycleSelectedVariation => 'چرخه شاخه اصلی انتخاب‌شده';

  @override
  String get keyShowOrHideComments => 'نمایش/ پنهان کردن نظرات';

  @override
  String get keyEnterOrExitVariation => 'ورود / خروج به شاخه';

  @override
  String get keyRequestComputerAnalysis => 'درخواست تحلیل رایانه‌ای، از اشتباه‌های‌تان بیاموزید';

  @override
  String get keyNextLearnFromYourMistakes => 'بعدی (از اشتباهات خود درس بگیرید)';

  @override
  String get keyNextBlunder => 'اشتباه فاحش بعدی';

  @override
  String get keyNextMistake => 'اشتباه بعدی';

  @override
  String get keyNextInaccuracy => 'بی‌دقتی بعدی';

  @override
  String get keyPreviousBranch => 'شاخه پیشین';

  @override
  String get keyNextBranch => 'شاخه بعدی';

  @override
  String get toggleVariationArrows => 'کلید پیکان‌های شاخه اصلی';

  @override
  String get cyclePreviousOrNextVariation => 'چرخه پیشین/پسین شاخه اصلی';

  @override
  String get toggleGlyphAnnotations => 'کلید علائم حرکت‌نویسی';

  @override
  String get togglePositionAnnotations => 'تغییر علائم حرکت‌نویسی';

  @override
  String get variationArrowsInfo => 'پیکان های شاخه اصلی به شما امکان می‌دهد بدون استفاده از فهرست حرکت، پیمایش کنید.';

  @override
  String get playSelectedMove => 'حرکت انتخاب شده را بازی کن';

  @override
  String get newTournament => 'مسابقه جدید';

  @override
  String get tournamentHomeTitle => 'مسابقات شطرنج با گونه‌ها و زمان‌بندی‌های مختلف';

  @override
  String get tournamentHomeDescription => 'هرچه سریع‌تر شطرنج بازی کنید! به یک مسابقه رسمی برنامه‌ریزی‌شده بپیوندید یا مسابقات خودتان را ایجاد کنید. شطرنج گلوله‌ای، برق‌آسا، مرسوم، ۹۶۰، پادشاه تپه‌ها، سه‌کیش و دیگر گزینه‌ها، برای لذت بی‌پایان از شطرنج در دسترس هستند.';

  @override
  String get tournamentNotFound => 'مسابقات یافت نشد';

  @override
  String get tournamentDoesNotExist => 'این مسابقات وجود ندارد';

  @override
  String get tournamentMayHaveBeenCanceled => 'ممکن است مسابقه لغو شده باشد,شاید همه ی بازیکنان مسابقه را قبل از شروع ترک کرده باشند';

  @override
  String get returnToTournamentsHomepage => 'بازگشت به صفحه اصلی مسابقات';

  @override
  String weeklyPerfTypeRatingDistribution(String param) {
    return 'توزیع درجه‌بندی $param هفتگی';
  }

  @override
  String yourPerfTypeRatingIsRating(String param1, String param2) {
    return 'درجه‌بندی $param1 شما $param2 است.';
  }

  @override
  String youAreBetterThanPercentOfPerfTypePlayers(String param1, String param2) {
    return 'شما بهتر از $param1 بازیکن ها در $param2 هستید.';
  }

  @override
  String userIsBetterThanPercentOfPerfTypePlayers(String param1, String param2, String param3) {
    return '$param1 بهتر از $param2 از بازیکنان $param3 میباشد.';
  }

  @override
  String betterThanPercentPlayers(String param1, String param2) {
    return 'بهتر از $param1 بازیکنان در $param2';
  }

  @override
  String youDoNotHaveAnEstablishedPerfTypeRating(String param) {
    return 'شما درجه‌بندی $param تثبیت‌شده‌ای ندارید.';
  }

  @override
  String get yourRating => 'درجه‌بندی شما';

  @override
  String get cumulative => 'تجمعی';

  @override
  String get glicko2Rating => 'درجه‌بندی Glicko-2';

  @override
  String get checkYourEmail => 'ایمیل خود را چک کنید';

  @override
  String get weHaveSentYouAnEmailClickTheLink => 'ما به شما ایمیل فرستادیم. روی لینکی که در ایمیل است کلیک کنید';

  @override
  String get ifYouDoNotSeeTheEmailCheckOtherPlaces => 'اگر رایانامه را نمی‌بینید، مکان‌های دیگری مانند پوشه‌های ناخواسته، هرزنامه، اجتماعی یا سایر موارد را بررسی کنید.';

  @override
  String weHaveSentYouAnEmailTo(String param) {
    return 'ایمیل ارسال شد.بر روی لینک داخل ایمیل کلیک کنید تا پسورد شما ریست شود $param  به آدرس';
  }

  @override
  String byRegisteringYouAgreeToBeBoundByOur(String param) {
    return 'با ثبت‌نام، با $param موافقت می‌کنید.';
  }

  @override
  String readAboutOur(String param) {
    return 'درباره $param ما بخوانید.';
  }

  @override
  String get networkLagBetweenYouAndLichess => 'تاخیر شبکه بین شما و Lichess';

  @override
  String get timeToProcessAMoveOnLichessServer => 'زمان سپری شده برای پردازش یک حرکت';

  @override
  String get downloadAnnotated => 'بارگیری حرکت‌نویسی';

  @override
  String get downloadRaw => 'بارگیری خام';

  @override
  String get downloadImported => 'بارگیری درونبُرد';

  @override
  String get crosstable => 'رودررو';

  @override
  String get youCanAlsoScrollOverTheBoardToMoveInTheGame => 'شما  می توانید برای حرکت در بازی از صفحه استفاده کنید';

  @override
  String get scrollOverComputerVariationsToPreviewThem => 'برای مشاهده آن ها اسکرول کنید.';

  @override
  String get analysisShapesHowTo => 'و کلیک کنید یا راست کلیک کنید تا دایره یا فلش در صفحه بکشید shift';

  @override
  String get letOtherPlayersMessageYou => 'ارسال پیام توسط بقیه به شما';

  @override
  String get receiveForumNotifications => 'دریافت اعلان در هنگام ذکر شدن در انجمن';

  @override
  String get shareYourInsightsData => 'اشتراک گذاشتن داده های شما';

  @override
  String get withNobody => 'هیچکس';

  @override
  String get withFriends => 'با دوستان';

  @override
  String get withEverybody => 'با همه';

  @override
  String get kidMode => 'حالت کودکان';

  @override
  String get kidModeIsEnabled => 'حالت کودک فعال است.';

  @override
  String get kidModeExplanation => 'این گزینه،امنیتی است.با فعال کردن حالت ((کودکانه))،همه ی ارتباطات(چت کردن و...)غیر فعال می شوند.با فعال کردن این گزینه،کودکان خود را محافطت کنید.';

  @override
  String inKidModeTheLichessLogoGetsIconX(String param) {
    return 'در حالت کودکانه،به نماد لیچس،یک $param اضافه می شود تا شما از فعال بودن آن مطلع شوید.';
  }

  @override
  String get askYourChessTeacherAboutLiftingKidMode => 'اکانت شما مدیریت شده است. برای برداشتن حالت کودک از معلم شطرنج خود درخواست کنید.';

  @override
  String get enableKidMode => 'فعال کردن حالت کودکانه';

  @override
  String get disableKidMode => 'غیر فعال کردن حالت کودکانه';

  @override
  String get security => 'امنیت';

  @override
  String get sessions => 'جلسات';

  @override
  String get revokeAllSessions => 'باطل کردن تمامی موارد';

  @override
  String get playChessEverywhere => 'همه جا شطرنج بازی کنید';

  @override
  String get asFreeAsLichess => 'رایگان به مانند لیچس';

  @override
  String get builtForTheLoveOfChessNotMoney => 'ساخته شده با عشق به شطرنج نه پول';

  @override
  String get everybodyGetsAllFeaturesForFree => 'همگی از مزایا بصورت رایگان استفاده می کنند';

  @override
  String get zeroAdvertisement => 'بدون تبلیغات';

  @override
  String get fullFeatured => 'با تمامی امکانات';

  @override
  String get phoneAndTablet => 'موبایل و تبلت';

  @override
  String get bulletBlitzClassical => 'گلوله‌ای، برق‌آسا، مرسوم';

  @override
  String get correspondenceChess => 'شطرنج مکاتبه ای';

  @override
  String get onlineAndOfflinePlay => 'بازی کردن بَرخط و بُرون‌خط';

  @override
  String get viewTheSolution => 'دیدن راهِ حل';

  @override
  String get followAndChallengeFriends => 'دنبال کردن و پیشنهاد بازی دادن به دوستان';

  @override
  String get gameAnalysis => 'تجزیه و تحلیلِ بازی';

  @override
  String xHostsY(String param1, String param2) {
    return '$param1 میزبان ها $param2';
  }

  @override
  String xJoinsY(String param1, String param2) {
    return '$param1 وارد می شود $param2';
  }

  @override
  String xLikesY(String param1, String param2) {
    return '$param1 می پسندد $param2';
  }

  @override
  String get quickPairing => 'رویارویی سریع';

  @override
  String get lobby => 'بازی های ایجادشده';

  @override
  String get anonymous => 'ناشناس';

  @override
  String yourScore(String param) {
    return 'امتیاز شما:$param';
  }

  @override
  String get language => 'زبان';

  @override
  String get background => 'زمینه';

  @override
  String get light => 'روشن';

  @override
  String get dark => 'تیره';

  @override
  String get transparent => 'شفاف';

  @override
  String get deviceTheme => 'طرح زمینه دستگاه';

  @override
  String get backgroundImageUrl => 'وب‌نشانی تصویر پس‌زمینه:';

  @override
  String get board => 'صفحه شطرنج';

  @override
  String get size => 'اندازه';

  @override
  String get opacity => 'کدری';

  @override
  String get brightness => 'درخشندگی';

  @override
  String get hue => 'فام';

  @override
  String get boardReset => 'بازنشاندن به رنگ‌های پیش‌فرض';

  @override
  String get pieceSet => 'نوع مهره';

  @override
  String get embedInYourWebsite => 'قرار دادن در وبگاه خود';

  @override
  String get usernameAlreadyUsed => 'این نام کاربری در حال حاضر انتخاب شده است.لطفا نام دیگری انتخاب کنید.';

  @override
  String get usernamePrefixInvalid => 'نام کاربری باید با حرف شروع شود.';

  @override
  String get usernameSuffixInvalid => 'نام کاربری باید با حرف یا شماره خاتمه یابد.';

  @override
  String get usernameCharsInvalid => 'نام کاربری فقط می تواند شامل حروف،اعداد،خط فاصله یا زیر خط(under line) باشد.';

  @override
  String get usernameUnacceptable => 'این نام کاربری قابل قبول نیست.';

  @override
  String get playChessInStyle => 'استایل شطرنج باز داشته باشید!';

  @override
  String get chessBasics => 'اصول شطرنج';

  @override
  String get coaches => 'مربی ها';

  @override
  String get invalidPgn => 'فایل PGN نامعتبر است';

  @override
  String get invalidFen => 'پوزیشن وارد شده نامعتبر است';

  @override
  String get custom => 'دلخواه';

  @override
  String get notifications => 'گزارش';

  @override
  String notificationsX(String param1) {
    return 'هشدار: $param1';
  }

  @override
  String perfRatingX(String param) {
    return 'درجه‌بندی: $param';
  }

  @override
  String get practiceWithComputer => 'تمرین با کامپیوتر';

  @override
  String anotherWasX(String param) {
    return 'حرکت مناسب دیگر $param بود';
  }

  @override
  String bestWasX(String param) {
    return 'بهترین حرکت $param بود';
  }

  @override
  String get youBrowsedAway => 'پوزیشن را به هم زدید!';

  @override
  String get resumePractice => 'ادامه تمرین';

  @override
  String get drawByFiftyMoves => 'بازی با قانون پنجاه حرکت مساوی شده است.';

  @override
  String get theGameIsADraw => 'بازی مساوی است.';

  @override
  String get computerThinking => 'کامپیوتر در حال محاسبه است...';

  @override
  String get seeBestMove => 'مشاهده بهترین حرکت';

  @override
  String get hideBestMove => 'پنهان کردن بهترین حرکت';

  @override
  String get getAHint => 'راهنمایی';

  @override
  String get evaluatingYourMove => 'در حال بررسی حرکت شما...';

  @override
  String get whiteWinsGame => 'سفید برنده شد';

  @override
  String get blackWinsGame => 'سیاه برنده شد';

  @override
  String get learnFromYourMistakes => 'از اشتباهات خود درس بگیرید';

  @override
  String get learnFromThisMistake => 'از این اشتباه درس بگیرید';

  @override
  String get skipThisMove => 'رد کردن این حرکت';

  @override
  String get next => 'بعدی';

  @override
  String xWasPlayed(String param) {
    return '$param بازی شد';
  }

  @override
  String get findBetterMoveForWhite => 'یه حرکت بهتر برای سفید پیدا کنید';

  @override
  String get findBetterMoveForBlack => 'یه حرکت بهتر برای سیاه پیدا کنید';

  @override
  String get resumeLearning => 'ادامه یادگیری';

  @override
  String get youCanDoBetter => 'شما می توانید حرکت بهتری انجام دهید!';

  @override
  String get tryAnotherMoveForWhite => 'برای سفید،حرکت دیگری را امتحان کنید';

  @override
  String get tryAnotherMoveForBlack => 'برای سیاه،حرکت دیگری را امتحان کنید';

  @override
  String get solution => 'راه حل';

  @override
  String get waitingForAnalysis => 'در انتظار برای آنالیز';

  @override
  String get noMistakesFoundForWhite => 'هیچ اشتباهی برای سفید مشاهده نشد';

  @override
  String get noMistakesFoundForBlack => 'هیچ اشتباهی برای سیاه مشاهده نشد';

  @override
  String get doneReviewingWhiteMistakes => 'اشتباهات سفید بررسی شد';

  @override
  String get doneReviewingBlackMistakes => 'اشتباهات سیاه بررسی شد.';

  @override
  String get doItAgain => 'دوباره';

  @override
  String get reviewWhiteMistakes => 'بررسی اشتباهات سفید';

  @override
  String get reviewBlackMistakes => 'بررسی اشتباهات سیاه';

  @override
  String get advantage => 'برتری';

  @override
  String get opening => 'گشایش';

  @override
  String get middlegame => 'وسط بازی';

  @override
  String get endgame => 'آخربازی';

  @override
  String get conditionalPremoves => 'پیش حرکت های شرطی';

  @override
  String get addCurrentVariation => 'اضافه کردن این نوع حرکات';

  @override
  String get playVariationToCreateConditionalPremoves => 'یک نوع حرکات را بازی کنید تا پیش حرکت های شرطی را بسازید';

  @override
  String get noConditionalPremoves => 'فاقد پیش حرکت های شرطی';

  @override
  String playX(String param) {
    return '$param را انجام دهید';
  }

  @override
  String get showUnreadLichessMessage => 'شما یک پیام خصوصی از Lichess دریافت کرده‌اید.';

  @override
  String get clickHereToReadIt => 'برای خواندن، این را بزنید';

  @override
  String get sorry => 'متاسفم :(';

  @override
  String get weHadToTimeYouOutForAWhile => 'شما برای مدتی مسدود شدید.';

  @override
  String get why => 'چرا؟';

  @override
  String get pleasantChessExperience => 'هدف ما مهیا ساختن تجربه لذت بخش شطرنج به همه افراد است.';

  @override
  String get goodPractice => 'به همین منظور، ما باید اطمینان حاصل کنیم که تمام بازیکنان تمرین خوب را دنبال میکنند.';

  @override
  String get potentialProblem => 'زمانی که مشکلی احتمالی شناسایی شد ، این پیام را نمایش می دهیم.';

  @override
  String get howToAvoidThis => 'چگونه از این امر جلوگیری کنیم؟';

  @override
  String get playEveryGame => 'هر بازی که استارت میزنید را بازی کنید.';

  @override
  String get tryToWin => 'در هر بازی برای پیروزی (یا حداقل تساوی) تلاش کنید.';

  @override
  String get resignLostGames => 'بازی های از دست رفته را انصراف دهید(نگذارید زمان تمام شود).';

  @override
  String get temporaryInconvenience => 'ما برای این مشکل موقت عذرخواهی می کنیم،';

  @override
  String get wishYouGreatGames => 'و برای شما بازیهای عالی در lichess.org آرزو می کنیم.';

  @override
  String get thankYouForReading => 'از اینکه متن را خواندید متشکریم!';

  @override
  String get lifetimeScore => 'امتیاز کل';

  @override
  String get currentMatchScore => 'امتیاز بازی فعلی';

  @override
  String get agreementAssistance => 'من تضمین میکنم که در حین بازی ها کمک نگیرم ( از انجین ، کتاب ، پایگاه داده یا شخصی دیگر)';

  @override
  String get agreementNice => 'من تضمین میکنم که همیشه به بازیکن های دیگر احترام بگذارم.';

  @override
  String agreementMultipleAccounts(String param) {
    return 'من موافقت می‌کنم که چندین اکانت برای خودم ایجاد نکنم(به جز دلایلی که در $param اشاره شده).';
  }

  @override
  String get agreementPolicy => 'من تضمین میکنم که به تمام قوانین و خط مشی های لیچس پایبند باشم .';

  @override
  String get searchOrStartNewDiscussion => 'جستجو یا شروع کردن مکالمه جدید';

  @override
  String get edit => 'ویرایش';

  @override
  String get bullet => 'گلوله‌ای';

  @override
  String get blitz => 'برق‌آسا';

  @override
  String get rapid => 'سریع';

  @override
  String get classical => 'کلاسیک';

  @override
  String get ultraBulletDesc => 'بازی‌های سرعتی دیوانه‌وار: کمتر از ۳۰ ثانیه';

  @override
  String get bulletDesc => 'بازی‌های خیلی سرعتی: کمتر از ۳ دقیقه';

  @override
  String get blitzDesc => 'بازی های سرعتی: ۳ تا ۸ دقیقه';

  @override
  String get rapidDesc => 'بازی های سریع: ۸ تا ۲۵ دقیقه';

  @override
  String get classicalDesc => 'بازی های کلاسیک : 25 دقیقه یا بیشتر';

  @override
  String get correspondenceDesc => 'بازی های مکاتبه ای : یک  یا چند روز برای هر حرکت';

  @override
  String get puzzleDesc => 'تمرین تاکتیک های شطرنج';

  @override
  String get important => 'مهم!';

  @override
  String yourQuestionMayHaveBeenAnswered(String param1) {
    return 'سوال شما ممکن است که از قبل پاسخی داشته باشد $param1';
  }

  @override
  String get inTheFAQ => 'در سوالات متداول باشد.';

  @override
  String toReportSomeoneForCheatingOrBadBehavior(String param1) {
    return 'برای گزارش دادن یک کاربر به علت تقلب یا بدرفتاری، $param1';
  }

  @override
  String get useTheReportForm => 'از فرم گزارش استفاده کنید.';

  @override
  String toRequestSupport(String param1) {
    return 'جهت درخواست پشتیبانی، $param1';
  }

  @override
  String get tryTheContactPage => 'با این صفحه ارتباط بگیرید.';

  @override
  String makeSureToRead(String param1) {
    return 'حتما $param1 را مطالعه کنید';
  }

  @override
  String get theForumEtiquette => 'آداب انجمن';

  @override
  String get thisTopicIsArchived => 'این موضوع بایگانی شده است و دیگر نمی توان به آن پاسخ داد.';

  @override
  String joinTheTeamXToPost(String param1) {
    return 'به $param1 ملحق شوید تا در این انجمن پست بگذارید';
  }

  @override
  String teamNamedX(String param1) {
    return 'تیم $param1';
  }

  @override
  String get youCannotPostYetPlaySomeGames => 'شما هنوز قادر به پست گذاشتن در انجمن نیستید. چند بازی انجام دهید!';

  @override
  String get subscribe => 'مشترک شدن';

  @override
  String get unsubscribe => 'لغو اشتراک';

  @override
  String mentionedYouInX(String param1) {
    return 'از شما در $param1 نام برده شد.';
  }

  @override
  String xMentionedYouInY(String param1, String param2) {
    return '$param1 اسم شما را در \"$param2\" ذکر کرده است.';
  }

  @override
  String invitedYouToX(String param1) {
    return 'شما به \"$param1\" دعوت شده اید.';
  }

  @override
  String xInvitedYouToY(String param1, String param2) {
    return '$param1 شما را به \"$param2\" دعوت کرده است.';
  }

  @override
  String get youAreNowPartOfTeam => 'شما در حال حاضر عضوی از تیم هستید.';

  @override
  String youHaveJoinedTeamX(String param1) {
    return 'شما به \"$param1\" پیوستید.';
  }

  @override
  String get someoneYouReportedWasBanned => 'شخصی که گزارش کردید مسدود شد';

  @override
  String get congratsYouWon => 'تبریک، شما برنده شدید!';

  @override
  String gameVsX(String param1) {
    return 'بازی در برابر $param1';
  }

  @override
  String resVsX(String param1, String param2) {
    return '$param1 در برابر $param2';
  }

  @override
  String get lostAgainstTOSViolator => 'شما در مقابل کسی که قوانین Lichess را نقض کرده، امتیاز درجه‌بندی از دست دادید';

  @override
  String refundXpointsTimeControlY(String param1, String param2) {
    return 'پس‌دادن: $param1 امتیاز به درجه‌بندی $param2.';
  }

  @override
  String get timeAlmostUp => 'زمان تقریباً تمام شده است!';

  @override
  String get clickToRevealEmailAddress => 'جهت مشاهده ایمیل کلیک کنید';

  @override
  String get download => 'بارگیری';

  @override
  String get coachManager => 'تنظیمات مربی';

  @override
  String get streamerManager => 'مدیریت پخش';

  @override
  String get cancelTournament => 'لغو مسابقه';

  @override
  String get tournDescription => 'توضیحات مسابقه';

  @override
  String get tournDescriptionHelp => 'نکته خاصی را می‌خواهید به شرکت‌کنندگان گویید؟ بکوشید کوتاه باشد. پیوندهای فرونشان موجودند:\n[name](https://url)';

  @override
  String get ratedFormHelp => 'بازی‌ها رسمی هستند\nو روی درجه‌بندی بازیکنان تاثیر می‌گذارند';

  @override
  String get onlyMembersOfTeam => 'تنها اعضای تیم';

  @override
  String get noRestriction => 'بدون محدودیت';

  @override
  String get minimumRatedGames => 'حداقل بازی های ریتد';

  @override
  String get minimumRating => 'حداقل درجه‌بندی';

  @override
  String get maximumWeeklyRating => 'حداکثر درجه‌بندی هفتگی';

  @override
  String positionInputHelp(String param) {
    return 'برای شروع هر بازی از یک پوزیشن مشخص یک FEN معتبر را جایگذاری کنید.\nاین عمل فقط برای بازی های استاندارد امکان پذیر است، نه با واریانت ها.\nشما می توانید $param را جهت ساخت یک پوزیشن FEN استفاده کنید و سپس اینجا جایگذاری کنید.\nبرای شروع بازی ها از وضعیت عادی ابتدایی خالی بگذارید.';
  }

  @override
  String get cancelSimul => 'بازی هم‌زمان (سیمولتانه) را لغو نمایید';

  @override
  String get simulHostcolor => 'رنگ مربوط به نمایش‌دهنده یا میزبان برای هر بازی';

  @override
  String get estimatedStart => 'زمان تقریبی شروع بازی';

  @override
  String simulFeatured(String param) {
    return 'نمایش در $param';
  }

  @override
  String simulFeaturedHelp(String param) {
    return 'بازی هم‌زمان خود را برای همه بر روی لینک $param نشان بدهید. برای دسترسی خصوصی آن را غیرفعال نمایید.';
  }

  @override
  String get simulDescription => 'توصیف بازی هم‌زمان';

  @override
  String get simulDescriptionHelp => 'آیا می‌خواهید مطلبی را به شرکت‌کنندگان بگویید؟';

  @override
  String markdownAvailable(String param) {
    return '$param برای کُدهای دستوری پیچیده‌تر در دسترس است.';
  }

  @override
  String get embedsAvailable => 'وب‌نشانی بازی یا وب‌نشانی فصل مطالعه را برای جاسازی آن، جایگذاری کنید.';

  @override
  String get inYourLocalTimezone => 'ذر منطقه زمانی شما';

  @override
  String get tournChat => 'چت مسابقه';

  @override
  String get noChat => 'بدون چت';

  @override
  String get onlyTeamLeaders => 'تنها مسئولان تیم';

  @override
  String get onlyTeamMembers => 'تنها اعضای تیم';

  @override
  String get navigateMoveTree => 'لیست درختی کلیدهای مربوط به جابجا شدن';

  @override
  String get mouseTricks => 'ترفندهای مربوط به موشواره';

  @override
  String get toggleLocalAnalysis => 'از سخت‌افزارِ رایانه خود برای بررسی استفاده نمایید';

  @override
  String get toggleAllAnalysis => 'از سخت‌افزارِ رایانه خود و از سرورهای سایت برای بررسی استفاده نمایید';

  @override
  String get playComputerMove => 'بهترین حرکت پیشنهادی توسط رایانه را انتخاب و بازی کنید';

  @override
  String get analysisOptions => 'امکاناتِ تجزیه و تحلیل';

  @override
  String get focusChat => 'تمرکز بر روی امکان چت و نوشتن در آن';

  @override
  String get showHelpDialog => 'نمایش این پنجره راهنما';

  @override
  String get reopenYourAccount => 'باز کردن مجدد حساب کاربری';

  @override
  String get closedAccountChangedMind => 'اگر حساب کاربری خود را مسدود کردید، اما بعد از آن نظرتان عوض شد، شما یک فرصت برای بازگرداندنِ حساب کاربری خود خواهید داشت.';

  @override
  String get onlyWorksOnce => 'پس از مسدودسازی حساب کاربری فقط یک بار امکان بازیابی آن خواهد بود.';

  @override
  String get cantDoThisTwice => 'اگر برای بار دوم حساب کاربری خود را مسدود سازید، هیچ راهی برای بازیابی آن وجود نخواهد داشت.';

  @override
  String get emailAssociatedToaccount => 'آدرس ایمیلی که به حساب کاربری مربوط شده است';

  @override
  String get sentEmailWithLink => 'ما یک ایمیل که حاوی یک لینک می‌باشد را به شما ارسال کرده‌ایم.';

  @override
  String get tournamentEntryCode => 'کد ورودی مسابقه';

  @override
  String get hangOn => 'صبر کن!';

  @override
  String gameInProgress(String param) {
    return 'شما یک بازی در حال انجام با $param دارید.';
  }

  @override
  String get abortTheGame => 'انصراف از بازی';

  @override
  String get resignTheGame => 'تسلیم';

  @override
  String get youCantStartNewGame => 'شما نمی توانید تا زمانی که این بازی تمام نشده بازی جدیدی آغاز کنید.';

  @override
  String get since => 'از وقتی که';

  @override
  String get until => 'تا وقتی که';

  @override
  String get lichessDbExplanation => 'بازی‌های رسمی برگزار شده در Lichess';

  @override
  String get switchSides => 'تعویض سمت';

  @override
  String get closingAccountWithdrawAppeal => 'با بستن حساب خود درخواست تجدید نظر خود را پس خواهید گرفت';

  @override
  String get ourEventTips => 'پیشنهادهای ما برای برگزاری رویدادها';

  @override
  String get instructions => 'راهنما';

  @override
  String get showMeEverything => 'همه چیز را به من نشان بده';

  @override
  String get lichessPatronInfo => 'لایچس یک خیریه و کاملا رایگان و نرم افزاری متن باز است. تمام هزینه های اجرا، توسعه و محتوا تنها بر پایه هدایای کاربران بنا شده است.';

  @override
  String get nothingToSeeHere => 'فعلا هیچی اینجا نیست.';

  @override
  String opponentLeftCounter(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'رقیب شما بازی را ترک کرده است. شما میتوانید بعد از $count ثانیه اعلام پیروزی کنید.',
      one: 'رقیب شما بازی را ترک کرده است. شما میتوانید بعد از $count ثانیه اعلام پیروزی کنید.',
      zero: 'رقیب شما بازی را ترک کرده است. شما میتوانید بعد از $count ثانیه اعلام پیروزی کنید.',
    );
    return '$_temp0';
  }

  @override
  String mateInXHalfMoves(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'در $count نیم‌حرکت مات می‌شود',
      one: 'در $count نیم‌حرکت مات می‌شود',
      zero: 'در $count نیم‌حرکت مات می‌شود',
    );
    return '$_temp0';
  }

  @override
  String nbBlunders(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count اشتباه بزرگ',
      one: '$count اشتباه بزرگ',
      zero: '$count اشتباه بزرگ',
    );
    return '$_temp0';
  }

  @override
  String nbMistakes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count اشتباه',
      one: '$count اشتباه',
      zero: '$count اشتباه',
    );
    return '$_temp0';
  }

  @override
  String nbInaccuracies(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count غیردقیق',
      one: '$count غیردقیق',
      zero: '$count غیردقیق',
    );
    return '$_temp0';
  }

  @override
  String nbPlayers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count بازیکن',
      one: '$count بازیکن',
      zero: '$count بازیکن',
    );
    return '$_temp0';
  }

  @override
  String nbGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count بازی',
      one: '$count بازی',
      zero: '$count بازی',
    );
    return '$_temp0';
  }

  @override
  String ratingXOverYGames(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ریتینگ در $param2 بازی',
      one: 'درجه‌بندی $count در $param2 بازی',
      zero: 'درجه‌بندی $count در $param2 بازی',
    );
    return '$_temp0';
  }

  @override
  String nbBookmarks(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count بازی مورد علاقه',
      one: '$count بازی مورد علاقه',
      zero: '$count بازی مورد علاقه',
    );
    return '$_temp0';
  }

  @override
  String nbDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count روز',
      one: '$count روز',
      zero: '$count روز',
    );
    return '$_temp0';
  }

  @override
  String nbHours(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ساعت',
      one: '$count ساعت',
      zero: '$count ساعت',
    );
    return '$_temp0';
  }

  @override
  String nbMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count دقیقه',
      one: '$count دقیقه',
      zero: '$count دقیقه',
    );
    return '$_temp0';
  }

  @override
  String rankIsUpdatedEveryNbMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'رتبه در هر $count دقیقه به‌روز می‌شود',
      one: 'رتبه در هر دقیقه به‌روز می‌شود',
      zero: 'رتبه در هر دقیقه به‌روز می‌شود',
    );
    return '$_temp0';
  }

  @override
  String nbPuzzles(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count معما',
      one: '$count معما',
      zero: '$count معما',
    );
    return '$_temp0';
  }

  @override
  String nbGamesWithYou(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count بازی با شما',
      one: '$count بازی با شما',
      zero: '$count بازی با شما',
    );
    return '$_temp0';
  }

  @override
  String nbRated(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count بازی رسمی',
      one: '$count بازی رسمی',
      zero: '$count بازی رسمی',
    );
    return '$_temp0';
  }

  @override
  String nbWins(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count برد',
      one: '$count برد',
      zero: '$count برد',
    );
    return '$_temp0';
  }

  @override
  String nbLosses(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count باخت',
      one: '$count باخت',
      zero: '$count باخت',
    );
    return '$_temp0';
  }

  @override
  String nbDraws(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count مساوی',
      one: '$count مساوی',
      zero: '$count مساوی',
    );
    return '$_temp0';
  }

  @override
  String nbPlaying(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count بازی در حال انجام',
      one: '$count بازی در حال انجام',
      zero: '$count بازی در حال انجام',
    );
    return '$_temp0';
  }

  @override
  String giveNbSeconds(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ثانیه اضافه کن',
      one: '$count ثانیه اضافه کن',
      zero: '$count ثانیه اضافه کن',
    );
    return '$_temp0';
  }

  @override
  String nbTournamentPoints(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'مجموع امتیازات مسابقات:$count',
      one: 'مجموع امتیازات مسابقات:$count',
      zero: 'مجموع امتیازات مسابقات:$count',
    );
    return '$_temp0';
  }

  @override
  String nbStudies(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count مطالعه',
      one: '$count مطالعه',
      zero: '$count مطالعه',
    );
    return '$_temp0';
  }

  @override
  String nbSimuls(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count سیمولتانه',
      one: '$count سیمولتانه',
      zero: '$count سیمولتانه',
    );
    return '$_temp0';
  }

  @override
  String moreThanNbRatedGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'بیشتر از $count بازی رسمی',
      one: 'بیشتر از $count بازی رسمی',
      zero: 'بیشتر از $count بازی رسمی',
    );
    return '$_temp0';
  }

  @override
  String moreThanNbPerfRatedGames(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'بیشتر از $count بازی رسمی $param2',
      one: 'بیشتر از $count بازی رسمی $param2',
      zero: 'بیشتر از $count بازی رسمی $param2',
    );
    return '$_temp0';
  }

  @override
  String needNbMorePerfGames(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'شما باید$count بازی رسمی$param2 انجام دهید.',
      one: 'شما باید$count بازی رسمی$param2 انجام دهید.',
      zero: 'شما باید$count بازی رسمی$param2 انجام دهید.',
    );
    return '$_temp0';
  }

  @override
  String needNbMoreGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'شما باید$count بازی رسمی دیگر انجام دهید.',
      one: 'شما باید$count بازی رسمی دیگر انجام دهید.',
      zero: 'شما باید$count بازی رسمی دیگر انجام دهید.',
    );
    return '$_temp0';
  }

  @override
  String nbImportedGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count بارگذاری شده',
      one: '$count بارگذاری شده',
      zero: '$count بارگذاری شده',
    );
    return '$_temp0';
  }

  @override
  String nbFriendsOnline(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count دوست بَرخط',
      one: '$count دوست بَرخط',
      zero: '$count دوست بَرخط',
    );
    return '$_temp0';
  }

  @override
  String nbFollowers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count دنبال کننده‌',
      one: '$count دنبال کننده‌',
      zero: '$count دنبال کننده‌',
    );
    return '$_temp0';
  }

  @override
  String nbFollowing(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count دنبال میکند',
      one: '$count دنبال می کند',
      zero: '$count دنبال می کند',
    );
    return '$_temp0';
  }

  @override
  String lessThanNbMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'کمتر از $count دقیقه',
      one: 'کمتر از $count دقیقه',
      zero: 'کمتر از $count دقیقه',
    );
    return '$_temp0';
  }

  @override
  String nbGamesInPlay(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count بازی در حال انجام است',
      one: '$count بازی در حال انجام است',
      zero: '$count بازی در حال انجام است',
    );
    return '$_temp0';
  }

  @override
  String maximumNbCharacters(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'حداکثر: $count حرف',
      one: 'حداکثر: $count حرف',
      zero: 'حداکثر: $count حرف',
    );
    return '$_temp0';
  }

  @override
  String blocks(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count مسدود شده',
      one: '$count مسدود شده',
      zero: '$count مسدود شده',
    );
    return '$_temp0';
  }

  @override
  String nbForumPosts(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count وبنوشته در انجمن',
      one: '$count وبنوشته در انجمن',
      zero: '$count وبنوشته در انجمن',
    );
    return '$_temp0';
  }

  @override
  String nbPerfTypePlayersThisWeek(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count بازیکن $param2 این هفته فعالیت داشته‌اند.',
      one: '$count بازیکن $param2 این هفته فعالیت داشته‌ است.',
      zero: '$count بازیکن $param2 این هفته فعالیت داشته‌ است.',
    );
    return '$_temp0';
  }

  @override
  String availableInNbLanguages(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'در $count  زبان‌ها موجود است',
      one: 'در $count  زبان‌ها موجود است',
      zero: 'در $count  زبان‌ها موجود است',
    );
    return '$_temp0';
  }

  @override
  String nbSecondsToPlayTheFirstMove(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ثانیه برای شروع اولین حرکت',
      one: '$count ثانیه برای شروع اولین حرکت',
      zero: '$count ثانیه برای شروع اولین حرکت',
    );
    return '$_temp0';
  }

  @override
  String nbSeconds(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ثانیه',
      one: '$count ثانیه',
      zero: '$count ثانیه',
    );
    return '$_temp0';
  }

  @override
  String andSaveNbPremoveLines(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'و پیش حرکت های $count را حفظ کنید',
      one: 'و پیش حرکت $count را حفظ کنید',
      zero: 'و پیش حرکت $count را حفظ کنید',
    );
    return '$_temp0';
  }

  @override
  String get stormMoveToStart => 'شروع کنید';

  @override
  String get stormYouPlayTheWhitePiecesInAllPuzzles => 'شما در همه معماها با مهره سفید بازی می‌کنید';

  @override
  String get stormYouPlayTheBlackPiecesInAllPuzzles => 'شما در همه معماها با مهره سیاه بازی می‌کنید';

  @override
  String get stormPuzzlesSolved => 'معما حل شد';

  @override
  String get stormNewDailyHighscore => 'رکورد جدید روزانه!';

  @override
  String get stormNewWeeklyHighscore => 'رکورد جدید هفتگی!';

  @override
  String get stormNewMonthlyHighscore => 'رکورد جدید ماهانه!';

  @override
  String get stormNewAllTimeHighscore => 'بالاترین امتیاز از ابتدا تا کنون!';

  @override
  String stormPreviousHighscoreWasX(String param) {
    return 'بالاترین امتیاز قبلی $param بود';
  }

  @override
  String get stormPlayAgain => 'دوباره بازی کن';

  @override
  String stormHighscoreX(String param) {
    return 'بالاترین امتیاز: $param';
  }

  @override
  String get stormScore => 'امتیاز';

  @override
  String get stormMoves => 'حرکت‌ها';

  @override
  String get stormAccuracy => 'دقت';

  @override
  String get stormCombo => 'توالی';

  @override
  String get stormTime => 'زمان';

  @override
  String get stormTimePerMove => 'زمان برای هر حرکت';

  @override
  String get stormHighestSolved => 'امتیازدارترین معمای حل‌شده';

  @override
  String get stormPuzzlesPlayed => 'معماهای بازی‌شده';

  @override
  String get stormNewRun => 'دور جدید (میانبر: Space)';

  @override
  String get stormEndRun => 'پایان‌دهی دور (میانبر: Enter)';

  @override
  String get stormHighscores => 'بالاترین امتیازها';

  @override
  String get stormViewBestRuns => 'مشاهده بهترین دورها';

  @override
  String get stormBestRunOfDay => 'بهترین دور روز';

  @override
  String get stormRuns => 'دورها';

  @override
  String get stormGetReady => 'آماده شوید!';

  @override
  String get stormWaitingForMorePlayers => 'در حال انتظار برای پیوستن بازیکنان بیشتر...';

  @override
  String get stormRaceComplete => 'مسابقه تمام شد!';

  @override
  String get stormSpectating => 'در حال تماشا';

  @override
  String get stormJoinTheRace => 'به مسابقه بپیوندید!';

  @override
  String get stormStartTheRace => 'شروع مسابقه';

  @override
  String stormYourRankX(String param) {
    return 'رتبه شما: $param';
  }

  @override
  String get stormWaitForRematch => 'برای بازی مجدد منتظر بمانید';

  @override
  String get stormNextRace => 'مسابقه بعدی';

  @override
  String get stormJoinRematch => 'پیوستن به بازی مجدد';

  @override
  String get stormWaitingToStart => 'در انتظار آغاز';

  @override
  String get stormCreateNewGame => 'ایجاد مسابقه جدید';

  @override
  String get stormJoinPublicRace => 'به یک مسابقه عمومی بپیوندید';

  @override
  String get stormRaceYourFriends => 'با دوستان خود مسابقه دهید';

  @override
  String get stormSkip => 'رد کردن';

  @override
  String get stormSkipHelp => 'در هر مسابقه می‌توانید یک حرکت را رد کنید:';

  @override
  String get stormSkipExplanation => 'این حرکت را رَد کنید تا توالی حرکات درست خود را حفظ کنید! در هر مسابقه فقط یک بار قابل استفاده است.';

  @override
  String get stormFailedPuzzles => 'معماهای ناموفق';

  @override
  String get stormSlowPuzzles => 'معماهای طولانی';

  @override
  String get stormSkippedPuzzle => 'معما با حرکت رَدشده';

  @override
  String get stormThisWeek => 'این هفته';

  @override
  String get stormThisMonth => 'این ماه';

  @override
  String get stormAllTime => 'از ابتدا تا کنون';

  @override
  String get stormClickToReload => 'برای بارگذاری مجدد، بزنید';

  @override
  String get stormThisRunHasExpired => 'وقت به پایان رسیده است!';

  @override
  String get stormThisRunWasOpenedInAnotherTab => 'این دور، در زبانه دیگری باز شده بود!';

  @override
  String stormXRuns(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count دور',
      one: 'یک دور',
      zero: 'یک دور',
    );
    return '$_temp0';
  }

  @override
  String stormPlayedNbRunsOfPuzzleStorm(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count دور از $param2 بازی شد',
      one: 'یک دور از $param2 بازی شد',
      zero: 'یک دور از $param2 بازی شد',
    );
    return '$_temp0';
  }

  @override
  String get streamerLichessStreamers => 'بَرخَط-محتواسازان Lichess';

  @override
  String get studyShareAndExport => 'همرسانی و برون‏بُرد';

  @override
  String get studyStart => 'شروع';
}
