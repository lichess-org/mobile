// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'l10n.dart';

// ignore_for_file: type=lint

/// The translations for Luxembourgish Letzeburgesch (`lb`).
class AppLocalizationsLb extends AppLocalizations {
  AppLocalizationsLb([String locale = 'lb']) : super(locale);

  @override
  String get mobileAllGames => 'All Partien';

  @override
  String get mobileAreYouSure => 'Bass de sécher?';

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
  String mobileGreeting(String param) {
    return 'Moien, $param';
  }

  @override
  String get mobileGreetingWithoutName => 'Moien';

  @override
  String get mobileHideVariation => 'Variante verstoppen';

  @override
  String get mobileHomeTab => 'Home';

  @override
  String get mobileLiveStreamers => 'Live streamers';

  @override
  String get mobileMustBeLoggedIn => 'Du muss ageloggt si fir dës Säit ze gesinn.';

  @override
  String get mobileNoSearchResults => 'Keng Resultater';

  @override
  String get mobileNotFollowingAnyUser => 'You are not following any user.';

  @override
  String get mobileOkButton => 'OK';

  @override
  String mobilePlayersMatchingSearchTerm(String param) {
    return 'Spiller mat „$param“';
  }

  @override
  String get mobilePrefMagnifyDraggedPiece => 'Gezunne Figur vergréisseren';

  @override
  String get mobilePuzzleStormConfirmEndRun => 'Do you want to end this run?';

  @override
  String get mobilePuzzleStormFilterNothingToShow => 'Nothing to show, please change the filters';

  @override
  String get mobilePuzzleStormNothingToShow => 'Nothing to show. Play some runs of Puzzle Storm.';

  @override
  String get mobilePuzzleStormSubtitle => 'Léis sou vill Aufgabe wéi méiglech an 3 Minutten.';

  @override
  String get mobilePuzzleStreakAbortWarning => 'You will lose your current streak and your score will be saved.';

  @override
  String get mobilePuzzleThemesSubtitle => 'Maach Aufgaben aus denge Liiblingserëffnungen oder sich dir een Theema eraus.';

  @override
  String get mobilePuzzlesTab => 'Aufgaben';

  @override
  String get mobileRecentSearches => 'Recent searches';

  @override
  String get mobileSettingsHapticFeedback => 'Haptesche Feedback';

  @override
  String get mobileSettingsImmersiveMode => 'Immersive Modus';

  @override
  String get mobileSettingsImmersiveModeSubtitle => 'Hide system UI while playing. Use this if you are bothered by the system\'s navigation gestures at the edges of the screen. Applies to game and Puzzle Storm screens.';

  @override
  String get mobileSettingsTab => 'Settings';

  @override
  String get mobileShareGamePGN => 'PGN deelen';

  @override
  String get mobileShareGameURL => 'URL vun der Partie deelen';

  @override
  String get mobileSharePositionAsFEN => 'Stellung als FEN deelen';

  @override
  String get mobileSharePuzzle => 'Dës Aufgab deelen';

  @override
  String get mobileShowComments => 'Kommentarer weisen';

  @override
  String get mobileShowResult => 'Resultat weisen';

  @override
  String get mobileShowVariations => 'Variante weisen';

  @override
  String get mobileSomethingWentWrong => 'Et ass eppes schifgaang.';

  @override
  String get mobileSystemColors => 'Systemsfaarwen';

  @override
  String get mobileTheme => 'Theme';

  @override
  String get mobileToolsTab => 'Tools';

  @override
  String get mobileWaitingForOpponentToJoin => 'Waiting for opponent to join...';

  @override
  String get mobileWatchTab => 'Watch';

  @override
  String get activityActivity => 'Verlaf';

  @override
  String get activityHostedALiveStream => 'Huet live gestreamt';

  @override
  String activityRankedInSwissTournament(String param1, String param2) {
    return 'Huet sech als #$param1 an $param2 placéiert';
  }

  @override
  String get activitySignedUp => 'Huet sech bei Lichess ugemellt';

