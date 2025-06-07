// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'l10n.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get mobileAccountPreferences => 'Account preferences';

  @override
  String get mobileAccountPreferencesHelp =>
      'These preferences are applied to your Lichess account and will be used across all devices.';

  @override
  String get mobileAllGames => '所有对局';

  @override
  String get mobileAreYouSure => '你确定吗？';

  @override
  String get mobileBoardSettings => 'Board settings';

  @override
  String get mobileCancelTakebackOffer => '取消悔棋请求';

  @override
  String get mobileClearButton => '清空';

  @override
  String get mobileCorrespondenceClearSavedMove => '清除已保存的着法';

  @override
  String get mobileCustomGameJoinAGame => '加入一局游戏';

  @override
  String get mobileFeedbackButton => '问题反馈';

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
  String get mobileHideVariation => '隐藏变着';

  @override
  String get mobileHomeTab => '主页';

  @override
  String get mobileLiveStreamers => '主播';

  @override
  String get mobileMustBeLoggedIn => '您必须登录才能浏览此页面。';

  @override
  String get mobileNoSearchResults => '无结果';

  @override
  String get mobileNotFollowingAnyUser => '你没有关注任何用户。';

  @override
  String get mobileOkButton => '好';

  @override
  String get mobileOverTheBoard => 'Over the board';

  @override
  String mobilePlayersMatchingSearchTerm(String param) {
    return '包含\"$param\"名称的棋手';
  }

  @override
  String get mobilePositionLeft => 'Left';

  @override
  String get mobilePositionRight => 'Right';

  @override
  String get mobilePrefMagnifyDraggedPiece => '放大正在拖动的棋子';

  @override
  String get mobilePuzzleStormConfirmEndRun => '你想结束这组谜题风暴吗？';

  @override
  String get mobilePuzzleStormFilterNothingToShow => '没有结果，请更改筛选条件';

  @override
  String get mobilePuzzleStormNothingToShow => '没有记录。 请下几组谜题风暴。';

  @override
  String get mobilePuzzleStormSubtitle => '在 3 分钟内解开尽可能多的谜题。';

  @override
  String get mobilePuzzleStreakAbortWarning => '你将失去你目前的连胜，你的分数将被保存。';

  @override
  String get mobilePuzzleThemesSubtitle => '从你最喜欢的开局解决谜题，或选择一个主题。';

  @override
  String get mobilePuzzlesTab => '谜题';

  @override
  String get mobileRecentSearches => '最近搜索';

  @override
  String get mobileRemoveBookmark => 'Remove bookmark';

  @override
  String get mobileSettingsClockPosition => 'Clock position';

  @override
  String get mobileSettingsCustomBackgroundPresets => 'Presets';

  @override
  String get mobileSettingsDraggedPieceTarget => 'Dragged piece target';

  @override
  String get mobileSettingsDraggedTargetCircle => 'Circle';

  @override
  String get mobileSettingsDraggedTargetSquare => 'Square';

  @override
  String get mobileSettingsHomeWidgets => 'Home widgets';

  @override
  String get mobileSettingsImmersiveMode => '沉浸模式';

  @override
  String get mobileSettingsImmersiveModeSubtitle =>
      '下棋时隐藏系统界面。 如果您的操作受到屏幕边缘的系统导航手势干扰，请使用此功能。 适用于棋局和谜题风暴界面。';

  @override
  String get mobileSettingsMaterialDifferenceCapturedPieces => 'Captured pieces';

  @override
  String get mobileSettingsPickAnImage => 'Pick an image';

  @override
  String get mobileSettingsPickAnImageHelp =>
      'Custom background works only in dark mode. A dark image is recommended.';

  @override
  String get mobileSettingsPickAnImageBlur => 'Blur the image';

  @override
  String get mobileSettingsPickAnImageHideBoard => 'Hide board';

  @override
  String get mobileSettingsPickAnImageShowBoard => 'Show board';

  @override
  String get mobileSettingsPickAnImageSwipeToDisplay => 'Swipe to display other backgrounds';

  @override
  String get mobileSettingsPieceShiftMethodEither => 'Either tap or drag';

  @override
  String get mobileSettingsPieceShiftMethodTapTwoSquares => 'Tap two squares';

  @override
  String get mobileSettingsShapeDrawing => 'Shape drawing';

  @override
  String get mobileSettingsShapeDrawingSubtitle =>
      'Draw shapes using two fingers: maintain one finger on an empty square and drag another finger to draw a shape.';

  @override
  String get mobileSettingsShowBorder => 'Show border';

  @override
  String get mobileSettingsTouchFeedback => 'Touch feedback';

  @override
  String get mobileSettingsTouchFeedbackSubtitle =>
      'When enabled, the device will vibrate shortly when you move or capture a piece.';

  @override
  String get mobileSettingsTab => '设置';

  @override
  String get mobileShareGamePGN => '分享 PGN';

  @override
  String get mobileShareGameURL => '分享棋局链接';

  @override
  String get mobileSharePositionAsFEN => '保存局面为 FEN';

  @override
  String get mobileSharePuzzle => '分享这个谜题';

  @override
  String get mobileShowComments => '显示评论';

  @override
  String get mobileShowResult => '显示结果';

  @override
  String get mobileShowVariations => '显示变着';

  @override
  String get mobileSomethingWentWrong => '出了一些问题。';

  @override
  String get mobileSystemColors => '系统颜色';

  @override
  String get mobileTapHereToStartPlayingChess => 'Tap here to start playing chess.';

  @override
  String get mobileTheme => '主题';

  @override
  String get mobileToolsTab => '工具';

  @override
  String mobileUnsupportedVariant(String param) {
    return 'Variant $param is not supported in this version.';
  }

  @override
  String get mobileWaitingForOpponentToJoin => '正在等待对手加入...';

  @override
  String get mobileWatchTab => '观看';

  @override
  String get mobileWelcomeToLichessApp => 'Welcome to Lichess app!';

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
    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '解决了 $count 道谜题');
    return '$_temp0';
  }

  @override
  String activityPlayedNbGames(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '下了 $count 局 $param2');
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
    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '下了 $count 手棋');
    return '$_temp0';
  }

  @override
  String activityInNbCorrespondenceGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '在 $count 局通讯棋局中');
    return '$_temp0';
  }

  @override
  String activityCompletedNbGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '完成了 $count 盘通讯棋');
    return '$_temp0';
  }

  @override
  String activityCompletedNbVariantGames(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '下完了$count$param2局通信棋局',
    );
    return '$_temp0';
  }

  @override
  String activityFollowedNbPlayers(int count) {
    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '新关注 $count 个用户');
    return '$_temp0';
  }

  @override
  String activityGainedNbFollowers(int count) {
    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '新增 $count 个关注者');
    return '$_temp0';
  }

  @override
  String activityHostedNbSimuls(int count) {
    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '主持了 $count 场车轮战');
    return '$_temp0';
  }

  @override
  String activityJoinedNbSimuls(int count) {
    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '参与了 $count 场车轮战');
    return '$_temp0';
  }

  @override
  String activityCreatedNbStudies(int count) {
    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '创建了 $count 个新的研讨');
    return '$_temp0';
  }

  @override
  String activityCompetedInNbTournaments(int count) {
    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '参与了 $count 场锦标赛');
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
    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '加入了 $count 个团队');
    return '$_temp0';
  }

  @override
  String get arenaArena => '竞技场';

  @override
  String get arenaArenaTournaments => '竞技场';

  @override
  String get arenaIsItRated => '会影响等级分吗？';

  @override
  String get arenaWillBeNotified => '当锦标赛开始时，你将收到通知，所以在其他标签页中下棋是无碍的。';

  @override
  String get arenaIsRated => '本锦标赛为排位赛，会影响你的等级分。';

  @override
  String get arenaIsNotRated => '本锦标赛为休闲赛，不会影响你的等级分。';

  @override
  String get arenaSomeRated => '部分锦标赛是排位赛，会影响你的等级分。';

  @override
  String get arenaHowAreScoresCalculated => '分数是如何计算的？';

  @override
  String get arenaHowAreScoresCalculatedAnswer =>
      '赢局的基础分数是2分，平局1分，输局不得分。如果你连胜两局将开始双倍积分，以火焰图标表示。接下来的对局将继续获得双倍积分，直到你输棋为止。也就是说，在双倍积分的情况下赢局值4分，平局2分。输局仍然不得分。 \n\n例如两场胜利紧接着一场平局得6分： 2 + 2 + (2 x 1)。';

  @override
  String get arenaBerserk => '狂暴锦标赛';

  @override
  String get arenaBerserkAnswer =>
      '如果棋手在棋局开始时点击“狂暴”按钮，将会损失一半的时间，但战胜该局将多得 1 分。\n\n如果棋局时限有加秒，那么启动狂暴会导致神速方加秒被取消。(唯一的例外是 1+2, 在这个情况下启动神速会把神速方的时限变为 1+0)。\n\n在无基础局时的棋局 (如 0+1、0+2 等) ，狂暴功能被禁用。\n\n只有走过 7 步棋以上的棋局会有狂暴加分。';

  @override
  String get arenaHowIsTheWinnerDecided => '赢家是如何决定的？';

  @override
  String get arenaHowIsTheWinnerDecidedAnswer =>
      '在锦标赛设定时间限制结束时积分最多的玩家将被宣布为获胜者。\n\n当两个或两个以上的玩家拥有相同分数时，锦标赛的表现是決勝。';

  @override
  String get arenaHowDoesPairingWork => '棋手是怎么配对的？';

  @override
  String get arenaHowDoesPairingWorkAnswer =>
      '在锦标赛开始时，系统会根据棋手的等级分进行配对。一局结束后，回到锦标赛主页等待。此后你会和与你锦标赛名次接近的棋手配对，这尽可能降低了等待时间。然而，你不一定会和锦标赛所有其他棋手下棋。\n\n为了下更多的棋局以得到更多的锦标赛积分，尽量快地下完每一盘棋并回到主页。';

  @override
  String get arenaHowDoesItEnd => '锦标赛如何结束？';

  @override
  String get arenaHowDoesItEndAnswer =>
      '锦标赛有倒计时。当它到零的时候锦标赛名次不再变动，赢家就确定了。此时未下完的棋局必须下完但这些棋局不计入锦标赛分数。';

  @override
  String get arenaOtherRules => '其他重要规则';

  @override
  String get arenaThereIsACountdown => '第一次移动有时间限制。规定时间内未能采取行动将会转由对手操作。';

  @override
  String get arenaThisIsPrivate => '这是一个私人锦标赛';

  @override
  String arenaShareUrl(String param) {
    return '分享本链接让其他人加入本锦标赛：$param';
  }

  @override
  String arenaDrawStreakStandard(String param) {
    return '连和场数：当棋手在竞技场中连续和棋时，只有第一次和棋或者超过 $param 步的和局才会计分。连和场数只能被胜利打破，不会被输棋或和棋打破。';
  }

  @override
  String get arenaDrawStreakVariants => '计分的和局的最小步数由不同的变体而变化。下面的表格列出了每个变体的阀值。';

  @override
  String get arenaVariant => '变体';

  @override
  String get arenaMinimumGameLength => '最少棋局步数';

  @override
  String get arenaHistory => '竞技场历史';

  @override
  String get arenaNewTeamBattle => '新团队战';

  @override
  String get arenaCustomStartDate => '自定义开始日期';

  @override
  String get arenaCustomStartDateHelp => '在你的本地时区，这将覆盖 “距比赛开始时间” 选项';

  @override
  String get arenaAllowBerserk => '允许狂暴模式';

  @override
  String get arenaAllowBerserkHelp => '允许玩家将自己的时间减半以获得额外得分';

  @override
  String get arenaAllowChatHelp => '允许玩家在聊天室中讨论';

  @override
  String get arenaArenaStreaks => '连胜奖励';

  @override
  String get arenaArenaStreaksHelp => '连胜两场后，获得4分而不是2分。';

  @override
  String get arenaNoBerserkAllowed => '禁止“狂暴”模式';

  @override
  String get arenaNoArenaStreaks => '取消连胜积分奖励';

  @override
  String get arenaAveragePerformance => '平均表现';

  @override
  String get arenaAverageScore => '平均分数';

  @override
  String get arenaMyTournaments => '我的锦标赛';

  @override
  String get arenaEditTournament => '编辑锦标赛';

  @override
  String get arenaEditTeamBattle => '编辑团队战斗';

  @override
  String get arenaDefender => '防守方';

  @override
  String get arenaPickYourTeam => '请选择您的团队';

  @override
  String get arenaWhichTeamWillYouRepresentInThisBattle => '你将代表哪个团队出战？';

  @override
  String get arenaYouMustJoinOneOfTheseTeamsToParticipate => '您必须加入这些团队之一才能参与！';

  @override
  String get arenaCreated => '创建于';

  @override
  String get arenaRecentlyPlayed => '最近结束';

  @override
  String get arenaBestResults => '最佳结果';

  @override
  String get arenaTournamentStats => '锦标赛统计';

  @override
  String get arenaRankAvgHelp =>
      '等级平均值是您排名的百分比。较低的排名越好。\n\n例如，在 100 个玩家的锦标赛中排名第三名 = 3%。在 1000 个玩家的锦标赛中排名第 10 名 = 1%。';

  @override
  String get arenaMedians => '中位数';

  @override
  String arenaAllAveragesAreX(String param) {
    return '此页面上的所有平均值是 $param。';
  }

  @override
  String get arenaTotal => '总计';

  @override
  String get arenaPointsAvg => '平均分数';

  @override
  String get arenaPointsSum => '总分数';

  @override
  String get arenaRankAvg => '平均等级';

  @override
  String get arenaTournamentWinners => '锦标赛赢家';

  @override
  String get arenaTournamentShields => '锦标赛盾牌';

  @override
  String get arenaOnlyTitled => '仅限有头衔玩家';

  @override
  String get arenaOnlyTitledHelp => '需要官方头衔才能加入比赛';

  @override
  String get arenaTournamentPairingsAreNowClosed => '竞技场配对已关闭。';

  @override
  String get arenaBerserkRate => '狂暴局比例';

  @override
  String arenaDrawingWithinNbMoves(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '前 $count 次移动玩家并不会获得任何积分。',
    );
    return '$_temp0';
  }

  @override
  String arenaViewAllXTeams(int count) {
    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '查看所有 $count 团队');
    return '$_temp0';
  }

  @override
  String get broadcastBroadcasts => '转播';

  @override
  String get broadcastMyBroadcasts => '我的直播';

  @override
  String get broadcastLiveBroadcasts => '赛事转播';

  @override
  String get broadcastBroadcastCalendar => '转播日程表';

  @override
  String get broadcastNewBroadcast => '新建实况转播';

  @override
  String get broadcastSubscribedBroadcasts => '已订阅的转播';

  @override
  String get broadcastAboutBroadcasts => '关于转播';

  @override
  String get broadcastHowToUseLichessBroadcasts => '如何使用 Lichess 转播';

  @override
  String get broadcastTheNewRoundHelp => '新一轮的成员和贡献者将与前一轮相同。';

  @override
  String get broadcastAddRound => '添加一轮';

  @override
  String get broadcastOngoing => '进行中';

  @override
  String get broadcastUpcoming => '即将举行';

  @override
  String get broadcastRoundName => '轮次名称';

  @override
  String get broadcastRoundNumber => '轮数';

  @override
  String get broadcastTournamentName => '锦标赛名称';

  @override
  String get broadcastTournamentDescription => '锦标赛简短描述';

  @override
  String get broadcastFullDescription => '赛事详情';

  @override
  String broadcastFullDescriptionHelp(String param1, String param2) {
    return '转播内容的详细描述 (可选）。可以使用 $param1，字数少于 $param2 个。';
  }

  @override
  String get broadcastSourceSingleUrl => 'PGN 的 URL 源';

  @override
  String get broadcastSourceUrlHelp => 'Lichess 将从该网址搜查 PGN 的更新。它必须是公开的。';

  @override
  String get broadcastSourceGameIds => '多达 64 个 Lichess 棋局 ID，用空格隔开。';

  @override
  String broadcastStartDateTimeZone(String param) {
    return '锦标赛本地时区的开始时间：$param';
  }

  @override
  String get broadcastStartDateHelp => '如果你知道比赛开始时间 (可选)';

  @override
  String get broadcastCurrentGameUrl => '当前棋局链接';

  @override
  String get broadcastDownloadAllRounds => '下载所有棋局';

  @override
  String get broadcastResetRound => '重置此轮';

  @override
  String get broadcastDeleteRound => '删除此轮';

  @override
  String get broadcastDefinitivelyDeleteRound => '确定删除该回合及其游戏。';

  @override
  String get broadcastDeleteAllGamesOfThisRound => '删除此回合的所有游戏。源需要激活才能重新创建。';

  @override
  String get broadcastEditRoundStudy => '编辑该轮次的棋局研究';

  @override
  String get broadcastDeleteTournament => '删除该锦标赛';

  @override
  String get broadcastDefinitivelyDeleteTournament => '确定删除整个锦标赛、所有轮次和其中所有比赛。';

  @override
  String get broadcastShowScores => '根据比赛结果显示棋手分数';

  @override
  String get broadcastReplacePlayerTags => '可选项：替换选手的名字、等级分和头衔';

  @override
  String get broadcastFideFederations => 'FIDE 成员国';

  @override
  String get broadcastTop10Rating => '前 10 名等级分';

  @override
  String get broadcastFidePlayers => 'FIDE 棋手';

  @override
  String get broadcastFidePlayerNotFound => '未找到 FIDE 棋手';

  @override
  String get broadcastFideProfile => 'FIDE 个人资料';

  @override
  String get broadcastFederation => '棋联';

  @override
  String get broadcastAgeThisYear => '今年的年龄';

  @override
  String get broadcastUnrated => '未评级';

  @override
  String get broadcastRecentTournaments => '最近的比赛';

  @override
  String get broadcastOpenLichess => '在 Lichess 中打开';

  @override
  String get broadcastTeams => '团队';

  @override
  String get broadcastBoards => '棋盘';

  @override
  String get broadcastOverview => '概览';

  @override
  String get broadcastSubscribeTitle => '订阅后会在每轮开始时通知。您可以在帐户首选项中切换铃声或推送广播通知。';

  @override
  String get broadcastUploadImage => '上传锦标赛图像';

  @override
  String get broadcastNoBoardsYet => '尚无看板。这些游戏一旦上传就会出现。';

  @override
  String broadcastBoardsCanBeLoaded(String param) {
    return '可以通过 $param加载看板';
  }

  @override
  String broadcastStartsAfter(String param) {
    return '从 $param 开始';
  }

  @override
  String get broadcastStartVerySoon => '转播将很快开始。';

  @override
  String get broadcastNotYetStarted => '转播尚未开始。';

  @override
  String get broadcastOfficialWebsite => '官网';

  @override
  String get broadcastStandings => '积分榜';

  @override
  String get broadcastOfficialStandings => '官方排名';

  @override
  String broadcastIframeHelp(String param) {
    return '$param 上的更多选项';
  }

  @override
  String get broadcastWebmastersPage => '网页管理员页面';

  @override
  String broadcastPgnSourceHelp(String param) {
    return '此回合有公开实时的 PGN 源。我们还提供一个 $param ，用于更快并更有效的同步刷新。';
  }

  @override
  String get broadcastEmbedThisBroadcast => '将此广播嵌入您的网站';

  @override
  String broadcastEmbedThisRound(String param) {
    return '将 $param 嵌入到您的网站';
  }

  @override
  String get broadcastRatingDiff => '积分差别';

  @override
  String get broadcastGamesThisTournament => '这个锦标赛中的游戏';

  @override
  String get broadcastScore => '得分';

  @override
  String get broadcastAllTeams => '所有团队';

  @override
  String get broadcastTournamentFormat => '锦标赛格式';

  @override
  String get broadcastTournamentLocation => '锦标赛地点';

  @override
  String get broadcastTopPlayers => '最强棋手';

  @override
  String get broadcastTimezone => '时区';

  @override
  String get broadcastFideRatingCategory => 'FIDE 评分类别';

  @override
  String get broadcastOptionalDetails => '可填的信息';

  @override
  String get broadcastPastBroadcasts => '结束的转播';

  @override
  String get broadcastAllBroadcastsByMonth => '按月查看所有转播';

  @override
  String get broadcastBackToLiveMove => '回到实时着法';

  @override
  String get broadcastSinceHideResults => '由于您选择隐藏比赛结果，为避免剧透，所有棋局预览均为空白状态。';

  @override
  String get broadcastLiveboard => '实时棋局';

  @override
  String broadcastNbBroadcasts(int count) {
    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '$count 直播');
    return '$_temp0';
  }

  @override
  String broadcastNbViewers(int count) {
    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '$count 名观众');
    return '$_temp0';
  }

  @override
  String challengeChallengesX(String param1) {
    return '挑战：$param1';
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
    return '$param 只接受好友的挑战。';
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
  String get coordinatesCoordinates => '坐标';

  @override
  String get coordinatesCoordinateTraining => '坐标训练';

  @override
  String coordinatesAverageScoreAsWhiteX(String param) {
    return '白方平均得分：$param';
  }

  @override
  String coordinatesAverageScoreAsBlackX(String param) {
    return '黑方平均得分：$param';
  }

  @override
  String get coordinatesKnowingTheChessBoard => '了解棋盘坐标是一门很重要的象棋技能：';

  @override
  String get coordinatesMostChessCourses => '象棋课程及练习普遍使用代数记谱法。';

  @override
  String get coordinatesTalkToYourChessFriends => '这能让您更便捷地与棋友交谈，因为你们都懂这门“象棋语言”。';

  @override
  String get coordinatesYouCanAnalyseAGameMoreEffectively => '快速识别格子可以高效的分析对局。';

  @override
  String get coordinatesACoordinateAppears => '坐标将在棋盘上出现，您必须点击对应的棋格。';

  @override
  String get coordinatesASquareIsHighlightedExplanation => '棋格将在棋盘上高亮显示，您必须输入它的坐标(例如\"e4\")。';

  @override
  String get coordinatesYouHaveThirtySeconds => '您有30秒时间正确配对尽可能多的棋格。';

  @override
  String get coordinatesGoAsLongAsYouWant => '没有时间限制，尽情练习吧！';

  @override
  String get coordinatesShowCoordinates => '显示坐标';

  @override
  String get coordinatesShowCoordsOnAllSquares => '在每个格子上显示坐标';

  @override
  String get coordinatesShowPieces => '显示棋子';

  @override
  String get coordinatesStartTraining => '开始训练';

  @override
  String get coordinatesFindSquare => '找格子';

  @override
  String get coordinatesNameSquare => '格子坐标';

  @override
  String get coordinatesPracticeOnlySomeFilesAndRanks => '练习指定行&列';

  @override
  String get patronDonate => '捐赠';

  @override
  String get patronLichessPatron => 'Lichess 赞助者账号';

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
    return '等级分偏差：$param';
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
  String get perfStatBerserkedGames => '狂暴局数';

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
    return '最高等级分：$param';
  }

  @override
  String perfStatLowestRating(String param) {
    return '最低等级分：$param';
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
    return '最长纪录：$param';
  }

  @override
  String perfStatCurrentStreak(String param) {
    return '当前纪录：$param';
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
  String get preferencesDisplay => '界面设置';

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
  String get preferencesPgnPieceNotation => '使用 PGN 字母 (K,Q,R,B,N) 或棋子图标来显示 PGN 棋谱';

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
  String get preferencesExceptInGame => '对局中除外';

  @override
  String get preferencesChessClock => '棋钟';

  @override
  String get preferencesTenthsOfSeconds => '显示十分之一秒';

  @override
  String get preferencesWhenTimeRemainingLessThanTenSeconds => '当剩余时间小于 10 秒';

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
  String get preferencesWhenTimeRemainingLessThanThirtySeconds => '时间剩余 < 30 秒时';

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
  String get preferencesBlindfold => '盲棋';

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
  String get puzzlePuzzleComplete => '解题完成！';

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
    return '你的连胜纪录：$param';
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
  String get puzzleSearchPuzzles => '搜索谜题';

  @override
  String get puzzleFromMyGamesNone =>
      '你下过的棋局暂时没有被纳入到谜题数据库中，但 Lichess 将一如既往地记着你所走的每一步。\n多下快棋和慢棋可以提升你的棋局被纳入谜题数据库的概率哦！';

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
    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '共 $count 次尝试');
    return '$_temp0';
  }

  @override
  String puzzleNbPointsBelowYourPuzzleRating(int count) {
    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '比你的谜题等级分低 $count');
    return '$_temp0';
  }

  @override
  String puzzleNbPointsAboveYourPuzzleRating(int count) {
    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '比你的谜题等级分高 $count');
    return '$_temp0';
  }

  @override
  String puzzlePuzzlesFoundInUserGames(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$param2 在游戏中发现了 $count 个谜题',
    );
    return '$_temp0';
  }

  @override
  String puzzleNbPlayed(int count) {
    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '玩过 $count');
    return '$_temp0';
  }

  @override
  String puzzleNbToReplay(int count) {
    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '$count 重玩');
    return '$_temp0';
  }

  @override
  String get puzzleThemeAdvancedPawn => '高位兵';

  @override
  String get puzzleThemeAdvancedPawnDescription => '你的兵已经深入对手的领地，可能威胁升变。';

  @override
  String get puzzleThemeAdvantage => '优势';

  @override
  String get puzzleThemeAdvantageDescription => '抓住能让你获得决定性优势的机会。(200 厘兵 ≤ 评估 ≤ 600 厘兵)';

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
  String get puzzleThemeAttackingF2F7Description => '进攻的焦点集中在 f2 或 f7 兵，像在双马防御煎肝进攻中一样。';

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
  String get puzzleThemeCrushingDescription => '抓住对手的失误以获得压倒性的优势 (评估 ≥ 600 厘兵)。';

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
  String get puzzleThemeEqualityDescription => '从大劣的局面回到和棋或者均势 (评估 ≤ 200 厘兵)。';

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
  String get puzzleThemeDiscoveredAttackDescription => '移动阻挡长距离棋子 (例如车) 的己方棋子 (例如马)，打通前者的路线。';

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
  String get puzzleThemeInterferenceDescription =>
      '走动棋子到对手的两个棋子之间，使其中的一个或两个棋子消除保护，例如将一个马走到两个车之间的防守格上。';

  @override
  String get puzzleThemeIntermezzo => '过渡着';

  @override
  String get puzzleThemeIntermezzoDescription => '不走预期的着法，而是走一着对手必须应对的直接威胁。';

  @override
  String get puzzleThemeKillBoxMate => '封盒杀法';

  @override
  String get puzzleThemeKillBoxMateDescription => '被后保护的车在敌方王侧封锁了所有逃脱格。后与车合作将王封杀在 3x3 的盒中。';

  @override
  String get puzzleThemeVukovicMate => '武科维奇杀法';

  @override
  String get puzzleThemeVukovicMateDescription => '车和马一起合作将死了王。车在第三个子的合作下杀死了王，马用来挡住敌王的出路格子。';

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
  String get puzzleThemeMix => '健康搭配';

  @override
  String get puzzleThemeMixDescription => '每个主题中选取一些。你不知道会出现什么，因此得时刻打起精神！ 就像在真实对局中一样。';

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
  String get settingsCantOpenSimilarAccount => '新账号名称不能和旧账号相同，只有大小写差别也不被允许。';

  @override
  String get settingsCancelKeepAccount => '取消，保留我的账户';

  @override
  String get settingsCloseAccountAreYouSure => '您确定要关闭您的账户吗？';

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
  String get strength => '强度';

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
  String get createTheGame => '创建对局';

  @override
  String get whiteIsVictorious => '白方胜利';

  @override
  String get blackIsVictorious => '黑方胜利';

  @override
  String get youPlayTheWhitePieces => '你执白棋';

  @override
  String get youPlayTheBlackPieces => '你执黑棋';

  @override
  String get itsYourTurn => '你的回合！';

  @override
  String get cheatDetected => '检测到作弊';

  @override
  String get kingInTheCenter => '王占中';

  @override
  String get threeChecks => '三次将军胜';

  @override
  String get raceFinished => '竞王结束';

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
  String get opponentLeftChoices => '你的对手已离开棋局。你可以宣布胜利、和棋或继续等待。';

  @override
  String get forceResignation => '宣布胜利';

  @override
  String get forceDraw => '宣布和棋';

  @override
  String get talkInChat => '聊天请注意文明用语！';

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
  String get inLocalBrowser => '本地浏览器';

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
  String get copyVariationPgn => '复制变着的 PGN';

  @override
  String get copyMainLinePgn => '复制主线的 PGN';

  @override
  String get move => '着法';

  @override
  String get variantLoss => '变体输棋';

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
  String get winning => '胜棋';

  @override
  String get losing => '输棋';

  @override
  String get drawn => '和棋';

  @override
  String get unknown => '未知';

  @override
  String get database => '数据库';

  @override
  String get whiteDrawBlack => '白胜／和棋／黑胜';

  @override
  String averageRatingX(String param) {
    return '平均等级分：$param';
  }

  @override
  String get recentGames => '最近棋局';

  @override
  String get topGames => '名局';

  @override
  String masterDbExplanation(String param1, String param2, String param3) {
    return '$param2-$param3 年国际棋联等级分 $param1 以上棋手的棋谱';
  }

  @override
  String get dtzWithRounding => '经过四舍五入的DTZ50\'\'，是基于到下次吃子或兵动的半步数目。';

  @override
  String get noGameFound => '未找到棋局';

  @override
  String get maxDepthReached => '已达到最大深度！';

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
  String get winPreventedBy50MoveRule => '因 50 回合规则未赢棋';

  @override
  String get lossSavedBy50MoveRule => '因 50 回合规则未输棋';

  @override
  String get winOr50MovesByPriorMistake => '赢棋或因先前错误而 50 步作和';

  @override
  String get lossOr50MovesByPriorMistake => '输棋或因先前错误而 50 步作和';

  @override
  String get unknownDueToRounding =>
      '由上次吃子或兵动开始按残局库建议走法走才能保证胜败的判断正确。这是因为 Syzygy 残局库的 DTZ 数值可能经过四舍五入。';

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
  String get drawClaimed => '平局声明';

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
  String joinedX(String param) {
    return '加入了$param';
  }

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
  String get computersAreNotAllowedToPlay =>
      '电脑与电脑辅助棋手不允许参加对局。下棋时，请不要从国际象棋引擎、数据库或其他棋手得到帮助。另外，强烈建议你不要创建备用账户。过度使用多余的账户会导致账号被封禁。';

  @override
  String get games => '棋局';

  @override
  String get forum => '论坛';

  @override
  String xPostedInForumY(String param1, String param2) {
    return '$param1 发文：$param2';
  }

  @override
  String get latestForumPosts => '最新论坛帖子';

  @override
  String get players => '棋手';

  @override
  String get friends => '棋友';

  @override
  String get otherPlayers => '其他玩家';

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
  String get changeEmail => '更改邮箱';

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
  String get ok => '好的';

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
  String get unlimited => '无限制';

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
  String get whiteProposesTakeback => '白方提议悔棋';

  @override
  String get blackProposesTakeback => '黑方提议悔棋';

  @override
  String get takebackPropositionSent => '悔棋请求已发送';

  @override
  String get whiteDeclinesTakeback => '白方拒绝悔棋';

  @override
  String get blackDeclinesTakeback => '黑方拒绝悔棋';

  @override
  String get whiteAcceptsTakeback => '白方同意悔棋';

  @override
  String get blackAcceptsTakeback => '黑方同意悔棋';

  @override
  String get whiteCancelsTakeback => '白方取消悔棋';

  @override
  String get blackCancelsTakeback => '黑方取消悔棋';

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
  String get noDrawBeforeSwissLimit => '你不能在瑞士锦标赛中 30 步棋之前和棋。';

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
    return '$param1 加入 $param2 队';
  }

  @override
  String xCreatedTeamY(String param1, String param2) {
    return '$param1 组建 $param2 队';
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
  String get pasteTheFenStringHere => '在此处粘贴 FEN 字串';

  @override
  String get pasteThePgnStringHere => '在此处粘贴 PGN 棋谱';

  @override
  String get orUploadPgnFile => '或者上传一个 PGN 文件';

  @override
  String get fromPosition => '自定义局面';

  @override
  String get continueFromHere => '从此处继续下棋';

  @override
  String get toStudy => '研讨';

  @override
  String get importGame => '导入棋局';

  @override
  String get importGameExplanation => '粘贴 PGN 棋谱后可重放棋局、使用电脑分析、使用对局聊天室以及获得通往本局的链接。';

  @override
  String get importGameCaveat => '变着分支将被删除。若要保存这些变着，请通过研讨导入 PGN。';

  @override
  String get importGameDataPrivacyWarning => '该 PGN（用以记录棋类游戏棋谱的文件格式）可被公众访问。私人导入游戏请用研究研究';

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
  String xStartedFollowingY(String param1, String param2) {
    return '$param1 开始关注 $param2';
  }

  @override
  String get more => '更多';

  @override
  String get memberSince => '注册日期';

  @override
  String lastSeenActive(String param) {
    return '最近登录 $param';
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
  String get createdBy => '创建者：';

  @override
  String get startingIn => '开始于';

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
    return 'Chess960 起始局面：$param';
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
    return '举报 $param';
  }

  @override
  String profileCompletion(String param) {
    return '资料完成度：$param';
  }

  @override
  String xRating(String param) {
    return '$param 等级分';
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
  String get oneUrlPerLine => '每行一个 URL。';

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
  String get website => '网站';

  @override
  String get mobile => '移动端';

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
  String get reportCheatBoostHelp => '请附上棋局链接解释该用户的行为问题。请不要只说 “对手作弊”，而是解释为什么你认为对手作弊。';

  @override
  String get reportUsernameHelp =>
      '解释这个用户名为何具有冒犯性。不要只说“它具有冒犯性/不恰当”，而是要告诉我们你是如何得出这个结论的，特别是如果侮辱性内容是隐晦的、非英语的、俚语或有历史/文化参考。';

  @override
  String get reportProcessedFasterInEnglish => '如果您使用英语举报，我们将会更快作出答复。';

  @override
  String get error_provideOneCheatedGameLink => '请提供至少一局作弊的棋局的链接。';

  @override
  String by(String param) {
    return '来自 $param';
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
  String get allSquaresOfTheBoard => '棋盘上的所有格子';

  @override
  String get onSlowGames => '在慢棋时';

  @override
  String get always => '总是';

  @override
  String get never => '从不';

  @override
  String xCompetesInY(String param1, String param2) {
    return '$param1 参加 $param2';
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
  String get error_email => '该邮箱地址无效';

  @override
  String get error_email_acceptable => '该邮箱地址不可用，请重新检查后重试。';

  @override
  String get error_email_unique => '邮箱地址无效或已被使用';

  @override
  String get error_email_different => '这已经是您的邮箱地址';

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
    return '允许等级分范围 ± $param';
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
  String get mobileApp => '移动应用';

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
  String get titleVerification => '头衔认证';

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
  String get aboutSimulImage => '菲舍尔同时挑战 50 个对手，胜 47 局，和 2 局，负 1 局。';

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
  String get tournamentHomeDescription =>
      '参加快节奏的国际象棋锦标赛！欢迎参与 Lichess 官方的锦标赛，或创建自己的锦标赛。子弹超快棋，闪电超快棋，经典，菲舍尔任意制，王居中，三次将军，并提供更多的选择给你带来无尽的国际象棋乐趣。';

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
    return '本月 $param 的等级分分布';
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
    return '$param1 比 $param2 的 $param3 棋手强';
  }

  @override
  String betterThanPercentPlayers(String param1, String param2) {
    return '比 $param1 的 $param2 棋手更强';
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
  String get ifYouDoNotGetTheEmail => '如果您在 5 分钟内没有收到电子邮件：';

  @override
  String get checkAllEmailFolders => '请检查所有垃圾邮件或其他文件夹';

  @override
  String verifyYourAddress(String param) {
    return '验证 $param 是您的邮箱地址';
  }

  @override
  String weHaveSentYouAnEmailTo(String param) {
    return '我们给你的邮箱 $param 发了重置密码的链接。请点击链接来重置你的密码。';
  }

  @override
  String byRegisteringYouAgreeToBeBoundByOur(String param) {
    return '注册代表你同意我们的 $param。';
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
  String get downloadRaw => '下载无注释的 PGN';

  @override
  String get downloadImported => '下载导入的棋局';

  @override
  String get downloadAllGames => '下载所有棋局';

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
  String get everybodyGetsAllFeaturesForFree => '每个人都可以免费使用所有功能';

  @override
  String get viewTheSolution => '看解答';

  @override
  String get noChallenges => '暂无挑战。';

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
    return '$param1 点赞 $param2';
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
  String get allLanguages => '所有语言';

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
  String get pieceSet => '棋子风格';

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
  String get invalidPgn => 'PGN 无法识别';

  @override
  String get invalidFen => 'FEN 无法识别';

  @override
  String get custom => '自定义';

  @override
  String get notifications => '通知';

  @override
  String notificationsX(String param1) {
    return '通知：$param1';
  }

  @override
  String perfRatingX(String param) {
    return '等级分：$param';
  }

  @override
  String get practiceWithComputer => '与电脑练习';

  @override
  String anotherWasX(String param) {
    return '$param 也不错';
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
  String get drawByFiftyMoves => '对局因 50 步规则判和。';

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
    return '走了 $param';
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
    return '你的问题可能已经 $param1 有了答案';
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
    return '加入 $param1，以在此论坛发表意见';
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
    return '$param1 在 “$param2” 中提到了你。';
  }

  @override
  String invitedYouToX(String param1) {
    return '邀请你加入 “$param1”。';
  }

  @override
  String xInvitedYouToY(String param1, String param2) {
    return '$param1 邀请你加入 “$param2”。';
  }

  @override
  String get youAreNowPartOfTeam => '你现在是团队的成员。';

  @override
  String youHaveJoinedTeamX(String param1) {
    return '你已加入“$param1”。';
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
  String get clickToRevealEmailAddress => '[点击显示邮箱地址]';

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
  String get tournDescriptionHelp => '你还有其他信息要告诉参赛者们吗？请不要写太多。可以使用 Markdown 来写链接：[文字](https://url)';

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
  String get embedsAvailable => '粘贴对局 URL 或学习章节 URL 来嵌入。';

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
  String get toggleAllAnalysis => '使用本地 + 服务器分析';

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
  String get reopenYourAccountDescription => '如果您关闭了账户，但此后又改变了主意，您可以获得一次恢复账户的机会。';

  @override
  String get emailAssociatedToaccount => '与账户关联的邮箱地址';

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
  String get stats => '统计信息';

  @override
  String get accessibility => '无障碍';

  @override
  String get enableBlindMode => '打开视障模式';

  @override
  String get disableBlindMode => '关闭视障模式';

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
    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '离将死剩$count着');
    return '$_temp0';
  }

  @override
  String nbBlunders(int count) {
    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '$count 次漏着');
    return '$_temp0';
  }

  @override
  String numberBlunders(int count) {
    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '$count 次漏着');
    return '$_temp0';
  }

  @override
  String nbMistakes(int count) {
    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '$count 次错着');
    return '$_temp0';
  }

  @override
  String numberMistakes(int count) {
    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '$count 次错着');
    return '$_temp0';
  }

  @override
  String nbInaccuracies(int count) {
    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '$count 次失准');
    return '$_temp0';
  }

  @override
  String numberInaccuracies(int count) {
    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '$count 次失准');
    return '$_temp0';
  }

  @override
  String nbPlayers(int count) {
    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '$count 位在线棋手');
    return '$_temp0';
  }

  @override
  String nbGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '查看所有 $count 个对局');
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
    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '$count 收藏');
    return '$_temp0';
  }

  @override
  String nbDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '$count 天');
    return '$_temp0';
  }

  @override
  String nbHours(int count) {
    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '$count 个小时');
    return '$_temp0';
  }

  @override
  String nbMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '$count 分钟');
    return '$_temp0';
  }

  @override
  String rankIsUpdatedEveryNbMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '每 $count 分钟更新排名');
    return '$_temp0';
  }

  @override
  String nbPuzzles(int count) {
    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '训练题 $count 题');
    return '$_temp0';
  }

  @override
  String nbGamesWithYou(int count) {
    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '与你下了 $count 盘棋');
    return '$_temp0';
  }

  @override
  String nbRated(int count) {
    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '$count 排位赛');
    return '$_temp0';
  }

  @override
  String nbWins(int count) {
    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '$count胜');
    return '$_temp0';
  }

  @override
  String nbLosses(int count) {
    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '$count负');
    return '$_temp0';
  }

  @override
  String nbDraws(int count) {
    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '$count和');
    return '$_temp0';
  }

  @override
  String nbPlaying(int count) {
    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '$count 正在进行');
    return '$_temp0';
  }

  @override
  String giveNbSeconds(int count) {
    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '添加对方 $count 秒');
    return '$_temp0';
  }

  @override
  String nbTournamentPoints(int count) {
    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '$count 锦标赛积分');
    return '$_temp0';
  }

  @override
  String nbStudies(int count) {
    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '$count研讨');
    return '$_temp0';
  }

  @override
  String nbSimuls(int count) {
    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '$count 个进行的车轮战棋局');
    return '$_temp0';
  }

  @override
  String moreThanNbRatedGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '完成至少 $count 局排位赛');
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
    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '你需要再完成 $count 局排位赛');
    return '$_temp0';
  }

  @override
  String nbImportedGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '$count 盘导入的棋局');
    return '$_temp0';
  }

  @override
  String nbFriendsOnline(int count) {
    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '在线好友：$count');
    return '$_temp0';
  }

  @override
  String nbFollowers(int count) {
    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '$count 关注者');
    return '$_temp0';
  }

  @override
  String nbFollowing(int count) {
    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '关注 $count 人');
    return '$_temp0';
  }

  @override
  String lessThanNbMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '小于 $count 分钟');
    return '$_temp0';
  }

  @override
  String nbGamesInPlay(int count) {
    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '$count 场对局进行中');
    return '$_temp0';
  }

  @override
  String maximumNbCharacters(int count) {
    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '最多 $count 个字符');
    return '$_temp0';
  }

  @override
  String blocks(int count) {
    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '$count 位黑名单用戶');
    return '$_temp0';
  }

  @override
  String nbForumPosts(int count) {
    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '发了 $count 个论坛帖子');
    return '$_temp0';
  }

  @override
  String nbPerfTypePlayersThisWeek(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '本周有 $count 位棋手下 $param2',
    );
    return '$_temp0';
  }

  @override
  String availableInNbLanguages(int count) {
    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '支持$count种语言！');
    return '$_temp0';
  }

  @override
  String nbSecondsToPlayTheFirstMove(int count) {
    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '还剩 $count 秒走第一步');
    return '$_temp0';
  }

  @override
  String nbSeconds(int count) {
    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '$count 秒');
    return '$_temp0';
  }

  @override
  String andSaveNbPremoveLines(int count) {
    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '已保存 $count 条先前的走子');
    return '$_temp0';
  }

  @override
  String get stormMoveToStart => '走一步棋以开始';

  @override
  String get stormYouPlayTheWhitePiecesInAllPuzzles => '你将在所有的谜题中执白';

  @override
  String get stormYouPlayTheBlackPiecesInAllPuzzles => '你将在所有的谜题中执黑';

  @override
  String get stormPuzzlesSolved => '谜题已解决！';

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
    return '最高分：$param';
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
  String get stormNewRun => '开始新的一组 (快捷键：空格)';

  @override
  String get stormEndRun => '结束本组 (快捷键：回车)';

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
  String get stormSlowPuzzles => '慢谜题';

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
    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '$count 组');
    return '$_temp0';
  }

  @override
  String stormPlayedNbRunsOfPuzzleStorm(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '玩了 $count 组的 $param2');
    return '$_temp0';
  }

  @override
  String get streamerLichessStreamers => 'Lichess 主播';

  @override
  String get studyPrivate => '私人';

  @override
  String get studyMyStudies => '我的研讨';

  @override
  String get studyStudiesIContributeTo => '我贡献的研讨';

  @override
  String get studyMyPublicStudies => '我的公开研讨';

  @override
  String get studyMyPrivateStudies => '我的私有研讨';

  @override
  String get studyMyFavoriteStudies => '我收藏的研讨';

  @override
  String get studyWhatAreStudies => '什么是研讨？';

  @override
  String get studyAllStudies => '所有研讨';

  @override
  String studyStudiesCreatedByX(String param) {
    return '由 $param 创建的研讨';
  }

  @override
  String get studyNoneYet => '暂无。';

  @override
  String get studyHot => '热门';

  @override
  String get studyDateAddedNewest => '添加时间 (最新)';

  @override
  String get studyDateAddedOldest => '添加时间 (最早)';

  @override
  String get studyRecentlyUpdated => '最近更新';

  @override
  String get studyMostPopular => '最受欢迎';

  @override
  String get studyAlphabetical => '按字母顺序';

  @override
  String get studyAddNewChapter => '添加一个新章节';

  @override
  String get studyAddMembers => '添加成员';

  @override
  String get studyInviteToTheStudy => '邀请参加研讨';

  @override
  String get studyPleaseOnlyInvitePeopleYouKnow => '请仅邀请你认识的并且积极希望参与这个研讨的成员';

  @override
  String get studySearchByUsername => '按用户名搜索';

  @override
  String get studySpectator => '旁观者';

  @override
  String get studyContributor => '贡献者';

  @override
  String get studyKick => '踢出';

  @override
  String get studyLeaveTheStudy => '离开研讨';

  @override
  String get studyYouAreNowAContributor => '你现在是一位贡献者';

  @override
  String get studyYouAreNowASpectator => '你现在是一位旁观者';

  @override
  String get studyPgnTags => 'PGN 标签';

  @override
  String get studyLike => '赞';

  @override
  String get studyUnlike => '取消赞';

  @override
  String get studyNewTag => '新建标签';

  @override
  String get studyCommentThisPosition => '评论当前局面';

  @override
  String get studyCommentThisMove => '评论这步走法';

  @override
  String get studyAnnotateWithGlyphs => '用符号标注';

  @override
  String get studyTheChapterIsTooShortToBeAnalysed => '本章节太短，无法进行分析。';

  @override
  String get studyOnlyContributorsCanRequestAnalysis => '只有贡献者可以请求服务器分析。';

  @override
  String get studyGetAFullComputerAnalysis => '请求服务器完整地分析主线走法。';

  @override
  String get studyMakeSureTheChapterIsComplete => '请确保章节已完成。你只能请求分析一次。';

  @override
  String get studyAllSyncMembersRemainOnTheSamePosition => 'SYNC 中所有成员处于相同局面';

  @override
  String get studyShareChanges => '与旁观者共享更改并云端保存';

  @override
  String get studyPlaying => '正在对局';

  @override
  String get studyShowResults => '结果';

  @override
  String get studyShowEvalBar => '评估条';

  @override
  String get studyNext => '下一页';

  @override
  String get studyShareAndExport => '分享并导出';

  @override
  String get studyCloneStudy => '复制棋局';

  @override
  String get studyStudyPgn => '研究 PGN';

  @override
  String get studyChapterPgn => '章节 PGN';

  @override
  String get studyCopyChapterPgn => '复制 PGN';

  @override
  String get studyDownloadGame => '下载棋局';

  @override
  String get studyStudyUrl => '研究链接';

  @override
  String get studyCurrentChapterUrl => '当前章节链接';

  @override
  String get studyYouCanPasteThisInTheForumToEmbed => '你可以将此粘贴到论坛以嵌入章节';

  @override
  String get studyStartAtInitialPosition => '从初始局面开始';

  @override
  String studyStartAtX(String param) {
    return '从 $param 开始';
  }

  @override
  String get studyEmbedInYourWebsite => '嵌入到你的网站上';

  @override
  String get studyReadMoreAboutEmbedding => '阅读更多关于嵌入的信息';

  @override
  String get studyOnlyPublicStudiesCanBeEmbedded => '只能嵌入隐私设置为公开的研究！';

  @override
  String get studyOpen => '打开';

  @override
  String studyXBroughtToYouByY(String param1, String param2) {
    return '$param1 由 $param2 提供';
  }

  @override
  String get studyStudyNotFound => '找不到研究';

  @override
  String get studyEditChapter => '编辑章节';

  @override
  String get studyNewChapter => '新章节';

  @override
  String studyImportFromChapterX(String param) {
    return '从 $param 导入';
  }

  @override
  String get studyOrientation => '视角';

  @override
  String get studyAnalysisMode => '分析模式';

  @override
  String get studyPinnedChapterComment => '置顶评论';

  @override
  String get studySaveChapter => '保存章节';

  @override
  String get studyClearAnnotations => '清除注释';

  @override
  String get studyClearVariations => '清除变着';

  @override
  String get studyDeleteChapter => '删除章节';

  @override
  String get studyDeleteThisChapter => '删除本章节？本操作无法撤销！';

  @override
  String get studyClearAllCommentsInThisChapter => '清除章节中所有信息？';

  @override
  String get studyRightUnderTheBoard => '正下方';

  @override
  String get studyNoPinnedComment => '不需要';

  @override
  String get studyNormalAnalysis => '普通模式';

  @override
  String get studyHideNextMoves => '隐藏下一步';

  @override
  String get studyInteractiveLesson => '互动课';

  @override
  String studyChapterX(String param) {
    return '章节 $param';
  }

  @override
  String get studyEmpty => '空白';

  @override
  String get studyStartFromInitialPosition => '从初始局面开始';

  @override
  String get studyEditor => '编辑器';

  @override
  String get studyStartFromCustomPosition => '从自定义局面开始';

  @override
  String get studyLoadAGameByUrl => '通过 URL 加载游戏';

  @override
  String get studyLoadAPositionFromFen => '从 FEN 加载一个局面';

  @override
  String get studyLoadAGameFromPgn => '从 PGN 文件加载游戏';

  @override
  String get studyAutomatic => '自动';

  @override
  String get studyUrlOfTheGame => '游戏的 URL';

  @override
  String studyLoadAGameFromXOrY(String param1, String param2) {
    return '从 $param1 或 $param2 加载游戏';
  }

  @override
  String get studyCreateChapter => '创建章节';

  @override
  String get studyCreateStudy => '创建课程';

  @override
  String get studyEditStudy => '编辑课程';

  @override
  String get studyVisibility => '权限';

  @override
  String get studyPublic => '公开';

  @override
  String get studyUnlisted => '未列出';

  @override
  String get studyInviteOnly => '仅限邀请';

  @override
  String get studyAllowCloning => '允许复制';

  @override
  String get studyNobody => '没人';

  @override
  String get studyOnlyMe => '仅自己';

  @override
  String get studyContributors => '贡献者';

  @override
  String get studyMembers => '成员';

  @override
  String get studyEveryone => '所有人';

  @override
  String get studyEnableSync => '允许同步';

  @override
  String get studyYesKeepEveryoneOnTheSamePosition => '确认：每个人都处于同样的局面';

  @override
  String get studyNoLetPeopleBrowseFreely => '取消：让玩家自由选择';

  @override
  String get studyPinnedStudyComment => '置顶评论';

  @override
  String get studyStart => '开始';

  @override
  String get studySave => '保存';

  @override
  String get studyClearChat => '清空对话';

  @override
  String get studyDeleteTheStudyChatHistory => '删除研讨聊天记录？本操作无法撤销！';

  @override
  String get studyDeleteStudy => '删除研讨';

  @override
  String studyConfirmDeleteStudy(String param) {
    return '确定删除整个研讨？该操作不可恢复，输入研讨名以确认：$param';
  }

  @override
  String get studyWhereDoYouWantToStudyThat => '你想从哪里开始此项研究？';

  @override
  String get studyGoodMove => '好棋';

  @override
  String get studyMistake => '错着';

  @override
  String get studyBrilliantMove => '妙着！';

  @override
  String get studyBlunder => '漏着';

  @override
  String get studyInterestingMove => '趣着';

  @override
  String get studyDubiousMove => '惑着';

  @override
  String get studyOnlyMove => '唯一着法';

  @override
  String get studyZugzwang => 'Zugzwang';

  @override
  String get studyEqualPosition => '均势';

  @override
  String get studyUnclearPosition => '局势不明';

  @override
  String get studyWhiteIsSlightlyBetter => '白方略优';

  @override
  String get studyBlackIsSlightlyBetter => '黑方略优';

  @override
  String get studyWhiteIsBetter => '白方占优';

  @override
  String get studyBlackIsBetter => '黑方占优';

  @override
  String get studyWhiteIsWinning => '白方即胜';

  @override
  String get studyBlackIsWinning => '黑方即胜';

  @override
  String get studyNovelty => '创新';

  @override
  String get studyDevelopment => '发展';

  @override
  String get studyInitiative => '占据主动';

  @override
  String get studyAttack => '攻击';

  @override
  String get studyCounterplay => '反击';

  @override
  String get studyTimeTrouble => '无暇多虑';

  @override
  String get studyWithCompensation => '优势补偿';

  @override
  String get studyWithTheIdea => '教科书式的';

  @override
  String get studyNextChapter => '下一章节';

  @override
  String get studyPrevChapter => '上一章节';

  @override
  String get studyStudyActions => '研讨操作';

  @override
  String get studyTopics => '主题';

  @override
  String get studyMyTopics => '我的主题';

  @override
  String get studyPopularTopics => '热门主题';

  @override
  String get studyManageTopics => '管理主题';

  @override
  String get studyBack => '回到起始';

  @override
  String get studyPlayAgain => '重玩';

  @override
  String get studyWhatWouldYouPlay => '你会在这个位置上怎么走？';

  @override
  String get studyYouCompletedThisLesson => '恭喜！你完成了这个课程！';

  @override
  String studyPerPage(String param) {
    return '$param 每页';
  }

  @override
  String get studyGetTheTour => '需要帮助？开始导览！';

  @override
  String get studyWelcomeToLichessStudyTitle => '欢迎来到 Lichess 研讨！';

  @override
  String get studyWelcomeToLichessStudyText =>
      '这是一个共同的分析委员会。<br><br>用它来分析和批注游戏，<br>与朋友讨论位置，<br>或者进行课程！<br><br>这是一个强大的工具，让我们花一些时间看看它如何运作。';

  @override
  String get studySharedAndSaveTitle => '已共享并保存';

  @override
  String get studySharedAndSavedText => '其他成员可以实时看到您的移动！<br>一切都会永远保存。';

  @override
  String get studyStudyMembersTitle => '研讨成员';

  @override
  String studyStudyMembersText(String param1, String param2) {
    return '$param1 旁观者可以在聊天室查看研讨并进行谈话。<br><br>$param2 贡献者可以移动并更新研讨。';
  }

  @override
  String studyAddMembersText(String param) {
    return '点击 $param 按钮.<br>选择你的贡献者';
  }

  @override
  String get studyStudyChaptersTitle => '研讨章节';

  @override
  String get studyStudyChaptersText => '研讨可以包含多个章节。<br>每个章节都有一个独特的初始位置并行动树。';

  @override
  String get studyCommentPositionTitle => '评论当前局面';

  @override
  String studyCommentPositionText(String param) {
    return '点击 $param 按钮，或右键点击棋步列表。<br>注释会被共享并保存。';
  }

  @override
  String get studyAnnotatePositionTitle => '标注局面';

  @override
  String get studyAnnotatePositionText => '点击 !? 按钮，或右键点击棋步列表。<br>标注会被共享并保存。';

  @override
  String get studyConclusionTitle => '感谢您抽出宝贵的时间';

  @override
  String get studyConclusionText =>
      '你可以从你的个人资料界面找到你的<a href=\'/study/mine/hot\'>过往研讨 <br> 我们也提供了 <a href=\'//lichess.org/blog/V0KrLSkAAMo3hsi4/study-chess-the-lichess-way\'>研讨博客</a>.<br>高级用户可以点击\"?\"查看键盘快捷键<br>研讨愉快';

  @override
  String get studyCreateChapterTitle => '让我们创建一个学习章节';

  @override
  String get studyCreateChapterText => '一份研讨可以有多个章节。<br>每个章节可以有独立的棋步树<br>可以通过多种方式';

  @override
  String get studyFromInitialPositionTitle => '从起始局面开始';

  @override
  String get studyFromInitialPositionText => '起始局面。<br>可以用来研讨开局。';

  @override
  String get studyCustomPositionTitle => '自定义局面';

  @override
  String get studyCustomPositionText => '自定义局面。<br>可以用来研讨终局。';

  @override
  String get studyLoadExistingLichessGameTitle => '导入 Lichess 棋局';

  @override
  String get studyLoadExistingLichessGameText =>
      '导入Lichess棋局链接<br>(例如 lichess.org/7fHIU0XI)<br>来导入这局棋中的所有棋步';

  @override
  String get studyFromFenStringTitle => '导入 FEN 代码';

  @override
  String get studyFromFenStringText =>
      '粘贴一个局面的 FEN 代码<br><i>4k3/4rb2/8/7p/8/5Q2/1PP5/1K6 w</i><br>来从这个局面开始章节';

  @override
  String get studyFromPgnGameTitle => '导入 PGN 代码';

  @override
  String get studyFromPgnGameText =>
      '粘贴一局棋的 PGN 代码<br><i>4k3/4rb2/8/7p/8/5Q2/1PP5/1K6 w</i><br>在章节中导入所有的棋步，注释和变招。';

  @override
  String get studyVariantsAreSupportedTitle => '研究支持变体';

  @override
  String get studyVariantsAreSupportedText => '你也可以研讨 CrazyHouse<br>和所有其他的 lichess 变种';

  @override
  String get studyChapterConclusionText => '章节会永久保存。<br>研讨愉快！';

  @override
  String get studyDoubleDefeat => '双败';

  @override
  String get studyBlackDefeatWhiteCanNotWin => '黑负，但白方无法获胜';

  @override
  String get studyWhiteDefeatBlackCanNotWin => '白负，但黑方无法获胜';

  @override
  String studyNbChapters(int count) {
    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '共 $count 章');
    return '$_temp0';
  }

  @override
  String studyNbGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '共 $count 盘棋');
    return '$_temp0';
  }

  @override
  String studyNbMembers(int count) {
    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '$count 位成员');
    return '$_temp0';
  }

  @override
  String studyPasteYourPgnTextHereUpToNbGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '在此粘贴你的 PGN 文本，最多支持 $count 个游戏',
    );
    return '$_temp0';
  }

  @override
  String get timeagoJustNow => '刚刚';

  @override
  String get timeagoRightNow => '刚刚';

  @override
  String get timeagoCompleted => '已完成';

  @override
  String timeagoInNbSeconds(int count) {
    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '在 $count 秒内');
    return '$_temp0';
  }

  @override
  String timeagoInNbMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '在 $count 分钟内');
    return '$_temp0';
  }

  @override
  String timeagoInNbHours(int count) {
    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '在 $count 小时内');
    return '$_temp0';
  }

  @override
  String timeagoInNbDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '在 $count 天内');
    return '$_temp0';
  }

  @override
  String timeagoInNbWeeks(int count) {
    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '在 $count 周内');
    return '$_temp0';
  }

  @override
  String timeagoInNbMonths(int count) {
    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '在 $count 月内');
    return '$_temp0';
  }

  @override
  String timeagoInNbYears(int count) {
    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '在 $count 年内');
    return '$_temp0';
  }

  @override
  String timeagoNbMinutesAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '$count 分钟前');
    return '$_temp0';
  }

  @override
  String timeagoNbHoursAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '$count 小时前');
    return '$_temp0';
  }

  @override
  String timeagoNbDaysAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '$count 天前');
    return '$_temp0';
  }

  @override
  String timeagoNbWeeksAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '$count 周前');
    return '$_temp0';
  }

  @override
  String timeagoNbMonthsAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '$count 月前');
    return '$_temp0';
  }

  @override
  String timeagoNbYearsAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '$count 年前');
    return '$_temp0';
  }

  @override
  String timeagoNbMinutesRemaining(int count) {
    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '还剩 $count 分钟');
    return '$_temp0';
  }

  @override
  String timeagoNbHoursRemaining(int count) {
    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '还剩 $count 小时');
    return '$_temp0';
  }
}

