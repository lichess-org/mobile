import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'l10n_af.dart';
import 'l10n_ar.dart';
import 'l10n_az.dart';
import 'l10n_be.dart';
import 'l10n_bg.dart';
import 'l10n_bn.dart';
import 'l10n_bs.dart';
import 'l10n_ca.dart';
import 'l10n_cs.dart';
import 'l10n_da.dart';
import 'l10n_de.dart';
import 'l10n_el.dart';
import 'l10n_en.dart';
import 'l10n_eo.dart';
import 'l10n_es.dart';
import 'l10n_et.dart';
import 'l10n_eu.dart';
import 'l10n_fa.dart';
import 'l10n_fi.dart';
import 'l10n_fr.dart';
import 'l10n_gl.dart';
import 'l10n_gsw.dart';
import 'l10n_he.dart';
import 'l10n_hi.dart';
import 'l10n_hr.dart';
import 'l10n_hu.dart';
import 'l10n_hy.dart';
import 'l10n_id.dart';
import 'l10n_it.dart';
import 'l10n_ja.dart';
import 'l10n_kk.dart';
import 'l10n_ko.dart';
import 'l10n_lt.dart';
import 'l10n_lv.dart';
import 'l10n_mk.dart';
import 'l10n_nb.dart';
import 'l10n_nl.dart';
import 'l10n_pl.dart';
import 'l10n_pt.dart';
import 'l10n_ro.dart';
import 'l10n_ru.dart';
import 'l10n_sk.dart';
import 'l10n_sl.dart';
import 'l10n_sq.dart';
import 'l10n_sr.dart';
import 'l10n_sv.dart';
import 'l10n_tr.dart';
import 'l10n_uk.dart';
import 'l10n_vi.dart';
import 'l10n_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/l10n.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('af'),
    Locale('ar'),
    Locale('az'),
    Locale('be'),
    Locale('bg'),
    Locale('bn'),
    Locale('bs'),
    Locale('ca'),
    Locale('cs'),
    Locale('da'),
    Locale('de'),
    Locale('el'),
    Locale('en', 'US'),
    Locale('eo'),
    Locale('es'),
    Locale('et'),
    Locale('eu'),
    Locale('fa'),
    Locale('fi'),
    Locale('fr'),
    Locale('gl'),
    Locale('gsw'),
    Locale('he'),
    Locale('hi'),
    Locale('hr'),
    Locale('hu'),
    Locale('hy'),
    Locale('id'),
    Locale('it'),
    Locale('ja'),
    Locale('kk'),
    Locale('ko'),
    Locale('lt'),
    Locale('lv'),
    Locale('mk'),
    Locale('nb'),
    Locale('nl'),
    Locale('pl'),
    Locale('pt'),
    Locale('pt', 'BR'),
    Locale('ro'),
    Locale('ru'),
    Locale('sk'),
    Locale('sl'),
    Locale('sq'),
    Locale('sr'),
    Locale('sv'),
    Locale('tr'),
    Locale('uk'),
    Locale('vi'),
    Locale('zh'),
    Locale('zh', 'TW')
  ];

  /// No description provided for @mobileAllGames.
  ///
  /// In en, this message translates to:
  /// **'All games'**
  String get mobileAllGames;

  /// No description provided for @mobileAreYouSure.
  ///
  /// In en, this message translates to:
  /// **'Are you sure?'**
  String get mobileAreYouSure;

  /// No description provided for @mobileCancelTakebackOffer.
  ///
  /// In en, this message translates to:
  /// **'Cancel takeback offer'**
  String get mobileCancelTakebackOffer;

  /// No description provided for @mobileClearButton.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get mobileClearButton;

  /// No description provided for @mobileCorrespondenceClearSavedMove.
  ///
  /// In en, this message translates to:
  /// **'Clear saved move'**
  String get mobileCorrespondenceClearSavedMove;

  /// No description provided for @mobileCustomGameJoinAGame.
  ///
  /// In en, this message translates to:
  /// **'Join a game'**
  String get mobileCustomGameJoinAGame;

  /// No description provided for @mobileFeedbackButton.
  ///
  /// In en, this message translates to:
  /// **'Feedback'**
  String get mobileFeedbackButton;

  /// No description provided for @mobileGreeting.
  ///
  /// In en, this message translates to:
  /// **'Hello, {param}'**
  String mobileGreeting(String param);

  /// No description provided for @mobileGreetingWithoutName.
  ///
  /// In en, this message translates to:
  /// **'Hello'**
  String get mobileGreetingWithoutName;

  /// No description provided for @mobileHideVariation.
  ///
  /// In en, this message translates to:
  /// **'Hide variation'**
  String get mobileHideVariation;

  /// No description provided for @mobileHomeTab.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get mobileHomeTab;

  /// No description provided for @mobileLiveStreamers.
  ///
  /// In en, this message translates to:
  /// **'Live streamers'**
  String get mobileLiveStreamers;

  /// No description provided for @mobileMustBeLoggedIn.
  ///
  /// In en, this message translates to:
  /// **'You must be logged in to view this page.'**
  String get mobileMustBeLoggedIn;

  /// No description provided for @mobileNoSearchResults.
  ///
  /// In en, this message translates to:
  /// **'No results'**
  String get mobileNoSearchResults;

  /// No description provided for @mobileNotFollowingAnyUser.
  ///
  /// In en, this message translates to:
  /// **'You are not following any user.'**
  String get mobileNotFollowingAnyUser;

  /// No description provided for @mobileOkButton.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get mobileOkButton;

  /// No description provided for @mobilePlayersMatchingSearchTerm.
  ///
  /// In en, this message translates to:
  /// **'Players with \"{param}\"'**
  String mobilePlayersMatchingSearchTerm(String param);

  /// No description provided for @mobilePrefMagnifyDraggedPiece.
  ///
  /// In en, this message translates to:
  /// **'Magnify dragged piece'**
  String get mobilePrefMagnifyDraggedPiece;

  /// No description provided for @mobilePuzzleStormConfirmEndRun.
  ///
  /// In en, this message translates to:
  /// **'Do you want to end this run?'**
  String get mobilePuzzleStormConfirmEndRun;

  /// No description provided for @mobilePuzzleStormFilterNothingToShow.
  ///
  /// In en, this message translates to:
  /// **'Nothing to show, please change the filters'**
  String get mobilePuzzleStormFilterNothingToShow;

  /// No description provided for @mobilePuzzleStormNothingToShow.
  ///
  /// In en, this message translates to:
  /// **'Nothing to show. Play some runs of Puzzle Storm.'**
  String get mobilePuzzleStormNothingToShow;

  /// No description provided for @mobilePuzzleStormSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Solve as many puzzles as possible in 3 minutes.'**
  String get mobilePuzzleStormSubtitle;

  /// No description provided for @mobilePuzzleStreakAbortWarning.
  ///
  /// In en, this message translates to:
  /// **'You will lose your current streak and your score will be saved.'**
  String get mobilePuzzleStreakAbortWarning;

  /// No description provided for @mobilePuzzleThemesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Play puzzles from your favorite openings, or choose a theme.'**
  String get mobilePuzzleThemesSubtitle;

  /// No description provided for @mobilePuzzlesTab.
  ///
  /// In en, this message translates to:
  /// **'Puzzles'**
  String get mobilePuzzlesTab;

  /// No description provided for @mobileRecentSearches.
  ///
  /// In en, this message translates to:
  /// **'Recent searches'**
  String get mobileRecentSearches;

  /// No description provided for @mobileSettingsHapticFeedback.
  ///
  /// In en, this message translates to:
  /// **'Haptic feedback'**
  String get mobileSettingsHapticFeedback;

  /// No description provided for @mobileSettingsImmersiveMode.
  ///
  /// In en, this message translates to:
  /// **'Immersive mode'**
  String get mobileSettingsImmersiveMode;

  /// No description provided for @mobileSettingsImmersiveModeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Hide system UI while playing. Use this if you are bothered by the system\'s navigation gestures at the edges of the screen. Applies to game and Puzzle Storm screens.'**
  String get mobileSettingsImmersiveModeSubtitle;

  /// No description provided for @mobileSettingsTab.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get mobileSettingsTab;

  /// No description provided for @mobileShareGamePGN.
  ///
  /// In en, this message translates to:
  /// **'Share PGN'**
  String get mobileShareGamePGN;

  /// No description provided for @mobileShareGameURL.
  ///
  /// In en, this message translates to:
  /// **'Share game URL'**
  String get mobileShareGameURL;

  /// No description provided for @mobileSharePositionAsFEN.
  ///
  /// In en, this message translates to:
  /// **'Share position as FEN'**
  String get mobileSharePositionAsFEN;

  /// No description provided for @mobileSharePuzzle.
  ///
  /// In en, this message translates to:
  /// **'Share this puzzle'**
  String get mobileSharePuzzle;

  /// No description provided for @mobileShowComments.
  ///
  /// In en, this message translates to:
  /// **'Show comments'**
  String get mobileShowComments;

  /// No description provided for @mobileShowResult.
  ///
  /// In en, this message translates to:
  /// **'Show result'**
  String get mobileShowResult;

  /// No description provided for @mobileShowVariations.
  ///
  /// In en, this message translates to:
  /// **'Show variations'**
  String get mobileShowVariations;

  /// No description provided for @mobileSomethingWentWrong.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong.'**
  String get mobileSomethingWentWrong;

  /// No description provided for @mobileSystemColors.
  ///
  /// In en, this message translates to:
  /// **'System colors'**
  String get mobileSystemColors;

  /// No description provided for @mobileTheme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get mobileTheme;

  /// No description provided for @mobileToolsTab.
  ///
  /// In en, this message translates to:
  /// **'Tools'**
  String get mobileToolsTab;

  /// No description provided for @mobileWaitingForOpponentToJoin.
  ///
  /// In en, this message translates to:
  /// **'Waiting for opponent to join...'**
  String get mobileWaitingForOpponentToJoin;

  /// No description provided for @mobileWatchTab.
  ///
  /// In en, this message translates to:
  /// **'Watch'**
  String get mobileWatchTab;

  /// No description provided for @activityActivity.
  ///
  /// In en, this message translates to:
  /// **'Activity'**
  String get activityActivity;

  /// No description provided for @activityHostedALiveStream.
  ///
  /// In en, this message translates to:
  /// **'Hosted a live stream'**
  String get activityHostedALiveStream;

  /// No description provided for @activityRankedInSwissTournament.
  ///
  /// In en, this message translates to:
  /// **'Ranked #{param1} in {param2}'**
  String activityRankedInSwissTournament(String param1, String param2);

  /// No description provided for @activitySignedUp.
  ///
  /// In en, this message translates to:
  /// **'Signed up to lichess.org'**
  String get activitySignedUp;

  /// No description provided for @activitySupportedNbMonths.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Supported lichess.org for {count} month as a {param2}} other{Supported lichess.org for {count} months as a {param2}}}'**
  String activitySupportedNbMonths(int count, String param2);

  /// No description provided for @activityPracticedNbPositions.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Practised {count} position on {param2}} other{Practised {count} positions on {param2}}}'**
  String activityPracticedNbPositions(int count, String param2);

  /// No description provided for @activitySolvedNbPuzzles.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Solved {count} training puzzle} other{Solved {count} training puzzles}}'**
  String activitySolvedNbPuzzles(int count);

  /// No description provided for @activityPlayedNbGames.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Played {count} {param2} game} other{Played {count} {param2} games}}'**
  String activityPlayedNbGames(int count, String param2);

  /// No description provided for @activityPostedNbMessages.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Posted {count} message in {param2}} other{Posted {count} messages in {param2}}}'**
  String activityPostedNbMessages(int count, String param2);

  /// No description provided for @activityPlayedNbMoves.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Played {count} move} other{Played {count} moves}}'**
  String activityPlayedNbMoves(int count);

  /// No description provided for @activityInNbCorrespondenceGames.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{in {count} correspondence game} other{in {count} correspondence games}}'**
  String activityInNbCorrespondenceGames(int count);

  /// No description provided for @activityCompletedNbGames.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Completed {count} correspondence game} other{Completed {count} correspondence games}}'**
  String activityCompletedNbGames(int count);

  /// No description provided for @activityCompletedNbVariantGames.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Completed {count} {param2} correspondence game} other{Completed {count} {param2} correspondence games}}'**
  String activityCompletedNbVariantGames(int count, String param2);

  /// No description provided for @activityFollowedNbPlayers.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Started following {count} player} other{Started following {count} players}}'**
  String activityFollowedNbPlayers(int count);

  /// No description provided for @activityGainedNbFollowers.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Gained {count} new follower} other{Gained {count} new followers}}'**
  String activityGainedNbFollowers(int count);

  /// No description provided for @activityHostedNbSimuls.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Hosted {count} simultaneous exhibition} other{Hosted {count} simultaneous exhibitions}}'**
  String activityHostedNbSimuls(int count);

  /// No description provided for @activityJoinedNbSimuls.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Participated in {count} simultaneous exhibition} other{Participated in {count} simultaneous exhibitions}}'**
  String activityJoinedNbSimuls(int count);

  /// No description provided for @activityCreatedNbStudies.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Created {count} new study} other{Created {count} new studies}}'**
  String activityCreatedNbStudies(int count);

  /// No description provided for @activityCompetedInNbTournaments.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Competed in {count} Arena tournament} other{Competed in {count} Arena tournaments}}'**
  String activityCompetedInNbTournaments(int count);

  /// No description provided for @activityRankedInTournament.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Ranked #{count} (top {param2}%) with {param3} game in {param4}} other{Ranked #{count} (top {param2}%) with {param3} games in {param4}}}'**
  String activityRankedInTournament(int count, String param2, String param3, String param4);

  /// No description provided for @activityCompetedInNbSwissTournaments.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Competed in {count} Swiss tournament} other{Competed in {count} Swiss tournaments}}'**
  String activityCompetedInNbSwissTournaments(int count);

  /// No description provided for @activityJoinedNbTeams.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Joined {count} team} other{Joined {count} teams}}'**
  String activityJoinedNbTeams(int count);

  /// No description provided for @broadcastBroadcasts.
  ///
  /// In en, this message translates to:
  /// **'Broadcasts'**
  String get broadcastBroadcasts;

  /// No description provided for @broadcastMyBroadcasts.
  ///
  /// In en, this message translates to:
  /// **'My broadcasts'**
  String get broadcastMyBroadcasts;

  /// No description provided for @broadcastLiveBroadcasts.
  ///
  /// In en, this message translates to:
  /// **'Live tournament broadcasts'**
  String get broadcastLiveBroadcasts;

  /// No description provided for @broadcastBroadcastCalendar.
  ///
  /// In en, this message translates to:
  /// **'Broadcast calendar'**
  String get broadcastBroadcastCalendar;

  /// No description provided for @broadcastNewBroadcast.
  ///
  /// In en, this message translates to:
  /// **'New live broadcast'**
  String get broadcastNewBroadcast;

  /// No description provided for @broadcastSubscribedBroadcasts.
  ///
  /// In en, this message translates to:
  /// **'Subscribed broadcasts'**
  String get broadcastSubscribedBroadcasts;

  /// No description provided for @broadcastAboutBroadcasts.
  ///
  /// In en, this message translates to:
  /// **'About broadcasts'**
  String get broadcastAboutBroadcasts;

  /// No description provided for @broadcastHowToUseLichessBroadcasts.
  ///
  /// In en, this message translates to:
  /// **'How to use Lichess Broadcasts.'**
  String get broadcastHowToUseLichessBroadcasts;

  /// No description provided for @broadcastTheNewRoundHelp.
  ///
  /// In en, this message translates to:
  /// **'The new round will have the same members and contributors as the previous one.'**
  String get broadcastTheNewRoundHelp;

  /// No description provided for @broadcastAddRound.
  ///
  /// In en, this message translates to:
  /// **'Add a round'**
  String get broadcastAddRound;

  /// No description provided for @broadcastOngoing.
  ///
  /// In en, this message translates to:
  /// **'Ongoing'**
  String get broadcastOngoing;

  /// No description provided for @broadcastUpcoming.
  ///
  /// In en, this message translates to:
  /// **'Upcoming'**
  String get broadcastUpcoming;

  /// No description provided for @broadcastRoundName.
  ///
  /// In en, this message translates to:
  /// **'Round name'**
  String get broadcastRoundName;

  /// No description provided for @broadcastRoundNumber.
  ///
  /// In en, this message translates to:
  /// **'Round number'**
  String get broadcastRoundNumber;

  /// No description provided for @broadcastTournamentName.
  ///
  /// In en, this message translates to:
  /// **'Tournament name'**
  String get broadcastTournamentName;

  /// No description provided for @broadcastTournamentDescription.
  ///
  /// In en, this message translates to:
  /// **'Short tournament description'**
  String get broadcastTournamentDescription;

  /// No description provided for @broadcastFullDescription.
  ///
  /// In en, this message translates to:
  /// **'Full tournament description'**
  String get broadcastFullDescription;

  /// No description provided for @broadcastFullDescriptionHelp.
  ///
  /// In en, this message translates to:
  /// **'Optional long description of the tournament. {param1} is available. Length must be less than {param2} characters.'**
  String broadcastFullDescriptionHelp(String param1, String param2);

  /// No description provided for @broadcastSourceSingleUrl.
  ///
  /// In en, this message translates to:
  /// **'PGN Source URL'**
  String get broadcastSourceSingleUrl;

  /// No description provided for @broadcastSourceUrlHelp.
  ///
  /// In en, this message translates to:
  /// **'URL that Lichess will check to get PGN updates. It must be publicly accessible from the Internet.'**
  String get broadcastSourceUrlHelp;

  /// No description provided for @broadcastSourceGameIds.
  ///
  /// In en, this message translates to:
  /// **'Up to 64 Lichess game IDs, separated by spaces.'**
  String get broadcastSourceGameIds;

  /// No description provided for @broadcastStartDateTimeZone.
  ///
  /// In en, this message translates to:
  /// **'Start date in the tournament local timezone: {param}'**
  String broadcastStartDateTimeZone(String param);

  /// No description provided for @broadcastStartDateHelp.
  ///
  /// In en, this message translates to:
  /// **'Optional, if you know when the event starts'**
  String get broadcastStartDateHelp;

  /// No description provided for @broadcastCurrentGameUrl.
  ///
  /// In en, this message translates to:
  /// **'Current game URL'**
  String get broadcastCurrentGameUrl;

  /// No description provided for @broadcastDownloadAllRounds.
  ///
  /// In en, this message translates to:
  /// **'Download all rounds'**
  String get broadcastDownloadAllRounds;

  /// No description provided for @broadcastResetRound.
  ///
  /// In en, this message translates to:
  /// **'Reset this round'**
  String get broadcastResetRound;

  /// No description provided for @broadcastDeleteRound.
  ///
  /// In en, this message translates to:
  /// **'Delete this round'**
  String get broadcastDeleteRound;

  /// No description provided for @broadcastDefinitivelyDeleteRound.
  ///
  /// In en, this message translates to:
  /// **'Definitively delete the round and all its games.'**
  String get broadcastDefinitivelyDeleteRound;

  /// No description provided for @broadcastDeleteAllGamesOfThisRound.
  ///
  /// In en, this message translates to:
  /// **'Delete all games of this round. The source will need to be active in order to re-create them.'**
  String get broadcastDeleteAllGamesOfThisRound;

  /// No description provided for @broadcastEditRoundStudy.
  ///
  /// In en, this message translates to:
  /// **'Edit round study'**
  String get broadcastEditRoundStudy;

  /// No description provided for @broadcastDeleteTournament.
  ///
  /// In en, this message translates to:
  /// **'Delete this tournament'**
  String get broadcastDeleteTournament;

  /// No description provided for @broadcastDefinitivelyDeleteTournament.
  ///
  /// In en, this message translates to:
  /// **'Definitively delete the entire tournament, all its rounds and all its games.'**
  String get broadcastDefinitivelyDeleteTournament;

  /// No description provided for @broadcastShowScores.
  ///
  /// In en, this message translates to:
  /// **'Show players scores based on game results'**
  String get broadcastShowScores;

  /// No description provided for @broadcastReplacePlayerTags.
  ///
  /// In en, this message translates to:
  /// **'Optional: replace player names, ratings and titles'**
  String get broadcastReplacePlayerTags;

  /// No description provided for @broadcastFideFederations.
  ///
  /// In en, this message translates to:
  /// **'FIDE federations'**
  String get broadcastFideFederations;

  /// No description provided for @broadcastTop10Rating.
  ///
  /// In en, this message translates to:
  /// **'Top 10 rating'**
  String get broadcastTop10Rating;

  /// No description provided for @broadcastFidePlayers.
  ///
  /// In en, this message translates to:
  /// **'FIDE players'**
  String get broadcastFidePlayers;

  /// No description provided for @broadcastFidePlayerNotFound.
  ///
  /// In en, this message translates to:
  /// **'FIDE player not found'**
  String get broadcastFidePlayerNotFound;

  /// No description provided for @broadcastFideProfile.
  ///
  /// In en, this message translates to:
  /// **'FIDE profile'**
  String get broadcastFideProfile;

  /// No description provided for @broadcastFederation.
  ///
  /// In en, this message translates to:
  /// **'Federation'**
  String get broadcastFederation;

  /// No description provided for @broadcastAgeThisYear.
  ///
  /// In en, this message translates to:
  /// **'Age this year'**
  String get broadcastAgeThisYear;

  /// No description provided for @broadcastUnrated.
  ///
  /// In en, this message translates to:
  /// **'Unrated'**
  String get broadcastUnrated;

  /// No description provided for @broadcastRecentTournaments.
  ///
  /// In en, this message translates to:
  /// **'Recent tournaments'**
  String get broadcastRecentTournaments;

  /// No description provided for @broadcastOpenLichess.
  ///
  /// In en, this message translates to:
  /// **'Open in Lichess'**
  String get broadcastOpenLichess;

  /// No description provided for @broadcastTeams.
  ///
  /// In en, this message translates to:
  /// **'Teams'**
  String get broadcastTeams;

  /// No description provided for @broadcastBoards.
  ///
  /// In en, this message translates to:
  /// **'Boards'**
  String get broadcastBoards;

  /// No description provided for @broadcastOverview.
  ///
  /// In en, this message translates to:
  /// **'Overview'**
  String get broadcastOverview;

  /// No description provided for @broadcastSubscribeTitle.
  ///
  /// In en, this message translates to:
  /// **'Subscribe to be notified when each round starts. You can toggle bell or push notifications for broadcasts in your account preferences.'**
  String get broadcastSubscribeTitle;

  /// No description provided for @broadcastUploadImage.
  ///
  /// In en, this message translates to:
  /// **'Upload tournament image'**
  String get broadcastUploadImage;

  /// No description provided for @broadcastNoBoardsYet.
  ///
  /// In en, this message translates to:
  /// **'No boards yet. These will appear once games are uploaded.'**
  String get broadcastNoBoardsYet;

  /// No description provided for @broadcastBoardsCanBeLoaded.
  ///
  /// In en, this message translates to:
  /// **'Boards can be loaded with a source or via the {param}'**
  String broadcastBoardsCanBeLoaded(String param);

  /// No description provided for @broadcastStartsAfter.
  ///
  /// In en, this message translates to:
  /// **'Starts after {param}'**
  String broadcastStartsAfter(String param);

  /// No description provided for @broadcastStartVerySoon.
  ///
  /// In en, this message translates to:
  /// **'The broadcast will start very soon.'**
  String get broadcastStartVerySoon;

  /// No description provided for @broadcastNotYetStarted.
  ///
  /// In en, this message translates to:
  /// **'The broadcast has not yet started.'**
  String get broadcastNotYetStarted;

  /// No description provided for @broadcastOfficialWebsite.
  ///
  /// In en, this message translates to:
  /// **'Official website'**
  String get broadcastOfficialWebsite;

  /// No description provided for @broadcastStandings.
  ///
  /// In en, this message translates to:
  /// **'Standings'**
  String get broadcastStandings;

  /// No description provided for @broadcastOfficialStandings.
  ///
  /// In en, this message translates to:
  /// **'Official Standings'**
  String get broadcastOfficialStandings;

  /// No description provided for @broadcastIframeHelp.
  ///
  /// In en, this message translates to:
  /// **'More options on the {param}'**
  String broadcastIframeHelp(String param);

  /// No description provided for @broadcastWebmastersPage.
  ///
  /// In en, this message translates to:
  /// **'webmasters page'**
  String get broadcastWebmastersPage;

  /// No description provided for @broadcastPgnSourceHelp.
  ///
  /// In en, this message translates to:
  /// **'A public, real-time PGN source for this round. We also offer a {param} for faster and more efficient synchronisation.'**
  String broadcastPgnSourceHelp(String param);

  /// No description provided for @broadcastEmbedThisBroadcast.
  ///
  /// In en, this message translates to:
  /// **'Embed this broadcast in your website'**
  String get broadcastEmbedThisBroadcast;

  /// No description provided for @broadcastEmbedThisRound.
  ///
  /// In en, this message translates to:
  /// **'Embed {param} in your website'**
  String broadcastEmbedThisRound(String param);

  /// No description provided for @broadcastRatingDiff.
  ///
  /// In en, this message translates to:
  /// **'Rating diff'**
  String get broadcastRatingDiff;

  /// No description provided for @broadcastGamesThisTournament.
  ///
  /// In en, this message translates to:
  /// **'Games in this tournament'**
  String get broadcastGamesThisTournament;

  /// No description provided for @broadcastScore.
  ///
  /// In en, this message translates to:
  /// **'Score'**
  String get broadcastScore;

  /// No description provided for @broadcastAllTeams.
  ///
  /// In en, this message translates to:
  /// **'All teams'**
  String get broadcastAllTeams;

  /// No description provided for @broadcastTournamentFormat.
  ///
  /// In en, this message translates to:
  /// **'Tournament format'**
  String get broadcastTournamentFormat;

  /// No description provided for @broadcastTournamentLocation.
  ///
  /// In en, this message translates to:
  /// **'Tournament Location'**
  String get broadcastTournamentLocation;

  /// No description provided for @broadcastTopPlayers.
  ///
  /// In en, this message translates to:
  /// **'Top players'**
  String get broadcastTopPlayers;

  /// No description provided for @broadcastTimezone.
  ///
  /// In en, this message translates to:
  /// **'Time zone'**
  String get broadcastTimezone;

  /// No description provided for @broadcastFideRatingCategory.
  ///
  /// In en, this message translates to:
  /// **'FIDE rating category'**
  String get broadcastFideRatingCategory;

  /// No description provided for @broadcastOptionalDetails.
  ///
  /// In en, this message translates to:
  /// **'Optional details'**
  String get broadcastOptionalDetails;

  /// No description provided for @broadcastPastBroadcasts.
  ///
  /// In en, this message translates to:
  /// **'Past broadcasts'**
  String get broadcastPastBroadcasts;

  /// No description provided for @broadcastAllBroadcastsByMonth.
  ///
  /// In en, this message translates to:
  /// **'View all broadcasts by month'**
  String get broadcastAllBroadcastsByMonth;

  /// No description provided for @broadcastBackToLiveMove.
  ///
  /// In en, this message translates to:
  /// **'Back to live move'**
  String get broadcastBackToLiveMove;

  /// No description provided for @broadcastSinceHideResults.
  ///
  /// In en, this message translates to:
  /// **'Since you chose to hide the results, all the preview boards are empty to avoid spoilers.'**
  String get broadcastSinceHideResults;

  /// No description provided for @broadcastNbBroadcasts.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{{count} broadcast} other{{count} broadcasts}}'**
  String broadcastNbBroadcasts(int count);

  /// No description provided for @challengeChallengesX.
  ///
  /// In en, this message translates to:
  /// **'Challenges: {param1}'**
  String challengeChallengesX(String param1);

  /// No description provided for @challengeChallengeToPlay.
  ///
  /// In en, this message translates to:
  /// **'Challenge to a game'**
  String get challengeChallengeToPlay;

  /// No description provided for @challengeChallengeDeclined.
  ///
  /// In en, this message translates to:
  /// **'Challenge declined.'**
  String get challengeChallengeDeclined;

  /// No description provided for @challengeChallengeAccepted.
  ///
  /// In en, this message translates to:
  /// **'Challenge accepted!'**
  String get challengeChallengeAccepted;

  /// No description provided for @challengeChallengeCanceled.
  ///
  /// In en, this message translates to:
  /// **'Challenge cancelled.'**
  String get challengeChallengeCanceled;

  /// No description provided for @challengeRegisterToSendChallenges.
  ///
  /// In en, this message translates to:
  /// **'Please register to send challenges to this user.'**
  String get challengeRegisterToSendChallenges;

  /// No description provided for @challengeYouCannotChallengeX.
  ///
  /// In en, this message translates to:
  /// **'You cannot challenge {param}.'**
  String challengeYouCannotChallengeX(String param);

  /// No description provided for @challengeXDoesNotAcceptChallenges.
  ///
  /// In en, this message translates to:
  /// **'{param} does not accept challenges.'**
  String challengeXDoesNotAcceptChallenges(String param);

  /// No description provided for @challengeYourXRatingIsTooFarFromY.
  ///
  /// In en, this message translates to:
  /// **'Your {param1} rating is too far from {param2}.'**
  String challengeYourXRatingIsTooFarFromY(String param1, String param2);

  /// No description provided for @challengeCannotChallengeDueToProvisionalXRating.
  ///
  /// In en, this message translates to:
  /// **'Cannot challenge due to provisional {param} rating.'**
  String challengeCannotChallengeDueToProvisionalXRating(String param);

  /// No description provided for @challengeXOnlyAcceptsChallengesFromFriends.
  ///
  /// In en, this message translates to:
  /// **'{param} only accepts challenges from friends.'**
  String challengeXOnlyAcceptsChallengesFromFriends(String param);

  /// No description provided for @challengeDeclineGeneric.
  ///
  /// In en, this message translates to:
  /// **'I\'m not accepting challenges at the moment.'**
  String get challengeDeclineGeneric;

  /// No description provided for @challengeDeclineLater.
  ///
  /// In en, this message translates to:
  /// **'This is not the right time for me, please ask again later.'**
  String get challengeDeclineLater;

  /// No description provided for @challengeDeclineTooFast.
  ///
  /// In en, this message translates to:
  /// **'This time control is too fast for me, please challenge again with a slower game.'**
  String get challengeDeclineTooFast;

  /// No description provided for @challengeDeclineTooSlow.
  ///
  /// In en, this message translates to:
  /// **'This time control is too slow for me, please challenge again with a faster game.'**
  String get challengeDeclineTooSlow;

  /// No description provided for @challengeDeclineTimeControl.
  ///
  /// In en, this message translates to:
  /// **'I\'m not accepting challenges with this time control.'**
  String get challengeDeclineTimeControl;

  /// No description provided for @challengeDeclineRated.
  ///
  /// In en, this message translates to:
  /// **'Please send me a rated challenge instead.'**
  String get challengeDeclineRated;

  /// No description provided for @challengeDeclineCasual.
  ///
  /// In en, this message translates to:
  /// **'Please send me a casual challenge instead.'**
  String get challengeDeclineCasual;

  /// No description provided for @challengeDeclineStandard.
  ///
  /// In en, this message translates to:
  /// **'I\'m not accepting variant challenges right now.'**
  String get challengeDeclineStandard;

  /// No description provided for @challengeDeclineVariant.
  ///
  /// In en, this message translates to:
  /// **'I\'m not willing to play this variant right now.'**
  String get challengeDeclineVariant;

  /// No description provided for @challengeDeclineNoBot.
  ///
  /// In en, this message translates to:
  /// **'I\'m not accepting challenges from bots.'**
  String get challengeDeclineNoBot;

  /// No description provided for @challengeDeclineOnlyBot.
  ///
  /// In en, this message translates to:
  /// **'I\'m only accepting challenges from bots.'**
  String get challengeDeclineOnlyBot;

  /// No description provided for @challengeInviteLichessUser.
  ///
  /// In en, this message translates to:
  /// **'Or invite a Lichess user:'**
  String get challengeInviteLichessUser;

  /// No description provided for @contactContact.
  ///
  /// In en, this message translates to:
  /// **'Contact'**
  String get contactContact;

  /// No description provided for @contactContactLichess.
  ///
  /// In en, this message translates to:
  /// **'Contact Lichess'**
  String get contactContactLichess;

  /// No description provided for @patronDonate.
  ///
  /// In en, this message translates to:
  /// **'Donate'**
  String get patronDonate;

  /// No description provided for @patronLichessPatron.
  ///
  /// In en, this message translates to:
  /// **'Lichess Patron'**
  String get patronLichessPatron;

  /// No description provided for @perfStatPerfStats.
  ///
  /// In en, this message translates to:
  /// **'{param} stats'**
  String perfStatPerfStats(String param);

  /// No description provided for @perfStatViewTheGames.
  ///
  /// In en, this message translates to:
  /// **'View the games'**
  String get perfStatViewTheGames;

  /// No description provided for @perfStatProvisional.
  ///
  /// In en, this message translates to:
  /// **'provisional'**
  String get perfStatProvisional;

  /// No description provided for @perfStatNotEnoughRatedGames.
  ///
  /// In en, this message translates to:
  /// **'Not enough rated games have been played to establish a reliable rating.'**
  String get perfStatNotEnoughRatedGames;

  /// No description provided for @perfStatProgressOverLastXGames.
  ///
  /// In en, this message translates to:
  /// **'Progression over the last {param} games:'**
  String perfStatProgressOverLastXGames(String param);

  /// No description provided for @perfStatRatingDeviation.
  ///
  /// In en, this message translates to:
  /// **'Rating deviation: {param}.'**
  String perfStatRatingDeviation(String param);

  /// No description provided for @perfStatRatingDeviationTooltip.
  ///
  /// In en, this message translates to:
  /// **'Lower value means the rating is more stable. Above {param1}, the rating is considered provisional. To be included in the rankings, this value should be below {param2} (standard chess) or {param3} (variants).'**
  String perfStatRatingDeviationTooltip(String param1, String param2, String param3);

  /// No description provided for @perfStatTotalGames.
  ///
  /// In en, this message translates to:
  /// **'Total games'**
  String get perfStatTotalGames;

  /// No description provided for @perfStatRatedGames.
  ///
  /// In en, this message translates to:
  /// **'Rated games'**
  String get perfStatRatedGames;

  /// No description provided for @perfStatTournamentGames.
  ///
  /// In en, this message translates to:
  /// **'Tournament games'**
  String get perfStatTournamentGames;

  /// No description provided for @perfStatBerserkedGames.
  ///
  /// In en, this message translates to:
  /// **'Berserked games'**
  String get perfStatBerserkedGames;

  /// No description provided for @perfStatTimeSpentPlaying.
  ///
  /// In en, this message translates to:
  /// **'Time spent playing'**
  String get perfStatTimeSpentPlaying;

  /// No description provided for @perfStatAverageOpponent.
  ///
  /// In en, this message translates to:
  /// **'Average opponent'**
  String get perfStatAverageOpponent;

  /// No description provided for @perfStatVictories.
  ///
  /// In en, this message translates to:
  /// **'Victories'**
  String get perfStatVictories;

  /// No description provided for @perfStatDefeats.
  ///
  /// In en, this message translates to:
  /// **'Defeats'**
  String get perfStatDefeats;

  /// No description provided for @perfStatDisconnections.
  ///
  /// In en, this message translates to:
  /// **'Disconnections'**
  String get perfStatDisconnections;

  /// No description provided for @perfStatNotEnoughGames.
  ///
  /// In en, this message translates to:
  /// **'Not enough games played'**
  String get perfStatNotEnoughGames;

  /// No description provided for @perfStatHighestRating.
  ///
  /// In en, this message translates to:
  /// **'Highest rating: {param}'**
  String perfStatHighestRating(String param);

  /// No description provided for @perfStatLowestRating.
  ///
  /// In en, this message translates to:
  /// **'Lowest rating: {param}'**
  String perfStatLowestRating(String param);

  /// No description provided for @perfStatFromXToY.
  ///
  /// In en, this message translates to:
  /// **'from {param1} to {param2}'**
  String perfStatFromXToY(String param1, String param2);

  /// No description provided for @perfStatWinningStreak.
  ///
  /// In en, this message translates to:
  /// **'Winning streak'**
  String get perfStatWinningStreak;

  /// No description provided for @perfStatLosingStreak.
  ///
  /// In en, this message translates to:
  /// **'Losing streak'**
  String get perfStatLosingStreak;

  /// No description provided for @perfStatLongestStreak.
  ///
  /// In en, this message translates to:
  /// **'Longest streak: {param}'**
  String perfStatLongestStreak(String param);

  /// No description provided for @perfStatCurrentStreak.
  ///
  /// In en, this message translates to:
  /// **'Current streak: {param}'**
  String perfStatCurrentStreak(String param);

  /// No description provided for @perfStatBestRated.
  ///
  /// In en, this message translates to:
  /// **'Best rated victories'**
  String get perfStatBestRated;

  /// No description provided for @perfStatGamesInARow.
  ///
  /// In en, this message translates to:
  /// **'Games played in a row'**
  String get perfStatGamesInARow;

  /// No description provided for @perfStatLessThanOneHour.
  ///
  /// In en, this message translates to:
  /// **'Less than one hour between games'**
  String get perfStatLessThanOneHour;

  /// No description provided for @perfStatMaxTimePlaying.
  ///
  /// In en, this message translates to:
  /// **'Max time spent playing'**
  String get perfStatMaxTimePlaying;

  /// No description provided for @perfStatNow.
  ///
  /// In en, this message translates to:
  /// **'now'**
  String get perfStatNow;

  /// No description provided for @preferencesPreferences.
  ///
  /// In en, this message translates to:
  /// **'Preferences'**
  String get preferencesPreferences;

  /// No description provided for @preferencesDisplay.
  ///
  /// In en, this message translates to:
  /// **'Display'**
  String get preferencesDisplay;

  /// No description provided for @preferencesPrivacy.
  ///
  /// In en, this message translates to:
  /// **'Privacy'**
  String get preferencesPrivacy;

  /// No description provided for @preferencesNotifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get preferencesNotifications;

  /// No description provided for @preferencesPieceAnimation.
  ///
  /// In en, this message translates to:
  /// **'Piece animation'**
  String get preferencesPieceAnimation;

  /// No description provided for @preferencesMaterialDifference.
  ///
  /// In en, this message translates to:
  /// **'Material difference'**
  String get preferencesMaterialDifference;

  /// No description provided for @preferencesBoardHighlights.
  ///
  /// In en, this message translates to:
  /// **'Board highlights (last move and check)'**
  String get preferencesBoardHighlights;

  /// No description provided for @preferencesPieceDestinations.
  ///
  /// In en, this message translates to:
  /// **'Piece destinations (valid moves and premoves)'**
  String get preferencesPieceDestinations;

  /// No description provided for @preferencesBoardCoordinates.
  ///
  /// In en, this message translates to:
  /// **'Board coordinates (A-H, 1-8)'**
  String get preferencesBoardCoordinates;

  /// No description provided for @preferencesMoveListWhilePlaying.
  ///
  /// In en, this message translates to:
  /// **'Move list while playing'**
  String get preferencesMoveListWhilePlaying;

  /// No description provided for @preferencesPgnPieceNotation.
  ///
  /// In en, this message translates to:
  /// **'Move notation'**
  String get preferencesPgnPieceNotation;

  /// No description provided for @preferencesChessPieceSymbol.
  ///
  /// In en, this message translates to:
  /// **'Chess piece symbol'**
  String get preferencesChessPieceSymbol;

  /// No description provided for @preferencesPgnLetter.
  ///
  /// In en, this message translates to:
  /// **'Letter (K, Q, R, B, N)'**
  String get preferencesPgnLetter;

  /// No description provided for @preferencesZenMode.
  ///
  /// In en, this message translates to:
  /// **'Zen mode'**
  String get preferencesZenMode;

  /// No description provided for @preferencesShowPlayerRatings.
  ///
  /// In en, this message translates to:
  /// **'Show player ratings'**
  String get preferencesShowPlayerRatings;

  /// No description provided for @preferencesShowFlairs.
  ///
  /// In en, this message translates to:
  /// **'Show player flairs'**
  String get preferencesShowFlairs;

  /// No description provided for @preferencesExplainShowPlayerRatings.
  ///
  /// In en, this message translates to:
  /// **'This hides all ratings from Lichess, to help focus on the chess. Rated games still impact your rating, this is only about what you get to see.'**
  String get preferencesExplainShowPlayerRatings;

  /// No description provided for @preferencesDisplayBoardResizeHandle.
  ///
  /// In en, this message translates to:
  /// **'Show board resize handle'**
  String get preferencesDisplayBoardResizeHandle;

  /// No description provided for @preferencesOnlyOnInitialPosition.
  ///
  /// In en, this message translates to:
  /// **'Only on initial position'**
  String get preferencesOnlyOnInitialPosition;

  /// No description provided for @preferencesInGameOnly.
  ///
  /// In en, this message translates to:
  /// **'In-game only'**
  String get preferencesInGameOnly;

  /// No description provided for @preferencesExceptInGame.
  ///
  /// In en, this message translates to:
  /// **'Except in-game'**
  String get preferencesExceptInGame;

  /// No description provided for @preferencesChessClock.
  ///
  /// In en, this message translates to:
  /// **'Chess clock'**
  String get preferencesChessClock;

  /// No description provided for @preferencesTenthsOfSeconds.
  ///
  /// In en, this message translates to:
  /// **'Tenths of seconds'**
  String get preferencesTenthsOfSeconds;

  /// No description provided for @preferencesWhenTimeRemainingLessThanTenSeconds.
  ///
  /// In en, this message translates to:
  /// **'When time remaining < 10 seconds'**
  String get preferencesWhenTimeRemainingLessThanTenSeconds;

  /// No description provided for @preferencesHorizontalGreenProgressBars.
  ///
  /// In en, this message translates to:
  /// **'Horizontal green progress bars'**
  String get preferencesHorizontalGreenProgressBars;

  /// No description provided for @preferencesSoundWhenTimeGetsCritical.
  ///
  /// In en, this message translates to:
  /// **'Sound when time gets critical'**
  String get preferencesSoundWhenTimeGetsCritical;

  /// No description provided for @preferencesGiveMoreTime.
  ///
  /// In en, this message translates to:
  /// **'Give more time'**
  String get preferencesGiveMoreTime;

  /// No description provided for @preferencesGameBehavior.
  ///
  /// In en, this message translates to:
  /// **'Game behaviour'**
  String get preferencesGameBehavior;

  /// No description provided for @preferencesHowDoYouMovePieces.
  ///
  /// In en, this message translates to:
  /// **'How do you move pieces?'**
  String get preferencesHowDoYouMovePieces;

  /// No description provided for @preferencesClickTwoSquares.
  ///
  /// In en, this message translates to:
  /// **'Click two squares'**
  String get preferencesClickTwoSquares;

  /// No description provided for @preferencesDragPiece.
  ///
  /// In en, this message translates to:
  /// **'Drag a piece'**
  String get preferencesDragPiece;

  /// No description provided for @preferencesBothClicksAndDrag.
  ///
  /// In en, this message translates to:
  /// **'Either'**
  String get preferencesBothClicksAndDrag;

  /// No description provided for @preferencesPremovesPlayingDuringOpponentTurn.
  ///
  /// In en, this message translates to:
  /// **'Premoves (playing during opponent turn)'**
  String get preferencesPremovesPlayingDuringOpponentTurn;

  /// No description provided for @preferencesTakebacksWithOpponentApproval.
  ///
  /// In en, this message translates to:
  /// **'Takebacks (with opponent approval)'**
  String get preferencesTakebacksWithOpponentApproval;

  /// No description provided for @preferencesInCasualGamesOnly.
  ///
  /// In en, this message translates to:
  /// **'In casual games only'**
  String get preferencesInCasualGamesOnly;

  /// No description provided for @preferencesPromoteToQueenAutomatically.
  ///
  /// In en, this message translates to:
  /// **'Promote to Queen automatically'**
  String get preferencesPromoteToQueenAutomatically;

  /// No description provided for @preferencesExplainPromoteToQueenAutomatically.
  ///
  /// In en, this message translates to:
  /// **'Hold the <ctrl> key while promoting to temporarily disable auto-promotion'**
  String get preferencesExplainPromoteToQueenAutomatically;

  /// No description provided for @preferencesWhenPremoving.
  ///
  /// In en, this message translates to:
  /// **'When premoving'**
  String get preferencesWhenPremoving;

  /// No description provided for @preferencesClaimDrawOnThreefoldRepetitionAutomatically.
  ///
  /// In en, this message translates to:
  /// **'Claim draw on threefold repetition automatically'**
  String get preferencesClaimDrawOnThreefoldRepetitionAutomatically;

  /// No description provided for @preferencesWhenTimeRemainingLessThanThirtySeconds.
  ///
  /// In en, this message translates to:
  /// **'When time remaining < 30 seconds'**
  String get preferencesWhenTimeRemainingLessThanThirtySeconds;

  /// No description provided for @preferencesMoveConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Move confirmation'**
  String get preferencesMoveConfirmation;

  /// No description provided for @preferencesExplainCanThenBeTemporarilyDisabled.
  ///
  /// In en, this message translates to:
  /// **'Can be disabled during a game with the board menu'**
  String get preferencesExplainCanThenBeTemporarilyDisabled;

  /// No description provided for @preferencesInCorrespondenceGames.
  ///
  /// In en, this message translates to:
  /// **'Correspondence games'**
  String get preferencesInCorrespondenceGames;

  /// No description provided for @preferencesCorrespondenceAndUnlimited.
  ///
  /// In en, this message translates to:
  /// **'Correspondence and unlimited'**
  String get preferencesCorrespondenceAndUnlimited;

  /// No description provided for @preferencesConfirmResignationAndDrawOffers.
  ///
  /// In en, this message translates to:
  /// **'Confirm resignation and draw offers'**
  String get preferencesConfirmResignationAndDrawOffers;

  /// No description provided for @preferencesCastleByMovingTheKingTwoSquaresOrOntoTheRook.
  ///
  /// In en, this message translates to:
  /// **'Castling method'**
  String get preferencesCastleByMovingTheKingTwoSquaresOrOntoTheRook;

  /// No description provided for @preferencesCastleByMovingTwoSquares.
  ///
  /// In en, this message translates to:
  /// **'Move king two squares'**
  String get preferencesCastleByMovingTwoSquares;

  /// No description provided for @preferencesCastleByMovingOntoTheRook.
  ///
  /// In en, this message translates to:
  /// **'Move king onto rook'**
  String get preferencesCastleByMovingOntoTheRook;

  /// No description provided for @preferencesInputMovesWithTheKeyboard.
  ///
  /// In en, this message translates to:
  /// **'Input moves with the keyboard'**
  String get preferencesInputMovesWithTheKeyboard;

  /// No description provided for @preferencesInputMovesWithVoice.
  ///
  /// In en, this message translates to:
  /// **'Input moves with your voice'**
  String get preferencesInputMovesWithVoice;

  /// No description provided for @preferencesSnapArrowsToValidMoves.
  ///
  /// In en, this message translates to:
  /// **'Snap arrows to valid moves'**
  String get preferencesSnapArrowsToValidMoves;

  /// No description provided for @preferencesSayGgWpAfterLosingOrDrawing.
  ///
  /// In en, this message translates to:
  /// **'Say \"Good game, well played\" upon defeat or draw'**
  String get preferencesSayGgWpAfterLosingOrDrawing;

  /// No description provided for @preferencesYourPreferencesHaveBeenSaved.
  ///
  /// In en, this message translates to:
  /// **'Your preferences have been saved.'**
  String get preferencesYourPreferencesHaveBeenSaved;

  /// No description provided for @preferencesScrollOnTheBoardToReplayMoves.
  ///
  /// In en, this message translates to:
  /// **'Scroll on the board to replay moves'**
  String get preferencesScrollOnTheBoardToReplayMoves;

  /// No description provided for @preferencesCorrespondenceEmailNotification.
  ///
  /// In en, this message translates to:
  /// **'Daily email listing your correspondence games'**
  String get preferencesCorrespondenceEmailNotification;

  /// No description provided for @preferencesNotifyStreamStart.
  ///
  /// In en, this message translates to:
  /// **'Streamer goes live'**
  String get preferencesNotifyStreamStart;

  /// No description provided for @preferencesNotifyInboxMsg.
  ///
  /// In en, this message translates to:
  /// **'New inbox message'**
  String get preferencesNotifyInboxMsg;

  /// No description provided for @preferencesNotifyForumMention.
  ///
  /// In en, this message translates to:
  /// **'Forum comment mentions you'**
  String get preferencesNotifyForumMention;

  /// No description provided for @preferencesNotifyInvitedStudy.
  ///
  /// In en, this message translates to:
  /// **'Study invite'**
  String get preferencesNotifyInvitedStudy;

  /// No description provided for @preferencesNotifyGameEvent.
  ///
  /// In en, this message translates to:
  /// **'Correspondence game updates'**
  String get preferencesNotifyGameEvent;

  /// No description provided for @preferencesNotifyChallenge.
  ///
  /// In en, this message translates to:
  /// **'Challenges'**
  String get preferencesNotifyChallenge;

  /// No description provided for @preferencesNotifyTournamentSoon.
  ///
  /// In en, this message translates to:
  /// **'Tournament starting soon'**
  String get preferencesNotifyTournamentSoon;

  /// No description provided for @preferencesNotifyTimeAlarm.
  ///
  /// In en, this message translates to:
  /// **'Correspondence clock running out'**
  String get preferencesNotifyTimeAlarm;

  /// No description provided for @preferencesNotifyBell.
  ///
  /// In en, this message translates to:
  /// **'Bell notification within Lichess'**
  String get preferencesNotifyBell;

  /// No description provided for @preferencesNotifyPush.
  ///
  /// In en, this message translates to:
  /// **'Device notification when you\'re not on Lichess'**
  String get preferencesNotifyPush;

  /// No description provided for @preferencesNotifyWeb.
  ///
  /// In en, this message translates to:
  /// **'Browser'**
  String get preferencesNotifyWeb;

  /// No description provided for @preferencesNotifyDevice.
  ///
  /// In en, this message translates to:
  /// **'Device'**
  String get preferencesNotifyDevice;

  /// No description provided for @preferencesBellNotificationSound.
  ///
  /// In en, this message translates to:
  /// **'Bell notification sound'**
  String get preferencesBellNotificationSound;

  /// No description provided for @preferencesBlindfold.
  ///
  /// In en, this message translates to:
  /// **'Blindfold'**
  String get preferencesBlindfold;

  /// No description provided for @puzzlePuzzles.
  ///
  /// In en, this message translates to:
  /// **'Puzzles'**
  String get puzzlePuzzles;

  /// No description provided for @puzzlePuzzleThemes.
  ///
  /// In en, this message translates to:
  /// **'Puzzle Themes'**
  String get puzzlePuzzleThemes;

  /// No description provided for @puzzleRecommended.
  ///
  /// In en, this message translates to:
  /// **'Recommended'**
  String get puzzleRecommended;

  /// No description provided for @puzzlePhases.
  ///
  /// In en, this message translates to:
  /// **'Phases'**
  String get puzzlePhases;

  /// No description provided for @puzzleMotifs.
  ///
  /// In en, this message translates to:
  /// **'Motifs'**
  String get puzzleMotifs;

  /// No description provided for @puzzleAdvanced.
  ///
  /// In en, this message translates to:
  /// **'Advanced'**
  String get puzzleAdvanced;

  /// No description provided for @puzzleLengths.
  ///
  /// In en, this message translates to:
  /// **'Lengths'**
  String get puzzleLengths;

  /// No description provided for @puzzleMates.
  ///
  /// In en, this message translates to:
  /// **'Mates'**
  String get puzzleMates;

  /// No description provided for @puzzleGoals.
  ///
  /// In en, this message translates to:
  /// **'Goals'**
  String get puzzleGoals;

  /// No description provided for @puzzleOrigin.
  ///
  /// In en, this message translates to:
  /// **'Origin'**
  String get puzzleOrigin;

  /// No description provided for @puzzleSpecialMoves.
  ///
  /// In en, this message translates to:
  /// **'Special moves'**
  String get puzzleSpecialMoves;

  /// No description provided for @puzzleDidYouLikeThisPuzzle.
  ///
  /// In en, this message translates to:
  /// **'Did you like this puzzle?'**
  String get puzzleDidYouLikeThisPuzzle;

  /// No description provided for @puzzleVoteToLoadNextOne.
  ///
  /// In en, this message translates to:
  /// **'Vote to load the next one!'**
  String get puzzleVoteToLoadNextOne;

  /// No description provided for @puzzleUpVote.
  ///
  /// In en, this message translates to:
  /// **'Up vote puzzle'**
  String get puzzleUpVote;

  /// No description provided for @puzzleDownVote.
  ///
  /// In en, this message translates to:
  /// **'Down vote puzzle'**
  String get puzzleDownVote;

  /// No description provided for @puzzleYourPuzzleRatingWillNotChange.
  ///
  /// In en, this message translates to:
  /// **'Your puzzle rating will not change. Note that puzzles are not a competition. Your rating helps selecting the best puzzles for your current skill.'**
  String get puzzleYourPuzzleRatingWillNotChange;

  /// No description provided for @puzzleFindTheBestMoveForWhite.
  ///
  /// In en, this message translates to:
  /// **'Find the best move for white.'**
  String get puzzleFindTheBestMoveForWhite;

  /// No description provided for @puzzleFindTheBestMoveForBlack.
  ///
  /// In en, this message translates to:
  /// **'Find the best move for black.'**
  String get puzzleFindTheBestMoveForBlack;

  /// No description provided for @puzzleToGetPersonalizedPuzzles.
  ///
  /// In en, this message translates to:
  /// **'To get personalized puzzles:'**
  String get puzzleToGetPersonalizedPuzzles;

  /// No description provided for @puzzlePuzzleId.
  ///
  /// In en, this message translates to:
  /// **'Puzzle {param}'**
  String puzzlePuzzleId(String param);

  /// No description provided for @puzzlePuzzleOfTheDay.
  ///
  /// In en, this message translates to:
  /// **'Puzzle of the day'**
  String get puzzlePuzzleOfTheDay;

  /// No description provided for @puzzleDailyPuzzle.
  ///
  /// In en, this message translates to:
  /// **'Daily Puzzle'**
  String get puzzleDailyPuzzle;

  /// No description provided for @puzzleClickToSolve.
  ///
  /// In en, this message translates to:
  /// **'Click to solve'**
  String get puzzleClickToSolve;

  /// No description provided for @puzzleGoodMove.
  ///
  /// In en, this message translates to:
  /// **'Good move'**
  String get puzzleGoodMove;

  /// No description provided for @puzzleBestMove.
  ///
  /// In en, this message translates to:
  /// **'Best move!'**
  String get puzzleBestMove;

  /// No description provided for @puzzleKeepGoing.
  ///
  /// In en, this message translates to:
  /// **'Keep going…'**
  String get puzzleKeepGoing;

  /// No description provided for @puzzlePuzzleSuccess.
  ///
  /// In en, this message translates to:
  /// **'Success!'**
  String get puzzlePuzzleSuccess;

  /// No description provided for @puzzlePuzzleComplete.
  ///
  /// In en, this message translates to:
  /// **'Puzzle complete!'**
  String get puzzlePuzzleComplete;

  /// No description provided for @puzzleByOpenings.
  ///
  /// In en, this message translates to:
  /// **'By openings'**
  String get puzzleByOpenings;

  /// No description provided for @puzzlePuzzlesByOpenings.
  ///
  /// In en, this message translates to:
  /// **'Puzzles by openings'**
  String get puzzlePuzzlesByOpenings;

  /// No description provided for @puzzleOpeningsYouPlayedTheMost.
  ///
  /// In en, this message translates to:
  /// **'Openings you played the most in rated games'**
  String get puzzleOpeningsYouPlayedTheMost;

  /// No description provided for @puzzleUseFindInPage.
  ///
  /// In en, this message translates to:
  /// **'Use \"Find in page\" in the browser menu to find your favourite opening!'**
  String get puzzleUseFindInPage;

  /// No description provided for @puzzleUseCtrlF.
  ///
  /// In en, this message translates to:
  /// **'Use Ctrl+f to find your favourite opening!'**
  String get puzzleUseCtrlF;

  /// No description provided for @puzzleNotTheMove.
  ///
  /// In en, this message translates to:
  /// **'That\'s not the move!'**
  String get puzzleNotTheMove;

  /// No description provided for @puzzleTrySomethingElse.
  ///
  /// In en, this message translates to:
  /// **'Try something else.'**
  String get puzzleTrySomethingElse;

  /// No description provided for @puzzleRatingX.
  ///
  /// In en, this message translates to:
  /// **'Rating: {param}'**
  String puzzleRatingX(String param);

  /// No description provided for @puzzleHidden.
  ///
  /// In en, this message translates to:
  /// **'hidden'**
  String get puzzleHidden;

  /// No description provided for @puzzleFromGameLink.
  ///
  /// In en, this message translates to:
  /// **'From game {param}'**
  String puzzleFromGameLink(String param);

  /// No description provided for @puzzleContinueTraining.
  ///
  /// In en, this message translates to:
  /// **'Continue training'**
  String get puzzleContinueTraining;

  /// No description provided for @puzzleDifficultyLevel.
  ///
  /// In en, this message translates to:
  /// **'Difficulty level'**
  String get puzzleDifficultyLevel;

  /// No description provided for @puzzleNormal.
  ///
  /// In en, this message translates to:
  /// **'Normal'**
  String get puzzleNormal;

  /// No description provided for @puzzleEasier.
  ///
  /// In en, this message translates to:
  /// **'Easier'**
  String get puzzleEasier;

  /// No description provided for @puzzleEasiest.
  ///
  /// In en, this message translates to:
  /// **'Easiest'**
  String get puzzleEasiest;

  /// No description provided for @puzzleHarder.
  ///
  /// In en, this message translates to:
  /// **'Harder'**
  String get puzzleHarder;

  /// No description provided for @puzzleHardest.
  ///
  /// In en, this message translates to:
  /// **'Hardest'**
  String get puzzleHardest;

  /// No description provided for @puzzleExample.
  ///
  /// In en, this message translates to:
  /// **'Example'**
  String get puzzleExample;

  /// No description provided for @puzzleAddAnotherTheme.
  ///
  /// In en, this message translates to:
  /// **'Add another theme'**
  String get puzzleAddAnotherTheme;

  /// No description provided for @puzzleNextPuzzle.
  ///
  /// In en, this message translates to:
  /// **'Next puzzle'**
  String get puzzleNextPuzzle;

  /// No description provided for @puzzleJumpToNextPuzzleImmediately.
  ///
  /// In en, this message translates to:
  /// **'Jump to next puzzle immediately'**
  String get puzzleJumpToNextPuzzleImmediately;

  /// No description provided for @puzzlePuzzleDashboard.
  ///
  /// In en, this message translates to:
  /// **'Puzzle Dashboard'**
  String get puzzlePuzzleDashboard;

  /// No description provided for @puzzleImprovementAreas.
  ///
  /// In en, this message translates to:
  /// **'Improvement areas'**
  String get puzzleImprovementAreas;

  /// No description provided for @puzzleStrengths.
  ///
  /// In en, this message translates to:
  /// **'Strengths'**
  String get puzzleStrengths;

  /// No description provided for @puzzleHistory.
  ///
  /// In en, this message translates to:
  /// **'Puzzle history'**
  String get puzzleHistory;

  /// No description provided for @puzzleSolved.
  ///
  /// In en, this message translates to:
  /// **'solved'**
  String get puzzleSolved;

  /// No description provided for @puzzleFailed.
  ///
  /// In en, this message translates to:
  /// **'incorrect'**
  String get puzzleFailed;

  /// No description provided for @puzzleStreakDescription.
  ///
  /// In en, this message translates to:
  /// **'Solve progressively harder puzzles and build a win streak. There is no clock, so take your time. One wrong move, and it\'s game over! But you can skip one move per session.'**
  String get puzzleStreakDescription;

  /// No description provided for @puzzleYourStreakX.
  ///
  /// In en, this message translates to:
  /// **'Your streak: {param}'**
  String puzzleYourStreakX(String param);

  /// No description provided for @puzzleStreakSkipExplanation.
  ///
  /// In en, this message translates to:
  /// **'Skip this move to preserve your streak! Only works once per run.'**
  String get puzzleStreakSkipExplanation;

  /// No description provided for @puzzleContinueTheStreak.
  ///
  /// In en, this message translates to:
  /// **'Continue the streak'**
  String get puzzleContinueTheStreak;

  /// No description provided for @puzzleNewStreak.
  ///
  /// In en, this message translates to:
  /// **'New streak'**
  String get puzzleNewStreak;

  /// No description provided for @puzzleFromMyGames.
  ///
  /// In en, this message translates to:
  /// **'From my games'**
  String get puzzleFromMyGames;

  /// No description provided for @puzzleLookupOfPlayer.
  ///
  /// In en, this message translates to:
  /// **'Lookup puzzles from a player\'s games'**
  String get puzzleLookupOfPlayer;

  /// No description provided for @puzzleFromXGames.
  ///
  /// In en, this message translates to:
  /// **'Puzzles from {param}\' games'**
  String puzzleFromXGames(String param);

  /// No description provided for @puzzleSearchPuzzles.
  ///
  /// In en, this message translates to:
  /// **'Search puzzles'**
  String get puzzleSearchPuzzles;

  /// No description provided for @puzzleFromMyGamesNone.
  ///
  /// In en, this message translates to:
  /// **'You have no puzzles in the database, but Lichess still loves you very much.\n\nPlay rapid and classical games to increase your chances of having a puzzle of yours added!'**
  String get puzzleFromMyGamesNone;

  /// No description provided for @puzzleFromXGamesFound.
  ///
  /// In en, this message translates to:
  /// **'{param1} puzzles found in {param2} games'**
  String puzzleFromXGamesFound(String param1, String param2);

  /// No description provided for @puzzlePuzzleDashboardDescription.
  ///
  /// In en, this message translates to:
  /// **'Train, analyse, improve'**
  String get puzzlePuzzleDashboardDescription;

  /// No description provided for @puzzlePercentSolved.
  ///
  /// In en, this message translates to:
  /// **'{param} solved'**
  String puzzlePercentSolved(String param);

  /// No description provided for @puzzleNoPuzzlesToShow.
  ///
  /// In en, this message translates to:
  /// **'Nothing to show, go play some puzzles first!'**
  String get puzzleNoPuzzlesToShow;

  /// No description provided for @puzzleImprovementAreasDescription.
  ///
  /// In en, this message translates to:
  /// **'Train these to optimize your progress!'**
  String get puzzleImprovementAreasDescription;

  /// No description provided for @puzzleStrengthDescription.
  ///
  /// In en, this message translates to:
  /// **'You perform the best in these themes'**
  String get puzzleStrengthDescription;

  /// No description provided for @puzzlePlayedXTimes.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Played {count} time} other{Played {count} times}}'**
  String puzzlePlayedXTimes(int count);

  /// No description provided for @puzzleNbPointsBelowYourPuzzleRating.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{One point below your puzzle rating} other{{count} points below your puzzle rating}}'**
  String puzzleNbPointsBelowYourPuzzleRating(int count);

  /// No description provided for @puzzleNbPointsAboveYourPuzzleRating.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{One point above your puzzle rating} other{{count} points above your puzzle rating}}'**
  String puzzleNbPointsAboveYourPuzzleRating(int count);

  /// No description provided for @puzzleNbPlayed.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, other{{count} played}}'**
  String puzzleNbPlayed(int count);

  /// No description provided for @puzzleNbToReplay.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, other{{count} to replay}}'**
  String puzzleNbToReplay(int count);

  /// No description provided for @puzzleThemeAdvancedPawn.
  ///
  /// In en, this message translates to:
  /// **'Advanced pawn'**
  String get puzzleThemeAdvancedPawn;

  /// No description provided for @puzzleThemeAdvancedPawnDescription.
  ///
  /// In en, this message translates to:
  /// **'One of your pawns is deep into the opponent position, maybe threatening to promote.'**
  String get puzzleThemeAdvancedPawnDescription;

  /// No description provided for @puzzleThemeAdvantage.
  ///
  /// In en, this message translates to:
  /// **'Advantage'**
  String get puzzleThemeAdvantage;

  /// No description provided for @puzzleThemeAdvantageDescription.
  ///
  /// In en, this message translates to:
  /// **'Seize your chance to get a decisive advantage. (200cp ≤ eval ≤ 600cp)'**
  String get puzzleThemeAdvantageDescription;

  /// No description provided for @puzzleThemeAnastasiaMate.
  ///
  /// In en, this message translates to:
  /// **'Anastasia\'s mate'**
  String get puzzleThemeAnastasiaMate;

  /// No description provided for @puzzleThemeAnastasiaMateDescription.
  ///
  /// In en, this message translates to:
  /// **'A knight and rook or queen team up to trap the opposing king between the side of the board and a friendly piece.'**
  String get puzzleThemeAnastasiaMateDescription;

  /// No description provided for @puzzleThemeArabianMate.
  ///
  /// In en, this message translates to:
  /// **'Arabian mate'**
  String get puzzleThemeArabianMate;

  /// No description provided for @puzzleThemeArabianMateDescription.
  ///
  /// In en, this message translates to:
  /// **'A knight and a rook team up to trap the opposing king on a corner of the board.'**
  String get puzzleThemeArabianMateDescription;

  /// No description provided for @puzzleThemeAttackingF2F7.
  ///
  /// In en, this message translates to:
  /// **'Attacking f2 or f7'**
  String get puzzleThemeAttackingF2F7;

  /// No description provided for @puzzleThemeAttackingF2F7Description.
  ///
  /// In en, this message translates to:
  /// **'An attack focusing on the f2 or f7 pawn, such as in the fried liver opening.'**
  String get puzzleThemeAttackingF2F7Description;

  /// No description provided for @puzzleThemeAttraction.
  ///
  /// In en, this message translates to:
  /// **'Attraction'**
  String get puzzleThemeAttraction;

  /// No description provided for @puzzleThemeAttractionDescription.
  ///
  /// In en, this message translates to:
  /// **'An exchange or sacrifice encouraging or forcing an opponent piece to a square that allows a follow-up tactic.'**
  String get puzzleThemeAttractionDescription;

  /// No description provided for @puzzleThemeBackRankMate.
  ///
  /// In en, this message translates to:
  /// **'Back rank mate'**
  String get puzzleThemeBackRankMate;

  /// No description provided for @puzzleThemeBackRankMateDescription.
  ///
  /// In en, this message translates to:
  /// **'Checkmate the king on the home rank, when it is trapped there by its own pieces.'**
  String get puzzleThemeBackRankMateDescription;

  /// No description provided for @puzzleThemeBishopEndgame.
  ///
  /// In en, this message translates to:
  /// **'Bishop endgame'**
  String get puzzleThemeBishopEndgame;

  /// No description provided for @puzzleThemeBishopEndgameDescription.
  ///
  /// In en, this message translates to:
  /// **'An endgame with only bishops and pawns.'**
  String get puzzleThemeBishopEndgameDescription;

  /// No description provided for @puzzleThemeBodenMate.
  ///
  /// In en, this message translates to:
  /// **'Boden\'s mate'**
  String get puzzleThemeBodenMate;

  /// No description provided for @puzzleThemeBodenMateDescription.
  ///
  /// In en, this message translates to:
  /// **'Two attacking bishops on criss-crossing diagonals deliver mate to a king obstructed by friendly pieces.'**
  String get puzzleThemeBodenMateDescription;

  /// No description provided for @puzzleThemeCastling.
  ///
  /// In en, this message translates to:
  /// **'Castling'**
  String get puzzleThemeCastling;

  /// No description provided for @puzzleThemeCastlingDescription.
  ///
  /// In en, this message translates to:
  /// **'Bring the king to safety, and deploy the rook for attack.'**
  String get puzzleThemeCastlingDescription;

  /// No description provided for @puzzleThemeCapturingDefender.
  ///
  /// In en, this message translates to:
  /// **'Capture the defender'**
  String get puzzleThemeCapturingDefender;

  /// No description provided for @puzzleThemeCapturingDefenderDescription.
  ///
  /// In en, this message translates to:
  /// **'Removing a piece that is critical to defence of another piece, allowing the now undefended piece to be captured on a following move.'**
  String get puzzleThemeCapturingDefenderDescription;

  /// No description provided for @puzzleThemeCrushing.
  ///
  /// In en, this message translates to:
  /// **'Crushing'**
  String get puzzleThemeCrushing;

  /// No description provided for @puzzleThemeCrushingDescription.
  ///
  /// In en, this message translates to:
  /// **'Spot the opponent blunder to obtain a crushing advantage. (eval ≥ 600cp)'**
  String get puzzleThemeCrushingDescription;

  /// No description provided for @puzzleThemeDoubleBishopMate.
  ///
  /// In en, this message translates to:
  /// **'Double bishop mate'**
  String get puzzleThemeDoubleBishopMate;

  /// No description provided for @puzzleThemeDoubleBishopMateDescription.
  ///
  /// In en, this message translates to:
  /// **'Two attacking bishops on adjacent diagonals deliver mate to a king obstructed by friendly pieces.'**
  String get puzzleThemeDoubleBishopMateDescription;

  /// No description provided for @puzzleThemeDovetailMate.
  ///
  /// In en, this message translates to:
  /// **'Dovetail mate'**
  String get puzzleThemeDovetailMate;

  /// No description provided for @puzzleThemeDovetailMateDescription.
  ///
  /// In en, this message translates to:
  /// **'A queen delivers mate to an adjacent king, whose only two escape squares are obstructed by friendly pieces.'**
  String get puzzleThemeDovetailMateDescription;

  /// No description provided for @puzzleThemeEquality.
  ///
  /// In en, this message translates to:
  /// **'Equality'**
  String get puzzleThemeEquality;

  /// No description provided for @puzzleThemeEqualityDescription.
  ///
  /// In en, this message translates to:
  /// **'Come back from a losing position, and secure a draw or a balanced position. (eval ≤ 200cp)'**
  String get puzzleThemeEqualityDescription;

  /// No description provided for @puzzleThemeKingsideAttack.
  ///
  /// In en, this message translates to:
  /// **'Kingside attack'**
  String get puzzleThemeKingsideAttack;

  /// No description provided for @puzzleThemeKingsideAttackDescription.
  ///
  /// In en, this message translates to:
  /// **'An attack of the opponent\'s king, after they castled on the king side.'**
  String get puzzleThemeKingsideAttackDescription;

  /// No description provided for @puzzleThemeClearance.
  ///
  /// In en, this message translates to:
  /// **'Clearance'**
  String get puzzleThemeClearance;

  /// No description provided for @puzzleThemeClearanceDescription.
  ///
  /// In en, this message translates to:
  /// **'A move, often with tempo, that clears a square, file or diagonal for a follow-up tactical idea.'**
  String get puzzleThemeClearanceDescription;

  /// No description provided for @puzzleThemeDefensiveMove.
  ///
  /// In en, this message translates to:
  /// **'Defensive move'**
  String get puzzleThemeDefensiveMove;

  /// No description provided for @puzzleThemeDefensiveMoveDescription.
  ///
  /// In en, this message translates to:
  /// **'A precise move or sequence of moves that is needed to avoid losing material or another advantage.'**
  String get puzzleThemeDefensiveMoveDescription;

  /// No description provided for @puzzleThemeDeflection.
  ///
  /// In en, this message translates to:
  /// **'Deflection'**
  String get puzzleThemeDeflection;

  /// No description provided for @puzzleThemeDeflectionDescription.
  ///
  /// In en, this message translates to:
  /// **'A move that distracts an opponent piece from another duty that it performs, such as guarding a key square. Sometimes also called \"overloading\".'**
  String get puzzleThemeDeflectionDescription;

  /// No description provided for @puzzleThemeDiscoveredAttack.
  ///
  /// In en, this message translates to:
  /// **'Discovered attack'**
  String get puzzleThemeDiscoveredAttack;

  /// No description provided for @puzzleThemeDiscoveredAttackDescription.
  ///
  /// In en, this message translates to:
  /// **'Moving a piece (such as a knight), that previously blocked an attack by a long range piece (such as a rook), out of the way of that piece.'**
  String get puzzleThemeDiscoveredAttackDescription;

  /// No description provided for @puzzleThemeDoubleCheck.
  ///
  /// In en, this message translates to:
  /// **'Double check'**
  String get puzzleThemeDoubleCheck;

  /// No description provided for @puzzleThemeDoubleCheckDescription.
  ///
  /// In en, this message translates to:
  /// **'Checking with two pieces at once, as a result of a discovered attack where both the moving piece and the unveiled piece attack the opponent\'s king.'**
  String get puzzleThemeDoubleCheckDescription;

  /// No description provided for @puzzleThemeEndgame.
  ///
  /// In en, this message translates to:
  /// **'Endgame'**
  String get puzzleThemeEndgame;

  /// No description provided for @puzzleThemeEndgameDescription.
  ///
  /// In en, this message translates to:
  /// **'A tactic during the last phase of the game.'**
  String get puzzleThemeEndgameDescription;

  /// No description provided for @puzzleThemeEnPassantDescription.
  ///
  /// In en, this message translates to:
  /// **'A tactic involving the en passant rule, where a pawn can capture an opponent pawn that has bypassed it using its initial two-square move.'**
  String get puzzleThemeEnPassantDescription;

  /// No description provided for @puzzleThemeExposedKing.
  ///
  /// In en, this message translates to:
  /// **'Exposed king'**
  String get puzzleThemeExposedKing;

  /// No description provided for @puzzleThemeExposedKingDescription.
  ///
  /// In en, this message translates to:
  /// **'A tactic involving a king with few defenders around it, often leading to checkmate.'**
  String get puzzleThemeExposedKingDescription;

  /// No description provided for @puzzleThemeFork.
  ///
  /// In en, this message translates to:
  /// **'Fork'**
  String get puzzleThemeFork;

  /// No description provided for @puzzleThemeForkDescription.
  ///
  /// In en, this message translates to:
  /// **'A move where the moved piece attacks two opponent pieces at once.'**
  String get puzzleThemeForkDescription;

  /// No description provided for @puzzleThemeHangingPiece.
  ///
  /// In en, this message translates to:
  /// **'Hanging piece'**
  String get puzzleThemeHangingPiece;

  /// No description provided for @puzzleThemeHangingPieceDescription.
  ///
  /// In en, this message translates to:
  /// **'A tactic involving an opponent piece being undefended or insufficiently defended and free to capture.'**
  String get puzzleThemeHangingPieceDescription;

  /// No description provided for @puzzleThemeHookMate.
  ///
  /// In en, this message translates to:
  /// **'Hook mate'**
  String get puzzleThemeHookMate;

  /// No description provided for @puzzleThemeHookMateDescription.
  ///
  /// In en, this message translates to:
  /// **'Checkmate with a rook, knight, and pawn along with one enemy pawn to limit the enemy king\'s escape.'**
  String get puzzleThemeHookMateDescription;

  /// No description provided for @puzzleThemeInterference.
  ///
  /// In en, this message translates to:
  /// **'Interference'**
  String get puzzleThemeInterference;

  /// No description provided for @puzzleThemeInterferenceDescription.
  ///
  /// In en, this message translates to:
  /// **'Moving a piece between two opponent pieces to leave one or both opponent pieces undefended, such as a knight on a defended square between two rooks.'**
  String get puzzleThemeInterferenceDescription;

  /// No description provided for @puzzleThemeIntermezzo.
  ///
  /// In en, this message translates to:
  /// **'Intermezzo'**
  String get puzzleThemeIntermezzo;

  /// No description provided for @puzzleThemeIntermezzoDescription.
  ///
  /// In en, this message translates to:
  /// **'Instead of playing the expected move, first interpose another move posing an immediate threat that the opponent must answer. Also known as \"Zwischenzug\" or \"In between\".'**
  String get puzzleThemeIntermezzoDescription;

  /// No description provided for @puzzleThemeKillBoxMate.
  ///
  /// In en, this message translates to:
  /// **'Kill box mate'**
  String get puzzleThemeKillBoxMate;

  /// No description provided for @puzzleThemeKillBoxMateDescription.
  ///
  /// In en, this message translates to:
  /// **'A rook is next to the enemy king and supported by a queen that also blocks the king\'s escape squares. The rook and the queen catch the enemy king in a 3 by 3 \"kill box\".'**
  String get puzzleThemeKillBoxMateDescription;

  /// No description provided for @puzzleThemeVukovicMate.
  ///
  /// In en, this message translates to:
  /// **'Vukovic mate'**
  String get puzzleThemeVukovicMate;

  /// No description provided for @puzzleThemeVukovicMateDescription.
  ///
  /// In en, this message translates to:
  /// **'A rook and knight team up to mate the king. The rook delivers mate while supported by a third piece, and the knight is used to block the king\'s escape squares.'**
  String get puzzleThemeVukovicMateDescription;

  /// No description provided for @puzzleThemeKnightEndgame.
  ///
  /// In en, this message translates to:
  /// **'Knight endgame'**
  String get puzzleThemeKnightEndgame;

  /// No description provided for @puzzleThemeKnightEndgameDescription.
  ///
  /// In en, this message translates to:
  /// **'An endgame with only knights and pawns.'**
  String get puzzleThemeKnightEndgameDescription;

  /// No description provided for @puzzleThemeLong.
  ///
  /// In en, this message translates to:
  /// **'Long puzzle'**
  String get puzzleThemeLong;

  /// No description provided for @puzzleThemeLongDescription.
  ///
  /// In en, this message translates to:
  /// **'Three moves to win.'**
  String get puzzleThemeLongDescription;

  /// No description provided for @puzzleThemeMaster.
  ///
  /// In en, this message translates to:
  /// **'Master games'**
  String get puzzleThemeMaster;

  /// No description provided for @puzzleThemeMasterDescription.
  ///
  /// In en, this message translates to:
  /// **'Puzzles from games played by titled players.'**
  String get puzzleThemeMasterDescription;

  /// No description provided for @puzzleThemeMasterVsMaster.
  ///
  /// In en, this message translates to:
  /// **'Master vs Master games'**
  String get puzzleThemeMasterVsMaster;

  /// No description provided for @puzzleThemeMasterVsMasterDescription.
  ///
  /// In en, this message translates to:
  /// **'Puzzles from games between two titled players.'**
  String get puzzleThemeMasterVsMasterDescription;

  /// No description provided for @puzzleThemeMate.
  ///
  /// In en, this message translates to:
  /// **'Checkmate'**
  String get puzzleThemeMate;

  /// No description provided for @puzzleThemeMateDescription.
  ///
  /// In en, this message translates to:
  /// **'Win the game with style.'**
  String get puzzleThemeMateDescription;

  /// No description provided for @puzzleThemeMateIn1.
  ///
  /// In en, this message translates to:
  /// **'Mate in 1'**
  String get puzzleThemeMateIn1;

  /// No description provided for @puzzleThemeMateIn1Description.
  ///
  /// In en, this message translates to:
  /// **'Deliver checkmate in one move.'**
  String get puzzleThemeMateIn1Description;

  /// No description provided for @puzzleThemeMateIn2.
  ///
  /// In en, this message translates to:
  /// **'Mate in 2'**
  String get puzzleThemeMateIn2;

  /// No description provided for @puzzleThemeMateIn2Description.
  ///
  /// In en, this message translates to:
  /// **'Deliver checkmate in two moves.'**
  String get puzzleThemeMateIn2Description;

  /// No description provided for @puzzleThemeMateIn3.
  ///
  /// In en, this message translates to:
  /// **'Mate in 3'**
  String get puzzleThemeMateIn3;

  /// No description provided for @puzzleThemeMateIn3Description.
  ///
  /// In en, this message translates to:
  /// **'Deliver checkmate in three moves.'**
  String get puzzleThemeMateIn3Description;

  /// No description provided for @puzzleThemeMateIn4.
  ///
  /// In en, this message translates to:
  /// **'Mate in 4'**
  String get puzzleThemeMateIn4;

  /// No description provided for @puzzleThemeMateIn4Description.
  ///
  /// In en, this message translates to:
  /// **'Deliver checkmate in four moves.'**
  String get puzzleThemeMateIn4Description;

  /// No description provided for @puzzleThemeMateIn5.
  ///
  /// In en, this message translates to:
  /// **'Mate in 5 or more'**
  String get puzzleThemeMateIn5;

  /// No description provided for @puzzleThemeMateIn5Description.
  ///
  /// In en, this message translates to:
  /// **'Figure out a long mating sequence.'**
  String get puzzleThemeMateIn5Description;

  /// No description provided for @puzzleThemeMiddlegame.
  ///
  /// In en, this message translates to:
  /// **'Middlegame'**
  String get puzzleThemeMiddlegame;

  /// No description provided for @puzzleThemeMiddlegameDescription.
  ///
  /// In en, this message translates to:
  /// **'A tactic during the second phase of the game.'**
  String get puzzleThemeMiddlegameDescription;

  /// No description provided for @puzzleThemeOneMove.
  ///
  /// In en, this message translates to:
  /// **'One-move puzzle'**
  String get puzzleThemeOneMove;

  /// No description provided for @puzzleThemeOneMoveDescription.
  ///
  /// In en, this message translates to:
  /// **'A puzzle that is only one move long.'**
  String get puzzleThemeOneMoveDescription;

  /// No description provided for @puzzleThemeOpening.
  ///
  /// In en, this message translates to:
  /// **'Opening'**
  String get puzzleThemeOpening;

  /// No description provided for @puzzleThemeOpeningDescription.
  ///
  /// In en, this message translates to:
  /// **'A tactic during the first phase of the game.'**
  String get puzzleThemeOpeningDescription;

  /// No description provided for @puzzleThemePawnEndgame.
  ///
  /// In en, this message translates to:
  /// **'Pawn endgame'**
  String get puzzleThemePawnEndgame;

  /// No description provided for @puzzleThemePawnEndgameDescription.
  ///
  /// In en, this message translates to:
  /// **'An endgame with only pawns.'**
  String get puzzleThemePawnEndgameDescription;

  /// No description provided for @puzzleThemePin.
  ///
  /// In en, this message translates to:
  /// **'Pin'**
  String get puzzleThemePin;

  /// No description provided for @puzzleThemePinDescription.
  ///
  /// In en, this message translates to:
  /// **'A tactic involving pins, where a piece is unable to move without revealing an attack on a higher value piece.'**
  String get puzzleThemePinDescription;

  /// No description provided for @puzzleThemePromotion.
  ///
  /// In en, this message translates to:
  /// **'Promotion'**
  String get puzzleThemePromotion;

  /// No description provided for @puzzleThemePromotionDescription.
  ///
  /// In en, this message translates to:
  /// **'Promote one of your pawn to a queen or minor piece.'**
  String get puzzleThemePromotionDescription;

  /// No description provided for @puzzleThemeQueenEndgame.
  ///
  /// In en, this message translates to:
  /// **'Queen endgame'**
  String get puzzleThemeQueenEndgame;

  /// No description provided for @puzzleThemeQueenEndgameDescription.
  ///
  /// In en, this message translates to:
  /// **'An endgame with only queens and pawns.'**
  String get puzzleThemeQueenEndgameDescription;

  /// No description provided for @puzzleThemeQueenRookEndgame.
  ///
  /// In en, this message translates to:
  /// **'Queen and Rook'**
  String get puzzleThemeQueenRookEndgame;

  /// No description provided for @puzzleThemeQueenRookEndgameDescription.
  ///
  /// In en, this message translates to:
  /// **'An endgame with only queens, rooks and pawns.'**
  String get puzzleThemeQueenRookEndgameDescription;

  /// No description provided for @puzzleThemeQueensideAttack.
  ///
  /// In en, this message translates to:
  /// **'Queenside attack'**
  String get puzzleThemeQueensideAttack;

  /// No description provided for @puzzleThemeQueensideAttackDescription.
  ///
  /// In en, this message translates to:
  /// **'An attack of the opponent\'s king, after they castled on the queen side.'**
  String get puzzleThemeQueensideAttackDescription;

  /// No description provided for @puzzleThemeQuietMove.
  ///
  /// In en, this message translates to:
  /// **'Quiet move'**
  String get puzzleThemeQuietMove;

  /// No description provided for @puzzleThemeQuietMoveDescription.
  ///
  /// In en, this message translates to:
  /// **'A move that does neither make a check or capture, nor an immediate threat to capture, but does prepare a more hidden unavoidable threat for a later move.'**
  String get puzzleThemeQuietMoveDescription;

  /// No description provided for @puzzleThemeRookEndgame.
  ///
  /// In en, this message translates to:
  /// **'Rook endgame'**
  String get puzzleThemeRookEndgame;

  /// No description provided for @puzzleThemeRookEndgameDescription.
  ///
  /// In en, this message translates to:
  /// **'An endgame with only rooks and pawns.'**
  String get puzzleThemeRookEndgameDescription;

  /// No description provided for @puzzleThemeSacrifice.
  ///
  /// In en, this message translates to:
  /// **'Sacrifice'**
  String get puzzleThemeSacrifice;

  /// No description provided for @puzzleThemeSacrificeDescription.
  ///
  /// In en, this message translates to:
  /// **'A tactic involving giving up material in the short-term, to gain an advantage again after a forced sequence of moves.'**
  String get puzzleThemeSacrificeDescription;

  /// No description provided for @puzzleThemeShort.
  ///
  /// In en, this message translates to:
  /// **'Short puzzle'**
  String get puzzleThemeShort;

  /// No description provided for @puzzleThemeShortDescription.
  ///
  /// In en, this message translates to:
  /// **'Two moves to win.'**
  String get puzzleThemeShortDescription;

  /// No description provided for @puzzleThemeSkewer.
  ///
  /// In en, this message translates to:
  /// **'Skewer'**
  String get puzzleThemeSkewer;

  /// No description provided for @puzzleThemeSkewerDescription.
  ///
  /// In en, this message translates to:
  /// **'A motif involving a high value piece being attacked, moving out the way, and allowing a lower value piece behind it to be captured or attacked, the inverse of a pin.'**
  String get puzzleThemeSkewerDescription;

  /// No description provided for @puzzleThemeSmotheredMate.
  ///
  /// In en, this message translates to:
  /// **'Smothered mate'**
  String get puzzleThemeSmotheredMate;

  /// No description provided for @puzzleThemeSmotheredMateDescription.
  ///
  /// In en, this message translates to:
  /// **'A checkmate delivered by a knight in which the mated king is unable to move because it is surrounded (or smothered) by its own pieces.'**
  String get puzzleThemeSmotheredMateDescription;

  /// No description provided for @puzzleThemeSuperGM.
  ///
  /// In en, this message translates to:
  /// **'Super GM games'**
  String get puzzleThemeSuperGM;

  /// No description provided for @puzzleThemeSuperGMDescription.
  ///
  /// In en, this message translates to:
  /// **'Puzzles from games played by the best players in the world.'**
  String get puzzleThemeSuperGMDescription;

  /// No description provided for @puzzleThemeTrappedPiece.
  ///
  /// In en, this message translates to:
  /// **'Trapped piece'**
  String get puzzleThemeTrappedPiece;

  /// No description provided for @puzzleThemeTrappedPieceDescription.
  ///
  /// In en, this message translates to:
  /// **'A piece is unable to escape capture as it has limited moves.'**
  String get puzzleThemeTrappedPieceDescription;

  /// No description provided for @puzzleThemeUnderPromotion.
  ///
  /// In en, this message translates to:
  /// **'Underpromotion'**
  String get puzzleThemeUnderPromotion;

  /// No description provided for @puzzleThemeUnderPromotionDescription.
  ///
  /// In en, this message translates to:
  /// **'Promotion to a knight, bishop, or rook.'**
  String get puzzleThemeUnderPromotionDescription;

  /// No description provided for @puzzleThemeVeryLong.
  ///
  /// In en, this message translates to:
  /// **'Very long puzzle'**
  String get puzzleThemeVeryLong;

  /// No description provided for @puzzleThemeVeryLongDescription.
  ///
  /// In en, this message translates to:
  /// **'Four moves or more to win.'**
  String get puzzleThemeVeryLongDescription;

  /// No description provided for @puzzleThemeXRayAttack.
  ///
  /// In en, this message translates to:
  /// **'X-Ray attack'**
  String get puzzleThemeXRayAttack;

  /// No description provided for @puzzleThemeXRayAttackDescription.
  ///
  /// In en, this message translates to:
  /// **'A piece attacks or defends a square, through an enemy piece.'**
  String get puzzleThemeXRayAttackDescription;

  /// No description provided for @puzzleThemeZugzwang.
  ///
  /// In en, this message translates to:
  /// **'Zugzwang'**
  String get puzzleThemeZugzwang;

  /// No description provided for @puzzleThemeZugzwangDescription.
  ///
  /// In en, this message translates to:
  /// **'The opponent is limited in the moves they can make, and all moves worsen their position.'**
  String get puzzleThemeZugzwangDescription;

  /// No description provided for @puzzleThemeMix.
  ///
  /// In en, this message translates to:
  /// **'Healthy mix'**
  String get puzzleThemeMix;

  /// No description provided for @puzzleThemeMixDescription.
  ///
  /// In en, this message translates to:
  /// **'A bit of everything. You don\'t know what to expect, so you remain ready for anything! Just like in real games.'**
  String get puzzleThemeMixDescription;

  /// No description provided for @puzzleThemePlayerGames.
  ///
  /// In en, this message translates to:
  /// **'Player games'**
  String get puzzleThemePlayerGames;

  /// No description provided for @puzzleThemePlayerGamesDescription.
  ///
  /// In en, this message translates to:
  /// **'Lookup puzzles generated from your games, or from another player\'s games.'**
  String get puzzleThemePlayerGamesDescription;

  /// No description provided for @puzzleThemePuzzleDownloadInformation.
  ///
  /// In en, this message translates to:
  /// **'These puzzles are in the public domain, and can be downloaded from {param}.'**
  String puzzleThemePuzzleDownloadInformation(String param);

  /// No description provided for @searchSearch.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get searchSearch;

  /// No description provided for @settingsSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsSettings;

  /// No description provided for @settingsCloseAccount.
  ///
  /// In en, this message translates to:
  /// **'Close account'**
  String get settingsCloseAccount;

  /// No description provided for @settingsManagedAccountCannotBeClosed.
  ///
  /// In en, this message translates to:
  /// **'Your account is managed, and cannot be closed.'**
  String get settingsManagedAccountCannotBeClosed;

  /// No description provided for @settingsCantOpenSimilarAccount.
  ///
  /// In en, this message translates to:
  /// **'The username will NOT be available for registration again.'**
  String get settingsCantOpenSimilarAccount;

  /// No description provided for @settingsCancelKeepAccount.
  ///
  /// In en, this message translates to:
  /// **'Cancel and keep my account'**
  String get settingsCancelKeepAccount;

  /// No description provided for @settingsCloseAccountAreYouSure.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to close your account?'**
  String get settingsCloseAccountAreYouSure;

  /// No description provided for @settingsThisAccountIsClosed.
  ///
  /// In en, this message translates to:
  /// **'This account is closed.'**
  String get settingsThisAccountIsClosed;

  /// No description provided for @playWithAFriend.
  ///
  /// In en, this message translates to:
  /// **'Play with a friend'**
  String get playWithAFriend;

  /// No description provided for @playWithTheMachine.
  ///
  /// In en, this message translates to:
  /// **'Play with the computer'**
  String get playWithTheMachine;

  /// No description provided for @toInviteSomeoneToPlayGiveThisUrl.
  ///
  /// In en, this message translates to:
  /// **'To invite someone to play, give this URL'**
  String get toInviteSomeoneToPlayGiveThisUrl;

  /// No description provided for @gameOver.
  ///
  /// In en, this message translates to:
  /// **'Game Over'**
  String get gameOver;

  /// No description provided for @waitingForOpponent.
  ///
  /// In en, this message translates to:
  /// **'Waiting for opponent'**
  String get waitingForOpponent;

  /// No description provided for @orLetYourOpponentScanQrCode.
  ///
  /// In en, this message translates to:
  /// **'Or let your opponent scan this QR code'**
  String get orLetYourOpponentScanQrCode;

  /// No description provided for @waiting.
  ///
  /// In en, this message translates to:
  /// **'Waiting'**
  String get waiting;

  /// No description provided for @yourTurn.
  ///
  /// In en, this message translates to:
  /// **'Your turn'**
  String get yourTurn;

  /// No description provided for @aiNameLevelAiLevel.
  ///
  /// In en, this message translates to:
  /// **'{param1} level {param2}'**
  String aiNameLevelAiLevel(String param1, String param2);

  /// No description provided for @level.
  ///
  /// In en, this message translates to:
  /// **'Level'**
  String get level;

  /// No description provided for @strength.
  ///
  /// In en, this message translates to:
  /// **'Strength'**
  String get strength;

  /// No description provided for @toggleTheChat.
  ///
  /// In en, this message translates to:
  /// **'Toggle the chat'**
  String get toggleTheChat;

  /// No description provided for @chat.
  ///
  /// In en, this message translates to:
  /// **'Chat'**
  String get chat;

  /// No description provided for @resign.
  ///
  /// In en, this message translates to:
  /// **'Resign'**
  String get resign;

  /// No description provided for @checkmate.
  ///
  /// In en, this message translates to:
  /// **'Checkmate'**
  String get checkmate;

  /// No description provided for @stalemate.
  ///
  /// In en, this message translates to:
  /// **'Stalemate'**
  String get stalemate;

  /// No description provided for @white.
  ///
  /// In en, this message translates to:
  /// **'White'**
  String get white;

  /// No description provided for @black.
  ///
  /// In en, this message translates to:
  /// **'Black'**
  String get black;

  /// No description provided for @asWhite.
  ///
  /// In en, this message translates to:
  /// **'as white'**
  String get asWhite;

  /// No description provided for @asBlack.
  ///
  /// In en, this message translates to:
  /// **'as black'**
  String get asBlack;

  /// No description provided for @randomColor.
  ///
  /// In en, this message translates to:
  /// **'Random side'**
  String get randomColor;

  /// No description provided for @createAGame.
  ///
  /// In en, this message translates to:
  /// **'Create a game'**
  String get createAGame;

  /// No description provided for @whiteIsVictorious.
  ///
  /// In en, this message translates to:
  /// **'White is victorious'**
  String get whiteIsVictorious;

  /// No description provided for @blackIsVictorious.
  ///
  /// In en, this message translates to:
  /// **'Black is victorious'**
  String get blackIsVictorious;

  /// No description provided for @youPlayTheWhitePieces.
  ///
  /// In en, this message translates to:
  /// **'You play the white pieces'**
  String get youPlayTheWhitePieces;

  /// No description provided for @youPlayTheBlackPieces.
  ///
  /// In en, this message translates to:
  /// **'You play the black pieces'**
  String get youPlayTheBlackPieces;

  /// No description provided for @itsYourTurn.
  ///
  /// In en, this message translates to:
  /// **'It\'s your turn!'**
  String get itsYourTurn;

  /// No description provided for @cheatDetected.
  ///
  /// In en, this message translates to:
  /// **'Cheat Detected'**
  String get cheatDetected;

  /// No description provided for @kingInTheCenter.
  ///
  /// In en, this message translates to:
  /// **'King in the centre'**
  String get kingInTheCenter;

  /// No description provided for @threeChecks.
  ///
  /// In en, this message translates to:
  /// **'Three checks'**
  String get threeChecks;

  /// No description provided for @raceFinished.
  ///
  /// In en, this message translates to:
  /// **'Race finished'**
  String get raceFinished;

  /// No description provided for @variantEnding.
  ///
  /// In en, this message translates to:
  /// **'Variant ending'**
  String get variantEnding;

  /// No description provided for @newOpponent.
  ///
  /// In en, this message translates to:
  /// **'New opponent'**
  String get newOpponent;

  /// No description provided for @yourOpponentWantsToPlayANewGameWithYou.
  ///
  /// In en, this message translates to:
  /// **'Your opponent wants to play a new game with you'**
  String get yourOpponentWantsToPlayANewGameWithYou;

  /// No description provided for @joinTheGame.
  ///
  /// In en, this message translates to:
  /// **'Join the game'**
  String get joinTheGame;

  /// No description provided for @whitePlays.
  ///
  /// In en, this message translates to:
  /// **'White to play'**
  String get whitePlays;

  /// No description provided for @blackPlays.
  ///
  /// In en, this message translates to:
  /// **'Black to play'**
  String get blackPlays;

  /// No description provided for @opponentLeftChoices.
  ///
  /// In en, this message translates to:
  /// **'Your opponent left the game. You can claim victory, call the game a draw, or wait.'**
  String get opponentLeftChoices;

  /// No description provided for @forceResignation.
  ///
  /// In en, this message translates to:
  /// **'Claim victory'**
  String get forceResignation;

  /// No description provided for @forceDraw.
  ///
  /// In en, this message translates to:
  /// **'Call draw'**
  String get forceDraw;

  /// No description provided for @talkInChat.
  ///
  /// In en, this message translates to:
  /// **'Please be nice in the chat!'**
  String get talkInChat;

  /// No description provided for @theFirstPersonToComeOnThisUrlWillPlayWithYou.
  ///
  /// In en, this message translates to:
  /// **'The first person to come to this URL will play with you.'**
  String get theFirstPersonToComeOnThisUrlWillPlayWithYou;

  /// No description provided for @whiteResigned.
  ///
  /// In en, this message translates to:
  /// **'White resigned'**
  String get whiteResigned;

  /// No description provided for @blackResigned.
  ///
  /// In en, this message translates to:
  /// **'Black resigned'**
  String get blackResigned;

  /// No description provided for @whiteLeftTheGame.
  ///
  /// In en, this message translates to:
  /// **'White left the game'**
  String get whiteLeftTheGame;

  /// No description provided for @blackLeftTheGame.
  ///
  /// In en, this message translates to:
  /// **'Black left the game'**
  String get blackLeftTheGame;

  /// No description provided for @whiteDidntMove.
  ///
  /// In en, this message translates to:
  /// **'White didn\'t move'**
  String get whiteDidntMove;

  /// No description provided for @blackDidntMove.
  ///
  /// In en, this message translates to:
  /// **'Black didn\'t move'**
  String get blackDidntMove;

  /// No description provided for @requestAComputerAnalysis.
  ///
  /// In en, this message translates to:
  /// **'Request a computer analysis'**
  String get requestAComputerAnalysis;

  /// No description provided for @computerAnalysis.
  ///
  /// In en, this message translates to:
  /// **'Computer analysis'**
  String get computerAnalysis;

  /// No description provided for @computerAnalysisAvailable.
  ///
  /// In en, this message translates to:
  /// **'Computer analysis available'**
  String get computerAnalysisAvailable;

  /// No description provided for @computerAnalysisDisabled.
  ///
  /// In en, this message translates to:
  /// **'Computer analysis disabled'**
  String get computerAnalysisDisabled;

  /// No description provided for @analysis.
  ///
  /// In en, this message translates to:
  /// **'Analysis board'**
  String get analysis;

  /// No description provided for @depthX.
  ///
  /// In en, this message translates to:
  /// **'Depth {param}'**
  String depthX(String param);

  /// No description provided for @usingServerAnalysis.
  ///
  /// In en, this message translates to:
  /// **'Using server analysis'**
  String get usingServerAnalysis;

  /// No description provided for @loadingEngine.
  ///
  /// In en, this message translates to:
  /// **'Loading engine...'**
  String get loadingEngine;

  /// No description provided for @calculatingMoves.
  ///
  /// In en, this message translates to:
  /// **'Calculating moves...'**
  String get calculatingMoves;

  /// No description provided for @engineFailed.
  ///
  /// In en, this message translates to:
  /// **'Error loading engine'**
  String get engineFailed;

  /// No description provided for @cloudAnalysis.
  ///
  /// In en, this message translates to:
  /// **'Cloud analysis'**
  String get cloudAnalysis;

  /// No description provided for @goDeeper.
  ///
  /// In en, this message translates to:
  /// **'Go deeper'**
  String get goDeeper;

  /// No description provided for @showThreat.
  ///
  /// In en, this message translates to:
  /// **'Show threat'**
  String get showThreat;

  /// No description provided for @inLocalBrowser.
  ///
  /// In en, this message translates to:
  /// **'in local browser'**
  String get inLocalBrowser;

  /// No description provided for @toggleLocalEvaluation.
  ///
  /// In en, this message translates to:
  /// **'Toggle local evaluation'**
  String get toggleLocalEvaluation;

  /// No description provided for @promoteVariation.
  ///
  /// In en, this message translates to:
  /// **'Promote variation'**
  String get promoteVariation;

  /// No description provided for @makeMainLine.
  ///
  /// In en, this message translates to:
  /// **'Make mainline'**
  String get makeMainLine;

  /// No description provided for @deleteFromHere.
  ///
  /// In en, this message translates to:
  /// **'Delete from here'**
  String get deleteFromHere;

  /// No description provided for @collapseVariations.
  ///
  /// In en, this message translates to:
  /// **'Collapse variations'**
  String get collapseVariations;

  /// No description provided for @expandVariations.
  ///
  /// In en, this message translates to:
  /// **'Expand variations'**
  String get expandVariations;

  /// No description provided for @forceVariation.
  ///
  /// In en, this message translates to:
  /// **'Force variation'**
  String get forceVariation;

  /// No description provided for @copyVariationPgn.
  ///
  /// In en, this message translates to:
  /// **'Copy variation PGN'**
  String get copyVariationPgn;

  /// No description provided for @move.
  ///
  /// In en, this message translates to:
  /// **'Move'**
  String get move;

  /// No description provided for @variantLoss.
  ///
  /// In en, this message translates to:
  /// **'Variant loss'**
  String get variantLoss;

  /// No description provided for @variantWin.
  ///
  /// In en, this message translates to:
  /// **'Variant win'**
  String get variantWin;

  /// No description provided for @insufficientMaterial.
  ///
  /// In en, this message translates to:
  /// **'Insufficient material'**
  String get insufficientMaterial;

  /// No description provided for @pawnMove.
  ///
  /// In en, this message translates to:
  /// **'Pawn move'**
  String get pawnMove;

  /// No description provided for @capture.
  ///
  /// In en, this message translates to:
  /// **'Capture'**
  String get capture;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @winning.
  ///
  /// In en, this message translates to:
  /// **'Winning'**
  String get winning;

  /// No description provided for @losing.
  ///
  /// In en, this message translates to:
  /// **'Losing'**
  String get losing;

  /// No description provided for @drawn.
  ///
  /// In en, this message translates to:
  /// **'Drawn'**
  String get drawn;

  /// No description provided for @unknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get unknown;

  /// No description provided for @database.
  ///
  /// In en, this message translates to:
  /// **'Database'**
  String get database;

  /// No description provided for @whiteDrawBlack.
  ///
  /// In en, this message translates to:
  /// **'White / Draw / Black'**
  String get whiteDrawBlack;

  /// No description provided for @averageRatingX.
  ///
  /// In en, this message translates to:
  /// **'Average rating: {param}'**
  String averageRatingX(String param);

  /// No description provided for @recentGames.
  ///
  /// In en, this message translates to:
  /// **'Recent games'**
  String get recentGames;

  /// No description provided for @topGames.
  ///
  /// In en, this message translates to:
  /// **'Top games'**
  String get topGames;

  /// No description provided for @masterDbExplanation.
  ///
  /// In en, this message translates to:
  /// **'OTB games of {param1}+ FIDE-rated players from {param2} to {param3}'**
  String masterDbExplanation(String param1, String param2, String param3);

  /// No description provided for @dtzWithRounding.
  ///
  /// In en, this message translates to:
  /// **'DTZ50\'\' with rounding, based on number of half-moves until next capture or pawn move'**
  String get dtzWithRounding;

  /// No description provided for @noGameFound.
  ///
  /// In en, this message translates to:
  /// **'No game found'**
  String get noGameFound;

  /// No description provided for @maxDepthReached.
  ///
  /// In en, this message translates to:
  /// **'Max depth reached!'**
  String get maxDepthReached;

  /// No description provided for @maybeIncludeMoreGamesFromThePreferencesMenu.
  ///
  /// In en, this message translates to:
  /// **'Maybe include more games from the preferences menu?'**
  String get maybeIncludeMoreGamesFromThePreferencesMenu;

  /// No description provided for @openings.
  ///
  /// In en, this message translates to:
  /// **'Openings'**
  String get openings;

  /// No description provided for @openingExplorer.
  ///
  /// In en, this message translates to:
  /// **'Opening explorer'**
  String get openingExplorer;

  /// No description provided for @openingEndgameExplorer.
  ///
  /// In en, this message translates to:
  /// **'Opening/endgame explorer'**
  String get openingEndgameExplorer;

  /// No description provided for @xOpeningExplorer.
  ///
  /// In en, this message translates to:
  /// **'{param} opening explorer'**
  String xOpeningExplorer(String param);

  /// No description provided for @playFirstOpeningEndgameExplorerMove.
  ///
  /// In en, this message translates to:
  /// **'Play first opening/endgame-explorer move'**
  String get playFirstOpeningEndgameExplorerMove;

  /// No description provided for @winPreventedBy50MoveRule.
  ///
  /// In en, this message translates to:
  /// **'Win prevented by 50-move rule'**
  String get winPreventedBy50MoveRule;

  /// No description provided for @lossSavedBy50MoveRule.
  ///
  /// In en, this message translates to:
  /// **'Loss prevented by 50-move rule'**
  String get lossSavedBy50MoveRule;

  /// No description provided for @winOr50MovesByPriorMistake.
  ///
  /// In en, this message translates to:
  /// **'Win or 50 moves by prior mistake'**
  String get winOr50MovesByPriorMistake;

  /// No description provided for @lossOr50MovesByPriorMistake.
  ///
  /// In en, this message translates to:
  /// **'Loss or 50 moves by prior mistake'**
  String get lossOr50MovesByPriorMistake;

  /// No description provided for @unknownDueToRounding.
  ///
  /// In en, this message translates to:
  /// **'Win/loss only guaranteed if recommended tablebase line has been followed since the last capture or pawn move, due to possible rounding of DTZ values in Syzygy tablebases.'**
  String get unknownDueToRounding;

  /// No description provided for @allSet.
  ///
  /// In en, this message translates to:
  /// **'All set!'**
  String get allSet;

  /// No description provided for @importPgn.
  ///
  /// In en, this message translates to:
  /// **'Import PGN'**
  String get importPgn;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @deleteThisImportedGame.
  ///
  /// In en, this message translates to:
  /// **'Delete this imported game?'**
  String get deleteThisImportedGame;

  /// No description provided for @replayMode.
  ///
  /// In en, this message translates to:
  /// **'Replay mode'**
  String get replayMode;

  /// No description provided for @realtimeReplay.
  ///
  /// In en, this message translates to:
  /// **'Realtime'**
  String get realtimeReplay;

  /// No description provided for @byCPL.
  ///
  /// In en, this message translates to:
  /// **'By CPL'**
  String get byCPL;

  /// No description provided for @enable.
  ///
  /// In en, this message translates to:
  /// **'Enable'**
  String get enable;

  /// No description provided for @bestMoveArrow.
  ///
  /// In en, this message translates to:
  /// **'Best move arrow'**
  String get bestMoveArrow;

  /// No description provided for @showVariationArrows.
  ///
  /// In en, this message translates to:
  /// **'Show variation arrows'**
  String get showVariationArrows;

  /// No description provided for @evaluationGauge.
  ///
  /// In en, this message translates to:
  /// **'Evaluation gauge'**
  String get evaluationGauge;

  /// No description provided for @multipleLines.
  ///
  /// In en, this message translates to:
  /// **'Multiple lines'**
  String get multipleLines;

  /// No description provided for @cpus.
  ///
  /// In en, this message translates to:
  /// **'CPUs'**
  String get cpus;

  /// No description provided for @memory.
  ///
  /// In en, this message translates to:
  /// **'Memory'**
  String get memory;

  /// No description provided for @infiniteAnalysis.
  ///
  /// In en, this message translates to:
  /// **'Infinite analysis'**
  String get infiniteAnalysis;

  /// No description provided for @removesTheDepthLimit.
  ///
  /// In en, this message translates to:
  /// **'Removes the depth limit, and keeps your computer warm'**
  String get removesTheDepthLimit;

  /// No description provided for @blunder.
  ///
  /// In en, this message translates to:
  /// **'Blunder'**
  String get blunder;

  /// No description provided for @mistake.
  ///
  /// In en, this message translates to:
  /// **'Mistake'**
  String get mistake;

  /// No description provided for @inaccuracy.
  ///
  /// In en, this message translates to:
  /// **'Inaccuracy'**
  String get inaccuracy;

  /// No description provided for @moveTimes.
  ///
  /// In en, this message translates to:
  /// **'Move times'**
  String get moveTimes;

  /// No description provided for @flipBoard.
  ///
  /// In en, this message translates to:
  /// **'Flip board'**
  String get flipBoard;

  /// No description provided for @threefoldRepetition.
  ///
  /// In en, this message translates to:
  /// **'Threefold repetition'**
  String get threefoldRepetition;

  /// No description provided for @claimADraw.
  ///
  /// In en, this message translates to:
  /// **'Claim a draw'**
  String get claimADraw;

  /// No description provided for @offerDraw.
  ///
  /// In en, this message translates to:
  /// **'Offer draw'**
  String get offerDraw;

  /// No description provided for @draw.
  ///
  /// In en, this message translates to:
  /// **'Draw'**
  String get draw;

  /// No description provided for @drawByMutualAgreement.
  ///
  /// In en, this message translates to:
  /// **'Draw by mutual agreement'**
  String get drawByMutualAgreement;

  /// No description provided for @fiftyMovesWithoutProgress.
  ///
  /// In en, this message translates to:
  /// **'Fifty moves without progress'**
  String get fiftyMovesWithoutProgress;

  /// No description provided for @currentGames.
  ///
  /// In en, this message translates to:
  /// **'Current games'**
  String get currentGames;

  /// No description provided for @viewInFullSize.
  ///
  /// In en, this message translates to:
  /// **'View in full size'**
  String get viewInFullSize;

  /// No description provided for @logOut.
  ///
  /// In en, this message translates to:
  /// **'Sign out'**
  String get logOut;

  /// No description provided for @signIn.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get signIn;

  /// No description provided for @rememberMe.
  ///
  /// In en, this message translates to:
  /// **'Keep me logged in'**
  String get rememberMe;

  /// No description provided for @youNeedAnAccountToDoThat.
  ///
  /// In en, this message translates to:
  /// **'You need an account to do that'**
  String get youNeedAnAccountToDoThat;

  /// No description provided for @signUp.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get signUp;

  /// No description provided for @computersAreNotAllowedToPlay.
  ///
  /// In en, this message translates to:
  /// **'Computers and computer-assisted players are not allowed to play. Please do not get assistance from chess engines, databases, or from other players while playing. Also note that making multiple accounts is strongly discouraged and excessive multi-accounting will lead to being banned.'**
  String get computersAreNotAllowedToPlay;

  /// No description provided for @games.
  ///
  /// In en, this message translates to:
  /// **'Games'**
  String get games;

  /// No description provided for @forum.
  ///
  /// In en, this message translates to:
  /// **'Forum'**
  String get forum;

  /// No description provided for @xPostedInForumY.
  ///
  /// In en, this message translates to:
  /// **'{param1} posted in topic {param2}'**
  String xPostedInForumY(String param1, String param2);

  /// No description provided for @latestForumPosts.
  ///
  /// In en, this message translates to:
  /// **'Latest forum posts'**
  String get latestForumPosts;

  /// No description provided for @players.
  ///
  /// In en, this message translates to:
  /// **'Players'**
  String get players;

  /// No description provided for @friends.
  ///
  /// In en, this message translates to:
  /// **'Friends'**
  String get friends;

  /// No description provided for @otherPlayers.
  ///
  /// In en, this message translates to:
  /// **'other players'**
  String get otherPlayers;

  /// No description provided for @discussions.
  ///
  /// In en, this message translates to:
  /// **'Conversations'**
  String get discussions;

  /// No description provided for @today.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get today;

  /// No description provided for @yesterday.
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get yesterday;

  /// No description provided for @minutesPerSide.
  ///
  /// In en, this message translates to:
  /// **'Minutes per side'**
  String get minutesPerSide;

  /// No description provided for @variant.
  ///
  /// In en, this message translates to:
  /// **'Variant'**
  String get variant;

  /// No description provided for @variants.
  ///
  /// In en, this message translates to:
  /// **'Variants'**
  String get variants;

  /// No description provided for @timeControl.
  ///
  /// In en, this message translates to:
  /// **'Time control'**
  String get timeControl;

  /// No description provided for @realTime.
  ///
  /// In en, this message translates to:
  /// **'Real time'**
  String get realTime;

  /// No description provided for @correspondence.
  ///
  /// In en, this message translates to:
  /// **'Correspondence'**
  String get correspondence;

  /// No description provided for @daysPerTurn.
  ///
  /// In en, this message translates to:
  /// **'Days per turn'**
  String get daysPerTurn;

  /// No description provided for @oneDay.
  ///
  /// In en, this message translates to:
  /// **'One day'**
  String get oneDay;

  /// No description provided for @time.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get time;

  /// No description provided for @rating.
  ///
  /// In en, this message translates to:
  /// **'Rating'**
  String get rating;

  /// No description provided for @ratingStats.
  ///
  /// In en, this message translates to:
  /// **'Rating stats'**
  String get ratingStats;

  /// No description provided for @username.
  ///
  /// In en, this message translates to:
  /// **'User name'**
  String get username;

  /// No description provided for @usernameOrEmail.
  ///
  /// In en, this message translates to:
  /// **'User name or email'**
  String get usernameOrEmail;

  /// No description provided for @changeUsername.
  ///
  /// In en, this message translates to:
  /// **'Change username'**
  String get changeUsername;

  /// No description provided for @changeUsernameNotSame.
  ///
  /// In en, this message translates to:
  /// **'Only the case of the letters can change. For example \"johndoe\" to \"JohnDoe\".'**
  String get changeUsernameNotSame;

  /// No description provided for @changeUsernameDescription.
  ///
  /// In en, this message translates to:
  /// **'Change your username. This can only be done once and you are only allowed to change the case of the letters in your username.'**
  String get changeUsernameDescription;

  /// No description provided for @signupUsernameHint.
  ///
  /// In en, this message translates to:
  /// **'Make sure to choose a family-friendly username. You cannot change it later and any accounts with inappropriate usernames will get closed!'**
  String get signupUsernameHint;

  /// No description provided for @signupEmailHint.
  ///
  /// In en, this message translates to:
  /// **'We will only use it for password reset.'**
  String get signupEmailHint;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @changePassword.
  ///
  /// In en, this message translates to:
  /// **'Change password'**
  String get changePassword;

  /// No description provided for @changeEmail.
  ///
  /// In en, this message translates to:
  /// **'Change email'**
  String get changeEmail;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @passwordReset.
  ///
  /// In en, this message translates to:
  /// **'Password reset'**
  String get passwordReset;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot password?'**
  String get forgotPassword;

  /// No description provided for @error_weakPassword.
  ///
  /// In en, this message translates to:
  /// **'This password is extremely common, and too easy to guess.'**
  String get error_weakPassword;

  /// No description provided for @error_namePassword.
  ///
  /// In en, this message translates to:
  /// **'Please don\'t use your username as your password.'**
  String get error_namePassword;

  /// No description provided for @blankedPassword.
  ///
  /// In en, this message translates to:
  /// **'You have used the same password on another site, and that site has been compromised. To ensure the safety of your Lichess account, we need you to set a new password. Thank you for your understanding.'**
  String get blankedPassword;

  /// No description provided for @youAreLeavingLichess.
  ///
  /// In en, this message translates to:
  /// **'You are leaving Lichess'**
  String get youAreLeavingLichess;

  /// No description provided for @neverTypeYourPassword.
  ///
  /// In en, this message translates to:
  /// **'Never type your Lichess password on another site!'**
  String get neverTypeYourPassword;

  /// No description provided for @proceedToX.
  ///
  /// In en, this message translates to:
  /// **'Proceed to {param}'**
  String proceedToX(String param);

  /// No description provided for @passwordSuggestion.
  ///
  /// In en, this message translates to:
  /// **'Do not set a password suggested by someone else. They will use it to steal your account.'**
  String get passwordSuggestion;

  /// No description provided for @emailSuggestion.
  ///
  /// In en, this message translates to:
  /// **'Do not set an email address suggested by someone else. They will use it to steal your account.'**
  String get emailSuggestion;

  /// No description provided for @emailConfirmHelp.
  ///
  /// In en, this message translates to:
  /// **'Help with email confirmation'**
  String get emailConfirmHelp;

  /// No description provided for @emailConfirmNotReceived.
  ///
  /// In en, this message translates to:
  /// **'Didn\'t receive your confirmation email after signing up?'**
  String get emailConfirmNotReceived;

  /// No description provided for @whatSignupUsername.
  ///
  /// In en, this message translates to:
  /// **'What username did you use to sign up?'**
  String get whatSignupUsername;

  /// No description provided for @usernameNotFound.
  ///
  /// In en, this message translates to:
  /// **'We couldn\'t find any user by this name: {param}.'**
  String usernameNotFound(String param);

  /// No description provided for @usernameCanBeUsedForNewAccount.
  ///
  /// In en, this message translates to:
  /// **'You can use this username to create a new account'**
  String get usernameCanBeUsedForNewAccount;

  /// No description provided for @emailSent.
  ///
  /// In en, this message translates to:
  /// **'We have sent an email to {param}.'**
  String emailSent(String param);

  /// No description provided for @emailCanTakeSomeTime.
  ///
  /// In en, this message translates to:
  /// **'It can take some time to arrive.'**
  String get emailCanTakeSomeTime;

  /// No description provided for @refreshInboxAfterFiveMinutes.
  ///
  /// In en, this message translates to:
  /// **'Wait 5 minutes and refresh your email inbox.'**
  String get refreshInboxAfterFiveMinutes;

  /// No description provided for @checkSpamFolder.
  ///
  /// In en, this message translates to:
  /// **'Also check your spam folder, it might end up there. If so, mark it as not spam.'**
  String get checkSpamFolder;

  /// No description provided for @emailForSignupHelp.
  ///
  /// In en, this message translates to:
  /// **'If everything else fails, then send us this email:'**
  String get emailForSignupHelp;

  /// No description provided for @copyTextToEmail.
  ///
  /// In en, this message translates to:
  /// **'Copy and paste the above text and send it to {param}'**
  String copyTextToEmail(String param);

  /// No description provided for @waitForSignupHelp.
  ///
  /// In en, this message translates to:
  /// **'We will come back to you shortly to help you complete your signup.'**
  String get waitForSignupHelp;

  /// No description provided for @accountConfirmed.
  ///
  /// In en, this message translates to:
  /// **'The user {param} is successfully confirmed.'**
  String accountConfirmed(String param);

  /// No description provided for @accountCanLogin.
  ///
  /// In en, this message translates to:
  /// **'You can login right now as {param}.'**
  String accountCanLogin(String param);

  /// No description provided for @accountConfirmationEmailNotNeeded.
  ///
  /// In en, this message translates to:
  /// **'You do not need a confirmation email.'**
  String get accountConfirmationEmailNotNeeded;

  /// No description provided for @accountClosed.
  ///
  /// In en, this message translates to:
  /// **'The account {param} is closed.'**
  String accountClosed(String param);

  /// No description provided for @accountRegisteredWithoutEmail.
  ///
  /// In en, this message translates to:
  /// **'The account {param} was registered without an email.'**
  String accountRegisteredWithoutEmail(String param);

  /// No description provided for @rank.
  ///
  /// In en, this message translates to:
  /// **'Rank'**
  String get rank;

  /// No description provided for @rankX.
  ///
  /// In en, this message translates to:
  /// **'Rank: {param}'**
  String rankX(String param);

  /// No description provided for @gamesPlayed.
  ///
  /// In en, this message translates to:
  /// **'Games played'**
  String get gamesPlayed;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @whiteTimeOut.
  ///
  /// In en, this message translates to:
  /// **'White time out'**
  String get whiteTimeOut;

  /// No description provided for @blackTimeOut.
  ///
  /// In en, this message translates to:
  /// **'Black time out'**
  String get blackTimeOut;

  /// No description provided for @drawOfferSent.
  ///
  /// In en, this message translates to:
  /// **'Draw offer sent'**
  String get drawOfferSent;

  /// No description provided for @drawOfferAccepted.
  ///
  /// In en, this message translates to:
  /// **'Draw offer accepted'**
  String get drawOfferAccepted;

  /// No description provided for @drawOfferCanceled.
  ///
  /// In en, this message translates to:
  /// **'Draw offer cancelled'**
  String get drawOfferCanceled;

  /// No description provided for @whiteOffersDraw.
  ///
  /// In en, this message translates to:
  /// **'White offers draw'**
  String get whiteOffersDraw;

  /// No description provided for @blackOffersDraw.
  ///
  /// In en, this message translates to:
  /// **'Black offers draw'**
  String get blackOffersDraw;

  /// No description provided for @whiteDeclinesDraw.
  ///
  /// In en, this message translates to:
  /// **'White declines draw'**
  String get whiteDeclinesDraw;

  /// No description provided for @blackDeclinesDraw.
  ///
  /// In en, this message translates to:
  /// **'Black declines draw'**
  String get blackDeclinesDraw;

  /// No description provided for @yourOpponentOffersADraw.
  ///
  /// In en, this message translates to:
  /// **'Your opponent offers a draw'**
  String get yourOpponentOffersADraw;

  /// No description provided for @accept.
  ///
  /// In en, this message translates to:
  /// **'Accept'**
  String get accept;

  /// No description provided for @decline.
  ///
  /// In en, this message translates to:
  /// **'Decline'**
  String get decline;

  /// No description provided for @playingRightNow.
  ///
  /// In en, this message translates to:
  /// **'Playing right now'**
  String get playingRightNow;

  /// No description provided for @eventInProgress.
  ///
  /// In en, this message translates to:
  /// **'Playing now'**
  String get eventInProgress;

  /// No description provided for @finished.
  ///
  /// In en, this message translates to:
  /// **'Finished'**
  String get finished;

  /// No description provided for @abortGame.
  ///
  /// In en, this message translates to:
  /// **'Abort game'**
  String get abortGame;

  /// No description provided for @gameAborted.
  ///
  /// In en, this message translates to:
  /// **'Game aborted'**
  String get gameAborted;

  /// No description provided for @standard.
  ///
  /// In en, this message translates to:
  /// **'Standard'**
  String get standard;

  /// No description provided for @customPosition.
  ///
  /// In en, this message translates to:
  /// **'Custom position'**
  String get customPosition;

  /// No description provided for @unlimited.
  ///
  /// In en, this message translates to:
  /// **'Unlimited'**
  String get unlimited;

  /// No description provided for @mode.
  ///
  /// In en, this message translates to:
  /// **'Mode'**
  String get mode;

  /// No description provided for @casual.
  ///
  /// In en, this message translates to:
  /// **'Casual'**
  String get casual;

  /// No description provided for @rated.
  ///
  /// In en, this message translates to:
  /// **'Rated'**
  String get rated;

  /// No description provided for @casualTournament.
  ///
  /// In en, this message translates to:
  /// **'Casual'**
  String get casualTournament;

  /// No description provided for @ratedTournament.
  ///
  /// In en, this message translates to:
  /// **'Rated'**
  String get ratedTournament;

  /// No description provided for @thisGameIsRated.
  ///
  /// In en, this message translates to:
  /// **'This game is rated'**
  String get thisGameIsRated;

  /// No description provided for @rematch.
  ///
  /// In en, this message translates to:
  /// **'Rematch'**
  String get rematch;

  /// No description provided for @rematchOfferSent.
  ///
  /// In en, this message translates to:
  /// **'Rematch offer sent'**
  String get rematchOfferSent;

  /// No description provided for @rematchOfferAccepted.
  ///
  /// In en, this message translates to:
  /// **'Rematch offer accepted'**
  String get rematchOfferAccepted;

  /// No description provided for @rematchOfferCanceled.
  ///
  /// In en, this message translates to:
  /// **'Rematch offer cancelled'**
  String get rematchOfferCanceled;

  /// No description provided for @rematchOfferDeclined.
  ///
  /// In en, this message translates to:
  /// **'Rematch offer declined'**
  String get rematchOfferDeclined;

  /// No description provided for @cancelRematchOffer.
  ///
  /// In en, this message translates to:
  /// **'Cancel rematch offer'**
  String get cancelRematchOffer;

  /// No description provided for @viewRematch.
  ///
  /// In en, this message translates to:
  /// **'View rematch'**
  String get viewRematch;

  /// No description provided for @confirmMove.
  ///
  /// In en, this message translates to:
  /// **'Confirm move'**
  String get confirmMove;

  /// No description provided for @play.
  ///
  /// In en, this message translates to:
  /// **'Play'**
  String get play;

  /// No description provided for @inbox.
  ///
  /// In en, this message translates to:
  /// **'Inbox'**
  String get inbox;

  /// No description provided for @chatRoom.
  ///
  /// In en, this message translates to:
  /// **'Chat room'**
  String get chatRoom;

  /// No description provided for @loginToChat.
  ///
  /// In en, this message translates to:
  /// **'Sign in to chat'**
  String get loginToChat;

  /// No description provided for @youHaveBeenTimedOut.
  ///
  /// In en, this message translates to:
  /// **'You have been timed out.'**
  String get youHaveBeenTimedOut;

  /// No description provided for @spectatorRoom.
  ///
  /// In en, this message translates to:
  /// **'Spectator room'**
  String get spectatorRoom;

  /// No description provided for @composeMessage.
  ///
  /// In en, this message translates to:
  /// **'Compose message'**
  String get composeMessage;

  /// No description provided for @subject.
  ///
  /// In en, this message translates to:
  /// **'Subject'**
  String get subject;

  /// No description provided for @send.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get send;

  /// No description provided for @incrementInSeconds.
  ///
  /// In en, this message translates to:
  /// **'Increment in seconds'**
  String get incrementInSeconds;

  /// No description provided for @freeOnlineChess.
  ///
  /// In en, this message translates to:
  /// **'Free Online Chess'**
  String get freeOnlineChess;

  /// No description provided for @exportGames.
  ///
  /// In en, this message translates to:
  /// **'Export games'**
  String get exportGames;

  /// No description provided for @ratingRange.
  ///
  /// In en, this message translates to:
  /// **'Rating range'**
  String get ratingRange;

  /// No description provided for @thisAccountViolatedTos.
  ///
  /// In en, this message translates to:
  /// **'This account violated the Lichess Terms of Service'**
  String get thisAccountViolatedTos;

  /// No description provided for @openingExplorerAndTablebase.
  ///
  /// In en, this message translates to:
  /// **'Opening explorer & tablebase'**
  String get openingExplorerAndTablebase;

  /// No description provided for @takeback.
  ///
  /// In en, this message translates to:
  /// **'Takeback'**
  String get takeback;

  /// No description provided for @proposeATakeback.
  ///
  /// In en, this message translates to:
  /// **'Propose a takeback'**
  String get proposeATakeback;

  /// No description provided for @takebackPropositionSent.
  ///
  /// In en, this message translates to:
  /// **'Takeback sent'**
  String get takebackPropositionSent;

  /// No description provided for @takebackPropositionDeclined.
  ///
  /// In en, this message translates to:
  /// **'Takeback declined'**
  String get takebackPropositionDeclined;

  /// No description provided for @takebackPropositionAccepted.
  ///
  /// In en, this message translates to:
  /// **'Takeback accepted'**
  String get takebackPropositionAccepted;

  /// No description provided for @takebackPropositionCanceled.
  ///
  /// In en, this message translates to:
  /// **'Takeback cancelled'**
  String get takebackPropositionCanceled;

  /// No description provided for @yourOpponentProposesATakeback.
  ///
  /// In en, this message translates to:
  /// **'Your opponent proposes a takeback'**
  String get yourOpponentProposesATakeback;

  /// No description provided for @bookmarkThisGame.
  ///
  /// In en, this message translates to:
  /// **'Bookmark this game'**
  String get bookmarkThisGame;

  /// No description provided for @tournament.
  ///
  /// In en, this message translates to:
  /// **'Tournament'**
  String get tournament;

  /// No description provided for @tournaments.
  ///
  /// In en, this message translates to:
  /// **'Tournaments'**
  String get tournaments;

  /// No description provided for @tournamentPoints.
  ///
  /// In en, this message translates to:
  /// **'Tournament points'**
  String get tournamentPoints;

  /// No description provided for @viewTournament.
  ///
  /// In en, this message translates to:
  /// **'View tournament'**
  String get viewTournament;

  /// No description provided for @backToTournament.
  ///
  /// In en, this message translates to:
  /// **'Back to tournament'**
  String get backToTournament;

  /// No description provided for @noDrawBeforeSwissLimit.
  ///
  /// In en, this message translates to:
  /// **'You cannot draw before 30 moves are played in a Swiss tournament.'**
  String get noDrawBeforeSwissLimit;

  /// No description provided for @thematic.
  ///
  /// In en, this message translates to:
  /// **'Thematic'**
  String get thematic;

  /// No description provided for @yourPerfRatingIsProvisional.
  ///
  /// In en, this message translates to:
  /// **'Your {param} rating is provisional'**
  String yourPerfRatingIsProvisional(String param);

  /// No description provided for @yourPerfRatingIsTooHigh.
  ///
  /// In en, this message translates to:
  /// **'Your {param1} rating ({param2}) is too high'**
  String yourPerfRatingIsTooHigh(String param1, String param2);

  /// No description provided for @yourTopWeeklyPerfRatingIsTooHigh.
  ///
  /// In en, this message translates to:
  /// **'Your top weekly {param1} rating ({param2}) is too high'**
  String yourTopWeeklyPerfRatingIsTooHigh(String param1, String param2);

  /// No description provided for @yourPerfRatingIsTooLow.
  ///
  /// In en, this message translates to:
  /// **'Your {param1} rating ({param2}) is too low'**
  String yourPerfRatingIsTooLow(String param1, String param2);

  /// No description provided for @ratedMoreThanInPerf.
  ///
  /// In en, this message translates to:
  /// **'Rated ≥ {param1} in {param2}'**
  String ratedMoreThanInPerf(String param1, String param2);

  /// No description provided for @ratedLessThanInPerf.
  ///
  /// In en, this message translates to:
  /// **'Rated ≤ {param1} in {param2} for the last week'**
  String ratedLessThanInPerf(String param1, String param2);

  /// No description provided for @mustBeInTeam.
  ///
  /// In en, this message translates to:
  /// **'Must be in team {param}'**
  String mustBeInTeam(String param);

  /// No description provided for @youAreNotInTeam.
  ///
  /// In en, this message translates to:
  /// **'You are not in the team {param}'**
  String youAreNotInTeam(String param);

  /// No description provided for @backToGame.
  ///
  /// In en, this message translates to:
  /// **'Back to game'**
  String get backToGame;

  /// No description provided for @siteDescription.
  ///
  /// In en, this message translates to:
  /// **'Free online chess server. Play chess in a clean interface. No registration, no ads, no plugin required. Play chess with the computer, friends or random opponents.'**
  String get siteDescription;

  /// No description provided for @xJoinedTeamY.
  ///
  /// In en, this message translates to:
  /// **'{param1} joined team {param2}'**
  String xJoinedTeamY(String param1, String param2);

  /// No description provided for @xCreatedTeamY.
  ///
  /// In en, this message translates to:
  /// **'{param1} created team {param2}'**
  String xCreatedTeamY(String param1, String param2);

  /// No description provided for @startedStreaming.
  ///
  /// In en, this message translates to:
  /// **'started streaming'**
  String get startedStreaming;

  /// No description provided for @xStartedStreaming.
  ///
  /// In en, this message translates to:
  /// **'{param} started streaming'**
  String xStartedStreaming(String param);

  /// No description provided for @averageElo.
  ///
  /// In en, this message translates to:
  /// **'Average rating'**
  String get averageElo;

  /// No description provided for @location.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get location;

  /// No description provided for @filterGames.
  ///
  /// In en, this message translates to:
  /// **'Filter games'**
  String get filterGames;

  /// No description provided for @reset.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get reset;

  /// No description provided for @apply.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get apply;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @leaderboard.
  ///
  /// In en, this message translates to:
  /// **'Leaderboard'**
  String get leaderboard;

  /// No description provided for @screenshotCurrentPosition.
  ///
  /// In en, this message translates to:
  /// **'Screenshot current position'**
  String get screenshotCurrentPosition;

  /// No description provided for @gameAsGIF.
  ///
  /// In en, this message translates to:
  /// **'Game as GIF'**
  String get gameAsGIF;

  /// No description provided for @pasteTheFenStringHere.
  ///
  /// In en, this message translates to:
  /// **'Paste the FEN text here'**
  String get pasteTheFenStringHere;

  /// No description provided for @pasteThePgnStringHere.
  ///
  /// In en, this message translates to:
  /// **'Paste the PGN text here'**
  String get pasteThePgnStringHere;

  /// No description provided for @orUploadPgnFile.
  ///
  /// In en, this message translates to:
  /// **'Or upload a PGN file'**
  String get orUploadPgnFile;

  /// No description provided for @fromPosition.
  ///
  /// In en, this message translates to:
  /// **'From position'**
  String get fromPosition;

  /// No description provided for @continueFromHere.
  ///
  /// In en, this message translates to:
  /// **'Continue from here'**
  String get continueFromHere;

  /// No description provided for @toStudy.
  ///
  /// In en, this message translates to:
  /// **'Study'**
  String get toStudy;

  /// No description provided for @importGame.
  ///
  /// In en, this message translates to:
  /// **'Import game'**
  String get importGame;

  /// No description provided for @importGameExplanation.
  ///
  /// In en, this message translates to:
  /// **'Paste a game PGN to get a browsable replay, computer analysis, game chat and public shareable URL.'**
  String get importGameExplanation;

  /// No description provided for @importGameCaveat.
  ///
  /// In en, this message translates to:
  /// **'Variations will be erased. To keep them, import the PGN via a study.'**
  String get importGameCaveat;

  /// No description provided for @importGameDataPrivacyWarning.
  ///
  /// In en, this message translates to:
  /// **'This PGN can be accessed by the public. To import a game privately, use a study.'**
  String get importGameDataPrivacyWarning;

  /// No description provided for @thisIsAChessCaptcha.
  ///
  /// In en, this message translates to:
  /// **'This is a chess CAPTCHA.'**
  String get thisIsAChessCaptcha;

  /// No description provided for @clickOnTheBoardToMakeYourMove.
  ///
  /// In en, this message translates to:
  /// **'Click on the board to make your move, and prove you are human.'**
  String get clickOnTheBoardToMakeYourMove;

  /// No description provided for @captcha_fail.
  ///
  /// In en, this message translates to:
  /// **'Please solve the chess captcha.'**
  String get captcha_fail;

  /// No description provided for @notACheckmate.
  ///
  /// In en, this message translates to:
  /// **'Not a checkmate'**
  String get notACheckmate;

  /// No description provided for @whiteCheckmatesInOneMove.
  ///
  /// In en, this message translates to:
  /// **'White to checkmate in one move'**
  String get whiteCheckmatesInOneMove;

  /// No description provided for @blackCheckmatesInOneMove.
  ///
  /// In en, this message translates to:
  /// **'Black to checkmate in one move'**
  String get blackCheckmatesInOneMove;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @reconnecting.
  ///
  /// In en, this message translates to:
  /// **'Reconnecting'**
  String get reconnecting;

  /// No description provided for @noNetwork.
  ///
  /// In en, this message translates to:
  /// **'Offline'**
  String get noNetwork;

  /// No description provided for @favoriteOpponents.
  ///
  /// In en, this message translates to:
  /// **'Favourite opponents'**
  String get favoriteOpponents;

  /// No description provided for @follow.
  ///
  /// In en, this message translates to:
  /// **'Follow'**
  String get follow;

  /// No description provided for @following.
  ///
  /// In en, this message translates to:
  /// **'Following'**
  String get following;

  /// No description provided for @unfollow.
  ///
  /// In en, this message translates to:
  /// **'Unfollow'**
  String get unfollow;

  /// No description provided for @followX.
  ///
  /// In en, this message translates to:
  /// **'Follow {param}'**
  String followX(String param);

  /// No description provided for @unfollowX.
  ///
  /// In en, this message translates to:
  /// **'Unfollow {param}'**
  String unfollowX(String param);

  /// No description provided for @block.
  ///
  /// In en, this message translates to:
  /// **'Block'**
  String get block;

  /// No description provided for @blocked.
  ///
  /// In en, this message translates to:
  /// **'Blocked'**
  String get blocked;

  /// No description provided for @unblock.
  ///
  /// In en, this message translates to:
  /// **'Unblock'**
  String get unblock;

  /// No description provided for @xStartedFollowingY.
  ///
  /// In en, this message translates to:
  /// **'{param1} started following {param2}'**
  String xStartedFollowingY(String param1, String param2);

  /// No description provided for @more.
  ///
  /// In en, this message translates to:
  /// **'More'**
  String get more;

  /// No description provided for @memberSince.
  ///
  /// In en, this message translates to:
  /// **'Member since'**
  String get memberSince;

  /// No description provided for @lastSeenActive.
  ///
  /// In en, this message translates to:
  /// **'Active {param}'**
  String lastSeenActive(String param);

  /// No description provided for @player.
  ///
  /// In en, this message translates to:
  /// **'Player'**
  String get player;

  /// No description provided for @list.
  ///
  /// In en, this message translates to:
  /// **'List'**
  String get list;

  /// No description provided for @graph.
  ///
  /// In en, this message translates to:
  /// **'Graph'**
  String get graph;

  /// No description provided for @required.
  ///
  /// In en, this message translates to:
  /// **'Required.'**
  String get required;

  /// No description provided for @openTournaments.
  ///
  /// In en, this message translates to:
  /// **'Open tournaments'**
  String get openTournaments;

  /// No description provided for @duration.
  ///
  /// In en, this message translates to:
  /// **'Duration'**
  String get duration;

  /// No description provided for @winner.
  ///
  /// In en, this message translates to:
  /// **'Winner'**
  String get winner;

  /// No description provided for @standing.
  ///
  /// In en, this message translates to:
  /// **'Standing'**
  String get standing;

  /// No description provided for @createANewTournament.
  ///
  /// In en, this message translates to:
  /// **'Create a new tournament'**
  String get createANewTournament;

  /// No description provided for @tournamentCalendar.
  ///
  /// In en, this message translates to:
  /// **'Tournament calendar'**
  String get tournamentCalendar;

  /// No description provided for @conditionOfEntry.
  ///
  /// In en, this message translates to:
  /// **'Entry requirements:'**
  String get conditionOfEntry;

  /// No description provided for @advancedSettings.
  ///
  /// In en, this message translates to:
  /// **'Advanced settings'**
  String get advancedSettings;

  /// No description provided for @safeTournamentName.
  ///
  /// In en, this message translates to:
  /// **'Pick a very safe name for the tournament.'**
  String get safeTournamentName;

  /// No description provided for @inappropriateNameWarning.
  ///
  /// In en, this message translates to:
  /// **'Anything even slightly inappropriate could get your account closed.'**
  String get inappropriateNameWarning;

  /// No description provided for @emptyTournamentName.
  ///
  /// In en, this message translates to:
  /// **'Leave empty to name the tournament after a notable chess player.'**
  String get emptyTournamentName;

  /// No description provided for @makePrivateTournament.
  ///
  /// In en, this message translates to:
  /// **'Make the tournament private, and restrict access with a password'**
  String get makePrivateTournament;

  /// No description provided for @join.
  ///
  /// In en, this message translates to:
  /// **'Join'**
  String get join;

  /// No description provided for @withdraw.
  ///
  /// In en, this message translates to:
  /// **'Withdraw'**
  String get withdraw;

  /// No description provided for @points.
  ///
  /// In en, this message translates to:
  /// **'Points'**
  String get points;

  /// No description provided for @wins.
  ///
  /// In en, this message translates to:
  /// **'Wins'**
  String get wins;

  /// No description provided for @losses.
  ///
  /// In en, this message translates to:
  /// **'Losses'**
  String get losses;

  /// No description provided for @createdBy.
  ///
  /// In en, this message translates to:
  /// **'Created by'**
  String get createdBy;

  /// No description provided for @tournamentIsStarting.
  ///
  /// In en, this message translates to:
  /// **'The tournament is starting'**
  String get tournamentIsStarting;

  /// No description provided for @tournamentPairingsAreNowClosed.
  ///
  /// In en, this message translates to:
  /// **'The tournament pairings are now closed.'**
  String get tournamentPairingsAreNowClosed;

  /// No description provided for @standByX.
  ///
  /// In en, this message translates to:
  /// **'Stand by {param}, pairing players, get ready!'**
  String standByX(String param);

  /// No description provided for @pause.
  ///
  /// In en, this message translates to:
  /// **'Pause'**
  String get pause;

  /// No description provided for @resume.
  ///
  /// In en, this message translates to:
  /// **'Resume'**
  String get resume;

  /// No description provided for @youArePlaying.
  ///
  /// In en, this message translates to:
  /// **'You are playing!'**
  String get youArePlaying;

  /// No description provided for @winRate.
  ///
  /// In en, this message translates to:
  /// **'Win rate'**
  String get winRate;

  /// No description provided for @berserkRate.
  ///
  /// In en, this message translates to:
  /// **'Berserk rate'**
  String get berserkRate;

  /// No description provided for @performance.
  ///
  /// In en, this message translates to:
  /// **'Performance'**
  String get performance;

  /// No description provided for @tournamentComplete.
  ///
  /// In en, this message translates to:
  /// **'Tournament complete'**
  String get tournamentComplete;

  /// No description provided for @movesPlayed.
  ///
  /// In en, this message translates to:
  /// **'Moves played'**
  String get movesPlayed;

  /// No description provided for @whiteWins.
  ///
  /// In en, this message translates to:
  /// **'White wins'**
  String get whiteWins;

  /// No description provided for @blackWins.
  ///
  /// In en, this message translates to:
  /// **'Black wins'**
  String get blackWins;

  /// No description provided for @drawRate.
  ///
  /// In en, this message translates to:
  /// **'Draw rate'**
  String get drawRate;

  /// No description provided for @draws.
  ///
  /// In en, this message translates to:
  /// **'Draws'**
  String get draws;

  /// No description provided for @nextXTournament.
  ///
  /// In en, this message translates to:
  /// **'Next {param} tournament:'**
  String nextXTournament(String param);

  /// No description provided for @averageOpponent.
  ///
  /// In en, this message translates to:
  /// **'Average opponent'**
  String get averageOpponent;

  /// No description provided for @boardEditor.
  ///
  /// In en, this message translates to:
  /// **'Board editor'**
  String get boardEditor;

  /// No description provided for @setTheBoard.
  ///
  /// In en, this message translates to:
  /// **'Set the board'**
  String get setTheBoard;

  /// No description provided for @popularOpenings.
  ///
  /// In en, this message translates to:
  /// **'Popular openings'**
  String get popularOpenings;

  /// No description provided for @endgamePositions.
  ///
  /// In en, this message translates to:
  /// **'Endgame positions'**
  String get endgamePositions;

  /// No description provided for @chess960StartPosition.
  ///
  /// In en, this message translates to:
  /// **'Chess960 start position: {param}'**
  String chess960StartPosition(String param);

  /// No description provided for @startPosition.
  ///
  /// In en, this message translates to:
  /// **'Starting position'**
  String get startPosition;

  /// No description provided for @clearBoard.
  ///
  /// In en, this message translates to:
  /// **'Clear board'**
  String get clearBoard;

  /// No description provided for @loadPosition.
  ///
  /// In en, this message translates to:
  /// **'Load position'**
  String get loadPosition;

  /// No description provided for @isPrivate.
  ///
  /// In en, this message translates to:
  /// **'Private'**
  String get isPrivate;

  /// No description provided for @reportXToModerators.
  ///
  /// In en, this message translates to:
  /// **'Report {param} to moderators'**
  String reportXToModerators(String param);

  /// No description provided for @profileCompletion.
  ///
  /// In en, this message translates to:
  /// **'Profile completion: {param}'**
  String profileCompletion(String param);

  /// No description provided for @xRating.
  ///
  /// In en, this message translates to:
  /// **'{param} rating'**
  String xRating(String param);

  /// No description provided for @ifNoneLeaveEmpty.
  ///
  /// In en, this message translates to:
  /// **'If none, leave empty'**
  String get ifNoneLeaveEmpty;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @editProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit profile'**
  String get editProfile;

  /// No description provided for @realName.
  ///
  /// In en, this message translates to:
  /// **'Real name'**
  String get realName;

  /// No description provided for @setFlair.
  ///
  /// In en, this message translates to:
  /// **'Set your flair'**
  String get setFlair;

  /// No description provided for @flair.
  ///
  /// In en, this message translates to:
  /// **'Flair'**
  String get flair;

  /// No description provided for @youCanHideFlair.
  ///
  /// In en, this message translates to:
  /// **'There is a setting to hide all user flairs across the entire site.'**
  String get youCanHideFlair;

  /// No description provided for @biography.
  ///
  /// In en, this message translates to:
  /// **'Biography'**
  String get biography;

  /// No description provided for @countryRegion.
  ///
  /// In en, this message translates to:
  /// **'Country or region'**
  String get countryRegion;

  /// No description provided for @thankYou.
  ///
  /// In en, this message translates to:
  /// **'Thank you!'**
  String get thankYou;

  /// No description provided for @socialMediaLinks.
  ///
  /// In en, this message translates to:
  /// **'Social media links'**
  String get socialMediaLinks;

  /// No description provided for @oneUrlPerLine.
  ///
  /// In en, this message translates to:
  /// **'One URL per line.'**
  String get oneUrlPerLine;

  /// No description provided for @inlineNotation.
  ///
  /// In en, this message translates to:
  /// **'Inline notation'**
  String get inlineNotation;

  /// No description provided for @makeAStudy.
  ///
  /// In en, this message translates to:
  /// **'For safekeeping and sharing, consider making a study.'**
  String get makeAStudy;

  /// No description provided for @clearSavedMoves.
  ///
  /// In en, this message translates to:
  /// **'Clear moves'**
  String get clearSavedMoves;

  /// No description provided for @previouslyOnLichessTV.
  ///
  /// In en, this message translates to:
  /// **'Previously on Lichess TV'**
  String get previouslyOnLichessTV;

  /// No description provided for @onlinePlayers.
  ///
  /// In en, this message translates to:
  /// **'Online players'**
  String get onlinePlayers;

  /// No description provided for @activePlayers.
  ///
  /// In en, this message translates to:
  /// **'Active players'**
  String get activePlayers;

  /// No description provided for @bewareTheGameIsRatedButHasNoClock.
  ///
  /// In en, this message translates to:
  /// **'Beware, the game is rated but has no clock!'**
  String get bewareTheGameIsRatedButHasNoClock;

  /// No description provided for @success.
  ///
  /// In en, this message translates to:
  /// **'Success'**
  String get success;

  /// No description provided for @automaticallyProceedToNextGameAfterMoving.
  ///
  /// In en, this message translates to:
  /// **'Automatically proceed to next game after moving'**
  String get automaticallyProceedToNextGameAfterMoving;

  /// No description provided for @autoSwitch.
  ///
  /// In en, this message translates to:
  /// **'Auto switch'**
  String get autoSwitch;

  /// No description provided for @puzzles.
  ///
  /// In en, this message translates to:
  /// **'Puzzles'**
  String get puzzles;

  /// No description provided for @onlineBots.
  ///
  /// In en, this message translates to:
  /// **'Online bots'**
  String get onlineBots;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// No description provided for @descPrivate.
  ///
  /// In en, this message translates to:
  /// **'Private description'**
  String get descPrivate;

  /// No description provided for @descPrivateHelp.
  ///
  /// In en, this message translates to:
  /// **'Text that only the team members will see. If set, replaces the public description for team members.'**
  String get descPrivateHelp;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No description provided for @website.
  ///
  /// In en, this message translates to:
  /// **'Website'**
  String get website;

  /// No description provided for @mobile.
  ///
  /// In en, this message translates to:
  /// **'Mobile'**
  String get mobile;

  /// No description provided for @help.
  ///
  /// In en, this message translates to:
  /// **'Help:'**
  String get help;

  /// No description provided for @createANewTopic.
  ///
  /// In en, this message translates to:
  /// **'Create a new topic'**
  String get createANewTopic;

  /// No description provided for @topics.
  ///
  /// In en, this message translates to:
  /// **'Topics'**
  String get topics;

  /// No description provided for @posts.
  ///
  /// In en, this message translates to:
  /// **'Posts'**
  String get posts;

  /// No description provided for @lastPost.
  ///
  /// In en, this message translates to:
  /// **'Last post'**
  String get lastPost;

  /// No description provided for @views.
  ///
  /// In en, this message translates to:
  /// **'Views'**
  String get views;

  /// No description provided for @replies.
  ///
  /// In en, this message translates to:
  /// **'Replies'**
  String get replies;

  /// No description provided for @replyToThisTopic.
  ///
  /// In en, this message translates to:
  /// **'Reply to this topic'**
  String get replyToThisTopic;

  /// No description provided for @reply.
  ///
  /// In en, this message translates to:
  /// **'Reply'**
  String get reply;

  /// No description provided for @message.
  ///
  /// In en, this message translates to:
  /// **'Message'**
  String get message;

  /// No description provided for @createTheTopic.
  ///
  /// In en, this message translates to:
  /// **'Create the topic'**
  String get createTheTopic;

  /// No description provided for @reportAUser.
  ///
  /// In en, this message translates to:
  /// **'Report a user'**
  String get reportAUser;

  /// No description provided for @user.
  ///
  /// In en, this message translates to:
  /// **'User'**
  String get user;

  /// No description provided for @reason.
  ///
  /// In en, this message translates to:
  /// **'Reason'**
  String get reason;

  /// No description provided for @whatIsIheMatter.
  ///
  /// In en, this message translates to:
  /// **'What\'s the matter?'**
  String get whatIsIheMatter;

  /// No description provided for @cheat.
  ///
  /// In en, this message translates to:
  /// **'Cheat'**
  String get cheat;

  /// No description provided for @troll.
  ///
  /// In en, this message translates to:
  /// **'Troll'**
  String get troll;

  /// No description provided for @other.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get other;

  /// No description provided for @reportCheatBoostHelp.
  ///
  /// In en, this message translates to:
  /// **'Paste the link to the game(s) and explain what is wrong about this user\'s behaviour. Don\'t just say \"they cheat\", but tell us how you came to this conclusion.'**
  String get reportCheatBoostHelp;

  /// No description provided for @reportUsernameHelp.
  ///
  /// In en, this message translates to:
  /// **'Explain what about this username is offensive. Don\'t just say \"it\'s offensive/inappropriate\", but tell us how you came to this conclusion, especially if the insult is obfuscated, not in english, is in slang, or is a historical/cultural reference.'**
  String get reportUsernameHelp;

  /// No description provided for @reportProcessedFasterInEnglish.
  ///
  /// In en, this message translates to:
  /// **'Your report will be processed faster if written in English.'**
  String get reportProcessedFasterInEnglish;

  /// No description provided for @error_provideOneCheatedGameLink.
  ///
  /// In en, this message translates to:
  /// **'Please provide at least one link to a cheated game.'**
  String get error_provideOneCheatedGameLink;

  /// No description provided for @by.
  ///
  /// In en, this message translates to:
  /// **'by {param}'**
  String by(String param);

  /// No description provided for @importedByX.
  ///
  /// In en, this message translates to:
  /// **'Imported by {param}'**
  String importedByX(String param);

  /// No description provided for @thisTopicIsNowClosed.
  ///
  /// In en, this message translates to:
  /// **'This topic is now closed.'**
  String get thisTopicIsNowClosed;

  /// No description provided for @blog.
  ///
  /// In en, this message translates to:
  /// **'Blog'**
  String get blog;

  /// No description provided for @notes.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get notes;

  /// No description provided for @typePrivateNotesHere.
  ///
  /// In en, this message translates to:
  /// **'Type private notes here'**
  String get typePrivateNotesHere;

  /// No description provided for @writeAPrivateNoteAboutThisUser.
  ///
  /// In en, this message translates to:
  /// **'Write a private note about this user'**
  String get writeAPrivateNoteAboutThisUser;

  /// No description provided for @noNoteYet.
  ///
  /// In en, this message translates to:
  /// **'No note yet'**
  String get noNoteYet;

  /// No description provided for @invalidUsernameOrPassword.
  ///
  /// In en, this message translates to:
  /// **'Invalid username or password'**
  String get invalidUsernameOrPassword;

  /// No description provided for @incorrectPassword.
  ///
  /// In en, this message translates to:
  /// **'Incorrect password'**
  String get incorrectPassword;

  /// No description provided for @invalidAuthenticationCode.
  ///
  /// In en, this message translates to:
  /// **'Invalid authentication code'**
  String get invalidAuthenticationCode;

  /// No description provided for @emailMeALink.
  ///
  /// In en, this message translates to:
  /// **'Email me a link'**
  String get emailMeALink;

  /// No description provided for @currentPassword.
  ///
  /// In en, this message translates to:
  /// **'Current password'**
  String get currentPassword;

  /// No description provided for @newPassword.
  ///
  /// In en, this message translates to:
  /// **'New password'**
  String get newPassword;

  /// No description provided for @newPasswordAgain.
  ///
  /// In en, this message translates to:
  /// **'New password (again)'**
  String get newPasswordAgain;

  /// No description provided for @newPasswordsDontMatch.
  ///
  /// In en, this message translates to:
  /// **'The new passwords don\'t match'**
  String get newPasswordsDontMatch;

  /// No description provided for @newPasswordStrength.
  ///
  /// In en, this message translates to:
  /// **'Password strength'**
  String get newPasswordStrength;

  /// No description provided for @clockInitialTime.
  ///
  /// In en, this message translates to:
  /// **'Clock initial time'**
  String get clockInitialTime;

  /// No description provided for @clockIncrement.
  ///
  /// In en, this message translates to:
  /// **'Clock increment'**
  String get clockIncrement;

  /// No description provided for @privacy.
  ///
  /// In en, this message translates to:
  /// **'Privacy'**
  String get privacy;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy policy'**
  String get privacyPolicy;

  /// No description provided for @letOtherPlayersFollowYou.
  ///
  /// In en, this message translates to:
  /// **'Let other players follow you'**
  String get letOtherPlayersFollowYou;

  /// No description provided for @letOtherPlayersChallengeYou.
  ///
  /// In en, this message translates to:
  /// **'Let other players challenge you'**
  String get letOtherPlayersChallengeYou;

  /// No description provided for @letOtherPlayersInviteYouToStudy.
  ///
  /// In en, this message translates to:
  /// **'Let other players invite you to study'**
  String get letOtherPlayersInviteYouToStudy;

  /// No description provided for @sound.
  ///
  /// In en, this message translates to:
  /// **'Sound'**
  String get sound;

  /// No description provided for @none.
  ///
  /// In en, this message translates to:
  /// **'None'**
  String get none;

  /// No description provided for @fast.
  ///
  /// In en, this message translates to:
  /// **'Fast'**
  String get fast;

  /// No description provided for @normal.
  ///
  /// In en, this message translates to:
  /// **'Normal'**
  String get normal;

  /// No description provided for @slow.
  ///
  /// In en, this message translates to:
  /// **'Slow'**
  String get slow;

  /// No description provided for @insideTheBoard.
  ///
  /// In en, this message translates to:
  /// **'Inside the board'**
  String get insideTheBoard;

  /// No description provided for @outsideTheBoard.
  ///
  /// In en, this message translates to:
  /// **'Outside the board'**
  String get outsideTheBoard;

  /// No description provided for @allSquaresOfTheBoard.
  ///
  /// In en, this message translates to:
  /// **'All squares of the board'**
  String get allSquaresOfTheBoard;

  /// No description provided for @onSlowGames.
  ///
  /// In en, this message translates to:
  /// **'On slow games'**
  String get onSlowGames;

  /// No description provided for @always.
  ///
  /// In en, this message translates to:
  /// **'Always'**
  String get always;

  /// No description provided for @never.
  ///
  /// In en, this message translates to:
  /// **'Never'**
  String get never;

  /// No description provided for @xCompetesInY.
  ///
  /// In en, this message translates to:
  /// **'{param1} competes in {param2}'**
  String xCompetesInY(String param1, String param2);

  /// No description provided for @victory.
  ///
  /// In en, this message translates to:
  /// **'Victory'**
  String get victory;

  /// No description provided for @defeat.
  ///
  /// In en, this message translates to:
  /// **'Defeat'**
  String get defeat;

  /// No description provided for @victoryVsYInZ.
  ///
  /// In en, this message translates to:
  /// **'{param1} vs {param2} in {param3}'**
  String victoryVsYInZ(String param1, String param2, String param3);

  /// No description provided for @defeatVsYInZ.
  ///
  /// In en, this message translates to:
  /// **'{param1} vs {param2} in {param3}'**
  String defeatVsYInZ(String param1, String param2, String param3);

  /// No description provided for @drawVsYInZ.
  ///
  /// In en, this message translates to:
  /// **'{param1} vs {param2} in {param3}'**
  String drawVsYInZ(String param1, String param2, String param3);

  /// No description provided for @timeline.
  ///
  /// In en, this message translates to:
  /// **'Timeline'**
  String get timeline;

  /// No description provided for @starting.
  ///
  /// In en, this message translates to:
  /// **'Starting:'**
  String get starting;

  /// No description provided for @allInformationIsPublicAndOptional.
  ///
  /// In en, this message translates to:
  /// **'All information is public and optional.'**
  String get allInformationIsPublicAndOptional;

  /// No description provided for @biographyDescription.
  ///
  /// In en, this message translates to:
  /// **'Talk about yourself, your interests, what you like in chess, your favourite openings, players, ...'**
  String get biographyDescription;

  /// No description provided for @listBlockedPlayers.
  ///
  /// In en, this message translates to:
  /// **'List players you have blocked'**
  String get listBlockedPlayers;

  /// No description provided for @human.
  ///
  /// In en, this message translates to:
  /// **'Human'**
  String get human;

  /// No description provided for @computer.
  ///
  /// In en, this message translates to:
  /// **'Computer'**
  String get computer;

  /// No description provided for @side.
  ///
  /// In en, this message translates to:
  /// **'Side'**
  String get side;

  /// No description provided for @clock.
  ///
  /// In en, this message translates to:
  /// **'Clock'**
  String get clock;

  /// No description provided for @opponent.
  ///
  /// In en, this message translates to:
  /// **'Opponent'**
  String get opponent;

  /// No description provided for @learnMenu.
  ///
  /// In en, this message translates to:
  /// **'Learn'**
  String get learnMenu;

  /// No description provided for @studyMenu.
  ///
  /// In en, this message translates to:
  /// **'Study'**
  String get studyMenu;

  /// No description provided for @practice.
  ///
  /// In en, this message translates to:
  /// **'Practice'**
  String get practice;

  /// No description provided for @community.
  ///
  /// In en, this message translates to:
  /// **'Community'**
  String get community;

  /// No description provided for @tools.
  ///
  /// In en, this message translates to:
  /// **'Tools'**
  String get tools;

  /// No description provided for @increment.
  ///
  /// In en, this message translates to:
  /// **'Increment'**
  String get increment;

  /// No description provided for @error_unknown.
  ///
  /// In en, this message translates to:
  /// **'Invalid value'**
  String get error_unknown;

  /// No description provided for @error_required.
  ///
  /// In en, this message translates to:
  /// **'This field is required'**
  String get error_required;

  /// No description provided for @error_email.
  ///
  /// In en, this message translates to:
  /// **'This email address is invalid'**
  String get error_email;

  /// No description provided for @error_email_acceptable.
  ///
  /// In en, this message translates to:
  /// **'This email address is not acceptable. Please double-check it, and try again.'**
  String get error_email_acceptable;

  /// No description provided for @error_email_unique.
  ///
  /// In en, this message translates to:
  /// **'Email address invalid or already taken'**
  String get error_email_unique;

  /// No description provided for @error_email_different.
  ///
  /// In en, this message translates to:
  /// **'This is already your email address'**
  String get error_email_different;

  /// No description provided for @error_minLength.
  ///
  /// In en, this message translates to:
  /// **'Must be at least {param} characters long'**
  String error_minLength(String param);

  /// No description provided for @error_maxLength.
  ///
  /// In en, this message translates to:
  /// **'Must be at most {param} characters long'**
  String error_maxLength(String param);

  /// No description provided for @error_min.
  ///
  /// In en, this message translates to:
  /// **'Must be at least {param}'**
  String error_min(String param);

  /// No description provided for @error_max.
  ///
  /// In en, this message translates to:
  /// **'Must be at most {param}'**
  String error_max(String param);

  /// No description provided for @ifRatingIsPlusMinusX.
  ///
  /// In en, this message translates to:
  /// **'If rating is ± {param}'**
  String ifRatingIsPlusMinusX(String param);

  /// No description provided for @ifRegistered.
  ///
  /// In en, this message translates to:
  /// **'If registered'**
  String get ifRegistered;

  /// No description provided for @onlyExistingConversations.
  ///
  /// In en, this message translates to:
  /// **'Only existing conversations'**
  String get onlyExistingConversations;

  /// No description provided for @onlyFriends.
  ///
  /// In en, this message translates to:
  /// **'Only friends'**
  String get onlyFriends;

  /// No description provided for @menu.
  ///
  /// In en, this message translates to:
  /// **'Menu'**
  String get menu;

  /// No description provided for @castling.
  ///
  /// In en, this message translates to:
  /// **'Castling'**
  String get castling;

  /// No description provided for @whiteCastlingKingside.
  ///
  /// In en, this message translates to:
  /// **'White O-O'**
  String get whiteCastlingKingside;

  /// No description provided for @blackCastlingKingside.
  ///
  /// In en, this message translates to:
  /// **'Black O-O'**
  String get blackCastlingKingside;

  /// No description provided for @tpTimeSpentPlaying.
  ///
  /// In en, this message translates to:
  /// **'Time spent playing: {param}'**
  String tpTimeSpentPlaying(String param);

  /// No description provided for @watchGames.
  ///
  /// In en, this message translates to:
  /// **'Watch games'**
  String get watchGames;

  /// No description provided for @tpTimeSpentOnTV.
  ///
  /// In en, this message translates to:
  /// **'Time featured on TV: {param}'**
  String tpTimeSpentOnTV(String param);

  /// No description provided for @watch.
  ///
  /// In en, this message translates to:
  /// **'Watch'**
  String get watch;

  /// No description provided for @videoLibrary.
  ///
  /// In en, this message translates to:
  /// **'Video library'**
  String get videoLibrary;

  /// No description provided for @streamersMenu.
  ///
  /// In en, this message translates to:
  /// **'Streamers'**
  String get streamersMenu;

  /// No description provided for @mobileApp.
  ///
  /// In en, this message translates to:
  /// **'Mobile App'**
  String get mobileApp;

  /// No description provided for @webmasters.
  ///
  /// In en, this message translates to:
  /// **'Webmasters'**
  String get webmasters;

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// No description provided for @aboutX.
  ///
  /// In en, this message translates to:
  /// **'About {param}'**
  String aboutX(String param);

  /// No description provided for @xIsAFreeYLibreOpenSourceChessServer.
  ///
  /// In en, this message translates to:
  /// **'{param1} is a free ({param2}), libre, no-ads, open source chess server.'**
  String xIsAFreeYLibreOpenSourceChessServer(String param1, String param2);

  /// No description provided for @really.
  ///
  /// In en, this message translates to:
  /// **'really'**
  String get really;

  /// No description provided for @contribute.
  ///
  /// In en, this message translates to:
  /// **'Contribute'**
  String get contribute;

  /// No description provided for @termsOfService.
  ///
  /// In en, this message translates to:
  /// **'Terms of Service'**
  String get termsOfService;

  /// No description provided for @sourceCode.
  ///
  /// In en, this message translates to:
  /// **'Source Code'**
  String get sourceCode;

  /// No description provided for @simultaneousExhibitions.
  ///
  /// In en, this message translates to:
  /// **'Simultaneous exhibitions'**
  String get simultaneousExhibitions;

  /// No description provided for @host.
  ///
  /// In en, this message translates to:
  /// **'Host'**
  String get host;

  /// No description provided for @hostColorX.
  ///
  /// In en, this message translates to:
  /// **'Host colour: {param}'**
  String hostColorX(String param);

  /// No description provided for @yourPendingSimuls.
  ///
  /// In en, this message translates to:
  /// **'Your pending simuls'**
  String get yourPendingSimuls;

  /// No description provided for @createdSimuls.
  ///
  /// In en, this message translates to:
  /// **'Newly created simuls'**
  String get createdSimuls;

  /// No description provided for @hostANewSimul.
  ///
  /// In en, this message translates to:
  /// **'Host a new simul'**
  String get hostANewSimul;

  /// No description provided for @signUpToHostOrJoinASimul.
  ///
  /// In en, this message translates to:
  /// **'Sign up to host or join a simul'**
  String get signUpToHostOrJoinASimul;

  /// No description provided for @noSimulFound.
  ///
  /// In en, this message translates to:
  /// **'Simul not found'**
  String get noSimulFound;

  /// No description provided for @noSimulExplanation.
  ///
  /// In en, this message translates to:
  /// **'This simultaneous exhibition does not exist.'**
  String get noSimulExplanation;

  /// No description provided for @returnToSimulHomepage.
  ///
  /// In en, this message translates to:
  /// **'Return to simul homepage'**
  String get returnToSimulHomepage;

  /// No description provided for @aboutSimul.
  ///
  /// In en, this message translates to:
  /// **'Simuls involve a single player facing several players at once.'**
  String get aboutSimul;

  /// No description provided for @aboutSimulImage.
  ///
  /// In en, this message translates to:
  /// **'Out of 50 opponents, Fischer won 47 games, drew 2 and lost 1.'**
  String get aboutSimulImage;

  /// No description provided for @aboutSimulRealLife.
  ///
  /// In en, this message translates to:
  /// **'The concept is taken from real world events. In real life, this involves the simul host moving from table to table to play a single move.'**
  String get aboutSimulRealLife;

  /// No description provided for @aboutSimulRules.
  ///
  /// In en, this message translates to:
  /// **'When the simul starts, every player starts a game with the host. The simul ends when all games are complete.'**
  String get aboutSimulRules;

  /// No description provided for @aboutSimulSettings.
  ///
  /// In en, this message translates to:
  /// **'Simuls are always casual. Rematches, takebacks and adding time are disabled.'**
  String get aboutSimulSettings;

  /// No description provided for @create.
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get create;

  /// No description provided for @whenCreateSimul.
  ///
  /// In en, this message translates to:
  /// **'When you create a Simul, you get to play several players at once.'**
  String get whenCreateSimul;

  /// No description provided for @simulVariantsHint.
  ///
  /// In en, this message translates to:
  /// **'If you select several variants, each player gets to choose which one to play.'**
  String get simulVariantsHint;

  /// No description provided for @simulClockHint.
  ///
  /// In en, this message translates to:
  /// **'Fischer Clock setup. The more players you take on, the more time you may need.'**
  String get simulClockHint;

  /// No description provided for @simulAddExtraTime.
  ///
  /// In en, this message translates to:
  /// **'You may add extra initial time to your clock to help you cope with the simul.'**
  String get simulAddExtraTime;

  /// No description provided for @simulHostExtraTime.
  ///
  /// In en, this message translates to:
  /// **'Host extra initial clock time'**
  String get simulHostExtraTime;

  /// No description provided for @simulAddExtraTimePerPlayer.
  ///
  /// In en, this message translates to:
  /// **'Add initial time to your clock for each player joining the simul.'**
  String get simulAddExtraTimePerPlayer;

  /// No description provided for @simulHostExtraTimePerPlayer.
  ///
  /// In en, this message translates to:
  /// **'Host extra clock time per player'**
  String get simulHostExtraTimePerPlayer;

  /// No description provided for @lichessTournaments.
  ///
  /// In en, this message translates to:
  /// **'Lichess tournaments'**
  String get lichessTournaments;

  /// No description provided for @tournamentFAQ.
  ///
  /// In en, this message translates to:
  /// **'Arena tournament FAQ'**
  String get tournamentFAQ;

  /// No description provided for @timeBeforeTournamentStarts.
  ///
  /// In en, this message translates to:
  /// **'Time before tournament starts'**
  String get timeBeforeTournamentStarts;

  /// No description provided for @averageCentipawnLoss.
  ///
  /// In en, this message translates to:
  /// **'Average centipawn loss'**
  String get averageCentipawnLoss;

  /// No description provided for @accuracy.
  ///
  /// In en, this message translates to:
  /// **'Accuracy'**
  String get accuracy;

  /// No description provided for @keyboardShortcuts.
  ///
  /// In en, this message translates to:
  /// **'Keyboard shortcuts'**
  String get keyboardShortcuts;

  /// No description provided for @keyMoveBackwardOrForward.
  ///
  /// In en, this message translates to:
  /// **'move backward/forward'**
  String get keyMoveBackwardOrForward;

  /// No description provided for @keyGoToStartOrEnd.
  ///
  /// In en, this message translates to:
  /// **'go to start/end'**
  String get keyGoToStartOrEnd;

  /// No description provided for @keyCycleSelectedVariation.
  ///
  /// In en, this message translates to:
  /// **'Cycle selected variation'**
  String get keyCycleSelectedVariation;

  /// No description provided for @keyShowOrHideComments.
  ///
  /// In en, this message translates to:
  /// **'show/hide comments'**
  String get keyShowOrHideComments;

  /// No description provided for @keyEnterOrExitVariation.
  ///
  /// In en, this message translates to:
  /// **'enter/exit variation'**
  String get keyEnterOrExitVariation;

  /// No description provided for @keyRequestComputerAnalysis.
  ///
  /// In en, this message translates to:
  /// **'Request computer analysis, Learn from your mistakes'**
  String get keyRequestComputerAnalysis;

  /// No description provided for @keyNextLearnFromYourMistakes.
  ///
  /// In en, this message translates to:
  /// **'Next (Learn from your mistakes)'**
  String get keyNextLearnFromYourMistakes;

  /// No description provided for @keyNextBlunder.
  ///
  /// In en, this message translates to:
  /// **'Next blunder'**
  String get keyNextBlunder;

  /// No description provided for @keyNextMistake.
  ///
  /// In en, this message translates to:
  /// **'Next mistake'**
  String get keyNextMistake;

  /// No description provided for @keyNextInaccuracy.
  ///
  /// In en, this message translates to:
  /// **'Next inaccuracy'**
  String get keyNextInaccuracy;

  /// No description provided for @keyPreviousBranch.
  ///
  /// In en, this message translates to:
  /// **'Previous branch'**
  String get keyPreviousBranch;

  /// No description provided for @keyNextBranch.
  ///
  /// In en, this message translates to:
  /// **'Next branch'**
  String get keyNextBranch;

  /// No description provided for @toggleVariationArrows.
  ///
  /// In en, this message translates to:
  /// **'Toggle variation arrows'**
  String get toggleVariationArrows;

  /// No description provided for @cyclePreviousOrNextVariation.
  ///
  /// In en, this message translates to:
  /// **'Cycle previous/next variation'**
  String get cyclePreviousOrNextVariation;

  /// No description provided for @toggleGlyphAnnotations.
  ///
  /// In en, this message translates to:
  /// **'Toggle move annotations'**
  String get toggleGlyphAnnotations;

  /// No description provided for @togglePositionAnnotations.
  ///
  /// In en, this message translates to:
  /// **'Toggle position annotations'**
  String get togglePositionAnnotations;

  /// No description provided for @variationArrowsInfo.
  ///
  /// In en, this message translates to:
  /// **'Variation arrows let you navigate without using the move list.'**
  String get variationArrowsInfo;

  /// No description provided for @playSelectedMove.
  ///
  /// In en, this message translates to:
  /// **'play selected move'**
  String get playSelectedMove;

  /// No description provided for @newTournament.
  ///
  /// In en, this message translates to:
  /// **'New tournament'**
  String get newTournament;

  /// No description provided for @tournamentHomeTitle.
  ///
  /// In en, this message translates to:
  /// **'Chess tournaments featuring various time controls and variants'**
  String get tournamentHomeTitle;

  /// No description provided for @tournamentHomeDescription.
  ///
  /// In en, this message translates to:
  /// **'Play fast-paced chess tournaments! Join an official scheduled tournament, or create your own. Bullet, Blitz, Classical, Chess960, King of the Hill, Threecheck, and more options available for endless chess fun.'**
  String get tournamentHomeDescription;

  /// No description provided for @tournamentNotFound.
  ///
  /// In en, this message translates to:
  /// **'Tournament not found'**
  String get tournamentNotFound;

  /// No description provided for @tournamentDoesNotExist.
  ///
  /// In en, this message translates to:
  /// **'This tournament does not exist.'**
  String get tournamentDoesNotExist;

  /// No description provided for @tournamentMayHaveBeenCanceled.
  ///
  /// In en, this message translates to:
  /// **'The tournament may have been cancelled if all players left before it started.'**
  String get tournamentMayHaveBeenCanceled;

  /// No description provided for @returnToTournamentsHomepage.
  ///
  /// In en, this message translates to:
  /// **'Return to tournaments homepage'**
  String get returnToTournamentsHomepage;

  /// No description provided for @weeklyPerfTypeRatingDistribution.
  ///
  /// In en, this message translates to:
  /// **'Weekly {param} rating distribution'**
  String weeklyPerfTypeRatingDistribution(String param);

  /// No description provided for @yourPerfTypeRatingIsRating.
  ///
  /// In en, this message translates to:
  /// **'Your {param1} rating is {param2}.'**
  String yourPerfTypeRatingIsRating(String param1, String param2);

  /// No description provided for @youAreBetterThanPercentOfPerfTypePlayers.
  ///
  /// In en, this message translates to:
  /// **'You are better than {param1} of {param2} players.'**
  String youAreBetterThanPercentOfPerfTypePlayers(String param1, String param2);

  /// No description provided for @userIsBetterThanPercentOfPerfTypePlayers.
  ///
  /// In en, this message translates to:
  /// **'{param1} is better than {param2} of {param3} players.'**
  String userIsBetterThanPercentOfPerfTypePlayers(String param1, String param2, String param3);

  /// No description provided for @betterThanPercentPlayers.
  ///
  /// In en, this message translates to:
  /// **'Better than {param1} of {param2} players'**
  String betterThanPercentPlayers(String param1, String param2);

  /// No description provided for @youDoNotHaveAnEstablishedPerfTypeRating.
  ///
  /// In en, this message translates to:
  /// **'You do not have an established {param} rating.'**
  String youDoNotHaveAnEstablishedPerfTypeRating(String param);

  /// No description provided for @yourRating.
  ///
  /// In en, this message translates to:
  /// **'Your rating'**
  String get yourRating;

  /// No description provided for @cumulative.
  ///
  /// In en, this message translates to:
  /// **'Cumulative'**
  String get cumulative;

  /// No description provided for @glicko2Rating.
  ///
  /// In en, this message translates to:
  /// **'Glicko-2 rating'**
  String get glicko2Rating;

  /// No description provided for @checkYourEmail.
  ///
  /// In en, this message translates to:
  /// **'Check your Email'**
  String get checkYourEmail;

  /// No description provided for @weHaveSentYouAnEmailClickTheLink.
  ///
  /// In en, this message translates to:
  /// **'We\'ve sent you an email. Click the link in the email to activate your account.'**
  String get weHaveSentYouAnEmailClickTheLink;

  /// No description provided for @ifYouDoNotSeeTheEmailCheckOtherPlaces.
  ///
  /// In en, this message translates to:
  /// **'If you don\'t see the email, check other places it might be, like your junk, spam, social, or other folders.'**
  String get ifYouDoNotSeeTheEmailCheckOtherPlaces;

  /// No description provided for @weHaveSentYouAnEmailTo.
  ///
  /// In en, this message translates to:
  /// **'We\'ve sent an email to {param}. Click the link in the email to reset your password.'**
  String weHaveSentYouAnEmailTo(String param);

  /// No description provided for @byRegisteringYouAgreeToBeBoundByOur.
  ///
  /// In en, this message translates to:
  /// **'By registering, you agree to the {param}.'**
  String byRegisteringYouAgreeToBeBoundByOur(String param);

  /// No description provided for @readAboutOur.
  ///
  /// In en, this message translates to:
  /// **'Read about our {param}.'**
  String readAboutOur(String param);

  /// No description provided for @networkLagBetweenYouAndLichess.
  ///
  /// In en, this message translates to:
  /// **'Network lag between you and Lichess'**
  String get networkLagBetweenYouAndLichess;

  /// No description provided for @timeToProcessAMoveOnLichessServer.
  ///
  /// In en, this message translates to:
  /// **'Time to process a move on Lichess\'s server'**
  String get timeToProcessAMoveOnLichessServer;

  /// No description provided for @downloadAnnotated.
  ///
  /// In en, this message translates to:
  /// **'Download annotated'**
  String get downloadAnnotated;

  /// No description provided for @downloadRaw.
  ///
  /// In en, this message translates to:
  /// **'Download raw'**
  String get downloadRaw;

  /// No description provided for @downloadImported.
  ///
  /// In en, this message translates to:
  /// **'Download imported'**
  String get downloadImported;

  /// No description provided for @crosstable.
  ///
  /// In en, this message translates to:
  /// **'Crosstable'**
  String get crosstable;

  /// No description provided for @youCanAlsoScrollOverTheBoardToMoveInTheGame.
  ///
  /// In en, this message translates to:
  /// **'Scroll over the board to move in the game.'**
  String get youCanAlsoScrollOverTheBoardToMoveInTheGame;

  /// No description provided for @scrollOverComputerVariationsToPreviewThem.
  ///
  /// In en, this message translates to:
  /// **'Scroll over computer variations to preview them.'**
  String get scrollOverComputerVariationsToPreviewThem;

  /// No description provided for @analysisShapesHowTo.
  ///
  /// In en, this message translates to:
  /// **'Press shift+click or right-click to draw circles and arrows on the board.'**
  String get analysisShapesHowTo;

  /// No description provided for @letOtherPlayersMessageYou.
  ///
  /// In en, this message translates to:
  /// **'Let other players message you'**
  String get letOtherPlayersMessageYou;

  /// No description provided for @receiveForumNotifications.
  ///
  /// In en, this message translates to:
  /// **'Receive notifications when mentioned in the forum'**
  String get receiveForumNotifications;

  /// No description provided for @shareYourInsightsData.
  ///
  /// In en, this message translates to:
  /// **'Share your chess insights data'**
  String get shareYourInsightsData;

  /// No description provided for @withNobody.
  ///
  /// In en, this message translates to:
  /// **'With nobody'**
  String get withNobody;

  /// No description provided for @withFriends.
  ///
  /// In en, this message translates to:
  /// **'With friends'**
  String get withFriends;

  /// No description provided for @withEverybody.
  ///
  /// In en, this message translates to:
  /// **'With everybody'**
  String get withEverybody;

  /// No description provided for @kidMode.
  ///
  /// In en, this message translates to:
  /// **'Kid mode'**
  String get kidMode;

  /// No description provided for @kidModeIsEnabled.
  ///
  /// In en, this message translates to:
  /// **'Kid mode is enabled.'**
  String get kidModeIsEnabled;

  /// No description provided for @kidModeExplanation.
  ///
  /// In en, this message translates to:
  /// **'This is about safety. In kid mode, all site communications are disabled. Enable this for your children and school students, to protect them from other internet users.'**
  String get kidModeExplanation;

  /// No description provided for @inKidModeTheLichessLogoGetsIconX.
  ///
  /// In en, this message translates to:
  /// **'In kid mode, the Lichess logo gets a {param} icon, so you know your kids are safe.'**
  String inKidModeTheLichessLogoGetsIconX(String param);

  /// No description provided for @askYourChessTeacherAboutLiftingKidMode.
  ///
  /// In en, this message translates to:
  /// **'Your account is managed. Ask your chess teacher about lifting kid mode.'**
  String get askYourChessTeacherAboutLiftingKidMode;

  /// No description provided for @enableKidMode.
  ///
  /// In en, this message translates to:
  /// **'Enable Kid mode'**
  String get enableKidMode;

  /// No description provided for @disableKidMode.
  ///
  /// In en, this message translates to:
  /// **'Disable Kid mode'**
  String get disableKidMode;

  /// No description provided for @security.
  ///
  /// In en, this message translates to:
  /// **'Security'**
  String get security;

  /// No description provided for @sessions.
  ///
  /// In en, this message translates to:
  /// **'Sessions'**
  String get sessions;

  /// No description provided for @revokeAllSessions.
  ///
  /// In en, this message translates to:
  /// **'revoke all sessions'**
  String get revokeAllSessions;

  /// No description provided for @playChessEverywhere.
  ///
  /// In en, this message translates to:
  /// **'Play chess everywhere'**
  String get playChessEverywhere;

  /// No description provided for @everybodyGetsAllFeaturesForFree.
  ///
  /// In en, this message translates to:
  /// **'Everybody gets all features for free'**
  String get everybodyGetsAllFeaturesForFree;

  /// No description provided for @viewTheSolution.
  ///
  /// In en, this message translates to:
  /// **'View the solution'**
  String get viewTheSolution;

  /// No description provided for @noChallenges.
  ///
  /// In en, this message translates to:
  /// **'No challenges.'**
  String get noChallenges;

  /// No description provided for @xHostsY.
  ///
  /// In en, this message translates to:
  /// **'{param1} hosts {param2}'**
  String xHostsY(String param1, String param2);

  /// No description provided for @xJoinsY.
  ///
  /// In en, this message translates to:
  /// **'{param1} joins {param2}'**
  String xJoinsY(String param1, String param2);

  /// No description provided for @xLikesY.
  ///
  /// In en, this message translates to:
  /// **'{param1} likes {param2}'**
  String xLikesY(String param1, String param2);

  /// No description provided for @quickPairing.
  ///
  /// In en, this message translates to:
  /// **'Quick pairing'**
  String get quickPairing;

  /// No description provided for @lobby.
  ///
  /// In en, this message translates to:
  /// **'Lobby'**
  String get lobby;

  /// No description provided for @anonymous.
  ///
  /// In en, this message translates to:
  /// **'Anonymous'**
  String get anonymous;

  /// No description provided for @yourScore.
  ///
  /// In en, this message translates to:
  /// **'Your score: {param}'**
  String yourScore(String param);

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @background.
  ///
  /// In en, this message translates to:
  /// **'Background'**
  String get background;

  /// No description provided for @light.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get light;

  /// No description provided for @dark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get dark;

  /// No description provided for @transparent.
  ///
  /// In en, this message translates to:
  /// **'Transparent'**
  String get transparent;

  /// No description provided for @deviceTheme.
  ///
  /// In en, this message translates to:
  /// **'Device theme'**
  String get deviceTheme;

  /// No description provided for @backgroundImageUrl.
  ///
  /// In en, this message translates to:
  /// **'Background image URL:'**
  String get backgroundImageUrl;

  /// No description provided for @board.
  ///
  /// In en, this message translates to:
  /// **'Board'**
  String get board;

  /// No description provided for @size.
  ///
  /// In en, this message translates to:
  /// **'Size'**
  String get size;

  /// No description provided for @opacity.
  ///
  /// In en, this message translates to:
  /// **'Opacity'**
  String get opacity;

  /// No description provided for @brightness.
  ///
  /// In en, this message translates to:
  /// **'Brightness'**
  String get brightness;

  /// No description provided for @hue.
  ///
  /// In en, this message translates to:
  /// **'Hue'**
  String get hue;

  /// No description provided for @boardReset.
  ///
  /// In en, this message translates to:
  /// **'Reset colours to default'**
  String get boardReset;

  /// No description provided for @pieceSet.
  ///
  /// In en, this message translates to:
  /// **'Piece set'**
  String get pieceSet;

  /// No description provided for @embedInYourWebsite.
  ///
  /// In en, this message translates to:
  /// **'Embed in your website'**
  String get embedInYourWebsite;

  /// No description provided for @usernameAlreadyUsed.
  ///
  /// In en, this message translates to:
  /// **'This username is already in use, please try another one.'**
  String get usernameAlreadyUsed;

  /// No description provided for @usernamePrefixInvalid.
  ///
  /// In en, this message translates to:
  /// **'The username must start with a letter.'**
  String get usernamePrefixInvalid;

  /// No description provided for @usernameSuffixInvalid.
  ///
  /// In en, this message translates to:
  /// **'The username must end with a letter or a number.'**
  String get usernameSuffixInvalid;

  /// No description provided for @usernameCharsInvalid.
  ///
  /// In en, this message translates to:
  /// **'The username must only contain letters, numbers, underscores, and hyphens. Consecutive underscores and hyphens are not allowed.'**
  String get usernameCharsInvalid;

  /// No description provided for @usernameUnacceptable.
  ///
  /// In en, this message translates to:
  /// **'This username is not acceptable.'**
  String get usernameUnacceptable;

  /// No description provided for @playChessInStyle.
  ///
  /// In en, this message translates to:
  /// **'Play chess in style'**
  String get playChessInStyle;

  /// No description provided for @chessBasics.
  ///
  /// In en, this message translates to:
  /// **'Chess basics'**
  String get chessBasics;

  /// No description provided for @coaches.
  ///
  /// In en, this message translates to:
  /// **'Coaches'**
  String get coaches;

  /// No description provided for @invalidPgn.
  ///
  /// In en, this message translates to:
  /// **'Invalid PGN'**
  String get invalidPgn;

  /// No description provided for @invalidFen.
  ///
  /// In en, this message translates to:
  /// **'Invalid FEN'**
  String get invalidFen;

  /// No description provided for @custom.
  ///
  /// In en, this message translates to:
  /// **'Custom'**
  String get custom;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @notificationsX.
  ///
  /// In en, this message translates to:
  /// **'Notifications: {param1}'**
  String notificationsX(String param1);

  /// No description provided for @perfRatingX.
  ///
  /// In en, this message translates to:
  /// **'Rating: {param}'**
  String perfRatingX(String param);

  /// No description provided for @practiceWithComputer.
  ///
  /// In en, this message translates to:
  /// **'Practice with computer'**
  String get practiceWithComputer;

  /// No description provided for @anotherWasX.
  ///
  /// In en, this message translates to:
  /// **'Another was {param}'**
  String anotherWasX(String param);

  /// No description provided for @bestWasX.
  ///
  /// In en, this message translates to:
  /// **'Best was {param}'**
  String bestWasX(String param);

  /// No description provided for @youBrowsedAway.
  ///
  /// In en, this message translates to:
  /// **'You browsed away'**
  String get youBrowsedAway;

  /// No description provided for @resumePractice.
  ///
  /// In en, this message translates to:
  /// **'Resume practice'**
  String get resumePractice;

  /// No description provided for @drawByFiftyMoves.
  ///
  /// In en, this message translates to:
  /// **'The game has been drawn by the fifty move rule.'**
  String get drawByFiftyMoves;

  /// No description provided for @theGameIsADraw.
  ///
  /// In en, this message translates to:
  /// **'The game is a draw.'**
  String get theGameIsADraw;

  /// No description provided for @computerThinking.
  ///
  /// In en, this message translates to:
  /// **'Computer thinking ...'**
  String get computerThinking;

  /// No description provided for @seeBestMove.
  ///
  /// In en, this message translates to:
  /// **'See best move'**
  String get seeBestMove;

  /// No description provided for @hideBestMove.
  ///
  /// In en, this message translates to:
  /// **'Hide best move'**
  String get hideBestMove;

  /// No description provided for @getAHint.
  ///
  /// In en, this message translates to:
  /// **'Get a hint'**
  String get getAHint;

  /// No description provided for @evaluatingYourMove.
  ///
  /// In en, this message translates to:
  /// **'Evaluating your move ...'**
  String get evaluatingYourMove;

  /// No description provided for @whiteWinsGame.
  ///
  /// In en, this message translates to:
  /// **'White wins'**
  String get whiteWinsGame;

  /// No description provided for @blackWinsGame.
  ///
  /// In en, this message translates to:
  /// **'Black wins'**
  String get blackWinsGame;

  /// No description provided for @learnFromYourMistakes.
  ///
  /// In en, this message translates to:
  /// **'Learn from your mistakes'**
  String get learnFromYourMistakes;

  /// No description provided for @learnFromThisMistake.
  ///
  /// In en, this message translates to:
  /// **'Learn from this mistake'**
  String get learnFromThisMistake;

  /// No description provided for @skipThisMove.
  ///
  /// In en, this message translates to:
  /// **'Skip this move'**
  String get skipThisMove;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @xWasPlayed.
  ///
  /// In en, this message translates to:
  /// **'{param} was played'**
  String xWasPlayed(String param);

  /// No description provided for @findBetterMoveForWhite.
  ///
  /// In en, this message translates to:
  /// **'Find a better move for white'**
  String get findBetterMoveForWhite;

  /// No description provided for @findBetterMoveForBlack.
  ///
  /// In en, this message translates to:
  /// **'Find a better move for black'**
  String get findBetterMoveForBlack;

  /// No description provided for @resumeLearning.
  ///
  /// In en, this message translates to:
  /// **'Resume learning'**
  String get resumeLearning;

  /// No description provided for @youCanDoBetter.
  ///
  /// In en, this message translates to:
  /// **'You can do better'**
  String get youCanDoBetter;

  /// No description provided for @tryAnotherMoveForWhite.
  ///
  /// In en, this message translates to:
  /// **'Try another move for white'**
  String get tryAnotherMoveForWhite;

  /// No description provided for @tryAnotherMoveForBlack.
  ///
  /// In en, this message translates to:
  /// **'Try another move for black'**
  String get tryAnotherMoveForBlack;

  /// No description provided for @solution.
  ///
  /// In en, this message translates to:
  /// **'Solution'**
  String get solution;

  /// No description provided for @waitingForAnalysis.
  ///
  /// In en, this message translates to:
  /// **'Waiting for analysis'**
  String get waitingForAnalysis;

  /// No description provided for @noMistakesFoundForWhite.
  ///
  /// In en, this message translates to:
  /// **'No mistakes found for white'**
  String get noMistakesFoundForWhite;

  /// No description provided for @noMistakesFoundForBlack.
  ///
  /// In en, this message translates to:
  /// **'No mistakes found for black'**
  String get noMistakesFoundForBlack;

  /// No description provided for @doneReviewingWhiteMistakes.
  ///
  /// In en, this message translates to:
  /// **'Done reviewing white mistakes'**
  String get doneReviewingWhiteMistakes;

  /// No description provided for @doneReviewingBlackMistakes.
  ///
  /// In en, this message translates to:
  /// **'Done reviewing black mistakes'**
  String get doneReviewingBlackMistakes;

  /// No description provided for @doItAgain.
  ///
  /// In en, this message translates to:
  /// **'Do it again'**
  String get doItAgain;

  /// No description provided for @reviewWhiteMistakes.
  ///
  /// In en, this message translates to:
  /// **'Review white mistakes'**
  String get reviewWhiteMistakes;

  /// No description provided for @reviewBlackMistakes.
  ///
  /// In en, this message translates to:
  /// **'Review black mistakes'**
  String get reviewBlackMistakes;

  /// No description provided for @advantage.
  ///
  /// In en, this message translates to:
  /// **'Advantage'**
  String get advantage;

  /// No description provided for @opening.
  ///
  /// In en, this message translates to:
  /// **'Opening'**
  String get opening;

  /// No description provided for @middlegame.
  ///
  /// In en, this message translates to:
  /// **'Middlegame'**
  String get middlegame;

  /// No description provided for @endgame.
  ///
  /// In en, this message translates to:
  /// **'Endgame'**
  String get endgame;

  /// No description provided for @conditionalPremoves.
  ///
  /// In en, this message translates to:
  /// **'Conditional premoves'**
  String get conditionalPremoves;

  /// No description provided for @addCurrentVariation.
  ///
  /// In en, this message translates to:
  /// **'Add current variation'**
  String get addCurrentVariation;

  /// No description provided for @playVariationToCreateConditionalPremoves.
  ///
  /// In en, this message translates to:
  /// **'Play a variation to create conditional premoves'**
  String get playVariationToCreateConditionalPremoves;

  /// No description provided for @noConditionalPremoves.
  ///
  /// In en, this message translates to:
  /// **'No conditional premoves'**
  String get noConditionalPremoves;

  /// No description provided for @playX.
  ///
  /// In en, this message translates to:
  /// **'Play {param}'**
  String playX(String param);

  /// No description provided for @showUnreadLichessMessage.
  ///
  /// In en, this message translates to:
  /// **'You have received a private message from Lichess.'**
  String get showUnreadLichessMessage;

  /// No description provided for @clickHereToReadIt.
  ///
  /// In en, this message translates to:
  /// **'Click here to read it'**
  String get clickHereToReadIt;

  /// No description provided for @sorry.
  ///
  /// In en, this message translates to:
  /// **'Sorry :('**
  String get sorry;

  /// No description provided for @weHadToTimeYouOutForAWhile.
  ///
  /// In en, this message translates to:
  /// **'We had to time you out for a while.'**
  String get weHadToTimeYouOutForAWhile;

  /// No description provided for @why.
  ///
  /// In en, this message translates to:
  /// **'Why?'**
  String get why;

  /// No description provided for @pleasantChessExperience.
  ///
  /// In en, this message translates to:
  /// **'We aim to provide a pleasant chess experience for everyone.'**
  String get pleasantChessExperience;

  /// No description provided for @goodPractice.
  ///
  /// In en, this message translates to:
  /// **'To that effect, we must ensure that all players follow good practice.'**
  String get goodPractice;

  /// No description provided for @potentialProblem.
  ///
  /// In en, this message translates to:
  /// **'When a potential problem is detected, we display this message.'**
  String get potentialProblem;

  /// No description provided for @howToAvoidThis.
  ///
  /// In en, this message translates to:
  /// **'How to avoid this?'**
  String get howToAvoidThis;

  /// No description provided for @playEveryGame.
  ///
  /// In en, this message translates to:
  /// **'Play every game you start.'**
  String get playEveryGame;

  /// No description provided for @tryToWin.
  ///
  /// In en, this message translates to:
  /// **'Try to win (or at least draw) every game you play.'**
  String get tryToWin;

  /// No description provided for @resignLostGames.
  ///
  /// In en, this message translates to:
  /// **'Resign lost games (don\'t let the clock run down).'**
  String get resignLostGames;

  /// No description provided for @temporaryInconvenience.
  ///
  /// In en, this message translates to:
  /// **'We apologise for the temporary inconvenience,'**
  String get temporaryInconvenience;

  /// No description provided for @wishYouGreatGames.
  ///
  /// In en, this message translates to:
  /// **'and wish you great games on lichess.org.'**
  String get wishYouGreatGames;

  /// No description provided for @thankYouForReading.
  ///
  /// In en, this message translates to:
  /// **'Thank you for reading!'**
  String get thankYouForReading;

  /// No description provided for @lifetimeScore.
  ///
  /// In en, this message translates to:
  /// **'Lifetime score'**
  String get lifetimeScore;

  /// No description provided for @currentMatchScore.
  ///
  /// In en, this message translates to:
  /// **'Current match score'**
  String get currentMatchScore;

  /// No description provided for @agreementAssistance.
  ///
  /// In en, this message translates to:
  /// **'I agree that I will at no time receive assistance during my games (from a chess computer, book, database or another person).'**
  String get agreementAssistance;

  /// No description provided for @agreementNice.
  ///
  /// In en, this message translates to:
  /// **'I agree that I will always be respectful to other players.'**
  String get agreementNice;

  /// No description provided for @agreementMultipleAccounts.
  ///
  /// In en, this message translates to:
  /// **'I agree that I will not create multiple accounts (except for the reasons stated in the {param}).'**
  String agreementMultipleAccounts(String param);

  /// No description provided for @agreementPolicy.
  ///
  /// In en, this message translates to:
  /// **'I agree that I will follow all Lichess policies.'**
  String get agreementPolicy;

  /// No description provided for @searchOrStartNewDiscussion.
  ///
  /// In en, this message translates to:
  /// **'Search or start new conversation'**
  String get searchOrStartNewDiscussion;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @bullet.
  ///
  /// In en, this message translates to:
  /// **'Bullet'**
  String get bullet;

  /// No description provided for @blitz.
  ///
  /// In en, this message translates to:
  /// **'Blitz'**
  String get blitz;

  /// No description provided for @rapid.
  ///
  /// In en, this message translates to:
  /// **'Rapid'**
  String get rapid;

  /// No description provided for @classical.
  ///
  /// In en, this message translates to:
  /// **'Classical'**
  String get classical;

  /// No description provided for @ultraBulletDesc.
  ///
  /// In en, this message translates to:
  /// **'Insanely fast games: less than 30 seconds'**
  String get ultraBulletDesc;

  /// No description provided for @bulletDesc.
  ///
  /// In en, this message translates to:
  /// **'Very fast games: less than 3 minutes'**
  String get bulletDesc;

  /// No description provided for @blitzDesc.
  ///
  /// In en, this message translates to:
  /// **'Fast games: 3 to 8 minutes'**
  String get blitzDesc;

  /// No description provided for @rapidDesc.
  ///
  /// In en, this message translates to:
  /// **'Rapid games: 8 to 25 minutes'**
  String get rapidDesc;

  /// No description provided for @classicalDesc.
  ///
  /// In en, this message translates to:
  /// **'Classical games: 25 minutes and more'**
  String get classicalDesc;

  /// No description provided for @correspondenceDesc.
  ///
  /// In en, this message translates to:
  /// **'Correspondence games: one or several days per move'**
  String get correspondenceDesc;

  /// No description provided for @puzzleDesc.
  ///
  /// In en, this message translates to:
  /// **'Chess tactics trainer'**
  String get puzzleDesc;

  /// No description provided for @important.
  ///
  /// In en, this message translates to:
  /// **'Important'**
  String get important;

  /// No description provided for @yourQuestionMayHaveBeenAnswered.
  ///
  /// In en, this message translates to:
  /// **'Your question may already have an answer {param1}'**
  String yourQuestionMayHaveBeenAnswered(String param1);

  /// No description provided for @inTheFAQ.
  ///
  /// In en, this message translates to:
  /// **'in the FAQ'**
  String get inTheFAQ;

  /// No description provided for @toReportSomeoneForCheatingOrBadBehavior.
  ///
  /// In en, this message translates to:
  /// **'To report a user for cheating or bad behaviour, {param1}'**
  String toReportSomeoneForCheatingOrBadBehavior(String param1);

  /// No description provided for @useTheReportForm.
  ///
  /// In en, this message translates to:
  /// **'use the report form'**
  String get useTheReportForm;

  /// No description provided for @toRequestSupport.
  ///
  /// In en, this message translates to:
  /// **'To request support, {param1}'**
  String toRequestSupport(String param1);

  /// No description provided for @tryTheContactPage.
  ///
  /// In en, this message translates to:
  /// **'try the contact page'**
  String get tryTheContactPage;

  /// No description provided for @makeSureToRead.
  ///
  /// In en, this message translates to:
  /// **'Make sure to read {param1}'**
  String makeSureToRead(String param1);

  /// No description provided for @theForumEtiquette.
  ///
  /// In en, this message translates to:
  /// **'the forum etiquette'**
  String get theForumEtiquette;

  /// No description provided for @thisTopicIsArchived.
  ///
  /// In en, this message translates to:
  /// **'This topic has been archived and can no longer be replied to.'**
  String get thisTopicIsArchived;

  /// No description provided for @joinTheTeamXToPost.
  ///
  /// In en, this message translates to:
  /// **'Join the {param1}, to post in this forum'**
  String joinTheTeamXToPost(String param1);

  /// No description provided for @teamNamedX.
  ///
  /// In en, this message translates to:
  /// **'{param1} team'**
  String teamNamedX(String param1);

  /// No description provided for @youCannotPostYetPlaySomeGames.
  ///
  /// In en, this message translates to:
  /// **'You can\'t post in the forums yet. Play some games!'**
  String get youCannotPostYetPlaySomeGames;

  /// No description provided for @subscribe.
  ///
  /// In en, this message translates to:
  /// **'Subscribe'**
  String get subscribe;

  /// No description provided for @unsubscribe.
  ///
  /// In en, this message translates to:
  /// **'Unsubscribe'**
  String get unsubscribe;

  /// No description provided for @mentionedYouInX.
  ///
  /// In en, this message translates to:
  /// **'mentioned you in \"{param1}\".'**
  String mentionedYouInX(String param1);

  /// No description provided for @xMentionedYouInY.
  ///
  /// In en, this message translates to:
  /// **'{param1} mentioned you in \"{param2}\".'**
  String xMentionedYouInY(String param1, String param2);

  /// No description provided for @invitedYouToX.
  ///
  /// In en, this message translates to:
  /// **'invited you to \"{param1}\".'**
  String invitedYouToX(String param1);

  /// No description provided for @xInvitedYouToY.
  ///
  /// In en, this message translates to:
  /// **'{param1} invited you to \"{param2}\".'**
  String xInvitedYouToY(String param1, String param2);

  /// No description provided for @youAreNowPartOfTeam.
  ///
  /// In en, this message translates to:
  /// **'You are now part of the team.'**
  String get youAreNowPartOfTeam;

  /// No description provided for @youHaveJoinedTeamX.
  ///
  /// In en, this message translates to:
  /// **'You have joined \"{param1}\".'**
  String youHaveJoinedTeamX(String param1);

  /// No description provided for @someoneYouReportedWasBanned.
  ///
  /// In en, this message translates to:
  /// **'Someone you reported was banned'**
  String get someoneYouReportedWasBanned;

  /// No description provided for @congratsYouWon.
  ///
  /// In en, this message translates to:
  /// **'Congratulations, you won!'**
  String get congratsYouWon;

  /// No description provided for @gameVsX.
  ///
  /// In en, this message translates to:
  /// **'Game vs {param1}'**
  String gameVsX(String param1);

  /// No description provided for @resVsX.
  ///
  /// In en, this message translates to:
  /// **'{param1} vs {param2}'**
  String resVsX(String param1, String param2);

  /// No description provided for @lostAgainstTOSViolator.
  ///
  /// In en, this message translates to:
  /// **'You lost rating points to someone who violated the Lichess TOS'**
  String get lostAgainstTOSViolator;

  /// No description provided for @refundXpointsTimeControlY.
  ///
  /// In en, this message translates to:
  /// **'Refund: {param1} {param2} rating points.'**
  String refundXpointsTimeControlY(String param1, String param2);

  /// No description provided for @timeAlmostUp.
  ///
  /// In en, this message translates to:
  /// **'Time is almost up!'**
  String get timeAlmostUp;

  /// No description provided for @clickToRevealEmailAddress.
  ///
  /// In en, this message translates to:
  /// **'[Click to reveal email address]'**
  String get clickToRevealEmailAddress;

  /// No description provided for @download.
  ///
  /// In en, this message translates to:
  /// **'Download'**
  String get download;

  /// No description provided for @coachManager.
  ///
  /// In en, this message translates to:
  /// **'Coach manager'**
  String get coachManager;

  /// No description provided for @streamerManager.
  ///
  /// In en, this message translates to:
  /// **'Streamer manager'**
  String get streamerManager;

  /// No description provided for @cancelTournament.
  ///
  /// In en, this message translates to:
  /// **'Cancel the tournament'**
  String get cancelTournament;

  /// No description provided for @tournDescription.
  ///
  /// In en, this message translates to:
  /// **'Tournament description'**
  String get tournDescription;

  /// No description provided for @tournDescriptionHelp.
  ///
  /// In en, this message translates to:
  /// **'Anything special you want to tell the participants? Try to keep it short. Markdown links are available: [name](https://url)'**
  String get tournDescriptionHelp;

  /// No description provided for @ratedFormHelp.
  ///
  /// In en, this message translates to:
  /// **'Games are rated and impact players ratings'**
  String get ratedFormHelp;

  /// No description provided for @onlyMembersOfTeam.
  ///
  /// In en, this message translates to:
  /// **'Only members of team'**
  String get onlyMembersOfTeam;

  /// No description provided for @noRestriction.
  ///
  /// In en, this message translates to:
  /// **'No restriction'**
  String get noRestriction;

  /// No description provided for @minimumRatedGames.
  ///
  /// In en, this message translates to:
  /// **'Minimum rated games'**
  String get minimumRatedGames;

  /// No description provided for @minimumRating.
  ///
  /// In en, this message translates to:
  /// **'Minimum rating'**
  String get minimumRating;

  /// No description provided for @maximumWeeklyRating.
  ///
  /// In en, this message translates to:
  /// **'Maximum weekly rating'**
  String get maximumWeeklyRating;

  /// No description provided for @positionInputHelp.
  ///
  /// In en, this message translates to:
  /// **'Paste a valid FEN to start every game from a given position.\nIt only works for standard games, not with variants.\nYou can use the {param} to generate a FEN position, then paste it here.\nLeave empty to start games from the normal initial position.'**
  String positionInputHelp(String param);

  /// No description provided for @cancelSimul.
  ///
  /// In en, this message translates to:
  /// **'Cancel the simul'**
  String get cancelSimul;

  /// No description provided for @simulHostcolor.
  ///
  /// In en, this message translates to:
  /// **'Host colour for each game'**
  String get simulHostcolor;

  /// No description provided for @estimatedStart.
  ///
  /// In en, this message translates to:
  /// **'Estimated start time'**
  String get estimatedStart;

  /// No description provided for @simulFeatured.
  ///
  /// In en, this message translates to:
  /// **'Feature on {param}'**
  String simulFeatured(String param);

  /// No description provided for @simulFeaturedHelp.
  ///
  /// In en, this message translates to:
  /// **'Show your simul to everyone on {param}. Disable for private simuls.'**
  String simulFeaturedHelp(String param);

  /// No description provided for @simulDescription.
  ///
  /// In en, this message translates to:
  /// **'Simul description'**
  String get simulDescription;

  /// No description provided for @simulDescriptionHelp.
  ///
  /// In en, this message translates to:
  /// **'Anything you want to tell the participants?'**
  String get simulDescriptionHelp;

  /// No description provided for @markdownAvailable.
  ///
  /// In en, this message translates to:
  /// **'{param} is available for more advanced syntax.'**
  String markdownAvailable(String param);

  /// No description provided for @embedsAvailable.
  ///
  /// In en, this message translates to:
  /// **'Paste a game URL or a study chapter URL to embed it.'**
  String get embedsAvailable;

  /// No description provided for @inYourLocalTimezone.
  ///
  /// In en, this message translates to:
  /// **'In your own local timezone'**
  String get inYourLocalTimezone;

  /// No description provided for @tournChat.
  ///
  /// In en, this message translates to:
  /// **'Tournament chat'**
  String get tournChat;

  /// No description provided for @noChat.
  ///
  /// In en, this message translates to:
  /// **'No chat'**
  String get noChat;

  /// No description provided for @onlyTeamLeaders.
  ///
  /// In en, this message translates to:
  /// **'Only team leaders'**
  String get onlyTeamLeaders;

  /// No description provided for @onlyTeamMembers.
  ///
  /// In en, this message translates to:
  /// **'Only team members'**
  String get onlyTeamMembers;

  /// No description provided for @navigateMoveTree.
  ///
  /// In en, this message translates to:
  /// **'Navigate the move tree'**
  String get navigateMoveTree;

  /// No description provided for @mouseTricks.
  ///
  /// In en, this message translates to:
  /// **'Mouse tricks'**
  String get mouseTricks;

  /// No description provided for @toggleLocalAnalysis.
  ///
  /// In en, this message translates to:
  /// **'Toggle local computer analysis'**
  String get toggleLocalAnalysis;

  /// No description provided for @toggleAllAnalysis.
  ///
  /// In en, this message translates to:
  /// **'Toggle all computer analysis'**
  String get toggleAllAnalysis;

  /// No description provided for @playComputerMove.
  ///
  /// In en, this message translates to:
  /// **'Play best computer move'**
  String get playComputerMove;

  /// No description provided for @analysisOptions.
  ///
  /// In en, this message translates to:
  /// **'Analysis options'**
  String get analysisOptions;

  /// No description provided for @focusChat.
  ///
  /// In en, this message translates to:
  /// **'Focus chat'**
  String get focusChat;

  /// No description provided for @showHelpDialog.
  ///
  /// In en, this message translates to:
  /// **'Show this help dialog'**
  String get showHelpDialog;

  /// No description provided for @reopenYourAccount.
  ///
  /// In en, this message translates to:
  /// **'Reopen your account'**
  String get reopenYourAccount;

  /// No description provided for @reopenYourAccountDescription.
  ///
  /// In en, this message translates to:
  /// **'If you closed your account, but have since changed your mind, you get a chance of getting your account back.'**
  String get reopenYourAccountDescription;

  /// No description provided for @emailAssociatedToaccount.
  ///
  /// In en, this message translates to:
  /// **'Email address associated to the account'**
  String get emailAssociatedToaccount;

  /// No description provided for @sentEmailWithLink.
  ///
  /// In en, this message translates to:
  /// **'We\'ve sent you an email with a link.'**
  String get sentEmailWithLink;

  /// No description provided for @tournamentEntryCode.
  ///
  /// In en, this message translates to:
  /// **'Tournament entry code'**
  String get tournamentEntryCode;

  /// No description provided for @hangOn.
  ///
  /// In en, this message translates to:
  /// **'Hang on!'**
  String get hangOn;

  /// No description provided for @gameInProgress.
  ///
  /// In en, this message translates to:
  /// **'You have a game in progress with {param}.'**
  String gameInProgress(String param);

  /// No description provided for @abortTheGame.
  ///
  /// In en, this message translates to:
  /// **'Abort the game'**
  String get abortTheGame;

  /// No description provided for @resignTheGame.
  ///
  /// In en, this message translates to:
  /// **'Resign the game'**
  String get resignTheGame;

  /// No description provided for @youCantStartNewGame.
  ///
  /// In en, this message translates to:
  /// **'You can\'t start a new game until this one is finished.'**
  String get youCantStartNewGame;

  /// No description provided for @since.
  ///
  /// In en, this message translates to:
  /// **'Since'**
  String get since;

  /// No description provided for @until.
  ///
  /// In en, this message translates to:
  /// **'Until'**
  String get until;

  /// No description provided for @lichessDbExplanation.
  ///
  /// In en, this message translates to:
  /// **'Rated games played on Lichess'**
  String get lichessDbExplanation;

  /// No description provided for @switchSides.
  ///
  /// In en, this message translates to:
  /// **'Switch sides'**
  String get switchSides;

  /// No description provided for @closingAccountWithdrawAppeal.
  ///
  /// In en, this message translates to:
  /// **'Closing your account will withdraw your appeal'**
  String get closingAccountWithdrawAppeal;

  /// No description provided for @ourEventTips.
  ///
  /// In en, this message translates to:
  /// **'Our tips for organising events'**
  String get ourEventTips;

  /// No description provided for @instructions.
  ///
  /// In en, this message translates to:
  /// **'Instructions'**
  String get instructions;

  /// No description provided for @showMeEverything.
  ///
  /// In en, this message translates to:
  /// **'Show me everything'**
  String get showMeEverything;

  /// No description provided for @lichessPatronInfo.
  ///
  /// In en, this message translates to:
  /// **'Lichess is a charity and entirely free/libre open source software.\nAll operating costs, development, and content are funded solely by user donations.'**
  String get lichessPatronInfo;

  /// No description provided for @nothingToSeeHere.
  ///
  /// In en, this message translates to:
  /// **'Nothing to see here at the moment.'**
  String get nothingToSeeHere;

  /// No description provided for @stats.
  ///
  /// In en, this message translates to:
  /// **'Stats'**
  String get stats;

  /// No description provided for @opponentLeftCounter.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Your opponent left the game. You can claim victory in {count} second.} other{Your opponent left the game. You can claim victory in {count} seconds.}}'**
  String opponentLeftCounter(int count);

  /// No description provided for @mateInXHalfMoves.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Mate in {count} half-move} other{Mate in {count} half-moves}}'**
  String mateInXHalfMoves(int count);

  /// No description provided for @nbBlunders.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{{count} blunder} other{{count} blunders}}'**
  String nbBlunders(int count);

  /// No description provided for @numberBlunders.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{{count} Blunder} other{{count} Blunders}}'**
  String numberBlunders(int count);

  /// No description provided for @nbMistakes.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{{count} mistake} other{{count} mistakes}}'**
  String nbMistakes(int count);

  /// No description provided for @numberMistakes.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{{count} Mistake} other{{count} Mistakes}}'**
  String numberMistakes(int count);

  /// No description provided for @nbInaccuracies.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{{count} inaccuracy} other{{count} inaccuracies}}'**
  String nbInaccuracies(int count);

  /// No description provided for @numberInaccuracies.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{{count} Inaccuracy} other{{count} Inaccuracies}}'**
  String numberInaccuracies(int count);

  /// No description provided for @nbPlayers.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{{count} player} other{{count} players}}'**
  String nbPlayers(int count);

  /// No description provided for @nbGames.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{{count} game} other{{count} games}}'**
  String nbGames(int count);

  /// No description provided for @ratingXOverYGames.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{{count} rating over {param2} game} other{{count} rating over {param2} games}}'**
  String ratingXOverYGames(int count, String param2);

  /// No description provided for @nbBookmarks.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{{count} bookmark} other{{count} bookmarks}}'**
  String nbBookmarks(int count);

  /// No description provided for @nbDays.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{{count} day} other{{count} days}}'**
  String nbDays(int count);

  /// No description provided for @nbHours.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{{count} hour} other{{count} hours}}'**
  String nbHours(int count);

  /// No description provided for @nbMinutes.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{{count} minute} other{{count} minutes}}'**
  String nbMinutes(int count);

  /// No description provided for @rankIsUpdatedEveryNbMinutes.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Rank is updated every minute} other{Rank is updated every {count} minutes}}'**
  String rankIsUpdatedEveryNbMinutes(int count);

  /// No description provided for @nbPuzzles.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{{count} puzzle} other{{count} puzzles}}'**
  String nbPuzzles(int count);

  /// No description provided for @nbGamesWithYou.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{{count} game with you} other{{count} games with you}}'**
  String nbGamesWithYou(int count);

  /// No description provided for @nbRated.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{{count} rated} other{{count} rated}}'**
  String nbRated(int count);

  /// No description provided for @nbWins.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{{count} win} other{{count} wins}}'**
  String nbWins(int count);

  /// No description provided for @nbLosses.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{{count} loss} other{{count} losses}}'**
  String nbLosses(int count);

  /// No description provided for @nbDraws.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{{count} draw} other{{count} draws}}'**
  String nbDraws(int count);

  /// No description provided for @nbPlaying.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{{count} playing} other{{count} playing}}'**
  String nbPlaying(int count);

  /// No description provided for @giveNbSeconds.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Give {count} second} other{Give {count} seconds}}'**
  String giveNbSeconds(int count);

  /// No description provided for @nbTournamentPoints.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{{count} tournament point} other{{count} tournament points}}'**
  String nbTournamentPoints(int count);

  /// No description provided for @nbStudies.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{{count} study} other{{count} studies}}'**
  String nbStudies(int count);

  /// No description provided for @nbSimuls.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{{count} simul} other{{count} simuls}}'**
  String nbSimuls(int count);

  /// No description provided for @moreThanNbRatedGames.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{≥ {count} rated game} other{≥ {count} rated games}}'**
  String moreThanNbRatedGames(int count);

  /// No description provided for @moreThanNbPerfRatedGames.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{≥ {count} {param2} rated game} other{≥ {count} {param2} rated games}}'**
  String moreThanNbPerfRatedGames(int count, String param2);

  /// No description provided for @needNbMorePerfGames.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{You need to play {count} more {param2} rated game} other{You need to play {count} more {param2} rated games}}'**
  String needNbMorePerfGames(int count, String param2);

  /// No description provided for @needNbMoreGames.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{You need to play {count} more rated game} other{You need to play {count} more rated games}}'**
  String needNbMoreGames(int count);

  /// No description provided for @nbImportedGames.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{{count} imported game} other{{count} imported games}}'**
  String nbImportedGames(int count);

  /// No description provided for @nbFriendsOnline.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{{count} friend online} other{{count} friends online}}'**
  String nbFriendsOnline(int count);

  /// No description provided for @nbFollowers.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{{count} follower} other{{count} followers}}'**
  String nbFollowers(int count);

  /// No description provided for @nbFollowing.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{{count} following} other{{count} following}}'**
  String nbFollowing(int count);

  /// No description provided for @lessThanNbMinutes.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Less than {count} minute} other{Less than {count} minutes}}'**
  String lessThanNbMinutes(int count);

  /// No description provided for @nbGamesInPlay.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{{count} game in play} other{{count} games in play}}'**
  String nbGamesInPlay(int count);

  /// No description provided for @maximumNbCharacters.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Maximum: {count} character.} other{Maximum: {count} characters.}}'**
  String maximumNbCharacters(int count);

  /// No description provided for @blocks.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{{count} block} other{{count} blocks}}'**
  String blocks(int count);

  /// No description provided for @nbForumPosts.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{{count} forum post} other{{count} forum posts}}'**
  String nbForumPosts(int count);

  /// No description provided for @nbPerfTypePlayersThisWeek.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{{count} {param2} player this week.} other{{count} {param2} players this week.}}'**
  String nbPerfTypePlayersThisWeek(int count, String param2);

  /// No description provided for @availableInNbLanguages.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Available in {count} language!} other{Available in {count} languages!}}'**
  String availableInNbLanguages(int count);

  /// No description provided for @nbSecondsToPlayTheFirstMove.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{{count} second to play the first move} other{{count} seconds to play the first move}}'**
  String nbSecondsToPlayTheFirstMove(int count);

  /// No description provided for @nbSeconds.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{{count} second} other{{count} seconds}}'**
  String nbSeconds(int count);

  /// No description provided for @andSaveNbPremoveLines.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{and save {count} premove line} other{and save {count} premove lines}}'**
  String andSaveNbPremoveLines(int count);

  /// No description provided for @stormMoveToStart.
  ///
  /// In en, this message translates to:
  /// **'Move to start'**
  String get stormMoveToStart;

  /// No description provided for @stormYouPlayTheWhitePiecesInAllPuzzles.
  ///
  /// In en, this message translates to:
  /// **'You play the white pieces in all puzzles'**
  String get stormYouPlayTheWhitePiecesInAllPuzzles;

  /// No description provided for @stormYouPlayTheBlackPiecesInAllPuzzles.
  ///
  /// In en, this message translates to:
  /// **'You play the black pieces in all puzzles'**
  String get stormYouPlayTheBlackPiecesInAllPuzzles;

  /// No description provided for @stormPuzzlesSolved.
  ///
  /// In en, this message translates to:
  /// **'puzzles solved'**
  String get stormPuzzlesSolved;

  /// No description provided for @stormNewDailyHighscore.
  ///
  /// In en, this message translates to:
  /// **'New daily highscore!'**
  String get stormNewDailyHighscore;

  /// No description provided for @stormNewWeeklyHighscore.
  ///
  /// In en, this message translates to:
  /// **'New weekly highscore!'**
  String get stormNewWeeklyHighscore;

  /// No description provided for @stormNewMonthlyHighscore.
  ///
  /// In en, this message translates to:
  /// **'New monthly highscore!'**
  String get stormNewMonthlyHighscore;

  /// No description provided for @stormNewAllTimeHighscore.
  ///
  /// In en, this message translates to:
  /// **'New all-time highscore!'**
  String get stormNewAllTimeHighscore;

  /// No description provided for @stormPreviousHighscoreWasX.
  ///
  /// In en, this message translates to:
  /// **'Previous highscore was {param}'**
  String stormPreviousHighscoreWasX(String param);

  /// No description provided for @stormPlayAgain.
  ///
  /// In en, this message translates to:
  /// **'Play again'**
  String get stormPlayAgain;

  /// No description provided for @stormHighscoreX.
  ///
  /// In en, this message translates to:
  /// **'Highscore: {param}'**
  String stormHighscoreX(String param);

  /// No description provided for @stormScore.
  ///
  /// In en, this message translates to:
  /// **'Score'**
  String get stormScore;

  /// No description provided for @stormMoves.
  ///
  /// In en, this message translates to:
  /// **'Moves'**
  String get stormMoves;

  /// No description provided for @stormAccuracy.
  ///
  /// In en, this message translates to:
  /// **'Accuracy'**
  String get stormAccuracy;

  /// No description provided for @stormCombo.
  ///
  /// In en, this message translates to:
  /// **'Combo'**
  String get stormCombo;

  /// No description provided for @stormTime.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get stormTime;

  /// No description provided for @stormTimePerMove.
  ///
  /// In en, this message translates to:
  /// **'Time per move'**
  String get stormTimePerMove;

  /// No description provided for @stormHighestSolved.
  ///
  /// In en, this message translates to:
  /// **'Highest solved'**
  String get stormHighestSolved;

  /// No description provided for @stormPuzzlesPlayed.
  ///
  /// In en, this message translates to:
  /// **'Puzzles played'**
  String get stormPuzzlesPlayed;

  /// No description provided for @stormNewRun.
  ///
  /// In en, this message translates to:
  /// **'New run (hotkey: Space)'**
  String get stormNewRun;

  /// No description provided for @stormEndRun.
  ///
  /// In en, this message translates to:
  /// **'End run (hotkey: Enter)'**
  String get stormEndRun;

  /// No description provided for @stormHighscores.
  ///
  /// In en, this message translates to:
  /// **'Highscores'**
  String get stormHighscores;

  /// No description provided for @stormViewBestRuns.
  ///
  /// In en, this message translates to:
  /// **'View best runs'**
  String get stormViewBestRuns;

  /// No description provided for @stormBestRunOfDay.
  ///
  /// In en, this message translates to:
  /// **'Best run of day'**
  String get stormBestRunOfDay;

  /// No description provided for @stormRuns.
  ///
  /// In en, this message translates to:
  /// **'Runs'**
  String get stormRuns;

  /// No description provided for @stormGetReady.
  ///
  /// In en, this message translates to:
  /// **'Get ready!'**
  String get stormGetReady;

  /// No description provided for @stormWaitingForMorePlayers.
  ///
  /// In en, this message translates to:
  /// **'Waiting for more players to join...'**
  String get stormWaitingForMorePlayers;

  /// No description provided for @stormRaceComplete.
  ///
  /// In en, this message translates to:
  /// **'Race complete!'**
  String get stormRaceComplete;

  /// No description provided for @stormSpectating.
  ///
  /// In en, this message translates to:
  /// **'Spectating'**
  String get stormSpectating;

  /// No description provided for @stormJoinTheRace.
  ///
  /// In en, this message translates to:
  /// **'Join the race!'**
  String get stormJoinTheRace;

  /// No description provided for @stormStartTheRace.
  ///
  /// In en, this message translates to:
  /// **'Start the race'**
  String get stormStartTheRace;

  /// No description provided for @stormYourRankX.
  ///
  /// In en, this message translates to:
  /// **'Your rank: {param}'**
  String stormYourRankX(String param);

  /// No description provided for @stormWaitForRematch.
  ///
  /// In en, this message translates to:
  /// **'Wait for rematch'**
  String get stormWaitForRematch;

  /// No description provided for @stormNextRace.
  ///
  /// In en, this message translates to:
  /// **'Next race'**
  String get stormNextRace;

  /// No description provided for @stormJoinRematch.
  ///
  /// In en, this message translates to:
  /// **'Join rematch'**
  String get stormJoinRematch;

  /// No description provided for @stormWaitingToStart.
  ///
  /// In en, this message translates to:
  /// **'Waiting to start'**
  String get stormWaitingToStart;

  /// No description provided for @stormCreateNewGame.
  ///
  /// In en, this message translates to:
  /// **'Create a new game'**
  String get stormCreateNewGame;

  /// No description provided for @stormJoinPublicRace.
  ///
  /// In en, this message translates to:
  /// **'Join a public race'**
  String get stormJoinPublicRace;

  /// No description provided for @stormRaceYourFriends.
  ///
  /// In en, this message translates to:
  /// **'Race your friends'**
  String get stormRaceYourFriends;

  /// No description provided for @stormSkip.
  ///
  /// In en, this message translates to:
  /// **'skip'**
  String get stormSkip;

  /// No description provided for @stormSkipHelp.
  ///
  /// In en, this message translates to:
  /// **'You can skip one move per race:'**
  String get stormSkipHelp;

  /// No description provided for @stormSkipExplanation.
  ///
  /// In en, this message translates to:
  /// **'Skip this move to preserve your combo! Only works once per race.'**
  String get stormSkipExplanation;

  /// No description provided for @stormFailedPuzzles.
  ///
  /// In en, this message translates to:
  /// **'Failed puzzles'**
  String get stormFailedPuzzles;

  /// No description provided for @stormSlowPuzzles.
  ///
  /// In en, this message translates to:
  /// **'Slow puzzles'**
  String get stormSlowPuzzles;

  /// No description provided for @stormSkippedPuzzle.
  ///
  /// In en, this message translates to:
  /// **'Skipped puzzle'**
  String get stormSkippedPuzzle;

  /// No description provided for @stormThisWeek.
  ///
  /// In en, this message translates to:
  /// **'This week'**
  String get stormThisWeek;

  /// No description provided for @stormThisMonth.
  ///
  /// In en, this message translates to:
  /// **'This month'**
  String get stormThisMonth;

  /// No description provided for @stormAllTime.
  ///
  /// In en, this message translates to:
  /// **'All-time'**
  String get stormAllTime;

  /// No description provided for @stormClickToReload.
  ///
  /// In en, this message translates to:
  /// **'Click to reload'**
  String get stormClickToReload;

  /// No description provided for @stormThisRunHasExpired.
  ///
  /// In en, this message translates to:
  /// **'This run has expired!'**
  String get stormThisRunHasExpired;

  /// No description provided for @stormThisRunWasOpenedInAnotherTab.
  ///
  /// In en, this message translates to:
  /// **'This run was opened in another tab!'**
  String get stormThisRunWasOpenedInAnotherTab;

  /// No description provided for @stormXRuns.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 run} other{{count} runs}}'**
  String stormXRuns(int count);

  /// No description provided for @stormPlayedNbRunsOfPuzzleStorm.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Played one run of {param2}} other{Played {count} runs of {param2}}}'**
  String stormPlayedNbRunsOfPuzzleStorm(int count, String param2);

  /// No description provided for @streamerLichessStreamers.
  ///
  /// In en, this message translates to:
  /// **'Lichess streamers'**
  String get streamerLichessStreamers;

  /// No description provided for @studyPrivate.
  ///
  /// In en, this message translates to:
  /// **'Private'**
  String get studyPrivate;

  /// No description provided for @studyMyStudies.
  ///
  /// In en, this message translates to:
  /// **'My studies'**
  String get studyMyStudies;

  /// No description provided for @studyStudiesIContributeTo.
  ///
  /// In en, this message translates to:
  /// **'Studies I contribute to'**
  String get studyStudiesIContributeTo;

  /// No description provided for @studyMyPublicStudies.
  ///
  /// In en, this message translates to:
  /// **'My public studies'**
  String get studyMyPublicStudies;

  /// No description provided for @studyMyPrivateStudies.
  ///
  /// In en, this message translates to:
  /// **'My private studies'**
  String get studyMyPrivateStudies;

  /// No description provided for @studyMyFavoriteStudies.
  ///
  /// In en, this message translates to:
  /// **'My favourite studies'**
  String get studyMyFavoriteStudies;

  /// No description provided for @studyWhatAreStudies.
  ///
  /// In en, this message translates to:
  /// **'What are studies?'**
  String get studyWhatAreStudies;

  /// No description provided for @studyAllStudies.
  ///
  /// In en, this message translates to:
  /// **'All studies'**
  String get studyAllStudies;

  /// No description provided for @studyStudiesCreatedByX.
  ///
  /// In en, this message translates to:
  /// **'Studies created by {param}'**
  String studyStudiesCreatedByX(String param);

  /// No description provided for @studyNoneYet.
  ///
  /// In en, this message translates to:
  /// **'None yet.'**
  String get studyNoneYet;

  /// No description provided for @studyHot.
  ///
  /// In en, this message translates to:
  /// **'Hot'**
  String get studyHot;

  /// No description provided for @studyDateAddedNewest.
  ///
  /// In en, this message translates to:
  /// **'Date added (newest)'**
  String get studyDateAddedNewest;

  /// No description provided for @studyDateAddedOldest.
  ///
  /// In en, this message translates to:
  /// **'Date added (oldest)'**
  String get studyDateAddedOldest;

  /// No description provided for @studyRecentlyUpdated.
  ///
  /// In en, this message translates to:
  /// **'Recently updated'**
  String get studyRecentlyUpdated;

  /// No description provided for @studyMostPopular.
  ///
  /// In en, this message translates to:
  /// **'Most popular'**
  String get studyMostPopular;

  /// No description provided for @studyAlphabetical.
  ///
  /// In en, this message translates to:
  /// **'Alphabetical'**
  String get studyAlphabetical;

  /// No description provided for @studyAddNewChapter.
  ///
  /// In en, this message translates to:
  /// **'Add a new chapter'**
  String get studyAddNewChapter;

  /// No description provided for @studyAddMembers.
  ///
  /// In en, this message translates to:
  /// **'Add members'**
  String get studyAddMembers;

  /// No description provided for @studyInviteToTheStudy.
  ///
  /// In en, this message translates to:
  /// **'Invite to the study'**
  String get studyInviteToTheStudy;

  /// No description provided for @studyPleaseOnlyInvitePeopleYouKnow.
  ///
  /// In en, this message translates to:
  /// **'Please only invite people who know you, and who actively want to join this study.'**
  String get studyPleaseOnlyInvitePeopleYouKnow;

  /// No description provided for @studySearchByUsername.
  ///
  /// In en, this message translates to:
  /// **'Search by username'**
  String get studySearchByUsername;

  /// No description provided for @studySpectator.
  ///
  /// In en, this message translates to:
  /// **'Spectator'**
  String get studySpectator;

  /// No description provided for @studyContributor.
  ///
  /// In en, this message translates to:
  /// **'Contributor'**
  String get studyContributor;

  /// No description provided for @studyKick.
  ///
  /// In en, this message translates to:
  /// **'Kick'**
  String get studyKick;

  /// No description provided for @studyLeaveTheStudy.
  ///
  /// In en, this message translates to:
  /// **'Leave the study'**
  String get studyLeaveTheStudy;

  /// No description provided for @studyYouAreNowAContributor.
  ///
  /// In en, this message translates to:
  /// **'You are now a contributor'**
  String get studyYouAreNowAContributor;

  /// No description provided for @studyYouAreNowASpectator.
  ///
  /// In en, this message translates to:
  /// **'You are now a spectator'**
  String get studyYouAreNowASpectator;

  /// No description provided for @studyPgnTags.
  ///
  /// In en, this message translates to:
  /// **'PGN tags'**
  String get studyPgnTags;

  /// No description provided for @studyLike.
  ///
  /// In en, this message translates to:
  /// **'Like'**
  String get studyLike;

  /// No description provided for @studyUnlike.
  ///
  /// In en, this message translates to:
  /// **'Unlike'**
  String get studyUnlike;

  /// No description provided for @studyNewTag.
  ///
  /// In en, this message translates to:
  /// **'New tag'**
  String get studyNewTag;

  /// No description provided for @studyCommentThisPosition.
  ///
  /// In en, this message translates to:
  /// **'Comment on this position'**
  String get studyCommentThisPosition;

  /// No description provided for @studyCommentThisMove.
  ///
  /// In en, this message translates to:
  /// **'Comment on this move'**
  String get studyCommentThisMove;

  /// No description provided for @studyAnnotateWithGlyphs.
  ///
  /// In en, this message translates to:
  /// **'Annotate with glyphs'**
  String get studyAnnotateWithGlyphs;

  /// No description provided for @studyTheChapterIsTooShortToBeAnalysed.
  ///
  /// In en, this message translates to:
  /// **'The chapter is too short to be analysed.'**
  String get studyTheChapterIsTooShortToBeAnalysed;

  /// No description provided for @studyOnlyContributorsCanRequestAnalysis.
  ///
  /// In en, this message translates to:
  /// **'Only the study contributors can request a computer analysis.'**
  String get studyOnlyContributorsCanRequestAnalysis;

  /// No description provided for @studyGetAFullComputerAnalysis.
  ///
  /// In en, this message translates to:
  /// **'Get a full server-side computer analysis of the mainline.'**
  String get studyGetAFullComputerAnalysis;

  /// No description provided for @studyMakeSureTheChapterIsComplete.
  ///
  /// In en, this message translates to:
  /// **'Make sure the chapter is complete. You can only request analysis once.'**
  String get studyMakeSureTheChapterIsComplete;

  /// No description provided for @studyAllSyncMembersRemainOnTheSamePosition.
  ///
  /// In en, this message translates to:
  /// **'All SYNC members remain on the same position'**
  String get studyAllSyncMembersRemainOnTheSamePosition;

  /// No description provided for @studyShareChanges.
  ///
  /// In en, this message translates to:
  /// **'Share changes with spectators and save them on the server'**
  String get studyShareChanges;

  /// No description provided for @studyPlaying.
  ///
  /// In en, this message translates to:
  /// **'Playing'**
  String get studyPlaying;

  /// No description provided for @studyShowResults.
  ///
  /// In en, this message translates to:
  /// **'Results'**
  String get studyShowResults;

  /// No description provided for @studyShowEvalBar.
  ///
  /// In en, this message translates to:
  /// **'Evaluation bars'**
  String get studyShowEvalBar;

  /// No description provided for @studyFirst.
  ///
  /// In en, this message translates to:
  /// **'First'**
  String get studyFirst;

  /// No description provided for @studyPrevious.
  ///
  /// In en, this message translates to:
  /// **'Previous'**
  String get studyPrevious;

  /// No description provided for @studyNext.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get studyNext;

  /// No description provided for @studyLast.
  ///
  /// In en, this message translates to:
  /// **'Last'**
  String get studyLast;

  /// No description provided for @studyShareAndExport.
  ///
  /// In en, this message translates to:
  /// **'Share & export'**
  String get studyShareAndExport;

  /// No description provided for @studyCloneStudy.
  ///
  /// In en, this message translates to:
  /// **'Clone'**
  String get studyCloneStudy;

  /// No description provided for @studyStudyPgn.
  ///
  /// In en, this message translates to:
  /// **'Study PGN'**
  String get studyStudyPgn;

  /// No description provided for @studyDownloadAllGames.
  ///
  /// In en, this message translates to:
  /// **'Download all games'**
  String get studyDownloadAllGames;

  /// No description provided for @studyChapterPgn.
  ///
  /// In en, this message translates to:
  /// **'Chapter PGN'**
  String get studyChapterPgn;

  /// No description provided for @studyCopyChapterPgn.
  ///
  /// In en, this message translates to:
  /// **'Copy PGN'**
  String get studyCopyChapterPgn;

  /// No description provided for @studyDownloadGame.
  ///
  /// In en, this message translates to:
  /// **'Download game'**
  String get studyDownloadGame;

  /// No description provided for @studyStudyUrl.
  ///
  /// In en, this message translates to:
  /// **'Study URL'**
  String get studyStudyUrl;

  /// No description provided for @studyCurrentChapterUrl.
  ///
  /// In en, this message translates to:
  /// **'Current chapter URL'**
  String get studyCurrentChapterUrl;

  /// No description provided for @studyYouCanPasteThisInTheForumToEmbed.
  ///
  /// In en, this message translates to:
  /// **'You can paste this in the forum or your Lichess blog to embed'**
  String get studyYouCanPasteThisInTheForumToEmbed;

  /// No description provided for @studyStartAtInitialPosition.
  ///
  /// In en, this message translates to:
  /// **'Start at initial position'**
  String get studyStartAtInitialPosition;

  /// No description provided for @studyStartAtX.
  ///
  /// In en, this message translates to:
  /// **'Start at {param}'**
  String studyStartAtX(String param);

  /// No description provided for @studyEmbedInYourWebsite.
  ///
  /// In en, this message translates to:
  /// **'Embed in your website'**
  String get studyEmbedInYourWebsite;

  /// No description provided for @studyReadMoreAboutEmbedding.
  ///
  /// In en, this message translates to:
  /// **'Read more about embedding'**
  String get studyReadMoreAboutEmbedding;

  /// No description provided for @studyOnlyPublicStudiesCanBeEmbedded.
  ///
  /// In en, this message translates to:
  /// **'Only public studies can be embedded!'**
  String get studyOnlyPublicStudiesCanBeEmbedded;

  /// No description provided for @studyOpen.
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get studyOpen;

  /// No description provided for @studyXBroughtToYouByY.
  ///
  /// In en, this message translates to:
  /// **'{param1}, brought to you by {param2}'**
  String studyXBroughtToYouByY(String param1, String param2);

  /// No description provided for @studyStudyNotFound.
  ///
  /// In en, this message translates to:
  /// **'Study not found'**
  String get studyStudyNotFound;

  /// No description provided for @studyEditChapter.
  ///
  /// In en, this message translates to:
  /// **'Edit chapter'**
  String get studyEditChapter;

  /// No description provided for @studyNewChapter.
  ///
  /// In en, this message translates to:
  /// **'New chapter'**
  String get studyNewChapter;

  /// No description provided for @studyImportFromChapterX.
  ///
  /// In en, this message translates to:
  /// **'Import from {param}'**
  String studyImportFromChapterX(String param);

  /// No description provided for @studyOrientation.
  ///
  /// In en, this message translates to:
  /// **'Orientation'**
  String get studyOrientation;

  /// No description provided for @studyAnalysisMode.
  ///
  /// In en, this message translates to:
  /// **'Analysis mode'**
  String get studyAnalysisMode;

  /// No description provided for @studyPinnedChapterComment.
  ///
  /// In en, this message translates to:
  /// **'Pinned chapter comment'**
  String get studyPinnedChapterComment;

  /// No description provided for @studySaveChapter.
  ///
  /// In en, this message translates to:
  /// **'Save chapter'**
  String get studySaveChapter;

  /// No description provided for @studyClearAnnotations.
  ///
  /// In en, this message translates to:
  /// **'Clear annotations'**
  String get studyClearAnnotations;

  /// No description provided for @studyClearVariations.
  ///
  /// In en, this message translates to:
  /// **'Clear variations'**
  String get studyClearVariations;

  /// No description provided for @studyDeleteChapter.
  ///
  /// In en, this message translates to:
  /// **'Delete chapter'**
  String get studyDeleteChapter;

  /// No description provided for @studyDeleteThisChapter.
  ///
  /// In en, this message translates to:
  /// **'Delete this chapter. There is no going back!'**
  String get studyDeleteThisChapter;

  /// No description provided for @studyClearAllCommentsInThisChapter.
  ///
  /// In en, this message translates to:
  /// **'Clear all comments, glyphs and drawn shapes in this chapter'**
  String get studyClearAllCommentsInThisChapter;

  /// No description provided for @studyRightUnderTheBoard.
  ///
  /// In en, this message translates to:
  /// **'Right under the board'**
  String get studyRightUnderTheBoard;

  /// No description provided for @studyNoPinnedComment.
  ///
  /// In en, this message translates to:
  /// **'None'**
  String get studyNoPinnedComment;

  /// No description provided for @studyNormalAnalysis.
  ///
  /// In en, this message translates to:
  /// **'Normal analysis'**
  String get studyNormalAnalysis;

  /// No description provided for @studyHideNextMoves.
  ///
  /// In en, this message translates to:
  /// **'Hide next moves'**
  String get studyHideNextMoves;

  /// No description provided for @studyInteractiveLesson.
  ///
  /// In en, this message translates to:
  /// **'Interactive lesson'**
  String get studyInteractiveLesson;

  /// No description provided for @studyChapterX.
  ///
  /// In en, this message translates to:
  /// **'Chapter {param}'**
  String studyChapterX(String param);

  /// No description provided for @studyEmpty.
  ///
  /// In en, this message translates to:
  /// **'Empty'**
  String get studyEmpty;

  /// No description provided for @studyStartFromInitialPosition.
  ///
  /// In en, this message translates to:
  /// **'Start from initial position'**
  String get studyStartFromInitialPosition;

  /// No description provided for @studyEditor.
  ///
  /// In en, this message translates to:
  /// **'Editor'**
  String get studyEditor;

  /// No description provided for @studyStartFromCustomPosition.
  ///
  /// In en, this message translates to:
  /// **'Start from custom position'**
  String get studyStartFromCustomPosition;

  /// No description provided for @studyLoadAGameByUrl.
  ///
  /// In en, this message translates to:
  /// **'Load games by URLs'**
  String get studyLoadAGameByUrl;

  /// No description provided for @studyLoadAPositionFromFen.
  ///
  /// In en, this message translates to:
  /// **'Load a position from FEN'**
  String get studyLoadAPositionFromFen;

  /// No description provided for @studyLoadAGameFromPgn.
  ///
  /// In en, this message translates to:
  /// **'Load games from PGN'**
  String get studyLoadAGameFromPgn;

  /// No description provided for @studyAutomatic.
  ///
  /// In en, this message translates to:
  /// **'Automatic'**
  String get studyAutomatic;

  /// No description provided for @studyUrlOfTheGame.
  ///
  /// In en, this message translates to:
  /// **'URL of the games, one per line'**
  String get studyUrlOfTheGame;

  /// No description provided for @studyLoadAGameFromXOrY.
  ///
  /// In en, this message translates to:
  /// **'Load games from {param1} or {param2}'**
  String studyLoadAGameFromXOrY(String param1, String param2);

  /// No description provided for @studyCreateChapter.
  ///
  /// In en, this message translates to:
  /// **'Create chapter'**
  String get studyCreateChapter;

  /// No description provided for @studyCreateStudy.
  ///
  /// In en, this message translates to:
  /// **'Create study'**
  String get studyCreateStudy;

  /// No description provided for @studyEditStudy.
  ///
  /// In en, this message translates to:
  /// **'Edit study'**
  String get studyEditStudy;

  /// No description provided for @studyVisibility.
  ///
  /// In en, this message translates to:
  /// **'Visibility'**
  String get studyVisibility;

  /// No description provided for @studyPublic.
  ///
  /// In en, this message translates to:
  /// **'Public'**
  String get studyPublic;

  /// No description provided for @studyUnlisted.
  ///
  /// In en, this message translates to:
  /// **'Unlisted'**
  String get studyUnlisted;

  /// No description provided for @studyInviteOnly.
  ///
  /// In en, this message translates to:
  /// **'Invite only'**
  String get studyInviteOnly;

  /// No description provided for @studyAllowCloning.
  ///
  /// In en, this message translates to:
  /// **'Allow cloning'**
  String get studyAllowCloning;

  /// No description provided for @studyNobody.
  ///
  /// In en, this message translates to:
  /// **'Nobody'**
  String get studyNobody;

  /// No description provided for @studyOnlyMe.
  ///
  /// In en, this message translates to:
  /// **'Only me'**
  String get studyOnlyMe;

  /// No description provided for @studyContributors.
  ///
  /// In en, this message translates to:
  /// **'Contributors'**
  String get studyContributors;

  /// No description provided for @studyMembers.
  ///
  /// In en, this message translates to:
  /// **'Members'**
  String get studyMembers;

  /// No description provided for @studyEveryone.
  ///
  /// In en, this message translates to:
  /// **'Everyone'**
  String get studyEveryone;

  /// No description provided for @studyEnableSync.
  ///
  /// In en, this message translates to:
  /// **'Enable sync'**
  String get studyEnableSync;

  /// No description provided for @studyYesKeepEveryoneOnTheSamePosition.
  ///
  /// In en, this message translates to:
  /// **'Yes: keep everyone on the same position'**
  String get studyYesKeepEveryoneOnTheSamePosition;

  /// No description provided for @studyNoLetPeopleBrowseFreely.
  ///
  /// In en, this message translates to:
  /// **'No: let people browse freely'**
  String get studyNoLetPeopleBrowseFreely;

  /// No description provided for @studyPinnedStudyComment.
  ///
  /// In en, this message translates to:
  /// **'Pinned study comment'**
  String get studyPinnedStudyComment;

  /// No description provided for @studyStart.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get studyStart;

  /// No description provided for @studySave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get studySave;

  /// No description provided for @studyClearChat.
  ///
  /// In en, this message translates to:
  /// **'Clear chat'**
  String get studyClearChat;

  /// No description provided for @studyDeleteTheStudyChatHistory.
  ///
  /// In en, this message translates to:
  /// **'Delete the study chat history? There is no going back!'**
  String get studyDeleteTheStudyChatHistory;

  /// No description provided for @studyDeleteStudy.
  ///
  /// In en, this message translates to:
  /// **'Delete study'**
  String get studyDeleteStudy;

  /// No description provided for @studyConfirmDeleteStudy.
  ///
  /// In en, this message translates to:
  /// **'Delete the entire study? There is no going back! Type the name of the study to confirm: {param}'**
  String studyConfirmDeleteStudy(String param);

  /// No description provided for @studyWhereDoYouWantToStudyThat.
  ///
  /// In en, this message translates to:
  /// **'Where do you want to study that?'**
  String get studyWhereDoYouWantToStudyThat;

  /// No description provided for @studyGoodMove.
  ///
  /// In en, this message translates to:
  /// **'Good move'**
  String get studyGoodMove;

  /// No description provided for @studyMistake.
  ///
  /// In en, this message translates to:
  /// **'Mistake'**
  String get studyMistake;

  /// No description provided for @studyBrilliantMove.
  ///
  /// In en, this message translates to:
  /// **'Brilliant move'**
  String get studyBrilliantMove;

  /// No description provided for @studyBlunder.
  ///
  /// In en, this message translates to:
  /// **'Blunder'**
  String get studyBlunder;

  /// No description provided for @studyInterestingMove.
  ///
  /// In en, this message translates to:
  /// **'Interesting move'**
  String get studyInterestingMove;

  /// No description provided for @studyDubiousMove.
  ///
  /// In en, this message translates to:
  /// **'Dubious move'**
  String get studyDubiousMove;

  /// No description provided for @studyOnlyMove.
  ///
  /// In en, this message translates to:
  /// **'Only move'**
  String get studyOnlyMove;

  /// No description provided for @studyZugzwang.
  ///
  /// In en, this message translates to:
  /// **'Zugzwang'**
  String get studyZugzwang;

  /// No description provided for @studyEqualPosition.
  ///
  /// In en, this message translates to:
  /// **'Equal position'**
  String get studyEqualPosition;

  /// No description provided for @studyUnclearPosition.
  ///
  /// In en, this message translates to:
  /// **'Unclear position'**
  String get studyUnclearPosition;

  /// No description provided for @studyWhiteIsSlightlyBetter.
  ///
  /// In en, this message translates to:
  /// **'White is slightly better'**
  String get studyWhiteIsSlightlyBetter;

  /// No description provided for @studyBlackIsSlightlyBetter.
  ///
  /// In en, this message translates to:
  /// **'Black is slightly better'**
  String get studyBlackIsSlightlyBetter;

  /// No description provided for @studyWhiteIsBetter.
  ///
  /// In en, this message translates to:
  /// **'White is better'**
  String get studyWhiteIsBetter;

  /// No description provided for @studyBlackIsBetter.
  ///
  /// In en, this message translates to:
  /// **'Black is better'**
  String get studyBlackIsBetter;

  /// No description provided for @studyWhiteIsWinning.
  ///
  /// In en, this message translates to:
  /// **'White is winning'**
  String get studyWhiteIsWinning;

  /// No description provided for @studyBlackIsWinning.
  ///
  /// In en, this message translates to:
  /// **'Black is winning'**
  String get studyBlackIsWinning;

  /// No description provided for @studyNovelty.
  ///
  /// In en, this message translates to:
  /// **'Novelty'**
  String get studyNovelty;

  /// No description provided for @studyDevelopment.
  ///
  /// In en, this message translates to:
  /// **'Development'**
  String get studyDevelopment;

  /// No description provided for @studyInitiative.
  ///
  /// In en, this message translates to:
  /// **'Initiative'**
  String get studyInitiative;

  /// No description provided for @studyAttack.
  ///
  /// In en, this message translates to:
  /// **'Attack'**
  String get studyAttack;

  /// No description provided for @studyCounterplay.
  ///
  /// In en, this message translates to:
  /// **'Counterplay'**
  String get studyCounterplay;

  /// No description provided for @studyTimeTrouble.
  ///
  /// In en, this message translates to:
  /// **'Time trouble'**
  String get studyTimeTrouble;

  /// No description provided for @studyWithCompensation.
  ///
  /// In en, this message translates to:
  /// **'With compensation'**
  String get studyWithCompensation;

  /// No description provided for @studyWithTheIdea.
  ///
  /// In en, this message translates to:
  /// **'With the idea'**
  String get studyWithTheIdea;

  /// No description provided for @studyNextChapter.
  ///
  /// In en, this message translates to:
  /// **'Next chapter'**
  String get studyNextChapter;

  /// No description provided for @studyPrevChapter.
  ///
  /// In en, this message translates to:
  /// **'Previous chapter'**
  String get studyPrevChapter;

  /// No description provided for @studyStudyActions.
  ///
  /// In en, this message translates to:
  /// **'Study actions'**
  String get studyStudyActions;

  /// No description provided for @studyTopics.
  ///
  /// In en, this message translates to:
  /// **'Topics'**
  String get studyTopics;

  /// No description provided for @studyMyTopics.
  ///
  /// In en, this message translates to:
  /// **'My topics'**
  String get studyMyTopics;

  /// No description provided for @studyPopularTopics.
  ///
  /// In en, this message translates to:
  /// **'Popular topics'**
  String get studyPopularTopics;

  /// No description provided for @studyManageTopics.
  ///
  /// In en, this message translates to:
  /// **'Manage topics'**
  String get studyManageTopics;

  /// No description provided for @studyBack.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get studyBack;

  /// No description provided for @studyPlayAgain.
  ///
  /// In en, this message translates to:
  /// **'Play again'**
  String get studyPlayAgain;

  /// No description provided for @studyWhatWouldYouPlay.
  ///
  /// In en, this message translates to:
  /// **'What would you play in this position?'**
  String get studyWhatWouldYouPlay;

  /// No description provided for @studyYouCompletedThisLesson.
  ///
  /// In en, this message translates to:
  /// **'Congratulations! You completed this lesson.'**
  String get studyYouCompletedThisLesson;

  /// No description provided for @studyPerPage.
  ///
  /// In en, this message translates to:
  /// **'{param} per page'**
  String studyPerPage(String param);

  /// No description provided for @studyNbChapters.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{{count} Chapter} other{{count} Chapters}}'**
  String studyNbChapters(int count);

  /// No description provided for @studyNbGames.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{{count} Game} other{{count} Games}}'**
  String studyNbGames(int count);

  /// No description provided for @studyNbMembers.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{{count} Member} other{{count} Members}}'**
  String studyNbMembers(int count);

  /// No description provided for @studyPasteYourPgnTextHereUpToNbGames.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Paste your PGN text here, up to {count} game} other{Paste games as PGN text here. For each game, a new chapter is created. The study can have up to {count} chapters.}}'**
  String studyPasteYourPgnTextHereUpToNbGames(int count);

  /// No description provided for @timeagoJustNow.
  ///
  /// In en, this message translates to:
  /// **'just now'**
  String get timeagoJustNow;

  /// No description provided for @timeagoRightNow.
  ///
  /// In en, this message translates to:
  /// **'right now'**
  String get timeagoRightNow;

  /// No description provided for @timeagoCompleted.
  ///
  /// In en, this message translates to:
  /// **'completed'**
  String get timeagoCompleted;

  /// No description provided for @timeagoInNbSeconds.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{in {count} second} other{in {count} seconds}}'**
  String timeagoInNbSeconds(int count);

  /// No description provided for @timeagoInNbMinutes.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{in {count} minute} other{in {count} minutes}}'**
  String timeagoInNbMinutes(int count);

  /// No description provided for @timeagoInNbHours.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{in {count} hour} other{in {count} hours}}'**
  String timeagoInNbHours(int count);

  /// No description provided for @timeagoInNbDays.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{in {count} day} other{in {count} days}}'**
  String timeagoInNbDays(int count);

  /// No description provided for @timeagoInNbWeeks.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{in {count} week} other{in {count} weeks}}'**
  String timeagoInNbWeeks(int count);

  /// No description provided for @timeagoInNbMonths.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{in {count} month} other{in {count} months}}'**
  String timeagoInNbMonths(int count);

  /// No description provided for @timeagoInNbYears.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{in {count} year} other{in {count} years}}'**
  String timeagoInNbYears(int count);

  /// No description provided for @timeagoNbMinutesAgo.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{{count} minute ago} other{{count} minutes ago}}'**
  String timeagoNbMinutesAgo(int count);

  /// No description provided for @timeagoNbHoursAgo.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{{count} hour ago} other{{count} hours ago}}'**
  String timeagoNbHoursAgo(int count);

  /// No description provided for @timeagoNbDaysAgo.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{{count} day ago} other{{count} days ago}}'**
  String timeagoNbDaysAgo(int count);

  /// No description provided for @timeagoNbWeeksAgo.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{{count} week ago} other{{count} weeks ago}}'**
  String timeagoNbWeeksAgo(int count);

  /// No description provided for @timeagoNbMonthsAgo.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{{count} month ago} other{{count} months ago}}'**
  String timeagoNbMonthsAgo(int count);

  /// No description provided for @timeagoNbYearsAgo.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{{count} year ago} other{{count} years ago}}'**
  String timeagoNbYearsAgo(int count);

  /// No description provided for @timeagoNbMinutesRemaining.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{{count} minute remaining} other{{count} minutes remaining}}'**
  String timeagoNbMinutesRemaining(int count);

  /// No description provided for @timeagoNbHoursRemaining.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{{count} hour remaining} other{{count} hours remaining}}'**
  String timeagoNbHoursRemaining(int count);
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'af', 'ar', 'az', 'be', 'bg', 'bn', 'bs', 'ca', 'cs', 'da', 'de', 'el', 'eo', 'es', 'et', 'eu', 'fa', 'fi', 'fr', 'gl', 'gsw', 'he', 'hi', 'hr', 'hu', 'hy', 'id', 'it', 'ja', 'kk', 'ko', 'lt', 'lv', 'mk', 'nb', 'nl', 'pl', 'pt', 'ro', 'ru', 'sk', 'sl', 'sq', 'sr', 'sv', 'tr', 'uk', 'vi', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {

  // Lookup logic when language+country codes are specified.
  switch (locale.languageCode) {
    case 'en': {
  switch (locale.countryCode) {
    case 'US': return AppLocalizationsEnUs();
   }
  break;
   }
    case 'pt': {
  switch (locale.countryCode) {
    case 'BR': return AppLocalizationsPtBr();
   }
  break;
   }
    case 'zh': {
  switch (locale.countryCode) {
    case 'TW': return AppLocalizationsZhTw();
   }
  break;
   }
  }

  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'af': return AppLocalizationsAf();
    case 'ar': return AppLocalizationsAr();
    case 'az': return AppLocalizationsAz();
    case 'be': return AppLocalizationsBe();
    case 'bg': return AppLocalizationsBg();
    case 'bn': return AppLocalizationsBn();
    case 'bs': return AppLocalizationsBs();
    case 'ca': return AppLocalizationsCa();
    case 'cs': return AppLocalizationsCs();
    case 'da': return AppLocalizationsDa();
    case 'de': return AppLocalizationsDe();
    case 'el': return AppLocalizationsEl();
    case 'eo': return AppLocalizationsEo();
    case 'es': return AppLocalizationsEs();
    case 'et': return AppLocalizationsEt();
    case 'eu': return AppLocalizationsEu();
    case 'fa': return AppLocalizationsFa();
    case 'fi': return AppLocalizationsFi();
    case 'fr': return AppLocalizationsFr();
    case 'gl': return AppLocalizationsGl();
    case 'gsw': return AppLocalizationsGsw();
    case 'he': return AppLocalizationsHe();
    case 'hi': return AppLocalizationsHi();
    case 'hr': return AppLocalizationsHr();
    case 'hu': return AppLocalizationsHu();
    case 'hy': return AppLocalizationsHy();
    case 'id': return AppLocalizationsId();
    case 'it': return AppLocalizationsIt();
    case 'ja': return AppLocalizationsJa();
    case 'kk': return AppLocalizationsKk();
    case 'ko': return AppLocalizationsKo();
    case 'lt': return AppLocalizationsLt();
    case 'lv': return AppLocalizationsLv();
    case 'mk': return AppLocalizationsMk();
    case 'nb': return AppLocalizationsNb();
    case 'nl': return AppLocalizationsNl();
    case 'pl': return AppLocalizationsPl();
    case 'pt': return AppLocalizationsPt();
    case 'ro': return AppLocalizationsRo();
    case 'ru': return AppLocalizationsRu();
    case 'sk': return AppLocalizationsSk();
    case 'sl': return AppLocalizationsSl();
    case 'sq': return AppLocalizationsSq();
    case 'sr': return AppLocalizationsSr();
    case 'sv': return AppLocalizationsSv();
    case 'tr': return AppLocalizationsTr();
    case 'uk': return AppLocalizationsUk();
    case 'vi': return AppLocalizationsVi();
    case 'zh': return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
