import 'package:intl/intl.dart' as intl;

import 'l10n.dart';

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

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
  String get activityActivity => '动态';

  @override
  String get activityHostedALiveStream => '主持了直播';

  @override
  String activityRankedInSwissTournament(String param1, String param2) {
    return '在 $param2 中获得第 #$param1 名';
  }

  @override
  String get activitySignedUp => '注册 lichess.org 账户';

  @override
  String activitySupportedNbMonths(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '该用户作为 $param2 已赞助 lichess.org $count 个月',
    );
    return '$_temp0';
  }

  @override
  String activityPracticedNbPositions(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '在 $param2 中完成了 $count 个练习',
    );
    return '$_temp0';
  }

  @override
  String activitySolvedNbPuzzles(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '解决了 $count 道谜题',
    );
    return '$_temp0';
  }

  @override
  String activityPlayedNbGames(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '下了 $count 局 $param2',
    );
    return '$_temp0';
  }

  @override
  String activityPostedNbMessages(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '在 $param2 发布 $count 条留言',
    );
    return '$_temp0';
  }

  @override
  String activityPlayedNbMoves(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '下了 $count 手棋',
    );
    return '$_temp0';
  }

  @override
  String activityInNbCorrespondenceGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '在 $count 局通讯棋局中',
    );
    return '$_temp0';
  }

  @override
  String activityCompletedNbGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '完成了 $count 盘通讯棋',
    );
    return '$_temp0';
  }

  @override
  String activityFollowedNbPlayers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '新关注 $count 个用户',
    );
    return '$_temp0';
  }

  @override
  String activityGainedNbFollowers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '新增 $count 个关注者',
    );
    return '$_temp0';
  }

  @override
  String activityHostedNbSimuls(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '主持了 $count 场车轮战',
    );
    return '$_temp0';
  }

  @override
  String activityJoinedNbSimuls(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '参与了 $count 场车轮战',
    );
    return '$_temp0';
  }

  @override
  String activityCreatedNbStudies(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '创建了 $count 个新的研讨',
    );
    return '$_temp0';
  }

  @override
  String activityCompetedInNbTournaments(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '参与了 $count 场锦标赛',
    );
    return '$_temp0';
  }

  @override
  String activityRankedInTournament(int count, String param2, String param3, String param4) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '在 $param4 里下了 $param3 盘棋，排名 #$count 位（前 $param2% ）',
    );
    return '$_temp0';
  }

  @override
  String activityCompetedInNbSwissTournaments(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '参加了 $count 场 swiss 锦标赛',
    );
    return '$_temp0';
  }

  @override
  String activityJoinedNbTeams(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '加入了 $count 个团队',
    );
    return '$_temp0';
  }

  @override
  String get broadcastBroadcasts => '转播';

  @override
  String get broadcastLiveBroadcasts => '赛事转播';

  @override
  String challengeChallengesX(String param1) {
    return '挑战: $param1';
  }

  @override
  String get challengeChallengeToPlay => '发起挑战';

  @override
  String get challengeChallengeDeclined => '拒绝挑战';

  @override
  String get challengeChallengeAccepted => '接受挑战';

  @override
  String get challengeChallengeCanceled => '挑战已取消';

  @override
  String get challengeRegisterToSendChallenges => '发起挑战前请先注册';

  @override
  String challengeYouCannotChallengeX(String param) {
    return '你不能挑战 $param';
  }

  @override
  String challengeXDoesNotAcceptChallenges(String param) {
    return '$param 不接受挑战';
  }

  @override
  String challengeYourXRatingIsTooFarFromY(String param1, String param2) {
    return '你的 $param1 等级分与 $param2 相差太远';
  }

  @override
  String challengeCannotChallengeDueToProvisionalXRating(String param) {
    return '你的 $param 等级分不够稳定，不能进行挑战。';
  }

  @override
  String challengeXOnlyAcceptsChallengesFromFriends(String param) {
    return '$param只接受好友的挑战。';
  }

  @override
  String get challengeDeclineGeneric => '我目前不接受挑战。';

  @override
  String get challengeDeclineLater => '这不是我合适的时机，请稍后再试。';

  @override
  String get challengeDeclineTooFast => '这次时限对我来说太快了，请再次用较慢的对局来挑战。';

  @override
  String get challengeDeclineTooSlow => '这次时限对我来说太慢了，请再次用较快的对局来挑战。';

  @override
  String get challengeDeclineTimeControl => '我不接受此次时限的挑战。';

  @override
  String get challengeDeclineRated => '请向我发送排位挑战。';

  @override
  String get challengeDeclineCasual => '请向我发送休闲挑战';

  @override
  String get challengeDeclineStandard => '我现在不接变体的挑战。';

  @override
  String get challengeDeclineVariant => '我现在不想玩这个变体。';

  @override
  String get challengeDeclineNoBot => '我不接受机器人的挑战。';

  @override
  String get challengeDeclineOnlyBot => '我只接受机器人的挑战。';

  @override
  String get challengeInviteLichessUser => '或邀请一位 Lichess 用户：';

  @override
  String get contactContact => '联系';

  @override
  String get contactContactLichess => '联系 Lichess';

  @override
  String get patronDonate => '捐赠';

  @override
  String get patronLichessPatron => '赞助 Lichess';

  @override
  String perfStatPerfStats(String param) {
    return '$param 战绩';
  }

  @override
  String get perfStatViewTheGames => '查看棋局';

  @override
  String get perfStatProvisional => '暂定';

  @override
  String get perfStatNotEnoughRatedGames => '因排位赛数量不足而无法测定可靠的等级分';

  @override
  String perfStatProgressOverLastXGames(String param) {
    return '最近 $param 局后的变化:';
  }

  @override
  String perfStatRatingDeviation(String param) {
    return '等级分偏差: $param';
  }

  @override
  String perfStatRatingDeviationTooltip(String param1, String param2, String param3) {
    return '偏差值越低，等级分越稳定。若偏差值大于 $param1，则等级分是暂时的。只有当偏差低于 $param2（标准局）/ $param3（变种）时，才能进入排名。';
  }

  @override
  String get perfStatTotalGames => '棋局总数';

  @override
  String get perfStatRatedGames => '排位赛局数';

  @override
  String get perfStatTournamentGames => '锦标赛局数';

  @override
  String get perfStatBerserkedGames => '神速局数';

  @override
  String get perfStatTimeSpentPlaying => '弈棋总时间';

  @override
  String get perfStatAverageOpponent => '对手平均等级分';

  @override
  String get perfStatVictories => '胜';

  @override
  String get perfStatDefeats => '负';

  @override
  String get perfStatDisconnections => '断线';

  @override
  String get perfStatNotEnoughGames => '棋局不足';

  @override
  String perfStatHighestRating(String param) {
    return '最高等级分: $param';
  }

  @override
  String perfStatLowestRating(String param) {
    return '最低等级分: $param';
  }

  @override
  String perfStatFromXToY(String param1, String param2) {
    return '自 $param1 至 $param2';
  }

  @override
  String get perfStatWinningStreak => '连胜';

  @override
  String get perfStatLosingStreak => '连败';

  @override
  String perfStatLongestStreak(String param) {
    return '最长纪录: $param';
  }

  @override
  String perfStatCurrentStreak(String param) {
    return '当前纪录: $param';
  }

  @override
  String get perfStatBestRated => '最佳胜利';

  @override
  String get perfStatGamesInARow => '连续对局';

  @override
  String get perfStatLessThanOneHour => '棋局间隔一个小时以内';

  @override
  String get perfStatMaxTimePlaying => '最长连续对局时间';

  @override
  String get perfStatNow => '现在';

  @override
  String get preferencesPreferences => '偏好设置';

  @override
  String get preferencesDisplay => '显示';

  @override
  String get preferencesPrivacy => '隐私设置';

  @override
  String get preferencesNotifications => '通知';

  @override
  String get preferencesPieceAnimation => '棋子动画';

  @override
  String get preferencesMaterialDifference => '子力差距';

  @override
  String get preferencesBoardHighlights => '棋盘高亮（最后一步与将军）';

  @override
  String get preferencesPieceDestinations => '棋子走到位置（有效着与预先走棋）';

  @override
  String get preferencesBoardCoordinates => '棋盘坐标（A-H, 1-8）';

  @override
  String get preferencesMoveListWhilePlaying => '对局进行时显示可走着法';

  @override
  String get preferencesPgnPieceNotation => '使用PGN字母(K,Q,R,B,N)或棋子图标来显示PGN棋谱';

  @override
  String get preferencesChessPieceSymbol => '棋子图标';

  @override
  String get preferencesPgnLetter => '字母 （K,Q,R,B,N）';

  @override
  String get preferencesZenMode => '禅意模式';

  @override
  String get preferencesShowPlayerRatings => '显示等级分';

  @override
  String get preferencesShowFlairs => '显示玩家图标';

  @override
  String get preferencesExplainShowPlayerRatings => '该选项可在网站内隐藏等级分，使你可以专注于下棋本身。对局依旧会影响等级分，但不会向你显示。';

  @override
  String get preferencesDisplayBoardResizeHandle => '调整棋盘大小';

  @override
  String get preferencesOnlyOnInitialPosition => '仅初始局面';

  @override
  String get preferencesInGameOnly => '仅在对局中';

  @override
  String get preferencesChessClock => '棋钟';

  @override
  String get preferencesTenthsOfSeconds => '显示十分之一秒';

  @override
  String get preferencesWhenTimeRemainingLessThanTenSeconds => '当剩余时间小于10秒';

  @override
  String get preferencesHorizontalGreenProgressBars => '显示绿色横进度条';

  @override
  String get preferencesSoundWhenTimeGetsCritical => '时间不足时声音提醒';

  @override
  String get preferencesGiveMoreTime => '给对方更多时间';

  @override
  String get preferencesGameBehavior => '对局行为';

  @override
  String get preferencesHowDoYouMovePieces => '你想通过什么方式走棋？';

  @override
  String get preferencesClickTwoSquares => '点起始位置和终止位置';

  @override
  String get preferencesDragPiece => '拖动棋子';

  @override
  String get preferencesBothClicksAndDrag => '两者都行';

  @override
  String get preferencesPremovesPlayingDuringOpponentTurn => '预先走棋（在对手的回合走棋）';

  @override
  String get preferencesTakebacksWithOpponentApproval => '悔棋（需要对手同意）';

  @override
  String get preferencesInCasualGamesOnly => '仅限于休闲对局';

  @override
  String get preferencesPromoteToQueenAutomatically => '兵自动升为后';

  @override
  String get preferencesExplainPromoteToQueenAutomatically => '按住 <ctrl> 键以临时禁用自动升变';

  @override
  String get preferencesWhenPremoving => '预先走棋時';

  @override
  String get preferencesClaimDrawOnThreefoldRepetitionAutomatically => '在三次重复局面时自动要求和局';

  @override
  String get preferencesWhenTimeRemainingLessThanThirtySeconds => '当剩余时间小于30秒';

  @override
  String get preferencesMoveConfirmation => '确认走棋';

  @override
  String get preferencesExplainCanThenBeTemporarilyDisabled => '可以在游戏中使用棋盘菜单禁用此功能';

  @override
  String get preferencesInCorrespondenceGames => '通信棋局';

  @override
  String get preferencesCorrespondenceAndUnlimited => '通信和无限';

  @override
  String get preferencesConfirmResignationAndDrawOffers => '认输以及提出和棋需要确认';

  @override
  String get preferencesCastleByMovingTheKingTwoSquaresOrOntoTheRook => '王车易位方法';

  @override
  String get preferencesCastleByMovingTwoSquares => '将王移动两格';

  @override
  String get preferencesCastleByMovingOntoTheRook => '将王移到车上';

  @override
  String get preferencesInputMovesWithTheKeyboard => '用键盘输入棋步';

  @override
  String get preferencesInputMovesWithVoice => '用语音输入着法';

  @override
  String get preferencesSnapArrowsToValidMoves => '将箭头吸附到有效着法上';

  @override
  String get preferencesSayGgWpAfterLosingOrDrawing => '输棋、和棋后自动发送：“厉害，玩得不错！”';

  @override
  String get preferencesYourPreferencesHaveBeenSaved => '你的设置已保存。';

  @override
  String get preferencesScrollOnTheBoardToReplayMoves => '在棋盘上滚动鼠标滚轮以回退';

  @override
  String get preferencesCorrespondenceEmailNotification => '每日发送邮件通知你正在进行的通讯棋局';

  @override
  String get preferencesNotifyStreamStart => '主播开始直播';

  @override
  String get preferencesNotifyInboxMsg => '新消息';

  @override
  String get preferencesNotifyForumMention => '论坛评论提到了你';

  @override
  String get preferencesNotifyInvitedStudy => '研讨邀请';

  @override
  String get preferencesNotifyGameEvent => '通信棋局更新';

  @override
  String get preferencesNotifyChallenge => '挑战';

  @override
  String get preferencesNotifyTournamentSoon => '比赛即将开始';

  @override
  String get preferencesNotifyTimeAlarm => '通讯棋局时间快要耗尽';

  @override
  String get preferencesNotifyBell => 'Lichess 内的铃声通知';

  @override
  String get preferencesNotifyPush => 'Lichess 外的设备通知';

  @override
  String get preferencesNotifyWeb => '浏览器通知';

  @override
  String get preferencesNotifyDevice => '设备通知';

  @override
  String get preferencesBellNotificationSound => '通知铃声';

  @override
  String get puzzlePuzzles => '谜题';

  @override
  String get puzzlePuzzleThemes => '训练主题';

  @override
  String get puzzleRecommended => '我们推荐：';

  @override
  String get puzzlePhases => '分阶段';

  @override
  String get puzzleMotifs => '分主题';

  @override
  String get puzzleAdvanced => '进阶';

  @override
  String get puzzleLengths => '分长度';

  @override
  String get puzzleMates => '将死';

  @override
  String get puzzleGoals => '分目标';

  @override
  String get puzzleOrigin => '来源';

  @override
  String get puzzleSpecialMoves => '特殊着法';

  @override
  String get puzzleDidYouLikeThisPuzzle => '你喜欢这道训练题吗？';

  @override
  String get puzzleVoteToLoadNextOne => '投票以加载下一题';

  @override
  String get puzzleUpVote => '赞';

  @override
  String get puzzleDownVote => '踩';

  @override
  String get puzzleYourPuzzleRatingWillNotChange => '你的谜题等级分将不会改变。请注意，解谜题不是比赛。等级分有助于根据你当前水平选择最佳谜题。';

  @override
  String get puzzleFindTheBestMoveForWhite => '找出白方的最佳着法';

  @override
  String get puzzleFindTheBestMoveForBlack => '找出黑方的最佳着法';

  @override
  String get puzzleToGetPersonalizedPuzzles => '获取个性化谜题';

  @override
  String puzzlePuzzleId(String param) {
    return '谜题编号：$param';
  }

  @override
  String get puzzlePuzzleOfTheDay => '每日棋谜';

  @override
  String get puzzleDailyPuzzle => '每日棋谜';

  @override
  String get puzzleClickToSolve => '点击解题';

  @override
  String get puzzleGoodMove => '好棋';

  @override
  String get puzzleBestMove => '最佳走法！';

  @override
  String get puzzleKeepGoing => '请继续…';

  @override
  String get puzzlePuzzleSuccess => '解题成功!';

  @override
  String get puzzlePuzzleComplete => '解题完成!';

  @override
  String get puzzleByOpenings => '按开局分类';

  @override
  String get puzzlePuzzlesByOpenings => '按开局分类的谜题';

  @override
  String get puzzleOpeningsYouPlayedTheMost => '你在排位赛中使用最多的开局';

  @override
  String get puzzleUseFindInPage => '在浏览器菜单中使用 “在页面中查找” 来找到你最爱的开局！';

  @override
  String get puzzleUseCtrlF => '使用 Ctrl + F 查找你最爱的开局！';

  @override
  String get puzzleNotTheMove => '不是最佳着法';

  @override
  String get puzzleTrySomethingElse => '试试其他着法';

  @override
  String puzzleRatingX(String param) {
    return '等级分：$param';
  }

  @override
  String get puzzleHidden => '已隐藏';

  @override
  String puzzleFromGameLink(String param) {
    return '来自对局：$param';
  }

  @override
  String get puzzleContinueTraining => '继续训练';

  @override
  String get puzzleDifficultyLevel => '难易级别';

  @override
  String get puzzleNormal => '正常';

  @override
  String get puzzleEasier => '更简单';

  @override
  String get puzzleEasiest => '最简单';

  @override
  String get puzzleHarder => '更难';

  @override
  String get puzzleHardest => '最难';

  @override
  String get puzzleExample => '示例';

  @override
  String get puzzleAddAnotherTheme => '添加新的主题';

  @override
  String get puzzleNextPuzzle => '下一个谜题';

  @override
  String get puzzleJumpToNextPuzzleImmediately => '解题后立即跳至下一个';

  @override
  String get puzzlePuzzleDashboard => '数据统计';

  @override
  String get puzzleImprovementAreas => '有待提升';

  @override
  String get puzzleStrengths => '强项';

  @override
  String get puzzleHistory => '解题历史';

  @override
  String get puzzleSolved => '已解答';

  @override
  String get puzzleFailed => '失败';

  @override
  String get puzzleStreakDescription => '解破日益困难的谜题，从而建造一个胜利纪录。没有计时。一步错解，游戏就会结束！不过，每场游戏都可跳过一步棋。';

  @override
  String puzzleYourStreakX(String param) {
    return '你的连胜纪录: $param';
  }

  @override
  String get puzzleStreakSkipExplanation => '跳过这一步来保持你的连胜纪录！每场游戏只能使用一次。';

  @override
  String get puzzleContinueTheStreak => '继续连胜纪录';

  @override
  String get puzzleNewStreak => '新连胜纪录';

  @override
  String get puzzleFromMyGames => '来自我的对局';

  @override
  String get puzzleLookupOfPlayer => '从玩家的对局中查找谜题';

  @override
  String puzzleFromXGames(String param) {
    return '来自 $param 的对局的谜题';
  }

  @override
  String get puzzleSearchPuzzles => '搜索谜题';

  @override
  String get puzzleFromMyGamesNone => '你下过的棋局暂时没有被纳入到谜题数据库中，但 Lichess 将一如既往地记着你所走的每一步。\n多下快棋和慢棋可以提升你的棋局被纳入谜题数据库的概率哦！';

  @override
  String puzzleFromXGamesFound(String param1, String param2) {
    return '在 $param2 场对局中发现了 $param1 个谜题';
  }

  @override
  String get puzzlePuzzleDashboardDescription => '训练、分析、提升';

  @override
  String puzzlePercentSolved(String param) {
    return '$param 已解决';
  }

  @override
  String get puzzleNoPuzzlesToShow => '没有什么可以显示的，先去玩一些谜题吧！';

  @override
  String get puzzleImprovementAreasDescription => '训练这些主题来提升你的表现！';

  @override
  String get puzzleStrengthDescription => '你擅长这些主题';

  @override
  String puzzlePlayedXTimes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '共 $count 次尝试',
    );
    return '$_temp0';
  }

  @override
  String puzzleNbPointsBelowYourPuzzleRating(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '比你的谜题等级分低$count',
    );
    return '$_temp0';
  }

  @override
  String puzzleNbPointsAboveYourPuzzleRating(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '比你的谜题等级分高$count',
    );
    return '$_temp0';
  }

  @override
  String puzzleNbPlayed(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '玩过 $count',
    );
    return '$_temp0';
  }

  @override
  String puzzleNbToReplay(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 重玩',
    );
    return '$_temp0';
  }

  @override
  String get puzzleThemeAdvancedPawn => '高位兵';

  @override
  String get puzzleThemeAdvancedPawnDescription => '你的兵已经深入对手的领地，可能威胁升变。';

  @override
  String get puzzleThemeAdvantage => '优势';

  @override
  String get puzzleThemeAdvantageDescription => '抓住能让你获得决定性优势的机会。(200厘兵 ≤ 评估 ≤ 600厘兵)';

  @override
  String get puzzleThemeAnastasiaMate => '阿纳斯塔西亚杀法';

  @override
  String get puzzleThemeAnastasiaMateDescription => '马与车或者后配合将对方的王将死在被同一方棋子卡住的边角。';

  @override
  String get puzzleThemeArabianMate => '阿拉伯杀法';

  @override
  String get puzzleThemeArabianMateDescription => '马与车配合将杀对方在角落上的王。';

  @override
  String get puzzleThemeAttackingF2F7 => '进攻 f2 或 f7';

  @override
  String get puzzleThemeAttackingF2F7Description => '进攻的焦点集中在f2或f7兵，像在双马防御煎肝进攻中一样。';

  @override
  String get puzzleThemeAttraction => '引入';

  @override
  String get puzzleThemeAttractionDescription => '以兑子或弃子吸引或迫使对方的棋子走到后续可实施战术的格子。';

  @override
  String get puzzleThemeBackRankMate => '底线杀王';

  @override
  String get puzzleThemeBackRankMateDescription => '在底线将杀被同一方棋子困住的王。';

  @override
  String get puzzleThemeBishopEndgame => '象残局';

  @override
  String get puzzleThemeBishopEndgameDescription => '只有象和兵的残局。';

  @override
  String get puzzleThemeBodenMate => '波登杀法';

  @override
  String get puzzleThemeBodenMateDescription => '双象在交错的斜线上将杀被同一方棋子阻挡的王。';

  @override
  String get puzzleThemeCastling => '王车易位';

  @override
  String get puzzleThemeCastlingDescription => '将王转移到安全的地方，同时将车投入进攻。';

  @override
  String get puzzleThemeCapturingDefender => '消除保护';

  @override
  String get puzzleThemeCapturingDefenderDescription => '消除保护另一个棋子的重要棋子，以在后续着法中吃掉已消除保护的棋子。';

  @override
  String get puzzleThemeCrushing => '压倒性优势';

  @override
  String get puzzleThemeCrushingDescription => '抓住对手的失误以获得压倒性的优势 (评估 ≥ 600厘兵)。';

  @override
  String get puzzleThemeDoubleBishopMate => '双象杀王';

  @override
  String get puzzleThemeDoubleBishopMateDescription => '双象在相邻的斜线上将杀被同一方棋子阻挡的王。';

  @override
  String get puzzleThemeDovetailMate => '燕尾杀法';

  @override
  String get puzzleThemeDovetailMateDescription => '后贴面杀，王唯一能逃跑的两个格子被同一方的棋子阻挡。';

  @override
  String get puzzleThemeEquality => '均势';

  @override
  String get puzzleThemeEqualityDescription => '从大劣的局面回到和棋或者均势 (评估 ≤ 200厘兵)。';

  @override
  String get puzzleThemeKingsideAttack => '王翼进攻';

  @override
  String get puzzleThemeKingsideAttackDescription => '在对方短易位后进攻对方的王。';

  @override
  String get puzzleThemeClearance => '腾挪';

  @override
  String get puzzleThemeClearanceDescription => '一着通常伴随有为后续战术构想腾空棋格、直线或斜线的棋。';

  @override
  String get puzzleThemeDefensiveMove => '防守着法';

  @override
  String get puzzleThemeDefensiveMoveDescription => '避免丢子或失去其他优势所需的精确着法或着法序列。';

  @override
  String get puzzleThemeDeflection => '引离';

  @override
  String get puzzleThemeDeflectionDescription => '一步棋使对方的棋子分散了其另一项任务，例如防守一个关键格。有时候也叫“过载”。';

  @override
  String get puzzleThemeDiscoveredAttack => '闪击';

  @override
  String get puzzleThemeDiscoveredAttackDescription => '移动阻挡长距离棋子(例如车) 的己方棋子(例如马)，打通前者的路线。';

  @override
  String get puzzleThemeDoubleCheck => '双将';

  @override
  String get puzzleThemeDoubleCheckDescription => '两个棋子同时将军，作为一种闪击，走动的棋子与后面闪露出来的棋子同时攻击对方的王。';

  @override
  String get puzzleThemeEndgame => '残局';

  @override
  String get puzzleThemeEndgameDescription => '对局最后阶段的战术。';

  @override
  String get puzzleThemeEnPassantDescription => '涉及吃过路兵规则的战术，兵可以吃掉对方刚走两格、横向相邻的兵。';

  @override
  String get puzzleThemeExposedKing => '暴露的王';

  @override
  String get puzzleThemeExposedKingDescription => '对方王的周围只有很少的防守棋子时的战术，往往导致将杀。';

  @override
  String get puzzleThemeFork => '击双';

  @override
  String get puzzleThemeForkDescription => '走动的棋子同时攻击对方的两个棋子。';

  @override
  String get puzzleThemeHangingPiece => '悬子';

  @override
  String get puzzleThemeHangingPieceDescription => '涉及对方少保护或无保护的棋子，可以随意吃掉。';

  @override
  String get puzzleThemeHookMate => '勾杀';

  @override
  String get puzzleThemeHookMateDescription => '用车、马、兵杀棋，对方的兵限制王逃跑。';

  @override
  String get puzzleThemeInterference => '拦截';

  @override
  String get puzzleThemeInterferenceDescription => '走动棋子到对手的两个棋子之间，使其中的一个或两个棋子消除保护，例如将一个马走到两个车之间的防守格上。';

  @override
  String get puzzleThemeIntermezzo => '过渡着';

  @override
  String get puzzleThemeIntermezzoDescription => '不走预期的着法，而是走一着对手必须应对的直接威胁。';

  @override
  String get puzzleThemeKnightEndgame => '马残局';

  @override
  String get puzzleThemeKnightEndgameDescription => '只有马和兵的残局。';

  @override
  String get puzzleThemeLong => '长谜题';

  @override
  String get puzzleThemeLongDescription => '三步胜。';

  @override
  String get puzzleThemeMaster => '大师对局';

  @override
  String get puzzleThemeMasterDescription => '出自有名棋手对局的谜题。';

  @override
  String get puzzleThemeMasterVsMaster => '大师与大师对局';

  @override
  String get puzzleThemeMasterVsMasterDescription => '出自两位有名棋手对局的谜题。';

  @override
  String get puzzleThemeMate => '杀王';

  @override
  String get puzzleThemeMateDescription => '有型地赢棋。';

  @override
  String get puzzleThemeMateIn1 => '一步杀';

  @override
  String get puzzleThemeMateIn1Description => '一步之内实现将杀。';

  @override
  String get puzzleThemeMateIn2 => '两步杀';

  @override
  String get puzzleThemeMateIn2Description => '两步之内实现将杀。';

  @override
  String get puzzleThemeMateIn3 => '三步杀';

  @override
  String get puzzleThemeMateIn3Description => '三步之内实现将杀。';

  @override
  String get puzzleThemeMateIn4 => '四步杀';

  @override
  String get puzzleThemeMateIn4Description => '四步之内实现将杀。';

  @override
  String get puzzleThemeMateIn5 => '五步或更多步杀';

  @override
  String get puzzleThemeMateIn5Description => '找出一套很长的将杀着法。';

  @override
  String get puzzleThemeMiddlegame => '中局';

  @override
  String get puzzleThemeMiddlegameDescription => '对局第二阶段的战术。';

  @override
  String get puzzleThemeOneMove => '一步棋谜题';

  @override
  String get puzzleThemeOneMoveDescription => '只有一步棋的谜题。';

  @override
  String get puzzleThemeOpening => '开局';

  @override
  String get puzzleThemeOpeningDescription => '对局第一阶段的战术。';

  @override
  String get puzzleThemePawnEndgame => '兵残局';

  @override
  String get puzzleThemePawnEndgameDescription => '只有兵的残局。';

  @override
  String get puzzleThemePin => '牵制';

  @override
  String get puzzleThemePinDescription => '涉及牵制的策略，一个棋子不能移动否则背后更高价值的棋子将被攻击。';

  @override
  String get puzzleThemePromotion => '升变';

  @override
  String get puzzleThemePromotionDescription => '将兵升变为后或其他棋子。';

  @override
  String get puzzleThemeQueenEndgame => '后残局';

  @override
  String get puzzleThemeQueenEndgameDescription => '只有后和兵的残局。';

  @override
  String get puzzleThemeQueenRookEndgame => '后车残局';

  @override
  String get puzzleThemeQueenRookEndgameDescription => '只有后、车、兵的残局。';

  @override
  String get puzzleThemeQueensideAttack => '后翼进攻';

  @override
  String get puzzleThemeQueensideAttackDescription => '在对方长易位后进攻对方的王。';

  @override
  String get puzzleThemeQuietMove => '安静的一着';

  @override
  String get puzzleThemeQuietMoveDescription => '一步没有将军吃子的棋，但是为后续准备了一个不可避免的威胁。';

  @override
  String get puzzleThemeRookEndgame => '车残局';

  @override
  String get puzzleThemeRookEndgameDescription => '只有车和兵的残局。';

  @override
  String get puzzleThemeSacrifice => '弃子';

  @override
  String get puzzleThemeSacrificeDescription => '涉及在短期内弃子的策略，以便在强制执行一系列着法后再次获得优势。';

  @override
  String get puzzleThemeShort => '短谜题';

  @override
  String get puzzleThemeShortDescription => '两步胜。';

  @override
  String get puzzleThemeSkewer => '串击';

  @override
  String get puzzleThemeSkewerDescription => '攻击对方高价值的棋子，使其走开，以允许其后方较低价值的棋子被吃或攻击（反向的牵制）。';

  @override
  String get puzzleThemeSmotheredMate => '闷杀';

  @override
  String get puzzleThemeSmotheredMateDescription => '由马完成的将杀，对方王被自己的棋子包围（或困住），因此无法移动。';

  @override
  String get puzzleThemeSuperGM => '超级大师对局';

  @override
  String get puzzleThemeSuperGMDescription => '出自世界上最好的棋手对局的谜题。';

  @override
  String get puzzleThemeTrappedPiece => '被困的棋子';

  @override
  String get puzzleThemeTrappedPieceDescription => '一个棋子由于其走法有限无法逃脱被捉。';

  @override
  String get puzzleThemeUnderPromotion => '低升变';

  @override
  String get puzzleThemeUnderPromotionDescription => '升变为马、象或车。';

  @override
  String get puzzleThemeVeryLong => '超长谜题';

  @override
  String get puzzleThemeVeryLongDescription => '四步或更多步胜。';

  @override
  String get puzzleThemeXRayAttack => '穿透攻击';

  @override
  String get puzzleThemeXRayAttackDescription => '一个棋子穿过对方的棋子攻击或防守一个格子。';

  @override
  String get puzzleThemeZugzwang => '楚茨文克（无等着）';

  @override
  String get puzzleThemeZugzwangDescription => '对手可选的着法是有限的，并且所有着法都会使其局面更加恶化。';

  @override
  String get puzzleThemeHealthyMix => '健康搭配';

  @override
  String get puzzleThemeHealthyMixDescription => '每个主题中选取一些。你不知道会出现什么，因此得时刻打起精神！ 就像在真实对局中一样。';

  @override
  String get puzzleThemePlayerGames => '玩家对局';

  @override
  String get puzzleThemePlayerGamesDescription => '查找从你或其他玩家的对局中产生的谜题。';

  @override
  String puzzleThemePuzzleDownloadInformation(String param) {
    return '这些谜题都是公开的，可以在 $param 下载。';
  }

  @override
  String get searchSearch => '搜索';

  @override
  String get settingsSettings => '设置';

  @override
  String get settingsCloseAccount => '关闭账户';

  @override
  String get settingsManagedAccountCannotBeClosed => '你的账号已被管理，无法被关闭。';

  @override
  String get settingsClosingIsDefinitive => '关闭账户是不可回退的决定。你真的确定吗？';

  @override
  String get settingsCantOpenSimilarAccount => '新账号名称不能和旧账号相同，只有大小写差别也不被允许。';

  @override
  String get settingsChangedMindDoNotCloseAccount => '我改主意了，不要关闭帐号';

  @override
  String get settingsCloseAccountExplanation => '你确定要关闭你的账户？关闭账户是不可回退的决定。 你将再不能再使用此账户登录。';

  @override
  String get settingsThisAccountIsClosed => '此帐户已被关闭。';

  @override
  String get playWithAFriend => '与好友下棋';

  @override
  String get playWithTheMachine => '和电脑下棋';

  @override
  String get toInviteSomeoneToPlayGiveThisUrl => '邀人下棋，请分享这个网址';

  @override
  String get gameOver => '棋局结束';

  @override
  String get waitingForOpponent => '等待对手';

  @override
  String get orLetYourOpponentScanQrCode => '或请您的对手扫描此二维码';

  @override
  String get waiting => '等待中';

  @override
  String get yourTurn => '你的回合';

  @override
  String aiNameLevelAiLevel(String param1, String param2) {
    return '$param1级別$param2';
  }

  @override
  String get level => '级别';

  @override
  String get strength => '电脑的难度';

  @override
  String get toggleTheChat => '聊天开关';

  @override
  String get chat => '聊天';

  @override
  String get resign => '认输';

  @override
  String get checkmate => '将死';

  @override
  String get stalemate => '逼和';

  @override
  String get white => '白方';

  @override
  String get black => '黑方';

  @override
  String get asWhite => '持白';

  @override
  String get asBlack => '持黑';

  @override
  String get randomColor => '随机选色';

  @override
  String get createAGame => '创建对局';

  @override
  String get whiteIsVictorious => '白方胜';

  @override
  String get blackIsVictorious => '黑方胜';

  @override
  String get youPlayTheWhitePieces => '你执白棋';

  @override
  String get youPlayTheBlackPieces => '你执黑棋';

  @override
  String get itsYourTurn => '轮到你了！';

  @override
  String get cheatDetected => '检测到作弊';

  @override
  String get kingInTheCenter => '王占中';

  @override
  String get threeChecks => '三次将军';

  @override
  String get raceFinished => '比赛结束';

  @override
  String get variantEnding => '变种结束';

  @override
  String get newOpponent => '新对手';

  @override
  String get yourOpponentWantsToPlayANewGameWithYou => '你的对手想和你再玩一局';

  @override
  String get joinTheGame => '加入对局';

  @override
  String get whitePlays => '白方走棋';

  @override
  String get blackPlays => '黑方走棋';

  @override
  String get opponentLeftChoices => '您的对手可能已离开棋局。您可以宣布胜利，和棋，或继续等待。';

  @override
  String get forceResignation => '宣布胜利';

  @override
  String get forceDraw => '和棋';

  @override
  String get talkInChat => '聊天请注意文明用语。';

  @override
  String get theFirstPersonToComeOnThisUrlWillPlayWithYou => '第一个访问此网址的人将与你下棋。';

  @override
  String get whiteResigned => '白方认输';

  @override
  String get blackResigned => '黑方认输';

  @override
  String get whiteLeftTheGame => '白方离开了棋局';

  @override
  String get blackLeftTheGame => '黑方离开了棋局';

  @override
  String get whiteDidntMove => '白方没有走棋';

  @override
  String get blackDidntMove => '黑方没有走棋';

  @override
  String get requestAComputerAnalysis => '请求电脑分析';

  @override
  String get computerAnalysis => '电脑分析';

  @override
  String get computerAnalysisAvailable => '电脑分析可用';

  @override
  String get computerAnalysisDisabled => '电脑分析已禁用';

  @override
  String get analysis => '分析面板';

  @override
  String depthX(String param) {
    return '深度 $param';
  }

  @override
  String get usingServerAnalysis => '正在使用服务器分析';

  @override
  String get loadingEngine => '引擎载入中...';

  @override
  String get calculatingMoves => '计算着法中...';

  @override
  String get engineFailed => '加载引擎时出错';

  @override
  String get cloudAnalysis => '云分析';

  @override
  String get goDeeper => '深入分析';

  @override
  String get showThreat => '显示威胁';

  @override
  String get inLocalBrowser => '在本地浏览器';

  @override
  String get toggleLocalEvaluation => '切换到本地分析';

  @override
  String get promoteVariation => '提升变着';

  @override
  String get makeMainLine => '做为主线';

  @override
  String get deleteFromHere => '从此处开始删除';

  @override
  String get collapseVariations => '折叠变着';

  @override
  String get expandVariations => '展开变着';

  @override
  String get forceVariation => '强制作为变着';

  @override
  String get copyVariationPgn => '复制变着的PGN';

  @override
  String get move => '着法';

  @override
  String get variantLoss => '变体输了';

  @override
  String get variantWin => '变体胜利';

  @override
  String get insufficientMaterial => '子力不足';

  @override
  String get pawnMove => '走兵';

  @override
  String get capture => '吃子';

  @override
  String get close => '关闭';

  @override
  String get winning => '赢棋';

  @override
  String get losing => '输棋';

  @override
  String get drawn => '和棋';

  @override
  String get unknown => '结局未知';

  @override
  String get database => '数据库';

  @override
  String get whiteDrawBlack => '白胜／和棋／黑胜';

  @override
  String averageRatingX(String param) {
    return '平均等级分：$param';
  }

  @override
  String get recentGames => '最近对局';

  @override
  String get topGames => '名局';

  @override
  String masterDbExplanation(String param1, String param2, String param3) {
    return '$param2-$param3年国际棋联等级分$param1以上棋手的两百万局棋谱';
  }

  @override
  String get dtzWithRounding => '经过四舍五入的DTZ50\'\'，是基于到下次吃子或兵动的半步数目。';

  @override
  String get noGameFound => '没找到符合要求的棋局';

  @override
  String get maxDepthReached => '已达最大深度！';

  @override
  String get maybeIncludeMoreGamesFromThePreferencesMenu => '请尝试在“选择”菜单内包括更多棋局。';

  @override
  String get openings => '开局';

  @override
  String get openingExplorer => '开局浏览器';

  @override
  String get openingEndgameExplorer => '开局/残局浏览器';

  @override
  String xOpeningExplorer(String param) {
    return '$param 开局浏览器';
  }

  @override
  String get playFirstOpeningEndgameExplorerMove => '在开局/残局浏览器走第一步棋';

  @override
  String get winPreventedBy50MoveRule => '因50回合规则未赢棋';

  @override
  String get lossSavedBy50MoveRule => '因50回合规则未输棋';

  @override
  String get winOr50MovesByPriorMistake => '赢棋或因先前错误而50步作和';

  @override
  String get lossOr50MovesByPriorMistake => '输棋或因先前错误而50步作和';

  @override
  String get unknownDueToRounding => '由上次吃子或兵动开始按残局库建议走法走才能保证胜败的判断正确。这是因为Syzygy残局库的DTZ数值可能经过四舍五入。';

  @override
  String get allSet => '好了！';

  @override
  String get importPgn => '导入 PGN';

  @override
  String get delete => '删除';

  @override
  String get deleteThisImportedGame => '删除此导入的棋局？';

  @override
  String get replayMode => '回放模式';

  @override
  String get realtimeReplay => '实时回放';

  @override
  String get byCPL => '按厘兵损失';

  @override
  String get openStudy => '进入研讨室';

  @override
  String get enable => '启用';

  @override
  String get bestMoveArrow => '最佳着法指示';

  @override
  String get showVariationArrows => '显示变着箭头';

  @override
  String get evaluationGauge => '显示局面评估';

  @override
  String get multipleLines => '多线搜索';

  @override
  String get cpus => 'CPU';

  @override
  String get memory => '内存';

  @override
  String get infiniteAnalysis => '开启无限分析';

  @override
  String get removesTheDepthLimit => '取消深度限制（会提升电脑温度）';

  @override
  String get engineManager => '引擎管理';

  @override
  String get blunder => '漏着';

  @override
  String get mistake => '错着';

  @override
  String get inaccuracy => '失准';

  @override
  String get moveTimes => '走棋时间';

  @override
  String get flipBoard => '翻转棋盘';

  @override
  String get threefoldRepetition => '三次重复局面';

  @override
  String get claimADraw => '宣布和棋';

  @override
  String get offerDraw => '提出和棋';

  @override
  String get draw => '平局';

  @override
  String get drawByMutualAgreement => '双方同意和棋';

  @override
  String get fiftyMovesWithoutProgress => '无实质进展的50步';

  @override
  String get currentGames => '正在对局';

  @override
  String get viewInFullSize => '放大观看';

  @override
  String get logOut => '登出';

  @override
  String get signIn => '登录';

  @override
  String get rememberMe => '保持登录状态';

  @override
  String get youNeedAnAccountToDoThat => '请登录以完成该操作';

  @override
  String get signUp => '注册';

  @override
  String get computersAreNotAllowedToPlay => '电脑与电脑辅助棋手不允许参加对局。下棋时，请不要从国际象棋引擎、数据库或其他棋手得到帮助。另外，强烈建议你不要创建备用账户。过度使用多余的账户会导致账号被封禁。';

  @override
  String get games => '棋局';

  @override
  String get forum => '论坛';

  @override
  String xPostedInForumY(String param1, String param2) {
    return '$param1发文：$param2';
  }

  @override
  String get latestForumPosts => '最新论坛帖子';

  @override
  String get players => '棋手';

  @override
  String get friends => '棋友';

  @override
  String get discussions => '讨论组';

  @override
  String get today => '今天';

  @override
  String get yesterday => '昨天';

  @override
  String get minutesPerSide => '各方限时（分钟）';

  @override
  String get variant => '变体';

  @override
  String get variants => '变体';

  @override
  String get timeControl => '时间限制';

  @override
  String get realTime => '实时棋局';

  @override
  String get correspondence => '通讯棋';

  @override
  String get daysPerTurn => '每步允许天数';

  @override
  String get oneDay => '1天';

  @override
  String get time => '时间';

  @override
  String get rating => '等级分';

  @override
  String get ratingStats => '等级分统计';

  @override
  String get username => '用户名';

  @override
  String get usernameOrEmail => '用户名 或 邮箱';

  @override
  String get changeUsername => '更改用户名';

  @override
  String get changeUsernameNotSame => '只能更改字母大小写。例如，将“johndoe”改为“JohnDoe”。';

  @override
  String get changeUsernameDescription => '更改用户名。注意只能更改一次，之后只能更改用户名字母的大小写。';

  @override
  String get signupUsernameHint => '请务必选择一个和谐的用户名，用户名设置后无法更改，并且不合规的用户名会导致账户被封禁！';

  @override
  String get signupEmailHint => '仅用于重置密码';

  @override
  String get password => '密码';

  @override
  String get changePassword => '更改密码';

  @override
  String get changeEmail => '更改电子邮件地址';

  @override
  String get email => '电子邮箱';

  @override
  String get passwordReset => '密码重置';

  @override
  String get forgotPassword => '忘记密码？';

  @override
  String get error_weakPassword => '这个密码太常见了，而且很容易猜到。';

  @override
  String get error_namePassword => '请不要把密码设为用户名。';

  @override
  String get blankedPassword => '你在其他站点使用过相同的密码，并且这些站点已经失效。 为确保你的 Lichess 账户安全，你需要设置一个新密码。感谢你的理解。';

  @override
  String get youAreLeavingLichess => '你正在离开 Lichess';

  @override
  String get neverTypeYourPassword => '永远不要在其他网站输入你的 Lichess 密码！';

  @override
  String proceedToX(String param) {
    return '前往 $param';
  }

  @override
  String get passwordSuggestion => '不要使用他人建议的密码，他们会用此密码盗取你的账户。';

  @override
  String get emailSuggestion => '不要使用他人提供的邮箱地址，他们会用它盗取你的账户。';

  @override
  String get emailConfirmHelp => '协助邮件确认';

  @override
  String get emailConfirmNotReceived => '注册后没有收到确认邮件？';

  @override
  String get whatSignupUsername => '你用了什么用户名注册？';

  @override
  String usernameNotFound(String param) {
    return '找不到用户 $param';
  }

  @override
  String get usernameCanBeUsedForNewAccount => '你可以使用此用户名创建账户';

  @override
  String emailSent(String param) {
    return '我们已经向 $param 发送了一封电子邮件。';
  }

  @override
  String get emailCanTakeSomeTime => '可能需要一些时间才能收到。';

  @override
  String get refreshInboxAfterFiveMinutes => '稍等 5 分钟并刷新你的收件箱。';

  @override
  String get checkSpamFolder => '尝试检查你的垃圾邮件箱，它可能在那里。如果在，请将其标记为非垃圾邮件。';

  @override
  String get emailForSignupHelp => '如果还是不行，请向我们发送这封邮件：';

  @override
  String copyTextToEmail(String param) {
    return '复制上面的文本并发送到 $param';
  }

  @override
  String get waitForSignupHelp => '我们很快就会给你回复，帮助你完成注册。';

  @override
  String accountConfirmed(String param) {
    return '用户 $param 已成功注册。';
  }

  @override
  String accountCanLogin(String param) {
    return '你可以以 $param 登录了。';
  }

  @override
  String get accountConfirmationEmailNotNeeded => '你不需要确认电子邮件。';

  @override
  String accountClosed(String param) {
    return '账户 $param 已被关闭。';
  }

  @override
  String accountRegisteredWithoutEmail(String param) {
    return '账户 $param 未使用电子邮箱注册。';
  }

  @override
  String get rank => '排名';

  @override
  String rankX(String param) {
    return '排名：$param';
  }

  @override
  String get gamesPlayed => '棋局';

  @override
  String get cancel => '取消';

  @override
  String get whiteTimeOut => '白方超时';

  @override
  String get blackTimeOut => '黑方超时';

  @override
  String get drawOfferSent => '和棋请求已发送';

  @override
  String get drawOfferAccepted => '对方同意和棋';

  @override
  String get drawOfferCanceled => '和棋请求已取消';

  @override
  String get whiteOffersDraw => '白方提出和棋';

  @override
  String get blackOffersDraw => '黑方提出和棋';

  @override
  String get whiteDeclinesDraw => '白方拒绝和棋';

  @override
  String get blackDeclinesDraw => '黑方拒绝和棋';

  @override
  String get yourOpponentOffersADraw => '你的对手提出和棋';

  @override
  String get accept => '接受';

  @override
  String get decline => '拒绝';

  @override
  String get playingRightNow => '正在对局';

  @override
  String get eventInProgress => '正在进行';

  @override
  String get finished => '已结束';

  @override
  String get abortGame => '中止本局';

  @override
  String get gameAborted => '棋局已中止';

  @override
  String get standard => '标准国际象棋';

  @override
  String get customPosition => '自定义位置';

  @override
  String get unlimited => '无限时间';

  @override
  String get mode => '模式';

  @override
  String get casual => '休闲';

  @override
  String get rated => '排位';

  @override
  String get casualTournament => '休闲';

  @override
  String get ratedTournament => '排位';

  @override
  String get thisGameIsRated => '此对局是排位赛';

  @override
  String get rematch => '重赛';

  @override
  String get rematchOfferSent => '重赛请求已发送';

  @override
  String get rematchOfferAccepted => '重赛请求已接受';

  @override
  String get rematchOfferCanceled => '重赛请求已取消';

  @override
  String get rematchOfferDeclined => '重赛请求被拒绝';

  @override
  String get cancelRematchOffer => '取消重赛请求';

  @override
  String get viewRematch => '观看重赛';

  @override
  String get confirmMove => '确认步着';

  @override
  String get play => '下棋';

  @override
  String get inbox => '收件箱';

  @override
  String get chatRoom => '聊天室';

  @override
  String get loginToChat => '聊天请登录';

  @override
  String get youHaveBeenTimedOut => '你被禁言。';

  @override
  String get spectatorRoom => '观众室';

  @override
  String get composeMessage => '发消息';

  @override
  String get subject => '主题';

  @override
  String get send => '发送';

  @override
  String get incrementInSeconds => '每步加时（秒）';

  @override
  String get freeOnlineChess => '免费在线国际象棋';

  @override
  String get exportGames => '导出棋局';

  @override
  String get ratingRange => '对方等级分范围';

  @override
  String get thisAccountViolatedTos => '该账户违反了 Lichess 服务条款';

  @override
  String get openingExplorerAndTablebase => '开局浏览器和残局数据库';

  @override
  String get takeback => '悔棋';

  @override
  String get proposeATakeback => '请求悔棋';

  @override
  String get takebackPropositionSent => '悔棋请求已发送';

  @override
  String get takebackPropositionDeclined => '悔棋请求被拒绝';

  @override
  String get takebackPropositionAccepted => '同意悔棋';

  @override
  String get takebackPropositionCanceled => '悔棋请求已取消';

  @override
  String get yourOpponentProposesATakeback => '对手请求悔棋';

  @override
  String get bookmarkThisGame => '收藏此棋局';

  @override
  String get tournament => '锦标赛';

  @override
  String get tournaments => '锦标赛';

  @override
  String get tournamentPoints => '锦标赛积分';

  @override
  String get viewTournament => '观看锦标赛';

  @override
  String get backToTournament => '回到锦标赛主页';

  @override
  String get noDrawBeforeSwissLimit => '你不能在瑞士锦标赛中30步棋之前和棋。';

  @override
  String get thematic => '从常见开局开始的锦标赛';

  @override
  String yourPerfRatingIsProvisional(String param) {
    return '你的 $param 等级分是暂时的';
  }

  @override
  String yourPerfRatingIsTooHigh(String param1, String param2) {
    return '你的 $param1 等级分 ($param2) 过高';
  }

  @override
  String yourTopWeeklyPerfRatingIsTooHigh(String param1, String param2) {
    return '你本周 $param1 的最高等级分 ($param2) 过高';
  }

  @override
  String yourPerfRatingIsTooLow(String param1, String param2) {
    return '你的 $param1 等级分 ($param2) 过低';
  }

  @override
  String ratedMoreThanInPerf(String param1, String param2) {
    return '$param2 等级分不低于 $param1';
  }

  @override
  String ratedLessThanInPerf(String param1, String param2) {
    return '$param2 等级分不超过 $param1';
  }

  @override
  String mustBeInTeam(String param) {
    return '必须属于 $param 队';
  }

  @override
  String youAreNotInTeam(String param) {
    return '你不在 $param 队里';
  }

  @override
  String get backToGame => '返回棋局';

  @override
  String get siteDescription => '界面简洁的免费在线国际象棋平台。免注册，无广告，无需插件。与电脑，朋友或随机对手一起对战吧！';

  @override
  String xJoinedTeamY(String param1, String param2) {
    return '$param1加入$param2队';
  }

  @override
  String xCreatedTeamY(String param1, String param2) {
    return '$param1组建$param2队';
  }

  @override
  String get startedStreaming => '开始直播';

  @override
  String xStartedStreaming(String param) {
    return '$param 开始直播';
  }

  @override
  String get averageElo => '平均等级分';

  @override
  String get location => '所在地';

  @override
  String get filterGames => '筛选棋局';

  @override
  String get reset => '重置';

  @override
  String get apply => '应用';

  @override
  String get save => '保存';

  @override
  String get leaderboard => '排行榜';

  @override
  String get screenshotCurrentPosition => '保存当前棋盘为图片';

  @override
  String get gameAsGIF => '保存棋局为 GIF';

  @override
  String get pasteTheFenStringHere => '在此处粘贴FEN字串';

  @override
  String get pasteThePgnStringHere => '在此处粘贴PGN棋谱';

  @override
  String get orUploadPgnFile => '或者上传一个PGN文件';

  @override
  String get fromPosition => '自定义局面';

  @override
  String get continueFromHere => '从此处继续下棋';

  @override
  String get toStudy => '研讨';

  @override
  String get importGame => '导入棋局';

  @override
  String get importGameExplanation => '粘贴PGN棋谱后可重放棋局、使用电脑分析、使用对局聊天室以及获得通往本局的链接。';

  @override
  String get importGameCaveat => '变着分支将被删除。若要保存这些变着，请通过研讨导入 PGN。';

  @override
  String get importGameDataPrivacyWarning => '该PGN（用以记录棋类游戏棋谱的文件格式）可被公众访问。私人导入游戏请用研究研究';

  @override
  String get thisIsAChessCaptcha => '这是一个国际象棋验证码。';

  @override
  String get clickOnTheBoardToMakeYourMove => '点击棋盘走棋以证明你是人类。';

  @override
  String get captcha_fail => '请解决国际象棋验证码。';

  @override
  String get notACheckmate => '沒有将死';

  @override
  String get whiteCheckmatesInOneMove => '白方一步将死';

  @override
  String get blackCheckmatesInOneMove => '黑方一步将死';

  @override
  String get retry => '重试';

  @override
  String get reconnecting => '重新连接中';

  @override
  String get noNetwork => '离线';

  @override
  String get favoriteOpponents => '对战最多的对手';

  @override
  String get follow => '关注';

  @override
  String get following => '已关注';

  @override
  String get unfollow => '取消关注';

  @override
  String followX(String param) {
    return '关注 $param';
  }

  @override
  String unfollowX(String param) {
    return '取消关注 $param';
  }

  @override
  String get block => '加入黑名单';

  @override
  String get blocked => '已加入黑名单';

  @override
  String get unblock => '移出黑名单';

  @override
  String get followsYou => '关注了你';

  @override
  String xStartedFollowingY(String param1, String param2) {
    return '$param1开始关注$param2';
  }

  @override
  String get more => '更多';

  @override
  String get memberSince => '注册日期';

  @override
  String lastSeenActive(String param) {
    return '最近登录$param';
  }

  @override
  String get player => '棋手';

  @override
  String get list => '列表';

  @override
  String get graph => '图表';

  @override
  String get required => '必填项目';

  @override
  String get openTournaments => '公开锦标赛';

  @override
  String get duration => '持续时间';

  @override
  String get winner => '获胜者';

  @override
  String get standing => '名次';

  @override
  String get createANewTournament => '建立新的锦标赛';

  @override
  String get tournamentCalendar => '锦标赛日程表';

  @override
  String get conditionOfEntry => '参赛条件：';

  @override
  String get advancedSettings => '高级设置';

  @override
  String get safeTournamentName => '为锦标赛提出一个无争议的名称。';

  @override
  String get inappropriateNameWarning => '即使只有一点点违规的内容都可能导致你的账户被封禁。';

  @override
  String get emptyTournamentName => '若留空，将会随机选择一位著名的大师的名字作为锦标赛名称。';

  @override
  String get makePrivateTournament => '设置比赛私有，并用密码限制访问';

  @override
  String get join => '参与锦标赛';

  @override
  String get withdraw => '退出锦标赛';

  @override
  String get points => '分数';

  @override
  String get wins => '胜';

  @override
  String get losses => '负';

  @override
  String get createdBy => '创建者:';

  @override
  String get tournamentIsStarting => '锦标赛已开始';

  @override
  String get tournamentPairingsAreNowClosed => '本锦标赛已不再产生新的对局';

  @override
  String standByX(String param) {
    return '$param 做好准备，你马上就要开始对局了！';
  }

  @override
  String get pause => '暂停';

  @override
  String get resume => '继续';

  @override
  String get youArePlaying => '你已加入锦标赛！';

  @override
  String get winRate => '胜率';

  @override
  String get berserkRate => '快棋率';

  @override
  String get performance => '表现评分';

  @override
  String get tournamentComplete => '锦标赛结束';

  @override
  String get movesPlayed => '步数';

  @override
  String get whiteWins => '白方胜率';

  @override
  String get blackWins => '黑方胜率';

  @override
  String get drawRate => '平局率';

  @override
  String get draws => '和棋';

  @override
  String nextXTournament(String param) {
    return '下一个 $param 锦标赛：';
  }

  @override
  String get averageOpponent => '对手平均等级分';

  @override
  String get boardEditor => '棋盘编辑器';

  @override
  String get setTheBoard => '摆棋';

  @override
  String get popularOpenings => '常见开局';

  @override
  String get endgamePositions => '残局局面';

  @override
  String chess960StartPosition(String param) {
    return 'Chess960 起始局面： $param';
  }

  @override
  String get startPosition => '起始局面';

  @override
  String get clearBoard => '清空棋盘';

  @override
  String get loadPosition => '载入局面';

  @override
  String get isPrivate => '私人锦标赛';

  @override
  String reportXToModerators(String param) {
    return '举报$param';
  }

  @override
  String profileCompletion(String param) {
    return '资料完成度：$param';
  }

  @override
  String xRating(String param) {
    return '$param等级分';
  }

  @override
  String get ifNoneLeaveEmpty => '如果没有，请留空';

  @override
  String get profile => '个人资料';

  @override
  String get editProfile => '编辑个人资料';

  @override
  String get realName => '真名';

  @override
  String get setFlair => '设置你的图标';

  @override
  String get flair => '头像';

  @override
  String get youCanHideFlair => '有一个设置可以隐藏整个站点上的所有用户图标。';

  @override
  String get biography => '个人简介';

  @override
  String get countryRegion => '国家或地区';

  @override
  String get thankYou => '致谢！';

  @override
  String get socialMediaLinks => '社交媒体链接';

  @override
  String get oneUrlPerLine => '每行一个URL。';

  @override
  String get inlineNotation => '紧凑显示棋谱';

  @override
  String get makeAStudy => '如果要保管和分享，请考虑创建一项研讨。';

  @override
  String get clearSavedMoves => '清除着法储存';

  @override
  String get previouslyOnLichessTV => '过去的 Lichess TV';

  @override
  String get onlinePlayers => '在线棋手';

  @override
  String get activePlayers => '活跃棋手';

  @override
  String get bewareTheGameIsRatedButHasNoClock => '注意，此对局是排位赛，但是不计时！';

  @override
  String get success => '操作成功';

  @override
  String get automaticallyProceedToNextGameAfterMoving => '走棋后自动进入下一盘棋';

  @override
  String get autoSwitch => '自动切换';

  @override
  String get puzzles => '谜题';

  @override
  String get onlineBots => '在线机器人';

  @override
  String get name => '名称';

  @override
  String get description => '描述';

  @override
  String get descPrivate => '内部简介';

  @override
  String get descPrivateHelp => '仅团队成员可见，设置后将覆盖公开简介为团队成员展示。';

  @override
  String get no => '否';

  @override
  String get yes => '是';

  @override
  String get help => '帮助：';

  @override
  String get createANewTopic => '新话题';

  @override
  String get topics => '话题';

  @override
  String get posts => '帖子';

  @override
  String get lastPost => '最后一帖';

  @override
  String get views => '浏览';

  @override
  String get replies => '回复';

  @override
  String get replyToThisTopic => '回复';

  @override
  String get reply => '回复';

  @override
  String get message => '信息';

  @override
  String get createTheTopic => '创建话题';

  @override
  String get reportAUser => '举报用户';

  @override
  String get user => '用户';

  @override
  String get reason => '原因';

  @override
  String get whatIsIheMatter => '举报原因？';

  @override
  String get cheat => '作弊';

  @override
  String get troll => '捣乱';

  @override
  String get other => '其他';

  @override
  String get reportDescriptionHelp => '请附上棋局链接解释该用户的行为问题。例如如果你怀疑某用户作弊，请不要只说 “对手作弊”。请解释为什么你认为对手作弊。如果你用英语举报，我们将会更快作出答复。';

  @override
  String get error_provideOneCheatedGameLink => '请提供至少一局作弊的棋局的链接。';

  @override
  String by(String param) {
    return '来自$param';
  }

  @override
  String importedByX(String param) {
    return '由 $param 导入';
  }

  @override
  String get thisTopicIsNowClosed => '本话题已关闭。';

  @override
  String get blog => '博客';

  @override
  String get notes => '备注';

  @override
  String get typePrivateNotesHere => '输入关于该用户的个人备注';

  @override
  String get writeAPrivateNoteAboutThisUser => '备注用户信息';

  @override
  String get noNoteYet => '暂无笔记';

  @override
  String get invalidUsernameOrPassword => '用户名或密码错误';

  @override
  String get incorrectPassword => '密码错误';

  @override
  String get invalidAuthenticationCode => '无效的验证码';

  @override
  String get emailMeALink => '通过电子邮件给我发送链接';

  @override
  String get currentPassword => '当前密码';

  @override
  String get newPassword => '新密码';

  @override
  String get newPasswordAgain => '重复新密码';

  @override
  String get newPasswordsDontMatch => '两次输入的新密码不一致';

  @override
  String get newPasswordStrength => '密码强度';

  @override
  String get clockInitialTime => '起始时限';

  @override
  String get clockIncrement => '加秒';

  @override
  String get privacy => '隐私';

  @override
  String get privacyPolicy => '隐私政策';

  @override
  String get letOtherPlayersFollowYou => '允许其他用户关注';

  @override
  String get letOtherPlayersChallengeYou => '允许其他玩家挑战';

  @override
  String get letOtherPlayersInviteYouToStudy => '允许其他用户邀请你参加研讨';

  @override
  String get sound => '声音';

  @override
  String get none => '无';

  @override
  String get fast => '快';

  @override
  String get normal => '普通';

  @override
  String get slow => '慢';

  @override
  String get insideTheBoard => '棋盘内';

  @override
  String get outsideTheBoard => '棋盘外';

  @override
  String get allSquaresOfTheBoard => 'All squares of the board';

  @override
  String get onSlowGames => '在慢棋时';

  @override
  String get always => '总是';

  @override
  String get never => '从不';

  @override
  String xCompetesInY(String param1, String param2) {
    return '$param1参加$param2';
  }

  @override
  String get victory => '获胜';

  @override
  String get defeat => '负败';

  @override
  String victoryVsYInZ(String param1, String param2, String param3) {
    return '$param1，与 $param2 进行的 $param3';
  }

  @override
  String defeatVsYInZ(String param1, String param2, String param3) {
    return '$param1，与 $param2 进行的 $param3';
  }

  @override
  String drawVsYInZ(String param1, String param2, String param3) {
    return '$param1，与 $param2 进行的 $param3';
  }

  @override
  String get timeline => '时间线';

  @override
  String get starting => '开始时间：';

  @override
  String get allInformationIsPublicAndOptional => '所有资料是公开且可选填的。';

  @override
  String get biographyDescription => '说说你自己，你的兴趣，你喜欢的开局，棋局，棋手...';

  @override
  String get listBlockedPlayers => '显示黑名单';

  @override
  String get human => '人类';

  @override
  String get computer => '电脑';

  @override
  String get side => '方';

  @override
  String get clock => '时钟';

  @override
  String get opponent => '对手';

  @override
  String get learnMenu => '学棋';

  @override
  String get studyMenu => '研讨';

  @override
  String get practice => '练习';

  @override
  String get community => '社区';

  @override
  String get tools => '工具';

  @override
  String get increment => '每步加秒';

  @override
  String get error_unknown => '无效值';

  @override
  String get error_required => '本项必填';

  @override
  String get error_email => '该电子邮件地址无效';

  @override
  String get error_email_acceptable => '该电子邮件地址是不可用。请重新检查后重试。';

  @override
  String get error_email_unique => '电子邮件地址无效或已被使用';

  @override
  String get error_email_different => '这已经是您的电子邮件地址';

  @override
  String error_minLength(String param) {
    return '最少 $param 个字符';
  }

  @override
  String error_maxLength(String param) {
    return '最长 $param 个字符';
  }

  @override
  String error_min(String param) {
    return '最少不小于 $param';
  }

  @override
  String error_max(String param) {
    return '最大不能超过 $param';
  }

  @override
  String ifRatingIsPlusMinusX(String param) {
    return '允许等级分范围±$param';
  }

  @override
  String get ifRegistered => '如已注册';

  @override
  String get onlyExistingConversations => '仅现有的对话';

  @override
  String get onlyFriends => '仅好友';

  @override
  String get menu => '菜单';

  @override
  String get castling => '王车易位';

  @override
  String get whiteCastlingKingside => '白方 O-O';

  @override
  String get blackCastlingKingside => '黑方 O-O';

  @override
  String tpTimeSpentPlaying(String param) {
    return '花在下棋上的时间：$param';
  }

  @override
  String get watchGames => '观看对局';

  @override
  String tpTimeSpentOnTV(String param) {
    return '在 Lichess TV 出现的时长：$param';
  }

  @override
  String get watch => '观看';

  @override
  String get videoLibrary => '视频库';

  @override
  String get streamersMenu => '主播';

  @override
  String get mobileApp => '手机APP';

  @override
  String get webmasters => '网站管理员';

  @override
  String get about => '关于';

  @override
  String aboutX(String param) {
    return '关于 $param';
  }

  @override
  String xIsAFreeYLibreOpenSourceChessServer(String param1, String param2) {
    return '$param1 是一个免费 ($param2)，自由，无广告的开源国际象棋服务器。';
  }

  @override
  String get really => '真的';

  @override
  String get contribute => '协助我们';

  @override
  String get termsOfService => '服务条款';

  @override
  String get sourceCode => '源代码';

  @override
  String get simultaneousExhibitions => '车轮战';

  @override
  String get host => '主持者';

  @override
  String hostColorX(String param) {
    return '主持颜色：$param';
  }

  @override
  String get yourPendingSimuls => '您待办的车轮战';

  @override
  String get createdSimuls => '最近创建的车轮战';

  @override
  String get hostANewSimul => '主持新车轮战';

  @override
  String get signUpToHostOrJoinASimul => '报名主持或参加车轮战';

  @override
  String get noSimulFound => '找不到车轮战';

  @override
  String get noSimulExplanation => '该车轮战不存在。';

  @override
  String get returnToSimulHomepage => '返回车轮战主页';

  @override
  String get aboutSimul => '车轮战涉及到一个人同时和几位棋手下棋。';

  @override
  String get aboutSimulImage => '菲舍尔同时挑战50个对手，胜47局，和2局，负1局。';

  @override
  String get aboutSimulRealLife => '这个概念来自真实的国际比赛。在现实中，这涉及到车轮战主持在桌与桌之间来回穿梭走棋。';

  @override
  String get aboutSimulRules => '当车轮战开始时， 每个棋手都与主持开始下棋， 而主持用白方。当所有的对局都结束时，车轮战就结束了。';

  @override
  String get aboutSimulSettings => '车轮战都是休闲对局。重赛、悔棋和加时功能被禁用。';

  @override
  String get create => '创建';

  @override
  String get whenCreateSimul => '当你创建一个车轮战时，你要一次同时跟几个棋手一起下棋。';

  @override
  String get simulVariantsHint => '如果你选择几种变体，每个棋手都能选择其中之一。';

  @override
  String get simulClockHint => '菲舍尔时钟设置。挑战者越多，你所需时间就可能相应越多。';

  @override
  String get simulAddExtraTime => '你可以为自己附加时间应对车轮战。';

  @override
  String get simulHostExtraTime => '主持的额外时间';

  @override
  String get simulAddExtraTimePerPlayer => '每有一个玩家加入车轮战，您棋钟的初始时间都将增加。';

  @override
  String get simulHostExtraTimePerPlayer => '每个玩家加入后棋钟增加的额外时间';

  @override
  String get lichessTournaments => 'Lichess 锦标赛';

  @override
  String get tournamentFAQ => '锦标赛常见问题';

  @override
  String get timeBeforeTournamentStarts => '距比赛开始时间';

  @override
  String get averageCentipawnLoss => '平均厘兵损失';

  @override
  String get accuracy => '准确度';

  @override
  String get keyboardShortcuts => '快捷键';

  @override
  String get keyMoveBackwardOrForward => '后退/前进';

  @override
  String get keyGoToStartOrEnd => '跳到开始/结束';

  @override
  String get keyCycleSelectedVariation => '选择变着';

  @override
  String get keyShowOrHideComments => '显示／隐藏评论';

  @override
  String get keyEnterOrExitVariation => '进入或退出变着';

  @override
  String get keyRequestComputerAnalysis => '请求电脑分析，并从你的失误中学习';

  @override
  String get keyNextLearnFromYourMistakes => '下一个 (从你的失误中学习)';

  @override
  String get keyNextBlunder => '下一个漏着';

  @override
  String get keyNextMistake => '下一个错着';

  @override
  String get keyNextInaccuracy => '下一个失准着';

  @override
  String get keyPreviousBranch => '上一个分支';

  @override
  String get keyNextBranch => '下一个分行';

  @override
  String get toggleVariationArrows => '开启变着箭头';

  @override
  String get cyclePreviousOrNextVariation => '切换上一个或下一个变着';

  @override
  String get toggleGlyphAnnotations => '开启着法注释';

  @override
  String get togglePositionAnnotations => '开启局面注释';

  @override
  String get variationArrowsInfo => '变着箭头让你不需要棋步列表也能浏览';

  @override
  String get playSelectedMove => '走已选的棋步';

  @override
  String get newTournament => '新锦标赛';

  @override
  String get tournamentHomeTitle => '国际象棋锦标赛均设有不同的时间限制和变体';

  @override
  String get tournamentHomeDescription => '参加快节奏的国际象棋锦标赛！欢迎参与 Lichess 官方的锦标赛，或创建自己的锦标赛。子弹超快棋，闪电超快棋，经典，菲舍尔任意制，王居中，三次将军，并提供更多的选择给你带来无尽的国际象棋乐趣。';

  @override
  String get tournamentNotFound => '找不到该锦标赛';

  @override
  String get tournamentDoesNotExist => '该锦标赛已不存在。';

  @override
  String get tournamentMayHaveBeenCanceled => '该锦标赛可能已被取消，假如所有的选手在比赛开始之前退赛。';

  @override
  String get returnToTournamentsHomepage => '返回锦标赛主页';

  @override
  String weeklyPerfTypeRatingDistribution(String param) {
    return '本月$param的等级分分布';
  }

  @override
  String yourPerfTypeRatingIsRating(String param1, String param2) {
    return '你的 $param1 等级分是 $param2。';
  }

  @override
  String youAreBetterThanPercentOfPerfTypePlayers(String param1, String param2) {
    return '你强于 $param1 的 $param2 棋手。';
  }

  @override
  String userIsBetterThanPercentOfPerfTypePlayers(String param1, String param2, String param3) {
    return '$param1比$param2的$param3棋手强';
  }

  @override
  String betterThanPercentPlayers(String param1, String param2) {
    return '比$param1的$param2棋手更强';
  }

  @override
  String youDoNotHaveAnEstablishedPerfTypeRating(String param) {
    return '你没有足够准确的 $param 等级分。';
  }

  @override
  String get yourRating => '你的等级分';

  @override
  String get cumulative => '累计';

  @override
  String get glicko2Rating => 'Glicko-2 等级分';

  @override
  String get checkYourEmail => '请查看你的电子邮件';

  @override
  String get weHaveSentYouAnEmailClickTheLink => '一封电子邮件已发送到你的邮箱。请点击邮件中的链接以激活你的账户。';

  @override
  String get ifYouDoNotSeeTheEmailCheckOtherPlaces => '如果你没有收到我们的邮件，请检查其他收件箱，例如垃圾箱，广告箱等。';

  @override
  String weHaveSentYouAnEmailTo(String param) {
    return '我们给你的邮箱 $param 发了重置密码的链接。请点击链接来重置你的密码。';
  }

  @override
  String byRegisteringYouAgreeToBeBoundByOur(String param) {
    return '注册代表你同意我们的 $param 。';
  }

  @override
  String readAboutOur(String param) {
    return '阅读我们的 $param';
  }

  @override
  String get networkLagBetweenYouAndLichess => '你和 Lichess 之间的网络延迟';

  @override
  String get timeToProcessAMoveOnLichessServer => 'Lichess 服务器上处理一步的时间';

  @override
  String get downloadAnnotated => '下载有注释的 PGN';

  @override
  String get downloadRaw => '下载无注释的PGN';

  @override
  String get downloadImported => '下载导入的棋局';

  @override
  String get crosstable => '比分表';

  @override
  String get youCanAlsoScrollOverTheBoardToMoveInTheGame => '你也可以用鼠标滚轮浏览棋局。';

  @override
  String get scrollOverComputerVariationsToPreviewThem => '移到电脑给出的变着上进行预览';

  @override
  String get analysisShapesHowTo => '按shift+左键单击或右键单击在棋盘上绘制圆圈和箭头。';

  @override
  String get letOtherPlayersMessageYou => '允许其他人给您发私信';

  @override
  String get receiveForumNotifications => '在论坛中被提及时接收通知';

  @override
  String get shareYourInsightsData => '分享你的对局洞察';

  @override
  String get withNobody => '不分享';

  @override
  String get withFriends => '和朋友分享';

  @override
  String get withEverybody => '和每个人分享';

  @override
  String get kidMode => '儿童模式';

  @override
  String get kidModeIsEnabled => '儿童模式已启用';

  @override
  String get kidModeExplanation => '安全第一。在儿童模式下，站内信无法使用。为了保护你的孩子和学生免受其他用户伤害，请启用儿童模式。';

  @override
  String inKidModeTheLichessLogoGetsIconX(String param) {
    return '在儿童模式下，Lichess 标志前会有 $param 图标。出现该图标你就知道你的孩子是安全的。';
  }

  @override
  String get askYourChessTeacherAboutLiftingKidMode => '你的账户处于托管中，可以让你的老师解除儿童模式。';

  @override
  String get enableKidMode => '打开儿童模式';

  @override
  String get disableKidMode => '关闭儿童模式';

  @override
  String get security => '安全';

  @override
  String get sessions => '会话';

  @override
  String get revokeAllSessions => '注销所有会话';

  @override
  String get playChessEverywhere => '在任何地方下棋！';

  @override
  String get asFreeAsLichess => 'Lichess 永远免费';

  @override
  String get builtForTheLoveOfChessNotMoney => '不是为了钱，而是因为对国际象棋的热爱而创建的';

  @override
  String get everybodyGetsAllFeaturesForFree => '每个人都可以免费使用所有功能';

  @override
  String get zeroAdvertisement => '没有广告';

  @override
  String get fullFeatured => '功能全面';

  @override
  String get phoneAndTablet => '手机和平板电脑';

  @override
  String get bulletBlitzClassical => '快棋与慢棋';

  @override
  String get correspondenceChess => '非即时比赛';

  @override
  String get onlineAndOfflinePlay => '在线和离线下棋';

  @override
  String get viewTheSolution => '看解答';

  @override
  String get followAndChallengeFriends => '关注并挑战朋友';

  @override
  String get gameAnalysis => '棋局分析';

  @override
  String xHostsY(String param1, String param2) {
    return '$param1 主持 $param2';
  }

  @override
  String xJoinsY(String param1, String param2) {
    return '$param1 参加 $param2';
  }

  @override
  String xLikesY(String param1, String param2) {
    return '$param1点赞$param2';
  }

  @override
  String get quickPairing => '快速匹配';

  @override
  String get lobby => '大厅';

  @override
  String get anonymous => '匿名';

  @override
  String yourScore(String param) {
    return '你的分数：$param';
  }

  @override
  String get language => '语言';

  @override
  String get background => '背景';

  @override
  String get light => '浅色';

  @override
  String get dark => '深色';

  @override
  String get transparent => '透明';

  @override
  String get deviceTheme => '设备主题';

  @override
  String get backgroundImageUrl => '背景图片网址：';

  @override
  String get board => '棋盘';

  @override
  String get size => '大小';

  @override
  String get opacity => '不透明度';

  @override
  String get brightness => '亮度';

  @override
  String get hue => '色调';

  @override
  String get boardReset => '重置颜色设置';

  @override
  String get pieceSet => '棋子设定';

  @override
  String get embedInYourWebsite => '嵌入到你的网站上';

  @override
  String get usernameAlreadyUsed => '该用户名已被使用，请使用另一个。';

  @override
  String get usernamePrefixInvalid => '用户名必须以字母开头。';

  @override
  String get usernameSuffixInvalid => '用户名必须以字母或数字结尾。';

  @override
  String get usernameCharsInvalid => '用户名必须只包含字母、数字、下划线和连字符。';

  @override
  String get usernameUnacceptable => '该用户名不被接受。';

  @override
  String get playChessInStyle => '有型地下棋';

  @override
  String get chessBasics => '基础知识';

  @override
  String get coaches => '教练';

  @override
  String get invalidPgn => 'PGN无法识别';

  @override
  String get invalidFen => 'FEN无法识别';

  @override
  String get custom => '自定义';

  @override
  String get notifications => '通知';

  @override
  String notificationsX(String param1) {
    return '通知: $param1';
  }

  @override
  String perfRatingX(String param) {
    return '等级分：$param';
  }

  @override
  String get practiceWithComputer => '与电脑练习';

  @override
  String anotherWasX(String param) {
    return '$param也不错';
  }

  @override
  String bestWasX(String param) {
    return '最佳着是 $param';
  }

  @override
  String get youBrowsedAway => '你浏览到别处了';

  @override
  String get resumePractice => '继续练习';

  @override
  String get drawByFiftyMoves => '对局因50步规则判和。';

  @override
  String get theGameIsADraw => '本局和棋。';

  @override
  String get computerThinking => '电脑正在思考...';

  @override
  String get seeBestMove => '查看最佳着法';

  @override
  String get hideBestMove => '隐藏最佳着法';

  @override
  String get getAHint => '提示';

  @override
  String get evaluatingYourMove => '评估着法中';

  @override
  String get whiteWinsGame => '白方胜';

  @override
  String get blackWinsGame => '黑方胜';

  @override
  String get learnFromYourMistakes => '从你的失误中学习';

  @override
  String get learnFromThisMistake => '从这个失误中学习';

  @override
  String get skipThisMove => '跳过此步';

  @override
  String get next => '继续';

  @override
  String xWasPlayed(String param) {
    return '走了$param';
  }

  @override
  String get findBetterMoveForWhite => '为白方找更好走法';

  @override
  String get findBetterMoveForBlack => '为黑方找更好走法';

  @override
  String get resumeLearning => '继续学习';

  @override
  String get youCanDoBetter => '加油！有更好的一步棋！';

  @override
  String get tryAnotherMoveForWhite => '为白方另找走法';

  @override
  String get tryAnotherMoveForBlack => '为黑方另找走法';

  @override
  String get solution => '解法';

  @override
  String get waitingForAnalysis => '正在等待分析';

  @override
  String get noMistakesFoundForWhite => '未找到白方失误';

  @override
  String get noMistakesFoundForBlack => '未找到黑方失误';

  @override
  String get doneReviewingWhiteMistakes => '白方失误回顾完毕';

  @override
  String get doneReviewingBlackMistakes => '黑方失误回顾完毕';

  @override
  String get doItAgain => '再来一次';

  @override
  String get reviewWhiteMistakes => '回顾白方失误';

  @override
  String get reviewBlackMistakes => '回顾黑方失误';

  @override
  String get advantage => '优势';

  @override
  String get opening => '开局';

  @override
  String get middlegame => '中盘';

  @override
  String get endgame => '残局';

  @override
  String get conditionalPremoves => '条件预先走棋';

  @override
  String get addCurrentVariation => '添加当前变着';

  @override
  String get playVariationToCreateConditionalPremoves => '走一步变着以创建条件预先走棋';

  @override
  String get noConditionalPremoves => '没有条件预先走棋';

  @override
  String playX(String param) {
    return '走 $param';
  }

  @override
  String get showUnreadLichessMessage => '您收到了一条来自Lichess的私人信息';

  @override
  String get clickHereToReadIt => '点此阅读';

  @override
  String get sorry => '抱歉 :(';

  @override
  String get weHadToTimeYouOutForAWhile => '我们必须将你停止一段时间。';

  @override
  String get why => '为什么？';

  @override
  String get pleasantChessExperience => '我们致力于为所有人提供一个愉悦的下棋体验。';

  @override
  String get goodPractice => '因此，我们必须确保每个玩家都要遵循规范。';

  @override
  String get potentialProblem => '我们会在检测到潜在问题时显示本信息。';

  @override
  String get howToAvoidThis => '如何避免这种情况？';

  @override
  String get playEveryGame => '认真下完每一盘棋。';

  @override
  String get tryToWin => '竭尽全力去赢得（或至少平局）每一场棋局。';

  @override
  String get resignLostGames => '投降输掉的比赛（不要浪费他人时间 ）。';

  @override
  String get temporaryInconvenience => '对于你临时的不便，我们深表歉意，';

  @override
  String get wishYouGreatGames => '并期待你在 lichess.org 上展露风采。';

  @override
  String get thankYouForReading => '感谢你的阅读！';

  @override
  String get lifetimeScore => '生涯得分';

  @override
  String get currentMatchScore => '当前比赛分数';

  @override
  String get agreementAssistance => '本人在游戏进行中不会接受任何帮助（包括来自电脑程序、书籍、残局库或其他人）。';

  @override
  String get agreementNice => '本人将尊重所有棋手。';

  @override
  String agreementMultipleAccounts(String param) {
    return '我同意我不会创建多个账号（除非是 $param 中允许的情况）。';
  }

  @override
  String get agreementPolicy => '本人将遵守所有 Lichess 规范。';

  @override
  String get searchOrStartNewDiscussion => '搜索或开始新对话';

  @override
  String get edit => '编辑';

  @override
  String get bullet => '超超快棋';

  @override
  String get blitz => '超快棋';

  @override
  String get rapid => '快棋';

  @override
  String get classical => '慢棋';

  @override
  String get ultraBulletDesc => '急速对战：少于 30 秒';

  @override
  String get bulletDesc => '高速对战：少于 3 分钟';

  @override
  String get blitzDesc => '快速对战：3 到 8 分钟';

  @override
  String get rapidDesc => '普速对战：8 到 25 分钟';

  @override
  String get classicalDesc => '经典对战：25 分钟及以上';

  @override
  String get correspondenceDesc => '非即时对战：每步一天或数天';

  @override
  String get puzzleDesc => '国际象棋战术训练';

  @override
  String get important => '重要';

  @override
  String yourQuestionMayHaveBeenAnswered(String param1) {
    return '你的问题可能已经$param1有了答案';
  }

  @override
  String get inTheFAQ => '在常见问题中';

  @override
  String toReportSomeoneForCheatingOrBadBehavior(String param1) {
    return '要举报用户作弊或不良行为，$param1';
  }

  @override
  String get useTheReportForm => '请使用举报表单';

  @override
  String toRequestSupport(String param1) {
    return '要请求支持，$param1';
  }

  @override
  String get tryTheContactPage => '请尝试使用联系页面';

  @override
  String makeSureToRead(String param1) {
    return '请确保你已阅读 $param1';
  }

  @override
  String get theForumEtiquette => '论坛礼仪';

  @override
  String get thisTopicIsArchived => '此话题已被存档且不能再回复。';

  @override
  String joinTheTeamXToPost(String param1) {
    return '加入$param1，以在此论坛发表意见';
  }

  @override
  String teamNamedX(String param1) {
    return '$param1 团队';
  }

  @override
  String get youCannotPostYetPlaySomeGames => '你还不能在论坛发表意见。再下几盘棋吧！';

  @override
  String get subscribe => '订阅';

  @override
  String get unsubscribe => '取消订阅';

  @override
  String mentionedYouInX(String param1) {
    return '在 “$param1” 中提到了你。';
  }

  @override
  String xMentionedYouInY(String param1, String param2) {
    return '$param1 在 \"$param2\" 中提到了你。';
  }

  @override
  String invitedYouToX(String param1) {
    return '邀请你加入\"$param1\"。';
  }

  @override
  String xInvitedYouToY(String param1, String param2) {
    return '$param1 邀请你加入 \"$param2\"。';
  }

  @override
  String get youAreNowPartOfTeam => '你现在是团队的成员。';

  @override
  String youHaveJoinedTeamX(String param1) {
    return '你已加入\"$param1\"。';
  }

  @override
  String get someoneYouReportedWasBanned => '你举报的用户已被封禁';

  @override
  String get congratsYouWon => '恭喜恭喜，你获胜了！';

  @override
  String gameVsX(String param1) {
    return '与 $param1 对局';
  }

  @override
  String resVsX(String param1, String param2) {
    return '$param1 vs $param2';
  }

  @override
  String get lostAgainstTOSViolator => '你输给了违反 Lichess 服务条款的用户';

  @override
  String refundXpointsTimeControlY(String param1, String param2) {
    return '退回了$param2 $param1 的等级分';
  }

  @override
  String get timeAlmostUp => '时间快到了！';

  @override
  String get clickToRevealEmailAddress => '[点击显示电子邮件地址]';

  @override
  String get download => '下载';

  @override
  String get coachManager => '教练管理';

  @override
  String get streamerManager => '直播管理';

  @override
  String get cancelTournament => '取消锦标赛';

  @override
  String get tournDescription => '锦标赛描述';

  @override
  String get tournDescriptionHelp => '你还有其他信息要告诉参赛者们吗？请不要写太多。可以使用Markdown来写链接：[文字](https://url)';

  @override
  String get ratedFormHelp => '排位赛\n将影响玩家的等级分';

  @override
  String get onlyMembersOfTeam => '仅团队成员';

  @override
  String get noRestriction => '无限制';

  @override
  String get minimumRatedGames => '最少排位赛局数';

  @override
  String get minimumRating => '最低等级分';

  @override
  String get maximumWeeklyRating => '本周最高等级分';

  @override
  String positionInputHelp(String param) {
    return '将一个有效的 FEN 粘贴于此作为所有对局的起始位置。\n仅适用于标准国际象棋，对变体无效。\n你可以试用 $param 来生成 FEN，然后将其粘贴到这里。\n置空表示以标准位置开始比赛。';
  }

  @override
  String get cancelSimul => '取消车轮战';

  @override
  String get simulHostcolor => '主持所执方';

  @override
  String get estimatedStart => '预计开始时间';

  @override
  String simulFeatured(String param) {
    return '展示在 $param';
  }

  @override
  String simulFeaturedHelp(String param) {
    return '在 $param 上向所有人展示你主持的车轮战，对私人车轮战无效。';
  }

  @override
  String get simulDescription => '车轮战描述';

  @override
  String get simulDescriptionHelp => '写下你想要告诉参与者的任何内容';

  @override
  String markdownAvailable(String param) {
    return '$param 可用于更高级的格式。';
  }

  @override
  String get embedsAvailable => '粘贴对局URL或学习章节URL来嵌入。';

  @override
  String get inYourLocalTimezone => '在你的本地时区';

  @override
  String get tournChat => '比赛聊天';

  @override
  String get noChat => '关闭聊天';

  @override
  String get onlyTeamLeaders => '仅限队长';

  @override
  String get onlyTeamMembers => '仅限队员';

  @override
  String get navigateMoveTree => '定位';

  @override
  String get mouseTricks => '鼠标使用技巧';

  @override
  String get toggleLocalAnalysis => '使用本地分析';

  @override
  String get toggleAllAnalysis => '使用本地+服务器分析';

  @override
  String get playComputerMove => '走电脑推荐的最佳招';

  @override
  String get analysisOptions => '分析选项';

  @override
  String get focusChat => '聚焦聊天';

  @override
  String get showHelpDialog => '显示此帮助对话框';

  @override
  String get reopenYourAccount => '恢复你的账户';

  @override
  String get closedAccountChangedMind => '如果你关闭了账户，但此后又改变了主意，你可以获得一次恢复账户的机会。';

  @override
  String get onlyWorksOnce => '账户关闭后只能恢复一次';

  @override
  String get cantDoThisTwice => '如果你第二次关闭账户，将无法恢复。';

  @override
  String get emailAssociatedToaccount => '与账户关联的电子邮件地址';

  @override
  String get sentEmailWithLink => '我们已经向你发送了一封带有链接的电子邮件。';

  @override
  String get tournamentEntryCode => '比赛入场码';

  @override
  String get hangOn => '等等！';

  @override
  String gameInProgress(String param) {
    return '你正在与 $param 进行对局。';
  }

  @override
  String get abortTheGame => '中止本局';

  @override
  String get resignTheGame => '认输';

  @override
  String get youCantStartNewGame => '在本局结束前，你不能开始新的对局。';

  @override
  String get since => '自';

  @override
  String get until => '直到';

  @override
  String get lichessDbExplanation => '来自 Lichess 的排位对局';

  @override
  String get switchSides => '更换所持颜色';

  @override
  String get closingAccountWithdrawAppeal => '关闭账户将撤回你的上诉';

  @override
  String get ourEventTips => '举办赛事的小建议';

  @override
  String get instructions => '说明';

  @override
  String get showMeEverything => '全部展示';

  @override
  String get lichessPatronInfo => 'Lichess 是一个非盈利、完全免费自由的开源软件。所有的运维成本、开发以及内容完全来自用户捐赠。';

  @override
  String get nothingToSeeHere => '此刻没有什么可看的。';

  @override
  String opponentLeftCounter(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '您的对手已离开棋局。您可以在 $count 秒后宣布胜利。',
    );
    return '$_temp0';
  }

  @override
  String mateInXHalfMoves(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '离将死剩$count着',
    );
    return '$_temp0';
  }

  @override
  String nbBlunders(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 次漏着',
    );
    return '$_temp0';
  }

  @override
  String nbMistakes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 次错着',
    );
    return '$_temp0';
  }

  @override
  String nbInaccuracies(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 次失准',
    );
    return '$_temp0';
  }

  @override
  String nbPlayers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 位在线棋手',
    );
    return '$_temp0';
  }

  @override
  String nbGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '查看所有$count个对局',
    );
    return '$_temp0';
  }

  @override
  String ratingXOverYGames(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$param2 场对局后的 $count 等级分',
    );
    return '$_temp0';
  }

  @override
  String nbBookmarks(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count收藏',
    );
    return '$_temp0';
  }

  @override
  String nbDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 天',
    );
    return '$_temp0';
  }

  @override
  String nbHours(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 个小时',
    );
    return '$_temp0';
  }

  @override
  String nbMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 分钟',
    );
    return '$_temp0';
  }

  @override
  String rankIsUpdatedEveryNbMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '每$count分钟更新排名',
    );
    return '$_temp0';
  }

  @override
  String nbPuzzles(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '训练题$count题',
    );
    return '$_temp0';
  }

  @override
  String nbGamesWithYou(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '与你下了$count盘棋',
    );
    return '$_temp0';
  }

  @override
  String nbRated(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 排位赛',
    );
    return '$_temp0';
  }

  @override
  String nbWins(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count胜',
    );
    return '$_temp0';
  }

  @override
  String nbLosses(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count负',
    );
    return '$_temp0';
  }

  @override
  String nbDraws(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count和',
    );
    return '$_temp0';
  }

  @override
  String nbPlaying(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 正在进行',
    );
    return '$_temp0';
  }

  @override
  String giveNbSeconds(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '添加对方$count秒',
    );
    return '$_temp0';
  }

  @override
  String nbTournamentPoints(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count锦标赛积分',
    );
    return '$_temp0';
  }

  @override
  String nbStudies(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count研讨',
    );
    return '$_temp0';
  }

  @override
  String nbSimuls(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 个进行的车轮战棋局',
    );
    return '$_temp0';
  }

  @override
  String moreThanNbRatedGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '完成至少 $count 局排位赛',
    );
    return '$_temp0';
  }

  @override
  String moreThanNbPerfRatedGames(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '完成至少 $count 局 $param2 排位赛',
    );
    return '$_temp0';
  }

  @override
  String needNbMorePerfGames(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '你需要再完成 $count 局 $param2 排位赛',
    );
    return '$_temp0';
  }

  @override
  String needNbMoreGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '你需要再完成 $count 局排位赛',
    );
    return '$_temp0';
  }

  @override
  String nbImportedGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count盘导入的棋局',
    );
    return '$_temp0';
  }

  @override
  String nbFriendsOnline(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '在线好友：$count',
    );
    return '$_temp0';
  }

  @override
  String nbFollowers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 关注者',
    );
    return '$_temp0';
  }

  @override
  String nbFollowing(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '关注$count人',
    );
    return '$_temp0';
  }

  @override
  String lessThanNbMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '小于 $count 分钟',
    );
    return '$_temp0';
  }

  @override
  String nbGamesInPlay(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 场对局进行中',
    );
    return '$_temp0';
  }

  @override
  String maximumNbCharacters(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '最多$count个字符',
    );
    return '$_temp0';
  }

  @override
  String blocks(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count位黑名单用戶',
    );
    return '$_temp0';
  }

  @override
  String nbForumPosts(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '发了$count个论坛帖子',
    );
    return '$_temp0';
  }

  @override
  String nbPerfTypePlayersThisWeek(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '本周有$count 位棋手下$param2',
    );
    return '$_temp0';
  }

  @override
  String availableInNbLanguages(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '支持$count种语言！',
    );
    return '$_temp0';
  }

  @override
  String nbSecondsToPlayTheFirstMove(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '还剩$count秒走第一步',
    );
    return '$_temp0';
  }

  @override
  String nbSeconds(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count秒',
    );
    return '$_temp0';
  }

  @override
  String andSaveNbPremoveLines(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '已保存 $count 条先前的走子',
    );
    return '$_temp0';
  }

  @override
  String get stormMoveToStart => '走一步棋以开始';

  @override
  String get stormYouPlayTheWhitePiecesInAllPuzzles => '你将在所有的谜题中执白';

  @override
  String get stormYouPlayTheBlackPiecesInAllPuzzles => '你将在所有的谜题中执黑';

  @override
  String get stormPuzzlesSolved => '谜题已解决 ！';

  @override
  String get stormNewDailyHighscore => '新的每日高分！';

  @override
  String get stormNewWeeklyHighscore => '新的每周高分！';

  @override
  String get stormNewMonthlyHighscore => '新月度高分！';

  @override
  String get stormNewAllTimeHighscore => '新的历史最高分！';

  @override
  String stormPreviousHighscoreWasX(String param) {
    return '上一次最高得分是 $param';
  }

  @override
  String get stormPlayAgain => '再玩一次';

  @override
  String stormHighscoreX(String param) {
    return '最高分： $param';
  }

  @override
  String get stormScore => '得分';

  @override
  String get stormMoves => '着法';

  @override
  String get stormAccuracy => '准确度';

  @override
  String get stormCombo => '连击';

  @override
  String get stormTime => '时间';

  @override
  String get stormTimePerMove => '平均着法时间';

  @override
  String get stormHighestSolved => '解决的最难谜题';

  @override
  String get stormPuzzlesPlayed => '玩过的谜题';

  @override
  String get stormNewRun => '开始新的一组(快捷键：空格)';

  @override
  String get stormEndRun => '结束本组(快捷键：回车)';

  @override
  String get stormHighscores => '高分榜';

  @override
  String get stormViewBestRuns => '查看最佳战绩';

  @override
  String get stormBestRunOfDay => '每日最佳战绩';

  @override
  String get stormRuns => '组数';

  @override
  String get stormGetReady => '做好准备！';

  @override
  String get stormWaitingForMorePlayers => '等待更多玩家加入...';

  @override
  String get stormRaceComplete => '竞速结束！';

  @override
  String get stormSpectating => '观战中';

  @override
  String get stormJoinTheRace => '加入竞速';

  @override
  String get stormStartTheRace => '开始比赛';

  @override
  String stormYourRankX(String param) {
    return '你的排名：$param';
  }

  @override
  String get stormWaitForRematch => '等待下一场';

  @override
  String get stormNextRace => '下一场竞速';

  @override
  String get stormJoinRematch => '再来一局';

  @override
  String get stormWaitingToStart => '等待开始';

  @override
  String get stormCreateNewGame => '创建新比赛';

  @override
  String get stormJoinPublicRace => '加入公开比赛';

  @override
  String get stormRaceYourFriends => '和好友比赛';

  @override
  String get stormSkip => '跳过';

  @override
  String get stormSkipHelp => '每场比赛仅能跳过一次';

  @override
  String get stormSkipExplanation => '跳过这一步来保留你的连击！每场比赛只能用一次';

  @override
  String get stormFailedPuzzles => '失败的谜题';

  @override
  String get stormSlowPuzzles => '慢 谜题';

  @override
  String get stormSkippedPuzzle => '跳过';

  @override
  String get stormThisWeek => '本周';

  @override
  String get stormThisMonth => '本月';

  @override
  String get stormAllTime => '全部时间';

  @override
  String get stormClickToReload => '点击重新加载';

  @override
  String get stormThisRunHasExpired => '本次冲刺已超时！';

  @override
  String get stormThisRunWasOpenedInAnotherTab => '本次冲刺已经在另一个标签页中打开！';

  @override
  String stormXRuns(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count组',
    );
    return '$_temp0';
  }

  @override
  String stormPlayedNbRunsOfPuzzleStorm(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '玩了$count组的$param2',
    );
    return '$_temp0';
  }

  @override
  String get streamerLichessStreamers => 'Lichess 主播';

  @override
  String get studyShareAndExport => '分享并导出';

  @override
  String get studyStart => '开始';
}

