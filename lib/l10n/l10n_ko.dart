// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'l10n.dart';

// ignore_for_file: type=lint

/// The translations for Korean (`ko`).
class AppLocalizationsKo extends AppLocalizations {
  AppLocalizationsKo([String locale = 'ko']) : super(locale);

  @override
  String get mobileAllGames => '모든 대국';

  @override
  String get mobileAreYouSure => '확실하십니까?';

  @override
  String get mobileBoardSettings => 'Board settings';

  @override
  String get mobileCancelTakebackOffer => '무르기 요청 취소';

  @override
  String get mobileClearButton => '지우기';

  @override
  String get mobileCorrespondenceClearSavedMove => '저장된 수 삭제';

  @override
  String get mobileCustomGameJoinAGame => '게임 참가';

  @override
  String get mobileFeedbackButton => '피드백';

  @override
  String mobileGoodEvening(String param) {
    return 'Good evening, $param';
  }

  @override
  String get mobileGoodEveningWithoutName => 'Good evening';

  @override
  String mobileGoodDay(String param) {
    return 'Good day, $param';
  }

  @override
  String get mobileGoodDayWithoutName => 'Good day';

  @override
  String get mobileHideVariation => '바리에이션 숨기기';

  @override
  String get mobileHomeTab => '홈';

  @override
  String get mobileLiveStreamers => '방송 중인 스트리머';

  @override
  String get mobileMustBeLoggedIn => '이 페이지를 보려면 로그인해야 합니다.';

  @override
  String get mobileNoSearchResults => '결과 없음';

  @override
  String get mobileNotFollowingAnyUser => '팔로우한 사용자가 없습니다.';

  @override
  String get mobileOkButton => '확인';

  @override
  String get mobileOverTheBoard => 'Over the board';

  @override
  String mobilePlayersMatchingSearchTerm(String param) {
    return '닉네임에 \"$param\"가 포함된 플레이어';
  }

  @override
  String get mobilePrefMagnifyDraggedPiece => '드래그한 기물 확대하기';

  @override
  String get mobilePuzzleStormConfirmEndRun => '이 도전을 종료하시겠습니까?';

  @override
  String get mobilePuzzleStormFilterNothingToShow => '표시할 것이 없습니다. 필터를 변경해 주세요';

  @override
  String get mobilePuzzleStormNothingToShow => '표시할 것이 없습니다. 먼저 퍼즐 스톰을 플레이하세요.';

  @override
  String get mobilePuzzleStormSubtitle => '3분 이내에 최대한 많은 퍼즐을 해결하십시오.';

  @override
  String get mobilePuzzleStreakAbortWarning => '현재 연속 해결 기록을 잃고 점수는 저장됩니다.';

  @override
  String get mobilePuzzleThemesSubtitle => '당신이 가장 좋아하는 오프닝으로부터의 퍼즐을 플레이하거나, 테마를 선택하십시오.';

  @override
  String get mobilePuzzlesTab => '퍼즐';

  @override
  String get mobileRecentSearches => '최근 검색어';

  @override
  String get mobileRemoveBookmark => 'Remove bookmark';

  @override
  String get mobileSettingsImmersiveMode => '전체 화면 모드';

  @override
  String get mobileSettingsImmersiveModeSubtitle =>
      'Hide system UI while playing. Use this if you are bothered by the system\'s navigation gestures at the edges of the screen. Applies to game and puzzle screens.';

  @override
  String get mobileSettingsTab => '설정';

  @override
  String get mobileShareGamePGN => 'PGN 공유';

  @override
  String get mobileShareGameURL => '게임 URL 공유';

  @override
  String get mobileSharePositionAsFEN => 'FEN으로 공유';

  @override
  String get mobileSharePuzzle => '이 퍼즐 공유';

  @override
  String get mobileShowComments => '댓글 보기';

  @override
  String get mobileShowResult => '결과 표시';

  @override
  String get mobileShowVariations => '바리에이션 보이기';

  @override
  String get mobileSomethingWentWrong => '문제가 발생했습니다.';

  @override
  String get mobileSystemColors => '시스템 색상';

  @override
  String get mobileTapHereToStartPlayingChess => 'Tap here to start playing chess.';

  @override
  String get mobileTheme => '테마';

  @override
  String get mobileToolsTab => '도구';

  @override
  String mobileUnsupportedVariant(String param) {
    return 'Variant $param is not supported in this version';
  }

  @override
  String get mobileWaitingForOpponentToJoin => '상대 참가를 기다리는 중...';

  @override
  String get mobileWatchTab => '관람';

