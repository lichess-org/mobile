// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'l10n.dart';

// ignore_for_file: type=lint

/// The translations for Lithuanian (`lt`).
class AppLocalizationsLt extends AppLocalizations {
  AppLocalizationsLt([String locale = 'lt']) : super(locale);

  @override
  String get mobileAllGames => 'All games';

  @override
  String get mobileAreYouSure => 'Are you sure?';

  @override
  String get mobileCancelTakebackOffer => 'Cancel takeback offer';

  @override
  String get mobileClearButton => 'Clear';

  @override
  String get mobileCorrespondenceClearSavedMove => 'Clear saved move';

  @override
  String get mobileCustomGameJoinAGame => 'Join a game';

  @override
  String get mobileFeedbackButton => 'Feedback';

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
  String get mobileHideVariation => 'Hide variation';

  @override
  String get mobileHomeTab => 'Home';

  @override
  String get mobileLiveStreamers => 'Live streamers';

  @override
  String get mobileMustBeLoggedIn => 'You must be logged in to view this page.';

  @override
  String get mobileNoSearchResults => 'No results';

  @override
  String get mobileNotFollowingAnyUser => 'You are not following any user.';

  @override
  String get mobileOkButton => 'OK';

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
  String get mobilePuzzleStreakAbortWarning =>
      'You will lose your current streak and your score will be saved.';

  @override
  String get mobilePuzzleThemesSubtitle =>
      'Play puzzles from your favorite openings, or choose a theme.';

  @override
  String get mobilePuzzlesTab => 'Puzzles';

  @override
  String get mobileRecentSearches => 'Recent searches';

  @override
  String get mobileRemoveBookmark => 'Remove bookmark';

  @override
  String get mobileSettingsImmersiveMode => 'Immersive mode';

  @override
  String get mobileSettingsImmersiveModeSubtitle =>
      'Hide system UI while playing. Use this if you are bothered by the system\'s navigation gestures at the edges of the screen. Applies to game and puzzle screens.';

  @override
  String get mobileSettingsTab => 'Settings';

  @override
  String get mobileShareGamePGN => 'Share PGN';

  @override
  String get mobileShareGameURL => 'Share game URL';

  @override
  String get mobileSharePositionAsFEN => 'Share position as FEN';

  @override
  String get mobileSharePuzzle => 'Share this puzzle';

  @override
  String get mobileShowComments => 'Show comments';

  @override
  String get mobileShowResult => 'Show result';

  @override
  String get mobileShowVariations => 'Show variations';

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
  String get mobileWatchTab => 'Watch';

  @override
  String get activityActivity => 'Veikla';

  @override
  String get activityHostedALiveStream => 'Organizavo transliaciją';

  @override
  String activityRankedInSwissTournament(String param1, String param2) {
    return 'Reitinguotas #$param1 iš $param2';
  }

  @override
  String get activitySignedUp => 'Užsiregistravo „Lichess“';

