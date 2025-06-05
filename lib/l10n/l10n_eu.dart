// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'l10n.dart';

// ignore_for_file: type=lint

/// The translations for Basque (`eu`).
class AppLocalizationsEu extends AppLocalizations {
  AppLocalizationsEu([String locale = 'eu']) : super(locale);

  @override
  String get mobileAllGames => 'Partida guztiak';

  @override
  String get mobileAreYouSure => 'Ziur zaude?';

  @override
  String get mobileCancelTakebackOffer => 'Bertan behera utzi atzera-egite eskaera';

  @override
  String get mobileClearButton => 'Garbitu';

  @override
  String get mobileCorrespondenceClearSavedMove => 'Garbitu gordetako jokaldia';

  @override
  String get mobileCustomGameJoinAGame => 'Sartu partida baten';

  @override
  String get mobileFeedbackButton => 'Iritzia';

  @override
  String mobileGreeting(String param) {
    return 'Kaixo $param';
  }

  @override
  String get mobileGreetingWithoutName => 'Kaixo';

  @override
  String get mobileHideVariation => 'Ezkutatu aukera';

  @override
  String get mobileHomeTab => 'Hasiera';

  @override
  String get mobileLiveStreamers => 'Zuzeneko streamerrak';

  @override
  String get mobileMustBeLoggedIn => 'Sartu egin behar zara orri hau ikusteko.';

  @override
  String get mobileNoSearchResults => 'Emaitzarik ez';

  @override
  String get mobileNotFollowingAnyUser => 'Ez zaude erabiltzailerik jarraitzen.';

  @override
  String get mobileOkButton => 'Ados';

  @override
  String mobilePlayersMatchingSearchTerm(String param) {
    return '\"$param\" duten jokalariak';
  }

  @override
  String get mobilePrefMagnifyDraggedPiece => 'Handitu arrastatutako pieza';

  @override
  String get mobilePuzzleStormConfirmEndRun => 'Saiakera hau amaitu nahi duzu?';

  @override
  String get mobilePuzzleStormFilterNothingToShow => 'Ez dago erakusteko ezer, aldatu filtroak';

  @override
  String get mobilePuzzleStormNothingToShow =>
      'Ez dago ezer erakusteko. Jokatu Ariketa zaparrada batzuk.';

  @override
  String get mobilePuzzleStormSubtitle => 'Ebatzi ahalik eta ariketa gehien 3 minututan.';

  @override
  String get mobilePuzzleStreakAbortWarning =>
      'Zure uneko bolada galduko duzu eta zure puntuazioa gorde egingo da.';

  @override
  String get mobilePuzzleThemesSubtitle =>
      'Jokatu zure irekiera gogokoenen ariketak, edo aukeratu gai bat.';

  @override
  String get mobilePuzzlesTab => 'Ariketak';

  @override
  String get mobileRecentSearches => 'Azken bilaketak';

  @override
  String get mobileSettingsHapticFeedback => 'Ukipen-erantzuna';

  @override
  String get mobileSettingsImmersiveMode => 'Murgiltze modua';

  @override
  String get mobileSettingsImmersiveModeSubtitle =>
      'Hide system UI while playing. Use this if you are bothered by the system\'s navigation gestures at the edges of the screen. Applies to game and puzzle screens.';

  @override
  String get mobileSettingsTab => 'Ezarpenak';

  @override
  String get mobileShareGamePGN => 'Partekatu PGNa';

  @override
  String get mobileShareGameURL => 'Partekatu partidaren URLa';

  @override
  String get mobileSharePositionAsFEN => 'Partekatu posizioa FEN gisa';

  @override
  String get mobileSharePuzzle => 'Partekatu ariketa hau';

  @override
  String get mobileShowComments => 'Erakutsi iruzkinak';

  @override
  String get mobileShowResult => 'Erakutsi emaitza';

  @override
  String get mobileShowVariations => 'Erakutsi aukerak';

  @override
  String get mobileSomethingWentWrong => 'Zerbait gaizki joan da.';

  @override
  String get mobileSystemColors => 'Sistemaren koloreak';

  @override
  String get mobileTheme => 'Itxura';

  @override
  String get mobileToolsTab => 'Tresnak';

  @override
  String get mobileWaitingForOpponentToJoin => 'Aurkaria sartzeko zain...';

  @override
  String get mobileWatchTab => 'Ikusi';

  @override
  String get activityActivity => 'Jarduera';

  @override
  String get activityHostedALiveStream => 'Zuzeneko emanaldi bat egin du';

  @override
  String activityRankedInSwissTournament(String param1, String param2) {
    return 'Sailkapena $param1/$param2';
  }

  @override
  String get activitySignedUp => 'Lichess.org-en izena eman du';

