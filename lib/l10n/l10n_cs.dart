import 'package:intl/intl.dart' as intl;

import 'l10n.dart';

/// The translations for Czech (`cs`).
class AppLocalizationsCs extends AppLocalizations {
  AppLocalizationsCs([String locale = 'cs']) : super(locale);

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
  String get broadcastBroadcasts => 'Přenosy';

  @override
  String get broadcastLiveBroadcasts => 'Živé přenosy turnajů';

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
  String get challengeDeclineLater => 'Teď nemohu, požádejte prosím později.';

  @override
  String get challengeDeclineTooFast => 'Tato časová kontrola je na mně příliš rychlá, vyzvi mně prosím s pomalejší.';

  @override
  String get challengeDeclineTooSlow => 'Vyzvi mne prosím k delší partii, tato časová kontrola je na mne moc rychlá.';

  @override
  String get challengeDeclineTimeControl => 'V tuto chvíli nepřijímám výzvy s touto časovou kontrolou.';

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
  String get perfStatNotEnoughRatedGames => 'Nebyl odebrán dostatečný počet hodnocených her pro odhad spolehlivého ratingu.';

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
  String get preferencesShowFlairs => 'Zobrazit hráčův rating';

  @override
  String get preferencesExplainShowPlayerRatings => 'Toto umožňuje skrýt rating z webových stránek, což pomůže soustředit se pouze na šachy. Hodnocené hry budou mít stále dopad na Váš rating.';

  @override
  String get preferencesDisplayBoardResizeHandle => 'Zobrazit tlačítko pro změnu velikosti šachovnice';

  @override
  String get preferencesOnlyOnInitialPosition => 'Jen v základním postavení';

  @override
  String get preferencesInGameOnly => 'Pouze u partie';

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
  String get preferencesPremovesPlayingDuringOpponentTurn => 'Předtahy (hraní během protivníkova tahu)';

  @override
  String get preferencesTakebacksWithOpponentApproval => 'Vrácení tahu (s protihráčovým souhlasem)';

  @override
  String get preferencesInCasualGamesOnly => 'Pouze v hrách \"jen tak\"';

  @override
  String get preferencesPromoteToQueenAutomatically => 'Automaticky vyměnit za dámu';

  @override
  String get preferencesExplainPromoteToQueenAutomatically => 'Podržte klávesu <ctrl> při proměně figury pro dočasné pozastavení možnosti automatické proměny';

  @override
  String get preferencesWhenPremoving => 'Při předtahu';

  @override
  String get preferencesClaimDrawOnThreefoldRepetitionAutomatically => 'Automaticky vyžádat remízu při trojím opakování pozice';

  @override
  String get preferencesWhenTimeRemainingLessThanThirtySeconds => 'Když zbývající čas < 30 sekund';

  @override
  String get preferencesMoveConfirmation => 'Potvrzení tahu';

  @override
  String get preferencesExplainCanThenBeTemporarilyDisabled => 'Může být zakázáno během hry v menu šachovnice';

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
  String get preferencesSayGgWpAfterLosingOrDrawing => 'Řekněte \"Good game, well played\" (překlad: \"Dobrá hra, pěkně zahráno\") po porážce nebo remíze';

  @override
  String get preferencesYourPreferencesHaveBeenSaved => 'Vaše nastavení bylo uloženo.';

  @override
  String get preferencesScrollOnTheBoardToReplayMoves => 'Rolováním na šachovnici přehrát tahy';

  @override
  String get preferencesCorrespondenceEmailNotification => 'Denní e-mailové oznámení se seznamem vašich korespondenčních her';

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
  String get puzzlePuzzles => 'Úlohy';

  @override
  String get puzzlePuzzleThemes => 'Motivy úloh';

  @override
  String get puzzleRecommended => 'Doporučené';

  @override
  String get puzzlePhases => 'Fáze';

  @override
  String get puzzleMotifs => 'Techniky';

  @override
  String get puzzleAdvanced => 'Pokročilé';

  @override
  String get puzzleLengths => 'Délka';

  @override
  String get puzzleMates => 'Maty';

  @override
  String get puzzleGoals => 'Cíle';

  @override
  String get puzzleOrigin => 'Původ';

  @override
  String get puzzleSpecialMoves => 'Speciální tahy';

  @override
  String get puzzleDidYouLikeThisPuzzle => 'Líbila se vám tato hádanka?';

  @override
  String get puzzleVoteToLoadNextOne => 'Hlasujte pro načtení dalšího!';

  @override
  String get puzzleUpVote => 'Dobrá úloha';

  @override
  String get puzzleDownVote => 'Špatná úloha';

  @override
  String get puzzleYourPuzzleRatingWillNotChange => 'Vaše hodnocení hádanky se nezmění. Hádanky nejsou soutěží. Hodnocení pomáhá vybírat nejlepší hádanky pro vaši aktuální dovednost.';

  @override
  String get puzzleFindTheBestMoveForWhite => 'Najděte nejlepší tah za bílého.';

  @override
  String get puzzleFindTheBestMoveForBlack => 'Najděte nejlepší tah za černého.';

  @override
  String get puzzleToGetPersonalizedPuzzles => 'Personalizované úlohy:';

  @override
  String puzzlePuzzleId(String param) {
    return 'Úloha $param';
  }

  @override
  String get puzzlePuzzleOfTheDay => 'Úloha dne';

  @override
  String get puzzleDailyPuzzle => 'Denní úloha';

  @override
  String get puzzleClickToSolve => 'Klikněte pro vyřešení';

  @override
  String get puzzleGoodMove => 'Dobrý tah';

  @override
  String get puzzleBestMove => 'Nejlepší tah!';

  @override
  String get puzzleKeepGoing => 'Pokračujte…';

  @override
  String get puzzlePuzzleSuccess => 'Úspěch!';

  @override
  String get puzzlePuzzleComplete => 'Úloha dokončena!';

  @override
  String get puzzleByOpenings => 'Podle zahájení';

  @override
  String get puzzlePuzzlesByOpenings => 'Úlohy podle zahájení';

  @override
  String get puzzleOpeningsYouPlayedTheMost => 'Zahájení, které jste hráli nejvíce v hodnocených hrách';

  @override
  String get puzzleUseFindInPage => 'Použijte \"Hledání na stránce\" v menu prohlížeče a najděte svoje oblíbené zahájení!';

  @override
  String get puzzleUseCtrlF => 'Použijte ctrl+f pro vyhledání vašeho oblíbeného zahájení!';

  @override
  String get puzzleNotTheMove => 'To není správný tah!';

  @override
  String get puzzleTrySomethingElse => 'Zkuste něco jiného.';

  @override
  String puzzleRatingX(String param) {
    return 'Rating: $param';
  }

  @override
  String get puzzleHidden => 'skryté';

  @override
  String puzzleFromGameLink(String param) {
    return 'Z partie $param';
  }

  @override
  String get puzzleContinueTraining => 'Pokračovat v tréninku';

  @override
  String get puzzleDifficultyLevel => 'Obtížnost';

  @override
  String get puzzleNormal => 'Střední';

  @override
  String get puzzleEasier => 'Snadné';

  @override
  String get puzzleEasiest => 'Nejjednodušší';

  @override
  String get puzzleHarder => 'Těžší';

  @override
  String get puzzleHardest => 'Nejtěžší';

  @override
  String get puzzleExample => 'Příklad';

  @override
  String get puzzleAddAnotherTheme => 'Přidat další téma';

  @override
  String get puzzleNextPuzzle => 'Další úloha';

  @override
  String get puzzleJumpToNextPuzzleImmediately => 'Okamžitě přejít na další úlohu';

  @override
  String get puzzlePuzzleDashboard => 'Shrnutí Vašeho řešení úloh';

  @override
  String get puzzleImprovementAreas => 'Zlepšení pozice';

  @override
  String get puzzleStrengths => 'Silné stránky';

  @override
  String get puzzleHistory => 'Historie řešení úloh';

  @override
  String get puzzleSolved => 'vyřešeno';

  @override
  String get puzzleFailed => 'nezdařilo se';

  @override
  String get puzzleStreakDescription => 'Vyřešte postupně těžší hádanky a vytvořte vítěznou sérii. Není tu žádný limit, takže si dejte na na čas. Jeden špatný tah a je to, hra skončí! Můžete ale přeskočit jeden tah za běh.';

  @override
  String puzzleYourStreakX(String param) {
    return 'Vaše série: $param';
  }

  @override
  String get puzzleStreakSkipExplanation => 'Přeskočit tento krok pro zachování své série! Funguje pouze jednou za běh.';

  @override
  String get puzzleContinueTheStreak => 'Pokračovat v sérii';

  @override
  String get puzzleNewStreak => 'Nová série';

  @override
  String get puzzleFromMyGames => 'Z mých partií';

  @override
  String get puzzleLookupOfPlayer => 'Vyhledat úlohy z her hráče';

  @override
  String puzzleFromXGames(String param) {
    return 'Úlohy z her hráče $param';
  }

  @override
  String get puzzleSearchPuzzles => 'Hledat hádanky';

  @override
  String get puzzleFromMyGamesNone => 'V databázi nemáte žádné úlohy, ale Lichess vás stále velmi miluje.\nHrajte rapid a klasické hry ke zvýšení šance na přidání vlastní úlohy!';

  @override
  String puzzleFromXGamesFound(String param1, String param2) {
    return '$param1 úloh nalezeno v $param2 partiích';
  }

  @override
  String get puzzlePuzzleDashboardDescription => 'Trénujte, analyzujte, zlepšujte';

  @override
  String puzzlePercentSolved(String param) {
    return '$param vyřešeno';
  }

  @override
  String get puzzleNoPuzzlesToShow => 'Nic k zobrazení, jděte nejdříve zkusit nějaké úlohy!';

  @override
  String get puzzleImprovementAreasDescription => 'Tyto procvičujte pro zlepšení!';

  @override
  String get puzzleStrengthDescription => 'V těchto tématech se vám daří nejvíc';

