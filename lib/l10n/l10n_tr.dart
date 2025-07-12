// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'l10n.dart';

// ignore_for_file: type=lint

/// The translations for Turkish (`tr`).
class AppLocalizationsTr extends AppLocalizations {
  AppLocalizationsTr([String locale = 'tr']) : super(locale);

  @override
  String get mobileAccountPreferences => 'Hesap tercihleri';

  @override
  String get mobileAccountPreferencesHelp =>
      'Bu tercihler Lichess hesabınıza uygulanacak ve cihazlarınız arasında senkronize edilecektir.';

  @override
  String get mobileAllGames => 'Tüm oyunlar';

  @override
  String get mobileAreYouSure => 'Emin misiniz?';

  @override
  String get mobileBoardSettings => 'Tahta seçenekleri';

  @override
  String get mobileCancelTakebackOffer => 'Geri alma teklifini iptal et';

  @override
  String get mobileClearButton => 'Temizle';

  @override
  String get mobileCorrespondenceClearSavedMove => 'Kayıtlı hamleyi sil';

  @override
  String get mobileCustomGameJoinAGame => 'Bir oyuna katıl';

  @override
  String get mobileFeedbackButton => 'Geri bildirimde bulun';

  @override
  String mobileGoodEvening(String param) {
    return 'İyi akşamlar, $param';
  }

  @override
  String get mobileGoodEveningWithoutName => 'İyi akşamlar';

  @override
  String mobileGoodDay(String param) {
    return 'İyi günler, $param';
  }

  @override
  String get mobileGoodDayWithoutName => 'İyi günler';

  @override
  String get mobileHideVariation => 'Varyasyonu gizle';

  @override
  String get mobileHomeTab => 'Ana sayfa';

  @override
  String get mobileLiveStreamers => 'Canlı yayıncılar';

  @override
  String get mobileMustBeLoggedIn => 'Bu sayfayı görüntülemek için giriş yapmalısınız.';

  @override
  String get mobileNoSearchResults => 'Sonuç bulunamadı';

  @override
  String get mobileNotAllFeaturesAreAvailable =>
      'Please note that not all features from the old app or the website are currently available, but we are adding features all the time.';

  @override
  String get mobileNotFollowingAnyUser => 'Hiçbir kullanıcıyı takip etmiyorsunuz.';

  @override
  String get mobileOkButton => 'Tamam';

  @override
  String get mobileOverTheBoard => 'Tahta üzerinde çevrimdışı oyna';

  @override
  String mobilePlayersMatchingSearchTerm(String param) {
    return '\"$param\" ile başlayan oyuncularla';
  }

  @override
  String get mobilePositionLeft => 'Sol';

  @override
  String get mobilePositionRight => 'Sağ';

  @override
  String get mobilePrefMagnifyDraggedPiece => 'Sürüklenen taşı büyüt';

  @override
  String get mobilePuzzleStormConfirmEndRun => 'Bu oyunu bitirmek istiyor musun?';

  @override
  String get mobilePuzzleStormFilterNothingToShow =>
      'Gösterilecek bir şey yok, lütfen filtreleri değiştirin';

  @override
  String get mobilePuzzleStormNothingToShow =>
      'Gösterilecek bir şey yok. Birkaç kez Bulmaca Fırtınası oyunu oynayın.';

  @override
  String get mobilePuzzleStormSubtitle => '3 dakika içerisinde mümkün olduğunca çok bulmaca çözün.';

  @override
  String get mobilePuzzleStreakAbortWarning =>
      'Mevcut serinizi kaybedeceksiniz ve puanınız kaydedilecektir.';

  @override
  String get mobilePuzzleThemesSubtitle =>
      'En sevdiğiniz açılışlardan bulmacalar oynayın veya bir tema seçin.';

  @override
  String get mobilePuzzlesTab => 'Bulmacalar';

  @override
  String get mobileRecentSearches => 'Son aramalar';

  @override
  String get mobileRemoveBookmark => 'Yer işaretini kaldır';

  @override
  String get mobileServerAnalysis => 'Server analysis';

  @override
  String get mobileSettingsClockPosition => 'Saat pozisyonu';

  @override
  String get mobileSettingsCustomBackgroundPresets => 'Hazırlar';

  @override
  String get mobileSettingsDraggedPieceTarget => 'Dragged piece target';

  @override
  String get mobileSettingsDraggedTargetCircle => 'Daire';

  @override
  String get mobileSettingsDraggedTargetSquare => 'Kare';

  @override
  String get mobileSettingsHomeWidgets => 'Ana ekran kısayolları';

  @override
  String get mobileSettingsImmersiveMode => 'Sürükleyici mod';

  @override
  String get mobileSettingsImmersiveModeSubtitle =>
      'Oynarken sistem arayüzünü gizle. Sistemin, ekranın kenarlarındaki gezinme hareketlerinden rahatsızsan bunu kullan. Bu ayar oyun ve bulmaca ekranlarına uygulanır.';

  @override
  String get mobileSettingsMaterialDifferenceCapturedPieces => 'Ele geçirilen taşlar';

  @override
  String get mobileSettingsPickAnImage => 'Bir resim seçin';

  @override
  String get mobileSettingsPickAnImageHelp =>
      'Özel arkaplan sadece karanlık modda çalışır. Karanlık bir resim tavsiye edilir.';

  @override
  String get mobileSettingsPickAnImageBlur => 'Resmi bulanıklaştır';

  @override
  String get mobileSettingsPickAnImageHideBoard => 'Tahtayı gizle';

  @override
  String get mobileSettingsPickAnImageShowBoard => 'Tahtayı göster';

  @override
  String get mobileSettingsPickAnImageSwipeToDisplay => 'Diğer arkaplanlar için kaydır';

  @override
  String get mobileSettingsPieceShiftMethodEither => 'Dokun veya sürükle';

  @override
  String get mobileSettingsPieceShiftMethodTapTwoSquares => 'İki kareye dokun';

  @override
  String get mobileSettingsShapeDrawing => 'Şekil çizimi';

  @override
  String get mobileSettingsShapeDrawingSubtitle =>
      'İki parmak kullanarak şekiller çizin: şekil çizmek için bir parmağı boş bir karede tutun ve başka bir parmağı sürükleyin.';

  @override
  String get mobileSettingsShowBorder => 'Kenarları göster';

  @override
  String get mobileSettingsTouchFeedback => 'Dokunuş geribildirimi';

  @override
  String get mobileSettingsTouchFeedbackSubtitle =>
      'Aktif olduğunda, bir taş oynatıldığında veya alındığında cihaz hafifçe titreyecektir.';

  @override
  String get mobileSettingsTab => 'Ayarlar';

  @override
  String get mobileShareGamePGN => 'PGN\'yi paylaş';

  @override
  String get mobileShareGameURL => 'Oyun linkini paylaş';

  @override
  String get mobileSharePositionAsFEN => 'Konumu FEN olarak paylaş';

  @override
  String get mobileSharePuzzle => 'Bulmacayı paylaş';

  @override
  String get mobileShowComments => 'Yorumları göster';

  @override
  String get mobileShowResult => 'Sonucu göster';

  @override
  String get mobileShowVariations => 'Varyasyonları göster';

  @override
  String get mobileSomethingWentWrong => 'Birşeyler ters gitti.';

  @override
  String get mobileSystemColors => 'Sistem renkleri';

  @override
  String get mobileTheme => 'Tema';

  @override
  String get mobileToolsTab => 'Araçlar';

  @override
  String mobileUnsupportedVariant(String param) {
    return '$param varyantı bu versiyonda desteklenmiyor.';
  }

  @override
  String get mobileWaitingForOpponentToJoin => 'Rakip bekleniyor...';

  @override
  String get mobileWatchTab => 'İzle';

  @override
  String get mobileWelcomeToLichessApp => 'Lichess uygulamasına hoşgeldiniz!';

  @override
  String get activityActivity => 'Son Etkinlikler';

  @override
  String get activityHostedALiveStream => 'Canlı yayın yaptı';

  @override
  String activityRankedInSwissTournament(String param1, String param2) {
    return '$param2 katılımcıları arasında #$param1. oldu';
  }

  @override
  String get activitySignedUp => 'lichess.org\'a üye oldu';