  @override
  String activitySupportedNbMonths(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Ënnerstëtzt Lichess.org säit $count Méint als $param2',
      one: 'Ënnerstëtzt Lichess.org säit $count Mount als $param2',
    );
    return '$_temp0';
  }

  @override
  String activityPracticedNbPositions(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Huet $count Positiounen zu $param2 geüübt',
      one: 'Huet $count Positioun zu $param2 geüübt',
    );
    return '$_temp0';
  }

  @override
  String activitySolvedNbPuzzles(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Huet $count Taktikaufgabe geléist',
      one: 'Huet $count Taktikaufgab geléist',
    );
    return '$_temp0';
  }

  @override
  String activityPlayedNbGames(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Huet $count Partien $param2 gespillt',
      one: 'Huet $count Partie $param2 gespillt',
    );
    return '$_temp0';
  }

  @override
  String activityPostedNbMessages(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Huet $count Noriichten an $param2 geschriwwen',
      one: 'Huet $count Noriicht an $param2 geschriwwen',
    );
    return '$_temp0';
  }

  @override
  String activityPlayedNbMoves(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Huet $count Zich gespillt',
      one: 'Huet $count Zuch gespillt',
    );
    return '$_temp0';
  }

  @override
  String activityInNbCorrespondenceGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'an $count Fernschachpartien',
      one: 'an $count Fernschachpartie',
    );
    return '$_temp0';
  }

  @override
  String activityCompletedNbGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Huet $count Fernschachpartien gespillt',
      one: 'Huet $count Fernschachpartie gespillt',
    );
    return '$_temp0';
  }

  @override
  String activityCompletedNbVariantGames(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Huet $count $param2-Fernschachpartië gespillt',
      one: 'Huet $count $param2-Fernschachpartie gespillt',
    );
    return '$_temp0';
  }

  @override
  String activityFollowedNbPlayers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Suivéiert $count Spiller',
      one: 'Suivéiert $count Spiller',
    );
    return '$_temp0';
  }

  @override
  String activityGainedNbFollowers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Huet $count nei Unhänger',
      one: 'Huet $count neien Unhänger',
    );
    return '$_temp0';
  }

  @override
  String activityHostedNbSimuls(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Huet $count Simultanvirstellunge presentéiert',
      one: 'Huet $count Simultanvirstellung presentéiert',
    );
    return '$_temp0';
  }

  @override
  String activityJoinedNbSimuls(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Huet bei $count Simultanvirstellunge matgemaach',
      one: 'Huet bei $count Simultanvirstellung matgemaach',
    );
    return '$_temp0';
  }

  @override
  String activityCreatedNbStudies(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Huet $count Etüde kreéiert',
      one: 'Huet $count Etüd kreéiert',
    );
    return '$_temp0';
  }

  @override
  String activityCompetedInNbTournaments(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Huet bei $count Arena Turnéiere matgemaach',
      one: 'Huet bei $count Arena Turnéier matgemaach',
    );
    return '$_temp0';
  }

  @override
  String activityRankedInTournament(int count, String param2, String param3, String param4) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Huet sech als #$count (iewescht $param2%) mat $param3 Partien an $param4 placéiert',
      one: 'Huet sech als #$count (iewescht $param2%) mat $param3 Partie an $param4 placéiert',
    );
    return '$_temp0';
  }

  @override
  String activityCompetedInNbSwissTournaments(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Huet bei $count Turnéieren nom Schwäizer System matgemaach',
      one: 'Huet bei $count Turnéier nom Schwäizer System matgemaach',
    );
    return '$_temp0';
  }

  @override
  String activityJoinedNbTeams(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Ass $count Ekippe bäigetrueden',
      one: 'Ass $count Ekipp bäigetrueden',
    );
    return '$_temp0';
  }

  @override
  String get broadcastBroadcasts => 'Iwwerdroungen';

  @override
  String get broadcastMyBroadcasts => 'My broadcasts';

  @override
  String get broadcastLiveBroadcasts => 'Live Turnéier Iwwerdroungen';

  @override
  String get broadcastBroadcastCalendar => 'Broadcast calendar';

  @override
  String get broadcastNewBroadcast => 'Nei Live Iwwerdroung';

  @override
  String get broadcastSubscribedBroadcasts => 'Subscribed broadcasts';

  @override
  String get broadcastAboutBroadcasts => 'About broadcasts';

  @override
  String get broadcastHowToUseLichessBroadcasts => 'How to use Lichess Broadcasts.';

  @override
  String get broadcastTheNewRoundHelp => 'The new round will have the same members and contributors as the previous one.';

  @override
  String get broadcastAddRound => 'Ronn hinzufügen';

  @override
  String get broadcastOngoing => 'Am Gaang';

  @override
  String get broadcastUpcoming => 'Demnächst';

  @override
  String get broadcastCompleted => 'Eriwwer';

  @override
  String get broadcastCompletedHelp => 'Lichess detects round completion, but can get it wrong. Use this to set it manually.';

  @override
  String get broadcastRoundName => 'Ronnennumm';

  @override
  String get broadcastRoundNumber => 'Ronnennummer';

  @override
  String get broadcastTournamentName => 'Turnéiernumm';

  @override
  String get broadcastTournamentDescription => 'Kuerz Turnéierbeschreiwung';

  @override
  String get broadcastFullDescription => 'Komplett Turnéierbeschreiwung';

  @override
  String broadcastFullDescriptionHelp(String param1, String param2) {
    return 'Optional laang Beschreiwung vum Turnéier. $param1 ass disponibel. Längt muss manner wéi $param2 Buschtawen sinn.';
  }

  @override
  String get broadcastSourceSingleUrl => 'PGN Source URL';

  @override
  String get broadcastSourceUrlHelp => 'URL déi Lichess checkt fir PGN à jour ze halen. Muss ëffentlech iwwer Internet zougänglech sinn.';

  @override
  String get broadcastSourceGameIds => 'Bis zu 64 Lichess-Partie-IDen, duerch Espacë getrennt.';

  @override
  String broadcastStartDateTimeZone(String param) {
    return 'Startdatum vum Turnéier an der lokaler Zäitzon: $param';
  }

  @override
  String get broadcastStartDateHelp => 'Optional, wann du wees wéini den Turnéier ufänkt';

  @override
  String get broadcastCurrentGameUrl => 'URL vun der aktueller Partie';

  @override
  String get broadcastDownloadAllRounds => 'All Ronnen eroflueden';

  @override
  String get broadcastResetRound => 'Ronn zerécksetzen';

  @override
  String get broadcastDeleteRound => 'Ronn läschen';

  @override
  String get broadcastDefinitivelyDeleteRound => 'Dës Ronn an hir Partien endgülteg läschen.';

  @override
  String get broadcastDeleteAllGamesOfThisRound => 'All Partien vun dëser Ronn läschen. D\'Quell muss aktiv sinn fir se ze rekreéieren.';

  @override
  String get broadcastEditRoundStudy => 'Ronnen-Etüd modifiéieren';

  @override
  String get broadcastDeleteTournament => 'Dësen Turnéier läschen';

  @override
  String get broadcastDefinitivelyDeleteTournament => 'De ganzen Turnéier definitiv läschen, all seng Ronnen an all seng Partien.';

  @override
  String get broadcastShowScores => 'Show players scores based on game results';

  @override
  String get broadcastReplacePlayerTags => 'Optional: Spillernimm, Wäertungen an Titelen ersetzen';

  @override
  String get broadcastFideFederations => 'FIDE-Federatiounen';

  @override
  String get broadcastTop10Rating => 'Top 10 rating';

  @override
  String get broadcastFidePlayers => 'FIDE-Spiller';

  @override
  String get broadcastFidePlayerNotFound => 'FIDE-Spiller net tfonnt';

  @override
  String get broadcastFideProfile => 'FIDE-Profil';

  @override
  String get broadcastFederation => 'Federatioun';

  @override
  String get broadcastAgeThisYear => 'Alter dëst Joer';

  @override
  String get broadcastUnrated => 'Ongewäert';

  @override
  String get broadcastRecentTournaments => 'Rezent Turnéieren';

  @override
  String get broadcastOpenLichess => 'Open in Lichess';

  @override
  String get broadcastTeams => 'Ekippen';

  @override
  String get broadcastBoards => 'Boards';

  @override
  String get broadcastOverview => 'Iwwersiicht';

  @override
  String get broadcastSubscribeTitle => 'Subscribe to be notified when each round starts. You can toggle bell or push notifications for broadcasts in your account preferences.';

  @override
  String get broadcastUploadImage => 'Turnéierbild eroplueden';

  @override
  String get broadcastNoBoardsYet => 'No boards yet. These will appear once games are uploaded.';

  @override
  String broadcastBoardsCanBeLoaded(String param) {
    return 'Boards can be loaded with a source or via the $param';
  }

  @override
  String broadcastStartsAfter(String param) {
    return 'Fänkt no $param un';
  }

  @override
  String get broadcastStartVerySoon => 'The broadcast will start very soon.';

  @override
  String get broadcastNotYetStarted => 'The broadcast has not yet started.';

  @override
  String get broadcastOfficialWebsite => 'Offiziell Websäit';

  @override
  String get broadcastStandings => 'Standings';

  @override
  String get broadcastOfficialStandings => 'Offizielle Stand';

  @override
  String broadcastIframeHelp(String param) {
    return 'Méi Optiounen op der $param';
  }

  @override
  String get broadcastWebmastersPage => 'Webmaster-Säit';

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
  String get broadcastGamesThisTournament => 'Partien an dësem Turnéier';

  @override
  String get broadcastScore => 'Score';

  @override
  String get broadcastAllTeams => 'All Ekippen';

  @override
  String get broadcastTournamentFormat => 'Turnéierformat';

  @override
  String get broadcastTournamentLocation => 'Turnéierplaz';

  @override
  String get broadcastTopPlayers => 'Topspiller';

  @override
  String get broadcastTimezone => 'Zäitzon';

  @override
  String get broadcastFideRatingCategory => 'FIDE-Wäertungskategorie';

  @override
  String get broadcastOptionalDetails => 'Fakultativ Detailler';

  @override
  String get broadcastPastBroadcasts => 'Past broadcasts';

  @override
  String get broadcastAllBroadcastsByMonth => 'View all broadcasts by month';

  @override
  String broadcastNbBroadcasts(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Iwwerdroungen',
      one: '$count Iwwerdroung',
    );
    return '$_temp0';
  }

  @override
  String challengeChallengesX(String param1) {
    return 'Erausfuerderungen: $param1';
  }

  @override
  String get challengeChallengeToPlay => 'Erausfuerderung zu enger Partie';

  @override
  String get challengeChallengeDeclined => 'Erausfuerderung ofgeleent';

  @override
  String get challengeChallengeAccepted => 'Erausfuerderung ugeholl!';

  @override
  String get challengeChallengeCanceled => 'Erausfuerderung annuléiert.';

  @override
  String get challengeRegisterToSendChallenges => 'Registréier dech wannechgelift fir Erausfuerderungen ze schécken.';

  @override
  String challengeYouCannotChallengeX(String param) {
    return 'Du kanns $param net erausfuerderen.';
  }

  @override
  String challengeXDoesNotAcceptChallenges(String param) {
    return '$param akzeptéiert keng Erausfuerderungen.';
  }

  @override
  String challengeYourXRatingIsTooFarFromY(String param1, String param2) {
    return 'Deng $param1 Wäertung ass ze wäit vum $param2.';
  }

  @override
  String challengeCannotChallengeDueToProvisionalXRating(String param) {
    return 'Kann net erausfuerderen wéinst provisorescher $param Wäertung.';
  }

  @override
  String challengeXOnlyAcceptsChallengesFromFriends(String param) {
    return '$param akzeptéiert just Erausfuerderungen vun Frënn.';
  }

  @override
  String get challengeDeclineGeneric => 'Ech akzeptéieren am Moment keng Erausfuerderungen.';

  @override
  String get challengeDeclineLater => 'Ech hun gerad keng Zäit, wannechgelift probéier méi spéit.';

  @override
  String get challengeDeclineTooFast => 'Dës Zäitkontroll ass mer ze schnell, fuerder mech wannechgelift zu enger méi lueser Partie eraus.';

  @override
  String get challengeDeclineTooSlow => 'Dës Zäitkontroll ass mer ze lues, fuerder mech wannechgelift zu enger méi schneller Partie eraus.';

  @override
  String get challengeDeclineTimeControl => 'Ech akzeptéieren keng Erausfuerderungen an dëser Zäitkontroll.';

  @override
  String get challengeDeclineRated => 'Schéck mer wannechgelift eng gewäert Erausfuerderung.';

  @override
  String get challengeDeclineCasual => 'Schéck mer wannechgelift eng ongewäert Erausfuerderung.';

  @override
  String get challengeDeclineStandard => 'Ech akzeptéieren am Moment keng Erausfuerderungen zu Varianten.';

  @override
  String get challengeDeclineVariant => 'Ech wëll déi Variant gerad net spillen.';

  @override
  String get challengeDeclineNoBot => 'Ech akzeptéieren keng Erausfuerderungen vun Bots.';

  @override
  String get challengeDeclineOnlyBot => 'Ech akzeptéieren just Erausfuerderungen vun Bots.';

  @override
  String get challengeInviteLichessUser => 'Oder invitéier en Lichess Benotzer:';

  @override
  String get contactContact => 'Kontakt';

  @override
  String get contactContactLichess => 'Lichess kontaktéieren';

  @override
  String get patronDonate => 'Spenden';

  @override
  String get patronLichessPatron => 'Lichess Ënnerstëtzer';

  @override
  String perfStatPerfStats(String param) {
    return '$param Statistiken';
  }

  @override
  String get perfStatViewTheGames => 'Partien ukucken';

  @override
  String get perfStatProvisional => 'provisoresch';

  @override
  String get perfStatNotEnoughRatedGames => 'Net genug gewäert Partien goufen gespillt fir eng zouverlässegeg Wäertung ze etabléieren.';

  @override
  String perfStatProgressOverLastXGames(String param) {
    return 'Progrès iwwert déi lescht $param Partien:';
  }

  @override
  String perfStatRatingDeviation(String param) {
    return 'Wäertungsofweichung: $param.';
  }

  @override
  String perfStatRatingDeviationTooltip(String param1, String param2, String param3) {
    return 'En niddregen Wäert heescht d\'Wäertung ass méi stabel. Iwwer $param1 ass d\'Wäertung just provisoresch. Fir an der Ranglëscht abegraff ze ginn muss dësen Wäert ënner $param2(Standard Schach) respektiv $param3(Varianten) sinn.';
  }

  @override
  String get perfStatTotalGames => 'Total Partien';

  @override
  String get perfStatRatedGames => 'Gewäert Partien';

  @override
  String get perfStatTournamentGames => 'Turnéier Partien';

  @override
  String get perfStatBerserkedGames => 'Berserk Partien';

  @override
  String get perfStatTimeSpentPlaying => 'Gesamt Spillzäit';

  @override
  String get perfStatAverageOpponent => 'Duerchschnëttleche Géigner';

  @override
  String get perfStatVictories => 'Victoirë';

  @override
  String get perfStatDefeats => 'Defaiten';

  @override
  String get perfStatDisconnections => 'Déconnexiounen';

  @override
  String get perfStatNotEnoughGames => 'Net genug gewäert Partien';

  @override
  String perfStatHighestRating(String param) {
    return 'Héchste Wäertungszuel: $param';
  }

  @override
  String perfStatLowestRating(String param) {
    return 'Niddregst Wäertungszuel: $param';
  }

  @override
  String perfStatFromXToY(String param1, String param2) {
    return 'Vun $param1 bis $param2';
  }

  @override
  String get perfStatWinningStreak => 'Erfollegsserie';

  @override
  String get perfStatLosingStreak => 'Verloschserie';

  @override
  String perfStatLongestStreak(String param) {
    return 'Längsten Erfollegserie: $param';
  }

  @override
  String perfStatCurrentStreak(String param) {
    return 'Aktuell Erfollegserie: $param';
  }

  @override
  String get perfStatBestRated => 'Bescht gewäert Victoirë';

  @override
  String get perfStatGamesInARow => 'Partien hannerteneen gespillt';

  @override
  String get perfStatLessThanOneHour => 'Manner wéi eng Stonn zwëschen den Partien';

  @override
  String get perfStatMaxTimePlaying => 'Maximal Spillzäit';

  @override
  String get perfStatNow => 'Elo';

  @override
  String get preferencesPreferences => 'Astellungen';

  @override
  String get preferencesDisplay => 'Usiicht';

  @override
  String get preferencesPrivacy => 'Privatsphär';

  @override
  String get preferencesNotifications => 'Benoriichtegungen';

  @override
  String get preferencesPieceAnimation => 'Figurenanimatioun';

  @override
  String get preferencesMaterialDifference => 'Materialënnerscheed';

  @override
  String get preferencesBoardHighlights => 'Felder um Briet ervirhiewen (leschten Zuch a Schach)';

  @override
  String get preferencesPieceDestinations => 'Zilfelder markéieren (legal Zich a Virauszich)';

  @override
  String get preferencesBoardCoordinates => 'Brietkoordinaten (A-H, 1-8)';

  @override
  String get preferencesMoveListWhilePlaying => 'Zuchlëscht wärend dem Spillen';

  @override
  String get preferencesPgnPieceNotation => 'Zuchnotatioun';

  @override
  String get preferencesChessPieceSymbol => 'Schachfiguresymbol';

  @override
  String get preferencesPgnLetter => 'Buschtaf (K, Q, R, B, N)';

  @override
  String get preferencesZenMode => 'Zen-Modus';

  @override
  String get preferencesShowPlayerRatings => 'Spillerwäertungen uweisen';

  @override
  String get preferencesShowFlairs => 'Show player flairs';

  @override
  String get preferencesExplainShowPlayerRatings => 'Verstopp all Wäertungen op der Websäit, fir dass du dech voll op de Schach konzentréieren kanns. Partien können ëmmer nach gewäert sinn, et geet just drëm, wat du gesäis.';

  @override
  String get preferencesDisplayBoardResizeHandle => 'Regeler fir Brietgréisst ze änneren weisen';

  @override
  String get preferencesOnlyOnInitialPosition => 'Just an Startpositioun';

  @override
  String get preferencesInGameOnly => 'Nëmmen während enger Partie';

  @override
  String get preferencesChessClock => 'Schachauer';

  @override
  String get preferencesTenthsOfSeconds => 'Zéngtelsekonnen';

  @override
  String get preferencesWhenTimeRemainingLessThanTenSeconds => 'Wann verbleiwend Zäit < 10 Sekonnen';

  @override
  String get preferencesHorizontalGreenProgressBars => 'Horizontalen gréngen Fortschrëttsbalken';

  @override
  String get preferencesSoundWhenTimeGetsCritical => 'Toun wann Zäit kritesch gëtt';

  @override
  String get preferencesGiveMoreTime => 'Zäit bäiginn';

  @override
  String get preferencesGameBehavior => 'Spillverhalen';

  @override
  String get preferencesHowDoYouMovePieces => 'Wéi Figuren beweegen?';

  @override
  String get preferencesClickTwoSquares => 'Zwee Felder klicken';

  @override
  String get preferencesDragPiece => 'Figur zéien';

  @override
  String get preferencesBothClicksAndDrag => 'Béides';

  @override
  String get preferencesPremovesPlayingDuringOpponentTurn => 'Virauszich (wärend dem Géigner sengem Zuch spillen)';

  @override
  String get preferencesTakebacksWithOpponentApproval => 'Zeréckhuelen (mat Zoustemmung vum Géigner)';

  @override
  String get preferencesInCasualGamesOnly => 'Just an ongewäerten Partien';

  @override
  String get preferencesPromoteToQueenAutomatically => 'Automatesch an eng Damm ëmwandelen';

  @override
  String get preferencesExplainPromoteToQueenAutomatically => 'Dréck ob deng <ctrl> Tasten während der Emwandlung fir temporär déi automatesch Emwandlung ze desaktivéieren';

  @override
  String get preferencesWhenPremoving => 'Wann Virauszuch';

  @override
  String get preferencesClaimDrawOnThreefoldRepetitionAutomatically => 'Remis duerch dräifach Stellungswidderhuelung reklaméieren';

  @override
  String get preferencesWhenTimeRemainingLessThanThirtySeconds => 'Wann verbleiwend Zäit < 30 Sekonnen';

  @override
  String get preferencesMoveConfirmation => 'Zich confirméieren';

  @override
  String get preferencesExplainCanThenBeTemporarilyDisabled => 'Kann während der Partie desaktivéiert ginn iwwert den Brietmenü';

  @override
  String get preferencesInCorrespondenceGames => 'Korrespondenz Schach';

  @override
  String get preferencesCorrespondenceAndUnlimited => 'Korrespondenz an onbegrenzt';

  @override
  String get preferencesConfirmResignationAndDrawOffers => 'Resignatioun a Remis-Offere confirméieren';

  @override
  String get preferencesCastleByMovingTheKingTwoSquaresOrOntoTheRook => 'Rochade-Method';

  @override
  String get preferencesCastleByMovingTwoSquares => 'Kinnek zwee Felder beweegen';

  @override
  String get preferencesCastleByMovingOntoTheRook => 'Kinnek op Tuerm beweegen';

  @override
  String get preferencesInputMovesWithTheKeyboard => 'Zich mat der Tastatur aginn';

  @override
  String get preferencesInputMovesWithVoice => 'Zich per Sproocherkennung aginn';

  @override
  String get preferencesSnapArrowsToValidMoves => 'Feiler können just legal Zich weisen';

  @override
  String get preferencesSayGgWpAfterLosingOrDrawing => 'No Defaite oder Remis \"Good game, well played\" (Gudd Partie, gudd gespillt) soen';

  @override
  String get preferencesYourPreferencesHaveBeenSaved => 'Deng Astellungen goufen gespäichert.';

  @override
  String get preferencesScrollOnTheBoardToReplayMoves => 'Scroll iwwer d\'Briet fir Zich nozespillen';

  @override
  String get preferencesCorrespondenceEmailNotification => 'Deegleg Email mat Lëscht vun Korrespondenzpartien';

  @override
  String get preferencesNotifyStreamStart => 'Streamer geet live';

  @override
  String get preferencesNotifyInboxMsg => 'Nei Privatnoriicht';

  @override
  String get preferencesNotifyForumMention => 'Forenkommentar ernimmt dech';

  @override
  String get preferencesNotifyInvitedStudy => 'Etüdeninvitatioun';

  @override
  String get preferencesNotifyGameEvent => 'Korrespondenzpartien Updates';

  @override
  String get preferencesNotifyChallenge => 'Erausfuerderungen';

  @override
  String get preferencesNotifyTournamentSoon => 'Turnéier fänkt gleich un';

  @override
  String get preferencesNotifyTimeAlarm => 'Zäit an Korrespondenzpartie leeft of';

  @override
  String get preferencesNotifyBell => 'Benoriichtegung ob Lichess';

  @override
  String get preferencesNotifyPush => 'Gerät Benoriichtegung wanns du net ob Lichess bass';

  @override
  String get preferencesNotifyWeb => 'Web-Browser';

  @override
  String get preferencesNotifyDevice => 'Gerät';

  @override
  String get preferencesBellNotificationSound => 'Glacken-Notifikatiounstoun';

  @override
  String get preferencesBlindfold => 'Blann';

  @override
  String get puzzlePuzzles => 'Aufgaben';

  @override
  String get puzzlePuzzleThemes => 'Aufgabentheemen';

  @override
  String get puzzleRecommended => 'Recommandéiert';

  @override
  String get puzzlePhases => 'Phasen';

  @override
  String get puzzleMotifs => 'Motiven';

  @override
  String get puzzleAdvanced => 'Avancéiert';

  @override
  String get puzzleLengths => 'Längten';

  @override
  String get puzzleMates => 'Matts';

  @override
  String get puzzleGoals => 'Ziler';

  @override
  String get puzzleOrigin => 'Ursprong';

  @override
  String get puzzleSpecialMoves => 'Besonnesch Zich';

  @override
  String get puzzleDidYouLikeThisPuzzle => 'Huet dir dës Aufgab gefall?';

  @override
  String get puzzleVoteToLoadNextOne => 'Stëmm of fir déi nächst ze lueden!';

  @override
  String get puzzleUpVote => 'Puzzle gudd bewäerten';

  @override
  String get puzzleDownVote => 'Puzzle schlecht bewäerten';

  @override
  String get puzzleYourPuzzleRatingWillNotChange => 'Deng Aufgabenwäertung wäert sech net änneren. Aufgaben sinn keng Competitioun. D\'Wäertung hëlleft déi bescht Aufgaben fir deng Fähegkeeten auszewielen.';

  @override
  String get puzzleFindTheBestMoveForWhite => 'Fann de beschten Zuch fir Wäiss.';

  @override
  String get puzzleFindTheBestMoveForBlack => 'Fann de beschten Zuch fir Schwaarz.';

  @override
  String get puzzleToGetPersonalizedPuzzles => 'Fir personaliséiert Aufgaben ze kréien:';

  @override
  String puzzlePuzzleId(String param) {
    return 'Aufgab $param';
  }

  @override
  String get puzzlePuzzleOfTheDay => 'Aufgab vum Dag';

  @override
  String get puzzleDailyPuzzle => 'Aufgab vum Dag';

  @override
  String get puzzleClickToSolve => 'Klick fir ze léisen';

  @override
  String get puzzleGoodMove => 'Gudden Zuch';

  @override
  String get puzzleBestMove => 'Beschten Zuch!';

  @override
  String get puzzleKeepGoing => 'Maach weider…';

  @override
  String get puzzlePuzzleSuccess => 'Korrekt!';

  @override
  String get puzzlePuzzleComplete => 'Aufgab ofgeschloss!';

  @override
  String get puzzleByOpenings => 'No Erëffnungen';

  @override
  String get puzzlePuzzlesByOpenings => 'Aufgaben no Erëffnungen';

  @override
  String get puzzleOpeningsYouPlayedTheMost => 'Erëffnungen, déi s du am meeschten an gewäertene Partie gespillt hues';

  @override
  String get puzzleUseFindInPage => 'Benotz \"Suche in Seite\" an dengem Browser fir deng Lieblingseröffnung ze fannen!';

  @override
  String get puzzleUseCtrlF => 'Benotz Strg+F fir deng Lieblingserëffnung ze fannen!';

  @override
  String get puzzleNotTheMove => 'Dat ass net den Zuch!';

  @override
  String get puzzleTrySomethingElse => 'Probéier eppes aneres.';

  @override
  String puzzleRatingX(String param) {
    return 'Wäertung: $param';
  }

  @override
  String get puzzleHidden => 'verstoppt';

  @override
  String puzzleFromGameLink(String param) {
    return 'Aus der Partie $param';
  }

  @override
  String get puzzleContinueTraining => 'Training weiderféieren';

  @override
  String get puzzleDifficultyLevel => 'Schwieregkeetsgrad';

  @override
  String get puzzleNormal => 'Normal';

  @override
  String get puzzleEasier => 'Méi einfach';

  @override
  String get puzzleEasiest => 'Am einfachsten';

  @override
  String get puzzleHarder => 'Méi schwéier';

  @override
  String get puzzleHardest => 'Am schwéiersten';

  @override
  String get puzzleExample => 'Beispill';

  @override
  String get puzzleAddAnotherTheme => 'E weidert Motiv bäifügen';

  @override
  String get puzzleNextPuzzle => 'Nächsten Puzzle';

  @override
  String get puzzleJumpToNextPuzzleImmediately => 'Direkt zur nächster Aufgab sprangen';

  @override
  String get puzzlePuzzleDashboard => 'Aufgabeniwwersiicht';

  @override
  String get puzzleImprovementAreas => 'Verbesserungsberäicher';

  @override
  String get puzzleStrengths => 'Stäerkten';

  @override
  String get puzzleHistory => 'Aufgabeverlaf';

  @override
  String get puzzleSolved => 'geléist';

  @override
  String get puzzleFailed => 'feelgeschloen';

  @override
  String get puzzleStreakDescription => 'Léis Aufgabe déi méi schwéier ginn a bau eng Erfollegsserie op. Et gëtt keng Auer, also huel dir Zäit. Ee falsche Zuch an et ass eriwwer! Mee du kanns een Zuch pro Laf iwwersprangen.';

  @override
  String puzzleYourStreakX(String param) {
    return 'Deng Erfollegsserie: $param';
  }

  @override
  String get puzzleStreakSkipExplanation => 'Iwwersprang dëse Zuch fir deng Erfollegsserie ze erhalen! Dës kanns du nëmmen ee Mol pro Laf maachen.';

  @override
  String get puzzleContinueTheStreak => 'Erfollegsserie wiederféieren';

  @override
  String get puzzleNewStreak => 'Nei Erfollegsserie';

  @override
  String get puzzleFromMyGames => 'Aus menge Partien';

  @override
  String get puzzleLookupOfPlayer => 'Sich Aufgaben aus Partie vun engem Spiller';

  @override
  String puzzleFromXGames(String param) {
    return 'Aufgaben aus Partie vum $param';
  }

  @override
  String get puzzleSearchPuzzles => 'Aufgabe sichen';

  @override
  String get puzzleFromMyGamesNone => 'Et befannen sech keng Aufgabe vun dir an der Datebank, mee Lichess schätzt dech weiderhi ganz vill.\nSpill rapid an klassesch Partien, fir deng Chancen ze erhéijen, eng Aufgab vun denge Partien bäizefügen!';

  @override
  String puzzleFromXGamesFound(String param1, String param2) {
    return '$param1 Aufgaben an $param2 Partie fonnt';
  }

  @override
  String get puzzlePuzzleDashboardDescription => 'Trainéier, analyséier, verbesser';

  @override
  String puzzlePercentSolved(String param) {
    return '$param geléist';
  }

  @override
  String get puzzleNoPuzzlesToShow => 'Näicht ze weisen, spill fir d\'éischt e puer Aufgaben!';

  @override
  String get puzzleImprovementAreasDescription => 'Trainéier dës fir däin Fortschrëtt ze optimiséieren!';

  @override
  String get puzzleStrengthDescription => 'Dës Aufgabe leien dir am beschten';

  @override
  String puzzlePlayedXTimes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count mol gespillt',
      one: '$count mol gespillt',
    );
    return '$_temp0';
  }

  @override
  String puzzleNbPointsBelowYourPuzzleRating(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Punkten ënner denger Aufgabebewärtung',
      one: 'Ee Punkt ënner denger Aufgabebewärtung',
    );
    return '$_temp0';
  }

  @override
  String puzzleNbPointsAboveYourPuzzleRating(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Punkten iwwer denger Aufgabebewärtung',
      one: 'Ee Punkt iwwer denger Aufgabebewärtung',
    );
    return '$_temp0';
  }

  @override
  String puzzleNbPlayed(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count gespillt',
      one: '$count gespillt',
    );
    return '$_temp0';
  }

  @override
  String puzzleNbToReplay(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ze widderhuelen',
      one: '$count ze widderhuelen',
    );
    return '$_temp0';
  }

  @override
  String get puzzleThemeAdvancedPawn => 'Virgeréckelte Bauer';

  @override
  String get puzzleThemeAdvancedPawnDescription => 'Ee vu denge Baueren ass déif an der géignerescher Stellung virgeréckelt an dreet méiglecherweis ëmzewandelen.';

  @override
  String get puzzleThemeAdvantage => 'Virdeel';

  @override
  String get puzzleThemeAdvantageDescription => 'Nëtz deng Geleeënheet fir en decisive Virdeel ze kréien. (200cp ≤ eval ≤ 600cp)';

  @override
  String get puzzleThemeAnastasiaMate => 'Anastasia-Matt';

  @override
  String get puzzleThemeAnastasiaMateDescription => 'E Sprénger an en Tuerm oder eng Damm schaffen zesummen fir de géigneresche Kinnek tëschent dem Rand vum Briet an enger vu senge Figuren matt ze setzen.';

  @override
  String get puzzleThemeArabianMate => 'Arabesche Matt';

  @override
  String get puzzleThemeArabianMateDescription => 'E Sprénger an en Turm schaffen zesummen fir de géigneresche Kinnek am Eck vum Briet matt ze setzen.';

  @override
  String get puzzleThemeAttackingF2F7 => 'Ugrëff op f2 oder f7';

  @override
  String get puzzleThemeAttackingF2F7Description => 'En Ugrëff den sech op d\'Baueren op f2 oder f7 konzentréiert, wéi z. B. bei der Fegatello-Variant.';

  @override
  String get puzzleThemeAttraction => 'Hinlenkung oder Magnéit';

  @override
  String get puzzleThemeAttractionDescription => 'En Oftausch oder Opfer datt eng géigneresch Figur ob e Feld invitéiert oder forcéiert datt eng Folgetaktik erlaabt.';

  @override
  String get puzzleThemeBackRankMate => 'Grondreiematt';

  @override
  String get puzzleThemeBackRankMateDescription => 'Setz de Kinnek op der Grondrei matt, wann en do vun sengen eegene Figuren ageklemmt ass.';

  @override
  String get puzzleThemeBishopEndgame => 'Leefer Endspill';

  @override
  String get puzzleThemeBishopEndgameDescription => 'En Endspill mat nëmmen Leefer a Baueren.';

  @override
  String get puzzleThemeBodenMate => 'Buedem-Matt';

  @override
  String get puzzleThemeBodenMateDescription => 'Zwee ugräifend Leefer op sech kräizegen Diagonalen setzen den Kinnek matt, deen duerch seng eege Figuren behënnert ass.';

  @override
  String get puzzleThemeCastling => 'Rochéieren';

  @override
  String get puzzleThemeCastlingDescription => 'Bréng de Kinnek a Sécherheet an den Tuerm op Ugrëffspositoun.';

  @override
  String get puzzleThemeCapturingDefender => 'Schlo de Verteideger';

  @override
  String get puzzleThemeCapturingDefenderDescription => 'D\'Schloen vun enger Figur, déi fir d\'Deckung vun enger anerer Figur zoustänneg war, soudass déi elo ongedeckten Figur mam nächsten Zuch kann geschloen ginn.';

  @override
  String get puzzleThemeCrushing => 'Vernichtend';

  @override
  String get puzzleThemeCrushingDescription => 'Fann d\'Gaffe vum Géigner, fir e vernichtenden Virdeel ze erhalen. (eval ≥ 600cp)';

  @override
  String get puzzleThemeDoubleBishopMate => 'Leeferpuermatt';

  @override
  String get puzzleThemeDoubleBishopMateDescription => 'Zwee ugräifend Leefer op niewenteneen leienden Diagonalen setzen den Kinnek matt, deen duerch seng eege Figuren behënnert ass.';

  @override
  String get puzzleThemeDovetailMate => 'Cozio-Matt';

  @override
  String get puzzleThemeDovetailMateDescription => 'Eng Damm setzt e niewestohende Kinnek matt, deem seng eenzeg zwee Fluchtfelder duerch seng eegen Figuren behënnert sinn.';

  @override
  String get puzzleThemeEquality => 'Egalitéit';

  @override
  String get puzzleThemeEqualityDescription => 'Komm aus enger verluerener Positioun zeréck a sécher dir e Remis oder ausgeglache Positioun. (eval ≤ 200cp)';

  @override
  String get puzzleThemeKingsideAttack => 'Ugrëff um Kinneksfligel';

  @override
  String get puzzleThemeKingsideAttackDescription => 'En Ugrëff op den géigneresche Kinnek, nodeem en op der Kinnekssäit rochéiert huet.';

  @override
  String get puzzleThemeClearance => 'Räumung';

  @override
  String get puzzleThemeClearanceDescription => 'En Zuch, meeschtens mat Tempo, deen de Wee ob e Feld, eng Linn oder eng Diagonal fräi mëscht an eng Folgetaktik erlaabt.';

  @override
  String get puzzleThemeDefensiveMove => 'Defensiven Zuch';

  @override
  String get puzzleThemeDefensiveMoveDescription => 'E prezisen Zuch oder eng Sequenz vun Zich, déi gespillt musse ginn fir keen Material oder Virdeel ze verléieren.';

  @override
  String get puzzleThemeDeflection => 'Oflenkung';

  @override
  String get puzzleThemeDeflectionDescription => 'En Zuch, deen eng géigneresch Figur vun enger anerer Aufgab oflenkt, wéi zum Beispill d\'Deckung vun engem wichtegen Feld. Heiansdo och \"Iwwerlaaschtung\" genannt.';

  @override
  String get puzzleThemeDiscoveredAttack => 'Ofzuchsugrëff';

  @override
  String get puzzleThemeDiscoveredAttackDescription => 'Eng Figur, déi den Ugrëff vun enger laangfeldreger Figur (zum Beispill en Tuerm) blockéiert, aus dem Wee beweegen.';

  @override
  String get puzzleThemeDoubleCheck => 'Dubbelschach';

  @override
  String get puzzleThemeDoubleCheckDescription => 'Schach mat zwou Figuren gläichzäiteg ginn als Resultat vun engem Ofzuchsugrëff, wou souwuel déi gespillte Figur ewéi och déi opgedeckte Figur de géigneresche Kinnek ugräifen.';

  @override
  String get puzzleThemeEndgame => 'Endspill';

  @override
  String get puzzleThemeEndgameDescription => 'Eng Taktik an der leschter Phase vun der Partie.';

  @override
  String get puzzleThemeEnPassantDescription => 'Eng Taktik bezüglech der \"en passant\" Reegel, bei där e Bauer e géigneresche Bauer schloen kann, deen un em mat engem Dubbelschrëtt aus der Ausgangspositioun laanscht gaangen ass.';

  @override
  String get puzzleThemeExposedKing => 'Exponéiert Kinnek';

  @override
  String get puzzleThemeExposedKingDescription => 'Eng Taktik bezüglech engem Kinnek, dee vun wéinege Figuren verdeedegt gëtt, wat oft zu Schachmatt féiert.';

  @override
  String get puzzleThemeFork => 'Forschett';

  @override
  String get puzzleThemeForkDescription => 'En Zuch, bei deem déi gespillte Figur zwou géigneresch Figuren gläichzäiteg ugräift.';

  @override
  String get puzzleThemeHangingPiece => 'Hänkend Figur';

  @override
  String get puzzleThemeHangingPieceDescription => 'Eng Taktik, bei där eng géignerescher Figur net oder ongenügend gedeckt ass an fräi ze schloen ass.';

  @override
  String get puzzleThemeHookMate => 'Hokenmatt';

  @override
  String get puzzleThemeHookMateDescription => 'Schachmatt mat engem Tuerm, Sprénger a Bauer zesummen mat engem géigneresche Bauer deen dem géigneresche Kinnek e Fluchtfeld hëlt.';

  @override
  String get puzzleThemeInterference => 'Ënnerbriechung';

  @override
  String get puzzleThemeInterferenceDescription => 'Eng Figur tëschent zwou géigneresch Figuren beweegen, fir eng oder béid géigneresch Figuren onverdeedegt ze loossen, wéi zum Beispill e Sprénger op engem verdeedegte Feld tëschent zwee Tierm.';

  @override
  String get puzzleThemeIntermezzo => 'Zwëschenzuch';

  @override
  String get puzzleThemeIntermezzoDescription => 'Amplaz den erwaardenen Zuch ze spillen, spill als éischt en Zuch deen eng direkt Bedroung poséiert, op deen de Géigner äntweren muss.';

  @override
  String get puzzleThemeKnightEndgame => 'Sprénger Endspill';

  @override
  String get puzzleThemeKnightEndgameDescription => 'En Endspill nëmmen mat Sprénger a Baueren.';

  @override
  String get puzzleThemeLong => 'Laang Aufgab';

  @override
  String get puzzleThemeLongDescription => 'Dräi Zich fir ze gewannen.';

  @override
  String get puzzleThemeMaster => 'Meeschter-Partien';

  @override
  String get puzzleThemeMasterDescription => 'Aufgabe aus Partie vu Spiller mat engem Titel.';

  @override
  String get puzzleThemeMasterVsMaster => 'Partië vu Meeschter géint Meeschter';

  @override
  String get puzzleThemeMasterVsMasterDescription => 'Aufgabe aus Partie tëschent zwee Spiller mat engem Titel.';

  @override
  String get puzzleThemeMate => 'Schachmatt';

  @override
  String get puzzleThemeMateDescription => 'Gewann d\'Partie mat Stil.';

  @override
  String get puzzleThemeMateIn1 => 'Matt an 1';

  @override
  String get puzzleThemeMateIn1Description => 'Mattsetzen an engem Zuch.';

  @override
  String get puzzleThemeMateIn2 => 'Matt an 2';

  @override
  String get puzzleThemeMateIn2Description => 'Mattsetzen an zwee Zich.';

  @override
  String get puzzleThemeMateIn3 => 'Matt an 3';

  @override
  String get puzzleThemeMateIn3Description => 'Mattsetzen an dräi Zich.';

  @override
  String get puzzleThemeMateIn4 => 'Matt a 4';

  @override
  String get puzzleThemeMateIn4Description => 'Mattsetzen a véier Zich.';

  @override
  String get puzzleThemeMateIn5 => 'Matt a 5 oder méi';

  @override
  String get puzzleThemeMateIn5Description => 'Fann eng laang Sequenz un Zich, déi schachmatt gëtt.';

  @override
  String get puzzleThemeMiddlegame => 'Mëttelspill';

  @override
  String get puzzleThemeMiddlegameDescription => 'Eng Taktik an der zweeter Phase vun der Partie.';

  @override
  String get puzzleThemeOneMove => 'Een-Zuch Aufgab';

  @override
  String get puzzleThemeOneMoveDescription => 'Eng Aufgab déi nëmmen een Zuch erfuerdert.';

  @override
  String get puzzleThemeOpening => 'Eröffnung';

  @override
  String get puzzleThemeOpeningDescription => 'Eng Taktik an der éischter Phase vun der Partie.';

  @override
  String get puzzleThemePawnEndgame => 'Baueren Endspill';

  @override
  String get puzzleThemePawnEndgameDescription => 'En Endspill mat just Baueren.';

  @override
  String get puzzleThemePin => 'Fesselung';

  @override
  String get puzzleThemePinDescription => 'Eng Taktik bezüglech Fesselungen, wou eng Figur sech net beweegen kann, ouni en Ugrëff op eng aner méi héichwäerteg Figur ze erlaben.';

  @override
  String get puzzleThemePromotion => 'Ëmwandlung';

  @override
  String get puzzleThemePromotionDescription => 'Wandel e Bauer zu enger Dame oder Liichtfigur ëm.';

  @override
  String get puzzleThemeQueenEndgame => 'Dammen Endspill';

  @override
  String get puzzleThemeQueenEndgameDescription => 'En Endspill mat just Dammen a Baueren.';

  @override
  String get puzzleThemeQueenRookEndgame => 'Damm an Tuerm';

  @override
  String get puzzleThemeQueenRookEndgameDescription => 'En Endspill nëmmen mat Dammen, Tierm a Baueren.';

  @override
  String get puzzleThemeQueensideAttack => 'Ugrëff um Dammefligel';

  @override
  String get puzzleThemeQueensideAttackDescription => 'En Ugrëff op de géigneresche Kinnek, nodeem en op der Dammesäit rochéiert huet.';

  @override
  String get puzzleThemeQuietMove => 'Rouegen Zuch';

  @override
  String get puzzleThemeQuietMoveDescription => 'En Zuch dee weder e Schach oder Schlagzuch ass oder eng direkt Drohung kréiert, mee eng verstoppte méi grouss Drohung virbereet.';

  @override
  String get puzzleThemeRookEndgame => 'Tuerm Endspill';

  @override
  String get puzzleThemeRookEndgameDescription => 'En Endspill nëmmen mat Tierm a Baueren.';

  @override
  String get puzzleThemeSacrifice => 'Opfer';

  @override
  String get puzzleThemeSacrificeDescription => 'Eng Taktik wou een kuerzfristeg Material opgëtt fir no enger forcéierter Sequenz laangfristeg e Virdeel ze hunn.';

  @override
  String get puzzleThemeShort => 'Kuerz Aufgab';

  @override
  String get puzzleThemeShortDescription => 'Zwee Zich fir ze gewannen.';

  @override
  String get puzzleThemeSkewer => 'Spiiss';

  @override
  String get puzzleThemeSkewerDescription => 'E Motiv mat enger wertvoller Figur déi ugegraff gëtt a beim Fortbeweegen erlaabt, dass eng manner wertvoll Figur hannendrunn ugegraff oder geschloe gëtt. Den Inverse vun enger Fesselung.';

  @override
  String get puzzleThemeSmotheredMate => 'Erstéckte Matt';

  @override
  String get puzzleThemeSmotheredMateDescription => 'E Schachmatt duerch e Sprénger deem den Kinnek net entkomme kann, well hien vun sengen eegenen Figuren ëmkreest (erstéckt) gëtt.';

  @override
  String get puzzleThemeSuperGM => 'Super-GM-Partien';

  @override
  String get puzzleThemeSuperGMDescription => 'Aufgabe vu Partie vun de beschte Spiller vun der Welt.';

  @override
  String get puzzleThemeTrappedPiece => 'Gefaange Figur';

  @override
  String get puzzleThemeTrappedPieceDescription => 'Eng Figur kann dem Schlagzuch net entkommen, well hir Zich begrenzt sinn.';

  @override
  String get puzzleThemeUnderPromotion => 'Ënnerwandlung';

  @override
  String get puzzleThemeUnderPromotionDescription => 'Ëmwandlung zu engem Sprénger, Leefer oder Tuerm.';

  @override
  String get puzzleThemeVeryLong => 'Ganz laang Aufgab';

  @override
  String get puzzleThemeVeryLongDescription => 'Véier oder méi Zich fir ze gewannen.';

  @override
  String get puzzleThemeXRayAttack => 'Rëntgen-Ugrëff';

  @override
  String get puzzleThemeXRayAttackDescription => 'Eng Figur attackéiert oder verdeedegte Feld duerch eng géigneresch Figur.';

  @override
  String get puzzleThemeZugzwang => 'Zugzwang';

  @override
  String get puzzleThemeZugzwangDescription => 'De Géigner huet eng begrenzten Unzuel un Zich an all Zuch verschlechtert seng Positioun.';

  @override
  String get puzzleThemeMix => 'Gesonde Mix';

  @override
  String get puzzleThemeMixDescription => 'E bësse vun allem. Du weess net wat dech erwaart, dowéinst muss op alles preparéiert sinn! Genau wéi bei echte Partien.';

  @override
  String get puzzleThemePlayerGames => 'Partie vu Spiller';

  @override
  String get puzzleThemePlayerGamesDescription => 'Sich no Aufgaben, déi aus denge Partien, oder aus de Partie vun anere Spiller generéiert goufen.';

  @override
  String puzzleThemePuzzleDownloadInformation(String param) {
    return 'Dës Aufgaben sinn ëffentlech zougänglech an kënnen ënner $param erofgelueden ginn.';
  }

  @override
  String get searchSearch => 'Sich';

  @override
  String get settingsSettings => 'Astellungen';

  @override
  String get settingsCloseAccount => 'Konto zoumaachen';

  @override
  String get settingsManagedAccountCannotBeClosed => 'Dësen Konto gëtt verwalt an kann net zougemaach ginn.';

  @override
  String get settingsClosingIsDefinitive => 'Zoumaachen ass definitiv. Et gëtt keen zeréck. Bass du sécher?';

  @override
  String get settingsCantOpenSimilarAccount => 'Du wäers keen Konto mam selwechten Numm können opmaachen, och mat anerer Grouss-/Klengschreiwung.';

  @override
  String get settingsChangedMindDoNotCloseAccount => 'Ech hun meng Meenung geännert, maacht mäin Konto net zou';

  @override
  String get settingsCloseAccountExplanation => 'Bass du secher dass du dësen Konto zoumaachen wëlls? En Konto zouzemaachen ass eng permanent Decisioun. Du wäers dech NIE MEI aloggen kënnen.';

  @override
  String get settingsThisAccountIsClosed => 'Dësen Konto ass zou.';

  @override
  String get playWithAFriend => 'Spill géint e Kolleeg';

  @override
  String get playWithTheMachine => 'Spill géint de Computer';

  @override
  String get toInviteSomeoneToPlayGiveThisUrl => 'Fir een an dës Partie z\'invitéieren, gëff ëm dëse Link';

  @override
  String get gameOver => 'Game Over';

  @override
  String get waitingForOpponent => 'Op de Géigner waarden';

  @override
  String get orLetYourOpponentScanQrCode => 'Oder looss däi Géigner dëse QR-Code scannen';

  @override
  String get waiting => 'Waarden';

  @override
  String get yourTurn => 'Du bass drun';

  @override
  String aiNameLevelAiLevel(String param1, String param2) {
    return '$param1 Level $param2';
  }

  @override
  String get level => 'Level';

  @override
  String get strength => 'Spillstäerkt';

  @override
  String get toggleTheChat => 'Chat uweisen/ausblenden';

  @override
  String get chat => 'So eppes';

  @override
  String get resign => 'Opginn';

  @override
  String get checkmate => 'Schachmatt';

  @override
  String get stalemate => 'Patt';

  @override
  String get white => 'Wäiss';

  @override
  String get black => 'Schwaarz';

  @override
  String get asWhite => 'mat Wäiss';

  @override
  String get asBlack => 'mat Schwaarz';

  @override
  String get randomColor => 'Zoufälleg Faarf';

  @override
  String get createAGame => 'Erstell eng Partie';

  @override
  String get whiteIsVictorious => 'Wäiss gewënnt';

  @override
  String get blackIsVictorious => 'Schwaarz gewënnt';

  @override
  String get youPlayTheWhitePieces => 'Du spills mat de wäisse Figuren';

  @override
  String get youPlayTheBlackPieces => 'Du spills mat de schwaarze Figuren';

  @override
  String get itsYourTurn => 'Et ass un dir!';

  @override
  String get cheatDetected => 'Bedruch erkannt';

  @override
  String get kingInTheCenter => 'Kinnek am Zentrum';

  @override
  String get threeChecks => 'Drëtt Kéier Schach';

  @override
  String get raceFinished => 'Course eriwwer';

  @override
  String get variantEnding => 'Enn vun der Variant';

  @override
  String get newOpponent => 'Neie Géigner';

  @override
  String get yourOpponentWantsToPlayANewGameWithYou => 'Däin Géigner wëll eng nei Partie mat dir spillen';

  @override
  String get joinTheGame => 'Triet der Partie bäi';

  @override
  String get whitePlays => 'Wäiss um Zuch';

  @override
  String get blackPlays => 'Schwaarz um Zuch';

  @override
  String get opponentLeftChoices => 'Däin Géigner huet d\'Partie verlooss. Du kanns d\'Victoire reklaméieren, Remis erklären, oder waarden.';

  @override
  String get forceResignation => 'Victoire reklaméieren';

  @override
  String get forceDraw => 'Remis erklären';

  @override
  String get talkInChat => 'Wannechgelift sief frëndlech am Chat!';

  @override
  String get theFirstPersonToComeOnThisUrlWillPlayWithYou => 'Di éischt Persoun déi dëst URL oprifft wäert däin Géigner sinn.';

  @override
  String get whiteResigned => 'Wäiss huet opginn';

  @override
  String get blackResigned => 'Schwaarz huet opginn';

  @override
  String get whiteLeftTheGame => 'Wäiss huet d\'Partie verlooss';

  @override
  String get blackLeftTheGame => 'Schwaarz huet d\'Partie verlooss';

  @override
  String get whiteDidntMove => 'Wäiss huet net gezunn';

  @override
  String get blackDidntMove => 'Schwaarz huet net gezunn';

  @override
  String get requestAComputerAnalysis => 'Eng Computeranalys ufroen';

  @override
  String get computerAnalysis => 'Computeranalys';

  @override
  String get computerAnalysisAvailable => 'Computeranalys disponibel';

  @override
  String get computerAnalysisDisabled => 'Computeranalys desaktivéiert';

  @override
  String get analysis => 'Analysebriet';

  @override
  String depthX(String param) {
    return 'Déift $param';
  }

  @override
  String get usingServerAnalysis => 'Serveranalys gëtt benotzt';

  @override
  String get loadingEngine => 'Engine luet...';

  @override
  String get calculatingMoves => 'Zich ginn gerechent...';

  @override
  String get engineFailed => 'Feeler beim Lueden';

  @override
  String get cloudAnalysis => 'Cloudanalys';

  @override
  String get goDeeper => 'Déift eropsetzen';

  @override
  String get showThreat => 'Bedroung weisen';

  @override
  String get inLocalBrowser => 'am lokalen Browser';

  @override
  String get toggleLocalEvaluation => 'Lokal Computeranalys aktivéieren/desaktivéieren';

  @override
  String get promoteVariation => 'Variant opwäerten';

  @override
  String get makeMainLine => 'Haaptvariant maachen';

  @override
  String get deleteFromHere => 'Vun hei läschen';

  @override
  String get collapseVariations => 'Varianten zesummeklappen';

  @override
  String get expandVariations => 'Varianten opklappen';

  @override
  String get forceVariation => 'Variant forcéieren';

  @override
  String get copyVariationPgn => 'PGN-Variant kopéieren';

  @override
  String get move => 'Zuch';

  @override
  String get variantLoss => 'Variant verluer';

  @override
  String get variantWin => 'Variant gewonn';

  @override
  String get insufficientMaterial => 'Ongenügend Material';

  @override
  String get pawnMove => 'Baueren Zuch';

  @override
  String get capture => 'Schlagzuch';

  @override
  String get close => 'Zoumaachen';

  @override
  String get winning => 'Gewënnt';

  @override
  String get losing => 'Verléiert';

  @override
  String get drawn => 'Remis';

  @override
  String get unknown => 'Onbekannt';

  @override
  String get database => 'Datebank';

  @override
  String get whiteDrawBlack => 'Wäiss / Remis / Schwaarz';

  @override
  String averageRatingX(String param) {
    return 'Duerchschnëttlech Wäertung: $param';
  }

  @override
  String get recentGames => 'Rezent Partien';

  @override
  String get topGames => 'Top Partien';

  @override
  String masterDbExplanation(String param1, String param2, String param3) {
    return 'Zwou Milliounen OTB Partien vun $param1+ FIDE-gewäerteten Spiller vun $param2 bis $param3';
  }

  @override
  String get dtzWithRounding => 'DTZ50\'\' mat Ronnung, baséierend ob Unzuel vun Hallefzich bis zum nächsten Schlag- oder Bauerenzuch';

  @override
  String get noGameFound => 'Keng Partie fonnt';

  @override
  String get maxDepthReached => 'Maximal Déift erreecht!';

  @override
  String get maybeIncludeMoreGamesFromThePreferencesMenu => 'Villäicht mussen méi Partien iwert den Astellungsmenü consideréiert ginn?';

  @override
  String get openings => 'Erëffnungen';

  @override
  String get openingExplorer => 'Erëffnungsdatebank';

  @override
  String get openingEndgameExplorer => 'Erëffnungs-/Endspilldatebank';

  @override
  String xOpeningExplorer(String param) {
    return '$param -Erëffnungsdatebank';
  }

  @override
  String get playFirstOpeningEndgameExplorerMove => 'Spill den éischten Zuch vun der Erëffnungs-/Endspill-Datebank';

  @override
  String get winPreventedBy50MoveRule => 'Victoire verhënnert duerch 50-Zich-Reegel';

  @override
  String get lossSavedBy50MoveRule => 'Defaite verhënnert duerch 50-Zich-Reegel';

  @override
  String get winOr50MovesByPriorMistake => 'Victoire oder 50 Zich duerch fréiere Feeler';

  @override
  String get lossOr50MovesByPriorMistake => 'Defaite oder 50 Zich duerch fréiere Feeler';

  @override
  String get unknownDueToRounding => 'Victoire/Defaite just garantéiert wann Tablebase Variant säit leschtem Schlag- oder Bauerenzuch gespillt gouf, wéinst méiglechem Ronnungsfeeler.';

  @override
  String get allSet => 'Prett!';

  @override
  String get importPgn => 'PGN importéieren';

  @override
  String get delete => 'Läschen';

  @override
  String get deleteThisImportedGame => 'Importéiert Partie läschen?';

  @override
  String get replayMode => 'Replay-Modus';

  @override
  String get realtimeReplay => 'Echtzäit';

  @override
  String get byCPL => 'No CPL';

  @override
  String get enable => 'Aktivéieren';

  @override
  String get bestMoveArrow => 'Beschten Zuch Feil';

  @override
  String get showVariationArrows => 'Variantefeiler weisen';

  @override
  String get evaluationGauge => 'Evaluatioun weisen';

  @override
  String get multipleLines => 'Méi Varianten';

  @override
  String get cpus => 'CPUs';

  @override
  String get memory => 'Aarbechtsspäicher';

  @override
  String get infiniteAnalysis => 'Endlos Analys';

  @override
  String get removesTheDepthLimit => 'Entfernt d\'Déifenbegrenzung an hält däin Computer waarm';

  @override
  String get blunder => 'Gaffe';

  @override
  String get mistake => 'Feeler';

  @override
  String get inaccuracy => 'Ongenauegkeet';

  @override
  String get moveTimes => 'Zuchzäiten';

  @override
  String get flipBoard => 'Briet dréinen';

  @override
  String get threefoldRepetition => 'Dräifach Widderhuelung';

  @override
  String get claimADraw => 'Remis reklaméieren';

  @override
  String get offerDraw => 'Remis bidden';

  @override
  String get draw => 'Remis';

  @override
  String get drawByMutualAgreement => 'Remis duerch Eenegung';

  @override
  String get fiftyMovesWithoutProgress => '50 Zich ouni Progrès';

  @override
  String get currentGames => 'Lafend Partien';

  @override
  String get viewInFullSize => 'An voller Gréisst ukucken';

  @override
  String get logOut => 'Ofmellen';

  @override
  String get signIn => 'Umellen';

  @override
  String get rememberMe => 'Ageloggt bleiwen';

  @override
  String get youNeedAnAccountToDoThat => 'Du brauchs een Account fir dat ze maachen';

  @override
  String get signUp => 'Registréieren';

  @override
  String get computersAreNotAllowedToPlay => 'Ënnerstëtzung vun Schachprogrammen, Datenbanken oder aneren Spiller ass wärend enger Partie net erlaabt. Wannechgelift bedenkt och, dass d\'Creatioun vun puer Benotzerkonten ongären gesinn ass and d\'Missachtung vun dëser Reegel, bis op Kulanz vun der Ekipp, zum Ausschloss aller betraffenen Konten féiert.';

  @override
  String get games => 'Partien';

  @override
  String get forum => 'Forum';

  @override
  String xPostedInForumY(String param1, String param2) {
    return '$param1 huet zum Thema $param2 geschriwwen';
  }

  @override
  String get latestForumPosts => 'Neisten Forumbäiträg';

  @override
  String get players => 'Spiller';

  @override
  String get friends => 'Kolleegen';

  @override
  String get otherPlayers => 'aner Spiller';

  @override
  String get discussions => 'Konversatiounen';

  @override
  String get today => 'Haut';

  @override
  String get yesterday => 'Gëschter';

  @override
  String get minutesPerSide => 'Minutten pro Säit';

  @override
  String get variant => 'Variant';

  @override
  String get variants => 'Varianten';

  @override
  String get timeControl => 'Zäitkontroll';

  @override
  String get realTime => 'Echtzäit';

  @override
  String get correspondence => 'Korrespondenz';

  @override
  String get daysPerTurn => 'Deeg pro Zuch';

  @override
  String get oneDay => 'Een Dag';

  @override
  String get time => 'Zäit';

  @override
  String get rating => 'Wäertung';

  @override
  String get ratingStats => 'Wäertungsstatistiken';

  @override
  String get username => 'Benotzernumm';

  @override
  String get usernameOrEmail => 'Benotzernumm oder Email';

  @override
  String get changeUsername => 'Benotzernumm änneren';

  @override
  String get changeUsernameNotSame => 'Just Grouss-/Klengschreiwung kann geännert ginn. Zum Beispill \"johndoe\" zu \"JohnDoe\".';

  @override
  String get changeUsernameDescription => 'Änner däin Benotzernumm. Dat kann just eemol gemaach ginn an just d\'Grouss-/Klengschreiwung vun den Buschtawen am Benotzernumm kann geännert ginn.';

  @override
  String get signupUsernameHint => 'Wielt wannechgelifft een familienfrëndlechen Benotzernumm. Den Numm kann dono net méi geännert ginn an Accounts mat onugebruechten Benotzernimm ginn zougemaach!';

  @override
  String get signupEmailHint => 'Mir benotzen se just fir Passwuert Resets.';

  @override
  String get password => 'Passwuert';

  @override
  String get changePassword => 'Passwuert änneren';

  @override
  String get changeEmail => 'Email änneren';

  @override
  String get email => 'Email';

  @override
  String get passwordReset => 'Passwuert zerécksetzen';

  @override
  String get forgotPassword => 'Passwuert vergiess?';

  @override
  String get error_weakPassword => 'Dëst Passwuert ass extrem heefeg an einfach ze roden.';

  @override
  String get error_namePassword => 'Wannechgelifft benotz net däin Benotzernumm als Passwuert.';

  @override
  String get blankedPassword => 'Du hues dat selwecht Passwuert ob enger anerer Säit benotzt déi kompromettéiert gouf. Fir d\'Secherheet vun dengem Lichess Konto ze assuréieren muss du en neit Passwuert wielen. Merci fir däi Versteesdemech.';

  @override
  String get youAreLeavingLichess => 'Du verléiss Lichess';

  @override
  String get neverTypeYourPassword => 'Gëff däin Lichess Passwuert nie ob enger anerer Säit an!';

  @override
  String proceedToX(String param) {
    return 'Weider op $param';
  }

  @override
  String get passwordSuggestion => 'Benotz kee Passwuert, dat een aneren dir virschleit. Et kéint probéiert ginn däin Konto ze klauen.';

  @override
  String get emailSuggestion => 'Benotz keng Email-Adress, déi een aneren dir virschleit. Et kéint probéiert ginn däin Konto ze klauen.';

  @override
  String get emailConfirmHelp => 'Hëllef bei der Email Confirmatioun';

  @override
  String get emailConfirmNotReceived => 'Huet dir keng Confirmatiouns Email kritt nom Umellen?';

  @override
  String get whatSignupUsername => 'Mat wéiengem Benotzernumm huet dir iech ugemellt?';

  @override
  String usernameNotFound(String param) {
    return 'Mir konnten keen Konto mat dësem Numm fannen: $param.';
  }

  @override
  String get usernameCanBeUsedForNewAccount => 'Dir kënnt mat dësen Benotzernumm en neien Konto kreéieren';

  @override
  String emailSent(String param) {
    return 'Mir hunn eng Email geschéckt un $param.';
  }

  @override
  String get emailCanTakeSomeTime => 'Et kéint kuerz daueren bis se ukënnt.';

  @override
  String get refreshInboxAfterFiveMinutes => 'Waart 5 Minutten an aktualiséiert är Email Inbox.';

  @override
  String get checkSpamFolder => 'Iwwerpréift och wannechgelift ären Spam Uerdner, falls se do ukënnt. Markéiert se an dësem Fall als net Spam.';

  @override
  String get emailForSignupHelp => 'Falls et nach ëmmer net geet, schéckt eis dës Email:';

  @override
  String copyTextToEmail(String param) {
    return 'Kopéiert an colléiert dësen Text an schéckt en un $param';
  }

  @override
  String get waitForSignupHelp => 'Mir wäerten iech sou schnell wéi méiglech äntferen an är Umellung komplétéieren.';

  @override
  String accountConfirmed(String param) {
    return 'The Benotzer $param gouf mat Succès confirméiert.';
  }

  @override
  String accountCanLogin(String param) {
    return 'Dir kënnt iech elo aloggen als $param.';
  }

  @override
  String get accountConfirmationEmailNotNeeded => 'Dir braucht keng Confirmatiouns Email.';

  @override
  String accountClosed(String param) {
    return 'De Konto $param ass zou.';
  }

  @override
  String accountRegisteredWithoutEmail(String param) {
    return 'De Konto $param gouf ouni Email registréiert.';
  }

  @override
  String get rank => 'Rang';

  @override
  String rankX(String param) {
    return 'Rang: $param';
  }

  @override
  String get gamesPlayed => 'Partien gespillt';

  @override
  String get ok => 'OK';

  @override
  String get cancel => 'Annuléieren';

  @override
  String get whiteTimeOut => 'Zäitiwwerschreidung vu Wäiss';

  @override
  String get blackTimeOut => 'Zäitiwwerschreidung vu Schwaarz';

  @override
  String get drawOfferSent => 'Remis-Offer geschéckt';

  @override
  String get drawOfferAccepted => 'Remis-Offer ugeholl';

  @override
  String get drawOfferCanceled => 'Remis-Offer annuléiert';

  @override
  String get whiteOffersDraw => 'Wäiss bitt Remis';

  @override
  String get blackOffersDraw => 'Schwaarz bitt Remis';

  @override
  String get whiteDeclinesDraw => 'Wäiss leent Remis of';

  @override
  String get blackDeclinesDraw => 'Schwaarz leent Remis of';

  @override
  String get yourOpponentOffersADraw => 'Däi Géigner bitt Remis';

  @override
  String get accept => 'Acceptéieren';

  @override
  String get decline => 'Ofleenen';

  @override
  String get playingRightNow => 'Partie leeft';

  @override
  String get eventInProgress => 'Partien lafen';

  @override
  String get finished => 'Fäerdeg';

  @override
  String get abortGame => 'Partie ofbriechen';

  @override
  String get gameAborted => 'Partie ofgebrach';

  @override
  String get standard => 'Standard';

  @override
  String get customPosition => 'Benotzerdefinéiert Stellung';

  @override
  String get unlimited => 'Illimitéiert';

  @override
  String get mode => 'Modus';

  @override
  String get casual => 'Ongewäert';

  @override
  String get rated => 'Gewäert';

  @override
  String get casualTournament => 'Ongewäert';

  @override
  String get ratedTournament => 'Gewäert';

  @override
  String get thisGameIsRated => 'Dës Partie ass gewäert';

  @override
  String get rematch => 'Revanche';

  @override
  String get rematchOfferSent => 'Revanche-Offer geschéckt';

  @override
  String get rematchOfferAccepted => 'Revanche-Offer ugeholl';

  @override
  String get rematchOfferCanceled => 'Revanche-Offer annuléiert';

  @override
  String get rematchOfferDeclined => 'Revanche-Offer ofgeleent';

  @override
  String get cancelRematchOffer => 'Revanche-Offer annuléieren';

  @override
  String get viewRematch => 'Revanche ukucken';

  @override
  String get confirmMove => 'Zuch confirméieren';

  @override
  String get play => 'Spillen';

  @override
  String get inbox => 'Posteingang';

  @override
  String get chatRoom => 'Chatraum';

  @override
  String get loginToChat => 'An Chat aloggen';

  @override
  String get youHaveBeenTimedOut => 'Du krus eng Auszeit.';

  @override
  String get spectatorRoom => 'Spectateur Raum';

  @override
  String get composeMessage => 'Message schreiwen';

  @override
  String get subject => 'Betreff';

  @override
  String get send => 'Schécken';

  @override
  String get incrementInSeconds => 'Inkrement a Sekonnen';

  @override
  String get freeOnlineChess => 'Gratis Online Schach';

  @override
  String get exportGames => 'Partien exportéieren';

  @override
  String get ratingRange => 'Wäertungsberäich';

  @override
  String get thisAccountViolatedTos => 'Dësen Konto huet géint d\'Lichess-Notzungsbedingungen verstouss';

  @override
  String get openingExplorerAndTablebase => 'Eröffnungsdatenbank & Tablebase';

  @override
  String get takeback => 'Zeréckhuelen';

  @override
  String get proposeATakeback => 'Zeréckhuelen virschloen';

  @override
  String get takebackPropositionSent => 'Zeréckhuelen geschéckt';

  @override
  String get takebackPropositionDeclined => 'Zeréckhuelen ofgeleent';

  @override
  String get takebackPropositionAccepted => 'Zeréckhuelen ugeholl';

  @override
  String get takebackPropositionCanceled => 'Zeréckhuelen annuléiert';

  @override
  String get yourOpponentProposesATakeback => 'Däin Géigner schléit en Zeréckhuelen fir';

  @override
  String get bookmarkThisGame => 'Dës Partie als Lieszeeche späicheren';

  @override
  String get tournament => 'Turnéier';

  @override
  String get tournaments => 'Turnéier';

  @override
  String get tournamentPoints => 'Turnéierpunkten';

  @override
  String get viewTournament => 'Turnéier ukucken';

  @override
  String get backToTournament => 'Zeréck bei den Turnéier';

  @override
  String get noDrawBeforeSwissLimit => 'Du kanns an engem Schwäizer Turnéier keen Remis offréieren virum 30ten Zuch.';

  @override
  String get thematic => 'Thematesch';

  @override
  String yourPerfRatingIsProvisional(String param) {
    return 'Deng $param Wäertung ass provisoresch';
  }

  @override
  String yourPerfRatingIsTooHigh(String param1, String param2) {
    return 'Deng $param1 Wäertung ($param2) ass ze héich';
  }

  @override
  String yourTopWeeklyPerfRatingIsTooHigh(String param1, String param2) {
    return 'Deng wöchentlech Top $param1 Wäertung ($param2) ass ze héich';
  }

  @override
  String yourPerfRatingIsTooLow(String param1, String param2) {
    return 'Deng $param1 Wäertung ($param2) ass ze niddreg';
  }

  @override
  String ratedMoreThanInPerf(String param1, String param2) {
    return 'Wäertung ≥ $param1 an $param2';
  }

  @override
  String ratedLessThanInPerf(String param1, String param2) {
    return 'Wäertung ≤ $param1 an $param2 an der leschter Woch';
  }

  @override
  String mustBeInTeam(String param) {
    return 'Muss Member vun $param sin';
  }

  @override
  String youAreNotInTeam(String param) {
    return 'Du bass net Member vun $param';
  }

  @override
  String get backToGame => 'Zeréck bei Partie';

  @override
  String get siteDescription => 'Gratis Online Schach Server. Spill Schach an engem propperen Interface. Keng Registratioun, keng Reklammen, keen Plugin néideg. Spill Schach géint Computer, Frënn oder zoufälleg Géigner.';

  @override
  String xJoinedTeamY(String param1, String param2) {
    return '$param1 ass Ekipp $param2 beigetrueden';
  }

  @override
  String xCreatedTeamY(String param1, String param2) {
    return '$param1 huet Ekipp $param2 gegrënnt';
  }

  @override
  String get startedStreaming => 'huet ugefang ze streamen';

  @override
  String xStartedStreaming(String param) {
    return '$param huet en Stream gestart';
  }

  @override
  String get averageElo => 'Duerchschnëttlech Wäertung';

  @override
  String get location => 'Standuert';

  @override
  String get filterGames => 'Partien filteren';

  @override
  String get reset => 'Zerécksetzen';

  @override
  String get apply => 'Uwenden';

  @override
  String get save => 'Späicheren';

  @override
  String get leaderboard => 'Ranglëscht';

  @override
  String get screenshotCurrentPosition => 'Aktuell Positioun screenshotten';

  @override
  String get gameAsGIF => 'Partie als GIF';

  @override
  String get pasteTheFenStringHere => 'FEN Text hei afügen';

  @override
  String get pasteThePgnStringHere => 'PGN Text hei afügen';

  @override
  String get orUploadPgnFile => 'Oder PGN Datei héichlueden';

  @override
  String get fromPosition => 'Aus Positioun';

  @override
  String get continueFromHere => 'Vun hei weiderspillen';

  @override
  String get toStudy => 'Etüd';

  @override
  String get importGame => 'Partie importéieren';

  @override
  String get importGameExplanation => 'Füg eng Partien PGN an fir en browsbaren Replay, Computer Analyse, Partienchat and eng deelbar URL ze kréien.';

  @override
  String get importGameCaveat => 'Varianten wäerten geläscht ginn. Fir se ze haalen, importéier d\'PGN an eng Etüd.';

  @override
  String get importGameDataPrivacyWarning => 'This PGN can be accessed by the public. To import a game privately, use a study.';

  @override
  String get thisIsAChessCaptcha => 'Dat hei ass en Schach CAPTCHA.';

  @override
  String get clickOnTheBoardToMakeYourMove => 'Klick op d\'Briet an maach däin Zuch fir ze weisen, dass du en Mënsch bass.';

  @override
  String get captcha_fail => 'Wannechgelift léis den Schach captcha.';

  @override
  String get notACheckmate => 'Keen Schachmatt';

  @override
  String get whiteCheckmatesInOneMove => 'Wäiss huet Schachmatt an engem Zuch';

  @override
  String get blackCheckmatesInOneMove => 'Schwaarz huet Schachmatt an engem Zuch';

  @override
  String get retry => 'Nei probéieren';

  @override
  String get reconnecting => 'Remverbannen';

  @override
  String get noNetwork => 'Offline';

  @override
  String get favoriteOpponents => 'Liblingsgéigner';

  @override
  String get follow => 'Followen';

  @override
  String get following => 'Folgend';

  @override
  String get unfollow => 'Unfollowen';

  @override
  String followX(String param) {
    return 'Dem $param followen';
  }

  @override
  String unfollowX(String param) {
    return 'Dem $param net méi followen';
  }

  @override
  String get block => 'Blockéieren';

  @override
  String get blocked => 'Geblockt';

  @override
  String get unblock => 'Spär ophiewen';

  @override
  String xStartedFollowingY(String param1, String param2) {
    return '$param1 followt elo $param2';
  }

  @override
  String get more => 'Méi';

  @override
  String get memberSince => 'Member säit';

  @override
  String lastSeenActive(String param) {
    return 'Aktiv $param';
  }

  @override
  String get player => 'Spiller';

  @override
  String get list => 'Lëscht';

  @override
  String get graph => 'Grafik';

  @override
  String get required => 'Obligatoresch.';

  @override
  String get openTournaments => 'Oppen Turnéier';

  @override
  String get duration => 'Dauer';

  @override
  String get winner => 'Gewënner';

  @override
  String get standing => 'Plaz';

  @override
  String get createANewTournament => 'Neien Turnéier kreéieren';

  @override
  String get tournamentCalendar => 'Turnéier Kalenner';

  @override
  String get conditionOfEntry => 'Teilnahmebedingung:';

  @override
  String get advancedSettings => 'Erweidert Astellungen';

  @override
  String get safeTournamentName => 'Wiehl en ganz sécheren Numm fir däin Turnéier.';

  @override
  String get inappropriateNameWarning => 'Alles nemmen liicht Onangemessenes kéint zum Zoumaachen vun dengem Konto féieren.';

  @override
  String get emptyTournamentName => 'Eidel loossen, wann den Turnéier no engem bekannten Schachspiller soll benannt ginn.';

  @override
  String get makePrivateTournament => 'Turnéier privat maachen an Accès mat Passwuert beschränken';

  @override
  String get join => 'Bäitrieden';

  @override
  String get withdraw => 'Zeréckzéihen';

  @override
  String get points => 'Punkten';

  @override
  String get wins => 'Victoiren';

  @override
  String get losses => 'Defaiten';

  @override
  String get createdBy => 'Kreéiert vum';

  @override
  String get tournamentIsStarting => 'Den Turnéier geet lass';

  @override
  String get tournamentPairingsAreNowClosed => 'Turnéierpaarungen sin elo zou.';

  @override
  String standByX(String param) {
    return 'Turnéier-Paarungen lafen. Maach dech prett, $param!';
  }

  @override
  String get pause => 'Paus';

  @override
  String get resume => 'Weider';

  @override
  String get youArePlaying => 'Deng Partie geet lass!';

  @override
  String get winRate => 'Gewënnrate';

  @override
  String get berserkRate => 'Berserkrate';

  @override
  String get performance => 'Performance';

  @override
  String get tournamentComplete => 'Turnéier fäerdeg';

  @override
  String get movesPlayed => 'Zich gespillt';

  @override
  String get whiteWins => 'Wäiss Victoiren';

  @override
  String get blackWins => 'Schwaarz Victoiren';

  @override
  String get drawRate => 'Remisquot';

  @override
  String get draws => 'Remis';

  @override
  String nextXTournament(String param) {
    return 'Nächsten $param Turnéier:';
  }

  @override
  String get averageOpponent => 'Duerchschnëttleche Géigner';

  @override
  String get boardEditor => 'Briet-Editor';

  @override
  String get setTheBoard => 'Briet opbauen';

  @override
  String get popularOpenings => 'Beléift Erëffnungen';

  @override
  String get endgamePositions => 'Endspill Positiounen';

  @override
  String chess960StartPosition(String param) {
    return 'Chess960 Start Positioun: $param';
  }

  @override
  String get startPosition => 'Ausgangsstellung';

  @override
  String get clearBoard => 'Briet opraumen';

  @override
  String get loadPosition => 'Stellung lueden';

  @override
  String get isPrivate => 'Privat';

  @override
  String reportXToModerators(String param) {
    return '$param den Moderatoren mellen';
  }

  @override
  String profileCompletion(String param) {
    return 'Profil vollstänneg zu: $param';
  }

  @override
  String xRating(String param) {
    return '$param Wäertung';
  }

  @override
  String get ifNoneLeaveEmpty => 'Eidel loossen, falls keng';

  @override
  String get profile => 'Profil';

  @override
  String get editProfile => 'Profil änneren';

  @override
  String get realName => 'Richtegen Numm';

  @override
  String get setFlair => 'Set your flair';

  @override
  String get flair => 'Flair';

  @override
  String get youCanHideFlair => 'There is a setting to hide all user flairs across the entire site.';

  @override
  String get biography => 'Biographie';

  @override
  String get countryRegion => 'Land oder Regioun';

  @override
  String get thankYou => 'Merci!';

  @override
  String get socialMediaLinks => 'Sozial Medien Links';

  @override
  String get oneUrlPerLine => 'Eng URL pro Zeil.';

  @override
  String get inlineNotation => 'Inline-Notatioun';

  @override
  String get makeAStudy => 'Fir Varianten laangfristeg ze haalen an ze deelen, consideréier eng Etüd ze kreéieren.';

  @override
  String get clearSavedMoves => 'Zich läschen';

  @override
  String get previouslyOnLichessTV => 'Virdrun op Lichess TV';

  @override
  String get onlinePlayers => 'Online Spiller';

  @override
  String get activePlayers => 'Aktiv Spiller';

  @override
  String get bewareTheGameIsRatedButHasNoClock => 'Pass op, d\'Partie ass gewäert mee huet keng Auer!';

  @override
  String get success => 'Succès';

  @override
  String get automaticallyProceedToNextGameAfterMoving => 'Automatesch bei déi nächst Partie goen nom Zéien';

  @override
  String get autoSwitch => 'Auto switch';

  @override
  String get puzzles => 'Aufgaben';

  @override
  String get onlineBots => 'Online-Botten';

  @override
  String get name => 'Numm';

  @override
  String get description => 'Beschreiwung';

  @override
  String get descPrivate => 'Privat Beschreiwung';

  @override
  String get descPrivateHelp => 'Text deen just Ekippenmemberen wäerten gesinn. Falls agestallt, ersetzt en fir Memberen d\'ëffentlech Beschreiwung.';

  @override
  String get no => 'Nee';

  @override
  String get yes => 'Jo';

  @override
  String get website => 'Websäit';

  @override
  String get mobile => 'Mobile';

  @override
  String get help => 'Hëllef:';

  @override
  String get createANewTopic => 'Neien Thema kreéieren';

  @override
  String get topics => 'Themen';

  @override
  String get posts => 'Bäiträg';

  @override
  String get lastPost => 'Leschten Beitrag';

  @override
  String get views => 'Besich';

  @override
  String get replies => 'Äntwerten';

  @override
  String get replyToThisTopic => 'Op dësen Thema äntweren';

  @override
  String get reply => 'Äntwert';

  @override
  String get message => 'Message';

  @override
  String get createTheTopic => 'Thema erstellen';

  @override
  String get reportAUser => 'Benotzer mellen';

  @override
  String get user => 'Benotzer';

  @override
  String get reason => 'Grond';

  @override
  String get whatIsIheMatter => 'Wat ass den Problem?';

  @override
  String get cheat => 'Bedruch';

  @override
  String get troll => 'Troll';

  @override
  String get other => 'Aner';

  @override
  String get reportCheatBoostHelp => 'Paste the link to the game(s) and explain what is wrong about this user\'s behaviour. Don\'t just say \"they cheat\", but tell us how you came to this conclusion.';

  @override
  String get reportUsernameHelp => 'Explain what about this username is offensive. Don\'t just say \"it\'s offensive/inappropriate\", but tell us how you came to this conclusion, especially if the insult is obfuscated, not in english, is in slang, or is a historical/cultural reference.';

  @override
  String get reportProcessedFasterInEnglish => 'Your report will be processed faster if written in English.';

  @override
  String get error_provideOneCheatedGameLink => 'Wannechgelift gëff eis op mannst een Link zu enger Partie mat Bedruch.';

  @override
  String by(String param) {
    return 'vum $param';
  }

  @override
  String importedByX(String param) {
    return 'Importéiert vun $param';
  }

  @override
  String get thisTopicIsNowClosed => 'Dësen Thema ass elo zou.';

  @override
  String get blog => 'Blog';

  @override
  String get notes => 'Notten';

  @override
  String get typePrivateNotesHere => 'Schreiw hei deng privat Notten';

  @override
  String get writeAPrivateNoteAboutThisUser => 'Schreiw eng privat Notiz iwwert dësen Benotzer';

  @override
  String get noNoteYet => 'Nach keng Notiz';

  @override
  String get invalidUsernameOrPassword => 'Ongëltege Benotzernumm oder Passwuert';

  @override
  String get incorrectPassword => 'Inkorrekt Passwuert';

  @override
  String get invalidAuthenticationCode => 'Ongëltegen Authentifizéierungscode';

  @override
  String get emailMeALink => 'Email mir en Link';

  @override
  String get currentPassword => 'Aktuellt Passwuert';

  @override
  String get newPassword => 'Neit Passwuert';

  @override
  String get newPasswordAgain => 'Neit Passwuert (nach eng Kéier)';

  @override
  String get newPasswordsDontMatch => 'Déi nei Passwierder sinn net identesch';

  @override
  String get newPasswordStrength => 'Passwuert Stäerkt';

  @override
  String get clockInitialTime => 'Auer Initial Zäit';

  @override
  String get clockIncrement => 'Auer-Inkrement';

  @override
  String get privacy => 'Privatsphär';

  @override
  String get privacyPolicy => 'Datenschutzbestëmmung';

  @override
  String get letOtherPlayersFollowYou => 'Anerer kënnen dir followen';

  @override
  String get letOtherPlayersChallengeYou => 'Anerer kënnen dech erausfuerderen';

  @override
  String get letOtherPlayersInviteYouToStudy => 'Anerer kënnen dech an eng Etüd invitéieren';

  @override
  String get sound => 'Toun';

  @override
  String get none => 'Keng';

  @override
  String get fast => 'Schnell';

  @override
  String get normal => 'Normal';

  @override
  String get slow => 'Lues';

  @override
  String get insideTheBoard => 'Um Briet';

  @override
  String get outsideTheBoard => 'Außerhalb vum Briet';

  @override
  String get allSquaresOfTheBoard => 'All d\'Felder um Briet';

  @override
  String get onSlowGames => 'An luesen Partien';

  @override
  String get always => 'Ëmmer';

  @override
  String get never => 'Ni';

  @override
  String xCompetesInY(String param1, String param2) {
    return '$param1 hëlt deel bei $param2';
  }

  @override
  String get victory => 'Victoire';

  @override
  String get defeat => 'Defaite';

  @override
  String victoryVsYInZ(String param1, String param2, String param3) {
    return '$param1 vs $param2 an $param3';
  }

  @override
  String defeatVsYInZ(String param1, String param2, String param3) {
    return '$param1 vs $param2 an $param3';
  }

  @override
  String drawVsYInZ(String param1, String param2, String param3) {
    return '$param1 vs $param2 an $param3';
  }

  @override
  String get timeline => 'Verlaf';

  @override
  String get starting => 'Start:';

  @override
  String get allInformationIsPublicAndOptional => 'All Infourmatioun ass ëffentlech an optional.';

  @override
  String get biographyDescription => 'Erziehl eppes iwer dech, deng Interessen, wat dir um Schach gefällt, deng Lieblingseröffnungen oder -spiller, ...';

  @override
  String get listBlockedPlayers => 'Geblockt Spiller oplëschten';

  @override
  String get human => 'Mënsch';

  @override
  String get computer => 'Computer';

  @override
  String get side => 'Säit';

  @override
  String get clock => 'Auer';

  @override
  String get opponent => 'Géigner';

  @override
  String get learnMenu => 'Léieren';

  @override
  String get studyMenu => 'Etüden';

  @override
  String get practice => 'Üben';

  @override
  String get community => 'Gemeinschaft';

  @override
  String get tools => 'Tools';

  @override
  String get increment => 'Inkrement';

  @override
  String get error_unknown => 'Ongültegen Wäert';

  @override
  String get error_required => 'Dëst Feld ass obligatoresch';

  @override
  String get error_email => 'Dës Email ass ongëlteg';

  @override
  String get error_email_acceptable => 'Dës Email Adress ass net akzeptabel. Iwwerpréif se wannechgelift an probéier nach eng Kéier.';

  @override
  String get error_email_unique => 'Email Adress ongëlteg oder schon benotzt';

  @override
  String get error_email_different => 'Dat ass schon deng Email Adress';

  @override
  String error_minLength(String param) {
    return 'Mindestens $param Zeechen';
  }

  @override
  String error_maxLength(String param) {
    return 'Maximal $param Zeechen';
  }

  @override
  String error_min(String param) {
    return 'Muss mindestens $param sinn';
  }

  @override
  String error_max(String param) {
    return 'Däerf maximal $param sinn';
  }

  @override
  String ifRatingIsPlusMinusX(String param) {
    return 'Falls Wäertung ± $param';
  }

  @override
  String get ifRegistered => 'Wann registréiert';

  @override
  String get onlyExistingConversations => 'Just lafend Konversatiounen';

  @override
  String get onlyFriends => 'Just Kolleegen';

  @override
  String get menu => 'Menü';

  @override
  String get castling => 'Rochade';

  @override
  String get whiteCastlingKingside => 'Wäiss O-O';

  @override
  String get blackCastlingKingside => 'Schwaarz O-O';

  @override
  String tpTimeSpentPlaying(String param) {
    return 'Gesamt Spillzäit: $param';
  }

  @override
  String get watchGames => 'Partien ukucken';

  @override
  String tpTimeSpentOnTV(String param) {
    return 'Gesamtzäit op TV: $param';
  }

  @override
  String get watch => 'Kucken';

  @override
  String get videoLibrary => 'Video Librairie';

  @override
  String get streamersMenu => 'Streamer';

  @override
  String get mobileApp => 'Mobil Applicatioun';

  @override
  String get webmasters => 'Webmasters';

  @override
  String get about => 'Iwwer';

  @override
  String aboutX(String param) {
    return 'Iwwer $param';
  }

  @override
  String xIsAFreeYLibreOpenSourceChessServer(String param1, String param2) {
    return '$param1 ass en gratis ($param2), fräien, keng-Reklammen, Open Source Schach Server.';
  }

  @override
  String get really => 'wierklech';

  @override
  String get contribute => 'Bäidroen';

  @override
  String get termsOfService => 'AGB';

  @override
  String get sourceCode => 'Quellcode';

  @override
  String get simultaneousExhibitions => 'Simultanveranstaltungen';

  @override
  String get host => 'Host';

  @override
  String hostColorX(String param) {
    return 'Host Figuren: $param';
  }

  @override
  String get yourPendingSimuls => 'Your pending simuls';

  @override
  String get createdSimuls => 'Nei kreéiert Simuls';

  @override
  String get hostANewSimul => 'Eng nei Simul hosten';

  @override
  String get signUpToHostOrJoinASimul => 'Sign up to host or join a simul';

  @override
  String get noSimulFound => 'Simul net fonnt';

  @override
  String get noSimulExplanation => 'Dës Simultanveranstaltung existéiert net.';

  @override
  String get returnToSimulHomepage => 'Zeréck op Simul Homepage';

  @override
  String get aboutSimul => 'An enger Simul spillt een Spiller géint vill aner Spiller gläichzäiteg.';

  @override
  String get aboutSimulImage => 'Vun 50 Géigner huet den Fischer géint 47 gewonn, géint 2 Remis gespillt and 1 Partie verluer.';

  @override
  String get aboutSimulRealLife => 'D\'Konzept gläicht deem vun richtegen Simultanveranstaltungen, wou den Host vun Briet zu Briet geet.';

  @override
  String get aboutSimulRules => 'Wann d\'Simul ufänkt, start all Spiller eng Partie mam Host. D\'Simul ass fäerdeg wann all Partien fäerdeg sinn.';

  @override
  String get aboutSimulSettings => 'Simultanpartië sinn ëmmer ongewäert. Revanchen, Zeréckhuelen an Zäit bäigi sinn net méiglech.';

  @override
  String get create => 'Kreéieren';

  @override
  String get whenCreateSimul => 'Wanns du eng Simul kreéiers. kanns du géint puer Spiller gläichzäiteg spillen.';

  @override
  String get simulVariantsHint => 'Wanns du puer Varianten auswiehls, kann all Spiller wiehlen, wéieng hien spillt.';

  @override
  String get simulClockHint => 'Fischer Bedenkzäit. Je méi Géigner du hues, desto méi Zäit wäers du brauchen.';

  @override
  String get simulAddExtraTime => 'Du kanns dir extra Zäit ginn fir besser mat der Simul zurechtzekommen.';

  @override
  String get simulHostExtraTime => 'Host extra Zäit';

  @override
  String get simulAddExtraTimePerPlayer => 'Gëff denger Auer zousätzlech Zäit fir all Spiller deen der Simultan bäitrëtt.';

  @override
  String get simulHostExtraTimePerPlayer => 'Gëff all Spiller zousätzlech Bedenkzäit';

  @override
  String get lichessTournaments => 'Lichess Turnéier';

  @override
  String get tournamentFAQ => 'Arena Turnéier FAQ';

  @override
  String get timeBeforeTournamentStarts => 'Zäit bis den Turnéier ufänkt';

  @override
  String get averageCentipawnLoss => 'Ø-Verloscht vun 1/100-Bauer p. Zuch';

  @override
  String get accuracy => 'Prezisioun';

  @override
  String get keyboardShortcuts => 'Tastaturkürzel';

  @override
  String get keyMoveBackwardOrForward => 'zeréck/no fir beweegen';

  @override
  String get keyGoToStartOrEnd => 'bei Start/Schluss goen';

  @override
  String get keyCycleSelectedVariation => 'Cycle selected variation';

  @override
  String get keyShowOrHideComments => 'Kommentarer weisen/verstoppen';

  @override
  String get keyEnterOrExitVariation => 'Variant wielen/verloossen';

  @override
  String get keyRequestComputerAnalysis => 'Computeranalys ufroen, léier aus denge Feeler';

  @override
  String get keyNextLearnFromYourMistakes => 'Nächst (Aus dengen Feeler léieren)';

  @override
  String get keyNextBlunder => 'Nächst Gaffe';

  @override
  String get keyNextMistake => 'Nächsten Feeler';

  @override
  String get keyNextInaccuracy => 'Nächst Ongenauegkeet';

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
  String get newTournament => 'Neien Turnéier';

  @override
  String get tournamentHomeTitle => 'Schach Turnéier mat verschiddenen Zäitkontrollen and Varianten';

  @override
  String get tournamentHomeDescription => 'Spill rasant Schachturnéier! Triet engem offiziell geplangten Turnéier bäi oder kreéier däin eegenen. Bullet, Blitz, Klassesch, Chess960, King of the Kill, Threecheck an weider Optiounen fir grenzenlosen Schachspaass.';

  @override
  String get tournamentNotFound => 'Turnéier net fonnt';

  @override
  String get tournamentDoesNotExist => 'Dësen Turnéier existéiert net.';

  @override
  String get tournamentMayHaveBeenCanceled => 'Den Turnéier gouf villäicht annuléiert falls all Spiller virum Start gaange sinn.';

  @override
  String get returnToTournamentsHomepage => 'Zeréck zur Tunéier Homepage';

  @override
  String weeklyPerfTypeRatingDistribution(String param) {
    return 'Wöchentlech $param Wäertungsverdeelung';
  }

  @override
  String yourPerfTypeRatingIsRating(String param1, String param2) {
    return 'Deng $param1 Wäertung ass $param2.';
  }

  @override
  String youAreBetterThanPercentOfPerfTypePlayers(String param1, String param2) {
    return 'Du bass besser wéi $param1 vun allen $param2-Spiller.';
  }

  @override
  String userIsBetterThanPercentOfPerfTypePlayers(String param1, String param2, String param3) {
    return '$param1 ass besser wéi $param2 vun allen $param3-Spiller.';
  }

  @override
  String betterThanPercentPlayers(String param1, String param2) {
    return 'Besser wéi $param1 vun de(n) $param2-Spiller';
  }

  @override
  String youDoNotHaveAnEstablishedPerfTypeRating(String param) {
    return 'Du hues keng feststehend $param Wäertung.';
  }

  @override
  String get yourRating => 'Deng Wäertung';

  @override
  String get cumulative => 'Kumulativ';

  @override
  String get glicko2Rating => 'Glicko-2 Wäertung';

  @override
  String get checkYourEmail => 'Kuckt Är Emailen';

  @override
  String get weHaveSentYouAnEmailClickTheLink => 'Mir hun dir eng Email geschéckt. Klick den Link an der Email fir däin Konto ze aktivéieren.';

  @override
  String get ifYouDoNotSeeTheEmailCheckOtherPlaces => 'Wanns du keng Email gesäis, kuck op aneren Plazen, wéi Junk, Spam, Sozial Medien, oder aneren Uerdner.';

  @override
  String weHaveSentYouAnEmailTo(String param) {
    return 'Mir hun eng Email un $param geschéckt. Klick den Link an der Email fir däin Passwuert zeréckzesetzen.';
  }

  @override
  String byRegisteringYouAgreeToBeBoundByOur(String param) {
    return 'Mam Registréieren akzeptéiers du $param.';
  }

  @override
  String readAboutOur(String param) {
    return 'Lies iwwer eis $param.';
  }

  @override
  String get networkLagBetweenYouAndLichess => 'Netzwierk Lag zwëschen dir an Lichess';

  @override
  String get timeToProcessAMoveOnLichessServer => 'Zäit fir en Zuch um Lichess Server ze veraarbechten';

  @override
  String get downloadAnnotated => 'Download kommentéiert';

  @override
  String get downloadRaw => 'Download onkommentéiert';

  @override
  String get downloadImported => 'Importéiert Partie eroflueden';

  @override
  String get crosstable => 'Matchverlaf';

  @override
  String get youCanAlsoScrollOverTheBoardToMoveInTheGame => 'Du kanns och um Briet scrollen fir duerch d\'Partie ze goen.';

  @override
  String get scrollOverComputerVariationsToPreviewThem => 'Scroll iwwer Computer Varianten fir eng Virschau ze kréien.';

  @override
  String get analysisShapesHowTo => 'Dréck Shift+Mausklick oder Rietsklick fir Kreeser and Feiler um Briet ze zeechnen.';

  @override
  String get letOtherPlayersMessageYou => 'Anerer kënnen dir Messagen schécken';

  @override
  String get receiveForumNotifications => 'Notificatioun kréien wann du am Forum erwähnt gëss';

  @override
  String get shareYourInsightsData => 'Deng perséinlech Schachstatistiken deelen';

  @override
  String get withNobody => 'Mat kengem';

  @override
  String get withFriends => 'Mat Kolleegen';

  @override
  String get withEverybody => 'Mat jidderengem';

  @override
  String get kidMode => 'Kannermodus';

  @override
  String get kidModeIsEnabled => 'De Kannermodus ass aktiv.';

  @override
  String get kidModeExplanation => 'Eng Sécherheetsastellung. Am Kannermodus sin all Kommunikatiounsweeër blockéiert. Aktivéier dës Optioun fir Kanner an Schüler virun Internetbenotzer ze schützen.';

  @override
  String inKidModeTheLichessLogoGetsIconX(String param) {
    return 'Am Kannermodus huet den Lichess logo en $param Icon, sou weess du dass däin Kand sécher ass.';
  }

  @override
  String get askYourChessTeacherAboutLiftingKidMode => 'Däin Konto gëtt verwalt. Fro däin Schachtrainer fir den Kannermodus opzehiewen.';

  @override
  String get enableKidMode => 'Kannermodus aktivéieren';

  @override
  String get disableKidMode => 'Kannermodus desaktivéieren';

  @override
  String get security => 'Sécherheet';

  @override
  String get sessions => 'Sitzungen';

  @override
  String get revokeAllSessions => 'All Sitzungen ofschléissen';

  @override
  String get playChessEverywhere => 'Spill iwwerall Schach';

  @override
  String get asFreeAsLichess => 'Sou gratis wéi Lichess';

  @override
  String get builtForTheLoveOfChessNotMoney => 'Aus Léift zum Schach, net Suen';

  @override
  String get everybodyGetsAllFeaturesForFree => 'Jiddereen kritt all Features fir näischt';

  @override
  String get zeroAdvertisement => 'Keng Reklamm';

  @override
  String get fullFeatured => 'Keng Aschränkungen';

  @override
  String get phoneAndTablet => 'Handy an Tablet';

  @override
  String get bulletBlitzClassical => 'Bullet, Blitz, Klassesch';

  @override
  String get correspondenceChess => 'Korrespondenz Schach';

  @override
  String get onlineAndOfflinePlay => 'Online an Offline spillen';

  @override
  String get viewTheSolution => 'Léisung ukucken';

  @override
  String get followAndChallengeFriends => 'Kolleege followen an erausfuerderen';

  @override
  String get gameAnalysis => 'Analys vun der Partie';

  @override
  String xHostsY(String param1, String param2) {
    return '$param1 huet $param2 kreéiert';
  }

  @override
  String xJoinsY(String param1, String param2) {
    return '$param1 mëscht mat bäi $param2';
  }

  @override
  String xLikesY(String param1, String param2) {
    return 'Dem $param1 gefält $param2';
  }

  @override
  String get quickPairing => 'Schnell Paarung';

  @override
  String get lobby => 'Lobby';

  @override
  String get anonymous => 'Anonym';

  @override
  String yourScore(String param) {
    return 'Däin Score: $param';
  }

  @override
  String get language => 'Sprooch';

  @override
  String get background => 'Hannergrond';

  @override
  String get light => 'Hell';

  @override
  String get dark => 'Däischter';

  @override
  String get transparent => 'Transparent';

  @override
  String get deviceTheme => 'Mam Gerät synchroniséieren';

  @override
  String get backgroundImageUrl => 'URL vum Hannergrondbild:';

  @override
  String get board => 'Briet';

  @override
  String get size => 'Gréisst';

  @override
  String get opacity => 'Transparenz';

  @override
  String get brightness => 'Hellegkeet';

  @override
  String get hue => 'Faarftoun';

  @override
  String get boardReset => 'Faarwen op de Standard zerécksetzen';

  @override
  String get pieceSet => 'Figurestil';

  @override
  String get embedInYourWebsite => 'An Websäit anbetten';

  @override
  String get usernameAlreadyUsed => 'Dësen Benotzernumm gëtt schonn benotzt, wiel wannechgelift een aneren.';

  @override
  String get usernamePrefixInvalid => 'De Benotzernumm muss mat engem Buschtaf ufänken.';

  @override
  String get usernameSuffixInvalid => 'De Benotzernumm muss mat engem Buschtaf oder enger Zuel ophalen.';

  @override
  String get usernameCharsInvalid => 'De Benotzernumm däerf just Buschtawen, Zuelen, Ënner- an Bindestricher enthalen. Konsekutiv Ënner- an Bindestricher sinn net erlaabt.';

  @override
  String get usernameUnacceptable => 'Dësen Benotzernumm ass net akzeptabel.';

  @override
  String get playChessInStyle => 'Mat Style Schach spillen';

  @override
  String get chessBasics => 'Schach Grondlagen';

  @override
  String get coaches => 'Trainer';

  @override
  String get invalidPgn => 'Ongëlteg PGN';

  @override
  String get invalidFen => 'Ongëlteg FEN';

  @override
  String get custom => 'Personaliséiert';

  @override
  String get notifications => 'Notificatiounen';

  @override
  String notificationsX(String param1) {
    return 'Notifikatiounen: $param1';
  }

  @override
  String perfRatingX(String param) {
    return 'Wäertung: $param';
  }

  @override
  String get practiceWithComputer => 'Mam Computer üben';

  @override
  String anotherWasX(String param) {
    return 'En aneren war $param';
  }

  @override
  String bestWasX(String param) {
    return 'Am Beschten war $param';
  }

  @override
  String get youBrowsedAway => 'Du hues fortgebliedert';

  @override
  String get resumePractice => 'Übung fortsetzen';

  @override
  String get drawByFiftyMoves => 'D\'Partie gouf duerch d\' 50 Zuch Reegel als Remis deklaréiert.';

  @override
  String get theGameIsADraw => 'D\'Partie ass Remis.';

  @override
  String get computerThinking => 'Computer iwwerleet ...';

  @override
  String get seeBestMove => 'Beschten Zuch gesinn';

  @override
  String get hideBestMove => 'Beschten Zuch verstoppen';

  @override
  String get getAHint => 'Tipp kréien';

  @override
  String get evaluatingYourMove => 'Zuch gëtt evaluéiert ...';

  @override
  String get whiteWinsGame => 'Wäiss gewënnt';

  @override
  String get blackWinsGame => 'Schwaarz gewënnt';

  @override
  String get learnFromYourMistakes => 'Aus dengen Feeler léieren';

  @override
  String get learnFromThisMistake => 'Aus dësem Feeler léieren';

  @override
  String get skipThisMove => 'Zuch iwwersprangen';

  @override
  String get next => 'Weider';

  @override
  String xWasPlayed(String param) {
    return '$param gouf gespillt';
  }

  @override
  String get findBetterMoveForWhite => 'Fann en bessern Zuch fir Wäiss';

  @override
  String get findBetterMoveForBlack => 'Fann en bessern Zuch fir Schwaarz';

  @override
  String get resumeLearning => 'Weider léieren';

  @override
  String get youCanDoBetter => 'Et geet nach besser';

  @override
  String get tryAnotherMoveForWhite => 'Probéier een aneren Zuch fir Wäiss';

  @override
  String get tryAnotherMoveForBlack => 'Probéier een aneren Zuch fir Schwaarz';

  @override
  String get solution => 'Léisung';

  @override
  String get waitingForAnalysis => 'Op d\'Analys waarden';

  @override
  String get noMistakesFoundForWhite => 'Keng Feeler vun Wäiss fonnt';

  @override
  String get noMistakesFoundForBlack => 'Keng Feeler vun Schwaarz fonnt';

  @override
  String get doneReviewingWhiteMistakes => 'Wäiss Feeler all nogekuckt';

  @override
  String get doneReviewingBlackMistakes => 'Schwaarz Feeler all nogekuckt';

  @override
  String get doItAgain => 'Nach eng Kéier';

  @override
  String get reviewWhiteMistakes => 'Feeler vun Wäiss iwwerpréifen';

  @override
  String get reviewBlackMistakes => 'Feeler vun Schwaarz iwwerpréifen';

  @override
  String get advantage => 'Virdeel';

  @override
  String get opening => 'Eröffnung';

  @override
  String get middlegame => 'Mëttelspill';

  @override
  String get endgame => 'Endspill';

  @override
  String get conditionalPremoves => 'Bedingt Virauszich';

  @override
  String get addCurrentVariation => 'Aktuell Variant bäifügen';

  @override
  String get playVariationToCreateConditionalPremoves => 'Variant spillen fir bedingt Virauszich ze kreéieren';

  @override
  String get noConditionalPremoves => 'Keng bedingt Virauszich';

  @override
  String playX(String param) {
    return 'Spill $param';
  }

  @override
  String get showUnreadLichessMessage => 'Du krus eng privat Noriicht vu Lichess.';

  @override
  String get clickHereToReadIt => 'Klick hei fir se ze liesen';

  @override
  String get sorry => 'Sorry :(';

  @override
  String get weHadToTimeYouOutForAWhile => 'Mir missten dir eng Auszeit ginn.';

  @override
  String get why => 'Firwat?';

  @override
  String get pleasantChessExperience => 'Mir wëllen jidderengem eng méiglechst gudd Schacherfahrung offréieren.';

  @override
  String get goodPractice => 'Fir dat ze erreechen mussen mer sécherstellen dass all Spiller sech korrekt verhalen.';

  @override
  String get potentialProblem => 'Mir weisen dësen Message, wann en potentiellen Problem erkannt gouf.';

  @override
  String get howToAvoidThis => 'Dat hei vermeiden?';

  @override
  String get playEveryGame => 'Spill all Partie déi du ufänks.';

  @override
  String get tryToWin => 'Probéier all Partie ze gewannen (oder op mannst Remis ze spillen).';

  @override
  String get resignLostGames => 'Gëff verlueren Partien op (looss net d\'Auer roflafen).';

  @override
  String get temporaryInconvenience => 'Mir entschëllege ons fir d\'temporär Onannehmlechkeeten,';

  @override
  String get wishYouGreatGames => 'an wënschen dir flott Partien op lichess.org.';

  @override
  String get thankYouForReading => 'Merci fir d\'Liesen!';

  @override
  String get lifetimeScore => 'Éiwegen Spillstand';

  @override
  String get currentMatchScore => 'Aktuellen Match Score';

  @override
  String get agreementAssistance => 'Ech stëmmen zou dass ech zu kengem Zäitpunkt wärend mengen Partien Hëllef an Usproch huelen (duerch Computer, Buch, Datenbank oder eng aner Persoun).';

  @override
  String get agreementNice => 'Ech stëmmen zou dass ech aneren Spiller géigeniwwer ëmmer respektvoll agéieren wäert.';

  @override
  String agreementMultipleAccounts(String param) {
    return 'Ech stëmmen zou dass ech net puer Konten kreéieren wäert (außer fir Zwecker genannt an den $param).';
  }

  @override
  String get agreementPolicy => 'Ech stëmmen zou dass ech den Lichess-Richtlinnen folgen wäert.';

  @override
  String get searchOrStartNewDiscussion => 'Sichen oder nei Konversatioun starten';

  @override
  String get edit => 'Änneren';

  @override
  String get bullet => 'Bullet';

  @override
  String get blitz => 'Blitz';

  @override
  String get rapid => 'Rapid';

  @override
  String get classical => 'Klassesch';

  @override
  String get ultraBulletDesc => 'Immens séier Partien: Manner wéi 30 Sekonnen';

  @override
  String get bulletDesc => 'Ganz schnell Partien: manner wéi 3 Minutten';

  @override
  String get blitzDesc => 'Schnell Partien: 3 bis 8 Minutten';

  @override
  String get rapidDesc => 'Rapid Partien: 8 bis 25 Minutten';

  @override
  String get classicalDesc => 'Klassesch Partien: 25 Minutten an méi';

  @override
  String get correspondenceDesc => 'Korrespondenz Partien: Een oder puer Deeg pro Zuch';

  @override
  String get puzzleDesc => 'Schach Taktiktrainer';

  @override
  String get important => 'Wichteg';

  @override
  String yourQuestionMayHaveBeenAnswered(String param1) {
    return 'Deng Fro gouf villäicht schon beäntwert $param1';
  }

  @override
  String get inTheFAQ => 'am FAQ';

  @override
  String toReportSomeoneForCheatingOrBadBehavior(String param1) {
    return 'Fir en Benotzer fir Bedruch oder schlecht Behuelen ze mellen, $param1';
  }

  @override
  String get useTheReportForm => 'benotz dësen Formulaire';

  @override
  String toRequestSupport(String param1) {
    return 'Fir Hëllef ze kréien, $param1';
  }

  @override
  String get tryTheContactPage => 'probéier eis Kontaktsäit';

  @override
  String makeSureToRead(String param1) {
    return 'Wannechgelift lies $param1';
  }

  @override
  String get theForumEtiquette => 'd\'Forumsetikett';

  @override
  String get thisTopicIsArchived => 'Dësen Thema gouf archivéiert and kann net méi beäntwert ginn.';

  @override
  String joinTheTeamXToPost(String param1) {
    return 'Triet $param1 bäi, fir an dësem Forum ze posten';
  }

  @override
  String teamNamedX(String param1) {
    return '$param1 Ekipp';
  }

  @override
  String get youCannotPostYetPlaySomeGames => 'Du kanns nach net am Forum schreiwen. Spill puer Partien!';

  @override
  String get subscribe => 'Abonéieren';

  @override
  String get unsubscribe => 'Desabonéiren';

  @override
  String mentionedYouInX(String param1) {
    return 'huet dech an \"$param1\" erwähnt.';
  }

  @override
  String xMentionedYouInY(String param1, String param2) {
    return '$param1 huet dech an \"$param2\" erwähnt.';
  }

  @override
  String invitedYouToX(String param1) {
    return 'huet dech zu \"$param1\" invitéiert.';
  }

  @override
  String xInvitedYouToY(String param1, String param2) {
    return '$param1 huet dech zu \"$param2\" invitéiert.';
  }

  @override
  String get youAreNowPartOfTeam => 'Du bass elo Member vun der Ekipp.';

  @override
  String youHaveJoinedTeamX(String param1) {
    return 'Du bass \"$param1\" bäigetrueden.';
  }

  @override
  String get someoneYouReportedWasBanned => 'Een vun dir gemellten Benotzer gouf gebannt';

  @override
  String get congratsYouWon => 'Felicitatioun, du hues gewonn!';

  @override
  String gameVsX(String param1) {
    return 'Partie géint $param1';
  }

  @override
  String resVsX(String param1, String param2) {
    return '$param1 vs $param2';
  }

  @override
  String get lostAgainstTOSViolator => 'Du hues géint een verluer deen géint Lichess-Richtlinnen vertouss huet';

  @override
  String refundXpointsTimeControlY(String param1, String param2) {
    return 'Réckerstattung: $param1 $param2 Wäertungspunkten.';
  }

  @override
  String get timeAlmostUp => 'Deng Zäit ass baal ofgelaf!';

  @override
  String get clickToRevealEmailAddress => '[Klick fir Email Adress ze weisen]';

  @override
  String get download => 'Download';

  @override
  String get coachManager => 'Coach Manager';

  @override
  String get streamerManager => 'Stream Manager';

  @override
  String get cancelTournament => 'Turnéier annuléieren';

  @override
  String get tournDescription => 'Turnéier Beschreiwung';

  @override
  String get tournDescriptionHelp => 'Wëlls du den Participanten eppes matdeelen? Haal dech kuerz. Markdown-Links sinn disponibel [name](https://url)';

  @override
  String get ratedFormHelp => 'Partie si gewäert \na verännere Spillerwäertungen';

  @override
  String get onlyMembersOfTeam => 'Just Memberen vun der Ekipp';

  @override
  String get noRestriction => 'Keng Aschränkungen';

  @override
  String get minimumRatedGames => 'Minimum gewäert Partien';

  @override
  String get minimumRating => 'Minimum Wäertung';

  @override
  String get maximumWeeklyRating => 'Maximal wöchentlech Wäertung';

  @override
  String positionInputHelp(String param) {
    return 'Füg eng gülteg FEN an, fir all Partie aus enger bestëmmter Positioun ze starten.\nEt funktioneiert nëmmen fir Standardpartien, net fir Varianten.\nDu kanns de $param benotzen, fir eng FEN-Positioun ze generéieren an dës dann hei afügen.\nLooss et eidel, fir Partie aus der normaler Ausgangspositioun ze starten.';
  }

  @override
  String get cancelSimul => 'Simul annuléieren';

  @override
  String get simulHostcolor => 'Faarf vum Host fir all Partie';

  @override
  String get estimatedStart => 'Ongeféier Startzäit';

  @override
  String simulFeatured(String param) {
    return 'Op $param weisen';
  }

  @override
  String simulFeaturedHelp(String param) {
    return 'Jidderengem op $param Simul uweisen. Desaktivéieren fir privat Simuls.';
  }

  @override
  String get simulDescription => 'Simul Beschreiwung';

  @override
  String get simulDescriptionHelp => 'Wëlls du den Participanten eppes matdeelen?';

  @override
  String markdownAvailable(String param) {
    return '$param ass fir erweidert Formatéierung disponibel.';
  }

  @override
  String get embedsAvailable => 'Füg eng Partien-URL oder eng Etüdenkapitel-URL an, fir se anzebetten.';

  @override
  String get inYourLocalTimezone => 'An denger lokaler Zäitzon';

  @override
  String get tournChat => 'Turnéier Chat';

  @override
  String get noChat => 'Keen Chat';

  @override
  String get onlyTeamLeaders => 'Just Ekippenleader';

  @override
  String get onlyTeamMembers => 'Just Ekippenmemberen';

  @override
  String get navigateMoveTree => 'Duerch den Zuchbam navigéieren';

  @override
  String get mouseTricks => 'Maus Tricks';

  @override
  String get toggleLocalAnalysis => 'Lokal Computeranalys aktivéieren/desaktivéieren';

  @override
  String get toggleAllAnalysis => 'All Computeranalysen aktivéieren/desaktivéieren';

  @override
  String get playComputerMove => 'Beschten Computer Zuch spillen';

  @override
  String get analysisOptions => 'Analysoptiounen';

  @override
  String get focusChat => 'Chat fokusséieren';

  @override
  String get showHelpDialog => 'Dësen Hëllefdialog weisen';

  @override
  String get reopenYourAccount => 'Konto nei opmaachen';

  @override
  String get closedAccountChangedMind => 'Wanns du dein Konto zougemaach has, mee säit deem deng Meenung geännert hues, kriss du eng Chance däin Konto zeréckzekréien.';

  @override
  String get onlyWorksOnce => 'Dat hei klappt just eemol.';

  @override
  String get cantDoThisTwice => 'Wann du däin Konto eng zweete Kéier zou mëss, kann een en net méi zeréckkréien.';

  @override
  String get emailAssociatedToaccount => 'Email Adress associéiert mam Konto';

  @override
  String get sentEmailWithLink => 'Mir hun dir eng Email mat engem Link geschéckt.';

  @override
  String get tournamentEntryCode => 'Turnéier Zougangscode';

  @override
  String get hangOn => 'Waart!';

  @override
  String gameInProgress(String param) {
    return 'Du hues eng Partie amgaang géint $param.';
  }

  @override
  String get abortTheGame => 'Partie ofbriechen';

  @override
  String get resignTheGame => 'Partie opginn';

  @override
  String get youCantStartNewGame => 'Du kanns keng nei Partie ufänken bis déi do fäerdeg ass.';

  @override
  String get since => 'Säit';

  @override
  String get until => 'Bis';

  @override
  String get lichessDbExplanation => 'Gewäert Partien vun allen Lichess Spiller';

  @override
  String get switchSides => 'Faarf wiesselen';

  @override
  String get closingAccountWithdrawAppeal => 'Däin Benotzerkonto zou ze maachen wäert och däin Asproch zeréckzéihen';

  @override
  String get ourEventTips => 'Eis Tipps fir d\'Organiséieren vun Turnéier';

  @override
  String get instructions => 'Instruktiounen';

  @override
  String get showMeEverything => 'Alles weisen';

  @override
  String get lichessPatronInfo => 'Lichess ass eng Wohltätegkeetsorganisatioun an eng komplett kostenfrei/open source Software.\nAll Betriebskäschten, Entwécklung an Inhalter ginn ausschließlech vun Benotzerspenden finanzéiert.';

  @override
  String get nothingToSeeHere => 'Fir de Moment gëtt et hei näischt ze gesinn.';

  @override
  String get stats => 'Statistiken';

  @override
  String opponentLeftCounter(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Däin Géigner huet d\'Partie verlooss. Du kanns an $count Sekonnen d\'Victoire reklaméieren.',
      one: 'Däin Géigner huet d\'Partie verlooss. Du kanns an $count Sekonn d\'Victoire reklaméieren.',
    );
    return '$_temp0';
  }

  @override
  String mateInXHalfMoves(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Matt an $count Hallef-Zich',
      one: 'Matt an $count Hallef-Zuch',
    );
    return '$_temp0';
  }

  @override
  String nbBlunders(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Gaffen',
      one: '$count Gaffe',
    );
    return '$_temp0';
  }

  @override
  String nbMistakes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Feeler',
      one: '$count Feeler',
    );
    return '$_temp0';
  }

  @override
  String nbInaccuracies(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Ongenauegkeeten',
      one: '$count Ongenauegkeet',
    );
    return '$_temp0';
  }

  @override
  String nbPlayers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Spiller',
      one: '$count Spiller',
    );
    return '$_temp0';
  }

  @override
  String nbGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Partien',
      one: '$count Partie',
    );
    return '$_temp0';
  }

  @override
  String ratingXOverYGames(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count-Wäertung aus $param2 Partien',
      one: '$count-Wäertung aus $param2 Partie',
    );
    return '$_temp0';
  }

  @override
  String nbBookmarks(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Lieszeeche',
      one: '$count Lieszeeche',
    );
    return '$_temp0';
  }

  @override
  String nbDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Deeg',
      one: '$count Dag',
    );
    return '$_temp0';
  }

  @override
  String nbHours(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Stonnen',
      one: '$count Stonn',
    );
    return '$_temp0';
  }

  @override
  String nbMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Minutten',
      one: '$count Minutt',
    );
    return '$_temp0';
  }

  @override
  String rankIsUpdatedEveryNbMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Rank gëtt all $count Minutten geupdate',
      one: 'Rang gëtt all Minutt geupdate',
    );
    return '$_temp0';
  }

  @override
  String nbPuzzles(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Aufgaben',
      one: '$count Aufgab',
    );
    return '$_temp0';
  }

  @override
  String nbGamesWithYou(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Partien géint dech',
      one: '$count Partie géint dech',
    );
    return '$_temp0';
  }

  @override
  String nbRated(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count gewäert',
      one: '$count gewäert',
    );
    return '$_temp0';
  }

  @override
  String nbWins(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count gewonn',
      one: '$count gewonn',
    );
    return '$_temp0';
  }

  @override
  String nbLosses(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count verluer',
      one: '$count verluer',
    );
    return '$_temp0';
  }

  @override
  String nbDraws(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Remis',
      one: '$count Remis',
    );
    return '$_temp0';
  }

  @override
  String nbPlaying(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count lafend',
      one: '$count lafend',
    );
    return '$_temp0';
  }

  @override
  String giveNbSeconds(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Dem Géigner $count Sekonne bäiginn',
      one: 'Dem Géigner $count Sekonn bäiginn',
    );
    return '$_temp0';
  }

  @override
  String nbTournamentPoints(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Turnéierpunkten',
      one: '$count Turnéierpunkt',
    );
    return '$_temp0';
  }

  @override
  String nbStudies(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Etüden',
      one: '$count Etüd',
    );
    return '$_temp0';
  }

  @override
  String nbSimuls(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Simultanveranstaltungen',
      one: '$count Simultanveranstaltung',
    );
    return '$_temp0';
  }

  @override
  String moreThanNbRatedGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '≥ $count gewäert Partien',
      one: '≥ $count gewäert Partie',
    );
    return '$_temp0';
  }

  @override
  String moreThanNbPerfRatedGames(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '≥ $count gewäert $param2 Partien',
      one: '≥ $count gewäert $param2 Partie',
    );
    return '$_temp0';
  }

  @override
  String needNbMorePerfGames(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Du muss nach $count gewäert $param2 Partien spillen',
      one: 'Du muss nach $count gewäert $param2 Partie spillen',
    );
    return '$_temp0';
  }

  @override
  String needNbMoreGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Du muss nach $count gewäert Partien spillen',
      one: 'Du muss nach $count gewäert Partie spillen',
    );
    return '$_temp0';
  }

  @override
  String nbImportedGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count importéiert Partien',
      one: '$count importéiert Partie',
    );
    return '$_temp0';
  }

  @override
  String nbFriendsOnline(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Kolleegen online',
      one: '$count Kolleeg online',
    );
    return '$_temp0';
  }

  @override
  String nbFollowers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Follower',
      one: '$count Follower',
    );
    return '$_temp0';
  }

  @override
  String nbFollowing(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Folgend',
      one: '$count Folgend',
    );
    return '$_temp0';
  }

  @override
  String lessThanNbMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Manner wéi $count Minutten',
      one: 'Manner wéi $count Minutt',
    );
    return '$_temp0';
  }

  @override
  String nbGamesInPlay(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Partien amgaang',
      one: '$count Partie amgaang',
    );
    return '$_temp0';
  }

  @override
  String maximumNbCharacters(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Maximum: $count Buschtawen.',
      one: 'Maximum: $count Buschtaw.',
    );
    return '$_temp0';
  }

  @override
  String blocks(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count geblockt',
      one: '$count geblockt',
    );
    return '$_temp0';
  }

  @override
  String nbForumPosts(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Forumbäiträg',
      one: '$count Forumbäitrag',
    );
    return '$_temp0';
  }

  @override
  String nbPerfTypePlayersThisWeek(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count$param2 Spiller dës Woch.',
      one: '$count$param2 Spiller dës Woch.',
    );
    return '$_temp0';
  }

  @override
  String availableInNbLanguages(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Disponibel an $count Sproochen!',
      one: 'Disponibel an $count Sprooch!',
    );
    return '$_temp0';
  }

  @override
  String nbSecondsToPlayTheFirstMove(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Sekonne fir den éischten Zuch ze maachen',
      one: '$count Sekonn fir den éischten Zuch ze maachen',
    );
    return '$_temp0';
  }

  @override
  String nbSeconds(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Sekonnen',
      one: '$count Sekonn',
    );
    return '$_temp0';
  }

  @override
  String andSaveNbPremoveLines(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'an späicher $count bedingt Virauszich',
      one: 'an späicher $count bedingten Virauszuch',
    );
    return '$_temp0';
  }

  @override
  String get stormMoveToStart => 'Maach en Zuch fir ze starten';

  @override
  String get stormYouPlayTheWhitePiecesInAllPuzzles => 'Du spills an allen Aufgaben mat de wäisse Figuren';

  @override
  String get stormYouPlayTheBlackPiecesInAllPuzzles => 'Du spills an allen Aufgaben mat de schwaarze Figuren';

  @override
  String get stormPuzzlesSolved => 'Aufgabe geléist';

  @override
  String get stormNewDailyHighscore => 'Néien Dagesrekord!';

  @override
  String get stormNewWeeklyHighscore => 'Néien Wocherekord!';

  @override
  String get stormNewMonthlyHighscore => 'Néie Rekord vum Mount!';

  @override
  String get stormNewAllTimeHighscore => 'Néien Allzäitrekord!';

  @override
  String stormPreviousHighscoreWasX(String param) {
    return 'Leschten Highscore war $param';
  }

  @override
  String get stormPlayAgain => 'Nach eng Kéier spillen';

  @override
  String stormHighscoreX(String param) {
    return 'Highscore: $param';
  }

  @override
  String get stormScore => 'Score';

  @override
  String get stormMoves => 'Zich';

  @override
  String get stormAccuracy => 'Prezisioun';

  @override
  String get stormCombo => 'Kombo';

  @override
  String get stormTime => 'Zäit';

  @override
  String get stormTimePerMove => 'Zäit pro Zuch';

  @override
  String get stormHighestSolved => 'Héchsten geléist Aufgab';

  @override
  String get stormPuzzlesPlayed => 'Aufgaben gespillt';

  @override
  String get stormNewRun => 'Neien Duerchlaf (hotkey: Leertaste)';

  @override
  String get stormEndRun => 'Duerchlaf ofbriechen (hotkey: Enter)';

  @override
  String get stormHighscores => 'Highscores';

  @override
  String get stormViewBestRuns => 'Bescht Duerchleef ukucken';

  @override
  String get stormBestRunOfDay => 'Beschten Duerchlaf vum Dag';

  @override
  String get stormRuns => 'Duerchleef';

  @override
  String get stormGetReady => 'Maach dech prett!';

  @override
  String get stormWaitingForMorePlayers => 'Waarden, bis méi Spiller matmaachen...';

  @override
  String get stormRaceComplete => 'Duerchlaf ofgeschloss!';

  @override
  String get stormSpectating => 'Nokucken';

  @override
  String get stormJoinTheRace => 'Triet der Course bäi!';

  @override
  String get stormStartTheRace => 'Course starten';

  @override
  String stormYourRankX(String param) {
    return 'Deng Plaz: $param';
  }

  @override
  String get stormWaitForRematch => 'Waard ob Revanche';

  @override
  String get stormNextRace => 'Nächst Course';

  @override
  String get stormJoinRematch => 'Revanche bäitrieden';

  @override
  String get stormWaitingToStart => 'Ob Start waarden';

  @override
  String get stormCreateNewGame => 'Kreéier eng nei Partie';

  @override
  String get stormJoinPublicRace => 'Oppener Course bäitrieden';

  @override
  String get stormRaceYourFriends => 'Course géint Kolleegen';

  @override
  String get stormSkip => 'Iwwersprangen';

  @override
  String get stormSkipHelp => 'Du kanns een Zuch pro Course iwwersprangen:';

  @override
  String get stormSkipExplanation => 'Iwwersprang dëse Zuch fir deng Erfollegsserie ze erhalen! Dës kanns du nëmmen ee Mol pro Laf maachen.';

  @override
  String get stormFailedPuzzles => 'Mësslongen Aufgaben';

  @override
  String get stormSlowPuzzles => 'Lues Aufgaben';

  @override
  String get stormSkippedPuzzle => 'Iwwersprongenen Puzzle';

  @override
  String get stormThisWeek => 'Dës Woch';

  @override
  String get stormThisMonth => 'Dëse Mount';

  @override
  String get stormAllTime => 'Gesamt';

  @override
  String get stormClickToReload => 'Klick fir nei ze lueden';

  @override
  String get stormThisRunHasExpired => 'Dësen Duerchlaf ass ofgelaf!';

  @override
  String get stormThisRunWasOpenedInAnotherTab => 'Dësen Duerchlaf gouf an engem aneren Tab opgemaach!';

  @override
  String stormXRuns(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Duerchleef',
      one: '1 Duerchlaf',
    );
    return '$_temp0';
  }

  @override
  String stormPlayedNbRunsOfPuzzleStorm(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Huet $count Duerchleef vun $param2 gespillt',
      one: 'Huet een Duerchlaf vun $param2 gespillt',
    );
    return '$_temp0';
  }

  @override
  String get streamerLichessStreamers => 'Lichess Streamer';

  @override
  String get studyPrivate => 'Privat';

  @override
  String get studyMyStudies => 'Meng Etüden';

  @override
  String get studyStudiesIContributeTo => 'Etüden, un deenen ech matwierken';

  @override
  String get studyMyPublicStudies => 'Meng öffentlech Etüden';

  @override
  String get studyMyPrivateStudies => 'Meng privat Etüden';

  @override
  String get studyMyFavoriteStudies => 'Meng Lieblingsetüden';

  @override
  String get studyWhatAreStudies => 'Wat sinn Etüden?';

  @override
  String get studyAllStudies => 'All Etüden';

  @override
  String studyStudiesCreatedByX(String param) {
    return 'Etüden kreéiert vun $param';
  }

  @override
  String get studyNoneYet => 'Nach keng.';

  @override
  String get studyHot => 'Ugesot';

  @override
  String get studyDateAddedNewest => 'Veröffentlechungsdatum (am neisten)';

  @override
  String get studyDateAddedOldest => 'Veröffentlechungsdatum (am aalsten)';

  @override
  String get studyRecentlyUpdated => 'Rezent aktualiséiert';

  @override
  String get studyMostPopular => 'Am Beléiftsten';

  @override
  String get studyAlphabetical => 'Alphabetesch';

  @override
  String get studyAddNewChapter => 'Neit Kapitel bäifügen';

  @override
  String get studyAddMembers => 'Memberen hinzufügen';

  @override
  String get studyInviteToTheStudy => 'An d\'Etüd alueden';

  @override
  String get studyPleaseOnlyInvitePeopleYouKnow => 'Wannechgelift invitéier just Leit déi du kenns an déi aktiv un der Etüd matwierken wëllen.';

  @override
  String get studySearchByUsername => 'No Benotzernumm sichen';

  @override
  String get studySpectator => 'Zuschauer';

  @override
  String get studyContributor => 'Matwierkenden';

  @override
  String get studyKick => 'Rausgehéien';

  @override
  String get studyLeaveTheStudy => 'Etüd verloossen';

  @override
  String get studyYouAreNowAContributor => 'Du bass elo e Contributeur';

  @override
  String get studyYouAreNowASpectator => 'Du bass elo en Zuschauer';

  @override
  String get studyPgnTags => 'PGN Tags';

  @override
  String get studyLike => 'Gefällt mir';

  @override
  String get studyUnlike => 'Gefällt mer net méi';

  @override
  String get studyNewTag => 'Néien Tag';

  @override
  String get studyCommentThisPosition => 'Kommentéier des Positioun';

  @override
  String get studyCommentThisMove => 'Kommentéier dësen Zuch';

  @override
  String get studyAnnotateWithGlyphs => 'Mat Symboler kommentéieren';

  @override
  String get studyTheChapterIsTooShortToBeAnalysed => 'D\'Kapitel ass ze kuerz fir analyséiert ze ginn.';

  @override
  String get studyOnlyContributorsCanRequestAnalysis => 'Just Etüden Matwierkender kënnen eng Computer Analyse ufroen.';

  @override
  String get studyGetAFullComputerAnalysis => 'Vollstänneg serversäiteg Computeranalyse vun der Haaptvariant erhalen.';

  @override
  String get studyMakeSureTheChapterIsComplete => 'Stell sécher dass d\'Kapitel vollstänneg ass. Du kanns eng Analyse just eemol ufroen.';

  @override
  String get studyAllSyncMembersRemainOnTheSamePosition => 'All SYNC Memberen gesinn déi selwecht Positioun';

  @override
  String get studyShareChanges => 'Deel Ännerungen mat den Zuschauer an späicher se um Server';

  @override
  String get studyPlaying => 'Lafend Partie';

  @override
  String get studyShowEvalBar => 'Evaluation bars';

  @override
  String get studyFirst => 'Éischt Säit';

  @override
  String get studyPrevious => 'Zeréck';

  @override
  String get studyNext => 'Weider';

  @override
  String get studyLast => 'Lescht Säit';

  @override
  String get studyShareAndExport => 'Deelen & exportéieren';

  @override
  String get studyCloneStudy => 'Klonen';

  @override
  String get studyStudyPgn => 'Etüden PGN';

  @override
  String get studyDownloadAllGames => 'All Partien eroflueden';

  @override
  String get studyChapterPgn => 'Kapitel PGN';

  @override
  String get studyCopyChapterPgn => 'PGN kopéieren';

  @override
  String get studyDownloadGame => 'Partie eroflueden';

  @override
  String get studyStudyUrl => 'Etüden URL';

  @override
  String get studyCurrentChapterUrl => 'Aktuellt Kapitel URL';

  @override
  String get studyYouCanPasteThisInTheForumToEmbed => 'Zum Anbetten an een Forum oder Blog afügen';

  @override
  String get studyStartAtInitialPosition => 'Mat Startpositioun ufänken';

  @override
  String studyStartAtX(String param) {
    return 'Bei $param ufänken';
  }

  @override
  String get studyEmbedInYourWebsite => 'An Websäit anbetten';

  @override
  String get studyReadMoreAboutEmbedding => 'Méi iwwer Anbetten liesen';

  @override
  String get studyOnlyPublicStudiesCanBeEmbedded => 'Just ëffentlech Etüden kënnen angebett ginn!';

  @override
  String get studyOpen => 'Opmaachen';

  @override
  String studyXBroughtToYouByY(String param1, String param2) {
    return '$param1, presentéiert vum $param2';
  }

  @override
  String get studyStudyNotFound => 'Etüd net fonnt';

  @override
  String get studyEditChapter => 'Kapitel editéieren';

  @override
  String get studyNewChapter => 'Neit Kapitel';

  @override
  String studyImportFromChapterX(String param) {
    return 'Importéieren aus $param';
  }

  @override
  String get studyOrientation => 'Orientatioun';

  @override
  String get studyAnalysisMode => 'Analysemodus';

  @override
  String get studyPinnedChapterComment => 'Ugepinnten Kapitelkommentar';

  @override
  String get studySaveChapter => 'Kapitel späicheren';

  @override
  String get studyClearAnnotations => 'Annotatiounen läschen';

  @override
  String get studyClearVariations => 'Variante läschen';

  @override
  String get studyDeleteChapter => 'Kapitel läschen';

  @override
  String get studyDeleteThisChapter => 'Kapitel läschen? Et gëtt keen zeréck!';

  @override
  String get studyClearAllCommentsInThisChapter => 'All Kommentarer, Symboler an Zeechnungsformen an dësem Kapitel läschen?';

  @override
  String get studyRightUnderTheBoard => 'Direkt ënnert dem Briet';

  @override
  String get studyNoPinnedComment => 'Keng';

  @override
  String get studyNormalAnalysis => 'Normal Analyse';

  @override
  String get studyHideNextMoves => 'Nächst Zich verstoppen';

  @override
  String get studyInteractiveLesson => 'Interaktiv Übung';

  @override
  String studyChapterX(String param) {
    return 'Kapitel $param';
  }

  @override
  String get studyEmpty => 'Eidel';

  @override
  String get studyStartFromInitialPosition => 'Aus Startpositioun ufänken';

  @override
  String get studyEditor => 'Editor';

  @override
  String get studyStartFromCustomPosition => 'Aus benotzerdefinéierter Positioun ufänken';

  @override
  String get studyLoadAGameByUrl => 'Partien mat URL lueden';

  @override
  String get studyLoadAPositionFromFen => 'Positioun aus FEN lueden';

  @override
  String get studyLoadAGameFromPgn => 'Partien aus PGN lueden';

  @override
  String get studyAutomatic => 'Automatesch';

  @override
  String get studyUrlOfTheGame => 'URL vun den Partien, eng pro Zeil';

  @override
  String studyLoadAGameFromXOrY(String param1, String param2) {
    return 'Partien vun $param1 oder $param2 lueden';
  }

  @override
  String get studyCreateChapter => 'Kapitel kréieren';

  @override
  String get studyCreateStudy => 'Etüd kreéieren';

  @override
  String get studyEditStudy => 'Etüd änneren';

  @override
  String get studyVisibility => 'Visibilitéit';

  @override
  String get studyPublic => 'Ëffentlech';

  @override
  String get studyUnlisted => 'Ongelëscht';

  @override
  String get studyInviteOnly => 'Just mat Invitatioun';

  @override
  String get studyAllowCloning => 'Klonen erlaaben';

  @override
  String get studyNobody => 'Keen';

  @override
  String get studyOnlyMe => 'Just ech';

  @override
  String get studyContributors => 'Matwierkendender';

  @override
  String get studyMembers => 'Memberen';

  @override
  String get studyEveryone => 'Jiddereen';

  @override
  String get studyEnableSync => 'Synchronisatioun aktivéieren';

  @override
  String get studyYesKeepEveryoneOnTheSamePosition => 'Jo: Jiddereen op der selwechter Positioun halen';

  @override
  String get studyNoLetPeopleBrowseFreely => 'Nee: Leit individuell browsen loossen';

  @override
  String get studyPinnedStudyComment => 'Ugepinnten Etüdenkommentar';

  @override
  String get studyStart => 'Lass';

  @override
  String get studySave => 'Späicheren';

  @override
  String get studyClearChat => 'Chat läschen';

  @override
  String get studyDeleteTheStudyChatHistory => 'Etüdenchat läschen? Et gëtt keen zeréck!';

  @override
  String get studyDeleteStudy => 'Etüd läschen';

  @override
  String studyConfirmDeleteStudy(String param) {
    return 'Komplett Etüd läschen? Et gëett keen zeréck! Tipp den Numm vun der Etüd an fir ze konfirméieren: $param';
  }

  @override
  String get studyWhereDoYouWantToStudyThat => 'Wéieng Etüd wëlls du benotzen?';

  @override
  String get studyGoodMove => 'Gudden Zuch';

  @override
  String get studyMistake => 'Feeler';

  @override
  String get studyBrilliantMove => 'Brillianten Zuch';

  @override
  String get studyBlunder => 'Gaffe';

  @override
  String get studyInterestingMove => 'Interessanten Zuch';

  @override
  String get studyDubiousMove => 'Dubiosen Zuch';

  @override
  String get studyOnlyMove => 'Eenzegen Zuch';

  @override
  String get studyZugzwang => 'Zugzwang';

  @override
  String get studyEqualPosition => 'Ausgeglach Positioun';

  @override
  String get studyUnclearPosition => 'Onkloer Positioun';

  @override
  String get studyWhiteIsSlightlyBetter => 'Wäiss steet liicht besser';

  @override
  String get studyBlackIsSlightlyBetter => 'Schwaarz steet liicht besser';

  @override
  String get studyWhiteIsBetter => 'Wäiss ass besser';

  @override
  String get studyBlackIsBetter => 'Schwaarz ass besser';

  @override
  String get studyWhiteIsWinning => 'Wéiss steet op Gewënn';

  @override
  String get studyBlackIsWinning => 'Schwaarz steet op Gewënn';

  @override
  String get studyNovelty => 'Neiheet';

  @override
  String get studyDevelopment => 'Entwécklung';

  @override
  String get studyInitiative => 'Initiativ';

  @override
  String get studyAttack => 'Ugrëff';

  @override
  String get studyCounterplay => 'Géigespill';

  @override
  String get studyTimeTrouble => 'Zäitdrock';

  @override
  String get studyWithCompensation => 'Mat Kompensatioun';

  @override
  String get studyWithTheIdea => 'Mat der Iddi';

  @override
  String get studyNextChapter => 'Nächst Kapitel';

  @override
  String get studyPrevChapter => 'Kapitel virdrun';

  @override
  String get studyStudyActions => 'Etüden-Aktiounen';

  @override
  String get studyTopics => 'Themen';

  @override
  String get studyMyTopics => 'Meng Themen';

  @override
  String get studyPopularTopics => 'Beléift Themen';

  @override
  String get studyManageTopics => 'Themen managen';

  @override
  String get studyBack => 'Zeréck';

  @override
  String get studyPlayAgain => 'Nach eng Kéier spillen';

  @override
  String get studyWhatWouldYouPlay => 'Wat géifs du an dëser Positioun spillen?';

  @override
  String get studyYouCompletedThisLesson => 'Gudd gemaach! Du hues dës Übung ofgeschloss.';

  @override
  String studyPerPage(String param) {
    return '$param pro Säit';
  }

  @override
  String studyNbChapters(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Kapitel',
      one: '$count Kapitel',
    );
    return '$_temp0';
  }

  @override
  String studyNbGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Partien',
      one: '$count Partie',
    );
    return '$_temp0';
  }

  @override
  String studyNbMembers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Memberen',
      one: '$count Member',
    );
    return '$_temp0';
  }

  @override
  String studyPasteYourPgnTextHereUpToNbGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'PGN Text hei asetzen, bis zu $count Partien',
      one: 'PGN Text hei asetzen, bis zu $count Partie',
    );
    return '$_temp0';
  }
}
