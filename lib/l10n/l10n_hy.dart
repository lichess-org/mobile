import 'package:intl/intl.dart' as intl;

import 'l10n.dart';

/// The translations for Armenian (`hy`).
class AppLocalizationsHy extends AppLocalizations {
  AppLocalizationsHy([String locale = 'hy']) : super(locale);

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
  String get activityActivity => 'Գործունեություն';

  @override
  String get activityHostedALiveStream => 'Անցկացվել է ուղիղ միացում';

  @override
  String activityRankedInSwissTournament(String param1, String param2) {
    return 'Վարկանիշը ≥ $param1 $param2-ում';
  }

  @override
  String get activitySignedUp => 'Գրանցում lichess.org-ում';

  @override
  String activitySupportedNbMonths(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Supported lichess.org for $count months as a $param2',
      one: 'Supported lichess.org for $count month as a $param2',
    );
    return '$_temp0';
  }

  @override
  String activityPracticedNbPositions(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Practised $count positions on $param2',
      one: 'Practised $count position on $param2',
    );
    return '$_temp0';
  }

  @override
  String activitySolvedNbPuzzles(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Լուծվել է $count տակտիկական գլուխկոտրուկ',
      one: 'Լուծվել է $count տակտիկական գլուխկոտրուկ',
    );
    return '$_temp0';
  }

  @override
  String activityPlayedNbGames(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Played $count $param2 games',
      one: 'Played $count $param2 game',
    );
    return '$_temp0';
  }

  @override
  String activityPostedNbMessages(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Posted $count messages in $param2',
      one: 'Posted $count message in $param2',
    );
    return '$_temp0';
  }

  @override
  String activityPlayedNbMoves(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Կատարված է $count քայլ',
      one: 'Կատարված է $count քայլ',
    );
    return '$_temp0';
  }

  @override
  String activityInNbCorrespondenceGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'նամակագրությամբ $count խաղում',
      one: 'նամակագրությամբ $count խաղում',
    );
    return '$_temp0';
  }

  @override
  String activityCompletedNbGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Ավարտված է նամակագրությամբ $count խաղ',
      one: 'Ավարտված է նամակագրությամբ $count խաղ',
    );
    return '$_temp0';
  }

  @override
  String activityFollowedNbPlayers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Started following $count players',
      one: 'Started following $count player',
    );
    return '$_temp0';
  }

  @override
  String activityGainedNbFollowers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Gained $count new followers',
      one: 'Gained $count new follower',
    );
    return '$_temp0';
  }

  @override
  String activityHostedNbSimuls(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Hosted $count simultaneous exhibitions',
      one: 'Hosted $count simultaneous exhibition',
    );
    return '$_temp0';
  }

  @override
  String activityJoinedNbSimuls(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Participated in $count simultaneous exhibitions',
      one: 'Participated in $count simultaneous exhibition',
    );
    return '$_temp0';
  }

  @override
  String activityCreatedNbStudies(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Ստեղծվել են $count նոր ստուդիաներ',
      one: 'Ստեղծվել է $count նոր ստուդիա',
    );
    return '$_temp0';
  }

  @override
  String activityCompetedInNbTournaments(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Ավարտված են $count «Արենա» մրցաշարերը',
      one: 'Ավարտված է $count «Արենա» մրցաշարը',
    );
    return '$_temp0';
  }

  @override
  String activityRankedInTournament(int count, String param2, String param3, String param4) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count տեղ ($param2 % լավագույն)՝ $param4 մրցաշարում $param3 խաղերի արդյունքով',
      one: '$count տեղ ($param2 % լավագույն)՝ $param4 մրցաշարում $param3 խաղերի արդյունքով',
    );
    return '$_temp0';
  }

  @override
  String activityCompetedInNbSwissTournaments(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Competed in $count Swiss tournaments',
      one: 'Competed in $count Swiss tournament',
    );
    return '$_temp0';
  }

  @override
  String activityJoinedNbTeams(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Ընդունվել է $count թիմ',
      one: 'Ընդունվել է $count թիմ',
    );
    return '$_temp0';
  }

  @override
  String get broadcastBroadcasts => 'Հեռարձակումներ';

  @override
  String get broadcastLiveBroadcasts => 'Մրցաշարի ուղիղ հեռարձակումներ';

  @override
  String challengeChallengesX(String param1) {
    return 'Մարտահրավերներ: $param1';
  }

  @override
  String get challengeChallengeToPlay => 'Ուղարկել խաղի մարտահրավեր';

  @override
  String get challengeChallengeDeclined => 'Մարտահրավերը մերժված է';

  @override
  String get challengeChallengeAccepted => 'Մարտահրավերն ընդունված է';

  @override
  String get challengeChallengeCanceled => 'Մարտահրավերը կասեցված է';

  @override
  String get challengeRegisterToSendChallenges => 'Գրանցվեք՝ մրցակիցներին խաղի հրավիրելու համար։';

  @override
  String challengeYouCannotChallengeX(String param) {
    return 'Դուք չեք կարող խաղին հրավիրել $param-ին։';
  }

  @override
  String challengeXDoesNotAcceptChallenges(String param) {
    return '$param-ը չի ընդունում մարտահրավերները։';
  }

  @override
  String challengeYourXRatingIsTooFarFromY(String param1, String param2) {
    return 'Ձեր $param1 վարկանիշը շատ հեռու է $param2-ից։';
  }

  @override
  String challengeCannotChallengeDueToProvisionalXRating(String param) {
    return 'Հնարավոր չէ հրավիրել խաղի՝ $param վարկանիշի անհավաստիության պատճառով։';
  }

  @override
  String challengeXOnlyAcceptsChallengesFromFriends(String param) {
    return '$param-ն մարտահրավերներ է ընդունում միայն ընկերներից։';
  }

  @override
  String get challengeDeclineGeneric => 'Այս պահին մարտահրավերներ չեմ ընդունում։';

  @override
  String get challengeDeclineLater => 'Այս պահին մարտահրավերներ չեմ ընդունում, խնդրում եմ, հրավիրեք ինձ ավելի ուշ։';

  @override
  String get challengeDeclineTooFast => 'Այդ ժամակարգն ինձ համար շատ արագ է, խնդրում եմ, հրավիրեք ինձ ավելի երկար ժամակարգով խաղի։';

  @override
  String get challengeDeclineTooSlow => 'Այդ ժամակարգն ինձ համար շատ դանդաղ է, խնդրում եմ, հրավիրեք ինձ ավելի կարճ ժամակարգով խաղի։';

  @override
  String get challengeDeclineTimeControl => 'Այդպիսի ժամակարգով մարտահրավերներ չեմ ընդունում։';

  @override
  String get challengeDeclineRated => 'Հրավիրեք ինձ վարկանիշային խաղի, խնդրում եմ։';

  @override
  String get challengeDeclineCasual => 'Հրավիրեք ինձ ընկերական խաղի, խնդրում եմ։';

  @override
  String get challengeDeclineStandard => 'Ես չեմ ընդունում ոչ դասական շախմատի մարտահրավերներ հենց հիմա։';

  @override
  String get challengeDeclineVariant => 'Ես չեմ ցանկանում շախմատի այս տարբերակը խաղալ հիմա։';

  @override
  String get challengeDeclineNoBot => 'Ես չեմ ընդունում բոտերի մարտահրավերները։';

  @override
  String get challengeDeclineOnlyBot => 'Ես ընդունում եմ միայն բոտերի մարտահրավերները։';

  @override
  String get challengeInviteLichessUser => 'Կամ հրավիրեք Lichess-ի օգտատիրոջ.';

  @override
  String get contactContact => 'Կոնտակտներ';

  @override
  String get contactContactLichess => 'Lichess-ի կոնտակտներ';

  @override
  String get patronDonate => 'Նվիրաբերել';

  @override
  String get patronLichessPatron => 'Lichess-ի հովանավոր';

  @override
  String perfStatPerfStats(String param) {
    return '$param վիճակագրություն';
  }

  @override
  String get perfStatViewTheGames => 'Դիտել պարտիաները';

  @override
  String get perfStatProvisional => 'նախնական';

  @override
  String get perfStatNotEnoughRatedGames => 'Ճշգրիտ վարկանիշն իմանալու համար վարկանիշային պարտիաների քանակը բավարար չէ։';

  @override
  String perfStatProgressOverLastXGames(String param) {
    return 'Աճը վերջին $param խաղերի ընթացքում.';
  }

  @override
  String perfStatRatingDeviation(String param) {
    return 'Վարկանիշի շեղումը` $param։';
  }

  @override
  String perfStatRatingDeviationTooltip(String param1, String param2, String param3) {
    return 'Ցածրագույն արժեքը նշանակում է, որ վարկանիշն ավելի կայուն է։ Եթե այդ ցուցանիշը գերազանցում է $param1-ը, ապա վարկանիշը համարվում է մոտավոր։ Վարկանիշի ցանկերում ընդգրկվելու համար այդ ցուցանիշը պետք է փոքր լինի $param2-ից (դասական շախմատ) կամ $param3-ից (տարբերակներ)։';
  }

  @override
  String get perfStatTotalGames => 'Ընդամենը պարտիաներ';

  @override
  String get perfStatRatedGames => 'Վարկանիշային պարտիաներ';

  @override
  String get perfStatTournamentGames => 'Մրցաշարային պարտիաներ';

  @override
  String get perfStatBerserkedGames => 'Բերսերկով պարտիաներ';

  @override
  String get perfStatTimeSpentPlaying => 'Ընդհանուր խաղաժամանակ';

  @override
  String get perfStatAverageOpponent => 'Մրցակիցների միջին վարկանիշը';

  @override
  String get perfStatVictories => 'Հաղթանակներ';

  @override
  String get perfStatDefeats => 'Պարտություններ';

  @override
  String get perfStatDisconnections => 'Անջատումներ';

  @override
  String get perfStatNotEnoughGames => 'Խաղացված պարտիաների քանակն անբավարար է';

  @override
  String perfStatHighestRating(String param) {
    return 'Բարձրագույն վարկանիշ` $param';
  }

  @override
  String perfStatLowestRating(String param) {
    return 'Ցածրագույն վարկանիշ` $param';
  }

  @override
  String perfStatFromXToY(String param1, String param2) {
    return '$param1-ից $param2';
  }

  @override
  String get perfStatWinningStreak => 'Անընդմեջ հաղթանակներ';

  @override
  String get perfStatLosingStreak => 'Անընդմեջ պարտություններ';

  @override
  String perfStatLongestStreak(String param) {
    return 'Ամենաերկար շարքը` $param';
  }

  @override
  String perfStatCurrentStreak(String param) {
    return 'Ընթացիկ շարքը` $param';
  }

  @override
  String get perfStatBestRated => 'Հաղթանակներ ամենաբարձր վարկանիշ ունեցողների նկատմամբ';

  @override
  String get perfStatGamesInARow => 'Անընդմեջ խաղացված պարտիաներ';

  @override
  String get perfStatLessThanOneHour => 'Պարտիաների միջև դադարը` մեկ ժամից պակաս';

  @override
  String get perfStatMaxTimePlaying => 'Առավելագույն խաղաժամանակ';

  @override
  String get perfStatNow => 'հիմա';

  @override
  String get preferencesPreferences => 'Կարգավորումներ';

  @override
  String get preferencesDisplay => 'Ցուցադրել';

  @override
  String get preferencesPrivacy => 'Գաղտնիություն';

  @override
  String get preferencesNotifications => 'Ծանուցումներ';

  @override
  String get preferencesPieceAnimation => 'Խաղաքարերի ձևավորում';

  @override
  String get preferencesMaterialDifference => 'Ցուցադրել նյութական տարբերությունը';

  @override
  String get preferencesBoardHighlights => 'Խաղատախտակի բնութագիր (վերջին քայլը և շախը)';

  @override
  String get preferencesPieceDestinations => 'Ցույց տալ թույլատրելի քայլերը';

  @override
  String get preferencesBoardCoordinates => 'Խաղատախտակի համակարգում (A-H, 1-8)';

  @override
  String get preferencesMoveListWhilePlaying => 'քայլերի ցուցակը խաղի ժամանակ';

  @override
  String get preferencesPgnPieceNotation => 'Շախմատային նոտագրություն';

  @override
  String get preferencesChessPieceSymbol => 'Շախմատային խաղաքարի պատկերանշան';

  @override
  String get preferencesPgnLetter => 'Խաղաքարի տառը (K, Q, R, B, N)';

  @override
  String get preferencesZenMode => 'Ձեն ռեժիմ';

  @override
  String get preferencesShowPlayerRatings => 'Ցուցադրել խաղացողի վարկանիշը';

  @override
  String get preferencesShowFlairs => 'Show player flairs';

  @override
  String get preferencesExplainShowPlayerRatings => 'Հնարավորություն է տալիս թաքցնելու կայքի բոլոր վարկանիշները՝ խաղի վրա կենտրոնանալու համար։ Պարտիաները մնում են վարկանիշային, պարզապես Դուք դա չեք տեսնի։';

  @override
  String get preferencesDisplayBoardResizeHandle => 'Ցույց տալ խաղատախտակի չափսի փոփոխության պատկերագիրը';

  @override
  String get preferencesOnlyOnInitialPosition => 'Միայն սկզբնական դիրքում';

  @override
  String get preferencesInGameOnly => 'Միայն խաղի մեջ';

  @override
  String get preferencesChessClock => 'շախմատի ժամացույց';

  @override
  String get preferencesTenthsOfSeconds => 'ցուցադրել վայրկյանները';

  @override
  String get preferencesWhenTimeRemainingLessThanTenSeconds => 'Երբ ժամանակը մնացել է <10 վայրկյան';

  @override
  String get preferencesHorizontalGreenProgressBars => 'Հորիզոնական կանաչ գծով';

  @override
  String get preferencesSoundWhenTimeGetsCritical => 'ձայնով, երբ ժամանակը վերջանում է';

  @override
  String get preferencesGiveMoreTime => 'Ավելացնել ժամանակ';

  @override
  String get preferencesGameBehavior => 'Խաղի կարգավորումներ';

  @override
  String get preferencesHowDoYouMovePieces => 'Ինչպե՞ս տեղաշարժել խաղաքարերը։';

  @override
  String get preferencesClickTwoSquares => 'Երկու վանդակները սեղմելով';

  @override
  String get preferencesDragPiece => 'Խաղաքարը տեղափոխելով';

  @override
  String get preferencesBothClicksAndDrag => 'Երկուսն էլ';

  @override
  String get preferencesPremovesPlayingDuringOpponentTurn => 'Նախնական քայլ (քանի դեռ մրցակիցը մտածում է)';

  @override
  String get preferencesTakebacksWithOpponentApproval => 'քայլը հետ վերցնելու առաջարկ (հակառակորդի թույլտվությամբ)';

  @override
  String get preferencesInCasualGamesOnly => 'Միայն ընկերական խաղերում';

  @override
  String get preferencesPromoteToQueenAutomatically => 'Ավտոմատ փոխակերպվել թագուհու';

  @override
  String get preferencesExplainPromoteToQueenAutomatically => 'Hold the <ctrl> key while promoting to temporarily disable auto-promotion';

  @override
  String get preferencesWhenPremoving => 'Նախաքայլ անելիս';

  @override
  String get preferencesClaimDrawOnThreefoldRepetitionAutomatically => 'Քայլերի եռակի կրկնության դեպքում ինքնաբերաբար պահանջել ոչ-ոքի';

  @override
  String get preferencesWhenTimeRemainingLessThanThirtySeconds => 'Երբ մնում է < 30 վայրկյանից քիչ';

  @override
  String get preferencesMoveConfirmation => 'Քայլի հաստատում';

  @override
  String get preferencesExplainCanThenBeTemporarilyDisabled => 'Can be disabled during a game with the board menu';

  @override
  String get preferencesInCorrespondenceGames => 'Նամակագրական խաղեր';

  @override
  String get preferencesCorrespondenceAndUnlimited => 'Նամակագրական և առանց ժամանակի սահմանափակման';

  @override
  String get preferencesConfirmResignationAndDrawOffers => 'Հաստատել պարտությունը և ոչ-ոքիի առաջարկը';

  @override
  String get preferencesCastleByMovingTheKingTwoSquaresOrOntoTheRook => 'Փոխատեղման եղանակը';

  @override
  String get preferencesCastleByMovingTwoSquares => 'Արքան տեղափոխել երկու վանդակ';

  @override
  String get preferencesCastleByMovingOntoTheRook => 'Արքան տեղափոխել նավակի վրա';

  @override
  String get preferencesInputMovesWithTheKeyboard => 'Քայլերը մուտքագրել ստեղնաշարով';

  @override
  String get preferencesInputMovesWithVoice => 'Քայլերի ներմուծումը ձայնի միջոցով';

  @override
  String get preferencesSnapArrowsToValidMoves => 'Սլաքներով ցույց տալ միայն թույլատրելի քայլերը';

  @override
  String get preferencesSayGgWpAfterLosingOrDrawing => 'Պարտությունից կամ ոչ-ոքիից հետո զրուցարանում գրել. «Good game, well played»';

  @override
  String get preferencesYourPreferencesHaveBeenSaved => 'Ձեր նախընտրությունները պահպանված են';

  @override
  String get preferencesScrollOnTheBoardToReplayMoves => 'Քայլերը դիտելու համար մկնիկի անիվը պտտեք խաղատախտակի վրա';

  @override
  String get preferencesCorrespondenceEmailNotification => 'Daily email listing your correspondence games';

  @override
  String get preferencesNotifyStreamStart => 'Streamer goes live';

  @override
  String get preferencesNotifyInboxMsg => 'New inbox message';

  @override
  String get preferencesNotifyForumMention => 'Forum comment mentions you';

  @override
  String get preferencesNotifyInvitedStudy => 'Ստուդիայի հրավեր';

  @override
  String get preferencesNotifyGameEvent => 'Նամակագրական խաղին առնչվող թարմացումներ';

  @override
  String get preferencesNotifyChallenge => 'Challenges';

  @override
  String get preferencesNotifyTournamentSoon => 'Մրցաշարը շուտով կսկսվի';

  @override
  String get preferencesNotifyTimeAlarm => 'Նամակագրական խաղում ժամանակը շուտով կսպառվի';

  @override
  String get preferencesNotifyBell => 'Lichess-ի ձայնային տեղեկացում';

  @override
  String get preferencesNotifyPush => 'Device notification when you\'re not on Lichess';

  @override
  String get preferencesNotifyWeb => 'Դիտարկիչ';

  @override
  String get preferencesNotifyDevice => 'Սարք';

  @override
  String get preferencesBellNotificationSound => 'Ծանուցումների զանգակի ձայնը';

  @override
  String get puzzlePuzzles => 'Խնդիրներ';

  @override
  String get puzzlePuzzleThemes => 'Խնդիրների թեմաներ';

  @override
  String get puzzleRecommended => 'Խորհուրդ է տրվում';

  @override
  String get puzzlePhases => 'Խաղի փուլեր';

  @override
  String get puzzleMotifs => 'Մոտիվներ';

  @override
  String get puzzleAdvanced => 'Առաջադեմ';

  @override
  String get puzzleLengths => 'Քայլերի քանակը';

  @override
  String get puzzleMates => 'Մատեր';

  @override
  String get puzzleGoals => 'Նպատակներ';

  @override
  String get puzzleOrigin => 'Պարտիաներից';

  @override
  String get puzzleSpecialMoves => 'Հատուկ քայլեր';

  @override
  String get puzzleDidYouLikeThisPuzzle => 'Հավանեցի՞ք խնդիրը։';

  @override
  String get puzzleVoteToLoadNextOne => 'Քվեարկե՛ք և անցե՛ք հաջորդին։';

  @override
  String get puzzleUpVote => 'Խնդիրը հավանեցի';

  @override
  String get puzzleDownVote => 'Խնդիրը չհավանեցի';

  @override
  String get puzzleYourPuzzleRatingWillNotChange => 'Խնդիրներ լուծելու Ձեր վարկանիշը չի փոփոխվի։ Խնդիրների լուծումը մրցություն չէ։ Վարկանիշը հնարավորություն է տալիս ավելի լավ ընտրել խնդիրները ըստ Ձեր մակարդակի։';

  @override
  String get puzzleFindTheBestMoveForWhite => 'Գտե՛ք սպիտակների լավագույն քայլը։';

  @override
  String get puzzleFindTheBestMoveForBlack => 'Գտե՛ք սևերի լավագույն քայլը։';

  @override
  String get puzzleToGetPersonalizedPuzzles => 'Անհատական խնդիրներ ստանալու համար.';

  @override
  String puzzlePuzzleId(String param) {
    return 'Խնդիր № $param';
  }

  @override
  String get puzzlePuzzleOfTheDay => 'Օրվա խնդիրը';

  @override
  String get puzzleDailyPuzzle => 'Ամենօրյա Խնդիր';

  @override
  String get puzzleClickToSolve => 'Սեղմեք լուծելու համար';

  @override
  String get puzzleGoodMove => 'Լավ քայլ է';

  @override
  String get puzzleBestMove => 'Լավագո՛ւյն քայլը';

  @override
  String get puzzleKeepGoing => 'Շարունակեք…';

  @override
  String get puzzlePuzzleSuccess => 'Խնդիրը լուծված է';

  @override
  String get puzzlePuzzleComplete => 'Խնդիրը լուծված է';

  @override
  String get puzzleByOpenings => 'Ըստ դեբյուտների';

  @override
  String get puzzlePuzzlesByOpenings => 'Դեբյուտային խնդիրներ';

  @override
  String get puzzleOpeningsYouPlayedTheMost => 'Դեբյուտներ, որոնք դուք խաղացել եք վարկանիշային կուսակցությունների մեծ մասում';

  @override
  String get puzzleUseFindInPage => 'Օգտագործեք \"Գտել էջում \" զննարկչի ընտրացանկում՝ ձեր նախընտրած դեբյուտը գտնելու՛ համար:';

  @override
  String get puzzleUseCtrlF => 'Օգտագործեք Ctrl + f ՝ Ձեր նախընտրած դեբյուտը գտնելու՛ համար։';

  @override
  String get puzzleNotTheMove => 'Վատ քայլ է';

  @override
  String get puzzleTrySomethingElse => 'Փորձեք այլ կերպ։';

  @override
  String puzzleRatingX(String param) {
    return 'Վարկանիշ՝ $param';
  }

  @override
  String get puzzleHidden => 'թաքցրած է';

  @override
  String puzzleFromGameLink(String param) {
    return '$param պարտիայից';
  }

  @override
  String get puzzleContinueTraining => 'Շարունակել մարզումը';

  @override
  String get puzzleDifficultyLevel => 'Բարդության մակարդակը';

  @override
  String get puzzleNormal => 'Միջին';

  @override
  String get puzzleEasier => 'Հեշտ';

  @override
  String get puzzleEasiest => 'Շատ հեշտ';

  @override
  String get puzzleHarder => 'Բարդ';

  @override
  String get puzzleHardest => 'Շատ բարդ';

  @override
  String get puzzleExample => 'Օրինակ';

  @override
  String get puzzleAddAnotherTheme => 'Ավելացնել այլ մոտիվ';

  @override
  String get puzzleNextPuzzle => 'Հաջորդ խնդիրը';

  @override
  String get puzzleJumpToNextPuzzleImmediately => 'Անմիջապես անցնել հաջորդ խնդրին';

  @override
  String get puzzlePuzzleDashboard => 'Խնդիրների վահանակ';

  @override
  String get puzzleImprovementAreas => 'Թույլ կողմեր';

  @override
  String get puzzleStrengths => 'Ուժեղ կողմեր';

  @override
  String get puzzleHistory => 'Խնդիրների պատմություն';

  @override
  String get puzzleSolved => 'լուծված';

  @override
  String get puzzleFailed => 'անհաջող';

  @override
  String get puzzleStreakDescription => 'Լուծե՛ք աստիճանաբար բարդացող խնդիրները և ստեղծե՛ք հաղթական շարք։ Այստեղ չկա ժամացույց, այնպես որ՝ մի՛ շտապեք։ Մեկ անհաջող քայլ, և խաղն ավարտված է։ Բայց մեկ խաղաշարի ընթացքում կարելի է բաց թողնել մեկ քայլ։';

  @override
  String puzzleYourStreakX(String param) {
    return 'Ձեր շարքը՝ $param';
  }

  @override
  String get puzzleStreakSkipExplanation => 'Բաց թողնել այս քայլը՝ շարքը պահպանելու համար։ Կարելի է օգտագործել միայն մեկ անգամ։';

  @override
  String get puzzleContinueTheStreak => 'Շարունակել շարքը';

  @override
  String get puzzleNewStreak => 'Նոր շարք';

  @override
  String get puzzleFromMyGames => 'Իմ պարտիաներից';

  @override
  String get puzzleLookupOfPlayer => 'Փնտրել խնդիրներ խաղացողի պարտիաներից';

  @override
  String puzzleFromXGames(String param) {
    return 'Խնդիրներ $param-ի պարտիաներից';
  }

  @override
  String get puzzleSearchPuzzles => 'Փնտրել խնդիրներ';

  @override
  String get puzzleFromMyGamesNone => 'Տվյալների բազայում Ձեր պարտիաներից խնդիրներ չկան, բայց Lichess-ը Ձեզ հետ հույսեր է կապում։ Խաղացե՛ք ավելի շատ արագ կամ դասական ժամակարգով պարտիաներ, և խնդիրներ ունեցող խաղացողների ցանկում հայտնվելու Ձեր հնարավորությունները կմեծանան։';

  @override
  String puzzleFromXGamesFound(String param1, String param2) {
    return 'Գտնվել է $param1 խնդիր $param2 պարտիաներում';
  }

  @override
  String get puzzlePuzzleDashboardDescription => 'Մարզվե՛ք, վերլուծե՛ք, բարելավե՛ք';

  @override
  String puzzlePercentSolved(String param) {
    return '$param ճիշտ է';
  }

  @override
  String get puzzleNoPuzzlesToShow => 'Ոչինչ չկա, սկսելու համար լուծե՛ք մի քանի խնդիր։';

  @override
  String get puzzleImprovementAreasDescription => 'Մարզե՛ք այս թեմաները՝ Ձեր առաջընթացը բարելավելու համար։';

  @override
  String get puzzleStrengthDescription => 'Դուք ցուցադրում եք լավագույն արդյունքները այս թեմաներում';

  @override
  String puzzlePlayedXTimes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Փորձել են լուծել $count անգամ',
      one: 'Փորձել են լուծել $count անգամ',
    );
    return '$_temp0';
  }

  @override
  String puzzleNbPointsBelowYourPuzzleRating(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count միավոր ցածր՝ խնդիրների լուծման Ձեր վարկանիշից',
      one: 'Մեկ միավոր ցածր՝ խնդիրների լուծման Ձեր վարկանիշից',
    );
    return '$_temp0';
  }

  @override
  String puzzleNbPointsAboveYourPuzzleRating(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count միավոր բարձր խնդիրների լուծման Ձեր վարկանիշից',
      one: 'Մեկ միավոր բարձր խնդիրների լուծման Ձեր վարկանիշից',
    );
    return '$_temp0';
  }

  @override
  String puzzleNbPlayed(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count լուծված է',
      one: '$count լուծված Է',
    );
    return '$_temp0';
  }

  @override
  String puzzleNbToReplay(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count կրկնել',
      one: '$count կրկնել',
    );
    return '$_temp0';
  }

  @override
  String get puzzleThemeAdvancedPawn => 'Առաջ գնացած զինվոր';

  @override
  String get puzzleThemeAdvancedPawnDescription => 'Զինվորը վերածվելու կամ զինվորը վերածվելու սպառնալիքի հետ կապված մարտավարություն։';

  @override
  String get puzzleThemeAdvantage => 'Առավելություն';

  @override
  String get puzzleThemeAdvantageDescription => 'Օգտագործեք որոշիչ առավելություն ստանալու Ձեր հնարավորությունը (200-ից 600 սանտիզինվոր)';

  @override
  String get puzzleThemeAnastasiaMate => 'Անաստասիայի մատ';

  @override
  String get puzzleThemeAnastasiaMateDescription => 'Ձին և նավակը (կամ թագուհին) մրցակցի արքային մատ են անում խաղատախտակի եզրի և մրցակցի այլ խաղաքարի միջև։';

  @override
  String get puzzleThemeArabianMate => 'Արաբական մատ';

  @override
  String get puzzleThemeArabianMateDescription => 'Ձին և նավակը մրցակցի արքային մատ են անում խաղատախտակի անկյունում։';

  @override
  String get puzzleThemeAttackingF2F7 => 'Գրոհ f2-ի կամ f7-ի վրա';

  @override
  String get puzzleThemeAttackingF2F7Description => 'f2 կամ f7 զինվորների վրա ուղղված գրոհ, օրինակ, Ֆեգատելլոյի գրոհում (տապակած լյարդի սկզբնախաղում)։';

  @override
  String get puzzleThemeAttraction => 'Հրապուրում';

  @override
  String get puzzleThemeAttractionDescription => 'Փոխանակում կամ զոհաբերություն, որը ստիպում կամ մղում է մրցակցի խաղաքարին զբաղեցնել դաշտը, որից հետո հնարավոր է դառնում հետագա մարտավարական հնարքը։';

  @override
  String get puzzleThemeBackRankMate => 'Մատ վերջին հորիզոնականում';

  @override
  String get puzzleThemeBackRankMateDescription => 'Մատ արքային նրա իսկ հորիզոնականում, երբ նա շրջափակված է իր իսկ խաղաքարերով։';

  @override
  String get puzzleThemeBishopEndgame => 'Փղային վերջնախաղ';

  @override
  String get puzzleThemeBishopEndgameDescription => 'Միայն փղերով և զինվորներով վերջնախաղ։';

  @override
  String get puzzleThemeBodenMate => 'Բոդենի մատ';

  @override
  String get puzzleThemeBodenMateDescription => 'Խաչվող անկյունագծերում գտնվող երկու փղերը մատ են հայտարարում մրցակցի արքային, որը շրջափակված է սեփական խաղաքարերով։';

  @override
  String get puzzleThemeCastling => 'Փոխատեղում';

  @override
  String get puzzleThemeCastlingDescription => 'Արքայի տեղափոխումն ապահով տեղ և նավակի դուրսբերումը մարտի։';

  @override
  String get puzzleThemeCapturingDefender => 'Պաշտպանի վերացում';

  @override
  String get puzzleThemeCapturingDefenderDescription => 'Այլ խաղաքարը պաշտպանող խաղաքարի շահում կամ փոխանակում՝ հետագայում անպաշտպան մնացած խաղաքարի շահումով։';

  @override
  String get puzzleThemeCrushing => 'Ջախջախում';

  @override
  String get puzzleThemeCrushingDescription => 'Օգտագործեք մրցակցի վրիպումը՝ ջախջախիչ առավելություն (600 և ավելի սանտիզինվոր) ստանալու համար';

  @override
  String get puzzleThemeDoubleBishopMate => 'Մատ երկու փղով';

  @override
  String get puzzleThemeDoubleBishopMateDescription => 'Հարակից անկյունագծերում գտնվող երկու փղերը մատ են հայտարարում մրցակցի արքային, որը շրջափակված է սեփական խաղաքարերով։';

  @override
  String get puzzleThemeDovetailMate => '«Ծիծեռնակի պոչ» մատ';

  @override
  String get puzzleThemeDovetailMateDescription => 'Մատ թագուհով կողքին կանգնած արքային, որի նահանջի միակ երկու դաշտերը զբաղեցնում են սեփական խաղաքարերը։';

  @override
  String get puzzleThemeEquality => 'Հավասարեցում';

  @override
  String get puzzleThemeEqualityDescription => 'Պարտված դիրքից հավասարեցրեք խաղը. պարտիան ավարտեք ոչ-ոքի կամ ստացեք նյութական հավասարություն (200 սանտիզինվորից պակաս)';

  @override
  String get puzzleThemeKingsideAttack => 'Գրոհ արքայական թևում';

  @override
  String get puzzleThemeKingsideAttackDescription => 'Գրոհ մրցակցի՝ կարճ կողմում փոխատեղում կատարած արքայի վրա։';

  @override
  String get puzzleThemeClearance => 'Գծի կամ դաշտի ազատում';

  @override
  String get puzzleThemeClearanceDescription => 'Որպես կանոն, տեմպով կատարվող քայլ, որն ազատում է դաշտը, գիծը կամ անկյունագիծը՝ մարտավարական մտահղացումն իրագործելու նպատակով։';

  @override
  String get puzzleThemeDefensiveMove => 'Պաշտպանական քայլ';

  @override
  String get puzzleThemeDefensiveMoveDescription => 'Ճշգրիտ քայլ կամ քայլերի հաջորդականություն, որոնք անհրաժեշտ են նյութական կամ առավելության կորստից խուսափելու համար։';

  @override
  String get puzzleThemeDeflection => 'Շեղում';

  @override
  String get puzzleThemeDeflectionDescription => 'Քայլ, որը մրցակցի խաղաքարը շեղում է կարևոր խնդրից, օրինակ, հանգուցային դաշտի պաշտպանությունից։';

  @override
  String get puzzleThemeDiscoveredAttack => 'Բացված հարձակում';

  @override
  String get puzzleThemeDiscoveredAttackDescription => 'Քայլ խաղաքարով, որ ծածկում է հեռահար խաղաքարի գրոհի գիծը։ Օրինակ, քայլ ձիով, որով բացվում է գիծը նրա հետևում կանգնած նավակի համար։';

  @override
  String get puzzleThemeDoubleCheck => 'Կրկնակի շախ';

  @override
  String get puzzleThemeDoubleCheckDescription => 'Շախ միաժամանակ երկու խաղաքարով՝ բաց հարձակման միջոցով։ Հնարավոր չէ վերցնել երկու գրոհող խաղաքարերը և հնարավոր չէ ծածկվել դրանցից, հետևաբար արքան կարող է միայն հեռանալ շախից։';

  @override
  String get puzzleThemeEndgame => 'Վերջնախաղ';

  @override
  String get puzzleThemeEndgameDescription => 'Մարտավարություն խաղի վերջնամասում։';

  @override
  String get puzzleThemeEnPassantDescription => 'Մարտավարություն «կողանցիկ հարված» կանոնի կիրառմամբ, որտեղ զինվորը կարող է հարվածել մրցակցի զինվորը, որը առաջին քայլն է կատարել՝ տեղաշարժվելով երկու դաշտ, ընդ որում՝ հատվող դաշտը գտնվում է մրցակցի զինվորի հարվածի տակ, որը կարող է վերցնել այդ զինվորը։';

  @override
  String get puzzleThemeExposedKing => 'Մերկ արքա';

  @override
  String get puzzleThemeExposedKingDescription => 'Անպաշտպան կամ թույլ պաշտպանված արքան հաճախ դառնում է մատային գրոհի զոհը։';

  @override
  String get puzzleThemeFork => 'Պատառաքաղ';

  @override
  String get puzzleThemeForkDescription => 'Քայլ, որի դեպքում հարվածի տակ է հայտնվում մրցակցի երկու խաղաքար։';

  @override
  String get puzzleThemeHangingPiece => 'Անպաշտպան խաղաքար';

  @override
  String get puzzleThemeHangingPieceDescription => 'Մարտավարություն, որի ժամանակ մրցակցի խաղաքարը պաշտպանված չէ կամ լավ պաշտպանված չէ և կարող է վերցվել։';

  @override
  String get puzzleThemeHookMate => 'Հուք մատ';

  @override
  String get puzzleThemeHookMateDescription => 'Մատ զինվորով պաշտպանված ձիով և նավակով, ընդ որում` մրցակցի զինվորներից մեկը զբաղեցնում է նրա արքայի նահանջի միակ դաշտը։';

  @override
  String get puzzleThemeInterference => 'Ծածկում';

  @override
  String get puzzleThemeInterferenceDescription => 'Քայլ, որով ծածկվում է մրցակցի հեռահար խաղաքարերի համագործակցության գիծը, որի արդյունքում այդ խաղաքարերը կամ նրանցից մեկը դառնում են անպաշտպան։ Օրինակ, ձին կանգնում է նավակների միջև գտնվող պաշտպանված վանդակին։';

  @override
  String get puzzleThemeIntermezzo => 'Միջանկյալ քայլ';

  @override
  String get puzzleThemeIntermezzoDescription => 'Սպասելի քայլ կատարելու փոխարեն, սկզբում կատարվում է այլ, անմիջական սպառնալիք ստեղծող քայլ, որին մրցակիցը պետք է պատասխանի։ Հայտնի է նաև  «Zwischenzug» կամ «Intermezzo» անուններով։';

  @override
  String get puzzleThemeKnightEndgame => 'Ձիու վերջնախաղ';

  @override
  String get puzzleThemeKnightEndgameDescription => 'Միայն ձիերով և զինվորներով վերջնախաղ։';

  @override
  String get puzzleThemeLong => 'Եռաքայլ խնդիր';

  @override
  String get puzzleThemeLongDescription => 'Երեք քայլ մինչև հաղթանակ։';

  @override
  String get puzzleThemeMaster => 'Վարպետների պարտիաներ';

  @override
  String get puzzleThemeMasterDescription => 'Խնդիրներ տիտղոսակիր խաղացողների մասնակցությամբ պարտիաներից։';

  @override
  String get puzzleThemeMasterVsMaster => 'Երկու վարպետների պարտիաներ';

  @override
  String get puzzleThemeMasterVsMasterDescription => 'Խնդիրներ երկու տիտղոսակիր խաղացողների մասնակցությամբ պարտիաներից։';

  @override
  String get puzzleThemeMate => 'Մատ';

  @override
  String get puzzleThemeMateDescription => 'Ավարտեք խաղը գեղեցիկ';

  @override
  String get puzzleThemeMateIn1 => 'Մատ 1 քայլից';

  @override
  String get puzzleThemeMateIn1Description => 'Արեք մատ մեկ քայլից։';

  @override
  String get puzzleThemeMateIn2 => 'Մատ 2 քայլից';

  @override
  String get puzzleThemeMateIn2Description => 'Արեք մատ երկու քայլից։';

  @override
  String get puzzleThemeMateIn3 => 'Մատ 3 քայլից';

  @override
  String get puzzleThemeMateIn3Description => 'Արեք մատ երեք քայլից։';

  @override
  String get puzzleThemeMateIn4 => 'Մատ 4 քայլից';

  @override
  String get puzzleThemeMateIn4Description => 'Արեք մատ չորս քայլից։';

  @override
  String get puzzleThemeMateIn5 => 'Մատ 5 և ավելի քայլից';

  @override
  String get puzzleThemeMateIn5Description => 'Գտեք դեպի մատը տանող քայլերի հաջորդականությունը։';

  @override
  String get puzzleThemeMiddlegame => 'Միջնախաղ';

  @override
  String get puzzleThemeMiddlegameDescription => 'Մարտավարություն խաղի երկրորդ փուլում։';

  @override
  String get puzzleThemeOneMove => 'Մեկքայլանի խնդիր';

  @override
  String get puzzleThemeOneMoveDescription => 'Խնդիր, որտեղ պետք է անել միայն մեկ հաղթող քայլ։';

  @override
  String get puzzleThemeOpening => 'Սկզբնախաղ';

  @override
  String get puzzleThemeOpeningDescription => 'Մարտավարություն խաղի առաջին փուլում։';

  @override
  String get puzzleThemePawnEndgame => 'Զինվորային վերջնախաղ';

  @override
  String get puzzleThemePawnEndgameDescription => 'Վերջնախաղ զինվորներով։';

  @override
  String get puzzleThemePin => 'Կապ';

  @override
  String get puzzleThemePinDescription => 'Կապի օգտագործումով մարտավարություն, երբ խաղաքարը չի կարող քայլել, այլապես գրոհի տակ կհայտնվի նրա հետևում գտնվող ավելի արժեքավոր խաղաքարը։';

  @override
  String get puzzleThemePromotion => 'Վերածում';

  @override
  String get puzzleThemePromotionDescription => 'Քայլ, որի ժամանակ զինվորը հասնում է վերջին հորիզոնականին և վերածվում նույն գույնի ցանկացած խաղաքարի, բացի արքայից։';

  @override
  String get puzzleThemeQueenEndgame => 'Թագուհու վերջնախաղ';

  @override
  String get puzzleThemeQueenEndgameDescription => 'Միայն թագուհիներով և զինվորներով վերջնախաղ։';

  @override
  String get puzzleThemeQueenRookEndgame => 'Թագուհով և նավակով վերջնախաղ';

  @override
  String get puzzleThemeQueenRookEndgameDescription => 'Միայն թագուհիներով, նավակներով և զինվորներով վերջնախաղ։';

  @override
  String get puzzleThemeQueensideAttack => 'Գրոհ թագուհու թևում';

  @override
  String get puzzleThemeQueensideAttackDescription => 'Գրոհ մրցակցի՝ երկար կողմում փոխատեղում կատարած արքայի վրա։';

  @override
  String get puzzleThemeQuietMove => 'Հանգիստ քայլ';

  @override
  String get puzzleThemeQuietMoveDescription => 'Քայլ առանց շախի կամ խաղաքար վերցնելու, որն այնուամենայնիվ նախապատրաստում է անխուսափելի սպառնալիք։';

  @override
  String get puzzleThemeRookEndgame => 'Նավակային վերջնախաղ';

  @override
  String get puzzleThemeRookEndgameDescription => 'Միայն նավակներով և զինվորներով վերջնախաղ։';

  @override
  String get puzzleThemeSacrifice => 'Զոհաբերություն';

  @override
  String get puzzleThemeSacrificeDescription => 'Մարտավարություն, որի ժամանակ տրվում է որևէ խաղաքար` առավելություն ստանալու, մատ հայտարարելու կամ պարտիան ոչ-ոքի ավարտելու նպատակով։';

  @override
  String get puzzleThemeShort => 'Երկքայլանի խնդիր';

  @override
  String get puzzleThemeShortDescription => 'Երկու քայլ մինչև հաղթանակ։';

  @override
  String get puzzleThemeSkewer => 'Գծային հարձակում';

  @override
  String get puzzleThemeSkewerDescription => 'Կապի տեսակ է, բայց այս դեպքում հակառակն է՝ ավելի թանկ խաղաքարը հայտնվում է պակաս արժեքավոր կամ համարժեք խաղաքարի գրոհի գծում։';

  @override
  String get puzzleThemeSmotheredMate => 'Խեղդուկ մատ';

  @override
  String get puzzleThemeSmotheredMateDescription => 'Մատ ձիով արքային, որը չի կարող փախչել, որովհետև շրջափակված է (խեղդված է) սեփական խաղաքարերով։';

  @override
  String get puzzleThemeSuperGM => 'Սուպերգրոսմայստերների պարտիաներ';

  @override
  String get puzzleThemeSuperGMDescription => 'Խնդիրներ աշխարհի լավագույն շախմատիստների պարտիաներից։';

  @override
  String get puzzleThemeTrappedPiece => 'Խաղաքարի որսում';

  @override
  String get puzzleThemeTrappedPieceDescription => 'Խաղաքարը չի կարող հեռանալ հարձակումից, քանի որ չունի նահանջի ազատ դաշտեր, կամ այդ դաշտերը ևս հարվածի տակ են։';

  @override
  String get puzzleThemeUnderPromotion => 'Թույլ վերածում';

  @override
  String get puzzleThemeUnderPromotionDescription => 'Զինվորի վերածում ոչ թե թագուհու, այլ ձիու, փղի կամ նավակի։';

  @override
  String get puzzleThemeVeryLong => 'Բազմաքայլ խնդիր';

  @override
  String get puzzleThemeVeryLongDescription => 'Չորս կամ ավելի քայլ հաղթելու համար։';

  @override
  String get puzzleThemeXRayAttack => 'Ռենտգեն';

  @override
  String get puzzleThemeXRayAttackDescription => 'Իրավիճակ, երբ հեռահար խաղաքարի հարձակման կամ պաշտպանության գծին կանգնած է մրցակցի խաղաքարը։';

  @override
  String get puzzleThemeZugzwang => 'Ցուգցվանգ';

  @override
  String get puzzleThemeZugzwangDescription => 'Մրցակիցը ստիպված է անել հնարավոր փոքրաթիվ քայլերից մեկը,  բայց քայլերից ցանկացածը տանում է դիրքի վատացման։';

  @override
  String get puzzleThemeHealthyMix => 'Խառը խնդիրներ';

  @override
  String get puzzleThemeHealthyMixDescription => 'Ամեն ինչից` քիչ-քիչ։ Դուք չգիտեք` ինչ է սպասվում, այնպես որ, պատրաստ եղեք ամեն ինչի։ Ինչպես իսկական պարտիայում։';

  @override
  String get puzzleThemePlayerGames => 'Խաղացողի պարտիաները';

  @override
  String get puzzleThemePlayerGamesDescription => 'Գտնել խնդիրներ, որոնք ստեղծվել են Ձեր պարտիաներից, կամ այլ խաղացողների պարտիաներից։';

  @override
  String puzzleThemePuzzleDownloadInformation(String param) {
    return 'Այս խնդիրները հանրության սեփականությունն են, և Դուք կարող եք ներբեռնել դրանք՝ $param։';
  }

  @override
  String get searchSearch => 'Փնտրել';

  @override
  String get settingsSettings => 'Կարգավորումներ';

  @override
  String get settingsCloseAccount => 'Փակել հաշիվը';

  @override
  String get settingsManagedAccountCannotBeClosed => 'Ձեր հաշիվը կառավարվում է և չի կարող փակվել։';

  @override
  String get settingsClosingIsDefinitive => 'Փակումը հնարավոր չի լինի չեղարկել։ Համոզվա՞ծ եք։';

  @override
  String get settingsCantOpenSimilarAccount => 'Դուք չեք կարողանա ստեղծել նույն անունով մասնակցային հաշիվ, նույնիսկ եթե տառաշարերը (մեծատառ-փոքրատառ) տարբերվեն։';

  @override
  String get settingsChangedMindDoNotCloseAccount => 'Ես մտափոխվել եմ, մի փակեք իմ հաշիվը';

  @override
  String get settingsCloseAccountExplanation => 'Դուք համոզվա՞ծ եք, որ ցանկանում եք փակել Ձեր մասնակցային հաշիվը։ Փակումն անդառնալի է։ Դուք այլևս երբեք չեք կարողանա մուտք գործել Ձեր հաշիվ։';

  @override
  String get settingsThisAccountIsClosed => 'Այս հաշիվը փակված է:';

  @override
  String get playWithAFriend => 'Խաղալ ընկերոջ հետ';

  @override
  String get playWithTheMachine => 'Խաղալ համակարգչի հետ';

  @override
  String get toInviteSomeoneToPlayGiveThisUrl => 'Որևէ մեկին խաղի հրավիրելու համար ուղարկեք ստորև տրված հղումը';

  @override
  String get gameOver => 'Խաղն ավարտված է';

  @override
  String get waitingForOpponent => 'Սպասում եմ հակառակորդին';

  @override
  String get orLetYourOpponentScanQrCode => 'Or let your opponent scan this QR code';

  @override
  String get waiting => 'Սպասում եմ';

  @override
  String get yourTurn => 'Ձեր հերթն է';

  @override
  String aiNameLevelAiLevel(String param1, String param2) {
    return '$param1, մակարդակ՝ $param2';
  }

  @override
  String get level => 'Մակարդակ';

  @override
  String get strength => 'Ուժ';

  @override
  String get toggleTheChat => 'Թաքցնել/ցուցադրել զրուցարանը';

  @override
  String get chat => 'Զրուցարան';

  @override
  String get resign => 'Հանձնվել';

  @override
  String get checkmate => 'Շախ և մատ';

  @override
  String get stalemate => 'Պատ';

  @override
  String get white => 'Սպիտակներ';

  @override
  String get black => 'Սևեր';

  @override
  String get asWhite => 'սպիտակների կողմից';

  @override
  String get asBlack => 'սևերի կողմից';

  @override
  String get randomColor => 'Կամայական գույն';

  @override
  String get createAGame => 'Ստեղծել նոր խաղ';

  @override
  String get whiteIsVictorious => 'Սպիտակները հաղթեցին';

  @override
  String get blackIsVictorious => 'Սևերը հաղթեցին';

  @override
  String get youPlayTheWhitePieces => 'Դուք խաղում եք սպիտակ խաղաքարերով։';

  @override
  String get youPlayTheBlackPieces => 'Դուք խաղում եք սև խաղաքարերով։';

  @override
  String get itsYourTurn => 'Ձեր Քայլն է!';

  @override
  String get cheatDetected => 'Հայտնաբերվել է խարդախություն';

  @override
  String get kingInTheCenter => 'Արքան կենտրոնում է';

  @override
  String get threeChecks => 'Երեք շախ';

  @override
  String get raceFinished => 'Մրցավազքը ավարտվեց';

  @override
  String get variantEnding => 'Տարբերակի ավարտ';

  @override
  String get newOpponent => 'Գտնել նոր հակառակորդ';

  @override
  String get yourOpponentWantsToPlayANewGameWithYou => 'Ձեր հակառակորդը ուզում է կրկին խաղալ Ձեզ հետ';

  @override
  String get joinTheGame => 'Միանալ խաղին';

  @override
  String get whitePlays => 'Խաղում են սպիտակները';

  @override
  String get blackPlays => 'Խաղում են սևերը';

  @override
  String get opponentLeftChoices => 'Հակառակորդը լքել է խաղը։ Դուք կարող եք պահանջել հաղթանակ, ոչ-ոքի կամ սպասել։';

  @override
  String get forceResignation => 'Պահանջել հաղթանակ';

  @override
  String get forceDraw => 'Պահանջել ոչ-ոքի';

  @override
  String get talkInChat => 'Խնդրում ենք զրուցարանում լինել բարեհամբույր:';

  @override
  String get theFirstPersonToComeOnThisUrlWillPlayWithYou => 'Առաջինը, ով կայցելի այս հղումով, կխաղա Ձեզ հետ։';

  @override
  String get whiteResigned => 'Սպիտակները հանձնվեցին';

  @override
  String get blackResigned => 'Սևերը հանձնվեցին';

  @override
  String get whiteLeftTheGame => 'Սպիտակները լքեցին խաղը';

  @override
  String get blackLeftTheGame => 'Սևերը լքեցին խաղը';

  @override
  String get whiteDidntMove => 'Սպիտակները քայլ չեն կատարել';

  @override
  String get blackDidntMove => 'Սևերը քայլ չեն կատարել';

  @override
  String get requestAComputerAnalysis => 'Համակարգչային վերլուծություն պատվիրել';

  @override
  String get computerAnalysis => 'Համակարգչային վերլուծություն';

  @override
  String get computerAnalysisAvailable => 'Առկա է համակարգչի վերլուծություն';

  @override
  String get computerAnalysisDisabled => 'Համակարգչային վերլուծությունն անջատված է';

  @override
  String get analysis => 'Վերլուծության տախտակ';

  @override
  String depthX(String param) {
    return 'Խորություն $param';
  }

  @override
  String get usingServerAnalysis => 'Օգտագործել սերվերի վերլուծությունը';

  @override
  String get loadingEngine => 'Շարժիչի բեռնում...';

  @override
  String get calculatingMoves => 'Կատարվում է քայլերի հաշվարկ...';

  @override
  String get engineFailed => 'Ծրագիրը բեռնելու սխալ';

  @override
  String get cloudAnalysis => 'Ամպի վերլուծություն';

  @override
  String get goDeeper => 'Ավելի խորանալ';

  @override
  String get showThreat => 'Ցուցադրել սպառնալիքը';

  @override
  String get inLocalBrowser => 'Տեղական բրաուզերում';

  @override
  String get toggleLocalEvaluation => 'Միացնել լոկալ գնահատականը';

  @override
  String get promoteVariation => 'Փոխել տարբերակը';

  @override
  String get makeMainLine => 'Դարձնել հիմնական տարբերակ';

  @override
  String get deleteFromHere => 'Ջնջել այստեղից';

  @override
  String get collapseVariations => 'Collapse variations';

  @override
  String get expandVariations => 'Expand variations';

  @override
  String get forceVariation => 'Պարտադրել վարիացիան';

  @override
  String get copyVariationPgn => 'Copy variation PGN';

  @override
  String get move => 'Քայլ';

  @override
  String get variantLoss => 'Տարբերակը պարտվում է';

  @override
  String get variantWin => 'Տարբերակը հաղթում է';

  @override
  String get insufficientMaterial => 'Առկա նյութը մատի համար բավարար չէ';

  @override
  String get pawnMove => 'Զինվորի քայլ';

  @override
  String get capture => 'Փոխանակում';

  @override
  String get close => 'Փակել';

  @override
  String get winning => 'Հաղթում է';

  @override
  String get losing => 'Պարտվում է';

  @override
  String get drawn => 'Ոչ-ոքիով';

  @override
  String get unknown => 'Անհայտ';

  @override
  String get database => 'Բազա';

  @override
  String get whiteDrawBlack => 'Սպիտակ / Ոչ-ոքի / Սև';

  @override
  String averageRatingX(String param) {
    return 'Միջին վարկանիշ $param';
  }

  @override
  String get recentGames => 'Վերջին խաղեր';

  @override
  String get topGames => 'Լավագույն խաղեր';

  @override
  String masterDbExplanation(String param1, String param2, String param3) {
    return '2 միլիոն OTB պարտիաներ  $param1+ $param2-ից $param3 FIDE-ի վարկանիշով խաղացողների';
  }

  @override
  String get dtzWithRounding => 'DTZ50\'\' կլորացումով` կախված կիսաքայլերի քանակից մինչև հաջորդ վերցնելը կամ զինվորի քայլը';

  @override
  String get noGameFound => 'Ոչ մի խաղ չի գտնվել';

  @override
  String get maxDepthReached => 'Արձանագրված է առավելագույն խորություն։';

  @override
  String get maybeIncludeMoreGamesFromThePreferencesMenu => 'Փորձեք կարգավորումներում միացնել ավելի շատ խաղեր։';

  @override
  String get openings => 'Սկզբնախաղեր';

  @override
  String get openingExplorer => 'Սկզբնախաղերի դիտարկիչ';

  @override
  String get openingEndgameExplorer => 'Սկզբնախաղերի/վերջնախաղերի տեղեկատու';

  @override
  String xOpeningExplorer(String param) {
    return '$param սկզբնախաղերի դիտարկիչ';
  }

  @override
  String get playFirstOpeningEndgameExplorerMove => 'Խաղալ սկզբնախաղեր­/վերջնախաղեր սովորողի առաջին քայլը';

  @override
  String get winPreventedBy50MoveRule => 'Հաղթանակը կասեցված Է 50 քայլի օրենքի համաձայն';

  @override
  String get lossSavedBy50MoveRule => 'Պարտությունը կասեցված Է 50 քայլի օրենքի համաձայն';

  @override
  String get winOr50MovesByPriorMistake => 'Հաղթանակ կամ 50 քայլ վերջին սխալից հետո';

  @override
  String get lossOr50MovesByPriorMistake => 'Պարտություն կամ 50 քայլ վերջին սխալից հետո';

  @override
  String get unknownDueToRounding => 'Հաղթանակը երաշխավորված է միայն այն դեպքում, եթե առաջարկվող քայլերի հաջորդականությունը կատարվել է վերջին անգամ խաղաքարը վերցնելուց կամ զինվորական քայլից՝ Syzygy-ի բազաներում DTZ արժեքների հնարավոր կլորացման պատճառով:';

  @override
  String get allSet => 'Ամեն ինչ պատրաստ է։';

  @override
  String get importPgn => 'Ներմուծել PGN';

  @override
  String get delete => 'Ջնջել';

  @override
  String get deleteThisImportedGame => 'Ջնջե՞լ ներմուծված խաղը';

  @override
  String get replayMode => 'Դիտել կրկնապատկերը';

  @override
  String get realtimeReplay => 'Ինչպես պարտիայում';

  @override
  String get byCPL => 'Ըստ սխալների';

  @override
  String get openStudy => 'Բացել ուսուցումը';

  @override
  String get enable => 'Միացնել';

  @override
  String get bestMoveArrow => 'Լավագույն քայլի սլաքը';

  @override
  String get showVariationArrows => 'Ցուցադրել տարբերակների սլաքները';

  @override
  String get evaluationGauge => 'Գնահատման սանդղակ';

  @override
  String get multipleLines => 'Մի քանի շարունակություն';

  @override
  String get cpus => 'Պրոցեսորներ';

  @override
  String get memory => 'Հիշողություն';

  @override
  String get infiniteAnalysis => 'Անվերջ վերլուծություն';

  @override
  String get removesTheDepthLimit => 'Վերացնում է խորության սահմանափակումը և տաք պահում ձեր համակարգիչը';

  @override
  String get engineManager => 'Շարժիչի մենեջեր';

  @override
  String get blunder => 'Վրիպում';

  @override
  String get mistake => 'Սխալ';

  @override
  String get inaccuracy => 'Անճշտություն';

  @override
  String get moveTimes => 'Քայլի տևողություն';

  @override
  String get flipBoard => 'Շրջել խաղատախտակը';

  @override
  String get threefoldRepetition => 'Եռակի կրկնություն';

  @override
  String get claimADraw => 'Պահանջել ոչ-ոքի';

  @override
  String get offerDraw => 'Առաջարկել ոչ-ոքի';

  @override
  String get draw => 'Ոչ-ոքի';

  @override
  String get drawByMutualAgreement => 'Ոչ-ոքի՝ փոխադարձ համաձայնությամբ';

  @override
  String get fiftyMovesWithoutProgress => '50 քայլ առանց առաջընթացի';

  @override
  String get currentGames => 'Այժմ օնլայն ընթացող խաղերը';

  @override
  String get viewInFullSize => 'Մեծացնել չափը';

  @override
  String get logOut => 'Ելք';

  @override
  String get signIn => 'Մուտք';

  @override
  String get rememberMe => 'Հիշել ինձ';

  @override
  String get youNeedAnAccountToDoThat => 'Դա անելու համար պետք է հաշիվ ունենալ';

  @override
  String get signUp => 'Գրանցվել';

  @override
  String get computersAreNotAllowedToPlay => 'Համակարգիչներն ու համակարգչից օգնություն վերցնող խաղացողներն իրավունք չունեն խաղալ։ Խնդրում ենք խաղալիս չօգտվել շախմատային ծրագրերից, տվյալների բազաներից և այլ մարդկանց օգնությունից:';

  @override
  String get games => 'Խաղեր';

  @override
  String get forum => 'Ֆորում';

  @override
  String xPostedInForumY(String param1, String param2) {
    return '$param1 գրառել է $param2 ֆորումում';
  }

  @override
  String get latestForumPosts => 'Վերջին գրառումները ֆորումում';

  @override
  String get players => 'Խաղացողներ';

  @override
  String get friends => 'Ընկերներ';

  @override
  String get discussions => 'Հաղորդագրություններ';

  @override
  String get today => 'Այսօր';

  @override
  String get yesterday => 'Երեկ';

  @override
  String get minutesPerSide => 'Րոպեներ ամեն կողմի համար';

  @override
  String get variant => 'Տարբերակ';

  @override
  String get variants => 'Տարբերակներ';

  @override
  String get timeControl => 'Ժամակարգ';

  @override
  String get realTime => 'Ժամանակով';

  @override
  String get correspondence => 'Նամակագրական';

  @override
  String get daysPerTurn => 'Օրեր քայլի համար';

  @override
  String get oneDay => 'Մեկ օր';

  @override
  String get time => 'Ժամանակ';

  @override
  String get rating => 'Վարկանիշ';

  @override
  String get ratingStats => 'Վարկանիշների բաշխում';

  @override
  String get username => 'Օգտատիրոջ անուն';

  @override
  String get usernameOrEmail => 'Օգտատիրոջ անուն կամ email';

  @override
  String get changeUsername => 'Փոխել օգտանունը';

  @override
  String get changeUsernameNotSame => 'Կարելի է փոխել միայն նշանների ստեղնաշարքը։ Օրինակ, «hayktadevosyan»-ը դարձնել «HaykTadevosyan»։';

  @override
  String get changeUsernameDescription => 'Փոխել օգտանունը։ Սա կարող է արվել ընդամենը մեկ անգամ, միայն թույլատրվում է օգտանվան փոքրատառերը դարձնել մեծատառ և հակառակը։';

  @override
  String get signupUsernameHint => 'Համոզվեք, որ ընտրել եք պարկեշտ մասնակցային անուն։ Հետագայում այն փոխել չեք կարողանա, ընդ որում, անպարկեշտ անուններով մասնակցային հաշիվները կփակվեն։';

  @override
  String get signupEmailHint => 'Մենք այն օգտագործելու ենք միայն գաղտնաբառը չեղարկելու համար։';

  @override
  String get password => 'Գաղտնաբառ';

  @override
  String get changePassword => 'Փոխել գաղտնաբառը';

  @override
  String get changeEmail => 'Փոխել էլ. փոստը';

  @override
  String get email => 'Էլ. փոստ';

  @override
  String get passwordReset => 'Վերականգնել գաղտնաբառը';

  @override
  String get forgotPassword => 'Մոռացել ե՞ք գաղտնաբառը';

  @override
  String get error_weakPassword => 'Այդ գաղտնաբառը շատ տարածված է, և այն չափազանց հեշտ է գուշակել։';

  @override
  String get error_namePassword => 'Խնդրում ենք՝ Ձեր մասնակցային անունը մի՛ օգտագործեք որպես գաղտնաբառ։';

  @override
  String get blankedPassword => 'Նույն գաղտնաբառը Դուք օգտագործել եք այլ կայքում, իսկ այդ կայքը վարկաբեկվել է։ Այժմ Lichess-ի Ձեր մասնակցային հաշվի անվտանգության համար անհրաժեշտ է սահմանել նոր գաղտնաբառ։ Շնորհակալություն ըմբռնումով մոտենալու համար։';

  @override
  String get youAreLeavingLichess => 'Դուք լքում եք Lichess-ը';

  @override
  String get neverTypeYourPassword => 'Երբեք մի՛ մուտքագրեք Lichess-ի գաղտնաբառը այլ կայքերում։';

  @override
  String proceedToX(String param) {
    return 'Անցնել $param';
  }

  @override
  String get passwordSuggestion => 'Մի՛ ընտրեք այլ անձանց առաջարկած գաղտնաբառը։ Նրանք դրա օգնությամբ կգողանան Ձեր մասնակցային հաշիվը։';

  @override
  String get emailSuggestion => 'Մի՛ ընտրեք այլ անձանց առաջարկած էլեկտրոնային փոստի հասցեն։ Նրանք դրա օգնությամբ կգողանան Ձեր մասնակցային հաշիվը։';

  @override
  String get emailConfirmHelp => 'Օգնություն էլեկտրոնային փոստի հաստատման հարցում';

  @override
  String get emailConfirmNotReceived => 'Գրանցվելուց հետո էլփոստին չե՞ք ստացել հաստատման նամակը:';

  @override
  String get whatSignupUsername => 'Ի՞նչ օգտանուն եք ընտրել գրանցվելու համար:';

  @override
  String usernameNotFound(String param) {
    return 'Մենք չկարողացանք գտնել որևէ օգտատիրոջ այս անունով՝ $param:';
  }

  @override
  String get usernameCanBeUsedForNewAccount => 'Նոր հաշիվ ստեղծելու համար Դուք կարող եք օգտագործել այս օգտանունը';

  @override
  String emailSent(String param) {
    return 'Մենք նամակ ենք ուղարկել $param հասցեին:';
  }

  @override
  String get emailCanTakeSomeTime => 'Հասնելու համար կարող է որոշ ժամանակ պահանջվել։';

  @override
  String get refreshInboxAfterFiveMinutes => 'Սպասեք 5 րոպե և թարմացրեք Ձեր էլփոստի մուտքային արկղը։';

  @override
  String get checkSpamFolder => 'Ստուգեք նաև սպամի պանակը, նամակը կարող է հայտնվել այնտեղ: Եթե ​​այդպես է, այն նշեք որպես ոչ սպամ:';

  @override
  String get emailForSignupHelp => 'Եթե ​​մնացած ամեն ինչը ձախողվի, ապա գրեք մեզ այս էլեկտրոնային հասցեով.';

  @override
  String copyTextToEmail(String param) {
    return 'Պատճենեք և տեղադրեք վերը նշված տեքստը և այն ուղարկեք $param-ին';
  }

  @override
  String get waitForSignupHelp => 'Մենք շուտով կվերադառնանք Ձեզ, որպեսզի օգնենք լրացնել Ձեր գրանցումը:';

  @override
  String accountConfirmed(String param) {
    return '$param օգտատերը հաջողությամբ հաստատվել է:';
  }

  @override
  String accountCanLogin(String param) {
    return 'Դուք կարող եք մուտք գործել հենց հիմա որպես $param:';
  }

  @override
  String get accountConfirmationEmailNotNeeded => 'Ձեզ անհրաժեշտ չէ հաստատման նամակ։';

  @override
  String accountClosed(String param) {
    return '$param հաշիվը փակված է:';
  }

  @override
  String accountRegisteredWithoutEmail(String param) {
    return '$param հաշիվը գրանցվել է առանց էլփոստի:';
  }

  @override
  String get rank => 'Դասակարգում';

  @override
  String rankX(String param) {
    return 'Դասակարգում՝ $param';
  }

  @override
  String get gamesPlayed => 'Խաղացած խաղեր';

  @override
  String get cancel => 'Հերքել';

  @override
  String get whiteTimeOut => 'Սպիտակների ժամանակը սպառվեց';

  @override
  String get blackTimeOut => 'Սևերի ժամանակը սպառվեց';

  @override
  String get drawOfferSent => 'Ոչ-ոքի առաջարկը ուղարկված է';

  @override
  String get drawOfferAccepted => 'Ոչ-ոքի առաջարկը ընդունվել է';

  @override
  String get drawOfferCanceled => 'Ոչ-ոքի առաջարկը հերքվել է';

  @override
  String get whiteOffersDraw => 'Սպիտակներն առաջարկում են ոչ-ոքի';

  @override
  String get blackOffersDraw => 'Սևերն առաջարկում են ոչ-ոքի';

  @override
  String get whiteDeclinesDraw => 'Սպիտակները մերժում են ոչ-ոքին';

  @override
  String get blackDeclinesDraw => 'Սևերը մերժում են ոչ-ոքին';

  @override
  String get yourOpponentOffersADraw => 'Ձեր հակառակորդը առաջարկում է ոչ-ոքի';

  @override
  String get accept => 'Համաձայնվել';

  @override
  String get decline => 'Մերժել';

  @override
  String get playingRightNow => 'Այս պահին խաղում են';

  @override
  String get eventInProgress => 'Խաղում են այս պահին';

  @override
  String get finished => 'Ավարտվել է';

  @override
  String get abortGame => 'Կասեցնել խաղը';

  @override
  String get gameAborted => 'Խաղը կասեցված է';

  @override
  String get standard => 'Ստանդարտ';

  @override
  String get customPosition => 'Custom position';

  @override
  String get unlimited => 'Անսահմանափակ';

  @override
  String get mode => 'Տեսակը';

  @override
  String get casual => 'Առանց վարկանիշի';

  @override
  String get rated => 'Վարկանիշային';

  @override
  String get casualTournament => 'Առանց վարկանիշի';

  @override
  String get ratedTournament => 'Վարկանիշային';

  @override
  String get thisGameIsRated => 'Խաղը Վարկանիշային է';

  @override
  String get rematch => 'Կրկին խաղալ';

  @override
  String get rematchOfferSent => 'Ռևանշի առաջարկը ուղարկված է';

  @override
  String get rematchOfferAccepted => 'Ռևանշի առաջարկը ընդունված է';

  @override
  String get rematchOfferCanceled => 'Ռևանշի առաջարկը կասեցված է';

  @override
  String get rematchOfferDeclined => 'Ռևանշի առաջարկը մերժված է';

  @override
  String get cancelRematchOffer => 'Կասեցնել ռևանշի առաջարկը';

  @override
  String get viewRematch => 'Ցույց տալ ռեւանշը';

  @override
  String get confirmMove => 'Հաստատել քայլը';

  @override
  String get play => 'Խաղալ';

  @override
  String get inbox => 'Փոստարկղ';

  @override
  String get chatRoom => 'Զրուցարանի պատուհան';

  @override
  String get loginToChat => 'Մուտք գործել զրուցարան';

  @override
  String get youHaveBeenTimedOut => 'Զրուցարանը ժամանակավորապես անհասանելի Ձեզ համար։';

  @override
  String get spectatorRoom => 'Հանդիսատեսների սենյակ';

  @override
  String get composeMessage => 'Գրել հաղորդագրություն';

  @override
  String get subject => 'Թեմա';

  @override
  String get send => 'Ուղարկել';

  @override
  String get incrementInSeconds => 'Ավելացումը ըստ վայրկյանների';

  @override
  String get freeOnlineChess => 'Անվճար օնլայն շախմատ';

  @override
  String get exportGames => 'Էկսպորտ անել խաղերը';

  @override
  String get ratingRange => 'Elo միջակայք';

  @override
  String get thisAccountViolatedTos => 'Այս օգտատերը խախտել է Lichess-ի օգտագործման պայմանները';

  @override
  String get openingExplorerAndTablebase => 'Սկզբնախաղերի և վերջնախաղերի բազա՝ &';

  @override
  String get takeback => 'Քայլը հետ վերցնել';

  @override
  String get proposeATakeback => 'Քայլը հետ վերցնելու առաջարկ անել';

  @override
  String get takebackPropositionSent => 'Քայլը հետ վերցնելու առաջարկն ուղարկված է';

  @override
  String get takebackPropositionDeclined => 'Քայլը հետ վերցնելու առաջարկը մերժված է';

  @override
  String get takebackPropositionAccepted => 'Քայլը հետ վերցնելու առաջարկն ընդունված է';

  @override
  String get takebackPropositionCanceled => 'Քայլը հետ վերցնելու առաջարկը կասեցված է';

  @override
  String get yourOpponentProposesATakeback => 'Ձեր հակառակորդը առաջարկում է քայլը հետ վերցնել';

  @override
  String get bookmarkThisGame => 'Էջանշել այս խաղը';

  @override
  String get tournament => 'Մրցաշար';

  @override
  String get tournaments => 'Մրցաշարեր';

  @override
  String get tournamentPoints => 'Մրցաշարային  միավորներ';

  @override
  String get viewTournament => 'Դիտել մրցաշարը';

  @override
  String get backToTournament => 'Վերադարձ դեպի մրցաշարը';

  @override
  String get noDrawBeforeSwissLimit => 'Դուք չեք կարող ոչ-ոքի առաջարկել մինչև 30-րդ քայլը շվեյցարական համակարգով մրցաշարում։';

  @override
  String get thematic => 'Թեմատիկա';

  @override
  String yourPerfRatingIsProvisional(String param) {
    return 'Ձեր վարկանիշը $param-ում դեռևս վավեր չէ';
  }

  @override
  String yourPerfRatingIsTooHigh(String param1, String param2) {
    return 'Ձեր վարկանիշը $param1ում ($param2) մասնակցելու համար չափազանց բարձր է';
  }

  @override
  String yourTopWeeklyPerfRatingIsTooHigh(String param1, String param2) {
    return 'Ձեր ամենշաբաթյա վարկանիշը $param1ում ($param2) չափազանց բարձր է';
  }

  @override
  String yourPerfRatingIsTooLow(String param1, String param2) {
    return 'Ձեր վարկանիշը $param1ին ($param2) մասնակցելու համար բավարար չէ';
  }

  @override
  String ratedMoreThanInPerf(String param1, String param2) {
    return 'Վարկանիշը ≥ $param1 $param2-ում';
  }

  @override
  String ratedLessThanInPerf(String param1, String param2) {
    return 'Վարկանիշը ≤ $param1 $param2-ում';
  }

  @override
  String mustBeInTeam(String param) {
    return 'Դուք պետք է լինեք $param ակումբի անդամ';
  }

  @override
  String youAreNotInTeam(String param) {
    return 'Դուք $param ակումբի անդամ չեք';
  }

  @override
  String get backToGame => 'Վերադառնալ պարտիային';

  @override
  String get siteDescription => 'Անվճար օնլայն շախմատ: Խաղացեք հաճելի ինտերֆեյսով, առանց գրանցման և գովազդի: Խաղացեք համակարգչի, ընկերների կամ անծանոթների հետ:';

  @override
  String xJoinedTeamY(String param1, String param2) {
    return '$param1 միացած թիմեր $param2';
  }

  @override
  String xCreatedTeamY(String param1, String param2) {
    return '$param1 ստեղծած թիմ $param2';
  }

  @override
  String get startedStreaming => 'սկսել է հեռարձակումը';

  @override
  String xStartedStreaming(String param) {
    return '$param-ն ուղիղ եթերում է';
  }

  @override
  String get averageElo => 'Միջին ELO';

  @override
  String get location => 'Տեղակայումը';

  @override
  String get filterGames => 'Զտել խաղերը';

  @override
  String get reset => 'Վերսկսել';

  @override
  String get apply => 'Կիրառել';

  @override
  String get save => 'Պահպանել';

  @override
  String get leaderboard => 'Առաջատարներ';

  @override
  String get screenshotCurrentPosition => 'Ստանալ այս դիրքի սքրինշոթը';

  @override
  String get gameAsGIF => 'Պարտիան GIF ձևաչափով';

  @override
  String get pasteTheFenStringHere => 'տեղադրել FEN տեքստը այստեղ';

  @override
  String get pasteThePgnStringHere => 'տեղադրել PGN-տողը այստեղ';

  @override
  String get orUploadPgnFile => 'Կամ վերբեռնեք PGN ֆայլը';

  @override
  String get fromPosition => 'Դիրքից';

  @override
  String get continueFromHere => 'Շարունակել այստեղից';

  @override
  String get toStudy => 'Սովորել';

  @override
  String get importGame => 'Խաղ ներմուծել';

  @override
  String get importGameExplanation => 'Տեղադրեք պարտիայի գրառումը PGN ձևաչափով, և հնարավորություն կստանաք վերախաղարկելու պարտիան, կատարելու համակարգչային վերլուծություն, շփվելու զրուցարանում և կիսվելու այդ պարտիայի հղումով։';

  @override
  String get importGameCaveat => 'Տարբերակները կհեռացվեն։ Դրանք պահպանելու համար, PGN-ը տեղափոխեք ստուդիա։';

  @override
  String get importGameDataPrivacyWarning => 'This PGN can be accessed by the public. To import a game privately, use a study.';

  @override
  String get thisIsAChessCaptcha => 'Սա շախմատային CAPTCHA է';

  @override
  String get clickOnTheBoardToMakeYourMove => 'Սեղմեք դաշտին, որ անեք ձեր քայլը և ապացուցեք, որ մարդ եք:';

  @override
  String get captcha_fail => 'Խնդրում ենք լուծել շախմատային CAPTCHA-ն։';

  @override
  String get notACheckmate => 'Մատ չէ';

  @override
  String get whiteCheckmatesInOneMove => 'Սպիտակները մատ են անում մեկ քայլից';

  @override
  String get blackCheckmatesInOneMove => 'Սևերը մատ են անում մեկ քայլից';

  @override
  String get retry => 'Կրկին փորձել';

  @override
  String get reconnecting => 'Կապի միացում';

  @override
  String get noNetwork => 'Օֆլայն';

  @override
  String get favoriteOpponents => 'Սիրելի հակառակորդներ';

  @override
  String get follow => 'Հետևել';

  @override
  String get following => 'Հետևում եք';

  @override
  String get unfollow => 'Չհետևել';

  @override
  String followX(String param) {
    return 'Հետևել $param-ին';
  }

  @override
  String unfollowX(String param) {
    return 'Չհետևել $param-ին';
  }

  @override
  String get block => 'Արգելափակել';

  @override
  String get blocked => 'Արգելափակված է';

  @override
  String get unblock => 'Հանել արգելափակումը';

  @override
  String get followsYou => 'Հետևում են ձեզ';

  @override
  String xStartedFollowingY(String param1, String param2) {
    return '$param1-ը այժմ հետևում է $param2-ին';
  }

  @override
  String get more => 'Ավելին';

  @override
  String get memberSince => 'Անդամ է՝ սկսած';

  @override
  String lastSeenActive(String param) {
    return 'Վերջին մուտքը $param';
  }

  @override
  String get player => 'Խաղացող';

  @override
  String get list => 'ցուցակ';

  @override
  String get graph => 'Գրաֆիկ';

  @override
  String get required => 'Պարտադիր.';

  @override
  String get openTournaments => 'Բաց մրցաշարեր';

  @override
  String get duration => 'Տևողություն';

  @override
  String get winner => 'Հաղթող';

  @override
  String get standing => 'Զբաղեցրած դիրք';

  @override
  String get createANewTournament => 'Ստեղծել նոր մրցաշար';

  @override
  String get tournamentCalendar => 'Մրցաշարի օրացույց';

  @override
  String get conditionOfEntry => 'Մուտքի պահանջներ՝';

  @override
  String get advancedSettings => 'Ընդլայնված կարգավորումներ';

  @override
  String get safeTournamentName => 'Ընտրեք շատ ապահով անվանում մրցաշարի համար։';

  @override
  String get inappropriateNameWarning => 'Եթե անվանումը թվա նույնիսկ փոքր-ինչ անհարիր, Ձեզ կարող են արգելափակել։';

  @override
  String get emptyTournamentName => 'Թողեք դատարկ` մրցաշարը պատահական գրոսմայստերի պատվին կոչելու համար։';

  @override
  String get makePrivateTournament => 'Մրցաշարը դարձնել փակ և մուտքը սահմանափակել գաղտնաբառով';

  @override
  String get join => 'Միանալ';

  @override
  String get withdraw => 'Չեղարկել';

  @override
  String get points => 'Միավորներ';

  @override
  String get wins => 'Հաղթանակներ';

  @override
  String get losses => 'Պարտություններ';

  @override
  String get createdBy => 'Ստեղծող՝';

  @override
  String get tournamentIsStarting => 'Մրցաշարը սկսվում է';

  @override
  String get tournamentPairingsAreNowClosed => 'Մրցաշարի վիճակահանությունն ավարտված է։';

  @override
  String standByX(String param) {
    return 'Խնդրում ենք սպասել $param, տեղի է ունենում վիճակահանություն։ Պատրա՛ստ եղեք։';
  }

  @override
  String get pause => 'Դադար';

  @override
  String get resume => 'Շարունակել';

  @override
  String get youArePlaying => 'Դուք խաղում եք։';

  @override
  String get winRate => 'Հաղթանակի տոկոս';

  @override
  String get berserkRate => 'Բերսերկի տոկոս';

  @override
  String get performance => 'Արտադրողականություն';

  @override
  String get tournamentComplete => 'Մրցաշարն ավարտված է';

  @override
  String get movesPlayed => 'Խաղացած քայլեր';

  @override
  String get whiteWins => 'Սպիտակները հաղթել են';

  @override
  String get blackWins => 'Սևերը հաղթել են';

  @override
  String get drawRate => 'Draw rate';

  @override
  String get draws => 'Ոչ-ոքիներ';

  @override
  String nextXTournament(String param) {
    return 'Մյուս $param մրցաշարը՝';
  }

  @override
  String get averageOpponent => 'Մրցակիցների միջին վարկանիշը';

  @override
  String get boardEditor => 'Խաղատախտակի խմբագրիչ';

  @override
  String get setTheBoard => 'Տեղադրել դիրքը';

  @override
  String get popularOpenings => 'Հանրաճանաչ սկզբնախաղեր';

  @override
  String get endgamePositions => 'Վերջնախաղային դիրքեր';

  @override
  String chess960StartPosition(String param) {
    return 'Շախմատ 960-ի սկզբնական դիրք՝ $param';
  }

  @override
  String get startPosition => 'Սկզբնական դիրք';

  @override
  String get clearBoard => 'Մաքրել տախտակը';

  @override
  String get loadPosition => 'Բեռնել դիրք';

  @override
  String get isPrivate => 'Անձնական';

  @override
  String reportXToModerators(String param) {
    return 'Տեղեկացնել $param մոդերատորներին';
  }

  @override
  String profileCompletion(String param) {
    return 'Մասնակցային էջը լրացված է $param-ով';
  }

  @override
  String xRating(String param) {
    return '$param վարկանիշ';
  }

  @override
  String get ifNoneLeaveEmpty => 'Կամ թողնել դատարկ';

  @override
  String get profile => 'Պրոֆիլ';

  @override
  String get editProfile => 'Խմբագրել անձնագիրը';

  @override
  String get realName => 'Real name';

  @override
  String get setFlair => 'Set your flair';

  @override
  String get flair => 'Flair';

  @override
  String get youCanHideFlair => 'There is a setting to hide all user flairs across the entire site.';

  @override
  String get biography => 'Կենսագրություն';

  @override
  String get countryRegion => 'Country or region';

  @override
  String get thankYou => 'Շնորհակալությո՛ւն։';

  @override
  String get socialMediaLinks => 'Հղումներ սոցցանցերին';

  @override
  String get oneUrlPerLine => 'Տողում՝ մեկ URL։';

  @override
  String get inlineNotation => 'Տողային նոտագրություն';

  @override
  String get makeAStudy => 'Պահպանելու և կիսվելու համար դիտարկեք ստուդիա ստեղծելու հնարավորությունը։';

  @override
  String get clearSavedMoves => 'Մաքրել քայլերը';

  @override
  String get previouslyOnLichessTV => 'Նախորդները Lichess TV-ով';

  @override
  String get onlinePlayers => 'Առցանց խաղացողներ';

  @override
  String get activePlayers => 'Ակտիվ խաղացողներ';

  @override
  String get bewareTheGameIsRatedButHasNoClock => 'Զգուշացում. խաղը վարկանիշային է, սակայն առանց ժամանակի';

  @override
  String get success => 'Հաջողված է';

  @override
  String get automaticallyProceedToNextGameAfterMoving => 'Հակառակորդի քայլից հետո ավտոմատ կերպով անցնել հաջորդ քայլին';

  @override
  String get autoSwitch => 'միանգամից անցնել հաջորդ խաղին';

  @override
  String get puzzles => 'Խնդիրներ';

  @override
  String get onlineBots => 'Online bots';

  @override
  String get name => 'Անուն';

  @override
  String get description => 'Նկարագրություն';

  @override
  String get descPrivate => 'Մասնավոր նկարագրություն';

  @override
  String get descPrivateHelp => 'Նկարագրություն, որը կտեսնեն միայն ակումբի անդամները։ Եթե սահմանված է, ապա փոխարինում է ակումբի բոլոր անդամների հրապարակային նկարագրությունը։';

  @override
  String get no => 'Ոչ';

  @override
  String get yes => 'այո';

  @override
  String get help => 'Օգնություն.';

  @override
  String get createANewTopic => 'Ստեղծել նոր թեմա';

  @override
  String get topics => 'Թեմաներ';

  @override
  String get posts => 'Հաղորդագրություններ';

  @override
  String get lastPost => 'Վերջին հաղորդագրությունը';

  @override
  String get views => 'Դիտումներ';

  @override
  String get replies => 'Պատասխաններ';

  @override
  String get replyToThisTopic => 'Պատասխանել այս թեմայում';

  @override
  String get reply => 'Պատասխանել';

  @override
  String get message => 'Հաղորդագրություն';

  @override
  String get createTheTopic => 'Ստեղծել թեմա';

  @override
  String get reportAUser => 'Հաղորդել օգտատիրոջ մասին';

  @override
  String get user => 'Օգտատեր';

  @override
  String get reason => 'Պատճառ';

  @override
  String get whatIsIheMatter => 'Ի՞նչ է պատահել';

  @override
  String get cheat => 'խաբեբա';

  @override
  String get troll => 'Թրոլինգ';

  @override
  String get other => 'այլ';

  @override
  String get reportDescriptionHelp => 'Կիսվեք մեզ հետ Այն խաղերի հղումներով, որտեղ կարծում եք, որ կանոնները խախտվել են և նկարագրեք, թե ինչն է սխալ: Բավական չէ պարզապես գրել \"Նա խարդախում է\", խնդրում ենք նկարագրել, թե ինչպես եք եկել այս եզրակացության: Մենք ավելի արագ կաշխատենք, եթե գրեք անգլերեն:';

  @override
  String get error_provideOneCheatedGameLink => 'Խնդրում ենք ավելացնել առնվազն մեկ խաղի հղում, որտեղ ձեր կարծիքով խախտվել են կանոնները:';

  @override
  String by(String param) {
    return 'ըստ $param';
  }

  @override
  String importedByX(String param) {
    return 'Ներմուծվել է $param-ի կողմից';
  }

  @override
  String get thisTopicIsNowClosed => 'Այս թեման այժմ փակ է։';

  @override
  String get blog => 'Բլոգ';

  @override
  String get notes => 'Նշումներ';

  @override
  String get typePrivateNotesHere => 'Մասնավոր նշումները մուտքագրեք այստեղ';

  @override
  String get writeAPrivateNoteAboutThisUser => 'Գրել գաղտնի նշում այդ օգտվողի մասին';

  @override
  String get noNoteYet => 'Դեռ մի նշում չկա';

  @override
  String get invalidUsernameOrPassword => 'Սխալ օգտանուն կամ գաղտնաբառ';

  @override
  String get incorrectPassword => 'Գաղտնաբառը սխալ է';

  @override
  String get invalidAuthenticationCode => 'Վավերացման սխալ կոդը';

  @override
  String get emailMeALink => 'Էլեկտրոնային փոստով ուղարկել ինձ  հղումը';

  @override
  String get currentPassword => 'Ընթացիկ գաղտնաբառը';

  @override
  String get newPassword => 'նոր գաղտնաբառը';

  @override
  String get newPasswordAgain => 'նոր գաղտնաբառը  (նորից)';

  @override
  String get newPasswordsDontMatch => 'Նոր գաղտնաբառերը չեն համընկնում';

  @override
  String get newPasswordStrength => 'Գաղտնաբառի բարդություն';

  @override
  String get clockInitialTime => 'Նախնական ժամանակը ժամացույցի վրա';

  @override
  String get clockIncrement => 'Ժամանակի հավելում';

  @override
  String get privacy => 'Գաղտնիություն';

  @override
  String get privacyPolicy => 'Գաղտնիության քաղաքականություն';

  @override
  String get letOtherPlayersFollowYou => 'Թույլ տալ ուրիշ խաղացողներին ձեզ հետևել';

  @override
  String get letOtherPlayersChallengeYou => 'Թույլ տալ ուրիշ խաղացողներին ձեզ մարտահրավեր նետել';

  @override
  String get letOtherPlayersInviteYouToStudy => 'Թույլ տալ ուրիշ խաղացողներին ձեզ հրավիրել ստուդիա';

  @override
  String get sound => 'Ձայն';

  @override
  String get none => 'Ոչ մեկը';

  @override
  String get fast => 'Արագ';

  @override
  String get normal => 'Նորմալ';

  @override
  String get slow => 'Դանդաղ';

  @override
  String get insideTheBoard => 'Խաղատախտակի ներսում';

  @override
  String get outsideTheBoard => 'Խաղատախտակից դուրս';

  @override
  String get allSquaresOfTheBoard => 'All squares of the board';

  @override
  String get onSlowGames => 'Դանդաղ խաղերում';

  @override
  String get always => 'Միշտ';

  @override
  String get never => 'Երբեք';

  @override
  String xCompetesInY(String param1, String param2) {
    return '$param1 որոշել է մասնակցել $param2-ին';
  }

  @override
  String get victory => 'Հաղթանակ';

  @override
  String get defeat => 'Պարտություն';

  @override
  String victoryVsYInZ(String param1, String param2, String param3) {
    return '$param1-ն ընդդեմ $param2-ի $param3-ում';
  }

  @override
  String defeatVsYInZ(String param1, String param2, String param3) {
    return '$param1-ն ընդդեմ $param2-ի $param3-ում';
  }

  @override
  String drawVsYInZ(String param1, String param2, String param3) {
    return '$param1-ն ընդդեմ $param2-ի $param3-ում';
  }

  @override
  String get timeline => 'Ժամանակացույց';

  @override
  String get starting => 'Սկիզբը՝';

  @override
  String get allInformationIsPublicAndOptional => 'Այստեղ նշվող բոլոր տեղեկությունները հասանելի են լինելու բոլորին, ավելացրեք դրանք սեփական ցանկությամբ։';

  @override
  String get biographyDescription => 'Պատմեք Ձեր մասին. ինչն եք սիրում շախմատում, որոնք են Ձեր սիրելի սկզբնախաղերը, պարտիաները, շախմատիստները…';

  @override
  String get listBlockedPlayers => 'Այն խաղացողների ցանկը, որոնց Դուք արգելափակել եք';

  @override
  String get human => 'Մարդ';

  @override
  String get computer => 'Համակարգիչ';

  @override
  String get side => 'Կողմ';

  @override
  String get clock => 'Ժամացույց';

  @override
  String get opponent => 'Մրցակից';

  @override
  String get learnMenu => 'Ուսուցում';

  @override
  String get studyMenu => 'Ստուդիա';

  @override
  String get practice => 'Փորձ';

  @override
  String get community => 'Համայնք';

  @override
  String get tools => 'Գործիքներ';

  @override
  String get increment => 'Ավելացում';

  @override
  String get error_unknown => 'Սխալ արժեք';

  @override
  String get error_required => 'Այս դաշտը պարտադիր է';

  @override
  String get error_email => 'Էլ. փոստի այս հասցեն սխալ է:';

  @override
  String get error_email_acceptable => 'Այս էլ. փոստի հասցեն վավեր չէ։ Ստուգեք այն և նորից փորձեք:';

  @override
  String get error_email_unique => 'Էլ. փոստի հասցեն անվավեր է կամ արդեն զբաղված է';

  @override
  String get error_email_different => 'Սա առանց այդ էլ Ձեր էլ. փոստի հասցեն է';

  @override
  String error_minLength(String param) {
    return 'Տեքստի նվազագույն երկարությունը — $param';
  }

  @override
  String error_maxLength(String param) {
    return 'Տեքստի առավելագույն երկարությունը — $param';
  }

  @override
  String error_min(String param) {
    return 'Արժեքը պետք է լինի մեծ կամ հավասար $param';
  }

  @override
  String error_max(String param) {
    return 'Արժեքը պետք է լինի փոքր կամ հավասար $param';
  }

  @override
  String ifRatingIsPlusMinusX(String param) {
    return 'Եթե գործակիցը ± $param';
  }

  @override
  String get ifRegistered => 'Եթե գրանցված է';

  @override
  String get onlyExistingConversations => 'Միայն գոյություն ունեցող քննարկումները';

  @override
  String get onlyFriends => 'Միայն ընկերները';

  @override
  String get menu => 'Մենյու';

  @override
  String get castling => 'Փոխատեղում';

  @override
  String get whiteCastlingKingside => 'Սպիտակները O-O';

  @override
  String get blackCastlingKingside => 'Սևերը O-O';

  @override
  String tpTimeSpentPlaying(String param) {
    return 'Ընդհանուր խաղաժամանակ` $param';
  }

  @override
  String get watchGames => 'Դիտել խաղեր';

  @override
  String tpTimeSpentOnTV(String param) {
    return 'Ժամանակը TV-ում՝ $param';
  }

  @override
  String get watch => 'Դիտում';

  @override
  String get videoLibrary => 'Տեսադարան';

  @override
  String get streamersMenu => 'Հեռարձակողներ';

  @override
  String get mobileApp => 'Բջջային հավելված';

  @override
  String get webmasters => 'Վեբմաստեր';

  @override
  String get about => 'Մեր մասին';

  @override
  String aboutX(String param) {
    return '$param-ի մասին';
  }

  @override
  String xIsAFreeYLibreOpenSourceChessServer(String param1, String param2) {
    return '$param1-ը անվճար ($param2) շախմատային սերվեր է՝ բաց ընթացիկ կոդով, առանց գովազդի։';
  }

  @override
  String get really => 'հե՛նց այդպես';

  @override
  String get contribute => 'Աջակցել զարգացմանը';

  @override
  String get termsOfService => 'Ծառայությունների մատուցման պայմաններ';

  @override
  String get sourceCode => 'Ընթացիկ կոդ';

  @override
  String get simultaneousExhibitions => 'Միաժամանակյա խաղաշար';

  @override
  String get host => 'Խաղաշարն անցկացնողը';

  @override
  String hostColorX(String param) {
    return 'Խաղաշար անցկացնողի գույնը` $param';
  }

  @override
  String get yourPendingSimuls => 'Your pending simuls';

  @override
  String get createdSimuls => 'Վերջերս ստեղծված խաղաշարեր';

  @override
  String get hostANewSimul => 'Ստեղծել նոր խաղաշար';

  @override
  String get signUpToHostOrJoinASimul => 'Sign up to host or join a simul';

  @override
  String get noSimulFound => 'Խաղաշարը չի գտնվել';

  @override
  String get noSimulExplanation => 'Այդ միաժամանակյա խաղաշարը գոյություն չունի։';

  @override
  String get returnToSimulHomepage => 'Վերադառնալ խաղաշարերի էջ';

  @override
  String get aboutSimul => 'Խաղաշարերը ենթադրում են մեկ խաղացողի մենամարտը միաժամանակ մի քանի խաղացողի հետ։';

  @override
  String get aboutSimulImage => 'Ընդհանուր 50 պարտիայից Ֆիշերը հաղթել է 47-ում, ոչ-ոքի արել 2-ում և պարտվել 1-ում։';

  @override
  String get aboutSimulRealLife => 'Գաղափարը կրկնում է կենդանի շախմատում ընդունված հայեցակարգը, երբ խաղաշար անցկացնողը տեղաշարժվում է սեղանից սեղան` մեկ քայլ կատարելու համար։';

  @override
  String get aboutSimulRules => 'Երբ սկսվում է միաժամանակյա խաղաշարը, յուրաքանչյուր խաղացող սկսում է պարտիան խաղաշարն անցկացնողի հետ, որը խաղում է սպիտակներով։ Խաղաշարն ավարտվում է, երբ խաղացվում են բոլոր պարտիաները։';

  @override
  String get aboutSimulSettings => 'Միաժամանակյա խաղաշարերը չեն ենթադրում վարկանիշային պարտիաներ։ Վերախաղարկումները, քայլերի չեղարկումները և ժամանակի հավելումները արգելված են։';

  @override
  String get create => 'Ստեղծել';

  @override
  String get whenCreateSimul => 'Եթե ստեղծեք միաժամանակյա խաղաշար, ստիպված կլինեք խաղալու միաժամանակ մի քանի խաղացողի դեմ։';

  @override
  String get simulVariantsHint => 'Եթե ընտրեք խաղի մի քանի տարբերակ, յուրաքանչյուր խաղացող կընտրի դրանցից այն մեկը, որը կցանկանա խաղալ ձեզ հետ։';

  @override
  String get simulClockHint => 'Ֆիշերի ժամացույցի կարգավորումներ։ Որքան շատ մրցակից ունենաք, այնքան շատ ժամանակ ձեզ պետք կգա։';

  @override
  String get simulAddExtraTime => 'Պարտիաներում մտորելու համար դուք կարող եք ստանալ լրացուցիչ ժամանակ։';

  @override
  String get simulHostExtraTime => 'Խաղաշար անցկացնողի լրացուցիչ ժամանակը';

  @override
  String get simulAddExtraTimePerPlayer => 'Ձեր ժամացույցի վրա ավելացրեք մեկնարկային ժամանակը յուրաքանչյուր խաղացողի համար, ով մուտք է գործել Ձեր միաժամանակյա խաղի նստաշրջան:';

  @override
  String get simulHostExtraTimePerPlayer => 'Յուրաքանչյուր խաղացողի համար նստաշրջանի ժամանակի լրացում';

  @override
  String get lichessTournaments => 'Lichess մրցաշարեր';

  @override
  String get tournamentFAQ => 'Հարցեր «Արենա» մրցաշարերի վերաբերյալ';

  @override
  String get timeBeforeTournamentStarts => 'Ժամանակ մինչև մրցաշարի սկսվելը';

  @override
  String get averageCentipawnLoss => 'Միջինը հարյուրերորդական զինվորի կորուստ';

  @override
  String get accuracy => 'Ճշտություն';

  @override
  String get keyboardShortcuts => 'Ստեղնաշարի դյուրանցումներ';

  @override
  String get keyMoveBackwardOrForward => 'քայլ հետ/առաջ';

  @override
  String get keyGoToStartOrEnd => 'գնալ սկիզբ/վերջ';

  @override
  String get keyCycleSelectedVariation => 'Cycle selected variation';

  @override
  String get keyShowOrHideComments => 'ցույց տալ/թաքցնել մեկնաբանությունները';

  @override
  String get keyEnterOrExitVariation => 'բացել/փակել տարբերակը';

  @override
  String get keyRequestComputerAnalysis => 'Պատվիրեք համակարգչային վերլուծություն, սովորեք սեփական սխալներից';

  @override
  String get keyNextLearnFromYourMistakes => 'Հաջորդը (Սովորեք ձեր սխալներից)';

  @override
  String get keyNextBlunder => 'Հաջորդ վրիպումը';

  @override
  String get keyNextMistake => 'Հաջորդ սխալը';

  @override
  String get keyNextInaccuracy => 'Հաջորդ անճշտությունը';

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
  String get newTournament => 'Նոր մրցաշար';

  @override
  String get tournamentHomeTitle => 'Շախմատի զանազան տարբերակներով և ժամակարգերով մրցաշարեր';

  @override
  String get tournamentHomeDescription => 'Մրցաշարում խաղացե՜ք արագ շախմատ։ Ընտրեք Lichess-ի պաշտոնական մրցաշարերից ցանկացածը կամ ստեղծեք ձերը։ Գնդակ (Bullet), կայծակնային (Blitz), դասական, շախմատ-960 (Ֆիշերի շախմատ, Chess960), արքան կենտրոնում (King of the Hill), երեք շախ (Threecheck) և խաղի այլ տարբերակներ. դրանք կապահովեն ձեր շախմատային հաճույքը։';

  @override
  String get tournamentNotFound => 'Մրցաշարը չի գտնվել';

  @override
  String get tournamentDoesNotExist => 'Այդպիսի մրցաշար գոյություն չունի։';

  @override
  String get tournamentMayHaveBeenCanceled => 'Կարող է չեղարկվել այն դեպքում, եթե բոլոր խաղացողները լքել են այն մինչև մեկնարկը։';

  @override
  String get returnToTournamentsHomepage => 'Մրցաշարերի գլխավոր էջ';

  @override
  String weeklyPerfTypeRatingDistribution(String param) {
    return 'Վարկանիշերի ամենշաբաթյա բաշխում $param-ում';
  }

  @override
  String yourPerfTypeRatingIsRating(String param1, String param2) {
    return 'Ձեր վարկանիշը $param1-ում՝ $param2։';
  }

  @override
  String youAreBetterThanPercentOfPerfTypePlayers(String param1, String param2) {
    return 'Դուք ուժեղ եք $param1 խաղացողից $param2-ում։';
  }

  @override
  String userIsBetterThanPercentOfPerfTypePlayers(String param1, String param2, String param3) {
    return '$param1 ուժեղ է $param2 խաղացողից $param3-ում։';
  }

  @override
  String betterThanPercentPlayers(String param1, String param2) {
    return 'Better than $param1 of $param2 players';
  }

  @override
  String youDoNotHaveAnEstablishedPerfTypeRating(String param) {
    return 'Ձեր վարկանիշը $param-ում դեռ որոշված չէ։';
  }

  @override
  String get yourRating => 'Ձեր վարկանիշը';

  @override
  String get cumulative => 'Ընդամենը';

  @override
  String get glicko2Rating => 'Glicko-2 վարկանիշ';

  @override
  String get checkYourEmail => 'Ստուգեք ձեր էլ. փոստը';

  @override
  String get weHaveSentYouAnEmailClickTheLink => 'Ձեզ նամակ ենք ուղարկել։ Մասնակցային հաշիվն ակտիվացնելու համար սեղմեք նամակում եղած հղումը։';

  @override
  String get ifYouDoNotSeeTheEmailCheckOtherPlaces => 'Եթե նամակը չկա, ստուգեք սպամի և այլ պանակները, որտեղ այն կարող էր հասնել:';

  @override
  String weHaveSentYouAnEmailTo(String param) {
    return 'Մենք նամակ ենք ուղարկել $param։ Կտտացրեք դրա մեջ գտնվող հղմանը՝ ձեր գաղտնաբառը վերականգնելու համար։';
  }

  @override
  String byRegisteringYouAgreeToBeBoundByOur(String param) {
    return 'Գրանցվելով՝ Դուք ստանձնում եք մեր $param հետևելու պարտականությունը:';
  }

  @override
  String readAboutOur(String param) {
    return 'Ծանոթացեք մեր $param։';
  }

  @override
  String get networkLagBetweenYouAndLichess => 'Ձեր և Lichess-ի սերվերների միջև տվյալների փոխանցման հետաձգում:';

  @override
  String get timeToProcessAMoveOnLichessServer => 'Քայլի մշակման ժամանակը Lichess-ի սերվերում';

  @override
  String get downloadAnnotated => 'Ներբեռնել անոտացիաներով';

  @override
  String get downloadRaw => 'Ներբեռնել նախնական տեսքով';

  @override
  String get downloadImported => 'Ներբեռնել ներմուծվածը';

  @override
  String get crosstable => 'Հաշիվ';

  @override
  String get youCanAlsoScrollOverTheBoardToMoveInTheGame => 'Քայլերը թերթելու համար կարելի է մկնիկի անիվը պտտել տախտակի վրա։';

  @override
  String get scrollOverComputerVariationsToPreviewThem => 'Թերթեք տարբերակները դրանք դիտելու համար:';

  @override
  String get analysisShapesHowTo => 'Խաղատախտակի վրա շրջանակներ և սլաքներ պատկերելու համար օգտագործեք Shift+մկնիկի ձախ կոճակը կամ աջ կոճակը։';

  @override
  String get letOtherPlayersMessageYou => 'Թույլ տալ այլ խաղացողներին Ձեզ հաղորդագրություններ ուղարկել';

  @override
  String get receiveForumNotifications => 'Ստանալ ծանուցումներ ֆորումում հիշատակվելու դեպքում';

  @override
  String get shareYourInsightsData => 'Ներկայացրեք Ձեր շախմատային պատկերացումների տվյալները';

  @override
  String get withNobody => 'Ոչ մեկի հետ';

  @override
  String get withFriends => 'Ընկերների հետ';

  @override
  String get withEverybody => 'Բոլորի հետ';

  @override
  String get kidMode => 'Մանկական ռեժիմ';

  @override
  String get kidModeIsEnabled => 'Kid mode is enabled.';

  @override
  String get kidModeExplanation => 'Սա անվտանգության համար է։ Մանկական ռեժիմում անջատված են կայքի հաղորդակցության բոլոր միջոցները։ Միացրեք այս ռեժիմը ձեր երեխաների և աշակերտների համար` նրանց այլ օգտատերերից պաշտպանելու համար։';

  @override
  String inKidModeTheLichessLogoGetsIconX(String param) {
    return 'Մանկական ռեժիմում Lichess-ի պատկերանշանին ավելանում է $param տեսքով նշան, որպեսզի Դուք իմանաք, որ Ձեր երեխաներն անվտանգության մեջ են։';
  }

  @override
  String get askYourChessTeacherAboutLiftingKidMode => 'Ձեր հաշիվը կառավարվում է: Հարցրեք ձեր շախմատի ուսուցիչին երեխաների ռեժիմը հեռացնելու մասին:';

  @override
  String get enableKidMode => 'Միացնել մանկական ռեժիմը';

  @override
  String get disableKidMode => 'Անջատել մանկական ռեժիմը';

  @override
  String get security => 'Անվտանգություն';

  @override
  String get sessions => 'Սեսիաներ';

  @override
  String get revokeAllSessions => 'փակել բոլոր սեսիաները';

  @override
  String get playChessEverywhere => 'Խաղացեք շախմատ ամենուր';

  @override
  String get asFreeAsLichess => 'Անվճար է Lichess-ի պես';

  @override
  String get builtForTheLoveOfChessNotMoney => 'Սիրով շախմատի, այլ ոչ` փողի հանդեպ';

  @override
  String get everybodyGetsAllFeaturesForFree => 'Բոլոր հնարավորությունները բոլորի համար անվճար են';

  @override
  String get zeroAdvertisement => 'Ոչ մի գովազդ';

  @override
  String get fullFeatured => 'Առավելագույն ֆունկցիոնալություն';

  @override
  String get phoneAndTablet => 'Հեռախոսով և պլանշետով';

  @override
  String get bulletBlitzClassical => 'Կայծակնային, արագ, դասական';

  @override
  String get correspondenceChess => 'Նամակագրական շախմատ';

  @override
  String get onlineAndOfflinePlay => 'Առցանց և օֆլայն խաղ';

  @override
  String get viewTheSolution => 'Դիտել լուծումը';

  @override
  String get followAndChallengeFriends => 'Բաժանորդագրություններ և խաղ ընկերների հետ';

  @override
  String get gameAnalysis => 'Խաղի վերլուծություն';

  @override
  String xHostsY(String param1, String param2) {
    return '$param1-ը ստեղծել է $param2-ը';
  }

  @override
  String xJoinsY(String param1, String param2) {
    return '$param1-ը միացել է $param2-ին';
  }

  @override
  String xLikesY(String param1, String param2) {
    return '$param1-ը հավանել է $param2-ին';
  }

  @override
  String get quickPairing => 'Արագ սկիզբ';

  @override
  String get lobby => 'Սպասասրահ';

  @override
  String get anonymous => 'Անանուն';

  @override
  String yourScore(String param) {
    return 'Ձեր հաշիվը՝ $param';
  }

  @override
  String get language => 'Լեզու';

  @override
  String get background => 'Ֆոն';

  @override
  String get light => 'Բաց';

  @override
  String get dark => 'Մուգ';

  @override
  String get transparent => 'Թափանցիկ';

  @override
  String get deviceTheme => 'Սարքի թեման';

  @override
  String get backgroundImageUrl => 'Հետնաշերտի պատկերի հղում`';

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
  String get pieceSet => 'Խաղաքարերի ձևավորումը';

  @override
  String get embedInYourWebsite => 'Ստանալ կոդ՝ կայքում տեղադրելու համար';

  @override
  String get usernameAlreadyUsed => 'Մասնակցային այս անունն արդեն զբաղված է։ Խնդրում ենք փորձել ուրիշը';

  @override
  String get usernamePrefixInvalid => 'Մասնակցային անունը պետք է սկսվի տառով';

  @override
  String get usernameSuffixInvalid => 'Մասնակցային անունը պետք է վերջանա տառով կամ թվով։';

  @override
  String get usernameCharsInvalid => 'Մասնակցային անունը պետք է բաղկացած լինի միայն տառերից, թվերից, ընդգծումներից և գծիկներից։';

  @override
  String get usernameUnacceptable => 'Մասնակցային այս անունն արդեն զբաղված է կամ անթույլատրելի է։.';

  @override
  String get playChessInStyle => 'Շախմատային ոճով';

  @override
  String get chessBasics => 'Շախմատի հիմունքներ';

  @override
  String get coaches => 'Մարզիչներ';

  @override
  String get invalidPgn => 'Ոչ կոռեկտ PGN';

  @override
  String get invalidFen => 'Ոչ կոռեկտ PGN';

  @override
  String get custom => 'Սեփական խաղ';

  @override
  String get notifications => 'Ծանուցումներ';

  @override
  String notificationsX(String param1) {
    return 'Ծանուցումներ: $param1';
  }

  @override
  String perfRatingX(String param) {
    return 'Վարկանիշ՝ $param';
  }

  @override
  String get practiceWithComputer => 'Մարզում համակարգչի հետ';

  @override
  String anotherWasX(String param) {
    return 'Կարելի էր $param';
  }

  @override
  String bestWasX(String param) {
    return 'Ավելի լավ էր $param';
  }

  @override
  String get youBrowsedAway => 'Դուք դուրս եկաք մարզման ռեժիմից';

  @override
  String get resumePractice => 'Վերսկսել մարզումը';

  @override
  String get drawByFiftyMoves => 'Խաղն ավարտվել է ոչ-ոքի հիսուն քայլի կանոնով։';

  @override
  String get theGameIsADraw => 'Խաղն ավարտվեց ոչ-ոքի։';

  @override
  String get computerThinking => 'Համակարգիչը մտածում է...';

  @override
  String get seeBestMove => 'Դիտել լավագույն քայլը';

  @override
  String get hideBestMove => 'Թաքցնել լավագույն քայլը';

  @override
  String get getAHint => 'Օգտվել հուշումից';

  @override
  String get evaluatingYourMove => 'Ձեր քայլի գնահատականը...';

  @override
  String get whiteWinsGame => 'Սպիտակները հաղթեցին';

  @override
  String get blackWinsGame => 'Սևերն հաղթեցին';

  @override
  String get learnFromYourMistakes => 'Սովորիր սխալներից';

  @override
  String get learnFromThisMistake => 'Սովորիր այս սխալից';

  @override
  String get skipThisMove => 'Բաց թողնել այս քայլը';

  @override
  String get next => 'Հաջորդ';

  @override
  String xWasPlayed(String param) {
    return 'Խաղացվել է $param';
  }

  @override
  String get findBetterMoveForWhite => 'Սպիտակների համար գտե՛ք ավելի ուժեղ քայլ';

  @override
  String get findBetterMoveForBlack => 'Սևերի համար գտե՛ք ավելի ուժեղ քայլ';

  @override
  String get resumeLearning => 'Շարունակել սովորել';

  @override
  String get youCanDoBetter => 'Կա ավելի ուժեղ քայլ';

  @override
  String get tryAnotherMoveForWhite => 'Սպիտակների համար փորձե՛ք այլ քայլ';

  @override
  String get tryAnotherMoveForBlack => 'Սևերի համար փորձե՛ք այլ քայլ';

  @override
  String get solution => 'Լուծում';

  @override
  String get waitingForAnalysis => 'Վերլուծության ստացման սպասում';

  @override
  String get noMistakesFoundForWhite => 'Սպիտակների սխալներ չեն գտնվել';

  @override
  String get noMistakesFoundForBlack => 'Սևերի սխալներ չեն գտնվել';

  @override
  String get doneReviewingWhiteMistakes => 'Սպիտակների սխալները վերլուծված են';

  @override
  String get doneReviewingBlackMistakes => 'Սևերի սխալները վերլուծված են';

  @override
  String get doItAgain => 'Կատարել ևս մեկ անգամ';

  @override
  String get reviewWhiteMistakes => 'Վերլուծել սպիտակների սխալները';

  @override
  String get reviewBlackMistakes => 'Վերլուծել սևերի սխալները';

  @override
  String get advantage => 'Առավելություն';

  @override
  String get opening => 'Սկզբնախաղ';

  @override
  String get middlegame => 'Միջնախաղ';

  @override
  String get endgame => 'Վերջնախաղ';

  @override
  String get conditionalPremoves => 'Պայմանական նախաքայլեր';

  @override
  String get addCurrentVariation => 'Ավելացնել ընթացիկ տարբերակը';

  @override
  String get playVariationToCreateConditionalPremoves => 'Պայմանական նախաքայլերն առաջադրելու համար խաղատախտակի վրա կատարեք քայլեր';

  @override
  String get noConditionalPremoves => 'Անպայմանական նախաքայլեր';

  @override
  String playX(String param) {
    return 'Խաղացեք $param';
  }

  @override
  String get showUnreadLichessMessage => 'You have received a private message from Lichess.';

  @override
  String get clickHereToReadIt => 'Click here to read it';

  @override
  String get sorry => 'Ներողություն :(';

  @override
  String get weHadToTimeYouOutForAWhile => 'Մենք ստիպված ենք անջատել Ձեզ որոշ ժամանակով։';

  @override
  String get why => 'Ինչու՞';

  @override
  String get pleasantChessExperience => 'Մեր նպատակը շախմատը բոլորի համար հետաքրքիր դարձնելն է։';

  @override
  String get goodPractice => 'Դրան հասնելու համար մենք պետք է այնպես անենք, որ բոլոր խաղացողները հետևեն բարեկրթության կանոններին։';

  @override
  String get potentialProblem => 'Երբ հայտնաբերում ենք հավանական խնդիր, մենք ցուցադրում ենք այս հաղորդագրությունը։';

  @override
  String get howToAvoidThis => 'Ինչպե՞ս խուսափել սրանից';

  @override
  String get playEveryGame => 'Հասցրե՛ք ավարտին սկսված բոլոր խաղերը։';

  @override
  String get tryToWin => 'Փորձեք հաղթել (կամ գոնե ոչ-ոքի խաղալ) յուրաքանչյուր խաղ։';

  @override
  String get resignLostGames => 'Հանձնվե՛ք պարտված խաղերում (մի\' թողեք ժամանակը սպառվի)։';

  @override
  String get temporaryInconvenience => 'Մենք հայցում ենք Ձեր ներողամտությունը անհարմարության համար,';

  @override
  String get wishYouGreatGames => 'և մաղթում հաճելի հաղեր lichess.org-ում։';

  @override
  String get thankYouForReading => 'Շնորհակալություն կարդալու համար:';

  @override
  String get lifetimeScore => 'Հաշիվը ողջ ընթացքում';

  @override
  String get currentMatchScore => 'Հաշիվն ընթացիկ խաղում';

  @override
  String get agreementAssistance => 'Հաստատում եմ, որ իմ խաղերում երբեք չեմ օգտվի կողմնակի օգնությունից (շախմատային ծրագրերից, գրքերից, տվյալների բազաներից և այլ խաղացողներից)։';

  @override
  String get agreementNice => 'Հաստատում եմ, որ հարգանքով եմ վերաբերվելու այլ խաղացողներին։';

  @override
  String agreementMultipleAccounts(String param) {
    return 'Համաձայն եմ, որ չպետք է ստեղծեմ բազմաթիվ մասնակցային հաշիվներ (բացառությամբ $paramում նշված պատճառների)։';
  }

  @override
  String get agreementPolicy => 'Հաստատում եմ, որ հետևելու եմ Lichess-ի բոլոր կանոններին։';

  @override
  String get searchOrStartNewDiscussion => 'Գտնել քննարկումը կամ ստեղծել նորը';

  @override
  String get edit => 'Խմբագրել';

  @override
  String get bullet => 'Bullet';

  @override
  String get blitz => 'Բլից';

  @override
  String get rapid => 'Արագ';

  @override
  String get classical => 'Դասական';

  @override
  String get ultraBulletDesc => 'Խելահեղորեն արագ պարտիաներ` 30 վայրկյանից պակաս';

  @override
  String get bulletDesc => 'Շատ արագ պարտիաներ` 3 րոպեից պակաս';

  @override
  String get blitzDesc => 'Արագ պարտիաներ` 3-ից 8 րոպե';

  @override
  String get rapidDesc => 'Արագ պարտիաներ` 8-ից 25 րոպե';

  @override
  String get classicalDesc => 'Դասական պարտիաներ` 25 րոպե և ավելի';

  @override
  String get correspondenceDesc => 'Նամակագրական պարտիաներ` մեկ կամ մի քանի օր քայլի համար';

  @override
  String get puzzleDesc => 'Շախմատային տակտիկայի մարզիչ';

  @override
  String get important => 'Կարևոր';

  @override
  String yourQuestionMayHaveBeenAnswered(String param1) {
    return 'Ձեր հարցին հնարավոր է տրվել է $param1 պատասխանը';
  }

  @override
  String get inTheFAQ => 'ՀՏՀ-ում';

  @override
  String toReportSomeoneForCheatingOrBadBehavior(String param1) {
    return 'Օգտատիրոջ խարդախ կամ անպարկեշտ պահվածքը ծանուցելու համար $param1';
  }

  @override
  String get useTheReportForm => 'օգտագործեք հաղորդման ձևը';

  @override
  String toRequestSupport(String param1) {
    return 'Աջակցություն ստանալու համար $param1';
  }

  @override
  String get tryTheContactPage => 'դիտեք կոնտակտային տվյալները';

  @override
  String makeSureToRead(String param1) {
    return 'Մի մոռացեք կարդալ $param1';
  }

  @override
  String get theForumEtiquette => 'ֆորումի վարվելակարգը';

  @override
  String get thisTopicIsArchived => 'Այս թեման տեղափոխվել է արխիվ, և այն այլևս հնարավոր չէ մեկնաբանել։';

  @override
  String joinTheTeamXToPost(String param1) {
    return 'Մուտք գործեք $param1, այս ֆորումում գրելու համար';
  }

  @override
  String teamNamedX(String param1) {
    return '$param1 թիմ';
  }

  @override
  String get youCannotPostYetPlaySomeGames => 'Դուք առայժմ չեք կարող գրել այս ֆորումում։ Խաղացե՛ք մի քանի պարտիա։';

  @override
  String get subscribe => 'Բաժանորդագրվել';

  @override
  String get unsubscribe => 'Ապաբաժանորդագրվել';

  @override
  String mentionedYouInX(String param1) {
    return 'հիշատակել է Ձեզ «$param1»-ում։';
  }

  @override
  String xMentionedYouInY(String param1, String param2) {
    return '$param1-ը հիշատակել է Ձեզ  «$param2»-ում։';
  }

  @override
  String invitedYouToX(String param1) {
    return 'Հրավիրել է Ձեզ «$param1»։';
  }

  @override
  String xInvitedYouToY(String param1, String param2) {
    return '$param1-ը հրավիրել է Ձեզ  «$param2»։';
  }

  @override
  String get youAreNowPartOfTeam => 'Այժմ Դուք ակումբի անդամ եք։';

  @override
  String youHaveJoinedTeamX(String param1) {
    return 'Դուք ընդգրկվել եք «$param1»-ում։';
  }

  @override
  String get someoneYouReportedWasBanned => 'Ինչ-որ մենք արգելափակվել է Ձեր դիմումով';

  @override
  String get congratsYouWon => 'Շնորհավորո՜ւմ ենք, Դուք հաղթեցիք։';

  @override
  String gameVsX(String param1) {
    return 'Խաղ ընդդեմ $param1-ի';
  }

  @override
  String resVsX(String param1, String param2) {
    return '$param1-ն ընդդեմ $param2-ի';
  }

  @override
  String get lostAgainstTOSViolator => 'Դուք պարտվել եք նրան, ով խախտել է Lichess-ի օգտվողի համաձայնագիրը';

  @override
  String refundXpointsTimeControlY(String param1, String param2) {
    return 'Վերադարձ. $param1 $param2 վարկանիշային միավոր';
  }

  @override
  String get timeAlmostUp => 'Ժամանակը գրեթե սպառվել է';

  @override
  String get clickToRevealEmailAddress => '[Սեղմեք՝ էլեկտրոնային փոստի հասցեն բացելու համար]';

  @override
  String get download => 'Ներբեռնել';

  @override
  String get coachManager => 'Մարզիչների համար';

  @override
  String get streamerManager => 'Սթրիմերների համար';

  @override
  String get cancelTournament => 'Չեղարկել մրցաշարը';

  @override
  String get tournDescription => 'Մրցաշարի նկարագրությունը';

  @override
  String get tournDescriptionHelp => 'Անկանու՞մ եք ինչ-որ բան ասել օգտվողներին: Փորձեք լինել հակիրճ. Markdown ձևաչափով հղումները [name](https://url) մատչելի են: ';

  @override
  String get ratedFormHelp => 'Խաղերն ընթանում են վարկանիշի հաշվարկով և ազդում են խաղացողների վարկանիշի վրա';

  @override
  String get onlyMembersOfTeam => 'Միայն ակումբի անդամների համար';

  @override
  String get noRestriction => 'Առանց սահմանափակումների';

  @override
  String get minimumRatedGames => 'Նվազագույն վարկանիշային խաղեր';

  @override
  String get minimumRating => 'Նվազագույն վարկանիշ';

  @override
  String get maximumWeeklyRating => 'Առավելագույն ամենշաբաթյա վարկանիշ';

  @override
  String positionInputHelp(String param) {
    return 'Տեղադրեք FEN-ի ճիշտ տողը, որպեսզի յուրաքանչյուր խաղ սկսվի տվյալ դիրքից:\nՍա աշխատում է միայն ստանդարտ խաղերի համար, բայց ոչ տարբերակների հետ:\nԴուք կարող եք օգտագործել $param՝ FEN դիրքը ստեղծելու համար, այնուհետև տեղադրեք այն այստեղ:\nԴաշտը թողեք դատարկ, որպեսզի խաղերը սկսվեն սովորական մեկնարկային դիրքից:';
  }

  @override
  String get cancelSimul => 'Չեղարկել խաղաշարը';

  @override
  String get simulHostcolor => 'Խաղաշար անցկացնողի գույնը յուրաքանչյուր պարտիայում';

  @override
  String get estimatedStart => 'Խաղաշարը սկսելու նախատեսվող ժամը';

  @override
  String simulFeatured(String param) {
    return 'Ցույց տալ $param-ում';
  }

  @override
  String simulFeaturedHelp(String param) {
    return 'Ցուցադրել խաղաշարը $param-ում։ Անջատեք մասնավոր խաղաշարերի համար։';
  }

  @override
  String get simulDescription => 'Խաղաշարի նկարագրությունը';

  @override
  String get simulDescriptionHelp => 'Ցանկանո՞ւմ եք որևէ բան պատմել մասնակիցներին։';

  @override
  String markdownAvailable(String param) {
    return '$param հասանելի է ընդլայնված ֆորմատավորման համար';
  }

  @override
  String get embedsAvailable => 'Ներդնելու համար տեղադրեք պարտիայի կամ ստուդիայի URL-հասցեն։';

  @override
  String get inYourLocalTimezone => 'Ձեր ժամագոտում';

  @override
  String get tournChat => 'Մրցաշարի զրուցարան';

  @override
  String get noChat => 'Առանց զրուցարանի';

  @override
  String get onlyTeamLeaders => 'Միայն թիմի կազմակերպիչները';

  @override
  String get onlyTeamMembers => 'Միայն թիմի անդամները';

  @override
  String get navigateMoveTree => 'Անցում ըստ քայլերի';

  @override
  String get mouseTricks => 'Շարժումներ մկնիկով';

  @override
  String get toggleLocalAnalysis => 'Միացնել համակարգչային վերլուծությունը';

  @override
  String get toggleAllAnalysis => 'Փոխել համակարգչային վերլուծության բոլոր եղանակները';

  @override
  String get playComputerMove => 'Անել լավագույն համակարգչային քայլը';

  @override
  String get analysisOptions => 'Վերլուծության պարամետրերը';

  @override
  String get focusChat => 'Տեղափոխվել զրուցարանի պատուհան';

  @override
  String get showHelpDialog => 'Ցույց տալ օգնությունը';

  @override
  String get reopenYourAccount => 'Վերաբացեք Ձեր մասնակցային հաշիվը';

  @override
  String get closedAccountChangedMind => 'Եթե Դուք փակել եք Ձեր մասնակցային հաշիվը, բայց մտափոխվել եք, մեկ անգամ այն վերականգնելու հնարավորություն ունեք։';

  @override
  String get onlyWorksOnce => 'Սա կաշխատի միայն մեկ անգամ։';

  @override
  String get cantDoThisTwice => 'Եթե Դուք ևս մեկ անգամ փակեք Ձեր մասնակցային հաշիվը, այն վերաբացելու հնարավորություն այլևս չեք ունենա։';

  @override
  String get emailAssociatedToaccount => 'Այս մասնակցային հաշվին կցված էլ. փոստի հասցեն։';

  @override
  String get sentEmailWithLink => 'Ձեզ ուղարկել ենք հղումով նամակ։';

  @override
  String get tournamentEntryCode => 'Մրցաշարին մասնակցելու կոդ';

  @override
  String get hangOn => 'Սպասե՛ք';

  @override
  String gameInProgress(String param) {
    return 'Դուք խաղի մեջ եք $param-ի հետ։';
  }

  @override
  String get abortTheGame => 'Ընդհատել խաղը';

  @override
  String get resignTheGame => 'Հանձնվել';

  @override
  String get youCantStartNewGame => 'Դուք չեք կարող սկսել նոր խաղ, քանի դեռ չի ավարտվել ընթացիկը։';

  @override
  String get since => 'Սկսած';

  @override
  String get until => 'Մինչև';

  @override
  String get lichessDbExplanation => 'Lichess-ի բոլոր խաղացողների վարկանիշային խաղեր';

  @override
  String get switchSides => 'Փոխել կողմը';

  @override
  String get closingAccountWithdrawAppeal => 'Ձեր մասնակցային հաշվի փակումը կչեղարկի Ձեր դիմումը';

  @override
  String get ourEventTips => 'Մեր խորհուրդները միջոցառումներ կազմակերպելու հարցում';

  @override
  String get instructions => 'Instructions';

  @override
  String get showMeEverything => 'Show me everything';

  @override
  String get lichessPatronInfo => 'Lichess-ը բարեգործական կազմակերպություն է, որը տրամադրում է բաց նախնական կոդով ազատ և անվճար ծրագրային ապահովում։\nՕպերացիոն բոլոր ծախսերը, մշակումները և կոնտենտը ֆինանսավորվում են բացառապես օգտատերերի նվիրաբերությունների հաշվին։';

  @override
  String get nothingToSeeHere => 'Nothing to see here at the moment.';

  @override
  String opponentLeftCounter(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Հակառակորդը լքել է խաղը։ Դուք կարող եք պահանջել հաղթանակ $count վարկյանից։',
      one: 'Հակառակորդը լքել է խաղը։ Դուք կարող եք պահանջել հաղթանակ $count վարկյանից։',
    );
    return '$_temp0';
  }

  @override
  String mateInXHalfMoves(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Մատ $count հատ կիսաքայլից',
      one: 'Մատ $count հատ կիսաքայլից',
    );
    return '$_temp0';
  }

  @override
  String nbBlunders(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count վրիպում',
      one: '$count վրիպում',
    );
    return '$_temp0';
  }

  @override
  String nbMistakes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count սխալ',
      one: '$count սխալ',
    );
    return '$_temp0';
  }

  @override
  String nbInaccuracies(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count անճշտություն',
      one: '$count անճշտություն',
    );
    return '$_temp0';
  }

  @override
  String nbPlayers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Միացած խաղացողների թիվը՝ $count',
      one: 'Միացած խաղացողների թիվը՝ $count',
    );
    return '$_temp0';
  }

  @override
  String nbGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Տեսնել բոլոր $count խաղերը',
      one: 'Տեսնել բոլոր $count խաղերը',
    );
    return '$_temp0';
  }

  @override
  String ratingXOverYGames(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count վարկանիշ $param2 պարտիայի համար',
      one: '$count վարկանիշ $param2 պարտիայի համար',
    );
    return '$_temp0';
  }

  @override
  String nbBookmarks(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Էջանիշեր',
      one: '$count Էջանիշեր',
    );
    return '$_temp0';
  }

  @override
  String nbDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count օր',
      one: '$count օր',
    );
    return '$_temp0';
  }

  @override
  String nbHours(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ժամ',
      one: '$count ժամ',
    );
    return '$_temp0';
  }

  @override
  String nbMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count րոպե',
      one: '$count րոպե',
    );
    return '$_temp0';
  }

  @override
  String rankIsUpdatedEveryNbMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Վարկանիշը թարմացվում է ամեն $count րոպե',
      one: 'Վարկանիշը թարմացվում է ամեն րոպե',
    );
    return '$_temp0';
  }

  @override
  String nbPuzzles(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count խնդիրներ',
      one: '$count խնդիր',
    );
    return '$_temp0';
  }

  @override
  String nbGamesWithYou(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Խաղեր՝ ձեր հետ',
      one: '$count Խաղեր՝ ձեր հետ',
    );
    return '$_temp0';
  }

  @override
  String nbRated(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count վարկանիշային',
      one: '$count վարկանիշային',
    );
    return '$_temp0';
  }

  @override
  String nbWins(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count հաղթանակ',
      one: '$count հաղթանակ',
    );
    return '$_temp0';
  }

  @override
  String nbLosses(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count պարտություն',
      one: '$count պարտություն',
    );
    return '$_temp0';
  }

  @override
  String nbDraws(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ոչ-ոքի',
      one: '$count ոչ-ոքի',
    );
    return '$_temp0';
  }

  @override
  String nbPlaying(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count խաղացվում են',
      one: '$count խաղացվում Է',
    );
    return '$_temp0';
  }

  @override
  String giveNbSeconds(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Տալ $count վայրկան',
      one: 'Տալ $count վայրկան',
    );
    return '$_temp0';
  }

  @override
  String nbTournamentPoints(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count մրցաշարային միավոր',
      one: '$count մրցաշարային միավոր',
    );
    return '$_temp0';
  }

  @override
  String nbStudies(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ուսուցում',
      one: '$count ստուդիա',
    );
    return '$_temp0';
  }

  @override
  String nbSimuls(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count խաղաշար',
      one: '$count խաղաշար',
    );
    return '$_temp0';
  }

  @override
  String moreThanNbRatedGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Վարկանիշային խաղերը՝ ≥ $count',
      one: 'Վարկանիշային խաղերը՝ ≥ $count',
    );
    return '$_temp0';
  }

  @override
  String moreThanNbPerfRatedGames(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Վարկանիշային խաղ $param2-ում ≥ $count',
      one: 'Վարկանիշային խաղ $param2-ում ≥ $count',
    );
    return '$_temp0';
  }

  @override
  String needNbMorePerfGames(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Դուք պետք է խաղաք ևս $count վարկանիշային խաղ $param2-ում',
      one: 'Դուք պետք է խաղաք ևս $count վարկանիշային խաղ $param2-ում',
    );
    return '$_temp0';
  }

  @override
  String needNbMoreGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Դուք պետք է խաղաք ևս $count վարկանիշային խաղ',
      one: 'Դուք պետք է խաղաք ևս $count վարկանիշային խաղ',
    );
    return '$_temp0';
  }

  @override
  String nbImportedGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ներմուծված խաղեր',
      one: '$count ներմուծված խաղեր',
    );
    return '$_temp0';
  }

  @override
  String nbFriendsOnline(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ընկեր առցանց է',
      one: '$count ընկեր առցանց է',
    );
    return '$_temp0';
  }

  @override
  String nbFollowers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count հետևողներ',
      one: '$count հետևողներ',
    );
    return '$_temp0';
  }

  @override
  String nbFollowing(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count հետևում են',
      one: '$count հետևում են',
    );
    return '$_temp0';
  }

  @override
  String lessThanNbMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'ավելի քիչ քան $count րոպե',
      one: 'ավելի քիչ քան $count րոպե',
    );
    return '$_temp0';
  }

  @override
  String nbGamesInPlay(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Ընթանում է $count խաղ',
      one: 'Ընթանում է $count խաղ',
    );
    return '$_temp0';
  }

  @override
  String maximumNbCharacters(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Առավելագույնը՝ $count նշան։',
      one: 'Առավելագույնը՝ $count նշան։',
    );
    return '$_temp0';
  }

  @override
  String blocks(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count արգելափակում',
      one: '$count արգելափակում',
    );
    return '$_temp0';
  }

  @override
  String nbForumPosts(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count հաղորդագրություն ֆորումում',
      one: '$count հաղորդագրություն ֆորումում',
    );
    return '$_temp0';
  }

  @override
  String nbPerfTypePlayersThisWeek(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count խաղացողները $param2-ում այս շաբաթ։',
      one: '$count խաղացողը $param2-ում այս շաբաթ։',
    );
    return '$_temp0';
  }

  @override
  String availableInNbLanguages(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Հասանելի՜ է $count լեզուներով',
      one: 'Հասանելի՜ է $count լեզվով',
    );
    return '$_temp0';
  }

  @override
  String nbSecondsToPlayTheFirstMove(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count վայրկյան առաջին քայլի համար',
      one: '$count վայրկյան առաջին քայլի համար',
    );
    return '$_temp0';
  }

  @override
  String nbSeconds(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count վարկյաններ',
      one: '$count վայրկյան',
    );
    return '$_temp0';
  }

  @override
  String andSaveNbPremoveLines(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'և հիշել $count հաջորդականությունները',
      one: 'և հիշել $count հաջորդականությունը',
    );
    return '$_temp0';
  }

  @override
  String get stormMoveToStart => 'Սկսելու համար քայլ կատարեք';

  @override
  String get stormYouPlayTheWhitePiecesInAllPuzzles => 'Դուք խաղում եք սպիտակ խաղաքարերով բոլոր խնդիրներում';

  @override
  String get stormYouPlayTheBlackPiecesInAllPuzzles => 'Դուք խաղում եք սև խաղաքարերով բոլոր խնդիրներում';

  @override
  String get stormPuzzlesSolved => 'խնդիրներ լուծվել են';

  @override
  String get stormNewDailyHighscore => 'Օրվա նո՛ր ռեկորդ';

  @override
  String get stormNewWeeklyHighscore => 'Շաբաթվա նոր ռեկորդ';

  @override
  String get stormNewMonthlyHighscore => 'Ամսվա նոր ռեկորդ';

  @override
  String get stormNewAllTimeHighscore => 'Բոլոր ժամանակների նոր ռեկորդ';

  @override
  String stormPreviousHighscoreWasX(String param) {
    return 'Նախորդ ռեկորդը եղել է $param';
  }

  @override
  String get stormPlayAgain => 'Խաղալ նորից';

  @override
  String stormHighscoreX(String param) {
    return 'Ռեկորդ՝ $param';
  }

  @override
  String get stormScore => 'Արդյունք';

  @override
  String get stormMoves => 'Քայլ';

  @override
  String get stormAccuracy => 'Ճշգրտություն';

  @override
  String get stormCombo => 'Քոմբո';

  @override
  String get stormTime => 'Ժամանակ';

  @override
  String get stormTimePerMove => 'Ժամանակ քայլին';

  @override
  String get stormHighestSolved => 'Շատ բարդ խնդիր';

  @override
  String get stormPuzzlesPlayed => 'Խաղացված խնդիրներ';

  @override
  String get stormNewRun => 'Նոր փորձ («Բացատ» ստեղն)';

  @override
  String get stormEndRun => 'Ավարտել փորձը («Մուտք» ստեղն)';

  @override
  String get stormHighscores => 'Ռեկորդներ';

  @override
  String get stormViewBestRuns => 'Դիտել լավագույն փորձերը';

  @override
  String get stormBestRunOfDay => 'Օրվա լավագույն փորձը';

  @override
  String get stormRuns => 'Շարքեր';

  @override
  String get stormGetReady => 'Պատրաստվե՜ք';

  @override
  String get stormWaitingForMorePlayers => 'Սպասում ենք այլ խաղացողների...';

  @override
  String get stormRaceComplete => 'Մրցավազքն ավարտված է';

  @override
  String get stormSpectating => 'Դիտում';

  @override
  String get stormJoinTheRace => 'Միանալ մրցավազքին';

  @override
  String get stormStartTheRace => 'Սկսել մրցավազքը';

  @override
  String stormYourRankX(String param) {
    return 'Ձեր տեղը՝ $param';
  }

  @override
  String get stormWaitForRematch => 'Սպասում ենք ռևանշի';

  @override
  String get stormNextRace => 'Հաջորդ մրցավազքը';

  @override
  String get stormJoinRematch => 'Միանալ ռևանշին';

  @override
  String get stormWaitingToStart => 'Սպասում ենք մեկնարկին';

  @override
  String get stormCreateNewGame => 'Ստեղծել նոր խաղ';

  @override
  String get stormJoinPublicRace => 'Մասնակցել ընդհանուր մրցավազքին';

  @override
  String get stormRaceYourFriends => 'Մրցել ընկերների հետ';

  @override
  String get stormSkip => 'բաց թողնել';

  @override
  String get stormSkipHelp => 'Մրցավազքի ընթացքում Դուք կարող եք բաց թողնել մեկ քայլ.';

  @override
  String get stormSkipExplanation => 'Բաց թողնել այս քայլը՝ շարքը պահպանելու համար։ Մրցավազքի ընթացքում կարելի է օգտագործել միայն մեկ անգամ։';

  @override
  String get stormFailedPuzzles => 'Չլուծված խնդիրներ';

  @override
  String get stormSlowPuzzles => 'Երկար լուծելի խնդիրներ';

  @override
  String get stormSkippedPuzzle => 'Բաց թողնված խնդիր';

  @override
  String get stormThisWeek => 'Այս շաբաթ';

  @override
  String get stormThisMonth => 'Այս ամիս';

  @override
  String get stormAllTime => 'Ամբողջ ընթացքում';

  @override
  String get stormClickToReload => 'Հպեք՝ վերագործարկելու համար';

  @override
  String get stormThisRunHasExpired => 'Այս շարքի ժամանակը սպառվե՛լ է:';

  @override
  String get stormThisRunWasOpenedInAnotherTab => 'Այս շարքը բացվել է մեկ ա՛յլ ներդիրում:';

  @override
  String stormXRuns(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count փորձ',
      one: '1 փորձ',
    );
    return '$_temp0';
  }

  @override
  String stormPlayedNbRunsOfPuzzleStorm(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Խաղացվել է $count շարք $param2-ում',
      one: 'Խաղացվել է մեկ շարք $param2-ում',
    );
    return '$_temp0';
  }

  @override
  String get streamerLichessStreamers => 'Lichess-ի հեռարձակողներ';

  @override
  String get studyShareAndExport => 'Տարածել & և արտահանել';

  @override
  String get studyStart => 'Սկսել';
}