/// The translations for Chinese, as used in Taiwan (`zh_TW`).
class AppLocalizationsZhTw extends AppLocalizationsZh {
  AppLocalizationsZhTw() : super('zh_TW');

  @override
  String get mobileAllGames => '所有棋局';

  @override
  String get mobileAreYouSure => '您確定嗎？';

  @override
  String get mobileCancelTakebackOffer => '取消悔棋請求';

  @override
  String get mobileClearButton => '清除';

  @override
  String get mobileCorrespondenceClearSavedMove => '清除已儲存移動';

  @override
  String get mobileCustomGameJoinAGame => '加入棋局';

  @override
  String get mobileFeedbackButton => '問題反饋';

  @override
  String get mobileHideVariation => '隱藏變化';

  @override
  String get mobileHomeTab => '首頁';

  @override
  String get mobileLiveStreamers => 'Lichess 實況主';

  @override
  String get mobileMustBeLoggedIn => '你必須登入才能查看此頁面。';

  @override
  String get mobileNoSearchResults => '沒有任何搜尋結果';

  @override
  String get mobileNotFollowingAnyUser => '您未追蹤任何使用者。';

  @override
  String get mobileOkButton => '確認';

  @override
  String mobilePlayersMatchingSearchTerm(String param) {
    return '名稱包含「$param」的玩家';
  }

