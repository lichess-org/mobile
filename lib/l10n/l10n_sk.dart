import 'package:intl/intl.dart' as intl;

import 'l10n.dart';

/// The translations for Slovak (`sk`).
class AppLocalizationsSk extends AppLocalizations {
  AppLocalizationsSk([String locale = 'sk']) : super(locale);

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
  String get activityActivity => 'Aktivita';

  @override
  String get activityHostedALiveStream => 'Vysielal naživo';

  @override
  String activityRankedInSwissTournament(String param1, String param2) {
    return 'Umiestnený ako #$param1 v $param2';
  }

  @override
  String get activitySignedUp => 'Registrácia na lichess.org';

  @override
  String activitySupportedNbMonths(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Podporuje lichess.org $count mesiacov ako $param2',
      many: 'Podporuje lichess.org $count mesiacov ako $param2',
      few: 'Podporuje lichess.org $count mesiace ako $param2',
      one: 'Podporuje lichess.org $count mesiac ako $param2',
    );
    return '$_temp0';
  }

  @override
  String activityPracticedNbPositions(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Precvičených $count pozícii v $param2',
      many: 'Precvičených $count pozícii v $param2',
      few: 'Precvičené $count pozície v $param2',
      one: 'Precvičená $count pozícia v $param2',
    );
    return '$_temp0';
  }

  @override
  String activitySolvedNbPuzzles(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Riešených $count taktických úloh',
      many: 'Riešených $count taktických úloh',
      few: 'Riešené $count taktické úlohy',
      one: 'Riešená $count taktická úloha',
    );
    return '$_temp0';
  }

  @override
  String activityPlayedNbGames(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Odohraných $count $param2 partií',
      many: 'Odohraných $count $param2 partií',
      few: 'Odohrané $count $param2 partie',
      one: 'Odohraná $count $param2 partia',
    );
    return '$_temp0';
  }

  @override
  String activityPostedNbMessages(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Uverejnených $count príspevkov v $param2',
      many: 'Uverejnených $count príspevkov v $param2',
      few: 'Uverejnené $count príspevky v $param2',
      one: 'Uverejnený $count príspevok v $param2',
    );
    return '$_temp0';
  }

  @override
  String activityPlayedNbMoves(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Zahral $count ťahov',
      many: 'Zharal $count ťahov',
      few: 'Zahral $count ťahy',
      one: 'Urobil $count ťah',
    );
    return '$_temp0';
  }

  @override
  String activityInNbCorrespondenceGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'v $count korešpondenčných hrách',
      many: 'v $count korešpondenčných hrách',
      few: 'v $count korešpondenčných hrách',
      one: 'v $count korešpondenčnej hre',
    );
    return '$_temp0';
  }

  @override
  String activityCompletedNbGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Dohraných $count korešpondenčných partií',
      many: 'Dohraných $count korešpondenčných partií',
      few: 'Dohrané $count korešpondenčné partie',
      one: 'Dohraná $count korešpondenčná partia',
    );
    return '$_temp0';
  }

  @override
  String activityFollowedNbPlayers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Začal sledovať $count hráčov',
      many: 'Začal sledovať $count hráčov',
      few: 'Začal sledovať $count hráčov',
      one: 'Začiatok sledovania $count hráča',
    );
    return '$_temp0';
  }

  @override
  String activityGainedNbFollowers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Získal $count nových sledovateľov',
      many: 'Získal $count nových sledovateľov',
      few: 'Získal $count nových sledovateľov',
      one: 'Získal $count nového sledovateľa',
    );
    return '$_temp0';
  }

  @override
  String activityHostedNbSimuls(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Usporiadanie a odohranie $count simultánok',
      many: 'Usporiadanie a odohranie $count simultánok',
      few: 'Usporiadanie a odohranie $count simultánok',
      one: 'Usporiadanie a odohranie $count simultánky',
    );
    return '$_temp0';
  }

  @override
  String activityJoinedNbSimuls(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Zúčastnil sa v $count simultánkach',
      many: 'Zúčastnil sa v $count simultánkach',
      few: 'Zúčastnil sa v $count simultánkach',
      one: 'Zúčastnenie sa v $count simultánke',
    );
    return '$_temp0';
  }

  @override
  String activityCreatedNbStudies(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Vytvorenie $count nových štúdií',
      many: 'Vytvorenie $count nových štúdií',
      few: 'Vytvorenie $count nových štúdií',
      one: 'Vytvorenie $count novej štúdie',
    );
    return '$_temp0';
  }

  @override
  String activityCompetedInNbTournaments(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Zúčastnil sa v $count turnajoch',
      many: 'Zúčastnil sa v $count turnajoch',
      few: 'Zúčastnil sa v $count turnajoch',
      one: 'Zúčastnil sa v $count turnaji',
    );
    return '$_temp0';
  }

  @override
  String activityRankedInTournament(int count, String param2, String param3, String param4) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Umiestnil sa na $count mieste (top $param2%) s $param3 partiami v $param4',
      many: 'Umiestnil sa na $count mieste (top $param2%) s $param3 partiami v $param4',
      few: 'Umiestnil sa na $count mieste (top $param2%) s $param3 partiami v $param4',
      one: 'Umiestnil sa na $count mieste (top $param2%) s $param3 partiou v $param4',
    );
    return '$_temp0';
  }

  @override
  String activityCompetedInNbSwissTournaments(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Odohraných $count turnajov švajčiarskym systémom',
      many: 'Odohraných $count turnajov švajčiarskym systémom',
      few: 'Odohrané $count turnaje švajčiarskym systémom',
      one: 'Odohraný $count turnaj švajčiarskym systémom',
    );
    return '$_temp0';
  }

  @override
  String activityJoinedNbTeams(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Vstup do $count družstiev',
      many: 'Vstup do $count družstiev',
      few: 'Vstup do $count družstiev',
      one: 'Vstup do $count družstva',
    );
    return '$_temp0';
  }

  @override
  String get broadcastBroadcasts => 'Vysielanie';

  @override
  String get broadcastLiveBroadcasts => 'Živé vysielanie turnaja';

  @override
  String challengeChallengesX(String param1) {
    return 'Výzvy: $param1';
  }

  @override
  String get challengeChallengeToPlay => 'Vyzvať na partiu';

  @override
  String get challengeChallengeDeclined => 'Výzva odmietnutá';

  @override
  String get challengeChallengeAccepted => 'Výzva prijatá!';

  @override
  String get challengeChallengeCanceled => 'Výzva zrušená.';

  @override
  String get challengeRegisterToSendChallenges => 'Pre odoslanie výzvy sa zaregistrujte.';

  @override
  String challengeYouCannotChallengeX(String param) {
    return 'Nemôžete vyzvať $param.';
  }

  @override
  String challengeXDoesNotAcceptChallenges(String param) {
    return '$param neprijíma výzvy.';
  }

  @override
  String challengeYourXRatingIsTooFarFromY(String param1, String param2) {
    return 'Medzi Vaším $param1 hodnotením a hodnotením hráča $param2 je príliš veľký rozdiel.';
  }

  @override
  String challengeCannotChallengeDueToProvisionalXRating(String param) {
    return 'Nemôžete odoslať výzvu kvôli provizórnemu $param hodnoteniu.';
  }

  @override
  String challengeXOnlyAcceptsChallengesFromFriends(String param) {
    return '$param prijíma výzvy iba od priateľov.';
  }

  @override
  String get challengeDeclineGeneric => 'Momentálne neprijímam výzvy.';

  @override
  String get challengeDeclineLater => 'Teraz pre mňa nie je vhodný čas, prosím spýtajte sa neskôr.';

  @override
  String get challengeDeclineTooFast => 'Táto časová kontrola je pre mňa prirýchla, prosím vyzvite ma opäť s dlhšou.';

  @override
  String get challengeDeclineTooSlow => 'Táto časová kontrola je pre mňa príliš pomalá, prosím vyzvite ma opäť s rýchlejšou.';

  @override
  String get challengeDeclineTimeControl => 'Neprijímam výzvy s touto časovou kontrolou.';

  @override
  String get challengeDeclineRated => 'Pošlite mi hodnotenú výzvu, prosím.';

  @override
  String get challengeDeclineCasual => 'Pošlite mi nehodnotenú výzvu, prosím.';

  @override
  String get challengeDeclineStandard => 'Momentálne neprijímam výzvy vo variantoch.';

  @override
  String get challengeDeclineVariant => 'Momentálne nie som ochotný hrať tento variant.';

  @override
  String get challengeDeclineNoBot => 'Neprijímam výzvy od botov.';

  @override
  String get challengeDeclineOnlyBot => 'Prijímam výzvy výlučne od botov.';

  @override
  String get challengeInviteLichessUser => 'Alebo pozvite používateľa Lichess:';

  @override
  String get contactContact => 'Kontakt';

  @override
  String get contactContactLichess => 'Kontaktuj Lichess';

  @override
  String get patronDonate => 'Prispieť';

  @override
  String get patronLichessPatron => 'Lichess Patrón';

  @override
  String perfStatPerfStats(String param) {
    return '$param štatistiky';
  }

  @override
  String get perfStatViewTheGames => 'Zobraziť partie';

  @override
  String get perfStatProvisional => 'provizórny';

  @override
  String get perfStatNotEnoughRatedGames => 'Na zaistenie spoľahlivého ratingu sa neodohralo dosť hodnotených hier.';

  @override
  String perfStatProgressOverLastXGames(String param) {
    return 'Postup počas posledných $param hier:';
  }

  @override
  String perfStatRatingDeviation(String param) {
    return 'Odchýlka ratingu: $param.';
  }

  @override
  String perfStatRatingDeviationTooltip(String param1, String param2, String param3) {
    return 'Nižšia hodnota znamená, že rating je stabilnejší. Hodnota vyššia ako $param1 znamená, že rating sa považuje za provizórny. Ak chcete byť zaradení do rebríčka, táto hodnota by mala byť nižšia ako $param2 (štandardný šach) alebo $param3 (varianty).';
  }

  @override
  String get perfStatTotalGames => 'Celkový počet hier';

  @override
  String get perfStatRatedGames => 'Hodnotené partie';

  @override
  String get perfStatTournamentGames => 'Turnajové hry';

  @override
  String get perfStatBerserkedGames => 'Zúrivé hry';

  @override
  String get perfStatTimeSpentPlaying => 'Čas strávený hraním';

  @override
  String get perfStatAverageOpponent => 'Priemerný súper';

  @override
  String get perfStatVictories => 'Víťazstvá';

  @override
  String get perfStatDefeats => 'Porážky';

  @override
  String get perfStatDisconnections => 'Odpojenia';

  @override
  String get perfStatNotEnoughGames => 'Nedostatok odohraných hier';

  @override
  String perfStatHighestRating(String param) {
    return 'Najvyšší rating: $param';
  }

  @override
  String perfStatLowestRating(String param) {
    return 'Najnižší rating: $param';
  }

  @override
  String perfStatFromXToY(String param1, String param2) {
    return 'od $param1 do $param2';
  }

  @override
  String get perfStatWinningStreak => 'Séria výhier';

  @override
  String get perfStatLosingStreak => 'Séria prehier';

  @override
  String perfStatLongestStreak(String param) {
    return 'Najdlhšia séria: $param';
  }

  @override
  String perfStatCurrentStreak(String param) {
    return 'Súčasná séria: $param';
  }

  @override
  String get perfStatBestRated => 'Najlepšie hodnotené víťazstvá';

  @override
  String get perfStatGamesInARow => 'Séria partií po sebe';

  @override
  String get perfStatLessThanOneHour => 'Menej ako hodina medzi hrami';

  @override
  String get perfStatMaxTimePlaying => 'Max čas strávený hraním';

  @override
  String get perfStatNow => 'teraz';

  @override
  String get preferencesPreferences => 'Nastavenia';

  @override
  String get preferencesDisplay => 'Zobrazenie';

  @override
  String get preferencesPrivacy => 'Súkromie';

  @override
  String get preferencesNotifications => 'Upozornenia';

  @override
  String get preferencesPieceAnimation => 'Animácia figúrok';

  @override
  String get preferencesMaterialDifference => 'Materiálny rozdiel';

  @override
  String get preferencesBoardHighlights => 'Zvýraznenie šachovnice (posledný ťah a šach)';

  @override
  String get preferencesPieceDestinations => 'Zobrazovať dostupné polia (možné ťahy a predťahy)';

  @override
  String get preferencesBoardCoordinates => 'Šachovnicové súradnice (A-H, 1-8)';

  @override
  String get preferencesMoveListWhilePlaying => 'Zobraziť šachovú notáciu počas partie';

  @override
  String get preferencesPgnPieceNotation => 'Označenie figúr v notácii';

  @override
  String get preferencesChessPieceSymbol => 'Symboly šachových figúr';

  @override
  String get preferencesPgnLetter => 'Písmenová notácia (K, D, V, S, J)';

  @override
  String get preferencesZenMode => 'Zen mód';

  @override
  String get preferencesShowPlayerRatings => 'Ukázať hráčove ratingy';

  @override
  String get preferencesShowFlairs => 'Zobraziť u hráčov ikonky štýlu';

  @override
  String get preferencesExplainShowPlayerRatings => 'Týmto môžete na webovej stránke skryť všetky hodnotenia, aby ste sa mohli sústrediť na šach. Partie môžu byť stále hodnotené, ide len o to, čo sa Vám zobrazí.';

  @override
  String get preferencesDisplayBoardResizeHandle => 'Zobraziť tlačidlo na zmenu veľkosti šachovnice';

  @override
  String get preferencesOnlyOnInitialPosition => 'Iba v základnom postavení';

  @override
  String get preferencesInGameOnly => 'Iba pri partii';

  @override
  String get preferencesChessClock => 'Šachové hodiny';

  @override
  String get preferencesTenthsOfSeconds => 'Desatiny sekundy';

  @override
  String get preferencesWhenTimeRemainingLessThanTenSeconds => 'Keď ostáva < 10 sekúnd';

  @override
  String get preferencesHorizontalGreenProgressBars => 'Vodorovné zelené ukazovatele priebehu';

  @override
  String get preferencesSoundWhenTimeGetsCritical => 'Zapnúť zvukové varovanie v prípade kritického množstva času';

  @override
  String get preferencesGiveMoreTime => 'Pridať čas';

  @override
  String get preferencesGameBehavior => 'Nastavenia partie';

  @override
  String get preferencesHowDoYouMovePieces => 'Akým spôsobom ťaháte figúrkami?';

  @override
  String get preferencesClickTwoSquares => 'Kliknutím na dve polia';

  @override
  String get preferencesDragPiece => 'Presun figúrky';

  @override
  String get preferencesBothClicksAndDrag => 'Oboje';

  @override
  String get preferencesPremovesPlayingDuringOpponentTurn => 'Predťahy (hranie počas súperovho ťahu)';

  @override
  String get preferencesTakebacksWithOpponentApproval => 'Vrátenie ťahu (so súhlasom súpera)';

  @override
  String get preferencesInCasualGamesOnly => 'Iba pri priateľských partiách';

  @override
  String get preferencesPromoteToQueenAutomatically => 'Automaticky premeniť pešiaka na dámu';

  @override
  String get preferencesExplainPromoteToQueenAutomatically => 'Pre dočasné vypnutie automatickej premeny podržte klávesu <ctrl> počas ťahu premeny';

  @override
  String get preferencesWhenPremoving => 'Pri predťahu';

  @override
  String get preferencesClaimDrawOnThreefoldRepetitionAutomatically => 'Automaticky vyžiadať remízu pri treťom opakovaní pozície';

  @override
  String get preferencesWhenTimeRemainingLessThanThirtySeconds => 'Keď ostáva < 30 sekúnd a menej';

  @override
  String get preferencesMoveConfirmation => 'Potvrdenie ťahu';

  @override
  String get preferencesExplainCanThenBeTemporarilyDisabled => 'Dá sa zrušiť počas partie cez \"hamburgerové menu\" pri šachovnici';

  @override
  String get preferencesInCorrespondenceGames => 'Korešpondenčné partie';

  @override
  String get preferencesCorrespondenceAndUnlimited => 'Korešpondenčný a nekonečný';

  @override
  String get preferencesConfirmResignationAndDrawOffers => 'Potvrdiť vzdanie partie a ponuku remízy';

  @override
  String get preferencesCastleByMovingTheKingTwoSquaresOrOntoTheRook => 'Spôsob vykonania rošády';

  @override
  String get preferencesCastleByMovingTwoSquares => 'Presunúť kráľa o dve polia';

  @override
  String get preferencesCastleByMovingOntoTheRook => 'Presunúť kráľa na pole s vežou';

  @override
  String get preferencesInputMovesWithTheKeyboard => 'Zadávanie ťahov pomocou klávesnice';

  @override
  String get preferencesInputMovesWithVoice => 'Zadávanie ťahov pomocou hlasu';

  @override
  String get preferencesSnapArrowsToValidMoves => 'Zobraziť šípky pri možných ťahoch';

  @override
  String get preferencesSayGgWpAfterLosingOrDrawing => 'Napíš \"Good game, well played\" (v preklade: Dobrá partia, pekne zahrané) po prehre alebo remíze';

  @override
  String get preferencesYourPreferencesHaveBeenSaved => 'Vaše nastavenia boli uložené.';

  @override
  String get preferencesScrollOnTheBoardToReplayMoves => 'Rolovaním po šachovnici prehrávať ťahy';

  @override
  String get preferencesCorrespondenceEmailNotification => 'Denný mailový výpis Vašich korešpondenčných partií';

  @override
  String get preferencesNotifyStreamStart => 'Streamer začal vysielať';

  @override
  String get preferencesNotifyInboxMsg => 'Nová správa';

  @override
  String get preferencesNotifyForumMention => 'V komentári na fóre sa o Vás píše';

  @override
  String get preferencesNotifyInvitedStudy => 'Pozvánka do štúdie';

  @override
  String get preferencesNotifyGameEvent => 'Aktualizácie korešpondenčných partií';

  @override
  String get preferencesNotifyChallenge => 'Výzvy';

  @override
  String get preferencesNotifyTournamentSoon => 'Onedlho začínajúci turnaj';

  @override
  String get preferencesNotifyTimeAlarm => 'Dochádza čas v korešpondenčnej partii';

  @override
  String get preferencesNotifyBell => 'Upozornenie zvončekom v rámci Lichess-u';

  @override
  String get preferencesNotifyPush => 'Upozornenie zariadenia v čase keď nie ste na Lichess-e';

  @override
  String get preferencesNotifyWeb => 'Prehliadač';

  @override
  String get preferencesNotifyDevice => 'Zariadenie';

  @override
  String get preferencesBellNotificationSound => 'Zvuk upozornenia';

  @override
  String get puzzlePuzzles => 'Šachové úlohy';

  @override
  String get puzzlePuzzleThemes => 'Kategórie úloh';

  @override
  String get puzzleRecommended => 'Odporúčané';

  @override
  String get puzzlePhases => 'Fázy';

  @override
  String get puzzleMotifs => 'Motívy';

  @override
  String get puzzleAdvanced => 'Pokročilé';

  @override
  String get puzzleLengths => 'Dĺžka';

  @override
  String get puzzleMates => 'Mat';

  @override
  String get puzzleGoals => 'Cieľ';

  @override
  String get puzzleOrigin => 'Pôvod';

  @override
  String get puzzleSpecialMoves => 'Špeciálne ťahy';

  @override
  String get puzzleDidYouLikeThisPuzzle => 'Páčila sa vám táto úloha?';

  @override
  String get puzzleVoteToLoadNextOne => 'Hlasujte a prejdite k ďalšej úlohe!';

  @override
  String get puzzleUpVote => 'Posunúť úlohu vyššie';

  @override
  String get puzzleDownVote => 'Posunúť úlohu nižšie';

  @override
  String get puzzleYourPuzzleRatingWillNotChange => 'Váš rating úloh sa nezmení. Upozorňujeme, že úlohy nie sú súťaž. Rating pomáha pri výbere najlepších úloh s prihliadnutím na vaše aktuálne zručnosti.';

  @override
  String get puzzleFindTheBestMoveForWhite => 'Nájdite najlepší ťah za bieleho.';

  @override
  String get puzzleFindTheBestMoveForBlack => 'Nájdite najlepší ťah za čierneho.';

  @override
  String get puzzleToGetPersonalizedPuzzles => 'Získajte úlohy šité na mieru:';

  @override
  String puzzlePuzzleId(String param) {
    return 'Úloha $param';
  }

  @override
  String get puzzlePuzzleOfTheDay => 'Úloha dňa';

  @override
  String get puzzleDailyPuzzle => 'Úloha na tento deň';

  @override
  String get puzzleClickToSolve => 'Kliknutím vyriešiť';

  @override
  String get puzzleGoodMove => 'Dobrý ťah';

  @override
  String get puzzleBestMove => 'Najlepší ťah!';

  @override
  String get puzzleKeepGoing => 'Pokračujte…';

  @override
  String get puzzlePuzzleSuccess => 'Vyriešené!';

  @override
  String get puzzlePuzzleComplete => 'Úloha splnená!';

  @override
  String get puzzleByOpenings => 'Podľa otvorení';

  @override
  String get puzzlePuzzlesByOpenings => 'Šachové úlohy podľa otvorení';

  @override
  String get puzzleOpeningsYouPlayedTheMost => 'Otvorenia, ktoré ste najviac hrali v hodnotených partiách';

  @override
  String get puzzleUseFindInPage => 'K nájdeniu Vášho obľúbeného otvorenia použite \"Nájsť na stránke\" v menu prehliadača!';

  @override
  String get puzzleUseCtrlF => 'K nájdeniu Vášho obľúbeného otvorenia použite Ctrl+f!';

  @override
  String get puzzleNotTheMove => 'To nie je ten správny ťah!';

  @override
  String get puzzleTrySomethingElse => 'Skúste niečo iné.';

  @override
  String puzzleRatingX(String param) {
    return 'Rating: $param';
  }

  @override
  String get puzzleHidden => 'skryté';

  @override
  String puzzleFromGameLink(String param) {
    return 'Z hry $param';
  }

  @override
  String get puzzleContinueTraining => 'Trénujte ďalej';

  @override
  String get puzzleDifficultyLevel => 'Obtiažnosť';

  @override
  String get puzzleNormal => 'Normálna';

  @override
  String get puzzleEasier => 'Ľahšia';

  @override
  String get puzzleEasiest => 'Najľahšia';

  @override
  String get puzzleHarder => 'Ťažšia';

  @override
  String get puzzleHardest => 'Najťažšia';

  @override
  String get puzzleExample => 'Príklad';

  @override
  String get puzzleAddAnotherTheme => 'Pridať ďalšiu kategóriu';

  @override
  String get puzzleNextPuzzle => 'Ďalšia úloha';

  @override
  String get puzzleJumpToNextPuzzleImmediately => 'Automaticky prejsť na ďalšiu úlohu';

  @override
  String get puzzlePuzzleDashboard => 'Nástenka šachových úloh';

  @override
  String get puzzleImprovementAreas => 'Oblasti zlepšenia';

  @override
  String get puzzleStrengths => 'Silné stránky';

  @override
  String get puzzleHistory => 'História úloh';

  @override
  String get puzzleSolved => 'vyriešené';

  @override
  String get puzzleFailed => 'zlyhané';

  @override
  String get puzzleStreakDescription => 'Riešte postupne ťažšie úlohy a dosiahnite nepretržitú sériu správnych riešení. Nie sú tu žiadne hodiny, takže sa neponáhľajte. Stačí jeden nesprávny ťah a séria sa končí! V každej sérii je však môžete jeden ťah vynechať.';

  @override
  String puzzleYourStreakX(String param) {
    return 'Vaša séria výhier: $param';
  }

  @override
  String get puzzleStreakSkipExplanation => 'Preskočte tento ťah, aby ste neprerušili sériu! Funguje len raz za sériu.';

  @override
  String get puzzleContinueTheStreak => 'Pokračovať v sérii výhier';

  @override
  String get puzzleNewStreak => 'Nová séria výhier';

  @override
  String get puzzleFromMyGames => 'Z mojich partií';

  @override
  String get puzzleLookupOfPlayer => 'Vyhľadávanie úloh z partií hráča';

  @override
  String puzzleFromXGames(String param) {
    return 'Úlohy z partí hráča $param';
  }

  @override
  String get puzzleSearchPuzzles => 'Hľadať úlohy';

  @override
  String get puzzleFromMyGamesNone => 'Nemáte v databáze žiadne úlohy z vlastných partií, ale Lichess Vás má aj tak veľmi rád.\n\nHrajte rapid a klasické partie, aby ste zvýšili svoje šance na pridanie úlohy z Vašej vlastnej partie!';

  @override
  String puzzleFromXGamesFound(String param1, String param2) {
    return '$param1 úloh nájdených v $param2 partiách';
  }

  @override
  String get puzzlePuzzleDashboardDescription => 'Trénujte, analyzujte, zlepšujte sa';

  @override
  String puzzlePercentSolved(String param) {
    return '$param vyriešených';
  }

  @override
  String get puzzleNoPuzzlesToShow => 'Niet tu čo ukázať, choďte najprv riešiť pár úloh!';

  @override
  String get puzzleImprovementAreasDescription => 'Precvičujte tieto úlohy aby ste napredovali čo najrýchlejšie!';

  @override
  String get puzzleStrengthDescription => 'Tieto témy Vám idú najlepšie';

  @override
  String puzzlePlayedXTimes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Hrané $count-krát',
      many: 'Hrané $count-krát',
      few: 'Hrané $count-krát',
      one: 'Hrané $count-krát',
    );
    return '$_temp0';
  }

  @override
  String puzzleNbPointsBelowYourPuzzleRating(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'O $count bodov nižšia ako Váš rating úloh',
      many: 'O $count bodov nižšia ako Váš rating úloh',
      few: 'O $count body nižšia ako Váš rating úloh',
      one: 'O jeden bod nižšia ako Váš rating úloh',
    );
    return '$_temp0';
  }

  @override
  String puzzleNbPointsAboveYourPuzzleRating(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'O $count bodov vyššia ako Váš rating úloh',
      many: 'O $count bodov vyššia ako Váš rating úloh',
      few: 'O $count body vyššia ako Váš rating úloh',
      one: 'O jeden bodov vyššia ako Váš rating úloh',
    );
    return '$_temp0';
  }

  @override
  String puzzleNbPlayed(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count hraných',
      many: '$count hraných',
      few: '$count hrané',
      one: '$count hraná',
    );
    return '$_temp0';
  }

  @override
  String puzzleNbToReplay(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count na zopakovanie',
      many: '$count na zopakovanie',
      few: '$count na zopakovanie',
      one: '$count na zopakovanie',
    );
    return '$_temp0';
  }

  @override
  String get puzzleThemeAdvancedPawn => 'Voľný pešiak';

  @override
  String get puzzleThemeAdvancedPawnDescription => 'Premena pešiaka alebo hrozba premeny je kľúčom k taktike.';

  @override
  String get puzzleThemeAdvantage => 'Výhoda';

  @override
  String get puzzleThemeAdvantageDescription => 'Využite svoju šancu získať rozhodujúcu prevahu (200cp ≤ eval ≤ 600cp)';

  @override
  String get puzzleThemeAnastasiaMate => 'Anastáziin mat';

  @override
  String get puzzleThemeAnastasiaMateDescription => 'Jazdec a veža alebo dáma sa spoja aby súperovho kráľa chytili do pasce medzi okrajom šachovnice a vlastnou figúrkou.';

  @override
  String get puzzleThemeArabianMate => 'Arabský mat';

  @override
  String get puzzleThemeArabianMateDescription => 'Jazdec a veža sa spoja aby súperovho kráľa chytili do pasce v rohu šachovnice.';

  @override
  String get puzzleThemeAttackingF2F7 => 'Útok na f2 alebo f7';

  @override
  String get puzzleThemeAttackingF2F7Description => 'Útok zameraný na f2 alebo f7 pešiaka, ako napríklad vo fried liver útoku.';

  @override
  String get puzzleThemeAttraction => 'Preťaženie';

  @override
  String get puzzleThemeAttractionDescription => 'Výmena alebo obeť podnecujúca alebo nútiaca pohyb súperovej figúry na pole, ktoré povoľuje nasledovnú taktiku.';

  @override
  String get puzzleThemeBackRankMate => 'Mat na poslednom rade';

  @override
  String get puzzleThemeBackRankMateDescription => 'Zmatujte kráľa na poslednej rade, keď je tam uväznený svojimi vlastnými figúrami.';

  @override
  String get puzzleThemeBishopEndgame => 'Strelcová koncovka';

  @override
  String get puzzleThemeBishopEndgameDescription => 'Koncovka iba so strelcami a pešiakmi.';

  @override
  String get puzzleThemeBodenMate => 'Bodenov mat';

  @override
  String get puzzleThemeBodenMateDescription => 'Dvaja útočiaci strelci na križujúcich sa diagonálach zmatujú kráľa zablokovaného vlastnými figúrkami.';

  @override
  String get puzzleThemeCastling => 'Rošáda';

  @override
  String get puzzleThemeCastlingDescription => 'Schovajte svojho kráľa do bezpečia a nasaďte vežu do útoku.';

  @override
  String get puzzleThemeCapturingDefender => 'Odstránenie obrany';

  @override
  String get puzzleThemeCapturingDefenderDescription => 'Odstránenie figúry, ktorá je dôležitá pri obrane inej figúry, dovoľujúc branie novo nebránenej figúry v následujúcom ťahu.';

  @override
  String get puzzleThemeCrushing => 'Rozdrvenie';

  @override
  String get puzzleThemeCrushingDescription => 'Odhaľte súperovu hrubú chybu a získajte drvivú výhodu. (eval ≥ 600cp)';

  @override
  String get puzzleThemeDoubleBishopMate => 'Mat dvojicou strelcov';

  @override
  String get puzzleThemeDoubleBishopMateDescription => 'Dvaja útočiaci strelci na susediacich diagonálach zmatujú kráľa zablokovaného vlastnými figúrkami.';

  @override
  String get puzzleThemeDovetailMate => 'Devetailov mat';

  @override
  String get puzzleThemeDovetailMateDescription => 'Dáma zmatuje kráľa v tesnej blízkosti, pričom jediné dve únikové políčka kráľovi blokujú vlastné figúrky.';

  @override
  String get puzzleThemeEquality => 'Rovnováha';

  @override
  String get puzzleThemeEqualityDescription => 'Dostaňte sa z prehratej pozície, a zaistite remízu alebo vyrovnanú pozíciu. (eval ≤ 200cp)';

  @override
  String get puzzleThemeKingsideAttack => 'Útok na kráľovskom krídle';

  @override
  String get puzzleThemeKingsideAttackDescription => 'Útok na súperovho kráľa po tom ako súper zahral malú rošádu.';

  @override
  String get puzzleThemeClearance => 'Uvoľnenie';

  @override
  String get puzzleThemeClearanceDescription => 'Ťah, častokrát s tempom, ktorý uvoľňuje pole, stĺpec alebo diagonálu na nasledujúcu taktickú ideu.';

  @override
  String get puzzleThemeDefensiveMove => 'Obranný ťah';

  @override
  String get puzzleThemeDefensiveMoveDescription => 'Presný ťah alebo sekvencia ťahov, ktorá je potrebná na odvrátenie straty materiálu alebo inej výhody.';

  @override
  String get puzzleThemeDeflection => 'Odlákanie';

  @override
  String get puzzleThemeDeflectionDescription => 'Ťah, ktorý odvádza súperovu figúry od jej iných povinností, ako napríklad bránenie kľúčového poľa. Občas nazývané aj \"preťaženie\".';

  @override
  String get puzzleThemeDiscoveredAttack => 'Odťažené napadnutie';

  @override
  String get puzzleThemeDiscoveredAttackDescription => 'Ťah figúrou, ktorá blokovala napadnutie inou figúrou, ako napr. ťah jazdcom, ktorý odkryje napadnutie vežou.';

  @override
  String get puzzleThemeDoubleCheck => 'Dvojitý šach';

  @override
  String get puzzleThemeDoubleCheckDescription => 'Šachovanie dvoma figúrami naraz, ako výsledok odkryvného šachu, kedy aj figúra ktorou sa potiahlo aj odkrytá figúra napádajú súperovho kráľa.';

  @override
  String get puzzleThemeEndgame => 'Koncovka';

  @override
  String get puzzleThemeEndgameDescription => 'Taktika počas posledného úseku hry.';

  @override
  String get puzzleThemeEnPassantDescription => 'Taktika spojená s pravidlom brania mimochodom, kedy pešiak môže vziať súperovho pešiaka, ktorý sa pohol zo základného postavenia o dve polia a tým sa dostal na jeho úroveň.';

  @override
  String get puzzleThemeExposedKing => 'Oslabený kráľ';

  @override
  String get puzzleThemeExposedKingDescription => 'Taktika spojená s kráľom, ktorý má okolo seba málo brániacich figúr, často vedúca k matu.';

  @override
  String get puzzleThemeFork => 'Vidlička';

  @override
  String get puzzleThemeForkDescription => 'Ťah, pri ktorom figúra útočí na dve nepriateľské figúry naraz.';

  @override
  String get puzzleThemeHangingPiece => 'Visiaca figúra';

  @override
  String get puzzleThemeHangingPieceDescription => 'Taktika spojená so súperovou figúrou, ktorá je nekrytá alebo nedostatočne krytá a je možné ju vziať zadarmo.';

  @override
  String get puzzleThemeHookMate => 'Hákový mat';

  @override
  String get puzzleThemeHookMateDescription => 'Mat vežou, jazdcom alebo pešiakom spolu s jedným súperovým pešiakom, ktorý obmedzuje pohyb kráľa.';

  @override
  String get puzzleThemeInterference => 'Prekrytie';

  @override
  String get puzzleThemeInterferenceDescription => 'Umiestnenie figúry medzi dve súperove figúry čím sa tieto dve stávajú nekrytými, napr. umiestnenie jazdca na kryté pole medzi dve veže.';

  @override
  String get puzzleThemeIntermezzo => 'Medziťah';

  @override
  String get puzzleThemeIntermezzoDescription => 'Namiesto očakávaného ťahu, zahranie ťahu znamenajúceho okamžitú hrozbu, na ktorú musí protihráč reagovať. Nazývaný tiež \"Zwischenzug\".';

  @override
  String get puzzleThemeKnightEndgame => 'Jazdcová koncovka';

  @override
  String get puzzleThemeKnightEndgameDescription => 'Koncovka iba s jazdcami a pešiakmi.';

  @override
  String get puzzleThemeLong => 'Troj-ťahové úlohy';

  @override
  String get puzzleThemeLongDescription => 'Tri ťahy do výhry.';

  @override
  String get puzzleThemeMaster => 'Partie majstrov';

  @override
  String get puzzleThemeMasterDescription => 'Úlohy z partií šachistov s titulom.';

  @override
  String get puzzleThemeMasterVsMaster => 'Partie majstrov proti majstrom';

  @override
  String get puzzleThemeMasterVsMasterDescription => 'Úlohy z partií medzi šachistami s titulom.';

  @override
  String get puzzleThemeMate => 'Mat';

  @override
  String get puzzleThemeMateDescription => 'Vyhrajte hru so štýlom.';

  @override
  String get puzzleThemeMateIn1 => 'Mat 1. ťahom';

  @override
  String get puzzleThemeMateIn1Description => 'Dajte mat jedným ťahom.';

  @override
  String get puzzleThemeMateIn2 => 'Mat 2. ťahom';

  @override
  String get puzzleThemeMateIn2Description => 'Dajte mat dvoma ťahmi.';

  @override
  String get puzzleThemeMateIn3 => 'Mat 3. ťahom';

  @override
  String get puzzleThemeMateIn3Description => 'Dajte mat tromi ťahmi.';

  @override
  String get puzzleThemeMateIn4 => 'Mat na 4 ťahy';

  @override
  String get puzzleThemeMateIn4Description => 'Dajte mat štyrmi ťahmi.';

  @override
  String get puzzleThemeMateIn5 => 'Mat 5. alebo väčším počtom ťahov';

  @override
  String get puzzleThemeMateIn5Description => 'Nájdite dlhú matovú kombináciu.';

  @override
  String get puzzleThemeMiddlegame => 'Stredná hra';

  @override
  String get puzzleThemeMiddlegameDescription => 'Taktika počas druhého úseku hry.';

  @override
  String get puzzleThemeOneMove => 'Jedno-ťahové úlohy';

  @override
  String get puzzleThemeOneMoveDescription => 'Úloha, ktorá je iba jednoťahová.';

  @override
  String get puzzleThemeOpening => 'Otvorenie';

  @override
  String get puzzleThemeOpeningDescription => 'Taktika počas prvého úseku hry.';

  @override
  String get puzzleThemePawnEndgame => 'Pešiaková koncovka';

  @override
  String get puzzleThemePawnEndgameDescription => 'Koncovka iba s pešiakmi.';

  @override
  String get puzzleThemePin => 'Väzba';

  @override
  String get puzzleThemePinDescription => 'Taktika spojená s väzbou, kedy sa figúrka nemôže pohnúť bez toho aby neodkryla napadnutie figúry vyššej hodnoty.';

  @override
  String get puzzleThemePromotion => 'Premena';

  @override
  String get puzzleThemePromotionDescription => 'Premena pešiaka alebo hrozba premeny pešiaka je kľúčom k tejto taktike.';

  @override
  String get puzzleThemeQueenEndgame => 'Dámska koncovka';

  @override
  String get puzzleThemeQueenEndgameDescription => 'Koncovka iba s kráľovnami a pešiakmi.';

  @override
  String get puzzleThemeQueenRookEndgame => 'Dáma a Veža';

  @override
  String get puzzleThemeQueenRookEndgameDescription => 'Koncovka iba s dámami, vežami a pešiakmi.';

  @override
  String get puzzleThemeQueensideAttack => 'Útok na dámskom krídle';

  @override
  String get puzzleThemeQueensideAttackDescription => 'Útok na súperovho kráľa po tom ako súper zahral veľkú rošádu.';

  @override
  String get puzzleThemeQuietMove => 'Tichý ťah';

  @override
  String get puzzleThemeQuietMoveDescription => 'Ťah, ktorým ani nešachujeme ani neberieme súperove figúry, ale pripravujeme neodvratnú hrozbu v neskoršom ťahu.';

  @override
  String get puzzleThemeRookEndgame => 'Vežová koncovka';

  @override
  String get puzzleThemeRookEndgameDescription => 'Koncovka iba s vežami a pešiakmi.';

  @override
  String get puzzleThemeSacrifice => 'Obeť';

  @override
  String get puzzleThemeSacrificeDescription => 'Taktika spojená s krátkodobým odovzdaním materiálu za účelom neskoršieho zisku výhody po zahratí vynútenej série ťahov.';

  @override
  String get puzzleThemeShort => 'Dvoj-ťahové úlohy';

  @override
  String get puzzleThemeShortDescription => 'Dva ťahy do výhry.';

  @override
  String get puzzleThemeSkewer => 'Napichnutie';

  @override
  String get puzzleThemeSkewerDescription => 'Motív spojený s napadnutím figúry vysokej hodnoty, po ktorej ustúpení je umožnené zobratie alebo napadnutie figúry nižšej hodnoty, opak väzby.';

  @override
  String get puzzleThemeSmotheredMate => 'Dusený mat';

  @override
  String get puzzleThemeSmotheredMateDescription => 'Mat daný jazdcom, pri ktorom sa matovaný kráľ nemá kam pohnúť pretože je obkolesený (alebo zadusený) vlastnými figúrami.';

  @override
  String get puzzleThemeSuperGM => 'Partie superveľmajstrov';

  @override
  String get puzzleThemeSuperGMDescription => 'Úlohy z partií najlepších hráčov sveta.';

  @override
  String get puzzleThemeTrappedPiece => 'Chytená figúra';

  @override
  String get puzzleThemeTrappedPieceDescription => 'Figúra neschopná ujsť vyhodeniu, pretože má limitované možnosti.';

  @override
  String get puzzleThemeUnderPromotion => 'Pod-premena';

  @override
  String get puzzleThemeUnderPromotionDescription => 'Premena na jazdca, strelca, alebo vežu.';

  @override
  String get puzzleThemeVeryLong => 'Viac-ťahové úlohy';

  @override
  String get puzzleThemeVeryLongDescription => 'Štyri alebo viac ťahov do výhry.';

  @override
  String get puzzleThemeXRayAttack => 'Röntgenový útok';

  @override
  String get puzzleThemeXRayAttackDescription => 'Figúra bráni alebo útočí na pole cez súperovu figúru.';

  @override
  String get puzzleThemeZugzwang => 'Nevýhoda ťahu';

  @override
  String get puzzleThemeZugzwangDescription => 'Súper je limitovaný vo svojich ťahoch a každý ťah zhorší jeho pozíciu.';

  @override
  String get puzzleThemeHealthyMix => 'Zdravý mix';

  @override
  String get puzzleThemeHealthyMixDescription => 'Zmes úloh. Neviete čo očakávať, a tak ste neustále pripravení na všetko! Presne ako v skutočných partiách.';

  @override
  String get puzzleThemePlayerGames => 'Vaše partie';

  @override
  String get puzzleThemePlayerGamesDescription => 'Vyhľadajte si úlohy vygenerované z Vašich partií alebo z partií iných hráčov.';

  @override
  String puzzleThemePuzzleDownloadInformation(String param) {
    return 'Tieto úlohy sú voľne dostupné a môžete si ich stiahnuť z $param.';
  }

  @override
  String get searchSearch => 'Hľadať';

  @override
  String get settingsSettings => 'Nastavenia';

  @override
  String get settingsCloseAccount => 'Zrušiť účet';

  @override
  String get settingsManagedAccountCannotBeClosed => 'Váš účet je spravovaný niekým iným a nemožno ho zrušiť.';

  @override
  String get settingsClosingIsDefinitive => 'Zrušenie je definitívne. Nedá sa vrátiť naspäť. Ste si istí?';

  @override
  String get settingsCantOpenSimilarAccount => 'Nebudete si môcť založiť nový účet s rovnakým menom, ani keď sa bude líšiť veľkosť písmen.';

  @override
  String get settingsChangedMindDoNotCloseAccount => 'Rozmyslel som si to, nerušte môj účet';

  @override
  String get settingsCloseAccountExplanation => 'Ste si istí, že chcete zrušiť váš účet? Zrušenie vášho účtu je trvalé rozhodnutie. Už sa NIKDY ZNOVU nebudete môcť prihlásiť.';

  @override
  String get settingsThisAccountIsClosed => 'Účet zrušený.';

  @override
  String get playWithAFriend => 'Hrať s priateľom';

  @override
  String get playWithTheMachine => 'Hrať proti počítaču';

  @override
  String get toInviteSomeoneToPlayGiveThisUrl => 'Zdieľaním tejto adresy môžete niekoho pozvať k partii';

  @override
  String get gameOver => 'Koniec partie';

  @override
  String get waitingForOpponent => 'Čaká sa na súpera';

  @override
  String get orLetYourOpponentScanQrCode => 'Alebo nech Váš súper naskenuje tento QR kód';

  @override
  String get waiting => 'Čaká sa';

  @override
  String get yourTurn => 'Ste na ťahu';

  @override
  String aiNameLevelAiLevel(String param1, String param2) {
    return '$param1 úrovne $param2';
  }

  @override
  String get level => 'Úroveň';

  @override
  String get strength => 'Sila';

  @override
  String get toggleTheChat => 'Prepínač okna rozhovoru';

  @override
  String get chat => 'Rozhovor';

  @override
  String get resign => 'Vzdať sa';

  @override
  String get checkmate => 'Mat';

  @override
  String get stalemate => 'Pat';

  @override
  String get white => 'Biely';

  @override
  String get black => 'Čierny';

  @override
  String get asWhite => 'ako biely';

  @override
  String get asBlack => 'ako čierny';

  @override
  String get randomColor => 'Náhodná farba figúr';

  @override
  String get createAGame => 'Vytvoriť partiu';

  @override
  String get whiteIsVictorious => 'Biely zvíťazil';

  @override
  String get blackIsVictorious => 'Čierny zvíťazil';

  @override
  String get youPlayTheWhitePieces => 'Hráte za bieleho';

  @override
  String get youPlayTheBlackPieces => 'Hráte za čierneho';

  @override
  String get itsYourTurn => 'Ste na ťahu!';

  @override
  String get cheatDetected => 'Bolo zaznamenané podvádzanie';

  @override
  String get kingInTheCenter => 'Kráľ v strede';

  @override
  String get threeChecks => 'Tri šachy';

  @override
  String get raceFinished => 'Preteky ukončené';

  @override
  String get variantEnding => 'Koniec variantu';

  @override
  String get newOpponent => 'Nový súper';

  @override
  String get yourOpponentWantsToPlayANewGameWithYou => 'Váš súper by si s Vami rád zahral odvetnú partiu';

  @override
  String get joinTheGame => 'Pripojiť sa k partii';

  @override
  String get whitePlays => 'Biely na ťahu';

  @override
  String get blackPlays => 'Čierny na ťahu';

  @override
  String get opponentLeftChoices => 'Váš súper zrejme opustil túto partiu. Môžete požadovať výhru, vyhlásiť partiu za remízu alebo počkať.';

  @override
  String get forceResignation => 'Požadovať výhru';

  @override
  String get forceDraw => 'Vyhlásiť za remízu';

  @override
  String get talkInChat => 'Prosím, buďte v chate ohľaduplní!';

  @override
  String get theFirstPersonToComeOnThisUrlWillPlayWithYou => 'Prvý kto použije tento odkaz si s Vami zahrá.';

  @override
  String get whiteResigned => 'Biely sa vzdal';

  @override
  String get blackResigned => 'Čierny sa vzdal';

  @override
  String get whiteLeftTheGame => 'Biely opustil partiu';

  @override
  String get blackLeftTheGame => 'Čierny opustil partiu';

  @override
  String get whiteDidntMove => 'Biely nepotiahol';

  @override
  String get blackDidntMove => 'Čierny nepotiahol';

  @override
  String get requestAComputerAnalysis => 'Požiadať o počítačovú analýzu';

  @override
  String get computerAnalysis => 'Počítačová analýza';

  @override
  String get computerAnalysisAvailable => 'K dispozícii je aj počítačová analýza partie';

  @override
  String get computerAnalysisDisabled => 'Počítačová analýza vypnutá';

  @override
  String get analysis => 'Analýza partie';

  @override
  String depthX(String param) {
    return 'Hĺbka $param';
  }

  @override
  String get usingServerAnalysis => 'Používa sa analýza servera';

  @override
  String get loadingEngine => 'Zavádzanie motora ...';

  @override
  String get calculatingMoves => 'Prebieha výpočet...';

  @override
  String get engineFailed => 'Chyba pri načítavaní motora';

  @override
  String get cloudAnalysis => 'Vzdialená analýza';

  @override
  String get goDeeper => 'Hlbšia analýza';

  @override
  String get showThreat => 'Ukázať hrozbu';

  @override
  String get inLocalBrowser => 'vo Vašom prehliadači';

  @override
  String get toggleLocalEvaluation => 'Prepnúť na analýzu vo Vašom prehliadači';

  @override
  String get promoteVariation => 'Povýšiť variant';

  @override
  String get makeMainLine => 'Povýšiť na hlavnú variantu';

  @override
  String get deleteFromHere => 'Vymazať odtiaľto';

  @override
  String get collapseVariations => 'Skryť varianty';

  @override
  String get expandVariations => 'Ukázať varianty';

  @override
  String get forceVariation => 'Povýšiť variant';

  @override
  String get copyVariationPgn => 'Kopírovať PGN variantu';

  @override
  String get move => 'Ťah';

  @override
  String get variantLoss => 'Prehrávajúci variant';

  @override
  String get variantWin => 'Vyhrávajúci variant';

  @override
  String get insufficientMaterial => 'Nedostatočný materiál';

  @override
  String get pawnMove => 'Ťah pešiakom';

  @override
  String get capture => 'Branie';

  @override
  String get close => 'Zavrieť';

  @override
  String get winning => 'Vyhráva';

  @override
  String get losing => 'Prehráva';

  @override
  String get drawn => 'Remizuje';

  @override
  String get unknown => 'Neznáme';

  @override
  String get database => 'Databáza';

  @override
  String get whiteDrawBlack => 'Biely / Remíza / Čierny';

  @override
  String averageRatingX(String param) {
    return 'Priemerný rating: $param';
  }

  @override
  String get recentGames => 'Nedávne partie';

  @override
  String get topGames => 'Top partie';

  @override
  String masterDbExplanation(String param1, String param2, String param3) {
    return 'Dva milióny partií hráčov s FIDE ratingom $param1+ od roku $param2 po $param3';
  }

  @override
  String get dtzWithRounding => 'DTZ50\" so zaokrúhlením, vychádzajúci s počtu polťahov až do najbližšieho brania alebo ťahu pešiakom';

  @override
  String get noGameFound => 'Nenašla sa žiadna partia';

  @override
  String get maxDepthReached => 'Dosiahnutá maximálna hĺbka!';

  @override
  String get maybeIncludeMoreGamesFromThePreferencesMenu => 'Možno vyberte viac partií z menu preferencií?';

  @override
  String get openings => 'Otvorenia';

  @override
  String get openingExplorer => 'Prieskumník otvorení';

  @override
  String get openingEndgameExplorer => 'Prieskumník otvorení/koncoviek';

  @override
  String xOpeningExplorer(String param) {
    return '$param prieskumník otvorení';
  }

  @override
  String get playFirstOpeningEndgameExplorerMove => 'Hrať prvý ťah navrhnutý prieskumníkom otorení/koncoviek';

  @override
  String get winPreventedBy50MoveRule => 'Výhre zabránilo pravidlo 50-tich ťahov';

  @override
  String get lossSavedBy50MoveRule => 'Od prehry zachránilo pravidlo 50-tich ťahov';

  @override
  String get winOr50MovesByPriorMistake => 'Výhra alebo 50 ťahov na základe predchádzajúcej chyby';

  @override
  String get lossOr50MovesByPriorMistake => 'Prehra alebo 50 ťahov v dôsledku predchádzajúcej chyby';

  @override
  String get unknownDueToRounding => 'Výhra/prehra je garantovaná iba ak bol od posledného brania alebo ťahu pešiakom dodržaný odporúčaný variant databázy, kvôli možnému zaokrúhleniu hodnoty DTZ v Syzygy databáze.';

  @override
  String get allSet => 'Všetko nastavené!';

  @override
  String get importPgn => 'Importovať PGN';

  @override
  String get delete => 'Vymazať';

  @override
  String get deleteThisImportedGame => 'Vymazať túto importovanú partiu?';

  @override
  String get replayMode => 'Mód prehrávania';

  @override
  String get realtimeReplay => 'Ako pri hre';

  @override
  String get byCPL => 'CHYBY';

  @override
  String get openStudy => 'Otvoriť štúdie';

  @override
  String get enable => 'Povoliť analýzu';

  @override
  String get bestMoveArrow => 'Šípka pre najlepší ťah';

  @override
  String get showVariationArrows => 'Zobraziť šípky variantov';

  @override
  String get evaluationGauge => 'Ukazovateľ hodnotenia';

  @override
  String get multipleLines => 'Počet variantov';

  @override
  String get cpus => 'Procesory';

  @override
  String get memory => 'Pamäť';

  @override
  String get infiniteAnalysis => 'Nekonečná analýza';

  @override
  String get removesTheDepthLimit => 'Odstráni obmedzenie hĺbky analýzy a spôsobí zahrievanie Vášho počítača';

  @override
  String get engineManager => 'Správa motorov';

  @override
  String get blunder => 'Hrubá chyba';

  @override
  String get mistake => 'Chyba';

  @override
  String get inaccuracy => 'Nepresnosť';

  @override
  String get moveTimes => 'Trvanie ťahov';

  @override
  String get flipBoard => 'Otočiť šachovnicu';

  @override
  String get threefoldRepetition => 'Trojnásobné opakovanie';

  @override
  String get claimADraw => 'Požadovať remízu';

  @override
  String get offerDraw => 'Ponúknuť remízu';

  @override
  String get draw => 'Remíza';

  @override
  String get drawByMutualAgreement => 'Remíza po vzájomnej dohode';

  @override
  String get fiftyMovesWithoutProgress => 'Päťdesiat ťahov bez posunu vpred';

  @override
  String get currentGames => 'Práve prebiehajúce partie';

  @override
  String get viewInFullSize => 'Zobraziť v plnej veľkosti';

  @override
  String get logOut => 'Odhlásiť sa';

  @override
  String get signIn => 'Prihlásiť sa';

  @override
  String get rememberMe => 'Zapamätať si ma';

  @override
  String get youNeedAnAccountToDoThat => 'Pre túto požiadavku musíte byť prihlásený';

  @override
  String get signUp => 'Zaregistrovať sa';

  @override
  String get computersAreNotAllowedToPlay => 'Hráči využívajúci pomoc počítačov nie sú vítaní. Počas partie nepoužívajte šachové programy, databázy ani rady iných hráčov. Vytváranie viacerých účtov sa silne neodporúča a nadmerné vytváranie účtov bude viesť k Vášmu zablokovaniu.';

  @override
  String get games => 'Partie';

  @override
  String get forum => 'Fórum';

  @override
  String xPostedInForumY(String param1, String param2) {
    return '$param1 príspevkov v téme $param2';
  }

  @override
  String get latestForumPosts => 'Najnovšie príspevky';

  @override
  String get players => 'Hráči';

  @override
  String get friends => 'Priatelia';

  @override
  String get discussions => 'Konverzácie';

  @override
  String get today => 'Dnes';

  @override
  String get yesterday => 'Včera';

  @override
  String get minutesPerSide => 'Minút na stranu';

  @override
  String get variant => 'Variant';

  @override
  String get variants => 'Varianty';

  @override
  String get timeControl => 'Čas';

  @override
  String get realTime => 'Nastaviť čas';

  @override
  String get correspondence => 'Korešpondenčný šach';

  @override
  String get daysPerTurn => 'Počet dní na ťah';

  @override
  String get oneDay => 'Jeden deň';

  @override
  String get time => 'Čas';

  @override
  String get rating => 'Rating';

  @override
  String get ratingStats => 'Štatistika ratingov';

  @override
  String get username => 'Užívateľské meno';

  @override
  String get usernameOrEmail => 'Meno používateľa alebo email';

  @override
  String get changeUsername => 'Zmeniť užívateľské meno';

  @override
  String get changeUsernameNotSame => 'Je možné zmeniť iba veľké a malé písmená. Napríklad \"miskomrkvicka\" na MiskoMrkvicka\".';

  @override
  String get changeUsernameDescription => 'Zmena užívateľského mena. Tento úkon je možné vykonať len raz a je povolené zmeniť iba veľké a malé písmená.';

  @override
  String get signupUsernameHint => 'Uistite sa, že si vyberáte rodinne prijateľné používateľské meno! Neskôr ho už nemôžete zmeniť a akýkoľvek účet s nevhodným užívateľským menom bude uzavretý.';

  @override
  String get signupEmailHint => 'Použijeme ho iba pri znovunastavení hesla.';

  @override
  String get password => 'Heslo';

  @override
  String get changePassword => 'Zmeniť heslo';

  @override
  String get changeEmail => 'Zmeniť email';

  @override
  String get email => 'Email';

  @override
  String get passwordReset => 'Obnova hesla';

  @override
  String get forgotPassword => 'Zabudli ste heslo?';

  @override
  String get error_weakPassword => 'Toto heslo je veľmi bežné, a ľahké na uhádnutie.';

  @override
  String get error_namePassword => 'Prosím, nepoužívajte Vaše prihlasovacie meno ako Vaše heslo!';

  @override
  String get blankedPassword => 'Na inej stránke ste použili rovnaké heslo a táto stránka bola napadnutá. Aby sme zaistili bezpečnosť Vášho účtu Lichess, je potrebné aby ste si nastavili nové heslo. Ďakujeme Vám za pochopenie.';

  @override
  String get youAreLeavingLichess => 'Odchádzate z Lichessu';

  @override
  String get neverTypeYourPassword => 'Nikdy nepoužívajte vaše Lichess heslo na inom webe!';

  @override
  String proceedToX(String param) {
    return 'Pokračovať na $param';
  }

  @override
  String get passwordSuggestion => 'Nepoužívajte heslo ktoré, vám dal niekto iný. Mohol by vám ukradnúť účet.';

  @override
  String get emailSuggestion => 'Nepoužívajte e-mail, ktorý, vám dal niekto iný. Mohol by vám ukradnúť účet.';

  @override
  String get emailConfirmHelp => 'Pomoc s overením e-mailu';

  @override
  String get emailConfirmNotReceived => 'Nedostali ste Váš overovací email po registrácii?';

  @override
  String get whatSignupUsername => 'Aké používateľské meno ste použili na registráciu?';

  @override
  String usernameNotFound(String param) {
    return 'Nepodarilo sa nám nájsť používateľa s týmto menom: $param.';
  }

  @override
  String get usernameCanBeUsedForNewAccount => 'Toto meno je možné na vytvorenie nového účtu použiť';

  @override
  String emailSent(String param) {
    return 'Na adresu $param sme poslali email.';
  }

  @override
  String get emailCanTakeSomeTime => 'Môže chvíľu trvať kým príde.';

  @override
  String get refreshInboxAfterFiveMinutes => 'Počkajte 5 minút a obnovte si emailovú schránku!';

  @override
  String get checkSpamFolder => 'Skontrolujte si aj priečinok s nevyžiadanou poštou, je možné, že sa dostal tam. Ak sa tak stalo, zrušte označenie emailu ako nevyžiadanej pošty.';

  @override
  String get emailForSignupHelp => 'Ak všetko ostatné zlyhá, pošlite nám tento email:';

  @override
  String copyTextToEmail(String param) {
    return 'Skopírujte a vložte uvedený text a pošlite ho na adresu $param';
  }

  @override
  String get waitForSignupHelp => 'Čoskoro sa Vám ozveme, aby sme Vám pomohli dokončiť registráciu.';

  @override
  String accountConfirmed(String param) {
    return 'Používateľ $param je úspešne potvrdený.';
  }

  @override
  String accountCanLogin(String param) {
    return 'Teraz sa môžete prihlásiť ako $param.';
  }

  @override
  String get accountConfirmationEmailNotNeeded => 'Potvrdzovací e-mail nepotrebujete.';

  @override
  String accountClosed(String param) {
    return 'Účet $param je zrušený.';
  }

  @override
  String accountRegisteredWithoutEmail(String param) {
    return 'Účet $param bol zaregistrovaný bez emailovej adresy.';
  }

  @override
  String get rank => 'Poradie';

  @override
  String rankX(String param) {
    return 'Poradie: $param';
  }

  @override
  String get gamesPlayed => 'Odohraných partií';

  @override
  String get cancel => 'Zrušiť';

  @override
  String get whiteTimeOut => 'Bielemu došiel čas';

  @override
  String get blackTimeOut => 'Čiernemu došiel čas';

  @override
  String get drawOfferSent => 'Ponuka remízy odoslaná';

  @override
  String get drawOfferAccepted => 'Ponuka remízy prijatá';

  @override
  String get drawOfferCanceled => 'Ponuka remízy zrušená';

  @override
  String get whiteOffersDraw => 'Biely ponúka remízu';

  @override
  String get blackOffersDraw => 'Čierny ponúka remízu';

  @override
  String get whiteDeclinesDraw => 'Biely odmietol remízu';

  @override
  String get blackDeclinesDraw => 'Čierny odmietol remízu';

  @override
  String get yourOpponentOffersADraw => 'Váš súper ponúka remízu';

  @override
  String get accept => 'Prijať';

  @override
  String get decline => 'Odmietnuť';

  @override
  String get playingRightNow => 'Práve hrajú';

  @override
  String get eventInProgress => 'Práve sa hrá';

  @override
  String get finished => 'Ukončené';

  @override
  String get abortGame => 'Zrušiť hru';

  @override
  String get gameAborted => 'Partia zrušená';

  @override
  String get standard => 'Štandard';

  @override
  String get customPosition => 'Custom position';

  @override
  String get unlimited => 'Bez času';

  @override
  String get mode => 'Režim partie';

  @override
  String get casual => 'Priateľská';

  @override
  String get rated => 'Hodnotená';

  @override
  String get casualTournament => 'Priateľská';

  @override
  String get ratedTournament => 'Hodnotený';

  @override
  String get thisGameIsRated => 'Táto hra je hodnotená';

  @override
  String get rematch => 'Odveta';

  @override
  String get rematchOfferSent => 'Zaslaná ponuka na odvetu';

  @override
  String get rematchOfferAccepted => 'Prijatá ponuka na odvetu';

  @override
  String get rematchOfferCanceled => 'Ponuka na odvetu zrušená';

  @override
  String get rematchOfferDeclined => 'Ponuka na odvetu odmietnutá';

  @override
  String get cancelRematchOffer => 'Odmietnuť odvetu';

  @override
  String get viewRematch => 'Zobraziť odvetu';

  @override
  String get confirmMove => 'Potvrdiť ťah';

  @override
  String get play => 'Hrať';

  @override
  String get inbox => 'Správy';

  @override
  String get chatRoom => 'Chatovacia miestnosť';

  @override
  String get loginToChat => 'Prihlásiť sa do četu';

  @override
  String get youHaveBeenTimedOut => 'Boli ste automaticky odhlásení.';

  @override
  String get spectatorRoom => 'Divácka miestnosť';

  @override
  String get composeMessage => 'Napísať správu';

  @override
  String get subject => 'Predmet';

  @override
  String get send => 'Poslať';

  @override
  String get incrementInSeconds => 'Prírastok v sekundách';

  @override
  String get freeOnlineChess => 'Online šach zdarma';

  @override
  String get exportGames => 'Exportovať partie';

  @override
  String get ratingRange => 'Rozsah hodnotení';

  @override
  String get thisAccountViolatedTos => 'Tento účet porušil Podmienky poskytovania služby Lichess';

  @override
  String get openingExplorerAndTablebase => 'Knižnica otvorení & koncoviek';

  @override
  String get takeback => 'Vrátiť ťah';

  @override
  String get proposeATakeback => 'Ponúknuť vrátenie ťahu';

  @override
  String get takebackPropositionSent => 'Ponuka na návrat zaslaná';

  @override
  String get takebackPropositionDeclined => 'Ponuka na návrat odmietnutá';

  @override
  String get takebackPropositionAccepted => 'Ponuka na návrat prijatá';

  @override
  String get takebackPropositionCanceled => 'Ponuka na návrat zrušená';

  @override
  String get yourOpponentProposesATakeback => 'Váš súper navrhuje vrátiť ťah';

  @override
  String get bookmarkThisGame => 'Označiť túto hru';

  @override
  String get tournament => 'Turnaj';

  @override
  String get tournaments => 'Turnaje';

  @override
  String get tournamentPoints => 'Turnajové body';

  @override
  String get viewTournament => 'Zobraziť turnaj';

  @override
  String get backToTournament => 'Návrat do turnaja';

  @override
  String get noDrawBeforeSwissLimit => 'V turnaji švajčiarskeho systému nie je možné remizovať pokiaľ sa neodohralo 30 ťahov.';

  @override
  String get thematic => 'Tematický';

  @override
  String yourPerfRatingIsProvisional(String param) {
    return 'Váš $param rating je provizórny';
  }

  @override
  String yourPerfRatingIsTooHigh(String param1, String param2) {
    return 'Váš $param1 rating ($param2) je príliš vysoký';
  }

  @override
  String yourTopWeeklyPerfRatingIsTooHigh(String param1, String param2) {
    return 'Váš najvyšší týždenný $param1 rating ($param2) je príliš vysoký';
  }

  @override
  String yourPerfRatingIsTooLow(String param1, String param2) {
    return 'Váš $param1 rating ($param2) je príliš nízky';
  }

  @override
  String ratedMoreThanInPerf(String param1, String param2) {
    return 'S ratingom ≥ $param1 v $param2';
  }

  @override
  String ratedLessThanInPerf(String param1, String param2) {
    return 'S ratingom ≤ $param1 v $param2';
  }

  @override
  String mustBeInTeam(String param) {
    return 'Musíte byť členom tímu $param';
  }

  @override
  String youAreNotInTeam(String param) {
    return 'Nie ste členom tímu $param';
  }

  @override
  String get backToGame => 'Návrat do hry';

  @override
  String get siteDescription => 'Šach online zadarmo. Hrajte šach teraz v novom rozhraní. Bez registrácie, reklám a zásuvných modulov. Hrajte šach s počítačom, priateľmi alebo náhodnými protivníkmi.';

  @override
  String xJoinedTeamY(String param1, String param2) {
    return '$param1 vstúpill/a do družstva $param2';
  }

  @override
  String xCreatedTeamY(String param1, String param2) {
    return '$param1 vytvoril/a tím $param2';
  }

  @override
  String get startedStreaming => 'začal vysielať';

  @override
  String xStartedStreaming(String param) {
    return '$param začal vysielať';
  }

  @override
  String get averageElo => 'Priemerný rating';

  @override
  String get location => 'Poloha';

  @override
  String get filterGames => 'Filter hier';

  @override
  String get reset => 'Obnoviť';

  @override
  String get apply => 'Potvrdiť';

  @override
  String get save => 'Uložiť';

  @override
  String get leaderboard => 'Rebríček';

  @override
  String get screenshotCurrentPosition => 'Odfotiť aktuálnu pozíciu';

  @override
  String get gameAsGIF => 'Uložiť ako GIF';

  @override
  String get pasteTheFenStringHere => 'Sem vložte FEN reťazec';

  @override
  String get pasteThePgnStringHere => 'Sem vložte PGN reťazec';

  @override
  String get orUploadPgnFile => 'Alebo nahrajte súbor PGN';

  @override
  String get fromPosition => 'Z pozície';

  @override
  String get continueFromHere => 'Pokračujte odtiaľto';

  @override
  String get toStudy => 'Štúdia';

  @override
  String get importGame => 'Importovať partiu';

  @override
  String get importGameExplanation => 'Vložením partie vo formáte PGN získate možnosť jej prehrania, počítačovú analýzu, chat k partii ako aj URL pre jej zdieľanie.';

  @override
  String get importGameCaveat => 'Variácie sa vymažú. Ak ich chcete zachovať, importujte PGN prostredníctvom štúdie.';

  @override
  String get importGameDataPrivacyWarning => 'Toto PGN je verejne dostupné. Ak chcete partiu importovať súkromne, použite štúdiu!';

  @override
  String get thisIsAChessCaptcha => 'Šachová CAPTCHA';

  @override
  String get clickOnTheBoardToMakeYourMove => 'Kliknite na šachovnicu a spravte ťah, aby ste dokázali, že ste človek.';

  @override
  String get captcha_fail => 'Prosím vyriešte šachovú captcha.';

  @override
  String get notACheckmate => 'Nie je to mat';

  @override
  String get whiteCheckmatesInOneMove => 'Biely dá mat 1. ťahom';

  @override
  String get blackCheckmatesInOneMove => 'Čierny dá mat 1. ťahom';

  @override
  String get retry => 'Znova';

  @override
  String get reconnecting => 'Pripájanie';

  @override
  String get noNetwork => 'Offline';

  @override
  String get favoriteOpponents => 'Obľúbení súperi';

  @override
  String get follow => 'Sledovať';

  @override
  String get following => 'Sledujete';

  @override
  String get unfollow => 'Zrušiť sledovanie';

  @override
  String followX(String param) {
    return 'Sledovať $param';
  }

  @override
  String unfollowX(String param) {
    return 'Prestať sledovať $param';
  }

  @override
  String get block => 'Blokovať';

  @override
  String get blocked => 'Blokovaný';

  @override
  String get unblock => 'Odblokovať';

  @override
  String get followsYou => 'Sleduje Vás';

  @override
  String xStartedFollowingY(String param1, String param2) {
    return '$param1 začal sledovať $param2';
  }

  @override
  String get more => 'Viac';

  @override
  String get memberSince => 'Členom od';

  @override
  String lastSeenActive(String param) {
    return 'Posledné prihlásenie $param';
  }

  @override
  String get player => 'Hráč';

  @override
  String get list => 'Zoznam';

  @override
  String get graph => 'Graf';

  @override
  String get required => 'Vyžaduje sa.';

  @override
  String get openTournaments => 'Otvorené turnaje';

  @override
  String get duration => 'Dĺžka';

  @override
  String get winner => 'Víťaz';

  @override
  String get standing => 'Poradie';

  @override
  String get createANewTournament => 'Vytvoriť nový turnaj';

  @override
  String get tournamentCalendar => 'Kalendár turnajov';

  @override
  String get conditionOfEntry => 'Podmienka vstupu:';

  @override
  String get advancedSettings => 'Pokročilé nastavenia';

  @override
  String get safeTournamentName => 'Názov turnaja vyberajte s rozvahou!';

  @override
  String get inappropriateNameWarning => 'Čokoľvek čo i len mierne nevhodné môže mať za následok uzavretie Vášho účtu.';

  @override
  String get emptyTournamentName => 'Ak názov nevyplníte, turnaj bude pomenovaný po náhodnom veľmajstrovi.';

  @override
  String get makePrivateTournament => 'Nastav turnaj ako súkromný a obmedz prístup k nemu pomocou hesla';

  @override
  String get join => 'Pripojiť';

  @override
  String get withdraw => 'Odstúpiť';

  @override
  String get points => 'Bodov';

  @override
  String get wins => 'Výhier';

  @override
  String get losses => 'Prehier';

  @override
  String get createdBy => 'Vytvorené';

  @override
  String get tournamentIsStarting => 'Turnaj sa začína';

  @override
  String get tournamentPairingsAreNowClosed => 'Párovanie hráčov v turnaji je už uzavreté.';

  @override
  String standByX(String param) {
    return 'Čakajte $param, vyberám súpera, pripravte sa!';
  }

  @override
  String get pause => 'Pozastaviť';

  @override
  String get resume => 'Pokračovať';

  @override
  String get youArePlaying => 'Hra začala!';

  @override
  String get winRate => 'Pomer výhier';

  @override
  String get berserkRate => 'Miera besnenia';

  @override
  String get performance => 'Výkon';

  @override
  String get tournamentComplete => 'Turnaj skončil';

  @override
  String get movesPlayed => 'Odohraných ťahov';

  @override
  String get whiteWins => 'Výhry ako biely';

  @override
  String get blackWins => 'Výhry ako čierny';

  @override
  String get drawRate => 'Pomer remíz';

  @override
  String get draws => 'Remízy';

  @override
  String nextXTournament(String param) {
    return 'Ďalší $param turnaj:';
  }

  @override
  String get averageOpponent => 'Priemerná sila súpera';

  @override
  String get boardEditor => 'Editor šachovnice';

  @override
  String get setTheBoard => 'Upraviť šachovnicu';

  @override
  String get popularOpenings => 'Populárne otvorenia';

  @override
  String get endgamePositions => 'Pozície z koncoviek';

  @override
  String chess960StartPosition(String param) {
    return 'Počiatočná pozícia šachu Chess960: $param';
  }

  @override
  String get startPosition => 'Štartovacia pozícia';

  @override
  String get clearBoard => 'Vyčistiť šachovnicu';

  @override
  String get loadPosition => 'Načítať pozíciu';

  @override
  String get isPrivate => 'Súkromný';

  @override
  String reportXToModerators(String param) {
    return 'Nahlásiť $param moderátorom';
  }

  @override
  String profileCompletion(String param) {
    return 'Úplnosť profilu: $param';
  }

  @override
  String xRating(String param) {
    return '$param hodnotenie';
  }

  @override
  String get ifNoneLeaveEmpty => 'Ak nemáte, nevyplňujte';

  @override
  String get profile => 'Profil';

  @override
  String get editProfile => 'Upraviť profil';

  @override
  String get realName => 'Skutočné meno';

  @override
  String get setFlair => 'Nastavte si svoju ikonku štýlu';

  @override
  String get flair => 'Ikonka štýlu';

  @override
  String get youCanHideFlair => 'V nastaveniach je možné skryť všetky ikonky štýlu používateľov na celej stránke.';

  @override
  String get biography => 'Životopis';

  @override
  String get countryRegion => 'Krajina alebo región';

  @override
  String get thankYou => 'Ďakujeme!';

  @override
  String get socialMediaLinks => 'Odkazy na sociálne siete';

  @override
  String get oneUrlPerLine => 'Jedna URL na riadok.';

  @override
  String get inlineNotation => 'Notácia v riadkoch';

  @override
  String get makeAStudy => 'Pre bezpečné uchovanie a zdieľanie pouvažujte nad vytvorením štúdie.';

  @override
  String get clearSavedMoves => 'Zrušiť dočasné ťahy';

  @override
  String get previouslyOnLichessTV => 'Bolo na Lichess TV';

  @override
  String get onlinePlayers => 'Pripojení hráči';

  @override
  String get activePlayers => 'Najaktívnejší hráči';

  @override
  String get bewareTheGameIsRatedButHasNoClock => 'Pozor, partia je hodnotená, ale bez časového limitu!';

  @override
  String get success => 'Hotovo';

  @override
  String get automaticallyProceedToNextGameAfterMoving => 'po ťahu automaticky prejdite k ďalšej hre';

  @override
  String get autoSwitch => 'Prepnite automaticky';

  @override
  String get puzzles => 'Šachové úlohy';

  @override
  String get onlineBots => 'Online bots';

  @override
  String get name => 'Meno';

  @override
  String get description => 'Popis';

  @override
  String get descPrivate => 'Opis pre členov tímu';

  @override
  String get descPrivateHelp => 'Text, ktorý uvidia len členovia daného tímu. Ak je zadaný, tak nahrádza verejný opis členov tímu.';

  @override
  String get no => 'Nie';

  @override
  String get yes => 'Áno';

  @override
  String get help => 'Pomoc:';

  @override
  String get createANewTopic => 'Vytvoriť novú tému';

  @override
  String get topics => 'Témy';

  @override
  String get posts => 'Príspevkov';

  @override
  String get lastPost => 'Posledné príspevky';

  @override
  String get views => 'Videní';

  @override
  String get replies => 'Odpovedí';

  @override
  String get replyToThisTopic => 'Odpovedať na túto tému';

  @override
  String get reply => 'Odpoveď';

  @override
  String get message => 'Správa';

  @override
  String get createTheTopic => 'Vytvoriť tému';

  @override
  String get reportAUser => 'Nahlásiť používateľa';

  @override
  String get user => 'Používateľ';

  @override
  String get reason => 'Dôvod';

  @override
  String get whatIsIheMatter => 'Čo sa deje?';

  @override
  String get cheat => 'Podvod';

  @override
  String get troll => 'Troll';

  @override
  String get other => 'Iné';

  @override
  String get reportDescriptionHelp => 'Vložte odkaz na hru/y, a vysvetlite, čo je zlé na tomto správaní používateľa.';

  @override
  String get error_provideOneCheatedGameLink => 'Prosím, uveďte aspoň jeden odkaz na partiu, v ktorej sa podvádzalo.';

  @override
  String by(String param) {
    return 'od $param';
  }

  @override
  String importedByX(String param) {
    return 'Importoval $param';
  }

  @override
  String get thisTopicIsNowClosed => 'Táto téma je uzavretá.';

  @override
  String get blog => 'Blog';

  @override
  String get notes => 'Poznámky';

  @override
  String get typePrivateNotesHere => 'Sem píšte súkromné správy';

  @override
  String get writeAPrivateNoteAboutThisUser => 'Napíšte súkromnú poznámku o tomto používateľovi';

  @override
  String get noNoteYet => 'Zatiaľ žiadna poznámka';

  @override
  String get invalidUsernameOrPassword => 'Nesprávne meno alebo heslo';

  @override
  String get incorrectPassword => 'Nesprávne heslo';

  @override
  String get invalidAuthenticationCode => 'Neplatný overovací kód';

  @override
  String get emailMeALink => 'Pošlite link emailom';

  @override
  String get currentPassword => 'Aktuálne heslo';

  @override
  String get newPassword => 'Nové heslo';

  @override
  String get newPasswordAgain => 'Nové heslo (znovu)';

  @override
  String get newPasswordsDontMatch => 'Zadané heslá sa nezhodujú';

  @override
  String get newPasswordStrength => 'Sila hesla';

  @override
  String get clockInitialTime => 'Počiatočný čas na hodinách';

  @override
  String get clockIncrement => 'Časový prírastok';

  @override
  String get privacy => 'Súkromie';

  @override
  String get privacyPolicy => 'Ochrana osobných údajov';

  @override
  String get letOtherPlayersFollowYou => 'Povoliť ostatným hráčom aby Vás sledovali';

  @override
  String get letOtherPlayersChallengeYou => 'Povoliť ostatným hráčom aby Vás vyzvali k partii';

  @override
  String get letOtherPlayersInviteYouToStudy => 'Povoliť ostatným hráčom aby Vás pozvali k šachovej štúdii';

  @override
  String get sound => 'Zvuk';

  @override
  String get none => 'Žiadny';

  @override
  String get fast => 'Rýchlo';

  @override
  String get normal => 'Normálne';

  @override
  String get slow => 'Pomaly';

  @override
  String get insideTheBoard => 'Vnútri šachovnice';

  @override
  String get outsideTheBoard => 'Mimo šachovnice';

  @override
  String get allSquaresOfTheBoard => 'Všetky políčka šachovnice';

  @override
  String get onSlowGames => 'Pri pomalých hrách';

  @override
  String get always => 'Vždy';

  @override
  String get never => 'Nikdy';

  @override
  String xCompetesInY(String param1, String param2) {
    return '$param1 súťaží v $param2';
  }

  @override
  String get victory => 'Výhra';

  @override
  String get defeat => 'Porážka';

  @override
  String victoryVsYInZ(String param1, String param2, String param3) {
    return '$param1 proti $param2 v $param3';
  }

  @override
  String defeatVsYInZ(String param1, String param2, String param3) {
    return '$param1 proti $param2 v $param3';
  }

  @override
  String drawVsYInZ(String param1, String param2, String param3) {
    return '$param1 proti $param2 v $param3';
  }

  @override
  String get timeline => 'Rozvrh';

  @override
  String get starting => 'Štart:';

  @override
  String get allInformationIsPublicAndOptional => 'Všetky informácie sú verejné a voliteľné.';

  @override
  String get biographyDescription => 'Napíšte niečo o sebe, čo sa Vám v šachu páči, Vaše obľúbené otvorenia, partie, hráči…';

  @override
  String get listBlockedPlayers => 'Zoznam zablokovaných hráčov';

  @override
  String get human => 'Človek';

  @override
  String get computer => 'Počítač';

  @override
  String get side => 'Farba';

  @override
  String get clock => 'Tempo';

  @override
  String get opponent => 'Protihráč';

  @override
  String get learnMenu => 'Učiť sa';

  @override
  String get studyMenu => 'Štúdie';

  @override
  String get practice => 'Tréning';

  @override
  String get community => 'Komunita';

  @override
  String get tools => 'Nástroje';

  @override
  String get increment => 'Prírastok';

  @override
  String get error_unknown => 'Neplatná hodnota';

  @override
  String get error_required => 'Povinné pole';

  @override
  String get error_email => 'Táto emailová adresa je neplatná';

  @override
  String get error_email_acceptable => 'Táto emailová adresa nie je akceptovateľná. Ešte raz ju prosím skontrolujte a skúste zadať znova.';

  @override
  String get error_email_unique => 'Emailová adresa je neplatná alebo sa už používa';

  @override
  String get error_email_different => 'Túto emailovú adresu už používate';

  @override
  String error_minLength(String param) {
    return 'Minimálna dĺžka je $param znakov';
  }

  @override
  String error_maxLength(String param) {
    return 'Maximálna dĺžka je $param znakov';
  }

  @override
  String error_min(String param) {
    return 'Minimálna dĺžka je $param znakov';
  }

  @override
  String error_max(String param) {
    return 'Maximálna dĺžka je $param znakov';
  }

  @override
  String ifRatingIsPlusMinusX(String param) {
    return 'Keď je hodnotenie ± $param';
  }

  @override
  String get ifRegistered => 'Ak sú registrovaní';

  @override
  String get onlyExistingConversations => 'Iba existujúce konverzácie';

  @override
  String get onlyFriends => 'Iba priatelia';

  @override
  String get menu => 'Menu';

  @override
  String get castling => 'Rošáda';

  @override
  String get whiteCastlingKingside => 'Biely O-O';

  @override
  String get blackCastlingKingside => 'Čierny O-O';

  @override
  String tpTimeSpentPlaying(String param) {
    return 'Čas strávený hraním: $param';
  }

  @override
  String get watchGames => 'Sledovať hry';

  @override
  String tpTimeSpentOnTV(String param) {
    return 'Čas strávený na TV: $param';
  }

  @override
  String get watch => 'Sledovať';

  @override
  String get videoLibrary => 'Video knižnica';

  @override
  String get streamersMenu => 'Streameri';

  @override
  String get mobileApp => 'Mobilná aplikácia';

  @override
  String get webmasters => 'Správcovia';

  @override
  String get about => 'Viac o';

  @override
  String aboutX(String param) {
    return 'O $param';
  }

  @override
  String xIsAFreeYLibreOpenSourceChessServer(String param1, String param2) {
    return '$param1 je bezplatný ($param2), slobodný open source šachový server bez reklám.';
  }

  @override
  String get really => 'naozaj';

  @override
  String get contribute => 'Prispieť';

  @override
  String get termsOfService => 'Podmienky služby';

  @override
  String get sourceCode => 'Zdrojový kód';

  @override
  String get simultaneousExhibitions => 'Simultánne exhibície';

  @override
  String get host => 'Hostiteľ';

  @override
  String hostColorX(String param) {
    return 'Farba simultánneho hráča: $param';
  }

  @override
  String get yourPendingSimuls => 'Vaše čakajúce simultánky';

  @override
  String get createdSimuls => 'Novovytvorené simultánky';

  @override
  String get hostANewSimul => 'Vytvoriť novú simultánku';

  @override
  String get signUpToHostOrJoinASimul => 'Prihláste sa k zorganizovaniu alebo zapojeniu sa do simultánky';

  @override
  String get noSimulFound => 'Simultánka nenájdená';

  @override
  String get noSimulExplanation => 'Táto simultánna exhibícia neexistuje.';

  @override
  String get returnToSimulHomepage => 'Späť na Simultánku';

  @override
  String get aboutSimul => 'Simultánky sú hry jedného hráča proti viacerým oponentom súčasne.';

  @override
  String get aboutSimulImage => 'Z celkovo 50 hráčov, Fisher vyhral 47 hier, 2 remízoval a 1 prehral.';

  @override
  String get aboutSimulRealLife => 'Koncept je prebraný zo skutočných svetových podujatí. V tomto prípade sa hostiteľ simultánky pohybuje od stola k stolu aby zahral jeden ťah.';

  @override
  String get aboutSimulRules => 'Keď simultánka začne, každý hráč hrá s hostiteľom, ktorý má biele figúrky. Simultánka končí, keď sa dohrajú všetky partie.';

  @override
  String get aboutSimulSettings => 'Simultánky sú vždy nebodované. Odvety, vrátenie ťahu a \"pridávania času\" sú zakázané.';

  @override
  String get create => 'Vytvoriť';

  @override
  String get whenCreateSimul => 'Po vytvorení simultánky, môžete hrať s niekoľkými hráčmi naraz.';

  @override
  String get simulVariantsHint => 'Ak vyberiete viacero variantov, každý hráč si môže vybrať, ktorý bude hrať.';

  @override
  String get simulClockHint => 'Nastavenie (Fisherových) hodín. Čím viac súperov, tým viac času budete potrebovat.';

  @override
  String get simulAddExtraTime => 'Môžete si pridať dodatočný čas k vašim hodinám pre zlepšenie behu simultánky.';

  @override
  String get simulHostExtraTime => 'Dotatočný čas pre hostiteľa.';

  @override
  String get simulAddExtraTimePerPlayer => 'Za každého hráča, ktorý sa pripojí k simultánke, navýšiť čas na Vašich hodinách o počiatočný čas partie.';

  @override
  String get simulHostExtraTimePerPlayer => 'Navýšiť čas na hodinách za každého hráča';

  @override
  String get lichessTournaments => 'Lichess turnaje';

  @override
  String get tournamentFAQ => 'Často kladené otázky pre turnajovú arénu';

  @override
  String get timeBeforeTournamentStarts => 'Čas do štartu turnaja';

  @override
  String get averageCentipawnLoss => 'Priemerná strata (v stotinách pešiaka)';

  @override
  String get accuracy => 'Presnosť';

  @override
  String get keyboardShortcuts => 'Klávesové skratky';

  @override
  String get keyMoveBackwardOrForward => 'pohyb dopredu/späť';

  @override
  String get keyGoToStartOrEnd => 'ísť na začiatok/koniec';

  @override
  String get keyCycleSelectedVariation => 'Cycle selected variation';

  @override
  String get keyShowOrHideComments => 'zobraziť/skryť komentáre';

  @override
  String get keyEnterOrExitVariation => 'zvoliť/opustiť variant';

  @override
  String get keyRequestComputerAnalysis => 'Požadujte analýzu počítačom, Poučte sa zo svojich chýb';

  @override
  String get keyNextLearnFromYourMistakes => 'Ďalej (Poučte sa zo svojich chýb)';

  @override
  String get keyNextBlunder => 'Ďalšia hrubá chyba';

  @override
  String get keyNextMistake => 'Ďalšia chyba';

  @override
  String get keyNextInaccuracy => 'Ďalšia nepresnosť';

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
  String get playSelectedMove => 'play selected move';

  @override
  String get newTournament => 'Nový turnaj';

  @override
  String get tournamentHomeTitle => 'Šachový turnaj ponúka rôzne časové nastavenia partie a rôzne varianty';

  @override
  String get tournamentHomeDescription => 'Hrajte šachové turnaje s rýchlym tempom! Pridajte sa k oficiálnym plánovaným turnajom, alebo si vytvorte vlastný turnaj. Bullet, Blitz, Classical, Chess960, King of the Hill, Threecheck, a viac možností na výber pre nekonečnú šachovú zábavu.';

  @override
  String get tournamentNotFound => 'Turnaj nenájdený';

  @override
  String get tournamentDoesNotExist => 'Zvolený turnaj neexistuje';

  @override
  String get tournamentMayHaveBeenCanceled => 'Turnaj mohol byť zrušený, ak všetci hráči opustili turnaj pred jeho začatím.';

  @override
  String get returnToTournamentsHomepage => 'Späť na prehľad turnajov';

  @override
  String weeklyPerfTypeRatingDistribution(String param) {
    return 'Týždenné $param ratingové hodnotenie';
  }

  @override
  String yourPerfTypeRatingIsRating(String param1, String param2) {
    return 'Vaše $param1 hodnotenie je $param2.';
  }

  @override
  String youAreBetterThanPercentOfPerfTypePlayers(String param1, String param2) {
    return 'Ste lepší/lepšia než $param1 $param2 hráčov.';
  }

  @override
  String userIsBetterThanPercentOfPerfTypePlayers(String param1, String param2, String param3) {
    return '$param1 je lepší/lepšia než $param2 $param3 hráčov.';
  }

  @override
  String betterThanPercentPlayers(String param1, String param2) {
    return 'Lepší než $param1 $param2 hráčov';
  }

  @override
  String youDoNotHaveAnEstablishedPerfTypeRating(String param) {
    return 'Nemáte ustálené $param hodnotenie.';
  }

  @override
  String get yourRating => 'Váš rating';

  @override
  String get cumulative => 'Kumulatívne';

  @override
  String get glicko2Rating => 'Glicko-2 rating';

  @override
  String get checkYourEmail => 'Skontrolujte si svoj e-mail';

  @override
  String get weHaveSentYouAnEmailClickTheLink => 'Práve sme Vám poslali správu na Váš e-mail. Kliknite na link v e-mail-i, na aktivovanie Vášho účtu.';

  @override
  String get ifYouDoNotSeeTheEmailCheckOtherPlaces => 'Ak nevidíte email, pozrite iné miesta kde by mohol byť, ako napríklad kôš, spam, sociálne, alebo iné priečinky.';

  @override
  String weHaveSentYouAnEmailTo(String param) {
    return 'Poslali sme email na $param. Kliknite na link v emaili na obnovenie hesla.';
  }

  @override
  String byRegisteringYouAgreeToBeBoundByOur(String param) {
    return 'Registráciou súhlasíte aby ste boli viazaný s našimi $param.';
  }

  @override
  String readAboutOur(String param) {
    return 'Prečítajte si o našej $param.';
  }

  @override
  String get networkLagBetweenYouAndLichess => 'Internetové oneskorenie medzi Vami a lichessom';

  @override
  String get timeToProcessAMoveOnLichessServer => 'Čas na spracovanie ťahu na lichess serveri';

  @override
  String get downloadAnnotated => 'Stiahnuť s poznámkami';

  @override
  String get downloadRaw => 'Stiahnuť čisté PGN';

  @override
  String get downloadImported => 'Stiahnuť importované';

  @override
  String get crosstable => 'Tabuľka';

  @override
  String get youCanAlsoScrollOverTheBoardToMoveInTheGame => 'K pohybu v partii môžete tiež použiť scrollovacie koliečko myši nad šachovnicou.';

  @override
  String get scrollOverComputerVariationsToPreviewThem => 'Prejdite kurzorom ponad počítačové varianty pre zobrazenie ich náhľadu.';

  @override
  String get analysisShapesHowTo => 'Stlačte shift+ľavé tlačidlo na myši alebo pravé tlačidlo na myši na kreslenie kruhov a šípok na šachovnici.';

  @override
  String get letOtherPlayersMessageYou => 'Povoliť ostatným hráčom aby Vám napísali správu';

  @override
  String get receiveForumNotifications => 'Dostávať upozornenia keď ťa niekto spomenie na fóre';

  @override
  String get shareYourInsightsData => 'Zdieľať výsledky analýz Vašich partií';

  @override
  String get withNobody => 'S nikým';

  @override
  String get withFriends => 'S priateľmi';

  @override
  String get withEverybody => 'S každým';

  @override
  String get kidMode => 'Detský režim';

  @override
  String get kidModeIsEnabled => 'Kid mode is enabled.';

  @override
  String get kidModeExplanation => 'V detskom režime je pre ochranu detí a mládeže pred ostatnými užívateľmi akákoľvek komunikácia zablokovaná.';

  @override
  String inKidModeTheLichessLogoGetsIconX(String param) {
    return 'Keď je zapnutý detský režim, tak sa pri logu Lichess objaví ikona $param. Podľa toho viete, že je Vaše dieťa v bezpečí.';
  }

  @override
  String get askYourChessTeacherAboutLiftingKidMode => 'Váš účet je spravovaný niekým iným. Opýtajte sa svojho učiteľa šachu na zrušenie detského režimu.';

  @override
  String get enableKidMode => 'Povoliť detský režim';

  @override
  String get disableKidMode => 'Vypnúť detský režim';

  @override
  String get security => 'Zabezpečenie';

  @override
  String get sessions => 'Pripojenia';

  @override
  String get revokeAllSessions => 'zrušiť všetky pripojenia';

  @override
  String get playChessEverywhere => 'Hrajte šachy kdekoľvek';

  @override
  String get asFreeAsLichess => 'Slobodný ako lichess';

  @override
  String get builtForTheLoveOfChessNotMoney => 'Vytvorené z lásky k šachom, nie pre peniaze';

  @override
  String get everybodyGetsAllFeaturesForFree => 'Každý dostane všetky možnosti zadarmo';

  @override
  String get zeroAdvertisement => 'Bez reklám';

  @override
  String get fullFeatured => 'Plne vybavený';

  @override
  String get phoneAndTablet => 'Mobil a tablet';

  @override
  String get bulletBlitzClassical => 'Ultrarýchla hra, blesková hra, klasická hra';

  @override
  String get correspondenceChess => 'Korespondenčné šachy';

  @override
  String get onlineAndOfflinePlay => 'Hra online i offline';

  @override
  String get viewTheSolution => 'Pozrite riešenie';

  @override
  String get followAndChallengeFriends => 'Sledovať a vyzvať priateľov';

  @override
  String get gameAnalysis => 'Analýza hry';

  @override
  String xHostsY(String param1, String param2) {
    return '$param1 založil $param2';
  }

  @override
  String xJoinsY(String param1, String param2) {
    return '$param1 sa pridal k $param2';
  }

  @override
  String xLikesY(String param1, String param2) {
    return '$param1 lajkol $param2';
  }

  @override
  String get quickPairing => 'Rýchle nájdenie súpera';

  @override
  String get lobby => 'Výzvy hráčov';

  @override
  String get anonymous => 'Anonymný';

  @override
  String yourScore(String param) {
    return 'Vaše skóre: $param';
  }

  @override
  String get language => 'Jazyk';

  @override
  String get background => 'Pozadie';

  @override
  String get light => 'Svetlé';

  @override
  String get dark => 'Tmavé';

  @override
  String get transparent => 'Priehľadné';

  @override
  String get deviceTheme => 'Motív zariadenia';

  @override
  String get backgroundImageUrl => 'URL obrázka na pozadí:';

  @override
  String get board => 'Šachovnica';

  @override
  String get size => 'Veľkosť';

  @override
  String get opacity => 'Priehľadnosť';

  @override
  String get brightness => 'Jas';

  @override
  String get hue => 'Odtieň';

  @override
  String get boardReset => 'Obnoviť farby na predvolené hodnoty';

  @override
  String get pieceSet => 'Vzhľad figúr';

  @override
  String get embedInYourWebsite => 'Vložiť na web';

  @override
  String get usernameAlreadyUsed => 'Toto užívateľské meno už existuje. Zvoľte si, prosím, iné.';

  @override
  String get usernamePrefixInvalid => 'Užívateľské meno sa musí začínať písmenom.';

  @override
  String get usernameSuffixInvalid => 'Užívateľské meno musí končiť písmenom alebo číslom.';

  @override
  String get usernameCharsInvalid => 'Užívateľské meno musí obsahovať iba písmená, čísla, podčiarkovník a pomlčku.';

  @override
  String get usernameUnacceptable => 'Toto užívateľské meno nie je prijateľné.';

  @override
  String get playChessInStyle => 'Hrajte šach štýlovo';

  @override
  String get chessBasics => 'Základy šachu';

  @override
  String get coaches => 'Tréneri';

  @override
  String get invalidPgn => 'Neplatný formát PGN';

  @override
  String get invalidFen => 'Neplatný formát FEN';

  @override
  String get custom => 'Vlastná';

  @override
  String get notifications => 'Upozornenia';

  @override
  String notificationsX(String param1) {
    return 'Upozornenia: $param1';
  }

  @override
  String perfRatingX(String param) {
    return 'Rating: $param';
  }

  @override
  String get practiceWithComputer => 'Precvičenie s počítačom';

  @override
  String anotherWasX(String param) {
    return 'Ďalšou možnosťou bolo $param';
  }

  @override
  String bestWasX(String param) {
    return 'Najlepší ťah bol $param';
  }

  @override
  String get youBrowsedAway => 'Precvičovanie prerušené';

  @override
  String get resumePractice => 'Pokračovať v precvičovaní';

  @override
  String get drawByFiftyMoves => 'Partia bola ukončená remízou podľa pravidla 50 ťahov.';

  @override
  String get theGameIsADraw => 'Hra skončila remízou.';

  @override
  String get computerThinking => 'Počítač premýšľa...';

  @override
  String get seeBestMove => 'Ukázať najlepší ťah';

  @override
  String get hideBestMove => 'Skryť najlepší ťah';

  @override
  String get getAHint => 'Získať nápovedu';

  @override
  String get evaluatingYourMove => 'Hodnotím Váš ťah...';

  @override
  String get whiteWinsGame => 'Biely vyhral';

  @override
  String get blackWinsGame => 'Čierny vyhral';

  @override
  String get learnFromYourMistakes => 'Poučte sa zo svojich chýb';

  @override
  String get learnFromThisMistake => 'Poučte sa z tejto chyby';

  @override
  String get skipThisMove => 'Preskočiť tento krok';

  @override
  String get next => 'Ďalší';

  @override
  String xWasPlayed(String param) {
    return 'hralo sa $param';
  }

  @override
  String get findBetterMoveForWhite => 'Nájdite lepší ťah bieleho';

  @override
  String get findBetterMoveForBlack => 'Nájdite lepší ťah čierneho';

  @override
  String get resumeLearning => 'Pokračovať v učení';

  @override
  String get youCanDoBetter => 'Dá sa to aj lepšie';

  @override
  String get tryAnotherMoveForWhite => 'Skúste ako biely potiahnuť niečo iné';

  @override
  String get tryAnotherMoveForBlack => 'Skúste ako čierny potiahnuť niečo iné';

  @override
  String get solution => 'Riešenie';

  @override
  String get waitingForAnalysis => 'Čakanie na analýzu';

  @override
  String get noMistakesFoundForWhite => 'Neboli nájdené žiadne chyby bieleho';

  @override
  String get noMistakesFoundForBlack => 'Neboli nájdené žiadne chyby čierneho';

  @override
  String get doneReviewingWhiteMistakes => 'Prezeranie chýb bieleho ukončené';

  @override
  String get doneReviewingBlackMistakes => 'Prezeranie chýb čierneho ukončené';

  @override
  String get doItAgain => 'Urob to znovu';

  @override
  String get reviewWhiteMistakes => 'Preskúmať chyby bieleho';

  @override
  String get reviewBlackMistakes => 'Preskúmať chyby čierneho';

  @override
  String get advantage => 'Výhoda';

  @override
  String get opening => 'Otvorenie';

  @override
  String get middlegame => 'Stredná hra';

  @override
  String get endgame => 'Koncovka';

  @override
  String get conditionalPremoves => 'Podmienené predťahy';

  @override
  String get addCurrentVariation => 'Pridaj aktuálny variant';

  @override
  String get playVariationToCreateConditionalPremoves => 'Hrať variant a vytvoriť podmienené predťahy';

  @override
  String get noConditionalPremoves => 'Žiadne podmienené predťahy';

  @override
  String playX(String param) {
    return 'Hrať $param';
  }

  @override
  String get showUnreadLichessMessage => 'You have received a private message from Lichess.';

  @override
  String get clickHereToReadIt => 'Click here to read it';

  @override
  String get sorry => 'Prepáčte :(';

  @override
  String get weHadToTimeYouOutForAWhile => 'Na chvíľu sme Vás museli odstaviť.';

  @override
  String get why => 'Prečo?';

  @override
  String get pleasantChessExperience => 'Naším cieľom je poskytovať všetkým príjemný šachový zážitok.';

  @override
  String get goodPractice => 'Aby sme to docielili, musíme sa uistiť že sa všetci hráči správajú športovo.';

  @override
  String get potentialProblem => 'Keď zaznamenáme potenciálny problém, zobrazíme túto správu.';

  @override
  String get howToAvoidThis => 'Ako sa tomu vyhnúť?';

  @override
  String get playEveryGame => 'Dohrajte každú začatú partiu!';

  @override
  String get tryToWin => 'Snažte sa vyhrať (alebo aspoň zremizovať) každú partiu, ktorú hráte!';

  @override
  String get resignLostGames => 'Prehraté partie vzdajte (nenechávajte vypršať čas na hodinách)!';

  @override
  String get temporaryInconvenience => 'Ospravedlňujeme sa za spôsobenú nepríjemnosť,';

  @override
  String get wishYouGreatGames => 'a prajeme Vám veľa skvelých partií na lichess.org.';

  @override
  String get thankYouForReading => 'Ďakujeme za dočítanie.';

  @override
  String get lifetimeScore => 'Celkové skóre';

  @override
  String get currentMatchScore => 'Skóre aktuálneho zápasu';

  @override
  String get agreementAssistance => 'Súhlasím, že v žiadnom prípade nebudem používať asistenciu (počítača, šachovej knihy, databázy alebo inej osoby).';

  @override
  String get agreementNice => 'Súhlasím, že budem vždy rešpektovať ostatných hráčov.';

  @override
  String agreementMultipleAccounts(String param) {
    return 'Súhlasím, že nebudem vytvárať ďalšie účty (s výnimkou dôvodov uvedených v $param).';
  }

  @override
  String get agreementPolicy => 'Súhlasím, že budem dodržiavať všetky pravidlá Lichessu.';

  @override
  String get searchOrStartNewDiscussion => 'Prehľadávať alebo začať novú konverzáciu';

  @override
  String get edit => 'Upraviť';

  @override
  String get bullet => 'Bullet';

  @override
  String get blitz => 'Blitz';

  @override
  String get rapid => 'Rapid';

  @override
  String get classical => 'Klasický šach';

  @override
  String get ultraBulletDesc => 'Šialene rýchle partie: menej než 30 sekúnd';

  @override
  String get bulletDesc => 'Veľmi rýchle partie: menej než 3 minúty';

  @override
  String get blitzDesc => 'Rýchle partie: 3 až 8 minút';

  @override
  String get rapidDesc => 'Rapid partie: 8 až 25 minút';

  @override
  String get classicalDesc => 'Klasické partie: 25 minút a viac';

  @override
  String get correspondenceDesc => 'Korešpondenčné partie: jeden alebo viac dní na ťah';

  @override
  String get puzzleDesc => 'Tréner taktických šachových pozícií';

  @override
  String get important => 'Dôležité';

  @override
  String yourQuestionMayHaveBeenAnswered(String param1) {
    return 'Tvoja otázka už možno bola zodpovedaná $param1';
  }

  @override
  String get inTheFAQ => 'vo F.A.Q.';

  @override
  String toReportSomeoneForCheatingOrBadBehavior(String param1) {
    return 'Pre nahlásenie užívateľa kôli podvádzaniu alebo zlému správaniu, $param1';
  }

  @override
  String get useTheReportForm => 'použi nahlasovací formulár';

  @override
  String toRequestSupport(String param1) {
    return 'Pre vyžiadanie podpory, $param1';
  }

  @override
  String get tryTheContactPage => 'vyskúšaj stránku Kontakt';

  @override
  String makeSureToRead(String param1) {
    return 'Určite si prečítajte $param1';
  }

  @override
  String get theForumEtiquette => 'etiketu fóra';

  @override
  String get thisTopicIsArchived => 'Táto téma bola presunutá do archívu a nemožno už na ňu odpovedať.';

  @override
  String joinTheTeamXToPost(String param1) {
    return 'Pripoj sa k $param1, aby si mohol uverejňovať príspevky v tomto fóre';
  }

  @override
  String teamNamedX(String param1) {
    return '$param1 tím';
  }

  @override
  String get youCannotPostYetPlaySomeGames => 'Nemôžeš prispievať do fóra. Zahraj si nejaké hry!';

  @override
  String get subscribe => 'Prihlásiť sa k odberu';

  @override
  String get unsubscribe => 'Odhlásiť sa z odberu';

  @override
  String mentionedYouInX(String param1) {
    return 'Vás spomenul(a) v \"$param1\".';
  }

  @override
  String xMentionedYouInY(String param1, String param2) {
    return '$param1 ťa spomenul v \"$param2\".';
  }

  @override
  String invitedYouToX(String param1) {
    return 'Vás pozval(a) k \"$param1\".';
  }

  @override
  String xInvitedYouToY(String param1, String param2) {
    return '$param1 Vás pozval(a) k \"$param2\".';
  }

  @override
  String get youAreNowPartOfTeam => 'Teraz si členom tímu.';

  @override
  String youHaveJoinedTeamX(String param1) {
    return 'Vstúpili ste do družstva $param1.';
  }

  @override
  String get someoneYouReportedWasBanned => 'Hráč, ktorého ste nahlásili bol zabanovaný';

  @override
  String get congratsYouWon => 'Gratulujeme, vyhrali ste!';

  @override
  String gameVsX(String param1) {
    return 'v partii proti $param1';
  }

  @override
  String resVsX(String param1, String param2) {
    return '$param1 proti $param2';
  }

  @override
  String get lostAgainstTOSViolator => 'Prehrali ste s niekým kto porušil pravidlá stránky Lichess';

  @override
  String refundXpointsTimeControlY(String param1, String param2) {
    return 'Náhrada: $param1 $param2 ratingových bodov.';
  }

  @override
  String get timeAlmostUp => 'Čas čoskoro vyprší!';

  @override
  String get clickToRevealEmailAddress => '[Kliknite pre zobrazenie e-mailovej adresy]';

  @override
  String get download => 'Stiahnuť';

  @override
  String get coachManager => 'Nastavenia trénera';

  @override
  String get streamerManager => 'Správca streamov';

  @override
  String get cancelTournament => 'Zrušiť turnaj';

  @override
  String get tournDescription => 'Popis turnaja';

  @override
  String get tournDescriptionHelp => 'Je niečo čo by ste chceli povedať účastníkom turnaja? Snažte sa byť stručný! Môžete použiť markdown značky: [name](https://url)';

  @override
  String get ratedFormHelp => 'Partie sú hodnotené\na ovplyvnia rating hráčov';

  @override
  String get onlyMembersOfTeam => 'Iba členovia tímu';

  @override
  String get noRestriction => 'Bez obmedzenia';

  @override
  String get minimumRatedGames => 'Minimum hodnotených partií';

  @override
  String get minimumRating => 'Minimálny rating';

  @override
  String get maximumWeeklyRating => 'Maximálny týždenný rating';

  @override
  String positionInputHelp(String param) {
    return 'Vložte platný FEN pre začatie každej partie z konkrétnej pozície!\nFunguje len pre štandardné partie, nie pre varianty.\nMôžete použiť $param na vygenerovanie FEN pozície a potom ju sem vložiť.\nNechajte prázdne pre začatie partií zo základnej pozície!';
  }

  @override
  String get cancelSimul => 'Zrušiť simultánku';

  @override
  String get simulHostcolor => 'Farba figúr hostiteľa pre každú partiu';

  @override
  String get estimatedStart => 'Predpokladaný čas začiatku';

  @override
  String simulFeatured(String param) {
    return 'Zobraziť na $param';
  }

  @override
  String simulFeaturedHelp(String param) {
    return 'Ukázať vašu simultánnu hru všetkým na $param. Zakázať pre súkromné simultánne hry.';
  }

  @override
  String get simulDescription => 'Popis simultánky';

  @override
  String get simulDescriptionHelp => 'Chcete účastníkom niečo povedať?';

  @override
  String markdownAvailable(String param) {
    return '$param je dostupné pre viac pokročilú syntax.';
  }

  @override
  String get embedsAvailable => 'Prilepiť URL hry alebo kapitoly štúdia sem.';

  @override
  String get inYourLocalTimezone => 'Vo vašom miestnom časovom pásme';

  @override
  String get tournChat => 'Turnajová diskusia';

  @override
  String get noChat => 'Vypnutý chat';

  @override
  String get onlyTeamLeaders => 'Iba vedúci družstiev';

  @override
  String get onlyTeamMembers => 'Iba členovia tímu';

  @override
  String get navigateMoveTree => 'Navigovať na všetky ťahy vo forme stromu';

  @override
  String get mouseTricks => 'Finty s myšou';

  @override
  String get toggleLocalAnalysis => 'Prepnúť počítačové analýzy lokálneho počítača';

  @override
  String get toggleAllAnalysis => 'Prepnúť všetky počítačové analýzy';

  @override
  String get playComputerMove => 'Hrať najlepší ťah podľa počítača';

  @override
  String get analysisOptions => 'Možnosti analýzy';

  @override
  String get focusChat => 'Zamerať sa na daný rozhovor';

  @override
  String get showHelpDialog => 'Zobrazenie tohto dialógového okna s nápovedou';

  @override
  String get reopenYourAccount => 'Opätovné otvorenie účtu';

  @override
  String get closedAccountChangedMind => 'Ak ste váš účet zatvorili, ale potom ste si to nakoniec rozmysleli, dostali ste poslednú šancu vrátiť sa späť k vášmu účtu.';

  @override
  String get onlyWorksOnce => 'Toto bude fungovať iba raz.';

  @override
  String get cantDoThisTwice => 'Ak účet zatvoríte druhýkrát, nebude už možné ho obnoviť.';

  @override
  String get emailAssociatedToaccount => 'E-mailová adresa priradená k účtu';

  @override
  String get sentEmailWithLink => 'Poslali sme vám e-mail s prepojením.';

  @override
  String get tournamentEntryCode => 'Vstupný kód do turnaja';

  @override
  String get hangOn => 'Počkaj!';

  @override
  String gameInProgress(String param) {
    return 'Máte rozohranú partiu s $param.';
  }

  @override
  String get abortTheGame => 'Zrušiť partiu';

  @override
  String get resignTheGame => 'Vzdať partiu';

  @override
  String get youCantStartNewGame => 'Kým neukončíte túto partiu, nemôžete začať novú.';

  @override
  String get since => 'Od';

  @override
  String get until => 'Do';

  @override
  String get lichessDbExplanation => 'Hodnotené partie vybraté spomedzi všetkých Lichess hráčov';

  @override
  String get switchSides => 'Vymeniť strany';

  @override
  String get closingAccountWithdrawAppeal => 'Zrušením Vášho účtu bude Vaše odvolanie stiahnuté';

  @override
  String get ourEventTips => 'Naše tipy ohľadom organizovania podujatí';

  @override
  String get instructions => 'Inštrukcie';

  @override
  String get showMeEverything => 'Ukázať všetko';

  @override
  String get lichessPatronInfo => 'Lichess je bezplatný a úplne slobodný/nezávislý softvér s otvoreným zdrojovým kódom. Všetky prevádzkové náklady, vývoj a obsah sú financované výlučne z darov používateľov.';

  @override
  String get nothingToSeeHere => 'Nothing to see here at the moment.';

  @override
  String opponentLeftCounter(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Váš súper odišiel od šachovnice. O $count sekúnd si môžete nárokovať výhru.',
      many: 'Váš súper odišiel od šachovnice. O $count sekúnd si môžete nárokovať výhru.',
      few: 'Váš súper odišiel od šachovnice. O $count sekundy si môžete nárokovať výhru.',
      one: 'Váš súper odišiel od šachovnice. O $count sekundu si môžete nárokovať výhru.',
    );
    return '$_temp0';
  }

  @override
  String mateInXHalfMoves(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Mat v $count. polťahu',
      many: 'Mat v $count. polťahu',
      few: 'Mat v $count. polťahu',
      one: 'Mat v $count. polťahu',
    );
    return '$_temp0';
  }

  @override
  String nbBlunders(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count hrubých chýb',
      many: '$count hrubých chýb',
      few: '$count hrubé chyby',
      one: '$count hrubá chyba',
    );
    return '$_temp0';
  }

  @override
  String nbMistakes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count chýb',
      many: '$count chýb',
      few: '$count chyby',
      one: '$count chyba',
    );
    return '$_temp0';
  }

  @override
  String nbInaccuracies(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count nepresností',
      many: '$count nepresností',
      few: '$count nepresnosti',
      one: '$count nepresnosť',
    );
    return '$_temp0';
  }

  @override
  String nbPlayers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count pripojených hráčov',
      many: '$count pripojených hráčov',
      few: '$count pripojení hráči',
      one: '$count pripojený hráč',
    );
    return '$_temp0';
  }

  @override
  String nbGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count partií',
      many: '$count partií',
      few: '$count partie',
      one: '$count partia',
    );
    return '$_temp0';
  }

  @override
  String ratingXOverYGames(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count rating z $param2 partií',
      many: '$count rating z $param2 partií',
      few: '$count rating z $param2 partií',
      one: '$count rating z $param2 partie',
    );
    return '$_temp0';
  }

  @override
  String nbBookmarks(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count záložiek',
      many: '$count záložiek',
      few: '$count záložky',
      one: '$count záložka',
    );
    return '$_temp0';
  }

  @override
  String nbDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count dní',
      many: '$count dní',
      few: '$count dni',
      one: '$count deň',
    );
    return '$_temp0';
  }

  @override
  String nbHours(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count hodín',
      many: '$count hodín',
      few: '$count hodiny',
      one: '$count hodina',
    );
    return '$_temp0';
  }

  @override
  String nbMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count minút',
      many: '$count minút',
      few: '$count minúty',
      one: '$count minúta',
    );
    return '$_temp0';
  }

  @override
  String rankIsUpdatedEveryNbMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Poradie sa aktualizuje každých $count minút',
      many: 'Poradie sa aktualizuje každých $count minút',
      few: 'Poradie sa aktualizuje každé $count minúty',
      one: 'Poradie sa aktualizuje každú minútu',
    );
    return '$_temp0';
  }

  @override
  String nbPuzzles(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count úloh',
      many: '$count úloh',
      few: '$count úlohy',
      one: '$count úloha',
    );
    return '$_temp0';
  }

  @override
  String nbGamesWithYou(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count partií s Vami',
      many: '$count partií s Vami',
      few: '$count partie s Vami',
      one: '$count partia s Vami',
    );
    return '$_temp0';
  }

  @override
  String nbRated(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count hodnotených',
      many: '$count hodnotených',
      few: '$count hodnotené',
      one: '$count hodnotená',
    );
    return '$_temp0';
  }

  @override
  String nbWins(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count výhier',
      many: '$count výhier',
      few: '$count výhry',
      one: '$count výhra',
    );
    return '$_temp0';
  }

  @override
  String nbLosses(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count prehier',
      many: '$count prehier',
      few: '$count prehry',
      one: '$count prehra',
    );
    return '$_temp0';
  }

  @override
  String nbDraws(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count remíz',
      many: '$count remíz',
      few: '$count remízy',
      one: '$count remíza',
    );
    return '$_temp0';
  }

  @override
  String nbPlaying(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count práve sa hrá',
      many: '$count práve sa hrá',
      few: '$count práve sa hrajú',
      one: '$count práve sa hrá',
    );
    return '$_temp0';
  }

  @override
  String giveNbSeconds(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Pridať $count sekúnd',
      many: 'Pridať $count sekúnd',
      few: 'Pridať $count sekundy',
      one: 'Pridať $count sekundu',
    );
    return '$_temp0';
  }

  @override
  String nbTournamentPoints(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count turnajových bodov',
      many: '$count turnajových bodov',
      few: '$count turnajové body',
      one: '$count turnajový bod',
    );
    return '$_temp0';
  }

  @override
  String nbStudies(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count štúdií',
      many: '$count štúdií',
      few: '$count štúdie',
      one: '$count štúdia',
    );
    return '$_temp0';
  }

  @override
  String nbSimuls(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count simultánok',
      many: '$count simultánok',
      few: '$count simultánky',
      one: '$count simultánka',
    );
    return '$_temp0';
  }

  @override
  String moreThanNbRatedGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '≥ $count hodnotených partií',
      many: '≥ $count hodnotených partií',
      few: '≥ $count hodnotené partie',
      one: '≥ $count hodnotená partia',
    );
    return '$_temp0';
  }

  @override
  String moreThanNbPerfRatedGames(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '≥ $count $param2 hodnotených partií',
      many: '≥ $count $param2 hodnotených partií',
      few: '≥ $count $param2 hodnotené partie',
      one: '≥ $count $param2 hodnotená partia',
    );
    return '$_temp0';
  }

  @override
  String needNbMorePerfGames(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Potrebujete odohrať ešte $count $param2 hodnotených partií',
      many: 'Potrebujete odohrať ešte $count $param2 hodnotených partií',
      few: 'Potrebujete odohrať ešte $count $param2 hodnotené partie',
      one: 'Potrebujete odohrať ešte $count $param2 hodnotenú partiu',
    );
    return '$_temp0';
  }

  @override
  String needNbMoreGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Potrebujete odohrať ešte $count hodnotených partií',
      many: 'Potrebujete odohrať ešte $count hodnotených partií',
      few: 'Potrebujete odohrať ešte $count hodnotené partie',
      one: 'Potrebujete odohrať ešte $count hodnotenú partiu',
    );
    return '$_temp0';
  }

  @override
  String nbImportedGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count importovaných partií',
      many: '$count importovaných partií',
      few: '$count importované partie',
      one: '$count importovaná partia',
    );
    return '$_temp0';
  }

  @override
  String nbFriendsOnline(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count priateľov online',
      many: '$count priateľov online',
      few: '$count priatelia online',
      one: '$count priateľ online',
    );
    return '$_temp0';
  }

  @override
  String nbFollowers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count sledujúcich',
      many: '$count sledujúcich',
      few: '$count sledujúci',
      one: '$count sledujúci',
    );
    return '$_temp0';
  }

  @override
  String nbFollowing(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count sledovaných',
      many: '$count sledovaných',
      few: '$count sledovaní',
      one: '$count sledovaný',
    );
    return '$_temp0';
  }

  @override
  String lessThanNbMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Menej ako $count minút',
      many: 'Menej ako $count minút',
      few: 'Menej ako $count minúty',
      one: 'Menej ako $count minúta',
    );
    return '$_temp0';
  }

  @override
  String nbGamesInPlay(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count rozohraných partií',
      many: '$count rozohraných partií',
      few: '$count rozohrané partie',
      one: '$count rozohraná partia',
    );
    return '$_temp0';
  }

  @override
  String maximumNbCharacters(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Maximum: $count znakov.',
      many: 'Maximum: $count znakov.',
      few: 'Maximum: $count znaky.',
      one: 'Maximum: $count znak.',
    );
    return '$_temp0';
  }

  @override
  String blocks(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count blokovaných hráčov',
      many: '$count blokovaných hráčov',
      few: '$count blokovaní hráči',
      one: '$count blokovaný hráč',
    );
    return '$_temp0';
  }

  @override
  String nbForumPosts(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count príspvkov vo fóre',
      many: '$count príspvkov vo fóre',
      few: '$count príspevky vo fóre',
      one: '$count príspevok vo fóre',
    );
    return '$_temp0';
  }

  @override
  String nbPerfTypePlayersThisWeek(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Tento týždeň hralo $param2 $count hráčov.',
      many: 'Tento týždeň hralo $param2 $count hráčov.',
      few: 'Tento týždeň hrali $param2 $count hráči.',
      one: 'Tento týždeň hral $param2 $count hráč.',
    );
    return '$_temp0';
  }

  @override
  String availableInNbLanguages(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Dostupné v $count jazykoch!',
      many: 'Dostupné v $count jazykoch!',
      few: 'Dostupné v $count jazykoch!',
      one: 'Dostupné v $count jazyku!',
    );
    return '$_temp0';
  }

  @override
  String nbSecondsToPlayTheFirstMove(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count sekúnd na vykonanie prvého ťahu',
      many: '$count sekúnd na vykonanie prvého ťahu',
      few: '$count sekundy na vykonanie prvého ťahu',
      one: '$count sekunda na vykonanie prvého ťahu',
    );
    return '$_temp0';
  }

  @override
  String nbSeconds(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count sekúnd',
      many: '$count sekúnd',
      few: '$count sekúnd',
      one: '$count sekunda',
    );
    return '$_temp0';
  }

  @override
  String andSaveNbPremoveLines(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'a uložiť $count variantov predťahu',
      many: 'a uložiť $count variantov predťahu',
      few: 'a uložiť $count varianty predťahu',
      one: 'a uložiť $count variant predťahu',
    );
    return '$_temp0';
  }

  @override
  String get stormMoveToStart => 'Odštartujte potiahnutím';

  @override
  String get stormYouPlayTheWhitePiecesInAllPuzzles => 'Vo všetkých úlohách ste biely';

  @override
  String get stormYouPlayTheBlackPiecesInAllPuzzles => 'Vo všetkých úlohách ste čierny';

  @override
  String get stormPuzzlesSolved => 'vyriešených úloh';

  @override
  String get stormNewDailyHighscore => 'Nové najvyššie skóre dňa!';

  @override
  String get stormNewWeeklyHighscore => 'Nové najvyššie skóre týždňa!';

  @override
  String get stormNewMonthlyHighscore => 'Nové najvyššie skóre mesiaca!';

  @override
  String get stormNewAllTimeHighscore => 'Nové celkové najvyššie skóre!';

  @override
  String stormPreviousHighscoreWasX(String param) {
    return 'Predchádzajúce najvyššie skóre bolo $param';
  }

  @override
  String get stormPlayAgain => 'Hrať znova';

  @override
  String stormHighscoreX(String param) {
    return 'Najvyššie skóre: $param';
  }

  @override
  String get stormScore => 'Skóre';

  @override
  String get stormMoves => 'Počet ťahov';

  @override
  String get stormAccuracy => 'Úspešnosť';

  @override
  String get stormCombo => 'Kombo';

  @override
  String get stormTime => 'Čas';

  @override
  String get stormTimePerMove => 'Čas na ťah';

  @override
  String get stormHighestSolved => 'Najťažšia vyriešená úloha';

  @override
  String get stormPuzzlesPlayed => 'Riešené úlohy';

  @override
  String get stormNewRun => 'Nový pokus (kláves. skratka: Medzerník)';

  @override
  String get stormEndRun => 'Ukončiť pokus (kláves. skratka: Enter)';

  @override
  String get stormHighscores => 'Najvyššie skóre';

  @override
  String get stormViewBestRuns => 'Prezrieť najlepšie pokusy';

  @override
  String get stormBestRunOfDay => 'Najlepší pokus dňa';

  @override
  String get stormRuns => 'Pokusy';

  @override
  String get stormGetReady => 'Pripravte sa!';

  @override
  String get stormWaitingForMorePlayers => 'Čaká sa kým sa pripojí viac hráčov...';

  @override
  String get stormRaceComplete => 'Preteky ukončené!';

  @override
  String get stormSpectating => 'Divák';

  @override
  String get stormJoinTheRace => 'Zapojte sa do pretekov!';

  @override
  String get stormStartTheRace => 'Odštartovať preteky';

  @override
  String stormYourRankX(String param) {
    return 'Vaše miesto: $param';
  }

  @override
  String get stormWaitForRematch => 'Čakať na odvetu';

  @override
  String get stormNextRace => 'Ďalšie preteky';

  @override
  String get stormJoinRematch => 'Zapojiť sa do odvety';

  @override
  String get stormWaitingToStart => 'Čaká sa na štart';

  @override
  String get stormCreateNewGame => 'Vytvoriť nové preteky';

  @override
  String get stormJoinPublicRace => 'Zapojiť sa do verejných pretekov';

  @override
  String get stormRaceYourFriends => 'Pretekajte sa s priateľmi';

  @override
  String get stormSkip => 'preskočiť';

  @override
  String get stormSkipHelp => 'Počas každých pretekov môžete raz vynechať ťah:';

  @override
  String get stormSkipExplanation => 'Vynechajte tento ťah aby ste neprišli o kombo! Je možné len raz počas pretekov.';

  @override
  String get stormFailedPuzzles => 'Neúspešne riešené úlohy';

  @override
  String get stormSlowPuzzles => 'Pomaly riešené úlohy';

  @override
  String get stormSkippedPuzzle => 'Preskočené úlohy';

  @override
  String get stormThisWeek => 'Tento týždeň';

  @override
  String get stormThisMonth => 'Tento mesiac';

  @override
  String get stormAllTime => 'Celkovo';

  @override
  String get stormClickToReload => 'Kliknite pre opätovné načítanie';

  @override
  String get stormThisRunHasExpired => 'Tento pokus vypršal!';

  @override
  String get stormThisRunWasOpenedInAnotherTab => 'Tento pokus ste otvorili v inej záložke!';

  @override
  String stormXRuns(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count pokusov',
      many: '$count pokusov',
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
      other: 'Odohraných $count pokusov $param2',
      many: 'Odohraných $count pokusov $param2',
      few: 'Obohrané $count pokusy $param2',
      one: 'Odohraný jeden pokus $param2',
    );
    return '$_temp0';
  }

  @override
  String get streamerLichessStreamers => 'Lichess streameri';

  @override
  String get studyShareAndExport => 'Zdielať & export';

  @override
  String get studyStart => 'Štart';
}
