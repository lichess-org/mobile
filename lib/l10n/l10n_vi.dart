import 'package:intl/intl.dart' as intl;

import 'l10n.dart';

/// The translations for Vietnamese (`vi`).
class AppLocalizationsVi extends AppLocalizations {
  AppLocalizationsVi([String locale = 'vi']) : super(locale);

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
  String get activityActivity => 'Hoạt động';

  @override
  String get activityHostedALiveStream => 'Đã phát trực tiếp';

  @override
  String activityRankedInSwissTournament(String param1, String param2) {
    return 'Đứng hạng $param1 trong giải $param2';
  }

  @override
  String get activitySignedUp => 'Đã ghi danh ở lichess.org';

  @override
  String activitySupportedNbMonths(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Đã ủng hộ lichess.org $count tháng với tư cách là một $param2',
    );
    return '$_temp0';
  }

  @override
  String activityPracticedNbPositions(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Đã luyện tập $count thế cờ trên $param2',
    );
    return '$_temp0';
  }

  @override
  String activitySolvedNbPuzzles(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Đã giải $count câu đố',
    );
    return '$_temp0';
  }

  @override
  String activityPlayedNbGames(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Đã chơi $count ván $param2',
    );
    return '$_temp0';
  }

  @override
  String activityPostedNbMessages(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Đã đăng $count bình luận trong diễn đàn $param2',
    );
    return '$_temp0';
  }

  @override
  String activityPlayedNbMoves(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Đã đi $count nước',
    );
    return '$_temp0';
  }

  @override
  String activityInNbCorrespondenceGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'trong $count ván cờ qua thư',
    );
    return '$_temp0';
  }

  @override
  String activityCompletedNbGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Đã hoàn thành $count ván cờ qua thư',
    );
    return '$_temp0';
  }

  @override
  String activityFollowedNbPlayers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Đã theo dõi $count người chơi',
    );
    return '$_temp0';
  }

  @override
  String activityGainedNbFollowers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Đạt được $count người theo dõi mới',
    );
    return '$_temp0';
  }

  @override
  String activityHostedNbSimuls(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Đã chủ trì $count sự kiện cờ đồng loạt',
    );
    return '$_temp0';
  }

  @override
  String activityJoinedNbSimuls(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Đã tham gia $count sự kiện cờ đồng loạt',
    );
    return '$_temp0';
  }

  @override
  String activityCreatedNbStudies(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Đã tạo $count nghiên cứu mới',
    );
    return '$_temp0';
  }

  @override
  String activityCompetedInNbTournaments(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Đã hoàn thành $count giải đấu Đấu trường',
    );
    return '$_temp0';
  }

  @override
  String activityRankedInTournament(int count, String param2, String param3, String param4) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Được hạng #$count (lọt top $param2%) với $param3 ván trong giải $param4',
    );
    return '$_temp0';
  }

  @override
  String activityCompetedInNbSwissTournaments(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Đã hoàn thành $count giải đấu hệ Thụy Sĩ',
    );
    return '$_temp0';
  }

  @override
  String activityJoinedNbTeams(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Đã tham gia $count đội',
    );
    return '$_temp0';
  }

  @override
  String get broadcastBroadcasts => 'Các phát sóng';

  @override
  String get broadcastLiveBroadcasts => 'Các giải đấu phát sóng trực tiếp';

  @override
  String challengeChallengesX(String param1) {
    return 'Số thách đấu: $param1';
  }

  @override
  String get challengeChallengeToPlay => 'Thách đấu một ván cờ';

  @override
  String get challengeChallengeDeclined => 'Lời thách đấu bị từ chối.';

  @override
  String get challengeChallengeAccepted => 'Lời thách đấu được chấp nhận!';

  @override
  String get challengeChallengeCanceled => 'Lời thách đấu bị hủy bỏ.';

  @override
  String get challengeRegisterToSendChallenges => 'Xin hãy đăng ký để gửi lời thách đấu tới người dùng này.';

  @override
  String challengeYouCannotChallengeX(String param) {
    return 'Bạn không thể thách đấu $param.';
  }

  @override
  String challengeXDoesNotAcceptChallenges(String param) {
    return '$param không chấp nhận các lời thách đấu.';
  }

  @override
  String challengeYourXRatingIsTooFarFromY(String param1, String param2) {
    return 'Hệ số $param1 của bạn quá cách biệt so với $param2.';
  }

  @override
  String challengeCannotChallengeDueToProvisionalXRating(String param) {
    return 'Không thể thách đấu do hệ số $param tạm thời.';
  }

  @override
  String challengeXOnlyAcceptsChallengesFromFriends(String param) {
    return '$param chỉ chấp nhận những thách đấu từ bạn bè.';
  }

  @override
  String get challengeDeclineGeneric => 'Hiện tại tôi đang không chấp nhận thách đấu.';

  @override
  String get challengeDeclineLater => 'Đây không phải là thời gian thích hợp với tôi, hãy hỏi lại sau.';

  @override
  String get challengeDeclineTooFast => 'Tùy chọn thời gian quá nhanh đối với tôi, hãy thách đấu lại với một thời gian chậm hơn.';

  @override
  String get challengeDeclineTooSlow => 'Tùy chọn thời gian quá chậm đối với tôi, hãy thách đấu lại với một thời gian nhanh hơn.';

  @override
  String get challengeDeclineTimeControl => 'Tôi không chấp nhận các thách đấu với tùy chọn thời gian này.';

  @override
  String get challengeDeclineRated => 'Hãy gửi yêu cầu thách đấu có xếp hạng cho tôi.';

  @override
  String get challengeDeclineCasual => 'Hãy gửi tôi yêu cầu thách đấu không xếp hạng.';

  @override
  String get challengeDeclineStandard => 'Hiện tại tôi không chấp nhận các thách đấu biến thể.';

  @override
  String get challengeDeclineVariant => 'Tôi chưa sẵn sàng chơi biến thể này ngay bây giờ.';

  @override
  String get challengeDeclineNoBot => 'Tôi không chấp nhận các thách đấu từ các BOT.';

  @override
  String get challengeDeclineOnlyBot => 'Tôi chỉ chấp nhận các thách đấu từ BOT.';

  @override
  String get challengeInviteLichessUser => 'Hoặc mời một người dùng Lichess:';

  @override
  String get contactContact => 'Liên hệ';

  @override
  String get contactContactLichess => 'Liên hệ Lichess';

  @override
  String get patronDonate => 'Ủng hộ';

  @override
  String get patronLichessPatron => 'Người bảo trợ Lichess';

  @override
  String perfStatPerfStats(String param) {
    return 'Thống kê $param';
  }

  @override
  String get perfStatViewTheGames => 'Xem các ván cờ';

  @override
  String get perfStatProvisional => 'tạm thời';

  @override
  String get perfStatNotEnoughRatedGames => 'Không có đủ ván có xếp hạng đã được chơi để thiết lập một hệ số đáng tin cậy.';

  @override
  String perfStatProgressOverLastXGames(String param) {
    return 'Sự tiến bộ qua $param ván cờ gần đây:';
  }

  @override
  String perfStatRatingDeviation(String param) {
    return 'Độ chênh lệch hệ số: $param.';
  }

  @override
  String perfStatRatingDeviationTooltip(String param1, String param2, String param3) {
    return 'Giá trị thấp hơn nghĩa là hệ số ổn định hơn. Ở ngưỡng trên $param1, hệ số được coi là tạm thời. Để được xếp trong bảng xếp hạng, giá trị này phải ở dưới ngưỡng $param2 (cờ tiêu chuẩn) hoặc $param3 (các biến thể).';
  }

  @override
  String get perfStatTotalGames => 'Tổng số ván cờ';

  @override
  String get perfStatRatedGames => 'Các ván cờ có xếp hạng';

  @override
  String get perfStatTournamentGames => 'Số ván chơi trong giải đấu';

  @override
  String get perfStatBerserkedGames => 'Số ván chơi Berserk';

  @override
  String get perfStatTimeSpentPlaying => 'Thời gian đã chơi';

  @override
  String get perfStatAverageOpponent => 'Đối thủ trung bình';

  @override
  String get perfStatVictories => 'Thắng';

  @override
  String get perfStatDefeats => 'Thua';

  @override
  String get perfStatDisconnections => 'Ngắt kết nối';

  @override
  String get perfStatNotEnoughGames => 'Chơi chưa đủ ván';

  @override
  String perfStatHighestRating(String param) {
    return 'Hệ số cao nhất: $param';
  }

  @override
  String perfStatLowestRating(String param) {
    return 'Hệ số thấp nhất: $param';
  }

  @override
  String perfStatFromXToY(String param1, String param2) {
    return 'từ $param1 đến $param2';
  }

  @override
  String get perfStatWinningStreak => 'Chuỗi thắng';

  @override
  String get perfStatLosingStreak => 'Chuỗi thua';

  @override
  String perfStatLongestStreak(String param) {
    return 'Chuỗi dài nhất: $param';
  }

  @override
  String perfStatCurrentStreak(String param) {
    return 'Chuỗi hiện tại: $param';
  }

  @override
  String get perfStatBestRated => 'Ván thắng được cộng Elo nhiều nhất';

  @override
  String get perfStatGamesInARow => 'Số ván cờ được chơi liên tục';

  @override
  String get perfStatLessThanOneHour => 'Ít hơn một giờ giữa các ván cờ';

  @override
  String get perfStatMaxTimePlaying => 'Thời gian dài nhất đã chơi';

  @override
  String get perfStatNow => 'bây giờ';

  @override
  String get preferencesPreferences => 'Tuỳ chỉnh';

  @override
  String get preferencesDisplay => 'Hiển thị';

  @override
  String get preferencesPrivacy => 'Quyền riêng tư';

  @override
  String get preferencesNotifications => 'Thông báo';

  @override
  String get preferencesPieceAnimation => 'Hình ảnh động của quân cờ';

  @override
  String get preferencesMaterialDifference => 'Chênh lệch giá trị quân cờ';

  @override
  String get preferencesBoardHighlights => 'Đánh dấu trên bàn cờ (nước đi mới nhất và nước chiếu)';

  @override
  String get preferencesPieceDestinations => 'Các điểm đến của quân cờ (các nước đi hợp lý và nước đi dự đoán)';

  @override
  String get preferencesBoardCoordinates => 'Tọa độ bàn cờ (A-H, 1-8)';

  @override
  String get preferencesMoveListWhilePlaying => 'Biên bản ván đấu';

  @override
  String get preferencesPgnPieceNotation => 'Ký hiệu nước cờ';

  @override
  String get preferencesChessPieceSymbol => 'Biểu tượng quân cờ';

  @override
  String get preferencesPgnLetter => 'Ký tự (K, Q, R, B, N)';

  @override
  String get preferencesZenMode => 'Chế độ tập trung';

  @override
  String get preferencesShowPlayerRatings => 'Hiển thị hệ số của người chơi';

  @override
  String get preferencesShowFlairs => 'Hiển thị biểu tượng của người chơi';

  @override
  String get preferencesExplainShowPlayerRatings => 'Điều này sẽ ẩn toàn bộ hệ số khỏi Lichess để giúp tập trung vào ván cờ. Ván đấu có xếp hạng vẫn ảnh hưởng đến hệ số của bạn, đây chỉ là những gì bạn có thể nhìn thấy.';

  @override
  String get preferencesDisplayBoardResizeHandle => 'Hiện nút thay đổi kích cỡ bàn cờ';

  @override
  String get preferencesOnlyOnInitialPosition => 'Chỉ ở thế cờ ban đầu';

  @override
  String get preferencesInGameOnly => 'Chỉ trong ván cờ';

  @override
  String get preferencesChessClock => 'Đồng hồ cờ vua';

  @override
  String get preferencesTenthsOfSeconds => 'Một phần mười giây';

  @override
  String get preferencesWhenTimeRemainingLessThanTenSeconds => 'Khi thời gian còn lại < 10 giây';

  @override
  String get preferencesHorizontalGreenProgressBars => 'Thanh tiến trình ngang màu xanh';

  @override
  String get preferencesSoundWhenTimeGetsCritical => 'Âm thanh khi thời gian sắp hết';

  @override
  String get preferencesGiveMoreTime => 'Cho thêm thời gian';

  @override
  String get preferencesGameBehavior => 'Thao tác chơi';

  @override
  String get preferencesHowDoYouMovePieces => 'Bạn di chuyển quân như thế nào?';

  @override
  String get preferencesClickTwoSquares => 'Nhấn hai ô';

  @override
  String get preferencesDragPiece => 'Thả quân cờ';

  @override
  String get preferencesBothClicksAndDrag => 'Cả hai';

  @override
  String get preferencesPremovesPlayingDuringOpponentTurn => 'Nước cờ dự đoán (được thực hiện khi đang đến lượt đi của đối phương)';

  @override
  String get preferencesTakebacksWithOpponentApproval => 'Hoãn nước đi (với sự chấp thuận của đối thủ)';

  @override
  String get preferencesInCasualGamesOnly => 'Chỉ trong các ván đấu không tính Elo';

  @override
  String get preferencesPromoteToQueenAutomatically => 'Tự động phong cấp thành quân Hậu';

  @override
  String get preferencesExplainPromoteToQueenAutomatically => 'Giữ nút <ctrl> trong khi phong cấp để tạm thời hủy bỏ việc phong cấp tự động';

  @override
  String get preferencesWhenPremoving => 'Khi đi trước';

  @override
  String get preferencesClaimDrawOnThreefoldRepetitionAutomatically => 'Tự động hoà khi lặp cờ ba lần';

  @override
  String get preferencesWhenTimeRemainingLessThanThirtySeconds => 'Khi thời gian còn lại < 30 giây';

  @override
  String get preferencesMoveConfirmation => 'Xác nhận nước đi';

  @override
  String get preferencesExplainCanThenBeTemporarilyDisabled => 'Có thể bị vô hiệu hóa trong ván cờ với mục lục bàn cờ';

  @override
  String get preferencesInCorrespondenceGames => 'Cờ qua thư';

  @override
  String get preferencesCorrespondenceAndUnlimited => 'Cờ qua thư và cờ vô hạn';

  @override
  String get preferencesConfirmResignationAndDrawOffers => 'Xác nhận chịu thua và đề nghị hòa';

  @override
  String get preferencesCastleByMovingTheKingTwoSquaresOrOntoTheRook => 'Cách nhập thành';

  @override
  String get preferencesCastleByMovingTwoSquares => 'Di chuyển vua 2 nước';

  @override
  String get preferencesCastleByMovingOntoTheRook => 'Di chuyển vua vào xe';

  @override
  String get preferencesInputMovesWithTheKeyboard => 'Nhập các nước đi với bàn phím';

  @override
  String get preferencesInputMovesWithVoice => 'Đầu vào nước đi với giọng nói của bạn';

  @override
  String get preferencesSnapArrowsToValidMoves => 'Tự kéo mũi tên vào ô của nước đi hợp lệ';

  @override
  String get preferencesSayGgWpAfterLosingOrDrawing => 'Tự động nhắn \"Good game, well played\" (Ván cờ hay, chơi hay lắm) sau khi hòa hoặc thua';

  @override
  String get preferencesYourPreferencesHaveBeenSaved => 'Tùy chọn của bạn đã được lưu';

  @override
  String get preferencesScrollOnTheBoardToReplayMoves => 'Cuộn con chuột trên bàn cờ để xem lại nước đi';

  @override
  String get preferencesCorrespondenceEmailNotification => 'Email thông báo hàng ngày sẽ bao gồm cả các ván cờ qua thư';

  @override
  String get preferencesNotifyStreamStart => 'Streamer đang phát trực tiếp';

  @override
  String get preferencesNotifyInboxMsg => 'Tin nhắn mới';

  @override
  String get preferencesNotifyForumMention => 'Có bình luận diễn đàn đề cập đến bạn';

  @override
  String get preferencesNotifyInvitedStudy => 'Lời mời nghiên cứu';

  @override
  String get preferencesNotifyGameEvent => 'Những cập nhật liên quan đến ván cờ qua thư';

  @override
  String get preferencesNotifyChallenge => 'Các lời thách đấu';

  @override
  String get preferencesNotifyTournamentSoon => 'Giải đấu sắp bắt đầu';

  @override
  String get preferencesNotifyTimeAlarm => 'Thời gian đánh cờ qua thư sắp hết';

  @override
  String get preferencesNotifyBell => 'Chuông thông báo khi đang truy cập Lichess';

  @override
  String get preferencesNotifyPush => 'Thông báo tới thiết bị của bạn khi bạn không truy cập Lichess';

  @override
  String get preferencesNotifyWeb => 'Trình duyệt';

  @override
  String get preferencesNotifyDevice => 'Thiết bị';

  @override
  String get preferencesBellNotificationSound => 'Âm thanh chuông báo';

  @override
  String get puzzlePuzzles => 'Câu đố';

  @override
  String get puzzlePuzzleThemes => 'Chủ đề câu đố';

  @override
  String get puzzleRecommended => 'Được đề xuất';

  @override
  String get puzzlePhases => 'Giai đoạn';

  @override
  String get puzzleMotifs => 'Các mô-típ';

  @override
  String get puzzleAdvanced => 'Nâng cao';

  @override
  String get puzzleLengths => 'Thời lượng';

  @override
  String get puzzleMates => 'Chiếu hết';

  @override
  String get puzzleGoals => 'Mục tiêu';

  @override
  String get puzzleOrigin => 'Nguồn từ';

  @override
  String get puzzleSpecialMoves => 'Các nước cờ đặc biệt';

  @override
  String get puzzleDidYouLikeThisPuzzle => 'Bạn thích câu đố này chứ?';

  @override
  String get puzzleVoteToLoadNextOne => 'Bình chọn để đến câu đố tiếp theo!';

  @override
  String get puzzleUpVote => 'Thích câu đố';

  @override
  String get puzzleDownVote => 'Không thích câu đố';

  @override
  String get puzzleYourPuzzleRatingWillNotChange => 'Hệ số giải câu đố của bạn sẽ không thay đổi. Lưu ý rằng giải câu đố không phải một cuộc thi. Hệ số của bạn nhằm giúp chọn những câu đố phù hợp nhất với trình độ của bạn.';

  @override
  String get puzzleFindTheBestMoveForWhite => 'Tìm nước tối ưu cho Trắng.';

  @override
  String get puzzleFindTheBestMoveForBlack => 'Tìm nước tối ưu cho Đen.';

  @override
  String get puzzleToGetPersonalizedPuzzles => 'Để có được các thế cờ dành riêng cho bạn:';

  @override
  String puzzlePuzzleId(String param) {
    return 'Câu đố $param';
  }

  @override
  String get puzzlePuzzleOfTheDay => 'Câu đố của ngày';

  @override
  String get puzzleDailyPuzzle => 'Câu đố Hàng ngày';

  @override
  String get puzzleClickToSolve => 'Nhấn để giải';

  @override
  String get puzzleGoodMove => 'Nước đi tốt';

  @override
  String get puzzleBestMove => 'Nước đi tối ưu!';

  @override
  String get puzzleKeepGoing => 'Hãy tiếp tục…';

  @override
  String get puzzlePuzzleSuccess => 'Thành công!';

  @override
  String get puzzlePuzzleComplete => 'Hoàn thành câu đố!';

  @override
  String get puzzleByOpenings => 'Theo khai cuộc';

  @override
  String get puzzlePuzzlesByOpenings => 'Câu đố theo khai cuộc';

  @override
  String get puzzleOpeningsYouPlayedTheMost => 'Những khai cuộc bạn thường chơi trong các ván đấu có xếp hạng';

  @override
  String get puzzleUseFindInPage => 'Dùng \"Tìm kiếm trong trang\" trong mục lục trình duyệt để tìm khai cuộc yêu thích của bạn!';

  @override
  String get puzzleUseCtrlF => 'Dùng Ctrl+f để tìm khai cuộc yêu thích của bạn!';

  @override
  String get puzzleNotTheMove => 'Đó chưa phải là nước đi tối ưu!';

  @override
  String get puzzleTrySomethingElse => 'Hãy thử nước đi khác.';

  @override
  String puzzleRatingX(String param) {
    return 'Hệ số: $param';
  }

  @override
  String get puzzleHidden => 'ẩn';

  @override
  String puzzleFromGameLink(String param) {
    return 'Từ ván cờ $param';
  }

  @override
  String get puzzleContinueTraining => 'Tiếp tục tập luyện';

  @override
  String get puzzleDifficultyLevel => 'Độ khó';

  @override
  String get puzzleNormal => 'Bình thường';

  @override
  String get puzzleEasier => 'Dễ hơn';

  @override
  String get puzzleEasiest => 'Dễ nhất';

  @override
  String get puzzleHarder => 'Khó hơn';

  @override
  String get puzzleHardest => 'Khó nhất';

  @override
  String get puzzleExample => 'Ví dụ';

  @override
  String get puzzleAddAnotherTheme => 'Thêm chủ đề khác';

  @override
  String get puzzleNextPuzzle => 'Câu đố tiếp theo';

  @override
  String get puzzleJumpToNextPuzzleImmediately => 'Chuyển tới câu đố tiếp theo ngay lập tức';

  @override
  String get puzzlePuzzleDashboard => 'Bảng thống kê giải câu đố';

  @override
  String get puzzleImprovementAreas => 'Các điểm cần cải thiện';

  @override
  String get puzzleStrengths => 'Điểm mạnh';

  @override
  String get puzzleHistory => 'Lịch sử giải câu đố';

  @override
  String get puzzleSolved => 'giải đúng';

  @override
  String get puzzleFailed => 'giải sai';

  @override
  String get puzzleStreakDescription => 'Giải những câu đố có độ khó tăng dần và tích lũy chuỗi thắng. Sẽ không có đồng hồ, nên hãy giải chúng một cách bình tĩnh. Một nước đi sai, và trò chơi sẽ kết thúc! Tuy nhiên, bạn được quyền bỏ qua một nước đi trong mỗi lần chơi.';

  @override
  String puzzleYourStreakX(String param) {
    return 'Chuỗi của bạn: $param';
  }

  @override
  String get puzzleStreakSkipExplanation => 'Bỏ qua nước đi này để bảo toàn chuỗi của bạn! Chỉ dùng được một lần cho mỗi lần chơi.';

  @override
  String get puzzleContinueTheStreak => 'Tiếp tục chuỗi';

  @override
  String get puzzleNewStreak => 'Chuỗi mới';

  @override
  String get puzzleFromMyGames => 'Từ ván đấu của tôi';

  @override
  String get puzzleLookupOfPlayer => 'Tìm câu đố từ các ván đấu của người khác';

  @override
  String puzzleFromXGames(String param) {
    return 'Câu đố từ ván cờ của $param';
  }

  @override
  String get puzzleSearchPuzzles => 'Tìm câu đố';

  @override
  String get puzzleFromMyGamesNone => 'Bạn không có câu đố nào trong dữ liệu, nhưng Lichess vẫn rất yêu mến bạn.\n\nHãy chơi thêm nhiều ván cờ nhanh và cờ chậm để có cơ hội có một câu đố từ ván cờ của riêng bạn!';

  @override
  String puzzleFromXGamesFound(String param1, String param2) {
    return 'Đã tìm được $param1 câu đố trong các ván đấu của $param2';
  }

  @override
  String get puzzlePuzzleDashboardDescription => 'Rèn luyện, phân tích, cải thiện';

  @override
  String puzzlePercentSolved(String param) {
    return 'Giải đúng $param';
  }

  @override
  String get puzzleNoPuzzlesToShow => 'Chưa có gì cả, hãy giải một vài câu đố trước đã!';

  @override
  String get puzzleImprovementAreasDescription => 'Luyện tập chúng để tối ưu hóa tiến trình của bạn!';

  @override
  String get puzzleStrengthDescription => 'Bạn thể hiện tốt nhất ở những lĩnh vực này';

  @override
  String puzzlePlayedXTimes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Đã được giải $count lần',
    );
    return '$_temp0';
  }

  @override
  String puzzleNbPointsBelowYourPuzzleRating(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Dưới $count điểm hệ số câu đố của bạn',
    );
    return '$_temp0';
  }

  @override
  String puzzleNbPointsAboveYourPuzzleRating(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Trên $count điểm hệ số câu đố của bạn',
    );
    return '$_temp0';
  }

  @override
  String puzzleNbPlayed(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Đã giải $count',
    );
    return '$_temp0';
  }

  @override
  String puzzleNbToReplay(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Cần giải lại $count',
    );
    return '$_temp0';
  }

  @override
  String get puzzleThemeAdvancedPawn => 'Tốt thông xa';

  @override
  String get puzzleThemeAdvancedPawnDescription => 'Một quân tốt của bạn có thể đe dọa phong cấp đang nằm sâu bên trong thế trận của đối thủ.';

  @override
  String get puzzleThemeAdvantage => 'Lợi thế';

  @override
  String get puzzleThemeAdvantageDescription => 'Tận dụng cơ hội của bạn để chiếm lấy lợi thế quyết định. (200cp ≤ đánh giá ≤ 600cp)';

  @override
  String get puzzleThemeAnastasiaMate => 'Chiếu hết kiểu Anastasia';

  @override
  String get puzzleThemeAnastasiaMateDescription => 'Một quân mã phối hợp cùng quân xe hoặc quân hậu để bẫy quân vua đối phương vào thế kẹp giữa cạnh bàn cờ và một quân khác.';

  @override
  String get puzzleThemeArabianMate => 'Chiếu hết kiểu Ả Rập';

  @override
  String get puzzleThemeArabianMateDescription => 'Một Mã và một Xe hợp sức để bẫy vua đối phương trên một góc của bàn cờ.';

  @override
  String get puzzleThemeAttackingF2F7 => 'Tấn công ô f2 hoặc f7';

  @override
  String get puzzleThemeAttackingF2F7Description => 'Một đòn tấn công nhằm vào quân tốt f2 hay f7, ví dụ như trong khai cuộc Fried Liver Attack.';

  @override
  String get puzzleThemeAttraction => 'Thu hút';

  @override
  String get puzzleThemeAttractionDescription => 'Việc đổi quân hoặc thí quân thu hút hoặc ép buộc một quân đối phương đến một ô nhằm tạo một đòn chiến thuật.';

  @override
  String get puzzleThemeBackRankMate => 'Chiếu hết hàng cuối';

  @override
  String get puzzleThemeBackRankMateDescription => 'Chiếu hết trên hàng cuối, khi vua bị mắc kẹt bởi chính quân của nó.';

  @override
  String get puzzleThemeBishopEndgame => 'Cờ tàn tượng';

  @override
  String get puzzleThemeBishopEndgameDescription => 'Một thế cờ tàn chỉ có tượng và tốt.';

  @override
  String get puzzleThemeBodenMate => 'Chiếu hết kiểu Boden';

  @override
  String get puzzleThemeBodenMateDescription => 'Hai quân Tượng tấn công trên các đường chéo chéo nhau chiếu hết một quân vua bị kẹt bởi đồng đội của nó.';

  @override
  String get puzzleThemeCastling => 'Nhập thành';

  @override
  String get puzzleThemeCastlingDescription => 'Chuyển quân vua đến vị trí an toàn và triển khai quân xe để tấn công.';

  @override
  String get puzzleThemeCapturingDefender => 'Ăn quân phòng thủ';

  @override
  String get puzzleThemeCapturingDefenderDescription => 'Loại bỏ một quân cực kỳ quan trọng đối với việc bảo vệ một quân cờ khác, khiến cho quân cờ hiện không được bảo vệ có thể bị ăn vào một nước sau đó.';

  @override
  String get puzzleThemeCrushing => 'Áp đảo';

  @override
  String get puzzleThemeCrushingDescription => 'Phát hiện sai lầm nghiêm trọng của đối phương để giành được lợi thế áp đảo. (đánh giá ≥ 600cp)';

  @override
  String get puzzleThemeDoubleBishopMate => 'Chiếu hết bằng cặp Tượng';

  @override
  String get puzzleThemeDoubleBishopMateDescription => 'Hai quân Tượng tấn công trên các đường chéo liền kề chiếu hết một quân vua bị cản trở bởi quân cờ.';

  @override
  String get puzzleThemeDovetailMate => 'Chiếu hết kiểu Đuôi én';

  @override
  String get puzzleThemeDovetailMateDescription => 'Một Hậu chiếu hết vua ở ô liền kề, hai ô duy nhất quân vua có thể chạy được lúc này đều bị chặn.';

  @override
  String get puzzleThemeEquality => 'Cân bằng';

  @override
  String get puzzleThemeEqualityDescription => 'Lật kèo từ một thế cờ thua và giành được một thế trận hòa hoặc cân bằng. (đánh giá ≤ 200cp)';

  @override
  String get puzzleThemeKingsideAttack => 'Tấn công cánh vua';

  @override
  String get puzzleThemeKingsideAttackDescription => 'Tấn công vua đối phương sau khi họ nhập thành cánh vua.';

  @override
  String get puzzleThemeClearance => 'Dọn đường';

  @override
  String get puzzleThemeClearanceDescription => 'Một nước đi, thường đi kèm nhịp độ dùng để dọn đường một ô, cột hay đường chéo cho một đòn chiến thuật sắp tới.';

  @override
  String get puzzleThemeDefensiveMove => 'Nước cờ phòng thủ';

  @override
  String get puzzleThemeDefensiveMoveDescription => 'Một nước đi hoặc chuỗi nước đi chính xác cần để tránh mất quân hoặc một lợi thế khác.';

  @override
  String get puzzleThemeDeflection => 'Đánh lạc hướng';

  @override
  String get puzzleThemeDeflectionDescription => 'Một nước đi đánh lạc hướng một quân đối phương khỏi một nhiệm vụ nó đang làm, chẳng hạn như bảo vệ một ô trọng điểm. Còn được gọi là \"quá tải\".';

  @override
  String get puzzleThemeDiscoveredAttack => 'Tấn công mở';

  @override
  String get puzzleThemeDiscoveredAttackDescription => 'Đi một quân cờ đang chặn giữa đường tấn công của một quân đánh xa khác (ví dụ như đi một quân mã khỏi đường tấn công của quân xe).';

  @override
  String get puzzleThemeDoubleCheck => 'Chiếu đôi';

  @override
  String get puzzleThemeDoubleCheckDescription => 'Chiếu bằng hai quân một lúc, là kết quả của một đòn tấn công mở khi mà cả quân đứng sau và quân chặn đường đều tấn công vua đối phương.';

  @override
  String get puzzleThemeEndgame => 'Tàn cuộc';

  @override
  String get puzzleThemeEndgameDescription => 'Chiến thuật trong phần kết thúc của ván cờ.';

  @override
  String get puzzleThemeEnPassantDescription => 'Một đòn chiến thuật bao gồm luật bắt tốt qua đường, khi một quân tốt có thể ăn một quân tốt đối phương đi qua mặt nó khi đi 2 ô từ vị trí ban đầu của nó.';

  @override
  String get puzzleThemeExposedKing => 'Vua bị hở';

  @override
  String get puzzleThemeExposedKingDescription => 'Một đòn chiến thuật bao gồm một quân vua với ít quân bảo vệ quanh quân vua đó, thường dẫn tới chiếu hết.';

  @override
  String get puzzleThemeFork => 'Tấn công đôi';

  @override
  String get puzzleThemeForkDescription => 'Một nước đi mà một quân cờ tấn công hai quân cờ của đối phương cùng lúc.';

  @override
  String get puzzleThemeHangingPiece => 'Quân treo';

  @override
  String get puzzleThemeHangingPieceDescription => 'Một chiến thuật liên quan đến quân cờ của đối phương không được phòng thủ hoặc phòng thủ không đủ dẫn tới việc có thể ăn quân cờ đấy.';

  @override
  String get puzzleThemeHookMate => 'Chiếu kiểu móc';

  @override
  String get puzzleThemeHookMateDescription => 'Chiếu hết bằng quân xe, mã và tốt cùng với một quân tốt đối phương làm chặn đường vua chạy.';

  @override
  String get puzzleThemeInterference => 'Can thiệp';

  @override
  String get puzzleThemeInterferenceDescription => 'Di chuyển một quân cờ giữa hai quân cờ đối thủ để một hoặc cả hai quân cờ đối thủ không bị cản trở, chẳng hạn như một quân Mã trên ô vuông được bảo vệ giữa hai quân Xe.';

  @override
  String get puzzleThemeIntermezzo => 'Xen giữa';

  @override
  String get puzzleThemeIntermezzoDescription => 'Thay vì chơi nước đi dự kiến, trước tiên hãy xen vào một nước đi khác gây ra mối đe dọa ngay lập tức mà đối thủ phải đáp trả. Còn được gọi là \"Zwischenzug\" hoặc \"Ở giữa\".';

  @override
  String get puzzleThemeKnightEndgame => 'Tàn cuộc Mã';

  @override
  String get puzzleThemeKnightEndgameDescription => 'Một thế cờ tàn chỉ có mã và tốt.';

  @override
  String get puzzleThemeLong => 'Câu đố dài';

  @override
  String get puzzleThemeLongDescription => 'Thắng trong ba nước cờ.';

  @override
  String get puzzleThemeMaster => 'Ván đấu cao cấp';

  @override
  String get puzzleThemeMasterDescription => 'Câu đố từ các ván đấu của người có danh hiệu.';

  @override
  String get puzzleThemeMasterVsMaster => 'Ván đấu giữa 2 kiện tướng';

  @override
  String get puzzleThemeMasterVsMasterDescription => 'Câu đố từ các ván đấu giữa hai người chơi có danh hiệu.';

  @override
  String get puzzleThemeMate => 'Chiếu hết';

  @override
  String get puzzleThemeMateDescription => 'Chiến thắng ván cờ với phong cách.';

  @override
  String get puzzleThemeMateIn1 => 'Chiếu hết trong 1 nước';

  @override
  String get puzzleThemeMateIn1Description => 'Chiếu hết trong một nước cờ.';

  @override
  String get puzzleThemeMateIn2 => 'Chiếu hết trong 2 nước';

  @override
  String get puzzleThemeMateIn2Description => 'Chiếu hết trong hai nước cờ.';

  @override
  String get puzzleThemeMateIn3 => 'Chiếu hết trong 3 nước';

  @override
  String get puzzleThemeMateIn3Description => 'Chiếu hết trong ba nước cờ.';

  @override
  String get puzzleThemeMateIn4 => 'Chiếu hết trong 4 nước';

  @override
  String get puzzleThemeMateIn4Description => 'Chiếu hết trong bốn nước cờ.';

  @override
  String get puzzleThemeMateIn5 => 'Chiếu hết trong 5 nước hoặc hơn';

  @override
  String get puzzleThemeMateIn5Description => 'Tìm ra một chuỗi dài các nước cờ dẫn đến chiếu hết.';

  @override
  String get puzzleThemeMiddlegame => 'Trung cuộc';

  @override
  String get puzzleThemeMiddlegameDescription => 'Chiến thuật trong giai đoạn thứ hai của ván cờ.';

  @override
  String get puzzleThemeOneMove => 'Câu đố một nước';

  @override
  String get puzzleThemeOneMoveDescription => 'Câu đố mà chỉ có một nước đi.';

  @override
  String get puzzleThemeOpening => 'Khai cuộc';

  @override
  String get puzzleThemeOpeningDescription => 'Chiến thuật trong phần mở đầu của ván cờ.';

  @override
  String get puzzleThemePawnEndgame => 'Tàn cuộc Tốt';

  @override
  String get puzzleThemePawnEndgameDescription => 'Một thế tàn cuộc chỉ với tốt.';

  @override
  String get puzzleThemePin => 'Ghim';

  @override
  String get puzzleThemePinDescription => 'Một chiến thuật khiến một quân cờ không thể di chuyển mà không để lộ mục tiêu là quân cờ đằng sau nó với giá trị lớn hơn.';

  @override
  String get puzzleThemePromotion => 'Phong cấp';

  @override
  String get puzzleThemePromotionDescription => 'Phong cấp tốt của bạn thành quân hậu hoặc những quân phụ khác.';

  @override
  String get puzzleThemeQueenEndgame => 'Tàn cuộc Hậu';

  @override
  String get puzzleThemeQueenEndgameDescription => 'Một thế cờ tàn chỉ có hậu và tốt.';

  @override
  String get puzzleThemeQueenRookEndgame => 'Hậu và Xe';

  @override
  String get puzzleThemeQueenRookEndgameDescription => 'Một thế cờ tàn chỉ có hậu, xe và tốt.';

  @override
  String get puzzleThemeQueensideAttack => 'Tấn công cánh hậu';

  @override
  String get puzzleThemeQueensideAttackDescription => 'Tấn công vua đối phương sau khi họ nhập thành cánh hậu.';

  @override
  String get puzzleThemeQuietMove => 'Nước đi tĩnh lặng';

  @override
  String get puzzleThemeQuietMoveDescription => 'Một nước cờ không chiếu hay ăn quân của đối phương, nhưng lại tạo ra một sự đe dọa không thể tránh khỏi cho một nước đi sau.';

  @override
  String get puzzleThemeRookEndgame => 'Tàn cuộc Xe';

  @override
  String get puzzleThemeRookEndgameDescription => 'Một thế cờ tàn chỉ có xe và tốt.';

  @override
  String get puzzleThemeSacrifice => 'Thí quân';

  @override
  String get puzzleThemeSacrificeDescription => 'Một chiến thuật liên quan đến việc từ bỏ quân trong thời gian ngắn, để giành lại lợi thế sau một chuỗi nước đi bắt buộc.';

  @override
  String get puzzleThemeShort => 'Câu đố ngắn';

  @override
  String get puzzleThemeShortDescription => 'Thắng trong hai nước cờ.';

  @override
  String get puzzleThemeSkewer => 'Đòn xiên';

  @override
  String get puzzleThemeSkewerDescription => 'Một mô típ liên quan tới việc một quân cờ có giá trị cao bị tấn công buộc phải di chuyển khỏi vị trí, dẫn tới một quân cờ giá trị thấp hơn ở phía sau bị tấn công hoặc ăn, ngược lại so với ghim.';

  @override
  String get puzzleThemeSmotheredMate => 'Chiếu kiểu kẹt';

  @override
  String get puzzleThemeSmotheredMateDescription => 'Một nước chiếu hết với quân mã mà trong đó vua đối phương không thể di chuyển vì bị bao vây bởi chính các quân cờ khác của họ.';

  @override
  String get puzzleThemeSuperGM => 'Các ván đấu từ Siêu Đại Kiện Tướng';

  @override
  String get puzzleThemeSuperGMDescription => 'Câu đố từ những ván đấu đã được chơi bởi những kỳ thủ giỏi nhất trên thế giới.';

  @override
  String get puzzleThemeTrappedPiece => 'Quân bị bẫy';

  @override
  String get puzzleThemeTrappedPieceDescription => 'Một quân cờ không thể thoát khỏi việc bị ăn vì nó bị giới hạn các nước đi.';

  @override
  String get puzzleThemeUnderPromotion => 'Phong cấp thấp';

  @override
  String get puzzleThemeUnderPromotionDescription => 'Phong cấp thành mã, tượng hoặc xe.';

  @override
  String get puzzleThemeVeryLong => 'Câu đố rất dài';

  @override
  String get puzzleThemeVeryLongDescription => 'Bốn nước cờ hoặc hơn để chiến thắng.';

  @override
  String get puzzleThemeXRayAttack => 'Đòn Tia X';

  @override
  String get puzzleThemeXRayAttackDescription => 'Một quân cờ tấn công hoặc phòng thủ một ô sau một quân cờ khác của đối phương.';

  @override
  String get puzzleThemeZugzwang => 'Cưỡng ép';

  @override
  String get puzzleThemeZugzwangDescription => 'Đối phương bị giới hạn các nước mà họ có thể đi và tất cả các nước đi ấy đều hại họ.';

  @override
  String get puzzleThemeHealthyMix => 'Phối hợp nhịp nhàng';

  @override
  String get puzzleThemeHealthyMixDescription => 'Mỗi thứ một chút. Bạn không biết được thứ gì đang chờ mình, vậy nên bạn cần phải sẵn sàng cho mọi thứ! Như một ván cờ thật vậy!';

  @override
  String get puzzleThemePlayerGames => 'Các ván đấu của người chơi';

  @override
  String get puzzleThemePlayerGamesDescription => 'Những câu đố từ những ván cờ của bạn hoặc từ các ván cờ của những người chơi khác.';

  @override
  String puzzleThemePuzzleDownloadInformation(String param) {
    return 'Những câu đố này thuộc phạm vi công khai và có thể tải về từ $param.';
  }

  @override
  String get searchSearch => 'Tìm kiếm';

  @override
  String get settingsSettings => 'Cài đặt';

  @override
  String get settingsCloseAccount => 'Đóng tài khoản';

  @override
  String get settingsManagedAccountCannotBeClosed => 'Tài khoản của bạn đang bị quản lý, hiện không thể đóng.';

  @override
  String get settingsClosingIsDefinitive => 'Việc đóng tài khoản là vĩnh viễn. Không có cách nào để có thể lấy lại. Bạn vẫn chắc chắn muốn đóng chứ?';

  @override
  String get settingsCantOpenSimilarAccount => 'Bạn không được phép tạo tài khoản trùng tên, kể cả khác chữ hoa, thường.';

  @override
  String get settingsChangedMindDoNotCloseAccount => 'Tôi đã đổi ý, đừng đóng tài khoản của tôi';

  @override
  String get settingsCloseAccountExplanation => 'Bạn có chắc muốn đóng tài khoản? Việc đóng tài khoản là quyết định vĩnh viễn. Bạn sẽ KHÔNG BAO GIỜ có thể ĐĂNG NHẬP LẠI.';

  @override
  String get settingsThisAccountIsClosed => 'Tài khoản này đã bị đóng';

  @override
  String get playWithAFriend => 'Chơi với bạn bè';

  @override
  String get playWithTheMachine => 'Chơi với máy tính';

  @override
  String get toInviteSomeoneToPlayGiveThisUrl => 'Để mời ai đó chơi, hãy gửi URL này';

  @override
  String get gameOver => 'Kết thúc ván cờ';

  @override
  String get waitingForOpponent => 'Đang chờ đối thủ';

  @override
  String get orLetYourOpponentScanQrCode => 'Hoặc để đối thủ của bạn quét mã QR này';

  @override
  String get waiting => 'Đang chờ';

  @override
  String get yourTurn => 'Đến lượt bạn';

  @override
  String aiNameLevelAiLevel(String param1, String param2) {
    return '$param1 cấp độ $param2';
  }

  @override
  String get level => 'Cấp độ';

  @override
  String get strength => 'Độ mạnh';

  @override
  String get toggleTheChat => 'Bật/Tắt trò chuyện';

  @override
  String get chat => 'Trò chuyện';

  @override
  String get resign => 'Chịu thua';

  @override
  String get checkmate => 'Chiếu hết';

  @override
  String get stalemate => 'Hết nước đi';

  @override
  String get white => 'Quân Trắng';

  @override
  String get black => 'Quân Đen';

  @override
  String get asWhite => 'khi chơi quân trắng';

  @override
  String get asBlack => 'khi chơi quân đen';

  @override
  String get randomColor => 'Màu quân ngẫu nhiên';

  @override
  String get createAGame => 'Tạo một ván cờ';

  @override
  String get whiteIsVictorious => 'Bên Trắng thắng';

  @override
  String get blackIsVictorious => 'Bên Đen thắng';

  @override
  String get youPlayTheWhitePieces => 'Bạn chơi quân trắng';

  @override
  String get youPlayTheBlackPieces => 'Bạn chơi quân đen';

  @override
  String get itsYourTurn => 'Đến lượt bạn!';

  @override
  String get cheatDetected => 'Phát hiện Gian lận';

  @override
  String get kingInTheCenter => 'Vua ở trung tâm';

  @override
  String get threeChecks => 'Ba lần chiếu';

  @override
  String get raceFinished => 'Cuộc đua kết thúc';

  @override
  String get variantEnding => 'Hết cờ theo luật biến thể';

  @override
  String get newOpponent => 'Đối thủ mới';

  @override
  String get yourOpponentWantsToPlayANewGameWithYou => 'Đối thủ muốn chơi một ván cờ mới với bạn';

  @override
  String get joinTheGame => 'Tham gia ván cờ';

  @override
  String get whitePlays => 'Lượt Trắng đi';

  @override
  String get blackPlays => 'Lượt Đen đi';

  @override
  String get opponentLeftChoices => 'Đối thủ của bạn đã rời khỏi ván cờ. Bạn có thể tuyên bố chiến thắng, chọn hòa hoặc đợi.';

  @override
  String get forceResignation => 'Giành chiến thắng';

  @override
  String get forceDraw => 'Bắt buộc hòa';

  @override
  String get talkInChat => 'Hãy cư xử thân thiện trong cuộc trò chuyện!';

  @override
  String get theFirstPersonToComeOnThisUrlWillPlayWithYou => 'Người đầu tiên sử dụng URL này sẽ bắt đầu chơi với bạn.';

  @override
  String get whiteResigned => 'Trắng chịu thua';

  @override
  String get blackResigned => 'Đen chịu thua';

  @override
  String get whiteLeftTheGame => 'Trắng đã rời khỏi ván cờ';

  @override
  String get blackLeftTheGame => 'Đen đã rời khỏi ván cờ';

  @override
  String get whiteDidntMove => 'Bên trắng không đi quân';

  @override
  String get blackDidntMove => 'Bên đen không đi quân';

  @override
  String get requestAComputerAnalysis => 'Yêu cầu máy tính phân tích';

  @override
  String get computerAnalysis => 'Máy tính phân tích';

  @override
  String get computerAnalysisAvailable => 'Có sẵn máy tính phân tích';

  @override
  String get computerAnalysisDisabled => 'Phân tích máy tính bị vô hiệu hóa';

  @override
  String get analysis => 'Bàn cờ phân tích';

  @override
  String depthX(String param) {
    return 'Độ sâu $param';
  }

  @override
  String get usingServerAnalysis => 'Sử dụng phân tích nhờ máy chủ';

  @override
  String get loadingEngine => 'Đang tải động cơ máy tính...';

  @override
  String get calculatingMoves => 'Đang tính nước đi...';

  @override
  String get engineFailed => 'Lỗi khi đang tải động cơ';

  @override
  String get cloudAnalysis => 'Phân tích đám mây';

  @override
  String get goDeeper => 'Phân tích sâu hơn';

  @override
  String get showThreat => 'Hiện các mối đe dọa';

  @override
  String get inLocalBrowser => 'trong trình duyệt cục bộ';

  @override
  String get toggleLocalEvaluation => 'Bật/Tắt đánh giá cục bộ';

  @override
  String get promoteVariation => 'Về biến chính';

  @override
  String get makeMainLine => 'Trở thành biến chính';

  @override
  String get deleteFromHere => 'Xoá từ đây';

  @override
  String get collapseVariations => 'Thu gọn các biến';

  @override
  String get expandVariations => 'Mở rộng các biến';

  @override
  String get forceVariation => 'Đổi biến';

  @override
  String get copyVariationPgn => 'Sao chép biến PGN';

  @override
  String get move => 'Nước cờ';

  @override
  String get variantLoss => 'Nước đi dẫn đến hết cờ';

  @override
  String get variantWin => 'Thắng theo luật biến thể';

  @override
  String get insufficientMaterial => 'Thiếu quân để chiếu hết';

  @override
  String get pawnMove => 'Tiến tốt';

  @override
  String get capture => 'Ăn quân';

  @override
  String get close => 'Đóng';

  @override
  String get winning => 'Đang thắng dần';

  @override
  String get losing => 'Đang thua dần';

  @override
  String get drawn => 'Hòa cờ';

  @override
  String get unknown => 'Không chắc';

  @override
  String get database => 'Cơ sở dữ liệu';

  @override
  String get whiteDrawBlack => 'Trắng / Hòa / Đen';

  @override
  String averageRatingX(String param) {
    return 'Hệ số bình quân: $param';
  }

  @override
  String get recentGames => 'Các ván cờ gần đây';

  @override
  String get topGames => 'Các ván đấu hàng đầu';

  @override
  String masterDbExplanation(String param1, String param2, String param3) {
    return 'Các ván đấu OTB của các kỳ thủ có hệ số Elo FIDE $param1+ từ năm $param2 đến $param3';
  }

  @override
  String get dtzWithRounding => 'DTZ50\" được làm tròn, dựa vào số nước đi quân cho tới nước ăn quân hoặc đi tiến tốt tiếp theo';

  @override
  String get noGameFound => 'Không tìm thấy ván nào';

  @override
  String get maxDepthReached => 'Đã đạt độ sâu tối đa!';

  @override
  String get maybeIncludeMoreGamesFromThePreferencesMenu => 'Bạn có muốn thêm nhiều ván đấu hơn từ mục lục?';

  @override
  String get openings => 'Các khai cuộc';

  @override
  String get openingExplorer => 'Khám phá khai cuộc';

  @override
  String get openingEndgameExplorer => 'Khám phá khai cuộc/tàn cuộc';

  @override
  String xOpeningExplorer(String param) {
    return 'Khám phá khai cuộc $param';
  }

  @override
  String get playFirstOpeningEndgameExplorerMove => 'Chơi nước khám phá khai cuộc/tàn cuộc đầu tiên';

  @override
  String get winPreventedBy50MoveRule => 'Chiến thắng bị ngăn cản bởi luật 50 nước';

  @override
  String get lossSavedBy50MoveRule => 'Ván đấu được cứu thua bởi luật 50 nước';

  @override
  String get winOr50MovesByPriorMistake => 'Giành chiến thắng hoặc 50 nước đi do sai lầm trước';

  @override
  String get lossOr50MovesByPriorMistake => 'Thua hoặc 50 lần nước đi do nhầm lẫn trước đó';

  @override
  String get unknownDueToRounding => 'Thắng/thua chỉ được đảm bảo nếu dòng tàn cuộc được đề xuất đã được tuân theo kể từ lần ăn quân hoặc tiến tốt cuối cùng, do có thể làm tròn các giá trị DTZ trong sách tàn cuộc Syzygy.';

  @override
  String get allSet => 'Đã xong!';

  @override
  String get importPgn => 'Nhập PGN';

  @override
  String get delete => 'Xóa';

  @override
  String get deleteThisImportedGame => 'Bạn muốn xóa ván đấu đã nhập?';

  @override
  String get replayMode => 'Chế độ xem lại';

  @override
  String get realtimeReplay => 'Thời gian thực';

  @override
  String get byCPL => 'Theo phần trăm mất tốt (CPL)';

  @override
  String get openStudy => 'Mở nghiên cứu';

  @override
  String get enable => 'Bật';

  @override
  String get bestMoveArrow => 'Mũi tên chỉ nước đi tốt nhất';

  @override
  String get showVariationArrows => 'Hiển thị mũi tên biến';

  @override
  String get evaluationGauge => 'Thang đo lợi thế';

  @override
  String get multipleLines => 'Số hàng phân tích';

  @override
  String get cpus => 'CPU';

  @override
  String get memory => 'Bộ nhớ';

  @override
  String get infiniteAnalysis => 'Phân tích vô hạn';

  @override
  String get removesTheDepthLimit => 'Bỏ giới hạn độ sâu và giữ máy tính của bạn mượt hơn';

  @override
  String get engineManager => 'Quản lý động cơ';

  @override
  String get blunder => 'Sai lầm nghiêm trọng';

  @override
  String get mistake => 'Sai lầm';

  @override
  String get inaccuracy => 'Không chính xác';

  @override
  String get moveTimes => 'Thời gian nghĩ nước đi';

  @override
  String get flipBoard => 'Quay bàn cờ';

  @override
  String get threefoldRepetition => 'Lặp cờ 3 lần';

  @override
  String get claimADraw => 'Nhận hòa';

  @override
  String get offerDraw => 'Đề nghị hoà';

  @override
  String get draw => 'Hoà';

  @override
  String get drawByMutualAgreement => 'Hòa theo thỏa thuận hai bên';

  @override
  String get fiftyMovesWithoutProgress => '50 nước không có tiến triển';

  @override
  String get currentGames => 'Các ván cờ đang diễn ra';

  @override
  String get viewInFullSize => 'Xem ở kích thước đầy đủ';

  @override
  String get logOut => 'Đăng xuất';

  @override
  String get signIn => 'Đăng nhập';

  @override
  String get rememberMe => 'Duy trì trạng thái đăng nhập';

  @override
  String get youNeedAnAccountToDoThat => 'Bạn cần một tài khoản để thực hiện điều đó';

  @override
  String get signUp => 'Đăng ký';

  @override
  String get computersAreNotAllowedToPlay => 'Máy tính và người chơi có máy tính hỗ trợ không được phép chơi. Vui lòng không nhận hỗ trợ từ các công cụ cờ vua, cơ sở dữ liệu, hoặc từ những người chơi khác khi chơi. Cũng lưu ý rằng việc lập nhiều tài khoản không được khuyến khích và bạn có thể bị cấm vĩnh viễn nếu tạo quá nhiều tài khoản.';

  @override
  String get games => 'Số ván cờ';

  @override
  String get forum => 'Diễn đàn';

  @override
  String xPostedInForumY(String param1, String param2) {
    return '$param1 đã viết trong diễn đàn $param2';
  }

  @override
  String get latestForumPosts => 'Bài đăng diễn đàn mới nhất';

  @override
  String get players => 'Kỳ thủ';

  @override
  String get friends => 'Bạn bè';

  @override
  String get discussions => 'Trò chuyện';

  @override
  String get today => 'Hôm nay';

  @override
  String get yesterday => 'Hôm qua';

  @override
  String get minutesPerSide => 'Số phút cho mỗi bên';

  @override
  String get variant => 'Biến thể';

  @override
  String get variants => 'Biến thể';

  @override
  String get timeControl => 'Kiểu thời gian';

  @override
  String get realTime => 'Thời gian thực';

  @override
  String get correspondence => 'Cờ qua thư';

  @override
  String get daysPerTurn => 'Số ngày cho mỗi nước đi';

  @override
  String get oneDay => 'Một ngày';

  @override
  String get time => 'Thời gian';

  @override
  String get rating => 'Hệ số';

  @override
  String get ratingStats => 'Các thống kê hệ số';

  @override
  String get username => 'Tên đăng nhập';

  @override
  String get usernameOrEmail => 'Tên đăng nhập hoặc email';

  @override
  String get changeUsername => 'Thay đổi tên đăng nhập';

  @override
  String get changeUsernameNotSame => 'Bạn chỉ có thể thay đổi cách viết hoa/thường. Ví dụ \"johndoe\" thành \"JohnDoe\".';

  @override
  String get changeUsernameDescription => 'Thay đổi tên người dùng của bạn. Điều này chỉ có thể thực hiện một lần và bạn chỉ được thay đổi cách viết hoa/viết thường các chữ trong tên người dùng của bạn.';

  @override
  String get signupUsernameHint => 'Hãy đảm bảo chọn tên người dùng thân thiện với mọi người. Bạn sẽ không thể thay đổi nó và bất kỳ tài khoản nào có tên người dùng không phù hợp sẽ bị đóng!';

  @override
  String get signupEmailHint => 'Chúng tôi chỉ sử dụng nó cho việc khôi phục mật khẩu.';

  @override
  String get password => 'Mật khẩu';

  @override
  String get changePassword => 'Thay đổi mật khẩu';

  @override
  String get changeEmail => 'Thay đổi thư điện tử';

  @override
  String get email => 'Thư điện tử';

  @override
  String get passwordReset => 'Đặt lại mật khẩu';

  @override
  String get forgotPassword => 'Quên mật khẩu?';

  @override
  String get error_weakPassword => 'Mật khẩu này quá phổ biến và quá dễ đoán.';

  @override
  String get error_namePassword => 'Vui lòng không sử dụng tên đăng nhập làm mật khẩu.';

  @override
  String get blankedPassword => 'Bạn đã sử dụng cùng một mật khẩu trên một trang web khác và trang web đó đã bị xâm nhập. Để đảm bảo an toàn cho tài khoản Lichess của bạn, chúng tôi cần bạn đặt mật khẩu mới. Cảm ơn vì bạn đã thông cảm.';

  @override
  String get youAreLeavingLichess => 'Bạn đang thoát Lichess';

  @override
  String get neverTypeYourPassword => 'Không bao giờ nhập mật khẩu Lichess của bạn trên bất kì trang web nào khác!';

  @override
  String proceedToX(String param) {
    return 'Chuyển tới trang $param';
  }

  @override
  String get passwordSuggestion => 'Đừng sử dụng mật khẩu được đề xuất bởi người khác. Họ có thể dùng nó để đánh cắp tài khoản của bạn.';

  @override
  String get emailSuggestion => 'Đừng đặt địa chỉ email được gợi ý bởi người khác. Họ có thể dùng nó để đánh cắp tài khoản của bạn.';

  @override
  String get emailConfirmHelp => 'Hỗ trợ việc xác nhận qua email';

  @override
  String get emailConfirmNotReceived => 'Không nhận được email xác nhận sau khi đăng ký?';

  @override
  String get whatSignupUsername => 'Tên người dùng mà bạn đã đăng ký là gì?';

  @override
  String usernameNotFound(String param) {
    return 'Chúng tôi không tìm thấy bất kì người dùng nào có tên: $param.';
  }

  @override
  String get usernameCanBeUsedForNewAccount => 'Bạn có thể dùng tên này để tạo một tài khoản mới';

  @override
  String emailSent(String param) {
    return 'Chúng tôi đã gửi cho $param một email.';
  }

  @override
  String get emailCanTakeSomeTime => 'Có thể sẽ mất một lúc để nhận được.';

  @override
  String get refreshInboxAfterFiveMinutes => 'Đợi 5 phút sau đó làm mới hộp thư đến trong email.';

  @override
  String get checkSpamFolder => 'Ngoài ra hãy kiểm tra hộp thư rác, nó có thể ở trong đó. Nếu có, hãy đánh dấu nó không phải là rác.';

  @override
  String get emailForSignupHelp => 'Nếu vẫn không nhận được, hãy gửi cho chúng tôi email này:';

  @override
  String copyTextToEmail(String param) {
    return 'Sao chép và dán đoạn văn bản phía trên và gửi nó tới $param';
  }

  @override
  String get waitForSignupHelp => 'Chúng tôi sẽ sớm liên lạc lại với bạn để giúp bạn hoàn tất việc đăng ký.';

  @override
  String accountConfirmed(String param) {
    return 'Đã xác nhận người dùng $param thành công.';
  }

  @override
  String accountCanLogin(String param) {
    return 'Bạn đã có thể đăng nhập ngay bây giờ tại $param.';
  }

  @override
  String get accountConfirmationEmailNotNeeded => 'Bạn không cần xác nhận email.';

  @override
  String accountClosed(String param) {
    return 'Tài khoản $param đã bị đóng.';
  }

  @override
  String accountRegisteredWithoutEmail(String param) {
    return 'Tài khoản $param đã đăng ký mà không cần có email.';
  }

  @override
  String get rank => 'Hạng';

  @override
  String rankX(String param) {
    return 'Hạng: $param';
  }

  @override
  String get gamesPlayed => 'Số ván đã chơi';

  @override
  String get cancel => 'Hủy';

  @override
  String get whiteTimeOut => 'Trắng hết giờ';

  @override
  String get blackTimeOut => 'Đen hết giờ';

  @override
  String get drawOfferSent => 'Đã gửi đề nghị hòa';

  @override
  String get drawOfferAccepted => 'Đề nghị hoà được chấp nhận';

  @override
  String get drawOfferCanceled => 'Đã hủy bỏ đề nghị hoà';

  @override
  String get whiteOffersDraw => 'Trắng đề nghị hòa';

  @override
  String get blackOffersDraw => 'Đen đề nghị hòa';

  @override
  String get whiteDeclinesDraw => 'Trắng từ chối hòa';

  @override
  String get blackDeclinesDraw => 'Đen từ chối hòa';

  @override
  String get yourOpponentOffersADraw => 'Đối thủ xin hoà';

  @override
  String get accept => 'Chấp nhận';

  @override
  String get decline => 'Từ chối';

  @override
  String get playingRightNow => 'Đang diễn ra';

  @override
  String get eventInProgress => 'Đang diễn ra';

  @override
  String get finished => 'Hoàn thành';

  @override
  String get abortGame => 'Hủy ván cờ';

  @override
  String get gameAborted => 'Ván cờ đã bị hủy bỏ';

  @override
  String get standard => 'Tiêu chuẩn';

  @override
  String get customPosition => 'Thế trận tùy chỉnh';

  @override
  String get unlimited => 'Vô hạn';

  @override
  String get mode => 'Chế độ';

  @override
  String get casual => 'Không xếp hạng';

  @override
  String get rated => 'Có xếp hạng';

  @override
  String get casualTournament => 'Không xếp hạng';

  @override
  String get ratedTournament => 'Có xếp hạng';

  @override
  String get thisGameIsRated => 'Ván cờ này có xếp hạng';

  @override
  String get rematch => 'Tái đấu';

  @override
  String get rematchOfferSent => 'Yêu cầu tái đấu đã được gửi';

  @override
  String get rematchOfferAccepted => 'Yêu cầu đấu lại được chấp nhận';

  @override
  String get rematchOfferCanceled => 'Yêu cầu tái đấu đã bị hủy';

  @override
  String get rematchOfferDeclined => 'Từ chối đấu lại';

  @override
  String get cancelRematchOffer => 'Hủy yêu cầu đấu lại';

  @override
  String get viewRematch => 'Xem trận tái đấu';

  @override
  String get confirmMove => 'Xác nhận nước đi';

  @override
  String get play => 'Chơi';

  @override
  String get inbox => 'Hộp thư';

  @override
  String get chatRoom => 'Phòng trò chuyện';

  @override
  String get loginToChat => 'Đăng nhập để trò chuyện';

  @override
  String get youHaveBeenTimedOut => 'Bạn đã bị tạm dừng trò chuyện.';

  @override
  String get spectatorRoom => 'Phòng khán giả';

  @override
  String get composeMessage => 'Soạn tin nhắn';

  @override
  String get subject => 'Tiêu đề';

  @override
  String get send => 'Gửi';

  @override
  String get incrementInSeconds => 'Gia tăng theo giây';

  @override
  String get freeOnlineChess => 'Chơi Cờ Vua Trực Tuyến Miễn Phí';

  @override
  String get exportGames => 'Xuất các ván cờ';

  @override
  String get ratingRange => 'Phạm vi hệ số';

  @override
  String get thisAccountViolatedTos => 'Tài khoản này đã vi phạm Điều khoản Dịch vụ của Lichess';

  @override
  String get openingExplorerAndTablebase => 'Sách khai cuộc & tàn cuộc';

  @override
  String get takeback => 'Đi lại';

  @override
  String get proposeATakeback => 'Đề nghị lùi một nước';

  @override
  String get takebackPropositionSent => 'Đã gửi đề nghị lùi một nước';

  @override
  String get takebackPropositionDeclined => 'Đề nghị lùi một nước bị từ chối';

  @override
  String get takebackPropositionAccepted => 'Đề nghị lùi một nước được chấp thuận';

  @override
  String get takebackPropositionCanceled => 'Hủy đề nghị lùi một nước';

  @override
  String get yourOpponentProposesATakeback => 'Đối thủ của bạn đề nghị lùi một nước';

  @override
  String get bookmarkThisGame => 'Đánh dấu ván này';

  @override
  String get tournament => 'Giải đấu';

  @override
  String get tournaments => 'Các giải đấu';

  @override
  String get tournamentPoints => 'Điểm giải đấu';

  @override
  String get viewTournament => 'Xem giải đấu';

  @override
  String get backToTournament => 'Quay lại giải đấu';

  @override
  String get noDrawBeforeSwissLimit => 'Trong giải đấu hệ Thụy Sĩ, ván cờ dưới 30 nước đi không thể hòa.';

  @override
  String get thematic => 'Theo thế cờ';

  @override
  String yourPerfRatingIsProvisional(String param) {
    return 'Hệ số $param của bạn là tạm thời';
  }

  @override
  String yourPerfRatingIsTooHigh(String param1, String param2) {
    return 'Hệ số $param1 của bạn ($param2) quá cao';
  }

  @override
  String yourTopWeeklyPerfRatingIsTooHigh(String param1, String param2) {
    return 'Hệ số $param1 hàng tuần của bạn ($param2) quá cao';
  }

  @override
  String yourPerfRatingIsTooLow(String param1, String param2) {
    return 'Hệ số Elo $param1 ($param2) của bạn quá thấp';
  }

  @override
  String ratedMoreThanInPerf(String param1, String param2) {
    return 'Hệ số $param2 ≥ $param1';
  }

  @override
  String ratedLessThanInPerf(String param1, String param2) {
    return 'Hệ số $param2 tuần trước ≤ $param1';
  }

  @override
  String mustBeInTeam(String param) {
    return 'Phải ở trong đội $param';
  }

  @override
  String youAreNotInTeam(String param) {
    return 'Bạn không ở trong đội $param';
  }

  @override
  String get backToGame => 'Quay lại ván đấu';

  @override
  String get siteDescription => 'Chơi cờ vua trực tuyến miễn phí. Chơi cờ vua với giao diện đẹp. Không cần đăng ký, không có quảng cáo, không yêu cầu plugin. Chơi cờ vua với máy tính, bạn bè hoặc đối thủ ngẫu nhiên.';

  @override
  String xJoinedTeamY(String param1, String param2) {
    return '$param1 đã gia nhập đội $param2';
  }

  @override
  String xCreatedTeamY(String param1, String param2) {
    return '$param1 đã tạo đội $param2';
  }

  @override
  String get startedStreaming => 'đã bắt đầu phát trực tiếp';

  @override
  String xStartedStreaming(String param) {
    return '$param đã bắt đầu phát trực tiếp';
  }

  @override
  String get averageElo => 'Hệ số bình quân';

  @override
  String get location => 'Vị trí';

  @override
  String get filterGames => 'Lọc ván cờ';

  @override
  String get reset => 'Đặt lại từ đầu';

  @override
  String get apply => 'Áp dụng';

  @override
  String get save => 'Lưu';

  @override
  String get leaderboard => 'Bảng dẫn đầu';

  @override
  String get screenshotCurrentPosition => 'Chụp màn hình thế cờ hiện tại';

  @override
  String get gameAsGIF => 'Ván cờ dưới dạng ảnh GIF';

  @override
  String get pasteTheFenStringHere => 'Dán chuỗi FEN vào đây';

  @override
  String get pasteThePgnStringHere => 'Dán chuỗi PGN vào đây';

  @override
  String get orUploadPgnFile => 'Hoặc tải lên tệp PGN';

  @override
  String get fromPosition => 'Từ thế cờ';

  @override
  String get continueFromHere => 'Tiếp tục từ đây';

  @override
  String get toStudy => 'Nghiên cứu';

  @override
  String get importGame => 'Nhập ván cờ';

  @override
  String get importGameExplanation => 'Dán PGN của ván đấu để xem lại trên trình duyệt, phân tích bằng máy tính, \ntrò chuyện trong ván đấu và có một URL có thể chia sẻ công khai.';

  @override
  String get importGameCaveat => 'Các biến sẽ bị xóa. Để giữ chúng, hãy nhập PGN thông qua một nghiên cứu.';

  @override
  String get importGameDataPrivacyWarning => 'Ai cũng có thể truy cập PGN này. Để nhập ván cờ một cách riêng tư, hãy sử dụng nghiên cứu.';

  @override
  String get thisIsAChessCaptcha => 'Đây là mã CAPTCHA cờ vua.';

  @override
  String get clickOnTheBoardToMakeYourMove => 'Nhấn vào bàn cờ để di chuyển và chứng minh bạn là con người.';

  @override
  String get captcha_fail => 'Hãy giải mã captcha cờ vua.';

  @override
  String get notACheckmate => 'Không phải là một nước chiếu hết';

  @override
  String get whiteCheckmatesInOneMove => 'Trắng chiếu hết trong một nước đi';

  @override
  String get blackCheckmatesInOneMove => 'Đen chiếu hết trong một nước đi';

  @override
  String get retry => 'Thử lại';

  @override
  String get reconnecting => 'Đang kết nối lại';

  @override
  String get noNetwork => 'Ngoại tuyến';

  @override
  String get favoriteOpponents => 'Đối thủ yêu thích';

  @override
  String get follow => 'Theo dõi';

  @override
  String get following => 'Đang theo dõi';

  @override
  String get unfollow => 'Bỏ theo dõi';

  @override
  String followX(String param) {
    return 'Theo dõi $param';
  }

  @override
  String unfollowX(String param) {
    return 'Bỏ theo dõi $param';
  }

  @override
  String get block => 'Chặn';

  @override
  String get blocked => 'Đã chặn';

  @override
  String get unblock => 'Bỏ chặn';

  @override
  String get followsYou => 'Theo dõi bạn';

  @override
  String xStartedFollowingY(String param1, String param2) {
    return '$param1 đã bắt đầu theo dõi $param2';
  }

  @override
  String get more => 'Xem thêm';

  @override
  String get memberSince => 'Thành viên từ';

  @override
  String lastSeenActive(String param) {
    return 'Hoạt động $param';
  }

  @override
  String get player => 'Người chơi';

  @override
  String get list => 'Danh sách';

  @override
  String get graph => 'Biểu đồ';

  @override
  String get required => 'Bắt buộc.';

  @override
  String get openTournaments => 'Các giải đấu mở';

  @override
  String get duration => 'Thời lượng';

  @override
  String get winner => 'Người chiến thắng';

  @override
  String get standing => 'Thứ hạng';

  @override
  String get createANewTournament => 'Tạo giải đấu mới';

  @override
  String get tournamentCalendar => 'Lịch giải đấu';

  @override
  String get conditionOfEntry => 'Điều kiện tham gia:';

  @override
  String get advancedSettings => 'Cài đặt nâng cao';

  @override
  String get safeTournamentName => 'Hãy chọn tên chuẩn mực cho giải đấu.';

  @override
  String get inappropriateNameWarning => 'Một hành động dù chỉ một chút không thích hợp, tài khoản của bạn có thể bị khoá.';

  @override
  String get emptyTournamentName => 'Hãy để trống để lấy tên theo tên một kỳ thủ cờ vua nổi tiếng.';

  @override
  String get makePrivateTournament => 'Đặt giải đấu ở chế độ riêng tư và giới hạn tham gia bởi mật khẩu';

  @override
  String get join => 'Tham gia';

  @override
  String get withdraw => 'Rút lui';

  @override
  String get points => 'Điểm';

  @override
  String get wins => 'Thắng';

  @override
  String get losses => 'Thua';

  @override
  String get createdBy => 'Tạo bởi';

  @override
  String get tournamentIsStarting => 'Giải đấu đang diễn ra';

  @override
  String get tournamentPairingsAreNowClosed => 'Đã đóng việc sắp xếp cặp đấu.';

  @override
  String standByX(String param) {
    return '$param chờ nhé, đang xếp cặp đấu, chuẩn bị sẵn sàng!';
  }

  @override
  String get pause => 'Tạm rút';

  @override
  String get resume => 'Tiếp tục';

  @override
  String get youArePlaying => 'Bạn đã vào ván!';

  @override
  String get winRate => 'Tỉ lệ thắng';

  @override
  String get berserkRate => 'Tỉ lệ Berserk';

  @override
  String get performance => 'Hiệu suất';

  @override
  String get tournamentComplete => 'Kết thúc giải đấu';

  @override
  String get movesPlayed => 'Số nước đi';

  @override
  String get whiteWins => 'Tỉ lệ trắng thắng';

  @override
  String get blackWins => 'Tỉ lệ đen thắng';

  @override
  String get drawRate => 'Tỉ lệ hòa';

  @override
  String get draws => 'Hoà';

  @override
  String nextXTournament(String param) {
    return 'Giải đấu tiếp theo $param:';
  }

  @override
  String get averageOpponent => 'Hệ số Elo đối thủ trung bình';

  @override
  String get boardEditor => 'Chỉnh sửa bàn cờ';

  @override
  String get setTheBoard => 'Thiết lập bàn cờ';

  @override
  String get popularOpenings => 'Khai cuộc phổ biến';

  @override
  String get endgamePositions => 'Các thế cờ trong tàn cuộc';

  @override
  String chess960StartPosition(String param) {
    return 'Ván đấu Chess960 bắt đầu bằng thế cờ: $param';
  }

  @override
  String get startPosition => 'Thế cờ ban đầu';

  @override
  String get clearBoard => 'Xóa bàn cờ';

  @override
  String get loadPosition => 'Tải thế cờ';

  @override
  String get isPrivate => 'Riêng tư';

  @override
  String reportXToModerators(String param) {
    return 'Báo cáo $param tới các điều hành viên';
  }

  @override
  String profileCompletion(String param) {
    return 'Hoàn thành hồ sơ: $param';
  }

  @override
  String xRating(String param) {
    return 'Hệ số $param';
  }

  @override
  String get ifNoneLeaveEmpty => 'Nếu không có, hãy để trống';

  @override
  String get profile => 'Hồ sơ';

  @override
  String get editProfile => 'Chỉnh sửa thông tin cá nhân';

  @override
  String get realName => 'Tên thật';

  @override
  String get setFlair => 'Đặt biểu tượng của bạn';

  @override
  String get flair => 'Biểu tượng';

  @override
  String get youCanHideFlair => 'Có một cài đặt để ẩn tất cả biểu tượng của người dùng trên toàn bộ trang web.';

  @override
  String get biography => 'Tiểu sử';

  @override
  String get countryRegion => 'Quốc gia hoặc khu vực';

  @override
  String get thankYou => 'Lời cảm ơn!';

  @override
  String get socialMediaLinks => 'Các liên kết mạng xã hội';

  @override
  String get oneUrlPerLine => 'Một URL/Link mỗi dòng.';

  @override
  String get inlineNotation => 'Ký hiệu bên trong bàn cờ';

  @override
  String get makeAStudy => 'Để bảo vệ và chia sẻ an toàn, hãy xem xét thực hiện một nghiên cứu.';

  @override
  String get clearSavedMoves => 'Xóa nước cờ';

  @override
  String get previouslyOnLichessTV => 'Ván trước được lên Lichess TV';

  @override
  String get onlinePlayers => 'Các kỳ thủ trực tuyến';

  @override
  String get activePlayers => 'Các kỳ thủ tích cực';

  @override
  String get bewareTheGameIsRatedButHasNoClock => 'Lưu ý, ván cờ có xếp hạng nhưng không tính thời gian!';

  @override
  String get success => 'Thành công';

  @override
  String get automaticallyProceedToNextGameAfterMoving => 'Tự động chuyển đến ván tiếp theo sau khi thực hiện nước đi';

  @override
  String get autoSwitch => 'Tự động chuyển';

  @override
  String get puzzles => 'Câu đố';

  @override
  String get onlineBots => 'Các Bot trực tuyến';

  @override
  String get name => 'Tên';

  @override
  String get description => 'Mô tả';

  @override
  String get descPrivate => 'Mô tả riêng tư';

  @override
  String get descPrivateHelp => 'Mô tả mà chỉ thành viên đội nhìn thấy. Nếu được đặt, sẽ thay thế mô tả thường cho thành viên đội.';

  @override
  String get no => 'Không';

  @override
  String get yes => 'Có';

  @override
  String get help => 'Hỗ trợ:';

  @override
  String get createANewTopic => 'Tạo một chủ đề mới';

  @override
  String get topics => 'Các chủ đề';

  @override
  String get posts => 'Số bài đăng';

  @override
  String get lastPost => 'Bài đăng gần đây nhất';

  @override
  String get views => 'Lượt xem';

  @override
  String get replies => 'Số bình luận';

  @override
  String get replyToThisTopic => 'Bình luận chủ đề này';

  @override
  String get reply => 'Trả lời';

  @override
  String get message => 'Tin nhắn';

  @override
  String get createTheTopic => 'Tạo chủ đề';

  @override
  String get reportAUser => 'Báo cáo một kỳ thủ';

  @override
  String get user => 'Kỳ thủ';

  @override
  String get reason => 'Lý do';

  @override
  String get whatIsIheMatter => 'Có chuyện gì vậy?';

  @override
  String get cheat => 'Gian lận';

  @override
  String get troll => 'Chọc tức, chơi khăm';

  @override
  String get other => 'Khác';

  @override
  String get reportDescriptionHelp => 'Dán đường dẫn đến (các) ván cờ và giải thích về vấn đề của kỳ thủ này. Đừng chỉ nói \"họ gian lận\" mà hãy miêu tả chi tiết nhất có thể. Vấn đề sẽ được giải quyết nhanh hơn nếu bạn viết bằng tiếng Anh.';

  @override
  String get error_provideOneCheatedGameLink => 'Hãy cung cấp ít nhất một đường dẫn đến ván cờ bị gian lận.';

  @override
  String by(String param) {
    return 'bởi $param';
  }

  @override
  String importedByX(String param) {
    return 'Được nhập bởi $param';
  }

  @override
  String get thisTopicIsNowClosed => 'Chủ đề này hiện đã bị đóng.';

  @override
  String get blog => 'Blog';

  @override
  String get notes => 'Ghi chú';

  @override
  String get typePrivateNotesHere => 'Nhập ghi chú cá nhân ở đây';

  @override
  String get writeAPrivateNoteAboutThisUser => 'Viết một ghi chú riêng về người dùng này';

  @override
  String get noNoteYet => 'Chưa có ghi chú nào';

  @override
  String get invalidUsernameOrPassword => 'Tên tài khoản hoặc mật khẩu đăng nhập không đúng';

  @override
  String get incorrectPassword => 'Mật khẩu sai';

  @override
  String get invalidAuthenticationCode => 'Mã xác thực không hợp lệ';

  @override
  String get emailMeALink => 'Gửi cho tôi một liên kết trong Email';

  @override
  String get currentPassword => 'Nhập mật khẩu hiện tại';

  @override
  String get newPassword => 'Nhập mật khẩu mới';

  @override
  String get newPasswordAgain => 'Nhập (lại) mật khẩu mới';

  @override
  String get newPasswordsDontMatch => 'Mật khẩu mới không khớp';

  @override
  String get newPasswordStrength => 'Độ mạnh của mật khẩu';

  @override
  String get clockInitialTime => 'Thời gian ban đầu';

  @override
  String get clockIncrement => 'Thời gian gia tăng';

  @override
  String get privacy => 'Bảo mật';

  @override
  String get privacyPolicy => 'Chính sách bảo mật';

  @override
  String get letOtherPlayersFollowYou => 'Cho phép người khác theo dõi bạn';

  @override
  String get letOtherPlayersChallengeYou => 'Cho phép người khác thách đấu bạn';

  @override
  String get letOtherPlayersInviteYouToStudy => 'Cho phép người khác mời bạn tham gia nghiên cứu';

  @override
  String get sound => 'Âm thanh';

  @override
  String get none => 'Không có';

  @override
  String get fast => 'Nhanh';

  @override
  String get normal => 'Bình thường';

  @override
  String get slow => 'Chậm';

  @override
  String get insideTheBoard => 'Bên trong bàn cờ';

  @override
  String get outsideTheBoard => 'Bên ngoài bàn cờ';

  @override
  String get allSquaresOfTheBoard => 'Tất cả ô vuông của bàn cờ';

  @override
  String get onSlowGames => 'Chỉ khi chơi cờ chậm';

  @override
  String get always => 'Luôn luôn';

  @override
  String get never => 'Không bao giờ';

  @override
  String xCompetesInY(String param1, String param2) {
    return '$param1 thi đấu ở $param2';
  }

  @override
  String get victory => 'Chiến thắng';

  @override
  String get defeat => 'Thua';

  @override
  String victoryVsYInZ(String param1, String param2, String param3) {
    return '$param1 $param2 trong $param3';
  }

  @override
  String defeatVsYInZ(String param1, String param2, String param3) {
    return '$param1 $param2 trong $param3';
  }

  @override
  String drawVsYInZ(String param1, String param2, String param3) {
    return '$param1 $param2 trong $param3';
  }

  @override
  String get timeline => 'Dòng thời gian';

  @override
  String get starting => 'Bắt đầu đấu:';

  @override
  String get allInformationIsPublicAndOptional => 'Tất cả thông tin đều công khai và không bắt buộc.';

  @override
  String get biographyDescription => 'Giới thiệu gì đó về bạn như sở thích, bạn thích gì ở cờ, khai cuộc yêu thích, ván cờ yêu thích, thần tượng, ...';

  @override
  String get listBlockedPlayers => 'Danh sách các kỳ thủ mà bạn đang chặn';

  @override
  String get human => 'Con người';

  @override
  String get computer => 'Máy tính';

  @override
  String get side => 'Bên';

  @override
  String get clock => 'Đồng hồ';

  @override
  String get opponent => 'Đối thủ';

  @override
  String get learnMenu => 'Học';

  @override
  String get studyMenu => 'Nghiên cứu';

  @override
  String get practice => 'Luyện tập';

  @override
  String get community => 'Cộng đồng';

  @override
  String get tools => 'Công cụ';

  @override
  String get increment => 'Gia tăng';

  @override
  String get error_unknown => 'Giá trị không hợp lệ';

  @override
  String get error_required => 'Mục này là bắt buộc';

  @override
  String get error_email => 'Địa chỉ email này không đúng';

  @override
  String get error_email_acceptable => 'Địa chỉ email này không được chấp nhận. Vui lòng kiểm tra và thử lại.';

  @override
  String get error_email_unique => 'Địa chỉ email này không hợp lệ hoặc đã được dùng';

  @override
  String get error_email_different => 'Đây đã là địa chỉ email hiện tại của bạn';

  @override
  String error_minLength(String param) {
    return 'Phải dài ít nhất $param ký tự';
  }

  @override
  String error_maxLength(String param) {
    return 'Chỉ được dài tối đa $param ký tự';
  }

  @override
  String error_min(String param) {
    return 'Phải ≥ $param';
  }

  @override
  String error_max(String param) {
    return 'Phải ≤ $param';
  }

  @override
  String ifRatingIsPlusMinusX(String param) {
    return 'Nếu hệ số trong phạm vi ± $param';
  }

  @override
  String get ifRegistered => 'Chỉ người có tài khoản';

  @override
  String get onlyExistingConversations => 'Chỉ từ các cuộc trò chuyện hiện tại';

  @override
  String get onlyFriends => 'Chỉ bạn bè';

  @override
  String get menu => 'Mục lục';

  @override
  String get castling => 'Nhập thành';

  @override
  String get whiteCastlingKingside => 'Trắng O-O';

  @override
  String get blackCastlingKingside => 'Đen O-O';

  @override
  String tpTimeSpentPlaying(String param) {
    return 'Thời gian đã chơi: $param';
  }

  @override
  String get watchGames => 'Xem các ván đấu';

  @override
  String tpTimeSpentOnTV(String param) {
    return 'Thời gian được lên Lichess TV: $param';
  }

  @override
  String get watch => 'Xem';

  @override
  String get videoLibrary => 'Thư viện video';

  @override
  String get streamersMenu => 'Các Streamer';

  @override
  String get mobileApp => 'Ứng dụng Điện thoại';

  @override
  String get webmasters => 'Nhà phát triển web';

  @override
  String get about => 'Về chúng tôi';

  @override
  String aboutX(String param) {
    return 'Giới thiệu về $param';
  }

  @override
  String xIsAFreeYLibreOpenSourceChessServer(String param1, String param2) {
    return '$param1 là một máy chủ cờ vua miễn phí ($param2), có mã nguồn mở và không có quảng cáo.';
  }

  @override
  String get really => 'thật sự';

  @override
  String get contribute => 'Đóng góp';

  @override
  String get termsOfService => 'Điều khoản Dịch vụ';

  @override
  String get sourceCode => 'Mã Nguồn';

  @override
  String get simultaneousExhibitions => 'Đấu cờ đồng loạt';

  @override
  String get host => 'Người chủ trì';

  @override
  String hostColorX(String param) {
    return 'Màu quân của người chủ trì: $param';
  }

  @override
  String get yourPendingSimuls => 'Sự kiện đồng loạt đang chờ xử lý của bạn';

  @override
  String get createdSimuls => 'Sự kiện cờ đồng loạt mới tạo';

  @override
  String get hostANewSimul => 'Chủ trì một sự kiện cờ đồng loạt mới';

  @override
  String get signUpToHostOrJoinASimul => 'Đăng kí để tham gia hoặc chủ trì một sự kiện đồng loạt';

  @override
  String get noSimulFound => 'Không tìm thấy sự kiện cờ đồng loạt nào';

  @override
  String get noSimulExplanation => 'Sự kiện cờ đồng loạt này không tồn tại.';

  @override
  String get returnToSimulHomepage => 'Trở về trang chủ cờ đồng loạt';

  @override
  String get aboutSimul => 'Cờ đồng loạt gồm một người duy nhất chơi cùng lúc với nhiều người khác.';

  @override
  String get aboutSimulImage => 'Trong số 50 đối thủ, Fischer thắng 47, hoà 2 và thua 1.';

  @override
  String get aboutSimulRealLife => 'Ý tưởng được lấy từ những sự kiện có thật. Trong đời thực, một người chủ trì cờ đồng loạt sẽ di chuyển từ bàn này qua bàn khác và đánh một nước mỗi bàn.';

  @override
  String get aboutSimulRules => 'Khi cờ đồng loạt bắt đầu, mỗi người chơi sẽ bắt đầu ván cờ với người chủ trì. Cờ đồng loạt kết thúc khi tất cả các ván cờ hoàn tất.';

  @override
  String get aboutSimulSettings => 'Cờ đồng loạt luôn không tính xếp hạng. Việc tái đấu, đi lại hay cho thêm thời gian đều bị vô hiệu.';

  @override
  String get create => 'Tạo';

  @override
  String get whenCreateSimul => 'Khi bạn tạo một sự kiện cờ đồng loạt, bạn sẽ chơi với nhiều người cùng một lúc.';

  @override
  String get simulVariantsHint => 'Nếu bạn chọn nhiều biến thể, mỗi người chơi sẽ được lựa chọn chơi biến thể nào.';

  @override
  String get simulClockHint => 'Thiết lập Đồng hồ Fischer. Bạn càng chơi với nhiều người thì càng có thể cần nhiều thời gian.';

  @override
  String get simulAddExtraTime => 'Bạn có thể thêm thời gian ban đầu cho đồng hồ của mình để đấu cờ đồng loạt dễ hơn.';

  @override
  String get simulHostExtraTime => 'Thời gian thêm ban đầu cho người chủ trì';

  @override
  String get simulAddExtraTimePerPlayer => 'Thêm thời gian ban đầu vào đồng hồ của bạn cho mỗi người chơi tham gia sự kiện đồng loạt.';

  @override
  String get simulHostExtraTimePerPlayer => 'Thời gian thêm cho mỗi người tham gia';

  @override
  String get lichessTournaments => 'Các giải đấu của Lichess';

  @override
  String get tournamentFAQ => 'Các câu hỏi hay gặp về giải đấu Đấu trường';

  @override
  String get timeBeforeTournamentStarts => 'Thời gian trước khi giải đấu bắt đầu';

  @override
  String get averageCentipawnLoss => 'Tỉ lệ mất tốt trung bình (ACPL)';

  @override
  String get accuracy => 'Độ chính xác';

  @override
  String get keyboardShortcuts => 'Các phím tắt';

  @override
  String get keyMoveBackwardOrForward => 'tua lại/đi tới';

  @override
  String get keyGoToStartOrEnd => 'chuyển đến nước đi đầu/cuối';

  @override
  String get keyCycleSelectedVariation => 'Biến được chọn theo chu kỳ';

  @override
  String get keyShowOrHideComments => 'hiện/ẩn bình luận';

  @override
  String get keyEnterOrExitVariation => 'vào/thoát biến';

  @override
  String get keyRequestComputerAnalysis => 'Yêu cầu máy tính phân tích, Học từ sai lầm của bạn';

  @override
  String get keyNextLearnFromYourMistakes => 'Tiếp theo (Học từ sai lầm của bạn)';

  @override
  String get keyNextBlunder => 'Nước đi sai nghiêm trọng tiếp theo';

  @override
  String get keyNextMistake => 'Nước đi sai lầm tiếp theo';

  @override
  String get keyNextInaccuracy => 'Nước đi không chính xác tiếp theo';

  @override
  String get keyPreviousBranch => 'Nhánh trước';

  @override
  String get keyNextBranch => 'Nhánh tiếp theo';

  @override
  String get toggleVariationArrows => 'Đổi mũi tên của từng biến';

  @override
  String get cyclePreviousOrNextVariation => 'Chu kì của biến trước/tiếp theo';

  @override
  String get toggleGlyphAnnotations => 'Đổi chú thích nước cờ';

  @override
  String get togglePositionAnnotations => 'Chuyển đổi chú thích thế cờ';

  @override
  String get variationArrowsInfo => 'Mũi tên của biến cho phép bạn điều hướng mà không cần sử dụng danh sách nước đi.';

  @override
  String get playSelectedMove => 'chơi nước đi đã chọn';

  @override
  String get newTournament => 'Giải đấu mới';

  @override
  String get tournamentHomeTitle => 'Giải đấu cờ vua với nhiều thiết lập thời gian và biến thể phong phú';

  @override
  String get tournamentHomeDescription => 'Chơi các giải đấu cờ vua nhịp độ nhanh! Tham gia một giải đấu chính thức hoặc tự tạo giải đấu của bạn. Cờ Đạn, cờ Chớp, cờ Nhanh, cờ Chậm, Chess960, King of the Hill, Threecheck và nhiều lựa chọn khác cho niềm vui đánh cờ vô tận.';

  @override
  String get tournamentNotFound => 'Không tìm thấy giải đấu';

  @override
  String get tournamentDoesNotExist => 'Giải đấu này không tồn tại.';

  @override
  String get tournamentMayHaveBeenCanceled => 'Giải đấu có thể đã bị huỷ, nếu tất cả người chơi rời giải trước khi giải đấu bắt đầu.';

  @override
  String get returnToTournamentsHomepage => 'Trở về trang chủ các giải đấu';

  @override
  String weeklyPerfTypeRatingDistribution(String param) {
    return 'Phân bổ hệ số $param hàng tuần';
  }

  @override
  String yourPerfTypeRatingIsRating(String param1, String param2) {
    return 'Hệ số $param1 của bạn là $param2.';
  }

  @override
  String youAreBetterThanPercentOfPerfTypePlayers(String param1, String param2) {
    return 'Bạn giỏi hơn $param1 người chơi $param2.';
  }

  @override
  String userIsBetterThanPercentOfPerfTypePlayers(String param1, String param2, String param3) {
    return '$param1 giỏi hơn $param2 người chơi $param3.';
  }

  @override
  String betterThanPercentPlayers(String param1, String param2) {
    return 'Bạn giỏi hơn $param1 người chơi $param2';
  }

  @override
  String youDoNotHaveAnEstablishedPerfTypeRating(String param) {
    return 'Bạn chưa có hệ số $param được thiết lập.';
  }

  @override
  String get yourRating => 'Hệ số của bạn';

  @override
  String get cumulative => 'Giỏi hơn so với còn lại';

  @override
  String get glicko2Rating => 'Hệ số Glicko-2';

  @override
  String get checkYourEmail => 'Kiểm tra Email của bạn';

  @override
  String get weHaveSentYouAnEmailClickTheLink => 'Chúng tôi đã gửi cho bạn một email. Nhấn vào link trong Email để kích hoạt tài khoản của bạn.';

  @override
  String get ifYouDoNotSeeTheEmailCheckOtherPlaces => 'Nếu bạn không thấy ở trong email, kiểm tra lại ở các nơi khác có thể có, như thư mục rác, thư rác, mạng xã hội hay các thư mục khác.';

  @override
  String weHaveSentYouAnEmailTo(String param) {
    return 'Chúng tôi đã gửi một email đến $param. Nhấp vào liên kết trong email để đặt lại mật khẩu của bạn.';
  }

  @override
  String byRegisteringYouAgreeToBeBoundByOur(String param) {
    return 'Bằng cách đăng ký, bạn đồng ý tuân thủ $param của chúng tôi.';
  }

  @override
  String readAboutOur(String param) {
    return 'Đọc về $param của chúng tôi.';
  }

  @override
  String get networkLagBetweenYouAndLichess => 'Độ trễ mạng giữa bạn và Lichess';

  @override
  String get timeToProcessAMoveOnLichessServer => 'Thời gian để tiến hành một nước đi trên máy chủ Lichess';

  @override
  String get downloadAnnotated => 'Tải về kèm chú thích';

  @override
  String get downloadRaw => 'Tải về bản thô';

  @override
  String get downloadImported => 'Tải về tệp đã được nhập';

  @override
  String get crosstable => 'Tổng điểm đối đầu';

  @override
  String get youCanAlsoScrollOverTheBoardToMoveInTheGame => 'Bạn cũng có thể cuộn chuột trên bàn cờ để xem các nước đi của ván.';

  @override
  String get scrollOverComputerVariationsToPreviewThem => 'Cuộn qua các biến máy tính để xem trước chúng.';

  @override
  String get analysisShapesHowTo => 'Nhấn Shift+click hoặc nhấp chuột phải để vẽ vòng tròn và mũi tên trên bàn cờ.';

  @override
  String get letOtherPlayersMessageYou => 'Cho phép người chơi khác gửi tin nhắn cho bạn';

  @override
  String get receiveForumNotifications => 'Nhận thông báo khi được đề cập trong diễn đàn';

  @override
  String get shareYourInsightsData => 'Chia sẻ dữ liệu chi tiết về cờ vua của bạn';

  @override
  String get withNobody => 'Không ai cả';

  @override
  String get withFriends => 'Với bạn bè';

  @override
  String get withEverybody => 'Với mọi người';

  @override
  String get kidMode => 'Chế độ trẻ em';

  @override
  String get kidModeIsEnabled => 'Chế độ trẻ em đã được bật.';

  @override
  String get kidModeExplanation => 'Điều này là để an toàn. Trong chế độ trẻ em, tất cả mọi giao tiếp trên trang web đều bị tắt. Kích hoạt điều này cho con của bạn và học viên trong lớp để bảo vệ chúng khỏi những người dùng khác trên Internet.';

  @override
  String inKidModeTheLichessLogoGetsIconX(String param) {
    return 'Trong chế độ trẻ em, biểu tượng Lichess có một biểu tượng $param, từ đó bạn biết con bạn được an toàn.';
  }

  @override
  String get askYourChessTeacherAboutLiftingKidMode => 'Tài khoản của bạn đang bị quản lý. Hỏi giáo viên dạy cờ của bạn để lấy lại quyền điều khiển.';

  @override
  String get enableKidMode => 'Kích hoạt chế độ Trẻ em';

  @override
  String get disableKidMode => 'Tắt chế độ Trẻ em';

  @override
  String get security => 'Bảo mật';

  @override
  String get sessions => 'Phiên';

  @override
  String get revokeAllSessions => 'xóa toàn bộ phiên đăng nhập';

  @override
  String get playChessEverywhere => 'Chơi cờ ở bất cứ đâu';

  @override
  String get asFreeAsLichess => 'Miễn phí như Lichess';

  @override
  String get builtForTheLoveOfChessNotMoney => 'Được xây dựng trên nền tảng tình yêu dành cho cờ vua, không phải vì tiền bạc';

  @override
  String get everybodyGetsAllFeaturesForFree => 'Mọi người đều được sử dụng tất cả các tính năng hoàn toàn miễn phí';

  @override
  String get zeroAdvertisement => 'Không có quảng cáo';

  @override
  String get fullFeatured => 'Toàn bộ chức năng hiện có';

  @override
  String get phoneAndTablet => 'Điện thoại và máy tính bảng';

  @override
  String get bulletBlitzClassical => 'Cờ đạn, cờ chớp, cờ nhanh, cờ chậm';

  @override
  String get correspondenceChess => 'Cờ qua thư';

  @override
  String get onlineAndOfflinePlay => 'Chơi trực tuyến và ngoại tuyến';

  @override
  String get viewTheSolution => 'Xem đáp án';

  @override
  String get followAndChallengeFriends => 'Theo dõi và thách đấu bạn bè';

  @override
  String get gameAnalysis => 'Phân tích ván cờ';

  @override
  String xHostsY(String param1, String param2) {
    return '$param1 đã chủ trì $param2';
  }

  @override
  String xJoinsY(String param1, String param2) {
    return '$param1 gia nhập $param2';
  }

  @override
  String xLikesY(String param1, String param2) {
    return '$param1 thích $param2';
  }

  @override
  String get quickPairing => 'Xếp cặp nhanh';

  @override
  String get lobby => 'Phòng chờ';

  @override
  String get anonymous => 'Ẩn danh';

  @override
  String yourScore(String param) {
    return 'Điểm của bạn: $param';
  }

  @override
  String get language => 'Ngôn ngữ';

  @override
  String get background => 'Nền';

  @override
  String get light => 'Sáng';

  @override
  String get dark => 'Tối';

  @override
  String get transparent => 'Trong suốt';

  @override
  String get deviceTheme => 'Giao diện thiết bị';

  @override
  String get backgroundImageUrl => 'URL ảnh nền:';

  @override
  String get board => 'Bàn cờ';

  @override
  String get size => 'Kích cỡ';

  @override
  String get opacity => 'Độ trong suốt';

  @override
  String get brightness => 'Độ sáng';

  @override
  String get hue => 'Màu gốc';

  @override
  String get boardReset => 'Đặt lại màu về mặc định';

  @override
  String get pieceSet => 'Bộ cờ';

  @override
  String get embedInYourWebsite => 'Nhúng vào trang web của bạn';

  @override
  String get usernameAlreadyUsed => 'Tên người dùng này đã được sử dụng, hãy chọn tên khác.';

  @override
  String get usernamePrefixInvalid => 'Tên người dùng phải bắt đầu với một chữ cái.';

  @override
  String get usernameSuffixInvalid => 'Tên người dùng phải kết thúc với một chữ cái hoặc một số.';

  @override
  String get usernameCharsInvalid => 'Tên người dùng chỉ được chứa chữ cái, số, dấu gạch nối và dấu gạch dưới. Dấu gạch dưới và dấu gạch nối không được liên tiếp nhau.';

  @override
  String get usernameUnacceptable => 'Tên người dùng này không được chấp nhận.';

  @override
  String get playChessInStyle => 'Chơi cờ vua theo phong cách';

  @override
  String get chessBasics => 'Cờ cơ bản';

  @override
  String get coaches => 'Huấn luyện viên';

  @override
  String get invalidPgn => 'PGN không hợp lệ';

  @override
  String get invalidFen => 'FEN không hợp lệ';

  @override
  String get custom => 'Tuỳ chỉnh';

  @override
  String get notifications => 'Thông báo';

  @override
  String notificationsX(String param1) {
    return 'Số thông báo: $param1';
  }

  @override
  String perfRatingX(String param) {
    return 'Hệ số: $param';
  }

  @override
  String get practiceWithComputer => 'Luyện tập với máy tính';

  @override
  String anotherWasX(String param) {
    return 'Nước đi khác là $param';
  }

  @override
  String bestWasX(String param) {
    return 'Nước đi tốt nhất là $param';
  }

  @override
  String get youBrowsedAway => 'Bạn đã duyệt xa';

  @override
  String get resumePractice => 'Tiếp tục luyện';

  @override
  String get drawByFiftyMoves => 'Ván đấu được xử hòa theo luật 50 nước.';

  @override
  String get theGameIsADraw => 'Ván cờ kết thúc hòa.';

  @override
  String get computerThinking => 'Máy tính đang nghĩ ...';

  @override
  String get seeBestMove => 'Xem nước đi tốt nhất';

  @override
  String get hideBestMove => 'Ẩn nước đi tốt nhất';

  @override
  String get getAHint => 'Xem gợi ý';

  @override
  String get evaluatingYourMove => 'Đang đánh giá nước đi của bạn ...';

  @override
  String get whiteWinsGame => 'Trắng thắng';

  @override
  String get blackWinsGame => 'Đen thắng';

  @override
  String get learnFromYourMistakes => 'Học từ sai lầm của bạn';

  @override
  String get learnFromThisMistake => 'Học từ sai lầm này';

  @override
  String get skipThisMove => 'Bỏ qua nước này';

  @override
  String get next => 'Tiếp';

  @override
  String xWasPlayed(String param) {
    return 'Đã chơi $param';
  }

  @override
  String get findBetterMoveForWhite => 'Tìm nước đi tốt hơn cho trắng';

  @override
  String get findBetterMoveForBlack => 'Tìm nước đi tốt hơn cho đen';

  @override
  String get resumeLearning => 'Tiếp tục học';

  @override
  String get youCanDoBetter => 'Bạn có thể làm tốt hơn';

  @override
  String get tryAnotherMoveForWhite => 'Tìm nước đi khác cho trắng';

  @override
  String get tryAnotherMoveForBlack => 'Tìm nước đi khác cho đen';

  @override
  String get solution => 'Đáp án';

  @override
  String get waitingForAnalysis => 'Đang chờ phân tích';

  @override
  String get noMistakesFoundForWhite => 'Bên trắng không mắc sai lầm nào';

  @override
  String get noMistakesFoundForBlack => 'Bên đen không mắc sai lầm nào';

  @override
  String get doneReviewingWhiteMistakes => 'Đã hoàn tất phân tích sai lầm của bên trắng';

  @override
  String get doneReviewingBlackMistakes => 'Đã hoàn tất phân tích sai lầm của bên đen';

  @override
  String get doItAgain => 'Thử lại một lần nữa';

  @override
  String get reviewWhiteMistakes => 'Đánh giá lỗi bên trắng';

  @override
  String get reviewBlackMistakes => 'Đánh giá lỗi bên đen';

  @override
  String get advantage => 'Lợi thế';

  @override
  String get opening => 'Khai cuộc';

  @override
  String get middlegame => 'Trung cuộc';

  @override
  String get endgame => 'Tàn cuộc';

  @override
  String get conditionalPremoves => 'Nước đi trước có điều kiện';

  @override
  String get addCurrentVariation => 'Thêm biến hiện tại';

  @override
  String get playVariationToCreateConditionalPremoves => 'Chơi một biến để tạo ra nước đi trước có điều kiện';

  @override
  String get noConditionalPremoves => 'Không có nước đi trước có điều kiện nào';

  @override
  String playX(String param) {
    return 'Chơi $param';
  }

  @override
  String get showUnreadLichessMessage => 'Bạn đã nhận được một tin nhắn riêng từ Lichess.';

  @override
  String get clickHereToReadIt => 'Nhấn vào đây để đọc nó';

  @override
  String get sorry => 'Rất tiếc :(';

  @override
  String get weHadToTimeYouOutForAWhile => 'Chúng tôi phải ngừng bạn lại một thời gian.';

  @override
  String get why => 'Tại sao?';

  @override
  String get pleasantChessExperience => 'Mục tiêu của chúng tôi là cung cấp trải nghiệm chơi cờ vui vẻ cho mọi người.';

  @override
  String get goodPractice => 'Để đạt được mục đích, chúng tôi phải chắc chắn rằng mọi người phải tuân thủ tốt.';

  @override
  String get potentialProblem => 'Khi có vấn đề phát sinh, chúng tôi sẽ hiển thị thông báo này.';

  @override
  String get howToAvoidThis => 'Làm thế nào để tránh điều này?';

  @override
  String get playEveryGame => 'Chơi tất cả các ván mà bạn đã tham gia.';

  @override
  String get tryToWin => 'Cố gắng thắng (hoặc ít nhất hòa) mỗi ván mà bạn chơi.';

  @override
  String get resignLostGames => 'Chịu thua những ván chắc chắn thua (đừng để đồng hồ chạy đến hết giờ).';

  @override
  String get temporaryInconvenience => 'Chúng tôi rất tiếc vì những bất tiện tạm thời này,';

  @override
  String get wishYouGreatGames => 'và chúc bạn có những ván cờ tuyệt vời trên lichess.org.';

  @override
  String get thankYouForReading => 'Cảm ơn bạn vì đã đọc!';

  @override
  String get lifetimeScore => 'Tổng điểm đối đầu';

  @override
  String get currentMatchScore => 'Tỷ số của lần đối đầu hiện tại';

  @override
  String get agreementAssistance => 'Tôi đồng ý rằng, tôi sẽ không nhận sự trợ giúp trong lúc chơi (từ máy tính, sách, các cơ sở dữ liệu hoặc từ người khác).';

  @override
  String get agreementNice => 'Tôi đồng ý rằng, tôi sẽ luôn luôn tôn trọng người chơi khác.';

  @override
  String agreementMultipleAccounts(String param) {
    return 'Tôi đồng ý rằng, tôi sẽ không tạo nhiều tài khoản (trừ các lý do nêu trong $param).';
  }

  @override
  String get agreementPolicy => 'Tôi đồng ý rằng, tôi sẽ luôn tuân thủ các chính sách của Lichess.';

  @override
  String get searchOrStartNewDiscussion => 'Tìm hoặc bắt đầu một cuộc trò chuyện';

  @override
  String get edit => 'Chỉnh sửa';

  @override
  String get bullet => 'Cờ đạn';

  @override
  String get blitz => 'Cờ chớp';

  @override
  String get rapid => 'Cờ nhanh';

  @override
  String get classical => 'Cờ chậm';

  @override
  String get ultraBulletDesc => 'Các ván cờ cực nhanh: ít hơn 30 giây';

  @override
  String get bulletDesc => 'Các ván cờ rất nhanh: ít hơn 3 phút';

  @override
  String get blitzDesc => 'Các ván cờ nhanh: 3 đến 8 phút';

  @override
  String get rapidDesc => 'Cờ nhanh: 8 tới 25 phút';

  @override
  String get classicalDesc => 'Cờ chậm: Nhiều hơn hoặc bằng 25 phút';

  @override
  String get correspondenceDesc => 'Cờ qua thư: Một hoặc vài ngày cho mỗi nước';

  @override
  String get puzzleDesc => 'Huấn luyện viên cờ thế';

  @override
  String get important => 'Chú ý';

  @override
  String yourQuestionMayHaveBeenAnswered(String param1) {
    return 'Vấn đề của bạn có thể đã được giải đáp $param1';
  }

  @override
  String get inTheFAQ => 'tại các câu hỏi thường gặp';

  @override
  String toReportSomeoneForCheatingOrBadBehavior(String param1) {
    return 'Để báo cáo một người dùng vì gian lận hoặc hành vi xấu, $param1';
  }

  @override
  String get useTheReportForm => 'dùng biểu mẫu báo cáo';

  @override
  String toRequestSupport(String param1) {
    return 'Để yêu cầu trợ giúp, $param1';
  }

  @override
  String get tryTheContactPage => 'hãy thử trang trợ giúp';

  @override
  String makeSureToRead(String param1) {
    return 'Hãy chắc rằng bạn đã đọc $param1';
  }

  @override
  String get theForumEtiquette => 'quy tắc diễn đàn';

  @override
  String get thisTopicIsArchived => 'Chủ đề này đã được lưu trữ và không thể trả lời được nữa.';

  @override
  String joinTheTeamXToPost(String param1) {
    return 'Gia nhập $param1 để đăng trong diễn đàn này';
  }

  @override
  String teamNamedX(String param1) {
    return 'Đội $param1';
  }

  @override
  String get youCannotPostYetPlaySomeGames => 'Bạn chưa thể đăng bài lên diễn đàn bây giờ. Hãy chơi vài ván đã!';

  @override
  String get subscribe => 'Đăng ký theo dõi';

  @override
  String get unsubscribe => 'Hủy đăng ký theo dõi';

  @override
  String mentionedYouInX(String param1) {
    return 'đã nhắc đến bạn trong \"$param1\".';
  }

  @override
  String xMentionedYouInY(String param1, String param2) {
    return '$param1 đã nhắc đến bạn trong \"$param2\".';
  }

  @override
  String invitedYouToX(String param1) {
    return 'đã mời bạn tham gia \"$param1\".';
  }

  @override
  String xInvitedYouToY(String param1, String param2) {
    return '$param1 đã mời bạn tham gia \"$param2\".';
  }

  @override
  String get youAreNowPartOfTeam => 'Bây giờ bạn là một phần của đội.';

  @override
  String youHaveJoinedTeamX(String param1) {
    return 'Bạn đã tham gia \"$param1\".';
  }

  @override
  String get someoneYouReportedWasBanned => 'Ai đó mà bạn báo cáo đã bị cấm';

  @override
  String get congratsYouWon => 'Chúc mừng, bạn đã giành chiến thắng!';

  @override
  String gameVsX(String param1) {
    return 'Ván đấu với $param1';
  }

  @override
  String resVsX(String param1, String param2) {
    return '$param1 với $param2';
  }

  @override
  String get lostAgainstTOSViolator => 'Bạn đã mất điểm hệ số vào người vi phạm Điều khoản Dịch vụ của Lichess';

  @override
  String refundXpointsTimeControlY(String param1, String param2) {
    return 'Hoàn lại: $param1 điểm hệ số $param2.';
  }

  @override
  String get timeAlmostUp => 'Thời gian sắp hết!';

  @override
  String get clickToRevealEmailAddress => '[Nhấp để tiết lộ địa chỉ email]';

  @override
  String get download => 'Tải về';

  @override
  String get coachManager => 'Quản lý huấn luyện viên';

  @override
  String get streamerManager => 'Quản lý trang Streamer';

  @override
  String get cancelTournament => 'Hủy giải đấu';

  @override
  String get tournDescription => 'Mô tả giải đấu';

  @override
  String get tournDescriptionHelp => 'Có điều gì đặc biệt bạn muốn nói với những người tham gia không? Cố gắng viết ngắn gọn. Các liên kết cấu trúc Markdown có sẵn: [Văn bản](https://url)';

  @override
  String get ratedFormHelp => 'Các ván đấu có xếp hạng và ảnh hưởng đến hệ số của người chơi';

  @override
  String get onlyMembersOfTeam => 'Chỉ thành viên của đội';

  @override
  String get noRestriction => 'Không giới hạn';

  @override
  String get minimumRatedGames => 'Số ván đã xếp hạng tối thiểu';

  @override
  String get minimumRating => 'Hệ số tối thiểu';

  @override
  String get maximumWeeklyRating => 'Hệ số cao nhất trong tuần';

  @override
  String positionInputHelp(String param) {
    return 'Dán một FEN hợp lệ để bắt đầu tất cả ván đấu bằng một thế cờ nhất định đó.\nNó chỉ dùng được cho cờ vua tiêu chuẩn, không được với các biến thể.\nBạn có thể dùng $param để tạo ra một FEN rồi dán ở đây.\nBỏ trống để bắt đầu tất cả ván đấu bằng thế trận ban đầu bình thường.';
  }

  @override
  String get cancelSimul => 'Hủy sự kiện cờ đồng loạt';

  @override
  String get simulHostcolor => 'Màu quân của người chủ trì cho mỗi ván đấu';

  @override
  String get estimatedStart => 'Thời gian bắt đầu dự kiến';

  @override
  String simulFeatured(String param) {
    return 'Hiển thị trên $param';
  }

  @override
  String simulFeaturedHelp(String param) {
    return 'Hiển thị sự kiện cờ đồng loạt của bạn trên $param. Không áp dụng cho các sự kiện riêng tư.';
  }

  @override
  String get simulDescription => 'Mô tả sự kiện cờ đồng loạt';

  @override
  String get simulDescriptionHelp => 'Bạn có muốn nói điều gì với những người tham gia không?';

  @override
  String markdownAvailable(String param) {
    return '$param khả dụng cho những cấu trúc nâng cao hơn.';
  }

  @override
  String get embedsAvailable => 'Dán URL ván đấu hoặc URL chương nghiên cứu để nhúng.';

  @override
  String get inYourLocalTimezone => 'Tại múi giờ địa phương của bạn';

  @override
  String get tournChat => 'Trò chuyện trong giải đấu';

  @override
  String get noChat => 'Không trò chuyện';

  @override
  String get onlyTeamLeaders => 'Chỉ các chỉ huy';

  @override
  String get onlyTeamMembers => 'Chỉ thành viên đội';

  @override
  String get navigateMoveTree => 'Điều hướng tìm nước đi';

  @override
  String get mouseTricks => 'Mẹo sử dụng chuột';

  @override
  String get toggleLocalAnalysis => 'Bật/Tắt máy tính phân tích';

  @override
  String get toggleAllAnalysis => 'Bật/Tắt toàn bộ máy tính phân tích';

  @override
  String get playComputerMove => 'Chơi nước máy tính tốt nhất';

  @override
  String get analysisOptions => 'Tùy chọn phân tích';

  @override
  String get focusChat => 'Tiêu điểm trò chuyện';

  @override
  String get showHelpDialog => 'Hiển thị thông điệp trợ giúp này';

  @override
  String get reopenYourAccount => 'Mở lại tài khoản';

  @override
  String get closedAccountChangedMind => 'Nếu bạn đóng tài khoản, song thay đổi ý định, bạn có đúng một cơ hội để mở lại tài khoản.';

  @override
  String get onlyWorksOnce => 'Chỉ làm được một lần.';

  @override
  String get cantDoThisTwice => 'Nếu bạn đóng tài khoản lần thứ hai, tài khoản sẽ không thể lấy lại được nữa.';

  @override
  String get emailAssociatedToaccount => 'Địa chỉ email liên kết với tài khoản này';

  @override
  String get sentEmailWithLink => 'Chúng tôi vừa gửi bạn một email với một đường dẫn.';

  @override
  String get tournamentEntryCode => 'Mã tham gia giải đấu';

  @override
  String get hangOn => 'Từ đã!';

  @override
  String gameInProgress(String param) {
    return 'Bạn đang có ván đấu với $param.';
  }

  @override
  String get abortTheGame => 'Hủy ván đấu';

  @override
  String get resignTheGame => 'Chịu thua';

  @override
  String get youCantStartNewGame => 'Bạn không thể chơi ván mới cho đến khi xong ván này.';

  @override
  String get since => 'Từ';

  @override
  String get until => 'Cho tới';

  @override
  String get lichessDbExplanation => 'Các ván đấu có xếp hạng được lấy từ tất cả các kỳ thủ trên Lichess';

  @override
  String get switchSides => 'Đổi bên';

  @override
  String get closingAccountWithdrawAppeal => 'Việc đóng tài khoản sẽ rút lại kháng cáo của bạn';

  @override
  String get ourEventTips => 'Lời khuyên của chúng tôi để tổ chức các sự kiện';

  @override
  String get instructions => 'Hướng dẫn';

  @override
  String get showMeEverything => 'Cho tôi xem mọi thứ nào';

  @override
  String get lichessPatronInfo => 'Lichess là một tổ chức phi lợi nhuận và là phần mềm hoàn toàn miễn phí/mã nguồn mở.\nMọi chi phí vận hành, phát triển, và nội dung được tài trợ bởi những đóng góp của người dùng.';

  @override
  String get nothingToSeeHere => 'Không có gì để xem ở đây vào lúc này.';

  @override
  String opponentLeftCounter(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Đối thủ đã rời khỏi ván cờ. Bạn có thể tuyên bố thắng cuộc trong $count giây.',
    );
    return '$_temp0';
  }

  @override
  String mateInXHalfMoves(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Chiếu hết trong $count nước',
    );
    return '$_temp0';
  }

  @override
  String nbBlunders(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count sai lầm nghiêm trọng',
    );
    return '$_temp0';
  }

  @override
  String nbMistakes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count sai lầm',
    );
    return '$_temp0';
  }

  @override
  String nbInaccuracies(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count không chính xác',
    );
    return '$_temp0';
  }

  @override
  String nbPlayers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count kỳ thủ',
    );
    return '$_temp0';
  }

  @override
  String nbGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ván cờ',
    );
    return '$_temp0';
  }

  @override
  String ratingXOverYGames(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Hệ số $count sau $param2 ván',
    );
    return '$_temp0';
  }

  @override
  String nbBookmarks(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count đánh dấu',
    );
    return '$_temp0';
  }

  @override
  String nbDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ngày',
    );
    return '$_temp0';
  }

  @override
  String nbHours(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count giờ',
    );
    return '$_temp0';
  }

  @override
  String nbMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count phút',
    );
    return '$_temp0';
  }

  @override
  String rankIsUpdatedEveryNbMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Thứ hạng được cập nhật mỗi $count phút',
    );
    return '$_temp0';
  }

  @override
  String nbPuzzles(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count cấu đố',
    );
    return '$_temp0';
  }

  @override
  String nbGamesWithYou(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ván cờ với bạn',
    );
    return '$_temp0';
  }

  @override
  String nbRated(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ván xếp hạng',
    );
    return '$_temp0';
  }

  @override
  String nbWins(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count thắng',
    );
    return '$_temp0';
  }

  @override
  String nbLosses(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count thua',
    );
    return '$_temp0';
  }

  @override
  String nbDraws(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count hòa',
    );
    return '$_temp0';
  }

  @override
  String nbPlaying(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ván đang chơi',
    );
    return '$_temp0';
  }

  @override
  String giveNbSeconds(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Cho thêm $count giây',
    );
    return '$_temp0';
  }

  @override
  String nbTournamentPoints(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count điểm giải đấu',
    );
    return '$_temp0';
  }

  @override
  String nbStudies(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count nghiên cứu',
    );
    return '$_temp0';
  }

  @override
  String nbSimuls(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Sự Kiện Cờ Đồng Loạt',
    );
    return '$_temp0';
  }

  @override
  String moreThanNbRatedGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '≥ $count ván xếp hạng',
    );
    return '$_temp0';
  }

  @override
  String moreThanNbPerfRatedGames(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Đã chơi ≥ $count ván $param2 xếp hạng',
    );
    return '$_temp0';
  }

  @override
  String needNbMorePerfGames(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Bạn cần chơi thêm $count ván $param2 xếp hạng',
    );
    return '$_temp0';
  }

  @override
  String needNbMoreGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Bạn cần chơi thêm $count ván xếp hạng',
    );
    return '$_temp0';
  }

  @override
  String nbImportedGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ván cờ đã nhập',
    );
    return '$_temp0';
  }

  @override
  String nbFriendsOnline(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count bạn trực tuyến',
    );
    return '$_temp0';
  }

  @override
  String nbFollowers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count người theo dõi',
    );
    return '$_temp0';
  }

  @override
  String nbFollowing(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Đang theo dõi $count người',
    );
    return '$_temp0';
  }

  @override
  String lessThanNbMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Ít hơn $count phút',
    );
    return '$_temp0';
  }

  @override
  String nbGamesInPlay(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count trận đang chơi',
    );
    return '$_temp0';
  }

  @override
  String maximumNbCharacters(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Tối đa: $count ký tự.',
    );
    return '$_temp0';
  }

  @override
  String blocks(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Đang chặn $count thành viên',
    );
    return '$_temp0';
  }

  @override
  String nbForumPosts(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Bài Viết Diễn Đàn',
    );
    return '$_temp0';
  }

  @override
  String nbPerfTypePlayersThisWeek(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count người chơi $param2 tuần này.',
    );
    return '$_temp0';
  }

  @override
  String availableInNbLanguages(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Hỗ trợ $count ngôn ngữ!',
    );
    return '$_temp0';
  }

  @override
  String nbSecondsToPlayTheFirstMove(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count giây còn lại để đi nước đầu tiên',
    );
    return '$_temp0';
  }

  @override
  String nbSeconds(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count giây',
    );
    return '$_temp0';
  }

  @override
  String andSaveNbPremoveLines(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'và lưu $count nước đi trước',
    );
    return '$_temp0';
  }

  @override
  String get stormMoveToStart => 'Đi quân để bắt đầu';

  @override
  String get stormYouPlayTheWhitePiecesInAllPuzzles => 'Bạn cầm quân trắng ở tất cả các câu đố';

  @override
  String get stormYouPlayTheBlackPiecesInAllPuzzles => 'Bạn cầm quân đen ở tất cả các câu đố';

  @override
  String get stormPuzzlesSolved => 'câu đố đã giải';

  @override
  String get stormNewDailyHighscore => 'Điểm cao hàng ngày mới!';

  @override
  String get stormNewWeeklyHighscore => 'Điểm cao hàng tuần mới!';

  @override
  String get stormNewMonthlyHighscore => 'Điểm cao hàng tháng mới!';

  @override
  String get stormNewAllTimeHighscore => 'Điểm cao mới!';

  @override
  String stormPreviousHighscoreWasX(String param) {
    return 'Điểm cao trước đây là $param';
  }

  @override
  String get stormPlayAgain => 'Chơi lại';

  @override
  String stormHighscoreX(String param) {
    return 'Điểm cao: $param';
  }

  @override
  String get stormScore => 'Điểm';

  @override
  String get stormMoves => 'Các nước đi';

  @override
  String get stormAccuracy => 'Độ chính xác';

  @override
  String get stormCombo => 'Chuỗi';

  @override
  String get stormTime => 'Thời gian';

  @override
  String get stormTimePerMove => 'Thời gian trên mỗi nước đi';

  @override
  String get stormHighestSolved => 'Câu giải được khó nhất';

  @override
  String get stormPuzzlesPlayed => 'Các thế cờ đã chơi';

  @override
  String get stormNewRun => 'Chạy lượt mới (phím nhanh: Dấu cách)';

  @override
  String get stormEndRun => 'Kết thúc (phím nhanh: Enter)';

  @override
  String get stormHighscores => 'Điểm cao';

  @override
  String get stormViewBestRuns => 'Xem các lần chạy tốt nhất';

  @override
  String get stormBestRunOfDay => 'Lần chạy tốt nhất của ngày';

  @override
  String get stormRuns => 'Số lần chạy';

  @override
  String get stormGetReady => 'Chuẩn bị!';

  @override
  String get stormWaitingForMorePlayers => 'Đang đợi thêm người chơi tham gia...';

  @override
  String get stormRaceComplete => 'Cuộc đua kết thúc!';

  @override
  String get stormSpectating => 'Đang xem';

  @override
  String get stormJoinTheRace => 'Tham gia cuộc đua!';

  @override
  String get stormStartTheRace => 'Bắt đầu cuộc đua';

  @override
  String stormYourRankX(String param) {
    return 'Thứ hạng của bạn: $param';
  }

  @override
  String get stormWaitForRematch => 'Đang đợi đấu lại';

  @override
  String get stormNextRace => 'Cuộc đua kế tiếp';

  @override
  String get stormJoinRematch => 'Tham gia đấu lại';

  @override
  String get stormWaitingToStart => 'Đang đợi bắt đầu';

  @override
  String get stormCreateNewGame => 'Tạo ván đấu mới';

  @override
  String get stormJoinPublicRace => 'Tham gia một cuộc đua công khai';

  @override
  String get stormRaceYourFriends => 'Đua với bạn bè của bạn';

  @override
  String get stormSkip => 'bỏ qua';

  @override
  String get stormSkipHelp => 'Bạn có thể bỏ qua một nước đi mỗi ván chơi:';

  @override
  String get stormSkipExplanation => 'Bỏ qua nước đi này để giữ chuỗi của bạn! Chỉ dùng được một lần mỗi cuộc đua.';

  @override
  String get stormFailedPuzzles => 'Các thế cờ đã giải sai';

  @override
  String get stormSlowPuzzles => 'Các thế cờ làm chậm';

  @override
  String get stormSkippedPuzzle => 'Câu đố đã bỏ qua';

  @override
  String get stormThisWeek => 'Tuần này';

  @override
  String get stormThisMonth => 'Tháng này';

  @override
  String get stormAllTime => 'Trước tới nay';

  @override
  String get stormClickToReload => 'Nhấn để tải lại';

  @override
  String get stormThisRunHasExpired => 'Lượt đua này đã quá hạn!';

  @override
  String get stormThisRunWasOpenedInAnotherTab => 'Lượt đua này đang được mở trong một tab khác!';

  @override
  String stormXRuns(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count lần chơi',
    );
    return '$_temp0';
  }

  @override
  String stormPlayedNbRunsOfPuzzleStorm(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Đã chơi $count lượt $param2',
    );
    return '$_temp0';
  }

  @override
  String get streamerLichessStreamers => 'Các Streamer của Lichess';

  @override
  String get studyShareAndExport => 'Chia sẻ & xuất';

  @override
  String get studyStart => 'Bắt đầu';
}