  @override
  String get mobileWelcomeToLichessApp => 'Welcome to Lichess app!';

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
      other: '$count개월 동안 $param2으로 lichess.org를 후원함',
    );
    return '$_temp0';
  }

  @override
  String activityPracticedNbPositions(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$param2에서 총 $count개의 포지션을 연습함',
    );
    return '$_temp0';
  }

  @override
  String activitySolvedNbPuzzles(int count) {
    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '전술 문제 $count개를 해결함');
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
    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '수 $count개를 둠');
    return '$_temp0';
  }

  @override
  String activityInNbCorrespondenceGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '$count개의 통신 대국에서');
    return '$_temp0';
  }

  @override
  String activityCompletedNbGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '$count번의 통신 대국을 완료함');
    return '$_temp0';
  }

  @override
  String activityCompletedNbVariantGames(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count번의 $param2 통신 대국을 완료함',
    );
    return '$_temp0';
  }

  @override
  String activityFollowedNbPlayers(int count) {
    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '$count 명을 팔로우 개시');
    return '$_temp0';
  }

  @override
  String activityGainedNbFollowers(int count) {
    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '$count 명의 신규 팔로워를 얻음');
    return '$_temp0';
  }

  @override
  String activityHostedNbSimuls(int count) {
    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '$count 번의 동시대국을 주최함');
    return '$_temp0';
  }

  @override
  String activityJoinedNbSimuls(int count) {
    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '$count 번의 동시대국에 참가함');
    return '$_temp0';
  }

  @override
  String activityCreatedNbStudies(int count) {
    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '새 연구 $count개 작성함');
    return '$_temp0';
  }

  @override
  String activityCompetedInNbTournaments(int count) {
    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '$count 번 토너먼트에 참가함');
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
    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '$count 번 토너먼트에 참가함');
    return '$_temp0';
  }

  @override
  String activityJoinedNbTeams(int count) {
    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '$count 팀에 참가함');
    return '$_temp0';
  }

  @override
  String get arenaArena => '아레나';

  @override
  String get arenaArenaTournaments => '아레나 토너먼트';

  @override
  String get arenaIsItRated => '레이팅이 적용되나요?';

  @override
  String get arenaWillBeNotified => '토너먼트가 시작하기 전 당신에게 알림이 발송되니 다른 탭에서 플레이하셔도 안전합니다.';

  @override
  String get arenaIsRated => '이 토너먼트는 레이팅이 적용되며 당신의 레이팅에 영향을 끼칠 것입니다.';

  @override
  String get arenaIsNotRated => '이 토너먼트는 레이팅이 적용되지 않으며 당신의 레이팅에 영향을 끼치지 않을 것입니다.';

  @override
  String get arenaSomeRated => '몇몇 토너먼트는 레이팅이 적용되며 당신의 레이팅에 영향을 끼칠 것입니다.';

  @override
  String get arenaHowAreScoresCalculated => '점수는 어떻게 계산되나요?';

  @override
  String get arenaHowAreScoresCalculatedAnswer =>
      '승리하면 기본 점수 2점, 비기면 1점, 패할 시 0점을 얻습니다.\n두개의 대국을 연속적으로 이기면 불꽃 모양의 아이콘을 얻으며, 더블 포인트 기록을 시작합니다.\n다음 대국들에서는 패배할 때까지 두 배의 점수를 얻습니다.\n말인 즉슨, 승리시 4점, 무승부시 2점, 패배시는 전과 같이 0점으로 취급됩니다.\n\n예를 들어, 두 번 승리 후 한 번 비길 경우에는 6점을 얻습니다: 2 + 2 (2 x 1)';

  @override
  String get arenaBerserk => '버서크（Berserk）';

  @override
  String get arenaBerserkAnswer =>
      '대국을 시작할 때, 옆의 \"버서크 (berserk)\" 버튼을 클릭하면, 가진 시간이 절반으로 깎이는 대신에 이길 경우 1점의 보너스 점수를 얻을 수 있습니다.\n\n증초가 있는 타임 컨트롤에서는 증초도 사라집니다. (단, 1+2 는 예외로, 1+0이 됩니다.)\n\n초기 시간이 0일 경우 (예: 0+1,0+2), 버서크에 돌입할 수 없습니다.\n\n버서크로 인한 보너스 점수를 얻기 위해서는 적어도 7수를 두어야 합니다.';

  @override
  String get arenaHowIsTheWinnerDecided => '승자는 어떻게 결정합니까?';

  @override
  String get arenaHowIsTheWinnerDecidedAnswer =>
      '토너먼트의 예정된 종료시각에 가장 많은 점수를 가지고 있는 플레이어가 승자로 결정됩니다.\n\n두 플레이어가 같은 점수일 경우에는, 토너먼트 내에서의 퍼포먼스 레이팅으로 승자를 가릅니다.';

  @override
  String get arenaHowDoesPairingWork => '대전 매칭은 어떻게 이루어집니까?';

  @override
  String get arenaHowDoesPairingWorkAnswer =>
      '토너먼트가 시작할 때에는, 레이팅을 기준으로 플레이어들이 매칭됩니다.\n게임을 끝내면 바로 토너먼토 로비에 돌아오십시오. 그러면 자신의 토너먼트 순위와 제일 가까운 플레이어와 매칭될 것입니다. 이 방법에 따르면 기다리는 시간이 최소화되지만, 토너먼트 내의 모든 플레이어와 만날 수 없을 수도 있습니다.\n빠르게 두고 로비에 나와 많은 게임을 플레이하여 더 많은 점수를 얻으십시오.';

  @override
  String get arenaHowDoesItEnd => '토너먼트는 어떻게 종료됩니까?';

  @override
  String get arenaHowDoesItEndAnswer =>
      '토너먼트에는 시간 제한이 있습니다. 남은 시간이 0이 되었을 때, 토너먼트 순위가 결정되고, 승자가 발표됩니다. 이 경우에, 진행중인 게임은 끝까지 두실 수 있지만, 토너먼트의 결과에는 영향을 주지 않습니다.';

  @override
  String get arenaOtherRules => '그 외 중요한 규칙';

  @override
  String get arenaThereIsACountdown => '당신의 첫 수에 카운트다운이 있습니다. 첫 수를 이 시간 내에 두지 않으면 게임에서 지게 됩니다.';

  @override
  String get arenaThisIsPrivate => '이 토너먼트는 비공개 토너먼트 입니다.';

  @override
  String arenaShareUrl(String param) {
    return '모두가 참여할 수 있게 이 URL을 공유해 주세요: $param';
  }

  @override
  String arenaDrawStreakStandard(String param) {
    return '연속 무승부: 플레이어가 2게임 이상 연속으로 무승부를 기록할 경우, 첫 무승부 또는 $param수 이상을 두고 발생한 무승부에만 점수가 주어질 것입니다. 연속 무승부는 게임에서 승리하면 초기화됩니다.';
  }

  @override
  String get arenaDrawStreakVariants =>
      '승점을 얻을 수 있는 비긴 게임의 최소 길이는 게임 종류에 따라 다릅니다. 아래 표에는 각 게임 종류에 따른 최소 값이 있습니다.';

  @override
  String get arenaVariant => '게임 종류';

  @override
  String get arenaMinimumGameLength => '최소 게임 길이';

  @override
  String get arenaHistory => '아레나 히스토리';

  @override
  String get arenaNewTeamBattle => '새 팀 배틀';

  @override
  String get arenaCustomStartDate => '시작시간 설정';

  @override
  String get arenaCustomStartDateHelp => '당신의 현지 시간대입니다. \"토너먼트 시작까지 시간\" 설정을 덮어씁니다.';

  @override
  String get arenaAllowBerserk => '버서크 모드 허용';

  @override
  String get arenaAllowBerserkHelp => '플레이어는 자신의 시간을 절반으로 줄이며 대신 추가 승점을 얻습니다';

  @override
  String get arenaAllowChatHelp => '플레이어가 채팅방에서 토론할 수 있습니다';

  @override
  String get arenaArenaStreaks => '아레나 연승';

  @override
  String get arenaArenaStreaksHelp => '2승 이후 추가로 연승을 하면 2점이 아니라 4점을 얻습니다.';

  @override
  String get arenaNoBerserkAllowed => '버서크 모드 허용 안 함';

  @override
  String get arenaNoArenaStreaks => '아레나 연승 없음';

  @override
  String get arenaAveragePerformance => '평균 성과';

  @override
  String get arenaAverageScore => '평균 점수';

  @override
  String get arenaMyTournaments => '내 토너먼트';

  @override
  String get arenaEditTournament => '토너먼트 편집하기';

  @override
  String get arenaEditTeamBattle => '팀 배틀 편집하기';

  @override
  String get arenaDefender => '타이틀 보유자';

  @override
  String get arenaPickYourTeam => '팀을 고르세요';

  @override
  String get arenaWhichTeamWillYouRepresentInThisBattle => '이 경기에서 어떤 팀을 대표하실건가요?';

  @override
  String get arenaYouMustJoinOneOfTheseTeamsToParticipate => '참여하기 위해서는 이 팀 중 하나에 가입해야 합니다!';

  @override
  String get arenaCreated => '생성됨';

  @override
  String get arenaRecentlyPlayed => '최근에 플레이함';

  @override
  String get arenaBestResults => '최선의 결과';

  @override
  String get arenaTournamentStats => '토너먼트 통계';

  @override
  String get arenaRankAvgHelp =>
      '백분위 순위는 말 그대로 순위의 백분율입니다. 즉, 백분위 순위는 낮을수록 더 높은 순위를 의미합니다. \n\n예를 들어, 100명의 참가자가 참여하는 토너먼트에서 3위를 차지하면 3%가 되고, 1000명의 참가자가 참여하는 토너먼트에서 10위를 차지하면 1%가 됩니다.';

  @override
  String get arenaMedians => '중앙값';

  @override
  String arenaAllAveragesAreX(String param) {
    return '이 페이지의 모든 평균값은 $param 입니다.';
  }

  @override
  String get arenaTotal => '합계';

  @override
  String get arenaPointsAvg => '평균 점수';

  @override
  String get arenaPointsSum => '총합 점수';

  @override
  String get arenaRankAvg => '백분위 순위';

  @override
  String get arenaTournamentWinners => '토너먼트 우승자';

  @override
  String get arenaTournamentShields => '토너먼트 실드';

  @override
  String get arenaOnlyTitled => '타이틀 플레이어만';

  @override
  String get arenaOnlyTitledHelp => '토너먼트에 참여하기 위해서는 공식 타이틀이 있어야 합니다.';

  @override
  String get arenaTournamentPairingsAreNowClosed => '토너먼트 매칭이 이제 종료되었습니다.';

  @override
  String get arenaBerserkRate => '버서크 비율';

  @override
  String arenaDrawingWithinNbMoves(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count수 내에 무승부로 게임이 끝나면 어떤 플레이어도 점수를 얻지 못합니다.',
    );
    return '$_temp0';
  }

  @override
  String arenaViewAllXTeams(int count) {
    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '모두 $count개 팀 보기');
    return '$_temp0';
  }

  @override
  String get broadcastBroadcasts => '방송';

  @override
  String get broadcastMyBroadcasts => '내 방송';

  @override
  String get broadcastLiveBroadcasts => '실시간 대회 방송';

  @override
  String get broadcastBroadcastCalendar => '방송 달력';

  @override
  String get broadcastNewBroadcast => '새 실시간 방송';

  @override
  String get broadcastSubscribedBroadcasts => '구독 중인 방송';

  @override
  String get broadcastAboutBroadcasts => '방송에 대해서';

  @override
  String get broadcastHowToUseLichessBroadcasts => 'Lichess 방송을 사용하는 방법.';

  @override
  String get broadcastTheNewRoundHelp => '새로운 라운드에는 이전 라운드와 동일한 구성원과 기여자가 있을 것입니다.';

  @override
  String get broadcastAddRound => '라운드 추가';

  @override
  String get broadcastOngoing => '진행중';

  @override
  String get broadcastUpcoming => '방영 예정';

  @override
  String get broadcastRoundName => '라운드 이름';

  @override
  String get broadcastRoundNumber => '라운드 숫자';

  @override
  String get broadcastTournamentName => '토너먼트 이름';

  @override
  String get broadcastTournamentDescription => '짧은 토너먼트 설명';

  @override
  String get broadcastFullDescription => '전체 이벤트 설명';

  @override
  String broadcastFullDescriptionHelp(String param1, String param2) {
    return '(선택) 방송에 대한 긴 설명입니다. $param1 사용이 가능합니다. 길이는 $param2 글자보다 짧아야 합니다.';
  }

  @override
  String get broadcastSourceSingleUrl => 'PGN Source URL';

  @override
  String get broadcastSourceUrlHelp =>
      'Lichess가 PGN 업데이트를 받기 위해 확인할 URL입니다. 인터넷에서 공개적으로 액세스 할 수 있어야 합니다.';

  @override
  String get broadcastSourceGameIds => '공간으로 나눠진 64개까지의 Lichess 경기 ID.';

  @override
  String broadcastStartDateTimeZone(String param) {
    return '내 시간대의 토너먼트 시작 날짜: $param';
  }

  @override
  String get broadcastStartDateHelp => '선택 사항, 언제 이벤트가 시작되는지 알고 있는 경우';

  @override
  String get broadcastCurrentGameUrl => '현재 게임 URL';

  @override
  String get broadcastDownloadAllRounds => '모든 라운드 다운로드받기';

  @override
  String get broadcastResetRound => '라운드 초기화';

  @override
  String get broadcastDeleteRound => '라운드 삭제';

  @override
  String get broadcastDefinitivelyDeleteRound => '라운드와 해당 게임을 완전히 삭제합니다.';

  @override
  String get broadcastDeleteAllGamesOfThisRound =>
      '이 라운드의 모든 게임을 삭제합니다. 다시 생성하려면 소스가 활성화되어 있어야 합니다.';

  @override
  String get broadcastEditRoundStudy => '경기 연구 편집';

  @override
  String get broadcastDeleteTournament => '이 토너먼트 삭제';

  @override
  String get broadcastDefinitivelyDeleteTournament => '토너먼트 전체의 모든 라운드와 게임을 완전히 삭제합니다.';

  @override
  String get broadcastShowScores => '게임 결과에 따라 플레이어 점수 표시';

  @override
  String get broadcastReplacePlayerTags => '선택 사항: 플레이어 이름, 레이팅 및 타이틀 바꾸기';

  @override
  String get broadcastFideFederations => 'FIDE 연맹';

  @override
  String get broadcastTop10Rating => 'Top 10 레이팅';

  @override
  String get broadcastFidePlayers => 'FIDE 선수들';

  @override
  String get broadcastFidePlayerNotFound => 'FIDE 선수 찾지 못함';

  @override
  String get broadcastFideProfile => 'FIDE 프로필';

  @override
  String get broadcastFederation => '연맹';

  @override
  String get broadcastAgeThisYear => '올해 나이';

  @override
  String get broadcastUnrated => '비레이팅';

  @override
  String get broadcastRecentTournaments => '최근 토너먼트';

  @override
  String get broadcastOpenLichess => 'Lichess에서 열기';

  @override
  String get broadcastTeams => '팀';

  @override
  String get broadcastBoards => '보드';

  @override
  String get broadcastOverview => '개요';

  @override
  String get broadcastSubscribeTitle =>
      '라운드가 시작될 때 알림을 받으려면 구독하세요. 계정 설정에서 방송을 위한 벨이나 알림 푸시를 토글할 수 있습니다.';

  @override
  String get broadcastUploadImage => '토너먼트 사진 업로드';

  @override
  String get broadcastNoBoardsYet => '아직 보드가 없습니다. 게임들이 업로드되면 나타납니다.';

  @override
  String broadcastBoardsCanBeLoaded(String param) {
    return '보드들은 소스나 $param(으)로 로드될 수 있습니다';
  }

  @override
  String broadcastStartsAfter(String param) {
    return '$param 후 시작';
  }

  @override
  String get broadcastStartVerySoon => '방송이 곧 시작됩니다.';

  @override
  String get broadcastNotYetStarted => '아직 방송이 시작을 하지 않았습니다.';

  @override
  String get broadcastOfficialWebsite => '공식 웹사이트';

  @override
  String get broadcastStandings => '순위';

  @override
  String get broadcastOfficialStandings => '공식 순위';

  @override
  String broadcastIframeHelp(String param) {
    return '$param에서 더 많은 정보를 확인하실 수 있습니다';
  }

  @override
  String get broadcastWebmastersPage => '웹마스터 페이지';

  @override
  String broadcastPgnSourceHelp(String param) {
    return '이 라운드의 공개된, 실시간 PGN 소스 입니다. 보다 더 빠르고 효율적인 동기화를 위해 $param도 제공됩니다.';
  }

  @override
  String get broadcastEmbedThisBroadcast => '이 방송을 웹사이트에 삽입하세요';

  @override
  String broadcastEmbedThisRound(String param) {
    return '$param을(를) 웹사이트에 삽입하세요';
  }

  @override
  String get broadcastRatingDiff => '레이팅 차이';

  @override
  String get broadcastGamesThisTournament => '이 토너먼트의 게임들';

  @override
  String get broadcastScore => '점수';

  @override
  String get broadcastAllTeams => '모든 팀';

  @override
  String get broadcastTournamentFormat => '토너먼트 형식';

  @override
  String get broadcastTournamentLocation => '토너먼트 장소';

  @override
  String get broadcastTopPlayers => '상위 플레이어들';

  @override
  String get broadcastTimezone => '시간대';

  @override
  String get broadcastFideRatingCategory => 'FIDE 레이팅 범주';

  @override
  String get broadcastOptionalDetails => '선택적 세부 정보';

  @override
  String get broadcastPastBroadcasts => '과거 방송들';

  @override
  String get broadcastAllBroadcastsByMonth => '월별 방송들 모두 보기';

  @override
  String get broadcastBackToLiveMove => '실시간 수로 돌아가기';

  @override
  String get broadcastSinceHideResults => '결과를 숨기도록 설정하였기에, 스포일러 방지 차원에서 모든 보드 미리보기가 비어 있습니다.';

  @override
  String get broadcastLiveboard => '실시간 체스판';

  @override
  String broadcastNbBroadcasts(int count) {
    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '$count 방송');
    return '$_temp0';
  }

  @override
  String broadcastNbViewers(int count) {
    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '시청자 $count명');
    return '$_temp0';
  }

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
  String get challengeDeclineTooFast => '시간이 너무 짧습니다. 더 느린 게임으로 신청해주세요.';

  @override
  String get challengeDeclineTooSlow => '시간이 너무 깁니다. 더 빠른 게임으로 다시 신청해주세요.';

  @override
  String get challengeDeclineTimeControl => '이 시간 제한으로는 도전을 받지 않겠습니다.';

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
  String get coordinatesCoordinates => 'Coordinates';

  @override
  String get coordinatesCoordinateTraining => 'Coordinate training';

  @override
  String coordinatesAverageScoreAsWhiteX(String param) {
    return 'Average score as white: $param';
  }

  @override
  String coordinatesAverageScoreAsBlackX(String param) {
    return 'Average score as black: $param';
  }

  @override
  String get coordinatesKnowingTheChessBoard =>
      'Knowing the chessboard coordinates is a very important skill for several reasons:';

  @override
  String get coordinatesMostChessCourses =>
      'Most chess courses and exercises use the algebraic notation extensively.';

  @override
  String get coordinatesTalkToYourChessFriends =>
      'It makes it easier to talk to your chess friends, since you both understand the \'language of chess\'.';

  @override
  String get coordinatesYouCanAnalyseAGameMoreEffectively =>
      'You can analyse a game more effectively if you can quickly recognise coordinates.';

  @override
  String get coordinatesACoordinateAppears =>
      'A coordinate appears on the board and you must click on the corresponding square.';

  @override
  String get coordinatesASquareIsHighlightedExplanation =>
      'A square is highlighted on the board and you must enter its coordinate (e.g. \"e4\").';

  @override
  String get coordinatesYouHaveThirtySeconds =>
      'You have 30 seconds to correctly map as many squares as possible!';

  @override
  String get coordinatesGoAsLongAsYouWant => 'Go as long as you want, there is no time limit!';

  @override
  String get coordinatesShowCoordinates => 'Show coordinates';

  @override
  String get coordinatesShowCoordsOnAllSquares => 'Coordinates on every square';

  @override
  String get coordinatesShowPieces => 'Show pieces';

  @override
  String get coordinatesStartTraining => 'Start training';

  @override
  String get coordinatesFindSquare => 'Find square';

  @override
  String get coordinatesNameSquare => 'Name square';

  @override
  String get coordinatesPracticeOnlySomeFilesAndRanks => 'Practice only some files & ranks';

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
  String get perfStatTotalGames => '총 대국';

  @override
  String get perfStatRatedGames => '레이팅 게임';

  @override
  String get perfStatTournamentGames => '토너먼트 게임';

  @override
  String get perfStatBerserkedGames => '버서크 게임';

  @override
  String get perfStatTimeSpentPlaying => '플레이한 시간';

  @override
  String get perfStatAverageOpponent => '상대 평균';

  @override
  String get perfStatVictories => '승';

  @override
  String get perfStatDefeats => '패';

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
    return '$param1에서 $param2까지';
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
  String get perfStatBestRated => '최고 레이팅 승리';

  @override
  String get perfStatGamesInARow => '연속 대국';

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
  String get preferencesPrivacy => '보안';

  @override
  String get preferencesNotifications => '알림';

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
  String get preferencesMoveListWhilePlaying => '기물 움직임 기록';

  @override
  String get preferencesPgnPieceNotation => 'PGN 기물표기방식';

  @override
  String get preferencesChessPieceSymbol => '체스 기물 기호';

  @override
  String get preferencesPgnLetter => '알파벳 (K, Q, R, B, N)';

  @override
  String get preferencesZenMode => '젠 모드';

  @override
  String get preferencesShowPlayerRatings => '플레이어 레이팅 보기';

  @override
  String get preferencesShowFlairs => '플레이어 아이콘 보기';

  @override
  String get preferencesExplainShowPlayerRatings =>
      '체스에 집중할 수 있도록 웹사이트에서 레이팅을 모두 숨깁니다. 경기는 여전히 레이팅에 반영될 것이며, 눈으로 보이는 정보에만 영향을 줍니다.';

  @override
  String get preferencesDisplayBoardResizeHandle => '보드 크기 재조정 핸들 보이기';

  @override
  String get preferencesOnlyOnInitialPosition => '초기 상태에서만';

  @override
  String get preferencesInGameOnly => '게임 도중에만 적용';

  @override
  String get preferencesExceptInGame => '게임 내 제외';

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
  String get preferencesPremovesPlayingDuringOpponentTurn => '미리두기 (상대 차례일 때 수를 두기)';

  @override
  String get preferencesTakebacksWithOpponentApproval => '무르기 (상대 승인과 함께)';

  @override
  String get preferencesInCasualGamesOnly => '캐주얼 모드에서만';

  @override
  String get preferencesPromoteToQueenAutomatically => '퀸으로 자동 승진';

  @override
  String get preferencesExplainPromoteToQueenAutomatically =>
      '일시적으로 자동 승진을 끄기 위해 승진하는 동안 <ctrl>를 누르세요';

  @override
  String get preferencesWhenPremoving => '미리두기 때만';

  @override
  String get preferencesClaimDrawOnThreefoldRepetitionAutomatically => '3회 동형반복시 자동으로 무승부 요청';

  @override
  String get preferencesWhenTimeRemainingLessThanThirtySeconds => '남은 시간이 30초 미만일 때만';

  @override
  String get preferencesMoveConfirmation => '수 확인';

  @override
  String get preferencesExplainCanThenBeTemporarilyDisabled => '경기 도중 보드 메뉴에서 비활성화될 수 있습니다.';

  @override
  String get preferencesInCorrespondenceGames => '통신 대국';

  @override
  String get preferencesCorrespondenceAndUnlimited => '통신 대국과 무제한';

  @override
  String get preferencesConfirmResignationAndDrawOffers => '기권 또는 무승부 제안시 물음';

  @override
  String get preferencesCastleByMovingTheKingTwoSquaresOrOntoTheRook => '캐슬링 방법';

  @override
  String get preferencesCastleByMovingTwoSquares => '킹을 2칸 옮기기';

  @override
  String get preferencesCastleByMovingOntoTheRook => '킹을 룩한테 이동';

  @override
  String get preferencesInputMovesWithTheKeyboard => '키보드 입력';

  @override
  String get preferencesInputMovesWithVoice => '음성으로 기물 이동';

  @override
  String get preferencesSnapArrowsToValidMoves => '적법한 움직임에만 화살표를 그림';

  @override
  String get preferencesSayGgWpAfterLosingOrDrawing =>
      '패배하거나 무승부 시 \"Good game, well played\"라고 말합니다.';

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
  String get preferencesNotifyInvitedStudy => '연구 초대';

  @override
  String get preferencesNotifyGameEvent => '통신 대국 업데이트';

  @override
  String get preferencesNotifyChallenge => '도전 과제';

  @override
  String get preferencesNotifyTournamentSoon => '곧 토너먼트 시작할 때';

  @override
  String get preferencesNotifyTimeAlarm => '통신 대국 시간 곧 만료됨';

  @override
  String get preferencesNotifyBell => 'Lichess 내에서 벨 알림';

  @override
  String get preferencesNotifyPush => 'Lichess를 사용하지 않을 때 기기 알림';

  @override
  String get preferencesNotifyWeb => '브라우저';

  @override
  String get preferencesNotifyDevice => '기기 정보';

  @override
  String get preferencesBellNotificationSound => '벨 알림 음';

  @override
  String get preferencesBlindfold => '기물 가리기';

  @override
  String get puzzlePuzzles => 'Puzzles';

  @override
  String get puzzlePuzzleThemes => 'Puzzle Themes';

  @override
  String get puzzleRecommended => 'Recommended';

  @override
  String get puzzlePhases => 'Phases';

  @override
  String get puzzleMotifs => 'Motifs';

  @override
  String get puzzleAdvanced => 'Advanced';

  @override
  String get puzzleLengths => 'Lengths';

  @override
  String get puzzleMates => 'Mates';

  @override
  String get puzzleGoals => 'Goals';

  @override
  String get puzzleOrigin => 'Origin';

  @override
  String get puzzleSpecialMoves => 'Special moves';

  @override
  String get puzzleDidYouLikeThisPuzzle => 'Did you like this puzzle?';

  @override
  String get puzzleVoteToLoadNextOne => 'Vote to load the next one!';

  @override
  String get puzzleUpVote => 'Up vote puzzle';

  @override
  String get puzzleDownVote => 'Down vote puzzle';

  @override
  String get puzzleYourPuzzleRatingWillNotChange =>
      'Your puzzle rating will not change. Note that puzzles are not a competition. Your rating helps selecting the best puzzles for your current skill.';

  @override
  String get puzzleFindTheBestMoveForWhite => 'Find the best move for white.';

  @override
  String get puzzleFindTheBestMoveForBlack => 'Find the best move for black.';

  @override
  String get puzzleToGetPersonalizedPuzzles => 'To get personalized puzzles:';

  @override
  String puzzlePuzzleId(String param) {
    return 'Puzzle $param';
  }

  @override
  String get puzzlePuzzleOfTheDay => 'Puzzle of the day';

  @override
  String get puzzleDailyPuzzle => 'Daily Puzzle';

  @override
  String get puzzleClickToSolve => 'Click to solve';

  @override
  String get puzzleGoodMove => 'Good move';

  @override
  String get puzzleBestMove => 'Best move!';

  @override
  String get puzzleKeepGoing => 'Keep going…';

  @override
  String get puzzlePuzzleSuccess => 'Success!';

  @override
  String get puzzlePuzzleComplete => 'Puzzle complete!';

  @override
  String get puzzleByOpenings => 'By openings';

  @override
  String get puzzlePuzzlesByOpenings => 'Puzzles by openings';

  @override
  String get puzzleOpeningsYouPlayedTheMost => 'Openings you played the most in rated games';

  @override
  String get puzzleUseFindInPage =>
      'Use \"Find in page\" in the browser menu to find your favourite opening!';

  @override
  String get puzzleUseCtrlF => 'Use Ctrl+f to find your favourite opening!';

  @override
  String get puzzleNotTheMove => 'That\'s not the move!';

  @override
  String get puzzleTrySomethingElse => 'Try something else.';

  @override
  String puzzleRatingX(String param) {
    return 'Rating: $param';
  }

  @override
  String get puzzleHidden => 'hidden';

  @override
  String puzzleFromGameLink(String param) {
    return 'From game $param';
  }

  @override
  String get puzzleContinueTraining => 'Continue training';

  @override
  String get puzzleDifficultyLevel => 'Difficulty level';

  @override
  String get puzzleNormal => 'Normal';

  @override
  String get puzzleEasier => 'Easier';

  @override
  String get puzzleEasiest => 'Easiest';

  @override
  String get puzzleHarder => 'Harder';

  @override
  String get puzzleHardest => 'Hardest';

  @override
  String get puzzleExample => 'Example';

  @override
  String get puzzleAddAnotherTheme => 'Add another theme';

  @override
  String get puzzleNextPuzzle => 'Next puzzle';

  @override
  String get puzzleJumpToNextPuzzleImmediately => 'Jump to next puzzle immediately';

  @override
  String get puzzlePuzzleDashboard => 'Puzzle Dashboard';

  @override
  String get puzzleImprovementAreas => 'Improvement areas';

  @override
  String get puzzleStrengths => 'Strengths';

  @override
  String get puzzleHistory => 'Puzzle history';

  @override
  String get puzzleSolved => 'solved';

  @override
  String get puzzleFailed => 'incorrect';

  @override
  String get puzzleStreakDescription =>
      'Solve progressively harder puzzles and build a win streak. There is no clock, so take your time. One wrong move, and it\'s game over! But you can skip one move per session.';

  @override
  String puzzleYourStreakX(String param) {
    return 'Your streak: $param';
  }

  @override
  String get puzzleStreakSkipExplanation =>
      'Skip this move to preserve your streak! Only works once per run.';

  @override
  String get puzzleContinueTheStreak => 'Continue the streak';

  @override
  String get puzzleNewStreak => 'New streak';

  @override
  String get puzzleFromMyGames => 'From my games';

  @override
  String get puzzleLookupOfPlayer => 'Lookup puzzles from a player\'s games';

  @override
  String get puzzleSearchPuzzles => 'Search puzzles';

  @override
  String get puzzleFromMyGamesNone =>
      'You have no puzzles in the database, but Lichess still loves you very much.\n\nPlay rapid and classical games to increase your chances of having a puzzle of yours added!';

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
      other: 'Played $count times',
      one: 'Played $count time',
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
  String puzzlePuzzlesFoundInUserGames(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count puzzles found in games by $param2',
      one: 'One puzzle found in games by $param2',
    );
    return '$_temp0';
  }

  @override
  String puzzleNbPlayed(int count) {
    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '$count played');
    return '$_temp0';
  }

  @override
  String puzzleNbToReplay(int count) {
    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '$count to replay');
    return '$_temp0';
  }

  @override
  String get puzzleThemeAdvancedPawn => 'Advanced pawn';

  @override
  String get puzzleThemeAdvancedPawnDescription =>
      'One of your pawns is deep into the opponent position, maybe threatening to promote.';

  @override
  String get puzzleThemeAdvantage => 'Advantage';

  @override
  String get puzzleThemeAdvantageDescription =>
      'Seize your chance to get a decisive advantage. (200cp ≤ eval ≤ 600cp)';

  @override
  String get puzzleThemeAnastasiaMate => 'Anastasia\'s mate';

  @override
  String get puzzleThemeAnastasiaMateDescription =>
      'A knight and rook or queen team up to trap the opposing king between the side of the board and a friendly piece.';

  @override
  String get puzzleThemeArabianMate => 'Arabian mate';

  @override
  String get puzzleThemeArabianMateDescription =>
      'A knight and a rook team up to trap the opposing king on a corner of the board.';

  @override
  String get puzzleThemeAttackingF2F7 => 'Attacking f2 or f7';

  @override
  String get puzzleThemeAttackingF2F7Description =>
      'An attack focusing on the f2 or f7 pawn, such as in the fried liver opening.';

  @override
  String get puzzleThemeAttraction => 'Attraction';

  @override
  String get puzzleThemeAttractionDescription =>
      'An exchange or sacrifice encouraging or forcing an opponent piece to a square that allows a follow-up tactic.';

  @override
  String get puzzleThemeBackRankMate => 'Back rank mate';

  @override
  String get puzzleThemeBackRankMateDescription =>
      'Checkmate the king on the home rank, when it is trapped there by its own pieces.';

  @override
  String get puzzleThemeBishopEndgame => 'Bishop endgame';

  @override
  String get puzzleThemeBishopEndgameDescription => 'An endgame with only bishops and pawns.';

  @override
  String get puzzleThemeBodenMate => 'Boden\'s mate';

  @override
  String get puzzleThemeBodenMateDescription =>
      'Two attacking bishops on criss-crossing diagonals deliver mate to a king obstructed by friendly pieces.';

  @override
  String get puzzleThemeCastling => 'Castling';

  @override
  String get puzzleThemeCastlingDescription =>
      'Bring the king to safety, and deploy the rook for attack.';

  @override
  String get puzzleThemeCapturingDefender => 'Capture the defender';

  @override
  String get puzzleThemeCapturingDefenderDescription =>
      'Removing a piece that is critical to defence of another piece, allowing the now undefended piece to be captured on a following move.';

  @override
  String get puzzleThemeCrushing => 'Crushing';

  @override
  String get puzzleThemeCrushingDescription =>
      'Spot the opponent blunder to obtain a crushing advantage. (eval ≥ 600cp)';

  @override
  String get puzzleThemeDoubleBishopMate => 'Double bishop mate';

  @override
  String get puzzleThemeDoubleBishopMateDescription =>
      'Two attacking bishops on adjacent diagonals deliver mate to a king obstructed by friendly pieces.';

  @override
  String get puzzleThemeDovetailMate => 'Dovetail mate';

  @override
  String get puzzleThemeDovetailMateDescription =>
      'A queen delivers mate to an adjacent king, whose only two escape squares are obstructed by friendly pieces.';

  @override
  String get puzzleThemeEquality => 'Equality';

  @override
  String get puzzleThemeEqualityDescription =>
      'Come back from a losing position, and secure a draw or a balanced position. (eval ≤ 200cp)';

  @override
  String get puzzleThemeKingsideAttack => 'Kingside attack';

  @override
  String get puzzleThemeKingsideAttackDescription =>
      'An attack of the opponent\'s king, after they castled on the king side.';

  @override
  String get puzzleThemeClearance => 'Clearance';

  @override
  String get puzzleThemeClearanceDescription =>
      'A move, often with tempo, that clears a square, file or diagonal for a follow-up tactical idea.';

  @override
  String get puzzleThemeDefensiveMove => 'Defensive move';

  @override
  String get puzzleThemeDefensiveMoveDescription =>
      'A precise move or sequence of moves that is needed to avoid losing material or another advantage.';

  @override
  String get puzzleThemeDeflection => 'Deflection';

  @override
  String get puzzleThemeDeflectionDescription =>
      'A move that distracts an opponent piece from another duty that it performs, such as guarding a key square. Sometimes also called \"overloading\".';

  @override
  String get puzzleThemeDiscoveredAttack => 'Discovered attack';

  @override
  String get puzzleThemeDiscoveredAttackDescription =>
      'Moving a piece (such as a knight), that previously blocked an attack by a long range piece (such as a rook), out of the way of that piece.';

  @override
  String get puzzleThemeDoubleCheck => 'Double check';

  @override
  String get puzzleThemeDoubleCheckDescription =>
      'Checking with two pieces at once, as a result of a discovered attack where both the moving piece and the unveiled piece attack the opponent\'s king.';

  @override
  String get puzzleThemeEndgame => 'Endgame';

  @override
  String get puzzleThemeEndgameDescription => 'A tactic during the last phase of the game.';

  @override
  String get puzzleThemeEnPassantDescription =>
      'A tactic involving the en passant rule, where a pawn can capture an opponent pawn that has bypassed it using its initial two-square move.';

  @override
  String get puzzleThemeExposedKing => 'Exposed king';

  @override
  String get puzzleThemeExposedKingDescription =>
      'A tactic involving a king with few defenders around it, often leading to checkmate.';

  @override
  String get puzzleThemeFork => 'Fork';

  @override
  String get puzzleThemeForkDescription =>
      'A move where the moved piece attacks two opponent pieces at once.';

  @override
  String get puzzleThemeHangingPiece => 'Hanging piece';

  @override
  String get puzzleThemeHangingPieceDescription =>
      'A tactic involving an opponent piece being undefended or insufficiently defended and free to capture.';

  @override
  String get puzzleThemeHookMate => 'Hook mate';

  @override
  String get puzzleThemeHookMateDescription =>
      'Checkmate with a rook, knight, and pawn along with one enemy pawn to limit the enemy king\'s escape.';

  @override
  String get puzzleThemeInterference => 'Interference';

  @override
  String get puzzleThemeInterferenceDescription =>
      'Moving a piece between two opponent pieces to leave one or both opponent pieces undefended, such as a knight on a defended square between two rooks.';

  @override
  String get puzzleThemeIntermezzo => 'Intermezzo';

  @override
  String get puzzleThemeIntermezzoDescription =>
      'Instead of playing the expected move, first interpose another move posing an immediate threat that the opponent must answer. Also known as \"Zwischenzug\" or \"In between\".';

  @override
  String get puzzleThemeKillBoxMate => 'Kill box mate';

  @override
  String get puzzleThemeKillBoxMateDescription =>
      'A rook is next to the enemy king and supported by a queen that also blocks the king\'s escape squares. The rook and the queen catch the enemy king in a 3 by 3 \"kill box\".';

  @override
  String get puzzleThemeVukovicMate => 'Vukovic mate';

  @override
  String get puzzleThemeVukovicMateDescription =>
      'A rook and knight team up to mate the king. The rook delivers mate while supported by a third piece, and the knight is used to block the king\'s escape squares.';

  @override
  String get puzzleThemeKnightEndgame => 'Knight endgame';

  @override
  String get puzzleThemeKnightEndgameDescription => 'An endgame with only knights and pawns.';

  @override
  String get puzzleThemeLong => 'Long puzzle';

  @override
  String get puzzleThemeLongDescription => 'Three moves to win.';

  @override
  String get puzzleThemeMaster => 'Master games';

  @override
  String get puzzleThemeMasterDescription => 'Puzzles from games played by titled players.';

  @override
  String get puzzleThemeMasterVsMaster => 'Master vs Master games';

  @override
  String get puzzleThemeMasterVsMasterDescription =>
      'Puzzles from games between two titled players.';

  @override
  String get puzzleThemeMate => 'Checkmate';

  @override
  String get puzzleThemeMateDescription => 'Win the game with style.';

  @override
  String get puzzleThemeMateIn1 => 'Mate in 1';

  @override
  String get puzzleThemeMateIn1Description => 'Deliver checkmate in one move.';

  @override
  String get puzzleThemeMateIn2 => 'Mate in 2';

  @override
  String get puzzleThemeMateIn2Description => 'Deliver checkmate in two moves.';

  @override
  String get puzzleThemeMateIn3 => 'Mate in 3';

  @override
  String get puzzleThemeMateIn3Description => 'Deliver checkmate in three moves.';

  @override
  String get puzzleThemeMateIn4 => 'Mate in 4';

  @override
  String get puzzleThemeMateIn4Description => 'Deliver checkmate in four moves.';

  @override
  String get puzzleThemeMateIn5 => 'Mate in 5 or more';

  @override
  String get puzzleThemeMateIn5Description => 'Figure out a long mating sequence.';

  @override
  String get puzzleThemeMiddlegame => 'Middlegame';

  @override
  String get puzzleThemeMiddlegameDescription => 'A tactic during the second phase of the game.';

  @override
  String get puzzleThemeOneMove => 'One-move puzzle';

  @override
  String get puzzleThemeOneMoveDescription => 'A puzzle that is only one move long.';

  @override
  String get puzzleThemeOpening => 'Opening';

  @override
  String get puzzleThemeOpeningDescription => 'A tactic during the first phase of the game.';

  @override
  String get puzzleThemePawnEndgame => 'Pawn endgame';

  @override
  String get puzzleThemePawnEndgameDescription => 'An endgame with only pawns.';

  @override
  String get puzzleThemePin => 'Pin';

  @override
  String get puzzleThemePinDescription =>
      'A tactic involving pins, where a piece is unable to move without revealing an attack on a higher value piece.';

  @override
  String get puzzleThemePromotion => 'Promotion';

  @override
  String get puzzleThemePromotionDescription =>
      'Promote one of your pawn to a queen or minor piece.';

  @override
  String get puzzleThemeQueenEndgame => 'Queen endgame';

  @override
  String get puzzleThemeQueenEndgameDescription => 'An endgame with only queens and pawns.';

  @override
  String get puzzleThemeQueenRookEndgame => 'Queen and Rook';

  @override
  String get puzzleThemeQueenRookEndgameDescription =>
      'An endgame with only queens, rooks and pawns.';

  @override
  String get puzzleThemeQueensideAttack => 'Queenside attack';

  @override
  String get puzzleThemeQueensideAttackDescription =>
      'An attack of the opponent\'s king, after they castled on the queen side.';

  @override
  String get puzzleThemeQuietMove => 'Quiet move';

  @override
  String get puzzleThemeQuietMoveDescription =>
      'A move that does neither make a check or capture, nor an immediate threat to capture, but does prepare a more hidden unavoidable threat for a later move.';

  @override
  String get puzzleThemeRookEndgame => 'Rook endgame';

  @override
  String get puzzleThemeRookEndgameDescription => 'An endgame with only rooks and pawns.';

  @override
  String get puzzleThemeSacrifice => 'Sacrifice';

  @override
  String get puzzleThemeSacrificeDescription =>
      'A tactic involving giving up material in the short-term, to gain an advantage again after a forced sequence of moves.';

  @override
  String get puzzleThemeShort => 'Short puzzle';

  @override
  String get puzzleThemeShortDescription => 'Two moves to win.';

  @override
  String get puzzleThemeSkewer => 'Skewer';

  @override
  String get puzzleThemeSkewerDescription =>
      'A motif involving a high value piece being attacked, moving out the way, and allowing a lower value piece behind it to be captured or attacked, the inverse of a pin.';

  @override
  String get puzzleThemeSmotheredMate => 'Smothered mate';

  @override
  String get puzzleThemeSmotheredMateDescription =>
      'A checkmate delivered by a knight in which the mated king is unable to move because it is surrounded (or smothered) by its own pieces.';

  @override
  String get puzzleThemeSuperGM => 'Super GM games';

  @override
  String get puzzleThemeSuperGMDescription =>
      'Puzzles from games played by the best players in the world.';

  @override
  String get puzzleThemeTrappedPiece => 'Trapped piece';

  @override
  String get puzzleThemeTrappedPieceDescription =>
      'A piece is unable to escape capture as it has limited moves.';

  @override
  String get puzzleThemeUnderPromotion => 'Underpromotion';

  @override
  String get puzzleThemeUnderPromotionDescription => 'Promotion to a knight, bishop, or rook.';

  @override
  String get puzzleThemeVeryLong => 'Very long puzzle';

  @override
  String get puzzleThemeVeryLongDescription => 'Four moves or more to win.';

  @override
  String get puzzleThemeXRayAttack => 'X-Ray attack';

  @override
  String get puzzleThemeXRayAttackDescription =>
      'A piece attacks or defends a square, through an enemy piece.';

  @override
  String get puzzleThemeZugzwang => 'Zugzwang';

  @override
  String get puzzleThemeZugzwangDescription =>
      'The opponent is limited in the moves they can make, and all moves worsen their position.';

  @override
  String get puzzleThemeMix => 'Healthy mix';

  @override
  String get puzzleThemeMixDescription =>
      'A bit of everything. You don\'t know what to expect, so you remain ready for anything! Just like in real games.';

  @override
  String get puzzleThemePlayerGames => 'Player games';

  @override
  String get puzzleThemePlayerGamesDescription =>
      'Lookup puzzles generated from your games, or from another player\'s games.';

  @override
  String puzzleThemePuzzleDownloadInformation(String param) {
    return 'These puzzles are in the public domain, and can be downloaded from $param.';
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
  String get settingsCantOpenSimilarAccount => '대소문자가 다르더라도, 똑같은 이름으로 계정을 다시 열 수 없습니다.';

  @override
  String get settingsCancelKeepAccount => '취소하고 계정 지키기';

  @override
  String get settingsCloseAccountAreYouSure => '계정을 정말로 폐쇄하시겠습니까?';

  @override
  String get settingsThisAccountIsClosed => '계정이 폐쇄되었습니다.';

  @override
  String get playWithAFriend => '친구와 체스 두기';

  @override
  String get playWithTheMachine => '컴퓨터와 체스 두기';

  @override
  String get toInviteSomeoneToPlayGiveThisUrl => '이 URL로 친구를 초대하세요';

  @override
  String get gameOver => '대국 종료';

  @override
  String get waitingForOpponent => '상대를 기다리는 중';

  @override
  String get orLetYourOpponentScanQrCode => '상대방에게 이 QR 코드를 스캔하라고 하셔도 됩니다.';

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
  String get resign => '기권하기';

  @override
  String get checkmate => '체크메이트';

  @override
  String get stalemate => '스테일메이트';

  @override
  String get white => '백';

  @override
  String get black => '흑';

  @override
  String get asWhite => '백일때';

  @override
  String get asBlack => '흑일때';

  @override
  String get randomColor => '무작위';

  @override
  String get createAGame => '새로운 대국 만들기';

  @override
  String get createTheGame => '대국 만들기';

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
  String get kingInTheCenter => '킹이 중앙에 도달';

  @override
  String get threeChecks => '세 번의 체크';

  @override
  String get raceFinished => '킹이 보드 끝에 도달함';

  @override
  String get variantEnding => '변형 종료';

  @override
  String get newOpponent => '새로운 상대';

  @override
  String get yourOpponentWantsToPlayANewGameWithYou => '상대가 재대결을 원합니다';

  @override
  String get joinTheGame => '대국 참가';

  @override
  String get whitePlays => '백 차례';

  @override
  String get blackPlays => '흑 차례';

  @override
  String get opponentLeftChoices => '당신의 상대가 게임을 나갔습니다. 상대를 기다리거나 승리 또는 무승부 처리할 수 있습니다.';

  @override
  String get forceResignation => '승리 취하기';

  @override
  String get forceDraw => '무승부 선언';

  @override
  String get talkInChat => '건전한 채팅을 해주세요!';

  @override
  String get theFirstPersonToComeOnThisUrlWillPlayWithYou => '이 URL로 가장 먼저 들어온 사람과 체스를 두게 됩니다.';

  @override
  String get whiteResigned => '백 기권';

  @override
  String get blackResigned => '흑 기권';

  @override
  String get whiteLeftTheGame => '백 퇴장';

  @override
  String get blackLeftTheGame => '흑 게임 퇴장';

  @override
  String get whiteDidntMove => '백이 수를 두지 않음';

  @override
  String get blackDidntMove => '흑이 수를 두지 않음';

  @override
  String get requestAComputerAnalysis => '컴퓨터 분석 요청하기';

  @override
  String get computerAnalysis => '컴퓨터 분석';

  @override
  String get computerAnalysisAvailable => '컴퓨터 분석 가능';

  @override
  String get computerAnalysisDisabled => '컴퓨터 분석 비활성화됨';

  @override
  String get analysis => '분석';

  @override
  String depthX(String param) {
    return '$param 수까지 탐색';
  }

  @override
  String get usingServerAnalysis => '서버 분석 사용하기';

  @override
  String get loadingEngine => '엔진 로드 중...';

  @override
  String get calculatingMoves => '수 계산 중...';

  @override
  String get engineFailed => '엔진 불러오는 도중 오류 발생';

  @override
  String get cloudAnalysis => '클라우드 분석';

  @override
  String get goDeeper => '더 깊게 분석하기';

  @override
  String get showThreat => '위험요소 표시';

  @override
  String get inLocalBrowser => '브라우저에서';

  @override
  String get toggleLocalEvaluation => '로컬 분석 전환';

  @override
  String get promoteVariation => '바리에이션 승격하기';

  @override
  String get makeMainLine => '주 라인으로 하기';

  @override
  String get deleteFromHere => '여기서부터 삭제';

  @override
  String get collapseVariations => '바리에이션 축소하기';

  @override
  String get expandVariations => '바리에이션 확장하기';

  @override
  String get forceVariation => '바리에이션 강제하기';

  @override
  String get copyVariationPgn => '바리에이션 PGN 복사';

  @override
  String get copyMainLinePgn => '주 라인 PGN 복사';

  @override
  String get move => '수';

  @override
  String get variantLoss => '변형 체스에서 패배';

  @override
  String get variantWin => '변형 체스에서 승리';

  @override
  String get insufficientMaterial => '기물 부족';

  @override
  String get pawnMove => '폰 이동';

  @override
  String get capture => '기물 잡기';

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
  String get whiteDrawBlack => '백 / 무승부 / 흑';

  @override
  String averageRatingX(String param) {
    return '평균 레이팅: $param';
  }

  @override
  String get recentGames => '최근 대국';

  @override
  String get topGames => '최고 레이팅 대국';

  @override
  String masterDbExplanation(String param1, String param2, String param3) {
    return '$param2년과 $param3년 사이 FIDE 레이팅이 최소 $param1였던 선수들의 기보가 약 2백만개 있습니다.';
  }

  @override
  String get dtzWithRounding => '다음 포획 혹은 폰 수까지 남은 반수를 반올림후 나타낸 DTZ50\" 수치';

  @override
  String get noGameFound => '대국을 찾을 수 없습니다';

  @override
  String get maxDepthReached => '최대 깊이 도달!';

  @override
  String get maybeIncludeMoreGamesFromThePreferencesMenu => '설정에서 더 많은 대국을 포함하세요.';

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
  String get winPreventedBy50MoveRule => '50수 규칙에 의하여 승리가 불가능합니다';

  @override
  String get lossSavedBy50MoveRule => '50수 규칙에 의하여 패배가 불가능합니다';

  @override
  String get winOr50MovesByPriorMistake => '승리 혹은 이전의 실수로 인한 50수 규칙 무승부';

  @override
  String get lossOr50MovesByPriorMistake => '패배 혹은 이전의 실수로 인한 50수 규칙 무승부';

  @override
  String get unknownDueToRounding => 'DTZ 수치의 반올림 때문에 추천된 테이블베이스 라인을 따라야만 승리 및 패배가 보장됩니다.';

  @override
  String get allSet => '모두 완료!';

  @override
  String get importPgn => 'PGN 가져오기';

  @override
  String get delete => '삭제';

  @override
  String get deleteThisImportedGame => '가져온 대국을 삭제할까요?';

  @override
  String get replayMode => '게임 다시보기';

  @override
  String get realtimeReplay => '실시간';

  @override
  String get byCPL => '센티폰 손실';

  @override
  String get enable => '활성화';

  @override
  String get bestMoveArrow => '최선의 수 화살표';

  @override
  String get showVariationArrows => '바리에이션 화살표 표시하기';

  @override
  String get evaluationGauge => '평가 게이지';

  @override
  String get multipleLines => '다중 라인 수';

  @override
  String get cpus => 'CPU 수';

  @override
  String get memory => '메모리';

  @override
  String get infiniteAnalysis => '무한 분석';

  @override
  String get removesTheDepthLimit => '탐색 깊이 제한을 없애고 컴퓨터를 따뜻하게 해줍니다';

  @override
  String get blunder => '블런더';

  @override
  String get mistake => '실수';

  @override
  String get inaccuracy => '부정확한 수';

  @override
  String get moveTimes => '이동 시간';

  @override
  String get flipBoard => '보드 돌리기';

  @override
  String get threefoldRepetition => '3회 동형반복';

  @override
  String get claimADraw => '무승부 처리';

  @override
  String get drawClaimed => '무승부 처리됨';

  @override
  String get offerDraw => '무승부 요청';

  @override
  String get draw => '무승부';

  @override
  String get drawByMutualAgreement => '상호 동의에 의한 무승부';

  @override
  String get fiftyMovesWithoutProgress => '진전 없이 50수 소모';

  @override
  String get currentGames => '진행 중인 대국들';

  @override
  String joinedX(String param) {
    return '$param 전에 가입함';
  }

  @override
  String get viewInFullSize => '크게 보기';

  @override
  String get logOut => '로그아웃';

  @override
  String get signIn => '로그인';

  @override
  String get rememberMe => '로그인 유지';

  @override
  String get youNeedAnAccountToDoThat => '회원이어야 가능합니다';

  @override
  String get signUp => '회원 가입';

  @override
  String get computersAreNotAllowedToPlay =>
      '컴퓨터나 컴퓨터를 사용하는 플레이어들은 대국이 금지되어 있습니다. 대국 중 체스 엔진이나, 데이터베이스나, 다른 사람들로부터 도움을 받지 마십시오. 이와 더불어 다중 계정 소유는 최대한 사용을 지양하여 주시고 지나치게 많은 계정들을 사용할 시 계정들이 차단될 수 있습니다.';

  @override
  String get games => '대국';

  @override
  String get forum => '포럼';

  @override
  String xPostedInForumY(String param1, String param2) {
    return '$param1(이)가 $param2 주제에 글을 씀';
  }

  @override
  String get latestForumPosts => '최근 포럼 글';

  @override
  String get players => '플레이어';

  @override
  String get friends => '친구들';

  @override
  String get otherPlayers => '다른 플레이어들';

  @override
  String get discussions => '대화';

  @override
  String get today => '오늘';

  @override
  String get yesterday => '어제';

  @override
  String get minutesPerSide => '제한 시간(분)';

  @override
  String get variant => '변형';

  @override
  String get variants => '변형';

  @override
  String get timeControl => '시간 제한';

  @override
  String get realTime => '실시간';

  @override
  String get correspondence => '통신 대국';

  @override
  String get daysPerTurn => '수당 일수';

  @override
  String get oneDay => '1일';

  @override
  String get time => '시간';

  @override
  String get rating => '레이팅';

  @override
  String get ratingStats => '레이팅 통계';

  @override
  String get username => '사용자 이름';

  @override
  String get usernameOrEmail => '사용자 이름이나 이메일 주소';

  @override
  String get changeUsername => '사용자 이름 변경';

  @override
  String get changeUsernameNotSame => '글자의 대소문자 변경만 가능합니다 예: \"chulsoo\"에서 \"ChulSoo\"로.';

  @override
  String get changeUsernameDescription => '사용자명 변경하기: 대/소문자만의 변경이 허용되며, 단 한번만 가능합니다.';

  @override
  String get signupUsernameHint =>
      '사용자 이름이 어린이를 포함해 모두에게 적절한지 확인하세요. 나중에 변경할 수 없으며 부적절한 사용자 이름을 가진 계정은 폐쇄됩니다!';

  @override
  String get signupEmailHint => '비밀번호 초기화를 위해서만 사용됩니다.';

  @override
  String get password => '비밀번호';

  @override
  String get changePassword => '비밀번호 변경';

  @override
  String get changeEmail => '이메일 주소 변경';

  @override
  String get email => '이메일';

  @override
  String get passwordReset => '비밀번호 초기화';

  @override
  String get forgotPassword => '비밀번호를 잊어버리셨나요?';

  @override
  String get error_weakPassword => '이 비밀번호는 매우 흔하며 추측하기 쉽습니다.';

  @override
  String get error_namePassword => '사용자 이름을 비밀번호로 사용하지 마세요.';

  @override
  String get blankedPassword =>
      '당신이 다른 사이트에서 동일한 비밀번호를 사용했으며, 해당 사이트가 유출되었습니다. Lichess 계정의 안전을 위해 새 비밀번호를 설정해 주세요. 양해해 주셔서 감사합니다.';

  @override
  String get youAreLeavingLichess => 'Lichess에서 나갑니다';

  @override
  String get neverTypeYourPassword => '다른 사이트에서는 절대로 Lichess 비밀번호를 입력하지 마세요!';

  @override
  String proceedToX(String param) {
    return '$param로 진행';
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
    return '$param(으)로 이메일을 전송했습니다.';
  }

  @override
  String get emailCanTakeSomeTime => '이메일이 도착하는데 시간이 좀 걸릴 수 있습니다.';

  @override
  String get refreshInboxAfterFiveMinutes => '5분 가량 기다린 후 이메일 수신함을 새로고침 해주세요.';

  @override
  String get checkSpamFolder => '또한 스팸 메일함에 들어가 있을 수 있습니다. 만약 그런 경우, 스팸이 아님으로 표시해 두세요.';

  @override
  String get emailForSignupHelp => '모두 실패했다면, 이곳으로 메일을 보내주세요:';

  @override
  String copyTextToEmail(String param) {
    return '위의 텍스트를 복사해서 $param(으)로 보내주세요';
  }

  @override
  String get waitForSignupHelp => '가입을 완료할 수 있도록 빠르게 연락드리겠습니다.';

  @override
  String accountConfirmed(String param) {
    return '유저 $param(이)가 성공적으로 확인되었습니다.';
  }

  @override
  String accountCanLogin(String param) {
    return '이제 $param(으)로 로그인할 수 있습니다.';
  }

  @override
  String get accountConfirmationEmailNotNeeded => '이메일 확인은 필요하지 않습니다.';

  @override
  String accountClosed(String param) {
    return '계정 $param(은)는 폐쇄되었습니다.';
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
  String get gamesPlayed => '대국 횟수';

  @override
  String get ok => '확인';

  @override
  String get cancel => '취소';

  @override
  String get whiteTimeOut => '백 시간 초과';

  @override
  String get blackTimeOut => '흑 시간 초과';

  @override
  String get drawOfferSent => '무승부 요청함';

  @override
  String get drawOfferAccepted => '무승부 요청 수락됨';

  @override
  String get drawOfferCanceled => '무승부 요청 취소함';

  @override
  String get whiteOffersDraw => '백이 무승부를 제안합니다';

  @override
  String get blackOffersDraw => '흑이 무승부를 제안합니다';

  @override
  String get whiteDeclinesDraw => '백이 무승부 제안을 거절하였습니다';

  @override
  String get blackDeclinesDraw => '흑이 무승부 제안을 거절하였습니다';

  @override
  String get yourOpponentOffersADraw => '상대가 무승부를 요청합니다';

  @override
  String get accept => '수락';

  @override
  String get decline => '거절';

  @override
  String get playingRightNow => '지금 대국 중';

  @override
  String get eventInProgress => '지금 대국 중';

  @override
  String get finished => '종료됨';

  @override
  String get abortGame => '대국 취소';

  @override
  String get gameAborted => '대국 취소됨';

  @override
  String get standard => '스탠다드';

  @override
  String get customPosition => '커스텀 포지션';

  @override
  String get unlimited => '무제한';

  @override
  String get mode => '모드';

  @override
  String get casual => '캐주얼';

  @override
  String get rated => '레이팅';

  @override
  String get casualTournament => '캐주얼';

  @override
  String get ratedTournament => '레이팅';

  @override
  String get thisGameIsRated => '이 대국은 레이팅 대국입니다';

  @override
  String get rematch => '재대결';

  @override
  String get rematchOfferSent => '재대결 요청 전송됨';

  @override
  String get rematchOfferAccepted => '재대결 요청 승낙됨';

  @override
  String get rematchOfferCanceled => '재대결 요청 취소됨';

  @override
  String get rematchOfferDeclined => '재대결 요청이 거절됐습니다';

  @override
  String get cancelRematchOffer => '재대결 요청 취소';

  @override
  String get viewRematch => '재대결 보기';

  @override
  String get confirmMove => '수 확인';

  @override
  String get play => '플레이';

  @override
  String get inbox => '편지함';

  @override
  String get chatRoom => '채팅';

  @override
  String get loginToChat => '채팅하려면 로그인하세요';

  @override
  String get youHaveBeenTimedOut => '채팅에서 타임아웃 되었습니다.';

  @override
  String get spectatorRoom => '관전자 채팅';

  @override
  String get composeMessage => '메시지 작성';

  @override
  String get subject => '제목';

  @override
  String get send => '전송';

  @override
  String get incrementInSeconds => '수 당 추가 시간(초)';

  @override
  String get freeOnlineChess => '무료 온라인 체스';

  @override
  String get exportGames => '대국 저장하기';

  @override
  String get ratingRange => '레이팅 범위';

  @override
  String get thisAccountViolatedTos => '이 계정은 Lichess 이용 약관을 위반하였습니다';

  @override
  String get openingExplorerAndTablebase => '오프닝 탐색 & 테이블베이스';

  @override
  String get takeback => '무르기';

  @override
  String get proposeATakeback => '무르기 요청';

  @override
  String get whiteProposesTakeback => '백이 무르기를 요청함';

  @override
  String get blackProposesTakeback => '흑이 무르기를 요청함';

  @override
  String get takebackPropositionSent => '무르기 요청 전송됨';

  @override
  String get whiteDeclinesTakeback => '백이 무르기를 거절하였습니다';

  @override
  String get blackDeclinesTakeback => '흑이 무르기를 거절하였습니다';

  @override
  String get whiteAcceptsTakeback => '백이 무르기를 승낙하였습니다';

  @override
  String get blackAcceptsTakeback => '흑이 무르기를 승낙하였습니다';

  @override
  String get whiteCancelsTakeback => '백이 무르기를 취소하였습니다';

  @override
  String get blackCancelsTakeback => '흑이 무르기를 취소하였습니다';

  @override
  String get yourOpponentProposesATakeback => '상대가 무르기를 요청합니다';

  @override
  String get bookmarkThisGame => '이 대국을 즐겨찾기에 추가하기';

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
  String get backToGame => '대국으로 돌아가기';

  @override
  String get siteDescription =>
      '회원 가입, 광고, 플러그인 없이 즐길 수 있는 깔끔한 구성의 무료 온라인 체스 게임입니다. 컴퓨터, 친구 또는 무작위로 고른 상대와 함께 체스를 즐겨보세요.';

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
  String get location => '위치';

  @override
  String get filterGames => '대국 필터';

  @override
  String get reset => '초기화';

  @override
  String get apply => '저장';

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
  String get importGame => '대국 불러오기';

  @override
  String get importGameExplanation =>
      '체스 대국의 PGN 을 붙여 넣으면, 복기와 컴퓨터 분석을 진행할 수 있고, 채팅을 칠 수도 있으며, 대국을 공유할 수 있는 URL 링크도 생성할 수 있습니다.';

  @override
  String get importGameCaveat => '변형은 지워집니다. 변형을 유지하려면 연구를 통해 PGN을 가져오세요.';

  @override
  String get importGameDataPrivacyWarning => '이 PGN은 모두가 볼 수 있게 됩니다. 비공개로 대국을 불러오려면, 연구 기능을 이용하세요.';

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
  String get reconnecting => '연결 중';

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
  String get startingIn => '대회 시작까지';

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
  String get ifNoneLeaveEmpty => '없다면 비워두세요';

  @override
  String get profile => '프로필';

  @override
  String get editProfile => '프로필 수정';

  @override
  String get realName => '실명';

  @override
  String get setFlair => '아이콘을 선택하세요';

  @override
  String get flair => '아이콘';

  @override
  String get youCanHideFlair => '전체 사이트에서 모든 유저의 아이콘을 숨기는 설정이 있습니다.';

  @override
  String get biography => '소개';

  @override
  String get countryRegion => '국가 또는 지역';

  @override
  String get thankYou => '감사합니다!';

  @override
  String get socialMediaLinks => '소셜 미디어 링크';

  @override
  String get oneUrlPerLine => '한 줄에 당 URL 1개';

  @override
  String get inlineNotation => '기보법 가로쓰기';

  @override
  String get makeAStudy => '안전하게 보관하고 공유하려면 연구를 만들어 보세요.';

  @override
  String get clearSavedMoves => '저장된 움직임 삭제';

  @override
  String get previouslyOnLichessTV => '이전 방송';

  @override
  String get onlinePlayers => '접속한 플레이어';

  @override
  String get activePlayers => '활동적인 플레이어';

  @override
  String get bewareTheGameIsRatedButHasNoClock => '주의하세요, 공식 대국이지만 시간 제한이 없습니다!';

  @override
  String get success => '성공!';

  @override
  String get automaticallyProceedToNextGameAfterMoving => '수를 둔 다음에 자동으로 다음 대국으로 이동';

  @override
  String get autoSwitch => '자동 전환';

  @override
  String get puzzles => '퍼즐';

  @override
  String get onlineBots => '온라인 봇';

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
  String get website => '웹사이트';

  @override
  String get mobile => '모바일';

  @override
  String get help => '힌트:';

  @override
  String get createANewTopic => '새 주제 만들기';

  @override
  String get topics => '주제';

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
  String get createTheTopic => '새 주제 생성';

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
  String get reportCheatBoostHelp =>
      '대국 URL 주소를 붙여넣으시고 해당 사용자가 무엇을 잘못했는지 설명해 주세요. 그냥 \"그들이 부정행위를 했어요\" 라고만 말하지 말고, 어떻게 당신이 이 결론에 도달하게 됐는지 알려주세요.';

  @override
  String get reportUsernameHelp =>
      '왜 이 사용자의 이름이 불쾌한지 설명해주세요. 그저 \"불쾌해요/부적절해요\"라고만 말하지 마세요, 대신 왜 이런 결론에 도달했는지 말씀해 주세요. 단어가 난해하거나, 영어가 아니거나, 은어이거나, 문화적/역사적 배경이 있는 경우 특히 중요합니다.';

  @override
  String get reportProcessedFasterInEnglish => '귀하의 신고가 영어로 적혀있을 경우 빠르게 처리될 것입니다.';

  @override
  String get error_provideOneCheatedGameLink => '부정행위가 존재하는 대국의 링크를 제공해주세요.';

  @override
  String by(String param) {
    return '작성: $param';
  }

  @override
  String importedByX(String param) {
    return '$param가 불러옴';
  }

  @override
  String get thisTopicIsNowClosed => '이 주제는 닫혔습니다.';

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
  String get clockIncrement => '수 당 추가 시간';

  @override
  String get privacy => '보안';

  @override
  String get privacyPolicy => '개인정보취급방침';

  @override
  String get letOtherPlayersFollowYou => '다른 사람이 팔로우할 수 있게 함';

  @override
  String get letOtherPlayersChallengeYou => '다른 사람이 나에게 도전할 수 있게 함';

  @override
  String get letOtherPlayersInviteYouToStudy => '다른 플레이어들이 나를 연구에 초대할 수 있음';

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
  String get allSquaresOfTheBoard => '보드의 모든 칸';

  @override
  String get onSlowGames => '느린 대국에서만';

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
  String get biographyDescription => '자신을 알려주세요. 왜 체스를 좋아하는지, 좋아하는 오프닝, 대국, 선수 등등...';

  @override
  String get listBlockedPlayers => '이 플레이어를 차단';

  @override
  String get human => '인간';

  @override
  String get computer => '컴퓨터';

  @override
  String get side => '색';

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
  String get increment => '추가 시간';

  @override
  String get error_unknown => '잘못된 값';

  @override
  String get error_required => '필수 기입 사항입니다.';

  @override
  String get error_email => '이메일 주소가 유효하지 않습니다';

  @override
  String get error_email_acceptable => '이 이메일 주소는 수용 불가합니다. 확인후 다시 시도해주세요.';

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
  String get titleVerification => '칭호 인증';

  @override
  String get sourceCode => '소스 코드';

  @override
  String get simultaneousExhibitions => '다면기';

  @override
  String get host => '주최자';

  @override
  String hostColorX(String param) {
    return '주최자 색: $param';
  }

  @override
  String get yourPendingSimuls => '대기 중인 다면기';

  @override
  String get createdSimuls => '새롭게 생성된 다면기';

  @override
  String get hostANewSimul => '새 다면기 주최하기';

  @override
  String get signUpToHostOrJoinASimul => '다면기를 주최/참가하려면 로그인하세요';

  @override
  String get noSimulFound => '다면기를 찾을 수 없습니다';

  @override
  String get noSimulExplanation => '존재하지 않는 다면기입니다.';

  @override
  String get returnToSimulHomepage => '다면기 홈으로 돌아가기';

  @override
  String get aboutSimul => '다면기에서는 1인의 플레이어가 여러 플레이어와 대국을 벌입니다.';

  @override
  String get aboutSimulImage => '피셔는 50명의 상대 중, 47국을 승리하였고, 2국은 무승부였으며 1국만 패하였습니다.';

  @override
  String get aboutSimulRealLife => '이 컨셉은 실제 이벤트들을 본딴 것입니다. 실제 경기에서는 다면기 주최자가 테이블을 돌아다니며 한 수씩 둡니다.';

  @override
  String get aboutSimulRules => '다면기가 시작되면, 모든 플레이어가 주최자와 대국을 합니다. 다면기는 모든 플레이어와 게임이 끝나면 종료됩니다.';

  @override
  String get aboutSimulSettings => '다면기는 항상 캐주얼전입니다. 재대결, 무르기, 시간추가를 할 수 없습니다.';

  @override
  String get create => '생성';

  @override
  String get whenCreateSimul => '다면기를 생성하면 한 번에 여러 명의 플레이어와 게임하게 됩니다.';

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
  String get keyCycleSelectedVariation => '선택된 바리에이션 순환하기';

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
  String get keyPreviousBranch => '이전 부';

  @override
  String get keyNextBranch => '다음 부';

  @override
  String get toggleVariationArrows => '바리에이션 화살표 표시하기';

  @override
  String get cyclePreviousOrNextVariation => '이전/다음 바리에이션 순환하기';

  @override
  String get toggleGlyphAnnotations => '이동 주석 토글하기';

  @override
  String get togglePositionAnnotations => '위치 주석 토글하기';

  @override
  String get variationArrowsInfo => '변형 화살표를 사용하면 이동 목록을 사용하지 않고 탐색이 가능합니다.';

  @override
  String get playSelectedMove => '선택한 수 두기';

  @override
  String get newTournament => '새로운 토너먼트';

  @override
  String get tournamentHomeTitle => '다양한 시간 제한과 변형을 지원하는 체스 토너먼트';

  @override
  String get tournamentHomeDescription =>
      '빠른 체스 토너먼트를 즐겨 보세요! 공식 일정이 잡힌 토너먼트에 참가할 수도, 당신만의 토너먼트를 만들 수도 있습니다. 불릿, 블리츠, 클래식, 체스960, 언덕의 왕, 3체크를 비롯하여 다양한 게임방식을 즐길 수 있습니다.';

  @override
  String get tournamentNotFound => '토너먼트를 찾을 수 없습니다';

  @override
  String get tournamentDoesNotExist => '존재하지 않는 토너먼트입니다.';

  @override
  String get tournamentMayHaveBeenCanceled => '모든 플레이어가 퇴장하여 취소된 대국일 수 있습니다.';

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
  String get ifYouDoNotSeeTheEmailCheckOtherPlaces =>
      '메일을 확인할 수 없다면, 스팸 메일함이나 다른 폴더에 메일이 있지 않은지 확인해 주세요.';

  @override
  String get ifYouDoNotGetTheEmail => '만일 5분 이내에 이메일을 받지 않으신다면';

  @override
  String get checkAllEmailFolders => '모든 쓰레기통, 스팸 폴더 등을 확인하세요';

  @override
  String verifyYourAddress(String param) {
    return '$param이 자신의 이메일 주소가 맞는지 확인하세요';
  }

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
  String get downloadAllGames => '모든 대국 다운로드';

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
  String get kidModeExplanation =>
      '이 모드는 안전에 관한 것입니다. 어린이 모드에서는 모든 통신이 비활성화됩니다. 당신의 아이들이나 학생들을 다른 인터넷 사용자들에서 보호하려면 이 모드를 켜십시오.';

  @override
  String inKidModeTheLichessLogoGetsIconX(String param) {
    return '어린이 모드에서는 lichess 로고가 $param 아이콘이 뜨기 때문에 안심하셔도 됩니다.';
  }

  @override
  String get askYourChessTeacherAboutLiftingKidMode =>
      '당신의 계정은 관리되고 있습니다. 어린이 모드 해제에 대해서는 체스 선생님께 문의하세요.';

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
  String get everybodyGetsAllFeaturesForFree => '모두가 모든 기능을 무료로 이용할 수 있습니다';

  @override
  String get viewTheSolution => '정답 보기';

  @override
  String get noChallenges => '도전 없음.';

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
  String get allLanguages => '모든 언어';

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
  String get chessBasics => '체스의 기본';

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
  String get drawByFiftyMoves => '대국이 50수 규칙에 의해 무승부가 되었습니다.';

  @override
  String get theGameIsADraw => '무승부 대국입니다.';

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
  String get tryAnotherMoveForWhite => '백의 또 다른 수를 찾아보세요';

  @override
  String get tryAnotherMoveForBlack => '흑의 또 다른 수를 찾아보세요';

  @override
  String get solution => '해답';

  @override
  String get waitingForAnalysis => '분석을 기다리는 중';

  @override
  String get noMistakesFoundForWhite => '백에게 실수는 없었습니다';

  @override
  String get noMistakesFoundForBlack => '흑에게 실수는 없었습니다';

  @override
  String get doneReviewingWhiteMistakes => '백의 실수 탐색이 종료됨';

  @override
  String get doneReviewingBlackMistakes => '흑의 실수 탐색이 종료됨';

  @override
  String get doItAgain => '다시 하기';

  @override
  String get reviewWhiteMistakes => '백의 실수 탐색하기';

  @override
  String get reviewBlackMistakes => '흑의 실수 탐색하기';

  @override
  String get advantage => '이점';

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
  String get showUnreadLichessMessage => 'Lichess로부터 비공개 메시지를 받았습니다.';

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
  String get playEveryGame => '시작한 모든 대국을 플레이하세요.';

  @override
  String get tryToWin => '플레이하는 모든 대국에서 승리하도록 (적어도 비기도록) 노력하세요.';

  @override
  String get resignLostGames => '벌써 패배한 대국에서는 기권하세요(시간이 흐르게 두지 마세요).';

  @override
  String get temporaryInconvenience => '일시적인 불편에 사과드리며,';

  @override
  String get wishYouGreatGames => '그리고 lichess.org에서 좋은 시간을 보내시기 바랍니다.';

  @override
  String get thankYouForReading => '읽어 주셔서 감사합니다!';

  @override
  String get lifetimeScore => '통산 전적';

  @override
  String get currentMatchScore => '현재 경기 점수';

  @override
  String get agreementAssistance => '나는 대국 중 도움을 받지 않겠습니다 (체스 컴퓨터, 책, 데이터베이스나 다른 사람).';

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
  String get bulletDesc => '매우 빠른 대국: 3분 미만';

  @override
  String get blitzDesc => '빠른 대국: 3에서 8분';

  @override
  String get rapidDesc => '래피드 대국: 8 ~ 25분';

  @override
  String get classicalDesc => '클래시컬 대국: 25분 이상';

  @override
  String get correspondenceDesc => '통신 대국: 한 수당 하루 또는 며칠';

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
    return '$param1에서 문의하실 수 있습니다.';
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
  String get youCannotPostYetPlaySomeGames => '아직 포럼에 글을 작성하실 수 없습니다. 대국을 좀 더 플레이해보세요!';

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
  String get timeAlmostUp => '시간이 거의 다 되었어요!';

  @override
  String get clickToRevealEmailAddress => '[이메일 주소를 보려면 클릭]';

  @override
  String get download => '다운로드';

  @override
  String get coachManager => '코치 설정';

  @override
  String get streamerManager => '스트리머 설정';

  @override
  String get cancelTournament => '토너먼트 취소하기';

  @override
  String get tournDescription => '토너먼트 설명';

  @override
  String get tournDescriptionHelp =>
      '참가자에게 하고 싶은 말이 있나요? 짧게 작성해주세요. 마크다운 링크가 가능합니다: [name](https://url)';

  @override
  String get ratedFormHelp => '대국들은 레이팅이 매겨지며, 플레이어의 레이팅에 영향을 미칩니다';

  @override
  String get onlyMembersOfTeam => '팀 멤버들만';

  @override
  String get noRestriction => '제한 없음';

  @override
  String get minimumRatedGames => '최소 레이팅 대국 참여 횟수';

  @override
  String get minimumRating => '최소 레이팅';

  @override
  String get maximumWeeklyRating => '최대 주간 레이팅';

  @override
  String positionInputHelp(String param) {
    return '모든 대국을 주어진 포지션으로 시작하려면 FEN을 붙여넣으세요.\n일반 대국이 아닌 변형 체스에는 적용되지 않습니다.\nFEN 포지션을 생성하기 위해 $param를 사용할 수 있습니다.\n비워두면 일반 시작 포지션에서 시작합니다.';
  }

  @override
  String get cancelSimul => '동시대국 취소하기';

  @override
  String get simulHostcolor => '각 대국에서 호스트의 색';

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
  String get embedsAvailable => '포함할 대국 URL 또는 연구 챕터 URL을 붙여넣으세요.';

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
  String get navigateMoveTree => '수순 트리 탐색';

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
  String get reopenYourAccount => '계정 재활성화';

  @override
  String get reopenYourAccountDescription => '계정을 폐쇄한 후 마음이 바뀌었다면, 계정을 다시 활성화할 수 있는 기회가 한 번 있습니다.';

  @override
  String get emailAssociatedToaccount => '계정에 등록된 이메일 주소';

  @override
  String get sentEmailWithLink => '링크가 포함된 이메일을 보냈습니다.';

  @override
  String get tournamentEntryCode => '토너먼트 입장 코드';

  @override
  String get hangOn => '잠깐만요!';

  @override
  String gameInProgress(String param) {
    return '$param와(과) 진행중인 대국이 있습니다.';
  }

  @override
  String get abortTheGame => '대국 중단';

  @override
  String get resignTheGame => '대국 기권';

  @override
  String get youCantStartNewGame => '이 대국이 끝나기 전까지 새 대국을 시작할 수 없습니다.';

  @override
  String get since => '부터';

  @override
  String get until => '까지';

  @override
  String get lichessDbExplanation => '모든 Lichess 플레이어의 레이팅 대국 샘플';

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
  String get lichessPatronInfo =>
      'Lichess는 비영리 기구이며 완전한 무료/자유 오픈소스 소프트웨어입니다.\n모든 운영 비용, 개발, 컨텐츠 조달은 전적으로 사용자들의 기부로 이루어집니다.';

  @override
  String get nothingToSeeHere => '지금은 여기에 볼 것이 없습니다.';

  @override
  String get stats => '통계';

  @override
  String get accessibility => '접근성';

  @override
  String get enableBlindMode => '시각장애 모드 활성화하기';

  @override
  String get disableBlindMode => '시각장애 모드 비활성화하기';

  @override
  String opponentLeftCounter(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '상대방이 게임을 나갔습니다. $count초 후에 승리를 취할 수 있습니다.',
    );
    return '$_temp0';
  }

  @override
  String mateInXHalfMoves(int count) {
    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '$count개의 반수 후 체크메이트');
    return '$_temp0';
  }

  @override
  String nbBlunders(int count) {
    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '$count 블런더');
    return '$_temp0';
  }

  @override
  String numberBlunders(int count) {
    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '$count 블런더');
    return '$_temp0';
  }

  @override
  String nbMistakes(int count) {
    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '$count 실수');
    return '$_temp0';
  }

  @override
  String numberMistakes(int count) {
    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '$count 실수');
    return '$_temp0';
  }

  @override
  String nbInaccuracies(int count) {
    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '$count 부정확한 수');
    return '$_temp0';
  }

  @override
  String numberInaccuracies(int count) {
    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '$count 부정확한 수');
    return '$_temp0';
  }

  @override
  String nbPlayers(int count) {
    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '플레이어 $count명');
    return '$_temp0';
  }

  @override
  String nbGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '대국 $count개');
    return '$_temp0';
  }

  @override
  String ratingXOverYGames(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 점수 (대국 $param2 회)',
    );
    return '$_temp0';
  }

  @override
  String nbBookmarks(int count) {
    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '$count개의 즐겨찾기');
    return '$_temp0';
  }

  @override
  String nbDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '$count일');
    return '$_temp0';
  }

  @override
  String nbHours(int count) {
    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '$count시간');
    return '$_temp0';
  }

  @override
  String nbMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '$count분');
    return '$_temp0';
  }

  @override
  String rankIsUpdatedEveryNbMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '순위는 매 $count분마다 갱신됩니다',
    );
    return '$_temp0';
  }

  @override
  String nbPuzzles(int count) {
    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '퍼즐 $count개');
    return '$_temp0';
  }

  @override
  String nbGamesWithYou(int count) {
    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '나와 $count번 대국 함');
    return '$_temp0';
  }

  @override
  String nbRated(int count) {
    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '공식 대국 $count 회');
    return '$_temp0';
  }

  @override
  String nbWins(int count) {
    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '$count번 승리');
    return '$_temp0';
  }

  @override
  String nbLosses(int count) {
    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '$count번 패배');
    return '$_temp0';
  }

  @override
  String nbDraws(int count) {
    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '$count번 비김');
    return '$_temp0';
  }

  @override
  String nbPlaying(int count) {
    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '현재 두고 있는 대국 $count개');
    return '$_temp0';
  }

  @override
  String giveNbSeconds(int count) {
    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '$count초 더 주기');
    return '$_temp0';
  }

  @override
  String nbTournamentPoints(int count) {
    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '$count 토너먼트 점수');
    return '$_temp0';
  }

  @override
  String nbStudies(int count) {
    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '$count 연구');
    return '$_temp0';
  }

  @override
  String nbSimuls(int count) {
    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '$count 다면기');
    return '$_temp0';
  }

  @override
  String moreThanNbRatedGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '레이팅전 $count 국 이상');
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
      other: '$param2 공식 대국을 $count회 더 두어야 합니다.',
    );
    return '$_temp0';
  }

  @override
  String needNbMoreGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '공식 대국을 $count회 더 두어야 합니다.',
    );
    return '$_temp0';
  }

  @override
  String nbImportedGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '불러온 대국 $count개');
    return '$_temp0';
  }

  @override
  String nbFriendsOnline(int count) {
    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '$count명의 친구들이 접속중');
    return '$_temp0';
  }

  @override
  String nbFollowers(int count) {
    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '팔로워 $count명');
    return '$_temp0';
  }

  @override
  String nbFollowing(int count) {
    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '팔로잉 $count명');
    return '$_temp0';
  }

  @override
  String lessThanNbMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '$count분 미만');
    return '$_temp0';
  }

  @override
  String nbGamesInPlay(int count) {
    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '$count개의 대국 진행 중');
    return '$_temp0';
  }

  @override
  String maximumNbCharacters(int count) {
    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '최대 $count자.');
    return '$_temp0';
  }

  @override
  String blocks(int count) {
    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '차단한 사람 $count명');
    return '$_temp0';
  }

  @override
  String nbForumPosts(int count) {
    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '$count 포럼 글');
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
    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '$count개의 언어를 지원합니다!');
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
    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '$count초');
    return '$_temp0';
  }

  @override
  String andSaveNbPremoveLines(int count) {
    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '$count 종류의 조건 수를 설정');
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
    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '$count번 도전');
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
  String get studyPrivate => 'Private';

  @override
  String get studyMyStudies => 'My studies';

  @override
  String get studyStudiesIContributeTo => 'Studies I contribute to';

  @override
  String get studyMyPublicStudies => 'My public studies';

  @override
  String get studyMyPrivateStudies => 'My private studies';

  @override
  String get studyMyFavoriteStudies => 'My favourite studies';

  @override
  String get studyWhatAreStudies => 'What are studies?';

  @override
  String get studyAllStudies => 'All studies';

  @override
  String studyStudiesCreatedByX(String param) {
    return 'Studies created by $param';
  }

  @override
  String get studyNoneYet => 'None yet.';

  @override
  String get studyHot => 'Hot';

  @override
  String get studyDateAddedNewest => 'Date added (newest)';

  @override
  String get studyDateAddedOldest => 'Date added (oldest)';

  @override
  String get studyRecentlyUpdated => 'Recently updated';

  @override
  String get studyMostPopular => 'Most popular';

  @override
  String get studyAlphabetical => 'Alphabetical';

  @override
  String get studyAddNewChapter => 'Add a new chapter';

  @override
  String get studyAddMembers => 'Add members';

  @override
  String get studyInviteToTheStudy => 'Invite to the study';

  @override
  String get studyPleaseOnlyInvitePeopleYouKnow =>
      'Please only invite people who know you, and who actively want to join this study.';

  @override
  String get studySearchByUsername => 'Search by username';

  @override
  String get studySpectator => 'Spectator';

  @override
  String get studyContributor => 'Contributor';

  @override
  String get studyKick => 'Kick';

  @override
  String get studyLeaveTheStudy => 'Leave the study';

  @override
  String get studyYouAreNowAContributor => 'You are now a contributor';

  @override
  String get studyYouAreNowASpectator => 'You are now a spectator';

  @override
  String get studyPgnTags => 'PGN tags';

  @override
  String get studyLike => 'Like';

  @override
  String get studyUnlike => 'Unlike';

  @override
  String get studyNewTag => 'New tag';

  @override
  String get studyCommentThisPosition => 'Comment on this position';

  @override
  String get studyCommentThisMove => 'Comment on this move';

  @override
  String get studyAnnotateWithGlyphs => 'Annotate with glyphs';

  @override
  String get studyTheChapterIsTooShortToBeAnalysed => 'The chapter is too short to be analysed.';

  @override
  String get studyOnlyContributorsCanRequestAnalysis =>
      'Only the study contributors can request a computer analysis.';

  @override
  String get studyGetAFullComputerAnalysis =>
      'Get a full server-side computer analysis of the mainline.';

  @override
  String get studyMakeSureTheChapterIsComplete =>
      'Make sure the chapter is complete. You can only request analysis once.';

  @override
  String get studyAllSyncMembersRemainOnTheSamePosition =>
      'All SYNC members remain on the same position';

  @override
  String get studyShareChanges => 'Share changes with spectators and save them on the server';

  @override
  String get studyPlaying => 'Playing';

  @override
  String get studyShowResults => 'Results';

  @override
  String get studyShowEvalBar => 'Evaluation bars';

  @override
  String get studyNext => 'Next';

  @override
  String get studyShareAndExport => 'Share & export';

  @override
  String get studyCloneStudy => 'Clone';

  @override
  String get studyStudyPgn => 'Study PGN';

  @override
  String get studyChapterPgn => 'Chapter PGN';

  @override
  String get studyCopyChapterPgn => 'Copy PGN';

  @override
  String get studyDownloadGame => 'Download game';

  @override
  String get studyStudyUrl => 'Study URL';

  @override
  String get studyCurrentChapterUrl => 'Current chapter URL';

  @override
  String get studyYouCanPasteThisInTheForumToEmbed =>
      'You can paste this in the forum or your Lichess blog to embed';

  @override
  String get studyStartAtInitialPosition => 'Start at initial position';

  @override
  String studyStartAtX(String param) {
    return 'Start at $param';
  }

  @override
  String get studyEmbedInYourWebsite => 'Embed in your website';

  @override
  String get studyReadMoreAboutEmbedding => 'Read more about embedding';

  @override
  String get studyOnlyPublicStudiesCanBeEmbedded => 'Only public studies can be embedded!';

  @override
  String get studyOpen => 'Open';

  @override
  String studyXBroughtToYouByY(String param1, String param2) {
    return '$param1, brought to you by $param2';
  }

  @override
  String get studyStudyNotFound => 'Study not found';

  @override
  String get studyEditChapter => 'Edit chapter';

  @override
  String get studyNewChapter => 'New chapter';

  @override
  String studyImportFromChapterX(String param) {
    return 'Import from $param';
  }

  @override
  String get studyOrientation => 'Orientation';

  @override
  String get studyAnalysisMode => 'Analysis mode';

  @override
  String get studyPinnedChapterComment => 'Pinned chapter comment';

  @override
  String get studySaveChapter => 'Save chapter';

  @override
  String get studyClearAnnotations => 'Clear annotations';

  @override
  String get studyClearVariations => 'Clear variations';

  @override
  String get studyDeleteChapter => 'Delete chapter';

  @override
  String get studyDeleteThisChapter => 'Delete this chapter. There is no going back!';

  @override
  String get studyClearAllCommentsInThisChapter =>
      'Clear all comments, glyphs and drawn shapes in this chapter';

  @override
  String get studyRightUnderTheBoard => 'Right under the board';

  @override
  String get studyNoPinnedComment => 'None';

  @override
  String get studyNormalAnalysis => 'Normal analysis';

  @override
  String get studyHideNextMoves => 'Hide next moves';

  @override
  String get studyInteractiveLesson => 'Interactive lesson';

  @override
  String studyChapterX(String param) {
    return 'Chapter $param';
  }

  @override
  String get studyEmpty => 'Empty';

  @override
  String get studyStartFromInitialPosition => 'Start from initial position';

  @override
  String get studyEditor => 'Editor';

  @override
  String get studyStartFromCustomPosition => 'Start from custom position';

  @override
  String get studyLoadAGameByUrl => 'Load games by URLs';

  @override
  String get studyLoadAPositionFromFen => 'Load a position from FEN';

  @override
  String get studyLoadAGameFromPgn => 'Load games from PGN';

  @override
  String get studyAutomatic => 'Automatic';

  @override
  String get studyUrlOfTheGame => 'URL of the games, one per line';

  @override
  String studyLoadAGameFromXOrY(String param1, String param2) {
    return 'Load games from $param1 or $param2';
  }

  @override
  String get studyCreateChapter => 'Create chapter';

  @override
  String get studyCreateStudy => 'Create study';

  @override
  String get studyEditStudy => 'Edit study';

  @override
  String get studyVisibility => 'Visibility';

  @override
  String get studyPublic => 'Public';

  @override
  String get studyUnlisted => 'Unlisted';

  @override
  String get studyInviteOnly => 'Invite only';

  @override
  String get studyAllowCloning => 'Allow cloning';

  @override
  String get studyNobody => 'Nobody';

  @override
  String get studyOnlyMe => 'Only me';

  @override
  String get studyContributors => 'Contributors';

  @override
  String get studyMembers => 'Members';

  @override
  String get studyEveryone => 'Everyone';

  @override
  String get studyEnableSync => 'Enable sync';

  @override
  String get studyYesKeepEveryoneOnTheSamePosition => 'Yes: keep everyone on the same position';

  @override
  String get studyNoLetPeopleBrowseFreely => 'No: let people browse freely';

  @override
  String get studyPinnedStudyComment => 'Pinned study comment';

  @override
  String get studyStart => 'Start';

  @override
  String get studySave => 'Save';

  @override
  String get studyClearChat => 'Clear chat';

  @override
  String get studyDeleteTheStudyChatHistory =>
      'Delete the study chat history? There is no going back!';

  @override
  String get studyDeleteStudy => 'Delete study';

  @override
  String studyConfirmDeleteStudy(String param) {
    return 'Delete the entire study? There is no going back! Type the name of the study to confirm: $param';
  }

  @override
  String get studyWhereDoYouWantToStudyThat => 'Where do you want to study that?';

  @override
  String get studyGoodMove => 'Good move';

  @override
  String get studyMistake => 'Mistake';

  @override
  String get studyBrilliantMove => 'Brilliant move';

  @override
  String get studyBlunder => 'Blunder';

  @override
  String get studyInterestingMove => 'Interesting move';

  @override
  String get studyDubiousMove => 'Dubious move';

  @override
  String get studyOnlyMove => 'Only move';

  @override
  String get studyZugzwang => 'Zugzwang';

  @override
  String get studyEqualPosition => 'Equal position';

  @override
  String get studyUnclearPosition => 'Unclear position';

  @override
  String get studyWhiteIsSlightlyBetter => 'White is slightly better';

  @override
  String get studyBlackIsSlightlyBetter => 'Black is slightly better';

  @override
  String get studyWhiteIsBetter => 'White is better';

  @override
  String get studyBlackIsBetter => 'Black is better';

  @override
  String get studyWhiteIsWinning => 'White is winning';

  @override
  String get studyBlackIsWinning => 'Black is winning';

  @override
  String get studyNovelty => 'Novelty';

  @override
  String get studyDevelopment => 'Development';

  @override
  String get studyInitiative => 'Initiative';

  @override
  String get studyAttack => 'Attack';

  @override
  String get studyCounterplay => 'Counterplay';

  @override
  String get studyTimeTrouble => 'Time trouble';

  @override
  String get studyWithCompensation => 'With compensation';

  @override
  String get studyWithTheIdea => 'With the idea';

  @override
  String get studyNextChapter => 'Next chapter';

  @override
  String get studyPrevChapter => 'Previous chapter';

  @override
  String get studyStudyActions => 'Study actions';

  @override
  String get studyTopics => 'Topics';

  @override
  String get studyMyTopics => 'My topics';

  @override
  String get studyPopularTopics => 'Popular topics';

  @override
  String get studyManageTopics => 'Manage topics';

  @override
  String get studyBack => 'Back';

  @override
  String get studyPlayAgain => 'Play again';

  @override
  String get studyWhatWouldYouPlay => 'What would you play in this position?';

  @override
  String get studyYouCompletedThisLesson => 'Congratulations! You completed this lesson.';

  @override
  String studyPerPage(String param) {
    return '$param per page';
  }

  @override
  String get studyGetTheTour => 'Need help? Get the tour!';

  @override
  String get studyWelcomeToLichessStudyTitle => 'Welcome to Lichess Study!';

  @override
  String get studyWelcomeToLichessStudyText =>
      'This is a shared analysis board.<br><br>Use it to analyse and annotate games,<br>discuss positions with friends,<br>and of course for chess lessons!<br><br>It\'s a powerful tool, let\'s take some time to see how it works.';

  @override
  String get studySharedAndSaveTitle => 'Shared and saved';

  @override
  String get studySharedAndSavedText =>
      'Other members can see your moves in real time!<br>Plus, everything is saved forever.';

  @override
  String get studyStudyMembersTitle => 'Study members';

  @override
  String studyStudyMembersText(String param1, String param2) {
    return '$param1 Spectators can view the study and talk in the chat.<br><br>$param2 Contributors can make moves and update the study.';
  }

  @override
  String studyAddMembersText(String param) {
    return 'Click the $param button.<br>Then decide who can contribute or not.';
  }

  @override
  String get studyStudyChaptersTitle => 'Study chapters';

  @override
  String get studyStudyChaptersText =>
      'A study can contain several chapters.<br>Each chapter has a distinct initial position and move tree.';

  @override
  String get studyCommentPositionTitle => 'Comment on a position';

  @override
  String studyCommentPositionText(String param) {
    return 'Click the $param button, or right click on the move list on the right.<br>Comments are shared and saved.';
  }

  @override
  String get studyAnnotatePositionTitle => 'Annotate a position';

  @override
  String get studyAnnotatePositionText =>
      'Click the !? button, or a right click on the move list on the right.<br>Annotation glyphs are shared and saved.';

  @override
  String get studyConclusionTitle => 'Thanks for your time';

  @override
  String get studyConclusionText =>
      'You can find your <a href=\'/study/mine/hot\'>previous studies</a> from your profile page.<br>There is also a <a href=\'//lichess.org/blog/V0KrLSkAAMo3hsi4/study-chess-the-lichess-way\'>blog post about studies</a>.<br>Power users might want to press \"?\" to see keyboard shortcuts.<br>Have fun!';

  @override
  String get studyCreateChapterTitle => 'Let\'s create a study chapter';

  @override
  String get studyCreateChapterText =>
      'A study can have several chapters.<br>Each chapter has a distinct move tree,<br>and can be created in various ways.';

  @override
  String get studyFromInitialPositionTitle => 'From initial position';

  @override
  String get studyFromInitialPositionText =>
      'Just a board setup for a new game.<br>Suited to explore openings.';

  @override
  String get studyCustomPositionTitle => 'Custom position';

  @override
  String get studyCustomPositionText => 'Setup the board your way.<br>Suited to explore endgames.';

  @override
  String get studyLoadExistingLichessGameTitle => 'Load an existing lichess game';

  @override
  String get studyLoadExistingLichessGameText =>
      'Paste a lichess game URL<br>(like lichess.org/7fHIU0XI)<br>to load the game moves in the chapter.';

  @override
  String get studyFromFenStringTitle => 'From a FEN string';

  @override
  String get studyFromFenStringText =>
      'Paste a position in FEN format<br><i>4k3/4rb2/8/7p/8/5Q2/1PP5/1K6 w</i><br>to start the chapter from a position.';

  @override
  String get studyFromPgnGameTitle => 'From a PGN game';

  @override
  String get studyFromPgnGameText =>
      'Paste a game in PGN format.<br>to load moves, comments and variations in the chapter.';

  @override
  String get studyVariantsAreSupportedTitle => 'Studies support variants';

  @override
  String get studyVariantsAreSupportedText =>
      'Yes, you can study crazyhouse<br>and all lichess variants!';

  @override
  String get studyChapterConclusionText =>
      'Chapters are saved forever.<br>Have fun organizing your chess content!';

  @override
  String get studyDoubleDefeat => 'Double defeat';

  @override
  String get studyBlackDefeatWhiteCanNotWin => 'Black defeat, but White can\'t win';

  @override
  String get studyWhiteDefeatBlackCanNotWin => 'White defeat, but Black can\'t win';

  @override
  String studyNbChapters(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Chapters',
      one: '$count Chapter',
    );
    return '$_temp0';
  }

  @override
  String studyNbGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Games',
      one: '$count Game',
    );
    return '$_temp0';
  }

  @override
  String studyNbMembers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Members',
      one: '$count Member',
    );
    return '$_temp0';
  }

  @override
  String studyPasteYourPgnTextHereUpToNbGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'Paste games as PGN text here. For each game, a new chapter is created. The study can have up to $count chapters.',
      one: 'Paste your PGN text here, up to $count game',
    );
    return '$_temp0';
  }

  @override
  String get timeagoJustNow => '방금';

  @override
  String get timeagoRightNow => '지금';

  @override
  String get timeagoCompleted => '종료됨';

  @override
  String timeagoInNbSeconds(int count) {
    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '$count초 후');
    return '$_temp0';
  }

  @override
  String timeagoInNbMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '$count분 후');
    return '$_temp0';
  }

  @override
  String timeagoInNbHours(int count) {
    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '$count시간 후');
    return '$_temp0';
  }

  @override
  String timeagoInNbDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '$count일 후');
    return '$_temp0';
  }

  @override
  String timeagoInNbWeeks(int count) {
    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '$count주 후');
    return '$_temp0';
  }

  @override
  String timeagoInNbMonths(int count) {
    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '$count개월 후');
    return '$_temp0';
  }

  @override
  String timeagoInNbYears(int count) {
    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '$count년 후');
    return '$_temp0';
  }

  @override
  String timeagoNbMinutesAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '$count분 전');
    return '$_temp0';
  }

  @override
  String timeagoNbHoursAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '$count시간 전');
    return '$_temp0';
  }

  @override
  String timeagoNbDaysAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '$count일 전');
    return '$_temp0';
  }

  @override
  String timeagoNbWeeksAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '$count주 전');
    return '$_temp0';
  }

  @override
  String timeagoNbMonthsAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '$count개월 전');
    return '$_temp0';
  }

  @override
  String timeagoNbYearsAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '$count년 전');
    return '$_temp0';
  }

  @override
  String timeagoNbMinutesRemaining(int count) {
    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '$count분 남음');
    return '$_temp0';
  }

  @override
  String timeagoNbHoursRemaining(int count) {
    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '$count시간 남음');
    return '$_temp0';
  }
}