  @override
  String get mobilePrefMagnifyDraggedPiece => '放大被拖曳的棋子';

  @override
  String get mobilePuzzleStormConfirmEndRun => '是否中斷於此？';

  @override
  String get mobilePuzzleStormFilterNothingToShow => '沒有內容可顯示，請更改篩選條件';

  @override
  String get mobilePuzzleStormNothingToShow => '沒有內容可顯示。您可以進行一些 Puzzle Storm 。';

  @override
  String get mobilePuzzleStormSubtitle => '在三分鐘內解開盡可能多的謎題';

  @override
  String get mobilePuzzleStreakAbortWarning => '這將失去目前的連勝並且將儲存目前成績。';

  @override
  String get mobilePuzzleThemesSubtitle => '從您喜歡的開局進行謎題，或選擇一個主題。';

  @override
  String get mobilePuzzlesTab => '謎題';

  @override
  String get mobileRecentSearches => '搜尋紀錄';

  @override
  String get mobileSettingsImmersiveMode => '沉浸模式';

  @override
  String get mobileSettingsTab => '設定';

  @override
  String get mobileShareGamePGN => '分享 PGN';

  @override
  String get mobileShareGameURL => '分享對局網址';

  @override
  String get mobileSharePositionAsFEN => '以 FEN 分享棋局位置';

