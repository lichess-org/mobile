// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'l10n.dart';

// ignore_for_file: type=lint

/// The translations for Modern Greek (`el`).
class AppLocalizationsEl extends AppLocalizations {
  AppLocalizationsEl([String locale = 'el']) : super(locale);

  @override
  String get mobileAllGames => 'Όλα τα παιχνίδια';

  @override
  String get mobileAreYouSure => 'Είστε σίγουροι;';

  @override
  String get mobileCancelTakebackOffer => 'Ακυρώστε την προσφορά αναίρεσης της κίνησης';

  @override
  String get mobileClearButton => 'Εκκαθάριση';

  @override
  String get mobileCorrespondenceClearSavedMove => 'Εκκαθάριση αποθηκευμένης κίνησης';

  @override
  String get mobileCustomGameJoinAGame => 'Συμμετοχή σε παρτίδα';

  @override
  String get mobileFeedbackButton => 'Πείτε μας τη γνώμη σας';

  @override
  String mobileGreeting(String param) {
    return 'Καλωσορίσατε, $param';
  }

  @override
  String get mobileGreetingWithoutName => 'Καλωσορίσατε';

  @override
  String get mobileHideVariation => 'Απόκρυψη παραλλαγής';

  @override
  String get mobileHomeTab => 'Αρχική';

  @override
  String get mobileLiveStreamers => 'Streamers ζωντανά αυτή τη στιγμή';

  @override
  String get mobileMustBeLoggedIn => 'Πρέπει να συνδεθείτε για να δείτε αυτή τη σελίδα.';

  @override
  String get mobileNoSearchResults => 'Δεν βρέθηκαν αποτελέσματα';

  @override
  String get mobileNotFollowingAnyUser => 'Δεν ακολουθείτε κανέναν χρήστη.';

  @override
  String get mobileOkButton => 'ΟΚ';

  @override
  String mobilePlayersMatchingSearchTerm(String param) {
    return 'Παίκτες με \"$param\"';
  }

  @override
  String get mobilePrefMagnifyDraggedPiece => 'Μεγέθυνση του επιλεγμένου κομματιού';

  @override
  String get mobilePuzzleStormConfirmEndRun => 'Θέλετε να τερματίσετε αυτόν τον γύρο;';

  @override
  String get mobilePuzzleStormFilterNothingToShow => 'Δεν υπάρχουν γρίφοι για τις συγκεκριμένες επιλογές φίλτρων, παρακαλώ δοκιμάστε κάποιες άλλες';

  @override
  String get mobilePuzzleStormNothingToShow => 'Δεν υπάρχουν στοιχεία. Παίξτε κάποιους γύρους Puzzle Storm.';

  @override
  String get mobilePuzzleStormSubtitle => 'Λύστε όσους γρίφους όσο το δυνατόν, σε 3 λεπτά.';

  @override
  String get mobilePuzzleStreakAbortWarning => 'Θα χάσετε το τρέχων σερί αποτελεσμάτων σας και η βαθμολογία θα αποθηκευτεί.';

  @override
  String get mobilePuzzleThemesSubtitle => 'Παίξτε γρίφους από τα αγαπημένα σας ανοίγματα, ή επιλέξτε θέμα.';

  @override
  String get mobilePuzzlesTab => 'Γρίφοι';

  @override
  String get mobileRecentSearches => 'Πρόσφατες αναζητήσεις';

  @override
  String get mobileSettingsHapticFeedback => 'Απόκριση δόνησης';

  @override
  String get mobileSettingsImmersiveMode => 'Λειτουργία εστίασης';

  @override
  String get mobileSettingsImmersiveModeSubtitle => 'Αποκρύπτει τη διεπαφή του συστήματος όσο παίζεται. Ενεργοποιήστε εάν σας ενοχλούν οι χειρονομίες πλοήγησης του συστήματος στα άκρα της οθόνης. Ισχύει για την προβολή παιχνιδιού και το Puzzle Storm.';

  @override
  String get mobileSettingsTab => 'Ρυθμίσεις';

  @override
  String get mobileShareGamePGN => 'Κοινοποίηση PGN';

  @override
  String get mobileShareGameURL => 'Κοινοποίηση URL παιχνιδιού';

  @override
  String get mobileSharePositionAsFEN => 'Κοινοποίηση θέσης ως FEN';

  @override
  String get mobileSharePuzzle => 'Κοινοποίηση γρίφου';

  @override
  String get mobileShowComments => 'Εμφάνιση σχολίων';

  @override
  String get mobileShowResult => 'Εμφάνιση αποτελέσματος';

  @override
  String get mobileShowVariations => 'Εμφάνιση παραλλαγών';

  @override
  String get mobileSomethingWentWrong => 'Κάτι πήγε στραβά.';

  @override
  String get mobileSystemColors => 'Χρώματα συστήματος';

  @override
  String get mobileTheme => 'Εμφάνιση';

  @override
  String get mobileToolsTab => 'Εργαλεία';

  @override
  String get mobileWaitingForOpponentToJoin => 'Αναμονή για αντίπαλο...';

  @override
  String get mobileWatchTab => 'Δείτε';

  @override
  String get activityActivity => 'Δραστηριότητα';

  @override
  String get activityHostedALiveStream => 'Μεταδίδει ζωντανά';

  @override
  String activityRankedInSwissTournament(String param1, String param2) {
    return 'Κατατάχθηκε #$param1 στο $param2';
  }

  @override
  String get activitySignedUp => 'Έκανε εγγραφή στο lichess.org';

