import 'package:intl/intl.dart' as intl;

import 'l10n.dart';

/// The translations for Bengali Bangla (`bn`).
class AppLocalizationsBn extends AppLocalizations {
  AppLocalizationsBn([String locale = 'bn']) : super(locale);

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
  String get activityActivity => 'কার্যকলাপ';

  @override
  String get activityHostedALiveStream => 'একটি লাইভ স্ট্রিম হোষ্টেড করেছেন';

  @override
  String activityRankedInSwissTournament(String param1, String param2) {
    return 'পদমর্যাদা পেয়েছেন #$param1 এর ভেতর $param2';
  }

  @override
  String get activitySignedUp => 'Lichess.org সাইন আপ করুন';

  @override
  String activitySupportedNbMonths(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'সাপোর্ট করেছেন lichess.org সাইটকে $count মাসের জন্য $param2 হিসেবে',
      one: 'সাপোর্ট করেছেন lichess.org সাইটকে $count মাসের জন্য $param2 হিসেবে',
    );
    return '$_temp0';
  }

  @override
  String activityPracticedNbPositions(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'অভ্যস্ত $count অবস্থান গুলো করত $param2',
      one: 'অভ্যস্ত $count অবস্থান করত $param2',
    );
    return '$_temp0';
  }

  @override
  String activitySolvedNbPuzzles(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'সমাধান $count কৌশলগত ধাঁধাগুলো',
      one: 'সমাধান $count কৌশলগত ধাঁধা',
    );
    return '$_temp0';
  }

  @override
  String activityPlayedNbGames(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'খেলেছে $count $param2 খেলাগুলো',
      one: 'খেলেছে $count $param2 খেলা',
    );
    return '$_temp0';
  }

  @override
  String activityPostedNbMessages(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'পোস্ট করা হয়েছে $count বার্তাগুলো $param2',
      one: 'পোস্ট করা হয়েছে $count বার্তায় $param2',
    );
    return '$_temp0';
  }

  @override
  String activityPlayedNbMoves(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count মুভে খেলেছেন',
      one: '$count মুভে খেলেছেন',
    );
    return '$_temp0';
  }

  @override
  String activityInNbCorrespondenceGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count টি কোরেস্পন্ডিং গেমের মধ্যে',
      one: '$count টি কোরেস্পন্ডিং গেমের মধ্যে',
    );
    return '$_temp0';
  }

  @override
  String activityCompletedNbGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'সম্পন্ন হয়েছে $count সাদৃশ্য খেলাগুলো',
      one: 'সম্পন্ন হয়েছে $count সাদৃশ্য খেলা',
    );
    return '$_temp0';
  }

  @override
  String activityFollowedNbPlayers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'অনুসরণ শুরু করেছে $count খেলোয়াড়',
      one: 'অনুসরণ শুরু করেছে $count খেলোয়াড়',
    );
    return '$_temp0';
  }

  @override
  String activityGainedNbFollowers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'অর্জন করেছেন $count নতুন অনুসরন',
      one: 'অর্জন করেছেন $count নতুন অনুসরন',
    );
    return '$_temp0';
  }

  @override
  String activityHostedNbSimuls(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'হোস্টেড $count সমকালীন প্রদর্শনী',
      one: 'হোস্টেড $count সমকালীন প্রদর্শনী',
    );
    return '$_temp0';
  }

  @override
  String activityJoinedNbSimuls(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'অংশগ্রহণ করী $count সমকালীন প্রদর্শনী',
      one: 'অংশগ্রহণ করী $count সমকালীন প্রদর্শনী',
    );
    return '$_temp0';
  }

  @override
  String activityCreatedNbStudies(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'তৈরি হয়েছে $count নতুন গবেষণা',
      one: 'তৈরি হয়েছে $count নতুন গবেষণা',
    );
    return '$_temp0';
  }

  @override
  String activityCompetedInNbTournaments(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'প্রতিযোগিতায় $count সর্ম্পূন হয়েছে',
      one: 'প্রতিযোগিতায় $count সর্ম্পূন হয়েছে',
    );
    return '$_temp0';
  }

  @override
  String activityRankedInTournament(int count, String param2, String param3, String param4) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'অনুপাত #$count (সর্বোচ্চ $param2%) সাথে $param3 খেলায় $param4',
      one: 'অনুপাত #$count (সর্বোচ্চ $param2%) সাথে $param3 খেলায় $param4',
    );
    return '$_temp0';
  }

  @override
  String activityCompetedInNbSwissTournaments(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'সুইস টুর্নামেন্ট শেষ করেছেন $count এর ভেতর',
      one: 'সুইস টুর্নামেন্ট শেষ করেছেন $count এর ভেতর',
    );
    return '$_temp0';
  }

  @override
  String activityJoinedNbTeams(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'যুক্ত হয়েছে $count দল',
      one: 'যুক্ত হয়েছে $count দল',
    );
    return '$_temp0';
  }

  @override
  String get broadcastBroadcasts => 'সম্প্রচার';

  @override
  String get broadcastLiveBroadcasts => 'সরাসরি টুর্নামেন্ট সম্প্রচার';

  @override
  String challengeChallengesX(String param1) {
    return 'প্রতিদ্বন্দ্বীরা:$param1';
  }

  @override
  String get challengeChallengeToPlay => 'খেলার জন্য চ্যালেঞ্জ করুন';

  @override
  String get challengeChallengeDeclined => 'চ্যালেঞ্জ প্রত্যাখ্যান করা হয়েছে';

  @override
  String get challengeChallengeAccepted => 'চ্যালেঞ্জ গৃহীত হয়েছে!';

  @override
  String get challengeChallengeCanceled => 'চ্যালেঞ্জ বাতিল হয়েছে.';

  @override
  String get challengeRegisterToSendChallenges => 'চ্যালেঞ্জ করার জন্য একাউন্ট প্রয়োজন। দয়া করে নিবন্ধন করুন।.';

  @override
  String challengeYouCannotChallengeX(String param) {
    return 'আপনি $param কে চ্যালেঞ্জ করতে পারবেন না.';
  }

  @override
  String challengeXDoesNotAcceptChallenges(String param) {
    return '$param চ্যালেঞ্জ গ্রহন করেননি.';
  }

  @override
  String challengeYourXRatingIsTooFarFromY(String param1, String param2) {
    return 'আপনার $param1 রেটিংস এবং $param2 এর ব্যবধান অনেক.';
  }

  @override
  String challengeCannotChallengeDueToProvisionalXRating(String param) {
    return 'আপনার (provisional) রেটিংস $param এর জন্য চ্যালেঞ্জ গ্রহণ হবে না.';
  }

  @override
  String challengeXOnlyAcceptsChallengesFromFriends(String param) {
    return '$param শুধু বন্ধুদের থেকে চ্যালেঞ্জ গ্রহন করেন.';
  }

  @override
  String get challengeDeclineGeneric => 'দুঃখিত আমি এই মুহুর্তে কোনো চ্যালেঞ্জ গ্রহন করছি না.';

  @override
  String get challengeDeclineLater => 'আমার জন্য এখন উপযুক্ত সময় নয়, পরে জিজ্ঞাস করুন.';

  @override
  String get challengeDeclineTooFast => 'এই টাইম কন্ট্রোলের গেম আমার জন্য খুবই দ্রুত হয়ে যায়, অনুগ্রহ করে আরেকটু ধীর গতির গেম দিয়ে চ্যালেঞ্জ দিন.';

  @override
  String get challengeDeclineTooSlow => 'এই টাইম কন্ট্রলের গেম আমার জন্য খুবই ধীর গতির হয়ে যায়, অনুগ্রহ করে আরেকটু দ্রুত গতির গেম দিয়ে চেলেঞ্জ দিন.';

  @override
  String get challengeDeclineTimeControl => 'এই টাইম কন্ট্রল গেমে আমি চেলেঞ্জ গ্রহন করি না.';

  @override
  String get challengeDeclineRated => 'অনুগ্রহ পুর্বক আমাকে রেটেড গেমের চেলেঞ্জ দিন.';

  @override
  String get challengeDeclineCasual => 'অনুগ্রহ করে এর বদলে কেজুয়াল সিলেক্ট করে চেলেঞ্জ দিন.';

  @override
  String get challengeDeclineStandard => 'আমি এখন ভ্যারিয়েন্ট চ্যালেঞ্জ গ্রহন থেকে বিরত রয়েছি.';

  @override
  String get challengeDeclineVariant => 'ভেরিয়েন্ট গেম খেলতে ইচ্ছে করছে না এখন.';

  @override
  String get challengeDeclineNoBot => 'আমি এখন বোট থেকে চ্যালেঞ্জ গ্রহন থেকে বিরত রয়েছি.';

  @override
  String get challengeDeclineOnlyBot => 'আমি বর্তমানে শুধু বোট থেকে চ্যালেঞ্জ গ্রহন করছি.';

  @override
  String get challengeInviteLichessUser => 'অথবা একজন লিচেস ব্যবহারকারীকে আমন্ত্রণ জানান |:';

  @override
  String get contactContact => 'লাইকেস. আর. সি. / এর যোগাযোগের সংক্ষিপ্ত লিঙ্ক, হোমপেজে দৃশ্যমান';

  @override
  String get contactContactLichess => 'পৃষ্ঠার শিরোনাম lichess. org/contact';

  @override
  String get patronDonate => 'দান করুন';

  @override
  String get patronLichessPatron => 'Lichess অভিভাবক';

  @override
  String perfStatPerfStats(String param) {
    return '$param stats';
  }

  @override
  String get perfStatViewTheGames => 'View the games';

  @override
  String get perfStatProvisional => 'provisional';

  @override
  String get perfStatNotEnoughRatedGames => 'Not enough rated games have been played to establish a reliable rating.';

  @override
  String perfStatProgressOverLastXGames(String param) {
    return 'Progression over the last $param games:';
  }

  @override
  String perfStatRatingDeviation(String param) {
    return 'Rating deviation: $param.';
  }

  @override
  String perfStatRatingDeviationTooltip(String param1, String param2, String param3) {
    return 'Lower value means the rating is more stable. Above $param1, the rating is considered provisional. To be included in the rankings, this value should be below $param2 (standard chess) or $param3 (variants).';
  }

  @override
  String get perfStatTotalGames => 'মোট গেম';

  @override
  String get perfStatRatedGames => 'Rated games';

  @override
  String get perfStatTournamentGames => 'Tournament games';

  @override
  String get perfStatBerserkedGames => 'Berserked games';

  @override
  String get perfStatTimeSpentPlaying => 'Time spent playing';

  @override
  String get perfStatAverageOpponent => 'Average opponent';

  @override
  String get perfStatVictories => 'Victories';

  @override
  String get perfStatDefeats => 'Defeats';

  @override
  String get perfStatDisconnections => 'Disconnections';

  @override
  String get perfStatNotEnoughGames => 'Not enough games played';

  @override
  String perfStatHighestRating(String param) {
    return 'Highest rating: $param';
  }

  @override
  String perfStatLowestRating(String param) {
    return 'Lowest rating: $param';
  }

  @override
  String perfStatFromXToY(String param1, String param2) {
    return 'from $param1 to $param2';
  }

  @override
  String get perfStatWinningStreak => 'Winning streak';

  @override
  String get perfStatLosingStreak => 'Losing streak';

  @override
  String perfStatLongestStreak(String param) {
    return 'Longest streak: $param';
  }

  @override
  String perfStatCurrentStreak(String param) {
    return 'Current streak: $param';
  }

  @override
  String get perfStatBestRated => 'Best rated victories';

  @override
  String get perfStatGamesInARow => 'Games played in a row';

  @override
  String get perfStatLessThanOneHour => 'Less than one hour between games';

  @override
  String get perfStatMaxTimePlaying => 'Max time spent playing';

  @override
  String get perfStatNow => 'now';

  @override
  String get preferencesPreferences => 'পছন্দসমূহ';

  @override
  String get preferencesDisplay => 'ডিসপ্লে';

  @override
  String get preferencesPrivacy => 'গোপনীয়তা';

  @override
  String get preferencesNotifications => 'নোটিফিকেশন';

  @override
  String get preferencesPieceAnimation => 'গুটির অ্যানিমেশন';

  @override
  String get preferencesMaterialDifference => 'গুটির মধ্যে ব্যবধান';

  @override
  String get preferencesBoardHighlights => 'বোর্ডের বৈশিষ্ট সমূহ (শেষ চাল এবং পরীক্ষা)';

  @override
  String get preferencesPieceDestinations => 'টুকরো গন্তব্যস্থল (বৈধ চাল ও আবার চাল)';

  @override
  String get preferencesBoardCoordinates => 'বোর্ডের স্থানাংকর (A-H, 1-8)';

  @override
  String get preferencesMoveListWhilePlaying => 'খেলার সময় তালিকা সরান';

  @override
  String get preferencesPgnPieceNotation => 'প্রতীক চিহ্ন সরান';

  @override
  String get preferencesChessPieceSymbol => 'দাবার টুকরোর ধরন';

  @override
  String get preferencesPgnLetter => 'বর্ণ (কে, কিউ, আর, বি, এন)';

  @override
  String get preferencesZenMode => 'জেন মোড';

  @override
  String get preferencesShowPlayerRatings => 'Show player ratings';

  @override
  String get preferencesShowFlairs => 'Show player flairs';

  @override
  String get preferencesExplainShowPlayerRatings => 'This hides all ratings from Lichess, to help focus on the chess. Rated games still impact your rating, this is only about what you get to see.';

  @override
  String get preferencesDisplayBoardResizeHandle => 'Show board resize handle';

  @override
  String get preferencesOnlyOnInitialPosition => 'Only on initial position';

  @override
  String get preferencesInGameOnly => 'In-game only';

  @override
  String get preferencesChessClock => 'দাবার ঘড়ি';

  @override
  String get preferencesTenthsOfSeconds => 'সেকেন্ডের কাটা';

  @override
  String get preferencesWhenTimeRemainingLessThanTenSeconds => 'যখন সময় বাকি < 10 সেকেন্ড';

  @override
  String get preferencesHorizontalGreenProgressBars => 'সমতল সবুজ অগ্রগতি বার';

  @override
  String get preferencesSoundWhenTimeGetsCritical => 'যখন সময় জটিল হয়ে যায় শব্দ';

  @override
  String get preferencesGiveMoreTime => 'আরো কিছু সময় দিন';

  @override
  String get preferencesGameBehavior => 'Game behaviour';

  @override
  String get preferencesHowDoYouMovePieces => 'কিভাবে আপনি টুকরোগুলো সরাবেন?';

  @override
  String get preferencesClickTwoSquares => 'দুই স্থান নির্বাচন করুন';

  @override
  String get preferencesDragPiece => 'এক টুকরো স্থান্তর করুন';

  @override
  String get preferencesBothClicksAndDrag => 'উভয়ের';

  @override
  String get preferencesPremovesPlayingDuringOpponentTurn => 'পূনারয়চালন (প্রতিপক্ষের মোর নেওয়ার সময়)';

  @override
  String get preferencesTakebacksWithOpponentApproval => 'পিছনে নেও (প্রতিদ্বন্দ্বীর অনুমদনের সাথে)';

  @override
  String get preferencesInCasualGamesOnly => 'শুধু অনিয়মিত খেলার মধ্যে';

  @override
  String get preferencesPromoteToQueenAutomatically => 'সংক্রিয়ভাবে রানীর জন্য প্রচার';

  @override
  String get preferencesExplainPromoteToQueenAutomatically => 'Hold the <ctrl> key while promoting to temporarily disable auto-promotion';

  @override
  String get preferencesWhenPremoving => 'যখন পূনার‍য়সারান';

  @override
  String get preferencesClaimDrawOnThreefoldRepetitionAutomatically => 'সংক্রিয়ভাবে দাবি আঁকা বিষয়ে তিনগুন অনুবর্তন';

  @override
  String get preferencesWhenTimeRemainingLessThanThirtySeconds => 'যখন সময় বাকি < 30 সেকেন্ড';

  @override
  String get preferencesMoveConfirmation => 'অনুমোদন সরান';

  @override
  String get preferencesExplainCanThenBeTemporarilyDisabled => 'Can be disabled during a game with the board menu';

  @override
  String get preferencesInCorrespondenceGames => 'সাদৃশ্য খেলাগুলো';

  @override
  String get preferencesCorrespondenceAndUnlimited => 'সাদৃশ্য এবং সীমাহীন';

  @override
  String get preferencesConfirmResignationAndDrawOffers => 'পদত্যাগ নিশ্চিত করুন এবং অফার লুটে নিন';

  @override
  String get preferencesCastleByMovingTheKingTwoSquaresOrOntoTheRook => 'কাস্টলিং পদ্বতি';

  @override
  String get preferencesCastleByMovingTwoSquares => 'দুই বর্গে রাজা সরান';

  @override
  String get preferencesCastleByMovingOntoTheRook => 'দাবার নৌকার উপর দিয়ে রাজাকে সরান';

  @override
  String get preferencesInputMovesWithTheKeyboard => 'কী-বোর্ডের সাথে নিবেশ সরান';

  @override
  String get preferencesInputMovesWithVoice => 'Input moves with your voice';

  @override
  String get preferencesSnapArrowsToValidMoves => 'Snap arrows to valid moves';

  @override
  String get preferencesSayGgWpAfterLosingOrDrawing => 'Say \"Good game, well played\" upon defeat or draw';

  @override
  String get preferencesYourPreferencesHaveBeenSaved => 'আপনার পচ্ছন্দগুলি সংরক্ষিত করা হয়েছে.';

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
  String get puzzlePuzzles => 'পাজল';

  @override
  String get puzzlePuzzleThemes => 'পাজল থিম';

  @override
  String get puzzleRecommended => 'প্রস্তাবিত';

  @override
  String get puzzlePhases => 'পর্যায়';

  @override
  String get puzzleMotifs => 'বিষয়বস্তু';

  @override
  String get puzzleAdvanced => 'বিস্তারিত';

  @override
  String get puzzleLengths => 'দৈর্ঘ্য';

  @override
  String get puzzleMates => 'চেকমেট নিদর্শন';

  @override
  String get puzzleGoals => 'উদ্দেশ';

  @override
  String get puzzleOrigin => 'উত্স';

  @override
  String get puzzleSpecialMoves => 'বিশেশ চাল';

  @override
  String get puzzleDidYouLikeThisPuzzle => 'আপনি এই ধাঁধা তি কি পছন্দ করেছেন?';

  @override
  String get puzzleVoteToLoadNextOne => 'পরের ধাঁধা তি তে জেতে ভতে দিন!';

  @override
  String get puzzleUpVote => 'ধাঁধা কে আপ-ভোট করুন';

  @override
  String get puzzleDownVote => 'ধাঁধা কে ডাউন-ভোট করুন';

  @override
  String get puzzleYourPuzzleRatingWillNotChange => 'আপনার ধাঁধার রেটিং পরিবর্তীত হবে না। উল্লেখ্য, ধাঁধা প্রতিযোগীতামূলক নয়। আপনার রেটিং আপনার দক্ষতা অনুযায়ী ধাঁধা বাছাই করতে সাহায্য করে।';

  @override
  String get puzzleFindTheBestMoveForWhite => 'সাদার জন্নে সব থেকে উপযোগী চাল তি খুজে বার করুন।.';

  @override
  String get puzzleFindTheBestMoveForBlack => 'কালোর জন্নে সব থেকে উপযোগী চাল তি খুজে বার করুন।.';

  @override
  String get puzzleToGetPersonalizedPuzzles => 'আপনার ব্যাক্তিগত পাজল পেতে:';

  @override
  String puzzlePuzzleId(String param) {
    return 'ধাঁধা $param';
  }

  @override
  String get puzzlePuzzleOfTheDay => 'আজকের পাজল';

  @override
  String get puzzleDailyPuzzle => 'দৈনিক ধাঁধা';

  @override
  String get puzzleClickToSolve => 'সমাধানের জন্য ক্লিক করুন';

  @override
  String get puzzleGoodMove => 'ভালো মানের মুভ';

  @override
  String get puzzleBestMove => 'সেরা মানের মুভ!';

  @override
  String get puzzleKeepGoing => 'চালিয়ে যান…';

  @override
  String get puzzlePuzzleSuccess => 'সফল হয়েছে!';

  @override
  String get puzzlePuzzleComplete => 'পাজল সম্পন্ন!';

  @override
  String get puzzleByOpenings => 'ওপেনিং অনুযায়ী';

  @override
  String get puzzlePuzzlesByOpenings => 'ওপেনিং অনুযায়ী ধাঁধা';

  @override
  String get puzzleOpeningsYouPlayedTheMost => 'রেটেড খেলায় আপনি যে ওপেনিংগুলো সবথেকে বেশি খেলেছেন';

  @override
  String get puzzleUseFindInPage => 'আপনার প্রিয় ওপেনিংগুলি খুঁজতে ব্রাউসার মেনুতে \"ফাইন্ড ইন পেজ\" ব্যবহার করুন!';

  @override
  String get puzzleUseCtrlF => 'আপনার প্রিয় ওপেনিং খুঁজতে Ctrl + F ব্যবহার করুন!';

  @override
  String get puzzleNotTheMove => 'এটা সঠিক চাল না!';

  @override
  String get puzzleTrySomethingElse => 'অন্য কিছু চেষ্টা করুন.';

  @override
  String puzzleRatingX(String param) {
    return 'রেটিংস: $param';
  }

  @override
  String get puzzleHidden => 'লুকায়িত';

  @override
  String puzzleFromGameLink(String param) {
    return '$param খেলা থেকে';
  }

  @override
  String get puzzleContinueTraining => 'প্রশিক্ষন চালিয়ে যান';

  @override
  String get puzzleDifficultyLevel => 'কঠিনের মাত্রা';

  @override
  String get puzzleNormal => 'সাধারন';

  @override
  String get puzzleEasier => 'সহজ';

  @override
  String get puzzleEasiest => 'খুবই সহজ';

  @override
  String get puzzleHarder => 'কঠিন';

  @override
  String get puzzleHardest => 'খুবই কঠিন';

  @override
  String get puzzleExample => 'উদাহরণ';

  @override
  String get puzzleAddAnotherTheme => 'অন্য থিম যুক্ত করুন';

  @override
  String get puzzleNextPuzzle => 'পরবর্তী ধাঁধা';

  @override
  String get puzzleJumpToNextPuzzleImmediately => 'তাৎক্ষনিক নতুন পাজলে চলে যাই';

  @override
  String get puzzlePuzzleDashboard => 'পাজল ড্যাশবোর্ড';

  @override
  String get puzzleImprovementAreas => 'উন্নতি করার জায়গা';

  @override
  String get puzzleStrengths => 'শক্তিমত্তা';

  @override
  String get puzzleHistory => 'পূর্বে চেষ্টা করা ধাঁধা';

  @override
  String get puzzleSolved => 'মীমাংসিত';

  @override
  String get puzzleFailed => 'ভুল করা ধাঁদা';

  @override
  String get puzzleStreakDescription => 'ধারাবাহিক জয় বজায় রাখতে ক্রমাগত কঠিন হতে থাকা ধাঁধার সমাধান করুন। কোনো সময়সীমা নেই। তবে একটি ভুল চালে খেলা শেষ। প্রতি সেশনে একটি করে চাল বাদ(skip) দেয়া যাবে।';

  @override
  String puzzleYourStreakX(String param) {
    return 'আপনার স্কোর: $param';
  }

  @override
  String get puzzleStreakSkipExplanation => 'আপনার ধারাবাহিক জয় বজায় রাখতে এই চাল বাদ(skip) করুন। প্রতিবার প্রচেষ্টায় একবার করে এমনটা করতে পারবেন।';

  @override
  String get puzzleContinueTheStreak => 'পরবর্তী ধাঁধায় যান';

  @override
  String get puzzleNewStreak => 'নতুন ধাঁধার ধারা';

  @override
  String get puzzleFromMyGames => 'আমার খেলা গুলো থেকে';

  @override
  String get puzzleLookupOfPlayer => 'একজন খেলোয়াড়ের খেলা থেকে ধাঁধা দেখুন';

  @override
  String puzzleFromXGames(String param) {
    return '$param এর খেলা থেকে নেয়া ধাঁধা';
  }

  @override
  String get puzzleSearchPuzzles => 'ধাঁধা খুজুন';

  @override
  String get puzzleFromMyGamesNone => 'ডাটাবেজে আপনার কোনো ধাঁধা নেই।\nআপনার খেলা থেকে ধাঁধা নেয়ার সম্ভাবনা বাড়াতে র‍্যাপিড এবং ক্লাসিক খেলুন।';

  @override
  String puzzleFromXGamesFound(String param1, String param2) {
    return '$param2 টি খেলা হতে $param1 টি ধাঁধা পাওয়া গেছে।';
  }

  @override
  String get puzzlePuzzleDashboardDescription => 'প্রশিক্ষণ, বিশ্লেষণ, উন্নতি';

  @override
  String puzzlePercentSolved(String param) {
    return '$param সমাধান করেছেন।';
  }

  @override
  String get puzzleNoPuzzlesToShow => 'প্রদর্শনের কিছু নেই। প্রথমে কিছু ধাঁধা খেলুন।';

  @override
  String get puzzleImprovementAreasDescription => 'আপনার প্রগতির জন্য এইগুলোতে প্রশিক্ষণ করুন!';

  @override
  String get puzzleStrengthDescription => 'আপনি এই ধাঁচের গুলোয় ভালো খেলেন।';

  @override
  String puzzlePlayedXTimes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count বার খেলা হয়েছে',
      one: '$count বার খেলা হয়েছে',
    );
    return '$_temp0';
  }

  @override
  String puzzleNbPointsBelowYourPuzzleRating(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'আপনার ধাঁধার রেটিং হতে $count পয়েন্ট কম।',
      one: 'আপনার ধাঁধার রেটিং হতে এক পয়েন্ট কম।',
    );
    return '$_temp0';
  }

  @override
  String puzzleNbPointsAboveYourPuzzleRating(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'আপনার ধাঁধার রেটিং হতে $count পয়েন্ট বেশি।',
      one: 'আপনার ধাঁধার রেটিং হতে এক পয়েন্ট বেশি।',
    );
    return '$_temp0';
  }

  @override
  String puzzleNbPlayed(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count টি খেলেছেন',
      one: '$count টি খেলেছেন',
    );
    return '$_temp0';
  }

  @override
  String puzzleNbToReplay(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count টি পুনরায় খেলুন',
      one: '$count টি পুনরায় খেলুন',
    );
    return '$_temp0';
  }

  @override
  String get puzzleThemeAdvancedPawn => 'অগ্রসর সৈন্য';

  @override
  String get puzzleThemeAdvancedPawnDescription => 'আপনার একটি সৈন্য প্রতিপক্ষের অবস্থানের গভীরে গিয়েছে, সম্ভবত তা প্রমোশনের জন্য হুশিয়ারি দিচ্ছে।';

  @override
  String get puzzleThemeAdvantage => 'লাভ';

  @override
  String get puzzleThemeAdvantageDescription => 'মারাত্বক লাভের জন্য আপনার সুযোগকে কাজে লাগান (200cp ≤ eval ≤ 600cp)';

  @override
  String get puzzleThemeAnastasiaMate => 'অ্যানেস্তেসিয়ার মাত';

  @override
  String get puzzleThemeAnastasiaMateDescription => 'একটা ঘোড়া এবং একটা নৌকা অথবা মন্ত্রীকে নিয়ে দল বাঁধান প্রতিপক্ষের রাজাকে বোর্ডের সাইড এবং তারই গুটির মাঝে ফাঁদে ফেলার জন্য।';

  @override
  String get puzzleThemeArabianMate => 'আরবীয় মাত';

  @override
  String get puzzleThemeArabianMateDescription => 'প্রতিপক্ষের রাজাকে বোর্ডের এক কোণায় ফাঁদে ফেলার জন্য একটা ঘোড়া এবং একটা নৌকার দলগঠন।';

  @override
  String get puzzleThemeAttackingF2F7 => 'f2 অথবা f7 কে আক্রমণ করা';

  @override
  String get puzzleThemeAttackingF2F7Description => 'f2 অথবা f7 সৈন্যকে লক্ষ্য করে আক্রমণ, ফ্রায়েড লিভার ওপেনিং এ যেমন।';

  @override
  String get puzzleThemeAttraction => 'আকর্ষণ';

  @override
  String get puzzleThemeAttractionDescription => 'শত্রুর গুটিকে জোর করে একটা ঘরে আনার জন্য একটা বিনিময় অথবা ত্যাগ যার মাধ্যমে পরে ট্যাকটিক করা যায়।';

  @override
  String get puzzleThemeBackRankMate => 'পিছনের র‍্যাংক মাত';

  @override
  String get puzzleThemeBackRankMateDescription => 'রাজাকে নিজের বাড়ির র‍্যাংকে বাজিমাত করা, যখন তা নিজের গুটি দ্বারাই ফাঁদে আটকে থাকে।';

  @override
  String get puzzleThemeBishopEndgame => 'হাতি এন্ডগেম';

  @override
  String get puzzleThemeBishopEndgameDescription => 'শুধু হাতি এবং সৈন্যদের নিয়ে একটা এন্ডগেম।';

  @override
  String get puzzleThemeBodenMate => 'বডেনের মাত';

  @override
  String get puzzleThemeBodenMateDescription => 'দুইটা ক্রস করা আড়া-আড়ি রেখার উপর দুইটা হাতি যা নিজের গুটিতে আটে থাকা রাজাকে বাজিমাত করে।';

  @override
  String get puzzleThemeCastling => 'ক্যাসলিং';

  @override
  String get puzzleThemeCastlingDescription => 'রাজাকে নিরাপদে নিয়ে আসুন, এবং আপনার নৌকাকে স্থাপন করুন হামলার জন্য.';

  @override
  String get puzzleThemeCapturingDefender => 'রক্ষককে খান';

  @override
  String get puzzleThemeCapturingDefenderDescription => 'একটা গুটিকে খাওয়া যা আরেকটার প্রতিরক্ষা করে, যা পরের একটি চালে যেই গুটিকে রক্ষা করা হচ্ছিল তাকে খাওয়ার সুযোগ করে দেয়।';

  @override
  String get puzzleThemeCrushing => 'গুড়িয়ে দেয়া';

  @override
  String get puzzleThemeCrushingDescription => 'অপনেন্টের ব্লানডারকে ধরে ফেলুন এবং প্রতিপক্ষকে গুড়িয়ে দিয়ে লাভ অর্জন করুন। (eval ≥ 600cp)';

  @override
  String get puzzleThemeDoubleBishopMate => 'দুটি হাতির মাত';

  @override
  String get puzzleThemeDoubleBishopMateDescription => 'পাশাপাশি দুটি আড়া-আড়ি রেখায় থাকা দুটি বিশপ/হাতি নিজের গুটি দ্বারা আটকা পড়া প্রতিপক্ষের রাজাকে কিস্তিমাত করবে।';

  @override
  String get puzzleThemeDovetailMate => 'ডাভটেইল মাত';

  @override
  String get puzzleThemeDovetailMateDescription => 'একটা মন্ত্রী রাজাকে বাজিমাত দেয়, যার কেবল দুটি মুক্তির ঘর নিজের গুটি দ্বারা দখলকৃত থাকে।';

  @override
  String get puzzleThemeEquality => 'সমতা';

  @override
  String get puzzleThemeEqualityDescription => 'একটা হেরে যাওয়া অবস্থান থেকে ফিরে আসা, এবং ড্র অথবা একটা ভারসাম্যযুক্ত অবস্থানে নিয়ে আসা। (eval ≤ 200cp)';

  @override
  String get puzzleThemeKingsideAttack => 'রাজার দিকে আক্রমণ';

  @override
  String get puzzleThemeKingsideAttackDescription => 'প্রতিপক্ষের রাজার নিজের পাশে ক্যাসলিং করার পর, তাকে আক্রমণ করা।';

  @override
  String get puzzleThemeClearance => 'পরিষ্কারকরণ';

  @override
  String get puzzleThemeClearanceDescription => 'প্রায়শই একটি টেম্পোসহ, একটা চাল যা একটা ঘর, ফাইল অথবা আড়া-আড়ি লাইন পরিষ্কার করে পরে যার দ্বারা ট্যাকটিক প্রয়োগ করা যায়।';

  @override
  String get puzzleThemeDefensiveMove => 'রক্ষণাত্বক চাল';

  @override
  String get puzzleThemeDefensiveMoveDescription => 'একটা নিখুঁত চাল অথবা চালের ধারা যার দ্বারা ম্যাটেরিয়াল হারানো অথবা অন্য ধরণের ক্ষতির হাত থেকে বাঁচা যায়।';

  @override
  String get puzzleThemeDeflection => 'বিচ্যুতি';

  @override
  String get puzzleThemeDeflectionDescription => 'একটা চাল যা প্রতিপক্ষের গুটিকে নিজের কাজ (যেমন একটা গুরুত্বপূর্ণ ঘর পাহারা দেয়া) থেকে বিরত রাখে। কখনো কখনো এটাকে ওভারলোডিং ও বলা হয়।';

  @override
  String get puzzleThemeDiscoveredAttack => 'আবিষ্কৃত আক্রমণ';

  @override
  String get puzzleThemeDiscoveredAttackDescription => 'একটা গুটি (যেমন ঘোড়া), যা পূর্বে কোন গুটির আক্রমণকে প্রতিরোধ করছিল, তাকে সেই গুটির রাস্তা থেকে সরিয়ে আক্রমণ করা। এতে যেগুটি সরানো হলো এবং যেগুটির পথ থেকে সরানো হলো উভয়ই আক্রমণ করবে।';

  @override
  String get puzzleThemeDoubleCheck => 'দ্বৈত চেক';

  @override
  String get puzzleThemeDoubleCheckDescription => 'দুটি গুটি দিয়ে একসাথে চেক করা, আবিষ্কৃত আক্রমণের ফলস্বরূপ যেখানে যে গুটি সরে এবং যে গুটির রাস্তা পরিষ্কার হয় উভয়ই প্রতিপক্ষের রাজাকে আক্রমণ করে।';

  @override
  String get puzzleThemeEndgame => 'সমাপনী খেলা';

  @override
  String get puzzleThemeEndgameDescription => 'গেমের শেষ পর্যায়ের একটি ট্যাকটিক।';

  @override
  String get puzzleThemeEnPassantDescription => 'এন প্যাসান্ট রুলকে কেন্দ্র করে একটি ট্যাকটিক, যেখানে একটা সৈন্য একটা প্রতিপক্ষের সৈন্যকে খেতে পারে যা তাকে পাশ কাটিয়েছে নিজের দুই ঘর অতিক্রমের ক্ষমতা ব্যবহার করে।';

  @override
  String get puzzleThemeExposedKing => 'বহি:প্রকাশিত রাজা';

  @override
  String get puzzleThemeExposedKingDescription => 'রাজার আশেপাশে অল্পসংখ্যক রক্ষককে কেন্দ্র করে একটি কৌশল, যা প্রায়ই কিস্তিমাতে পরিণত হয়।';

  @override
  String get puzzleThemeFork => 'কাঁটাচামচ';

  @override
  String get puzzleThemeForkDescription => 'একটা চাল যেখানে একটা গুটি প্রতিপক্ষের দুটি গুটিকে আক্রমণ করে একইসাথে (যেভাবে একজন দুইহাতে দুটো কাঁটাচামচ দিয়ে দুটো জিনিসে আক্রমণ করে).';

  @override
  String get puzzleThemeHangingPiece => 'ঝুলন্ত গুটি';

  @override
  String get puzzleThemeHangingPieceDescription => 'প্রতিপক্ষের গুটি অরক্ষিত বা অপর্যাপ্তভাবে রক্ষিত এবং ক্যাপচার/খাওয়ার জন্য উন্মুক্ত।';

  @override
  String get puzzleThemeHookMate => 'হুক মেট';

  @override
  String get puzzleThemeHookMateDescription => 'একটি নৌকা, ঘোড়া এবং সৈন্য দ্বারা প্রতিপক্ষের রাজাকে কিস্তিমাত করা যা নিজের সৈন্য দ্বারা আটকা পরেছে।';

  @override
  String get puzzleThemeInterference => 'প্রতিবন্ধকতা তৈরি';

  @override
  String get puzzleThemeInterferenceDescription => 'একটি গুটিকে প্রতিপক্ষের দুটি গুটির মধ্যবর্তী ঘরে চাল দেয়া, যাতে একটি বা উভয় গুটি অরক্ষিত হয়ে পড়ে। যেমনঃ দুটি নৌকার মধ্যে প্রতিপক্ষের একটি রক্ষিত ঘরে প্রতিপক্ষের ঘোড়ার চাল দেয়া।';

  @override
  String get puzzleThemeIntermezzo => 'Intermezzo/মধ্যবর্তী চাল';

  @override
  String get puzzleThemeIntermezzoDescription => 'প্রত্যাশিত চাল না খেলে ভিন্ন চাল দেয়া, যা তৎক্ষণাৎ হুমকি(threat) তৈরি করবে এবং প্রতিপক্ষকে অবশ্যই তা প্রতিহত করতে হবে।';

  @override
  String get puzzleThemeKnightEndgame => 'Knight/ঘোড়ার সমাপনী খেলা';

  @override
  String get puzzleThemeKnightEndgameDescription => 'শুধু হাতি এবং সৈন্যদের নিয়ে সমাপনী খেলা।';

  @override
  String get puzzleThemeLong => 'দীর্ঘ ধাঁধা';

  @override
  String get puzzleThemeLongDescription => 'তিন চালে জিতুন।';

  @override
  String get puzzleThemeMaster => 'খেতাবধারীদের খেলা';

  @override
  String get puzzleThemeMasterDescription => 'খেতাবধারীদের খেলা থেকে নেয়া ধাঁধা।';

  @override
  String get puzzleThemeMasterVsMaster => 'খেতাব বনাম খেতাব';

  @override
  String get puzzleThemeMasterVsMasterDescription => 'দুইজন খেতাবধারীদের খেলা থেকে নেয়া ধাঁধা।';

  @override
  String get puzzleThemeMate => 'কিস্তিমাত';

  @override
  String get puzzleThemeMateDescription => 'ভঙ্গিমায় খেলা জিতুন।';

  @override
  String get puzzleThemeMateIn1 => '১ চালে মাত';

  @override
  String get puzzleThemeMateIn1Description => '১ চালে কিস্তিমাত দিন।';

  @override
  String get puzzleThemeMateIn2 => '২ চালে মাত';

  @override
  String get puzzleThemeMateIn2Description => '২ চালে কিস্তিমাত দিন।';

  @override
  String get puzzleThemeMateIn3 => '৩ চালে মাত';

  @override
  String get puzzleThemeMateIn3Description => '৩ চালে কিস্তিমাত দিন।';

  @override
  String get puzzleThemeMateIn4 => '৪ চালে মাত';

  @override
  String get puzzleThemeMateIn4Description => '৪ চালে কিস্তিমাত দিন।';

  @override
  String get puzzleThemeMateIn5 => '৫ বা ততোধিক চালে মাত';

  @override
  String get puzzleThemeMateIn5Description => 'কিস্তিমাত করার দীর্ঘ চালের ক্রম বের করতে হবে।';

  @override
  String get puzzleThemeMiddlegame => 'মধ্য-খেলা';

  @override
  String get puzzleThemeMiddlegameDescription => 'খেলার দ্বিতীয় পর্যায়ের কৌশল।';

  @override
  String get puzzleThemeOneMove => '১ চালের ধাঁধা';

  @override
  String get puzzleThemeOneMoveDescription => 'মাত্র ১ চাল দীর্ঘ ধাঁধা।';

  @override
  String get puzzleThemeOpening => 'প্রারম্ভিক খেলা';

  @override
  String get puzzleThemeOpeningDescription => 'খেলার শুরুর পর্যায়ের কৌশল।';

  @override
  String get puzzleThemePawnEndgame => 'সৈন্যের সমাপনী খেলা';

  @override
  String get puzzleThemePawnEndgameDescription => 'শুধুমাত্র সৈন্য দ্বারা সমাপনী খেলা।';

  @override
  String get puzzleThemePin => 'Pin/আটকে ফেলা';

  @override
  String get puzzleThemePinDescription => 'এক ধরণের কৌশল যেখানে একটি গুটির চাল দিলে নিজের বড় গুটির উপর আক্রমন হবে।';

  @override
  String get puzzleThemePromotion => 'Promotion/পদোন্নতি';

  @override
  String get puzzleThemePromotionDescription => 'আপনার সৈন্যকে মন্ত্রী বা অন্য লঘু গুটিতে উন্নীত করুন।';

  @override
  String get puzzleThemeQueenEndgame => 'মন্ত্রীর সমাপনী খেলা';

  @override
  String get puzzleThemeQueenEndgameDescription => 'শুধু মন্ত্রী এবং সৈন্যদের নিয়ে একটা সমাপনী খেলা।';

  @override
  String get puzzleThemeQueenRookEndgame => 'মন্ত্রী এবং নৌকা';

  @override
  String get puzzleThemeQueenRookEndgameDescription => 'শুধু মন্ত্রী, নৌকা এবং সৈন্যদের নিয়ে সমাপনী খেলা।';

  @override
  String get puzzleThemeQueensideAttack => 'মন্ত্রী-দিকের আক্রমণ';

  @override
  String get puzzleThemeQueensideAttackDescription => 'প্রতিপক্ষের রাজার মন্ত্রীর দিকে ক্যাসলিং করার পর আক্রমণ।';

  @override
  String get puzzleThemeQuietMove => 'Quite/নীরব চাল';

  @override
  String get puzzleThemeQuietMoveDescription => 'যে চাল তাৎক্ষণিক কোনো প্রতিক্রিয়া করে না, কিন্তু পরবর্তী চাল গুলোকে অনেক গুপ্ত, অনিবার্য আক্রমনের জন্য তৈরি করে।';

  @override
  String get puzzleThemeRookEndgame => 'নৌকার সমাপনী খেলা';

  @override
  String get puzzleThemeRookEndgameDescription => 'শুধু নৌকা এবং সৈন্যদের নিয়ে সমাপনী খেলা।';

  @override
  String get puzzleThemeSacrifice => 'Sacrifice/বিসর্জন';

  @override
  String get puzzleThemeSacrificeDescription => 'কৌশলগত সুবিধা অর্জনের জন্য গুটি বিসর্জন দেয়া।';

  @override
  String get puzzleThemeShort => 'সংক্ষিপ্ত ধাঁধা';

  @override
  String get puzzleThemeShortDescription => 'দুই চালে জিতুন।';

  @override
  String get puzzleThemeSkewer => 'Skewer/শূল';

  @override
  String get puzzleThemeSkewerDescription => 'কোনো বড় গুটি আক্রমনের শিকার হলে, সেটি সরে গিয়ে পিছনের কোনো ছোট গুটিকে বিসর্জন/আক্রান্ত করা।';

  @override
  String get puzzleThemeSmotheredMate => 'স্মদারড মেট';

  @override
  String get puzzleThemeSmotheredMateDescription => 'ঘোড়া যখন নিজের গুটি দ্বারা আটকে পড়া রাজাকে কিস্তিমাত করে।';

  @override
  String get puzzleThemeSuperGM => 'সুপার গ্রান্ডমাস্টারদের খেলা।';

  @override
  String get puzzleThemeSuperGMDescription => 'বিশ্বসেরা দাবাড়ুদের খেলা থেকে নেয়া ধাঁধা।';

  @override
  String get puzzleThemeTrappedPiece => 'আটকে পড়া গুটি';

  @override
  String get puzzleThemeTrappedPieceDescription => 'সীমিত চাল থাকার জন্য গুটি যখন নিজেকে খাওয়া(capture) থেকে বাঁচাতে পারে না।';

  @override
  String get puzzleThemeUnderPromotion => 'অর্ধ-পদোন্নতি(Underpromotion)';

  @override
  String get puzzleThemeUnderPromotionDescription => 'ঘোড়া, হাতি অথবা নৌকায় উন্নীত করা।';

  @override
  String get puzzleThemeVeryLong => 'অতিদীর্ঘ ধাঁধা';

  @override
  String get puzzleThemeVeryLongDescription => 'চার বা ততোধিক চালে জিতুন';

  @override
  String get puzzleThemeXRayAttack => 'এক্স-রে আক্রমণ';

  @override
  String get puzzleThemeXRayAttackDescription => 'একটি গুটি যখন প্রতিপক্ষের গুটির ভিতর দিয়ে কোনো ঘরকে রক্ষা বা আক্রমন করে।';

  @override
  String get puzzleThemeZugzwang => 'জুগজওয়াং(Zugzwang)';

  @override
  String get puzzleThemeZugzwangDescription => 'প্রতিপক্ষের সীমিত চাল আছে, এবং সব চাল তাদের অবস্থান আরো খারাপ করবে।';

  @override
  String get puzzleThemeHealthyMix => 'পরিমিত মিশ্রণ';

  @override
  String get puzzleThemeHealthyMixDescription => 'সবকিছু একটু করে। আপনি জানবেন না কি আসতে চলেছে। অনেকটা বাস্তব খেলার মতো।';

  @override
  String get puzzleThemePlayerGames => 'খেলোয়ারদের খেলা হতে';

  @override
  String get puzzleThemePlayerGamesDescription => 'খেলোয়ারদের খেলা থেকে বাছাই করে তৈরি করা ধাঁধা।';

  @override
  String puzzleThemePuzzleDownloadInformation(String param) {
    return 'এই ধাঁধা গুলো সবার জন্য উন্মুক্ত এবং $param থেকে নামিয়ে নেয়া যাবে।';
  }

  @override
  String get searchSearch => 'অনুসন্ধান';

  @override
  String get settingsSettings => 'সেটিংস';

  @override
  String get settingsCloseAccount => 'একাউন্ট বন্ধ করুন';

  @override
  String get settingsManagedAccountCannotBeClosed => 'আপনার অ্যাকাউন্ট পরিচালিত এবং বন্ধ করা যাবে না.';

  @override
  String get settingsClosingIsDefinitive => 'একাউন্ট বন্ধ সুনিশ্চিত। আর ফেরত যাওয়ার উপায় নেই। আপনি কি নিশ্চিত?';

  @override
  String get settingsCantOpenSimilarAccount => 'আপনি একই নামে আর নতুন একাউন্ট খুলতে পারবেন না, যদিও নামের বর্ণগুলো ছোট/বড় হাতের হয়।';

  @override
  String get settingsChangedMindDoNotCloseAccount => 'আমি নিজের মত পরিবর্তন করেছি এবং আমার একাউন্ট বন্ধ করতে চাই না';

  @override
  String get settingsCloseAccountExplanation => 'আপনি কি নিশ্চিত যে আপনি নিজের একাউন্টটি বন্ধ করতে চান? আপনার একাউন্ট বন্ধ করবার সিদ্ধান্তটি স্থায়ী হবে। আপনি আর কখনও লগ ইন করতে সক্ষম হবেন না।';

  @override
  String get settingsThisAccountIsClosed => 'এই একাউন্টটি বন্ধ করা হয়েছে';

  @override
  String get playWithAFriend => 'বন্ধুর সাথে খেলো';

  @override
  String get playWithTheMachine => 'কম্পিউটারের সাথে খেলতে চান';

  @override
  String get toInviteSomeoneToPlayGiveThisUrl => 'কাউকে খেলার জন্য আমন্ত্রণ জানাতে চাইলে এই URL টি দিন';

  @override
  String get gameOver => 'খেলা সমাপ্ত';

  @override
  String get waitingForOpponent => 'প্রতিপক্ষের জন্য অপেক্ষারত';

  @override
  String get orLetYourOpponentScanQrCode => 'Or let your opponent scan this QR code';

  @override
  String get waiting => 'অপেক্ষা করুন';

  @override
  String get yourTurn => 'আপনার চাল';

  @override
  String aiNameLevelAiLevel(String param1, String param2) {
    return '$param1 এর লেভেল $param2';
  }

  @override
  String get level => 'লেভেল';

  @override
  String get strength => 'শক্তি';

  @override
  String get toggleTheChat => 'আড্ডা চালু/বন্ধ';

  @override
  String get chat => 'আড্ডা';

  @override
  String get resign => 'হার স্বীকার করুন';

  @override
  String get checkmate => 'কিস্তিমাত';

  @override
  String get stalemate => 'চালমাত - সমান';

  @override
  String get white => 'সাদা';

  @override
  String get black => 'কালো';

  @override
  String get asWhite => 'সাদা হয়ে';

  @override
  String get asBlack => 'কালো হয়ে';

  @override
  String get randomColor => 'যে কোন রঙ';

  @override
  String get createAGame => 'খেলা তৈরি করুন';

  @override
  String get whiteIsVictorious => 'সাদা বিজয়ী';

  @override
  String get blackIsVictorious => 'কালো বিজয়ী';

  @override
  String get youPlayTheWhitePieces => 'আপনি সাদা গুটি নিয়ে খেলছেন';

  @override
  String get youPlayTheBlackPieces => 'আপনি কালো গুটি নিয়ে খেলছেন';

  @override
  String get itsYourTurn => 'এবার আপনার পালা!';

  @override
  String get cheatDetected => 'প্রতারণা শনাক্ত করা হয়েছে';

  @override
  String get kingInTheCenter => 'রাজাকে কেন্দ্রে আনুন';

  @override
  String get threeChecks => 'তিনটি কিস্তি';

  @override
  String get raceFinished => 'প্রতিযোগিতা শেষ';

  @override
  String get variantEnding => 'ভিন্ন রকমের সমাপ্তি';

  @override
  String get newOpponent => 'নতুন প্রতিপক্ষ';

  @override
  String get yourOpponentWantsToPlayANewGameWithYou => 'আপনার প্রতিপক্ষ পুনরায়  আপনার সাথে খেলতে চায়';

  @override
  String get joinTheGame => 'খেলাটিতে যোগ দিন';

  @override
  String get whitePlays => 'সাদার চাল';

  @override
  String get blackPlays => 'কালোর চাল';

  @override
  String get opponentLeftChoices => 'অপর খেলোয়াড় খেলাটি ছেড়ে চলে গেছেন, আপনি সেই খেলাটিকে জিততে পারেন নাহলে ড্র করতে পারেন কিংবা অপেক্ষা করুন প্রতিপক্ষের পুনরায় খেলায় ফিরে আসার';

  @override
  String get forceResignation => 'বিজয় দাবী করুন';

  @override
  String get forceDraw => 'সমান ঘোষণা করুন';

  @override
  String get talkInChat => 'আড্ডায় কথা বলুন';

  @override
  String get theFirstPersonToComeOnThisUrlWillPlayWithYou => 'এই URL দিয়ে আসা প্রথম ব্যক্তি আপনার সাথে খেলবেন';

  @override
  String get whiteResigned => 'সাদা হার মেনে নিলেন';

  @override
  String get blackResigned => 'কালো হার মেনে নিলেন';

  @override
  String get whiteLeftTheGame => 'সাদা খেলাটি ছেড়ে চলে গেছেন';

  @override
  String get blackLeftTheGame => 'কালো খেলাটি ছেড়ে চলে গেছেন';

  @override
  String get whiteDidntMove => 'সাদা চাল দিল না';

  @override
  String get blackDidntMove => 'কালো চাল দিল না';

  @override
  String get requestAComputerAnalysis => 'কম্পিউটার বিশ্লেষণের জন্য অবেদন করুন';

  @override
  String get computerAnalysis => 'কম্পিউটারের বিশ্লেষণ';

  @override
  String get computerAnalysisAvailable => 'কম্পিউটার বিশ্লেষণ পাওয়া যায়';

  @override
  String get computerAnalysisDisabled => 'কম্পিউটার বিশ্লেষণ অচল করা আছে';

  @override
  String get analysis => 'বিশ্লেষণ বোর্ড';

  @override
  String depthX(String param) {
    return 'গভীরতা $param';
  }

  @override
  String get usingServerAnalysis => 'সার্ভারের বিশ্লেষণ ব্যবহার করা হচ্ছে';

  @override
  String get loadingEngine => 'ইঞ্জিন লোড করা হচ্ছে...';

  @override
  String get calculatingMoves => 'চালগুলি গননা করা হচ্ছে...';

  @override
  String get engineFailed => 'ইঞ্জিন লোড করতে ব্যর্থ';

  @override
  String get cloudAnalysis => 'মেঘবিশ্লেষণ';

  @override
  String get goDeeper => 'গভীরে যাও';

  @override
  String get showThreat => 'ন্হমকি দেখান';

  @override
  String get inLocalBrowser => 'সাধারন ব্রাউজারের মধ্যে';

  @override
  String get toggleLocalEvaluation => 'স্থানীয় টগ্ল মূল্যায়ন';

  @override
  String get promoteVariation => 'বিজ্ঞাপন';

  @override
  String get makeMainLine => 'প্রাধান সীমা করা';

  @override
  String get deleteFromHere => 'এখান থেকে মুছুন';

  @override
  String get collapseVariations => 'Collapse variations';

  @override
  String get expandVariations => 'Expand variations';

  @override
  String get forceVariation => 'জোর করে পরিবর্তন';

  @override
  String get copyVariationPgn => 'Copy variation PGN';

  @override
  String get move => 'চাল';

  @override
  String get variantLoss => 'ভিন্ন ক্ষতি';

  @override
  String get variantWin => 'ভিন্ন জয়';

  @override
  String get insufficientMaterial => 'অপর্যাপ্ত উপাদান';

  @override
  String get pawnMove => 'ঘুঁটি সরান';

  @override
  String get capture => 'অধিগ্রহন করুন';

  @override
  String get close => 'বন্ধ';

  @override
  String get winning => 'জয়লাভ';

  @override
  String get losing => 'হেরে যাওয়া';

  @override
  String get drawn => 'সমান';

  @override
  String get unknown => 'অজানা';

  @override
  String get database => 'ডেটাবেজ';

  @override
  String get whiteDrawBlack => 'সাদা / সমান / কালো';

  @override
  String averageRatingX(String param) {
    return 'গড় নির্ধারণ:$param';
  }

  @override
  String get recentGames => 'সম্প্রতি খেলা';

  @override
  String get topGames => 'সেরা খেলা';

  @override
  String masterDbExplanation(String param1, String param2, String param3) {
    return '২ লক্ষ ওটিবি খেলার $param1+খেলয়াড়ের বিশ্বাসের অনুপাত $param2 থেকে $param3';
  }

  @override
  String get dtzWithRounding => 'DTZ50\'\' রাউন্ডিং সহ, পরবর্তী ক্যাপচার বা পন মুভ পর্যন্ত অর্ধ-চালের সংখ্যার উপর ভিত্তি করে';

  @override
  String get noGameFound => 'কোন খেলা নেই';

  @override
  String get maxDepthReached => 'সর্বোচ্চ গভীরতা পৌঁছে গেছে!';

  @override
  String get maybeIncludeMoreGamesFromThePreferencesMenu => 'হয়তো আরো খেলা যোগ করা হবে পচ্ছন্দের তালিকায়?';

  @override
  String get openings => 'শুরুর ভাগ';

  @override
  String get openingExplorer => 'অনুসন্ধানকারী খুলতেছে';

  @override
  String get openingEndgameExplorer => 'প্রারম্ভিক/শেষ খেলা কৌশল বিশ্লেষণ';

  @override
  String xOpeningExplorer(String param) {
    return '$param অনুসন্ধানকারী খুলতেছে';
  }

  @override
  String get playFirstOpeningEndgameExplorerMove => 'প্রথম ওপেনিং/এন্ডগেম-এক্সপ্লোরার মুভ খেলুন';

  @override
  String get winPreventedBy50MoveRule => '50-চাল নিয়মে জয় প্রতিরোধ';

  @override
  String get lossSavedBy50MoveRule => '50- চাল নিয়মে হার জমা';

  @override
  String get winOr50MovesByPriorMistake => 'Win or 50 moves by prior mistake';

  @override
  String get lossOr50MovesByPriorMistake => 'Loss or 50 moves by prior mistake';

  @override
  String get unknownDueToRounding => 'Syzygy টেবিলবেসগুলিতে DTZ মানগুলির সম্ভাব্য রাউন্ডিংয়ের কারণে, শেষ ক্যাপচার বা পন মুভের পর থেকে প্রস্তাবিত টেবিলবেস লাইন অনুসরণ করা হলেই জয়/পরাজয়ের নিশ্চয়তা থাকে.';

  @override
  String get allSet => 'সব প্রস্তুত!';

  @override
  String get importPgn => 'PGN প্রবেশ করান';

  @override
  String get delete => 'মুছে ফেলা';

  @override
  String get deleteThisImportedGame => 'প্রেবেশ করানো খেলাটি মুছেফেলবেন?';

  @override
  String get replayMode => 'উত্তর ধরন';

  @override
  String get realtimeReplay => 'সঠিকসময়';

  @override
  String get byCPL => 'CPL দ্বারা';

  @override
  String get openStudy => 'মুক্ত অধ্যয়ন';

  @override
  String get enable => 'সচল';

  @override
  String get bestMoveArrow => 'সরানোর উত্তম চিহ্ন';

  @override
  String get showVariationArrows => 'বৈচিত্র্য তীর দেখান';

  @override
  String get evaluationGauge => 'পরিমাপ মূল্যায়ন';

  @override
  String get multipleLines => 'বহু রেখা';

  @override
  String get cpus => 'সিপিইউএস';

  @override
  String get memory => 'মেমরি';

  @override
  String get infiniteAnalysis => 'অনন্ত বিশ্লেষণ';

  @override
  String get removesTheDepthLimit => 'গভীরতার সীমা অপসারণ করুন এবং আপনার কম্পিউটারকে গরম রাখুন';

  @override
  String get engineManager => 'ইঞ্জিন ম্যানেজার';

  @override
  String get blunder => 'গুরুতর ভুল';

  @override
  String get mistake => 'ভুল';

  @override
  String get inaccuracy => 'অশুদ্ধি';

  @override
  String get moveTimes => 'চালের সময়';

  @override
  String get flipBoard => 'বোর্ডকে ঘোরান';

  @override
  String get threefoldRepetition => 'তিনবার একই চাল';

  @override
  String get claimADraw => 'সমান দাবী করুন';

  @override
  String get offerDraw => 'সমানের জন্য আহ্‌বান জানান';

  @override
  String get draw => 'সমান';

  @override
  String get drawByMutualAgreement => 'মতৈক্যের ভিত্তিতে ড্র';

  @override
  String get fiftyMovesWithoutProgress => 'কোনো অগ্রগতি ছাড়া ৫০ চাল';

  @override
  String get currentGames => 'বর্তমান খেলা';

  @override
  String get viewInFullSize => 'পূর্ণ আকারে দেখুন';

  @override
  String get logOut => 'প্রস্থান';

  @override
  String get signIn => 'সাইন ইন';

  @override
  String get rememberMe => 'আমাকে লগিন/সংযুক্ত রাখুন';

  @override
  String get youNeedAnAccountToDoThat => 'এটি করার জন্য আপনার একাউন্ট প্রয়োজন';

  @override
  String get signUp => 'নিবন্ধ';

  @override
  String get computersAreNotAllowedToPlay => 'কম্পিউটার অথবা কম্পিউটার ব্যবহার করে খেলা যাবে না | সবাইকে অনুরোধ করা হচ্ছে যেন কেউ খেলার সময় কোনো রকম কম্পিউটার এর সাহায্য না নেন | পুনশ্চ, অযথা অনেক গুলি একাউন্ট খুলবেন না তাহলে আপনাকে বহিষ্কার করা হতে পারে.';

  @override
  String get games => 'সমস্ত খেলা';

  @override
  String get forum => 'ফোরাম';

  @override
  String xPostedInForumY(String param1, String param2) {
    return '$param1 পোস্ট করেছেন এ বিষয়ে $param2';
  }

  @override
  String get latestForumPosts => 'সর্বশেষ ফোরাম বার্তা';

  @override
  String get players => 'খেলোয়াড়';

  @override
  String get friends => 'বন্ধুরা';

  @override
  String get discussions => 'বার্তাগুলি';

  @override
  String get today => 'আজ';

  @override
  String get yesterday => 'গতকাল';

  @override
  String get minutesPerSide => 'প্রতিটি পাশের জন্য বরাদ্দ মিনিট';

  @override
  String get variant => 'বিকল্প';

  @override
  String get variants => 'বিভিন্ন';

  @override
  String get timeControl => 'সময় নিয়ন্ত্রণ';

  @override
  String get realTime => 'সঠিক সময়';

  @override
  String get correspondence => 'দীর্ঘ খেলা';

  @override
  String get daysPerTurn => 'প্রতিটি চালের জন্য বরাদ্দ দিন';

  @override
  String get oneDay => 'একদিন';

  @override
  String get time => 'সময়';

  @override
  String get rating => 'অনুপাত';

  @override
  String get ratingStats => 'অনুপাত পরিসংখ্যান';

  @override
  String get username => 'ব্যবহারকারীর নাম';

  @override
  String get usernameOrEmail => 'ব্যবহারকারী নাম অথবা ই-মেইল';

  @override
  String get changeUsername => 'ইউজারনেম পরিবর্তন করুন';

  @override
  String get changeUsernameNotSame => 'শুধুমাত্র লেটারগুলোর কেইস পরিবর্তন করা সম্ভব। উদাহরণস্বরূপ \"johndoe\" থেকে \"JohnDoe\"।';

  @override
  String get changeUsernameDescription => 'আপনার ইউসারনেম পরিবর্তন করুন। এটি মাত্র একবারই পরিবর্তন করা যাবে এবং আপনি শুধুমাত্র বড়ো-ছোট হাতের অক্ষরে রূপান্তরকরণ করতে পারবেন।';

  @override
  String get signupUsernameHint => 'পছন্দ অনুযায়ী নিজের ইউজারনেম তৈরি করুন কারন পরে এটি পরিবর্তন করতে পারবেন না এবং অনুপযুক্ত ইউজারনেমের যেকোনো অ্যাকাউন্ট পরবর্বতিতে বন্ধ করা হতে পারে!';

  @override
  String get signupEmailHint => 'আমরা এটি শুধুমাত্র পাসওয়ার্ড রিসেটের জন্য ব্যবহার করব.';

  @override
  String get password => 'পাসওয়ার্ড';

  @override
  String get changePassword => 'পাসওয়ার্ড পরিবর্তন';

  @override
  String get changeEmail => 'ই-মেইল পরিবর্তন করুন';

  @override
  String get email => 'ইমেল';

  @override
  String get passwordReset => 'পাসওয়ার্ড পরিবর্তন';

  @override
  String get forgotPassword => 'পাসওয়ার্ড ভুলে গেছেন?';

  @override
  String get error_weakPassword => 'এই পাসওয়ার্ড অত্যন্ত প্রচলিত, এবং অনুমান করা খুব সহজ.';

  @override
  String get error_namePassword => 'দয়া করে আপনার পাসওয়ার্ড হিসাবে আপনার ব্যবহারকারী নাম ব্যবহার করবেন না.';

  @override
  String get blankedPassword => 'আপনি অন্য সাইটে একই পাসওয়ার্ড ব্যবহার করেছেন এবং সেই সাইট ডাটা হ্যাক করা হয়েছে. আপনার Lichess অ্যাকাউন্টের নিরাপত্তা নিশ্চিত করতে, আপনাকে একটি নতুন পাসওয়ার্ড সেট করতে হবে. বোঝার জন্য আপনাকে ধন্যবাদ.';

  @override
  String get youAreLeavingLichess => 'আপনি লিচেস ছেড়ে যাচ্ছেন';

  @override
  String get neverTypeYourPassword => 'লিচেসে ব্যবহৃত পাসওয়ার্ড অন্য কোনো ওয়েবসাইটে টাইপ/ব্যবহার করবেন না!';

  @override
  String proceedToX(String param) {
    return '$param এ এগিয়ে যান';
  }

  @override
  String get passwordSuggestion => 'অন্য কারো প্রস্তাবিত পাসওয়ার্ড ব্যবহার করবেন না, কারন আপনার অ্যাকাউন্ট অন্য কারো দ্বারা চুরি/ব্যাবহার হওয়ার সম্ভাবনা রয়েছে';

  @override
  String get emailSuggestion => 'অন্য কারো প্রস্তাবিত ই-মেইল ব্যবহার করবেন না, কারন আপনার অ্যাকাউন্ট অন্য কারো দ্বারা চুরি/ব্যাবহার হওয়ার সম্ভাবনা রয়েছে';

  @override
  String get emailConfirmHelp => 'ইমেল নিশ্চিতকরণের মাধ্যমে সাহায্য';

  @override
  String get emailConfirmNotReceived => 'সাইন আপ করার পর ইমেইলে কনফার্মেশন পান নি?';

  @override
  String get whatSignupUsername => 'একাউন্ট খোলার/সাইন আপ করার সময় ইউজারনেম কি ব্যাবহার করেছিলেন?';

  @override
  String usernameNotFound(String param) {
    return 'আমরা এই নামের কোনো ব্যবহারকারী খুঁজে পাইনি: $param.';
  }

  @override
  String get usernameCanBeUsedForNewAccount => 'নতুন একাউন্ট খুলতে এই ইউজারনেমটি ব্যাবহার করতে পারেন';

  @override
  String emailSent(String param) {
    return '$param ঠিকানায় আমরা ইমেইল পাঠিয়েছি';
  }

  @override
  String get emailCanTakeSomeTime => 'পৌঁছাতে কিছু সময় লাগতে পারে।.';

  @override
  String get refreshInboxAfterFiveMinutes => '৫ মিনিট অপেক্ষা করে ইমেইলবক্স রিফ্রেশ করুন.';

  @override
  String get checkSpamFolder => 'এছাড়াও আপনার স্প্যাম ফোল্ডার চেক করুন, এটি সেখানে থাকতে পারে। যদি তাই হয়, এটি স্প্যাম নয় হিসাবে চিহ্নিত করুন.';

  @override
  String get emailForSignupHelp => 'অন্য সব কিছু ব্যর্থ হলে, আমাদের এই ইমেল পাঠান:';

  @override
  String copyTextToEmail(String param) {
    return 'উপরের লেখাটি কপি করে পেস্ট করুন এবং $param এ পাঠান';
  }

  @override
  String get waitForSignupHelp => 'আপনাকে আপনার সাইনআপ সম্পূর্ণ করতে সাহায্য করার জন্য আমরা শীঘ্রই আপনার কাছে ফিরে আসব.';

  @override
  String accountConfirmed(String param) {
    return 'ব্যবহারকারী $param সফলভাবে নিশ্চিত করা হয়েছে.';
  }

  @override
  String accountCanLogin(String param) {
    return 'আপনি এখন $param হিসাবে লগইন করতে পারেন.';
  }

  @override
  String get accountConfirmationEmailNotNeeded => 'আপনার নিশ্চিতকরণ ইমেল এর প্রয়োজন নেই.';

  @override
  String accountClosed(String param) {
    return '$param একাউন্টটি বন্ধ করা হয়েছে.';
  }

  @override
  String accountRegisteredWithoutEmail(String param) {
    return '$param একাউন্টটি একটি ইমেল ছাড়াই রেজিস্টার করা হয়েছিল.';
  }

  @override
  String get rank => 'মর্যাদাক্রম';

  @override
  String rankX(String param) {
    return 'অনুপাত: $param';
  }

  @override
  String get gamesPlayed => 'খেলা খেলেছেন';

  @override
  String get cancel => 'বাতিল করুন';

  @override
  String get whiteTimeOut => 'সাদার সময় শেষ';

  @override
  String get blackTimeOut => 'কালোর সময় আপ';

  @override
  String get drawOfferSent => 'সমান অফার পাঠানো হয়েছে';

  @override
  String get drawOfferAccepted => 'সমান অফার গ্রহণ করা হয়েছে';

  @override
  String get drawOfferCanceled => 'সমান অফার বাতিল করা হয়েছে';

  @override
  String get whiteOffersDraw => 'সাদা অফার সমান';

  @override
  String get blackOffersDraw => 'কালো অফার সমান';

  @override
  String get whiteDeclinesDraw => 'সাদা সমান প্রত্যাখান করেছে';

  @override
  String get blackDeclinesDraw => 'কালো সমান প্রত্যাখান করেছে';

  @override
  String get yourOpponentOffersADraw => 'আপনার প্রতিপক্ষ সমান অফার করেছেন';

  @override
  String get accept => 'গ্রহণ করুন';

  @override
  String get decline => 'প্রত্যাখ্যান করুন';

  @override
  String get playingRightNow => 'এই মুহূর্তে খেলছেন';

  @override
  String get eventInProgress => 'এই মুহূর্তে খেলতেছে';

  @override
  String get finished => 'সমাপ্ত';

  @override
  String get abortGame => 'খেলা বন্ধ করুন';

  @override
  String get gameAborted => 'খেলা বন্ধ করা হয়েছে';

  @override
  String get standard => 'আদর্শ';

  @override
  String get customPosition => 'পছন্দসই পজিশন';

  @override
  String get unlimited => 'সীমাহীন সময়';

  @override
  String get mode => 'ধরন';

  @override
  String get casual => 'সাধারণ';

  @override
  String get rated => 'রেট করা';

  @override
  String get casualTournament => 'সাধারন';

  @override
  String get ratedTournament => 'অনুপাত';

  @override
  String get thisGameIsRated => 'এই খেলাটি রেট করা';

  @override
  String get rematch => 'আবার খেলুন';

  @override
  String get rematchOfferSent => 'পুনঃম্যাচের অফার পাঠানো হয়েছে';

  @override
  String get rematchOfferAccepted => 'পুনঃম্যাচের অফার গ্রহণ করা হয়েছে';

  @override
  String get rematchOfferCanceled => 'পুনঃম্যাচের অফার বাতিল করা হয়েছে';

  @override
  String get rematchOfferDeclined => 'পুনঃম্যাচের অফার প্রত্যাখ্যাত হয়েছে';

  @override
  String get cancelRematchOffer => 'পুনঃম্যাচের অফার বাতিল করুন';

  @override
  String get viewRematch => 'পুনঃম্যাচ দেখান';

  @override
  String get confirmMove => 'পদক্ষেপ নিশ্চিত করছি';

  @override
  String get play => 'খেলুন';

  @override
  String get inbox => 'ডাকবাক্স';

  @override
  String get chatRoom => 'আড্ডাঘর';

  @override
  String get loginToChat => 'আলাপআলচনা করতে লগিন করুন';

  @override
  String get youHaveBeenTimedOut => 'আপনার সময় শেষ.';

  @override
  String get spectatorRoom => 'দর্শক কক্ষ';

  @override
  String get composeMessage => 'মেসেজ তৈরি করুন';

  @override
  String get subject => 'শিরোনাম';

  @override
  String get send => 'পাঠান';

  @override
  String get incrementInSeconds => 'প্রতি সেকেন্ডে পর্যায়ক্রমিক বৃদ্ধি';

  @override
  String get freeOnlineChess => 'ফ্রি অনলাইন দাবা';

  @override
  String get exportGames => 'খেলা রপ্তানী';

  @override
  String get ratingRange => 'রেটিং সীমা';

  @override
  String get thisAccountViolatedTos => 'এই অ্যাকাউন্টটি লিচেস্‌-এর পরিষেবার শর্তসমূহ লঙ্ঘন করেছে';

  @override
  String get openingExplorerAndTablebase => 'বিস্লেষন খুলতেছে & টেবিলবেস';

  @override
  String get takeback => 'চাল ফিরিয়ে নিন';

  @override
  String get proposeATakeback => 'চাল ফিরিয়ে নেবার সুযোগ দিন';

  @override
  String get takebackPropositionSent => 'চাল ফিরিয়ে সুযোগ পাঠানো হয়েছে';

  @override
  String get takebackPropositionDeclined => 'চাল ফিরিয়ে নেবার সুযোগ প্রত্যাখ্যাত হয়েছে';

  @override
  String get takebackPropositionAccepted => 'চাল ফিরিয়ে নেবার সুযোগ গৃহীত হয়েছে';

  @override
  String get takebackPropositionCanceled => 'চাল ফিরিয়ে নেবার সুযোগ বাতিল করা হয়েছে';

  @override
  String get yourOpponentProposesATakeback => 'আপনার প্রতিপক্ষ চাল ফিরিয়ে নেবার সুযোগ দিতে চান';

  @override
  String get bookmarkThisGame => 'এই খেলাটি বুকমার্ক করুন';

  @override
  String get tournament => 'টুর্নামেন্ট';

  @override
  String get tournaments => 'টুর্নামেন্টগুলো';

  @override
  String get tournamentPoints => 'টুর্নামেন্ট পয়েন্ট';

  @override
  String get viewTournament => 'টুর্নামেন্ট দেখুন';

  @override
  String get backToTournament => 'টুর্নামেন্ট এ ফিরে যান';

  @override
  String get noDrawBeforeSwissLimit => 'একটি সুইস টুর্নামেন্টে 30টি চাল খেলার আগে আপনি ড্র করতে পারবেন না.';

  @override
  String get thematic => 'ধাতুসংক্রান্ত';

  @override
  String yourPerfRatingIsProvisional(String param) {
    return 'আপনার $param অনুপাত হয় সাময়িক';
  }

  @override
  String yourPerfRatingIsTooHigh(String param1, String param2) {
    return 'আপনার $param1 অনুপাত ($param2) হয় অনেক বেশি';
  }

  @override
  String yourTopWeeklyPerfRatingIsTooHigh(String param1, String param2) {
    return 'আপনার সাপ্তাহিক সর্বোচ্চ $param1 অনুপাত ($param2) হয় অনেক বেশি';
  }

  @override
  String yourPerfRatingIsTooLow(String param1, String param2) {
    return 'আপনার $param1 অনুপাত ($param2) হয় অনেক কম';
  }

  @override
  String ratedMoreThanInPerf(String param1, String param2) {
    return 'অনুপাতদিত ≥ $param1 এ $param2';
  }

  @override
  String ratedLessThanInPerf(String param1, String param2) {
    return 'অনুপাদিত ≤ $param1 এ $param2';
  }

  @override
  String mustBeInTeam(String param) {
    return 'অবশ্যই $param টিমে থাকতে হবে।';
  }

  @override
  String youAreNotInTeam(String param) {
    return 'আপনি $param দলে নেই।';
  }

  @override
  String get backToGame => 'খেলায় এ ফিরে যান';

  @override
  String get siteDescription => 'ফ্রি অনলাইন দাবা খেলা। এখন থেকে পরিচ্ছন্ন ইন্টারফেসে দাবা খেলুন। কোন রেজিস্ট্রেশনের দরকার নেই, নেই কোন বিজ্ঞাপন, এমনকি কোনও প্লাগইন-এরও প্রয়োজন নেই। দাবা খেলুন কম্পিউটারের সাথে, অথবা বন্ধুর সাথে অথবা অজানা যে কোন প্রতিপক্ষের সাথে।';

  @override
  String xJoinedTeamY(String param1, String param2) {
    return '$param1 যোগ দিলেন $param2 দলে';
  }

  @override
  String xCreatedTeamY(String param1, String param2) {
    return '$param1 বানালেন $param2 দল';
  }

  @override
  String get startedStreaming => 'স্ট্রিমিং চালু করেছেন';

  @override
  String xStartedStreaming(String param) {
    return '$param স্ট্রিমিং শুরু করেছেন';
  }

  @override
  String get averageElo => 'গড় ইলো';

  @override
  String get location => 'বসবাসস্থল';

  @override
  String get filterGames => 'খেলা ছাঁকন';

  @override
  String get reset => 'পুনরায় চালু করা';

  @override
  String get apply => 'প্রয়োগ';

  @override
  String get save => 'সংরক্ষন করুন';

  @override
  String get leaderboard => 'লিডারবোর্ড';

  @override
  String get screenshotCurrentPosition => 'বর্তমান অবস্থানে স্ক্রিনশট নিন';

  @override
  String get gameAsGIF => 'GIF হিসেবে';

  @override
  String get pasteTheFenStringHere => 'এখানে FEN স্ট্রিংটি জোড়া লাগান';

  @override
  String get pasteThePgnStringHere => 'এখানে PGN স্ট্রিংটি জোড়া লাগান';

  @override
  String get orUploadPgnFile => 'অথবা PGN আপলোড করুন';

  @override
  String get fromPosition => 'অবস্থা থেকে';

  @override
  String get continueFromHere => 'এখান থেকে আবার শুরু করুন';

  @override
  String get toStudy => 'স্টাডি';

  @override
  String get importGame => 'খেলা আমদানী';

  @override
  String get importGameExplanation => 'যখন একটি খেলার PGN যোগ করবেন আপনি পাবেন একটি ব্রাউজাবেল উত্তর,\nএকটি কম্পিউটার বিশ্লেষণ, একটি খেলা আলাপ এবং একটি ভাগাভাগি করার URL.';

  @override
  String get importGameCaveat => 'Variations will be erased. To keep them, import the PGN via a study.';

  @override
  String get importGameDataPrivacyWarning => 'এই PGN জনসাধারণের দ্বারা অধিগত করা যেতে পারে। ব্যক্তিগতভাবে একটি গেম ইমপোর্ট করতে, একটি স্টাডি ব্যবহার করুন.';

  @override
  String get thisIsAChessCaptcha => 'এটি হল দাবা CAPTCHA';

  @override
  String get clickOnTheBoardToMakeYourMove => 'বোর্ডে ক্লিক করে চাল দিয়ে প্রমাণ করুন যে আপনি সত্যিই মানুষ, রোবট নন।';

  @override
  String get captcha_fail => 'দয়া করে দাবার ক্যাপচা সমাধান করুন.';

  @override
  String get notACheckmate => 'এটি কিস্তিমাত নয়';

  @override
  String get whiteCheckmatesInOneMove => 'সাদা দলের একটি মুভে চেকমেট';

  @override
  String get blackCheckmatesInOneMove => 'কালো দলের একটি মুভে চেকমেট';

  @override
  String get retry => 'আবার চেষ্টা করুন';

  @override
  String get reconnecting => 'পুনঃসংযোগের চেষ্টা চলছে';

  @override
  String get noNetwork => 'অফলাইন';

  @override
  String get favoriteOpponents => 'প্রিয় প্রতিদ্বন্দ্বী';

  @override
  String get follow => 'অনুসরণ';

  @override
  String get following => 'অনুসরণ করছেন';

  @override
  String get unfollow => 'আর অনুসরণ নয়';

  @override
  String followX(String param) {
    return '$param-কে ফলো করুন';
  }

  @override
  String unfollowX(String param) {
    return '$paramকে অননুসরণ করুন';
  }

  @override
  String get block => 'বাধা দিন';

  @override
  String get blocked => 'বাধাগ্রস্ত';

  @override
  String get unblock => 'বাধা উঠিয়ে নিন';

  @override
  String get followsYou => 'আপনাকে অনুসরণ করছে';

  @override
  String xStartedFollowingY(String param1, String param2) {
    return '$param1 অনুসরণ করা শুরু করেছেন $param2';
  }

  @override
  String get more => 'আরও';

  @override
  String get memberSince => 'সদস্য রয়েছেন';

  @override
  String lastSeenActive(String param) {
    return 'শেষ আগমন $param';
  }

  @override
  String get player => 'খেলোয়াড়';

  @override
  String get list => 'তালিকা';

  @override
  String get graph => 'গ্রাফ';

  @override
  String get required => 'প্রয়োজনীয়';

  @override
  String get openTournaments => 'উন্মুক্ত টুর্নামেন্টগুলো';

  @override
  String get duration => 'সময়কাল';

  @override
  String get winner => 'বিজয়ী';

  @override
  String get standing => 'অপেক্ষারত';

  @override
  String get createANewTournament => 'নতুন টুর্নামেন্ট সৃষ্টি করুন';

  @override
  String get tournamentCalendar => 'টুর্নামেন্ট ক্যালেন্ডার';

  @override
  String get conditionOfEntry => 'এন্ট্রির শর্তাবলি:';

  @override
  String get advancedSettings => 'এডভান্সড সেটিংস';

  @override
  String get safeTournamentName => 'টুর্নামেন্টের জন্য একটি নিরাপদ নাম পছন্দ করুন।';

  @override
  String get inappropriateNameWarning => 'এমনকি সামান্য অনুপযুক্ত কিছুও আপনার অ্যাকাউন্ট বন্ধ করতে পারে।';

  @override
  String get emptyTournamentName => 'কোন গ্র্যান্ডমাস্টারের নামে টুর্নামেন্টের নাম দিতে চাইলে খালি রাখুন।';

  @override
  String get makePrivateTournament => 'পাসওয়ার্ড দিয়ে টুর্নামেন্টটি গোপনীয় এবং সিমাবদ্ধ করেদিন';

  @override
  String get join => 'যোগ দিন';

  @override
  String get withdraw => 'উঠিয়ে নিন';

  @override
  String get points => 'পয়েন্ট';

  @override
  String get wins => 'জয়';

  @override
  String get losses => 'পরাজয়';

  @override
  String get createdBy => 'তৈরি করেছেন';

  @override
  String get tournamentIsStarting => 'টুর্নামেন্ট শুরু হচ্ছে';

  @override
  String get tournamentPairingsAreNowClosed => 'ক্রীড়া-প্রতিযোগিতা যোগদান এখন বন্ধ হয়ে গেছে.';

  @override
  String standByX(String param) {
    return 'অপেক্ষিত $param, যোগদান খেলোয়ার, তৈরি হও!';
  }

  @override
  String get pause => 'বিরতি/Pause';

  @override
  String get resume => 'পুনরায় শুরু';

  @override
  String get youArePlaying => 'আপনি খেলতেছেন!';

  @override
  String get winRate => 'জয়ের অনুপাত';

  @override
  String get berserkRate => 'ক্ষিপ্ত অনুপাত';

  @override
  String get performance => 'সম্পাদন';

  @override
  String get tournamentComplete => 'ক্রীড়া-প্রতিযোগিতা সম্পন্ন হয়েছে';

  @override
  String get movesPlayed => 'খেলা সরানো হয়েছে';

  @override
  String get whiteWins => 'সাদা বিজয়ী';

  @override
  String get blackWins => 'কালো বিজয়ী';

  @override
  String get drawRate => 'ড্র হার';

  @override
  String get draws => 'সমান';

  @override
  String nextXTournament(String param) {
    return 'পরবর্তী $param ক্রীড়া-প্রতিযোগিতা:';
  }

  @override
  String get averageOpponent => 'গড় প্রতিদ্বন্দ্বী';

  @override
  String get boardEditor => 'বোর্ড সম্পাদক';

  @override
  String get setTheBoard => 'বোর্ড সেট করুন';

  @override
  String get popularOpenings => 'জনপ্রিয় চমক';

  @override
  String get endgamePositions => 'সমাপনী খেলার অবস্থান';

  @override
  String chess960StartPosition(String param) {
    return 'Chess960 এর শুরুর অবস্থান: $param';
  }

  @override
  String get startPosition => 'শুরুর অবস্থান';

  @override
  String get clearBoard => 'বোর্ড খালি করুন';

  @override
  String get loadPosition => 'অবস্থান পুনঃস্থাপন';

  @override
  String get isPrivate => 'ব্যক্তিগত';

  @override
  String reportXToModerators(String param) {
    return 'মডারেটরদের কাছে $param এর নামে রিপোর্ট করুন';
  }

  @override
  String profileCompletion(String param) {
    return 'প্রোফাইল সম্পন্ন: $param';
  }

  @override
  String xRating(String param) {
    return '$param অনুপাত';
  }

  @override
  String get ifNoneLeaveEmpty => 'যদি কিছুই না হয়, খালি রাখুন';

  @override
  String get profile => 'পরিচিতি';

  @override
  String get editProfile => 'পরিচিতি সম্পাদনা';

  @override
  String get realName => 'Real name';

  @override
  String get setFlair => 'আপনার ফ্লেয়ার সেট করুন';

  @override
  String get flair => 'ফ্লেয়ার';

  @override
  String get youCanHideFlair => 'পুরো সাইট জুড়ে সমস্ত ব্যবহারকারীর ফ্লেয়ার লুকানোর জন্য একটি সেটিং রয়েছে.';

  @override
  String get biography => 'জীবনবৃত্তান্ত';

  @override
  String get countryRegion => 'দেশ বা অঞ্চল';

  @override
  String get thankYou => 'ধন্যবাদ';

  @override
  String get socialMediaLinks => 'সোশ্যাল মিডিয়ার লিঙ্ক';

  @override
  String get oneUrlPerLine => 'প্রতি লাইনে একটি লিংক।';

  @override
  String get inlineNotation => 'রেখা চিহ্ন';

  @override
  String get makeAStudy => 'অধ্যায়ন নিরাপদ রাখার জন্য অন্য ইউজারদের সঙ্গে শেয়ারকরুন ও অধ্যায়ন তৈরি করুন.';

  @override
  String get clearSavedMoves => 'চাল গুলো মুছুন';

  @override
  String get previouslyOnLichessTV => 'এর আগে Lichess TV- তে যা হয়েছে';

  @override
  String get onlinePlayers => 'যে সমস্ত  খেলোয়ার অনলাইন আছে';

  @override
  String get activePlayers => 'সক্রিয় খেলোয়াড়গণ';

  @override
  String get bewareTheGameIsRatedButHasNoClock => 'সাবধান, এই খেলাটি মূল্যায়িত তবে কোনো সময়সীমা নেই!';

  @override
  String get success => 'সফল্য হয়েছে';

  @override
  String get automaticallyProceedToNextGameAfterMoving => 'স্বয়ংক্রিয় ভাবে পরবর্তী খেলায় যান';

  @override
  String get autoSwitch => 'স্বয়ংক্রিয় পরিবর্তন';

  @override
  String get puzzles => 'ধাঁধা';

  @override
  String get onlineBots => 'অনলাইন বটস';

  @override
  String get name => 'নাম';

  @override
  String get description => 'বিবরণ';

  @override
  String get descPrivate => 'ব্যাক্তিগত বর্ননা';

  @override
  String get descPrivateHelp => 'যে লেখা শুধু দলের সদস্য দেখতে পাবে.';

  @override
  String get no => 'না';

  @override
  String get yes => 'হ্যা';

  @override
  String get help => 'সাহায্য';

  @override
  String get createANewTopic => 'নতুন বিষয়  তৈরি করুন';

  @override
  String get topics => 'বিষয়';

  @override
  String get posts => 'লেখা';

  @override
  String get lastPost => 'শেষলেখা';

  @override
  String get views => 'দৃষ্টিপাত';

  @override
  String get replies => 'উত্তর';

  @override
  String get replyToThisTopic => 'এই বিষয়ে উত্তর দিন';

  @override
  String get reply => 'উত্তর';

  @override
  String get message => 'বার্তা';

  @override
  String get createTheTopic => 'বিষয় তৈরী করুন';

  @override
  String get reportAUser => 'কোনো user এর বিরুদ্ধে report করুন';

  @override
  String get user => 'user এর নাম';

  @override
  String get reason => 'কারণ';

  @override
  String get whatIsIheMatter => 'সম্পূর্ণ ঘটনার বিবরণ দেন';

  @override
  String get cheat => 'চিটিং করছে';

  @override
  String get troll => 'ব্যঙ্গ করছে';

  @override
  String get other => 'অন্য কোনো কারণ';

  @override
  String get reportDescriptionHelp => 'এখানে সেই খেলাটির link দেন এবং বলুন ওই ব্যক্তি ব্যবহারে কি অসুবিধা ছিল ?';

  @override
  String get error_provideOneCheatedGameLink => 'অনুগ্রহ করে একটা চিটেড গেমের লিংক দিন।';

  @override
  String by(String param) {
    return '$param এর দ্বারা';
  }

  @override
  String importedByX(String param) {
    return 'খেলাটি এনেছেন $param';
  }

  @override
  String get thisTopicIsNowClosed => 'এই বিষয়টি এখন শেষ হয়ে গেছে';

  @override
  String get blog => 'ব্লগ';

  @override
  String get notes => 'গুরুত্বপূর্ণ তথ্য';

  @override
  String get typePrivateNotesHere => 'এখানে নিজের ব্যক্তিগত  গুরুত্বপূর্ণ তথ্য লিখতে পারেন';

  @override
  String get writeAPrivateNoteAboutThisUser => 'এই ব্যবহারকারী সম্পর্কে ব্যক্তিগত নোট লিখুন';

  @override
  String get noNoteYet => 'এখন পর্যন্ত কোনো নোট নেই';

  @override
  String get invalidUsernameOrPassword => 'ব্যবহারকারী নাম অথবা পাসওয়ার্ড টি ঠিক নয়';

  @override
  String get incorrectPassword => 'ভুল সঙ্কেত শব্দ';

  @override
  String get invalidAuthenticationCode => 'ইনভ্যালিড অথেন্টিকেশন কোড';

  @override
  String get emailMeALink => 'আমাকে লিংক ইমেইল কর';

  @override
  String get currentPassword => 'বর্তমান পাসওয়ার্ড';

  @override
  String get newPassword => 'নতুন পাসওয়ার্ড';

  @override
  String get newPasswordAgain => 'নতুন পাসওয়ার্ড (পুনরায়)';

  @override
  String get newPasswordsDontMatch => 'নতুন পাসওয়ার্ড আগের সঙ্গে মিলে নি';

  @override
  String get newPasswordStrength => 'পাসওয়ার্ডের শক্তি';

  @override
  String get clockInitialTime => 'ঘড়ি অনুযায়ী প্রাথমিক সময়';

  @override
  String get clockIncrement => 'ঘড়ির সময়বৃদ্ধির হার';

  @override
  String get privacy => 'গোপনীয়তা';

  @override
  String get privacyPolicy => 'গোপনীয়তা নীতি';

  @override
  String get letOtherPlayersFollowYou => 'অন্যান্য খেলোয়ারদের আপানকে অনুসরন করতে দিন';

  @override
  String get letOtherPlayersChallengeYou => 'অন্যান্য খেলোয়ারদের আপানকে চ্যালেঞ্জ করতে দিন';

  @override
  String get letOtherPlayersInviteYouToStudy => 'অন্যান্য খেলোয়ারদের আপানকে আমন্ত্রন করতে দিন';

  @override
  String get sound => 'শব্দ';

  @override
  String get none => 'কিছুই না';

  @override
  String get fast => 'দ্রুত';

  @override
  String get normal => 'সাধারন';

  @override
  String get slow => 'ধীর';

  @override
  String get insideTheBoard => 'বোর্ডের মাধ্যে';

  @override
  String get outsideTheBoard => 'বোর্ডের বাহিরে';

  @override
  String get allSquaresOfTheBoard => 'All squares of the board';

  @override
  String get onSlowGames => 'খেলায় ধীর গতি';

  @override
  String get always => 'সব সময়';

  @override
  String get never => 'কখনই না';

  @override
  String xCompetesInY(String param1, String param2) {
    return '$param1 করা আছে মধ্যে $param2';
  }

  @override
  String get victory => 'বিজয়';

  @override
  String get defeat => 'হার';

  @override
  String victoryVsYInZ(String param1, String param2, String param3) {
    return '$param1 বানাম $param2 মধ্যে $param3';
  }

  @override
  String defeatVsYInZ(String param1, String param2, String param3) {
    return '$param1 বানাম $param2 মধ্যে $param3';
  }

  @override
  String drawVsYInZ(String param1, String param2, String param3) {
    return '$param1 বানাম $param2 মধ্যে $param3';
  }

  @override
  String get timeline => 'সময়রেখা';

  @override
  String get starting => 'শুরু হইতেছে:';

  @override
  String get allInformationIsPublicAndOptional => 'সব তথ্য হয় সরকারী এবং ঐচ্ছিক.';

  @override
  String get biographyDescription => 'আপনার সম্পর্কে বলুন, দাবায় আপনি কি পচ্ছন্দ করেন, আপনার প্রিয় সাইটগুলো, খেলা, খেলোয়াড়দের সম্পর্কে বলুন…';

  @override
  String get listBlockedPlayers => 'আপনি যাদের অবরুদ্ধ করেছেন তাদের তালিকা';

  @override
  String get human => 'মানুষ';

  @override
  String get computer => 'কম্পিউটার';

  @override
  String get side => 'পাশে';

  @override
  String get clock => 'ঘড়ি';

  @override
  String get opponent => 'প্রতিদ্বন্দ্বী';

  @override
  String get learnMenu => 'শেখা';

  @override
  String get studyMenu => 'অধ্যায়ন';

  @override
  String get practice => 'অনুশীলন';

  @override
  String get community => 'সম্প্রদায়';

  @override
  String get tools => 'সরঞ্জামসমূহ';

  @override
  String get increment => 'মুনাফা';

  @override
  String get error_unknown => 'অচল মান';

  @override
  String get error_required => 'এই ঘরটি পূরন করা আবশ্যক';

  @override
  String get error_email => 'ইমেইল ঠিকানাটি বৈধ নয়';

  @override
  String get error_email_acceptable => 'ইমেইল ঠিকানাটি গ্রহণযোগ্য নয়। দয়া করে পুনরায় চেক করুন, অত‍ঃপর চেষ্টা করুন।';

  @override
  String get error_email_unique => 'ইমেইল টি অকার্যকর বা ইতোমধ্যে ব্যবহৃত';

  @override
  String get error_email_different => 'এটি আপনার বর্তমানে ব্যবহৃত ইমেইল ঠিকানা';

  @override
  String error_minLength(String param) {
    return 'পাসওয়ার্ড অন্তত $param বর্ণ/চিহ্ন দীর্ঘ হতে হবে';
  }

  @override
  String error_maxLength(String param) {
    return 'পাসওয়ার্ড সর্বোচ্চ $param বর্ণ/চিহ্ন দীর্ঘ হতে পারবে';
  }

  @override
  String error_min(String param) {
    return 'অবশ্যই $param দীর্ঘ হতে হবে।';
  }

  @override
  String error_max(String param) {
    return 'অবশ্যই $param এর মধ্যে হতে হবে।';
  }

  @override
  String ifRatingIsPlusMinusX(String param) {
    return 'যদি অনুপাত হয় ± $param';
  }

  @override
  String get ifRegistered => 'নিবন্ধিত';

  @override
  String get onlyExistingConversations => 'বিদ্যমান কথোপকথন';

  @override
  String get onlyFriends => 'শুধু বন্ধুরা';

  @override
  String get menu => 'মেনু';

  @override
  String get castling => 'কাস্টেলিং';

  @override
  String get whiteCastlingKingside => 'সাদা O-O';

  @override
  String get blackCastlingKingside => 'কালো O-O';

  @override
  String tpTimeSpentPlaying(String param) {
    return 'খেলার সময় অতিবাহিত: $param';
  }

  @override
  String get watchGames => 'খেলাগুলো দেখুন';

  @override
  String tpTimeSpentOnTV(String param) {
    return 'টিভির সময়: $param';
  }

  @override
  String get watch => 'দেখুন';

  @override
  String get videoLibrary => 'ভিডিও লাইব্রেরি';

  @override
  String get streamersMenu => 'স্ট্রিমারকারীরা';

  @override
  String get mobileApp => 'মোবাইল অ্যাপ';

  @override
  String get webmasters => 'ওয়েবমাস্টারগুলো';

  @override
  String get about => 'সম্পর্কে';

  @override
  String aboutX(String param) {
    return '$param সম্পর্কে';
  }

  @override
  String xIsAFreeYLibreOpenSourceChessServer(String param1, String param2) {
    return '$param1 বিনামুল্যে ($param2), লাইব্রেরী, এড-মুক্ত, ওপেনসোর্স দাবার সার্ভার.';
  }

  @override
  String get really => 'সত্যিকার অর্থেই';

  @override
  String get contribute => 'অবদান';

  @override
  String get termsOfService => 'পরিষেবার শর্তাদি';

  @override
  String get sourceCode => 'উৎস সংকেতলিপি';

  @override
  String get simultaneousExhibitions => 'সমকালবর্তী প্রদর্শন';

  @override
  String get host => 'স্বাগতিক';

  @override
  String hostColorX(String param) {
    return 'হোস্ট রং: $param';
  }

  @override
  String get yourPendingSimuls => 'আপনার অমীমাংসিত সিমুলস';

  @override
  String get createdSimuls => 'নতুন সিমুলস তৈরি হয়েছে';

  @override
  String get hostANewSimul => 'একটি নতুন সিমুল স্বাগতিক';

  @override
  String get signUpToHostOrJoinASimul => 'সিমুল হোস্ট করতে বা সিমুলে যোগ দিতে সাইন আপ করুন';

  @override
  String get noSimulFound => 'একসঙ্গে খুঁজে পাওয়া যায়নি';

  @override
  String get noSimulExplanation => 'এই যুগপত প্রদর্শনী বিদ্যমান নেই.';

  @override
  String get returnToSimulHomepage => 'সিমুল প্রথমপাতায় ফিরে যান';

  @override
  String get aboutSimul => 'সিমুলস একজন খেলোয়াড় মুখোমুখি হয় একসজ্ঞে কয়েকজন খেলোয়াড়ের সাথে.';

  @override
  String get aboutSimulImage => '50 প্রতিদ্বন্দ্বীর মধ্যে, ফিশার জিতেছে 47 খেলা, সমান 2 এবং হার 1.';

  @override
  String get aboutSimulRealLife => 'এই ধারনাটি নেওয়া হয় পৃথিবীর বাস্তব ঘটনা গুলো থেকে, বাস্তব জীবনে, স্বাগতিক সিমুল জরিত টেবিল সরানো থেকে টেবিল একক ভাবে চালার জন্য.';

  @override
  String get aboutSimulRules => 'যখন সিমুল শুরু হয়, প্রত্যেক খেলোয়াড় শুরু করে স্বাগতিকের সাথে একটি খেলা, যে পায় খেলার জন্য সাদা টুকরোগুলো, যখন সব খেলা সম্পন্ন হয় তখন সিমুল শেষ হয়ে যায়.';

  @override
  String get aboutSimulSettings => 'সিমুলগুলো হয় সবসময় আকস্মিক. পূনারয়খেলা, পেছনেনেওয়া এবং \"অনেকসময়\" বিকল হয়.';

  @override
  String get create => 'তৈরি করুন';

  @override
  String get whenCreateSimul => 'যখন আপনি একটি সিমুল তৈরি করেন, আপনি খেলার জন্য একাধিক খেলোয়ার পাবেন.';

  @override
  String get simulVariantsHint => 'যদি আপনি বিভিন্ন অপশন নির্বাচন করেন, প্রতিটি খেলোয়াড়কে বেছে নিতে হবে যেটা সে খেলতে চায়.';

  @override
  String get simulClockHint => 'ফিশার ঘড়ি বিন্যাস. একবারে অনেক খেলোয়াড় নিলে, হয়তো আপনার অনেক সময় প্রয়োজন হবে.';

  @override
  String get simulAddExtraTime => 'আপনি হয়তো অতিরিক্ত সময় যোগ করে আপনার ঘড়ি সিমুলের সাথে মোকাবেলা করতে পারবেন.';

  @override
  String get simulHostExtraTime => 'অতিরিক্ত ঘড়ির সময়ের স্বাগতিক';

  @override
  String get simulAddExtraTimePerPlayer => 'সিমুলে যোগদানকারী প্রতিটি খেলোয়াড়ের জন্য আপনার ঘড়িতে ইনিশিয়াল সময় যোগ করুন.';

  @override
  String get simulHostExtraTimePerPlayer => 'হোষ্ট একস্ত্রা ক্লক টাইম প্রতি খেলোয়াড়ের জন্য';

  @override
  String get lichessTournaments => 'দাবা ক্রীড়া-প্রতিযোগিতা';

  @override
  String get tournamentFAQ => 'কর্মক্ষেত্র প্রতিযোগিতার প্রশ্নবলী';

  @override
  String get timeBeforeTournamentStarts => 'সময়ের পূর্বে প্রতিযোগিতা শুরু';

  @override
  String get averageCentipawnLoss => 'গড় ছিন্টেপাওন ক্ষতি';

  @override
  String get accuracy => 'নির্ভুলতা';

  @override
  String get keyboardShortcuts => 'কী-বোর্ড শর্টকাট';

  @override
  String get keyMoveBackwardOrForward => 'পেছনে সরান/সামনে যান';

  @override
  String get keyGoToStartOrEnd => 'শুরু করতে যান/শেষ';

  @override
  String get keyCycleSelectedVariation => 'Cycle selected variation';

  @override
  String get keyShowOrHideComments => 'দেখুন/মন্তব্য লুকান';

  @override
  String get keyEnterOrExitVariation => 'প্রবেশ করান/বেরিয়ে যান';

  @override
  String get keyRequestComputerAnalysis => 'কম্পিউটার বিশ্লেষণের জন্য অনুরোধ করুন, আপনার ভুলগুলো থেকে শিখুন';

  @override
  String get keyNextLearnFromYourMistakes => 'পরবর্তী (আপনার ভুল থেকে শিখুন)';

  @override
  String get keyNextBlunder => 'পরবর্তী সাঙ্ঘাতিক ভুল';

  @override
  String get keyNextMistake => 'পরবর্তী ভুল';

  @override
  String get keyNextInaccuracy => 'পরবর্তী নির্ভুলতা';

  @override
  String get keyPreviousBranch => 'আগের শাখা';

  @override
  String get keyNextBranch => 'পরবর্তী শাখা';

  @override
  String get toggleVariationArrows => 'Toggle variation arrows';

  @override
  String get cyclePreviousOrNextVariation => 'Cycle previous/next variation';

  @override
  String get toggleGlyphAnnotations => 'Toggle move annotations';

  @override
  String get togglePositionAnnotations => 'Toggle position annotations';

  @override
  String get variationArrowsInfo => 'ভ্যারিয়েসন অ্যারোঁগুলি আপনাকে চাল তালিকা ব্যবহার না করেই নেভিগেট করতে দেয়.';

  @override
  String get playSelectedMove => 'নির্বাচিত চাল খেলুন';

  @override
  String get newTournament => 'নতুন ক্রীড়া-প্রতিযোগিতা';

  @override
  String get tournamentHomeTitle => 'দাবা ক্রীড়া-প্রতিযোগিতা বিভিন্ন সময় নিয়ন্ত্রণ এবং বৈকল্পিক দেখানো হয়েছে';

  @override
  String get tournamentHomeDescription => 'দ্রুত-গুরূত্বপূর্ণ দাবা প্রতিযোগিতা খেলুন! একটি অফিসিয়াল সময়সূচী প্রতিযোগিতায় যোগ দিন অথবা নিজের তৈরি করুন. বুল্লেট, বিলটজ, ক্লাসিক্যাল, দাবা960, পাহাড়ের রাজা, তিনরেখা, এবং আরো অপশন রয়েছে দাবা মজার জন্য.';

  @override
  String get tournamentNotFound => 'ক্রীড়া-প্রতিযোগিতা খুজে পাওয়া যাইনি';

  @override
  String get tournamentDoesNotExist => 'এই ক্রীড়া-প্রতিযোগিতার অস্তিত্ব নেই.';

  @override
  String get tournamentMayHaveBeenCanceled => 'ক্রীড়া-প্রতিযোগিতা শুরু হওয়ার পূর্বে যদি সব খেলোয়াড় বেড়িয়ে যায়, হয়তো এটা বাতিল করা হতে পারে.';

  @override
  String get returnToTournamentsHomepage => 'ফিরেযান ক্রীড়া-প্রতিযোগিতার প্রথম পাতায়';

  @override
  String weeklyPerfTypeRatingDistribution(String param) {
    return 'সাপ্তাহিক $param অনুপাত বন্টন';
  }

  @override
  String yourPerfTypeRatingIsRating(String param1, String param2) {
    return 'আপনার $param1 অনুপাত হয় $param2.';
  }

  @override
  String youAreBetterThanPercentOfPerfTypePlayers(String param1, String param2) {
    return 'আপনি তুলনায় ভাল $param1 এর $param2 খেলোয়াড়দের.';
  }

  @override
  String userIsBetterThanPercentOfPerfTypePlayers(String param1, String param2, String param3) {
    return '$param1 $param2 উত্তম $param3 খেলোয়াড়ের থেকে.';
  }

  @override
  String betterThanPercentPlayers(String param1, String param2) {
    return '$param2 খেলোয়াড়দের মধ্যে $param1 এর চেয়ে ভালো';
  }

  @override
  String youDoNotHaveAnEstablishedPerfTypeRating(String param) {
    return 'আপনার প্রতিষ্ঠিত কোন $param অনুপাত নেই.';
  }

  @override
  String get yourRating => 'আপনার রেটিংস';

  @override
  String get cumulative => 'বর্ধিত';

  @override
  String get glicko2Rating => 'গ্লাইকো-২ রেটিং';

  @override
  String get checkYourEmail => 'আপনার ই-মেইল চেক করুন';

  @override
  String get weHaveSentYouAnEmailClickTheLink => 'আমরা আপনাকে একটি ই-মেইল পাঠিয়েছি. একাউন্টি সক্তিয় করার জন্য ই-মেইল দেওয়া লিংকটি ক্লিক করুন.';

  @override
  String get ifYouDoNotSeeTheEmailCheckOtherPlaces => 'যদি আপনি ই-মেইলটি না দেখতে পান, অন্যজাগায় থাকতে পারে, যেমন আপনার জুনক, স্প্যাম, সোসিয়াল, অথবা অন্য ফোল্ডার.';

  @override
  String weHaveSentYouAnEmailTo(String param) {
    return 'আমরা একটি ই-মেইল পাঠিয়েছি $param. ই-মেইলে দেওয়া লিংকে ক্লিক করুন পাসওয়ার্ড পরিবর্তন করতে.';
  }

  @override
  String byRegisteringYouAgreeToBeBoundByOur(String param) {
    return 'নিবন্ধন করে, আপনি সম্মত হন আমাদের দ্বারা আবদ্ধ হতে $param.';
  }

  @override
  String readAboutOur(String param) {
    return 'আমাদের $param সম্পর্কে পড়ুন.';
  }

  @override
  String get networkLagBetweenYouAndLichess => 'আপনার এবং লিচেস এর মধ্যে নেটওয়ার্ক ব্যবধান';

  @override
  String get timeToProcessAMoveOnLichessServer => 'লিচেস সার্ভারে স্থানান্তর প্রক্রিয়া করার সময়';

  @override
  String get downloadAnnotated => 'টীকাযুক্ত ডাউনলোড করুন';

  @override
  String get downloadRaw => 'কাঁচা ডাউনলোড করুন';

  @override
  String get downloadImported => 'আগমিত ডাউনলোড করুন';

  @override
  String get crosstable => 'ক্রোস্ট্যাবলে';

  @override
  String get youCanAlsoScrollOverTheBoardToMoveInTheGame => 'খেলা সরাতে আপনি বোর্ডের উপর স্ক্রল ও করতে পারবেন.';

  @override
  String get scrollOverComputerVariationsToPreviewThem => 'প্রিভিউ দেখার জন্য কম্পিউটার ভ্যারিয়েশনের উপর স্ক্রল করুন।';

  @override
  String get analysisShapesHowTo => 'সিফ্ট+ক্লিক চাপুন অথবা ডান-ক্লিক করুন বোর্ডের উপর বৃত্ত এবং তীর আঁকার জন্য.';

  @override
  String get letOtherPlayersMessageYou => 'অন্যান্য খেলোয়ারদের আপনাকে বার্তা করতে দিন';

  @override
  String get receiveForumNotifications => 'নোটিফিকেশন পাবেন যখন ফোরামে আপনাকে কেউ উল্লেখ করে';

  @override
  String get shareYourInsightsData => 'আপনার দাবার অর্ন্তদৃষ্টি তথ্য শেয়ার করুন';

  @override
  String get withNobody => 'কারো সাথে না';

  @override
  String get withFriends => 'বন্ধুদের সাথে';

  @override
  String get withEverybody => 'সবার সাথে';

  @override
  String get kidMode => 'বাচ্চা ধরন';

  @override
  String get kidModeIsEnabled => 'কিড মোড সক্রিয় করা আছে.';

  @override
  String get kidModeExplanation => 'এটা হয় নিরাপত্তা সম্পর্কে. বাচ্চা ধরনের মধ্যে সব সাইটের যোগাযোগ নিষ্ক্রিয় করা হয়েছে. আপনার বাচ্চা এবং বিদ্যালয়ের ছাত্রদের, অন্য ইন্টারনেট ব্যবহারকারীদের থেকে রক্ষা করতে এটা সক্রিয় করুন.';

  @override
  String inKidModeTheLichessLogoGetsIconX(String param) {
    return 'বাচ্চা ধরনের মধ্যে, লিচেস লোগো পায় একটি $param প্রতীক,\nতাই আপনি জানতে পারবেন আপনার বাচ্চা নিরাপদ.';
  }

  @override
  String get askYourChessTeacherAboutLiftingKidMode => 'আপনার অ্যাকাউন্ট পরিচালিত করা হয়. কিড মোড উত্তোলন সম্পর্কে আপনার দাবা শিক্ষককে জিজ্ঞাসা করুন.';

  @override
  String get enableKidMode => 'বাচ্চা ধরন সক্রিয় করুন';

  @override
  String get disableKidMode => 'বাচ্চা ধরন নিষ্ক্রিয় করুন';

  @override
  String get security => 'নিরাপত্তা';

  @override
  String get sessions => 'সেশনসমূহ';

  @override
  String get revokeAllSessions => 'সকল সেশন বাতিল করুন';

  @override
  String get playChessEverywhere => 'দাবা খেলুন সব জায়গায়';

  @override
  String get asFreeAsLichess => 'যেমন লিচাস মুক্ত হিসাবে';

  @override
  String get builtForTheLoveOfChessNotMoney => 'দাবার ভালবাসার জন্য তৈরি, টাকা না';

  @override
  String get everybodyGetsAllFeaturesForFree => 'সকলেই পাবে বিনামূল্যে সব বৈশিষ্ট্য';

  @override
  String get zeroAdvertisement => 'শূন্য বিজ্ঞাপন';

  @override
  String get fullFeatured => 'সম্পূর্ণ বৈশিষ্ট্যযুক্ত';

  @override
  String get phoneAndTablet => 'ফোন এবং ট্যাবলেট';

  @override
  String get bulletBlitzClassical => 'গুলি, খুব দ্রুত আক্রমণ, ক্লাসিকাল';

  @override
  String get correspondenceChess => 'সাদৃশ্য দাবা';

  @override
  String get onlineAndOfflinePlay => 'অনলাইন এবং অফলাইন খেলা';

  @override
  String get viewTheSolution => 'সমাধান দেখুন';

  @override
  String get followAndChallengeFriends => 'অনুসরন করুন এবং বন্ধুদের চ্যালেঞ্জ করুন';

  @override
  String get gameAnalysis => 'খেলা বিশ্লেষন';

  @override
  String xHostsY(String param1, String param2) {
    return '$param1 নির্মানকর্তা $param2';
  }

  @override
  String xJoinsY(String param1, String param2) {
    return '$param1 যোগদেয় $param2';
  }

  @override
  String xLikesY(String param1, String param2) {
    return '$param1 পচ্ছন্দ $param2';
  }

  @override
  String get quickPairing => 'দ্রুত জোর-বাঁধানো';

  @override
  String get lobby => 'উপশালা';

  @override
  String get anonymous => 'অজ্ঞাত';

  @override
  String yourScore(String param) {
    return 'আপনার স্কোর: $param';
  }

  @override
  String get language => 'ভাষা';

  @override
  String get background => 'পটভূমি';

  @override
  String get light => 'আলো';

  @override
  String get dark => 'অন্ধকার';

  @override
  String get transparent => 'স্বচ্ছ';

  @override
  String get deviceTheme => 'ডিভাইস থিম';

  @override
  String get backgroundImageUrl => 'পটভূমি ছবির URL:';

  @override
  String get board => 'বোর্ড';

  @override
  String get size => 'সাইজ';

  @override
  String get opacity => 'অসস্বচছলতা';

  @override
  String get brightness => 'ব্রাইটনেস';

  @override
  String get hue => 'হিউ';

  @override
  String get boardReset => 'ডিফল্টে রং রিসেট করুন';

  @override
  String get pieceSet => 'টুকরা সেট';

  @override
  String get embedInYourWebsite => 'আপনার ওয়েবসাইটে বসান';

  @override
  String get usernameAlreadyUsed => 'এই ব্যবহারকারীর নাম ইতিমধ্যে ব্যবহার করা হয়েছে, দয়া করে অন্য একটি চেষ্টা করুন.';

  @override
  String get usernamePrefixInvalid => 'ইউজারনেম অবশ্যই কোন অক্ষর দ্বারা শুরু হতে হবে।';

  @override
  String get usernameSuffixInvalid => 'ইউজারনেম অবশ্যই কোন অক্ষর বা সংখ্যা দ্বারা শেষ হতে হবে।';

  @override
  String get usernameCharsInvalid => 'ইউজারনেমে শুধুমাত্র অক্ষর, নাম্বার, আন্ডারস্কোর এবং হাইফেন থাকতে পারবে।';

  @override
  String get usernameUnacceptable => 'এই ব্যবহারকারী নামটি গ্রহণযোগ্য নয়.';

  @override
  String get playChessInStyle => 'দাবা খেলুন শৈলিতে';

  @override
  String get chessBasics => 'দাবা মূলসূত্র';

  @override
  String get coaches => 'প্রশিক্ষক';

  @override
  String get invalidPgn => 'অকার্যকর PGN';

  @override
  String get invalidFen => 'অকার্যকর FEN';

  @override
  String get custom => 'স্বনির্ধারিত';

  @override
  String get notifications => 'বিজ্ঞাপন';

  @override
  String notificationsX(String param1) {
    return 'নোটিফিকেশন: $param1';
  }

  @override
  String perfRatingX(String param) {
    return 'অনুপাত: $param';
  }

  @override
  String get practiceWithComputer => 'কম্পিউটারের সাথে অনুশীলন';

  @override
  String anotherWasX(String param) {
    return 'আরেকটি ছিল $param';
  }

  @override
  String bestWasX(String param) {
    return 'সেরা ছিল $param';
  }

  @override
  String get youBrowsedAway => 'আপনি যতদূর ব্রাউজ করেছেন';

  @override
  String get resumePractice => 'পুনারয় অনুশীলন';

  @override
  String get drawByFiftyMoves => 'খেলাটি পঞ্চাশ চালের নিয়মে ড্র হয়েছে.';

  @override
  String get theGameIsADraw => 'খেলাটি হয় সমান.';

  @override
  String get computerThinking => 'কম্পিউটারের চিন্তা ...';

  @override
  String get seeBestMove => 'দেখুন সেরা চাল';

  @override
  String get hideBestMove => 'লুকান সেরা চাল';

  @override
  String get getAHint => 'একটি সূত্র পান';

  @override
  String get evaluatingYourMove => 'আপনার চাল মূল্যায়ন করবে...';

  @override
  String get whiteWinsGame => 'সাদা জিতেছে';

  @override
  String get blackWinsGame => 'কালো জিতেছে';

  @override
  String get learnFromYourMistakes => 'আপনার ভুলগুলো থেকে শিখুন';

  @override
  String get learnFromThisMistake => 'এই ভুল থেকে শিখুন';

  @override
  String get skipThisMove => 'এই ধাপটি এড়িয়ে যান';

  @override
  String get next => 'পরবর্তী';

  @override
  String xWasPlayed(String param) {
    return '$param খেলা হয়েছিল';
  }

  @override
  String get findBetterMoveForWhite => 'সাদার জন্য একটি ভালো চাল খুঁজুন';

  @override
  String get findBetterMoveForBlack => 'কালোর জন্য একটি ভালো চাল খুঁজুন';

  @override
  String get resumeLearning => 'পুনারয় শিখুন';

  @override
  String get youCanDoBetter => 'আপনি ভালো করতে পারেন';

  @override
  String get tryAnotherMoveForWhite => 'সাদার জন্য আরেকটি চাল চেষ্টা করুন';

  @override
  String get tryAnotherMoveForBlack => 'কালোর জন্য আরেকটি চাল চেষ্টা করুন';

  @override
  String get solution => 'সমাধান';

  @override
  String get waitingForAnalysis => 'অপেক্ষা করা হচ্ছে বিশ্লেষণের জন্য';

  @override
  String get noMistakesFoundForWhite => 'সাদার জন্য কোন ভুল পাওয়া যায়নি';

  @override
  String get noMistakesFoundForBlack => 'কালোর জন্য কোন ভুল পাওয়া যায়নি';

  @override
  String get doneReviewingWhiteMistakes => 'সাদার ভুল পর্যালোচনা করা হয়েছে';

  @override
  String get doneReviewingBlackMistakes => 'কালোর ভুল পর্যালোচনা করা হয়েছে';

  @override
  String get doItAgain => 'এটা পুনারয় করুন';

  @override
  String get reviewWhiteMistakes => 'সাদার ভুল পর্যালোচনা';

  @override
  String get reviewBlackMistakes => 'কালোর ভুল পর্যালোচনা';

  @override
  String get advantage => 'সুবিধা';

  @override
  String get opening => 'উদ্বোধন';

  @override
  String get middlegame => 'মাধ্যমখেলা';

  @override
  String get endgame => 'খেলাশেষ';

  @override
  String get conditionalPremoves => 'শর্তাধীন পুনারয়চাল';

  @override
  String get addCurrentVariation => 'বর্তমান ভিন্ন করুন';

  @override
  String get playVariationToCreateConditionalPremoves => 'শর্তাধীন পুনারয় চাল তৈরির জন্য একটি ভিন্ন খেলুন';

  @override
  String get noConditionalPremoves => 'পুনারয়চাল শর্তাধীন নেই';

  @override
  String playX(String param) {
    return 'খেলা $param';
  }

  @override
  String get showUnreadLichessMessage => 'আপনি Lichess থেকে একটি ব্যক্তিগত বার্তা পেয়েছেন.';

  @override
  String get clickHereToReadIt => 'পড়তে এখানে ক্লিক করুন';

  @override
  String get sorry => 'দুঃখিত :(';

  @override
  String get weHadToTimeYouOutForAWhile => 'আমাদের কিছুক্ষণের জন্য আপনাকে বিরতি হল।';

  @override
  String get why => 'কেন';

  @override
  String get pleasantChessExperience => 'আমাদের লক্ষ্য প্রত্যেকের জন্য একটি আনন্দদায়ক দাবা খেলার অভিজ্ঞতা দেয়া।';

  @override
  String get goodPractice => 'সেই লক্ষ্যে আমাদের অবশ্যই নিশ্চিত করতে হবে যে সমস্ত খেলোয়াড় ভাল অভ্যাস চর্চা করে।';

  @override
  String get potentialProblem => 'যখন এধরনের সমস্যা ধরা পড়ে তখনই আমরা এই মেসেজ দিই.';

  @override
  String get howToAvoidThis => 'কিভাবে এসব এড়িয়ে চলবো?';

  @override
  String get playEveryGame => 'যে গেম খেলা শুরু করবেন তা অবশ্যই শেষ করবেন.';

  @override
  String get tryToWin => 'জেতার চেষ্টা করুন (অথবা ড্র) যেসব গেম খেলছেন.';

  @override
  String get resignLostGames => 'হেরে জাওা খেলা তি রেসিগ্ন করুন।( সময় সেশ হওার অপ্পেখা করবেন না)।.';

  @override
  String get temporaryInconvenience => 'অস্থায়ীভাবে এই অসুবিধার জন্য আমরা ক্ষমা প্রার্থনা করছি,';

  @override
  String get wishYouGreatGames => 'এবং lichess.org এ আপনার দুর্দান্ত গেমের শুভেচ্ছা.';

  @override
  String get thankYouForReading => 'পড়ার জন্য ধন্যবাদ!';

  @override
  String get lifetimeScore => 'সারাজীবনের স্কোর';

  @override
  String get currentMatchScore => 'বর্তমান ম্যাচের স্কোর';

  @override
  String get agreementAssistance => 'আমি সম্মতি এবং প্রতিশ্রুতি দিচ্ছি যে দাবা খেলার সময় কম্পিউটারের সহায়তা নিয়ে, কোনো প্রোগ্রাম বই, ডেটাবেজ বা অন্যকোনো ব্যাক্তির সহায়তা নিয়ে চিটিং করে খেলবো না).';

  @override
  String get agreementNice => 'আমি সম্মতি জানাচ্ছি সকল দাবাড়ু খেলোয়াড়দের সঙ্গে শ্রদ্ধাশীল আচরন করবো.';

  @override
  String agreementMultipleAccounts(String param) {
    return 'আমি একমত পোষণ করছি যে আমি একাধিক একাউন্ট তৈরি করব না ($param এ উল্লেখিত কারণ ব্যতীত)।';
  }

  @override
  String get agreementPolicy => 'আমি সম্মতি জানাচ্ছি যে আমি লাইচেজের সকল নিয়মকানুন মেনে চলবো.';

  @override
  String get searchOrStartNewDiscussion => 'খুজুন অথবা নতুন মেসেজ কনভার্সনে যান';

  @override
  String get edit => 'এডিট বা সম্পাদন করুন';

  @override
  String get bullet => 'বুলেট';

  @override
  String get blitz => 'ব্লিজ';

  @override
  String get rapid => 'র‍্যাপিড';

  @override
  String get classical => 'ক্লাসিক্যাল';

  @override
  String get ultraBulletDesc => 'অত্যন্ত দ্রুত গেমস: 30 সেকেন্ডেরও কম';

  @override
  String get bulletDesc => 'খুবই দ্রুত গেমস: 3 মিনিটেরও কম';

  @override
  String get blitzDesc => 'দ্রুত গেমস: 3 থেকে 8 মিনিট';

  @override
  String get rapidDesc => 'র‍্যাপিড গেমস: 3 থেকে 8 মিনিট';

  @override
  String get classicalDesc => 'ক্লাসিক্যাল গেমস: ২৫ মিনিট বা তার বেশি';

  @override
  String get correspondenceDesc => 'কোরেস্পডেন্স গেমস: এক বা একাধিক দিনের চাল';

  @override
  String get puzzleDesc => 'দাবা কৌশলের প্রশিক্ষক';

  @override
  String get important => 'গুরুত্বপূর্ণ';

  @override
  String yourQuestionMayHaveBeenAnswered(String param1) {
    return 'হয়তো আপনার প্রশ্নের উত্তর রয়েছেই $param1';
  }

  @override
  String get inTheFAQ => 'F.A.Q এর মধ্যে.';

  @override
  String toReportSomeoneForCheatingOrBadBehavior(String param1) {
    return 'প্রতারনারমুলক কাজ বা খারাপ আচরনের জন্য রিপোর্ট, $param1';
  }

  @override
  String get useTheReportForm => 'এই রিপোর্ট ফোরাম ব্যাবহার করুন';

  @override
  String toRequestSupport(String param1) {
    return 'সমর্থনের জন্য অনুরোধ করতে, $param1';
  }

  @override
  String get tryTheContactPage => 'যোগাযোগ পেজে যেয়ে দেখতে পারেন';

  @override
  String makeSureToRead(String param1) {
    return 'অনুগ্রহ করে $param1 পড়ুন';
  }

  @override
  String get theForumEtiquette => 'ফোরাম শিষ্টাচার';

  @override
  String get thisTopicIsArchived => 'এই টপিক বা বিষয়টি সংরক্ষণাগারভুক্ত করা হয়েছে সুতরাং এর জবাব আর দেওয়া যাবে না.';

  @override
  String joinTheTeamXToPost(String param1) {
    return 'যুক্ত হোন $param1, এই ফোরামে পোষ্ট করার জন্য';
  }

  @override
  String teamNamedX(String param1) {
    return '$param1 দল';
  }

  @override
  String get youCannotPostYetPlaySomeGames => 'আপনি এখন ফোরামে পোষ্ট করতে পারবেন না. আগে কিছু গেম খেলুন!';

  @override
  String get subscribe => 'সাবস্ক্রাইব';

  @override
  String get unsubscribe => 'আনসাবস্ক্রাইব';

  @override
  String mentionedYouInX(String param1) {
    return '\"$param1\" এ আপনাকে উল্লেখ করেছেন।';
  }

  @override
  String xMentionedYouInY(String param1, String param2) {
    return '$param1 , \"$param2\" এ আপনার নাম উল্লেখ করেছেন।';
  }

  @override
  String invitedYouToX(String param1) {
    return '\"$param1\" এ আপনাকে আমন্ত্রণ জানিয়েছেন।';
  }

  @override
  String xInvitedYouToY(String param1, String param2) {
    return '$param1, আপনাকে \"$param2\" এ আমন্ত্রণ জানিয়েছেন।';
  }

  @override
  String get youAreNowPartOfTeam => 'আপনি এখন দলের একটি অংশ।';

  @override
  String youHaveJoinedTeamX(String param1) {
    return 'আপনি \"$param1\" এ যোগদান করেছেন।';
  }

  @override
  String get someoneYouReportedWasBanned => 'আপনি অভিযুক্ত একজনকে ব্যান করা হয়েছে';

  @override
  String get congratsYouWon => 'অভিনন্দন, আপনি জিতেছেন!';

  @override
  String gameVsX(String param1) {
    return 'খেলা বনাম $param1';
  }

  @override
  String resVsX(String param1, String param2) {
    return '$param1 বনাম $param2';
  }

  @override
  String get lostAgainstTOSViolator => 'আপনি এমন কারোর সাথে হেরেছেন যে Liches TOS ভঙ্গ করেছে';

  @override
  String refundXpointsTimeControlY(String param1, String param2) {
    return 'ফেরত: $param1 $param2 রেটিং পয়েন্ট।';
  }

  @override
  String get timeAlmostUp => 'সময় প্রায় শেষ!';

  @override
  String get clickToRevealEmailAddress => '[ইমেইল অ্যাড্রেস দেখতে ক্লিক করুন]';

  @override
  String get download => 'ডাউনলোড করুন';

  @override
  String get coachManager => 'প্রশিক্ষক ব্যবস্থাপনা';

  @override
  String get streamerManager => 'সম্প্রচার নিয়ন্ত্রণ';

  @override
  String get cancelTournament => 'টুর্নামেন্ট বাতিল করুন';

  @override
  String get tournDescription => 'টুর্নামেন্টের বর্ণনা';

  @override
  String get tournDescriptionHelp => 'অংশগ্রহণকারীদের কিছু বলতে চান? সংক্ষেপে লেখার চেষ্টা করুন।\nMarkdown links ব্যবহারযোগ্য: [name](https://url)';

  @override
  String get ratedFormHelp => 'খেলাগুলো রেটেড/পয়েন্ট ভিত্তিক এবং খেলোয়াড়দের রেটিং এ প্রভাব ফেলবে';

  @override
  String get onlyMembersOfTeam => 'শুধুমাত্র দলের সদস্যরা';

  @override
  String get noRestriction => 'কোনো বিধিনিষেধ নেই';

  @override
  String get minimumRatedGames => 'সর্বনিম্ন রেটেড খেলার সংখ্যা';

  @override
  String get minimumRating => 'সর্বনিম্ন রেটিং';

  @override
  String get maximumWeeklyRating => 'সর্বোচ্চ সাপ্তাহিক রেটিং';

  @override
  String positionInputHelp(String param) {
    return 'একটি প্রদত্ত অবস্থান থেকে প্রতিটি খেলা শুরু করতে একটি বৈধ FEN পেস্ট করুন. এটি শুধুমাত্র স্ট্যান্ডার্ড গেমের জন্য কাজ করে, ভেরিয়েন্টের সাথে নয়. আপনি একটি FEN তৈরি করতে $param ব্যবহার করতে পারেন, তারপর এটি এখানে পেস্ট করুন. স্বাভাবিক প্রাথমিক অবস্থান থেকে গেম শুরু করতে খালি ছেড়ে দিন.';
  }

  @override
  String get cancelSimul => 'একত্রে খেলা বাতিল করুন';

  @override
  String get simulHostcolor => 'স্বাগতিক খেলোয়াড়ের ঘুটি/ piece এর রঙ';

  @override
  String get estimatedStart => 'আনুমানিক খেলা শুরুর সময়';

  @override
  String simulFeatured(String param) {
    return 'দেখানো হবে $param';
  }

  @override
  String simulFeaturedHelp(String param) {
    return '$param-এ সবার কাছে আপনার সিমুল দেখান। ব্যক্তিগত সিমুল জন্য নিষ্ক্রিয় করুন.';
  }

  @override
  String get simulDescription => 'সিমুল বর্ণনা';

  @override
  String get simulDescriptionHelp => 'আপনি অংশগ্রহণকারীদের কিছু বলতে চান?';

  @override
  String markdownAvailable(String param) {
    return '$param আরও উচ্চতর সিনট্যাক্সের জন্য উপলব্ধ.';
  }

  @override
  String get embedsAvailable => 'এম্বেড করতে একটি গেম URL বা একটি স্টাডি চ্যাপটার URL পেস্ট করুন.';

  @override
  String get inYourLocalTimezone => 'আপনার স্থানীয় সময়';

  @override
  String get tournChat => 'টুর্নামেন্ট চ্যাট';

  @override
  String get noChat => 'কোনো চ্যাট নয়';

  @override
  String get onlyTeamLeaders => 'শুধুমাত্র দলীয় প্রধানগণ';

  @override
  String get onlyTeamMembers => 'শুধুমাত্র দলের সদস্যরা';

  @override
  String get navigateMoveTree => 'Move/চালের তালিকা নির্দেশক';

  @override
  String get mouseTricks => 'মাউসের নিয়ন্ত্রন';

  @override
  String get toggleLocalAnalysis => 'ব্যক্তিগত কম্পিউটার বিশ্লেষণ অন/অফ';

  @override
  String get toggleAllAnalysis => 'সব কম্পিউটার বিশ্লেষণ অন/অফ';

  @override
  String get playComputerMove => 'কম্পিউটারের সেরা চাল';

  @override
  String get analysisOptions => 'আনাল্যসিস অপশনস';

  @override
  String get focusChat => 'ফোকাস চ্যাট';

  @override
  String get showHelpDialog => 'এই হেল্প ডায়ালগ দেখান';

  @override
  String get reopenYourAccount => 'আপনার একাউন্ট পুনরায় খুলুন';

  @override
  String get closedAccountChangedMind => 'আপনি যদি আপনার একাউন্ট বন্ধ করে থাকেন, কিন্তু পরবর্তীতে মন পরিবর্তন করেন, সেক্ষেত্রে একাউন্ট ফেরত পাওয়ার জন্য আপনাকে একবার সুযোগ দেয়া হবে।';

  @override
  String get onlyWorksOnce => 'এটি শুধুমাত্র একবার কাজ করবে।';

  @override
  String get cantDoThisTwice => 'আপনি যদি দ্বিতীয়বারের মত একাউন্ট বন্ধ করেন, তাহলে তা আর পুনরুদ্ধার করা যাবে না।';

  @override
  String get emailAssociatedToaccount => 'এই একাউন্টের সঙ্গে সংশ্লিষ্ট ই-মেইল অ্যাড্রেস হচ্ছে';

  @override
  String get sentEmailWithLink => 'আমরা আপনাকে একটি লিঙ্ক সহ ই-মেইল পাঠিয়েছি।';

  @override
  String get tournamentEntryCode => 'টুর্নামেন্টে প্রবেশের কোড';

  @override
  String get hangOn => 'সাবধান!';

  @override
  String gameInProgress(String param) {
    return '$param এর সাথে এখনো আপনার খেলা চলছে।';
  }

  @override
  String get abortTheGame => 'খেলা ত্যাগ(abort) করুন';

  @override
  String get resignTheGame => 'খেলা সমর্পণ(resign) করুন';

  @override
  String get youCantStartNewGame => 'আপনি এই খেলা শেষ না করে নতুন খেলা শুরু করতে পারবেন না।';

  @override
  String get since => 'Since/শুরু';

  @override
  String get until => 'Until/পর্যন্ত';

  @override
  String get lichessDbExplanation => 'লিচেস এর সকল খেলোয়াড়দের রেটেড খেলা থেকে সংগ্রহকৃত';

  @override
  String get switchSides => 'পক্ষ পরিবর্তন করুন';

  @override
  String get closingAccountWithdrawAppeal => 'একাউন্ট বন্ধ করলে আপনার আপিল প্রত্যাহার হয়ে যাবে';

  @override
  String get ourEventTips => 'ইভেন্ট আয়োজনের জন্য আমাদের টিপস';

  @override
  String get instructions => 'নির্দেশাবলী';

  @override
  String get showMeEverything => 'সবকিছু দেখানো হোক';

  @override
  String get lichessPatronInfo => 'লিচেস একটি অলাভজনক এবং সম্পূর্ণ বিনামূল্য/লিব্রা ওপেন সোর্স সফটওয়্যার।\nসকল পরিচালনা খরচ, উন্নয়ন, এবং বিষয়বস্তু ব্যবহারকারীদের দানের মাধ্যমে সংগৃহীত হয়।';

  @override
  String get nothingToSeeHere => 'এই মুহূর্তে এখানে দেখার কিছু নেই.';

  @override
  String opponentLeftCounter(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'আপনার প্রতিপক্ষ খেলা ছেড়ে দিয়েছেন। আপনি $count সেকেন্ডের মধ্যে জয় দাবি করতে পারেন.',
      one: 'আপনার প্রতিপক্ষ খেলা ছেড়ে চলে গেছেন. আপনি চাইলে বিজয় দাবি করতে পারেন $count সেকেন্ডের মধ্যে.',
    );
    return '$_temp0';
  }

  @override
  String mateInXHalfMoves(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'সজ্ঞী $count অর্ধ-ধাপ',
      one: 'সজ্ঞী $count অর্ধ-ধাপ',
    );
    return '$_temp0';
  }

  @override
  String nbBlunders(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count টি ব্লান্ডার',
      one: '$count টি ব্লান্ডার',
    );
    return '$_temp0';
  }

  @override
  String nbMistakes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countটি ভূল',
      one: '$countটি ভূল',
    );
    return '$_temp0';
  }

  @override
  String nbInaccuracies(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countটি অনিপুণতা',
      one: '$countটি অনিপুণতা',
    );
    return '$_temp0';
  }

  @override
  String nbPlayers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count জন খেলোয়াড়',
      one: '$count জন খেলোয়াড়',
    );
    return '$_temp0';
  }

  @override
  String nbGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count টি খেলা',
      one: '$count টি খেলা',
    );
    return '$_temp0';
  }

  @override
  String ratingXOverYGames(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count রেটিং $param2 গেমের উপরে',
      one: '$count রেটিং $param2 গেমের উপরে',
    );
    return '$_temp0';
  }

  @override
  String nbBookmarks(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count টি বুকমার্ক',
      one: '$count টি বুকমার্ক',
    );
    return '$_temp0';
  }

  @override
  String nbDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count দিনগুলো',
      one: '$count দিন',
    );
    return '$_temp0';
  }

  @override
  String nbHours(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ঘন্টা',
      one: '$count ঘন্টা',
    );
    return '$_temp0';
  }

  @override
  String nbMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count মিনিট',
      one: '$count মিনিট',
    );
    return '$_temp0';
  }

  @override
  String rankIsUpdatedEveryNbMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'আপনার অনুক্রম প্রতি $count মিনিট পরপর আপডেট করা হয়।',
      one: 'আপনার অনুক্রম প্রতি মিনিট পরপর আপডেট করা হয়।',
    );
    return '$_temp0';
  }

  @override
  String nbPuzzles(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ধাঁধা',
      one: '$count ধাঁধা',
    );
    return '$_temp0';
  }

  @override
  String nbGamesWithYou(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count টি খেলা আপনার সঙ্গে',
      one: '$count টি খেলা আপনার সঙ্গে',
    );
    return '$_temp0';
  }

  @override
  String nbRated(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count অনুপাত',
      one: '$count অনুপাত',
    );
    return '$_temp0';
  }

  @override
  String nbWins(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count টি জয়',
      one: '$count টি জয়',
    );
    return '$_temp0';
  }

  @override
  String nbLosses(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count টি পরাজয়',
      one: '$count টি পরাজয়',
    );
    return '$_temp0';
  }

  @override
  String nbDraws(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count টি ড্র',
      one: '$count টি ড্র',
    );
    return '$_temp0';
  }

  @override
  String nbPlaying(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count খেলছে',
      one: '$count খেলছে',
    );
    return '$_temp0';
  }

  @override
  String giveNbSeconds(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count সেকেন্ড দিন',
      one: '$count সেকেন্ড দিন',
    );
    return '$_temp0';
  }

  @override
  String nbTournamentPoints(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ক্রীড়া-প্রতিযোগিতা অনুপাতগুলো',
      one: '$count ক্রীড়া-প্রতিযোগিতা অনুপাত',
    );
    return '$_temp0';
  }

  @override
  String nbStudies(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count অধ্যায়নগুলি',
      one: '$count অধ্যায়ন',
    );
    return '$_temp0';
  }

  @override
  String nbSimuls(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count শিমুলগুলো',
      one: '$count শিমুল',
    );
    return '$_temp0';
  }

  @override
  String moreThanNbRatedGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '≥ $count খেলার অনুপাতগুলো',
      one: '≥ $count খেলার অনুপাত',
    );
    return '$_temp0';
  }

  @override
  String moreThanNbPerfRatedGames(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '≥ $count $param2 খেলার অনুপাতগুলো',
      one: '≥ $count $param2 খেলার অনুপাত',
    );
    return '$_temp0';
  }

  @override
  String needNbMorePerfGames(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'আপনার খেলার প্রয়োজন $count আরো $param2 খেলার অনুপাত',
      one: 'আপনার খেলার প্রয়োজন $count আরো $param2 খেলার অনুপাত',
    );
    return '$_temp0';
  }

  @override
  String needNbMoreGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'আপনার খেলার প্রয়োজন $count আরো অনুপাদিত খেলা',
      one: 'আপনার খেলার প্রয়োজন $count আরো অনুপাদিত খেলা',
    );
    return '$_temp0';
  }

  @override
  String nbImportedGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count টি আমদানীকৃত খেলা',
      one: '$count টি আমদানীকৃত খেলা',
    );
    return '$_temp0';
  }

  @override
  String nbFriendsOnline(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count বন্ধুরা অনলাইনে রয়েছেন',
      one: '$count বন্ধু অনলাইনে রয়েছেন',
    );
    return '$_temp0';
  }

  @override
  String nbFollowers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count অনুসরণকারী',
      one: '$count অনুসরণকারী',
    );
    return '$_temp0';
  }

  @override
  String nbFollowing(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count অনুসরণ করছেন',
      one: '$count অনুসরণ করছেন',
    );
    return '$_temp0';
  }

  @override
  String lessThanNbMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count মিনিটের কম সময়ে',
      one: '$count মিনিটের কম সময়ে',
    );
    return '$_temp0';
  }

  @override
  String nbGamesInPlay(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count খেলা চলছে',
      one: '$count খেলা চলছে',
    );
    return '$_temp0';
  }

  @override
  String maximumNbCharacters(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'সর্বোচ্চ: $count টি অক্ষর',
      one: 'সর্বোচ্চ: $count টি অক্ষর',
    );
    return '$_temp0';
  }

  @override
  String blocks(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count বাধা',
      one: '$count বাধা',
    );
    return '$_temp0';
  }

  @override
  String nbForumPosts(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ফোরাম পোষ্ট',
      one: '$count ফোরাম পোষ্ট',
    );
    return '$_temp0';
  }

  @override
  String nbPerfTypePlayersThisWeek(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count $param2 খেলোয়াড়গুলো এই সপ্তাহের.',
      one: '$count $param2 খেলোয়াড় এই সপ্তাহের.',
    );
    return '$_temp0';
  }

  @override
  String availableInNbLanguages(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'প্রাপ্য $count ভাষা সমূহ!',
      one: 'প্রাপ্য $count ভাষা!',
    );
    return '$_temp0';
  }

  @override
  String nbSecondsToPlayTheFirstMove(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count সেকেন্ডে খেলার প্রথম চাল',
      one: '$count সেকেন্ডে খেলার প্রথম চাল',
    );
    return '$_temp0';
  }

  @override
  String nbSeconds(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count সেকেন্ড',
      one: '$count সেকেন্ড',
    );
    return '$_temp0';
  }

  @override
  String andSaveNbPremoveLines(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'এবং সংরক্ষন $count পুনারয়চাল রেখা',
      one: 'এবং সংরক্ষন $count পুনারয়চাল রেখা',
    );
    return '$_temp0';
  }

  @override
  String get stormMoveToStart => 'সুরু করতে চাল দিন';

  @override
  String get stormYouPlayTheWhitePiecesInAllPuzzles => 'আপনি সমস্ত ধাঁধাতে সাদা ঘুঁটি নিয়ে খেলছেন।';

  @override
  String get stormYouPlayTheBlackPiecesInAllPuzzles => 'আপনি সমস্ত ধাঁধাতে কালো ঘুঁটি নিয়ে খেলছেন।';

  @override
  String get stormPuzzlesSolved => 'ধাঁধা সমাধান করা হয়েছে';

  @override
  String get stormNewDailyHighscore => 'নতুন দৈনিক হাইস্কোর!';

  @override
  String get stormNewWeeklyHighscore => 'নতুন সাপ্তাহিক হাইস্কোর!';

  @override
  String get stormNewMonthlyHighscore => 'নতুন মাসিক হাইস্কোর!';

  @override
  String get stormNewAllTimeHighscore => 'নতুন সর্বকালের হাইস্কোর!';

  @override
  String stormPreviousHighscoreWasX(String param) {
    return 'আগের হাইস্কোর তি ছিল $param';
  }

  @override
  String get stormPlayAgain => 'আবার খেলুন';

  @override
  String stormHighscoreX(String param) {
    return 'হাইস্কোর $param';
  }

  @override
  String get stormScore => 'স্কোর';

  @override
  String get stormMoves => 'চাল';

  @override
  String get stormAccuracy => 'নির্ভুলতা';

  @override
  String get stormCombo => 'Combo';

  @override
  String get stormTime => 'সময়';

  @override
  String get stormTimePerMove => 'চাল প্রতি সময়';

  @override
  String get stormHighestSolved => 'সর্বোচ্চ সমাধানকৃত';

  @override
  String get stormPuzzlesPlayed => 'Puzzles played';

  @override
  String get stormNewRun => 'New run (hotkey: Space)';

  @override
  String get stormEndRun => 'End run (hotkey: Enter)';

  @override
  String get stormHighscores => 'হাইস্কোর';

  @override
  String get stormViewBestRuns => 'View best runs';

  @override
  String get stormBestRunOfDay => 'Best run of day';

  @override
  String get stormRuns => 'চালান';

  @override
  String get stormGetReady => 'Get ready!';

  @override
  String get stormWaitingForMorePlayers => 'Waiting for more players to join...';

  @override
  String get stormRaceComplete => 'Race complete!';

  @override
  String get stormSpectating => 'Spectating';

  @override
  String get stormJoinTheRace => 'Join the race!';

  @override
  String get stormStartTheRace => 'Start the race';

  @override
  String stormYourRankX(String param) {
    return 'Your rank: $param';
  }

  @override
  String get stormWaitForRematch => 'Wait for rematch';

  @override
  String get stormNextRace => 'Next race';

  @override
  String get stormJoinRematch => 'Join rematch';

  @override
  String get stormWaitingToStart => 'Waiting to start';

  @override
  String get stormCreateNewGame => 'Create a new game';

  @override
  String get stormJoinPublicRace => 'Join a public race';

  @override
  String get stormRaceYourFriends => 'Race your friends';

  @override
  String get stormSkip => 'এড়িয়ে যান';

  @override
  String get stormSkipHelp => 'You can skip one move per race:';

  @override
  String get stormSkipExplanation => 'Skip this move to preserve your combo! Only works once per race.';

  @override
  String get stormFailedPuzzles => 'Failed puzzles';

  @override
  String get stormSlowPuzzles => 'Slow puzzles';

  @override
  String get stormSkippedPuzzle => 'Skipped puzzle';

  @override
  String get stormThisWeek => 'This week';

  @override
  String get stormThisMonth => 'এই মাসে';

  @override
  String get stormAllTime => 'All-time';

  @override
  String get stormClickToReload => 'পুনঃলোড করতে ক্লিক করুন';

  @override
  String get stormThisRunHasExpired => 'This run has expired!';

  @override
  String get stormThisRunWasOpenedInAnotherTab => 'This run was opened in another tab!';

  @override
  String stormXRuns(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count দউর',
      one: '১ দউর',
    );
    return '$_temp0';
  }

  @override
  String stormPlayedNbRunsOfPuzzleStorm(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Played $count runs of $param2',
      one: 'Played one run of $param2',
    );
    return '$_temp0';
  }

  @override
  String get streamerLichessStreamers => 'লিছেসস স্ত্রেয়ামের';

  @override
  String get studyShareAndExport => 'Share & export';

  @override
  String get studyStart => 'শুরু করুন';
}