/// The translations for Chinese, as used in Taiwan (`zh_TW`).
class AppLocalizationsZhTw extends AppLocalizationsZh {
  AppLocalizationsZhTw(): super('zh_TW');

  @override
  String get activityActivity => '活動';

  @override
  String get activityHostedALiveStream => '主持一個現場直播';

  @override
  String activityRankedInSwissTournament(String param1, String param2) {
    return '在$param2中排名$param1';
  }

  @override
  String get activitySignedUp => '在lichess.org中註冊';

  @override
  String activitySupportedNbMonths(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '以$param2的身分支持lichess.org$count個月',
    );
    return '$_temp0';
  }

  @override
  String activityPracticedNbPositions(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '在$param2練習了$count個棋局',
    );
    return '$_temp0';
  }

  @override
  String activitySolvedNbPuzzles(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '解決了$count個戰術題目',
    );
    return '$_temp0';
  }

  @override
  String activityPlayedNbGames(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '下了$count場$param2類型的棋局',
    );
    return '$_temp0';
  }

  @override
  String activityPostedNbMessages(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '在$param2發表了$count則訊息',
    );
    return '$_temp0';
  }

  @override
  String activityPlayedNbMoves(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '下了$count步',
    );
    return '$_temp0';
  }

  @override
  String activityInNbCorrespondenceGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '在$count場長時間棋局中',
    );
    return '$_temp0';
  }

  @override
  String activityCompletedNbGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '完成了$count場長時間棋局',
    );
    return '$_temp0';
  }

  @override
  String activityFollowedNbPlayers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '開始關注$count個玩家',
    );
    return '$_temp0';
  }

  @override
  String activityGainedNbFollowers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '增加了$count個追蹤者',
    );
    return '$_temp0';
  }

  @override
  String activityHostedNbSimuls(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '主持了$count場車輪戰',
    );
    return '$_temp0';
  }

  @override
  String activityJoinedNbSimuls(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '加入了$count場車輪戰',
    );
    return '$_temp0';
  }

  @override
  String activityCreatedNbStudies(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '創造了$count個新的研究',
    );
    return '$_temp0';
  }

  @override
  String activityCompetedInNbTournaments(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '完成了$count場錦標賽',
    );
    return '$_temp0';
  }

  @override
  String activityRankedInTournament(int count, String param2, String param3, String param4) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '在$param4錦標賽中下了$param3盤棋局，排名第$count(前$param2%)',
    );
    return '$_temp0';
  }

  @override
  String activityCompetedInNbSwissTournaments(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '參與過$count\'場瑞士制錦標賽',
    );
    return '$_temp0';
  }

  @override
  String activityJoinedNbTeams(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '加入$count團隊',
    );
    return '$_temp0';
  }

  @override
  String get broadcastBroadcasts => '比賽直播';

  @override
  String get broadcastLiveBroadcasts => '錦標賽直播';

  @override
  String challengeChallengesX(String param1) {
    return '挑戰: $param1';
  }

  @override
  String get challengeChallengeToPlay => '邀請對弈';

  @override
  String get challengeChallengeDeclined => '對弈邀請已拒絕';

  @override
  String get challengeChallengeAccepted => '對弈邀請已接受';

  @override
  String get challengeChallengeCanceled => '對弈邀請已撤銷';

  @override
  String get challengeRegisterToSendChallenges => '請登入以向其他人發出對弈邀請';

  @override
  String challengeYouCannotChallengeX(String param) {
    return '你無法向$param發出對弈邀請';
  }

  @override
  String challengeXDoesNotAcceptChallenges(String param) {
    return '$param沒有接受對弈邀請';
  }

  @override
  String challengeYourXRatingIsTooFarFromY(String param1, String param2) {
    return '您的$param1積分與$param2相差太多';
  }

  @override
  String challengeCannotChallengeDueToProvisionalXRating(String param) {
    return '由於您的$param積分不夠穩定，無法發出挑戰。';
  }

  @override
  String challengeXOnlyAcceptsChallengesFromFriends(String param) {
    return '$param只接受好友的對弈邀請';
  }

  @override
  String get challengeDeclineGeneric => '我目前不接受對弈';

  @override
  String get challengeDeclineLater => '我現在不接受對弈，請晚點再詢問';

  @override
  String get challengeDeclineTooFast => '這個時間控制對我來說太快了，請用慢一點的遊戲再次挑戰。';

  @override
  String get challengeDeclineTooSlow => '這個時間控制對我來說太慢了，請用快一點的遊戲再次挑戰。';

  @override
  String get challengeDeclineTimeControl => '我不接受這個挑戰的時間控制。';

  @override
  String get challengeDeclineRated => '請向我發送積分對弈。';

  @override
  String get challengeDeclineCasual => '請向我發送休閒對弈。';

  @override
  String get challengeDeclineStandard => '我不接受變體對弈。';

  @override
  String get challengeDeclineVariant => '我現在不想玩這個變體。';

  @override
  String get challengeDeclineNoBot => '我不接受機器人的對弈。';

  @override
  String get challengeDeclineOnlyBot => '我目前只接受機器人的對弈。';

  @override
  String get challengeInviteLichessUser => '或邀請一位 Lichess 用户：';

  @override
  String get contactContact => '聯繫我們';

  @override
  String get contactContactLichess => '聯繫 Lichess';

  @override
  String get patronDonate => '捐款';

  @override
  String get patronLichessPatron => 'Lichess 贊助者';

  @override
  String perfStatPerfStats(String param) {
    return '$param戰績';
  }

  @override
  String get perfStatViewTheGames => '查看遊戲紀錄';

  @override
  String get perfStatProvisional => '臨時';

  @override
  String get perfStatNotEnoughRatedGames => '積分賽場次太少，無法計算準確積分。';

  @override
  String perfStatProgressOverLastXGames(String param) {
    return '最近$param場棋局之積分變化：';
  }

  @override
  String perfStatRatingDeviation(String param) {
    return '積分誤差: $param';
  }

  @override
  String perfStatRatingDeviationTooltip(String param1, String param2, String param3) {
    return '越低的數值代表積分越穩定。 數值高於$param1時的積分會被判定為浮動積分。\n要被列入排名之中，該數值需低於$param2(標準西洋棋) 或是$param3(西洋棋變體)。';
  }

  @override
  String get perfStatTotalGames => '總計棋局';

  @override
  String get perfStatRatedGames => '積分棋局';

  @override
  String get perfStatTournamentGames => '聯賽棋局';

  @override
  String get perfStatBerserkedGames => '狂暴模式棋局';

  @override
  String get perfStatTimeSpentPlaying => '奕棋時間';

  @override
  String get perfStatAverageOpponent => '對手平均積分';

  @override
  String get perfStatVictories => '勝場';

  @override
  String get perfStatDefeats => '敗場';

  @override
  String get perfStatDisconnections => '斷線場次';

  @override
  String get perfStatNotEnoughGames => '棋局數不夠多';

  @override
  String perfStatHighestRating(String param) {
    return '最高積分：$param';
  }

  @override
  String perfStatLowestRating(String param) {
    return '最低積分：$param';
  }

  @override
  String perfStatFromXToY(String param1, String param2) {
    return '從$param1到$param2';
  }

  @override
  String get perfStatWinningStreak => '連勝場數';

  @override
  String get perfStatLosingStreak => '連敗場數';

  @override
  String perfStatLongestStreak(String param) {
    return '最長紀錄：$param';
  }

  @override
  String perfStatCurrentStreak(String param) {
    return '目前記錄：$param';
  }

  @override
  String get perfStatBestRated => '積分賽勝場之最強對手';

  @override
  String get perfStatGamesInARow => '連續奕棋場數';

  @override
  String get perfStatLessThanOneHour => '兩場間距不到一小時';

  @override
  String get perfStatMaxTimePlaying => '最高奕棋時間';

  @override
  String get perfStatNow => '現在';

  @override
  String get preferencesPreferences => '偏好設置';

  @override
  String get preferencesDisplay => '顯示';

  @override
  String get preferencesPrivacy => '隱私';

  @override
  String get preferencesNotifications => '通知';

  @override
  String get preferencesPieceAnimation => '棋子動畫';

  @override
  String get preferencesMaterialDifference => '子力差距';

  @override
  String get preferencesBoardHighlights => '棋盤高亮 (最後一步與將軍)';

  @override
  String get preferencesPieceDestinations => '棋子目的地（有效走法與預先走棋）';

  @override
  String get preferencesBoardCoordinates => '棋盤座標（A-H, 1-8）';

  @override
  String get preferencesMoveListWhilePlaying => '遊戲進行時顯示棋譜';

  @override
  String get preferencesPgnPieceNotation => '棋譜記法';

  @override
  String get preferencesChessPieceSymbol => '棋子符號';

  @override
  String get preferencesPgnLetter => '字母 (K, Q, R, B, N)';

  @override
  String get preferencesZenMode => '專注模式';

  @override
  String get preferencesShowPlayerRatings => '顯示玩家等級分';

  @override
  String get preferencesExplainShowPlayerRatings => '這允許隱藏本網站上的所有等級分，以輔助專心下棋。每局遊戲仍可以計算及改變等級分，這個設定只會影響到你是否看得到此分數。';

  @override
  String get preferencesDisplayBoardResizeHandle => '顯示盤面大小調整區塊';

  @override
  String get preferencesOnlyOnInitialPosition => '只在起始局面';

  @override
  String get preferencesInGameOnly => '只在遊戲中';

  @override
  String get preferencesChessClock => '棋鐘';

  @override
  String get preferencesTenthsOfSeconds => '十分之一秒';

  @override
  String get preferencesWhenTimeRemainingLessThanTenSeconds => '當剩餘時間小於10秒';

  @override
  String get preferencesHorizontalGreenProgressBars => '綠色橫進度條';

  @override
  String get preferencesSoundWhenTimeGetsCritical => '時間不足時聲音提醒';

  @override
  String get preferencesGiveMoreTime => '給對方更多時間';

  @override
  String get preferencesGameBehavior => '對局行為';

  @override
  String get preferencesHowDoYouMovePieces => '移動棋子方式？';

  @override
  String get preferencesClickTwoSquares => '點擊棋子及目標位置';

  @override
  String get preferencesDragPiece => '拖曳棋子';

  @override
  String get preferencesBothClicksAndDrag => '兩者都行';

  @override
  String get preferencesPremovesPlayingDuringOpponentTurn => '預先走棋（在對手的回合走棋）';

  @override
  String get preferencesTakebacksWithOpponentApproval => '悔棋（經過對手同意）';

  @override
  String get preferencesInCasualGamesOnly => '僅限非正式遊戲';

  @override
  String get preferencesPromoteToQueenAutomatically => '兵自動升為后';

  @override
  String get preferencesExplainPromoteToQueenAutomatically => '升變的同時按住<ctrl>以暫時取消自動升變';

  @override
  String get preferencesWhenPremoving => '預先走棋時';

  @override
  String get preferencesClaimDrawOnThreefoldRepetitionAutomatically => '在三次重覆局面時自動要求和局';

  @override
  String get preferencesWhenTimeRemainingLessThanThirtySeconds => '當剩餘時間小於30秒';

  @override
  String get preferencesMoveConfirmation => '走棋確認';

  @override
  String get preferencesExplainCanThenBeTemporarilyDisabled => '可以在遊戲中用棋盤選單中關閉此功能';

  @override
  String get preferencesInCorrespondenceGames => '在長期對局中';

  @override
  String get preferencesCorrespondenceAndUnlimited => '通信和無限';

  @override
  String get preferencesConfirmResignationAndDrawOffers => '確認投降或和局請求';

  @override
  String get preferencesCastleByMovingTheKingTwoSquaresOrOntoTheRook => '入堡方法';

  @override
  String get preferencesCastleByMovingTwoSquares => '移動國王兩格';

  @override
  String get preferencesCastleByMovingOntoTheRook => '移動國王到城堡上';

  @override
  String get preferencesInputMovesWithTheKeyboard => '使用鍵盤輸入著法';

  @override
  String get preferencesInputMovesWithVoice => '用語音輸入著法';

  @override
  String get preferencesSnapArrowsToValidMoves => '將右鍵標示箭頭鎖定到合法棋步';

  @override
  String get preferencesSayGgWpAfterLosingOrDrawing => '輸棋或和棋後自動發送 \"Good game, well played\"。';

  @override
  String get preferencesYourPreferencesHaveBeenSaved => '已儲存您的設定。';

  @override
  String get preferencesScrollOnTheBoardToReplayMoves => '在騎盤上使用滑鼠滾輪以重新顯示過去棋步';

  @override
  String get preferencesCorrespondenceEmailNotification => '每日以電郵列出您當前的長期對局';

  @override
  String get preferencesNotifyStreamStart => '追蹤的直播主開始直播';

  @override
  String get preferencesNotifyInboxMsg => '收件夾有新訊息';

  @override
  String get preferencesNotifyForumMention => '論壇評論中提到您';

  @override
  String get preferencesNotifyInvitedStudy => '研究邀請';

  @override
  String get preferencesNotifyGameEvent => '長期對局更新訊息';

  @override
  String get preferencesNotifyChallenge => '挑戰';

  @override
  String get preferencesNotifyTournamentSoon => '比賽即將開始';

  @override
  String get preferencesNotifyTimeAlarm => '長期對局的時間即將耗盡';

  @override
  String get preferencesNotifyBell => 'Lichess 內的鈴聲通知';

  @override
  String get preferencesNotifyPush => 'Lichess 外的設備通知';

  @override
  String get preferencesNotifyWeb => '瀏覽器通知';

  @override
  String get preferencesNotifyDevice => '設備通知';

  @override
  String get preferencesBellNotificationSound => '通知鈴聲';

  @override
  String get puzzlePuzzles => '謎題';

  @override
  String get puzzlePuzzleThemes => '謎題主題';

  @override
  String get puzzleRecommended => '推薦';

  @override
  String get puzzlePhases => '分類';

  @override
  String get puzzleMotifs => '主題';

  @override
  String get puzzleAdvanced => '高級';

  @override
  String get puzzleLengths => '長度';

  @override
  String get puzzleMates => '將軍';

  @override
  String get puzzleGoals => '目標';

  @override
  String get puzzleOrigin => '來源';

  @override
  String get puzzleSpecialMoves => '特殊移動';

  @override
  String get puzzleDidYouLikeThisPuzzle => '您喜歡這道謎題嗎？';

  @override
  String get puzzleVoteToLoadNextOne => '告訴我們加載下一題!';

  @override
  String get puzzleYourPuzzleRatingWillNotChange => '您的謎題評級不會改變。請注意，謎題不是比賽。您的評分有助於選擇最適合您當前技能的謎題。';

  @override
  String get puzzleFindTheBestMoveForWhite => '為白方找出最佳移動';

  @override
  String get puzzleFindTheBestMoveForBlack => '為黑方找出最佳移動';

  @override
  String get puzzleToGetPersonalizedPuzzles => '得到個人推薦題目:';

  @override
  String puzzlePuzzleId(String param) {
    return '謎題 $param';
  }

  @override
  String get puzzlePuzzleOfTheDay => '每日一題';

  @override
  String get puzzleClickToSolve => '點擊解題';

  @override
  String get puzzleGoodMove => '好棋';

  @override
  String get puzzleBestMove => '最佳走法!';

  @override
  String get puzzleKeepGoing => '加油!';

  @override
  String get puzzlePuzzleSuccess => '成功！';

  @override
  String get puzzlePuzzleComplete => '解題完成!';

  @override
  String get puzzleNotTheMove => '不是這步!';

  @override
  String get puzzleTrySomethingElse => '試試其他的移動';

  @override
  String puzzleRatingX(String param) {
    return '評級：$param';
  }

  @override
  String get puzzleHidden => '隱藏';

  @override
  String puzzleFromGameLink(String param) {
    return '來自對局 $param';
  }

  @override
  String get puzzleContinueTraining => '繼續訓練';

  @override
  String get puzzleDifficultyLevel => '困難度';

  @override
  String get puzzleNormal => '一般';

  @override
  String get puzzleEasier => '簡單';

  @override
  String get puzzleEasiest => '超簡單';

  @override
  String get puzzleHarder => '困難';

  @override
  String get puzzleHardest => '超困難';

  @override
  String get puzzleExample => '範例';

  @override
  String get puzzleAddAnotherTheme => '加入其他主題';

  @override
  String get puzzleJumpToNextPuzzleImmediately => '立即跳到下一個謎題';

  @override
  String get puzzlePuzzleDashboard => '謎題能力分析';

  @override
  String get puzzleImprovementAreas => '弱點';

  @override
  String get puzzleStrengths => '強項';

  @override
  String get puzzleHistory => '解題紀錄';

  @override
  String get puzzleSolved => '解決';

  @override
  String get puzzleFailed => '失敗';

  @override
  String get puzzleStreakDescription => '累積你的連勝，解著漸漸變難的題目。 沒有時間限制，不要急。走錯一步，將會是遊戲結束！\n不過每一局中你都有跳過一步棋的機會。';

  @override
  String puzzleYourStreakX(String param) {
    return '您的連勝場數：$param';
  }

  @override
  String get puzzleStreakSkipExplanation => '跳過這一步來維持您的連勝紀錄！每次遊玩只能使用一次。';

  @override
  String get puzzleContinueTheStreak => '繼續遊玩';

  @override
  String get puzzleNewStreak => '新的連勝紀錄';

  @override
  String get puzzleFromMyGames => '來自我的棋局';

  @override
  String get puzzleLookupOfPlayer => '尋找其他棋手的棋局謎題';

  @override
  String puzzleFromXGames(String param) {
    return '來自$param棋局的謎題';
  }

  @override
  String get puzzleSearchPuzzles => '尋找謎題';

  @override
  String get puzzleFromMyGamesNone => '你在數據庫中沒有謎題，但 Lichess 仍然非常愛你。\n遊玩一些快速和經典遊戲，以增加添加拼圖的機會！';

  @override
  String puzzleFromXGamesFound(String param1, String param2) {
    return '在$param2中找到$param1個謎題';
  }

  @override
  String get puzzlePuzzleDashboardDescription => '訓練、分析、改進';

  @override
  String puzzlePercentSolved(String param) {
    return '$param 已解決';
  }

  @override
  String get puzzleNoPuzzlesToShow => '沒有什麼可展示的，先去玩一些謎題吧！';

  @override
  String get puzzleImprovementAreasDescription => '訓練這些類型的謎題來優化你的進步！';

  @override
  String get puzzleStrengthDescription => '你在這些主題中表現最好';

  @override
  String puzzlePlayedXTimes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '已被嘗試$count次',
    );
    return '$_temp0';
  }

  @override
  String puzzleNbPointsBelowYourPuzzleRating(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '低於你的謎題積分$count點',
    );
    return '$_temp0';
  }

  @override
  String puzzleNbPointsAboveYourPuzzleRating(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '高於你的謎題積分$count點',
    );
    return '$_temp0';
  }

  @override
  String puzzleNbPlayed(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 已遊玩',
    );
    return '$_temp0';
  }

  @override
  String puzzleNbToReplay(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 重玩',
    );
    return '$_temp0';
  }

  @override
  String get puzzleThemeAdvancedPawn => '升變兵';

  @override
  String get puzzleThemeAdvancedPawnDescription => '你的其中一個兵已經深入了對方的棋位，或許要威脅升變。';

  @override
  String get puzzleThemeAdvantage => '擁有優勢';

  @override
  String get puzzleThemeAnastasiaMate => '阿納斯塔西亞殺法';

  @override
  String get puzzleThemeArabianMate => '阿拉伯殺法';

  @override
  String get puzzleThemeArabianMateDescription => '馬和車聯手把對方的王困住在角落的位置';

  @override
  String get puzzleThemeAttackingF2F7 => '攻擊f2或f7';

  @override
  String get puzzleThemeAttraction => '吸引';

  @override
  String get puzzleThemeBackRankMate => '後排將死';

  @override
  String get puzzleThemeBackRankMateDescription => '在對方的王在底線被自身的棋子困住時，將殺對方的王';

  @override
  String get puzzleThemeBishopEndgame => '象殘局';

  @override
  String get puzzleThemeBishopEndgameDescription => '只剩象和兵的殘局';

  @override
  String get puzzleThemeBodenMate => '波登殺法';

  @override
  String get puzzleThemeCastling => '易位';

  @override
  String get puzzleThemeCapturingDefender => '吃子 - 防守者';

  @override
  String get puzzleThemeCrushing => '壓倒性優勢';

  @override
  String get puzzleThemeCrushingDescription => '察覺對方的漏著並藉此取得巨大優勢。(大於600百分兵)';

  @override
  String get puzzleThemeDoubleBishopMate => '雙主教將死';

  @override
  String get puzzleThemeEquality => '均勢';

  @override
  String get puzzleThemeKingsideAttack => '王翼攻擊';

  @override
  String get puzzleThemeClearance => '騰挪';

  @override
  String get puzzleThemeDefensiveMove => '加強防守';

  @override
  String get puzzleThemeDeflection => '引離';

  @override
  String get puzzleThemeDiscoveredAttack => '閃擊';

  @override
  String get puzzleThemeDoubleCheck => '雙將';

  @override
  String get puzzleThemeEndgame => '殘局';

  @override
  String get puzzleThemeEndgameDescription => '棋局中最後階段的戰術';

  @override
  String get puzzleThemeFork => '捉雙';

  @override
  String get puzzleThemeKnightEndgame => '馬殘局';

  @override
  String get puzzleThemeKnightEndgameDescription => '只剩馬和兵的殘局';

  @override
  String get puzzleThemeLong => '長謎題';

  @override
  String get puzzleThemeLongDescription => '三步獲勝';

  @override
  String get puzzleThemeMaster => '大師棋局';

  @override
  String get puzzleThemeMasterVsMaster => '大師對局';

  @override
  String get puzzleThemeMate => '將軍';

  @override
  String get puzzleThemeMateIn1 => '一步殺棋';

  @override
  String get puzzleThemeMateIn1Description => '一步將軍';

  @override
  String get puzzleThemeMateIn2 => '兩步殺棋';

  @override
  String get puzzleThemeMateIn2Description => '走兩步以達到將軍';

  @override
  String get puzzleThemeMateIn3 => '三步殺棋';

  @override
  String get puzzleThemeMateIn3Description => '走三步以達到將軍';

  @override
  String get puzzleThemeMateIn4 => '四步殺棋';

  @override
  String get puzzleThemeMateIn4Description => '走四步以達到將軍';

  @override
  String get puzzleThemeMateIn5 => '五步或更高 將軍';

  @override
  String get puzzleThemeMiddlegame => '中局';

  @override
  String get puzzleThemeMiddlegameDescription => '棋局中第二階段的戰術';

  @override
  String get puzzleThemeOneMove => '一步題';

  @override
  String get puzzleThemeOneMoveDescription => '只有一步長的題目';

  @override
  String get puzzleThemeOpening => '開局';

  @override
  String get puzzleThemeOpeningDescription => '棋局中起始階段的戰術';

  @override
  String get puzzleThemePawnEndgame => '兵殘局';

  @override
  String get puzzleThemePawnEndgameDescription => '只剩兵的殘局';

  @override
  String get puzzleThemePin => '牽制';

  @override
  String get puzzleThemePromotion => '升變';

  @override
  String get puzzleThemeQueenEndgame => '后殘局';

  @override
  String get puzzleThemeQueenEndgameDescription => '只剩后和兵的殘局';

  @override
  String get puzzleThemeQueenRookEndgame => '后與車';

  @override
  String get puzzleThemeQueenRookEndgameDescription => '只剩后、車和兵的殘局';

  @override
  String get puzzleThemeQueensideAttack => '后翼攻擊';

  @override
  String get puzzleThemeQuietMove => '安靜的一着';

  @override
  String get puzzleThemeRookEndgame => '車殘局';

  @override
  String get puzzleThemeRookEndgameDescription => '只剩車和兵的殘局';

  @override
  String get puzzleThemeSacrifice => '棄子';

  @override
  String get puzzleThemeShort => '短謎題';

  @override
  String get puzzleThemeShortDescription => '兩步獲勝';

  @override
  String get puzzleThemeSkewer => '串擊';

  @override
  String get puzzleThemeSmotheredMate => '悶殺';

  @override
  String get puzzleThemeSuperGM => '超級大師賽局';

  @override
  String get puzzleThemeSuperGMDescription => '來自世界各地優秀玩家對局的戰術題';

  @override
  String get puzzleThemeTrappedPiece => '被困的棋子';

  @override
  String get puzzleThemeUnderPromotion => '升變';

  @override
  String get puzzleThemeUnderPromotionDescription => '升變成騎士、象或車';

  @override
  String get puzzleThemeVeryLong => '非常長的謎題';

  @override
  String get puzzleThemeVeryLongDescription => '四步或以上獲勝';

  @override
  String get puzzleThemeXRayAttack => '穿透攻擊';

  @override
  String get puzzleThemeZugzwang => '等著';

  @override
  String get puzzleThemeHealthyMix => '綜合';

  @override
  String get puzzleThemeHealthyMixDescription => '所有類型都有！你不知道會遇到什麼題型，所以請做好準備，就像在實戰一樣。';

  @override
  String get searchSearch => '搜尋';

  @override
  String get settingsSettings => '設定';

  @override
  String get settingsCloseAccount => '關閉帳戶';

  @override
  String get settingsClosingIsDefinitive => '您確定要刪除帳號嗎？這是不能挽回的';

  @override
  String get settingsCantOpenSimilarAccount => '即使名稱大小寫不同，您也不能使用相同的名稱開設新帳戶';

  @override
  String get settingsChangedMindDoNotCloseAccount => '我改變主意了，不要關閉我的帳號';

  @override
  String get settingsCloseAccountExplanation => '您真的確定要刪除帳戶嗎？ 關閉帳戶是永久性的決定， 您將「永遠無法」再次登錄。';

  @override
  String get settingsThisAccountIsClosed => '此帳號已被關閉。';

  @override
  String get playWithAFriend => '和好友下棋';

  @override
  String get playWithTheMachine => '和電腦下棋';

  @override
  String get toInviteSomeoneToPlayGiveThisUrl => '邀人下棋，請分享這個網址';

  @override
  String get gameOver => '遊戲結束';

  @override
  String get waitingForOpponent => '等待對手';

  @override
  String get waiting => '請稍等';

  @override
  String get yourTurn => '該你走';

  @override
  String aiNameLevelAiLevel(String param1, String param2) {
    return '$param1等級 $param2';
  }

  @override
  String get level => '難度';

  @override
  String get strength => '強度';

  @override
  String get toggleTheChat => '聊天開關';

  @override
  String get chat => '聊天';

  @override
  String get resign => '認輸';

  @override
  String get checkmate => '將死';

  @override
  String get stalemate => '逼和';

  @override
  String get white => '白方';

  @override
  String get black => '黑方';

  @override
  String get asWhite => '使用白棋';

  @override
  String get asBlack => '使用黑棋';

  @override
  String get randomColor => '隨機選色';

  @override
  String get createAGame => '開始對局';

  @override
  String get whiteIsVictorious => '白方勝';

  @override
  String get blackIsVictorious => '黑方勝';

  @override
  String get youPlayTheWhitePieces => '您執白棋';

  @override
  String get youPlayTheBlackPieces => '您執黑棋';

  @override
  String get itsYourTurn => '輪到你了！';

  @override
  String get cheatDetected => '偵測到作弊行為';

  @override
  String get kingInTheCenter => '王居中';

  @override
  String get threeChecks => '三次將軍';

  @override
  String get raceFinished => '競王結束';

  @override
  String get variantEnding => '另類終局';

  @override
  String get newOpponent => '換個對手';

  @override
  String get yourOpponentWantsToPlayANewGameWithYou => '你的對手想和你複賽';

  @override
  String get joinTheGame => '加入這盤棋';

  @override
  String get whitePlays => '白方走棋';

  @override
  String get blackPlays => '黑方走棋';

  @override
  String get opponentLeftChoices => '對方可能已經離開遊戲。您可以選擇：取勝、和棋或等待對方走棋。';

  @override
  String get forceResignation => '取勝';

  @override
  String get forceDraw => '和棋';

  @override
  String get talkInChat => '請在聊天室裡文明一點';

  @override
  String get theFirstPersonToComeOnThisUrlWillPlayWithYou => '第一個訪問該網址的人將與您下棋。';

  @override
  String get whiteResigned => '白方認輸';

  @override
  String get blackResigned => '黑方認輸';

  @override
  String get whiteLeftTheGame => '白方棄局';

  @override
  String get blackLeftTheGame => '黑方棄局';

  @override
  String get whiteDidntMove => '白方沒有走棋';

  @override
  String get blackDidntMove => '黑方沒有走棋';

  @override
  String get requestAComputerAnalysis => '請求電腦分析';

  @override
  String get computerAnalysis => '電腦分析';

  @override
  String get computerAnalysisAvailable => '電腦分析可用';

  @override
  String get computerAnalysisDisabled => '電腦分析未啟用';

  @override
  String get analysis => '分析棋局';

  @override
  String depthX(String param) {
    return '深度 $param';
  }

  @override
  String get usingServerAnalysis => '正在使用伺服器分析';

  @override
  String get loadingEngine => '正在載入引擎 ...';

  @override
  String get calculatingMoves => '計算著法中。。。';

  @override
  String get engineFailed => '加載引擎出錯';

  @override
  String get cloudAnalysis => '雲端分析';

  @override
  String get goDeeper => '深入分析';

  @override
  String get showThreat => '顯示敵方威脅';

  @override
  String get inLocalBrowser => '在本地瀏覽器';

  @override
  String get toggleLocalEvaluation => '使用您當地的伺服器分析';

  @override
  String get promoteVariation => '增加變化';

  @override
  String get makeMainLine => '將這步棋導入主要流程中';

  @override
  String get deleteFromHere => '從這處開始刪除';

  @override
  String get forceVariation => '移除變化';

  @override
  String get copyVariationPgn => '複製變體 PGN';

  @override
  String get move => '走棋';

  @override
  String get variantLoss => '您因特殊規則而輸了';

  @override
  String get variantWin => '您因特殊規則而贏了';

  @override
  String get insufficientMaterial => '由於棋子不足而導致平局';

  @override
  String get pawnMove => '小兵移動';

  @override
  String get capture => '吃子';

  @override
  String get close => '關閉';

  @override
  String get winning => '贏棋';

  @override
  String get losing => '輸棋';

  @override
  String get drawn => '平手';

  @override
  String get unknown => '未知';

  @override
  String get database => '資料庫';

  @override
  String get whiteDrawBlack => '白棋獲勝 / 平局 / 黑棋獲勝';

  @override
  String averageRatingX(String param) {
    return '平均評分: $param';
  }

  @override
  String get recentGames => '最近的棋局';

  @override
  String get topGames => '評分最高的棋局';

  @override
  String masterDbExplanation(String param1, String param2, String param3) {
    return '來自$param2到$param3年國際棋聯積分$param1以上的棋手對局棋譜';
  }

  @override
  String get dtzWithRounding => '經過四捨五入的DTZ50\'\'，是基於到下次吃子或兵動的半步數目。';

  @override
  String get noGameFound => '未找到遊戲';

  @override
  String get maxDepthReached => '已達到最大深度！';

  @override
  String get maybeIncludeMoreGamesFromThePreferencesMenu => '試著從偏好設置中加入更多棋局';

  @override
  String get openings => '開局';

  @override
  String get openingExplorer => '開局瀏覽器';

  @override
  String get openingEndgameExplorer => '開局與終局瀏覽器';

  @override
  String xOpeningExplorer(String param) {
    return '$param開局瀏覽器';
  }

  @override
  String get playFirstOpeningEndgameExplorerMove => '在開局/殘局瀏覽器走第一步棋';

  @override
  String get winPreventedBy50MoveRule => '在不違反50步和局規則下贏得這局棋';

  @override
  String get lossSavedBy50MoveRule => '藉由50步和局規則來避免輸掉棋局';

  @override
  String get winOr50MovesByPriorMistake => '贏棋或因先前錯誤50步作和';

  @override
  String get lossOr50MovesByPriorMistake => '輸棋或因先前錯誤50步作和';

  @override
  String get unknownDueToRounding => '由上次吃子或兵動開始按殘局庫建議走法走才能保證勝敗的判斷正確。這是因為Syzygy殘局庫的DTZ數值可能經過四捨五入。';

  @override
  String get allSet => '一切就緒！';

  @override
  String get importPgn => '匯入 PGN';

  @override
  String get delete => '刪除';

  @override
  String get deleteThisImportedGame => '刪除此匯入的棋局？';

  @override
  String get replayMode => '重播模式';

  @override
  String get realtimeReplay => '實時';

  @override
  String get byCPL => 'CPL';

  @override
  String get openStudy => '打開研究視窗';

  @override
  String get enable => '開啟';

  @override
  String get bestMoveArrow => '最佳移動的箭頭';

  @override
  String get showVariationArrows => '顯示變體箭頭';

  @override
  String get evaluationGauge => '棋力估計表';

  @override
  String get multipleLines => '路線分析線';

  @override
  String get cpus => 'CPU';

  @override
  String get memory => '記憶體';

  @override
  String get infiniteAnalysis => '無限分析';

  @override
  String get removesTheDepthLimit => '取消深度限制，使您的電腦發熱。';

  @override
  String get engineManager => '引擎管理';

  @override
  String get blunder => '嚴重錯誤';

  @override
  String get mistake => '錯誤';

  @override
  String get inaccuracy => '輕微失誤';

  @override
  String get moveTimes => '走棋時間';

  @override
  String get flipBoard => '翻轉棋盤';

  @override
  String get threefoldRepetition => '三次重複局面';

  @override
  String get claimADraw => '要求和棋';

  @override
  String get offerDraw => '提出和棋';

  @override
  String get draw => '和棋';

  @override
  String get drawByMutualAgreement => '雙方同意和局';

  @override
  String get fiftyMovesWithoutProgress => '50步規則和局';

  @override
  String get currentGames => '當前對局';

  @override
  String get viewInFullSize => '在整個網頁裡觀看棋局';

  @override
  String get logOut => '登出';

  @override
  String get signIn => '登入';

  @override
  String get rememberMe => '保持登入狀態';

  @override
  String get youNeedAnAccountToDoThat => '請註冊以完成該操作';

  @override
  String get signUp => '註冊';

  @override
  String get computersAreNotAllowedToPlay => '電腦與電腦輔助棋手不允許參加對弈。對弈時，請勿從國際象棋引擎、資料庫以及其他棋手那裡獲取幫助。另外，強烈建議不要創建多個帳號；過分地使用多個帳號將導致封號。';

  @override
  String get games => '棋局';

  @override
  String get forum => '論壇';

  @override
  String xPostedInForumY(String param1, String param2) {
    return '$param1發帖：$param2';
  }

  @override
  String get latestForumPosts => '最新論壇貼文';

  @override
  String get players => '棋手';

  @override
  String get friends => '朋友';

  @override
  String get discussions => '對話';

  @override
  String get today => '今天';

  @override
  String get yesterday => '昨天';

  @override
  String get minutesPerSide => '每方分鐘數';

  @override
  String get variant => '變體';

  @override
  String get variants => '變體';

  @override
  String get timeControl => '時間限制';

  @override
  String get realTime => '實時棋局';

  @override
  String get correspondence => '通信棋局';

  @override
  String get daysPerTurn => '每步允許天數';

  @override
  String get oneDay => '一天';

  @override
  String get time => '時間';

  @override
  String get rating => '評級';

  @override
  String get ratingStats => '評分數據';

  @override
  String get username => '用戶名';

  @override
  String get usernameOrEmail => '用戶名或電郵地址';

  @override
  String get changeUsername => '更改用戶名';

  @override
  String get changeUsernameNotSame => '只能更改字母大小字。例如，將「johndoe」變成「JohnDoe」。';

  @override
  String get changeUsernameDescription => '更改用戶名。您最多可以更改一次字母大小寫。';

  @override
  String get signupUsernameHint => '請選擇一個和諧的用戶名，用戶名無法再次更改，並且不合規的用戶名會導致帳戶被封禁！';

  @override
  String get signupEmailHint => '僅用於密碼重置';

  @override
  String get password => '密碼';

  @override
  String get changePassword => '更改密碼';

  @override
  String get changeEmail => '更改電郵地址';

  @override
  String get email => '電郵地址';

  @override
  String get passwordReset => '重置密碼';

  @override
  String get forgotPassword => '忘記密碼？';

  @override
  String get error_weakPassword => '此密碼太常見，且很容易被猜到。';

  @override
  String get error_namePassword => '請不要把密碼設為用戶名。';

  @override
  String get blankedPassword => '你在其他站點使用過相同的密碼，並且這些站點已經失效。為確保你的 Lichess 帳戶安全，你需要設置新密碼。感謝你的理解。';

  @override
  String get youAreLeavingLichess => '你正在離開 Lichess';

  @override
  String get neverTypeYourPassword => '不要在其他網站輸入你的 Lichess 密碼！';

  @override
  String proceedToX(String param) {
    return '前往 $param';
  }

  @override
  String get passwordSuggestion => '不要使用他人建議的密碼，他們會用此密碼盜取你的帳戶。';

  @override
  String get emailSuggestion => '不要使用他人提供的郵箱地址，他們會用它盜取你的帳戶。';

  @override
  String get emailConfirmHelp => '協助郵件確認';

  @override
  String get emailConfirmNotReceived => '註冊後沒有收到確認郵件？';

  @override
  String get whatSignupUsername => '你用了什麼用戶名註冊？';

  @override
  String usernameNotFound(String param) {
    return '找不到用戶 $param。';
  }

  @override
  String get usernameCanBeUsedForNewAccount => '你可以使用這個用戶名創建帳戶';

  @override
  String emailSent(String param) {
    return '我們向 $param 發送了電子郵件。';
  }

  @override
  String get emailCanTakeSomeTime => '可能需要一些時間才能收到。';

  @override
  String get refreshInboxAfterFiveMinutes => '等待5分鐘並刷新你的收件箱。';

  @override
  String get checkSpamFolder => '嘗試檢查你的垃圾郵件收件匣，它可能在那裡。 如果在，請將其標記為非垃圾郵件。';

  @override
  String get emailForSignupHelp => '如果其他所有的方法都失敗了，給我們發這條短信：';

  @override
  String copyTextToEmail(String param) {
    return '複製並粘貼上面的文本然後把它發給$param';
  }

  @override
  String get waitForSignupHelp => '我們很快就會給你回復，説明你完成註冊。';

  @override
  String accountConfirmed(String param) {
    return '這個使用者 $param 成功地確認了';
  }

  @override
  String accountCanLogin(String param) {
    return '你可以做為 $param 登入了。';
  }

  @override
  String get accountConfirmationEmailNotNeeded => '你不需要確認電子郵件。';

  @override
  String accountClosed(String param) {
    return '帳戶 $param 被關閉。';
  }

  @override
  String accountRegisteredWithoutEmail(String param) {
    return '帳戶 $param 未使用電子郵箱註冊。';
  }

  @override
  String get rank => '排名';

  @override
  String rankX(String param) {
    return '排名：$param';
  }

  @override
  String get gamesPlayed => '盤棋已結束';

  @override
  String get cancel => '取消';

  @override
  String get whiteTimeOut => '白方時間到';

  @override
  String get blackTimeOut => '黑方時間到';

  @override
  String get drawOfferSent => '和棋請求已發送';

  @override
  String get drawOfferAccepted => '同意和棋';

  @override
  String get drawOfferCanceled => '和棋取消';

  @override
  String get whiteOffersDraw => '白方提出和棋';

  @override
  String get blackOffersDraw => '黑方提出和棋';

  @override
  String get whiteDeclinesDraw => '白方拒絕和棋';

  @override
  String get blackDeclinesDraw => '黑方拒絕和棋';

  @override
  String get yourOpponentOffersADraw => '您的對手提出和棋';

  @override
  String get accept => '接受';

  @override
  String get decline => '拒絕';

  @override
  String get playingRightNow => '正在對局';

  @override
  String get eventInProgress => '正在進行';

  @override
  String get finished => '已結束';

  @override
  String get abortGame => '中止本局';

  @override
  String get gameAborted => '棋局已中止';

  @override
  String get standard => '標準';

  @override
  String get unlimited => '無限';

  @override
  String get mode => '模式';

  @override
  String get casual => '休閒';

  @override
  String get rated => '排位賽';

  @override
  String get casualTournament => '休閒';

  @override
  String get ratedTournament => '排位';

  @override
  String get thisGameIsRated => '此對局是排位賽';

  @override
  String get rematch => '重賽';

  @override
  String get rematchOfferSent => '重賽請求已發送';

  @override
  String get rematchOfferAccepted => '重賽請求被接受';

  @override
  String get rematchOfferCanceled => '重賽請求被取消';

  @override
  String get rematchOfferDeclined => '重賽請求被拒絕';

  @override
  String get cancelRematchOffer => '取消重賽請求';

  @override
  String get viewRematch => '觀看重賽';

  @override
  String get confirmMove => '確認移動';

  @override
  String get play => '下棋';

  @override
  String get inbox => '收件箱';

  @override
  String get chatRoom => '聊天室';

  @override
  String get loginToChat => '登入以聊天';

  @override
  String get youHaveBeenTimedOut => '由於時間原因您不能發言';

  @override
  String get spectatorRoom => '觀眾室';

  @override
  String get composeMessage => '寫信息';

  @override
  String get subject => '主題';

  @override
  String get send => '發送';

  @override
  String get incrementInSeconds => '增加秒數';

  @override
  String get freeOnlineChess => '免費線上國際象棋';

  @override
  String get exportGames => '導出棋局';

  @override
  String get ratingRange => '對方級別範圍';

  @override
  String get thisAccountViolatedTos => '此帳號違反了Lichess的使用規定';

  @override
  String get openingExplorerAndTablebase => '開局瀏覽器 & 總局資料庫';

  @override
  String get takeback => '悔棋';

  @override
  String get proposeATakeback => '請求悔棋';

  @override
  String get takebackPropositionSent => '悔棋請求已發送';

  @override
  String get takebackPropositionDeclined => '悔棋請求被拒絕';

  @override
  String get takebackPropositionAccepted => '同意悔棋';

  @override
  String get takebackPropositionCanceled => '悔棋請求已取消';

  @override
  String get yourOpponentProposesATakeback => '對手請求悔棋';

  @override
  String get bookmarkThisGame => '收藏該棋局';

  @override
  String get tournament => '錦標賽';

  @override
  String get tournaments => '錦標賽';

  @override
  String get tournamentPoints => '錦標賽得分';

  @override
  String get viewTournament => '觀看錦標賽';

  @override
  String get backToTournament => '返回錦標賽主頁';

  @override
  String get noDrawBeforeSwissLimit => '在瑞士錦標賽中，在下三十步棋前你不能提和.';

  @override
  String get thematic => '特殊開局';

  @override
  String yourPerfRatingIsProvisional(String param) {
    return '您目前的評分$param為臨時評分';
  }

  @override
  String yourPerfRatingIsTooHigh(String param1, String param2) {
    return '您的 $param1 積分 ($param2) 過高';
  }

  @override
  String yourTopWeeklyPerfRatingIsTooHigh(String param1, String param2) {
    return '您本週最高 $param1 積分 ($param2) 過高';
  }

  @override
  String yourPerfRatingIsTooLow(String param1, String param2) {
    return '您的 $param1 積分 ($param2) 過低';
  }

  @override
  String ratedMoreThanInPerf(String param1, String param2) {
    return '在$param2模式下的評分大於$param1';
  }

  @override
  String ratedLessThanInPerf(String param1, String param2) {
    return '在$param2模式下的評分小於$param1';
  }

  @override
  String mustBeInTeam(String param) {
    return '需要在$param團隊內';
  }

  @override
  String youAreNotInTeam(String param) {
    return '您不在$param團隊中';
  }

  @override
  String get backToGame => '返回棋局';

  @override
  String get siteDescription => '界面清新的免費線上國際象棋平台。不用註冊，沒有廣告，無需插件。快來與電腦、朋友和陌生人一起對戰吧！';

  @override
  String xJoinedTeamY(String param1, String param2) {
    return '$param1加入$param2隊';
  }

  @override
  String xCreatedTeamY(String param1, String param2) {
    return '$param1組建$param2隊';
  }

  @override
  String get startedStreaming => '開始直播';

  @override
  String xStartedStreaming(String param) {
    return '$param開始直播';
  }

  @override
  String get averageElo => '平均級別';

  @override
  String get location => '所在地';

  @override
  String get filterGames => '篩選棋局';

  @override
  String get reset => '重置';

  @override
  String get apply => '套用';

  @override
  String get save => '儲存';

  @override
  String get leaderboard => '排行榜';

  @override
  String get screenshotCurrentPosition => '截圖當前頁面';

  @override
  String get gameAsGIF => '保存棋局為 GIF';

  @override
  String get pasteTheFenStringHere => '在此處黏貼FEN棋譜';

  @override
  String get pasteThePgnStringHere => '在此處黏貼PGN棋譜';

  @override
  String get orUploadPgnFile => '或者上傳一個PGN文件';

  @override
  String get fromPosition => '自定義局面';

  @override
  String get continueFromHere => '从此處繼續';

  @override
  String get toStudy => '研究';

  @override
  String get importGame => '導入棋局';

  @override
  String get importGameExplanation => '貼上PGN棋譜後可以重播棋局，使用電腦分析、對局聊天室及取得此棋局的分享連結。';

  @override
  String get importGameCaveat => '變著分支將被刪除。 若要保存這些變著，請通過導入PGN棋譜創建一個研究。';

  @override
  String get thisIsAChessCaptcha => '這是一個國際象棋驗證碼。';

  @override
  String get clickOnTheBoardToMakeYourMove => '點擊棋盤走棋以證明您是人類。';

  @override
  String get captcha_fail => '請完成驗證。';

  @override
  String get notACheckmate => '沒有將死';

  @override
  String get whiteCheckmatesInOneMove => '白方一步將死';

  @override
  String get blackCheckmatesInOneMove => '黑方一步棋將死對手';

  @override
  String get retry => '重試';

  @override
  String get reconnecting => '重新連接中';

  @override
  String get favoriteOpponents => '最喜歡的對手';

  @override
  String get follow => '關注';

  @override
  String get following => '已關注';

  @override
  String get unfollow => '取消關注';

  @override
  String followX(String param) {
    return '追蹤$param';
  }

  @override
  String unfollowX(String param) {
    return '取消追蹤$param';
  }

  @override
  String get block => '加入黑名單';

  @override
  String get blocked => '已加入黑名單';

  @override
  String get unblock => '移除出黑名單';

  @override
  String get followsYou => '關注您';

  @override
  String xStartedFollowingY(String param1, String param2) {
    return '$param1開始關注$param2';
  }

  @override
  String get more => '更多';

  @override
  String get memberSince => '註冊日期';

  @override
  String lastSeenActive(String param) {
    return '最近登入 $param';
  }

  @override
  String get player => '棋手';

  @override
  String get list => '列表';

  @override
  String get graph => '圖表';

  @override
  String get required => '必填項目。';

  @override
  String get openTournaments => '公開錦標賽';

  @override
  String get duration => '持續時間';

  @override
  String get winner => '勝利者';

  @override
  String get standing => '名次';

  @override
  String get createANewTournament => '建立新的錦標賽';

  @override
  String get tournamentCalendar => '錦標賽日程';

  @override
  String get conditionOfEntry => '加入限制:';

  @override
  String get advancedSettings => '高級設定';

  @override
  String get safeTournamentName => '幫錦標賽挑選一個適合的名字';

  @override
  String get inappropriateNameWarning => '即便只是一點點的違規都有可能導致您的帳號被封鎖。';

  @override
  String get emptyTournamentName => '若不填入錦標賽的名稱，將會用一位著名的棋手名字來做為錦標賽名稱。';

  @override
  String get makePrivateTournament => '把錦標賽設定為私人，並設定密碼來限制進入。';

  @override
  String get join => '加入';

  @override
  String get withdraw => '離開';

  @override
  String get points => '分數';

  @override
  String get wins => '勝';

  @override
  String get losses => '負';

  @override
  String get createdBy => '創建者：';

  @override
  String get tournamentIsStarting => '錦標賽即將開始';

  @override
  String get tournamentPairingsAreNowClosed => '此錦標賽的對手配對已結束。';

  @override
  String standByX(String param) {
    return '$param準備好，你馬上要開始對棋了！';
  }

  @override
  String get pause => '暫停';

  @override
  String get resume => '繼續';

  @override
  String get youArePlaying => '等待對手中';

  @override
  String get winRate => '勝率';

  @override
  String get berserkRate => '快棋率';

  @override
  String get performance => '表現';

  @override
  String get tournamentComplete => '錦標賽結束';

  @override
  String get movesPlayed => '步數';

  @override
  String get whiteWins => '白方獲勝';

  @override
  String get blackWins => '黑方獲勝';

  @override
  String get drawRate => '和棋率';

  @override
  String get draws => '和棋';

  @override
  String nextXTournament(String param) {
    return '下一個$param錦標賽';
  }

  @override
  String get averageOpponent => '平均對手評分';

  @override
  String get boardEditor => '棋盤編輯器';

  @override
  String get setTheBoard => '設定版型';

  @override
  String get popularOpenings => '使用率最高的開局';

  @override
  String get endgamePositions => '殘局局面';

  @override
  String chess960StartPosition(String param) {
    return '960棋局開局位置: $param';
  }

  @override
  String get startPosition => '初始佈局';

  @override
  String get clearBoard => '清空棋盤';

  @override
  String get loadPosition => '裝入佈局';

  @override
  String get isPrivate => '私人';

  @override
  String reportXToModerators(String param) {
    return '將$param報告給管理人員';
  }

  @override
  String profileCompletion(String param) {
    return '個人檔案完成度:$param';
  }

  @override
  String xRating(String param) {
    return '$param評分';
  }

  @override
  String get ifNoneLeaveEmpty => '如果沒有，請留空';

  @override
  String get profile => '資料';

  @override
  String get editProfile => '編輯資料';

  @override
  String get setFlair => '設置你的圖標';

  @override
  String get flair => '圖標';

  @override
  String get youCanHideFlair => '有一個設置可以隱藏整個網站上所有用户圖標。';

  @override
  String get biography => '個人簡介';

  @override
  String get countryRegion => '國家或地區';

  @override
  String get thankYou => '謝謝！';

  @override
  String get socialMediaLinks => '官方社群連結';

  @override
  String get oneUrlPerLine => '每行一個網址';

  @override
  String get inlineNotation => '棋譜集中顯示';

  @override
  String get makeAStudy => '為了安全保管和分享，考慮創建一項研討.';

  @override
  String get clearSavedMoves => '清空著法儲存';

  @override
  String get previouslyOnLichessTV => '過去的Lichess TV直播';

  @override
  String get onlinePlayers => '在線棋手';

  @override
  String get activePlayers => '活躍棋手';

  @override
  String get bewareTheGameIsRatedButHasNoClock => '注意，這棋局是排位賽，但是不計時！';

  @override
  String get success => '大功告成！';

  @override
  String get automaticallyProceedToNextGameAfterMoving => '移动棋子后自动进入下一盘棋';

  @override
  String get autoSwitch => '自动更换';

  @override
  String get puzzles => '謎題';

  @override
  String get name => '名';

  @override
  String get description => '描述';

  @override
  String get descPrivate => '內部簡介';

  @override
  String get descPrivateHelp => '僅團隊成員可見，設置後將覆蓋公開簡介為團隊成員展示。';

  @override
  String get no => '否';

  @override
  String get yes => '是';

  @override
  String get help => '幫助：';

  @override
  String get createANewTopic => '新话题';

  @override
  String get topics => '话题';

  @override
  String get posts => '貼文';

  @override
  String get lastPost => '最近貼文';

  @override
  String get views => '浏览';

  @override
  String get replies => '回复';

  @override
  String get replyToThisTopic => '回复此话题';

  @override
  String get reply => '回复';

  @override
  String get message => '信息';

  @override
  String get createTheTopic => '创建话题';

  @override
  String get reportAUser => '举报用户';

  @override
  String get user => '用户';

  @override
  String get reason => '原因';

  @override
  String get whatIsIheMatter => '举报原因？';

  @override
  String get cheat => '作弊';

  @override
  String get troll => '钓鱼';

  @override
  String get other => '其他';

  @override
  String get reportDescriptionHelp => '附上游戏的网址解释该用户的行为问题';

  @override
  String get error_provideOneCheatedGameLink => '請提供至少一局作弊棋局的連結。';

  @override
  String by(String param) {
    return '$param作';
  }

  @override
  String importedByX(String param) {
    return '由$param滙入';
  }

  @override
  String get thisTopicIsNowClosed => '本话题已关闭。';

  @override
  String get blog => '博客';

  @override
  String get notes => '笔记';

  @override
  String get typePrivateNotesHere => '在此輸入私人筆記';

  @override
  String get writeAPrivateNoteAboutThisUser => '備註用戶資訊';

  @override
  String get noNoteYet => '尚無筆記';

  @override
  String get invalidUsernameOrPassword => '用户名或密碼錯誤';

  @override
  String get incorrectPassword => '舊密碼錯誤';

  @override
  String get invalidAuthenticationCode => '驗證碼無效';

  @override
  String get emailMeALink => '通過電郵發送連結給我';

  @override
  String get currentPassword => '目前密碼';

  @override
  String get newPassword => '新密碼';

  @override
  String get newPasswordAgain => '重複新密碼';

  @override
  String get newPasswordsDontMatch => '新密碼不符合';

  @override
  String get newPasswordStrength => '密碼強度';

  @override
  String get clockInitialTime => '棋鐘起始時間';

  @override
  String get clockIncrement => '加秒';

  @override
  String get privacy => '隱私';

  @override
  String get privacyPolicy => '隱私條款';

  @override
  String get letOtherPlayersFollowYou => '允许其他玩家关注';

  @override
  String get letOtherPlayersChallengeYou => '允许其他玩家挑战';

  @override
  String get letOtherPlayersInviteYouToStudy => '允許其他棋手邀請你參加研討';

  @override
  String get sound => '聲音';

  @override
  String get none => '無';

  @override
  String get fast => '快';

  @override
  String get normal => '普通';

  @override
  String get slow => '慢';

  @override
  String get insideTheBoard => '棋盤內';

  @override
  String get outsideTheBoard => '棋盤外';

  @override
  String get onSlowGames => '慢棋時';

  @override
  String get always => '總是';

  @override
  String get never => '永不';

  @override
  String xCompetesInY(String param1, String param2) {
    return '$param1参加$param2';
  }

  @override
  String get victory => '成功！';

  @override
  String get defeat => '戰敗';

  @override
  String victoryVsYInZ(String param1, String param2, String param3) {
    return '$param1在$param3模式下贏了$param2';
  }

  @override
  String defeatVsYInZ(String param1, String param2, String param3) {
    return '$param1在$param3模式下輸給了$param2';
  }

  @override
  String drawVsYInZ(String param1, String param2, String param3) {
    return '$param1在$param3模式下和$param2平手';
  }

  @override
  String get timeline => '时间线';

  @override
  String get starting => '开始时间：';

  @override
  String get allInformationIsPublicAndOptional => '所有資料是公開的，同時是可選的。';

  @override
  String get biographyDescription => '給我們一個您的自我介紹，像是您的興趣、您喜愛的選手等';

  @override
  String get listBlockedPlayers => '显示黑名单用户列表';

  @override
  String get human => '人类';

  @override
  String get computer => '電腦';

  @override
  String get side => '方';

  @override
  String get clock => '鐘';

  @override
  String get opponent => '对手';

  @override
  String get learnMenu => '學棋';

  @override
  String get studyMenu => '研究';

  @override
  String get practice => '練習';

  @override
  String get community => '社區';

  @override
  String get tools => '工具';

  @override
  String get increment => '加秒';

  @override
  String get error_unknown => '無效值';

  @override
  String get error_required => '本项必填';

  @override
  String get error_email => '這個電子郵件地址無效';

  @override
  String get error_email_acceptable => '該電子郵件地址是不可用。請重新檢查後重試。';

  @override
  String get error_email_unique => '電子郵件地址無效或已被使用';

  @override
  String get error_email_different => '這已經是您的電子郵件地址';

  @override
  String error_minLength(String param) {
    return '至少應有 $param 個字元長';
  }

  @override
  String error_maxLength(String param) {
    return '最多不能超過 $param 個字元長';
  }

  @override
  String error_min(String param) {
    return '最少 $param 個字符';
  }

  @override
  String error_max(String param) {
    return '最大不能超過 $param';
  }

  @override
  String ifRatingIsPlusMinusX(String param) {
    return '允许评级范围±$param';
  }

  @override
  String get ifRegistered => '如已註冊';

  @override
  String get onlyExistingConversations => '僅目前對話';

  @override
  String get onlyFriends => '只允許好友';

  @override
  String get menu => '菜单';

  @override
  String get castling => '王车易位';

  @override
  String get whiteCastlingKingside => '白方短易位';

  @override
  String get blackCastlingKingside => '黑方短易位';

  @override
  String tpTimeSpentPlaying(String param) {
    return '花在下棋上的時間：$param';
  }

  @override
  String get watchGames => '觀看對局直播';

  @override
  String tpTimeSpentOnTV(String param) {
    return '花在Lichess TV觀看直播的時間：$param';
  }

  @override
  String get watch => '觀看';

  @override
  String get videoLibrary => '影片庫';

  @override
  String get streamersMenu => '實況主';

  @override
  String get mobileApp => '行動應用程式';

  @override
  String get webmasters => '網站管理員';

  @override
  String get about => '關於';

  @override
  String aboutX(String param) {
    return '關於 $param';
  }

  @override
  String xIsAFreeYLibreOpenSourceChessServer(String param1, String param2) {
    return '$param1是一個免費的($param2)，開放性的，無廣告，開放資源的網站';
  }

  @override
  String get really => '真的';

  @override
  String get contribute => '協助';

  @override
  String get termsOfService => '服務條款';

  @override
  String get sourceCode => '原始碼';

  @override
  String get simultaneousExhibitions => '車輪戰';

  @override
  String get host => '主持';

  @override
  String hostColorX(String param) {
    return '主持者使用旗子顏色:$param';
  }

  @override
  String get yourPendingSimuls => '你待處理的車輪戰';

  @override
  String get createdSimuls => '最近开始的同步赛';

  @override
  String get hostANewSimul => '主持新同步赛';

  @override
  String get signUpToHostOrJoinASimul => '註冊以舉辦或參與車輪戰';

  @override
  String get noSimulFound => '找不到该同步赛';

  @override
  String get noSimulExplanation => '此車輪戰不存在。';

  @override
  String get returnToSimulHomepage => '返回表演赛主页';

  @override
  String get aboutSimul => '車輪戰涉及到一個人同時和幾位棋手下棋。';

  @override
  String get aboutSimulImage => '在50个对手中，菲舍尔赢了47局，和了2局，输了1局。';

  @override
  String get aboutSimulRealLife => '这个概念来自真实的国际赛事。 在现实中，这涉及到主持在桌与桌之间来回穿梭走棋。';

  @override
  String get aboutSimulRules => '当表演赛开始的时候， 每个玩家都与主持开始对弈， 而主持用白方。 当所有的对局都结束时，表演赛就结束了。';

  @override
  String get aboutSimulSettings => '表演赛总是不定级的。 复赛、悔棋和\"加时\"功能将被禁用。';

  @override
  String get create => '创建';

  @override
  String get whenCreateSimul => '當您創建車輪戰時，您要同時跟幾個棋手一起下棋。';

  @override
  String get simulVariantsHint => '如果您选择几个变体，每个玩家都要选择下哪一种。';

  @override
  String get simulClockHint => '菲舍爾時鐘設定。棋手越多，您需要的時間可能就越多。';

  @override
  String get simulAddExtraTime => '您可以給您的時鍾多加點時間以幫助您應對車輪戰。';

  @override
  String get simulHostExtraTime => '主持人的额外时间';

  @override
  String get simulAddExtraTimePerPlayer => '每有一個玩家加入車輪戰，您棋鐘的初始時間都將增加。';

  @override
  String get simulHostExtraTimePerPlayer => '每個玩家加入后棋鐘增加的額外時間';

  @override
  String get lichessTournaments => 'Lichess比赛';

  @override
  String get tournamentFAQ => '比赛常见问题';

  @override
  String get timeBeforeTournamentStarts => '比赛准备时间';

  @override
  String get averageCentipawnLoss => '平均厘兵损失';

  @override
  String get accuracy => '精準度';

  @override
  String get keyboardShortcuts => '快捷键';

  @override
  String get keyMoveBackwardOrForward => '后退/前进';

  @override
  String get keyGoToStartOrEnd => '跳到开始/结束';

  @override
  String get keyCycleSelectedVariation => '循環已選取的變體';

  @override
  String get keyShowOrHideComments => '显示/隐藏评论';

  @override
  String get keyEnterOrExitVariation => '进入/退出变体';

  @override
  String get keyRequestComputerAnalysis => '請求引擎分析，從你的失誤中學習';

  @override
  String get keyNextLearnFromYourMistakes => '下一個 (從你的失誤中學習)';

  @override
  String get keyNextBlunder => '下一個漏著';

  @override
  String get keyNextMistake => '下一個錯著';

  @override
  String get keyNextInaccuracy => '下一個疑著';

  @override
  String get keyPreviousBranch => '上一個分支';

  @override
  String get keyNextBranch => '下一個分支';

  @override
  String get toggleVariationArrows => '切換變體箭頭';

  @override
  String get cyclePreviousOrNextVariation => '循環上一個/下一個變體';

  @override
  String get toggleGlyphAnnotations => '切換圖形標註';

  @override
  String get variationArrowsInfo => '變體箭頭讓你不需棋步列表導航';

  @override
  String get playSelectedMove => '走已選的棋步';

  @override
  String get newTournament => '新比赛';

  @override
  String get tournamentHomeTitle => '国际象棋赛事均设有不同的时间控制和变体';

  @override
  String get tournamentHomeDescription => '加入快節奏的國際象棋比賽！加入定時賽事，或創建自己的。子彈，閃電，經典，菲舍爾任意制，王到中心，三次將軍，並提供更多的選擇為無盡的國際象棋樂趣。';

  @override
  String get tournamentNotFound => '找不到该比赛';

  @override
  String get tournamentDoesNotExist => '这个比赛不存在。';

  @override
  String get tournamentMayHaveBeenCanceled => '它可能已被取消，假如所有的对手在比赛开始之前离开。';

  @override
  String get returnToTournamentsHomepage => '返回比赛主页';

  @override
  String weeklyPerfTypeRatingDistribution(String param) {
    return '本月$param的分数分布';
  }

  @override
  String yourPerfTypeRatingIsRating(String param1, String param2) {
    return '您的$param1分数是$param2分。';
  }

  @override
  String youAreBetterThanPercentOfPerfTypePlayers(String param1, String param2) {
    return '您比$param1的$param2棋手更强。';
  }

  @override
  String userIsBetterThanPercentOfPerfTypePlayers(String param1, String param2, String param3) {
    return '$param1比$param3之中的$param2棋手強。';
  }

  @override
  String betterThanPercentPlayers(String param1, String param2) {
    return '您比$param1的$param2棋手更強。';
  }

  @override
  String youDoNotHaveAnEstablishedPerfTypeRating(String param) {
    return '您没有准确的$param评级。';
  }

  @override
  String get yourRating => '您的評分';

  @override
  String get cumulative => '平均累積';

  @override
  String get glicko2Rating => 'Glicko-2 積分';

  @override
  String get checkYourEmail => '請檢查您的電子郵件';

  @override
  String get weHaveSentYouAnEmailClickTheLink => '我們已經發送了一封電子郵件到你的郵箱. 點擊郵件中的連結以激活您的賬號.';

  @override
  String get ifYouDoNotSeeTheEmailCheckOtherPlaces => '若您沒收到郵件，請檢查您的其他收件箱，例如垃圾箱、促銷、社交等。';

  @override
  String weHaveSentYouAnEmailTo(String param) {
    return '我們發送了一封郵件到 $param。點擊郵件中的連結來重置您的密碼。';
  }

  @override
  String byRegisteringYouAgreeToBeBoundByOur(String param) {
    return '您一登记，我们就假设您同意尊重我们的使用规则（$param）。';
  }

  @override
  String readAboutOur(String param) {
    return '閱讀我們的$param';
  }

  @override
  String get networkLagBetweenYouAndLichess => '您和 lichess 之間的網絡時滯';

  @override
  String get timeToProcessAMoveOnLichessServer => 'lichess 伺服器上處理走棋的時間';

  @override
  String get downloadAnnotated => '下载带笔记的记录';

  @override
  String get downloadRaw => '下载无笔记的记录';

  @override
  String get downloadImported => '下载已导入棋局';

  @override
  String get crosstable => '历史表';

  @override
  String get youCanAlsoScrollOverTheBoardToMoveInTheGame => '您也可以用滚动键在棋盘游戏中移动。';

  @override
  String get scrollOverComputerVariationsToPreviewThem => '將鼠標移到電腦分析變招上進行預覽';

  @override
  String get analysisShapesHowTo => '按shift点击或右键棋盘上绘制圆圈和箭头。';

  @override
  String get letOtherPlayersMessageYou => '允許其他人發送私訊給您';

  @override
  String get receiveForumNotifications => '在論壇中被提及時接收通知';

  @override
  String get shareYourInsightsData => '分享您的慧眼数据';

  @override
  String get withNobody => '不分享';

  @override
  String get withFriends => '與好友分享';

  @override
  String get withEverybody => '與所有人分享';

  @override
  String get kidMode => '兒童模式';

  @override
  String get kidModeIsEnabled => '已啓用兒童模式';

  @override
  String get kidModeExplanation => '考量安全，在兒童模式中，網站上全部的文字交流將會被關閉。開啟此模式來保護你的孩子及學生不被網路上的人傷害。';

  @override
  String inKidModeTheLichessLogoGetsIconX(String param) {
    return '在兒童模式下，Lichess的標誌會有一個$param圖示，讓你知道你的孩子是安全的。';
  }

  @override
  String get askYourChessTeacherAboutLiftingKidMode => '你的帳戶被管理，詢問你的老師解除兒童模式。';

  @override
  String get enableKidMode => '啟用兒童模式';

  @override
  String get disableKidMode => '停用兒童模式';

  @override
  String get security => '資訊安全相關設定';

  @override
  String get sessions => '會話';

  @override
  String get revokeAllSessions => '登出所有裝置';

  @override
  String get playChessEverywhere => '随处下棋！';

  @override
  String get asFreeAsLichess => '完全又永遠的免費。';

  @override
  String get builtForTheLoveOfChessNotMoney => '不是為了錢，是為了國際象棋所創建。';

  @override
  String get everybodyGetsAllFeaturesForFree => '每個人都能免費使用所有功能';

  @override
  String get zeroAdvertisement => '沒有廣告';

  @override
  String get fullFeatured => '功能全面';

  @override
  String get phoneAndTablet => '手機和平板電腦';

  @override
  String get bulletBlitzClassical => '子彈，閃電，經典';

  @override
  String get correspondenceChess => '通訊賽';

  @override
  String get onlineAndOfflinePlay => '線上或離線下棋';

  @override
  String get viewTheSolution => '看解答';

  @override
  String get followAndChallengeFriends => '添加好友並與他們對戰';

  @override
  String get gameAnalysis => '棋局分析研究';

  @override
  String xHostsY(String param1, String param2) {
    return '$param1主持$param2';
  }

  @override
  String xJoinsY(String param1, String param2) {
    return '$param1加入$param2';
  }

  @override
  String xLikesY(String param1, String param2) {
    return '$param1對$param2按讚';
  }

  @override
  String get quickPairing => '快速配對';

  @override
  String get lobby => '大廳';

  @override
  String get anonymous => '匿名用户';

  @override
  String yourScore(String param) {
    return '您的分數:$param';
  }

  @override
  String get language => '語言';

  @override
  String get background => '背景';

  @override
  String get light => '亮';

  @override
  String get dark => '暗';

  @override
  String get transparent => '透明度';

  @override
  String get deviceTheme => '設備主題';

  @override
  String get backgroundImageUrl => '背景圖片網址:';

  @override
  String get pieceSet => '棋子外觀設定';

  @override
  String get embedInYourWebsite => '嵌入您的網站';

  @override
  String get usernameAlreadyUsed => '此用戶名已經有人在使用，請嘗試使用別的';

  @override
  String get usernamePrefixInvalid => '使用者名稱必須以字母開頭';

  @override
  String get usernameSuffixInvalid => '使用者名稱的結尾必須為字母或數字';

  @override
  String get usernameCharsInvalid => '使用者名稱只能包含字母、 數字、 底線和短劃線。';

  @override
  String get usernameUnacceptable => '此使用者名稱不可用';

  @override
  String get playChessInStyle => '下棋也要穿得好看';

  @override
  String get chessBasics => '基本知識';

  @override
  String get coaches => '教練';

  @override
  String get invalidPgn => '無效的PGN';

  @override
  String get invalidFen => '無效的FEN';

  @override
  String get custom => '自訂設定';

  @override
  String get notifications => '通知';

  @override
  String notificationsX(String param1) {
    return '通知: $param1';
  }

  @override
  String perfRatingX(String param) {
    return '評分:$param';
  }

  @override
  String get practiceWithComputer => '和電腦練習';

  @override
  String anotherWasX(String param) {
    return '另一個是$param';
  }

  @override
  String bestWasX(String param) {
    return '最好的一步是$param';
  }

  @override
  String get youBrowsedAway => '您暫停了剛剛的進度';

  @override
  String get resumePractice => '繼續練習';

  @override
  String get drawByFiftyMoves => '對局因 50 步規則判和。';

  @override
  String get theGameIsADraw => '這是一場平局';

  @override
  String get computerThinking => '電腦運算中...';

  @override
  String get seeBestMove => '觀看最佳移動';

  @override
  String get hideBestMove => '隱藏最佳移動';

  @override
  String get getAHint => '得到提示';

  @override
  String get evaluatingYourMove => '分析您的移動';

  @override
  String get whiteWinsGame => '白方獲勝';

  @override
  String get blackWinsGame => '黑方獲勝';

  @override
  String get learnFromYourMistakes => '從您的失誤中學習';

  @override
  String get learnFromThisMistake => '從您的失誤中學習';

  @override
  String get skipThisMove => '跳過這一步';

  @override
  String get next => '下一個';

  @override
  String xWasPlayed(String param) {
    return '走了$param';
  }

  @override
  String get findBetterMoveForWhite => '找出白方的最佳著法';

  @override
  String get findBetterMoveForBlack => '找出黑方的最佳著法';

  @override
  String get resumeLearning => '回復學習';

  @override
  String get youCanDoBetter => '您還可以做得更好';

  @override
  String get tryAnotherMoveForWhite => '嘗試白方更好其他的著法';

  @override
  String get tryAnotherMoveForBlack => '嘗試黑方更好其他的著法';

  @override
  String get solution => '解決方案';

  @override
  String get waitingForAnalysis => '等待分析';

  @override
  String get noMistakesFoundForWhite => '沒有找到白方的失誤';

  @override
  String get noMistakesFoundForBlack => '沒有找到黑方的失誤';

  @override
  String get doneReviewingWhiteMistakes => '已完成觀看白方的失誤';

  @override
  String get doneReviewingBlackMistakes => '已完成觀看黑方的失誤';

  @override
  String get doItAgain => '重作一次';

  @override
  String get reviewWhiteMistakes => '複習白方失誤';

  @override
  String get reviewBlackMistakes => '複習黑方失誤';

  @override
  String get advantage => '優勢';

  @override
  String get opening => '開局';

  @override
  String get middlegame => '中場';

  @override
  String get endgame => '殘局';

  @override
  String get conditionalPremoves => '預設棋譜';

  @override
  String get addCurrentVariation => '加入現有變化';

  @override
  String get playVariationToCreateConditionalPremoves => '著一步不同的位置以創建預估走位';

  @override
  String get noConditionalPremoves => '無預設棋譜';

  @override
  String playX(String param) {
    return '移動至$param';
  }

  @override
  String get showUnreadLichessMessage => '你收到一個來自 Lichess 的私人信息。';

  @override
  String get clickHereToReadIt => '點擊閱讀';

  @override
  String get sorry => '抱歉:(';

  @override
  String get weHadToTimeYouOutForAWhile => '您被封鎖了，在一陣子的時間內將不能下棋';

  @override
  String get why => '為什麼？';

  @override
  String get pleasantChessExperience => '我們的目的在於為所有人提供愉快的國際象棋體驗';

  @override
  String get goodPractice => '為此，我們必須確保所有參與者都遵循良好做法';

  @override
  String get potentialProblem => '當檢測到不良行為時，我們將顯示此消息';

  @override
  String get howToAvoidThis => '如何避免這件事發生?';

  @override
  String get playEveryGame => '下好每一盤您加入的棋';

  @override
  String get tryToWin => '試著在每個棋局裡獲勝(或至少平手)';

  @override
  String get resignLostGames => '棄權(不要讓時間耗盡)';

  @override
  String get temporaryInconvenience => '對於給您帶來的不便，我們深表歉意';

  @override
  String get wishYouGreatGames => '並祝您在lichess.org上玩得開心。';

  @override
  String get thankYouForReading => '感謝您的閱讀!';

  @override
  String get lifetimeScore => '帳戶總分';

  @override
  String get currentMatchScore => '現時的對局分數';

  @override
  String get agreementAssistance => '我同意我不會在比賽期間使用支援(從書籍、電腦運算、資料庫等等)';

  @override
  String get agreementNice => '我會一直尊重其他的玩家';

  @override
  String agreementMultipleAccounts(String param) {
    return '我同意我不會開設多個帳號(除了於$param列明的原因以外)';
  }

  @override
  String get agreementPolicy => '我同意我將會遵守Lichess的規則';

  @override
  String get searchOrStartNewDiscussion => '尋找或開始聊天';

  @override
  String get edit => '編輯';

  @override
  String get blitz => '快棋';

  @override
  String get rapid => '快速模式';

  @override
  String get classical => '經典';

  @override
  String get ultraBulletDesc => '瘋狂速度模式: 低於30秒';

  @override
  String get bulletDesc => '非常速度模式:低於3分鐘';

  @override
  String get blitzDesc => '快速模式:3到8分鐘';

  @override
  String get rapidDesc => '一般模式:8到25分鐘';

  @override
  String get classicalDesc => '經典模式:25分鐘以上';

  @override
  String get correspondenceDesc => '長期模式:一天或好幾天一步';

  @override
  String get puzzleDesc => '西洋棋戰術教練';

  @override
  String get important => '重要';

  @override
  String yourQuestionMayHaveBeenAnswered(String param1) {
    return '您的問題可能已經有答案了$param1';
  }

  @override
  String get inTheFAQ => '在F.A.Q裡';

  @override
  String toReportSomeoneForCheatingOrBadBehavior(String param1) {
    return '舉報一位作弊或者是不良行為的玩家，$param1';
  }

  @override
  String get useTheReportForm => '請造訪回報頁面';

  @override
  String toRequestSupport(String param1) {
    return '需要請求協助，$param1';
  }

  @override
  String get tryTheContactPage => '請到協助頁面';

  @override
  String makeSureToRead(String param1) {
    return '確保你已閱讀 $param1';
  }

  @override
  String get theForumEtiquette => '論壇禮儀';

  @override
  String get thisTopicIsArchived => '該討論已封存，不能再留言';

  @override
  String joinTheTeamXToPost(String param1) {
    return '請先加入$param1團隊，才能在這則討論裡發表留言';
  }

  @override
  String teamNamedX(String param1) {
    return '$param1團隊';
  }

  @override
  String get youCannotPostYetPlaySomeGames => '您目前不能發表文章在論壇裡，先下幾盤棋吧!';

  @override
  String get subscribe => '訂閱';

  @override
  String get unsubscribe => '取消訂閱';

  @override
  String mentionedYouInX(String param1) {
    return '在 \"$param1\" 中提到了您。';
  }

  @override
  String xMentionedYouInY(String param1, String param2) {
    return '$param1 在 \"$param2\" 中提到了您。';
  }

  @override
  String invitedYouToX(String param1) {
    return '邀請您至\"$param1\"。';
  }

  @override
  String xInvitedYouToY(String param1, String param2) {
    return '$param1 邀請您至\"$param2\"。';
  }

  @override
  String get youAreNowPartOfTeam => '您現在是團隊的成員了。';

  @override
  String youHaveJoinedTeamX(String param1) {
    return '您已加入 \"$param1\"。';
  }

  @override
  String get someoneYouReportedWasBanned => '您檢舉的玩家已被封鎖帳號';

  @override
  String get congratsYouWon => '恭喜，您贏了！';

  @override
  String gameVsX(String param1) {
    return '與$param1對局';
  }

  @override
  String resVsX(String param1, String param2) {
    return '$param1 vs $param2';
  }

  @override
  String get lostAgainstTOSViolator => '你輸給了違反了服務挑款的棋手';

  @override
  String refundXpointsTimeControlY(String param1, String param2) {
    return '退回 $param1 $param2 等級分。';
  }

  @override
  String get timeAlmostUp => '時間快到了！';

  @override
  String get clickToRevealEmailAddress => '[按下展示電郵位置]';

  @override
  String get download => '下載';

  @override
  String get coachManager => '教練管理';

  @override
  String get streamerManager => '直播管理';

  @override
  String get cancelTournament => '取消錦標賽';

  @override
  String get tournDescription => '錦標賽敘述';

  @override
  String get tournDescriptionHelp => '有甚麼特別要告訴參賽者的嗎？盡量不要太長。可以使用Markdown網址 [name](https://url)。';

  @override
  String get ratedFormHelp => '比賽為積分賽\n會影響到棋手的積分';

  @override
  String get onlyMembersOfTeam => '只限隊員';

  @override
  String get noRestriction => '沒有限制';

  @override
  String get minimumRatedGames => '評分局遊玩次數下限';

  @override
  String get minimumRating => '評分下限';

  @override
  String get maximumWeeklyRating => '每週最高評分';

  @override
  String positionInputHelp(String param) {
    return '將一個有效的 FEN 粘貼於此作為所有對局的起始位置。\n僅適用於標準國際象棋，對變體無效。\n你可以試用 $param 來生成 FEN，然後將其粘貼到這裡。\n置空表示以標準位置開始比賽。';
  }

  @override
  String get cancelSimul => '取消車輪戰';

  @override
  String get simulHostcolor => '主持所執方';

  @override
  String get estimatedStart => '預計開始時間';

  @override
  String simulFeatured(String param) {
    return '展示在 $param';
  }

  @override
  String simulFeaturedHelp(String param) {
    return '在 $param 上向所有人展示您主持的車輪戰，對私人車輪戰無效。';
  }

  @override
  String get simulDescription => '車輪戰描述';

  @override
  String get simulDescriptionHelp => '有甚麼要告訴參賽者的嗎？';

  @override
  String markdownAvailable(String param) {
    return '$param 可用於更高級的格式。';
  }

  @override
  String get embedsAvailable => '粘貼對局URL或學習章節URL來嵌入。';

  @override
  String get inYourLocalTimezone => '在你的時區內';

  @override
  String get tournChat => '錦標賽聊天室';

  @override
  String get noChat => '無聊天室';

  @override
  String get onlyTeamLeaders => '僅限各隊隊長';

  @override
  String get onlyTeamMembers => '僅限各隊伍';

  @override
  String get navigateMoveTree => '定位';

  @override
  String get mouseTricks => '滑鼠功能';

  @override
  String get toggleLocalAnalysis => '切換本地計算機分析';

  @override
  String get toggleAllAnalysis => '切換所有(本地+服務器) 的電腦分析';

  @override
  String get playComputerMove => '走電腦推薦的最佳著法';

  @override
  String get analysisOptions => '分析局面';

  @override
  String get focusChat => '聚焦聊天';

  @override
  String get showHelpDialog => '顯示此說明欄';

  @override
  String get reopenYourAccount => '重新開啟帳戶';

  @override
  String get closedAccountChangedMind => '如果你停用了自己的帳號，但是改變了心意，你有一次的機會可以拿回帳號。';

  @override
  String get onlyWorksOnce => '這只能復原一次';

  @override
  String get cantDoThisTwice => '如果你決定再次停用你的帳號，則不會有任何方式去復原。';

  @override
  String get emailAssociatedToaccount => '和此帳號相關的電子信箱';

  @override
  String get sentEmailWithLink => '我們已將網址寄送至你的信箱';

  @override
  String get tournamentEntryCode => '錦標賽參賽碼';

  @override
  String get hangOn => '等一下！';

  @override
  String gameInProgress(String param) {
    return '您正在與 $param 進行對局。';
  }

  @override
  String get abortTheGame => '中止本局';

  @override
  String get resignTheGame => '認輸';

  @override
  String get youCantStartNewGame => '直到當下這局下完之前，你無法開始新的棋局';

  @override
  String get since => '自';

  @override
  String get until => '直到';

  @override
  String get lichessDbExplanation => '來自 Lichess 用戶的所有評分遊戲';

  @override
  String get switchSides => '更換所持顏色';

  @override
  String get closingAccountWithdrawAppeal => '關閉帳戶將會收回你的上訴';

  @override
  String get ourEventTips => '舉辦賽事的小建議';

  @override
  String get instructions => '說明';

  @override
  String get showMeEverything => '全部顯示';

  @override
  String get lichessPatronInfo => 'Lichess是個慈善、完全免費之開源軟件。\n一切營運成本、開發和內容皆來自用戶之捐贈。';

  @override
  String opponentLeftCounter(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '您的對手已經離開了遊戲。您將在 $count 秒後獲勝。',
    );
    return '$_temp0';
  }

  @override
  String mateInXHalfMoves(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '在$count步內將死對手',
    );
    return '$_temp0';
  }

  @override
  String nbBlunders(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 次漏著',
    );
    return '$_temp0';
  }

  @override
  String nbMistakes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 次失誤',
    );
    return '$_temp0';
  }

  @override
  String nbInaccuracies(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 次輕微失誤',
    );
    return '$_temp0';
  }

  @override
  String nbPlayers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count位棋手目前在線',
    );
    return '$_temp0';
  }

  @override
  String nbGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '查看所有$count盤棋',
    );
    return '$_temp0';
  }

  @override
  String ratingXOverYGames(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$param2 場對局後的 $count 等級分',
    );
    return '$_temp0';
  }

  @override
  String nbBookmarks(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count個收藏',
    );
    return '$_temp0';
  }

  @override
  String nbDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count天',
    );
    return '$_temp0';
  }

  @override
  String nbHours(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count小時',
    );
    return '$_temp0';
  }

  @override
  String nbMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 分鐘',
    );
    return '$_temp0';
  }

  @override
  String rankIsUpdatedEveryNbMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '評分每 $count 分鐘更新一次',
    );
    return '$_temp0';
  }

  @override
  String nbPuzzles(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count個題目',
    );
    return '$_temp0';
  }

  @override
  String nbGamesWithYou(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '與您下過$count盤棋',
    );
    return '$_temp0';
  }

  @override
  String nbRated(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 場排位賽',
    );
    return '$_temp0';
  }

  @override
  String nbWins(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count局勝',
    );
    return '$_temp0';
  }

  @override
  String nbLosses(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count局負',
    );
    return '$_temp0';
  }

  @override
  String nbDraws(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count局和',
    );
    return '$_temp0';
  }

  @override
  String nbPlaying(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count下棋中',
    );
    return '$_temp0';
  }

  @override
  String giveNbSeconds(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '給對方加$count秒',
    );
    return '$_temp0';
  }

  @override
  String nbTournamentPoints(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count錦標賽得分',
    );
    return '$_temp0';
  }

  @override
  String nbStudies(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count個研究',
    );
    return '$_temp0';
  }

  @override
  String nbSimuls(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 個進行的車輪戰棋局',
    );
    return '$_temp0';
  }

  @override
  String moreThanNbRatedGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '完成至少 $count 場排位賽',
    );
    return '$_temp0';
  }

  @override
  String moreThanNbPerfRatedGames(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '≥ $count $param2 排位賽',
    );
    return '$_temp0';
  }

  @override
  String needNbMorePerfGames(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '你需要再下 $count 局 $param2 變體的排位賽',
    );
    return '$_temp0';
  }

  @override
  String needNbMoreGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '您需要再完成 $count 場排位賽',
    );
    return '$_temp0';
  }

  @override
  String nbImportedGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '已導入$count盤棋局',
    );
    return '$_temp0';
  }

  @override
  String nbFriendsOnline(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 位好友在線',
    );
    return '$_temp0';
  }

  @override
  String nbFollowers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count個關注者',
    );
    return '$_temp0';
  }

  @override
  String nbFollowing(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '關注$count人',
    );
    return '$_temp0';
  }

  @override
  String lessThanNbMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '小於$count分鐘',
    );
    return '$_temp0';
  }

  @override
  String nbGamesInPlay(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count場對局正在進行中',
    );
    return '$_temp0';
  }

  @override
  String maximumNbCharacters(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '最多$count个字符',
    );
    return '$_temp0';
  }

  @override
  String blocks(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count位黑名单用户',
    );
    return '$_temp0';
  }

  @override
  String nbForumPosts(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count個論壇貼文',
    );
    return '$_temp0';
  }

  @override
  String nbPerfTypePlayersThisWeek(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '本周$count位棋手下了$param2模式的棋局',
    );
    return '$_temp0';
  }

  @override
  String availableInNbLanguages(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '支援$count種語言！',
    );
    return '$_temp0';
  }

  @override
  String nbSecondsToPlayTheFirstMove(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '在$count秒前須下出第一步',
    );
    return '$_temp0';
  }

  @override
  String nbSeconds(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 秒',
    );
    return '$_temp0';
  }

  @override
  String andSaveNbPremoveLines(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '以儲存$count列預走的棋步',
    );
    return '$_temp0';
  }

  @override
  String get stormMoveToStart => '移動以開始';

  @override
  String get stormYouPlayTheWhitePiecesInAllPuzzles => '您將在所有謎題中執白';

  @override
  String get stormYouPlayTheBlackPiecesInAllPuzzles => '您將在所有謎題中執黑';

  @override
  String get stormPuzzlesSolved => '已解決題目！';

  @override
  String get stormNewDailyHighscore => '新的每日紀錄！';

  @override
  String get stormNewWeeklyHighscore => '新的每周紀錄！';

  @override
  String get stormNewMonthlyHighscore => '新的每月紀錄！';

  @override
  String get stormNewAllTimeHighscore => '新歷史紀錄！';

  @override
  String stormPreviousHighscoreWasX(String param) {
    return '之前的紀錄:$param';
  }

  @override
  String get stormPlayAgain => '再玩一次';

  @override
  String stormHighscoreX(String param) {
    return '最高紀錄:$param';
  }

  @override
  String get stormScore => '得分';

  @override
  String get stormMoves => '走棋';

  @override
  String get stormAccuracy => '精準度';

  @override
  String get stormCombo => '連擊';

  @override
  String get stormTime => '時間';

  @override
  String get stormTimePerMove => '平均走棋時間';

  @override
  String get stormHighestSolved => '最難解決的題目';

  @override
  String get stormPuzzlesPlayed => '解決過的題目';

  @override
  String get stormNewRun => '新的一輪 (快捷鍵:空白鍵)';

  @override
  String get stormEndRun => '結束此輪 (快捷鍵:Enter鍵)';

  @override
  String get stormHighscores => '最高紀錄';

  @override
  String get stormViewBestRuns => '顯示最佳的一輪';

  @override
  String get stormBestRunOfDay => '今日最佳的一輪';

  @override
  String get stormRuns => '輪';

  @override
  String get stormGetReady => '做好準備！';

  @override
  String get stormWaitingForMorePlayers => '等待更多玩家加入...';

  @override
  String get stormRaceComplete => '完賽！';

  @override
  String get stormSpectating => '觀戰中';

  @override
  String get stormJoinTheRace => '加入競賽！';

  @override
  String get stormStartTheRace => '開始比賽';

  @override
  String stormYourRankX(String param) {
    return '你的排名: $param';
  }

  @override
  String get stormWaitForRematch => '等候重賽';

  @override
  String get stormNextRace => '下一場競賽';

  @override
  String get stormJoinRematch => '再來一局';

  @override
  String get stormWaitingToStart => '等待開始';

  @override
  String get stormCreateNewGame => '開始新遊戲';

  @override
  String get stormJoinPublicRace => '加入公開比賽';

  @override
  String get stormRaceYourFriends => '和好友比賽';

  @override
  String get stormSkip => '跳過';

  @override
  String get stormSkipHelp => '每場賽可略一手棋';

  @override
  String get stormSkipExplanation => '跳過這一步來維持您的連擊紀錄！每次遊玩只能使用一次。';

  @override
  String get stormFailedPuzzles => '失敗了的謎題';

  @override
  String get stormSlowPuzzles => '慢 謎題';

  @override
  String get stormThisWeek => '本星期';

  @override
  String get stormThisMonth => '本月';

  @override
  String get stormAllTime => '總計';

  @override
  String get stormClickToReload => '點擊以重新加載';

  @override
  String get stormThisRunHasExpired => '本次比賽已過期！';

  @override
  String get stormThisRunWasOpenedInAnotherTab => '本次沖刺已經在另一個標籤頁中打開！';

  @override
  String stormXRuns(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count輪',
    );
    return '$_temp0';
  }

  @override
  String stormPlayedNbRunsOfPuzzleStorm(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '玩了$count輪的$param2',
    );
    return '$_temp0';
  }

  @override
  String get streamerLichessStreamers => 'Lichess實況主';

  @override
  String get studyShareAndExport => '分享 & 導出';

  @override
  String get studyStart => '開始';
}