  @override
  String puzzlePlayedXTimes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Hráno ${count}krát',
      many: 'Hráno ${count}krát',
      few: 'Hráno ${count}krát',
      one: 'Hráno ${count}krát',
    );
    return '$_temp0';
  }

  @override
  String puzzleNbPointsBelowYourPuzzleRating(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count bodů pod vaším ratingem',
      many: '$count bodů pod vaším ratingem',
      few: '$count body pod vaším ratingem',
      one: 'Jeden bod pod vaším ratingem',
    );
    return '$_temp0';
  }

  @override
  String puzzleNbPointsAboveYourPuzzleRating(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count bodů nad vaším ratingem',
      many: '$count bodů nad vaším ratingem',
      few: '$count body nad vaším ratingem',
      one: 'Jeden bod nad vaším ratingem',
    );
    return '$_temp0';
  }

  @override
  String puzzleNbPlayed(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count zahráno',
      many: '$count zahráno',
      few: '$count zahrány',
      one: '$count zahána',
    );
    return '$_temp0';
  }

  @override
  String puzzleNbToReplay(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count k opakování',
      many: '$count k opakování',
      few: '$count k opakování',
      one: '$count k opakování',
    );
    return '$_temp0';
  }

  @override
  String get puzzleThemeAdvancedPawn => 'Postouplý pěšec';

  @override
  String get puzzleThemeAdvancedPawnDescription => 'Jeden z Vašich pěšců je hluboko v poli protihráče, a možná hrozí proměnou.';

  @override
  String get puzzleThemeAdvantage => 'Výhoda';

  @override
  String get puzzleThemeAdvantageDescription => 'Využijte své šance získat rozhodující výhodu. (200cp ≤ eval ≤ 600cp)';

  @override
  String get puzzleThemeAnastasiaMate => 'Anastáziin mat';

  @override
  String get puzzleThemeAnastasiaMateDescription => 'Jezdec a věž nebo královna se spojí, aby obklíčili protihráčova krále mezi krajem šachovnice a přátelskou figurou.';

  @override
  String get puzzleThemeArabianMate => 'Arabský mat';

  @override
  String get puzzleThemeArabianMateDescription => 'Jezdec a věž dají mat soupeřovu králi na kraji šachovnice.';

  @override
  String get puzzleThemeAttackingF2F7 => 'Útok na f2 či f7';

  @override
  String get puzzleThemeAttackingF2F7Description => 'Útok zaměřený na pěšce f2, resp. f7, například jako při tzv. Šustrmatu (Ovčáckém matu).';

  @override
  String get puzzleThemeAttraction => 'Zavlečení';

  @override
  String get puzzleThemeAttractionDescription => 'Výměna nebo obětování figur, která podpoří nebo vynutí figuru protihráče postoupit na pole, jenž umožňuje další taktický postup.';

  @override
  String get puzzleThemeBackRankMate => 'Mat na poslední řadě';

  @override
  String get puzzleThemeBackRankMateDescription => 'Mat krále na poslední řadě, kde je uvězněn vlastními figurami.';

  @override
  String get puzzleThemeBishopEndgame => 'Střelcové koncovky';

  @override
  String get puzzleThemeBishopEndgameDescription => 'Koncovka jen se střelci a pěšci.';

  @override
  String get puzzleThemeBodenMate => 'Bodenův mat';

  @override
  String get puzzleThemeBodenMateDescription => 'Dva útočící střelci na různých diagonálách dají mat soupeřovu králi, jež je zablokován svými figurami.';

  @override
  String get puzzleThemeCastling => 'Rošáda';

  @override
  String get puzzleThemeCastlingDescription => 'Schovejte krále do bezpečí a vyviňte věž.';

  @override
  String get puzzleThemeCapturingDefender => 'Odstranění obránce';

  @override
  String get puzzleThemeCapturingDefenderDescription => 'Sebrání figury, která brání jinou figuru, a poté dalším tahem dobereme tuto nechráněnou figuru.';

  @override
  String get puzzleThemeCrushing => 'Potrestání';

  @override
  String get puzzleThemeCrushingDescription => 'Odhalte chybu soupeře a získejte drtivou výhodu. (eval ≥ 600cp)';

  @override
  String get puzzleThemeDoubleBishopMate => 'Mat dvěma střelci';

  @override
  String get puzzleThemeDoubleBishopMateDescription => 'Dva útočící střelci na různých diagonálách dají mat soupeřovu králi.';

  @override
  String get puzzleThemeDovetailMate => 'Coziův mat';

  @override
  String get puzzleThemeDovetailMateDescription => 'Dáma matuje sousedícího krále, jehož jediná dvě ústupová pole blokují přátelské figurky.';

  @override
  String get puzzleThemeEquality => 'Vyrovnání pozice';

  @override
  String get puzzleThemeEqualityDescription => 'Zremízování či zisk vyrovnané pozice z dříve prohrané pozice. (eval ≤ 200cp)';

  @override
  String get puzzleThemeKingsideAttack => 'Útok na královském křídle';

  @override
  String get puzzleThemeKingsideAttackDescription => 'Útok na soupeřova krále poté, co udělal malou rošádu.';

  @override
  String get puzzleThemeClearance => 'Uvolnění';

  @override
  String get puzzleThemeClearanceDescription => 'Tah, často s tempem, který uvolní pole, sloupec nebo diagonálu pro následný taktický úder.';

  @override
  String get puzzleThemeDefensiveMove => 'Obranný tah';

  @override
  String get puzzleThemeDefensiveMoveDescription => 'Přesný tah nebo pořadí tahů, které jsou potřebné k tomu, aby nedošlo ke ztrátě materiálu nebo jiné výhody.';

  @override
  String get puzzleThemeDeflection => 'Zavlečení';

  @override
  String get puzzleThemeDeflectionDescription => 'Tah, který odvádí soupeřovu figuru od jejích jiných povinností, jako například bránění klíčového pole. Občas nazýváno také jako \"přetížení\".';

  @override
  String get puzzleThemeDiscoveredAttack => 'Odtažný útok';

  @override
  String get puzzleThemeDiscoveredAttackDescription => 'Tah figurou (například jezdcem) z cesty jiné, dalekonosné, které blokovala působnost (například věži).';

  @override
  String get puzzleThemeDoubleCheck => 'Dvojný šach';

  @override
  String get puzzleThemeDoubleCheckDescription => 'Šach dvěma figurami zároveň, často důsledkem odtahu. Obě figury dávají šach soupeřovu králi.';

  @override
  String get puzzleThemeEndgame => 'Koncovka';

  @override
  String get puzzleThemeEndgameDescription => 'Taktický obrat během poslední fáze hry.';

  @override
  String get puzzleThemeEnPassantDescription => 'Taktický prvek obsahující braní mimochodem, v rámci kterého může pěšec vzít pěšce soupeřova, který prošel přes ohrožené pole pomocí tahu o dvě pole z druhé řady.';

  @override
  String get puzzleThemeExposedKing => 'Ohrožený král';

  @override
  String get puzzleThemeExposedKingDescription => 'Taktika zahrnují krále s pár obránci okolo něj, obvykle vedoucí k matu.';

  @override
  String get puzzleThemeFork => 'Vidlička';

  @override
  String get puzzleThemeForkDescription => 'Tah, kterým tažená figura útočí na dvě protivníkovy figury najednou.';

  @override
  String get puzzleThemeHangingPiece => 'Visící figura';

  @override
  String get puzzleThemeHangingPieceDescription => 'Taktika zahrnující nechráněnou nebo nedostatečně chráněnou a zdarma získatelnou protivníkovu figuru.';

  @override
  String get puzzleThemeHookMate => 'Hákový mat';

  @override
  String get puzzleThemeHookMateDescription => 'Mat věží, jezdcem a pěšcem spolu s pěšcem nepřátelským, který blokuje ústup králi.';

  @override
  String get puzzleThemeInterference => 'Překrytí';

  @override
  String get puzzleThemeInterferenceDescription => 'Tah figurou na pole mezi dvě soupeřovy figury, aby jedna z nich byla nechráněná, například tah jezdcem na chráněné pole mezi dvě soupeřovy věže.';

  @override
  String get puzzleThemeIntermezzo => 'Intermezzo';

  @override
  String get puzzleThemeIntermezzoDescription => 'Namísto zahrání očekávaného tahu je nejdřív zahrán tah představující bezprostřední hrozbu (např. šach či napadení), na který musí soupeř odpovědět. Tomuto motivu se také říká Zwischenzug.';

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
  String get puzzleThemeMasterVsMasterDescription => 'Úlohy z partií šachistů s oficiálním titulem.';

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
  String get puzzleThemePinDescription => 'Taktika zahrnující vazby, kde se figura nemůže pohnout bez odhalení útoku na figuru vyšší hodnoty.';

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
  String get puzzleThemeQueenRookEndgameDescription => 'Konec hry jen s královnami, věžemi a pěšci.';

  @override
  String get puzzleThemeQueensideAttack => 'Útok na dámském křídle';

  @override
  String get puzzleThemeQueensideAttackDescription => 'Útok na soupeřova krále poté, co udělal dlouhou rošádu.';

  @override
  String get puzzleThemeQuietMove => 'Tichý tah';

  @override
  String get puzzleThemeQuietMoveDescription => 'Tah, který není ani šach ani braní, ale připraví nevyhnutelnou hrozbu na další tah.';

  @override
  String get puzzleThemeRookEndgame => 'Věžové koncovky';

  @override
  String get puzzleThemeRookEndgameDescription => 'Koncovka jen s věžemi a pěšci.';

  @override
  String get puzzleThemeSacrifice => 'Oběť';

  @override
  String get puzzleThemeSacrificeDescription => 'Taktika zahrnující krátkodobé vzdání materiálu, s cílem získat opět výhodu po vynucené sekvenci tahů.';

  @override
  String get puzzleThemeShort => 'Krátká úloha';

  @override
  String get puzzleThemeShortDescription => 'Dva tahy do výhry.';

  @override
  String get puzzleThemeSkewer => 'Napíchnutí';

  @override
  String get puzzleThemeSkewerDescription => 'Motiv zahrnující útok na figuru vyšší hodnoty, která útoku uhne, ale dovolí tak útok nebo sebrání figury nižší hodnoty za ní, opak vazby.';

  @override
  String get puzzleThemeSmotheredMate => 'Dušený mat';

  @override
  String get puzzleThemeSmotheredMateDescription => 'Mat jezdcem, během kterého nepřátelský král nemůže utéct, protože je blokován (dušen) vlastními figurami.';

  @override
  String get puzzleThemeSuperGM => 'Úlohy Super GM';

  @override
  String get puzzleThemeSuperGMDescription => 'Hádanky z her hraných nejlepšími hráči na světě.';

  @override
  String get puzzleThemeTrappedPiece => 'Chycená figura';

  @override
  String get puzzleThemeTrappedPieceDescription => 'Figura nemůže ustoupit, protože má omezenou působnost.';

  @override
  String get puzzleThemeUnderPromotion => 'Minoritní proměna';

  @override
  String get puzzleThemeUnderPromotionDescription => 'Proměna na jezdce, střelce či věž, jelikož proměna na dámu je v dané pozici špatná.';

  @override
  String get puzzleThemeVeryLong => 'Velmi dlouhá úloha';

  @override
  String get puzzleThemeVeryLongDescription => 'Čtyři či více tahů k vyhrávající pozici.';

  @override
  String get puzzleThemeXRayAttack => 'Rentgenový útok';

  @override
  String get puzzleThemeXRayAttackDescription => 'Figura útočí nebo chrání pole skrze nepřátelskou figuru.';

  @override
  String get puzzleThemeZugzwang => 'Zugzwang';

  @override
  String get puzzleThemeZugzwangDescription => 'Soupeř musí zahrát jakýkoliv tah, přičemž všechny zhoršují jeho pozici a zlepšují naší pozici.';

  @override
  String get puzzleThemeHealthyMix => 'Mix úloh';

  @override
  String get puzzleThemeHealthyMixDescription => 'Troška od všeho. Nevíte co čekat, čili jste na vše připraveni! Jako v normální partii.';

  @override
  String get puzzleThemePlayerGames => 'Z vašich her';

  @override
  String get puzzleThemePlayerGamesDescription => 'Vyhledejte úlohy vygenerované z vašich her, nebo z her jiného hráče.';

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
  String get settingsClosingIsDefinitive => 'Zrušení účtu je trvalé. Tato akce je nevratná. Jste si jisti, že chcete svůj účet uzavřít?';

  @override
  String get settingsCantOpenSimilarAccount => 'Nebudete moci založit nový účet se stejným jménem, a to ani když se bude lišit velikost písmen.';

  @override
  String get settingsChangedMindDoNotCloseAccount => 'Změnil jsem názor, nechci zrušit svůj účet';

  @override
  String get settingsCloseAccountExplanation => 'Jste si jisti, že chcete uzavřít svůj účet? Uzavření účtu je trvalé rozhodnutí. Již NIKDY SE ZNOVU nebudete moci přihlásit.';

  @override
  String get settingsThisAccountIsClosed => 'Tento účet je zrušen.';

  @override
  String get playWithAFriend => 'Vyzvi kamaráda';

  @override
  String get playWithTheMachine => 'Hrát proti počítači';

  @override
  String get toInviteSomeoneToPlayGiveThisUrl => 'Pro pozvání někoho ke hře využijte tento odkaz';

  @override
  String get gameOver => 'Konec hry';

  @override
  String get waitingForOpponent => 'Čekání na soupeře';

  @override
  String get orLetYourOpponentScanQrCode => 'Nebo nechte soupeře naskenovat tento QR kód';

  @override
  String get waiting => 'Čeká se';

  @override
  String get yourTurn => 'Jste na tahu';

  @override
  String aiNameLevelAiLevel(String param1, String param2) {
    return 'AI $param1 úrovně $param2';
  }

  @override
  String get level => 'Úroveň';

  @override
  String get strength => 'Obtížnost';

  @override
  String get toggleTheChat => 'Zapnout/vypnout chat';

  @override
  String get chat => 'Chat';

  @override
  String get resign => 'Vzdát se';

  @override
  String get checkmate => 'Šach mat';

  @override
  String get stalemate => 'Pat';

  @override
  String get white => 'Bílý';

  @override
  String get black => 'Černý';

  @override
  String get asWhite => 'jako bílá';

  @override
  String get asBlack => 'jako černá';

  @override
  String get randomColor => 'Náhodná barva';

  @override
  String get createAGame => 'Vytvořit hru';

  @override
  String get whiteIsVictorious => 'Vyhrál bílý';

  @override
  String get blackIsVictorious => 'Vyhrál černý';

  @override
  String get youPlayTheWhitePieces => 'Hrajete bílými figurami';

  @override
  String get youPlayTheBlackPieces => 'Hrajete černými figurami';

  @override
  String get itsYourTurn => 'Jste na tahu!';

  @override
  String get cheatDetected => 'Podvádění detekováno';

  @override
  String get kingInTheCenter => 'Král uprostřed (King of the hill)';

  @override
  String get threeChecks => 'Třikrát šach';

  @override
  String get raceFinished => 'Závod skončil';

  @override
  String get variantEnding => 'Konec varianty';

  @override
  String get newOpponent => 'Nový protihráč';

  @override
  String get yourOpponentWantsToPlayANewGameWithYou => 'Váš soupeř s Vámi chce hrát další partii';

  @override
  String get joinTheGame => 'Připojit se ke hře';

  @override
  String get whitePlays => 'Bílý na tahu';

  @override
  String get blackPlays => 'Černý na tahu';

  @override
  String get opponentLeftChoices => 'Soupeř opustil hru. Můžete vynutit remízu nebo jeho vzdání partie či na něj počkat.';

  @override
  String get forceResignation => 'Vynutit vzdání partie';

  @override
  String get forceDraw => 'Vynutit remízu';

  @override
  String get talkInChat => 'Pro povídání v chatu pište sem';

  @override
  String get theFirstPersonToComeOnThisUrlWillPlayWithYou => 'První kdo přijde pomocí tohoto odkazu, bude s Vámi hrát';

  @override
  String get whiteResigned => 'Bílý se vzdal';

  @override
  String get blackResigned => 'Černý se vzdal';

  @override
  String get whiteLeftTheGame => 'Bílý opustil hru';

  @override
  String get blackLeftTheGame => 'Černý opustil hru';

  @override
  String get whiteDidntMove => 'Bílý netáhl';

  @override
  String get blackDidntMove => 'Černý netáhl';

  @override
  String get requestAComputerAnalysis => 'Vyžádat počítačovou analýzu';

  @override
  String get computerAnalysis => 'Počítačová analýza';

  @override
  String get computerAnalysisAvailable => 'Analýza počítače k dispozici';

  @override
  String get computerAnalysisDisabled => 'Analýza počítačem je vypnutá';

  @override
  String get analysis => 'Analýza';

  @override
  String depthX(String param) {
    return 'Hloubka $param';
  }

  @override
  String get usingServerAnalysis => 'Používání analýzy serveru';

  @override
  String get loadingEngine => 'Načítání AI engine...';

  @override
  String get calculatingMoves => 'Výpočet tahů...';

  @override
  String get engineFailed => 'Chyba při načítání enginu';

  @override
  String get cloudAnalysis => 'Cloudová analýza';

  @override
  String get goDeeper => 'Hlouběji';

  @override
  String get showThreat => 'Zobrazit hrozbu';

  @override
  String get inLocalBrowser => 'v lokálním prohlížeči';

  @override
  String get toggleLocalEvaluation => 'Lokální analýza';

  @override
  String get promoteVariation => 'Povýšit variantu';

  @override
  String get makeMainLine => 'Povýšit na hlavní variantu';

  @override
  String get deleteFromHere => 'Smazat odsud';

  @override
  String get collapseVariations => 'Collapse variations';

  @override
  String get expandVariations => 'Expand variations';

  @override
  String get forceVariation => 'Zobrazit jako variantu';

  @override
  String get copyVariationPgn => 'Zkopírovat PGN varianty';

  @override
  String get move => 'Tah';

  @override
  String get variantLoss => 'Prohra';

  @override
  String get variantWin => 'Výhra';

  @override
  String get insufficientMaterial => 'Nedostatek materiálu';

  @override
  String get pawnMove => 'Tah pěšcem';

  @override
  String get capture => 'Sebrání';

  @override
  String get close => 'Zavřít';

  @override
  String get winning => 'Vyhrává';

  @override
  String get losing => 'Prohrává';

  @override
  String get drawn => 'Remízuje';

  @override
  String get unknown => 'Neznámé';

  @override
  String get database => 'Databáze';

  @override
  String get whiteDrawBlack => 'Bílý / Remíza / Černý';

  @override
  String averageRatingX(String param) {
    return 'Průměrný rating: $param';
  }

  @override
  String get recentGames => 'Nedávné hry';

  @override
  String get topGames => 'Top hry';

  @override
  String masterDbExplanation(String param1, String param2, String param3) {
    return 'Dva miliony her hráčů Ela FIDE $param1+ od let $param2 do $param3';
  }

  @override
  String get dtzWithRounding => 'DTZ50\'\' s zaokrouhlením na základě počtu půltahů do dalšího braní nebo tahu pěšcem';

  @override
  String get noGameFound => 'Žádná hra nenalezena';

  @override
  String get maxDepthReached => 'Maximální hloubka dosažena!';

  @override
  String get maybeIncludeMoreGamesFromThePreferencesMenu => 'Možná zkuste vybrat více her z menu preferencí?';

  @override
  String get openings => 'Zahájení';

  @override
  String get openingExplorer => 'Průzkumník zahájení';

  @override
  String get openingEndgameExplorer => 'Průzkumník zahájení/koncovek';

  @override
  String xOpeningExplorer(String param) {
    return '$param průzkumník zahájení';
  }

  @override
  String get playFirstOpeningEndgameExplorerMove => 'Hrát první tah průzkumníka zahájení/koncovek';

  @override
  String get winPreventedBy50MoveRule => 'Výhra zabránění 50tahového pravidla';

  @override
  String get lossSavedBy50MoveRule => 'Prohra zachráněna 50tahovým pravidlem';

  @override
  String get winOr50MovesByPriorMistake => 'Výhra nebo 50 tahů po předchozí chybě';

  @override
  String get lossOr50MovesByPriorMistake => 'Prohra nebo 50 tahů po předchozí chybě';

  @override
  String get unknownDueToRounding => 'Výhra/prohra zaručena pouze v případě, že byla dodržena doporučená série tahů z tablebase od posledního braní nebo tahu pěšcem, vzhledem k možnému zaokrouhlení hodnot DTZ v tabulkách Syzygy.';

  @override
  String get allSet => 'Vše nastaveno!';

  @override
  String get importPgn => 'Vložit PGN';

  @override
  String get delete => 'Smazat';

  @override
  String get deleteThisImportedGame => 'Opravdu chcete smazat tuto nahranou hru?';

  @override
  String get replayMode => 'Mód přehrávání';

  @override
  String get realtimeReplay => 'Jako při hře';

  @override
  String get byCPL => 'Dle CPL';

  @override
  String get openStudy => 'Otevřít studii';

  @override
  String get enable => 'Povolit analýzu';

  @override
  String get bestMoveArrow => 'Šipka pro nejlepší tah';

  @override
  String get showVariationArrows => 'Zobrazit šipky variant';

  @override
  String get evaluationGauge => 'Měřítko hodnocení';

  @override
  String get multipleLines => 'Počet variant';

  @override
  String get cpus => 'Procesor(y)';

  @override
  String get memory => 'Paměť';

  @override
  String get infiniteAnalysis => 'Nekonečná analýza';

  @override
  String get removesTheDepthLimit => 'Zapne nekonečnou analýzu a odstraní omezení hloubky propočtu';

  @override
  String get engineManager => 'Správce enginu';

  @override
  String get blunder => 'Hrubá chyba';

  @override
  String get mistake => 'Chyba';

  @override
  String get inaccuracy => 'Nepřesnost';

  @override
  String get moveTimes => 'Čas na tah';

  @override
  String get flipBoard => 'Otočit šachovnici';

  @override
  String get threefoldRepetition => 'Trojí opakování pozice';

  @override
  String get claimADraw => 'Reklamovat remízu';

  @override
  String get offerDraw => 'Nabídnout remízu';

  @override
  String get draw => 'Remíza';

  @override
  String get drawByMutualAgreement => 'Remíza po vzájemné dohodě';

  @override
  String get fiftyMovesWithoutProgress => 'Padesát tahů bez progresu';

  @override
  String get currentGames => 'Právě probíhající partie';

  @override
  String get viewInFullSize => 'Zobrazit v plné velikosti';

  @override
  String get logOut => 'Odhlásit se';

  @override
  String get signIn => 'Přihlásit se';

  @override
  String get rememberMe => 'Zůstat přihlášen/a';

  @override
  String get youNeedAnAccountToDoThat => 'Pro následující akci je vyžadován účet';

  @override
  String get signUp => 'Registrace';

  @override
  String get computersAreNotAllowedToPlay => 'Počítačová asistence není během hraní povolena. Nepoužívejte během hraní šachové programy, databáze nebo nápovědu jiných hráčů.';

  @override
  String get games => 'Partie';

  @override
  String get forum => 'Fórum';

  @override
  String xPostedInForumY(String param1, String param2) {
    return '$param1 napsal do fóra $param2';
  }

  @override
  String get latestForumPosts => 'Poslední příspěvky';

  @override
  String get players => 'Hráči';

  @override
  String get friends => 'Přátelé';

  @override
  String get discussions => 'Konverzace';

  @override
  String get today => 'Dnes';

  @override
  String get yesterday => 'Včera';

  @override
  String get minutesPerSide => 'Minut pro každého hráče';

  @override
  String get variant => 'Varianta';

  @override
  String get variants => 'Varianty';

  @override
  String get timeControl => 'Tempo hry';

  @override
  String get realTime => 'Skutečný čas';

  @override
  String get correspondence => 'Korespondenčně';

  @override
  String get daysPerTurn => 'Dnů na tah';

  @override
  String get oneDay => 'Jeden den';

  @override
  String get time => 'Tempo';

  @override
  String get rating => 'Rating';

  @override
  String get ratingStats => 'Statistiky hodnocení';

  @override
  String get username => 'Uživatelské jméno';

  @override
  String get usernameOrEmail => 'Uživatelské jméno';

  @override
  String get changeUsername => 'Změnit uživatelské jméno';

  @override
  String get changeUsernameNotSame => 'Můžete změnit pouze velikost písmen. Např. z \"petrnovak\" na \"PetrNovak\".';

  @override
  String get changeUsernameDescription => 'Změňte své uživatelské jméno. To lze provést pouze jednou, a můžete změnit pouze velikost písmen.';

  @override
  String get signupUsernameHint => 'Zvolte si vhodné a nezávadné uživatelské jméno. Později ho nelze změnit a účty s nevhodnými uživatelskými jmény budou uzavřeny!';

  @override
  String get signupEmailHint => 'Bude použit pouze pro obnovení hesla.';

  @override
  String get password => 'Heslo';

  @override
  String get changePassword => 'Změnit heslo';

  @override
  String get changeEmail => 'Změnit email';

  @override
  String get email => 'Email';

  @override
  String get passwordReset => 'Změna hesla';

  @override
  String get forgotPassword => 'Zapomněl jste heslo?';

  @override
  String get error_weakPassword => 'Toto heslo je velmi běžné a je snadné ho uhodnout.';

  @override
  String get error_namePassword => 'Nepoužívejte prosím své uživatelské jméno jako heslo.';

  @override
  String get blankedPassword => 'Použili jste stejné heslo na jiném webu, který byl kompromitován. Abychom zajistili bezpečnost vašeho Lichess účtu, potřebujeme nastavit nové heslo. Děkujeme za pochopení.';

  @override
  String get youAreLeavingLichess => 'Odcházíte z Lichess';

  @override
  String get neverTypeYourPassword => 'Nikdy nezadávejte svoje Lichess heslo na jiném webu!';

  @override
  String proceedToX(String param) {
    return 'Pokračovat na $param';
  }

  @override
  String get passwordSuggestion => 'Nenastavujte heslo navržené někým jiným. Využijí toho k ukradení Vašeho účtu.';

  @override
  String get emailSuggestion => 'Nenastavujte e-mailovou adresu navrženou někým jiným. Použijí to ke krádeži Vašeho účtu.';

  @override
  String get emailConfirmHelp => 'Pomoc s potvrzovacím e-mailem';

  @override
  String get emailConfirmNotReceived => 'Neobdrželi jste potvrzovací e-mail po registraci?';

  @override
  String get whatSignupUsername => 'Jaké uživatelské jméno jste použili k registraci?';

  @override
  String usernameNotFound(String param) {
    return 'Nenašli jsme žádného uživatele s tímto jménem: $param.';
  }

  @override
  String get usernameCanBeUsedForNewAccount => 'Můžete použít toto jméno pro vytvoření nového účtu';

  @override
  String emailSent(String param) {
    return 'Poslali jsme e-mail na $param.';
  }

  @override
  String get emailCanTakeSomeTime => 'Může to chvíli trvat.';

  @override
  String get refreshInboxAfterFiveMinutes => 'Počkejte 5 minut a obnovte vaši e-mailovou schránku.';

  @override
  String get checkSpamFolder => 'Také zkontrolujte složku nevyžádané pošty. Pokud ano, označte mail jako vyžádaný.';

  @override
  String get emailForSignupHelp => 'Pokud všechno ostatní selže, pošlete nám tento e-mail:';

  @override
  String copyTextToEmail(String param) {
    return 'Zkopírujte a vložte výše uvedený text a pošlete jej na $param';
  }

  @override
  String get waitForSignupHelp => 'Brzy se k vám ozveme, abychom vám pomohli dokončit registraci.';

  @override
  String accountConfirmed(String param) {
    return 'Uživatel $param byl úspěšně potvrzen.';
  }

  @override
  String accountCanLogin(String param) {
    return 'Nyní se můžete přihlásit jako $param.';
  }

  @override
  String get accountConfirmationEmailNotNeeded => 'Nepotřebujete potvrzovací e-mail.';

  @override
  String accountClosed(String param) {
    return 'Účet $param je uzavřen.';
  }

  @override
  String accountRegisteredWithoutEmail(String param) {
    return 'Účet $param byl zaregistrován bez e-mailu.';
  }

  @override
  String get rank => 'Pořadí';

  @override
  String rankX(String param) {
    return 'Pořadí: $param';
  }

  @override
  String get gamesPlayed => 'Odehraných partií';

  @override
  String get cancel => 'Zrušit';

  @override
  String get whiteTimeOut => 'Bílému došel čas';

  @override
  String get blackTimeOut => 'Černému došel čas';

  @override
  String get drawOfferSent => 'Nabídka remízy byla odeslána';

  @override
  String get drawOfferAccepted => 'Soupeř remízu přijal';

  @override
  String get drawOfferCanceled => 'Nabídka remízy byla zrušena';

  @override
  String get whiteOffersDraw => 'Bílý nabízí remízu';

  @override
  String get blackOffersDraw => 'Černý nabízí remízu';

  @override
  String get whiteDeclinesDraw => 'Bílý odmítá remízu';

  @override
  String get blackDeclinesDraw => 'Černý odmítá remízu';

  @override
  String get yourOpponentOffersADraw => 'Soupeř nabízí remízu';

  @override
  String get accept => 'Přijmout';

  @override
  String get decline => 'Odmítnout';

  @override
  String get playingRightNow => 'Právě se hraje';

  @override
  String get eventInProgress => 'Právě se hraje';

  @override
  String get finished => 'Dokončeno';

  @override
  String get abortGame => 'Zrušit hru';

  @override
  String get gameAborted => 'Hra byla zrušena';

  @override
  String get standard => 'Standard';

  @override
  String get customPosition => 'Vlastní pozice';

  @override
  String get unlimited => 'Bez hodin';

  @override
  String get mode => 'Režim hry';

  @override
  String get casual => 'Jen tak';

  @override
  String get rated => 'Hodnocená';

  @override
  String get casualTournament => 'Jen tak';

  @override
  String get ratedTournament => 'Hodnocená';

  @override
  String get thisGameIsRated => 'Tato hra se započítává do hodnocení';

  @override
  String get rematch => 'Odveta';

  @override
  String get rematchOfferSent => 'Nabídka odvety byla odeslána';

  @override
  String get rematchOfferAccepted => 'Nabídka odvety byla přijata';

  @override
  String get rematchOfferCanceled => 'Nabídka odvety byla zrušena';

  @override
  String get rematchOfferDeclined => 'Nabídka odvety byla odmítnuta';

  @override
  String get cancelRematchOffer => 'Zrušit nabídku odvety';

  @override
  String get viewRematch => 'Sledovat odvetu';

  @override
  String get confirmMove => 'Potvrdit tah';

  @override
  String get play => 'Hrát';

  @override
  String get inbox => 'Doručené';

  @override
  String get chatRoom => 'Chat';

  @override
  String get loginToChat => 'Přihlaš se k chatování';

  @override
  String get youHaveBeenTimedOut => 'Byli jste odhlášeni.';

  @override
  String get spectatorRoom => 'Chat diváků';

  @override
  String get composeMessage => 'Napsat zprávu';

  @override
  String get subject => 'Předmět';

  @override
  String get send => 'Odeslat';

  @override
  String get incrementInSeconds => 'Bonus za tah (v sekundách)';

  @override
  String get freeOnlineChess => 'Šachy online zdarma';

  @override
  String get exportGames => 'Exportovat partie';

  @override
  String get ratingRange => 'Síla hráče';

  @override
  String get thisAccountViolatedTos => 'Tento účet porušil podmínky služeb Lichess';

  @override
  String get openingExplorerAndTablebase => 'Knihovna zahájení / tablebase koncovek';

  @override
  String get takeback => 'Vrátit tah';

  @override
  String get proposeATakeback => 'Navrhnout vrácení tahu';

  @override
  String get takebackPropositionSent => 'Návrh na vrácení tahu byl odeslán';

  @override
  String get takebackPropositionDeclined => 'Návrh na vrácení tahu byl odmítnut';

  @override
  String get takebackPropositionAccepted => 'Návrh na vrácení tahu byl přijat';

  @override
  String get takebackPropositionCanceled => 'Návrh na vrácení tahu byl zrušen';

  @override
  String get yourOpponentProposesATakeback => 'Soupeř navrhuje vrácení tahu';

  @override
  String get bookmarkThisGame => 'Přidat tuto partii do záložek';

  @override
  String get tournament => 'Turnaj';

  @override
  String get tournaments => 'Turnaje';

  @override
  String get tournamentPoints => 'Turnajové body';

  @override
  String get viewTournament => 'Zobrazit turnaj';

  @override
  String get backToTournament => 'Zpět k turnaji';

  @override
  String get noDrawBeforeSwissLimit => 'Nemůžete remízovat dříve, než se odehraje 30 tahů švýcarského turnaje.';

  @override
  String get thematic => 'Tématický';

  @override
  String yourPerfRatingIsProvisional(String param) {
    return 'Váš rating $param je provizorní';
  }

  @override
  String yourPerfRatingIsTooHigh(String param1, String param2) {
    return 'Váš $param1 rating ($param2) je příliš vysoký';
  }

  @override
  String yourTopWeeklyPerfRatingIsTooHigh(String param1, String param2) {
    return 'Váš týdenní rating ve variantě $param1 ($param2) je příliš vysoký';
  }

  @override
  String yourPerfRatingIsTooLow(String param1, String param2) {
    return 'Váš $param1 rating ($param2) je příliš nízký';
  }

  @override
  String ratedMoreThanInPerf(String param1, String param2) {
    return 'Rating ≥ $param1 v $param2 variantě';
  }

  @override
  String ratedLessThanInPerf(String param1, String param2) {
    return 'Rating ≤ $param1 v $param2 variantě';
  }

  @override
  String mustBeInTeam(String param) {
    return 'Musíte být členem týmu $param';
  }

  @override
  String youAreNotInTeam(String param) {
    return 'Nejste členem týmu $param';
  }

  @override
  String get backToGame => 'Zpět do hry';

  @override
  String get siteDescription => 'Šachy online zdarma. Hrajte šachy přímo ve Vašem prohlížeči, bez registrace, bez reklam, bez dalšího stahování. Hrajte proti počítači, kamarádům nebo náhodně vybraným soupeřům.';

  @override
  String xJoinedTeamY(String param1, String param2) {
    return '$param1 se přidal k týmu $param2';
  }

  @override
  String xCreatedTeamY(String param1, String param2) {
    return '$param1 založil tým $param2';
  }

  @override
  String get startedStreaming => 'začal streamovat';

  @override
  String xStartedStreaming(String param) {
    return '$param začal streamovat';
  }

  @override
  String get averageElo => 'Průměrný rating';

  @override
  String get location => 'Poloha';

  @override
  String get filterGames => 'Filtrovat partie';

  @override
  String get reset => 'Zrušit';

  @override
  String get apply => 'Použít';

  @override
  String get save => 'Uložit';

  @override
  String get leaderboard => 'Žebříček';

  @override
  String get screenshotCurrentPosition => 'Screenshot pozice';

  @override
  String get gameAsGIF => 'Uložit jako GIF';

  @override
  String get pasteTheFenStringHere => 'Zde vložte FEN řetězec';

  @override
  String get pasteThePgnStringHere => 'Zde vložte PGN řetězec';

  @override
  String get orUploadPgnFile => 'Nebo nahrajte soubor PGN';

  @override
  String get fromPosition => 'Z pozice';

  @override
  String get continueFromHere => 'Pokračovat zde';

  @override
  String get toStudy => 'Do studie';

  @override
  String get importGame => 'Importuj hru';

  @override
  String get importGameExplanation => 'Vložení partie ve formátu PGN Vám umožní přehrání partie, získáte počítačovou analýzu, chat ke hře a URL ke sdílení hry.';

  @override
  String get importGameCaveat => 'Varianty budou vymazány. Chcete-li je ponechat, importujte PGN prostřednictvím studie.';

  @override
  String get importGameDataPrivacyWarning => 'K této PGN má přístup kdokoli. Chcete-li hru naimportovat soukromě, použijte studii.';

  @override
  String get thisIsAChessCaptcha => 'Toto je šachové CAPTCHA.';

  @override
  String get clickOnTheBoardToMakeYourMove => 'Kliknutím na šachovnici zadejte váš tah a dokažte, že jste človek.';

  @override
  String get captcha_fail => 'Prosím vyřešte šachovou captcha.';

  @override
  String get notACheckmate => 'Toto není mat.';

  @override
  String get whiteCheckmatesInOneMove => 'Bílý dá prvním tahem mat';

  @override
  String get blackCheckmatesInOneMove => 'Černý dá prvním tahem mat';

  @override
  String get retry => 'Zkusit znovu';

  @override
  String get reconnecting => 'Připojování';

  @override
  String get noNetwork => 'Offline';

  @override
  String get favoriteOpponents => 'Oblíbení soupeři';

  @override
  String get follow => 'Sledovat';

  @override
  String get following => 'Sledován';

  @override
  String get unfollow => 'Přestat sledovat';

  @override
  String followX(String param) {
    return 'Sledovat $param';
  }

  @override
  String unfollowX(String param) {
    return 'Přestat sledovat $param';
  }

  @override
  String get block => 'Blokovat';

  @override
  String get blocked => 'Blokován';

  @override
  String get unblock => 'Odblokovat';

  @override
  String get followsYou => 'Vás sleduje';

  @override
  String xStartedFollowingY(String param1, String param2) {
    return '$param1 začal sledovat $param2';
  }

  @override
  String get more => 'Více';

  @override
  String get memberSince => 'Členem od';

  @override
  String lastSeenActive(String param) {
    return 'Poslední přihlášení $param';
  }

  @override
  String get player => 'Hráč';

  @override
  String get list => 'Seznam';

  @override
  String get graph => 'Graf';

  @override
  String get required => 'Vyžadováno.';

  @override
  String get openTournaments => 'Otevřené turnaje';

  @override
  String get duration => 'Trvání';

  @override
  String get winner => 'Vítěz';

  @override
  String get standing => 'Umístění';

  @override
  String get createANewTournament => 'Vytvořit turnaj';

  @override
  String get tournamentCalendar => 'Kalendář turnajů';

  @override
  String get conditionOfEntry => 'Podmínka vstupu:';

  @override
  String get advancedSettings => 'Pokročilá nastavení';

  @override
  String get safeTournamentName => 'Vyberte \"bezpečné\" jméno turnaje.';

  @override
  String get inappropriateNameWarning => 'Cokoli i mírně nevhodného může způsobit uzavření vašeho účtu.';

  @override
  String get emptyTournamentName => 'Pokud jméno turnaje nevyplníte, bude pojmenován po náhodném velmistrovi.';

  @override
  String get makePrivateTournament => 'Udělejte turnaj soukromý a omezte přístup heslem';

  @override
  String get join => 'Přidat se';

  @override
  String get withdraw => 'Odhlásit se';

  @override
  String get points => 'Body';

  @override
  String get wins => 'Výhry';

  @override
  String get losses => 'Prohry';

  @override
  String get createdBy => 'Vytvořeno uživatelem';

  @override
  String get tournamentIsStarting => 'Turnaj začíná';

  @override
  String get tournamentPairingsAreNowClosed => 'Turnajové rozlosování je nyní uzavřeno.';

  @override
  String standByX(String param) {
    return 'Vyčkejte $param, vybírám soupeře, připravte se!';
  }

  @override
  String get pause => 'Pozastavit';

  @override
  String get resume => 'Pokračovat';

  @override
  String get youArePlaying => 'Hra začala!';

  @override
  String get winRate => 'Poměr výher';

  @override
  String get berserkRate => 'Poměr Berserk';

  @override
  String get performance => 'Výkon';

  @override
  String get tournamentComplete => 'Turnaj skončil';

  @override
  String get movesPlayed => 'Odehráno tahů';

  @override
  String get whiteWins => 'Bílý vyhrál';

  @override
  String get blackWins => 'Černý vyhrál';

  @override
  String get drawRate => 'Poměr remíz';

  @override
  String get draws => 'Remízy';

  @override
  String nextXTournament(String param) {
    return 'Příští $param turnaj:';
  }

  @override
  String get averageOpponent => 'Průměrná síla soupeře';

  @override
  String get boardEditor => 'Editor šachovnice';

  @override
  String get setTheBoard => 'Upravit šachovnici';

  @override
  String get popularOpenings => 'Populární zahájení';

  @override
  String get endgamePositions => 'Pozice koncovek';

  @override
  String chess960StartPosition(String param) {
    return 'Základní postavení Chess960: $param';
  }

  @override
  String get startPosition => 'Základní postavení';

  @override
  String get clearBoard => 'Prázdná šachovnice';

  @override
  String get loadPosition => 'Nahrát pozici';

  @override
  String get isPrivate => 'Soukromý';

  @override
  String reportXToModerators(String param) {
    return 'Nahlásit $param moderátorům';
  }

  @override
  String profileCompletion(String param) {
    return 'Kompletace profilu: $param';
  }

  @override
  String xRating(String param) {
    return '$param rating';
  }

  @override
  String get ifNoneLeaveEmpty => 'Pokud nemáte, nechte pole volné';

  @override
  String get profile => 'Profil';

  @override
  String get editProfile => 'Upravit profil';

  @override
  String get realName => 'Real name';

  @override
  String get setFlair => 'Nastav si svou ikonu za jménem';

  @override
  String get flair => 'Upravitelná ikona';

  @override
  String get youCanHideFlair => 'There is a setting to hide all user flairs across the entire site.';

  @override
  String get biography => 'O mně';

  @override
  String get countryRegion => 'Země nebo region';

  @override
  String get thankYou => 'Děkujeme!';

  @override
  String get socialMediaLinks => 'Odkazy na sociální sítě';

  @override
  String get oneUrlPerLine => 'Jedna URL na řádek.';

  @override
  String get inlineNotation => 'Notace v řádcích';

  @override
  String get makeAStudy => 'Pro bezpečné uložení a sdílení zvažte vytvoření studie.';

  @override
  String get clearSavedMoves => 'Vymazat tahy';

  @override
  String get previouslyOnLichessTV => 'Dříve na Lichess TV';

  @override
  String get onlinePlayers => 'Hráči online';

  @override
  String get activePlayers => 'Aktivní hráči';

  @override
  String get bewareTheGameIsRatedButHasNoClock => 'Pozor, hra je o body i když je bez hodin!';

  @override
  String get success => 'Úspěch';

  @override
  String get automaticallyProceedToNextGameAfterMoving => 'Automaticky přejdi k další hře po tahu';

  @override
  String get autoSwitch => 'Přepnout automaticky';

  @override
  String get puzzles => 'Puzzle';

  @override
  String get onlineBots => 'Online bots';

  @override
  String get name => 'Jméno';

  @override
  String get description => 'Popis';

  @override
  String get descPrivate => 'Soukromý popis';

  @override
  String get descPrivateHelp => 'Text, který uvidí pouze členové týmu, kteří poté uvidí jenom tento text.';

  @override
  String get no => 'Ne';

  @override
  String get yes => 'Ano';

  @override
  String get help => 'Nápověda:';

  @override
  String get createANewTopic => 'Vytvořit nové téma';

  @override
  String get topics => 'Témata';

  @override
  String get posts => 'Příspěvky';

  @override
  String get lastPost => 'Poslední Příspěvek';

  @override
  String get views => 'Zobrazení';

  @override
  String get replies => 'Odpovědi';

  @override
  String get replyToThisTopic => 'Odpovědět na toto téma';

  @override
  String get reply => 'Odpovědět';

  @override
  String get message => 'Zpráva';

  @override
  String get createTheTopic => 'Vytvořit téma';

  @override
  String get reportAUser => 'Nahlásit uživatele';

  @override
  String get user => 'Uživatel';

  @override
  String get reason => 'Důvod';

  @override
  String get whatIsIheMatter => 'Co se stalo?';

  @override
  String get cheat => 'Podvod';

  @override
  String get troll => 'Troll';

  @override
  String get other => 'Jiné';

  @override
  String get reportDescriptionHelp => 'Vložte link na hru(y) a popište, co je špatně na chování tohoto hráče. (Pokud možno anglicky.)';

  @override
  String get error_provideOneCheatedGameLink => 'Prosím, uveďte alespoň jeden link na partii, ve které se podvádělo.';

  @override
  String by(String param) {
    return 'od $param';
  }

  @override
  String importedByX(String param) {
    return 'Importováno uživatelem $param';
  }

  @override
  String get thisTopicIsNowClosed => 'Toto téma je již uzavřeno.';

  @override
  String get blog => 'Blog';

  @override
  String get notes => 'Poznámky';

  @override
  String get typePrivateNotesHere => 'Zde napište soukromé poznámky';

  @override
  String get writeAPrivateNoteAboutThisUser => 'Napište soukromou poznámku o tomto uživateli';

  @override
  String get noNoteYet => 'Zatím žádné poznámky';

  @override
  String get invalidUsernameOrPassword => 'Špatné jméno nebo heslo';

  @override
  String get incorrectPassword => 'Nesprávné heslo';

  @override
  String get invalidAuthenticationCode => 'Neplatný ověřovací kód';

  @override
  String get emailMeALink => 'Pošlete mi odkaz e-mailem';

  @override
  String get currentPassword => 'Současné heslo';

  @override
  String get newPassword => 'Nové heslo';

  @override
  String get newPasswordAgain => 'Nové heslo (znovu)';

  @override
  String get newPasswordsDontMatch => 'Nová hesla nesouhlasí';

  @override
  String get newPasswordStrength => 'Síla hesla';

  @override
  String get clockInitialTime => 'Počáteční čas';

  @override
  String get clockIncrement => 'Přídavek';

  @override
  String get privacy => 'Soukromí';

  @override
  String get privacyPolicy => 'Zásady ochrany osobních údajů';

  @override
  String get letOtherPlayersFollowYou => 'Umožnit ostatním hráčům následovat Tě';

  @override
  String get letOtherPlayersChallengeYou => 'Umožnit ostatním hráčům vyzvat Tě';

  @override
  String get letOtherPlayersInviteYouToStudy => 'Umožnit ostatním hráčům pozvat Vás ke studii';

  @override
  String get sound => 'Zvuky';

  @override
  String get none => 'Žádné';

  @override
  String get fast => 'Rychlé';

  @override
  String get normal => 'Normální';

  @override
  String get slow => 'Pomalé';

  @override
  String get insideTheBoard => 'Na šachovnici';

  @override
  String get outsideTheBoard => 'Mimo šachovnici';

  @override
  String get allSquaresOfTheBoard => 'All squares of the board';

  @override
  String get onSlowGames => 'Při pomalých hrách';

  @override
  String get always => 'Vždy';

  @override
  String get never => 'Nikdy';

  @override
  String xCompetesInY(String param1, String param2) {
    return '$param1 se účastní $param2';
  }

  @override
  String get victory => 'Vítězství';

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
  String get timeline => 'Timeline';

  @override
  String get starting => 'Začíná:';

  @override
  String get allInformationIsPublicAndOptional => 'Všechny informace jsou veřejné a nepovinné.';

  @override
  String get biographyDescription => 'Napiš o sobě - co máš na šachu rád, oblíbená zahájení, partie, hráči…';

  @override
  String get listBlockedPlayers => 'Seznam hráčů, které jste zablokoval(a).';

  @override
  String get human => 'Člověk';

  @override
  String get computer => 'Počítač';

  @override
  String get side => 'Strana';

  @override
  String get clock => 'Čas';

  @override
  String get opponent => 'Protihráč';

  @override
  String get learnMenu => 'Učit se';

  @override
  String get studyMenu => 'Studie';

  @override
  String get practice => 'Procvičujte';

  @override
  String get community => 'Komunita';

  @override
  String get tools => 'Nástroje';

  @override
  String get increment => 'Navýšení';

  @override
  String get error_unknown => 'Neplatná hodnota';

  @override
  String get error_required => 'Toto pole je povinné';

  @override
  String get error_email => 'Emailová adresa je neplatná';

  @override
  String get error_email_acceptable => 'Tato emailová adresa je nepřijatelná. Prosím, zkontrolujte ji a zkuste to znovu.';

  @override
  String get error_email_unique => 'E-mailová adresa je neplatná nebo je již obsazena';

  @override
  String get error_email_different => 'Toto je již Vaše emailová adresa';

  @override
  String error_minLength(String param) {
    return 'Minimální délka je $param';
  }

  @override
  String error_maxLength(String param) {
    return 'Maximální délka je $param';
  }

  @override
  String error_min(String param) {
    return 'Musí být větší nebo rovno $param';
  }

  @override
  String error_max(String param) {
    return 'Musí být menší nebo rovno $param';
  }

  @override
  String ifRatingIsPlusMinusX(String param) {
    return 'Pokud je rating ± $param';
  }

  @override
  String get ifRegistered => 'Pokud je registrován';

  @override
  String get onlyExistingConversations => 'Pouze existující konverzace';

  @override
  String get onlyFriends => 'Jenom přátelé';

  @override
  String get menu => 'Menu';

  @override
  String get castling => 'Rošáda';

  @override
  String get whiteCastlingKingside => 'Bílá O-O';

  @override
  String get blackCastlingKingside => 'Černá O-O';

  @override
  String tpTimeSpentPlaying(String param) {
    return 'Čas strávený hraním $param';
  }

  @override
  String get watchGames => 'Sledujte hry';

  @override
  String tpTimeSpentOnTV(String param) {
    return 'Čas v TV: $param';
  }

  @override
  String get watch => 'Sledujte';

  @override
  String get videoLibrary => 'Video knihovna';

  @override
  String get streamersMenu => 'Streameři';

  @override
  String get mobileApp => 'Mobilní aplikace';

  @override
  String get webmasters => 'Správci webu';

  @override
  String get about => 'O aplikaci';

  @override
  String aboutX(String param) {
    return 'O $param';
  }

  @override
  String xIsAFreeYLibreOpenSourceChessServer(String param1, String param2) {
    return '$param1 je bezplatný ($param2), svobodný open source šachový server bez reklam.';
  }

  @override
  String get really => 'opravdu';

  @override
  String get contribute => 'Přispějte';

  @override
  String get termsOfService => 'Podmínky používání';

  @override
  String get sourceCode => 'Zdrojový kod';

  @override
  String get simultaneousExhibitions => 'Simultánky';

  @override
  String get host => 'Host';

  @override
  String hostColorX(String param) {
    return 'Barva zakladatele: $param';
  }

  @override
  String get yourPendingSimuls => 'Your pending simuls';

  @override
  String get createdSimuls => 'Nově vytvořené simultánky';

  @override
  String get hostANewSimul => 'Vytvoř novou simultánku';

  @override
  String get signUpToHostOrJoinASimul => 'Sign up to host or join a simul';

  @override
  String get noSimulFound => 'Simultánka nenalezena';

  @override
  String get noSimulExplanation => 'Tato simultánka neexistuje';

  @override
  String get returnToSimulHomepage => 'Vrať se na domovskou sránku simultánek';

  @override
  String get aboutSimul => 'Simultánka je boj jednoho hráče proti několika ostatním.';

  @override
  String get aboutSimulImage => 'Z 50 soupeřů, Fisher vyhrál 47, remízoval 2 a prohrál 1.';

  @override
  String get aboutSimulRealLife => 'Koncept je převzat z realných v akcí, kde se host pohybuje po kruhu a vždy odehraje jeden tah.';

  @override
  String get aboutSimulRules => 'Když simultánka začne, každý hráč začne hrát s hostem, který dostane bílé figurky. Simultánka končí, když jsou všechny hry ukončeny.';

  @override
  String get aboutSimulSettings => 'Simultánka je vždy neformální. Je nemožné nabízet odvety, vracení tahu a přidávat čas.';

  @override
  String get create => 'Vytvořte';

  @override
  String get whenCreateSimul => 'Když vytvoříte simultánku, budete hrát proti více hráčům najednou.';

  @override
  String get simulVariantsHint => 'Pokud vyberete více variant, každý ze soupeřů si může vybrat.';

  @override
  String get simulClockHint => 'Nastavení Fisherových hodin. Čím víc hráčů přijmete, tím víc času budete potřebovat.';

  @override
  String get simulAddExtraTime => 'Můžete si přidat více času, abyste  tu simultánku lépe zvládli.';

  @override
  String get simulHostExtraTime => 'Hostův bonusový čas';

  @override
  String get simulAddExtraTimePerPlayer => 'Přidat extra čas za každého hráče který se přidá do simultánky.';

  @override
  String get simulHostExtraTimePerPlayer => 'Extra čas pro hostitele za každého hráče';

  @override
  String get lichessTournaments => 'Lichess turnaje';

  @override
  String get tournamentFAQ => 'Arena turnaj - často kladené otázky';

  @override
  String get timeBeforeTournamentStarts => 'Čas do začátku turnaje';

  @override
  String get averageCentipawnLoss => 'Průměrná pěšcová ztráta';

  @override
  String get accuracy => 'Přesnost';

  @override
  String get keyboardShortcuts => 'Klávesové zkratky';

  @override
  String get keyMoveBackwardOrForward => 'O tah vpřed/vzad';

  @override
  String get keyGoToStartOrEnd => 'běžte na začátek/konec';

  @override
  String get keyCycleSelectedVariation => 'Cycle selected variation';

  @override
  String get keyShowOrHideComments => 'zobrazte/skryjte komentáře';

  @override
  String get keyEnterOrExitVariation => 'Zobraz variantu';

  @override
  String get keyRequestComputerAnalysis => 'Vyžádejte si počítačovou analýzu, poučte se ze svých chyb';

  @override
  String get keyNextLearnFromYourMistakes => 'Další (poučit se z chyb)';

  @override
  String get keyNextBlunder => 'Další hrubá chyba';

  @override
  String get keyNextMistake => 'Další chyba';

  @override
  String get keyNextInaccuracy => 'Další nepřesnost';

  @override
  String get keyPreviousBranch => 'Previous branch';

  @override
  String get keyNextBranch => 'Next branch';

  @override
  String get toggleVariationArrows => 'Přepnout šipky variant';

  @override
  String get cyclePreviousOrNextVariation => 'Cycle previous/next variation';

  @override
  String get toggleGlyphAnnotations => 'Přepnout poznámky glyfů';

  @override
  String get togglePositionAnnotations => 'Toggle position annotations';

  @override
  String get variationArrowsInfo => 'Šipky variant umožňují navigaci bez použití seznamu tahů.';

  @override
  String get playSelectedMove => 'zahrát vybraný tah';

  @override
  String get newTournament => 'Nový turnaj';

  @override
  String get tournamentHomeTitle => 'Šachové turnaje nabízejí různé časové možnosti a varianty';

  @override
  String get tournamentHomeDescription => 'Zahrajte si rychlý šachový turnaj! Připojte se k oficiálnímu plánovanému turnaji, nebo si vytvořte vlastní. Bullet, Blitz, Klasické, Chess960(Fisherovky), Král v centru, Tři šachy a další možnosti jsou k dispozici pro nekonečnou šachovou zábavu.';

  @override
  String get tournamentNotFound => 'Turnaj nenalezen';

  @override
  String get tournamentDoesNotExist => 'Tento turnaj neexistuje.';

  @override
  String get tournamentMayHaveBeenCanceled => 'Možná byl zrušen, jestliže jej opustili všichni hráči před jeho začátkem.';

  @override
  String get returnToTournamentsHomepage => 'Návrat na stránku turnajů';

  @override
  String weeklyPerfTypeRatingDistribution(String param) {
    return 'Týdenní hodnocení pro $param';
  }

  @override
  String yourPerfTypeRatingIsRating(String param1, String param2) {
    return 'Vaše $param1 hodnocení je $param2.';
  }

  @override
  String youAreBetterThanPercentOfPerfTypePlayers(String param1, String param2) {
    return 'Jste lepší než $param1 z $param2 hráčů.';
  }

  @override
  String userIsBetterThanPercentOfPerfTypePlayers(String param1, String param2, String param3) {
    return '$param1 je lepší než $param2 z hráčů $param3.';
  }

  @override
  String betterThanPercentPlayers(String param1, String param2) {
    return 'Lepší než $param1 hráčů $param2';
  }

  @override
  String youDoNotHaveAnEstablishedPerfTypeRating(String param) {
    return 'Nemáte stanovené $param hodnocení.';
  }

  @override
  String get yourRating => 'Tvoje hodnocení';

  @override
  String get cumulative => 'Kumulativně';

  @override
  String get glicko2Rating => 'Glicko-2 hodnocení';

  @override
  String get checkYourEmail => 'Zkontrolujte svoji emailovou složku';

  @override
  String get weHaveSentYouAnEmailClickTheLink => 'Zaslali jsme vám email. Klikněte na odkaz v emailu pro aktivaci vašeho účtu.';

  @override
  String get ifYouDoNotSeeTheEmailCheckOtherPlaces => 'Pokud email nenaleznete v doručené poště, zkontrolujte další místa, kde by mohl být, jako spam, zprávy ze sociálních sítí, koš nebo jiné složky.';

  @override
  String weHaveSentYouAnEmailTo(String param) {
    return 'Zaslali jsme vám email na $param. Klikněte na odkaz v emailu pro přenastavení vašeho hesla.';
  }

  @override
  String byRegisteringYouAgreeToBeBoundByOur(String param) {
    return 'Registrací berete na vědomí naše $param.';
  }

  @override
  String readAboutOur(String param) {
    return 'Přečtěte si naše $param.';
  }

  @override
  String get networkLagBetweenYouAndLichess => 'Síťové zpoždění mezi vámi a lichess';

  @override
  String get timeToProcessAMoveOnLichessServer => 'Čas na zpracování tahu na lichess serveru.';

  @override
  String get downloadAnnotated => 'Stáhnout s poznámkami';

  @override
  String get downloadRaw => 'Stáhnout jako text';

  @override
  String get downloadImported => 'Stáhnout importované';

  @override
  String get crosstable => 'Výsledky';

  @override
  String get youCanAlsoScrollOverTheBoardToMoveInTheGame => 'K pohybu v partii můžete také použít scrollovací kolečko myši nad šachovnicí.';

  @override
  String get scrollOverComputerVariationsToPreviewThem => 'Najetím na varianty počítače zobrazíte jejich náhled.';

  @override
  String get analysisShapesHowTo => 'Kliknutím se shiftem či kliknutím pravým tlačítkem lze kreslit do šachovnice kolečka a šipky.';

  @override
  String get letOtherPlayersMessageYou => 'Povolit zprávy od ostatních hráčů';

  @override
  String get receiveForumNotifications => 'Dostat oznámení, pokud jste zmíněni ve fóru';

  @override
  String get shareYourInsightsData => 'Sdílet výsledky analýzy vašeho hraní';

  @override
  String get withNobody => 'S nikým';

  @override
  String get withFriends => 'S přáteli';

  @override
  String get withEverybody => 'Se všemi';

  @override
  String get kidMode => 'Dětský režim';

  @override
  String get kidModeIsEnabled => 'Dětský režim je povolen.';

  @override
  String get kidModeExplanation => 'To je pro bezpečnost. V dětském režimu je jakákoli komunikace zablokována. Zapněte to pro děti a studenty, pro ochranu před ostatními na Internetu.';

  @override
  String inKidModeTheLichessLogoGetsIconX(String param) {
    return 'Když je zapnutý dětský režim, tak se u loga Lichess objeví ikona $param. Podle toho poznáte, že je Vaše dítě v bezpečí.';
  }

  @override
  String get askYourChessTeacherAboutLiftingKidMode => 'Váš účet je spravován. Požádejte svého šachového učitele o zrušení dětského režimu.';

  @override
  String get enableKidMode => 'Povolit dětský režim';

  @override
  String get disableKidMode => 'Vypnout dětský režim';

  @override
  String get security => 'Zabezpečení';

  @override
  String get sessions => 'Relace';

  @override
  String get revokeAllSessions => 'odebrat všechny relace';

  @override
  String get playChessEverywhere => 'Hrajte šachy kdekoliv';

  @override
  String get asFreeAsLichess => 'Svobodný jako lichess';

  @override
  String get builtForTheLoveOfChessNotMoney => 'Vytvořeno z lásky k šachům, ne pro peníze';

  @override
  String get everybodyGetsAllFeaturesForFree => 'Každý dostane všechny možnosti zdarma';

  @override
  String get zeroAdvertisement => 'Bez reklam';

  @override
  String get fullFeatured => 'Plně vybavený';

  @override
  String get phoneAndTablet => 'Mobil a tablet';

  @override
  String get bulletBlitzClassical => 'ultrarychlá hra, blesková hra, klasická hra';

  @override
  String get correspondenceChess => 'Korespondenční šachy';

  @override
  String get onlineAndOfflinePlay => 'Hra online i offline';

  @override
  String get viewTheSolution => 'Zobrazit řešení';

  @override
  String get followAndChallengeFriends => 'Hraj s přáteli';

  @override
  String get gameAnalysis => 'Analýza hry';

  @override
  String xHostsY(String param1, String param2) {
    return '$param1 založil $param2';
  }

  @override
  String xJoinsY(String param1, String param2) {
    return '$param1 se přidal k $param2';
  }

  @override
  String xLikesY(String param1, String param2) {
    return '$param1 lajknul $param2';
  }

  @override
  String get quickPairing => 'Rychlá hra';

  @override
  String get lobby => 'Výzvy';

  @override
  String get anonymous => 'Anonymní';

  @override
  String yourScore(String param) {
    return 'Vaše skóre: $param';
  }

  @override
  String get language => 'Jazyk';

  @override
  String get background => 'Pozadí';

  @override
  String get light => 'Světlé';

  @override
  String get dark => 'Tmavé';

  @override
  String get transparent => 'Průhledné';

  @override
  String get deviceTheme => 'Motiv podle zařízení';

  @override
  String get backgroundImageUrl => 'URL zdroj obrázku na pozadí:';

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
  String get pieceSet => 'Vzhled figur';

  @override
  String get embedInYourWebsite => 'Vložit na web';

  @override
  String get usernameAlreadyUsed => 'Toto uživatelské jméno již existuje. Zvol, prosím, jiné.';

  @override
  String get usernamePrefixInvalid => 'Uživatelské jméno musí začínat písmenem.';

  @override
  String get usernameSuffixInvalid => 'Uživatelské jméno musí končit písmenem nebo číslem.';

  @override
  String get usernameCharsInvalid => 'Uživatelské jméno musí obsahovat pouze písmena, číslice, podtržítka a pomlčky.';

  @override
  String get usernameUnacceptable => 'Toto uživatelské jméno není přijatelné.';

  @override
  String get playChessInStyle => 'Hrajte šachy stylově';

  @override
  String get chessBasics => 'Základy šachu';

  @override
  String get coaches => 'Trenéři';

  @override
  String get invalidPgn => 'Neplatný formát PGN';

  @override
  String get invalidFen => 'Neplatný formát FEN';

  @override
  String get custom => 'Vlastní';

  @override
  String get notifications => 'Oznámení';

  @override
  String notificationsX(String param1) {
    return 'Oznámení: $param1';
  }

  @override
  String perfRatingX(String param) {
    return 'Rating: $param';
  }

  @override
  String get practiceWithComputer => 'Procvičit s počítačem';

  @override
  String anotherWasX(String param) {
    return 'Další možnost je $param';
  }

  @override
  String bestWasX(String param) {
    return 'Nejlepší tah byl $param';
  }

  @override
  String get youBrowsedAway => 'Procvičování přerušeno';

  @override
  String get resumePractice => 'Pokračovat v procvičování';

  @override
  String get drawByFiftyMoves => 'Hra skončila remízou podle pravidla padesáti tahů.';

  @override
  String get theGameIsADraw => 'Hra končí remízou.';

  @override
  String get computerThinking => 'Počítač přemýšlí...';

  @override
  String get seeBestMove => 'Ukázat nejlepší tah';

  @override
  String get hideBestMove => 'Skrýt nejlepší tah';

  @override
  String get getAHint => 'Získat nápovědu';

  @override
  String get evaluatingYourMove => 'Hodnotím tvůj tah...';

  @override
  String get whiteWinsGame => 'Bílý vyhrál';

  @override
  String get blackWinsGame => 'Černý vyhrál';

  @override
  String get learnFromYourMistakes => 'Poučte se ze svých chyb';

  @override
  String get learnFromThisMistake => 'Poučte se z této chyby';

  @override
  String get skipThisMove => 'Přeskočit tento krok';

  @override
  String get next => 'Další';

  @override
  String xWasPlayed(String param) {
    return 'Bylo zahráno $param';
  }

  @override
  String get findBetterMoveForWhite => 'Najděte lepší tah bílého';

  @override
  String get findBetterMoveForBlack => 'Najděte lepší tah černého';

  @override
  String get resumeLearning => 'Pokračovat v učení';

  @override
  String get youCanDoBetter => 'Máte lepší tah';

  @override
  String get tryAnotherMoveForWhite => 'Zkuste jiný tah bílého';

  @override
  String get tryAnotherMoveForBlack => 'Zkuste jiný tah černého';

  @override
  String get solution => 'Řešení';

  @override
  String get waitingForAnalysis => 'Čekání na analýzu';

  @override
  String get noMistakesFoundForWhite => 'Žádné bílého chyby nenalezeny';

  @override
  String get noMistakesFoundForBlack => 'Žádné černého chyby nenalezeny';

  @override
  String get doneReviewingWhiteMistakes => 'Procházení chyb bílého dokončeno';

  @override
  String get doneReviewingBlackMistakes => 'Procházení chyb černého dokončeno';

  @override
  String get doItAgain => 'Udělat znovu';

  @override
  String get reviewWhiteMistakes => 'Projít chyby bílého';

  @override
  String get reviewBlackMistakes => 'Projít chyby černého';

  @override
  String get advantage => 'Výhoda';

  @override
  String get opening => 'Zahájení';

  @override
  String get middlegame => 'Střední hra';

  @override
  String get endgame => 'Koncovka';

  @override
  String get conditionalPremoves => 'Podmíněné předtahy';

  @override
  String get addCurrentVariation => 'Přidat současnou variantu';

  @override
  String get playVariationToCreateConditionalPremoves => 'Hrajte variantu k vytvoření podmíněných předtahů';

  @override
  String get noConditionalPremoves => 'Žádné podmíněné předtahy';

  @override
  String playX(String param) {
    return 'Hrajte $param';
  }

  @override
  String get showUnreadLichessMessage => 'Dostali jste soukromou zprávu od Lichess.';

  @override
  String get clickHereToReadIt => 'Pro přečtení klikněte zde';

  @override
  String get sorry => 'Omlouváme se :(';

  @override
  String get weHadToTimeYouOutForAWhile => 'Museli jsme tě odpojit na chvíli.';

  @override
  String get why => 'Proč?';

  @override
  String get pleasantChessExperience => 'Snažíme se všem poskytnout příjemnou hru.';

  @override
  String get goodPractice => 'Proto se musíme ujistit, že se všichni chovají správně.';

  @override
  String get potentialProblem => 'Tato zpráva se ukáže když zjistíme problém.';

  @override
  String get howToAvoidThis => 'Jak se tomuto vyhnout?';

  @override
  String get playEveryGame => 'Dohraj každou hru kterou začneš.';

  @override
  String get tryToWin => 'Zkus vyhrát (nebo alespoň remizovat) každou hru.';

  @override
  String get resignLostGames => 'Odstup od prohraných her (nenechávej dojít hodiny).';

  @override
  String get temporaryInconvenience => 'Omlouváme se za dočasnou nedostupnost,';

  @override
  String get wishYouGreatGames => 'a přejeme ti mnoho dobrých partií na lichess.org.';

  @override
  String get thankYouForReading => 'Díky za přečtení!';

  @override
  String get lifetimeScore => 'Celoživotní skóre';

  @override
  String get currentMatchScore => 'Současné výsledky zápasů';

  @override
  String get agreementAssistance => 'Přísahám, že nikdy nevyužiji jiné pomoci při mých hrách (počítače, knihy, databáze nebo jiné osoby).';

  @override
  String get agreementNice => 'Přísahám, že budu vždy respektovat ostatní hráče.';

  @override
  String agreementMultipleAccounts(String param) {
    return 'Souhlasím s tím, že nebudu vytvářet více účtů (s výjimkou důvodů uvedených v $param).';
  }

  @override
  String get agreementPolicy => 'Souhlasím, že se budu řídit všemi pravidly Lichessu.';

  @override
  String get searchOrStartNewDiscussion => 'Začněte nebo vyhledejte konverzaci';

  @override
  String get edit => 'Upravit';

  @override
  String get bullet => 'Bullet';

  @override
  String get blitz => 'Bleskové šachy';

  @override
  String get rapid => 'Rapid';

  @override
  String get classical => 'Klasické';

  @override
  String get ultraBulletDesc => 'Šíleně rychlé hry: méně než 30 sekund';

  @override
  String get bulletDesc => 'Velmi rychlé hry: méně než 3 minuty';

  @override
  String get blitzDesc => 'Rychlé hry: 3 až 8 minut';

  @override
  String get rapidDesc => 'Rapid tempo: 8 až 25 minut';

  @override
  String get classicalDesc => 'Klasické tempo: 25 a více minut';

  @override
  String get correspondenceDesc => 'Korespondenční šach: jeden nebo více dnů na tah';

  @override
  String get puzzleDesc => 'Trénink šachové taktiky';

  @override
  String get important => 'Důležité';

  @override
  String yourQuestionMayHaveBeenAnswered(String param1) {
    return 'Vaše otázka již možná má odpověď $param1';
  }

  @override
  String get inTheFAQ => 'v Často kladených dotazech (F.A.Q.).';

  @override
  String toReportSomeoneForCheatingOrBadBehavior(String param1) {
    return 'Chcete-li nahlásit uživatele z důvodu podvádění nebo za špatné chování, $param1';
  }

  @override
  String get useTheReportForm => 'použijte nahlašovací formulář';

  @override
  String toRequestSupport(String param1) {
    return 'Chcete-li požádat o podporu, $param1';
  }

  @override
  String get tryTheContactPage => 'vyzkoušejte stránku s kontakty';

  @override
  String makeSureToRead(String param1) {
    return 'Určitě si přečtěte $param1';
  }

  @override
  String get theForumEtiquette => 'pravidla chování ve fórech';

  @override
  String get thisTopicIsArchived => 'Toto téma se archivovalo a nelze na něj dále odpovídat.';

  @override
  String joinTheTeamXToPost(String param1) {
    return 'Připojte se k $param1, chcete-li přidávat příspěvky na toto fórum';
  }

  @override
  String teamNamedX(String param1) {
    return '$param1 tým';
  }

  @override
  String get youCannotPostYetPlaySomeGames => 'Zatím nemůžete přidávat příspěvky na fóra. Zahrajte si nějaké hry!';

  @override
  String get subscribe => 'Odebírat';

  @override
  String get unsubscribe => 'Zrušit odběr';

  @override
  String mentionedYouInX(String param1) {
    return 'vás zmínil v \"$param1\".';
  }

  @override
  String xMentionedYouInY(String param1, String param2) {
    return '$param1 Vás zmínil(a) v příspěvku \"$param2\".';
  }

  @override
  String invitedYouToX(String param1) {
    return 'vás pozval ke studii \"$param1\".';
  }

  @override
  String xInvitedYouToY(String param1, String param2) {
    return '$param1 vás pozval ke studii \"$param2\".';
  }

  @override
  String get youAreNowPartOfTeam => 'Nyní jste součástí týmu.';

  @override
  String youHaveJoinedTeamX(String param1) {
    return 'Připojili jste se k týmu \"$param1\".';
  }

  @override
  String get someoneYouReportedWasBanned => 'Někdo, koho jste nahlásili, byl zablokován';

  @override
  String get congratsYouWon => 'Gratulujeme, zvítězili jste!';

  @override
  String gameVsX(String param1) {
    return 'Partie proti $param1';
  }

  @override
  String resVsX(String param1, String param2) {
    return '$param1 vs. $param2';
  }

  @override
  String get lostAgainstTOSViolator => 'Prohráli jste proti hráči, jež porušil Podmínky použití Lichess';

  @override
  String refundXpointsTimeControlY(String param1, String param2) {
    return 'Vráceno $param1 $param2 ratingových bodů.';
  }

  @override
  String get timeAlmostUp => 'Čas vám běží!';

  @override
  String get clickToRevealEmailAddress => '[Klikněte pro zobrazení e-mailové adresy]';

  @override
  String get download => 'Stáhnout';

  @override
  String get coachManager => 'Nastavení trenéra';

  @override
  String get streamerManager => 'Nastavení streamera';

  @override
  String get cancelTournament => 'Zrušit turnaj';

  @override
  String get tournDescription => 'Popis turnaje';

  @override
  String get tournDescriptionHelp => 'Je tu něco co by ste chtěli sdělit účastníkům? Skuste to ve skratce. Markdown odkazy jsou k dispozici: [name](https://url)';

  @override
  String get ratedFormHelp => 'Hry jsou hodnoceny a mají dopad na hodnocení hráče';

  @override
  String get onlyMembersOfTeam => 'Pouze členové týmu';

  @override
  String get noRestriction => 'Bez omezení';

  @override
  String get minimumRatedGames => 'Minimální počet her s ratingem';

  @override
  String get minimumRating => 'Minimální rating';

  @override
  String get maximumWeeklyRating => 'Maximální tydenní rating';

  @override
  String positionInputHelp(String param) {
    return 'Vložte platný FEN popis šachovnice, pokud chcete, aby všechny hry začaly z dané pozice.\nFunguje to pouze pro standardní hry, ne pro varianty.\nMůžete použít $param pro vygenerování FEN popisu zadané pozice a potom ho sem vložit.\nNechte toto pole prázdné, pokud chcete začínat z běžného základního postavení.';
  }

  @override
  String get cancelSimul => 'Zrušit simultánku';

  @override
  String get simulHostcolor => 'Barva figur pořadatele';

  @override
  String get estimatedStart => 'Předpokládaný začátek';

  @override
  String simulFeatured(String param) {
    return 'Funkce v $param';
  }

  @override
  String simulFeaturedHelp(String param) {
    return 'Zobrazit vaši simultánní hru všem na $param. Vypnout pro soukromé simultánní hry.';
  }

  @override
  String get simulDescription => 'Popis simultánky';

  @override
  String get simulDescriptionHelp => 'Je tu něco co by jste chtěli sdělit účastníkům?';

  @override
  String markdownAvailable(String param) {
    return '$param je k dispozici pro pokročilé formátování.';
  }

  @override
  String get embedsAvailable => 'Vložte URL hry nebo kapitoly studie pro zobrazení.';

  @override
  String get inYourLocalTimezone => 'Ve vašem časovém pásmu';

  @override
  String get tournChat => 'Turnajový chat';

  @override
  String get noChat => 'Vypnutý chat';

  @override
  String get onlyTeamLeaders => 'Pouze vedoucí týmu';

  @override
  String get onlyTeamMembers => 'Pouze členové týmu';

  @override
  String get navigateMoveTree => 'Navigovat seznamem tahů';

  @override
  String get mouseTricks => 'Klávesové zkratky';

  @override
  String get toggleLocalAnalysis => 'Zapnout/vypnout lokální počítačovou analýzu';

  @override
  String get toggleAllAnalysis => 'Zapnout/vypnout všechny počítačové analýzy';

  @override
  String get playComputerMove => 'Zahrát nejlepší počítačový tah';

  @override
  String get analysisOptions => 'Ovládání analýzy';

  @override
  String get focusChat => 'Vybrat chat';

  @override
  String get showHelpDialog => 'Zobrazit tuto nápovědu';

  @override
  String get reopenYourAccount => 'Znovu otevřít svůj účet';

  @override
  String get closedAccountChangedMind => 'Pokud jste uzavřel svůj účet, ale od té doby jste změnili názor, dostanete jednu šanci získat svůj účet zpět.';

  @override
  String get onlyWorksOnce => 'Toto je možné provést pouze jednou.';

  @override
  String get cantDoThisTwice => 'Pokud svůj účet zrušíte podruhé, nebude ho už možné obnovit.';

  @override
  String get emailAssociatedToaccount => 'E-mailová adresa přidružená k tomuto účtu';

  @override
  String get sentEmailWithLink => 'Poslali jsme vám e-mail s odkazem.';

  @override
  String get tournamentEntryCode => 'Kód pro vstup do turnaje';

  @override
  String get hangOn => 'Počkejte!';

  @override
  String gameInProgress(String param) {
    return 'Již probíhá hra s $param.';
  }

  @override
  String get abortTheGame => 'Zrušit hru';

  @override
  String get resignTheGame => 'Vzdát hru';

  @override
  String get youCantStartNewGame => 'Nemůžete začít novou hru, dokud nebude tato dokončena.';

  @override
  String get since => 'Od';

  @override
  String get until => 'Do';

  @override
  String get lichessDbExplanation => 'Hodnocené hry od všech Lichess hráčů';

  @override
  String get switchSides => 'Prohodit strany';

  @override
  String get closingAccountWithdrawAppeal => 'Uzavřením vašeho účtu stáhnete vaše odvolání';

  @override
  String get ourEventTips => 'Naše tipy pro organizování akcí';

  @override
  String get instructions => 'Pokyny';

  @override
  String get showMeEverything => 'Ukaž mi všechno';

  @override
  String get lichessPatronInfo => 'Lichess je bezplatný a zcela svobodný/nezávislý softvér s otevřeným zdrojovým kódem.\nVeškeré provozní náklady, vývoj a obsah jsou financovány výhradně z příspěvků uživatelů.';

  @override
  String get nothingToSeeHere => 'Nothing to see here at the moment.';

  @override
  String opponentLeftCounter(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Tvůj soupeř opustil hru. Můžeš si vyžádat vítězství za $count sekund.',
      many: 'Tvůj soupeř opustil hru. Můžeš si vyžádat vítězství za $count sekund.',
      few: 'Tvůj soupeř opustil hru. Můžeš si vyžádat vítězství za $count sekundy.',
      one: 'Tvůj soupeř opustil hru. Můžeš si vyžádat vítězství za $count sekundu.',
    );
    return '$_temp0';
  }

  @override
  String mateInXHalfMoves(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Mat v $count půltazích',
      many: 'Mat v $count půltazích',
      few: 'Mat v $count půltazích',
      one: 'Mat v $count půltahu',
    );
    return '$_temp0';
  }

  @override
  String nbBlunders(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count hrubých chyb',
      many: '$count hrubých chyb',
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
      other: '$count chyb',
      many: '$count chyb',
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
      other: '$count nepřesností',
      many: '$count nepřesností',
      few: '$count nepřesnosti',
      one: '$count nepřesnost',
    );
    return '$_temp0';
  }

  @override
  String nbPlayers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count hráčů online',
      many: '$count hráčů online',
      few: '$count hráči online',
      one: '$count hráč online',
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
      one: '$count partie',
    );
    return '$_temp0';
  }

  @override
  String ratingXOverYGames(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count hodnocení po $param2 partiích',
      many: '$count hodnocení po $param2 partiích',
      few: '$count hodnocení po $param2 partiích',
      one: '$count hodnocení po $param2 partii',
    );
    return '$_temp0';
  }

  @override
  String nbBookmarks(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count záložek',
      many: '$count záložek',
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
      other: '$count dnů',
      many: '$count dnů',
      few: '$count dny',
      one: '$count den',
    );
    return '$_temp0';
  }

  @override
  String nbHours(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count hodin',
      many: '$count hodin',
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
      other: '$count minut',
      many: '$count minut',
      few: '$count minuty',
      one: '$count minuta',
    );
    return '$_temp0';
  }

  @override
  String rankIsUpdatedEveryNbMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Pořadí je aktualizováno každých $count minut',
      many: 'Pořadí je aktualizováno každých $count minut',
      few: 'Pořadí je aktualizováno každé $count minuty',
      one: 'Pořadí je aktualizováno každou minutu',
    );
    return '$_temp0';
  }

  @override
  String nbPuzzles(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count taktických úloh',
      many: '$count taktických úloh',
      few: '$count taktické úlohy',
      one: '$count taktická úloha',
    );
    return '$_temp0';
  }

  @override
  String nbGamesWithYou(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count partií s Vámi',
      many: '$count partií s Vámi',
      few: '$count partie s Vámi',
      one: '$count partie s Vámi',
    );
    return '$_temp0';
  }

  @override
  String nbRated(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count hodnocených',
      many: '$count hodnocených',
      few: '$count hodnocené',
      one: '$count hodnocená',
    );
    return '$_temp0';
  }

  @override
  String nbWins(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count výher',
      many: '$count výher',
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
      other: '$count proher',
      many: '$count proher',
      few: '$count prohry',
      one: '$count prohra',
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
      other: '$count se hraje',
      many: '$count se hraje',
      few: '$count se hrají',
      one: '$count právě hraje',
    );
    return '$_temp0';
  }

  @override
  String giveNbSeconds(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Přidat $count sekund',
      many: 'Přidat $count sekund',
      few: 'Přidat $count sekundy',
      one: 'Přidat $count sekundu',
    );
    return '$_temp0';
  }

  @override
  String nbTournamentPoints(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count turnajových bodů',
      many: '$count turnajových bodů',
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
      other: '$count studií',
      many: '$count studií',
      few: '$count studie',
      one: '$count studie',
    );
    return '$_temp0';
  }

  @override
  String nbSimuls(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count simultánek',
      many: '$count simultánek',
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
      other: '≥ $count hodnocených her',
      many: '≥ $count hodnocených her',
      few: '≥ $count hodnocené hry',
      one: '≥ $count hodnocená hra',
    );
    return '$_temp0';
  }

  @override
  String moreThanNbPerfRatedGames(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '≥ $count $param2 hodnocených her',
      many: '≥ $count $param2 hodnocených her',
      few: '≥ $count $param2 hodnocené hry',
      one: '≥ $count $param2 hodnocená hra',
    );
    return '$_temp0';
  }

  @override
  String needNbMorePerfGames(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Potřebujete odehrát ještě $count $param2 hodnocených partií',
      many: 'Potřebujete odehrát ještě $count $param2 hodnocených partií',
      few: 'Potřebujete odehrát ještě $count $param2 hodnocené partie',
      one: 'Potřebujete odehrát ještě $count $param2 hodnocenou partii',
    );
    return '$_temp0';
  }

  @override
  String needNbMoreGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Potřebujete odehrát ještě $count hodnocených partií',
      many: 'Potřebujete odehrát ještě $count hodnocených partií',
      few: 'Potřebujete odehrát ještě $count hodnocené partie',
      one: 'Potřebujete odehrát ještě $count hodnocenou partii',
    );
    return '$_temp0';
  }

  @override
  String nbImportedGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count importovaných',
      many: '$count importovaných',
      few: '$count importované',
      one: '$count importovaná',
    );
    return '$_temp0';
  }

  @override
  String nbFriendsOnline(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count kamarádů online',
      many: '$count kamarádů online',
      few: '$count kamarádi online',
      one: '$count kamarád online',
    );
    return '$_temp0';
  }

  @override
  String nbFollowers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count následovníků',
      many: '$count následovníků',
      few: '$count následovníci',
      one: '$count následovník',
    );
    return '$_temp0';
  }

  @override
  String nbFollowing(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count sleduje',
      many: '$count sleduje',
      few: '$count sleduje',
      one: '$count sleduje',
    );
    return '$_temp0';
  }

  @override
  String lessThanNbMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Méně než $count minut',
      many: 'Méně než $count minut',
      few: 'Méně než $count minuty',
      one: 'Méně než $count minuta',
    );
    return '$_temp0';
  }

  @override
  String nbGamesInPlay(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count rozehraných her',
      many: '$count rozehraných her',
      few: '$count rozehrané hry',
      one: '$count rozehraná hra',
    );
    return '$_temp0';
  }

  @override
  String maximumNbCharacters(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Maximum: $count znaků.',
      many: 'Maximum: $count znaků.',
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
      other: '$count zablokovaných hráčů',
      many: '$count zablokovaných hráčů',
      few: '$count zablokovaní hráči',
      one: '$count zablokovaný hráč',
    );
    return '$_temp0';
  }

  @override
  String nbForumPosts(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count příspěvků na fóru',
      many: '$count příspěvků na fóru',
      few: '$count příspěvky na fóru',
      one: '$count příspěvek na fóru',
    );
    return '$_temp0';
  }

  @override
  String nbPerfTypePlayersThisWeek(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count hráčů hrálo $param2 tento týden.',
      many: '$count hráčů hrálo $param2 tento týden.',
      few: '$count hráči hráli $param2 tento týden.',
      one: '$count hráč hrál $param2 tento týden.',
    );
    return '$_temp0';
  }

  @override
  String availableInNbLanguages(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Dostupné v $count jazycích!',
      many: 'Dostupné v $count jazycích!',
      few: 'Dostupné v $count jazycích!',
      one: 'Dostupné v $count jazyku!',
    );
    return '$_temp0';
  }

  @override
  String nbSecondsToPlayTheFirstMove(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count sekund na první tah',
      many: '$count sekund na první tah',
      few: '$count sekundy na první tah',
      one: '$count sekunda na první tah',
    );
    return '$_temp0';
  }

  @override
  String nbSeconds(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count sekund',
      many: '$count sekund',
      few: '$count sekundy',
      one: '$count sekunda',
    );
    return '$_temp0';
  }

  @override
  String andSaveNbPremoveLines(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'a uložit $count předtažených variant',
      many: 'a uložit $count předtažených variant',
      few: 'a uložit $count předtažené varianty',
      one: 'a uložit $count předtaženou variantu',
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
  String get stormSkipExplanation => 'Přeskočte tento tah pro zachování své série! Funguje pouze jednou za závod.';

  @override
  String get stormFailedPuzzles => 'Neúspěšné úlohy';

  @override
  String get stormSlowPuzzles => 'Pomalé úlohy';

  @override
  String get stormSkippedPuzzle => 'Přeskočené puzzle';

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
  String get studyShareAndExport => 'Sdílení a export';

  @override
  String get studyStart => 'Začít';
}
