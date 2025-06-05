// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'l10n.dart';

// ignore_for_file: type=lint

/// The translations for Czech (`cs`).
class AppLocalizationsCs extends AppLocalizations {
  AppLocalizationsCs([String locale = 'cs']) : super(locale);

  @override
  String get mobileAllGames => 'Všechny hry';

  @override
  String get mobileAreYouSure => 'Jste si jistí?';

  @override
  String get mobileCancelTakebackOffer => 'Zrušit nabídku vrácení tahu';

  @override
  String get mobileClearButton => 'Vymazat';

  @override
  String get mobileCorrespondenceClearSavedMove => 'Vymazat uložené tahy';

  @override
  String get mobileCustomGameJoinAGame => 'Připojit se ke hře';

  @override
  String get mobileFeedbackButton => 'Zpětná vazba';

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
  String get mobileHideVariation => 'Schovej variace';

  @override
  String get mobileHomeTab => 'Domů';

  @override
  String get mobileLiveStreamers => 'Streameři';

  @override
  String get mobileMustBeLoggedIn => 'Pro zobrazení této stránky musíte být přihlášeni.';

  @override
  String get mobileNoSearchResults => 'Žádné výsledky';

  @override
  String get mobileNotFollowingAnyUser => 'Nesledujete žádného uživatele.';

  @override
  String get mobileOkButton => 'OK';

  @override
  String mobilePlayersMatchingSearchTerm(String param) {
    return 'Hráči s „$param“';
  }

  @override
  String get mobilePrefMagnifyDraggedPiece => 'Zvětšit taženou figuru';

  @override
  String get mobilePuzzleStormConfirmEndRun => 'Chceš ukončit tento běh?';

  @override
  String get mobilePuzzleStormFilterNothingToShow => 'Nic k zobrazení, prosím změn filtry';

  @override
  String get mobilePuzzleStormNothingToShow =>
      'Nic k zobrazení. Zahrajte si nějaké běhy úlohových bouří.';

  @override
  String get mobilePuzzleStormSubtitle => 'Vyřeš co nejvíce úloh za 3 minuty.';

  @override
  String get mobilePuzzleStreakAbortWarning => 'Ztratíte aktuální sérii a vaše skóre bude uloženo.';

  @override
  String get mobilePuzzleThemesSubtitle =>
      'Hraj úlohy z tvých oblíbených zahájení, nebo si vyber styl.';

  @override
  String get mobilePuzzlesTab => 'Úlohy';

  @override
  String get mobileRecentSearches => 'Nedávná vyhledávání';

  @override
  String get mobileSettingsImmersiveMode => 'Režim bez rušení';

  @override
  String get mobileSettingsImmersiveModeSubtitle =>
      'Hide system UI while playing. Use this if you are bothered by the system\'s navigation gestures at the edges of the screen. Applies to game and puzzle screens.';

  @override
  String get mobileSettingsTab => 'Nastavení';

  @override
  String get mobileShareGamePGN => 'Sdílet PGN';

  @override
  String get mobileShareGameURL => 'Sdílet URL hry';

  @override
  String get mobileSharePositionAsFEN => 'Sdílet pozici jako FEN';

  @override
  String get mobileSharePuzzle => 'Sdílet tuto úlohu';

  @override
  String get mobileShowComments => 'Zobrazit komentáře';

  @override
  String get mobileShowResult => 'Zobrazit výsledky';

  @override
  String get mobileShowVariations => 'Zobrazit variace';

  @override
  String get mobileSomethingWentWrong => 'Něco se pokazilo.';

  @override
  String get mobileSystemColors => 'Systémové barvy';

  @override
  String get mobileTheme => 'Téma';

  @override
  String get mobileToolsTab => 'Nástroje';

  @override
  String get mobileWaitingForOpponentToJoin => 'Čeká se na připojení protihráče...';

  @override
  String get mobileWatchTab => 'Sledovat';

  @override
  String get activityActivity => 'Aktivita';

  @override
  String get activityHostedALiveStream => 'Hostoval živý stream';

  @override
  String activityRankedInSwissTournament(String param1, String param2) {
    return '$param1. místo v turnaji $param2';
  }

  @override
  String get activitySignedUp => 'Vytvořen účet na lichess';

