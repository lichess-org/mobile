// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'l10n.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get mobileAllGames => 'Toutes les parties';

  @override
  String get mobileAreYouSure => 'Êtes-vous sûr ?';

  @override
  String get mobileCancelTakebackOffer => 'Annuler la proposition de reprise du coup';

  @override
  String get mobileClearButton => 'Effacer';

  @override
  String get mobileCorrespondenceClearSavedMove => 'Effacer les coups enregistrés';

  @override
  String get mobileCustomGameJoinAGame => 'Joindre une partie';

  @override
  String get mobileFeedbackButton => 'Commentaires';

  @override
  String mobileGreeting(String param) {
    return 'Bonjour $param';
  }

  @override
  String get mobileGreetingWithoutName => 'Bonjour';

  @override
  String get mobileHideVariation => 'Masquer les variantes';

  @override
  String get mobileHomeTab => 'Accueil';

  @override
  String get mobileLiveStreamers => 'Diffuseurs en direct';

  @override
  String get mobileMustBeLoggedIn => 'Vous devez être connecté pour voir cette page.';

  @override
  String get mobileNoSearchResults => 'Aucun résultat';

  @override
  String get mobileNotFollowingAnyUser => 'Vous ne suivez aucun utilisateur.';

  @override
  String get mobileOkButton => 'OK';

  @override
  String mobilePlayersMatchingSearchTerm(String param) {
    return 'Joueurs – \"$param\"';
  }

  @override
  String get mobilePrefMagnifyDraggedPiece => 'Grossir la pièce déplacée';

  @override
  String get mobilePuzzleStormConfirmEndRun => 'Voulez-vous mettre fin à cette série ?';

  @override
  String get mobilePuzzleStormFilterNothingToShow => 'Rien à afficher. Veuillez changer les filtres';

  @override
  String get mobilePuzzleStormNothingToShow => 'Rien à afficher. Jouez quelques séries de problèmes.';

  @override
  String get mobilePuzzleStormSubtitle => 'Faites un maximum de problèmes en 3 minutes.';

  @override
  String get mobilePuzzleStreakAbortWarning => 'Votre série actuelle prendra fin et votre résultat sera sauvegardé.';

  @override
  String get mobilePuzzleThemesSubtitle => 'Faites des problèmes basés sur vos ouvertures préférées ou choisissez un thème.';

  @override
  String get mobilePuzzlesTab => 'Problèmes';

  @override
  String get mobileRecentSearches => 'Recherches récentes';

  @override
  String get mobileSettingsHapticFeedback => 'Mode vibration';

  @override
  String get mobileSettingsImmersiveMode => 'Mode plein écran';

  @override
  String get mobileSettingsImmersiveModeSubtitle => 'Masquer l\'interface système durant la partie. À utiliser lorsque les gestes pour naviguer dans l\'interface système sur les bords de l\'écran vous gênent. S\'applique en jeu et pour les séries de problèmes.';

  @override
  String get mobileSettingsTab => 'Paramètres';

  @override
  String get mobileShareGamePGN => 'Partager le PGN';

  @override
  String get mobileShareGameURL => 'Partager l\'URL de la partie';

  @override
  String get mobileSharePositionAsFEN => 'Partager la position FEN';

  @override
  String get mobileSharePuzzle => 'Partager ce problème';

  @override
  String get mobileShowComments => 'Afficher les commentaires';

  @override
  String get mobileShowResult => 'Afficher le résultat';

  @override
  String get mobileShowVariations => 'Afficher les variantes';

  @override
  String get mobileSomethingWentWrong => 'Une erreur s\'est produite.';

  @override
  String get mobileSystemColors => 'Couleurs du système';

  @override
  String get mobileTheme => 'Thème';

  @override
  String get mobileToolsTab => 'Outils';

  @override
  String get mobileWaitingForOpponentToJoin => 'En attente d\'un adversaire...';

  @override
  String get mobileWatchTab => 'Regarder';

  @override
  String get activityActivity => 'Activité';

  @override
  String get activityHostedALiveStream => 'A hébergé une diffusion en direct';

  @override
  String activityRankedInSwissTournament(String param1, String param2) {
    return 'Classé $param1 dans le tournoi $param2';
  }

  @override
  String get activitySignedUp => 'S\'est inscrit(e) à lichess.org';

  @override
  String activitySupportedNbMonths(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'A soutenu lichess.org pendant $count mois en tant que $param2',
      one: 'A soutenu lichess.org pendant $count mois en tant que $param2',
    );
    return '$_temp0';
  }

  @override
  String activityPracticedNbPositions(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'A pratiqué $count positions de $param2',
      one: 'A pratiqué $count position de $param2',
    );
    return '$_temp0';
  }

  @override
  String activitySolvedNbPuzzles(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'A résolu $count problème(s) tactique(s)',
      one: 'A résolu $count problème tactique',
    );
    return '$_temp0';
  }

  @override
  String activityPlayedNbGames(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'A joué $count parties de $param2',
      one: 'A joué $count partie de $param2',
    );
    return '$_temp0';
  }

  @override
  String activityPostedNbMessages(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'A posté $count messages dans $param2',
      one: 'A posté $count message dans $param2',
    );
    return '$_temp0';
  }

  @override
  String activityPlayedNbMoves(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'A joué $count coups',
      one: 'A joué $count coup',
    );
    return '$_temp0';
  }

  @override
  String activityInNbCorrespondenceGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'dans $count parties par correspondance',
      one: 'dans $count partie par correspondance',
    );
    return '$_temp0';
  }

  @override
  String activityCompletedNbGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count parties par correspondance terminées',
      one: '$count partie par correspondance terminée',
    );
    return '$_temp0';
  }

  @override
  String activityCompletedNbVariantGames(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count parties $param2 par correspondance terminées',
      one: '$count partie $param2 par correspondance terminée',
    );
    return '$_temp0';
  }

  @override
  String activityFollowedNbPlayers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'A commencé à suivre $count joueurs',
      one: 'A commencé à suivre $count joueur',
    );
    return '$_temp0';
  }

  @override
  String activityGainedNbFollowers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'A gagné $count nouveaux suiveurs',
      one: 'A gagné $count nouveau suiveur',
    );
    return '$_temp0';
  }

  @override
  String activityHostedNbSimuls(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'A hébergé $count simultanées',
      one: 'A hébergé $count simultanée',
    );
    return '$_temp0';
  }

  @override
  String activityJoinedNbSimuls(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'A participé à $count simultanées',
      one: 'A participé à $count simultanée(s)',
    );
    return '$_temp0';
  }

  @override
  String activityCreatedNbStudies(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count nouvelles études créées',
      one: 'A créé $count nouvelle étude',
    );
    return '$_temp0';
  }

  @override
  String activityCompetedInNbTournaments(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'A participé à $count tournois',
      one: 'A participé à $count tournoi',
    );
    return '$_temp0';
  }

  @override
  String activityRankedInTournament(int count, String param2, String param3, String param4) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Classé #$count (pourcentage: $param2%) avec $param3 parties en $param4',
      one: 'Classé #$count (pourcentage: $param2%) avec $param3 partie en $param4',
    );
    return '$_temp0';
  }

  @override
  String activityCompetedInNbSwissTournaments(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'A participé à $count tournois suisses',
      one: 'A participé à $count tournoi(s) suisse(s)',
    );
    return '$_temp0';
  }

  @override
  String activityJoinedNbTeams(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'A rejoint $count équipes',
      one: 'A rejoint $count équipe',
    );
    return '$_temp0';
  }

  @override
  String get broadcastBroadcasts => 'Diffusions';

  @override
  String get broadcastMyBroadcasts => 'Ma diffusion';

  @override
  String get broadcastLiveBroadcasts => 'Diffusions de tournois en direct';

  @override
  String get broadcastBroadcastCalendar => 'Calendrier des diffusions';

  @override
  String get broadcastNewBroadcast => 'Nouvelle diffusion en direct';

  @override
  String get broadcastSubscribedBroadcasts => 'Diffusions suivies';

  @override
  String get broadcastAboutBroadcasts => 'À propos des diffusions';

  @override
  String get broadcastHowToUseLichessBroadcasts => 'Comment utiliser les diffusions dans Lichess.';

  @override
  String get broadcastTheNewRoundHelp => 'La nouvelle ronde aura les mêmes participants et contributeurs que la précédente.';

  @override
  String get broadcastAddRound => 'Ajouter une ronde';

  @override
  String get broadcastOngoing => 'En cours';

  @override
  String get broadcastUpcoming => 'À venir';

  @override
  String get broadcastRoundName => 'Nom de la ronde';

  @override
  String get broadcastRoundNumber => 'Numéro de la ronde';

  @override
  String get broadcastTournamentName => 'Nom du tournoi';

  @override
  String get broadcastTournamentDescription => 'Brève description du tournoi';

  @override
  String get broadcastFullDescription => 'Description complète de l\'événement';

  @override
  String broadcastFullDescriptionHelp(String param1, String param2) {
    return 'Description détaillée et optionnelle de la diffusion. $param1 est disponible. La longueur doit être inférieure à $param2 caractères.';
  }

  @override
  String get broadcastSourceSingleUrl => 'URL source de la partie en PGN';

  @override
  String get broadcastSourceUrlHelp => 'URL que Lichess interrogera pour obtenir les mises à jour du PGN. Elle doit être accessible publiquement depuis Internet.';

  @override
  String get broadcastSourceGameIds => 'Jusqu\'à 64 ID de partie Lichess séparés par des espaces.';

  @override
  String broadcastStartDateTimeZone(String param) {
    return 'Date de début du tournoi (fuseau horaire local) : $param';
  }

  @override
  String get broadcastStartDateHelp => 'Facultatif, si vous savez quand l\'événement commence';

  @override
  String get broadcastCurrentGameUrl => 'URL de la partie en cours';

  @override
  String get broadcastDownloadAllRounds => 'Télécharger toutes les rondes';

  @override
  String get broadcastResetRound => 'Réinitialiser cette ronde';

  @override
  String get broadcastDeleteRound => 'Supprimer cette ronde';

  @override
  String get broadcastDefinitivelyDeleteRound => 'Supprimer définitivement la ronde et ses parties.';

  @override
  String get broadcastDeleteAllGamesOfThisRound => 'Supprimer toutes les parties de la ronde. La source doit être active pour recréer les parties.';

  @override
  String get broadcastEditRoundStudy => 'Modifier l\'étude de la ronde';

  @override
  String get broadcastDeleteTournament => 'Supprimer ce tournoi';

  @override
  String get broadcastDefinitivelyDeleteTournament => 'Supprimer définitivement le tournoi, toutes ses rondes et toutes ses parties.';

  @override
  String get broadcastShowScores => 'Afficher les résultats des joueurs en fonction des résultats des parties';

  @override
  String get broadcastReplacePlayerTags => 'Facultatif : remplacer les noms des joueurs, les classements et les titres';

  @override
  String get broadcastFideFederations => 'Fédérations FIDE';

  @override
  String get broadcastTop10Rating => '10 plus hauts classements';

  @override
  String get broadcastFidePlayers => 'Joueurs FIDE';

  @override
  String get broadcastFidePlayerNotFound => 'Joueur FIDE introuvable';

  @override
  String get broadcastFideProfile => 'Profil FIDE';

  @override
  String get broadcastFederation => 'Fédération';

  @override
  String get broadcastAgeThisYear => 'Âge cette année';

  @override
  String get broadcastUnrated => 'Non classé';

  @override
  String get broadcastRecentTournaments => 'Tournois récents';

  @override
  String get broadcastOpenLichess => 'Ouvrir dans Lichess';

  @override
  String get broadcastTeams => 'Équipes';

  @override
  String get broadcastBoards => 'Échiquiers';

  @override
  String get broadcastOverview => 'Survol';

  @override
  String get broadcastSubscribeTitle => 'Abonnez-vous pour être averti du début de chaque ronde. Vous pouvez basculer entre une sonnerie ou une notification poussée pour les diffusions dans les préférences de votre compte.';

  @override
  String get broadcastUploadImage => 'Téléverser une image pour le tournoi';

  @override
  String get broadcastNoBoardsYet => 'Pas d\'échiquiers pour le moment. Ils s\'afficheront lorsque les parties seront téléversées.';

  @override
  String broadcastBoardsCanBeLoaded(String param) {
    return 'Les échiquiers sont chargés à partir d\'une source ou de l\'$param.';
  }

  @override
  String broadcastStartsAfter(String param) {
    return 'Commence après la $param';
  }

  @override
  String get broadcastStartVerySoon => 'La diffusion commencera très bientôt.';

  @override
  String get broadcastNotYetStarted => 'La diffusion n\'a pas encore commencé.';

  @override
  String get broadcastOfficialWebsite => 'Site Web officiel';

  @override
  String get broadcastStandings => 'Classement';

  @override
  String get broadcastOfficialStandings => 'Résultats officiels';

  @override
  String broadcastIframeHelp(String param) {
    return 'Plus d\'options sur la $param';
  }

  @override
  String get broadcastWebmastersPage => 'page des webmestres';

  @override
  String broadcastPgnSourceHelp(String param) {
    return 'Source PGN publique en temps réel pour cette ronde. Nous offrons également un $param pour permettre une synchronisation rapide et efficace.';
  }

  @override
  String get broadcastEmbedThisBroadcast => 'Intégrer cette diffusion dans votre site Web';

  @override
  String broadcastEmbedThisRound(String param) {
    return 'Intégrer la $param dans votre site Web';
  }

  @override
  String get broadcastRatingDiff => 'Différence de cote';

  @override
  String get broadcastGamesThisTournament => 'Partie de ce tournoi';

  @override
  String get broadcastScore => 'Résultat';

  @override
  String get broadcastAllTeams => 'Toutes les équipes';

  @override
  String get broadcastTournamentFormat => 'Format du tournoi';

  @override
  String get broadcastTournamentLocation => 'Lieu du tournoi';

  @override
  String get broadcastTopPlayers => 'Meilleurs joueurs';

  @override
  String get broadcastTimezone => 'Fuseau horaire';

  @override
  String get broadcastFideRatingCategory => 'Catégorie FIDE';

  @override
  String get broadcastOptionalDetails => 'Informations facultatives';

  @override
  String get broadcastPastBroadcasts => 'Diffusions passées';

  @override
  String get broadcastAllBroadcastsByMonth => 'Voir les diffusions par mois';

  @override
  String get broadcastBackToLiveMove => 'Retour au coup en direct';

  @override
  String get broadcastSinceHideResults => 'Vous avez choisi de masquer les résultats. Les échiquiers de prévisualisation sont donc vides pour ne rien révéler.';

  @override
  String broadcastNbBroadcasts(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count diffusions',
      one: '$count diffusion',
    );
    return '$_temp0';
  }

  @override
  String challengeChallengesX(String param1) {
    return 'Défis : $param1';
  }

  @override
  String get challengeChallengeToPlay => 'Défier ce joueur';

  @override
  String get challengeChallengeDeclined => 'Défi refusé';

  @override
  String get challengeChallengeAccepted => 'Défi accepté !';

  @override
  String get challengeChallengeCanceled => 'Défi annulé.';

  @override
  String get challengeRegisterToSendChallenges => 'Veuillez vous inscrire pour envoyer des défis à cet utilisateur.';

  @override
  String challengeYouCannotChallengeX(String param) {
    return 'Vous ne pouvez pas défier $param.';
  }

  @override
  String challengeXDoesNotAcceptChallenges(String param) {
    return '$param n’accepte pas les défis.';
  }

  @override
  String challengeYourXRatingIsTooFarFromY(String param1, String param2) {
    return 'Votre classement de $param1 est trop différent de celui de $param2.';
  }

  @override
  String challengeCannotChallengeDueToProvisionalXRating(String param) {
    return 'Défi refusé à cause de la cote $param provisoire.';
  }

  @override
  String challengeXOnlyAcceptsChallengesFromFriends(String param) {
    return '$param n’accepte que les défis de ses ami(e)s.';
  }

  @override
  String get challengeDeclineGeneric => 'Je n\'accepte pas de défis pour le moment.';

  @override
  String get challengeDeclineLater => 'Ce n\'est pas un bon moment pour moi, réessayez plus tard, svp.';

  @override
  String get challengeDeclineTooFast => 'Ce contrôle de temps est trop rapide pour moi, réessayez avec un contrôle de temps plus lent, svp.';

  @override
  String get challengeDeclineTooSlow => 'Ce contrôle de temps est trop lent pour moi, réessayez avec un contrôle de temps plus rapide, svp.';

  @override
  String get challengeDeclineTimeControl => 'Je n\'accepte pas de défis avec ce contrôle de temps.';

  @override
  String get challengeDeclineRated => 'Envoyez-moi plutôt un défi classé.';

  @override
  String get challengeDeclineCasual => 'Envoyez-moi plutôt un défi amical.';

  @override
  String get challengeDeclineStandard => 'Je n\'accepte pas de défis avec des variantes pour le moment.';

  @override
  String get challengeDeclineVariant => 'Je ne veux pas jouer cette variante pour le moment.';

  @override
  String get challengeDeclineNoBot => 'Je n\'accepte pas les défis des robots.';

  @override
  String get challengeDeclineOnlyBot => 'J\'accepte uniquement les défis des robots.';

  @override
  String get challengeInviteLichessUser => 'Ou inviter un utilisateur de Lichess :';

  @override
  String get contactContact => 'Contact';

  @override
  String get contactContactLichess => 'Contacter Lichess';

  @override
  String get patronDonate => 'Faire un don';

  @override
  String get patronLichessPatron => 'Mécène Lichess';

  @override
  String perfStatPerfStats(String param) {
    return 'Statistiques en $param';
  }

  @override
  String get perfStatViewTheGames => 'Voir les parties';

  @override
  String get perfStatProvisional => 'provisoire';

  @override
  String get perfStatNotEnoughRatedGames => 'Il n\'y a pas assez de parties classées pour établir un classement fiable.';

  @override
  String perfStatProgressOverLastXGames(String param) {
    return 'Changement après les $param dernières parties :';
  }

  @override
  String perfStatRatingDeviation(String param) {
    return 'Écart-type du classement : $param.';
  }

  @override
  String perfStatRatingDeviationTooltip(String param1, String param2, String param3) {
    return 'Une valeur plus faible indique un classement plus fiable. Au-delà de $param1, le classement est considéré comme provisoire. Pour être inclus dans les classements, cette valeur doit être inférieure à $param2 (échecs standards) ou $param3 (variantes).';
  }

  @override
  String get perfStatTotalGames => 'Nombre total de parties';

  @override
  String get perfStatRatedGames => 'Parties classées';

  @override
  String get perfStatTournamentGames => 'Parties de tournoi';

  @override
  String get perfStatBerserkedGames => 'Parties berserkées';

  @override
  String get perfStatTimeSpentPlaying => 'Temps passé à jouer';

  @override
  String get perfStatAverageOpponent => 'Classement moyen des adversaires';

  @override
  String get perfStatVictories => 'Victoires';

  @override
  String get perfStatDefeats => 'Défaites';

  @override
  String get perfStatDisconnections => 'Déconnexions';

  @override
  String get perfStatNotEnoughGames => 'Pas assez de parties jouées';

  @override
  String perfStatHighestRating(String param) {
    return 'Meilleur classement atteint : $param';
  }

  @override
  String perfStatLowestRating(String param) {
    return 'Plus bas classement atteint : $param';
  }

  @override
  String perfStatFromXToY(String param1, String param2) {
    return 'de $param1 à $param2';
  }

  @override
  String get perfStatWinningStreak => 'Victoires consécutives';

  @override
  String get perfStatLosingStreak => 'Défaites consécutives';

  @override
  String perfStatLongestStreak(String param) {
    return 'Série la plus longue : $param';
  }

  @override
  String perfStatCurrentStreak(String param) {
    return 'Série actuelle : $param';
  }

  @override
  String get perfStatBestRated => 'Meilleures victoires classées';

  @override
  String get perfStatGamesInARow => 'Parties jouées à la suite';

  @override
  String get perfStatLessThanOneHour => 'Moins d\'une heure entre les parties';

  @override
  String get perfStatMaxTimePlaying => 'Temps maximal à jouer en continu';

  @override
  String get perfStatNow => 'maintenant';

  @override
  String get preferencesPreferences => 'Préférences';

  @override
  String get preferencesDisplay => 'Affichage';

  @override
  String get preferencesPrivacy => 'Confidentialité';

  @override
  String get preferencesNotifications => 'Notifications';

  @override
  String get preferencesPieceAnimation => 'Animation des pièces';

  @override
  String get preferencesMaterialDifference => 'Différence de matériel';

  @override
  String get preferencesBoardHighlights => 'Mettre en évidence les cases (dernier coup et échec)';

  @override
  String get preferencesPieceDestinations => 'Cases de destination (coups et pré-coups légaux)';

  @override
  String get preferencesBoardCoordinates => 'Coordonnées (a-h, 1-8)';

  @override
  String get preferencesMoveListWhilePlaying => 'Liste des coups durant la partie';

  @override
  String get preferencesPgnPieceNotation => 'Notation des coups';

  @override
  String get preferencesChessPieceSymbol => 'Figurine de la pièce';

  @override
  String get preferencesPgnLetter => 'Lettre de la pièce (K, Q, R, B, N)';

  @override
  String get preferencesZenMode => 'Mode Zen';

  @override
  String get preferencesShowPlayerRatings => 'Afficher les classements du joueur';

  @override
  String get preferencesShowFlairs => 'Montrer les émojis de l\'utilisateur';

  @override
  String get preferencesExplainShowPlayerRatings => 'Cela permet de masquer tous les classements sur le site pour se concentrer sur les échecs. Les parties peuvent toujours être classées.';

  @override
  String get preferencesDisplayBoardResizeHandle => 'Afficher la poignée de redimensionnement de l\'échiquier';

  @override
  String get preferencesOnlyOnInitialPosition => 'Seulement dans la position initiale';

  @override
  String get preferencesInGameOnly => 'Seulement durant la partie';

  @override
  String get preferencesExceptInGame => 'Sauf durant la partie';

  @override
  String get preferencesChessClock => 'Pendule';

  @override
  String get preferencesTenthsOfSeconds => 'Dixièmes de seconde';

  @override
  String get preferencesWhenTimeRemainingLessThanTenSeconds => 'Quand il reste moins de 10 secondes';

  @override
  String get preferencesHorizontalGreenProgressBars => 'Barres de progression horizontales vertes';

  @override
  String get preferencesSoundWhenTimeGetsCritical => 'Alerte quand le temps restant devient critique';

  @override
  String get preferencesGiveMoreTime => 'Donner plus de temps';

  @override
  String get preferencesGameBehavior => 'Comportement du jeu';

  @override
  String get preferencesHowDoYouMovePieces => 'Comment voulez-vous déplacer les pièces ?';

  @override
  String get preferencesClickTwoSquares => 'Clic et clic';

  @override
  String get preferencesDragPiece => 'Faire glisser la pièce';

  @override
  String get preferencesBothClicksAndDrag => 'Les deux';

  @override
  String get preferencesPremovesPlayingDuringOpponentTurn => 'Pré-coups';

  @override
  String get preferencesTakebacksWithOpponentApproval => 'Annulations de coups (avec accord de l\'adversaire)';

  @override
  String get preferencesInCasualGamesOnly => 'Durant les parties amicales seulement';

  @override
  String get preferencesPromoteToQueenAutomatically => 'Promouvoir en dame automatiquement';

  @override
  String get preferencesExplainPromoteToQueenAutomatically => 'Maintenez la touche <ctrl> enfoncée lors de la promotion pour désactiver temporairement l\'auto-promotion';

  @override
  String get preferencesWhenPremoving => 'Lors d\'un pré-coup';

  @override
  String get preferencesClaimDrawOnThreefoldRepetitionAutomatically => 'Déclarer la nulle par répétition automatiquement';

  @override
  String get preferencesWhenTimeRemainingLessThanThirtySeconds => 'Quand il reste moins de 30 secondes';

  @override
  String get preferencesMoveConfirmation => 'Confirmation de coup';

  @override
  String get preferencesExplainCanThenBeTemporarilyDisabled => 'Peut être désactivé pendant une partie grâce au menu de l\'échiquer';

  @override
  String get preferencesInCorrespondenceGames => 'Dans les parties par correspondance';

  @override
  String get preferencesCorrespondenceAndUnlimited => 'Correspondance et illimité';

  @override
  String get preferencesConfirmResignationAndDrawOffers => 'Confirmer l\'abandon et la proposition de nulle';

  @override
  String get preferencesCastleByMovingTheKingTwoSquaresOrOntoTheRook => 'Manière de roquer';

  @override
  String get preferencesCastleByMovingTwoSquares => 'En déplaçant le Roi de 2 cases';

  @override
  String get preferencesCastleByMovingOntoTheRook => 'En déplaçant le Roi sur la Tour';

  @override
  String get preferencesInputMovesWithTheKeyboard => 'Saisir les coups au clavier';

  @override
  String get preferencesInputMovesWithVoice => 'Utiliser la reconnaissance vocale pour déplacer les pièces';

  @override
  String get preferencesSnapArrowsToValidMoves => 'Restreindre les flèches aux coups valides';

  @override
  String get preferencesSayGgWpAfterLosingOrDrawing => 'Dire \"Bonne partie, bien jouée\" en cas de défaite ou de nulle';

  @override
  String get preferencesYourPreferencesHaveBeenSaved => 'Vos préférences ont été sauvegardées.';

  @override
  String get preferencesScrollOnTheBoardToReplayMoves => 'Parcourez les coups avec la molette de la souris sur l\'échiquier';

  @override
  String get preferencesCorrespondenceEmailNotification => 'Email quotidien de la liste de vos parties par correspondance';

  @override
  String get preferencesNotifyStreamStart => 'Le diffuseur passe en direct';

  @override
  String get preferencesNotifyInboxMsg => 'Nouveau message';

  @override
  String get preferencesNotifyForumMention => 'Un commentaire du forum vous mentionne';

  @override
  String get preferencesNotifyInvitedStudy => 'Invitation à une étude';

  @override
  String get preferencesNotifyGameEvent => 'Mise à jour des parties par correspondance';

  @override
  String get preferencesNotifyChallenge => 'Défis';

  @override
  String get preferencesNotifyTournamentSoon => 'Le tournoi va bientôt commencer';

  @override
  String get preferencesNotifyTimeAlarm => 'Le temps de la partie par correspondance est presque épuisé';

  @override
  String get preferencesNotifyBell => 'Notification sonore sur Lichess';

  @override
  String get preferencesNotifyPush => 'Notification sur votre appareil quand vous n\'êtes pas sur Lichess';

  @override
  String get preferencesNotifyWeb => 'Navigateur';

  @override
  String get preferencesNotifyDevice => 'Appareil';

  @override
  String get preferencesBellNotificationSound => 'Son de notification';

  @override
  String get preferencesBlindfold => 'Partie à l\'aveugle';

  @override
  String get puzzlePuzzles => 'Problèmes';

  @override
  String get puzzlePuzzleThemes => 'Thèmes des problèmes';

  @override
  String get puzzleRecommended => 'Recommandé';

  @override
  String get puzzlePhases => 'Phases';

  @override
  String get puzzleMotifs => 'Motifs';

  @override
  String get puzzleAdvanced => 'Avancé';

  @override
  String get puzzleLengths => 'Longueurs';

  @override
  String get puzzleMates => 'Mats';

  @override
  String get puzzleGoals => 'Objectifs';

  @override
  String get puzzleOrigin => 'Origine';

  @override
  String get puzzleSpecialMoves => 'Coups spéciaux';

  @override
  String get puzzleDidYouLikeThisPuzzle => 'Avez-vous aimé ce problème ?';

  @override
  String get puzzleVoteToLoadNextOne => 'Votez pour afficher le suivant !';

  @override
  String get puzzleUpVote => 'Voter pour ce problème';

  @override
  String get puzzleDownVote => 'Voter contre ce problème';

  @override
  String get puzzleYourPuzzleRatingWillNotChange => 'Votre classement ne changera pas. Notez que les problèmes ne sont pas une compétition. Le classement aide à sélectionner les meilleurs problèmes en fonction de votre niveau.';

  @override
  String get puzzleFindTheBestMoveForWhite => 'Trouvez le meilleur coup pour les Blancs.';

  @override
  String get puzzleFindTheBestMoveForBlack => 'Trouvez le meilleur coup pour les Noirs.';

  @override
  String get puzzleToGetPersonalizedPuzzles => 'Pour obtenir des problèmes personnalisés :';

  @override
  String puzzlePuzzleId(String param) {
    return 'Problème $param';
  }

  @override
  String get puzzlePuzzleOfTheDay => 'Problème du jour';

  @override
  String get puzzleDailyPuzzle => 'Problème du jour';

  @override
  String get puzzleClickToSolve => 'Cliquez pour résoudre';

  @override
  String get puzzleGoodMove => 'Bon coup';

  @override
  String get puzzleBestMove => 'Meilleur coup  !';

  @override
  String get puzzleKeepGoing => 'Continuez…';

  @override
  String get puzzlePuzzleSuccess => 'Succès !';

  @override
  String get puzzlePuzzleComplete => 'Problème terminé !';

  @override
  String get puzzleByOpenings => 'Par ouverture';

  @override
  String get puzzlePuzzlesByOpenings => 'Problèmes par ouverture';

  @override
  String get puzzleOpeningsYouPlayedTheMost => 'Ouvertures que vous avez le plus jouées dans des parties classées';

  @override
  String get puzzleUseFindInPage => 'Utilisez la fonction « Rechercher dans la page » du navigateur pour trouver votre ouverture préférée !';

  @override
  String get puzzleUseCtrlF => 'Appuyez sur les touches Ctrl+f pour trouver votre ouverture préférée !';

  @override
  String get puzzleNotTheMove => 'Ce n\'est pas le coup !';

  @override
  String get puzzleTrySomethingElse => 'Essayez autre chose.';

  @override
  String puzzleRatingX(String param) {
    return 'Classement : $param';
  }

  @override
  String get puzzleHidden => 'masqué';

  @override
  String puzzleFromGameLink(String param) {
    return 'Tiré de la partie $param';
  }

  @override
  String get puzzleContinueTraining => 'Continuer l\'entraînement';

  @override
  String get puzzleDifficultyLevel => 'Niveau de difficulté';

  @override
  String get puzzleNormal => 'Normal';

  @override
  String get puzzleEasier => 'Plus facile';

  @override
  String get puzzleEasiest => 'Le plus facile';

  @override
  String get puzzleHarder => 'Plus difficile';

  @override
  String get puzzleHardest => 'Le plus difficile';

  @override
  String get puzzleExample => 'Exemple';

  @override
  String get puzzleAddAnotherTheme => 'Ajouter un autre thème';

  @override
  String get puzzleNextPuzzle => 'Problème suivant';

  @override
  String get puzzleJumpToNextPuzzleImmediately => 'Passer immédiatement au problème suivant';

  @override
  String get puzzlePuzzleDashboard => 'Tableau de bord des problèmes';

  @override
  String get puzzleImprovementAreas => 'Aspects à améliorer';

  @override
  String get puzzleStrengths => 'Points forts';

  @override
  String get puzzleHistory => 'Historique des problèmes';

  @override
  String get puzzleSolved => 'résolu';

  @override
  String get puzzleFailed => 'non résolu';

  @override
  String get puzzleStreakDescription => 'Résolvez des problèmes de plus en plus difficiles et obtenez une série de victoires. Prenez votre temps, il n\'y a pas de pendule. Un mauvais coup et c\'est terminé ! Mais vous pouvez passer un coup par session.';

  @override
  String puzzleYourStreakX(String param) {
    return 'Votre série gagnante : $param';
  }

  @override
  String get puzzleStreakSkipExplanation => 'Sautez ce coup pour préserver votre série gagnante! Possible une seule fois par session.';

  @override
  String get puzzleContinueTheStreak => 'Continuer la série';

  @override
  String get puzzleNewStreak => 'Nouvelle série';

  @override
  String get puzzleFromMyGames => 'De mes parties';

  @override
  String get puzzleLookupOfPlayer => 'Rechercher des problèmes à partir des parties d\'un joueur';

  @override
  String puzzleFromXGames(String param) {
    return 'Problèmes tirés des parties de $param\'';
  }

  @override
  String get puzzleSearchPuzzles => 'Rechercher des problèmes';

  @override
  String get puzzleFromMyGamesNone => 'Vous n\'avez pas de problèmes dans la base de données, mais Lichess vous aime toujours.\nJouez des parties rapides et classiques pour augmenter vos chances qu\'une de vos parties soit utilisée comme problème !';

  @override
  String puzzleFromXGamesFound(String param1, String param2) {
    return '$param1 problèmes trouvés dans $param2 parties';
  }

  @override
  String get puzzlePuzzleDashboardDescription => 'S\'entraîner, analyser, s\'améliorer';

  @override
  String puzzlePercentSolved(String param) {
    return '$param des problèmes résolus';
  }

  @override
  String get puzzleNoPuzzlesToShow => 'Rien à afficher - faites d\'abord quelques problèmes !';

  @override
  String get puzzleImprovementAreasDescription => 'Faites ces problèmes pour progresser !';

  @override
  String get puzzleStrengthDescription => 'Vous avez le plus de succès dans ces thèmes.';

  @override
  String puzzlePlayedXTimes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Joué $count fois',
      one: 'Joué $count fois',
    );
    return '$_temp0';
  }

  @override
  String puzzleNbPointsBelowYourPuzzleRating(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count points en dessous de votre classement de problème',
      one: 'Un point en dessous de votre classement de problème',
    );
    return '$_temp0';
  }

  @override
  String puzzleNbPointsAboveYourPuzzleRating(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count points au dessus de votre classement de problème',
      one: 'Un point au dessus de votre classement de problème',
    );
    return '$_temp0';
  }

  @override
  String puzzleNbPlayed(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count problèmes faits',
      one: '$count problème fait',
    );
    return '$_temp0';
  }

  @override
  String puzzleNbToReplay(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count problèmes à refaire',
      one: '$count problème à refaire',
    );
    return '$_temp0';
  }

  @override
  String get puzzleThemeAdvancedPawn => 'Pion avancé';

  @override
  String get puzzleThemeAdvancedPawnDescription => 'Un pion se promouvant ou menaçant d\'être promu est essentiel à la tactique.';

  @override
  String get puzzleThemeAdvantage => 'Avantage';

  @override
  String get puzzleThemeAdvantageDescription => 'Saisissez votre chance d\'obtenir un avantage décisif. (200cp ≤ évaluation ≤ 600cp)';

  @override
  String get puzzleThemeAnastasiaMate => 'Mat d\'Anastasie';

  @override
  String get puzzleThemeAnastasiaMateDescription => 'Un Cavalier et une Tour ou une Dame s\'associent pour piéger le Roi adverse entre le bord de l\'échiquier et une pièce amie.';

  @override
  String get puzzleThemeArabianMate => 'Mat des Arabes';

  @override
  String get puzzleThemeArabianMateDescription => 'Un Cavalier et une Tour s\'associent pour piéger le Roi adverse dans un coin de l\'échiquier.';

  @override
  String get puzzleThemeAttackingF2F7 => 'Attaque sur f2 ou f7';

  @override
  String get puzzleThemeAttackingF2F7Description => 'Une attaque sur le pion f2 ou f7, comme dans l\'attaque fegatello/Fried Liver.';

  @override
  String get puzzleThemeAttraction => 'Attraction';

  @override
  String get puzzleThemeAttractionDescription => 'Un échange ou un sacrifice encourageant ou forçant une pièce adverse à bouger sur une case, permettant une tactique.';

  @override
  String get puzzleThemeBackRankMate => 'Mat du couloir';

  @override
  String get puzzleThemeBackRankMateDescription => 'Matez le Roi sur la dernière rangée, lorsqu\'il est piégé par ses propres pièces.';

  @override
  String get puzzleThemeBishopEndgame => 'Finale de Fous';

  @override
  String get puzzleThemeBishopEndgameDescription => 'Une finale avec seulement des Fous et des pions.';

  @override
  String get puzzleThemeBodenMate => 'Mat de Boden';

  @override
  String get puzzleThemeBodenMateDescription => 'Deux Fous contrôlant des diagonales qui s\'entrecroisent matent un Roi bloqué par ses propres pièces.';

  @override
  String get puzzleThemeCastling => 'Roque';

  @override
  String get puzzleThemeCastlingDescription => 'Mettez votre Roi en sécurité et développez vos Tours pour attaquer.';

  @override
  String get puzzleThemeCapturingDefender => 'Capturez le défenseur';

  @override
  String get puzzleThemeCapturingDefenderDescription => 'Retire une pièce essentielle à la défense d\'une autre pièce, permettant à la pièce non protégée d\'être capturée au coup suivant.';

  @override
  String get puzzleThemeCrushing => 'Écrasant';

  @override
  String get puzzleThemeCrushingDescription => 'Repérez la gaffe de l\'adversaire pour obtenir un avantage écrasant. (évaluation > 600cp)';

  @override
  String get puzzleThemeDoubleBishopMate => 'Mat des deux Fous';

  @override
  String get puzzleThemeDoubleBishopMateDescription => 'Deux Fous contrôlant des diagonales adjacentes matent un Roi bloqué par ses propres pièces.';

  @override
  String get puzzleThemeDovetailMate => 'Mat de Cozio';

  @override
  String get puzzleThemeDovetailMateDescription => 'Une Dame mate un Roi placé sur une case adjacente, les deux seules cases de fuite étant occupées par des pièces amies.';

  @override
  String get puzzleThemeEquality => 'Égalité';

  @override
  String get puzzleThemeEqualityDescription => 'Revenir d\'une position perdante et assurer une nulle ou une position équilibrée. (évaluation ≤ 200cp)';

  @override
  String get puzzleThemeKingsideAttack => 'Attaque sur l\'aile roi';

  @override
  String get puzzleThemeKingsideAttackDescription => 'Une attaque du Roi adverse, après qu\'il a fait le petit roque.';

  @override
  String get puzzleThemeClearance => 'Dégagement';

  @override
  String get puzzleThemeClearanceDescription => 'Un coup, souvent avec tempo, qui libère une case, une colonne ou une diagonale en vue d\'une idée tactique.';

  @override
  String get puzzleThemeDefensiveMove => 'Coup défensif';

  @override
  String get puzzleThemeDefensiveMoveDescription => 'Un coup ou une séquence de coups précis qui est nécessaire pour éviter de perdre du matériel ou un autre avantage.';

  @override
  String get puzzleThemeDeflection => 'Déviation';

  @override
  String get puzzleThemeDeflectionDescription => 'Un coup qui dévie une pièce de l\'adversaire d\'une tâche qu\'elle assure, comme la protection d\'une case-clé.';

  @override
  String get puzzleThemeDiscoveredAttack => 'Attaque à la découverte';

  @override
  String get puzzleThemeDiscoveredAttackDescription => 'Déplacer une pièce qui bloquait auparavant une attaque par une autre pièce à longue portée, comme un Cavalier hors du champ d\'une Tour.';

  @override
  String get puzzleThemeDoubleCheck => 'Échec double';

  @override
  String get puzzleThemeDoubleCheckDescription => 'Faire échec avec deux pièces à la fois, à la suite d\'une attaque à la découverte où la pièce mobile et la pièce dévoilée attaquent le Roi adverse.';

  @override
  String get puzzleThemeEndgame => 'Finale';

  @override
  String get puzzleThemeEndgameDescription => 'Une tactique lors de la dernière phase du jeu.';

  @override
  String get puzzleThemeEnPassantDescription => 'Une tactique impliquant la règle de la prise en passant, où un pion peut capturer un pion adverse qui l\'a croisé lors de son déplacement initial de deux cases.';

  @override
  String get puzzleThemeExposedKing => 'Roi exposé';

  @override
  String get puzzleThemeExposedKingDescription => 'Une tactique impliquant un Roi avec peu de défenseurs autour de lui, menant souvent à l\'échec et mat.';

  @override
  String get puzzleThemeFork => 'Fourchette';

  @override
  String get puzzleThemeForkDescription => 'Un coup où la pièce déplacée attaque deux pièces de l\'adversaire à la fois.';

  @override
  String get puzzleThemeHangingPiece => 'Pièce en prise';

  @override
  String get puzzleThemeHangingPieceDescription => 'Une tactique impliquant une pièce adverse non protégée ou insuffisamment défendue et libre d\'être capturée.';

  @override
  String get puzzleThemeHookMate => 'Mat du hameçon';

  @override
  String get puzzleThemeHookMateDescription => 'Mat avec une Tour, un Cavalier et un pion, avec un pion adverse qui empêche la fuite du roi ennemi.';

  @override
  String get puzzleThemeInterference => 'Interception';

  @override
  String get puzzleThemeInterferenceDescription => 'Déplacer une pièce entre deux pièces adverses pour en laisser l\'une ou les deux non protégées, comme un Cavalier sur une case défendue entre deux Tours.';

  @override
  String get puzzleThemeIntermezzo => 'Coup intermédiaire';

  @override
  String get puzzleThemeIntermezzoDescription => 'Au lieu de jouer le coup attendu, jouez d\'abord un autre coup posant une menace immédiate à laquelle l\'adversaire doit répondre. Aussi connu sous le nom de \"Zwischenzug\".';

  @override
  String get puzzleThemeKillBoxMate => 'Mat par mise en boîte';

  @override
  String get puzzleThemeKillBoxMateDescription => 'La tour, protégée par la dame, met le roi adverse en échec et la dame bloque la seule case de fuite du roi (le roi est enfermé dans une boîte de 3 cases par 3 cases formée par la tour et la dame).';

  @override
  String get puzzleThemeVukovicMate => 'Mat de Vukovic';

  @override
  String get puzzleThemeVukovicMateDescription => 'Une tour et un cavalier collaborent pour mater le roi adverse. Protégée par une troisième pièce, la tour fait mat, car le cavalier bloque la case de fuite du roi.';

  @override
  String get puzzleThemeKnightEndgame => 'Finale de Cavaliers';

  @override
  String get puzzleThemeKnightEndgameDescription => 'Une finale avec seulement des Cavaliers et des pions.';

  @override
  String get puzzleThemeLong => 'Long problème';

  @override
  String get puzzleThemeLongDescription => 'Victoire en trois coups.';

  @override
  String get puzzleThemeMaster => 'Parties de maîtres';

  @override
  String get puzzleThemeMasterDescription => 'Problèmes tirés de parties jouées par des joueurs titrés';

  @override
  String get puzzleThemeMasterVsMaster => 'Parties jouées entre maîtres';

  @override
  String get puzzleThemeMasterVsMasterDescription => 'Problèmes tirés de parties entre deux joueurs titrés';

  @override
  String get puzzleThemeMate => 'Mat';

  @override
  String get puzzleThemeMateDescription => 'Gagnez la partie avec classe.';

  @override
  String get puzzleThemeMateIn1 => 'Mat en 1';

  @override
  String get puzzleThemeMateIn1Description => 'Matez en un coup.';

  @override
  String get puzzleThemeMateIn2 => 'Mat en 2';

  @override
  String get puzzleThemeMateIn2Description => 'Matez en deux coups.';

  @override
  String get puzzleThemeMateIn3 => 'Mat en 3';

  @override
  String get puzzleThemeMateIn3Description => 'Matez en trois coups.';

  @override
  String get puzzleThemeMateIn4 => 'Mat en 4';

  @override
  String get puzzleThemeMateIn4Description => 'Matez en quatre coups.';

  @override
  String get puzzleThemeMateIn5 => 'Mat en 5 ou plus';

  @override
  String get puzzleThemeMateIn5Description => 'Trouvez une longue séquence de coups menant au mat.';

  @override
  String get puzzleThemeMiddlegame => 'Milieu de jeu';

  @override
  String get puzzleThemeMiddlegameDescription => 'Une tactique pendant la seconde phase de la partie.';

  @override
  String get puzzleThemeOneMove => 'Problème à un coup';

  @override
  String get puzzleThemeOneMoveDescription => 'Un problème qui ne dure qu\'un coup.';

  @override
  String get puzzleThemeOpening => 'Ouverture';

  @override
  String get puzzleThemeOpeningDescription => 'Une tactique durant la première phase de la partie.';

  @override
  String get puzzleThemePawnEndgame => 'Finale de pions';

  @override
  String get puzzleThemePawnEndgameDescription => 'Une finale avec seulement des pions.';

  @override
  String get puzzleThemePin => 'Clouage';

  @override
  String get puzzleThemePinDescription => 'Une tactique impliquant des clouages, où une pièce est incapable de se déplacer sans qu\'une pièce de valeur supérieure soit attaquée.';

  @override
  String get puzzleThemePromotion => 'Promotion';

  @override
  String get puzzleThemePromotionDescription => 'Un pion promouvant ou menaçant d\'être promu est essentiel à la tactique.';

  @override
  String get puzzleThemeQueenEndgame => 'Finale de Dames';

  @override
  String get puzzleThemeQueenEndgameDescription => 'Une finale avec seulement des Dames et des pions.';

  @override
  String get puzzleThemeQueenRookEndgame => 'Dames et Tours';

  @override
  String get puzzleThemeQueenRookEndgameDescription => 'Une finale avec seulement des Dames, Tours et pions.';

  @override
  String get puzzleThemeQueensideAttack => 'Attaque sur l\'aile dame';

  @override
  String get puzzleThemeQueensideAttackDescription => 'Une attaque du Roi adverse, après qu\'il a fait le grand roque.';

  @override
  String get puzzleThemeQuietMove => 'Coup silencieux';

  @override
  String get puzzleThemeQuietMoveDescription => 'Un mouvement qui ne fait pas échec ni n\'est une capture, mais qui prépare une menace inévitable.';

  @override
  String get puzzleThemeRookEndgame => 'Finale de Tours';

  @override
  String get puzzleThemeRookEndgameDescription => 'Une finale avec seulement des Tours et des pions.';

  @override
  String get puzzleThemeSacrifice => 'Sacrifice';

  @override
  String get puzzleThemeSacrificeDescription => 'Une tactique consistant à donner du matériel à court terme, pour gagner un avantage après une séquence de coups forcés.';

  @override
  String get puzzleThemeShort => 'Court problème';

  @override
  String get puzzleThemeShortDescription => 'Victoire en deux coups.';

  @override
  String get puzzleThemeSkewer => 'Enfilade';

  @override
  String get puzzleThemeSkewerDescription => 'Un motif impliquant l\'attaque d\'une pièce de grande valeur qui en se dégageant permet la capture ou l\'attaque d\'une pièce de moindre valeur située derrière elle, l\'inverse d\'un clouage.';

  @override
  String get puzzleThemeSmotheredMate => 'Mat à l\'étouffée';

  @override
  String get puzzleThemeSmotheredMateDescription => 'Un mat délivré par un Cavalier dans lequel le Roi est incapable de s\'échapper parce qu\'il est entouré (ou étouffé) par ses propres pièces.';

  @override
  String get puzzleThemeSuperGM => 'Parties de super GM';

  @override
  String get puzzleThemeSuperGMDescription => 'Problèmes issus de parties des meilleurs joueurs du monde.';

  @override
  String get puzzleThemeTrappedPiece => 'Pièce enfermée';

  @override
  String get puzzleThemeTrappedPieceDescription => 'Une pièce forcément capturée car incapable de s\'échapper.';

  @override
  String get puzzleThemeUnderPromotion => 'Sous-promotion';

  @override
  String get puzzleThemeUnderPromotionDescription => 'Promotion en Cavalier, Fou ou Tour.';

  @override
  String get puzzleThemeVeryLong => 'Très long problème';

  @override
  String get puzzleThemeVeryLongDescription => 'Quatre coups ou plus pour gagner.';

  @override
  String get puzzleThemeXRayAttack => 'Attaque « rayons X »';

  @override
  String get puzzleThemeXRayAttackDescription => 'Une pièce attaque ou défend une case, à travers une pièce ennemie.';

  @override
  String get puzzleThemeZugzwang => 'Zugzwang';

  @override
  String get puzzleThemeZugzwangDescription => 'L\'adversaire est limité dans les mouvements qu\'il peut effectuer, et tous les coups aggravent sa position.';

  @override
  String get puzzleThemeMix => 'Problèmes variés';

  @override
  String get puzzleThemeMixDescription => 'Un peu de tout. Vous ne savez pas à quoi vous attendre! Comme dans une vraie partie.';

  @override
  String get puzzleThemePlayerGames => 'Parties de joueurs';

  @override
  String get puzzleThemePlayerGamesDescription => 'Problèmes tirés de vos parties ou de celles d\'autres joueurs.';

  @override
  String puzzleThemePuzzleDownloadInformation(String param) {
    return 'Ces problèmes sont du domaine public et peuvent être téléchargés sur $param.';
  }

  @override
  String get searchSearch => 'Recherche';

  @override
  String get settingsSettings => 'Paramètres';

  @override
  String get settingsCloseAccount => 'Fermer votre compte';

  @override
  String get settingsManagedAccountCannotBeClosed => 'Votre compte est géré et ne peut pas être fermé.';

  @override
  String get settingsCantOpenSimilarAccount => 'Vous ne serez pas autorisé à ouvrir un nouveau compte avec le même nom, même si la casse est différente.';

  @override
  String get settingsCancelKeepAccount => 'Annuler l\'opération et conserver mon compte';

  @override
  String get settingsCloseAccountAreYouSure => 'Êtes-vous sûr de vouloir fermer votre compte?';

  @override
  String get settingsThisAccountIsClosed => 'Ce compte a été fermé.';

  @override
  String get playWithAFriend => 'Jouer avec un(e) ami(e)';

  @override
  String get playWithTheMachine => 'Jouer contre l\'ordinateur';

  @override
  String get toInviteSomeoneToPlayGiveThisUrl => 'Pour inviter quelqu\'un à jouer, donnez-lui ce lien';

  @override
  String get gameOver => 'Partie terminée';

  @override
  String get waitingForOpponent => 'En attente de votre adversaire';

  @override
  String get orLetYourOpponentScanQrCode => 'Ou laissez votre adversaire scanner ce code QR';

  @override
  String get waiting => 'En attente';

  @override
  String get yourTurn => 'À votre tour';

  @override
  String aiNameLevelAiLevel(String param1, String param2) {
    return '$param1 niveau $param2';
  }

  @override
  String get level => 'Niveau';

  @override
  String get strength => 'Niveau';

  @override
  String get toggleTheChat => 'Activer/désactiver la discussion';

  @override
  String get chat => 'Discussion';

  @override
  String get resign => 'Abandonner';

  @override
  String get checkmate => 'Échec et mat';

  @override
  String get stalemate => 'Pat';

  @override
  String get white => 'Blancs';

  @override
  String get black => 'Noirs';

  @override
  String get asWhite => 'avec les blancs';

  @override
  String get asBlack => 'avec les noirs';

  @override
  String get randomColor => 'Couleur aléatoire';

  @override
  String get createAGame => 'Créer une partie';

  @override
  String get whiteIsVictorious => 'Victoire des Blancs';

  @override
  String get blackIsVictorious => 'Victoire des Noirs';

  @override
  String get youPlayTheWhitePieces => 'Vous jouez avec les blancs';

  @override
  String get youPlayTheBlackPieces => 'Vous jouez avec les noirs';

  @override
  String get itsYourTurn => 'C\'est votre tour !';

  @override
  String get cheatDetected => 'Tricherie détectée';

  @override
  String get kingInTheCenter => 'Roi au centre';

  @override
  String get threeChecks => 'Trois échecs';

  @override
  String get raceFinished => 'Course terminée';

  @override
  String get variantEnding => 'Fin par variante';

  @override
  String get newOpponent => 'Nouvel adversaire';

  @override
  String get yourOpponentWantsToPlayANewGameWithYou => 'Votre adversaire souhaite jouer une nouvelle partie avec vous';

  @override
  String get joinTheGame => 'Rejoindre la partie';

  @override
  String get whitePlays => 'Trait aux Blancs';

  @override
  String get blackPlays => 'Trait aux Noirs';

  @override
  String get opponentLeftChoices => 'Votre adversaire a peut-être quitté la partie. Vous pouvez soit attendre son retour, soit revendiquer la nulle ou la victoire.';

  @override
  String get forceResignation => 'Revendiquer la victoire';

  @override
  String get forceDraw => 'Déclarer la nulle';

  @override
  String get talkInChat => 'Soyez courtois dans le chat.';

  @override
  String get theFirstPersonToComeOnThisUrlWillPlayWithYou => 'La première personne qui cliquera sur ce lien jouera avec vous.';

  @override
  String get whiteResigned => 'Les Blancs abandonnent';

  @override
  String get blackResigned => 'Les Noirs abandonnent';

  @override
  String get whiteLeftTheGame => 'Les Blancs ont quitté la partie';

  @override
  String get blackLeftTheGame => 'Les Noirs ont quitté la partie';

  @override
  String get whiteDidntMove => 'Les Blancs n\'ont pas bougé';

  @override
  String get blackDidntMove => 'Les Noirs n\'ont pas bougé';

  @override
  String get requestAComputerAnalysis => 'Demander une analyse automatique';

  @override
  String get computerAnalysis => 'Analyse de l\'ordinateur';

  @override
  String get computerAnalysisAvailable => 'Analyse de l\'ordinateur disponible';

  @override
  String get computerAnalysisDisabled => 'Analyse de l\'ordinateur désactivée';

  @override
  String get analysis => 'Échiquier d\'analyse';

  @override
  String depthX(String param) {
    return 'Profondeur $param';
  }

  @override
  String get usingServerAnalysis => 'Analyse serveur en cours';

  @override
  String get loadingEngine => 'Chargement en cours...';

  @override
  String get calculatingMoves => 'Calcul des coups...';

  @override
  String get engineFailed => 'Erreur lors du chargement du moteur';

  @override
  String get cloudAnalysis => 'Analyse dans le cloud';

  @override
  String get goDeeper => 'Analyser plus profondément';

  @override
  String get showThreat => 'Voir la menace';

  @override
  String get inLocalBrowser => 'dans le navigateur local';

  @override
  String get toggleLocalEvaluation => 'Activer/désactiver l\'évaluation locale';

  @override
  String get promoteVariation => 'Promouvoir la variante';

  @override
  String get makeMainLine => 'En faire la variante principale';

  @override
  String get deleteFromHere => 'Supprimer à partir d\'ici';

  @override
  String get collapseVariations => 'Fermer les variantes';

  @override
  String get expandVariations => 'Afficher les variantes';

  @override
  String get forceVariation => 'Forcer la variante';

  @override
  String get copyVariationPgn => 'Copier le PGN de la variante';

  @override
  String get move => 'Coup';

  @override
  String get variantLoss => 'Perte (variante)';

  @override
  String get variantWin => 'Gain (variante)';

  @override
  String get insufficientMaterial => 'Matériel insuffisant';

  @override
  String get pawnMove => 'Coup de pion';

  @override
  String get capture => 'Prise';

  @override
  String get close => 'Fermer';

  @override
  String get winning => 'Gagnant';

  @override
  String get losing => 'Perdant';

  @override
  String get drawn => 'Nulle';

  @override
  String get unknown => 'Inconnu';

  @override
  String get database => 'Base de données';

  @override
  String get whiteDrawBlack => 'Blancs / Nulle / Noirs';

  @override
  String averageRatingX(String param) {
    return 'Classement moyen : $param';
  }

  @override
  String get recentGames => 'Parties récentes';

  @override
  String get topGames => 'Meilleures parties';

  @override
  String masterDbExplanation(String param1, String param2, String param3) {
    return 'Deux millions de parties jouées en tournois FIDE >$param1 de $param2 à $param3';
  }

  @override
  String get dtzWithRounding => 'DTZ50\'\' arrondi, basé sur le nombre de demi-coups jusqu\'à la prochaine capture ou le prochain coup de pion';

  @override
  String get noGameFound => 'Aucune partie trouvée';

  @override
  String get maxDepthReached => 'Profondeur maximale atteinte !';

  @override
  String get maybeIncludeMoreGamesFromThePreferencesMenu => 'Peut-être inclure plus de parties depuis le menu préférences ?';

  @override
  String get openings => 'Ouvertures';

  @override
  String get openingExplorer => 'Explorateur d\'ouvertures';

  @override
  String get openingEndgameExplorer => 'Explorateur d\'ouvertures/de finales';

  @override
  String xOpeningExplorer(String param) {
    return '$param explorateur d\'ouvertures';
  }

  @override
  String get playFirstOpeningEndgameExplorerMove => 'Jouer le premier coup dans l\'explorateur d\'ouverture/de finale';

  @override
  String get winPreventedBy50MoveRule => 'Gain empêché par la règle des 50 coups';

  @override
  String get lossSavedBy50MoveRule => 'Défaite évitée par la règle des 50 coups';

  @override
  String get winOr50MovesByPriorMistake => 'Victoire ou 50 coups par suite d\'une erreur';

  @override
  String get lossOr50MovesByPriorMistake => 'Défaite ou 50 coups par suite d\'une erreur';

  @override
  String get unknownDueToRounding => 'Victoire/défaite garantie uniquement si la variante recommandée de la table de finale a été suivie depuis la dernière capture ou le dernier coup de pion, en raison de l’arrondissement possible de valeurs DTZ faisant partie de tables de finale Syzygy.';

  @override
  String get allSet => 'Tout est prêt !';

  @override
  String get importPgn => 'Importer le PGN';

  @override
  String get delete => 'Effacer';

  @override
  String get deleteThisImportedGame => 'Effacer cette partie importée ?';

  @override
  String get replayMode => 'Rejouer la partie';

  @override
  String get realtimeReplay => 'Temps réel';

  @override
  String get byCPL => 'Par erreurs';

  @override
  String get enable => 'Activée';

  @override
  String get bestMoveArrow => 'Flèche du meilleur coup';

  @override
  String get showVariationArrows => 'Afficher les flèches de variantes';

  @override
  String get evaluationGauge => 'Jauge d\'évaluation';

  @override
  String get multipleLines => 'Lignes d\'analyse';

  @override
  String get cpus => 'Processeurs';

  @override
  String get memory => 'Mémoire';

  @override
  String get infiniteAnalysis => 'Analyse infinie';

  @override
  String get removesTheDepthLimit => 'Désactive la profondeur limitée et fait chauffer votre ordinateur';

  @override
  String get blunder => 'Gaffe';

  @override
  String get mistake => 'Erreur';

  @override
  String get inaccuracy => 'Imprécision';

  @override
  String get moveTimes => 'Temps par coup';

  @override
  String get flipBoard => 'Tourner l\'échiquier';

  @override
  String get threefoldRepetition => 'Triple répétition';

  @override
  String get claimADraw => 'Revendiquer la partie nulle';

  @override
  String get offerDraw => 'Proposer la nulle';

  @override
  String get draw => 'Partie nulle';

  @override
  String get drawByMutualAgreement => 'Partie nulle par accord mutuel';

  @override
  String get fiftyMovesWithoutProgress => 'Cinquante coups joués sans progrès';

  @override
  String get currentGames => 'Parties en cours';

  @override
  String get viewInFullSize => 'Agrandir';

  @override
  String get logOut => 'Déconnexion';

  @override
  String get signIn => 'Connexion';

  @override
  String get rememberMe => 'Se souvenir de moi';

  @override
  String get youNeedAnAccountToDoThat => 'Compte d\'utilisateur requis';

  @override
  String get signUp => 'S\'inscrire';

  @override
  String get computersAreNotAllowedToPlay => 'Les ordinateurs et les joueurs assistés par ordinateur ne sont pas autorisés à jouer. Veuillez ne pas vous aider de moteurs d\'analyse, de bases de données ou d\'autres joueurs pendant la partie. Notez également qu\'il est fortement déconseillé de créer plusieurs comptes. Le multi-compte excessif mènera à l\'exclusion.';

  @override
  String get games => 'Parties';

  @override
  String get forum => 'Forum';

  @override
  String xPostedInForumY(String param1, String param2) {
    return '$param1 a posté dans le forum $param2';
  }

  @override
  String get latestForumPosts => 'Derniers posts du forum';

  @override
  String get players => 'Joueurs';

  @override
  String get friends => 'Amis';

  @override
  String get otherPlayers => 'autres joueurs';

  @override
  String get discussions => 'Discussions';

  @override
  String get today => 'Aujourd\'hui';

  @override
  String get yesterday => 'Hier';

  @override
  String get minutesPerSide => 'Minutes par joueur';

  @override
  String get variant => 'Variante';

  @override
  String get variants => 'Variantes';

  @override
  String get timeControl => 'Cadence';

  @override
  String get realTime => 'Temps réel';

  @override
  String get correspondence => 'Correspondance';

  @override
  String get daysPerTurn => 'Jours par coup';

  @override
  String get oneDay => 'Un jour';

  @override
  String get time => 'Temps';

  @override
  String get rating => 'Classement';

  @override
  String get ratingStats => 'Statistiques de classement';

  @override
  String get username => 'Nom d\'utilisateur';

  @override
  String get usernameOrEmail => 'Nom d\'utilisateur ou courriel';

  @override
  String get changeUsername => 'Modifier le nom d\'utilisateur';

  @override
  String get changeUsernameNotSame => 'Seules les majuscules et les minuscules peuvent être changées - ex. JeanDupont plutôt que jeandupont.';

  @override
  String get changeUsernameDescription => 'Modifiez votre nom d\'utilisateur. Vous pouvez le faire une fois seulement. Seule la casse des lettres peut être modifiée.';

  @override
  String get signupUsernameHint => 'Assurez-vous de choisir un nom d\'utilisateur convenable. Vous ne pourrez pas le modifier et tout nom d\'utilisateur inapproprié entraînera la fermeture du compte !';

  @override
  String get signupEmailHint => 'Nous l\'utiliserons uniquement pour la réinitialisation du mot de passe.';

  @override
  String get password => 'Mot de passe';

  @override
  String get changePassword => 'Changer votre mot de passe';

  @override
  String get changeEmail => 'Changer votre courriel';

  @override
  String get email => 'Courriel';

  @override
  String get passwordReset => 'Réinitialisation du mot de passe';

  @override
  String get forgotPassword => 'Mot de passe oublié ?';

  @override
  String get error_weakPassword => 'Ce mot de passe est très courant et trop facile à deviner.';

  @override
  String get error_namePassword => 'N\'employez pas votre nom d\'utilisateur comme mot de passe.';

  @override
  String get blankedPassword => 'Vous avez utilisé le même mot de passe sur un autre site, et ce site a été compromis. Pour assurer la sécurité de votre compte Lichess, vous devez établir un nouveau mot de passe. Merci de votre compréhension.';

  @override
  String get youAreLeavingLichess => 'Vous quittez Lichess';

  @override
  String get neverTypeYourPassword => 'N\'utilisez jamais votre mot de passe Lichess sur un autre site !';

  @override
  String proceedToX(String param) {
    return 'Continuer vers $param';
  }

  @override
  String get passwordSuggestion => 'N\'utilisez pas un mot de passe suggéré par une autre personne. Elle pourrait l\'utiliser pour voler votre compte.';

  @override
  String get emailSuggestion => 'N\'utilisez pas une adresse de courriel suggérée par une autre personne. Celle-ci pourrait l\'utiliser pour voler votre compte.';

  @override
  String get emailConfirmHelp => 'Aide sur la confirmation par courriel';

  @override
  String get emailConfirmNotReceived => 'Vous n\'avez pas reçu votre courriel de confirmation après votre inscription?';

  @override
  String get whatSignupUsername => 'Avec quel nom d\'utilisateur vous êtes-vous inscrit?';

  @override
  String usernameNotFound(String param) {
    return 'Nous n\'avons trouvé aucun utilisateur de ce nom : $param.';
  }

  @override
  String get usernameCanBeUsedForNewAccount => 'Vous pouvez utiliser ce nom d\'utilisateur pour créer un nouveau compte.';

  @override
  String emailSent(String param) {
    return 'Nous avons envoyé un courriel à $param.';
  }

  @override
  String get emailCanTakeSomeTime => 'L\'arrivée du courriel peut prendre un peu de temps.';

  @override
  String get refreshInboxAfterFiveMinutes => 'Attendez 5 minutes et rafraîchissez votre boîte de réception.';

  @override
  String get checkSpamFolder => 'Vérifiez aussi votre dossier de pourriel, il pourrait s\'y trouver. Si c\'est le cas, marquez-le comme non-pourriel.';

  @override
  String get emailForSignupHelp => 'Si rien ne marche, envoyez-nous ce courriel :';

  @override
  String copyTextToEmail(String param) {
    return 'Copiez et collez le texte ci-dessus et envoyez-le à $param';
  }

  @override
  String get waitForSignupHelp => 'Nous vous contacterons sous peu pour vous aider à compléter votre inscription.';

  @override
  String accountConfirmed(String param) {
    return 'L\'inscription de l\'utilisateur $param a été confirmée avec succès.';
  }

  @override
  String accountCanLogin(String param) {
    return 'Vous pouvez désormais vous connecter en tant que $param.';
  }

  @override
  String get accountConfirmationEmailNotNeeded => 'Vous n\'avez pas besoin d\'un courriel de confirmation.';

  @override
  String accountClosed(String param) {
    return 'Le compte de $param est fermé.';
  }

  @override
  String accountRegisteredWithoutEmail(String param) {
    return 'Le compte $param a été enregistré sans courriel.';
  }

  @override
  String get rank => 'Rang';

  @override
  String rankX(String param) {
    return 'Classement : $param';
  }

  @override
  String get gamesPlayed => 'Parties jouées';

  @override
  String get ok => 'OK';

  @override
  String get cancel => 'Annuler';

  @override
  String get whiteTimeOut => 'Temps blanc écoulé';

  @override
  String get blackTimeOut => 'Temps noir écoulé';

  @override
  String get drawOfferSent => 'Proposition de nulle envoyée';

  @override
  String get drawOfferAccepted => 'Proposition de nulle acceptée';

  @override
  String get drawOfferCanceled => 'Proposition de nulle annulée';

  @override
  String get whiteOffersDraw => 'Les Blancs proposent la nulle';

  @override
  String get blackOffersDraw => 'Les Noirs proposent la nulle';

  @override
  String get whiteDeclinesDraw => 'Les Blancs refusent la nulle';

  @override
  String get blackDeclinesDraw => 'Les Noirs refusent la nulle';

  @override
  String get yourOpponentOffersADraw => 'Votre adversaire propose la nulle';

  @override
  String get accept => 'Accepter';

  @override
  String get decline => 'Refuser';

  @override
  String get playingRightNow => 'En cours';

  @override
  String get eventInProgress => 'Parties en cours';

  @override
  String get finished => 'Terminé';

  @override
  String get abortGame => 'Annuler la partie';

  @override
  String get gameAborted => 'Partie annulée';

  @override
  String get standard => 'Standard';

  @override
  String get customPosition => 'Position personnalisée';

  @override
  String get unlimited => 'Illimité';

  @override
  String get mode => 'Mode';

  @override
  String get casual => 'Amical';

  @override
  String get rated => 'Classé';

  @override
  String get casualTournament => 'Amical';

  @override
  String get ratedTournament => 'Classé';

  @override
  String get thisGameIsRated => 'Cette partie est classée';

  @override
  String get rematch => 'Revanche';

  @override
  String get rematchOfferSent => 'Proposition de revanche envoyée';

  @override
  String get rematchOfferAccepted => 'Proposition de revanche acceptée';

  @override
  String get rematchOfferCanceled => 'Proposition de revanche annulée';

  @override
  String get rematchOfferDeclined => 'Proposition de revanche déclinée';

  @override
  String get cancelRematchOffer => 'Annuler la proposition de revanche';

  @override
  String get viewRematch => 'Voir la revanche';

  @override
  String get confirmMove => 'Confirmer le coup';

  @override
  String get play => 'Jouer';

  @override
  String get inbox => 'Boîte de réception';

  @override
  String get chatRoom => 'Salon de discussion';

  @override
  String get loginToChat => 'Connectez-vous pour discuter';

  @override
  String get youHaveBeenTimedOut => 'Vous avez été suspendu temporairement.';

  @override
  String get spectatorRoom => 'Salon des spectateurs';

  @override
  String get composeMessage => 'Écrire un message';

  @override
  String get subject => 'Sujet';

  @override
  String get send => 'Envoyer';

  @override
  String get incrementInSeconds => 'Incrément en secondes';

  @override
  String get freeOnlineChess => 'Jeu d\'échecs gratuit en ligne';

  @override
  String get exportGames => 'Exporter les parties';

  @override
  String get ratingRange => 'Classement de vos adversaires';

  @override
  String get thisAccountViolatedTos => 'Ce compte a enfreint les conditions d\'utilisation de Lichess';

  @override
  String get openingExplorerAndTablebase => 'Arbre d\'ouvertures & tables de finales';

  @override
  String get takeback => 'Annuler le coup';

  @override
  String get proposeATakeback => 'Proposer l\'annulation du coup';

  @override
  String get takebackPropositionSent => 'Annulation du coup proposée';

  @override
  String get takebackPropositionDeclined => 'Annulation du coup déclinée';

  @override
  String get takebackPropositionAccepted => 'Annulation du coup acceptée';

  @override
  String get takebackPropositionCanceled => 'Annulation du coup annulée';

  @override
  String get yourOpponentProposesATakeback => 'Votre adversaire propose l\'annulation du coup';

  @override
  String get bookmarkThisGame => 'Ajouter cette partie aux favorites';

  @override
  String get tournament => 'Tournoi';

  @override
  String get tournaments => 'Tournois';

  @override
  String get tournamentPoints => 'Score de tournoi';

  @override
  String get viewTournament => 'Voir le tournoi';

  @override
  String get backToTournament => 'Retour au tournoi';

  @override
  String get noDrawBeforeSwissLimit => 'Vous ne pouvez pas faire de nulle avant 30 coups dans un tournoi suisse.';

  @override
  String get thematic => 'Thématique';

  @override
  String yourPerfRatingIsProvisional(String param) {
    return 'Votre classement $param est provisoire';
  }

  @override
  String yourPerfRatingIsTooHigh(String param1, String param2) {
    return 'Votre cote $param1 ($param2) est trop élevée';
  }

  @override
  String yourTopWeeklyPerfRatingIsTooHigh(String param1, String param2) {
    return 'Votre meilleure cote hebdomadaire de $param1 ($param2) est trop élevée';
  }

  @override
  String yourPerfRatingIsTooLow(String param1, String param2) {
    return 'Votre cote de $param1 ($param2) est trop faible';
  }

  @override
  String ratedMoreThanInPerf(String param1, String param2) {
    return 'Cote ≥ $param1 en $param2';
  }

  @override
  String ratedLessThanInPerf(String param1, String param2) {
    return 'Cote ≤ $param1 en $param2';
  }

  @override
  String mustBeInTeam(String param) {
    return 'Vous devez faire partie de l\'équipe $param';
  }

  @override
  String youAreNotInTeam(String param) {
    return 'Vous ne faites pas partie de l\'équipe $param';
  }

  @override
  String get backToGame => 'Retour à la partie';

  @override
  String get siteDescription => 'Jeu d\'échecs gratuit en ligne. Jouez aux échecs immédiatement avec une interface simple. Pas d\'inscription obligatoire, pas de publicité, pas de plugin. Jouez aux échecs avec des adversaires en ligne, avec des amis ou contre l\'ordinateur.';

  @override
  String xJoinedTeamY(String param1, String param2) {
    return '$param1 a rejoint l\'équipe $param2';
  }

  @override
  String xCreatedTeamY(String param1, String param2) {
    return '$param1 a créé l\'équipe $param2';
  }

  @override
  String get startedStreaming => 'a commencé une diffusion en direct';

  @override
  String xStartedStreaming(String param) {
    return '$param a commencé une diffusion en direct';
  }

  @override
  String get averageElo => 'Classement moyen';

  @override
  String get location => 'Localisation';

  @override
  String get filterGames => 'Filtrer les parties';

  @override
  String get reset => 'Réinitialiser';

  @override
  String get apply => 'Appliquer';

  @override
  String get save => 'Enregistrer';

  @override
  String get leaderboard => 'Classements';

  @override
  String get screenshotCurrentPosition => 'Capture d\'écran de la position actuelle';

  @override
  String get gameAsGIF => 'Enregistrer la partie en GIF';

  @override
  String get pasteTheFenStringHere => 'Coller le FEN ici';

  @override
  String get pasteThePgnStringHere => 'Coller le PGN ici';

  @override
  String get orUploadPgnFile => 'Ou téléverser un fichier PGN';

  @override
  String get fromPosition => 'Depuis une position';

  @override
  String get continueFromHere => 'Continuer depuis cette position';

  @override
  String get toStudy => 'Étude';

  @override
  String get importGame => 'Importer une partie';

  @override
  String get importGameExplanation => 'Quand vous collez une partie en PGN vous pouvez la rejouer, consulter l\'analyse de l\'ordinateur, utiliser le tchat et partager le lien.';

  @override
  String get importGameCaveat => 'Les variantes seront effacées. Pour les conserver, importez le PGN dans une étude.';

  @override
  String get importGameDataPrivacyWarning => 'Cette partie en format PGN n\'est pas privée. Pour importer une partie en privé, utilisez une étude.';

  @override
  String get thisIsAChessCaptcha => 'Ceci est un CAPTCHA d\'échecs.';

  @override
  String get clickOnTheBoardToMakeYourMove => 'Cliquez sur l\'échiquier pour jouer un coup, et prouver que vous êtes humain.';

  @override
  String get captcha_fail => 'Vous devez résoudre le diagramme d\'échecs.';

  @override
  String get notACheckmate => 'Ce n\'est pas un échec et mat';

  @override
  String get whiteCheckmatesInOneMove => 'Les Blancs matent en un coup';

  @override
  String get blackCheckmatesInOneMove => 'Les Noirs matent en un coup';

  @override
  String get retry => 'Réessayer';

  @override
  String get reconnecting => 'Reconnexion en cours';

  @override
  String get noNetwork => 'Hors ligne';

  @override
  String get favoriteOpponents => 'Adversaires préférés';

  @override
  String get follow => 'Suivre';

  @override
  String get following => 'Suivi';

  @override
  String get unfollow => 'Ne plus suivre';

  @override
  String followX(String param) {
    return 'Suivre $param';
  }

  @override
  String unfollowX(String param) {
    return 'Ne plus suivre $param';
  }

  @override
  String get block => 'Bloquer';

  @override
  String get blocked => 'Bloqué';

  @override
  String get unblock => 'Débloquer';

  @override
  String xStartedFollowingY(String param1, String param2) {
    return '$param1 a suivi $param2';
  }

  @override
  String get more => 'Plus';

  @override
  String get memberSince => 'Membre depuis';

  @override
  String lastSeenActive(String param) {
    return 'Actif $param';
  }

  @override
  String get player => 'Joueur';

  @override
  String get list => 'Liste';

  @override
  String get graph => 'Graphique';

  @override
  String get required => 'Requis.';

  @override
  String get openTournaments => 'Tournois ouverts';

  @override
  String get duration => 'Durée';

  @override
  String get winner => 'Vainqueur';

  @override
  String get standing => 'Classement';

  @override
  String get createANewTournament => 'Créer un nouveau tournoi';

  @override
  String get tournamentCalendar => 'Calendrier des tournois';

  @override
  String get conditionOfEntry => 'Condition d\'admission :';

  @override
  String get advancedSettings => 'Paramètres avancés';

  @override
  String get safeTournamentName => 'Choisissez un sage nom pour le tournoi.';

  @override
  String get inappropriateNameWarning => 'Toute conduite inappropriée aboutira à la fermeture de votre compte.';

  @override
  String get emptyTournamentName => 'Laissez vide pour que le tournoi soit nommé d\'après le nom d\'un grand maître.';

  @override
  String get makePrivateTournament => 'Rendre le tournoi privé et en restreindre l\'accès avec un mot de passe';

  @override
  String get join => 'Rejoindre';

  @override
  String get withdraw => 'Renoncer';

  @override
  String get points => 'Points';

  @override
  String get wins => 'Victoires';

  @override
  String get losses => 'Défaites';

  @override
  String get createdBy => 'Créé par';

  @override
  String get tournamentIsStarting => 'Le tournoi commence';

  @override
  String get tournamentPairingsAreNowClosed => 'Les appariements du tournoi sont maintenant terminés.';

  @override
  String standByX(String param) {
    return 'Appariements des joueurs, tenez-vous prêt $param !';
  }

  @override
  String get pause => 'Pause';

  @override
  String get resume => 'Reprendre';

  @override
  String get youArePlaying => 'Vous êtes en train de jouer !';

  @override
  String get winRate => 'Taux de victoires';

  @override
  String get berserkRate => 'Taux de berserk';

  @override
  String get performance => 'Performance';

  @override
  String get tournamentComplete => 'Tournoi complet';

  @override
  String get movesPlayed => 'Coups joués';

  @override
  String get whiteWins => 'Gains blancs';

  @override
  String get blackWins => 'Gains noirs';

  @override
  String get drawRate => 'Taux de nulles';

  @override
  String get draws => 'Nulles';

  @override
  String nextXTournament(String param) {
    return 'Prochain tournoi de $param :';
  }

  @override
  String get averageOpponent => 'Opposition moyenne';

  @override
  String get boardEditor => 'Éditeur de position';

  @override
  String get setTheBoard => 'Entrer une position';

  @override
  String get popularOpenings => 'Ouvertures courantes';

  @override
  String get endgamePositions => 'Positions de finale';

  @override
  String chess960StartPosition(String param) {
    return 'Position de départ – Chess960 : $param';
  }

  @override
  String get startPosition => 'Position de départ';

  @override
  String get clearBoard => 'Vider l\'échiquier';

  @override
  String get loadPosition => 'Charger une position';

  @override
  String get isPrivate => 'Privé';

  @override
  String reportXToModerators(String param) {
    return 'Signaler $param aux modérateurs';
  }

  @override
  String profileCompletion(String param) {
    return 'Profil rempli à $param';
  }

  @override
  String xRating(String param) {
    return 'Classement $param';
  }

  @override
  String get ifNoneLeaveEmpty => 'Sinon, laissez vide';

  @override
  String get profile => 'Profil';

  @override
  String get editProfile => 'Modifier le profil';

  @override
  String get realName => 'Nom réel';

  @override
  String get setFlair => 'Choisir votre émoji';

  @override
  String get flair => 'Émoji';

  @override
  String get youCanHideFlair => 'Un paramètre permet de cacher les émojis des utilisateurs sur tout le site.';

  @override
  String get biography => 'Biographie';

  @override
  String get countryRegion => 'Pays ou région';

  @override
  String get thankYou => 'Merci !';

  @override
  String get socialMediaLinks => 'Liens des réseaux sociaux';

  @override
  String get oneUrlPerLine => 'Une URL par ligne.';

  @override
  String get inlineNotation => 'Notation en ligne';

  @override
  String get makeAStudy => 'Pour conserver et partager vos analyses, créez une étude.';

  @override
  String get clearSavedMoves => 'Supprimer les coups';

  @override
  String get previouslyOnLichessTV => 'Précédemment sur Lichess TV';

  @override
  String get onlinePlayers => 'Joueurs en ligne';

  @override
  String get activePlayers => 'Joueurs actifs';

  @override
  String get bewareTheGameIsRatedButHasNoClock => 'Attention, la partie est classée, mais sans limite de temps !';

  @override
  String get success => 'Réussi';

  @override
  String get automaticallyProceedToNextGameAfterMoving => 'Aller automatiquement à la prochaine partie après chaque coup';

  @override
  String get autoSwitch => 'Changement automatique';

  @override
  String get puzzles => 'Problèmes';

  @override
  String get onlineBots => 'Bots en ligne';

  @override
  String get name => 'Nom';

  @override
  String get description => 'Description';

  @override
  String get descPrivate => 'Description privée';

  @override
  String get descPrivateHelp => 'Texte que seuls les membres de l\'équipe verront. Si utilisé, remplace la description publique pour les membres de l\'équipe.';

  @override
  String get no => 'Non';

  @override
  String get yes => 'Oui';

  @override
  String get website => 'Site Web';

  @override
  String get mobile => 'Appli mobile';

  @override
  String get help => 'Aide :';

  @override
  String get createANewTopic => 'Créer un nouveau sujet';

  @override
  String get topics => 'Sujets';

  @override
  String get posts => 'Messages';

  @override
  String get lastPost => 'Dernier message';

  @override
  String get views => 'Vues';

  @override
  String get replies => 'Réponses';

  @override
  String get replyToThisTopic => 'Répondre à ce sujet';

  @override
  String get reply => 'Répondre';

  @override
  String get message => 'Message';

  @override
  String get createTheTopic => 'Créer un sujet';

  @override
  String get reportAUser => 'Signaler un utilisateur';

  @override
  String get user => 'Utilisateur';

  @override
  String get reason => 'Motif';

  @override
  String get whatIsIheMatter => 'Quel est le problème ?';

  @override
  String get cheat => 'Triche';

  @override
  String get troll => 'Troll';

  @override
  String get other => 'Autre';

  @override
  String get reportCheatBoostHelp => 'Collez le lien vers la ou les parties et expliquez pourquoi le comportement de l\'utilisateur est inapproprié. Ne dites pas juste « il triche »; expliquez comment vous êtes arrivé à cette conclusion.';

  @override
  String get reportUsernameHelp => 'Expliquez pourquoi ce nom d\'utilisateur est offensant. Ne dites pas simplement qu\'il est choquant ou inapproprié; expliquez comment vous êtes arrivé à cette conclusion, surtout si l\'insulte n\'est pas claire, n\'est pas en anglais, est en argot ou a une connotation historique ou culturelle.';

  @override
  String get reportProcessedFasterInEnglish => 'Votre rapport sera traité plus rapidement s\'il est rédigé en anglais.';

  @override
  String get error_provideOneCheatedGameLink => 'Merci de fournir au moins un lien vers une partie où il y a eu triche.';

  @override
  String by(String param) {
    return 'par $param';
  }

  @override
  String importedByX(String param) {
    return 'Importée par $param';
  }

  @override
  String get thisTopicIsNowClosed => 'Ce sujet est maintenant fermé.';

  @override
  String get blog => 'Blog';

  @override
  String get notes => 'Notes';

  @override
  String get typePrivateNotesHere => 'Écrivez vos notes privées ici';

  @override
  String get writeAPrivateNoteAboutThisUser => 'Écrire une note privée sur cet utilisateur';

  @override
  String get noNoteYet => 'Aucune note';

  @override
  String get invalidUsernameOrPassword => 'Nom d\'utilisateur ou mot de passe invalide';

  @override
  String get incorrectPassword => 'Mot de passe incorrect';

  @override
  String get invalidAuthenticationCode => 'Code d\'authentification non valide';

  @override
  String get emailMeALink => 'Envoyez-moi un lien';

  @override
  String get currentPassword => 'Mot de passe actuel';

  @override
  String get newPassword => 'Nouveau mot de passe';

  @override
  String get newPasswordAgain => 'Nouveau mot de passe (encore)';

  @override
  String get newPasswordsDontMatch => 'Les nouveaux mots de passe ne correspondent pas';

  @override
  String get newPasswordStrength => 'Robustesse du mot de passe';

  @override
  String get clockInitialTime => 'Temps initial à la pendule';

  @override
  String get clockIncrement => 'Incrément de la pendule';

  @override
  String get privacy => 'Confidentialité';

  @override
  String get privacyPolicy => 'Politique de confidentialité';

  @override
  String get letOtherPlayersFollowYou => 'Autoriser les autres joueurs à vous suivre';

  @override
  String get letOtherPlayersChallengeYou => 'Autoriser les autres joueurs à vous défier';

  @override
  String get letOtherPlayersInviteYouToStudy => 'Autoriser les autres joueurs à vous inviter à une analyse partagée';

  @override
  String get sound => 'Son';

  @override
  String get none => 'Aucune';

  @override
  String get fast => 'Rapide';

  @override
  String get normal => 'Normale';

  @override
  String get slow => 'Lente';

  @override
  String get insideTheBoard => 'Sur l\'échiquier';

  @override
  String get outsideTheBoard => 'En dehors de l\'échiquier';

  @override
  String get allSquaresOfTheBoard => 'Toutes les cases';

  @override
  String get onSlowGames => 'Durant les parties lentes';

  @override
  String get always => 'Toujours';

  @override
  String get never => 'Jamais';

  @override
  String xCompetesInY(String param1, String param2) {
    return '$param1 participe à $param2';
  }

  @override
  String get victory => 'Victoire';

  @override
  String get defeat => 'Défaite';

  @override
  String victoryVsYInZ(String param1, String param2, String param3) {
    return '$param1 contre $param2 en $param3';
  }

  @override
  String defeatVsYInZ(String param1, String param2, String param3) {
    return '$param1 contre $param2 en $param3';
  }

  @override
  String drawVsYInZ(String param1, String param2, String param3) {
    return '$param1 vs. $param2 en $param3';
  }

  @override
  String get timeline => 'Activité';

  @override
  String get starting => 'Début :';

  @override
  String get allInformationIsPublicAndOptional => 'Toutes les informations sont publiques et facultatives.';

  @override
  String get biographyDescription => 'Parlez de vous, de ce que vous aimez dans les échecs, vos ouvertures préférées, vos parties, vos joueurs préférés, ...';

  @override
  String get listBlockedPlayers => 'Lister les joueurs que vous avez bloqués';

  @override
  String get human => 'Humain';

  @override
  String get computer => 'Ordinateur';

  @override
  String get side => 'Côté';

  @override
  String get clock => 'Pendule';

  @override
  String get opponent => 'Adversaire';

  @override
  String get learnMenu => 'Apprendre';

  @override
  String get studyMenu => 'Étudier';

  @override
  String get practice => 'S\'entraîner';

  @override
  String get community => 'Communauté';

  @override
  String get tools => 'Outils';

  @override
  String get increment => 'Incrément';

  @override
  String get error_unknown => 'Valeur invalide';

  @override
  String get error_required => 'Ce champ est requis';

  @override
  String get error_email => 'Cette adresse courriel est invalide';

  @override
  String get error_email_acceptable => 'Cette adresse courriel est refusée. Double-cliquez dessus et réessayez.';

  @override
  String get error_email_unique => 'Adresse courriel invalide ou déjà utilisée';

  @override
  String get error_email_different => 'Vous utilisez déjà cette adresse courriel';

  @override
  String error_minLength(String param) {
    return 'Doit comporter au moins $param caractères';
  }

  @override
  String error_maxLength(String param) {
    return 'Doit comporter au plus $param caractères';
  }

  @override
  String error_min(String param) {
    return 'Doit être supérieur(e) ou égal(e) à $param';
  }

  @override
  String error_max(String param) {
    return 'Doit être inférieur(e) ou égal(e) à $param';
  }

  @override
  String ifRatingIsPlusMinusX(String param) {
    return 'Si son niveau est ± $param';
  }

  @override
  String get ifRegistered => 'Si inscrit';

  @override
  String get onlyExistingConversations => 'Conversations en cours seulement';

  @override
  String get onlyFriends => 'Seulement les amis';

  @override
  String get menu => 'Menu';

  @override
  String get castling => 'Roque';

  @override
  String get whiteCastlingKingside => 'Blancs O-O';

  @override
  String get blackCastlingKingside => 'Noirs O-O';

  @override
  String tpTimeSpentPlaying(String param) {
    return 'Temps total à jouer : $param';
  }

  @override
  String get watchGames => 'Regarder les parties';

  @override
  String tpTimeSpentOnTV(String param) {
    return 'Temps passé à la TV : $param';
  }

  @override
  String get watch => 'Regarder';

  @override
  String get videoLibrary => 'Vidéothèque';

  @override
  String get streamersMenu => 'Streamers';

  @override
  String get mobileApp => 'L\'application';

  @override
  String get webmasters => 'Webmestres';

  @override
  String get about => 'À propos';

  @override
  String aboutX(String param) {
    return 'À propos de $param';
  }

  @override
  String xIsAFreeYLibreOpenSourceChessServer(String param1, String param2) {
    return '$param1 est un serveur d\'échecs gratuit ($param2), libre, sans pubs et open source.';
  }

  @override
  String get really => 'pour de vrai';

  @override
  String get contribute => 'Contribuer';

  @override
  String get termsOfService => 'Conditions d\'utilisation';

  @override
  String get sourceCode => 'Code source';

  @override
  String get simultaneousExhibitions => 'Parties simultanées';

  @override
  String get host => 'Hôte';

  @override
  String hostColorX(String param) {
    return 'Couleur de l’hôte : $param';
  }

  @override
  String get yourPendingSimuls => 'Vos simultanées en attente';

  @override
  String get createdSimuls => 'Nouvelles simultanées';

  @override
  String get hostANewSimul => 'Créer une nouvelle simultanée';

  @override
  String get signUpToHostOrJoinASimul => 'Inscrivez-vous pour organiser une simultanée ou y participer';

  @override
  String get noSimulFound => 'Simultanée introuvable';

  @override
  String get noSimulExplanation => 'Cette simultanée n\'existe pas.';

  @override
  String get returnToSimulHomepage => 'Retour aux parties simultanées';

  @override
  String get aboutSimul => 'Une simultanée est une rencontre entre un joueur et plusieurs adversaires chacun sur un échiquier séparé.';

  @override
  String get aboutSimulImage => 'Sur 50 adversaires, Fischer a gagné 47 parties, fait 2 nulles et perdu 1 partie.';

  @override
  String get aboutSimulRealLife => 'Le concept est inspiré de la vie réelle, où le joueur passe d\'un échiquier à l\'autre pour jouer chaque coup.';

  @override
  String get aboutSimulRules => 'Quand la simultanée commence, chaque joueur débute une partie contre l\'hôte, qui a les Blancs. La simultanée prend fin lorsque toutes les parties sont terminées.';

  @override
  String get aboutSimulSettings => 'Les parties simultanées sont toujours amicales. Les revanches, l\'annulation de coups et la possibilité de donner du temps sont désactivées.';

  @override
  String get create => 'Créer';

  @override
  String get whenCreateSimul => 'Lorsque vous créez une simultanée, vouz affrontez plusieurs adversaires à la fois.';

  @override
  String get simulVariantsHint => 'Si vous sélectionnez plusieurs variantes, chaque joueur doit choisir laquelle jouer.';

  @override
  String get simulClockHint => 'Configuration de la cadence Fischer. Plus il y a d\'adversaires, plus vous pourriez avoir besoin de temps.';

  @override
  String get simulAddExtraTime => 'Vous pouvez ajouter du temps supplémentaire à votre pendule pour gérer la simultanée.';

  @override
  String get simulHostExtraTime => 'Temps supplémentaire de l\'hôte';

  @override
  String get simulAddExtraTimePerPlayer => 'Ajouter le temps initial à votre pendule pour chaque joueur participant à la simultanée';

  @override
  String get simulHostExtraTimePerPlayer => 'Temps additionnel ajouté à la pendule de l\'hôte pour chaque joueur';

  @override
  String get lichessTournaments => 'Tournois Lichess';

  @override
  String get tournamentFAQ => 'FAQ des tournois';

  @override
  String get timeBeforeTournamentStarts => 'Temps restant avant le début du tournoi';

  @override
  String get averageCentipawnLoss => 'Perte moyenne en centipions';

  @override
  String get accuracy => 'Précision';

  @override
  String get keyboardShortcuts => 'Raccourcis clavier';

  @override
  String get keyMoveBackwardOrForward => 'avancer/reculer';

  @override
  String get keyGoToStartOrEnd => 'aller au début/à la fin';

  @override
  String get keyCycleSelectedVariation => 'Changer de variante';

  @override
  String get keyShowOrHideComments => 'montrer/cacher les annotations';

  @override
  String get keyEnterOrExitVariation => 'entrer dans/sortir d\'une variante';

  @override
  String get keyRequestComputerAnalysis => 'Demandez une analyse informatique, apprenez de vos erreurs';

  @override
  String get keyNextLearnFromYourMistakes => 'Suivant (apprenez de vos erreurs)';

  @override
  String get keyNextBlunder => 'Gaffe suivante';

  @override
  String get keyNextMistake => 'Erreur suivante';

  @override
  String get keyNextInaccuracy => 'Imprécision suivante';

  @override
  String get keyPreviousBranch => 'Branche précédente';

  @override
  String get keyNextBranch => 'Branche suivante';

  @override
  String get toggleVariationArrows => 'Activer/désactiver les flèches de variantes';

  @override
  String get cyclePreviousOrNextVariation => 'Variante précédente/suivante';

  @override
  String get toggleGlyphAnnotations => 'Activer/désactiver les annotations en symboles';

  @override
  String get togglePositionAnnotations => 'Activer/désactiver les annotations de positions';

  @override
  String get variationArrowsInfo => 'Les flèches de variantes vous permettent de naviguer sans utiliser la liste des coups.';

  @override
  String get playSelectedMove => 'jouer le coup sélectionné';

  @override
  String get newTournament => 'Nouveau tournoi';

  @override
  String get tournamentHomeTitle => 'Tournoi réunissant plusieurs variantes et cadences';

  @override
  String get tournamentHomeDescription => 'Jouez des tournois d\'échecs palpitants ! Rejoignez un tournoi officiel programmé ou créez le vôtre. Bullet, Blitz, Classique, Chess960, King of the Hill, Threecheck et d\'autres options sont disponibles pour s\'amuser sans fin.';

  @override
  String get tournamentNotFound => 'Tournoi inexistant';

  @override
  String get tournamentDoesNotExist => 'Ce tournoi n\'existe pas.';

  @override
  String get tournamentMayHaveBeenCanceled => 'Il a peut-être été annulé, si tous les joueurs l\'ont quitté avant le début.';

  @override
  String get returnToTournamentsHomepage => 'Retour à la page des tournois';

  @override
  String weeklyPerfTypeRatingDistribution(String param) {
    return 'Distribution hebdomadaire des classements en $param';
  }

  @override
  String yourPerfTypeRatingIsRating(String param1, String param2) {
    return 'Votre classement en $param1 est de $param2.';
  }

  @override
  String youAreBetterThanPercentOfPerfTypePlayers(String param1, String param2) {
    return 'Vous êtes meilleur que $param1 des joueurs de $param2.';
  }

  @override
  String userIsBetterThanPercentOfPerfTypePlayers(String param1, String param2, String param3) {
    return '$param1 est meilleur que $param2 des joueurs de $param3.';
  }

  @override
  String betterThanPercentPlayers(String param1, String param2) {
    return 'Meilleur que $param1 des joueurs de $param2';
  }

  @override
  String youDoNotHaveAnEstablishedPerfTypeRating(String param) {
    return 'Vous n\'avez pas de classement établi en $param.';
  }

  @override
  String get yourRating => 'Votre cote';

  @override
  String get cumulative => 'Cumulé';

  @override
  String get glicko2Rating => 'Classement Glicko-2';

  @override
  String get checkYourEmail => 'Vérifiez vos emails';

  @override
  String get weHaveSentYouAnEmailClickTheLink => 'Nous vous avons envoyé un email. Visitez le lien qui s\'y trouve pour activer votre compte.';

  @override
  String get ifYouDoNotSeeTheEmailCheckOtherPlaces => 'Si vous ne trouvez pas l\'email dans votre boîte de réception, vérifiez dans vos emails indésirables ou autres dossiers.';

  @override
  String weHaveSentYouAnEmailTo(String param) {
    return 'Nous avons envoyé un email à $param. Cliquez le lien qui s\'y trouve pour réinitialiser votre mot de passe.';
  }

  @override
  String byRegisteringYouAgreeToBeBoundByOur(String param) {
    return 'En vous inscrivant, vous acceptez d\'être lié à nos $param.';
  }

  @override
  String readAboutOur(String param) {
    return 'En savoir plus sur notre $param.';
  }

  @override
  String get networkLagBetweenYouAndLichess => 'Latence du réseau entre vous et lichess';

  @override
  String get timeToProcessAMoveOnLichessServer => 'Temps nécessaire au traitement d\'un coup sur le serveur lichess';

  @override
  String get downloadAnnotated => 'Télécharger le PGN annoté';

  @override
  String get downloadRaw => 'Télécharger le PGN brut';

  @override
  String get downloadImported => 'Télécharger le PGN importé';

  @override
  String get crosstable => 'Historique des parties';

  @override
  String get youCanAlsoScrollOverTheBoardToMoveInTheGame => 'Vous pouvez aussi utiliser la molette sur l\'échiquier pour faire défiler la partie.';

  @override
  String get scrollOverComputerVariationsToPreviewThem => 'Survolez les variantes du moteur d\'analyse avec la souris pour les visualiser.';

  @override
  String get analysisShapesHowTo => 'Utilisez maj+clic ou clic-droit pour dessiner des cercles et des flèches sur l\'échiquier.';

  @override
  String get letOtherPlayersMessageYou => 'Permettre à d\'autres joueurs de vous envoyer des messages';

  @override
  String get receiveForumNotifications => 'Recevoir une notification lorsque votre nom est mentionné dans le forum';

  @override
  String get shareYourInsightsData => 'Partager les statistiques de vos parties générées par lichess';

  @override
  String get withNobody => 'Avec personne';

  @override
  String get withFriends => 'Avec mes amis';

  @override
  String get withEverybody => 'Avec tout le monde';

  @override
  String get kidMode => 'Mode enfants';

  @override
  String get kidModeIsEnabled => 'Le mode enfant est activé.';

  @override
  String get kidModeExplanation => 'Cela concerne la sécurité. Dans le mode enfants, toutes les communications du site sont désactivées. Activez ce mode pour vos enfants et pour les écoliers, afin de les protéger des autres utilisateurs.';

  @override
  String inKidModeTheLichessLogoGetsIconX(String param) {
    return 'Dans le mode enfants, l\'icône $param se rajoute au logo lichess pour que vous sachiez que les enfants sont en sécurité.';
  }

  @override
  String get askYourChessTeacherAboutLiftingKidMode => 'Votre compte est géré. Demandez à votre professeur d\'échecs de désactiver le mode enfant.';

  @override
  String get enableKidMode => 'Activer le mode enfants';

  @override
  String get disableKidMode => 'Désactiver le mode enfants';

  @override
  String get security => 'Sécurité';

  @override
  String get sessions => 'Sessions';

  @override
  String get revokeAllSessions => 'supprimer toutes les sessions';

  @override
  String get playChessEverywhere => 'Jouez aux échecs partout';

  @override
  String get asFreeAsLichess => 'Aussi gratuit que lichess';

  @override
  String get builtForTheLoveOfChessNotMoney => 'Construit pour l\'amour du jeu d\'échecs, pas pour l\'argent';

  @override
  String get everybodyGetsAllFeaturesForFree => 'Toutes les fonctionnalités sont gratuites pour tout le monde';

  @override
  String get zeroAdvertisement => 'Aucune publicité';

  @override
  String get fullFeatured => 'Tout Lichess, et encore plus';

  @override
  String get phoneAndTablet => 'Smartphones et tablettes';

  @override
  String get bulletBlitzClassical => 'Partie éclair, Rapide, Semi-Rapide';

  @override
  String get correspondenceChess => 'Échecs par correspondance';

  @override
  String get onlineAndOfflinePlay => 'Jouez en ligne ou hors-ligne';

  @override
  String get viewTheSolution => 'Regarder la solution';

  @override
  String get followAndChallengeFriends => 'Suivez et défiez vos amis !';

  @override
  String get noChallenges => 'Pas de défis.';

  @override
  String get gameAnalysis => 'Analyse de la partie';

  @override
  String xHostsY(String param1, String param2) {
    return '$param1 héberge $param2';
  }

  @override
  String xJoinsY(String param1, String param2) {
    return '$param1 rejoint $param2';
  }

  @override
  String xLikesY(String param1, String param2) {
    return '$param1 aime $param2';
  }

  @override
  String get quickPairing => 'Appariement rapide';

  @override
  String get lobby => 'Salon';

  @override
  String get anonymous => 'Anonyme';

  @override
  String yourScore(String param) {
    return 'Votre score : $param';
  }

  @override
  String get language => 'Langue';

  @override
  String get background => 'Arrière-plan';

  @override
  String get light => 'Lumineux';

  @override
  String get dark => 'Sombre';

  @override
  String get transparent => 'Transparent';

  @override
  String get deviceTheme => 'Thème de l\'appareil';

  @override
  String get backgroundImageUrl => 'URL de l\'image de fond :';

  @override
  String get board => 'Échiquier';

  @override
  String get size => 'Taille';

  @override
  String get opacity => 'Opacité';

  @override
  String get brightness => 'Luminosité';

  @override
  String get hue => 'Teinte';

  @override
  String get boardReset => 'Rétablir les couleurs par défaut';

  @override
  String get pieceSet => 'Jeu de pièces';

  @override
  String get embedInYourWebsite => 'Intégrer dans votre site web';

  @override
  String get usernameAlreadyUsed => 'Ce nom d\'utilisateur existe déjà, merci d\'en choisir un autre.';

  @override
  String get usernamePrefixInvalid => 'Le nom d\'utilisateur doit commencer par une lettre.';

  @override
  String get usernameSuffixInvalid => 'Le nom d’utilisateur doit se terminer par une lettre ou un chiffre.';

  @override
  String get usernameCharsInvalid => 'Le nom d\'utilisateur doit contenir uniquement des lettres, des chiffres, des tirets.';

  @override
  String get usernameUnacceptable => 'Ce nom d\'utilisateur existe déjà ou est insultant.';

  @override
  String get playChessInStyle => 'Jouez aux échecs avec classe';

  @override
  String get chessBasics => 'Bases des échecs';

  @override
  String get coaches => 'Entraîneurs';

  @override
  String get invalidPgn => 'PGN non valide';

  @override
  String get invalidFen => 'FEN non valide';

  @override
  String get custom => 'Personnalisée';

  @override
  String get notifications => 'Notifications';

  @override
  String notificationsX(String param1) {
    return 'Notifications : $param1';
  }

  @override
  String perfRatingX(String param) {
    return 'Classement : $param';
  }

  @override
  String get practiceWithComputer => 'S\'entraîner avec un ordinateur';

  @override
  String anotherWasX(String param) {
    return 'Un autre était $param';
  }

  @override
  String bestWasX(String param) {
    return 'Le meilleur coup était $param';
  }

  @override
  String get youBrowsedAway => 'Vous avez parcouru';

  @override
  String get resumePractice => 'Reprendre l\'entraînement';

  @override
  String get drawByFiftyMoves => 'Cette partie est nulle en raison de la règle des cinquante coups.';

  @override
  String get theGameIsADraw => 'La partie est nulle.';

  @override
  String get computerThinking => 'L’ordinateur réfléchit ...';

  @override
  String get seeBestMove => 'Voir le meilleur coup';

  @override
  String get hideBestMove => 'Cacher le meilleur coup';

  @override
  String get getAHint => 'Obtenir un indice';

  @override
  String get evaluatingYourMove => 'Evaluation de votre coup ...';

  @override
  String get whiteWinsGame => 'Les Blancs gagnent';

  @override
  String get blackWinsGame => 'Les Noirs gagnent';

  @override
  String get learnFromYourMistakes => 'Apprendre de vos erreurs';

  @override
  String get learnFromThisMistake => 'Apprendre de cette erreur';

  @override
  String get skipThisMove => 'Passer ce coup';

  @override
  String get next => 'Suivant';

  @override
  String xWasPlayed(String param) {
    return '$param a été joué';
  }

  @override
  String get findBetterMoveForWhite => 'Trouvez un meilleur coup pour les Blancs';

  @override
  String get findBetterMoveForBlack => 'Trouvez un meilleur coup pour les Noirs';

  @override
  String get resumeLearning => 'Retour à l\'apprentissage';

  @override
  String get youCanDoBetter => 'Vous pouvez faire mieux';

  @override
  String get tryAnotherMoveForWhite => 'Essayez un autre coup pour les Blancs';

  @override
  String get tryAnotherMoveForBlack => 'Essayez un autre coup pour les Noirs';

  @override
  String get solution => 'Solution';

  @override
  String get waitingForAnalysis => 'En cours d\'analyse';

  @override
  String get noMistakesFoundForWhite => 'Pas d\'erreur trouvée pour les Blancs';

  @override
  String get noMistakesFoundForBlack => 'Pas d\'erreur trouvée pour les Noirs';

  @override
  String get doneReviewingWhiteMistakes => 'Fin d\'examen des erreurs des Blancs';

  @override
  String get doneReviewingBlackMistakes => 'Fin d\'examen des erreurs des Noirs';

  @override
  String get doItAgain => 'Recommencer';

  @override
  String get reviewWhiteMistakes => 'Revoir les erreurs des Blancs';

  @override
  String get reviewBlackMistakes => 'Revoir les erreurs des Noirs';

  @override
  String get advantage => 'Avantage';

  @override
  String get opening => 'Ouverture';

  @override
  String get middlegame => 'Milieu de partie';

  @override
  String get endgame => 'Fin de partie';

  @override
  String get conditionalPremoves => 'Précoups conditionnels';

  @override
  String get addCurrentVariation => 'Ajouter la variante en cours';

  @override
  String get playVariationToCreateConditionalPremoves => 'Jouer une variante pour créer des précoups conditionnels';

  @override
  String get noConditionalPremoves => 'Pas de précoups conditionnels';

  @override
  String playX(String param) {
    return 'Jouer $param';
  }

  @override
  String get showUnreadLichessMessage => 'Vous avez reçu un message privé de Lichess.';

  @override
  String get clickHereToReadIt => 'Cliquez ici pour le lire.';

  @override
  String get sorry => 'Désolé :(';

  @override
  String get weHadToTimeYouOutForAWhile => 'Nous avons dû temporairement vous suspendre.';

  @override
  String get why => 'Pourquoi ?';

  @override
  String get pleasantChessExperience => 'Nous souhaitons procurer à chacun une agréable expérience du jeu d\'échecs.';

  @override
  String get goodPractice => 'Dans ce but, nous devons veiller à ce que tous les joueurs adoptent les bonnes pratiques.';

  @override
  String get potentialProblem => 'Lorsqu\'un potentiel problème est détecté, nous affichons ce message.';

  @override
  String get howToAvoidThis => 'Comment éviter cela?';

  @override
  String get playEveryGame => 'Jouez chaque partie que vous commencez.';

  @override
  String get tryToWin => 'Essayez de gagner (ou du moins d\'annuler) chaque partie que vous jouez.';

  @override
  String get resignLostGames => 'Abandonnez les parties perdues sans laisser votre temps s\'écouler.';

  @override
  String get temporaryInconvenience => 'Nous nous excusons pour le désagrément occasionné,';

  @override
  String get wishYouGreatGames => 'et vous souhaitons d\'excellentes parties sur lichess.org.';

  @override
  String get thankYouForReading => 'Merci d\'avoir pris le temps de lire !';

  @override
  String get lifetimeScore => 'Meilleur résultat';

  @override
  String get currentMatchScore => 'Résultat actuel (match)';

  @override
  String get agreementAssistance => 'Je m\'engage à ne jamais recevoir d\'aide pendant mes parties (ni d\'un programme d\'échecs, ni d\'un livre, ni d\'une base de données, ni d\'autrui).';

  @override
  String get agreementNice => 'Je m\'engage à toujours être agréable envers les autres.';

  @override
  String agreementMultipleAccounts(String param) {
    return 'J\'accepte de ne pas créer de comptes multiples (sauf pour les raisons indiquées dans les $param).';
  }

  @override
  String get agreementPolicy => 'Je m\'engage à respecter toutes les règles de Lichess.';

  @override
  String get searchOrStartNewDiscussion => 'Rechercher ou démarrer une nouvelle conversation';

  @override
  String get edit => 'Éditer';

  @override
  String get bullet => 'Bullet';

  @override
  String get blitz => 'Blitz';

  @override
  String get rapid => 'Rapide';

  @override
  String get classical => 'Classique';

  @override
  String get ultraBulletDesc => 'Parties éclairs : moins de 30 secondes';

  @override
  String get bulletDesc => 'Parties extrêmement rapides : moins de 3 minutes';

  @override
  String get blitzDesc => 'Parties très rapides : de 3 à 8 minutes';

  @override
  String get rapidDesc => 'Parties rapides : de 8 à 25 minutes';

  @override
  String get classicalDesc => 'Parties lentes : 25 minutes ou plus';

  @override
  String get correspondenceDesc => 'Parties par correspondance : un jour ou plus par coup';

  @override
  String get puzzleDesc => 'Entraînement tactique';

  @override
  String get important => 'Important';

  @override
  String yourQuestionMayHaveBeenAnswered(String param1) {
    return 'Votre question a peut-être déjà une réponse $param1';
  }

  @override
  String get inTheFAQ => 'dans la F.A.Q.';

  @override
  String toReportSomeoneForCheatingOrBadBehavior(String param1) {
    return 'Pour signaler un utilisateur pour triche ou mauvais comportement, $param1';
  }

  @override
  String get useTheReportForm => 'utilisez le formulaire de signalement';

  @override
  String toRequestSupport(String param1) {
    return 'Pour demander de l\'aide, $param1';
  }

  @override
  String get tryTheContactPage => 'essayez la page de contact';

  @override
  String makeSureToRead(String param1) {
    return 'Veillez à lire $param1';
  }

  @override
  String get theForumEtiquette => 'le règlement du forum';

  @override
  String get thisTopicIsArchived => 'Ce sujet a été archivé et il n\'est plus possible d\'y répondre.';

  @override
  String joinTheTeamXToPost(String param1) {
    return 'Pour poster sur ce forum, rejoignez $param1';
  }

  @override
  String teamNamedX(String param1) {
    return 'Équipe $param1';
  }

  @override
  String get youCannotPostYetPlaySomeGames => 'Vous ne pouvez pas encore poster dans les forums. Jouez quelques parties !';

  @override
  String get subscribe => 'Suivre';

  @override
  String get unsubscribe => 'Ne plus suivre';

  @override
  String mentionedYouInX(String param1) {
    return 'vous a mentionné dans « $param1 ».';
  }

  @override
  String xMentionedYouInY(String param1, String param2) {
    return '$param1 vous a mentionné dans « $param2 ».';
  }

  @override
  String invitedYouToX(String param1) {
    return 'vous a invité à « $param1 ».';
  }

  @override
  String xInvitedYouToY(String param1, String param2) {
    return '$param1 vous a invité à « $param2 ».';
  }

  @override
  String get youAreNowPartOfTeam => 'Vous faites maintenant partie de l’équipe.';

  @override
  String youHaveJoinedTeamX(String param1) {
    return 'Vous avez joint l\'équipe \"$param1\".';
  }

  @override
  String get someoneYouReportedWasBanned => 'Quelqu\'un que vous avez signalé a été banni.';

  @override
  String get congratsYouWon => 'Bravo, vous avez gagné !';

  @override
  String gameVsX(String param1) {
    return 'Partie contre $param1';
  }

  @override
  String resVsX(String param1, String param2) {
    return '$param1 contre $param2';
  }

  @override
  String get lostAgainstTOSViolator => 'Vous avez perdu contre quelqu\'un qui a violé les conditions d’usage de Lichess';

  @override
  String refundXpointsTimeControlY(String param1, String param2) {
    return 'Remboursement : $param1 point(s) de cote – $param2.';
  }

  @override
  String get timeAlmostUp => 'Vous n\'avez presque plus de temps!';

  @override
  String get clickToRevealEmailAddress => '[Cliquer pour révéler l\'adresse courriel]';

  @override
  String get download => 'Télécharger';

  @override
  String get coachManager => 'Config. param. coach';

  @override
  String get streamerManager => 'Config. param. streamer';

  @override
  String get cancelTournament => 'Annuler le tournoi';

  @override
  String get tournDescription => 'Description du tournoi';

  @override
  String get tournDescriptionHelp => 'Quelque chose de spécial à dire aux participants ? Soyez bref. Des liens Markdown sont disponibles : [name](https://url)';

  @override
  String get ratedFormHelp => 'Les parties sont classées\net ont un impact sur le classement des joueurs';

  @override
  String get onlyMembersOfTeam => 'Seulement les membres de l\'équipe';

  @override
  String get noRestriction => 'Sans restriction';

  @override
  String get minimumRatedGames => 'Nombre minimum de parties classées';

  @override
  String get minimumRating => 'Classement minimal';

  @override
  String get maximumWeeklyRating => 'Classement hebdomadaire maximal';

  @override
  String positionInputHelp(String param) {
    return 'Collez un FEN valide pour commencer chaque partie à partir d\'une position donnée.\nCela ne fonctionne que pour les parties normales, pas avec les variantes.\nVous pouvez utiliser le $param pour créer une position FEN puis la coller ici.\nLaissez vide pour commencer les parties à partir de la position initiale normale.';
  }

  @override
  String get cancelSimul => 'Annuler la simultanée';

  @override
  String get simulHostcolor => 'Couleur des pièces jouées par l\'hôte pour chaque partie';

  @override
  String get estimatedStart => 'Heure de début estimée';

  @override
  String simulFeatured(String param) {
    return 'Simultanée diffusée sur $param';
  }

  @override
  String simulFeaturedHelp(String param) {
    return 'Montrez votre simultanée à tout le monde sur $param. Désactivez cette option pour les simultanées privées.';
  }

  @override
  String get simulDescription => 'Description de la simultanée';

  @override
  String get simulDescriptionHelp => 'Voulez-vous dire quelque chose aux participants ?';

  @override
  String markdownAvailable(String param) {
    return '$param offre des options de formatage supplémentaires.';
  }

  @override
  String get embedsAvailable => 'Collez l\'URL d\'une partie ou d\'un chapitre d\'étude pour l\'intégrer.';

  @override
  String get inYourLocalTimezone => 'Dans votre fuseau horaire';

  @override
  String get tournChat => 'Salon de discussion du tournoi';

  @override
  String get noChat => 'Aucun salon de discussion';

  @override
  String get onlyTeamLeaders => 'Seulement les chefs de l\'équipe';

  @override
  String get onlyTeamMembers => 'Seulement les membres de l\'équipe';

  @override
  String get navigateMoveTree => 'Naviguer dans l\'arborescence';

  @override
  String get mouseTricks => 'Astuces pour la souris';

  @override
  String get toggleLocalAnalysis => 'Activer/désactiver l’analyse locale';

  @override
  String get toggleAllAnalysis => 'Activer/désactiver toutes les analyses';

  @override
  String get playComputerMove => 'Jouer le meilleur coup de l\'ordinateur';

  @override
  String get analysisOptions => 'Options d\'analyse';

  @override
  String get focusChat => 'Priorité au salon de discussion';

  @override
  String get showHelpDialog => 'Afficher cette boîte de dialogue';

  @override
  String get reopenYourAccount => 'Rouvrir votre compte';

  @override
  String get reopenYourAccountDescription => 'Vous avez fermé votre compte, mais vous avez changé d\'idée? Vous avez une chance de le récupérer.';

  @override
  String get emailAssociatedToaccount => 'Adresse courriel associée à votre compte';

  @override
  String get sentEmailWithLink => 'Nous vous avons envoyé un courriel avec un lien.';

  @override
  String get tournamentEntryCode => 'Code d\'entrée du tournoi';

  @override
  String get hangOn => 'Vous jouez déjà une partie!';

  @override
  String gameInProgress(String param) {
    return 'Vous avez une partie en cours avec $param.';
  }

  @override
  String get abortTheGame => 'Annuler la partie';

  @override
  String get resignTheGame => 'Abandonner la partie';

  @override
  String get youCantStartNewGame => 'Vous ne pouvez pas commencer une nouvelle partie tant que celle-ci n\'est pas terminée.';

  @override
  String get since => 'De';

  @override
  String get until => 'À';

  @override
  String get lichessDbExplanation => 'Échantillon de parties classées jouées par les joueurs de Lichess';

  @override
  String get switchSides => 'Changer de couleur';

  @override
  String get closingAccountWithdrawAppeal => 'Fermer votre compte annulera votre appel';

  @override
  String get ourEventTips => 'Nos conseils pour l\'organisation d\'événements';

  @override
  String get instructions => 'Instructions';

  @override
  String get showMeEverything => 'Tout afficher';

  @override
  String get lichessPatronInfo => 'Lichess est une association à but non lucratif et un logiciel open source entièrement libre.\nTous les coûts d\'exploitation, le développement et le contenu sont financés uniquement par les dons des utilisateurs.';

  @override
  String get nothingToSeeHere => 'Rien à voir ici pour le moment.';

  @override
  String get stats => 'Statistiques';

  @override
  String opponentLeftCounter(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Votre adversaire a quitté la partie. Vous pourrez revendiquer la victoire dans $count secondes.',
      one: 'Votre adversaire a quitté la partie. Vous pourrez revendiquer la victoire dans $count seconde.',
    );
    return '$_temp0';
  }

  @override
  String mateInXHalfMoves(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Mate en $count demi-coups',
      one: 'Mate en $count demi-coup',
    );
    return '$_temp0';
  }

  @override
  String nbBlunders(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count gaffes',
      one: '$count gaffe',
    );
    return '$_temp0';
  }

  @override
  String numberBlunders(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Erreurs graves',
      one: '$count Erreur grave',
    );
    return '$_temp0';
  }

  @override
  String nbMistakes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count erreurs',
      one: '$count erreur',
    );
    return '$_temp0';
  }

  @override
  String numberMistakes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Erreurs',
      one: '$count Erreur',
    );
    return '$_temp0';
  }

  @override
  String nbInaccuracies(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count imprécisions',
      one: '$count imprécision',
    );
    return '$_temp0';
  }

  @override
  String numberInaccuracies(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Imprécisions',
      one: '$count Imprécision',
    );
    return '$_temp0';
  }

  @override
  String nbPlayers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count joueurs',
      one: '$count joueur',
    );
    return '$_temp0';
  }

  @override
  String nbGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count parties',
      one: '$count partie',
    );
    return '$_temp0';
  }

  @override
  String ratingXOverYGames(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Classement $count après $param2 parties',
      one: 'Classement $count après $param2 partie',
    );
    return '$_temp0';
  }

  @override
  String nbBookmarks(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count favoris',
      one: '$count favori',
    );
    return '$_temp0';
  }

  @override
  String nbDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count jours',
      one: '$count jour',
    );
    return '$_temp0';
  }

  @override
  String nbHours(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count heures',
      one: '$count heure',
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
      other: 'Le classement est mis à jour toutes les $count minutes',
      one: 'Le classement est mis à jour toutes les minutes',
    );
    return '$_temp0';
  }

  @override
  String nbPuzzles(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count problèmes',
      one: '$count problème',
    );
    return '$_temp0';
  }

  @override
  String nbGamesWithYou(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count parties avec vous',
      one: '$count partie avec vous',
    );
    return '$_temp0';
  }

  @override
  String nbRated(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count évaluées',
      one: '$count évaluée',
    );
    return '$_temp0';
  }

  @override
  String nbWins(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count victoires',
      one: '$count victoire',
    );
    return '$_temp0';
  }

  @override
  String nbLosses(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count défaites',
      one: '$count défaite',
    );
    return '$_temp0';
  }

  @override
  String nbDraws(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count nulles',
      one: '$count nulle',
    );
    return '$_temp0';
  }

  @override
  String nbPlaying(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count en cours',
      one: '$count en cours',
    );
    return '$_temp0';
  }

  @override
  String giveNbSeconds(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Rajouter $count secondes',
      one: 'Rajouter $count seconde',
    );
    return '$_temp0';
  }

  @override
  String nbTournamentPoints(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count points de tournoi',
      one: '$count point de tournoi',
    );
    return '$_temp0';
  }

  @override
  String nbStudies(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count études',
      one: '$count étude',
    );
    return '$_temp0';
  }

  @override
  String nbSimuls(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count simultané(e)s',
      one: '$count simultané(e)s',
    );
    return '$_temp0';
  }

  @override
  String moreThanNbRatedGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '≥ $count parties classées',
      one: '≥ $count partie classée',
    );
    return '$_temp0';
  }

  @override
  String moreThanNbPerfRatedGames(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '≥ $count parties de $param2 classées',
      one: '≥ $count partie de $param2 classée',
    );
    return '$_temp0';
  }

  @override
  String needNbMorePerfGames(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Vous devez encore jouer $count parties de $param2 classées',
      one: 'Vous devez encore jouer $count partie de $param2 classée',
    );
    return '$_temp0';
  }

  @override
  String needNbMoreGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Vous devez encore jouer $count parties classées',
      one: 'Vous devez encore jouer $count partie classée',
    );
    return '$_temp0';
  }

  @override
  String nbImportedGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count parties importées',
      one: '$count partie importée',
    );
    return '$_temp0';
  }

  @override
  String nbFriendsOnline(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count amis en ligne',
      one: '$count ami en ligne',
    );
    return '$_temp0';
  }

  @override
  String nbFollowers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count suiveurs',
      one: '$count suiveur',
    );
    return '$_temp0';
  }

  @override
  String nbFollowing(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count suivis',
      one: '$count suivi',
    );
    return '$_temp0';
  }

  @override
  String lessThanNbMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Moins de $count minutes',
      one: 'Moins de $count minute',
    );
    return '$_temp0';
  }

  @override
  String nbGamesInPlay(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count parties en cours',
      one: '$count partie en cours',
    );
    return '$_temp0';
  }

  @override
  String maximumNbCharacters(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Maximum : $count caractères.',
      one: 'Maximum : $count caractère.',
    );
    return '$_temp0';
  }

  @override
  String blocks(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count joueurs bloqués',
      one: '$count joueurs bloqués',
    );
    return '$_temp0';
  }

  @override
  String nbForumPosts(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count messages postés',
      one: '$count message posté',
    );
    return '$_temp0';
  }

  @override
  String nbPerfTypePlayersThisWeek(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count joueurs de $param2 cette semaine.',
      one: '$count joueur de $param2 cette semaine.',
    );
    return '$_temp0';
  }

  @override
  String availableInNbLanguages(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Disponible en $count langues !',
      one: 'Disponible en $count langue !',
    );
    return '$_temp0';
  }

  @override
  String nbSecondsToPlayTheFirstMove(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count secondes pour jouer le premier coup',
      one: '$count seconde pour jouer le premier coup',
    );
    return '$_temp0';
  }

  @override
  String nbSeconds(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count secondes',
      one: '$count seconde',
    );
    return '$_temp0';
  }

  @override
  String andSaveNbPremoveLines(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'et enregistrer $count variantes de précoups',
      one: 'et enregistrer $count variante de précoups',
    );
    return '$_temp0';
  }

  @override
  String get stormMoveToStart => 'Jouez un coup pour commencer';

  @override
  String get stormYouPlayTheWhitePiecesInAllPuzzles => 'Vous jouez les pièces blanches dans tous les problèmes';

  @override
  String get stormYouPlayTheBlackPiecesInAllPuzzles => 'Vous jouez les pièces noires dans tous les problèmes';

  @override
  String get stormPuzzlesSolved => 'problèmes résolus';

  @override
  String get stormNewDailyHighscore => 'Nouveau record du jour !';

  @override
  String get stormNewWeeklyHighscore => 'Nouveau record de la semaine !';

  @override
  String get stormNewMonthlyHighscore => 'Nouveau record du mois !';

  @override
  String get stormNewAllTimeHighscore => 'Nouveau record absolu !';

  @override
  String stormPreviousHighscoreWasX(String param) {
    return 'Le record précédent était $param';
  }

  @override
  String get stormPlayAgain => 'Rejouer';

  @override
  String stormHighscoreX(String param) {
    return 'Meilleur score : $param';
  }

  @override
  String get stormScore => 'Score';

  @override
  String get stormMoves => 'Coups';

  @override
  String get stormAccuracy => 'Précision';

  @override
  String get stormCombo => 'Combo';

  @override
  String get stormTime => 'Temps';

  @override
  String get stormTimePerMove => 'Temps par coup';

  @override
  String get stormHighestSolved => 'Prob. résolu le plus difficile';

  @override
  String get stormPuzzlesPlayed => 'Problèmes joués';

  @override
  String get stormNewRun => 'Nouvel essai (raccourci clavier: Espace)';

  @override
  String get stormEndRun => 'Terminer l\'essai (raccourci clavier: Entrée)';

  @override
  String get stormHighscores => 'Meilleurs scores';

  @override
  String get stormViewBestRuns => 'Voir les meilleurs essais';

  @override
  String get stormBestRunOfDay => 'Meilleur essai du jour';

  @override
  String get stormRuns => 'Essais';

  @override
  String get stormGetReady => 'Soyez prêts !';

  @override
  String get stormWaitingForMorePlayers => 'En attente d\'autres joueurs...';

  @override
  String get stormRaceComplete => 'Course terminée !';

  @override
  String get stormSpectating => 'Observer';

  @override
  String get stormJoinTheRace => 'Participez !';

  @override
  String get stormStartTheRace => 'Débuter la course';

  @override
  String stormYourRankX(String param) {
    return 'Votre classement : $param';
  }

  @override
  String get stormWaitForRematch => 'Attendre une offre de revanche';

  @override
  String get stormNextRace => 'Course suivante';

  @override
  String get stormJoinRematch => 'Faire une revanche';

  @override
  String get stormWaitingToStart => 'Attendre le départ de la course';

  @override
  String get stormCreateNewGame => 'Créer une nouvelle course';

  @override
  String get stormJoinPublicRace => 'Joindre une course publique';

  @override
  String get stormRaceYourFriends => 'Faites la course avec vos amis';

  @override
  String get stormSkip => 'sauter';

  @override
  String get stormSkipHelp => 'Vous pouvez sauter un coup par course :';

  @override
  String get stormSkipExplanation => 'Sautez ce coup pour préserver votre combo ! Ne fonctionne qu\'une seule fois par course.';

  @override
  String get stormFailedPuzzles => 'Problèmes échoués';

  @override
  String get stormSlowPuzzles => 'Problèmes lents';

  @override
  String get stormSkippedPuzzle => 'Problème ignoré';

  @override
  String get stormThisWeek => 'Cette semaine';

  @override
  String get stormThisMonth => 'Ce mois-ci';

  @override
  String get stormAllTime => 'Depuis le début';

  @override
  String get stormClickToReload => 'Cliquez pour recharger';

  @override
  String get stormThisRunHasExpired => 'Cette série d\'essais a expirée !';

  @override
  String get stormThisRunWasOpenedInAnotherTab => 'Cette série a été ouverte dans un autre onglet !';

  @override
  String stormXRuns(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count essais',
      one: '1 essai',
    );
    return '$_temp0';
  }

  @override
  String stormPlayedNbRunsOfPuzzleStorm(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'A fait $count essais de $param2',
      one: 'A fait un essai de $param2',
    );
    return '$_temp0';
  }

  @override
  String get streamerLichessStreamers => 'Streamers sur Lichess';

  @override
  String get studyPrivate => 'Étude(s) privée(s)';

  @override
  String get studyMyStudies => 'Mes études';

  @override
  String get studyStudiesIContributeTo => 'Études auxquelles je participe';

  @override
  String get studyMyPublicStudies => 'Mes études publiques';

  @override
  String get studyMyPrivateStudies => 'Mes études privées';

  @override
  String get studyMyFavoriteStudies => 'Mes études favorites';

  @override
  String get studyWhatAreStudies => 'Qu\'est-ce qu\'une étude ?';

  @override
  String get studyAllStudies => 'Toutes les études';

  @override
  String studyStudiesCreatedByX(String param) {
    return 'Études créées par $param';
  }

  @override
  String get studyNoneYet => 'Aucune étude.';

  @override
  String get studyHot => 'Populaire(s)';

  @override
  String get studyDateAddedNewest => 'Date d\'ajout (dernier ajout)';

  @override
  String get studyDateAddedOldest => 'Date d\'ajout (premier ajout)';

  @override
  String get studyRecentlyUpdated => 'Récemment mis à jour';

  @override
  String get studyMostPopular => 'Études les plus populaires';

  @override
  String get studyAlphabetical => 'Alphabétique';

  @override
  String get studyAddNewChapter => 'Ajouter un nouveau chapitre';

  @override
  String get studyAddMembers => 'Ajouter des membres';

  @override
  String get studyInviteToTheStudy => 'Inviter à l\'étude';

  @override
  String get studyPleaseOnlyInvitePeopleYouKnow => 'Veuillez n\'inviter que des personnes qui vous connaissent et qui souhaitent activement participer à cette étude.';

  @override
  String get studySearchByUsername => 'Rechercher par nom d\'utilisateur';

  @override
  String get studySpectator => 'Spectateur';

  @override
  String get studyContributor => 'Contributeur';

  @override
  String get studyKick => 'Éjecter';

  @override
  String get studyLeaveTheStudy => 'Quitter l\'étude';

  @override
  String get studyYouAreNowAContributor => 'Vous êtes maintenant un contributeur';

  @override
  String get studyYouAreNowASpectator => 'Vous êtes maintenant un spectateur';

  @override
  String get studyPgnTags => 'Étiquettes PGN';

  @override
  String get studyLike => 'Aimer';

  @override
  String get studyUnlike => 'Je n’aime pas';

  @override
  String get studyNewTag => 'Nouvelle étiquette';

  @override
  String get studyCommentThisPosition => 'Commenter la position';

  @override
  String get studyCommentThisMove => 'Commenter ce coup';

  @override
  String get studyAnnotateWithGlyphs => 'Annoter avec des symboles';

  @override
  String get studyTheChapterIsTooShortToBeAnalysed => 'Le chapitre est trop court pour être analysé.';

  @override
  String get studyOnlyContributorsCanRequestAnalysis => 'Seuls les contributeurs de l\'étude peuvent demander une analyse informatique.';

  @override
  String get studyGetAFullComputerAnalysis => 'Obtenez une analyse en ligne complète de la ligne principale.';

  @override
  String get studyMakeSureTheChapterIsComplete => 'Assurez-vous que le chapitre est terminé. Vous ne pouvez demander l\'analyse qu\'une seule fois.';

  @override
  String get studyAllSyncMembersRemainOnTheSamePosition => 'Tous les membres SYNC demeurent sur la même position';

  @override
  String get studyShareChanges => 'Partager les changements avec les spectateurs et les enregistrer sur le serveur';

  @override
  String get studyPlaying => 'En cours';

  @override
  String get studyShowResults => 'Résultats';

  @override
  String get studyShowEvalBar => 'Barre d’évaluation';

  @override
  String get studyFirst => 'Premier';

  @override
  String get studyPrevious => 'Précédent';

  @override
  String get studyNext => 'Suivant';

  @override
  String get studyLast => 'Dernier';

  @override
  String get studyShareAndExport => 'Partager & exporter';

  @override
  String get studyCloneStudy => 'Dupliquer';

  @override
  String get studyStudyPgn => 'PGN de l\'étude';

  @override
  String get studyDownloadAllGames => 'Télécharger toutes les parties';

  @override
  String get studyChapterPgn => 'PGN du chapitre';

  @override
  String get studyCopyChapterPgn => 'Copier le fichier PGN';

  @override
  String get studyDownloadGame => 'Télécharger la partie';

  @override
  String get studyStudyUrl => 'URL de l\'étude';

  @override
  String get studyCurrentChapterUrl => 'URL du chapitre actuel';

  @override
  String get studyYouCanPasteThisInTheForumToEmbed => 'Vous pouvez collez ce lien dans le forum afin de l’insérer';

  @override
  String get studyStartAtInitialPosition => 'Commencer à partir du début';

  @override
  String studyStartAtX(String param) {
    return 'Débuter à $param';
  }

  @override
  String get studyEmbedInYourWebsite => 'Intégrer dans votre site ou blog';

  @override
  String get studyReadMoreAboutEmbedding => 'En savoir plus sur l\'intégration';

  @override
  String get studyOnlyPublicStudiesCanBeEmbedded => 'Seules les études publiques peuvent être intégrées !';

  @override
  String get studyOpen => 'Ouvrir';

  @override
  String studyXBroughtToYouByY(String param1, String param2) {
    return '$param1 vous est apporté par $param2';
  }

  @override
  String get studyStudyNotFound => 'Étude introuvable';

  @override
  String get studyEditChapter => 'Modifier le chapitre';

  @override
  String get studyNewChapter => 'Nouveau chapitre';

  @override
  String studyImportFromChapterX(String param) {
    return 'Importer depuis $param';
  }

  @override
  String get studyOrientation => 'Orientation';

  @override
  String get studyAnalysisMode => 'Mode analyse';

  @override
  String get studyPinnedChapterComment => 'Commentaire du chapitre épinglé';

  @override
  String get studySaveChapter => 'Enregistrer le chapitre';

  @override
  String get studyClearAnnotations => 'Effacer les annotations';

  @override
  String get studyClearVariations => 'Supprimer les variantes';

  @override
  String get studyDeleteChapter => 'Supprimer le chapitre';

  @override
  String get studyDeleteThisChapter => 'Supprimer ce chapitre ? Cette action est irréversible !';

  @override
  String get studyClearAllCommentsInThisChapter => 'Effacer tous les commentaires et annotations dans ce chapitre ?';

  @override
  String get studyRightUnderTheBoard => 'Juste sous l\'échiquier';

  @override
  String get studyNoPinnedComment => 'Aucun';

  @override
  String get studyNormalAnalysis => 'Analyse normale';

  @override
  String get studyHideNextMoves => 'Cacher les coups suivants';

  @override
  String get studyInteractiveLesson => 'Leçon interactive';

  @override
  String studyChapterX(String param) {
    return 'Chapitre : $param';
  }

  @override
  String get studyEmpty => 'Par défaut';

  @override
  String get studyStartFromInitialPosition => 'Commencer à partir du début';

  @override
  String get studyEditor => 'Editeur';

  @override
  String get studyStartFromCustomPosition => 'Commencer à partir d\'une position personnalisée';

  @override
  String get studyLoadAGameByUrl => 'Charger des parties à partir d\'une URL';

  @override
  String get studyLoadAPositionFromFen => 'Charger une position par FEN';

  @override
  String get studyLoadAGameFromPgn => 'Charger des parties par PGN';

  @override
  String get studyAutomatic => 'Automatique';

  @override
  String get studyUrlOfTheGame => 'URL des parties, une par ligne';

  @override
  String studyLoadAGameFromXOrY(String param1, String param2) {
    return 'Charger des parties de $param1 ou $param2';
  }

  @override
  String get studyCreateChapter => 'Créer un chapitre';

  @override
  String get studyCreateStudy => 'Créer une étude';

  @override
  String get studyEditStudy => 'Modifier l\'étude';

  @override
  String get studyVisibility => 'Visibilité';

  @override
  String get studyPublic => 'Publique';

  @override
  String get studyUnlisted => 'Non répertorié';

  @override
  String get studyInviteOnly => 'Sur invitation seulement';

  @override
  String get studyAllowCloning => 'Autoriser la duplication';

  @override
  String get studyNobody => 'Personne';

  @override
  String get studyOnlyMe => 'Seulement moi';

  @override
  String get studyContributors => 'Contributeurs';

  @override
  String get studyMembers => 'Membres';

  @override
  String get studyEveryone => 'Tout le monde';

  @override
  String get studyEnableSync => 'Activer la synchronisation';

  @override
  String get studyYesKeepEveryoneOnTheSamePosition => 'Oui : garder tout le monde sur la même position';

  @override
  String get studyNoLetPeopleBrowseFreely => 'Non : laisser les gens naviguer librement';

  @override
  String get studyPinnedStudyComment => 'Commentaire d\'étude épinglé';

  @override
  String get studyStart => 'Commencer';

  @override
  String get studySave => 'Enregistrer';

  @override
  String get studyClearChat => 'Effacer le tchat';

  @override
  String get studyDeleteTheStudyChatHistory => 'Supprimer l\'historique du tchat de l\'étude ? Cette action est irréversible !';

  @override
  String get studyDeleteStudy => 'Supprimer l\'étude';

  @override
  String studyConfirmDeleteStudy(String param) {
    return 'Supprimer toute l’étude? Aucun retour en arrière possible! Taper le nom de l’étude pour confirmer : $param';
  }

  @override
  String get studyWhereDoYouWantToStudyThat => 'Où voulez-vous étudier cela ?';

  @override
  String get studyGoodMove => 'Bon coup';

  @override
  String get studyMistake => 'Erreur';

  @override
  String get studyBrilliantMove => 'Excellent coup';

  @override
  String get studyBlunder => 'Gaffe';

  @override
  String get studyInterestingMove => 'Coup intéressant';

  @override
  String get studyDubiousMove => 'Coup douteux';

  @override
  String get studyOnlyMove => 'Seul coup';

  @override
  String get studyZugzwang => 'Zugzwang';

  @override
  String get studyEqualPosition => 'Position égale';

  @override
  String get studyUnclearPosition => 'Position incertaine';

  @override
  String get studyWhiteIsSlightlyBetter => 'Les Blancs sont un peu mieux';

  @override
  String get studyBlackIsSlightlyBetter => 'Les Noirs sont un peu mieux';

  @override
  String get studyWhiteIsBetter => 'Les Blancs sont mieux';

  @override
  String get studyBlackIsBetter => 'Les Noirs sont mieux';

  @override
  String get studyWhiteIsWinning => 'Les Blancs gagnent';

  @override
  String get studyBlackIsWinning => 'Les Noirs gagnent';

  @override
  String get studyNovelty => 'Nouveauté';

  @override
  String get studyDevelopment => 'Développement';

  @override
  String get studyInitiative => 'Initiative';

  @override
  String get studyAttack => 'Attaque';

  @override
  String get studyCounterplay => 'Contre-jeu';

  @override
  String get studyTimeTrouble => 'Pression de temps';

  @override
  String get studyWithCompensation => 'Avec compensation';

  @override
  String get studyWithTheIdea => 'Avec l\'idée';

  @override
  String get studyNextChapter => 'Chapitre suivant';

  @override
  String get studyPrevChapter => 'Chapitre précédent';

  @override
  String get studyStudyActions => 'Options pour les études';

  @override
  String get studyTopics => 'Thèmes';

  @override
  String get studyMyTopics => 'Mes thèmes';

  @override
  String get studyPopularTopics => 'Thèmes populaires';

  @override
  String get studyManageTopics => 'Gérer les thèmes';

  @override
  String get studyBack => 'Retour';

  @override
  String get studyPlayAgain => 'Jouer à nouveau';

  @override
  String get studyWhatWouldYouPlay => 'Que joueriez-vous dans cette position ?';

  @override
  String get studyYouCompletedThisLesson => 'Félicitations ! Vous avez terminé ce cours.';

  @override
  String studyPerPage(String param) {
    return '$param par page';
  }

  @override
  String studyNbChapters(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count chapitres',
      one: '$count chapitre',
    );
    return '$_temp0';
  }

  @override
  String studyNbGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count parties',
      one: '$count partie',
    );
    return '$_temp0';
  }

  @override
  String studyNbMembers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count membres',
      one: '$count membre',
    );
    return '$_temp0';
  }

  @override
  String studyPasteYourPgnTextHereUpToNbGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Collez votre texte PGN ici, jusqu\'à $count parties',
      one: 'Collez votre texte PGN ici, jusqu\'à $count partie',
    );
    return '$_temp0';
  }

  @override
  String get timeagoJustNow => 'Maintenant';

  @override
  String get timeagoRightNow => 'à l\'instant';

  @override
  String get timeagoCompleted => 'terminé';

  @override
  String timeagoInNbSeconds(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'dans $count secondes',
      one: 'dans $count seconde',
    );
    return '$_temp0';
  }

  @override
  String timeagoInNbMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'dans $count minutes',
      one: 'dans $count minute',
    );
    return '$_temp0';
  }

  @override
  String timeagoInNbHours(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'dans $count heures',
      one: 'dans $count heure',
    );
    return '$_temp0';
  }

  @override
  String timeagoInNbDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'dans $count jours',
      one: 'dans $count jour',
    );
    return '$_temp0';
  }

  @override
  String timeagoInNbWeeks(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'dans $count semaines',
      one: 'dans $count semaine',
    );
    return '$_temp0';
  }

  @override
  String timeagoInNbMonths(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'dans $count mois',
      one: 'dans $count mois',
    );
    return '$_temp0';
  }

  @override
  String timeagoInNbYears(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'dans $count ans',
      one: 'dans $count an',
    );
    return '$_temp0';
  }

  @override
  String timeagoNbMinutesAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'il y a $count minutes',
      one: 'il y a $count minute',
    );
    return '$_temp0';
  }

  @override
  String timeagoNbHoursAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'il y a $count heures',
      one: 'il y a $count heure',
    );
    return '$_temp0';
  }

  @override
  String timeagoNbDaysAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'il y a $count jours',
      one: 'il y a $count jour',
    );
    return '$_temp0';
  }

  @override
  String timeagoNbWeeksAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'il y a $count semaines',
      one: 'il y a $count semaine',
    );
    return '$_temp0';
  }

  @override
  String timeagoNbMonthsAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'il y a $count mois',
      one: 'il y a $count mois',
    );
    return '$_temp0';
  }

  @override
  String timeagoNbYearsAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'il y a $count ans',
      one: 'il y a $count an',
    );
    return '$_temp0';
  }

  @override
  String timeagoNbMinutesRemaining(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count minutes restantes',
      one: '$count minute restante',
    );
    return '$_temp0';
  }

  @override
  String timeagoNbHoursRemaining(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count heures restantes',
      one: '$count heure restante',
    );
    return '$_temp0';
  }
}