  @override
  String get mobileSharePuzzle => '分享這個謎題';

  @override
  String get mobileShowComments => '顯示留言';

  @override
  String get mobileShowResult => '顯示結果';

  @override
  String get mobileShowVariations => '顯示變體';

  @override
  String get mobileSomethingWentWrong => '發生了一些問題。';

  @override
  String get mobileSystemColors => '系統顏色';

  @override
  String get mobileTheme => '佈景主題';

  @override
  String get mobileToolsTab => '工具';

  @override
  String get mobileWaitingForOpponentToJoin => '正在等待對手加入...';

  @override
  String get mobileWatchTab => '觀戰';

  @override
  String get activityActivity => '活動';

  @override
  String get activityHostedALiveStream => '主持一個現場直播';

  @override
  String activityRankedInSwissTournament(String param1, String param2) {
    return '在$param2中排名 $param1';
  }

  @override
  String get activitySignedUp => '在 lichess.org 中註冊';

  @override
  String activitySupportedNbMonths(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '以 $param2 身分贊助 lichess.org $count 個月',
    );
    return '$_temp0';
  }

  @override
  String activityPracticedNbPositions(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '在 $param2 練習了 $count 個棋局',
    );
    return '$_temp0';
  }

  @override
  String activitySolvedNbPuzzles(int count) {
    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '解決了 $count 個戰術題目');
    return '$_temp0';
  }

  @override
  String activityPlayedNbGames(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '下了 $count 場$param2類型的棋局',
    );
    return '$_temp0';
  }

  @override
  String activityPostedNbMessages(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '在「$param2」發表了 $count 則訊息',
    );
    return '$_temp0';
  }

  @override
  String activityPlayedNbMoves(int count) {
    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '下了 $count 步');
    return '$_temp0';
  }

  @override
  String activityInNbCorrespondenceGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '在 $count 場通信棋局中');
    return '$_temp0';
  }

  @override
  String activityCompletedNbGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '完成了 $count 場通信棋局');
    return '$_temp0';
  }

  @override
  String activityCompletedNbVariantGames(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '完成了 $count $param2 場通信棋局',
    );
    return '$_temp0';
  }

  @override
  String activityFollowedNbPlayers(int count) {
    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '開始關注 $count 個玩家');
    return '$_temp0';
  }

  @override
  String activityGainedNbFollowers(int count) {
    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '增加了 $count 個追蹤者');
    return '$_temp0';
  }

  @override
  String activityHostedNbSimuls(int count) {
    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '主持了$count場車輪戰');
    return '$_temp0';
  }

  @override
  String activityJoinedNbSimuls(int count) {
    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '加入了$count場車輪戰');
    return '$_temp0';
  }

  @override
  String activityCreatedNbStudies(int count) {
    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '創造了$count個新的研究');
    return '$_temp0';
  }

  @override
  String activityCompetedInNbTournaments(int count) {
    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '完成了$count場錦標賽');
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
    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '參與過 $count 場瑞士制錦標賽');
    return '$_temp0';
  }

  @override
  String activityJoinedNbTeams(int count) {
    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '加入 $count 團隊');
    return '$_temp0';
  }

  @override
  String get arenaArena => '競技場';

  @override
  String get arenaArenaTournaments => '錦標賽';

  @override
  String get arenaIsItRated => '這一局棋會被評分嗎？';

  @override
  String get arenaWillBeNotified => '您將會在錦標賽開始時收到通知，所以您可以放心的在錦標賽開始前下其他的棋局。';

  @override
  String get arenaIsRated => '這場錦標賽將會評分，並且影響到您的評分。';

  @override
  String get arenaIsNotRated => '這場錦標賽不會評分，並且它不會影響到您的評分。';

  @override
  String get arenaSomeRated => '一些錦標賽將會評分，並且影響到您的評分。';

  @override
  String get arenaHowAreScoresCalculated => '分數是如何計算的？';

  @override
  String get arenaHowAreScoresCalculatedAnswer =>
      '贏家將會得到2積分，平局1積分，輸家0分。\n如果您連續贏了2場以上的棋局，您將會開始以火焰符號標示的連勝次數。\n在連勝後您將會收到兩倍的積分直到輸棋。\n換句話說：贏得 4 積分，平局得 2 積分，但是輸家依舊沒有積分。\n\n例如：連贏兩場加上一局平局，您將會得到 2 + 2 + ( 2 x 1 ) = 6 積分';

  @override
  String get arenaBerserk => '狂暴選項';

  @override
  String get arenaBerserkAnswer =>
      '狂暴模式若開啟，玩家時間將會砍半，不過在獲勝時將會多 1 積分\n\n在狂暴模式下，加時制將會被停用（1+2 是一個例外，它將會改為 1+0）。\n\n狂暴模式將不會被允許在零初始時間模式時開啟（例如：0+1，0+2）。\n\n狂暴模式只會在您下了 7 步棋以上才會得到加成分數。';

  @override
  String get arenaHowIsTheWinnerDecided => '贏家是怎麼決定的？';

  @override
  String get arenaHowIsTheWinnerDecidedAnswer => '在錦標賽中獲得最多積分的人將獲勝，當兩位(或以上)玩家擁有相同積分時，這場錦標賽將會被視為平手';

  @override
  String get arenaHowDoesPairingWork => '對手是如何配對的?';

  @override
  String get arenaHowDoesPairingWorkAnswer =>
      '在錦標賽開始時，系統將會以您的模式評分為基礎分配對手。\n在您完成了第一場棋局後，系統將會分配與您排名相近的玩家作為對手，這會需要一點時間做分配。\n迅速完成棋局並獲勝就可以得到更多積分。';

  @override
  String get arenaHowDoesItEnd => '錦標賽何時會結束？';

  @override
  String get arenaHowDoesItEndAnswer =>
      '每場錦標賽都會有一個倒數計時器，當它歸零時，錦標賽的排名就會固定，排名將會被顯示。如果有比賽在錦標賽結束後還沒完成，您還是得完成它，但是積分將不會被算進錦標賽的積分裡。';

  @override
  String get arenaOtherRules => '其他重要的規則';

  @override
  String get arenaThereIsACountdown => '在您開始您的第一步棋前將會有一個倒數計時器，在倒數結束前如果沒有下出您的第一步，您的對手將會直接獲勝';

  @override
  String get arenaThisIsPrivate => '這是一個私人的錦標賽';

  @override
  String arenaShareUrl(String param) {
    return '分享這個網址讓其他人加入這場錦標賽：$param';
  }

  @override
  String arenaDrawStreakStandard(String param) {
    return '連和場數：當棋手在競技場中連續和棋時，只有第一次和棋或者超過 $param 步的和局才會計分。 連和場數只能被勝利打破，不會被輸棋或和棋打破。';
  }

  @override
  String get arenaDrawStreakVariants => '計分的和局的最小步數由不同的變體而變化。 下面的表格列出了每個變體的閥值。';

  @override
  String get arenaVariant => '變體';

  @override
  String get arenaMinimumGameLength => '最少對局步數';

  @override
  String get arenaHistory => '先前的重要錦標賽';

  @override
  String get arenaNewTeamBattle => '新團隊戰';

  @override
  String get arenaCustomStartDate => '自定義開始日期';

  @override
  String get arenaCustomStartDateHelp => '在您的當地時區，這將會覆蓋在 \"比賽準備時間\" 選項';

  @override
  String get arenaAllowBerserk => '允許啟用狂暴模式';

  @override
  String get arenaAllowBerserkHelp => '讓玩家將時間減半以獲得額外積分';

  @override
  String get arenaAllowChatHelp => '讓玩家在聊天室討論';

  @override
  String get arenaArenaStreaks => '競技場連勝';

  @override
  String get arenaArenaStreaksHelp => '2次勝利後，連勝將會取得4分，而不是2分。';

  @override
  String get arenaNoBerserkAllowed => '禁止「神速」模式';

  @override
  String get arenaNoArenaStreaks => '無競技場連勝';

  @override
  String get arenaAveragePerformance => '平均表現';

  @override
  String get arenaAverageScore => '平均分數';

  @override
  String get arenaMyTournaments => '我的錦標賽';

  @override
  String get arenaEditTournament => '編輯錦標賽';

  @override
  String get arenaEditTeamBattle => '編輯團隊比賽';

  @override
  String get arenaDefender => '防守者';

  @override
  String get arenaPickYourTeam => '選擇隊伍';

  @override
  String get arenaWhichTeamWillYouRepresentInThisBattle => '你會為哪一個隊伍代表比賽？';

  @override
  String get arenaYouMustJoinOneOfTheseTeamsToParticipate => '你必須參加某個隊伍以比賽！';

  @override
  String get arenaCreated => '已建立';

  @override
  String get arenaRecentlyPlayed => '最近玩過';

  @override
  String get arenaBestResults => '最佳紀錄';

  @override
  String get arenaTournamentStats => '錦標賽得分';

  @override
  String get arenaRankAvgHelp =>
      '平均等地表示你的等地百分比。越低越好。\n\n舉例而言，在 100 人中被評等地 3 表示 %3；在 1000 人中被評等地 10 表示 %1';

  @override
  String get arenaMedians => '中位數';

  @override
  String arenaAllAveragesAreX(String param) {
    return '所有平均為$param。';
  }

  @override
  String get arenaTotal => '總計';

  @override
  String get arenaPointsAvg => '平均分數';

  @override
  String get arenaPointsSum => '總計分數';

  @override
  String get arenaRankAvg => '平均等地';

  @override
  String get arenaTournamentWinners => '錦標賽贏家';

  @override
  String get arenaTournamentShields => '錦標賽徽章';

  @override
  String get arenaOnlyTitled => '僅限頭銜玩家';

  @override
  String get arenaOnlyTitledHelp => '需要官方頭銜才能加入比賽';

  @override
  String get arenaTournamentPairingsAreNowClosed => '此錦標賽的對手配對已結束。';

  @override
  String get arenaBerserkRate => '快棋率';

  @override
  String arenaDrawingWithinNbMoves(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '在$count步內平局的棋局將不會得到積分',
    );
    return '$_temp0';
  }

  @override
  String arenaViewAllXTeams(int count) {
    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '查看所有 $count 團隊');
    return '$_temp0';
  }

  @override
  String get broadcastBroadcasts => '比賽直播';

  @override
  String get broadcastMyBroadcasts => '我的直播';

  @override
  String get broadcastLiveBroadcasts => '錦標賽直播';

  @override
  String get broadcastBroadcastCalendar => '直播時程表';

  @override
  String get broadcastNewBroadcast => '新的現場直播';

  @override
  String get broadcastSubscribedBroadcasts => '已訂閱的直播';

  @override
  String get broadcastAboutBroadcasts => '關於直播';

  @override
  String get broadcastHowToUseLichessBroadcasts => '如何使用 Lichess 比賽直播';

  @override
  String get broadcastTheNewRoundHelp => '新的一局會有跟上一局相同的成員與貢獻者';

  @override
  String get broadcastAddRound => '新增回合';

  @override
  String get broadcastOngoing => '進行中';

  @override
  String get broadcastUpcoming => '即將舉行';

  @override
  String get broadcastRoundName => '回合名稱';

  @override
  String get broadcastRoundNumber => '回合數';

  @override
  String get broadcastTournamentName => '錦標賽名稱';

  @override
  String get broadcastTournamentDescription => '簡短比賽說明';

  @override
  String get broadcastFullDescription => '完整比賽說明';

  @override
  String broadcastFullDescriptionHelp(String param1, String param2) {
    return '直播內容的詳細描述 。可以利用 $param1。字數限於$param2個字。';
  }

  @override
  String get broadcastSourceSingleUrl => 'PGN 來源網址';

  @override
  String get broadcastSourceUrlHelp => 'Lichess 將以該網址更新PGN數據，網址必須公開';

  @override
  String get broadcastSourceGameIds => '最多 64 個以空格分開的 Lichess 棋局序號。';

  @override
  String broadcastStartDateTimeZone(String param) {
    return '當地時區的錦標賽起始日期：$param';
  }

  @override
  String get broadcastStartDateHelp => '可選，如果知道比賽開始時間';

  @override
  String get broadcastCurrentGameUrl => '目前棋局連結';

  @override
  String get broadcastDownloadAllRounds => '下載所有棋局';

  @override
  String get broadcastResetRound => '重設此回合';

  @override
  String get broadcastDeleteRound => '刪除此回合';

  @override
  String get broadcastDefinitivelyDeleteRound => '刪除這局以及其所有棋局';

  @override
  String get broadcastDeleteAllGamesOfThisRound => '刪除所有此輪的棋局。直播來源必須是開啟的以成功重新建立棋局。';

  @override
  String get broadcastEditRoundStudy => '編輯此輪研究';

  @override
  String get broadcastDeleteTournament => '刪除此錦標賽';

  @override
  String get broadcastDefinitivelyDeleteTournament => '刪除錦標賽以及所有棋局';

  @override
  String get broadcastShowScores => '根據比賽結果顯示玩家分數';

  @override
  String get broadcastReplacePlayerTags => '取代玩家名字、評級、以及頭銜（選填）';

  @override
  String get broadcastFideFederations => 'FIDE 國別';

  @override
  String get broadcastTop10Rating => '前 10 名平均評級';

  @override
  String get broadcastFidePlayers => 'FIDE 玩家';

  @override
  String get broadcastFidePlayerNotFound => '找不到 FIDE 玩家';

  @override
  String get broadcastFideProfile => 'FIDE 序號';

  @override
  String get broadcastFederation => '國籍';

  @override
  String get broadcastAgeThisYear => '年齡';

  @override
  String get broadcastUnrated => '未評級';

  @override
  String get broadcastRecentTournaments => '最近錦標賽';

  @override
  String get broadcastOpenLichess => '在 lichess 中開啟';

  @override
  String get broadcastTeams => '團隊';

  @override
  String get broadcastBoards => '棋局';

  @override
  String get broadcastOverview => '概覽';

  @override
  String get broadcastSubscribeTitle => '訂閱以在每輪開始時獲得通知。您可以在帳戶設定中切換直播的鈴聲或推播通知。';

  @override
  String get broadcastUploadImage => '上傳錦標賽圖片';

  @override
  String get broadcastNoBoardsYet => '尚無棋局。這些棋局將在對局上傳後顯示。';

  @override
  String broadcastBoardsCanBeLoaded(String param) {
    return '棋盤能夠以輸入源投放或是利用$param';
  }

  @override
  String broadcastStartsAfter(String param) {
    return '於$param開始';
  }

  @override
  String get broadcastStartVerySoon => '直播即將開始。';

  @override
  String get broadcastNotYetStarted => '直播尚未開始。';

  @override
  String get broadcastOfficialWebsite => '官網';

  @override
  String get broadcastStandings => '排行榜';

  @override
  String get broadcastOfficialStandings => '官方排名';

  @override
  String broadcastIframeHelp(String param) {
    return '更多選項在$param';
  }

  @override
  String get broadcastWebmastersPage => '網頁管理員頁面';

  @override
  String broadcastPgnSourceHelp(String param) {
    return '這一輪的公開實時 PGN。我們還提供$param以實現更快和更高效的同步。';
  }

  @override
  String get broadcastEmbedThisBroadcast => '將此直播嵌入您的網站';

  @override
  String broadcastEmbedThisRound(String param) {
    return '將$param嵌入您的網站';
  }

  @override
  String get broadcastRatingDiff => '評級差異';

  @override
  String get broadcastGamesThisTournament => '此比賽的對局';

  @override
  String get broadcastScore => '分數';

  @override
  String get broadcastAllTeams => '所有團隊';

  @override
  String get broadcastTournamentFormat => '錦標賽格式';

  @override
  String get broadcastTournamentLocation => '錦標賽地點';

  @override
  String get broadcastTopPlayers => '頂尖玩家';

  @override
  String get broadcastTimezone => '時區';

  @override
  String get broadcastFideRatingCategory => 'FIDE 評級類別';

  @override
  String get broadcastOptionalDetails => '其他細節';

  @override
  String get broadcastPastBroadcasts => '直播紀錄';

  @override
  String get broadcastAllBroadcastsByMonth => '以月份顯示所有直播';

  @override
  String get broadcastBackToLiveMove => '返回及時走法';

  @override
  String get broadcastSinceHideResults => '由於您選擇隱藏結果，所有預覽棋盤都是空的，以避免劇透。';

  @override
  String broadcastNbBroadcasts(int count) {
    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '$count 個直播');
    return '$_temp0';
  }

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
  String get coordinatesCoordinates => '座標';

  @override
  String get coordinatesCoordinateTraining => '座標訓練';

  @override
  String coordinatesAverageScoreAsWhiteX(String param) {
    return '白棋方平均分數: $param';
  }

  @override
  String coordinatesAverageScoreAsBlackX(String param) {
    return '黑棋方平均分數: $param';
  }

  @override
  String get coordinatesKnowingTheChessBoard => '能快速對照棋盤上的座標與其位置是一項很重要的技巧。';

  @override
  String get coordinatesMostChessCourses => '大多數的西洋棋課程都很頻繁的使用代數記譜法。';

  @override
  String get coordinatesTalkToYourChessFriends => '這讓你跟和棋友更容易聊天，因為你們都知道「西洋棋的共同語言」。';

  @override
  String get coordinatesYouCanAnalyseAGameMoreEffectively => '如果能夠快速地辨認座標，可以更有效率的分析一場棋局。';

  @override
  String get coordinatesACoordinateAppears => '座標將在棋盤上出現，您必須點擊對應的棋格。';

  @override
  String get coordinatesASquareIsHighlightedExplanation => '棋格將在棋盤上以紅色光提示，您必須輸入它的座標(例如「e4」)。';

  @override
  String get coordinatesYouHaveThirtySeconds => '您有30秒時間正確配對盡可能多的棋格。';

  @override
  String get coordinatesGoAsLongAsYouWant => '沒有時間限制，盡情練習吧！';

  @override
  String get coordinatesShowCoordinates => '顯示座標';

  @override
  String get coordinatesShowCoordsOnAllSquares => '在每一格顯示座標';

  @override
  String get coordinatesShowPieces => '顯示棋子';

  @override
  String get coordinatesStartTraining => '開始訓練';

  @override
  String get coordinatesFindSquare => '尋找方格';

  @override
  String get coordinatesNameSquare => '說出方格的名字';

  @override
  String get coordinatesPracticeOnlySomeFilesAndRanks => '只練習部分列與行';

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
  String get preferencesPreferences => '偏好設定';

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
  String get preferencesBoardHighlights => '國王紅色亮光（最後一步與將軍）';

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
  String get preferencesShowFlairs => '顯示玩家身分';

  @override
  String get preferencesExplainShowPlayerRatings =>
      '這允許隱藏本網站上的所有等級分，以輔助專心下棋。每局遊戲仍可以計算及改變等級分，這個設定只會影響到你是否看得到此分數。';

  @override
  String get preferencesDisplayBoardResizeHandle => '顯示盤面大小調整區塊';

  @override
  String get preferencesOnlyOnInitialPosition => '只在起始局面';

  @override
  String get preferencesInGameOnly => '只在遊戲中';

  @override
  String get preferencesExceptInGame => '僅適用於非評分局中';

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
  String get preferencesBlindfold => '盲棋';

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
  String get puzzleUpVote => '投票為好謎題';

  @override
  String get puzzleDownVote => '投票為壞謎題';

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
  String get puzzleDailyPuzzle => '每日謎題';

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
  String get puzzleByOpenings => '以開局區分';

  @override
  String get puzzlePuzzlesByOpenings => '以開局區分謎題';

  @override
  String get puzzleOpeningsYouPlayedTheMost => '您最常使用的開局';

  @override
  String get puzzleUseFindInPage => '在瀏覽器中使用「在頁面中尋找」以尋找你最喜歡的開局！';

  @override
  String get puzzleUseCtrlF => '按下 Ctrl+f 以找出您最喜歡的開局方式！';

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
  String get puzzleNextPuzzle => '下個謎題';

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
  String get puzzleStreakDescription =>
      '累積你的連勝，解著漸漸變難的題目。 沒有時間限制，不要急。走錯一步，將會是遊戲結束！\n不過每一局中你都有跳過一步棋的機會。';

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
  String get puzzleSearchPuzzles => '尋找謎題';

  @override
  String get puzzleFromMyGamesNone => '你在資料庫中沒有謎題，但 Lichess 仍然非常愛你。\n遊玩一些快速和經典遊戲，以增加從你的棋局中生成謎題的機會！';

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
    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '已被嘗試$count次');
    return '$_temp0';
  }

  @override
  String puzzleNbPointsBelowYourPuzzleRating(int count) {
    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '低於你的謎題積分$count點');
    return '$_temp0';
  }

  @override
  String puzzleNbPointsAboveYourPuzzleRating(int count) {
    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '高於你的謎題積分$count點');
    return '$_temp0';
  }

  @override
  String puzzleNbPlayed(int count) {
    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '$count 已遊玩');
    return '$_temp0';
  }

  @override
  String puzzleNbToReplay(int count) {
    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '$count 重玩');
    return '$_temp0';
  }

  @override
  String get puzzleThemeAdvancedPawn => '升變兵';

  @override
  String get puzzleThemeAdvancedPawnDescription => '你的其中一個兵已經深入了對方的棋位，或許要威脅升變。';

  @override
  String get puzzleThemeAdvantage => '取得優勢';

  @override
  String get puzzleThemeAdvantageDescription => '把握機會以取得決定性優勢。（200 厘兵 ≤ 評估值 ≤ 600 厘兵）';

  @override
  String get puzzleThemeAnastasiaMate => '阿納斯塔西亞殺法';

  @override
  String get puzzleThemeAnastasiaMateDescription => '馬與車或后聯手在棋盤邊困住對手國王以及另一對手棋子';

  @override
  String get puzzleThemeArabianMate => '阿拉伯殺法';

  @override
  String get puzzleThemeArabianMateDescription => '馬和車聯手把對方的王困住在角落的位置';

  @override
  String get puzzleThemeAttackingF2F7 => '攻擊 f2 或 f7';

  @override
  String get puzzleThemeAttackingF2F7Description => '專注於 f2 或 f7 兵的攻擊，像是 fried liver 攻擊';

  @override
  String get puzzleThemeAttraction => '吸引';

  @override
  String get puzzleThemeAttractionDescription => '一種換子或犧牲強迫對手旗子到某格以好進行接下來的戰術。';

  @override
  String get puzzleThemeBackRankMate => '後排將死';

  @override
  String get puzzleThemeBackRankMateDescription => '在對方的王於底線被自身的棋子困住時，將死對方的王';

  @override
  String get puzzleThemeBishopEndgame => '主教殘局';

  @override
  String get puzzleThemeBishopEndgameDescription => '只剩象和兵的殘局';

  @override
  String get puzzleThemeBodenMate => '波登殺法';

  @override
  String get puzzleThemeBodenMateDescription => '以在對角線上的兩個主教將死被自身棋子困住的王。';

  @override
  String get puzzleThemeCastling => '易位';

  @override
  String get puzzleThemeCastlingDescription => '讓國王回到安全，並讓車發動攻擊。';

  @override
  String get puzzleThemeCapturingDefender => '吃子 - 防守者';

  @override
  String get puzzleThemeCapturingDefenderDescription => '移除防守其他棋子的防守者以攻擊未被保護的棋子';

  @override
  String get puzzleThemeCrushing => '壓倒性優勢';

  @override
  String get puzzleThemeCrushingDescription => '察覺對方的漏著並藉此取得巨大優勢。(大於600百分兵)';

  @override
  String get puzzleThemeDoubleBishopMate => '雙主教將死';

  @override
  String get puzzleThemeDoubleBishopMateDescription => '相鄰對角線上的兩個主教將將死被自身棋子困住的王。';

  @override
  String get puzzleThemeDovetailMate => '柯齊奧將死';

  @override
  String get puzzleThemeDovetailMateDescription => '以皇后將死被自身棋子困住的國王';

  @override
  String get puzzleThemeEquality => '均勢';

  @override
  String get puzzleThemeEqualityDescription => '從劣勢中反敗為和。（分析值 ≤ 200厘兵）';

  @override
  String get puzzleThemeKingsideAttack => '王翼攻擊';

  @override
  String get puzzleThemeKingsideAttackDescription => '在對方於王翼易位後的攻擊。';

  @override
  String get puzzleThemeClearance => '騰挪';

  @override
  String get puzzleThemeClearanceDescription => '為了施展戰術而清除我方攻擊格上的障礙物。';

  @override
  String get puzzleThemeDefensiveMove => '加強防守';

  @override
  String get puzzleThemeDefensiveMoveDescription => '一種為了避免遺失棋子或優勢而採取的必要行動。';

  @override
  String get puzzleThemeDeflection => '引離';

  @override
  String get puzzleThemeDeflectionDescription => '為了分散敵人專注力所採取的戰術，容易搗亂敵人原本的計畫。';

  @override
  String get puzzleThemeDiscoveredAttack => '閃擊';

  @override
  String get puzzleThemeDiscoveredAttackDescription => '將一子（例如騎士）移開長程攻擊格（例如城堡）。';

  @override
  String get puzzleThemeDoubleCheck => '雙將';

  @override
  String get puzzleThemeDoubleCheckDescription => '雙重將軍，讓我方能攻擊敵人的他子。';

  @override
  String get puzzleThemeEndgame => '殘局';

  @override
  String get puzzleThemeEndgameDescription => '棋局中最後階段的戰術';

  @override
  String get puzzleThemeEnPassantDescription => '一種食敵方過路兵的戰略。';

  @override
  String get puzzleThemeExposedKing => '未被保護的國王';

  @override
  String get puzzleThemeExposedKingDescription => '攻擊未被保護的國王之戰術，常常導致將死。';

  @override
  String get puzzleThemeFork => '捉雙';

  @override
  String get puzzleThemeForkDescription => '一種同時攻擊敵方多個子，使敵方只能犧牲一子的戰術。';

  @override
  String get puzzleThemeHangingPiece => '懸子';

  @override
  String get puzzleThemeHangingPieceDescription => '「免費」取得他子的戰術';

  @override
  String get puzzleThemeHookMate => '鉤將死';

  @override
  String get puzzleThemeHookMateDescription => '利用車馬兵與一敵方兵以限制敵方國王的逃生路線。';

  @override
  String get puzzleThemeInterference => '干擾';

  @override
  String get puzzleThemeInterferenceDescription => '將一子擋在兩個敵方子之間以切斷防護，例如以騎士在兩車之間阻擋。';

  @override
  String get puzzleThemeIntermezzo => 'Intermezzo';

  @override
  String get puzzleThemeIntermezzoDescription =>
      '與其走正常的棋譜，不如威脅敵方子吧！這樣不但可以破壞敵方原先計畫，還可以讓敵人必須對威脅採取對應的動作。這種戰術又稱為「Zwischenzug」或「In between」。';

  @override
  String get puzzleThemeKillBoxMate => '殺戮箱將死';

  @override
  String get puzzleThemeKillBoxMateDescription =>
      '一個城堡在敵方國王旁邊，由皇后支援，同時封鎖國王的逃脫路徑。城堡和皇后會將敵方國王困在 3×3 的『殺戮箱』中。';

  @override
  String get puzzleThemeVukovicMate => '武科維奇將死';

  @override
  String get puzzleThemeVukovicMateDescription =>
      '一個城堡和一個騎士合作對國王發動將死。城堡執行將死攻擊，並由第三個棋子支援，而騎士則負責封鎖國王的逃脫路徑。';

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
  String get puzzleThemeMasterDescription => '從頭銜玩家的棋局中生成的謎題。';

  @override
  String get puzzleThemeMasterVsMaster => '大師對局';

  @override
  String get puzzleThemeMasterVsMasterDescription => '從兩位頭銜玩家的棋局中生成的謎題。';

  @override
  String get puzzleThemeMate => '將軍';

  @override
  String get puzzleThemeMateDescription => '以你的技能贏得勝利';

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
  String get puzzleThemeMateIn5Description => '看出較長的將死步驟。';

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
  String get puzzleThemePinDescription => '一種涉及「牽制」，讓一敵方子無法在讓其他更高價值的子不被受到攻擊下移動的戰術。';

  @override
  String get puzzleThemePromotion => '升變';

  @override
  String get puzzleThemePromotionDescription => '讓兵走到後排升變為皇后或其他高價值的子。';

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
  String get puzzleThemeQueensideAttackDescription => '在對方於后翼易位後的攻擊。';

  @override
  String get puzzleThemeQuietMove => '安靜的一着';

  @override
  String get puzzleThemeQuietMoveDescription => '隱藏在未來敵方無法避免的攻擊。';

  @override
  String get puzzleThemeRookEndgame => '車殘局';

  @override
  String get puzzleThemeRookEndgameDescription => '只剩車和兵的殘局';

  @override
  String get puzzleThemeSacrifice => '棄子';

  @override
  String get puzzleThemeSacrificeDescription => '犧牲我方子以在一系列的移動後得到優勢。';

  @override
  String get puzzleThemeShort => '短謎題';

  @override
  String get puzzleThemeShortDescription => '兩步獲勝';

  @override
  String get puzzleThemeSkewer => '串擊';

  @override
  String get puzzleThemeSkewerDescription => '攻擊敵方高價值的子以讓敵方移開，以攻擊背後較為低價值未受保護的他子。為一種反向的「牽制」。';

  @override
  String get puzzleThemeSmotheredMate => '悶殺';

  @override
  String get puzzleThemeSmotheredMateDescription => '一種以馬將死被自身棋子所圍困的國王。';

  @override
  String get puzzleThemeSuperGM => '超級大師賽局';

  @override
  String get puzzleThemeSuperGMDescription => '來自世界各地優秀玩家對局的戰術題';

  @override
  String get puzzleThemeTrappedPiece => '被困的棋子';

  @override
  String get puzzleThemeTrappedPieceDescription => '一子因為被限制逃生路線而無法逃離被犧牲的命運。';

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
  String get puzzleThemeXRayAttackDescription => '以敵方子攻擊或防守的戰術。';

  @override
  String get puzzleThemeZugzwang => '等著';

  @override
  String get puzzleThemeZugzwangDescription => '對方的棋子因為所移動的空間有限所以所到之處都會增加對方劣勢';

  @override
  String get puzzleThemeMix => '綜合';

  @override
  String get puzzleThemeMixDescription => '所有類型都有！你不知道會遇到什麼題型，所以請做好準備，就像在實戰一樣。';

  @override
  String get puzzleThemePlayerGames => '玩家謎題';

  @override
  String get puzzleThemePlayerGamesDescription => '查詢從你或其他玩家的對奕所生成的謎題。';

  @override
  String puzzleThemePuzzleDownloadInformation(String param) {
    return '這些為公開謎題，並且在 $param 提供下載管道。';
  }

  @override
  String get searchSearch => '搜尋';

  @override
  String get settingsSettings => '設定';

  @override
  String get settingsCloseAccount => '關閉帳戶';

  @override
  String get settingsManagedAccountCannotBeClosed => '您的帳號已被管理並且無法關閉。';

  @override
  String get settingsCantOpenSimilarAccount => '即使名稱大小寫不同，您也不能使用相同的名稱開設新帳戶';

  @override
  String get settingsCancelKeepAccount => '取消併保留我的帳號';

  @override
  String get settingsCloseAccountAreYouSure => '確定要關閉您的帳戶嗎？';

  @override
  String get settingsThisAccountIsClosed => '此帳號已被關閉。';

  @override
  String get playWithAFriend => '和好友下棋';

  @override
  String get playWithTheMachine => '和電腦下棋';

  @override
  String get toInviteSomeoneToPlayGiveThisUrl => '請分享此網址以邀人下棋';

  @override
  String get gameOver => '遊戲結束';

  @override
  String get waitingForOpponent => '正在等待對手';

  @override
  String get orLetYourOpponentScanQrCode => '或是讓對手掃描這個 QR code';

  @override
  String get waiting => '等待對手確認中';

  @override
  String get yourTurn => '該您走';

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
  String get white => '執白';

  @override
  String get black => '執黑';

  @override
  String get asWhite => '作為白方';

  @override
  String get asBlack => '作為黑方';

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
  String get itsYourTurn => '該您走！';

  @override
  String get cheatDetected => '偵測到作弊行為';

  @override
  String get kingInTheCenter => '王居中';

  @override
  String get threeChecks => '三次將軍';

  @override
  String get raceFinished => '王至第八排';

  @override
  String get variantEnding => '變體終局';

  @override
  String get newOpponent => '換個對手';

  @override
  String get yourOpponentWantsToPlayANewGameWithYou => '您的對手想和你複賽';

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
  String get whiteLeftTheGame => '白方棄賽';

  @override
  String get blackLeftTheGame => '黑方棄賽';

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
  String get computerAnalysisDisabled => '未啟用電腦分析';

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
  String get calculatingMoves => '計算著法中...';

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
  String get promoteVariation => '升級變化';

  @override
  String get makeMainLine => '將這步棋導入主要流程中';

  @override
  String get deleteFromHere => '從這處開始刪除';

  @override
  String get collapseVariations => '隱藏變體';

  @override
  String get expandVariations => '顯示變體';

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
  String get maybeIncludeMoreGamesFromThePreferencesMenu => '試著從設定中加入更多棋局';

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
  String get byCPL => '以厘兵損失';

  @override
  String get enable => '啟用';

  @override
  String get bestMoveArrow => '最佳移動的箭頭';

  @override
  String get showVariationArrows => '顯示變體箭頭';

  @override
  String get evaluationGauge => '評估條';

  @override
  String get multipleLines => '路線分析線';

  @override
  String get cpus => 'CPU 數量';

  @override
  String get memory => '記憶體';

  @override
  String get infiniteAnalysis => '無限分析';

  @override
  String get removesTheDepthLimit => '取消深度限制，可能會使您的電腦發熱。';

  @override
  String get blunder => '漏著';

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
  String get computersAreNotAllowedToPlay =>
      '電腦與電腦輔助棋手不允許參加對弈。對弈時，請勿從國際象棋引擎、資料庫以及其他棋手那裡獲取幫助。另外，強烈建議不要創建多個帳號；過分地使用多個帳號將導致封號。';

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
  String get otherPlayers => '其他玩家';

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
  String get username => '使用者名稱';

  @override
  String get usernameOrEmail => '使用者名稱或電郵地址';

  @override
  String get changeUsername => '更改使用者名稱';

  @override
  String get changeUsernameNotSame => '只能更改字母大小字。例如，將「johndoe」變成「JohnDoe」。';

  @override
  String get changeUsernameDescription => '更改使用者名稱。您最多可以更改一次字母大小寫。';

  @override
  String get signupUsernameHint => '請選擇一個妥當的使用者名稱。請注意使用者名稱無法再次更改，並且不妥當的名稱會導致帳號被封禁！';

  @override
  String get signupEmailHint => '僅用於密碼重置';

  @override
  String get password => '密碼';

  @override
  String get changePassword => '更改密碼';

  @override
  String get changeEmail => '更改電子郵件';

  @override
  String get email => '電子郵件';

  @override
  String get passwordReset => '重置密碼';

  @override
  String get forgotPassword => '忘記密碼？';

  @override
  String get error_weakPassword => '此密碼太常見，且很容易被猜到。';

  @override
  String get error_namePassword => '請不要把密碼設為使用者名稱。';

  @override
  String get blankedPassword => '你在其他站點使用過相同的密碼，並且這些站點已經失效。為確保你的 Lichess 帳戶安全，你需要設置新密碼。感謝你的理解。';

  @override
  String get youAreLeavingLichess => '你正要離開 Lichess';

  @override
  String get neverTypeYourPassword => '不要在其他網站輸入你的 Lichess 密碼！';

  @override
  String proceedToX(String param) {
    return '前往 $param';
  }

  @override
  String get passwordSuggestion => '不要使用他人建議的密碼，他們會用此密碼盜取你的帳戶。';

  @override
  String get emailSuggestion => '不要使用他人提供的電子郵件，他們會用它盜取您的帳號。';

  @override
  String get emailConfirmHelp => '協助電郵確認';

  @override
  String get emailConfirmNotReceived => '註冊後沒有收到確認郵件？';

  @override
  String get whatSignupUsername => '你用了什麼使用者名稱註冊？';

  @override
  String usernameNotFound(String param) {
    return '找不到使用者名稱 $param。';
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
    return '複製並貼上上面的文字然後把它發給$param';
  }

  @override
  String get waitForSignupHelp => '我們很快就會給你回覆，説明你完成註冊。';

  @override
  String accountConfirmed(String param) {
    return '使用者 $param 認證成功';
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
  String get gamesPlayed => '下過局數';

  @override
  String get ok => '確認';

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
  String get customPosition => '自定義局面';

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
  String get youHaveBeenTimedOut => '您已被禁言';

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
  String get freeOnlineChess => '免費線上西洋棋';

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
  String get noDrawBeforeSwissLimit => '在積分循環制錦標賽中，在下三十步棋前無法和局。';

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
  String get pasteTheFenStringHere => '在此處貼上 FEN 棋譜';

  @override
  String get pasteThePgnStringHere => '在此處貼上 PGN 棋譜';

  @override
  String get orUploadPgnFile => '或者上傳一個PGN文件';

  @override
  String get fromPosition => '自定義局面';

  @override
  String get continueFromHere => '從此處繼續';

  @override
  String get toStudy => '研究';

  @override
  String get importGame => '導入棋局';

  @override
  String get importGameExplanation => '貼上PGN棋譜後可以重播棋局，使用電腦分析、對局聊天室及取得此棋局的分享連結。';

  @override
  String get importGameCaveat => '變種分支將被刪除。 若要保存這些變種，請透過導入 PGN 棋譜建立一個研究。';

  @override
  String get importGameDataPrivacyWarning => '此為公開 PGN。若要導入私人棋局，請使用研究。';

  @override
  String get thisIsAChessCaptcha => '此為西洋棋驗證碼。';

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
  String get noNetwork => '離線';

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
  String get winner => '贏家';

  @override
  String get standing => '名次';

  @override
  String get createANewTournament => '建立新的錦標賽';

  @override
  String get tournamentCalendar => '錦標賽日程';

  @override
  String get conditionOfEntry => '加入限制:';

  @override
  String get advancedSettings => '進階設定';

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
  String get loadPosition => '載入佈局';

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
  String get realName => '真實名稱';

  @override
  String get setFlair => '設置你的身分';

  @override
  String get flair => '身分';

  @override
  String get youCanHideFlair => '你可以在設定中隱藏使用者身分。';

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
  String get onlineBots => '線上機器人';

  @override
  String get name => '名稱';

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
  String get website => '網頁版';

  @override
  String get mobile => '行動裝置';

  @override
  String get help => '幫助：';

  @override
  String get createANewTopic => '新話題';

  @override
  String get topics => '話題';

  @override
  String get posts => '貼文';

  @override
  String get lastPost => '最近貼文';

  @override
  String get views => '瀏覽';

  @override
  String get replies => '回覆';

  @override
  String get replyToThisTopic => '回覆此話題';

  @override
  String get reply => '回覆';

  @override
  String get message => '訊息';

  @override
  String get createTheTopic => '建立話題';

  @override
  String get reportAUser => '舉報使用者';

  @override
  String get user => '使用者';

  @override
  String get reason => '原因';

  @override
  String get whatIsIheMatter => '舉報原因？';

  @override
  String get cheat => '作弊';

  @override
  String get troll => '搗亂';

  @override
  String get other => '其他';

  @override
  String get reportCheatBoostHelp => '請詳細說明你舉報此使用者的具體原因並貼上遊戲連結。「他作弊」等簡短說明是不被接受的。';

  @override
  String get reportUsernameHelp =>
      '請詳細說明你舉報此使用者的具體原因。若必要請解釋其名詞的歷史意義、網路用語、或是此使用者名稱如何指桑罵槐。「他的使用者名稱不妥」等簡短說明是不被接受的。';

  @override
  String get reportProcessedFasterInEnglish => '若舉報內容為英文將會更快的被處理。';

  @override
  String get error_provideOneCheatedGameLink => '請提供至少一局作弊棋局的連結。';

  @override
  String by(String param) {
    return '作者：$param';
  }

  @override
  String importedByX(String param) {
    return '由$param導入';
  }

  @override
  String get thisTopicIsNowClosed => '此話題已關閉';

  @override
  String get blog => '部落格';

  @override
  String get notes => '備註';

  @override
  String get typePrivateNotesHere => '在此輸入私人備註';

  @override
  String get writeAPrivateNoteAboutThisUser => '備註用戶資訊';

  @override
  String get noNoteYet => '尚無備註';

  @override
  String get invalidUsernameOrPassword => '使用者名稱或密碼錯誤';

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
  String get letOtherPlayersFollowYou => '允許其他玩家關注';

  @override
  String get letOtherPlayersChallengeYou => '允許其他玩家發起挑戰';

  @override
  String get letOtherPlayersInviteYouToStudy => '允許其他棋手邀請你參加研討';

  @override
  String get sound => '音效';

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
  String get allSquaresOfTheBoard => '包括所有棋盤內的格子';

  @override
  String get onSlowGames => '慢棋時';

  @override
  String get always => '總是';

  @override
  String get never => '永不';

  @override
  String xCompetesInY(String param1, String param2) {
    return '$param1在$param2參加';
  }

  @override
  String get victory => '勝利';

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
    return '$param1在$param3模式下和$param2和棋';
  }

  @override
  String get timeline => '時間軸';

  @override
  String get starting => '起始時間：';

  @override
  String get allInformationIsPublicAndOptional => '所有資料為公開並且可被隱藏。';

  @override
  String get biographyDescription => '給一個自我介紹，例如興趣或您喜愛的選手等';

  @override
  String get listBlockedPlayers => '顯示黑名單';

  @override
  String get human => '人類';

  @override
  String get computer => '電腦';

  @override
  String get side => '方';

  @override
  String get clock => '棋鐘';

  @override
  String get opponent => '對手';

  @override
  String get learnMenu => '學習';

  @override
  String get studyMenu => '研究';

  @override
  String get practice => '練習';

  @override
  String get community => '社群';

  @override
  String get tools => '工具';

  @override
  String get increment => '加秒';

  @override
  String get error_unknown => '無效值';

  @override
  String get error_required => '本項必填';

  @override
  String get error_email => '無效電子郵件';

  @override
  String get error_email_acceptable => '該電子郵件地址無效。請重新檢查後重試。';

  @override
  String get error_email_unique => '電子郵件地址無效或已被使用';

  @override
  String get error_email_different => '這已經是您的電子郵件地址';

  @override
  String error_minLength(String param) {
    return '至少包含 $param 個字元';
  }

  @override
  String error_maxLength(String param) {
    return '最多包含 $param 個字元';
  }

  @override
  String error_min(String param) {
    return '最少包含 $param 個字符';
  }

  @override
  String error_max(String param) {
    return '最多不能超過 $param';
  }

  @override
  String ifRatingIsPlusMinusX(String param) {
    return '允許評級範圍±$param';
  }

  @override
  String get ifRegistered => '已登入者';

  @override
  String get onlyExistingConversations => '僅目前對話';

  @override
  String get onlyFriends => '只允許好友';

  @override
  String get menu => '選單';

  @override
  String get castling => '王車易位';

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
    return '花在Lichess TV的時間：$param';
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
    return '$param1是一個完全免費($param2)、開放性、無廣告、並且開源的網站';
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
    return '主持人所使用旗子顏色：$param';
  }

  @override
  String get yourPendingSimuls => '正在載入比賽';

  @override
  String get createdSimuls => '觀看最近開始的車輪戰';

  @override
  String get hostANewSimul => '主持車輪戰';

  @override
  String get signUpToHostOrJoinASimul => '註冊以舉辦或參與車輪戰';

  @override
  String get noSimulFound => '找不到該車輪戰';

  @override
  String get noSimulExplanation => '此車輪戰不存在。';

  @override
  String get returnToSimulHomepage => '返回車輪戰首頁';

  @override
  String get aboutSimul => '車輪戰涉及到一個人同時和幾位棋手下棋。';

  @override
  String get aboutSimulImage => '在50位對手中，費雪贏了47局、和了2局、並輸了1局。';

  @override
  String get aboutSimulRealLife => '這種賽制來自於真實的國際賽事。 在現實中，這涉及到主持人在棋局與棋局之間來回走棋。';

  @override
  String get aboutSimulRules => '當車輪賽開始時，每個玩家都會與主持人對奕，主持人持白。當所有對局結束表示車輪賽也一併結束。';

  @override
  String get aboutSimulSettings => '車輪賽事較為非正式的賽制。重賽、悔棋、以及加時功能皆會被禁用。';

  @override
  String get create => '建立';

  @override
  String get whenCreateSimul => '當您創建車輪戰時，您要同時跟幾個棋手一起下棋。';

  @override
  String get simulVariantsHint => '如果您選擇多個變體，每個玩家可以選擇自己所好的變體。';

  @override
  String get simulClockHint => '費雪棋鐘設定。棋手越多，您所需的時間可能就越多。';

  @override
  String get simulAddExtraTime => '您可以給您的時鍾多加點時間以幫助您應對車輪戰。';

  @override
  String get simulHostExtraTime => '主持人的額外時間';

  @override
  String get simulAddExtraTimePerPlayer => '每有一個玩家加入車輪戰，您棋鐘的初始時間都將增加。';

  @override
  String get simulHostExtraTimePerPlayer => '於每位玩家加入後棋鐘增加的額外時間';

  @override
  String get lichessTournaments => 'Lichess 錦標賽';

  @override
  String get tournamentFAQ => '競技場錦標賽常見問題';

  @override
  String get timeBeforeTournamentStarts => '錦標賽準備時間';

  @override
  String get averageCentipawnLoss => '平均厘兵損失';

  @override
  String get accuracy => '精準度';

  @override
  String get keyboardShortcuts => '快捷鍵';

  @override
  String get keyMoveBackwardOrForward => '後退/前進';

  @override
  String get keyGoToStartOrEnd => '跳轉到開始/結束';

  @override
  String get keyCycleSelectedVariation => '循環已選取的變體';

  @override
  String get keyShowOrHideComments => '顯示/隱藏評論';

  @override
  String get keyEnterOrExitVariation => '進入/退出變體';

  @override
  String get keyRequestComputerAnalysis => '請求引擎分析，從你的失誤中學習';

  @override
  String get keyNextLearnFromYourMistakes => '下一個 (從你的失誤中學習)';

  @override
  String get keyNextBlunder => '下一個漏著';

  @override
  String get keyNextMistake => '下一個錯誤';

  @override
  String get keyNextInaccuracy => '下一個輕微失誤';

  @override
  String get keyPreviousBranch => '上一個分支';

  @override
  String get keyNextBranch => '下一個分支';

  @override
  String get toggleVariationArrows => '顯示變體箭頭';

  @override
  String get cyclePreviousOrNextVariation => '循環上一個/下一個變體';

  @override
  String get toggleGlyphAnnotations => '顯示圖形標註';

  @override
  String get togglePositionAnnotations => '顯示位置標註';

  @override
  String get variationArrowsInfo => '變體箭頭讓你不需棋步列表導航';

  @override
  String get playSelectedMove => '走已選取的棋步';

  @override
  String get newTournament => '新比賽';

  @override
  String get tournamentHomeTitle => '富有各種時間以及變體的西洋棋錦標賽';

  @override
  String get tournamentHomeDescription =>
      '加入快節奏的國際象棋比賽！加入定時賽事，或創建自己的。子彈，閃電，經典，菲舍爾任意制，王到中心，三次將軍，並提供更多的選擇為無盡的國際象棋樂趣。';

  @override
  String get tournamentNotFound => '找不到該錦標賽';

  @override
  String get tournamentDoesNotExist => '這個錦標賽不存在。';

  @override
  String get tournamentMayHaveBeenCanceled => '錦標賽可能因為沒有其他玩家而取消。';

  @override
  String get returnToTournamentsHomepage => '返回錦標賽首頁';

  @override
  String weeklyPerfTypeRatingDistribution(String param) {
    return '本月$param的分數分布';
  }

  @override
  String yourPerfTypeRatingIsRating(String param1, String param2) {
    return '您的$param1目前$param2分。';
  }

  @override
  String youAreBetterThanPercentOfPerfTypePlayers(String param1, String param2) {
    return '您比$param1的$param2棋手更強。';
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
    return '您沒有準確的$param評級。';
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
  String get weHaveSentYouAnEmailClickTheLink => '我們已經發送了一封電子郵件到你的郵箱。點擊郵件中的連結以啟用帳號。';

  @override
  String get ifYouDoNotSeeTheEmailCheckOtherPlaces => '若您沒收到郵件，請檢查您的其他收件箱，例如垃圾箱、促銷、社交等。';

  @override
  String weHaveSentYouAnEmailTo(String param) {
    return '我們發送了一封郵件到 $param。點擊郵件中的連結來重置您的密碼。';
  }

  @override
  String byRegisteringYouAgreeToBeBoundByOur(String param) {
    return '註冊帳號表示同意並且遵守 $param';
  }

  @override
  String readAboutOur(String param) {
    return '閱讀我們的$param';
  }

  @override
  String get networkLagBetweenYouAndLichess => '您和 Lichess 之間的網路停滯';

  @override
  String get timeToProcessAMoveOnLichessServer => 'lichess 伺服器上處理走棋的時間';

  @override
  String get downloadAnnotated => '下載含有棋子走動方向的棋局';

  @override
  String get downloadRaw => '下載純文字';

  @override
  String get downloadImported => '下載導入的棋局';

  @override
  String get crosstable => '歷程表';

  @override
  String get youCanAlsoScrollOverTheBoardToMoveInTheGame => '您也可以捲動棋盤以移動。';

  @override
  String get scrollOverComputerVariationsToPreviewThem => '將鼠標移到電腦分析變種上進行預覽';

  @override
  String get analysisShapesHowTo => '按 shift 點及或右鍵棋盤上以繪製圓圈與箭頭。';

  @override
  String get letOtherPlayersMessageYou => '允許其他人發送私訊給您';

  @override
  String get receiveForumNotifications => '在論壇中被提及時接收通知';

  @override
  String get shareYourInsightsData => '顯示您的洞察數據';

  @override
  String get withNobody => '不顯示';

  @override
  String get withFriends => '好友';

  @override
  String get withEverybody => '所有人';

  @override
  String get kidMode => '兒童模式';

  @override
  String get kidModeIsEnabled => '已啟用兒童模式';

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
  String get sessions => '裝置';

  @override
  String get revokeAllSessions => '登出所有裝置';

  @override
  String get playChessEverywhere => '隨處下棋！';

  @override
  String get everybodyGetsAllFeaturesForFree => '每個人都能免費使用所有功能';

  @override
  String get viewTheSolution => '看解答';

  @override
  String get noChallenges => '沒有挑戰。';

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
  String get backgroundImageUrl => '背景圖片網址：';

  @override
  String get board => '棋盤外觀';

  @override
  String get size => '大小';

  @override
  String get opacity => '透明度';

  @override
  String get brightness => '亮度';

  @override
  String get hue => '色調';

  @override
  String get boardReset => '回復預設顏色設定';

  @override
  String get pieceSet => '棋子外觀設定';

  @override
  String get embedInYourWebsite => '嵌入您的網站';

  @override
  String get usernameAlreadyUsed => '該使用者名稱已被使用，請換一個試試！';

  @override
  String get usernamePrefixInvalid => '使用者名稱必須以字母開頭';

  @override
  String get usernameSuffixInvalid => '使用者名稱的結尾必須為字母或數字';

  @override
  String get usernameCharsInvalid => '使用者名稱只能包含字母、 數字、 底線和短劃線。';

  @override
  String get usernameUnacceptable => '無法套用此使用者名稱';

  @override
  String get playChessInStyle => '下棋也要穿得好看';

  @override
  String get chessBasics => '基本常識';

  @override
  String get coaches => '教練';

  @override
  String get invalidPgn => '無效的 PGN';

  @override
  String get invalidFen => '無效的 FEN';

  @override
  String get custom => '自訂設定';

  @override
  String get notifications => '通知';

  @override
  String notificationsX(String param1) {
    return '通知：$param1';
  }

  @override
  String perfRatingX(String param) {
    return '評分：$param';
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
  String get resumeLearning => '繼續學習';

  @override
  String get youCanDoBetter => '還有更好的移動';

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
  String get doItAgain => '再試一次';

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
  String get addCurrentVariation => '加入現有變種';

  @override
  String get playVariationToCreateConditionalPremoves => '走一種變種以建立棋譜';

  @override
  String get noConditionalPremoves => '無預設棋譜';

  @override
  String playX(String param) {
    return '移動至$param';
  }

  @override
  String get showUnreadLichessMessage => '你收到一個來自 Lichess 的私訊。';

  @override
  String get clickHereToReadIt => '點擊以閱讀';

  @override
  String get sorry => '抱歉：（';

  @override
  String get weHadToTimeYouOutForAWhile => '我們必須將您暫時封鎖';

  @override
  String get why => '為什麼？';

  @override
  String get pleasantChessExperience => '我們的目的在於維持良好的下棋環境';

  @override
  String get goodPractice => '為此，我們必須確保所有參與者都遵循良好做法';

  @override
  String get potentialProblem => '當檢測到不良行為時，我們將顯示此消息';

  @override
  String get howToAvoidThis => '如何避免這件事發生?';

  @override
  String get playEveryGame => '避免在棋局中任意退出';

  @override
  String get tryToWin => '試著在每個棋局裡獲勝(或至少平手)';

  @override
  String get resignLostGames => '投降（不要讓時間耗盡）';

  @override
  String get temporaryInconvenience => '我們對於給您帶來的不便深表歉意';

  @override
  String get wishYouGreatGames => '並祝您在 lichess.org 上玩得開心。';

  @override
  String get thankYouForReading => '感謝您的閱讀！';

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
  String get bullet => 'Bullet';

  @override
  String get blitz => 'Blitz';

  @override
  String get rapid => '快速模式';

  @override
  String get classical => '經典';

  @override
  String get ultraBulletDesc => '瘋狂速度模式：低於30秒';

  @override
  String get bulletDesc => '極快速模式：低於3分鐘';

  @override
  String get blitzDesc => '快速模式：3到8分鐘';

  @override
  String get rapidDesc => '一般模式：8到25分鐘';

  @override
  String get classicalDesc => '經典模式：25分鐘以上';

  @override
  String get correspondenceDesc => '通信模式：一天或好幾天一步';

  @override
  String get puzzleDesc => '西洋棋戰術教練';

  @override
  String get important => '重要';

  @override
  String yourQuestionMayHaveBeenAnswered(String param1) {
    return '您的問題可能已經有答案了$param1';
  }

  @override
  String get inTheFAQ => '在常見問答內';

  @override
  String toReportSomeoneForCheatingOrBadBehavior(String param1) {
    return '舉報一位作弊或違反善良風俗的玩家，$param1';
  }

  @override
  String get useTheReportForm => '請填寫回報表單';

  @override
  String toRequestSupport(String param1) {
    return '$param1以獲取協助';
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
    return '在「$param1」中提到了您。';
  }

  @override
  String xMentionedYouInY(String param1, String param2) {
    return '$param1 在「$param2」中提到了您。';
  }

  @override
  String invitedYouToX(String param1) {
    return '邀請您至「$param1」。';
  }

  @override
  String xInvitedYouToY(String param1, String param2) {
    return '$param1 邀請您至「$param2」。';
  }

  @override
  String get youAreNowPartOfTeam => '您現在是團隊的成員了。';

  @override
  String youHaveJoinedTeamX(String param1) {
    return '您已加入「$param1」。';
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
  String get lostAgainstTOSViolator => '你輸給了違反了服務條款的棋手';

  @override
  String refundXpointsTimeControlY(String param1, String param2) {
    return '退回 $param1 $param2 等級分。';
  }

  @override
  String get timeAlmostUp => '時間快到了！';

  @override
  String get clickToRevealEmailAddress => '[點擊以顯示電子郵件]';

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
  String get tournDescriptionHelp => '有甚麼特別要告訴參賽者的嗎？盡量不要太長。可以使用 Markdown 網址 [name](https://url)。';

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
    return '將一個有效的 FEN 貼上於此作為所有對局的起始位置。\n僅適用於標準西洋棋，對變種無效。\n你可以試用 $param 來生成 FEN，然後將其貼上到這裡。\n置空表示以預設位置開始比賽。';
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
  String get embedsAvailable => '貼上對局或學習章節網址來嵌入。';

  @override
  String get inYourLocalTimezone => '在您的時區內';

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
  String get reopenYourAccountDescription => '如果你停用了自己的帳號，但是改變了心意，你有一次的機會可以拿回帳號。';

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
  String get lichessPatronInfo => 'Lichess是個慈善、完全免費且開源的軟體。\n一切營運成本、開發和內容皆來自用戶之捐贈。';

  @override
  String get nothingToSeeHere => '目前這裡沒有什麼好看的。';

  @override
  String get stats => '統計';

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
    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '在$count步內將死對手');
    return '$_temp0';
  }

  @override
  String nbBlunders(int count) {
    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '$count 次漏著');
    return '$_temp0';
  }

  @override
  String numberBlunders(int count) {
    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '$count 次漏著');
    return '$_temp0';
  }

  @override
  String nbMistakes(int count) {
    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '$count 次失誤');
    return '$_temp0';
  }

  @override
  String numberMistakes(int count) {
    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '$count 次失誤');
    return '$_temp0';
  }

  @override
  String nbInaccuracies(int count) {
    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '$count 次輕微失誤');
    return '$_temp0';
  }

  @override
  String numberInaccuracies(int count) {
    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '$count 次輕微失誤');
    return '$_temp0';
  }

  @override
  String nbPlayers(int count) {
    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '$count位棋手目前在線');
    return '$_temp0';
  }

  @override
  String nbGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '查看所有$count盤棋');
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
    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '$count個收藏');
    return '$_temp0';
  }

  @override
  String nbDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '$count天');
    return '$_temp0';
  }

  @override
  String nbHours(int count) {
    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '$count小時');
    return '$_temp0';
  }

  @override
  String nbMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '$count 分鐘');
    return '$_temp0';
  }

  @override
  String rankIsUpdatedEveryNbMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '評分每 $count 分鐘更新一次');
    return '$_temp0';
  }

  @override
  String nbPuzzles(int count) {
    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '$count個題目');
    return '$_temp0';
  }

  @override
  String nbGamesWithYou(int count) {
    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '與您下過$count盤棋');
    return '$_temp0';
  }

  @override
  String nbRated(int count) {
    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '$count 場排位賽');
    return '$_temp0';
  }

  @override
  String nbWins(int count) {
    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '$count局勝');
    return '$_temp0';
  }

  @override
  String nbLosses(int count) {
    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '$count局負');
    return '$_temp0';
  }

  @override
  String nbDraws(int count) {
    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '$count局和');
    return '$_temp0';
  }

  @override
  String nbPlaying(int count) {
    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '$count下棋中');
    return '$_temp0';
  }

  @override
  String giveNbSeconds(int count) {
    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '給對方加$count秒');
    return '$_temp0';
  }

  @override
  String nbTournamentPoints(int count) {
    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '$count錦標賽得分');
    return '$_temp0';
  }

  @override
  String nbStudies(int count) {
    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '$count個研究');
    return '$_temp0';
  }

  @override
  String nbSimuls(int count) {
    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '$count 個進行的車輪戰棋局');
    return '$_temp0';
  }

  @override
  String moreThanNbRatedGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '完成至少 $count 場排位賽');
    return '$_temp0';
  }

  @override
  String moreThanNbPerfRatedGames(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '≥ $count $param2 排位賽');
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
    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '您需要再完成 $count 場排位賽');
    return '$_temp0';
  }

  @override
  String nbImportedGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '已導入$count盤棋局');
    return '$_temp0';
  }

  @override
  String nbFriendsOnline(int count) {
    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '$count 位好友在線');
    return '$_temp0';
  }

  @override
  String nbFollowers(int count) {
    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '$count個關注者');
    return '$_temp0';
  }

  @override
  String nbFollowing(int count) {
    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '關注$count人');
    return '$_temp0';
  }

  @override
  String lessThanNbMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '小於$count分鐘');
    return '$_temp0';
  }

  @override
  String nbGamesInPlay(int count) {
    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '$count場對局正在進行中');
    return '$_temp0';
  }

  @override
  String maximumNbCharacters(int count) {
    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '最多包含 $count 個字符');
    return '$_temp0';
  }

  @override
  String blocks(int count) {
    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '$count位黑名單使用者');
    return '$_temp0';
  }

  @override
  String nbForumPosts(int count) {
    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '$count個論壇貼文');
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
    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '支援$count種語言！');
    return '$_temp0';
  }

  @override
  String nbSecondsToPlayTheFirstMove(int count) {
    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '在$count秒前須下出第一步');
    return '$_temp0';
  }

  @override
  String nbSeconds(int count) {
    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '$count 秒');
    return '$_temp0';
  }

  @override
  String andSaveNbPremoveLines(int count) {
    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '以省略$count個預走的棋步');
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
    return '之前的最高紀錄：$param';
  }

  @override
  String get stormPlayAgain => '再玩一次';

  @override
  String stormHighscoreX(String param) {
    return '最高紀錄：$param';
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
  String get stormNewRun => '新的一輪 （快捷鍵：空白鍵）';

  @override
  String get stormEndRun => '結束此輪 （快捷鍵：Enter 鍵）';

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
  String get stormFailedPuzzles => '失敗的謎題';

  @override
  String get stormSlowPuzzles => '耗時謎題';

  @override
  String get stormSkippedPuzzle => '已跳過的謎題';

  @override
  String get stormThisWeek => '本星期';

  @override
  String get stormThisMonth => '本月';

  @override
  String get stormAllTime => '總計';

  @override
  String get stormClickToReload => '點擊以重新加載';

  @override
  String get stormThisRunHasExpired => '本輪已過期！';

  @override
  String get stormThisRunWasOpenedInAnotherTab => '本輪已經在另一個分頁中打開！';

  @override
  String stormXRuns(int count) {
    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '$count輪');
    return '$_temp0';
  }

  @override
  String stormPlayedNbRunsOfPuzzleStorm(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '玩了$count輪的$param2');
    return '$_temp0';
  }

  @override
  String get streamerLichessStreamers => 'Lichess 實況主';

  @override
  String get studyPrivate => '私人的';

  @override
  String get studyMyStudies => '我的研究';

  @override
  String get studyStudiesIContributeTo => '我有貢獻的研究';

  @override
  String get studyMyPublicStudies => '我的公開研究';

  @override
  String get studyMyPrivateStudies => '我的私人研究';

  @override
  String get studyMyFavoriteStudies => '我最愛的研究';

  @override
  String get studyWhatAreStudies => '研究是什麼?';

  @override
  String get studyAllStudies => '所有研究';

  @override
  String studyStudiesCreatedByX(String param) {
    return '$param創建的研究';
  }

  @override
  String get studyNoneYet => '暫時沒有...';

  @override
  String get studyHot => '熱門的';

  @override
  String get studyDateAddedNewest => '新增日期(由新到舊)';

  @override
  String get studyDateAddedOldest => '新增日期(由舊到新)';

  @override
  String get studyRecentlyUpdated => '最近更新';

  @override
  String get studyMostPopular => '最受歡迎';

  @override
  String get studyAlphabetical => '按字母順序';

  @override
  String get studyAddNewChapter => '加入新章節';

  @override
  String get studyAddMembers => '新增成員';

  @override
  String get studyInviteToTheStudy => '邀請加入研究';

  @override
  String get studyPleaseOnlyInvitePeopleYouKnow => '只邀請你所認識的人，以及願意積極投入的人來共同研究';

  @override
  String get studySearchByUsername => '透過使用者名稱搜尋';

  @override
  String get studySpectator => '觀眾';

  @override
  String get studyContributor => '共同研究者';

  @override
  String get studyKick => '踢出';

  @override
  String get studyLeaveTheStudy => '退出研究';

  @override
  String get studyYouAreNowAContributor => '你現在是一位研究者了';

  @override
  String get studyYouAreNowASpectator => '你現在是觀眾';

  @override
  String get studyPgnTags => 'PGN 標籤';

  @override
  String get studyLike => '喜歡';

  @override
  String get studyUnlike => '取消喜歡';

  @override
  String get studyNewTag => '新標籤';

  @override
  String get studyCommentThisPosition => '對於目前局面的評論';

  @override
  String get studyCommentThisMove => '對於此棋步的評論';

  @override
  String get studyAnnotateWithGlyphs => '以圖形標註';

  @override
  String get studyTheChapterIsTooShortToBeAnalysed => '因為太短，所以此章節無法被分析';

  @override
  String get studyOnlyContributorsCanRequestAnalysis => '只有研究專案編輯者才能要求電腦分析';

  @override
  String get studyGetAFullComputerAnalysis => '請求伺服器完整的分析主要走法';

  @override
  String get studyMakeSureTheChapterIsComplete => '確認此章節已完成，您只能要求分析一次';

  @override
  String get studyAllSyncMembersRemainOnTheSamePosition => '所有的SYNC成員處於相同局面';

  @override
  String get studyShareChanges => '向旁觀者分享這些變動並將其保留在伺服器中';

  @override
  String get studyPlaying => '下棋中';

  @override
  String get studyShowResults => '結果';

  @override
  String get studyShowEvalBar => '評估條';

  @override
  String get studyNext => '下一頁';

  @override
  String get studyShareAndExport => '分享 & 導出';

  @override
  String get studyCloneStudy => '複製';

  @override
  String get studyStudyPgn => '研究 PGN';

  @override
  String get studyChapterPgn => '章節PGN';

  @override
  String get studyCopyChapterPgn => '複製PGN';

  @override
  String get studyDownloadGame => '下載棋局';

  @override
  String get studyStudyUrl => '研究連結';

  @override
  String get studyCurrentChapterUrl => '目前章節連結';

  @override
  String get studyYouCanPasteThisInTheForumToEmbed => '您可以將此複製到論壇以嵌入';

  @override
  String get studyStartAtInitialPosition => '從起始局面開始';

  @override
  String studyStartAtX(String param) {
    return '從$param開始';
  }

  @override
  String get studyEmbedInYourWebsite => '嵌入到您的網站或部落格';

  @override
  String get studyReadMoreAboutEmbedding => '閱讀更多與嵌入有關的內容';

  @override
  String get studyOnlyPublicStudiesCanBeEmbedded => '只有公開的研究可以嵌入!';

  @override
  String get studyOpen => '打開';

  @override
  String studyXBroughtToYouByY(String param1, String param2) {
    return '$param1,由$param2提供';
  }

  @override
  String get studyStudyNotFound => '找無此研究';

  @override
  String get studyEditChapter => '編輯章節';

  @override
  String get studyNewChapter => '建立新章節';

  @override
  String studyImportFromChapterX(String param) {
    return '從 $param 導入';
  }

  @override
  String get studyOrientation => '視角';

  @override
  String get studyAnalysisMode => '分析模式';

  @override
  String get studyPinnedChapterComment => '置頂留言';

  @override
  String get studySaveChapter => '儲存章節';

  @override
  String get studyClearAnnotations => '清除註記';

  @override
  String get studyClearVariations => '清除變化';

  @override
  String get studyDeleteChapter => '刪除章節';

  @override
  String get studyDeleteThisChapter => '刪除此章節? 此動作將無法取消！';

  @override
  String get studyClearAllCommentsInThisChapter => '清除此章節中的所有註釋和圖形嗎？';

  @override
  String get studyRightUnderTheBoard => '棋盤下方';

  @override
  String get studyNoPinnedComment => '無';

  @override
  String get studyNormalAnalysis => '一般分析';

  @override
  String get studyHideNextMoves => '隱藏下一步';

  @override
  String get studyInteractiveLesson => '互動課程';

  @override
  String studyChapterX(String param) {
    return '章節$param';
  }

  @override
  String get studyEmpty => '空的';

  @override
  String get studyStartFromInitialPosition => '從起始局面開始';

  @override
  String get studyEditor => '編輯器';

  @override
  String get studyStartFromCustomPosition => '從自定的局面開始';

  @override
  String get studyLoadAGameByUrl => '以連結導入棋局';

  @override
  String get studyLoadAPositionFromFen => '透過FEN讀取局面';

  @override
  String get studyLoadAGameFromPgn => '以PGN文件導入棋局';

  @override
  String get studyAutomatic => '自動';

  @override
  String get studyUrlOfTheGame => '棋局連結，一行一個';

  @override
  String studyLoadAGameFromXOrY(String param1, String param2) {
    return '從$param1或$param2載入棋局';
  }

  @override
  String get studyCreateChapter => '建立章節';

  @override
  String get studyCreateStudy => '建立研究';

  @override
  String get studyEditStudy => '編輯此研究';

  @override
  String get studyVisibility => '權限';

  @override
  String get studyPublic => '公開的';

  @override
  String get studyUnlisted => '不公開';

  @override
  String get studyInviteOnly => '僅限邀請';

  @override
  String get studyAllowCloning => '可以複製';

  @override
  String get studyNobody => '没有人';

  @override
  String get studyOnlyMe => '僅自己';

  @override
  String get studyContributors => '貢獻者';

  @override
  String get studyMembers => '成員';

  @override
  String get studyEveryone => '所有人';

  @override
  String get studyEnableSync => '允許同步';

  @override
  String get studyYesKeepEveryoneOnTheSamePosition => '同步：讓所有人停留在同一個局面';

  @override
  String get studyNoLetPeopleBrowseFreely => '不同步：允許所有人自由進行瀏覽';

  @override
  String get studyPinnedStudyComment => '置頂研究留言';

  @override
  String get studyStart => '開始';

  @override
  String get studySave => '存檔';

  @override
  String get studyClearChat => '清空對話紀錄';

  @override
  String get studyDeleteTheStudyChatHistory => '確定要清空課程對話紀錄嗎？此操作無法還原！';

  @override
  String get studyDeleteStudy => '刪除此研究';

  @override
  String studyConfirmDeleteStudy(String param) {
    return '你確定要刪除整個研究？此動作無法反悔。輸入研究名稱確認：$param';
  }

  @override
  String get studyWhereDoYouWantToStudyThat => '要從哪裡開始研究呢？';

  @override
  String get studyGoodMove => '好棋';

  @override
  String get studyMistake => '失誤';

  @override
  String get studyBrilliantMove => '妙着';

  @override
  String get studyBlunder => '嚴重失誤';

  @override
  String get studyInterestingMove => '有趣的一着';

  @override
  String get studyDubiousMove => '值得商榷的一着';

  @override
  String get studyOnlyMove => '唯一著法';

  @override
  String get studyZugzwang => '等著';

  @override
  String get studyEqualPosition => '勢均力敵';

  @override
  String get studyUnclearPosition => '局勢不明';

  @override
  String get studyWhiteIsSlightlyBetter => '白方稍占優勢';

  @override
  String get studyBlackIsSlightlyBetter => '黑方稍占優勢';

  @override
  String get studyWhiteIsBetter => '白方占優勢';

  @override
  String get studyBlackIsBetter => '黑方占優勢';

  @override
  String get studyWhiteIsWinning => '白方要取得勝利了';

  @override
  String get studyBlackIsWinning => '黑方要取得勝利了';

  @override
  String get studyNovelty => '新奇的';

  @override
  String get studyDevelopment => '發展';

  @override
  String get studyInitiative => '佔據主動';

  @override
  String get studyAttack => '攻擊';

  @override
  String get studyCounterplay => '反擊';

  @override
  String get studyTimeTrouble => '時間壓力';

  @override
  String get studyWithCompensation => '優勢補償';

  @override
  String get studyWithTheIdea => '教科書式的';

  @override
  String get studyNextChapter => '下一章';

  @override
  String get studyPrevChapter => '上一章';

  @override
  String get studyStudyActions => '研討操作';

  @override
  String get studyTopics => '主題';

  @override
  String get studyMyTopics => '我的主題';

  @override
  String get studyPopularTopics => '熱門主題';

  @override
  String get studyManageTopics => '管理主題';

  @override
  String get studyBack => '返回';

  @override
  String get studyPlayAgain => '再玩一次';

  @override
  String get studyWhatWouldYouPlay => '你會在這個位置上怎麼走？';

  @override
  String get studyYouCompletedThisLesson => '恭喜！您完成了這個課程。';

  @override
  String studyPerPage(String param) {
    return '$param 每頁';
  }

  @override
  String get studyGetTheTour => '需要幫助？查看導覽！';

  @override
  String get studyWelcomeToLichessStudyTitle => '歡迎來到 Lichess 研究區！';

  @override
  String studyNbChapters(int count) {
    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '第$count章');
    return '$_temp0';
  }

  @override
  String studyNbGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '$count對局');
    return '$_temp0';
  }

  @override
  String studyNbMembers(int count) {
    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '$count位成員');
    return '$_temp0';
  }

  @override
  String studyPasteYourPgnTextHereUpToNbGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '在此貼上PGN文本，最多可導入$count個棋局',
    );
    return '$_temp0';
  }

  @override
  String get timeagoJustNow => '剛剛';

  @override
  String get timeagoRightNow => '現在';

  @override
  String get timeagoCompleted => '已結束';

  @override
  String timeagoInNbSeconds(int count) {
    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '$count秒後');
    return '$_temp0';
  }

  @override
  String timeagoInNbMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '$count分後');
    return '$_temp0';
  }

  @override
  String timeagoInNbHours(int count) {
    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '$count小時後');
    return '$_temp0';
  }

  @override
  String timeagoInNbDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '$count天後');
    return '$_temp0';
  }

  @override
  String timeagoInNbWeeks(int count) {
    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '$count週後');
    return '$_temp0';
  }

  @override
  String timeagoInNbMonths(int count) {
    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '$count個月後');
    return '$_temp0';
  }

  @override
  String timeagoInNbYears(int count) {
    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '$count年後');
    return '$_temp0';
  }

  @override
  String timeagoNbMinutesAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '$count分前');
    return '$_temp0';
  }

  @override
  String timeagoNbHoursAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '$count小時前');
    return '$_temp0';
  }

  @override
  String timeagoNbDaysAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '$count天前');
    return '$_temp0';
  }

  @override
  String timeagoNbWeeksAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '$count週前');
    return '$_temp0';
  }

  @override
  String timeagoNbMonthsAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '$count個月前');
    return '$_temp0';
  }

  @override
  String timeagoNbYearsAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '$count年前');
    return '$_temp0';
  }

  @override
  String timeagoNbMinutesRemaining(int count) {
    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '剩下 $count 分鐘');
    return '$_temp0';
  }

  @override
  String timeagoNbHoursRemaining(int count) {
    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '剩下 $count 小時');
    return '$_temp0';
  }
}