  @override
  String activitySupportedNbMonths(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Remia lichess.org $count mėn. kaip „$param2“',
      many: 'Remia lichess.org $count mėn. kaip „$param2“',
      few: 'Remia lichess.org $count mėn. kaip „$param2“',
      one: 'Remia lichess.org $count mėn. kaip „$param2“',
    );
    return '$_temp0';
  }

  @override
  String activityPracticedNbPositions(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Praktikavosi $count pozicijų per „$param2“',
      many: 'Praktikavosi $count pozicijų per „$param2“',
      few: 'Praktikavosi $count pozicijas per „$param2“',
      one: 'Praktikavosi $count poziciją per „$param2“',
    );
    return '$_temp0';
  }

  @override
  String activitySolvedNbPuzzles(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Išsprendė $count taktinių užduočių',
      many: 'Išsprendė $count taktinių užduočių',
      few: 'Išsprendė $count taktines užduotis',
      one: 'Išsprendė $count taktinę užduotį',
    );
    return '$_temp0';
  }

  @override
  String activityPlayedNbGames(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Sužaidė $count „$param2“ partijų',
      many: 'Sužaidė $count „$param2“ partijų',
      few: 'Sužaidė $count „$param2“ partijas',
      one: 'Sužaidė $count „$param2“ partiją',
    );
    return '$_temp0';
  }

  @override
  String activityPostedNbMessages(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Parašė $count žinučių temoje „$param2“',
      many: 'Parašė $count žinučių temoje „$param2“',
      few: 'Parašė $count žinutes temoje „$param2“',
      one: 'Parašė $count žinutę temoje „$param2“',
    );
    return '$_temp0';
  }

  @override
  String activityPlayedNbMoves(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Sužaidė $count ėjimų',
      many: 'Sužaidė $count ėjimų',
      few: 'Sužaidė $count ėjimus',
      one: 'Sužaidė $count ėjimą',
    );
    return '$_temp0';
  }

  @override
  String activityInNbCorrespondenceGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'per $count korespondencinių partijų',
      many: 'per $count korespondencinių partijų',
      few: 'per $count korespondencines partijas',
      one: 'per $count korespondencinę partiją',
    );
    return '$_temp0';
  }

  @override
  String activityCompletedNbGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Užbaigė $count korespondencinių partijų',
      many: 'Užbaigė $count korespondencinių partijų',
      few: 'Užbaigė $count korespondencines partijas',
      one: 'Užbaigė $count korespondencinę partiją',
    );
    return '$_temp0';
  }

  @override
  String activityCompletedNbVariantGames(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Baigta $count $param2 korespondencinių partijų',
      many: 'Baigta $count $param2 korespondencinių partijų',
      few: 'Baigtos $count $param2 korespondencinės partijos',
      one: 'Baigta $count $param2 korespondencinės partija',
    );
    return '$_temp0';
  }

  @override
  String activityFollowedNbPlayers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Pradėjo sekti $count žaidėjų',
      many: 'Pradėjo sekti $count žaidėjų',
      few: 'Pradėjo sekti $count žaidėjus',
      one: 'Pradėjo sekti $count žaidėją',
    );
    return '$_temp0';
  }

  @override
  String activityGainedNbFollowers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Sulaukė $count sekėjų',
      many: 'Sulaukė $count sekėjų',
      few: 'Sulaukė $count sekėjų',
      one: 'Sulaukė $count sekėjo',
    );
    return '$_temp0';
  }

  @override
  String activityHostedNbSimuls(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Organizavo $count simulų',
      many: 'Organizavo $count simulų',
      few: 'Organizavo $count simulus',
      one: 'Organizavo $count simulą',
    );
    return '$_temp0';
  }

  @override
  String activityJoinedNbSimuls(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Dalyvavo $count-yje simulų',
      many: 'Dalyvavo $count-yje simulų',
      few: 'Dalyvavo $count-se simuluose',
      one: 'Dalyvavo $count-me simule',
    );
    return '$_temp0';
  }

  @override
  String activityCreatedNbStudies(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Sukūrė $count naujų studijų',
      many: 'Sukūrė $count naujų studijų',
      few: 'Sukūrė $count naujas studijas',
      one: 'Sukūrė $count naują studiją',
    );
    return '$_temp0';
  }

  @override
  String activityCompetedInNbTournaments(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Varžėsi $count-yje turnyrų',
      many: 'Varžėsi $count-yje turnyrų',
      few: 'Varžėsi $count-uose turnyruose',
      one: 'Varžėsi $count-ame turnyre',
    );
    return '$_temp0';
  }

  @override
  String activityRankedInTournament(int count, String param2, String param3, String param4) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Užėmė #$count (tarp $param2% geriausiųjų) su $param3 partijų, žaidžiant „$param4“',
      many: 'Užėmė #$count (tarp $param2% geriausiųjų) su $param3 partijų, žaidžiant „$param4“',
      few: 'Užėmė #$count (tarp $param2% geriausiųjų) su $param3 partijomis, žaidžiant „$param4“',
      one: 'Užėmė #$count (tarp $param2% geriausiųjų) su $param3 partija, žaidžiant „$param4“',
    );
    return '$_temp0';
  }

  @override
  String activityCompetedInNbSwissTournaments(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Dalyvavo $count šveicariškų turnyrų',
      many: 'Dalyvavo $count šveicariško turnyro',
      few: 'Dalyvavo $count šveicariškuose turnyruose',
      one: 'Dalyvavo $count šveicariškame turnyre',
    );
    return '$_temp0';
  }

  @override
  String activityJoinedNbTeams(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Prisijungė prie $count komandų',
      many: 'Prisijungė prie $count komandų',
      few: 'Prisijungė prie $count komandų',
      one: 'Prisijungė prie $count komandos',
    );
    return '$_temp0';
  }

  @override
  String get arenaArena => 'Arena';

  @override
  String get arenaArenaTournaments => 'Arenos turnyrai';

  @override
  String get arenaIsItRated => 'Ar jis vertinamas?';

  @override
  String get arenaWillBeNotified =>
      'Jums bus pranešta apie turnyro pradžią, tad laukdami galite saugiai žaisti kitoje kortelėje.';

  @override
  String get arenaIsRated => 'Šis turnyras yra vertinamas ir turės įtakos jūsų reitingui.';

  @override
  String get arenaIsNotRated =>
      'Šis turnyras *nėra* vertinamas ir *neturės* įtakos jūsų reitingui.';

  @override
  String get arenaSomeRated => 'Kai kurie turnyrai yra vertinami ir turės įtakos jūsų reitingui.';

  @override
  String get arenaHowAreScoresCalculated => 'Kaip apskaičiuojami taškai?';

  @override
  String get arenaHowAreScoresCalculatedAnswer =>
      'Pergalė vertinama 2 taškais, lygiosios: 1 tašku, o pralaimėjimas taškų nevertas.\nJeigu laimite dvi partijas iš eilės, pradėsite dvigubų taškų seriją, žymimą liepsnos piktograma.\nTolimesnės partijos bus vertos dvigubai daugiau taškų tol, kol nebelaimėsite.\nT. y., pergalė bus verta 4 taškų, lygiosios: 2 taškų, o pralaimėjimas taškų nepelnys.\n\nPavyzdžiui, dvi pergalės ir tada įvykusios lygiosios bus įvertinta 6 taškais: 2 + 2 + (2 x 1)';

  @override
  String get arenaBerserk => 'Įsiutimas arenoje';

  @override
  String get arenaBerserkAnswer =>
      'Žaidėjui partijos pradžioje paspaudus mygtuką „Įsiūtis“, jie praras pusę suteikiamo laiko ėjimams, tačiau pergalė bus verta vieno papildomo turnyrinio taško.\n\n„Įsiūtis“ laiko kontrolėse su prieaugiu kartu dar panaikins ir jį (1+2 yra išimtis, bus duodama 1+0).\n\n„Įsiūtis“ nėra galimas partijose su nuliniu pradiniu laiku (0+1, 0+2).\n\n„Įsiūtis“ suteiks papildomą tašką tik sužaidus bent 7 ėjimus partijoje.';

  @override
  String get arenaHowIsTheWinnerDecided => 'Kaip nustatomas laimėtojas?';

  @override
  String get arenaHowIsTheWinnerDecidedAnswer =>
      'Žaidėjas (-ai), surinkęs (-ę) daugiausiai taškų pasibaigus nustatytam turnyro laiko limitui, bus paskelbtas (-i) laimėtoju (-ais).';

  @override
  String get arenaHowDoesPairingWork => 'Kaip veikia suporavimas?';

  @override
  String get arenaHowDoesPairingWorkAnswer =>
      'Turnyro pradžioje žaidėjai suporuojami atsižvelgiant į jų reitingus.\nKai tik baigiate partiją, grįžkite į turnyro laukiamąjį: tuomet būsite suporuoti su žaidėju, artimus jūsų reitingui. Tai užtikrina mažiausią laukimo laiką, visgi jūs galite nesusidurti su visais kitais turnyro žaidėjais.\nŽaisdami greitai ir grįždami į laukiamąjį sužaisite daugiau partijų ir galėsite pelnyti daugiau taškų.';

  @override
  String get arenaHowDoesItEnd => 'Kaip jis baigiasi?';

  @override
  String get arenaHowDoesItEndAnswer =>
      'Turnyras turi atgalinio skaičiavimo laikmatį. Jam pasiekus nulį, turnyro statistika užšaldoma bei paskelbiamas laimėtojas. Dar vykstančios partijos privalo būti užbaigtos, tačiau jos nebesiskaičiuoja turnyrui.';

  @override
  String get arenaOtherRules => 'Kitos svarbios taisyklės';

  @override
  String get arenaThereIsACountdown =>
      'Jūsų pirmajam ėjimui yra laiko limitas. Jei per šį laiką neatliksite ėjimo, jūsų varžovui bus įskaityta pergalė.';

  @override
  String get arenaThisIsPrivate => 'Tai yra privatus turnyras';

  @override
  String arenaShareUrl(String param) {
    return 'Pasidalinkite šiuo adresu su žaidėjais: $param';
  }

  @override
  String arenaDrawStreakStandard(String param) {
    return 'Lygiųjų sekos: kai žaidėjas turi vienas po kitos einančias lygiąsias arenoje, tik pirmosios, arba trunkančios ilgiau nei $param ėjimų standartiniuose žaidimuose, lygiosios suteiks tašką. Lygiųjų seka gali būti nutraukta tik pergale, ne pralaimėjimu ar lygiosiomis.';
  }

  @override
  String get arenaDrawStreakVariants =>
      'Minimalus žaidimo ilgis užtikrinantis taškus skiriasi pagal variantą. Pateiktoje lentelėje nurodomi slenksčiai kiekvienam variantui.';

  @override
  String get arenaVariant => 'Variantas';

  @override
  String get arenaMinimumGameLength => 'Minimalus partijos ilgis';

  @override
  String get arenaHistory => 'Arenų istorija';

  @override
  String get arenaNewTeamBattle => 'Nauja komandinė kova';

  @override
  String get arenaCustomStartDate => 'Kita pradžios data';

  @override
  String get arenaCustomStartDateHelp =>
      'Jūsų laiko zonoje. Turi pirmenybę prieš \"Laikas iki turnyro pradžios\" nustatymą';

  @override
  String get arenaAllowBerserk => 'Leisti \"įsiūtį\"';

  @override
  String get arenaAllowBerserkHelp =>
      'Leisti žaidėjams gauti papildomą tašką, perpus sumažinant savo laiką';

  @override
  String get arenaAllowChatHelp => 'Leisti žaidėjams kalbėtis pokalbių kambaryje';

  @override
  String get arenaArenaStreaks => 'Arenos serijos';

  @override
  String get arenaArenaStreaksHelp =>
      'Po dviejų pergalių kiti laimėjimai suteikia keturis taškus vietoje dviejų.';

  @override
  String get arenaNoBerserkAllowed => 'Negalimas Įsiutis';

  @override
  String get arenaNoArenaStreaks => 'Negalimos Arenos sekos';

  @override
  String get arenaAveragePerformance => 'Vidutinis pasirodymas';

  @override
  String get arenaAverageScore => 'Vidutiniškai taškų';

  @override
  String get arenaMyTournaments => 'Mano turnyrai';

  @override
  String get arenaEditTournament => 'Redaguoti turnyrą';

  @override
  String get arenaEditTeamBattle => 'Redaguoti komandų turnyrą';

  @override
  String get arenaDefender => 'Ginantis titulą';

  @override
  String get arenaPickYourTeam => 'Pasirinkti savo komandą';

  @override
  String get arenaWhichTeamWillYouRepresentInThisBattle =>
      'Kuriai komandai atstovausite šiame mūšyje?';

  @override
  String get arenaYouMustJoinOneOfTheseTeamsToParticipate =>
      'Norėdami dalyvauti, turite prisijungti prie vienos iš šių komandų!';

  @override
  String get arenaCreated => 'Sukurtas';

  @override
  String get arenaRecentlyPlayed => 'Neseniai žaista';

  @override
  String get arenaBestResults => 'Geriausi rezultatai';

  @override
  String get arenaTournamentStats => 'Turnyro statistika';

  @override
  String get arenaRankAvgHelp =>
      'Reitingo vidurkis-tai jūsų reitingas procentais. Mažesnis yra geresnis.\n\nPavyzdžiui, užėmus 3 vietą 100 žaidėjų turnyre = 3%. Užėmus 10-ą vietą 1000 žaidėjų turnyre = 1%.';

  @override
  String get arenaMedians => 'medianos';

  @override
  String arenaAllAveragesAreX(String param) {
    return 'Visi vidurkiai šiame puslapyje yra $param.';
  }

  @override
  String get arenaTotal => 'Iš viso';

  @override
  String get arenaPointsAvg => 'Taškų vidurkis';

  @override
  String get arenaPointsSum => 'Taškų suma';

  @override
  String get arenaRankAvg => 'Reitingo vidurkis';

  @override
  String get arenaTournamentWinners => 'Turnyro nugalėtojai';

  @override
  String get arenaTournamentShields => 'Turnyro trofėjus';

  @override
  String get arenaOnlyTitled => 'Tik tituluoti žaidėjai';

  @override
  String get arenaOnlyTitledHelp => 'Prisijungti į turnyrą būtinas oficialus titulas';

  @override
  String get arenaTournamentPairingsAreNowClosed => 'Suporavimai turnyrui jau baigėsi.';

  @override
  String get arenaBerserkRate => 'Įsiūčio dažnis';

  @override
  String arenaDrawingWithinNbMoves(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Lygiosios per pirmuosius $count ėjimų nesuteiks taškų nė vienam žaidėjui.',
      many: 'Lygiosios per pirmuosius $count ėjimų nesuteiks taškų nė vienam žaidėjui.',
      few: 'Lygiosios per pirmuosius $count ėjimus nesuteiks taškų nė vienam žaidėjui.',
      one: 'Lygiosios per pirmąjį ėjimą nesuteiks taškų nė vienam žaidėjui.',
    );
    return '$_temp0';
  }

  @override
  String arenaViewAllXTeams(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Peržvelgti visas $count komandų',
      many: 'Peržvelgti visas $count komandų',
      few: 'Peržvelgti visas $count komandas',
      one: 'Peržvelgti komandą',
    );
    return '$_temp0';
  }

  @override
  String get broadcastBroadcasts => 'Transliacijos';

  @override
  String get broadcastMyBroadcasts => 'Mano transliacijos';

  @override
  String get broadcastLiveBroadcasts => 'Vykstančios turnyrų transliacijos';

  @override
  String get broadcastBroadcastCalendar => 'Transliavimo kalendorius';

  @override
  String get broadcastNewBroadcast => 'Nauja transliacija';

  @override
  String get broadcastSubscribedBroadcasts => 'Prenumeruojamos transliacijos';

  @override
  String get broadcastAboutBroadcasts => 'Apie transliacijas';

  @override
  String get broadcastHowToUseLichessBroadcasts => 'Kaip naudotis Lichess transliacijomis.';

  @override
  String get broadcastTheNewRoundHelp =>
      'Naujajame ture bus tie patys nariai ir bendradarbiai, kaip ir ankstesniame.';

  @override
  String get broadcastAddRound => 'Pridėti raundą';

  @override
  String get broadcastOngoing => 'Vykstančios';

  @override
  String get broadcastUpcoming => 'Artėjančios';

  @override
  String get broadcastRoundName => 'Raundo pavadinimas';

  @override
  String get broadcastRoundNumber => 'Raundo numeris';

  @override
  String get broadcastTournamentName => 'Turnyro pavadinimas';

  @override
  String get broadcastTournamentDescription => 'Trumpas turnyro aprašymas';

  @override
  String get broadcastFullDescription => 'Pilnas renginio aprašymas';

  @override
  String broadcastFullDescriptionHelp(String param1, String param2) {
    return 'Neprivalomas pilnas transliacijos aprašymas. Galima naudoti $param1. Ilgis negali viršyti $param2 simbolių.';
  }

  @override
  String get broadcastSourceSingleUrl => 'PGN šaltinio URL';

  @override
  String get broadcastSourceUrlHelp =>
      'URL, į kurį „Lichess“ kreipsis gauti PGN atnaujinimus. Privalo būti viešai pasiekiamas internete.';

  @override
  String get broadcastSourceGameIds => 'Iki 64 Lichess žaidimo ID, atskirtų tarpais.';

  @override
  String broadcastStartDateTimeZone(String param) {
    return 'Turnyro pradžia vietos laiku: $param';
  }

  @override
  String get broadcastStartDateHelp => 'Neprivaloma; tik jeigu žinote, kada prasideda renginys';

  @override
  String get broadcastCurrentGameUrl => 'Dabartinio žaidimo adresas';

  @override
  String get broadcastDownloadAllRounds => 'Atsisiųsti visus raundus';

  @override
  String get broadcastResetRound => 'Atstatyti raundą';

  @override
  String get broadcastDeleteRound => 'Ištrinti raundą';

  @override
  String get broadcastDefinitivelyDeleteRound => 'Užtikrintai ištrinti raundą ir jo partijas.';

  @override
  String get broadcastDeleteAllGamesOfThisRound =>
      'Ištrinti visas partijas šiame raunde. Norint jas perkurti reikės aktyvaus šaltinio.';

  @override
  String get broadcastEditRoundStudy => 'Keisti raundo studiją';

  @override
  String get broadcastDeleteTournament => 'Ištrinti šį turnyrą';

  @override
  String get broadcastDefinitivelyDeleteTournament =>
      'Užtikrintai ištrinti visą turnyrą, visus raundus ir visas jų partijas.';

  @override
  String get broadcastShowScores => 'Rodyti žaidėjų balus pagal partijų rezultatus';

  @override
  String get broadcastReplacePlayerTags =>
      'Pasirenkama: pakeiskite žaidėjų vardus, reitingus ir titulus';

  @override
  String get broadcastFideFederations => 'FIDE federacijos';

  @override
  String get broadcastTop10Rating => '10 aukščiausių reitingų';

  @override
  String get broadcastFidePlayers => 'FIDE žaidėjai';

  @override
  String get broadcastFidePlayerNotFound => 'FIDE žaidėjas nerastas';

  @override
  String get broadcastFideProfile => 'FIDE profilis';

  @override
  String get broadcastFederation => 'Federacija';

  @override
  String get broadcastAgeThisYear => 'Amžius šiemet';

  @override
  String get broadcastUnrated => 'Nereitinguota(s)';

  @override
  String get broadcastRecentTournaments => 'Neseniai sukurti turnyrai';

  @override
  String get broadcastOpenLichess => 'Atverti Lichess-e';

  @override
  String get broadcastTeams => 'Komandos';

  @override
  String get broadcastBoards => 'Lentos';

  @override
  String get broadcastOverview => 'Apžvalga';

  @override
  String get broadcastSubscribeTitle =>
      'Užsakykite pranešimą apie kiekvieno turo pradžią. Paskyros nustatymuose galite perjungti transliacijų skambėjimo signalą arba tiesioginius pranešimus.';

  @override
  String get broadcastUploadImage => 'Įkelkite turnyro paveikslėlį';

  @override
  String get broadcastNoBoardsYet => 'Dar nėra lentų. Jos bus rodomos, kai bus įkeltos partijos.';

  @override
  String broadcastBoardsCanBeLoaded(String param) {
    return 'Lentas galima įkelti iš šaltinio arba per $param';
  }

  @override
  String broadcastStartsAfter(String param) {
    return 'Pradedama po $param';
  }

  @override
  String get broadcastStartVerySoon => 'Transliacija prasidės visai netrukus.';

  @override
  String get broadcastNotYetStarted => 'Transliacija dar neprasidėjo.';

  @override
  String get broadcastOfficialWebsite => 'Oficialus tinklapis';

  @override
  String get broadcastStandings => 'Rezultatai';

  @override
  String get broadcastOfficialStandings => 'Oficialūs rezultatai';

  @override
  String broadcastIframeHelp(String param) {
    return 'Daugiau parinkčių $param';
  }

  @override
  String get broadcastWebmastersPage => 'žiniatinklio valdytojų puslapis';

  @override
  String broadcastPgnSourceHelp(String param) {
    return 'Viešas realaus laiko PGN šaltinis šiam turui. Taip pat siūlome $param greitesniam ir efektyvesniam sinchronizavimui.';
  }

  @override
  String get broadcastEmbedThisBroadcast => 'Įterpkite šią transliaciją į savo svetainę';

  @override
  String broadcastEmbedThisRound(String param) {
    return 'Įterpkite $param į savo svetainę';
  }

  @override
  String get broadcastRatingDiff => 'Reitingo skirtumas';

  @override
  String get broadcastGamesThisTournament => 'Partijos šiame turnyre';

  @override
  String get broadcastScore => 'Taškų skaičius';

  @override
  String get broadcastAllTeams => 'Visos komandos';

  @override
  String get broadcastTournamentFormat => 'Turnyro formatas';

  @override
  String get broadcastTournamentLocation => 'Turnyro vieta';

  @override
  String get broadcastTopPlayers => 'Geriausi žaidėjai';

  @override
  String get broadcastTimezone => 'Laiko juosta';

  @override
  String get broadcastFideRatingCategory => 'FIDE reitingo kategorija';

  @override
  String get broadcastOptionalDetails => 'Papildoma informacija';

  @override
  String get broadcastPastBroadcasts => 'Ankstesnės transliacijos';

  @override
  String get broadcastAllBroadcastsByMonth => 'Rodyti visas transliacijas pagal mėnesį';

  @override
  String get broadcastBackToLiveMove => 'Grįžti prie esamo ėjimo';

  @override
  String get broadcastSinceHideResults =>
      'Kadangi pasirinkote nerodyti rezutatų, visos peržiūros lentos yra tuščios, kad neišduotų jų.';

  @override
  String get broadcastLiveboard => 'Esama lenta';

  @override
  String broadcastNbBroadcasts(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count transliacijų',
      many: '$count transliacijos',
      few: '$count transliacijos',
      one: '$count transliacija',
    );
    return '$_temp0';
  }

  @override
  String broadcastNbViewers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count žiūrovų',
      many: '$count žiūrovų',
      few: '$count žiūrovai',
      one: '$count žiūrovas',
    );
    return '$_temp0';
  }

  @override
  String challengeChallengesX(String param1) {
    return 'Iššūkiai: $param1';
  }

  @override
  String get challengeChallengeToPlay => 'Iškelti iššūkį';

  @override
  String get challengeChallengeDeclined => 'Iššūkis atmestas';

  @override
  String get challengeChallengeAccepted => 'Iššūkis priimtas!';

  @override
  String get challengeChallengeCanceled => 'Iššūkis atšauktas.';

  @override
  String get challengeRegisterToSendChallenges => 'Norėdami kurti iššūkius užsiregistruokite.';

  @override
  String challengeYouCannotChallengeX(String param) {
    return 'Negalite kelti iššūkio $param.';
  }

  @override
  String challengeXDoesNotAcceptChallenges(String param) {
    return '$param nepriima iššūkių.';
  }

  @override
  String challengeYourXRatingIsTooFarFromY(String param1, String param2) {
    return 'Jūsų $param1 reitingas per toli nuo $param2.';
  }

  @override
  String challengeCannotChallengeDueToProvisionalXRating(String param) {
    return 'Negalima sukurti iššūkio dėl laikino $param reitingo.';
  }

  @override
  String challengeXOnlyAcceptsChallengesFromFriends(String param) {
    return '$param priima iššūkius tik iš draugų.';
  }

  @override
  String get challengeDeclineGeneric => 'Šiuo metu iššūkių nepriimu.';

  @override
  String get challengeDeclineLater => 'Šiuo metu nepriimu iššūkių, pabandykite dar kartą vėliau.';

  @override
  String get challengeDeclineTooFast =>
      'Ši laiko kontrolė man per greita, kitame iššūkyje nurodykite lėtesnį žaidimą.';

  @override
  String get challengeDeclineTooSlow =>
      'Ši laiko kontrolė man per lėta, kitame iššūkyje nurodykite greitesnį žaidimą.';

  @override
  String get challengeDeclineTimeControl => 'Nepriimu iššūkių su šia laiko kontrole.';

  @override
  String get challengeDeclineRated => 'Vietoje šio iššūkio atsiųskite vertinamą iššūkį.';

  @override
  String get challengeDeclineCasual => 'Vietoje šio iššūkio atsiųskite nevertinamą iššūkį.';

  @override
  String get challengeDeclineStandard => 'Šiuo metu nepriimu variantų iššūkių.';

  @override
  String get challengeDeclineVariant => 'Šiuo metu nenoriu žaisti šio varianto.';

  @override
  String get challengeDeclineNoBot => 'Nepriimu iššūkių iš programų.';

  @override
  String get challengeDeclineOnlyBot => 'Priimu iššūkius tik iš programų.';

  @override
  String get challengeInviteLichessUser => 'Arba pakvieskite Lichess vartotoją:';

  @override
  String get contactContact => 'Susisiekite';

  @override
  String get contactContactLichess => 'Susisiekite su „Lichess“';

  @override
  String get coordinatesCoordinates => 'Koordinatės';

  @override
  String get coordinatesCoordinateTraining => 'Koordinačių treniruotė';

  @override
  String coordinatesAverageScoreAsWhiteX(String param) {
    return 'Vidutinis rezultatas baltaisiais: $param';
  }

  @override
  String coordinatesAverageScoreAsBlackX(String param) {
    return 'Vidutinis rezultatas juodaisiais: $param';
  }

  @override
  String get coordinatesKnowingTheChessBoard =>
      'Šachmatų lentos koordinačių žinojimas yra ypač svarbus įgūdis:';

  @override
  String get coordinatesMostChessCourses =>
      'Dauguma šachmatų kursų ir pratimų plačiai naudoja algebrinį žymėjimą.';

  @override
  String get coordinatesTalkToYourChessFriends =>
      'Tai leidžia paprasčiau kalbėti su jūsų šachmatų draugais, kadangi abu suprantate „šachmatų kalbą“.';

  @override
  String get coordinatesYouCanAnalyseAGameMoreEffectively =>
      'Galite efektyviau analizuoti partijas, kadangi nereikia ieškoti langelių pavadinimų.';

  @override
  String get coordinatesACoordinateAppears =>
      'Ant lentos pateikiama koordinatė ir jums reikia spustelti ant atitinkamo langelio.';

  @override
  String get coordinatesASquareIsHighlightedExplanation =>
      'Ant lentos paryškinamas langelis ir jums reikia spustelti ant atitinkamos koordinatės (pvz. \"e4\").';

  @override
  String get coordinatesYouHaveThirtySeconds =>
      'Turite 30 sekundžių pažymėti kiek galima daugiau langelių!';

  @override
  String get coordinatesGoAsLongAsYouWant => 'Žymėkite kiek tik norite, laiko limito nėra!';

  @override
  String get coordinatesShowCoordinates => 'Rodyti koordinates';

  @override
  String get coordinatesShowCoordsOnAllSquares => 'Kiekvieno laukelio koordinatės';

  @override
  String get coordinatesShowPieces => 'Rodyti figūras';

  @override
  String get coordinatesStartTraining => 'Pradėti treniruotę';

  @override
  String get coordinatesFindSquare => 'Rasti langelį';

  @override
  String get coordinatesNameSquare => 'Pavadinti langelį';

  @override
  String get coordinatesPracticeOnlySomeFilesAndRanks =>
      'Treniruotis tik kai kurias statines ir gulstines';

  @override
  String get patronDonate => 'Paremti';

  @override
  String get patronLichessPatron => 'Lichess rėmėjas';

  @override
  String perfStatPerfStats(String param) {
    return '$param statistika';
  }

  @override
  String get perfStatViewTheGames => 'Peržiūrėti partijas';

  @override
  String get perfStatProvisional => 'laikinas';

  @override
  String get perfStatNotEnoughRatedGames =>
      'Kol kas nesužaista pakankamai reitinguotų partijų, kad būtų sudarytas patikimas reitingas.';

  @override
  String perfStatProgressOverLastXGames(String param) {
    return 'Progresas per paskutines $param partijas:';
  }

  @override
  String perfStatRatingDeviation(String param) {
    return 'Reitingo paklaida: $param.';
  }

  @override
  String perfStatRatingDeviationTooltip(String param1, String param2, String param3) {
    return 'Žemesnė vertė reiškia, kad reitingas stabilesnis. Reikšmei esant virš $param1, reitingas laikomas laikinuoju. Norint būti paskelbtam reitingavimuose, ši reikšmė turi būti mažesnė, nei $param2 (standartiniuose šachmatuose) ar $param3 (variantuose).';
  }

  @override
  String get perfStatTotalGames => 'Viso partijų';

  @override
  String get perfStatRatedGames => 'Reitinguotų partijų';

  @override
  String get perfStatTournamentGames => 'Turnyrinių partijų';

  @override
  String get perfStatBerserkedGames => 'Įsiučio partijų';

  @override
  String get perfStatTimeSpentPlaying => 'Laiko praleista žaidžiant';

  @override
  String get perfStatAverageOpponent => 'Vidutinis priešininkas';

  @override
  String get perfStatVictories => 'Pergalių';

  @override
  String get perfStatDefeats => 'Pralaimėjimų';

  @override
  String get perfStatDisconnections => 'Atsijungimų';

  @override
  String get perfStatNotEnoughGames => 'Žaista nepakankamai partijų';

  @override
  String perfStatHighestRating(String param) {
    return 'Aukščiausias reitingas: $param';
  }

  @override
  String perfStatLowestRating(String param) {
    return 'Žemiausias reitingas: $param';
  }

  @override
  String perfStatFromXToY(String param1, String param2) {
    return 'nuo $param1 iki $param2';
  }

  @override
  String get perfStatWinningStreak => 'Pergalių iš eilės';

  @override
  String get perfStatLosingStreak => 'Pralaimėjimų iš eilės';

  @override
  String perfStatLongestStreak(String param) {
    return 'Daugiausia iš eilės: $param';
  }

  @override
  String perfStatCurrentStreak(String param) {
    return 'Kol kas iš eilės: $param';
  }

  @override
  String get perfStatBestRated => 'Geriausios reitinguotos pergalės';

  @override
  String get perfStatGamesInARow => 'Partijų žaista iš eilės';

  @override
  String get perfStatLessThanOneHour => 'Mažiau negu valanda tarp partijų';

  @override
  String get perfStatMaxTimePlaying => 'Daugiausia laiko praleista žaidžiant';

  @override
  String get perfStatNow => 'dabar';

  @override
  String get preferencesPreferences => 'Preferences';

  @override
  String get preferencesDisplay => 'Display';

  @override
  String get preferencesPrivacy => 'Privacy';

  @override
  String get preferencesNotifications => 'Notifications';

  @override
  String get preferencesPieceAnimation => 'Piece animation';

  @override
  String get preferencesMaterialDifference => 'Material difference';

  @override
  String get preferencesBoardHighlights => 'Board highlights (last move and check)';

  @override
  String get preferencesPieceDestinations => 'Piece destinations (valid moves and premoves)';

  @override
  String get preferencesBoardCoordinates => 'Board coordinates (A-H, 1-8)';

  @override
  String get preferencesMoveListWhilePlaying => 'Move list while playing';

  @override
  String get preferencesPgnPieceNotation => 'Move notation';

  @override
  String get preferencesChessPieceSymbol => 'Chess piece symbol';

  @override
  String get preferencesPgnLetter => 'Letter (K, Q, R, B, N)';

  @override
  String get preferencesZenMode => 'Zen mode';

  @override
  String get preferencesShowPlayerRatings => 'Show player ratings';

  @override
  String get preferencesShowFlairs => 'Show player flairs';

  @override
  String get preferencesExplainShowPlayerRatings =>
      'This hides all ratings from Lichess, to help focus on the chess. Rated games still impact your rating, this is only about what you get to see.';

  @override
  String get preferencesDisplayBoardResizeHandle => 'Show board resize handle';

  @override
  String get preferencesOnlyOnInitialPosition => 'Only on initial position';

  @override
  String get preferencesInGameOnly => 'In-game only';

  @override
  String get preferencesExceptInGame => 'Except in-game';

  @override
  String get preferencesChessClock => 'Chess clock';

  @override
  String get preferencesTenthsOfSeconds => 'Tenths of seconds';

  @override
  String get preferencesWhenTimeRemainingLessThanTenSeconds => 'When time remaining < 10 seconds';

  @override
  String get preferencesHorizontalGreenProgressBars => 'Horizontal green progress bars';

  @override
  String get preferencesSoundWhenTimeGetsCritical => 'Sound when time gets critical';

  @override
  String get preferencesGiveMoreTime => 'Give more time';

  @override
  String get preferencesGameBehavior => 'Game behaviour';

  @override
  String get preferencesHowDoYouMovePieces => 'How do you move pieces?';

  @override
  String get preferencesClickTwoSquares => 'Click two squares';

  @override
  String get preferencesDragPiece => 'Drag a piece';

  @override
  String get preferencesBothClicksAndDrag => 'Either';

  @override
  String get preferencesPremovesPlayingDuringOpponentTurn =>
      'Premoves (playing during opponent turn)';

  @override
  String get preferencesTakebacksWithOpponentApproval => 'Takebacks (with opponent approval)';

  @override
  String get preferencesInCasualGamesOnly => 'In casual games only';

  @override
  String get preferencesPromoteToQueenAutomatically => 'Promote to Queen automatically';

  @override
  String get preferencesExplainPromoteToQueenAutomatically =>
      'Hold the <ctrl> key while promoting to temporarily disable auto-promotion';

  @override
  String get preferencesWhenPremoving => 'When premoving';

  @override
  String get preferencesClaimDrawOnThreefoldRepetitionAutomatically =>
      'Claim draw on threefold repetition automatically';

  @override
  String get preferencesWhenTimeRemainingLessThanThirtySeconds =>
      'When time remaining < 30 seconds';

  @override
  String get preferencesMoveConfirmation => 'Move confirmation';

  @override
  String get preferencesExplainCanThenBeTemporarilyDisabled =>
      'Can be disabled during a game with the board menu';

  @override
  String get preferencesInCorrespondenceGames => 'Correspondence games';

  @override
  String get preferencesCorrespondenceAndUnlimited => 'Correspondence and unlimited';

  @override
  String get preferencesConfirmResignationAndDrawOffers => 'Confirm resignation and draw offers';

  @override
  String get preferencesCastleByMovingTheKingTwoSquaresOrOntoTheRook => 'Castling method';

  @override
  String get preferencesCastleByMovingTwoSquares => 'Move king two squares';

  @override
  String get preferencesCastleByMovingOntoTheRook => 'Move king onto rook';

  @override
  String get preferencesInputMovesWithTheKeyboard => 'Input moves with the keyboard';

  @override
  String get preferencesInputMovesWithVoice => 'Input moves with your voice';

  @override
  String get preferencesSnapArrowsToValidMoves => 'Snap arrows to valid moves';

  @override
  String get preferencesSayGgWpAfterLosingOrDrawing =>
      'Say \"Good game, well played\" upon defeat or draw';

  @override
  String get preferencesYourPreferencesHaveBeenSaved => 'Your preferences have been saved.';

  @override
  String get preferencesScrollOnTheBoardToReplayMoves => 'Scroll on the board to replay moves';

  @override
  String get preferencesCorrespondenceEmailNotification =>
      'Daily email listing your correspondence games';

  @override
  String get preferencesNotifyStreamStart => 'Streamer goes live';

  @override
  String get preferencesNotifyInboxMsg => 'New inbox message';

  @override
  String get preferencesNotifyForumMention => 'Forum comment mentions you';

  @override
  String get preferencesNotifyInvitedStudy => 'Study invite';

  @override
  String get preferencesNotifyGameEvent => 'Correspondence game updates';

  @override
  String get preferencesNotifyChallenge => 'Challenges';

  @override
  String get preferencesNotifyTournamentSoon => 'Tournament starting soon';

  @override
  String get preferencesNotifyTimeAlarm => 'Correspondence clock running out';

  @override
  String get preferencesNotifyBell => 'Bell notification within Lichess';

  @override
  String get preferencesNotifyPush => 'Device notification when you\'re not on Lichess';

  @override
  String get preferencesNotifyWeb => 'Browser';

  @override
  String get preferencesNotifyDevice => 'Device';

  @override
  String get preferencesBellNotificationSound => 'Bell notification sound';

  @override
  String get preferencesBlindfold => 'Blindfold';

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
  String get puzzleThemeAdvancedPawn => 'Pažengęs pėstininkas';

  @override
  String get puzzleThemeAdvancedPawnDescription =>
      'Pėstininkas, kuris keičiamas kita figūra, ar tuoj tai darys, čia yra esminė taktika.';

  @override
  String get puzzleThemeAdvantage => 'Pranašumas';

  @override
  String get puzzleThemeAdvantageDescription =>
      'Pasinaudokite proga įgauti esminį pranašumą. (200cp ≤ eval ≤ 600cp)';

  @override
  String get puzzleThemeAnastasiaMate => 'Anastasijos matas';

  @override
  String get puzzleThemeAnastasiaMateDescription =>
      'Žirgas ir valdovė arba bokštas bendromis jėgomis įkalina priešininko karalių tarp lentos krašto ir kitos figūros.';

  @override
  String get puzzleThemeArabianMate => 'Arabiškasis matas';

  @override
  String get puzzleThemeArabianMateDescription =>
      'Žirgas ir bokštas suvienija jėgas įkalindami priešininko karalių lentos kampe.';

  @override
  String get puzzleThemeAttackingF2F7 => 'f2 arba f7 puolimas';

  @override
  String get puzzleThemeAttackingF2F7Description =>
      'Puolimas, koncentruotas ties f2 ar f7 pėstininkais, panašiai kaip keptų kepenų debiute.';

  @override
  String get puzzleThemeAttraction => 'Trauka';

  @override
  String get puzzleThemeAttractionDescription =>
      'Apsikeitimas ar paaukojimas, skatinantis ar priverčiantis priešininko figūrą pajudėti į langelį, kuris leidžia kitą taktiką.';

  @override
  String get puzzleThemeBackRankMate => 'Paskutinės eilės matas';

  @override
  String get puzzleThemeBackRankMateDescription =>
      'Matas karaliui, esančiam namų eilėje, kai jis užblokuotas savo paties figūrų.';

  @override
  String get puzzleThemeBishopEndgame => 'Rikių endšpilis';

  @override
  String get puzzleThemeBishopEndgameDescription => 'Endšpilis tik su rikiais ir pėstininkais.';

  @override
  String get puzzleThemeBodenMate => 'Bodeno matas';

  @override
  String get puzzleThemeBodenMateDescription =>
      'Du puolantys rikiai susikryžiojančiose įstrižainėse atlieka matą priešininko karaliui, įkalintam draugiškų figūrų.';

  @override
  String get puzzleThemeCastling => 'Rokiruotės';

  @override
  String get puzzleThemeCastlingDescription =>
      'Parveskite karalių į saugią vietą ir panaudokite atakai bokštą.';

  @override
  String get puzzleThemeCapturingDefender => 'Nukirskite gynėją';

  @override
  String get puzzleThemeCapturingDefenderDescription =>
      'Pašalinkite figūrą, kuri yra kritiškai svarbi kitos figūros gynybai, paruošdami naujai neapsaugotą figūrą kirtimui kitu ėjimu.';

  @override
  String get puzzleThemeCrushing => 'Suspaudimas';

  @override
  String get puzzleThemeCrushingDescription =>
      'Pastebėkite priešininko klaidą ir įgaukite ryškią persvarą. (eval ≥ 600cp)';

  @override
  String get puzzleThemeDoubleBishopMate => 'Dvigubų rikių matas';

  @override
  String get puzzleThemeDoubleBishopMateDescription =>
      'Du gretimose įstrižainėse puolantys rikiai atlieka matą priešininko karaliui, įkalintam draugiškų figūrų.';

  @override
  String get puzzleThemeDovetailMate => 'Kozio matas';

  @override
  String get puzzleThemeDovetailMateDescription =>
      'Valdovė atlieka matą greta esančiam priešininko karaliui, kurio vieninteliai pabėgimo langeliai užimti draugiškų figūrų.';

  @override
  String get puzzleThemeEquality => 'Lygybė';

  @override
  String get puzzleThemeEqualityDescription =>
      'Grįžkite iš pralaiminčios pozicijos ir užsitikrinkite lygiąsias arba balansuotą poziciją. (eval ≤ 200cp)';

  @override
  String get puzzleThemeKingsideAttack => 'Karaliaus pusės ataka';

  @override
  String get puzzleThemeKingsideAttackDescription =>
      'Ataka į priešininko karalių po to, kai jis rokiravosi karaliaus pusėje.';

  @override
  String get puzzleThemeClearance => 'Išvalymas';

  @override
  String get puzzleThemeClearanceDescription =>
      'Ėjimas, dažnai su tempu, kuris išvalo langelį, eilutę ar įstrižainę kitai taktinei idėjai.';

  @override
  String get puzzleThemeDefensiveMove => 'Apsisaugantis ėjimas';

  @override
  String get puzzleThemeDefensiveMoveDescription =>
      'Tikslus ėjimas ar ėjimų seka kuri skirta išvengti figūrų praradimo ar kito priešininko pranašumo.';

  @override
  String get puzzleThemeDeflection => 'Atmušimas';

  @override
  String get puzzleThemeDeflectionDescription =>
      'Ėjimas, kuris nukreipia priešininko figūros dėmesį nuo kitos svarbios jos rolės, pavyzdžiui: langelio šalia karaliaus saugojimo.';

  @override
  String get puzzleThemeDiscoveredAttack => 'Atidengimo ataka';

  @override
  String get puzzleThemeDiscoveredAttackDescription =>
      'Blokuojančios figūros patraukimas nuo ilgų distancijų figūros, pavyzdžiui žirgo patraukimas nuo bokšto trajektorijos.';

  @override
  String get puzzleThemeDoubleCheck => 'Dvigubas šachas';

  @override
  String get puzzleThemeDoubleCheckDescription =>
      'Šachas dviem figūrom vienu metu. Įvyksta po atidengimo atakos, kai ir perkelta figūra ir atidengta figūra puola priešininko karalių.';

  @override
  String get puzzleThemeEndgame => 'Endšpilis';

  @override
  String get puzzleThemeEndgameDescription => 'Taktika, skirta paskutinei žaidimo fazei.';

  @override
  String get puzzleThemeEnPassantDescription =>
      'Taktika susijusi su kirtimu prasilenkiant (en passant). Pėstininkas gali nukirsti priešininko pėstininką, kuris \"aplenkė\" pirmąjį perkeltas per du langelius.';

  @override
  String get puzzleThemeExposedKing => 'Atidengtas karalius';

  @override
  String get puzzleThemeExposedKingDescription =>
      'Taktika, susijusi su karaliumi, kuris neturi daug gynejų aplink save. Tai dažnai priveda prie mato.';

  @override
  String get puzzleThemeFork => 'Šakutė';

  @override
  String get puzzleThemeForkDescription =>
      'Ėjimas, kurio metu perkelta figūra puola dvi ar daugiau priešininko figūrų vienu metu.';

  @override
  String get puzzleThemeHangingPiece => 'Kabanti figūra';

  @override
  String get puzzleThemeHangingPieceDescription =>
      'Taktika, susijusi su neapginta ar nepakankamai apginta ir lengvai nukertama priešininko figūra.';

  @override
  String get puzzleThemeHookMate => 'Kablio matas';

  @override
  String get puzzleThemeHookMateDescription =>
      'Matas su bokštu, žirgu ir pėstininku palei vieną iš priešininko pėstininkų, apribojančių priešininko karaliaus pabėgimą.';

  @override
  String get puzzleThemeInterference => 'Trukdymas';

  @override
  String get puzzleThemeInterferenceDescription =>
      'Figūros perkėlimas tarp dviejų priešininko figūrų, paliekant vieną ar abi jų neapgintas. Pavyzdžiui: perkeliant žirgą į apgintą laukelį tarp dviejų bokštų.';

  @override
  String get puzzleThemeIntermezzo => 'Tarpinis ėjimas';

  @override
  String get puzzleThemeIntermezzoDescription =>
      'Vietoje to, kad būtų padarytas ėjimas, kurio tikėtasi, įterpiamas kitas ėjimas, kuris apgaulingai pateikiamas kaip staigi ataka priešininkui, į kurią jis turi atsakyti. Dar žinomas kaip \"intermezzo\" ar \"zwischenzug\".';

  @override
  String get puzzleThemeKillBoxMate => 'Mirtinos dėžutės matas';

  @override
  String get puzzleThemeKillBoxMateDescription =>
      'Bokštas yra šalia varžovo karaliaus ir jį palaiko karalienė, kuri tuo pačiu uždaro karaliaus pabėgimo langelius. Bokštas ir karalienė sugauna varžovo karalių 3×3 langelių „mirties dėžutėje“.';

  @override
  String get puzzleThemeVukovicMate => 'Vukovic matas';

  @override
  String get puzzleThemeVukovicMateDescription =>
      'Bokštas ir žirgas kartu matuoja karalių. Bokštas atlieka matą, jį palaiko trečioji figūra, o žirgas naudojamas uždaryti karaliaus pabėgimo langelius.';

  @override
  String get puzzleThemeKnightEndgame => 'Žirgų endšpilis';

  @override
  String get puzzleThemeKnightEndgameDescription => 'Endšpilis tik su žirgais ir pėstininkais.';

  @override
  String get puzzleThemeLong => 'Ilgas galvosūkis';

  @override
  String get puzzleThemeLongDescription => 'Trys ėjimai laimėti.';

  @override
  String get puzzleThemeMaster => 'Meistrų partijos';

  @override
  String get puzzleThemeMasterDescription => 'Užduotys iš tituluotų žaidėjų partijų.';

  @override
  String get puzzleThemeMasterVsMaster => 'Meistrų prieš meistrus partijos';

  @override
  String get puzzleThemeMasterVsMasterDescription => 'Užduotys iš partijų tarp tituluotų žaidėjų.';

  @override
  String get puzzleThemeMate => 'Matas';

  @override
  String get puzzleThemeMateDescription => 'Laimėkite žaidimą su klase.';

  @override
  String get puzzleThemeMateIn1 => 'Matas vienu ėjimu';

  @override
  String get puzzleThemeMateIn1Description => 'Atlikite matą vienu ėjimu.';

  @override
  String get puzzleThemeMateIn2 => 'Matas dviem ėjimais';

  @override
  String get puzzleThemeMateIn2Description => 'Atlikite matą dviem ėjimais.';

  @override
  String get puzzleThemeMateIn3 => 'Matas trimis ėjimais';

  @override
  String get puzzleThemeMateIn3Description => 'Atlikite matą trimis ėjimais.';

  @override
  String get puzzleThemeMateIn4 => 'Matas keturiais ėjimais';

  @override
  String get puzzleThemeMateIn4Description => 'Atlikite matą keturiais ėjimais.';

  @override
  String get puzzleThemeMateIn5 => 'Matas penkiais ar daugiau ėjimų';

  @override
  String get puzzleThemeMateIn5Description => 'Atskleiskite ilgą seką vedančią iki mato.';

  @override
  String get puzzleThemeMiddlegame => 'Mitelšpilis';

  @override
  String get puzzleThemeMiddlegameDescription => 'Taktikos skirtos antrai žaidimo fazei.';

  @override
  String get puzzleThemeOneMove => 'Vieno ėjimo galvosūkiai';

  @override
  String get puzzleThemeOneMoveDescription => 'Tik vieno ėjimo galvosūkiai.';

  @override
  String get puzzleThemeOpening => 'Debiutai';

  @override
  String get puzzleThemeOpeningDescription => 'Taktika, kuri galioja pirmoje žaidimo fazėje.';

  @override
  String get puzzleThemePawnEndgame => 'Pėstininkų endšpilis';

  @override
  String get puzzleThemePawnEndgameDescription => 'Endšpilis tik su pėstininkais.';

  @override
  String get puzzleThemePin => 'Surišimas';

  @override
  String get puzzleThemePinDescription =>
      'Taktika susijusi su surišimais, kai figūra negali pajudėti neatidengdama atakos į kitą, vertingesnę figūrą.';

  @override
  String get puzzleThemePromotion => 'Paaukštinimas';

  @override
  String get puzzleThemePromotionDescription =>
      'Pėstininkas, kuris pasiaukština ar kėsinasi pasiaukštinti yra raktas šiai taktikai.';

  @override
  String get puzzleThemeQueenEndgame => 'Valdovės endšpilis';

  @override
  String get puzzleThemeQueenEndgameDescription => 'Endšpilis tik su valdovėmis ir pėstininkais.';

  @override
  String get puzzleThemeQueenRookEndgame => 'Valdovės ir bokšto endšpilis';

  @override
  String get puzzleThemeQueenRookEndgameDescription =>
      'Endšpilis tik su valdovėmis, bokštais ir pėstininkais.';

  @override
  String get puzzleThemeQueensideAttack => 'Valdovės pusės ataka';

  @override
  String get puzzleThemeQueensideAttackDescription =>
      'Ataka priešininko karaliui po to, kai jis atliko rokiruotę valdovės pusėje.';

  @override
  String get puzzleThemeQuietMove => 'Tylus ėjimas';

  @override
  String get puzzleThemeQuietMoveDescription =>
      'Ėjimas, kuris nei atlieka šachą, nei kerta, tačiau paruošia neišvengiamam pavojui vėliasneme ėjime.';

  @override
  String get puzzleThemeRookEndgame => 'Bokštų endšpilis';

  @override
  String get puzzleThemeRookEndgameDescription => 'Endšpilis tik su bokštais ir pėstininkais.';

  @override
  String get puzzleThemeSacrifice => 'Auka';

  @override
  String get puzzleThemeSacrificeDescription =>
      'Taktika, susijusi su figūrų atidavimu dabar, bei gautu pranašumu vėliau po priverstų ėjimų sekos.';

  @override
  String get puzzleThemeShort => 'Trumpas galvosūkis';

  @override
  String get puzzleThemeShortDescription => 'Du ėjimai laimėti.';

  @override
  String get puzzleThemeSkewer => 'Pradūrimas';

  @override
  String get puzzleThemeSkewerDescription =>
      'Motyvas įtraukiantis brangią figūrą, kuri puolama. Jai pasitraukiant atveriamas kelias nukirsti už jos stovinčią mažiau brangią figūrą.';

  @override
  String get puzzleThemeSmotheredMate => 'Uždusintas matas';

  @override
  String get puzzleThemeSmotheredMateDescription =>
      'Matas, kurį atlieka žirgas, kai matuojamas karalius negali pajudėti nes yra apsuptas savo paties figūrų.';

  @override
  String get puzzleThemeSuperGM => 'Super GM partijos';

  @override
  String get puzzleThemeSuperGMDescription =>
      'Užduotys iš partijų, kurias žaidė geriausi pasaulio žaidėjai.';

  @override
  String get puzzleThemeTrappedPiece => 'Įkalinta figūra';

  @override
  String get puzzleThemeTrappedPieceDescription =>
      'Figūra negali pabėgti, nes turi ribotą skaičių ėjimų.';

  @override
  String get puzzleThemeUnderPromotion => 'Žemesnis paaukštinimas';

  @override
  String get puzzleThemeUnderPromotionDescription => 'Paaukštinimas į žirgą, rikį ar bokštą.';

  @override
  String get puzzleThemeVeryLong => 'Labai ilgas galvosūkis';

  @override
  String get puzzleThemeVeryLongDescription => 'Keturi ar daugiau ėjimai laimėti.';

  @override
  String get puzzleThemeXRayAttack => 'Spindulio ataka';

  @override
  String get puzzleThemeXRayAttackDescription =>
      'Figūra puola ar gina laukelį kiaurai priešininko figūros.';

  @override
  String get puzzleThemeZugzwang => 'Priverstinis ėjimas';

  @override
  String get puzzleThemeZugzwangDescription =>
      'Priešininkas apribotas ėjimais, kuriuos gali padaryti, ir visi jo ėjimai tik pabloginą jo poziciją.';

  @override
  String get puzzleThemeMix => 'Visko po truputį';

  @override
  String get puzzleThemeMixDescription =>
      'Nežinote ko tikėtis, todėl būkite pasiruošę bet kam! Visai kaip tikruose žaidimuose.';

  @override
  String get puzzleThemePlayerGames => 'Žaidėjų žaidimai';

  @override
  String get puzzleThemePlayerGamesDescription =>
      'Galvosūkiai sugeneruoti iš jūsų partijų ar iš kitų žaidėjų partijų.';

  @override
  String puzzleThemePuzzleDownloadInformation(String param) {
    return 'Šie galvosūkiai yra laisvai prieinami ir gali būti parsisiųsti iš $param.';
  }

  @override
  String get searchSearch => 'Ieškoti';

  @override
  String get settingsSettings => 'Nuostatos';

  @override
  String get settingsCloseAccount => 'Uždaryti paskyrą';

  @override
  String get settingsManagedAccountCannotBeClosed =>
      'Jūsų paskyra yra valdoma ir negali būti uždaryta.';

  @override
  String get settingsCantOpenSimilarAccount =>
      'Naudotojo vardo NEBUS galima naudoti naujai registracijai.';

  @override
  String get settingsCancelKeepAccount => 'Atsisakyti ir palikti mano paskyrą';

  @override
  String get settingsCloseAccountAreYouSure => 'Ar tikrai norite uždaryti savo paskyrą?';

  @override
  String get settingsThisAccountIsClosed => 'Ši paskyra uždaryta.';

  @override
  String get playWithAFriend => 'Play with a friend';

  @override
  String get playWithTheMachine => 'Play with the computer';

  @override
  String get toInviteSomeoneToPlayGiveThisUrl => 'To invite someone to play, give this URL';

  @override
  String get gameOver => 'Game Over';

  @override
  String get waitingForOpponent => 'Waiting for opponent';

  @override
  String get orLetYourOpponentScanQrCode => 'Or let your opponent scan this QR code';

  @override
  String get waiting => 'Waiting';

  @override
  String get yourTurn => 'Your turn';

  @override
  String aiNameLevelAiLevel(String param1, String param2) {
    return '$param1 level $param2';
  }

  @override
  String get level => 'Level';

  @override
  String get strength => 'Strength';

  @override
  String get toggleTheChat => 'Toggle the chat';

  @override
  String get chat => 'Chat';

  @override
  String get resign => 'Resign';

  @override
  String get checkmate => 'Checkmate';

  @override
  String get stalemate => 'Stalemate';

  @override
  String get white => 'White';

  @override
  String get black => 'Black';

  @override
  String get asWhite => 'as white';

  @override
  String get asBlack => 'as black';

  @override
  String get randomColor => 'Random side';

  @override
  String get createAGame => 'Create a game';

  @override
  String get createTheGame => 'Create the game';

  @override
  String get whiteIsVictorious => 'White is victorious';

  @override
  String get blackIsVictorious => 'Black is victorious';

  @override
  String get youPlayTheWhitePieces => 'You play the white pieces';

  @override
  String get youPlayTheBlackPieces => 'You play the black pieces';

  @override
  String get itsYourTurn => 'It\'s your turn!';

  @override
  String get cheatDetected => 'Cheat Detected';

  @override
  String get kingInTheCenter => 'King in the centre';

  @override
  String get threeChecks => 'Three checks';

  @override
  String get raceFinished => 'Race finished';

  @override
  String get variantEnding => 'Variant ending';

  @override
  String get newOpponent => 'New opponent';

  @override
  String get yourOpponentWantsToPlayANewGameWithYou =>
      'Your opponent wants to play a new game with you';

  @override
  String get joinTheGame => 'Join the game';

  @override
  String get whitePlays => 'White to play';

  @override
  String get blackPlays => 'Black to play';

  @override
  String get opponentLeftChoices =>
      'Your opponent left the game. You can claim victory, call the game a draw, or wait.';

  @override
  String get forceResignation => 'Claim victory';

  @override
  String get forceDraw => 'Call draw';

  @override
  String get talkInChat => 'Please be nice in the chat!';

  @override
  String get theFirstPersonToComeOnThisUrlWillPlayWithYou =>
      'The first person to come to this URL will play with you.';

  @override
  String get whiteResigned => 'White resigned';

  @override
  String get blackResigned => 'Black resigned';

  @override
  String get whiteLeftTheGame => 'White left the game';

  @override
  String get blackLeftTheGame => 'Black left the game';

  @override
  String get whiteDidntMove => 'White didn\'t move';

  @override
  String get blackDidntMove => 'Black didn\'t move';

  @override
  String get requestAComputerAnalysis => 'Request a computer analysis';

  @override
  String get computerAnalysis => 'Computer analysis';

  @override
  String get computerAnalysisAvailable => 'Computer analysis available';

  @override
  String get computerAnalysisDisabled => 'Computer analysis disabled';

  @override
  String get analysis => 'Analysis board';

  @override
  String depthX(String param) {
    return 'Depth $param';
  }

  @override
  String get usingServerAnalysis => 'Using server analysis';

  @override
  String get loadingEngine => 'Loading engine...';

  @override
  String get calculatingMoves => 'Calculating moves...';

  @override
  String get engineFailed => 'Error loading engine';

  @override
  String get cloudAnalysis => 'Cloud analysis';

  @override
  String get goDeeper => 'Go deeper';

  @override
  String get showThreat => 'Show threat';

  @override
  String get inLocalBrowser => 'in local browser';

  @override
  String get toggleLocalEvaluation => 'Toggle local evaluation';

  @override
  String get promoteVariation => 'Promote variation';

  @override
  String get makeMainLine => 'Make mainline';

  @override
  String get deleteFromHere => 'Delete from here';

  @override
  String get collapseVariations => 'Collapse variations';

  @override
  String get expandVariations => 'Expand variations';

  @override
  String get forceVariation => 'Force variation';

  @override
  String get copyVariationPgn => 'Copy variation PGN';

  @override
  String get copyMainLinePgn => 'Copy mainline PGN';

  @override
  String get move => 'Move';

  @override
  String get variantLoss => 'Variant loss';

  @override
  String get variantWin => 'Variant win';

  @override
  String get insufficientMaterial => 'Insufficient material';

  @override
  String get pawnMove => 'Pawn move';

  @override
  String get capture => 'Capture';

  @override
  String get close => 'Close';

  @override
  String get winning => 'Winning';

  @override
  String get losing => 'Losing';

  @override
  String get drawn => 'Drawn';

  @override
  String get unknown => 'Unknown';

  @override
  String get database => 'Database';

  @override
  String get whiteDrawBlack => 'White / Draw / Black';

  @override
  String averageRatingX(String param) {
    return 'Average rating: $param';
  }

  @override
  String get recentGames => 'Recent games';

  @override
  String get topGames => 'Top games';

  @override
  String masterDbExplanation(String param1, String param2, String param3) {
    return 'OTB games of $param1+ FIDE-rated players from $param2 to $param3';
  }

  @override
  String get dtzWithRounding =>
      'DTZ50\'\' with rounding, based on number of half-moves until next capture or pawn move';

  @override
  String get noGameFound => 'No game found';

  @override
  String get maxDepthReached => 'Max depth reached!';

  @override
  String get maybeIncludeMoreGamesFromThePreferencesMenu =>
      'Maybe include more games from the preferences menu?';

  @override
  String get openings => 'Openings';

  @override
  String get openingExplorer => 'Opening explorer';

  @override
  String get openingEndgameExplorer => 'Opening/endgame explorer';

  @override
  String xOpeningExplorer(String param) {
    return '$param opening explorer';
  }

  @override
  String get playFirstOpeningEndgameExplorerMove => 'Play first opening/endgame-explorer move';

  @override
  String get winPreventedBy50MoveRule => 'Win prevented by 50-move rule';

  @override
  String get lossSavedBy50MoveRule => 'Loss prevented by 50-move rule';

  @override
  String get winOr50MovesByPriorMistake => 'Win or 50 moves by prior mistake';

  @override
  String get lossOr50MovesByPriorMistake => 'Loss or 50 moves by prior mistake';

  @override
  String get unknownDueToRounding =>
      'Win/loss only guaranteed if recommended tablebase line has been followed since the last capture or pawn move, due to possible rounding of DTZ values in Syzygy tablebases.';

  @override
  String get allSet => 'All set!';

  @override
  String get importPgn => 'Import PGN';

  @override
  String get delete => 'Delete';

  @override
  String get deleteThisImportedGame => 'Delete this imported game?';

  @override
  String get replayMode => 'Replay mode';

  @override
  String get realtimeReplay => 'Realtime';

  @override
  String get byCPL => 'By CPL';

  @override
  String get enable => 'Enable';

  @override
  String get bestMoveArrow => 'Best move arrow';

  @override
  String get showVariationArrows => 'Show variation arrows';

  @override
  String get evaluationGauge => 'Evaluation gauge';

  @override
  String get multipleLines => 'Multiple lines';

  @override
  String get cpus => 'CPUs';

  @override
  String get memory => 'Memory';

  @override
  String get infiniteAnalysis => 'Infinite analysis';

  @override
  String get removesTheDepthLimit => 'Removes the depth limit, and keeps your computer warm';

  @override
  String get blunder => 'Blunder';

  @override
  String get mistake => 'Mistake';

  @override
  String get inaccuracy => 'Inaccuracy';

  @override
  String get moveTimes => 'Move times';

  @override
  String get flipBoard => 'Flip board';

  @override
  String get threefoldRepetition => 'Threefold repetition';

  @override
  String get claimADraw => 'Claim a draw';

  @override
  String get drawClaimed => 'Draw claimed';

  @override
  String get offerDraw => 'Offer draw';

  @override
  String get draw => 'Draw';

  @override
  String get drawByMutualAgreement => 'Draw by mutual agreement';

  @override
  String get fiftyMovesWithoutProgress => 'Fifty moves without progress';

  @override
  String get currentGames => 'Current games';

  @override
  String joinedX(String param) {
    return 'Joined $param';
  }

  @override
  String get viewInFullSize => 'View in full size';

  @override
  String get logOut => 'Sign out';

  @override
  String get signIn => 'Sign in';

  @override
  String get rememberMe => 'Keep me logged in';

  @override
  String get youNeedAnAccountToDoThat => 'You need an account to do that';

  @override
  String get signUp => 'Register';

  @override
  String get computersAreNotAllowedToPlay =>
      'Computers and computer-assisted players are not allowed to play. Please do not get assistance from chess engines, databases, or from other players while playing. Also note that making multiple accounts is strongly discouraged and excessive multi-accounting will lead to being banned.';

  @override
  String get games => 'Games';

  @override
  String get forum => 'Forum';

  @override
  String xPostedInForumY(String param1, String param2) {
    return '$param1 posted in topic $param2';
  }

  @override
  String get latestForumPosts => 'Latest forum posts';

  @override
  String get players => 'Players';

  @override
  String get friends => 'Friends';

  @override
  String get otherPlayers => 'other players';

  @override
  String get discussions => 'Conversations';

  @override
  String get today => 'Today';

  @override
  String get yesterday => 'Yesterday';

  @override
  String get minutesPerSide => 'Minutes per side';

  @override
  String get variant => 'Variant';

  @override
  String get variants => 'Variants';

  @override
  String get timeControl => 'Time control';

  @override
  String get realTime => 'Real time';

  @override
  String get correspondence => 'Correspondence';

  @override
  String get daysPerTurn => 'Days per turn';

  @override
  String get oneDay => 'One day';

  @override
  String get time => 'Time';

  @override
  String get rating => 'Rating';

  @override
  String get ratingStats => 'Rating stats';

  @override
  String get username => 'User name';

  @override
  String get usernameOrEmail => 'User name or email';

  @override
  String get changeUsername => 'Change username';

  @override
  String get changeUsernameNotSame =>
      'Only the case of the letters can change. For example \"johndoe\" to \"JohnDoe\".';

  @override
  String get changeUsernameDescription =>
      'Change your username. This can only be done once and you are only allowed to change the case of the letters in your username.';

  @override
  String get signupUsernameHint =>
      'Make sure to choose a username that\'s appropriate for all ages. You cannot change it later and any accounts with inappropriate usernames will get closed!';

  @override
  String get signupEmailHint => 'We will only use it for password reset.';

  @override
  String get password => 'Password';

  @override
  String get changePassword => 'Change password';

  @override
  String get changeEmail => 'Change email';

  @override
  String get email => 'Email';

  @override
  String get passwordReset => 'Password reset';

  @override
  String get forgotPassword => 'Forgot password?';

  @override
  String get error_weakPassword => 'This password is extremely common, and too easy to guess.';

  @override
  String get error_namePassword => 'Please don\'t use your username as your password.';

  @override
  String get blankedPassword =>
      'You have used the same password on another site, and that site has been compromised. To ensure the safety of your Lichess account, we need you to set a new password. Thank you for your understanding.';

  @override
  String get youAreLeavingLichess => 'You are leaving Lichess';

  @override
  String get neverTypeYourPassword => 'Never type your Lichess password on another site!';

  @override
  String proceedToX(String param) {
    return 'Proceed to $param';
  }

  @override
  String get passwordSuggestion =>
      'Do not set a password suggested by someone else. They will use it to steal your account.';

  @override
  String get emailSuggestion =>
      'Do not set an email address suggested by someone else. They will use it to steal your account.';

  @override
  String get emailConfirmHelp => 'Help with email confirmation';

  @override
  String get emailConfirmNotReceived => 'Didn\'t receive your confirmation email after signing up?';

  @override
  String get whatSignupUsername => 'What username did you use to sign up?';

  @override
  String usernameNotFound(String param) {
    return 'We couldn\'t find any user by this name: $param.';
  }

  @override
  String get usernameCanBeUsedForNewAccount => 'You can use this username to create a new account';

  @override
  String emailSent(String param) {
    return 'We have sent an email to $param.';
  }

  @override
  String get emailCanTakeSomeTime => 'It can take some time to arrive.';

  @override
  String get refreshInboxAfterFiveMinutes => 'Wait 5 minutes and refresh your email inbox.';

  @override
  String get checkSpamFolder =>
      'Also check your spam folder, it might end up there. If so, mark it as not spam.';

  @override
  String get emailForSignupHelp => 'If everything else fails, then send us this email:';

  @override
  String copyTextToEmail(String param) {
    return 'Copy and paste the above text and send it to $param';
  }

  @override
  String get waitForSignupHelp =>
      'We will come back to you shortly to help you complete your signup.';

  @override
  String accountConfirmed(String param) {
    return 'The user $param is successfully confirmed.';
  }

  @override
  String accountCanLogin(String param) {
    return 'You can login right now as $param.';
  }

  @override
  String get accountConfirmationEmailNotNeeded => 'You do not need a confirmation email.';

  @override
  String accountClosed(String param) {
    return 'The account $param is closed.';
  }

  @override
  String accountRegisteredWithoutEmail(String param) {
    return 'The account $param was registered without an email.';
  }

  @override
  String get rank => 'Rank';

  @override
  String rankX(String param) {
    return 'Rank: $param';
  }

  @override
  String get gamesPlayed => 'Games played';

  @override
  String get ok => 'OK';

  @override
  String get cancel => 'Cancel';

  @override
  String get whiteTimeOut => 'White time out';

  @override
  String get blackTimeOut => 'Black time out';

  @override
  String get drawOfferSent => 'Draw offer sent';

  @override
  String get drawOfferAccepted => 'Draw offer accepted';

  @override
  String get drawOfferCanceled => 'Draw offer cancelled';

  @override
  String get whiteOffersDraw => 'White offers draw';

  @override
  String get blackOffersDraw => 'Black offers draw';

  @override
  String get whiteDeclinesDraw => 'White declines draw';

  @override
  String get blackDeclinesDraw => 'Black declines draw';

  @override
  String get yourOpponentOffersADraw => 'Your opponent offers a draw';

  @override
  String get accept => 'Accept';

  @override
  String get decline => 'Decline';

  @override
  String get playingRightNow => 'Playing right now';

  @override
  String get eventInProgress => 'Playing now';

  @override
  String get finished => 'Finished';

  @override
  String get abortGame => 'Abort game';

  @override
  String get gameAborted => 'Game aborted';

  @override
  String get standard => 'Standard';

  @override
  String get customPosition => 'Custom position';

  @override
  String get unlimited => 'Unlimited';

  @override
  String get mode => 'Mode';

  @override
  String get casual => 'Casual';

  @override
  String get rated => 'Rated';

  @override
  String get casualTournament => 'Casual';

  @override
  String get ratedTournament => 'Rated';

  @override
  String get thisGameIsRated => 'This game is rated';

  @override
  String get rematch => 'Rematch';

  @override
  String get rematchOfferSent => 'Rematch offer sent';

  @override
  String get rematchOfferAccepted => 'Rematch offer accepted';

  @override
  String get rematchOfferCanceled => 'Rematch offer cancelled';

  @override
  String get rematchOfferDeclined => 'Rematch offer declined';

  @override
  String get cancelRematchOffer => 'Cancel rematch offer';

  @override
  String get viewRematch => 'View rematch';

  @override
  String get confirmMove => 'Confirm move';

  @override
  String get play => 'Play';

  @override
  String get inbox => 'Inbox';

  @override
  String get chatRoom => 'Chat room';

  @override
  String get loginToChat => 'Sign in to chat';

  @override
  String get youHaveBeenTimedOut => 'You have been timed out.';

  @override
  String get spectatorRoom => 'Spectator room';

  @override
  String get composeMessage => 'Compose message';

  @override
  String get subject => 'Subject';

  @override
  String get send => 'Send';

  @override
  String get incrementInSeconds => 'Increment in seconds';

  @override
  String get freeOnlineChess => 'Free Online Chess';

  @override
  String get exportGames => 'Export games';

  @override
  String get ratingRange => 'Rating range';

  @override
  String get thisAccountViolatedTos => 'This account violated the Lichess Terms of Service';

  @override
  String get openingExplorerAndTablebase => 'Opening explorer & tablebase';

  @override
  String get takeback => 'Takeback';

  @override
  String get proposeATakeback => 'Propose a takeback';

  @override
  String get whiteProposesTakeback => 'White proposes takeback';

  @override
  String get blackProposesTakeback => 'Black proposes takeback';

  @override
  String get takebackPropositionSent => 'Takeback sent';

  @override
  String get whiteDeclinesTakeback => 'White declines takeback';

  @override
  String get blackDeclinesTakeback => 'Black declines takeback';

  @override
  String get whiteAcceptsTakeback => 'White accepts takeback';

  @override
  String get blackAcceptsTakeback => 'Black accepts takeback';

  @override
  String get whiteCancelsTakeback => 'White cancels takeback';

  @override
  String get blackCancelsTakeback => 'Black cancels takeback';

  @override
  String get yourOpponentProposesATakeback => 'Your opponent proposes a takeback';

  @override
  String get bookmarkThisGame => 'Bookmark this game';

  @override
  String get tournament => 'Tournament';

  @override
  String get tournaments => 'Tournaments';

  @override
  String get tournamentPoints => 'Tournament points';

  @override
  String get viewTournament => 'View tournament';

  @override
  String get backToTournament => 'Back to tournament';

  @override
  String get noDrawBeforeSwissLimit =>
      'You cannot draw before 30 moves are played in a Swiss tournament.';

  @override
  String get thematic => 'Thematic';

  @override
  String yourPerfRatingIsProvisional(String param) {
    return 'Your $param rating is provisional';
  }

  @override
  String yourPerfRatingIsTooHigh(String param1, String param2) {
    return 'Your $param1 rating ($param2) is too high';
  }

  @override
  String yourTopWeeklyPerfRatingIsTooHigh(String param1, String param2) {
    return 'Your top weekly $param1 rating ($param2) is too high';
  }

  @override
  String yourPerfRatingIsTooLow(String param1, String param2) {
    return 'Your $param1 rating ($param2) is too low';
  }

  @override
  String ratedMoreThanInPerf(String param1, String param2) {
    return 'Rated ≥ $param1 in $param2';
  }

  @override
  String ratedLessThanInPerf(String param1, String param2) {
    return 'Rated ≤ $param1 in $param2 for the last week';
  }

  @override
  String mustBeInTeam(String param) {
    return 'Must be in team $param';
  }

  @override
  String youAreNotInTeam(String param) {
    return 'You are not in the team $param';
  }

  @override
  String get backToGame => 'Back to game';

  @override
  String get siteDescription =>
      'Free online chess server. Play chess in a clean interface. No registration, no ads, no plugin required. Play chess with the computer, friends or random opponents.';

  @override
  String xJoinedTeamY(String param1, String param2) {
    return '$param1 joined team $param2';
  }

  @override
  String xCreatedTeamY(String param1, String param2) {
    return '$param1 created team $param2';
  }

  @override
  String get startedStreaming => 'started streaming';

  @override
  String xStartedStreaming(String param) {
    return '$param started streaming';
  }

  @override
  String get averageElo => 'Average rating';

  @override
  String get location => 'Location';

  @override
  String get filterGames => 'Filter games';

  @override
  String get reset => 'Reset';

  @override
  String get apply => 'Submit';

  @override
  String get save => 'Save';

  @override
  String get leaderboard => 'Leaderboard';

  @override
  String get screenshotCurrentPosition => 'Screenshot current position';

  @override
  String get gameAsGIF => 'Game as GIF';

  @override
  String get pasteTheFenStringHere => 'Paste the FEN text here';

  @override
  String get pasteThePgnStringHere => 'Paste the PGN text here';

  @override
  String get orUploadPgnFile => 'Or upload a PGN file';

  @override
  String get fromPosition => 'From position';

  @override
  String get continueFromHere => 'Continue from here';

  @override
  String get toStudy => 'Study';

  @override
  String get importGame => 'Import game';

  @override
  String get importGameExplanation =>
      'Paste a game PGN to get a browsable replay, computer analysis, game chat and public shareable URL.';

  @override
  String get importGameCaveat =>
      'Variations will be erased. To keep them, import the PGN via a study.';

  @override
  String get importGameDataPrivacyWarning =>
      'This PGN can be accessed by the public. To import a game privately, use a study.';

  @override
  String get thisIsAChessCaptcha => 'This is a chess CAPTCHA.';

  @override
  String get clickOnTheBoardToMakeYourMove =>
      'Click on the board to make your move, and prove you are human.';

  @override
  String get captcha_fail => 'Please solve the chess captcha.';

  @override
  String get notACheckmate => 'Not a checkmate';

  @override
  String get whiteCheckmatesInOneMove => 'White to checkmate in one move';

  @override
  String get blackCheckmatesInOneMove => 'Black to checkmate in one move';

  @override
  String get retry => 'Retry';

  @override
  String get reconnecting => 'Reconnecting';

  @override
  String get noNetwork => 'Offline';

  @override
  String get favoriteOpponents => 'Favourite opponents';

  @override
  String get follow => 'Follow';

  @override
  String get following => 'Following';

  @override
  String get unfollow => 'Unfollow';

  @override
  String followX(String param) {
    return 'Follow $param';
  }

  @override
  String unfollowX(String param) {
    return 'Unfollow $param';
  }

  @override
  String get block => 'Block';

  @override
  String get blocked => 'Blocked';

  @override
  String get unblock => 'Unblock';

  @override
  String xStartedFollowingY(String param1, String param2) {
    return '$param1 started following $param2';
  }

  @override
  String get more => 'More';

  @override
  String get memberSince => 'Member since';

  @override
  String lastSeenActive(String param) {
    return 'Active $param';
  }

  @override
  String get player => 'Player';

  @override
  String get list => 'List';

  @override
  String get graph => 'Graph';

  @override
  String get required => 'Required.';

  @override
  String get openTournaments => 'Open tournaments';

  @override
  String get duration => 'Duration';

  @override
  String get winner => 'Winner';

  @override
  String get standing => 'Standing';

  @override
  String get createANewTournament => 'Create a new tournament';

  @override
  String get tournamentCalendar => 'Tournament calendar';

  @override
  String get conditionOfEntry => 'Entry requirements:';

  @override
  String get advancedSettings => 'Advanced settings';

  @override
  String get safeTournamentName => 'Pick a very safe name for the tournament.';

  @override
  String get inappropriateNameWarning =>
      'Anything even slightly inappropriate could get your account closed.';

  @override
  String get emptyTournamentName =>
      'Leave empty to name the tournament after a notable chess player.';

  @override
  String get makePrivateTournament =>
      'Make the tournament private, and restrict access with a password';

  @override
  String get join => 'Join';

  @override
  String get withdraw => 'Withdraw';

  @override
  String get points => 'Points';

  @override
  String get wins => 'Wins';

  @override
  String get losses => 'Losses';

  @override
  String get createdBy => 'Created by';

  @override
  String get startingIn => 'Starting in';

  @override
  String standByX(String param) {
    return 'Stand by $param, pairing players, get ready!';
  }

  @override
  String get pause => 'Pause';

  @override
  String get resume => 'Resume';

  @override
  String get youArePlaying => 'You are playing!';

  @override
  String get winRate => 'Win rate';

  @override
  String get performance => 'Performance';

  @override
  String get tournamentComplete => 'Tournament complete';

  @override
  String get movesPlayed => 'Moves played';

  @override
  String get whiteWins => 'White wins';

  @override
  String get blackWins => 'Black wins';

  @override
  String get drawRate => 'Draw rate';

  @override
  String get draws => 'Draws';

  @override
  String get averageOpponent => 'Average opponent';

  @override
  String get boardEditor => 'Board editor';

  @override
  String get setTheBoard => 'Set the board';

  @override
  String get popularOpenings => 'Popular openings';

  @override
  String get endgamePositions => 'Endgame positions';

  @override
  String chess960StartPosition(String param) {
    return 'Chess960 start position: $param';
  }

  @override
  String get startPosition => 'Starting position';

  @override
  String get clearBoard => 'Clear board';

  @override
  String get loadPosition => 'Load position';

  @override
  String get isPrivate => 'Private';

  @override
  String reportXToModerators(String param) {
    return 'Report $param to moderators';
  }

  @override
  String profileCompletion(String param) {
    return 'Profile completion: $param';
  }

  @override
  String xRating(String param) {
    return '$param rating';
  }

  @override
  String get ifNoneLeaveEmpty => 'If none, leave empty';

  @override
  String get profile => 'Profile';

  @override
  String get editProfile => 'Edit profile';

  @override
  String get realName => 'Real name';

  @override
  String get setFlair => 'Set your flair';

  @override
  String get flair => 'Flair';

  @override
  String get youCanHideFlair =>
      'There is a setting to hide all user flairs across the entire site.';

  @override
  String get biography => 'Biography';

  @override
  String get countryRegion => 'Country or region';

  @override
  String get thankYou => 'Thank you!';

  @override
  String get socialMediaLinks => 'Social media links';

  @override
  String get oneUrlPerLine => 'One URL per line.';

  @override
  String get inlineNotation => 'Inline notation';

  @override
  String get makeAStudy => 'For safekeeping and sharing, consider making a study.';

  @override
  String get clearSavedMoves => 'Clear moves';

  @override
  String get previouslyOnLichessTV => 'Previously on Lichess TV';

  @override
  String get onlinePlayers => 'Online players';

  @override
  String get activePlayers => 'Active players';

  @override
  String get bewareTheGameIsRatedButHasNoClock => 'Beware, the game is rated but has no clock!';

  @override
  String get success => 'Success';

  @override
  String get automaticallyProceedToNextGameAfterMoving =>
      'Automatically proceed to next game after moving';

  @override
  String get autoSwitch => 'Auto switch';

  @override
  String get puzzles => 'Puzzles';

  @override
  String get onlineBots => 'Online bots';

  @override
  String get name => 'Name';

  @override
  String get description => 'Description';

  @override
  String get descPrivate => 'Private description';

  @override
  String get descPrivateHelp =>
      'Text that only the team members will see. If set, replaces the public description for team members.';

  @override
  String get no => 'No';

  @override
  String get yes => 'Yes';

  @override
  String get website => 'Website';

  @override
  String get mobile => 'Mobile';

  @override
  String get help => 'Help:';

  @override
  String get createANewTopic => 'Create a new topic';

  @override
  String get topics => 'Topics';

  @override
  String get posts => 'Posts';

  @override
  String get lastPost => 'Last post';

  @override
  String get views => 'Views';

  @override
  String get replies => 'Replies';

  @override
  String get replyToThisTopic => 'Reply to this topic';

  @override
  String get reply => 'Reply';

  @override
  String get message => 'Message';

  @override
  String get createTheTopic => 'Create the topic';

  @override
  String get reportAUser => 'Report a user';

  @override
  String get user => 'User';

  @override
  String get reason => 'Reason';

  @override
  String get whatIsIheMatter => 'What\'s the matter?';

  @override
  String get cheat => 'Cheat';

  @override
  String get troll => 'Troll';

  @override
  String get other => 'Other';

  @override
  String get reportCheatBoostHelp =>
      'Paste the link to the game(s) and explain what is wrong about this user\'s behaviour. Don\'t just say \"they cheat\", but tell us how you came to this conclusion.';

  @override
  String get reportUsernameHelp =>
      'Explain what about this username is offensive. Don\'t just say \"it\'s offensive/inappropriate\", but tell us how you came to this conclusion, especially if the insult is obfuscated, not in english, is in slang, or is a historical/cultural reference.';

  @override
  String get reportProcessedFasterInEnglish =>
      'Your report will be processed faster if written in English.';

  @override
  String get error_provideOneCheatedGameLink =>
      'Please provide at least one link to a cheated game.';

  @override
  String by(String param) {
    return 'by $param';
  }

  @override
  String importedByX(String param) {
    return 'Imported by $param';
  }

  @override
  String get thisTopicIsNowClosed => 'This topic is now closed.';

  @override
  String get blog => 'Blog';

  @override
  String get notes => 'Notes';

  @override
  String get typePrivateNotesHere => 'Type private notes here';

  @override
  String get writeAPrivateNoteAboutThisUser => 'Write a private note about this user';

  @override
  String get noNoteYet => 'No note yet';

  @override
  String get invalidUsernameOrPassword => 'Invalid username or password';

  @override
  String get incorrectPassword => 'Incorrect password';

  @override
  String get invalidAuthenticationCode => 'Invalid authentication code';

  @override
  String get emailMeALink => 'Email me a link';

  @override
  String get currentPassword => 'Current password';

  @override
  String get newPassword => 'New password';

  @override
  String get newPasswordAgain => 'New password (again)';

  @override
  String get newPasswordsDontMatch => 'The new passwords don\'t match';

  @override
  String get newPasswordStrength => 'Password strength';

  @override
  String get clockInitialTime => 'Clock initial time';

  @override
  String get clockIncrement => 'Clock increment';

  @override
  String get privacy => 'Privacy';

  @override
  String get privacyPolicy => 'Privacy policy';

  @override
  String get letOtherPlayersFollowYou => 'Let other players follow you';

  @override
  String get letOtherPlayersChallengeYou => 'Let other players challenge you';

  @override
  String get letOtherPlayersInviteYouToStudy => 'Let other players invite you to study';

  @override
  String get sound => 'Sound';

  @override
  String get none => 'None';

  @override
  String get fast => 'Fast';

  @override
  String get normal => 'Normal';

  @override
  String get slow => 'Slow';

  @override
  String get insideTheBoard => 'Inside the board';

  @override
  String get outsideTheBoard => 'Outside the board';

  @override
  String get allSquaresOfTheBoard => 'All squares of the board';

  @override
  String get onSlowGames => 'On slow games';

  @override
  String get always => 'Always';

  @override
  String get never => 'Never';

  @override
  String xCompetesInY(String param1, String param2) {
    return '$param1 competes in $param2';
  }

  @override
  String get victory => 'Victory';

  @override
  String get defeat => 'Defeat';

  @override
  String victoryVsYInZ(String param1, String param2, String param3) {
    return '$param1 vs $param2 in $param3';
  }

  @override
  String defeatVsYInZ(String param1, String param2, String param3) {
    return '$param1 vs $param2 in $param3';
  }

  @override
  String drawVsYInZ(String param1, String param2, String param3) {
    return '$param1 vs $param2 in $param3';
  }

  @override
  String get timeline => 'Timeline';

  @override
  String get starting => 'Starting:';

  @override
  String get allInformationIsPublicAndOptional => 'All information is public and optional.';

  @override
  String get biographyDescription =>
      'Talk about yourself, your interests, what you like in chess, your favourite openings, players, ...';

  @override
  String get listBlockedPlayers => 'List players you have blocked';

  @override
  String get human => 'Human';

  @override
  String get computer => 'Computer';

  @override
  String get side => 'Side';

  @override
  String get clock => 'Clock';

  @override
  String get opponent => 'Opponent';

  @override
  String get learnMenu => 'Learn';

  @override
  String get studyMenu => 'Study';

  @override
  String get practice => 'Practice';

  @override
  String get community => 'Community';

  @override
  String get tools => 'Tools';

  @override
  String get increment => 'Increment';

  @override
  String get error_unknown => 'Invalid value';

  @override
  String get error_required => 'This field is required';

  @override
  String get error_email => 'This email address is invalid';

  @override
  String get error_email_acceptable =>
      'This email address is not acceptable. Please double-check it, and try again.';

  @override
  String get error_email_unique => 'Email address invalid or already taken';

  @override
  String get error_email_different => 'This is already your email address';

  @override
  String error_minLength(String param) {
    return 'Must be at least $param characters long';
  }

  @override
  String error_maxLength(String param) {
    return 'Must be at most $param characters long';
  }

  @override
  String error_min(String param) {
    return 'Must be at least $param';
  }

  @override
  String error_max(String param) {
    return 'Must be at most $param';
  }

  @override
  String ifRatingIsPlusMinusX(String param) {
    return 'If rating is ± $param';
  }

  @override
  String get ifRegistered => 'If registered';

  @override
  String get onlyExistingConversations => 'Only existing conversations';

  @override
  String get onlyFriends => 'Only friends';

  @override
  String get menu => 'Menu';

  @override
  String get castling => 'Castling';

  @override
  String get whiteCastlingKingside => 'White O-O';

  @override
  String get blackCastlingKingside => 'Black O-O';

  @override
  String tpTimeSpentPlaying(String param) {
    return 'Time spent playing: $param';
  }

  @override
  String get watchGames => 'Watch games';

  @override
  String tpTimeSpentOnTV(String param) {
    return 'Time featured on TV: $param';
  }

  @override
  String get watch => 'Watch';

  @override
  String get videoLibrary => 'Video library';

  @override
  String get streamersMenu => 'Streamers';

  @override
  String get mobileApp => 'Mobile App';

  @override
  String get webmasters => 'Webmasters';

  @override
  String get about => 'About';

  @override
  String aboutX(String param) {
    return 'About $param';
  }

  @override
  String xIsAFreeYLibreOpenSourceChessServer(String param1, String param2) {
    return '$param1 is a free ($param2), libre, no-ads, open source chess server.';
  }

  @override
  String get really => 'really';

  @override
  String get contribute => 'Contribute';

  @override
  String get termsOfService => 'Terms of Service';

  @override
  String get titleVerification => 'Title verification';

  @override
  String get sourceCode => 'Source Code';

  @override
  String get simultaneousExhibitions => 'Simultaneous exhibitions';

  @override
  String get host => 'Host';

  @override
  String hostColorX(String param) {
    return 'Host colour: $param';
  }

  @override
  String get yourPendingSimuls => 'Your pending simuls';

  @override
  String get createdSimuls => 'Newly created simuls';

  @override
  String get hostANewSimul => 'Host a new simul';

  @override
  String get signUpToHostOrJoinASimul => 'Sign up to host or join a simul';

  @override
  String get noSimulFound => 'Simul not found';

  @override
  String get noSimulExplanation => 'This simultaneous exhibition does not exist.';

  @override
  String get returnToSimulHomepage => 'Return to simul homepage';

  @override
  String get aboutSimul => 'Simuls involve a single player facing several players at once.';

  @override
  String get aboutSimulImage => 'Out of 50 opponents, Fischer won 47 games, drew 2 and lost 1.';

  @override
  String get aboutSimulRealLife =>
      'The concept is taken from real world events. In real life, this involves the simul host moving from table to table to play a single move.';

  @override
  String get aboutSimulRules =>
      'When the simul starts, every player starts a game with the host. The simul ends when all games are complete.';

  @override
  String get aboutSimulSettings =>
      'Simuls are always casual. Rematches, takebacks and adding time are disabled.';

  @override
  String get create => 'Create';

  @override
  String get whenCreateSimul => 'When you create a Simul, you get to play several players at once.';

  @override
  String get simulVariantsHint =>
      'If you select several variants, each player gets to choose which one to play.';

  @override
  String get simulClockHint =>
      'Fischer Clock setup. The more players you take on, the more time you may need.';

  @override
  String get simulAddExtraTime =>
      'You may add extra initial time to your clock to help you cope with the simul.';

  @override
  String get simulHostExtraTime => 'Host extra initial clock time';

  @override
  String get simulAddExtraTimePerPlayer =>
      'Add initial time to your clock for each player joining the simul.';

  @override
  String get simulHostExtraTimePerPlayer => 'Host extra clock time per player';

  @override
  String get lichessTournaments => 'Lichess tournaments';

  @override
  String get tournamentFAQ => 'Arena tournament FAQ';

  @override
  String get timeBeforeTournamentStarts => 'Time before tournament starts';

  @override
  String get averageCentipawnLoss => 'Average centipawn loss';

  @override
  String get accuracy => 'Accuracy';

  @override
  String get keyboardShortcuts => 'Keyboard shortcuts';

  @override
  String get keyMoveBackwardOrForward => 'move backward/forward';

  @override
  String get keyGoToStartOrEnd => 'go to start/end';

  @override
  String get keyCycleSelectedVariation => 'Cycle selected variation';

  @override
  String get keyShowOrHideComments => 'show/hide comments';

  @override
  String get keyEnterOrExitVariation => 'enter/exit variation';

  @override
  String get keyRequestComputerAnalysis => 'Request computer analysis, Learn from your mistakes';

  @override
  String get keyNextLearnFromYourMistakes => 'Next (Learn from your mistakes)';

  @override
  String get keyNextBlunder => 'Next blunder';

  @override
  String get keyNextMistake => 'Next mistake';

  @override
  String get keyNextInaccuracy => 'Next inaccuracy';

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
  String get variationArrowsInfo =>
      'Variation arrows let you navigate without using the move list.';

  @override
  String get playSelectedMove => 'play selected move';

  @override
  String get newTournament => 'New tournament';

  @override
  String get tournamentHomeTitle =>
      'Chess tournaments featuring various time controls and variants';

  @override
  String get tournamentHomeDescription =>
      'Play fast-paced chess tournaments! Join an official scheduled tournament, or create your own. Bullet, Blitz, Classical, Chess960, King of the Hill, Threecheck, and more options available for endless chess fun.';

  @override
  String get tournamentNotFound => 'Tournament not found';

  @override
  String get tournamentDoesNotExist => 'This tournament does not exist.';

  @override
  String get tournamentMayHaveBeenCanceled =>
      'The tournament may have been cancelled if all players left before it started.';

  @override
  String get returnToTournamentsHomepage => 'Return to tournaments homepage';

  @override
  String weeklyPerfTypeRatingDistribution(String param) {
    return 'Weekly $param rating distribution';
  }

  @override
  String yourPerfTypeRatingIsRating(String param1, String param2) {
    return 'Your $param1 rating is $param2.';
  }

  @override
  String youAreBetterThanPercentOfPerfTypePlayers(String param1, String param2) {
    return 'You are better than $param1 of $param2 players.';
  }

  @override
  String userIsBetterThanPercentOfPerfTypePlayers(String param1, String param2, String param3) {
    return '$param1 is better than $param2 of $param3 players.';
  }

  @override
  String betterThanPercentPlayers(String param1, String param2) {
    return 'Better than $param1 of $param2 players';
  }

  @override
  String youDoNotHaveAnEstablishedPerfTypeRating(String param) {
    return 'You do not have an established $param rating.';
  }

  @override
  String get yourRating => 'Your rating';

  @override
  String get cumulative => 'Cumulative';

  @override
  String get glicko2Rating => 'Glicko-2 rating';

  @override
  String get checkYourEmail => 'Check your Email';

  @override
  String get weHaveSentYouAnEmailClickTheLink =>
      'We\'ve sent you an email. Click the link in the email to activate your account.';

  @override
  String get ifYouDoNotSeeTheEmailCheckOtherPlaces =>
      'If you don\'t see the email, check other places it might be, like your junk, spam, social, or other folders.';

  @override
  String get ifYouDoNotGetTheEmail => 'If you do not get the email within 5 minutes:';

  @override
  String get checkAllEmailFolders => 'Check all junk, spam, and other folders';

  @override
  String verifyYourAddress(String param) {
    return 'Verify that $param is your email address';
  }

  @override
  String weHaveSentYouAnEmailTo(String param) {
    return 'We\'ve sent an email to $param. Click the link in the email to reset your password.';
  }

  @override
  String byRegisteringYouAgreeToBeBoundByOur(String param) {
    return 'By registering, you agree to the $param.';
  }

  @override
  String readAboutOur(String param) {
    return 'Read about our $param.';
  }

  @override
  String get networkLagBetweenYouAndLichess => 'Network lag between you and Lichess';

  @override
  String get timeToProcessAMoveOnLichessServer => 'Time to process a move on Lichess\'s server';

  @override
  String get downloadAnnotated => 'Download annotated';

  @override
  String get downloadRaw => 'Download raw';

  @override
  String get downloadImported => 'Download imported';

  @override
  String get downloadAllGames => 'Download all games';

  @override
  String get crosstable => 'Crosstable';

  @override
  String get youCanAlsoScrollOverTheBoardToMoveInTheGame =>
      'Scroll over the board to move in the game.';

  @override
  String get scrollOverComputerVariationsToPreviewThem =>
      'Scroll over computer variations to preview them.';

  @override
  String get analysisShapesHowTo =>
      'Press shift+click or right-click to draw circles and arrows on the board.';

  @override
  String get letOtherPlayersMessageYou => 'Let other players message you';

  @override
  String get receiveForumNotifications => 'Receive notifications when mentioned in the forum';

  @override
  String get shareYourInsightsData => 'Share your chess insights data';

  @override
  String get withNobody => 'With nobody';

  @override
  String get withFriends => 'With friends';

  @override
  String get withEverybody => 'With everybody';

  @override
  String get kidMode => 'Kid mode';

  @override
  String get kidModeIsEnabled => 'Kid mode is enabled.';

  @override
  String get kidModeExplanation =>
      'This is about safety. In kid mode, all site communications are disabled. Enable this for your children and school students, to protect them from other internet users.';

  @override
  String inKidModeTheLichessLogoGetsIconX(String param) {
    return 'In kid mode, the Lichess logo gets a $param icon, so you know your kids are safe.';
  }

  @override
  String get askYourChessTeacherAboutLiftingKidMode =>
      'Your account is managed. Ask your chess teacher about lifting kid mode.';

  @override
  String get enableKidMode => 'Enable Kid mode';

  @override
  String get disableKidMode => 'Disable Kid mode';

  @override
  String get security => 'Security';

  @override
  String get sessions => 'Sessions';

  @override
  String get revokeAllSessions => 'revoke all sessions';

  @override
  String get playChessEverywhere => 'Play chess everywhere';

  @override
  String get everybodyGetsAllFeaturesForFree => 'Everybody gets all features for free';

  @override
  String get viewTheSolution => 'View the solution';

  @override
  String get noChallenges => 'No challenges.';

  @override
  String xHostsY(String param1, String param2) {
    return '$param1 hosts $param2';
  }

  @override
  String xJoinsY(String param1, String param2) {
    return '$param1 joins $param2';
  }

  @override
  String xLikesY(String param1, String param2) {
    return '$param1 likes $param2';
  }

  @override
  String get quickPairing => 'Quick pairing';

  @override
  String get lobby => 'Lobby';

  @override
  String get anonymous => 'Anonymous';

  @override
  String yourScore(String param) {
    return 'Your score: $param';
  }

  @override
  String get language => 'Language';

  @override
  String get allLanguages => 'All languages';

  @override
  String get background => 'Background';

  @override
  String get light => 'Light';

  @override
  String get dark => 'Dark';

  @override
  String get transparent => 'Transparent';

  @override
  String get deviceTheme => 'Device theme';

  @override
  String get backgroundImageUrl => 'Background image URL:';

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
  String get pieceSet => 'Piece set';

  @override
  String get embedInYourWebsite => 'Embed in your website';

  @override
  String get usernameAlreadyUsed => 'This username is already in use, please try another one.';

  @override
  String get usernamePrefixInvalid => 'The username must start with a letter.';

  @override
  String get usernameSuffixInvalid => 'The username must end with a letter or a number.';

  @override
  String get usernameCharsInvalid =>
      'The username must only contain letters, numbers, underscores, and hyphens. Consecutive underscores and hyphens are not allowed.';

  @override
  String get usernameUnacceptable => 'This username is not acceptable.';

  @override
  String get playChessInStyle => 'Play chess in style';

  @override
  String get chessBasics => 'Chess basics';

  @override
  String get coaches => 'Coaches';

  @override
  String get invalidPgn => 'Invalid PGN';

  @override
  String get invalidFen => 'Invalid FEN';

  @override
  String get custom => 'Custom';

  @override
  String get notifications => 'Notifications';

  @override
  String notificationsX(String param1) {
    return 'Notifications: $param1';
  }

  @override
  String perfRatingX(String param) {
    return 'Rating: $param';
  }

  @override
  String get practiceWithComputer => 'Practice with computer';

  @override
  String anotherWasX(String param) {
    return 'Another was $param';
  }

  @override
  String bestWasX(String param) {
    return 'Best was $param';
  }

  @override
  String get youBrowsedAway => 'You browsed away';

  @override
  String get resumePractice => 'Resume practice';

  @override
  String get drawByFiftyMoves => 'The game has been drawn by the fifty move rule.';

  @override
  String get theGameIsADraw => 'The game is a draw.';

  @override
  String get computerThinking => 'Computer thinking ...';

  @override
  String get seeBestMove => 'See best move';

  @override
  String get hideBestMove => 'Hide best move';

  @override
  String get getAHint => 'Get a hint';

  @override
  String get evaluatingYourMove => 'Evaluating your move ...';

  @override
  String get whiteWinsGame => 'White wins';

  @override
  String get blackWinsGame => 'Black wins';

  @override
  String get learnFromYourMistakes => 'Learn from your mistakes';

  @override
  String get learnFromThisMistake => 'Learn from this mistake';

  @override
  String get skipThisMove => 'Skip this move';

  @override
  String get next => 'Next';

  @override
  String xWasPlayed(String param) {
    return '$param was played';
  }

  @override
  String get findBetterMoveForWhite => 'Find a better move for white';

  @override
  String get findBetterMoveForBlack => 'Find a better move for black';

  @override
  String get resumeLearning => 'Resume learning';

  @override
  String get youCanDoBetter => 'You can do better';

  @override
  String get tryAnotherMoveForWhite => 'Try another move for white';

  @override
  String get tryAnotherMoveForBlack => 'Try another move for black';

  @override
  String get solution => 'Solution';

  @override
  String get waitingForAnalysis => 'Waiting for analysis';

  @override
  String get noMistakesFoundForWhite => 'No mistakes found for white';

  @override
  String get noMistakesFoundForBlack => 'No mistakes found for black';

  @override
  String get doneReviewingWhiteMistakes => 'Done reviewing white mistakes';

  @override
  String get doneReviewingBlackMistakes => 'Done reviewing black mistakes';

  @override
  String get doItAgain => 'Do it again';

  @override
  String get reviewWhiteMistakes => 'Review white mistakes';

  @override
  String get reviewBlackMistakes => 'Review black mistakes';

  @override
  String get advantage => 'Advantage';

  @override
  String get opening => 'Opening';

  @override
  String get middlegame => 'Middlegame';

  @override
  String get endgame => 'Endgame';

  @override
  String get conditionalPremoves => 'Conditional premoves';

  @override
  String get addCurrentVariation => 'Add current variation';

  @override
  String get playVariationToCreateConditionalPremoves =>
      'Play a variation to create conditional premoves';

  @override
  String get noConditionalPremoves => 'No conditional premoves';

  @override
  String playX(String param) {
    return 'Play $param';
  }

  @override
  String get showUnreadLichessMessage => 'You have received a private message from Lichess.';

  @override
  String get clickHereToReadIt => 'Click here to read it';

  @override
  String get sorry => 'Sorry :(';

  @override
  String get weHadToTimeYouOutForAWhile => 'We had to time you out for a while.';

  @override
  String get why => 'Why?';

  @override
  String get pleasantChessExperience =>
      'We aim to provide a pleasant chess experience for everyone.';

  @override
  String get goodPractice =>
      'To that effect, we must ensure that all players follow good practice.';

  @override
  String get potentialProblem => 'When a potential problem is detected, we display this message.';

  @override
  String get howToAvoidThis => 'How to avoid this?';

  @override
  String get playEveryGame => 'Play every game you start.';

  @override
  String get tryToWin => 'Try to win (or at least draw) every game you play.';

  @override
  String get resignLostGames => 'Resign lost games (don\'t let the clock run down).';

  @override
  String get temporaryInconvenience => 'We apologise for the temporary inconvenience,';

  @override
  String get wishYouGreatGames => 'and wish you great games on lichess.org.';

  @override
  String get thankYouForReading => 'Thank you for reading!';

  @override
  String get lifetimeScore => 'Lifetime score';

  @override
  String get currentMatchScore => 'Current match score';

  @override
  String get agreementAssistance =>
      'I agree that I will at no time receive assistance during my games (from a chess computer, book, database or another person).';

  @override
  String get agreementNice => 'I agree that I will always be respectful to other players.';

  @override
  String agreementMultipleAccounts(String param) {
    return 'I agree that I will not create multiple accounts (except for the reasons stated in the $param).';
  }

  @override
  String get agreementPolicy => 'I agree that I will follow all Lichess policies.';

  @override
  String get searchOrStartNewDiscussion => 'Search or start new conversation';

  @override
  String get edit => 'Edit';

  @override
  String get bullet => 'Bullet';

  @override
  String get blitz => 'Blitz';

  @override
  String get rapid => 'Rapid';

  @override
  String get classical => 'Classical';

  @override
  String get ultraBulletDesc => 'Insanely fast games: less than 30 seconds';

  @override
  String get bulletDesc => 'Very fast games: less than 3 minutes';

  @override
  String get blitzDesc => 'Fast games: 3 to 8 minutes';

  @override
  String get rapidDesc => 'Rapid games: 8 to 25 minutes';

  @override
  String get classicalDesc => 'Classical games: 25 minutes and more';

  @override
  String get correspondenceDesc => 'Correspondence games: one or several days per move';

  @override
  String get puzzleDesc => 'Chess tactics trainer';

  @override
  String get important => 'Important';

  @override
  String yourQuestionMayHaveBeenAnswered(String param1) {
    return 'Your question may already have an answer $param1';
  }

  @override
  String get inTheFAQ => 'in the FAQ';

  @override
  String toReportSomeoneForCheatingOrBadBehavior(String param1) {
    return 'To report a user for cheating or bad behaviour, $param1';
  }

  @override
  String get useTheReportForm => 'use the report form';

  @override
  String toRequestSupport(String param1) {
    return 'To request support, $param1';
  }

  @override
  String get tryTheContactPage => 'try the contact page';

  @override
  String makeSureToRead(String param1) {
    return 'Make sure to read $param1';
  }

  @override
  String get theForumEtiquette => 'the forum etiquette';

  @override
  String get thisTopicIsArchived => 'This topic has been archived and can no longer be replied to.';

  @override
  String joinTheTeamXToPost(String param1) {
    return 'Join the $param1, to post in this forum';
  }

  @override
  String teamNamedX(String param1) {
    return '$param1 team';
  }

  @override
  String get youCannotPostYetPlaySomeGames => 'You can\'t post in the forums yet. Play some games!';

  @override
  String get subscribe => 'Subscribe';

  @override
  String get unsubscribe => 'Unsubscribe';

  @override
  String mentionedYouInX(String param1) {
    return 'mentioned you in \"$param1\".';
  }

  @override
  String xMentionedYouInY(String param1, String param2) {
    return '$param1 mentioned you in \"$param2\".';
  }

  @override
  String invitedYouToX(String param1) {
    return 'invited you to \"$param1\".';
  }

  @override
  String xInvitedYouToY(String param1, String param2) {
    return '$param1 invited you to \"$param2\".';
  }

  @override
  String get youAreNowPartOfTeam => 'You are now part of the team.';

  @override
  String youHaveJoinedTeamX(String param1) {
    return 'You have joined \"$param1\".';
  }

  @override
  String get someoneYouReportedWasBanned => 'Someone you reported was banned';

  @override
  String get congratsYouWon => 'Congratulations, you won!';

  @override
  String gameVsX(String param1) {
    return 'Game vs $param1';
  }

  @override
  String resVsX(String param1, String param2) {
    return '$param1 vs $param2';
  }

  @override
  String get lostAgainstTOSViolator =>
      'You lost rating points to someone who violated the Lichess TOS';

  @override
  String refundXpointsTimeControlY(String param1, String param2) {
    return 'Refund: $param1 $param2 rating points.';
  }

  @override
  String get timeAlmostUp => 'Time is almost up!';

  @override
  String get clickToRevealEmailAddress => '[Click to reveal email address]';

  @override
  String get download => 'Download';

  @override
  String get coachManager => 'Coach manager';

  @override
  String get streamerManager => 'Streamer manager';

  @override
  String get cancelTournament => 'Cancel the tournament';

  @override
  String get tournDescription => 'Tournament description';

  @override
  String get tournDescriptionHelp =>
      'Anything special you want to tell the participants? Try to keep it short. Markdown links are available: [name](https://url)';

  @override
  String get ratedFormHelp => 'Games are rated and impact players ratings';

  @override
  String get onlyMembersOfTeam => 'Only members of team';

  @override
  String get noRestriction => 'No restriction';

  @override
  String get minimumRatedGames => 'Minimum rated games';

  @override
  String get minimumRating => 'Minimum rating';

  @override
  String get maximumWeeklyRating => 'Maximum weekly rating';

  @override
  String positionInputHelp(String param) {
    return 'Paste a valid FEN to start every game from a given position.\nIt only works for standard games, not with variants.\nYou can use the $param to generate a FEN position, then paste it here.\nLeave empty to start games from the normal initial position.';
  }

  @override
  String get cancelSimul => 'Cancel the simul';

  @override
  String get simulHostcolor => 'Host colour for each game';

  @override
  String get estimatedStart => 'Estimated start time';

  @override
  String simulFeatured(String param) {
    return 'Feature on $param';
  }

  @override
  String simulFeaturedHelp(String param) {
    return 'Show your simul to everyone on $param. Disable for private simuls.';
  }

  @override
  String get simulDescription => 'Simul description';

  @override
  String get simulDescriptionHelp => 'Anything you want to tell the participants?';

  @override
  String markdownAvailable(String param) {
    return '$param is available for more advanced syntax.';
  }

  @override
  String get embedsAvailable => 'Paste a game URL or a study chapter URL to embed it.';

  @override
  String get inYourLocalTimezone => 'In your own local timezone';

  @override
  String get tournChat => 'Tournament chat';

  @override
  String get noChat => 'No chat';

  @override
  String get onlyTeamLeaders => 'Only team leaders';

  @override
  String get onlyTeamMembers => 'Only team members';

  @override
  String get navigateMoveTree => 'Navigate the move tree';

  @override
  String get mouseTricks => 'Mouse tricks';

  @override
  String get toggleLocalAnalysis => 'Toggle local computer analysis';

  @override
  String get toggleAllAnalysis => 'Toggle all computer analysis';

  @override
  String get playComputerMove => 'Play best computer move';

  @override
  String get analysisOptions => 'Analysis options';

  @override
  String get focusChat => 'Focus chat';

  @override
  String get showHelpDialog => 'Show this help dialog';

  @override
  String get reopenYourAccount => 'Reopen your account';

  @override
  String get reopenYourAccountDescription =>
      'If you closed your account, but have since changed your mind, you get a chance of getting your account back.';

  @override
  String get emailAssociatedToaccount => 'Email address associated to the account';

  @override
  String get sentEmailWithLink => 'We\'ve sent you an email with a link.';

  @override
  String get tournamentEntryCode => 'Tournament entry code';

  @override
  String get hangOn => 'Hang on!';

  @override
  String gameInProgress(String param) {
    return 'You have a game in progress with $param.';
  }

  @override
  String get abortTheGame => 'Abort the game';

  @override
  String get resignTheGame => 'Resign the game';

  @override
  String get youCantStartNewGame => 'You can\'t start a new game until this one is finished.';

  @override
  String get since => 'Since';

  @override
  String get until => 'Until';

  @override
  String get lichessDbExplanation => 'Rated games played on Lichess';

  @override
  String get switchSides => 'Switch sides';

  @override
  String get closingAccountWithdrawAppeal => 'Closing your account will withdraw your appeal';

  @override
  String get ourEventTips => 'Our tips for organising events';

  @override
  String get instructions => 'Instructions';

  @override
  String get showMeEverything => 'Show me everything';

  @override
  String get lichessPatronInfo =>
      'Lichess is a charity and entirely free/libre open source software.\nAll operating costs, development, and content are funded solely by user donations.';

  @override
  String get nothingToSeeHere => 'Nothing to see here at the moment.';

  @override
  String get stats => 'Stats';

  @override
  String get accessibility => 'Accessibility';

  @override
  String get enableBlindMode => 'Enable blind mode';

  @override
  String get disableBlindMode => 'Disable blind mode';

  @override
  String opponentLeftCounter(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Your opponent left the game. You can claim victory in $count seconds.',
      one: 'Your opponent left the game. You can claim victory in $count second.',
    );
    return '$_temp0';
  }

  @override
  String mateInXHalfMoves(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Mate in $count half-moves',
      one: 'Mate in $count half-move',
    );
    return '$_temp0';
  }

  @override
  String nbBlunders(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count blunders',
      one: '$count blunder',
    );
    return '$_temp0';
  }

  @override
  String numberBlunders(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Blunders',
      one: '$count Blunder',
    );
    return '$_temp0';
  }

  @override
  String nbMistakes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count mistakes',
      one: '$count mistake',
    );
    return '$_temp0';
  }

  @override
  String numberMistakes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Mistakes',
      one: '$count Mistake',
    );
    return '$_temp0';
  }

  @override
  String nbInaccuracies(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count inaccuracies',
      one: '$count inaccuracy',
    );
    return '$_temp0';
  }

  @override
  String numberInaccuracies(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Inaccuracies',
      one: '$count Inaccuracy',
    );
    return '$_temp0';
  }

  @override
  String nbPlayers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count players',
      one: '$count player',
    );
    return '$_temp0';
  }

  @override
  String nbGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count games',
      one: '$count game',
    );
    return '$_temp0';
  }

  @override
  String ratingXOverYGames(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count rating over $param2 games',
      one: '$count rating over $param2 game',
    );
    return '$_temp0';
  }

  @override
  String nbBookmarks(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count bookmarks',
      one: '$count bookmark',
    );
    return '$_temp0';
  }

  @override
  String nbDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count days',
      one: '$count day',
    );
    return '$_temp0';
  }

  @override
  String nbHours(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count hours',
      one: '$count hour',
    );
    return '$_temp0';
  }

  @override
  String nbMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count minutes',
      one: '$count minute',
    );
    return '$_temp0';
  }

  @override
  String rankIsUpdatedEveryNbMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Rank is updated every $count minutes',
      one: 'Rank is updated every minute',
    );
    return '$_temp0';
  }

  @override
  String nbPuzzles(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count puzzles',
      one: '$count puzzle',
    );
    return '$_temp0';
  }

  @override
  String nbGamesWithYou(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count games with you',
      one: '$count game with you',
    );
    return '$_temp0';
  }

  @override
  String nbRated(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count rated',
      one: '$count rated',
    );
    return '$_temp0';
  }

  @override
  String nbWins(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count wins',
      one: '$count win',
    );
    return '$_temp0';
  }

  @override
  String nbLosses(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count losses',
      one: '$count loss',
    );
    return '$_temp0';
  }

  @override
  String nbDraws(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count draws',
      one: '$count draw',
    );
    return '$_temp0';
  }

  @override
  String nbPlaying(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count playing',
      one: '$count playing',
    );
    return '$_temp0';
  }

  @override
  String giveNbSeconds(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Give $count seconds',
      one: 'Give $count second',
    );
    return '$_temp0';
  }

  @override
  String nbTournamentPoints(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count tournament points',
      one: '$count tournament point',
    );
    return '$_temp0';
  }

  @override
  String nbStudies(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count studies',
      one: '$count study',
    );
    return '$_temp0';
  }

  @override
  String nbSimuls(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count simuls',
      one: '$count simul',
    );
    return '$_temp0';
  }

  @override
  String moreThanNbRatedGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '≥ $count rated games',
      one: '≥ $count rated game',
    );
    return '$_temp0';
  }

  @override
  String moreThanNbPerfRatedGames(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '≥ $count $param2 rated games',
      one: '≥ $count $param2 rated game',
    );
    return '$_temp0';
  }

  @override
  String needNbMorePerfGames(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'You need to play $count more $param2 rated games',
      one: 'You need to play $count more $param2 rated game',
    );
    return '$_temp0';
  }

  @override
  String needNbMoreGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'You need to play $count more rated games',
      one: 'You need to play $count more rated game',
    );
    return '$_temp0';
  }

  @override
  String nbImportedGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count imported games',
      one: '$count imported game',
    );
    return '$_temp0';
  }

  @override
  String nbFriendsOnline(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count friends online',
      one: '$count friend online',
    );
    return '$_temp0';
  }

  @override
  String nbFollowers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count followers',
      one: '$count follower',
    );
    return '$_temp0';
  }

  @override
  String nbFollowing(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count following',
      one: '$count following',
    );
    return '$_temp0';
  }

  @override
  String lessThanNbMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Less than $count minutes',
      one: 'Less than $count minute',
    );
    return '$_temp0';
  }

  @override
  String nbGamesInPlay(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count games in play',
      one: '$count game in play',
    );
    return '$_temp0';
  }

  @override
  String maximumNbCharacters(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Maximum: $count characters.',
      one: 'Maximum: $count character.',
    );
    return '$_temp0';
  }

  @override
  String blocks(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count blocks',
      one: '$count block',
    );
    return '$_temp0';
  }

  @override
  String nbForumPosts(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count forum posts',
      one: '$count forum post',
    );
    return '$_temp0';
  }

  @override
  String nbPerfTypePlayersThisWeek(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count $param2 players this week.',
      one: '$count $param2 player this week.',
    );
    return '$_temp0';
  }

  @override
  String availableInNbLanguages(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Available in $count languages!',
      one: 'Available in $count language!',
    );
    return '$_temp0';
  }

  @override
  String nbSecondsToPlayTheFirstMove(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count seconds to play the first move',
      one: '$count second to play the first move',
    );
    return '$_temp0';
  }

  @override
  String nbSeconds(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count seconds',
      one: '$count second',
    );
    return '$_temp0';
  }

  @override
  String andSaveNbPremoveLines(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'and save $count premove lines',
      one: 'and save $count premove line',
    );
    return '$_temp0';
  }

  @override
  String get stormMoveToStart => 'Norėdami pradėti padarykite ėjimą';

  @override
  String get stormYouPlayTheWhitePiecesInAllPuzzles => 'Visose užduotyse žaidžiate baltaisiais';

  @override
  String get stormYouPlayTheBlackPiecesInAllPuzzles => 'Visose užduotyse žaidžiate juodaisiais';

  @override
  String get stormPuzzlesSolved => 'išspręsta užduočių';

  @override
  String get stormNewDailyHighscore => 'Naujas kasdieninis rekordas!';

  @override
  String get stormNewWeeklyHighscore => 'Naujas savaitinis rekordas!';

  @override
  String get stormNewMonthlyHighscore => 'Naujas mėnesinis rekordas!';

  @override
  String get stormNewAllTimeHighscore => 'Naujas visų laikų rekordas!';

  @override
  String stormPreviousHighscoreWasX(String param) {
    return 'Praėjęs rekordas buvo $param';
  }

  @override
  String get stormPlayAgain => 'Žaisti dar';

  @override
  String stormHighscoreX(String param) {
    return 'Rekordas: $param';
  }

  @override
  String get stormScore => 'Taškų';

  @override
  String get stormMoves => 'Ėjimų';

  @override
  String get stormAccuracy => 'Tikslumas';

  @override
  String get stormCombo => 'Iš eilės';

  @override
  String get stormTime => 'Laikas';

  @override
  String get stormTimePerMove => 'Laiko per ėjimą';

  @override
  String get stormHighestSolved => 'Daugiausia išspręsta';

  @override
  String get stormPuzzlesPlayed => 'Sužaista galvosūkių';

  @override
  String get stormNewRun => 'Nauja eilė (klavišas: tarpas)';

  @override
  String get stormEndRun => 'Baigti eilę (klavišas: įvesti)';

  @override
  String get stormHighscores => 'Geriausi rezultatai';

  @override
  String get stormViewBestRuns => 'Peržiūrėti geriausias eiles';

  @override
  String get stormBestRunOfDay => 'Geriausia dienos eilė';

  @override
  String get stormRuns => 'Eilės';

  @override
  String get stormGetReady => 'Pasiruoškite!';

  @override
  String get stormWaitingForMorePlayers => 'Laukiama daugiau žaidėjų...';

  @override
  String get stormRaceComplete => 'Lenktynės baigtos!';

  @override
  String get stormSpectating => 'Stebima';

  @override
  String get stormJoinTheRace => 'Prisijungti prie lenktynių!';

  @override
  String get stormStartTheRace => 'Pradėti lenktynes';

  @override
  String stormYourRankX(String param) {
    return 'Jūsų reitingas: $param';
  }

  @override
  String get stormWaitForRematch => 'Laukti revanšo';

  @override
  String get stormNextRace => 'Kitos lenktynės';

  @override
  String get stormJoinRematch => 'Prisijungti revanšui';

  @override
  String get stormWaitingToStart => 'Laukiama pradžios';

  @override
  String get stormCreateNewGame => 'Kurti naują žaidimą';

  @override
  String get stormJoinPublicRace => 'Prisijungti prie viešų lenktynių';

  @override
  String get stormRaceYourFriends => 'Lenktyniauti su draugais';

  @override
  String get stormSkip => 'praleisti';

  @override
  String get stormSkipHelp => 'NAUJA! Per lenktynes galite praleisti vieną ėjimą:';

  @override
  String get stormSkipExplanation =>
      'Praleiskite ėjimą norėdami išlaikyti seką! Veikia tik kartą per lenktynes.';

  @override
  String get stormFailedPuzzles => 'Nepavykę galvosūkiai';

  @override
  String get stormSlowPuzzles => 'Lėti galvosūkiai';

  @override
  String get stormSkippedPuzzle => 'Praleista užduotis';

  @override
  String get stormThisWeek => 'Šią savaitę';

  @override
  String get stormThisMonth => 'Šį mėnesį';

  @override
  String get stormAllTime => 'Visų laikų';

  @override
  String get stormClickToReload => 'Spauskite norėdami perkrauti';

  @override
  String get stormThisRunHasExpired => 'Ši eilė pasibaigė!';

  @override
  String get stormThisRunWasOpenedInAnotherTab => 'Ši eilė atidaryta kitoje kortelėje!';

  @override
  String stormXRuns(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count eilių',
      many: '$count eilės',
      few: '$count eilės',
      one: '1 eilė',
    );
    return '$_temp0';
  }

  @override
  String stormPlayedNbRunsOfPuzzleStorm(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Žaista $count $param2 eilių',
      many: 'Žaista $count $param2 eilės',
      few: 'Žaistos $count $param2 eilės',
      one: 'Žaista viena $param2 eilė',
    );
    return '$_temp0';
  }

  @override
  String get streamerLichessStreamers => 'Lichess transliuotojai';

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
  String get timeagoJustNow => 'ką tik';

  @override
  String get timeagoRightNow => 'dabar';

  @override
  String get timeagoCompleted => 'užbaigta';

  @override
  String timeagoInNbSeconds(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'po $count sekundžių',
      many: 'po $count sekundės',
      few: 'po $count sekundžių',
      one: 'po $count sekundės',
    );
    return '$_temp0';
  }

  @override
  String timeagoInNbMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'po $count minučių',
      many: 'po $count minutės',
      few: 'po $count minučių',
      one: 'po $count minutės',
    );
    return '$_temp0';
  }

  @override
  String timeagoInNbHours(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'po $count valandų',
      many: 'po $count valandos',
      few: 'po $count valandų',
      one: 'po $count valandos',
    );
    return '$_temp0';
  }

  @override
  String timeagoInNbDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'po $count dienų',
      many: 'po $count dienos',
      few: 'po $count dienų',
      one: 'po $count dienos',
    );
    return '$_temp0';
  }

  @override
  String timeagoInNbWeeks(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'po $count savaičių',
      many: 'po $count savaitės',
      few: 'po $count savaičių',
      one: 'po $count savaitės',
    );
    return '$_temp0';
  }

  @override
  String timeagoInNbMonths(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'po $count mėnesių',
      many: 'po $count mėnesio',
      few: 'po $count mėnesių',
      one: 'po $count mėnesio',
    );
    return '$_temp0';
  }

  @override
  String timeagoInNbYears(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'po $count metų',
      many: 'po $count metų',
      few: 'po $count metų',
      one: 'po $count metų',
    );
    return '$_temp0';
  }

  @override
  String timeagoNbMinutesAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Prieš $count minučių',
      many: 'Prieš $count minutės',
      few: 'Prieš $count minutes',
      one: 'Prieš $count minutę',
    );
    return '$_temp0';
  }

  @override
  String timeagoNbHoursAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Prieš $count valandų',
      many: 'Prieš $count valandos',
      few: 'Prieš $count valandas',
      one: 'Prieš $count valandą',
    );
    return '$_temp0';
  }

  @override
  String timeagoNbDaysAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Prieš $count dienų',
      many: 'Prieš $count dienos',
      few: 'Prieš $count dienas',
      one: 'Prieš $count dieną',
    );
    return '$_temp0';
  }

  @override
  String timeagoNbWeeksAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Prieš $count savaičių',
      many: 'Prieš $count savaitės',
      few: 'Prieš $count savaites',
      one: 'Prieš $count savaitę',
    );
    return '$_temp0';
  }

  @override
  String timeagoNbMonthsAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Prieš $count mėnesių',
      many: 'Prieš $count mėnesio',
      few: 'Prieš $count mėnesius',
      one: 'Prieš $count mėnesį',
    );
    return '$_temp0';
  }

  @override
  String timeagoNbYearsAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Prieš $count metų',
      many: 'Prieš $count metų',
      few: 'Prieš $count metus',
      one: 'Prieš $count metus',
    );
    return '$_temp0';
  }

  @override
  String timeagoNbMinutesRemaining(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Liko $count minučių',
      many: 'Liko $count minučių',
      few: 'Liko $count minutės',
      one: 'Liko $count minutė',
    );
    return '$_temp0';
  }

  @override
  String timeagoNbHoursRemaining(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Liko $count valandų',
      many: 'Liko $count valandų',
      few: 'Liko $count valandos',
      one: 'Liko $count valanda',
    );
    return '$_temp0';
  }
}
