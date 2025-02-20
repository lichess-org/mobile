// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'l10n.dart';

// ignore_for_file: type=lint

/// The translations for Irish (`ga`).
class AppLocalizationsGa extends AppLocalizations {
  AppLocalizationsGa([String locale = 'ga']) : super(locale);

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
  String mobileGreeting(String param) {
    return 'Hello, $param';
  }

  @override
  String get mobileGreetingWithoutName => 'Hello';

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
  String get mobilePuzzleStreakAbortWarning => 'You will lose your current streak and your score will be saved.';

  @override
  String get mobilePuzzleThemesSubtitle => 'Play puzzles from your favorite openings, or choose a theme.';

  @override
  String get mobilePuzzlesTab => 'Puzzles';

  @override
  String get mobileRecentSearches => 'Recent searches';

  @override
  String get mobileSettingsHapticFeedback => 'Haptic feedback';

  @override
  String get mobileSettingsImmersiveMode => 'Immersive mode';

  @override
  String get mobileSettingsImmersiveModeSubtitle => 'Hide system UI while playing. Use this if you are bothered by the system\'s navigation gestures at the edges of the screen. Applies to game and Puzzle Storm screens.';

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
  String get activityActivity => 'Gníomhaíocht';

  @override
  String get activityHostedALiveStream => 'Bhí sruth beo faoi cúram';

  @override
  String activityRankedInSwissTournament(String param1, String param2) {
    return 'Céim #$param1 as $param2';
  }

  @override
  String get activitySignedUp => 'Sínithe suas le lichess.org';

