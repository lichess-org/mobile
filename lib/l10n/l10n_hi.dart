import 'package:intl/intl.dart' as intl;

import 'l10n.dart';

/// The translations for Hindi (`hi`).
class AppLocalizationsHi extends AppLocalizations {
  AppLocalizationsHi([String locale = 'hi']) : super(locale);

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
  String get activityActivity => 'कार्यकलाप';

  @override
  String get activityHostedALiveStream => 'एक लाइव स्ट्रीम होस्ट किया गया';

  @override
  String activityRankedInSwissTournament(String param1, String param2) {
    return '#$param1 स्थान $param2 मे';
  }

  @override
  String get activitySignedUp => 'lichess.org पर साइन अप किया गया';

  @override
  String activitySupportedNbMonths(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$param2 के रूप में $count महीने के लिए lichess.org का समर्थन किया।',
      one: '$param2 के रूप में $count महीने के लिए lichess.org का समर्थन किया।',
    );
    return '$_temp0';
  }

  @override
  String activityPracticedNbPositions(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$param2 पर $count स्थितियों का अभ्यास किया',
      one: '$param2 पर $count स्थिति का अभ्यास किया',
    );
    return '$_temp0';
  }

  @override
  String activitySolvedNbPuzzles(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count प्रशिक्षण पहेलियों को हल किया',
      one: '$count प्रशिक्षण पहेली को हल किया',
    );
    return '$_temp0';
  }

  @override
  String activityPlayedNbGames(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count $param2 के खेल खेले',
      one: '$count $param2 का खेल खेला',
    );
    return '$_temp0';
  }

  @override
  String activityPostedNbMessages(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$param2 में $count संदेश भेजे',
      one: '$param2 में $count संदेश भेजा',
    );
    return '$_temp0';
  }

  @override
  String activityPlayedNbMoves(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count चालें चली',
      one: '$count चाल चली',
    );
    return '$_temp0';
  }

  @override
  String activityInNbCorrespondenceGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count पत्राचार खेलों में',
      one: '$count पत्राचार खेल में',
    );
    return '$_temp0';
  }

  @override
  String activityCompletedNbGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count पत्राचार खेल पूर्ण किए',
      one: '$count पत्राचार खेल पूर्ण किया',
    );
    return '$_temp0';
  }

  @override
  String activityFollowedNbPlayers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count खिलाड़ियों का अनुसरण करना शुरू किया',
      one: '$count खिलाड़ी का अनुसरण करना शुरू किया',
    );
    return '$_temp0';
  }

  @override
  String activityGainedNbFollowers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count नए अनुयायी प्राप्त किए गए',
      one: '$count नया अनुयायी प्राप्त किया गया',
    );
    return '$_temp0';
  }

  @override
  String activityHostedNbSimuls(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count समकालिक प्रदर्शनियों का आयोजन किया',
      one: '$count समकालिक प्रदर्शनी का आयोजन किया',
    );
    return '$_temp0';
  }

  @override
  String activityJoinedNbSimuls(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count समकालिक प्रदर्शनियों में भाग लिया',
      one: '$count समकालिक प्रदर्शनी में भाग लिया',
    );
    return '$_temp0';
  }

  @override
  String activityCreatedNbStudies(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count नए अध्ययनों का निर्माण किया',
      one: '$count नया अध्ययन का निर्माण किया',
    );
    return '$_temp0';
  }

  @override
  String activityCompetedInNbTournaments(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count arena टूर्नामेटों में भाग लिया',
      one: '$count arena टूर्नामेंट में भाग लिया',
    );
    return '$_temp0';
  }

  @override
  String activityRankedInTournament(int count, String param2, String param3, String param4) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$param4 में $param3 खेल के साथ $count (टॉप $param2%) रैंक किया गया',
      one: '$param4 में $param3 खेल के साथ $count (टॉप $param2%) रैंक किया गया',
    );
    return '$_temp0';
  }

  @override
  String activityCompetedInNbSwissTournaments(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count स्विस टुर्नामेंटों में भाग लिया',
      one: '$count स्विस टूर्नामेंट में भाग लिया',
    );
    return '$_temp0';
  }

  @override
  String activityJoinedNbTeams(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count टीमों में शामिल हुए',
      one: '$count टीम में शामिल हुए',
    );
    return '$_temp0';
  }

  @override
  String get broadcastBroadcasts => 'प्रसारण';

  @override
  String get broadcastLiveBroadcasts => 'लाइव टूर्नामेंट प्रसारण';

  @override
  String challengeChallengesX(String param1) {
    return 'Challenges: $param1';
  }

  @override
  String get challengeChallengeToPlay => 'एक खेल के लिए चुनौती';

  @override
  String get challengeChallengeDeclined => 'चुनौती इंकार कर दिया';

  @override
  String get challengeChallengeAccepted => 'चुनौती स्वीकार की गई!';

  @override
  String get challengeChallengeCanceled => 'चुनौती रद्द।';

  @override
  String get challengeRegisterToSendChallenges => 'कृपया चुनौतियों को भेजने के लिए पंजीकरण करें।';

  @override
  String challengeYouCannotChallengeX(String param) {
    return 'आप $param को चुनौती नहीं दे सकते।';
  }

  @override
  String challengeXDoesNotAcceptChallenges(String param) {
    return '$param चुनौतियों को स्वीकार नहीं करता है।';
  }

  @override
  String challengeYourXRatingIsTooFarFromY(String param1, String param2) {
    return 'आपकी $param1 रेटिंग $param2 से बहुत दूर है।';
  }

  @override
  String challengeCannotChallengeDueToProvisionalXRating(String param) {
    return 'अनंतिम $param रेटिंग के कारण चुनौती नहीं दी जा सकती।';
  }

  @override
  String challengeXOnlyAcceptsChallengesFromFriends(String param) {
    return '$param केवल दोस्तों की चुनौतियों को स्वीकार करता है।';
  }

  @override
  String get challengeDeclineGeneric => 'मैं इस समय चुनौतियों को स्वीकार नहीं कर रहा हूं।';

  @override
  String get challengeDeclineLater => 'मैं अभी चुनौतियों को स्वीकार नहीं कर रहा हूं, कृपया बाद में फिर से पूछें।';

  @override
  String get challengeDeclineTooFast => 'मेरे लिए समय नियंत्रण बहुत तेज़ है, कृपया मुझे धीमे खेल में चुनौती दें';

  @override
  String get challengeDeclineTooSlow => 'मेरे लिए समय नियंत्रण बहुत धीमे है, कृपया मुझे तेज़ खेल में चुनौती दें';

  @override
  String get challengeDeclineTimeControl => 'मैं अभी इस समय-प्रारूप के साथ चुनौतियों को स्वीकार नहीं कर रहा हूं';

  @override
  String get challengeDeclineRated => 'इसके बजाय कृपया मुझे एक रेटेड चुनौती भेजें';

  @override
  String get challengeDeclineCasual => 'इसके बजाय कृपया मुझे एक आकस्मिक चुनौती भेजें';

  @override
  String get challengeDeclineStandard => 'मैं अभी वैरिएंट चुनौतियों को स्वीकार नहीं कर रहा हूं।';

  @override
  String get challengeDeclineVariant => 'मैं अभी इस संस्करण को नहीं खेलना चाहता हूं।';

  @override
  String get challengeDeclineNoBot => 'मैं कंप्यूटर से चुनौतियों को स्वीकार नहीं कर रहा हूँ';

  @override
  String get challengeDeclineOnlyBot => 'मैं केवल कंप्यूटर से चुनौतियों को स्वीकार कर रहा हूं';

  @override
  String get challengeInviteLichessUser => 'Or invite a Lichess user:';

  @override
  String get contactContact => 'संपर्क';

  @override
  String get contactContactLichess => 'लिचेस से संपर्क करें';

  @override
  String get patronDonate => 'दान करें';

  @override
  String get patronLichessPatron => 'Lichess संरक्षक';

  @override
  String perfStatPerfStats(String param) {
    return '$param आँकड़े';
  }

  @override
  String get perfStatViewTheGames => 'खेल देखें';

  @override
  String get perfStatProvisional => 'अनंतिम';

  @override
  String get perfStatNotEnoughRatedGames => 'विश्वसनीय रेटिंग स्थापित करने के लिए पर्याप्त रेटिंग वाले गेम नहीं खेले गए हैं।';

  @override
  String perfStatProgressOverLastXGames(String param) {
    return 'अंतिम $param खेलों पर प्रगति:';
  }

  @override
  String perfStatRatingDeviation(String param) {
    return 'रेटिंग विचलन: $param';
  }

  @override
  String perfStatRatingDeviationTooltip(String param1, String param2, String param3) {
    return 'कम मूल्य का मतलब है कि रेटिंग अधिक स्थिर है। $param1 से ऊपर, रेटिंग को अनंतिम माना जाता है। रैंकिंग में शामिल होने के लिए, यह मान $param2 (मानक शतरंज) या $param3 (वेरिएंट) से नीचे होना चाहिए।';
  }

  @override
  String get perfStatTotalGames => 'कुल खेल';

  @override
  String get perfStatRatedGames => 'रेटेड खेल';

  @override
  String get perfStatTournamentGames => 'टूर्नामेंट खेल';

  @override
  String get perfStatBerserkedGames => 'निडर खेल';

  @override
  String get perfStatTimeSpentPlaying => 'खेलने में बिताया गया समय';

  @override
  String get perfStatAverageOpponent => 'औसत प्रतिद्वंद्वी';

  @override
  String get perfStatVictories => 'विजय';

  @override
  String get perfStatDefeats => 'पराजय';

  @override
  String get perfStatDisconnections => 'संपर्क टूटे';

  @override
  String get perfStatNotEnoughGames => 'पर्याप्त खेल नहीं खेले गए';

  @override
  String perfStatHighestRating(String param) {
    return 'अधिकतम रेटिंग:$param';
  }

  @override
  String perfStatLowestRating(String param) {
    return 'न्यूनतम रेटिंग: $param';
  }

  @override
  String perfStatFromXToY(String param1, String param2) {
    return '$param1 से $param2 तक';
  }

  @override
  String get perfStatWinningStreak => 'लगातार जीत की संख्या';

  @override
  String get perfStatLosingStreak => 'लगातार हार की संख्या';

  @override
  String perfStatLongestStreak(String param) {
    return 'सबसे लंबी स्ट्रीक: $param';
  }

  @override
  String perfStatCurrentStreak(String param) {
    return 'वर्तमान स्ट्रीक: $param';
  }

  @override
  String get perfStatBestRated => 'सर्वश्रेष्ठ रेटेड जीत';

  @override
  String get perfStatGamesInARow => 'लगातार खेले गए खेल';

  @override
  String get perfStatLessThanOneHour => 'वो खेल जिन के बीच एक घंटे से कम फासला हो';

  @override
  String get perfStatMaxTimePlaying => 'खेलने में बिताया गया अधिकतम समय';

  @override
  String get perfStatNow => 'अभी';

  @override
  String get preferencesPreferences => 'प्राथमिकताएं';

  @override
  String get preferencesDisplay => 'डिस्प्ले';

  @override
  String get preferencesPrivacy => 'प्राइवेसी';

  @override
  String get preferencesNotifications => 'सूचनाएं';

  @override
  String get preferencesPieceAnimation => 'मोहरों का एनीमेशन';

  @override
  String get preferencesMaterialDifference => 'सामग्री का अंतर';

  @override
  String get preferencesBoardHighlights => 'बोर्ड का हाइलाइट (आख़िरी चाल और शह)';

  @override
  String get preferencesPieceDestinations => 'मोहरों का गंतव्य (मान्य चालें और पहले से चुनी आई चालें)';

  @override
  String get preferencesBoardCoordinates => 'बोर्ड का निर्देशांक (A-H, 1-8)';

  @override
  String get preferencesMoveListWhilePlaying => 'खेलते समय चालों की सूची';

  @override
  String get preferencesPgnPieceNotation => 'चाल नोटेशन';

  @override
  String get preferencesChessPieceSymbol => 'शतरंज टुकड़ा प्रतीक';

  @override
  String get preferencesPgnLetter => 'अक्षर (K, Q, R, B, N)';

  @override
  String get preferencesZenMode => 'ज़ेन मोड';

  @override
  String get preferencesShowPlayerRatings => 'खिलाड़ी की रेटिंग दिखाएं';

  @override
  String get preferencesShowFlairs => 'Show player flairs';

  @override
  String get preferencesExplainShowPlayerRatings => 'यह शतरंज पर ध्यान केंद्रित करने में मदद करने के लिए वेबसाइट से सभी रेटिंग छिपाने की अनुमति देता है। खेलों को अभी भी रेट किया जा सकता है, यह केवल इस बारे में है कि आपको क्या देखने को मिलता है।';

  @override
  String get preferencesDisplayBoardResizeHandle => 'बोर्ड आकार परिवर्तन करने वाली मूठ दिखाएं';

  @override
  String get preferencesOnlyOnInitialPosition => 'केवल प्रारंभिक स्थिति पर';

  @override
  String get preferencesInGameOnly => 'केवल खेल में';

  @override
  String get preferencesChessClock => 'शतरंज की घड़ी';

  @override
  String get preferencesTenthsOfSeconds => 'सेकेंड का दसवाँ हिस्सा';

  @override
  String get preferencesWhenTimeRemainingLessThanTenSeconds => 'जब बचा हुआ समय < 10 सेकेंड';

  @override
  String get preferencesHorizontalGreenProgressBars => 'क्षैतिज(horizontal) हरी प्रगति सलाखें(bars)';

  @override
  String get preferencesSoundWhenTimeGetsCritical => 'ध्वनि जब समय महत्वपूर्ण (कम) हो जाता है';

  @override
  String get preferencesGiveMoreTime => 'अधिक समय दें';

  @override
  String get preferencesGameBehavior => 'खेल का व्यवहार';

  @override
  String get preferencesHowDoYouMovePieces => 'आप टुकड़ों को कैसे चलाते हैं?';

  @override
  String get preferencesClickTwoSquares => 'दो चौकों पर क्लिक करें';

  @override
  String get preferencesDragPiece => 'एक टुकड़ा खींचें';

  @override
  String get preferencesBothClicksAndDrag => 'या तो';

  @override
  String get preferencesPremovesPlayingDuringOpponentTurn => 'पहले से चुनी गयी चालें (प्रतिद्वंद्वी की बारी के दौरान खेलना)';

  @override
  String get preferencesTakebacksWithOpponentApproval => 'वापस लेना (प्रतिद्वंद्वी के अनुमति से)';

  @override
  String get preferencesInCasualGamesOnly => 'केवल आकस्मिक खेलों में ही';

  @override
  String get preferencesPromoteToQueenAutomatically => 'रानी की उन्नति (प्रमोट) अपने आप करें';

  @override
  String get preferencesExplainPromoteToQueenAutomatically => '<ctrl> ऑटो-प्रमोशन को अस्थायी रूप से अक्षम करने के लिए प्रचार करते समय कुंजी';

  @override
  String get preferencesWhenPremoving => 'पहले से चाल चलते समय';

  @override
  String get preferencesClaimDrawOnThreefoldRepetitionAutomatically => 'दावा तीन बार दोहराव पर स्वचालित रूप से ड्रा';

  @override
  String get preferencesWhenTimeRemainingLessThanThirtySeconds => 'जब बचा हुआ समय < 30 सेकेंड';

  @override
  String get preferencesMoveConfirmation => 'चाल की पुष्टि करें';

  @override
  String get preferencesExplainCanThenBeTemporarilyDisabled => 'बोर्ड मेनू के साथ गेम के दौरान अक्षम किया जा सकता है';

  @override
  String get preferencesInCorrespondenceGames => 'लम्बे खेलों में';

  @override
  String get preferencesCorrespondenceAndUnlimited => 'पत्राचार और असीमित';

  @override
  String get preferencesConfirmResignationAndDrawOffers => 'इस्तीफे की पुष्टि करें और ड्रा ऑफर करें';

  @override
  String get preferencesCastleByMovingTheKingTwoSquaresOrOntoTheRook => 'आप कैसे कैंसिल करना चाहते हो?';

  @override
  String get preferencesCastleByMovingTwoSquares => 'राजा दो चौकों ले जाएँ';

  @override
  String get preferencesCastleByMovingOntoTheRook => 'राजा हाथी पर ले जाएँ';

  @override
  String get preferencesInputMovesWithTheKeyboard => 'कंप्यूटर कीबोर्ड के साथ इनपुट करें';

  @override
  String get preferencesInputMovesWithVoice => 'Input moves with your voice';

  @override
  String get preferencesSnapArrowsToValidMoves => 'मान्य चाल के लिए स्नैप तीर';

  @override
  String get preferencesSayGgWpAfterLosingOrDrawing => 'हार या ड्रॉ पर \"अच्छा खेल, अच्छा खेला\" कहें';

  @override
  String get preferencesYourPreferencesHaveBeenSaved => 'आपकी प्राथमिकताएं सेव कर ली गई हैं';

  @override
  String get preferencesScrollOnTheBoardToReplayMoves => 'पिछली चालें पुनः देखने के लिए बोर्ड पर स्क्राल करें';

  @override
  String get preferencesCorrespondenceEmailNotification => 'आपके पत्राचार खेलों को सूचीबद्ध करने वाली दैनिक मेल अधिसूचना';

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
  String get puzzlePuzzles => 'पहेलियाँ';

  @override
  String get puzzlePuzzleThemes => 'पहेली विषयों';

  @override
  String get puzzleRecommended => 'सिफारिश की';

  @override
  String get puzzlePhases => 'चरण';

  @override
  String get puzzleMotifs => 'रूपांकनों';

  @override
  String get puzzleAdvanced => 'उन्नत';

  @override
  String get puzzleLengths => 'लंबाई';

  @override
  String get puzzleMates => 'साथी';

  @override
  String get puzzleGoals => 'लक्ष्य';

  @override
  String get puzzleOrigin => 'मूल';

  @override
  String get puzzleSpecialMoves => 'विशेष चाल';

  @override
  String get puzzleDidYouLikeThisPuzzle => 'क्या आपको यह पहेली पसंद आई?';

  @override
  String get puzzleVoteToLoadNextOne => 'अगले एक को लोड करने के लिए वोट दें!';

  @override
  String get puzzleUpVote => 'पहेली को उपवोट करिये';

  @override
  String get puzzleDownVote => 'पहेली को डाउनवोट करिये';

  @override
  String get puzzleYourPuzzleRatingWillNotChange => 'आपकी पज़ल रेटिङ नही बदलेगी।पज़ल एक स्पर्धा नही है रेटिङ आपके अनुकुल पज़ल चुनने मे मदद करती है।';

  @override
  String get puzzleFindTheBestMoveForWhite => 'सफेद रंग के लिए सर्वश्रेष्ठ चाल का पता लगाएं।';

  @override
  String get puzzleFindTheBestMoveForBlack => 'काले रंग के लिए सर्वश्रेष्ठ चाल का पता लगाएं।';

  @override
  String get puzzleToGetPersonalizedPuzzles => 'वैयक्तिकृत पहेलियाँ प्राप्त करने के लिए:';

  @override
  String puzzlePuzzleId(String param) {
    return 'पहेलियाँ $param';
  }

  @override
  String get puzzlePuzzleOfTheDay => 'आज की पहेली';

  @override
  String get puzzleDailyPuzzle => 'दैनिक पहेली';

  @override
  String get puzzleClickToSolve => 'हल करने के लिए क्लिक करें';

  @override
  String get puzzleGoodMove => 'अच्छी चाल!';

  @override
  String get puzzleBestMove => 'सर्वश्रेष्ठ चाल!';

  @override
  String get puzzleKeepGoing => 'लगे रहें…';

  @override
  String get puzzlePuzzleSuccess => 'सफलता!';

  @override
  String get puzzlePuzzleComplete => 'पहेली पूरी!';

  @override
  String get puzzleByOpenings => 'उद्घाटन द्वारा';

  @override
  String get puzzlePuzzlesByOpenings => 'उद्घाटन द्वारा पहेलियाँ';

  @override
  String get puzzleOpeningsYouPlayedTheMost => 'ओपनिंग्स आपने रेटेड गेम्स में सबसे ज्यादा खेले';

  @override
  String get puzzleUseFindInPage => 'अपनी पसंदीदा ओपनिंग ढूंढने के लिए ब्राउज़र मेनू में \"पेज खोजें\" का उपयोग करें!';

  @override
  String get puzzleUseCtrlF => 'अपनी पसंदीदा ओपनिंग ढूंढने के लिए Ctrl+f का उपयोग करें!';

  @override
  String get puzzleNotTheMove => 'यह कदम नहीं है!';

  @override
  String get puzzleTrySomethingElse => 'कुछ और कोशिश करो।';

  @override
  String puzzleRatingX(String param) {
    return 'रेटिंग: $param';
  }

  @override
  String get puzzleHidden => 'छिपा हुआ';

  @override
  String puzzleFromGameLink(String param) {
    return '$param खेल से';
  }

  @override
  String get puzzleContinueTraining => 'प्रशिक्षण जारी रखें';

  @override
  String get puzzleDifficultyLevel => 'Difficulty level';

  @override
  String get puzzleNormal => 'समान्य';

  @override
  String get puzzleEasier => 'आसान';

  @override
  String get puzzleEasiest => 'सबसे आसान';

  @override
  String get puzzleHarder => 'कठिन';

  @override
  String get puzzleHardest => 'सबसे कठिन';

  @override
  String get puzzleExample => 'उदाहरण';

  @override
  String get puzzleAddAnotherTheme => 'एक और विषय जोड़ें';

  @override
  String get puzzleNextPuzzle => 'अगली पहेली';

  @override
  String get puzzleJumpToNextPuzzleImmediately => 'तुरंत अगली पहेली पर जाएं';

  @override
  String get puzzlePuzzleDashboard => 'पहेली डैशबोर्ड';

  @override
  String get puzzleImprovementAreas => 'सुधार क्षेत्रों';

  @override
  String get puzzleStrengths => 'ताकत';

  @override
  String get puzzleHistory => 'पहेली इतिहास';

  @override
  String get puzzleSolved => 'हल किया';

  @override
  String get puzzleFailed => 'अनुत्तीर्ण होना';

  @override
  String get puzzleStreakDescription => 'कठिन पहेलियों को हल करें एवं जीतने की श्रंखला बनाएं । समय की कोई पाबंदी नहीं है अतः अपना समय लें । एक गलत कदम और खेल खतम! परंतु आप हर अधिवेशन मे एक कदम छोड़ सकते हैं।';

  @override
  String puzzleYourStreakX(String param) {
    return 'आपका स्कोर: $param';
  }

  @override
  String get puzzleStreakSkipExplanation => 'अपने कॉम्बो को संरक्षित करने के लिए इस कदम को छोड़ दें। सम्पूर्ण पारी मे केवल एक बार काम करता है ।';

  @override
  String get puzzleContinueTheStreak => 'श्रंखला बनाए रखें ।';

  @override
  String get puzzleNewStreak => 'नई श्रंखला';

  @override
  String get puzzleFromMyGames => 'मेरे खेलों से';

  @override
  String get puzzleLookupOfPlayer => 'किसी खिलाड़ी के खेल से पहेलियाँ खोजें';

  @override
  String puzzleFromXGames(String param) {
    return '$param के खेलो की पज़ल​|';
  }

  @override
  String get puzzleSearchPuzzles => 'पज़ल खोजे';

  @override
  String get puzzleFromMyGamesNone => 'आपके डेटाबेस में कोई पहेली नहीं है, लेकिन लिचेस अभी भी आपसे बहुत प्यार करता है।\n\nआपकी कोई पहेली जुड़ने की संभावना बढ़ाने के लिए तेज़ और शास्त्रीय गेम खेलें!';

  @override
  String puzzleFromXGamesFound(String param1, String param2) {
    return '$param1 puzzles found in $param2 games';
  }

  @override
  String get puzzlePuzzleDashboardDescription => 'Train, analyse, improve';

  @override
  String puzzlePercentSolved(String param) {
    return '$param solved';
  }

  @override
  String get puzzleNoPuzzlesToShow => 'Nothing to show, go play some puzzles first!';

  @override
  String get puzzleImprovementAreasDescription => 'Train these to optimize your progress!';

  @override
  String get puzzleStrengthDescription => 'You perform the best in these themes';

  @override
  String puzzlePlayedXTimes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count समय खेले',
      one: '$count समय खेले',
    );
    return '$_temp0';
  }

  @override
  String puzzleNbPointsBelowYourPuzzleRating(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'पहेली की गणना मे से $count अंक नीचे',
      one: 'पहीली की गणना मे से एक अंक नीचे',
    );
    return '$_temp0';
  }

  @override
  String puzzleNbPointsAboveYourPuzzleRating(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'पहेली की गणना मे से $count अंक नीचे',
      one: 'पहेली की गणना मे से एक अंक नीचे',
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
  String get puzzleThemeAdvancedPawn => 'उन्नत पैदल';

  @override
  String get puzzleThemeAdvancedPawnDescription => 'प्रचार करने या धमकी देने वाला पैदल रणनीति की कुंजी है।';

  @override
  String get puzzleThemeAdvantage => 'लाभ';

  @override
  String get puzzleThemeAdvantageDescription => 'निर्णायक लाभ प्राप्त करने के लिए अपने अवसर को जब्त करें। (200cp al eval ≤ 600cp)';

  @override
  String get puzzleThemeAnastasiaMate => 'अनास्तासिया के मात';

  @override
  String get puzzleThemeAnastasiaMateDescription => 'बोर्ड के किनारे और एक अनुकूल टुकड़े के बीच विरोधी राजा को फंसाने के लिए एक घोड़ा और हाथी या वज़ीर टीम।';

  @override
  String get puzzleThemeArabianMate => 'अरेबियन मात';

  @override
  String get puzzleThemeArabianMateDescription => 'बोर्ड के एक कोने पर विरोधी राजा को फंसाने के लिए एक नाइट और एक रूक टीम।';

  @override
  String get puzzleThemeAttackingF2F7 => 'F2 या f7 पर हमला करना';

  @override
  String get puzzleThemeAttackingF2F7Description => 'एक हमला f2 या f7 मोहरे पर ध्यान केंद्रित करता है, जैसे कि तले हुए लिवर को खोलना।';

  @override
  String get puzzleThemeAttraction => 'आकर्षण';

  @override
  String get puzzleThemeAttractionDescription => 'एक विरोधी टुकड़े को एक वर्ग को प्रोत्साहित करने या मजबूर करने के लिए एक विनिमय या बलिदान जो अनुवर्ती रणनीति की अनुमति देता है।';

  @override
  String get puzzleThemeBackRankMate => 'पीछे की पंक्ति पर मात';

  @override
  String get puzzleThemeBackRankMateDescription => 'होम पंक्ति पर राजा को मात दे, जब वह अपने टुकड़ों से वहां फंस गया हो।';

  @override
  String get puzzleThemeBishopEndgame => 'ऊँट का एंडगेम';

  @override
  String get puzzleThemeBishopEndgameDescription => 'केवल ऊँट और प्यादे के साथ एक एंडगेम।';

  @override
  String get puzzleThemeBodenMate => 'बोडेन का मात';

  @override
  String get puzzleThemeBodenMateDescription => 'क्राइस-क्रॉसिंग विकर्णों पर दो हमलावर ऊँट मित्रवत टुकड़ों द्वारा बाधित एक राजा को चेकमेट वितरित करते हैं।';

  @override
  String get puzzleThemeCastling => 'कैसलिंग';

  @override
  String get puzzleThemeCastlingDescription => 'राजा को सुरक्षा के लिए लाएँ, और हमले के लिए हाथी तैनात करें।';

  @override
  String get puzzleThemeCapturingDefender => 'रक्षक को पकड़ना';

  @override
  String get puzzleThemeCapturingDefenderDescription => 'एक टुकड़े को निकालना जो दूसरे टुकड़े की रक्षा के लिए महत्वपूर्ण है, जिससे अब अपरिभाषित टुकड़ा को निम्नलिखित चाल पर कब्जा करने की अनुमति मिलती है।';

  @override
  String get puzzleThemeCrushing => 'मुंहतोड़';

  @override
  String get puzzleThemeCrushingDescription => 'एक कुचल लाभ प्राप्त करने के लिए प्रतिद्वंद्वी की बड़ी भूल को ढूंढे । (eval ≥ 600cp)';

  @override
  String get puzzleThemeDoubleBishopMate => 'डबल ऊँट मात';

  @override
  String get puzzleThemeDoubleBishopMateDescription => 'आसन्न विकर्णों पर दो हमलावर ऊँट मित्रवत टुकड़ों द्वारा बाधित एक राजा को चेकमेट वितरित करते हैं।';

  @override
  String get puzzleThemeDovetailMate => 'डव्टेल मात';

  @override
  String get puzzleThemeDovetailMateDescription => 'एक वज़ीर एक समीपवर्ती राजा को चेकमेट वितरित करती है, जिसके केवल दो भागने वाले वर्ग मैत्रीपूर्ण टुकड़ों द्वारा बाधित होते हैं।';

  @override
  String get puzzleThemeEquality => 'समानता';

  @override
  String get puzzleThemeEqualityDescription => 'एक खोने की स्थिति से वापस आएँ, और एक ड्रॉ या संतुलित स्थिति को सुरक्षित करें। (eval ≤ 200cp)';

  @override
  String get puzzleThemeKingsideAttack => 'किंगसाइड का हमला';

  @override
  String get puzzleThemeKingsideAttackDescription => 'प्रतिद्वंद्वी के राजा का एक हमला, बाद में वे राजा की तरफ झुक गए।';

  @override
  String get puzzleThemeClearance => 'रास्ता साफ़ करना';

  @override
  String get puzzleThemeClearanceDescription => 'एक चाल, अक्सर टेम्पो के साथ, जो एक अनुवर्ती सामरिक विचार के लिए एक वर्ग, फ़ाइल या विकर्ण को साफ करता है।';

  @override
  String get puzzleThemeDefensiveMove => 'रक्षात्मक चाल';

  @override
  String get puzzleThemeDefensiveMoveDescription => 'सामग्री को खोने या अन्य लाभ से बचने के लिए आवश्यक चाल की एक सटीक चाल या अनुक्रम।';

  @override
  String get puzzleThemeDeflection => 'नीचे को झुकाव';

  @override
  String get puzzleThemeDeflectionDescription => 'एक चाल जो एक प्रतिद्वंद्वी के टुकड़े को दूसरे कर्तव्य से विचलित करती है जो इसे निष्पादित करता है, जैसे कि एक प्रमुख वर्ग की रखवाली।';

  @override
  String get puzzleThemeDiscoveredAttack => 'हमले की खोज की';

  @override
  String get puzzleThemeDiscoveredAttackDescription => 'एक टुकड़ा जो पहले एक और लंबी दूरी के टुकड़े द्वारा हमले को अवरुद्ध करता है, जैसे कि एक शूरवीर के रास्ते से बाहर एक नाइट।';

  @override
  String get puzzleThemeDoubleCheck => 'दोहरा शह';

  @override
  String get puzzleThemeDoubleCheckDescription => 'एक बार में दो टुकड़ों के साथ जाँच, एक खोज हमले के परिणामस्वरूप जहां चलती टुकड़ा और अनावरण टुकड़ा दोनों प्रतिद्वंद्वी के राजा पर हमला करते हैं।';

  @override
  String get puzzleThemeEndgame => 'एंडगेम';

  @override
  String get puzzleThemeEndgameDescription => 'खेल के अंतिम चरण के दौरान एक रणनीति।';

  @override
  String get puzzleThemeEnPassantDescription => 'एन पास के नियम को शामिल करने वाली एक रणनीति, जहां एक मोहरा एक प्रतिद्वंद्वी मोहरे को पकड़ सकता है जिसने अपने शुरुआती दो-वर्ग चाल का उपयोग करके इसे बाईपास किया है।';

  @override
  String get puzzleThemeExposedKing => 'उजागर राजा';

  @override
  String get puzzleThemeExposedKingDescription => 'एक रणनीति जिसमें इसके चारों ओर कुछ रक्षकों के साथ एक राजा होता है, अक्सर चेकमेट के लिए अग्रणी होता है।';

  @override
  String get puzzleThemeFork => 'कांटा';

  @override
  String get puzzleThemeForkDescription => 'एक चाल जहां स्थानांतरित टुकड़ा एक बार में दो प्रतिद्वंद्वी टुकड़ों पर हमला करता है।';

  @override
  String get puzzleThemeHangingPiece => 'लटकता हुआ टुकड़ा';

  @override
  String get puzzleThemeHangingPieceDescription => 'किसी विरोधी टुकड़े को अपरिभाषित या अपर्याप्त रूप से संरक्षित करने और कब्जा करने के लिए स्वतंत्र होने वाली रणनीति।';

  @override
  String get puzzleThemeHookMate => 'हुक मात';

  @override
  String get puzzleThemeHookMateDescription => 'शत्रु राजा के भागने को सीमित करने के लिए एक शत्रु प्यादा के साथ एक हाथी, घोड़ा और प्यादा के साथ चेकमेट।';

  @override
  String get puzzleThemeInterference => 'दखल अंदाजी';

  @override
  String get puzzleThemeInterferenceDescription => 'दो प्रतिद्वंद्वी टुकड़ों के बीच एक टुकड़े को स्थानांतरित करना एक या दोनों प्रतिद्वंद्वी टुकड़ों को अपरिभाषित करना, जैसे कि दो बदमाशों के बीच बचाव चौक पर एक नाइट।';

  @override
  String get puzzleThemeIntermezzo => 'इंटेरमेस्सो';

  @override
  String get puzzleThemeIntermezzoDescription => 'अपेक्षित चाल चलने के बजाय, पहले एक और कदम उठाएँ, जिससे तत्काल खतरे की आशंका पैदा हो जाए। इसे \"ज़्विसचेंज़ुग\" या \"इन बीच\" के रूप में भी जाना जाता है।';

  @override
  String get puzzleThemeKnightEndgame => 'नाइट एंडगेम';

  @override
  String get puzzleThemeKnightEndgameDescription => 'केवल शूरवीरों और प्यादों के साथ एक एंडगेम।';

  @override
  String get puzzleThemeLong => 'लंबी पहेली';

  @override
  String get puzzleThemeLongDescription => 'जीत के लिए तीन चाल चली।';

  @override
  String get puzzleThemeMaster => 'मास्टर खेल';

  @override
  String get puzzleThemeMasterDescription => 'शीर्षक वाले खिलाड़ियों द्वारा खेले जाने वाले खेलों की पहेलियाँ।';

  @override
  String get puzzleThemeMasterVsMaster => 'मास्टर बनाम मास्टर खेल';

  @override
  String get puzzleThemeMasterVsMasterDescription => 'दो शीर्षक वाले खिलाड़ियों के बीच खेल से पहेलियाँ।';

  @override
  String get puzzleThemeMate => 'शाहमात';

  @override
  String get puzzleThemeMateDescription => 'शैली के साथ खेल जीतें।';

  @override
  String get puzzleThemeMateIn1 => '1 में मात';

  @override
  String get puzzleThemeMateIn1Description => 'एक कदम में चेकमेट वितरित करें।';

  @override
  String get puzzleThemeMateIn2 => '2 में मात';

  @override
  String get puzzleThemeMateIn2Description => 'चेकमेट को दो चालों में वितरित करें।';

  @override
  String get puzzleThemeMateIn3 => '3 में मात';

  @override
  String get puzzleThemeMateIn3Description => 'चेकमेट को तीन चालों में वितरित करें।';

  @override
  String get puzzleThemeMateIn4 => '4 में मात';

  @override
  String get puzzleThemeMateIn4Description => 'चेकमेट को चार चालों में वितरित करें।';

  @override
  String get puzzleThemeMateIn5 => '5 या अधिक में मात';

  @override
  String get puzzleThemeMateIn5Description => 'एक लंबी संभोग अनुक्रम का चित्रण करें।';

  @override
  String get puzzleThemeMiddlegame => 'मिडलगेम';

  @override
  String get puzzleThemeMiddlegameDescription => 'खेल के दूसरे चरण के दौरान एक रणनीति।';

  @override
  String get puzzleThemeOneMove => 'एकतरफा पहेली';

  @override
  String get puzzleThemeOneMoveDescription => 'एक पहेली जो केवल एक लंबी है।';

  @override
  String get puzzleThemeOpening => 'प्रारंभिक';

  @override
  String get puzzleThemeOpeningDescription => 'खेल के पहले चरण के दौरान एक रणनीति।';

  @override
  String get puzzleThemePawnEndgame => 'प्यादा एंडगेम';

  @override
  String get puzzleThemePawnEndgameDescription => 'केवल प्यादों के साथ एक एंडगेम।';

  @override
  String get puzzleThemePin => 'पिन';

  @override
  String get puzzleThemePinDescription => 'एक टैक्टिक जिसमें पिन शामिल होता है, जहां एक टुकड़ा उच्च मूल्य के टुकड़े पर हमले का खुलासा किए बिना स्थानांतरित करने में असमर्थ होता है।';

  @override
  String get puzzleThemePromotion => 'पदोन्नति';

  @override
  String get puzzleThemePromotionDescription => 'प्रचार करने या धमकी देने वाला मोहरा रणनीति की कुंजी है।';

  @override
  String get puzzleThemeQueenEndgame => 'वज़ीर एंडगेम';

  @override
  String get puzzleThemeQueenEndgameDescription => 'केवल वज़ीरों और प्यादों के साथ एक एंडगेम।';

  @override
  String get puzzleThemeQueenRookEndgame => 'वज़ीर और हाथी';

  @override
  String get puzzleThemeQueenRookEndgameDescription => 'केवल वज़ीरों, हाथी और प्यादों के साथ एक एंडगेम।';

  @override
  String get puzzleThemeQueensideAttack => 'वज़ीर साइड हमला';

  @override
  String get puzzleThemeQueensideAttackDescription => 'वज़ीर के पक्ष में जाने के बाद, प्रतिद्वंद्वी के राजा पर हमला।';

  @override
  String get puzzleThemeQuietMove => 'शांत चाल';

  @override
  String get puzzleThemeQuietMoveDescription => 'एक चाल जो एक चेक या कैप्चर नहीं करता है, लेकिन बाद के कदम के लिए एक अपरिहार्य खतरा तैयार करता है।';

  @override
  String get puzzleThemeRookEndgame => 'रूक एंडगेम';

  @override
  String get puzzleThemeRookEndgameDescription => 'केवल किश्ती और पंजे के साथ एक एंडगेम।';

  @override
  String get puzzleThemeSacrifice => 'कुर्बानी';

  @override
  String get puzzleThemeSacrificeDescription => 'चालों के मजबूर अनुक्रम के बाद फिर से लाभ प्राप्त करने के लिए अल्पकालिक में सामग्री देने से संबंधित एक रणनीति।';

  @override
  String get puzzleThemeShort => 'लघु पहेली';

  @override
  String get puzzleThemeShortDescription => 'जीतने के लिए दो चाल।';

  @override
  String get puzzleThemeSkewer => 'स्किवर';

  @override
  String get puzzleThemeSkewerDescription => 'एक उच्च मूल्य के टुकड़े पर हमला करने वाला एक मोटिफ, जिस तरह से बाहर निकल रहा है, और इसके पीछे एक कम मूल्य के टुकड़े को पकड़ने या हमला करने की अनुमति देता है, एक पिन का उलटा।';

  @override
  String get puzzleThemeSmotheredMate => 'समोथेरद मात';

  @override
  String get puzzleThemeSmotheredMateDescription => 'एक चेकमेट जो एक घोड़े द्वारा दिया जाता है, जिसमें संभोगरत राजा हिलने में असमर्थ होता है, क्योंकि वह अपने ही टुकड़ों से घिरा होता है (या स्मूथ)।';

  @override
  String get puzzleThemeSuperGM => 'उत्तम जीएम का खेल';

  @override
  String get puzzleThemeSuperGMDescription => 'दुनिया के सर्वश्रेष्ठ खिलाड़ियों द्वारा खेले जाने वाले खेलों की पहेलियाँ।';

  @override
  String get puzzleThemeTrappedPiece => 'फँसा हुआ मोहरा';

  @override
  String get puzzleThemeTrappedPieceDescription => 'एक मोहरा बचने में असमर्थ है क्योंकि सीमित चालें हैं।';

  @override
  String get puzzleThemeUnderPromotion => 'सामर्थ्य से कम उन्नति';

  @override
  String get puzzleThemeUnderPromotionDescription => 'एक घोड़े, ऊँट, या हाथी में पदोन्नति।';

  @override
  String get puzzleThemeVeryLong => 'बहुत लंबी पहेली';

  @override
  String get puzzleThemeVeryLongDescription => 'जीतने के लिए चार चाल या उससे अधिक।';

  @override
  String get puzzleThemeXRayAttack => 'एक्स-रे हमला';

  @override
  String get puzzleThemeXRayAttackDescription => 'एक टुकड़ा एक दुश्मन के टुकड़े के माध्यम से एक वर्ग पर हमला करता है या बचाव करता है।';

  @override
  String get puzzleThemeZugzwang => 'ज़ुग्ज्वांग';

  @override
  String get puzzleThemeZugzwangDescription => 'प्रतिद्वंद्वी उन चालों में सीमित है जो वे कर सकते हैं, और सभी चालें उनकी स्थिति को खराब करती हैं।';

  @override
  String get puzzleThemeHealthyMix => 'स्वस्थ मिश्रण';

  @override
  String get puzzleThemeHealthyMixDescription => 'सब का कुछ कुछ। आप नहीं जानते कि क्या उम्मीद है, इसलिए आप किसी भी चीज़ के लिए तैयार रहें! बिल्कुल असली खेल की तरह।';

  @override
  String get puzzleThemePlayerGames => 'खिलाड़ियों के खेल';

  @override
  String get puzzleThemePlayerGamesDescription => 'Lookup puzzles generated from your games, or from another player\'s games.';

  @override
  String puzzleThemePuzzleDownloadInformation(String param) {
    return 'These puzzles are in the public domain, and can be downloaded from $param.';
  }

  @override
  String get searchSearch => 'खोजें';

  @override
  String get settingsSettings => 'व्यवस्था (सेटिंग्स)';

  @override
  String get settingsCloseAccount => 'खातें को बंद करें';

  @override
  String get settingsManagedAccountCannotBeClosed => 'आपका खाता प्रबंधित है, और बंद नहीं किया जा सकता|';

  @override
  String get settingsClosingIsDefinitive => 'समापन निश्चित है। वहां से कोई वापसी नहीं है। क्या आपने सुनिश्चित कर लिया है?';

  @override
  String get settingsCantOpenSimilarAccount => 'आपको इस नाम से कोई नया खाता खोलने की अनुमति नहीं दी जाएगी।';

  @override
  String get settingsChangedMindDoNotCloseAccount => 'मैंने अपना मन बदल लिया, मेरे खाता को बंद न करें';

  @override
  String get settingsCloseAccountExplanation => 'क्या आप वाकई अपना खाता बंद करना चाहते हैं? अपना खाता बंद करना एक स्थायी निर्णय है। आप कभी भी लॉग इन नहीं कर पाएंगे।';

  @override
  String get settingsThisAccountIsClosed => 'यह ख़ाता बंद है|';

  @override
  String get playWithAFriend => 'मित्र के साथ खेलें';

  @override
  String get playWithTheMachine => 'कंप्यूटर के साथ खेलें';

  @override
  String get toInviteSomeoneToPlayGiveThisUrl => 'इस खेल में किसी को आमंत्रित करने के लिए उन्हें ये पता दें';

  @override
  String get gameOver => 'खेल समाप्त';

  @override
  String get waitingForOpponent => 'आप प्रतिद्वंदी की प्रतीक्षा कर रहे हैं';

  @override
  String get orLetYourOpponentScanQrCode => 'या अपने प्रतिद्वंद्वी को इस क्यूआर कोड को स्कैन करने दें';

  @override
  String get waiting => 'प्रतिद्वंदी के चुनौती स्वीकार करने की प्रतीक्षा कर रहे हैं';

  @override
  String get yourTurn => 'आपकी चाल';

  @override
  String aiNameLevelAiLevel(String param1, String param2) {
    return '$param1 स्तर $param2 वाला';
  }

  @override
  String get level => 'स्तर';

  @override
  String get strength => 'ताक़त';

  @override
  String get toggleTheChat => 'चैट को टोग्ल करें';

  @override
  String get chat => 'बातचीत';

  @override
  String get resign => 'हार मान लें';

  @override
  String get checkmate => 'शह और मात';

  @override
  String get stalemate => 'गतिरोध (स्टेलमेट)';

  @override
  String get white => 'सफेद';

  @override
  String get black => 'काला';

  @override
  String get asWhite => 'सफ़ेद से';

  @override
  String get asBlack => 'काले से';

  @override
  String get randomColor => 'कोई भी रंग';

  @override
  String get createAGame => 'नया खेल';

  @override
  String get whiteIsVictorious => 'सफेद विजयी हुआ';

  @override
  String get blackIsVictorious => 'काला विजयी हुआ';

  @override
  String get youPlayTheWhitePieces => 'आप सफेद मोहरों से खेलेंगे';

  @override
  String get youPlayTheBlackPieces => 'आप काले मोहरों से खेलेंगे';

  @override
  String get itsYourTurn => 'यह आपकी बारी है!';

  @override
  String get cheatDetected => 'धोखा का पता चला';

  @override
  String get kingInTheCenter => 'राजा मध्य में';

  @override
  String get threeChecks => 'तीन शह';

  @override
  String get raceFinished => 'दौड़ समाप्त';

  @override
  String get variantEnding => 'प्रकार समाप्त';

  @override
  String get newOpponent => 'नया प्रतिद्वंदी ढूंढें';

  @override
  String get yourOpponentWantsToPlayANewGameWithYou => 'आपका प्रतिद्वंद्वी आपके साथ एक नया खेल खेलना चाहता है';

  @override
  String get joinTheGame => 'खेल में शामिल हों';

  @override
  String get whitePlays => 'सफेद की चाल';

  @override
  String get blackPlays => 'काले की चाल';

  @override
  String get opponentLeftChoices => 'आपके प्रतिद्वंद्वी ने खेल छोड़ दिया। आप जीत का दावा कर सकते हैं, खेल को ड्रा कह सकते हैं, या प्रतीक्षा कर सकते हैं।';

  @override
  String get forceResignation => 'जीत का दवा करें';

  @override
  String get forceDraw => 'बराबरी पर खेल समाप्त करें';

  @override
  String get talkInChat => 'कृपया सज्जनतापूर्ण बातचीत करें!';

  @override
  String get theFirstPersonToComeOnThisUrlWillPlayWithYou => 'इस URL पर आने वाला पहला व्यक्ति आपके साथ खेलेगा।';

  @override
  String get whiteResigned => 'सफेद ने हार मान ली';

  @override
  String get blackResigned => 'काले ने हार मान ली';

  @override
  String get whiteLeftTheGame => 'सफेद खेल छोड़ कर चला गया';

  @override
  String get blackLeftTheGame => 'काला खेल छोड़ कर चला गया';

  @override
  String get whiteDidntMove => 'सफेद ने चाल नहीं चली';

  @override
  String get blackDidntMove => 'काले ने चाल नहीं चली';

  @override
  String get requestAComputerAnalysis => 'कंप्यूटर विश्लेषण का अनुरोध करें';

  @override
  String get computerAnalysis => 'कंप्यूटर विश्लेषण';

  @override
  String get computerAnalysisAvailable => 'कंप्यूटर विश्लेषण उपलब्ध है';

  @override
  String get computerAnalysisDisabled => 'कंप्यूटर विश्लेषण निष्क्रिय है';

  @override
  String get analysis => 'विश्लेषण पट';

  @override
  String depthX(String param) {
    return 'मध्यमार्ग $param';
  }

  @override
  String get usingServerAnalysis => 'सर्वर विश्लेषण का उपयोग किया जा रहा है';

  @override
  String get loadingEngine => 'इंजन लोड हो रहा है ...';

  @override
  String get calculatingMoves => 'चालों की गणना की जा रही है...';

  @override
  String get engineFailed => 'इंजन लोड करने में समस्या';

  @override
  String get cloudAnalysis => 'क्लाउड विश्लेषण';

  @override
  String get goDeeper => 'गहराई में जाओ';

  @override
  String get showThreat => 'खतरे को दिखाएं';

  @override
  String get inLocalBrowser => 'स्थानीय ब्राउज़र में';

  @override
  String get toggleLocalEvaluation => 'स्थानीय मूल्यांकन को टॉगल करें';

  @override
  String get promoteVariation => 'विविधता को बढ़ावा दें';

  @override
  String get makeMainLine => 'मुख्य लाइन बनाएं';

  @override
  String get deleteFromHere => 'यहां से हटाओ';

  @override
  String get collapseVariations => 'Collapse variations';

  @override
  String get expandVariations => 'Expand variations';

  @override
  String get forceVariation => 'बल भिन्नता';

  @override
  String get copyVariationPgn => 'प्रतिलिपि भिन्नता पीजीएन';

  @override
  String get move => 'चाल';

  @override
  String get variantLoss => 'प्रकार में हानि';

  @override
  String get variantWin => 'जीत का प्रकार';

  @override
  String get insufficientMaterial => 'मात के लिए  मोहरे  की अपर्याप्तता';

  @override
  String get pawnMove => 'प्यादा  की चाल';

  @override
  String get capture => 'कब्जा';

  @override
  String get close => 'बंद करें';

  @override
  String get winning => 'जीत';

  @override
  String get losing => 'हार';

  @override
  String get drawn => 'ड्रॉ';

  @override
  String get unknown => 'अज्ञात';

  @override
  String get database => 'डेटाबेस';

  @override
  String get whiteDrawBlack => 'सफ़ेद / ड्रॉ / काला';

  @override
  String averageRatingX(String param) {
    return 'औसत रेटिंग: $param';
  }

  @override
  String get recentGames => 'हाल के खेल';

  @override
  String get topGames => 'शीर्ष खेल';

  @override
  String masterDbExplanation(String param1, String param2, String param3) {
    return '$param2 से $param3 के दशक के $param1+ FIDE- रेटेड खिलाड़ियों के दो मिलियन ओटीबी खेल';
  }

  @override
  String get dtzWithRounding => 'DTZ50\'\' गोलाई के साथ, अगले कब्ज़ा या प्यादा की चाल तक आधे-चालों की संख्या के आधार पर';

  @override
  String get noGameFound => 'कोई गेम नहीं मिला';

  @override
  String get maxDepthReached => 'अधिकतम गहराई तक पहुँच गया!';

  @override
  String get maybeIncludeMoreGamesFromThePreferencesMenu => 'शायद प्राथमिकताएं मेनू से अधिक गेम शामिल हैं?';

  @override
  String get openings => 'शुरूआत';

  @override
  String get openingExplorer => 'उद्घाटन खोज';

  @override
  String get openingEndgameExplorer => 'प्रारम्भिक खेल/समाप्ति खेल अन्वेषक';

  @override
  String xOpeningExplorer(String param) {
    return '$param ओपनिंग एक्सप्लोरर';
  }

  @override
  String get playFirstOpeningEndgameExplorerMove => 'पहली ओपनिंग/एंडगेम-एक्सप्लोरर चाल खेलें';

  @override
  String get winPreventedBy50MoveRule => 'जीत 50-चालन नियम से रोका गया';

  @override
  String get lossSavedBy50MoveRule => 'हार 50-चाल नियम द्वारा बचाया';

  @override
  String get winOr50MovesByPriorMistake => 'जीत अथ्वा 50 चाल नियम पुरानी ग़लती के कारण​।';

  @override
  String get lossOr50MovesByPriorMistake => 'हार​ अथ्वा 50 चाल नियम पुरानी ग़लती के कारण​।';

  @override
  String get unknownDueToRounding => 'जीत/नुकसान की गारंटी केवल तभी दी जाती है जब Syzygy टेबलबेस में DTZ मानों के संभावित राउंडिंग के कारण अंतिम कैप्चर या पॉन मूव के बाद से अनुशंसित टेबलबेस लाइन का पालन किया गया हो।';

  @override
  String get allSet => 'सब तैयार!';

  @override
  String get importPgn => 'PGN आयात करें';

  @override
  String get delete => 'हटाएँ';

  @override
  String get deleteThisImportedGame => 'इस आयात किए गए गेम को हटाएं?';

  @override
  String get replayMode => 'रीप्ले मोड';

  @override
  String get realtimeReplay => 'रियल टाइम';

  @override
  String get byCPL => 'CPL द्वारा';

  @override
  String get openStudy => 'अध्ययन खोलो';

  @override
  String get enable => 'सक्षम करें';

  @override
  String get bestMoveArrow => 'सर्वश्रेष्ठ चाल तीर';

  @override
  String get showVariationArrows => 'विविधता वाले तीर दिखाएँ';

  @override
  String get evaluationGauge => 'मूल्यांकन गेज';

  @override
  String get multipleLines => 'एकाधिक पंक्तियाँ';

  @override
  String get cpus => 'केंद्रीय संसाधन एकक (CPUs)';

  @override
  String get memory => 'स्मृति (मेमोरी)';

  @override
  String get infiniteAnalysis => 'अनंत विश्लेषण';

  @override
  String get removesTheDepthLimit => 'गहराई सीमा को निकालता है, और आपके कंप्यूटर को गर्म रखता है';

  @override
  String get engineManager => 'इंजन प्रबंधक';

  @override
  String get blunder => 'भयंकर गलती';

  @override
  String get mistake => 'ग़लती';

  @override
  String get inaccuracy => 'गलती';

  @override
  String get moveTimes => 'चाल समय';

  @override
  String get flipBoard => 'बोर्ड पलटें';

  @override
  String get threefoldRepetition => 'तीन बार दोहराव';

  @override
  String get claimADraw => 'बराबरी का दावा करें';

  @override
  String get offerDraw => 'खेल को बराबरी पर समाप्त करने का प्रस्ताव दें';

  @override
  String get draw => 'खेल बराबरी पे समाप्त';

  @override
  String get drawByMutualAgreement => 'आपसी सहमति से ड्रॉ';

  @override
  String get fiftyMovesWithoutProgress => 'पचास चालें बिना किसी प्रगति के';

  @override
  String get currentGames => 'अभी खेले जा रहे खेल';

  @override
  String get viewInFullSize => 'पूर्ण आकर में देखें';

  @override
  String get logOut => 'खाते से निकास करें';

  @override
  String get signIn => 'खाते में प्रवेश करें';

  @override
  String get rememberMe => 'मुझे लोग्ड इन रखें';

  @override
  String get youNeedAnAccountToDoThat => 'ऐसा करने के लिए आपको खाता खोलने की आवश्यकता है';

  @override
  String get signUp => 'खाता खोलें';

  @override
  String get computersAreNotAllowedToPlay => 'कंप्यूटर और कंप्यूटर-सहाय खिलाडियों  को खेलने की अनुमति नहीं है । कृपया शतरंज मशीनों, दस्तावेजों या किसी और खिलाडी की सहायता न लें। इस बात का भी ध्यान रखें कि एक से अधिक खाते खोलना बिलकुल भी प्रोत्साहित नहीं है और अतियाधिक खाते खोलने से आप पर प्रतिबन्ध लगा दिया जायेगा।';

  @override
  String get games => 'खेल';

  @override
  String get forum => 'जनसभा (फोरम )';

  @override
  String xPostedInForumY(String param1, String param2) {
    return '$param1 ने $param2 जनसभा (फोरम ) में उल्लेख (पोस्ट) किया';
  }

  @override
  String get latestForumPosts => 'नवीनतम जनसभा (फोरम) के उल्लेख (पोस्ट)';

  @override
  String get players => 'शतरंज खिलाड़ी';

  @override
  String get friends => 'मित्र';

  @override
  String get discussions => 'वार्तालाप';

  @override
  String get today => 'आज';

  @override
  String get yesterday => 'एक दिन पूर्व';

  @override
  String get minutesPerSide => 'मिनट प्रति खिलाड़ी';

  @override
  String get variant => 'प्रकार';

  @override
  String get variants => 'प्रकार';

  @override
  String get timeControl => 'समय नियंत्रण';

  @override
  String get realTime => 'वास्तविक खेल';

  @override
  String get correspondence => 'काफी लम्बे वक़्त का खेल';

  @override
  String get daysPerTurn => 'दिन प्रति चाल';

  @override
  String get oneDay => 'एक दिन';

  @override
  String get time => 'समय';

  @override
  String get rating => 'रेटिंग';

  @override
  String get ratingStats => 'रेटिंग सांख्यिकी';

  @override
  String get username => 'आपका यूज़र नेम';

  @override
  String get usernameOrEmail => 'उपयोगकर्ता का नाम';

  @override
  String get changeUsername => 'खाता नाम बदलें';

  @override
  String get changeUsernameNotSame => 'केवल अक्षरों का मामला बदल सकता है। उदाहरण के लिए \"johndoe\" से \"JohnDoe\"।';

  @override
  String get changeUsernameDescription => 'अपना उपयोगकर्ता नाम बदलें। यह केवल एक बार किया जा सकता है और आपको केवल अपने उपयोगकर्ता नाम के केस को बदलने की अनुमति है।';

  @override
  String get signupUsernameHint => 'कृपया उचित यूज़रनेम ही चुनें। आप इसे बाद में बदल नहीं पाएंगे और अनुचित यूज़रनेम वाले कोई भी खाते बंद कर दिए जाएंगे।';

  @override
  String get signupEmailHint => 'हम इस का इस्तेमाल सिर्फ़ पासवर्ड रीसेट के लिए करेंगे।';

  @override
  String get password => 'पासवर्ड';

  @override
  String get changePassword => 'पासवर्ड बदलें';

  @override
  String get changeEmail => 'अपना इ-मेल बदलो';

  @override
  String get email => 'इ-मेल';

  @override
  String get passwordReset => 'पासवर्ड बदलें';

  @override
  String get forgotPassword => 'क्या आप अपना पासवर्ड भूल गए हैं?';

  @override
  String get error_weakPassword => 'यह पासवर्ड बहुत ही सामान्य है, और इसका अनुमान लगाना बहुत आसान है।';

  @override
  String get error_namePassword => 'कृपया अपने यूजरनेम नाम को अपने पासवर्ड के रूप में उपयोग न करें।';

  @override
  String get blankedPassword => 'आपने उसी पासवर्ड का उपयोग किसी अन्य साइट पर किया है, और उस साइट के साथ छेड़छाड़ की गई है। आपके लिचेस खाते की सुरक्षा सुनिश्चित करने के लिए, हम चाहते हैं कि आप एक नया पासवर्ड सेट करें। समझने के लिए धन्यवाद |';

  @override
  String get youAreLeavingLichess => 'आप लिचेस छोड़ रहे हैं';

  @override
  String get neverTypeYourPassword => 'अपना लिचेस पासवर्ड कभी भी किसी अन्य साइट पर न लिखें!';

  @override
  String proceedToX(String param) {
    return '$param पर जाएं';
  }

  @override
  String get passwordSuggestion => 'किसी और द्वारा सुझाया गया पासवर्ड सेट न करें। वे इसका इस्तेमाल आपके खाते को चुराने के लिए कर सकते हैं';

  @override
  String get emailSuggestion => 'किसी और द्वारा सुझाया गया पासवर्ड सेट न करें। वे इसका इस्तेमाल आपके खाते को चुराने के लिए कर सकते हैं';

  @override
  String get emailConfirmHelp => 'ईमेल कन्फ़र्मेशन में सहायता';

  @override
  String get emailConfirmNotReceived => 'साइन अप के बाद कन्फ़र्मेशन ईमेल नहीं मिला?';

  @override
  String get whatSignupUsername => 'आपने साइन अप के लिए कौन से यूज़रनेम का इस्तेमाल किया?';

  @override
  String usernameNotFound(String param) {
    return 'हमें $param नाम से कोई यूज़र नहीं मिला।';
  }

  @override
  String get usernameCanBeUsedForNewAccount => 'आप इस यूज़रनेम से नया खाता खोल सकते हैं|';

  @override
  String emailSent(String param) {
    return 'हम ने $param को ईमेल भेजा है|';
  }

  @override
  String get emailCanTakeSomeTime => 'इसे आने में कुछ समय लग सकता है।';

  @override
  String get refreshInboxAfterFiveMinutes => '5 मिनट प्रतीक्षा करें और अपना ईमेल इनबॉक्स रिफ्रेश करें।';

  @override
  String get checkSpamFolder => 'अपना स्पैम फ़ोल्डर भी जांचें, हो सकता है कि वह वहां हो। यदि हां, तो इसे स्पैम नहीं के रूप में चिह्नित करें।';

  @override
  String get emailForSignupHelp => 'यदि बाकी सब विफल हो जाए तो हमें यह ईमेल भेजें';

  @override
  String copyTextToEmail(String param) {
    return 'उपरोक्त टेक्स्ट को कॉपी और पेस्ट करें और $param पर भेजें';
  }

  @override
  String get waitForSignupHelp => 'आपका साइनअप पूरा करने में मदद करने के लिए हम जल्द ही आपके पास वापस आएंगे।';

  @override
  String accountConfirmed(String param) {
    return 'The user $param is successfully confirmed.';
  }

  @override
  String accountCanLogin(String param) {
    return 'आप अब $param से लॉग इन कर सकते हैं|';
  }

  @override
  String get accountConfirmationEmailNotNeeded => 'आप को कन्फ़र्मेशन ईमेल की ज़रुरत नहीं है|';

  @override
  String accountClosed(String param) {
    return '$param खाता बंद है.';
  }

  @override
  String accountRegisteredWithoutEmail(String param) {
    return 'खाता $param बिना किसी ईमेल के पंजीकृत किया गया था.';
  }

  @override
  String get rank => 'श्रेणी (रैंक)';

  @override
  String rankX(String param) {
    return 'रैंक: $param';
  }

  @override
  String get gamesPlayed => 'खेले हुए खेल';

  @override
  String get cancel => 'रद्द करें';

  @override
  String get whiteTimeOut => 'सफेद का समय समाप्त';

  @override
  String get blackTimeOut => 'काला का समय समाप्त';

  @override
  String get drawOfferSent => 'बराबरी पे खेल समाप्त करने का प्रस्ताव भेजा गया';

  @override
  String get drawOfferAccepted => 'बराबरी पे खेल समाप्त करने का प्रस्ताव स्वीकारित किया गया';

  @override
  String get drawOfferCanceled => 'बराबरी पे खेल समाप्त करने का प्रस्ताव रद्द किया गया.';

  @override
  String get whiteOffersDraw => 'सफ़ेद खिलाड़ी का बराबरी पे खेल समाप्त करने का प्रस्ताव';

  @override
  String get blackOffersDraw => 'काले खिलाड़ी का बराबरी पे खेल समाप्त करने का प्रस्ताव';

  @override
  String get whiteDeclinesDraw => 'सफ़ेद खिलाड़ी द्वारा बराबरी पे खेल समाप्त करने का प्रस्ताव ख़ारिज';

  @override
  String get blackDeclinesDraw => 'काले खिलाड़ी द्वारा बराबरी पे खेल समाप्त करने का प्रस्ताव ख़ारिज';

  @override
  String get yourOpponentOffersADraw => 'आपके प्रतिद्वंदी ने बराबरी पे खेल समाप्त करने का प्रस्ताव भेजा है';

  @override
  String get accept => 'स्वीकार करें';

  @override
  String get decline => 'अस्वीकार करें';

  @override
  String get playingRightNow => 'अभी खेला जा रहा';

  @override
  String get eventInProgress => 'अभी खेला जा रहा';

  @override
  String get finished => 'समाप्त';

  @override
  String get abortGame => 'खेल रद्द करें';

  @override
  String get gameAborted => 'खेल रद्द किया गया';

  @override
  String get standard => 'साधारण';

  @override
  String get customPosition => 'कस्टम स्थान';

  @override
  String get unlimited => 'असीमित';

  @override
  String get mode => 'प्रणाली';

  @override
  String get casual => 'मूल्यांकन के बिना';

  @override
  String get rated => 'मूल्यांकित';

  @override
  String get casualTournament => 'आकस्मिक';

  @override
  String get ratedTournament => 'रेटेड';

  @override
  String get thisGameIsRated => 'यह खेल मूल्यांकित है';

  @override
  String get rematch => 'फिर से खेलें';

  @override
  String get rematchOfferSent => 'फिर से खेलने का प्रस्ताव भेजा गया है';

  @override
  String get rematchOfferAccepted => 'फिर से खेलने का प्रस्ताव स्वीकार कर लिया गया है';

  @override
  String get rematchOfferCanceled => 'फिर से खेलने का प्रस्ताव रद्द कर दिया गया है';

  @override
  String get rematchOfferDeclined => 'फिर से खेलने का प्रस्ताव अस्वीकार कर दिया गया है';

  @override
  String get cancelRematchOffer => 'फिर से खेलने का प्रस्ताव रद्द करें';

  @override
  String get viewRematch => 'फिर से खेले गए खेल को देखें';

  @override
  String get confirmMove => 'चाल की पुष्टि करें';

  @override
  String get play => 'खेलें';

  @override
  String get inbox => 'आपके सन्देश (इनबॉक्स)';

  @override
  String get chatRoom => 'बातचीत का कमरा';

  @override
  String get loginToChat => 'चैट के लिए लॉग इन';

  @override
  String get youHaveBeenTimedOut => 'आप का समय समाप्त हो गया है';

  @override
  String get spectatorRoom => 'दर्शकों का कमरा';

  @override
  String get composeMessage => 'सन्देश बनाएँ';

  @override
  String get subject => 'विषय';

  @override
  String get send => 'भेजें';

  @override
  String get incrementInSeconds => 'हर चाल पर सेकंड्स की वृद्धि';

  @override
  String get freeOnlineChess => 'मुफ्त ऑनलाइन शतरंज';

  @override
  String get exportGames => 'खेल को निर्यात (एक्सपोर्ट) करें';

  @override
  String get ratingRange => 'अंकों की सीमा';

  @override
  String get thisAccountViolatedTos => 'इस खाते ने सेवा की शर्तों का उल्लंघन किया';

  @override
  String get openingExplorerAndTablebase => 'ओपनिंग एक्सप्लोरर & टेबलबेस';

  @override
  String get takeback => 'चाल को वापस लें';

  @override
  String get proposeATakeback => 'चाल को वापस लेने की प्रस्ताव को भेजें';

  @override
  String get takebackPropositionSent => 'चाल को वापस लेने के प्रस्ताव को भेज दिया गया है';

  @override
  String get takebackPropositionDeclined => 'चाल को वापस लेने के प्रस्ताव को अस्वीकार कर दिया गया है';

  @override
  String get takebackPropositionAccepted => 'चाल को वापस लेने के प्रस्ताव को स्वीकार कर लिया गया है';

  @override
  String get takebackPropositionCanceled => 'चाल को वापस लेने के प्रस्ताव को रद्द कर दिया गया है';

  @override
  String get yourOpponentProposesATakeback => 'आपके प्रतिद्वंद्वी ने चाल को वापस लेने का प्रस्ताव भेजा है';

  @override
  String get bookmarkThisGame => 'इस खेल की स्मृति (बुकमार्क) बनाएं';

  @override
  String get tournament => 'प्रतियोगिता';

  @override
  String get tournaments => 'प्रतियोगिताएँ';

  @override
  String get tournamentPoints => 'प्रतियोगिता के अंक';

  @override
  String get viewTournament => 'प्रतियोगिता देखें';

  @override
  String get backToTournament => 'प्रतियोगिता पर वापिस जाएँ';

  @override
  String get noDrawBeforeSwissLimit => 'स्विस टूर्नामेंट में 30 चालें खेले जाने से पहले आप ड्रॉ नहीं कर सकते।';

  @override
  String get thematic => 'कथ्यपरक';

  @override
  String yourPerfRatingIsProvisional(String param) {
    return 'आपके $param रेटिंग अनंतिम है';
  }

  @override
  String yourPerfRatingIsTooHigh(String param1, String param2) {
    return 'आपके $param1 रेटिंग ($param2) बहुत अधिक है';
  }

  @override
  String yourTopWeeklyPerfRatingIsTooHigh(String param1, String param2) {
    return 'अपने शीर्ष साप्ताहिक $param1 रेटिंग ($param2) बहुत अधिक है';
  }

  @override
  String yourPerfRatingIsTooLow(String param1, String param2) {
    return 'आपका $param1 रेटिंग ($param2) बहुत कम है';
  }

  @override
  String ratedMoreThanInPerf(String param1, String param2) {
    return '≥ $param1 में $param2 रेट';
  }

  @override
  String ratedLessThanInPerf(String param1, String param2) {
    return '≤ $param1 में $param2 रेट';
  }

  @override
  String mustBeInTeam(String param) {
    return 'टीम में होना ज़रूरी है $param';
  }

  @override
  String youAreNotInTeam(String param) {
    return 'आप $param का हिस्सा नही हो';
  }

  @override
  String get backToGame => 'खेल पर लौटें।';

  @override
  String get siteDescription => 'खेलें शतरंज मुफ्त और ऑनलाइन साफ़ सुथरे अंदाज में| न कोई पंजीकरण, न कोई प्रचार और न ही किसी अन्य बहरी चीज की आव्यशकता| शतरंज कम्प्युटर, दोस्तों या किसी भी प्रतिद्वंदी के साथ खेलें|';

  @override
  String xJoinedTeamY(String param1, String param2) {
    return '$param1 $param2 समूह से जुड़ा';
  }

  @override
  String xCreatedTeamY(String param1, String param2) {
    return '$param1 ने  $param2 समूह बनाया';
  }

  @override
  String get startedStreaming => 'ने स्ट्रीमिंग शुरू किया';

  @override
  String xStartedStreaming(String param) {
    return '$param ने स्ट्रीमिंग शुरू किया';
  }

  @override
  String get averageElo => 'औसत अंक';

  @override
  String get location => 'स्थान';

  @override
  String get filterGames => 'खेलों को छानें (फ़िल्टर करें)';

  @override
  String get reset => 'फिर से स्थापित (रीसेट) करें';

  @override
  String get apply => 'लागू करें';

  @override
  String get save => 'सहेजें';

  @override
  String get leaderboard => 'उच्च खिलाडी, अंक तालिका (लीडरबोर्ड)';

  @override
  String get screenshotCurrentPosition => 'वर्तमान स्थिति का स्क्रीनशॉट';

  @override
  String get gameAsGIF => 'GIF के रूप में सेव करें';

  @override
  String get pasteTheFenStringHere => 'FEN को यहा रखें (paste)';

  @override
  String get pasteThePgnStringHere => 'PGN को यहा रखें (paste)';

  @override
  String get orUploadPgnFile => 'या PGN अपलोड करे|';

  @override
  String get fromPosition => 'स्थिति से';

  @override
  String get continueFromHere => 'यहा से जारी करें';

  @override
  String get toStudy => 'पढ़े';

  @override
  String get importGame => 'खेल आयात (इम्पोर्ट) करे';

  @override
  String get importGameExplanation => 'जब एक खेल PGN चिपकाने आप एक ब्राउसेबल पुनरावृत्ति, एक कंप्यूटर विश्लेषण, एक खेल चैट और एक साझा यूआरएल मिलता है ।';

  @override
  String get importGameCaveat => 'विविधताएं मिट जाएंगी. उन्हें रखने के लिए, एक अध्ययन के माध्यम से PGN आयात करें।';

  @override
  String get importGameDataPrivacyWarning => 'This PGN can be accessed by the public. To import a game privately, use a study.';

  @override
  String get thisIsAChessCaptcha => 'यह इंसानों और कम्प्यूटरों को अलग करने के लिए शतरंज की पहेली है';

  @override
  String get clickOnTheBoardToMakeYourMove => 'अपनी चाल चलने के लिए बोर्ड पर क्लिक करें और साबित करे की आप इंसान हैं।';

  @override
  String get captcha_fail => 'कृपया शतरंज कैप्चा हल करें।';

  @override
  String get notACheckmate => 'शह और मात नहीं';

  @override
  String get whiteCheckmatesInOneMove => 'सफेद १ चाल में शहमात देगा';

  @override
  String get blackCheckmatesInOneMove => 'काला १ चाल में शहमात देगा';

  @override
  String get retry => 'फिर से कोशिश करें';

  @override
  String get reconnecting => 'फिर से जुड़ने की कोशिश (रीकनेक्ट)';

  @override
  String get noNetwork => 'ऑफ़लाइन';

  @override
  String get favoriteOpponents => 'पसंदीदा विरोधि';

  @override
  String get follow => 'अनुसरण करे';

  @override
  String get following => 'अनुसरण कर रहे हैं';

  @override
  String get unfollow => 'अनुसरण न करें';

  @override
  String followX(String param) {
    return '$param को फॉलो करें';
  }

  @override
  String unfollowX(String param) {
    return 'क्या आप $param को अनफॉलो कारना चाहते हैं?';
  }

  @override
  String get block => 'अवस्र्द्ध (ब्लॉक) करें';

  @override
  String get blocked => 'अवस्र्द्ध (ब्लॉक) कर दिया गया';

  @override
  String get unblock => 'अवस्र्द्ध (ब्लॉक) न करें';

  @override
  String get followsYou => 'आपका अनुसरण कर रहे हैं';

  @override
  String xStartedFollowingY(String param1, String param2) {
    return '$param1 ने  $param2 का अनुसरण करना शुरू किया';
  }

  @override
  String get more => 'अधिक';

  @override
  String get memberSince => 'सदस्य बनने की तारीख';

  @override
  String lastSeenActive(String param) {
    return '$param पहले सक्रिय';
  }

  @override
  String get player => 'खिलाड़ी';

  @override
  String get list => 'सूची';

  @override
  String get graph => 'लेखाचित्र';

  @override
  String get required => 'जरूरी है';

  @override
  String get openTournaments => 'खुली प्रतियोगिता';

  @override
  String get duration => 'अवधि';

  @override
  String get winner => 'विजयी';

  @override
  String get standing => 'पद';

  @override
  String get createANewTournament => 'नयी प्रतियोगिता आरम्भ करें';

  @override
  String get tournamentCalendar => 'टूर्नामेंट कैलेंडर';

  @override
  String get conditionOfEntry => 'प्रवेश की शर्त:';

  @override
  String get advancedSettings => 'एडव्हान्स सेटिंग्ज';

  @override
  String get safeTournamentName => 'टूर्नामेंट के लिए उचित नाम चुनिए ।';

  @override
  String get inappropriateNameWarning => 'थोड़ा सा भी अनुचित नाम चुनने से आपका ख़ाता बंद हो सकता है।';

  @override
  String get emptyTournamentName => 'खाली रखने पर बेतरतीब ढंग से कोई एक सर्वश्रेष्ठ शतरंज के खिलाड़ी के बाद टूर्नामेंट का नाम चुना जाएगा।';

  @override
  String get makePrivateTournament => 'प्रतियोगिता को निजी बनाएं, और पासवर्ड के साथ पहुंच को प्रतिबंधित करें';

  @override
  String get join => 'हिस्सा लें';

  @override
  String get withdraw => 'छोड़ के जाएं';

  @override
  String get points => 'अंक';

  @override
  String get wins => 'जीतें';

  @override
  String get losses => 'हारें';

  @override
  String get createdBy => 'द्वारा रचित';

  @override
  String get tournamentIsStarting => 'प्रतियोगित शुरू हो रही है';

  @override
  String get tournamentPairingsAreNowClosed => 'टूर्नामेंट जोड़ियां अब बंद हो गयी हैं।';

  @override
  String standByX(String param) {
    return '$param, खिलाड़ियों, बाँधना द्वारा खड़े हो जाओ तैयार हो जाओ!';
  }

  @override
  String get pause => 'ठहराव';

  @override
  String get resume => 'फिर से शुरू करें';

  @override
  String get youArePlaying => 'आप खेल रहे हैं!';

  @override
  String get winRate => 'जीत दर';

  @override
  String get berserkRate => 'निडर की दर';

  @override
  String get performance => 'प्रदर्शन';

  @override
  String get tournamentComplete => 'टूर्नामेंट पूर्ण';

  @override
  String get movesPlayed => 'चालें चलायीं';

  @override
  String get whiteWins => 'सफ़ेद विजयी हुआ';

  @override
  String get blackWins => 'काला विजयी हुआ';

  @override
  String get drawRate => 'Draw rate';

  @override
  String get draws => 'ड्रा';

  @override
  String nextXTournament(String param) {
    return 'अगले $param टूर्नामेंट:';
  }

  @override
  String get averageOpponent => 'औसत प्रतिद्वंद्वी';

  @override
  String get boardEditor => 'बोर्ड संपादक';

  @override
  String get setTheBoard => 'बोर्ड सेट करें';

  @override
  String get popularOpenings => 'लोकप्रिय शुरुआती चाल';

  @override
  String get endgamePositions => 'अंतिम चरण के खेल की स्थिति';

  @override
  String chess960StartPosition(String param) {
    return 'चेस960 खेल की प्रारम्भिक स्थिति: $param';
  }

  @override
  String get startPosition => 'शुरू करने की स्थिति:';

  @override
  String get clearBoard => 'बोर्ड सॉफ करें';

  @override
  String get loadPosition => 'इस स्थिति से चालू करें';

  @override
  String get isPrivate => 'गोपनीय';

  @override
  String reportXToModerators(String param) {
    return 'संचालकों को $param रिपोर्ट करें';
  }

  @override
  String profileCompletion(String param) {
    return 'प्रोफाइल पूरा: $param';
  }

  @override
  String xRating(String param) {
    return '$param रेटिंग';
  }

  @override
  String get ifNoneLeaveEmpty => 'यदि कोई नहीं, खाली छोड़ दो';

  @override
  String get profile => 'प्रोफ़ाइल';

  @override
  String get editProfile => 'प्रोफ़ाइल संपादित करें';

  @override
  String get realName => 'Real name';

  @override
  String get setFlair => 'Set your flair';

  @override
  String get flair => 'Flair';

  @override
  String get youCanHideFlair => 'संपूर्ण साइट पर सभी उपयोगकर्ता विशेषताओं को छिपाने के लिए एक सेटिंग है';

  @override
  String get biography => 'जीवनी';

  @override
  String get countryRegion => 'Country or region';

  @override
  String get thankYou => 'धन्यवाद!';

  @override
  String get socialMediaLinks => 'सामाजिक माध्यम';

  @override
  String get oneUrlPerLine => 'प्रति पंक्ति एक कड़ी';

  @override
  String get inlineNotation => 'इनलाइन नोटेशन';

  @override
  String get makeAStudy => 'सुरक्षित रखने और साझा करने के लिए, एक अध्ययन करने पर विचार करें।';

  @override
  String get clearSavedMoves => 'चाल हटाओ';

  @override
  String get previouslyOnLichessTV => 'इससे पहले Lichess TV पर';

  @override
  String get onlinePlayers => 'ऑनलाइन खिलाड़ियों';

  @override
  String get activePlayers => 'सक्रिय  खिलाडी';

  @override
  String get bewareTheGameIsRatedButHasNoClock => 'सावधान, खेल मूल्यांकित है लेकिन कोई समय नियंत्रण नहीं है!';

  @override
  String get success => 'सफलता';

  @override
  String get automaticallyProceedToNextGameAfterMoving => 'चाल चलने के बाद अपने आप अगले खेल पर जाएँ';

  @override
  String get autoSwitch => 'अपने आप खेल बदलें।';

  @override
  String get puzzles => 'पहेलियाँ';

  @override
  String get onlineBots => 'ऑनलाइन बॉट';

  @override
  String get name => 'नाम';

  @override
  String get description => 'विवरण';

  @override
  String get descPrivate => 'टेक्स्ट जो केवल टीम के सदस्य देखेंगे। यदि सेट किया जाता है, तो टीम के सदस्यों के लिए सार्वजनिक विवरण को बदल देता है।';

  @override
  String get descPrivateHelp => '\"निजी विवरण\" शीर्षक के लिए मदद पाठ/';

  @override
  String get no => 'नहीं';

  @override
  String get yes => 'हाँ';

  @override
  String get help => 'सहायता';

  @override
  String get createANewTopic => 'एक नया विषय बनाएँ';

  @override
  String get topics => 'विषय';

  @override
  String get posts => 'पोस्ट की संख्या';

  @override
  String get lastPost => 'आख़िरी  पोस्ट';

  @override
  String get views => 'देखे जाने की संख्या';

  @override
  String get replies => 'उत्तरों की संख्या';

  @override
  String get replyToThisTopic => 'इस विषय पर उत्तर दें';

  @override
  String get reply => 'उत्तर दें';

  @override
  String get message => 'संदेश';

  @override
  String get createTheTopic => 'इस विषय को बनाएँ';

  @override
  String get reportAUser => 'किसी उपयोगकर्ता (यूज़र) को रिपोर्ट करें';

  @override
  String get user => 'उपयोगकर्ता (यूज़र)';

  @override
  String get reason => 'कारण';

  @override
  String get whatIsIheMatter => 'बात क्या है?';

  @override
  String get cheat => 'धोखेबाज़ी';

  @override
  String get troll => 'ट्रोल';

  @override
  String get other => 'दूसरा';

  @override
  String get reportDescriptionHelp => 'खेल/खेलों के लिंक को लगाएं (paste) और बताएँ की यूज़र के व्यवहार में क्या खराबी है|';

  @override
  String get error_provideOneCheatedGameLink => 'कृपया ठगे गए खेल के लिए कम से कम एक लिंक प्रदान करें।';

  @override
  String by(String param) {
    return '$param द्वारा';
  }

  @override
  String importedByX(String param) {
    return '$param द्वारा आयातित';
  }

  @override
  String get thisTopicIsNowClosed => 'यह विषय अब बंद हो चुका है|';

  @override
  String get blog => 'ब्लॉग';

  @override
  String get notes => 'टिप्पणियाँ';

  @override
  String get typePrivateNotesHere => 'निजी टिप्पणियाँ यहाँ लिखें';

  @override
  String get writeAPrivateNoteAboutThisUser => 'Write a private note about this user';

  @override
  String get noNoteYet => 'अभी तक कोई नोट नहीं';

  @override
  String get invalidUsernameOrPassword => 'अमान्य यूज़र का नाम या पासवर्ड';

  @override
  String get incorrectPassword => 'गलत पासवर्ड';

  @override
  String get invalidAuthenticationCode => 'अवैध प्रमाणीकरण कोड';

  @override
  String get emailMeALink => 'मुझे एक लिंक ईमेल करें';

  @override
  String get currentPassword => 'वर्तमान पासवर्ड';

  @override
  String get newPassword => 'नया पासवर्ड';

  @override
  String get newPasswordAgain => 'नया पासवर्ड (फिर से)';

  @override
  String get newPasswordsDontMatch => 'नए पासवर्ड मेल नहीं खाते हैं';

  @override
  String get newPasswordStrength => 'पासवर्ड क्षमता';

  @override
  String get clockInitialTime => 'घड़ी का शुरुआती समय';

  @override
  String get clockIncrement => 'समय वृद्धि';

  @override
  String get privacy => 'एकांतता (प्राइवेसी)';

  @override
  String get privacyPolicy => 'गोपनीयता नीति';

  @override
  String get letOtherPlayersFollowYou => 'दूसरे खिलाड़ियों को अपना अनुसरण (फॉलो) करने दें';

  @override
  String get letOtherPlayersChallengeYou => 'दूसरे खिलाड़ियों को आपको चुनौती देने दें';

  @override
  String get letOtherPlayersInviteYouToStudy => 'अन्य खिलाड़ियों को अध्ययन करने के लिए आमंत्रित करें';

  @override
  String get sound => 'आवाज़';

  @override
  String get none => 'कोई नहीं';

  @override
  String get fast => 'तेज';

  @override
  String get normal => 'समान्य';

  @override
  String get slow => 'धीमा';

  @override
  String get insideTheBoard => 'बोर्ड के अंदर';

  @override
  String get outsideTheBoard => 'बोर्ड के बाहर';

  @override
  String get allSquaresOfTheBoard => 'All squares of the board';

  @override
  String get onSlowGames => 'धीमे खेलों पर';

  @override
  String get always => 'हमेशा';

  @override
  String get never => 'कभी नहीं';

  @override
  String xCompetesInY(String param1, String param2) {
    return '$param1 $param2 में हिस्सा लेता है';
  }

  @override
  String get victory => 'जीत!';

  @override
  String get defeat => 'हार';

  @override
  String victoryVsYInZ(String param1, String param2, String param3) {
    return '$param1 बनाम $param2\n$param3 में';
  }

  @override
  String defeatVsYInZ(String param1, String param2, String param3) {
    return '$param1 बनाम $param2\n$param3 में';
  }

  @override
  String drawVsYInZ(String param1, String param2, String param3) {
    return '$param1 बनाम $param2\n$param3 में';
  }

  @override
  String get timeline => 'समयरेखा';

  @override
  String get starting => 'शुरू हो रहा है:';

  @override
  String get allInformationIsPublicAndOptional => 'सभी जानकारी सार्वजनिक और वैकल्पिक है।';

  @override
  String get biographyDescription => 'अपने बारे मे बताएँ, आपको शतरंज मे क्या अच्छा लगता है, आपका पसंदीदा शुऱुआतें, खेलें, खिलाड़ी...';

  @override
  String get listBlockedPlayers => 'उन खिलाड़ियों की सूची दिखाएँ जिन्हें आप अवस्र्द्ध (ब्लॉक) किए हुए हैं';

  @override
  String get human => 'आदमी';

  @override
  String get computer => 'कंप्यूटर';

  @override
  String get side => 'पक्ष';

  @override
  String get clock => 'घड़ी';

  @override
  String get opponent => 'प्रतिद्वंद्वी';

  @override
  String get learnMenu => 'सीखें';

  @override
  String get studyMenu => 'पढ़े';

  @override
  String get practice => 'अभ्यास';

  @override
  String get community => 'समुदाय';

  @override
  String get tools => 'उपकरण';

  @override
  String get increment => 'वृद्धि';

  @override
  String get error_unknown => 'अमान्य मूल्य';

  @override
  String get error_required => 'यह जानकारी जरुरी है';

  @override
  String get error_email => 'यह ई-मेल सही नहीं हैं';

  @override
  String get error_email_acceptable => 'यह ई-मेल स्वीकार नहीं की जा सकती है। कृप्या इसे पुनः जांच करके प्रयास करें।';

  @override
  String get error_email_unique => 'यह ईमेल या तो सही नही ह्ऐ अथवा पहले इस्तेमाल हो गया ह्ऐ';

  @override
  String get error_email_different => 'यह पहले से ही आपका ईमेल पता है';

  @override
  String error_minLength(String param) {
    return 'कम से कम $param वर्ण का शब्द होना चाहिए।';
  }

  @override
  String error_maxLength(String param) {
    return 'कम से कम $param वर्ण का शब्द होना चाहिए।';
  }

  @override
  String error_min(String param) {
    return 'कम से कम $param';
  }

  @override
  String error_max(String param) {
    return '$param से ज़्यादा नही।';
  }

  @override
  String ifRatingIsPlusMinusX(String param) {
    return 'अगर स्तर $param ऊपर निचे हो तब';
  }

  @override
  String get ifRegistered => 'अगर पंजीकृत है';

  @override
  String get onlyExistingConversations => 'केवल मौजूदा वार्तालाप';

  @override
  String get onlyFriends => 'केवल दोस्त';

  @override
  String get menu => 'मेनू';

  @override
  String get castling => 'केस्लिंग';

  @override
  String get whiteCastlingKingside => 'सफ़ेद O-O';

  @override
  String get blackCastlingKingside => 'काला O-O';

  @override
  String tpTimeSpentPlaying(String param) {
    return 'समय व्यतीत : $param';
  }

  @override
  String get watchGames => 'खेल देखें';

  @override
  String tpTimeSpentOnTV(String param) {
    return 'TV पर समय: $param';
  }

  @override
  String get watch => 'देखें';

  @override
  String get videoLibrary => 'वीडियो लाइब्रेरी';

  @override
  String get streamersMenu => 'प्रसारण करता';

  @override
  String get mobileApp => 'मोबाइल ऐप';

  @override
  String get webmasters => 'वेबमास्टर्स';

  @override
  String get about => 'के बारे में';

  @override
  String aboutX(String param) {
    return '$param के बारे में';
  }

  @override
  String xIsAFreeYLibreOpenSourceChessServer(String param1, String param2) {
    return '$param1 एक मुफ्त ($param2), स्वतंत्र, विज्ञापनों से मुक्त, खुला स्रोत, शतरंज सर्वर है।';
  }

  @override
  String get really => 'सचमुच';

  @override
  String get contribute => 'सहयोग करें';

  @override
  String get termsOfService => 'नियम और शर्तें';

  @override
  String get sourceCode => 'सोर्स कोड';

  @override
  String get simultaneousExhibitions => 'एकसमयी प्रदर्शनी';

  @override
  String get host => 'मेजबानी  करें';

  @override
  String hostColorX(String param) {
    return 'मेजबान रंग: $param';
  }

  @override
  String get yourPendingSimuls => 'Your pending simuls';

  @override
  String get createdSimuls => 'नयें सिमुल';

  @override
  String get hostANewSimul => 'एक नए सिमुल की मेजबानी  करें';

  @override
  String get signUpToHostOrJoinASimul => 'Sign up to host or join a simul';

  @override
  String get noSimulFound => 'सिमुल नहीं मिला';

  @override
  String get noSimulExplanation => 'यह एकसमयी प्रदर्शनी मौजूद नहीं है';

  @override
  String get returnToSimulHomepage => 'सिमुल के मुख्य पृष्ठ पर जाए';

  @override
  String get aboutSimul => 'सिमुल मैं एक खिलाडी अनेक खिलाडियों के विरुद्थ होता है';

  @override
  String get aboutSimulImage => 'पचास प्रतिद्वंदियों में से फिशर ने सैंतालिश खेल जीते, एक बराबरी पर खत्म हुआ और एक हारा।';

  @override
  String get aboutSimulRealLife => 'यह कांसेप्ट असली दुनिया की घटनाओं से लिया गया है। असली जिंदगी मैं सिमुल का मेजबान एक टेबल से दूसरी टेबल जाकर हर एक चाल चलता है।';

  @override
  String get aboutSimulRules => 'जब सिमुल आरम्भ होता है तब हर खिलाडी एक खेल आरम्भ करता है  जिसे सफ़ेद खेलने को दिया जाता है। सिमुल तब समाप्त हो जाता है जब सारे खेलों का अंत हो जाता है।';

  @override
  String get aboutSimulSettings => 'सिमुल हमेशा आकाशमिक होते हैं। फिर से खेलना, चाल वापस लेना और अधिक समय प्रदान करने के विकलब बंद होते हैं।';

  @override
  String get create => 'बनाएं';

  @override
  String get whenCreateSimul => 'जब आप सिमुल बनाते हैं तो आपको कई खिलाडियों के साथ एक साथ खेलने का मौका मिलता है';

  @override
  String get simulVariantsHint => 'अगर आप कई सारे रूपांतर लेते हैं तो हर खिलाडी को यह चुनने का हक़ होती है की वो क्या खेले';

  @override
  String get simulClockHint => 'फिशर क्लॉक सेटअप। आप जितने ज्यादा खिलाडी लेंगे, उतना आपको अधिक समय की आव्यशकता होगी।';

  @override
  String get simulAddExtraTime => 'सिमुल का सामना करने के लिए आप अपनी घडी में अतिरिक्त समय जोड़ सकते हैं';

  @override
  String get simulHostExtraTime => 'अतिरिक्त समय की मेजबानी करें';

  @override
  String get simulAddExtraTimePerPlayer => 'Add initial time to your clock for each player joining the simul.';

  @override
  String get simulHostExtraTimePerPlayer => 'Host extra clock time per player';

  @override
  String get lichessTournaments => 'lichess की प्रतियोगिताएं';

  @override
  String get tournamentFAQ => 'अखाडा प्रतियोगिता के बारे में कई बार पूछे गए  सवाल';

  @override
  String get timeBeforeTournamentStarts => 'प्रतियोगिता के आरंभ होने में समय';

  @override
  String get averageCentipawnLoss => 'सामान्य हार गया';

  @override
  String get accuracy => 'Accuracy';

  @override
  String get keyboardShortcuts => 'किबोर्ड के शार्टकट';

  @override
  String get keyMoveBackwardOrForward => 'आगे खेले पीछे करे';

  @override
  String get keyGoToStartOrEnd => 'शुरूआत मे हिलाए';

  @override
  String get keyCycleSelectedVariation => 'Cycle selected variation';

  @override
  String get keyShowOrHideComments => 'टिपण्णी दिखाएँ/छिपाएँ';

  @override
  String get keyEnterOrExitVariation => 'अंदर बाहर करे';

  @override
  String get keyRequestComputerAnalysis => 'कंप्यूटर विश्लेषण का अनुरोध करें, अपनी गलतियों से सीखें';

  @override
  String get keyNextLearnFromYourMistakes => 'आगे (अपनी गलतियों से सीखें)';

  @override
  String get keyNextBlunder => 'अगली बड़ी गलती';

  @override
  String get keyNextMistake => 'अगली गलती';

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
  String get newTournament => 'नया टूर्नमेंट बनायें';

  @override
  String get tournamentHomeTitle => 'शतरंज का टूर्नमेंट, अलग अलग खेल समय और प्रकार के साथ';

  @override
  String get tournamentHomeDescription => 'तेज़ रफ़्तार वाले शतरंज टूर्नमेंट खेलिए! आधिकारिक अन्यूसशीट टूर्नमेंट मे भाग लें, या खुद का टूर्नमेंट बनायें! Bullet, Blitz, Classical, Chess960, King of the Hill, Threecheck और अधिक प्रकार के मज़ेदार शतरंज के किस्म खेलिए!';

  @override
  String get tournamentNotFound => 'टूर्नामेंट नहीं मिला';

  @override
  String get tournamentDoesNotExist => 'यह टूर्नामेंट मौजूद नहीं है।';

  @override
  String get tournamentMayHaveBeenCanceled => 'टूर्नमेंट रद्द् हो गया होगा, अगर सभी खिलाड़ी टूर्नमेंट शुरू होने से पहले चले तौंरमेंट छोड़ चुके है';

  @override
  String get returnToTournamentsHomepage => 'वापिस लौटें';

  @override
  String weeklyPerfTypeRatingDistribution(String param) {
    return 'इस हफ्ते का $param रेटिंग वितरण';
  }

  @override
  String yourPerfTypeRatingIsRating(String param1, String param2) {
    return 'आपकी $param1 रेटिंग $param2 है';
  }

  @override
  String youAreBetterThanPercentOfPerfTypePlayers(String param1, String param2) {
    return 'आप $param1 खेलने वालो से बेहतर हो, $param2 मे';
  }

  @override
  String userIsBetterThanPercentOfPerfTypePlayers(String param1, String param2, String param3) {
    return '$param1 $param2 $param3 खेलने वालों से बेहतर है';
  }

  @override
  String betterThanPercentPlayers(String param1, String param2) {
    return 'आप $param1 $param2 खिलाडी से बेहतर है';
  }

  @override
  String youDoNotHaveAnEstablishedPerfTypeRating(String param) {
    return 'आपके पास स्थापित $param रेटिंग नहीं है';
  }

  @override
  String get yourRating => 'आपकी रेटिंग';

  @override
  String get cumulative => 'संचयी';

  @override
  String get glicko2Rating => 'Glicko-2 रेटिंग';

  @override
  String get checkYourEmail => 'अपना ई-मेल  देखें';

  @override
  String get weHaveSentYouAnEmailClickTheLink => 'हम आपको एक ईमेल भेज दिया है। अपने खाते को सक्रिय करने के लिए ईमेल में लिंक पर क्लिक करें।';

  @override
  String get ifYouDoNotSeeTheEmailCheckOtherPlaces => 'आप ईमेल नहीं देखते हैं, तो अन्य स्थानों पर यह हो सकता है, आपकी कबाड़, स्पैम, सामाजिक, या अन्य फ़ोल्डर की तरह की जाँच करें।';

  @override
  String weHaveSentYouAnEmailTo(String param) {
    return 'हम$param के लिए एक ईमेल भेज दिया है। अपना पासवर्ड रीसेट करने के लिए ईमेल में लिंक पर क्लिक करें।';
  }

  @override
  String byRegisteringYouAgreeToBeBoundByOur(String param) {
    return 'दर्ज करके, आप हमारे $param द्वारा बाध्य होने के लिए सहमत हैं।';
  }

  @override
  String readAboutOur(String param) {
    return 'हमारे$param के बारे में पढ़ें।';
  }

  @override
  String get networkLagBetweenYouAndLichess => 'आप और lichess के बीच नेटवर्क के अंतराल';

  @override
  String get timeToProcessAMoveOnLichessServer => 'Lichess सर्वर पर एक कदम प्रक्रिया के लिए समय';

  @override
  String get downloadAnnotated => 'एनोटेट नीचे लादें';

  @override
  String get downloadRaw => 'कच्चा नीचे लादें';

  @override
  String get downloadImported => 'डाउनलोड आयातित';

  @override
  String get crosstable => 'विजय और पराजय का अभिलेख';

  @override
  String get youCanAlsoScrollOverTheBoardToMoveInTheGame => 'आप खेल में जाने के लिए बोर्ड पर भी स्क्रॉल कर सकते हैं।';

  @override
  String get scrollOverComputerVariationsToPreviewThem => 'कंप्युटर द्वारा इस स्थिति के विभिन्न रूपांतरण को देखने के लिए चिन्हित करें';

  @override
  String get analysisShapesHowTo => 'बोर्ड पर मंडलियां और तीरों को आकर्षित करने के लिए shift + click या right-click दबाएं';

  @override
  String get letOtherPlayersMessageYou => 'अन्य खिलाड़ियों को आपको संदेश देने दें';

  @override
  String get receiveForumNotifications => 'जब आपके नाम का ज़िक्र हो तब नोटिफ़िकेशन पाएँ';

  @override
  String get shareYourInsightsData => 'अपने इनसाइट डेटा साझा करें';

  @override
  String get withNobody => 'किसी के साथ नहीं';

  @override
  String get withFriends => 'दोस्तों के साथ';

  @override
  String get withEverybody => 'सभी के साथ';

  @override
  String get kidMode => 'बच्चा मोड';

  @override
  String get kidModeIsEnabled => 'किड मोड सक्षम है';

  @override
  String get kidModeExplanation => 'यह सुरक्षा के बारे में है। बच्चे मोड में, सभी साइट संचार अक्षम हैं। यह अपने बच्चों के लिए सक्षम और स्कूल के छात्रों उन्हें अन्य इंटरनेट उपयोगकर्ताओं से सुरक्षित करने के लिए।';

  @override
  String inKidModeTheLichessLogoGetsIconX(String param) {
    return 'बच्चे के मोड में, lichess लोगो को $param आइकन मिलता है, इसलिए आप जानते हैं कि आपके बच्चे सुरक्षित हैं';
  }

  @override
  String get askYourChessTeacherAboutLiftingKidMode => 'Your account is managed. Ask your chess teacher about lifting kid mode.';

  @override
  String get enableKidMode => 'बच्चे मोड को सक्षम करें';

  @override
  String get disableKidMode => 'बच्चे मोड अक्षम करें';

  @override
  String get security => 'सुरक्षा';

  @override
  String get sessions => 'सत्र';

  @override
  String get revokeAllSessions => 'सभी सत्र रद्द';

  @override
  String get playChessEverywhere => 'हर जगह शतरंज खेलें';

  @override
  String get asFreeAsLichess => 'Lichess जैसा मुक्त';

  @override
  String get builtForTheLoveOfChessNotMoney => 'शतरंज के प्यार के लिए निर्मित, धन के लिए नहीं';

  @override
  String get everybodyGetsAllFeaturesForFree => 'हर कोई मुफ्त में सभी सुविधाओं प्राप्त करता है';

  @override
  String get zeroAdvertisement => 'शून्य विज्ञापन';

  @override
  String get fullFeatured => 'पूरा विशेष रुप से प्रदर्शित';

  @override
  String get phoneAndTablet => 'फोन और टैबलेट';

  @override
  String get bulletBlitzClassical => 'बुलेट, ब्लिट्ज, क्लासिकल';

  @override
  String get correspondenceChess => 'पत्राचार शतरंज';

  @override
  String get onlineAndOfflinePlay => 'ऑनलाइन और ऑफ़लाइन खेलने के लिए';

  @override
  String get viewTheSolution => 'समाधान देखें';

  @override
  String get followAndChallengeFriends => 'अपने दोस्तों को चुनौती';

  @override
  String get gameAnalysis => 'खेल अध्ययन';

  @override
  String xHostsY(String param1, String param2) {
    return '$param1 मेजबान $param2';
  }

  @override
  String xJoinsY(String param1, String param2) {
    return '$param1 मेजबान $param2';
  }

  @override
  String xLikesY(String param1, String param2) {
    return '$param1 ने $param2 पसंद किया:';
  }

  @override
  String get quickPairing => 'त्वरित युग्मन';

  @override
  String get lobby => 'लॉबी';

  @override
  String get anonymous => 'अज्ञात';

  @override
  String yourScore(String param) {
    return 'आपका स्कोर: $param';
  }

  @override
  String get language => 'भाषा';

  @override
  String get background => 'पृष्ठभूमि';

  @override
  String get light => 'हल्का';

  @override
  String get dark => 'काला';

  @override
  String get transparent => 'पारदर्शी';

  @override
  String get deviceTheme => 'Device theme';

  @override
  String get backgroundImageUrl => 'पृष्ठभूमि छवि URL:';

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
  String get pieceSet => 'मोहरे';

  @override
  String get embedInYourWebsite => 'अपनी वेबसाइट में एम्बेड करें';

  @override
  String get usernameAlreadyUsed => 'यह उपयोगकर्ता नाम पहले से उपयोग में है, कृपया एक दूसरे का प्रयास करें।';

  @override
  String get usernamePrefixInvalid => 'जो नाम आप उपयोग करते, वह किसी अक्षर से शुरू होना चाहिए।';

  @override
  String get usernameSuffixInvalid => 'जो नाम आप उपयोग करते, वह किसी अक्षर या संख्या के साथ समाप्त होना चाहिए ।';

  @override
  String get usernameCharsInvalid => 'जो नाम आप उपयोग करते, उनमें सिर्फ पत्र, संख्या, अंडरस्कोर और हाइफ़न होना चाहिए ।';

  @override
  String get usernameUnacceptable => 'यह उपयोगकर्ता नाम स्वीकार्य नहीं है।';

  @override
  String get playChessInStyle => 'शैली में शतरंज खेलें';

  @override
  String get chessBasics => 'शतरंज मूल बातें';

  @override
  String get coaches => 'कोच';

  @override
  String get invalidPgn => 'अमान्य PGN';

  @override
  String get invalidFen => 'अमान्य FEN';

  @override
  String get custom => 'कस्टम';

  @override
  String get notifications => 'सूचनाएँ';

  @override
  String notificationsX(String param1) {
    return 'Notifications: $param1';
  }

  @override
  String perfRatingX(String param) {
    return 'रेटिंग: $param';
  }

  @override
  String get practiceWithComputer => 'कंप्यूटर के साथ अभ्यास';

  @override
  String anotherWasX(String param) {
    return '$param भी अच्छे कदम थे';
  }

  @override
  String bestWasX(String param) {
    return 'सर्वश्रेष्ठ चाल $param थे';
  }

  @override
  String get youBrowsedAway => 'आप किसी और वेबसाइट को गया';

  @override
  String get resumePractice => 'अभ्यास जारी रखें';

  @override
  String get drawByFiftyMoves => 'खेल पचास चाल नियम की वजह से बराबरी में ख़त्म हुआ है.';

  @override
  String get theGameIsADraw => 'खेल ड्रॉ है ।';

  @override
  String get computerThinking => 'कंप्यूटर सोच...';

  @override
  String get seeBestMove => 'सर्वश्रेष्ठ चाल देखें';

  @override
  String get hideBestMove => 'सर्वश्रेष्ठ चाल छिपाएं';

  @override
  String get getAHint => 'एक संकेत प्राप्त करें';

  @override
  String get evaluatingYourMove => 'कंप्यूटर आपके कदम का मूल्यांकन कर रहे हैं..';

  @override
  String get whiteWinsGame => 'सफेद जीत';

  @override
  String get blackWinsGame => 'काला विजयी';

  @override
  String get learnFromYourMistakes => 'अपनी ग़लतियाँ से सीखें';

  @override
  String get learnFromThisMistake => 'इस ग़लती से सीखें';

  @override
  String get skipThisMove => 'इस चाल को छोड़ें';

  @override
  String get next => 'अगला';

  @override
  String xWasPlayed(String param) {
    return '$param खेला गया';
  }

  @override
  String get findBetterMoveForWhite => 'सफेद के लिए एक बेहतर कदम का पता लगाएं';

  @override
  String get findBetterMoveForBlack => 'काले के लिए एक बेहतर कदम खोजें';

  @override
  String get resumeLearning => 'सीखना जारी रखें';

  @override
  String get youCanDoBetter => 'आप बेहतर कर सकते हैं';

  @override
  String get tryAnotherMoveForWhite => 'सफ़ेद के लिए एक और चाल आज़माएं';

  @override
  String get tryAnotherMoveForBlack => 'काले के लिए एक और कदम की कोशिश';

  @override
  String get solution => 'समाधान';

  @override
  String get waitingForAnalysis => 'विश्लेषण के लिए प्रतीक्षा';

  @override
  String get noMistakesFoundForWhite => 'श्वेता के लिए नहीं मिली कोई ग़लतियाँ';

  @override
  String get noMistakesFoundForBlack => 'सफ़ेद पहलू ने ग़लती नहीं किया';

  @override
  String get doneReviewingWhiteMistakes => 'सफ़ेद पहलू की ग़लती को पूरी तरह समज लिया';

  @override
  String get doneReviewingBlackMistakes => 'काला पहलू की ग़लती को पूरी तरह समज लिया';

  @override
  String get doItAgain => 'इसे फिर से करो';

  @override
  String get reviewWhiteMistakes => 'सफ़ेद पहलू के ग़लती को देखें';

  @override
  String get reviewBlackMistakes => 'काला पहलू के ग़लती को देखें';

  @override
  String get advantage => 'लाभ';

  @override
  String get opening => 'ओपनिंग';

  @override
  String get middlegame => 'मिडलगेम';

  @override
  String get endgame => 'एंडगेम';

  @override
  String get conditionalPremoves => 'सक्रिय कदम';

  @override
  String get addCurrentVariation => 'इन कदमों को शामिल करें';

  @override
  String get playVariationToCreateConditionalPremoves => 'आपके सक्रिय कदमों का अनुक्रम करो, जैसे आप खेल में प्रयोग करेंगे';

  @override
  String get noConditionalPremoves => 'सक्रिय कदम का अवश्य नहीं है';

  @override
  String playX(String param) {
    return '$param खेलें';
  }

  @override
  String get showUnreadLichessMessage => 'You have received a private message from Lichess.';

  @override
  String get clickHereToReadIt => 'Click here to read it';

  @override
  String get sorry => 'खेद :(';

  @override
  String get weHadToTimeYouOutForAWhile => 'हमें आपको कुछ समय के लिए प्रतिबंधित करना पड़ा।';

  @override
  String get why => 'क्यों?';

  @override
  String get pleasantChessExperience => 'हम सभी के लिए एक सुखद शतरंज अनुभव प्रदान करना चाहते हैं।';

  @override
  String get goodPractice => 'इसलिए, हमें यह सुनिश्चित करना होगा कि सभी खिलाड़ी अच्छे अभ्यास का पालन करें।';

  @override
  String get potentialProblem => 'जब एक संभावित समस्या का पता चलता है, हम इस संदेश को प्रदर्शित करते हैं।';

  @override
  String get howToAvoidThis => 'इससे कैसे बचा जाए?';

  @override
  String get playEveryGame => 'आप शुरू करे हुए हर खेल को खेलें।';

  @override
  String get tryToWin => 'आपके द्वारा खेले जाने वाले हर खेल को जीतने की कोशिश करें। (या कम से कम खेल ड्रा करें)।';

  @override
  String get resignLostGames => 'हारे हुए खेलों को त्याग दें (घड़ी को अंत तक न चलने दें)।';

  @override
  String get temporaryInconvenience => 'हमें अल्पकालिक असुविधा के लिए खेद है';

  @override
  String get wishYouGreatGames => 'और lichess.org पर आपको अनेक शानदार खेलों की शुभकामनाएं।';

  @override
  String get thankYouForReading => 'पढ़ने के लिए धन्यवाद!';

  @override
  String get lifetimeScore => 'जीवनकाल स्कोर';

  @override
  String get currentMatchScore => 'वर्तमान मैच का स्कोर';

  @override
  String get agreementAssistance => 'मैं मानता हूं कि मुझे अपने खेल के दौरान (शतरंज के कंप्यूटर, पुस्तक, डेटाबेस या किसी अन्य व्यक्ति से) सहायता प्राप्त नहीं होगी।';

  @override
  String get agreementNice => 'मैं इस बात से सहमत हूं कि मैं हमेशा अन्य खिलाड़ियों के प्रति सम्मानजनक रहूंगा।';

  @override
  String agreementMultipleAccounts(String param) {
    return 'मैं मानता हूं कि मैं एकाधिक खाते नहीं बना सकता ($param में बताए गए कारणों को छोड़कर)।';
  }

  @override
  String get agreementPolicy => 'मैं इस बात से सहमत हूं कि मैं सभी Lichess नीतियों का पालन करूंगा।';

  @override
  String get searchOrStartNewDiscussion => 'खोजे या नया वार्तालाप आरम्भ करें';

  @override
  String get edit => 'संशोधन करें';

  @override
  String get bullet => 'Bullet';

  @override
  String get blitz => 'Blitz';

  @override
  String get rapid => 'रैपिड';

  @override
  String get classical => 'क्लॅसिकल';

  @override
  String get ultraBulletDesc => 'बेहद तेज खेल: 30 सेकंड से कम';

  @override
  String get bulletDesc => 'बहुत तेज खेल: 3 मिनट से कम';

  @override
  String get blitzDesc => 'तेज खेल: 3 से 8 मिनट';

  @override
  String get rapidDesc => 'रैपिड गेम्स: 8 से 25 मिनट';

  @override
  String get classicalDesc => 'क्लॅसिकल खेल: 25 मिनट और अधिक';

  @override
  String get correspondenceDesc => 'पत्राचार खेल: एक या कई दिन प्रति चाल';

  @override
  String get puzzleDesc => 'शतरंज की रणनीति के प्रशिक्षक';

  @override
  String get important => 'जरूरी';

  @override
  String yourQuestionMayHaveBeenAnswered(String param1) {
    return 'आपके प्रश्न में पहले से ही एक उत्तर $param1 हो सकता है';
  }

  @override
  String get inTheFAQ => 'F.A.Q. मे';

  @override
  String toReportSomeoneForCheatingOrBadBehavior(String param1) {
    return 'उपयोगकर्ता को धोखा देने या बुरे व्यवहार के लिए रिपोर्ट करने के लिए,$param1';
  }

  @override
  String get useTheReportForm => 'रिपोर्ट फॉर्म का उपयोग करें';

  @override
  String toRequestSupport(String param1) {
    return 'समर्थन का अनुरोध करने के लिए,$param1';
  }

  @override
  String get tryTheContactPage => 'संपर्क पृष्ठ का प्रयास करें';

  @override
  String makeSureToRead(String param1) {
    return 'पढ़ना ना भुलें $param1';
  }

  @override
  String get theForumEtiquette => 'the forum etiquette';

  @override
  String get thisTopicIsArchived => 'इस विषय को संग्रहीत किया गया है और अब इसका उत्तर नहीं दिया जा सकता है।';

  @override
  String joinTheTeamXToPost(String param1) {
    return 'इस फ़ोरम में पोस्ट करने के लिए$param1 से जुड़ें';
  }

  @override
  String teamNamedX(String param1) {
    return '$param1 टीम';
  }

  @override
  String get youCannotPostYetPlaySomeGames => 'आप अभी तक फ़ोरम में पोस्ट नहीं कर सकते। कुछ गेम्स खेलें!';

  @override
  String get subscribe => 'सदस्यता लें';

  @override
  String get unsubscribe => 'सदस्यता रद्द करें';

  @override
  String mentionedYouInX(String param1) {
    return 'आपने \"$param1\" में उल्लेख किया है।';
  }

  @override
  String xMentionedYouInY(String param1, String param2) {
    return '$param1 ने \"$param2\" में आपका उल्लेख किया।';
  }

  @override
  String invitedYouToX(String param1) {
    return 'आपको \"$param1\" के लिए आमंत्रित किया गया है।';
  }

  @override
  String xInvitedYouToY(String param1, String param2) {
    return '$param1 ने आपको \"$param2\" के लिए आमंत्रित किया।';
  }

  @override
  String get youAreNowPartOfTeam => 'अब आप टीम का हिस्सा हैं।';

  @override
  String youHaveJoinedTeamX(String param1) {
    return 'आप \"$param1\" में शामिल हो गए हैं।';
  }

  @override
  String get someoneYouReportedWasBanned => 'आपके द्वारा सूचित किसी पर प्रतिबंध लगा दिया गया था';

  @override
  String get congratsYouWon => 'बधाई हो, आप जीत गए!';

  @override
  String gameVsX(String param1) {
    return 'खेल बनाम $param1';
  }

  @override
  String resVsX(String param1, String param2) {
    return '$param1 बनाम $param2';
  }

  @override
  String get lostAgainstTOSViolator => 'आप Lichess TOS का उल्लंघन करने वाले व्यक्ति से हार गए';

  @override
  String refundXpointsTimeControlY(String param1, String param2) {
    return '$param1 $param2 वापसी की';
  }

  @override
  String get timeAlmostUp => 'समय लगभग समाप्त है!';

  @override
  String get clickToRevealEmailAddress => '[ईमेल देखने के लिए क्लिक करें]';

  @override
  String get download => 'डाउनलोड करें';

  @override
  String get coachManager => 'कोच मनेजर';

  @override
  String get streamerManager => 'स्ट्रीमर मैनेजर';

  @override
  String get cancelTournament => 'टूर्नामेंट रद्द करें';

  @override
  String get tournDescription => 'टूर्नामेंट विवरण';

  @override
  String get tournDescriptionHelp => 'क्या आप प्रतिभागियों को कोई विशेष बात बताना चाहते हैं? संक्षिप्त में कहें।मार्क्डाउन लिंक्स उपलब्ध हैं: [name](https://url)';

  @override
  String get ratedFormHelp => 'खेल मूल्यांकित हैं तथा खिलाड़ी के मूल्यांकन को प्रभावित करते हैं';

  @override
  String get onlyMembersOfTeam => 'केवल टीम के सदस्य';

  @override
  String get noRestriction => 'अप्रतिबंधित';

  @override
  String get minimumRatedGames => 'न्यूनतम मूल्यांकित खेलों की संख्या';

  @override
  String get minimumRating => 'न्यूनतम मूल्यांकन';

  @override
  String get maximumWeeklyRating => 'न्यूनतम साप्ताहिक मूल्यांकन';

  @override
  String positionInputHelp(String param) {
    return 'किसी निर्धारित स्थिति से खेल आरंभ करने के लिए एक वैध FEN डालें।\nयह केवल मूल खेलों के लिए काम करता है, रूपांतरण के साथ नहीं।\nआप $param का प्रयोग FEN स्थिति को प्राप्त करने के लिए कर सकते हैं फिर उसे यहाँ डाल दीजिए।\nप्रारम्भिक स्थिति से खेल को शुरू करने के लिए इसे रिक्त छोड़ दें।';
  }

  @override
  String get cancelSimul => 'समकालिक खेल को निरस्त करें';

  @override
  String get simulHostcolor => 'प्रत्येक खेल के लिए मेजबान के मोहरों का रंग';

  @override
  String get estimatedStart => 'अनुमानित प्रारंभ समय';

  @override
  String simulFeatured(String param) {
    return '$param पर प्रस्तुत';
  }

  @override
  String simulFeaturedHelp(String param) {
    return '$param पर अपने समकालिक खेल को प्रदर्शित करें। निजी समकालिक खेलों के लिए निष्क्रिय।';
  }

  @override
  String get simulDescription => 'समकालिक खेल का विवरण';

  @override
  String get simulDescriptionHelp => 'क्या आप प्रतिभागियों को कुछ बताना चाहते हैं?';

  @override
  String markdownAvailable(String param) {
    return '$param अत्याधुनिक स्वरूपण के लिए उपलब्ध है।';
  }

  @override
  String get embedsAvailable => 'खेल अथवा अध्ययन का URL paste करे एमबेड करने के लिये|';

  @override
  String get inYourLocalTimezone => 'आपके अपने क्षेत्रीय समयानुसार';

  @override
  String get tournChat => 'प्रतियोगिता वार्ता';

  @override
  String get noChat => 'वार्ता निषेध';

  @override
  String get onlyTeamLeaders => 'केवल टीम नेता';

  @override
  String get onlyTeamMembers => 'केवल टीम सदस्य';

  @override
  String get navigateMoveTree => 'चालों की सूची पर जाएं';

  @override
  String get mouseTricks => 'माउस की तरकीबें';

  @override
  String get toggleLocalAnalysis => 'स्थानीय कंप्युटर विश्लेषण';

  @override
  String get toggleAllAnalysis => 'सभी कंप्यूटर विश्लेषण टॉगल करें';

  @override
  String get playComputerMove => 'कंप्युटर की सर्वश्रेष्ठ चाल चलें';

  @override
  String get analysisOptions => 'विश्लेषण विकल्प';

  @override
  String get focusChat => 'फोकस चैट';

  @override
  String get showHelpDialog => 'सहायता संवाद दर्शायें';

  @override
  String get reopenYourAccount => 'अपना खाता पुनः खोलें।';

  @override
  String get closedAccountChangedMind => 'अगर आपने अपना खाता बंद कर दिया था, लेकिन अब आपने मन बदल लिया है, तो आपको अपना खाता वापस पाने का एक अवसर मिलता है।';

  @override
  String get onlyWorksOnce => 'यह केवल एक बार काम करेगा।';

  @override
  String get cantDoThisTwice => 'अगर आपने दूसरी बार अपना खाता बंद किया, तो उसे वापस पाने का कोई रास्ता नहीं होगा।';

  @override
  String get emailAssociatedToaccount => 'खाते से संबंधित ईमेल पता';

  @override
  String get sentEmailWithLink => 'हमने आपको लिंक के साथ एक ईमेल भेजा है।';

  @override
  String get tournamentEntryCode => 'प्रतियोगिता प्रवेश कोड';

  @override
  String get hangOn => 'प्रतिक्षा कीजीए।';

  @override
  String gameInProgress(String param) {
    return '$param के साथ आपका खेल समाप्त नही हुआ है।';
  }

  @override
  String get abortTheGame => 'खेल रद्द करें';

  @override
  String get resignTheGame => 'हार मान ले';

  @override
  String get youCantStartNewGame => 'जब तक यह गेम समाप्त नहीं हो जाता तब तक आप एक नया गेम शुरू नहीं कर सकते।';

  @override
  String get since => 'दिनांक से';

  @override
  String get until => 'दिनांक तक​';

  @override
  String get lichessDbExplanation => 'मुल्यांकित खेल Lichess के सभी खिलाड़ियो से';

  @override
  String get switchSides => 'पार्श्व बदलना';

  @override
  String get closingAccountWithdrawAppeal => 'आपका खाता बंद करने से आपकी अपील वापस ले ली जाएगी';

  @override
  String get ourEventTips => 'कार्यक्रम आयोजित करने कि सलाह';

  @override
  String get instructions => 'Instructions';

  @override
  String get showMeEverything => 'Show me everything';

  @override
  String get lichessPatronInfo => 'Lichess एक चैरिटी और पूरी तरह से फ्री/लिबर ओपन सोर्स सॉफ्टवेयर है।\nसभी परिचालन लागत, विकास और सामग्री पूरी तरह से उपयोगकर्ता दान द्वारा वित्त पोषित हैं।';

  @override
  String get nothingToSeeHere => 'Nothing to see here at the moment.';

  @override
  String opponentLeftCounter(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'आपके प्रतिद्वंद्वी ने खेल छोड़ दिया। आप $count सेकंड में जीत का दावा कर सकते हैं।',
      one: 'आपके प्रतिद्वंद्वी ने खेल छोड़ दिया। आप $count सेकंड में जीत का दावा कर सकते हैं।',
    );
    return '$_temp0';
  }

  @override
  String mateInXHalfMoves(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count आधे-कदम में चेकमैट',
      one: '$count हाफ मूव में मेट',
    );
    return '$_temp0';
  }

  @override
  String nbBlunders(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count गंभीर गल्तियां',
      one: '$count गंभीर गलती',
    );
    return '$_temp0';
  }

  @override
  String nbMistakes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count गलतियाँ',
      one: '$count ग़लती',
    );
    return '$_temp0';
  }

  @override
  String nbInaccuracies(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count अशुद्धियाँ',
      one: '$count अशुद्धि',
    );
    return '$_temp0';
  }

  @override
  String nbPlayers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count खिलाड़ी',
      one: '$count खिलाड़ी',
    );
    return '$_temp0';
  }

  @override
  String nbGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count खेल',
      one: '$count खेल',
    );
    return '$_temp0';
  }

  @override
  String ratingXOverYGames(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count खेलों में $param2 रेटिंग',
      one: '$count खेलों में $param2 रेटिंग',
    );
    return '$_temp0';
  }

  @override
  String nbBookmarks(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count पृष्ठ स्मृतियाँ',
      one: '$count पृष्ठ स्मृतियाँ',
    );
    return '$_temp0';
  }

  @override
  String nbDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count दिन',
      one: '$count दिन',
    );
    return '$_temp0';
  }

  @override
  String nbHours(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count घंटे',
      one: '$count घंटे',
    );
    return '$_temp0';
  }

  @override
  String nbMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count मिनट',
      one: '$count मिनट',
    );
    return '$_temp0';
  }

  @override
  String rankIsUpdatedEveryNbMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'पद को हर $count मिनटों में अपडेट किया जाता है',
      one: 'पद को हर मिनटों में अपडेट किया जाता है',
    );
    return '$_temp0';
  }

  @override
  String nbPuzzles(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count पहेली',
      one: '$count पहेली',
    );
    return '$_temp0';
  }

  @override
  String nbGamesWithYou(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'आपके साथ $count खेल',
      one: 'आपके साथ $count खेल',
    );
    return '$_temp0';
  }

  @override
  String nbRated(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count रेटेड खेल',
      one: '$count रेटेड खेल',
    );
    return '$_temp0';
  }

  @override
  String nbWins(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count जीत',
      one: '$count जीत',
    );
    return '$_temp0';
  }

  @override
  String nbLosses(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count हार',
      one: '$count हार',
    );
    return '$_temp0';
  }

  @override
  String nbDraws(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count खेल बराबरी पे समाप्त',
      one: '$count खेल बराबरी पे समाप्त',
    );
    return '$_temp0';
  }

  @override
  String nbPlaying(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count खेल रहा है',
      one: '$count खेल रहा है',
    );
    return '$_temp0';
  }

  @override
  String giveNbSeconds(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count सेकंड्स दें',
      one: '$count सेकंड्स दें',
    );
    return '$_temp0';
  }

  @override
  String nbTournamentPoints(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count टूर्नामेंट अंक',
      one: '$count टूर्नामेंट अंक',
    );
    return '$_temp0';
  }

  @override
  String nbStudies(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count अध्ययन',
      one: '$count अध्ययन',
    );
    return '$_temp0';
  }

  @override
  String nbSimuls(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count सिमुल्स',
      one: '$count सिमुल',
    );
    return '$_temp0';
  }

  @override
  String moreThanNbRatedGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '≥ $count रेटेड खेल',
      one: '≥ $count रेटेड खेल',
    );
    return '$_temp0';
  }

  @override
  String moreThanNbPerfRatedGames(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '≥ $count $param2 रेटेड खेल',
      one: '≥ $count $param2 रेटेड खेल',
    );
    return '$_temp0';
  }

  @override
  String needNbMorePerfGames(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'आपको $count और $param2 रेटेड खेल खेलने की आवश्यकता है।',
      one: 'आपको $count और $param2 रेटेड खेल खेलने की आवश्यकता है।',
    );
    return '$_temp0';
  }

  @override
  String needNbMoreGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'आपको $count और खेल में भाग लेने की आवश्यकता है',
      one: 'आपको $count और खेल में भाग लेने की आवश्यकता है',
    );
    return '$_temp0';
  }

  @override
  String nbImportedGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count खेल आयत (इम्पोर्ट) किये गए',
      one: '$count खेल आयत (इम्पोर्ट) किये गए',
    );
    return '$_temp0';
  }

  @override
  String nbFriendsOnline(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count दोस्त ऑनलाइन',
      one: '$count मित्र ऑनलाइन',
    );
    return '$_temp0';
  }

  @override
  String nbFollowers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count अनुसरणकर्ता',
      one: '$count अनुसरणकर्ता',
    );
    return '$_temp0';
  }

  @override
  String nbFollowing(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count अनुगामी',
      one: '$count अनुगामी',
    );
    return '$_temp0';
  }

  @override
  String lessThanNbMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count मिनट से कम',
      one: '$count मिनट से कम',
    );
    return '$_temp0';
  }

  @override
  String nbGamesInPlay(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count खेल खेले जा रहे है',
      one: '$count खेल खेले जा रहे है',
    );
    return '$_temp0';
  }

  @override
  String maximumNbCharacters(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'अधिकतम $count अक्षर|',
      one: 'अधिकतम $count अक्षर|',
    );
    return '$_temp0';
  }

  @override
  String blocks(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count  अवस्र्द्ध (ब्लॉक)',
      one: '$count  अवस्र्द्ध (ब्लॉक)',
    );
    return '$_temp0';
  }

  @override
  String nbForumPosts(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count जनसभा (फोरम) ब्योरे (पोस्ट्स)',
      one: '$count जनसभा (फोरम) ब्योरे (पोस्ट्स)',
    );
    return '$_temp0';
  }

  @override
  String nbPerfTypePlayersThisWeek(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count $param2 खिलाड़ी इस सप्ताह।',
      one: '$count $param2 खिलाड़ी इस सप्ताह।',
    );
    return '$_temp0';
  }

  @override
  String availableInNbLanguages(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count भाषाओं में उपलब्ध है !',
      one: '$count भाषाओं में उपलब्ध है !',
    );
    return '$_temp0';
  }

  @override
  String nbSecondsToPlayTheFirstMove(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count सेकंड का समय पहला चाल के लिए',
      one: '$count सेकंड का समय पहला चाल के लिए',
    );
    return '$_temp0';
  }

  @override
  String nbSeconds(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count सेकंड',
      one: '$count सेकंड',
    );
    return '$_temp0';
  }

  @override
  String andSaveNbPremoveLines(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'बाद में $count सक्रिय कदम को बचाओ',
      one: 'बाद में $count सक्रिय कदम को बचाओ',
    );
    return '$_temp0';
  }

  @override
  String get stormMoveToStart => 'शुरू करने के लिए एक चाल खेलें।';

  @override
  String get stormYouPlayTheWhitePiecesInAllPuzzles => 'आप सभी पहेली में सफेद शतरंज के मोहरे खेलते हैं';

  @override
  String get stormYouPlayTheBlackPiecesInAllPuzzles => 'आप सभी पहेली में काला शतरंज के मोहरे खेलते हैं';

  @override
  String get stormPuzzlesSolved => 'हल पहेलियों की संख्या';

  @override
  String get stormNewDailyHighscore => 'आज का नया सर्वश्रेष्ठ स्कोर';

  @override
  String get stormNewWeeklyHighscore => 'इस हफ्ते का नया सर्वश्रेष्ठ स्कोर';

  @override
  String get stormNewMonthlyHighscore => 'इस महीने का नया सर्वश्रेष्ठ स्कोर';

  @override
  String get stormNewAllTimeHighscore => 'अब तक का सर्वश्रेष्ठ स्कोर';

  @override
  String stormPreviousHighscoreWasX(String param) {
    return 'पुराना सर्वश्रेष्ठ स्कोर $param था';
  }

  @override
  String get stormPlayAgain => 'फिर से खेलेंगे?';

  @override
  String stormHighscoreX(String param) {
    return 'सर्वश्रेष्ठ स्कोर: $param';
  }

  @override
  String get stormScore => 'स्कोर';

  @override
  String get stormMoves => 'चाल';

  @override
  String get stormAccuracy => 'शुद्धता';

  @override
  String get stormCombo => 'कॉम्बो';

  @override
  String get stormTime => 'समय';

  @override
  String get stormTimePerMove => 'समय प्रति चाल';

  @override
  String get stormHighestSolved => 'सबसे ऊंचा हल';

  @override
  String get stormPuzzlesPlayed => 'पहेलियां खेलीं';

  @override
  String get stormNewRun => 'नया रन (हॉटकी: स्पेस)';

  @override
  String get stormEndRun => 'अंत रन (हॉटकी: दर्ज करें)';

  @override
  String get stormHighscores => 'उच्च स्कोर';

  @override
  String get stormViewBestRuns => 'सर्वश्रेष्ठ रन देखें';

  @override
  String get stormBestRunOfDay => 'दिन का सर्वश्रेष्ठ रन';

  @override
  String get stormRuns => 'रन';

  @override
  String get stormGetReady => 'तैयार हो जाओ!';

  @override
  String get stormWaitingForMorePlayers => 'अधिक खिलाड़ियों के शामिल होने का इंतजार...';

  @override
  String get stormRaceComplete => 'रेस पूरी!';

  @override
  String get stormSpectating => 'दर्शकों';

  @override
  String get stormJoinTheRace => 'दौड़ में शामिल हों!';

  @override
  String get stormStartTheRace => 'Start the race';

  @override
  String stormYourRankX(String param) {
    return 'आपकी रैंक: $param';
  }

  @override
  String get stormWaitForRematch => 'रीमैच के लिए प्रतीक्षा करें';

  @override
  String get stormNextRace => 'अगली दौड़';

  @override
  String get stormJoinRematch => 'रीमैच में शामिल हों';

  @override
  String get stormWaitingToStart => 'प्रारंभ होने की प्रतीक्षा में';

  @override
  String get stormCreateNewGame => 'नया गेम बनाएं';

  @override
  String get stormJoinPublicRace => 'एक सार्वजनिक दौड़ में शामिल हों';

  @override
  String get stormRaceYourFriends => 'अपने दोस्तों को रेस';

  @override
  String get stormSkip => 'छोड़ें';

  @override
  String get stormSkipHelp => 'आप प्रति रेस एक चाल को छोड़ सकते हैं:';

  @override
  String get stormSkipExplanation => 'अपने कॉम्बो को संरक्षित करने के लिए इस कदम को छोड़ दें! केवल एक बार रेस के अनुसार काम करता है।';

  @override
  String get stormFailedPuzzles => 'Failed puzzles';

  @override
  String get stormSlowPuzzles => 'Slow puzzles';

  @override
  String get stormSkippedPuzzle => 'Skipped puzzle';

  @override
  String get stormThisWeek => 'इस सप्ताह';

  @override
  String get stormThisMonth => 'इस महीने';

  @override
  String get stormAllTime => 'सब समय';

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
      other: '$count रन',
      one: 'एक प्रयास',
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
  String get streamerLichessStreamers => 'लिचेस स्ट्रीमर';

  @override
  String get studyShareAndExport => 'शेयर & एक्सपोर्ट करें';

  @override
  String get studyStart => 'शुरू करिए';
}
