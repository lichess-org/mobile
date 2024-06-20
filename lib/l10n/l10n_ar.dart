import 'package:intl/intl.dart' as intl;

import 'l10n.dart';

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get activityActivity => 'الأنشطة';

  @override
  String get activityHostedALiveStream => 'بدأ بث مباشر';

  @override
  String activityRankedInSwissTournament(String param1, String param2) {
    return 'حائز على تصنيف #$param1 في $param2';
  }

  @override
  String get activitySignedUp => 'إنشيء حساب ليتشيس جديد';

  @override
  String activitySupportedNbMonths(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'دعم lichess.org لمدة $count أشهر ك $param2',
      many: 'دعم lichess.org لمدة $count اشهر ك$param2',
      few: 'دعم lichess.org لمدة $count اشهر ك$param2',
      two: 'دعم lichess.org لمدة $count أشهر ك$param2',
      one: 'دعم lichess.org لمدة $count شهر ك$param2',
      zero: 'دعم ليتشيس لمدة $count شهر ك$param2',
    );
    return '$_temp0';
  }

  @override
  String activityPracticedNbPositions(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'لقد تدربت على $count موقفا تكتيكيا من $param2',
      many: 'لقد تدربت على $count موقفا تكتيكيا من $param2',
      few: 'لقد تدربت على $count مواقف تكتيكية من $param2',
      two: 'لقد تدربت على $count موقفين تكتيكيين من $param2',
      one: 'لقد تدربت على $count موقف تكتيكي من $param2',
      zero: 'لقد تدربت على $count موقف تكتيكي من $param2',
    );
    return '$_temp0';
  }

  @override
  String activitySolvedNbPuzzles(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'تم حل $count لغز تكتيكي',
      many: 'تم حل $count لغز تكتيكي',
      few: 'تم حل $count ألغاز تكتيكية',
      two: 'تم حل $count من الالغاز التكتيكية',
      one: 'تم حل $count لغز تكتيكي',
      zero: 'تم حل $count لغز تكتيكي',
    );
    return '$_temp0';
  }

  @override
  String activityPlayedNbGames(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'تم لعب $count مباراة $param2',
      many: 'تم لعب $count مباراة $param2',
      few: 'تم لعب $count مباراة $param2',
      two: 'تم لعب $count مباراة $param2',
      one: 'تم لعب $count مباراة $param2',
      zero: 'تم لعب $count مباراة $param2',
    );
    return '$_temp0';
  }

  @override
  String activityPostedNbMessages(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'تم ارسال $count رسالة في $param2',
      many: 'تم ارسال $count رسالة في $param2',
      few: 'تم ارسال $count رسالة في $param2',
      two: 'تم ارسال $count رسالة في $param2',
      one: 'تم ارسال $count رسالة في $param2',
      zero: 'تم ارسال $count رسالة في $param2',
    );
    return '$_temp0';
  }

  @override
  String activityPlayedNbMoves(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'لعب $count من النقلات',
      many: 'لعب $count من النقلات',
      few: 'لعب $count من النقلات',
      two: 'لعب $count نقلتين',
      one: 'لعب $count نقلة',
      zero: 'لعب $count نقلة',
    );
    return '$_temp0';
  }

  @override
  String activityInNbCorrespondenceGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'في $count من مباريات المراسلة',
      many: 'في $count من مباريات المراسلة',
      few: 'في $count مباريات مراسلة',
      two: 'في $count مباريات مراسلة',
      one: 'في $count مباريات مراسلة',
      zero: 'في $count مباريات مراسلة',
    );
    return '$_temp0';
  }

  @override
  String activityCompletedNbGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'تم اكمال $count مباراة بالمراسلة',
      many: 'تم اكمال $count مباراة بالمراسلة',
      few: 'تم اكمال $count مباراة بالمراسلة',
      two: 'تم اكمال $count مباراة بالمراسلة',
      one: 'تم اكمال $count مباراة بالمراسلة',
      zero: 'تم اكمال $count مباراة بالمراسلة',
    );
    return '$_temp0';
  }

  @override
  String activityFollowedNbPlayers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'تم البدء في متابعة $count لاعب',
      many: 'تم البدء في متابعة $count لاعبين',
      few: 'تم البدء في متابعة $count لاعبين',
      two: 'تم البدء في متابعة $count لاعبان',
      one: 'تم البدء في متابعة $count لاعب',
      zero: 'تم البدء في متابعة $count لاعب',
    );
    return '$_temp0';
  }

  @override
  String activityGainedNbFollowers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'اكتسب $count متابع جديد',
      many: 'اكتسب $count متابع جديد',
      few: 'اكتسب $count متابعين جدد',
      two: 'اكتسب $count متابعان جديدان',
      one: 'اكتسب $count متابع جديد',
      zero: 'اكتسب $count متابع جديد',
    );
    return '$_temp0';
  }

  @override
  String activityHostedNbSimuls(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'استضافة $count مباراة استعراضية في نفس الوقت',
      many: 'استضافة $count مباراة استعراضية في نفس الوقت',
      few: 'استضافة $count مباراة استعراضية في نفس الوقت',
      two: 'استضافة $count مباراة استعراضية في نفس الوقت',
      one: 'استضافة $count مباراة استعراضية في نفس الوقت',
      zero: 'استضافة $count مباراة استعراضية في نفس الوقت',
    );
    return '$_temp0';
  }

  @override
  String activityJoinedNbSimuls(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'المشاركة في $count مباراة استعراضية في نفس الوقت',
      many: 'المشاركة في $count مباراة استعراضية في نفس الوقت',
      few: 'المشاركة في $count مباراة استعراضية في نفس الوقت',
      two: 'المشاركة في $count مباراة استعراضية في نفس الوقت',
      one: 'المشاركة في $count مباراة استعراضية في نفس الوقت',
      zero: 'المشاركة في $count مباراة استعراضية في نفس الوقت',
    );
    return '$_temp0';
  }

  @override
  String activityCreatedNbStudies(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'تم إنشاء $count دراسة جديدة',
      many: 'تم إنشاء $count دراسة جديدة',
      few: 'تم إنشاء $count دراسة جديدة',
      two: 'تم إنشاء $count دراسة جديدة',
      one: 'تم إنشاء $count دراسة جديدة',
      zero: 'تم إنشاء $count دراسة جديدة',
    );
    return '$_temp0';
  }

  @override
  String activityCompetedInNbTournaments(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'تنافس في $count بطولة',
      many: 'تنافس في $count بطولة',
      few: 'تنافس في $count بطولة',
      two: 'تنافس في $count بطولة',
      one: 'تنافس في $count بطولة',
      zero: 'تنافس في $count بطولة',
    );
    return '$_temp0';
  }

  @override
  String activityRankedInTournament(int count, String param2, String param3, String param4) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'المركز #$count (أفضل $param2%) ل $param3 مباراة في $param4',
      many: 'المركز #$count (أفضل $param2%) ل $param3 مباراة في $param4',
      few: 'المركز #$count (أفضل $param2%) ل $param3 مباراة في $param4',
      two: 'المركز #$count (أفضل $param2%) ل $param3 مباراة في $param4',
      one: 'المركز #$count (أفضل $param2%) ل $param3 مباراة في $param4',
      zero: 'المركز #$count (أفضل $param2%) ل $param3 مباراة في $param4',
    );
    return '$_temp0';
  }

  @override
  String activityCompetedInNbSwissTournaments(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'تنافس في $count بطولة سويسرية',
      many: 'تنافس في $count بطولة سويسرية',
      few: 'تنافس في $count بطولة سويسرية',
      two: 'تنافس في $count بطولة سويسرية',
      one: 'تنافس في $count بطولة سويسرية',
      zero: 'تنافس في $count بطولة سويسرية',
    );
    return '$_temp0';
  }

  @override
  String activityJoinedNbTeams(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'إنضم ل $count فريقًا',
      many: 'إنضم ل $count فرقة',
      few: 'إنضم ل $count فرق',
      two: 'إنضم لفريقين $count',
      one: 'إنضم ل $count فريق',
      zero: 'إنضم ل $count فريق',
    );
    return '$_temp0';
  }

  @override
  String get contactContact => 'اتصل بنا';

  @override
  String get contactContactLichess => 'تواصل مع Lichess';

  @override
  String get playWithAFriend => 'اللعب مع صديق';

  @override
  String get playWithTheMachine => 'اللعب مع الحاسوب';

  @override
  String get toInviteSomeoneToPlayGiveThisUrl => 'لدعوة شخص ما للعب، أرسل له هذا الرابط';

  @override
  String get gameOver => 'انتهت المباراة';

  @override
  String get waitingForOpponent => 'في إنتظار المنافس';

  @override
  String get orLetYourOpponentScanQrCode => 'أو أجعل خصمك يمسح رمز QR هذا';

  @override
  String get waiting => 'قيد الانتظار';

  @override
  String get yourTurn => 'دورك';

  @override
  String aiNameLevelAiLevel(String param1, String param2) {
    return '$param1 مستوى $param2';
  }

  @override
  String get level => 'مستوى';

  @override
  String get strength => 'القوة';

  @override
  String get toggleTheChat => 'تعطيل/تشغيل الدردشة';

  @override
  String get chat => 'دردشة';

  @override
  String get resign => 'استسلام';

  @override
  String get checkmate => 'كش مات';

  @override
  String get stalemate => 'مات مخنوق';

  @override
  String get white => 'أبيض';

  @override
  String get black => 'أسود';

  @override
  String get asWhite => 'بالأبيض';

  @override
  String get asBlack => 'الأسود';

  @override
  String get randomColor => 'لون عشوائي';

  @override
  String get createAGame => 'إنشاء مباراة';

  @override
  String get whiteIsVictorious => 'الأبيض فاز';

  @override
  String get blackIsVictorious => 'الأسود فاز';

  @override
  String get youPlayTheWhitePieces => 'أنت تلعب بالقطع البيضاء';

  @override
  String get youPlayTheBlackPieces => 'أنت تلعب بالقطع السوداء';

  @override
  String get itsYourTurn => 'إنه دورك!';

  @override
  String get cheatDetected => 'تحديد حالة غِشّ';

  @override
  String get kingInTheCenter => 'الملك في الوسط';

  @override
  String get threeChecks => 'كش ملك ثلاثا';

  @override
  String get raceFinished => 'نهاية السباق';

  @override
  String get variantEnding => 'نهاية خاصة';

  @override
  String get newOpponent => 'خصم جديد';

  @override
  String get yourOpponentWantsToPlayANewGameWithYou => 'يريد متحديك أن يلعب مباراة جديدة معك';

  @override
  String get joinTheGame => 'انضم إلى المباراة';

  @override
  String get whitePlays => 'دور الأبيض';

  @override
  String get blackPlays => 'دور الأسود';

  @override
  String get opponentLeftChoices => 'يبدو أن الخصم ترك المباراة. يمكنك انتزاع الفوز، إعلان التعادل أو الانتظار.';

  @override
  String get forceResignation => 'إعلن فوزك';

  @override
  String get forceDraw => 'إعلن التعادل';

  @override
  String get talkInChat => 'كن حسن الخلق في الدردشة!';

  @override
  String get theFirstPersonToComeOnThisUrlWillPlayWithYou => 'أول من يأتي لهذا الرابط سيلعب معك.';

  @override
  String get whiteResigned => 'الأبيض استسلم';

  @override
  String get blackResigned => 'الأسود استسلم';

  @override
  String get whiteLeftTheGame => 'الأبيض ترك المباراة';

  @override
  String get blackLeftTheGame => 'الأسود ترك المباراة';

  @override
  String get whiteDidntMove => 'لم يقم الأبيض بالحركة';

  @override
  String get blackDidntMove => 'لم يلعب الأسود بعد';

  @override
  String get requestAComputerAnalysis => 'اطلب تحليل حاسب';

  @override
  String get computerAnalysis => 'تحليل الحاسوب';

  @override
  String get computerAnalysisAvailable => 'تحليل الحاسوب متاح';

  @override
  String get computerAnalysisDisabled => 'تحليل الحاسوب غير مفعل';

  @override
  String get analysis => 'لوحة التحليل';

  @override
  String depthX(String param) {
    return 'عمق التحليل $param';
  }

  @override
  String get usingServerAnalysis => 'استخدام تحليل الخادم';

  @override
  String get loadingEngine => 'تحميل المحرك...';

  @override
  String get calculatingMoves => 'جاري حساب النقلات...';

  @override
  String get engineFailed => 'خطأ في تحميل المحرك';

  @override
  String get cloudAnalysis => 'تحليل سحابي';

  @override
  String get goDeeper => 'تحليل أعمق';

  @override
  String get showThreat => 'إظهار التهديد';

  @override
  String get inLocalBrowser => 'في متصفحك';

  @override
  String get toggleLocalEvaluation => 'التبديل للتحليل بالمتصفح';

  @override
  String get promoteVariation => 'رفع سلسلة الحركات';

  @override
  String get makeMainLine => 'رفع الى التسلسل الرئيسي';

  @override
  String get deleteFromHere => 'احذف من هنا';

  @override
  String get forceVariation => 'فرض التسلسل';

  @override
  String get copyVariationPgn => 'انسخ التفريع بصيغة PGN';

  @override
  String get move => 'التقلة';

  @override
  String get variantLoss => 'خسارة بطريقة خاصة';

  @override
  String get variantWin => 'فوز بطريقة خاصة';

  @override
  String get insufficientMaterial => 'قطع غير كافية لإنهاء المباراة';

  @override
  String get pawnMove => 'نقلة بيدق';

  @override
  String get capture => 'أسر';

  @override
  String get close => 'إغلاق';

  @override
  String get winning => 'فائزة';

  @override
  String get losing => 'خاسرة';

  @override
  String get drawn => 'تعادل';

  @override
  String get unknown => 'مجهول';

  @override
  String get database => 'قاعدة بيانات';

  @override
  String get whiteDrawBlack => 'أسود / تعادل / أبيض';

  @override
  String averageRatingX(String param) {
    return 'متوسط التقييم: $param';
  }

  @override
  String get recentGames => 'أحدث المباريات';

  @override
  String get topGames => 'أفضل الالعاب';

  @override
  String masterDbExplanation(String param1, String param2, String param3) {
    return 'قاعدة بيانات مباريات الأساتذة تقييم $param1+ للاعبين من $param2 إلى $param3';
  }

  @override
  String get dtzWithRounding => 'DTZ50\'\' هي عدد الحركات حتى حصول أخذ أو تحريك بيدق';

  @override
  String get noGameFound => 'لم يتم العثور على مباريات';

  @override
  String get maxDepthReached => 'تم الوصول إلى أقصى عمق!';

  @override
  String get maybeIncludeMoreGamesFromThePreferencesMenu => 'أترغب في ضم مباريات أكثر من قائمة التفضيلات؟';

  @override
  String get openings => 'الافتتاحيات';

  @override
  String get openingExplorer => 'مستكشف الافتتاحيات';

  @override
  String get openingEndgameExplorer => 'مستكشف نهاية/بداية الدور';

  @override
  String xOpeningExplorer(String param) {
    return 'مستكشف افتتاحيات $param';
  }

  @override
  String get playFirstOpeningEndgameExplorerMove => 'Play first opening/endgame-explorer move';

  @override
  String get winPreventedBy50MoveRule => 'قاعدة ال 50 نقلة منعت الفوز';

  @override
  String get lossSavedBy50MoveRule => 'قاعدة ال 50 نقلة منعت الخسارة';

  @override
  String get winOr50MovesByPriorMistake => 'فوز أو 50 حركة عن طريق خطأ سابق';

  @override
  String get lossOr50MovesByPriorMistake => 'خسارة أو 50 نقلة عن طريق خطأ سابق';

  @override
  String get unknownDueToRounding => 'فالفوز/الخسارة المكفولة فقط إذا كان خط الأساس الموصى به قد اتبع منذ آخر عملية لالتقاط أو تحريك للبياء، بسبب احتمال تقريب الأرباح.';

  @override
  String get allSet => 'إعتمد كل الإعدادات!';

  @override
  String get importPgn => 'استيراد PGN';

  @override
  String get delete => 'حذف';

  @override
  String get deleteThisImportedGame => 'هل تريد حذف هذه المباراة المستوردة؟';

  @override
  String get replayMode => 'نمط إعادة العرض';

  @override
  String get realtimeReplay => 'ذات الوقت';

  @override
  String get byCPL => 'بالاثارة';

  @override
  String get openStudy => 'فتح دراسة';

  @override
  String get enable => 'تفعيل';

  @override
  String get bestMoveArrow => 'سهم أفضل نقلة';

  @override
  String get showVariationArrows => 'أظهر سلسلة النقلات المرشحة';

  @override
  String get evaluationGauge => 'مقياس التقييم';

  @override
  String get multipleLines => 'عدد الخطوط';

  @override
  String get cpus => 'المعالجات';

  @override
  String get memory => 'الذاكرة';

  @override
  String get infiniteAnalysis => 'تحليل لانهائي';

  @override
  String get removesTheDepthLimit => 'التحليل لأبعد عمق، وابقاء حاسوبك نشطًا';

  @override
  String get engineManager => 'مدير المحركات';

  @override
  String get blunder => 'خطأ فادح';

  @override
  String get mistake => 'خطأ';

  @override
  String get inaccuracy => 'غير دقيق';

  @override
  String get moveTimes => 'توقيت النقلات';

  @override
  String get flipBoard => 'تدوير الرقعة';

  @override
  String get threefoldRepetition => 'تكرار ثلاثي';

  @override
  String get claimADraw => 'إعلان التعادل';

  @override
  String get offerDraw => 'عرض التعادل';

  @override
  String get draw => 'تعادل';

  @override
  String get drawByMutualAgreement => 'التعادل بالاتفاق المتبادل';

  @override
  String get fiftyMovesWithoutProgress => 'خمسون حركة بدون أي تقدم';

  @override
  String get currentGames => 'المباريات الحالية';

  @override
  String get viewInFullSize => 'عرض بالحجم الكامل';

  @override
  String get logOut => 'خروج';

  @override
  String get signIn => 'دخول';

  @override
  String get rememberMe => 'ابقني مسجل هنا';

  @override
  String get youNeedAnAccountToDoThat => 'تحتاج حسابا لهذا';

  @override
  String get signUp => 'تسجيل';

  @override
  String get computersAreNotAllowedToPlay => 'برامج الشطرنج واللاعبين الذين يستعينون بالبرامج ممنوعين من اللعب. فضلا لا تستخدم برامج الشطرنج، قواعد البيانات، أو مساعدة لاعبين آخرين أثناء اللعب. بالإضافة إلى ذلك يرجى عدم تسجيل أكثر من حساب لأن ذلك قد يؤدي إلى الحظر من الموقع.';

  @override
  String get games => 'المباريات';

  @override
  String get forum => 'منتدى';

  @override
  String xPostedInForumY(String param1, String param2) {
    return '$param1 منشور في الموضوع $param2';
  }

  @override
  String get latestForumPosts => 'آخر منشورات المنتدى';

  @override
  String get players => 'اللاعبون';

  @override
  String get friends => 'الأصدقاء';

  @override
  String get discussions => 'المحادثات';

  @override
  String get today => 'اليوم';

  @override
  String get yesterday => 'الأمس';

  @override
  String get minutesPerSide => 'دقائق لكل طرف';

  @override
  String get variant => 'النوع';

  @override
  String get variants => 'الأنواع';

  @override
  String get timeControl => 'التوقيت';

  @override
  String get realTime => 'سريع';

  @override
  String get correspondence => 'مراسلة';

  @override
  String get daysPerTurn => 'يوم لكل نقلة';

  @override
  String get oneDay => 'يوم واحد';

  @override
  String get time => 'الوقت';

  @override
  String get rating => 'التقييم';

  @override
  String get ratingStats => 'احصائيات التقييم';

  @override
  String get username => 'اسم المستخدم';

  @override
  String get usernameOrEmail => 'اسم المستخدم أو البريد الإلكتروني';

  @override
  String get changeUsername => 'تغيير اسم المستخدم';

  @override
  String get changeUsernameNotSame => 'يمكن تغيير حساسية الأحرف فقط.';

  @override
  String get changeUsernameDescription => 'غير إسم المستخدم. يمكنك تغيير إسم المستخدم الخاص بك مرة واحدة فقط, ويمكنك فقط تغيير حساسية الاحرف.';

  @override
  String get signupUsernameHint => 'تأكد من اختيار اسم مستخدم صديق للعائلة. لا يمكنك تغييره لاحقًا وأي حسابات تحتوي على أسماء مستخدمين غير ملائمة سيتم إغلاقها!';

  @override
  String get signupEmailHint => 'سوف نستخدمه فقط لإعادة تعيين كلمة المرور.';

  @override
  String get password => 'كلمة السر';

  @override
  String get changePassword => 'تغيير كلمة السر';

  @override
  String get changeEmail => 'غير البريد الإلكتروني';

  @override
  String get email => 'البريد الإلكتروني';

  @override
  String get passwordReset => 'إعادة تعيين كلمة المرور';

  @override
  String get forgotPassword => 'هل نسيت كلمة المرور؟';

  @override
  String get error_weakPassword => 'كلمة المرور هذه ضعيفة للغاية, و يسهل تخمينها.';

  @override
  String get error_namePassword => 'الرجاء عدم استخدام اسم المستخدم الخاص بك ككلمة المرور الخاصة بك.';

  @override
  String get blankedPassword => 'لقد استخدمت نفس كلمة المرور في موقع آخر، وقد تعرض ذلك الموقع للخطر. لضمان سلامة حساب Lichess الخاص بك، نحن بحاجة منك إلى تعيين كلمة مرور جديدة. شكرا لتفهمك.';

  @override
  String get youAreLeavingLichess => 'أنت تغادر Lichess';

  @override
  String get neverTypeYourPassword => 'لا تكتب كلمة مرور Lichess الخاصة بك على موقع آخر!';

  @override
  String proceedToX(String param) {
    return 'انتقل إلى $param';
  }

  @override
  String get passwordSuggestion => 'لا تقم بتعيين كلمة مرور مقترحة من قبل شخص آخر. سوف يستخدمونها لسرقة حسابك.';

  @override
  String get emailSuggestion => 'لا تقم بتعيين عنوان بريد إلكتروني اقترحه شخص آخر. سوف يستخدمه لسرقة حسابك.';

  @override
  String get emailConfirmHelp => 'المساعدة في تأكيد البريد الإلكتروني';

  @override
  String get emailConfirmNotReceived => 'لم تستلم بريدك الإلكتروني للتأكيد بعد التسجيل؟';

  @override
  String get whatSignupUsername => 'ما هو اسم المستخدم الذي استخدمته للتسجيل؟';

  @override
  String usernameNotFound(String param) {
    return 'لم نتمكن من العثور على أي مستخدم بهذا الاسم: $param.';
  }

  @override
  String get usernameCanBeUsedForNewAccount => 'يمكنك استخدام اسم المستخدم هذا لإنشاء حساب جديد';

  @override
  String emailSent(String param) {
    return 'لقد أرسلنا رسالة بريد إلكتروني إلى $param.';
  }

  @override
  String get emailCanTakeSomeTime => 'قد تستغرق وقت للوصول.';

  @override
  String get refreshInboxAfterFiveMinutes => 'انتظر 5 دقائق وحدث بريدك الوارد.';

  @override
  String get checkSpamFolder => 'تحقق ايضا من بريدك المهمل ربما وصل لهناك، اذا وجدت الرسالة هناك علمها ك\"غير مهمل\".';

  @override
  String get emailForSignupHelp => 'اذا فشلت كل المحاولات ارسل لنا ايميل:';

  @override
  String copyTextToEmail(String param) {
    return 'انسح النص اعلاه و ارسله للبريد التالي$param';
  }

  @override
  String get waitForSignupHelp => 'سنعود اليك قريباً لمساعدتك على اكمال التسجيل.';

  @override
  String accountConfirmed(String param) {
    return 'المستخدم $param تم تأكيده بنجاح.';
  }

  @override
  String accountCanLogin(String param) {
    return 'يمكنك الان الدخول باسم $param.';
  }

  @override
  String get accountConfirmationEmailNotNeeded => 'لا حاجة لتأكيد ايميلك.';

  @override
  String accountClosed(String param) {
    return 'هذا الحساب$param مغلق.';
  }

  @override
  String accountRegisteredWithoutEmail(String param) {
    return 'هذا الحساب$param تم تسجيله بدون ايميل.';
  }

  @override
  String get rank => 'المرتبة';

  @override
  String rankX(String param) {
    return 'الترتيب: $param';
  }

  @override
  String get gamesPlayed => 'المباريات الملعوبة';

  @override
  String get cancel => 'إلغاء';

  @override
  String get whiteTimeOut => 'انتهى وقت الأبيض';

  @override
  String get blackTimeOut => 'انتهى وقت الأسود';

  @override
  String get drawOfferSent => 'تم ارسال عرض التعادل';

  @override
  String get drawOfferAccepted => 'تم قبول عرض التعادل';

  @override
  String get drawOfferCanceled => 'أُلغي عرض التعادل';

  @override
  String get whiteOffersDraw => 'الأبيض يعرض التعادل';

  @override
  String get blackOffersDraw => 'الأسود يعرض التعادل';

  @override
  String get whiteDeclinesDraw => 'الأبيض رفض التعادل';

  @override
  String get blackDeclinesDraw => 'الأسود رفض التعادل';

  @override
  String get yourOpponentOffersADraw => 'الخصم يعرض التعادل';

  @override
  String get accept => 'قبول';

  @override
  String get decline => 'رفض';

  @override
  String get playingRightNow => 'يلعب الآن';

  @override
  String get eventInProgress => 'يلعب الآن';

  @override
  String get finished => 'انتهت';

  @override
  String get abortGame => 'إلغاء اللعبة';

  @override
  String get gameAborted => 'اللعبة ألغيت';

  @override
  String get standard => 'عادي';

  @override
  String get customPosition => 'موضع مخصص';

  @override
  String get unlimited => 'غير محدود';

  @override
  String get mode => 'مقيمة أو غير مقيمة';

  @override
  String get casual => 'غير مقيّمة';

  @override
  String get rated => 'مقيّمة';

  @override
  String get casualTournament => 'غير مقيّمة';

  @override
  String get ratedTournament => 'مقيّمة';

  @override
  String get thisGameIsRated => 'هذه اللعبة مقيّمة';

  @override
  String get rematch => 'العب مرة أخرى';

  @override
  String get rematchOfferSent => 'أُرسل طلب اللعب';

  @override
  String get rematchOfferAccepted => 'قُبل طلب اللعب';

  @override
  String get rematchOfferCanceled => 'أُلغي طلب اللعب';

  @override
  String get rematchOfferDeclined => 'رُفض طلب اللعب';

  @override
  String get cancelRematchOffer => 'إلغاء  طلب اللعب';

  @override
  String get viewRematch => 'شاهد اللعبة اللاحقة';

  @override
  String get confirmMove => 'تأكيد النقلة';

  @override
  String get play => 'العب';

  @override
  String get inbox => 'صندوق الرسائل';

  @override
  String get chatRoom => 'غرفة الدردشة';

  @override
  String get loginToChat => 'تسجيل الدخول للدردشة';

  @override
  String get youHaveBeenTimedOut => 'تم حظرك مؤقتًا.';

  @override
  String get spectatorRoom => 'غرفة المشاهدين';

  @override
  String get composeMessage => 'اكتب رسالة';

  @override
  String get subject => 'عنوان';

  @override
  String get send => 'إرسال';

  @override
  String get incrementInSeconds => 'الزيادة بالثواني';

  @override
  String get freeOnlineChess => 'شطرنج مجاني على الإنترنت';

  @override
  String get exportGames => 'تصدير المباريات';

  @override
  String get ratingRange => 'نطاق التقييم';

  @override
  String get thisAccountViolatedTos => 'هذا الحساب انتهك شروط خدمة lichess';

  @override
  String get openingExplorerAndTablebase => 'مستكشف الافتتاحيات& جدول النهايات';

  @override
  String get takeback => 'تراجع';

  @override
  String get proposeATakeback => 'اقتراح تراجع عن النقلة الآخيرة';

  @override
  String get takebackPropositionSent => 'أُرسل مقترح التراجع';

  @override
  String get takebackPropositionDeclined => 'رُفض مقترح التراجع';

  @override
  String get takebackPropositionAccepted => 'قُبل مقترح التراجع';

  @override
  String get takebackPropositionCanceled => 'ألغي مقترح التراجع';

  @override
  String get yourOpponentProposesATakeback => 'خصمك يطلب تراجعا عن النقلة الأخيرة';

  @override
  String get bookmarkThisGame => 'أضف هذه المباراة للمفضلة';

  @override
  String get tournament => 'مسابقة';

  @override
  String get tournaments => 'مسابقات';

  @override
  String get tournamentPoints => 'نقاط المسابقة';

  @override
  String get viewTournament => 'شاهد المسابقة';

  @override
  String get backToTournament => 'عودة للمسابقة';

  @override
  String get noDrawBeforeSwissLimit => 'لا يمكنك التعادل قبل لعب 30 حركة في بطولة سويسرية.';

  @override
  String get thematic => 'وضعية مخصصة';

  @override
  String yourPerfRatingIsProvisional(String param) {
    return 'تقييمك في $param مؤقت';
  }

  @override
  String yourPerfRatingIsTooHigh(String param1, String param2) {
    return 'تقييمك في $param1 وقدره $param2 عالي جدًا';
  }

  @override
  String yourTopWeeklyPerfRatingIsTooHigh(String param1, String param2) {
    return 'تقييمك الأسبوعي في $param1 وقدره $param2 عالي جدًا';
  }

  @override
  String yourPerfRatingIsTooLow(String param1, String param2) {
    return 'تقييمك في $param1 وقدره $param2 منخفض جدًا';
  }

  @override
  String ratedMoreThanInPerf(String param1, String param2) {
    return 'تقييم $param1 على الأقل $param2';
  }

  @override
  String ratedLessThanInPerf(String param1, String param2) {
    return 'تقييم $param1 فأقل $param2';
  }

  @override
  String mustBeInTeam(String param) {
    return 'يجب أن تكون في فريق $param';
  }

  @override
  String youAreNotInTeam(String param) {
    return 'عذراََ, أنت لست عضو في فريق $param';
  }

  @override
  String get backToGame => 'العودة للمباراة';

  @override
  String get siteDescription => 'موقع شطرنج مجاني. العب الشطرنج الآن بتصميم نظيف، دون تسجيل او دعايات أو إضافات برمجية. العب الشطرنج مع الحاسب، الأصدقاء أو خصوما من حول الكرة الأرضية';

  @override
  String xJoinedTeamY(String param1, String param2) {
    return '$param1 انضم لفريق $param2';
  }

  @override
  String xCreatedTeamY(String param1, String param2) {
    return '$param1 أنشأ فريق $param2';
  }

  @override
  String get startedStreaming => 'بدأ البث';

  @override
  String xStartedStreaming(String param) {
    return '$param بدأ يبث';
  }

  @override
  String get averageElo => 'متوسط التقييم';

  @override
  String get location => 'الموقع';

  @override
  String get filterGames => 'تصفية المباريات';

  @override
  String get reset => 'إعادة للإفتراضي';

  @override
  String get apply => 'قبول';

  @override
  String get save => 'حفظ';

  @override
  String get leaderboard => 'قائمة الصدارة';

  @override
  String get screenshotCurrentPosition => 'لقطة شاشة';

  @override
  String get gameAsGIF => 'حفظ بصيغة GIF';

  @override
  String get pasteTheFenStringHere => 'ألصق الـFEN هنا';

  @override
  String get pasteThePgnStringHere => 'ألصق الـPGN هنا';

  @override
  String get orUploadPgnFile => 'أو حمل مِلف PGN';

  @override
  String get fromPosition => 'من وضع';

  @override
  String get continueFromHere => 'تابع من هنا';

  @override
  String get toStudy => 'دراسة';

  @override
  String get importGame => 'استورد مباراة';

  @override
  String get importGameExplanation => 'عند لصق مباراة PGN تحصل على إمكانية كرار استعراضها وتحليل حاسوبي ودردشة للمباراة ورابط قابل للمشاركة.';

  @override
  String get importGameCaveat => 'سيتم محو التغييرات. للحفاظ عليها، يرجى استيراد PGN (تنسيق لعبة الشطرنج المحمول) عبر تبويب دراسة.';

  @override
  String get importGameDataPrivacyWarning => 'يمكن لأي أحد الوصول إلى PGN، إذا أردت إنشاء تحليل خاص، استخدم قسم دراسة.';

  @override
  String get thisIsAChessCaptcha => 'هذا اختبار شطرنجي  للتمييز بين الحاسب والإنسان';

  @override
  String get clickOnTheBoardToMakeYourMove => 'اضغط على الرقعة لاختيارالنقلة وتأكيد إنسانيتك';

  @override
  String get captcha_fail => 'الرجاء حل مسألة الشطرنج مات بنقلة واحدة.';

  @override
  String get notACheckmate => 'ليست كش مات';

  @override
  String get whiteCheckmatesInOneMove => 'كش مات للأبيض في نقلة واحدة';

  @override
  String get blackCheckmatesInOneMove => 'كش مات للأسود في نقلة واحدة';

  @override
  String get retry => 'أعد المحاولة';

  @override
  String get reconnecting => 'إعادة الإتصال';

  @override
  String get noNetwork => 'غير متصل';

  @override
  String get favoriteOpponents => 'خصوم مفضلين';

  @override
  String get follow => 'تابع';

  @override
  String get following => 'متابع';

  @override
  String get unfollow => 'إالغاء المتابعة';

  @override
  String followX(String param) {
    return 'متابعة $param';
  }

  @override
  String unfollowX(String param) {
    return 'إلغاء متابعة$param';
  }

  @override
  String get block => 'حظر';

  @override
  String get blocked => 'محظور';

  @override
  String get unblock => 'إلغاء الحظر';

  @override
  String get followsYou => 'يتابعك';

  @override
  String xStartedFollowingY(String param1, String param2) {
    return '$param1 بدأ متابعة $param2';
  }

  @override
  String get more => 'المزيد';

  @override
  String get memberSince => 'مسجل منذ';

  @override
  String lastSeenActive(String param) {
    return 'آخر دخول $param';
  }

  @override
  String get player => 'لاعب';

  @override
  String get list => 'قائمة';

  @override
  String get graph => 'رسم بياني';

  @override
  String get required => 'مطلوب';

  @override
  String get openTournaments => 'المسابقات المفتوحة';

  @override
  String get duration => 'المدة';

  @override
  String get winner => 'الفائز';

  @override
  String get standing => 'الترتيب';

  @override
  String get createANewTournament => 'ابدأ مسابقة جديدة';

  @override
  String get tournamentCalendar => 'جدول البطولات';

  @override
  String get conditionOfEntry => 'شروط الدخول:';

  @override
  String get advancedSettings => 'إعدادات متقدمة';

  @override
  String get safeTournamentName => 'اختر اسماً ملائماً لهذه البطولة.';

  @override
  String get inappropriateNameWarning => 'أي شيء غير مناسب ولو حتى قليلاً يمكن أن يعرّض حسابك للإغلاق.';

  @override
  String get emptyTournamentName => 'أترك الحقل فارغاً وسيتم تسمية البطولة باسم غراند ماستر عشوائي.';

  @override
  String get recommendNotTouching => 'نوصي بعدم تغيير هذه الخيارات.';

  @override
  String get fewerPlayers => 'إذا حددت شروطَ دخولٍ للبطولة فقد يكون لديك لاعبون أقل.';

  @override
  String get showAdvancedSettings => 'إظهار الإعدادات المتقدمة';

  @override
  String get makePrivateTournament => 'جعل البطولة خاصة، وتقييد الوصول بكلمة مرور';

  @override
  String get join => 'إشترك';

  @override
  String get withdraw => 'انسحاب';

  @override
  String get points => 'النقاط';

  @override
  String get wins => 'الفوز';

  @override
  String get losses => 'الخسارة';

  @override
  String get createdBy => 'أنشأها';

  @override
  String get tournamentIsStarting => 'بدأت المسابقة';

  @override
  String get tournamentPairingsAreNowClosed => 'إزواج البطولة مغلق الآن.';

  @override
  String standByX(String param) {
    return 'تأهب يا $param، جارٍ مزاوجة اللاعبين، استعد!';
  }

  @override
  String get pause => 'الإيقاف المؤقت';

  @override
  String get resume => 'استئناف';

  @override
  String get youArePlaying => 'أنت تلعب!';

  @override
  String get winRate => 'معدل الفوز';

  @override
  String get berserkRate => 'معدل المخاطرة';

  @override
  String get performance => 'تقييم الأداء';

  @override
  String get tournamentComplete => 'إكتملت البطولة';

  @override
  String get movesPlayed => 'نقلات اللعب';

  @override
  String get whiteWins => 'فوز الأبيض';

  @override
  String get blackWins => 'فوز الأسود';

  @override
  String get drawRate => 'معدل التعادل';

  @override
  String get draws => 'تعادل';

  @override
  String nextXTournament(String param) {
    return 'بطولة ال $param التالية:';
  }

  @override
  String get averageOpponent => 'معدل الخصم';

  @override
  String get boardEditor => 'محرر الرقعة';

  @override
  String get setTheBoard => 'إعداد الرقعة';

  @override
  String get popularOpenings => 'إفتتاحيات شائعة';

  @override
  String get endgamePositions => 'وضعية نهاية المباراة';

  @override
  String chess960StartPosition(String param) {
    return 'وضعية بدأ Chess960 هي:$param';
  }

  @override
  String get startPosition => 'وضع البداية';

  @override
  String get clearBoard => 'رقعة بلا قطع';

  @override
  String get loadPosition => 'تحميل الوضع';

  @override
  String get isPrivate => 'خاص';

  @override
  String reportXToModerators(String param) {
    return 'بلغ الإدارة عن $param';
  }

  @override
  String profileCompletion(String param) {
    return 'اكتمال الملف الشخصي: $param';
  }

  @override
  String xRating(String param) {
    return 'تقييم $param';
  }

  @override
  String get ifNoneLeaveEmpty => 'إذا لم يوجد، أتركه فارغًا';

  @override
  String get profile => 'الملف الشخصي';

  @override
  String get editProfile => 'حرر الملف الشخصي';

  @override
  String get firstName => 'الاسم الأول';

  @override
  String get lastName => 'اسم العائلة';

  @override
  String get setFlair => 'اختيار الشارة';

  @override
  String get flair => 'الشارة';

  @override
  String get youCanHideFlair => 'يستخدم هذا الإعداد لإخفاء جميع شارات المستخدمين في الموقع.';

  @override
  String get biography => 'نبذة عنك';

  @override
  String get countryRegion => 'البلد أو المنطقة';

  @override
  String get thankYou => 'شكرًا لك!';

  @override
  String get socialMediaLinks => 'روابط وسائل التواصل الاجتماعي';

  @override
  String get oneUrlPerLine => 'رابط واحد لكل سطر';

  @override
  String get inlineNotation => 'تنسيق التدوين';

  @override
  String get makeAStudy => 'للحفظ الآمن و المشاركة، يمكنك إنشاء دراسة.';

  @override
  String get clearSavedMoves => 'مسح النقلات';

  @override
  String get previouslyOnLichessTV => 'سابقاً على تلفاز ليتشيس';

  @override
  String get onlinePlayers => 'لاعبون متصلون';

  @override
  String get activePlayers => 'لاعبون نشطون';

  @override
  String get bewareTheGameIsRatedButHasNoClock => 'كن على حذر, هذه المباراة مقيمة وبدون توقيت!';

  @override
  String get success => 'تم بنجاح';

  @override
  String get automaticallyProceedToNextGameAfterMoving => 'الإنتقال تلقائيًا للمباراة التالية بعد النقل';

  @override
  String get autoSwitch => 'تبديل تلقائي';

  @override
  String get puzzles => 'الألغاز';

  @override
  String get onlineBots => 'Online bots';

  @override
  String get name => 'الاسم';

  @override
  String get description => 'الوصف';

  @override
  String get descPrivate => 'وصف خاص';

  @override
  String get descPrivateHelp => 'هذا النص سيراه فقط أعضاء الفريق. في حالة ضبطه، سيحل محل الوصف العام لأعضاء الفريق.';

  @override
  String get no => 'لا';

  @override
  String get yes => 'نعم';

  @override
  String get help => 'مساعدة:';

  @override
  String get createANewTopic => 'إنشاء موضوع جديد';

  @override
  String get topics => 'المواضيع';

  @override
  String get posts => 'المنشورات';

  @override
  String get lastPost => 'آخر منشور';

  @override
  String get views => 'المشاهدات';

  @override
  String get replies => 'الردود';

  @override
  String get replyToThisTopic => 'الرد على هذا الموضوع';

  @override
  String get reply => 'الرد';

  @override
  String get message => 'رسالة';

  @override
  String get createTheTopic => 'إنشاء الموضوع';

  @override
  String get reportAUser => 'الإبلاغ عن مستخدم';

  @override
  String get user => 'المستخدم';

  @override
  String get reason => 'السبب';

  @override
  String get whatIsIheMatter => 'ما الأمر؟';

  @override
  String get cheat => 'غش';

  @override
  String get insult => 'إهانة';

  @override
  String get troll => 'إزعاج';

  @override
  String get ratingManipulation => 'تلاعب بالتقييم';

  @override
  String get other => 'أخرى';

  @override
  String get reportDescriptionHelp => 'الصق رابط المباراة (المباريات) واشرح بالتفصيل المشكلة في تصرف هذا المستحدم. لا تقل فقط \"انهم يغشون\"، ولكن اشرح لنا سبب استنتاجك. سيكون الرد أسرع إن كتبت بالإنكليزية.';

  @override
  String get error_provideOneCheatedGameLink => 'برجاء تقديم رابط واحد علي الأقل لمباراة حدث فيها غش.';

  @override
  String by(String param) {
    return 'كتبها $param';
  }

  @override
  String importedByX(String param) {
    return 'استيراد \'$param\'';
  }

  @override
  String get thisTopicIsNowClosed => 'هذا الموضوع مغلق الآن.';

  @override
  String get blog => 'المدونة';

  @override
  String get notes => 'ملاحظات';

  @override
  String get typePrivateNotesHere => 'اكتب الملاحظات الخاصة هنا';

  @override
  String get writeAPrivateNoteAboutThisUser => 'كتابة ملاحظة خاصة عن هذا المستخدم';

  @override
  String get noNoteYet => 'لا يوجد ملاحظة بعد';

  @override
  String get invalidUsernameOrPassword => 'اسم المستخدم خطأ أو كلمة المرور غير صحيحة';

  @override
  String get incorrectPassword => 'كلمة المرور غير صحيحة';

  @override
  String get invalidAuthenticationCode => 'رمز مصادقة غير صحيح';

  @override
  String get emailMeALink => 'أرسل لي الرابط بالبريد الإلكتروني';

  @override
  String get currentPassword => 'كلمة المرور الحالية';

  @override
  String get newPassword => 'كلمة المرور الجديدة';

  @override
  String get newPasswordAgain => 'كلمة المرور الجديدة (مرة أخرى)';

  @override
  String get newPasswordsDontMatch => 'كلمتا المرور الجديدتين غير متطابقتين';

  @override
  String get newPasswordStrength => 'قوة كلمة المرور';

  @override
  String get clockInitialTime => 'الوقت الأولي للساعة';

  @override
  String get clockIncrement => 'زيادة الساعة';

  @override
  String get privacy => 'الخصوصية';

  @override
  String get privacyPolicy => 'سياسة الخصوصية';

  @override
  String get letOtherPlayersFollowYou => 'اسمح للاعبين الآخرين بمتابعتك';

  @override
  String get letOtherPlayersChallengeYou => 'اسمح للاعبين الآخرين بتحديك';

  @override
  String get letOtherPlayersInviteYouToStudy => 'اسمح للاعبين الآخرين بدعوتك لدراسة';

  @override
  String get sound => 'الصوت';

  @override
  String get none => 'بدون';

  @override
  String get fast => 'سريع';

  @override
  String get normal => 'عادي';

  @override
  String get slow => 'بطيء';

  @override
  String get insideTheBoard => 'داخل الرقعة';

  @override
  String get outsideTheBoard => 'خارج الرقعة';

  @override
  String get onSlowGames => 'في المباريات البطيئة';

  @override
  String get always => 'دائماً';

  @override
  String get never => 'إطلاقا';

  @override
  String xCompetesInY(String param1, String param2) {
    return '$param1 تنافس في $param2';
  }

  @override
  String get victory => 'أحسنت!';

  @override
  String get defeat => 'هزيمة';

  @override
  String victoryVsYInZ(String param1, String param2, String param3) {
    return '$param1 ضد $param2 في $param3';
  }

  @override
  String defeatVsYInZ(String param1, String param2, String param3) {
    return '$param1 ضد $param2 في $param3';
  }

  @override
  String drawVsYInZ(String param1, String param2, String param3) {
    return '$param1 ضد $param2 في $param3';
  }

  @override
  String get timeline => 'الجدول الزمني';

  @override
  String get starting => 'تبدأ في:';

  @override
  String get allInformationIsPublicAndOptional => 'كل المعلومات متاحة للجميع وهي اختيارية.';

  @override
  String get biographyDescription => 'تحدّث عن نفسك، عن اهتماماتك ما تحب في الشطرنج، افتتاحياتك المفضلة، المباريات، اللاعبون...';

  @override
  String get listBlockedPlayers => 'اسرد اللاعبين الذين حظرتهم';

  @override
  String get human => 'إنسان';

  @override
  String get computer => 'حاسب';

  @override
  String get side => 'الجهة';

  @override
  String get clock => 'الوقت';

  @override
  String get opponent => 'الخصم';

  @override
  String get learnMenu => 'تعلم';

  @override
  String get studyMenu => 'دراسة';

  @override
  String get practice => 'تدريب';

  @override
  String get community => 'المجتمع';

  @override
  String get tools => 'أدوات';

  @override
  String get increment => 'الزيادة';

  @override
  String get error_unknown => 'بيانات خاطئة';

  @override
  String get error_required => 'هذة الخانة ضرورية';

  @override
  String get error_email => 'هذا البريد الإلكتروني غير صحبح';

  @override
  String get error_email_acceptable => 'هذا البريد الالكتروني غير مقبول. رجاءً تحقق منه مرة أخرى و حاول مرة ثانية.';

  @override
  String get error_email_unique => 'هذا البريد الالكتروني غير صالح أو مأخوذ من قبل';

  @override
  String get error_email_different => 'هذا بالفعل بريدك الالكتروني';

  @override
  String error_minLength(String param) {
    return 'الحد الأدنى للطول هو$param';
  }

  @override
  String error_maxLength(String param) {
    return 'حد الطول الأقصى هو $param';
  }

  @override
  String error_min(String param) {
    return 'يجب أن يكون أكبر أو يساوي ل $param';
  }

  @override
  String error_max(String param) {
    return 'يجب أن يكون أقل أو يساوي $param';
  }

  @override
  String ifRatingIsPlusMinusX(String param) {
    return '± $param اذا التقييم';
  }

  @override
  String get ifRegistered => 'قيد التسجيل';

  @override
  String get onlyExistingConversations => 'المحادثات الحالية فقط';

  @override
  String get onlyFriends => 'الأصدقاء فقط';

  @override
  String get menu => 'القائمة';

  @override
  String get castling => 'تبييت';

  @override
  String get whiteCastlingKingside => 'تبييت قصير للأبيض';

  @override
  String get blackCastlingKingside => 'تبييت قصير للأسود';

  @override
  String tpTimeSpentPlaying(String param) {
    return 'الوقت المقضي في اللعب:  $param';
  }

  @override
  String get watchGames => 'شاهد الألعاب';

  @override
  String tpTimeSpentOnTV(String param) {
    return 'الوقت في المشاهدة:  $param';
  }

  @override
  String get watch => 'شاهد';

  @override
  String get videoLibrary => 'مكتبة الفيديو';

  @override
  String get streamersMenu => 'ﻻعبو البث المباشر';

  @override
  String get mobileApp => 'تطبيق الجوال';

  @override
  String get webmasters => 'مدراء المواقع';

  @override
  String get about => 'عن';

  @override
  String aboutX(String param) {
    return 'عن $param';
  }

  @override
  String xIsAFreeYLibreOpenSourceChessServer(String param1, String param2) {
    return '$param1 هو ($param2) خادم شطرنج مجاني، حر، بدون إعلانات، مفتوح المصدر.';
  }

  @override
  String get really => 'حقاً';

  @override
  String get contribute => 'ساهم';

  @override
  String get termsOfService => 'شروط الخدمة';

  @override
  String get sourceCode => 'الكود المصدر';

  @override
  String get simultaneousExhibitions => 'معارض التزامنيات';

  @override
  String get host => 'المضيف';

  @override
  String hostColorX(String param) {
    return 'لون المضيف: $param';
  }

  @override
  String get yourPendingSimuls => 'مبارياتك المعلقة';

  @override
  String get createdSimuls => 'تزامنيات مُنشأة حديثاً';

  @override
  String get hostANewSimul => 'استضف تزامنية جديدة';

  @override
  String get signUpToHostOrJoinASimul => 'سجل لاستضافة أو الانضمام إلى محاكاة';

  @override
  String get noSimulFound => 'التزامنية غير موجودة';

  @override
  String get noSimulExplanation => 'معرض هذه التزامنية غير موجود.';

  @override
  String get returnToSimulHomepage => 'العودة لصفحة التزامنية';

  @override
  String get aboutSimul => 'التزامنيات هي لاعب واحد يواجه عدة خصوم في وقت واحد.';

  @override
  String get aboutSimulImage => 'مع 50 خصماً, فاز فيشر بـ 47 مباراة, تعادل في اثنتين, وخسر واحدة.';

  @override
  String get aboutSimulRealLife => 'تم أخذ مفهوم التزامنيات من أحداث الحياة الواقعية. حيث ينتقل المضيف من طاولة لأخرى للعب.';

  @override
  String get aboutSimulRules => 'عندما تبدأ التزامنية، يبدأ كل لاعب مباراة مع المضيف، حيث يلعب المضيف بالقطع البيضاء. تنتهي التزامنية بإنتهاء جميع المبارايات.';

  @override
  String get aboutSimulSettings => 'التزامنيات دائما عفوية. لا يمكن استرجاع النقلات، أضافة الوقت، او حتى طلب لعبة أخرى.';

  @override
  String get create => 'ابدأ';

  @override
  String get whenCreateSimul => 'عندما تنشئ تزامنية، يمكنك اللعب مع عدة لاعبين في الوقت ذاته.';

  @override
  String get simulVariantsHint => 'إذا اخترت عدة أنواع, كل لاعب يمكنه اختيار النوع الذي يريد.';

  @override
  String get simulClockHint => 'ضبط توقيت بالزيادة . كلما زاد عدد اللاعبين كلما احتجت لوقت أطول.';

  @override
  String get simulAddExtraTime => 'يمكنك زيادة الوقت لساعتك للمساعدة في التزامنية.';

  @override
  String get simulHostExtraTime => 'التوقيت الإضافي لساعة المضيف';

  @override
  String get simulAddExtraTimePerPlayer => 'أضف وقتًا ابتدائيًا إلى ساعتك لكل لاعب ينضم إلى المحاكاة.';

  @override
  String get simulHostExtraTimePerPlayer => 'استضافة وقت إضافيًا لكل لاعب';

  @override
  String get lichessTournaments => 'مسابقات الموقع';

  @override
  String get tournamentFAQ => 'مسابقة الساحة (الأسئلة الشائعة)';

  @override
  String get timeBeforeTournamentStarts => 'الوقت حتى بداية المسابقة';

  @override
  String get averageCentipawnLoss => 'معدل الخسارة مقيمة ب 0.01 بيدق';

  @override
  String get accuracy => 'الدقة';

  @override
  String get keyboardShortcuts => 'اختصارات لوحة المفاتيح';

  @override
  String get keyMoveBackwardOrForward => 'تحرك للخلف/للأمام';

  @override
  String get keyGoToStartOrEnd => 'اذهب للبداية/للنهاية';

  @override
  String get keyCycleSelectedVariation => 'التفريع المحدد';

  @override
  String get keyShowOrHideComments => 'أظهر/أخفِ التعليقات';

  @override
  String get keyEnterOrExitVariation => 'متغير دخول/خروج';

  @override
  String get keyRequestComputerAnalysis => 'اطلب تحليل الحاسوب وتعلم من أخطائك';

  @override
  String get keyNextLearnFromYourMistakes => 'التالي (تعلم من أخطائك)';

  @override
  String get keyNextBlunder => 'الخطأ الفادح التالي';

  @override
  String get keyNextMistake => 'الخطأ التالي';

  @override
  String get keyNextInaccuracy => 'النقلة غير الدقيقة التالية';

  @override
  String get keyPreviousBranch => 'التفريع السابق';

  @override
  String get keyNextBranch => 'التفريع القادم';

  @override
  String get toggleVariationArrows => 'تبديل أسهم النقلات المرشحة';

  @override
  String get cyclePreviousOrNextVariation => 'الدورة السابقة/التفريع التالي';

  @override
  String get toggleGlyphAnnotations => 'تبديل الرموز التوضيحية';

  @override
  String get togglePositionAnnotations => 'Toggle position annotations';

  @override
  String get variationArrowsInfo => 'أسمهم النقلات تسمح لك بلعبها دون استخدام قائمة النقلات المرشحة.';

  @override
  String get playSelectedMove => 'لعب النقلة المحددة';

  @override
  String get newTournament => 'مسابقة جديدة';

  @override
  String get tournamentHomeTitle => 'مسابقات بانواع شطرنج مختلفة وساعات مختلفة';

  @override
  String get tournamentHomeDescription => 'العب مسابقات شطرنج بكل السرعات. انضم للمسابقات الرسمية المجدولة، أو ابدأ مسابقاتك الخاصة.';

  @override
  String get tournamentNotFound => 'المسابقة غير موجودة';

  @override
  String get tournamentDoesNotExist => 'هذه المسابقة غير موجودة';

  @override
  String get tournamentMayHaveBeenCanceled => 'إذا غادر جميع اللاعبين قبل بداية المسابقة قإنها تُلغى';

  @override
  String get returnToTournamentsHomepage => 'الرجوع إلى المسابقات';

  @override
  String weeklyPerfTypeRatingDistribution(String param) {
    return 'توزيع التقييم الأسبوعي لـ $param';
  }

  @override
  String yourPerfTypeRatingIsRating(String param1, String param2) {
    return 'تقييمك في $param1 هو $param2.';
  }

  @override
  String youAreBetterThanPercentOfPerfTypePlayers(String param1, String param2) {
    return 'أنت أفضل من $param1 من $param2 لاعب.';
  }

  @override
  String userIsBetterThanPercentOfPerfTypePlayers(String param1, String param2, String param3) {
    return '$param1 أنت أفضل من $param2 من $param3 اللاعبين.';
  }

  @override
  String betterThanPercentPlayers(String param1, String param2) {
    return 'أفضل من $param1 بالمائة من لاعبي الشطرنج $param2';
  }

  @override
  String youDoNotHaveAnEstablishedPerfTypeRating(String param) {
    return 'ليس لديك تقييم ثابت في $param.';
  }

  @override
  String get yourRating => 'تقييمك';

  @override
  String get cumulative => 'جمعا';

  @override
  String get glicko2Rating => 'نظام تقييم Glicko-2';

  @override
  String get checkYourEmail => 'تحقق من بريدك الإلكتروني';

  @override
  String get weHaveSentYouAnEmailClickTheLink => 'أرسلنا رسالة لبريدك الإلكتروني. فضلا اضغط الرابط فيها لتفعيل حسابك';

  @override
  String get ifYouDoNotSeeTheEmailCheckOtherPlaces => 'إذا لم تجد الرسالة، فابحث عنها في المهملات أو في مجلد spam';

  @override
  String weHaveSentYouAnEmailTo(String param) {
    return 'ارسلنا رسالة إلى $param. اضغط على الرابط فيها لإعادة تعيين كلمة المرور.';
  }

  @override
  String byRegisteringYouAgreeToBeBoundByOur(String param) {
    return 'بتسجيلك في الموقع فانت توافق على شروطنا $param';
  }

  @override
  String readAboutOur(String param) {
    return 'اقرأ عن $param.';
  }

  @override
  String get networkLagBetweenYouAndLichess => 'تأخر الاتصال بينك وبيننا';

  @override
  String get timeToProcessAMoveOnLichessServer => 'الوفت المطلوب لتنفيذ النقلة على الخادم';

  @override
  String get downloadAnnotated => 'تحميل مع الشرح';

  @override
  String get downloadRaw => 'تحميل بدون الشرح';

  @override
  String get downloadImported => 'تحميل المستورد';

  @override
  String get crosstable => 'تاريخ';

  @override
  String get youCanAlsoScrollOverTheBoardToMoveInTheGame => 'يمكنك استخدام الزر الاوسط للفأرة على الرقعة لتنفيذ حركة من الدور.';

  @override
  String get scrollOverComputerVariationsToPreviewThem => 'مرر فوق المتغييرات لاستعراضها.';

  @override
  String get analysisShapesHowTo => 'استخدم ز الفأرة الأيمن لرسم دوائر وأسهم على الرقعة';

  @override
  String get letOtherPlayersMessageYou => 'السماح للاعبين بمراسلتك';

  @override
  String get receiveForumNotifications => 'تلقى الإشعارات في حال تمت الإشارة إليك في المنتدى';

  @override
  String get shareYourInsightsData => 'شارك بيانات طريقة لعبك';

  @override
  String get withNobody => 'وحدك';

  @override
  String get withFriends => 'مع الأصدقاء';

  @override
  String get withEverybody => 'مع الجميع';

  @override
  String get kidMode => 'موقع الأطفال';

  @override
  String get kidModeIsEnabled => 'وضع الطفل مفعل.';

  @override
  String get kidModeExplanation => 'هذا يتعلق بالأمان. في نمط الطفل، يتم تعطيل كافة اتصالات المواقع. تمكين هذا للأطفال والطلاب، لحمايتهم من مستخدمي الإنترنت الأخرين.';

  @override
  String inKidModeTheLichessLogoGetsIconX(String param) {
    return 'في نمط الطفل، يكون لشعار ليتشيس رمز $param، لكي تعرف أن أطفالك آمنين.';
  }

  @override
  String get askYourChessTeacherAboutLiftingKidMode => 'يتم إدارة حسابك. اسأل معلم الشطرنج الخاص بك عن رفع وضع الطفل.';

  @override
  String get enableKidMode => 'تمكين نمط الطفل';

  @override
  String get disableKidMode => 'تعطيل نمط الطفل';

  @override
  String get security => 'الأمان';

  @override
  String get sessions => 'جلسات';

  @override
  String get revokeAllSessions => 'إلغاء كافة جلسات العمل';

  @override
  String get playChessEverywhere => 'العب الشطرنج فى كل مكان';

  @override
  String get asFreeAsLichess => 'مجاني';

  @override
  String get builtForTheLoveOfChessNotMoney => 'تم بناؤه حباً في الشطرنج, وليس المال :)';

  @override
  String get everybodyGetsAllFeaturesForFree => 'كل المميزات لكل الأعضاء مجاناً';

  @override
  String get zeroAdvertisement => 'لا دعايات';

  @override
  String get fullFeatured => 'كل المميزات';

  @override
  String get phoneAndTablet => 'للجوالات والأجهزة اللوحية';

  @override
  String get bulletBlitzClassical => 'بالتوقيت المفضل لك';

  @override
  String get correspondenceChess => 'شطرنج بالمراسلة';

  @override
  String get onlineAndOfflinePlay => 'على الإنترنت أو بدون اتصال';

  @override
  String get viewTheSolution => 'الحل';

  @override
  String get followAndChallengeFriends => 'تابع وتحدى أصدقاءك';

  @override
  String get gameAnalysis => 'تحليل المباراة';

  @override
  String xHostsY(String param1, String param2) {
    return '$param1 يستضيف $param2';
  }

  @override
  String xJoinsY(String param1, String param2) {
    return '$param1 إنضم ل $param2';
  }

  @override
  String xLikesY(String param1, String param2) {
    return '$param1 أعجب ب $param2';
  }

  @override
  String get quickPairing => 'مزاوجة سريعة';

  @override
  String get lobby => 'الصالة';

  @override
  String get anonymous => 'مجهول';

  @override
  String yourScore(String param) {
    return 'نقاطك: $param';
  }

  @override
  String get language => 'اللغة';

  @override
  String get background => 'الخلفية';

  @override
  String get light => 'فاتح';

  @override
  String get dark => 'داكن';

  @override
  String get transparent => 'شفّاف';

  @override
  String get deviceTheme => 'مظهر الجهاز';

  @override
  String get backgroundImageUrl => 'رابط صورة الخلفية:';

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
  String get pieceSet => 'مجموعة القطع';

  @override
  String get embedInYourWebsite => 'تضمين في موقع الويب الخاص بك';

  @override
  String get usernameAlreadyUsed => 'اسم المستخدم الذي اخترته موجود بالفعل، الرجاء كتابة اسم آخر.';

  @override
  String get usernamePrefixInvalid => 'اسم المستخدم يجب أن يبدأ بحرف.';

  @override
  String get usernameSuffixInvalid => 'اسم المستخدم يجب أن ينتهي بحرف أو رقم.';

  @override
  String get usernameCharsInvalid => 'اسم المستخدم يجب أن يحتوي فقط على حروف وأرقام،خط سفلي ، والواصلات.';

  @override
  String get usernameUnacceptable => 'اسم المستخدم هذا غير مقبول.';

  @override
  String get playChessInStyle => 'لعب الشطرنج في نمط';

  @override
  String get chessBasics => 'أساسيات الشطرنج';

  @override
  String get coaches => 'المدربين';

  @override
  String get invalidPgn => 'ملف بي جي ان غير صالح';

  @override
  String get invalidFen => 'FEN غير صالح';

  @override
  String get custom => 'مخصص';

  @override
  String get notifications => 'إشعارات';

  @override
  String notificationsX(String param1) {
    return 'الإشعارات $param1';
  }

  @override
  String perfRatingX(String param) {
    return 'التقييم: $param';
  }

  @override
  String get practiceWithComputer => 'الممارسة مع الكمبيوتر';

  @override
  String anotherWasX(String param) {
    return 'نقلة أخرى $param';
  }

  @override
  String bestWasX(String param) {
    return 'النقلة الأفضل هي $param';
  }

  @override
  String get youBrowsedAway => 'تصفحت نقلات مختلفة';

  @override
  String get resumePractice => 'استئناف التدريب';

  @override
  String get drawByFiftyMoves => 'تم حسم هذا المباراة بالتعادل حسب قاعدة الخمسين حركة.';

  @override
  String get theGameIsADraw => 'المباراة تعادل.';

  @override
  String get computerThinking => 'الكمبيوتر يفكر ...';

  @override
  String get seeBestMove => 'شاهد افضل نقلة';

  @override
  String get hideBestMove => 'أخفي أفضل نقلة';

  @override
  String get getAHint => 'احصل على تلميح';

  @override
  String get evaluatingYourMove => 'يتم الان تقييم نقلتك ...';

  @override
  String get whiteWinsGame => 'الأبيض يفوز';

  @override
  String get blackWinsGame => 'الاسود يفوز';

  @override
  String get learnFromYourMistakes => 'التعلم من الأخطاء الخاصة بك';

  @override
  String get learnFromThisMistake => 'تعلم من هذا الخطأ';

  @override
  String get skipThisMove => 'تجاوز هذه الخطوة';

  @override
  String get next => 'التالي';

  @override
  String xWasPlayed(String param) {
    return 'تم لعب $param';
  }

  @override
  String get findBetterMoveForWhite => 'جد نقلة أفضل للأبيض';

  @override
  String get findBetterMoveForBlack => 'جد نقلة أفضل للأسود';

  @override
  String get resumeLearning => 'استئناف التعلم';

  @override
  String get youCanDoBetter => 'يمكنك أن تفعل أفضل';

  @override
  String get tryAnotherMoveForWhite => 'حاول نقلة أخرى للأبيض';

  @override
  String get tryAnotherMoveForBlack => 'حاول نقلة أخرى للأسود';

  @override
  String get solution => 'الحل';

  @override
  String get waitingForAnalysis => 'بإنتظار انتهاء التحليل';

  @override
  String get noMistakesFoundForWhite => 'لم يتم ايجاد أي خطأ للأبيض';

  @override
  String get noMistakesFoundForBlack => 'لم يتم ايجاد أي خطأ للأسود';

  @override
  String get doneReviewingWhiteMistakes => 'تم الإنتهاء من مراجعة أخطاء الأبيض';

  @override
  String get doneReviewingBlackMistakes => 'تم الإنتهاء من مراجعة أخطاء الأسود';

  @override
  String get doItAgain => 'قم بذلك مرة اخرى';

  @override
  String get reviewWhiteMistakes => 'مراجعة أخطاء الأبيض';

  @override
  String get reviewBlackMistakes => 'مراجعة أخطاء الأسود';

  @override
  String get advantage => 'الأفضلية';

  @override
  String get opening => 'افتتاحية';

  @override
  String get middlegame => 'جزء منتصف اللعبة';

  @override
  String get endgame => 'جزء نهاية اللعبة';

  @override
  String get conditionalPremoves => 'تحريكات شرطية';

  @override
  String get addCurrentVariation => 'إضافة تنويعة حالية';

  @override
  String get playVariationToCreateConditionalPremoves => 'إلعب تفريع لإنشاء نقلة مسبقة مشروطة';

  @override
  String get noConditionalPremoves => 'لا توجد نقلات استباقية مشروطة';

  @override
  String playX(String param) {
    return 'إلعب $param';
  }

  @override
  String get showUnreadLichessMessage => 'تسلّمتَ رسالة خاصة من ليتشيس.';

  @override
  String get clickHereToReadIt => 'اضغط هنا بمتابعة القراءة';

  @override
  String get sorry => 'نأسف :(';

  @override
  String get weHadToTimeYouOutForAWhile => 'اضطررنا إلى حظرك لفترة قصيرة.';

  @override
  String get why => 'لماذا ؟';

  @override
  String get pleasantChessExperience => 'نحن نهدف الى توفير تجربة شطرنج ممتعة للجميع.';

  @override
  String get goodPractice => 'لهذا الغرض، علينا التأكد أن جميع اللاعبين يسلكون سلوكاً حسناً.';

  @override
  String get potentialProblem => 'عند اكتشاف مشكلة محتملة، نعرض هذه الرسالة.';

  @override
  String get howToAvoidThis => 'كيفية تجنب حدوث هذا ؟';

  @override
  String get playEveryGame => 'العب كل دور تبدأه.';

  @override
  String get tryToWin => 'حاول فوز (او تعادل على الأقل) كل دور تلعبه.';

  @override
  String get resignLostGames => 'انسحب اذا كنت على وشك الهزيمة (لا تدع الوقت ينتهي).';

  @override
  String get temporaryInconvenience => 'نعتذر عن الازعاج المؤقت';

  @override
  String get wishYouGreatGames => 'ونتمنى لك ادوار جيدة على Lichess.org.';

  @override
  String get thankYouForReading => 'نشكرك على القراءة!';

  @override
  String get lifetimeScore => 'النتيجة النهائية';

  @override
  String get currentMatchScore => 'نتيجة المباراة الحالية';

  @override
  String get agreementAssistance => 'أوافق على أني لن أتلقى أي مساعدة خلال مبارياتي أبدا (من محرك شطرنج أو كتاب أو قاعدة بيانات أو شخص اخر).';

  @override
  String get agreementNice => 'أؤكد أنني سأعامل اللاعبين الآخرين بكل احترام.';

  @override
  String agreementMultipleAccounts(String param) {
    return 'أوافق على أني لن أدخل بحسابات متعددة (إلا للأسباب المذكورة في $param).';
  }

  @override
  String get agreementPolicy => 'أوافق على أني سأتبع سياسات الموقع.';

  @override
  String get searchOrStartNewDiscussion => 'البحث أو بدء محادثة جديدة';

  @override
  String get edit => 'تعديل';

  @override
  String get bullet => 'الرصاصة';

  @override
  String get blitz => 'الخاطف';

  @override
  String get rapid => 'السريع';

  @override
  String get classical => 'تقليدي';

  @override
  String get ultraBulletDesc => 'مباراةٌ جنونية السرعة: أقل من ثلاثين ثانية';

  @override
  String get bulletDesc => 'مباراةٌ سريعةٌ جداً: أقل من ٣ دقائق';

  @override
  String get blitzDesc => 'مبارياتٌ خاطفة: ٣ - ٨ دقائق';

  @override
  String get rapidDesc => 'مباريات سريعة: ٨-٢٥ دقائق';

  @override
  String get classicalDesc => 'مبارياتٌ كلاسيكيةٌ: ٢٥ دقيقة و أكثر';

  @override
  String get correspondenceDesc => 'ألعاب المراسلة: يوم أو عدة أيام لكل نقلة';

  @override
  String get puzzleDesc => 'مدرب تكتيكات الشطرنج';

  @override
  String get important => 'مهم';

  @override
  String yourQuestionMayHaveBeenAnswered(String param1) {
    return 'قد يكون سؤالك مجاوب $param1';
  }

  @override
  String get inTheFAQ => 'فى صفحة الأسإلة المتكررة.';

  @override
  String toReportSomeoneForCheatingOrBadBehavior(String param1) {
    return 'للإبلاغ عن مستخدم بسبب الغش أو السلوك السيئ، $param1';
  }

  @override
  String get useTheReportForm => 'إستخدم نموذج التبليغ';

  @override
  String toRequestSupport(String param1) {
    return 'لطلب الدعم، $param1';
  }

  @override
  String get tryTheContactPage => 'جرب صفحة الإتصال';

  @override
  String makeSureToRead(String param1) {
    return 'تحقق من قراءة $param1';
  }

  @override
  String get theForumEtiquette => 'آداب المنتدى';

  @override
  String get thisTopicIsArchived => 'تم أرشفة هذا الموضوع ولم يعد يمكن الرد عليه.';

  @override
  String joinTheTeamXToPost(String param1) {
    return 'انضم إلى $param1، للمشاركة في هذا المنتدى';
  }

  @override
  String teamNamedX(String param1) {
    return 'فريق $param1';
  }

  @override
  String get youCannotPostYetPlaySomeGames => 'لا يمكنك النشر في المنتديات حتى الآن. إلعب بعض المباريات!';

  @override
  String get subscribe => 'اشترك';

  @override
  String get unsubscribe => 'إلغاء الإشتراك';

  @override
  String mentionedYouInX(String param1) {
    return 'ذكرك في \"$param1\".';
  }

  @override
  String xMentionedYouInY(String param1, String param2) {
    return '$param1 قد ذكرك في \"$param2\".';
  }

  @override
  String invitedYouToX(String param1) {
    return 'دعاك إلى \"$param1\".';
  }

  @override
  String xInvitedYouToY(String param1, String param2) {
    return '$param1 قد دعاك إلى \"$param2\".';
  }

  @override
  String get youAreNowPartOfTeam => 'أنت الآن عضو في الفريق.';

  @override
  String youHaveJoinedTeamX(String param1) {
    return 'لقد انضممت إلى \"$param1\".';
  }

  @override
  String get someoneYouReportedWasBanned => 'شخص قد أبلغت عنه تم حظره';

  @override
  String get congratsYouWon => 'تهانينا، لقد فزت!';

  @override
  String gameVsX(String param1) {
    return 'مباراة ضد $param1';
  }

  @override
  String resVsX(String param1, String param2) {
    return '$param1 ضد $param2';
  }

  @override
  String get lostAgainstTOSViolator => 'لقد خسرت أمام شخص قد انتهك شروط خدمة Lichess';

  @override
  String refundXpointsTimeControlY(String param1, String param2) {
    return 'استعادة: $param1 نقطة تقييم، تصنيف $param2.';
  }

  @override
  String get timeAlmostUp => 'أوشك الوقت على الإنتهاء!';

  @override
  String get clickToRevealEmailAddress => '[انقر للكشف عن عنوان البريد الإلكتروني]';

  @override
  String get download => 'تحميل';

  @override
  String get coachManager => 'مدير المدرب';

  @override
  String get streamerManager => 'مدير البث';

  @override
  String get cancelTournament => 'الغاء البطولة';

  @override
  String get tournDescription => 'وصف البطولة';

  @override
  String get tournDescriptionHelp => 'هل تريد إخبار أي شيء مميز للمشاركين؟ حاول أن تبقيه قصيرة. روابط Markdown متوفرة: [name](https://url)';

  @override
  String get ratedFormHelp => 'المباريات مصنفة\nوتأثر على تقييم اللاعبين';

  @override
  String get onlyMembersOfTeam => 'اعضاء الفريق فقط';

  @override
  String get noRestriction => 'لا قيود';

  @override
  String get minimumRatedGames => 'الحد الأدنى للالعاب المصنفة';

  @override
  String get minimumRating => 'أقل تصنيف';

  @override
  String get maximumWeeklyRating => 'الحد الاقصى للتصنيف الاسبوعي';

  @override
  String positionInputHelp(String param) {
    return 'لصق FEN صالح لبدء كل لعبة من موقع معين.\nإنه يعمل فقط للألعاب العادية، وليس مع المتغيرات.\nيمكنك استخدام $param لإنشاء موضع FEN، ثم لصقه هنا.\nاتركه فارغاً لبدء الألعاب من الوضع الأولي العادي.';
  }

  @override
  String get cancelSimul => 'ابطال المباراة الجماعية';

  @override
  String get simulHostcolor => 'لون المضيف لكل لعبة';

  @override
  String get estimatedStart => 'الوقت المتوقع للبدأ';

  @override
  String simulFeatured(String param) {
    return 'ميزة في $param';
  }

  @override
  String simulFeaturedHelp(String param) {
    return 'إظهار التبسيط الخاص بك للجميع في $param. تعطيل للمحاكاة الخاصة.';
  }

  @override
  String get simulDescription => 'وصف المباراة الجماعية';

  @override
  String get simulDescriptionHelp => 'أي شيء تريد أن تخبره للمشاركين؟';

  @override
  String markdownAvailable(String param) {
    return '$param متاح لتركيبات الأكثر تطوراً.';
  }

  @override
  String get embedsAvailable => 'أضف رابط المباراة أو رابط الدراسة لإضافتها هنا.';

  @override
  String get inYourLocalTimezone => 'في منطقتك الزمنية المحلية';

  @override
  String get tournChat => 'دردشة البطولة';

  @override
  String get noChat => 'لا دردشة';

  @override
  String get onlyTeamLeaders => 'فقط قائدي الفريق';

  @override
  String get onlyTeamMembers => 'فقط لاعبي الفريق';

  @override
  String get navigateMoveTree => 'التنقل في لائحة النقلات';

  @override
  String get mouseTricks => 'حيل بالفأرة';

  @override
  String get toggleLocalAnalysis => 'تبديل تحليل الكمبيوتر المحلي';

  @override
  String get toggleAllAnalysis => 'تبديل كل تحليل الكمبيوتر';

  @override
  String get playComputerMove => 'العب افضل نقلة يقترحها الكمبيوتر';

  @override
  String get analysisOptions => 'خيارات التحليل';

  @override
  String get focusChat => 'تركيز';

  @override
  String get showHelpDialog => 'إظهار رسالة المساعدة هذه';

  @override
  String get reopenYourAccount => 'اعادة فتح حسابك';

  @override
  String get closedAccountChangedMind => 'إذا كنت قد أغلقت حسابك، و أبدلت رأيك، لديك فرصة واحدة لاستعادة الحساب.';

  @override
  String get onlyWorksOnce => 'سيعمل هذا لمرة واحدة فقط';

  @override
  String get cantDoThisTwice => 'إذا أغلقت حسابك مرة ثانية فليس من الممكن استعادة حسابك مرة أخرى.';

  @override
  String get emailAssociatedToaccount => 'البريد الالكتروني مربوط بالحساب';

  @override
  String get sentEmailWithLink => 'أرسالنا لك ايميل يحتوي على رابط.';

  @override
  String get tournamentEntryCode => 'رمز دخول البطولة';

  @override
  String get hangOn => 'انتظر!';

  @override
  String gameInProgress(String param) {
    return 'لديك مباراة جارية مع $param.';
  }

  @override
  String get abortTheGame => 'الغي المباراة';

  @override
  String get resignTheGame => 'انسحاب طوعي';

  @override
  String get youCantStartNewGame => 'لا يمكن أن تبدأ مباراة قبل الانتهاء من المباراة الحالية.';

  @override
  String get since => 'منذ';

  @override
  String get until => 'حتى';

  @override
  String get lichessDbExplanation => 'عينة من الألعاب المقيمة من جميع لاعبي Lichess';

  @override
  String get switchSides => 'تبديل جهة اللعب';

  @override
  String get closingAccountWithdrawAppeal => 'إغلاق حسابك سوف تخسر تقدمك';

  @override
  String get ourEventTips => 'نصائحنا لتنظيم الأحداث';

  @override
  String get instructions => 'التعليمات';

  @override
  String get showMeEverything => 'اظهر لي كل شيء';

  @override
  String get lichessPatronInfo => 'Lichess هو موقع خيري و مجاني بشكل كامل ومفتوح المصدر.\nكافة التكاليف التشغيلية و التطويرية و المحتوى يتم الحصول عليه من قبل تبرعات المستخدمين.';

  @override
  String get nothingToSeeHere => 'لا يوجد شيء يمكن رؤيته هنا في الوقت الحالي.';

  @override
  String opponentLeftCounter(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'لقد غادر خصمك اللعبة. يمكنك الفوز بعد $count ثانية.',
      many: 'لقد غادر خصمك اللعبة. يمكنك الفوز بعد $count ثانية.',
      few: 'لقد غادر خصمك اللعبة. يمكنك الفوز بعد $count ثانية.',
      two: 'لقد غادر خصمك اللعبة. يمكنك الفوز بعد ثانيتين.',
      one: 'لقد غادر خصمك اللعبة. يمكنك الفوز بعد ثانية.',
      zero: 'انسحب خصمك من المباراة. يمكنك المطالبة بالفوز في غضون $count ثانية.',
    );
    return '$_temp0';
  }

  @override
  String mateInXHalfMoves(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'كش مات في $count نقلة',
      many: 'كش مات في $count نقلة',
      few: 'مات في $count نصف-نقلة',
      two: 'مات في $count نصف-نقلة',
      one: 'مات في $count نصف-نقلة',
      zero: 'مات في $count نصف-نقلة',
    );
    return '$_temp0';
  }

  @override
  String nbBlunders(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count غلطات',
      many: '$count غلطات',
      few: '$count غلطات',
      two: '$count غلطة',
      one: '$count غلطة',
      zero: '$count غلطة',
    );
    return '$_temp0';
  }

  @override
  String nbMistakes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count أخطاء',
      many: '$count أخطاء',
      few: '$count أخطاء',
      two: '$count أخطاء',
      one: '$count خطأ',
      zero: '$count خطأ',
    );
    return '$_temp0';
  }

  @override
  String nbInaccuracies(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count غموض',
      many: '$count غموض',
      few: '$count غموض',
      two: '$count غموض',
      one: '$count غموض',
      zero: '$count غموض',
    );
    return '$_temp0';
  }

  @override
  String nbPlayers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count لاعب',
      many: '$count لاعبين',
      few: '$count لاعبين',
      two: '$count لاعب',
      one: '$count لاعب',
      zero: '$count لاعب',
    );
    return '$_temp0';
  }

  @override
  String nbGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count مباراة',
      many: '$count مباراة',
      few: '$count مباراة',
      two: '$count مباراة',
      one: '$count مباراة',
      zero: '$count مباراة',
    );
    return '$_temp0';
  }

  @override
  String ratingXOverYGames(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'التصنيف للشطرنج $count بعد $param2 مباراة',
      many: 'تصنيفك في $count بعد $param2 مباراة',
      few: 'تصنيفك في $count بعد $param2 مباراة',
      two: 'التصنيف للشطرنج $count بعد $param2 مباراتين',
      one: 'التصنيف للشطرنج $count بعد $param2 مباراة واحدة',
      zero: 'التصنيف للشطرنج $count بعد $param2 مباراة',
    );
    return '$_temp0';
  }

  @override
  String nbBookmarks(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count مباراة مفضلة',
      many: '$count مباراة مفضلة',
      few: '$count مباراة مفضلة',
      two: '$count مباراة مفضلة',
      one: '$count مباراة مفضلة',
      zero: '$count مباراة مفضلة',
    );
    return '$_temp0';
  }

  @override
  String nbDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count يوم',
      many: '$count يوم',
      few: '$count يوم',
      two: '$count يوم',
      one: '$count يوم',
      zero: '$count يوم',
    );
    return '$_temp0';
  }

  @override
  String nbHours(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ساعة',
      many: '$count ساعة',
      few: '$count ساعة',
      two: '$count ساعة',
      one: '$count ساعة',
      zero: '$count ساعة',
    );
    return '$_temp0';
  }

  @override
  String nbMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count دقيقة',
      many: '$count دقيقة',
      few: '$count دقيقة',
      two: '$count دقيقة',
      one: '$count دقائق',
      zero: '$count دقائق',
    );
    return '$_temp0';
  }

  @override
  String rankIsUpdatedEveryNbMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'يتم تحديث الترتيب كل $count دقيقة',
      many: 'يتم تحديث الترتيب كل $count دقيقة',
      few: 'يتم تحديث الترتيب كل $count دقائق',
      two: 'يتم تحديث الترتيب كل دقيقتين',
      one: 'يتم تحديث الترتيب كل دقيقة',
      zero: 'يتم تحديث الرتبة كل $count دقيقة',
    );
    return '$_temp0';
  }

  @override
  String nbPuzzles(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count لغز',
      many: '$count لغز',
      few: '$count ألغاز',
      two: '$count لغزان',
      one: '$count لغز',
      zero: '$count لغز',
    );
    return '$_temp0';
  }

  @override
  String nbGamesWithYou(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count مباراة معك',
      many: '$count مباراة معك',
      few: '$count مباراة معك',
      two: '$count مباراة معك',
      one: '$count مباراة معك',
      zero: '$count مباراة معك',
    );
    return '$_temp0';
  }

  @override
  String nbRated(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count مقيمة',
      many: '$count مقيمة',
      few: '$count مقيمة',
      two: '$count مقيمة',
      one: '$count مقيمة',
      zero: '$count مقيمة',
    );
    return '$_temp0';
  }

  @override
  String nbWins(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count فوز',
      many: '$count فوز',
      few: '$count فوز',
      two: '$count فوز',
      one: '$count فوز',
      zero: '$count فوز',
    );
    return '$_temp0';
  }

  @override
  String nbLosses(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count خسارة',
      many: '$count خسارة',
      few: '$count خسارة',
      two: '$count خسارة',
      one: '$count خسارة',
      zero: '$count خسارة',
    );
    return '$_temp0';
  }

  @override
  String nbDraws(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count تعادلات',
      many: '$count تعادل',
      few: '$count تعادلات',
      two: '$count تعادلات',
      one: '$count تعادل',
      zero: '$count تعادل',
    );
    return '$_temp0';
  }

  @override
  String nbPlaying(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count لعبت',
      many: '$count لعبت',
      few: '$count لعبت',
      two: '$count لعبت',
      one: '$count لعبت',
      zero: '$count لعبت',
    );
    return '$_temp0';
  }

  @override
  String giveNbSeconds(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'منح $count ثانية',
      many: 'منح $count ثانية',
      few: 'منح $count ثانية',
      two: 'منح $count ثانية',
      one: 'منح $count ثانية',
      zero: 'منح $count ثانية',
    );
    return '$_temp0';
  }

  @override
  String nbTournamentPoints(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'نقاط المسابقة $count',
      many: 'نقاط المسابقة $count',
      few: 'نقاط المسابقة $count',
      two: 'نقاط المسابقة $count',
      one: 'نقاط المسابقة $count',
      zero: 'نقاط المسابقة $count',
    );
    return '$_temp0';
  }

  @override
  String nbStudies(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count دراسة',
      many: '$count دراسات',
      few: '$count دراسة',
      two: '$count دراسة',
      one: '$count دراسة',
      zero: '$count دراسة',
    );
    return '$_temp0';
  }

  @override
  String nbSimuls(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count خَصم في الوقت نفسه',
      many: '$count خَصم في الوقت نفسه',
      few: '$count خصوم في الوقت نفسه',
      two: '$count خَصمان في الوقت نفسه',
      one: '$count خصم واحد',
      zero: '$count خصم',
    );
    return '$_temp0';
  }

  @override
  String moreThanNbRatedGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '≥ $count مباراة مقيمة',
      many: '≥ $count مباراة مقيمة',
      few: '≥ $count مباراة مقيمة',
      two: '≥ $count مباراة مقيمة',
      one: '≥ $count مباراة مقيمة',
      zero: '≥ $count مباراة مقيمة',
    );
    return '$_temp0';
  }

  @override
  String moreThanNbPerfRatedGames(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '≥ $count مباراة $param2 مقيمة',
      many: '≥ $count مباراة $param2 مقيمة',
      few: '≥ $count مباراة $param2 مقيمة',
      two: '≥ $count مباراة $param2 مقيمة',
      one: '≥ $count مباراة $param2 مقيمة',
      zero: '≥ $count مباراة $param2 مقيمة',
    );
    return '$_temp0';
  }

  @override
  String needNbMorePerfGames(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'يجب أن تلعب $count مباراة $param2 مقيمة إضافية',
      many: 'يجب أن تلعب $count مباراة $param2 مقيمة إضافية',
      few: 'يجب أن تلعب $count مباراة $param2 مقيمة إضافية',
      two: 'يجب أن تلعب $count مباراة $param2 مقيمة إضافية',
      one: 'يجب أن تلعب $count مباراة $param2 مقيمة إضافية',
      zero: 'يجب أن تلعب $count مباراة $param2 مقيمة إضافية',
    );
    return '$_temp0';
  }

  @override
  String needNbMoreGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'يجب أن تلعب $count مباراة مقيمة أخرى',
      many: 'يجب أن تلعب $count مباراة مقيمة أخرى',
      few: 'يجب أن تلعب $count مباراة مقيمة أخرى',
      two: 'يجب أن تلعب $count مباراة مقيمة أخرى',
      one: 'يجب أن تلعب $count مباراة مقيمة أخرى',
      zero: 'يجب أن تلعب $count مباراة مقيمة أخرى',
    );
    return '$_temp0';
  }

  @override
  String nbImportedGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'مباراة مستوردة $count',
      many: 'مباراة مستوردة $count',
      few: 'مباراة مستوردة $count',
      two: 'مباراة مستوردة $count',
      one: 'مباراة مستوردة $count',
      zero: 'مباراة مستوردة $count',
    );
    return '$_temp0';
  }

  @override
  String nbFriendsOnline(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count أصدقاء متصلون',
      many: '$count أصدقاء متصلون',
      few: '$count أصدقاء متصلون',
      two: '$count أصدقاء متصلون',
      one: '$count صديق متصل',
      zero: '$count أصدقاء متصلون',
    );
    return '$_temp0';
  }

  @override
  String nbFollowers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count متابع',
      many: '$count متابع',
      few: '$count متابع',
      two: '$count متابع',
      one: '$count متابع',
      zero: '$count متابع',
    );
    return '$_temp0';
  }

  @override
  String nbFollowing(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count يتابعهم',
      many: '$count يتابعهم',
      few: '$count يتابعهم',
      two: '$count يتابعهم',
      one: '$count يتابعهم',
      zero: '$count يتابعهم',
    );
    return '$_temp0';
  }

  @override
  String lessThanNbMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'أقل من $count دقيقة',
      many: 'أقل من $count دقيقة',
      few: 'أقل من $count دقيقة',
      two: 'أقل من $count دقيقة',
      one: 'أقل من $count دقيقة',
      zero: 'أقل من $count دقيقة',
    );
    return '$_temp0';
  }

  @override
  String nbGamesInPlay(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count مباراة جارية',
      many: '$count مباراة جارية',
      few: '$count مباراة جارية',
      two: '$count مباراة جارية',
      one: '$count مباراة جارية',
      zero: '$count مباراة جارية',
    );
    return '$_temp0';
  }

  @override
  String maximumNbCharacters(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'الحد الأقصى: $count حرف.',
      many: 'الحد الأقصى: $count حرف.',
      few: 'الحد الأقصى: $count حرف.',
      two: 'الحد الأقصى: $count حرف.',
      one: 'الحد الأقصى: $count حرف.',
      zero: 'الحد الأقصى: $count حرف.',
    );
    return '$_temp0';
  }

  @override
  String blocks(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count حظر',
      many: '$count حظر',
      few: '$count حظر',
      two: '$count حظر',
      one: '$count حظر',
      zero: '$count حظر',
    );
    return '$_temp0';
  }

  @override
  String nbForumPosts(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'منشورات المنتدى $count',
      many: 'منشورات المنتدى $count',
      few: 'منشورات المنتدى $count',
      two: 'منشورات المنتدى $count',
      one: 'منشورات المنتدى $count',
      zero: 'منشورات المنتدى $count',
    );
    return '$_temp0';
  }

  @override
  String nbPerfTypePlayersThisWeek(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$param2 $count لاعب هذا الإسبوع.',
      many: '$param2 $count لاعب هذا الإسبوع.',
      few: '$param2 $count لاعب هذا الإسبوع.',
      two: '$param2 $count لاعب هذا الإسبوع.',
      one: '$param2 $count لاعب هذا الإسبوع.',
      zero: '$param2 $count لاعب هذا الإسبوع.',
    );
    return '$_temp0';
  }

  @override
  String availableInNbLanguages(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'متاح ب $count لغات!',
      many: 'متاح ب $count لغات!',
      few: 'متاح ب $count لغات!',
      two: 'متاح ب $count لغات!',
      one: 'متاح ب $count لغات!',
      zero: 'متاح ب $count لغات!',
    );
    return '$_temp0';
  }

  @override
  String nbSecondsToPlayTheFirstMove(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ثوانِ متبقية لاتمام النقلة الأولى',
      many: '$count ثوانِ متبقية لاتمام النقلة الأولى',
      few: '$count ثوانِ متبقية لاتمام النقلة الأولى',
      two: '$count ثوانِ متبقية لاتمام النقلة الأولى',
      one: '$count ثانية متبقية لإتمام النقلة الأولى',
      zero: '$count ثانية متبقية لاتمام النقلة الأولى',
    );
    return '$_temp0';
  }

  @override
  String nbSeconds(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ثوانِ',
      many: '$count ثوانِ',
      few: '$count ثوانِ',
      two: '$count ثوانِ',
      one: '$count ثانية',
      zero: '$count ثانية',
    );
    return '$_temp0';
  }

  @override
  String andSaveNbPremoveLines(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'واحفظ عدد $count تفريع نقلة مسبقة',
      many: 'واحفظ عدد $count تفريع نقلة مسبقة',
      few: 'واحفظ عدد $count تفريع نقلة مسبقة',
      two: 'واحفظ عدد $count تفريع نقلة مسبقة',
      one: 'واحفظ تفريع النقلة المسبقة',
      zero: 'واحفظ تفريع النقلة المسبقة',
    );
    return '$_temp0';
  }

  @override
  String get patronDonate => 'تبرع';

  @override
  String get patronLichessPatron => 'راعي Lichess';

  @override
  String get preferencesPreferences => 'تفضيلات';

  @override
  String get preferencesDisplay => 'عرض';

  @override
  String get preferencesPrivacy => 'الخصوصية';

  @override
  String get preferencesNotifications => 'إشعارات';

  @override
  String get preferencesPieceAnimation => 'المؤثرات الحركية للقطعة';

  @override
  String get preferencesMaterialDifference => 'الفرق المادي';

  @override
  String get preferencesBoardHighlights => 'تميز معالم الرقعة (آخر نقلة والكش)';

  @override
  String get preferencesPieceDestinations => 'إظهار النقلات القانونية (النقلات المتاحة والنقلات الاستباقية)';

  @override
  String get preferencesBoardCoordinates => 'إحداثيات الرقعة (A-H, 1-8)';

  @override
  String get preferencesMoveListWhilePlaying => 'قائمة النقلات خلال المباراة';

  @override
  String get preferencesPgnPieceNotation => 'تدوين النقلة';

  @override
  String get preferencesChessPieceSymbol => 'رمز قطعة الشطرنج';

  @override
  String get preferencesPgnLetter => 'حروف (K, Q, R, B, N)';

  @override
  String get preferencesZenMode => 'وضع التأمل';

  @override
  String get preferencesShowPlayerRatings => 'إظهار تقييمات اللاعب';

  @override
  String get preferencesShowFlairs => 'إظهار ميول اللاعب';

  @override
  String get preferencesExplainShowPlayerRatings => 'هذا يخفي جميع التقييمات من الموقع، للمساعدة في التركيز على مباراة الشطرنج. لا يزال من الممكن لعب مباريات مقيمة، هذا فقط يحدد ما تراه.';

  @override
  String get preferencesDisplayBoardResizeHandle => 'أظهر زر تعديل حجم الرقعة';

  @override
  String get preferencesOnlyOnInitialPosition => 'خلال الوضع المبدئي فقط';

  @override
  String get preferencesInGameOnly => 'في اللعبة فقط';

  @override
  String get preferencesChessClock => 'مؤقت الشطرنج';

  @override
  String get preferencesTenthsOfSeconds => 'أجزاء الثانية';

  @override
  String get preferencesWhenTimeRemainingLessThanTenSeconds => 'عندما يقل الوقت عن 10 ثوانٍ';

  @override
  String get preferencesHorizontalGreenProgressBars => 'الشريط الأخضر للساعة';

  @override
  String get preferencesSoundWhenTimeGetsCritical => 'إصدار صوت عندما يقارب الوقت الانتهاء';

  @override
  String get preferencesGiveMoreTime => 'منح الوقت';

  @override
  String get preferencesGameBehavior => 'إعدادات اللعبة';

  @override
  String get preferencesHowDoYouMovePieces => 'كيف يمكنك تحريك القطع؟';

  @override
  String get preferencesClickTwoSquares => 'النقر فوق مربعين';

  @override
  String get preferencesDragPiece => 'سحب القطعة';

  @override
  String get preferencesBothClicksAndDrag => 'كلاهما';

  @override
  String get preferencesPremovesPlayingDuringOpponentTurn => 'النقلات الاستباقية (اللعب خلال دور الخصم)';

  @override
  String get preferencesTakebacksWithOpponentApproval => 'التراجع عن النقلات (بموافقة الخصم)';

  @override
  String get preferencesInCasualGamesOnly => 'في المباريات غير المقيمة فقط';

  @override
  String get preferencesPromoteToQueenAutomatically => 'الترقية إلى وزير آلياً';

  @override
  String get preferencesExplainPromoteToQueenAutomatically => 'اضغط مفتاح<ctrl> عند الترقية لتعطيل الترقية التلقائية مؤقتاً';

  @override
  String get preferencesWhenPremoving => 'عند النقلة الاستباقية';

  @override
  String get preferencesClaimDrawOnThreefoldRepetitionAutomatically => 'مطالبة بالتعادل لتكرار نفس النقلات ثلاث مرات بشكل تلقائي';

  @override
  String get preferencesWhenTimeRemainingLessThanThirtySeconds => 'عندما يقل الوقت عن 30 ثانية';

  @override
  String get preferencesMoveConfirmation => 'تأكيد النقلة';

  @override
  String get preferencesExplainCanThenBeTemporarilyDisabled => 'يمكن تعطيله أثناء اللعبة مع قائمة اللوحة';

  @override
  String get preferencesInCorrespondenceGames => 'فى العاب المراسلة';

  @override
  String get preferencesCorrespondenceAndUnlimited => 'مراسلة وبدون توقيت';

  @override
  String get preferencesConfirmResignationAndDrawOffers => 'تأكيد الاستسلام وعرض التعادل';

  @override
  String get preferencesCastleByMovingTheKingTwoSquaresOrOntoTheRook => 'طريقة التحصين/التبييت';

  @override
  String get preferencesCastleByMovingTwoSquares => 'حرك الملك مربعين';

  @override
  String get preferencesCastleByMovingOntoTheRook => 'حرك الملك بإتجاه الرخ';

  @override
  String get preferencesInputMovesWithTheKeyboard => 'إدخال النقلات بلوحة المفاتيح';

  @override
  String get preferencesInputMovesWithVoice => 'الإدخال يتحرك بصوتك';

  @override
  String get preferencesSnapArrowsToValidMoves => 'سحب الأسهم في اتجاهات صالحة';

  @override
  String get preferencesSayGgWpAfterLosingOrDrawing => 'قُل \"مباراة جيدة، لعبت بشكل جيد\" عند الهزيمة أو التعادل';

  @override
  String get preferencesYourPreferencesHaveBeenSaved => 'تم حفظ تفضيلاتك.';

  @override
  String get preferencesScrollOnTheBoardToReplayMoves => 'مرر على الرقعة لإعادة عرض التحركات';

  @override
  String get preferencesCorrespondenceEmailNotification => 'البريد الإلكتروني اليومي يدرج ألعاب المراسلة الخاصة بك';

  @override
  String get preferencesNotifyStreamStart => 'البث مباشر الآن';

  @override
  String get preferencesNotifyInboxMsg => 'رسالة جديدة في البريد الوارد';

  @override
  String get preferencesNotifyForumMention => 'تعليق في المنتدى يشير إليك';

  @override
  String get preferencesNotifyInvitedStudy => 'دعوة إلى الدراسة';

  @override
  String get preferencesNotifyGameEvent => 'تحديثات مباراة المراسلة';

  @override
  String get preferencesNotifyChallenge => 'تحديات';

  @override
  String get preferencesNotifyTournamentSoon => 'البطولة ستبدأ قريباً';

  @override
  String get preferencesNotifyTimeAlarm => 'ساعة المراسلة تنفد';

  @override
  String get preferencesNotifyBell => 'إشعار الجرس داخل Lichess';

  @override
  String get preferencesNotifyPush => 'إشعار الجهاز عندما لا تكون على Lichess';

  @override
  String get preferencesNotifyWeb => 'المتصفح';

  @override
  String get preferencesNotifyDevice => 'الجهاز';

  @override
  String get preferencesBellNotificationSound => 'صوت التنبيه';

  @override
  String get puzzlePuzzles => 'الألغاز';

  @override
  String get puzzlePuzzleThemes => 'خصائص الألغاز';

  @override
  String get puzzleRecommended => 'مقترح';

  @override
  String get puzzlePhases => 'مراحل';

  @override
  String get puzzleMotifs => 'الأفكار الرئيسية';

  @override
  String get puzzleAdvanced => 'خيارات أعمق';

  @override
  String get puzzleLengths => 'الأطوال';

  @override
  String get puzzleMates => 'الحلفاء';

  @override
  String get puzzleGoals => 'الغايات';

  @override
  String get puzzleOrigin => 'الأصل';

  @override
  String get puzzleSpecialMoves => 'نقلات مميزة';

  @override
  String get puzzleDidYouLikeThisPuzzle => 'هل أعجبك هذا اللغز؟';

  @override
  String get puzzleVoteToLoadNextOne => 'صوت لتبدأ الغز التالي!';

  @override
  String get puzzleUpVote => 'أعجبني اللغز';

  @override
  String get puzzleDownVote => 'لم يعجبني اللغز';

  @override
  String get puzzleYourPuzzleRatingWillNotChange => 'تقييم الألغاز الخاص بك لن يتغير. لاحظ أن الألغاز ليست مسابقة. التقييم يساعد على اختيار أفضل الألغاز لمهاراتك الحالية.';

  @override
  String get puzzleFindTheBestMoveForWhite => 'جد أفضل نقلة للأبيض.';

  @override
  String get puzzleFindTheBestMoveForBlack => 'جد أفضل نقلة للأسود.';

  @override
  String get puzzleToGetPersonalizedPuzzles => 'للحصول على ألغاز خاصة بك:';

  @override
  String puzzlePuzzleId(String param) {
    return 'لغز $param';
  }

  @override
  String get puzzlePuzzleOfTheDay => 'لغز اليوم';

  @override
  String get puzzleDailyPuzzle => 'اللغز اليومي';

  @override
  String get puzzleClickToSolve => 'انقر للحل';

  @override
  String get puzzleGoodMove => 'نقلة جيدة';

  @override
  String get puzzleBestMove => 'أفضل نقلة!';

  @override
  String get puzzleKeepGoing => 'استمر…';

  @override
  String get puzzlePuzzleSuccess => 'تم بنجاح!';

  @override
  String get puzzlePuzzleComplete => 'تم حل اللغز!';

  @override
  String get puzzleByOpenings => 'من الافتتاحات';

  @override
  String get puzzlePuzzlesByOpenings => 'ألغاز من الافتتاحات';

  @override
  String get puzzleOpeningsYouPlayedTheMost => 'الافتتاحات التي استخدمتها في معظم المبارايات المقيمة';

  @override
  String get puzzleUseFindInPage => 'استخدم خاصية \"البحث في الصفحة\" في المتصفح للعثور على افتتاحك المفضل!';

  @override
  String get puzzleUseCtrlF => 'أضغط Ctrl و f لتبحث عن افتتاحك المفضل!';

  @override
  String get puzzleNotTheMove => 'هذه ليست الحركة الصحيحة!';

  @override
  String get puzzleTrySomethingElse => 'جرب شيئا آخر.';

  @override
  String puzzleRatingX(String param) {
    return 'التقييم: $param';
  }

  @override
  String get puzzleHidden => 'مخفي';

  @override
  String puzzleFromGameLink(String param) {
    return 'من مباراة $param';
  }

  @override
  String get puzzleContinueTraining => 'استمر في التدريب';

  @override
  String get puzzleDifficultyLevel => 'مستوى الصعوبة';

  @override
  String get puzzleNormal => 'عادي';

  @override
  String get puzzleEasier => 'سهل';

  @override
  String get puzzleEasiest => 'سهل جدًا';

  @override
  String get puzzleHarder => 'أصعب';

  @override
  String get puzzleHardest => 'صعب جدًا';

  @override
  String get puzzleExample => 'مثال';

  @override
  String get puzzleAddAnotherTheme => 'إضافة نوع آخر';

  @override
  String get puzzleNextPuzzle => 'اللغز الموالي';

  @override
  String get puzzleJumpToNextPuzzleImmediately => 'انتقل للغز التالي مباشرة';

  @override
  String get puzzlePuzzleDashboard => 'لوحة التحكم بالألغاز';

  @override
  String get puzzleImprovementAreas => 'مناطق بحاجة لتحسين';

  @override
  String get puzzleStrengths => 'نقاط القوة';

  @override
  String get puzzleHistory => 'سجل الألغاز';

  @override
  String get puzzleSolved => 'حلت';

  @override
  String get puzzleFailed => 'فشلت';

  @override
  String get puzzleStreakDescription => 'حل الألغاز بشكل مطرد وبناء سلسلة الفوز. لا توجد ساعة، لذا خذ وقتك. نقلة خاطئة واحدة، وقد انتهت اللعبة! ولكن يمكنك تخطي حركة واحدة في كل دورة.';

  @override
  String puzzleYourStreakX(String param) {
    return 'حل متتالي: $param';
  }

  @override
  String get puzzleStreakSkipExplanation => 'تخطى هذه الحركة للحفاظ على سلسلة الانتصارات.';

  @override
  String get puzzleContinueTheStreak => 'استمر في الحل المتتالي';

  @override
  String get puzzleNewStreak => 'حل متتالي جديد';

  @override
  String get puzzleFromMyGames => 'من مبارياتي';

  @override
  String get puzzleLookupOfPlayer => 'ابحث عن ألغاز في مباريات لاعبين آخريين';

  @override
  String puzzleFromXGames(String param) {
    return 'ألغاز من مباريات $param';
  }

  @override
  String get puzzleSearchPuzzles => 'ابحث عن ألغاز';

  @override
  String get puzzleFromMyGamesNone => 'ليس لديك أي ألغز في قاعدة البيانات، لكن Lichess تحبك جداً.\nإلعب مبارايات سريعة أو مبارايات كلاسيكية لزيادة فرصك في الحصول على ألغازك الخاصة!';

  @override
  String puzzleFromXGamesFound(String param1, String param2) {
    return '$param1 ألغاز وجدت في $param2 مباراة';
  }

  @override
  String get puzzlePuzzleDashboardDescription => 'تدرب،حلل،تطور';

  @override
  String puzzlePercentSolved(String param) {
    return 'تم حل $param';
  }

  @override
  String get puzzleNoPuzzlesToShow => 'لا شيء لإظهاره، اذهب والعب بعض الألغاز!';

  @override
  String get puzzleImprovementAreasDescription => 'تدرب بهذه لتحسين تقدمك!';

  @override
  String get puzzleStrengthDescription => 'أنت تقوم بهذه المهارة بأفضل شكل';

  @override
  String puzzlePlayedXTimes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'لعبت $count مرة',
      many: 'لعبت $count مرة',
      few: 'لعبت $count مرة',
      two: 'لعبت $count مرة',
      one: 'لعبت $count مرة',
      zero: 'لعبت $count مرة',
    );
    return '$_temp0';
  }

  @override
  String puzzleNbPointsBelowYourPuzzleRating(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count نقطة أقل من تقييمك في الألغاز',
      many: '$count نقطة أقل من تقييمك في الألغاز',
      few: '$count نقطة أقل من تقييمك في الألغاز',
      two: '$count نقطة أقل من تقييمك في الألغاز',
      one: 'نقطة واحدة أقل من تقييمك في الألغاز',
      zero: 'نقطة واحدة أقل من تقييمك في الألغاز',
    );
    return '$_temp0';
  }

  @override
  String puzzleNbPointsAboveYourPuzzleRating(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count نقطة أعلى من تقييمك في الألغاز',
      many: '$count نقطة أعلى من تقييمك في الألغاز',
      few: '$count نقطة أعلى من تقييمك في الألغاز',
      two: '$count نقطة أعلى من تقييمك في الألغاز',
      one: 'نقطة واحدة أعلى من تقييمك في الألغاز',
      zero: 'نقطة واحدة أعلى من تقييمك في الألغاز',
    );
    return '$_temp0';
  }

  @override
  String puzzleNbPlayed(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count لعبت',
      many: '$count لعبت',
      few: '$count لعبت',
      two: '$count لعبت',
      one: '$count لعبت',
      zero: '$count لعبت',
    );
    return '$_temp0';
  }

  @override
  String puzzleNbToReplay(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count لإعادة العرض',
      many: '$count لإعادة العرض',
      few: '$count لإعادة العرض',
      two: '$count لإعادة العرض',
      one: '$count لإعادة العرض',
      zero: '$count لإعادة العرض',
    );
    return '$_temp0';
  }

  @override
  String get puzzleThemeAdvancedPawn => 'الأخذ بالتجاوز';

  @override
  String get puzzleThemeAdvancedPawnDescription => 'و يُعتبر ترقية البيدق أو التهديد بترقيته هو مفتاح التكتيك.';

  @override
  String get puzzleThemeAdvantage => 'أفضلية';

  @override
  String get puzzleThemeAdvantageDescription => 'اغتنم فرصتك للحصول على ميزة حاسمة. (200cp ≤ التقييم ≤ 600cp)';

  @override
  String get puzzleThemeAnastasiaMate => 'أنماط كش مات';

  @override
  String get puzzleThemeAnastasiaMateDescription => 'يتعاون الحصان والقلعة أو الوزير ليحاصروا الملك المنافس بين جانب الرقعة وقطعة صديقة.';

  @override
  String get puzzleThemeArabianMate => 'كش مات عربي';

  @override
  String get puzzleThemeArabianMateDescription => 'يتعاون الحصان والرخ ليحاصروا ملك الخصم في زاوية الرقعة.';

  @override
  String get puzzleThemeAttackingF2F7 => 'الهجوم على f2 أو f7';

  @override
  String get puzzleThemeAttackingF2F7Description => 'هجوم يستهدف بيادق f2 أو f7، على سبيل المثال، كما في افتتاحية \"fried liver\".';

  @override
  String get puzzleThemeAttraction => 'الجذب(التضحية)';

  @override
  String get puzzleThemeAttractionDescription => 'تضحية خادعة تغري الخصم لأخذها لتنفيذ فكرة تكتيكية، أو تبادل قطع بهدف إرغام الخضم على نقل قطعة إلى مربع حيث يمكن استغلال موقعها الجديد من خلال تكتيك معين.';

  @override
  String get puzzleThemeBackRankMate => 'كش مات في الصف الأخير';

  @override
  String get puzzleThemeBackRankMateDescription => 'كش مات في الصف الأخير حيث يكون الملك محاصر بقطعه.';

  @override
  String get puzzleThemeBishopEndgame => 'مرحلة نهاية اللعبة بالفيلة';

  @override
  String get puzzleThemeBishopEndgameDescription => 'مرحلة نهاية اللعبة تتضمن فيل وجنود فقط.';

  @override
  String get puzzleThemeBodenMate => 'كش مات \"بودين\"';

  @override
  String get puzzleThemeBodenMateDescription => 'فيلين يهاجمان الملك على أوتار متجاورة ويكون الملكك محاصر بقطع صديقة ليشكل كش مات.';

  @override
  String get puzzleThemeCastling => 'تبييت';

  @override
  String get puzzleThemeCastlingDescription => 'ضع الملك في أمان، وانشر القلعة للهجوم.';

  @override
  String get puzzleThemeCapturingDefender => 'خذ المدافع';

  @override
  String get puzzleThemeCapturingDefenderDescription => 'إزالة قطعة ذات أهمية حاسمة للدفاع عن قطعة أخرى، مما يسمح للقطعة التي لا يمكن الدفاع عنها الآن أن يتم الاستيلاء عليها في الحركة التالية.';

  @override
  String get puzzleThemeCrushing => 'سحق';

  @override
  String get puzzleThemeCrushingDescription => 'اكتشف خطأ الخصم الفادح للحصول على تفوق ساحق (يساوي 600 جزء بالمئة من البيدق أو أكثر)';

  @override
  String get puzzleThemeDoubleBishopMate => 'كش مات بفيلين';

  @override
  String get puzzleThemeDoubleBishopMateDescription => 'فيلين يهاجمان الملك على أوتار متجاورة ويكون الملكك محاصر بقطع صديقة ليشكل كش مات.';

  @override
  String get puzzleThemeDovetailMate => 'كش مات \"Dovetail\"';

  @override
  String get puzzleThemeDovetailMateDescription => 'الوزير يكش مات للملك العدو المجاور، و يكون المربعات الي يمكن الهرب إليها مشغولة بقطع صديقة.';

  @override
  String get puzzleThemeEquality => 'المساواة';

  @override
  String get puzzleThemeEqualityDescription => 'تحويل الوضعية الخاسرة إلى وصعية تعادل أو موقف متعادل';

  @override
  String get puzzleThemeKingsideAttack => 'هجوم من طرف الملك';

  @override
  String get puzzleThemeKingsideAttackDescription => 'الهجوم على ملك الخصم بعد أن يجري التبييت على جناح الملك.';

  @override
  String get puzzleThemeClearance => 'تصفية';

  @override
  String get puzzleThemeClearanceDescription => 'حركة، غالباً ما تكون تراجعية، مما يفرغ عمود أو قطر أو مربع، ليتبعه خطة تكتيكية.';

  @override
  String get puzzleThemeDefensiveMove => 'نقلة دفاعية';

  @override
  String get puzzleThemeDefensiveMoveDescription => 'نقلات أو سلسلة من النقلات الدقيقة الضرورية لعدم خسارة قطع أو خسارة الأفضلية.';

  @override
  String get puzzleThemeDeflection => 'ابعاد';

  @override
  String get puzzleThemeDeflectionDescription => 'نقلة تصرف انتباه قطعة الخصم عن مهمة مهمة أخرى تؤديها، على سبيل المثال، عن الدفاع عن مربع رئيسي. أحيانًا يُطلق عليه أيضًا \"التحميل الزائد\".';

  @override
  String get puzzleThemeDiscoveredAttack => 'هجوم مكشوف';

  @override
  String get puzzleThemeDiscoveredAttackDescription => 'تحريك قطعة (مثل الحصان)، التي حالت في السابق دون هجوم على قطعة بعيدة المدى (مثل القلعة)، بعيدا عن طريق تلك القطعة.';

  @override
  String get puzzleThemeDoubleCheck => 'كشة مزدوجة';

  @override
  String get puzzleThemeDoubleCheckDescription => 'الكش من قطعتين في وقت واحد، نتيجةً للهجوم المكتشف حيث تهاجم كل من القطعة المتحركة والقطعة غير المختبئة ملك الخصم. وبالتالي لا يمكن للملك سوى الهروب من الكش.';

  @override
  String get puzzleThemeEndgame => 'مرحلة نهاية المباراة';

  @override
  String get puzzleThemeEndgameDescription => 'تكتيك خلال مرحلة نهاية المباراة.';

  @override
  String get puzzleThemeEnPassantDescription => 'تكتيك يستخدم قاعدة \"الأخذ بالتجاوز\"، حيث يمكن للبيدق أن يأسر بيدق الخصم الذي قام بالحركة الأولية عن طريق نقله مربعين، حيث يتعرض المربع المتقاطع للهجوم من قبل بيدق يمكنه الاستيلاء على بيدق الخصم.';

  @override
  String get puzzleThemeExposedKing => 'ملك مكشوف';

  @override
  String get puzzleThemeExposedKingDescription => 'تكتيك حيث يكون هناك القليل من المدافعين حول الملك مما يقود غالباً إلى كش مات.';

  @override
  String get puzzleThemeFork => 'شوكة';

  @override
  String get puzzleThemeForkDescription => 'نقلة تهاجم قطعتين للخصم في آن واحد.';

  @override
  String get puzzleThemeHangingPiece => 'قطعة معلقة بدون حماية';

  @override
  String get puzzleThemeHangingPieceDescription => 'تكتيك حيث تكون قطعة للخصم غير مدافع عنها أو دفاع غير كافي بالتالي يمكن التقاطها بدون خسارة أي قطع من طرفك.';

  @override
  String get puzzleThemeHookMate => 'كش مات بالخطاف';

  @override
  String get puzzleThemeHookMateDescription => 'نمط الكش مات باستخدام قلعة و حصان و جندي بالإضافة إلى جندي الخصم ليحد من حركات الملك للهروب.';

  @override
  String get puzzleThemeInterference => 'التشوش';

  @override
  String get puzzleThemeInterferenceDescription => 'نقلة تحجب خط التفاعل بين قطع الخصم بعيدة المدى، ونتيجة لذلك تصبح إحدى القطعتين أو كلاهما بلا حماية. على سبيل المثال، يقف الحصان في مربع بين قلعتين.';

  @override
  String get puzzleThemeIntermezzo => 'النقلة البينيّة';

  @override
  String get puzzleThemeIntermezzoDescription => 'بدلاً من لعب النقلة المتوقعة، يتم أولاً القيام بنقلة أخرى تشكل تهديدًا فوريًا مباشرًا يجب على الخصم الرد عليه. يُعرف أيضًا باسم \"زفيشنزوك\" أو \"أنترميزو \".';

  @override
  String get puzzleThemeKnightEndgame => 'نهاية المباراة تتضمن حصان';

  @override
  String get puzzleThemeKnightEndgameDescription => 'نهاية مباراة تتضمن أحصنة و بيادق فقط.';

  @override
  String get puzzleThemeLong => 'لغز طويل';

  @override
  String get puzzleThemeLongDescription => 'ثلاث حركات للفوز.';

  @override
  String get puzzleThemeMaster => 'مباريات استاذ';

  @override
  String get puzzleThemeMasterDescription => 'ألغاز من مباريات لاعبين من حملة الألقاب.';

  @override
  String get puzzleThemeMasterVsMaster => 'مباراة أستاذ ضد أستاذ';

  @override
  String get puzzleThemeMasterVsMasterDescription => 'ألغاز من مباريات بين لاعبين من حملة الألقاب.';

  @override
  String get puzzleThemeMate => 'كش مات';

  @override
  String get puzzleThemeMateDescription => 'اربح المباراة بأناقة.';

  @override
  String get puzzleThemeMateIn1 => 'كش مات في حركة واحدة';

  @override
  String get puzzleThemeMateIn1Description => 'تحقيق الكش مات في حركة وحدة.';

  @override
  String get puzzleThemeMateIn2 => 'كش مات في حركتين';

  @override
  String get puzzleThemeMateIn2Description => 'تحقيق الكش مات في حركتين.';

  @override
  String get puzzleThemeMateIn3 => 'كش مات في 3 حركات';

  @override
  String get puzzleThemeMateIn3Description => 'تحقيق الكش مات في 3 نقلات.';

  @override
  String get puzzleThemeMateIn4 => 'كش مات في 4 حركات';

  @override
  String get puzzleThemeMateIn4Description => 'تحقيق الكش مات قي 4 نقلات.';

  @override
  String get puzzleThemeMateIn5 => 'كش مات في 5 حركات أو اكثر';

  @override
  String get puzzleThemeMateIn5Description => 'اكتشف سلسلة من الحركات الممتابعة التي تقود إلى كش مات.';

  @override
  String get puzzleThemeMiddlegame => 'مرحلة وسط اللعبة';

  @override
  String get puzzleThemeMiddlegameDescription => 'تكتيك خلال وسط المباراة.';

  @override
  String get puzzleThemeOneMove => 'لفز ذو حركة واحدة';

  @override
  String get puzzleThemeOneMoveDescription => 'لغز بحركة واحدة فقط.';

  @override
  String get puzzleThemeOpening => 'افتتاح';

  @override
  String get puzzleThemeOpeningDescription => 'تكتيك في مرحلة الافتتاح.';

  @override
  String get puzzleThemePawnEndgame => 'نهاية اللعبة بالجنود';

  @override
  String get puzzleThemePawnEndgameDescription => 'نهاية لعبة بجنود فقط.';

  @override
  String get puzzleThemePin => 'تثبيت';

  @override
  String get puzzleThemePinDescription => 'تكتيك يستخدم التثبيت حيث تكون القطعة غير قادرة على الحركة لأنها ستعرض قطعة ذات قيمة أكبر للهجوم.';

  @override
  String get puzzleThemePromotion => 'ترقية';

  @override
  String get puzzleThemePromotionDescription => 'ترقية جنديك إلى وزير أو أي قطعة أخرى.';

  @override
  String get puzzleThemeQueenEndgame => 'نهاية مباراة الوزير';

  @override
  String get puzzleThemeQueenEndgameDescription => 'نهاية المباراة بالوزير و الجنود.';

  @override
  String get puzzleThemeQueenRookEndgame => 'وزير و قلعة';

  @override
  String get puzzleThemeQueenRookEndgameDescription => 'نهاية المباراة تضمن وزير و قلاع و جنود.';

  @override
  String get puzzleThemeQueensideAttack => 'هجوم على طرف الوزير';

  @override
  String get puzzleThemeQueensideAttackDescription => 'الهجوم على ملك الخصم بعد التبييت على جناح الوزير.';

  @override
  String get puzzleThemeQuietMove => 'نقلة هادئة';

  @override
  String get puzzleThemeQuietMoveDescription => 'حركة لا تكش أو تأخذ أي قطعة و لا تشكل أي تهديد مباشر بالأخذ، لكنها تحضر لحركة خفية لتهديد لا يمكن تجنبه.';

  @override
  String get puzzleThemeRookEndgame => 'نهاية المباراة بالقلعة';

  @override
  String get puzzleThemeRookEndgameDescription => 'نهاية المباراة بالقلعة و الجنود فقط.';

  @override
  String get puzzleThemeSacrifice => 'تضحية';

  @override
  String get puzzleThemeSacrificeDescription => 'تكتيك يشمل التضحية ببعض القطع مقابل كسب الأفضلية مرة أخرى بعد عدة حركات إجبارية.';

  @override
  String get puzzleThemeShort => 'لغز قصير';

  @override
  String get puzzleThemeShortDescription => 'حركتين للانتصار.';

  @override
  String get puzzleThemeSkewer => 'سيخ';

  @override
  String get puzzleThemeSkewerDescription => 'نموذج يتضمن قطعة عالية القيمة تتعرض للهجوم، وتتحرك بعيدًا عن الخط، وتسمح بأسر قطعة ذات قيمة أقل خلفها أو مهاجمتها، عكس التثبيت.';

  @override
  String get puzzleThemeSmotheredMate => 'كش بالخنق';

  @override
  String get puzzleThemeSmotheredMateDescription => 'هو نمط من الكش مات بالحصان حيث أن الملك غير قادر على التحرك لأنه محاط (مخنوق) بقطعه.';

  @override
  String get puzzleThemeSuperGM => 'مباراة أستاذ دولي كبير';

  @override
  String get puzzleThemeSuperGMDescription => 'ألغاز من مبارايات تم لعبها من أفضل اللاعبين في العالم.';

  @override
  String get puzzleThemeTrappedPiece => 'قطعة محاصرة';

  @override
  String get puzzleThemeTrappedPieceDescription => 'قطعة لا تستطيع الهرب بسبب عدم وجود مربعات آمنة للهروب إليها.';

  @override
  String get puzzleThemeUnderPromotion => 'ترقية لغير الوزير';

  @override
  String get puzzleThemeUnderPromotionDescription => 'ترقية الجندي لقلعة أو فيل أو حصان.';

  @override
  String get puzzleThemeVeryLong => 'لغز طويل جداً';

  @override
  String get puzzleThemeVeryLongDescription => 'أربع نقلات أو أكثر للفوز.';

  @override
  String get puzzleThemeXRayAttack => 'هجوم X-Ray';

  @override
  String get puzzleThemeXRayAttackDescription => 'القطعة تهاجم أو تدافع عن مربع, من خلال قطعة عدو.';

  @override
  String get puzzleThemeZugzwang => 'Zugzwang';

  @override
  String get puzzleThemeZugzwangDescription => 'حركات الخصم محدودة و كل الحركات تؤدي إلى تفاقم الوضع نحو الأسوء.';

  @override
  String get puzzleThemeHealthyMix => 'خليط';

  @override
  String get puzzleThemeHealthyMixDescription => 'القليل من كل نوع، لذا لا يمكنك التنبؤ باللغز القادم فابقى مستعداً لأي شيء، تماماً كالمباريات الحقيقية.';

  @override
  String get puzzleThemePlayerGames => 'مبارايات اللاعب';

  @override
  String get puzzleThemePlayerGamesDescription => 'ابحث عن ألغاز من مبارياتك أو من مباريات لاعبين آخرين.';

  @override
  String puzzleThemePuzzleDownloadInformation(String param) {
    return 'هذه الألغاز موجودة للعامة بإمكانك تحميلها من هنا$param.';
  }

  @override
  String perfStatPerfStats(String param) {
    return 'احصائيات $param';
  }

  @override
  String get perfStatViewTheGames => 'عرض المباريات';

  @override
  String get perfStatProvisional => 'مؤقت';

  @override
  String get perfStatNotEnoughRatedGames => 'لم تلعب مباريات مقيّمة بما يكفي للحصول ع تقييم موثق.';

  @override
  String perfStatProgressOverLastXGames(String param) {
    return 'التقدم خلال آخر المباريات ال$param الاخيرة:';
  }

  @override
  String perfStatRatingDeviation(String param) {
    return 'انحراف التقييم: $param.';
  }

  @override
  String perfStatRatingDeviationTooltip(String param1, String param2, String param3) {
    return 'القيمة المنخفضة تعني أن التصنيف أكثر استقرارا. أعلى من $param1، يعتبر التقييم مؤقتا. لكي يتم تضمينه في الترتيبات، يجب أن تكون هذه القيمة أقل من $param2 (الشطرنج القياسي) أو $param3 (المتغيرات).';
  }

  @override
  String get perfStatTotalGames => 'إجمالي المباريات';

  @override
  String get perfStatRatedGames => 'مباريات مقيّمة';

  @override
  String get perfStatTournamentGames => 'مباريات بطولة';

  @override
  String get perfStatBerserkedGames => 'مباريات مخاطرة';

  @override
  String get perfStatTimeSpentPlaying => 'الوقت المقضي في اللعب';

  @override
  String get perfStatAverageOpponent => 'متوسط تقييم الخصم';

  @override
  String get perfStatVictories => 'الانتصارات';

  @override
  String get perfStatDefeats => 'الهزائم';

  @override
  String get perfStatDisconnections => 'الانقطاعات';

  @override
  String get perfStatNotEnoughGames => 'لم تلعب مباريات كفاية';

  @override
  String perfStatHighestRating(String param) {
    return 'أعلى تقييم: $param';
  }

  @override
  String perfStatLowestRating(String param) {
    return 'أقل تقييم: $param';
  }

  @override
  String perfStatFromXToY(String param1, String param2) {
    return 'من $param1 الى $param2';
  }

  @override
  String get perfStatWinningStreak => 'سلسلة الانتصارات';

  @override
  String get perfStatLosingStreak => 'سلسلة الهزائم';

  @override
  String perfStatLongestStreak(String param) {
    return 'اطول سلسلة: $param';
  }

  @override
  String perfStatCurrentStreak(String param) {
    return 'السلسلة الحالية: $param';
  }

  @override
  String get perfStatBestRated => 'افضل الانتصارات المقيّمة';

  @override
  String get perfStatGamesInARow => 'مباريات لُعبت على التوالي';

  @override
  String get perfStatLessThanOneHour => 'اقل من ساعة واحدة بين المباريات';

  @override
  String get perfStatMaxTimePlaying => 'اقصى وقت مقضي في اللعب';

  @override
  String get perfStatNow => 'الآن';

  @override
  String get searchSearch => 'بحث';

  @override
  String get settingsSettings => 'الإعدادات';

  @override
  String get settingsCloseAccount => 'إغلاق الحساب';

  @override
  String get settingsManagedAccountCannotBeClosed => 'حسابك يتم إدارته، ولا يمكن إغلاقه.';

  @override
  String get settingsClosingIsDefinitive => 'الإغلاق الحساب نهائي، لا يمكنك التراجع عن هذا القرار، أ أنت متحقق؟';

  @override
  String get settingsCantOpenSimilarAccount => 'لن يسمح لك بفتح حساب جديد بنفس الإسم، حتى لو كان حجم الأحرف مختلف.';

  @override
  String get settingsChangedMindDoNotCloseAccount => 'غيرت رأيي، لا تغلق حسابي';

  @override
  String get settingsCloseAccountExplanation => 'هل أنت متأكد من أنك تريد اغلاق حسابك؟\nاغلاق حسابك هو قرار دائم ونهائي.\nولا يمكنك التراجع عن هذا القرار على الإطلاق.';

  @override
  String get settingsThisAccountIsClosed => 'هذا الحساب مغلق.';

  @override
  String get streamerLichessStreamers => 'بثوث ليشس';

  @override
  String get stormMoveToStart => 'حَرِك لتبدأ';

  @override
  String get stormYouPlayTheWhitePiecesInAllPuzzles => 'أنت تلعب بالقطع البيضاء في جميع الألغاز';

  @override
  String get stormYouPlayTheBlackPiecesInAllPuzzles => 'أنت تلعب بالقطع السوداء في جميع الألغاز';

  @override
  String get stormPuzzlesSolved => 'الألغاز التي حللتها سابقا';

  @override
  String get stormNewDailyHighscore => 'حققت نتيجة يومية جديدة!';

  @override
  String get stormNewWeeklyHighscore => 'حققت نتيجة أسبوعية جديدة!';

  @override
  String get stormNewMonthlyHighscore => 'حققت نتيجة شهرية جديدة!';

  @override
  String get stormNewAllTimeHighscore => 'أعلى مستوى جديد على الإطلاق!';

  @override
  String stormPreviousHighscoreWasX(String param) {
    return 'النتيجة العالية السابقة كانت $param';
  }

  @override
  String get stormPlayAgain => 'إلعب مرة أخرى';

  @override
  String stormHighscoreX(String param) {
    return 'أعلى نتيجة: $param';
  }

  @override
  String get stormScore => 'النتيجة';

  @override
  String get stormMoves => 'نقلة';

  @override
  String get stormAccuracy => 'الدقة';

  @override
  String get stormCombo => 'مجموعة';

  @override
  String get stormTime => 'الوقت';

  @override
  String get stormTimePerMove => 'الوقت لكل نقلة';

  @override
  String get stormHighestSolved => 'تقييم أصعب لغز تم حله';

  @override
  String get stormPuzzlesPlayed => 'الألغاز التي لعبتها سابقا';

  @override
  String get stormNewRun => 'سباق جديد';

  @override
  String get stormEndRun => 'انهاء السباق';

  @override
  String get stormHighscores => 'أعلى النتائج';

  @override
  String get stormViewBestRuns => 'اعرض أفضل الجولات';

  @override
  String get stormBestRunOfDay => 'أفضل جولة لك اليوم';

  @override
  String get stormRuns => 'جولات';

  @override
  String get stormGetReady => 'استعد!';

  @override
  String get stormWaitingForMorePlayers => 'ينتظر انضمام مزيد من الاعبين...';

  @override
  String get stormRaceComplete => 'انتهى السباق!';

  @override
  String get stormSpectating => 'تفرج';

  @override
  String get stormJoinTheRace => 'انضم للسباق!';

  @override
  String get stormStartTheRace => 'بدء السباق';

  @override
  String stormYourRankX(String param) {
    return 'رتبتك $param';
  }

  @override
  String get stormWaitForRematch => 'انتظر إعادة اللعب';

  @override
  String get stormNextRace => 'السباق التالي';

  @override
  String get stormJoinRematch => 'انضم إلى المباراة من جديد';

  @override
  String get stormWaitingToStart => 'ينتظر البدء';

  @override
  String get stormCreateNewGame => 'أنشئ لعبة جديدة';

  @override
  String get stormJoinPublicRace => 'انضم للسباقٍ علني';

  @override
  String get stormRaceYourFriends => 'واجه أصدقائك';

  @override
  String get stormSkip => 'تخطى';

  @override
  String get stormSkipHelp => 'يمكنك تخطي حركة واحدة في كل سباق:';

  @override
  String get stormSkipExplanation => 'تخطى هذه الحركة للحفاظ على سلسلة الانتصارات.';

  @override
  String get stormFailedPuzzles => 'الألغاز التي فشلت في حلها';

  @override
  String get stormSlowPuzzles => 'ألغاز بطيئة';

  @override
  String get stormSkippedPuzzle => 'الألغاز التي تخطيتها';

  @override
  String get stormThisWeek => 'هذا الأسبوع';

  @override
  String get stormThisMonth => 'هذا الشهر';

  @override
  String get stormAllTime => 'كل الأوقات';

  @override
  String get stormClickToReload => 'اضغط لإعادة التحميل';

  @override
  String get stormThisRunHasExpired => 'انتهت صلاحية هذا السباق!';

  @override
  String get stormThisRunWasOpenedInAnotherTab => 'تم فتح هذا السباق في علامة تبويب أخرى!';

  @override
  String stormXRuns(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count جولة',
      many: '$count جولة',
      few: '$count جولات',
      two: 'جولتان',
      one: 'جولة واحدة',
      zero: 'لا جولات',
    );
    return '$_temp0';
  }

  @override
  String stormPlayedNbRunsOfPuzzleStorm(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'لعبت $count جولة من $param2',
      many: 'لعبت $count جولة من $param2',
      few: 'لعبت $count جولات من $param2',
      two: 'لعبت جولتين من $param2',
      one: 'لعبت جولة واحدة من $param2',
      zero: 'لم تلعب أي جولة $param2',
    );
    return '$_temp0';
  }

  @override
  String get studyShareAndExport => 'مشاركة و تصدير';

  @override
  String get studyStart => 'ابدأ';

  @override
  String get broadcastBroadcasts => 'البثوث';

  @override
  String get broadcastStartDate => 'تاريخ البدء في المنطقة الزمنية الخاصة بك';
}
