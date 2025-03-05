// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'l10n.dart';

// ignore_for_file: type=lint

/// The translations for Indonesian (`id`).
class AppLocalizationsId extends AppLocalizations {
  AppLocalizationsId([String locale = 'id']) : super(locale);

  @override
  String get mobileAllGames => 'Semua permainan';

  @override
  String get mobileAreYouSure => 'Apa kamu yakin?';

  @override
  String get mobileCancelTakebackOffer => 'Cancel takeback offer';

  @override
  String get mobileClearButton => 'Clear';

  @override
  String get mobileCorrespondenceClearSavedMove => 'Clear saved move';

  @override
  String get mobileCustomGameJoinAGame => 'Join a game';

  @override
  String get mobileFeedbackButton => 'Ulas balik';

  @override
  String mobileGreeting(String param) {
    return 'Halo, $param';
  }

  @override
  String get mobileGreetingWithoutName => 'Halo';

  @override
  String get mobileHideVariation => 'Sembunyikan variasi';

  @override
  String get mobileHomeTab => 'Beranda';

  @override
  String get mobileLiveStreamers => 'Live streamers';

  @override
  String get mobileMustBeLoggedIn => 'You must be logged in to view this page.';

  @override
  String get mobileNoSearchResults => 'No results';

  @override
  String get mobileNotFollowingAnyUser => 'You are not following any user.';

  @override
  String get mobileOkButton => 'Oke';

  @override
  String mobilePlayersMatchingSearchTerm(String param) {
    return 'Players with \"$param\"';
  }

  @override
  String get mobilePrefMagnifyDraggedPiece => 'Magnify dragged piece';

  @override
  String get mobilePuzzleStormConfirmEndRun => 'Do you want to end this run?';

  @override
  String get mobilePuzzleStormFilterNothingToShow => 'Nothing to show, please change the filters';

  @override
  String get mobilePuzzleStormNothingToShow => 'Nothing to show. Play some runs of Puzzle Storm.';

  @override
  String get mobilePuzzleStormSubtitle => 'Solve as many puzzles as possible in 3 minutes.';

  @override
  String get mobilePuzzleStreakAbortWarning => 'You will lose your current streak and your score will be saved.';

  @override
  String get mobilePuzzleThemesSubtitle => 'Play puzzles from your favorite openings, or choose a theme.';

  @override
  String get mobilePuzzlesTab => 'Teka-teki';

  @override
  String get mobileRecentSearches => 'Recent searches';

  @override
  String get mobileSettingsHapticFeedback => 'Haptic feedback';

  @override
  String get mobileSettingsImmersiveMode => 'Immersive mode';

  @override
  String get mobileSettingsImmersiveModeSubtitle => 'Hide system UI while playing. Use this if you are bothered by the system\'s navigation gestures at the edges of the screen. Applies to game and Puzzle Storm screens.';

  @override
  String get mobileSettingsTab => 'Pengaturan';

  @override
  String get mobileShareGamePGN => 'Bagikan GPN';

  @override
  String get mobileShareGameURL => 'Bagikan URL permainan';

  @override
  String get mobileSharePositionAsFEN => 'Share position as FEN';

  @override
  String get mobileSharePuzzle => 'Bagikan teka-teki ini';

  @override
  String get mobileShowComments => 'Tampilkan komentar';

  @override
  String get mobileShowResult => 'Tampilkan hasil';

  @override
  String get mobileShowVariations => 'Tampilkan variasi';

  @override
  String get mobileSomethingWentWrong => 'Something went wrong.';

  @override
  String get mobileSystemColors => 'System colors';

  @override
  String get mobileTheme => 'Theme';

  @override
  String get mobileToolsTab => 'Tools';

  @override
  String get mobileWaitingForOpponentToJoin => 'Waiting for opponent to join...';

  @override
  String get mobileWatchTab => 'Tontonan';

  @override
  String get activityActivity => 'Aktivitas';

  @override
  String get activityHostedALiveStream => 'Host streaming langsung';

  @override
  String activityRankedInSwissTournament(String param1, String param2) {
    return 'Peringkat #$param1 di $param2';
  }

  @override
  String get activitySignedUp => 'Daftarkan untuk lichess.org';

