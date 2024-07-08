import 'package:intl/intl.dart' as intl;

import 'l10n.dart';

/// The translations for Korean (`ko`).
class AppLocalizationsKo extends AppLocalizations {
  AppLocalizationsKo([String locale = 'ko']) : super(locale);

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
  String get activityActivity => '활동';

  @override
  String get activityHostedALiveStream => '라이브 스트리밍을 함';

  @override
  String activityRankedInSwissTournament(String param1, String param2) {
    return '$param2에서 $param1등';
  }

  @override
  String get activitySignedUp => 'Lichess에 회원가입함';

  @override
  String activitySupportedNbMonths(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 개월 동안 $param2 에서 lichess.org 을 후원하였습니다.',
    );
    return '$_temp0';
  }

  @override
  String activityPracticedNbPositions(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$param2 에서 총 $count 개의 포지션을 연습하였습니다.',
    );
    return '$_temp0';
  }

  @override
  String activitySolvedNbPuzzles(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '전술 문제 $count 개를 해결하였습니다.',
    );
    return '$_temp0';
  }

  @override
  String activityPlayedNbGames(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '총 $count 회의 $param2 게임을 하였습니다.',
    );
    return '$_temp0';
  }

  @override
  String activityPostedNbMessages(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$param2 에 총 $count 개의 글을 게시하였습니다.',
    );
    return '$_temp0';
  }

  @override
  String activityPlayedNbMoves(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 수를 둠',
    );
    return '$_temp0';
  }

  @override
  String activityInNbCorrespondenceGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count개의 통신전에서',
    );
    return '$_temp0';
  }

  @override
  String activityCompletedNbGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 번의 통신전을 완료하셨습니다.',
    );
    return '$_temp0';
  }

  @override
  String activityFollowedNbPlayers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 명을 팔로우 개시',
    );
    return '$_temp0';
  }

  @override
  String activityGainedNbFollowers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 명의 신규 팔로워를 얻음',
    );
    return '$_temp0';
  }

  @override
  String activityHostedNbSimuls(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 번의 동시대국을 주최함',
    );
    return '$_temp0';
  }

  @override
  String activityJoinedNbSimuls(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 번의 동시대국에 참가함',
    );
    return '$_temp0';
  }

  @override
  String activityCreatedNbStudies(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 건의 연구를 작성함',
    );
    return '$_temp0';
  }

  @override
  String activityCompetedInNbTournaments(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 번 토너먼트에 참가함',
    );
    return '$_temp0';
  }

  @override
  String activityRankedInTournament(int count, String param2, String param3, String param4) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 위 (상위 $param2%)  ($param4 에서 $param3 국)',
    );
    return '$_temp0';
  }

  @override
  String activityCompetedInNbSwissTournaments(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 번 토너먼트에 참가함',
    );
    return '$_temp0';
  }

  @override
  String activityJoinedNbTeams(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 팀에 참가함',
    );
    return '$_temp0';
  }

  @override
  String get broadcastBroadcasts => '방송';

  @override
  String get broadcastLiveBroadcasts => '실시간 대회 방송';

  @override
  String challengeChallengesX(String param1) {
    return '도전: $param1';
  }

  @override
  String get challengeChallengeToPlay => '도전 신청';

  @override
  String get challengeChallengeDeclined => '도전 거절됨';

  @override
  String get challengeChallengeAccepted => '도전 수락!';

  @override
  String get challengeChallengeCanceled => '도전 취소됨.';

  @override
  String get challengeRegisterToSendChallenges => '도전을 하려면 가입하십시오.';

  @override
  String challengeYouCannotChallengeX(String param) {
    return '$param에게는 도전할 수 없습니다.';
  }

  @override
  String challengeXDoesNotAcceptChallenges(String param) {
    return '$param가 도전을 받아들이지 않았습니다.';
  }

  @override
  String challengeYourXRatingIsTooFarFromY(String param1, String param2) {
    return '당신의 레이팅 등급인 $param1과 상대의 레이팅 등급인 $param2과의 격차가 너무 큽니다.';
  }

  @override
  String challengeCannotChallengeDueToProvisionalXRating(String param) {
    return '$param 가 아직 레이팅이 확정되지 않아서 도전하실 수 없습니다.';
  }

  @override
  String challengeXOnlyAcceptsChallengesFromFriends(String param) {
    return '$param님은 친구인 상대만 도전을 받아들입니다.';
  }

  @override
  String get challengeDeclineGeneric => '지금 도전을 받지 않습니다.';

  @override
  String get challengeDeclineLater => '시간이 맞지 않습니다. 나중에 다시 요청해주세요.';

  @override
  String get challengeDeclineTooFast => '시간이 너무 짧습니다. 더 긴 게임으로 신청해주세요.';

  @override
  String get challengeDeclineTooSlow => '시간이 너무 깁니다. 더 빠른 게임으로 신청해주세요.';

  @override
  String get challengeDeclineTimeControl => '이 시간으로는 도전을 받지 않습니다.';

  @override
  String get challengeDeclineRated => '대신 레이팅 대전을 신청해주세요.';

  @override
  String get challengeDeclineCasual => '대신 캐주얼 대전을 신청해주세요.';

  @override
  String get challengeDeclineStandard => '지금은 변형 체스 도전을 받지 않고 있습니다.';

  @override
  String get challengeDeclineVariant => '지금은 이 변형 체스를 하고 싶지 않습니다.';

  @override
  String get challengeDeclineNoBot => '봇의 도전은 받지 않습니다.';

  @override
  String get challengeDeclineOnlyBot => '봇의 도전만 받고 있습니다.';

  @override
  String get challengeInviteLichessUser => '또는 Lichess 사용자를 초대합니다:';

  @override
  String get contactContact => '문의';

  @override
  String get contactContactLichess => 'Lichess에 문의하기';

  @override
  String get patronDonate => '기부';

  @override
  String get patronLichessPatron => 'Lichess 후원자';

  @override
  String perfStatPerfStats(String param) {
    return '$param 통계';
  }

  @override
  String get perfStatViewTheGames => '게임 보기';

  @override
  String get perfStatProvisional => '임시';

  @override
  String get perfStatNotEnoughRatedGames => '신뢰할만한 레이팅을 설정하기에 충분한 만큼의 레이팅 게임을 플레이하지 않았습니다.';

  @override
  String perfStatProgressOverLastXGames(String param) {
    return '최근 $param 게임 동안:';
  }

  @override
  String perfStatRatingDeviation(String param) {
    return '레이팅 편차: $param.';
  }

  @override
  String perfStatRatingDeviationTooltip(String param1, String param2, String param3) {
    return '낮은 값일 수록 레이팅이 안정적입니다. $param1 이상이라면 임시 레이팅으로 간주합니다. 랭킹에 들기 위해서는 이 값이 $param2 (스탠다드 체스) 또는 $param3 (변형 체스) 보다 낮아야 합니다.';
  }

  @override
  String get perfStatTotalGames => '총 게임';

  @override
  String get perfStatRatedGames => '레이팅 게임';

  @override
  String get perfStatTournamentGames => '토너먼트 게임';

  @override
  String get perfStatBerserkedGames => '버서크 게임';

  @override
  String get perfStatTimeSpentPlaying => '플레이한 시간';

  @override
  String get perfStatAverageOpponent => '상대의 평균 레이팅';

  @override
  String get perfStatVictories => '승리';

  @override
  String get perfStatDefeats => '패배';

  @override
  String get perfStatDisconnections => '연결 끊김';

  @override
  String get perfStatNotEnoughGames => '충분한 게임을 하지 않으셨습니다';

  @override
  String perfStatHighestRating(String param) {
    return '최고 레이팅: $param';
  }

  @override
  String perfStatLowestRating(String param) {
    return '최저 레이팅: $param';
  }

  @override
  String perfStatFromXToY(String param1, String param2) {
    return '$param1에서 $param2';
  }

  @override
  String get perfStatWinningStreak => '연승';

  @override
  String get perfStatLosingStreak => '연패';

  @override
  String perfStatLongestStreak(String param) {
    return '최고 기록: $param';
  }

  @override
  String perfStatCurrentStreak(String param) {
    return '현재 기록: $param';
  }

  @override
  String get perfStatBestRated => '승리한 최고 레이팅';

  @override
  String get perfStatGamesInARow => '연속 게임 플레이';

  @override
  String get perfStatLessThanOneHour => '게임 사이가 1시간 미만인 경우';

  @override
  String get perfStatMaxTimePlaying => '게임을 한 최대 시간';

  @override
  String get perfStatNow => '지금';

  @override
  String get preferencesPreferences => '설정';

  @override
  String get preferencesDisplay => '화면';

  @override
  String get preferencesPrivacy => '프라이버시';

  @override
  String get preferencesNotifications => '공지 사항';

  @override
  String get preferencesPieceAnimation => '기물 움직임 애니메이션';

  @override
  String get preferencesMaterialDifference => '기물 차이';

  @override
  String get preferencesBoardHighlights => '보드 하이라이트 (마지막 수 및 체크)';

  @override
  String get preferencesPieceDestinations => '기물 착지점 (유효한 움직임 및 미리두기)';

  @override
  String get preferencesBoardCoordinates => '보드 좌표 (A-H, 1-8)';

  @override
  String get preferencesMoveListWhilePlaying => '피스 움직임 기록';

  @override
  String get preferencesPgnPieceNotation => 'PGN 기물표기방식';

  @override
  String get preferencesChessPieceSymbol => '체스 말 기호';

  @override
  String get preferencesPgnLetter => '알파벳 (K, Q, R, B, N)';

  @override
  String get preferencesZenMode => '젠 모드';

  @override
  String get preferencesShowPlayerRatings => '플레이어 레이팅 보기';

  @override
  String get preferencesShowFlairs => '플레이어 레이팅 보기';

  @override
  String get preferencesExplainShowPlayerRatings => '체스에 집중할 수 있도록 웹사이트에서 레이팅을 모두 숨깁니다. 경기는 여전히 레이팅에 반영될 것이며, 눈으로 보이는 정보에만 영향을 줍니다.';

  @override
  String get preferencesDisplayBoardResizeHandle => '보드 크기 재조정 핸들 보이기';

  @override
  String get preferencesOnlyOnInitialPosition => '초기 상태에서만';

  @override
  String get preferencesInGameOnly => '게임 도중에만 적용';

  @override
  String get preferencesChessClock => '체스 시계';

  @override
  String get preferencesTenthsOfSeconds => '1/10초 단위';

  @override
  String get preferencesWhenTimeRemainingLessThanTenSeconds => '남은 시간이 10초 미만일 때';

  @override
  String get preferencesHorizontalGreenProgressBars => '녹색 수평 진행 바';

  @override
  String get preferencesSoundWhenTimeGetsCritical => '시간이 얼마 안 남았을 때 소리 재생';

  @override
  String get preferencesGiveMoreTime => '시간 더 주기';

  @override
  String get preferencesGameBehavior => '게임 동작';

  @override
  String get preferencesHowDoYouMovePieces => '기물을 어떻게 움직이나요?';

  @override
  String get preferencesClickTwoSquares => '현재 위치와 원하는 위치에 클릭하기';

  @override
  String get preferencesDragPiece => '드래그';

  @override
  String get preferencesBothClicksAndDrag => '아무 방법으로';

  @override
  String get preferencesPremovesPlayingDuringOpponentTurn => '미리두기 (상대 턴일 때 수를 두기)';

  @override
  String get preferencesTakebacksWithOpponentApproval => '무르기 (상대 승인과 함께)';

  @override
  String get preferencesInCasualGamesOnly => '캐주얼 모드에서만';

  @override
  String get preferencesPromoteToQueenAutomatically => '퀸으로 자동 승진';

  @override
  String get preferencesExplainPromoteToQueenAutomatically => '일시적으로 자동 승진을 끄기 위해 승진하는 동안 <ctrl>를 누르세요';

  @override
  String get preferencesWhenPremoving => '미리둘 때만';

  @override
  String get preferencesClaimDrawOnThreefoldRepetitionAutomatically => '3회 동형반복시 자동으로 무승부 요청';

  @override
  String get preferencesWhenTimeRemainingLessThanThirtySeconds => '남은 시간이 30초 미만일 때만';

  @override
  String get preferencesMoveConfirmation => '피스를 움직이기 전에 물음';

  @override
  String get preferencesExplainCanThenBeTemporarilyDisabled => 'Can be disabled during a game with the board menu';

  @override
  String get preferencesInCorrespondenceGames => '긴 대국에서만';

  @override
  String get preferencesCorrespondenceAndUnlimited => '긴 대국과 무제한';

  @override
  String get preferencesConfirmResignationAndDrawOffers => '기권 또는 무승부 제안시 물음';

  @override
  String get preferencesCastleByMovingTheKingTwoSquaresOrOntoTheRook => '캐슬링 방법';

  @override
  String get preferencesCastleByMovingTwoSquares => '왕을 2칸 옮기기';

  @override
  String get preferencesCastleByMovingOntoTheRook => '킹을 룩한테 이동';

  @override
  String get preferencesInputMovesWithTheKeyboard => '키보드 입력';

  @override
  String get preferencesInputMovesWithVoice => '음성으로 기물 이동';

  @override
  String get preferencesSnapArrowsToValidMoves => '적법한 움직임에만 화살표를 그림';

  @override
  String get preferencesSayGgWpAfterLosingOrDrawing => '패배하거나 무승부 시 \"Good game, well played\"라고 말합니다.';

  @override
  String get preferencesYourPreferencesHaveBeenSaved => '설정이 저장되었습니다.';

  @override
  String get preferencesScrollOnTheBoardToReplayMoves => '보드에서 스크롤을 해서 수를 앞 뒤로 이동';

  @override
  String get preferencesCorrespondenceEmailNotification => '매일 일간 게임의 목록을 보여주는 알림 메일을 받기';

  @override
  String get preferencesNotifyStreamStart => '스트리머가 생방송 시작';

  @override
  String get preferencesNotifyInboxMsg => '새로운 받은 편지함 메시지';

  @override
  String get preferencesNotifyForumMention => '포럼 댓글에서 당신이 언급됨';

  @override
  String get preferencesNotifyInvitedStudy => '스터디 초대';

  @override
  String get preferencesNotifyGameEvent => '긴 대국 업데이트';

  @override
  String get preferencesNotifyChallenge => '도전 과제';

  @override
  String get preferencesNotifyTournamentSoon => '곧 토너먼트 시작할 때';

  @override
  String get preferencesNotifyTimeAlarm => '긴 대국 시간 초과';

  @override
  String get preferencesNotifyBell => '리체스 내에서 벨 알림';

  @override
  String get preferencesNotifyPush => '리체스를 사용하지 않을 때 기기 알림';

  @override
  String get preferencesNotifyWeb => '브라우저';

  @override
  String get preferencesNotifyDevice => '기기 정보';

  @override
  String get preferencesBellNotificationSound => '벨 알림 음';

  @override
  String get puzzlePuzzles => '퍼즐';

  @override
  String get puzzlePuzzleThemes => '퍼즐 테마';

  @override
  String get puzzleRecommended => '추천';

  @override
  String get puzzlePhases => '단계';

  @override
  String get puzzleMotifs => '모티브';

  @override
  String get puzzleAdvanced => '고급';

  @override
  String get puzzleLengths => '길이';

  @override
  String get puzzleMates => '체크메이트';

  @override
  String get puzzleGoals => '목표';

  @override
  String get puzzleOrigin => '출처';

  @override
  String get puzzleSpecialMoves => '특수 행마';

  @override
  String get puzzleDidYouLikeThisPuzzle => '이 퍼즐이 괜찮았나요?';

  @override
  String get puzzleVoteToLoadNextOne => '다음 퍼즐을 위해 투표해주세요!';

  @override
  String get puzzleUpVote => '퍼즐 추천';

  @override
  String get puzzleDownVote => '퍼즐 비추천';

  @override
  String get puzzleYourPuzzleRatingWillNotChange => '당신의 퍼즐 레이팅은 바뀌지 않을 것입니다. 퍼즐은 경쟁이 아니라는 걸 기억하세요. 레이팅은 당신의 현재 스킬에 맞는 퍼즐을 선택하도록 돕습니다.';

  @override
  String get puzzleFindTheBestMoveForWhite => '백의 최고의 수를 찾아보세요.';

  @override
  String get puzzleFindTheBestMoveForBlack => '흑의 최고의 수를 찾아보세요.';

  @override
  String get puzzleToGetPersonalizedPuzzles => '개인화된 퍼즐을 위해선:';

  @override
  String puzzlePuzzleId(String param) {
    return '퍼즐 $param';
  }

  @override
  String get puzzlePuzzleOfTheDay => '오늘의 퍼즐';

  @override
  String get puzzleDailyPuzzle => '일일 퍼즐';

  @override
  String get puzzleClickToSolve => '퍼즐 풀기';

  @override
  String get puzzleGoodMove => '좋은 수 입니다.';

  @override
  String get puzzleBestMove => '가장 좋은 수입니다!';

  @override
  String get puzzleKeepGoing => '계속하세요...';

  @override
  String get puzzlePuzzleSuccess => '성공!';

  @override
  String get puzzlePuzzleComplete => '퍼즐 완료!';

  @override
  String get puzzleByOpenings => '오프닝별';

  @override
  String get puzzlePuzzlesByOpenings => '오프닝별 퍼즐';

  @override
  String get puzzleOpeningsYouPlayedTheMost => '레이팅 게임에서 가장 많이 플레이한 오프닝';

  @override
  String get puzzleUseFindInPage => '브라우저의 \"페이지에서 찾기\" 메뉴를 이용해 가장 좋아하는 오프닝을 찾으세요!';

  @override
  String get puzzleUseCtrlF => 'Ctrl+f를 사용해서 가장 좋아하는 오프닝을 찾으세요!';

  @override
  String get puzzleNotTheMove => '답이 아닙니다!';

  @override
  String get puzzleTrySomethingElse => '다른 것 시도하기';

  @override
  String puzzleRatingX(String param) {
    return '레이팅: $param';
  }

  @override
  String get puzzleHidden => '숨겨짐';

  @override
  String puzzleFromGameLink(String param) {
    return '게임 $param에서';
  }

  @override
  String get puzzleContinueTraining => '연습 계속하기';

  @override
  String get puzzleDifficultyLevel => '난이도';

  @override
  String get puzzleNormal => '보통';

  @override
  String get puzzleEasier => '쉬움';

  @override
  String get puzzleEasiest => '매우 쉬움';

  @override
  String get puzzleHarder => '어려움';

  @override
  String get puzzleHardest => '매우 어려움';

  @override
  String get puzzleExample => '예시';

  @override
  String get puzzleAddAnotherTheme => '새 테마 추가';

  @override
  String get puzzleNextPuzzle => '다음 퍼즐';

  @override
  String get puzzleJumpToNextPuzzleImmediately => '다음 퍼즐로 즉시 이동';

  @override
  String get puzzlePuzzleDashboard => '퍼즐 대시보드';

  @override
  String get puzzleImprovementAreas => '개선이 필요한 부분';

  @override
  String get puzzleStrengths => '강점';

  @override
  String get puzzleHistory => '퍼즐 히스토리';

  @override
  String get puzzleSolved => '해결함';

  @override
  String get puzzleFailed => '실패함';

  @override
  String get puzzleStreakDescription => '점점 더 어려워지는 퍼즐을 풀고 연승을 쌓으세요. 시간 제한은 없습니다. 한번의 잘못된 수 만으로 게임이 끝납니다! 그러나 세션당 한 수를 건너 뛸 수 있습니다.';

  @override
  String puzzleYourStreakX(String param) {
    return '연승 기록: $param';
  }

  @override
  String get puzzleStreakSkipExplanation => '이 수를 건너뛰고 연승 기록을 보존하세요! 한 도전에 한 번만 가능합니다.';

  @override
  String get puzzleContinueTheStreak => '계속하기';

  @override
  String get puzzleNewStreak => '새 연승 도전';

  @override
  String get puzzleFromMyGames => '내 게임에서';

  @override
  String get puzzleLookupOfPlayer => '플레이어의 게임들에서 퍼즐을 찾습니다';

  @override
  String puzzleFromXGames(String param) {
    return '$param의 게임에서의 퍼즐';
  }

  @override
  String get puzzleSearchPuzzles => '퍼즐 찾기';

  @override
  String get puzzleFromMyGamesNone => '데이터베이스에 퍼즐이 없습니다만, Lichess는 여전히 당신을 사랑합니다.\n래피드나 클래시컬 게임을 플레이해서 당신의 퍼즐이 추가될 확률을 높이세요!';

  @override
  String puzzleFromXGamesFound(String param1, String param2) {
    return '$param2의 게임에서 찾은 $param1개의 퍼즐';
  }

  @override
  String get puzzlePuzzleDashboardDescription => '훈련, 분석, 개선';

  @override
  String puzzlePercentSolved(String param) {
    return '$param 해결함';
  }

  @override
  String get puzzleNoPuzzlesToShow => '표시할 것이 없습니다. 먼저 퍼즐을 플레이하세요!';

  @override
  String get puzzleImprovementAreasDescription => '실력을 높이기 위해 훈련하세요!';

  @override
  String get puzzleStrengthDescription => '이 테마에서 최고의 성적을 냈습니다';

  @override
  String puzzlePlayedXTimes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count회 플레이',
    );
    return '$_temp0';
  }

  @override
  String puzzleNbPointsBelowYourPuzzleRating(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '당신의 퍼즐 레이팅보다 $count 포인트 낮음',
    );
    return '$_temp0';
  }

  @override
  String puzzleNbPointsAboveYourPuzzleRating(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '당신의 퍼즐 레이팅보다 $count 포인트 높음',
    );
    return '$_temp0';
  }

  @override
  String puzzleNbPlayed(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 플레이함',
    );
    return '$_temp0';
  }

  @override
  String puzzleNbToReplay(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 다시 풀기',
    );
    return '$_temp0';
  }

  @override
  String get puzzleThemeAdvancedPawn => '전진한 폰';

  @override
  String get puzzleThemeAdvancedPawnDescription => '상대방 진영에 깊숙히 전진한 폰이 승급을 노립니다.';

  @override
  String get puzzleThemeAdvantage => '이점';

  @override
  String get puzzleThemeAdvantageDescription => '결정적인 이점을 쟁취하세요. (200cp ≤ eval ≤ 600cp)';

  @override
  String get puzzleThemeAnastasiaMate => '아나스타시아 메이트';

  @override
  String get puzzleThemeAnastasiaMateDescription => '나이트와 룩 또는 퀸이 힘을 합쳐 상대 킹을 보드 가장자리와 자신의 기물 사이의 함정에 빠트립니다.';

  @override
  String get puzzleThemeArabianMate => '아라비안 메이트';

  @override
  String get puzzleThemeArabianMateDescription => '나이트와 룩이 힘을 합쳐 상대 킹을 보드 구석에서 함정에 빠트립니다.';

  @override
  String get puzzleThemeAttackingF2F7 => 'f2나 f7 공격하기';

  @override
  String get puzzleThemeAttackingF2F7Description => 'f2나 f7 칸의 폰을 노리고 공격합니다. 예시: 프라이드 리버 오프닝.';

  @override
  String get puzzleThemeAttraction => '유인';

  @override
  String get puzzleThemeAttractionDescription => '희생이나 교환을 통해 상대 기물을 후속 전술이 있는 칸으로 끌어냅니다.';

  @override
  String get puzzleThemeBackRankMate => '백 랭크 메이트';

  @override
  String get puzzleThemeBackRankMateDescription => '킹이 자신의 기물들에게 막혀 마지막 랭크에서 체크메이트 당합니다.';

  @override
  String get puzzleThemeBishopEndgame => '비숍 엔드게임';

  @override
  String get puzzleThemeBishopEndgameDescription => '비숍과 폰만 있는 엔드게임';

  @override
  String get puzzleThemeBodenMate => '보든 메이트';

  @override
  String get puzzleThemeBodenMateDescription => '자신의 기물에 막힌 킹에게 두 비숍이 X자로 대각선을 막아 메이트를 합니다.';

  @override
  String get puzzleThemeCastling => '캐슬링';

  @override
  String get puzzleThemeCastlingDescription => '왕을 안전하게 피신시키고, 룩을 이용해 공격 태세를 갖춥니다.';

  @override
  String get puzzleThemeCapturingDefender => '보호하는 기물을 제거하세요.';

  @override
  String get puzzleThemeCapturingDefenderDescription => '다른 기물을 방어중인 기물을 잡아서 다음 수에 더 이상 방어되지 않는 기물을 잡을 수 있게 됩니다.';

  @override
  String get puzzleThemeCrushing => '박살내기';

  @override
  String get puzzleThemeCrushingDescription => '상대의 블런더를 포착하고 박살내어 이득을 얻으세요. (eval ≥ 600cp)';

  @override
  String get puzzleThemeDoubleBishopMate => '2비숍 메이트';

  @override
  String get puzzleThemeDoubleBishopMateDescription => '자신의 기물에 막힌 킹에게 두 비숍이 인접한 대각선을 막아 메이트를 합니다.';

  @override
  String get puzzleThemeDovetailMate => '도브테일 메이트';

  @override
  String get puzzleThemeDovetailMateDescription => '퀸이 킹 바로 옆에서 메이트를 합니다. 유일하게 빠져나갈 수 있는 두 칸은 자신의 기물에게 막혀 있습니다.';

  @override
  String get puzzleThemeEquality => '동등함';

  @override
  String get puzzleThemeEqualityDescription => '불리한 상황에서 벗어나 무승부 또는 균형잡힌 포지션으로 만드세요. (eval ≤ 200cp)';

  @override
  String get puzzleThemeKingsideAttack => '킹사이드 공격';

  @override
  String get puzzleThemeKingsideAttackDescription => '상대 킹이 킹사이드 캐슬링을 한 뒤의 공격.';

  @override
  String get puzzleThemeClearance => '정리';

  @override
  String get puzzleThemeClearanceDescription => '이어지는 전술적 아이디어를 위해 칸, 파일 또는 대각선을 비우는 수입니다.';

  @override
  String get puzzleThemeDefensiveMove => '방어적인 수';

  @override
  String get puzzleThemeDefensiveMoveDescription => '기물을 잃거나 다른 손실을 피하기 위해 필요한 정확한 수입니다.';

  @override
  String get puzzleThemeDeflection => '유인';

  @override
  String get puzzleThemeDeflectionDescription => '중요한 칸을 수비하는 등 다른 역할을 수행하는 상대 기물의 주의를 분산시키는 수입니다. \"과부하\"라고도 불립니다.';

  @override
  String get puzzleThemeDiscoveredAttack => '디스커버드 어택';

  @override
  String get puzzleThemeDiscoveredAttackDescription => '장거리 기물(예: 룩)의 길을 막고 있는 기물(예: 나이트)을 이동시켜 공격합니다.';

  @override
  String get puzzleThemeDoubleCheck => '더블 체크';

  @override
  String get puzzleThemeDoubleCheckDescription => '움직인 기물과 그 뒤에 있던 기물이 모두 상대 킹을 공격한 디스커버 어택의 결과로, 두 기물이 동시에 체크를 합니다.';

  @override
  String get puzzleThemeEndgame => '엔드게임';

  @override
  String get puzzleThemeEndgameDescription => '게임 종반부에서의 전략';

  @override
  String get puzzleThemeEnPassantDescription => '앙파상 규칙을 포함한 전술입니다. 상대 폰이 처음에 두 칸 이동해서 내 폰을 지나쳤을 경우, 그 폰을 잡을 수 있습니다.';

  @override
  String get puzzleThemeExposedKing => '노출된 킹';

  @override
  String get puzzleThemeExposedKingDescription => '주변에 방어자가 얼마 없는 킹에 대한 전술입니다. 종종 체크메이트가 되기도 합니다.';

  @override
  String get puzzleThemeFork => '포크';

  @override
  String get puzzleThemeForkDescription => '이동한 기물이 두 개의 상대 기물을 동시에 공격하는 수입니다.';

  @override
  String get puzzleThemeHangingPiece => '보호받지 않는 기물';

  @override
  String get puzzleThemeHangingPieceDescription => '상대 기물이 지켜지지 않거나 불충분하게 지켜져 공짜로 잡을 수 있는 전술입니다.';

  @override
  String get puzzleThemeHookMate => '훅 메이트';

  @override
  String get puzzleThemeHookMateDescription => '상대의 폰에 의해 탈출로가 막힌 킹을 룩, 나이트, 폰으로 체크메이트 합니다.';

  @override
  String get puzzleThemeInterference => '간섭';

  @override
  String get puzzleThemeInterferenceDescription => '상대의 두 기물 사이에 기물을 집어넣어 그 기물들을 지켜지지 않게 만듭니다. 두 룩 사이의 나이트처럼요.';

  @override
  String get puzzleThemeIntermezzo => '사잇수';

  @override
  String get puzzleThemeIntermezzoDescription => '예상되는 플레이를 하는 대신, 먼저 상대가 즉시 해결해야 하는 또 다른 위협을 끼워 넣습니다. \"Zwischenzug\"나 \"In between\"이라고도 합니다.';

  @override
  String get puzzleThemeKnightEndgame => '나이트 엔딩';

  @override
  String get puzzleThemeKnightEndgameDescription => '나이트와 폰만 있는 엔드게임';

  @override
  String get puzzleThemeLong => '긴 퍼즐';

  @override
  String get puzzleThemeLongDescription => '승리까지 세 수 걸립니다.';

  @override
  String get puzzleThemeMaster => '마스터 게임';

  @override
  String get puzzleThemeMasterDescription => '타이틀 보유 플레이어의 게임에서 나온 퍼즐입니다.';

  @override
  String get puzzleThemeMasterVsMaster => '마스터 vs 마스터 게임';

  @override
  String get puzzleThemeMasterVsMasterDescription => '타이틀 보유 플레이어 간의 게임에서 나온 퍼즐입니다.';

  @override
  String get puzzleThemeMate => '체크메이트';

  @override
  String get puzzleThemeMateDescription => '게임을 승리하세요.';

  @override
  String get puzzleThemeMateIn1 => '1수 메이트';

  @override
  String get puzzleThemeMateIn1Description => '한 수만에 체크메이트하세요.';

  @override
  String get puzzleThemeMateIn2 => '2수 메이트';

  @override
  String get puzzleThemeMateIn2Description => '두 수만에 체크메이트하세요.';

  @override
  String get puzzleThemeMateIn3 => '3수 메이트';

  @override
  String get puzzleThemeMateIn3Description => '세 수만에 체크메이트하세요.';

  @override
  String get puzzleThemeMateIn4 => '4수 메이트';

  @override
  String get puzzleThemeMateIn4Description => '네 수만에 체크메이트하세요.';

  @override
  String get puzzleThemeMateIn5 => '5수+ 메이트';

  @override
  String get puzzleThemeMateIn5Description => '긴 체크메이트를 찾아내세요.';

  @override
  String get puzzleThemeMiddlegame => '미들게임';

  @override
  String get puzzleThemeMiddlegameDescription => '게임 중반부에서의 전략';

  @override
  String get puzzleThemeOneMove => '1수 퍼즐';

  @override
  String get puzzleThemeOneMoveDescription => '한 수짜리 퍼즐입니다.';

  @override
  String get puzzleThemeOpening => '오프닝';

  @override
  String get puzzleThemeOpeningDescription => '게임 초반부에서의 전략';

  @override
  String get puzzleThemePawnEndgame => '폰 엔드게임';

  @override
  String get puzzleThemePawnEndgameDescription => '폰만 있는 엔드게임.';

  @override
  String get puzzleThemePin => '핀';

  @override
  String get puzzleThemePinDescription => '더 높은 가치의 기물이 공격받게 되기 때문에 기물을 움직이지 못하게 하는 전술입니다.';

  @override
  String get puzzleThemePromotion => '프로모션';

  @override
  String get puzzleThemePromotionDescription => '폰을 퀸이나 다른 기물로 승진';

  @override
  String get puzzleThemeQueenEndgame => '퀸 엔딩';

  @override
  String get puzzleThemeQueenEndgameDescription => '퀸과 폰만 있는 엔드게임';

  @override
  String get puzzleThemeQueenRookEndgame => '퀸과 룩';

  @override
  String get puzzleThemeQueenRookEndgameDescription => '퀸과 룩, 폰만 있는 엔드게임';

  @override
  String get puzzleThemeQueensideAttack => '퀸사이드 공격';

  @override
  String get puzzleThemeQueensideAttackDescription => '상대 킹이 퀸사이드 캐슬링을 한 뒤의 공격.';

  @override
  String get puzzleThemeQuietMove => '조용한 수';

  @override
  String get puzzleThemeQuietMoveDescription => '체크 또는 기물을 잡는 수가 아니지만 나중에 피할 수 없는 위협을 준비하는 수입니다.';

  @override
  String get puzzleThemeRookEndgame => '룩 엔딩';

  @override
  String get puzzleThemeRookEndgameDescription => '룩과 폰만 있는 엔드게임';

  @override
  String get puzzleThemeSacrifice => '희생';

  @override
  String get puzzleThemeSacrificeDescription => '일련의 강제수로 이득을 얻기 위해 단기적으로 기물을 포기하는 전술입니다.';

  @override
  String get puzzleThemeShort => '짧은 퍼즐';

  @override
  String get puzzleThemeShortDescription => '승리까지 두 수 걸립니다.';

  @override
  String get puzzleThemeSkewer => '스큐어';

  @override
  String get puzzleThemeSkewerDescription => '높은 가치의 기물을 공격해 길을 비키게 만들고, 그 뒤에 있는 낮은 가치의 기물을 잡는 전술입니다. 핀의 반대죠.';

  @override
  String get puzzleThemeSmotheredMate => '질식 체크메이트';

  @override
  String get puzzleThemeSmotheredMateDescription => '자신의 기물에 둘러쌓여(또는 \"질식되어\") 움직일 수 없는 킹을 나이트로 체크메이트 시키는 것 입니다.';

  @override
  String get puzzleThemeSuperGM => '슈퍼GM 게임';

  @override
  String get puzzleThemeSuperGMDescription => '세계 최고 플레이어들의 게임에서 나온 퍼즐입니다.';

  @override
  String get puzzleThemeTrappedPiece => '갇힌 기물';

  @override
  String get puzzleThemeTrappedPieceDescription => '기물의 움직임이 제한되어 있어 잡히는걸 막을 수 없습니다.';

  @override
  String get puzzleThemeUnderPromotion => '하향 승진';

  @override
  String get puzzleThemeUnderPromotionDescription => '나이트, 비숍, 룩으로 승진';

  @override
  String get puzzleThemeVeryLong => '아주 긴 퍼즐';

  @override
  String get puzzleThemeVeryLongDescription => '승리까지 네 수 이상이 걸립니다.';

  @override
  String get puzzleThemeXRayAttack => 'X-Ray 공격';

  @override
  String get puzzleThemeXRayAttackDescription => '기물이 상대 기물 너머의 칸을 공격 또는 방어합니다.';

  @override
  String get puzzleThemeZugzwang => '추크추방';

  @override
  String get puzzleThemeZugzwangDescription => '상대가 둘 수 있는 수는 제한되어 있으며, 모든 수가 포지션을 악화시킵니다.';

  @override
  String get puzzleThemeHealthyMix => '골고루 섞기';

  @override
  String get puzzleThemeHealthyMixDescription => '전부 다. 무엇이 나올지 모르기 때문에 모든 것에 준비되어 있어야 합니다. 마치 진짜 게임처럼요.';

  @override
  String get puzzleThemePlayerGames => '플레이어 게임';

  @override
  String get puzzleThemePlayerGamesDescription => '당신의 게임이나 다른 플레이어의 게임에서 나온 퍼즐을 찾아보세요.';

  @override
  String puzzleThemePuzzleDownloadInformation(String param) {
    return '이 퍼즐들은 퍼블릭 도메인이며, $param에서 다운로드할 수 있습니다.';
  }

  @override
  String get searchSearch => '검색';

  @override
  String get settingsSettings => '설정';

  @override
  String get settingsCloseAccount => '계정 폐쇄';

  @override
  String get settingsManagedAccountCannotBeClosed => '당신의 계정은 관리되고 있으며, 폐쇄될 수 없습니다.';

  @override
  String get settingsClosingIsDefinitive => '폐쇄 결정은 바꾸거나, 되돌릴 수 없습니다. 정말로 하실 건가요?';

  @override
  String get settingsCantOpenSimilarAccount => '대소문자가 다르더라도, 똑같은 이름으로 계정을 다시 열 수 없습니다.';

  @override
  String get settingsChangedMindDoNotCloseAccount => '마음이 바뀌었습니다, 계정을 폐쇄하지 않겠습니다';

  @override
  String get settingsCloseAccountExplanation => '정말로 계정을 닫고 싶으신가요? 계정 폐쇄는 되돌릴 수 없습니다. 절대로 다시 로그인 할 수 없습니다.';

  @override
  String get settingsThisAccountIsClosed => '계정이 폐쇄되었습니다.';

  @override
  String get playWithAFriend => '친구와 게임하기';

  @override
  String get playWithTheMachine => '체스 엔진과 게임하기';

  @override
  String get toInviteSomeoneToPlayGiveThisUrl => '이 URL로 친구를 초대하세요';

  @override
  String get gameOver => '게임 종료';

  @override
  String get waitingForOpponent => '상대를 기다리는 중';

  @override
  String get orLetYourOpponentScanQrCode => '또는 상대방에게 이 QR 코드를 스캔하게 하세요';

  @override
  String get waiting => '기다리는 중';

  @override
  String get yourTurn => '내 차례';

  @override
  String aiNameLevelAiLevel(String param1, String param2) {
    return '$param1 레벨 $param2';
  }

  @override
  String get level => '레벨';

  @override
  String get strength => '난이도';

  @override
  String get toggleTheChat => '채팅 끄기/켜기';

  @override
  String get chat => '채팅';

  @override
  String get resign => '기권';

  @override
  String get checkmate => '체크메이트';

  @override
  String get stalemate => '스테일메이트';

  @override
  String get white => '백색';

  @override
  String get black => '흑색';

  @override
  String get asWhite => '백일때';

  @override
  String get asBlack => '흑일때';

  @override
  String get randomColor => '무작위';

  @override
  String get createAGame => '새 게임 만들기';

  @override
  String get whiteIsVictorious => '백 승리';

  @override
  String get blackIsVictorious => '흑 승리';

  @override
  String get youPlayTheWhitePieces => '당신은 백으로 둡니다';

  @override
  String get youPlayTheBlackPieces => '당신은 흑으로 둡니다';

  @override
  String get itsYourTurn => '당신이 둘 차례입니다!';

  @override
  String get cheatDetected => '부정행위 감지됨';

  @override
  String get kingInTheCenter => '킹이 중앙에 도달함';

  @override
  String get threeChecks => '세 번의 체크';

  @override
  String get raceFinished => '킹이 보드 끝에 도달함';

  @override
  String get variantEnding => '변형 게임 엔딩';

  @override
  String get newOpponent => '새 상대';

  @override
  String get yourOpponentWantsToPlayANewGameWithYou => '상대가 재대결을 원합니다';

  @override
  String get joinTheGame => '게임 참가';

  @override
  String get whitePlays => '백색 차례';

  @override
  String get blackPlays => '흑색 차례';

  @override
  String get opponentLeftChoices => '당신의 상대가 게임을 나갔습니다. 상대를 기다리거나 승리 또는 무승부 처리할 수 있습니다.';

  @override
  String get forceResignation => '승리 처리';

  @override
  String get forceDraw => '무승부 처리';

  @override
  String get talkInChat => '건전한 채팅을 해주세요!';

  @override
  String get theFirstPersonToComeOnThisUrlWillPlayWithYou => '이 URL로 가장 먼저 들어온 사람과 체스를 두게 됩니다.';

  @override
  String get whiteResigned => '백색 기권';

  @override
  String get blackResigned => '흑색 기권';

  @override
  String get whiteLeftTheGame => '백색이 게임을 나갔습니다';

  @override
  String get blackLeftTheGame => '흑색이 게임을 나갔습니다';

  @override
  String get whiteDidntMove => '백이 두지 않음';

  @override
  String get blackDidntMove => '흑이 두지 않음';

  @override
  String get requestAComputerAnalysis => '컴퓨터 분석 요청';

  @override
  String get computerAnalysis => '컴퓨터 분석';

  @override
  String get computerAnalysisAvailable => '컴퓨터 분석이 가능합니다.';

  @override
  String get computerAnalysisDisabled => '컴퓨터 분석 꺼짐';

  @override
  String get analysis => '분석';

  @override
  String depthX(String param) {
    return '$param 수까지 탐색';
  }

  @override
  String get usingServerAnalysis => '서버 분석 사용하기';

  @override
  String get loadingEngine => '엔진 로드 중 ...';

  @override
  String get calculatingMoves => '수 계산 중...';

  @override
  String get engineFailed => '엔진 로딩 에러';

  @override
  String get cloudAnalysis => '클라우드 분석';

  @override
  String get goDeeper => '더 깊게 분석하기';

  @override
  String get showThreat => '위험요소 표시하기';

  @override
  String get inLocalBrowser => '브라우저에서';

  @override
  String get toggleLocalEvaluation => '개인 컴퓨터에서 분석하기';

  @override
  String get promoteVariation => '게임 분석 후에 어떤 수에 대한 예상결과들을 확인하고 싶다면';

  @override
  String get makeMainLine => '주 라인으로 하기';

  @override
  String get deleteFromHere => '여기서부터 삭제';

  @override
  String get collapseVariations => 'Collapse variations';

  @override
  String get expandVariations => 'Expand variations';

  @override
  String get forceVariation => '변화 강제하기';

  @override
  String get copyVariationPgn => '변동 PGN 복사';

  @override
  String get move => '수';

  @override
  String get variantLoss => '변형 체스에서 패배';

  @override
  String get variantWin => '변형 체스에서 승리';

  @override
  String get insufficientMaterial => '기물 부족으로 무승부입니다.';

  @override
  String get pawnMove => '폰 이동';

  @override
  String get capture => 'Capture';

  @override
  String get close => '닫기';

  @override
  String get winning => '이기는 수';

  @override
  String get losing => '지는 수';

  @override
  String get drawn => '무승부';

  @override
  String get unknown => '알 수 없음';

  @override
  String get database => '데이터베이스';

  @override
  String get whiteDrawBlack => '백 : 무승부 : 흑';

  @override
  String averageRatingX(String param) {
    return '평균 레이팅: $param';
  }

  @override
  String get recentGames => '최근 게임';

  @override
  String get topGames => '최고 레이팅 게임';

  @override
  String masterDbExplanation(String param1, String param2, String param3) {
    return '$param2년과 $param3년 사이 FIDE 레이팅이 최소 $param1였던 선수들의 기보가 약 2백만개 있습니다.';
  }

  @override
  String get dtzWithRounding => '다음 포획 혹은 폰 수까지 남은 반수를 반올림후 나타낸 DTZ50\" 수치';

  @override
  String get noGameFound => '게임을 찾을 수 없습니다.';

  @override
  String get maxDepthReached => '최대 깊이 도달!';

  @override
  String get maybeIncludeMoreGamesFromThePreferencesMenu => '설정에서 더 많은 게임을 포함하세요.';

  @override
  String get openings => '오프닝';

  @override
  String get openingExplorer => '오프닝 탐색기';

  @override
  String get openingEndgameExplorer => '오프닝/엔드게임 탐색기';

  @override
  String xOpeningExplorer(String param) {
    return '$param 오프닝 탐색기';
  }

  @override
  String get playFirstOpeningEndgameExplorerMove => '첫 번째 오프닝/엔드게임 탐색기 수 두기';

  @override
  String get winPreventedBy50MoveRule => '50수 규칙에 의하여 승리가 불가능합니다.';

  @override
  String get lossSavedBy50MoveRule => '50수 규칙에 의하여 패배가 불가능합니다.';

  @override
  String get winOr50MovesByPriorMistake => '승리 혹은 이전의 실수로 인한 50수 규칙 무승부';

  @override
  String get lossOr50MovesByPriorMistake => '패배 혹은 이전의 실수로 인한 50수 규칙 무승부';

  @override
  String get unknownDueToRounding => 'DTZ 수치의 반올림 때문에 추천된 테이블베이스 라인을 따라야만 승리 및 패배가 보장됩니다.';

  @override
  String get allSet => '모든 설정 완료!';

  @override
  String get importPgn => 'PGN 가져오기';

  @override
  String get delete => '삭제';

  @override
  String get deleteThisImportedGame => '가져온 게임을 삭제할까요?';

  @override
  String get replayMode => '게임 다시보기';

  @override
  String get realtimeReplay => '실시간';

  @override
  String get byCPL => '평가치변화';

  @override
  String get openStudy => '연구를 시작하기';

  @override
  String get enable => '활성화';

  @override
  String get bestMoveArrow => '최선의 수 화살표';

  @override
  String get showVariationArrows => '바리에이션 화살표 표시하기';

  @override
  String get evaluationGauge => '평가치 게이지';

  @override
  String get multipleLines => '다중 분석 수';

  @override
  String get cpus => 'CPU 수';

  @override
  String get memory => '메모리';

  @override
  String get infiniteAnalysis => '무한 분석';

  @override
  String get removesTheDepthLimit => '탐색 깊이 제한을 없애고 컴퓨터를 따뜻하게 해줍니다';

  @override
  String get engineManager => '엔진 매니저';

  @override
  String get blunder => '심각한 실수';

  @override
  String get mistake => '실수';

  @override
  String get inaccuracy => '사소한 실수';

  @override
  String get moveTimes => '이동 시간';

  @override
  String get flipBoard => '보드 돌리기';

  @override
  String get threefoldRepetition => '3회 동형반복';

  @override
  String get claimADraw => '무승부 처리';

  @override
  String get offerDraw => '무승부 요청';

  @override
  String get draw => '무승부';

  @override
  String get drawByMutualAgreement => '상호 동의에 의한 무승부';

  @override
  String get fiftyMovesWithoutProgress => '진전이 없이 50수 소모';

  @override
  String get currentGames => '진행 중인 게임';

  @override
  String get viewInFullSize => '크게 보기';

  @override
  String get logOut => '로그아웃';

  @override
  String get signIn => '로그인';

  @override
  String get rememberMe => '로그인 유지';

  @override
  String get youNeedAnAccountToDoThat => '회원만이 접근할 수 있습니다.';

  @override
  String get signUp => '회원 가입';

  @override
  String get computersAreNotAllowedToPlay => '컴퓨터나 컴퓨터의 도움을 받는 플레이어는 대국이 금지되어 있습니다. 대국할 때 체스 엔진이나 관련 자료, 또는 주변 플레이어로부터 도움을 받지 마십시오. 또한, 다중 계정 사용은 권장하지 않으며 지나치게 많은 다중 계정을 사용할 시 계정이 차단될 수 있습니다.';

  @override
  String get games => '게임';

  @override
  String get forum => '포럼';

  @override
  String xPostedInForumY(String param1, String param2) {
    return '$param1(이)가 $param2 쓰레드에 글을 씀';
  }

  @override
  String get latestForumPosts => '최근 포럼 글';

  @override
  String get players => '플레이어';

  @override
  String get friends => '친구들';

  @override
  String get discussions => '토론';

  @override
  String get today => '오늘';

  @override
  String get yesterday => '어제';

  @override
  String get minutesPerSide => '주어진 시간(분)';

  @override
  String get variant => '게임 종류';

  @override
  String get variants => '변형';

  @override
  String get timeControl => '시간 제한';

  @override
  String get realTime => '짧은 대국';

  @override
  String get correspondence => '긴 대국';

  @override
  String get daysPerTurn => '한 수에 걸리는 일수';

  @override
  String get oneDay => '1일';

  @override
  String get time => '시간';

  @override
  String get rating => '레이팅';

  @override
  String get ratingStats => '레이팅 통계';

  @override
  String get username => '아이디';

  @override
  String get usernameOrEmail => '사용자 이름이나 이메일 주소';

  @override
  String get changeUsername => '사용자명 변경';

  @override
  String get changeUsernameNotSame => '글자의 대소문자 변경만 가능합니다 예: \"johndoe\" to \"JohnDoe\".';

  @override
  String get changeUsernameDescription => '닉네임 변경하기: 대/소문자의 변경만이 허용되며, 단 한번만 가능한 작업입니다.';

  @override
  String get signupUsernameHint => '사용자 이름이 어린이를 포함해 모두에게 적절한지 확인하세요. 나중에 변경할 수 없으며 부적절한 사용자 이름을 가진 계정은 폐쇄됩니다!';

  @override
  String get signupEmailHint => '비밀번호 초기화를 위해서만 사용됩니다.';

  @override
  String get password => '비밀번호';

  @override
  String get changePassword => '비밀번호 변경';

  @override
  String get changeEmail => '메일 주소 변경';

  @override
  String get email => '메일';

  @override
  String get passwordReset => '비밀번호 초기화';

  @override
  String get forgotPassword => '비밀번호를 잊어버리셨나요?';

  @override
  String get error_weakPassword => '이 비밀번호는 매우 일반적이고 추측하기 쉽습니다.';

  @override
  String get error_namePassword => '사용자 아이디를 비밀번호로 사용하지 마세요.';

  @override
  String get blankedPassword => '다른 사이트에서 동일한 비밀번호를 사용했으며 해당 사이트가 유출된 경우. 라이선스 계정의 안전을 위해 새 비밀번호를 설정해 주셔야 합니다. 양해해 주셔서 감사합니다.';

  @override
  String get youAreLeavingLichess => '리체스에서 나갑니다';

  @override
  String get neverTypeYourPassword => '다른 사이트에서는 절대로 리체스 비밀번호를 입력하지 마세요!';

  @override
  String proceedToX(String param) {
    return '$param 진행';
  }

  @override
  String get passwordSuggestion => '다른 사람이 제안한 비밀번호를 설정하지 마세요. 타인이 계정을 도용하는 데 사용할 수 있습니다.';

  @override
  String get emailSuggestion => '다른 사람이 추천한 이메일 주소를 설정하지 마세요. 타인이 계정을 도용하는 데 사용할 수 있습니다.';

  @override
  String get emailConfirmHelp => '이메일 확인 도움말';

  @override
  String get emailConfirmNotReceived => '가입 후 확인 이메일을 받지 못하셨나요?';

  @override
  String get whatSignupUsername => '가입할 때 어떤 사용자 이름을 사용하셨나요?';

  @override
  String usernameNotFound(String param) {
    return '사용자 이름을 찾을 수 없습니다: $param.';
  }

  @override
  String get usernameCanBeUsedForNewAccount => '이 사용자 이름을 사용하여 새 계정을 만들 수 있습니다';

  @override
  String emailSent(String param) {
    return '$param로 이메일을 전송했습니다.';
  }

  @override
  String get emailCanTakeSomeTime => '도착하는데 시간이 걸릴 수 있습니다.';

  @override
  String get refreshInboxAfterFiveMinutes => '5분 가량 기다린 후 이메일 수신함을 새로고침하세요.';

  @override
  String get checkSpamFolder => '또한 스펨메일함을 확인해주시고 스펨을 해제해주세요.';

  @override
  String get emailForSignupHelp => '모두 실패했다면 이곳으로 메일을 보내주세요:';

  @override
  String copyTextToEmail(String param) {
    return '위의 텍스트를 복사해서 $param로 보내주세요.';
  }

  @override
  String get waitForSignupHelp => '가입을 완료할 수 있도록 빠르게 연락드리겠습니다.';

  @override
  String accountConfirmed(String param) {
    return '$param 사용자가 성공적으로 확인되었습니다.';
  }

  @override
  String accountCanLogin(String param) {
    return '이제 $param로 로그인할 수 있습니다.';
  }

  @override
  String get accountConfirmationEmailNotNeeded => '이메일 확인은 필요하지 않습니다.';

  @override
  String accountClosed(String param) {
    return '$param 계정은 폐쇄되었습니다.';
  }

  @override
  String accountRegisteredWithoutEmail(String param) {
    return '$param 계정은 이메일 주소가 없이 등록되었습니다.';
  }

  @override
  String get rank => '순위';

  @override
  String rankX(String param) {
    return '순위: $param등';
  }

  @override
  String get gamesPlayed => '게임';

  @override
  String get cancel => '취소';

  @override
  String get whiteTimeOut => '백색 시간 초과';

  @override
  String get blackTimeOut => '흑색 시간 초과';

  @override
  String get drawOfferSent => '무승부를 요청했습니다';

  @override
  String get drawOfferAccepted => '무승부 요청이 승낙됐습니다';

  @override
  String get drawOfferCanceled => '무승부 요청을 취소했습니다';

  @override
  String get whiteOffersDraw => '백이 무승부를 제안했습니다';

  @override
  String get blackOffersDraw => '흑이 무승부를 제안했습니다';

  @override
  String get whiteDeclinesDraw => '백이 무승부 제안을 거절했습니다';

  @override
  String get blackDeclinesDraw => '흑이 무승부 제안을 거절했습니다';

  @override
  String get yourOpponentOffersADraw => '상대가 무승부를 요청했습니다';

  @override
  String get accept => '승낙';

  @override
  String get decline => '거절';

  @override
  String get playingRightNow => '대국 중';

  @override
  String get eventInProgress => '지금 대국 중';

  @override
  String get finished => '종료';

  @override
  String get abortGame => '게임 중단';

  @override
  String get gameAborted => '게임 중단됨';

  @override
  String get standard => '표준';

  @override
  String get customPosition => '사용자 지정 포지션';

  @override
  String get unlimited => '무제한';

  @override
  String get mode => '모드';

  @override
  String get casual => '캐주얼';

  @override
  String get rated => '레이팅';

  @override
  String get casualTournament => '일반';

  @override
  String get ratedTournament => '레이팅';

  @override
  String get thisGameIsRated => '이 게임은 레이팅 게임입니다';

  @override
  String get rematch => '재대결';

  @override
  String get rematchOfferSent => '재대결 요청을 보냈습니다';

  @override
  String get rematchOfferAccepted => '재대결 요청이 승낙됐습니다';

  @override
  String get rematchOfferCanceled => '재대결 요청이 취소됐습니다';

  @override
  String get rematchOfferDeclined => '재대결 요청이 거절됐습니다';

  @override
  String get cancelRematchOffer => '재대결 요청 취소';

  @override
  String get viewRematch => '재대결 보러 가기';

  @override
  String get confirmMove => '수 확인';

  @override
  String get play => '플레이';

  @override
  String get inbox => '받은편지함';

  @override
  String get chatRoom => '채팅';

  @override
  String get loginToChat => '채팅에 로그인하기';

  @override
  String get youHaveBeenTimedOut => '채팅에서 로그아웃 되었습니다.';

  @override
  String get spectatorRoom => '관전자 채팅';

  @override
  String get composeMessage => '메시지 작성';

  @override
  String get subject => '제목';

  @override
  String get send => '전송';

  @override
  String get incrementInSeconds => '턴 당 추가 시간(초)';

  @override
  String get freeOnlineChess => '무료 온라인 체스';

  @override
  String get exportGames => '게임 내보내기';

  @override
  String get ratingRange => 'ELO 범위';

  @override
  String get thisAccountViolatedTos => '이 계정은 Lichess 이용 약관을 위반했습니다.';

  @override
  String get openingExplorerAndTablebase => '오프닝 탐색 & 테이블베이스';

  @override
  String get takeback => '무르기';

  @override
  String get proposeATakeback => '무르기를 요청합니다';

  @override
  String get takebackPropositionSent => '무르기 요청을 보냈습니다';

  @override
  String get takebackPropositionDeclined => '무르기 요청이 거절됐습니다';

  @override
  String get takebackPropositionAccepted => '무르기 요청이 승낙됐습니다';

  @override
  String get takebackPropositionCanceled => '무르기 요청이 취소됐습니다';

  @override
  String get yourOpponentProposesATakeback => '상대가 무르기를 요청합니다';

  @override
  String get bookmarkThisGame => '이 게임을 즐겨찾기에 추가하기';

  @override
  String get tournament => '토너먼트';

  @override
  String get tournaments => '토너먼트';

  @override
  String get tournamentPoints => '토너먼트 점수';

  @override
  String get viewTournament => '토너먼트 보기';

  @override
  String get backToTournament => '토너먼트로 돌아가기';

  @override
  String get noDrawBeforeSwissLimit => '스위스 토너먼트에서는 30수 전에 무승부를 할 수 없습니다.';

  @override
  String get thematic => '국면지정';

  @override
  String yourPerfRatingIsProvisional(String param) {
    return '사용자의 임시 등급 $param는 임시적입니다.';
  }

  @override
  String yourPerfRatingIsTooHigh(String param1, String param2) {
    return '귀하의 $param1 레이팅($param2)은 너무 높습니다.';
  }

  @override
  String yourTopWeeklyPerfRatingIsTooHigh(String param1, String param2) {
    return '$param1 랭크가 너무 높습니다. ($param2)';
  }

  @override
  String yourPerfRatingIsTooLow(String param1, String param2) {
    return '$param1 랭크가 너무 낮습니다. ($param2)';
  }

  @override
  String ratedMoreThanInPerf(String param1, String param2) {
    return '$param2 레이팅 $param1 이상';
  }

  @override
  String ratedLessThanInPerf(String param1, String param2) {
    return '$param2 레이팅 $param1 이하';
  }

  @override
  String mustBeInTeam(String param) {
    return '팀 $param 의 멤버에 한정';
  }

  @override
  String youAreNotInTeam(String param) {
    return '팀 $param 에 소속되지 않았습니다.';
  }

  @override
  String get backToGame => '게임으로 돌아가기';

  @override
  String get siteDescription => '회원가입, 광고, 플러그인 없이 즐길 수 있는 깔끔한 구성의 무료 온라인 체스 게임입니다. 컴퓨터, 친구 또는 무작위로 고른 상대와 함께 체스를 즐겨보세요.';

  @override
  String xJoinedTeamY(String param1, String param2) {
    return '$param1(이)가 팀 $param2에 가입했습니다.';
  }

  @override
  String xCreatedTeamY(String param1, String param2) {
    return '$param1(이)가 팀 $param2(을)를 만들었습니다.';
  }

  @override
  String get startedStreaming => '스트리밍 시작';

  @override
  String xStartedStreaming(String param) {
    return '$param 님이 스트리밍을 시작했습니다';
  }

  @override
  String get averageElo => '평균 레이팅';

  @override
  String get location => '주소';

  @override
  String get filterGames => '필터';

  @override
  String get reset => '초기화';

  @override
  String get apply => '적용';

  @override
  String get save => '저장하기';

  @override
  String get leaderboard => '리더보드';

  @override
  String get screenshotCurrentPosition => '스크린샷 찍기';

  @override
  String get gameAsGIF => 'GIF로 저장하기';

  @override
  String get pasteTheFenStringHere => 'FEN값을 붙여 넣으세요';

  @override
  String get pasteThePgnStringHere => 'PGN값을 붙여 넣으세요';

  @override
  String get orUploadPgnFile => '또는 PGN 파일을 업로드하세요';

  @override
  String get fromPosition => '정해진 보드판에서 시작';

  @override
  String get continueFromHere => '여기서부터 시작';

  @override
  String get toStudy => '연구';

  @override
  String get importGame => '게임 불러오기';

  @override
  String get importGameExplanation => '게임의 PGN 을 붙여넣으면, 브라우저에서의 리플레이, 컴퓨터 해석, 게임챗, 공유가능 URL을 얻습니다.';

  @override
  String get importGameCaveat => '변형은 지워집니다. 변형을 유지하려면 스터디를 통해 PGN을 가져오세요.';

  @override
  String get importGameDataPrivacyWarning => '이 PGN은 모두가 볼 수 있게 됩니다. 비공개로 게임을 불러오려면, 연구 기능을 이용하세요.';

  @override
  String get thisIsAChessCaptcha => '자동 기입을 방지하기 위한 체스 퀴즈입니다.';

  @override
  String get clickOnTheBoardToMakeYourMove => '보드를 클릭해서 체스 퍼즐을 풀고 당신이 사람임을 알려주세요.';

  @override
  String get captcha_fail => '문제를 풀어 인간임을 증명해주세요.';

  @override
  String get notACheckmate => '체크메이트가 아닙니다.';

  @override
  String get whiteCheckmatesInOneMove => '백이 한 수 만에 체크메이트하기';

  @override
  String get blackCheckmatesInOneMove => '흑이 한 수 만에 체크메이트하기';

  @override
  String get retry => '재시도';

  @override
  String get reconnecting => '연결 재시도 중';

  @override
  String get noNetwork => '오프라인';

  @override
  String get favoriteOpponents => '관심있는 상대';

  @override
  String get follow => '팔로우';

  @override
  String get following => '팔로잉';

  @override
  String get unfollow => '팔로우 취소';

  @override
  String followX(String param) {
    return '$param 팔로우하기';
  }

  @override
  String unfollowX(String param) {
    return '$param 팔로우 취소하기';
  }

  @override
  String get block => '차단';

  @override
  String get blocked => '차단됨';

  @override
  String get unblock => '차단 해제';

  @override
  String get followsYou => '팔로워';

  @override
  String xStartedFollowingY(String param1, String param2) {
    return '$param1(이)가 $param2(을)를 팔로우했습니다';
  }

  @override
  String get more => '더보기';

  @override
  String get memberSince => '가입 시기:';

  @override
  String lastSeenActive(String param) {
    return '최근 로그인: $param';
  }

  @override
  String get player => '플레이어';

  @override
  String get list => '목록';

  @override
  String get graph => '그래프';

  @override
  String get required => '필수 항목';

  @override
  String get openTournaments => '시작 예정 토너먼트';

  @override
  String get duration => '경기 시간';

  @override
  String get winner => '승자';

  @override
  String get standing => '순위';

  @override
  String get createANewTournament => '새 토너먼트 생성';

  @override
  String get tournamentCalendar => '토너먼트 달력';

  @override
  String get conditionOfEntry => '참가조건:';

  @override
  String get advancedSettings => '고급 설정';

  @override
  String get safeTournamentName => '토너먼트 이름은 무난한 것으로 정해주십시오.';

  @override
  String get inappropriateNameWarning => '조금이라도 부적절한 이름일 경우에는 계정이 정지될 수도 있습니다.';

  @override
  String get emptyTournamentName => '토너먼트 이름을 공란으로 두면, 임의의 그랜드마스터 선수 이름으로 선택됩니다.';

  @override
  String get makePrivateTournament => '토너먼트를 비공개로 바꾸고, 비밀번호가 있어야만 들어갈 수 있습니다.';

  @override
  String get join => '참가하기';

  @override
  String get withdraw => '중단';

  @override
  String get points => '포인트';

  @override
  String get wins => '승리';

  @override
  String get losses => '패배';

  @override
  String get createdBy => '토너먼트 주최자:';

  @override
  String get tournamentIsStarting => '토너먼트가 곧 시작됩니다';

  @override
  String get tournamentPairingsAreNowClosed => '토너먼트 매칭이 종료되었습니다.';

  @override
  String standByX(String param) {
    return '$param 님, 현재 매칭중입니다. 준비하십시오!';
  }

  @override
  String get pause => '일시 중지';

  @override
  String get resume => '재개';

  @override
  String get youArePlaying => '참가중!';

  @override
  String get winRate => '승률';

  @override
  String get berserkRate => '버서크율';

  @override
  String get performance => '퍼포먼스 레이팅';

  @override
  String get tournamentComplete => '대회 종료';

  @override
  String get movesPlayed => '말 이동 횟수';

  @override
  String get whiteWins => '하얀 말로 우승';

  @override
  String get blackWins => '검은 말로 우승';

  @override
  String get drawRate => '무승부 비율';

  @override
  String get draws => '무승부';

  @override
  String nextXTournament(String param) {
    return '다음 $param 대회:';
  }

  @override
  String get averageOpponent => '상대의 평균 승점';

  @override
  String get boardEditor => '보드 편집기';

  @override
  String get setTheBoard => '보드 세팅하기';

  @override
  String get popularOpenings => '인기 있는 오프닝';

  @override
  String get endgamePositions => '엔드게임 포지션';

  @override
  String chess960StartPosition(String param) {
    return '체스960 시작 포지션: $param';
  }

  @override
  String get startPosition => '시작 포지션';

  @override
  String get clearBoard => '보드 지우기';

  @override
  String get loadPosition => '포지션 불러오기';

  @override
  String get isPrivate => '비공개';

  @override
  String reportXToModerators(String param) {
    return '$param 신고';
  }

  @override
  String profileCompletion(String param) {
    return '프로필 완성도: $param';
  }

  @override
  String xRating(String param) {
    return '레이팅: $param';
  }

  @override
  String get ifNoneLeaveEmpty => '없으면 무시하세요';

  @override
  String get profile => '프로필';

  @override
  String get editProfile => '프로필 수정';

  @override
  String get realName => 'Real name';

  @override
  String get setFlair => 'Set your flair';

  @override
  String get flair => 'Flair';

  @override
  String get youCanHideFlair => 'There is a setting to hide all user flairs across the entire site.';

  @override
  String get biography => '소개';

  @override
  String get countryRegion => '국가/지역';

  @override
  String get thankYou => '감사합니다!';

  @override
  String get socialMediaLinks => '소셜 미디어 링크';

  @override
  String get oneUrlPerLine => '한 줄에 1개 URL';

  @override
  String get inlineNotation => '기보를 가로쓰기';

  @override
  String get makeAStudy => '안전하게 보관하고 공유하려면 스터디를 만들어 보세요.';

  @override
  String get clearSavedMoves => '저장된 움직임 삭제';

  @override
  String get previouslyOnLichessTV => '이전 방송';

  @override
  String get onlinePlayers => '접속한 플레이어';

  @override
  String get activePlayers => '활동적인 플레이어';

  @override
  String get bewareTheGameIsRatedButHasNoClock => '조심하세요, 레이팅 게임이며 시간 제한이 없습니다!';

  @override
  String get success => '성공!';

  @override
  String get automaticallyProceedToNextGameAfterMoving => '수를 둔 다음에 자동으로 다음 게임에 이동';

  @override
  String get autoSwitch => '자동 전환';

  @override
  String get puzzles => '퍼즐';

  @override
  String get onlineBots => 'Online bots';

  @override
  String get name => '이름';

  @override
  String get description => '설명';

  @override
  String get descPrivate => '비공개 설명';

  @override
  String get descPrivateHelp => '팀 멤버만 볼 수 있는 텍스트입니다. 설정된다면, 팀 멤버에게는 공개 설명 대신 보이게 됩니다.';

  @override
  String get no => '아니오';

  @override
  String get yes => '예';

  @override
  String get help => '힌트:';

  @override
  String get createANewTopic => '새 토픽';

  @override
  String get topics => '토픽';

  @override
  String get posts => '글';

  @override
  String get lastPost => '최근 글';

  @override
  String get views => '조회';

  @override
  String get replies => '답글';

  @override
  String get replyToThisTopic => '답글 달기';

  @override
  String get reply => '전송';

  @override
  String get message => '내용';

  @override
  String get createTheTopic => '새 토픽 생성';

  @override
  String get reportAUser => '사용자 신고';

  @override
  String get user => '신고할 사용자 이름';

  @override
  String get reason => '이유';

  @override
  String get whatIsIheMatter => '무엇이 문제인가요?';

  @override
  String get cheat => '부정행위';

  @override
  String get troll => '분란 조장';

  @override
  String get other => '기타';

  @override
  String get reportDescriptionHelp => '게임 URL 주소를 붙여넣으시고 해당 사용자가 무엇을 잘못했는지 설명해 주세요.';

  @override
  String get error_provideOneCheatedGameLink => '부정행위가 존재하는 게임의 링크를 적어도 하나는 적어주세요.';

  @override
  String by(String param) {
    return '작성: $param';
  }

  @override
  String importedByX(String param) {
    return '$param가 불러옴';
  }

  @override
  String get thisTopicIsNowClosed => '이 토픽은 닫혔습니다.';

  @override
  String get blog => '블로그';

  @override
  String get notes => '노트';

  @override
  String get typePrivateNotesHere => '여기에 비공개 메모 작성하기';

  @override
  String get writeAPrivateNoteAboutThisUser => '이 사용자에 대한 비공개 메모를 작성하세요';

  @override
  String get noNoteYet => '아직 메모가 없습니다.';

  @override
  String get invalidUsernameOrPassword => '사용자 이름이나 비밀번호가 잘못되었습니다.';

  @override
  String get incorrectPassword => '잘못된 비밀번호입니다.';

  @override
  String get invalidAuthenticationCode => '무효한 인증코드';

  @override
  String get emailMeALink => '메일로 링크를 보내주세요';

  @override
  String get currentPassword => '현재 비밀번호';

  @override
  String get newPassword => '새 비밀번호';

  @override
  String get newPasswordAgain => '새 비밀번호 확인';

  @override
  String get newPasswordsDontMatch => '새로운 비밀번호가 일치하지 않습니다';

  @override
  String get newPasswordStrength => '비밀번호 강도';

  @override
  String get clockInitialTime => '기본 시간';

  @override
  String get clockIncrement => '한 수당 증가하는 시간';

  @override
  String get privacy => '보안';

  @override
  String get privacyPolicy => '개인정보취급방침';

  @override
  String get letOtherPlayersFollowYou => '다른 사람이 팔로우할 수 있게 함';

  @override
  String get letOtherPlayersChallengeYou => '다른 사람이 나에게 도전할 수 있게 함';

  @override
  String get letOtherPlayersInviteYouToStudy => '다른 플레이어들이 나를 학습에 초대할 수 있음';

  @override
  String get sound => '소리';

  @override
  String get none => '없음';

  @override
  String get fast => '빠르게';

  @override
  String get normal => '보통';

  @override
  String get slow => '느리게';

  @override
  String get insideTheBoard => '보드 안쪽에';

  @override
  String get outsideTheBoard => '보드 바깥쪽에';

  @override
  String get allSquaresOfTheBoard => 'All squares of the board';

  @override
  String get onSlowGames => '느린 게임에서만';

  @override
  String get always => '항상';

  @override
  String get never => '안 함';

  @override
  String xCompetesInY(String param1, String param2) {
    return '$param1가 $param2에 참가했습니다.';
  }

  @override
  String get victory => '승리';

  @override
  String get defeat => '패배';

  @override
  String victoryVsYInZ(String param1, String param2, String param3) {
    return '$param1: $param2 / $param3';
  }

  @override
  String defeatVsYInZ(String param1, String param2, String param3) {
    return '$param1: $param2 / $param3';
  }

  @override
  String drawVsYInZ(String param1, String param2, String param3) {
    return '$param1: $param2 / $param3';
  }

  @override
  String get timeline => '타임라인';

  @override
  String get starting => '시작합니다:';

  @override
  String get allInformationIsPublicAndOptional => '모든 정보는 공개되며 선택 사항입니다.';

  @override
  String get biographyDescription => '자신을 알려주세요. 왜 체스를 좋아하는지, 좋아하는 오프닝, 게임, 선수 등등...';

  @override
  String get listBlockedPlayers => '이 플레이어를 차단';

  @override
  String get human => '인간';

  @override
  String get computer => '인공지능';

  @override
  String get side => '진영';

  @override
  String get clock => '시계';

  @override
  String get opponent => '상대';

  @override
  String get learnMenu => '배우기';

  @override
  String get studyMenu => '연구';

  @override
  String get practice => '연습';

  @override
  String get community => '커뮤니티';

  @override
  String get tools => '도구';

  @override
  String get increment => '시간 증가';

  @override
  String get error_unknown => '잘못된 값';

  @override
  String get error_required => '필수 기입 사항입니다.';

  @override
  String get error_email => '이메일 주소가 유효하지 않습니다';

  @override
  String get error_email_acceptable => '이 이메일 주소는 받을 수 없습니다. 다시 확인후 시도해주세요.';

  @override
  String get error_email_unique => '이메일 주소가 유효하지 않거나 이미 등록되었습니다';

  @override
  String get error_email_different => '이미 당신의 이메일 주소입니다.';

  @override
  String error_minLength(String param) {
    return '최소 $param자여야 합니다.';
  }

  @override
  String error_maxLength(String param) {
    return '최대 $param자여야 합니다';
  }

  @override
  String error_min(String param) {
    return '최소 $param자 이어야 합니다.';
  }

  @override
  String error_max(String param) {
    return '최대 $param자 이어야 합니다.';
  }

  @override
  String ifRatingIsPlusMinusX(String param) {
    return '레이팅이 ± $param 이하일 경우';
  }

  @override
  String get ifRegistered => '가입된 사람만';

  @override
  String get onlyExistingConversations => '기존에 대화한 경우만';

  @override
  String get onlyFriends => '친구만';

  @override
  String get menu => '메뉴';

  @override
  String get castling => '캐슬링';

  @override
  String get whiteCastlingKingside => '백색 O-O';

  @override
  String get blackCastlingKingside => '흑색 O-O';

  @override
  String tpTimeSpentPlaying(String param) {
    return '플레이한 시간 : $param';
  }

  @override
  String get watchGames => '관람';

  @override
  String tpTimeSpentOnTV(String param) {
    return 'Lichess TV에 나온 시간 : $param';
  }

  @override
  String get watch => '중계';

  @override
  String get videoLibrary => '비디오 라이브러리';

  @override
  String get streamersMenu => '스트리머';

  @override
  String get mobileApp => '모바일 앱';

  @override
  String get webmasters => '웹마스터';

  @override
  String get about => 'Lichess 개요';

  @override
  String aboutX(String param) {
    return '$param에 대해';
  }

  @override
  String xIsAFreeYLibreOpenSourceChessServer(String param1, String param2) {
    return '$param1는 무료($param2)이고, 자유로우며, 광고가 없는 오픈 소스 체스 서버입니다.';
  }

  @override
  String get really => '정말입니다!';

  @override
  String get contribute => '기여하기';

  @override
  String get termsOfService => '이용 약관';

  @override
  String get sourceCode => '소스 코드';

  @override
  String get simultaneousExhibitions => '동시대국';

  @override
  String get host => '호스트';

  @override
  String hostColorX(String param) {
    return '호스트의 색: $param';
  }

  @override
  String get yourPendingSimuls => '대기 중인 동시대국';

  @override
  String get createdSimuls => '새롭게 생성된 동시대국';

  @override
  String get hostANewSimul => '새 동시대국을 생성하기';

  @override
  String get signUpToHostOrJoinASimul => '동시대국을 생성/참가하려면 로그인하세요';

  @override
  String get noSimulFound => '동시대국을 찾을 수 없습니다';

  @override
  String get noSimulExplanation => '존재하지 않는 동시대국입니다.';

  @override
  String get returnToSimulHomepage => '동시대국 홈으로 돌아가기';

  @override
  String get aboutSimul => '동시대국에서는 1인의 플레이어가 여러 플레이어와 대국을 벌입니다.';

  @override
  String get aboutSimulImage => '50명의 상대 중, 피셔는 47국을 승리하였고, 2국은 무승부였으며 1국만을 패배하였습니다.';

  @override
  String get aboutSimulRealLife => '이 동시대국의 개념은 실제 동시대국과 동일합니다. 실제로 1인 플레이어는 테이블을 넘기며 한 수씩 둡니다.';

  @override
  String get aboutSimulRules => '동시대국이 시작되면 모든 플레이어가 호스트와 게임을 합니다. 동시대국은 모든 플레이어와 게임이 끝나면 종료됩니다.';

  @override
  String get aboutSimulSettings => '동시대국은 캐주얼 전입니다. 재대결, 무르기, 시간추가를 할 수 없습니다.';

  @override
  String get create => '생성';

  @override
  String get whenCreateSimul => '동시대국을 생성하면 한 번에 여러 명의 플레이어와 게임하게 됩니다.';

  @override
  String get simulVariantsHint => '복수의 게임방식을 선택할 경우, 상대방 측에서 게임 방식을 선택하게 됩니다.';

  @override
  String get simulClockHint => '피셔 방식 제한시간 설정: 여러 명의 사람들과 둔다면 더 많은 시간이 필요할 것입니다.';

  @override
  String get simulAddExtraTime => '동시대국을 위하여 당신에게만 여분의 시간을 더할 수 있습니다.';

  @override
  String get simulHostExtraTime => '호스트 연장 시간';

  @override
  String get simulAddExtraTimePerPlayer => '다면기에 참여하는 각 플레이어에게 기본 시간을 추가합니다.';

  @override
  String get simulHostExtraTimePerPlayer => '호스트는 플레이어마다 추가 시간을 가짐';

  @override
  String get lichessTournaments => 'Lichess 토너먼트';

  @override
  String get tournamentFAQ => '아레나 토너먼트 FAQ';

  @override
  String get timeBeforeTournamentStarts => '토너먼트 시작까지 시간';

  @override
  String get averageCentipawnLoss => '평균 CP(centipawn) 손실';

  @override
  String get accuracy => '정확도';

  @override
  String get keyboardShortcuts => '키보드 단축키';

  @override
  String get keyMoveBackwardOrForward => '뒤로/앞으로 가기';

  @override
  String get keyGoToStartOrEnd => '처음/끝으로 가기';

  @override
  String get keyCycleSelectedVariation => 'Cycle selected variation';

  @override
  String get keyShowOrHideComments => '댓글 표시/숨기기';

  @override
  String get keyEnterOrExitVariation => '바리에이션 들어가기/나오기';

  @override
  String get keyRequestComputerAnalysis => '컴퓨터 분석 요청, 실수에서 배우기';

  @override
  String get keyNextLearnFromYourMistakes => '다음 (실수에서 배우기)';

  @override
  String get keyNextBlunder => '다음 블런더';

  @override
  String get keyNextMistake => '다음 실수';

  @override
  String get keyNextInaccuracy => '다음 부정확한 수';

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
  String get variationArrowsInfo => '변형 화살표를 사용하면 이동 목록을 사용하지 않고 탐색이 가능합니다.';

  @override
  String get playSelectedMove => '선택한 수 두기';

  @override
  String get newTournament => '새로운 토너먼트';

  @override
  String get tournamentHomeTitle => '다양한 제한시간과 게임방식을 지원하는 체스 토너먼트';

  @override
  String get tournamentHomeDescription => '빠른 체스 토너먼트를 즐겨 보세요! 공식 일정이 잡힌 토너먼트에 참가할 수도, 당신만의 토너먼트를 만들 수도 있습니다. 불릿, 블리츠, 클래식, 체스960, 언덕의 왕, 3체크를 비롯하여 다양한 게임방식을 즐길 수 있습니다.';

  @override
  String get tournamentNotFound => '토너먼트를 찾을 수 없습니다';

  @override
  String get tournamentDoesNotExist => '존재하지 않는 토너먼트입니다.';

  @override
  String get tournamentMayHaveBeenCanceled => '모든 플레이어가 퇴장하여 취소된 게임일 수 있습니다.';

  @override
  String get returnToTournamentsHomepage => '토너먼트 홈으로 돌아가기';

  @override
  String weeklyPerfTypeRatingDistribution(String param) {
    return '주간 $param 레이팅 분포';
  }

  @override
  String yourPerfTypeRatingIsRating(String param1, String param2) {
    return '당신의 $param1 레이팅은 $param2입니다.';
  }

  @override
  String youAreBetterThanPercentOfPerfTypePlayers(String param1, String param2) {
    return '당신은 $param1의 $param2 플레이어보다 더 뛰어납니다.';
  }

  @override
  String userIsBetterThanPercentOfPerfTypePlayers(String param1, String param2, String param3) {
    return '$param1는 $param2의 $param3 플레이어보다 더 뛰어납니다.';
  }

  @override
  String betterThanPercentPlayers(String param1, String param2) {
    return '$param1의 $param2 플레이어보다 더 뛰어납니다.';
  }

  @override
  String youDoNotHaveAnEstablishedPerfTypeRating(String param) {
    return '아직 확정된 $param 레이팅을 갖지 않으셨습니다.';
  }

  @override
  String get yourRating => '당신의 레이팅';

  @override
  String get cumulative => '누적 유저 비율';

  @override
  String get glicko2Rating => 'Glicko-2 레이팅';

  @override
  String get checkYourEmail => '메일을 확인해 주세요.';

  @override
  String get weHaveSentYouAnEmailClickTheLink => '메일을 보냈습니다. 메일에서 링크를 클릭해서 계정을 활성화해 주세요.';

  @override
  String get ifYouDoNotSeeTheEmailCheckOtherPlaces => '메일을 확인할 수 없다면, 스팸 메일함이나 다른 폴더에 메일이 있지 않은지 확인해 주세요.';

  @override
  String weHaveSentYouAnEmailTo(String param) {
    return '$param 주소로 메일을 보냈습니다. 메일을 확인하고 비밀번호를 재설정하세요.';
  }

  @override
  String byRegisteringYouAgreeToBeBoundByOur(String param) {
    return '이곳에 등록하면 당신은 이곳의 $param 약관에 동의하시는 것입니다.';
  }

  @override
  String readAboutOur(String param) {
    return '$param를 읽어보세요.';
  }

  @override
  String get networkLagBetweenYouAndLichess => '당신과 lichess 서버 간의 네트워크 지연 시간';

  @override
  String get timeToProcessAMoveOnLichessServer => 'lichess 서버에서 한 수를 계산하는 데 걸리는 시간';

  @override
  String get downloadAnnotated => '주석이 달린 기보 다운로드';

  @override
  String get downloadRaw => '기보 다운로드';

  @override
  String get downloadImported => '불러온 기보 다운로드';

  @override
  String get crosstable => '점수판';

  @override
  String get youCanAlsoScrollOverTheBoardToMoveInTheGame => '마우스 스크롤을 돌림으로써 수를 진행할 수 있습니다.';

  @override
  String get scrollOverComputerVariationsToPreviewThem => '컴퓨터 변화수를 미리보기 위해서는 커서를 올리세요.';

  @override
  String get analysisShapesHowTo => 'Shift + 왼쪽/오른쪽 클릭으로 원이나 화살표를 보드 상에 그릴 수 있습니다.';

  @override
  String get letOtherPlayersMessageYou => '다른 사람들이 당신에게 메시지를 보낼 수 있도록 합니다.';

  @override
  String get receiveForumNotifications => '포럼에서 언급되면 알림을 받습니다';

  @override
  String get shareYourInsightsData => '당신의 게임 분석 결과를 공유합니다.';

  @override
  String get withNobody => '나만 보기';

  @override
  String get withFriends => '친구들만';

  @override
  String get withEverybody => '공개';

  @override
  String get kidMode => '어린이 모드';

  @override
  String get kidModeIsEnabled => '어린이 모드가 활성화되었습니다.';

  @override
  String get kidModeExplanation => '이 모드는 안전에 관한 것입니다. 어린이 모드에서는 모든 통신이 비활성화됩니다. 당신의 아이들이나 학생들을 다른 인터넷 사용자들에서 보호하려면 이 모드를 켜십시오.';

  @override
  String inKidModeTheLichessLogoGetsIconX(String param) {
    return '어린이 모드에서는 lichess 로고가 $param 아이콘이 뜨기 때문에 안심하셔도 됩니다.';
  }

  @override
  String get askYourChessTeacherAboutLiftingKidMode => '당신의 계정은 관리되고 있습니다. 어린이 모드 해제에 대해서는 체스 선생님께 문의하세요.';

  @override
  String get enableKidMode => '어린이 모드 활성화하기';

  @override
  String get disableKidMode => '어린이 모드 비활성화하기';

  @override
  String get security => '보안';

  @override
  String get sessions => '세션';

  @override
  String get revokeAllSessions => '모든 세션 비활성화';

  @override
  String get playChessEverywhere => '어디에서나 체스를 즐기세요';

  @override
  String get asFreeAsLichess => 'lichess처럼 무료입니다';

  @override
  String get builtForTheLoveOfChessNotMoney => '오직 체스에 대한 열정으로 만들어졌습니다';

  @override
  String get everybodyGetsAllFeaturesForFree => '모두가 모든 기능을 무료로 이용할 수 있습니다';

  @override
  String get zeroAdvertisement => '광고가 없습니다';

  @override
  String get fullFeatured => '모든 기능을 지원합니다';

  @override
  String get phoneAndTablet => '스마트폰과 태블릿 지원';

  @override
  String get bulletBlitzClassical => '불릿, 블리츠, 클래식 방식 지원';

  @override
  String get correspondenceChess => '우편 체스 지원';

  @override
  String get onlineAndOfflinePlay => '온라인/오프라인 게임 모두 지원';

  @override
  String get viewTheSolution => '해답 보기';

  @override
  String get followAndChallengeFriends => '친구를 팔로우하고 도전하기';

  @override
  String get gameAnalysis => '게임 분석기';

  @override
  String xHostsY(String param1, String param2) {
    return '$param2가 $param1를 시작했습니다.';
  }

  @override
  String xJoinsY(String param1, String param2) {
    return '$param2가 $param1에 참여했습니다.';
  }

  @override
  String xLikesY(String param1, String param2) {
    return '$param1(이)가 $param2를 좋아합니다.';
  }

  @override
  String get quickPairing => '빠른 상대 찾기';

  @override
  String get lobby => '로비';

  @override
  String get anonymous => '익명 플레이어';

  @override
  String yourScore(String param) {
    return '당신의 점수는 $param입니다.';
  }

  @override
  String get language => '언어';

  @override
  String get background => '배경';

  @override
  String get light => '밝게';

  @override
  String get dark => '어둡게';

  @override
  String get transparent => '투명하게';

  @override
  String get deviceTheme => '기기 테마';

  @override
  String get backgroundImageUrl => '배경 이미지 URL:';

  @override
  String get board => '보드';

  @override
  String get size => '크기';

  @override
  String get opacity => '투명도';

  @override
  String get brightness => '명도';

  @override
  String get hue => '색상';

  @override
  String get boardReset => '기본 색상으로 되돌리기';

  @override
  String get pieceSet => '기물 세트';

  @override
  String get embedInYourWebsite => '웹사이트에 공유하기';

  @override
  String get usernameAlreadyUsed => '이미 사용중인 사용자 이름입니다. 다른 이름을 사용해주세요.';

  @override
  String get usernamePrefixInvalid => '유저 이름의 첫 글자는 알파벳이어야 합니다.';

  @override
  String get usernameSuffixInvalid => '유저 이름의 끝 글자는 알파벳이나 숫자여야 합니다.';

  @override
  String get usernameCharsInvalid => '유저 이름에는 알파벳, 숫자, 언더스코어 ( _ ), 하이픈 ( - ) 만을 사용할 수 있습니다.';

  @override
  String get usernameUnacceptable => '사용자 이름을 사용할 수 없습니다.';

  @override
  String get playChessInStyle => '스타일리시하게 체스하기';

  @override
  String get chessBasics => '체스 기본';

  @override
  String get coaches => '코치';

  @override
  String get invalidPgn => '잘못된 PGN입니다.';

  @override
  String get invalidFen => '잘못된 FEN입니다.';

  @override
  String get custom => '사용자 지정';

  @override
  String get notifications => '알림';

  @override
  String notificationsX(String param1) {
    return '알림: $param1';
  }

  @override
  String perfRatingX(String param) {
    return '레이팅: $param';
  }

  @override
  String get practiceWithComputer => '컴퓨터와 연습하기';

  @override
  String anotherWasX(String param) {
    return '다른 수는 $param';
  }

  @override
  String bestWasX(String param) {
    return '최선의 수는 $param';
  }

  @override
  String get youBrowsedAway => '중간에 그만두셨습니다';

  @override
  String get resumePractice => '연습을 계속하기';

  @override
  String get drawByFiftyMoves => '게임이 50수 규칙에 의해 무승부가 되었습니다.';

  @override
  String get theGameIsADraw => '무승부 게임입니다.';

  @override
  String get computerThinking => '컴퓨터 생각 중…';

  @override
  String get seeBestMove => '최상의 수 보기';

  @override
  String get hideBestMove => '최상의 수 숨기기';

  @override
  String get getAHint => '힌트 보기';

  @override
  String get evaluatingYourMove => '이동하신 수를 평가 중입니다…';

  @override
  String get whiteWinsGame => '하얀색 승리';

  @override
  String get blackWinsGame => '검은색 승리';

  @override
  String get learnFromYourMistakes => '실수에서 배우기';

  @override
  String get learnFromThisMistake => '이 실수에서 배우기';

  @override
  String get skipThisMove => '이 수 넘기기';

  @override
  String get next => '다음으로';

  @override
  String xWasPlayed(String param) {
    return '$param 이 두어짐';
  }

  @override
  String get findBetterMoveForWhite => '흰색에게 좀 더 나은 수를 찾아보세요';

  @override
  String get findBetterMoveForBlack => '검은색에게 좀 더 나은 수를 찾아보세요';

  @override
  String get resumeLearning => '학습 계속하기';

  @override
  String get youCanDoBetter => '더 잘할 수 있어요';

  @override
  String get tryAnotherMoveForWhite => '흰색에게 또 다른 수를 찾아보세요';

  @override
  String get tryAnotherMoveForBlack => '검은색에게 또 다른 수를 찾아보세요';

  @override
  String get solution => '해답';

  @override
  String get waitingForAnalysis => '분석을 기다리는 중';

  @override
  String get noMistakesFoundForWhite => '백에게 악수는 없었습니다';

  @override
  String get noMistakesFoundForBlack => '흑에게 악수는 없었습니다';

  @override
  String get doneReviewingWhiteMistakes => '백의 악수 체크가 종료됨';

  @override
  String get doneReviewingBlackMistakes => '흑의 악수 체크가 종료됨';

  @override
  String get doItAgain => '다시 하기';

  @override
  String get reviewWhiteMistakes => '백의 악수를 체크';

  @override
  String get reviewBlackMistakes => '흑의 악수를 체크';

  @override
  String get advantage => '이득';

  @override
  String get opening => '오프닝';

  @override
  String get middlegame => '미들게임';

  @override
  String get endgame => '엔드게임';

  @override
  String get conditionalPremoves => '수 예측';

  @override
  String get addCurrentVariation => '현재의 변화를 추가';

  @override
  String get playVariationToCreateConditionalPremoves => '기물을 움직여 조건적인 수를 만들기';

  @override
  String get noConditionalPremoves => '조건적인 수가 없습니다';

  @override
  String playX(String param) {
    return '$param 를 둠';
  }

  @override
  String get showUnreadLichessMessage => '리체스로부터 비공개 메시지를 받았습니다.';

  @override
  String get clickHereToReadIt => '클릭하여 읽기';

  @override
  String get sorry => '죄송합니다 :(';

  @override
  String get weHadToTimeYouOutForAWhile => '짧은 시간동안 정지를 받으셨습니다.';

  @override
  String get why => '왜 그런가요?';

  @override
  String get pleasantChessExperience => '우리는 모두에게 즐거운 체스 경험을 제공하는 것을 목표로 합니다.';

  @override
  String get goodPractice => '그러기 위해서는, 우리는 모든 플레이어가 좋은 관행을 따르도록 보장해야 합니다.';

  @override
  String get potentialProblem => '잠재적인 문제가 감지되었을 때는, 우리는 이 메시지를 표시합니다.';

  @override
  String get howToAvoidThis => '이것을 어떻게 피할 수 있나요?';

  @override
  String get playEveryGame => '시작한 모든 게임을 플레이하세요.';

  @override
  String get tryToWin => '당신이 플레이하는 모든 게임에서 이기도록 (아니면 적어도 비기도록) 노력하세요.';

  @override
  String get resignLostGames => '패배한 게임에서는 기권하세요(시간이 흐르게 두지 마세요).';

  @override
  String get temporaryInconvenience => '일시적인 불편에 사과드리며,';

  @override
  String get wishYouGreatGames => 'lichess.org에서 좋은 게임 즐기시기 바랍니다.';

  @override
  String get thankYouForReading => '읽어 주셔서 감사합니다!';

  @override
  String get lifetimeScore => '통산 전적';

  @override
  String get currentMatchScore => '현재 경기 점수';

  @override
  String get agreementAssistance => '나는 게임 중 도움을 받지 않겠습니다 (체스 컴퓨터, 책, 데이터베이스나 다른 사람).';

  @override
  String get agreementNice => '나는 항상 다른 플레이어들을 존중하겠습니다.';

  @override
  String agreementMultipleAccounts(String param) {
    return '나는 다중 계정을 생성하지 않을 것에 동의합니다. ($param에 명시된 경우 제외)';
  }

  @override
  String get agreementPolicy => '나는 모든 Lichess 정책을 따르겠습니다.';

  @override
  String get searchOrStartNewDiscussion => '대화 찾기 또는 새 대화 시작하기';

  @override
  String get edit => '편집';

  @override
  String get bullet => '불릿';

  @override
  String get blitz => '블리츠';

  @override
  String get rapid => '래피드';

  @override
  String get classical => '클래시컬';

  @override
  String get ultraBulletDesc => '가장 빠른 게임: 30초 미만';

  @override
  String get bulletDesc => '매우 빠른 게임: 3분 미만';

  @override
  String get blitzDesc => '빠른 게임: 3에서 8분';

  @override
  String get rapidDesc => '래피드 게임: 8 ~ 25분';

  @override
  String get classicalDesc => '클래시컬 게임: 25분 이상';

  @override
  String get correspondenceDesc => '통신전: 한 수당 하루 또는 수 일';

  @override
  String get puzzleDesc => '체스 전술 트레이너';

  @override
  String get important => '중요!';

  @override
  String yourQuestionMayHaveBeenAnswered(String param1) {
    return '$param1에 원하시는 답변이 있을 수 있습니다.';
  }

  @override
  String get inTheFAQ => 'F.A.Q';

  @override
  String toReportSomeoneForCheatingOrBadBehavior(String param1) {
    return '$param1에서 엔진 사용이나 부적절한 행동을 신고하십시오.';
  }

  @override
  String get useTheReportForm => '사용자 신고';

  @override
  String toRequestSupport(String param1) {
    return '$param1에서 리체스에 문의하실 수 있습니다.';
  }

  @override
  String get tryTheContactPage => '연락처';

  @override
  String makeSureToRead(String param1) {
    return '$param1를 꼭 읽으세요';
  }

  @override
  String get theForumEtiquette => '포럼 에티켓';

  @override
  String get thisTopicIsArchived => '이 주제는 보존되어서 댓글을 남기실 수 없습니다.';

  @override
  String joinTheTeamXToPost(String param1) {
    return '이 포럼에 글을 올리시려면 $param1에 가입하셔야 합니다.';
  }

  @override
  String teamNamedX(String param1) {
    return '팀 $param1';
  }

  @override
  String get youCannotPostYetPlaySomeGames => '이 포럼에 글을 올리시기에는 게임 수가 부족합니다.';

  @override
  String get subscribe => '구독';

  @override
  String get unsubscribe => '구독 취소';

  @override
  String mentionedYouInX(String param1) {
    return '당신이 $param1에서 언급됨';
  }

  @override
  String xMentionedYouInY(String param1, String param2) {
    return '$param1가 당신을 \"$param2\"에서 언급했습니다.';
  }

  @override
  String invitedYouToX(String param1) {
    return '$param1에 초대합니다.';
  }

  @override
  String xInvitedYouToY(String param1, String param2) {
    return '$param1가 당신을 \"$param2\"에 초대합니다.';
  }

  @override
  String get youAreNowPartOfTeam => '당신은 이제 팀에 소속되었습니다.';

  @override
  String youHaveJoinedTeamX(String param1) {
    return '\"$param1\"에 가입되었습니다.';
  }

  @override
  String get someoneYouReportedWasBanned => '당신이 신고한 플레이어가 차단되었습니다.';

  @override
  String get congratsYouWon => '축하합니다. 승리하셨습니다!';

  @override
  String gameVsX(String param1) {
    return 'Game vs $param1';
  }

  @override
  String resVsX(String param1, String param2) {
    return '$param1 vs $param2';
  }

  @override
  String get lostAgainstTOSViolator => '당신은 Lichess의 서비스 약관을 어긴 플레이어에게 패배했습니다.';

  @override
  String refundXpointsTimeControlY(String param1, String param2) {
    return '환불: $param2 레이팅 포인트 $param1점';
  }

  @override
  String get timeAlmostUp => '시간이 거의 다 되었습니다!';

  @override
  String get clickToRevealEmailAddress => '[이메일 주소를 보려면 클릭]';

  @override
  String get download => '다운로드';

  @override
  String get coachManager => '코치 설정';

  @override
  String get streamerManager => '스트리머 설정';

  @override
  String get cancelTournament => '토너먼트 취소';

  @override
  String get tournDescription => '토너먼트 설명';

  @override
  String get tournDescriptionHelp => '참가자에게 하고 싶은 말이 있나요? 짧게 작성해주세요. 마크다운 링크가 가능합니다: [name](https://url)';

  @override
  String get ratedFormHelp => '레이팅 게임을 합니다\n플레이어 레이팅에 영향을 줍니다';

  @override
  String get onlyMembersOfTeam => '팀 멤버만';

  @override
  String get noRestriction => '제한 없음';

  @override
  String get minimumRatedGames => '최소 레이팅 게임 참여 횟수';

  @override
  String get minimumRating => '최소 레이팅';

  @override
  String get maximumWeeklyRating => '최대 주간 레이팅';

  @override
  String positionInputHelp(String param) {
    return '모든 게임을 주어진 포지션으로 시작하려면 FEN을 붙여넣으세요.\n일반 게임이 아닌 변형 체스에는 적용되지 않습니다.\nFEN 포지션을 생성하기 위해 $param를 사용할 수 있습니다.\n비워두면 일반 시작 포지션에서 시작합니다.';
  }

  @override
  String get cancelSimul => '동시대국 취소하기';

  @override
  String get simulHostcolor => '각 게임에서 호스트의 색';

  @override
  String get estimatedStart => '예상 시작 시간';

  @override
  String simulFeatured(String param) {
    return '$param에서 공개';
  }

  @override
  String simulFeaturedHelp(String param) {
    return '모두가 $param에서 동시대국을 볼 수 있습니다. 비공개 대국을 위해서는 비활성화하세요.';
  }

  @override
  String get simulDescription => '동시대국 설명';

  @override
  String get simulDescriptionHelp => '참가자들에게 하고 싶은 말이 있나요?';

  @override
  String markdownAvailable(String param) {
    return '추가로 $param 문법을 사용하실 수 있습니다.';
  }

  @override
  String get embedsAvailable => '포함할 게임 URL 또는 스터디 챕터 URL을 붙여넣으세요.';

  @override
  String get inYourLocalTimezone => '본인의 현지 시간대 기준';

  @override
  String get tournChat => '토너먼트 채팅';

  @override
  String get noChat => '채팅 없음';

  @override
  String get onlyTeamLeaders => '팀 리더만';

  @override
  String get onlyTeamMembers => '팀 멤버만';

  @override
  String get navigateMoveTree => '수 탐색';

  @override
  String get mouseTricks => '마우스 기능';

  @override
  String get toggleLocalAnalysis => '로컬 컴퓨터 분석 켜기/끄기';

  @override
  String get toggleAllAnalysis => '모든 컴퓨터 분석 켜기/끄기';

  @override
  String get playComputerMove => '최선의 컴퓨터 수 두기';

  @override
  String get analysisOptions => '분석 옵션';

  @override
  String get focusChat => '채팅에 포커스 주기';

  @override
  String get showHelpDialog => '이 도움말 보기';

  @override
  String get reopenYourAccount => '계정 다시 활성화';

  @override
  String get closedAccountChangedMind => '계정을 폐쇄한 후 마음이 바뀌었다면, 계정을 다시 활성화할 수 있는 기회가 한 번 있습니다.';

  @override
  String get onlyWorksOnce => '단 한번만 가능합니다.';

  @override
  String get cantDoThisTwice => '계정을 두 번째로 폐쇄했다면 복구할 방법이 없습니다.';

  @override
  String get emailAssociatedToaccount => '계정에 등록된 이메일 주소';

  @override
  String get sentEmailWithLink => '링크가 포함된 이메일을 보냈습니다.';

  @override
  String get tournamentEntryCode => '토너먼트 입장 코드';

  @override
  String get hangOn => '잠깐!';

  @override
  String gameInProgress(String param) {
    return '$param와 진행중인 게임이 있습니다.';
  }

  @override
  String get abortTheGame => '게임 중단';

  @override
  String get resignTheGame => '게임 기권';

  @override
  String get youCantStartNewGame => '이 게임이 끝나기 전까지 새 게임을 시작할 수 없습니다.';

  @override
  String get since => '부터';

  @override
  String get until => '까지';

  @override
  String get lichessDbExplanation => '모든 리체스 플레이어의 레이팅 게임 샘플';

  @override
  String get switchSides => '색 바꾸기';

  @override
  String get closingAccountWithdrawAppeal => '계정을 폐쇄하면 이의 제기는 자동으로 취소됩니다';

  @override
  String get ourEventTips => '이벤트 준비를 위한 팁';

  @override
  String get instructions => '설명';

  @override
  String get showMeEverything => '모두 보기';

  @override
  String get lichessPatronInfo => 'Lichess는 비영리 기구이며 완전한 무료/자유 오픈소스 소프트웨어입니다.\n모든 운영 비용, 개발, 컨텐츠 조달은 전적으로 사용자들의 기부로 이루어집니다.';

  @override
  String get nothingToSeeHere => '지금은 여기에 볼 것이 없습니다.';

  @override
  String opponentLeftCounter(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '당신의 상대가 게임을 나갔습니다. $count 초 후에 승리를 주장할 수 있습니다.',
    );
    return '$_temp0';
  }

  @override
  String mateInXHalfMoves(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count반수만에 체크메이트',
    );
    return '$_temp0';
  }

  @override
  String nbBlunders(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 블런더',
    );
    return '$_temp0';
  }

  @override
  String nbMistakes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 실수',
    );
    return '$_temp0';
  }

  @override
  String nbInaccuracies(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 사소한 실수',
    );
    return '$_temp0';
  }

  @override
  String nbPlayers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count명의 플레이어',
    );
    return '$_temp0';
  }

  @override
  String nbGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count개의 게임',
    );
    return '$_temp0';
  }

  @override
  String ratingXOverYGames(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$param2게임간의 $count 레이팅',
    );
    return '$_temp0';
  }

  @override
  String nbBookmarks(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count개의 즐겨찾기',
    );
    return '$_temp0';
  }

  @override
  String nbDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count일',
    );
    return '$_temp0';
  }

  @override
  String nbHours(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count시간',
    );
    return '$_temp0';
  }

  @override
  String nbMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count분',
    );
    return '$_temp0';
  }

  @override
  String rankIsUpdatedEveryNbMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '순위는 매 $count분마다 갱신됩니다.',
    );
    return '$_temp0';
  }

  @override
  String nbPuzzles(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '퍼즐 $count개',
    );
    return '$_temp0';
  }

  @override
  String nbGamesWithYou(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '나와 $count번 대국 함',
    );
    return '$_temp0';
  }

  @override
  String nbRated(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count번의 레이팅 대국',
    );
    return '$_temp0';
  }

  @override
  String nbWins(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count번 승리',
    );
    return '$_temp0';
  }

  @override
  String nbLosses(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count번 패배',
    );
    return '$_temp0';
  }

  @override
  String nbDraws(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count번 비김',
    );
    return '$_temp0';
  }

  @override
  String nbPlaying(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '플레이 중인 게임 $count개',
    );
    return '$_temp0';
  }

  @override
  String giveNbSeconds(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count초 더 주기',
    );
    return '$_temp0';
  }

  @override
  String nbTournamentPoints(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 토너먼트 포인트',
    );
    return '$_temp0';
  }

  @override
  String nbStudies(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 연구',
    );
    return '$_temp0';
  }

  @override
  String nbSimuls(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 동시대국',
    );
    return '$_temp0';
  }

  @override
  String moreThanNbRatedGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '레이팅전 $count 국 이상',
    );
    return '$_temp0';
  }

  @override
  String moreThanNbPerfRatedGames(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$param2 레이팅전 $count 국 이상',
    );
    return '$_temp0';
  }

  @override
  String needNbMorePerfGames(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$param2 랭크 게임을 $count회 더 플레이해야합니다.',
    );
    return '$_temp0';
  }

  @override
  String needNbMoreGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '랭크 게임을 $count회 더 플레이하셔야 합니다.',
    );
    return '$_temp0';
  }

  @override
  String nbImportedGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '불러온 게임 $count개',
    );
    return '$_temp0';
  }

  @override
  String nbFriendsOnline(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count명의 친구들이 접속중',
    );
    return '$_temp0';
  }

  @override
  String nbFollowers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '팔로워 $count명',
    );
    return '$_temp0';
  }

  @override
  String nbFollowing(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '팔로잉 $count명',
    );
    return '$_temp0';
  }

  @override
  String lessThanNbMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count분 미만',
    );
    return '$_temp0';
  }

  @override
  String nbGamesInPlay(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count개의 게임 플레이 중',
    );
    return '$_temp0';
  }

  @override
  String maximumNbCharacters(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '최대 $count자.',
    );
    return '$_temp0';
  }

  @override
  String blocks(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '차단한 사람 $count명',
    );
    return '$_temp0';
  }

  @override
  String nbForumPosts(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 포럼 글',
    );
    return '$_temp0';
  }

  @override
  String nbPerfTypePlayersThisWeek(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '이번 주의 $param2 플레이어는 $count명입니다.',
    );
    return '$_temp0';
  }

  @override
  String availableInNbLanguages(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count개의 언어 지원!',
    );
    return '$_temp0';
  }

  @override
  String nbSecondsToPlayTheFirstMove(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 초 안에 첫 수를 두십시오.',
    );
    return '$_temp0';
  }

  @override
  String nbSeconds(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count초',
    );
    return '$_temp0';
  }

  @override
  String andSaveNbPremoveLines(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 종류의 조건 수를 설정',
    );
    return '$_temp0';
  }

  @override
  String get stormMoveToStart => '기물을 움직이면 시작';

  @override
  String get stormYouPlayTheWhitePiecesInAllPuzzles => '당신은 모든 퍼즐을 백으로 플레이합니다';

  @override
  String get stormYouPlayTheBlackPiecesInAllPuzzles => '당신은 모든 퍼즐을 흑으로 플레이합니다';

  @override
  String get stormPuzzlesSolved => '퍼즐 해결';

  @override
  String get stormNewDailyHighscore => '새 일일 최고 기록!';

  @override
  String get stormNewWeeklyHighscore => '새 주간 최고 기록!';

  @override
  String get stormNewMonthlyHighscore => '새 월간 최고 기록!';

  @override
  String get stormNewAllTimeHighscore => '새 역대 최고 기록!';

  @override
  String stormPreviousHighscoreWasX(String param) {
    return '이전 최고 기록은 $param입니다.';
  }

  @override
  String get stormPlayAgain => '다시 플레이';

  @override
  String stormHighscoreX(String param) {
    return '최고기록: $param';
  }

  @override
  String get stormScore => '점수';

  @override
  String get stormMoves => '이동';

  @override
  String get stormAccuracy => '정확도';

  @override
  String get stormCombo => '콤보';

  @override
  String get stormTime => '시간';

  @override
  String get stormTimePerMove => '한 수당 시간';

  @override
  String get stormHighestSolved => '최고 해결 레이팅';

  @override
  String get stormPuzzlesPlayed => '플레이한 퍼즐';

  @override
  String get stormNewRun => '새로 시작(단축키: 스페이스바)';

  @override
  String get stormEndRun => '끝내기(단축키: 엔터)';

  @override
  String get stormHighscores => '하이스코어';

  @override
  String get stormViewBestRuns => '최고 기록 보기';

  @override
  String get stormBestRunOfDay => '일일 최고기록';

  @override
  String get stormRuns => '도전 횟수';

  @override
  String get stormGetReady => '준비!';

  @override
  String get stormWaitingForMorePlayers => '더 많은 플레이어를 기다리는 중...';

  @override
  String get stormRaceComplete => '레이스 완료!';

  @override
  String get stormSpectating => '관전';

  @override
  String get stormJoinTheRace => '레이스에 참가!';

  @override
  String get stormStartTheRace => '레이스 시작';

  @override
  String stormYourRankX(String param) {
    return '당신의 순위: $param';
  }

  @override
  String get stormWaitForRematch => '재경기를 위해 대기';

  @override
  String get stormNextRace => '다음 레이스';

  @override
  String get stormJoinRematch => '재경기 참가';

  @override
  String get stormWaitingToStart => '시작 대기 중';

  @override
  String get stormCreateNewGame => '새로운 게임 만들기';

  @override
  String get stormJoinPublicRace => '공개 레이스에 참가';

  @override
  String get stormRaceYourFriends => '친구와 레이스';

  @override
  String get stormSkip => '건너뛰기';

  @override
  String get stormSkipHelp => '레이스 당 한 번 건너뛸 수 있습니다:';

  @override
  String get stormSkipExplanation => '이 수를 건너뛰고 콤보 기록을 보존하세요! 한 레이스에 한 번만 가능합니다.';

  @override
  String get stormFailedPuzzles => '실패한 퍼즐';

  @override
  String get stormSlowPuzzles => '느린 퍼즐';

  @override
  String get stormSkippedPuzzle => '건너뛴 퍼즐';

  @override
  String get stormThisWeek => '이번 주';

  @override
  String get stormThisMonth => '이번 달';

  @override
  String get stormAllTime => '모든 기간';

  @override
  String get stormClickToReload => '눌러서 새로고침';

  @override
  String get stormThisRunHasExpired => '이 도전은 만료되었습니다!';

  @override
  String get stormThisRunWasOpenedInAnotherTab => '이 도전은 다른 탭에서 열렸습니다!';

  @override
  String stormXRuns(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count번 도전',
    );
    return '$_temp0';
  }

  @override
  String stormPlayedNbRunsOfPuzzleStorm(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$param2 중$count개 플레이함',
    );
    return '$_temp0';
  }

  @override
  String get streamerLichessStreamers => 'Lichess 스트리머';

  @override
  String get studyShareAndExport => '공유 및 내보내기';

  @override
  String get studyStart => '시작';
}