  @override
  String activitySupportedNbMonths(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Thacaíodh le lichess.org ar feadh $count mhí mar $param2',
      many: 'Thacaíodh le lichess.org ar feadh $count mhí mar $param2',
      few: 'Thacaigh lichess.org ar feadh $count mí mar $param2',
      two: 'Thacaíodh le lichess.org ar feadh $count mhí mar $param2',
      one: 'Thacaíodh le lichess.org ar feadh mí amháin mar $param2',
    );
    return '$_temp0';
  }

  @override
  String activityPracticedNbPositions(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Rinneadh cleachtadh ar $count suíomh de chuid $param2',
      many: 'Rinneadh cleachtadh ar $count suíomh de chuid $param2',
      few: 'Rinneadh cleachtadh ar$count suíomh de chuid $param2',
      two: 'Rinneadh cleachtadh ar $count shuíomh de chuid $param2',
      one: 'Rinneadh cleachtadh ar suíomh amháin de chuid $param2',
    );
    return '$_temp0';
  }

  @override
  String activitySolvedNbPuzzles(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count fadhb beartach réitithe',
      many: '$count fadhb beartach réitithe',
      few: '$count bhfadhb beartach réitithe',
      two: '$count fhadhb beartach réitithe',
      one: 'Fadhb beartach amháin réitithe',
    );
    return '$_temp0';
  }

  @override
  String activityPlayedNbGames(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Imríodh $count cluiche $param2',
      many: 'Imríodh $count cluiche $param2',
      few: 'Imríodh $count gcluiche $param2',
      two: 'Imríodh $count chluiche $param2',
      one: 'Imríodh cluiche amháin $param2',
    );
    return '$_temp0';
  }

  @override
  String activityPostedNbMessages(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Phostaíodh $count teachtaireachtí i $param2',
      many: 'Phostaíodh $count teachtaireachtí i $param2',
      few: 'Phostaíodh $count teachtaireachtí i $param2',
      two: 'Phostaíodh $count teachtaireachtí i $param2',
      one: 'Phostaíodh teachtaireacht amháin i $param2',
    );
    return '$_temp0';
  }

  @override
  String activityPlayedNbMoves(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count beart imeartha',
      many: '$count beart imeartha',
      few: '$count beart imeartha',
      two: '$count bheart imeartha',
      one: 'Beart amháin imeartha',
    );
    return '$_temp0';
  }

  @override
  String activityInNbCorrespondenceGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'i $count cluiche comhfhreagrais',
      many: 'i $count cluiche comhfhreagrais',
      few: 'i $count cluiche comhfhreagrais',
      two: 'i $count chluiche comhfhreagrais',
      one: 'i gcluiche amháin comhfhreagrais',
    );
    return '$_temp0';
  }

  @override
  String activityCompletedNbGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count cluiche comhfhreagrais críochnaithe',
      many: '$count cluiche comhfhreagrais críochnaithe',
      few: '$count gcluiche comhfhreagrais críochnaithe',
      two: '$count chluiche comhfhreagrais críochnaithe',
      one: '$count cluiche comhfhreagrais críochnaithe',
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
      other: 'Thosaíodh $count ficheallaí a leanacht',
      many: 'Thosaíodh $count ficheallaí a leanacht',
      few: 'Thosaíodh $count bhficheallaí a leanacht',
      two: 'Thosaíodh $count fhicheallaí a leanacht',
      one: 'Thosaíodh ficheallaí amháin a leanacht',
    );
    return '$_temp0';
  }

  @override
  String activityGainedNbFollowers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Fuarthas $count leantóir nua',
      many: 'Fuarthas $count leantóir nua',
      few: 'Fuarthas $count leantóir nua',
      two: 'Fuarthas $count leantóir nua',
      one: 'Fuarthas leantóir amháin nua',
    );
    return '$_temp0';
  }

  @override
  String activityHostedNbSimuls(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Bhí $count taispeántas comhuaineacha faoi cúram',
      many: 'Bhí $count taispeántas comhuaineacha faoi cúram',
      few: 'Bhí $count taispeántas comhuaineacha faoi cúram',
      two: 'Bhí $count taispeántas comhuaineacha faoi cúram',
      one: 'Bhí taispeántas comhuaineach amháin faoi cúram',
    );
    return '$_temp0';
  }

  @override
  String activityJoinedNbSimuls(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Glacadh páirt i $count taispeántais comhuaineacha',
      many: 'Glacadh páirt i $count taispeántais comhuaineacha',
      few: 'Glacadh páirt i $count dtaispeántais comhuaineacha',
      two: 'Glacadh páirt i $count thaispeántais comhuaineacha',
      one: 'Glacadh páirt i dtaispeántas comhuaineach amháin',
    );
    return '$_temp0';
  }

  @override
  String activityCreatedNbStudies(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Chruthaigh $count staidéar nua',
      many: 'Chruthaigh $count staidéar nua',
      few: 'Chruthaigh $count staidéar nua',
      two: 'Chruthaigh $count staidéar nua',
      one: 'Chruthaigh staidéar nua amháin',
    );
    return '$_temp0';
  }

  @override
  String activityCompetedInNbTournaments(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'San iomaíocht i $count comórtas Airéine',
      many: 'San iomaíocht i $count comórtas Airéine',
      few: 'San iomaíocht i $count gcomórtas Airéine',
      two: 'San iomaíocht i $count chomórtas Airéine',
      one: 'San iomaíocht i gcomórtas Airéine amháin',
    );
    return '$_temp0';
  }

  @override
  String activityRankedInTournament(int count, String param2, String param3, String param4) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Céimíocht #$count (an $param2% is fearr) le $param3 cluiche i $param4',
      many: 'Céimíocht #$count (an $param2% is fearr) le $param3 cluiche i $param4',
      few: 'Céimíocht #$count (an $param2% is fearr) le $param3 gcluiche i $param4',
      two: 'Céimíocht #$count (an $param2% is fearr) le $param3 chluiche i $param4',
      one: 'Céimíocht #$count (an $param2% is fearr) le $param3 cluiche i $param4',
    );
    return '$_temp0';
  }

  @override
  String activityCompetedInNbSwissTournaments(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'San iomaíocht i $count comórtas swiss',
      many: 'San iomaíocht i $count comórtas swiss',
      few: 'San iomaíocht i $count gcomórtas swiss',
      two: 'San iomaíocht i $count chomórtas swiss',
      one: 'San iomaíocht i gcomórtais swiss amháín',
    );
    return '$_temp0';
  }

  @override
  String activityJoinedNbTeams(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Isteach i $count foireann',
      many: 'Isteach i $count foireann',
      few: 'Isteach i $count bhfoireann',
      two: 'Isteach i $count fhoireann',
      one: 'Isteach i bhfoireann amháin',
    );
    return '$_temp0';
  }

  @override
  String get broadcastBroadcasts => 'Craoltaí';

  @override
  String get broadcastMyBroadcasts => 'My broadcasts';

  @override
  String get broadcastLiveBroadcasts => 'Craoltaí beo comórtais';

  @override
  String get broadcastBroadcastCalendar => 'Broadcast calendar';

  @override
  String get broadcastNewBroadcast => 'Craoladh beo nua';

  @override
  String get broadcastSubscribedBroadcasts => 'Subscribed broadcasts';

  @override
  String get broadcastAboutBroadcasts => 'About broadcasts';

  @override
  String get broadcastHowToUseLichessBroadcasts => 'How to use Lichess Broadcasts.';

  @override
  String get broadcastTheNewRoundHelp => 'The new round will have the same members and contributors as the previous one.';

  @override
  String get broadcastAddRound => 'Cuir babhta leis';

  @override
  String get broadcastOngoing => 'Leanúnach';

  @override
  String get broadcastUpcoming => 'Le teacht';

  @override
  String get broadcastRoundName => 'Ainm babhta';

  @override
  String get broadcastRoundNumber => 'Uimhir bhabhta';

  @override
  String get broadcastTournamentName => 'Ainm comórtas';

  @override
  String get broadcastTournamentDescription => 'Cur síos gairid ar an gcomórtas';

  @override
  String get broadcastFullDescription => 'Cur síos iomlán ar an ócáid';

  @override
  String broadcastFullDescriptionHelp(String param1, String param2) {
    return 'Cur síos fada roghnach ar an craoladh. Tá $param1 ar fáil. Caithfidh an fad a bheith níos lú ná $param2 carachtar.';
  }

  @override
  String get broadcastSourceSingleUrl => 'PGN Source URL';

  @override
  String get broadcastSourceUrlHelp => 'URL a seiceálfaidh Lichess chun PGN nuashonruithe a fháil. Caithfidh sé a bheith le féiceáil go poiblí ón Idirlíon.';

  @override
  String get broadcastSourceGameIds => 'Up to 64 Lichess game IDs, separated by spaces.';

  @override
  String broadcastStartDateTimeZone(String param) {
    return 'Start date in the tournament local timezone: $param';
  }

  @override
  String get broadcastStartDateHelp => 'Roghnach, má tá a fhios agat cathain a thosóidh an ócáid';

  @override
  String get broadcastCurrentGameUrl => 'URL cluiche reatha';

  @override
  String get broadcastDownloadAllRounds => 'Íoslódáil gach babhta';

  @override
  String get broadcastResetRound => 'Athshocraigh an babhta seo';

  @override
  String get broadcastDeleteRound => 'Scrios an babhta seo';

  @override
  String get broadcastDefinitivelyDeleteRound => 'Scrios go cinntitheach an babhta agus a chuid cluichí.';

  @override
  String get broadcastDeleteAllGamesOfThisRound => 'Scrios gach cluiche den bhabhta seo. Caithfidh an fhoinse a bheith gníomhach chun iad a athchruthú.';

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
  String get challengeChallengeToPlay => 'Dúshlán cluiche';

  @override
  String get challengeChallengeDeclined => 'Dúshlán diúltaithe';

  @override
  String get challengeChallengeAccepted => 'Dúshlán glactha!';

  @override
  String get challengeChallengeCanceled => 'Dúshlán ar ceal.';

  @override
  String get challengeRegisterToSendChallenges => 'Cláraigh le do thoil chun dúshláin a sheoladh.';

  @override
  String challengeYouCannotChallengeX(String param) {
    return 'Níl cead dúshlán a cuir chuig $param.';
  }

  @override
  String challengeXDoesNotAcceptChallenges(String param) {
    return 'Ní ghlacann $param le dúshláin.';
  }

  @override
  String challengeYourXRatingIsTooFarFromY(String param1, String param2) {
    return 'Tá do rátáil $param1 rófhada ó $param2.';
  }

  @override
  String challengeCannotChallengeDueToProvisionalXRating(String param) {
    return 'Ní féidir dúshlán a thabhairt mar gheall ar rátáil sealadach $param.';
  }

  @override
  String challengeXOnlyAcceptsChallengesFromFriends(String param) {
    return 'Ní ghlacann $param ach le dúshláin ó chairde.';
  }

  @override
  String get challengeDeclineGeneric => 'Nílim ag glacadh le dúshláin i láthair na huaire.';

  @override
  String get challengeDeclineLater => 'Ní am ceart dom anois, iarr arís níos déanaí.';

  @override
  String get challengeDeclineTooFast => 'Tá an maor ama seo ró-thapa dom, tabhair dúshlán arís le cluiche níos moille.';

  @override
  String get challengeDeclineTooSlow => 'Tá an maor ama seo ró-mhall dom, tabhair dúshlán arís le cluiche níos tapa.';

  @override
  String get challengeDeclineTimeControl => 'Nílim ag glacadh le dúshláin leis an maor ama seo.';

  @override
  String get challengeDeclineRated => 'Seol dúshlán rátáilte chugam ina ionad.';

  @override
  String get challengeDeclineCasual => 'Seol dúshlán fhánach chugam ina ionad.';

  @override
  String get challengeDeclineStandard => 'Nílim ag glacadh le dúshláin éagsúla anois.';

  @override
  String get challengeDeclineVariant => 'Nílim sásta an leagan seo a imirt faoi láthair.';

  @override
  String get challengeDeclineNoBot => 'Nílim ag glacadh dúshláin ó botaí.';

  @override
  String get challengeDeclineOnlyBot => 'Nílim ag glacadh ach le dúshláin ó botaí.';

  @override
  String get challengeInviteLichessUser => 'Nó tabhair cuireadh d’Úsáideoir Lichess:';

  @override
  String get contactContact => 'Teagmháil';

  @override
  String get contactContactLichess => 'Déan teagmháil le Lichess';

  @override
  String get patronDonate => 'Deonaigh';

  @override
  String get patronLichessPatron => 'Pátrún Lichess';

  @override
  String perfStatPerfStats(String param) {
    return '$param staitisticí';
  }

  @override
  String get perfStatViewTheGames => 'Féach ar na cluichí';

  @override
  String get perfStatProvisional => 'sealadach';

  @override
  String get perfStatNotEnoughRatedGames => 'Níor imríodh go leor cluichí rátáilte chun rátáil iontaofa a bhunú.';

  @override
  String perfStatProgressOverLastXGames(String param) {
    return 'Dul chun cinn le $param cluiche anuas:';
  }

  @override
  String perfStatRatingDeviation(String param) {
    return 'Diall rátála. $param.';
  }

  @override
  String perfStatRatingDeviationTooltip(String param1, String param2, String param3) {
    return 'Ciallaíonn luach níos ísle go bhfuil an rátáil níos cobhsaí. Os cionn $param1, meastar go bhfuil an rátáil sealadach. Le bheith san áireamh sna rangú, ba cheart go mbeadh an luach seo faoi bhun $param2 (ficheall caighdeánach) nó $param3 (leaganacha).';
  }

  @override
  String get perfStatTotalGames => 'Cluichí iomlána';

  @override
  String get perfStatRatedGames => 'Cluichí rátáilte';

  @override
  String get perfStatTournamentGames => 'Cluichí comórtais';

  @override
  String get perfStatBerserkedGames => 'Cluichí Bainí';

  @override
  String get perfStatTimeSpentPlaying => 'Am a chaitear ag imirt';

  @override
  String get perfStatAverageOpponent => 'Meán céile comhraic';

  @override
  String get perfStatVictories => 'Buanna';

  @override
  String get perfStatDefeats => 'Cailleadh cluichí';

  @override
  String get perfStatDisconnections => 'Dícheangail';

  @override
  String get perfStatNotEnoughGames => 'Gan go leor cluichí imearta';

  @override
  String perfStatHighestRating(String param) {
    return 'Rátáil is airde: $param';
  }

  @override
  String perfStatLowestRating(String param) {
    return 'Rátáil is ísle: $param';
  }

  @override
  String perfStatFromXToY(String param1, String param2) {
    return 'ó $param1 go $param2';
  }

  @override
  String get perfStatWinningStreak => 'Stríoc bua';

  @override
  String get perfStatLosingStreak => 'Stríoc caillte';

  @override
  String perfStatLongestStreak(String param) {
    return 'Stríoc is faide: $param';
  }

  @override
  String perfStatCurrentStreak(String param) {
    return 'Stríoc reatha: $param';
  }

  @override
  String get perfStatBestRated => 'Bua ar an rátáil is fearr';

  @override
  String get perfStatGamesInARow => 'Cluichí a imrítear i ndiaidh a chéile';

  @override
  String get perfStatLessThanOneHour => 'Níos lú ná uair an chloig idir cluichí';

  @override
  String get perfStatMaxTimePlaying => 'Uasmhéid ama caite ag imirt';

  @override
  String get perfStatNow => 'anois';

  @override
  String get preferencesPreferences => 'Socruithe';

  @override
  String get preferencesDisplay => 'Taispeáin';

  @override
  String get preferencesPrivacy => 'Príobháideacht';

  @override
  String get preferencesNotifications => 'Fógraí';

  @override
  String get preferencesPieceAnimation => 'Beochan píosa';

  @override
  String get preferencesMaterialDifference => 'Difríocht ábhartha';

  @override
  String get preferencesBoardHighlights => 'Buaicphointí an bhoird (an mbeart deireanach agus an sáinn)';

  @override
  String get preferencesPieceDestinations => 'Cinn scríbe píosaí (bearta dlithiúil agus réamh-bheart)';

  @override
  String get preferencesBoardCoordinates => 'Comhordanáidí an chlár fichille (A-H, 1-8)';

  @override
  String get preferencesMoveListWhilePlaying => 'Liosta birt agus tú ag imirt';

  @override
  String get preferencesPgnPieceNotation => 'Nodaireacht';

  @override
  String get preferencesChessPieceSymbol => 'Siombail píosa fichille';

  @override
  String get preferencesPgnLetter => 'Litie (K, Q, R, B, N)';

  @override
  String get preferencesZenMode => 'Modh Zen';

  @override
  String get preferencesShowPlayerRatings => 'Taispeáin rátálacha ficheallaí';

  @override
  String get preferencesShowFlairs => 'Show player flairs';

  @override
  String get preferencesExplainShowPlayerRatings => 'Ligeann sé seo gach rátáil a cheilt ón suíomh Gréasáin, chun cabhrú le díriú ar an bhficheall. Is féidir cluichí a rátáil fós, níl sé seo ach faoi na rudaí a fheiceann tú.';

  @override
  String get preferencesDisplayBoardResizeHandle => 'Taispeáin láimhseáil athrú méide an bhoird';

  @override
  String get preferencesOnlyOnInitialPosition => 'Suíomh tosaigh amháin';

  @override
  String get preferencesInGameOnly => 'In-game only';

  @override
  String get preferencesExceptInGame => 'Except in-game';

  @override
  String get preferencesChessClock => 'Clog fichille';

  @override
  String get preferencesTenthsOfSeconds => 'Deichiú soicind';

  @override
  String get preferencesWhenTimeRemainingLessThanTenSeconds => 'Nuair atá am fágtha < 10 soicind';

  @override
  String get preferencesHorizontalGreenProgressBars => 'Barraí cothrománacha glasa ar dhul chun cinn';

  @override
  String get preferencesSoundWhenTimeGetsCritical => 'Fuaim nuair atá an t-am criticiúil';

  @override
  String get preferencesGiveMoreTime => 'Tabhair am breise';

  @override
  String get preferencesGameBehavior => 'Iompar cluiche';

  @override
  String get preferencesHowDoYouMovePieces => 'Conas a bhogann tú píosaí?';

  @override
  String get preferencesClickTwoSquares => 'Cliceáil dhá chearnóg';

  @override
  String get preferencesDragPiece => 'Tarraing píosa';

  @override
  String get preferencesBothClicksAndDrag => 'Aon slí';

  @override
  String get preferencesPremovesPlayingDuringOpponentTurn => 'Réamh-bheart (ag imirt i lár am comhraic)';

  @override
  String get preferencesTakebacksWithOpponentApproval => 'Aistarraing (le ceadú céile comhraic)';

  @override
  String get preferencesInCasualGamesOnly => 'I gcluichí fánach amháin';

  @override
  String get preferencesPromoteToQueenAutomatically => 'Ardú go banríon sa ghnáthchúrsa';

  @override
  String get preferencesExplainPromoteToQueenAutomatically => 'Coinnigh an <ctrl> eochair síos agus ceithearnach á ardú chun uath-ardú a dhíchumasú go sealadach';

  @override
  String get preferencesWhenPremoving => 'Réamh-ghluaiseacht';

  @override
  String get preferencesClaimDrawOnThreefoldRepetitionAutomatically => 'Máigh cluiche cothrom ar athrshuíomh faoi thrí go huathoibríoch';

  @override
  String get preferencesWhenTimeRemainingLessThanThirtySeconds => 'Nuair atá am fágtha < 30 soicind';

  @override
  String get preferencesMoveConfirmation => 'Deimhniú beart';

  @override
  String get preferencesExplainCanThenBeTemporarilyDisabled => 'Can be disabled during a game with the board menu';

  @override
  String get preferencesInCorrespondenceGames => 'Cluichí comhfhreagrais';

  @override
  String get preferencesCorrespondenceAndUnlimited => 'Comhfhreagras agus neamhtheoranta';

  @override
  String get preferencesConfirmResignationAndDrawOffers => 'Deimhnigh éirí as agus tairiscintí cothroma';

  @override
  String get preferencesCastleByMovingTheKingTwoSquaresOrOntoTheRook => 'Modh caisliú';

  @override
  String get preferencesCastleByMovingTwoSquares => 'Bog an rí dhá chearnóg';

  @override
  String get preferencesCastleByMovingOntoTheRook => 'Bog rí ar caiseal';

  @override
  String get preferencesInputMovesWithTheKeyboard => 'Bogann ionchur leis an méarchlár';

  @override
  String get preferencesInputMovesWithVoice => 'Input moves with your voice';

  @override
  String get preferencesSnapArrowsToValidMoves => 'Snap saigheada chuig bearta dlithiúil';

  @override
  String get preferencesSayGgWpAfterLosingOrDrawing => 'Abair \"Cluiche maith, Grma\" ar aon cluiche cailte nó cothroma';

  @override
  String get preferencesYourPreferencesHaveBeenSaved => 'Sábháladh do chuid sainroghanna.';

  @override
  String get preferencesScrollOnTheBoardToReplayMoves => 'Scrollaigh ar an gclár chun bearta a athimirt';

  @override
  String get preferencesCorrespondenceEmailNotification => 'Ríomhphost laethúil ag liostú do chluichí comhfhreagrais';

  @override
  String get preferencesNotifyStreamStart => 'Sraoilleán ag craoladh beo';

  @override
  String get preferencesNotifyInboxMsg => 'Teachtaireacht nua sa bosca isteach';

  @override
  String get preferencesNotifyForumMention => 'Luann trácht an fhóraim tú';

  @override
  String get preferencesNotifyInvitedStudy => 'Déan staidéar ar an gcuireadh';

  @override
  String get preferencesNotifyGameEvent => 'Nuashonruithe cluiche comhfhreagrais';

  @override
  String get preferencesNotifyChallenge => 'Dúshláin';

  @override
  String get preferencesNotifyTournamentSoon => 'Comórtas ag tosú go luath';

  @override
  String get preferencesNotifyTimeAlarm => 'Clog comhfhreagrais ag rith amach';

  @override
  String get preferencesNotifyBell => 'Fógra cloig laistigh de Lichess';

  @override
  String get preferencesNotifyPush => 'Fógra gléis nuair nach bhfuil tú ar Lichess';

  @override
  String get preferencesNotifyWeb => 'Brabhsálaí';

  @override
  String get preferencesNotifyDevice => 'Gléas';

  @override
  String get preferencesBellNotificationSound => 'Bell notification sound';

  @override
  String get preferencesBlindfold => 'Blindfold';

  @override
  String get puzzlePuzzles => 'Fadhbanna';

  @override
  String get puzzlePuzzleThemes => 'Téamaí fadhbanna fichille';

  @override
  String get puzzleRecommended => 'Molta';

  @override
  String get puzzlePhases => 'Céimeanna';

  @override
  String get puzzleMotifs => 'Móitífeanna';

  @override
  String get puzzleAdvanced => 'Ardleibhéal';

  @override
  String get puzzleLengths => 'Faid';

  @override
  String get puzzleMates => 'Marbhsháinne';

  @override
  String get puzzleGoals => 'Aidhme';

  @override
  String get puzzleOrigin => 'Foinse';

  @override
  String get puzzleSpecialMoves => 'Bearta speisialta';

  @override
  String get puzzleDidYouLikeThisPuzzle => 'Ba mhaith leat an fadhb seo?';

  @override
  String get puzzleVoteToLoadNextOne => 'Vótáil chun an chéad cheann eile a lódáil!';

  @override
  String get puzzleUpVote => 'Fadhb vóta suas';

  @override
  String get puzzleDownVote => 'Fadhb vóta síos';

  @override
  String get puzzleYourPuzzleRatingWillNotChange => 'Ní thiocfaidh aon athrú ar do rátáil fadhbanna. Tabhair faoi deara nach comórtas iad fadhbanna. Cuidíonn rátáil leis na fadhbanna is fearr a roghnú do do scil reatha.';

  @override
  String get puzzleFindTheBestMoveForWhite => 'Faigh an beart is fearr do bán.';

  @override
  String get puzzleFindTheBestMoveForBlack => 'Faigh an beart is fearr do dubh.';

  @override
  String get puzzleToGetPersonalizedPuzzles => 'Chun fadhbanna pearsantaithe a fháil:';

  @override
  String puzzlePuzzleId(String param) {
    return 'Fadhb $param';
  }

  @override
  String get puzzlePuzzleOfTheDay => 'Fadhb an lae';

  @override
  String get puzzleDailyPuzzle => 'Daily Puzzle';

  @override
  String get puzzleClickToSolve => 'Cliceáil chun réitigh';

  @override
  String get puzzleGoodMove => 'Beart maith';

  @override
  String get puzzleBestMove => 'Beart is fearr!';

  @override
  String get puzzleKeepGoing => 'Lean ar aghaidh…';

  @override
  String get puzzlePuzzleSuccess => 'D\'éirigh leat!';

  @override
  String get puzzlePuzzleComplete => 'Fadhb críochnaithe!';

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
  String get puzzleNotTheMove => 'Ní hé sin an beart!';

  @override
  String get puzzleTrySomethingElse => 'Triail beart eile.';

  @override
  String puzzleRatingX(String param) {
    return 'Rátáil: $param';
  }

  @override
  String get puzzleHidden => 'folaithe';

  @override
  String puzzleFromGameLink(String param) {
    return 'Ó cluiche $param';
  }

  @override
  String get puzzleContinueTraining => 'Lean ar aghaidh le cleachtadh';

  @override
  String get puzzleDifficultyLevel => 'Deacracht';

  @override
  String get puzzleNormal => 'Gnáth';

  @override
  String get puzzleEasier => 'Níos éasca';

  @override
  String get puzzleEasiest => 'Is éasca';

  @override
  String get puzzleHarder => 'Níos deacra';

  @override
  String get puzzleHardest => 'Is deacra';

  @override
  String get puzzleExample => 'Sampla';

  @override
  String get puzzleAddAnotherTheme => 'Cuir téama eile leis';

  @override
  String get puzzleNextPuzzle => 'An chéad bhfadhb eile';

  @override
  String get puzzleJumpToNextPuzzleImmediately => 'Léim chuig an chéad fadhbh eile láithreach';

  @override
  String get puzzlePuzzleDashboard => 'Painéal fadhbhanna';

  @override
  String get puzzleImprovementAreas => 'Réimsí feabhsúcháin';

  @override
  String get puzzleStrengths => 'Cumais';

  @override
  String get puzzleHistory => 'Stair fadhbhanna';

  @override
  String get puzzleSolved => 'réitithe';

  @override
  String get puzzleFailed => 'teipthe';

  @override
  String get puzzleStreakDescription => 'Réitigh fadhbhanna níos deacra de réir a chéile chun stríoc buaite a thiomsú. Níl aon chlog ann, mar sin tóg do chuid ama. Beart mícheart amháin, agus tá an cluiche thart! Ach is féidir beart a scipeáil uair amháin i seisiúin.';

  @override
  String puzzleYourStreakX(String param) {
    return 'Do stríoc: $param';
  }

  @override
  String get puzzleStreakSkipExplanation => 'Scipeáil an beart seo chun do stríoc a choinneáil! Ní oibríonn sé ach uair amháin i sruth.';

  @override
  String get puzzleContinueTheStreak => 'Lean leis an stríoc';

  @override
  String get puzzleNewStreak => 'Stríoc nua';

  @override
  String get puzzleFromMyGames => 'Ó mo chluichí';

  @override
  String get puzzleLookupOfPlayer => 'Cuardaigh fadhbanna ó chluichí imreoir';

  @override
  String puzzleFromXGames(String param) {
    return 'Fadhbanna ó chluichí $param\'';
  }

  @override
  String get puzzleSearchPuzzles => 'Cuardaigh fadhbanna';

  @override
  String get puzzleFromMyGamesNone => 'Níl aon fadhb agat sa bhunachar sonraí, ach is breá le Lichess tú go mór fós. \nImir cluichí gasta agus clasaiceacha chun cur leis na seansanna go gcuirfear fadhb de do chuid féin leis!';

  @override
  String puzzleFromXGamesFound(String param1, String param2) {
    return '$param1 fadhb le fáil i $param2 cluiche';
  }

  @override
  String get puzzlePuzzleDashboardDescription => 'Traenáil, anailís, feabhsú';

  @override
  String puzzlePercentSolved(String param) {
    return 'Réitíodh $param';
  }

  @override
  String get puzzleNoPuzzlesToShow => 'Níl rud le taispeáint, imirt roinnt fadhb ar dtús!';

  @override
  String get puzzleImprovementAreasDescription => 'Traenáil iad seo chun do fhorbairt a bharrfheabhsú!';

  @override
  String get puzzleStrengthDescription => 'Cruthaigh tú an chuid is fearr sna réimsí seo';

  @override
  String puzzlePlayedXTimes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Imeartha $count uair',
      many: 'Imeartha $count uair',
      few: 'Imeartha $count uair',
      two: 'Imeartha $count uair',
      one: 'Imeartha $count uair',
    );
    return '$_temp0';
  }

  @override
  String puzzleNbPointsBelowYourPuzzleRating(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count pointe faoi bhun do rátáil faidhbe',
      many: '$count pointe faoi bhun do rátáil faidhbe',
      few: '$count bpointe faoi bhun do rátáil faidhbe',
      two: '$count phointe faoi bhun do rátáil faidhbe',
      one: 'Pointe amháin faoi bhun do rátáil faidhbe',
    );
    return '$_temp0';
  }

  @override
  String puzzleNbPointsAboveYourPuzzleRating(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count pointe os comhair do rátáil faidhbe',
      many: '$count pointe os comhair do rátáil faidhbe',
      few: '$count bpointe os comhair do rátáil faidhbe',
      two: '$count phointe os comhair do rátáil faidhbe',
      one: 'Pointe amháin os comhair do rátáil faidhbe',
    );
    return '$_temp0';
  }

  @override
  String puzzleNbPlayed(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'D\'imir $count',
      many: 'D\'imir $count',
      few: 'D\'imir $count',
      two: 'D\'imir $count',
      one: 'D\'imir $count',
    );
    return '$_temp0';
  }

  @override
  String puzzleNbToReplay(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count athimirt',
      many: '$count athimirt',
      few: '$count athimirt',
      two: '$count athimirt',
      one: '$count athimirt',
    );
    return '$_temp0';
  }

  @override
  String get puzzleThemeAdvancedPawn => 'Ceithearnach chun cinn';

  @override
  String get puzzleThemeAdvancedPawnDescription => 'Tá ceithearnach ag ardú nó atá ag bagairt ardú ríthábhachtach don bheartaíocht.';

  @override
  String get puzzleThemeAdvantage => 'Buntáiste';

  @override
  String get puzzleThemeAdvantageDescription => 'Tóg do sheans buntáiste ceart a fháil. (200cp ≤ meast ≤ 600cp)';

  @override
  String get puzzleThemeAnastasiaMate => 'Marbhsháinn Anastasia';

  @override
  String get puzzleThemeAnastasiaMateDescription => 'Oibríonn ridire agus caiseal nó banríon le chéile chun rí an namhaid a cheansaigh idir imeall an clár fichille agus píosa cairdiúil.';

  @override
  String get puzzleThemeArabianMate => 'Marbhsháinn Arabaigh';

  @override
  String get puzzleThemeArabianMateDescription => 'Oibríonn ridire agus caiseal le chéile chun rí an namhaid a cheansaigh idir cúinne an clár fichille.';

  @override
  String get puzzleThemeAttackingF2F7 => 'Ag ionsaí f2 nó f7';

  @override
  String get puzzleThemeAttackingF2F7Description => 'Ionsaí ag díriú ar an ceithearnach f2 nó f7, mar shampla ins an oscailt ae friochta.';

  @override
  String get puzzleThemeAttraction => 'Meabhlú';

  @override
  String get puzzleThemeAttractionDescription => 'Malartú nó íobairt a spreagann nó a chuireann brú ar phíosa comhraic dul go cearnóg a cheadaíonn beartíocht leantach.';

  @override
  String get puzzleThemeBackRankMate => 'Marbhsháinn céim ar cúl';

  @override
  String get puzzleThemeBackRankMateDescription => 'Déan marbhsháinn ar an rí ar an céim baile, sa tslí go bhfuil sé gafa ansin lena phíosaí féin.';

  @override
  String get puzzleThemeBishopEndgame => 'Cor deiridh easpaig';

  @override
  String get puzzleThemeBishopEndgameDescription => 'Cor deiridh le easpaig agus ceithearnaigh amháin.';

  @override
  String get puzzleThemeBodenMate => 'Marbhsháinn Boden';

  @override
  String get puzzleThemeBodenMateDescription => 'Déanann dhá easpaig ar fiarthrasnáin chliathach ionsaí marbhsháinn ar rí a bhfuil píosaí cairdiúla ag cur bac air.';

  @override
  String get puzzleThemeCastling => 'Caisliú';

  @override
  String get puzzleThemeCastlingDescription => 'Cuir an rí i bhfolach, agus scaoil an caiseal le haghaidh ionsaí.';

  @override
  String get puzzleThemeCapturingDefender => 'Marú an cosantóir';

  @override
  String get puzzleThemeCapturingDefenderDescription => 'Bain amach píosa atá ríthábhachtach do cosaint píosa eile, ag ceadaigh an píosa atá anois gan chosaint a mharú an sa chéad bheart ina dhiaidh.';

  @override
  String get puzzleThemeCrushing => 'Tubaisteach';

  @override
  String get puzzleThemeCrushingDescription => 'Féach ar earráid an chéile comhraic chun buntáiste cumhachtach a fháil. (meastóireacht ≥ 600cp)';

  @override
  String get puzzleThemeDoubleBishopMate => 'Marbhsháinn dhá easpag';

  @override
  String get puzzleThemeDoubleBishopMateDescription => 'Dhá ionsaitheoir easpig ar trasnáin cóngarach dá chéile marbhsháinn ar rí ina bhfuil píosaí cairdiúla ag cuir bac air.';

  @override
  String get puzzleThemeDovetailMate => 'Marbhsháinn déada';

  @override
  String get puzzleThemeDovetailMateDescription => 'Déanann banríon marbhsháinn ar rí cóngarach dí, níl ach dhá chearnóg éalaithe aige agus tá a píosaí cairdiúla ag cuir cosc ar a soghluaisteacht chuig na cearnóga seo.';

  @override
  String get puzzleThemeEquality => 'Comhionannas';

  @override
  String get puzzleThemeEqualityDescription => 'Tar ar ais ó suíomh caillte, agus faigh cluiche cothrom nó suíomh cothrom. (meastóireacht ≤ 200cp)';

  @override
  String get puzzleThemeKingsideAttack => 'Ionsaí ar taobh an rí';

  @override
  String get puzzleThemeKingsideAttackDescription => 'Ionsaí ar rí an chéile comhraic, tar éis dóibh caisliú ar thaobh an rí.';

  @override
  String get puzzleThemeClearance => 'Glanadh';

  @override
  String get puzzleThemeClearanceDescription => 'Beart, go minic le luas, a ghlanann cearnóg, treas nó fiarthrasnán le haghaidh smaoineamh beartach.';

  @override
  String get puzzleThemeDefensiveMove => 'Beart cosanta';

  @override
  String get puzzleThemeDefensiveMoveDescription => 'Beart cruinn nó staith bearta atá tábhachtach chun cailliúint ábhair nó buntáiste eile a sheachaint.';

  @override
  String get puzzleThemeDeflection => 'Sraonadh';

  @override
  String get puzzleThemeDeflectionDescription => 'Beart a cureann mearú ar píosa do chomhraic chéile atá gnóthach ar post eile, mar shampla ag déanamh cosaint ar cearnóg. Uaireanta tugtar \"ró-ualú\" air fosta.';

  @override
  String get puzzleThemeDiscoveredAttack => 'Ionsaí nochta';

  @override
  String get puzzleThemeDiscoveredAttackDescription => 'Ag bogadh píosa (ridire b\'fhéidir), a chuir bac ar ionsaí roimhe seo le píosa fadraoin (caiseal b\'fhéidir), as bealach an phíosa sin.';

  @override
  String get puzzleThemeDoubleCheck => 'Sáinn faoi dhó';

  @override
  String get puzzleThemeDoubleCheckDescription => 'Ag sáiniú le dhá phíosa ag an am céanna, tar éis ionsaí nochta ina n-ionsaíonn an píosa gluaiseachta agus an píosa nochtaithe araon rí an chéile comhraic.';

  @override
  String get puzzleThemeEndgame => 'Cor deiridh';

  @override
  String get puzzleThemeEndgameDescription => 'Beartaíocht i gcor deiridh na cluiche.';

  @override
  String get puzzleThemeEnPassantDescription => 'Beartaíocht a bhaineann leis an riail en passant, sa tslí gur féidir le ceithearnach ceithearnach an céile comhraic a mharú agus é ag úsáid a ghluaiseachta tosaigh dhá chearnóg.';

  @override
  String get puzzleThemeExposedKing => 'Rí nochtaithe';

  @override
  String get puzzleThemeExposedKingDescription => 'Beartaíocht ina bhfuil rí gan mórán cosantóirí timpeall air, agus marbhsháinn mar thoradh air go minic.';

  @override
  String get puzzleThemeFork => 'Gabhal';

  @override
  String get puzzleThemeForkDescription => 'Saghas ionsaí faoi dhó nó bagairt dhúbailte.';

  @override
  String get puzzleThemeHangingPiece => 'Píosa ar crochadh';

  @override
  String get puzzleThemeHangingPieceDescription => 'Beartaíocht ina bhfuil píosa comhraic gan chosaint nó gan chosaint go leor agus saor le marú.';

  @override
  String get puzzleThemeHookMate => 'Marbhsháinn corrán';

  @override
  String get puzzleThemeHookMateDescription => 'Marbhsháinn le caiseal, ridire, agus ceithearnach in éineacht le ceithearnach namhaid amháin chun éalú rí an namhaid a chosc.';

  @override
  String get puzzleThemeInterference => 'Bac';

  @override
  String get puzzleThemeInterferenceDescription => 'Ag bogadh píosa idir dhá phíosa do chéile comhraic chun píosa comhraic amháin nó an dá phíosa comhraic a fhágáil gan chosaint, mar ridire ar chearnóg chosanta idir dhá chaiseal.';

  @override
  String get puzzleThemeIntermezzo => 'Intermezzo';

  @override
  String get puzzleThemeIntermezzoDescription => 'Tarlaíonn Zwischenzug i lár malartú píosaí nó i líne beartaíochta in áit eile ar an gclár nuair a ghluaiseann imreoir píosa ar shlí nach bhfuil an t-imreoir eile ag súil leis chun suíomh níos fearr a fháil.';

  @override
  String get puzzleThemeKillBoxMate => 'Kill box mate';

  @override
  String get puzzleThemeKillBoxMateDescription => 'A rook is next to the enemy king and supported by a queen that also blocks the king\'s escape squares. The rook and the queen catch the enemy king in a 3 by 3 \"kill box\".';

  @override
  String get puzzleThemeVukovicMate => 'Vukovic mate';

  @override
  String get puzzleThemeVukovicMateDescription => 'A rook and knight team up to mate the king. The rook delivers mate while supported by a third piece, and the knight is used to block the king\'s escape squares.';

  @override
  String get puzzleThemeKnightEndgame => 'Cor deiridh ridire';

  @override
  String get puzzleThemeKnightEndgameDescription => 'Cor deiridh le ridirí agus ceithearnaigh amháin.';

  @override
  String get puzzleThemeLong => 'Fadhbh fada';

  @override
  String get puzzleThemeLongDescription => 'Trí bheart le bua.';

  @override
  String get puzzleThemeMaster => 'Máistir-chluichí';

  @override
  String get puzzleThemeMasterDescription => 'Fadhbhanna ó chluichí a imríonn ficheallaí le teideal.';

  @override
  String get puzzleThemeMasterVsMaster => 'Cluichí Máistir vs Máistir';

  @override
  String get puzzleThemeMasterVsMasterDescription => 'Fadhbhanna ó chluichí idir dhá fhicheallaí le teideal.';

  @override
  String get puzzleThemeMate => 'Marbhsháinn';

  @override
  String get puzzleThemeMateDescription => 'Buaigh an cluiche le stíl.';

  @override
  String get puzzleThemeMateIn1 => 'Marbhsháinn i mbeart amháin';

  @override
  String get puzzleThemeMateIn1Description => 'Tabhair Marbhsháinn i mbeart amháin.';

  @override
  String get puzzleThemeMateIn2 => 'Marbhsháinn i 2 bheart';

  @override
  String get puzzleThemeMateIn2Description => 'Tabhair Marbhsháinn i dhá bheart.';

  @override
  String get puzzleThemeMateIn3 => 'Marbhsháinn i 3 bheart';

  @override
  String get puzzleThemeMateIn3Description => 'Tabhair Marbhsháinn i dtrí bheart.';

  @override
  String get puzzleThemeMateIn4 => 'Marbhsháinn i 4 bheart';

  @override
  String get puzzleThemeMateIn4Description => 'Tabhair Marbhsháinn i ceithre bheart.';

  @override
  String get puzzleThemeMateIn5 => 'Marbhsháinn i 5 mbeart nó níos mó';

  @override
  String get puzzleThemeMateIn5Description => 'Obair amach an marbháháinn le seicheamh fada.';

  @override
  String get puzzleThemeMiddlegame => 'Lár an cluiche';

  @override
  String get puzzleThemeMiddlegameDescription => 'Beartaíocht san dara céim den chluiche.';

  @override
  String get puzzleThemeOneMove => 'Fadhbh beart-amháin';

  @override
  String get puzzleThemeOneMoveDescription => 'Fadhbh nach bhfuil ach beart amháin fada.';

  @override
  String get puzzleThemeOpening => 'Oscail';

  @override
  String get puzzleThemeOpeningDescription => 'Beartaíocht san céad céim den chluiche.';

  @override
  String get puzzleThemePawnEndgame => 'Cor deiridh na ceithearnaigh';

  @override
  String get puzzleThemePawnEndgameDescription => 'Deireadh cluiche le ceithearnaigh amháin.';

  @override
  String get puzzleThemePin => 'Teannta';

  @override
  String get puzzleThemePinDescription => 'Beartaíocht le teannta, nuair nach féidir le píosa bogadh gan ionsaí a nochtadh ar phíosa le cuacht níos mó.';

  @override
  String get puzzleThemePromotion => 'Ardú';

  @override
  String get puzzleThemePromotionDescription => '\'Sé ceithearnach atá ag ardú nó ag bagairt ardú lár an bartaíocht.';

  @override
  String get puzzleThemeQueenEndgame => 'Cor deiridh na mbanríona';

  @override
  String get puzzleThemeQueenEndgameDescription => 'Cor deiridh le banríonacha agus ceithearnaigh amháin.';

  @override
  String get puzzleThemeQueenRookEndgame => 'Cor deiridh don Banríon agus Casieal';

  @override
  String get puzzleThemeQueenRookEndgameDescription => 'Cor deiridh gan aon píosa ach banríona, caisil, agus ceithearnaigh.';

  @override
  String get puzzleThemeQueensideAttack => 'Ionsaí ar taobh na mbanríona';

  @override
  String get puzzleThemeQueensideAttackDescription => 'Ionsaí ar rí an namhaid, tar éis dóibh caisliú ar taobh na mbanríona.';

  @override
  String get puzzleThemeQuietMove => 'Beart cúin';

  @override
  String get puzzleThemeQuietMoveDescription => 'Beart nach ndéanann sáinn nó marú, ach a ullmhaíonn bagairt dosheachanta le haghaidh beart níos déanaí.';

  @override
  String get puzzleThemeRookEndgame => 'Cor deiridh caiseal';

  @override
  String get puzzleThemeRookEndgameDescription => 'Cor deiridh le caisil agus ceithearnaigh amháin.';

  @override
  String get puzzleThemeSacrifice => 'Íobairt';

  @override
  String get puzzleThemeSacrificeDescription => 'Beartaíocht a bhaineann le íobairt píosa sa ghearrthéarma, chun buntáiste a fháil tar éis bearta éigeantach.';

  @override
  String get puzzleThemeShort => 'Fadhbh gearr';

  @override
  String get puzzleThemeShortDescription => 'Dhá bheart le bua.';

  @override
  String get puzzleThemeSkewer => 'Sá';

  @override
  String get puzzleThemeSkewerDescription => 'Móitíf ina bhfuil píosa cuachtach á ionsaí, ag bogadh amach as bealach, agus ag ligean píosa le cuacht níos ísle a mharú nó a ionsaí, inbhéart teannta.';

  @override
  String get puzzleThemeSmotheredMate => 'Sáinn plúchta';

  @override
  String get puzzleThemeSmotheredMateDescription => 'Marbhsháinn ó ridire ina bhfuil an rí faoin ionsaí greimithe (nó plúchta) toisc go bhfuil a phíosaí féin timpeall air.';

  @override
  String get puzzleThemeSuperGM => 'Cluichí Super GM';

  @override
  String get puzzleThemeSuperGMDescription => 'Fadhbhanna ó chluichí a d’imir na bhficheallaithe is fearr ar an domhan.';

  @override
  String get puzzleThemeTrappedPiece => 'Píosa gafa';

  @override
  String get puzzleThemeTrappedPieceDescription => 'Ní féidir le píosa éalú ó marú toisc go bhfuil soghluaiseacht teoranta aige.';

  @override
  String get puzzleThemeUnderPromotion => 'Foardú';

  @override
  String get puzzleThemeUnderPromotionDescription => 'Ridire, easpag, nó caiseal a ardú.';

  @override
  String get puzzleThemeVeryLong => 'Fadhbh an-fhada';

  @override
  String get puzzleThemeVeryLongDescription => 'Ceithre bheart nó níos mó le buachan.';

  @override
  String get puzzleThemeXRayAttack => 'Ionsaí x-ghathaithe';

  @override
  String get puzzleThemeXRayAttackDescription => 'Déanann píosa ionsaí nó cosaint ar chearnóg, trí phíosa namhaid.';

  @override
  String get puzzleThemeZugzwang => 'Zugzwang';

  @override
  String get puzzleThemeZugzwangDescription => 'Ciallaíonn Zugzwang gur gá le himreoir a s(h) eans a \nthógáil cé nár mhaith leis nó léi toisc gur laige a bheith a s(h) uíomh cibé beart a dhéanfaidh sé/sí. Ba mhaith leis / léi \"háram\" a rá ach níl sé sin ceadaithe.';

  @override
  String get puzzleThemeMix => 'Meascán sláintiúil';

  @override
  String get puzzleThemeMixDescription => 'Giota de gach rud. Níl a fhios agat cad tá os do comhair, mar sin fanann tú réidh le haghaidh athan bith! Díreach mar atá i gcluichí fíor.';

  @override
  String get puzzleThemePlayerGames => 'Cluichí imreoir';

  @override
  String get puzzleThemePlayerGamesDescription => 'Cuardaigh fadhbanna a ghintear ó do chluichí, nó ó chluichí imreoir eile.';

  @override
  String puzzleThemePuzzleDownloadInformation(String param) {
    return 'Tá na fadhbanna seo i mbéal an phobail, agus is féidir iad a íoslódáil ó $param.';
  }

  @override
  String get searchSearch => 'Cuardaigh';

  @override
  String get settingsSettings => 'Socruithe';

  @override
  String get settingsCloseAccount => 'Dún cuntas';

  @override
  String get settingsManagedAccountCannotBeClosed => 'Tá do chuntas á bhainistiú, agus ní féidir é a dhúnadh.';

  @override
  String get settingsCantOpenSimilarAccount => 'Ní cheadófar duit cuntas nua a oscailt leis an ainm céanna, fiú má tá an cás difriúil.';

  @override
  String get settingsCancelKeepAccount => 'Cancel and keep my account';

  @override
  String get settingsCloseAccountAreYouSure => 'Are you sure you want to close your account?';

  @override
  String get settingsThisAccountIsClosed => 'Tá an cuntas seo dúnta.';

  @override
  String get playWithAFriend => 'Imir le cara';

  @override
  String get playWithTheMachine => 'Imir in aghaidh an ríomhaire';

  @override
  String get toInviteSomeoneToPlayGiveThisUrl => 'Chun cuireadh a thabhairt do dhuine, tabhair an URL seo dóibh';

  @override
  String get gameOver => 'Cluiche Thart';

  @override
  String get waitingForOpponent => 'Ag fanacht ar chéile comhraic';

  @override
  String get orLetYourOpponentScanQrCode => 'Or let your opponent scan this QR code';

  @override
  String get waiting => 'Ag fanacht';

  @override
  String get yourTurn => 'Do sheal';

  @override
  String aiNameLevelAiLevel(String param1, String param2) {
    return '$param1 leibhéal $param2';
  }

  @override
  String get level => 'Leibhéal';

  @override
  String get strength => 'Caighdeán imeartha';

  @override
  String get toggleTheChat => 'Scoránaigh an comhrá';

  @override
  String get chat => 'Tosaigh comhrá';

  @override
  String get resign => 'Éirigh as';

  @override
  String get checkmate => 'Marbhsháinn';

  @override
  String get stalemate => 'Leamhsháinn';

  @override
  String get white => 'Bán';

  @override
  String get black => 'Dubh';

  @override
  String get asWhite => 'mar bán';

  @override
  String get asBlack => 'mar dubh';

  @override
  String get randomColor => 'Taobh randamach';

  @override
  String get createAGame => 'Cruthaigh cluiche';

  @override
  String get whiteIsVictorious => 'Tá an bua ag Bán';

  @override
  String get blackIsVictorious => 'Tá an bua ag Dubh';

  @override
  String get youPlayTheWhitePieces => 'Imir leis na píosaí bána';

  @override
  String get youPlayTheBlackPieces => 'Imir leis na píosaí dubha';

  @override
  String get itsYourTurn => 'Is é do sheal!';

  @override
  String get cheatDetected => 'Caimiléireacht Aimsithe';

  @override
  String get kingInTheCenter => 'Rí sa lár';

  @override
  String get threeChecks => 'Trí sháinn';

  @override
  String get raceFinished => 'Rás críochnaithe';

  @override
  String get variantEnding => 'Leagan críoch';

  @override
  String get newOpponent => 'Céile comhraic nua';

  @override
  String get yourOpponentWantsToPlayANewGameWithYou => 'Ba mhaith le do chéile comhraic cluiche nua a imirt leat';

  @override
  String get joinTheGame => 'Téigh isteach sa chluiche';

  @override
  String get whitePlays => 'Is le Bán an imirt';

  @override
  String get blackPlays => 'Is le Dubh an imirt';

  @override
  String get opponentLeftChoices => 'D’fhág do chéile comhraic an cluiche. Féadfaidh tú an bua a fháil, an cluiche a chríochnú ar chomhscór, nó fanacht.';

  @override
  String get forceResignation => 'Maígh an bua';

  @override
  String get forceDraw => 'Fógair cluiche cothrom';

  @override
  String get talkInChat => 'Bí dea-bhéasach sa chomhrá!';

  @override
  String get theFirstPersonToComeOnThisUrlWillPlayWithYou => 'Imreoidh an chéad duine a thagann go dtí an URL seo leat';

  @override
  String get whiteResigned => 'D\'éirigh Bán as';

  @override
  String get blackResigned => 'D\'éirigh Dubh as';

  @override
  String get whiteLeftTheGame => 'D\'fhág Bán an cluiche';

  @override
  String get blackLeftTheGame => 'D\'fhág Dubh an cluiche';

  @override
  String get whiteDidntMove => 'Níor bhog bán';

  @override
  String get blackDidntMove => 'Níor bhog dubh';

  @override
  String get requestAComputerAnalysis => 'Iarr anailís an ríomhaire';

  @override
  String get computerAnalysis => 'Anailís an ríomhaire';

  @override
  String get computerAnalysisAvailable => 'Anailís an ríomhaire ar fáil';

  @override
  String get computerAnalysisDisabled => 'Anailís ríomhaireachta díchumasaithe';

  @override
  String get analysis => 'Clár anailíse';

  @override
  String depthX(String param) {
    return 'Doimhneacht $param';
  }

  @override
  String get usingServerAnalysis => 'Ag úsáid anailís freastalaí';

  @override
  String get loadingEngine => 'Inneall ag lódáil...';

  @override
  String get calculatingMoves => 'Bearta á ríomh...';

  @override
  String get engineFailed => 'Earráid agus an t-inneall á lódáil';

  @override
  String get cloudAnalysis => 'Anailís scamaill';

  @override
  String get goDeeper => 'Téigh níos doimhne';

  @override
  String get showThreat => 'Taispeáin an bhagairt';

  @override
  String get inLocalBrowser => 'sa bhrabhsálaí áitiúil';

  @override
  String get toggleLocalEvaluation => 'Scoránú measúnú áitiúil';

  @override
  String get promoteVariation => 'Cuir éagsúlacht chun cinn';

  @override
  String get makeMainLine => 'Déan príomhlíne';

  @override
  String get deleteFromHere => 'Scrios as seo';

  @override
  String get collapseVariations => 'Collapse variations';

  @override
  String get expandVariations => 'Expand variations';

  @override
  String get forceVariation => 'Éagsúlacht fórsa';

  @override
  String get copyVariationPgn => 'Copy variation PGN';

  @override
  String get move => 'Beart';

  @override
  String get variantLoss => 'Caill malartach';

  @override
  String get variantWin => 'Bua malartach';

  @override
  String get insufficientMaterial => 'Easpa píosaí don marbhsháinn';

  @override
  String get pawnMove => 'Beart ceithearnach';

  @override
  String get capture => 'Marú';

  @override
  String get close => 'Dún';

  @override
  String get winning => 'Ag baint';

  @override
  String get losing => 'Ag cailleadh';

  @override
  String get drawn => 'Comhscór';

  @override
  String get unknown => 'Anaithnid';

  @override
  String get database => 'Bunachar';

  @override
  String get whiteDrawBlack => 'Bán / Comhscór / Dubh';

  @override
  String averageRatingX(String param) {
    return 'Meán-rátáil: $param';
  }

  @override
  String get recentGames => 'Cluichí is déanaí';

  @override
  String get topGames => 'Cluichí is fearr';

  @override
  String masterDbExplanation(String param1, String param2, String param3) {
    return 'Dhá mhilliúin cluiche thar an mbord $param1 imreoirí le rátáil FIDE ó $param2 go $param3';
  }

  @override
  String get dtzWithRounding => 'DTZ50\'\' le slánú, bunaithe ar líon na leathbheart go dtí an chéad ghabháil nó beart ceaithearnach';

  @override
  String get noGameFound => 'Níor aimsíodh cluiche';

  @override
  String get maxDepthReached => 'Doimhneacht uasta bainte amach!';

  @override
  String get maybeIncludeMoreGamesFromThePreferencesMenu => 'D\'fheadfaí níos mó cluichí a chur san áireamh ón roghchlár?';

  @override
  String get openings => 'Oscailtí';

  @override
  String get openingExplorer => 'Ag oscailt taiscéalaí';

  @override
  String get openingEndgameExplorer => 'Taiscéalaí oscailte / deireadh an chluiche';

  @override
  String xOpeningExplorer(String param) {
    return '$param ag oscailt taiscéalaí';
  }

  @override
  String get playFirstOpeningEndgameExplorerMove => 'Play first opening/endgame-explorer move';

  @override
  String get winPreventedBy50MoveRule => 'Bac ar bhua mar gheall ar riail an 50 bheart';

  @override
  String get lossSavedBy50MoveRule => 'Bac ar chaill mar gheall arriail an 50 bheart';

  @override
  String get winOr50MovesByPriorMistake => 'Bua nó 50 beart trí bhotún roimhe seo';

  @override
  String get lossOr50MovesByPriorMistake => 'Cailleadh nó 50 beart trí bhotún roimhe seo';

  @override
  String get unknownDueToRounding => 'Ní ráthaítear bua / caillteanas ach má leanadh an líne mholta boird ón mbeart gabhála nó ceithearnach deireanach, mar gheall ar chothromú féideartha luachanna DTZ i mboscaí tábla Syzygy.';

  @override
  String get allSet => 'Réidh le himirt!';

  @override
  String get importPgn => 'Iompórtáil PGN';

  @override
  String get delete => 'Scrios';

  @override
  String get deleteThisImportedGame => 'Scrios an cluiche iompórtáilte seo?';

  @override
  String get replayMode => 'Modh athimeartha';

  @override
  String get realtimeReplay => 'Fíor-am';

  @override
  String get byCPL => 'De réir CPL';

  @override
  String get enable => 'Cumasaigh';

  @override
  String get bestMoveArrow => 'Saighead don bheart is fearr';

  @override
  String get showVariationArrows => 'Show variation arrows';

  @override
  String get evaluationGauge => 'Tomhsaire measúnachta';

  @override
  String get multipleLines => 'Línte ar leith';

  @override
  String get cpus => 'LAPanna';

  @override
  String get memory => 'Cuimhne';

  @override
  String get infiniteAnalysis => 'Anailís gan teorainn';

  @override
  String get removesTheDepthLimit => 'Faigheann sé réidh leis an teorainn doimhneachta, agus coinníonn sé do ríomhaire te';

  @override
  String get blunder => 'Meancóg';

  @override
  String get mistake => 'Botún';

  @override
  String get inaccuracy => 'Míchruinneas';

  @override
  String get moveTimes => 'Amanna na mbearta';

  @override
  String get flipBoard => 'Cas an bord';

  @override
  String get threefoldRepetition => 'Athriocht faoi thrí';

  @override
  String get claimADraw => 'Maígh comhscór';

  @override
  String get offerDraw => 'Tairg comhscór';

  @override
  String get draw => 'Comhscór';

  @override
  String get drawByMutualAgreement => 'Cluiche cothrom trí chomhaontú frithpháirteach';

  @override
  String get fiftyMovesWithoutProgress => 'Caoga beart gan dul chun cinn';

  @override
  String get currentGames => 'Cluichí reatha';

  @override
  String get viewInFullSize => 'Breathnaigh in lánmhéid';

  @override
  String get logOut => 'Logáil amach';

  @override
  String get signIn => 'Logáil isteach';

  @override
  String get rememberMe => 'Coinnigh logáilte istigh mé';

  @override
  String get youNeedAnAccountToDoThat => 'Tá cuntas ag teastáil uait chun é sin a dhéanamh';

  @override
  String get signUp => 'Cláraigh';

  @override
  String get computersAreNotAllowedToPlay => 'Níl cead ag ríomhair agus imreoirí le cabhair ó ríomhairí imirt. Ná bí ag lorg cabhrach ó innill fichille, bunachair sonraí nó imreoirí eile agus tú ag imirt. Moltar go láidir gan iliomaid cuntais a chruthú agus is féidir cosc a chur ar úsáideoirí as an iomarca cuntais a chruthú.';

  @override
  String get games => 'Cluichí';

  @override
  String get forum => 'Fóram';

  @override
  String xPostedInForumY(String param1, String param2) {
    return 'Scríobh $param1 teachtaireacht sa topaic $param2';
  }

  @override
  String get latestForumPosts => 'Postálacha fóraim is déanaí';

  @override
  String get players => 'Imreoirí';

  @override
  String get friends => 'Cairde';

  @override
  String get otherPlayers => 'other players';

  @override
  String get discussions => 'Comhráite';

  @override
  String get today => 'Inniu';

  @override
  String get yesterday => 'Inné';

  @override
  String get minutesPerSide => 'Nóiméid an taobh';

  @override
  String get variant => 'Athróg';

  @override
  String get variants => 'Athróga';

  @override
  String get timeControl => 'Rialú ama';

  @override
  String get realTime => 'Fíor-am';

  @override
  String get correspondence => 'Comhfhreagras';

  @override
  String get daysPerTurn => 'Laethanta sa bheart';

  @override
  String get oneDay => 'Lá amháin';

  @override
  String get time => 'Am';

  @override
  String get rating => 'Rátáil';

  @override
  String get ratingStats => 'Staitisticí rátála';

  @override
  String get username => 'Ainm úsáideora';

  @override
  String get usernameOrEmail => 'Ainm úsáideora nó seoladh ríomphoist';

  @override
  String get changeUsername => 'Athraigh ainm úsáideora';

  @override
  String get changeUsernameNotSame => 'Ní féidir ach cás na litreacha a athrú. Mar shampla ó \"seanog\" go \"SeanOg\".';

  @override
  String get changeUsernameDescription => 'Athraigh d\'ainm úsáideora. Ní féidir é seo a dhéanamh ach uair amháin agus ní cheadaítear duit ach cás na litreacha i d’ainm úsáideora a athrú.';

  @override
  String get signupUsernameHint => 'Déan cinnte ainm úsáideora a oireann don teaghlach a roghnú. Ní féidir leat é a athrú ina dhiaidh agus dúnfar aon chuntais a bhfuil ainmneacha úsáideora míchuí orthu!';

  @override
  String get signupEmailHint => 'Ní úsáidfimid é ach le haghaidh athshocrú pasfhocail.';

  @override
  String get password => 'Pasfhocal';

  @override
  String get changePassword => 'Athraigh pasfhocal';

  @override
  String get changeEmail => 'Athraigh do sheoladh ríomhphoist';

  @override
  String get email => 'Ríomhphost';

  @override
  String get passwordReset => 'Athshocraigh pasfhocal';

  @override
  String get forgotPassword => 'An ndearna tú dearmad ar do phasfhocal?';

  @override
  String get error_weakPassword => 'Tá an pasfhocal seo thar a bheith coitianta, agus ró-éasca le buille faoi thuairim.';

  @override
  String get error_namePassword => 'Ná húsáid d\'ainm úsáideora mar do phasfhocal.';

  @override
  String get blankedPassword => 'D\'úsáid tú an pasfhocal céanna ar shuíomh eile, agus tá an suíomh sin curtha i gcontúirt. Chun sábháilteacht do chuntais Lichess a chinntiú, ní mór dúinn pasfhocal nua a shocrú. Go raibh maith agat as do thuiscint.';

  @override
  String get youAreLeavingLichess => 'Tá tú ag fágáil Lichess';

  @override
  String get neverTypeYourPassword => 'Ná clóscríobh do phasfhocal Lichess ar shuíomh eile riamh!';

  @override
  String proceedToX(String param) {
    return 'Lean ar aghaidh go $param';
  }

  @override
  String get passwordSuggestion => 'Ná socraigh pasfhocal a mhol duine éigin eile. Úsáidfidh siad é chun do chuntas a ghoid.';

  @override
  String get emailSuggestion => 'Ná socraigh seoladh ríomhphoist a mhol duine éigin eile. Úsáidfidh siad é chun do chuntas a ghoid.';

  @override
  String get emailConfirmHelp => 'Cabhair le deimhniú ríomhphoist';

  @override
  String get emailConfirmNotReceived => 'Nach bhfuair tú do ríomhphost deimhnithe tar éis síniú suas?';

  @override
  String get whatSignupUsername => 'Cén t-ainm úsáideora a d\'úsáid tú chun clárú?';

  @override
  String usernameNotFound(String param) {
    return 'Níorbh fhéidir linn aon úsáideoir leis an ainm seo a aimsiú: $param.';
  }

  @override
  String get usernameCanBeUsedForNewAccount => 'Is féidir leat an t-ainm úsáideora seo a úsáid chun cuntas nua a chruthú';

  @override
  String emailSent(String param) {
    return 'Tá ríomhphost seolta againn chuig $param.';
  }

  @override
  String get emailCanTakeSomeTime => 'Féadfaidh sé roinnt ama le teacht.';

  @override
  String get refreshInboxAfterFiveMinutes => 'Fan 5 nóiméad agus athnuachan ríomhphoist.';

  @override
  String get checkSpamFolder => 'Seiceáil freisin d\'fhillteán turscair. Más ansin é marcáil nach turscar é.';

  @override
  String get emailForSignupHelp => 'Má theipeann ar gach rud eile, seol an ríomhphost seo chugainn:';

  @override
  String copyTextToEmail(String param) {
    return 'Cóipeáil agus greamaigh an téacs thuas agus seol chuig $param é';
  }

  @override
  String get waitForSignupHelp => 'Beimid ar ais chugat go luath chun cabhrú leat do chlárú a chur i gcrích.';

  @override
  String accountConfirmed(String param) {
    return 'D\'éirigh leis an úsáideoir $param a dhearbhú.';
  }

  @override
  String accountCanLogin(String param) {
    return 'Is féidir leat logáil isteach anois mar $param.';
  }

  @override
  String get accountConfirmationEmailNotNeeded => 'Ní gá duit ríomhphost deimhnithe.';

  @override
  String accountClosed(String param) {
    return 'Tá an cuntas $param dúnta.';
  }

  @override
  String accountRegisteredWithoutEmail(String param) {
    return 'Cláraíodh an cuntas $param gan ríomhphost.';
  }

  @override
  String get rank => 'Rang';

  @override
  String rankX(String param) {
    return 'Rangú: $param';
  }

  @override
  String get gamesPlayed => 'Cluichí imeartha';

  @override
  String get ok => 'OK';

  @override
  String get cancel => 'Cealaigh';

  @override
  String get whiteTimeOut => 'Am Bán istigh';

  @override
  String get blackTimeOut => 'Am Dubh istigh';

  @override
  String get drawOfferSent => 'Tairiscint comhscór seolta';

  @override
  String get drawOfferAccepted => 'Glacadh leis an tairiscint comhscór';

  @override
  String get drawOfferCanceled => 'Tairiscint comhscór curtha ar ceal';

  @override
  String get whiteOffersDraw => 'Tairgeann Bán comhscór';

  @override
  String get blackOffersDraw => 'Tairgeann Dubh comhscór';

  @override
  String get whiteDeclinesDraw => 'Diúltaíonn Bán do chomhscór';

  @override
  String get blackDeclinesDraw => 'Diúltaíonn Dubh do chomhscór';

  @override
  String get yourOpponentOffersADraw => 'Tá do chéile comhraic ag tairiscint comhscór';

  @override
  String get accept => 'Glac';

  @override
  String get decline => 'Diúltaigh';

  @override
  String get playingRightNow => 'Á imirt anois';

  @override
  String get eventInProgress => 'Á imirt anois';

  @override
  String get finished => 'Críochnaithe';

  @override
  String get abortGame => 'Éirigh as';

  @override
  String get gameAborted => 'Éiríodh as an chluiche';

  @override
  String get standard => 'Caighdeán';

  @override
  String get customPosition => 'Custom position';

  @override
  String get unlimited => 'Neamhtheoranta';

  @override
  String get mode => 'Modh';

  @override
  String get casual => 'Neamhfhoirmiúil';

  @override
  String get rated => 'Rátáilte';

  @override
  String get casualTournament => 'Neamhfhoirmiúil';

  @override
  String get ratedTournament => 'Rátáilte';

  @override
  String get thisGameIsRated => 'Is cluiche rátáilte an cluiche seo';

  @override
  String get rematch => 'Athimirt';

  @override
  String get rematchOfferSent => 'Tairiscint athimeartha seolta';

  @override
  String get rematchOfferAccepted => 'Glacadh leis an tairiscint athimeartha';

  @override
  String get rematchOfferCanceled => 'Cealaíodh an tairiscint athimeartha';

  @override
  String get rematchOfferDeclined => 'Diúltaíodh an tairiscint athimeartha';

  @override
  String get cancelRematchOffer => 'Cealaigh an tairiscint athimeartha';

  @override
  String get viewRematch => 'Féach ar an athimirt';

  @override
  String get confirmMove => 'Deimhnigh beart';

  @override
  String get play => 'Imir';

  @override
  String get inbox => 'Bosca isteach';

  @override
  String get chatRoom => 'Seomra comhrá';

  @override
  String get loginToChat => 'Sínigh isteach le teachtaireacht a sheoladh';

  @override
  String get youHaveBeenTimedOut => 'Tá tú curtha ar fionraí ar feadh tréimhse.';

  @override
  String get spectatorRoom => 'Seomra lucht féachana';

  @override
  String get composeMessage => 'Cruthaigh teachtaireacht';

  @override
  String get subject => 'Ábhar';

  @override
  String get send => 'Seol';

  @override
  String get incrementInSeconds => 'Incrimint i soicindí';

  @override
  String get freeOnlineChess => 'Ficheall Saor in Aisce Ar Líne';

  @override
  String get exportGames => 'Easpórtáil cluichí';

  @override
  String get ratingRange => 'Raon rátála';

  @override
  String get thisAccountViolatedTos => 'Sháraigh an cuntas Téarmaí Seirbhíse Lichess';

  @override
  String get openingExplorerAndTablebase => 'Ag oscailt taiscéalaí & bunachar deiridh an chluiche';

  @override
  String get takeback => 'Aisthógáil';

  @override
  String get proposeATakeback => 'Aisthógáil a mholadh';

  @override
  String get takebackPropositionSent => 'Aisthógáil seolta';

  @override
  String get takebackPropositionDeclined => 'Aisthógáil diúltaithe';

  @override
  String get takebackPropositionAccepted => 'Aisthógáil deimhnithe';

  @override
  String get takebackPropositionCanceled => 'Cuireadh an iarratas aisthógáil ar ceal';

  @override
  String get yourOpponentProposesATakeback => 'Molann do chéile comhraic aisthógáil';

  @override
  String get bookmarkThisGame => 'Cuir leabharmharc leis an chluiche seo';

  @override
  String get tournament => 'Comórtas';

  @override
  String get tournaments => 'Comórtais';

  @override
  String get tournamentPoints => 'Pointí ó chomórtais';

  @override
  String get viewTournament => 'Féach ar chomórtas';

  @override
  String get backToTournament => 'Fill ar an chomórtas';

  @override
  String get noDrawBeforeSwissLimit => 'Ní féidir cluiche cothroma a aontú sula n-imrítear 30 beart i gcomórtas Eilvéiseach.';

  @override
  String get thematic => 'Téamach';

  @override
  String yourPerfRatingIsProvisional(String param) {
    return 'Tá do rátáil $param sealadach';
  }

  @override
  String yourPerfRatingIsTooHigh(String param1, String param2) {
    return 'Tá do rátáil $param1 ($param2) ró-ard';
  }

  @override
  String yourTopWeeklyPerfRatingIsTooHigh(String param1, String param2) {
    return 'Tá do rátáil seachtainiúil $param1 is fearr ($param2) ró-ard';
  }

  @override
  String yourPerfRatingIsTooLow(String param1, String param2) {
    return 'Tá do rátáil $param1 ($param2) ró-íseal';
  }

  @override
  String ratedMoreThanInPerf(String param1, String param2) {
    return 'Rátáil ≥ $param1 i $param2';
  }

  @override
  String ratedLessThanInPerf(String param1, String param2) {
    return 'Rátáilte ≤ $param1 i $param2';
  }

  @override
  String mustBeInTeam(String param) {
    return 'Caithfear a bheith i bhfoireann $param';
  }

  @override
  String youAreNotInTeam(String param) {
    return 'Níl tú san fhoireann $param';
  }

  @override
  String get backToGame => 'Fill ar an chluiche';

  @override
  String get siteDescription => 'Freastalaí fichille saor in aisce. Imir ficheall i gcomhéadan glan. Níl aon fógraí agus ní chaithfear clárú nó plugin a úsáid. Imir ficheall leis an ríomhaire, le cairde nó céilí comhraic randamach.';

  @override
  String xJoinedTeamY(String param1, String param2) {
    return 'chuaigh $param1 isteach i bhfoireann $param2';
  }

  @override
  String xCreatedTeamY(String param1, String param2) {
    return 'Bhunaigh $param1 an fhoireann $param2';
  }

  @override
  String get startedStreaming => 'thosaigh sruthú';

  @override
  String xStartedStreaming(String param) {
    return 'Thosaigh $param ag sruthú';
  }

  @override
  String get averageElo => 'Meán rátáil';

  @override
  String get location => 'Láthair';

  @override
  String get filterGames => 'Scag cluichí';

  @override
  String get reset => 'Athshocraigh';

  @override
  String get apply => 'Deimhnigh';

  @override
  String get save => 'Sábháil';

  @override
  String get leaderboard => 'Clár ceann riain';

  @override
  String get screenshotCurrentPosition => 'Seat an suíomh reatha';

  @override
  String get gameAsGIF => 'Cluiche mar GIF';

  @override
  String get pasteTheFenStringHere => 'Greamaigh an téacs FEN anseo';

  @override
  String get pasteThePgnStringHere => 'Greamaigh an téacs PGN anseo';

  @override
  String get orUploadPgnFile => 'Nó treas a uaslódáil';

  @override
  String get fromPosition => 'Ó shuíomh';

  @override
  String get continueFromHere => 'Lean ar aghaidh ó seo';

  @override
  String get toStudy => 'Staidéar';

  @override
  String get importGame => 'Déan cluiche a iompórtáil';

  @override
  String get importGameExplanation => 'Greamaigh cluiche PGN chun athfhéachaint inbhrabhsala a fháil,\nanailís ríomhaire, comhrá cluiche agus URL inroinnte.';

  @override
  String get importGameCaveat => 'Scriosfar éagsúlachtaí. Chun iad a choinneáil, iompórtáil an PGN trí staidéar.';

  @override
  String get importGameDataPrivacyWarning => 'This PGN can be accessed by the public. To import a game privately, use a study.';

  @override
  String get thisIsAChessCaptcha => 'Is CAPCHTA fichille é seo.';

  @override
  String get clickOnTheBoardToMakeYourMove => 'Cliceáil ar an bhord le beart a dhéanamh, agus cruthaigh gur duine thú.';

  @override
  String get captcha_fail => 'Réitigh an captcha fichille, le do thoil.';

  @override
  String get notACheckmate => 'Ní marbhsháinn í sin';

  @override
  String get whiteCheckmatesInOneMove => 'Marbhsháinn ag bán le beart amháin';

  @override
  String get blackCheckmatesInOneMove => 'Marbhsháinn ag dubh le beart amháin';

  @override
  String get retry => 'Atriail';

  @override
  String get reconnecting => 'Ag athcheangal';

  @override
  String get noNetwork => 'Offline';

  @override
  String get favoriteOpponents => 'Céilí comhraic is fearr';

  @override
  String get follow => 'Lean';

  @override
  String get following => 'Ag leanúint';

  @override
  String get unfollow => 'Dílean';

  @override
  String followX(String param) {
    return 'Lean $param';
  }

  @override
  String unfollowX(String param) {
    return 'Dílean $param';
  }

  @override
  String get block => 'Blocáil';

  @override
  String get blocked => 'Blocáilte';

  @override
  String get unblock => 'Bain bac de';

  @override
  String xStartedFollowingY(String param1, String param2) {
    return 'Thosaigh $param1 ag leanúint $param2';
  }

  @override
  String get more => 'Tuilleadh';

  @override
  String get memberSince => 'Ball ó';

  @override
  String lastSeenActive(String param) {
    return 'Gníomhach $param';
  }

  @override
  String get player => 'Imreoir';

  @override
  String get list => 'Liosta';

  @override
  String get graph => 'Graf';

  @override
  String get required => 'Riachtanach.';

  @override
  String get openTournaments => 'Comórtais oscailte';

  @override
  String get duration => 'Fad';

  @override
  String get winner => 'Buaiteoir';

  @override
  String get standing => 'Stádas';

  @override
  String get createANewTournament => 'Cruthaigh comórtas nua';

  @override
  String get tournamentCalendar => 'Féilire na gcomórtas';

  @override
  String get conditionOfEntry => 'Riachtanais iontrála:';

  @override
  String get advancedSettings => 'Ardsocruithe';

  @override
  String get safeTournamentName => 'Pioc ainm an-sábháilte don chomórtas.';

  @override
  String get inappropriateNameWarning => 'D\'fhéadfadh do chuntas a dhúnadh má roghnaítear aon rud míchuí.';

  @override
  String get emptyTournamentName => 'Fág folamh chun an comórtas a ainmniú i ndiaidh imreoir fichille suntasach.';

  @override
  String get makePrivateTournament => 'Déan an comórtas príobháideach, agus cuir srian ar rochtain le pasfhocal';

  @override
  String get join => 'Cláraigh';

  @override
  String get withdraw => 'Tarraing siar';

  @override
  String get points => 'Pointí';

  @override
  String get wins => 'Buanna';

  @override
  String get losses => 'Cailliúintí';

  @override
  String get createdBy => 'Cruthaithe ag';

  @override
  String get tournamentIsStarting => 'Tá an comórtas ag tosú';

  @override
  String get tournamentPairingsAreNowClosed => 'Níl cluichí á socrú níos mó.';

  @override
  String standByX(String param) {
    return 'Bí réidh $param, ag roinnt imreoirí ina bpéirí, faigh faoi réir!';
  }

  @override
  String get pause => 'Cuir ar sos';

  @override
  String get resume => 'Atosaigh';

  @override
  String get youArePlaying => 'Tá tú ag imirt!';

  @override
  String get winRate => 'Ráta bua';

  @override
  String get berserkRate => 'Ráta Beirseirc';

  @override
  String get performance => 'Caighdeán imeartha';

  @override
  String get tournamentComplete => 'Comórtas críochnaithe';

  @override
  String get movesPlayed => 'Bearta imeartha';

  @override
  String get whiteWins => 'Buanna ag bán';

  @override
  String get blackWins => 'Buanna ag dubh';

  @override
  String get drawRate => 'Draw rate';

  @override
  String get draws => 'Comhscór';

  @override
  String nextXTournament(String param) {
    return 'An chéad chomórtas $param eile:';
  }

  @override
  String get averageOpponent => 'Gnáth-céile comhraic';

  @override
  String get boardEditor => 'Eagarthóir boird';

  @override
  String get setTheBoard => 'Socraigh an bord';

  @override
  String get popularOpenings => 'Deiseanna a bhfuil tóir orthu';

  @override
  String get endgamePositions => 'Suíomhanna deiridh an cluiche';

  @override
  String chess960StartPosition(String param) {
    return 'Suíomh tosaigh Ficheall960: $param';
  }

  @override
  String get startPosition => 'Suíomh tosaithe';

  @override
  String get clearBoard => 'Glan an bord';

  @override
  String get loadPosition => 'Lódáil suíomh';

  @override
  String get isPrivate => 'Príobháideach';

  @override
  String reportXToModerators(String param) {
    return 'Déan gearán faoi $param leis na modhnóirí';
  }

  @override
  String profileCompletion(String param) {
    return 'Comhlánú próifíle: $param';
  }

  @override
  String xRating(String param) {
    return 'rátáil $param';
  }

  @override
  String get ifNoneLeaveEmpty => 'Mura bhfuil, fág folamh';

  @override
  String get profile => 'Próifíl';

  @override
  String get editProfile => 'Cuir próifíl in eagar';

  @override
  String get realName => 'Real name';

  @override
  String get setFlair => 'Set your flair';

  @override
  String get flair => 'Flair';

  @override
  String get youCanHideFlair => 'There is a setting to hide all user flairs across the entire site.';

  @override
  String get biography => 'Beathaisnéis';

  @override
  String get countryRegion => 'Country or region';

  @override
  String get thankYou => 'Go raibh maith agat!';

  @override
  String get socialMediaLinks => 'Naisc chuig na meáin shóisialta';

  @override
  String get oneUrlPerLine => 'URL amháin an líne.';

  @override
  String get inlineNotation => 'Nodaireacht inlíne';

  @override
  String get makeAStudy => 'Ar mhaithe le slánú agus le roinnt, smaoinigh ar staidéar a dhéanamh.';

  @override
  String get clearSavedMoves => 'Glan amach bearta';

  @override
  String get previouslyOnLichessTV => 'Roimhe seo ar Lichess TV';

  @override
  String get onlinePlayers => 'Imreoirí ar líne';

  @override
  String get activePlayers => 'Imreoirí gníomhacha';

  @override
  String get bewareTheGameIsRatedButHasNoClock => 'Tabhair aire, tá an cluiche seo rátáilte ach níl clog aige!';

  @override
  String get success => 'D\'éirigh leat';

  @override
  String get automaticallyProceedToNextGameAfterMoving => 'Téigh ar aghaidh chuig an chéad cluiche eile go huathoibríoch i ndiaidh bogadh';

  @override
  String get autoSwitch => 'Athrú uathoibríoch';

  @override
  String get puzzles => 'Tomhais';

  @override
  String get onlineBots => 'Online bots';

  @override
  String get name => 'Ainm';

  @override
  String get description => 'Cur síos';

  @override
  String get descPrivate => 'Cur síos príobháideach';

  @override
  String get descPrivateHelp => 'Téacs nach bhfuil le feiceáil ach le baill. Má tá sé socraithe, cuirtear an tuairisc phoiblí in ionad do baill na foirne.';

  @override
  String get no => 'Ná lig';

  @override
  String get yes => 'Lig';

  @override
  String get website => 'Website';

  @override
  String get mobile => 'Mobile';

  @override
  String get help => 'Cabhair:';

  @override
  String get createANewTopic => 'Cruthaigh topaic nua';

  @override
  String get topics => 'Topaicí';

  @override
  String get posts => 'Postálacha';

  @override
  String get lastPost => 'Postáil is déanaí';

  @override
  String get views => 'Amhairc';

  @override
  String get replies => 'Freagraí';

  @override
  String get replyToThisTopic => 'Tabhair freagra ar an topaic seo';

  @override
  String get reply => 'Freagair';

  @override
  String get message => 'Teachtaireacht';

  @override
  String get createTheTopic => 'Cruthaigh an topaic';

  @override
  String get reportAUser => 'Déan gearán faoi úsáideoir';

  @override
  String get user => 'Úsáideoir';

  @override
  String get reason => 'Fáth';

  @override
  String get whatIsIheMatter => 'Cad atá cearr?';

  @override
  String get cheat => 'Caimiléir';

  @override
  String get troll => 'Troll';

  @override
  String get other => 'Eile';

  @override
  String get reportCheatBoostHelp => 'Paste the link to the game(s) and explain what is wrong about this user\'s behaviour. Don\'t just say \"they cheat\", but tell us how you came to this conclusion.';

  @override
  String get reportUsernameHelp => 'Explain what about this username is offensive. Don\'t just say \"it\'s offensive/inappropriate\", but tell us how you came to this conclusion, especially if the insult is obfuscated, not in english, is in slang, or is a historical/cultural reference.';

  @override
  String get reportProcessedFasterInEnglish => 'Your report will be processed faster if written in English.';

  @override
  String get error_provideOneCheatedGameLink => 'Cuir nasc ar fáil chuig cluiche amháin ar a laghad ar tharla caimiléireacht ann le do thoil.';

  @override
  String by(String param) {
    return 'ó$param';
  }

  @override
  String importedByX(String param) {
    return 'Iompórtáilte ag $param';
  }

  @override
  String get thisTopicIsNowClosed => 'Tá an topaic seo dúnta anois.';

  @override
  String get blog => 'Blag';

  @override
  String get notes => 'Nótaí';

  @override
  String get typePrivateNotesHere => 'Scríobh nótaí príobháideach anseo';

  @override
  String get writeAPrivateNoteAboutThisUser => 'Scríobh nóta príobháideach faoin úsáideoir seo';

  @override
  String get noNoteYet => 'Gan nóta fós';

  @override
  String get invalidUsernameOrPassword => 'Ainm úsáideora nó pasfhocal neamhbhailí';

  @override
  String get incorrectPassword => 'Pasfhocal mícheart';

  @override
  String get invalidAuthenticationCode => 'Cód fíordheimhnithe neamhbhailí';

  @override
  String get emailMeALink => 'Seol nasc chugam trí ríomphost';

  @override
  String get currentPassword => 'Pasfhocal reatha';

  @override
  String get newPassword => 'Pasfhocal nua';

  @override
  String get newPasswordAgain => 'Pasfhocal nua (arís)';

  @override
  String get newPasswordsDontMatch => 'Níl na pasfhocail nua ag teacht le chéile';

  @override
  String get newPasswordStrength => 'Neart an phasfhocail';

  @override
  String get clockInitialTime => 'Am tosaithe an chloig';

  @override
  String get clockIncrement => 'Am incriminte an chloig';

  @override
  String get privacy => 'Príobháideachas';

  @override
  String get privacyPolicy => 'Polasaí príobháideachais';

  @override
  String get letOtherPlayersFollowYou => 'Lig do imreoirí eile thú a leanúint';

  @override
  String get letOtherPlayersChallengeYou => 'Lig do imreoirí eile dúshláin a sheoladh chugat';

  @override
  String get letOtherPlayersInviteYouToStudy => 'Lig do imreoirí eile cuireadh a sheoladh chugat le haghaidh staidéir';

  @override
  String get sound => 'Fuaim';

  @override
  String get none => 'Faic';

  @override
  String get fast => 'Tapa';

  @override
  String get normal => 'Gnách';

  @override
  String get slow => 'Mall';

  @override
  String get insideTheBoard => 'Laistigh den chlár';

  @override
  String get outsideTheBoard => 'Lasmuigh den chlár';

  @override
  String get allSquaresOfTheBoard => 'All squares of the board';

  @override
  String get onSlowGames => 'Ar chluichí malla';

  @override
  String get always => 'I gcónaí';

  @override
  String get never => 'Choíche';

  @override
  String xCompetesInY(String param1, String param2) {
    return 'Glacann $param1 páirt i $param2';
  }

  @override
  String get victory => 'Bua';

  @override
  String get defeat => 'Cailleadh';

  @override
  String victoryVsYInZ(String param1, String param2, String param3) {
    return '$param1 in aghaidh $param2 i $param3';
  }

  @override
  String defeatVsYInZ(String param1, String param2, String param3) {
    return '$param1 in aghaidh $param2 i $param3';
  }

  @override
  String drawVsYInZ(String param1, String param2, String param3) {
    return '$param1 in aghaidh $param2 i $param3';
  }

  @override
  String get timeline => 'Amlíne';

  @override
  String get starting => 'Ag tosú:';

  @override
  String get allInformationIsPublicAndOptional => 'Tá an t-eolas ar fad roghnach agus tá sé infheicthe do chách.';

  @override
  String get biographyDescription => 'Labhair fút féin, faoi do shuimeanna, cad is maith leat i bhficheall, na hoscailtí is fearr leat, imreoirí, ...';

  @override
  String get listBlockedPlayers => 'Liostaigh imreoirí atá blocáilte agat';

  @override
  String get human => 'Duine';

  @override
  String get computer => 'Ríomhaire';

  @override
  String get side => 'Taobh';

  @override
  String get clock => 'Clog';

  @override
  String get opponent => 'Céile comhraic';

  @override
  String get learnMenu => 'Foghlaim';

  @override
  String get studyMenu => 'Staidéar';

  @override
  String get practice => 'Cleachtadh';

  @override
  String get community => 'Pobal';

  @override
  String get tools => 'Uirlisí';

  @override
  String get increment => 'Incrimint';

  @override
  String get error_unknown => 'Luach neamhbhailí';

  @override
  String get error_required => 'Tá an réimse seo riachtanach';

  @override
  String get error_email => 'Tá an seoladh ríomhphoist seo neamhbhailí';

  @override
  String get error_email_acceptable => 'Ní ghlactar leis an seoladh ríomhphoist seo. Déan é a sheiceáil faoi dhó le do thoil, agus bain triail eile as.';

  @override
  String get error_email_unique => 'Seoladh ríomhphoist neamhbhailí nó tógtha cheana féin';

  @override
  String get error_email_different => 'Seo do sheoladh ríomhphoist cheana féin';

  @override
  String error_minLength(String param) {
    return 'Is é $param an fad íosta';
  }

  @override
  String error_maxLength(String param) {
    return 'Is é $param an fad uasta';
  }

  @override
  String error_min(String param) {
    return 'Caithfidh sé a bheith níos mó nó cothrom le $param';
  }

  @override
  String error_max(String param) {
    return 'Caithfidh sé a bheith níos lú nó cothrom le $param';
  }

  @override
  String ifRatingIsPlusMinusX(String param) {
    return 'Más é ±$param an rátáil';
  }

  @override
  String get ifRegistered => 'Má chláraítear';

  @override
  String get onlyExistingConversations => 'Comhráite láithreach amháin';

  @override
  String get onlyFriends => 'Cairde amháin';

  @override
  String get menu => 'Roghchlár';

  @override
  String get castling => 'Caisleáil';

  @override
  String get whiteCastlingKingside => 'O-O Bán';

  @override
  String get blackCastlingKingside => 'O-O Dubh';

  @override
  String tpTimeSpentPlaying(String param) {
    return 'Am caite ag imirt: $param';
  }

  @override
  String get watchGames => 'Féach ar chluichí';

  @override
  String tpTimeSpentOnTV(String param) {
    return 'Am ar TV: $param';
  }

  @override
  String get watch => 'Féach';

  @override
  String get videoLibrary => 'Leabharlann físeáin';

  @override
  String get streamersMenu => 'Sruthóir';

  @override
  String get mobileApp => 'Aip Mhóibíleach';

  @override
  String get webmasters => 'Máistir gréasáin';

  @override
  String get about => 'Faoi';

  @override
  String aboutX(String param) {
    return 'Maidir le $param';
  }

  @override
  String xIsAFreeYLibreOpenSourceChessServer(String param1, String param2) {
    return 'Is freastalaí fichille oscailte saor in aisce ($param2) é $param1, gan aon fhógraí.';
  }

  @override
  String get really => 'i ndáiríre';

  @override
  String get contribute => 'Glac páirt';

  @override
  String get termsOfService => 'Téarmaí Seirbhíse';

  @override
  String get sourceCode => 'Cód Foinse';

  @override
  String get simultaneousExhibitions => 'Taispeántais comhuaineach';

  @override
  String get host => 'Óstach';

  @override
  String hostColorX(String param) {
    return 'Dath an óstaigh: $param';
  }

  @override
  String get yourPendingSimuls => 'Your pending simuls';

  @override
  String get createdSimuls => 'Cluichí comhuaineacha nua-chruthaithe';

  @override
  String get hostANewSimul => 'Óstáil cluiche comhuaineach nua';

  @override
  String get signUpToHostOrJoinASimul => 'Sign up to host or join a simul';

  @override
  String get noSimulFound => 'Ní bhfuarthas cluiche comhuaineach';

  @override
  String get noSimulExplanation => 'Níl an taispeántas comhuaineach seo ann.';

  @override
  String get returnToSimulHomepage => 'Pill ar leathanach baile na gcluichí comhuaineach';

  @override
  String get aboutSimul => 'Bíonn imreoir aonair os comhair roinnt imreoirí ag an am céanna i gcluichí comhuaineacha.';

  @override
  String get aboutSimulImage => 'As 50 céile comhraic, bhuaigh Fischer 47 cluiche, 2 chomhscór agus chaill sé 1.';

  @override
  String get aboutSimulRealLife => 'Tá an coincheap bunaithe ar eachtraí an fíorshaol. Sa fíorshaol, baineann sé seo leis an óstach comhuaineach ag bogadh ó thábla go tábla chun aon bheart amháin a dhéanamh.';

  @override
  String get aboutSimulRules => 'Nuair a thosaíonn an cluiche comhuaineach, tosaíonn gach imreoir cluiche leis an óstach, a imríonn leis na píosaí bána. Críochnaíonn an cluiche comhuaineach nuair a chríochnaíonn gach cluiche.';

  @override
  String get aboutSimulSettings => 'Bíonn cluichí comhuaineacha neamhfhoirmiúil i gconaí. Tá athimirt, aistarraing agus am breise díchumasaithe.';

  @override
  String get create => 'Cruthaigh';

  @override
  String get whenCreateSimul => 'Nuair a chruthaíonn tú cluiche comhuaineach, imríonn tú roinnt imreoirí ag an am céanna.';

  @override
  String get simulVariantsHint => 'Má roghnaíonn tú roinnt leaganacha, faigheann gach imreoir deis cluiche a roghnú.';

  @override
  String get simulClockHint => 'Suiteáil Clog Fischer. Braitheann an méid ama a theastaíonn uait ar an méid céile comhraic atá agat.';

  @override
  String get simulAddExtraTime => 'Féadfaidh tú am breise a chur le do chlog chun cabhrú leat déileáil leis an gcluiche comhuaineach.';

  @override
  String get simulHostExtraTime => 'Am breise an óstaigh';

  @override
  String get simulAddExtraTimePerPlayer => 'Cuir am tosaigh le do chlog do gach imreoir a ghlacann páirt sa chluiche comhuaineach.';

  @override
  String get simulHostExtraTimePerPlayer => 'Óstáil am breise clog do gach imreora';

  @override
  String get lichessTournaments => 'Comórtais Lichess';

  @override
  String get tournamentFAQ => 'Ceisteanna Coitianta Comórtais Airéine';

  @override
  String get timeBeforeTournamentStarts => 'Am fágtha sula dtosnaíonn an comórtas';

  @override
  String get averageCentipawnLoss => 'Meán chaillteanas ceithearnach sa lár';

  @override
  String get accuracy => 'Cruinneas';

  @override
  String get keyboardShortcuts => 'Aicearraí méarchláir';

  @override
  String get keyMoveBackwardOrForward => 'bog siar/ar aghaidh';

  @override
  String get keyGoToStartOrEnd => 'téigh chuig tús/deireadh';

  @override
  String get keyCycleSelectedVariation => 'Cycle selected variation';

  @override
  String get keyShowOrHideComments => 'taispeáin/folaigh nótaí tráchta';

  @override
  String get keyEnterOrExitVariation => 'iontráil/scor comhathrú';

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
  String get variationArrowsInfo => 'Variation arrows let you navigate without using the move list.';

  @override
  String get playSelectedMove => 'play selected move';

  @override
  String get newTournament => 'Comórtas nua';

  @override
  String get tournamentHomeTitle => 'Comórtais fichille ina bhfuil srianta ama agus comhathraithe éagsúla';

  @override
  String get tournamentHomeDescription => 'Imir comortais fichille ag luas tapaigh! Cláraigh do chomórtas oifigiúil sceidealaithe nó cruthaigh do cheann féin. Gasta (Bullet), Tapa (Blitz), Clasaiceach (Classical), Ficheall 960 (Chess960), Rí an Chnoic (King of the Hill), Sáinn faoi thrí (Threecheck), agus tuilleadh roghanna ar fáil le haghaidh spraoi fichille gan críoch.';

  @override
  String get tournamentNotFound => 'Níor aimsíodh an comórtas';

  @override
  String get tournamentDoesNotExist => 'Níl an comórtas seo ann.';

  @override
  String get tournamentMayHaveBeenCanceled => 'B\'fhéidir gur cuireadh an comórtas seo ar ceal má d\'fhág gach imreoir sular thosaigh sé.';

  @override
  String get returnToTournamentsHomepage => 'Fill ar leathanach baile na gcomórtas';

  @override
  String weeklyPerfTypeRatingDistribution(String param) {
    return 'Dáileadh $param ráta seachtainiúil';
  }

  @override
  String yourPerfTypeRatingIsRating(String param1, String param2) {
    return 'Is é do rátáil $param1 $param2.';
  }

  @override
  String youAreBetterThanPercentOfPerfTypePlayers(String param1, String param2) {
    return 'Tá tú níos fearr ná $param1 as $param2. imreoir.';
  }

  @override
  String userIsBetterThanPercentOfPerfTypePlayers(String param1, String param2, String param3) {
    return 'Tá $param1 níos fearr ná $param2 as $param3 imreoir.';
  }

  @override
  String betterThanPercentPlayers(String param1, String param2) {
    return 'Better than $param1 of $param2 players';
  }

  @override
  String youDoNotHaveAnEstablishedPerfTypeRating(String param) {
    return 'Níl rátáil $param bunaithe agat.';
  }

  @override
  String get yourRating => 'Do rátáil';

  @override
  String get cumulative => 'Carnach';

  @override
  String get glicko2Rating => 'Rátáil Glicko-2';

  @override
  String get checkYourEmail => 'Seiceáil do ríomphoist';

  @override
  String get weHaveSentYouAnEmailClickTheLink => 'Seoladh ríomhphost chugat. Cliceáil ar an nasc sa ríomhphost chun do chuntas a ghníomhachtú.';

  @override
  String get ifYouDoNotSeeTheEmailCheckOtherPlaces => 'Mura bhfeiceann tú an ríomhphost, seiceáil áiteanna eile a d’fhéadfadh sé a bheith ann, cosúil le junk, spam, sóisialta nó fillteáin eile.';

  @override
  String weHaveSentYouAnEmailTo(String param) {
    return 'Tá ríomhphost seolta againn chuig $param. Cliceáil ar an nasc sa ríomhphost chun do phasfhocal a athshocrú.';
  }

  @override
  String byRegisteringYouAgreeToBeBoundByOur(String param) {
    return 'Trí chlárú, aontaíonn tú leis na $param.';
  }

  @override
  String readAboutOur(String param) {
    return 'Léigh faoinár $param.';
  }

  @override
  String get networkLagBetweenYouAndLichess => 'Moill gréasáin idir tú féin agus Lichess';

  @override
  String get timeToProcessAMoveOnLichessServer => 'Am le beart a phróiseáil ar fhreastalaí Lichess';

  @override
  String get downloadAnnotated => 'Íoslódáil leagan anótáilte';

  @override
  String get downloadRaw => 'Ioslódáil sonraí loma';

  @override
  String get downloadImported => 'Ioslódáil sonraí iompórtáilte';

  @override
  String get crosstable => 'Trastábla';

  @override
  String get youCanAlsoScrollOverTheBoardToMoveInTheGame => 'Is féidir scrolláil thar an gclár freisin chun bogadh sa chluiche.';

  @override
  String get scrollOverComputerVariationsToPreviewThem => 'Scrollaigh thar athrúcháin ríomhaire chun réamhamharc a dhéanamh orthu.';

  @override
  String get analysisShapesHowTo => 'Brúigh shift + cliceáil nó deaschliceáil chun ciorcail agus saigheada a tharraingt ar an gclár.';

  @override
  String get letOtherPlayersMessageYou => 'Lig d\'imreoirí eile teachtaireacht a chur chugat';

  @override
  String get receiveForumNotifications => 'Faigh fógraí nuair a luaitear tú san fhóram';

  @override
  String get shareYourInsightsData => 'Roinn do thuiscint ar an fhicheall';

  @override
  String get withNobody => 'Le duine ar bith';

  @override
  String get withFriends => 'Le cairde';

  @override
  String get withEverybody => 'Le gach duine';

  @override
  String get kidMode => 'Mód páistí';

  @override
  String get kidModeIsEnabled => 'Kid mode is enabled.';

  @override
  String get kidModeExplanation => 'Baineann sé seo le sábháilteacht. I mód na bpáistí, tá gach cumarsáid múchta. Úsáid seo do pháistí agus daltaí scoile, chun iad a chosaint ó úsáideoirí idirlín eile.';

  @override
  String inKidModeTheLichessLogoGetsIconX(String param) {
    return 'I mód na bpáistí, faigheann an lógó Lichess íocón $param, ionas go mbeidh a fhios agat go bhfuil do pháistí sábháilte.';
  }

  @override
  String get askYourChessTeacherAboutLiftingKidMode => 'Tá do chuntas á bhainistiú. Iarr ar do mhúinteoir fichille faoi mhodh ardú na bpáistí.';

  @override
  String get enableKidMode => 'Cuir mód na bpáistí ar siúl';

  @override
  String get disableKidMode => 'Múch mód na bpáistí';

  @override
  String get security => 'Slándáil';

  @override
  String get sessions => 'Seisiúin';

  @override
  String get revokeAllSessions => 'cealaigh gach seisiún';

  @override
  String get playChessEverywhere => 'Imir ficheall i ngach áit';

  @override
  String get asFreeAsLichess => 'Chomh saor le Lichess';

  @override
  String get builtForTheLoveOfChessNotMoney => 'Cruthaithe mar gheall ar ghrá don fhicheall, ní d\'airgead';

  @override
  String get everybodyGetsAllFeaturesForFree => 'Faigheann gach duine gach gné saor in aisce';

  @override
  String get zeroAdvertisement => 'Gan fógraíocht';

  @override
  String get fullFeatured => 'Uirlisí iomlána le feiceáil';

  @override
  String get phoneAndTablet => 'Fón agus táibléad';

  @override
  String get bulletBlitzClassical => 'Bullet, blitz, clasaiceach';

  @override
  String get correspondenceChess => 'Ficheall chomhfhreagrais';

  @override
  String get onlineAndOfflinePlay => 'Imirt ar líne agus as líne';

  @override
  String get viewTheSolution => 'Féach ar an réiteach';

  @override
  String get followAndChallengeFriends => 'Lean agus tabhair dúshlán do chairde';

  @override
  String get noChallenges => 'No challenges.';

  @override
  String get gameAnalysis => 'Anailís cluichí';

  @override
  String xHostsY(String param1, String param2) {
    return 'Óstálann $param1 $param2';
  }

  @override
  String xJoinsY(String param1, String param2) {
    return 'tagann $param1 $param2';
  }

  @override
  String xLikesY(String param1, String param2) {
    return 'Is maith le $param1 $param2';
  }

  @override
  String get quickPairing => 'Péireáil ghasta';

  @override
  String get lobby => 'Forsheomra';

  @override
  String get anonymous => 'Anaithnid';

  @override
  String yourScore(String param) {
    return 'Do scór: $param';
  }

  @override
  String get language => 'Teanga';

  @override
  String get background => 'Cúlra';

  @override
  String get light => 'Geal';

  @override
  String get dark => 'Dorcha';

  @override
  String get transparent => 'Trédhearcach';

  @override
  String get deviceTheme => 'Téama gléas';

  @override
  String get backgroundImageUrl => 'URL íomhá chúlrá:';

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
  String get pieceSet => 'Foireann píosaí';

  @override
  String get embedInYourWebsite => 'Leabaigh i do shuíomh gréasáin';

  @override
  String get usernameAlreadyUsed => 'Tá an t-ainm úsáideora seo in úsáid cheana féin, bain triail as ceann eile.';

  @override
  String get usernamePrefixInvalid => 'Caithfidh an t-ainm úsáideora tosú le litir.';

  @override
  String get usernameSuffixInvalid => 'Caithfidh an t-ainm úsáideora críochnú le litir nó uimhir.';

  @override
  String get usernameCharsInvalid => 'Ní mór nach mbeadh ach litreacha, uimhreacha, fo-línte agus fleiscíní san ainm úsáideora. Ní cheadaítear fostríoca agus fleiscíní leanúnacha.';

  @override
  String get usernameUnacceptable => 'Níl an t-ainm úsáideora seo inghlactha.';

  @override
  String get playChessInStyle => 'Imir ficheall go stuama';

  @override
  String get chessBasics => 'Bunghnéithe fichille';

  @override
  String get coaches => 'Cóitseálaithe';

  @override
  String get invalidPgn => 'PGN neamhbhailí';

  @override
  String get invalidFen => 'FEN neamhbhailí';

  @override
  String get custom => 'Saincheaptha';

  @override
  String get notifications => 'Fógraí';

  @override
  String notificationsX(String param1) {
    return 'Notifications: $param1';
  }

  @override
  String perfRatingX(String param) {
    return 'Rátáil: $param';
  }

  @override
  String get practiceWithComputer => 'Cleachtaigh leis an ríomhaire';

  @override
  String anotherWasX(String param) {
    return 'Ceann eile ba ea $param';
  }

  @override
  String bestWasX(String param) {
    return 'Ba é $param ab fhearr';
  }

  @override
  String get youBrowsedAway => 'Bhí tú ag brabhsáil in áit éigin eile';

  @override
  String get resumePractice => 'Atosaigh cleachtadh';

  @override
  String get drawByFiftyMoves => 'Tá an cluiche cothrom leis an riail caoga beart.';

  @override
  String get theGameIsADraw => 'Cluiche cothrom.';

  @override
  String get computerThinking => 'An ríomhaire ag machnamh ...';

  @override
  String get seeBestMove => 'Féach an beart is fearr';

  @override
  String get hideBestMove => 'Folaigh an beart is fearr';

  @override
  String get getAHint => 'Faigh leid';

  @override
  String get evaluatingYourMove => 'Ag meas do bheart ...';

  @override
  String get whiteWinsGame => 'Bhuaigh bán';

  @override
  String get blackWinsGame => 'Bhuaigh dubh';

  @override
  String get learnFromYourMistakes => 'Foghlaim ó do chuid botúin';

  @override
  String get learnFromThisMistake => 'Foghlaim ón mbotún seo';

  @override
  String get skipThisMove => 'Ná bac leis an mbeart seo';

  @override
  String get next => 'Ar aghaidh';

  @override
  String xWasPlayed(String param) {
    return 'Imríodh $param';
  }

  @override
  String get findBetterMoveForWhite => 'Faigh beart níos fearr do bán';

  @override
  String get findBetterMoveForBlack => 'Faigh beart níos fearr do dubh';

  @override
  String get resumeLearning => 'Atosaigh an fhoghlaim';

  @override
  String get youCanDoBetter => 'Tá beart níos fearr ann';

  @override
  String get tryAnotherMoveForWhite => 'Triail beart bán eile';

  @override
  String get tryAnotherMoveForBlack => 'Triail beart dubh eile';

  @override
  String get solution => 'Réiteach';

  @override
  String get waitingForAnalysis => 'Ag fanacht ar anailís';

  @override
  String get noMistakesFoundForWhite => 'Ní bhfuarthas aon bhotúin ó bán';

  @override
  String get noMistakesFoundForBlack => 'Ní bhfuarthas aon bhotúin ó dubh';

  @override
  String get doneReviewingWhiteMistakes => 'Déanta ag athbhreithniú botúin bhána';

  @override
  String get doneReviewingBlackMistakes => 'Déanta ag athbhreithniú botúin dhubh';

  @override
  String get doItAgain => 'Déan arís é';

  @override
  String get reviewWhiteMistakes => 'Athbhreithnigh botúin bhána';

  @override
  String get reviewBlackMistakes => 'Athbhreithnigh botúin dhubha';

  @override
  String get advantage => 'Buntáiste';

  @override
  String get opening => 'Oscailt';

  @override
  String get middlegame => 'Lár an chluiche';

  @override
  String get endgame => 'Cor deiridh';

  @override
  String get conditionalPremoves => 'Réamhbhearta coinníollacha';

  @override
  String get addCurrentVariation => 'Cuir athrúchán reatha leis';

  @override
  String get playVariationToCreateConditionalPremoves => 'Imir athrúchán chun réamhbheart coinníollach a chruthú';

  @override
  String get noConditionalPremoves => 'Gan aon réamhbhearta coinníollacha';

  @override
  String playX(String param) {
    return 'Imir $param';
  }

  @override
  String get showUnreadLichessMessage => 'You have received a private message from Lichess.';

  @override
  String get clickHereToReadIt => 'Click here to read it';

  @override
  String get sorry => 'Tá brón orainn :(';

  @override
  String get weHadToTimeYouOutForAWhile => 'Bhí orainn tú a chur ar fionraí ar feadh tréimhse.';

  @override
  String get why => 'Cén fáth?';

  @override
  String get pleasantChessExperience => 'Ba mhaith linn atmaisféar maith fichille a chur ar fáil do chách.';

  @override
  String get goodPractice => 'De bhrí sin, ní mór dúinn a chinntiú go leanann gach ficheallaí dea-chleachtas.';

  @override
  String get potentialProblem => 'Nuair a aimsítear fadhb fhéideartha, taispeánann muid an teachtaireacht seo.';

  @override
  String get howToAvoidThis => 'Conas seo a sheachaint?';

  @override
  String get playEveryGame => 'Imir gach cluiche a chuireann tú tús leis.';

  @override
  String get tryToWin => 'Déan iarracht gach cluiche a imríonn tú a bhuachaint (nó comhscór a fháil ar a laghad).';

  @override
  String get resignLostGames => 'Éirigh as cluichí caillte (ná lig don clog rith amach).';

  @override
  String get temporaryInconvenience => 'Gabhaimid leithscéal as an míchaoithiúlacht shealadach,';

  @override
  String get wishYouGreatGames => 'agus guímid cluichí iontacha ort ar lichess.org.';

  @override
  String get thankYouForReading => 'Go raibh maith agat as léamh!';

  @override
  String get lifetimeScore => 'Scór saoil';

  @override
  String get currentMatchScore => 'Scór reatha an chluiche';

  @override
  String get agreementAssistance => 'Aontaím nach nglacfaidh mé le cabhair ar bith i rith mo chluichí (ó ríomhaire fichille, ó leabhar, ó bhunachar sonraí nó ó dhuine eile).';

  @override
  String get agreementNice => 'Aontaím go mbeidh meas agam i gcónaí ar fhicheallaithe eile.';

  @override
  String agreementMultipleAccounts(String param) {
    return 'Aontaím nach gcruthóidh mé cuntais iolracha (ach amháin ar na cúiseanna atá luaite sa $param).';
  }

  @override
  String get agreementPolicy => 'Aontaím go leanfaidh mé gach polasaí Lichess.';

  @override
  String get searchOrStartNewDiscussion => 'Cuardaigh nó cuir tús le comhrá nua';

  @override
  String get edit => 'Athraigh';

  @override
  String get bullet => 'Bullet';

  @override
  String get blitz => 'Blitz';

  @override
  String get rapid => 'Mear';

  @override
  String get classical => 'Clasaiceach';

  @override
  String get ultraBulletDesc => 'Cluichí ríghasta; níos lú ná 30 soicind';

  @override
  String get bulletDesc => 'Cluichí an-ghasta: níos lú ná 3 nóiméad';

  @override
  String get blitzDesc => 'Cluichí gasta: 3 go 8 nóiméad';

  @override
  String get rapidDesc => 'Cluichí meara: 8 go 25 nóiméad';

  @override
  String get classicalDesc => 'Cluichí clasaiceacha: 25 nóiméad agus níos mó';

  @override
  String get correspondenceDesc => 'Cluichí comhfhreagrais: lá nó dhó an bhirt';

  @override
  String get puzzleDesc => 'Traenálaí beartaíocht fichille';

  @override
  String get important => 'Tábhachtach';

  @override
  String yourQuestionMayHaveBeenAnswered(String param1) {
    return 'Seans go bhfuil freagra do cheist ann cheana féin $param1';
  }

  @override
  String get inTheFAQ => 'sna CCana';

  @override
  String toReportSomeoneForCheatingOrBadBehavior(String param1) {
    return 'Chun gearán a dhéanmah faoi úsáideoir maidir le caimiléireacht nó drochiompar, $param1';
  }

  @override
  String get useTheReportForm => 'bain úsáid as an bhfoirm thuairisce';

  @override
  String toRequestSupport(String param1) {
    return 'Chun tacaíocht a iarraidh, $param1';
  }

  @override
  String get tryTheContactPage => 'triail an leathanach teagmhála';

  @override
  String makeSureToRead(String param1) {
    return 'Bí cinnte $param1 a léamh';
  }

  @override
  String get theForumEtiquette => 'rialacha iompair an fhóraim';

  @override
  String get thisTopicIsArchived => 'Cuireadh an t-ábhar seo i gcartlann agus ní féidir freagra a thabhairt air a thuilleadh.';

  @override
  String joinTheTeamXToPost(String param1) {
    return 'Comhcheangail an $param1, le postáil san fhóram seo';
  }

  @override
  String teamNamedX(String param1) {
    return 'Foireann $param1';
  }

  @override
  String get youCannotPostYetPlaySomeGames => 'Níl cead postáil sna fóraim go fóill. Imir roinnt cluichí!';

  @override
  String get subscribe => 'Liostáil';

  @override
  String get unsubscribe => 'Díliostáil';

  @override
  String mentionedYouInX(String param1) {
    return 'luadh tú i \"$param1\".';
  }

  @override
  String xMentionedYouInY(String param1, String param2) {
    return 'luadh $param1 tú i \"$param2\".';
  }

  @override
  String invitedYouToX(String param1) {
    return 'tugadh cuireadh duit \"$param1\".';
  }

  @override
  String xInvitedYouToY(String param1, String param2) {
    return 'tugadh $param1 cuireadh duit \"$param2\".';
  }

  @override
  String get youAreNowPartOfTeam => 'Tá tú anois mar chuid den fhoireann.';

  @override
  String youHaveJoinedTeamX(String param1) {
    return 'Tá tú tar éis dul isteach \"$param1\".';
  }

  @override
  String get someoneYouReportedWasBanned => 'Cuireadh cosc ar dhuine a thuairiscigh tú';

  @override
  String get congratsYouWon => 'Comhghairdeas, bhuaigh tú!';

  @override
  String gameVsX(String param1) {
    return 'Cluiche in aghaidh $param1';
  }

  @override
  String resVsX(String param1, String param2) {
    return '$param1 in aghaidh $param2';
  }

  @override
  String get lostAgainstTOSViolator => 'Chaill tú i gcoinne duine a sháraigh téarmaí seirbhíse Lichess';

  @override
  String refundXpointsTimeControlY(String param1, String param2) {
    return 'Athchistiú: $param1 $param2 pointí rátála.';
  }

  @override
  String get timeAlmostUp => 'Tá an t-am beagnach suas!';

  @override
  String get clickToRevealEmailAddress => '[Cliceáil chun seoladh ríomhphoist a nochtadh]';

  @override
  String get download => 'Íoslódáil';

  @override
  String get coachManager => 'Socruithe cóitseál a bhainistiú';

  @override
  String get streamerManager => 'Socruithe sruthanna a bhainistiú';

  @override
  String get cancelTournament => 'Cuir an comórtas ar ceal';

  @override
  String get tournDescription => 'Cur síos ar an gcomórtas';

  @override
  String get tournDescriptionHelp => 'Rud ar bith speisialta ba mhaith leat a rá leis na rannpháirtithe? Déan iarracht é a choinneáil gearr. Tá naisc Markdown ar fáil: [name](https://url)';

  @override
  String get ratedFormHelp => 'Déantar cluichí a rátáil\nagus rátálacha imreoirí tionchair';

  @override
  String get onlyMembersOfTeam => 'Baill foirne amháin';

  @override
  String get noRestriction => 'Gan aon srian';

  @override
  String get minimumRatedGames => 'Cluichí rátáilte íosta';

  @override
  String get minimumRating => 'Rátáil íosta';

  @override
  String get maximumWeeklyRating => 'Uasráta seachtainiúil';

  @override
  String positionInputHelp(String param) {
    return 'Greamaigh FEN bailí chun gach cluiche a thosú ó áit ar leith.\nNí oibríonn sé ach le haghaidh cluichí caighdeánacha, ní le leaganacha.\nIs féidir leat an $param a úsáid chun suíomh FEN a ghiniúint, ansin é a ghreamú anseo.\nFág folamh chun cluichí a thosú ón ngnáthshuíomh tosaigh.';
  }

  @override
  String get cancelSimul => 'Cuir an taispeántas comhuaineach ar ceal';

  @override
  String get simulHostcolor => 'Dath óstach do gach cluiche';

  @override
  String get estimatedStart => 'Am tosaithe measta';

  @override
  String simulFeatured(String param) {
    return 'Gné ar $param';
  }

  @override
  String simulFeaturedHelp(String param) {
    return 'Taispeáin do thaispeántas comhuaineach do gach duine ar $param. Díchumasaithe do thaispeántais chomhuaineacha phríobháideacha.';
  }

  @override
  String get simulDescription => 'Tuairisc ar thaispeántas comhuaineach';

  @override
  String get simulDescriptionHelp => 'Rud ar bith is mian leat a rá leis na rannpháirtithe?';

  @override
  String markdownAvailable(String param) {
    return 'Tá $param ar fáil le haghaidh comhréir níos airde.';
  }

  @override
  String get embedsAvailable => 'Greamaigh URL cluiche nó URL caibidil staidéir chun é a leabú.';

  @override
  String get inYourLocalTimezone => 'I do chrios ama áitiúil féin';

  @override
  String get tournChat => 'Comhrá comórtais';

  @override
  String get noChat => 'Cosc ar comhrá';

  @override
  String get onlyTeamLeaders => 'Ceannairí foirne amháin';

  @override
  String get onlyTeamMembers => 'Baill foirne amháin';

  @override
  String get navigateMoveTree => 'Déan nascleanúint ar an gcrann birt';

  @override
  String get mouseTricks => 'Cleasanna luiche';

  @override
  String get toggleLocalAnalysis => 'Scoránú anailís áitiúil ar ríomhaire';

  @override
  String get toggleAllAnalysis => 'Scoránú gach anailís ríomhaire';

  @override
  String get playComputerMove => 'Déan an beart ríomhaire is fearr';

  @override
  String get analysisOptions => 'Roghanna anailíse';

  @override
  String get focusChat => 'Comhrá spriocghrúpa';

  @override
  String get showHelpDialog => 'Taispeáin an dialóg cabhrach seo';

  @override
  String get reopenYourAccount => 'Athoscailt do chuntas';

  @override
  String get reopenYourAccountDescription => 'If you closed your account, but have since changed your mind, you get a chance of getting your account back.';

  @override
  String get emailAssociatedToaccount => 'Seoladh ríomhphoist a bhaineann leis an gcuntas';

  @override
  String get sentEmailWithLink => 'Tá ríomhphost seolta againn le nasc.';

  @override
  String get tournamentEntryCode => 'Cód iontrála an chomórtais';

  @override
  String get hangOn => 'Fan!';

  @override
  String gameInProgress(String param) {
    return 'Tá cluiche idir lámha agat le $param.';
  }

  @override
  String get abortTheGame => 'Giorraigh an cluiche';

  @override
  String get resignTheGame => 'Éirigh as';

  @override
  String get youCantStartNewGame => 'Ní féidir leat cluiche nua a thosú go dtí go mbeidh an ceann seo críochnaithe.';

  @override
  String get since => 'Ó';

  @override
  String get until => 'Go dtí';

  @override
  String get lichessDbExplanation => 'Cluichí rátáilte a sampláladh ó gach imreoir Lichess';

  @override
  String get switchSides => 'Athraigh taobhanna';

  @override
  String get closingAccountWithdrawAppeal => 'Má dhúnann tú do chuntas tarraingeofar siar d’achomharc';

  @override
  String get ourEventTips => 'Ár leideanna chun imeachtaí a eagrú';

  @override
  String get instructions => 'Instructions';

  @override
  String get showMeEverything => 'Show me everything';

  @override
  String get lichessPatronInfo => 'Is carthanas é Lichess, agus agus bogearraí foinse oscailte go hiomlán saor in aisce.\nMaoinítear na costais oibriúcháin, na forbartha agus an t-ábhar go léir trí thabhartais úsáideora amháin.';

  @override
  String get nothingToSeeHere => 'Nothing to see here at the moment.';

  @override
  String get stats => 'Stats';

  @override
  String opponentLeftCounter(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'D’fhág do chéile comhraic an cluiche. Féadfaidh tú an bua a fháil i $count soicind.',
      many: 'D’fhág do chéile comhraic an cluiche. Féadfaidh tú an bua a fháil i $count soicind.',
      few: 'D’fhág do chéile comhraic an cluiche. Féadfaidh tú an bua a fháil i $count shoicind.',
      two: 'D’fhág do chéile comhraic an cluiche. Féadfaidh tú an bua a fháil i $count shoicind.',
      one: 'D’fhág do chéile comhraic an cluiche. Féadfaidh tú an bua a fháil éileamh i $count soicind.',
    );
    return '$_temp0';
  }

  @override
  String mateInXHalfMoves(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Marbhsháinn i $count leath-bheart',
      many: 'Marbhsháinn i $count leath-bheart',
      few: 'Marbhsháinn i $count leath-bheart',
      two: 'Marbhsháinn i $count leath-bheart',
      one: 'Marbhsháinn i $count leath-bheart',
    );
    return '$_temp0';
  }

  @override
  String nbBlunders(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count botún',
      many: '$count botún',
      few: '$count mbotún',
      two: '$count bhotún',
      one: '$count botún',
    );
    return '$_temp0';
  }

  @override
  String numberBlunders(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Botún',
      many: '$count Botún',
      few: '$count Mbotún',
      two: '$count Bhotún',
      one: '$count Botún',
    );
    return '$_temp0';
  }

  @override
  String nbMistakes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count botún',
      many: '$count botún',
      few: '$count mbotún',
      two: '$count bhotún',
      one: '$count botún',
    );
    return '$_temp0';
  }

  @override
  String numberMistakes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Botún',
      many: '$count Botún',
      few: '$count Mbotún',
      two: '$count Bhotún',
      one: '$count Botún',
    );
    return '$_temp0';
  }

  @override
  String nbInaccuracies(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count míchruinneas',
      many: '$count míchruinneas',
      few: '$count míchruinneas',
      two: '$count mhíchruinneas',
      one: '$count míchruinneas',
    );
    return '$_temp0';
  }

  @override
  String numberInaccuracies(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Míchruinneas',
      many: '$count Míchruinneas',
      few: '$count Míchruinneas',
      two: '$count Mhíchruinneas',
      one: '$count Míchruinneas',
    );
    return '$_temp0';
  }

  @override
  String nbPlayers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count imreoir',
      many: '$count imreoir',
      few: '$count imreoir',
      two: '$count imreoir',
      one: '$count imreoir',
    );
    return '$_temp0';
  }

  @override
  String nbGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count cluiche',
      many: '$count cluichí',
      few: '$count cluiche',
      two: '$count chluiche',
      one: '$count cluiche',
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
      other: '$count leabharmharc',
      many: '$count leabharmharcanna',
      few: '$count leabharmharc',
      two: '$count leabharmharc',
      one: '$count leabharmharc',
    );
    return '$_temp0';
  }

  @override
  String nbDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count laethanta',
      many: '$count lá',
      few: '$count lá',
      two: '$count lá',
      one: 'Lá amháin',
    );
    return '$_temp0';
  }

  @override
  String nbHours(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count uair',
      many: '$count uair',
      few: '$count uair',
      two: '$count uair',
      one: '$count uair',
    );
    return '$_temp0';
  }

  @override
  String nbMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count nóiméad',
      many: '$count nóiméad',
      few: '$count nóiméad',
      two: '$count nóiméad',
      one: '$count nóiméad',
    );
    return '$_temp0';
  }

  @override
  String rankIsUpdatedEveryNbMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Uasdátaítear rangú gach $count nóimead',
      many: 'Uasdátaítear rangú gach $count nóimead',
      few: 'Uasdátaítear rangú gach $count nóimead',
      two: 'Uasdátaítear rangú gach $count nóimead',
      one: 'Uasdátaítear rangú gach $count nóimead',
    );
    return '$_temp0';
  }

  @override
  String nbPuzzles(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count fadhb',
      many: '$count fadhbanna',
      few: '$count fhadhb',
      two: '$count fhadhb',
      one: '$count fadhb',
    );
    return '$_temp0';
  }

  @override
  String nbGamesWithYou(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count cluiche leat',
      many: '$count cluiche leat',
      few: '$count gcluiche leat',
      two: '$count chluiche leat',
      one: '$count cluiche leat',
    );
    return '$_temp0';
  }

  @override
  String nbRated(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count chluichí rátáilte',
      many: '$count chluichí rátáilte',
      few: '$count chluichí rátáilte',
      two: '$count chluiche rátáilte',
      one: '$count cluiche rátáilte',
    );
    return '$_temp0';
  }

  @override
  String nbWins(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count bua',
      many: '$count bua',
      few: '$count mbua',
      two: '$count bhua',
      one: '$count bua',
    );
    return '$_temp0';
  }

  @override
  String nbLosses(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count caill',
      many: '$count caill',
      few: '$count chaill',
      two: '$count chaill',
      one: '$count caill',
    );
    return '$_temp0';
  }

  @override
  String nbDraws(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count comhscór',
      many: '$count comhscór',
      few: '$count gcomhscór',
      two: '$count chomhscór',
      one: '$count comhscór',
    );
    return '$_temp0';
  }

  @override
  String nbPlaying(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count á imirt',
      many: '$count á imirt',
      few: '$count á imirt',
      two: '$count á imirt',
      one: '$count á imirt',
    );
    return '$_temp0';
  }

  @override
  String giveNbSeconds(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Tabhair $count shoicind',
      many: 'Tabhair $count shoicind',
      few: 'Tabhair $count shoicind',
      two: 'Tabhair $count shoicind',
      one: 'Tabhair $count soicind',
    );
    return '$_temp0';
  }

  @override
  String nbTournamentPoints(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count pointí comórtais',
      many: '$count pointe comórtais',
      few: '$count bpointe comórtais',
      two: '$count phointe comórtais',
      one: '$count pointe comórtais',
    );
    return '$_temp0';
  }

  @override
  String nbStudies(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count staidéir',
      many: '$count staidéir',
      few: '$count staidéir',
      two: '$count staidéir',
      one: '$count staidéar',
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
      other: '≥ $count cluichí rátáilte',
      many: '≥ $count cluichí rátáilte',
      few: '≥ $count cluichí rátáilte',
      two: '≥ $count cluichí rátáilte',
      one: '≥ $count cluiche rátáilte',
    );
    return '$_temp0';
  }

  @override
  String moreThanNbPerfRatedGames(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '≥ $count cluichí rátáilte $param2',
      many: '≥ $count cluichí rátáilte $param2',
      few: '≥ $count cluichí rátáilte $param2',
      two: '≥ $count cluichí rátáilte $param2',
      one: '≥ $count cluiche rátáilte $param2',
    );
    return '$_temp0';
  }

  @override
  String needNbMorePerfGames(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Caithfidh tú $count cluichí rátáilte $param2 níos mó a imirt',
      many: 'Caithfidh tú $count gcluiche rátáilte \"$param2\" eile a imirt',
      few: 'Caithfidh tú $count gcluiche rátáilte \"$param2\" eile a imirt',
      two: 'Caithfidh tú $count chluiche rátáilte \"$param2\" eile a imirt',
      one: 'Caithfidh tú $count cluiche rátáilte \"$param2\" eile a imirt',
    );
    return '$_temp0';
  }

  @override
  String needNbMoreGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Caithfidh tú $count cluichí rátáilte eile a imirt',
      many: 'Caithfidh tú $count cluiche rátáilte eile a imirt',
      few: 'Caithfidh tú $count gcluiche rátáilte eile a imirt',
      two: 'Caithfidh tú $count chluiche rátáilte eile a imirt',
      one: 'Caithfidh tú $count cluiche rátáilte eile a imirt',
    );
    return '$_temp0';
  }

  @override
  String nbImportedGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count cluichí iompórtáilte',
      many: '$count cluiche iompórtáilte',
      few: '$count gcluiche iompórtáilte',
      two: '$count chluiche iompórtáilte',
      one: '$count cluiche iompórtáilte',
    );
    return '$_temp0';
  }

  @override
  String nbFriendsOnline(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count cairde ar líne',
      many: '$count cairde ar líne',
      few: '$count cairde ar líne',
      two: '$count chara ar líne',
      one: 'cara amháin ar líne',
    );
    return '$_temp0';
  }

  @override
  String nbFollowers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count leantóirí',
      many: '$count leantóirí',
      few: '$count leantóir',
      two: 'beirt leantóir',
      one: 'leantóir amháin',
    );
    return '$_temp0';
  }

  @override
  String nbFollowing(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ag leanúint',
      many: '$count ag leanúint',
      few: '$count ag leanúint',
      two: 'beirt ag leanúint',
      one: 'duine amháin ag leanúint',
    );
    return '$_temp0';
  }

  @override
  String lessThanNbMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Níos lú ná $count nóiméid',
      many: 'Níos lú ná $count nóiméad',
      few: 'Níos lú ná $count nóiméad',
      two: 'Níos lú ná $count nóiméad',
      one: 'Níos lú ná nóiméad amháin',
    );
    return '$_temp0';
  }

  @override
  String nbGamesInPlay(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count cluichí san imirt',
      many: '$count cluiche san imirt',
      few: '$count gcluiche san imirt',
      two: '$count chluiche san imirt',
      one: '$count cluiche san imirt',
    );
    return '$_temp0';
  }

  @override
  String maximumNbCharacters(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Uasmhéid $count carachtair.',
      many: 'Uasmhéid $count carachtar.',
      few: 'Uasmhéid $count gcarachtar.',
      two: 'Uasmhéid $count charachtar.',
      one: 'Uasmhéid $count carachtar.',
    );
    return '$_temp0';
  }

  @override
  String blocks(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count bloic',
      many: '$count bloic',
      few: '$count bloic',
      two: '$count bhloc',
      one: 'bloc amháin',
    );
    return '$_temp0';
  }

  @override
  String nbForumPosts(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'poist fóraim $count',
      many: 'poist fóraim $count',
      few: 'poist fóraim $count',
      two: 'post fóraim $count',
      one: 'post fóraim amháin',
    );
    return '$_temp0';
  }

  @override
  String nbPerfTypePlayersThisWeek(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count $param2 imreoirí an tseachtain seo.',
      many: '$count $param2 imreoirí an tseachtain seo.',
      few: '$count $param2 imreoir an tseachtain seo.',
      two: '$count $param2 imreoir an tseachtain seo.',
      one: '$count $param2 imreoir an tseachtain seo.',
    );
    return '$_temp0';
  }

  @override
  String availableInNbLanguages(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Ar fáil i $count teangacha!',
      many: 'Ar fáil i $count teanga!',
      few: 'Ar fáil i $count dteanga!',
      two: 'Ar fáil i $count theanga!',
      one: 'Ar fáil i $count teanga!',
    );
    return '$_temp0';
  }

  @override
  String nbSecondsToPlayTheFirstMove(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count soicindí chun an chéad bheart a imirt',
      many: '$count soicind chun an chéad bheart a imirt',
      few: '$count soicind chun an chéad bheart a imirt',
      two: '$count soicind chun an chéad bheart a imirt',
      one: '$count soicind chun an chéad bheart a imirt',
    );
    return '$_temp0';
  }

  @override
  String nbSeconds(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count soicind',
      many: '$count soicind',
      few: '$count soicind',
      two: '$count shoicind',
      one: '$count soicind',
    );
    return '$_temp0';
  }

  @override
  String andSaveNbPremoveLines(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'agus sábháil $count líne réamhbhirt',
      many: 'agus sábháil $count líne réamhbhirt',
      few: 'agus sábháil $count líne réamhbhirt',
      two: 'agus sábháil $count líne réamhbhirt',
      one: 'agus sábháil $count líne réamhbhirt',
    );
    return '$_temp0';
  }

  @override
  String get stormMoveToStart => 'Bog le tosú';

  @override
  String get stormYouPlayTheWhitePiecesInAllPuzzles => 'Imir leis na píosaí bána i ngach fadhb';

  @override
  String get stormYouPlayTheBlackPiecesInAllPuzzles => 'Imir leis na píosaí dubha i ngach fadhb';

  @override
  String get stormPuzzlesSolved => 'fadhbhanna déanta';

  @override
  String get stormNewDailyHighscore => 'Ardscór laethúil nua!';

  @override
  String get stormNewWeeklyHighscore => 'Ardscór seachtainiúil nua!';

  @override
  String get stormNewMonthlyHighscore => 'Ardscór míosa nua!';

  @override
  String get stormNewAllTimeHighscore => 'Ardscór nua an tsaoil!';

  @override
  String stormPreviousHighscoreWasX(String param) {
    return 'Ba é $param an ardscór roimhe seo';
  }

  @override
  String get stormPlayAgain => 'Imir arís';

  @override
  String stormHighscoreX(String param) {
    return 'Ardscór: $param';
  }

  @override
  String get stormScore => 'Scór';

  @override
  String get stormMoves => 'Bearta';

  @override
  String get stormAccuracy => 'Cruinneas';

  @override
  String get stormCombo => 'Sraithbhuille';

  @override
  String get stormTime => 'Am';

  @override
  String get stormTimePerMove => 'Am an bheart';

  @override
  String get stormHighestSolved => 'Réitithe is airde';

  @override
  String get stormPuzzlesPlayed => 'Fadhbhanna imeartha';

  @override
  String get stormNewRun => 'Stríocáin nua (eochair aicearra: Spás)';

  @override
  String get stormEndRun => 'Stríocáin deireadh (eochair aicearra: Iontráil)';

  @override
  String get stormHighscores => 'Ardscóir';

  @override
  String get stormViewBestRuns => 'Féach ar stríocáin is fearr';

  @override
  String get stormBestRunOfDay => 'An stríocán is fearr sa lá';

  @override
  String get stormRuns => 'Stríocáin';

  @override
  String get stormGetReady => 'Déan réidh!';

  @override
  String get stormWaitingForMorePlayers => 'Ag fanacht le níos mó imreoirí a bheith páirteach...';

  @override
  String get stormRaceComplete => 'Léibhéal críochnaithe!';

  @override
  String get stormSpectating => 'Ag breathnú';

  @override
  String get stormJoinTheRace => 'Bí sa rás!';

  @override
  String get stormStartTheRace => 'Tosaigh an rás';

  @override
  String stormYourRankX(String param) {
    return 'Do rang: $param';
  }

  @override
  String get stormWaitForRematch => 'Fan ar athchluiche';

  @override
  String get stormNextRace => 'Chéad rás eile';

  @override
  String get stormJoinRematch => 'Téigh isteach i athchluiche';

  @override
  String get stormWaitingToStart => 'Ag fanacht le tosú';

  @override
  String get stormCreateNewGame => 'Cruthaigh cluiche nua';

  @override
  String get stormJoinPublicRace => 'Glac páirt i rás poiblí';

  @override
  String get stormRaceYourFriends => 'Rás in aghaidh do chairde';

  @override
  String get stormSkip => 'scipeáil';

  @override
  String get stormSkipHelp => 'Tá cead beart amháin a scipeáil in aon rás amháin:';

  @override
  String get stormSkipExplanation => 'Scipeáil an beart seo chun do sraithbhuille a chaomhnú! Ní oibríonn sé ach uair amháin in aon rás amháin.';

  @override
  String get stormFailedPuzzles => 'Fadhbanna theip';

  @override
  String get stormSlowPuzzles => 'Fadhbanna mall';

  @override
  String get stormSkippedPuzzle => 'Fadhb scipeáilte';

  @override
  String get stormThisWeek => 'An tseachtain seo';

  @override
  String get stormThisMonth => 'An mhí seo';

  @override
  String get stormAllTime => 'Riamh';

  @override
  String get stormClickToReload => 'Cliceáil chun athlódáil';

  @override
  String get stormThisRunHasExpired => 'Tá an rith seo imithe as feidhm!';

  @override
  String get stormThisRunWasOpenedInAnotherTab => 'Osclaíodh an rith seo i dtáb eile!';

  @override
  String stormXRuns(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count stríocáin',
      many: '$count stríocáin',
      few: '$count stríocáin',
      two: '$count stríocáin',
      one: '1 stríocáin',
    );
    return '$_temp0';
  }

  @override
  String stormPlayedNbRunsOfPuzzleStorm(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'D\'imir $count stríocáin de $param2',
      many: 'D\'imir $count stríocáin de $param2',
      few: 'D\'imir $count stríocáin de $param2',
      two: 'D\'imir $count stríocáin de $param2',
      one: 'D\'imir stríocáin amháin de $param2',
    );
    return '$_temp0';
  }

  @override
  String get streamerLichessStreamers => 'Sruthaithe Lichess';

  @override
  String get studyPrivate => 'Cé na daoine! Tá an leathanach seo príobháideach, ní féidir leat é a rochtain';

  @override
  String get studyMyStudies => 'Mo chuid staidéir';

  @override
  String get studyStudiesIContributeTo => 'Staidéir atá á n-iarraidh agam';

  @override
  String get studyMyPublicStudies => 'Mo chuid staidéir phoiblí';

  @override
  String get studyMyPrivateStudies => 'Mo chuid staidéir phríobháideacha';

  @override
  String get studyMyFavoriteStudies => 'Na staidéir is fearr liom';

  @override
  String get studyWhatAreStudies => 'Cad is staidéir ann?';

  @override
  String get studyAllStudies => 'Gach staidéar';

  @override
  String studyStudiesCreatedByX(String param) {
    return 'Staidéir a chruthaigh $param';
  }

  @override
  String get studyNoneYet => 'Níl aon cheann fós.';

  @override
  String get studyHot => 'Te';

  @override
  String get studyDateAddedNewest => 'Dáta curtha leis (dáta is déanaí)';

  @override
  String get studyDateAddedOldest => 'Dáta curtha leis (dáta is sinne)';

  @override
  String get studyRecentlyUpdated => 'Faisnéis nuashonraithe le déanaí';

  @override
  String get studyMostPopular => 'Móréilimh';

  @override
  String get studyAlphabetical => 'Aibítre';

  @override
  String get studyAddNewChapter => 'Cuir caibidil nua leis';

  @override
  String get studyAddMembers => 'Cuir baill leis';

  @override
  String get studyInviteToTheStudy => 'Tabhair cuireadh don staidéar';

  @override
  String get studyPleaseOnlyInvitePeopleYouKnow => 'Ná tabhair cuireadh ach do dhaoine a bhfuil aithne agat orthu, agus ar mian leo go gníomhach a bheith páirteach sa staidéar seo.';

  @override
  String get studySearchByUsername => 'Cuardaigh de réir ainm úsáideora';

  @override
  String get studySpectator => 'Breathnóir';

  @override
  String get studyContributor => 'Rannpháirtí';

  @override
  String get studyKick => 'Ciceáil';

  @override
  String get studyLeaveTheStudy => 'Fág an staidéar';

  @override
  String get studyYouAreNowAContributor => 'Is ranníocóir anois tú';

  @override
  String get studyYouAreNowASpectator => 'Is lucht féachana anois tú';

  @override
  String get studyPgnTags => 'Clibeanna PGN';

  @override
  String get studyLike => 'Is maith liom';

  @override
  String get studyUnlike => 'Díthogh';

  @override
  String get studyNewTag => 'Clib nua';

  @override
  String get studyCommentThisPosition => 'Déan trácht ar an suíomh seo';

  @override
  String get studyCommentThisMove => 'Déan trácht ar an mbeart seo';

  @override
  String get studyAnnotateWithGlyphs => 'Nodaireacht le glifeanna';

  @override
  String get studyTheChapterIsTooShortToBeAnalysed => 'Tá an chaibidil ró-ghearr le hanailís a dhéanamh uirthi.';

  @override
  String get studyOnlyContributorsCanRequestAnalysis => 'Ní féidir ach le rannpháirtithe an staidéir anailís ríomhaire a iarraidh.';

  @override
  String get studyGetAFullComputerAnalysis => 'Faigh anailís ríomhaire iomlán ón freastalaí ar an bpríomhlíne.';

  @override
  String get studyMakeSureTheChapterIsComplete => 'Bí cinnte go bhfuil an chaibidil críochnaithe. Ní féidir leat iarr ar anailís ach uair amháin.';

  @override
  String get studyAllSyncMembersRemainOnTheSamePosition => 'Fanann gach ball SYNC sa suíomh céanna';

  @override
  String get studyShareChanges => 'Roinn athruithe le lucht féachana agus sábháil iad ar an freastalaí';

  @override
  String get studyPlaying => 'Ag imirt';

  @override
  String get studyShowResults => 'Results';

  @override
  String get studyShowEvalBar => 'Evaluation bars';

  @override
  String get studyFirst => 'Céad';

  @override
  String get studyPrevious => 'Roimhe';

  @override
  String get studyNext => 'Ar aghaidh';

  @override
  String get studyLast => 'Deiridh';

  @override
  String get studyShareAndExport => 'Comhroinn & easpórtáil';

  @override
  String get studyCloneStudy => 'Déan cóip';

  @override
  String get studyStudyPgn => 'Déan staidéar ar PGN';

  @override
  String get studyDownloadAllGames => 'Íoslódáil gach cluiche';

  @override
  String get studyChapterPgn => 'PGN caibidle';

  @override
  String get studyCopyChapterPgn => 'Cóipeáil PGN';

  @override
  String get studyDownloadGame => 'Íoslódáil cluiche';

  @override
  String get studyStudyUrl => 'URL an staidéir';

  @override
  String get studyCurrentChapterUrl => 'URL caibidil reatha';

  @override
  String get studyYouCanPasteThisInTheForumToEmbed => 'Is féidir é seo a ghreamú san fhóram chun leabú';

  @override
  String get studyStartAtInitialPosition => 'Tosaigh ag an suíomh tosaigh';

  @override
  String studyStartAtX(String param) {
    return 'Tosú ag $param';
  }

  @override
  String get studyEmbedInYourWebsite => 'Leabaithe i do shuíomh Gréasáin nó i do bhlag';

  @override
  String get studyReadMoreAboutEmbedding => 'Léigh tuilleadh faoi leabú';

  @override
  String get studyOnlyPublicStudiesCanBeEmbedded => 'Ní féidir ach staidéir phoiblí a leabú!';

  @override
  String get studyOpen => 'Oscailte';

  @override
  String studyXBroughtToYouByY(String param1, String param2) {
    return '$param1, a thugann $param2 chugat';
  }

  @override
  String get studyStudyNotFound => 'Níor aimsíodh staidéar';

  @override
  String get studyEditChapter => 'Cuir caibidil in eagar';

  @override
  String get studyNewChapter => 'Caibidil nua';

  @override
  String studyImportFromChapterX(String param) {
    return 'Iompórtáil ó $param';
  }

  @override
  String get studyOrientation => 'Treoshuíomh';

  @override
  String get studyAnalysisMode => 'Modh anailíse';

  @override
  String get studyPinnedChapterComment => 'Trácht caibidil greamaithe';

  @override
  String get studySaveChapter => 'Sábháil caibidil';

  @override
  String get studyClearAnnotations => 'Glan anótála';

  @override
  String get studyClearVariations => 'Glan éagsúlachtaí';

  @override
  String get studyDeleteChapter => 'Scrios caibidil';

  @override
  String get studyDeleteThisChapter => 'Scrios an chaibidil seo? Níl aon dul ar ais!';

  @override
  String get studyClearAllCommentsInThisChapter => 'Glan gach trácht, glif agus cruthanna tarraingthe sa chaibidil seo?';

  @override
  String get studyRightUnderTheBoard => 'Díreach faoin gclár';

  @override
  String get studyNoPinnedComment => 'Faic';

  @override
  String get studyNormalAnalysis => 'Gnáth-anailís';

  @override
  String get studyHideNextMoves => 'Folaigh na bearta ina dhiaidh seo';

  @override
  String get studyInteractiveLesson => 'Ceacht idirghníomhach';

  @override
  String studyChapterX(String param) {
    return 'Caibidil $param';
  }

  @override
  String get studyEmpty => 'Folamh';

  @override
  String get studyStartFromInitialPosition => 'Tosaigh ón suíomh tosaigh';

  @override
  String get studyEditor => 'Eagarthóir';

  @override
  String get studyStartFromCustomPosition => 'Tosaigh ón suíomh saincheaptha';

  @override
  String get studyLoadAGameByUrl => 'Lód cluichí le URLanna';

  @override
  String get studyLoadAPositionFromFen => 'Luchtaigh suíomh ó FEN';

  @override
  String get studyLoadAGameFromPgn => 'Lódáil cluichí ó PGN';

  @override
  String get studyAutomatic => 'Uathoibríoch';

  @override
  String get studyUrlOfTheGame => 'URL na gcluichí, ceann amháin an líne';

  @override
  String studyLoadAGameFromXOrY(String param1, String param2) {
    return 'Lódáil cluichí ó $param1 nó $param2';
  }

  @override
  String get studyCreateChapter => 'Cruthaigh caibidil';

  @override
  String get studyCreateStudy => 'Cruthaigh staidéar';

  @override
  String get studyEditStudy => 'Cuir staidéar in eagar';

  @override
  String get studyVisibility => 'Infheictheacht';

  @override
  String get studyPublic => 'Poiblí';

  @override
  String get studyUnlisted => 'Neamhliostaithe';

  @override
  String get studyInviteOnly => 'Tabhair cuireadh amháin';

  @override
  String get studyAllowCloning => 'Lig clónáil';

  @override
  String get studyNobody => 'Níl einne';

  @override
  String get studyOnlyMe => 'Mise amháin';

  @override
  String get studyContributors => 'Rannpháirtithe';

  @override
  String get studyMembers => 'Baill';

  @override
  String get studyEveryone => 'Gach duine';

  @override
  String get studyEnableSync => 'Cuir sinc ar chumas';

  @override
  String get studyYesKeepEveryoneOnTheSamePosition => 'Cinnte: coinnigh gach duine ar an suíomh céanna';

  @override
  String get studyNoLetPeopleBrowseFreely => 'Na déan: lig do dhaoine brabhsáil go saor';

  @override
  String get studyPinnedStudyComment => 'Trácht staidéir greamaithe';

  @override
  String get studyStart => 'Tosú';

  @override
  String get studySave => 'Sábháil';

  @override
  String get studyClearChat => 'Glan comhrá';

  @override
  String get studyDeleteTheStudyChatHistory => 'Scrios an stair comhrá staidéir? Níl aon dul ar ais!';

  @override
  String get studyDeleteStudy => 'Scrios an staidéar';

  @override
  String studyConfirmDeleteStudy(String param) {
    return 'Scrios an staidéar iomlán? Níl aon dul ar ais! Clóscríobh ainm an staidéar le deimhniú: $param';
  }

  @override
  String get studyWhereDoYouWantToStudyThat => 'Cá háit ar mhaith leat staidéar a dhéanamh air sin?';

  @override
  String get studyGoodMove => 'Beart maith';

  @override
  String get studyMistake => 'Botún';

  @override
  String get studyBrilliantMove => 'Beart iontach';

  @override
  String get studyBlunder => 'Botún';

  @override
  String get studyInterestingMove => 'Beart suimiúil';

  @override
  String get studyDubiousMove => 'Beart amhrasach';

  @override
  String get studyOnlyMove => 'Beart dleathach';

  @override
  String get studyZugzwang => 'Zugzwang';

  @override
  String get studyEqualPosition => 'Suíomh cothrom';

  @override
  String get studyUnclearPosition => 'Suíomh doiléir';

  @override
  String get studyWhiteIsSlightlyBetter => 'Tá bán píosa beag níos fearr';

  @override
  String get studyBlackIsSlightlyBetter => 'Tá dubh píosa beag níos fearr';

  @override
  String get studyWhiteIsBetter => 'Tá bán níos fearr';

  @override
  String get studyBlackIsBetter => 'Tá dubh níos fearr';

  @override
  String get studyWhiteIsWinning => 'Bán ag bua';

  @override
  String get studyBlackIsWinning => 'Dubh ag bua';

  @override
  String get studyNovelty => 'Nuaga';

  @override
  String get studyDevelopment => 'Forbairt';

  @override
  String get studyInitiative => 'Tionscnamh';

  @override
  String get studyAttack => 'Ionsaí';

  @override
  String get studyCounterplay => 'Frithimirt';

  @override
  String get studyTimeTrouble => 'Trioblóid ama';

  @override
  String get studyWithCompensation => 'Le cúiteamh';

  @override
  String get studyWithTheIdea => 'Le smaoineamh';

  @override
  String get studyNextChapter => 'Céad chaibidil eile';

  @override
  String get studyPrevChapter => 'Caibidil roimhe seo';

  @override
  String get studyStudyActions => 'Déan staidéar ar ghníomhartha';

  @override
  String get studyTopics => 'Topaicí';

  @override
  String get studyMyTopics => 'Mo thopaicí';

  @override
  String get studyPopularTopics => 'Topaicí choitianta';

  @override
  String get studyManageTopics => 'Bainistigh topaicí';

  @override
  String get studyBack => 'Siar';

  @override
  String get studyPlayAgain => 'Imir arís';

  @override
  String get studyWhatWouldYouPlay => 'Cad a dhéanfá sa suíomh seo?';

  @override
  String get studyYouCompletedThisLesson => 'Comhghairdeas! Chríochnaigh tú an ceacht seo.';

  @override
  String studyPerPage(String param) {
    return '$param per page';
  }

  @override
  String studyNbChapters(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Caibidil',
      many: '$count Caibidil',
      few: '$count gCaibidil',
      two: '$count Chaibidil',
      one: '$count Caibidil',
    );
    return '$_temp0';
  }

  @override
  String studyNbGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Cluiche',
      many: '$count Cluiche',
      few: '$count gCluiche',
      two: '$count Chluiche',
      one: '$count Cluiche',
    );
    return '$_temp0';
  }

  @override
  String studyNbMembers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Comhalta',
      many: '$count Comhalta',
      few: '$count gComhalta',
      two: '$count Chomhalta',
      one: '$count Comhalta',
    );
    return '$_temp0';
  }

  @override
  String studyPasteYourPgnTextHereUpToNbGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Greamaigh do théacs PGN anseo, suas le $count cluiche',
      many: 'Greamaigh do théacs PGN anseo, suas le $count cluiche',
      few: 'Greamaigh do théacs PGN anseo, suas le $count gcluiche',
      two: 'Greamaigh do théacs PGN anseo, suas le $count chluiche',
      one: 'Greamaigh do théacs PGN anseo, suas le $count cluiche',
    );
    return '$_temp0';
  }

  @override
  String get timeagoJustNow => 'díreach anois';

  @override
  String get timeagoRightNow => 'anois';

  @override
  String get timeagoCompleted => 'completed';

  @override
  String timeagoInNbSeconds(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'i $count soicind',
      many: 'i $count soicind',
      few: 'i $count soicind',
      two: 'i $count soicind',
      one: 'i soicind amháín',
    );
    return '$_temp0';
  }

  @override
  String timeagoInNbMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'i $count nóiméad',
      many: 'i $count nóiméad',
      few: 'i $count nóiméad',
      two: 'i $count nóiméad',
      one: 'i nóiméad amháin',
    );
    return '$_temp0';
  }

  @override
  String timeagoInNbHours(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'i $count uair',
      many: 'i $count uair',
      few: 'i $count uair',
      two: 'i $count uair',
      one: 'in uair amháin',
    );
    return '$_temp0';
  }

  @override
  String timeagoInNbDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'i $count lá',
      many: 'i $count lá',
      few: 'i $count lá',
      two: 'i $count lá',
      one: 'i lá amháín',
    );
    return '$_temp0';
  }

  @override
  String timeagoInNbWeeks(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'i $count seachtain',
      many: 'i $count seachtain',
      few: 'i $count seachtain',
      two: 'i $count sheachtain',
      one: 'i seachtain amháin',
    );
    return '$_temp0';
  }

  @override
  String timeagoInNbMonths(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'i $count mí',
      many: 'i $count mí',
      few: 'i $count mhí',
      two: 'i $count mhí',
      one: 'i gceann míosa',
    );
    return '$_temp0';
  }

  @override
  String timeagoInNbYears(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'i gceann $count bliain',
      many: 'i gceann $count mbliain',
      few: 'i gceann $count bhliain',
      two: 'i gceann $count bhliain',
      one: 'i gceann bliana',
    );
    return '$_temp0';
  }

  @override
  String timeagoNbMinutesAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count nóiméad ó shin',
      many: '$count nóiméad ó shin',
      few: '$count nóiméad ó shin',
      two: '$count nóiméad ó shin',
      one: 'nóiméad amháin ó shin',
    );
    return '$_temp0';
  }

  @override
  String timeagoNbHoursAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count uair ó shin',
      many: '$count uair ó shin',
      few: '$count uair ó shin',
      two: '$count uair ó shin',
      one: 'uair amháin ó shin',
    );
    return '$_temp0';
  }

  @override
  String timeagoNbDaysAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count lá ó shin',
      many: '$count lá ó shin',
      few: '$count lá ó shin',
      two: '$count lá ó shin',
      one: 'lá amháin ó shin',
    );
    return '$_temp0';
  }

  @override
  String timeagoNbWeeksAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count seachtain ó shin',
      many: '$count seachtain ó shin',
      few: '$count sheachtain ó shin',
      two: '$count sheachtain ó shin',
      one: 'seachtain amháin ó shin',
    );
    return '$_temp0';
  }

  @override
  String timeagoNbMonthsAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count mí ó shin',
      many: '$count mí ó shin',
      few: '$count mí ó shin',
      two: '$count mhí ó shin',
      one: 'mí amháin ó shin',
    );
    return '$_temp0';
  }

  @override
  String timeagoNbYearsAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count bliain ó shin',
      many: '$count mbliain ó shin',
      few: '$count mbliain ó shin',
      two: '$count bhliain ó shin',
      one: 'Bliain amháin ó shin',
    );
    return '$_temp0';
  }

  @override
  String timeagoNbMinutesRemaining(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count minutes remaining',
      one: '$count minute remaining',
    );
    return '$_temp0';
  }

  @override
  String timeagoNbHoursRemaining(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count hours remaining',
      one: '$count hour remaining',
    );
    return '$_temp0';
  }
}