  @override
  String activitySupportedNbMonths(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Mendukung lichess.org untuk $count bulan sebagai $param2',
    );
    return '$_temp0';
  }

  @override
  String activityPracticedNbPositions(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Dipraktekkan $count posisi di $param2',
    );
    return '$_temp0';
  }

  @override
  String activitySolvedNbPuzzles(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Sudah menyelesaikan $count teka-teki catur',
    );
    return '$_temp0';
  }

  @override
  String activityPlayedNbGames(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Telah memainkan $count $param2 permainan',
    );
    return '$_temp0';
  }

  @override
  String activityPostedNbMessages(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Diposting $count pesan masuk $param2',
    );
    return '$_temp0';
  }

  @override
  String activityPlayedNbMoves(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Dimainkan $count langkah',
    );
    return '$_temp0';
  }

  @override
  String activityInNbCorrespondenceGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'dalam $count permainan korespondensi',
    );
    return '$_temp0';
  }

  @override
  String activityCompletedNbGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Komplit $count permainan korespondensi',
    );
    return '$_temp0';
  }

  @override
  String activityCompletedNbVariantGames(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Completed $count $param2 correspondence games',
      one: 'Completed $count $param2 correspondence game',
    );
    return '$_temp0';
  }

  @override
  String activityFollowedNbPlayers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Mulai mengikuti $count pemain',
    );
    return '$_temp0';
  }

  @override
  String activityGainedNbFollowers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Memperoleh $count pengikut baru',
    );
    return '$_temp0';
  }

  @override
  String activityHostedNbSimuls(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Diselenggarakan $count pameran simultan',
    );
    return '$_temp0';
  }

  @override
  String activityJoinedNbSimuls(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Berpartisipasi dalam $count pameran simultan',
    );
    return '$_temp0';
  }

  @override
  String activityCreatedNbStudies(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Membuat $count studi baru',
    );
    return '$_temp0';
  }

  @override
  String activityCompetedInNbTournaments(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Sudah mengikuti $count turnamen',
    );
    return '$_temp0';
  }

  @override
  String activityRankedInTournament(int count, String param2, String param3, String param4) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Peringkat #$count (atas $param2%) dengan $param3 permainan di $param4',
    );
    return '$_temp0';
  }

  @override
  String activityCompetedInNbSwissTournaments(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Sudah mengikuti $count turnamen swiss',
    );
    return '$_temp0';
  }

  @override
  String activityJoinedNbTeams(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Bergabung $count tim',
    );
    return '$_temp0';
  }

  @override
  String get broadcastBroadcasts => 'Siaran';

  @override
  String get broadcastMyBroadcasts => 'My broadcasts';

  @override
  String get broadcastLiveBroadcasts => 'Siaran turnamen langsung';

  @override
  String get broadcastBroadcastCalendar => 'Broadcast calendar';

  @override
  String get broadcastNewBroadcast => 'Siaran langsung baru';

  @override
  String get broadcastSubscribedBroadcasts => 'Subscribed broadcasts';

  @override
  String get broadcastAboutBroadcasts => 'About broadcasts';

  @override
  String get broadcastHowToUseLichessBroadcasts => 'How to use Lichess Broadcasts.';

  @override
  String get broadcastTheNewRoundHelp => 'The new round will have the same members and contributors as the previous one.';

  @override
  String get broadcastAddRound => 'Tambakan ronde';

  @override
  String get broadcastOngoing => 'Sedang berlangsung';

  @override
  String get broadcastUpcoming => 'Akan datang';

  @override
  String get broadcastRoundName => 'Nama ronde';

  @override
  String get broadcastRoundNumber => 'Babak ronde';

  @override
  String get broadcastTournamentName => 'Nama turnamen';

  @override
  String get broadcastTournamentDescription => 'Deskripsi singkat turnamen';

  @override
  String get broadcastFullDescription => 'Keterangan acara secara penuh';

  @override
  String broadcastFullDescriptionHelp(String param1, String param2) {
    return 'Deskripsi panjang opsional dari siaran. $param1 tersedia. Panjangnya harus kurang dari $param2 karakter.';
  }

  @override
  String get broadcastSourceSingleUrl => 'PGN Source URL';

  @override
  String get broadcastSourceUrlHelp => 'URL yang akan di-polling oleh Lichess untuk mendapatkan pembaruan PGN. Itu harus dapat diakses publik dari Internet.';

  @override
  String get broadcastSourceGameIds => 'Up to 64 Lichess game IDs, separated by spaces.';

  @override
  String broadcastStartDateTimeZone(String param) {
    return 'Start date in the tournament local timezone: $param';
  }

  @override
  String get broadcastStartDateHelp => 'Opsional, jika Anda tahu kapan acara dimulai';

  @override
  String get broadcastCurrentGameUrl => 'Tautan permainan ini';

  @override
  String get broadcastDownloadAllRounds => 'Unduh semua ronde';

  @override
  String get broadcastResetRound => 'Atur ulang ronde ini';

  @override
  String get broadcastDeleteRound => 'Hapus ronde ini';

  @override
  String get broadcastDefinitivelyDeleteRound => 'Definitively delete the round and all its games.';

  @override
  String get broadcastDeleteAllGamesOfThisRound => 'Delete all games of this round. The source will need to be active in order to re-create them.';

  @override
  String get broadcastEditRoundStudy => 'Edit round study';

  @override
  String get broadcastDeleteTournament => 'Delete this tournament';

  @override
  String get broadcastDefinitivelyDeleteTournament => 'Definitively delete the entire tournament, all its rounds and all its games.';

  @override
  String get broadcastShowScores => 'Show players scores based on game results';

  @override
  String get broadcastReplacePlayerTags => 'Optional: replace player names, ratings and titles';

  @override
  String get broadcastFideFederations => 'FIDE federations';

  @override
  String get broadcastTop10Rating => 'Top 10 rating';

  @override
  String get broadcastFidePlayers => 'FIDE players';

  @override
  String get broadcastFidePlayerNotFound => 'FIDE player not found';

  @override
  String get broadcastFideProfile => 'FIDE profile';

  @override
  String get broadcastFederation => 'Federation';

  @override
  String get broadcastAgeThisYear => 'Age this year';

  @override
  String get broadcastUnrated => 'Unrated';

  @override
  String get broadcastRecentTournaments => 'Recent tournaments';

  @override
  String get broadcastOpenLichess => 'Open in Lichess';

  @override
  String get broadcastTeams => 'Teams';

  @override
  String get broadcastBoards => 'Boards';

  @override
  String get broadcastOverview => 'Overview';

  @override
  String get broadcastSubscribeTitle => 'Subscribe to be notified when each round starts. You can toggle bell or push notifications for broadcasts in your account preferences.';

  @override
  String get broadcastUploadImage => 'Upload tournament image';

  @override
  String get broadcastNoBoardsYet => 'No boards yet. These will appear once games are uploaded.';

  @override
  String broadcastBoardsCanBeLoaded(String param) {
    return 'Boards can be loaded with a source or via the $param';
  }

  @override
  String broadcastStartsAfter(String param) {
    return 'Starts after $param';
  }

  @override
  String get broadcastStartVerySoon => 'The broadcast will start very soon.';

  @override
  String get broadcastNotYetStarted => 'The broadcast has not yet started.';

  @override
  String get broadcastOfficialWebsite => 'Official website';

  @override
  String get broadcastStandings => 'Standings';

  @override
  String get broadcastOfficialStandings => 'Official Standings';

  @override
  String broadcastIframeHelp(String param) {
    return 'More options on the $param';
  }

  @override
  String get broadcastWebmastersPage => 'webmasters page';

  @override
  String broadcastPgnSourceHelp(String param) {
    return 'A public, real-time PGN source for this round. We also offer a $param for faster and more efficient synchronisation.';
  }

  @override
  String get broadcastEmbedThisBroadcast => 'Embed this broadcast in your website';

  @override
  String broadcastEmbedThisRound(String param) {
    return 'Embed $param in your website';
  }

  @override
  String get broadcastRatingDiff => 'Rating diff';

  @override
  String get broadcastGamesThisTournament => 'Games in this tournament';

  @override
  String get broadcastScore => 'Score';

  @override
  String get broadcastAllTeams => 'All teams';

  @override
  String get broadcastTournamentFormat => 'Tournament format';

  @override
  String get broadcastTournamentLocation => 'Tournament Location';

  @override
  String get broadcastTopPlayers => 'Top players';

  @override
  String get broadcastTimezone => 'Time zone';

  @override
  String get broadcastFideRatingCategory => 'FIDE rating category';

  @override
  String get broadcastOptionalDetails => 'Optional details';

  @override
  String get broadcastPastBroadcasts => 'Past broadcasts';

  @override
  String get broadcastAllBroadcastsByMonth => 'View all broadcasts by month';

  @override
  String get broadcastBackToLiveMove => 'Back to live move';

  @override
  String get broadcastSinceHideResults => 'Since you chose to hide the results, all the preview boards are empty to avoid spoilers.';

  @override
  String broadcastNbBroadcasts(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count broadcasts',
      one: '$count broadcast',
    );
    return '$_temp0';
  }

  @override
  String challengeChallengesX(String param1) {
    return 'Challenges: $param1';
  }

  @override
  String get challengeChallengeToPlay => 'Menantang ke permainan';

  @override
  String get challengeChallengeDeclined => 'Tantangan ditolak';

  @override
  String get challengeChallengeAccepted => 'Tantangan diterima!';

  @override
  String get challengeChallengeCanceled => 'Tantangan dibatalkan.';

  @override
  String get challengeRegisterToSendChallenges => 'Harap mendaftar untuk mengirim tantangan.';

  @override
  String challengeYouCannotChallengeX(String param) {
    return 'Anda tidak dapat menantang $param.';
  }

  @override
  String challengeXDoesNotAcceptChallenges(String param) {
    return '$param tidak menerima tantangan.';
  }

  @override
  String challengeYourXRatingIsTooFarFromY(String param1, String param2) {
    return 'Rating $param1 Anda terlalu jauh dari $param2.';
  }

  @override
  String challengeCannotChallengeDueToProvisionalXRating(String param) {
    return 'Dilarang menantang orang lain dikarenakan rating $param masih sementara.';
  }

  @override
  String challengeXOnlyAcceptsChallengesFromFriends(String param) {
    return '$param hanya menerima tantangan dari teman.';
  }

  @override
  String get challengeDeclineGeneric => 'Saya tidak menerima tantangan saat ini.';

  @override
  String get challengeDeclineLater => 'Bukan waktu yang bagus untukku, mungkin lain kali.';

  @override
  String get challengeDeclineTooFast => 'Kecepatan waktu terlalu cepat untukku, harap tantang lagi dengan waktu permainan yang lebih lambat.';

  @override
  String get challengeDeclineTooSlow => 'Kecepatan waktu terlalu lama untukku, harap tantang lagi dengan waktu permainan yang lebih cepat.';

  @override
  String get challengeDeclineTimeControl => 'Saya tidak menerima tantangan dengan waktu permainan seperti ini.';

  @override
  String get challengeDeclineRated => 'Tolong tantang aku dengan permainan di rating.';

  @override
  String get challengeDeclineCasual => 'Tolong tantang aku dengan permainan yang santai.';

  @override
  String get challengeDeclineStandard => 'Saya tidak menerima tantangan variasi sekarang.';

  @override
  String get challengeDeclineVariant => 'Saya tidak ingin bermain variasi ini sekarang.';

  @override
  String get challengeDeclineNoBot => 'Saya tidak menerima tantangan dari bot.';

  @override
  String get challengeDeclineOnlyBot => 'Saya hanya menerima tantangan dari bot.';

  @override
  String get challengeInviteLichessUser => 'Atau undang pengguna Lichess lain:';

  @override
  String get contactContact => 'Kontak';

  @override
  String get contactContactLichess => 'Kontak Lichess';

  @override
  String get patronDonate => 'Donasi';

  @override
  String get patronLichessPatron => 'Patron Lichess';

  @override
  String perfStatPerfStats(String param) {
    return '$param statistik';
  }

  @override
  String get perfStatViewTheGames => 'Lihat permainan';

  @override
  String get perfStatProvisional => 'penyisihan';

  @override
  String get perfStatNotEnoughRatedGames => 'Tidak mencukupi permainan dirating yang telah dimainkan untuk mendapatkan rating yang dapat diandalkan.';

  @override
  String perfStatProgressOverLastXGames(String param) {
    return 'Kemajuan dalam permainan $param terakhir kali:';
  }

  @override
  String perfStatRatingDeviation(String param) {
    return 'Selisih rating: $param.';
  }

  @override
  String perfStatRatingDeviationTooltip(String param1, String param2, String param3) {
    return 'Nilai rendah berarti ratingnya lebih stabil. Diatas $param1, ratingnya dipertimbangkan sebagai provisonal. Untuk dimasukkan dalam rangking, nilai ini harus berada dibawah $param2 (catur standar) atau $param3 (variasi).';
  }

  @override
  String get perfStatTotalGames => 'Total permainan';

  @override
  String get perfStatRatedGames => 'Permainan di-rating';

  @override
  String get perfStatTournamentGames => 'Permainan turnamen';

  @override
  String get perfStatBerserkedGames => 'Permainan saat mengamuk';

  @override
  String get perfStatTimeSpentPlaying => 'Waktu bermain';

  @override
  String get perfStatAverageOpponent => 'Rata-rata lawan';

  @override
  String get perfStatVictories => 'Kemenangan';

  @override
  String get perfStatDefeats => 'Kalah';

  @override
  String get perfStatDisconnections => 'Koneksi terputus';

  @override
  String get perfStatNotEnoughGames => 'Permainan yang dimainkan tidak mencukupi';

  @override
  String perfStatHighestRating(String param) {
    return 'Rating tertinggi: $param';
  }

  @override
  String perfStatLowestRating(String param) {
    return 'Rating terendah: $param';
  }

  @override
  String perfStatFromXToY(String param1, String param2) {
    return 'dari $param1 ke $param2';
  }

  @override
  String get perfStatWinningStreak => 'Kemenangan beruntun';

  @override
  String get perfStatLosingStreak => 'Kekalahan beruntun';

  @override
  String perfStatLongestStreak(String param) {
    return 'Beruntun terpanjang: $param';
  }

  @override
  String perfStatCurrentStreak(String param) {
    return 'Beruntun saat ini: $param';
  }

  @override
  String get perfStatBestRated => 'Kemenangan dirating terbaik';

  @override
  String get perfStatGamesInARow => 'Permainan yang dimainkan berturut-turut';

  @override
  String get perfStatLessThanOneHour => 'Kurang dari satu jam antar permainan';

  @override
  String get perfStatMaxTimePlaying => 'Maksimal waktu bermain';

  @override
  String get perfStatNow => 'sekarang';

  @override
  String get preferencesPreferences => 'Pengaturan';

  @override
  String get preferencesDisplay => 'Tampilan';

  @override
  String get preferencesPrivacy => 'Privasi';

  @override
  String get preferencesNotifications => 'Notifikasi';

  @override
  String get preferencesPieceAnimation => 'Animasi Buah Catur';

  @override
  String get preferencesMaterialDifference => 'Perbedaan materi';

  @override
  String get preferencesBoardHighlights => 'Sorotan papan (langkah terakhir dan skak)';

  @override
  String get preferencesPieceDestinations => 'Jejak buah catur (langkah sah dan pra-langkah)';

  @override
  String get preferencesBoardCoordinates => 'Koordinat Papan (A-H, 1-8)';

  @override
  String get preferencesMoveListWhilePlaying => 'Daftar langkah ketika bermain';

  @override
  String get preferencesPgnPieceNotation => 'Catatan langkah';

  @override
  String get preferencesChessPieceSymbol => 'Simbol bidak catur';

  @override
  String get preferencesPgnLetter => 'Huruf (K, Q, R, B, N)';

  @override
  String get preferencesZenMode => 'Mode Zen';

  @override
  String get preferencesShowPlayerRatings => 'Munculkan rating pemain';

  @override
  String get preferencesShowFlairs => 'Show player flairs';

  @override
  String get preferencesExplainShowPlayerRatings => 'Ini dapat menyembunyikan rating dari website, agar membantu fokus ke catur. Permainan tetap dapat dinilai, ini hanya untuk apa yang Anda lihat.';

  @override
  String get preferencesDisplayBoardResizeHandle => 'Tampilkan pengubah ukuran papan catur';

  @override
  String get preferencesOnlyOnInitialPosition => 'Hanya di posisi awal';

  @override
  String get preferencesInGameOnly => 'Hanya di dalam permainan';

  @override
  String get preferencesExceptInGame => 'Except in-game';

  @override
  String get preferencesChessClock => 'Jam catur';

  @override
  String get preferencesTenthsOfSeconds => 'Sepersepuluh detik';

  @override
  String get preferencesWhenTimeRemainingLessThanTenSeconds => 'Ketika waktu tersisa < 10 detik';

  @override
  String get preferencesHorizontalGreenProgressBars => 'Indikator horisontal perkembangan warna hijau';

  @override
  String get preferencesSoundWhenTimeGetsCritical => 'Bersuara ketika waktu hampir habis';

  @override
  String get preferencesGiveMoreTime => 'Berikan waktu lebih';

  @override
  String get preferencesGameBehavior => 'Lingkungan permainan';

  @override
  String get preferencesHowDoYouMovePieces => 'Bagaimana Anda melangkahkan bidak?';

  @override
  String get preferencesClickTwoSquares => 'Klik dua kotak';

  @override
  String get preferencesDragPiece => 'Seret sebuah bidak';

  @override
  String get preferencesBothClicksAndDrag => 'Keduanya';

  @override
  String get preferencesPremovesPlayingDuringOpponentTurn => 'Pra-langkah (siapkan langkah saat giliran lawan)';

  @override
  String get preferencesTakebacksWithOpponentApproval => 'Langkah batal (dengan persetujuan lawan)';

  @override
  String get preferencesInCasualGamesOnly => 'Hanya pada permainan santai (tanpa di-rating)';

  @override
  String get preferencesPromoteToQueenAutomatically => 'Otomatis promosikan Menteri';

  @override
  String get preferencesExplainPromoteToQueenAutomatically => 'Tahan tombol <ctrl> saat promosi untuk sementara membatalkan promosi otomatis';

  @override
  String get preferencesWhenPremoving => 'Ketika pra-langkah';

  @override
  String get preferencesClaimDrawOnThreefoldRepetitionAutomatically => 'Langsung Remis pada pengulangan ketiga kali';

  @override
  String get preferencesWhenTimeRemainingLessThanThirtySeconds => 'Ketika waktu tersisa < 30 detik';

  @override
  String get preferencesMoveConfirmation => 'Konfirmasi langkah';

  @override
  String get preferencesExplainCanThenBeTemporarilyDisabled => 'Dapat dimatikan selama permainan pada menu papan';

  @override
  String get preferencesInCorrespondenceGames => 'Pada partai korespondensi';

  @override
  String get preferencesCorrespondenceAndUnlimited => 'Korespondensi dan permainan tanpa batas waktu';

  @override
  String get preferencesConfirmResignationAndDrawOffers => 'Mengonfirmasi tawaran menyerah dan remis';

  @override
  String get preferencesCastleByMovingTheKingTwoSquaresOrOntoTheRook => 'Metode rokade';

  @override
  String get preferencesCastleByMovingTwoSquares => 'Memindahkan raja dua kotak';

  @override
  String get preferencesCastleByMovingOntoTheRook => 'Memindahkan raja ke benteng';

  @override
  String get preferencesInputMovesWithTheKeyboard => 'Melangkah dengan menggunakan keyboard';

  @override
  String get preferencesInputMovesWithVoice => 'Input moves with your voice';

  @override
  String get preferencesSnapArrowsToValidMoves => 'Arahkan panah ke arah yang benar';

  @override
  String get preferencesSayGgWpAfterLosingOrDrawing => 'Ucapkan \"Good game, well played\" apabila kalah atau seri';

  @override
  String get preferencesYourPreferencesHaveBeenSaved => 'Pengaturan telah disimpan.';

  @override
  String get preferencesScrollOnTheBoardToReplayMoves => 'Gulir pada papan untuk mengulang gerakan';

  @override
  String get preferencesCorrespondenceEmailNotification => 'Email harian yang berisi daftar permainan korespondensi anda';

  @override
  String get preferencesNotifyStreamStart => 'Streamer memulai siaran';

  @override
  String get preferencesNotifyInboxMsg => 'Pesan masuk';

  @override
  String get preferencesNotifyForumMention => 'Komentar forum menyebutkan Anda';

  @override
  String get preferencesNotifyInvitedStudy => 'Undangan studi';

  @override
  String get preferencesNotifyGameEvent => 'Update permainan korespondensi';

  @override
  String get preferencesNotifyChallenge => 'Tantangan';

  @override
  String get preferencesNotifyTournamentSoon => 'Turnamen akan segera dimulai';

  @override
  String get preferencesNotifyTimeAlarm => 'Waktu korespondensi akan habis';

  @override
  String get preferencesNotifyBell => 'Notifikasi bel didalam Lichess';

  @override
  String get preferencesNotifyPush => 'Notifikasi perangkat saat anda tidak di Lichess';

  @override
  String get preferencesNotifyWeb => 'Browser';

  @override
  String get preferencesNotifyDevice => 'Perangkat';

  @override
  String get preferencesBellNotificationSound => 'Suara pemberitahuan';

  @override
  String get preferencesBlindfold => 'Blindfold';

  @override
  String get puzzlePuzzles => 'Teka-teki';

  @override
  String get puzzlePuzzleThemes => 'Tema teka-teki';

  @override
  String get puzzleRecommended => 'Direkomendasikan';

  @override
  String get puzzlePhases => 'Tahapan';

  @override
  String get puzzleMotifs => 'Tema';

  @override
  String get puzzleAdvanced => 'Lanjut';

  @override
  String get puzzleLengths => 'Panjang';

  @override
  String get puzzleMates => 'Mat';

  @override
  String get puzzleGoals => 'Tujuan';

  @override
  String get puzzleOrigin => 'Asal';

  @override
  String get puzzleSpecialMoves => 'Langkah spesial';

  @override
  String get puzzleDidYouLikeThisPuzzle => 'Apakah anda menyukai teka-teki ini?';

  @override
  String get puzzleVoteToLoadNextOne => 'Isi untuk memanggil yang satunya lagi!';

  @override
  String get puzzleUpVote => 'Up vote puzzle';

  @override
  String get puzzleDownVote => 'Down vote puzzle';

  @override
  String get puzzleYourPuzzleRatingWillNotChange => 'Your puzzle rating will not change. Note that puzzles are not a competition. Your rating helps selecting the best puzzles for your current skill.';

  @override
  String get puzzleFindTheBestMoveForWhite => 'Temukan langkah terbaik putih.';

  @override
  String get puzzleFindTheBestMoveForBlack => 'Temukan langkah terbaik hitam.';

  @override
  String get puzzleToGetPersonalizedPuzzles => 'Untuk mendapatkan teka-teki yang diatur:';

  @override
  String puzzlePuzzleId(String param) {
    return 'Teka-teki $param';
  }

  @override
  String get puzzlePuzzleOfTheDay => 'Teka-teki hari ini';

  @override
  String get puzzleDailyPuzzle => 'Teka-teki harian';

  @override
  String get puzzleClickToSolve => 'Klik untuk jawabannya';

  @override
  String get puzzleGoodMove => 'Langkah bagus';

  @override
  String get puzzleBestMove => 'Langkah Baik!';

  @override
  String get puzzleKeepGoing => 'Lanjutkan…';

  @override
  String get puzzlePuzzleSuccess => 'Berhasil!';

  @override
  String get puzzlePuzzleComplete => 'Teka-teki terselesaikan!';

  @override
  String get puzzleByOpenings => 'By openings';

  @override
  String get puzzlePuzzlesByOpenings => 'Puzzles by openings';

  @override
  String get puzzleOpeningsYouPlayedTheMost => 'Openings you played the most in rated games';

  @override
  String get puzzleUseFindInPage => 'Use \"Find in page\" in the browser menu to find your favourite opening!';

  @override
  String get puzzleUseCtrlF => 'Use Ctrl+f to find your favourite opening!';

  @override
  String get puzzleNotTheMove => 'Itu bukan langkahnya!';

  @override
  String get puzzleTrySomethingElse => 'Coba lagi lainnya.';

  @override
  String puzzleRatingX(String param) {
    return 'Rating: $param';
  }

  @override
  String get puzzleHidden => 'tersembunyi';

  @override
  String puzzleFromGameLink(String param) {
    return 'Dari game $param';
  }

  @override
  String get puzzleContinueTraining => 'Lanjutkan latihan';

  @override
  String get puzzleDifficultyLevel => 'Level Sulit';

  @override
  String get puzzleNormal => 'Normal';

  @override
  String get puzzleEasier => 'Lebih mudah';

  @override
  String get puzzleEasiest => 'Paling mudah';

  @override
  String get puzzleHarder => 'Lebih sulit';

  @override
  String get puzzleHardest => 'Paling sulit';

  @override
  String get puzzleExample => 'Contoh';

  @override
  String get puzzleAddAnotherTheme => 'Tambah tema lainnya';

  @override
  String get puzzleNextPuzzle => 'Teka-teki selanjutnya';

  @override
  String get puzzleJumpToNextPuzzleImmediately => 'Lompat ke teka-teki berikutnya segera';

  @override
  String get puzzlePuzzleDashboard => 'Beranda Teka-teki';

  @override
  String get puzzleImprovementAreas => 'Area Penyempurnaan';

  @override
  String get puzzleStrengths => 'Kekuatan';

  @override
  String get puzzleHistory => 'Riwayat teka-teki';

  @override
  String get puzzleSolved => 'diselesaikan';

  @override
  String get puzzleFailed => 'gagal';

  @override
  String get puzzleStreakDescription => 'Pecahkan teka-teki yang semakin sulit dan bangun kemenangan beruntun. Tidak ada jam, jadi luangkan waktu Anda. Satu langkah salah, dan permainan berakir! Tapi Anda dapat melewati gerakan per sesi.';

  @override
  String puzzleYourStreakX(String param) {
    return 'Garis Anda: $param';
  }

  @override
  String get puzzleStreakSkipExplanation => 'Lewati gerakan ini untuk mempertahankan garis Anda! Hanya bekerja sekali per pertandingan.';

  @override
  String get puzzleContinueTheStreak => 'Lanjutkan garisnya';

  @override
  String get puzzleNewStreak => 'Garis baru';

  @override
  String get puzzleFromMyGames => 'Dari permainan saya';

  @override
  String get puzzleLookupOfPlayer => 'Cari teka-teki dari sebuah permainan pemain';

  @override
  String puzzleFromXGames(String param) {
    return 'Teka-teki dari permainan $param';
  }

  @override
  String get puzzleSearchPuzzles => 'Cari teka-teki';

  @override
  String get puzzleFromMyGamesNone => 'Anda tidak memiliki teka-teki dalam database, tetapi Lichess masih sangat mencintai Anda.\nMainkan permainan cepat dan klasik untuk meningkatkan kesempatan Anda agar sebuah teka-teki dari Anda dapat ditambahkan!';

  @override
  String puzzleFromXGamesFound(String param1, String param2) {
    return 'Teka-teki $param1 ditemukan di permainan $param2';
  }

  @override
  String get puzzlePuzzleDashboardDescription => 'Latih, analisis, meningkat';

  @override
  String puzzlePercentSolved(String param) {
    return '$param selesai';
  }

  @override
  String get puzzleNoPuzzlesToShow => 'Tidak ada apa apa, silahkan mainkan taktik terlebih dahulu!';

  @override
  String get puzzleImprovementAreasDescription => 'Latih ini untuk mengoptimisasi kemajuan anda!';

  @override
  String get puzzleStrengthDescription => 'Performa anda baik di tema-tema ini';

  @override
  String puzzlePlayedXTimes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Dimainkan $count kali',
    );
    return '$_temp0';
  }

  @override
  String puzzleNbPointsBelowYourPuzzleRating(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count poin dibawah rating teka-teki Anda',
    );
    return '$_temp0';
  }

  @override
  String puzzleNbPointsAboveYourPuzzleRating(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count poin diatas rating teka-teki Anda',
    );
    return '$_temp0';
  }

  @override
  String puzzleNbPlayed(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count dimainkan',
    );
    return '$_temp0';
  }

  @override
  String puzzleNbToReplay(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count dapat diulang',
    );
    return '$_temp0';
  }

  @override
  String get puzzleThemeAdvancedPawn => 'Pion terdepan';

  @override
  String get puzzleThemeAdvancedPawnDescription => 'Satu pion anda jauh dalam posisi lawan, mungkin mengancam untuk melakukan promosi.';

  @override
  String get puzzleThemeAdvantage => 'Keuntungan';

  @override
  String get puzzleThemeAdvantageDescription => 'Raih kesempatan Anda untuk mendapatkan keuntungan yang besar. (200cp ≤ eval ≤ 600cp)';

  @override
  String get puzzleThemeAnastasiaMate => 'Skakmat Anastasia';

  @override
  String get puzzleThemeAnastasiaMateDescription => 'Kuda dan benteng bekerja sama untuk menjebak raja lawan di antara sisi papan dan bidak kawan di sisi lain.';

  @override
  String get puzzleThemeArabianMate => 'Skakmat Arab';

  @override
  String get puzzleThemeArabianMateDescription => 'Bidak kuda dan benteng bekerja sama untuk menjebak raja lawan di sudut papan.';

  @override
  String get puzzleThemeAttackingF2F7 => 'Menyerang f2 atau f7';

  @override
  String get puzzleThemeAttackingF2F7Description => 'Sebuah serangan memfokuskan pada pion f2 atau f7, seperti pembukaan fried liver.';

  @override
  String get puzzleThemeAttraction => 'Pikatan';

  @override
  String get puzzleThemeAttractionDescription => 'Sebuah pertukaran atau pengorbanan yang mendorong atau memaksa bidak lawan ke kotak yang memungkinkan taktik tindak lanjut.';

  @override
  String get puzzleThemeBackRankMate => 'Mat Baris Terakhir';

  @override
  String get puzzleThemeBackRankMateDescription => 'Skakmat raja di kandang sendiri, ketika terjebak oleh bidaknya sendiri.';

  @override
  String get puzzleThemeBishopEndgame => 'Babak akhir gajah';

  @override
  String get puzzleThemeBishopEndgameDescription => 'Babak akhir dengan hanya gajah dan pion.';

  @override
  String get puzzleThemeBodenMate => 'Skakmat Boden';

  @override
  String get puzzleThemeBodenMateDescription => 'Dua bidak gajah yang menyerang dengan diagonal berselang-seling mengantarkan raja skakmat karena terhalang oleh bidaknya sendiri, biasanya benteng dan pion.';

  @override
  String get puzzleThemeCastling => 'Rokade';

  @override
  String get puzzleThemeCastlingDescription => 'Letakkan posisi raja aman, dan manfaatkan benteng untuk menyerang.';

  @override
  String get puzzleThemeCapturingDefender => 'Memakan pelindung';

  @override
  String get puzzleThemeCapturingDefenderDescription => 'Memakan bidak yang sangat penting untuk menjaga bidak lain, memungkinkan bagian yang sekarang tidak terlindungi untuk ditangkap pada langkah berikut.';

  @override
  String get puzzleThemeCrushing => 'Hancurkan';

  @override
  String get puzzleThemeCrushingDescription => 'Temukan kesalahan lawan untuk mendapat keuntungan yang besar. (eval ≥ 600cp)';

  @override
  String get puzzleThemeDoubleBishopMate => 'Skakmat gajah ganda';

  @override
  String get puzzleThemeDoubleBishopMateDescription => 'Dua bidak gajah yang menyerang pada diagonal yang bersebelahan mengantarkan sekakmat pada raja yang terhalang bidaknya sendiri.';

  @override
  String get puzzleThemeDovetailMate => 'Skatmat Dovetail';

  @override
  String get puzzleThemeDovetailMateDescription => 'Menteri skakmat disebelah raja, yang dua petak melarikan dirinya terhambat oleh bidak kawan.';

  @override
  String get puzzleThemeEquality => 'Kesetaraan';

  @override
  String get puzzleThemeEqualityDescription => 'Kembali dari posisi kalah dan amankan seri atau posisi seimbang. (eval ≤ 200cp)';

  @override
  String get puzzleThemeKingsideAttack => 'Serangan raja';

  @override
  String get puzzleThemeKingsideAttackDescription => 'Serangan raja lawan, setelah mereka berada di sisi raja.';

  @override
  String get puzzleThemeClearance => 'Pembersihan';

  @override
  String get puzzleThemeClearanceDescription => 'Sebuah gerakan, seringkali dengan tempo, file atau diagonal untuk ide taktis lanjutan.';

  @override
  String get puzzleThemeDefensiveMove => 'Gerakan bertahan';

  @override
  String get puzzleThemeDefensiveMoveDescription => 'Sebuah gerakan presisi atau urutan gerakan yang dibutuhkan untuk menghindari kerugian material atau keunggulan lain.';

  @override
  String get puzzleThemeDeflection => 'Defleksi';

  @override
  String get puzzleThemeDeflectionDescription => 'Gerakan yang mengalihkan perhatian bidak lawan dari tugas lain yang dilakukan, seperti menjaga kotak kunci. Kadang juga disebut \"overloading\".';

  @override
  String get puzzleThemeDiscoveredAttack => 'Menemukan serangan';

  @override
  String get puzzleThemeDiscoveredAttackDescription => 'Menggerakan bidak(seperti kuda), yang sebelumnya memblokir serangan oleh bidak jarak jauh(seperti benteng) keluar dari bidak itu.';

  @override
  String get puzzleThemeDoubleCheck => 'Skak ganda';

  @override
  String get puzzleThemeDoubleCheckDescription => 'Skak dengan dua bidak bersamaan, sebagai hasil dari serangan tarik dimana bidak yang bergerak dan bidak yang terungkap menyerang raja lawan bersamaan.';

  @override
  String get puzzleThemeEndgame => 'Akhir permainan';

  @override
  String get puzzleThemeEndgameDescription => 'Sebuah taktik selama fase akhir permainan.';

  @override
  String get puzzleThemeEnPassantDescription => 'Taktik melibatkan aturan \"en passant\", yang mana pion dapat makan pion lawan yang baru saja melangkah 2 petak awal.';

  @override
  String get puzzleThemeExposedKing => 'Raja tak terlindung';

  @override
  String get puzzleThemeExposedKingDescription => 'Sebuah taktik melibatkan raja dan beberapa bidak penjaga yang dimana sering berujung sekakmat.';

  @override
  String get puzzleThemeFork => 'Fork';

  @override
  String get puzzleThemeForkDescription => 'Sebuah gerakan dimana bidak yang digerakkan menyerang dua bidak lawan secara bersamaan.';

  @override
  String get puzzleThemeHangingPiece => 'Bidak tak terjaga';

  @override
  String get puzzleThemeHangingPieceDescription => 'Sebuah taktik dimana bidak lawan tidak dipertahankan atau kurang cukup pertahanan sehingga dapat dimakan dengan aman.';

  @override
  String get puzzleThemeHookMate => 'Sekakmat kait';

  @override
  String get puzzleThemeHookMateDescription => 'Skakmat dengan benteng, kuda, dan pion serta satu pion lawan untuk membatasi pergerakan raja lawan.';

  @override
  String get puzzleThemeInterference => 'Gangguan';

  @override
  String get puzzleThemeInterferenceDescription => 'Menggerakan sebuah bidak diantara dua bidak lawan agar menghilangkan pertahanan satu atau kedua bidak lasan, contohnya sebuah kuda pada kotak yang aman diantara dua benteng.';

  @override
  String get puzzleThemeIntermezzo => 'Selingan';

  @override
  String get puzzleThemeIntermezzoDescription => 'Daripada memainkan gerakan yang disangka, mainkan terlebih dulu gerakan lain yang mengancam sehingga mewajibkan lawan untuk membalas. Juga disebut \"Zwischenzug\" atau \"Di antara\".';

  @override
  String get puzzleThemeKillBoxMate => 'Kill box mate';

  @override
  String get puzzleThemeKillBoxMateDescription => 'A rook is next to the enemy king and supported by a queen that also blocks the king\'s escape squares. The rook and the queen catch the enemy king in a 3 by 3 \"kill box\".';

  @override
  String get puzzleThemeVukovicMate => 'Vukovic mate';

  @override
  String get puzzleThemeVukovicMateDescription => 'A rook and knight team up to mate the king. The rook delivers mate while supported by a third piece, and the knight is used to block the king\'s escape squares.';

  @override
  String get puzzleThemeKnightEndgame => 'Babak akhir kuda';

  @override
  String get puzzleThemeKnightEndgameDescription => 'Babak akhir dengan hanya kuda dan pion.';

  @override
  String get puzzleThemeLong => 'Puzzle Panjang';

  @override
  String get puzzleThemeLongDescription => 'Tiga gerakan untuk menang.';

  @override
  String get puzzleThemeMaster => 'Permainan master';

  @override
  String get puzzleThemeMasterDescription => 'Puzzle dari seri pemain bergelar.';

  @override
  String get puzzleThemeMasterVsMaster => 'Game Master vs Master';

  @override
  String get puzzleThemeMasterVsMasterDescription => 'Puzzle dari permainan antara dua pemain bergelar.';

  @override
  String get puzzleThemeMate => 'Skakmat';

  @override
  String get puzzleThemeMateDescription => 'Menangkan game dengan bergaya.';

  @override
  String get puzzleThemeMateIn1 => 'Mati dalam 1 Langkah';

  @override
  String get puzzleThemeMateIn1Description => 'Berikan skakmat dalam satu gerakan.';

  @override
  String get puzzleThemeMateIn2 => 'Mati dalam 2 Langkah';

  @override
  String get puzzleThemeMateIn2Description => 'Berikan skakmat dalam dua gerakan.';

  @override
  String get puzzleThemeMateIn3 => 'Mati dalam 3 Langkah';

  @override
  String get puzzleThemeMateIn3Description => 'Berikan skatmat dalam tiga gerakan.';

  @override
  String get puzzleThemeMateIn4 => 'Mati dalam 4 Langkah';

  @override
  String get puzzleThemeMateIn4Description => 'Berikan skakmat dalam empat gerakan.';

  @override
  String get puzzleThemeMateIn5 => 'Mati dalam 5 langkah atau lebih';

  @override
  String get puzzleThemeMateIn5Description => 'Temukan urutan panjang skatmat.';

  @override
  String get puzzleThemeMiddlegame => 'Setengah permainan';

  @override
  String get puzzleThemeMiddlegameDescription => 'Taktik selama fase kedua permainan.';

  @override
  String get puzzleThemeOneMove => 'Teka-teki satu gerakan';

  @override
  String get puzzleThemeOneMoveDescription => 'Teka-teki yang hanya satu gerakan panjang.';

  @override
  String get puzzleThemeOpening => 'Pembuka';

  @override
  String get puzzleThemeOpeningDescription => 'Taktik selama fase pertama permainan.';

  @override
  String get puzzleThemePawnEndgame => 'Babak akhir pion';

  @override
  String get puzzleThemePawnEndgameDescription => 'Babak akhir hanya dengan pion.';

  @override
  String get puzzleThemePin => 'Pin';

  @override
  String get puzzleThemePinDescription => 'Taktik meliputi pin, dimana bidak tidak dapat bergerak tanpa membuka serangan pada bidak yang bernilai lebih tinggi.';

  @override
  String get puzzleThemePromotion => 'Promosi';

  @override
  String get puzzleThemePromotionDescription => 'Promosi salah satu pion menjadi menteri atau bidak minor lainnya.';

  @override
  String get puzzleThemeQueenEndgame => 'Babak akhir menteri';

  @override
  String get puzzleThemeQueenEndgameDescription => 'Babak akhir hanya dengan menteri dan pion.';

  @override
  String get puzzleThemeQueenRookEndgame => 'Menteri dan Benteng';

  @override
  String get puzzleThemeQueenRookEndgameDescription => 'Permainan Akhir hanya dengan menteri, benteng, dan pion.';

  @override
  String get puzzleThemeQueensideAttack => 'Serangan sisi menteri';

  @override
  String get puzzleThemeQueensideAttackDescription => 'Serangan raja lawan, setelah lawan rokade panjang.';

  @override
  String get puzzleThemeQuietMove => 'Gerakan tenang';

  @override
  String get puzzleThemeQuietMoveDescription => 'Sebuah gerakan yang tidak melakukan sekak maupun memakan, dan tidak memberi ancaman memakan langsung, namun mempersiapkan ancaman tersembunyi yang tidak dapat dihindari pada gerakan selanjutnya.';

  @override
  String get puzzleThemeRookEndgame => 'Permainan Akhir benteng';

  @override
  String get puzzleThemeRookEndgameDescription => 'Babak akhir dengan hanya benteng dan pion.';

  @override
  String get puzzleThemeSacrifice => 'Sacrifice';

  @override
  String get puzzleThemeSacrificeDescription => 'Sebuah taktik yang melibatkan menyerahkan material dalam jangka pendek, untuk meraih keuntungan kembali setelah urutan gerakan yang terpaksa.';

  @override
  String get puzzleThemeShort => 'Teka-teki pendek';

  @override
  String get puzzleThemeShortDescription => 'Dua gerakan untuk menang.';

  @override
  String get puzzleThemeSkewer => 'Tusukan';

  @override
  String get puzzleThemeSkewerDescription => 'Sebuah motif melibatkan sebuah bidak berharga yang diserang bergerak sehingga mengizinkan bidak bernilai lebih rendah dibelakangnya dimakan atau diserang, yang merupakan kebalikan dari sebuah pin.';

  @override
  String get puzzleThemeSmotheredMate => 'Sekakmat kepung';

  @override
  String get puzzleThemeSmotheredMateDescription => 'Sebuah sekakmat yang diraih oleh sebuah kuda yang dimana raja tidak dapat bergerak karena terkepung oleh bidaknya sendiri.';

  @override
  String get puzzleThemeSuperGM => 'Permainan super GM';

  @override
  String get puzzleThemeSuperGMDescription => 'Teka-teki dari permainan yang dimainkan oleh pemain terbaik di seluruh dunia.';

  @override
  String get puzzleThemeTrappedPiece => 'Bidak yang terperangkap';

  @override
  String get puzzleThemeTrappedPieceDescription => 'Bidak tidak bisa lolos dari penangkapan karena gerakannya dibatasi.';

  @override
  String get puzzleThemeUnderPromotion => 'Dalam Promosi';

  @override
  String get puzzleThemeUnderPromotionDescription => 'Promosi ke kuda, gajah, atau benteng.';

  @override
  String get puzzleThemeVeryLong => 'Teka-teki yang sangat panjang';

  @override
  String get puzzleThemeVeryLongDescription => 'Empat gerakan atau lebih untuk menang.';

  @override
  String get puzzleThemeXRayAttack => 'Serangan Sinar-X';

  @override
  String get puzzleThemeXRayAttackDescription => 'Bidak menyerang atau mempertahankan kotak, melalui bidak musuh.';

  @override
  String get puzzleThemeZugzwang => 'Zugzwang';

  @override
  String get puzzleThemeZugzwangDescription => 'Musuh dibatasi gerakan yang dapat mereka lakukan, dan semua gerakan memperburuk posisi mereka.';

  @override
  String get puzzleThemeMix => 'Campuran baik';

  @override
  String get puzzleThemeMixDescription => 'Sedikit dari segalanya. Anda tidak tahu apa yang akan terjadi, jadi Anda tetap siap untuk apapun! Sama seperti permainan sebenarnya.';

  @override
  String get puzzleThemePlayerGames => 'Permainan pemain';

  @override
  String get puzzleThemePlayerGamesDescription => 'Mengambil taktik yang dihasilkan dari permainan anda, atau pemain lain.';

  @override
  String puzzleThemePuzzleDownloadInformation(String param) {
    return 'Taktik-taktik ini ada di domain publik, dan dapat di download dari $param.';
  }

  @override
  String get searchSearch => 'Cari';

  @override
  String get settingsSettings => 'Pengaturan';

  @override
  String get settingsCloseAccount => 'Tutup akun';

  @override
  String get settingsManagedAccountCannotBeClosed => 'Akun Anda dikelola, dan tidak dapat ditutup.';

  @override
  String get settingsCantOpenSimilarAccount => 'Anda tidak akan diizinkan untuk membuka akun baru dengan nama yang sama, meskipun besar-kecil hurufnya berbeda.';

  @override
  String get settingsCancelKeepAccount => 'Cancel and keep my account';

  @override
  String get settingsCloseAccountAreYouSure => 'Are you sure you want to close your account?';

  @override
  String get settingsThisAccountIsClosed => 'Akun ini telah ditutup.';

  @override
  String get playWithAFriend => 'Bermain dengan teman';

  @override
  String get playWithTheMachine => 'Bermain melawan komputer';

  @override
  String get toInviteSomeoneToPlayGiveThisUrl => 'Undang yang lain dengan memberikan URL berikut';

  @override
  String get gameOver => 'Permainan Berakhir';

  @override
  String get waitingForOpponent => 'Menunggu lawan';

  @override
  String get orLetYourOpponentScanQrCode => 'Atau silakan lawan anda untuk melakukan scan pada kode QR ini';

  @override
  String get waiting => 'Menunggu';

  @override
  String get yourTurn => 'Giliran Anda';

  @override
  String aiNameLevelAiLevel(String param1, String param2) {
    return '$param1 level $param2';
  }

  @override
  String get level => 'Level';

  @override
  String get strength => 'Kekuatan';

  @override
  String get toggleTheChat => 'Ganti tampilan obrolan';

  @override
  String get chat => 'Obrolan';

  @override
  String get resign => 'Menyerah';

  @override
  String get checkmate => 'Skakmat';

  @override
  String get stalemate => 'Langkah buntu';

  @override
  String get white => 'Putih';

  @override
  String get black => 'Hitam';

  @override
  String get asWhite => 'sebagai Putih';

  @override
  String get asBlack => 'sebagai Hitam';

  @override
  String get randomColor => 'Warna acak';

  @override
  String get createAGame => 'Mulai permainan baru';

  @override
  String get whiteIsVictorious => 'Putih menang';

  @override
  String get blackIsVictorious => 'Hitam menang';

  @override
  String get youPlayTheWhitePieces => 'Anda bermain dipihak putih';

  @override
  String get youPlayTheBlackPieces => 'Anda bermain dipihak hitam';

  @override
  String get itsYourTurn => 'Giliran Anda!';

  @override
  String get cheatDetected => 'Curang Terdeteksi';

  @override
  String get kingInTheCenter => 'Raja berada di tengah';

  @override
  String get threeChecks => 'Tiga kali skak';

  @override
  String get raceFinished => 'Balapan telah berakhir';

  @override
  String get variantEnding => 'Akhir sesuai aturan variasi';

  @override
  String get newOpponent => 'Permainan yang baru';

  @override
  String get yourOpponentWantsToPlayANewGameWithYou => 'Lawan Anda ingin bermain lagi dengan Anda';

  @override
  String get joinTheGame => 'Ikuti permainan';

  @override
  String get whitePlays => 'Putih melangkah';

  @override
  String get blackPlays => 'Hitam melangkah';

  @override
  String get opponentLeftChoices => 'Pemain lainnya telah meninggalkan permainan. Anda bisa klaim kemenangan, menyatakan remis, atau menunggunya.';

  @override
  String get forceResignation => 'Klaim menang';

  @override
  String get forceDraw => 'Nyatakan remis';

  @override
  String get talkInChat => 'Silahkan mengobrol dengan sopan';

  @override
  String get theFirstPersonToComeOnThisUrlWillPlayWithYou => 'Orang pertama yang datang ke URL ini akan bermain dengan Anda';

  @override
  String get whiteResigned => 'Putih menyerah';

  @override
  String get blackResigned => 'Hitam menyerah';

  @override
  String get whiteLeftTheGame => 'Putih meninggalkan permainan';

  @override
  String get blackLeftTheGame => 'Hitam meninggalkan permainan';

  @override
  String get whiteDidntMove => 'Putih tidak melangkah';

  @override
  String get blackDidntMove => 'Hitam tidak melangkah';

  @override
  String get requestAComputerAnalysis => 'Minta analisa komputer';

  @override
  String get computerAnalysis => 'Analisa komputer';

  @override
  String get computerAnalysisAvailable => 'Analisa komputer tersedia';

  @override
  String get computerAnalysisDisabled => 'Analisa komputer tidak tersedia';

  @override
  String get analysis => 'Papan analisa';

  @override
  String depthX(String param) {
    return 'Detil $param';
  }

  @override
  String get usingServerAnalysis => 'Menggunakan server analisa';

  @override
  String get loadingEngine => 'Memuat...';

  @override
  String get calculatingMoves => 'Menghitung...';

  @override
  String get engineFailed => 'Gagal memuat komputer';

  @override
  String get cloudAnalysis => 'Analisis Cloud';

  @override
  String get goDeeper => 'Lihat lebih detail';

  @override
  String get showThreat => 'Tunjukkan ancaman';

  @override
  String get inLocalBrowser => 'di browser lokal';

  @override
  String get toggleLocalEvaluation => 'Ganti evaluasi lokal';

  @override
  String get promoteVariation => 'Variasi promosi';

  @override
  String get makeMainLine => 'Buat jalur utama';

  @override
  String get deleteFromHere => 'Hapus dari sini';

  @override
  String get collapseVariations => 'Tutup variasi';

  @override
  String get expandVariations => 'Buka variasi';

  @override
  String get forceVariation => 'Paksakan variasi';

  @override
  String get copyVariationPgn => 'Salin Variasi dalam PGN';

  @override
  String get move => 'Langkah';

  @override
  String get variantLoss => 'Kekalahan variasi';

  @override
  String get variantWin => 'Kemenangan variasi';

  @override
  String get insufficientMaterial => 'Bidak tidak mencukupi';

  @override
  String get pawnMove => 'Langkah pion';

  @override
  String get capture => 'Makan';

  @override
  String get close => 'Tutup';

  @override
  String get winning => 'Kemenangan';

  @override
  String get losing => 'Kekalahan';

  @override
  String get drawn => 'Langkah remis';

  @override
  String get unknown => 'Tak diketahui';

  @override
  String get database => 'Basis Data';

  @override
  String get whiteDrawBlack => 'Putih / Remis / Hitam';

  @override
  String averageRatingX(String param) {
    return 'Rata-rata rating: $param';
  }

  @override
  String get recentGames => 'Permainan terkini';

  @override
  String get topGames => 'Permaninan kelas atas';

  @override
  String masterDbExplanation(String param1, String param2, String param3) {
    return 'Permainan OTB dua juta $param1 + FIDE dinilai pemain dari tahun $param2 untuk $param3';
  }

  @override
  String get dtzWithRounding => 'DTZ50\" dengan pembulatan, berdasarkan jumlah dari langkah setengah sampai ada langkah makan atau langkah pion';

  @override
  String get noGameFound => 'Permainan tidak ditemukan';

  @override
  String get maxDepthReached => 'Kedalaman maksimal tercapai!';

  @override
  String get maybeIncludeMoreGamesFromThePreferencesMenu => 'Apakah ingin memasukan Permainan lainnya dari menu preferensi?';

  @override
  String get openings => 'Pembukaan';

  @override
  String get openingExplorer => 'Penjelajah pembukaan';

  @override
  String get openingEndgameExplorer => 'Penjelajah pembukaan/babak akhir';

  @override
  String xOpeningExplorer(String param) {
    return 'Menjelajahi pembukaan $param';
  }

  @override
  String get playFirstOpeningEndgameExplorerMove => 'Play first opening/endgame-explorer move';

  @override
  String get winPreventedBy50MoveRule => 'Tidak bisa menang karena peraturan 50 langkah';

  @override
  String get lossSavedBy50MoveRule => 'Kekalahan terhindari karena peraturan 50 langkah';

  @override
  String get winOr50MovesByPriorMistake => 'Win or 50 moves by prior mistake';

  @override
  String get lossOr50MovesByPriorMistake => 'Loss or 50 moves by prior mistake';

  @override
  String get unknownDueToRounding => 'Win/loss only guaranteed if recommended tablebase line has been followed since the last capture or pawn move, due to possible rounding of DTZ values in Syzygy tablebases.';

  @override
  String get allSet => 'Semua siap!';

  @override
  String get importPgn => 'Impor PGN';

  @override
  String get delete => 'Hapus';

  @override
  String get deleteThisImportedGame => 'Hapus permainan impor ini?';

  @override
  String get replayMode => 'Mode Putar Ulang';

  @override
  String get realtimeReplay => 'Langsung';

  @override
  String get byCPL => 'Secara CPL';

  @override
  String get enable => 'Aktifkan';

  @override
  String get bestMoveArrow => 'Panah Langkah terbaik';

  @override
  String get showVariationArrows => 'Tampilkan variasi panah';

  @override
  String get evaluationGauge => 'Mengukur evaluasi';

  @override
  String get multipleLines => 'Beberapa variasi';

  @override
  String get cpus => 'CPU';

  @override
  String get memory => 'Memori';

  @override
  String get infiniteAnalysis => 'Menganalisa tanpa ada batasan';

  @override
  String get removesTheDepthLimit => 'Menghapus batas kedalaman, dan membuat komputer Anda hangat';

  @override
  String get blunder => 'Blunder';

  @override
  String get mistake => 'Kesalahan';

  @override
  String get inaccuracy => 'Ketidaktelitian';

  @override
  String get moveTimes => 'Waktu gerak';

  @override
  String get flipBoard => 'Putar papan catur';

  @override
  String get threefoldRepetition => 'Pengulangan 3x posisi yang sama';

  @override
  String get claimADraw => 'Klaim remis';

  @override
  String get offerDraw => 'Tawarkan remis';

  @override
  String get draw => 'Remis';

  @override
  String get drawByMutualAgreement => 'Remis atas keputusan bersama';

  @override
  String get fiftyMovesWithoutProgress => '50 langkah tanpa kemajuan';

  @override
  String get currentGames => 'Permainan saat ini';

  @override
  String get viewInFullSize => 'Lihat dalam ukuran penuh';

  @override
  String get logOut => 'Keluar';

  @override
  String get signIn => 'Masuk';

  @override
  String get rememberMe => 'Ingat Saya';

  @override
  String get youNeedAnAccountToDoThat => 'Anda perlu mendaftar untuk melakukannya';

  @override
  String get signUp => 'Daftar';

  @override
  String get computersAreNotAllowedToPlay => 'Komputer maupun pemain yang menggunakan bantuan komputer dilarang bermain. Mohon untuk tidak menggunakan bantuan dari program komputer, database, maupun pemain lain ketika bermain. Juga menggunakan beberapa akun bersamaan sangat dilarang dan akan mengakibatkan akun anda di-BANNED!';

  @override
  String get games => 'Permainan';

  @override
  String get forum => 'Forum';

  @override
  String xPostedInForumY(String param1, String param2) {
    return '$param1 postingan dalam topik $param2';
  }

  @override
  String get latestForumPosts => 'Pesan forum terbaru';

  @override
  String get players => 'Pemain';

  @override
  String get friends => 'Teman';

  @override
  String get otherPlayers => 'pemain lainnya';

  @override
  String get discussions => 'Diskusi';

  @override
  String get today => 'Hari ini';

  @override
  String get yesterday => 'Kemarin';

  @override
  String get minutesPerSide => 'Menit untuk tiap pihak';

  @override
  String get variant => 'Variasi permainan';

  @override
  String get variants => 'Variasi permainan';

  @override
  String get timeControl => 'Kontrol waktu';

  @override
  String get realTime => 'Langsung';

  @override
  String get correspondence => 'Korespondensi';

  @override
  String get daysPerTurn => 'Hari per langkah';

  @override
  String get oneDay => 'Satu hari';

  @override
  String get time => 'Waktu';

  @override
  String get rating => 'Rating';

  @override
  String get ratingStats => 'Statistik rating';

  @override
  String get username => 'Nama pengguna';

  @override
  String get usernameOrEmail => 'Nama pengguna atau email';

  @override
  String get changeUsername => 'Ganti nama pengguna';

  @override
  String get changeUsernameNotSame => 'Hanya dapat mengubah ke huruf besar atau kecil. Contohnya \"johndoe\" ke \"JohnDoe\"';

  @override
  String get changeUsernameDescription => 'Ganti nama pengguna Anda. Ini hanya diperbolehkan mengubah huruf besar-kecil nama pengguna Anda.';

  @override
  String get signupUsernameHint => 'Pastikan username Anda senonoh. Anda tidak dapat menggantinya lagi dan akun dengan username tidak senonoh akan di tutup!';

  @override
  String get signupEmailHint => 'Ini hanya akan digunakan untuk setel ulang password.';

  @override
  String get password => 'Kata sandi';

  @override
  String get changePassword => 'Ganti kata sandi';

  @override
  String get changeEmail => 'Ubah email';

  @override
  String get email => 'Email';

  @override
  String get passwordReset => 'Reset kata sandi';

  @override
  String get forgotPassword => 'Lupa kata sandi?';

  @override
  String get error_weakPassword => 'Password ini terlalu umum dan mudah ditebak.';

  @override
  String get error_namePassword => 'Mohon tidak menggunakan username sebagai password.';

  @override
  String get blankedPassword => 'Anda telah menggunakan password di website lain, dan website itu telah jebol. Untuk memastikan keamanan akun Lichess anda, kami haruskan untuk menyetel password baru. Terimakasih atas pengertiannya.';

  @override
  String get youAreLeavingLichess => 'Anda akan keluar dari Lichess';

  @override
  String get neverTypeYourPassword => 'Jangan pernah memasukkan password Lichess di tempat lain!';

  @override
  String proceedToX(String param) {
    return 'Melanjutkan ke $param';
  }

  @override
  String get passwordSuggestion => 'Jangan gunakan password yang disarankan orang lain. Mereka akan menggunakannya untuk mengambil akun anda.';

  @override
  String get emailSuggestion => 'Jangan gunakan email yang disarankan orang lain. Mereka akan menggunakannya untuk mengambil akun anda.';

  @override
  String get emailConfirmHelp => 'Bantuan untuk email konfirmasi';

  @override
  String get emailConfirmNotReceived => 'Tidak mendapat email konfirmasi setelah registrasi?';

  @override
  String get whatSignupUsername => 'Username apa yang Anda gunakan saat sign up?';

  @override
  String usernameNotFound(String param) {
    return 'Kami tidak dapat menemukan user dengan nama ini: $param.';
  }

  @override
  String get usernameCanBeUsedForNewAccount => 'Anda dapat menggunakan username ini untuk membuat akun baru';

  @override
  String emailSent(String param) {
    return 'Kami telah mengirim email ke $param.';
  }

  @override
  String get emailCanTakeSomeTime => 'Dapat membutuhkan beberapa waktu hingga sampai.';

  @override
  String get refreshInboxAfterFiveMinutes => 'Tunggu 5 menit dan refresh kotak masuk Anda.';

  @override
  String get checkSpamFolder => 'Cek juga folder spam Anda, mungkin ada disana. Jika ada, tandai sebagai bukan spam.';

  @override
  String get emailForSignupHelp => 'Jika semuanya gagal, kirim kami email ini:';

  @override
  String copyTextToEmail(String param) {
    return 'Salin dan tempel teks diatas dan kirimkan ke $param';
  }

  @override
  String get waitForSignupHelp => 'Kami akan kembali sejenak untuk membantu penyelesaian signup anda.';

  @override
  String accountConfirmed(String param) {
    return 'User $param berhasil dikonfirmasi.';
  }

  @override
  String accountCanLogin(String param) {
    return 'Anda sekarang dapat masuk sebagai $param.';
  }

  @override
  String get accountConfirmationEmailNotNeeded => 'Anda tidak butuh email konfirmasi.';

  @override
  String accountClosed(String param) {
    return 'Akun $param telah ditutup.';
  }

  @override
  String accountRegisteredWithoutEmail(String param) {
    return 'Akun $param diregistrasi tanpa email.';
  }

  @override
  String get rank => 'Peringkat';

  @override
  String rankX(String param) {
    return 'Rating: $param';
  }

  @override
  String get gamesPlayed => 'Permainan yang telah dimainkan';

  @override
  String get ok => 'OK';

  @override
  String get cancel => 'Batal';

  @override
  String get whiteTimeOut => 'Putih kehabisan waktu';

  @override
  String get blackTimeOut => 'Hitam kehabisan waktu';

  @override
  String get drawOfferSent => 'Tawaran remis terkirim';

  @override
  String get drawOfferAccepted => 'Tawaran remis diterima';

  @override
  String get drawOfferCanceled => 'Tawaran remis dibatalkan';

  @override
  String get whiteOffersDraw => 'Putih menawarkan remis';

  @override
  String get blackOffersDraw => 'Hitam menawarkan remis';

  @override
  String get whiteDeclinesDraw => 'Putih menolak remis';

  @override
  String get blackDeclinesDraw => 'Hitam menolak remis';

  @override
  String get yourOpponentOffersADraw => 'Lawan anda menawar remis';

  @override
  String get accept => 'Terima';

  @override
  String get decline => 'Tolak';

  @override
  String get playingRightNow => 'Bermain saat ini';

  @override
  String get eventInProgress => 'Mainkan sekarang';

  @override
  String get finished => 'Selesai';

  @override
  String get abortGame => 'Batalkan permainan';

  @override
  String get gameAborted => 'Permainan dibatalkan';

  @override
  String get standard => 'Standar';

  @override
  String get customPosition => 'Posisi kustom';

  @override
  String get unlimited => 'Tak terbatas';

  @override
  String get mode => 'Mode';

  @override
  String get casual => 'Santai (Tanpa rating)';

  @override
  String get rated => 'Di-rating';

  @override
  String get casualTournament => 'Santai (Tanpa rating)';

  @override
  String get ratedTournament => 'Di-rating';

  @override
  String get thisGameIsRated => 'Permainan ini di-rating';

  @override
  String get rematch => 'Ulang pertandingan';

  @override
  String get rematchOfferSent => 'Tawaran permainan ulang terkirim';

  @override
  String get rematchOfferAccepted => 'Tawaran permainan ulang diterima';

  @override
  String get rematchOfferCanceled => 'Tawaran permainan ulang dibatalkan';

  @override
  String get rematchOfferDeclined => 'Tawaran permainan ulang ditolak';

  @override
  String get cancelRematchOffer => 'Batalkan tawaran permainan ulang';

  @override
  String get viewRematch => 'Lihat permainan ulang';

  @override
  String get confirmMove => 'Konfirmasi langkah';

  @override
  String get play => 'Mainkan';

  @override
  String get inbox => 'Kotak Masuk';

  @override
  String get chatRoom => 'Ruang Ngobrol';

  @override
  String get loginToChat => 'Masuk untuk mengobrol';

  @override
  String get youHaveBeenTimedOut => 'Waktu Anda telah habis.';

  @override
  String get spectatorRoom => 'Ruang penonton';

  @override
  String get composeMessage => 'Tulis pesan';

  @override
  String get subject => 'subyek';

  @override
  String get send => 'Kirim';

  @override
  String get incrementInSeconds => 'Kenaikan dalam detik';

  @override
  String get freeOnlineChess => 'Catur online gratis!';

  @override
  String get exportGames => 'Ekspor Permainan';

  @override
  String get ratingRange => 'Batasan rating';

  @override
  String get thisAccountViolatedTos => 'Akun ini melanggar Ketentuan Layanan Lichess';

  @override
  String get openingExplorerAndTablebase => 'Penjelajah pembukaan & tablebase';

  @override
  String get takeback => 'Langkah Batal';

  @override
  String get proposeATakeback => 'Ajukan langkah batal';

  @override
  String get takebackPropositionSent => 'Penawaran untuk langkah batal terkirim';

  @override
  String get takebackPropositionDeclined => 'Penawaran untuk langkah batal ditolak';

  @override
  String get takebackPropositionAccepted => 'Penawaran untuk langkah batal diterima';

  @override
  String get takebackPropositionCanceled => 'Penawaran untuk langkah batal dibatalkan';

  @override
  String get yourOpponentProposesATakeback => 'Musuh anda menawarkan langkah batal';

  @override
  String get bookmarkThisGame => 'Tandai permainan ini';

  @override
  String get tournament => 'Turnamen';

  @override
  String get tournaments => 'Turnamen';

  @override
  String get tournamentPoints => 'Poin Turnamen';

  @override
  String get viewTournament => 'Lihat turnamen';

  @override
  String get backToTournament => 'Kembali ke turnamen';

  @override
  String get noDrawBeforeSwissLimit => 'Anda tidak dapat menawarkan remis sebelum 30 langkah dimainkan di pertandingan Swiss.';

  @override
  String get thematic => 'Bertema';

  @override
  String yourPerfRatingIsProvisional(String param) {
    return 'Rating Anda ($param) bersifat sementara';
  }

  @override
  String yourPerfRatingIsTooHigh(String param1, String param2) {
    return 'Rating $param1 kamu ($param2) terlalu besar';
  }

  @override
  String yourTopWeeklyPerfRatingIsTooHigh(String param1, String param2) {
    return 'Rating permainan $param1 mingguan teratas Anda ($param2) terlalu besar';
  }

  @override
  String yourPerfRatingIsTooLow(String param1, String param2) {
    return 'Rating $param1 kamu ($param2) terlalu rendah';
  }

  @override
  String ratedMoreThanInPerf(String param1, String param2) {
    return 'Hanya boleh dengan rating ≥ $param1 dipermainan $param2';
  }

  @override
  String ratedLessThanInPerf(String param1, String param2) {
    return 'Hanya boleh dengan rating ≤ $param1 dipermainan $param2';
  }

  @override
  String mustBeInTeam(String param) {
    return 'Harus dari dalam tim $param';
  }

  @override
  String youAreNotInTeam(String param) {
    return 'Anda tidak masuk dalam tim $param';
  }

  @override
  String get backToGame => 'Kembali ke permainan';

  @override
  String get siteDescription => 'Permainan Catur gratis. Main Catur sekarang dengan antarmuka yang bersih. Tanpa registrasi, tanpa iklan, dan tanpa plugin tambahan. Bermain catur lawan komputer, teman atau lawan manusia secara acak.';

  @override
  String xJoinedTeamY(String param1, String param2) {
    return '$param1 bergabung tim $param2';
  }

  @override
  String xCreatedTeamY(String param1, String param2) {
    return '$param1 membuat tim $param2';
  }

  @override
  String get startedStreaming => 'memulai streaming';

  @override
  String xStartedStreaming(String param) {
    return '$param memulai streaming';
  }

  @override
  String get averageElo => 'Rating rata-rata';

  @override
  String get location => 'Lokasi';

  @override
  String get filterGames => 'Pilih permainan';

  @override
  String get reset => 'Ulang';

  @override
  String get apply => 'Terapkan';

  @override
  String get save => 'Simpan';

  @override
  String get leaderboard => 'Peringkat Terbaik';

  @override
  String get screenshotCurrentPosition => 'Foto posisi saat ini';

  @override
  String get gameAsGIF => 'Simpan sebagai GIF';

  @override
  String get pasteTheFenStringHere => 'Paste string FEN di sini';

  @override
  String get pasteThePgnStringHere => 'Paste string PGN di sini';

  @override
  String get orUploadPgnFile => 'Atau muat berkas PGN';

  @override
  String get fromPosition => 'Dari posisi';

  @override
  String get continueFromHere => 'Lanjutkan dari sini';

  @override
  String get toStudy => 'Studi';

  @override
  String get importGame => 'Masukkan permainan';

  @override
  String get importGameExplanation => 'Ketika menyalin PGN permainan Anda dapat putar-ulang di browser analisis komputer, obrolan permainan dan URL yand dapat di bagi.';

  @override
  String get importGameCaveat => 'Variasi akan dihapus. Untuk menyimpan, Import berkas PGN melalui Study.';

  @override
  String get importGameDataPrivacyWarning => 'Berkas PGN ini bisa diakses oleh publik. Untuk mengimpor pertandingan dengan privasi, gunakan study.';

  @override
  String get thisIsAChessCaptcha => 'Ini adalah CAPTCHA catur.';

  @override
  String get clickOnTheBoardToMakeYourMove => 'Klik pada papan untuk melangkah  dan buktikan bahwa anda asli manusia.';

  @override
  String get captcha_fail => 'Harap selesaikan captcha catur.';

  @override
  String get notACheckmate => 'Bukan skakmat';

  @override
  String get whiteCheckmatesInOneMove => 'Putih skakmat dalam satu langkah';

  @override
  String get blackCheckmatesInOneMove => 'Hitam skakmat dalam satu langkah';

  @override
  String get retry => 'Mengulang';

  @override
  String get reconnecting => 'Menyambung ulang';

  @override
  String get noNetwork => 'Offline';

  @override
  String get favoriteOpponents => 'Lawan Favorit';

  @override
  String get follow => 'Ikuti';

  @override
  String get following => 'Mengikuti';

  @override
  String get unfollow => 'Tidak mengikuti';

  @override
  String followX(String param) {
    return 'Ikuti $param';
  }

  @override
  String unfollowX(String param) {
    return 'Stop mengikuti $param';
  }

  @override
  String get block => 'Blokir';

  @override
  String get blocked => 'Diblokir';

  @override
  String get unblock => 'Buka blokir';

  @override
  String xStartedFollowingY(String param1, String param2) {
    return '$param1 mulai mengikuti $param2';
  }

  @override
  String get more => 'Lainnya';

  @override
  String get memberSince => 'Anggota sejak';

  @override
  String lastSeenActive(String param) {
    return 'Login terakhir $param';
  }

  @override
  String get player => 'Pemain';

  @override
  String get list => 'Daftar';

  @override
  String get graph => 'Grafik';

  @override
  String get required => 'Dibutuhkan.';

  @override
  String get openTournaments => 'Turnamen terbuka';

  @override
  String get duration => 'Durasi';

  @override
  String get winner => 'Pemenang';

  @override
  String get standing => 'Klasemen';

  @override
  String get createANewTournament => 'Buat turnamen baru';

  @override
  String get tournamentCalendar => 'Jadwal turnamen';

  @override
  String get conditionOfEntry => 'Persyaratan masuk:';

  @override
  String get advancedSettings => 'Pengaturan lanjutan';

  @override
  String get safeTournamentName => 'Pilih nama yang paling aman untuk turnamen.';

  @override
  String get inappropriateNameWarning => 'Nama apapun yang bahkan sedikit tidak pantas akan mengakibatkan akun Anda ditutup.';

  @override
  String get emptyTournamentName => 'Biarkan kosong untuk nama turnamen setelah pengacakan Grandmaster.';

  @override
  String get makePrivateTournament => 'Jadikan turnamen pribadi, dan batasi akses dengan kata sandi';

  @override
  String get join => 'Gabung';

  @override
  String get withdraw => 'Keluar';

  @override
  String get points => 'Poin';

  @override
  String get wins => 'Menang';

  @override
  String get losses => 'Kalah';

  @override
  String get createdBy => 'Dibuat oleh';

  @override
  String get tournamentIsStarting => 'Turnamen sudah dimulai';

  @override
  String get tournamentPairingsAreNowClosed => 'Pairing pemain sudah ditutup.';

  @override
  String standByX(String param) {
    return 'Bersiaplah $param, pairing pemain sedang dilakukan!';
  }

  @override
  String get pause => 'Jeda';

  @override
  String get resume => 'Lanjutkan';

  @override
  String get youArePlaying => 'Anda bermain!';

  @override
  String get winRate => 'Rating kemenangan';

  @override
  String get berserkRate => 'Rating berserk';

  @override
  String get performance => 'Prestasi';

  @override
  String get tournamentComplete => 'Turnamen selesai';

  @override
  String get movesPlayed => 'Langkah yang dijalankan';

  @override
  String get whiteWins => 'Putih Menang';

  @override
  String get blackWins => 'Hitam Menang';

  @override
  String get drawRate => 'Persentase imbang';

  @override
  String get draws => 'Remis';

  @override
  String nextXTournament(String param) {
    return 'Turnamen $param selanjutnya:';
  }

  @override
  String get averageOpponent => 'Rata-rata rating lawan';

  @override
  String get boardEditor => 'Edit Papan';

  @override
  String get setTheBoard => 'Atur papan';

  @override
  String get popularOpenings => 'Pembuka populer';

  @override
  String get endgamePositions => 'Posisi akhir permainan';

  @override
  String chess960StartPosition(String param) {
    return 'Posisi awal Catur960: $param';
  }

  @override
  String get startPosition => 'Posisi Awal';

  @override
  String get clearBoard => 'Bersihkan papan';

  @override
  String get loadPosition => 'Panggil posisi';

  @override
  String get isPrivate => 'Pribadi';

  @override
  String reportXToModerators(String param) {
    return 'Lapor $param ke moderator';
  }

  @override
  String profileCompletion(String param) {
    return 'Kelengkapan profil $param';
  }

  @override
  String xRating(String param) {
    return 'peringkat $param';
  }

  @override
  String get ifNoneLeaveEmpty => 'Jika tidak ada, biarkan kosong';

  @override
  String get profile => 'Profil';

  @override
  String get editProfile => 'Ubah profil';

  @override
  String get realName => 'Nama asli';

  @override
  String get setFlair => 'Sunting flair anda';

  @override
  String get flair => 'Flair';

  @override
  String get youCanHideFlair => 'Terdapat setting untuk menyembunyikan semua flair pengguna pada seluruh situs.';

  @override
  String get biography => 'Biografi';

  @override
  String get countryRegion => 'Negara atau wilayah';

  @override
  String get thankYou => 'Terima Kasih!';

  @override
  String get socialMediaLinks => 'Tautan sosial media';

  @override
  String get oneUrlPerLine => 'Satu tautan per baris.';

  @override
  String get inlineNotation => 'Notasi inline';

  @override
  String get makeAStudy => 'Untuk keperluan menyimpan dan membagi file, pertimbangkan untuk membuat sebuah study.';

  @override
  String get clearSavedMoves => 'Bersihkan gerakan';

  @override
  String get previouslyOnLichessTV => 'Sebelumnya di Lichess TV';

  @override
  String get onlinePlayers => 'Pemain online';

  @override
  String get activePlayers => 'Pemain aktif';

  @override
  String get bewareTheGameIsRatedButHasNoClock => 'Awas, permainan ini pake rating namun tanpa pake waktu!';

  @override
  String get success => 'Berhasil';

  @override
  String get automaticallyProceedToNextGameAfterMoving => 'Otomatis memproses permainan berikutnya setelah melangkah';

  @override
  String get autoSwitch => 'Pindah otomatis';

  @override
  String get puzzles => 'Taktik';

  @override
  String get onlineBots => 'Online bots';

  @override
  String get name => 'Nama';

  @override
  String get description => 'Keterangan';

  @override
  String get descPrivate => 'Deskripsi pribadi';

  @override
  String get descPrivateHelp => 'Teks yang hanya bisa dilihat oleh anggota tim. Jika ditetapkan, akan menggantikan deskripsi publik untuk anggota tim.';

  @override
  String get no => 'Tidak';

  @override
  String get yes => 'Ya';

  @override
  String get website => 'Situs Web';

  @override
  String get mobile => 'Mobile';

  @override
  String get help => 'Bantuan:';

  @override
  String get createANewTopic => 'Buat topik baru';

  @override
  String get topics => 'Topik';

  @override
  String get posts => 'Posting';

  @override
  String get lastPost => 'Posting terbaru';

  @override
  String get views => 'Penampilan';

  @override
  String get replies => 'Jawaban';

  @override
  String get replyToThisTopic => 'Jawab topik ini';

  @override
  String get reply => 'Jawab';

  @override
  String get message => 'Pesan';

  @override
  String get createTheTopic => 'Buat topik';

  @override
  String get reportAUser => 'Laporkan pengguna';

  @override
  String get user => 'Pengguna';

  @override
  String get reason => 'Alasan';

  @override
  String get whatIsIheMatter => 'Apa masalahnya?';

  @override
  String get cheat => 'Cheat';

  @override
  String get troll => 'Jebakan';

  @override
  String get other => 'Lainnya';

  @override
  String get reportCheatBoostHelp => 'Paste the link to the game(s) and explain what is wrong about this user\'s behaviour. Don\'t just say \"they cheat\", but tell us how you came to this conclusion.';

  @override
  String get reportUsernameHelp => 'Explain what about this username is offensive. Don\'t just say \"it\'s offensive/inappropriate\", but tell us how you came to this conclusion, especially if the insult is obfuscated, not in english, is in slang, or is a historical/cultural reference.';

  @override
  String get reportProcessedFasterInEnglish => 'Your report will be processed faster if written in English.';

  @override
  String get error_provideOneCheatedGameLink => 'Harap berikan setidaknya satu tautan ke permainan yang curang.';

  @override
  String by(String param) {
    return 'oleh $param';
  }

  @override
  String importedByX(String param) {
    return 'Diimpor oleh $param';
  }

  @override
  String get thisTopicIsNowClosed => 'Topik ini ditutup.';

  @override
  String get blog => 'Blog';

  @override
  String get notes => 'Catatan';

  @override
  String get typePrivateNotesHere => 'Ketik pesan pribadi di sini';

  @override
  String get writeAPrivateNoteAboutThisUser => 'Tulis catatan pribadi tentang pengguna ini';

  @override
  String get noNoteYet => 'Belum ada catatan';

  @override
  String get invalidUsernameOrPassword => 'Username dan atau password salah';

  @override
  String get incorrectPassword => 'Kata sandi salah';

  @override
  String get invalidAuthenticationCode => 'Kode autentikasi salah';

  @override
  String get emailMeALink => 'Emailkan ke saya sebuah link';

  @override
  String get currentPassword => 'Password saat ini';

  @override
  String get newPassword => 'Password baru';

  @override
  String get newPasswordAgain => 'Password baru (lagi)';

  @override
  String get newPasswordsDontMatch => 'Kata sandi baru tidak cocok';

  @override
  String get newPasswordStrength => 'Kekuatan Kata Sandi';

  @override
  String get clockInitialTime => 'Waktu awal';

  @override
  String get clockIncrement => 'Kenaikan waktu';

  @override
  String get privacy => 'Privasi';

  @override
  String get privacyPolicy => 'Kebijakan privasi';

  @override
  String get letOtherPlayersFollowYou => 'Biarkan pengguna lain mengikuti anda';

  @override
  String get letOtherPlayersChallengeYou => 'Biarkan pengguna lain menantang anda';

  @override
  String get letOtherPlayersInviteYouToStudy => 'Ijinkan pemain lain mengajak Anda untuk studi';

  @override
  String get sound => 'Suara';

  @override
  String get none => 'Tidak Ada';

  @override
  String get fast => 'Cepat';

  @override
  String get normal => 'Normal';

  @override
  String get slow => 'Lambat';

  @override
  String get insideTheBoard => 'Di dalam papan';

  @override
  String get outsideTheBoard => 'Di luar papan';

  @override
  String get allSquaresOfTheBoard => 'All squares of the board';

  @override
  String get onSlowGames => 'Pada catur klasik';

  @override
  String get always => 'Selalu';

  @override
  String get never => 'Tidak pernah';

  @override
  String xCompetesInY(String param1, String param2) {
    return '$param1 berkompetisi dalam $param2';
  }

  @override
  String get victory => 'Berhasil';

  @override
  String get defeat => 'Kalah';

  @override
  String victoryVsYInZ(String param1, String param2, String param3) {
    return '$param1 melawan $param2 dalam permainan $param3';
  }

  @override
  String defeatVsYInZ(String param1, String param2, String param3) {
    return '$param1 melawan $param2 dalam permainan $param3';
  }

  @override
  String drawVsYInZ(String param1, String param2, String param3) {
    return '$param1 melawan $param2 dalam permainan $param3';
  }

  @override
  String get timeline => 'Timeline';

  @override
  String get starting => 'Mulai:';

  @override
  String get allInformationIsPublicAndOptional => 'Semua informasi bersifat publik jika dikehendaki.';

  @override
  String get biographyDescription => 'Ceritakan tentang anda, apa yang anda sukai dalam catur, pembukaan kesukaan, permainan, pemain…';

  @override
  String get listBlockedPlayers => 'Daftar pengguna yang anda blokir';

  @override
  String get human => 'Manusia';

  @override
  String get computer => 'Komputer';

  @override
  String get side => 'Pihak';

  @override
  String get clock => 'Jam';

  @override
  String get opponent => 'Lawan';

  @override
  String get learnMenu => 'Materi';

  @override
  String get studyMenu => 'Studi';

  @override
  String get practice => 'Latihan';

  @override
  String get community => 'Komunitas';

  @override
  String get tools => 'Alat';

  @override
  String get increment => 'Kenaikan';

  @override
  String get error_unknown => 'Nilai tidak valid';

  @override
  String get error_required => 'Isian di sini diperlukan';

  @override
  String get error_email => 'Alamat e-mail ini tidak valid';

  @override
  String get error_email_acceptable => 'Alamat e-mail ini tidak dapat diterma. Pastikan kembali e-mail Anda, lalu coba lagi.';

  @override
  String get error_email_unique => 'Alamat e-mail tidak valid atau sudah dipakai';

  @override
  String get error_email_different => 'Ini sudah menjadi alamat e-mail Anda';

  @override
  String error_minLength(String param) {
    return 'Panjang minimum adalah $param';
  }

  @override
  String error_maxLength(String param) {
    return 'Panjang maksimum adalah $param';
  }

  @override
  String error_min(String param) {
    return 'Harus lebih besar atau sama dengan $param';
  }

  @override
  String error_max(String param) {
    return 'Harus kurang atau sama dengan $param';
  }

  @override
  String ifRatingIsPlusMinusX(String param) {
    return 'Jika ratingnya ± $param';
  }

  @override
  String get ifRegistered => 'Telah terdaftar';

  @override
  String get onlyExistingConversations => 'Khusus percakapan yang ada';

  @override
  String get onlyFriends => 'Hanya teman';

  @override
  String get menu => 'Menu';

  @override
  String get castling => 'Rokade';

  @override
  String get whiteCastlingKingside => 'Putih O-O';

  @override
  String get blackCastlingKingside => 'Hitam O-O';

  @override
  String tpTimeSpentPlaying(String param) {
    return 'Waktu sisa permainan: $param';
  }

  @override
  String get watchGames => 'Menonton permainan';

  @override
  String tpTimeSpentOnTV(String param) {
    return 'Waktu pada TV: $param';
  }

  @override
  String get watch => 'Tonton';

  @override
  String get videoLibrary => 'Pustaka Video';

  @override
  String get streamersMenu => 'Penonton';

  @override
  String get mobileApp => 'Aplikasi Mobile';

  @override
  String get webmasters => 'Webmaster';

  @override
  String get about => 'Tentang';

  @override
  String aboutX(String param) {
    return 'Tentang $param';
  }

  @override
  String xIsAFreeYLibreOpenSourceChessServer(String param1, String param2) {
    return '$param1 adalah server catur yang ($param2) gratis, tanpa iklan, dan sumber terbuka.';
  }

  @override
  String get really => 'benar-benar';

  @override
  String get contribute => 'Kontribusi';

  @override
  String get termsOfService => 'Ketentuan Layanan (ToS)';

  @override
  String get sourceCode => 'Kode Sumber';

  @override
  String get simultaneousExhibitions => 'Eksibisi Simultan';

  @override
  String get host => 'Penyedia';

  @override
  String hostColorX(String param) {
    return 'Warna host: $param';
  }

  @override
  String get yourPendingSimuls => 'Simul anda yang tertunda';

  @override
  String get createdSimuls => 'Membuat Simultan baru';

  @override
  String get hostANewSimul => 'Penyedia Simultan baru';

  @override
  String get signUpToHostOrJoinASimul => 'Daftar untuk membuat atau bergabung pada simul';

  @override
  String get noSimulFound => 'Simultan tidak ada';

  @override
  String get noSimulExplanation => 'Eksibisi simultan ini tidak ada';

  @override
  String get returnToSimulHomepage => 'Kembali ke halaman Simultan';

  @override
  String get aboutSimul => 'Simultan adalah seoran pemain lawan banyak lawan dalam satu saat.';

  @override
  String get aboutSimulImage => 'Sampai 50 lawan, Fischer menang 47 partai, 2 remis dan 1 kekalahan.';

  @override
  String get aboutSimulRealLife => 'Konsep ini seperti dalam dunia nyata. Dalam dunia nyata, ini dilakukan oleh pensimultan yang bergerak dari meja ke meja yang memainkan sebuah langkah.';

  @override
  String get aboutSimulRules => 'Saat Simultan dimulai, setiap pemain melawan penyedia, yang bermain sebagai buah putih. Simultan berakhir jika seluruh partai telah selesai dimainkan.';

  @override
  String get aboutSimulSettings => 'Simultan selalu sederhana, tanding ulang, langkah balik dan tambahan waktu tidak diijinkan.';

  @override
  String get create => 'Buat baru';

  @override
  String get whenCreateSimul => 'Ketika anda membuat Simultan, anda akan bertemu banyak lawan dalam satu saat.';

  @override
  String get simulVariantsHint => 'Jika anda memilih banyak varian, setiap pemain bisa memilih yang dimainkan.';

  @override
  String get simulClockHint => 'Aturan Jam Fischer: Semakin banyak peserta yang ikut, semakin banyak waktu diperlukan.';

  @override
  String get simulAddExtraTime => 'Anda bisa menambah waktu pada jam anda untuk membantu simultan anda';

  @override
  String get simulHostExtraTime => 'Penyedia waktu tambahan';

  @override
  String get simulAddExtraTimePerPlayer => 'Tambahkan waktu awal kepada jam anda untuk setiap pemain yang bergabung ke simul.';

  @override
  String get simulHostExtraTimePerPlayer => 'Waktu tambahan tuan rumah setiap pemain baru simul';

  @override
  String get lichessTournaments => 'Turnamen Lichess';

  @override
  String get tournamentFAQ => 'Arena Turnamen FAQ';

  @override
  String get timeBeforeTournamentStarts => 'Waktu sebelum turnamen dimulai';

  @override
  String get averageCentipawnLoss => 'Rata-rata poin kekalahan';

  @override
  String get accuracy => 'Akurasi';

  @override
  String get keyboardShortcuts => 'Tombol pintas keyboard';

  @override
  String get keyMoveBackwardOrForward => 'Mundurkan/Majukan';

  @override
  String get keyGoToStartOrEnd => 'Ke awal/akhir';

  @override
  String get keyCycleSelectedVariation => 'Cycle selected variation';

  @override
  String get keyShowOrHideComments => 'Tampilkan/sembunyikan komentar';

  @override
  String get keyEnterOrExitVariation => 'masuk/keluar dari variasi';

  @override
  String get keyRequestComputerAnalysis => 'Minta analisis komputer, belajar dari kesalahan anda';

  @override
  String get keyNextLearnFromYourMistakes => 'Berikutnya (Belajar dari kesalahan anda)';

  @override
  String get keyNextBlunder => 'Blunder selanjutnya';

  @override
  String get keyNextMistake => 'Kesalahan berikutnya';

  @override
  String get keyNextInaccuracy => 'Ketidakakuratan selanjutnya';

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
  String get playSelectedMove => 'mainkan gerakan terpilih';

  @override
  String get newTournament => 'Turnamen baru';

  @override
  String get tournamentHomeTitle => 'Turnamen catur dengan menampilkan berbagai kontrol waktu dan beberapa varian';

  @override
  String get tournamentHomeDescription => 'Turnamen catur cepat! ikuti jadwal pertandingan yang telah kami atur, atau buat sesuai keinginanmu.  bullet, blitz, classical, chess960, king of the hill, tiga langkah mati, dan banyak lagi pilihan yang tersedia untuk kesenangan bercatur yang tiada habisnya.';

  @override
  String get tournamentNotFound => 'Turnamen tidak ditemukan';

  @override
  String get tournamentDoesNotExist => 'Turnamen tidak ada';

  @override
  String get tournamentMayHaveBeenCanceled => 'turnamen harus dibatalkan, jika semua pemain meninggalkannya sebelum turnamen dimulai.';

  @override
  String get returnToTournamentsHomepage => 'Kembali ke laman turnamen';

  @override
  String weeklyPerfTypeRatingDistribution(String param) {
    return 'Distribusi rating $param bulanan';
  }

  @override
  String yourPerfTypeRatingIsRating(String param1, String param2) {
    return 'Rating $param1 anda adalah $param2';
  }

  @override
  String youAreBetterThanPercentOfPerfTypePlayers(String param1, String param2) {
    return 'Anda lebih baik daripada $param1 pemain $param2 lainnya';
  }

  @override
  String userIsBetterThanPercentOfPerfTypePlayers(String param1, String param2, String param3) {
    return '$param1 lebih baik daripada $param2 dari $param3 pemain.';
  }

  @override
  String betterThanPercentPlayers(String param1, String param2) {
    return 'Anda lebih baik $param1 dari $param2 pemain lainnya';
  }

  @override
  String youDoNotHaveAnEstablishedPerfTypeRating(String param) {
    return 'Anda tidak punya rating $param mapan';
  }

  @override
  String get yourRating => 'Rating Anda';

  @override
  String get cumulative => 'Kumulatif';

  @override
  String get glicko2Rating => 'Rating Glicko-2';

  @override
  String get checkYourEmail => 'Cek email mu';

  @override
  String get weHaveSentYouAnEmailClickTheLink => 'Kami telah mengirim Anda sebuah email. Buka link di dalam email untuk mengaktivasi akun Anda.';

  @override
  String get ifYouDoNotSeeTheEmailCheckOtherPlaces => 'Jika anda tidak melihat surel, cek tempat-tempat lain; seperti junk, spam, sosial, atau berkas lainnya';

  @override
  String weHaveSentYouAnEmailTo(String param) {
    return 'Kami telah mengirim surel kepada $param. Klik tautan di dalam surel untuk mengubah kata sandi anda.';
  }

  @override
  String byRegisteringYouAgreeToBeBoundByOur(String param) {
    return 'Dengan mendaftar, anda setuju untuk terikat dengan $param kita.';
  }

  @override
  String readAboutOur(String param) {
    return 'Baca tentang $param kami.';
  }

  @override
  String get networkLagBetweenYouAndLichess => 'Hambatan jaringan antara anda dan lichess.';

  @override
  String get timeToProcessAMoveOnLichessServer => 'Waktu untuk memproses suatu langkah dalam server lichess';

  @override
  String get downloadAnnotated => 'Unduh versi anotasi';

  @override
  String get downloadRaw => 'Unduh mentah';

  @override
  String get downloadImported => 'Unduh permainan yang telah dimasukkan';

  @override
  String get crosstable => 'Napak tilas';

  @override
  String get youCanAlsoScrollOverTheBoardToMoveInTheGame => 'Anda juga bisa menggunakan scroll untuk bergerak dalam permainan.';

  @override
  String get scrollOverComputerVariationsToPreviewThem => 'Letakkan mouse diatas variasi komputer untuk meninjau hal tersebut.';

  @override
  String get analysisShapesHowTo => 'Tekan shift+klik atau klik-kanan untuk menggambar lingkaran dan panah di papan.';

  @override
  String get letOtherPlayersMessageYou => 'Memperbolehkan pemain lain mengirim pesan untuk Anda';

  @override
  String get receiveForumNotifications => 'Menerima notifikasi ketika disebut/mention dalam forum';

  @override
  String get shareYourInsightsData => 'Berbagi data permainan anda';

  @override
  String get withNobody => 'Tidak dengan siapapun';

  @override
  String get withFriends => 'Dengan teman';

  @override
  String get withEverybody => 'Dengan semua orang';

  @override
  String get kidMode => 'Mode anak';

  @override
  String get kidModeIsEnabled => 'Kid mode is enabled.';

  @override
  String get kidModeExplanation => 'Ini adalah tentang keselamatan. Dalam modus anak, semua situs komunikasi dinonaktifkan. Mengaktifkan ini untuk anak-anak Anda dan sekolah siswa, untuk melindungi mereka dari pengguna internet yang lain.';

  @override
  String inKidModeTheLichessLogoGetsIconX(String param) {
    return 'Dalam modus anak, lichess logo mendapat ikon $param, sehingga Anda tahu anak-anak Anda aman.';
  }

  @override
  String get askYourChessTeacherAboutLiftingKidMode => 'Akun anda dimanjemen. Tanya pelatih catur anda untuk menghapus mode anak-anak.';

  @override
  String get enableKidMode => 'Mengaktifkan mode anak';

  @override
  String get disableKidMode => 'Menonaktifkan modus anak';

  @override
  String get security => 'Keamanan';

  @override
  String get sessions => 'Sesi';

  @override
  String get revokeAllSessions => 'mencabut semua sesi';

  @override
  String get playChessEverywhere => 'Bermain catur dimanapun';

  @override
  String get everybodyGetsAllFeaturesForFree => 'Semua pengguna mendapatkan seluruh fitur dengan gratis';

  @override
  String get viewTheSolution => 'Lihat jawaban';

  @override
  String get noChallenges => 'No challenges.';

  @override
  String xHostsY(String param1, String param2) {
    return '$param1 tuan rumah $param2';
  }

  @override
  String xJoinsY(String param1, String param2) {
    return '$param1 bergabung $param2';
  }

  @override
  String xLikesY(String param1, String param2) {
    return '$param1 suka $param2';
  }

  @override
  String get quickPairing => 'Pencarian cepat';

  @override
  String get lobby => 'Ruang Lobi';

  @override
  String get anonymous => 'Tanpa Nama';

  @override
  String yourScore(String param) {
    return 'Skor Anda: $param';
  }

  @override
  String get language => 'Bahasa';

  @override
  String get background => 'Latar';

  @override
  String get light => 'Terang';

  @override
  String get dark => 'Gelap';

  @override
  String get transparent => 'Tembus pandang';

  @override
  String get deviceTheme => 'Tema perangkat';

  @override
  String get backgroundImageUrl => 'URL gambar latar belakang:';

  @override
  String get board => 'Papan';

  @override
  String get size => 'Ukuran';

  @override
  String get opacity => 'Transparansi';

  @override
  String get brightness => 'Kecerahan';

  @override
  String get hue => 'Rona';

  @override
  String get boardReset => 'Kembalikan warna ke pengaturan semula';

  @override
  String get pieceSet => 'Susunan buah catur';

  @override
  String get embedInYourWebsite => 'Salin dalam website Anda';

  @override
  String get usernameAlreadyUsed => 'Nama pengguna ini sudah digunakan, coba yang lain.';

  @override
  String get usernamePrefixInvalid => 'Nama pengguna harus berawal huruf.';

  @override
  String get usernameSuffixInvalid => 'Nama pengguna harus berakhiran dengan huruf atau angka.';

  @override
  String get usernameCharsInvalid => 'Nama pengguna hanya boleh mengandung huruf, garisbawah, dan tanda hubung.';

  @override
  String get usernameUnacceptable => 'Nama pengguna ini tidak dapat diterima.';

  @override
  String get playChessInStyle => 'Bermain catur dengan gaya';

  @override
  String get chessBasics => 'Dasar-dasar permainan catur';

  @override
  String get coaches => 'Pelatih';

  @override
  String get invalidPgn => 'PGN tidak valid';

  @override
  String get invalidFen => 'FEN tidak valid';

  @override
  String get custom => 'Atur';

  @override
  String get notifications => 'Notifikasi';

  @override
  String notificationsX(String param1) {
    return 'Pemberitahuan: $param1';
  }

  @override
  String perfRatingX(String param) {
    return 'Rating: $param';
  }

  @override
  String get practiceWithComputer => 'Praktis dengan komputer';

  @override
  String anotherWasX(String param) {
    return 'Lainnya $param';
  }

  @override
  String bestWasX(String param) {
    return 'Terbaik adalah $param';
  }

  @override
  String get youBrowsedAway => 'Anda melihat-lihat';

  @override
  String get resumePractice => 'Lanjutkan latihan';

  @override
  String get drawByFiftyMoves => 'Permainan remis karena aturan 50 langkah.';

  @override
  String get theGameIsADraw => 'Permainan ini menarik.';

  @override
  String get computerThinking => 'Komputer berpikir ...';

  @override
  String get seeBestMove => 'Lihat langkah terbaik';

  @override
  String get hideBestMove => 'Sembunyikan langkah terbaik';

  @override
  String get getAHint => 'Dapatkan petunjuk';

  @override
  String get evaluatingYourMove => 'Mengevaluasi langkah anda ...';

  @override
  String get whiteWinsGame => 'Putih menang';

  @override
  String get blackWinsGame => 'Hitam menang';

  @override
  String get learnFromYourMistakes => 'Pelajaran dari kesalahanmu';

  @override
  String get learnFromThisMistake => 'Pelajari dari kesalahan ini';

  @override
  String get skipThisMove => 'Lewatkan langkah ini';

  @override
  String get next => 'Selanjutnya';

  @override
  String xWasPlayed(String param) {
    return '$param sedang diamainkan';
  }

  @override
  String get findBetterMoveForWhite => 'Temukan langkah yang lebih baik untuk warna putih';

  @override
  String get findBetterMoveForBlack => 'Temukan langkah yang lebih baik untuk warna hitam';

  @override
  String get resumeLearning => 'Lanjutkan materi';

  @override
  String get youCanDoBetter => 'Kamu bisa melakukan lebih baik';

  @override
  String get tryAnotherMoveForWhite => 'Coba langkah lain untuk putih';

  @override
  String get tryAnotherMoveForBlack => 'Coba langkah lain untuk hitam';

  @override
  String get solution => 'Solusi';

  @override
  String get waitingForAnalysis => 'Tunggu untuk menganalisa';

  @override
  String get noMistakesFoundForWhite => 'Tidak ditemukan kesalahan untuk putih';

  @override
  String get noMistakesFoundForBlack => 'Tidak ditemukan kesalahan untuk hitam';

  @override
  String get doneReviewingWhiteMistakes => 'Selesai mempelajari kesalahan putih';

  @override
  String get doneReviewingBlackMistakes => 'Selesai mempelajari kesalahan hitam';

  @override
  String get doItAgain => 'Lakukan lagi';

  @override
  String get reviewWhiteMistakes => 'Review kesalahan putih';

  @override
  String get reviewBlackMistakes => 'Review kesalahan hitam';

  @override
  String get advantage => 'Keuntungan';

  @override
  String get opening => 'Pembuka';

  @override
  String get middlegame => 'Setengah permainan';

  @override
  String get endgame => 'Akhir permainan';

  @override
  String get conditionalPremoves => 'Syarat pra-langkah';

  @override
  String get addCurrentVariation => 'Tambahkan variasi';

  @override
  String get playVariationToCreateConditionalPremoves => 'Memainkan sebuah variasi untuk membuat syarat pra-langkah';

  @override
  String get noConditionalPremoves => 'Tidak ada syarat pra-langkah';

  @override
  String playX(String param) {
    return 'Memainkan $param';
  }

  @override
  String get showUnreadLichessMessage => 'Anda telah menerima pesan pribadi dari Lichess.';

  @override
  String get clickHereToReadIt => 'Klik di sini untuk membaca';

  @override
  String get sorry => 'Maaf :(';

  @override
  String get weHadToTimeYouOutForAWhile => 'Kami harus mengatur waktu Anda untuk sementara waktu.';

  @override
  String get why => 'Mengapa?';

  @override
  String get pleasantChessExperience => 'Kami bertujuan dan menjaga untuk memberikan pengalaman catur yang menyenangkan bagi semua orang.';

  @override
  String get goodPractice => 'Untuk itu, kami harus memastikan bahwa semua pemain harus mengikuti perlakuan yang baik.';

  @override
  String get potentialProblem => 'Ketika potensi menimbulkan masalah terdeteksi, kami menampilkan pesan ini.';

  @override
  String get howToAvoidThis => 'Bagaimana cara untuk menghindari ini?';

  @override
  String get playEveryGame => 'Mainkan setiap permainan yang kamu mulai.';

  @override
  String get tryToWin => 'Usahakan untuk menang (atau setidaknya remis) disetiap permainan yang kau mainkan.';

  @override
  String get resignLostGames => 'Ajukan menyerah untuk permainan yang kalah (jangan sampai waktu habis).';

  @override
  String get temporaryInconvenience => 'Kami mohon maaf atas ketidaknyamanan ini,';

  @override
  String get wishYouGreatGames => 'dan doakan Anda untuk mendapatkan pengalaman bermain yang hebat di lichess.org.';

  @override
  String get thankYouForReading => 'Terima kasih sudah membacanya!';

  @override
  String get lifetimeScore => 'Skor seumur hidup';

  @override
  String get currentMatchScore => 'Skor pertandingan saat ini';

  @override
  String get agreementAssistance => 'Saya menyetujui bahwa saya tidak akan pernah menerima bantuan selama pertandingan (dari komputer catur, buku, database ataupun orang lain).';

  @override
  String get agreementNice => 'Saya menyetujui bahwa saya akan selalu bersikap baik kepada pemain lain.';

  @override
  String agreementMultipleAccounts(String param) {
    return 'Saya setuju untuk tidak membuat banyak akun (kecuali untuk alasan yang tertera di $param).';
  }

  @override
  String get agreementPolicy => 'Saya menyetujui bahwa saya akan mengikuti semua kebijakan yang ada di Lichess.';

  @override
  String get searchOrStartNewDiscussion => 'Cari atau mulai diskusi baru';

  @override
  String get edit => 'Ubah';

  @override
  String get bullet => 'Peluru';

  @override
  String get blitz => 'Blitz';

  @override
  String get rapid => 'Cepat';

  @override
  String get classical => 'Klasikal';

  @override
  String get ultraBulletDesc => 'Sangat-sangat cepat: kurang dari 30 detik';

  @override
  String get bulletDesc => 'Sangat cepat: kurang dari 3 menit';

  @override
  String get blitzDesc => 'Permainan cepat: 3 hingga 8 menit';

  @override
  String get rapidDesc => 'Permainan rapid: 8 hingga 25 menit';

  @override
  String get classicalDesc => 'Permainan klasikal: 25 menit atau lebih';

  @override
  String get correspondenceDesc => 'Permainan korespondensi: satu atau beberapa hari dalam satu langkah';

  @override
  String get puzzleDesc => 'Pelatih taktik catur';

  @override
  String get important => 'Penting';

  @override
  String yourQuestionMayHaveBeenAnswered(String param1) {
    return 'Pertanyaan anda mungkin sudah terjawab $param1';
  }

  @override
  String get inTheFAQ => 'di Pertanyaan umum';

  @override
  String toReportSomeoneForCheatingOrBadBehavior(String param1) {
    return 'Untuk melaporkan pengguna atas kecurangan atau kelakuan buruk, $param1';
  }

  @override
  String get useTheReportForm => 'gunakan form pelaporan';

  @override
  String toRequestSupport(String param1) {
    return 'Untuk meminta bantuan, $param1';
  }

  @override
  String get tryTheContactPage => 'silakan lihat laman kontak';

  @override
  String makeSureToRead(String param1) {
    return 'Pastilkan membaca $param1';
  }

  @override
  String get theForumEtiquette => 'etika forum';

  @override
  String get thisTopicIsArchived => 'Topik ini sudah diarsipkan dan tidak dapat dibalas.';

  @override
  String joinTheTeamXToPost(String param1) {
    return 'Gabung dengan $param1, untuk posting di forum ini';
  }

  @override
  String teamNamedX(String param1) {
    return 'tim $param1';
  }

  @override
  String get youCannotPostYetPlaySomeGames => 'Anda belum bisa mengirim pos di forum ini. Mainkan beberapa permainan!';

  @override
  String get subscribe => 'Berlangganan';

  @override
  String get unsubscribe => 'Berhenti berlangganan';

  @override
  String mentionedYouInX(String param1) {
    return 'membahas anda di \"$param1\".';
  }

  @override
  String xMentionedYouInY(String param1, String param2) {
    return '$param1 membahas anda di \"$param2\".';
  }

  @override
  String invitedYouToX(String param1) {
    return 'mengundang anda ke \"$param1\".';
  }

  @override
  String xInvitedYouToY(String param1, String param2) {
    return '$param1 mengundang ke \"$param2\".';
  }

  @override
  String get youAreNowPartOfTeam => 'Anda sekarang bagian dalam tim.';

  @override
  String youHaveJoinedTeamX(String param1) {
    return 'Anda sudah bergabung \"$param1\".';
  }

  @override
  String get someoneYouReportedWasBanned => 'Seseorang yang Anda laporkan telah di-ban';

  @override
  String get congratsYouWon => 'Selamat, kamu menang!';

  @override
  String gameVsX(String param1) {
    return 'Game vs $param1';
  }

  @override
  String resVsX(String param1, String param2) {
    return '$param1 vs $param2';
  }

  @override
  String get lostAgainstTOSViolator => 'Anda kalah dari seseorang yang melanggar TOS Lichess';

  @override
  String refundXpointsTimeControlY(String param1, String param2) {
    return 'Pengembalian dana: $param1 $param2 poin rating.';
  }

  @override
  String get timeAlmostUp => 'Waktu hampir habis!';

  @override
  String get clickToRevealEmailAddress => '[Klik untuk memunculkan alamat email]';

  @override
  String get download => 'Unduh';

  @override
  String get coachManager => 'Manajer pelatih';

  @override
  String get streamerManager => 'Manajer stream';

  @override
  String get cancelTournament => 'Batalkan turnamen';

  @override
  String get tournDescription => 'Deskripsi turnamen';

  @override
  String get tournDescriptionHelp => 'Adakah sesuatu yang spesial yang Anda ingin katakan kepada peserta? Coba buat pendek saja. Tautan Markdown tersedia: [name] (https://url)';

  @override
  String get ratedFormHelp => 'Permainan dinilai \ndan berdampak pada peringkat pemain';

  @override
  String get onlyMembersOfTeam => 'Hanya anggota dari tim';

  @override
  String get noRestriction => 'Tidak ada pembatasan';

  @override
  String get minimumRatedGames => 'Permainan di nilai minimum';

  @override
  String get minimumRating => 'Peringkat minimum';

  @override
  String get maximumWeeklyRating => 'Peringkat mingguan maksimum';

  @override
  String positionInputHelp(String param) {
    return 'Tempelkan sebuah FEN yang valid untuk memulai setiap game dari posisi yang diberikan.\nIni hanya berfungsi untuk game standar, bukan yang dengan variasi.\nAnda dapat menggunakan $param untuk menghasilkan sebuah posisi FEN, lalu tempel di sini.\nKosongkan untuk memulai permainan dari posisi awal yang normal.';
  }

  @override
  String get cancelSimul => 'Batalkan simulasi';

  @override
  String get simulHostcolor => 'Pilih warna untuk setiap permainan';

  @override
  String get estimatedStart => 'Waktu estimasi mulai';

  @override
  String simulFeatured(String param) {
    return 'Tersedia di $param';
  }

  @override
  String simulFeaturedHelp(String param) {
    return 'Tampilkan simulasi Anda ke semua orang pada $param. Nonaktifkan untuk simulasi pribadi.';
  }

  @override
  String get simulDescription => 'Deskripsi simulasi';

  @override
  String get simulDescriptionHelp => 'Adakah sesuatu yang ingin Anda sampaikan pada peserta?';

  @override
  String markdownAvailable(String param) {
    return '$param tersedia untuk sintaks lebih lanjut.';
  }

  @override
  String get embedsAvailable => 'Paste a game URL or a study chapter URL to embed it.';

  @override
  String get inYourLocalTimezone => 'Di zona waktu lokal Anda';

  @override
  String get tournChat => 'Obrolan turnamen';

  @override
  String get noChat => 'Tanpa obrolan';

  @override
  String get onlyTeamLeaders => 'Hanya pemimpin tim';

  @override
  String get onlyTeamMembers => 'Hanya anggota tim';

  @override
  String get navigateMoveTree => 'Navigasi gerakan partai';

  @override
  String get mouseTricks => 'Trik pada tetikus/mouse';

  @override
  String get toggleLocalAnalysis => 'Nyala / mati analisa komputer lokal';

  @override
  String get toggleAllAnalysis => 'Nyala / mati semua analisa komputer';

  @override
  String get playComputerMove => 'Langkahkan gerakan terbaik komputer';

  @override
  String get analysisOptions => 'Setelan analisa';

  @override
  String get focusChat => 'Fokus pada kotak obroloan';

  @override
  String get showHelpDialog => 'Tampilkan halaman bantuan ini';

  @override
  String get reopenYourAccount => 'Buka kembali akun Anda';

  @override
  String get reopenYourAccountDescription => 'If you closed your account, but have since changed your mind, you get a chance of getting your account back.';

  @override
  String get emailAssociatedToaccount => 'Alamat e-mail yang terkait dengan akun ini';

  @override
  String get sentEmailWithLink => 'Kami telah mengirimkan Anda email dengan tautan.';

  @override
  String get tournamentEntryCode => 'Kode masuk turnamen';

  @override
  String get hangOn => 'Tunggu sebentar!';

  @override
  String gameInProgress(String param) {
    return 'Permainan anda dengan $param masih sedang berlangsung.';
  }

  @override
  String get abortTheGame => 'Batalkan permainan';

  @override
  String get resignTheGame => 'Menyerah dari permainan';

  @override
  String get youCantStartNewGame => 'Anda tidak dapat memulai permainan baru sampai permainan ini selesai.';

  @override
  String get since => 'Sejak';

  @override
  String get until => 'Hingga';

  @override
  String get lichessDbExplanation => 'Partai diambil dari semua pemain rated Lichess';

  @override
  String get switchSides => 'Tukar Sisi';

  @override
  String get closingAccountWithdrawAppeal => 'Menutup akun anda akan menarik permohonan banding';

  @override
  String get ourEventTips => 'Tips dari kami terkait penyelenggaraan acara';

  @override
  String get instructions => 'Instruksi';

  @override
  String get showMeEverything => 'Tunjukkan semuanya';

  @override
  String get lichessPatronInfo => 'Lichess adalah sebuah amal dan semuanya merupakan perangkat lunak sumber terbuka yang gratis/bebas.\nSemua biaya operasi, pengembangan, dan konten didanai sepenuhnya oleh donasi pengguna.';

  @override
  String get nothingToSeeHere => 'Tidak ada yang bisa dilihat untuk saat ini.';

  @override
  String get stats => 'Stats';

  @override
  String opponentLeftCounter(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Lawanmu telah meninggalkan permainan. Anda dapat mengklaim kemenangan dalam $count detik.',
    );
    return '$_temp0';
  }

  @override
  String mateInXHalfMoves(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Mati $count di pertengahan langkah',
    );
    return '$_temp0';
  }

  @override
  String nbBlunders(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count blunder',
    );
    return '$_temp0';
  }

  @override
  String numberBlunders(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Blunder',
    );
    return '$_temp0';
  }

  @override
  String nbMistakes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count kesalahan',
    );
    return '$_temp0';
  }

  @override
  String numberMistakes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Kesalahan',
    );
    return '$_temp0';
  }

  @override
  String nbInaccuracies(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ketidaktepatan',
    );
    return '$_temp0';
  }

  @override
  String numberInaccuracies(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Ketidaktepatan',
    );
    return '$_temp0';
  }

  @override
  String nbPlayers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count pemain tersambung',
    );
    return '$_temp0';
  }

  @override
  String nbGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Lihat semua $count Permainan',
    );
    return '$_temp0';
  }

  @override
  String ratingXOverYGames(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count rating dengan $param2 pertandingan',
    );
    return '$_temp0';
  }

  @override
  String nbBookmarks(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Permainan ditandai',
    );
    return '$_temp0';
  }

  @override
  String nbDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count hari',
    );
    return '$_temp0';
  }

  @override
  String nbHours(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count jam',
    );
    return '$_temp0';
  }

  @override
  String nbMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count menit',
    );
    return '$_temp0';
  }

  @override
  String rankIsUpdatedEveryNbMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Peringkat update setiap $count menit',
    );
    return '$_temp0';
  }

  @override
  String nbPuzzles(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count taktik',
    );
    return '$_temp0';
  }

  @override
  String nbGamesWithYou(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count kali bermain dengan anda',
    );
    return '$_temp0';
  }

  @override
  String nbRated(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count dengan rating',
    );
    return '$_temp0';
  }

  @override
  String nbWins(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count menang',
    );
    return '$_temp0';
  }

  @override
  String nbLosses(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count kalah',
    );
    return '$_temp0';
  }

  @override
  String nbDraws(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count imbang',
    );
    return '$_temp0';
  }

  @override
  String nbPlaying(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Sedang bermain',
    );
    return '$_temp0';
  }

  @override
  String giveNbSeconds(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Berikan $count detik',
    );
    return '$_temp0';
  }

  @override
  String nbTournamentPoints(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count poin turnamen',
    );
    return '$_temp0';
  }

  @override
  String nbStudies(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count studi',
    );
    return '$_temp0';
  }

  @override
  String nbSimuls(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count eksibisi simultan',
    );
    return '$_temp0';
  }

  @override
  String moreThanNbRatedGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Hanya boleh ≥ $count permainan yang di-rating',
    );
    return '$_temp0';
  }

  @override
  String moreThanNbPerfRatedGames(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Hanya boleh dengan rating ≥ $count dipermainan $param2 yang dirating',
    );
    return '$_temp0';
  }

  @override
  String needNbMorePerfGames(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Kamu perlu bermain $count lebih banyak permainan $param2 yang di-rating',
    );
    return '$_temp0';
  }

  @override
  String needNbMoreGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Kamu perlu bermain $count lebih banyak permainan yang di-rating',
    );
    return '$_temp0';
  }

  @override
  String nbImportedGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count permainan telah dimasukkan',
    );
    return '$_temp0';
  }

  @override
  String nbFriendsOnline(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count teman online',
    );
    return '$_temp0';
  }

  @override
  String nbFollowers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count pengikut',
    );
    return '$_temp0';
  }

  @override
  String nbFollowing(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count mengikuti',
    );
    return '$_temp0';
  }

  @override
  String lessThanNbMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Kurang dari $count menit',
    );
    return '$_temp0';
  }

  @override
  String nbGamesInPlay(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count pertandingan sedang berlangsung',
    );
    return '$_temp0';
  }

  @override
  String maximumNbCharacters(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Maksimal: $count karakter',
    );
    return '$_temp0';
  }

  @override
  String blocks(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count diblokir',
    );
    return '$_temp0';
  }

  @override
  String nbForumPosts(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Postingan Forum',
    );
    return '$_temp0';
  }

  @override
  String nbPerfTypePlayersThisWeek(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count $param2 pemain minggu ini.',
    );
    return '$_temp0';
  }

  @override
  String availableInNbLanguages(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Tersedia di dalam $count bahasa!',
    );
    return '$_temp0';
  }

  @override
  String nbSecondsToPlayTheFirstMove(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count detik untuk memainkan langkah pertama',
    );
    return '$_temp0';
  }

  @override
  String nbSeconds(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count detik',
    );
    return '$_temp0';
  }

  @override
  String andSaveNbPremoveLines(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'dan simpan $count baris pra-langkah',
    );
    return '$_temp0';
  }

  @override
  String get stormMoveToStart => 'Melangkah untuk memulai';

  @override
  String get stormYouPlayTheWhitePiecesInAllPuzzles => 'Anda memainkan bidak putih di semua taktik';

  @override
  String get stormYouPlayTheBlackPiecesInAllPuzzles => 'Anda memainkan bidak hitam di semua taktik';

  @override
  String get stormPuzzlesSolved => 'teka-teki terpecahkan';

  @override
  String get stormNewDailyHighscore => 'Skor tertinggi harian terbaru!';

  @override
  String get stormNewWeeklyHighscore => 'Skor tertinggi mingguan terbaru!';

  @override
  String get stormNewMonthlyHighscore => 'Skor tertinggi bulanan terbaru!';

  @override
  String get stormNewAllTimeHighscore => 'Skor tertinggi terbaru!';

  @override
  String stormPreviousHighscoreWasX(String param) {
    return 'Skor tertinggi sebelumnya $param';
  }

  @override
  String get stormPlayAgain => 'Mainkan lagi';

  @override
  String stormHighscoreX(String param) {
    return 'Skor tertinggi: $param';
  }

  @override
  String get stormScore => 'Skor';

  @override
  String get stormMoves => 'Langkah';

  @override
  String get stormAccuracy => 'Akurasi';

  @override
  String get stormCombo => 'Kombo';

  @override
  String get stormTime => 'Waktu';

  @override
  String get stormTimePerMove => 'Waktu per langkah';

  @override
  String get stormHighestSolved => 'Terpecahkan tertinggi';

  @override
  String get stormPuzzlesPlayed => 'Teka-teki dimainkan';

  @override
  String get stormNewRun => 'Mulai baru (tombol: Space)';

  @override
  String get stormEndRun => 'Akhiri (tombol: Enter)';

  @override
  String get stormHighscores => 'Skor tertinggi';

  @override
  String get stormViewBestRuns => 'Lihat hasil terbaik';

  @override
  String get stormBestRunOfDay => 'Hasil terbaik hari ini';

  @override
  String get stormRuns => 'Berjalan';

  @override
  String get stormGetReady => 'Ayo mulai!';

  @override
  String get stormWaitingForMorePlayers => 'Menunggu pemain lain untuk bergabung...';

  @override
  String get stormRaceComplete => 'Pertandingan selesai!';

  @override
  String get stormSpectating => 'Menonton';

  @override
  String get stormJoinTheRace => 'Ikuti pertandingan!';

  @override
  String get stormStartTheRace => 'Mulai balapan';

  @override
  String stormYourRankX(String param) {
    return 'Peringkat anda: $param';
  }

  @override
  String get stormWaitForRematch => 'Tunggu permainan ulang';

  @override
  String get stormNextRace => 'Balapan selanjutnya';

  @override
  String get stormJoinRematch => 'Gabung permainan ulang';

  @override
  String get stormWaitingToStart => 'Tunggu mulai';

  @override
  String get stormCreateNewGame => 'Buat permainan baru';

  @override
  String get stormJoinPublicRace => 'Ikut pertandingan umum';

  @override
  String get stormRaceYourFriends => 'Tanding teman Anda';

  @override
  String get stormSkip => 'lewati';

  @override
  String get stormSkipHelp => 'Anda dapat melewati satu gerakan per pertandingan:';

  @override
  String get stormSkipExplanation => 'Lewati gerakan ini untuk mempertahankan kombo Anda! Hanya bekerja sekali per pertandingan.';

  @override
  String get stormFailedPuzzles => 'Teka-teki yang gagal';

  @override
  String get stormSlowPuzzles => 'Teka-teki yang memakan waktu';

  @override
  String get stormSkippedPuzzle => 'Puzzle yang dilewati';

  @override
  String get stormThisWeek => 'Minggu ini';

  @override
  String get stormThisMonth => 'Bulan ini';

  @override
  String get stormAllTime => 'Sepanjang waktu';

  @override
  String get stormClickToReload => 'Klik untuk memuat ulang';

  @override
  String get stormThisRunHasExpired => 'Sesi ini telah kedaluwarsa!';

  @override
  String get stormThisRunWasOpenedInAnotherTab => 'Sesi ini dibuka di tab lain!';

  @override
  String stormXRuns(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count berjalan',
    );
    return '$_temp0';
  }

  @override
  String stormPlayedNbRunsOfPuzzleStorm(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Memainkan $count kali $param2',
    );
    return '$_temp0';
  }

  @override
  String get streamerLichessStreamers => 'Streamer Lichess';

  @override
  String get studyPrivate => 'Pribadi';

  @override
  String get studyMyStudies => 'Studi saya';

  @override
  String get studyStudiesIContributeTo => 'Studi yang saya ikut berkontribusi';

  @override
  String get studyMyPublicStudies => 'Studi publik saya';

  @override
  String get studyMyPrivateStudies => 'Studi pribadi saya';

  @override
  String get studyMyFavoriteStudies => 'Studi favorit saya';

  @override
  String get studyWhatAreStudies => 'Apa itu studi?';

  @override
  String get studyAllStudies => 'Semua studi';

  @override
  String studyStudiesCreatedByX(String param) {
    return 'Studi dibuat oleh $param';
  }

  @override
  String get studyNoneYet => 'Tidak ada.';

  @override
  String get studyHot => 'Terhangat';

  @override
  String get studyDateAddedNewest => 'Tanggal ditambahkan (terbaru)';

  @override
  String get studyDateAddedOldest => 'Tanggal ditambahkan (terlama)';

  @override
  String get studyRecentlyUpdated => 'Baru saja diperbarui';

  @override
  String get studyMostPopular => 'Paling populer';

  @override
  String get studyAlphabetical => 'Menurut abjad';

  @override
  String get studyAddNewChapter => 'Tambahkan bab baru';

  @override
  String get studyAddMembers => 'Tambahkan anggota';

  @override
  String get studyInviteToTheStudy => 'Ajak untuk studi';

  @override
  String get studyPleaseOnlyInvitePeopleYouKnow => 'Harap hanya mengundang orang yang Anda kenal, dan yang secara aktif ingin bergabung dengan studi ini.';

  @override
  String get studySearchByUsername => 'Cari berdasarkan nama pengguna';

  @override
  String get studySpectator => 'Penonton';

  @override
  String get studyContributor => 'Kontributor';

  @override
  String get studyKick => 'Diusir';

  @override
  String get studyLeaveTheStudy => 'Tinggalkan studi';

  @override
  String get studyYouAreNowAContributor => 'Sekarang Anda menjadi kontributor';

  @override
  String get studyYouAreNowASpectator => 'Sekarang Anda adalah penonton';

  @override
  String get studyPgnTags => 'Tagar PGN';

  @override
  String get studyLike => 'Suka';

  @override
  String get studyUnlike => 'Batal Suka';

  @override
  String get studyNewTag => 'Tagar baru';

  @override
  String get studyCommentThisPosition => 'Komentar di posisi ini';

  @override
  String get studyCommentThisMove => 'Komentari langkah ini';

  @override
  String get studyAnnotateWithGlyphs => 'Anotasikan dengan glif';

  @override
  String get studyTheChapterIsTooShortToBeAnalysed => 'Bab ini terlalu pendek untuk di analisa.';

  @override
  String get studyOnlyContributorsCanRequestAnalysis => 'Hanya kontributor yang dapat meminta analisa komputer.';

  @override
  String get studyGetAFullComputerAnalysis => 'Dapatkan analisis komputer penuh di pihak server dari jalur utama.';

  @override
  String get studyMakeSureTheChapterIsComplete => 'Pastikan bab ini selesai. Anda hanya dapat meminta analisis satu kali.';

  @override
  String get studyAllSyncMembersRemainOnTheSamePosition => 'Semua anggota yang ter-sinkron tetap pada posisi yang sama';

  @override
  String get studyShareChanges => 'Bagikan perubahan dengan penonton dan simpan di server';

  @override
  String get studyPlaying => 'Memainkan';

  @override
  String get studyShowResults => 'Results';

  @override
  String get studyShowEvalBar => 'Evaluation bars';

  @override
  String get studyFirst => 'Pertama';

  @override
  String get studyPrevious => 'Sebelumnya';

  @override
  String get studyNext => 'Berikutnya';

  @override
  String get studyLast => 'Terakhir';

  @override
  String get studyShareAndExport => 'Bagikan & ekspor';

  @override
  String get studyCloneStudy => 'Gandakan';

  @override
  String get studyStudyPgn => 'Studi PGN';

  @override
  String get studyDownloadAllGames => 'Unduh semua permainan';

  @override
  String get studyChapterPgn => 'Bab PGN';

  @override
  String get studyCopyChapterPgn => 'Salin PGN';

  @override
  String get studyDownloadGame => 'Unduh permainan';

  @override
  String get studyStudyUrl => 'URL studi';

  @override
  String get studyCurrentChapterUrl => 'URL Bab saat ini';

  @override
  String get studyYouCanPasteThisInTheForumToEmbed => 'Anda dapat menempelkan ini di forum untuk disematkan';

  @override
  String get studyStartAtInitialPosition => 'Mulai saat posisi awal';

  @override
  String studyStartAtX(String param) {
    return 'Mulai dari $param';
  }

  @override
  String get studyEmbedInYourWebsite => 'Sematkan di blog atau website Anda';

  @override
  String get studyReadMoreAboutEmbedding => 'Baca lebih tentang penyematan';

  @override
  String get studyOnlyPublicStudiesCanBeEmbedded => 'Hanya pelajaran publik yang dapat di sematkan!';

  @override
  String get studyOpen => 'Buka';

  @override
  String studyXBroughtToYouByY(String param1, String param2) {
    return '$param1 dibawakan kepadamu dari $param2';
  }

  @override
  String get studyStudyNotFound => 'Studi tidak ditemukan';

  @override
  String get studyEditChapter => 'Ubah bab';

  @override
  String get studyNewChapter => 'Bab baru';

  @override
  String studyImportFromChapterX(String param) {
    return 'Impor dari $param';
  }

  @override
  String get studyOrientation => 'Orientasi';

  @override
  String get studyAnalysisMode => 'Mode analisa';

  @override
  String get studyPinnedChapterComment => 'Sematkan komentar bagian bab';

  @override
  String get studySaveChapter => 'Simpan bab';

  @override
  String get studyClearAnnotations => 'Hapus anotasi';

  @override
  String get studyClearVariations => 'Hapus variasi';

  @override
  String get studyDeleteChapter => 'Hapus bab';

  @override
  String get studyDeleteThisChapter => 'Hapus bab ini? Ini tidak akan dapat mengulangkan kembali!';

  @override
  String get studyClearAllCommentsInThisChapter => 'Hapus semua komentar dan bentuk di bab ini?';

  @override
  String get studyRightUnderTheBoard => 'Kanan dibawah papan';

  @override
  String get studyNoPinnedComment => 'Tidak ada';

  @override
  String get studyNormalAnalysis => 'Analisa biasa';

  @override
  String get studyHideNextMoves => 'Sembunyikan langkah selanjutnya';

  @override
  String get studyInteractiveLesson => 'Pelajaran interaktif';

  @override
  String studyChapterX(String param) {
    return 'Bab $param';
  }

  @override
  String get studyEmpty => 'Kosong';

  @override
  String get studyStartFromInitialPosition => 'Mulai dari posisi awal';

  @override
  String get studyEditor => 'Penyunting';

  @override
  String get studyStartFromCustomPosition => 'Mulai dari posisi yang disesuaikan';

  @override
  String get studyLoadAGameByUrl => 'Muat permainan dari URL';

  @override
  String get studyLoadAPositionFromFen => 'Muat posisi dari FEN';

  @override
  String get studyLoadAGameFromPgn => 'Muat permainan dari PGN';

  @override
  String get studyAutomatic => 'Otomatis';

  @override
  String get studyUrlOfTheGame => 'URL permainan';

  @override
  String studyLoadAGameFromXOrY(String param1, String param2) {
    return 'Muat permainan dari $param1 atau $param2';
  }

  @override
  String get studyCreateChapter => 'Buat bab';

  @override
  String get studyCreateStudy => 'Buat studi';

  @override
  String get studyEditStudy => 'Ubah studi';

  @override
  String get studyVisibility => 'Visibilitas';

  @override
  String get studyPublic => 'Publik';

  @override
  String get studyUnlisted => 'Tidak terdaftar';

  @override
  String get studyInviteOnly => 'Hanya yang diundang';

  @override
  String get studyAllowCloning => 'Perbolehkan kloning';

  @override
  String get studyNobody => 'Tidak ada seorangpun';

  @override
  String get studyOnlyMe => 'Hanya saya';

  @override
  String get studyContributors => 'Kontributor';

  @override
  String get studyMembers => 'Anggota';

  @override
  String get studyEveryone => 'Semua orang';

  @override
  String get studyEnableSync => 'Aktifkan sinkronisasi';

  @override
  String get studyYesKeepEveryoneOnTheSamePosition => 'Ya: atur semua orang dalam posisi yang sama';

  @override
  String get studyNoLetPeopleBrowseFreely => 'Tidak: Bolehkan untuk menjelajah dengan bebas';

  @override
  String get studyPinnedStudyComment => 'Sematkan komentar studi';

  @override
  String get studyStart => 'Mulai';

  @override
  String get studySave => 'Simpan';

  @override
  String get studyClearChat => 'Bersihkan obrolan';

  @override
  String get studyDeleteTheStudyChatHistory => 'Hapus riwayat obrolan studi? Ini tidak akan dapat mengulangkan kembali!';

  @override
  String get studyDeleteStudy => 'Hapus studi';

  @override
  String studyConfirmDeleteStudy(String param) {
    return 'Hapus seluruh studi? Tidak dapat kembal lagi! Tuliskan nama studi untuk konfirmasi: $param';
  }

  @override
  String get studyWhereDoYouWantToStudyThat => 'Dimana Anda ingin mempelajarinya?';

  @override
  String get studyGoodMove => 'Langkah bagus';

  @override
  String get studyMistake => 'Kesalahan';

  @override
  String get studyBrilliantMove => 'Langkah Brilian';

  @override
  String get studyBlunder => 'Blunder';

  @override
  String get studyInterestingMove => 'Langkah menarik';

  @override
  String get studyDubiousMove => 'Langkah meragukan';

  @override
  String get studyOnlyMove => 'Langkah satu-satunya';

  @override
  String get studyZugzwang => 'Zugzwang';

  @override
  String get studyEqualPosition => 'Posisi imbang';

  @override
  String get studyUnclearPosition => 'Posisi tidak jelas';

  @override
  String get studyWhiteIsSlightlyBetter => 'Putih sedikit lebih unggul';

  @override
  String get studyBlackIsSlightlyBetter => 'Hitam sedikit lebih unggul';

  @override
  String get studyWhiteIsBetter => 'Putih lebih unggul';

  @override
  String get studyBlackIsBetter => 'Hitam lebih unggul';

  @override
  String get studyWhiteIsWinning => 'Putih menang telak';

  @override
  String get studyBlackIsWinning => 'Hitam menang telak';

  @override
  String get studyNovelty => 'Langkah baru';

  @override
  String get studyDevelopment => 'Pengembangan';

  @override
  String get studyInitiative => 'Inisiatif';

  @override
  String get studyAttack => 'Serangan';

  @override
  String get studyCounterplay => 'Serangan balik';

  @override
  String get studyTimeTrouble => 'Tekanan waktu';

  @override
  String get studyWithCompensation => 'Dengan kompensasi';

  @override
  String get studyWithTheIdea => 'Dengan ide';

  @override
  String get studyNextChapter => 'Bab selanjutnya';

  @override
  String get studyPrevChapter => 'Bab sebelumnya';

  @override
  String get studyStudyActions => 'Pembelajaran';

  @override
  String get studyTopics => 'Topik';

  @override
  String get studyMyTopics => 'Topik saya';

  @override
  String get studyPopularTopics => 'Topik populer';

  @override
  String get studyManageTopics => 'Kelola topik';

  @override
  String get studyBack => 'Kembali';

  @override
  String get studyPlayAgain => 'Main lagi';

  @override
  String get studyWhatWouldYouPlay => 'What would you play in this position?';

  @override
  String get studyYouCompletedThisLesson => 'Selamat. Anda telah menyelesaikan pelajaran ini.';

  @override
  String studyPerPage(String param) {
    return '$param per page';
  }

  @override
  String studyNbChapters(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Bab',
    );
    return '$_temp0';
  }

  @override
  String studyNbGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Permainan',
    );
    return '$_temp0';
  }

  @override
  String studyNbMembers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Anggota',
    );
    return '$_temp0';
  }

  @override
  String studyPasteYourPgnTextHereUpToNbGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Tempelkan PGN kamu disini, lebih dari $count permainan',
    );
    return '$_temp0';
  }

  @override
  String get timeagoJustNow => 'baru saja';

  @override
  String get timeagoRightNow => 'sekarang';

  @override
  String get timeagoCompleted => 'telah selesai';

  @override
  String timeagoInNbSeconds(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'dalam $count detik',
    );
    return '$_temp0';
  }

  @override
  String timeagoInNbMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'dalam $count menit',
    );
    return '$_temp0';
  }

  @override
  String timeagoInNbHours(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'dalam $count jam',
    );
    return '$_temp0';
  }

  @override
  String timeagoInNbDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'dalam $count hari',
    );
    return '$_temp0';
  }

  @override
  String timeagoInNbWeeks(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'dalam $count minggu',
    );
    return '$_temp0';
  }

  @override
  String timeagoInNbMonths(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'dalam $count bulan',
    );
    return '$_temp0';
  }

  @override
  String timeagoInNbYears(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'dalam $count tahun',
    );
    return '$_temp0';
  }

  @override
  String timeagoNbMinutesAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count menit yang lalu',
    );
    return '$_temp0';
  }

  @override
  String timeagoNbHoursAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count jam yang lalu',
    );
    return '$_temp0';
  }

  @override
  String timeagoNbDaysAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count hari yang lalu',
    );
    return '$_temp0';
  }

  @override
  String timeagoNbWeeksAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count minggu yang lalu',
    );
    return '$_temp0';
  }

  @override
  String timeagoNbMonthsAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count bulan yang lalu',
    );
    return '$_temp0';
  }

  @override
  String timeagoNbYearsAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count tahun yang lalu',
    );
    return '$_temp0';
  }

  @override
  String timeagoNbMinutesRemaining(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count menit tersisa',
    );
    return '$_temp0';
  }

  @override
  String timeagoNbHoursRemaining(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count jam tersisa',
    );
    return '$_temp0';
  }
}