  @override
  String activitySupportedNbMonths(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Lichess.org-i laguntza eman zion $count hilabetez $param2 gisa',
      one: 'Lichess.org-i laguntza eman zion hilabete $count-z $param2 gisa',
    );
    return '$_temp0';
  }

  @override
  String activityPracticedNbPositions(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$param2 erako $count posizio praktikatu ditu',
      one: '$param2 erako posizio $count praktikatu du',
    );
    return '$_temp0';
  }

  @override
  String activitySolvedNbPuzzles(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ariketa ebatzi ditu',
      one: 'Ariketa $count ebatzi du',
    );
    return '$_temp0';
  }

  @override
  String activityPlayedNbGames(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count $param2 partida jokatu ditu',
      one: '$param2 partida $count jokatu du',
    );
    return '$_temp0';
  }

  @override
  String activityPostedNbMessages(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$param2 foroan $count mezu argitaratu ditu',
      one: '$param2 foroan mezu $count argitaratu du',
    );
    return '$_temp0';
  }

  @override
  String activityPlayedNbMoves(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Jokaldi $count egin du',
      one: 'Jokaldi $count egin du',
    );
    return '$_temp0';
  }

  @override
  String activityInNbCorrespondenceGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'posta bidezko partida $count-en',
      one: 'posta bidezko partida $count-en',
    );
    return '$_temp0';
  }

  @override
  String activityCompletedNbGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Posta bidezko $count partida jokatu ditu',
      one: 'Posta bidezko partida $count jokatu du',
    );
    return '$_temp0';
  }

  @override
  String activityCompletedNbVariantGames(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$param2 posta bidezko $count partida osatuta',
      one: '$param2 posta bidezko partida $count osatuta',
    );
    return '$_temp0';
  }

  @override
  String activityFollowedNbPlayers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count jokalari jarraitzen hasi da',
      one: 'Jokalari $count jarraitzen hasi da',
    );
    return '$_temp0';
  }

  @override
  String activityGainedNbFollowers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count jarraitzaile berri lortu ditu',
      one: 'Jarraitzaile berri $count lortu du',
    );
    return '$_temp0';
  }

  @override
  String activityHostedNbSimuls(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Aldibereko partiden $count saio antolatu ditu',
      one: 'Aldibereko partiden saio $count antolatu du',
    );
    return '$_temp0';
  }

  @override
  String activityJoinedNbSimuls(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Aldibireko $count saiotan hartu du parte',
      one: 'Aldibireko saio ${count}ean hartu du parte',
    );
    return '$_temp0';
  }

  @override
  String activityCreatedNbStudies(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count azterlan berri sortu ditu',
      one: 'Azterlan berri $count sortu du',
    );
    return '$_temp0';
  }

  @override
  String activityCompetedInNbTournaments(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count txapelketetan parte hartu du',
      one: 'Txapelketa ${count}ean parte hartu du',
    );
    return '$_temp0';
  }

  @override
  String activityRankedInTournament(int count, String param2, String param3, String param4) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$count. postua (% $param2 onenen artean) $param3 partida jokatuta $param4 txapelketan',
      one:
          '$count. postua lortu du (% $param2 onenen artean) partida $param3 jokatuta $param4 txapelketan',
    );
    return '$_temp0';
  }

  @override
  String activityCompetedInNbSwissTournaments(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count txapelketa suitzarretan hartu du parte',
      one: 'Txapelketa suitzar ${count}en hartu du parte',
    );
    return '$_temp0';
  }

  @override
  String activityJoinedNbTeams(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count taldetara sartu da',
      one: 'Talde ${count}era sartu da',
    );
    return '$_temp0';
  }

  @override
  String get arenaArena => 'Arena';

  @override
  String get arenaArenaTournaments => 'Arena Txapelketak';

  @override
  String get arenaIsItRated => 'Sailkapenerako balio du?';

  @override
  String get arenaWillBeNotified =>
      'Txapelketa hasten denean jakinarazpen bat bidaliko dizugu, beraz beste fitxa baten beste partida bat jokatu dezakezu txapelketaren zain zauden artean.';

  @override
  String get arenaIsRated =>
      'Txapelketa honek sailkapenerako balio duenez, zuren sailkapenaren puntuazioa aldatuko du.';

  @override
  String get arenaIsNotRated =>
      'Txapelketa *ez bada* sailkatutakoa, *ez du* zure sailkapenean eraginik izango.';

  @override
  String get arenaSomeRated =>
      'Txapelketa batzuk sailkapenerako balio dutenez zure sailkapenaren puntuazioa aldatuko dute.';

  @override
  String get arenaHowAreScoresCalculated => 'Nola kalkulatzen dira puntuazioak?';

  @override
  String get arenaHowAreScoresCalculatedAnswer =>
      'Garaipenak 2 puntu ematen ditu, berdinketak puntu 1 eta porrotak bat ere ez.\nBi partida jarraian irabazten badituzu, suaren ikonoa agertuko da.\nHurrengo partidek puntu-bikoitzen balioa izango dute, bat irabazten ez duzun arte.\nHau da, garaipenak 4 puntu emango dizkizu, berdinketak 2 eta porrotak bat ere ez.\n\nAdibidez, bi partida irabazi eta jarraian bat berdintzeak 6 puntu balioko ditu: 2 + 2 + (2 x 1)';

  @override
  String get arenaBerserk => 'Arena Berserk';

  @override
  String get arenaBerserkAnswer =>
      'Jokalari batek partidaren hasieran Berserk botoia sakatzen badu, bere erlojuko denbora erdia galduko du, baina partida irabazten badu puntu gehigarri bat lortuko du.\n\nBerserk erabiltzen baduzu denbora gehigarria ematen duten denbora kontroletan, honek denbora gehigarria ere bertan behera utziko du (1+2 da salbuespen bakarra, 1+0 ematen du).\n\nBerserk ezin da erabili hasierako denbora zero den denbora kontroletan (0+1, 0+2).\n\nBerserk-ek puntu gehigarria emango dizu paridan gutxienez 7 jokaldi egiten badituzu.';

  @override
  String get arenaHowIsTheWinnerDecided => 'Nola erabakitzen da garailea?';

  @override
  String get arenaHowIsTheWinnerDecidedAnswer =>
      'Txapelketari ezarritako denbora-muga heltzean puntu gehien duten jokalariak, garaile izendatuko dira.';

  @override
  String get arenaHowDoesPairingWork => 'Nola funtzionatzen dute parekatzeek?';

  @override
  String get arenaHowDoesPairingWorkAnswer =>
      'Txapelketaren hasieran jokalariak beren sailkapenaren arabera parekatuko dira.\nPartida bat bukatu bezain laster, itzuli txapelketaren egongelara: jarraian zure sailkapenaren antzekoa duen beste jokalari baten aurka jokatuko duzu. Horrela ahalik eta denbora gutxien itxarotea lortzen da nahiz eta ez jokatu txapelketako beste jokalari guztiekin.\nJokatu azkar, itzuli egongelara partida gehiago jokatu eta puntu gehiago irabazteko.';

  @override
  String get arenaHowDoesItEnd => 'Nola bukatzen da?';

  @override
  String get arenaHowDoesItEndAnswer =>
      'Txapelketak atzerako kontagailua du. Zerora iristean, txapelketaren sailkapena bere horretan gordeko da eta irabazlea nor den jakinaraziko da. Jokoan daduden partidak bukatu egin beharko dira nahiz eta ez duten txapelketarako kontatuko.';

  @override
  String get arenaOtherRules => 'Beste arau garrantzitsu batzuk';

  @override
  String get arenaThereIsACountdown =>
      'Lehenengo jokaldia egiteko denbora muga dago. Jokaldia denbora hori igaro aurretik egiten ez baduzu, partida galdutzat emango dizugu.';

  @override
  String get arenaThisIsPrivate => 'Hau txapelketa pribatua da';

  @override
  String arenaShareUrl(String param) {
    return 'Partekatu helbide hau jendeak parte har dezan: $param';
  }

  @override
  String arenaDrawStreakStandard(String param) {
    return 'Berdinketa erreskada: jokalari baten hainbat berdinketa jarraian egin dituenean, lehenengoak bakarrik edo $param jokaldi baino gehiagoko partidek emango diote puntua partida estandarretan. Berdinketa erreskada garaipen batek bakarrik apurtu dezake, inoiz ez porrot edo beste berdinketa batek.';
  }

  @override
  String get arenaDrawStreakVariants =>
      'Berdinketa gisa amaitzen diren partiden luzera desberdina da aldaeraren arabera. Beheko taulan agertzen da aldaera bakoitzari dagokiona.';

  @override
  String get arenaVariant => 'Aldaera';

  @override
  String get arenaMinimumGameLength => 'Partidaren gutxieneko luzera';

  @override
  String get arenaHistory => 'Arena historikoa';

  @override
  String get arenaNewTeamBattle => 'Taldeen Arteko Txapelketa berria';

  @override
  String get arenaCustomStartDate => 'Pertsonalizatutako hasiera data';

  @override
  String get arenaCustomStartDateHelp =>
      'Zure ordu-zonan. Honek \"Txapeketa hasi aurreko denbora\" ezarpena gainidazten du';

  @override
  String get arenaAllowBerserk => 'Berserk onartu';

  @override
  String get arenaAllowBerserkHelp =>
      'Utzi jokalariei beren denbora erdira jaisten puntu gehigarri bat lortzeko';

  @override
  String get arenaAllowChatHelp => 'Utzi jokalariei txatean hitz egiten';

  @override
  String get arenaArenaStreaks => 'Arena boladak';

  @override
  String get arenaArenaStreaksHelp =>
      'Bi garaipenen ostean, jarraian datozen garaipenek 4 puntu emango dituzte 2 eman beharrean.';

  @override
  String get arenaNoBerserkAllowed => 'Ez da Berserkik onartzen';

  @override
  String get arenaNoArenaStreaks => 'Ez da Arena boladarik onartzen';

  @override
  String get arenaAveragePerformance => 'Bataz besteko performancea';

  @override
  String get arenaAverageScore => 'Batez besteko puntuazioa';

  @override
  String get arenaMyTournaments => 'Nire txapelketak';

  @override
  String get arenaEditTournament => 'Editatu txapelketa';

  @override
  String get arenaEditTeamBattle => 'Editatu taldekako txapelketa';

  @override
  String get arenaDefender => 'Aurreko txapelduna';

  @override
  String get arenaPickYourTeam => 'Aukeratu zure taldea';

  @override
  String get arenaWhichTeamWillYouRepresentInThisBattle => 'Zein talderen izenean jokatuko duzu?';

  @override
  String get arenaYouMustJoinOneOfTheseTeamsToParticipate =>
      'Parte hartzeko talde hauetako baten kide izan behar zara!';

  @override
  String get arenaCreated => 'Sortuta';

  @override
  String get arenaRecentlyPlayed => 'Azkenaldian jokatuta';

  @override
  String get arenaBestResults => 'Emaitza onenak';

  @override
  String get arenaTournamentStats => 'Txapelketaren estatistikak';

  @override
  String get arenaRankAvgHelp =>
      'Sailkapenaren bataz bestekoa zure puntuazioaren ehuneko bat da. Baxuagoa hobe da.\n\nAdibidez, 100 jokalariko txapelketa baten 3. sailkatzea = %3. 1000 jokalariko txapelketa baten 10. sailkatzea = %1.';

  @override
  String get arenaMedians => 'medianak';

  @override
  String arenaAllAveragesAreX(String param) {
    return 'Orrialde honetako batazbesteko guztiak $param dira.';
  }

  @override
  String get arenaTotal => 'Guztira';

  @override
  String get arenaPointsAvg => 'Bataz besteko puntuak';

  @override
  String get arenaPointsSum => 'Puntuen batuketa';

  @override
  String get arenaRankAvg => 'Sailkapenaren bataz bestekoa';

  @override
  String get arenaTournamentWinners => 'Txapelketaren irabazleak';

  @override
  String get arenaTournamentShields => 'Txapelketen garaikurrak';

  @override
  String get arenaOnlyTitled => 'Tituludun jokalariak bakarrik';

  @override
  String get arenaOnlyTitledHelp => 'Eskatu titulu ofiziala izatea txapelketan sartzeko';

  @override
  String get arenaTournamentPairingsAreNowClosed => 'Txapelketaren parekatzeak itxita daude jada.';

  @override
  String get arenaBerserkRate => 'Berserk ratioa';

  @override
  String arenaDrawingWithinNbMoves(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'Lehenengo $count jokaldiren aurretik partida berdintzean, jokalari batek ere ez du punturik lortuko.',
      one:
          '$count jokaldiaren aurretik partida berdintzean, jokalari batek ere ez du punturik lortuko.',
    );
    return '$_temp0';
  }

  @override
  String arenaViewAllXTeams(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count taldeak ikusi',
      one: 'Taldea ikusi',
    );
    return '$_temp0';
  }

  @override
  String get broadcastBroadcasts => 'Emanaldiak';

  @override
  String get broadcastMyBroadcasts => 'Nire zuzenekoak';

  @override
  String get broadcastLiveBroadcasts => 'Txapelketen zuzeneko emanaldiak';

  @override
  String get broadcastBroadcastCalendar => 'Emanaldien egutegia';

  @override
  String get broadcastNewBroadcast => 'Zuzeneko emanaldi berria';

  @override
  String get broadcastSubscribedBroadcasts => 'Harpidetutako emanaldiak';

  @override
  String get broadcastAboutBroadcasts => 'Zuzeneko emanaldiei buruz';

  @override
  String get broadcastHowToUseLichessBroadcasts => 'Nola erabili Lichessen Zuzenekoak.';

  @override
  String get broadcastTheNewRoundHelp =>
      'Txanda berriak aurrekoak beste kide eta laguntzaile izango ditu.';

  @override
  String get broadcastAddRound => 'Gehitu txanda bat';

  @override
  String get broadcastOngoing => 'Orain martxan';

  @override
  String get broadcastUpcoming => 'Hurrengo emanaldiak';

  @override
  String get broadcastRoundName => 'Txandaren izena';

  @override
  String get broadcastRoundNumber => 'Txanda zenbaki';

  @override
  String get broadcastTournamentName => 'Txapelketaren izena';

  @override
  String get broadcastTournamentDescription => 'Txapelketaren deskribapen laburra';

  @override
  String get broadcastFullDescription => 'Ekitaldiaren deskribapen osoa';

  @override
  String broadcastFullDescriptionHelp(String param1, String param2) {
    return 'Emanaldiaren azalpen luzea, hautazkoa da. $param1 badago. Luzera $param2 karaktere edo laburragoa izan behar da.';
  }

  @override
  String get broadcastSourceSingleUrl => 'PGNaren jatorrizko URLa';

  @override
  String get broadcastSourceUrlHelp =>
      'Lichessek PGNaren eguneraketak jasoko dituen URLa. Interneteko helbide bat izan behar da.';

  @override
  String get broadcastSourceGameIds =>
      'Gehienez ere Lichesseko 64 partidren idak, espazioekin banatuta.';

  @override
  String broadcastStartDateTimeZone(String param) {
    return 'Txapelketaren hasiera ordua ordu-zona lokalean: $param';
  }

  @override
  String get broadcastStartDateHelp => 'Hautazkoa, ekitaldia noiz hasten den baldin badakizu';

  @override
  String get broadcastCurrentGameUrl => 'Uneko partidaren URL helbidea';

  @override
  String get broadcastDownloadAllRounds => 'Deskargatu txanda guztiak';

  @override
  String get broadcastResetRound => 'Berrezarri txanda hau';

  @override
  String get broadcastDeleteRound => 'Ezabatu txanda hau';

  @override
  String get broadcastDefinitivelyDeleteRound => 'Betiko ezabatu txanda eta bere partida guztiak.';

  @override
  String get broadcastDeleteAllGamesOfThisRound =>
      'Ezabatu txanda honetako partida guztiak. Jatorria aktibo egon behar da berriz sortzeko.';

  @override
  String get broadcastEditRoundStudy => 'Editatu txandako azterlana';

  @override
  String get broadcastDeleteTournament => 'Ezabatu txapelketa hau';

  @override
  String get broadcastDefinitivelyDeleteTournament =>
      'Txapelketa behin betiko ezabatu, bere txanda eta partida guztiak barne.';

  @override
  String get broadcastShowScores => 'Erakutsi jokalarien puntuazioak partiden emaitzen arabera';

  @override
  String get broadcastReplacePlayerTags =>
      'Hautazkoa: aldatu jokalarien izen, puntuazio eta tituluak';

  @override
  String get broadcastFideFederations => 'FIDE federazioak';

  @override
  String get broadcastTop10Rating => '10 onenak';

  @override
  String get broadcastFidePlayers => 'FIDE jokalariak';

  @override
  String get broadcastFidePlayerNotFound => 'FIDE jokalaria ez da aurkitu';

  @override
  String get broadcastFideProfile => 'FIDE profila';

  @override
  String get broadcastFederation => 'Federazioa';

  @override
  String get broadcastAgeThisYear => 'Adina';

  @override
  String get broadcastUnrated => 'Ez du sailkapenik';

  @override
  String get broadcastRecentTournaments => 'Azken txapelketak';

  @override
  String get broadcastOpenLichess => 'Ireki Lichessen';

  @override
  String get broadcastTeams => 'Taldeak';

  @override
  String get broadcastBoards => 'Taulak';

  @override
  String get broadcastOverview => 'Laburpena';

  @override
  String get broadcastSubscribeTitle =>
      'Harpidetu txanda bakoitza hastean jakinarazpena jasotzeko. Kanpaia edo push erako notifikazioak zure kontuaren hobespenetan aktibatu ditzakezu.';

  @override
  String get broadcastUploadImage => 'Kargatu txapelketaren irudia';

  @override
  String get broadcastNoBoardsYet => 'Taularik ez oraindik. Partidak igotzean agertuko dira.';

  @override
  String broadcastBoardsCanBeLoaded(String param) {
    return 'Taulak iturburu batekin edo ${param}ren bidez kargatu daitezke';
  }

  @override
  String broadcastStartsAfter(String param) {
    return '${param}ren ondoren hasiko da';
  }

  @override
  String get broadcastStartVerySoon => 'Zuzenekoa berehala hasiko da.';

  @override
  String get broadcastNotYetStarted => 'Zuzenekoa ez da oraindik hasi.';

  @override
  String get broadcastOfficialWebsite => 'Webgune ofiziala';

  @override
  String get broadcastStandings => 'Sailkapena';

  @override
  String get broadcastOfficialStandings => 'Sailkapen ofiziala';

  @override
  String broadcastIframeHelp(String param) {
    return 'Aukera gehiago ${param}ean';
  }

  @override
  String get broadcastWebmastersPage => 'webmasterraren webgune';

  @override
  String broadcastPgnSourceHelp(String param) {
    return 'Txanda honen zuzeneko PGN iturburua. $param ere eskaintzen dugu sinkronizazio zehatzagoa nahi baduzu.';
  }

  @override
  String get broadcastEmbedThisBroadcast => 'Txertatu zuzeneko hau zure webgunean';

  @override
  String broadcastEmbedThisRound(String param) {
    return 'Txertatu $param zure webgunean';
  }

  @override
  String get broadcastRatingDiff => 'Elo diferentzia';

  @override
  String get broadcastGamesThisTournament => 'Txapelketa honetako partidak';

  @override
  String get broadcastScore => 'Emaitza';

  @override
  String get broadcastAllTeams => 'Talde guztiak';

  @override
  String get broadcastTournamentFormat => 'Txapelketaren formatua';

  @override
  String get broadcastTournamentLocation => 'Txapelketaren kokalekua';

  @override
  String get broadcastTopPlayers => 'Jokalari onenak';

  @override
  String get broadcastTimezone => 'Ordu-zona';

  @override
  String get broadcastFideRatingCategory => 'FIDE rating kategoria';

  @override
  String get broadcastOptionalDetails => 'Hautazko xehetasunak';

  @override
  String get broadcastPastBroadcasts => 'Pasatutako zuzenekoak';

  @override
  String get broadcastAllBroadcastsByMonth => 'Ikusi zuzeneko guztiak hilabeteka';

  @override
  String get broadcastBackToLiveMove => 'Zuzeneko jokaldi-modura itzuli';

  @override
  String get broadcastSinceHideResults =>
      'Emaitzak ezkutatzea erabaki duzunez, taulen aurreikuspenak hutsik daude.';

  @override
  String get broadcastLiveboard => 'Zuzeneko taula';

  @override
  String broadcastNbBroadcasts(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count zuzeneko',
      one: 'Zuzeneko $count',
    );
    return '$_temp0';
  }

  @override
  String broadcastNbViewers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ikusle',
      one: 'Ikusle $count',
    );
    return '$_temp0';
  }

  @override
  String challengeChallengesX(String param1) {
    return 'Erronkak: $param1';
  }

  @override
  String get challengeChallengeToPlay => 'Partida baterako erronka egin';

  @override
  String get challengeChallengeDeclined => 'Erronka baztertuta';

  @override
  String get challengeChallengeAccepted => 'Erronka onartuta!';

  @override
  String get challengeChallengeCanceled => 'Erronka bertan behera utzita.';

  @override
  String get challengeRegisterToSendChallenges => 'Eman izena erronkak bidaltzeko.';

  @override
  String challengeYouCannotChallengeX(String param) {
    return 'Ezin diozu $param erabiltzaileri erronka egin.';
  }

  @override
  String challengeXDoesNotAcceptChallenges(String param) {
    return '$param erabiltzaileak ez du erronkarik onartzen.';
  }

  @override
  String challengeYourXRatingIsTooFarFromY(String param1, String param2) {
    return 'Zure $param1 puntuazioa urrunegi dago $param2-tik.';
  }

  @override
  String challengeCannotChallengeDueToProvisionalXRating(String param) {
    return 'Ezin duzu erronkarik egin behin-behineko $param puntuazioa duzulako.';
  }

  @override
  String challengeXOnlyAcceptsChallengesFromFriends(String param) {
    return '$param erabiltzaileak bere lagunen erronkak onartzen ditu bakarrik.';
  }

  @override
  String get challengeDeclineGeneric => 'Orain ez dut erronkarik onartzen.';

  @override
  String get challengeDeclineLater => 'Hori ez da momenturik onena, eskatu beranduago.';

  @override
  String get challengeDeclineTooFast =>
      'Erritmo hori azkarregia da, proposatu partida geldoago bat.';

  @override
  String get challengeDeclineTooSlow =>
      'Erritmo hori geldoegia da, proposatu partida azkarrago bat.';

  @override
  String get challengeDeclineTimeControl => 'Ez dut erritmo horretako erronkarik onartzen.';

  @override
  String get challengeDeclineRated => 'Mesedez bidali puntuaziorako balio duen erronka bat.';

  @override
  String get challengeDeclineCasual =>
      'Mesedez bidali lagunarteko erronka bat, puntuaziorako balio ez duena.';

  @override
  String get challengeDeclineStandard => 'Ez dut aldaeren erronkarik onartzen.';

  @override
  String get challengeDeclineVariant => 'Ez dut aldaera horretan jokatu nahi.';

  @override
  String get challengeDeclineNoBot => 'Ez dut erroboten erronkarik onartzen.';

  @override
  String get challengeDeclineOnlyBot => 'Erroboten erronkak bakarrik onartzen ditut.';

  @override
  String get challengeInviteLichessUser => 'Edo gonbidatu Lichesseko erabiltzaile bat:';

  @override
  String get contactContact => 'Harremana';

  @override
  String get contactContactLichess => 'Jarri kontaktuan Lichessekin';

  @override
  String get patronDonate => 'Dirua eman';

  @override
  String get patronLichessPatron => 'Lichess babeslea';

  @override
  String perfStatPerfStats(String param) {
    return '$param estatistikak';
  }

  @override
  String get perfStatViewTheGames => 'Partidak ikusi';

  @override
  String get perfStatProvisional => 'behin-behinekoa';

  @override
  String get perfStatNotEnoughRatedGames =>
      'Ez duzu puntuaziorako balio duten behar adina partida jokatu.';

  @override
  String perfStatProgressOverLastXGames(String param) {
    return 'Azken $param partidetako aurrerapena:';
  }

  @override
  String perfStatRatingDeviation(String param) {
    return 'Puntuazioaren desbideraketa: $param.';
  }

  @override
  String perfStatRatingDeviationTooltip(String param1, String param2, String param3) {
    return 'Balio baxuagoak puntuazioa egonkorragoa dela esan nahi du. ${param1}tik gorako balioak puntuazioa behin-behinekoa dela esan nahi du. Sailkapenetan agertzeko, balio hori $param2 baino baxuagoa (xake estandarrean) eta $param3 baino baxuagoa (aldaeretan) izan behar da.';
  }

  @override
  String get perfStatTotalGames => 'Partida kopurua';

  @override
  String get perfStatRatedGames => 'Puntuaziorako balio duten partidak';

  @override
  String get perfStatTournamentGames => 'Txapelketetako partidak';

  @override
  String get perfStatBerserkedGames => 'Berserk erabilitako partidak';

  @override
  String get perfStatTimeSpentPlaying => 'Jokatzen emandako denbora';

  @override
  String get perfStatAverageOpponent => 'Aurkarien batazbestekoa';

  @override
  String get perfStatVictories => 'Garaipenak';

  @override
  String get perfStatDefeats => 'Porrotak';

  @override
  String get perfStatDisconnections => 'Deskonektatutakoak';

  @override
  String get perfStatNotEnoughGames => 'Ez duzu partida nahiko jokatu';

  @override
  String perfStatHighestRating(String param) {
    return 'Puntuazio altuena: $param';
  }

  @override
  String perfStatLowestRating(String param) {
    return 'Puntuazio baxuena: $param';
  }

  @override
  String perfStatFromXToY(String param1, String param2) {
    return '$param1 - $param2';
  }

  @override
  String get perfStatWinningStreak => 'Garaipenen segida';

  @override
  String get perfStatLosingStreak => 'Porroten segida';

  @override
  String perfStatLongestStreak(String param) {
    return 'Segida luzeena: $param';
  }

  @override
  String perfStatCurrentStreak(String param) {
    return 'Uneko segida: $param';
  }

  @override
  String get perfStatBestRated => 'Garaipen onenak';

  @override
  String get perfStatGamesInARow => 'Jarraian jokatutako partida kopurua';

  @override
  String get perfStatLessThanOneHour => 'Partiden artean ordubete baino gutxiago';

  @override
  String get perfStatMaxTimePlaying => 'Jokatzen emandako denbora gehiena';

  @override
  String get perfStatNow => 'orain';

  @override
  String get preferencesPreferences => 'Lehentasunak';

  @override
  String get preferencesDisplay => 'Erakutsi';

  @override
  String get preferencesPrivacy => 'Pribatutasuna';

  @override
  String get preferencesNotifications => 'Jakinarazpenak';

  @override
  String get preferencesPieceAnimation => 'Piezen animazioa';

  @override
  String get preferencesMaterialDifference => 'Material desoreka';

  @override
  String get preferencesBoardHighlights => 'Taulan markak erakutsi (azken jokaldia eta xakea)';

  @override
  String get preferencesPieceDestinations =>
      'Piezen norakoak (jokaldi zuzenak eta aurre-jokaldiak)';

  @override
  String get preferencesBoardCoordinates => 'Taularen koordinatutak (A-H, 1-8)';

  @override
  String get preferencesMoveListWhilePlaying => 'Jokaldi-zerrenda partidan zehar';

  @override
  String get preferencesPgnPieceNotation => 'Jokaldien idazketa';

  @override
  String get preferencesChessPieceSymbol => 'Xake piezen ikurra';

  @override
  String get preferencesPgnLetter => 'Hizkiak (K, Q, R, B, N)';

  @override
  String get preferencesZenMode => 'Zen modua';

  @override
  String get preferencesShowPlayerRatings => 'Erakutsi jokalarien puntuazioak';

  @override
  String get preferencesShowFlairs => 'Ikusi jokalarien iruditxoak';

  @override
  String get preferencesExplainShowPlayerRatings =>
      'Horri esker, gunearen puntuazio guztiak ezkutatu daitezke, xakean arreta jartzen laguntzeko. Partidak puntuka izan daitezke oraindik, hau da zuk ikus dezakezuna.';

  @override
  String get preferencesDisplayBoardResizeHandle =>
      'Xake-taularen tamaina aldatzeko aukera erakutsi';

  @override
  String get preferencesOnlyOnInitialPosition => 'Hasierako posizioan bakarrik';

  @override
  String get preferencesInGameOnly => 'Partidan zehar bakarrik';

  @override
  String get preferencesExceptInGame => 'Jokoan zehar izan ezik';

  @override
  String get preferencesChessClock => 'Xake-erlojua';

  @override
  String get preferencesTenthsOfSeconds => 'Segundo-hamarrenak erakutsi';

  @override
  String get preferencesWhenTimeRemainingLessThanTenSeconds =>
      'Denbora 10 segundotik behera dagoenean';

  @override
  String get preferencesHorizontalGreenProgressBars => 'Aurrerabide-barra berdea horizontalki';

  @override
  String get preferencesSoundWhenTimeGetsCritical => 'Soinua jo denbora bukatzear dagoenean';

  @override
  String get preferencesGiveMoreTime => 'Denbora gehiago eman';

  @override
  String get preferencesGameBehavior => 'Partidaren portaera';

  @override
  String get preferencesHowDoYouMovePieces => 'Nola mugitzen dituzu piezak?';

  @override
  String get preferencesClickTwoSquares => 'Bi laukitan klik eginda';

  @override
  String get preferencesDragPiece => 'Pieza arrastatuta';

  @override
  String get preferencesBothClicksAndDrag => 'Edozein';

  @override
  String get preferencesPremovesPlayingDuringOpponentTurn =>
      'Aldez aurretik mugitzea (aurkariaren txanda den bitartean mugitu)';

  @override
  String get preferencesTakebacksWithOpponentApproval =>
      'Jokaldia atzera botatzea  (aurkariaren onespenarekin)';

  @override
  String get preferencesInCasualGamesOnly => 'Puntu-aldaketarik gabeko partidetan bakarrik';

  @override
  String get preferencesPromoteToQueenAutomatically => 'Dama automatikoki sustatzea';

  @override
  String get preferencesExplainPromoteToQueenAutomatically =>
      'Eutsi <ctrl> tekla sakatuta sustapenean sustapen automatikoa aldi baterako desaktibatzeko';

  @override
  String get preferencesWhenPremoving => 'Aldez aurreko jokaldia egiten denean';

  @override
  String get preferencesClaimDrawOnThreefoldRepetitionAutomatically =>
      'Posizioa hirutan errepikatzen denean berdinketa automatikoki eskatu';

  @override
  String get preferencesWhenTimeRemainingLessThanThirtySeconds =>
      '30 segundo baino gutxiago geratzen denean';

  @override
  String get preferencesMoveConfirmation => 'Jokaldia baieztatzea';

  @override
  String get preferencesExplainCanThenBeTemporarilyDisabled =>
      'Partida baten zehar taularen menua erabiliz desaktibatu daiteke';

  @override
  String get preferencesInCorrespondenceGames => 'Posta bidezko partidak';

  @override
  String get preferencesCorrespondenceAndUnlimited => 'Posta-xakea,  denbora-eperik gabe';

  @override
  String get preferencesConfirmResignationAndDrawOffers =>
      'Etsitze eta berdinketa eskaeren baieztapena eskatu';

  @override
  String get preferencesCastleByMovingTheKingTwoSquaresOrOntoTheRook => 'Endrokatzeko modua';

  @override
  String get preferencesCastleByMovingTwoSquares => 'Erregea bi lauki mugitu';

  @override
  String get preferencesCastleByMovingOntoTheRook => 'Erregea gazteluaren gainera mugitu';

  @override
  String get preferencesInputMovesWithTheKeyboard => 'Jokaldiak teklatuarekin sartu';

  @override
  String get preferencesInputMovesWithVoice => 'Egin jokaldiak zure ahotsarekin';

  @override
  String get preferencesSnapArrowsToValidMoves => 'Marraztutako geziak legezko jokaldietara mugatu';

  @override
  String get preferencesSayGgWpAfterLosingOrDrawing =>
      'Txateam \"Good game, well played\" esan partida galdu edo berdintzean';

  @override
  String get preferencesYourPreferencesHaveBeenSaved => 'Zure ezarpenak ondo gorde dira.';

  @override
  String get preferencesScrollOnTheBoardToReplayMoves => 'Mugitu taula gainean jokaldiak ikusteko';

  @override
  String get preferencesCorrespondenceEmailNotification =>
      'Jaso posta elektronikoz zure posta-bidezko partiden jakinarazpenen zerrenda egunero';

  @override
  String get preferencesNotifyStreamStart => 'Streamerra zuzenean dago';

  @override
  String get preferencesNotifyInboxMsg => 'Mezu berria postontzian';

  @override
  String get preferencesNotifyForumMention => 'Foroko erantzunean aipatu zaituzte';

  @override
  String get preferencesNotifyInvitedStudy => 'Azterlanreko gonbidapena';

  @override
  String get preferencesNotifyGameEvent => 'Posta bidezko partidetan eguneraketa';

  @override
  String get preferencesNotifyChallenge => 'Erronkak';

  @override
  String get preferencesNotifyTournamentSoon => 'Txapelketa laster hasiko da';

  @override
  String get preferencesNotifyTimeAlarm => 'Posta bidezko partidaren denbora amaitzen ari da';

  @override
  String get preferencesNotifyBell => 'Kanpai bidezko jakinarazpena Lichess barruan';

  @override
  String get preferencesNotifyPush => 'Gailuko jakinarazpena Lichessen ez zaudenean';

  @override
  String get preferencesNotifyWeb => 'Nabigatzailea';

  @override
  String get preferencesNotifyDevice => 'Gailua';

  @override
  String get preferencesBellNotificationSound => 'Kanpaiaren jakinarazpen soinua';

  @override
  String get preferencesBlindfold => 'Itsuka';

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
  String get puzzleThemeAdvancedPawn => 'Peoi aurreratua';

  @override
  String get puzzleThemeAdvancedPawnDescription =>
      'Sustatuko den edo sustatze-bidean dagoen peoia da ariketa honen muina.';

  @override
  String get puzzleThemeAdvantage => 'Abantaila';

  @override
  String get puzzleThemeAdvantageDescription =>
      'Abantaila osoa lortzen saiatu (200cp ≤ ebaluazioa ≤ 600cp)';

  @override
  String get puzzleThemeAnastasiaMate => 'Anastasiaren matea';

  @override
  String get puzzleThemeAnastasiaMateDescription =>
      'Zaldun bat eta gaztelua eta damak aurkariaren erregea taularen bazter baten eta bere pieza baten artean harrapatzen dute.';

  @override
  String get puzzleThemeArabianMate => 'Mate arabiarra';

  @override
  String get puzzleThemeArabianMateDescription =>
      'Zaldun eta gaztelu banak elkarrekin lan egiten dute aurkariaren erregea xake-taularen bazter baten harrapatzeko.';

  @override
  String get puzzleThemeAttackingF2F7 => 'f2 edo f7 erasotu';

  @override
  String get puzzleThemeAttackingF2F7Description => 'f2 edo f7ko peoia helburu duen erasoa.';

  @override
  String get puzzleThemeAttraction => 'Erakarmena';

  @override
  String get puzzleThemeAttractionDescription =>
      'Aurkariaren pieza bat ondorengo erasoa erraztuko duen lauki batera mugitzeko pieza-aldaketa edo sakrifizioa.';

  @override
  String get puzzleThemeBackRankMate => 'Azken lerroko matea';

  @override
  String get puzzleThemeBackRankMateDescription =>
      'Bere piezekin trabatuta dagoenean erregeari bere errenkadan matea ematea.';

  @override
  String get puzzleThemeBishopEndgame => 'Alfilen bukaera';

  @override
  String get puzzleThemeBishopEndgameDescription =>
      'Alfilak eta peoiak bakarrik dituen partida-bukaera.';

  @override
  String get puzzleThemeBodenMate => 'Bodenen matea';

  @override
  String get puzzleThemeBodenMateDescription =>
      'Bi alfilek beren piezen artean trabatuta dagoen erregeari ematen dioten matea.';

  @override
  String get puzzleThemeCastling => 'Endrokea';

  @override
  String get puzzleThemeCastlingDescription => 'Babestu erregea eta ekarri gaztelua erasora.';

  @override
  String get puzzleThemeCapturingDefender => 'Defendatzailea harrapatu';

  @override
  String get puzzleThemeCapturingDefenderDescription =>
      'Beste pieza bat defendatzeko funtsezkoa den pieza kentzea, hurrengo jokaldietan lehenengo pieza hori harrapatzeko.';

  @override
  String get puzzleThemeCrushing => 'Zapalketa';

  @override
  String get puzzleThemeCrushingDescription =>
      'Akatsa aurkitu eta guztizko abantaila lortu. (ebaluazioa ≥ 600cp)';

  @override
  String get puzzleThemeDoubleBishopMate => 'Bi alfilen matea';

  @override
  String get puzzleThemeDoubleBishopMateDescription =>
      'Bi alfilek beren piezen artean trabatuta dagoen erregeari ematen dioten matea.';

  @override
  String get puzzleThemeDovetailMate => 'Mirubuztanaren matea';

  @override
  String get puzzleThemeDovetailMateDescription =>
      'Damak ematen duen matea erregearen ihes-laukiak bere piezekin trabatuta daudenean.';

  @override
  String get puzzleThemeEquality => 'Berdintasuna';

  @override
  String get puzzleThemeEqualityDescription =>
      'Partida galduta izatetik, berdinketa edo posizio berdintsua lortzera itzuli. (ebaluazioa ≤ 200cp)';

  @override
  String get puzzleThemeKingsideAttack => 'Erregearen aldeko erasoa';

  @override
  String get puzzleThemeKingsideAttackDescription =>
      'Aurkariaren erregearen aurkako erasoa, hau motzean endrokatu ostean.';

  @override
  String get puzzleThemeClearance => 'Garbiketa';

  @override
  String get puzzleThemeClearanceDescription =>
      'Lauki, errenkada edo diagonala garbitzen duen jokaldia, ondoren beste ideia taktiko bat erabiltzeko.';

  @override
  String get puzzleThemeDefensiveMove => 'Defentsa-jokaldia';

  @override
  String get puzzleThemeDefensiveMoveDescription =>
      'Materiala edo beste edozein abantaila galtzea ekiditeko jokaldi edo jokaldi-multzoa.';

  @override
  String get puzzleThemeDeflection => 'Desbideraketa';

  @override
  String get puzzleThemeDeflectionDescription =>
      'Aurkariaren pieza berezkoa duen betebehar batetik desbideratzea, adibidez lauki bat babestetik. Batzuetan \"gainkarga\" ere deitzen zaio.';

  @override
  String get puzzleThemeDiscoveredAttack => 'Ageriko erasoa';

  @override
  String get puzzleThemeDiscoveredAttackDescription =>
      'Beste pieza baten erasoa blokeatzen duen pieza bat mugitzea.';

  @override
  String get puzzleThemeDoubleCheck => 'Xake bikoitza';

  @override
  String get puzzleThemeDoubleCheckDescription =>
      'Bi piezarekin batera xake egitea, ageriko eraso baten ondorioz, mugitutako eta ezkutuan zegoen piezak aurkariaren erregea erasotuz.';

  @override
  String get puzzleThemeEndgame => 'Partida-bukaera';

  @override
  String get puzzleThemeEndgameDescription => 'Partidaren azken faseko taktika.';

  @override
  String get puzzleThemeEnPassantDescription =>
      'Igarotzean harrapatzeko arauarekin zerikusia duen taktika.';

  @override
  String get puzzleThemeExposedKing => 'Babesik gabeko erregea';

  @override
  String get puzzleThemeExposedKingDescription =>
      'Pieza gutxik defenditzen duten erregearen inguruko erasoa, sarri matean amaitzen dena.';

  @override
  String get puzzleThemeFork => 'Eraso bikoitza';

  @override
  String get puzzleThemeForkDescription =>
      'Mugitzen den piezak aurkariaren bi pieza batera erasotzen dituenean.';

  @override
  String get puzzleThemeHangingPiece => 'Defentsarik gabeko pieza';

  @override
  String get puzzleThemeHangingPieceDescription =>
      'Defentsarik ez duen edo defendatzaile gutxi dituen aurkariaren pieza baten ingurukoak.';

  @override
  String get puzzleThemeHookMate => 'Hooken matea';

  @override
  String get puzzleThemeHookMateDescription =>
      'Gaztelua, zalduna eta peoi batekin ematen den matea aurkariaren peoi batek bere erregearen bidea oztopatzen duelarik.';

  @override
  String get puzzleThemeInterference => 'Tartean sartzea';

  @override
  String get puzzleThemeInterferenceDescription =>
      'Aurkariaren bi piezaren artean pieza bat jartzea, horrela aurkariaren piezetako bat edo biak defentsarik gabe utziz.';

  @override
  String get puzzleThemeIntermezzo => 'Tarteko-jokaldia';

  @override
  String get puzzleThemeIntermezzoDescription =>
      'Esperotako jokaldia egin beharrean, aurkariari mehatxu bat eginez beste jokaldi bat egin aurkaria jokaldi horri erantzutera derrigortuz.';

  @override
  String get puzzleThemeKillBoxMate => 'Hilkutxaren matea';

  @override
  String get puzzleThemeKillBoxMateDescription =>
      'Gaztelua aurkariaren erregearen ondoan dago damaren laguntzarekin, honek gainera erregearen ihes-laukiak babesten ditu. Gazteluak eta damak erregea 3x3ko \"hilkutxa\" baten harrapatu dezakete.';

  @override
  String get puzzleThemeVukovicMate => 'Vukovicen matea';

  @override
  String get puzzleThemeVukovicMateDescription =>
      'Gaztelu eta zaldunak batera lan egiten dute matea emateko. Gazteluak mate ematen du hirugaren piezak lagundurik, zaldunak erregearen ihes-laukiak babesten dituen artean.';

  @override
  String get puzzleThemeKnightEndgame => 'Zaldunen finala';

  @override
  String get puzzleThemeKnightEndgameDescription =>
      'Zaldunak eta peoiak bakarrik dituen partida bukaera.';

  @override
  String get puzzleThemeLong => 'Ariketa luzea';

  @override
  String get puzzleThemeLongDescription => 'Irabazteko hiru jokaldi.';

  @override
  String get puzzleThemeMaster => 'Maisuen partidak';

  @override
  String get puzzleThemeMasterDescription =>
      'Tituludun jokalariek jokatutako partidetan oinarritutako ariketak.';

  @override
  String get puzzleThemeMasterVsMaster => 'Maisuen arteko partidak';

  @override
  String get puzzleThemeMasterVsMasterDescription =>
      'Tituludun jokalari biren artean jokatutako partidetan oinarritutako ariketak.';

  @override
  String get puzzleThemeMate => 'Mate';

  @override
  String get puzzleThemeMateDescription => 'Irabazi partida estiloarekin.';

  @override
  String get puzzleThemeMateIn1 => 'Mate baten';

  @override
  String get puzzleThemeMateIn1Description => 'Eman mate jokaldi bakarrean.';

  @override
  String get puzzleThemeMateIn2 => 'Mate bitan';

  @override
  String get puzzleThemeMateIn2Description => 'Eman mate bi jokalditan.';

  @override
  String get puzzleThemeMateIn3 => 'Mate hirutan';

  @override
  String get puzzleThemeMateIn3Description => 'Eman mate hiru jokalditan.';

  @override
  String get puzzleThemeMateIn4 => 'Mate lautan';

  @override
  String get puzzleThemeMateIn4Description => 'Eman mate lau jokalditan.';

  @override
  String get puzzleThemeMateIn5 => 'Mate 5 edo jokaldi gehiagotan';

  @override
  String get puzzleThemeMateIn5Description => 'Mate emateko sekuentzia luzea asmatu.';

  @override
  String get puzzleThemeMiddlegame => 'Erdi-jokoa';

  @override
  String get puzzleThemeMiddlegameDescription => 'Partidaren bigarren faseko taktika.';

  @override
  String get puzzleThemeOneMove => 'Jokaldi bakarreko ariketa';

  @override
  String get puzzleThemeOneMoveDescription => 'Jokaldi bakarrean ebazten den ariketa.';

  @override
  String get puzzleThemeOpening => 'Hasiera';

  @override
  String get puzzleThemeOpeningDescription => 'Partidaren lehenengo faseko taktika.';

  @override
  String get puzzleThemePawnEndgame => 'Peoien finala';

  @override
  String get puzzleThemePawnEndgameDescription => 'Peoiak bakarrik dituen finala.';

  @override
  String get puzzleThemePin => 'Iltzaketa';

  @override
  String get puzzleThemePinDescription =>
      'Iltzaketak ardatz dituen taktika, pieza bat mugitu ezin denean gehiago balio duen pieza bat airean utziko duelako.';

  @override
  String get puzzleThemePromotion => 'Sustapena';

  @override
  String get puzzleThemePromotionDescription =>
      'Sustatuko den edo sustatze-bidean dagoen peoia da ariketa honen muina.';

  @override
  String get puzzleThemeQueenEndgame => 'Damen finala';

  @override
  String get puzzleThemeQueenEndgameDescription => 'Damak eta peoiak bakarrik dituen finala.';

  @override
  String get puzzleThemeQueenRookEndgame => 'Dama eta Gaztelua';

  @override
  String get puzzleThemeQueenRookEndgameDescription =>
      'Damak, gazteluak eta peoiak bakarrik dituen finala.';

  @override
  String get puzzleThemeQueensideAttack => 'Damaren aldeko erasoa';

  @override
  String get puzzleThemeQueensideAttackDescription =>
      'Aurkariaren erregearen aurkako erasoa, hau luzean endrokatu ostean.';

  @override
  String get puzzleThemeQuietMove => 'Jokaldi lasaia';

  @override
  String get puzzleThemeQuietMoveDescription =>
      'Xakerik edo piezarik harrapatzen ez duen jokaldia, baina geldiezina den eraso bat prestatzen duena.';

  @override
  String get puzzleThemeRookEndgame => 'Gazteluen finala';

  @override
  String get puzzleThemeRookEndgameDescription => 'Gazteluak eta peoiak bakarrik dituen finala.';

  @override
  String get puzzleThemeSacrifice => 'Sakrifizioa';

  @override
  String get puzzleThemeSacrificeDescription =>
      'Geroago abantaila lortzeko epe motzean materiala entregatzea helburu duen taktika.';

  @override
  String get puzzleThemeShort => 'Ariketa laburra';

  @override
  String get puzzleThemeShortDescription => 'Bi jokaldi irabazteko.';

  @override
  String get puzzleThemeSkewer => 'Paretik kentzea';

  @override
  String get puzzleThemeSkewerDescription =>
      'Erasotua den balio handiko pieza bat mugitzea, erasotik kenduz eta bere atzean dagoen baina gutxiago balio duen pieza bat harrapatzen uztea, iltzaketaren aurkakoa.';

  @override
  String get puzzleThemeSmotheredMate => 'Ostikoaren matea';

  @override
  String get puzzleThemeSmotheredMateDescription =>
      'Zaldiak ematen duen matea, aurkariaren erregea bere piezak oztopatzen dutenez ezin delako mugitu.';

  @override
  String get puzzleThemeSuperGM => 'Super GMen partidak';

  @override
  String get puzzleThemeSuperGMDescription =>
      'Munduko jokalari onenek jokatutako partidetatik ateratako ariketak.';

  @override
  String get puzzleThemeTrappedPiece => 'Harrapatutako pieza';

  @override
  String get puzzleThemeTrappedPieceDescription =>
      'Bere jokaldiak mugatuta dituelako ihes egin ezin duen pieza.';

  @override
  String get puzzleThemeUnderPromotion => 'Sustapen txikia';

  @override
  String get puzzleThemeUnderPromotionDescription => 'Zalduna, alfila edo gaztelua sustatzea.';

  @override
  String get puzzleThemeVeryLong => 'Ariketa oso luzea';

  @override
  String get puzzleThemeVeryLongDescription => 'Irabazteko lau jokaldi edo gehiago.';

  @override
  String get puzzleThemeXRayAttack => 'X-izpien erasoa';

  @override
  String get puzzleThemeXRayAttackDescription =>
      'Aurkariaren pieza baten artetik, pieza batek lauki bat erasotu edo defendatzen duenean.';

  @override
  String get puzzleThemeZugzwang => 'Zugzwang';

  @override
  String get puzzleThemeZugzwangDescription =>
      'Aurkariak jokaldi mugatuak ditu eta jokaldi guztien bere posizioa okertu egiten dute.';

  @override
  String get puzzleThemeMix => 'Denetik pixkat';

  @override
  String get puzzleThemeMixDescription =>
      'Denetatik. Ez dakizu zer espero, beraz prestatu zure burua edozertarako! Benetako partidetan bezala.';

  @override
  String get puzzleThemePlayerGames => 'Jokalarien partidak';

  @override
  String get puzzleThemePlayerGamesDescription =>
      'Ikusi zure edo beste jokalarien partidetatik sortutako ariketak.';

  @override
  String puzzleThemePuzzleDownloadInformation(String param) {
    return 'Ariketa hauek publikoak dira, $param helbidetik deskargatu daitezke.';
  }

  @override
  String get searchSearch => 'Bilatu';

  @override
  String get settingsSettings => 'Ezarpenak';

  @override
  String get settingsCloseAccount => 'Kontua itxi';

  @override
  String get settingsManagedAccountCannotBeClosed =>
      'Zure kontua beste norbaitek kudeatzen du eta ezin da itxi.';

  @override
  String get settingsCantOpenSimilarAccount =>
      'Ezingo duzu beste kontu bat ireki izen berdinarekin, naiz eta hizki larriak eta xeheak aldatu.';

  @override
  String get settingsCancelKeepAccount => 'Utzi eta mantendu nire kontua';

  @override
  String get settingsCloseAccountAreYouSure => 'Ziur zure kontua ezabatu nahi duzula?';

  @override
  String get settingsThisAccountIsClosed => 'Kontu hau itxita dago.';

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
  String get stormMoveToStart => 'Mugitu hasteko';

  @override
  String get stormYouPlayTheWhitePiecesInAllPuzzles =>
      'Ariketa guztietan pieza zuriekin jokatuko duzu';

  @override
  String get stormYouPlayTheBlackPiecesInAllPuzzles =>
      'Ariketa guztietan pieza beltzekin jokatuko duzu';

  @override
  String get stormPuzzlesSolved => 'ariketa ebatzita';

  @override
  String get stormNewDailyHighscore => 'Eguneko marka berria!';

  @override
  String get stormNewWeeklyHighscore => 'Asteko marka berria!';

  @override
  String get stormNewMonthlyHighscore => 'Hileko marka berria!';

  @override
  String get stormNewAllTimeHighscore => 'Marka berria!';

  @override
  String stormPreviousHighscoreWasX(String param) {
    return 'Aurreko marka $param zen';
  }

  @override
  String get stormPlayAgain => 'Jokatu berriz';

  @override
  String stormHighscoreX(String param) {
    return 'Marka: $param';
  }

  @override
  String get stormScore => 'Puntuazioa';

  @override
  String get stormMoves => 'Jokaldiak';

  @override
  String get stormAccuracy => 'Zehaztasuna';

  @override
  String get stormCombo => 'Jarraiak';

  @override
  String get stormTime => 'Denbora';

  @override
  String get stormTimePerMove => 'Jokaldiko denbora';

  @override
  String get stormHighestSolved => 'Ebatzitako altuena';

  @override
  String get stormPuzzlesPlayed => 'Jokatutako ariketak';

  @override
  String get stormNewRun => 'Saiakera berria (espazioa)';

  @override
  String get stormEndRun => 'Amaitu saiakera (enter)';

  @override
  String get stormHighscores => 'Puntuazio altuenak';

  @override
  String get stormViewBestRuns => 'Ikusi saiakera onenak';

  @override
  String get stormBestRunOfDay => 'Eguneko saiakera onena';

  @override
  String get stormRuns => 'Saiakerak';

  @override
  String get stormGetReady => 'Prest!';

  @override
  String get stormWaitingForMorePlayers => 'Jokalari gehiago sartzeko zain...';

  @override
  String get stormRaceComplete => 'Lasterketa amaitu da!';

  @override
  String get stormSpectating => 'Ikusten';

  @override
  String get stormJoinTheRace => 'Sartu lasterketara!';

  @override
  String get stormStartTheRace => 'Hasi lasterketa';

  @override
  String stormYourRankX(String param) {
    return 'Zure sailkapena: $param';
  }

  @override
  String get stormWaitForRematch => 'Itxaron berriz jokatzeko';

  @override
  String get stormNextRace => 'Hurrengo lasterketa';

  @override
  String get stormJoinRematch => 'Sartu berriz jokatzera';

  @override
  String get stormWaitingToStart => 'Hasteko zain';

  @override
  String get stormCreateNewGame => 'Sortu partida berria';

  @override
  String get stormJoinPublicRace => 'Sartu lasterketa publikora';

  @override
  String get stormRaceYourFriends => 'Jokatu zure lagunekin';

  @override
  String get stormSkip => 'salto egin';

  @override
  String get stormSkipHelp => 'Lasterketa bakoitzean jokaldi bat saltatu dezakezu:';

  @override
  String get stormSkipExplanation =>
      'Jokaldi hau saltatu zure bolada mantentzeko! Lasterketa bakoitzean behin bakarrik erabili dezakezu.';

  @override
  String get stormFailedPuzzles => 'Huts egindako ariketak';

  @override
  String get stormSlowPuzzles => 'Ariketa geldoak';

  @override
  String get stormSkippedPuzzle => 'Salto egindako ariketa';

  @override
  String get stormThisWeek => 'Aste honetan';

  @override
  String get stormThisMonth => 'Hilabete honetan';

  @override
  String get stormAllTime => 'Hasieratik';

  @override
  String get stormClickToReload => 'Egin klik berriz kargatzeko';

  @override
  String get stormThisRunHasExpired => 'Lasterketa hau iraungi egin da!';

  @override
  String get stormThisRunWasOpenedInAnotherTab => 'Lasterketa hau beste fitxa baten zabaldu da!';

  @override
  String stormXRuns(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count saiakera',
      one: 'Saiakera 1',
    );
    return '$_temp0';
  }

  @override
  String stormPlayedNbRunsOfPuzzleStorm(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$param2 ariketaren $count saiakera egin dituzu',
      one: '$param2 ariketaren saiakera bat egin duzu',
    );
    return '$_temp0';
  }

  @override
  String get streamerLichessStreamers => 'Lichess streamerrak';

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
  String get timeagoJustNow => 'orain';

  @override
  String get timeagoRightNow => 'orain';

  @override
  String get timeagoCompleted => 'amaituta';

  @override
  String timeagoInNbSeconds(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count segundo barru',
      one: 'segundo $count barru',
    );
    return '$_temp0';
  }

  @override
  String timeagoInNbMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count minututan',
      one: 'minutu ${count}en',
    );
    return '$_temp0';
  }

  @override
  String timeagoInNbHours(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ordu barru',
      one: 'ordu $count barru',
    );
    return '$_temp0';
  }

  @override
  String timeagoInNbDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count egun barru',
      one: 'egun $count barru',
    );
    return '$_temp0';
  }

  @override
  String timeagoInNbWeeks(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count egun barru',
      one: 'aste $count barru',
    );
    return '$_temp0';
  }

  @override
  String timeagoInNbMonths(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count hilabete barru',
      one: 'hilabete $count barru',
    );
    return '$_temp0';
  }

  @override
  String timeagoInNbYears(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count urte barru',
      one: 'urte $count barru',
    );
    return '$_temp0';
  }

  @override
  String timeagoNbMinutesAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'orain dela $count minutu',
      one: 'orain dela minutu $count',
    );
    return '$_temp0';
  }

  @override
  String timeagoNbHoursAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'orain dela $count ordu',
      one: 'orain dela ordu $count',
    );
    return '$_temp0';
  }

  @override
  String timeagoNbDaysAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'orain dela $count egun',
      one: 'orain dela egun $count',
    );
    return '$_temp0';
  }

  @override
  String timeagoNbWeeksAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'orain dela $count aste',
      one: 'orain dela aste $count',
    );
    return '$_temp0';
  }

  @override
  String timeagoNbMonthsAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'orain dela $count hilabete',
      one: 'orain dela hilabete $count',
    );
    return '$_temp0';
  }

  @override
  String timeagoNbYearsAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'orain dela $count urte',
      one: 'orain dela urte $count',
    );
    return '$_temp0';
  }

  @override
  String timeagoNbMinutesRemaining(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count minutu falta dira',
      one: 'Minutu $count falta da',
    );
    return '$_temp0';
  }

  @override
  String timeagoNbHoursRemaining(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ordu falta dira',
      one: 'Ordu $count falta da',
    );
    return '$_temp0';
  }
}
