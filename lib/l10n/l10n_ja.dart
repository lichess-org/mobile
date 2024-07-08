import 'package:intl/intl.dart' as intl;

import 'l10n.dart';

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

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
  String get activityActivity => '活動';

  @override
  String get activityHostedALiveStream => 'ライブ配信';

  @override
  String activityRankedInSwissTournament(String param1, String param2) {
    return '$param1 位（$param2）';
  }

  @override
  String get activitySignedUp => 'Lichess に登録';

  @override
  String activitySupportedNbMonths(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$param2 として lichess.org を $count か月間支援',
    );
    return '$_temp0';
  }

  @override
  String activityPracticedNbPositions(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 局面を $param2 で練習',
    );
    return '$_temp0';
  }

  @override
  String activitySolvedNbPuzzles(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 問のタクティクス問題に解答',
    );
    return '$_temp0';
  }

  @override
  String activityPlayedNbGames(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 局の $param2 をプレイ',
    );
    return '$_temp0';
  }

  @override
  String activityPostedNbMessages(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 件のメッセージを $param2 に投稿',
    );
    return '$_temp0';
  }

  @override
  String activityPlayedNbMoves(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 手をプレイ',
    );
    return '$_temp0';
  }

  @override
  String activityInNbCorrespondenceGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '（通信戦 $count 局で）',
    );
    return '$_temp0';
  }

  @override
  String activityCompletedNbGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 局の通信戦を完了',
    );
    return '$_temp0';
  }

  @override
  String activityFollowedNbPlayers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 人をフォロー開始',
    );
    return '$_temp0';
  }

  @override
  String activityGainedNbFollowers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 人の新規フォロワーを獲得',
    );
    return '$_temp0';
  }

  @override
  String activityHostedNbSimuls(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 回の同時対局を主催',
    );
    return '$_temp0';
  }

  @override
  String activityJoinedNbSimuls(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 回の同時対局に参加',
    );
    return '$_temp0';
  }

  @override
  String activityCreatedNbStudies(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 件の研究を作成',
    );
    return '$_temp0';
  }

  @override
  String activityCompetedInNbTournaments(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 回のトーナメントに参加',
    );
    return '$_temp0';
  }

  @override
  String activityRankedInTournament(int count, String param2, String param3, String param4) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 位（上位 $param2 %）（$param4 $param3 局で）',
    );
    return '$_temp0';
  }

  @override
  String activityCompetedInNbSwissTournaments(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 回のスイス式トーナメントに参加',
    );
    return '$_temp0';
  }

  @override
  String activityJoinedNbTeams(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count チームに参加',
    );
    return '$_temp0';
  }

  @override
  String get broadcastBroadcasts => 'イベント中継';

  @override
  String get broadcastLiveBroadcasts => '実戦トーナメントのライブ中継';

  @override
  String challengeChallengesX(String param1) {
    return 'チャレンジ：$param1';
  }

  @override
  String get challengeChallengeToPlay => '対局を申し込む';

  @override
  String get challengeChallengeDeclined => '挑戦が拒否されました。';

  @override
  String get challengeChallengeAccepted => '挑戦が承認されました！';

  @override
  String get challengeChallengeCanceled => '挑戦がキャンセルされました。';

  @override
  String get challengeRegisterToSendChallenges => '挑戦を送るには登録が必要です。';

  @override
  String challengeYouCannotChallengeX(String param) {
    return '$param には挑戦できません。';
  }

  @override
  String challengeXDoesNotAcceptChallenges(String param) {
    return '$param は挑戦を受け付けていません。';
  }

  @override
  String challengeYourXRatingIsTooFarFromY(String param1, String param2) {
    return 'あなたの $param1 レーティングは $param2 と離れすぎています。';
  }

  @override
  String challengeCannotChallengeDueToProvisionalXRating(String param) {
    return '$param レーティングが暫定のため挑戦できません。';
  }

  @override
  String challengeXOnlyAcceptsChallengesFromFriends(String param) {
    return '$param は友達からの挑戦しか受け付けません。';
  }

  @override
  String get challengeDeclineGeneric => '現在、挑戦を受け付けていません。';

  @override
  String get challengeDeclineLater => '今は都合が悪いので、後でもう一度尋ねてください。';

  @override
  String get challengeDeclineTooFast => 'この持時間は私には短すぎます。もっと長い持時間で挑戦してください。';

  @override
  String get challengeDeclineTooSlow => 'この持時間は私には長すぎます。もっと短い持時間で挑戦してください。';

  @override
  String get challengeDeclineTimeControl => '現在、この持時間での挑戦は受け付けていません。';

  @override
  String get challengeDeclineRated => '代わりにレート戦での挑戦を送ってください。';

  @override
  String get challengeDeclineCasual => '代わりに非レート戦での挑戦を送ってください。';

  @override
  String get challengeDeclineStandard => '現在、バリアントでの挑戦は受け付けていません。';

  @override
  String get challengeDeclineVariant => '今はこのバリアントで対戦するつもりはありません。';

  @override
  String get challengeDeclineNoBot => 'ボットからの挑戦は受け付けていません。';

  @override
  String get challengeDeclineOnlyBot => '私はボットからの挑戦しか受け付けません。';

  @override
  String get challengeInviteLichessUser => 'Lichess ユーザーを招待する：';

  @override
  String get contactContact => '各種連絡先';

  @override
  String get contactContactLichess => 'Lichess に連絡する';

  @override
  String get patronDonate => '寄付';

  @override
  String get patronLichessPatron => 'Lichess パトロン';

  @override
  String perfStatPerfStats(String param) {
    return '$param の統計';
  }

  @override
  String get perfStatViewTheGames => '対局を表示';

  @override
  String get perfStatProvisional => '仮定';

  @override
  String get perfStatNotEnoughRatedGames => 'レート戦が少なすぎて信頼できるレーティングが算出できません。';

  @override
  String perfStatProgressOverLastXGames(String param) {
    return '過去 $param 戦での変動：';
  }

  @override
  String perfStatRatingDeviation(String param) {
    return 'レーティング偏差：$param';
  }

  @override
  String perfStatRatingDeviationTooltip(String param1, String param2, String param3) {
    return '数字が小さいほどレーティングが安定していることになります。$param1 を超えていると暫定レーティングとなります。ランキング入りするにはこの数字が $param2 未満（通常ルール）か $param3 未満（バリアント）でなくてはなりません。';
  }

  @override
  String get perfStatTotalGames => '総局数';

  @override
  String get perfStatRatedGames => 'レート戦局数';

  @override
  String get perfStatTournamentGames => 'トーナメント対局数';

  @override
  String get perfStatBerserkedGames => 'バーサーク局数';

  @override
  String get perfStatTimeSpentPlaying => '総プレイ時間';

  @override
  String get perfStatAverageOpponent => '対局相手の平均';

  @override
  String get perfStatVictories => '勝ち';

  @override
  String get perfStatDefeats => '負け';

  @override
  String get perfStatDisconnections => '接続切れ';

  @override
  String get perfStatNotEnoughGames => '対局数が不十分';

  @override
  String perfStatHighestRating(String param) {
    return '最高レーティング：$param';
  }

  @override
  String perfStatLowestRating(String param) {
    return '最低レーティング：$param';
  }

  @override
  String perfStatFromXToY(String param1, String param2) {
    return '$param1 から $param2 まで';
  }

  @override
  String get perfStatWinningStreak => '連勝';

  @override
  String get perfStatLosingStreak => '連敗';

  @override
  String perfStatLongestStreak(String param) {
    return '最長：$param';
  }

  @override
  String perfStatCurrentStreak(String param) {
    return '現在：$param';
  }

  @override
  String get perfStatBestRated => '勝った相手の最高';

  @override
  String get perfStatGamesInARow => '連続対局数';

  @override
  String get perfStatLessThanOneHour => 'ゲーム間隔 1 時間以内';

  @override
  String get perfStatMaxTimePlaying => '最長連続プレイ時間';

  @override
  String get perfStatNow => '現在';

  @override
  String get preferencesPreferences => '設定';

  @override
  String get preferencesDisplay => '表示';

  @override
  String get preferencesPrivacy => 'プライバシー';

  @override
  String get preferencesNotifications => '通知';

  @override
  String get preferencesPieceAnimation => '駒のアニメーション速度';

  @override
  String get preferencesMaterialDifference => '駒の損得';

  @override
  String get preferencesBoardHighlights => '盤上のハイライト表示（最後の手、チェック）';

  @override
  String get preferencesPieceDestinations => '駒の行き先（ルール上動けるマス、プリムーブ）';

  @override
  String get preferencesBoardCoordinates => 'マスの座標（A-H, 1-8）';

  @override
  String get preferencesMoveListWhilePlaying => 'プレイ中の棋譜記録';

  @override
  String get preferencesPgnPieceNotation => 'PGN 駒表示方法';

  @override
  String get preferencesChessPieceSymbol => 'チェス駒シンボル';

  @override
  String get preferencesPgnLetter => '文字（K, Q, R, B, N）';

  @override
  String get preferencesZenMode => '集中モード';

  @override
  String get preferencesShowPlayerRatings => 'レーティングを表示';

  @override
  String get preferencesShowFlairs => 'プレイヤーのフレアを表示';

  @override
  String get preferencesExplainShowPlayerRatings => 'Lichess 上のすべてのレーティングが非表示となり、集中しやすくなります。対局はレート戦のままで、変わるのは表示の有無だけです。';

  @override
  String get preferencesDisplayBoardResizeHandle => '盤サイズ変更マークを表示';

  @override
  String get preferencesOnlyOnInitialPosition => 'ゲーム開始時のみ';

  @override
  String get preferencesInGameOnly => '対局中のみ';

  @override
  String get preferencesChessClock => '時間表示';

  @override
  String get preferencesTenthsOfSeconds => '0.1秒単位で時間表示';

  @override
  String get preferencesWhenTimeRemainingLessThanTenSeconds => '持時間が残り10秒以下の場合';

  @override
  String get preferencesHorizontalGreenProgressBars => '緑の棒（プログレスバー）を表示';

  @override
  String get preferencesSoundWhenTimeGetsCritical => '時間が迫ってきたら音を鳴らす';

  @override
  String get preferencesGiveMoreTime => '相手に時間追加';

  @override
  String get preferencesGameBehavior => '対局中の動作';

  @override
  String get preferencesHowDoYouMovePieces => '駒の移動方法';

  @override
  String get preferencesClickTwoSquares => '2 つのマスをクリック';

  @override
  String get preferencesDragPiece => '駒をドラッグ';

  @override
  String get preferencesBothClicksAndDrag => 'どちらでも';

  @override
  String get preferencesPremovesPlayingDuringOpponentTurn => 'プリムーブ（相手の手番中に次の自分の手を入力する）';

  @override
  String get preferencesTakebacksWithOpponentApproval => '待ったあり（相手が同意すれば）';

  @override
  String get preferencesInCasualGamesOnly => '非レート戦のみ';

  @override
  String get preferencesPromoteToQueenAutomatically => '自動的にクイーンに昇格する';

  @override
  String get preferencesExplainPromoteToQueenAutomatically => '<ctrl> キーを押しながら昇格させると、Q への自動昇格を一時的に無効にできます';

  @override
  String get preferencesWhenPremoving => 'プリムーブをした場合';

  @override
  String get preferencesClaimDrawOnThreefoldRepetitionAutomatically => '同形三復を自動的にドローにする';

  @override
  String get preferencesWhenTimeRemainingLessThanThirtySeconds => '持時間が残り30秒以下の場合';

  @override
  String get preferencesMoveConfirmation => '着手をそのつど確認する';

  @override
  String get preferencesExplainCanThenBeTemporarilyDisabled => 'ボードのメニューからゲーム中に無効にできます';

  @override
  String get preferencesInCorrespondenceGames => '通信チェスのみ';

  @override
  String get preferencesCorrespondenceAndUnlimited => '通信戦と持時間無制限';

  @override
  String get preferencesConfirmResignationAndDrawOffers => '投了とドロー提案を確認する';

  @override
  String get preferencesCastleByMovingTheKingTwoSquaresOrOntoTheRook => 'キャスリングの入力';

  @override
  String get preferencesCastleByMovingTwoSquares => 'キングを 2 マス動かす';

  @override
  String get preferencesCastleByMovingOntoTheRook => 'キングをルークの上に動かす';

  @override
  String get preferencesInputMovesWithTheKeyboard => '手をキーボードで入力';

  @override
  String get preferencesInputMovesWithVoice => '手を声で入力';

  @override
  String get preferencesSnapArrowsToValidMoves => '可能な手を矢印で表示';

  @override
  String get preferencesSayGgWpAfterLosingOrDrawing => '負けかドローの際に「Good game, well played」と言う';

  @override
  String get preferencesYourPreferencesHaveBeenSaved => '設定が保存されました。';

  @override
  String get preferencesScrollOnTheBoardToReplayMoves => 'ボード上スクロールで手を再現';

  @override
  String get preferencesCorrespondenceEmailNotification => '通信戦の対局をリストにした毎日のメール通知';

  @override
  String get preferencesNotifyStreamStart => '配信を始めた時';

  @override
  String get preferencesNotifyInboxMsg => '新しい着信メッセージ';

  @override
  String get preferencesNotifyForumMention => 'フォーラムであなたの名前が出た時';

  @override
  String get preferencesNotifyInvitedStudy => '研究への招待';

  @override
  String get preferencesNotifyGameEvent => '通信戦の進行状況';

  @override
  String get preferencesNotifyChallenge => '挑戦が来た時';

  @override
  String get preferencesNotifyTournamentSoon => 'トーナメントが間もなく開始';

  @override
  String get preferencesNotifyTimeAlarm => '通信戦の時間切迫';

  @override
  String get preferencesNotifyBell => 'Lichess にいる時にベル音';

  @override
  String get preferencesNotifyPush => 'Lichess にいない時にデバイスでの通知';

  @override
  String get preferencesNotifyWeb => 'ブラウザ';

  @override
  String get preferencesNotifyDevice => 'デバイス';

  @override
  String get preferencesBellNotificationSound => 'ベル通知の音';

  @override
  String get puzzlePuzzles => 'タクティクス問題';

  @override
  String get puzzlePuzzleThemes => '問題のテーマ';

  @override
  String get puzzleRecommended => 'おすすめ';

  @override
  String get puzzlePhases => '序盤・中盤・終盤';

  @override
  String get puzzleMotifs => 'モチーフ';

  @override
  String get puzzleAdvanced => '上級';

  @override
  String get puzzleLengths => '手数';

  @override
  String get puzzleMates => 'メイト';

  @override
  String get puzzleGoals => '目標';

  @override
  String get puzzleOrigin => '出所';

  @override
  String get puzzleSpecialMoves => '特殊な手';

  @override
  String get puzzleDidYouLikeThisPuzzle => 'この問題は気に入りましたか？';

  @override
  String get puzzleVoteToLoadNextOne => '投票すると次を読み込みます！';

  @override
  String get puzzleUpVote => '上げ投票';

  @override
  String get puzzleDownVote => '下げ投票';

  @override
  String get puzzleYourPuzzleRatingWillNotChange => 'あなたのレーティングは動きません。タクティクス問題は競技ではありません。レーティングは今のあなたのスキルに見合った問題を選ぶのに役立ちます。';

  @override
  String get puzzleFindTheBestMoveForWhite => '白の最善手を見つけてください。';

  @override
  String get puzzleFindTheBestMoveForBlack => '黒の最善手を見つけてください。';

  @override
  String get puzzleToGetPersonalizedPuzzles => 'あなたに合わせた問題を解くには:';

  @override
  String puzzlePuzzleId(String param) {
    return '問題番号 $param';
  }

  @override
  String get puzzlePuzzleOfTheDay => '本日の問題';

  @override
  String get puzzleDailyPuzzle => '本日の問題';

  @override
  String get puzzleClickToSolve => '問題を解く';

  @override
  String get puzzleGoodMove => '好手';

  @override
  String get puzzleBestMove => '最善手！';

  @override
  String get puzzleKeepGoing => '続ける…';

  @override
  String get puzzlePuzzleSuccess => '成功！';

  @override
  String get puzzlePuzzleComplete => '問題終了！';

  @override
  String get puzzleByOpenings => 'オープニング別';

  @override
  String get puzzlePuzzlesByOpenings => 'オープニング別の問題';

  @override
  String get puzzleOpeningsYouPlayedTheMost => 'レート戦でもっともよく使ったオープニング';

  @override
  String get puzzleUseFindInPage => 'ブラウザのページ内検索（Ctrl+F）を使えばお好きなオープニングが探せます。';

  @override
  String get puzzleUseCtrlF => 'Ctrl+F を使えばお好きなオープニングが探せます。';

  @override
  String get puzzleNotTheMove => 'その手は違います！';

  @override
  String get puzzleTrySomethingElse => '別の手をどうぞ。';

  @override
  String puzzleRatingX(String param) {
    return 'レーティング: $param';
  }

  @override
  String get puzzleHidden => '非表示';

  @override
  String puzzleFromGameLink(String param) {
    return 'ゲーム $param から';
  }

  @override
  String get puzzleContinueTraining => 'トレーニングを続ける';

  @override
  String get puzzleDifficultyLevel => '難易度';

  @override
  String get puzzleNormal => '通常';

  @override
  String get puzzleEasier => '易しい';

  @override
  String get puzzleEasiest => '非常に易しい';

  @override
  String get puzzleHarder => '難しい';

  @override
  String get puzzleHardest => '非常に難しい';

  @override
  String get puzzleExample => '例';

  @override
  String get puzzleAddAnotherTheme => '別のテーマを追加';

  @override
  String get puzzleNextPuzzle => '次の問題';

  @override
  String get puzzleJumpToNextPuzzleImmediately => '解いたらすぐ次の問題を読み込む';

  @override
  String get puzzlePuzzleDashboard => '問題成績データ';

  @override
  String get puzzleImprovementAreas => '改善ポイント';

  @override
  String get puzzleStrengths => '得意テーマ';

  @override
  String get puzzleHistory => '解答履歴';

  @override
  String get puzzleSolved => '正解';

  @override
  String get puzzleFailed => '失敗';

  @override
  String get puzzleStreakDescription => 'だんだん難しくなる問題に連続正解してください。時間制限はないのでじっくりとどうぞ。1 手間違えると終了です！　ただし途中 1 手だけ飛ばすことができます。';

  @override
  String puzzleYourStreakX(String param) {
    return '連続正解：$param';
  }

  @override
  String get puzzleStreakSkipExplanation => '手を飛ばすことで連続正解が続きます！ 1 回だけ有効。';

  @override
  String get puzzleContinueTheStreak => '連続正解を続ける';

  @override
  String get puzzleNewStreak => '新たなストリーク';

  @override
  String get puzzleFromMyGames => '自分のゲームから';

  @override
  String get puzzleLookupOfPlayer => 'ある人の対局から取った問題を検索';

  @override
  String puzzleFromXGames(String param) {
    return '$param の対局からの問題';
  }

  @override
  String get puzzleSearchPuzzles => '問題を検索';

  @override
  String get puzzleFromMyGamesNone => 'あなたの対局からの問題はまだありませんが、Lichess はあなたの参加を歓迎します。自分の対局が使われる可能性を増やすには、ラピッドかクラシカルでプレイしてください！';

  @override
  String puzzleFromXGamesFound(String param1, String param2) {
    return '$param1 問がヒット（全 $param2 局中）';
  }

  @override
  String get puzzlePuzzleDashboardDescription => '練習、分析、上達';

  @override
  String puzzlePercentSolved(String param) {
    return '$param に正解';
  }

  @override
  String get puzzleNoPuzzlesToShow => 'データがありません、まず問題をプレイしてから！';

  @override
  String get puzzleImprovementAreasDescription => 'ここのテーマを練習して前進！';

  @override
  String get puzzleStrengthDescription => 'これらのテーマで好成績でした';

  @override
  String puzzlePlayedXTimes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 回プレイ',
    );
    return '$_temp0';
  }

  @override
  String puzzleNbPointsBelowYourPuzzleRating(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'あなたのレーティングより $count 点下',
    );
    return '$_temp0';
  }

  @override
  String puzzleNbPointsAboveYourPuzzleRating(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'あなたのレーティングより $count 点上',
    );
    return '$_temp0';
  }

  @override
  String puzzleNbPlayed(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 問をプレイ',
    );
    return '$_temp0';
  }

  @override
  String puzzleNbToReplay(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 再挑戦',
    );
    return '$_temp0';
  }

  @override
  String get puzzleThemeAdvancedPawn => '進んだポーン';

  @override
  String get puzzleThemeAdvancedPawnDescription => 'ポーンの昇格かその狙いがテーマの問題。';

  @override
  String get puzzleThemeAdvantage => '優位';

  @override
  String get puzzleThemeAdvantageDescription => '決定的な優位を得てください。（評価値は 200cp 以上 600cp 以下）';

  @override
  String get puzzleThemeAnastasiaMate => 'アナスタシアのメイト';

  @override
  String get puzzleThemeAnastasiaMateDescription => '盤端と味方の駒にはさまれたキングを、ナイトとルーク（またはクイーン）でメイトする形。';

  @override
  String get puzzleThemeArabianMate => 'アラビアのメイト';

  @override
  String get puzzleThemeArabianMateDescription => '盤の隅にいるキングを、ナイトとルークでメイトする形。';

  @override
  String get puzzleThemeAttackingF2F7 => 'f2/f7への攻撃';

  @override
  String get puzzleThemeAttackingF2F7Description => 'f2 か f7 のポーンを狙う攻撃（フライド・リバー・アタックなど）。';

  @override
  String get puzzleThemeAttraction => 'アトラクション（引き寄せ）';

  @override
  String get puzzleThemeAttractionDescription => '交換か捨て駒によって相手の駒を不利なマスに誘い込む。';

  @override
  String get puzzleThemeBackRankMate => 'バックランク・メイト';

  @override
  String get puzzleThemeBackRankMateDescription => '一番下のランクで、上を自分の駒に塞がれたキングをメイトする。';

  @override
  String get puzzleThemeBishopEndgame => 'ビショップ・エンドゲーム';

  @override
  String get puzzleThemeBishopEndgameDescription => 'ビショップとポーンだけの終盤。';

  @override
  String get puzzleThemeBodenMate => 'ボーデンのメイト';

  @override
  String get puzzleThemeBodenMateDescription => '味方の駒にじゃまされたキングを、2 個のビショップが交差した効き筋でメイトする形。';

  @override
  String get puzzleThemeCastling => 'キャスリング';

  @override
  String get puzzleThemeCastlingDescription => 'キングを安全にし、ルークを攻撃に活用する。';

  @override
  String get puzzleThemeCapturingDefender => '守り駒の除去';

  @override
  String get puzzleThemeCapturingDefenderDescription => '別の駒を守っている駒を消して、無防備になった駒を取る。';

  @override
  String get puzzleThemeCrushing => '圧倒';

  @override
  String get puzzleThemeCrushingDescription => '相手の悪手をとがめて圧倒的な優位を築きます。（評価値は 600cp 以上）';

  @override
  String get puzzleThemeDoubleBishopMate => 'ダブル・ビショップのメイト';

  @override
  String get puzzleThemeDoubleBishopMateDescription => '味方の駒にじゃまされたキングを、2 個のビショップが平行な効き筋でメイトする形。';

  @override
  String get puzzleThemeDovetailMate => '燕尾のメイト';

  @override
  String get puzzleThemeDovetailMateDescription => '斜め後ろを両方とも味方の駒に塞がれたキングを、クイーン1個でメイトする形。';

  @override
  String get puzzleThemeEquality => '互角';

  @override
  String get puzzleThemeEqualityDescription => '劣勢の局面から、ドローを確保するか互角の局面に戻します。（評価値は 200cp 以下）';

  @override
  String get puzzleThemeKingsideAttack => 'キングサイド攻撃';

  @override
  String get puzzleThemeKingsideAttackDescription => 'キングサイドにキャスリングした相手のキングを攻撃する。';

  @override
  String get puzzleThemeClearance => 'クリアランス（解放）';

  @override
  String get puzzleThemeClearanceDescription => '次のタクティクスのためにマス、ファイル、斜線を開く手（先手であることが多い）。';

  @override
  String get puzzleThemeDefensiveMove => '守り';

  @override
  String get puzzleThemeDefensiveMoveDescription => '駒損などの不利を避けるために必要な正確な手または手順。';

  @override
  String get puzzleThemeDeflection => 'ディフレクション（そらし）';

  @override
  String get puzzleThemeDeflectionDescription => '相手の駒を別の役割（重要なマスを守るなど）からそらす手。';

  @override
  String get puzzleThemeDiscoveredAttack => 'ディスカバード・アタック';

  @override
  String get puzzleThemeDiscoveredAttackDescription => '別のラインピースの効きを止めていた駒を動かす手。たとえばルークの効き筋からナイトを動かす。';

  @override
  String get puzzleThemeDoubleCheck => 'ダブル・チェック';

  @override
  String get puzzleThemeDoubleCheckDescription => 'ディスカバード・アタックによって、動いた駒とラインピースが相手のキングに同時にチェックをかける手。';

  @override
  String get puzzleThemeEndgame => 'エンドゲーム';

  @override
  String get puzzleThemeEndgameDescription => 'ゲームの終盤でのタクティクス。';

  @override
  String get puzzleThemeEnPassantDescription => 'アンパッサン、つまり相手の 2 マス前進したポーンを途中で取る手を含むタクティクス。';

  @override
  String get puzzleThemeExposedKing => '危険なキング';

  @override
  String get puzzleThemeExposedKingDescription => '守り駒の少ないキングを攻める問題、多くの場合メイトにつながる。';

  @override
  String get puzzleThemeFork => 'フォーク（両取り）';

  @override
  String get puzzleThemeForkDescription => '動いた駒が相手の 2 つの駒を同時に攻撃する手。';

  @override
  String get puzzleThemeHangingPiece => '浮き駒';

  @override
  String get puzzleThemeHangingPieceDescription => '守りのない駒、または守り駒の足りない駒をただで取る問題。';

  @override
  String get puzzleThemeHookMate => '釣り針のメイト';

  @override
  String get puzzleThemeHookMateDescription => 'ポーンの隣にいるキングを、ルーク、ナイト、ポーンでメイトする形。';

  @override
  String get puzzleThemeInterference => 'インターフェア（干渉）';

  @override
  String get puzzleThemeInterferenceDescription => '相手の 2 つの駒の間に駒を入れて浮き駒を作る問題。相手の 2 個のルークの間に守られたナイトを入れる、など。';

  @override
  String get puzzleThemeIntermezzo => 'ツヴィッシェンツーク（利かし）';

  @override
  String get puzzleThemeIntermezzoDescription => '当然に見える手を指す代わりに、いったん相手が受けざるを得ない別の手をはさむ問題。';

  @override
  String get puzzleThemeKnightEndgame => 'ナイト・エンドゲーム';

  @override
  String get puzzleThemeKnightEndgameDescription => 'ナイトとポーンだけの終盤。';

  @override
  String get puzzleThemeLong => '長手数問題';

  @override
  String get puzzleThemeLongDescription => '3 手で勝ちになります。';

  @override
  String get puzzleThemeMaster => 'マスターのゲーム';

  @override
  String get puzzleThemeMasterDescription => 'タイトル保持者の対局から採った問題。';

  @override
  String get puzzleThemeMasterVsMaster => 'マスター同士のゲーム';

  @override
  String get puzzleThemeMasterVsMasterDescription => '双方がタイトル保持者の対局から採った問題。';

  @override
  String get puzzleThemeMate => 'メイト';

  @override
  String get puzzleThemeMateDescription => 'きれいに勝ちを決める。';

  @override
  String get puzzleThemeMateIn1 => '1 手メイト';

  @override
  String get puzzleThemeMateIn1Description => '1 手でチェックメイトにします。';

  @override
  String get puzzleThemeMateIn2 => '2 手メイト';

  @override
  String get puzzleThemeMateIn2Description => '2 手でチェックメイトにします。';

  @override
  String get puzzleThemeMateIn3 => '3 手メイト';

  @override
  String get puzzleThemeMateIn3Description => '3 手でチェックメイトにします。';

  @override
  String get puzzleThemeMateIn4 => '4 手メイト';

  @override
  String get puzzleThemeMateIn4Description => '4 手でチェックメイトにします。';

  @override
  String get puzzleThemeMateIn5 => '5 手以上メイト';

  @override
  String get puzzleThemeMateIn5Description => '長いメイトの手順を考える。';

  @override
  String get puzzleThemeMiddlegame => 'ミドルゲーム';

  @override
  String get puzzleThemeMiddlegameDescription => 'ゲームの中盤でのタクティクス。';

  @override
  String get puzzleThemeOneMove => '1 手問題';

  @override
  String get puzzleThemeOneMoveDescription => '1 手だけ動かす問題。';

  @override
  String get puzzleThemeOpening => 'オープニング';

  @override
  String get puzzleThemeOpeningDescription => 'ゲームの序盤でのタクティクス。';

  @override
  String get puzzleThemePawnEndgame => 'ポーン・エンドゲーム';

  @override
  String get puzzleThemePawnEndgameDescription => 'ポーンだけの終盤。';

  @override
  String get puzzleThemePin => 'ピン';

  @override
  String get puzzleThemePinDescription => 'ピンを含む問題。ラインピースに狙われた駒が動くと、より価値の高い駒が取られてしまう状況。';

  @override
  String get puzzleThemePromotion => 'プロモーション';

  @override
  String get puzzleThemePromotionDescription => 'ポーンの昇格かその狙いがテーマの問題。';

  @override
  String get puzzleThemeQueenEndgame => 'クイーン・エンドゲーム';

  @override
  String get puzzleThemeQueenEndgameDescription => 'クイーンとポーンだけの終盤。';

  @override
  String get puzzleThemeQueenRookEndgame => 'クイーンとルーク';

  @override
  String get puzzleThemeQueenRookEndgameDescription => 'クイーン、ルーク、ポーンだけの終盤。';

  @override
  String get puzzleThemeQueensideAttack => 'クイーンサイド攻撃';

  @override
  String get puzzleThemeQueensideAttackDescription => 'クイーンサイドにキャスリングした相手のキングを攻撃する。';

  @override
  String get puzzleThemeQuietMove => '静かな手';

  @override
  String get puzzleThemeQuietMoveDescription => 'チェックでも駒取りでもないが、次に防げない狙いを用意する手。';

  @override
  String get puzzleThemeRookEndgame => 'ルーク・エンドゲーム';

  @override
  String get puzzleThemeRookEndgameDescription => 'ルークとポーンだけの終盤。';

  @override
  String get puzzleThemeSacrifice => 'サクリファイス（捨て駒）';

  @override
  String get puzzleThemeSacrificeDescription => '短期的な駒損を含み、強制的な手順の後に優位を築く問題。';

  @override
  String get puzzleThemeShort => '短手数問題';

  @override
  String get puzzleThemeShortDescription => '2 手で勝ちになります。';

  @override
  String get puzzleThemeSkewer => 'スキュアー（串刺し）';

  @override
  String get puzzleThemeSkewerDescription => 'ラインピースで価値の高い駒を攻撃し、それが逃げた後で背後にある価値の低い駒を取るタクティクス。ピンの裏返し。';

  @override
  String get puzzleThemeSmotheredMate => 'スマザード・メイト';

  @override
  String get puzzleThemeSmotheredMateDescription => 'キングが味方の駒に囲まれて動けない時（スマザー＝窒息している時）に、ナイト 1 個でかけるメイト。';

  @override
  String get puzzleThemeSuperGM => 'スーパー GM の対局';

  @override
  String get puzzleThemeSuperGMDescription => '世界の一流選手の対局から採った問題。';

  @override
  String get puzzleThemeTrappedPiece => '敵駒を殺す';

  @override
  String get puzzleThemeTrappedPieceDescription => '相手の駒の動きを制限して、逃げられない状態にする問題。';

  @override
  String get puzzleThemeUnderPromotion => 'アンダープロモーション';

  @override
  String get puzzleThemeUnderPromotionDescription => 'ナイト、ビショップ、ルークへの昇格。';

  @override
  String get puzzleThemeVeryLong => '超長手数問題';

  @override
  String get puzzleThemeVeryLongDescription => '4 手以上で勝ちになります。';

  @override
  String get puzzleThemeXRayAttack => 'Ｘ線攻撃';

  @override
  String get puzzleThemeXRayAttackDescription => '相手の駒の向こうにあるマスを間接的に攻撃（または防御）する。';

  @override
  String get puzzleThemeZugzwang => 'ツークツワンク';

  @override
  String get puzzleThemeZugzwangDescription => '相手の指せる手が、どれを選んでも局面を悪くしてしまう形。';

  @override
  String get puzzleThemeHealthyMix => '混合';

  @override
  String get puzzleThemeHealthyMixDescription => 'いろいろな問題を少しずつ。どんな問題が来るかわからないので油断しないで！　実戦と同じです。';

  @override
  String get puzzleThemePlayerGames => 'プレイヤーの対局';

  @override
  String get puzzleThemePlayerGamesDescription => '自分の対局、他のプレイヤーの対局から取られた問題を検索します。';

  @override
  String puzzleThemePuzzleDownloadInformation(String param) {
    return 'これらの問題はパブリックドメインにあり、$param でダウンロードできます。';
  }

  @override
  String get searchSearch => '検索';

  @override
  String get settingsSettings => '設定';

  @override
  String get settingsCloseAccount => 'アカウント停止';

  @override
  String get settingsManagedAccountCannotBeClosed => 'あなたのアカウントは別の人が管理しており、自分では停止できません。';

  @override
  String get settingsClosingIsDefinitive => 'アカウント停止は不可逆で、元には戻せません。ほんとうに停止しますか？';

  @override
  String get settingsCantOpenSimilarAccount => '同じ名前（大文字・小文字が違っていても）で別のアカウントを作ることもできません。';

  @override
  String get settingsChangedMindDoNotCloseAccount => '気が変わったのでアカウントを停止しない';

  @override
  String get settingsCloseAccountExplanation => 'ほんとうにアカウントを停止しますか？　これは永久的な決定です。このアカウントには二度とログインできなくなります。';

  @override
  String get settingsThisAccountIsClosed => 'このアカウントは停止されました';

  @override
  String get playWithAFriend => '友達と対局する';

  @override
  String get playWithTheMachine => 'AI と対局する';

  @override
  String get toInviteSomeoneToPlayGiveThisUrl => '誰かを招待する時はこのURLを送ってください';

  @override
  String get gameOver => '終局';

  @override
  String get waitingForOpponent => '相手を待っています';

  @override
  String get orLetYourOpponentScanQrCode => 'または相手にこの QR コードをスキャンさせてください';

  @override
  String get waiting => '待機中';

  @override
  String get yourTurn => 'あなたの手番です';

  @override
  String aiNameLevelAiLevel(String param1, String param2) {
    return '$param1 レベル $param2';
  }

  @override
  String get level => 'レベル';

  @override
  String get strength => '強さ';

  @override
  String get toggleTheChat => 'チャットのオン・オフ';

  @override
  String get chat => 'チャット';

  @override
  String get resign => '投了';

  @override
  String get checkmate => 'チェックメイト';

  @override
  String get stalemate => 'ステイルメイト';

  @override
  String get white => '白';

  @override
  String get black => '黒';

  @override
  String get asWhite => '白番';

  @override
  String get asBlack => '黒番';

  @override
  String get randomColor => 'ランダム';

  @override
  String get createAGame => '対局を作成する';

  @override
  String get whiteIsVictorious => '白の勝ちです';

  @override
  String get blackIsVictorious => '黒の勝ちです';

  @override
  String get youPlayTheWhitePieces => 'あなたは白です';

  @override
  String get youPlayTheBlackPieces => 'あなたは黒です';

  @override
  String get itsYourTurn => 'あなたの手番です！';

  @override
  String get cheatDetected => '不正行為検出';

  @override
  String get kingInTheCenter => 'キングが中央マスに入りました';

  @override
  String get threeChecks => '3 回チェック成功';

  @override
  String get raceFinished => 'レースが終了しました';

  @override
  String get variantEnding => 'バリアントエンディング';

  @override
  String get newOpponent => '新しい相手';

  @override
  String get yourOpponentWantsToPlayANewGameWithYou => '相手がもう一度対局したいと言っています';

  @override
  String get joinTheGame => '対局に参加する';

  @override
  String get whitePlays => '白の手番';

  @override
  String get blackPlays => '黒の手番';

  @override
  String get opponentLeftChoices => '相手が退席したようです。投了させる、引き分けにする、相手を待つ、のどれかを選んでください。';

  @override
  String get forceResignation => '投了させる';

  @override
  String get forceDraw => '引き分けにする';

  @override
  String get talkInChat => 'チャットでは礼儀を忘れず';

  @override
  String get theFirstPersonToComeOnThisUrlWillPlayWithYou => 'このURLを最初にクリックした人があなたと対局します。';

  @override
  String get whiteResigned => '白が投了しました';

  @override
  String get blackResigned => '黒が投了しました';

  @override
  String get whiteLeftTheGame => '白が退席しました';

  @override
  String get blackLeftTheGame => '黒が退席しました';

  @override
  String get whiteDidntMove => '白、手を指さず';

  @override
  String get blackDidntMove => '黒、手を指さず';

  @override
  String get requestAComputerAnalysis => 'コンピューター解析をリクエスト';

  @override
  String get computerAnalysis => 'コンピューター解析';

  @override
  String get computerAnalysisAvailable => 'コンピュータ解析がされています';

  @override
  String get computerAnalysisDisabled => 'コンピュータ解析は不使用です';

  @override
  String get analysis => '棋譜解析';

  @override
  String depthX(String param) {
    return '深度 $param';
  }

  @override
  String get usingServerAnalysis => 'サーバ解析を使用中';

  @override
  String get loadingEngine => 'エンジン読込中…';

  @override
  String get calculatingMoves => '手を読んでいます…';

  @override
  String get engineFailed => 'エンジン読み込みエラー';

  @override
  String get cloudAnalysis => 'クラウド解析';

  @override
  String get goDeeper => 'より深く';

  @override
  String get showThreat => '狙いを表示';

  @override
  String get inLocalBrowser => 'ローカル ブラウザ内での解析';

  @override
  String get toggleLocalEvaluation => 'ローカル評価値のオン/オフ';

  @override
  String get promoteVariation => '変化を主手順にする';

  @override
  String get makeMainLine => '主手順にする';

  @override
  String get deleteFromHere => 'これ以降を削除';

  @override
  String get collapseVariations => '変化手順をかくす';

  @override
  String get expandVariations => '変化手順を表示する';

  @override
  String get forceVariation => '変化として表示';

  @override
  String get copyVariationPgn => '手順の PGN をコピー';

  @override
  String get move => '手';

  @override
  String get variantLoss => 'バリアント負け';

  @override
  String get variantWin => 'バリアント勝ち';

  @override
  String get insufficientMaterial => '戦力不足';

  @override
  String get pawnMove => 'ポーンの手';

  @override
  String get capture => '駒取り';

  @override
  String get close => '閉じる';

  @override
  String get winning => '勝勢';

  @override
  String get losing => '敗勢';

  @override
  String get drawn => 'ドロー';

  @override
  String get unknown => '不明';

  @override
  String get database => 'データベース';

  @override
  String get whiteDrawBlack => '白勝 / ドロー / 黒勝';

  @override
  String averageRatingX(String param) {
    return '平均レーティング: $param';
  }

  @override
  String get recentGames => '最近の対局';

  @override
  String get topGames => 'トップの対局';

  @override
  String masterDbExplanation(String param1, String param2, String param3) {
    return '$param2 年から $param3 年まで、FIDEレーティング $param1 以上の対局が200 万局あります';
  }

  @override
  String get dtzWithRounding => 'DTZ50*（丸めあり）、次の駒取りかポーンの移動までの半手単位の手数による';

  @override
  String get noGameFound => '対局が見つかりません';

  @override
  String get maxDepthReached => '最大深度に到達！';

  @override
  String get maybeIncludeMoreGamesFromThePreferencesMenu => '設定メニューからさらに広い範囲を指定しますか？';

  @override
  String get openings => 'オープニング';

  @override
  String get openingExplorer => 'オープニング探索';

  @override
  String get openingEndgameExplorer => '序盤／終盤エクスプローラー';

  @override
  String xOpeningExplorer(String param) {
    return '$param オープニング探索';
  }

  @override
  String get playFirstOpeningEndgameExplorerMove => '序盤／終盤エクスプローラーの最初の手を指す';

  @override
  String get winPreventedBy50MoveRule => '勝勢ながら 50 手ルールでドロー';

  @override
  String get lossSavedBy50MoveRule => '敗勢ながら 50 手ルールでドロー';

  @override
  String get winOr50MovesByPriorMistake => '勝ち、または以前の悪手のため50手ドロー';

  @override
  String get lossOr50MovesByPriorMistake => '負け、または以前の悪手のため50手ドロー';

  @override
  String get unknownDueToRounding => '勝ち／負けが確実なのは、最後の駒取りかポーンの移動からずっとテーブルベースの推奨ラインに従った場合のみです（丸めの可能性のため）。';

  @override
  String get allSet => '準備完了！';

  @override
  String get importPgn => 'PGN をインポート';

  @override
  String get delete => '削除';

  @override
  String get deleteThisImportedGame => 'ほんとうに削除しますか？';

  @override
  String get replayMode => '再現の方式';

  @override
  String get realtimeReplay => 'リアルタイム';

  @override
  String get byCPL => '評価値で';

  @override
  String get openStudy => '研究を開く';

  @override
  String get enable => '解析する';

  @override
  String get bestMoveArrow => '最善手を表示';

  @override
  String get showVariationArrows => '変化手順の矢印を表示';

  @override
  String get evaluationGauge => '評価値を表示';

  @override
  String get multipleLines => '解析ライン数';

  @override
  String get cpus => 'スレッド数';

  @override
  String get memory => 'メモリ';

  @override
  String get infiniteAnalysis => '無限解析';

  @override
  String get removesTheDepthLimit => '探索手数の制限をなくし最大限の解析を行なう';

  @override
  String get engineManager => '解析エンジンの管理';

  @override
  String get blunder => '大悪手';

  @override
  String get mistake => '悪手';

  @override
  String get inaccuracy => '疑問手';

  @override
  String get moveTimes => '消費時間';

  @override
  String get flipBoard => '盤の上下反転';

  @override
  String get threefoldRepetition => '同形三復';

  @override
  String get claimADraw => '引き分けを申し立てる';

  @override
  String get offerDraw => '引き分けを提案する';

  @override
  String get draw => '引き分け';

  @override
  String get drawByMutualAgreement => '合意によるドロー';

  @override
  String get fiftyMovesWithoutProgress => '50 手中駒取りもポーンの手もなし';

  @override
  String get currentGames => '現在対局中';

  @override
  String get viewInFullSize => 'フルサイズで見る';

  @override
  String get logOut => 'ログアウト';

  @override
  String get signIn => 'ログイン';

  @override
  String get rememberMe => '次から自動ログイン';

  @override
  String get youNeedAnAccountToDoThat => 'アカウントが必要です';

  @override
  String get signUp => '登録';

  @override
  String get computersAreNotAllowedToPlay => 'コンピューターの力を借りての対局は禁止されています。対局中にチェスエンジン、データベース、他人の助言は厳禁です。また、複数アカウントの使用も追放の可能性があります。';

  @override
  String get games => '局';

  @override
  String get forum => 'フォーラム';

  @override
  String xPostedInForumY(String param1, String param2) {
    return '$param1 が $param2 に投稿しました';
  }

  @override
  String get latestForumPosts => '最新のフォーラム記事';

  @override
  String get players => 'プレイヤー';

  @override
  String get friends => '友達';

  @override
  String get discussions => 'トピック';

  @override
  String get today => '今日';

  @override
  String get yesterday => '昨日';

  @override
  String get minutesPerSide => '持ち時間';

  @override
  String get variant => 'バリアント';

  @override
  String get variants => '変則チェス';

  @override
  String get timeControl => '持時間';

  @override
  String get realTime => '実時間';

  @override
  String get correspondence => '通信チェス';

  @override
  String get daysPerTurn => '1 手あたり日数';

  @override
  String get oneDay => '1日';

  @override
  String get time => '時間';

  @override
  String get rating => 'レーティング';

  @override
  String get ratingStats => 'レーティングの統計';

  @override
  String get username => 'ユーザー名';

  @override
  String get usernameOrEmail => 'ユーザー名、またはメールアドレス';

  @override
  String get changeUsername => 'ユーザー名の変更';

  @override
  String get changeUsernameNotSame => '大文字・小文字の変更だけができます（johndoe を JohnDoeに、など）';

  @override
  String get changeUsernameDescription => 'ユーザー名を変更します。これは一回限りで、行なえるのは大文字・小文字の変更だけです。';

  @override
  String get signupUsernameHint => 'ユーザー名は無難なものにしてください。後で変えることはできないし、ユーザー名が不適切だとアカウントが閉鎖されます！';

  @override
  String get signupEmailHint => 'この情報はパスワードのリセットにのみ使用します。';

  @override
  String get password => 'パスワード';

  @override
  String get changePassword => 'パスワードの変更';

  @override
  String get changeEmail => 'メールアドレスの変更';

  @override
  String get email => 'メールアドレス';

  @override
  String get passwordReset => 'パスワードをリセットする';

  @override
  String get forgotPassword => 'パスワードを忘れた方はこちら';

  @override
  String get error_weakPassword => 'このパスワードはありふれすぎていて簡単に破られます。';

  @override
  String get error_namePassword => 'パスワードはユーザー名と同じにしないでください。';

  @override
  String get blankedPassword => 'あなたは別のサイトで同じパスワードを使用し、そのサイトは侵入を受けています。 Lichess アカウントの安全性のため、新しいパスワードを設定してください。ご理解に感謝します。';

  @override
  String get youAreLeavingLichess => 'Lichess から移動します';

  @override
  String get neverTypeYourPassword => '別のサイトで同じパスワードを使わないで！';

  @override
  String proceedToX(String param) {
    return '$param に移動する';
  }

  @override
  String get passwordSuggestion => '他の人が提案したパスワードは使わないように。アカウントが乗っ取られるかもしれません。';

  @override
  String get emailSuggestion => '他の人が提案したメールアドレスは使わないように。アカウントが乗っ取られるかもしれません。';

  @override
  String get emailConfirmHelp => '確認メールについてのヘルプ';

  @override
  String get emailConfirmNotReceived => 'サインアップしたのに確認メールが届きませんでしたか？';

  @override
  String get whatSignupUsername => 'サインアップに使用したユーザー名は？';

  @override
  String usernameNotFound(String param) {
    return 'この名前のユーザーは見つかりません：$param';
  }

  @override
  String get usernameCanBeUsedForNewAccount => 'このユーザー名を使って新しいアカウントが作れます';

  @override
  String emailSent(String param) {
    return '$param にメールを送信しました。';
  }

  @override
  String get emailCanTakeSomeTime => '受信まで少しかかるかもしれません。';

  @override
  String get refreshInboxAfterFiveMinutes => '5 分待ってからメール受信箱を更新してください。';

  @override
  String get checkSpamFolder => 'またスパムフォルダに入ってしまう場合もあります。もしそうならスパムではないとマークしてください。';

  @override
  String get emailForSignupHelp => 'どの手段もうまくいかない場合は、次のメールをこちらまで送信してください：';

  @override
  String copyTextToEmail(String param) {
    return '上のテキストをコピー＆ペーストして $param に送信します';
  }

  @override
  String get waitForSignupHelp => 'またこちらから連絡してサインアップ完了までお手伝いします。';

  @override
  String accountConfirmed(String param) {
    return 'ユーザー $param の確認が完了しました。';
  }

  @override
  String accountCanLogin(String param) {
    return 'すぐに $param としてログインできます。';
  }

  @override
  String get accountConfirmationEmailNotNeeded => 'あなたには確認メールは必要ありません。';

  @override
  String accountClosed(String param) {
    return 'アカウント $param は停止されました。';
  }

  @override
  String accountRegisteredWithoutEmail(String param) {
    return 'アカウント $param はメールアドレスなしで登録されています。';
  }

  @override
  String get rank => 'ランク';

  @override
  String rankX(String param) {
    return 'ランク: $param';
  }

  @override
  String get gamesPlayed => '対局数';

  @override
  String get cancel => 'キャンセル';

  @override
  String get whiteTimeOut => '白時間切れ';

  @override
  String get blackTimeOut => '黒時間切れ';

  @override
  String get drawOfferSent => 'ドローの提案を送信しました';

  @override
  String get drawOfferAccepted => 'ドロー提案が承諾されました';

  @override
  String get drawOfferCanceled => 'ドローの提案をキャンセルしました';

  @override
  String get whiteOffersDraw => '白が引き分けを提案しました';

  @override
  String get blackOffersDraw => '黒が引き分けを提案しました';

  @override
  String get whiteDeclinesDraw => '白が引き分けを拒否しました';

  @override
  String get blackDeclinesDraw => '黒が引き分けを拒否しました';

  @override
  String get yourOpponentOffersADraw => '相手がドローを提案しました';

  @override
  String get accept => '承諾';

  @override
  String get decline => '拒否';

  @override
  String get playingRightNow => '対局中';

  @override
  String get eventInProgress => '対局中';

  @override
  String get finished => '終了したトーナメント';

  @override
  String get abortGame => '対局を中止する';

  @override
  String get gameAborted => '対局を中止しました';

  @override
  String get standard => 'スタンダード';

  @override
  String get customPosition => '自由配置局面';

  @override
  String get unlimited => '無制限';

  @override
  String get mode => 'モード';

  @override
  String get casual => '非レート戦';

  @override
  String get rated => 'レート戦';

  @override
  String get casualTournament => '非レート戦';

  @override
  String get ratedTournament => 'レート戦';

  @override
  String get thisGameIsRated => 'この対局はレート戦です';

  @override
  String get rematch => '再対局';

  @override
  String get rematchOfferSent => '再対局の提案があります';

  @override
  String get rematchOfferAccepted => '再対局が承諾されました';

  @override
  String get rematchOfferCanceled => '再対局が取り消されました';

  @override
  String get rematchOfferDeclined => '再対局が拒否されました';

  @override
  String get cancelRematchOffer => '再対局の提案をキャンセル';

  @override
  String get viewRematch => '再戦を観戦する';

  @override
  String get confirmMove => '指し手を確定';

  @override
  String get play => '対局';

  @override
  String get inbox => '受信箱';

  @override
  String get chatRoom => 'チャットルーム';

  @override
  String get loginToChat => 'ログインが必要';

  @override
  String get youHaveBeenTimedOut => 'チャットは一時禁止中';

  @override
  String get spectatorRoom => '観戦席';

  @override
  String get composeMessage => 'メッセージを作成する';

  @override
  String get subject => '件名';

  @override
  String get send => '送信する';

  @override
  String get incrementInSeconds => '１手ごとに増える秒数';

  @override
  String get freeOnlineChess => '無料オンラインチェス';

  @override
  String get exportGames => '対局をエクスポートする';

  @override
  String get ratingRange => 'レーティングの範囲';

  @override
  String get thisAccountViolatedTos => 'このアカウントは Lichess の利用規約に違反しました';

  @override
  String get openingExplorerAndTablebase => 'オープニング探索 & テーブルベース';

  @override
  String get takeback => '待った';

  @override
  String get proposeATakeback => '待ったのお願い';

  @override
  String get takebackPropositionSent => '待ったのお願いを送りました';

  @override
  String get takebackPropositionDeclined => '待ったを拒否';

  @override
  String get takebackPropositionAccepted => '待ったを認める';

  @override
  String get takebackPropositionCanceled => '待ったのお願いをキャンセル';

  @override
  String get yourOpponentProposesATakeback => '対局相手が待ったをしていいか聞いています';

  @override
  String get bookmarkThisGame => 'この対局をブックマークする';

  @override
  String get tournament => 'トーナメント';

  @override
  String get tournaments => 'トーナメント';

  @override
  String get tournamentPoints => 'トーナメントポイント';

  @override
  String get viewTournament => 'トーナメントを見る';

  @override
  String get backToTournament => 'トーナメントに戻る';

  @override
  String get noDrawBeforeSwissLimit => 'スイス式トーナメントでは 30 手指すまでドローは認められません。';

  @override
  String get thematic => '局面指定';

  @override
  String yourPerfRatingIsProvisional(String param) {
    return 'あなたの $param レーティングは仮レートです';
  }

  @override
  String yourPerfRatingIsTooHigh(String param1, String param2) {
    return '$param1 レーティング ($param2) が高すぎます';
  }

  @override
  String yourTopWeeklyPerfRatingIsTooHigh(String param1, String param2) {
    return '$param1 の週間パフォーマンス ($param2) が高すぎます';
  }

  @override
  String yourPerfRatingIsTooLow(String param1, String param2) {
    return '$param1 レーティング ($param2) が低すぎます';
  }

  @override
  String ratedMoreThanInPerf(String param1, String param2) {
    return '$param2 のレーティング $param1 以上';
  }

  @override
  String ratedLessThanInPerf(String param1, String param2) {
    return '$param2 レーティング $param1 以下';
  }

  @override
  String mustBeInTeam(String param) {
    return 'チーム $param のメンバー限定';
  }

  @override
  String youAreNotInTeam(String param) {
    return 'チーム $param に入っていません';
  }

  @override
  String get backToGame => 'ゲームに戻る';

  @override
  String get siteDescription => '無料オンラインチェス。簡素なインターフェースですぐに対局を。登録不要、広告なし、プラグイン不要。AIと、友達と、知らない相手とも対局できます。';

  @override
  String xJoinedTeamY(String param1, String param2) {
    return '$param1 がチーム $param2 に参加';
  }

  @override
  String xCreatedTeamY(String param1, String param2) {
    return '$param1 がチーム $param2 を作成';
  }

  @override
  String get startedStreaming => '配信を開始';

  @override
  String xStartedStreaming(String param) {
    return '$param が配信を開始';
  }

  @override
  String get averageElo => '平均レーティング';

  @override
  String get location => '住所';

  @override
  String get filterGames => '条件で絞り込む';

  @override
  String get reset => 'リセット';

  @override
  String get apply => '適用';

  @override
  String get save => '保存';

  @override
  String get leaderboard => 'ランキング';

  @override
  String get screenshotCurrentPosition => '現局面のスクリーンショット';

  @override
  String get gameAsGIF => 'GIF 形式の棋譜';

  @override
  String get pasteTheFenStringHere => 'ここにFEN形式の局面をペースト';

  @override
  String get pasteThePgnStringHere => 'ここにPGN形式の棋譜をペースト';

  @override
  String get orUploadPgnFile => 'または PGN ファイルをアップロード';

  @override
  String get fromPosition => '特定の局面から';

  @override
  String get continueFromHere => 'この局面から対局';

  @override
  String get toStudy => '研究';

  @override
  String get importGame => '棋譜をインポート';

  @override
  String get importGameExplanation => 'ゲームの PGN を貼りつけると、ブラウザ上でのリプレイ、\nコンピュータ解析、ゲームチャット、共有可能 URL が得られます。';

  @override
  String get importGameCaveat => '変化手順は消えます。残したい場合は研究を経由して PGN をインポートしてください。';

  @override
  String get importGameDataPrivacyWarning => 'この PGN はすべての人に公開されます。非公開の状態で棋譜をインポートするには「研究」機能でどうぞ。';

  @override
  String get thisIsAChessCaptcha => 'これはロボットよけの認証です。';

  @override
  String get clickOnTheBoardToMakeYourMove => '駒を動かしてあなたが人間である事を証明して下さい。';

  @override
  String get captcha_fail => '問題を解いて人間だと証明してください。';

  @override
  String get notACheckmate => 'チェックメイトではありません';

  @override
  String get whiteCheckmatesInOneMove => '白 1 手でチェックメイト';

  @override
  String get blackCheckmatesInOneMove => '黒 1 手でチェックメイト';

  @override
  String get retry => 'もう一度';

  @override
  String get reconnecting => '再接続';

  @override
  String get noNetwork => 'オフライン';

  @override
  String get favoriteOpponents => '対戦の多かった相手';

  @override
  String get follow => 'フォローする';

  @override
  String get following => 'フォローしています';

  @override
  String get unfollow => 'フォローをやめる';

  @override
  String followX(String param) {
    return '$param をフォロー';
  }

  @override
  String unfollowX(String param) {
    return '$param のフォローを外す';
  }

  @override
  String get block => 'ブロックする';

  @override
  String get blocked => 'ブロック済';

  @override
  String get unblock => 'ブロックを外す';

  @override
  String get followsYou => 'あなたをフォローしています';

  @override
  String xStartedFollowingY(String param1, String param2) {
    return '$param1 が $param2 のフォローを開始';
  }

  @override
  String get more => 'さらに表示';

  @override
  String get memberSince => '登録日';

  @override
  String lastSeenActive(String param) {
    return '最後のログイン $param';
  }

  @override
  String get player => 'プレイヤー';

  @override
  String get list => 'リスト';

  @override
  String get graph => 'グラフ';

  @override
  String get required => '必須です。';

  @override
  String get openTournaments => '参加募集中のトーナメント';

  @override
  String get duration => '対局継続時間';

  @override
  String get winner => '勝者';

  @override
  String get standing => '順位';

  @override
  String get createANewTournament => '新しいトーナメントを作る';

  @override
  String get tournamentCalendar => 'トーナメント・カレンダー';

  @override
  String get conditionOfEntry => '参加条件:';

  @override
  String get advancedSettings => '高度な設定';

  @override
  String get safeTournamentName => 'トーナメントの名前は無難なものにしてください。';

  @override
  String get inappropriateNameWarning => '少しでも不適切な名前の場合、あなたのアカウントを停止することがあります。';

  @override
  String get emptyTournamentName => '空白のままにしておくと、自動でランダムな有名選手の名前がつきます。';

  @override
  String get makePrivateTournament => 'トーナメントを「非公開」にすると参加にパスワードが必要になります';

  @override
  String get join => '参加する';

  @override
  String get withdraw => '参加をやめる';

  @override
  String get points => 'ポイント';

  @override
  String get wins => '勝';

  @override
  String get losses => '敗';

  @override
  String get createdBy => 'トーナメント作成者';

  @override
  String get tournamentIsStarting => 'トーナメント開始';

  @override
  String get tournamentPairingsAreNowClosed => 'トーナメントの対局の組み合わせは終了しました。';

  @override
  String standByX(String param) {
    return '$param さん、現在ペアリング中です。用意して！';
  }

  @override
  String get pause => '休む';

  @override
  String get resume => '再開する';

  @override
  String get youArePlaying => '参加中！';

  @override
  String get winRate => '勝率';

  @override
  String get berserkRate => 'バーサーク率';

  @override
  String get performance => 'パフォーマンス';

  @override
  String get tournamentComplete => 'トーナメント終了';

  @override
  String get movesPlayed => '総手数';

  @override
  String get whiteWins => '白勝ち';

  @override
  String get blackWins => '黒勝ち';

  @override
  String get drawRate => 'ドロー率';

  @override
  String get draws => 'ドロー';

  @override
  String nextXTournament(String param) {
    return '次の $param トーナメント:';
  }

  @override
  String get averageOpponent => '対局相手の平均';

  @override
  String get boardEditor => '盤面入力';

  @override
  String get setTheBoard => '盤面を指定';

  @override
  String get popularOpenings => '人気のオープニング';

  @override
  String get endgamePositions => 'エンドゲームの局面';

  @override
  String chess960StartPosition(String param) {
    return 'チェス960 開始局面: $param';
  }

  @override
  String get startPosition => '開始局面';

  @override
  String get clearBoard => '盤面をクリアする';

  @override
  String get loadPosition => '局面を読み込む';

  @override
  String get isPrivate => 'プライベート';

  @override
  String reportXToModerators(String param) {
    return 'モデレーターに$paramを通報する。';
  }

  @override
  String profileCompletion(String param) {
    return 'プロフィール記入率：$param';
  }

  @override
  String xRating(String param) {
    return '$param レーティング';
  }

  @override
  String get ifNoneLeaveEmpty => 'ない場合は空白で';

  @override
  String get profile => 'プロフィール';

  @override
  String get editProfile => 'プロフィールの編集';

  @override
  String get realName => '実名';

  @override
  String get setFlair => 'フレアを設定';

  @override
  String get flair => 'フレア';

  @override
  String get youCanHideFlair => 'サイト全体でフレアを非表示にする設定があります。';

  @override
  String get biography => '自己紹介';

  @override
  String get countryRegion => '国・地域';

  @override
  String get thankYou => 'ありがとう！';

  @override
  String get socialMediaLinks => 'ソーシャルメディアへのリンク';

  @override
  String get oneUrlPerLine => 'URL は 1 行に 1 個です。';

  @override
  String get inlineNotation => '棋譜を行書き';

  @override
  String get makeAStudy => '永久保存や共有には「研究」機能をお使いください。';

  @override
  String get clearSavedMoves => '手をクリアする';

  @override
  String get previouslyOnLichessTV => '過去の Lichess TV 対局';

  @override
  String get onlinePlayers => '接続中のプレイヤー';

  @override
  String get activePlayers => '総対局数上位';

  @override
  String get bewareTheGameIsRatedButHasNoClock => '注意！レイティング対象ですが時間無制限です';

  @override
  String get success => '成功';

  @override
  String get automaticallyProceedToNextGameAfterMoving => '指した後 自動的に次のゲームに切り替える';

  @override
  String get autoSwitch => '自動切り替え';

  @override
  String get puzzles => 'タクティクス問題';

  @override
  String get onlineBots => 'オンラインのボット';

  @override
  String get name => '名称';

  @override
  String get description => '説明';

  @override
  String get descPrivate => '非公開説明文';

  @override
  String get descPrivateHelp => 'チームメンバーだけに見える文章です。設定すると、チームメンバーには一般向けの説明文に代えて表示されます。';

  @override
  String get no => 'いいえ';

  @override
  String get yes => 'はい';

  @override
  String get help => 'ヘルプ：';

  @override
  String get createANewTopic => '新しいトピックを作成';

  @override
  String get topics => 'トピック';

  @override
  String get posts => '投稿数';

  @override
  String get lastPost => '最終投稿';

  @override
  String get views => '閲覧数';

  @override
  String get replies => '返信数';

  @override
  String get replyToThisTopic => 'このトピックに返信';

  @override
  String get reply => '返信';

  @override
  String get message => 'メッセージ';

  @override
  String get createTheTopic => 'トピックを作成';

  @override
  String get reportAUser => 'プレイヤーの報告';

  @override
  String get user => 'プレイヤー';

  @override
  String get reason => '理由';

  @override
  String get whatIsIheMatter => 'どうされましたか？';

  @override
  String get cheat => 'ソフト使用';

  @override
  String get troll => '荒らし';

  @override
  String get other => 'その他';

  @override
  String get reportDescriptionHelp => '問題のゲームへのリンクを貼って、相手ユーザーの問題点を説明してください。ただ「イカサマだ」と言うのではなく、なぜそう思うか理由を書いてください。英語で書くと対応が早くできます。';

  @override
  String get error_provideOneCheatedGameLink => '不正のあった対局 1 局以上へのリンクを添えてください。';

  @override
  String by(String param) {
    return '$param によって';
  }

  @override
  String importedByX(String param) {
    return '$param がインポート';
  }

  @override
  String get thisTopicIsNowClosed => 'このトピックは閉鎖されました。';

  @override
  String get blog => 'ブログ';

  @override
  String get notes => 'メモ';

  @override
  String get typePrivateNotesHere => '自分用のメモ欄';

  @override
  String get writeAPrivateNoteAboutThisUser => 'このユーザーについて自分用のメモを書く';

  @override
  String get noNoteYet => 'まだメモはありません';

  @override
  String get invalidUsernameOrPassword => '無効なユーザー名 または パスワード';

  @override
  String get incorrectPassword => 'パスワードが違います';

  @override
  String get invalidAuthenticationCode => '無効な認証コード';

  @override
  String get emailMeALink => 'リンクをメールで送る';

  @override
  String get currentPassword => '現在のパスワード';

  @override
  String get newPassword => '新しいパスワード';

  @override
  String get newPasswordAgain => '新しいパスワード（確認）';

  @override
  String get newPasswordsDontMatch => '新しいパスワードが一致しません';

  @override
  String get newPasswordStrength => 'パスワードの強度';

  @override
  String get clockInitialTime => '持時間';

  @override
  String get clockIncrement => '追加時間';

  @override
  String get privacy => 'プライバシー（英文）';

  @override
  String get privacyPolicy => 'プライバシー・ポリシー';

  @override
  String get letOtherPlayersFollowYou => '他人からのフォローを可能にする';

  @override
  String get letOtherPlayersChallengeYou => '他人からの挑戦を可能にする';

  @override
  String get letOtherPlayersInviteYouToStudy => '研究について他の人からの招待を認める';

  @override
  String get sound => '音声';

  @override
  String get none => '無効';

  @override
  String get fast => '速い';

  @override
  String get normal => '普通';

  @override
  String get slow => '遅い';

  @override
  String get insideTheBoard => '盤の内';

  @override
  String get outsideTheBoard => '盤の外';

  @override
  String get allSquaresOfTheBoard => 'すべてのマスに';

  @override
  String get onSlowGames => '長時間の対局のみ';

  @override
  String get always => '常に有効';

  @override
  String get never => '無効';

  @override
  String xCompetesInY(String param1, String param2) {
    return '$param1 が $param2 で対局しました。';
  }

  @override
  String get victory => '勝ち';

  @override
  String get defeat => '負け';

  @override
  String victoryVsYInZ(String param1, String param2, String param3) {
    return '$param1 対 $param2、$param3';
  }

  @override
  String defeatVsYInZ(String param1, String param2, String param3) {
    return '$param1 対 $param2、$param3 で';
  }

  @override
  String drawVsYInZ(String param1, String param2, String param3) {
    return '$param1 対 $param2、$param3 で';
  }

  @override
  String get timeline => 'タイムライン';

  @override
  String get starting => '開始時刻：';

  @override
  String get allInformationIsPublicAndOptional => '情報の記入はすべて任意で、すべて公開されます。';

  @override
  String get biographyDescription => '自己紹介（チェスの好きな点、お気に入りの戦法、ゲーム、選手など）';

  @override
  String get listBlockedPlayers => 'ブロックしたプレイヤーリスト';

  @override
  String get human => '人間';

  @override
  String get computer => 'コンピューター';

  @override
  String get side => '先手後手';

  @override
  String get clock => '対局時計';

  @override
  String get opponent => '対戦相手';

  @override
  String get learnMenu => '学ぶ';

  @override
  String get studyMenu => '研究';

  @override
  String get practice => '練習問題';

  @override
  String get community => 'コミュニティ';

  @override
  String get tools => 'ツール';

  @override
  String get increment => '追加時間';

  @override
  String get error_unknown => '無効な値';

  @override
  String get error_required => 'この欄は入力必須です';

  @override
  String get error_email => 'このメールアドレスは無効です';

  @override
  String get error_email_acceptable => 'このメールアドレスは使用できません。確認してもう一度どうぞ。';

  @override
  String get error_email_unique => 'メールアドレスが無効かすでに使われています';

  @override
  String get error_email_different => 'すでにあなたのメールアドレスになっています';

  @override
  String error_minLength(String param) {
    return '最小の長さは $param です';
  }

  @override
  String error_maxLength(String param) {
    return '最大の長さは $param です';
  }

  @override
  String error_min(String param) {
    return '$param 以上にしてください';
  }

  @override
  String error_max(String param) {
    return '$param 以下にしてください';
  }

  @override
  String ifRatingIsPlusMinusX(String param) {
    return 'レーティング差が±$param以内のとき';
  }

  @override
  String get ifRegistered => '登録ユーザーだけ';

  @override
  String get onlyExistingConversations => 'すでにある会話のみ';

  @override
  String get onlyFriends => '友達のみ';

  @override
  String get menu => 'メニュー';

  @override
  String get castling => 'キャスリング';

  @override
  String get whiteCastlingKingside => '白　O-O';

  @override
  String get blackCastlingKingside => '黒　O-O';

  @override
  String tpTimeSpentPlaying(String param) {
    return 'プレイ時間:$param';
  }

  @override
  String get watchGames => 'ゲームを見る';

  @override
  String tpTimeSpentOnTV(String param) {
    return 'TVに映った時間:$param';
  }

  @override
  String get watch => '見る';

  @override
  String get videoLibrary => 'チェスの動画集';

  @override
  String get streamersMenu => '配信者';

  @override
  String get mobileApp => 'モバイルアプリ';

  @override
  String get webmasters => 'ウェブサイト運営者の方へ';

  @override
  String get about => 'Lichess 概要';

  @override
  String aboutX(String param) {
    return '$param について';
  }

  @override
  String xIsAFreeYLibreOpenSourceChessServer(String param1, String param2) {
    return '$param1 は無料 ($param2)・自由・広告なし・オープンソースのチェス サーバです。';
  }

  @override
  String get really => '本当に';

  @override
  String get contribute => '力を貸す';

  @override
  String get termsOfService => '利用規約（英文）';

  @override
  String get sourceCode => 'ソースコード';

  @override
  String get simultaneousExhibitions => '同時対局';

  @override
  String get host => 'ホスト';

  @override
  String hostColorX(String param) {
    return 'ホストの色: $param';
  }

  @override
  String get yourPendingSimuls => '保留中の同時対局';

  @override
  String get createdSimuls => '新たな同時対局';

  @override
  String get hostANewSimul => '新たな同時対局を作る';

  @override
  String get signUpToHostOrJoinASimul => '同時対局の主催・参加にはサインアップを';

  @override
  String get noSimulFound => '同時対局が見つかりません';

  @override
  String get noSimulExplanation => 'この同時対局は存在しません';

  @override
  String get returnToSimulHomepage => '同時対局トップに戻る';

  @override
  String get aboutSimul => '同時対局では、1 人が多数の相手と同時に対局します。';

  @override
  String get aboutSimulImage => 'この時フィッシャーは 50 人と対局して 47 勝 2 分 1 敗でした。';

  @override
  String get aboutSimulRealLife => 'コンセプトは現実の同時対局と同じです。現実世界では 1 人がテーブルを回って 1 手ずつ指していきます。';

  @override
  String get aboutSimulRules => '同時対局が始まると、全員がホスト（白番）と対戦します。同時対局はすべての対局が終わった時に終了します。';

  @override
  String get aboutSimulSettings => '同時対局は非レート戦です。再対局、待った、持時間追加はできません。';

  @override
  String get create => '作成する';

  @override
  String get whenCreateSimul => '同時対局を作成すると、同時に複数の相手と対戦できます。';

  @override
  String get simulVariantsHint => '複数のバリアントを選ぶと、どのバリアントにするか相手が選べます。';

  @override
  String get simulClockHint => 'フィッシャーモードの設定。相手が多いほど追加時間は長めに。';

  @override
  String get simulAddExtraTime => '同時対局の手間を考え、自分に持時間をさらに追加できます。';

  @override
  String get simulHostExtraTime => 'ホスト延長時間';

  @override
  String get simulAddExtraTimePerPlayer => '同時対局の参加者 1 人につき何分の形で自分の持時間を増やせます。';

  @override
  String get simulHostExtraTimePerPlayer => 'ホスト延長時間（人数比例）';

  @override
  String get lichessTournaments => 'Lichess トーナメント';

  @override
  String get tournamentFAQ => 'アリーナ・トーナメントFAQ';

  @override
  String get timeBeforeTournamentStarts => '開始までの時間';

  @override
  String get averageCentipawnLoss => '平均センチポーン差';

  @override
  String get accuracy => '正確度';

  @override
  String get keyboardShortcuts => 'ショートカットキー';

  @override
  String get keyMoveBackwardOrForward => '手を戻す/進める';

  @override
  String get keyGoToStartOrEnd => '最初/最後に戻る';

  @override
  String get keyCycleSelectedVariation => '選択した手順を切り替え';

  @override
  String get keyShowOrHideComments => 'コメントを表示する/隠す';

  @override
  String get keyEnterOrExitVariation => '変化に入る/出る';

  @override
  String get keyRequestComputerAnalysis => 'コンピュータ解析の要請、自分の悪手に学ぶ';

  @override
  String get keyNextLearnFromYourMistakes => '次（自分の悪手に学ぶ）';

  @override
  String get keyNextBlunder => '次の大悪手';

  @override
  String get keyNextMistake => '次の悪手';

  @override
  String get keyNextInaccuracy => '次のやや悪手';

  @override
  String get keyPreviousBranch => '前の変化手順';

  @override
  String get keyNextBranch => '次の変化手順';

  @override
  String get toggleVariationArrows => '変化手順の矢印を切り替え';

  @override
  String get cyclePreviousOrNextVariation => 'ひとつ前/次の手順を切り替え';

  @override
  String get toggleGlyphAnnotations => '記号での注釈を切り替え';

  @override
  String get togglePositionAnnotations => 'Toggle position annotations';

  @override
  String get variationArrowsInfo => '変化手順の矢印があれば棋譜記録を使わずにナビゲーションできます。';

  @override
  String get playSelectedMove => '選択した手をプレイ';

  @override
  String get newTournament => '新しいトーナメント';

  @override
  String get tournamentHomeTitle => 'さまざまな持時間とルールのチェストーナメント';

  @override
  String get tournamentHomeDescription => '早指しのチェストーナメントに参加しよう！　定時のトーナメントに参加するほか、自分で作ることもできます。ブレット、ブリッツ、クラシック、チェス960、キングオブザヒル、3チェックなどチェスの無限の楽しみを。';

  @override
  String get tournamentNotFound => 'トーナメントが見つかりません';

  @override
  String get tournamentDoesNotExist => 'このトーナメントは存在しません';

  @override
  String get tournamentMayHaveBeenCanceled => '開始前に全員が参加をやめてキャンセルされた可能性があります。';

  @override
  String get returnToTournamentsHomepage => 'トーナメントトップに戻る';

  @override
  String weeklyPerfTypeRatingDistribution(String param) {
    return '今週の $param レーティング分布';
  }

  @override
  String yourPerfTypeRatingIsRating(String param1, String param2) {
    return 'あなたの $param1 レーティングは $param2 です。';
  }

  @override
  String youAreBetterThanPercentOfPerfTypePlayers(String param1, String param2) {
    return 'あなたは全体の $param1 の$param2参加者より上です。';
  }

  @override
  String userIsBetterThanPercentOfPerfTypePlayers(String param1, String param2, String param3) {
    return '$param1 は全体の $param2 の $param3 参加者より上です。';
  }

  @override
  String betterThanPercentPlayers(String param1, String param2) {
    return '全体の $param1 の $param2 参加者より上';
  }

  @override
  String youDoNotHaveAnEstablishedPerfTypeRating(String param) {
    return 'まだ $param レーティングが確定していません。';
  }

  @override
  String get yourRating => 'あなたの位置';

  @override
  String get cumulative => '累積百分率';

  @override
  String get glicko2Rating => 'グリコ-2 レーティング';

  @override
  String get checkYourEmail => 'メールを確認してください';

  @override
  String get weHaveSentYouAnEmailClickTheLink => 'メールを送信しました。リンクをクリックしてアカウントの作成を完了してください。';

  @override
  String get ifYouDoNotSeeTheEmailCheckOtherPlaces => 'メールが見つからない場合は、他の場所（スパムフォルダなど）を確認してください。';

  @override
  String weHaveSentYouAnEmailTo(String param) {
    return '$paramにメールを送信しました。リンクをクリックしてパスワードの変更を完了してください。';
  }

  @override
  String byRegisteringYouAgreeToBeBoundByOur(String param) {
    return '登録するとあなたは $param に従うと同意したことになります。';
  }

  @override
  String readAboutOur(String param) {
    return 'Lichess の $param 文書です。';
  }

  @override
  String get networkLagBetweenYouAndLichess => 'あなたと Lichess の間のネットワークラグ';

  @override
  String get timeToProcessAMoveOnLichessServer => 'Lichess サーバが手を処理する時間';

  @override
  String get downloadAnnotated => '解説つきダウンロード';

  @override
  String get downloadRaw => '棋譜のみダウンロード';

  @override
  String get downloadImported => 'インポート分のダウンロード';

  @override
  String get crosstable => '成績表';

  @override
  String get youCanAlsoScrollOverTheBoardToMoveInTheGame => '盤上で駒を動かすことでも手を入力できます。';

  @override
  String get scrollOverComputerVariationsToPreviewThem => '手順の上にカーソルを移動させるとプレビューが表示されます。';

  @override
  String get analysisShapesHowTo => 'Shift + クリックや右クリックで盤上に丸や矢印が描けます。';

  @override
  String get letOtherPlayersMessageYou => '他のプレイヤーからのメッセージを受け付ける';

  @override
  String get receiveForumNotifications => 'フォーラムで自分の名前が出たときに通知を受け取る';

  @override
  String get shareYourInsightsData => 'Insights のデータを共有する';

  @override
  String get withNobody => '誰にも見せない';

  @override
  String get withFriends => '友達にだけ';

  @override
  String get withEverybody => '誰にでも';

  @override
  String get kidMode => 'キッズモード';

  @override
  String get kidModeIsEnabled => 'キッズモードが有効です。';

  @override
  String get kidModeExplanation => 'これは安全対策です。「キッズモード」ではサイト上の会話がすべて無効になります。子供や生徒のアカウントでこのモードを有効にしておけば、彼らを他のユーザーから守ることができます。';

  @override
  String inKidModeTheLichessLogoGetsIconX(String param) {
    return 'キッズモードでは Lichess のロゴに $param のアイコンが付き、安全であることを示します。';
  }

  @override
  String get askYourChessTeacherAboutLiftingKidMode => 'あなたのアカウントは管理されています。キッズモードの停止は講師に依頼してください。';

  @override
  String get enableKidMode => 'キッズモードを有効化';

  @override
  String get disableKidMode => 'キッズモードを無効化';

  @override
  String get security => 'セキュリティ';

  @override
  String get sessions => 'セッション';

  @override
  String get revokeAllSessions => 'すべてのセッションを取り消す';

  @override
  String get playChessEverywhere => 'どこでもチェスを対局';

  @override
  String get asFreeAsLichess => 'Lichess は常に無料';

  @override
  String get builtForTheLoveOfChessNotMoney => '金ではなくチェス愛のために作られたアプリ';

  @override
  String get everybodyGetsAllFeaturesForFree => '誰でもすべての機能が無料です';

  @override
  String get zeroAdvertisement => '広告いっさいなし';

  @override
  String get fullFeatured => '幅広い機能';

  @override
  String get phoneAndTablet => '携帯やタブレットで';

  @override
  String get bulletBlitzClassical => 'ブレット、ブリッツ、クラシカル';

  @override
  String get correspondenceChess => '通信戦';

  @override
  String get onlineAndOfflinePlay => 'オンラインでもオフラインでも';

  @override
  String get viewTheSolution => '解答を見る';

  @override
  String get followAndChallengeFriends => '友達をフォローして対局しよう';

  @override
  String get gameAnalysis => '棋譜解析';

  @override
  String xHostsY(String param1, String param2) {
    return '$param1が $param2 を作成しました';
  }

  @override
  String xJoinsY(String param1, String param2) {
    return '$param1が $param2 に参加';
  }

  @override
  String xLikesY(String param1, String param2) {
    return '$param1 が $param2 に「いいね」しました。';
  }

  @override
  String get quickPairing => '自動ペアリング';

  @override
  String get lobby => 'ロビー';

  @override
  String get anonymous => '匿名';

  @override
  String yourScore(String param) {
    return '通算成績：$param';
  }

  @override
  String get language => '言語';

  @override
  String get background => '背景';

  @override
  String get light => '明るい';

  @override
  String get dark => '暗い';

  @override
  String get transparent => '透明';

  @override
  String get deviceTheme => 'デバイスの設定に従う';

  @override
  String get backgroundImageUrl => '背景画像URL:';

  @override
  String get board => '盤のデザイン';

  @override
  String get size => 'サイズ';

  @override
  String get opacity => '透明度';

  @override
  String get brightness => '明るさ';

  @override
  String get hue => '色';

  @override
  String get boardReset => '色をデフォルトに戻す';

  @override
  String get pieceSet => '駒のデザイン';

  @override
  String get embedInYourWebsite => '自分のウェブサイトに埋め込む';

  @override
  String get usernameAlreadyUsed => 'このユーザー名は既に使用されています。別の名前にしてください。';

  @override
  String get usernamePrefixInvalid => 'ユーザー名の最初は英字でなくてはなりません。';

  @override
  String get usernameSuffixInvalid => 'ユーザー名の最後は英字か数字でなくてはなりません。';

  @override
  String get usernameCharsInvalid => 'ユーザー名に使えるのは英字、数字、アンダースコア、ハイフンだけです。';

  @override
  String get usernameUnacceptable => 'このユーザー名は認められません。';

  @override
  String get playChessInStyle => 'グッズ購入';

  @override
  String get chessBasics => 'チェスの基本';

  @override
  String get coaches => 'コーチ';

  @override
  String get invalidPgn => '無効な PGN';

  @override
  String get invalidFen => '無効な FEN';

  @override
  String get custom => '自由設定';

  @override
  String get notifications => '通知';

  @override
  String notificationsX(String param1) {
    return '通知：$param1';
  }

  @override
  String perfRatingX(String param) {
    return 'レーティング: $param';
  }

  @override
  String get practiceWithComputer => 'コンピューターと練習する';

  @override
  String anotherWasX(String param) {
    return '別の手は $param';
  }

  @override
  String bestWasX(String param) {
    return '最善手は $param';
  }

  @override
  String get youBrowsedAway => 'ページを離れました';

  @override
  String get resumePractice => '練習を続ける';

  @override
  String get drawByFiftyMoves => '50 手ルールによりドローになりました。';

  @override
  String get theGameIsADraw => 'ドロー（引き分け）です。';

  @override
  String get computerThinking => 'コンピューター思考中…';

  @override
  String get seeBestMove => '最善手を見る';

  @override
  String get hideBestMove => '最善手をかくす';

  @override
  String get getAHint => 'ヒントを見る';

  @override
  String get evaluatingYourMove => 'あなたの手を評価中…';

  @override
  String get whiteWinsGame => '白勝ち';

  @override
  String get blackWinsGame => '黒勝ち';

  @override
  String get learnFromYourMistakes => '自分の悪手に学ぼう';

  @override
  String get learnFromThisMistake => 'この悪手に学ぶ';

  @override
  String get skipThisMove => 'この手を飛ばす';

  @override
  String get next => '次';

  @override
  String xWasPlayed(String param) {
    return '指されたのは $param';
  }

  @override
  String get findBetterMoveForWhite => '白のもっといい手を見つけてください';

  @override
  String get findBetterMoveForBlack => '黒のもっといい手を見つけてください';

  @override
  String get resumeLearning => '学習を続ける';

  @override
  String get youCanDoBetter => 'もっといい手があります';

  @override
  String get tryAnotherMoveForWhite => '白の別の手を考えてください';

  @override
  String get tryAnotherMoveForBlack => '黒の別の手を考えてください';

  @override
  String get solution => '答え';

  @override
  String get waitingForAnalysis => '解析を待っています';

  @override
  String get noMistakesFoundForWhite => '白に悪手はありませんでした';

  @override
  String get noMistakesFoundForBlack => '黒に悪手はありませんでした';

  @override
  String get doneReviewingWhiteMistakes => '白の悪手チェックが終了';

  @override
  String get doneReviewingBlackMistakes => '黒の悪手チェックが終了';

  @override
  String get doItAgain => 'もう一度どうぞ';

  @override
  String get reviewWhiteMistakes => '白の悪手をチェックする';

  @override
  String get reviewBlackMistakes => '黒の悪手をチェックする';

  @override
  String get advantage => '優位';

  @override
  String get opening => '序盤';

  @override
  String get middlegame => '中盤';

  @override
  String get endgame => '終盤';

  @override
  String get conditionalPremoves => 'コンディショナルムーブ';

  @override
  String get addCurrentVariation => '現在の変化を追加する';

  @override
  String get playVariationToCreateConditionalPremoves => '駒を動かしてコンディショナルムーブを設定します';

  @override
  String get noConditionalPremoves => 'コンディショナルムーブなし';

  @override
  String playX(String param) {
    return '指し手は $param';
  }

  @override
  String get showUnreadLichessMessage => 'Lichess からプライベートメッセージが来ました。';

  @override
  String get clickHereToReadIt => 'ここをクリックして読む';

  @override
  String get sorry => '残念です :(';

  @override
  String get weHadToTimeYouOutForAWhile => 'しばらく対局を禁止します。';

  @override
  String get why => 'どうして？';

  @override
  String get pleasantChessExperience => 'Lichess ではすべての人に楽しいチェス体験を提供しています。';

  @override
  String get goodPractice => 'そのためには、すべての人にマナーを守っていただく必要があります。';

  @override
  String get potentialProblem => '問題があった場合、このメッセージ画面が表示されます。';

  @override
  String get howToAvoidThis => 'どうすればいいの？';

  @override
  String get playEveryGame => '始めたゲームを中断しない';

  @override
  String get tryToWin => 'すべてのゲームで勝ち（またはドロー）を目指す';

  @override
  String get resignLostGames => '敗勢なら投了する（時間切れまで放置しない）';

  @override
  String get temporaryInconvenience => 'しばらくご不便をおかけしますが';

  @override
  String get wishYouGreatGames => '今後も Lichess ですばらしいゲームを楽しまれるよう願っています。';

  @override
  String get thankYouForReading => '熟読ありがとう！';

  @override
  String get lifetimeScore => '通算成績';

  @override
  String get currentMatchScore => '現在のスコア';

  @override
  String get agreementAssistance => '私はいかなる場合も対局中に外部の力を借りないことに同意します（コンピュータ、書籍、データベース、別の人物）。';

  @override
  String get agreementNice => '私は常に他のプレイヤーへの礼儀を守ることに同意します。';

  @override
  String agreementMultipleAccounts(String param) {
    return '私は複数のアカウントを作成しないことに同意します（$param に記載の理由による場合を除く）。';
  }

  @override
  String get agreementPolicy => '私は Lichess のすべてのポリシーに従うことに同意します。';

  @override
  String get searchOrStartNewDiscussion => '検索または新しいトピックを始める';

  @override
  String get edit => '編集';

  @override
  String get bullet => 'ブレット';

  @override
  String get blitz => 'ブリッツ';

  @override
  String get rapid => 'ラピッド';

  @override
  String get classical => 'クラシカル';

  @override
  String get ultraBulletDesc => '極早指し戦：30 秒未満';

  @override
  String get bulletDesc => '超早指し戦：3 分未満';

  @override
  String get blitzDesc => '早指し戦：3 分から 8 分';

  @override
  String get rapidDesc => 'ラピッド：8 分から 25 分';

  @override
  String get classicalDesc => 'クラシカル：25 分以上';

  @override
  String get correspondenceDesc => '通信戦：1 手につき 1 日から数日';

  @override
  String get puzzleDesc => 'タクティクス問題';

  @override
  String get important => '重要';

  @override
  String yourQuestionMayHaveBeenAnswered(String param1) {
    return 'ご質問の答えはすでに $param1 にあるかもしれません';
  }

  @override
  String get inTheFAQ => 'FAQ 内';

  @override
  String toReportSomeoneForCheatingOrBadBehavior(String param1) {
    return '不正行為や不適切な行動の通報には $param1';
  }

  @override
  String get useTheReportForm => '通報フォームをお使いください';

  @override
  String toRequestSupport(String param1) {
    return 'サポートを求める時には$param1';
  }

  @override
  String get tryTheContactPage => '「連絡先」のページをご覧ください';

  @override
  String makeSureToRead(String param1) {
    return '$param1 を必ずお読みください';
  }

  @override
  String get theForumEtiquette => 'フォーラムでのマナー';

  @override
  String get thisTopicIsArchived => 'このトピックはすでにアーカイブ化されコメントの追加はできません。';

  @override
  String joinTheTeamXToPost(String param1) {
    return '投稿するには $param1 に加入してください';
  }

  @override
  String teamNamedX(String param1) {
    return '$param1 チーム';
  }

  @override
  String get youCannotPostYetPlaySomeGames => '何局か指し終えるまで投稿はできません。';

  @override
  String get subscribe => '投稿をフォロー';

  @override
  String get unsubscribe => '投稿のフォローをはずす';

  @override
  String mentionedYouInX(String param1) {
    return '「$param1」であなたの名前が出ました。';
  }

  @override
  String xMentionedYouInY(String param1, String param2) {
    return '$param1さんが「$param2」であなたの名前を出しました。';
  }

  @override
  String invitedYouToX(String param1) {
    return '「$param1」 への招待が来ました。';
  }

  @override
  String xInvitedYouToY(String param1, String param2) {
    return '$param1 から 「$param2」 への招待が来ました。';
  }

  @override
  String get youAreNowPartOfTeam => 'チームの一員になりました。';

  @override
  String youHaveJoinedTeamX(String param1) {
    return '「$param1」に参加しました。';
  }

  @override
  String get someoneYouReportedWasBanned => 'あなたが通報した人が追放されました';

  @override
  String get congratsYouWon => 'おめでとう、あなたの勝ちです！';

  @override
  String gameVsX(String param1) {
    return '$param1 との対局';
  }

  @override
  String resVsX(String param1, String param2) {
    return '$param1 対 $param2';
  }

  @override
  String get lostAgainstTOSViolator => 'あなたは利用規約違反の人に負けていました';

  @override
  String refundXpointsTimeControlY(String param1, String param2) {
    return 'レーティングの復活：$param1 $param2 点。';
  }

  @override
  String get timeAlmostUp => '残り時間わずか！';

  @override
  String get clickToRevealEmailAddress => '[ クリックでメールアドレスを表示 ]';

  @override
  String get download => 'ダウンロード';

  @override
  String get coachManager => 'コーチ用設定';

  @override
  String get streamerManager => '配信者用設定';

  @override
  String get cancelTournament => 'トーナメントをキャンセル';

  @override
  String get tournDescription => 'トーナメントの説明';

  @override
  String get tournDescriptionHelp => '参加者に特に説明しておきたいことはありますか？　短く書いてください。リンクも入れられます：[name](https://url)';

  @override
  String get ratedFormHelp => 'レート戦です\nプレイヤーのレーティングが動きます';

  @override
  String get onlyMembersOfTeam => 'チームメンバーのみ';

  @override
  String get noRestriction => '制限なし';

  @override
  String get minimumRatedGames => '必要対局数（レート戦）';

  @override
  String get minimumRating => 'レーティング下限';

  @override
  String get maximumWeeklyRating => 'レーティング上限（週内）';

  @override
  String positionInputHelp(String param) {
    return '有効な FEN をペーストすると全対局がその局面から始まります。\n通常ルールのチェスだけで、バリアントには使えません。\n$param を使えば FEN が作れます。それをここにペーストするだけです。\n通常の開始局面から始める場合はここは空白のままです。';
  }

  @override
  String get cancelSimul => '同時対局をキャンセル';

  @override
  String get simulHostcolor => 'ホスト側の手番';

  @override
  String get estimatedStart => '開始予定時刻';

  @override
  String simulFeatured(String param) {
    return '$param に表示';
  }

  @override
  String simulFeaturedHelp(String param) {
    return '$param 上の全員に表示します。非公開の同時対局では無効にしてください。';
  }

  @override
  String get simulDescription => '同時対局の説明';

  @override
  String get simulDescriptionHelp => '参加者に伝えたいことがあればどうぞ';

  @override
  String markdownAvailable(String param) {
    return '高度な修飾方法として $param も使えます。';
  }

  @override
  String get embedsAvailable => '棋譜の URL、研究の章の URL をペーストすると埋め込みできます。';

  @override
  String get inYourLocalTimezone => '自分のタイムゾーンで';

  @override
  String get tournChat => 'トーナメント チャット';

  @override
  String get noChat => 'チャットなし';

  @override
  String get onlyTeamLeaders => 'チームリーダー限定';

  @override
  String get onlyTeamMembers => 'チームメンバー限定';

  @override
  String get navigateMoveTree => '分岐ツリー内の移動';

  @override
  String get mouseTricks => 'マウスでの操作';

  @override
  String get toggleLocalAnalysis => 'ローカルコンピュータ解析の切り替え';

  @override
  String get toggleAllAnalysis => '全コンピュータ解析の切り替え';

  @override
  String get playComputerMove => 'コンピュータの最善手をプレイ';

  @override
  String get analysisOptions => '解析のオプション';

  @override
  String get focusChat => 'チャットにフォーカス';

  @override
  String get showHelpDialog => 'このヘルプダイアログを表示';

  @override
  String get reopenYourAccount => 'アカウントを再開する';

  @override
  String get closedAccountChangedMind => 'アカウントを閉鎖して、後で気が変わった場合、一度だけアカウントを再開することができます。';

  @override
  String get onlyWorksOnce => '再開は一回限りです。';

  @override
  String get cantDoThisTwice => '二度目にアカウントを閉鎖した場合、アカウントを復元する方法はありません。';

  @override
  String get emailAssociatedToaccount => 'アカウントに登録されたメールアドレス';

  @override
  String get sentEmailWithLink => 'あなたにリンクを含むメールを送信しました。';

  @override
  String get tournamentEntryCode => 'トーナメント参加コード';

  @override
  String get hangOn => '待って！';

  @override
  String gameInProgress(String param) {
    return '$param との対局が進行中です。';
  }

  @override
  String get abortTheGame => '対局を中止する';

  @override
  String get resignTheGame => '投了する';

  @override
  String get youCantStartNewGame => 'この対局が終わるまで、別の対局は開始できません。';

  @override
  String get since => '開始';

  @override
  String get until => '終了';

  @override
  String get lichessDbExplanation => 'Lichess 全プレイヤーのレート戦が対象';

  @override
  String get switchSides => '色変更';

  @override
  String get closingAccountWithdrawAppeal => 'アカウントを閉鎖すると異議申立ても取り下げになります';

  @override
  String get ourEventTips => 'チェスイベント開催のアドバイス';

  @override
  String get instructions => '使用法';

  @override
  String get showMeEverything => 'すべてを表示';

  @override
  String get lichessPatronInfo => 'Lichess は非営利組織であり、完全に無料/自由なオープンソースソフトウェアです。\n運営費、開発、コンテンツを支えているのはすべてユーザーの寄付です。';

  @override
  String get nothingToSeeHere => '今は何もありません。';

  @override
  String opponentLeftCounter(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '相手がいなくなりました。後 $count 秒で勝ちにできます。',
    );
    return '$_temp0';
  }

  @override
  String mateInXHalfMoves(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count プライでメイト',
    );
    return '$_temp0';
  }

  @override
  String nbBlunders(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 大悪手',
    );
    return '$_temp0';
  }

  @override
  String nbMistakes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 悪手',
    );
    return '$_temp0';
  }

  @override
  String nbInaccuracies(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 緩手',
    );
    return '$_temp0';
  }

  @override
  String nbPlayers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 人',
    );
    return '$_temp0';
  }

  @override
  String nbGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 局',
    );
    return '$_temp0';
  }

  @override
  String ratingXOverYGames(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count レーティング（$param2 局で）',
    );
    return '$_temp0';
  }

  @override
  String nbBookmarks(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count個の ブックマーク',
    );
    return '$_temp0';
  }

  @override
  String nbDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count日',
    );
    return '$_temp0';
  }

  @override
  String nbHours(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count時間',
    );
    return '$_temp0';
  }

  @override
  String nbMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 分',
    );
    return '$_temp0';
  }

  @override
  String rankIsUpdatedEveryNbMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '順位は $count 分ごとに更新',
    );
    return '$_temp0';
  }

  @override
  String nbPuzzles(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count タクティクス問題',
    );
    return '$_temp0';
  }

  @override
  String nbGamesWithYou(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'あなたと $count 局対局',
    );
    return '$_temp0';
  }

  @override
  String nbRated(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 局レート戦',
    );
    return '$_temp0';
  }

  @override
  String nbWins(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 勝',
    );
    return '$_temp0';
  }

  @override
  String nbLosses(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 敗',
    );
    return '$_temp0';
  }

  @override
  String nbDraws(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 分',
    );
    return '$_temp0';
  }

  @override
  String nbPlaying(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 局進行中',
    );
    return '$_temp0';
  }

  @override
  String giveNbSeconds(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count秒を与える',
    );
    return '$_temp0';
  }

  @override
  String nbTournamentPoints(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count トーナメントポイント',
    );
    return '$_temp0';
  }

  @override
  String nbStudies(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 研究',
    );
    return '$_temp0';
  }

  @override
  String nbSimuls(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 同時対局',
    );
    return '$_temp0';
  }

  @override
  String moreThanNbRatedGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'レート戦 $count 局以上',
    );
    return '$_temp0';
  }

  @override
  String moreThanNbPerfRatedGames(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$param2 レート戦 $count 局以上',
    );
    return '$_temp0';
  }

  @override
  String needNbMorePerfGames(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$param2 のレート戦があと $count 局必要です',
    );
    return '$_temp0';
  }

  @override
  String needNbMoreGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'レート戦があと $count 局必要です',
    );
    return '$_temp0';
  }

  @override
  String nbImportedGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 局をインポート',
    );
    return '$_temp0';
  }

  @override
  String nbFriendsOnline(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 人の友達が接続中',
    );
    return '$_temp0';
  }

  @override
  String nbFollowers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count フォロワー',
    );
    return '$_temp0';
  }

  @override
  String nbFollowing(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 人をフォロー',
    );
    return '$_temp0';
  }

  @override
  String lessThanNbMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 分未満',
    );
    return '$_temp0';
  }

  @override
  String nbGamesInPlay(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 局対局中',
    );
    return '$_temp0';
  }

  @override
  String maximumNbCharacters(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '最大: $count 文字',
    );
    return '$_temp0';
  }

  @override
  String blocks(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 名をブロック',
    );
    return '$_temp0';
  }

  @override
  String nbForumPosts(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count フォーラム投稿',
    );
    return '$_temp0';
  }

  @override
  String nbPerfTypePlayersThisWeek(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'この 1 週間の参加者 $count 人（$param2）。',
    );
    return '$_temp0';
  }

  @override
  String availableInNbLanguages(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count言語で利用可能',
    );
    return '$_temp0';
  }

  @override
  String nbSecondsToPlayTheFirstMove(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'あと $count 秒以内に初手を指してください',
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
      other: '$count 種のコンディショナルムーブを設定',
    );
    return '$_temp0';
  }

  @override
  String get stormMoveToStart => '一手指すとスタート';

  @override
  String get stormYouPlayTheWhitePiecesInAllPuzzles => 'あなたの駒はつねに白です';

  @override
  String get stormYouPlayTheBlackPiecesInAllPuzzles => 'あなたの駒はつねに黒です';

  @override
  String get stormPuzzlesSolved => '正解数';

  @override
  String get stormNewDailyHighscore => '今日のハイスコア更新！';

  @override
  String get stormNewWeeklyHighscore => '今週のハイスコア更新！';

  @override
  String get stormNewMonthlyHighscore => '今月のハイスコア更新！';

  @override
  String get stormNewAllTimeHighscore => '歴代のハイスコア更新！';

  @override
  String stormPreviousHighscoreWasX(String param) {
    return '以前のハイスコアは $param';
  }

  @override
  String get stormPlayAgain => 'もう一度プレイ';

  @override
  String stormHighscoreX(String param) {
    return 'ハイスコア：$param';
  }

  @override
  String get stormScore => 'スコア';

  @override
  String get stormMoves => '総手数';

  @override
  String get stormAccuracy => '正解率';

  @override
  String get stormCombo => '連続正解';

  @override
  String get stormTime => '経過時間';

  @override
  String get stormTimePerMove => '１手あたり時間';

  @override
  String get stormHighestSolved => '正解最高レート';

  @override
  String get stormPuzzlesPlayed => 'プレイした問題';

  @override
  String get stormNewRun => '新たなストーム（スペースキー）';

  @override
  String get stormEndRun => 'ストーム終了（Enter キー）';

  @override
  String get stormHighscores => 'ハイスコア';

  @override
  String get stormViewBestRuns => '最高記録を表示';

  @override
  String get stormBestRunOfDay => '日別最高';

  @override
  String get stormRuns => '回数';

  @override
  String get stormGetReady => '用意！';

  @override
  String get stormWaitingForMorePlayers => '他の参加者を待っています...';

  @override
  String get stormRaceComplete => 'レース終了！';

  @override
  String get stormSpectating => '観戦中';

  @override
  String get stormJoinTheRace => 'レースに参戦！';

  @override
  String get stormStartTheRace => 'レースを開始';

  @override
  String stormYourRankX(String param) {
    return '順位：$param';
  }

  @override
  String get stormWaitForRematch => '次をお待ちください';

  @override
  String get stormNextRace => '次のレース';

  @override
  String get stormJoinRematch => 'もう一度参加する';

  @override
  String get stormWaitingToStart => 'まもなくスタート';

  @override
  String get stormCreateNewGame => '新たなレースを作成';

  @override
  String get stormJoinPublicRace => 'レースに参加';

  @override
  String get stormRaceYourFriends => '友達とレース';

  @override
  String get stormSkip => '飛ばす';

  @override
  String get stormSkipHelp => 'レース中 1 手だけ飛ばすことができます：';

  @override
  String get stormSkipExplanation => '手を飛ばすことで連続正解が続きます！ 1 レース中 1 回だけ有効。';

  @override
  String get stormFailedPuzzles => '不正解の問題';

  @override
  String get stormSlowPuzzles => '時間のかかった問題';

  @override
  String get stormSkippedPuzzle => '飛ばした問題';

  @override
  String get stormThisWeek => '今週';

  @override
  String get stormThisMonth => '今月';

  @override
  String get stormAllTime => '全期間';

  @override
  String get stormClickToReload => 'クリックで再読み込み';

  @override
  String get stormThisRunHasExpired => '時間切れです！';

  @override
  String get stormThisRunWasOpenedInAnotherTab => 'この試行は別のタブで開かれました！';

  @override
  String stormXRuns(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 回',
    );
    return '$_temp0';
  }

  @override
  String stormPlayedNbRunsOfPuzzleStorm(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$param2 を $count 回プレイ',
    );
    return '$_temp0';
  }

  @override
  String get streamerLichessStreamers => 'Lichess 配信者';

  @override
  String get studyShareAndExport => '共有とエクスポート';

  @override
  String get studyStart => '開始';
}