  @override
  String activitySupportedNbMonths(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Podporuje lichess.org $count měsíců jako $param2',
      many: 'Podporuje lichess.org $count měsíců jako $param2',
      few: 'Podporuje lichess.org $count měsíce jako $param2',
      one: 'Podporuje lichess.org $count měsíc jako $param2',
    );
    return '$_temp0';
  }

  @override
  String activityPracticedNbPositions(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Procvičeno $count pozic v $param2',
      many: 'Procvičeno $count pozic v $param2',
      few: 'Procvičeny $count pozice v $param2',
      one: 'Procvičena $count pozice v $param2',
    );
    return '$_temp0';
  }

  @override
  String activitySolvedNbPuzzles(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Vyřešeno $count taktických úloh',
      many: 'Vyřešeno $count taktických úloh',
      few: 'Vyřešeny $count taktické úlohy',
      one: 'Vyřešena $count taktická úloha',
    );
    return '$_temp0';
  }

  @override
  String activityPlayedNbGames(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Odehráno $count $param2 her',
      many: 'Odehráno $count $param2 her',
      few: 'Odehrány $count $param2 hry',
      one: 'Odehrána $count $param2 hra',
    );
    return '$_temp0';
  }

  @override
  String activityPostedNbMessages(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Napsal $count příspěvků do $param2',
      many: 'Napsal $count příspěvků do $param2',
      few: 'Odeslány $count příspěvky do $param2',
      one: 'Napsal $count příspěvek do $param2',
    );
    return '$_temp0';
  }

  @override
  String activityPlayedNbMoves(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Hráno $count tahů',
      many: 'Hráno $count tahů',
      few: 'Hrány $count tahy',
      one: 'Hrán $count tah',
    );
    return '$_temp0';
  }

  @override
  String activityInNbCorrespondenceGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'v $count korespondenčních partiích',
      many: 'v $count korespondenčních partiích',
      few: 'v $count korespondenčních partiích',
      one: 'v $count korespondenční partii',
    );
    return '$_temp0';
  }

  @override
  String activityCompletedNbGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Dokončeno $count korespondenčních partií',
      many: 'Dokončeno $count korespondenčních partií',
      few: 'Dokončeny $count korespondenční partie',
      one: 'Dokončena $count korespondenční partie',
    );
    return '$_temp0';
  }

  @override
  String activityCompletedNbVariantGames(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Dokončeno $count $param2 korespondenčních partii',
      many: 'Dokončeno $count $param2 korespondenčních partii',
      few: 'Dokončeny $count $param2 korespondenční partie',
      one: 'Dokončena $count $param2 korespondenční partie',
    );
    return '$_temp0';
  }

  @override
  String activityFollowedNbPlayers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Začali jste sledovat $count hráčů',
      many: 'Začali jste sledovat $count hráčů',
      few: 'Začali jste sledovat $count hráče',
      one: 'Začali jste sledovat $count hráče',
    );
    return '$_temp0';
  }

  @override
  String activityGainedNbFollowers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Získáno $count nových následovníků',
      many: 'Získáno $count nových následovníků',
      few: 'Získáni $count noví následovníci',
      one: 'Získán $count nový následovník',
    );
    return '$_temp0';
  }

  @override
  String activityHostedNbSimuls(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Hostili jste $count simultánek',
      many: 'Hostili jste $count simultánek',
      few: 'Hostili jste $count simultánky',
      one: 'Hostili jste $count simultánku',
    );
    return '$_temp0';
  }

  @override
  String activityJoinedNbSimuls(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Zúčastnili jste se $count simultánek',
      many: 'Zúčastnili jste se $count simultánek',
      few: 'Zúčastnili jste se $count simultánek',
      one: 'Zúčastnili jste se $count simultánky',
    );
    return '$_temp0';
  }

  @override
  String activityCreatedNbStudies(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Vytvořeno $count studií',
      many: 'Vytvořeno $count studií',
      few: 'Vytvořeny $count studie',
      one: 'Vytvořena $count studie',
    );
    return '$_temp0';
  }

  @override
  String activityCompetedInNbTournaments(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Účast v $count turnajích',
      many: 'Účast v $count turnajích',
      few: 'Účast ve $count turnajích',
      one: 'Účast v $count turnaji',
    );
    return '$_temp0';
  }

  @override
  String activityRankedInTournament(int count, String param2, String param3, String param4) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Skončil #$count (top $param2%) s $param3 hrami v $param4',
      many: 'Skončil #$count (top $param2%) s $param3 hrami v $param4',
      few: 'Skončil #$count (top $param2%) s $param3 hrami v $param4',
      one: 'Skončil #$count (top $param2%) s $param3 hrou v $param4',
    );
    return '$_temp0';
  }

  @override
  String activityCompetedInNbSwissTournaments(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Účast v $count švýcarských turnajích',
      many: 'Účast v $count švýcarských turnajích',
      few: 'Účast ve $count švýcarských turnajích',
      one: 'Účast v $count švýcarském turnaji',
    );
    return '$_temp0';
  }

  @override
  String activityJoinedNbTeams(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Přidal se k $count týmům',
      many: 'Přidal se k $count týmům',
      few: 'Přidal se k $count týmům',
      one: 'Přidal se k $count týmu',
    );
    return '$_temp0';
  }

  @override
  String get arenaArena => 'Aréna';

  @override
  String get arenaArenaTournaments => 'Otevřené turnaje';

  @override
  String get arenaIsItRated => 'Započítává se turnaj do ratingu?';

  @override
  String get arenaWillBeNotified =>
      'Upozorníme Vás, až turnaj začne. Během čekání můžete klidně hrát v jiné záložce prohlížeče.';

  @override
  String get arenaIsRated =>
      'Tento turnaj je hodnocený a odehrané partie budou mít vliv na Váš rating.';

  @override
  String get arenaIsNotRated =>
      'Tento turnaj není hodnocený a odehrané partie nebudou mít vliv na Váš rating.';

  @override
  String get arenaSomeRated => 'Některé turnaje jsou hodnoceny a budou mít vliv na váš rating.';

  @override
  String get arenaHowAreScoresCalculated => 'Jak se počítají turnajové body?';

  @override
  String get arenaHowAreScoresCalculatedAnswer =>
      'Výhra je v základu hodnocena 2 body, remíza 1 bodem a za prohru nezískáte žádný bod. \nJestliže ale vyhrajete dvě hry v řadě, začne Vám \"dvojitá\" série - poznáte ji podle ikony ohně u Vašeho jména.\nDokud budete vyhrávat, budou následující hry ohodnoceny dvojnásobným počtem bodů.\n\nNapříklad - dvě výhry následované remízou budou ohodnoceny 6 body: 2 + 2 + (2*1)';

  @override
  String get arenaBerserk => 'Tlačítko Berserk';

  @override
  String get arenaBerserkAnswer =>
      'Pokud hráč stiskne před začátkem partie tlačítko \"Berserk\", ztratí polovinu svého času na hodinách, ale pokud vyhraje, získá za partii o 1 bod navíc.\n\nBerserk v partiích hraných s přídavkem rovněž zruší hráči tento přídavek (např. partie hraná 4+2 se změní na 2+0, výjimkou je časová kontrola 1+2, kterou Berserk změní na 1+0)\n\nTlačítko Berserk není přístupné pro partie s nulovým základním časem (0+1, 0+2).\n\nHráč získá za Berserk bod navíc pouze v případě, že partie měla alespoň 7 tahů.';

  @override
  String get arenaHowIsTheWinnerDecided => 'Kdo se stane vítězem?';

  @override
  String get arenaHowIsTheWinnerDecidedAnswer =>
      'Hráč s nejvyšším počtem bodů na konci stanoveného časového limitu pro turnaj se stane jeho vítězem.';

  @override
  String get arenaHowDoesPairingWork => 'Jak funguje párování?';

  @override
  String get arenaHowDoesPairingWorkAnswer =>
      'Na začátku turnaje jsou hráči spárováni podle svých ratingů.\nJakmile skončíte svou partii, vraťte se do turnajové místnosti - budete spárováni s hráčem, který má podobný rating jako Vy. Díky tomu budete na další spárování čekat velmi krátce, ale pravděpodobně nebudete hrát se všemi ostatními hráči v turnaji.\nHrajte rychle a vraťte se vždy co nejdříve do turnajové místnosti - stihnete tak odehrát více her a získat více bodů.';

  @override
  String get arenaHowDoesItEnd => 'Jak turnaj končí?';

  @override
  String get arenaHowDoesItEndAnswer =>
      'Turnaj má hodiny s časovým odpočtem. Jakmile dosáhnou nuly, je žebříček turnaje zmrazen a je vyhlášen vítěz. Nedokončené hry se musí dohrát, ale nezapočítávají se již do turnajových výsledků.';

  @override
  String get arenaOtherRules => 'Další důležitá pravidla';

  @override
  String get arenaThereIsACountdown =>
      'Než uděláte svůj první tah, běží časový odpočet. Pokud nestihnete během odpočtu udělat svůj první tah, partii prohrajete.';

  @override
  String get arenaThisIsPrivate => 'Toto je soukromý turnaj';

  @override
  String arenaShareUrl(String param) {
    return 'Sdílejte tuto adresu URL, aby se mohli lidé připojit: $param';
  }

  @override
  String arenaDrawStreakStandard(String param) {
    return 'Série remíz: když hráč několikrát po sobě skončí hru remízou v aréně, pouze první remíza mu dá bod, nebo pokud k remíze dojde po více než $param tazích. Série může být ukončena pouze výhrou, ne prohrou nebo další remízou.';
  }

  @override
  String get arenaDrawStreakVariants =>
      'Minimální délka hry pro bodovanou remízu se liší podle varianty. Níže uvedená tabulka uvádí hotnotu pro danou variantu.';

  @override
  String get arenaVariant => 'Varianta';

  @override
  String get arenaMinimumGameLength => 'Minimální délka hry';

  @override
  String get arenaHistory => 'Historie arény';

  @override
  String get arenaNewTeamBattle => 'Nová týmová bitva';

  @override
  String get arenaCustomStartDate => 'Vlastní datum zahájení';

  @override
  String get arenaCustomStartDateHelp =>
      'Ve vašem vlastním časovém pásmu. Přepíše nastavení \"Čas před zahájením turnaje\"';

  @override
  String get arenaAllowBerserk => 'Povolit Berserk';

  @override
  String get arenaAllowBerserkHelp => 'Umožní hráčům snížit čas na polovinu a získat bod navíc';

  @override
  String get arenaAllowChatHelp => 'Nechat hráče diskutovat v chatu';

  @override
  String get arenaArenaStreaks => 'Série v aréně';

  @override
  String get arenaArenaStreaksHelp =>
      'Po dvou výhrách, další po sobě jdoucí výhry udělují 4 body místo 2.';

  @override
  String get arenaNoBerserkAllowed => 'Berserk mód není povolen';

  @override
  String get arenaNoArenaStreaks => 'Žádné arénové série';

  @override
  String get arenaAveragePerformance => 'Průměrný výkon';

  @override
  String get arenaAverageScore => 'Průměrné skóre';

  @override
  String get arenaMyTournaments => 'Moje turnaje';

  @override
  String get arenaEditTournament => 'Upravit turnaj';

  @override
  String get arenaEditTeamBattle => 'Upravit týmové bitvy';

  @override
  String get arenaDefender => 'Obránce';

  @override
  String get arenaPickYourTeam => 'Vyber si tým';

  @override
  String get arenaWhichTeamWillYouRepresentInThisBattle =>
      'Který tým budeš reprezentovat v této bitvě?';

  @override
  String get arenaYouMustJoinOneOfTheseTeamsToParticipate =>
      'Musíš se připojit k jednomu z těchto týmů!';

  @override
  String get arenaCreated => 'Vytvořeno';

  @override
  String get arenaRecentlyPlayed => 'Nedávno hrané';

  @override
  String get arenaBestResults => 'Nejlepší výsledky';

  @override
  String get arenaTournamentStats => 'Turnajové statistiky';

  @override
  String get arenaRankAvgHelp =>
      'Průměrný rank je procento umístění. Nižší je lepší.\n\nNapříklad, umístíte se 3 v turnaji o 100 hráčích tak rank je 3%. Umístíte se 10 v turnaji o 1000 hráčích task rank je 1%.';

  @override
  String get arenaMedians => 'mediány';

  @override
  String arenaAllAveragesAreX(String param) {
    return 'Všechny průměry na této stránce jsou $param.';
  }

  @override
  String get arenaTotal => 'Celkem';

  @override
  String get arenaPointsAvg => 'Bodový průměr';

  @override
  String get arenaPointsSum => 'Bodový součet';

  @override
  String get arenaRankAvg => 'Průměrný rank';

  @override
  String get arenaTournamentWinners => 'Turnajoví vítězové';

  @override
  String get arenaTournamentShields => 'Turnajové štíty';

  @override
  String get arenaOnlyTitled => 'Pouze hráči s titulem';

  @override
  String get arenaOnlyTitledHelp => 'Požadovat oficiální titul k připojení se do turnaje';

  @override
  String get arenaTournamentPairingsAreNowClosed => 'Turnajové rozlosování je nyní uzavřeno.';

  @override
  String get arenaBerserkRate => 'Berserkův mat';

  @override
  String arenaDrawingWithinNbMoves(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Remíza během prvních $count tahů znamená, že body nezíská ani jeden ze soupeřů.',
      many: 'Remíza během prvních $count tahů znamená, že body nezíská ani jeden ze soupeřů.',
      few: 'Remíza během prvních $count tahů znamená, že body nezíská ani jeden ze soupeřů.',
      one: 'Remíza během prvních $count tahů znamená, že body nezíská ani jeden ze soupeřů.',
    );
    return '$_temp0';
  }

  @override
  String arenaViewAllXTeams(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Zobrazit seznam všech $count týmů',
      many: 'Zobrazit $count týmů',
      few: 'Zobrazit $count týmy',
      one: 'Zobrazit tým',
    );
    return '$_temp0';
  }

  @override
  String get broadcastBroadcasts => 'Vysílání';

  @override
  String get broadcastMyBroadcasts => 'Moje vysílání';

  @override
  String get broadcastLiveBroadcasts => 'Živé přenosy turnajů';

  @override
  String get broadcastBroadcastCalendar => 'Kalendář přenosů';

  @override
  String get broadcastNewBroadcast => 'Nový živý přenos';

  @override
  String get broadcastSubscribedBroadcasts => 'Odebírané přenosy';

  @override
  String get broadcastAboutBroadcasts => 'O vysílání';

  @override
  String get broadcastHowToUseLichessBroadcasts => 'Jak používat Lichess vysílání.';

  @override
  String get broadcastTheNewRoundHelp =>
      'Nové kolo bude mít stejné členy a přispěvatele jako to předchozí.';

  @override
  String get broadcastAddRound => 'Přidat kolo';

  @override
  String get broadcastOngoing => 'Probíhající';

  @override
  String get broadcastUpcoming => 'Chystané';

  @override
  String get broadcastRoundName => 'Číslo kola';

  @override
  String get broadcastRoundNumber => 'Číslo kola';

  @override
  String get broadcastTournamentName => 'Název turnaje';

  @override
  String get broadcastTournamentDescription => 'Stručný popis turnaje';

  @override
  String get broadcastFullDescription => 'Úplný popis události';

  @override
  String broadcastFullDescriptionHelp(String param1, String param2) {
    return 'Volitelný dlouhý popis přenosu. $param1 je k dispozici. Délka musí být menší než $param2 znaků.';
  }

  @override
  String get broadcastSourceSingleUrl => 'PGN Zdrojová URL adresa';

  @override
  String get broadcastSourceUrlHelp =>
      'URL adresa, kterou bude Lichess kontrolovat pro získání PGN aktualizací. Musí být veřejně přístupná z internetu.';

  @override
  String get broadcastSourceGameIds => 'Až 64 ID Lichess her, oddělených mezerama.';

  @override
  String broadcastStartDateTimeZone(String param) {
    return 'Datum zahájení v lokálním čase turnaje: $param';
  }

  @override
  String get broadcastStartDateHelp => 'Nepovinné, pokud víte, kdy událost začíná';

  @override
  String get broadcastCurrentGameUrl => 'URL adresa právě probíhající partie';

  @override
  String get broadcastDownloadAllRounds => 'Stáhnout hry ze všech kol';

  @override
  String get broadcastResetRound => 'Resetovat toto kolo';

  @override
  String get broadcastDeleteRound => 'Smazat toto kolo';

  @override
  String get broadcastDefinitivelyDeleteRound => 'Definitivně smazat kolo a jeho hry.';

  @override
  String get broadcastDeleteAllGamesOfThisRound =>
      'Smazat všechny hry v tomto kole. Zdroj musí být aktivní aby bylo možno je znovu vytvořit.';

  @override
  String get broadcastEditRoundStudy => 'Upravit studie kola';

  @override
  String get broadcastDeleteTournament => 'Smazat tento turnaj';

  @override
  String get broadcastDefinitivelyDeleteTournament =>
      'Opravdu smazat celý turnaj, všechna kola a hry.';

  @override
  String get broadcastShowScores => 'Zobraz skóre hráču dle herních výsledků';

  @override
  String get broadcastReplacePlayerTags => 'Volitelné: nahraď jména hráčů, rating a tituly';

  @override
  String get broadcastFideFederations => 'FIDE federace';

  @override
  String get broadcastTop10Rating => 'Rating top 10';

  @override
  String get broadcastFidePlayers => 'FIDE hráči';

  @override
  String get broadcastFidePlayerNotFound => 'FIDE hráč nenalezen';

  @override
  String get broadcastFideProfile => 'FIDE profil';

  @override
  String get broadcastFederation => 'Federace';

  @override
  String get broadcastAgeThisYear => 'Věk tento rok';

  @override
  String get broadcastUnrated => 'Nehodnocen';

  @override
  String get broadcastRecentTournaments => 'Nedávné tournamenty';

  @override
  String get broadcastOpenLichess => 'Otevřít v Lichess';

  @override
  String get broadcastTeams => 'Týmy';

  @override
  String get broadcastBoards => 'Šachovnice';

  @override
  String get broadcastOverview => 'Přehled';

  @override
  String get broadcastSubscribeTitle =>
      'Přihlaste se k odběru, abyste byli informováni o začátku každého kola. V předvolbách účtu můžete přepnout mezi zvukovými nebo push oznámeními pro vysílání.';

  @override
  String get broadcastUploadImage => 'Nahrát obrázek turnaje';

  @override
  String get broadcastNoBoardsYet => 'Zatím žádné šachovnice. Ty se zobrazí se po nahrání partií.';

  @override
  String broadcastBoardsCanBeLoaded(String param) {
    return 'Hry můžou být načteny pomocí zdroje či $param';
  }

  @override
  String broadcastStartsAfter(String param) {
    return 'Začíná po $param';
  }

  @override
  String get broadcastStartVerySoon => 'Vysílání začne velmi brzy.';

  @override
  String get broadcastNotYetStarted => 'Vysílání ještě nezačalo.';

  @override
  String get broadcastOfficialWebsite => 'Oficiální stránka';

  @override
  String get broadcastStandings => 'Pořadí';

  @override
  String get broadcastOfficialStandings => 'Oficiální pořadí';

  @override
  String broadcastIframeHelp(String param) {
    return 'Více možností na $param';
  }

  @override
  String get broadcastWebmastersPage => 'Stránka webmasterů';

  @override
  String broadcastPgnSourceHelp(String param) {
    return 'Veřejný zdroj PGN v reálném čase pro toto kolo. Nabízíme také $param pro rychlejší a efektivnější synchronizaci.';
  }

  @override
  String get broadcastEmbedThisBroadcast => 'Vložte toto vysílání na váš web';

  @override
  String broadcastEmbedThisRound(String param) {
    return 'Vložte $param na váš web';
  }

  @override
  String get broadcastRatingDiff => 'Ratingový rozdíl';

  @override
  String get broadcastGamesThisTournament => 'Hry v tomto turnaji';

  @override
  String get broadcastScore => 'Skóre';

  @override
  String get broadcastAllTeams => 'Všechny týmy';

  @override
  String get broadcastTournamentFormat => 'Formát turnaje';

  @override
  String get broadcastTournamentLocation => 'Místo konání turnaje';

  @override
  String get broadcastTopPlayers => 'Nejlepší hráči';

  @override
  String get broadcastTimezone => 'Časové pásmo';

  @override
  String get broadcastFideRatingCategory => 'Kategorie ratingu FIDE';

  @override
  String get broadcastOptionalDetails => 'Volitelné detaily';

  @override
  String get broadcastPastBroadcasts => 'Dřívější vysílání';

  @override
  String get broadcastAllBroadcastsByMonth => 'Zobrazit všechny vysílání podle měsíce';

  @override
  String get broadcastBackToLiveMove => 'Zpět k přímému tahu';

  @override
  String get broadcastSinceHideResults =>
      'Vzhledem k tomu, že jste se rozhodli skrýt výsledky, všechny náhledy jsou prázdné, abyste se vyhnuli spoilerům.';

  @override
  String get broadcastLiveboard => 'Živá deska';

  @override
  String broadcastNbBroadcasts(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count vysílání',
      many: '$count vysílání',
      few: '$count vysílání',
      one: '$count vysílání',
    );
    return '$_temp0';
  }

  @override
  String broadcastNbViewers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count diváků',
      many: '$count diváků',
      few: '$count diváků',
      one: '$count divák',
    );
    return '$_temp0';
  }

  @override
  String challengeChallengesX(String param1) {
    return 'Výzvy: $param1';
  }

  @override
  String get challengeChallengeToPlay => 'Vyzvat k partii';

  @override
  String get challengeChallengeDeclined => 'Výzva odmítnuta';

  @override
  String get challengeChallengeAccepted => 'Výzva přijata!';

  @override
  String get challengeChallengeCanceled => 'Výzva byla zrušena.';

  @override
  String get challengeRegisterToSendChallenges => 'Pro poslání výzvy se musíte zaregistrovat.';

  @override
  String challengeYouCannotChallengeX(String param) {
    return 'Nemůžete vyzvat $param.';
  }

  @override
  String challengeXDoesNotAcceptChallenges(String param) {
    return '$param nepřijímá výzvy.';
  }

  @override
  String challengeYourXRatingIsTooFarFromY(String param1, String param2) {
    return 'Vaše $param1 hodnocení je příliš daleko od $param2.';
  }

  @override
  String challengeCannotChallengeDueToProvisionalXRating(String param) {
    return 'Nelze vyzvat kvůli prozatimnímu $param elu.';
  }

  @override
  String challengeXOnlyAcceptsChallengesFromFriends(String param) {
    return '$param přijímá výzvy pouze od přátel.';
  }

  @override
  String get challengeDeclineGeneric => 'V tuto chvíli nepřijímám výzvy.';

  @override
  String get challengeDeclineLater => 'Teď nemohu, požádejte mne prosím později.';

  @override
  String get challengeDeclineTooFast =>
      'Toto časové tempo je na mne příliš rychlé, vyzvi mně prosím na pomalejší.';

  @override
  String get challengeDeclineTooSlow =>
      'Vyzvi mne prosím k delší partii, toto časové tempo je na mne moc rychlé.';

  @override
  String get challengeDeclineTimeControl =>
      'V tuto chvíli nepřijímám výzvy s tímto časovým tempem.';

  @override
  String get challengeDeclineRated => 'Vyzvěte mě raději k hodnocené partii.';

  @override
  String get challengeDeclineCasual => 'Vyzvěte mě raději k nehodnocené partii.';

  @override
  String get challengeDeclineStandard => 'Nyní nepřijímám výzvy variant.';

  @override
  String get challengeDeclineVariant => 'Tuto variantu momentálně nechci hrát.';

  @override
  String get challengeDeclineNoBot => 'Nepřijímám výzvy od botů.';

  @override
  String get challengeDeclineOnlyBot => 'Přijímám výzvy pouze od botů.';

  @override
  String get challengeInviteLichessUser => 'Nebo pozvěte uživatele Lichess:';

  @override
  String get contactContact => 'Kontakt';

  @override
  String get contactContactLichess => 'Kontaktujte Lichess';

  @override
  String get patronDonate => 'Přispět';

  @override
  String get patronLichessPatron => 'Lichess Patron';

  @override
  String perfStatPerfStats(String param) {
    return '$param statistiky';
  }

  @override
  String get perfStatViewTheGames => 'Zobrazit hry';

  @override
  String get perfStatProvisional => 'prozatímní';

  @override
  String get perfStatNotEnoughRatedGames =>
      'Nebyl odebrán dostatečný počet hodnocených her pro odhad spolehlivého ratingu.';

  @override
  String perfStatProgressOverLastXGames(String param) {
    return 'Pokrok v posledních $param hrách:';
  }

  @override
  String perfStatRatingDeviation(String param) {
    return 'Odchylka hodnocení: $param.';
  }

  @override
  String perfStatRatingDeviationTooltip(String param1, String param2, String param3) {
    return 'Nižší hodnota znamená, že je hodnocení stabilnější. Nad $param1 je hodnocení považováno za prozatímní. Pro zahrnutí do žebříčku by tato hodnota měla být nižší než $param2 (standardní šachy) nebo $param3 (varianty).';
  }

  @override
  String get perfStatTotalGames => 'Celkový počet her';

  @override
  String get perfStatRatedGames => 'Hodnocených her';

  @override
  String get perfStatTournamentGames => 'Turnajové partie';

  @override
  String get perfStatBerserkedGames => 'Beskerské hry';

  @override
  String get perfStatTimeSpentPlaying => 'Čas strávený hraním';

  @override
  String get perfStatAverageOpponent => 'Průměrný soupeř';

  @override
  String get perfStatVictories => 'Vítězství';

  @override
  String get perfStatDefeats => 'Prohry';

  @override
  String get perfStatDisconnections => 'Odpojení';

  @override
  String get perfStatNotEnoughGames => 'Nedostatek odehraných her';

  @override
  String perfStatHighestRating(String param) {
    return 'Nejvyšší rating: $param';
  }

  @override
  String perfStatLowestRating(String param) {
    return 'Nejnižší rating: $param';
  }

  @override
  String perfStatFromXToY(String param1, String param2) {
    return 'od $param1 do $param2';
  }

  @override
  String get perfStatWinningStreak => 'Série výher';

  @override
  String get perfStatLosingStreak => 'Série proher';

  @override
  String perfStatLongestStreak(String param) {
    return 'Nejdelší série: $param';
  }

  @override
  String perfStatCurrentStreak(String param) {
    return 'Aktuální série: $param';
  }

  @override
  String get perfStatBestRated => 'Nejlépe hodnocená vítězství';

  @override
  String get perfStatGamesInARow => 'Hry odehrané v řadě';

  @override
  String get perfStatLessThanOneHour => 'Méně než jedna hodina mezi hrami';

  @override
  String get perfStatMaxTimePlaying => 'Maximální čas strávený hraním';

  @override
  String get perfStatNow => 'nyní';

  @override
  String get preferencesPreferences => 'Předvolby';

  @override
  String get preferencesDisplay => 'Zobrazení';

  @override
  String get preferencesPrivacy => 'Soukromí';

  @override
  String get preferencesNotifications => 'Upozornění';

  @override
  String get preferencesPieceAnimation => 'Animace figur';

  @override
  String get preferencesMaterialDifference => 'Materiální rozdíl';

  @override
  String get preferencesBoardHighlights => 'Zvýraznění na šachovnici (poslední tah a šach)';

  @override
  String get preferencesPieceDestinations => 'Možnosti figur (možné tahy a předtahy)';

  @override
  String get preferencesBoardCoordinates => 'Souřadnice šachovnice (A-H, 1-8)';

  @override
  String get preferencesMoveListWhilePlaying => 'Seznam tahů během hry';

  @override
  String get preferencesPgnPieceNotation => 'Označení figur v notaci';

  @override
  String get preferencesChessPieceSymbol => 'Symbol šachových figur';

  @override
  String get preferencesPgnLetter => 'Anglickými písmeny (K, Q, R, B, N)';

  @override
  String get preferencesZenMode => 'Zen mód';

  @override
  String get preferencesShowPlayerRatings => 'Zobrazit hodnocení hráčů';

  @override
  String get preferencesShowFlairs => 'Zobrazovat ikony hráčů';

  @override
  String get preferencesExplainShowPlayerRatings =>
      'Toto umožňuje skrýt rating z webových stránek, což pomůže soustředit se pouze na šachy. Hodnocené hry budou mít stále dopad na Váš rating.';

  @override
  String get preferencesDisplayBoardResizeHandle =>
      'Zobrazit tlačítko pro změnu velikosti šachovnice';

  @override
  String get preferencesOnlyOnInitialPosition => 'Jen v základním postavení';

  @override
  String get preferencesInGameOnly => 'Pouze u partie';

  @override
  String get preferencesExceptInGame => 'Kromě hry';

  @override
  String get preferencesChessClock => 'Šachové hodiny';

  @override
  String get preferencesTenthsOfSeconds => 'Desetiny sekund';

  @override
  String get preferencesWhenTimeRemainingLessThanTenSeconds => 'Když zbývající čas < 10 sekund';

  @override
  String get preferencesHorizontalGreenProgressBars => 'Vodorovný indikátor průběhu';

  @override
  String get preferencesSoundWhenTimeGetsCritical => 'Zvuk, když zbývá velmi málo času';

  @override
  String get preferencesGiveMoreTime => 'Přidej čas';

  @override
  String get preferencesGameBehavior => 'Chování hry';

  @override
  String get preferencesHowDoYouMovePieces => 'Způsob provádění tahů';

  @override
  String get preferencesClickTwoSquares => 'Kliknutím na dvě pole';

  @override
  String get preferencesDragPiece => 'Přetažením figury';

  @override
  String get preferencesBothClicksAndDrag => 'Obojí';

  @override
  String get preferencesPremovesPlayingDuringOpponentTurn =>
      'Předtahy (hraní během protivníkova tahu)';

  @override
  String get preferencesTakebacksWithOpponentApproval => 'Vrácení tahu (s protihráčovým souhlasem)';

  @override
  String get preferencesInCasualGamesOnly => 'Pouze v hrách \"jen tak\"';

  @override
  String get preferencesPromoteToQueenAutomatically => 'Automaticky vyměnit za dámu';

  @override
  String get preferencesExplainPromoteToQueenAutomatically =>
      'Podržte klávesu <ctrl> při proměně figury pro dočasné pozastavení možnosti automatické proměny';

  @override
  String get preferencesWhenPremoving => 'Při předtahu';

  @override
  String get preferencesClaimDrawOnThreefoldRepetitionAutomatically =>
      'Automaticky vyžádat remízu při trojím opakování pozice';

  @override
  String get preferencesWhenTimeRemainingLessThanThirtySeconds => 'Když zbývající čas < 30 sekund';

  @override
  String get preferencesMoveConfirmation => 'Potvrzení tahu';

  @override
  String get preferencesExplainCanThenBeTemporarilyDisabled =>
      'Může být zakázáno během hry v menu šachovnice';

  @override
  String get preferencesInCorrespondenceGames => 'V korespondenčním šachu';

  @override
  String get preferencesCorrespondenceAndUnlimited => 'Korespondeční a bez limitu';

  @override
  String get preferencesConfirmResignationAndDrawOffers => 'Potvrzovat rezignaci a nabídku remízy';

  @override
  String get preferencesCastleByMovingTheKingTwoSquaresOrOntoTheRook => 'Způsob provádění rošády';

  @override
  String get preferencesCastleByMovingTwoSquares => 'Pohnout králem o dvě pole';

  @override
  String get preferencesCastleByMovingOntoTheRook => 'Pohnout králem na místo věže';

  @override
  String get preferencesInputMovesWithTheKeyboard => 'Zadávání tahů pomocí klávesnice';

  @override
  String get preferencesInputMovesWithVoice => 'Zadávání tahů hlasem';

  @override
  String get preferencesSnapArrowsToValidMoves => 'Přichytit šipky k platným tahům';

  @override
  String get preferencesSayGgWpAfterLosingOrDrawing =>
      'Řekněte \"Good game, well played\" (překlad: \"Dobrá hra, pěkně zahráno\") po porážce nebo remíze';

  @override
  String get preferencesYourPreferencesHaveBeenSaved => 'Vaše nastavení bylo uloženo.';

  @override
  String get preferencesScrollOnTheBoardToReplayMoves => 'Rolováním na šachovnici přehrát tahy';

  @override
  String get preferencesCorrespondenceEmailNotification =>
      'Denní e-mailové oznámení se seznamem vašich korespondenčních her';

  @override
  String get preferencesNotifyStreamStart => 'Streamer vysílá živě';

  @override
  String get preferencesNotifyInboxMsg => 'Nová zpráva';

  @override
  String get preferencesNotifyForumMention => 'Komentář ve fóru Vás zmiňuje';

  @override
  String get preferencesNotifyInvitedStudy => 'Pozvánka do studie';

  @override
  String get preferencesNotifyGameEvent => 'Aktualizace korespondenční hry';

  @override
  String get preferencesNotifyChallenge => 'Výzvy';

  @override
  String get preferencesNotifyTournamentSoon => 'Turnaj brzy začne';

  @override
  String get preferencesNotifyTimeAlarm => 'Dochází čas na korespondenčních hodinách';

  @override
  String get preferencesNotifyBell => 'Zvuková upozornění na Lichess';

  @override
  String get preferencesNotifyPush => 'Oznámení zařízení, když nejste na Lichess';

  @override
  String get preferencesNotifyWeb => 'Prohlížeč';

  @override
  String get preferencesNotifyDevice => 'Zařízení';

  @override
  String get preferencesBellNotificationSound => 'Typ zvukového upozornění';

  @override
  String get preferencesBlindfold => 'Páska přes oči';

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
  String get puzzleThemeAdvancedPawn => 'Postouplý pěšec';

  @override
  String get puzzleThemeAdvancedPawnDescription =>
      'Jeden z Vašich pěšců je hluboko v poli protihráče, a možná hrozí proměnou.';

  @override
  String get puzzleThemeAdvantage => 'Výhoda';

  @override
  String get puzzleThemeAdvantageDescription =>
      'Využijte své šance získat rozhodující výhodu. (200cp ≤ eval ≤ 600cp)';

  @override
  String get puzzleThemeAnastasiaMate => 'Anastáziin mat';

  @override
  String get puzzleThemeAnastasiaMateDescription =>
      'Jezdec a věž nebo královna se spojí, aby obklíčili protihráčova krále mezi krajem šachovnice a přátelskou figurou.';

  @override
  String get puzzleThemeArabianMate => 'Arabský mat';

  @override
  String get puzzleThemeArabianMateDescription =>
      'Jezdec a věž dají mat soupeřovu králi na kraji šachovnice.';

  @override
  String get puzzleThemeAttackingF2F7 => 'Útok na f2 či f7';

  @override
  String get puzzleThemeAttackingF2F7Description =>
      'Útok zaměřený na pěšce f2, resp. f7, například jako při tzv. Šustrmatu (Ovčáckém matu).';

  @override
  String get puzzleThemeAttraction => 'Zavlečení';

  @override
  String get puzzleThemeAttractionDescription =>
      'Výměna nebo obětování figur, která podpoří nebo vynutí figuru protihráče postoupit na pole, jenž umožňuje další taktický postup.';

  @override
  String get puzzleThemeBackRankMate => 'Mat na poslední řadě';

  @override
  String get puzzleThemeBackRankMateDescription =>
      'Mat krále na poslední řadě, kde je uvězněn vlastními figurami.';

  @override
  String get puzzleThemeBishopEndgame => 'Střelcové koncovky';

  @override
  String get puzzleThemeBishopEndgameDescription => 'Koncovka jen se střelci a pěšci.';

  @override
  String get puzzleThemeBodenMate => 'Bodenův mat';

  @override
  String get puzzleThemeBodenMateDescription =>
      'Dva útočící střelci na různých diagonálách dají mat soupeřovu králi, jež je zablokován svými figurami.';

  @override
  String get puzzleThemeCastling => 'Rošáda';

  @override
  String get puzzleThemeCastlingDescription => 'Schovejte krále do bezpečí a vyviňte věž.';

  @override
  String get puzzleThemeCapturingDefender => 'Odstranění obránce';

  @override
  String get puzzleThemeCapturingDefenderDescription =>
      'Sebrání figury, která brání jinou figuru, a poté dalším tahem dobereme tuto nechráněnou figuru.';

  @override
  String get puzzleThemeCrushing => 'Potrestání';

  @override
  String get puzzleThemeCrushingDescription =>
      'Odhalte chybu soupeře a získejte drtivou výhodu. (eval ≥ 600cp)';

  @override
  String get puzzleThemeDoubleBishopMate => 'Mat dvěma střelci';

  @override
  String get puzzleThemeDoubleBishopMateDescription =>
      'Dva útočící střelci na různých diagonálách dají mat soupeřovu králi.';

  @override
  String get puzzleThemeDovetailMate => 'Coziův mat';

  @override
  String get puzzleThemeDovetailMateDescription =>
      'Dáma matuje sousedícího krále, jehož jediná dvě ústupová pole blokují přátelské figurky.';

  @override
  String get puzzleThemeEquality => 'Vyrovnání pozice';

  @override
  String get puzzleThemeEqualityDescription =>
      'Zremízování či zisk vyrovnané pozice z dříve prohrané pozice. (eval ≤ 200cp)';

  @override
  String get puzzleThemeKingsideAttack => 'Útok na královském křídle';

  @override
  String get puzzleThemeKingsideAttackDescription =>
      'Útok na soupeřova krále poté, co udělal malou rošádu.';

  @override
  String get puzzleThemeClearance => 'Uvolnění';

  @override
  String get puzzleThemeClearanceDescription =>
      'Tah, často s tempem, který uvolní pole, sloupec nebo diagonálu pro následný taktický úder.';

  @override
  String get puzzleThemeDefensiveMove => 'Obranný tah';

  @override
  String get puzzleThemeDefensiveMoveDescription =>
      'Přesný tah nebo pořadí tahů, které jsou potřebné k tomu, aby nedošlo ke ztrátě materiálu nebo jiné výhody.';

  @override
  String get puzzleThemeDeflection => 'Zavlečení';

  @override
  String get puzzleThemeDeflectionDescription =>
      'Tah, který odvádí soupeřovu figuru od jejích jiných povinností, jako například bránění klíčového pole. Občas nazýváno také jako \"přetížení\".';

  @override
  String get puzzleThemeDiscoveredAttack => 'Odtažný útok';

  @override
  String get puzzleThemeDiscoveredAttackDescription =>
      'Tah figurou (například jezdcem) z cesty jiné, dalekonosné, které blokovala působnost (například věži).';

  @override
  String get puzzleThemeDoubleCheck => 'Dvojný šach';

  @override
  String get puzzleThemeDoubleCheckDescription =>
      'Šach dvěma figurami zároveň, často důsledkem odtahu. Obě figury dávají šach soupeřovu králi.';

  @override
  String get puzzleThemeEndgame => 'Koncovka';

  @override
  String get puzzleThemeEndgameDescription => 'Taktický obrat během poslední fáze hry.';

  @override
  String get puzzleThemeEnPassantDescription =>
      'Taktický prvek obsahující braní mimochodem, v rámci kterého může pěšec vzít pěšce soupeřova, který prošel přes ohrožené pole pomocí tahu o dvě pole z druhé řady.';

  @override
  String get puzzleThemeExposedKing => 'Ohrožený král';

  @override
  String get puzzleThemeExposedKingDescription =>
      'Taktika zahrnují krále s pár obránci okolo něj, obvykle vedoucí k matu.';

  @override
  String get puzzleThemeFork => 'Vidlička';

  @override
  String get puzzleThemeForkDescription =>
      'Tah, kterým tažená figura útočí na dvě protivníkovy figury najednou.';

  @override
  String get puzzleThemeHangingPiece => 'Visící figura';

  @override
  String get puzzleThemeHangingPieceDescription =>
      'Taktika zahrnující nechráněnou nebo nedostatečně chráněnou a zdarma získatelnou protivníkovu figuru.';

  @override
  String get puzzleThemeHookMate => 'Hákový mat';

  @override
  String get puzzleThemeHookMateDescription =>
      'Mat věží, jezdcem a pěšcem spolu s pěšcem nepřátelským, který blokuje ústup králi.';

  @override
  String get puzzleThemeInterference => 'Překrytí';

  @override
  String get puzzleThemeInterferenceDescription =>
      'Tah figurou na pole mezi dvě soupeřovy figury, aby jedna z nich byla nechráněná, například tah jezdcem na chráněné pole mezi dvě soupeřovy věže.';

  @override
  String get puzzleThemeIntermezzo => 'Intermezzo';

  @override
  String get puzzleThemeIntermezzoDescription =>
      'Namísto zahrání očekávaného tahu je nejdřív zahrán tah představující bezprostřední hrozbu (např. šach či napadení), na který musí soupeř odpovědět. Tomuto motivu se také říká Zwischenzug.';

  @override
  String get puzzleThemeKillBoxMate => 'Mat ve smrtící zóně';

  @override
  String get puzzleThemeKillBoxMateDescription =>
      'Věž je vedle soupeřova krále a je podporován dámou, která též blokuje úniková políčka krále. Věž a dáma tak společně uvězní soupeřova krále ve 3 krát 3 „smrtící zóně“.';

  @override
  String get puzzleThemeVukovicMate => 'Vukovicův mat';

  @override
  String get puzzleThemeVukovicMateDescription =>
      'Věž a jezdec spolupracují na matování krále. Věž dává mat za podpory třetí figury, zatímco jezdec blokuje králova úniková políčka.';

  @override
  String get puzzleThemeKnightEndgame => 'Jezdcové koncovky';

  @override
  String get puzzleThemeKnightEndgameDescription => 'Koncovka jen s jezdci a pěšci.';

  @override
  String get puzzleThemeLong => 'Dlouhá úloha';

  @override
  String get puzzleThemeLongDescription => 'Tři tahy k výhře.';

  @override
  String get puzzleThemeMaster => 'Partie mistrů';

  @override
  String get puzzleThemeMasterDescription => 'Úlohy z partií šachistů s oficiálním titulem.';

  @override
  String get puzzleThemeMasterVsMaster => 'Úlohy z mistrovských partií';

  @override
  String get puzzleThemeMasterVsMasterDescription =>
      'Úlohy z partií šachistů s oficiálním titulem.';

  @override
  String get puzzleThemeMate => 'Mat';

  @override
  String get puzzleThemeMateDescription => 'Vyhrajte hru stylově.';

  @override
  String get puzzleThemeMateIn1 => 'Mat 1. tahem';

  @override
  String get puzzleThemeMateIn1Description => 'Dejte mat prvním tahem.';

  @override
  String get puzzleThemeMateIn2 => 'Mat 2. tahem';

  @override
  String get puzzleThemeMateIn2Description => 'Dejte mat druhým tahem.';

  @override
  String get puzzleThemeMateIn3 => 'Mat 3. tahem';

  @override
  String get puzzleThemeMateIn3Description => 'Dejte mat třetím tahem.';

  @override
  String get puzzleThemeMateIn4 => 'Mat 4. tahem';

  @override
  String get puzzleThemeMateIn4Description => 'Dejte mat čtvrtým tahem.';

  @override
  String get puzzleThemeMateIn5 => 'Mat za 5 nebo více tahů';

  @override
  String get puzzleThemeMateIn5Description => 'Spočítejte dlouhou variantu vedoucí do matu.';

  @override
  String get puzzleThemeMiddlegame => 'Střední hra';

  @override
  String get puzzleThemeMiddlegameDescription => 'Taktický obrat ve střední hře.';

  @override
  String get puzzleThemeOneMove => 'Jednotažka';

  @override
  String get puzzleThemeOneMoveDescription => 'Úloha, která má pouze jeden tah.';

  @override
  String get puzzleThemeOpening => 'Zahájení';

  @override
  String get puzzleThemeOpeningDescription => 'Taktický obrat v zahájení.';

  @override
  String get puzzleThemePawnEndgame => 'Pěšcové koncovky';

  @override
  String get puzzleThemePawnEndgameDescription => 'Koncovka pouze s pěšci.';

  @override
  String get puzzleThemePin => 'Vazba';

  @override
  String get puzzleThemePinDescription =>
      'Taktika zahrnující vazby, kde se figura nemůže pohnout bez odhalení útoku na figuru vyšší hodnoty.';

  @override
  String get puzzleThemePromotion => 'Proměna figury';

  @override
  String get puzzleThemePromotionDescription => 'Proměna pěšce v dámu nebo lehkou figuru.';

  @override
  String get puzzleThemeQueenEndgame => 'Dámské koncovky';

  @override
  String get puzzleThemeQueenEndgameDescription => 'Koncovka jen s dámy a pěšci.';

  @override
  String get puzzleThemeQueenRookEndgame => 'Královna a věž';

  @override
  String get puzzleThemeQueenRookEndgameDescription =>
      'Konec hry jen s královnami, věžemi a pěšci.';

  @override
  String get puzzleThemeQueensideAttack => 'Útok na dámském křídle';

  @override
  String get puzzleThemeQueensideAttackDescription =>
      'Útok na soupeřova krále poté, co udělal dlouhou rošádu.';

  @override
  String get puzzleThemeQuietMove => 'Tichý tah';

  @override
  String get puzzleThemeQuietMoveDescription =>
      'Tah, který není ani šach ani braní, ale připraví nevyhnutelnou hrozbu na další tah.';

  @override
  String get puzzleThemeRookEndgame => 'Věžové koncovky';

  @override
  String get puzzleThemeRookEndgameDescription => 'Koncovka jen s věžemi a pěšci.';

  @override
  String get puzzleThemeSacrifice => 'Oběť';

  @override
  String get puzzleThemeSacrificeDescription =>
      'Taktika zahrnující krátkodobé vzdání materiálu, s cílem získat opět výhodu po vynucené sekvenci tahů.';

  @override
  String get puzzleThemeShort => 'Krátká úloha';

  @override
  String get puzzleThemeShortDescription => 'Dva tahy do výhry.';

  @override
  String get puzzleThemeSkewer => 'Napíchnutí';

  @override
  String get puzzleThemeSkewerDescription =>
      'Motiv zahrnující útok na figuru vyšší hodnoty, která útoku uhne, ale dovolí tak útok nebo sebrání figury nižší hodnoty za ní, opak vazby.';

  @override
  String get puzzleThemeSmotheredMate => 'Dušený mat';

  @override
  String get puzzleThemeSmotheredMateDescription =>
      'Mat jezdcem, během kterého nepřátelský král nemůže utéct, protože je blokován (dušen) vlastními figurami.';

  @override
  String get puzzleThemeSuperGM => 'Úlohy Super GM';

  @override
  String get puzzleThemeSuperGMDescription => 'Hádanky z her hraných nejlepšími hráči na světě.';

  @override
  String get puzzleThemeTrappedPiece => 'Chycená figura';

  @override
  String get puzzleThemeTrappedPieceDescription =>
      'Figura nemůže ustoupit, protože má omezenou působnost.';

  @override
  String get puzzleThemeUnderPromotion => 'Minoritní proměna';

  @override
  String get puzzleThemeUnderPromotionDescription =>
      'Proměna na jezdce, střelce či věž, jelikož proměna na dámu je v dané pozici špatná.';

  @override
  String get puzzleThemeVeryLong => 'Velmi dlouhá úloha';

  @override
  String get puzzleThemeVeryLongDescription => 'Čtyři či více tahů k vyhrávající pozici.';

  @override
  String get puzzleThemeXRayAttack => 'Rentgenový útok';

  @override
  String get puzzleThemeXRayAttackDescription =>
      'Figura útočí nebo chrání pole skrze nepřátelskou figuru.';

  @override
  String get puzzleThemeZugzwang => 'Zugzwang';

  @override
  String get puzzleThemeZugzwangDescription =>
      'Soupeř musí zahrát jakýkoliv tah, přičemž všechny zhoršují jeho pozici a zlepšují naší pozici.';

  @override
  String get puzzleThemeMix => 'Mix úloh';

  @override
  String get puzzleThemeMixDescription =>
      'Troška od všeho. Nevíte co čekat, čili jste na vše připraveni! Jako v normální partii.';

  @override
  String get puzzleThemePlayerGames => 'Z vašich her';

  @override
  String get puzzleThemePlayerGamesDescription =>
      'Vyhledejte úlohy vygenerované z vašich her, nebo z her jiného hráče.';

  @override
  String puzzleThemePuzzleDownloadInformation(String param) {
    return 'Tyto hádanky jsou ve veřejné doméně a lze je stáhnout z $param.';
  }

  @override
  String get searchSearch => 'Hledat';

  @override
  String get settingsSettings => 'Nastavení';

  @override
  String get settingsCloseAccount => 'Zrušit účet';

  @override
  String get settingsManagedAccountCannotBeClosed => 'Váš účet je spravován a nemůže být zrušen.';

  @override
  String get settingsCantOpenSimilarAccount =>
      'Nebudete moci založit nový účet se stejným jménem, a to ani když se bude lišit velikost písmen.';

  @override
  String get settingsCancelKeepAccount => 'Zrušit a zachovat můj účet';

  @override
  String get settingsCloseAccountAreYouSure => 'Opravdu chcete uzavřít svůj účet?';

  @override
  String get settingsThisAccountIsClosed => 'Tento účet je zrušen.';

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
  String get stormMoveToStart => 'Zahrajte tah pro zahájení';

  @override
  String get stormYouPlayTheWhitePiecesInAllPuzzles => 'Ve všech úlohách máte bílé figury';

  @override
  String get stormYouPlayTheBlackPiecesInAllPuzzles => 'Ve všech úlohách máte černé figury';

  @override
  String get stormPuzzlesSolved => 'úloh vyřešeno';

  @override
  String get stormNewDailyHighscore => 'Nové denní maximum!';

  @override
  String get stormNewWeeklyHighscore => 'Nové týdenní maximum!';

  @override
  String get stormNewMonthlyHighscore => 'Nové měsíční maximum!';

  @override
  String get stormNewAllTimeHighscore => 'Nový osobní rekord!';

  @override
  String stormPreviousHighscoreWasX(String param) {
    return 'Předchozí osobní rekord byl $param';
  }

  @override
  String get stormPlayAgain => 'Hrát znovu';

  @override
  String stormHighscoreX(String param) {
    return 'Nejvyšší skóre: $param';
  }

  @override
  String get stormScore => 'Skóre';

  @override
  String get stormMoves => 'Tahy';

  @override
  String get stormAccuracy => 'Přesnost';

  @override
  String get stormCombo => 'Kombo';

  @override
  String get stormTime => 'Čas';

  @override
  String get stormTimePerMove => 'Čas na tah';

  @override
  String get stormHighestSolved => 'Nejtěžší vyřešená úloha';

  @override
  String get stormPuzzlesPlayed => 'Přehrané úlohy';

  @override
  String get stormNewRun => 'Nový pokus (klávesa: Mezerník)';

  @override
  String get stormEndRun => 'Ukončit pokus (klávesa: Enter)';

  @override
  String get stormHighscores => 'Nejvyšší skóre';

  @override
  String get stormViewBestRuns => 'Zobrazit nejlepší pokusy';

  @override
  String get stormBestRunOfDay => 'Nejlepší pokus dne';

  @override
  String get stormRuns => 'Pokusy';

  @override
  String get stormGetReady => 'Připravte se!';

  @override
  String get stormWaitingForMorePlayers => 'Čeká se na připojení dalších hráčů...';

  @override
  String get stormRaceComplete => 'Závod ukončen!';

  @override
  String get stormSpectating => 'Sledování';

  @override
  String get stormJoinTheRace => 'Připojte se k závodu!';

  @override
  String get stormStartTheRace => 'Zahájit závod';

  @override
  String stormYourRankX(String param) {
    return 'Pořadí v závodu: $param';
  }

  @override
  String get stormWaitForRematch => 'Počkejte na další kolo';

  @override
  String get stormNextRace => 'Další závod';

  @override
  String get stormJoinRematch => 'Připojit se k odvetě';

  @override
  String get stormWaitingToStart => 'Čeká se na zahájení';

  @override
  String get stormCreateNewGame => 'Vytvořit nový závod';

  @override
  String get stormJoinPublicRace => 'Připojit se k veřejnému závodu';

  @override
  String get stormRaceYourFriends => 'Závodit s přáteli';

  @override
  String get stormSkip => 'přeskočit';

  @override
  String get stormSkipHelp => 'V každém závodě můžete přeskočit jeden tah:';

  @override
  String get stormSkipExplanation =>
      'Přeskočte tento tah pro zachování své série! Funguje pouze jednou za závod.';

  @override
  String get stormFailedPuzzles => 'Neúspěšné úlohy';

  @override
  String get stormSlowPuzzles => 'Pomalé úlohy';

  @override
  String get stormSkippedPuzzle => 'Přeskočené úlohy';

  @override
  String get stormThisWeek => 'Tento týden';

  @override
  String get stormThisMonth => 'Tento měsíc';

  @override
  String get stormAllTime => 'Za celou dobu';

  @override
  String get stormClickToReload => 'Kliknutím obnovte';

  @override
  String get stormThisRunHasExpired => 'Tento závod byl již smazán!';

  @override
  String get stormThisRunWasOpenedInAnotherTab => 'Váš závod byl otevřen na další stránce!';

  @override
  String stormXRuns(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count pokusů',
      many: '$count pokusů',
      few: '$count pokusy',
      one: '1 pokus',
    );
    return '$_temp0';
  }

  @override
  String stormPlayedNbRunsOfPuzzleStorm(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Odehráno $count běhů z $param2',
      many: 'Odehráno $count her $param2',
      few: 'Odehrány $count pokusy $param2',
      one: 'Odehrán jeden $param2',
    );
    return '$_temp0';
  }

  @override
  String get streamerLichessStreamers => 'Lichess streameři';

  @override
  String get studyPrivate => 'Soukromé';

  @override
  String get studyMyStudies => 'Moje studie';

  @override
  String get studyStudiesIContributeTo => 'Studie, ke kterým přispívám';

  @override
  String get studyMyPublicStudies => 'Moje veřejné studie';

  @override
  String get studyMyPrivateStudies => 'Moje soukromé studie';

  @override
  String get studyMyFavoriteStudies => 'Moje oblíbené studie';

  @override
  String get studyWhatAreStudies => 'Co jsou studie?';

  @override
  String get studyAllStudies => 'Všechny studie';

  @override
  String studyStudiesCreatedByX(String param) {
    return 'Studie vytvořené hráčem $param';
  }

  @override
  String get studyNoneYet => 'Zatím nic.';

  @override
  String get studyHot => 'Oblíbené';

  @override
  String get studyDateAddedNewest => 'Datum přidání (nejnovější)';

  @override
  String get studyDateAddedOldest => 'Datum přidání (nejstarší)';

  @override
  String get studyRecentlyUpdated => 'Nedávno aktualizované';

  @override
  String get studyMostPopular => 'Nejoblíbenější';

  @override
  String get studyAlphabetical => 'Abecedně';

  @override
  String get studyAddNewChapter => 'Přidat novou kapitolu';

  @override
  String get studyAddMembers => 'Přidat uživatele';

  @override
  String get studyInviteToTheStudy => 'Pozvat do studie';

  @override
  String get studyPleaseOnlyInvitePeopleYouKnow =>
      'Prosím zvěte pouze lidi, které znáte a kteří se chtějí aktivně připojit k této studii.';

  @override
  String get studySearchByUsername => 'Hledat podle uživatelského jména';

  @override
  String get studySpectator => 'Divák';

  @override
  String get studyContributor => 'Přispívající';

  @override
  String get studyKick => 'Vyhodit';

  @override
  String get studyLeaveTheStudy => 'Opustit studii';

  @override
  String get studyYouAreNowAContributor => 'Nyní jste přispívající';

  @override
  String get studyYouAreNowASpectator => 'Nyní jste divák';

  @override
  String get studyPgnTags => 'PGN tagy';

  @override
  String get studyLike => 'To se mi líbí';

  @override
  String get studyUnlike => 'Už se mi nelíbí';

  @override
  String get studyNewTag => 'Nový štítek';

  @override
  String get studyCommentThisPosition => 'Komentář k tomuto příspěvku';

  @override
  String get studyCommentThisMove => 'Komentář k tomuto tahu';

  @override
  String get studyAnnotateWithGlyphs => 'Popsat glyfy';

  @override
  String get studyTheChapterIsTooShortToBeAnalysed =>
      'Kapitola je moc krátká na to, aby mohla být zanalyzována.';

  @override
  String get studyOnlyContributorsCanRequestAnalysis =>
      'Pouze přispěvatelé mohou požádat o počítačovou analýzu.';

  @override
  String get studyGetAFullComputerAnalysis => 'Získejte plnou počítačovou analýzu hlavní varianty.';

  @override
  String get studyMakeSureTheChapterIsComplete =>
      'Ujistěte se, že je kapitola úplná. O analýzu můžete požádat pouze jednou.';

  @override
  String get studyAllSyncMembersRemainOnTheSamePosition =>
      'Všichni SYNCHRONIZOVANÍ členové zůstávají na stejné pozici';

  @override
  String get studyShareChanges => 'Sdílet změny s diváky a uložit je na server';

  @override
  String get studyPlaying => 'Probíhající';

  @override
  String get studyShowResults => 'Výsledky';

  @override
  String get studyShowEvalBar => 'Lišta hodnotící pozici';

  @override
  String get studyNext => 'Další';

  @override
  String get studyShareAndExport => 'Sdílení a export';

  @override
  String get studyCloneStudy => 'Klonovat';

  @override
  String get studyStudyPgn => 'PGN studie';

  @override
  String get studyChapterPgn => 'PGN kapitoly';

  @override
  String get studyCopyChapterPgn => 'Kopírovat PGN';

  @override
  String get studyDownloadGame => 'Stáhnout hru';

  @override
  String get studyStudyUrl => 'URL studie';

  @override
  String get studyCurrentChapterUrl => 'URL aktuální kapitoly';

  @override
  String get studyYouCanPasteThisInTheForumToEmbed =>
      'Tento odkaz můžete vložit např. do diskusního fóra';

  @override
  String get studyStartAtInitialPosition => 'Začít ve výchozí pozici';

  @override
  String studyStartAtX(String param) {
    return 'Začít u tahu $param';
  }

  @override
  String get studyEmbedInYourWebsite => 'Vložte vaší stránku nebo blog';

  @override
  String get studyReadMoreAboutEmbedding => 'Přečtěte si více o vkládání';

  @override
  String get studyOnlyPublicStudiesCanBeEmbedded => 'Lze vložit pouze veřejné studie!';

  @override
  String get studyOpen => 'Otevřít';

  @override
  String studyXBroughtToYouByY(String param1, String param2) {
    return '$param1 vám přináší $param2';
  }

  @override
  String get studyStudyNotFound => 'Studie nenalezena';

  @override
  String get studyEditChapter => 'Upravit kapitolu';

  @override
  String get studyNewChapter => 'Nová kapitola';

  @override
  String studyImportFromChapterX(String param) {
    return 'Importovat z $param';
  }

  @override
  String get studyOrientation => 'Orientace';

  @override
  String get studyAnalysisMode => 'Režim rozboru';

  @override
  String get studyPinnedChapterComment => 'Připnutý komentář u kapitoly';

  @override
  String get studySaveChapter => 'Uložit kapitolu';

  @override
  String get studyClearAnnotations => 'Vymazat anotace';

  @override
  String get studyClearVariations => 'Vymazat varianty';

  @override
  String get studyDeleteChapter => 'Odstranit kapitolu';

  @override
  String get studyDeleteThisChapter =>
      'Opravdu chcete odstranit tuto kapitolu? Kapitola bude navždy ztracena!';

  @override
  String get studyClearAllCommentsInThisChapter =>
      'Vymazat všechny komentáře a výtvory v této kapitole?';

  @override
  String get studyRightUnderTheBoard => 'Přímo pod šachovnicí';

  @override
  String get studyNoPinnedComment => 'Žádný';

  @override
  String get studyNormalAnalysis => 'Normální rozbor';

  @override
  String get studyHideNextMoves => 'Skrýt následující tahy';

  @override
  String get studyInteractiveLesson => 'Interaktivní lekce';

  @override
  String studyChapterX(String param) {
    return 'Kapitola: $param';
  }

  @override
  String get studyEmpty => 'Prázdné';

  @override
  String get studyStartFromInitialPosition => 'Začít z původní pozice';

  @override
  String get studyEditor => 'Tvůrce';

  @override
  String get studyStartFromCustomPosition => 'Začít od vlastní pozice';

  @override
  String get studyLoadAGameByUrl => 'Načíst hru podle URL';

  @override
  String get studyLoadAPositionFromFen => 'Načíst polohu z FEN';

  @override
  String get studyLoadAGameFromPgn => 'Načíst hru z PGN';

  @override
  String get studyAutomatic => 'Automatický';

  @override
  String get studyUrlOfTheGame => 'URL hry';

  @override
  String studyLoadAGameFromXOrY(String param1, String param2) {
    return 'Načíst hru z $param1 nebo $param2';
  }

  @override
  String get studyCreateChapter => 'Vytvořit kapitolu';

  @override
  String get studyCreateStudy => 'Vytvořit studii';

  @override
  String get studyEditStudy => 'Upravit studii';

  @override
  String get studyVisibility => 'Viditelnost';

  @override
  String get studyPublic => 'Veřejná';

  @override
  String get studyUnlisted => 'Neveřejná';

  @override
  String get studyInviteOnly => 'Pouze na pozvání';

  @override
  String get studyAllowCloning => 'Povolit klonování';

  @override
  String get studyNobody => 'Nikdo';

  @override
  String get studyOnlyMe => 'Pouze já';

  @override
  String get studyContributors => 'Přispěvatelé';

  @override
  String get studyMembers => 'Členové';

  @override
  String get studyEveryone => 'Kdokoli';

  @override
  String get studyEnableSync => 'Povolit synchronizaci';

  @override
  String get studyYesKeepEveryoneOnTheSamePosition => 'Ano, všichni zůstávají na stejné pozici';

  @override
  String get studyNoLetPeopleBrowseFreely => 'Ne, umožnit volné procházení';

  @override
  String get studyPinnedStudyComment => 'Připnutý komentář studie';

  @override
  String get studyStart => 'Začít';

  @override
  String get studySave => 'Uložit';

  @override
  String get studyClearChat => 'Vyčistit chat';

  @override
  String get studyDeleteTheStudyChatHistory =>
      'Opravdu chcete vymazat historii chatu? Operaci nelze vrátit!';

  @override
  String get studyDeleteStudy => 'Smazat studii';

  @override
  String studyConfirmDeleteStudy(String param) {
    return 'Opravdu chcete smazat celou studii? Akci nelze vrátit zpět. Zadejte název studie pro potvrzení: $param';
  }

  @override
  String get studyWhereDoYouWantToStudyThat => 'Kde chcete tuto pozici studovat?';

  @override
  String get studyGoodMove => 'Dobrý tah';

  @override
  String get studyMistake => 'Chyba';

  @override
  String get studyBrilliantMove => 'Výborný tah';

  @override
  String get studyBlunder => 'Hrubá chyba';

  @override
  String get studyInterestingMove => 'Zajímavý tah';

  @override
  String get studyDubiousMove => 'Pochybný tah';

  @override
  String get studyOnlyMove => 'Jediný tah';

  @override
  String get studyZugzwang => 'Zugzwang';

  @override
  String get studyEqualPosition => 'Rovná pozice';

  @override
  String get studyUnclearPosition => 'Nejasná pozice';

  @override
  String get studyWhiteIsSlightlyBetter => 'Bílý stojí o něco lépe';

  @override
  String get studyBlackIsSlightlyBetter => 'Černý stojí o něco lépe';

  @override
  String get studyWhiteIsBetter => 'Bílý stojí lépe';

  @override
  String get studyBlackIsBetter => 'Černý stojí lépe';

  @override
  String get studyWhiteIsWinning => 'Bílý má rozhodující výhodu';

  @override
  String get studyBlackIsWinning => 'Černý má rozhodující výhodu';

  @override
  String get studyNovelty => 'Novinka';

  @override
  String get studyDevelopment => 'Vývin';

  @override
  String get studyInitiative => 'S iniciativou';

  @override
  String get studyAttack => 'S útokem';

  @override
  String get studyCounterplay => 'S protihrou';

  @override
  String get studyTimeTrouble => 'Časová tíseň';

  @override
  String get studyWithCompensation => 'S kompenzací';

  @override
  String get studyWithTheIdea => 'S ideou';

  @override
  String get studyNextChapter => 'Další kapitola';

  @override
  String get studyPrevChapter => 'Předchozí kapitola';

  @override
  String get studyStudyActions => 'Akce pro studii';

  @override
  String get studyTopics => 'Témata';

  @override
  String get studyMyTopics => 'Moje témata';

  @override
  String get studyPopularTopics => 'Oblíbená témata';

  @override
  String get studyManageTopics => 'Správa témat';

  @override
  String get studyBack => 'Zpět';

  @override
  String get studyPlayAgain => 'Hrát znovu';

  @override
  String get studyWhatWouldYouPlay => 'Co byste v této pozici hráli?';

  @override
  String get studyYouCompletedThisLesson => 'Blahopřejeme! Dokončili jste tuto lekci.';

  @override
  String studyPerPage(String param) {
    return '$param na stránku';
  }

  @override
  String get studyGetTheTour => 'Potřebujete pomoc? Pojďme na prohlídku!';

  @override
  String get studyWelcomeToLichessStudyTitle => 'Vítejte v Lichess studiích!';

  @override
  String get studyWelcomeToLichessStudyText =>
      'To je společná analytická deska.<br><br>Použijte ji k analýze a anotování her,<br>diskutování o pozicích s přáteli,<br>a samozřejmě pro šachové lekce!<br><br>Je to výkonný nástroj, podívejme se, jak to funguje.';

  @override
  String get studySharedAndSaveTitle => 'Sdíleno a uloženo';

  @override
  String get studySharedAndSavedText =>
      'Ostatní členové mohou vidět vaše tahy v reálném čase!<br>Navíc vše je navždy uloženo.';

  @override
  String get studyStudyMembersTitle => 'Členové studie';

  @override
  String studyStudyMembersText(String param1, String param2) {
    return '$param1 Diváci si mohou prohlížet studii a psát do chatu..<br><br>$param2 Přispěvatelé mohou provádět tahy a upravovat studii.';
  }

  @override
  String studyAddMembersText(String param) {
    return 'Klikněte na $param tlačítko.<br>Pak se rozhodněte, kdo může přispět.';
  }

  @override
  String get studyStudyChaptersTitle => 'Studijní kapitoly';

  @override
  String get studyStudyChaptersText =>
      'Studie může obsahovat několik kapitol.<br>Každá kapitola má odlišnou počáteční polohu a strom tahů.';

  @override
  String get studyCommentPositionTitle => 'Komentář k pozici';

  @override
  String studyCommentPositionText(String param) {
    return 'Klikněte na tlačítko $param nebo klikněte pravým tlačítkem myši na seznam tahů vpravo.<br>Komentáře jsou sdíleny a uloženy.';
  }

  @override
  String get studyAnnotatePositionTitle => 'Anotovat pozici';

  @override
  String get studyAnnotatePositionText =>
      'Klikněte na tlačítko !?, nebo klikněte pravým tlačítkem na seznam tahů vpravo.<br>Anotační symbolyy jsou nyní sdíleny a uloženy.';

  @override
  String get studyConclusionTitle => 'Děkujeme za váš čas';

  @override
  String get studyConclusionText =>
      'Můžete naleznout <a href=\'/study/mine/hot\'>předchozí studie</a> na vaší profilové stránce.<br>Také si můžete přečíst <a href=\'//lichess.org/blog/V0KrLSkAAMo3hsi4/study-chess-the-lichess-way\'>blogový příspěvek o studdích</a>.<br>Zkušení uživatelé mohou stisknout „?“ pro zobrazení klávesových zkratek.<br>Hodně zábavy!';

  @override
  String get studyCreateChapterTitle => 'Pojďme vytvořit kapitolu studie';

  @override
  String get studyCreateChapterText =>
      'Studie může mít několik kapitol.<br>Každá kapitola má odlišný strom tahů<br>a může být vytvořena různými způsoby.';

  @override
  String get studyFromInitialPositionTitle => 'Z počáteční pozice';

  @override
  String get studyFromInitialPositionText =>
      'Jen deska pro novou hru.<br>Vhodná k prozkoumávání zahájení.';

  @override
  String get studyCustomPositionTitle => 'Vlastní pozice';

  @override
  String get studyCustomPositionText =>
      'Nastavte si desku jak chcete.<br>Vhodná ke studiu koncovek.';

  @override
  String get studyLoadExistingLichessGameTitle => 'Načíst existující lichess hru';

  @override
  String get studyLoadExistingLichessGameText =>
      'Vložte lichess game URL<br>(jako lichess.org/7fHIU0XI)<br>pro načtení hry pohyby v kapitole.';

  @override
  String get studyFromFenStringTitle => 'Z FEN';

  @override
  String get studyFromFenStringText =>
      'Vložte pozici do FEN formátu<br><i>4k3/4rb2/8/7p/8/5Q2/1PP5/1K6 w</i><br>a začněte kapitolu z pozice.';

  @override
  String get studyFromPgnGameTitle => 'Ze hry PGN';

  @override
  String get studyFromPgnGameText =>
      'Vložte hru ve formátu PGN.<br>pro načtení pohybů, komentářů a variací v kapitole.';

  @override
  String get studyVariantsAreSupportedTitle => 'Studie podporují varianty';

  @override
  String get studyVariantsAreSupportedText =>
      'Ano, můžete studovat crazyhouse<br>a všechny lichess varianty!';

  @override
  String get studyChapterConclusionText =>
      'Kapitoly jsou navždy uloženy.<br>Hodně zábavy s organizováním vašeho šachového obsahu!';

  @override
  String get studyDoubleDefeat => 'Dvojitá prohra';

  @override
  String get studyBlackDefeatWhiteCanNotWin => 'Černý prohrál, ale bílý nemůže vyhrát';

  @override
  String get studyWhiteDefeatBlackCanNotWin => 'Bílý prohrál, ale černý nemůže vyhrát';

  @override
  String studyNbChapters(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count kapitol',
      many: '$count kapitol',
      few: '$count kapitoly',
      one: '$count kapitola',
    );
    return '$_temp0';
  }

  @override
  String studyNbGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count her',
      many: '$count her',
      few: '$count hry',
      one: '$count hra',
    );
    return '$_temp0';
  }

  @override
  String studyNbMembers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count členů',
      many: '$count členů',
      few: '$count členi',
      one: '$count člen',
    );
    return '$_temp0';
  }

  @override
  String studyPasteYourPgnTextHereUpToNbGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Vložte obsah vašeho PGN souboru (až $count her)',
      many: 'Vložte obsah vašeho PGN souboru (až $count her)',
      few: 'Vložte obsah vašeho PGN souboru (až $count hry)',
      one: 'Vložte obsah vašeho PGN souboru (až $count hra)',
    );
    return '$_temp0';
  }

  @override
  String get timeagoJustNow => 'právě teď';

  @override
  String get timeagoRightNow => 'právě teď';

  @override
  String get timeagoCompleted => 'dokončeno';

  @override
  String timeagoInNbSeconds(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'za $count sekund',
      many: 'za $count sekund',
      few: 'za $count sekundy',
      one: 'za $count sekundu',
    );
    return '$_temp0';
  }

  @override
  String timeagoInNbMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'za $count minut',
      many: 'za $count minut',
      few: 'za $count minuty',
      one: 'za $count minutu',
    );
    return '$_temp0';
  }

  @override
  String timeagoInNbHours(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'za $count hodin',
      many: 'za $count hodin',
      few: 'za $count hodiny',
      one: 'za $count hodinu',
    );
    return '$_temp0';
  }

  @override
  String timeagoInNbDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'za $count dnů',
      many: 'za $count dnů',
      few: 'za $count dny',
      one: 'za $count den',
    );
    return '$_temp0';
  }

  @override
  String timeagoInNbWeeks(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'za $count týdnů',
      many: 'za $count týdnů',
      few: 'za $count týdny',
      one: 'za $count týden',
    );
    return '$_temp0';
  }

  @override
  String timeagoInNbMonths(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'za $count měsíců',
      many: 'za $count měsíců',
      few: 'za $count měsíce',
      one: 'za $count měsíc',
    );
    return '$_temp0';
  }

  @override
  String timeagoInNbYears(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'za $count let',
      many: 'za $count let',
      few: 'za $count roky',
      one: 'za $count rok',
    );
    return '$_temp0';
  }

  @override
  String timeagoNbMinutesAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'před $count minutami',
      many: 'před $count minutami',
      few: 'před $count minutami',
      one: 'před $count minutou',
    );
    return '$_temp0';
  }

  @override
  String timeagoNbHoursAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'před $count hodinami',
      many: 'před $count hodinami',
      few: 'před $count hodinami',
      one: 'před $count hodinou',
    );
    return '$_temp0';
  }

  @override
  String timeagoNbDaysAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'před $count dny',
      many: 'před $count dny',
      few: 'před $count dny',
      one: 'před $count dnem',
    );
    return '$_temp0';
  }

  @override
  String timeagoNbWeeksAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'před $count týdny',
      many: 'před $count týdny',
      few: 'před $count týdny',
      one: 'před $count týdnem',
    );
    return '$_temp0';
  }

  @override
  String timeagoNbMonthsAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'před $count měsíci',
      many: 'před $count měsíci',
      few: 'před $count měsíci',
      one: 'před $count měsícem',
    );
    return '$_temp0';
  }

  @override
  String timeagoNbYearsAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'před $count lety',
      many: 'před $count lety',
      few: 'před $count lety',
      one: 'před $count rokem',
    );
    return '$_temp0';
  }

  @override
  String timeagoNbMinutesRemaining(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Zbývá $count minut',
      many: 'Zbývá $count minut',
      few: 'Zbývají $count minuty',
      one: 'Zbývá $count minuta',
    );
    return '$_temp0';
  }

  @override
  String timeagoNbHoursRemaining(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Zbývá $count hodin',
      many: 'Zbývá $count hodin',
      few: 'Zbývají $count hodiny',
      one: 'Zbývá $count hodina',
    );
    return '$_temp0';
  }
}