  @override
  String activitySupportedNbMonths(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'lichess.org\'u $count aylığına $param2 olarak destekledi',
      one: 'lichess.org\'u $count aylığına $param2 olarak destekledi',
    );
    return '$_temp0';
  }

  @override
  String activityPracticedNbPositions(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$param2 üzerine $count alıştırma yaptı',
      one: '$param2 üzerine $count alıştırma yaptı',
    );
    return '$_temp0';
  }

  @override
  String activitySolvedNbPuzzles(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count bulmaca çözdü',
      one: '$count bulmaca çözdü',
    );
    return '$_temp0';
  }

  @override
  String activityPlayedNbGames(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count kez $param2 oynadı',
      one: '$count kez $param2 oynadı',
    );
    return '$_temp0';
  }

  @override
  String activityPostedNbMessages(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$param2 forumunda $count mesaj paylaştı',
      one: 'Forumda $count mesaj paylaştı: $param2',
    );
    return '$_temp0';
  }

  @override
  String activityPlayedNbMoves(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count hamle yaptı',
      one: '$count hamle yaptı',
    );
    return '$_temp0';
  }

  @override
  String activityInNbCorrespondenceGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '($count yazışmalı oyunda)',
      one: '($count yazışmalı oyunda)',
    );
    return '$_temp0';
  }

  @override
  String activityCompletedNbGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count adet yazışmalı oyun tamamladı',
      one: '$count adet yazışmalı oyun tamamladı',
    );
    return '$_temp0';
  }

  @override
  String activityCompletedNbVariantGames(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count $param2 yazışmalı oyunu tamamladı',
      one: '$count $param2 yazışmalı oyunu tamamladı',
    );
    return '$_temp0';
  }

  @override
  String activityFollowedNbPlayers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count oyuncuyu takip etmeye başladı',
      one: '$count oyuncuyu takip etmeye başladı',
    );
    return '$_temp0';
  }

  @override
  String activityGainedNbFollowers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count yeni takipçi kazandı',
      one: '$count yeni takipçi kazandı',
    );
    return '$_temp0';
  }

  @override
  String activityHostedNbSimuls(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count eş zamanlı gösteriye ev sahipliği yaptı',
      one: '$count simultaneye ev sahipliği yaptı',
    );
    return '$_temp0';
  }

  @override
  String activityJoinedNbSimuls(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count eş zamanlı gösteriye katıldı',
      one: '$count eş zamanlı gösteriye katıldı',
    );
    return '$_temp0';
  }

  @override
  String activityCreatedNbStudies(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count yeni çalışma oluşturdu',
      one: '$count yeni çalışma oluşturdu',
    );
    return '$_temp0';
  }

  @override
  String activityCompetedInNbTournaments(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count turnuvaya katıldı',
      one: '$count turnuvaya katıldı',
    );
    return '$_temp0';
  }

  @override
  String activityRankedInTournament(int count, String param2, String param3, String param4) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$param3 oyun oynayarak $param4 turnuvasında $count. oldu (en iyi $param2% içinde)',
      one: '$param3 oyun oynayarak $param4 turnuvasında $count. oldu (en iyi $param2% içinde)',
    );
    return '$_temp0';
  }

  @override
  String activityCompetedInNbSwissTournaments(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count İsviçre Sistemi turnuvasına katıldı',
      one: '$count İsviçre Sistemi turnuvasına katıldı',
    );
    return '$_temp0';
  }

  @override
  String activityJoinedNbTeams(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count takıma katıldı',
      one: '$count takıma katıldı',
    );
    return '$_temp0';
  }

  @override
  String get arenaArena => 'Arena';

  @override
  String get arenaArenaTournaments => 'Arena turnuvaları';

  @override
  String get arenaIsItRated => 'Bu turnuva puanlı mı?';

  @override
  String get arenaWillBeNotified =>
      'Turnuva başladığında sana haber vereceğiz, bu süre zarfında başka bir sekmede oynamanın bir sakıncası yok.';

  @override
  String get arenaIsRated => 'Evet, bu turnuva puanlıdır ve oyun puanınızı etkileyecektir.';

  @override
  String get arenaIsNotRated =>
      'Hayır, bu turnuva puanlı *değildir* ve oyun puanınızı *etkilemeyecektir*.';

  @override
  String get arenaSomeRated => 'Bazı turnuvalar puanlıdır ve oyun puanınızı etkiler.';

  @override
  String get arenaHowAreScoresCalculated => 'Maçlardan alınan puanlar nasıl hesaplanıyor?';

  @override
  String get arenaHowAreScoresCalculatedAnswer =>
      'Kazanılan bir oyun temelde 2 puan, beraberlik 1 puan değerindedir. Kaybedilen bir oyun ise hiçbir puan getirmez. Üst üste iki oyun kazandığınız takdirde alev ikonu ile simgelenen çifte puan serisine girersiniz.\n\nMağlup olana veya berabere kalana kadar yapılan maçlardan iki katı puan kazanırsınız. Yani seride iken bir galibiyet 4 puan, beraberlik 2 puan getirirken kaybedilen oyundan hiçbir puan alınmaz.\n\nÖrneğin; üst üste kazanılan iki oyun ve ardından alınan bir beraberlik 6 puan değerindedir: 2 + 2 + (2 x 1)';

  @override
  String get arenaBerserk => 'Divane Modu';

  @override
  String get arenaBerserkAnswer =>
      'Oyunun başında ekranın sağ altında bulunan \"Berserk\" tuşuna tıklayan oyuncu süresinin yarısından feragat eder ancak maçı kazandığı takdirde fazladan 1 turnuva puanı alır.\n\nSüre eklemeli oyunlarda Divane açan oyuncuya hamle sonrası süre ilave edilmez. (1+2 bir istisnadır, bu tempoda süre 1+0 olur)\n\nSıfır dakika ile başlayan oyunlarda Divane seçeneği mevcut değildir. (0+1, 0+2).\n\nDivane açılan bir oyun en az 7 hamle oynanmadan bitmiş ise ek puan geçerli değildir.';

  @override
  String get arenaHowIsTheWinnerDecided => 'Kazanan nasıl belirleniyor?';

  @override
  String get arenaHowIsTheWinnerDecidedAnswer =>
      'Turnuva sona erdiğinde en fazla puana sahip oyuncu(lar) galip ilan edilir.';

  @override
  String get arenaHowDoesPairingWork => 'Eşleştirme nasıl yapılıyor?';

  @override
  String get arenaHowDoesPairingWorkAnswer =>
      'Turnuvanın başında eşleştirmeler oyuncuların puanlarına göre yapılır. Oyunu bitirip lobiye döndüğünüz anda ise kendi sıralamanıza yakın bir rakip ile eşleştirilirsiniz. Böylece bekleme süresi en aza indirgenmiş olur fakat turnuvadaki tüm oyuncularla karşılaşamayabilirsiniz.\n\nDaha fazla oyun oynayıp daha çok puan kazanmak için hızlıca oynayın ve lobiye dönün.';

  @override
  String get arenaHowDoesItEnd => 'Turnuva nasıl sona erer?';

  @override
  String get arenaHowDoesItEndAnswer =>
      'Turnuvanın belirli bir süresi vardır. Bu süre bittiğinde sıralamalar kilitlenir ve kazanlar ilan edilir. Devam etmekte olan oyunların bitirilmesi gerekir ancak bu oyunlar turnuvaya dahil edilmez.';

  @override
  String get arenaOtherRules => 'Diğer önemli kurallar';

  @override
  String get arenaThereIsACountdown =>
      'İlk hamlenizi yapmanız için bir geri sayım vardır. Verilen süre içinde bir hamle yapmadığınız takdirde rakibiniz galip sayılır.';

  @override
  String get arenaThisIsPrivate => 'Bu özel bir turnuvadır';

  @override
  String arenaShareUrl(String param) {
    return 'Arkadaşlarını davet etmek için bu URL\'yi kullanabilirsin: $param';
  }

  @override
  String arenaDrawStreakStandard(String param) {
    return 'Beraberlik serisi: Arena turnuvasında üst üste berabere kalan bir oyuncu sadece ilk maçtan puan alır. Beraberlik serisi yalnızca bir galibiyet ile bozulur, yenilgi veya başka bir beraberlikte devam eder. Ek olarak, klasik maçlarda $param hamleden uzun süren beraberliklerde oyuncular yine puan alır.';
  }

  @override
  String get arenaDrawStreakVariants =>
      'Berabere biten oyunların puan getirmesi için gereken minimum hamle sayısı varyanta göre değişir. Her varyant için gerekli olan asgari hamle sayısı tabloda verilmiştir.';

  @override
  String get arenaVariant => 'Varyant';

  @override
  String get arenaMinimumGameLength => 'Asgari hamle sayısı';

  @override
  String get arenaHistory => 'Arena Geçmişi';

  @override
  String get arenaNewTeamBattle => 'Yeni Takım Çarpışması';

  @override
  String get arenaCustomStartDate => 'Özel başlangıç tarihi';

  @override
  String get arenaCustomStartDateHelp =>
      'Kendi saat diliminizi kullanın. \"Turnuvaya kalan süre\" ayarı geçersiz kalacaktır';

  @override
  String get arenaAllowBerserk => 'Divane moduna izin ver';

  @override
  String get arenaAllowBerserkHelp =>
      'Ekstra puan kazanmak isteyen oyuncuların, sürelerinin yarısından feragat etmesine izin ver';

  @override
  String get arenaAllowChatHelp => 'Oyuncuların sohbet odasında konuşmasına izin ver';

  @override
  String get arenaArenaStreaks => 'Arena serisi';

  @override
  String get arenaArenaStreaksHelp =>
      '2 kez üst üste kazandıktan sonra yapılan maçlar 2 yerine 4 puan verir.';

  @override
  String get arenaNoBerserkAllowed => 'Divane modu devre dışı';

  @override
  String get arenaNoArenaStreaks => 'Arena serisi devre dışı';

  @override
  String get arenaAveragePerformance => 'Ortalama performans';

  @override
  String get arenaAverageScore => 'Ortalama skor';

  @override
  String get arenaMyTournaments => 'Turnuvalarım';

  @override
  String get arenaEditTournament => 'Turnuvayı düzenle';

  @override
  String get arenaEditTeamBattle => 'Takım çarpışmasını düzenle';

  @override
  String get arenaDefender => 'Savunucu';

  @override
  String get arenaPickYourTeam => 'Takımınızı seçin';

  @override
  String get arenaWhichTeamWillYouRepresentInThisBattle =>
      'Bu mücadelede hangi takımı temsil edeceksiniz?';

  @override
  String get arenaYouMustJoinOneOfTheseTeamsToParticipate =>
      'Katılmak için bu takımlardan birine katılmanız gerekir!';

  @override
  String get arenaCreated => 'Oluşturuldu';

  @override
  String get arenaRecentlyPlayed => 'Son oynananlar';

  @override
  String get arenaBestResults => 'En iyi sonuçlar';

  @override
  String get arenaTournamentStats => 'Turnuva istatistikleri';

  @override
  String get arenaRankAvgHelp =>
      'Sıralama ortalaması, sıralamanızın yüzdesidir. Daha düşük olması daha iyidir.\n\nÖrneğin, 100 oyunculu bir turnuvada 3. sırada olmak = %3. 1000 oyunculu bir turnuvada 10. sırada olmak = %1.';

  @override
  String get arenaMedians => 'ortancadır';

  @override
  String arenaAllAveragesAreX(String param) {
    return 'Bu sayfadaki tüm değerler $param.';
  }

  @override
  String get arenaTotal => 'Toplam';

  @override
  String get arenaPointsAvg => 'Puan ortalaması';

  @override
  String get arenaPointsSum => 'Puan toplamı';

  @override
  String get arenaRankAvg => 'Sıralama ortalaması';

  @override
  String get arenaTournamentWinners => 'Turnuva şampiyonları';

  @override
  String get arenaTournamentShields => 'Turnuva kalkanları';

  @override
  String get arenaOnlyTitled => 'Sadece unvanlı oyuncular';

  @override
  String get arenaOnlyTitledHelp => 'Turnuvaya katılmak için resmî bir unvana sahip olmayı iste';

  @override
  String get arenaTournamentPairingsAreNowClosed => 'Turnuva eşleştirmeleri şu anda kapalıdır.';

  @override
  String get arenaBerserkRate => 'Divane oranı';

  @override
  String arenaDrawingWithinNbMoves(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'İlk $count hamle içinde oyun berabere biterse hiçbir oyuncu puan kazanamaz.',
      one: 'İlk $count hamle içinde oyun berabere biterse hiçbir oyuncu puan kazanamaz.',
    );
    return '$_temp0';
  }

  @override
  String arenaViewAllXTeams(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Tüm $count takımlarını görüntüleyin',
      one: 'Takımı görüntüleyin',
    );
    return '$_temp0';
  }

  @override
  String get broadcastBroadcasts => 'Canlı Turnuvalar';

  @override
  String get broadcastMyBroadcasts => 'Canlı Turnuvalarım';

  @override
  String get broadcastLiveBroadcasts => 'Canlı Turnuva Yayınları';

  @override
  String get broadcastBroadcastCalendar => 'Turnuva takvimi';

  @override
  String get broadcastNewBroadcast => 'Canlı Turnuva Ekle';

  @override
  String get broadcastSubscribedBroadcasts => 'Abone olduğunuz canlı turnuvalar';

  @override
  String get broadcastAboutBroadcasts => 'Canlı Turnuvalar hakkında';

  @override
  String get broadcastHowToUseLichessBroadcasts => 'Lichess Canlı Turnuvaları nasıl kullanılır.';

  @override
  String get broadcastTheNewRoundHelp =>
      'Yeni tur, önceki turdaki üyeler ve katkıda bulunanlarla aynı olacak.';

  @override
  String get broadcastAddRound => 'Bir tur ekle';

  @override
  String get broadcastOngoing => 'Devam eden turnuvalar';

  @override
  String get broadcastUpcoming => 'Yaklaşan turnuvalar';

  @override
  String get broadcastRoundName => 'Tur ismi';

  @override
  String get broadcastRoundNumber => 'Tur sayısı';

  @override
  String get broadcastTournamentName => 'Turnuva ismi';

  @override
  String get broadcastTournamentDescription => 'Turnuvanın kısa tanımı';

  @override
  String get broadcastFullDescription => 'Etkinliğin detaylıca açıklaması';

  @override
  String broadcastFullDescriptionHelp(String param1, String param2) {
    return 'Etkinliğin isteğe bağlı detaylı açıklaması. $param1 seçeneği mevcuttur. Metnin uzunluğu azami $param2 karakter olmalıdır.';
  }

  @override
  String get broadcastSourceSingleUrl => 'PGN Kaynak URL\'si';

  @override
  String get broadcastSourceUrlHelp =>
      'Lichess, sağladığınız URL yardımıyla PGN\'yi güncelleyecektir. İnternet üzerinden herkese açık bir URL yazmalısınız.';

  @override
  String get broadcastSourceGameIds => 'Boşluklarla ayrılmış 64 adede kadar Lichess oyun ID\'si.';

  @override
  String broadcastStartDateTimeZone(String param) {
    return 'Turnuva yerel saati ile başlama zamanı: $param';
  }

  @override
  String get broadcastStartDateHelp =>
      'İsteğe bağlı, etkinliğin ne zaman başladığını biliyorsanız ekleyebilirsiniz.';

  @override
  String get broadcastCurrentGameUrl => 'Şu anki oyunun linki';

  @override
  String get broadcastDownloadAllRounds => 'Bütün maçları indir';

  @override
  String get broadcastResetRound => 'Bu turu sıfırla';

  @override
  String get broadcastDeleteRound => 'Bu turu sil';

  @override
  String get broadcastDefinitivelyDeleteRound => 'Turu ve oyunlarını tamamen sil.';

  @override
  String get broadcastDeleteAllGamesOfThisRound =>
      'Bu turdaki tüm oyunları sil. Tekrardan yapılabilmesi için kaynağın aktif olması gerekir.';

  @override
  String get broadcastEditRoundStudy => 'Tur çalışmasını düzenle';

  @override
  String get broadcastDeleteTournament => 'Bu turnuvayı sil';

  @override
  String get broadcastDefinitivelyDeleteTournament =>
      'Bütün turnuvayı, turlarını ve oyunlarını kalıcı olarak sil.';

  @override
  String get broadcastShowScores => 'Oyuncuların puanlarını oyun sonuçlarına göre göster';

  @override
  String get broadcastReplacePlayerTags =>
      'İsteğe bağlı: Oyuncu adlarını, derecelendirmelerini ve unvanlarını değiştirin';

  @override
  String get broadcastFideFederations => 'FIDE federasyonları';

  @override
  String get broadcastTop10Rating => 'İlk 10 rating';

  @override
  String get broadcastFidePlayers => 'FIDE oyuncuları';

  @override
  String get broadcastFidePlayerNotFound => 'FIDE oyuncusu bulunamadı';

  @override
  String get broadcastFideProfile => 'FIDE profili';

  @override
  String get broadcastFederation => 'Federasyon';

  @override
  String get broadcastAgeThisYear => 'Bu yılki yaşı';

  @override
  String get broadcastUnrated => 'Derecelendirilmemiş';

  @override
  String get broadcastRecentTournaments => 'Son Turnuvalar';

  @override
  String get broadcastOpenLichess => 'Lichess\'te aç';

  @override
  String get broadcastTeams => 'Takımlar';

  @override
  String get broadcastBoards => 'Tahtalar';

  @override
  String get broadcastOverview => 'Genel Bakış';

  @override
  String get broadcastSubscribeTitle =>
      'Tur başladığında bildirim almak için abone olun. Hesap tercihlerinizden anlık ya da çan bildirimi tercihinizi hesap tercihlerinizden belirleyebilirsiniz.';

  @override
  String get broadcastUploadImage => 'Turnuva görseli yükleyin';

  @override
  String get broadcastNoBoardsYet =>
      'Henüz tahta bulunmamaktadır. Oyunlar yüklendikçe tahtalar ortaya çıkacaktır.';

  @override
  String broadcastBoardsCanBeLoaded(String param) {
    return 'Tahtalar bir kaynaktan ya da ${param}ndan yüklenebilir';
  }

  @override
  String broadcastStartsAfter(String param) {
    return '$param\'ten sonra başlar';
  }

  @override
  String get broadcastStartVerySoon => 'Yayın az sonra başlayacak.';

  @override
  String get broadcastNotYetStarted => 'Yayın henüz başlamadı.';

  @override
  String get broadcastOfficialWebsite => 'Resmî site';

  @override
  String get broadcastStandings => 'Sıralamalar';

  @override
  String get broadcastOfficialStandings => 'Resmi Sıralamalar';

  @override
  String broadcastIframeHelp(String param) {
    return '${param}nda daha fazla seçenek';
  }

  @override
  String get broadcastWebmastersPage => 'ağ yöneticileri sayfası';

  @override
  String broadcastPgnSourceHelp(String param) {
    return 'Bu turun açık, gerçek zamanlı PGN kaynağı. Daha hızlı ve verimli senkronizasyon için $param\'ımız da bulunmaktadır.';
  }

  @override
  String get broadcastEmbedThisBroadcast => 'İnternet sitenizde bu yayını gömülü paylaşın';

  @override
  String broadcastEmbedThisRound(String param) {
    return '${param}u İnternet sitenizde gömülü paylaşın';
  }

  @override
  String get broadcastRatingDiff => 'Puan farkı';

  @override
  String get broadcastGamesThisTournament => 'Bu turnuvadaki maçlar';

  @override
  String get broadcastScore => 'Skor';

  @override
  String get broadcastAllTeams => 'Tüm takımlar';

  @override
  String get broadcastTournamentFormat => 'Turnuva biçimi';

  @override
  String get broadcastTournamentLocation => 'Turnuva Konumu';

  @override
  String get broadcastTopPlayers => 'En iyi oyuncular';

  @override
  String get broadcastTimezone => 'Zaman dilimi';

  @override
  String get broadcastFideRatingCategory => 'FIDE derecelendirme kategorisi';

  @override
  String get broadcastOptionalDetails => 'İsteğe bağlı ayrıntılar';

  @override
  String get broadcastPastBroadcasts => 'Geçmiş yayınlar';

  @override
  String get broadcastAllBroadcastsByMonth => 'Tüm yayınları aylara göre görüntüleyin';

  @override
  String get broadcastBackToLiveMove => 'Canlı hamleye dön';

  @override
  String get broadcastSinceHideResults =>
      'Sonuçları gizlemeyi seçtiğiniz için, spoiler vermemek adına tüm tahta görünümleri boş olacak.';

  @override
  String get broadcastLiveboard => 'Canlı tahta';

  @override
  String get broadcastCommunityBroadcast => 'Topluluk yayını';

  @override
  String broadcastCreatedAndManagedBy(String param) {
    return '$param tarafından oluşturuldu ve yönetiliyor.';
  }

  @override
  String broadcastNbBroadcasts(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count canlı turnuva',
      one: '$count canlı turnuva',
    );
    return '$_temp0';
  }

  @override
  String broadcastNbViewers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count izleyici',
      one: '$count izleyici',
    );
    return '$_temp0';
  }

  @override
  String challengeChallengesX(String param1) {
    return '$param1 karşılaşmaları';
  }

  @override
  String get challengeChallengeToPlay => 'Oyun teklif et';

  @override
  String get challengeChallengeDeclined => 'Oyun teklifi reddedildi';

  @override
  String get challengeChallengeAccepted => 'Oyun teklifi kabul edildi!';

  @override
  String get challengeChallengeCanceled => 'Oyun teklifi iptal edildi.';

  @override
  String get challengeRegisterToSendChallenges => 'Oyun daveti göndermek için lütfen üye olun.';

  @override
  String challengeYouCannotChallengeX(String param) {
    return '$param adlı oyuncuya oyun daveti gönderemezsiniz.';
  }

  @override
  String challengeXDoesNotAcceptChallenges(String param) {
    return '$param oyun davetlerini kabul etmiyor.';
  }

  @override
  String challengeYourXRatingIsTooFarFromY(String param1, String param2) {
    return '$param1 puanınız $param2 ile kıyaslandığında büyük fark var.';
  }

  @override
  String challengeCannotChallengeDueToProvisionalXRating(String param) {
    return '$param puanınız geçici olduğu için başka oyunculara meydan okuyamazsınız.';
  }

  @override
  String challengeXOnlyAcceptsChallengesFromFriends(String param) {
    return '$param sadece arkadaşlarından gelen oyun davetlerini kabul ediyor.';
  }

  @override
  String get challengeDeclineGeneric => 'Şimdilik oyun tekliflerini kabul etmiyorum.';

  @override
  String get challengeDeclineLater =>
      'Şu anda müsait değilim, lütfen daha sonra yeniden teklif ediniz.';

  @override
  String get challengeDeclineTooFast =>
      'Bu süre ayarı benim için çok hızlı, lütfen daha yavaş oyunları teklif ediniz.';

  @override
  String get challengeDeclineTooSlow =>
      'Bu süre ayarı benim için çok yavaş, lütfen daha hızlı oyunları teklif ediniz.';

  @override
  String get challengeDeclineTimeControl =>
      'Bu süre ayarına sahip oyun tekliflerini kabul etmiyorum.';

  @override
  String get challengeDeclineRated => 'Bunun yerine puanlı oyun teklifi yapınız lütfen.';

  @override
  String get challengeDeclineCasual => 'Bunun yerine puansız oyun teklifi yapınız lütfen.';

  @override
  String get challengeDeclineStandard =>
      'Şimdilik standart dışı varyantlarda oyun tekliflerini kabul etmiyorum.';

  @override
  String get challengeDeclineVariant => 'Şimdilik bu varyantı oynamak istemiyorum.';

  @override
  String get challengeDeclineNoBot => 'Botlardan gelen oyun tekliflerini kabul etmiyorum.';

  @override
  String get challengeDeclineOnlyBot =>
      'Yalnızca botlardan gelen oyun tekliflerini kabul ediyorum.';

  @override
  String get challengeInviteLichessUser => 'Veya bir Lichess kullanıcısını davet edin:';

  @override
  String get contactContact => 'İletişim';

  @override
  String get contactContactLichess => 'Lichess ile iletişime geçin';

  @override
  String get coordinatesCoordinates => 'Koordinatlar';

  @override
  String get coordinatesCoordinateTraining => 'Koordinat Antrenmanı';

  @override
  String coordinatesAverageScoreAsWhiteX(String param) {
    return 'Beyaz olarak ortalama skor: $param';
  }

  @override
  String coordinatesAverageScoreAsBlackX(String param) {
    return 'Siyah olarak ortalama skor: $param';
  }

  @override
  String get coordinatesKnowingTheChessBoard =>
      'Satranç tahtasının koordinatlarını bilmek çok önemli bir satranç becerisidir:';

  @override
  String get coordinatesMostChessCourses =>
      'Satranç derslerinin ve alıştırmalarının çoğunda cebirsel gösterim kullanılır.';

  @override
  String get coordinatesTalkToYourChessFriends =>
      '\"Satranç dilini\" anlayabildiğin için satranç oynayan arkadaşlarınla anlaşman daha kolay bir hâl alır.';

  @override
  String get coordinatesYouCanAnalyseAGameMoreEffectively =>
      'Karelerin adlarını iyice bilirsen oyunları daha etkili bir şekilde analiz edebilirsin.';

  @override
  String get coordinatesACoordinateAppears =>
      'Tahta üzerinde sana verilecek koordinata karşılık gelen kareye tıklamalısın.';

  @override
  String get coordinatesASquareIsHighlightedExplanation =>
      'Tahta üzerinde gösterilen karenin koordinatını yazmalısın (\"e4\" gibi).';

  @override
  String get coordinatesYouHaveThirtySeconds => '30 saniye içinde kaç tane kare bulabilirsen!';

  @override
  String get coordinatesGoAsLongAsYouWant => 'İstediğin kadar oyna, süre sınırı yok!';

  @override
  String get coordinatesShowCoordinates => 'Koordinatları göster';

  @override
  String get coordinatesShowCoordsOnAllSquares => 'Her karede koordinatlar';

  @override
  String get coordinatesShowPieces => 'Taşları göster';

  @override
  String get coordinatesStartTraining => 'Antrenmana başla';

  @override
  String get coordinatesFindSquare => 'Kareleri bul';

  @override
  String get coordinatesNameSquare => 'Kareleri yaz';

  @override
  String get coordinatesPracticeOnlySomeFilesAndRanks =>
      'Sadece bazı dosyaları & rütbeleri uygulayın';

  @override
  String get patronDonate => 'Bağış yap';

  @override
  String get patronLichessPatron => 'Lichess Destekçisi';

  @override
  String get patronBecomePatron => 'Lichess Destekçisi olun';

  @override
  String perfStatPerfStats(String param) {
    return '$param istatistikleri';
  }

  @override
  String get perfStatViewTheGames => 'Oyunları görüntüle';

  @override
  String get perfStatProvisional => 'geçici';

  @override
  String get perfStatNotEnoughRatedGames =>
      'Güvenilir bir puan oluşturmak için yeterli sayıda puanlı oyun oynanmamış.';

  @override
  String perfStatProgressOverLastXGames(String param) {
    return 'Son $param maç sonrası durum:';
  }

  @override
  String perfStatRatingDeviation(String param) {
    return 'Puan sapma değeri: $param.';
  }

  @override
  String perfStatRatingDeviationTooltip(String param1, String param2, String param3) {
    return 'Daha düşük değer reytingin daha istikrarlı olduğu anlamına gelir. $param1 değerinin üzerindeyse reytingin geçici olduğu kabul edilir. Sıralamaya dahil edilmek için $param2 (standart satranç) veya $param3 (varyantlarda) değerinin altında olmak gerekiyor.';
  }

  @override
  String get perfStatTotalGames => 'Toplam maç sayısı';

  @override
  String get perfStatRatedGames => 'Dereceli oyunlar';

  @override
  String get perfStatTournamentGames => 'Turnuva maçları';

  @override
  String get perfStatBerserkedGames => 'Divane açılan maçlar';

  @override
  String get perfStatTimeSpentPlaying => 'Toplam oynama süresi';

  @override
  String get perfStatAverageOpponent => 'Ortalama rakip';

  @override
  String get perfStatVictories => 'Zaferler';

  @override
  String get perfStatDefeats => 'Yenilgiler';

  @override
  String get perfStatDisconnections => 'Oyundan kopma sayısı';

  @override
  String get perfStatNotEnoughGames => 'Yapılan maç sayısı yeterli değil';

  @override
  String perfStatHighestRating(String param) {
    return 'En yüksek puan: $param';
  }

  @override
  String perfStatLowestRating(String param) {
    return 'En düşük puan: $param';
  }

  @override
  String perfStatFromXToY(String param1, String param2) {
    return '$param1 tarihinden $param2 tarihine kadar';
  }

  @override
  String get perfStatWinningStreak => 'Kazanma serisi';

  @override
  String get perfStatLosingStreak => 'Yenilgi serisi';

  @override
  String perfStatLongestStreak(String param) {
    return 'En uzun seri: $param';
  }

  @override
  String perfStatCurrentStreak(String param) {
    return 'Mevcut seri: $param';
  }

  @override
  String get perfStatBestRated => 'Destansı zaferler';

  @override
  String get perfStatGamesInARow => 'Üst üste yapılan maçlar';

  @override
  String get perfStatLessThanOneHour => 'Maçlar arasında bir saatten az bir boşluk olmalı';

  @override
  String get perfStatMaxTimePlaying => 'Oyun için harcanan en uzun süre';

  @override
  String get perfStatNow => 'şimdi';

  @override
  String get preferencesPreferences => 'Tercihler';

  @override
  String get preferencesDisplay => 'Görünüm';

  @override
  String get preferencesPrivacy => 'Gizlilik';

  @override
  String get preferencesNotifications => 'Bildirimler';

  @override
  String get preferencesPieceAnimation => 'Hamle animasyonu';

  @override
  String get preferencesMaterialDifference => 'Taş farkı';

  @override
  String get preferencesBoardHighlights => 'Tahta uyarıları (son hamle ve şah çekme)';

  @override
  String get preferencesPieceDestinations =>
      'Taşın gidebileceği kareler (geçerli hamleler ve ön hamleler)';

  @override
  String get preferencesBoardCoordinates => 'Tahta koordinatları (A-H, 1-8)';

  @override
  String get preferencesMoveListWhilePlaying => 'Oyun sırasında notasyonu göster';

  @override
  String get preferencesPgnPieceNotation => 'Notasyonda taşların simgesi';

  @override
  String get preferencesChessPieceSymbol => 'Satranç taşı sembolü';

  @override
  String get preferencesPgnLetter => 'Harf (K, Q, R, B, N)';

  @override
  String get preferencesZenMode => 'Sade görünüm';

  @override
  String get preferencesShowPlayerRatings => 'Oyuncu puanlarını göster';

  @override
  String get preferencesShowFlairs => 'Oyuncu rozetlerini göster';

  @override
  String get preferencesExplainShowPlayerRatings =>
      'Bu seçenek, sitedeki bütün oyuncu puanlarını gizleyerek yalnızca satranca odaklanmanıza yardımcı olur. Hâlâ puanlı maçlar oynayabilirsiniz ancak puanlar sizden gizlenir.';

  @override
  String get preferencesDisplayBoardResizeHandle => 'Tahta büyüklüğünü ayarlama kolunu göster';

  @override
  String get preferencesOnlyOnInitialPosition => 'Sadece başlangıç konumunda';

  @override
  String get preferencesInGameOnly => 'Sadece oyun sırasında';

  @override
  String get preferencesExceptInGame => 'Oyun içi dışında';

  @override
  String get preferencesChessClock => 'Satranç saati';

  @override
  String get preferencesTenthsOfSeconds => 'Saniyenin onda biri';

  @override
  String get preferencesWhenTimeRemainingLessThanTenSeconds => 'Kalan zaman 10 saniyeden az ise';

  @override
  String get preferencesHorizontalGreenProgressBars => 'Yeşil yatay ilerleme çubuğu';

  @override
  String get preferencesSoundWhenTimeGetsCritical => 'Zaman kritik seviyeye düştüğünde sesle uyar';

  @override
  String get preferencesGiveMoreTime => 'Fazladan süre ver';

  @override
  String get preferencesGameBehavior => 'Oyun tercihleri';

  @override
  String get preferencesHowDoYouMovePieces => 'Taşları nasıl hareket ettirirsin?';

  @override
  String get preferencesClickTwoSquares => 'İki kareye tıklayarak';

  @override
  String get preferencesDragPiece => 'Taşı sürükleyerek';

  @override
  String get preferencesBothClicksAndDrag => 'İkisi de';

  @override
  String get preferencesPremovesPlayingDuringOpponentTurn =>
      'Ön hamleler (hamle sırası rakipteyken oynama)';

  @override
  String get preferencesTakebacksWithOpponentApproval => 'Hamle geri alma (rakibin onayıyla)';

  @override
  String get preferencesInCasualGamesOnly => 'Sadece puansız oyunlarda';

  @override
  String get preferencesPromoteToQueenAutomatically =>
      'Geçer piyonu otomatik olarak Vezir\'e terfi et';

  @override
  String get preferencesExplainPromoteToQueenAutomatically =>
      'Otomatik terfiyi geçici olarak devre dışı bırakmak için terfi sırasında <ctrl> tuşunu basılı tutun';

  @override
  String get preferencesWhenPremoving => 'Ön hamlelerde';

  @override
  String get preferencesClaimDrawOnThreefoldRepetitionAutomatically =>
      'Üçlü tekrarda otomatik olarak beraberlik teklif et';

  @override
  String get preferencesWhenTimeRemainingLessThanThirtySeconds => 'Kalan zaman 30 saniyeden az ise';

  @override
  String get preferencesMoveConfirmation => 'Hamleyi onayla';

  @override
  String get preferencesExplainCanThenBeTemporarilyDisabled =>
      'Oyun esnasında tahta menüsünden devre dışı bırakılabilir';

  @override
  String get preferencesInCorrespondenceGames => 'Yazışmalı oyunlar';

  @override
  String get preferencesCorrespondenceAndUnlimited => 'Yazışmalı ve sınırsız';

  @override
  String get preferencesConfirmResignationAndDrawOffers =>
      'Oyundan çekilme ve beraberlik tekliflerini onayla';

  @override
  String get preferencesCastleByMovingTheKingTwoSquaresOrOntoTheRook => 'Rok atma şekli';

  @override
  String get preferencesCastleByMovingTwoSquares => 'Şahı iki kare sürerek';

  @override
  String get preferencesCastleByMovingOntoTheRook => 'Şahı kalenin üstüne getirerek';

  @override
  String get preferencesInputMovesWithTheKeyboard => 'Hamleleri Klavye ile yap';

  @override
  String get preferencesInputMovesWithVoice => 'Hamleleri sesinizle sağlayın';

  @override
  String get preferencesSnapArrowsToValidMoves => 'Sadece mümkün hamlelere ok çiz';

  @override
  String get preferencesSayGgWpAfterLosingOrDrawing =>
      'Beraberlik veya yenilgiyle biten maçların sonunda \"İyi oyundu, güzel oynadın\" mesajı gönder';

  @override
  String get preferencesYourPreferencesHaveBeenSaved => 'Tercihleriniz kaydedildi.';

  @override
  String get preferencesScrollOnTheBoardToReplayMoves =>
      'Hamleleri tekrar görmek için fare tekerleğini tahta üzerinde kaydırın';

  @override
  String get preferencesCorrespondenceEmailNotification =>
      'Günlük yazışmalı oyunlarınızı listeleyen posta bildirimi alın';

  @override
  String get preferencesNotifyStreamStart => 'Canlı yayın başladığında';

  @override
  String get preferencesNotifyInboxMsg => 'Gelen kutusunda yeni bir mesaj';

  @override
  String get preferencesNotifyForumMention => 'Sizden bahseden bir forum mesajı';

  @override
  String get preferencesNotifyInvitedStudy => 'Çalışma daveti';

  @override
  String get preferencesNotifyGameEvent => 'Yazışmalı oyun güncellemeleri';

  @override
  String get preferencesNotifyChallenge => 'Meydan okumalar';

  @override
  String get preferencesNotifyTournamentSoon => 'Yakında başlayan turnuva';

  @override
  String get preferencesNotifyTimeAlarm => 'Yazışmalı oyununuzda süreniz azalıyor';

  @override
  String get preferencesNotifyBell => 'Lichess içinde çan bildirimi';

  @override
  String get preferencesNotifyPush => 'Lichess\'te değilken cihaz bildirimleri';

  @override
  String get preferencesNotifyWeb => 'Tarayıcı';

  @override
  String get preferencesNotifyDevice => 'Cihaz';

  @override
  String get preferencesBellNotificationSound => 'Çan bildirimi sesi';

  @override
  String get preferencesBlindfold => 'Körleme modu';

  @override
  String get puzzlePuzzles => 'Bulmacalar';

  @override
  String get puzzlePuzzleThemes => 'Bulmaca temaları';

  @override
  String get puzzleRecommended => 'Önerilen';

  @override
  String get puzzlePhases => 'Oyun aşamaları';

  @override
  String get puzzleMotifs => 'Motifler';

  @override
  String get puzzleAdvanced => 'İleri düzey';

  @override
  String get puzzleLengths => 'Uzunluğa göre';

  @override
  String get puzzleMates => 'Matlar';

  @override
  String get puzzleGoals => 'Hedefler';

  @override
  String get puzzleOrigin => 'Kaynak';

  @override
  String get puzzleSpecialMoves => 'Özel hamleler';

  @override
  String get puzzleDidYouLikeThisPuzzle => 'Bulmacayı beğendiniz mi?';

  @override
  String get puzzleVoteToLoadNextOne => 'Sıradakine geçmek için oy verin!';

  @override
  String get puzzleUpVote => 'Bulmacayı beğen';

  @override
  String get puzzleDownVote => 'Bulmacayı beğenme';

  @override
  String get puzzleYourPuzzleRatingWillNotChange =>
      'Bulmaca puanınız değişmeyecek. Bulmacaların bir yarış olmadığını unutmayın. Bu puan mevcut becerilerinize en uygun bulmacayı seçmeye yardımcı olur.';

  @override
  String get puzzleFindTheBestMoveForWhite => 'Beyaz için en iyi hamleyi bulunuz.';

  @override
  String get puzzleFindTheBestMoveForBlack => 'Siyah için en iyi hamleyi bulun.';

  @override
  String get puzzleToGetPersonalizedPuzzles => 'Kişiselleştirilmiş bulmacalar için:';

  @override
  String puzzlePuzzleId(String param) {
    return 'Bulmaca $param';
  }

  @override
  String get puzzlePuzzleOfTheDay => 'Günün bulmacası';

  @override
  String get puzzleDailyPuzzle => 'Günlük Bulmaca';

  @override
  String get puzzleClickToSolve => 'Çözmek için tıklayın';

  @override
  String get puzzleGoodMove => 'İyi hamle';

  @override
  String get puzzleBestMove => 'En iyi hamle!';

  @override
  String get puzzleKeepGoing => 'Devam et...';

  @override
  String get puzzlePuzzleSuccess => 'Başarılı!';

  @override
  String get puzzlePuzzleComplete => 'Bulmaca tamamlandı!';

  @override
  String get puzzleByOpenings => 'Açılışlardan';

  @override
  String get puzzlePuzzlesByOpenings => 'Açılışlardan bulmacalar';

  @override
  String get puzzleOpeningsYouPlayedTheMost => 'Dereceli oyunlarda en çok oynadığınız açılışlar';

  @override
  String get puzzleUseFindInPage =>
      'Favori açılışlarınızı bulmak için tarayıcı menüsündeki \" Sayfa içinde bul\" seçeneğini kullanın!';

  @override
  String get puzzleUseCtrlF => 'Favori açılışınızı bulmak bulmak için Ctrl+f kısayolunu kullanın!';

  @override
  String get puzzleNotTheMove => 'Olmadı!';

  @override
  String get puzzleTrySomethingElse => 'Başka bir şey dene.';

  @override
  String puzzleRatingX(String param) {
    return 'Puan: $param';
  }

  @override
  String get puzzleHidden => 'gizli';

  @override
  String puzzleFromGameLink(String param) {
    return 'Maçın linki: $param';
  }

  @override
  String get puzzleContinueTraining => 'Pratik yapmaya devam et';

  @override
  String get puzzleDifficultyLevel => 'Zorluk seviyesi';

  @override
  String get puzzleNormal => 'Normal';

  @override
  String get puzzleEasier => 'Kolay';

  @override
  String get puzzleEasiest => 'Çok kolay';

  @override
  String get puzzleHarder => 'Zor';

  @override
  String get puzzleHardest => 'Çok zor';

  @override
  String get puzzleExample => 'Örnek';

  @override
  String get puzzleAddAnotherTheme => 'Başka bir tema ekle';

  @override
  String get puzzleNextPuzzle => 'Sıradaki bulmaca';

  @override
  String get puzzleJumpToNextPuzzleImmediately => 'Hemen sonraki bulmacaya atla';

  @override
  String get puzzlePuzzleDashboard => 'Bulmaca kontrol paneli';

  @override
  String get puzzleImprovementAreas => 'Gelişim alanları';

  @override
  String get puzzleStrengths => 'Güçlü yönler';

  @override
  String get puzzleHistory => 'Bulmaca geçmişi';

  @override
  String get puzzleSolved => 'çözüldü';

  @override
  String get puzzleFailed => 'başarısız';

  @override
  String get puzzleStreakDescription =>
      'Giderek zorlaşan bulmacaları çözün ve bir galibiyet serisi oluşturun. Zaman sınırı yok, bu yüzden acele etmeyin. Bir yanlış hamleye oyun biter! Fakat tur başına bir hamle atlayabilirsiniz.';

  @override
  String puzzleYourStreakX(String param) {
    return 'Seriniz: $param';
  }

  @override
  String get puzzleStreakSkipExplanation =>
      'Serini korumak için bu hamleyi atla! Her turda sadece bir atlama hakkın var.';

  @override
  String get puzzleContinueTheStreak => 'Seriye devam et';

  @override
  String get puzzleNewStreak => 'Yeni seri';

  @override
  String get puzzleFromMyGames => 'Benim oyunlarımdan';

  @override
  String get puzzleLookupOfPlayer => 'Bir oyuncunun oyunlarından bulmaca ara';

  @override
  String get puzzleSearchPuzzles => 'Bulmaca ara';

  @override
  String get puzzleFromMyGamesNone =>
      'Veri tabanında sizin maçlarınızdan bir bulmaca bulamadık ama dert etmeyin, Lichess pabucunuzu dama atmadı. Size ait bulmacaların eklenme şansını artırmak için rapid ve klasik maçlar oynayın!';

  @override
  String get puzzlePuzzleDashboardDescription =>
      'Egzersiz yapın, analiz edin, becerilerinizi geliştirin';

  @override
  String puzzlePercentSolved(String param) {
    return '$param çözüldü';
  }

  @override
  String get puzzleNoPuzzlesToShow => 'Gösterilecek bir şey yok. Önce biraz bulmaca çöz!';

  @override
  String get puzzleImprovementAreasDescription =>
      'Gelişiminizi optimize etmek için bunlar üzerine çalışın!';

  @override
  String get puzzleStrengthDescription => 'En iyi performansı bu temalarda gösteriyorsunuz';

  @override
  String puzzlePlayedXTimes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count kez çözüldü',
      one: '$count kez çözüldü',
    );
    return '$_temp0';
  }

  @override
  String puzzleNbPointsBelowYourPuzzleRating(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Bulmaca puanınızın $count puan altında',
      one: 'Bulmaca puanınızın bir puan altında',
    );
    return '$_temp0';
  }

  @override
  String puzzleNbPointsAboveYourPuzzleRating(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Bulmaca puanınızdan $count puan yüksek',
      one: 'Bulmaca puanınızdan bir puan yüksek',
    );
    return '$_temp0';
  }

  @override
  String puzzlePuzzlesFoundInUserGames(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count bulmaca oyunlar arasında $param2 tarafından bulundu',
      one: 'Bir bulmaca oyunlar arasında $param2 tarafından bulundu',
    );
    return '$_temp0';
  }

  @override
  String puzzleNbPlayed(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count bulmaca',
      one: '$count bulmaca',
    );
    return '$_temp0';
  }

  @override
  String puzzleNbToReplay(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count gözden geçirilecek',
      one: '$count gözden geçirilecek',
    );
    return '$_temp0';
  }

  @override
  String get puzzleThemeAdvancedPawn => 'İlerlemiş piyon';

  @override
  String get puzzleThemeAdvancedPawnDescription =>
      'Terfi eden veya terfi etmek üzere olan bir piyon taktik bilgisinin olmazsa olmazıdır.';

  @override
  String get puzzleThemeAdvantage => 'Avantaj';

  @override
  String get puzzleThemeAdvantageDescription =>
      'Mutlak bir üstünlük kazanma şansını yakala. (200sp ≤ analiz ≤ 600sp)';

  @override
  String get puzzleThemeAnastasiaMate => 'Anastasia matı';

  @override
  String get puzzleThemeAnastasiaMateDescription =>
      'Kale veya vezir, atın yardımıyla tahtanın kenarı ve kendi taşı arasında sıkıştırılan rakip şahı mat eder.';

  @override
  String get puzzleThemeArabianMate => 'Arap matı';

  @override
  String get puzzleThemeArabianMateDescription =>
      'At ile kalenin, rakip şahı tahtanın köşesine sıkıştırdığı matlar.';

  @override
  String get puzzleThemeAttackingF2F7 => 'Saldırı: f2 ve f7';

  @override
  String get puzzleThemeAttackingF2F7Description =>
      'Kızarmış karaciğer açılışında olduğu gibi f2 veya f7 karesindeki piyonları hedef alan saldırılar.';

  @override
  String get puzzleThemeAttraction => 'Cezbetme';

  @override
  String get puzzleThemeAttractionDescription =>
      'Rakip taşı türlü taktiklere müsait bir kareye gitmeye zorlayan yahut teşvik eden takas veya taş fedası.';

  @override
  String get puzzleThemeBackRankMate => 'Koridor matı';

  @override
  String get puzzleThemeBackRankMateDescription =>
      'Kendi taşları arkasında sıkışıp kalmış şaha koridorun kapısını göster.';

  @override
  String get puzzleThemeBishopEndgame => 'Fil oyunsonu';

  @override
  String get puzzleThemeBishopEndgameDescription => 'Sadece fil ve piyon içeren oyunsonu.';

  @override
  String get puzzleThemeBodenMate => 'Boden matı';

  @override
  String get puzzleThemeBodenMateDescription =>
      'İki fil, kendi taşları tarafından kısıtlanan şaha farklı açılardan girişerek onu mat eder.';

  @override
  String get puzzleThemeCastling => 'Rok';

  @override
  String get puzzleThemeCastlingDescription => 'Şahı güvene alırken kaleni saldırıya hazırla.';

  @override
  String get puzzleThemeCapturingDefender => 'Savunmayı baltala';

  @override
  String get puzzleThemeCapturingDefenderDescription =>
      'Bir taşı savunan diğer bir taşı ortadan kaldırarak savunmasız kalan taşı sonraki hamlede ele geçir.';

  @override
  String get puzzleThemeCrushing => 'Ezici üstünlük';

  @override
  String get puzzleThemeCrushingDescription =>
      'Rakibin vahim hatasını yakalayarak ezici bir üstünlük elde et. (analiz ≥ 600sp)';

  @override
  String get puzzleThemeDoubleBishopMate => 'Çift fil matı';

  @override
  String get puzzleThemeDoubleBishopMateDescription =>
      'Yan yana konuşlanmış iki fil, kendi taşları tarafından kısıtlanmış şahı mat eder.';

  @override
  String get puzzleThemeDovetailMate => 'Kurtağzı matı';

  @override
  String get puzzleThemeDovetailMateDescription =>
      'İki kaçış yolu da kendi taşlarınca kapalı olan şah, hemen çaprazına konuşlanan vezir tarafından mat edilir.';

  @override
  String get puzzleThemeEquality => 'Eşitlik';

  @override
  String get puzzleThemeEqualityDescription =>
      'Kaybeden bir durumdan paçayı kurtararak beraberlik veya dengeli bir pozisyon elde et. (analiz ≤ 200sp)';

  @override
  String get puzzleThemeKingsideAttack => 'Şah tarafına saldırı';

  @override
  String get puzzleThemeKingsideAttackDescription => 'Kısa rok atan rahip şaha saldırı.';

  @override
  String get puzzleThemeClearance => 'Boşaltma';

  @override
  String get puzzleThemeClearanceDescription =>
      'Bir kareyi veya bir hattı arkasından gelecek taktiğe hazırlayan, genellikle oynayan tarafa tempo kazandıran hamleler.';

  @override
  String get puzzleThemeDefensiveMove => 'Savunma hamlesi';

  @override
  String get puzzleThemeDefensiveMoveDescription =>
      'Taş veya avantaj kaybını önlemek için yapılması gereken bir hamle ya da hamleler dizisi.';

  @override
  String get puzzleThemeDeflection => 'Saptırma';

  @override
  String get puzzleThemeDeflectionDescription =>
      'Rakip taşı önemli bir kareyi korumak gibi mühim bir görevden alıkoyan hamleler.';

  @override
  String get puzzleThemeDiscoveredAttack => 'Açarak saldırı';

  @override
  String get puzzleThemeDiscoveredAttackDescription =>
      'Uzun menzilli bir taşın yolunu kesen diğer bir taşı oynayarak yapılan saldırılar. Atı oynayarak kaleyle şah çekmek gibi.';

  @override
  String get puzzleThemeDoubleCheck => 'Çifte şah';

  @override
  String get puzzleThemeDoubleCheckDescription =>
      'Bir hamlede, hem hareket eden hem de bu hareket sonucu önü açılan taş ile rakibe aynı anda iki farklı yerden şah çek.';

  @override
  String get puzzleThemeEndgame => 'Oyunsonu';

  @override
  String get puzzleThemeEndgameDescription => 'Oyunun son aşamasında hayat kurtarıcı taktikler.';

  @override
  String get puzzleThemeEnPassantDescription =>
      'Başlangıçta iki kare ileri giden kurnaz piyonun, rakip piyon ile yan yana geldikten sonra geçerken alma kuralı sebebiyle helvasının yendiği taktikler.';

  @override
  String get puzzleThemeExposedKing => 'Savunmasız şah';

  @override
  String get puzzleThemeExposedKingDescription =>
      'Şahın defansa gelin diye feryat ettiği, çoğu zaman mata giden taktikler.';

  @override
  String get puzzleThemeFork => 'Çatal';

  @override
  String get puzzleThemeForkDescription =>
      'Bir taşın aynı anda iki rakip taşa saldırdığı hamleler.';

  @override
  String get puzzleThemeHangingPiece => 'Askıda taş';

  @override
  String get puzzleThemeHangingPieceDescription =>
      'Savunmasız veya yeterince korunmayan, yenilebilecek taşları içeren taktikler.';

  @override
  String get puzzleThemeHookMate => 'Kanca matı';

  @override
  String get puzzleThemeHookMateDescription =>
      'Bir kale, at ve piyonla beraber şahın kaçışını kısıtlayan bir rakip piyonun kullanıldığı mat.';

  @override
  String get puzzleThemeInterference => 'Yol Kesme';

  @override
  String get puzzleThemeInterferenceDescription =>
      'Rakip taşların arasına kendi taşını koyarak rakibin bir taşını ya da iki taşını da savunmasız bırak. Rakibin iki kalesinin arasındaki güvenli bir kareye atı oynamak gibi.';

  @override
  String get puzzleThemeIntermezzo => 'Ara hamle';

  @override
  String get puzzleThemeIntermezzoDescription =>
      'Beklenen hamleyi oynamadan önce rakibin derhal yanıt vermesi gereken başka bir tehdit oluştur. Bu taktik aynı zamanda \"Zwischenzug\" olarak da bilinir.';

  @override
  String get puzzleThemeKillBoxMate => 'Kafesleme matı';

  @override
  String get puzzleThemeKillBoxMateDescription =>
      'Rakip şahının yanında bir kale bulunur ve bir vezir tarafından desteklenir ve bu kale aynı zamanda şahın kaçış karelerini de engeller. Kale ve vezir, düşman şahını 3\'e 3\'lük bir \"kafeste\" sıkıştırır.';

  @override
  String get puzzleThemeVukovicMate => 'Vukovic matı';

  @override
  String get puzzleThemeVukovicMateDescription =>
      'Bir kale ve at, şahı mat etmek için bir araya gelir. Kale, üçüncü bir taşla desteklenerek mat eder ve at şahın kaçış karelerini engellemek için kullanılır.';

  @override
  String get puzzleThemeKnightEndgame => 'At oyunsonu';

  @override
  String get puzzleThemeKnightEndgameDescription => 'Sadece at ve piyon içeren oyunsonu.';

  @override
  String get puzzleThemeLong => 'Uzun bulmaca';

  @override
  String get puzzleThemeLongDescription => 'Üç hamlede kazanç.';

  @override
  String get puzzleThemeMaster => 'Ustaların oyunları';

  @override
  String get puzzleThemeMasterDescription => 'Unvanlı oyuncuların oyunlarından bulmacalar.';

  @override
  String get puzzleThemeMasterVsMaster => 'Ustaların ustalarla oynadığı oyunlar';

  @override
  String get puzzleThemeMasterVsMasterDescription =>
      'Unvanlı iki oyuncunun oyunlarından bulmacalar.';

  @override
  String get puzzleThemeMate => 'Mat';

  @override
  String get puzzleThemeMateDescription => 'Oyunu tarz ile kazanın.';

  @override
  String get puzzleThemeMateIn1 => '1 Hamlede Mat';

  @override
  String get puzzleThemeMateIn1Description => 'Tek hamlede rakibi mat et.';

  @override
  String get puzzleThemeMateIn2 => '2 Hamlede Mat';

  @override
  String get puzzleThemeMateIn2Description => 'İki hamlede rakibi mat et.';

  @override
  String get puzzleThemeMateIn3 => '3 Hamlede Mat';

  @override
  String get puzzleThemeMateIn3Description => 'Üç hamlede rakibi mat et.';

  @override
  String get puzzleThemeMateIn4 => '4 Hamlede Mat';

  @override
  String get puzzleThemeMateIn4Description => 'Dört hamlede rakibi mat et.';

  @override
  String get puzzleThemeMateIn5 => '5 hamle ve üstü matlar';

  @override
  String get puzzleThemeMateIn5Description => 'Uzun bir mat serisini çözmeye çalış.';

  @override
  String get puzzleThemeMiddlegame => 'Oyunortası';

  @override
  String get puzzleThemeMiddlegameDescription =>
      'Oyunun ikinci aşamasında her eve lazım taktikler.';

  @override
  String get puzzleThemeOneMove => 'Tek hamlelik bulmaca';

  @override
  String get puzzleThemeOneMoveDescription => 'Yalnızca bir hamle uzunluğundaki bulmacalar.';

  @override
  String get puzzleThemeOpening => 'Açılış';

  @override
  String get puzzleThemeOpeningDescription =>
      'Oyunun ilk aşamasında hayatınızı kolaylaştıran taktikler.';

  @override
  String get puzzleThemePawnEndgame => 'Piyon oyunsonu';

  @override
  String get puzzleThemePawnEndgameDescription => 'Yalnızca piyonların olduğu oyunsonları.';

  @override
  String get puzzleThemePin => 'Açmaz';

  @override
  String get puzzleThemePinDescription =>
      'Hareket ettiği takdirde arkasında bulunan, kendisinden daha değerli bir taş tehlikeye düşeceği için olduğu yere mıhlanmış zavallı taşları içeren taktikler.';

  @override
  String get puzzleThemePromotion => 'Terfi';

  @override
  String get puzzleThemePromotionDescription =>
      'Terfi eden veya terfi etmek üzere olan bir piyon taktik bilgisinin olmazsa olmazıdır.';

  @override
  String get puzzleThemeQueenEndgame => 'Vezir oyunsonu';

  @override
  String get puzzleThemeQueenEndgameDescription => 'Sadece vezir ve piyon içeren oyunsonu.';

  @override
  String get puzzleThemeQueenRookEndgame => 'Vezir ve kale oyunsonu';

  @override
  String get puzzleThemeQueenRookEndgameDescription =>
      'Sadece vezir, kale ve piyon içeren oyunsonu.';

  @override
  String get puzzleThemeQueensideAttack => 'Vezir tarafına saldırı';

  @override
  String get puzzleThemeQueensideAttackDescription => 'Uzun rok atan rahip şaha saldırı.';

  @override
  String get puzzleThemeQuietMove => 'Sakin hamle';

  @override
  String get puzzleThemeQuietMoveDescription =>
      'Şah çekmenin veya taş yemenin olmadığı, ancak gelecekteki kaçınılmaz bir tehdidin temelini atan hamleler.';

  @override
  String get puzzleThemeRookEndgame => 'Kale oyunsonu';

  @override
  String get puzzleThemeRookEndgameDescription => 'Sadece kale ve piyon içeren oyunsonu.';

  @override
  String get puzzleThemeSacrifice => 'Feda';

  @override
  String get puzzleThemeSacrificeDescription =>
      'Zorunlu hamleler serisinden sonra avantaj elde etmek için kısa vadede en az bir taşı gözden çıkarmanız gereken taktikler.';

  @override
  String get puzzleThemeShort => 'Kısa bulmaca';

  @override
  String get puzzleThemeShortDescription => 'İki hamlede kazanç.';

  @override
  String get puzzleThemeSkewer => 'Şiş';

  @override
  String get puzzleThemeSkewerDescription =>
      'Değerli bir taşın saldırı altında olduğu, hareketi hâlinde ise arkasındaki daha düşük değerli bir taşın düşeceği ya da tehlikeye gireceği motifler. Bir nevi açmazın tersi.';

  @override
  String get puzzleThemeSmotheredMate => 'Boğmaca Matı';

  @override
  String get puzzleThemeSmotheredMateDescription =>
      'Kendi taşları tarafından çevrelendiği (ya da boğulduğu) için hareket edemeyen şahın at ile mat edildiği pozisyonlar.';

  @override
  String get puzzleThemeSuperGM => 'Süper GM\'lerin oyunları';

  @override
  String get puzzleThemeSuperGMDescription =>
      'Dünyanın en iyi oyuncularının oyunlarından bulmacalar.';

  @override
  String get puzzleThemeTrappedPiece => 'Tuzağa düşmüş taş';

  @override
  String get puzzleThemeTrappedPieceDescription =>
      'Gidecek güvenli bir kare kalmadığı için kaçacak yerleri olmayan taşlar.';

  @override
  String get puzzleThemeUnderPromotion => 'Düşük terfi';

  @override
  String get puzzleThemeUnderPromotionDescription => 'At, fil veya kaleye terfi.';

  @override
  String get puzzleThemeVeryLong => 'Çok uzun bulmaca';

  @override
  String get puzzleThemeVeryLongDescription => 'Dört hamle veya daha uzun kazançlar.';

  @override
  String get puzzleThemeXRayAttack => 'X-Işını Saldırısı';

  @override
  String get puzzleThemeXRayAttackDescription =>
      'Rakibin taşı üzerinden bir kareyi koruyan veya bir kareye saldıran taşları içeren taktikler.';

  @override
  String get puzzleThemeZugzwang => 'Zugzwang';

  @override
  String get puzzleThemeZugzwangDescription =>
      'Rakibin iyi bir hamlesinin kalmadığı, yapabileceği bütün hamlelerin kendisine zarar vereceği taktikler.';

  @override
  String get puzzleThemeMix => 'Bir ondan bir bundan';

  @override
  String get puzzleThemeMixDescription =>
      'Ortaya karışık bulmacalar. Karşına ne tür bir pozisyonun çıkacağı tam bir muamma. Tıpkı gerçek maçlardaki gibi her şeye hazırlıklı olmakta fayda var.';

  @override
  String get puzzleThemePlayerGames => 'Bireysel oyunlar';

  @override
  String get puzzleThemePlayerGamesDescription =>
      'Sizin veya başka bir oyuncunun maçlarından üretilen bulmacalar.';

  @override
  String puzzleThemePuzzleDownloadInformation(String param) {
    return 'Bütün bulmacalar kamuya açıktır ve $param adresinden indirilebilir.';
  }

  @override
  String get searchSearch => 'Ara';

  @override
  String get settingsSettings => 'Ayarlar';

  @override
  String get settingsCloseAccount => 'Hesabı kapat';

  @override
  String get settingsManagedAccountCannotBeClosed =>
      'Hesabınız başkası tarafından yönetiliyor, kapatılamaz.';

  @override
  String get settingsCantOpenSimilarAccount =>
      'Büyük-küçük harf değişiklikleri yapsanız dahi aynı kullanıcı adıyla yeni bir hesap açamazsınız.';

  @override
  String get settingsCancelKeepAccount => 'Vazgeç ve hesabımı koru';

  @override
  String get settingsCloseAccountAreYouSure => 'Hesabınızı kapatmak istediğinize emin misiniz?';

  @override
  String get settingsThisAccountIsClosed => 'Hesap kapatılmıştır.';

  @override
  String get playWithAFriend => 'Bir arkadaşınla oyna';

  @override
  String get playWithTheMachine => 'Bilgisayara karşı oyna';

  @override
  String get toInviteSomeoneToPlayGiveThisUrl => 'Oyuna davet etmek için, bu linki gönderin';

  @override
  String get gameOver => 'Oyun bitti';

  @override
  String get waitingForOpponent => 'Rakip bekleniyor';

  @override
  String get orLetYourOpponentScanQrCode => 'Veya rakibiniz bu QR kodunu tarasın';

  @override
  String get waiting => 'Bekleniyor';

  @override
  String get yourTurn => 'Sıra sizde';

  @override
  String aiNameLevelAiLevel(String param1, String param2) {
    return '$param1 seviye $param2';
  }

  @override
  String get level => 'Seviye';

  @override
  String get strength => 'Kuvvet';

  @override
  String get toggleTheChat => 'Sohbeti aç/kapat';

  @override
  String get chat => 'Sohbet';

  @override
  String get resign => 'Oyundan Çekil';

  @override
  String get checkmate => 'Şah Mat';

  @override
  String get stalemate => 'Pat';

  @override
  String get white => 'Beyaz';

  @override
  String get black => 'Siyah';

  @override
  String get asWhite => 'beyazda';

  @override
  String get asBlack => 'siyahlarda';

  @override
  String get randomColor => 'Rastgele renk';

  @override
  String get createAGame => 'Yeni bir oyun kur';

  @override
  String get createTheGame => 'Oyunu oluştur';

  @override
  String get whiteIsVictorious => 'Zafer Beyazın';

  @override
  String get blackIsVictorious => 'Zafer Siyahın';

  @override
  String get youPlayTheWhitePieces => 'Beyaz taşlar sizin';

  @override
  String get youPlayTheBlackPieces => 'Siyah taşlar sizin';

  @override
  String get itsYourTurn => 'Sıra sizde!';

  @override
  String get cheatDetected => 'Hile Tespit Edildi';

  @override
  String get kingInTheCenter => 'Şah merkezde';

  @override
  String get threeChecks => 'Üç şah';

  @override
  String get raceFinished => 'Yarış bitti';

  @override
  String get variantEnding => 'Varyant bitti';

  @override
  String get newOpponent => 'Yeni rakip';

  @override
  String get yourOpponentWantsToPlayANewGameWithYou =>
      'Rakibiniz sizinle yeni bir oyun oynamak istiyor';

  @override
  String get joinTheGame => 'Oyuna katıl';

  @override
  String get whitePlays => 'Hamle Beyazda';

  @override
  String get blackPlays => 'Hamle Siyahta';

  @override
  String get opponentLeftChoices =>
      'Rakibiniz oyundan düştü ya da masayı terk etti. İsterseniz dönmesini bekleyebilir, oyuna berabere diyebilir ya da galibiyetinizi talep edebilirsiniz.';

  @override
  String get forceResignation => 'Galibiyet talep et';

  @override
  String get forceDraw => 'Beraberlik ilan et';

  @override
  String get talkInChat => 'Lütfen sohbette nazik ol!';

  @override
  String get theFirstPersonToComeOnThisUrlWillPlayWithYou =>
      'Bağlantıya ilk ulaşan kişi rakibiniz olacak.';

  @override
  String get whiteResigned => 'Beyaz oyundan çekildi';

  @override
  String get blackResigned => 'Siyah oyundan çekildi';

  @override
  String get whiteLeftTheGame => 'Beyaz oyundan ayrıldı';

  @override
  String get blackLeftTheGame => 'Siyah oyundan ayrıldı';

  @override
  String get whiteDidntMove => 'Beyaz hamle yapmadı';

  @override
  String get blackDidntMove => 'Siyah hamle yapmadı';

  @override
  String get requestAComputerAnalysis => 'Bilgisayar analizi talep et';

  @override
  String get computerAnalysis => 'Bilgisayar analizi';

  @override
  String get computerAnalysisAvailable => 'Bilgisayar analizi mevcut';

  @override
  String get computerAnalysisDisabled => 'Bilgisayar analizi devre dışı bırakıldı';

  @override
  String get analysis => 'Analiz tahtası';

  @override
  String depthX(String param) {
    return 'Derinlik $param';
  }

  @override
  String get usingServerAnalysis => 'Sunucu analizi yapılıyor';

  @override
  String get loadingEngine => 'Satranç motoru yükleniyor...';

  @override
  String get calculatingMoves => 'Hamleler hesaplanıyor...';

  @override
  String get engineFailed => 'Motor yüklenirken hata oluştu';

  @override
  String get cloudAnalysis => 'Bulut analizi';

  @override
  String get goDeeper => 'Daha derine in';

  @override
  String get showThreat => 'Tehdidi göster';

  @override
  String get inLocalBrowser => 'yerel tarayıcı üzerinde';

  @override
  String get toggleLocalEvaluation => 'Yerel analizi aç/kapat';

  @override
  String get promoteVariation => 'Bu varyanttan devam et';

  @override
  String get makeMainLine => 'Ana devam yolu yap';

  @override
  String get deleteFromHere => 'Bu hamleden sonrasını sil';

  @override
  String get collapseVariations => 'Varyasyonları daralt';

  @override
  String get expandVariations => 'Varyasyonları genişlet';

  @override
  String get forceVariation => 'Varyant olarak göster';

  @override
  String get copyVariationPgn => 'Varyasyon PGN\'sini kopyala';

  @override
  String get copyMainLinePgn => 'Ana PGN\'yi kopyala';

  @override
  String get move => 'Hamle';

  @override
  String get variantLoss => 'Varyant yenilgisi';

  @override
  String get variantWin => 'Varyant zaferi';

  @override
  String get insufficientMaterial => 'Yetersiz taş';

  @override
  String get pawnMove => 'Piyon hamlesi';

  @override
  String get capture => 'Taş yeme';

  @override
  String get close => 'Kapat';

  @override
  String get winning => 'Kazandıran hamle(ler)';

  @override
  String get losing => 'Kaybettiren hamle(ler)';

  @override
  String get drawn => 'Berabere';

  @override
  String get unknown => 'Belirsiz';

  @override
  String get database => 'Veritabanı';

  @override
  String get whiteDrawBlack => 'Beyaz / Berabere / Siyah';

  @override
  String averageRatingX(String param) {
    return 'Ortalama puan: $param';
  }

  @override
  String get recentGames => 'Son oyunlar';

  @override
  String get topGames => 'En yüksek puanlı oyunlar';

  @override
  String masterDbExplanation(String param1, String param2, String param3) {
    return '$param2 yılından $param3 yılına kadar $param1+ FIDE puanına sahip oyuncular tarafından tahta üzerinde oynanmış 2 milyon oyun';
  }

  @override
  String get dtzWithRounding =>
      'DTZ50\'\', bir sonraki yakalama veya piyon hamlesine kadar olan yarım hamle sayısına dayalı yuvarlama ile';

  @override
  String get noGameFound => 'Oyun bulunamadı';

  @override
  String get maxDepthReached => 'Maksimum derinliğe ulaşıldı!';

  @override
  String get maybeIncludeMoreGamesFromThePreferencesMenu =>
      'Seçenekler menüsünden daha fazla oyun eklemeyi deneyebilirsiniz.';

  @override
  String get openings => 'Açılışlar';

  @override
  String get openingExplorer => 'Açılış kâşifi';

  @override
  String get openingEndgameExplorer => 'Açılış/oyunsonu kâşifi';

  @override
  String xOpeningExplorer(String param) {
    return '$param açılış kâşifi';
  }

  @override
  String get playFirstOpeningEndgameExplorerMove =>
      'İlk sıradaki açılış kaşifi/oyun sonu analizi hamlesini oyna';

  @override
  String get winPreventedBy50MoveRule => 'Galibiyet 50 hamle kuralı yüzünden engellendi';

  @override
  String get lossSavedBy50MoveRule => 'Mağlubiyet 50 hamle kuralı sayesinde önlendi';

  @override
  String get winOr50MovesByPriorMistake => 'Galibiyet veya geçmiş hata sebebiyle 50 hamle';

  @override
  String get lossOr50MovesByPriorMistake => 'Mağlubiyet veya geçmiş hata sebebiyle 50 hamle';

  @override
  String get unknownDueToRounding =>
      'Kazanma/kaybetme, Syzygy tablo tabanlarında DTZ değerlerinin olası yuvarlanması nedeniyle, yalnızca son esir alma veya piyon hareketinden bu yana önerilen tablo tabanı çizgisi izlendiğinde garanti edilir.';

  @override
  String get allSet => 'Her şey tamam!';

  @override
  String get importPgn => 'PGN\'yi içe aktar';

  @override
  String get delete => 'Sil';

  @override
  String get deleteThisImportedGame => 'İçe aktarılmış bu oyun silinsin mi?';

  @override
  String get replayMode => 'Tekrar modu';

  @override
  String get realtimeReplay => 'Gerçek Zamanlı';

  @override
  String get byCPL => 'CPL ile';

  @override
  String get enable => 'Etkinleştir';

  @override
  String get bestMoveArrow => 'En iyi hamle imleci';

  @override
  String get showVariationArrows => 'Varyasyon oklarını göster';

  @override
  String get evaluationGauge => 'Değerlendirme çubuğu';

  @override
  String get multipleLines => 'Çoklu varyantlar';

  @override
  String get cpus => 'İşlemci';

  @override
  String get memory => 'Hafıza';

  @override
  String get infiniteAnalysis => 'Sonsuz analiz';

  @override
  String get removesTheDepthLimit => 'Derinlik sınırını kaldırır ve bilgisayarınızı sıcacık tutar';

  @override
  String get blunder => 'Vahim hata';

  @override
  String get mistake => 'Hata';

  @override
  String get inaccuracy => 'Kusurlu hamle';

  @override
  String get moveTimes => 'Hamle zamanları';

  @override
  String get flipBoard => 'Tahtayı döndür';

  @override
  String get threefoldRepetition => 'Üç kez hamle tekrarı';

  @override
  String get claimADraw => 'Beraberlik talep et';

  @override
  String get drawClaimed => 'Beraberlik iddia edildi';

  @override
  String get offerDraw => 'Beraberlik teklif et';

  @override
  String get draw => 'Berabere';

  @override
  String get drawByMutualAgreement => 'Karşılıklı anlaşma ile berabere';

  @override
  String get fiftyMovesWithoutProgress => 'Gelişme olmadan elli hamle';

  @override
  String get currentGames => 'Şu anda oynanan oyunlar';

  @override
  String joinedX(String param) {
    return '$param katıldı';
  }

  @override
  String get viewInFullSize => 'Tam ekran göster';

  @override
  String get logOut => 'Çıkış';

  @override
  String get signIn => 'Giriş';

  @override
  String get rememberMe => 'Oturumu açık bırak';

  @override
  String get youNeedAnAccountToDoThat => 'Bunu yapmanız için bir hesaba ihtiyacınız var';

  @override
  String get signUp => 'Kayıt Ol';

  @override
  String get computersAreNotAllowedToPlay =>
      'Bilgisayarlar ve bilgisayar destekli oyuncuların oynamasına izin yoktur. Lütfen maçlarda satranç motorlarından, veri tabanlarından ya da başka oyunculardan destek almayınız. Ayrıca, birden fazla hesap açmanız kesinlikle önerilmez. Çok fazla hesap açmak, hesapların kapatılmasına neden olacaktır.';

  @override
  String get games => 'Oyunlar';

  @override
  String get forum => 'Forum';

  @override
  String xPostedInForumY(String param1, String param2) {
    return '$param1, $param2 konusu altına bir mesaj yazdı';
  }

  @override
  String get latestForumPosts => 'En son forum gönderileri';

  @override
  String get players => 'Oyuncular';

  @override
  String get friends => 'Arkadaşlar';

  @override
  String get otherPlayers => 'diğer oyuncular';

  @override
  String get discussions => 'Sohbetler';

  @override
  String get today => 'Bugün';

  @override
  String get yesterday => 'Dün';

  @override
  String get minutesPerSide => 'Taraf başına dakika';

  @override
  String get variant => 'Varyant';

  @override
  String get variants => 'Varyantlar';

  @override
  String get timeControl => 'Süre ayarı';

  @override
  String get realTime => 'Gerçek zaman';

  @override
  String get correspondence => 'Yazışma';

  @override
  String get daysPerTurn => 'Hamle başına gün';

  @override
  String get oneDay => 'Bir gün';

  @override
  String get time => 'Zaman';

  @override
  String get rating => 'Puan';

  @override
  String get ratingStats => 'Puan istatistikleri';

  @override
  String get username => 'Kullanıcı adı';

  @override
  String get usernameOrEmail => 'Kullanıcı adı veya e-posta';

  @override
  String get changeUsername => 'Kullanıcı adını değiştir';

  @override
  String get changeUsernameNotSame =>
      'Sadece kullanıcı adınızdaki büyük/küçük harfleri değiştirebilirsiniz. Örneğin \"johndoe\" den \"JohnDoe\" gibi.';

  @override
  String get changeUsernameDescription =>
      'Kullanıcı adınızı değiştirin. Bu işlemi sadece 1 (bir) kez gerçekleştirebilirsiniz ve sadece mevcut kullanıcı adınızdaki harfleri (\"johndoe\", \"JohnDoe\") değiştirebilirsiniz.';

  @override
  String get signupUsernameHint =>
      'Aile dostu bir kullanıcı adı seçtiğinizden emin olun. Kullanıcı adı daha sonra değiştirilemez ve uygunsuz kullanıcı adına sahip hesaplar kapatılır!';

  @override
  String get signupEmailHint => 'Bunu yalnızca şifre sıfırlaması için kullanacağız.';

  @override
  String get password => 'Şifre';

  @override
  String get changePassword => 'Şifre değiştir';

  @override
  String get changeEmail => 'E-posta adresini değiştir';

  @override
  String get email => 'E-posta';

  @override
  String get passwordReset => 'Şifreyi yenile';

  @override
  String get forgotPassword => 'Şifremi unuttum';

  @override
  String get error_weakPassword => 'Bu parola çok yaygın, ve tahmin etmesi çok kolay.';

  @override
  String get error_namePassword => 'Lütfen kullanıcı adınızı parolanız olarak kullanmayın.';

  @override
  String get blankedPassword =>
      'Şifreniz güvenlik açığı yaşanan başka bir sitede kullanılmış. Lichess hesabınızı güvende tutmak için yeni bir şifre seçmeniz gerekiyor. Anlayışınız için teşekkürler.';

  @override
  String get youAreLeavingLichess => 'Lichess\'ten ayrılıyorsunuz';

  @override
  String get neverTypeYourPassword => 'Lichess parolanızı asla başka bir site içerisinde yazmayın!';

  @override
  String proceedToX(String param) {
    return '$param adresine devam et';
  }

  @override
  String get passwordSuggestion =>
      'Başkaları tarafından önerilen bir parolayı kullanmayın. Bunu hesabınızı çalmak için kullanacaklardır.';

  @override
  String get emailSuggestion =>
      'Başkaları tarafından önerilen bir e-posta adresi kullanmayın. Bunu hesabınızı çalmak için kullanacaklardır.';

  @override
  String get emailConfirmHelp => 'E-posta onayı için yardım';

  @override
  String get emailConfirmNotReceived => 'Kayıt olduktan sonra doğrulama e-postası almadınız mı?';

  @override
  String get whatSignupUsername => 'Kayıt olmak için hangi kullanıcı adını kullandınız?';

  @override
  String usernameNotFound(String param) {
    return '$param adında herhangi bir kullanıcı bulamadık.';
  }

  @override
  String get usernameCanBeUsedForNewAccount =>
      'Bu kullanıcı adını yeni bir hesap oluşturmak için kullanabilirsiniz';

  @override
  String emailSent(String param) {
    return '$param adresine bir e-posta gönderdik.';
  }

  @override
  String get emailCanTakeSomeTime => 'E-postanın ulaşması biraz zaman alabilir.';

  @override
  String get refreshInboxAfterFiveMinutes => '5 dakika bekleyip e-posta gelen kutunuzu yenileyin.';

  @override
  String get checkSpamFolder =>
      'Ayrıca spam klasörünü kontrol edin, orada olabilir. Eğer öyleyse spam değil olarak işaretleyin.';

  @override
  String get emailForSignupHelp => 'Hiçbiri işe yaramazsa, bize şu e-postayı gönderin:';

  @override
  String copyTextToEmail(String param) {
    return 'Yukarıdaki metni kopyalayıp $param adresine gönderin';
  }

  @override
  String get waitForSignupHelp =>
      'Kaydınızı tamamlamanıza yardımcı olmak için kısa bir süre içinde size geri döneceğiz.';

  @override
  String accountConfirmed(String param) {
    return '$param kullanıcısı başarıyla onaylandı.';
  }

  @override
  String accountCanLogin(String param) {
    return 'Artık $param olarak giriş yapabilirsiniz.';
  }

  @override
  String get accountConfirmationEmailNotNeeded => 'Onay e-postasına ihtiyacınız yok.';

  @override
  String accountClosed(String param) {
    return '$param hesabı kapatılmıştır.';
  }

  @override
  String accountRegisteredWithoutEmail(String param) {
    return '$param hesabı e-posta olmadan kaydedildi.';
  }

  @override
  String get rank => 'Sıralama';

  @override
  String rankX(String param) {
    return 'Sıralama: $param';
  }

  @override
  String get gamesPlayed => 'Oynanmış oyunlar';

  @override
  String get ok => 'Tamam';

  @override
  String get cancel => 'İptal et';

  @override
  String get whiteTimeOut => 'Beyazın zamanı tükendi';

  @override
  String get blackTimeOut => 'Siyahın zamanı tükendi';

  @override
  String get drawOfferSent => 'Beraberlik teklifi gönderildi';

  @override
  String get drawOfferAccepted => 'Beraberlik teklifi kabul edildi';

  @override
  String get drawOfferCanceled => 'Beraberlik teklifi iptal edildi';

  @override
  String get whiteOffersDraw => 'Beyaz beraberlik teklif ediyor';

  @override
  String get blackOffersDraw => 'Siyah beraberlik teklif ediyor';

  @override
  String get whiteDeclinesDraw => 'Beyaz beraberlik teklifini geri çevirdi';

  @override
  String get blackDeclinesDraw => 'Siyah beraberlik teklifini geri çevirdi';

  @override
  String get yourOpponentOffersADraw => 'Rakibiniz beraberlik teklif ediyor';

  @override
  String get accept => 'Kabul et';

  @override
  String get decline => 'Reddet';

  @override
  String get playingRightNow => 'Şu an oynanıyor';

  @override
  String get eventInProgress => 'Şu anda oynanıyor';

  @override
  String get finished => 'Bitti';

  @override
  String get abortGame => 'Oyunu iptal et';

  @override
  String get gameAborted => 'Oyun iptal edildi';

  @override
  String get standard => 'Standart';

  @override
  String get customPosition => 'Özel Konum';

  @override
  String get unlimited => 'Sınırsız';

  @override
  String get mode => 'Mod';

  @override
  String get casual => 'Puansız';

  @override
  String get rated => 'Puanlı';

  @override
  String get casualTournament => 'Puansız';

  @override
  String get ratedTournament => 'Puanlı';

  @override
  String get thisGameIsRated => 'Bu oyun derecelidir';

  @override
  String get rematch => 'Yeniden oyna';

  @override
  String get rematchOfferSent => 'Yeniden oynama teklifi yollandı';

  @override
  String get rematchOfferAccepted => 'Yeniden oynama teklifi kabul edildi';

  @override
  String get rematchOfferCanceled => 'Yeniden oynama teklifi geri çekildi';

  @override
  String get rematchOfferDeclined => 'Yeniden oynama teklifi reddedildi';

  @override
  String get cancelRematchOffer => 'Yeniden oynama teklifini geri çek';

  @override
  String get viewRematch => 'Rövanş oyununu göster';

  @override
  String get confirmMove => 'Hamleyi onayla';

  @override
  String get play => 'Oyna';

  @override
  String get inbox => 'Gelen kutusu';

  @override
  String get chatRoom => 'Sohbet odası';

  @override
  String get loginToChat => 'Sohbete katılmak için oturum aç';

  @override
  String get youHaveBeenTimedOut => 'Sohbetten men edildiniz.';

  @override
  String get spectatorRoom => 'Seyirci odası';

  @override
  String get composeMessage => 'Bir mesaj yaz';

  @override
  String get subject => 'Konu';

  @override
  String get send => 'Gönder';

  @override
  String get incrementInSeconds => 'Hamle başına eklenen saniye';

  @override
  String get freeOnlineChess => 'Ücretsiz Çevrimiçi Satranç';

  @override
  String get exportGames => 'Oyunları indir';

  @override
  String get ratingRange => 'Puan aralığı';

  @override
  String get thisAccountViolatedTos => 'Bu hesap Lichess Hizmet Şartları\'nı ihlal etti';

  @override
  String get openingExplorerAndTablebase => 'Açılış kâşifi & oyunsonu analizi';

  @override
  String get takeback => 'Hamleyi geri al';

  @override
  String get proposeATakeback => 'Hamleyi geri almayı teklif et';

  @override
  String get whiteProposesTakeback => 'Beyaz hamleyi geri alma önerisinde bulunuyor';

  @override
  String get blackProposesTakeback => 'Siyah hamleyi geri alma önerisinde bulunuyor';

  @override
  String get takebackPropositionSent => 'Hamleyi geri alma teklif edildi';

  @override
  String get whiteDeclinesTakeback => 'Beyaz hamleyi geri almayı reddediyor';

  @override
  String get blackDeclinesTakeback => 'Siyah hamleyi geri almayı reddediyor';

  @override
  String get whiteAcceptsTakeback => 'Beyaz hamleyi geri almayı kabul ediyor';

  @override
  String get blackAcceptsTakeback => 'Siyah hamleyi geri almayı kabul ediyor';

  @override
  String get whiteCancelsTakeback => 'Beyaz hamleyi geri almayı iptal ediyor';

  @override
  String get blackCancelsTakeback => 'Siyah hamleyi geri almayı iptal ediyor';

  @override
  String get yourOpponentProposesATakeback => 'Rakibiniz hamleyi geri almayı teklif etti';

  @override
  String get bookmarkThisGame => 'Bu oyunu işaretle';

  @override
  String get tournament => 'Turnuva';

  @override
  String get tournaments => 'Turnuvalar';

  @override
  String get tournamentPoints => 'Turnuvalardan alınan puanlar';

  @override
  String get viewTournament => 'Turnuvaya göz at';

  @override
  String get backToTournament => 'Turnuvaya geri dön';

  @override
  String get noDrawBeforeSwissLimit =>
      'Bir İsviçre sistemi turnuvasında 30 hamle oynanmadan beraberlik teklif edemezsiniz.';

  @override
  String get thematic => 'Tematik';

  @override
  String yourPerfRatingIsProvisional(String param) {
    return '$param puanınız geçicidir';
  }

  @override
  String yourPerfRatingIsTooHigh(String param1, String param2) {
    return '$param1 puanınız ($param2) gerekenden fazla';
  }

  @override
  String yourTopWeeklyPerfRatingIsTooHigh(String param1, String param2) {
    return 'Haftalık $param1 puanınız ($param2) gerekenden fazla';
  }

  @override
  String yourPerfRatingIsTooLow(String param1, String param2) {
    return '$param1 puanınız ($param2) gerekenden az';
  }

  @override
  String ratedMoreThanInPerf(String param1, String param2) {
    return '$param2 puanı ≥ $param1 olmalı';
  }

  @override
  String ratedLessThanInPerf(String param1, String param2) {
    return '$param2 puanı ≤ $param1 olmalı';
  }

  @override
  String mustBeInTeam(String param) {
    return '$param adlı takımda olmalısınız';
  }

  @override
  String youAreNotInTeam(String param) {
    return '$param takımının üyesi değilsiniz';
  }

  @override
  String get backToGame => 'Oyuna dön';

  @override
  String get siteDescription =>
      'Bedava çevrimiçi satranç sunucusu. Sade bir arayüzde satranç oynayın. Kayda gerek yok, reklam yok, eklenti yok. Bilgisayara karşı, arkadaşlarınızla veya rastgele bir rakiple satranç oynayın.';

  @override
  String xJoinedTeamY(String param1, String param2) {
    return '$param1, $param2 takımına katıldı';
  }

  @override
  String xCreatedTeamY(String param1, String param2) {
    return '$param1, $param2 takımını kurdu';
  }

  @override
  String get startedStreaming => 'bir yayın başlattı';

  @override
  String xStartedStreaming(String param) {
    return '$param canlı yayında';
  }

  @override
  String get averageElo => 'Ortalama derece';

  @override
  String get location => 'Yer';

  @override
  String get filterGames => 'Oyunları kategorilendir';

  @override
  String get reset => 'Sıfırla';

  @override
  String get apply => 'Uygula';

  @override
  String get save => 'Kaydet';

  @override
  String get leaderboard => 'Lider Tablosu';

  @override
  String get screenshotCurrentPosition => 'Geçerli pozisyonun ekran görüntüsünü al';

  @override
  String get gameAsGIF => 'Oyunun GIF hali';

  @override
  String get pasteTheFenStringHere => 'FEN kodunu buraya yapıştırın';

  @override
  String get pasteThePgnStringHere => 'PGN kodunu buraya yapıştırın';

  @override
  String get orUploadPgnFile => 'Veya bir PGN dosyası yükle';

  @override
  String get fromPosition => 'Özel pozisyondan';

  @override
  String get continueFromHere => 'Bu pozisyondan devam et';

  @override
  String get toStudy => 'Çalışma oluştur';

  @override
  String get importGame => 'Oyun yükle';

  @override
  String get importGameExplanation =>
      'Göz atılabilir bir oyun tekrarı, bilgisayar analizi, oyun sohbeti ve paylaşılabilir bir URL edinmek için bir oyun PGN\'si yapıştırın.';

  @override
  String get importGameCaveat =>
      'Varyasyonlar silinecek. Varyasyonları saklamak için bir çalışma aracılığıyla PGN\'yi içe aktarın.';

  @override
  String get importGameDataPrivacyWarning =>
      'Bu PGN herkes tarafından erişilebilir. Bir oyunu özel olarak yüklemek istiyorsanız bir çalışma kullanın.';

  @override
  String get thisIsAChessCaptcha => 'Bu bir satranç CAPTCHA\'sıdır.';

  @override
  String get clickOnTheBoardToMakeYourMove =>
      'İnsan olduğunuzu kanıtlamak için tahtaya tıklayın ve hamlenizi yapın.';

  @override
  String get captcha_fail => 'Lütfen satranç CAPTCHA\'sını çözün.';

  @override
  String get notACheckmate => 'Mat değil';

  @override
  String get whiteCheckmatesInOneMove => 'Beyaz bir hamlede mat eder';

  @override
  String get blackCheckmatesInOneMove => 'Siyah bir hamlede mat eder';

  @override
  String get retry => 'Tekrar dene';

  @override
  String get reconnecting => 'Yeniden bağlanılıyor';

  @override
  String get noNetwork => 'Çevrimdışı';

  @override
  String get favoriteOpponents => 'Favori rakipler';

  @override
  String get follow => 'Takip et';

  @override
  String get following => 'Takip ediyorsun';

  @override
  String get unfollow => 'Takibi bırak';

  @override
  String followX(String param) {
    return '$param Takip Et';
  }

  @override
  String unfollowX(String param) {
    return '$param Takibi Bırak';
  }

  @override
  String get block => 'Engelle';

  @override
  String get blocked => 'Engellendi';

  @override
  String get unblock => 'Engeli kaldır';

  @override
  String xStartedFollowingY(String param1, String param2) {
    return '$param1, $param2 isimli oyuncuyu takip etmeye başladı';
  }

  @override
  String get more => 'Daha fazla';

  @override
  String get memberSince => 'Üyelik tarihi';

  @override
  String lastSeenActive(String param) {
    return 'Aktif $param';
  }

  @override
  String get player => 'Oyuncu';

  @override
  String get list => 'Liste';

  @override
  String get graph => 'Grafik';

  @override
  String get required => 'Gerekli.';

  @override
  String get openTournaments => 'Açık turnuvalar';

  @override
  String get duration => 'Süre';

  @override
  String get winner => 'Kazanan';

  @override
  String get standing => 'Sıralama';

  @override
  String get createANewTournament => 'Yeni bir turnuva oluştur';

  @override
  String get tournamentCalendar => 'Turnuva takvimi';

  @override
  String get conditionOfEntry => 'Katılma şartı:';

  @override
  String get advancedSettings => 'Gelişmiş ayarlar';

  @override
  String get safeTournamentName => 'Turnuva için oldukça güvenli bir isim seçin.';

  @override
  String get inappropriateNameWarning =>
      'Herhangi bir uygunsuz isim, hesabınızın yasaklanmasına yol açabilir.';

  @override
  String get emptyTournamentName =>
      'Kutuyu boş bırakarak turnuvaya rastgele bir Büyükusta\'nın ismini verebilirsiniz.';

  @override
  String get makePrivateTournament =>
      'Turnuvayı özel olarak ayarlayın ve şifre koyarak erişimi kısıtlayın';

  @override
  String get join => 'Katıl';

  @override
  String get withdraw => 'Çekil';

  @override
  String get points => 'Puanlar';

  @override
  String get wins => 'Galibiyetler';

  @override
  String get losses => 'Mağlubiyetler';

  @override
  String get startingIn => 'Başlamasına';

  @override
  String standByX(String param) {
    return 'Hazır ol $param, oyuncular eşleştiriliyor!';
  }

  @override
  String get pause => 'Duraklat';

  @override
  String get resume => 'Devam et';

  @override
  String get youArePlaying => 'Şu an oyundasınız!';

  @override
  String get winRate => 'Kazanma oranı';

  @override
  String get performance => 'Performans';

  @override
  String get tournamentComplete => 'Turnuva sona erdi';

  @override
  String get movesPlayed => 'Toplam hamle sayısı';

  @override
  String get whiteWins => 'Beyaz zaferleri';

  @override
  String get blackWins => 'Siyah zaferleri';

  @override
  String get drawRate => 'Berabere oranı';

  @override
  String get draws => 'Beraberlikler';

  @override
  String get averageOpponent => 'Ortalama rakip';

  @override
  String get boardEditor => 'Tahta yapıcı';

  @override
  String get setTheBoard => 'Tahtayı ayarla';

  @override
  String get popularOpenings => 'Popüler açılışlar';

  @override
  String get endgamePositions => 'Oyunsonu pozisyonları';

  @override
  String chess960StartPosition(String param) {
    return 'Chess960 başlangıç pozisyonu: $param';
  }

  @override
  String get startPosition => 'Başlangıç konumu';

  @override
  String get clearBoard => 'Tahtayı temizle';

  @override
  String get loadPosition => 'Pozisyon yükle';

  @override
  String get isPrivate => 'Özel';

  @override
  String reportXToModerators(String param) {
    return '$param \'i Moderatörlere bildir';
  }

  @override
  String profileCompletion(String param) {
    return 'Profil tamamlanma oranı: $param';
  }

  @override
  String xRating(String param) {
    return 'Derecelendirme: $param';
  }

  @override
  String get ifNoneLeaveEmpty => 'Eğer yoksa, boş bırakın';

  @override
  String get profile => 'Profil';

  @override
  String get editProfile => 'Profili düzenle';

  @override
  String get realName => 'Gerçek isim';

  @override
  String get setFlair => 'Rozetinizi seçin';

  @override
  String get flair => 'Rozet';

  @override
  String get youCanHideFlair => 'Ayarlardan oyuncu rozetlerini gizleyebilirsiniz.';

  @override
  String get biography => 'Biyografi';

  @override
  String get countryRegion => 'Ülke veya bölge';

  @override
  String get thankYou => 'Teşekkürler!';

  @override
  String get socialMediaLinks => 'Sosyal medya bağlantıları';

  @override
  String get oneUrlPerLine => 'Her satıra bir bağlantı yazın.';

  @override
  String get inlineNotation => 'Notasyonu aynı satırda göster';

  @override
  String get makeAStudy => 'Bunları kaydetmek ve paylaşmak için çalışma oluşturabilirsiniz.';

  @override
  String get clearSavedMoves => 'Hamleleri sil';

  @override
  String get previouslyOnLichessTV => 'Lichess TV\'de bunlar da vardı;';

  @override
  String get onlinePlayers => 'Çevrimiçi oyuncular';

  @override
  String get activePlayers => 'Aktif oyuncular';

  @override
  String get bewareTheGameIsRatedButHasNoClock => 'Dikkat, oyun puanlı ama suresizdir.';

  @override
  String get success => 'Başarılı';

  @override
  String get automaticallyProceedToNextGameAfterMoving =>
      'Hamle yaptıktan sonra otomatik olarak diğer oyuna geç';

  @override
  String get autoSwitch => 'Otomatik Seç';

  @override
  String get puzzles => 'Bulmacalar';

  @override
  String get onlineBots => 'Çevrimiçi botlar';

  @override
  String get name => 'İsim';

  @override
  String get description => 'Açıklama';

  @override
  String get descPrivate => 'Üyelere özel açıklama';

  @override
  String get descPrivateHelp =>
      'Sadece takım üyelerinin görebileceği metindir. Kullanılması halinde, takım üyeleri genel açıklama yerine bunu görür.';

  @override
  String get no => 'Hayır';

  @override
  String get yes => 'Evet';

  @override
  String get website => 'Web sitesi';

  @override
  String get mobile => 'Mobil';

  @override
  String get help => 'Yardım:';

  @override
  String get createANewTopic => 'Yeni bir bildiri oluştur.';

  @override
  String get topics => 'Konular';

  @override
  String get posts => 'Gönderiler';

  @override
  String get lastPost => 'Son gönderi';

  @override
  String get views => 'Görüntülenme sayısı';

  @override
  String get replies => 'Cevaplar';

  @override
  String get replyToThisTopic => 'Bu konu hakkında cevap yaz';

  @override
  String get reply => 'Cevap yaz';

  @override
  String get message => 'Mesaj';

  @override
  String get createTheTopic => 'Bildiri oluştur';

  @override
  String get reportAUser => 'Kullanıcı ihbar et';

  @override
  String get user => 'Kullanıcı';

  @override
  String get reason => 'Sebep';

  @override
  String get whatIsIheMatter => 'Problem nedir?';

  @override
  String get cheat => 'Hile';

  @override
  String get troll => 'Trol';

  @override
  String get other => 'Diğer';

  @override
  String get reportCheatBoostHelp =>
      'Oyunun (oyunların) bağlantısını yapıştırın ve kullanıcının hangi davranışı yanlış açıklayın. Sadece \"bu hile\" demeyin, bize bu sonuca nasıl vardığınızı söyleyin.';

  @override
  String get reportUsernameHelp =>
      'Bu kullanıcı adı hakkında neyin saldırganca olduğunu açıklayın. Sadece \"bu saldırganca/uygunsuz\" demeyin, bu sonuca nasıl vardığınızı söyleyin bize, özellikle de hakaret gizlenmiş, ingilizce olmayan, argo, veya tarihsel/kültürel referansalar varsa.';

  @override
  String get reportProcessedFasterInEnglish =>
      'Eğer İngilizce yazarsanız raporunuz daha hızlı işleme alınır.';

  @override
  String get error_provideOneCheatedGameLink =>
      'Lütfen hileli gördüğünüz en az 1 adet oyun linki verin.';

  @override
  String by(String param) {
    return '$param oluşturdu';
  }

  @override
  String importedByX(String param) {
    return '$param tarafından yüklendi';
  }

  @override
  String get thisTopicIsNowClosed => 'Bu konu kapanmıştır.';

  @override
  String get blog => 'Blog';

  @override
  String get notes => 'Notlar';

  @override
  String get typePrivateNotesHere => 'Özel notlarınızı buraya yazın';

  @override
  String get writeAPrivateNoteAboutThisUser => 'Bu kullanıcı hakkında özel bir not oluştur';

  @override
  String get noNoteYet => 'Henüz bir not yok';

  @override
  String get invalidUsernameOrPassword => 'Hatalı kullanıcı adı ya da şifre';

  @override
  String get incorrectPassword => 'Şifre yanlış';

  @override
  String get invalidAuthenticationCode => 'Geçersiz kimlik doğrulama kodu';

  @override
  String get emailMeALink => 'E-Posta ile giriş linki yolla';

  @override
  String get currentPassword => 'Mevcut şifre';

  @override
  String get newPassword => 'Yeni şifre';

  @override
  String get newPasswordAgain => 'Yeni şifre (tekrar)';

  @override
  String get newPasswordsDontMatch => 'Yeni şifreler eşleşmiyor';

  @override
  String get newPasswordStrength => 'Şifre gücü';

  @override
  String get clockInitialTime => 'Maç başlangıç süresi';

  @override
  String get clockIncrement => 'Hamle başına süre artışı';

  @override
  String get privacy => 'Gizlilik';

  @override
  String get privacyPolicy => 'Gizlilik politikası';

  @override
  String get letOtherPlayersFollowYou => 'Diğer oyuncular seni takip etsin mi?';

  @override
  String get letOtherPlayersChallengeYou => 'Diğer oyuncular oyun teklif edebilsin';

  @override
  String get letOtherPlayersInviteYouToStudy =>
      'Diğer oyuncular sizi bir çalışmaya davet edebilsin';

  @override
  String get sound => 'Ses';

  @override
  String get none => 'Hiçbiri';

  @override
  String get fast => 'Hızlı';

  @override
  String get normal => 'Normal';

  @override
  String get slow => 'Yavaş';

  @override
  String get insideTheBoard => 'Karelerin üzerinde';

  @override
  String get outsideTheBoard => 'Karelerin dışında';

  @override
  String get allSquaresOfTheBoard => 'Tahtadaki tüm karelerde';

  @override
  String get onSlowGames => 'Yavaş oyunlarda';

  @override
  String get always => 'Her zaman';

  @override
  String get never => 'Asla';

  @override
  String xCompetesInY(String param1, String param2) {
    return '$param1, $param2\'ya katıldı';
  }

  @override
  String get victory => 'Zafer';

  @override
  String get defeat => 'Yenilgi';

  @override
  String victoryVsYInZ(String param1, String param2, String param3) {
    return '$param2 adlı oyuncuya karşı $param3 maçında $param1';
  }

  @override
  String defeatVsYInZ(String param1, String param2, String param3) {
    return '$param2 adlı oyuncuya karşı $param3 maçında $param1';
  }

  @override
  String drawVsYInZ(String param1, String param2, String param3) {
    return '$param2 adlı oyuncuya karşı $param3 maçında $param1';
  }

  @override
  String get timeline => 'Zaman tüneli';

  @override
  String get starting => 'Başlangıç:';

  @override
  String get allInformationIsPublicAndOptional => 'Tüm bilgiler herkese açık ve seçime bağlıdır.';

  @override
  String get biographyDescription =>
      'Kendinizden bahsedin, satrançta ne buluyorsunuz, favori açılışlarınız, oyunlarınız, hayranı olduğunuz satranç ustaları…';

  @override
  String get listBlockedPlayers => 'Engellenen oyuncular';

  @override
  String get human => 'İnsan';

  @override
  String get computer => 'Bilgisayar';

  @override
  String get side => 'Taraf';

  @override
  String get clock => 'Saat';

  @override
  String get opponent => 'Rakip';

  @override
  String get learnMenu => 'Öğren';

  @override
  String get studyMenu => 'Çalışmalar';

  @override
  String get practice => 'Egzersizler';

  @override
  String get community => 'Topluluk';

  @override
  String get tools => 'Araçlar';

  @override
  String get increment => 'Artış';

  @override
  String get error_unknown => 'Geçersiz değer';

  @override
  String get error_required => 'Bu alan gerekli';

  @override
  String get error_email => 'Bu e-posta adresi geçersiz';

  @override
  String get error_email_acceptable =>
      'Bu e-posta adresi kabul edilemez. Lütfen tekrar kontrol edin ve tekrar deneyin.';

  @override
  String get error_email_unique => 'E-posta adresi geçersiz veya önceden alınmış';

  @override
  String get error_email_different => 'Zaten bu e-postayı kullanıyorsun';

  @override
  String error_minLength(String param) {
    return 'Asgari uzunluk: $param';
  }

  @override
  String error_maxLength(String param) {
    return 'Azami uzunluk: $param';
  }

  @override
  String error_min(String param) {
    return '$param değerinden büyük veya eşit olmalıdır';
  }

  @override
  String error_max(String param) {
    return '$param değerinden küçük veya eşit olmalıdır';
  }

  @override
  String ifRatingIsPlusMinusX(String param) {
    return 'Eğer puanları ± $param ise';
  }

  @override
  String get ifRegistered => 'Hesabı olanlar';

  @override
  String get onlyExistingConversations => 'Sadece mevcut yazışmalar';

  @override
  String get onlyFriends => 'Sadece arkadaşlar';

  @override
  String get menu => 'Menü';

  @override
  String get castling => 'Rok Atma';

  @override
  String get whiteCastlingKingside => 'Beyaz O-O';

  @override
  String get blackCastlingKingside => 'Siyah O-O';

  @override
  String tpTimeSpentPlaying(String param) {
    return 'Toplam oynama süresi: $param';
  }

  @override
  String get watchGames => 'Oyunları izle';

  @override
  String tpTimeSpentOnTV(String param) {
    return 'TV\'de izlenme süresi: $param';
  }

  @override
  String get watch => 'İzle';

  @override
  String get videoLibrary => 'Video kütüphanesi';

  @override
  String get streamersMenu => 'Canlı Yayınlar';

  @override
  String get mobileApp => 'Mobil Uygulama';

  @override
  String get webmasters => 'Site Yöneticileri';

  @override
  String get about => 'Hakkında';

  @override
  String aboutX(String param) {
    return '$param hakkında';
  }

  @override
  String xIsAFreeYLibreOpenSourceChessServer(String param1, String param2) {
    return '$param1; tamamen ücretsiz ($param2), özgür, reklamsız, açık kaynak kodlu bir satranç sitesidir.';
  }

  @override
  String get really => 'ciddiyiz';

  @override
  String get contribute => 'Katkıda bulun';

  @override
  String get termsOfService => 'Hizmet koşulları';

  @override
  String get titleVerification => 'Ünvan doğrulaması';

  @override
  String get sourceCode => 'Kaynak Kodu';

  @override
  String get simultaneousExhibitions => 'Eş zamanlı gösteriler';

  @override
  String get host => 'Ev Sahibi';

  @override
  String hostColorX(String param) {
    return 'Ev sahibi rengi: $param';
  }

  @override
  String get yourPendingSimuls => 'Bekleyen simultane oyunlarınız';

  @override
  String get createdSimuls => 'Yeni oluşturulan eş zamanlı gösteriler';

  @override
  String get hostANewSimul => 'Eş zamanlı gösteri düzenle';

  @override
  String get signUpToHostOrJoinASimul =>
      'Bir simultane oyuna katılmak veya ev sahipliği yapmak için kayıt olun';

  @override
  String get noSimulFound => 'Eş zamanlı gösteri bulunamadı';

  @override
  String get noSimulExplanation => 'Eş zamanlı gösteri yok.';

  @override
  String get returnToSimulHomepage => 'Eş zamanlı gösteri sayfasına geri dön';

  @override
  String get aboutSimul =>
      'Eş zamanlı gösterilerde, bir oyuncu aynı anda birçok oyuncuya karşı mücadele verir.';

  @override
  String get aboutSimulImage =>
      'Fischer 50 rakibe karşı, 47 oyun kazandı, 2 beraberlik ve 1 yenilgi aldı.';

  @override
  String get aboutSimulRealLife =>
      'Bu kavram gerçek etkinliklerden alınmıştır. Gerçek hayatta, eş zamanlı gösterinin ev sahibi masadan masaya dolaşarak birer hamle yapar.';

  @override
  String get aboutSimulRules =>
      'Eş zamanlı gösteriye katılan her oyuncu, beyaz taşlarla oynayan ev sahibi ilk hamleyi yaptıktan sonra maça başlar. Bütün oyunlar bittiğinde eş zamanlı gösteri sona erer.';

  @override
  String get aboutSimulSettings =>
      'Eş zamanlı gösteriler daima puansızdır. Yeniden maç teklifi göndermek, hamleyi geri almak ve ek süre talep etmek devre dışıdır.';

  @override
  String get create => 'Oluştur';

  @override
  String get whenCreateSimul => 'Eş zamanlı gösterilerde, birkaç oyuncuyla aynı anda oynarsınız.';

  @override
  String get simulVariantsHint =>
      'Eğer birkaç varyant seçerseniz, her oyuncu istediği varyantı seçip oynar.';

  @override
  String get simulClockHint =>
      'Fischer Saati formatı. Ne kadar fazla oyuncu ile yüzleşirseniz, o kadar fazla zamana ihtiyaç duyabilirsiniz.';

  @override
  String get simulAddExtraTime =>
      'Eş zamanlı gösteride süreyi idare edebilmek için kendi saatinize fazladan zaman ekleyebilirsiniz.';

  @override
  String get simulHostExtraTime => 'Ev sahibinin fazladan süresi';

  @override
  String get simulAddExtraTimePerPlayer =>
      'Eş zamanlı gösteriye katılan her oyuncu için saatinize başlangıç süresi ekleyin.';

  @override
  String get simulHostExtraTimePerPlayer => 'Ev sahibi, katılan her oyuncu için ekstra süre alır';

  @override
  String get lichessTournaments => 'Lichess turnuvaları';

  @override
  String get tournamentFAQ => 'Arena turnuvaları SSS';

  @override
  String get timeBeforeTournamentStarts => 'Turnuvaya kalan süre';

  @override
  String get averageCentipawnLoss => 'Ortalama santipiyon kaybı';

  @override
  String get accuracy => 'Doğruluk';

  @override
  String get keyboardShortcuts => 'Klavye kısayolları';

  @override
  String get keyMoveBackwardOrForward => 'önceki/sonraki hamle';

  @override
  String get keyGoToStartOrEnd => 'başa/sona git';

  @override
  String get keyCycleSelectedVariation => 'Seçilen varyasyonu değiştir';

  @override
  String get keyShowOrHideComments => 'yorumları gizle/göster';

  @override
  String get keyEnterOrExitVariation => 'varyasyona gir/çık';

  @override
  String get keyRequestComputerAnalysis => 'Bilgisayar analizi talep et, Hatalarından ders al';

  @override
  String get keyNextLearnFromYourMistakes => 'Sonraki (Hatalarından ders al)';

  @override
  String get keyNextBlunder => 'Sonraki vahim hata';

  @override
  String get keyNextMistake => 'Sonraki hata';

  @override
  String get keyNextInaccuracy => 'Sonraki kusurlu hamle';

  @override
  String get keyPreviousBranch => 'Önceki dal';

  @override
  String get keyNextBranch => 'Sıradaki dal';

  @override
  String get toggleVariationArrows => 'Varyasyon oklarını aç/kapat';

  @override
  String get cyclePreviousOrNextVariation => 'Önceki/sonraki varyasyona geç';

  @override
  String get toggleGlyphAnnotations => 'Glif dipnotlarını aç/kapat';

  @override
  String get togglePositionAnnotations => 'Konum açıklamalarını değiştir';

  @override
  String get variationArrowsInfo =>
      'Varyasyon okları, hamle listesini kullanmadan gezinmenizi sağlar.';

  @override
  String get playSelectedMove => 'seçili hamleyi oyna';

  @override
  String get newTournament => 'Yeni turnuva';

  @override
  String get tournamentHomeTitle =>
      'Çeşitli zaman kontrolleri ve varyantları içeren satranç turnuvası';

  @override
  String get tournamentHomeDescription =>
      'Hızlı tempolu satranç turnuvalarında oynayın! Önceden planlanmış turnuvalara katılın, ya da kendi turnuvanızı oluşturun. Sınırsız satranç eğlenceniz için Kurşun, Yıldırım, Klasik, Satranç960, Tepenin Şahı, Üçşah ve daha fazla seçenek mevcuttur.';

  @override
  String get tournamentNotFound => 'Turnuva bulunamadı.';

  @override
  String get tournamentDoesNotExist => 'Böyle bir turnuva yok.';

  @override
  String get tournamentMayHaveBeenCanceled =>
      'Eğer bütün oyuncular turnuva başlamadan ayrıldıysa, iptal edilmiş olabilir.';

  @override
  String get returnToTournamentsHomepage => 'Turnuva sayfasına geri dön.';

  @override
  String weeklyPerfTypeRatingDistribution(String param) {
    return 'Haftalık $param puan dağılımı';
  }

  @override
  String yourPerfTypeRatingIsRating(String param1, String param2) {
    return '$param1 puanınız $param2.';
  }

  @override
  String youAreBetterThanPercentOfPerfTypePlayers(String param1, String param2) {
    return '$param2 kategorisindeki oyuncuların $param1 kadarından daha iyisiniz.';
  }

  @override
  String userIsBetterThanPercentOfPerfTypePlayers(String param1, String param2, String param3) {
    return '$param1 $param3 oyuncularının $param2 kadarından daha iyi.';
  }

  @override
  String betterThanPercentPlayers(String param1, String param2) {
    return '$param2 oyuncularının $param1 kadarından daha iyi';
  }

  @override
  String youDoNotHaveAnEstablishedPerfTypeRating(String param) {
    return 'Sabit bir $param puanınız yok.';
  }

  @override
  String get yourRating => 'Sizin puanınız';

  @override
  String get cumulative => 'Kümülatif';

  @override
  String get glicko2Rating => 'Glicko-2 puanı';

  @override
  String get checkYourEmail => 'E-postanızı kontrol edin';

  @override
  String get weHaveSentYouAnEmailClickTheLink =>
      'Size e-posta yolladık. Hesabınızı aktifleştirmek için e-postanızdaki linke tıklayın.';

  @override
  String get ifYouDoNotSeeTheEmailCheckOtherPlaces =>
      'Eğer e-postayı görmüyorsanız, spam, sosyal veya diğer klasörlere göz atmayı deneyin.';

  @override
  String get ifYouDoNotGetTheEmail => 'Eğer 5 dakika içerisinde mail size ulaşmazsa:';

  @override
  String get checkAllEmailFolders => 'Tüm çöp, spam ve diğer klasörleri kontrol edin';

  @override
  String verifyYourAddress(String param) {
    return 'E-posta adresiniz $param olduğunu doğrulayın';
  }

  @override
  String weHaveSentYouAnEmailTo(String param) {
    return '$param adresine e-posta yolladık. Şifrenizi tekrar ayarlamak için e-postadaki linke tıklayın.';
  }

  @override
  String byRegisteringYouAgreeToBeBoundByOur(String param) {
    return 'Kaydolarak, $param \'ı kabul etmiş sayılırsınız.';
  }

  @override
  String readAboutOur(String param) {
    return '$param hakkında bilgi edinin.';
  }

  @override
  String get networkLagBetweenYouAndLichess => 'Siz ve lichess.org arasındaki gecikme (ping)';

  @override
  String get timeToProcessAMoveOnLichessServer => 'lichess.org üzerindeki hamle süreniz (ms)';

  @override
  String get downloadAnnotated => 'Açıklamalarıyla beraber indirin';

  @override
  String get downloadRaw => 'Açıklamasız indirin.';

  @override
  String get downloadImported => 'İçeri aktarılmış oyunu indir';

  @override
  String get downloadAllGames => 'Bütün oyunları indir';

  @override
  String get crosstable => 'Çapraz Tablo';

  @override
  String get youCanAlsoScrollOverTheBoardToMoveInTheGame =>
      'Ayrıca fare tekerini kullanarak da hamle yapabilirsiniz.';

  @override
  String get scrollOverComputerVariationsToPreviewThem =>
      'Fareyi bilgisayar varyantlarının üzerine getirerek pozisyonu görüntüleyin.';

  @override
  String get analysisShapesHowTo =>
      'Tahta üzerinde çember ya da ok çizmek için lütfen shift+click ya da right+click kullanın.';

  @override
  String get letOtherPlayersMessageYou => 'Diğer oyuncular size mesaj yollayabilsinler mi?';

  @override
  String get receiveForumNotifications => 'Forumda sizden bahsedildiğinde bildirim alın';

  @override
  String get shareYourInsightsData => 'Satranç oyun verilerinizi diğerleriyle paylaşın';

  @override
  String get withNobody => 'Hiçkimse ile';

  @override
  String get withFriends => 'Yalnızca arkadaşlarımla';

  @override
  String get withEverybody => 'Herkes ile';

  @override
  String get kidMode => 'Çocuk modu';

  @override
  String get kidModeIsEnabled => 'Çocuk modu etkin.';

  @override
  String get kidModeExplanation =>
      'Bu mod çocuğunuzun güvenliği ile ilgilidir. Tüm site bağlantıları devre dışı bırakılır. Eğer çocuklarınızı veya okul öğrencilerinizi diğer internet kullanıcılarına karşı korumak istiyorsanız, bu modu etkinleştirin.';

  @override
  String inKidModeTheLichessLogoGetsIconX(String param) {
    return 'Çocuk modunda, lichess.org logosu yerine $param belirir, bilin ki çocuğunuz güvendedir :)';
  }

  @override
  String get askYourChessTeacherAboutLiftingKidMode =>
      'Hesabınız kısıtlandı. Çocuk modunu kaldırmak için satranç öğretmeninize danışın.';

  @override
  String get enableKidMode => 'Çocuk modunu aktifleştir';

  @override
  String get disableKidMode => 'Çocuk modunu devre dışı bırak';

  @override
  String get security => 'Güvenlik';

  @override
  String get sessions => 'Oturumlar';

  @override
  String get revokeAllSessions => 'tüm oturumları kaldır';

  @override
  String get playChessEverywhere => 'Her yerde satranç oyna';

  @override
  String get everybodyGetsAllFeaturesForFree => 'Bütün özellikler ücretsizdir';

  @override
  String get viewTheSolution => 'Çözümü göster';

  @override
  String get noChallenges => 'Meydan okuma yok.';

  @override
  String xHostsY(String param1, String param2) {
    return '$param1 ev sahipliği yaptı: $param2';
  }

  @override
  String xJoinsY(String param1, String param2) {
    return '$param1 katıldı: $param2';
  }

  @override
  String xLikesY(String param1, String param2) {
    return '$param1 beğendi: $param2';
  }

  @override
  String get quickPairing => 'Hızlı eşleşme';

  @override
  String get lobby => 'Lobi';

  @override
  String get anonymous => 'Anonim';

  @override
  String yourScore(String param) {
    return 'Puan durumu: $param';
  }

  @override
  String get language => 'Dil';

  @override
  String get allLanguages => 'Tüm diller';

  @override
  String get background => 'Arkaplan';

  @override
  String get light => 'Açık';

  @override
  String get dark => 'Koyu';

  @override
  String get transparent => 'Şeffaf';

  @override
  String get deviceTheme => 'Cihaz teması';

  @override
  String get backgroundImageUrl => 'Arka plan resim linki:';

  @override
  String get board => 'Tahta';

  @override
  String get size => 'Boyut';

  @override
  String get opacity => 'Opaklık';

  @override
  String get brightness => 'Parlaklık';

  @override
  String get hue => 'Ton';

  @override
  String get boardReset => 'Renkleri varsayılana döndür';

  @override
  String get pieceSet => 'Taş seti';

  @override
  String get embedInYourWebsite => 'İnternet sitenizde gömülü olarak paylaşın';

  @override
  String get usernameAlreadyUsed =>
      'Bu kullanıcı adı zaten kullanılıyor, lütfen başka bir kullanıcı adı deneyin.';

  @override
  String get usernamePrefixInvalid => 'Kullanıcı adınız bir harfle başlamak zorundadır.';

  @override
  String get usernameSuffixInvalid => 'Kullanıcı adınız bir harf veya sayı ile bitmelidir.';

  @override
  String get usernameCharsInvalid =>
      'Kullanıcı adı yalnızca harf, sayı, alt çizgi ve çizgi içerebilir.';

  @override
  String get usernameUnacceptable => 'Bu kullanıcı adı uygun değil.';

  @override
  String get playChessInStyle => 'Satrancı tarz ile oynayın';

  @override
  String get chessBasics => 'Satrancın temel prensipleri';

  @override
  String get coaches => 'Eğitmenler';

  @override
  String get invalidPgn => 'Geçersiz PGN';

  @override
  String get invalidFen => 'Geçersiz FEN';

  @override
  String get custom => 'Özel';

  @override
  String get notifications => 'Bildirimler';

  @override
  String notificationsX(String param1) {
    return 'Bildirimler: $param1';
  }

  @override
  String perfRatingX(String param) {
    return 'Puan: $param';
  }

  @override
  String get practiceWithComputer => 'Bilgisayar ile pratik yapın';

  @override
  String anotherWasX(String param) {
    return '$param ise bir diğer seçenek';
  }

  @override
  String bestWasX(String param) {
    return 'En iyisi $param idi';
  }

  @override
  String get youBrowsedAway => 'Çok uzaklara gittiniz';

  @override
  String get resumePractice => 'Pratik yapmaya devam edin.';

  @override
  String get drawByFiftyMoves => 'Oyun, elli hamle kuralı gereğince beraberlikle sonuçlandı.';

  @override
  String get theGameIsADraw => 'Bu maç berabere.';

  @override
  String get computerThinking => 'Bilgisayar düşünüyor...';

  @override
  String get seeBestMove => 'En iyi hamleyi gör';

  @override
  String get hideBestMove => 'En iyi hamleyi gizle';

  @override
  String get getAHint => 'İpucu';

  @override
  String get evaluatingYourMove => 'Hamleniz değerlendiriliyor...';

  @override
  String get whiteWinsGame => 'Beyaz kazandı';

  @override
  String get blackWinsGame => 'Siyah kazandı';

  @override
  String get learnFromYourMistakes => 'Hatalarından ders al';

  @override
  String get learnFromThisMistake => 'Bu hatadan ders çıkart';

  @override
  String get skipThisMove => 'Bu hamleyi geç';

  @override
  String get next => 'Sonraki';

  @override
  String xWasPlayed(String param) {
    return '$param oynandı';
  }

  @override
  String get findBetterMoveForWhite => 'Beyaz için en iyi hamleyi bulun';

  @override
  String get findBetterMoveForBlack => 'Siyah için en iyi hamleyi bulun';

  @override
  String get resumeLearning => 'Kaldığınız yerden devam edin';

  @override
  String get youCanDoBetter => 'Daha iyisini yapabilirsin';

  @override
  String get tryAnotherMoveForWhite => 'Beyaz için başka bir hamle dene';

  @override
  String get tryAnotherMoveForBlack => 'Siyah için başka bir hamle dene';

  @override
  String get solution => 'Çözüm';

  @override
  String get waitingForAnalysis => 'Analiz bekleniyor';

  @override
  String get noMistakesFoundForWhite => 'Beyazın bir hatası bulunamadı';

  @override
  String get noMistakesFoundForBlack => 'Siyahın bir hatası bulunamadı';

  @override
  String get doneReviewingWhiteMistakes => 'Beyazın hataları analiz edildi';

  @override
  String get doneReviewingBlackMistakes => 'Siyahın hataları analiz edildi';

  @override
  String get doItAgain => 'Tekrarlayın';

  @override
  String get reviewWhiteMistakes => 'Beyazın hatalarını gözden geçirin';

  @override
  String get reviewBlackMistakes => 'Siyahın hatalarını gözden geçirin';

  @override
  String get advantage => 'Avantaj';

  @override
  String get opening => 'Açılış';

  @override
  String get middlegame => 'Oyunortası';

  @override
  String get endgame => 'Oyunsonu';

  @override
  String get conditionalPremoves => 'Şartlı ön hamle';

  @override
  String get addCurrentVariation => 'Mevcut varyantı ekle';

  @override
  String get playVariationToCreateConditionalPremoves =>
      'Koşullu ön hamleler yapmak için bir varyasyon oynayın';

  @override
  String get noConditionalPremoves => 'Koşullu ön hamle yok';

  @override
  String playX(String param) {
    return '$param oyna';
  }

  @override
  String get showUnreadLichessMessage => 'Lichess size bir özel mesaj gönderdi.';

  @override
  String get clickHereToReadIt => 'Okumak için buraya tıklayın';

  @override
  String get sorry => 'Üzgünüz :(';

  @override
  String get weHadToTimeYouOutForAWhile =>
      'Sizi bir süreliğine oyunlardan men etmek zorunda kaldık.';

  @override
  String get why => 'Neden?';

  @override
  String get pleasantChessExperience => 'Herkese keyifli bir satranç deneyimi sunmayı amaçlıyoruz.';

  @override
  String get goodPractice =>
      'Bu nedenle, bütün oyuncuların doğru davranışlar sergilemesine özen gösteriyoruz.';

  @override
  String get potentialProblem =>
      'Potansiyel bir sorun tespit edildiğinde bu mesajı görüntülüyoruz.';

  @override
  String get howToAvoidThis => 'Tekrar olmaması için ne yapmalıyım?';

  @override
  String get playEveryGame => 'Başladığınız her oyunu sonuna kadar oynayın.';

  @override
  String get tryToWin =>
      'Oynadığınız her oyunu kazanmaya çalışın (ya da en azından berabere kalmayı deneyin).';

  @override
  String get resignLostGames => 'Kaybettiğiniz oyunlardan çekilin (sürenin dolmasını beklemeyin).';

  @override
  String get temporaryInconvenience => 'Verdiğimiz geçici rahatsızlıktan dolayı özür dileriz,';

  @override
  String get wishYouGreatGames => 've lichess.org\'da harika oyunlar dileriz.';

  @override
  String get thankYouForReading => 'Okuduğunuz için teşekkür ederiz!';

  @override
  String get lifetimeScore => 'Toplam skor';

  @override
  String get currentMatchScore => 'Mevcut maç skoru';

  @override
  String get agreementAssistance =>
      'Maçlar esnasında hiçbir zaman dışarıdan yardım almayacağım (bilgisayardan, kitaptan, veri tabanından veya başka bir insandan).';

  @override
  String get agreementNice => 'Diğer oyunculara karşı her zaman iyi bir tutum içinde olacağım.';

  @override
  String agreementMultipleAccounts(String param) {
    return 'Birden fazla hesap oluşturmayacağımı onaylıyorum ($param\'da sıralanmış durumlar hariç).';
  }

  @override
  String get agreementPolicy => 'Lichess kurallarını takip edeceğim.';

  @override
  String get searchOrStartNewDiscussion => 'Tartışma ara veya yenisini başlat';

  @override
  String get edit => 'Düzenle';

  @override
  String get bullet => 'Bullet';

  @override
  String get blitz => 'Yıldırım';

  @override
  String get rapid => 'Hızlı';

  @override
  String get classical => 'Klasik';

  @override
  String get ultraBulletDesc => 'Aşırı hızlı oyunlar: 30 saniyeden daha az';

  @override
  String get bulletDesc => 'Çok yüksek tempolu oyunlar: 3 dakikadan daha az';

  @override
  String get blitzDesc => 'Yüksek tempolu oyunlar: 3 ile 8 dakika arası';

  @override
  String get rapidDesc => 'Hızlı oyunlar: 8 ile 25 dakika arası';

  @override
  String get classicalDesc => 'Klasik oyunlar: 25 dakika ve daha fazlası';

  @override
  String get correspondenceDesc => 'Yazışmalı oyunlar: Hamle başına bir veya birkaç gün';

  @override
  String get puzzleDesc => 'Satranç taktik egzersizi';

  @override
  String get important => 'Önemli';

  @override
  String yourQuestionMayHaveBeenAnswered(String param1) {
    return 'Sorunuzun yanıtı $param1 cevaplanmış olabilir.';
  }

  @override
  String get inTheFAQ => 'Sıkça Sorulan Sorularda';

  @override
  String toReportSomeoneForCheatingOrBadBehavior(String param1) {
    return 'Bir kullanıcıyı hileden ya da kötü davranışından dolayı raporlamak istiyorsanız $param1';
  }

  @override
  String get useTheReportForm => 'rapor formunu kullanın';

  @override
  String toRequestSupport(String param1) {
    return 'Destek almak istiyorsanız, $param1';
  }

  @override
  String get tryTheContactPage => 'iletişim sayfasını kullanmayı deneyebilirsiniz';

  @override
  String makeSureToRead(String param1) {
    return 'Okuduğunuzdan emin olun: $param1';
  }

  @override
  String get theForumEtiquette => 'forum görgü kuralları';

  @override
  String get thisTopicIsArchived => 'Bu konu arşivlenmiş ve yeni yanıtlara kapatılmıştır.';

  @override
  String joinTheTeamXToPost(String param1) {
    return 'Bu forumda paylaşım yapmak için $param1 adlı takıma katılın';
  }

  @override
  String teamNamedX(String param1) {
    return '$param1';
  }

  @override
  String get youCannotPostYetPlaySomeGames =>
      'Henüz forumda konu açamazsınız. Biraz daha maç yaptıktan sonra tekrar deneyin.';

  @override
  String get subscribe => 'Abone ol';

  @override
  String get unsubscribe => 'Abonelikten çık';

  @override
  String mentionedYouInX(String param1) {
    return '\"$param1\" adlı gönderide sizden bahsetti.';
  }

  @override
  String xMentionedYouInY(String param1, String param2) {
    return '$param1 sizden bahsetti: \"$param2\".';
  }

  @override
  String invitedYouToX(String param1) {
    return 'sizi \"$param1\" adlı çalışmaya davet etti.';
  }

  @override
  String xInvitedYouToY(String param1, String param2) {
    return '$param1 sizi \"$param2\" adlı çalışmaya davet ediyor.';
  }

  @override
  String get youAreNowPartOfTeam => 'Artık ekibin bir üyesisiniz.';

  @override
  String youHaveJoinedTeamX(String param1) {
    return '\"$param1\" adlı takıma katıldın.';
  }

  @override
  String get someoneYouReportedWasBanned => 'İhbar ettiğiniz biri engellendi';

  @override
  String get congratsYouWon => 'Tebrikler, kazandınız!';

  @override
  String gameVsX(String param1) {
    return '$param1 ile oyun';
  }

  @override
  String resVsX(String param1, String param2) {
    return '$param1 ile $param2 karşı karşıya';
  }

  @override
  String get lostAgainstTOSViolator => 'Lichess Kulanım Şartları\'nı ihlal eden birine kaybettiniz';

  @override
  String refundXpointsTimeControlY(String param1, String param2) {
    return '$param1 $param2 puanı iade edildi.';
  }

  @override
  String get timeAlmostUp => 'Zaman dolmak üzere!';

  @override
  String get clickToRevealEmailAddress => '[E-posta adresini göstermek için tıklayın]';

  @override
  String get download => 'İndir';

  @override
  String get coachManager => 'Eğitmen ayarları';

  @override
  String get streamerManager => 'Yayıncı ayarları';

  @override
  String get cancelTournament => 'Turnuvayı iptal et';

  @override
  String get tournDescription => 'Turnuva açıklaması';

  @override
  String get tournDescriptionHelp =>
      'Katılımcılara söylemek istediğiniz özel bir şey var mı? Kısa tutmaya çalışın. İşaretleme bağlantılarını kullanabilirsiniz: [name](https://url)';

  @override
  String get ratedFormHelp => 'Oyunlar derecelidir ve oyuncu puanlarını etkilemektedir';

  @override
  String get onlyMembersOfTeam => 'Sadece takım üyeleri';

  @override
  String get noRestriction => 'Kısıtlama yok';

  @override
  String get minimumRatedGames => 'En düşük puanlı oyunlar';

  @override
  String get minimumRating => 'En düşük puan';

  @override
  String get maximumWeeklyRating => 'Haftalık en yüksek puan';

  @override
  String positionInputHelp(String param) {
    return 'Her oyunda belirli bir pozisyondan başlamak için geçerli FEN yazınız.\nSadece standart oyunlarda çalışır, varyantlarda çalışmaz.\nFEN pozisyonu oluşturmak için $param kullanıp buraya yazabilirsiniz.\nBaşlangıç pozisyonundan oynamak için boş bırakınız.';
  }

  @override
  String get cancelSimul => 'Eş zamanlı gösteriyi iptal et';

  @override
  String get simulHostcolor => 'Ev sahibinin rengi';

  @override
  String get estimatedStart => 'Tahminî başlangıç süresi';

  @override
  String simulFeatured(String param) {
    return '$param adresinden yayımla';
  }

  @override
  String simulFeaturedHelp(String param) {
    return 'Eş zamanlı gösteriyi $param adresinden herkese görünür kılar. Özel gösteriler için devre dışı bırakın.';
  }

  @override
  String get simulDescription => 'Eş zamanlı gösterinin açıklaması';

  @override
  String get simulDescriptionHelp => 'Katılımcılara söylemek istediğiniz bir şey var mı?';

  @override
  String markdownAvailable(String param) {
    return '$param kullanarak metni daha ayrıntılı bir şekilde biçimlendirebilirsiniz.';
  }

  @override
  String get embedsAvailable =>
      'Bir maç veya çalışma bölümü eklemek için bağlantıyı buraya yapıştırın.';

  @override
  String get inYourLocalTimezone => 'Yerel zaman diliminizde';

  @override
  String get tournChat => 'Turnuva sohbeti';

  @override
  String get noChat => 'Sohbet yasak';

  @override
  String get onlyTeamLeaders => 'Yalnızca takım liderleri';

  @override
  String get onlyTeamMembers => 'Yalnızca takım üyeleri';

  @override
  String get navigateMoveTree => 'Hamleler arasında gezin';

  @override
  String get mouseTricks => 'Fare ile yapılan numaralar';

  @override
  String get toggleLocalAnalysis => 'Yerel bilgisayar analizini aç/kapat';

  @override
  String get toggleAllAnalysis => 'Genel bilgisayar analizini aç/kapat';

  @override
  String get playComputerMove => 'En iyi bilgisayar hamlesini oyna';

  @override
  String get analysisOptions => 'Analiz seçenekleri';

  @override
  String get focusChat => 'Sohbete odaklan';

  @override
  String get showHelpDialog => 'Bu yardım iletisini göster';

  @override
  String get reopenYourAccount => 'Hesabı aktifleştir';

  @override
  String get reopenYourAccountDescription =>
      'Hesabınızı kapattıktan sonra fikrinizi değiştirdiyseniz hesabınızı tekrar açmak için bir şansınız var.';

  @override
  String get emailAssociatedToaccount => 'Hesabın bağlı olduğu e-posta adresi';

  @override
  String get sentEmailWithLink => 'Size içinde ilgili bağlantı bulunan bir e-posta gönderdik.';

  @override
  String get tournamentEntryCode => 'Turnuva giriş kodu';

  @override
  String get hangOn => 'Dur bir dakika!';

  @override
  String gameInProgress(String param) {
    return 'Şu anda $param ile olan maçınız devam ediyor.';
  }

  @override
  String get abortTheGame => 'Maçı iptal et';

  @override
  String get resignTheGame => 'Maçı terk et';

  @override
  String get youCantStartNewGame => 'Mevcut oyun bitene kadar yeni bir oyuna başlayamazsın.';

  @override
  String get since => 'Seçili tarihten beri';

  @override
  String get until => 'Seçili tarihe kadar';

  @override
  String get lichessDbExplanation =>
      'Tüm Lichess oyuncularının puanlı oyunlarından alınan örnekler';

  @override
  String get switchSides => 'Renk değiştir';

  @override
  String get closingAccountWithdrawAppeal => 'Hesabınızı kapatırsanız başvurunuz geri çekilecektir';

  @override
  String get ourEventTips => 'Etkinlik düzenlemek için ipuçlarımız';

  @override
  String get instructions => 'Talimatlar';

  @override
  String get showMeEverything => 'Bana her şeyi göster';

  @override
  String get lichessPatronInfo =>
      'Lichess bir yardım kuruluşudur ve tamamen özgür/açık kaynak kodlu bir yazılımdır. Tüm işletme maliyetleri, geliştirmeler ve içerikler yalnızca kullanıcı bağışları ile finanse edilmektedir.';

  @override
  String get nothingToSeeHere => 'Şu anda görülebilecek bir şey yok.';

  @override
  String get stats => 'İstatistikler';

  @override
  String get accessibility => 'Erişilebilirlik';

  @override
  String get enableBlindMode => 'Kör modunu aktifleştir';

  @override
  String get disableBlindMode => 'Kör modunu devre dışı bırak';

  @override
  String opponentLeftCounter(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Rakibiniz oyundan ayrıldı. $count saniye sonra galibiyet talep edebilirsiniz.',
      one: 'Rakibiniz oyundan ayrıldı. $count saniye sonra galibiyet talep edebilirsiniz.',
    );
    return '$_temp0';
  }

  @override
  String mateInXHalfMoves(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count yarım hamlede mat',
      one: '$count yarım hamle sonra mat',
    );
    return '$_temp0';
  }

  @override
  String nbBlunders(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count vahim hata',
      one: '$count vahim hata',
    );
    return '$_temp0';
  }

  @override
  String numberBlunders(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Vahim hata',
      one: '$count Vahim hata',
    );
    return '$_temp0';
  }

  @override
  String nbMistakes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count hata',
      one: '$count hata',
    );
    return '$_temp0';
  }

  @override
  String numberMistakes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Hata',
      one: '$count Hata',
    );
    return '$_temp0';
  }

  @override
  String nbInaccuracies(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count kusurlu hamle',
      one: '$count kusurlu hamle',
    );
    return '$_temp0';
  }

  @override
  String numberInaccuracies(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Kusurlu hamle',
      one: '$count Kusurlu hamle',
    );
    return '$_temp0';
  }

  @override
  String nbPlayers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count çevrimiçi oyuncu',
      one: '$count çevrimiçi oyuncu',
    );
    return '$_temp0';
  }

  @override
  String nbGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count oynanan oyun',
      one: '$count oynanan oyun',
    );
    return '$_temp0';
  }

  @override
  String ratingXOverYGames(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$param2 oyun üzerinden $count puanı',
      one: '$param2 oyun üzerinden $count puanı',
    );
    return '$_temp0';
  }

  @override
  String nbBookmarks(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count işaretlenmiş oyun',
      one: '$count işaretlenmiş oyun',
    );
    return '$_temp0';
  }

  @override
  String nbDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count gün',
      one: '$count gün',
    );
    return '$_temp0';
  }

  @override
  String nbHours(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count saat',
      one: '$count saat',
    );
    return '$_temp0';
  }

  @override
  String nbMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count dakika',
      one: '$count dakika',
    );
    return '$_temp0';
  }

  @override
  String rankIsUpdatedEveryNbMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Sıralama her $count dakikada bir güncellenir',
      one: 'Sıralama her $count dakikada bir güncellenir',
    );
    return '$_temp0';
  }

  @override
  String nbPuzzles(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count bulmaca',
      one: '$count bulmaca',
    );
    return '$_temp0';
  }

  @override
  String nbGamesWithYou(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Sizinle oynadığı oyun sayısı: $count',
      one: 'Sizinle oynadığı oyun sayısı: $count',
    );
    return '$_temp0';
  }

  @override
  String nbRated(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count dereceli',
      one: '$count puanlı',
    );
    return '$_temp0';
  }

  @override
  String nbWins(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count galibiyet',
      one: '$count galibiyet',
    );
    return '$_temp0';
  }

  @override
  String nbLosses(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count mağlubiyet',
      one: '$count mağlubiyet',
    );
    return '$_temp0';
  }

  @override
  String nbDraws(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count beraberlik',
      one: '$count beraberlik',
    );
    return '$_temp0';
  }

  @override
  String nbPlaying(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count oynuyor',
      one: '$count oynanıyor',
    );
    return '$_temp0';
  }

  @override
  String giveNbSeconds(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count saniye ver',
      one: '$count saniye ver',
    );
    return '$_temp0';
  }

  @override
  String nbTournamentPoints(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Turnuva Puanı',
      one: '$count Turnuva Puanı',
    );
    return '$_temp0';
  }

  @override
  String nbStudies(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count çalışma',
      one: '$count çalışma',
    );
    return '$_temp0';
  }

  @override
  String nbSimuls(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count eş zamanlı oyun',
      one: '$count eş zamanlı oyun',
    );
    return '$_temp0';
  }

  @override
  String moreThanNbRatedGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '≥ $count dereceli maç',
      one: '≥ $count dereceli maç',
    );
    return '$_temp0';
  }

  @override
  String moreThanNbPerfRatedGames(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '≥ $count puanlı $param2 maçı',
      one: '≥ $count puanlı $param2 maçı',
    );
    return '$_temp0';
  }

  @override
  String needNbMorePerfGames(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count tane daha dereceli $param2 oynamanız gerekiyor',
      one: '$count tane daha dereceli $param2 oynamanız gerekiyor',
    );
    return '$_temp0';
  }

  @override
  String needNbMoreGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count tane daha dereceli oyun oynamanız gerekiyor',
      one: '$count tane daha dereceli oyun oynamanız gerekiyor',
    );
    return '$_temp0';
  }

  @override
  String nbImportedGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count yüklenen oyun',
      one: '$count yüklenen oyun',
    );
    return '$_temp0';
  }

  @override
  String nbFriendsOnline(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count arkadaş çevrim içi',
      one: '$count arkadaş çevrim içi',
    );
    return '$_temp0';
  }

  @override
  String nbFollowers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count takipçi',
      one: '$count takipçi',
    );
    return '$_temp0';
  }

  @override
  String nbFollowing(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count takip ettiklerim',
      one: '$count takip ettiklerim',
    );
    return '$_temp0';
  }

  @override
  String lessThanNbMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count dakikadan daha az',
      one: '$count dakikadan daha az',
    );
    return '$_temp0';
  }

  @override
  String nbGamesInPlay(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Şu anda $count oyun oynanıyor',
      one: 'Şu anda $count oyun oynanıyor',
    );
    return '$_temp0';
  }

  @override
  String maximumNbCharacters(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'En fazla: $count karakter.',
      one: 'En fazla: $count karakter.',
    );
    return '$_temp0';
  }

  @override
  String blocks(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count kişiyi engelledi',
      one: '$count kişiyi engelledi',
    );
    return '$_temp0';
  }

  @override
  String nbForumPosts(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Forum Mesajı',
      one: '$count Forum Mesajı',
    );
    return '$_temp0';
  }

  @override
  String nbPerfTypePlayersThisWeek(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Bu hafta $count $param2 oyuncusu.',
      one: 'Bu hafta bir $param2 oyuncusu.',
    );
    return '$_temp0';
  }

  @override
  String availableInNbLanguages(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count farklı dili destekler!',
      one: '$count farklı dili destekler!',
    );
    return '$_temp0';
  }

  @override
  String nbSecondsToPlayTheFirstMove(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'İlk hamle için son $count saniye',
      one: 'İlk hamle için son $count saniye',
    );
    return '$_temp0';
  }

  @override
  String nbSeconds(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count saniye',
      one: '$count saniye',
    );
    return '$_temp0';
  }

  @override
  String andSaveNbPremoveLines(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 've $count önceki varyantları kaydedin',
      one: 've $count önceki varyantları kaydedin',
    );
    return '$_temp0';
  }

  @override
  String get stormMoveToStart => 'Başlamak için hamle yap';

  @override
  String get stormYouPlayTheWhitePiecesInAllPuzzles => 'Tüm bulmacalarda beyaz taraf olacaksın';

  @override
  String get stormYouPlayTheBlackPiecesInAllPuzzles => 'Tüm bulmacalarda siyah taraf olacaksın';

  @override
  String get stormPuzzlesSolved => 'bulmaca çözüldü';

  @override
  String get stormNewDailyHighscore => 'Günün rekoru kırıldı!';

  @override
  String get stormNewWeeklyHighscore => 'Haftanın rekoru kırıldı!';

  @override
  String get stormNewMonthlyHighscore => 'Ayın rekoru kırıldı!';

  @override
  String get stormNewAllTimeHighscore => 'Tüm zamanların rekoru kırıldı!';

  @override
  String stormPreviousHighscoreWasX(String param) {
    return 'Eski rekor: $param';
  }

  @override
  String get stormPlayAgain => 'Tekrar oyna';

  @override
  String stormHighscoreX(String param) {
    return 'Rekor: $param';
  }

  @override
  String get stormScore => 'Günlük rekor';

  @override
  String get stormMoves => 'Hamle sayısı';

  @override
  String get stormAccuracy => 'Başarı oranı';

  @override
  String get stormCombo => 'Kombo';

  @override
  String get stormTime => 'Süre';

  @override
  String get stormTimePerMove => 'Hamle başı süre';

  @override
  String get stormHighestSolved => 'Azami zorluk';

  @override
  String get stormPuzzlesPlayed => 'Oynanan bulmacalar';

  @override
  String get stormNewRun => 'Yeni tur (kısayol: Boşluk tuşu)';

  @override
  String get stormEndRun => 'Turu bitir (kısayol: Enter)';

  @override
  String get stormHighscores => 'Rekorlar';

  @override
  String get stormViewBestRuns => 'En iyi denemeleri göster';

  @override
  String get stormBestRunOfDay => 'Tarih';

  @override
  String get stormRuns => 'Deneme sayısı';

  @override
  String get stormGetReady => 'Hazır ol!';

  @override
  String get stormWaitingForMorePlayers => 'Diğer oyuncuların katılması bekleniyor...';

  @override
  String get stormRaceComplete => 'Yarış sona erdi!';

  @override
  String get stormSpectating => 'İzleyici modu';

  @override
  String get stormJoinTheRace => 'Yarışa katıl!';

  @override
  String get stormStartTheRace => 'Yarışı başlat';

  @override
  String stormYourRankX(String param) {
    return 'Sıralamanız: $param';
  }

  @override
  String get stormWaitForRematch => 'Rövanş için bekle';

  @override
  String get stormNextRace => 'Sıradaki yarış';

  @override
  String get stormJoinRematch => 'Rövanşa katıl';

  @override
  String get stormWaitingToStart => 'Başlamak üzere';

  @override
  String get stormCreateNewGame => 'Yeni bir oyun oluştur';

  @override
  String get stormJoinPublicRace => 'Herkese açık yarışa katıl';

  @override
  String get stormRaceYourFriends => 'Arkadaşlarınla yarış';

  @override
  String get stormSkip => 'atla';

  @override
  String get stormSkipHelp => 'Her yarışta bir hamleyi atlayabilirsin:';

  @override
  String get stormSkipExplanation =>
      'Serini korumak için bu hamleyi atla! Her yarışta sadece bir atlama hakkın var.';

  @override
  String get stormFailedPuzzles => 'Yanlış çözülen bulmacalar';

  @override
  String get stormSlowPuzzles => 'Yavaş çözülen bulmacalar';

  @override
  String get stormSkippedPuzzle => 'Atlanan bulmaca';

  @override
  String get stormThisWeek => 'Bu hafta';

  @override
  String get stormThisMonth => 'Bu ay';

  @override
  String get stormAllTime => 'Rekor';

  @override
  String get stormClickToReload => 'Tekrar yüklemek için tıkla';

  @override
  String get stormThisRunHasExpired => 'Bu çalışmanın süresi doldu!';

  @override
  String get stormThisRunWasOpenedInAnotherTab => 'Bu çalışma başka sekmede açılmış!';

  @override
  String stormXRuns(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count tur',
      one: '1 tur',
    );
    return '$_temp0';
  }

  @override
  String stormPlayedNbRunsOfPuzzleStorm(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count kez $param2 oynadı',
      one: 'Bir kez $param2 oynadı',
    );
    return '$_temp0';
  }

  @override
  String get streamerLichessStreamers => 'Lichess yayıncıları';

  @override
  String get studyPrivate => 'Gizli';

  @override
  String get studyMyStudies => 'Çalışmalarım';

  @override
  String get studyStudiesIContributeTo => 'Katkıda bulunduğum çalışmalar';

  @override
  String get studyMyPublicStudies => 'Herkese açık çalışmalarım';

  @override
  String get studyMyPrivateStudies => 'Gizli çalışmalarım';

  @override
  String get studyMyFavoriteStudies => 'En sevdiğim çalışmalar';

  @override
  String get studyWhatAreStudies => 'Çalışmalar nedir?';

  @override
  String get studyAllStudies => 'Bütün çalışmalar';

  @override
  String studyStudiesCreatedByX(String param) {
    return 'Çalışmalar $param tarafından oluşturulmuştur';
  }

  @override
  String get studyNoneYet => 'Henüz yok.';

  @override
  String get studyHot => 'Popüler';

  @override
  String get studyDateAddedNewest => 'Eklenme tarihi (en yeni)';

  @override
  String get studyDateAddedOldest => 'Eklenme tarihi (en eski)';

  @override
  String get studyRecentlyUpdated => 'Yeni güncellenmiş';

  @override
  String get studyMostPopular => 'En popüler';

  @override
  String get studyAlphabetical => 'Alfabetik';

  @override
  String get studyAddNewChapter => 'Yeni bir bölüm ekle';

  @override
  String get studyAddMembers => 'Üye ekle';

  @override
  String get studyInviteToTheStudy => 'Bu çalışmaya davet edin';

  @override
  String get studyPleaseOnlyInvitePeopleYouKnow =>
      'Lütfen sadece tanıdığınız ve katkı sağlayacağını düşündüğünüz kişileri davet ediniz.';

  @override
  String get studySearchByUsername => 'Kullanıcı adına göre ara';

  @override
  String get studySpectator => 'İzleyici';

  @override
  String get studyContributor => 'Katılımcı';

  @override
  String get studyKick => 'Çıkar';

  @override
  String get studyLeaveTheStudy => 'Çalışmadan ayrıl';

  @override
  String get studyYouAreNowAContributor => 'Artık bir katılımcısınız';

  @override
  String get studyYouAreNowASpectator => 'Artık bir izleyicisiniz';

  @override
  String get studyPgnTags => 'PGN etiketleri';

  @override
  String get studyLike => 'Beğen';

  @override
  String get studyUnlike => 'Beğenmekten Vazgeç';

  @override
  String get studyNewTag => 'Yeni etiket';

  @override
  String get studyCommentThisPosition => 'Bu pozisyon için yorum yap';

  @override
  String get studyCommentThisMove => 'Bu hamle için yorum yap';

  @override
  String get studyAnnotateWithGlyphs => 'Glifler ile açıkla';

  @override
  String get studyTheChapterIsTooShortToBeAnalysed => 'Bu bölüm analiz için çok kısa.';

  @override
  String get studyOnlyContributorsCanRequestAnalysis =>
      'Sadece katılımcılar bilgisayar analizi isteyebilir.';

  @override
  String get studyGetAFullComputerAnalysis => 'Bu varyant için ayrıntılı bir sunucu analizi yapın.';

  @override
  String get studyMakeSureTheChapterIsComplete =>
      'Bu bölümü tamamladığınızdan emin olun. Sadece bir kez bilgisayar analizi talep edebilirsiniz.';

  @override
  String get studyAllSyncMembersRemainOnTheSamePosition =>
      'Senkronize edilen bütün üyeler aynı pozisyonda kalır';

  @override
  String get studyShareChanges => 'Değişiklikleri izleyiciler ile paylaşın ve sunucuya kaydedin';

  @override
  String get studyPlaying => 'Oynanıyor';

  @override
  String get studyShowResults => 'Sonuçlar';

  @override
  String get studyShowEvalBar => 'Değerlendirme çubuğu';

  @override
  String get studyNext => 'Sonraki';

  @override
  String get studyShareAndExport => 'Paylaş ve dışa aktar';

  @override
  String get studyCloneStudy => 'Klon';

  @override
  String get studyStudyPgn => 'Çalışma PGN\'si';

  @override
  String get studyChapterPgn => 'Bölüm PGN\'si';

  @override
  String get studyCopyChapterPgn => 'PGN \'yi kopyala';

  @override
  String get studyDownloadGame => 'Oyunu indir';

  @override
  String get studyStudyUrl => 'Çalışma Adresi';

  @override
  String get studyCurrentChapterUrl => 'Mevcut Bölümün Adresi';

  @override
  String get studyYouCanPasteThisInTheForumToEmbed =>
      'Forumda gömülü olarak paylaşmak için yukarıdaki bağlantıyı kullanabilirsiniz';

  @override
  String get studyStartAtInitialPosition => 'İlk pozisyondan başlasın';

  @override
  String studyStartAtX(String param) {
    return '$param pozisyonundan başlasın';
  }

  @override
  String get studyEmbedInYourWebsite =>
      'İnternet sitenizde ya da blogunuzda gömülü olarak paylaşın';

  @override
  String get studyReadMoreAboutEmbedding => 'Gömülü paylaşma hakkında';

  @override
  String get studyOnlyPublicStudiesCanBeEmbedded =>
      'Yalnızca herkese açık çalışmalar gömülü paylaşılabilir!';

  @override
  String get studyOpen => 'Aç';

  @override
  String studyXBroughtToYouByY(String param1, String param2) {
    return '$param2 sana $param1 getirdi';
  }

  @override
  String get studyStudyNotFound => 'Böyle bir çalışma bulunamadı';

  @override
  String get studyEditChapter => 'Bölümü düzenle';

  @override
  String get studyNewChapter => 'Yeni bölüm';

  @override
  String studyImportFromChapterX(String param) {
    return '$param çalışmasından içe aktar';
  }

  @override
  String get studyOrientation => 'Tahta yönü';

  @override
  String get studyAnalysisMode => 'Analiz modu';

  @override
  String get studyPinnedChapterComment => 'Bölüm üzerine yorumlar';

  @override
  String get studySaveChapter => 'Bölümü kaydet';

  @override
  String get studyClearAnnotations => 'Açıklamaları sil';

  @override
  String get studyClearVariations => 'Varyasyonları sil';

  @override
  String get studyDeleteChapter => 'Bölümü sil';

  @override
  String get studyDeleteThisChapter => 'Bu bölüm silinsin mi? Bunun geri dönüşü yok!';

  @override
  String get studyClearAllCommentsInThisChapter =>
      'Bu bölümdeki bütün yorumlar ve işaretler temizlensin mi?';

  @override
  String get studyRightUnderTheBoard => 'Tahtanın hemen altında görünsün';

  @override
  String get studyNoPinnedComment => 'Yok';

  @override
  String get studyNormalAnalysis => 'Normal analiz';

  @override
  String get studyHideNextMoves => 'Sonraki hamleleri gizle';

  @override
  String get studyInteractiveLesson => 'Etkileşimli ders';

  @override
  String studyChapterX(String param) {
    return 'Bölüm $param';
  }

  @override
  String get studyEmpty => 'Boş';

  @override
  String get studyStartFromInitialPosition => 'İlk pozisyondan başlasın';

  @override
  String get studyEditor => 'Editör';

  @override
  String get studyStartFromCustomPosition => 'Özel bir pozisyondan başlasın';

  @override
  String get studyLoadAGameByUrl => 'URL ile oyun yükle';

  @override
  String get studyLoadAPositionFromFen => 'FEN kullanarak pozisyon yükle';

  @override
  String get studyLoadAGameFromPgn => 'PGN ile oyun yükle';

  @override
  String get studyAutomatic => 'Otomatik';

  @override
  String get studyUrlOfTheGame => 'Oyunun bağlantısı';

  @override
  String studyLoadAGameFromXOrY(String param1, String param2) {
    return '$param1 veya $param2 kullanarak oyun yükle';
  }

  @override
  String get studyCreateChapter => 'Bölüm oluştur';

  @override
  String get studyCreateStudy => 'Çalışma oluştur';

  @override
  String get studyEditStudy => 'Çalışmayı düzenle';

  @override
  String get studyVisibility => 'Görünürlük';

  @override
  String get studyPublic => 'Herkese açık';

  @override
  String get studyUnlisted => 'Liste dışı';

  @override
  String get studyInviteOnly => 'Sadece davet edilenler';

  @override
  String get studyAllowCloning => 'Klonlamaya izni olanlar';

  @override
  String get studyNobody => 'Hiç kimse';

  @override
  String get studyOnlyMe => 'Sadece ben';

  @override
  String get studyContributors => 'Katkıda Bulunanlar';

  @override
  String get studyMembers => 'Üyeler';

  @override
  String get studyEveryone => 'Herkes';

  @override
  String get studyEnableSync => 'Senkronizasyonu etkinleştir';

  @override
  String get studyYesKeepEveryoneOnTheSamePosition => 'Evet: herkes aynı pozisyonda kalsın';

  @override
  String get studyNoLetPeopleBrowseFreely => 'Hayır: herkes dilediğince gezinebilsin';

  @override
  String get studyPinnedStudyComment => 'Çalışma üzerine yorumlar';

  @override
  String get studyStart => 'Başlat';

  @override
  String get studySave => 'Kaydet';

  @override
  String get studyClearChat => 'Sohbeti temizle';

  @override
  String get studyDeleteTheStudyChatHistory =>
      'Çalışmanın sohbet geçmişi silinsin mi? Bunun geri dönüşü yok!';

  @override
  String get studyDeleteStudy => 'Çalışmayı sil';

  @override
  String studyConfirmDeleteStudy(String param) {
    return 'Tüm çalışma silinsin mi? Bunun geri dönüşü yok! İşlemi onaylamak için çalışmanın adını yazın: $param';
  }

  @override
  String get studyWhereDoYouWantToStudyThat => 'Bu çalışmayı nerede sürdürmek istersiniz?';

  @override
  String get studyGoodMove => 'İyi hamle';

  @override
  String get studyMistake => 'Hata';

  @override
  String get studyBrilliantMove => 'Muhteşem hamle';

  @override
  String get studyBlunder => 'Vahim hata';

  @override
  String get studyInterestingMove => 'İlginç hamle';

  @override
  String get studyDubiousMove => 'Şüpheli hamle';

  @override
  String get studyOnlyMove => 'Tek hamle';

  @override
  String get studyZugzwang => 'Zugzwang';

  @override
  String get studyEqualPosition => 'Eşit pozisyon';

  @override
  String get studyUnclearPosition => 'Belirsiz pozisyon';

  @override
  String get studyWhiteIsSlightlyBetter => 'Beyaz biraz önde';

  @override
  String get studyBlackIsSlightlyBetter => 'Siyah biraz önde';

  @override
  String get studyWhiteIsBetter => 'Beyaz daha üstün';

  @override
  String get studyBlackIsBetter => 'Siyah daha üstün';

  @override
  String get studyWhiteIsWinning => 'Beyaz kazanıyor';

  @override
  String get studyBlackIsWinning => 'Siyah kazanıyor';

  @override
  String get studyNovelty => 'Farklı bir açılış';

  @override
  String get studyDevelopment => 'Gelişim hamlesi';

  @override
  String get studyInitiative => 'Girişim';

  @override
  String get studyAttack => 'Saldırı';

  @override
  String get studyCounterplay => 'Karşı saldırı';

  @override
  String get studyTimeTrouble => 'Vakit sıkıntısı';

  @override
  String get studyWithCompensation => 'Pozisyon avantajı ile';

  @override
  String get studyWithTheIdea => 'Plan doğrultusunda';

  @override
  String get studyNextChapter => 'Sonraki bölüm';

  @override
  String get studyPrevChapter => 'Önceki bölüm';

  @override
  String get studyStudyActions => 'Çalışma seçenekleri';

  @override
  String get studyTopics => 'Konular';

  @override
  String get studyMyTopics => 'Konularım';

  @override
  String get studyPopularTopics => 'Popüler konular';

  @override
  String get studyManageTopics => 'Konuları yönet';

  @override
  String get studyBack => 'Baştan başlat';

  @override
  String get studyPlayAgain => 'Tekrar oyna';

  @override
  String get studyWhatWouldYouPlay => 'Burada hangi hamleyi yapardınız?';

  @override
  String get studyYouCompletedThisLesson => 'Tebrikler! Bu dersi tamamlandınız.';

  @override
  String studyPerPage(String param) {
    return 'Sayfa başına $param';
  }

  @override
  String get studyGetTheTour => 'Yardıma mı ihtiyacın var? Tura başla!';

  @override
  String get studyWelcomeToLichessStudyTitle => 'Lichess Dersine Hoşgeldin! ';

  @override
  String get studyWelcomeToLichessStudyText =>
      'Bu paylaşımlı bir analiz panosudur.<br><br>Oyunları analiz etmek ve not eklemek,<br>arkadaşlarınızla pozisyonları tartışmak,<br>ve tabii ki satranç dersleri için kullanabilirsiniz!<br><br>Güçlü bir araç, nasıl çalıştığını görmek için biraz zaman ayıralım.';

  @override
  String get studySharedAndSaveTitle => 'Paylaşıldı ve kaydedildi';

  @override
  String get studySharedAndSavedText =>
      'Diğer üyeler sizin hareketlerinizi gerçek zamanlı olarak görebilir!<br>Ayrıca, her şey sonsuza kadar kaydedilir.';

  @override
  String get studyStudyMembersTitle => 'Çalışma üyeleri';

  @override
  String studyStudyMembersText(String param1, String param2) {
    return '$param1 Seyirciler çalışmayı görüntüleyebilir ve sohbette konuşabilir.<br><br>$param2 Katılımcılar hamle yapabilir ve çalışmayı güncelleyebilir.';
  }

  @override
  String studyAddMembersText(String param) {
    return '$param düğmesine tıklayın.<br>Sonra kimlerin katılabileceğine karar verin.';
  }

  @override
  String get studyStudyChaptersTitle => 'Çalışma bölümleri';

  @override
  String get studyStudyChaptersText =>
      'Bir çalışma birden fazla bölüm içerebilir.<br>Her bir bölüm ayrı bir başlangıç konumuna ve hamle ağacına sahiptir.';

  @override
  String get studyCommentPositionTitle => 'Bir pozisyona yorum yap';

  @override
  String studyCommentPositionText(String param) {
    return '$param düğmesine tıklayın veya sağdaki taşıma listesine sağ tıklayın.<br>Yorumlar paylaşılır ve kaydedilir.';
  }

  @override
  String get studyAnnotatePositionTitle => 'Konuma yorum ekleyin';

  @override
  String get studyAnnotatePositionText =>
      '!? düğmesine tıklayın ya da sağdaki hamle listesine sağ tıklayın.<br> Yorum yazıları paylaşılır ve kaydedilir.';

  @override
  String get studyConclusionTitle => 'Vakit ayırdığınız için teşekkürler';

  @override
  String get studyConclusionText =>
      '<a href=\'/study/mine/hot\'>Önceki çalışmalarınızı</a> profil sayfanızdan bulabilirsiniz.<br>Çalışmalar hakkında ayrıca bir <a href=\'//lichess.org/blog/V0KrLSkAAMo3hsi4/study-chess-the-lichess-way\'> blog gönderisi</a> mevcuttur.<br>Usta kullanıcılar klavye kısayollarını görmek için \"?\" basabilir.<br>İyi eğlenceler!';

  @override
  String get studyCreateChapterTitle => 'Bir çalışma bölümü oluşturalım';

  @override
  String get studyCreateChapterText =>
      'Bir çalışma birkaç bölümden oluşabilir.<br>Her bölümün kendine özgü bir hareket ağacı vardır<br>ve çeşitli şekillerde oluşturulabilir.';

  @override
  String get studyFromInitialPositionTitle => 'Başlangıç pozisyonundan';

  @override
  String get studyFromInitialPositionText =>
      'Yeni bir oyun için sadece bir tahta kurulumu.<br>Açılışları keşfetmek için uygun.';

  @override
  String get studyCustomPositionTitle => 'Özel konum';

  @override
  String get studyCustomPositionText =>
      'Tahtayı istediğiniz gibi ayarlayın.<br>Son oyunları keşfetmek için uygun.';

  @override
  String get studyLoadExistingLichessGameTitle => 'Mevcut bir lichess oyununu yükle';

  @override
  String get studyLoadExistingLichessGameText =>
      'Lichess oyun URL\'sini yapıştırın<br>(örneğin lichess.org/7fHIU0XI)<br>bölümdeki oyun hamlelerini yüklemek için.';

  @override
  String get studyFromFenStringTitle => 'Bir FEN dizisinden';

  @override
  String get studyFromFenStringText =>
      'Paste a position in FEN format<br><i>4k3/4rb2/8/7p/8/5Q2/1PP5/1K6 w</i><br>to start the chapter from a position.';

  @override
  String get studyFromPgnGameTitle => 'PGN oyunundan';

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
  String get studyDoubleDefeat => 'Çift mağlubiyet';

  @override
  String get studyBlackDefeatWhiteCanNotWin => 'Black defeat, but White can\'t win';

  @override
  String get studyWhiteDefeatBlackCanNotWin => 'Beyaz kaybeder fakat siyah kazanamaz';

  @override
  String studyNbChapters(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Bölüm',
      one: '$count Bölüm',
    );
    return '$_temp0';
  }

  @override
  String studyNbGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Oyun',
      one: '$count oyun',
    );
    return '$_temp0';
  }

  @override
  String studyNbMembers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Üye',
      one: '$count Üye',
    );
    return '$_temp0';
  }

  @override
  String studyPasteYourPgnTextHereUpToNbGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'PGN metninizi buraya yapıştırın, en fazla $count oyuna kadar',
      one: 'PGN metninizi buraya yapıştırın, en fazla $count oyuna kadar',
    );
    return '$_temp0';
  }

  @override
  String get timeagoJustNow => 'şu anda';

  @override
  String get timeagoRightNow => 'hemen şimdi';

  @override
  String get timeagoCompleted => 'tamamlanmış';

  @override
  String timeagoInNbSeconds(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count saniyede',
      one: '$count saniyede',
    );
    return '$_temp0';
  }

  @override
  String timeagoInNbMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count dakikada',
      one: '$count dakikada',
    );
    return '$_temp0';
  }

  @override
  String timeagoInNbHours(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count saatte',
      one: '$count saatte',
    );
    return '$_temp0';
  }

  @override
  String timeagoInNbDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count günde',
      one: '$count günde',
    );
    return '$_temp0';
  }

  @override
  String timeagoInNbWeeks(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count haftada',
      one: '$count haftada',
    );
    return '$_temp0';
  }

  @override
  String timeagoInNbMonths(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ayda',
      one: '$count ayda',
    );
    return '$_temp0';
  }

  @override
  String timeagoInNbYears(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count yılda',
      one: '$count yılda',
    );
    return '$_temp0';
  }

  @override
  String timeagoNbMinutesAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count dakika önce',
      one: '$count dakika önce',
    );
    return '$_temp0';
  }

  @override
  String timeagoNbHoursAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count saat önce',
      one: '$count saat önce',
    );
    return '$_temp0';
  }

  @override
  String timeagoNbDaysAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count gün önce',
      one: '$count gün önce',
    );
    return '$_temp0';
  }

  @override
  String timeagoNbWeeksAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count hafta önce',
      one: '$count hafta önce',
    );
    return '$_temp0';
  }

  @override
  String timeagoNbMonthsAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ay önce',
      one: '$count ay önce',
    );
    return '$_temp0';
  }

  @override
  String timeagoNbYearsAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count yıl önce',
      one: '$count yıl önce',
    );
    return '$_temp0';
  }

  @override
  String timeagoNbMinutesRemaining(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count dakika kaldı',
      one: '$count dakika kaldı',
    );
    return '$_temp0';
  }

  @override
  String timeagoNbHoursRemaining(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count saat kaldı',
      one: '$count saat kaldı',
    );
    return '$_temp0';
  }
}