  @override
  String activitySupportedNbMonths(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Υποστήριξε το lichess για $count μήνες ως $param2',
      one: 'Υποστήριξε το lichess για $count μήνα ως $param2',
    );
    return '$_temp0';
  }

  @override
  String activityPracticedNbPositions(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Εξασκήθηκε $count θέσεις σε $param2',
      one: 'Εξασκήθηκε $count θέση σε $param2',
    );
    return '$_temp0';
  }

  @override
  String activitySolvedNbPuzzles(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Έλυσε $count τακτικούς γρίφους',
      one: 'Έλυσε $count τακτικό γρίφο',
    );
    return '$_temp0';
  }

  @override
  String activityPlayedNbGames(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Έπαιξε $count παρτίδες $param2',
      one: 'Έπαιξε $count παρτίδα $param2',
    );
    return '$_temp0';
  }

  @override
  String activityPostedNbMessages(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Δημοσίευσε $count μηνύματα στο $param2',
      one: 'Δημοσίευσε $count μήνυμα στο $param2',
    );
    return '$_temp0';
  }

  @override
  String activityPlayedNbMoves(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Έπαιξε $count κινήσεις',
      one: 'Έπαιξε $count κίνηση',
    );
    return '$_temp0';
  }

  @override
  String activityInNbCorrespondenceGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'σε $count παρτίδες αλληλογραφίας',
      one: 'σε $count παρτίδα αλληλογραφίας',
    );
    return '$_temp0';
  }

  @override
  String activityCompletedNbGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Ολοκλήρωσε $count παρτίδες αλληλογραφίας',
      one: 'Ολοκλήρωσε $count παρτίδα αλληλογραφίας',
    );
    return '$_temp0';
  }

  @override
  String activityCompletedNbVariantGames(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Ολοκλήρωσε $count παρτίδες αλληλογραφίας $param2',
      one: 'Ολοκλήρωσε $count παρτίδα αλληλογραφίας $param2',
    );
    return '$_temp0';
  }

  @override
  String activityFollowedNbPlayers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Άρχισε να ακολουθεί $count παίκτες',
      one: 'Άρχισε να ακολουθεί $count παίκτη',
    );
    return '$_temp0';
  }

  @override
  String activityGainedNbFollowers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Απέκτησε $count νέους ακόλουθους',
      one: 'Απέκτησε $count νέο ακόλουθο',
    );
    return '$_temp0';
  }

  @override
  String activityHostedNbSimuls(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Φιλοξένησε $count σιμουλτανέ',
      one: 'Φιλοξένησε $count σιμουλτανέ',
    );
    return '$_temp0';
  }

  @override
  String activityJoinedNbSimuls(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Συμμετείχε σε $count σιμουλτανέ',
      one: 'Συμμετείχε σε $count σιμουλτανέ',
    );
    return '$_temp0';
  }

  @override
  String activityCreatedNbStudies(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Δημιούργησε $count νέες μελέτες',
      one: 'Δημιούργησε $count νέα μελέτη',
    );
    return '$_temp0';
  }

  @override
  String activityCompetedInNbTournaments(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Αγωνίστηκε σε $count τουρνουά',
      one: 'Αγωνίστηκε σε $count τουρνουά',
    );
    return '$_temp0';
  }

  @override
  String activityRankedInTournament(int count, String param2, String param3, String param4) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Κατατάχθηκε #$count (κορυφαίος $param2%) με $param3 παιχνίδια σε $param4',
      one: 'Κατατάχθηκε #$count (κορυφαίος $param2%) με $param3 παιχνίδι σε $param4',
    );
    return '$_temp0';
  }

  @override
  String activityCompetedInNbSwissTournaments(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Αγωνίστηκε σε $count ελβετικά τουρνουά',
      one: 'Αγωνίστηκε σε $count ελβετικό τουρνουά',
    );
    return '$_temp0';
  }

  @override
  String activityJoinedNbTeams(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Έγινε μέλος $count ομαδών',
      one: 'Έγινε μέλος $count ομάδας',
    );
    return '$_temp0';
  }

  @override
  String get arenaArena => 'Αρένα';

  @override
  String get arenaArenaTournaments => 'Τουρνουά αρένας';

  @override
  String get arenaIsItRated => 'Είναι βαθμολογημένο;';

  @override
  String get arenaWillBeNotified => 'Θα ειδοποιηθείτε όταν ξεκινήσει το τουρνουά, έτσι είναι ασφαλές να παίξετε σε άλλη καρτέλα όσο περιμένετε.';

  @override
  String get arenaIsRated => 'Αυτό το τουρνουά είναι με αξιολόγηση και θα επηρεάσει την βαθμολογία σας.';

  @override
  String get arenaIsNotRated => 'Αυτό το τουρνουά *δεν* είναι βαθμολογημένο και *δεν* θα επηρεάσει την βαθμολογία σας.';

  @override
  String get arenaSomeRated => 'Ορισμένα πρωταθλήματα είναι βαθμολογημένα και θα επηρεάσουν την βαθμολογία σας.';

  @override
  String get arenaHowAreScoresCalculated => 'Πως υπολογίζονται οι βαθμολογίες;';

  @override
  String get arenaHowAreScoresCalculatedAnswer => 'Η νίκη αξίζει 2 πόντους, η ισοπαλία 1 πόντο, και η ήττα κανένα.\nΑν νικήσετε δύο παρτίδες συνεχόμενα αποδίδονται διπλάσιοι πόντοι,\nπου αντιπροσωπεύονται από ένα εικονίδιο φλόγας.\nΟι επόμενες παρτίδες θα αξίζουν διπλάσιους πόντους μέχρι να χάσετε μία. Επομένως, η νίκη θα βαθμολογείται με 4 πόντους, η ισοπαλία 2 πόντους, και η ήττα 0.\nΓια παράδειγμα, δύο νίκες και μία ισοπαλία αξίζουν 6 πόντους: 2 + 2 + (2 x 1)';

  @override
  String get arenaBerserk => 'Αρένα Berserk';

  @override
  String get arenaBerserkAnswer => 'Όταν ο παίκτης πατήσει το πλήκτρο Berserk στην έναρξη της παρτίδας, χάνει τον μισό χρόνο στο ρολόι, αλλά η νίκη αξίζει ένα έξτρα πόντο στο τουρνουά.\n\nΠατώντας Berserk σε χρόνους με προσαύξηση, ακυρώνεται η προσαύξηση (εξαιρείται το 1+2, που γίνεται 1+0). \n\nTo Berserk δεν ισχύει για παρτίδες με μηδενικό αρχικό χρόνο (0+1, 0+2).\n\nΤο Berserk προσθέτει ένα έξτρα πόντο μόνο αν παιχθούν τουλάχιστον 7 κινήσεις στην παρτίδα.';

  @override
  String get arenaHowIsTheWinnerDecided => 'Πως αναδεικνύεται ο νικητής;';

  @override
  String get arenaHowIsTheWinnerDecidedAnswer => 'Ο παίκτης/παίκτες με τους περισσότερους πόντους μετά τη λήξη του προκαθορισμένου χρόνου του τουρνουά αναδεικνύεται/αναδεικνύονται νικητής/νικητής.\n\nΌταν δύο ή περισσότεροι παίκτες έχουν τους ίδιους πόντους, η επίδοση στον διαγωνισμό καθορίζει τον νικητή.';

  @override
  String get arenaHowDoesPairingWork => 'Πως λειτουργεί η αντιστοίχιση;';

  @override
  String get arenaHowDoesPairingWorkAnswer => 'Στην αρχή του διαγωνισμού, οι παίκτες αντιστοιχίζονται βάσει της βαθμολογίας τους.\nΜόλις τελειώσει η παρτίδα σας, επιστρέφετε στο δωμάτιο αναμονής του τουρνουά όπου θα κληρωθείτε με παίκτη κοντά στην κατάταξή σας. Αυτό εξασφαλίζει μικρό χρόνο αναμονής, ωστόσο μπορεί να μην αντιμετωπίσετε όλους τους άλλους παίκτες στο πρωτάθλημα.\nΠαίξτε γρήγορα και επιστρέψτε στο δωμάτιο αναμονής για να παίξετε περισσότερες παρτίδες και να κερδίσετε περισσότερους πόντους.';

  @override
  String get arenaHowDoesItEnd => 'Πως τελειώνει;';

  @override
  String get arenaHowDoesItEndAnswer => 'Το τουρνουά έχει ρολόι αντίστροφης μέτρησης. Όταν αυτό φτάσει στο μηδέν, η βαθμολογίες των παικτών κλειδώνουν, και αναδεικνύεται ο νικητής. Οι παρτίδες σε εξέλιξη πρέπει να ολοκληρωθούν, ωστόσο το αποτέλεσμα τους δεν μετράει για το πρωτάθλημα.';

  @override
  String get arenaOtherRules => 'Άλλοι σημαντικοί κανόνες';

  @override
  String get arenaThereIsACountdown => 'Υπάρχει αντίστροφη μέτρηση για την πρώτη κίνηση. Εάν δεν κάνετε την πρώτη σας κίνηση μέσα σε αυτό το χρονικό διάστημα θα χάσετε την παρτίδα.';

  @override
  String get arenaThisIsPrivate => 'Αυτός ο διαγωνισμός είναι ιδιωτικός';

  @override
  String arenaShareUrl(String param) {
    return 'Μοιραστείτε αυτήν την διεύθυνση URL για να συμμετάσχουν άλλα άτομα: $param';
  }

  @override
  String arenaDrawStreakStandard(String param) {
    return 'Συνεχόμενες ισοπαλίες: Όταν ένας παίκτης έχει συνεχόμενες ισοπαλίες στην αρένα, είτε μόνο η πρώτη θα δώσει ένα πόντο, είτε ισοπαλίες που διήρκησαν πάνω από $param κινήσεις. Οι συνεχόμενες ισοπαλίες σταματούν να θεωρούνται συνεχόμενες μόνο εφόσον τις ακολουθήσει μία νίκη και όχι μία ήττα ή ισοπαλία.';
  }

  @override
  String get arenaDrawStreakVariants => 'Ο ελάχιστος αριθμός των κινήσεων που απαιτούνται στα ισόπαλα παιχνίδια για να δώσουν πόντους εξαρτάται από την κάθε παραλλαγή, όπως φαίνεται και στον παρακάτω πίνακα.';

  @override
  String get arenaVariant => 'Εκδοχή';

  @override
  String get arenaMinimumGameLength => 'Ελάχιστος αριθμός κινήσεων';

  @override
  String get arenaHistory => 'Ιστορικό αρένας';

  @override
  String get arenaNewTeamBattle => 'Νέα ομαδική μάχη';

  @override
  String get arenaCustomStartDate => 'Προσαρμοσμένη ημερομηνία έναρξης';

  @override
  String get arenaCustomStartDateHelp => 'Στην τοπική ζώνη ώρας σας. Αυτό υπερισχύει της ρύθμισης \"Χρόνος προτού ξεκινήσει το πρωτάθλημα\"';

  @override
  String get arenaAllowBerserk => 'Να επιτρέπεται το Berserk';

  @override
  String get arenaAllowBerserkHelp => 'Να επιτρέπεται στους παίκτες να μειώσουν τον χρόνο στο ρολόι τους κατά το ήμισυ για να κερδίσουν έναν επιπλέον πόντο';

  @override
  String get arenaAllowChatHelp => 'Να επιτρέπεται στους παίκτες να συζητούν σε δωμάτιο συνομιλίας';

  @override
  String get arenaArenaStreaks => 'Arena streaks';

  @override
  String get arenaArenaStreaksHelp => 'Μετά από 2 νίκες, επιπλέον διαδοχικές νίκες σας 4 πόντους αντί για 2.';

  @override
  String get arenaNoBerserkAllowed => 'Δεν επιτρέπεται το berserk';

  @override
  String get arenaNoArenaStreaks => 'Χωρίς σερί νικών Αρένας';

  @override
  String get arenaAveragePerformance => 'Μέση επίδοση';

  @override
  String get arenaAverageScore => 'Μέση βαθμολογία';

  @override
  String get arenaMyTournaments => 'Τα τουρνουά μου';

  @override
  String get arenaEditTournament => 'Επεξεργασία τουρνουά';

  @override
  String get arenaEditTeamBattle => 'Επεξεργασία ομαδικής μάχης';

  @override
  String get arenaDefender => 'Υπερασπιστής';

  @override
  String get arenaPickYourTeam => 'Διαλέξτε την ομάδα σας';

  @override
  String get arenaWhichTeamWillYouRepresentInThisBattle => 'Ποια ομάδα θα αντιπροσωπεύσετε σε αυτή τη μάχη;';

  @override
  String get arenaYouMustJoinOneOfTheseTeamsToParticipate => 'Πρέπει να μπείτε σε μία από αυτές τις ομάδες για να συμμετάσχετε!';

  @override
  String get arenaCreated => 'Δημιουργήθηκε';

  @override
  String get arenaRecentlyPlayed => 'Παίχτηκαν πρόσφατα';

  @override
  String get arenaBestResults => 'Καλύτερα αποτελέσματα';

  @override
  String get arenaTournamentStats => 'Στατιστικά τουρνουά';

  @override
  String get arenaRankAvgHelp => 'Ο μέσος όρος κατάταξης είναι ένα ποσοστό της κατάταξης σας. Χαμηλότερο είναι καλύτερο.\n\nΓια παράδειγμα, είστε τρίτος σε ένα τουρνουά 100 παικτών = 3%. Όντας δέκατος σε ένα τουρνουά 1000 παικτών = 1%.';

  @override
  String get arenaMedians => 'διάμεσες τιμές';

  @override
  String arenaAllAveragesAreX(String param) {
    return 'Όλοι οι μέσοι όροι σε αυτήν τη σελίδα είναι $param.';
  }

  @override
  String get arenaTotal => 'Σύνολο';

  @override
  String get arenaPointsAvg => 'Μέσος όρος πόντων';

  @override
  String get arenaPointsSum => 'Σύνολο πόντων';

  @override
  String get arenaRankAvg => 'Μέσος όρος κατάταξης';

  @override
  String get arenaTournamentWinners => 'Νικητές πρωταθλήματος';

  @override
  String get arenaTournamentShields => 'Πρωταθλήματα Ασπίδας';

  @override
  String get arenaOnlyTitled => 'Μόνο τιτλούχοι παίκτες';

  @override
  String get arenaOnlyTitledHelp => 'Χρειάζεται ένας επίσημος τίτλος για συμμετοχή στο πρωτάθλημα';

  @override
  String get arenaTournamentPairingsAreNowClosed => 'The tournament pairings are now closed.';

  @override
  String get arenaBerserkRate => 'Berserk rate';

  @override
  String arenaDrawingWithinNbMoves(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Η συμφωνία ισοπαλίας στις πρώτες $count κινήσεις δε δίνει πόντους σε κανέναν παίκτη.',
      one: 'Η συμφωνία ισοπαλίας στην πρώτη $count κίνηση δε δίνει πόντους σε κανέναν παίκτη.',
    );
    return '$_temp0';
  }

  @override
  String arenaViewAllXTeams(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Δείτε όλες τις $count ομάδες',
      one: 'Δείτε την ομάδα',
    );
    return '$_temp0';
  }

  @override
  String get broadcastBroadcasts => 'Αναμεταδόσεις';

  @override
  String get broadcastMyBroadcasts => 'Οι αναμεταδόσεις μου';

  @override
  String get broadcastLiveBroadcasts => 'Αναμεταδόσεις ζωντανών τουρνουά';

  @override
  String get broadcastBroadcastCalendar => 'Ημερολόγιο αναμεταδόσεων';

  @override
  String get broadcastNewBroadcast => 'Νέα ζωντανή αναμετάδοση';

  @override
  String get broadcastSubscribedBroadcasts => 'Εγγεγραμμένες αναμεταδόσεις';

  @override
  String get broadcastAboutBroadcasts => 'Σχετικά με τις αναμεταδόσεις';

  @override
  String get broadcastHowToUseLichessBroadcasts => 'Πώς να χρησιμοποιήσετε τις αναμεταδόσεις Lichess.';

  @override
  String get broadcastTheNewRoundHelp => 'Ο νέος γύρος θα έχει τα ίδια μέλη και τους ίδιους συνεισφέροντες όπως ο προηγούμενος.';

  @override
  String get broadcastAddRound => 'Προσθήκη γύρου';

  @override
  String get broadcastOngoing => 'Σε εξέλιξη';

  @override
  String get broadcastUpcoming => 'Προσεχή';

  @override
  String get broadcastRoundName => 'Όνομα γύρου';

  @override
  String get broadcastRoundNumber => 'Αριθμός γύρου';

  @override
  String get broadcastTournamentName => 'Όνομα τουρνουά';

  @override
  String get broadcastTournamentDescription => 'Σύντομη περιγραφή τουρνουά';

  @override
  String get broadcastFullDescription => 'Πλήρης περιγραφή γεγονότος';

  @override
  String broadcastFullDescriptionHelp(String param1, String param2) {
    return 'Προαιρετική αναλυτική περιγραφή της αναμετάδοσης. Η μορφή $param1 είναι διαθέσιμη. Το μήκος πρέπει μικρότερο από $param2 χαρακτήρες.';
  }

  @override
  String get broadcastSourceSingleUrl => 'Πηγαίο URL για PGN';

  @override
  String get broadcastSourceUrlHelp => 'URL για λήψη PGN ενημερώσεων. Πρέπει να είναι δημόσια προσβάσιμο μέσω διαδικτύου.';

  @override
  String get broadcastSourceGameIds => 'Έως και 64 ταυτότητες παιχνιδιών Lichess, διαχωριζόμενες από κενά.';

  @override
  String broadcastStartDateTimeZone(String param) {
    return 'Ημερομηνία έναρξης του τουρνουά στην τοπική ζώνη ώρας: $param';
  }

  @override
  String get broadcastStartDateHelp => 'Προαιρετικό, εάν γνωρίζετε πότε αρχίζει η εκδήλωση';

  @override
  String get broadcastCurrentGameUrl => 'Διεύθυνση URL αυτής της παρτίδας';

  @override
  String get broadcastDownloadAllRounds => 'Λήψη όλων των γύρων';

  @override
  String get broadcastResetRound => 'Επαναφορά αυτού του γύρου';

  @override
  String get broadcastDeleteRound => 'Διαγραφή αυτού του γύρου';

  @override
  String get broadcastDefinitivelyDeleteRound => 'Διαγράψτε οριστικά τον γύρο και όλες τις παρτίδες του.';

  @override
  String get broadcastDeleteAllGamesOfThisRound => 'Διαγράψτε όλες τις παρτίδες αυτού του γύρου. Η πηγή μετάδοσης θα πρέπει να είναι ενεργή για να τα ξαναδημιουργήσετε.';

  @override
  String get broadcastEditRoundStudy => 'Επεξεργασία μελέτης γύρου';

  @override
  String get broadcastDeleteTournament => 'Διαγραφή αυτού του τουρνουά';

  @override
  String get broadcastDefinitivelyDeleteTournament => 'Σίγουρα διαγράψτε ολόκληρο τον διαγωνισμό, όλους τους γύρους του και όλες τις παρτίδες του.';

  @override
  String get broadcastShowScores => 'Εμφάνιση βαθμολογιών παικτών βάσει των αποτελεσμάτων των παρτίδων.';

  @override
  String get broadcastReplacePlayerTags => 'Προαιρετικό: αντικατάσταση ονομάτων, βαθμολογιών και τίτλων παικτών';

  @override
  String get broadcastFideFederations => 'Ομοσπονδίες FIDE';

  @override
  String get broadcastTop10Rating => 'Κορυφαίες 10 βαθμολογίες';

  @override
  String get broadcastFidePlayers => 'Παίκτες FIDE';

  @override
  String get broadcastFidePlayerNotFound => 'Δε βρέθηκε παίκτης FIDE';

  @override
  String get broadcastFideProfile => 'Προφίλ FIDE';

  @override
  String get broadcastFederation => 'Ομοσπονδία';

  @override
  String get broadcastAgeThisYear => 'Φετινή ηλικία';

  @override
  String get broadcastUnrated => 'Μη βαθμολογημένο';

  @override
  String get broadcastRecentTournaments => 'Πρόσφατα τουρνουά';

  @override
  String get broadcastOpenLichess => 'Άνοιγμα στο Lichess';

  @override
  String get broadcastTeams => 'Ομάδες';

  @override
  String get broadcastBoards => 'Σκακιέρες';

  @override
  String get broadcastOverview => 'Επισκόπηση';

  @override
  String get broadcastSubscribeTitle => 'Εγγραφείτε για να ειδοποιείστε όταν ξεκινάει ο κάθε γύρος. Μπορείτε να εναλλάξετε μεταξύ του κουδουνιού ή των push ειδοποιήσεων για αναμεταδόσεις, στις προτιμήσεις του λογαριασμού σας.';

  @override
  String get broadcastUploadImage => 'Ανεβάστε εικόνα τουρνουά';

  @override
  String get broadcastNoBoardsYet => 'Δεν υπάρχουν διαθέσιμες σκακιέρες ακόμα. Θα εμφανιστούν μόλις φορτωθούν οι παρτίδες.';

  @override
  String broadcastBoardsCanBeLoaded(String param) {
    return 'Οι σκακιέρες μπορούν να φορτωθούν από μια πηγή ή μέσω του $param';
  }

  @override
  String broadcastStartsAfter(String param) {
    return 'Ξεκινάει μετά από $param';
  }

  @override
  String get broadcastStartVerySoon => 'Η αναμετάδοση θα ξεκινήσει πολύ σύντομα.';

  @override
  String get broadcastNotYetStarted => 'Η αναμετάδοση δεν έχει ξεκινήσει ακόμα.';

  @override
  String get broadcastOfficialWebsite => 'Επίσημη ιστοσελίδα';

  @override
  String get broadcastStandings => 'Κατάταξη';

  @override
  String get broadcastOfficialStandings => 'Επίσημη Κατάταξη';

  @override
  String broadcastIframeHelp(String param) {
    return 'Περισσότερες επιλογές στη $param';
  }

  @override
  String get broadcastWebmastersPage => 'σελίδα για webmasters';

  @override
  String broadcastPgnSourceHelp(String param) {
    return 'Μια δημόσια πηγή PGN πολύ λειτουργεί σε πραγματικό χρόνο για αυτόν τον γύρο. Προσφέρουμε επίσης το $param για γρηγορότερο και αποτελεσματικότερο συγχρονισμό.';
  }

  @override
  String get broadcastEmbedThisBroadcast => 'Ενσωμάτωση αυτήν την αναμετάδοση στην ιστοσελίδα σας';

  @override
  String broadcastEmbedThisRound(String param) {
    return 'Ενσωματώστε τον $param στην ιστοσελίδα σας';
  }

  @override
  String get broadcastRatingDiff => 'Διαφορά βαθμολογίας';

  @override
  String get broadcastGamesThisTournament => 'Παρτίδες σε αυτό το τουρνουά';

  @override
  String get broadcastScore => 'Βαθμολογία';

  @override
  String get broadcastAllTeams => 'Όλες οι ομάδες';

  @override
  String get broadcastTournamentFormat => 'Μορφή τουρνουά';

  @override
  String get broadcastTournamentLocation => 'Τοποθεσία Τουρνουά';

  @override
  String get broadcastTopPlayers => 'Κορυφαίοι παίκτες';

  @override
  String get broadcastTimezone => 'Ζώνη ώρας';

  @override
  String get broadcastFideRatingCategory => 'Κατηγορία αξιολόγησης FIDE';

  @override
  String get broadcastOptionalDetails => 'Προαιρετικές λεπτομέρειες';

  @override
  String get broadcastPastBroadcasts => 'Προηγούμενες αναμεταδόσεις';

  @override
  String get broadcastAllBroadcastsByMonth => 'Προβολή όλων των αναμεταδόσεων ανά μήνα';

  @override
  String get broadcastBackToLiveMove => 'Back to live move';

  @override
  String get broadcastSinceHideResults => 'Εφόσον επιλέξατε να κρύψετε τα αποτελέσματα, όλες οι σκακιέρες προεπισκόπησης είναι κενές ώστε να αποφευχθούν σπόιλερς.';

  @override
  String get broadcastLiveboard => 'Live board';

  @override
  String broadcastNbBroadcasts(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count αναμεταδόσεις',
      one: '$count αναμετάδοση',
    );
    return '$_temp0';
  }

  @override
  String broadcastNbViewers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count viewers',
      one: '$count viewer',
    );
    return '$_temp0';
  }

  @override
  String challengeChallengesX(String param1) {
    return 'Προκλήσεις: $param1';
  }

  @override
  String get challengeChallengeToPlay => 'Προκαλέστε σε παιχνίδι';

  @override
  String get challengeChallengeDeclined => 'Η πρόκληση απορρίφθηκε';

  @override
  String get challengeChallengeAccepted => 'Η πρόκληση έγινε δεκτή!';

  @override
  String get challengeChallengeCanceled => 'Η πρόκληση ακυρώθηκε.';

  @override
  String get challengeRegisterToSendChallenges => 'Εγγραφείτε για να στείλετε προκλήσεις.';

  @override
  String challengeYouCannotChallengeX(String param) {
    return 'Δεν μπορείτε να προκαλέσετε τον $param.';
  }

  @override
  String challengeXDoesNotAcceptChallenges(String param) {
    return '$param δε δέχεται προκλήσεις.';
  }

  @override
  String challengeYourXRatingIsTooFarFromY(String param1, String param2) {
    return 'Η βαθμολογία σας στο $param1 διαφέρει σημαντικά από αυτήν του χρήστη $param2.';
  }

  @override
  String challengeCannotChallengeDueToProvisionalXRating(String param) {
    return 'Δεν είναι δυνατή η πρόκληση λόγω της προσωρινής βαθμολογίας στο $param.';
  }

  @override
  String challengeXOnlyAcceptsChallengesFromFriends(String param) {
    return '$param δέχεται προκλήσεις μόνο από φίλους.';
  }

  @override
  String get challengeDeclineGeneric => 'Δε δέχομαι προκλήσεις αυτή τη στιγμή.';

  @override
  String get challengeDeclineLater => 'Δεν είμαι διαθέσιμος αυτήν τη στιγμή, ρωτήστε με ξανά αργότερα.';

  @override
  String get challengeDeclineTooFast => 'Αυτός ο χρόνος είναι πολύ γρήγορος για μένα, προκαλέστε με ξανά με έναν πιο αργό.';

  @override
  String get challengeDeclineTooSlow => 'Αυτός ο χρόνος είναι πολύ αργός για μένα, προκαλέστε με ξανά με έναν πιο γρήγορο.';

  @override
  String get challengeDeclineTimeControl => 'Δεν δέχομαι προκλήσεις με τέτοιους χρόνους.';

  @override
  String get challengeDeclineRated => 'Στείλτε μου μία βαθμολογημένη και όχι φιλική πρόκληση.';

  @override
  String get challengeDeclineCasual => 'Στείλτε μου μία φιλική και όχι βαθμολογημένη πρόκληση.';

  @override
  String get challengeDeclineStandard => 'Δεν δέχομαι προκλήσεις με παραλλαγές αυτή τη στιγμή.';

  @override
  String get challengeDeclineVariant => 'Δεν είμαι πρόθυμος να παίξω αυτήν την παραλλαγή αυτή τη στιγμή.';

  @override
  String get challengeDeclineNoBot => 'Δεν δέχομαι προκλήσεις από bots.';

  @override
  String get challengeDeclineOnlyBot => 'Δέχομαι προκλήσεις μόνο από bots.';

  @override
  String get challengeInviteLichessUser => 'Ή προσκαλέστε έναν χρήστη του Lichess:';

  @override
  String get contactContact => 'Επικοινωνία';

  @override
  String get contactContactLichess => 'Επικοινωνήστε με Lichess';

  @override
  String get patronDonate => 'Κάντε δωρεά';

  @override
  String get patronLichessPatron => 'Υποστηρικτής του Lichess';

  @override
  String perfStatPerfStats(String param) {
    return 'Στατιστικά $param';
  }

  @override
  String get perfStatViewTheGames => 'Προβολή παρτίδων';

  @override
  String get perfStatProvisional => 'προσωρινή';

  @override
  String get perfStatNotEnoughRatedGames => 'Δεν έχουν παιχτεί αρκετές βαθμολογημένες παρτίδες ώστε να υπάρξει έμπιστη βαθμολογία.';

  @override
  String perfStatProgressOverLastXGames(String param) {
    return 'Εξέλιξη βάσει των τελευταίων $param παρτίδων:';
  }

  @override
  String perfStatRatingDeviation(String param) {
    return 'Απόκλιση βαθμολογίας: $param.';
  }

  @override
  String perfStatRatingDeviationTooltip(String param1, String param2, String param3) {
    return 'Χαμηλότερη τιμή σημαίνει ότι η βαθμολογία είναι πιο σταθερή. Βαθμολογίες πάνω από $param1 θεωρούνται προσωρινές. Για να συμπεριληφθείτε στην κατάταξη, η βαθμολογία σας πρέπει να είναι κάτω από $param2 (στο κανονικό σκάκι) ή $param3 (στις παραλλαγές).';
  }

  @override
  String get perfStatTotalGames => 'Σύνολο παρτίδων';

  @override
  String get perfStatRatedGames => 'Βαθμολογημένες παρτίδες';

  @override
  String get perfStatTournamentGames => 'Παρτίδες σε τουρνουά';

  @override
  String get perfStatBerserkedGames => 'Παρτίδες με berserk';

  @override
  String get perfStatTimeSpentPlaying => 'Χρόνος που διατέθηκε παίζοντας';

  @override
  String get perfStatAverageOpponent => 'Μέση αξιολόγηση αντιπάλων';

  @override
  String get perfStatVictories => 'Νίκες';

  @override
  String get perfStatDefeats => 'Ήττες';

  @override
  String get perfStatDisconnections => 'Αποσυνδέσεις';

  @override
  String get perfStatNotEnoughGames => 'Δεν έχουν παιχτεί αρκετές παρτίδες';

  @override
  String perfStatHighestRating(String param) {
    return 'Υψηλότερη βαθμολογία: $param';
  }

  @override
  String perfStatLowestRating(String param) {
    return 'Χαμηλότερη βαθμολογία: $param';
  }

  @override
  String perfStatFromXToY(String param1, String param2) {
    return 'από $param1 έως $param2';
  }

  @override
  String get perfStatWinningStreak => 'Συνεχόμενες νίκες';

  @override
  String get perfStatLosingStreak => 'Συνεχόμενες ήττες';

  @override
  String perfStatLongestStreak(String param) {
    return 'Μεγαλύτερο Σερί: $param';
  }

  @override
  String perfStatCurrentStreak(String param) {
    return 'Τρέχον σερί: $param';
  }

  @override
  String get perfStatBestRated => 'Καλύτερες αξιολογήσιμες νίκες';

  @override
  String get perfStatGamesInARow => 'Συνεχόμενες παρτίδες';

  @override
  String get perfStatLessThanOneHour => 'Διάστημα λιγότερο από μία ώρα μεταξύ των παρτίδων';

  @override
  String get perfStatMaxTimePlaying => 'Μέγιστος χρόνος που διατέθηκε παίζοντας';

  @override
  String get perfStatNow => 'τώρα';

  @override
  String get preferencesPreferences => 'Προτιμήσεις';

  @override
  String get preferencesDisplay => 'Εμφάνιση';

  @override
  String get preferencesPrivacy => 'Ιδιωτικότητα';

  @override
  String get preferencesNotifications => 'Ειδοποιήσεις';

  @override
  String get preferencesPieceAnimation => 'Κίνηση πιονιών';

  @override
  String get preferencesMaterialDifference => 'Διαφορά υλικού';

  @override
  String get preferencesBoardHighlights => 'Φωτισμός σκακιέρας (τελευταία κίνηση και σαχ)';

  @override
  String get preferencesPieceDestinations => 'Προορισμοί κομματιών (έγκυρες κινήσεις και προκινήσεις)';

  @override
  String get preferencesBoardCoordinates => 'Συντεταγμένες σκακιέρας (A-H, 1-8)';

  @override
  String get preferencesMoveListWhilePlaying => 'Λίστα κινήσεων κατά τη διάρκεια της παρτίδας';

  @override
  String get preferencesPgnPieceNotation => 'Εμφάνιση κινήσεων';

  @override
  String get preferencesChessPieceSymbol => 'Σύμβολο πιονιού στο σκάκι';

  @override
  String get preferencesPgnLetter => 'Γράμμα (K, Q, R, B, N)';

  @override
  String get preferencesZenMode => 'Λειτουργία Zεν';

  @override
  String get preferencesShowPlayerRatings => 'Εμφάνιση αξιολογήσεων παικτών';

  @override
  String get preferencesShowFlairs => 'Show player flairs';

  @override
  String get preferencesExplainShowPlayerRatings => 'Αυτό επιτρέπει την απόκρυψη όλων τις βαθμολογίες από την ιστοσελίδα, έτσι ώστε να μπορείτε να επικεντρωθείτε στο σκάκι. Τα παιχνίδια θα αξιολογούνται, η ρύθμιση αυτή επηρεάζει την εμφάνιση μόνο.';

  @override
  String get preferencesDisplayBoardResizeHandle => 'Εμφάνιση χειριστηρίου αλλαγής μεγέθους σκακιέρας';

  @override
  String get preferencesOnlyOnInitialPosition => 'Μόνο στην αρχική διάταξη';

  @override
  String get preferencesInGameOnly => 'Μόνο κατά τη διάρκεια του παιχνιδιού';

  @override
  String get preferencesExceptInGame => 'Except in-game';

  @override
  String get preferencesChessClock => 'Σκακιστικό χρονόμετρο';

  @override
  String get preferencesTenthsOfSeconds => 'Δέκατα του δευτερολέπτου';

  @override
  String get preferencesWhenTimeRemainingLessThanTenSeconds => 'Όταν απομένουν < 10 δευτερόλεπτα';

  @override
  String get preferencesHorizontalGreenProgressBars => 'Οριζόντιες πράσινες γραμμές προόδου';

  @override
  String get preferencesSoundWhenTimeGetsCritical => 'Ηχητική ειδοποίηση όταν ο χρόνος γίνεται κρίσιμος';

  @override
  String get preferencesGiveMoreTime => 'Προσθέστε περισσότερο χρόνο';

  @override
  String get preferencesGameBehavior => 'Συμπεριφορά παιχνιδιού';

  @override
  String get preferencesHowDoYouMovePieces => 'Πώς θέλετε να μετακινείτε τα κομμάτια;';

  @override
  String get preferencesClickTwoSquares => 'Κάνοντας κλικ στα δύο τετράγωνα';

  @override
  String get preferencesDragPiece => 'Σέρνοντας ένα πιόνι';

  @override
  String get preferencesBothClicksAndDrag => 'Και τα δύο';

  @override
  String get preferencesPremovesPlayingDuringOpponentTurn => 'Προκινήσεις (παιγμένες κατά τον χρόνο σκέψης του αντιπάλου)';

  @override
  String get preferencesTakebacksWithOpponentApproval => 'Ανακλήσεις (με έγκριση του αντιπάλου)';

  @override
  String get preferencesInCasualGamesOnly => 'Μόνο σε φιλικά παιχνίδια';

  @override
  String get preferencesPromoteToQueenAutomatically => 'Αυτόματη προαγωγή σε βασίλισσα';

  @override
  String get preferencesExplainPromoteToQueenAutomatically => 'Κρατήστε πατημένο το πλήκτρο <ctrl> ενώ κάνετε την προαγωγή για να απενεργοποιήσετε προσωρινά την αυτόματη προαγωγή';

  @override
  String get preferencesWhenPremoving => 'Κατά προεπιλογή κίνησης';

  @override
  String get preferencesClaimDrawOnThreefoldRepetitionAutomatically => 'Διεκδικήστε ισοπαλία αυτόματα σε τριπλή επανάληψη';

  @override
  String get preferencesWhenTimeRemainingLessThanThirtySeconds => 'Όταν απομένουν < 30 δευτερόλεπτα';

  @override
  String get preferencesMoveConfirmation => 'Επιβεβαίωση κίνησης';

  @override
  String get preferencesExplainCanThenBeTemporarilyDisabled => 'Μπορεί να απενεργοποιηθεί κατά τη διάρκεια ενός παιχνιδιού με το μενού της σκακιέρας';

  @override
  String get preferencesInCorrespondenceGames => 'Στις παρτίδες δι\' αλληλογραφίας';

  @override
  String get preferencesCorrespondenceAndUnlimited => 'Δι\' αλληλογραφίας και απεριορίστου χρόνου';

  @override
  String get preferencesConfirmResignationAndDrawOffers => 'Επιβεβαίωση παραίτησης και προσφοράς ισοπαλίας';

  @override
  String get preferencesCastleByMovingTheKingTwoSquaresOrOntoTheRook => 'Μέθοδος ροκέ';

  @override
  String get preferencesCastleByMovingTwoSquares => 'Ροκέ μετακινώντας τον βασιλιά δύο τετράγωνα';

  @override
  String get preferencesCastleByMovingOntoTheRook => 'Ροκέ μετακινώντας τον βασιλιά πάνω στον πύργο';

  @override
  String get preferencesInputMovesWithTheKeyboard => 'Κάντε κινήσεις με το πληκτρολόγιο';

  @override
  String get preferencesInputMovesWithVoice => 'Εισαγωγή κινήσεων με τη φωνή σας';

  @override
  String get preferencesSnapArrowsToValidMoves => 'Αγκύρωση βελών σε έγκυρες κινήσεις';

  @override
  String get preferencesSayGgWpAfterLosingOrDrawing => 'Αποστολή «Good game, well played» (Ωραίο παιχνίδι, καλά παιγμένο) μετά από ήττα ή ισοπαλία';

  @override
  String get preferencesYourPreferencesHaveBeenSaved => 'Οι προτιμήσεις σας αποθηκεύτηκαν.';

  @override
  String get preferencesScrollOnTheBoardToReplayMoves => 'Κυλίστε τον δρομέα πάνω στη σκακιέρα για να ξαναδείτε κινήσεις';

  @override
  String get preferencesCorrespondenceEmailNotification => 'Να δέχομαι ημερήσια ειδοποίηση ηλεκτρονικού ταχυδρομείου για τα παιχνίδια διά αλληλογραφίας μου';

  @override
  String get preferencesNotifyStreamStart => 'Streamer εκπέμπει ζωντανά';

  @override
  String get preferencesNotifyInboxMsg => 'Νέο εισερχόμενο μήνυμα';

  @override
  String get preferencesNotifyForumMention => 'Το σχόλιο του φόρουμ σας αναφέρει';

  @override
  String get preferencesNotifyInvitedStudy => 'Πρόσκληση μελέτης';

  @override
  String get preferencesNotifyGameEvent => 'Ενημερώσεις σε παιχνίδια αλληλογραφίας';

  @override
  String get preferencesNotifyChallenge => 'Προκλήσεις';

  @override
  String get preferencesNotifyTournamentSoon => 'Το τουρνουά ξεκινά σύντομα';

  @override
  String get preferencesNotifyTimeAlarm => 'Το ρολόι εξαντλείται στο παιχνίδι αλληλογραφίας';

  @override
  String get preferencesNotifyBell => 'Ειδοποίηση με καμπανάκι εντός του Lichess';

  @override
  String get preferencesNotifyPush => 'Ειδοποίηση συσκευής όταν δεν είστε στο Lichess';

  @override
  String get preferencesNotifyWeb => 'Browser';

  @override
  String get preferencesNotifyDevice => 'Συσκευή';

  @override
  String get preferencesBellNotificationSound => 'Ειδοποίηση με ήχο από καμπανάκι';

  @override
  String get preferencesBlindfold => 'Τυφλό';

  @override
  String get puzzlePuzzles => 'Γρίφοι';

  @override
  String get puzzlePuzzleThemes => 'Θέματα γρίφων';

  @override
  String get puzzleRecommended => 'Προτεινόμενα';

  @override
  String get puzzlePhases => 'Φάσεις';

  @override
  String get puzzleMotifs => 'Μοτίβα';

  @override
  String get puzzleAdvanced => 'Για προχωρημένους';

  @override
  String get puzzleLengths => 'Μήκος γρίφου';

  @override
  String get puzzleMates => 'Ματ';

  @override
  String get puzzleGoals => 'Στόχοι';

  @override
  String get puzzleOrigin => 'Πηγή';

  @override
  String get puzzleSpecialMoves => 'Ειδικές κινήσεις';

  @override
  String get puzzleDidYouLikeThisPuzzle => 'Σας άρεσε αυτός ο γρίφος;';

  @override
  String get puzzleVoteToLoadNextOne => 'Ψηφίστε για να προχωρήσετε στο επόμενο!';

  @override
  String get puzzleUpVote => 'Μου άρεσε ο γρίφος';

  @override
  String get puzzleDownVote => 'Δε μου άρεσε ο γρίφος';

  @override
  String get puzzleYourPuzzleRatingWillNotChange => 'Οι βαθμοί αξιολόγησής σας δε θα αλλάξουν. Αυτοί οι βαθμοί χρησιμεύουν στην επιλογή γρίφων για το επίπεδό σας και όχι στον ανταγωνισμό.';

  @override
  String get puzzleFindTheBestMoveForWhite => 'Βρείτε την καλύτερη κίνηση για τα λευκά.';

  @override
  String get puzzleFindTheBestMoveForBlack => 'Βρείτε την καλύτερη κίνηση για τα μαύρα.';

  @override
  String get puzzleToGetPersonalizedPuzzles => 'Για να λύνετε εξατομικευμένους γρίφους:';

  @override
  String puzzlePuzzleId(String param) {
    return 'Γρίφος $param';
  }

  @override
  String get puzzlePuzzleOfTheDay => 'Γρίφος της ημέρας';

  @override
  String get puzzleDailyPuzzle => 'Ημερήσιος Γρίφος';

  @override
  String get puzzleClickToSolve => 'Κάντε κλικ για να τον λύσετε';

  @override
  String get puzzleGoodMove => 'Καλή κίνηση';

  @override
  String get puzzleBestMove => 'Παίξατε την καλύτερη κίνηση!';

  @override
  String get puzzleKeepGoing => 'Συνεχίστε…';

  @override
  String get puzzlePuzzleSuccess => 'Επιτυχία!';

  @override
  String get puzzlePuzzleComplete => 'Ο γρίφος ολοκληρώθηκε!';

  @override
  String get puzzleByOpenings => 'Ανά άνοιγμα';

  @override
  String get puzzlePuzzlesByOpenings => 'Γρίφοι ανά άνοιγμα';

  @override
  String get puzzleOpeningsYouPlayedTheMost => 'Ανοίγματα που παίξατε πιο συχνά σε βαθμολογημένες παρτίδες σκάκι';

  @override
  String get puzzleUseFindInPage => 'Πατήστε «Εύρεση στη σελίδα» στο μενού του προγράμματος περιήγησης, για να βρείτε το αγαπημένο σας άνοιγμα!';

  @override
  String get puzzleUseCtrlF => 'Πατήστε Ctrl+f για να βρείτε το αγαπημένο σας άνοιγμα!';

  @override
  String get puzzleNotTheMove => 'Δεν είναι αυτή η κίνηση!';

  @override
  String get puzzleTrySomethingElse => 'Δοκιμάστε κάτι άλλο.';

  @override
  String puzzleRatingX(String param) {
    return 'Βαθμολογία: $param';
  }

  @override
  String get puzzleHidden => 'κρυφό';

  @override
  String puzzleFromGameLink(String param) {
    return 'Από το παιχνίδι $param';
  }

  @override
  String get puzzleContinueTraining => 'Συνέχεια εξάσκησης';

  @override
  String get puzzleDifficultyLevel => 'Επίπεδο δυσκολίας';

  @override
  String get puzzleNormal => 'Κανονικό';

  @override
  String get puzzleEasier => 'Εύκολο';

  @override
  String get puzzleEasiest => 'Πολύ εύκολο';

  @override
  String get puzzleHarder => 'Δύσκολο';

  @override
  String get puzzleHardest => 'Πολύ δύσκολο';

  @override
  String get puzzleExample => 'Παράδειγμα';

  @override
  String get puzzleAddAnotherTheme => 'Προσθήκη νέου θέματος';

  @override
  String get puzzleNextPuzzle => 'Επόμενος γρίφος';

  @override
  String get puzzleJumpToNextPuzzleImmediately => 'Μετάβαση στον επόμενο γρίφο αμέσως';

  @override
  String get puzzlePuzzleDashboard => 'Ταμπλό γρίφων';

  @override
  String get puzzleImprovementAreas => 'Τομείς βελτίωσης';

  @override
  String get puzzleStrengths => 'Δυνατά σημεία';

  @override
  String get puzzleHistory => 'Ιστορικό γρίφων';

  @override
  String get puzzleSolved => 'λύθηκε';

  @override
  String get puzzleFailed => 'απέτυχε';

  @override
  String get puzzleStreakDescription => 'Λύστε γρίφους που γίνονται όλο και πιο δύσκολοι και χτίστε σιγά σιγά ένα «σερί νικών». Δεν υπάρχει χρόνος, οπότε μη βιάζεστε. Μια λάθος κίνηση, και το παιχνίδι τέλειωσε! Μπορείτε να παραλείψετε μια κίνηση σε κάθε γύρο.';

  @override
  String puzzleYourStreakX(String param) {
    return 'Το σερί νικών σας: $param';
  }

  @override
  String get puzzleStreakSkipExplanation => 'Παραλείψτε αυτή την κίνηση για να διατηρήσετε το σερί νικών σας! Λειτουργεί μόνο μία φορά ανά γύρο.';

  @override
  String get puzzleContinueTheStreak => 'Συνεχίστε το σερί νικών';

  @override
  String get puzzleNewStreak => 'Νέο σερί νικών';

  @override
  String get puzzleFromMyGames => 'Από τα παιχνίδια μου';

  @override
  String get puzzleLookupOfPlayer => 'Αναζητήστε γρίφους από τα παιχνίδια ενός παίκτη';

  @override
  String puzzleFromXGames(String param) {
    return 'Γρίφοι από τα παιχνίδια του χρήστη $param';
  }

  @override
  String get puzzleSearchPuzzles => 'Αναζήτηση γρίφων';

  @override
  String get puzzleFromMyGamesNone => 'Δεν υπάρχουν γρίφοι από τα παιχνίδια σας στη βάση δεδομένων.\nΠαίξτε κλασικά ή rapid παιχνίδια για να αυξηθούν οι πιθανότητες προσθήκης γρίφων από τα παιχνίδια σας στη βάση δεδομένων!';

  @override
  String puzzleFromXGamesFound(String param1, String param2) {
    return 'Βρέθηκαν $param1 γρίφοι στα παιχνίδια του χρήστη $param2';
  }

  @override
  String get puzzlePuzzleDashboardDescription => 'Προπονηθείτε, αναλύστε, βελτιωθείτε';

  @override
  String puzzlePercentSolved(String param) {
    return '$param λυμένα';
  }

  @override
  String get puzzleNoPuzzlesToShow => 'Δεν υπάρχει τίποτα εδώ, ακόμα, λύστε μερικούς γρίφους πρώτα!';

  @override
  String get puzzleImprovementAreasDescription => 'Εκπαιδευτείτε σε αυτά για να βελτιώσετε την πρόοδό σας!';

  @override
  String get puzzleStrengthDescription => 'Τα πάτε καλύτερα στις εξής κατηγορίες';

  @override
  String puzzlePlayedXTimes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Λύθηκε $count φορές',
      one: 'Λύθηκε $count φορά',
    );
    return '$_temp0';
  }

  @override
  String puzzleNbPointsBelowYourPuzzleRating(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count πόντους κάτω από τη βαθμολογία γρίφων σας',
      one: 'Έναν πόντο κάτω από τη βαθμολογία γρίφων σας',
    );
    return '$_temp0';
  }

  @override
  String puzzleNbPointsAboveYourPuzzleRating(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count πόντους πάνω από την βαθμολογία γρίφων σας',
      one: 'Έναν πόντο πάνω από την βαθμολογία γρίφων σας',
    );
    return '$_temp0';
  }

  @override
  String puzzleNbPlayed(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count παίχτηκαν',
      one: '$count παίχτηκε',
    );
    return '$_temp0';
  }

  @override
  String puzzleNbToReplay(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count για επανάληψη',
      one: '$count για επανάληψη',
    );
    return '$_temp0';
  }

  @override
  String get puzzleThemeAdvancedPawn => 'Προωθημένο πιόνι';

  @override
  String get puzzleThemeAdvancedPawnDescription => 'Ένα πιόνι που προάγεται ή απειλεί να προαχθεί είναι κλειδί για αυτή την τακτική.';

  @override
  String get puzzleThemeAdvantage => 'Πλεονέκτημα';

  @override
  String get puzzleThemeAdvantageDescription => 'Αρπάξτε την ευκαιρία ώστε να αποκτήσετε ένα αποφασιστικό πλεονέκτημα. (200cp ≤ eval ≤ 600cp)';

  @override
  String get puzzleThemeAnastasiaMate => 'To ματ της Αναστασίας';

  @override
  String get puzzleThemeAnastasiaMateDescription => 'Ένας ίππος και ένας πύργος ή βασίλισσα κάνουν ματ στον αντίπαλο βασιλιά στο περιθώριο της σκακιέρας, όταν ένα φιλικό κομμάτι του εμποδίζει την διαφυγή.';

  @override
  String get puzzleThemeArabianMate => 'Αραβικό ματ';

  @override
  String get puzzleThemeArabianMateDescription => 'Συνεργασία ίππου και πύργου για παγίδευση του αντίπαλου βασιλιά στην άκρη της σκακιέρας.';

  @override
  String get puzzleThemeAttackingF2F7 => 'Επίθεση στο f2 ή f7';

  @override
  String get puzzleThemeAttackingF2F7Description => 'Μια επίθεση που εστιάζει στο πιόνι f2 ή f7, όπως στην επίθεση Φράιντ Λίβερ.';

  @override
  String get puzzleThemeAttraction => 'Έλξη';

  @override
  String get puzzleThemeAttractionDescription => 'Μια ανταλλαγή ή θυσία που ενθαρρύνει ή αναγκάζει ένα αντίπαλο κομμάτι σε ένα τετράγωνο όπου δύναται μια επακόλουθη τακτική.';

  @override
  String get puzzleThemeBackRankMate => 'Ματ της τελευταίας γραμμής';

  @override
  String get puzzleThemeBackRankMateDescription => 'Κάντε ματ στον βασιλιά στην τελευταία γραμμή όταν είναι παγιδευμένος εκεί από τα κομμάτια του.';

  @override
  String get puzzleThemeBishopEndgame => 'Φινάλε Αξιωματικών';

  @override
  String get puzzleThemeBishopEndgameDescription => 'Ένα τέλος παρτίδας μόνο με αξιωματικούς και πιόνια.';

  @override
  String get puzzleThemeBodenMate => 'Ματ του Μποντάν';

  @override
  String get puzzleThemeBodenMateDescription => 'Δύο επιτιθέμενοι αξιωματικοί κινούμενοι διαγωνίως κάνουν ματ σε βασιλιά που εμποδίζεται από φιλικά κομμάτια.';

  @override
  String get puzzleThemeCastling => 'Pοκέ';

  @override
  String get puzzleThemeCastlingDescription => 'Εξασφαλίστε την ασφάλεια του βασιλιά και αναπτύξτε τον πύργο για επίθεση.';

  @override
  String get puzzleThemeCapturingDefender => 'Αιχμαλωτίστε τον αμυνόμενο';

  @override
  String get puzzleThemeCapturingDefenderDescription => 'Απομάκρυνση κομματιού που είναι σημαντικό για την υπεράσπιση άλλου κομματιού, επιτρέποντας την αιχμαλώτιση του πλέον ανυπεράσπιστου κομματιού στην επόμενη κίνηση.';

  @override
  String get puzzleThemeCrushing => 'Σύνθλιψη';

  @override
  String get puzzleThemeCrushingDescription => 'Εντοπίστε το σοβαρό λάθος του αντιπάλου για να αποκτήσετε συντριπτικό πλεονέκτημα. (eval ≥ 600cp)';

  @override
  String get puzzleThemeDoubleBishopMate => 'Ματ με δύο αξιωματικούς';

  @override
  String get puzzleThemeDoubleBishopMateDescription => 'Δύο επιτιθέμενοι αξιωματικοί σε κοντινή απόσταση κάνουν ματ σε βασιλιά που εμποδίζεται από φιλικά κομμάτια.';

  @override
  String get puzzleThemeDovetailMate => 'Dovetail ματ';

  @override
  String get puzzleThemeDovetailMateDescription => 'Βασίλισσα κάνει ματ σε παρακείμενο βασιλιά, του οποίου τα μοναδικά δύο τετράγωνα διαφυγής εμποδίζονται από φιλικά κομμάτια.';

  @override
  String get puzzleThemeEquality => 'Ισότητα';

  @override
  String get puzzleThemeEqualityDescription => 'Επιστρέψτε από μια χαμένη θέση και ασφαλίστε μια κλήρωση ή μια ισορροπημένη θέση. (eval ≤ 200cp)';

  @override
  String get puzzleThemeKingsideAttack => 'Επίθεση στην πλευρά του βασιλιά';

  @override
  String get puzzleThemeKingsideAttackDescription => 'Επίθεση στον αντίπαλο βασιλιά, μετά από μικρό ροκέ.';

  @override
  String get puzzleThemeClearance => 'Ελευθέρωση';

  @override
  String get puzzleThemeClearanceDescription => 'Μία κίνηση, συνήθως με tempo, που ελευθερώνει το τετράγωνο, στήλη ή διαγώνιο για την συνέχιση τακτικής ιδέας.';

  @override
  String get puzzleThemeDefensiveMove => 'Αμυντική κίνηση';

  @override
  String get puzzleThemeDefensiveMoveDescription => 'Μια ακριβής κίνηση ή ακολουθία κινήσεων που απαιτείται για να αποφευχθεί η απώλεια υλικού ή άλλου πλεονεκτήματος.';

  @override
  String get puzzleThemeDeflection => 'Εκτροπή';

  @override
  String get puzzleThemeDeflectionDescription => 'Μία κίνηση που απομακρύνει ένα αντίπαλο κομμάτι από υφιστάμενο καθήκον, όπως η φύλαξη ενός τετραγώνου κλειδί. Μερικές φορές ονομάζεται και \"υπερφόρτωση\".';

  @override
  String get puzzleThemeDiscoveredAttack => 'Επίθεση με αποκάλυψη';

  @override
  String get puzzleThemeDiscoveredAttackDescription => 'Μετακίνηση κομματιού που προηγουμένως εμπόδιζε την επίθεση από κομμάτι μεγάλης εμβέλειας, όπως ένας ίππος που εμπόδιζε έναν πύργο.';

  @override
  String get puzzleThemeDoubleCheck => 'Διπλό σαχ';

  @override
  String get puzzleThemeDoubleCheckDescription => 'Διπλό σαχ ως αποτέλεσμα μίας επίθεσης με αποκάλυψη, όπου και το μετακινούμενο κομμάτι δίνει σαχ.';

  @override
  String get puzzleThemeEndgame => 'Φινάλε';

  @override
  String get puzzleThemeEndgameDescription => 'Μια τακτική κατά την τελευταία φάση του παιχνιδιού.';

  @override
  String get puzzleThemeEnPassantDescription => 'Τακτικό που αφορά το κανόνα en passant, όπου ένα πιόνι μπορεί να αιχμαλωτίσει ένα αντίπαλο πιόνι που το προσπέρασε χρησιμοποιώντας την αρχική δύο τετραγώνων κίνηση.';

  @override
  String get puzzleThemeExposedKing => 'Εκτεθειμένος βασιλιάς';

  @override
  String get puzzleThemeExposedKingDescription => 'Τακτικό που αφορά βασιλιά με λίγα αμυντικά κομμάτια γύρω του, που συχνά οδηγεί σε ματ.';

  @override
  String get puzzleThemeFork => 'Πιρούνισμα';

  @override
  String get puzzleThemeForkDescription => 'Μια κίνηση όπου το μετακινούμενο κομμάτι επιτίθεται ταυτόχρονα σε δύο ή περισσότερα αντίπαλα κομμάτια.';

  @override
  String get puzzleThemeHangingPiece => 'Κρεμασμένα κομμάτια';

  @override
  String get puzzleThemeHangingPieceDescription => 'Μια τακτική όπου ένα αντίπαλο κομμάτι είναι ανυπεράσπιστο ή υπερασπιζόμενο ανεπαρκώς και μπορεί να παρθεί.';

  @override
  String get puzzleThemeHookMate => 'Ματ με αγκίστρι';

  @override
  String get puzzleThemeHookMateDescription => 'Ματ με πύργο, ίππο, και ένα πιόνι μαζί με ένα εχθρικό πιόνι που εμποδίζει την διαφυγή του αντίπαλου βασιλιά.';

  @override
  String get puzzleThemeInterference => 'Παρεμβολή';

  @override
  String get puzzleThemeInterferenceDescription => 'Μετακίνηση κομματιού ανάμεσα σε δύο αντίπαλα κομμάτια για να αφήσει ένα ή και τα δύο αντίπαλα κομμάτια ανυπεράσπιστα, όπως ένας ίππος σε υπερασπιζόμενο τετράγωνο ανάμεσα σε δύο πύργους.';

  @override
  String get puzzleThemeIntermezzo => 'Ενδιάμεση κίνηση';

  @override
  String get puzzleThemeIntermezzoDescription => 'Αντί για την αναμενόμενη κίνηση παίζουμε πρώτα μια άλλη κίνηση η οποία δημιουργεί μια άμεση απειλή και που ο αντίπαλος πρέπει να απαντήσει. Επίσης γνωστό ως \"Zwischenzug\" ή \"Intermezzo\".';

  @override
  String get puzzleThemeKillBoxMate => 'Kill box mate';

  @override
  String get puzzleThemeKillBoxMateDescription => 'A rook is next to the enemy king and supported by a queen that also blocks the king\'s escape squares. The rook and the queen catch the enemy king in a 3 by 3 \"kill box\".';

  @override
  String get puzzleThemeVukovicMate => 'Ματ του Vukovic';

  @override
  String get puzzleThemeVukovicMateDescription => 'Ένας πύργος και ένας ίππος συνδυάζονται για ματ στην άκρη της σκακιέρας. Ο πύργος κάνει ματ υποστηριζόμενος από κάποιο άλλο κομμάτι, ενώ ο ίππος ελέγχει τα υπόλοιπα διαθέσιμα τετράγωνα γύρω από τον βασιλιά.';

  @override
  String get puzzleThemeKnightEndgame => 'Φινάλε Ίππων';

  @override
  String get puzzleThemeKnightEndgameDescription => 'Ένα τέλος παρτίδας μόνο με ίππους και πιόνια.';

  @override
  String get puzzleThemeLong => 'Μεγάλος γρίφος';

  @override
  String get puzzleThemeLongDescription => 'Τρεις κινήσεις για να κερδίσετε.';

  @override
  String get puzzleThemeMaster => 'Master παιχνίδια';

  @override
  String get puzzleThemeMasterDescription => 'Γρίφοι από παρτίδες τιτλούχων παικτών.';

  @override
  String get puzzleThemeMasterVsMaster => 'Master vs Master παιχνίδια';

  @override
  String get puzzleThemeMasterVsMasterDescription => 'Γρίφοι από παρτίδες μεταξύ δύο τιτλούχων παικτών.';

  @override
  String get puzzleThemeMate => 'Ματ';

  @override
  String get puzzleThemeMateDescription => 'Κερδίστε το παιχνίδι με στυλ.';

  @override
  String get puzzleThemeMateIn1 => 'Ματ σε 1';

  @override
  String get puzzleThemeMateIn1Description => 'Κάντε ματ με μια κίνηση.';

  @override
  String get puzzleThemeMateIn2 => 'Ματ σε 2';

  @override
  String get puzzleThemeMateIn2Description => 'Κάντε ματ σε δύο κινήσεις.';

  @override
  String get puzzleThemeMateIn3 => 'Ματ σε 3';

  @override
  String get puzzleThemeMateIn3Description => 'Κάντε ματ σε τρεις κινήσεις.';

  @override
  String get puzzleThemeMateIn4 => 'Ματ σε 4';

  @override
  String get puzzleThemeMateIn4Description => 'Κάντε ματ σε τέσσερις κινήσεις.';

  @override
  String get puzzleThemeMateIn5 => 'Ματ σε 5 ή περισσότερο';

  @override
  String get puzzleThemeMateIn5Description => 'Βρείτε μία μακρά ακολουθία κινήσεων που οδηγεί σε ματ.';

  @override
  String get puzzleThemeMiddlegame => 'Μέση φάση παιχνιδιού';

  @override
  String get puzzleThemeMiddlegameDescription => 'Μια τακτική κατά τη δεύτερη φάση του παιχνιδιού.';

  @override
  String get puzzleThemeOneMove => 'Γρίφος μιας κίνησης';

  @override
  String get puzzleThemeOneMoveDescription => 'Ένας γρίφος που έχει μόνο μία κίνηση.';

  @override
  String get puzzleThemeOpening => 'Άνοιγμα';

  @override
  String get puzzleThemeOpeningDescription => 'Μια τακτική κατά την πρώτη φάση του παιχνιδιού.';

  @override
  String get puzzleThemePawnEndgame => 'Φινάλε Πιονιών';

  @override
  String get puzzleThemePawnEndgameDescription => 'Ένα τέλος παρτίδας μόνο με πιόνια.';

  @override
  String get puzzleThemePin => 'Κάρφωμα';

  @override
  String get puzzleThemePinDescription => 'Μια τακτική που περιλαμβάνει καρφώματα, όπου ένα κομμάτι αδυνατεί να μετακινηθεί χωρίς να αποκαλύψει μια επίθεση σε ένα κομμάτι μεγαλύτερης αξίας.';

  @override
  String get puzzleThemePromotion => 'Προαγωγή';

  @override
  String get puzzleThemePromotionDescription => 'Ένα πιόνι που προάγεται ή απειλεί να προαχθεί είναι κλειδί για αυτή την τακτική.';

  @override
  String get puzzleThemeQueenEndgame => 'Φινάλε Βασιλισσών';

  @override
  String get puzzleThemeQueenEndgameDescription => 'Ένα τέλος παρτίδας μόνο με βασίλισσες και πιόνια.';

  @override
  String get puzzleThemeQueenRookEndgame => 'Βασίλισσα και Πύργος';

  @override
  String get puzzleThemeQueenRookEndgameDescription => 'Ένα τέλος παρτίδας μόνο με βασίλισσες, πύργους και πιόνια.';

  @override
  String get puzzleThemeQueensideAttack => 'Επίθεση στην πλευρά της βασίλισσας';

  @override
  String get puzzleThemeQueensideAttackDescription => 'Επίθεση στον αντίπαλο βασιλιά, μετά από μεγάλο ροκέ.';

  @override
  String get puzzleThemeQuietMove => 'Ήσυχη κίνηση';

  @override
  String get puzzleThemeQuietMoveDescription => 'Μια κίνηση που δεν δίνει σαχ ή αιχμαλωτίζει, αλλά προετοιμάζει μια αναπόφευκτη απειλή σε επόμενη κίνηση.';

  @override
  String get puzzleThemeRookEndgame => 'Φινάλε Πύργων';

  @override
  String get puzzleThemeRookEndgameDescription => 'Ένα τέλος παρτίδας μόνο με πύργους και πιόνια.';

  @override
  String get puzzleThemeSacrifice => 'Θυσία';

  @override
  String get puzzleThemeSacrificeDescription => 'Μια τακτική που περιλαμβάνει την εγκατάλειψη υλικού βραχυπρόθεσμα, ώστε να κερδηθεί πλεονέκτημα μετά από μια εξαναγκασμένη ακολουθία κινήσεων.';

  @override
  String get puzzleThemeShort => 'Σύντομος γρίφος';

  @override
  String get puzzleThemeShortDescription => 'Δύο κινήσεις για να κερδίσετε.';

  @override
  String get puzzleThemeSkewer => 'Σούβλισμα';

  @override
  String get puzzleThemeSkewerDescription => 'Ένα μοτίβο όπου ένα κομμάτι υψηλής αξίας δέχεται επίθεση, κάνει στην άκρη, και επιτρέπει την επίθεση ή το πάρσιμο ενός κομματιού μικρότερης αξίας πίσω από αυτό, το αντίστροφο δηλαδή του καρφώματος.';

  @override
  String get puzzleThemeSmotheredMate => 'Ματ αποπνιγμού';

  @override
  String get puzzleThemeSmotheredMateDescription => 'Ένα ματ που γίνεται από έναν ίππο σε έναν βασιλιάς ο οποίος δεν μπορεί να μετακινηθεί όντας περιτριγυρισμένος (ή πνιγμένος) από δικά του κομμάτια.';

  @override
  String get puzzleThemeSuperGM => 'Παιχνίδια Super GM';

  @override
  String get puzzleThemeSuperGMDescription => 'Γρίφοι από παρτίδες που παίχθηκαν από κορυφαίους παίκτες του κόσμου.';

  @override
  String get puzzleThemeTrappedPiece => 'Παγιδευμένο κομμάτι';

  @override
  String get puzzleThemeTrappedPieceDescription => 'Ένα κομμάτι δεν μπορεί να αποφύγει την αιχμαλώτιση, καθώς έχει περιορισμένες κινήσεις.';

  @override
  String get puzzleThemeUnderPromotion => 'Προαγωγή σε κομμάτι μικρότερης αξίας';

  @override
  String get puzzleThemeUnderPromotionDescription => 'Προώθηση σε ιππότη, αξιωματικό ή πύργο.';

  @override
  String get puzzleThemeVeryLong => 'Πολύ μεγάλος γρίφος';

  @override
  String get puzzleThemeVeryLongDescription => 'Τέσσερις κινήσεις ή περισσότερα για να κερδίσετε.';

  @override
  String get puzzleThemeXRayAttack => 'Επίθεση ακτίνας Χ';

  @override
  String get puzzleThemeXRayAttackDescription => 'Κομμάτι που επιτίθεται ή αμύνεται ένα τετράγωνο, πίσω από εχθρικό κομμάτι.';

  @override
  String get puzzleThemeZugzwang => 'Τσούγκτσβανγκ';

  @override
  String get puzzleThemeZugzwangDescription => 'Ο αντίπαλος είναι περιορισμένος στις κινήσεις που μπορεί να κάνει και οποιαδήποτε κίνηση επιλέξει επιδεινώνει την θέση του.';

  @override
  String get puzzleThemeMix => 'Προτεινόμενο μίγμα';

  @override
  String get puzzleThemeMixDescription => 'Λίγο απ\' όλα. Δεν ξέρετε τι να περιμένετε, οπότε παραμένετε σε ετοιμότητα! Όπως στα πραγματικά παιχνίδια.';

  @override
  String get puzzleThemePlayerGames => 'Παιχνίδια παίκτη';

  @override
  String get puzzleThemePlayerGamesDescription => 'Αναζητήστε γρίφους που δημιουργήθηκαν από παιχνίδια είτε δικά σας είτε άλλων παικτών.';

  @override
  String puzzleThemePuzzleDownloadInformation(String param) {
    return 'Αυτοί οι γρίφοι είναι δημόσιοι και μπορείτε να τους κατεβάσετε εδώ $param.';
  }

  @override
  String get searchSearch => 'Αναζήτηση';

  @override
  String get settingsSettings => 'Επιλογές';

  @override
  String get settingsCloseAccount => 'Κλείσιμο λογαριασμού';

  @override
  String get settingsManagedAccountCannotBeClosed => 'Ο λογαριασμός σας βρίσκεται υπό διαχείριση και δεν μπορεί να κλείσει.';

  @override
  String get settingsCantOpenSimilarAccount => 'Δεν θα σας επιτραπεί η δημιουργία νέου λογαριασμού με το ίδιο όνομα, ακόμα κι αν μετατρέψετε έναν μικρό σε έναν κεφαλαίο ή το αντίστροφο.';

  @override
  String get settingsCancelKeepAccount => 'Ακύρωσε και διατήρησε τον λογαριασμό μου';

  @override
  String get settingsCloseAccountAreYouSure => 'Είσαστε σίγουροι ότι θέλετε να κλείσετε τον λογαριασμό σας;';

  @override
  String get settingsThisAccountIsClosed => 'Αυτός ο λογαριασμός έχει κλείσει.';

  @override
  String get playWithAFriend => 'Παίξτε με έναν φίλο';

  @override
  String get playWithTheMachine => 'Παίξτε με τον υπολογιστή';

  @override
  String get toInviteSomeoneToPlayGiveThisUrl => 'Για να προσκαλέσετε κάποιον σε ένα παιχνίδι, στείλτε του αυτήν τη διεύθυνση';

  @override
  String get gameOver => 'Τέλος παιχνιδιού';

  @override
  String get waitingForOpponent => 'Αναμονή για αντίπαλο';

  @override
  String get orLetYourOpponentScanQrCode => 'Ή ζητήστε από τον αντίπαλό σας να σαρώσει αυτόν τον κωδικό QR';

  @override
  String get waiting => 'Αναμονή';

  @override
  String get yourTurn => 'Η σειρά σας';

  @override
  String aiNameLevelAiLevel(String param1, String param2) {
    return '$param1 επιπέδου $param2';
  }

  @override
  String get level => 'Επίπεδο';

  @override
  String get strength => 'Ισχύς';

  @override
  String get toggleTheChat => 'Εναλλαγή προβολής της συνομιλίας';

  @override
  String get chat => 'Συνομιλία';

  @override
  String get resign => 'Παραίτηση';

  @override
  String get checkmate => 'Ματ';

  @override
  String get stalemate => 'Πατ';

  @override
  String get white => 'Λευκά';

  @override
  String get black => 'Μαύρα';

  @override
  String get asWhite => 'ως λευκός';

  @override
  String get asBlack => 'ως μαύρος';

  @override
  String get randomColor => 'Τυχαίο χρώμα';

  @override
  String get createAGame => 'Δημιουργήστε παιχνίδι';

  @override
  String get whiteIsVictorious => 'Τα λευκά νίκησαν';

  @override
  String get blackIsVictorious => 'Τα μαύρα νίκησαν';

  @override
  String get youPlayTheWhitePieces => 'Παίζετε τα λευκά';

  @override
  String get youPlayTheBlackPieces => 'Παίζετε τα μαύρα';

  @override
  String get itsYourTurn => 'Είναι η σειρά σας!';

  @override
  String get cheatDetected => 'Βρέθηκε απάτη';

  @override
  String get kingInTheCenter => 'Βασιλιάς στο κέντρο';

  @override
  String get threeChecks => 'Τρία σαχ';

  @override
  String get raceFinished => 'Τέλος αγώνα';

  @override
  String get variantEnding => 'Εκδοχή ολοκληρώθηκε';

  @override
  String get newOpponent => 'Νέος αντίπαλος';

  @override
  String get yourOpponentWantsToPlayANewGameWithYou => 'Ο αντίπαλος θέλει να παίξει νέο παιχνίδι μαζί σας';

  @override
  String get joinTheGame => 'Λάβετε μέρος στο παιχνίδι';

  @override
  String get whitePlays => 'Παίζουν τα λευκά';

  @override
  String get blackPlays => 'Παίζουν τα μαύρα';

  @override
  String get opponentLeftChoices => 'Ο αντίπαλός σας έφυγε από το παιχνίδι. Μπορείτε να ισχυρισθείτε νίκη, ισοπαλία, ή να περιμένετε.';

  @override
  String get forceResignation => 'Ισχυριστείτε νίκη';

  @override
  String get forceDraw => 'Δηλώστε ισοπαλία';

  @override
  String get talkInChat => 'Παρακαλούμε να είστε ευγενικοί στη συνομιλία!';

  @override
  String get theFirstPersonToComeOnThisUrlWillPlayWithYou => 'Ο πρώτος που θα επισκεφθεί αυτήν τη διεύθυνση θα παίξει μαζί σας.';

  @override
  String get whiteResigned => 'Τα λευκά παραιτήθηκαν';

  @override
  String get blackResigned => 'Τα μαύρα παραιτήθηκαν';

  @override
  String get whiteLeftTheGame => 'Τα λευκά έφυγαν από το παιχνίδι';

  @override
  String get blackLeftTheGame => 'Τα μαύρα έφυγαν από το παιχνίδι';

  @override
  String get whiteDidntMove => 'Τα λευκά δεν έπαιξαν';

  @override
  String get blackDidntMove => 'Τα μαύρα δεν έπαιξαν';

  @override
  String get requestAComputerAnalysis => 'Ζητήστε ανάλυση υπολογιστή';

  @override
  String get computerAnalysis => 'Ανάλυση υπολογιστή';

  @override
  String get computerAnalysisAvailable => 'Ανάλυση υπολογιστή διαθέσιμη';

  @override
  String get computerAnalysisDisabled => 'Η ανάλυση υπολογιστή απενεργοποιήθηκε';

  @override
  String get analysis => 'Σκακιέρα ανάλυσης';

  @override
  String depthX(String param) {
    return '$param βάθος';
  }

  @override
  String get usingServerAnalysis => 'Ανάλυση διακομιστή';

  @override
  String get loadingEngine => 'Εκκίνηση μηχανής ...';

  @override
  String get calculatingMoves => 'Υπολογισμός κινήσεων...';

  @override
  String get engineFailed => 'Σφάλμα κατά τη φόρτωση της μηχανής';

  @override
  String get cloudAnalysis => 'Ανάλυση σε νέφος';

  @override
  String get goDeeper => 'Βαθύτερα';

  @override
  String get showThreat => 'Εμφάνιση απειλής';

  @override
  String get inLocalBrowser => 'σε τοπικό περιηγητή';

  @override
  String get toggleLocalEvaluation => 'Εναλλαγή τοπικής αξιολόγησης';

  @override
  String get promoteVariation => 'Προώθηση βαριάντας';

  @override
  String get makeMainLine => 'Δημιουργία κύριας γραμμής';

  @override
  String get deleteFromHere => 'Διαγραφή από εδώ';

  @override
  String get collapseVariations => 'Σύμπτυξη παραλλαγών';

  @override
  String get expandVariations => 'Εμφάνιση βαριάντων';

  @override
  String get forceVariation => 'Θέσε σε βαριάντα';

  @override
  String get copyVariationPgn => 'Αντιγραφή PGN αρχείου κινήσεων';

  @override
  String get move => 'Κίνηση';

  @override
  String get variantLoss => 'Ήττα εκδοχής';

  @override
  String get variantWin => 'Νίκη εκδοχής';

  @override
  String get insufficientMaterial => 'Ανεπαρκές υλικό';

  @override
  String get pawnMove => 'Κίνηση πιονιού';

  @override
  String get capture => 'Αιχμαλώτιση';

  @override
  String get close => 'Κλείσιμο';

  @override
  String get winning => 'Κερδίζει';

  @override
  String get losing => 'Χάνει';

  @override
  String get drawn => 'Ισοπαλία';

  @override
  String get unknown => 'Άγνωστο';

  @override
  String get database => 'Βάση δεδομένων';

  @override
  String get whiteDrawBlack => 'Λευκά / Ισοπαλία / Μαύρα';

  @override
  String averageRatingX(String param) {
    return 'Μέση βαθμολογία: $param';
  }

  @override
  String get recentGames => 'Πρόσφατα παιχνίδια';

  @override
  String get topGames => 'Κορυφαίες παρτίδες';

  @override
  String masterDbExplanation(String param1, String param2, String param3) {
    return 'Παρτίδες OTB $param1 + παικτών με αξιολόγηση FIDE, από $param2 έως $param3';
  }

  @override
  String get dtzWithRounding => 'DTZ50\'\' με στρογγυλοποίηση, βάσει του αριθμού των κινήσεων μέχρι την επόμενη κίνηση πιονιού ή την επόμενη αλλαγή';

  @override
  String get noGameFound => 'Δεν βρέθηκε παρτίδα';

  @override
  String get maxDepthReached => 'Έχετε φτάσει το μέγιστο βάθος!';

  @override
  String get maybeIncludeMoreGamesFromThePreferencesMenu => 'Δοκιμάστε να συμπεριλάβετε περισσότερα παιχνίδια από το μενού προτιμήσεων.';

  @override
  String get openings => 'Ανοίγματα';

  @override
  String get openingExplorer => 'Εξερευνητής ανοιγμάτων';

  @override
  String get openingEndgameExplorer => 'Εξερευνητής ανοιγμάτων/φινάλε';

  @override
  String xOpeningExplorer(String param) {
    return '$param εξερευνητής ανοιγμάτων';
  }

  @override
  String get playFirstOpeningEndgameExplorerMove => 'Κλειδί: παίξτε ΠρώταΆνοιγμαΦινάλεΕξερευνητήςΚίνηση';

  @override
  String get winPreventedBy50MoveRule => 'H νίκη εμποδίζεται από τον κανόνα των 50 κινήσεων';

  @override
  String get lossSavedBy50MoveRule => 'Η ήττα αποτρέπεται από τον κανόνα των 50 κινήσεων';

  @override
  String get winOr50MovesByPriorMistake => 'Νίκη ή ισοπαλία από 50 κινήσεις λόγω λάθους';

  @override
  String get lossOr50MovesByPriorMistake => 'Ήττα ή ισοπαλία από 50 κινήσεις λόγω λάθους';

  @override
  String get unknownDueToRounding => 'Η νίκη/ήττα είναι εγγυημένη μόνο εάν έχει ακολουθηθεί η συνιστώμενη γραμμή βάσης από την τελευταία κίνηση πιονιού ή την τελευταία αλλαγή, λόγω πιθανής στρογγυλοποίησης.';

  @override
  String get allSet => 'Εφαρμογή!';

  @override
  String get importPgn => 'Εισαγωγή PGN';

  @override
  String get delete => 'Διαγραφή';

  @override
  String get deleteThisImportedGame => 'Διαγραφή εισηγμένης παρτίδας;';

  @override
  String get replayMode => 'Επανάληψη';

  @override
  String get realtimeReplay => 'Σε πραγματικό χρόνο';

  @override
  String get byCPL => 'Με CPL';

  @override
  String get enable => 'Ενεργοποίηση';

  @override
  String get bestMoveArrow => 'Βέλτιστη κίνηση βέλους';

  @override
  String get showVariationArrows => 'Εμφάνισε βελάκια παραλλαγών';

  @override
  String get evaluationGauge => 'Δείκτης αξιολόγησης';

  @override
  String get multipleLines => 'Πολλαπλές γραμμές';

  @override
  String get cpus => 'CPUs';

  @override
  String get memory => 'Μνήμη';

  @override
  String get infiniteAnalysis => 'Άπειρη ανάλυση';

  @override
  String get removesTheDepthLimit => 'Καταργεί το όριο βάθους και κρατά τον υπολογιστή σας ζεστό';

  @override
  String get blunder => 'Σοβαρό σφάλμα';

  @override
  String get mistake => 'Λάθος';

  @override
  String get inaccuracy => 'Ανακρίβεια';

  @override
  String get moveTimes => 'Χρόνοι κινήσεων';

  @override
  String get flipBoard => 'Περιστροφή σκακιέρας';

  @override
  String get threefoldRepetition => 'Τριπλή επανάληψη';

  @override
  String get claimADraw => 'Απαίτηση ισοπαλίας';

  @override
  String get drawClaimed => 'Draw claimed';

  @override
  String get offerDraw => 'Προσφορά ισοπαλίας';

  @override
  String get draw => 'Ισοπαλία';

  @override
  String get drawByMutualAgreement => 'Ισοπαλία κατόπιν συμφωνίας';

  @override
  String get fiftyMovesWithoutProgress => 'Πενήντα κινήσεις χωρίς πρόοδο';

  @override
  String get currentGames => 'Παιχνίδια σε εξέλιξη';

  @override
  String get viewInFullSize => 'Προβολή σε πλήρες μέγεθος';

  @override
  String get logOut => 'Έξοδος';

  @override
  String get signIn => 'Είσοδος';

  @override
  String get rememberMe => 'Απομνημόνευση των στοιχείων σύνδεσης';

  @override
  String get youNeedAnAccountToDoThat => 'Χρειάζεστε λογαριασμό για να το κάνετε αυτό';

  @override
  String get signUp => 'Εγγραφή';

  @override
  String get computersAreNotAllowedToPlay => 'Δεν επιτρέπουμε στους υπολογιστές και παίκτες με υποβοήθηση υπολογιστή να παίζουν στο Lichess. Παρακαλούμε μη δεχτείτε βοήθεια από σκακιστικούς υπολογιστές, βάσεις δεδομένων ή άλλους παίκτες όσο παίζετε εδώ. Επίσης σημειώστε πως αποθαρρύνουμε την δημιουργία πολλών λογαριασμών και υπερβολή σε αυτό θα καταλήξει σε αποκλεισμό.';

  @override
  String get games => 'Παιχνίδια';

  @override
  String get forum => 'Φόρουμ';

  @override
  String xPostedInForumY(String param1, String param2) {
    return 'Ο χρήστης $param1 έγραψε στη συζήτηση $param2';
  }

  @override
  String get latestForumPosts => 'Τελευταίες δημοσιεύσεις στο φόρουμ';

  @override
  String get players => 'Παίκτες';

  @override
  String get friends => 'Φίλοι';

  @override
  String get otherPlayers => 'άλλους παίκτες';

  @override
  String get discussions => 'Συζητήσεις';

  @override
  String get today => 'Σήμερα';

  @override
  String get yesterday => 'Χθες';

  @override
  String get minutesPerSide => 'Λεπτά ανά πλευρά';

  @override
  String get variant => 'Εκδοχή';

  @override
  String get variants => 'Εκδοχές';

  @override
  String get timeControl => 'Χρονόμετρο';

  @override
  String get realTime => 'Πραγματικού χρόνου';

  @override
  String get correspondence => 'Αλληλογραφία';

  @override
  String get daysPerTurn => 'Ημέρες ανά κίνηση';

  @override
  String get oneDay => 'Μία ημέρα';

  @override
  String get time => 'Χρόνος';

  @override
  String get rating => 'Βαθμολογία';

  @override
  String get ratingStats => 'Στατιστικές βαθμολογίας';

  @override
  String get username => 'Όνομα χρήστη';

  @override
  String get usernameOrEmail => 'Όνομα χρήστη ή ηλ. ταχυδρομείο';

  @override
  String get changeUsername => 'Αλλαγή ονόματος χρήστη';

  @override
  String get changeUsernameNotSame => 'Μόνο η αλλαγή χαρακτήρων από μικρά σε κεφαλαία επιτρέπεται. Για παράδειγμα \"johndoe\" σε \"JohnDoe\".';

  @override
  String get changeUsernameDescription => 'Αλλαγή ονόματος χρήστη. Μπορεί να γίνει μόνο μία φορά και μόνο η αλλαγή χαρακτήρων σε μικρά-κεφαλαία στο όνομα χρήστη επιτρέπεται.';

  @override
  String get signupUsernameHint => 'Eπιλέξτε ένα φιλικό προς την οικογένεια όνομα χρήστη, καθώς δε θα μπορέσετε να το αλλάξετε αργότερα. Λογαριασμοί με ακατάλληλα ψευδώνυμα θα απενεργοποιούνται!';

  @override
  String get signupEmailHint => 'Θα τη χρησιμοποιήσουμε μόνο για την επαναφορά του κωδικού πρόσβασης.';

  @override
  String get password => 'Κωδικός';

  @override
  String get changePassword => 'Αλλαγή κωδικού';

  @override
  String get changeEmail => 'Αλλαγή διεύθυνσης email';

  @override
  String get email => 'Ηλ. ταχυδρομείο';

  @override
  String get passwordReset => 'Επαναφορά κωδικού';

  @override
  String get forgotPassword => 'Ξεχάσατε τον κωδικό;';

  @override
  String get error_weakPassword => 'Αυτός ο κωδικός πρόσβασης είναι εξαιρετικά συνηθισμένος και πολύ εύκολος να μαντέψει.';

  @override
  String get error_namePassword => 'Παρακαλώ μην χρησιμοποιείτε το όνομα χρήστη σας ως κωδικό πρόσβασής σας.';

  @override
  String get blankedPassword => 'Έχετε χρησιμοποιήσει τον ίδιο κωδικό πρόσβασης σε άλλη ιστοσελίδα και εκείνη η ιστοσελίδα έχει παραβιαστεί. Για να διασφαλίσετε την ασφάλεια του λογαριασμού σας στο Lichess θα πρέπει να ορίσετε ένα νέο κωδικό πρόσβασης. Σας ευχαριστούμε για την κατανόησή.';

  @override
  String get youAreLeavingLichess => 'Φεύγετε από το Lichess';

  @override
  String get neverTypeYourPassword => 'Ποτέ μην πληκτρολογήσετε τον κωδικό σας από το Lichess σε άλλον ιστότοπο!';

  @override
  String proceedToX(String param) {
    return 'Μεταβείτε στο $param';
  }

  @override
  String get passwordSuggestion => 'Μην ορίσετε τον κωδικό πρόσβασης που σας πρότεινε κάποιος άλλος. Θα χρησιμοποιηθεί για να κλαπεί ο λογαριασμός σας.';

  @override
  String get emailSuggestion => 'Μη χρησιμοποιήσετε email που στάλθηκε από κάποιον άλλο. Θα το χρησιμοποιήσουν για να κλέψουν τον λογαριασμό σας.';

  @override
  String get emailConfirmHelp => 'Βοήθεια για την επιβεβαίωση email';

  @override
  String get emailConfirmNotReceived => 'Δε λάβατε το email επιβεβαίωσης μετά την εγγραφή;';

  @override
  String get whatSignupUsername => 'Τι όνομα χρήστη χρησιμοποιήσατε για να εγγραφείτε;';

  @override
  String usernameNotFound(String param) {
    return 'Δεν μπορέσαμε να βρούμε κάποιον χρήστη με το όνομα: $param.';
  }

  @override
  String get usernameCanBeUsedForNewAccount => 'Μπορείτε να χρησιμοποιήσετε αυτό το όνομα χρήστη για να δημιουργήσετε ένα νέο λογαριασμό';

  @override
  String emailSent(String param) {
    return 'Στείλαμε ένα email στη διεύθυνση $param.';
  }

  @override
  String get emailCanTakeSomeTime => 'Μπορεί να πάρει κάποια λεπτά μέχρι να φτάσει.';

  @override
  String get refreshInboxAfterFiveMinutes => 'Περιμένετε 5 λεπτά και ανανεώστε τα εισερχόμενα email σας.';

  @override
  String get checkSpamFolder => 'Επίσης, ελέγξτε τον φάκελο ανεπιθύμητης αλληλογραφίας, μπορεί να έχει καταλήξει εκεί. Αν ναι, σημειώστε το ως μη ανεπιθύμητο.';

  @override
  String get emailForSignupHelp => 'Αν όλα τα άλλα αποτύχουν, τότε στείλτε μας αυτό το email:';

  @override
  String copyTextToEmail(String param) {
    return 'Αντιγράψτε και επικολλήστε το παραπάνω κείμενο και στείλτε το στο $param';
  }

  @override
  String get waitForSignupHelp => 'Θα επανέλθουμε σύντομα σε σας για να σας βοηθήσουμε να ολοκληρώσετε την εγγραφή σας.';

  @override
  String accountConfirmed(String param) {
    return 'Ο χρήστης $param έχει επαληθευτεί με επιτυχία.';
  }

  @override
  String accountCanLogin(String param) {
    return 'Μπορείτε να συνδεθείτε τώρα ως $param.';
  }

  @override
  String get accountConfirmationEmailNotNeeded => 'Δεν χρειάζεστε ένα email επιβεβαίωσης.';

  @override
  String accountClosed(String param) {
    return 'Ο λογαριασμός $param έχει κλείσει.';
  }

  @override
  String accountRegisteredWithoutEmail(String param) {
    return 'Ο λογαριασμός $param καταχωρήθηκε χωρίς email.';
  }

  @override
  String get rank => 'Κατάταξη';

  @override
  String rankX(String param) {
    return 'Κατάταξη: $param';
  }

  @override
  String get gamesPlayed => 'Παιγμένα παιχνίδια';

  @override
  String get ok => 'ΟΚ';

  @override
  String get cancel => 'Ακύρωση';

  @override
  String get whiteTimeOut => 'Τέλος χρόνου για τα λευκά';

  @override
  String get blackTimeOut => 'Τέλος χρόνου για τα μαύρα';

  @override
  String get drawOfferSent => 'Πρόταση ισοπαλίας εστάλη';

  @override
  String get drawOfferAccepted => 'Πρόταση ισοπαλίας αποδεκτή';

  @override
  String get drawOfferCanceled => 'Πρόταση ισοπαλίας ακυρώθηκε';

  @override
  String get whiteOffersDraw => 'Τα λευκά προσφέρουν ισοπαλία';

  @override
  String get blackOffersDraw => 'Τα μαύρα προσφέρουν ισοπαλία';

  @override
  String get whiteDeclinesDraw => 'Τα λευκά απορρίπτουν την ισοπαλία';

  @override
  String get blackDeclinesDraw => 'Τα μαύρα απορρίπτουν την ισοπαλία';

  @override
  String get yourOpponentOffersADraw => 'Ο αντίπαλος σας προτείνει ισοπαλία';

  @override
  String get accept => 'Αποδοχή';

  @override
  String get decline => 'Άρνηση';

  @override
  String get playingRightNow => 'Παιχνίδι σε εξέλιξη τώρα';

  @override
  String get eventInProgress => 'Σε εξέλιξη τώρα';

  @override
  String get finished => 'Ολοκληρωμένα';

  @override
  String get abortGame => 'Εγκαταλείψτε το παιχνίδι';

  @override
  String get gameAborted => 'Παιχνίδι εγκατελήφθη';

  @override
  String get standard => 'Κανονικό';

  @override
  String get customPosition => 'Προσαρμοσμένη θέση';

  @override
  String get unlimited => 'Απεριόριστου χρόνου';

  @override
  String get mode => 'Τύπος παιχνιδιού';

  @override
  String get casual => 'Φιλικό';

  @override
  String get rated => 'Βαθμολογημένο';

  @override
  String get casualTournament => 'Φιλικό';

  @override
  String get ratedTournament => 'Βαθμολογημένo';

  @override
  String get thisGameIsRated => 'Το παιχνίδι βαθμολογείται';

  @override
  String get rematch => 'Ξαναπαίξτε';

  @override
  String get rematchOfferSent => 'Πρόταση ρεβάνς εστάλη';

  @override
  String get rematchOfferAccepted => 'Η πρόταση ρεβάνς έγινε αποδεκτή';

  @override
  String get rematchOfferCanceled => 'Η πρόταση ρεβάνς ακυρώθηκε';

  @override
  String get rematchOfferDeclined => 'Η πρόταση ρεβάνς απορρίφθηκε';

  @override
  String get cancelRematchOffer => 'Ακύρωση πρότασης ρεβάνς';

  @override
  String get viewRematch => 'Δείτε την παρτίδα ρεβάνς';

  @override
  String get confirmMove => 'Επιβεβαίωση κίνησης';

  @override
  String get play => 'Παίξτε';

  @override
  String get inbox => 'Εισερχόμενα';

  @override
  String get chatRoom => 'Ζωντανή συζήτηση';

  @override
  String get loginToChat => 'Συνδεθείτε για να μιλήσετε';

  @override
  String get youHaveBeenTimedOut => 'Έχετε αποσυνδεθεί.';

  @override
  String get spectatorRoom => 'Συζήτηση θεατών';

  @override
  String get composeMessage => 'Σύνθεση μηνύματος';

  @override
  String get subject => 'Θέμα';

  @override
  String get send => 'Αποστολή';

  @override
  String get incrementInSeconds => 'Προσαύξηση σε δευτερόλεπτα';

  @override
  String get freeOnlineChess => 'Δωρεάν Διαδικτυακό Σκάκι';

  @override
  String get exportGames => 'Εξαγωγή παιχνιδιών';

  @override
  String get ratingRange => 'Εμβέλεια βαθμολογίας';

  @override
  String get thisAccountViolatedTos => 'Αυτός ο λογαριασμός παραβαίνει τους όρους χρήσης του Lichess';

  @override
  String get openingExplorerAndTablebase => 'Εξερευνητής ανοιγμάτων & φινάλε';

  @override
  String get takeback => 'Ανάκληση κίνησης';

  @override
  String get proposeATakeback => 'Προσφέρετε ανάκληση της προηγούμενης κίνησης';

  @override
  String get takebackPropositionSent => 'Προσφορά ανάκλησης κίνησης εστάλη';

  @override
  String get takebackPropositionDeclined => 'Απορρίφθηκε η προσφορά ανάκλησης κίνησης';

  @override
  String get takebackPropositionAccepted => 'Προσφορά ακύρωσης κίνησης αποδεκτή';

  @override
  String get takebackPropositionCanceled => 'Προσφορά ακύρωσης κίνησης ακυρώθηκε';

  @override
  String get yourOpponentProposesATakeback => 'Ο αντίπαλός σας πρότεινε ακύρωση της τελευταίας κίνησης';

  @override
  String get bookmarkThisGame => 'Προσθέστε σελιδοδείκτη για αυτό το παιχνίδι';

  @override
  String get tournament => 'Τουρνουά';

  @override
  String get tournaments => 'Πρωταθλήματα';

  @override
  String get tournamentPoints => 'Πόντοι από τουρνουά';

  @override
  String get viewTournament => 'Παρακολούθηση τουρνουά';

  @override
  String get backToTournament => 'Επιστροφή στο τουρνουά';

  @override
  String get noDrawBeforeSwissLimit => 'Στα τουρνουά ελβετικού τύπου, απαγορεύονται οι προτάσεις ισοπαλίας σε λιγότερες από 30 κινήσεις.';

  @override
  String get thematic => 'Θεματικό';

  @override
  String yourPerfRatingIsProvisional(String param) {
    return 'Η $param βαθμολογία σας είναι προσωρινή';
  }

  @override
  String yourPerfRatingIsTooHigh(String param1, String param2) {
    return 'Η $param1 βαθμολογία σας ($param2) είναι πολύ υψηλή';
  }

  @override
  String yourTopWeeklyPerfRatingIsTooHigh(String param1, String param2) {
    return 'Η κορυφαία εβδομαδιαία $param1 βαθμολογία σας ($param2) είναι πολύ υψηλή';
  }

  @override
  String yourPerfRatingIsTooLow(String param1, String param2) {
    return 'Η $param1 βαθμολογία σας ($param2) είναι πολύ χαμηλή';
  }

  @override
  String ratedMoreThanInPerf(String param1, String param2) {
    return 'Βαθμολογημένο ≥ $param1 στο $param2';
  }

  @override
  String ratedLessThanInPerf(String param1, String param2) {
    return 'Βαθμολογημένο ≤ $param1 στο $param2';
  }

  @override
  String mustBeInTeam(String param) {
    return 'Πρέπει να είστε στην ομάδα $param';
  }

  @override
  String youAreNotInTeam(String param) {
    return 'Δεν είστε στην ομάδα $param';
  }

  @override
  String get backToGame => 'Επιστρέψτε στο παιχνίδι';

  @override
  String get siteDescription => 'Δωρεάν διαδικτυακό παιχνίδι Σκακιού. Παίξτε Σκάκι τώρα σε καθαρό γραφικό περιβάλλον. Χωρίς εγγραφές, χωρίς διαφημίσεις, χωρίς πρόσθετα. Παίξτε Σκάκι με τον υπολογιστή, με φίλους ή με τυχαίους αντιπάλους.';

  @override
  String xJoinedTeamY(String param1, String param2) {
    return 'Ο/Η $param1 έγινε μέλος της ομάδα $param2';
  }

  @override
  String xCreatedTeamY(String param1, String param2) {
    return 'Ο $param1 δημιούργησε την ομάδα $param2';
  }

  @override
  String get startedStreaming => 'ξεκίνησε να μεταδίδει';

  @override
  String xStartedStreaming(String param) {
    return '$param ξεκίνησε να μεταδίδει';
  }

  @override
  String get averageElo => 'Μέσος όρος βαθμολογίας';

  @override
  String get location => 'Τοποθεσία';

  @override
  String get filterGames => 'Φίλτρο παιχνιδιών';

  @override
  String get reset => 'Επαναφορά';

  @override
  String get apply => 'Εφαρμογή';

  @override
  String get save => 'Αποθήκευση';

  @override
  String get leaderboard => 'Πίνακας βαθμολογίας';

  @override
  String get screenshotCurrentPosition => 'Τραβήξτε στιγμιότυπο της τρέχουσας θέσης';

  @override
  String get gameAsGIF => 'Αποθήκευση ως GIF';

  @override
  String get pasteTheFenStringHere => 'Επικολλήστε τον κώδικα FEN εδώ';

  @override
  String get pasteThePgnStringHere => 'Επικολλήστε το κείμενο του PGN εδώ';

  @override
  String get orUploadPgnFile => 'Ή μεταφορτώστε ένα αρχείο PGN';

  @override
  String get fromPosition => 'Από συγκεκριμένη θέση';

  @override
  String get continueFromHere => 'Συνέχεια από εδώ';

  @override
  String get toStudy => 'Μελέτη';

  @override
  String get importGame => 'Εισαγωγή παιχνιδιού';

  @override
  String get importGameExplanation => 'Επικολλήστε PGN παιχνιδιού για να δημιουργήσετε περιηγήσιμη αναπαραγωγή, \nανάλυση από υπολογιστή, συνομιλία παιχνιδιού και κοινόχρηστο URL.';

  @override
  String get importGameCaveat => 'Οι παραλλαγές θα διαγραφούν. Για να τις κρατήσετε εισάγεται το PGN μέσω μιας μελέτης.';

  @override
  String get importGameDataPrivacyWarning => 'Αυτό το PGN είναι προσβάσιμο από το κοινό. Για να εισαγάγετε ένα παιχνίδι ιδιωτικά, χρησιμοποιήστε μια μελέτη.';

  @override
  String get thisIsAChessCaptcha => 'Αυτό είναι CAPTCHA σκακιού.';

  @override
  String get clickOnTheBoardToMakeYourMove => 'Κάνετε κλικ στη σκακιέρα για να κινήσετε τα πιόνια και να αποδείξετε πως είστε άνθρωπος.';

  @override
  String get captcha_fail => 'Παρακαλούμε λύστε το σκακιστικό captcha.';

  @override
  String get notACheckmate => 'Δεν είναι ματ';

  @override
  String get whiteCheckmatesInOneMove => 'Παίζουν τα λευκά, κάντε ματ με μια κίνηση';

  @override
  String get blackCheckmatesInOneMove => 'Παίζουν τα μαύρα, κάντε ματ με μια κίνηση';

  @override
  String get retry => 'Επανάληψη';

  @override
  String get reconnecting => 'Επανασύνδεση';

  @override
  String get noNetwork => 'Εκτός σύνδεσης';

  @override
  String get favoriteOpponents => 'Αγαπημένοι αντίπαλοι';

  @override
  String get follow => 'Ακολουθήστε';

  @override
  String get following => 'Ακολουθείτε';

  @override
  String get unfollow => 'Κατάργηση παρακολούθησης';

  @override
  String followX(String param) {
    return 'Ακολουθήστε τον $param';
  }

  @override
  String unfollowX(String param) {
    return 'Κατάργηση ακολούθησης του $param';
  }

  @override
  String get block => 'Αποκλείστε';

  @override
  String get blocked => 'Αποκλεισμένος';

  @override
  String get unblock => 'Κατάργηση απόκλεισης';

  @override
  String xStartedFollowingY(String param1, String param2) {
    return 'Ο $param1 άρχισε να ακολουθεί τον $param2';
  }

  @override
  String get more => 'Περισσότερα';

  @override
  String get memberSince => 'Μέλος από τις';

  @override
  String lastSeenActive(String param) {
    return 'Τελευταία είσοδος $param';
  }

  @override
  String get player => 'Παίκτης';

  @override
  String get list => 'Κατάλογος';

  @override
  String get graph => 'Διάγραμμα';

  @override
  String get required => 'Απαιτείται.';

  @override
  String get openTournaments => 'Ανοικτά τουρνουά';

  @override
  String get duration => 'Διάρκεια';

  @override
  String get winner => 'Νικητής';

  @override
  String get standing => 'Κατάταξη';

  @override
  String get createANewTournament => 'Δημιουργήστε νέο τουρνουά';

  @override
  String get tournamentCalendar => 'Ημερολόγιο τουρνουά';

  @override
  String get conditionOfEntry => 'Προϋπόθεση εισόδου:';

  @override
  String get advancedSettings => 'Ρυθμίσεις για προχωρημένους';

  @override
  String get safeTournamentName => 'Διαλέξτε ένα πολύ ασφαλές όνομα για το τουρνουά.';

  @override
  String get inappropriateNameWarning => 'Οτιδήποτε ακόμα και ελάχιστα ακατάλληλο μπορεί να κλείσει τον λογαριασμό σας.';

  @override
  String get emptyTournamentName => 'Αφήστε το κενό για να πάρει το όνομά του τυχαία από κάποιον γνωστό σκακιστή.';

  @override
  String get makePrivateTournament => 'Κάντε το τουρνουά ιδιωτικό, και περιορίστε την πρόσβαση με κωδικό';

  @override
  String get join => 'Συμμετοχή';

  @override
  String get withdraw => 'Απόσυρση';

  @override
  String get points => 'Πόντοι';

  @override
  String get wins => 'Νίκες';

  @override
  String get losses => 'Ήττες';

  @override
  String get createdBy => 'Δημιουργήθηκε από';

  @override
  String get startingIn => 'Starting in';

  @override
  String get tournamentPairingsAreNowClosed => 'Οι αντιστοιχίσεις του διαγωνισμού έχουν κλείσει.';

  @override
  String standByX(String param) {
    return 'Αναμένετε $param, αντιστοίχιση παικτών, ετοιμαστείτε!';
  }

  @override
  String get pause => 'Παύση';

  @override
  String get resume => 'Συνέχεια';

  @override
  String get youArePlaying => 'Παίζετε τώρα!';

  @override
  String get winRate => 'Ποσοστό νικών';

  @override
  String get berserkRate => 'Ποσοστό berserk';

  @override
  String get performance => 'Επίδοση';

  @override
  String get tournamentComplete => 'Το τουρνουά ολοκληρώθηκε';

  @override
  String get movesPlayed => 'Παιγμένες κινήσεις';

  @override
  String get whiteWins => 'Τα άσπρα νικούν';

  @override
  String get blackWins => 'Τα μαύρα νικούν';

  @override
  String get drawRate => 'Ποσοστά ισοπαλίας';

  @override
  String get draws => 'Ισοπαλίες';

  @override
  String get averageOpponent => 'Μέση βαθμολογία αντιπάλων';

  @override
  String get boardEditor => 'Προετοιμαστής σκακιέρας';

  @override
  String get setTheBoard => 'Στήστε την σκακιέρα';

  @override
  String get popularOpenings => 'Δημοφιλή ανοίγματα';

  @override
  String get endgamePositions => 'Θέσεις φινάλε';

  @override
  String chess960StartPosition(String param) {
    return 'Αρχική θέση Chess960: $param';
  }

  @override
  String get startPosition => 'Αρχική διάταξη';

  @override
  String get clearBoard => 'Εκκαθάριση σκακιέρας';

  @override
  String get loadPosition => 'Φορτώστε θέση';

  @override
  String get isPrivate => 'Ιδιωτικό';

  @override
  String reportXToModerators(String param) {
    return 'Αναφέρετε τον $param στο προσωπικό';
  }

  @override
  String profileCompletion(String param) {
    return 'Ολοκλήρωση προφίλ: $param';
  }

  @override
  String xRating(String param) {
    return 'Βαθμολογία $param';
  }

  @override
  String get ifNoneLeaveEmpty => 'Αν δεν υπάρχει, αφήστε κενό';

  @override
  String get profile => 'Προφίλ';

  @override
  String get editProfile => 'Επεξεργασία προφίλ';

  @override
  String get realName => 'Πραγματικό όνομα';

  @override
  String get setFlair => 'Ορίστε τη νιφάδα σας';

  @override
  String get flair => 'Νιφάδα';

  @override
  String get youCanHideFlair => 'Υπάρχει μια ρύθμιση για να κρύψει όλες τις νιφάδες χρήστη σε ολόκληρη την ιστοσελίδα.';

  @override
  String get biography => 'Βιογραφικό';

  @override
  String get countryRegion => 'Χώρα ή περιοχή';

  @override
  String get thankYou => 'Ευχαριστούμε!';

  @override
  String get socialMediaLinks => 'Σύνδεσμοι κοινωνικών μέσων';

  @override
  String get oneUrlPerLine => 'Μία διεύθυνση URL ανά γραμμή.';

  @override
  String get inlineNotation => 'Ενσωματωμένη σημειογραφία';

  @override
  String get makeAStudy => 'Για αποθήκευση και διαμοιρασμό, μπορείτε να δημιουργήσετε μία μελέτη.';

  @override
  String get clearSavedMoves => 'Εκκαθάριση κινήσεων';

  @override
  String get previouslyOnLichessTV => 'Νωρίτερα στη Tηλεόραση Lichess';

  @override
  String get onlinePlayers => 'Συνδεδεμένοι παίκτες';

  @override
  String get activePlayers => 'Ενεργοί παίκτες';

  @override
  String get bewareTheGameIsRatedButHasNoClock => 'Προσοχή, το παιχνίδι βαθμολογείται αλλά του λείπει ρολόι!';

  @override
  String get success => 'Επιτυχία';

  @override
  String get automaticallyProceedToNextGameAfterMoving => 'Προχωρήστε αυτόματα στο επόμενο παιχνίδι μετά την κίνηση';

  @override
  String get autoSwitch => 'Αυτόματη εναλλαγή';

  @override
  String get puzzles => 'Γρίφοι';

  @override
  String get onlineBots => 'Συνδεδεμένα bot';

  @override
  String get name => 'Ονομασία';

  @override
  String get description => 'Περιγραφή';

  @override
  String get descPrivate => 'Ιδιωτική περιγραφή';

  @override
  String get descPrivateHelp => 'Κείμενο που θα δουν μόνο τα μέλη της ομάδας. Εάν οριστεί, αντικαθιστά τη δημόσια περιγραφή για τα μέλη της ομάδας.';

  @override
  String get no => 'Όχι';

  @override
  String get yes => 'Ναι';

  @override
  String get website => 'Ιστοσελίδα';

  @override
  String get mobile => 'Εφαρμογή Κινητού';

  @override
  String get help => 'Βοήθεια:';

  @override
  String get createANewTopic => 'Δημιουργήστε καινούριο θέμα';

  @override
  String get topics => 'Θέματα';

  @override
  String get posts => 'Δημοσιεύσεις';

  @override
  String get lastPost => 'Τελευταία δημοσίευση';

  @override
  String get views => 'Εμφανίσεις';

  @override
  String get replies => 'Απαντήσεις';

  @override
  String get replyToThisTopic => 'Απαντήστε σε αυτό το θέμα';

  @override
  String get reply => 'Απάντηση';

  @override
  String get message => 'Μήνυμα';

  @override
  String get createTheTopic => 'Δημιουργήστε θέμα';

  @override
  String get reportAUser => 'Αναφορά χρήστη';

  @override
  String get user => 'Χρήστης';

  @override
  String get reason => 'Αιτία';

  @override
  String get whatIsIheMatter => 'Τι τρέχει;';

  @override
  String get cheat => 'Απάτη';

  @override
  String get troll => 'Εμπαιγμός';

  @override
  String get other => 'Άλλο';

  @override
  String get reportCheatBoostHelp => 'Επικολλήστε τους συνδέσμους με τα παιχνίδια και εξηγήστε μας γιατί θεωρείτε ότι η συμπεριφορά του χρήστη είναι παράξενη σε αυτά. Μη λέτε απλώς ότι «κλέβει» (\"they cheat\"), αλλά πείτε μας πως καταλήξατε σε αυτό το συμπέρασμα.';

  @override
  String get reportUsernameHelp => 'Εξηγήστε μας γιατί είναι προσβλητικό το όνομα αυτού του χρήστη. Μη λέτε απλώς ότι \"είναι προσβλητικό/ακατάλληλο\" (\"it\'s offensive/inappropriate\"), αλλά πείτε μας πώς καταλήξατε σε αυτό το συμπέρασμα, ειδικά αν πρόκειται για προσβολή η οποία δεν είναι ιδιαίτερα εμφανής: για παράδειγμα αν δεν είναι στα αγγλικά, είναι σε κάποια αργκό ή κάνει κάποια προσβλητική ιστορική/πολιτιστική αναφορά.';

  @override
  String get reportProcessedFasterInEnglish => 'Η αναφορά σας θα επεξεργαστεί γρηγορότερα αν είναι γραμμένη στα αγγλικά.';

  @override
  String get error_provideOneCheatedGameLink => 'Καταχωρίστε τουλάχιστον έναν σύνδεσμο σε ένα παιχνίδι εξαπάτησης.';

  @override
  String by(String param) {
    return 'από τον $param';
  }

  @override
  String importedByX(String param) {
    return 'Εισήχθη από τον χρήστη $param';
  }

  @override
  String get thisTopicIsNowClosed => 'Το θέμα έχει κλείσει.';

  @override
  String get blog => 'Ιστολόγιο';

  @override
  String get notes => 'Σημειώσεις';

  @override
  String get typePrivateNotesHere => 'Γράψτε εδώ τις προσωπικές σας σημειώσεις';

  @override
  String get writeAPrivateNoteAboutThisUser => 'Γράψτε μια ιδιωτική σημείωση για αυτόν το χρήστη';

  @override
  String get noNoteYet => 'Καμία σημείωση ακόμη';

  @override
  String get invalidUsernameOrPassword => 'Άκυρο όνομα χρήστη ή κωδικός';

  @override
  String get incorrectPassword => 'Εσφαλμένος κωδικός';

  @override
  String get invalidAuthenticationCode => 'Μη έγκυρος κωδικός επαλήθευσης';

  @override
  String get emailMeALink => 'Στείλτε μου σύνδεσμο μέσω ηλ. ταχυδρομείου';

  @override
  String get currentPassword => 'Κωδικός σε ισχύ';

  @override
  String get newPassword => 'Νέος κωδικός';

  @override
  String get newPasswordAgain => 'Νέος κωδικός (επαλήθευση)';

  @override
  String get newPasswordsDontMatch => 'Οι νέοι κωδικοί πρόσβασης δεν ταιριάζουν';

  @override
  String get newPasswordStrength => 'Ισχύς Κωδικού Πρόσβασης';

  @override
  String get clockInitialTime => 'Ρολόι αρχικός χρόνος';

  @override
  String get clockIncrement => 'Ρολόι προσαύξηση';

  @override
  String get privacy => 'Απόρρητο';

  @override
  String get privacyPolicy => 'Πολιτική απορρήτου';

  @override
  String get letOtherPlayersFollowYou => 'Επιτρέψτε σε άλλους παίκτες να σας ακολουθούν';

  @override
  String get letOtherPlayersChallengeYou => 'Επιτρέψτε σε άλλους παίκτες να σας προκαλούν σε παιχνίδι';

  @override
  String get letOtherPlayersInviteYouToStudy => 'Επιτρέψτε σε άλλους παίκτες να σας προσκαλούν σε μελέτη';

  @override
  String get sound => 'Ήχος';

  @override
  String get none => 'Καθόλου';

  @override
  String get fast => 'Γρήγορη';

  @override
  String get normal => 'Κανονική';

  @override
  String get slow => 'Αργή';

  @override
  String get insideTheBoard => 'Μέσα στη σκακιέρα';

  @override
  String get outsideTheBoard => 'Εκτός της σκακιέρας';

  @override
  String get allSquaresOfTheBoard => 'Σε όλα τα τετράγωνα της σκακιέρας';

  @override
  String get onSlowGames => 'Σε αργά παιχνίδια';

  @override
  String get always => 'Πάντα';

  @override
  String get never => 'Ποτέ';

  @override
  String xCompetesInY(String param1, String param2) {
    return 'Ο χρήστης $param1 ανταγωνίζεται στο $param2';
  }

  @override
  String get victory => 'Επιτυχία';

  @override
  String get defeat => 'Ήττα';

  @override
  String victoryVsYInZ(String param1, String param2, String param3) {
    return '$param1 εναντίον $param2 σε $param3';
  }

  @override
  String defeatVsYInZ(String param1, String param2, String param3) {
    return '$param1 εναντίον $param2 σε $param3';
  }

  @override
  String drawVsYInZ(String param1, String param2, String param3) {
    return '$param1 εναντίον $param2 σε $param3';
  }

  @override
  String get timeline => 'Χρονολόγιο';

  @override
  String get starting => 'Αρχίζει:';

  @override
  String get allInformationIsPublicAndOptional => 'Όλες οι πληροφορίες είναι δημόσιες και προαιρετικές.';

  @override
  String get biographyDescription => 'Γράψτε για τον εαυτό σας, τι σας αρέσει στο σκάκι, τα αγαπημένα σας ανοίγματα, παιχνίδια, παίκτες…';

  @override
  String get listBlockedPlayers => 'Κατάλογος παικτών που έχετε αποκλείσει';

  @override
  String get human => 'Άνθρωπος';

  @override
  String get computer => 'Υπολογιστής';

  @override
  String get side => 'Πλευρά';

  @override
  String get clock => 'Χρόνος';

  @override
  String get opponent => 'Αντίπαλος';

  @override
  String get learnMenu => 'Εκμάθηση';

  @override
  String get studyMenu => 'Μελέτη';

  @override
  String get practice => 'Εξάσκηση';

  @override
  String get community => 'Κοινότητα';

  @override
  String get tools => 'Εργαλεία';

  @override
  String get increment => 'Προσαύξηση';

  @override
  String get error_unknown => 'Άκυρη τιμή';

  @override
  String get error_required => 'Αυτό το πεδίο είναι υποχρεωτικό';

  @override
  String get error_email => 'Αυτή η διεύθυνση ηλεκτρονικού ταχυδρομείου δεν είναι έγκυρη';

  @override
  String get error_email_acceptable => 'Αυτή η διεύθυνση ηλ. ταχυδρομείου δεν είναι αποδεκτή. Ελέγξτε την και προσπαθήστε ξανά.';

  @override
  String get error_email_unique => 'Η διεύθυνση ηλεκτρονικού ταχυδρομείου είναι άκυρη ή υπάρχει ήδη';

  @override
  String get error_email_different => 'Έχετε ήδη αυτήν την διεύθυνση ηλ. ταχυδρομείου';

  @override
  String error_minLength(String param) {
    return 'Πρέπει να περιέχει τουλάχιστον $param χαρακτήρες';
  }

  @override
  String error_maxLength(String param) {
    return 'Πρέπει να περιέχει το πολύ $param χαρακτήρες';
  }

  @override
  String error_min(String param) {
    return 'Πρέπει να είναι τουλάχιστον $param';
  }

  @override
  String error_max(String param) {
    return 'Πρέπει να είναι το πολύ $param';
  }

  @override
  String ifRatingIsPlusMinusX(String param) {
    return 'Εάν η βαθμολογία είναι ± $param';
  }

  @override
  String get ifRegistered => 'Εάν είναι εγγεγραμμένοι';

  @override
  String get onlyExistingConversations => 'Μόνο υπάρχουσες συνομιλίες';

  @override
  String get onlyFriends => 'Μόνο φίλοι';

  @override
  String get menu => 'Κατάλογος';

  @override
  String get castling => 'Pοκέ';

  @override
  String get whiteCastlingKingside => 'Λευκά O-O';

  @override
  String get blackCastlingKingside => 'Μαύρα O-O';

  @override
  String tpTimeSpentPlaying(String param) {
    return 'Χρόνος που διατέθηκε παίζοντας: $param';
  }

  @override
  String get watchGames => 'Παρακολουθήστε παιχνίδια';

  @override
  String tpTimeSpentOnTV(String param) {
    return 'Χρόνος στην Τηλεόραση: $param';
  }

  @override
  String get watch => 'Παρακολουθήστε';

  @override
  String get videoLibrary => 'Βιβλιοθήκη τηλεοπτικού υλικού';

  @override
  String get streamersMenu => 'Streamers';

  @override
  String get mobileApp => 'Εφαρμογή για Κινητά';

  @override
  String get webmasters => 'Διαχειριστές';

  @override
  String get about => 'Σχετικά με';

  @override
  String aboutX(String param) {
    return 'Σχετικά με $param';
  }

  @override
  String xIsAFreeYLibreOpenSourceChessServer(String param1, String param2) {
    return 'Ο $param1 είναι ($param2) δωρεάν, ελεύθερος, χωρίς διαφημίσεις, ανοικτού κώδικα διακομιστής για σκάκι.';
  }

  @override
  String get really => 'πραγματικά';

  @override
  String get contribute => 'Συνεισφέρετε';

  @override
  String get termsOfService => 'Όροι χρήσης';

  @override
  String get sourceCode => 'Πηγαίος κώδικας';

  @override
  String get simultaneousExhibitions => 'Σιμουλτανέ';

  @override
  String get host => 'Διοργανωτής';

  @override
  String hostColorX(String param) {
    return 'Χρώμα διοργανωτή: $param';
  }

  @override
  String get yourPendingSimuls => 'Τα εκκρεμείς σας σιμουλτανέ';

  @override
  String get createdSimuls => 'Πρόσφατα σιμουλτανέ';

  @override
  String get hostANewSimul => 'Διοργάνωση νέου σιμουλτανέ';

  @override
  String get signUpToHostOrJoinASimul => 'Εγγραφείτε για να φιλοξενήσετε ή να συμμετάσχετε σε ένα σιμουλτανέ';

  @override
  String get noSimulFound => 'Το σιμουλτανέ δε βρέθηκε';

  @override
  String get noSimulExplanation => 'Αυτό το σιμουλτανέ δεν υπάρχει.';

  @override
  String get returnToSimulHomepage => 'Επιστροφή στην αρχική σελίδα σιμουλτανέ';

  @override
  String get aboutSimul => 'Τα σιμουλτανέ είναι διοργανώσεις στις οποίες ένας μεμονωμένος παίκτης αντιμετωπίζει πολλούς ταυτόχρονα.';

  @override
  String get aboutSimulImage => 'Από τους 50 αντιπάλους, ο Φίσερ κέρδισε 47 παιχνίδια, κατάφερε 2 ισοπαλίες και έχασε 1.';

  @override
  String get aboutSimulRealLife => 'Η έννοια προέρχεται από πραγματικά γεγονότα. Σε πραγματικούς χώρους, ο διοργανωτής του σιμουλτανέ μετακινείται από τραπέζι σε τραπέζι για να παίξει μία και μόνο κίνηση.';

  @override
  String get aboutSimulRules => 'Όταν ξεκινήσει το σιμουλτανέ, κάθε παίκτης ξεκινά το παιχνίδι με τον διοργανωτή, ο οποίος έχει τα λευκά κομμάτια. Η διοργάνωση τελειώνει όταν όλα τα παιχνίδια ολοκληρωθούν.';

  @override
  String get aboutSimulSettings => 'Τα σιμουλτανέ είναι πάντα φιλικά. Οι επαναλήψεις, ανακλήσεις κινήσεων και προσθήκες επιπλέον χρόνου έχουν απενεργοποιηθεί.';

  @override
  String get create => 'Δημιουργήστε';

  @override
  String get whenCreateSimul => 'Όταν δημιουργείτε ένα σιμουλτανέ, πρέπει να παίξετε με αρκετούς παίκτες ταυτόχρονα.';

  @override
  String get simulVariantsHint => 'Εάν επιλέξετε διάφορες εκδοχές, κάθε παίκτης μπορεί να επιλέξει ποια θα παίξει.';

  @override
  String get simulClockHint => 'Ρολόι Φίσερ. Όσους περισσότερους παίκτες παίξετε, τόσο περισσότερο χρόνο ίσως χρειαστείτε.';

  @override
  String get simulAddExtraTime => 'Μπορείτε να προσθέσετε επιπλέον χρόνο στο ρολόι σας για να βοηθηθείτε.';

  @override
  String get simulHostExtraTime => 'Παροχή επιπλέον χρόνου στο ρολόι';

  @override
  String get simulAddExtraTimePerPlayer => 'Προσθήκη χρόνου στο ρολόι κάθε παίκτη που συνδέεται στο σιμουλτανέ.';

  @override
  String get simulHostExtraTimePerPlayer => 'Προσθήκη επιπλέον χρόνου ανά παίκτη';

  @override
  String get lichessTournaments => 'Τουρνουά στο Lichess';

  @override
  String get tournamentFAQ => 'Τεκμηρίωση για τουρνουά τύπου αρένας';

  @override
  String get timeBeforeTournamentStarts => 'Χρόνος προτού ξεκινήσει το τουρνουά';

  @override
  String get averageCentipawnLoss => 'Μέση απώλεια εκατοστοπιονιού';

  @override
  String get accuracy => 'Ακρίβεια';

  @override
  String get keyboardShortcuts => 'Συντομεύσεις πληκτρολογίου';

  @override
  String get keyMoveBackwardOrForward => 'μετακίνηση προς τα πίσω / προς τα εμπρός';

  @override
  String get keyGoToStartOrEnd => 'πηγαίνετε στην έναρξη / λήξη';

  @override
  String get keyCycleSelectedVariation => 'Επανάληψη επιλεγμένης βαριάντας';

  @override
  String get keyShowOrHideComments => 'εμφάνιση / απόκρυψη σχολίων';

  @override
  String get keyEnterOrExitVariation => 'είσοδος / έξοδος εκδοχής';

  @override
  String get keyRequestComputerAnalysis => 'Ζητήστε ανάλυση της θέσης από υπολογιστή, Μάθετε από τα λάθη σας';

  @override
  String get keyNextLearnFromYourMistakes => 'Συνέχεια (Μάθετε από τα λάθη σας)';

  @override
  String get keyNextBlunder => 'Επόμενο σοβαρό σφάλμα';

  @override
  String get keyNextMistake => 'Επόμενο λάθος';

  @override
  String get keyNextInaccuracy => 'Επόμενη ανακρίβεια';

  @override
  String get keyPreviousBranch => 'Προηγούμενος κλάδος';

  @override
  String get keyNextBranch => 'Επόμενος κλάδως';

  @override
  String get toggleVariationArrows => 'Εμφάνισε βελάκια παραλλαγών';

  @override
  String get cyclePreviousOrNextVariation => 'Κλειδί: κύκλος ΠροηγούμενηΉΕπόμενηΒαριάντα';

  @override
  String get toggleGlyphAnnotations => 'Μεταβολή ΓρίφοςΣχόλιο';

  @override
  String get togglePositionAnnotations => 'Μεταβολή ΘέσηΣχόλιο';

  @override
  String get variationArrowsInfo => 'Εκδοχή ΒέληΠληροφορίες.';

  @override
  String get playSelectedMove => 'παίξε την επιλεγμένη κίνηση';

  @override
  String get newTournament => 'Νέο τουρνουά';

  @override
  String get tournamentHomeTitle => 'Σκακιστικά τουρνουά διαφόρων χρόνων και εκδοχών';

  @override
  String get tournamentHomeDescription => 'Παίξτε στιγμιαία τορνουά. Συμμετάσχετε σε επίσημο διαγωνισμό ή δημιουργήστε δικό σας. Υπερταχέα, Ταχέα, Κλασσικά, 960, Βασιλιάς στο κέντρο, Τρία σαχ και πολλές άλλες επιλογές για ατελείωτη διασκέδαση.';

  @override
  String get tournamentNotFound => 'Τουρνουά δεν βρέθηκε';

  @override
  String get tournamentDoesNotExist => 'Αυτό το τουρνουά δεν υπάρχει.';

  @override
  String get tournamentMayHaveBeenCanceled => 'Ίσως έχει ακυρωθεί, εάν όλοι οι παίκτες αποχώρησαν πριν ξεκινήσει το τουρνουά.';

  @override
  String get returnToTournamentsHomepage => 'Επιστροφή στην αρχική σελίδα τουρνουά';

  @override
  String weeklyPerfTypeRatingDistribution(String param) {
    return 'Μηνιαία κατανομή βαθμολογίας $param';
  }

  @override
  String yourPerfTypeRatingIsRating(String param1, String param2) {
    return 'Η βαθμολογία σας στο $param1 είναι $param2.';
  }

  @override
  String youAreBetterThanPercentOfPerfTypePlayers(String param1, String param2) {
    return 'Είστε καλύτεροι από $param1 των παικτών $param2.';
  }

  @override
  String userIsBetterThanPercentOfPerfTypePlayers(String param1, String param2, String param3) {
    return 'Ο/Η $param1 είναι καλύτερος/η από το $param2 των $param3 παικτών.';
  }

  @override
  String betterThanPercentPlayers(String param1, String param2) {
    return 'Είστε καλύτεροι από $param1 των παικτών $param2';
  }

  @override
  String youDoNotHaveAnEstablishedPerfTypeRating(String param) {
    return 'Δεν έχετε μια καθιερωμένη βαθμολογία $param.';
  }

  @override
  String get yourRating => 'Η βαθμολογία σας';

  @override
  String get cumulative => 'Αθροιστικά';

  @override
  String get glicko2Rating => 'Βαθμολογία Glicko-2';

  @override
  String get checkYourEmail => 'Ελέγξτε το ηλ. ταχυδρομείο σας';

  @override
  String get weHaveSentYouAnEmailClickTheLink => 'Σας έχουμε στείλει ένα μήνυμα ηλ. ταχυδρομείου. Κάντε κλικ τον σύνδεσμο στο ηλ.ταχυδρομείο για να ενεργοποιήσετε τον λογαριασμό σας.';

  @override
  String get ifYouDoNotSeeTheEmailCheckOtherPlaces => 'Εάν δεν μπορείτε να δείτε το μήνυμα ηλ. ταχυδρομείου, ελέγξτε άλλες θέσεις που θα μπορούσε να είναι, όπως στα διαγραμμένα, ανεπιθύμητη αλληλογραφία, κοινωνικά, ή σε άλλους φακέλους.';

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
    return 'Έχουμε στείλει ένα μήνυμα ηλ. ταχυδρομείου στο $param. Κάντε κλικ τον σύνδεσμο στο ηλ. ταχυδρομείο για να επαναφέρετε τον κωδικό πρόσβασής σας.';
  }

  @override
  String byRegisteringYouAgreeToBeBoundByOur(String param) {
    return 'Με την εγγραφή σας συμφωνείτε ότι δεσμεύεστε από τους $param.';
  }

  @override
  String readAboutOur(String param) {
    return 'Διαβάστε για την $param μας.';
  }

  @override
  String get networkLagBetweenYouAndLichess => 'Υστέρηση δικτύου ανάμεσα σε εσάς και το lichess';

  @override
  String get timeToProcessAMoveOnLichessServer => 'Χρόνος επεξεργασίας μίας κίνησης στον διακομιστή lichess';

  @override
  String get downloadAnnotated => 'Λήψη με υποσημειώσεις';

  @override
  String get downloadRaw => 'Λήψη ακατέργαστο';

  @override
  String get downloadImported => 'Λήψη εισαγόμενου';

  @override
  String get downloadAllGames => 'Download all games';

  @override
  String get crosstable => 'Αποτελέσματα';

  @override
  String get youCanAlsoScrollOverTheBoardToMoveInTheGame => 'Μπορείτε επίσης να κινήσετε πάνω στην σκακιέρα για να μετακινηθείτε στο παιχνίδι.';

  @override
  String get scrollOverComputerVariationsToPreviewThem => 'Μετακινήστε το ποντίκι σας πάνω στις βαριάντες του υπολογιστή για την προεπισκόπησή τους.';

  @override
  String get analysisShapesHowTo => 'Πατήστε Shift + κλικ ή δεξί κλικ για να σχεδιάσετε κύκλους και βέλη στην σκακιέρα.';

  @override
  String get letOtherPlayersMessageYou => 'Επιτρέψτε άλλους παίκτες να σας στέλνουν μηνύματα';

  @override
  String get receiveForumNotifications => 'Να λαμβάνετε ειδοποιήσεις όταν γίνεται αναφορά σας στο φόρουμ';

  @override
  String get shareYourInsightsData => 'Κοινή χρήση των δεδομένων σας';

  @override
  String get withNobody => 'Με κανέναν';

  @override
  String get withFriends => 'Με φίλους';

  @override
  String get withEverybody => 'Με όλους';

  @override
  String get kidMode => 'Λειτουργία παιδιού';

  @override
  String get kidModeIsEnabled => 'Η λειτουργία για παιδιά είναι ενεργοποιημένη.';

  @override
  String get kidModeExplanation => 'Αυτό έχει σχέση με την ασφάλεια. Στην λειτουργία για παιδιά, απενεργοποιούνται όλες οι επικοινωνίες της ιστοσελίδας. Ενεργοποιήστε το για τα παιδιά σας και τους μαθητές, για την προστασία τους από άλλους διαδικτυακούς χρήστες.';

  @override
  String inKidModeTheLichessLogoGetsIconX(String param) {
    return 'Στην λειτουργία για παιδιά, το λογότυπο του lichess παίρνει ένα εικονίδιο $param, έτσι ώστε να γνωρίζετε ότι τα παιδιά σας είναι ασφαλή.';
  }

  @override
  String get askYourChessTeacherAboutLiftingKidMode => 'Ο λογαριασμός σας διαχειρίζεται. Ρωτήστε τον δασκαλό σας στο σκάκι για να αφαιρέσει τη λειτουργία παιδιού.';

  @override
  String get enableKidMode => 'Ενεργοποίηση λειτουργίας παιδιού';

  @override
  String get disableKidMode => 'Απενεργοποίηση λειτουργίας παιδιού';

  @override
  String get security => 'Ασφάλεια';

  @override
  String get sessions => 'Συνεδρίες';

  @override
  String get revokeAllSessions => 'ανακαλέστε όλες τις συνεδρίες';

  @override
  String get playChessEverywhere => 'Παίξτε σκάκι παντού';

  @override
  String get everybodyGetsAllFeaturesForFree => 'Όλα τα στοιχεία είναι δωρεάν για όλους';

  @override
  String get viewTheSolution => 'Δείτε τη λύση';

  @override
  String get noChallenges => 'Δεν έχετε προκλήσεις.';

  @override
  String xHostsY(String param1, String param2) {
    return '$param1 φιλοξενεί τη $param2';
  }

  @override
  String xJoinsY(String param1, String param2) {
    return '$param1 συμμετέχει στη $param2';
  }

  @override
  String xLikesY(String param1, String param2) {
    return '$param2 αρέσει στην/ον $param1';
  }

  @override
  String get quickPairing => 'Γρήγορη αντιστοίχιση';

  @override
  String get lobby => 'Χώρος αναμονής';

  @override
  String get anonymous => 'Ανώνυμος';

  @override
  String yourScore(String param) {
    return 'Η βαθμολογία σας: $param';
  }

  @override
  String get language => 'Γλώσσα';

  @override
  String get allLanguages => 'All languages';

  @override
  String get background => 'Φόντο';

  @override
  String get light => 'Φωτεινό';

  @override
  String get dark => 'Σκοτεινό';

  @override
  String get transparent => 'Διάφανο';

  @override
  String get deviceTheme => 'Θέμα συσκευής';

  @override
  String get backgroundImageUrl => 'Διεύθυνση εικόνας φόντου:';

  @override
  String get board => 'Σκακιέρα';

  @override
  String get size => 'Μέγεθος';

  @override
  String get opacity => 'Αδιαφάνεια';

  @override
  String get brightness => 'Φωτεινότητα';

  @override
  String get hue => 'Χροιά';

  @override
  String get boardReset => 'Επαναφορά χρωμάτων στα προκαθορισμένα';

  @override
  String get pieceSet => 'Επιλογή κομματιών';

  @override
  String get embedInYourWebsite => 'Ενσωματώστε στην ιστοσελίδα σας';

  @override
  String get usernameAlreadyUsed => 'Αυτό το όνομα χρήστη ήδη χρησιμοποιείται, παρακαλώ δοκιμάστε ένα άλλο.';

  @override
  String get usernamePrefixInvalid => 'Το όνομα χρήστη πρέπει να αρχίζει με ένα γράμμα.';

  @override
  String get usernameSuffixInvalid => 'Το όνομα χρήστη πρέπει να τελειώνει με ένα γράμμα ή έναν αριθμό.';

  @override
  String get usernameCharsInvalid => 'Το όνομα χρήστη πρέπει να περιέχει μόνο γράμματα, αριθμούς, κάτω παύλες και ενωτικά.';

  @override
  String get usernameUnacceptable => 'Αυτό το όνομα χρήστη δεν είναι αποδεκτό.';

  @override
  String get playChessInStyle => 'Παίξτε σκάκι με στυλ';

  @override
  String get chessBasics => 'Τα βασικά';

  @override
  String get coaches => 'Προπονητές';

  @override
  String get invalidPgn => 'Μη έγκυρο PGN';

  @override
  String get invalidFen => 'Μη έγκυρο FEN';

  @override
  String get custom => 'Προσαρμογή';

  @override
  String get notifications => 'Ειδοποιήσεις';

  @override
  String notificationsX(String param1) {
    return 'Ειδοποιήσεις: $param1';
  }

  @override
  String perfRatingX(String param) {
    return 'Βαθμολογία: $param';
  }

  @override
  String get practiceWithComputer => 'Εξάσκηση με τον υπολογιστή';

  @override
  String anotherWasX(String param) {
    return 'Εναλλακτική ήταν $param';
  }

  @override
  String bestWasX(String param) {
    return 'Το καλύτερο ήταν $param';
  }

  @override
  String get youBrowsedAway => 'Απομακρυνθήκατε';

  @override
  String get resumePractice => 'Συνεχίσετε την πρακτική';

  @override
  String get drawByFiftyMoves => 'Ισοπαλία λόγω του κανόνα των 50 κινήσεων.';

  @override
  String get theGameIsADraw => 'Η παρτίδα είναι ισόπαλη.';

  @override
  String get computerThinking => 'Ο υπολογιστής σκέφτεται ...';

  @override
  String get seeBestMove => 'Δείτε την καλύτερη κίνηση';

  @override
  String get hideBestMove => 'Απόκρυψη καλύτερης κίνησης';

  @override
  String get getAHint => 'Λάβετε μια υπόδειξη';

  @override
  String get evaluatingYourMove => 'Αξιολογώντας την κίνηση σας...';

  @override
  String get whiteWinsGame => 'Κερδίζουν τα λευκά';

  @override
  String get blackWinsGame => 'Κερδίζουν τα μαύρα';

  @override
  String get learnFromYourMistakes => 'Μάθετε από τα λάθη σας';

  @override
  String get learnFromThisMistake => 'Μάθετε από αυτό το λάθος';

  @override
  String get skipThisMove => 'Παραλείψτε αυτό το βήμα';

  @override
  String get next => 'Επόμενο';

  @override
  String xWasPlayed(String param) {
    return '$param παίχτηκε';
  }

  @override
  String get findBetterMoveForWhite => 'Βρείτε μια καλύτερη κίνηση για τα λευκά';

  @override
  String get findBetterMoveForBlack => 'Βρείτε μια καλύτερη κίνηση για τα μαύρα';

  @override
  String get resumeLearning => 'Συνεχίστε την μάθηση';

  @override
  String get youCanDoBetter => 'Μπορείτε και καλύτερα';

  @override
  String get tryAnotherMoveForWhite => 'Δοκιμάστε μια άλλη κίνηση για τα λευκά';

  @override
  String get tryAnotherMoveForBlack => 'Δοκιμάστε μια άλλη κίνηση για τα μαύρα';

  @override
  String get solution => 'Λύση';

  @override
  String get waitingForAnalysis => 'Αναμονή για την ανάλυση';

  @override
  String get noMistakesFoundForWhite => 'Δεν βρέθηκαν λάθη για τα λευκά';

  @override
  String get noMistakesFoundForBlack => 'Δεν βρέθηκαν λάθη για τα μαύρα';

  @override
  String get doneReviewingWhiteMistakes => 'Έγινε έλεγχος λαθών για τα λευκά';

  @override
  String get doneReviewingBlackMistakes => 'Έγινε έλεγχος λαθών για τα μαύρα';

  @override
  String get doItAgain => 'Κάντε το ξανά';

  @override
  String get reviewWhiteMistakes => 'Ανασκόπηση λαθών λευκών';

  @override
  String get reviewBlackMistakes => 'Ανασκόπηση λαθών μαύρων';

  @override
  String get advantage => 'Πλεονέκτημα';

  @override
  String get opening => 'Άνοιγμα';

  @override
  String get middlegame => 'Μέση φάση παιχνιδιού';

  @override
  String get endgame => 'Φινάλε';

  @override
  String get conditionalPremoves => 'Υποθετικές προκινήσεις';

  @override
  String get addCurrentVariation => 'Προσθέστε τρέχουσα παραλλαγή';

  @override
  String get playVariationToCreateConditionalPremoves => 'Παίξτε μια παραλλαγή για να δημιουργήσετε υποθετικές προκινήσεις';

  @override
  String get noConditionalPremoves => 'Καμία υποθετική προκίνηση';

  @override
  String playX(String param) {
    return 'Παίξτε $param';
  }

  @override
  String get showUnreadLichessMessage => 'Έχετε λάβει ένα προσωπικό μήνυμα από το Lichess.';

  @override
  String get clickHereToReadIt => 'Κάντε κλικ εδώ για να το δείτε';

  @override
  String get sorry => 'Λυπούμαστε :(';

  @override
  String get weHadToTimeYouOutForAWhile => 'Πρέπει να σας αποκλείσουμε για λίγο.';

  @override
  String get why => 'Γιατί;';

  @override
  String get pleasantChessExperience => 'Ο σκοπός μας είναι να προσφέρουμε μια ευχάριστη σκακιστική ατμόσφαιρα για όλους.';

  @override
  String get goodPractice => 'Για να πραγματοποιηθεί αυτό, πρέπει να βεβαιωθούμε ότι όλοι οι παίκτες ακολουθούν τους κανόνες.';

  @override
  String get potentialProblem => 'Όταν ανιχνευτεί ένα πιθανό πρόβλημα, εμφανίζεται αυτό το μήνυμα.';

  @override
  String get howToAvoidThis => 'Πώς να το αποφύγετε αυτό;';

  @override
  String get playEveryGame => 'Τελειώστε κάθε παρτίδα που ξεκινάτε.';

  @override
  String get tryToWin => 'Προσπαθήστε να νικήσετε (ή να φέρετε ισοπαλία) σε κάθε παιχνίδι που παίζετε.';

  @override
  String get resignLostGames => 'Παραιτηθείτε σε παιχνίδια που χάνετε (μην αφήνετε τον χρόνο σας να τελειώσει).';

  @override
  String get temporaryInconvenience => 'Συγχωρέστε μας για την προσωρινή δυσφορία,';

  @override
  String get wishYouGreatGames => 'και σας ευχόμαστε καλές παρτίδες στο lichess.org.';

  @override
  String get thankYouForReading => 'Ευχαριστούμε που αφιερώσατε χρόνο για να διαβάσετε το μήνυμα!';

  @override
  String get lifetimeScore => 'Συνολικό σκορ';

  @override
  String get currentMatchScore => 'Τρέχον σκορ';

  @override
  String get agreementAssistance => 'Αποδέχομαι ότι ουδέποτε θα λάβω βοήθεια κατά τις παρτίδες μου (από υπολογιστή, βιβλίο, βάση δεδομένων ή άλλο πρόσωπο).';

  @override
  String get agreementNice => 'Αποδέχομαι ότι πάντα θα επιδεικνύω σεβασμό προς όλους του παίκτες.';

  @override
  String agreementMultipleAccounts(String param) {
    return 'Συμφωνώ ότι δε θα δημιουργήσω πολλούς λογαριασμούς (εκτός από τους λόγους προβλέπονται από τους $param).';
  }

  @override
  String get agreementPolicy => 'Αποδέχομαι ότι θα συμμορφωθώ με όλες τις πολιτικές του Lichess.';

  @override
  String get searchOrStartNewDiscussion => 'Αναζήτηση ή έναρξη νέας συνομιλίας';

  @override
  String get edit => 'Επεξεργασία';

  @override
  String get bullet => 'Bullet';

  @override
  String get blitz => 'Blitz';

  @override
  String get rapid => 'Rapid';

  @override
  String get classical => 'Κλασικό';

  @override
  String get ultraBulletDesc => 'Εξαιρετικά γρήγορες παρτίδες: λιγότερο από 30 δεύτερα';

  @override
  String get bulletDesc => 'Πολύ γρήγορες παρτίδες: λιγότερο από 3 λεπτά';

  @override
  String get blitzDesc => 'Γρήγορες παρτίδες: 3 έως 8 λεπτά';

  @override
  String get rapidDesc => 'Παρτίδες rapid: 8 έως 25 λεπτά';

  @override
  String get classicalDesc => 'Κλασικές παρτίδες: 25 λεπτά και άνω';

  @override
  String get correspondenceDesc => 'Παρτίδες αλληλογραφίας: μία ή περισσότερες μέρες για την κίνηση';

  @override
  String get puzzleDesc => 'Εξάσκηση τακτικών';

  @override
  String get important => 'Σημαντικό';

  @override
  String yourQuestionMayHaveBeenAnswered(String param1) {
    return 'Η ερώτησή σας μπορεί να έχει απαντηθεί ήδη $param1';
  }

  @override
  String get inTheFAQ => 'στις συχνές ερωτήσεις.';

  @override
  String toReportSomeoneForCheatingOrBadBehavior(String param1) {
    return 'Για να αναφέρετε έναν χρήστη για κλέψιμο ή για κακή συμπεριφορά, $param1';
  }

  @override
  String get useTheReportForm => 'χρησιμοποιείστε τη φόρμα αναφορών';

  @override
  String toRequestSupport(String param1) {
    return 'Για να ζητήσετε βοήθεια, $param1';
  }

  @override
  String get tryTheContactPage => 'χρησιμοποιείστε την σελίδα επικοινωνίας';

  @override
  String makeSureToRead(String param1) {
    return 'Φροντίστε να διαβάσετε $param1';
  }

  @override
  String get theForumEtiquette => 'τους κανόνες καλής συμπεριφοράς του φόρουμ';

  @override
  String get thisTopicIsArchived => 'Αυτό το θέμα έχει αρχειοθετηθεί και δεν δέχεται απαντήσεις.';

  @override
  String joinTheTeamXToPost(String param1) {
    return 'Δηλώστε συμμετοχή στο $param1, για να κάνετε δημοσιεύσεις σε αυτό το φόρουμ';
  }

  @override
  String teamNamedX(String param1) {
    return '$param1 ομάδες';
  }

  @override
  String get youCannotPostYetPlaySomeGames => 'Δεν μπορείτε να δημοσιεύσετε σε αυτό το φόρουμ ακόμα. Παίξτε μερικά παιχνίδια!';

  @override
  String get subscribe => 'Εγγραφείτε';

  @override
  String get unsubscribe => 'Απεγγραφείτε';

  @override
  String mentionedYouInX(String param1) {
    return 'σας ανέφερε στο \"$param1\".';
  }

  @override
  String xMentionedYouInY(String param1, String param2) {
    return 'Ο χρήστης $param1 σας ανέφερε στο «$param2».';
  }

  @override
  String invitedYouToX(String param1) {
    return 'σας προσκάλεσε στο «$param1».';
  }

  @override
  String xInvitedYouToY(String param1, String param2) {
    return 'Ο χρήστης $param1 σας προσκάλεσε στο «$param2».';
  }

  @override
  String get youAreNowPartOfTeam => 'Είστε πλέον μέλος της ομάδας.';

  @override
  String youHaveJoinedTeamX(String param1) {
    return 'Είστε πλέον μέλος της ομάδας «$param1».';
  }

  @override
  String get someoneYouReportedWasBanned => 'Κάποιος που αναφέρατε έχει αποκλειστεί';

  @override
  String get congratsYouWon => 'Συγχαρητήρια, κερδίσατε!';

  @override
  String gameVsX(String param1) {
    return 'Παιχνίδι εναντίον $param1';
  }

  @override
  String resVsX(String param1, String param2) {
    return '$param1 εναντίον $param2';
  }

  @override
  String get lostAgainstTOSViolator => 'Χάσατε από κάποιον που παραβίασε τους όρους χρήσης του Lichess';

  @override
  String refundXpointsTimeControlY(String param1, String param2) {
    return 'Επιστροφή πόντων: $param1 $param2 πόντοι βαθμολογίας.';
  }

  @override
  String get timeAlmostUp => 'Ο χρόνος σας έχει σχεδόν τελειώσει!';

  @override
  String get clickToRevealEmailAddress => '[Κάντε κλικ για να δείτε τη διεύθυνση ηλεκτρονικού ταχυδρομείου]';

  @override
  String get download => 'Λήψη';

  @override
  String get coachManager => 'Διαχειριστής προπονητή';

  @override
  String get streamerManager => 'Διαχειριστής streamer';

  @override
  String get cancelTournament => 'Ακύρωση τουρνουά';

  @override
  String get tournDescription => 'Περιγραφή του τουρνουά';

  @override
  String get tournDescriptionHelp => 'Θέλετε να πείτε κάτι ιδιαίτερο στους παίκτες; Προσπαθήστε να κρατήσετε το μήνυμά σας σύντομο. Μπορείτε να χρησιμοποιείτε συνδέσμους σε Markdown: [name](https://url)';

  @override
  String get ratedFormHelp => 'Τα παιχνίδια αξιολογούνται\nκαι επηρεάζουν τη βαθμολογία των παιχτών';

  @override
  String get onlyMembersOfTeam => 'Μόνο μέλη της ομάδας';

  @override
  String get noRestriction => 'Χωρίς περιορισμούς';

  @override
  String get minimumRatedGames => 'Ελάχιστος αριθμός βαθμολογημένων παιχνιδιών';

  @override
  String get minimumRating => 'Ελάχιστη βαθμολογία';

  @override
  String get maximumWeeklyRating => 'Μέγιστη εβδομαδιαία βαθμολογία';

  @override
  String positionInputHelp(String param) {
    return 'Επικολλήστε ένα έγκυρο FEN για να ξεκινήσει κάθε παιχνίδι από μια συγκεκριμένη θέση.\nΛειτουργεί μόνο για κανονικά παιχνίδια, όχι για παραλλαγές.\nΜπορείτε να χρησιμοποιήσετε τον $param για να πάρετε το FEN μιας θέσης, και στη συνέχεια να την επικολλήστε το εδώ.\nΜπορείτε να αφήσετε το πλαίσιο κενό για να ξεκινούν οι παρτίδες από την κανονική αρχική θέση.';
  }

  @override
  String get cancelSimul => 'Ακύρωση σιμουλτανέ';

  @override
  String get simulHostcolor => 'Χρώμα διοργανωτή σε κάθε παιχνίδι';

  @override
  String get estimatedStart => 'Εκτιμώμενη ώρα έναρξης';

  @override
  String simulFeatured(String param) {
    return 'Προβεβλημένο στο $param';
  }

  @override
  String simulFeaturedHelp(String param) {
    return 'Να εμφανίζεται το σιμουλτανέ σε όλους στο $param. Απενεργοποιήστε αυτήν την επιλογή για ιδιωτικά σιμουλτανέ.';
  }

  @override
  String get simulDescription => 'Περιγραφή σιμουλτανέ';

  @override
  String get simulDescriptionHelp => 'Θέλετε να πείτε κάτι στους συμμετέχοντες;';

  @override
  String markdownAvailable(String param) {
    return 'Η μορφή $param είναι διαθέσιμη για μια πιο προχωρημένη σύνταξη.';
  }

  @override
  String get embedsAvailable => 'Επικολλήστε μια διεύθυνση URL παιχνιδιού ή ένα κεφάλαιο μελέτης για να το ενσωματώσετε.';

  @override
  String get inYourLocalTimezone => 'Στη δική σας ζώνη ώρας';

  @override
  String get tournChat => 'Δωμάτιο συνομιλίας τουρνουά';

  @override
  String get noChat => 'Να μην επιτρέπεται η συνομιλία';

  @override
  String get onlyTeamLeaders => 'Μόνο οι αρχηγοί ομάδων';

  @override
  String get onlyTeamMembers => 'Μόνο τα μέλη της ομάδας';

  @override
  String get navigateMoveTree => 'Πλοηγηθείτε στο δέντρο κινήσεων';

  @override
  String get mouseTricks => '«Κόλπα» με το ποντίκι';

  @override
  String get toggleLocalAnalysis => 'Εναλλαγή ανάλυσης τοπικού υπολογιστή';

  @override
  String get toggleAllAnalysis => 'Εναλλαγή όλων των αναλύσεων υπολογιστή';

  @override
  String get playComputerMove => 'Παίξτε την καλύτερη κίνηση που προτείνει ο υπολογιστής';

  @override
  String get analysisOptions => 'Ρυθμίσεις ανάλυσης';

  @override
  String get focusChat => 'Εστίαση στο chat';

  @override
  String get showHelpDialog => 'Εμφάνιση αυτού του παραθύρου διαλόγου βοήθειας';

  @override
  String get reopenYourAccount => 'Ξανανοίξτε τον λογαριασμό σας';

  @override
  String get reopenYourAccountDescription => 'Αν κλείσατε τον λογαριασμό σας, αλλά έκτοτε έχετε αλλάξει γνώμη, έχετε την δυνατότητα να ανακτήσετε τον λογαριασμό σας.';

  @override
  String get emailAssociatedToaccount => 'Διεύθυνση ηλεκτρονικού ταχυδρομείου αυτού του λογαριασμού';

  @override
  String get sentEmailWithLink => 'Σας στείλαμε ένα email με τον σύνδεσμο.';

  @override
  String get tournamentEntryCode => 'Κωδικός εισόδου τουρνουά';

  @override
  String get hangOn => 'Περιμένετε!';

  @override
  String gameInProgress(String param) {
    return 'Έχετε μία παρτίδα σε εξέλιξη με τον/την $param.';
  }

  @override
  String get abortTheGame => 'Διακόψτε το παιχνίδι';

  @override
  String get resignTheGame => 'Εγκαταλείψτε το παιχνίδι';

  @override
  String get youCantStartNewGame => 'Δεν μπορείτε να ξεκινήσετε μια καινούργια παρτίδα εάν δεν ολοκληρωθεί αυτή.';

  @override
  String get since => 'Από';

  @override
  String get until => 'Έως';

  @override
  String get lichessDbExplanation => 'Δείγμα βαθμολογημένων παιχνιδιών από όλους του παίκτες στο Lichess';

  @override
  String get switchSides => 'Εναλλαγή πλευρών';

  @override
  String get closingAccountWithdrawAppeal => 'Αν απενεργοποιήσετε τον λογαριασμό σας θα χάσετε το δικαίωμα έφεσης';

  @override
  String get ourEventTips => 'Οι συμβουλές μας για τη διοργάνωση εκδηλώσεων';

  @override
  String get instructions => 'Οδηγίες';

  @override
  String get showMeEverything => 'Εμφάνιση όλων';

  @override
  String get lichessPatronInfo => 'Το Lichess είναι ένα φιλανθρωπικό και εντελώς ελεύθερο λογισμικό ανοιχτού κώδικα.\nΌλα τα εξοδα λειτουργίας, ανάπτυξης και περιεχομένου καλύπτοναι αποκλειστικά από δωρεές χρηστών.';

  @override
  String get nothingToSeeHere => 'Τίποτα για να δείτε εδώ αυτή τη στιγμή.';

  @override
  String get stats => 'Στατιστικά';

  @override
  String opponentLeftCounter(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Ο αντίπαλος έφυγε από το παιχνίδι. Διεκδίκηση νίκης σε $count δευτερόλεπτα.',
      one: 'Ο αντίπαλός σας έφυγε από το παιχνίδι. Διεκδίκηση νίκης σε $count δευτερόλεπτο.',
    );
    return '$_temp0';
  }

  @override
  String mateInXHalfMoves(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Ματ σε $count μισές κινήσεις',
      one: 'Ματ σε $count μισή κίνηση',
    );
    return '$_temp0';
  }

  @override
  String nbBlunders(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count σοβαρά σφάλματα',
      one: '$count σοβαρό σφάλμα',
    );
    return '$_temp0';
  }

  @override
  String numberBlunders(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Σοβαρά σφάλματα',
      one: '$count Σοβαρό σφάλμα',
    );
    return '$_temp0';
  }

  @override
  String nbMistakes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count λάθη',
      one: '$count λάθος',
    );
    return '$_temp0';
  }

  @override
  String numberMistakes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Λάθη',
      one: '$count Λάθος',
    );
    return '$_temp0';
  }

  @override
  String nbInaccuracies(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ανακρίβειες',
      one: '$count ανακρίβεια',
    );
    return '$_temp0';
  }

  @override
  String numberInaccuracies(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Ανακρίβειες',
      one: '$count Ανακρίβεια',
    );
    return '$_temp0';
  }

  @override
  String nbPlayers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count παίκτες',
      one: '$count παίκτης',
    );
    return '$_temp0';
  }

  @override
  String nbGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count παιχνίδια',
      one: '$count παιχνίδι',
    );
    return '$_temp0';
  }

  @override
  String ratingXOverYGames(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Βαθμολογία $count για $param2 παιχνίδια',
      one: 'Βαθμολογία $count για $param2 παιχνίδι',
    );
    return '$_temp0';
  }

  @override
  String nbBookmarks(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count σελιδοδείκτες',
      one: '$count σελιδοδείκτης',
    );
    return '$_temp0';
  }

  @override
  String nbDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ημέρες',
      one: '$count ημέρα',
    );
    return '$_temp0';
  }

  @override
  String nbHours(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ώρες',
      one: '$count ώρα',
    );
    return '$_temp0';
  }

  @override
  String nbMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count λεπτά',
      one: '$count λεπτό',
    );
    return '$_temp0';
  }

  @override
  String rankIsUpdatedEveryNbMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Η κατάταξη ενημερώνεται κάθε $count λεπτά',
      one: 'Η κατάταξη ενημερώνεται κάθε λεπτό',
    );
    return '$_temp0';
  }

  @override
  String nbPuzzles(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count γρίφοι',
      one: '$count γρίφος',
    );
    return '$_temp0';
  }

  @override
  String nbGamesWithYou(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count παιχνίδια με εσάς',
      one: '$count παιχνίδι με εσάς',
    );
    return '$_temp0';
  }

  @override
  String nbRated(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count βαθμολογημένα',
      one: '$count βαθμολογημένο',
    );
    return '$_temp0';
  }

  @override
  String nbWins(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count νίκες',
      one: '$count νίκη',
    );
    return '$_temp0';
  }

  @override
  String nbLosses(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ήττες',
      one: '$count ήττα',
    );
    return '$_temp0';
  }

  @override
  String nbDraws(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ισοπαλίες',
      one: '$count ισοπαλία',
    );
    return '$_temp0';
  }

  @override
  String nbPlaying(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count παίζονται',
      one: '$count παίζεται',
    );
    return '$_temp0';
  }

  @override
  String giveNbSeconds(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Προσθέστε $count δευτερόλεπτα',
      one: 'Προσθέστε $count δευτερόλεπτα',
    );
    return '$_temp0';
  }

  @override
  String nbTournamentPoints(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count πόντοι τουρνουά',
      one: '$count πόντος τουρνουά',
    );
    return '$_temp0';
  }

  @override
  String nbStudies(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count μελέτες',
      one: '$count μελέτη',
    );
    return '$_temp0';
  }

  @override
  String nbSimuls(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count σιμουλτανέ',
      one: '$count σιμουλτανέ',
    );
    return '$_temp0';
  }

  @override
  String moreThanNbRatedGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '≥ $count βαθμολογημένα παιχνίδια',
      one: '≥ $count βαθμολογημένο παιχνίδι',
    );
    return '$_temp0';
  }

  @override
  String moreThanNbPerfRatedGames(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '≥ $count βαθμολογημένα παιχνίδια $param2',
      one: '≥ $count βαθμολογημένο παιχνίδι $param2',
    );
    return '$_temp0';
  }

  @override
  String needNbMorePerfGames(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Πρέπει να παίξετε $count επιπλέον $param2 βαθμολογημένα παιχνίδια',
      one: 'Πρέπει να παίξετε $count επιπλέον $param2 βαθμολογημένο παιχνίδι',
    );
    return '$_temp0';
  }

  @override
  String needNbMoreGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Πρέπει να παίξετε $count βαθμολογημένα παιχνίδια',
      one: 'Πρέπει να παίξετε $count βαθμολογημένο παιχνίδι',
    );
    return '$_temp0';
  }

  @override
  String nbImportedGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Εισαγόμενα παιχνίδια',
      one: '$count Εισαγόμενο παιχνίδι',
    );
    return '$_temp0';
  }

  @override
  String nbFriendsOnline(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count φίλοι συνδεδεμένοι',
      one: '$count φίλος συνδεδεμένος',
    );
    return '$_temp0';
  }

  @override
  String nbFollowers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ακόλουθοι',
      one: '$count ακόλουθος',
    );
    return '$_temp0';
  }

  @override
  String nbFollowing(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ακολουθούνται',
      one: '$count ακολουθείται',
    );
    return '$_temp0';
  }

  @override
  String lessThanNbMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Λιγότερο από $count λεπτά',
      one: 'Λιγότερο από $count λεπτό',
    );
    return '$_temp0';
  }

  @override
  String nbGamesInPlay(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count παιχνίδια παίζονται τώρα',
      one: '$count παιχνίδι παίζεται τώρα',
    );
    return '$_temp0';
  }

  @override
  String maximumNbCharacters(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Όριο: $count χαρακτήρες.',
      one: 'Όριο: $count χαρακτήρες.',
    );
    return '$_temp0';
  }

  @override
  String blocks(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count αποκλεισμοί',
      one: '$count αποκλεισμός',
    );
    return '$_temp0';
  }

  @override
  String nbForumPosts(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count δημοσιεύσεις φόρουμ',
      one: '$count δημοσίευση φόρουμ',
    );
    return '$_temp0';
  }

  @override
  String nbPerfTypePlayersThisWeek(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count παίκτες $param2 αυτήν την εβδομάδα.',
      one: '$count παίκτης $param2 αυτήν την εβδομάδα.',
    );
    return '$_temp0';
  }

  @override
  String availableInNbLanguages(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Διαθέσιμο σε $count γλώσσες!',
      one: 'Διαθέσιμο σε $count γλώσσες!',
    );
    return '$_temp0';
  }

  @override
  String nbSecondsToPlayTheFirstMove(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count δευτερόλεπτα για την πρώτη κίνηση',
      one: '$count δευτερόλεπτο για την πρώτη κίνηση',
    );
    return '$_temp0';
  }

  @override
  String nbSeconds(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count δευτερόλεπτα',
      one: '$count δευτερόλεπτο',
    );
    return '$_temp0';
  }

  @override
  String andSaveNbPremoveLines(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'και αποθηκεύστε $count γραμμές προκίνησης',
      one: 'και αποθηκεύστε $count γραμμή προκίνησης',
    );
    return '$_temp0';
  }

  @override
  String get stormMoveToStart => 'Μετακινήστε ένα κομμάτι για να αρχίσετε';

  @override
  String get stormYouPlayTheWhitePiecesInAllPuzzles => 'Παίζετε με τα λευκά σε όλους τους γρίφους';

  @override
  String get stormYouPlayTheBlackPiecesInAllPuzzles => 'Παίζετε με τα μαύρα σε όλους τους γρίφους';

  @override
  String get stormPuzzlesSolved => 'λυμένοι γρίφοι';

  @override
  String get stormNewDailyHighscore => 'Νέο ημερήσιο ρεκόρ!';

  @override
  String get stormNewWeeklyHighscore => 'Νέο εβδομαδιαίο ρεκόρ!';

  @override
  String get stormNewMonthlyHighscore => 'Νέο μηνιαίο ρεκόρ!';

  @override
  String get stormNewAllTimeHighscore => 'Νέο ρεκόρ όλων των εποχών!';

  @override
  String stormPreviousHighscoreWasX(String param) {
    return 'Το προηγούμενο ρεκόρ ήταν $param';
  }

  @override
  String get stormPlayAgain => 'Παίξτε ξανά';

  @override
  String stormHighscoreX(String param) {
    return 'Ρεκόρ: $param';
  }

  @override
  String get stormScore => 'Βαθμολογία';

  @override
  String get stormMoves => 'Κινήσεις';

  @override
  String get stormAccuracy => 'Ακρίβεια';

  @override
  String get stormCombo => 'Combo';

  @override
  String get stormTime => 'Χρόνος';

  @override
  String get stormTimePerMove => 'Χρόνος ανά κίνηση';

  @override
  String get stormHighestSolved => 'Υψηλότερο επιλυμένο';

  @override
  String get stormPuzzlesPlayed => 'Παιγμένοι γρίφοι';

  @override
  String get stormNewRun => 'Νέος γύρος (πλήκτρο: Space)';

  @override
  String get stormEndRun => 'Τερματισμός γύρου (πλήκτρο: Enter)';

  @override
  String get stormHighscores => 'Υψηλότερα σκορ';

  @override
  String get stormViewBestRuns => 'Προβολή καλύτερων γύρων';

  @override
  String get stormBestRunOfDay => 'Καλύτερος γύρος της ημέρας';

  @override
  String get stormRuns => 'Γύροι';

  @override
  String get stormGetReady => 'Ετοιμαστείτε!';

  @override
  String get stormWaitingForMorePlayers => 'Αναμονή για περισσότερους παίκτες...';

  @override
  String get stormRaceComplete => 'Ο αγώνας ολοκληρώθηκε!';

  @override
  String get stormSpectating => 'Παρακολούθηση';

  @override
  String get stormJoinTheRace => 'Λάβετε μέρος στον αγώνα!';

  @override
  String get stormStartTheRace => 'Εκκίνηση αγώνα';

  @override
  String stormYourRankX(String param) {
    return 'Κατάταξη: $param';
  }

  @override
  String get stormWaitForRematch => 'Αναμονή για ρεβάνς';

  @override
  String get stormNextRace => 'Επόμενος αγώνας';

  @override
  String get stormJoinRematch => 'Συμμετοχή στη ρεβάνς';

  @override
  String get stormWaitingToStart => 'Αναμονή για έναρξη';

  @override
  String get stormCreateNewGame => 'Νέο παιχνίδι';

  @override
  String get stormJoinPublicRace => 'Συμμετοχή σε δημόσιο αγώνα';

  @override
  String get stormRaceYourFriends => 'Συμμετοχή σε αγώνα με φίλους';

  @override
  String get stormSkip => 'παράλειψη';

  @override
  String get stormSkipHelp => 'Μπορείτε να παραλείψετε μία κίνηση σε κάθε αγώνα:';

  @override
  String get stormSkipExplanation => 'Παραλείψτε αυτή την κίνηση για να διατηρήσετε το combo σας! Αυτό μπορείτε να το κάνετε μόνο μία φορά σε κάθε αγώνα.';

  @override
  String get stormFailedPuzzles => 'Γρίφοι που δε λύθηκαν σωστά';

  @override
  String get stormSlowPuzzles => 'Γρίφοι που λύθηκαν αργά';

  @override
  String get stormSkippedPuzzle => 'Γρίφος με κίνηση που παραλείφθηκε';

  @override
  String get stormThisWeek => 'Αυτήν την εβδομάδα';

  @override
  String get stormThisMonth => 'Aυτόν τον μήνα';

  @override
  String get stormAllTime => 'Από την αρχή';

  @override
  String get stormClickToReload => 'Κάντε κλικ για να ανανεώσετε τη σελίδα';

  @override
  String get stormThisRunHasExpired => 'Αυτός ο γύρος έχει τελειώσει!';

  @override
  String get stormThisRunWasOpenedInAnotherTab => 'Αυτός ο γύρος είναι ανοιχτός σε άλλη καρτέλα!';

  @override
  String stormXRuns(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count γύροι',
      one: '1 γύρος',
    );
    return '$_temp0';
  }

  @override
  String stormPlayedNbRunsOfPuzzleStorm(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Έπαιξε $count γύρους $param2',
      one: 'Έπαιξε έναν γύρο $param2',
    );
    return '$_temp0';
  }

  @override
  String get streamerLichessStreamers => 'Lichess streamers';

  @override
  String get studyPrivate => 'Ιδιωτικό';

  @override
  String get studyMyStudies => 'Οι μελέτες μου';

  @override
  String get studyStudiesIContributeTo => 'Μελέτες που συνεισφέρω';

  @override
  String get studyMyPublicStudies => 'Οι δημόσιες μελέτες μου';

  @override
  String get studyMyPrivateStudies => 'Οι ιδιωτικές μελέτες μου';

  @override
  String get studyMyFavoriteStudies => 'Οι αγαπημένες μελέτες μου';

  @override
  String get studyWhatAreStudies => 'Τι είναι οι μελέτες;';

  @override
  String get studyAllStudies => 'Όλες οι μελέτες';

  @override
  String studyStudiesCreatedByX(String param) {
    return 'Μελέτες που δημιουργήθηκαν από τον/την $param';
  }

  @override
  String get studyNoneYet => 'Τίποτα ακόμη εδώ.';

  @override
  String get studyHot => 'Δημοφιλείς (hot)';

  @override
  String get studyDateAddedNewest => 'Ημερομηνία προσθήκης (νεότερες)';

  @override
  String get studyDateAddedOldest => 'Ημερομηνία προσθήκης (παλαιότερες)';

  @override
  String get studyRecentlyUpdated => 'Πρόσφατα ενημερωμένες';

  @override
  String get studyMostPopular => 'Οι πιο δημοφιλείς';

  @override
  String get studyAlphabetical => 'Αλφαβητικά';

  @override
  String get studyAddNewChapter => 'Προσθήκη νέου κεφαλαίου';

  @override
  String get studyAddMembers => 'Προσθήκη μελών';

  @override
  String get studyInviteToTheStudy => 'Προσκάλεσε στην μελέτη';

  @override
  String get studyPleaseOnlyInvitePeopleYouKnow => 'Παρακαλώ, προσκαλέστε μόνο άτομα που γνωρίζετε και που θέλουν να συμμετέχουν ενεργά σε αυτήν την μελέτη.';

  @override
  String get studySearchByUsername => 'Αναζήτηση με όνομα χρήστη';

  @override
  String get studySpectator => 'Θεατής';

  @override
  String get studyContributor => 'Συνεισφέρων';

  @override
  String get studyKick => 'Αποβολή';

  @override
  String get studyLeaveTheStudy => 'Αποχώρησε από αυτήν την μελέτη';

  @override
  String get studyYouAreNowAContributor => 'Μπορείτε τώρα να συνεισφέρετε στην μελέτη';

  @override
  String get studyYouAreNowASpectator => 'Είστε πλέον θεατής';

  @override
  String get studyPgnTags => 'PGN ετικέτες';

  @override
  String get studyLike => 'Μου αρέσει';

  @override
  String get studyUnlike => 'Δε μου αρέσει';

  @override
  String get studyNewTag => 'Νέα ετικέτα';

  @override
  String get studyCommentThisPosition => 'Σχολίασε την υπάρχουσα θέση';

  @override
  String get studyCommentThisMove => 'Σχολίασε αυτήν την κίνηση';

  @override
  String get studyAnnotateWithGlyphs => 'Σχολιασμός με σύμβολα';

  @override
  String get studyTheChapterIsTooShortToBeAnalysed => 'Το κεφάλαιο είναι πολύ μικρό για να αναλυθεί.';

  @override
  String get studyOnlyContributorsCanRequestAnalysis => 'Μόνο αυτοί που συνεισφέρουν στην σπουδή μπορούν να ζητήσουν ανάλυση από υπολογιστή.';

  @override
  String get studyGetAFullComputerAnalysis => 'Αίτηση πλήρης ανάλυσης της κύριας γραμμής παρτίδας από μηχανή του σέρβερ.';

  @override
  String get studyMakeSureTheChapterIsComplete => 'Σιγουρευτείτε ότι το κεφάλαιο είναι ολοκληρωμένο. Μπορείτε να ζητήσετε ανάλυση μόνο μια φορά.';

  @override
  String get studyAllSyncMembersRemainOnTheSamePosition => 'Όλα τα συγχρονισμένα μέλη παραμένουν στην ίδια θέση';

  @override
  String get studyShareChanges => 'Διαμοιρασμός στους θεατές των αλλαγών και αποθήκευση τους στο σέρβερ';

  @override
  String get studyPlaying => 'Παίζονται';

  @override
  String get studyShowResults => 'Αποτελέσματα';

  @override
  String get studyShowEvalBar => 'Μπάρες αξιολόγησης';

  @override
  String get studyNext => 'Επόμενη';

  @override
  String get studyShareAndExport => 'Διαμοιρασμός & εξαγωγή';

  @override
  String get studyCloneStudy => 'Κλωνοποίησε';

  @override
  String get studyStudyPgn => 'PGN της μελέτης';

  @override
  String get studyDownloadAllGames => 'Λήψη όλων των παιχνιδιών';

  @override
  String get studyChapterPgn => 'PGN του κεφαλαίου';

  @override
  String get studyCopyChapterPgn => 'Αντιγραφή PGN';

  @override
  String get studyDownloadGame => 'Λήψη παιχνιδιού';

  @override
  String get studyStudyUrl => 'URL μελέτης';

  @override
  String get studyCurrentChapterUrl => 'Τρέχον κεφάλαιο URL';

  @override
  String get studyYouCanPasteThisInTheForumToEmbed => 'Επικολλήστε το παρόν για ενσωμάτωση στο φόρουμ';

  @override
  String get studyStartAtInitialPosition => 'Ξεκινάει από αρχική θέση';

  @override
  String studyStartAtX(String param) {
    return 'Ξεκινάει με $param';
  }

  @override
  String get studyEmbedInYourWebsite => 'Ενσωματώστε στην ιστοσελίδα σας ή το μπλογκ σας';

  @override
  String get studyReadMoreAboutEmbedding => 'Διαβάστε περισσότερα για την ενσωμάτωση';

  @override
  String get studyOnlyPublicStudiesCanBeEmbedded => 'Μόνο δημόσιες μελέτες μπορούν να ενσωματωθούν!';

  @override
  String get studyOpen => 'Άνοιξε';

  @override
  String studyXBroughtToYouByY(String param1, String param2) {
    return '$param1, δημιουργήθηκε από $param2';
  }

  @override
  String get studyStudyNotFound => 'Η μελέτη δεν βρέθηκε';

  @override
  String get studyEditChapter => 'Επεξεργάσου το κεφάλαιο';

  @override
  String get studyNewChapter => 'Νέο κεφάλαιο';

  @override
  String studyImportFromChapterX(String param) {
    return 'Εισαγωγή από $param';
  }

  @override
  String get studyOrientation => 'Προσανατολισμός';

  @override
  String get studyAnalysisMode => 'Τύπος ανάλυσης';

  @override
  String get studyPinnedChapterComment => 'Καρφιτσωμένο σχόλιο κεφαλαίου';

  @override
  String get studySaveChapter => 'Αποθήκευση κεφαλαίου';

  @override
  String get studyClearAnnotations => 'Διαγραφή σχολιασμών';

  @override
  String get studyClearVariations => 'Εκκαθάριση βαριάντων';

  @override
  String get studyDeleteChapter => 'Διαγραφή κεφαλαίου';

  @override
  String get studyDeleteThisChapter => 'Διαγραφή κεφαλαίου; Μη αναιρέσιμη ενέργεια!';

  @override
  String get studyClearAllCommentsInThisChapter => 'Καθαρισμός όλων των σχολίων, συμβόλων και σχεδίων στο τρέχον κεφάλαιο;';

  @override
  String get studyRightUnderTheBoard => 'Κάτω από την σκακιέρα';

  @override
  String get studyNoPinnedComment => 'Καμία';

  @override
  String get studyNormalAnalysis => 'Απλή ανάλυση';

  @override
  String get studyHideNextMoves => 'Απόκρυψη επόμενων κινήσεων';

  @override
  String get studyInteractiveLesson => 'Διαδραστικό μάθημα';

  @override
  String studyChapterX(String param) {
    return 'Κεφάλαιο $param';
  }

  @override
  String get studyEmpty => 'Κενή';

  @override
  String get studyStartFromInitialPosition => 'Έναρξη από τρέχουσα θέση';

  @override
  String get studyEditor => 'Επεξεργαστής';

  @override
  String get studyStartFromCustomPosition => 'Έναρξη από τρέχουσα θέση';

  @override
  String get studyLoadAGameByUrl => 'Φόρτωση παρτίδας με URL';

  @override
  String get studyLoadAPositionFromFen => 'Φόρτωση θέσης από FEN';

  @override
  String get studyLoadAGameFromPgn => 'Φόρτωσε μια παρτίδα από PGN';

  @override
  String get studyAutomatic => 'Αυτόματο';

  @override
  String get studyUrlOfTheGame => 'URL παρτίδων, ένα ανά γραμμή';

  @override
  String studyLoadAGameFromXOrY(String param1, String param2) {
    return 'Φόρτωση παρτίδων από $param1 ή $param2';
  }

  @override
  String get studyCreateChapter => 'Δημιουργία κεφαλαίου';

  @override
  String get studyCreateStudy => 'Δημιουργία μελέτης';

  @override
  String get studyEditStudy => 'Επεξεργασία μελέτης';

  @override
  String get studyVisibility => 'Ορατότητα';

  @override
  String get studyPublic => 'Δημόσια';

  @override
  String get studyUnlisted => 'Ακαταχώρητη';

  @override
  String get studyInviteOnly => 'Με πρόσκληση';

  @override
  String get studyAllowCloning => 'Επέτρεψε αντιγραφή';

  @override
  String get studyNobody => 'Κανένας';

  @override
  String get studyOnlyMe => 'Μόνο εγώ';

  @override
  String get studyContributors => 'Συνεισφέροντες';

  @override
  String get studyMembers => 'Μέλη';

  @override
  String get studyEveryone => 'Οποιοσδήποτε';

  @override
  String get studyEnableSync => 'Ενεργοποίηση συγχρονισμού';

  @override
  String get studyYesKeepEveryoneOnTheSamePosition => 'Ναι: όλοι βλέπουν την ίδια θέση';

  @override
  String get studyNoLetPeopleBrowseFreely => 'Όχι: ελεύθερη επιλογή θέσης';

  @override
  String get studyPinnedStudyComment => 'Καρφιτσωμένο σχόλιο μελέτης';

  @override
  String get studyStart => 'Δημιουργία';

  @override
  String get studySave => 'Αποθήκευση';

  @override
  String get studyClearChat => 'Εκκαθάριση συνομιλίας';

  @override
  String get studyDeleteTheStudyChatHistory => 'Διαγραφή συνομιλίας μελέτης; Μη αναιρέσιμη ενέργεια!';

  @override
  String get studyDeleteStudy => 'Διαγραφή μελέτης';

  @override
  String studyConfirmDeleteStudy(String param) {
    return 'Να διαγραφεί όλη η μελέτη; Η ενέργεια αυτή δεν μπορεί να αναιρεθεί! Πληκτρολογήστε το όνομα της μελέτης για επιβεβαίωση: $param';
  }

  @override
  String get studyWhereDoYouWantToStudyThat => 'Που θέλετε να δημιουργήσετε την μελέτη;';

  @override
  String get studyGoodMove => 'Καλή κίνηση';

  @override
  String get studyMistake => 'Λάθος';

  @override
  String get studyBrilliantMove => 'Εξαιρετική κίνηση';

  @override
  String get studyBlunder => 'Σοβαρό λάθος';

  @override
  String get studyInterestingMove => 'Ενδιαφέρουσα κίνηση';

  @override
  String get studyDubiousMove => 'Κίνηση αμφίβολης αξίας';

  @override
  String get studyOnlyMove => 'Μοναδική κίνηση';

  @override
  String get studyZugzwang => 'Τσούγκσβανγκ';

  @override
  String get studyEqualPosition => 'Ισόπαλη θέση';

  @override
  String get studyUnclearPosition => 'Ασαφής θέση';

  @override
  String get studyWhiteIsSlightlyBetter => 'Το λευκά είναι ελαφρώς καλύτερα';

  @override
  String get studyBlackIsSlightlyBetter => 'Το μαύρα είναι ελαφρώς καλύτερα';

  @override
  String get studyWhiteIsBetter => 'Τα λευκά είναι καλύτερα';

  @override
  String get studyBlackIsBetter => 'Τα μαύρα είναι καλύτερα';

  @override
  String get studyWhiteIsWinning => 'Τα λευκά κερδίζουν';

  @override
  String get studyBlackIsWinning => 'Τα μαύρα κερδίζουν';

  @override
  String get studyNovelty => 'Novelty';

  @override
  String get studyDevelopment => 'Ανάπτυξη';

  @override
  String get studyInitiative => 'Πρωτοβουλία';

  @override
  String get studyAttack => 'Επίθεση';

  @override
  String get studyCounterplay => 'Αντεπίθεση';

  @override
  String get studyTimeTrouble => 'Πίεση χρόνου';

  @override
  String get studyWithCompensation => 'Με αντάλλαγμα';

  @override
  String get studyWithTheIdea => 'Με ιδέα';

  @override
  String get studyNextChapter => 'Επόμενο κεφάλαιο';

  @override
  String get studyPrevChapter => 'Προηγούμενο κεφάλαιο';

  @override
  String get studyStudyActions => 'Ρυθμίσεις μελέτης';

  @override
  String get studyTopics => 'Θέματα';

  @override
  String get studyMyTopics => 'Τα θέματά μου';

  @override
  String get studyPopularTopics => 'Δημοφιλή θέματα';

  @override
  String get studyManageTopics => 'Διαχείριση θεμάτων';

  @override
  String get studyBack => 'Πίσω';

  @override
  String get studyPlayAgain => 'Παίξτε ξανά';

  @override
  String get studyWhatWouldYouPlay => 'Τι θα παίζατε σε αυτή τη θέση;';

  @override
  String get studyYouCompletedThisLesson => 'Συγχαρητήρια! Ολοκληρώσατε αυτό το μάθημα.';

  @override
  String studyPerPage(String param) {
    return '$param ανά σελίδα';
  }

  @override
  String get studyGetTheTour => 'Need help? Get the tour!';

  @override
  String get studyWelcomeToLichessStudyTitle => 'Welcome to Lichess Study!';

  @override
  String get studyWelcomeToLichessStudyText => 'This is a shared analysis board.<br><br>Use it to analyse and annotate games,<br>discuss positions with friends,<br>and of course for chess lessons!<br><br>It\'s a powerful tool, let\'s take some time to see how it works.';

  @override
  String get studySharedAndSaveTitle => 'Shared and saved';

  @override
  String get studySharedAndSavedText => 'Other members can see your moves in real time!<br>Plus, everything is saved forever.';

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
  String get studyStudyChaptersText => 'A study can contain several chapters.<br>Each chapter has a distinct initial position and move tree.';

  @override
  String get studyCommentPositionTitle => 'Comment on a position';

  @override
  String studyCommentPositionText(String param) {
    return 'Click the $param button, or right click on the move list on the right.<br>Comments are shared and saved.';
  }

  @override
  String get studyAnnotatePositionTitle => 'Annotate a position';

  @override
  String get studyAnnotatePositionText => 'Click the !? button, or a right click on the move list on the right.<br>Annotation glyphs are shared and saved.';

  @override
  String get studyConclusionTitle => 'Thanks for your time';

  @override
  String get studyConclusionText => 'You can find your <a href=\'/study/mine/hot\'>previous studies</a> from your profile page.<br>There is also a <a href=\'//lichess.org/blog/V0KrLSkAAMo3hsi4/study-chess-the-lichess-way\'>blog post about studies</a>.<br>Power users might want to press \"?\" to see keyboard shortcuts.<br>Have fun!';

  @override
  String get studyCreateChapterTitle => 'Let\'s create a study chapter';

  @override
  String get studyCreateChapterText => 'A study can have several chapters.<br>Each chapter has a distinct move tree,<br>and can be created in various ways.';

  @override
  String get studyFromInitialPositionTitle => 'From initial position';

  @override
  String get studyFromInitialPositionText => 'Just a board setup for a new game.<br>Suited to explore openings.';

  @override
  String get studyCustomPositionTitle => 'Custom position';

  @override
  String get studyCustomPositionText => 'Setup the board your way.<br>Suited to explore endgames.';

  @override
  String get studyLoadExistingLichessGameTitle => 'Load an existing lichess game';

  @override
  String get studyLoadExistingLichessGameText => 'Paste a lichess game URL<br>(like lichess.org/7fHIU0XI)<br>to load the game moves in the chapter.';

  @override
  String get studyFromFenStringTitle => 'From a FEN string';

  @override
  String get studyFromFenStringText => 'Paste a position in FEN format<br><i>4k3/4rb2/8/7p/8/5Q2/1PP5/1K6 w</i><br>to start the chapter from a position.';

  @override
  String get studyFromPgnGameTitle => 'From a PGN game';

  @override
  String get studyFromPgnGameText => 'Paste a game in PGN format.<br>to load moves, comments and variations in the chapter.';

  @override
  String get studyVariantsAreSupportedTitle => 'Studies support variants';

  @override
  String get studyVariantsAreSupportedText => 'Yes, you can study crazyhouse<br>and all lichess variants!';

  @override
  String get studyChapterConclusionText => 'Chapters are saved forever.<br>Have fun organizing your chess content!';

  @override
  String studyNbChapters(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Κεφάλαια',
      one: '$count Κεφάλαιο',
    );
    return '$_temp0';
  }

  @override
  String studyNbGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Παρτίδες',
      one: '$count Παρτίδα',
    );
    return '$_temp0';
  }

  @override
  String studyNbMembers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Μέλη',
      one: '$count Μέλος',
    );
    return '$_temp0';
  }

  @override
  String studyPasteYourPgnTextHereUpToNbGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Επικολλήστε παιχνίδια ως PGN εδώ. Θα δημιουργηθεί κεφάλαιο για κάθε παιχνίδι. Η μελέτη μπορεί να έχει μέχρι $count κεφάλαια.',
      one: 'Επικολλήστε το PGN εδώ, μέχρι $count παρτίδα',
    );
    return '$_temp0';
  }

  @override
  String get timeagoJustNow => 'μόλις τώρα';

  @override
  String get timeagoRightNow => 'αυτή τη στιγμή';

  @override
  String get timeagoCompleted => 'ολοκληρώθηκε';

  @override
  String timeagoInNbSeconds(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'σε $count δευτερόλεπτα',
      one: 'σε $count δευτερόλεπτο',
    );
    return '$_temp0';
  }

  @override
  String timeagoInNbMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'σε $count λεπτά',
      one: 'σε $count λεπτό',
    );
    return '$_temp0';
  }

  @override
  String timeagoInNbHours(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'σε $count ώρες',
      one: 'σε $count ώρα',
    );
    return '$_temp0';
  }

  @override
  String timeagoInNbDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'σε $count ημέρες',
      one: 'σε $count ημέρα',
    );
    return '$_temp0';
  }

  @override
  String timeagoInNbWeeks(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'σε $count εβδομάδες',
      one: 'σε $count εβδομάδα',
    );
    return '$_temp0';
  }

  @override
  String timeagoInNbMonths(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'σε $count μήνες',
      one: 'σε $count μήνα',
    );
    return '$_temp0';
  }

  @override
  String timeagoInNbYears(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count έτη',
      one: 'σε $count έτος',
    );
    return '$_temp0';
  }

  @override
  String timeagoNbMinutesAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count λεπτά πριν',
      one: '$count λεπτό πριν',
    );
    return '$_temp0';
  }

  @override
  String timeagoNbHoursAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ώρες πριν',
      one: '$count ώρα πριν',
    );
    return '$_temp0';
  }

  @override
  String timeagoNbDaysAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ημέρες πριν',
      one: '$count μέρα πριν',
    );
    return '$_temp0';
  }

  @override
  String timeagoNbWeeksAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count εβδομάδες πριν',
      one: '$count εβδομάδα πριν',
    );
    return '$_temp0';
  }

  @override
  String timeagoNbMonthsAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count μήνες πριν',
      one: '$count μήνα πριν',
    );
    return '$_temp0';
  }

  @override
  String timeagoNbYearsAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count χρόνια πριν',
      one: '$count χρόνο πριν',
    );
    return '$_temp0';
  }

  @override
  String timeagoNbMinutesRemaining(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'απομένουν $count λεπτά',
      one: 'απομένει $count λεπτό',
    );
    return '$_temp0';
  }

  @override
  String timeagoNbHoursRemaining(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'απομένουν $count ώρες',
      one: 'απομένει $count ώρα',
    );
    return '$_temp0';
  }
}
