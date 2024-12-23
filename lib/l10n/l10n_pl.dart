// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'l10n.dart';

// ignore_for_file: type=lint

/// The translations for Polish (`pl`).
class AppLocalizationsPl extends AppLocalizations {
  AppLocalizationsPl([String locale = 'pl']) : super(locale);

  @override
  String get mobileAllGames => 'Wszystkie partie';

  @override
  String get mobileAreYouSure => 'Jesteś pewien?';

  @override
  String get mobileCancelTakebackOffer => 'Anuluj prośbę cofnięcia ruchu';

  @override
  String get mobileClearButton => 'Wyczyść';

  @override
  String get mobileCorrespondenceClearSavedMove => 'Usuń zapisany ruch';

  @override
  String get mobileCustomGameJoinAGame => 'Dołącz do partii';

  @override
  String get mobileFeedbackButton => 'Opinie';

  @override
  String mobileGreeting(String param) {
    return 'Witaj $param';
  }

  @override
  String get mobileGreetingWithoutName => 'Witaj';

  @override
  String get mobileHideVariation => 'Ukryj wariant';

  @override
  String get mobileHomeTab => 'Start';

  @override
  String get mobileLiveStreamers => 'Aktywni streamerzy';

  @override
  String get mobileMustBeLoggedIn => 'Musisz być zalogowany, aby wyświetlić tę stronę.';

  @override
  String get mobileNoSearchResults => 'Brak wyników';

  @override
  String get mobileNotFollowingAnyUser => 'Nie obserwujesz żadnego gracza.';

  @override
  String get mobileOkButton => 'OK';

  @override
  String mobilePlayersMatchingSearchTerm(String param) {
    return 'Gracze pasujący do \"$param\"';
  }

  @override
  String get mobilePrefMagnifyDraggedPiece => 'Powiększ przeciąganą bierkę';

  @override
  String get mobilePuzzleStormConfirmEndRun => 'Czy chcesz zakończyć tę serię?';

  @override
  String get mobilePuzzleStormFilterNothingToShow => 'Brak wyników, zmień proszę filtry';

  @override
  String get mobilePuzzleStormNothingToShow => 'Nic do wyświetlenia. Rozegraj kilka serii.';

  @override
  String get mobilePuzzleStormSubtitle => 'Rozwiąż jak najwięcej zadań w ciągu 3 minut.';

  @override
  String get mobilePuzzleStreakAbortWarning => 'Przerwiesz swoją dobrą passę, a Twój wynik zostanie zapisany.';

  @override
  String get mobilePuzzleThemesSubtitle => 'Rozwiąż zadania z ulubionego debiutu lub wybierz motyw.';

  @override
  String get mobilePuzzlesTab => 'Zadania';

  @override
  String get mobileRecentSearches => 'Ostatnio wyszukiwane';

  @override
  String get mobileSettingsHapticFeedback => 'Wibracja przy dotknięciu';

  @override
  String get mobileSettingsImmersiveMode => 'Tryb pełnoekranowy';

  @override
  String get mobileSettingsImmersiveModeSubtitle => 'Ukryj interfejs użytkownika podczas gry. Użyj tego, jeśli rozpraszają Cię elementy nawigacji systemu na krawędziach ekranu. Dotyczy ekranów gry i rozwiązywania zadań.';

  @override
  String get mobileSettingsTab => 'Ustawienia';

  @override
  String get mobileShareGamePGN => 'Udostępnij PGN';

  @override
  String get mobileShareGameURL => 'Udostępnij adres URL partii';

  @override
  String get mobileSharePositionAsFEN => 'Udostępnij pozycję jako FEN';

  @override
  String get mobileSharePuzzle => 'Udostępnij to zadanie';

  @override
  String get mobileShowComments => 'Pokaż komentarze';

  @override
  String get mobileShowResult => 'Pokaż wynik';

  @override
  String get mobileShowVariations => 'Pokaż warianty';

  @override
  String get mobileSomethingWentWrong => 'Coś poszło nie tak.';

  @override
  String get mobileSystemColors => 'Kolory systemowe';

  @override
  String get mobileTheme => 'Motyw';

  @override
  String get mobileToolsTab => 'Narzędzia';

  @override
  String get mobileWaitingForOpponentToJoin => 'Oczekiwanie na dołączenie przeciwnika...';

  @override
  String get mobileWatchTab => 'Oglądaj';

  @override
  String get activityActivity => 'Aktywność';

  @override
  String get activityHostedALiveStream => 'Udostępnił stream na żywo';

  @override
  String activityRankedInSwissTournament(String param1, String param2) {
    return '$param1 miejsce w $param2';
  }

  @override
  String get activitySignedUp => 'Rejestracja na lichess.org';

  @override
  String activitySupportedNbMonths(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Wspiera lichess.org przez $count miesięcy jako $param2',
      many: 'Wspiera lichess.org przez $count miesięcy jako $param2',
      few: 'Wspiera lichess.org przez $count miesiące jako $param2',
      one: 'Wspomógł/-ogła lichess.org na miesiąc jako $param2',
    );
    return '$_temp0';
  }

  @override
  String activityPracticedNbPositions(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Przerobiono $count ćwiczeń w $param2',
      many: 'Przerobiono $count ćwiczeń w $param2',
      few: 'Przerobiono $count ćwiczenia w $param2',
      one: 'Przerobiono $count ćwiczenie w $param2',
    );
    return '$_temp0';
  }

  @override
  String activitySolvedNbPuzzles(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Rozwiązano $count zadań szachowych',
      many: 'Rozwiązano $count zadań szachowych',
      few: 'Rozwiązano $count zadania szachowe',
      one: 'Rozwiązano $count zadanie szachowe',
    );
    return '$_temp0';
  }

  @override
  String activityPlayedNbGames(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Rozegrane $count partii $param2',
      many: 'Rozegrane $count partii $param2',
      few: 'Rozegrane $count partie $param2',
      one: 'Rozegrana $count partia $param2',
    );
    return '$_temp0';
  }

  @override
  String activityPostedNbMessages(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Opublikowanie $count wpisów w $param2',
      many: 'Opublikowanie $count wpisów w $param2',
      few: 'Opublikowanie $count wpisów w $param2',
      one: 'Opublikowanie wpisu w $param2',
    );
    return '$_temp0';
  }

  @override
  String activityPlayedNbMoves(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Wykonane $count ruchów',
      many: 'Wykonane $count ruchów',
      few: 'Wykonane $count ruchy',
      one: 'Wykonany $count ruch',
    );
    return '$_temp0';
  }

  @override
  String activityInNbCorrespondenceGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'w $count partiach korespondencyjnych',
      many: 'w $count partiach korespondencyjnych',
      few: 'w $count partiach korespondencyjnych',
      one: 'w $count partii korespondencyjnej',
    );
    return '$_temp0';
  }

  @override
  String activityCompletedNbGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Zakończenie $count partii korespondencyjnych',
      many: 'Zakończenie $count partii korespondencyjnych',
      few: 'Zakończenie $count partii korespondencyjnych',
      one: 'Zakończenie partii korespondencyjnej',
    );
    return '$_temp0';
  }

  @override
  String activityCompletedNbVariantGames(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Zakończone $count $param2 partii korespondencyjnych',
      many: 'Zakończone $count $param2 partii korespondencyjnych',
      few: 'Zakończone $count $param2 partie korespondencyjne',
      one: 'Zakończona $count $param2 partia korespondencyjna',
    );
    return '$_temp0';
  }

  @override
  String activityFollowedNbPlayers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Rozpoczęcie obserwowania $count graczy',
      many: 'Rozpoczęcie obserwowania $count graczy',
      few: 'Rozpoczęcie obserwowania $count graczy',
      one: 'Rozpoczęcie obserwowania gracza',
    );
    return '$_temp0';
  }

  @override
  String activityGainedNbFollowers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Zyskano $count nowych obserwujących',
      many: 'Zyskano $count nowych obserwujących',
      few: 'Zyskano $count nowych obserwujących',
      one: 'Zyskano $count nowego obserwującego/-ą',
    );
    return '$_temp0';
  }

  @override
  String activityHostedNbSimuls(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Rozegranie $count symultan',
      many: 'Rozegranie $count symultan',
      few: 'Rozegranie $count symultan',
      one: 'Rozegranie symultany',
    );
    return '$_temp0';
  }

  @override
  String activityJoinedNbSimuls(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Udział w $count symultanach',
      many: 'Udział w $count symultanach',
      few: 'Udział w $count symultanach',
      one: 'Udział w $count symultanie',
    );
    return '$_temp0';
  }

  @override
  String activityCreatedNbStudies(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Utworzenie $count nowych opracowań',
      many: 'Utworzenie $count nowych opracowań',
      few: 'Utworzenie $count nowych opracowań',
      one: 'Utworzenie nowego opracowania',
    );
    return '$_temp0';
  }

  @override
  String activityCompetedInNbTournaments(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Uczestnictwo w $count turniejach',
      many: 'Uczestnictwo w $count turniejach',
      few: 'Uczestnictwo w $count turniejach',
      one: 'Uczestnictwo w turnieju',
    );
    return '$_temp0';
  }

  @override
  String activityRankedInTournament(int count, String param2, String param3, String param4) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count miejsce w klasyfikacji (top $param2%) z $param3 partiami w $param4',
      many: '$count miejsce w klasyfikacji (top $param2%) z $param3 partiami w $param4',
      few: '$count miejsce w klasyfikacji (top $param2%) z $param3 partiami w $param4',
      one: '$count miejsce w klasyfikacji (top $param2%) z $param3 partią w $param4',
    );
    return '$_temp0';
  }

  @override
  String activityCompetedInNbSwissTournaments(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Uczestniczył(a) w $count turniejach szwajcarskich',
      many: 'Uczestniczył(a) w $count turniejach szwajcarskich',
      few: 'Uczestniczył(a) w $count turniejach szwajcarskich',
      one: 'Uczestniczył(a) w $count turnieju szwajcarskim',
    );
    return '$_temp0';
  }

  @override
  String activityJoinedNbTeams(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Dołączono do $count zespołów',
      many: 'Dołączenie do $count klubów',
      few: 'Dołączenie do $count klubów',
      one: 'Dołączenie do klubu',
    );
    return '$_temp0';
  }

  @override
  String get broadcastBroadcasts => 'Transmisje';

  @override
  String get broadcastMyBroadcasts => 'Moje transmisje';

  @override
  String get broadcastLiveBroadcasts => 'Transmisje turniejów na żywo';

  @override
  String get broadcastBroadcastCalendar => 'Kalendarz transmisji';

  @override
  String get broadcastNewBroadcast => 'Nowa transmisja na żywo';

  @override
  String get broadcastSubscribedBroadcasts => 'Subskrybowane transmisje';

  @override
  String get broadcastAboutBroadcasts => 'O transmisji';

  @override
  String get broadcastHowToUseLichessBroadcasts => 'Jak korzystać z transmisji na Lichess.';

  @override
  String get broadcastTheNewRoundHelp => 'Nowa runda będzie miała tych samych uczestników co poprzednia.';

  @override
  String get broadcastAddRound => 'Dodaj rundę';

  @override
  String get broadcastOngoing => 'Trwające';

  @override
  String get broadcastUpcoming => 'Nadchodzące';

  @override
  String get broadcastCompleted => 'Zakończone';

  @override
  String get broadcastCompletedHelp => 'Lichess wykrywa ukończenie rundy w oparciu o śledzone partie. Użyj tego przełącznika, jeśli nie ma takich partii.';

  @override
  String get broadcastRoundName => 'Nazwa rundy';

  @override
  String get broadcastRoundNumber => 'Numer rundy';

  @override
  String get broadcastTournamentName => 'Nazwa turnieju';

  @override
  String get broadcastTournamentDescription => 'Krótki opis turnieju';

  @override
  String get broadcastFullDescription => 'Pełny opis wydarzenia';

  @override
  String broadcastFullDescriptionHelp(String param1, String param2) {
    return 'Opcjonalny długi opis transmisji. $param1 jest dostępny. Długość musi być mniejsza niż $param2 znaków.';
  }

  @override
  String get broadcastSourceSingleUrl => 'Adres URL zapisu PGN';

  @override
  String get broadcastSourceUrlHelp => 'Adres URL, który Lichess będzie udostępniał, aby można było uzyskać aktualizacje PGN. Musi być publicznie dostępny z internetu.';

  @override
  String get broadcastSourceGameIds => 'Do 64 identyfikatorów partii, oddzielonych spacjami.';

  @override
  String broadcastStartDateTimeZone(String param) {
    return 'Data rozpoczęcia w lokalnej strefie czasowej turnieju: $param';
  }

  @override
  String get broadcastStartDateHelp => 'Opcjonalne, jeśli wiesz kiedy wydarzenie się rozpocznie';

  @override
  String get broadcastCurrentGameUrl => 'Adres URL bieżącej partii';

  @override
  String get broadcastDownloadAllRounds => 'Pobierz wszystkie rundy';

  @override
  String get broadcastResetRound => 'Zresetuj tę rundę';

  @override
  String get broadcastDeleteRound => 'Usuń tę rundę';

  @override
  String get broadcastDefinitivelyDeleteRound => 'Ostatecznie usuń rundę i jej wszystkie partie.';

  @override
  String get broadcastDeleteAllGamesOfThisRound => 'Usuń wszystkie partie w tej rundzie. Źródło będzie musiało być aktywne, aby je odtworzyć.';

  @override
  String get broadcastEditRoundStudy => 'Edytuj opracowanie rundy';

  @override
  String get broadcastDeleteTournament => 'Usuń ten turniej';

  @override
  String get broadcastDefinitivelyDeleteTournament => 'Ostatecznie usuń cały turniej, jego wszystkie rundy i partie.';

  @override
  String get broadcastShowScores => 'Pokaż wyniki graczy na podstawie wyników gry';

  @override
  String get broadcastReplacePlayerTags => 'Opcjonalnie: zmień nazwy, rankingi oraz tytuły gracza';

  @override
  String get broadcastFideFederations => 'Federacje FIDE';

  @override
  String get broadcastTop10Rating => '10 najlepszych rankingów';

  @override
  String get broadcastFidePlayers => 'Zawodnicy FIDE';

  @override
  String get broadcastFidePlayerNotFound => 'Nie znaleziono zawodnika FIDE';

  @override
  String get broadcastFideProfile => 'Profil FIDE';

  @override
  String get broadcastFederation => 'Federacja';

  @override
  String get broadcastAgeThisYear => 'Wiek w tym roku';

  @override
  String get broadcastUnrated => 'Bez rankingu';

  @override
  String get broadcastRecentTournaments => 'Najnowsze turnieje';

  @override
  String get broadcastOpenLichess => 'Otwórz w Lichess';

  @override
  String get broadcastTeams => 'Drużyny';

  @override
  String get broadcastBoards => 'Szachownice';

  @override
  String get broadcastOverview => 'Podgląd';

  @override
  String get broadcastSubscribeTitle => 'Subskrybuj, aby dostawać powiadomienia o każdej rozpoczętej rundzie. W preferencjach konta możesz przełączać czy chcesz powiadomienia dźwiękowe czy wyskakujące notyfikacje tekstowe.';

  @override
  String get broadcastUploadImage => 'Prześlij logo turnieju';

  @override
  String get broadcastNoBoardsYet => 'Szachownice pojawią się jak tylko załadują się partie.';

  @override
  String broadcastBoardsCanBeLoaded(String param) {
    return 'Szachownice mogą być załadowane bezpośrednio ze źródła lub przez $param';
  }

  @override
  String broadcastStartsAfter(String param) {
    return 'Rozpoczyna się po $param';
  }

  @override
  String get broadcastStartVerySoon => 'Transmisja wkrótce się rozpocznie.';

  @override
  String get broadcastNotYetStarted => 'Transmisja jeszcze się nie rozpoczęła.';

  @override
  String get broadcastOfficialWebsite => 'Oficjalna strona';

  @override
  String get broadcastStandings => 'Klasyfikacja';

  @override
  String get broadcastOfficialStandings => 'Oficjalna klasyfikacja';

  @override
  String broadcastIframeHelp(String param) {
    return 'Więcej opcji na $param';
  }

  @override
  String get broadcastWebmastersPage => 'stronie webmasterów';

  @override
  String broadcastPgnSourceHelp(String param) {
    return 'Publiczne źródło PGN w czasie rzeczywistym dla tej rundy. Oferujemy również $param dla szybszej i skuteczniejszej synchronizacji.';
  }

  @override
  String get broadcastEmbedThisBroadcast => 'Umieść tę transmisję na swojej stronie internetowej';

  @override
  String broadcastEmbedThisRound(String param) {
    return 'Osadź $param na swojej stronie internetowej';
  }

  @override
  String get broadcastRatingDiff => 'Różnica rankingu';

  @override
  String get broadcastGamesThisTournament => 'Partie w tym turnieju';

  @override
  String get broadcastScore => 'Wynik';

  @override
  String get broadcastAllTeams => 'Wszystkie kluby';

  @override
  String get broadcastTournamentFormat => 'Format turnieju';

  @override
  String get broadcastTournamentLocation => 'Lokalizacja turnieju';

  @override
  String get broadcastTopPlayers => 'Najlepsi gracze';

  @override
  String get broadcastTimezone => 'Strefa czasowa';

  @override
  String get broadcastFideRatingCategory => 'Kategoria rankingu FIDE';

  @override
  String get broadcastOptionalDetails => 'Opcjonalne szczegóły';

  @override
  String get broadcastPastBroadcasts => 'Poprzednie transmisje';

  @override
  String get broadcastAllBroadcastsByMonth => 'Zobacz wszystkie transmisje w danym miesiącu';

  @override
  String broadcastNbBroadcasts(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count transmisji',
      many: '$count transmisji',
      few: '$count transmisje',
      one: '$count transmisja',
    );
    return '$_temp0';
  }

  @override
  String challengeChallengesX(String param1) {
    return 'Wyzwania: $param1';
  }

  @override
  String get challengeChallengeToPlay => 'Zaproś do gry';

  @override
  String get challengeChallengeDeclined => 'Wyzwanie odrzucone';

  @override
  String get challengeChallengeAccepted => 'Wyzwanie zaakceptowane!';

  @override
  String get challengeChallengeCanceled => 'Wyzwanie anulowane.';

  @override
  String get challengeRegisterToSendChallenges => 'Zarejestruj się, aby zapraszać do gry.';

  @override
  String challengeYouCannotChallengeX(String param) {
    return 'Nie możesz wyzwać $param.';
  }

  @override
  String challengeXDoesNotAcceptChallenges(String param) {
    return '$param nie przyjmuje wyzwań.';
  }

  @override
  String challengeYourXRatingIsTooFarFromY(String param1, String param2) {
    return 'Twój ranking ($param1) jest zbyt odległy od $param2.';
  }

  @override
  String challengeCannotChallengeDueToProvisionalXRating(String param) {
    return 'Nie możesz zapraszać ze względu na swój tymczasowy ranking ($param).';
  }

  @override
  String challengeXOnlyAcceptsChallengesFromFriends(String param) {
    return '$param akceptuje tylko wyzwania od znajomych.';
  }

  @override
  String get challengeDeclineGeneric => 'Obecnie nie akceptuję wyzwań.';

  @override
  String get challengeDeclineLater => 'Nie mam teraz czasu, spróbuj proszę później.';

  @override
  String get challengeDeclineTooFast => 'Ta kontrola czasu jest dla mnie zbyt szybka, zaproś mnie do wolniejszej partii.';

  @override
  String get challengeDeclineTooSlow => 'Ta kontrola czasu jest dla mnie zbyt wolna, zaproś mnie do szybszej partii.';

  @override
  String get challengeDeclineTimeControl => 'Nie akceptuję wyzwań z tą kontrolą czasu.';

  @override
  String get challengeDeclineRated => 'Zaproś mnie proszę do partii rankingowej.';

  @override
  String get challengeDeclineCasual => 'Zaproś mnie proszę do partii nierankingowej.';

  @override
  String get challengeDeclineStandard => 'Nie akceptuję teraz zaproszeń do gry w warianty.';

  @override
  String get challengeDeclineVariant => 'Nie chcę grać teraz tego wariantu.';

  @override
  String get challengeDeclineNoBot => 'Nie przyjmuję wyzwań od botów.';

  @override
  String get challengeDeclineOnlyBot => 'Przyjmuję tylko wyzwania od botów.';

  @override
  String get challengeInviteLichessUser => 'Lub zaproś użytkownika Lichess:';

  @override
  String get contactContact => 'Kontakt';

  @override
  String get contactContactLichess => 'Skontaktuj się z Lichess';

  @override
  String get patronDonate => 'Przekaż datek';

  @override
  String get patronLichessPatron => 'Patron Lichess';

  @override
  String perfStatPerfStats(String param) {
    return 'Statystyki dla $param';
  }

  @override
  String get perfStatViewTheGames => 'Zobacz partie';

  @override
  String get perfStatProvisional => 'prowizoryczny';

  @override
  String get perfStatNotEnoughRatedGames => 'Nie zagrano wystarczająco dużo rankingowych gier, aby ustalić wiarygodny ranking.';

  @override
  String perfStatProgressOverLastXGames(String param) {
    return 'Postęp w ostatnich $param partiach:';
  }

  @override
  String perfStatRatingDeviation(String param) {
    return 'Odchylenie rankingu: $param.';
  }

  @override
  String perfStatRatingDeviationTooltip(String param1, String param2, String param3) {
    return 'Niższa wartość oznacza, że ranking jest bardziej stabilny. Powyżej $param1, ranking jest uważany za tymczasowy. Aby znaleźć się na listach rankingowych, wartość ta powinna być niższa niż $param2 (standardowe szachy) lub $param3 (warianty).';
  }

  @override
  String get perfStatTotalGames => 'Wszystkie partie';

  @override
  String get perfStatRatedGames => 'Partie rankingowe';

  @override
  String get perfStatTournamentGames => 'Partie turniejowe';

  @override
  String get perfStatBerserkedGames => 'Partie z berserkiem';

  @override
  String get perfStatTimeSpentPlaying => 'Czas spędzony na grze';

  @override
  String get perfStatAverageOpponent => 'Średni ranking przeciwnika';

  @override
  String get perfStatVictories => 'Zwycięstwa';

  @override
  String get perfStatDefeats => 'Porażki';

  @override
  String get perfStatDisconnections => 'Rozłączania';

  @override
  String get perfStatNotEnoughGames => 'Za mało rozegranych partii';

  @override
  String perfStatHighestRating(String param) {
    return 'Najwyższy ranking: $param';
  }

  @override
  String perfStatLowestRating(String param) {
    return 'Najniższy ranking: $param';
  }

  @override
  String perfStatFromXToY(String param1, String param2) {
    return 'od $param1 do $param2';
  }

  @override
  String get perfStatWinningStreak => 'Seria zwycięstw';

  @override
  String get perfStatLosingStreak => 'Seria porażek';

  @override
  String perfStatLongestStreak(String param) {
    return 'Najdłuższa seria: $param';
  }

  @override
  String perfStatCurrentStreak(String param) {
    return 'Bieżąca seria: $param';
  }

  @override
  String get perfStatBestRated => 'Najlepsze zwycięstwa';

  @override
  String get perfStatGamesInARow => 'Gry rozegrane z rzędu';

  @override
  String get perfStatLessThanOneHour => 'Mniej niż jedna godzina pomiędzy grami';

  @override
  String get perfStatMaxTimePlaying => 'Maksymalny czas spędzony na grze';

  @override
  String get perfStatNow => 'teraz';

  @override
  String get preferencesPreferences => 'Ustawienia';

  @override
  String get preferencesDisplay => 'Wyświetlanie';

  @override
  String get preferencesPrivacy => 'Prywatność';

  @override
  String get preferencesNotifications => 'Powiadomienia';

  @override
  String get preferencesPieceAnimation => 'Animacja ruchu bierek';

  @override
  String get preferencesMaterialDifference => 'Przewaga materialna';

  @override
  String get preferencesBoardHighlights => 'Wyróżnienie pól szachownicy (ostatni ruch i szach)';

  @override
  String get preferencesPieceDestinations => 'Pola docelowe (ruchy poprawne i planowane)';

  @override
  String get preferencesBoardCoordinates => 'Współrzędne pól (a-h, 1-8)';

  @override
  String get preferencesMoveListWhilePlaying => 'Lista ruchów podczas partii';

  @override
  String get preferencesPgnPieceNotation => 'Notacja ruchów';

  @override
  String get preferencesChessPieceSymbol => 'Za pomocą symboli figur';

  @override
  String get preferencesPgnLetter => 'Litery (K, Q, R, B, N)';

  @override
  String get preferencesZenMode => 'Tryb Zen';

  @override
  String get preferencesShowPlayerRatings => 'Pokaż rankingi gracza';

  @override
  String get preferencesShowFlairs => 'Pokaż emblematy graczy';

  @override
  String get preferencesExplainShowPlayerRatings => 'Ukrywa wszystkie rankingi na stronie internetowej, aby pomóc skupić się na grze. Partie nadal mogą być oceniane, opcja ukrywa tylko widok rankingu.';

  @override
  String get preferencesDisplayBoardResizeHandle => 'Pokaż uchwyt od zmiany rozmiaru szachownicy';

  @override
  String get preferencesOnlyOnInitialPosition => 'Tylko w pozycji początkowej';

  @override
  String get preferencesInGameOnly => 'Tylko w partii';

  @override
  String get preferencesExceptInGame => 'Except in-game';

  @override
  String get preferencesChessClock => 'Zegar szachowy';

  @override
  String get preferencesTenthsOfSeconds => 'Dziesiąte części sekundy';

  @override
  String get preferencesWhenTimeRemainingLessThanTenSeconds => 'Kiedy na zegarze jest mniej niż 10 sekund';

  @override
  String get preferencesHorizontalGreenProgressBars => 'Poziomy zielony pasek czasu';

  @override
  String get preferencesSoundWhenTimeGetsCritical => 'Powiadom dźwiękiem przy niedoczasie';

  @override
  String get preferencesGiveMoreTime => 'Dodaj więcej czasu';

  @override
  String get preferencesGameBehavior => 'Zachowanie gry';

  @override
  String get preferencesHowDoYouMovePieces => 'W jaki sposób wykonywać ruch?';

  @override
  String get preferencesClickTwoSquares => 'Klikając dwa pola';

  @override
  String get preferencesDragPiece => 'Przeciągając figurę';

  @override
  String get preferencesBothClicksAndDrag => 'Na oba sposoby';

  @override
  String get preferencesPremovesPlayingDuringOpponentTurn => 'Ruch planowany (podczas ruchu przeciwnika)';

  @override
  String get preferencesTakebacksWithOpponentApproval => 'Cofanie ruchów (za zgodą przeciwnika)';

  @override
  String get preferencesInCasualGamesOnly => 'Tylko w grach towarzyskich';

  @override
  String get preferencesPromoteToQueenAutomatically => 'Automatyczna promocja na hetmana';

  @override
  String get preferencesExplainPromoteToQueenAutomatically => 'Przytrzymaj klawisz <ctrl> podczas promocji pionka, aby tymczasowo wyłączyć automatyczną przemianę w hetmana';

  @override
  String get preferencesWhenPremoving => 'W czasie ruchu planowanego';

  @override
  String get preferencesClaimDrawOnThreefoldRepetitionAutomatically => 'Automatyczny remis po trzykrotnym powtórzeniu pozycji';

  @override
  String get preferencesWhenTimeRemainingLessThanThirtySeconds => 'Kiedy pozostało mniej niż 30 sekund';

  @override
  String get preferencesMoveConfirmation => 'Potwierdzenie ruchu';

  @override
  String get preferencesExplainCanThenBeTemporarilyDisabled => 'Może być wyłączony podczas partii z menu';

  @override
  String get preferencesInCorrespondenceGames => 'W grze korespondencyjnej';

  @override
  String get preferencesCorrespondenceAndUnlimited => 'Korespondencyjne i bez limitu czasu';

  @override
  String get preferencesConfirmResignationAndDrawOffers => 'Potwierdzaj poddanie się i wysłanie propozycji remisu';

  @override
  String get preferencesCastleByMovingTheKingTwoSquaresOrOntoTheRook => 'Sposób roszowania';

  @override
  String get preferencesCastleByMovingTwoSquares => 'Ruch królem o dwa pola';

  @override
  String get preferencesCastleByMovingOntoTheRook => 'Ruch królem na wieżę';

  @override
  String get preferencesInputMovesWithTheKeyboard => 'Wprowadzaj ruchy za pomocą klawiatury';

  @override
  String get preferencesInputMovesWithVoice => 'Wykonywanie posunięć za pomocą głosu';

  @override
  String get preferencesSnapArrowsToValidMoves => 'Wyrównuj strzałki do legalnych ruchów';

  @override
  String get preferencesSayGgWpAfterLosingOrDrawing => 'Napisz \"Good game, well played\" po przegranej lub remisie';

  @override
  String get preferencesYourPreferencesHaveBeenSaved => 'Twoje ustawienia zostały zapisane.';

  @override
  String get preferencesScrollOnTheBoardToReplayMoves => 'Przewiń myszką, aby powtórzyć ruchy';

  @override
  String get preferencesCorrespondenceEmailNotification => 'Codzienne powiadomienia mailowe z listą Twoich partii korespondencyjnych';

  @override
  String get preferencesNotifyStreamStart => 'Streamer jest na żywo';

  @override
  String get preferencesNotifyInboxMsg => 'Nowa wiadomość';

  @override
  String get preferencesNotifyForumMention => 'Wspomniano o Tobie w komentarzu na forum';

  @override
  String get preferencesNotifyInvitedStudy => 'Zaproszenie do wspólnego opracowania';

  @override
  String get preferencesNotifyGameEvent => 'Zdarzenie w partii korespondencyjnej';

  @override
  String get preferencesNotifyChallenge => 'Wyzwania';

  @override
  String get preferencesNotifyTournamentSoon => 'Turniej rozpocznie się wkrótce';

  @override
  String get preferencesNotifyTimeAlarm => 'Czas w partii korespondencyjnej dobiega końca';

  @override
  String get preferencesNotifyBell => 'Powiadomienie dźwiękowe gdy jesteś na Lichess';

  @override
  String get preferencesNotifyPush => 'Powiadomienie na urządzenie, gdy nie jesteś na Lichess';

  @override
  String get preferencesNotifyWeb => 'Przeglądarka';

  @override
  String get preferencesNotifyDevice => 'Urządzenie';

  @override
  String get preferencesBellNotificationSound => 'Dźwięk powiadomień';

  @override
  String get preferencesBlindfold => 'Gra na ślepo';

  @override
  String get puzzlePuzzles => 'Zadania szachowe';

  @override
  String get puzzlePuzzleThemes => 'Motywy zadań';

  @override
  String get puzzleRecommended => 'Polecane';

  @override
  String get puzzlePhases => 'Faza gry';

  @override
  String get puzzleMotifs => 'Motyw';

  @override
  String get puzzleAdvanced => 'Zaawansowane';

  @override
  String get puzzleLengths => 'Długość zadania';

  @override
  String get puzzleMates => 'Maty';

  @override
  String get puzzleGoals => 'Cele';

  @override
  String get puzzleOrigin => 'Źródło';

  @override
  String get puzzleSpecialMoves => 'Szczególne posunięcia';

  @override
  String get puzzleDidYouLikeThisPuzzle => 'Czy podobało Ci się to zadanie?';

  @override
  String get puzzleVoteToLoadNextOne => 'Zagłosuj, by wczytać następny!';

  @override
  String get puzzleUpVote => 'Daj plusa zadaniu';

  @override
  String get puzzleDownVote => 'Daj minusa zadaniu';

  @override
  String get puzzleYourPuzzleRatingWillNotChange => 'Twój ranking w rozwiązywaniu zadań nie ulegnie zmianie. Pamiętaj, że zadania nie są rywalizacją. Twój ranking pomaga wybrać najlepsze zadania dla Twoich aktualnych umiejętności.';

  @override
  String get puzzleFindTheBestMoveForWhite => 'Znajdź najlepszy ruch dla białych.';

  @override
  String get puzzleFindTheBestMoveForBlack => 'Znajdź najlepszy ruch dla czarnych.';

  @override
  String get puzzleToGetPersonalizedPuzzles => 'Aby uzyskać spersonalizowane zadania:';

  @override
  String puzzlePuzzleId(String param) {
    return 'Zadanie $param';
  }

  @override
  String get puzzlePuzzleOfTheDay => 'Zadanie dnia';

  @override
  String get puzzleDailyPuzzle => 'Zadanie dnia';

  @override
  String get puzzleClickToSolve => 'Kliknij, aby zobaczyć rozwiązanie';

  @override
  String get puzzleGoodMove => 'Dobry ruch';

  @override
  String get puzzleBestMove => 'Najlepszy ruch!';

  @override
  String get puzzleKeepGoing => 'Kontynuuj…';

  @override
  String get puzzlePuzzleSuccess => 'Sukces!';

  @override
  String get puzzlePuzzleComplete => 'Zadanie zakończone!';

  @override
  String get puzzleByOpenings => 'Według otwarć';

  @override
  String get puzzlePuzzlesByOpenings => 'Zadania według otwarć';

  @override
  String get puzzleOpeningsYouPlayedTheMost => 'Najczęściej grane otwarcia w partiach rankingowych';

  @override
  String get puzzleUseFindInPage => 'Użyj \"Znajdź na stronie\" w menu przeglądarki, aby znaleźć swoje ulubione otwarcie!';

  @override
  String get puzzleUseCtrlF => 'Użyj Ctrl+f, aby znaleźć swoje ulubione otwarcie!';

  @override
  String get puzzleNotTheMove => 'To nie jest właściwy ruch!';

  @override
  String get puzzleTrySomethingElse => 'Spróbuj czegoś innego.';

  @override
  String puzzleRatingX(String param) {
    return 'Ranking: $param';
  }

  @override
  String get puzzleHidden => 'ukryty';

  @override
  String puzzleFromGameLink(String param) {
    return 'Z partii $param';
  }

  @override
  String get puzzleContinueTraining => 'Kontynuuj trening';

  @override
  String get puzzleDifficultyLevel => 'Poziom trudności';

  @override
  String get puzzleNormal => 'Normalny';

  @override
  String get puzzleEasier => 'Łatwy';

  @override
  String get puzzleEasiest => 'Bardzo łatwy';

  @override
  String get puzzleHarder => 'Trudny';

  @override
  String get puzzleHardest => 'Bardzo trudny';

  @override
  String get puzzleExample => 'Przykład';

  @override
  String get puzzleAddAnotherTheme => 'Dodaj inny motyw';

  @override
  String get puzzleNextPuzzle => 'Następne zadanie';

  @override
  String get puzzleJumpToNextPuzzleImmediately => 'Natychmiast przejdź do następnego zadania';

  @override
  String get puzzlePuzzleDashboard => 'Panel zadań';

  @override
  String get puzzleImprovementAreas => 'Obszary rozwoju';

  @override
  String get puzzleStrengths => 'Siła';

  @override
  String get puzzleHistory => 'Historia zadań';

  @override
  String get puzzleSolved => 'rozwiązane';

  @override
  String get puzzleFailed => 'nie udało się';

  @override
  String get puzzleStreakDescription => 'Stopniowo rozwiązuj coraz trudniejsze zadania i utwórz serię poprawnych rozwiązań. Czas nie jest odliczany, więc nie musisz się spieszyć. Jednak do przegranej wystarczy tylko jeden zły ruch! Możesz pominąć jeden ruch na sesję.';

  @override
  String puzzleYourStreakX(String param) {
    return 'Twoja seria: $param';
  }

  @override
  String get puzzleStreakSkipExplanation => 'Pomiń ruch, jeśli chcesz zachować swoją serię. Możesz użyć tylko raz w sesji.';

  @override
  String get puzzleContinueTheStreak => 'Kontynuuj serię';

  @override
  String get puzzleNewStreak => 'Nowa seria';

  @override
  String get puzzleFromMyGames => 'Z moich gier';

  @override
  String get puzzleLookupOfPlayer => 'Wyszukaj zadań z gier gracza';

  @override
  String puzzleFromXGames(String param) {
    return 'Zadania z partii gracza $param';
  }

  @override
  String get puzzleSearchPuzzles => 'Szukaj zadań';

  @override
  String get puzzleFromMyGamesNone => 'Nie masz zadań w bazie danych, ale Lichess nadal bardzo Cię kocha.\nGraj partie szybkie i klasyczne, aby zwiększyć swoje szanse na dodanie zadania!';

  @override
  String puzzleFromXGamesFound(String param1, String param2) {
    return '$param1 zadań znalezionych w $param2 grach';
  }

  @override
  String get puzzlePuzzleDashboardDescription => 'Trenuj, analizuj, doskonal się';

  @override
  String puzzlePercentSolved(String param) {
    return '$param rozwiązanych';
  }

  @override
  String get puzzleNoPuzzlesToShow => 'Nic do pokazania, najpierw rozwiąż kilka zadań!';

  @override
  String get puzzleImprovementAreasDescription => 'Trenuj, aby zoptymalizować swoje postępy!';

  @override
  String get puzzleStrengthDescription => 'Najlepiej sobie radzisz z tymi motywami';

  @override
  String puzzlePlayedXTimes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Rozwiązywane $count razy',
      many: 'Rozwiązywane $count razy',
      few: 'Rozwiązywane $count razy',
      one: 'Rozwiązywane $count raz',
    );
    return '$_temp0';
  }

  @override
  String puzzleNbPointsBelowYourPuzzleRating(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count punktów poniżej Twojego rankingu w rozwiązywaniu zadań',
      many: '$count punktów poniżej Twojego rankingu w rozwiązywaniu zadań',
      few: '$count punkty poniżej Twojego rankingu w rozwiązywaniu zadań',
      one: 'Jeden punkt poniżej Twojego rankingu w rozwiązywaniu zadań',
    );
    return '$_temp0';
  }

  @override
  String puzzleNbPointsAboveYourPuzzleRating(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count punktów powyżej Twojego rankingu w rozwiązywaniu zadań',
      many: '$count punktów powyżej Twojego rankingu w rozwiązywaniu zadań',
      few: '$count punkty powyżej Twojego rankingu w rozwiązywaniu zadań',
      one: 'Jeden punkt powyżej Twojego rankingu w rozwiązywaniu zadań',
    );
    return '$_temp0';
  }

  @override
  String puzzleNbPlayed(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count rozwiązywanych',
      many: '$count rozwiązywanych',
      few: '$count rozwiązywanych',
      one: '$count rozwiązywanych',
    );
    return '$_temp0';
  }

  @override
  String puzzleNbToReplay(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count do powtórki',
      many: '$count do powtórki',
      few: '$count do powtórki',
      one: '$count do powtórki',
    );
    return '$_temp0';
  }

  @override
  String get puzzleThemeAdvancedPawn => 'Zaawansowany pion';

  @override
  String get puzzleThemeAdvancedPawnDescription => 'Zaawansowany pion lub pion grożący przemianą jest kluczowy w taktyce.';

  @override
  String get puzzleThemeAdvantage => 'Przewaga';

  @override
  String get puzzleThemeAdvantageDescription => 'Wykorzystaj szansę na uzyskanie decydującej przewagi. (200cp ≤ eval ≤ 600cp)';

  @override
  String get puzzleThemeAnastasiaMate => 'Mat Anastazji';

  @override
  String get puzzleThemeAnastasiaMateDescription => 'Skoczek, wieża lub hetman łączą siły, aby złapać przeciwnego króla w pułapkę pomiędzy bandą szachownicy, a jego inną figurą.';

  @override
  String get puzzleThemeArabianMate => 'Mat arabski';

  @override
  String get puzzleThemeArabianMateDescription => 'Skoczek i wieża współpracują razem, aby zaciągnąć króla w róg szachownicy.';

  @override
  String get puzzleThemeAttackingF2F7 => 'Atak na f2 lub f7';

  @override
  String get puzzleThemeAttackingF2F7Description => 'Atak koncentrujący się na pionach f2 lub f7, na przykład taki jak w szewskim macie.';

  @override
  String get puzzleThemeAttraction => 'Przyciąganie';

  @override
  String get puzzleThemeAttractionDescription => 'Wymiana bądź poświęcenie zachęcające lub zmuszające bierkę przeciwnika do zajęcia pola, na którym będzie ona celem kolejnych taktyk.';

  @override
  String get puzzleThemeBackRankMate => 'Mat na ostatniej linii';

  @override
  String get puzzleThemeBackRankMateDescription => 'Zamatuj króla uwięzionego w ostatnim rzędzie przez własne bierki.';

  @override
  String get puzzleThemeBishopEndgame => 'Końcówka gońcowa';

  @override
  String get puzzleThemeBishopEndgameDescription => 'Gra końcowa wyłącznie z gońcami i pionami.';

  @override
  String get puzzleThemeBodenMate => 'Mat Bodena';

  @override
  String get puzzleThemeBodenMateDescription => 'Dwa atakujące gońce na przeciwnych przekątnych matują króla ograniczonego przez własne bierki.';

  @override
  String get puzzleThemeCastling => 'Roszada';

  @override
  String get puzzleThemeCastlingDescription => 'Zabezpiecz swojego króla i wprowadź do gry wieżę.';

  @override
  String get puzzleThemeCapturingDefender => 'Zabicie obrońcy';

  @override
  String get puzzleThemeCapturingDefenderDescription => 'Usunięcie obrońcy który jest kluczowy do obrony innej figury, pozwalając na zbicie niebronionej figury w następnym ruchu.';

  @override
  String get puzzleThemeCrushing => 'Decydująca przewaga';

  @override
  String get puzzleThemeCrushingDescription => 'Znajdź błąd przeciwnika i zdobądź decydującą przewagę (ocena pozycji: powyżej 600cp)';

  @override
  String get puzzleThemeDoubleBishopMate => 'Mat dwoma gońcami';

  @override
  String get puzzleThemeDoubleBishopMateDescription => 'Dwa atakujące gońce na sąsiednich przekątnych matują króla ograniczonego przez własne bierki.';

  @override
  String get puzzleThemeDovetailMate => 'Jaskółczy ogon';

  @override
  String get puzzleThemeDovetailMateDescription => 'Hetman matuje sąsiedniego króla, którego jedyne dwa pola ucieczki są zablokowane przez własne bierki.';

  @override
  String get puzzleThemeEquality => 'Równowaga';

  @override
  String get puzzleThemeEqualityDescription => 'Odzyskaj remis bądź równowagę wychodząc z przegrywającej pozycji. (ocena pozycji: poniżej 200cp)';

  @override
  String get puzzleThemeKingsideAttack => 'Atak skrzydłem królewskim';

  @override
  String get puzzleThemeKingsideAttackDescription => 'Atak na króla przeciwnika po krótkiej roszadzie.';

  @override
  String get puzzleThemeClearance => 'Zwolnienie';

  @override
  String get puzzleThemeClearanceDescription => 'Posunięcie, często z tempem, które udostępnia pole, linię bądź przekątną do wykorzystania w następnej taktyce.';

  @override
  String get puzzleThemeDefensiveMove => 'Ruch obronny';

  @override
  String get puzzleThemeDefensiveMoveDescription => 'Precyzyjne posunięcie lub ich ciąg, niezbędne by uniknąć straty materiału lub innej przewagi.';

  @override
  String get puzzleThemeDeflection => 'Odciągnięcie';

  @override
  String get puzzleThemeDeflectionDescription => 'Posunięcie odciągające bierkę przeciwnika od innego wykonywanego przez nią zadania, np. ochrony kluczowego pola.';

  @override
  String get puzzleThemeDiscoveredAttack => 'Atak z odsłony';

  @override
  String get puzzleThemeDiscoveredAttackDescription => 'Ruch bierką, która blokuje atak innej figury dalekiego zasięgu, np. ruch skoczkiem uaktywniający wieżę.';

  @override
  String get puzzleThemeDoubleCheck => 'Podwójny szach';

  @override
  String get puzzleThemeDoubleCheckDescription => 'Szach dwoma bierkami jednocześnie będący wynikiem ataku z odkrycia, w którym zarówno bierka poruszana, jak i odkryta atakują króla.';

  @override
  String get puzzleThemeEndgame => 'Końcówka';

  @override
  String get puzzleThemeEndgameDescription => 'Taktyka w ostatniej fazie gry.';

  @override
  String get puzzleThemeEnPassantDescription => 'Taktyka wykorzystująca bicie w przelocie, gdzie pion może zbić piona przeciwnika, który minął go wykonawszy swoje początkowe posuniecie o dwa pola.';

  @override
  String get puzzleThemeExposedKing => 'Odsłonięty król';

  @override
  String get puzzleThemeExposedKingDescription => 'Taktyka z udziałem króla z kilkoma jego obrońcami, często prowadząca do mata.';

  @override
  String get puzzleThemeFork => 'Widełki';

  @override
  String get puzzleThemeForkDescription => 'Ruch w którym poruszona bierka atakuje jednocześnie dwie bierki przeciwnika.';

  @override
  String get puzzleThemeHangingPiece => 'Wisząca figura';

  @override
  String get puzzleThemeHangingPieceDescription => 'Taktyka wykorzystująca możliwość zbicia niebronionej lub niedostatecznie bronionej bierki przeciwnika.';

  @override
  String get puzzleThemeHookMate => 'Mat haka';

  @override
  String get puzzleThemeHookMateDescription => 'Mat wieżą, skoczkiem i pionkiem z wrogim pionem blokującym ucieczkę króla.';

  @override
  String get puzzleThemeInterference => 'Przesłona';

  @override
  String get puzzleThemeInterferenceDescription => 'Ruch figurą pomiędzy dwie figury przeciwnika, tak, że jedna lub obydwie są niebronione. Na przykład ruch skoczkiem na bronione pole pomiędzy dwie wieże.';

  @override
  String get puzzleThemeIntermezzo => 'Wtrącony ruch';

  @override
  String get puzzleThemeIntermezzoDescription => 'Zamiast zagrania spodziewanego posunięcia, wykonanie takiego, które stanowi bezpośrednią groźbę, na którą przeciwnik zmuszony jest odpowiedzieć. Znane również jako „zwischenzug”.';

  @override
  String get puzzleThemeKnightEndgame => 'Końcówka skoczkowa';

  @override
  String get puzzleThemeKnightEndgameDescription => 'Gra końcowa wyłącznie ze skoczkami i pionami.';

  @override
  String get puzzleThemeLong => 'Długie zadanie';

  @override
  String get puzzleThemeLongDescription => 'Trzy ruchy by wygrać.';

  @override
  String get puzzleThemeMaster => 'Partie mistrzów';

  @override
  String get puzzleThemeMasterDescription => 'Zadania z partii graczy utytułowanych.';

  @override
  String get puzzleThemeMasterVsMaster => 'Mistrz kontra Mistrz';

  @override
  String get puzzleThemeMasterVsMasterDescription => 'Zadania z partii pomiędzy dwoma utytułowanymi graczami.';

  @override
  String get puzzleThemeMate => 'Mat';

  @override
  String get puzzleThemeMateDescription => 'Wygraj partię w dobrym stylu.';

  @override
  String get puzzleThemeMateIn1 => 'Mat w 1 ruchu';

  @override
  String get puzzleThemeMateIn1Description => 'Daj mata w jednym posunięciu.';

  @override
  String get puzzleThemeMateIn2 => 'Mat w 2 ruchach';

  @override
  String get puzzleThemeMateIn2Description => 'Daj mata w dwóch posunięciach.';

  @override
  String get puzzleThemeMateIn3 => 'Mat w 3 ruchach';

  @override
  String get puzzleThemeMateIn3Description => 'Daj mata w trzech posunięciach.';

  @override
  String get puzzleThemeMateIn4 => 'Mat w 4 ruchach';

  @override
  String get puzzleThemeMateIn4Description => 'Daj mata w czterech posunięciach.';

  @override
  String get puzzleThemeMateIn5 => 'Mat w 5 lub więcej ruchach';

  @override
  String get puzzleThemeMateIn5Description => 'Naprawdę długa sekwencja matowa.';

  @override
  String get puzzleThemeMiddlegame => 'Gra środkowa';

  @override
  String get puzzleThemeMiddlegameDescription => 'Taktyka w drugiej fazie gry.';

  @override
  String get puzzleThemeOneMove => 'Jednochodówka';

  @override
  String get puzzleThemeOneMoveDescription => 'Zadanie, którego długość to tylko jedno posunięcie.';

  @override
  String get puzzleThemeOpening => 'Otwarcie';

  @override
  String get puzzleThemeOpeningDescription => 'Taktyka w pierwszej fazie gry.';

  @override
  String get puzzleThemePawnEndgame => 'Końcówka pionkowa';

  @override
  String get puzzleThemePawnEndgameDescription => 'Gra końcowa wyłącznie z pionami.';

  @override
  String get puzzleThemePin => 'Związanie';

  @override
  String get puzzleThemePinDescription => 'Taktyka wykorzystująca związania, czyli sytuacje, w których ruch bierki naraża na atak figurę o wyższej wartości.';

  @override
  String get puzzleThemePromotion => 'Promocja';

  @override
  String get puzzleThemePromotionDescription => 'Promocja piona lub zagrożenie promocją jest kluczem tej taktyki.';

  @override
  String get puzzleThemeQueenEndgame => 'Końcówka hetmańska';

  @override
  String get puzzleThemeQueenEndgameDescription => 'Gra końcowa wyłącznie z hetmanami i pionami.';

  @override
  String get puzzleThemeQueenRookEndgame => 'Końcówka wieżowo-hetmańska';

  @override
  String get puzzleThemeQueenRookEndgameDescription => 'Gra końcowa wyłącznie z wieżami, hetmanami i pionami.';

  @override
  String get puzzleThemeQueensideAttack => 'Atak skrzydłem hetmańskim';

  @override
  String get puzzleThemeQueensideAttackDescription => 'Atak na króla przeciwnika po długiej roszadzie.';

  @override
  String get puzzleThemeQuietMove => 'Cichy ruch';

  @override
  String get puzzleThemeQuietMoveDescription => 'Posunięcie niebędące ani szachem, ani biciem, które przygotowuje groźbę nie do uniknięcia w jednym z kolejnych posunięć.';

  @override
  String get puzzleThemeRookEndgame => 'Końcówka wieżowa';

  @override
  String get puzzleThemeRookEndgameDescription => 'Gra końcowa wyłącznie z wieżami i pionami.';

  @override
  String get puzzleThemeSacrifice => 'Poświęcenie';

  @override
  String get puzzleThemeSacrificeDescription => 'Taktyka wykorzystująca krótkoterminowe oddanie materiału do zdobycia przewagi po forsownej sekwencji posunięć.';

  @override
  String get puzzleThemeShort => 'Krótkie zadanie';

  @override
  String get puzzleThemeShortDescription => 'Dwa ruchy by wygrać.';

  @override
  String get puzzleThemeSkewer => 'Szpila';

  @override
  String get puzzleThemeSkewerDescription => 'Motyw, w którym bierka o wyższej wartości unikając ataku pozwala na zbicie bądź zaatakowanie bierki o niższej wartości. Odwrotność związania.';

  @override
  String get puzzleThemeSmotheredMate => 'Mat Beniowskiego';

  @override
  String get puzzleThemeSmotheredMateDescription => 'Mat dawany skoczkiem w którym matowany król nie może się poruszać ponieważ jest otoczony (zduszony) własnymi bierkami.';

  @override
  String get puzzleThemeSuperGM => 'Partie arcymistrzów';

  @override
  String get puzzleThemeSuperGMDescription => 'Zadania z partii granych przez najlepszych graczy na świecie.';

  @override
  String get puzzleThemeTrappedPiece => 'Uwięziona figura';

  @override
  String get puzzleThemeTrappedPieceDescription => 'Bierka nie może uniknąć zbicia z powodu ograniczenia mobilności.';

  @override
  String get puzzleThemeUnderPromotion => 'Słaba promocja';

  @override
  String get puzzleThemeUnderPromotionDescription => 'Promocja na skoczka, gońca lub wieżę.';

  @override
  String get puzzleThemeVeryLong => 'Bardzo długie zadanie';

  @override
  String get puzzleThemeVeryLongDescription => 'Cztery ruchy lub więcej, aby wygrać.';

  @override
  String get puzzleThemeXRayAttack => 'Rentgen';

  @override
  String get puzzleThemeXRayAttackDescription => 'Figura atakuje albo broni pole przez wrogą figurę.';

  @override
  String get puzzleThemeZugzwang => 'Zugzwang';

  @override
  String get puzzleThemeZugzwangDescription => 'Ograniczone ruchy przeciwnika powodują, że każde posunięcie pogarsza jego pozycję.';

  @override
  String get puzzleThemeMix => 'Miszmasz';

  @override
  String get puzzleThemeMixDescription => 'Po trochu wszystkiego. Nie wiesz czego się spodziewać, więc bądź gotów na wszystko! Tak jak w prawdziwej partii.';

  @override
  String get puzzleThemePlayerGames => 'Partie gracza';

  @override
  String get puzzleThemePlayerGamesDescription => 'Wyszukaj zadania wygenerowane z Twoich partii lub z partii innego gracza.';

  @override
  String puzzleThemePuzzleDownloadInformation(String param) {
    return 'Te zadania dostępne są w domenie publicznej i mogą być pobrane z $param.';
  }

  @override
  String get searchSearch => 'Szukaj';

  @override
  String get settingsSettings => 'Ustawienia';

  @override
  String get settingsCloseAccount => 'Zamknij konto';

  @override
  String get settingsManagedAccountCannotBeClosed => 'Twoim kontem zarządza nauczyciel, nie możesz go zamknąć.';

  @override
  String get settingsClosingIsDefinitive => 'Zamknięcie konta jest nieodwracalne. Czy chcesz kontynuować?';

  @override
  String get settingsCantOpenSimilarAccount => 'Nie będzie można otworzyć nowego konta z tą samą nazwą, nawet jeśli wielkość liter będzie inna.';

  @override
  String get settingsChangedMindDoNotCloseAccount => 'Zmieniłem zdanie, nie chcę zamykać swojego konta';

  @override
  String get settingsCloseAccountExplanation => 'Jesteś pewien, że chcesz zamknąć swoje konto? Zamknięcie konta jest decyzją nieodwracalną. Już NIGDY nie będziesz mógł się na nie zalogować.';

  @override
  String get settingsThisAccountIsClosed => 'Konto zostało zamknięte.';

  @override
  String get playWithAFriend => 'Zagraj ze znajomym';

  @override
  String get playWithTheMachine => 'Zagraj z komputerem';

  @override
  String get toInviteSomeoneToPlayGiveThisUrl => 'Przekaż ten adres, by zaprosić kogoś do wspólnej gry';

  @override
  String get gameOver => 'Partia zakończona';

  @override
  String get waitingForOpponent => 'Oczekiwanie na ruch przeciwnika';

  @override
  String get orLetYourOpponentScanQrCode => 'Lub pozwól przeciwnikowi zeskanować ten kod QR';

  @override
  String get waiting => 'Oczekiwanie';

  @override
  String get yourTurn => 'Twój ruch';

  @override
  String aiNameLevelAiLevel(String param1, String param2) {
    return '$param1 poziom $param2';
  }

  @override
  String get level => 'Poziom';

  @override
  String get strength => 'Siła';

  @override
  String get toggleTheChat => 'Pokaż/ukryj rozmowy';

  @override
  String get chat => 'Czat';

  @override
  String get resign => 'Poddaj się';

  @override
  String get checkmate => 'Mat';

  @override
  String get stalemate => 'Pat';

  @override
  String get white => 'Białe';

  @override
  String get black => 'Czarne';

  @override
  String get asWhite => 'białymi';

  @override
  String get asBlack => 'czarnymi';

  @override
  String get randomColor => 'Losowo';

  @override
  String get createAGame => 'Nowa partia';

  @override
  String get whiteIsVictorious => 'Zwycięstwo białych';

  @override
  String get blackIsVictorious => 'Zwycięstwo czarnych';

  @override
  String get youPlayTheWhitePieces => 'Grasz białymi';

  @override
  String get youPlayTheBlackPieces => 'Grasz czarnymi';

  @override
  String get itsYourTurn => 'Twój ruch!';

  @override
  String get cheatDetected => 'Wykryto oszustwo';

  @override
  String get kingInTheCenter => 'Król w centrum';

  @override
  String get threeChecks => 'Trzy szachy';

  @override
  String get raceFinished => 'Wyścig zakończony';

  @override
  String get variantEnding => 'Wariant zakończony';

  @override
  String get newOpponent => 'Nowy przeciwnik';

  @override
  String get yourOpponentWantsToPlayANewGameWithYou => 'Przeciwnik chce zagrać z Tobą nową partię';

  @override
  String get joinTheGame => 'Dołącz do gry';

  @override
  String get whitePlays => 'Ruch białych';

  @override
  String get blackPlays => 'Ruch czarnych';

  @override
  String get opponentLeftChoices => 'Przeciwnik opuścił grę. Możesz ogłosić swoje zwycięstwo, uznać partię za nierozstrzygniętą lub poczekać.';

  @override
  String get forceResignation => 'Ogłoś wygraną';

  @override
  String get forceDraw => 'Ogłoś remis';

  @override
  String get talkInChat => 'Bądź miły na czacie';

  @override
  String get theFirstPersonToComeOnThisUrlWillPlayWithYou => 'Pierwsza osoba, która przejdzie pod ten adres, dołączy do Twojej partii.';

  @override
  String get whiteResigned => 'Białe poddały się';

  @override
  String get blackResigned => 'Czarne poddały się';

  @override
  String get whiteLeftTheGame => 'Białe opuściły grę';

  @override
  String get blackLeftTheGame => 'Czarne opuściły grę';

  @override
  String get whiteDidntMove => 'Białe nie ruszyły się';

  @override
  String get blackDidntMove => 'Czarne nie ruszyły się';

  @override
  String get requestAComputerAnalysis => 'Poproś o analizę komputerową';

  @override
  String get computerAnalysis => 'Analiza komputerowa';

  @override
  String get computerAnalysisAvailable => 'Dostępna analiza komputerowa';

  @override
  String get computerAnalysisDisabled => 'Analiza komputerowa wyłączona';

  @override
  String get analysis => 'Analiza partii';

  @override
  String depthX(String param) {
    return 'Głębokość $param';
  }

  @override
  String get usingServerAnalysis => 'Analiza zdalna';

  @override
  String get loadingEngine => 'Wczytywanie silnika szachowego...';

  @override
  String get calculatingMoves => 'Obliczanie ruchów...';

  @override
  String get engineFailed => 'Błąd ładowania silnika';

  @override
  String get cloudAnalysis => 'Analiza w chmurze';

  @override
  String get goDeeper => 'Analizuj głębiej';

  @override
  String get showThreat => 'Pokaż zagrożenia';

  @override
  String get inLocalBrowser => 'w przeglądarce';

  @override
  String get toggleLocalEvaluation => 'Włącz/wyłącz ocenę lokalną';

  @override
  String get promoteVariation => 'Promuj ten wariant';

  @override
  String get makeMainLine => 'Promuj na główny wariant';

  @override
  String get deleteFromHere => 'Usuń od tego miejsca';

  @override
  String get collapseVariations => 'Zwiń warianty';

  @override
  String get expandVariations => 'Rozwiń warianty';

  @override
  String get forceVariation => 'Zamień w wariant';

  @override
  String get copyVariationPgn => 'Skopiuj wariant PGN';

  @override
  String get move => 'Ruch';

  @override
  String get variantLoss => 'Wariant przegrywający';

  @override
  String get variantWin => 'Wariant wygrywający';

  @override
  String get insufficientMaterial => 'Niewystarczający materiał';

  @override
  String get pawnMove => 'Ruch pionem';

  @override
  String get capture => 'Bicie';

  @override
  String get close => 'Zamknij';

  @override
  String get winning => 'Wygrywa';

  @override
  String get losing => 'Przegrywa';

  @override
  String get drawn => 'Remisuje';

  @override
  String get unknown => 'Nieznany';

  @override
  String get database => 'Baza danych';

  @override
  String get whiteDrawBlack => 'Białe / Remis / Czarne';

  @override
  String averageRatingX(String param) {
    return 'Średni ranking: $param';
  }

  @override
  String get recentGames => 'Ostatnie partie';

  @override
  String get topGames => 'Najlepsze partie';

  @override
  String masterDbExplanation(String param1, String param2, String param3) {
    return 'Dwa miliony partii graczy FIDE ($param1+) rozegranych w latach $param2–$param3';
  }

  @override
  String get dtzWithRounding => 'DTZ50\'\' - odległość do zerowania z regułą pięćdziesięciu ruchów';

  @override
  String get noGameFound => 'Nie znaleziono partii';

  @override
  String get maxDepthReached => 'Osiągnięto maksymalną głębokość!';

  @override
  String get maybeIncludeMoreGamesFromThePreferencesMenu => 'Może zaimportujesz więcej partii z menu narzędzi?';

  @override
  String get openings => 'Otwarcia';

  @override
  String get openingExplorer => 'Biblioteka otwarć';

  @override
  String get openingEndgameExplorer => 'Biblioteka otwarć i końcówek';

  @override
  String xOpeningExplorer(String param) {
    return 'Biblioteka otwarć $param';
  }

  @override
  String get playFirstOpeningEndgameExplorerMove => 'Zagraj pierwsze posunięcie z biblioteki otwarć';

  @override
  String get winPreventedBy50MoveRule => 'Bez wygranej ze względu na regułę 50 ruchów';

  @override
  String get lossSavedBy50MoveRule => 'Bez przegranej ze względu na regułę 50 ruchów';

  @override
  String get winOr50MovesByPriorMistake => 'Zwycięstwo lub 50 posunięć bez rozstrzygnięcia';

  @override
  String get lossOr50MovesByPriorMistake => 'Porażka lub 50 posunięć bez rozstrzygnięcia';

  @override
  String get unknownDueToRounding => 'Zwycięstwo/porażka gwarantowana tylko wtedy, gdy przestrzegano zwycięskiej linii bazy końcówek od ostatniego bicia lub posunięcia pionem.';

  @override
  String get allSet => 'Gotowe!';

  @override
  String get importPgn => 'Importuj PGN';

  @override
  String get delete => 'Usuń';

  @override
  String get deleteThisImportedGame => 'Czy usunąć tę partię?';

  @override
  String get replayMode => 'Tryb odtwarzania';

  @override
  String get realtimeReplay => 'Jak w grze';

  @override
  String get byCPL => 'Wg SCP';

  @override
  String get enable => 'Włącz';

  @override
  String get bestMoveArrow => 'Strzałka najlepszego ruchu';

  @override
  String get showVariationArrows => 'Pokaż strzałki wariantów';

  @override
  String get evaluationGauge => 'Wskaźnik oceny pozycji';

  @override
  String get multipleLines => 'Analizowane warianty';

  @override
  String get cpus => 'Procesory';

  @override
  String get memory => 'Pamięć RAM';

  @override
  String get infiniteAnalysis => 'Nieskończona analiza';

  @override
  String get removesTheDepthLimit => 'Usuwa limit głębokości analizy i rozgrzewa Twój komputer do czerwoności ;)';

  @override
  String get blunder => 'Błąd';

  @override
  String get mistake => 'Pomyłka';

  @override
  String get inaccuracy => 'Niedokładność';

  @override
  String get moveTimes => 'Tempo gry';

  @override
  String get flipBoard => 'Obróć szachownicę';

  @override
  String get threefoldRepetition => 'Trzykrotne powtórzenie pozycji';

  @override
  String get claimADraw => 'Ogłoś remis';

  @override
  String get offerDraw => 'Zaproponuj remis';

  @override
  String get draw => 'Remis';

  @override
  String get drawByMutualAgreement => 'Remis za obopólną zgodą';

  @override
  String get fiftyMovesWithoutProgress => '50 posunięć bez bicia i ruchu pionem';

  @override
  String get currentGames => 'Partie w toku';

  @override
  String get viewInFullSize => 'Zobacz w pełnym rozmiarze';

  @override
  String get logOut => 'Wyloguj';

  @override
  String get signIn => 'Zaloguj się';

  @override
  String get rememberMe => 'Zapamiętaj';

  @override
  String get youNeedAnAccountToDoThat => 'Do tego potrzebne jest konto';

  @override
  String get signUp => 'Zarejestruj się';

  @override
  String get computersAreNotAllowedToPlay => 'Partie graczy komputerowych lub grających z jego pomocą są zabronione. Podczas gry niedozwolone jest korzystanie z pomocy programów szachowych, baz danych oraz innych graczy. Odradzamy zakładanie wielu kont, a utrata umiaru w tym zakresie skutkować będzie zablokowaniem.';

  @override
  String get games => 'Partie';

  @override
  String get forum => 'Forum';

  @override
  String xPostedInForumY(String param1, String param2) {
    return '$param1 napisał/a w temacie $param2';
  }

  @override
  String get latestForumPosts => 'Najnowsze wpisy';

  @override
  String get players => 'Gracze';

  @override
  String get friends => 'Znajomi';

  @override
  String get otherPlayers => 'inni gracze';

  @override
  String get discussions => 'Rozmowy';

  @override
  String get today => 'Dzisiaj';

  @override
  String get yesterday => 'Wczoraj';

  @override
  String get minutesPerSide => 'Minuty na gracza';

  @override
  String get variant => 'Odmiana';

  @override
  String get variants => 'Odmiany';

  @override
  String get timeControl => 'Tempo gry';

  @override
  String get realTime => 'W czasie rzeczywistym';

  @override
  String get correspondence => 'Korespondencyjne';

  @override
  String get daysPerTurn => 'Dni na ruch';

  @override
  String get oneDay => '1 dzień';

  @override
  String get time => 'Tempo';

  @override
  String get rating => 'Ranking';

  @override
  String get ratingStats => 'Statystyki rankingowe';

  @override
  String get username => 'Nazwa użytkownika';

  @override
  String get usernameOrEmail => 'Nazwa użytkownika lub e-mail';

  @override
  String get changeUsername => 'Zmień nazwę użytkownika';

  @override
  String get changeUsernameNotSame => 'Można zmienić tylko wielkość liter, np. „JanNowak” zamiast „jannowak”.';

  @override
  String get changeUsernameDescription => 'Zmiana nazwy użytkownika może być wykonana tylko raz i dotyczy tylko wielkości liter w nazwie.';

  @override
  String get signupUsernameHint => 'Wybierz przyjazną nazwę użytkownika. Nie możesz jej później zmienić, a niestosowna nazwa spowoduje zamknięcie konta!';

  @override
  String get signupEmailHint => 'Użyjemy go tylko do resetowania hasła.';

  @override
  String get password => 'Hasło';

  @override
  String get changePassword => 'Zmień hasło';

  @override
  String get changeEmail => 'Zmień adres e-mail';

  @override
  String get email => 'E-mail';

  @override
  String get passwordReset => 'Resetuj hasło';

  @override
  String get forgotPassword => 'Nie pamiętasz hasła?';

  @override
  String get error_weakPassword => 'To hasło jest bardzo popularne i zbyt łatwe do odgadnięcia.';

  @override
  String get error_namePassword => 'Nie używaj nazwy użytkownika jako hasła.';

  @override
  String get blankedPassword => 'Użyłeś/aś tego samego hasła w innym serwisie, który został zaatakowany. Aby zapewnić bezpieczeństwo Twojego konta Lichess, musisz ustawić nowe hasło. Dziękujemy za wyrozumiałość.';

  @override
  String get youAreLeavingLichess => 'Opuszczasz Lichess';

  @override
  String get neverTypeYourPassword => 'Nigdy nie wpisuj hasła Lichess na innej stronie!';

  @override
  String proceedToX(String param) {
    return 'Przejdź do $param';
  }

  @override
  String get passwordSuggestion => 'Nie ustawiaj hasła zasugerowanego przez kogoś innego. Wykorzystają je do kradzieży Twojego konta.';

  @override
  String get emailSuggestion => 'Nie ustawiaj adresu e-mail zasugerowanego przez kogoś innego. Wykorzystają go do kradzieży Twojego konta.';

  @override
  String get emailConfirmHelp => 'Pomoc z potwierdzeniem adresu e-mail';

  @override
  String get emailConfirmNotReceived => 'Nie dotarło potwierdzenie e-mail po rejestracji?';

  @override
  String get whatSignupUsername => 'Jakiej nazwy użytkownika użyłeś/aś do rejestracji?';

  @override
  String usernameNotFound(String param) {
    return 'Nie mogliśmy znaleźć żadnego użytkownika o tej nazwie: $param.';
  }

  @override
  String get usernameCanBeUsedForNewAccount => 'Możesz użyć tej nazwy użytkownika, aby utworzyć nowe konto';

  @override
  String emailSent(String param) {
    return 'Wysłaliśmy do Ciebie e-mail na $param.';
  }

  @override
  String get emailCanTakeSomeTime => 'Dostarczenie emaila może zająć trochę czasu.';

  @override
  String get refreshInboxAfterFiveMinutes => 'Poczekaj 5 minut i odśwież swoją skrzynkę pocztową.';

  @override
  String get checkSpamFolder => 'Sprawdź również folder spamu, gdzie mógł trafić nasz e-mail. Jeśli tak, oznacz go jako nie spam.';

  @override
  String get emailForSignupHelp => 'Jeśli wszystko inne zawiedzie, wyślij nam ten e-mail:';

  @override
  String copyTextToEmail(String param) {
    return 'Skopiuj i wklej powyższy tekst i wyślij go do $param';
  }

  @override
  String get waitForSignupHelp => 'Wkrótce wrócimy do Ciebie, aby pomóc Ci w dokończeniu rejestracji.';

  @override
  String accountConfirmed(String param) {
    return 'Użytkownik $param został pomyślnie potwierdzony.';
  }

  @override
  String accountCanLogin(String param) {
    return 'Teraz możesz się zalogować jako $param.';
  }

  @override
  String get accountConfirmationEmailNotNeeded => 'Nie potrzebujesz e-maila z potwierdzeniem.';

  @override
  String accountClosed(String param) {
    return 'Konto $param jest zamknięte.';
  }

  @override
  String accountRegisteredWithoutEmail(String param) {
    return 'Konto $param zostało zarejestrowane bez adresu e-mail.';
  }

  @override
  String get rank => 'Miejsce';

  @override
  String rankX(String param) {
    return 'Miejsce: $param';
  }

  @override
  String get gamesPlayed => 'Rozegranych partii';

  @override
  String get ok => 'OK';

  @override
  String get cancel => 'Anuluj';

  @override
  String get whiteTimeOut => 'Upłynął czas białych';

  @override
  String get blackTimeOut => 'Upłynął czas czarnych';

  @override
  String get drawOfferSent => 'Wysłano propozycję remisu';

  @override
  String get drawOfferAccepted => 'Przyjęto propozycję remisu';

  @override
  String get drawOfferCanceled => 'Wycofano propozycję remisu';

  @override
  String get whiteOffersDraw => 'Białe proponują remis';

  @override
  String get blackOffersDraw => 'Czarne proponują remis';

  @override
  String get whiteDeclinesDraw => 'Białe odrzucają propozycję remisu';

  @override
  String get blackDeclinesDraw => 'Czarne odrzucają propozycję remisu';

  @override
  String get yourOpponentOffersADraw => 'Przeciwnik proponuje remis';

  @override
  String get accept => 'Przyjmij';

  @override
  String get decline => 'Odrzuć';

  @override
  String get playingRightNow => 'W toku';

  @override
  String get eventInProgress => 'W toku';

  @override
  String get finished => 'Zakończone';

  @override
  String get abortGame => 'Przerwij partię';

  @override
  String get gameAborted => 'Partia została przerwana';

  @override
  String get standard => 'Standard';

  @override
  String get customPosition => 'Niestandardowa pozycja';

  @override
  String get unlimited => 'Bez limitu';

  @override
  String get mode => 'Rodzaj';

  @override
  String get casual => 'Towarzyska';

  @override
  String get rated => 'Rankingowa';

  @override
  String get casualTournament => 'Towarzyska';

  @override
  String get ratedTournament => 'Rankingowa';

  @override
  String get thisGameIsRated => 'Partia rankingowa';

  @override
  String get rematch => 'Rewanż';

  @override
  String get rematchOfferSent => 'Wysłano propozycję rewanżu';

  @override
  String get rematchOfferAccepted => 'Przyjęto propozycję rewanżu';

  @override
  String get rematchOfferCanceled => 'Wycofano propozycję rewanżu';

  @override
  String get rematchOfferDeclined => 'Odrzucono propozycję rewanżu';

  @override
  String get cancelRematchOffer => 'Wycofaj propozycję rewanżu';

  @override
  String get viewRematch => 'Zobacz rewanż';

  @override
  String get confirmMove => 'Potwierdź ruch';

  @override
  String get play => 'Zagraj';

  @override
  String get inbox => 'Wiadomości';

  @override
  String get chatRoom => 'Czat';

  @override
  String get loginToChat => 'Zaloguj się, aby rozmawiać';

  @override
  String get youHaveBeenTimedOut => 'Zostałeś czasowo wyciszony.';

  @override
  String get spectatorRoom => 'Widzowie';

  @override
  String get composeMessage => 'Napisz wiadomość';

  @override
  String get subject => 'Temat';

  @override
  String get send => 'Wyślij';

  @override
  String get incrementInSeconds => 'Dodawany czas w sekundach';

  @override
  String get freeOnlineChess => 'Darmowe szachy online';

  @override
  String get exportGames => 'Eksportuj partie';

  @override
  String get ratingRange => 'Przedział rankingowy';

  @override
  String get thisAccountViolatedTos => 'Użytkownik tego konta naruszył warunki korzystania z Lichess';

  @override
  String get openingExplorerAndTablebase => 'Biblioteka otwarć i końcówek';

  @override
  String get takeback => 'Cofnij ruch';

  @override
  String get proposeATakeback => 'Poproś o cofnięcie ruchu';

  @override
  String get takebackPropositionSent => 'Wysłano prośbę o cofnięcie ruchu';

  @override
  String get takebackPropositionDeclined => 'Odrzucono prośbę o cofnięcie ruchu';

  @override
  String get takebackPropositionAccepted => 'Ruch został wycofany';

  @override
  String get takebackPropositionCanceled => 'Wycofano prośbę o cofnięcie ruchu';

  @override
  String get yourOpponentProposesATakeback => 'Przeciwnik chce cofnąć ruch';

  @override
  String get bookmarkThisGame => 'Dodaj do ulubionych';

  @override
  String get tournament => 'Turniej';

  @override
  String get tournaments => 'Turnieje';

  @override
  String get tournamentPoints => 'Punkty turniejowe';

  @override
  String get viewTournament => 'Wróć do turnieju';

  @override
  String get backToTournament => 'Wróć do turnieju';

  @override
  String get noDrawBeforeSwissLimit => 'Nie możesz oferować remisu przed 30 posunięciem w turnieju szwajcarskim.';

  @override
  String get thematic => 'Tematyczny';

  @override
  String yourPerfRatingIsProvisional(String param) {
    return 'Twój ranking ($param) jest prowizoryczny';
  }

  @override
  String yourPerfRatingIsTooHigh(String param1, String param2) {
    return 'Twój ranking $param2 ($param1) jest za wysoki';
  }

  @override
  String yourTopWeeklyPerfRatingIsTooHigh(String param1, String param2) {
    return 'Twój ranking tygodniowy $param2 ($param1) jest za wysoki';
  }

  @override
  String yourPerfRatingIsTooLow(String param1, String param2) {
    return 'Twój ranking $param2 ($param1) jest za niski';
  }

  @override
  String ratedMoreThanInPerf(String param1, String param2) {
    return 'Ranking ≥ $param1 ($param2)';
  }

  @override
  String ratedLessThanInPerf(String param1, String param2) {
    return 'Ranking ≤ $param1 ($param2)';
  }

  @override
  String mustBeInTeam(String param) {
    return 'Musisz należeć do klubu $param';
  }

  @override
  String youAreNotInTeam(String param) {
    return 'Nie należysz do klubu $param';
  }

  @override
  String get backToGame => 'Wróć do partii';

  @override
  String get siteDescription => 'Proste w obsłudze szachy online dla wszystkich. Nie trzeba zakładać konta, nie ma reklam, bez instalacji. Możesz grać z komputerem, z kimś, kogo znasz - albo z nieznajomymi.';

  @override
  String xJoinedTeamY(String param1, String param2) {
    return '$param1 dołączył do klubu $param2';
  }

  @override
  String xCreatedTeamY(String param1, String param2) {
    return '$param1 założył klub $param2';
  }

  @override
  String get startedStreaming => 'rozpoczyna nadawanie na żywo';

  @override
  String xStartedStreaming(String param) {
    return '$param rozpoczął streaming';
  }

  @override
  String get averageElo => 'Średni ranking';

  @override
  String get location => 'Miejsce';

  @override
  String get filterGames => 'Filtruj partie';

  @override
  String get reset => 'Przywróć domyślne';

  @override
  String get apply => 'Zastosuj';

  @override
  String get save => 'Zapisz';

  @override
  String get leaderboard => 'Najlepsi gracze';

  @override
  String get screenshotCurrentPosition => 'Zrzut ekranu aktualnej pozycji';

  @override
  String get gameAsGIF => 'Zapisz jako GIF';

  @override
  String get pasteTheFenStringHere => 'Wklej tutaj pozycję w formacie FEN';

  @override
  String get pasteThePgnStringHere => 'Wklej poniżej przebieg partii w formacie PGN';

  @override
  String get orUploadPgnFile => 'lub wgraj plik PGN';

  @override
  String get fromPosition => 'Z pozycji';

  @override
  String get continueFromHere => 'Kontynuuj z tej pozycji';

  @override
  String get toStudy => 'Opracowanie';

  @override
  String get importGame => 'Importuj partię';

  @override
  String get importGameExplanation => 'Wklejenie PGN partii daje możliwość jej odtworzenia, analizy komputerowej, rozmowy i udostępnienia.';

  @override
  String get importGameCaveat => 'Warianty zostaną usunięte. Aby je zachować, zaimportuj plik PGN jako opracowanie.';

  @override
  String get importGameDataPrivacyWarning => 'Ten zapis PGN będzie dostępny publicznie. Aby zaimportować partię tylko dla siebie, stwórz prywatne opracowanie.';

  @override
  String get thisIsAChessCaptcha => 'To jest szachowa CAPTCHA.';

  @override
  String get clickOnTheBoardToMakeYourMove => 'Wykonaj ruch i udowodnij, że jesteś człowiekiem.';

  @override
  String get captcha_fail => 'Rozwiąż zadanie szachowe.';

  @override
  String get notACheckmate => 'To nie jest mat';

  @override
  String get whiteCheckmatesInOneMove => 'Białe dają mata w jednym ruchu';

  @override
  String get blackCheckmatesInOneMove => 'Czarne dają mata w jednym ruchu';

  @override
  String get retry => 'Spróbuj jeszcze raz';

  @override
  String get reconnecting => 'Ponowne łączenie';

  @override
  String get noNetwork => 'Offline';

  @override
  String get favoriteOpponents => 'Ulubieni przeciwnicy';

  @override
  String get follow => 'Obserwuj';

  @override
  String get following => 'Obserwowany';

  @override
  String get unfollow => 'Przestań obserwować';

  @override
  String followX(String param) {
    return 'Obserwuj $param';
  }

  @override
  String unfollowX(String param) {
    return 'Przestań obserwować $param';
  }

  @override
  String get block => 'Zablokuj';

  @override
  String get blocked => 'Zablokowany';

  @override
  String get unblock => 'Odblokuj';

  @override
  String xStartedFollowingY(String param1, String param2) {
    return '$param1 obserwuje $param2';
  }

  @override
  String get more => 'Więcej';

  @override
  String get memberSince => 'Zarejestrowano';

  @override
  String lastSeenActive(String param) {
    return 'Widziano $param';
  }

  @override
  String get player => 'Gracz';

  @override
  String get list => 'Lista';

  @override
  String get graph => 'Wykres';

  @override
  String get required => 'Wymagane.';

  @override
  String get openTournaments => 'Dostępne turnieje';

  @override
  String get duration => 'Czas trwania';

  @override
  String get winner => 'Zwycięzca';

  @override
  String get standing => 'Miejsce';

  @override
  String get createANewTournament => 'Nowy turniej';

  @override
  String get tournamentCalendar => 'Kalendarz turniejowy';

  @override
  String get conditionOfEntry => 'Warunki przystąpienia:';

  @override
  String get advancedSettings => 'Ustawienia zaawansowane';

  @override
  String get safeTournamentName => 'Nadaj turniejowi neutralną nazwę.';

  @override
  String get inappropriateNameWarning => 'Nawet nieco nieodpowiednia nazwa może spowodować zamknięcie Twojego konta.';

  @override
  String get emptyTournamentName => 'Jeśli nie podasz nazwy turnieju, zostanie on nazwany od nazwiska losowo wybranego arcymistrza.';

  @override
  String get makePrivateTournament => 'Ustaw turniej jako prywatny i ogranicz dostęp za pomocą hasła';

  @override
  String get join => 'Dołącz';

  @override
  String get withdraw => 'Wycofaj się';

  @override
  String get points => 'Punkty';

  @override
  String get wins => 'Wygrane';

  @override
  String get losses => 'Przegrane';

  @override
  String get createdBy => 'Stworzony przez';

  @override
  String get tournamentIsStarting => 'Rozpoczęcie turnieju';

  @override
  String get tournamentPairingsAreNowClosed => 'Zakończono kojarzenie par.';

  @override
  String standByX(String param) {
    return 'Parowanie graczy, przygotuj się do gry, $param!';
  }

  @override
  String get pause => 'Pauza';

  @override
  String get resume => 'Wznów';

  @override
  String get youArePlaying => 'Grasz!';

  @override
  String get winRate => 'Współczynnik zwycięstw';

  @override
  String get berserkRate => 'Berserków';

  @override
  String get performance => 'Wynik';

  @override
  String get tournamentComplete => 'Turniej zakończony';

  @override
  String get movesPlayed => 'Wykonanych ruchów';

  @override
  String get whiteWins => 'Wygranych białych';

  @override
  String get blackWins => 'Wygranych czarnych';

  @override
  String get drawRate => 'Częstość remisowania';

  @override
  String get draws => 'Remisów';

  @override
  String nextXTournament(String param) {
    return 'Następny turniej $param:';
  }

  @override
  String get averageOpponent => 'Średni ranking przeciwnika';

  @override
  String get boardEditor => 'Edytor pozycji';

  @override
  String get setTheBoard => 'Ustaw szachownicę';

  @override
  String get popularOpenings => 'Popularne otwarcia';

  @override
  String get endgamePositions => 'Pozycje końcowe';

  @override
  String chess960StartPosition(String param) {
    return 'Pozycja startowa w Szachach 960: $param';
  }

  @override
  String get startPosition => 'Ustawienie początkowe';

  @override
  String get clearBoard => 'Wyczyść szachownicę';

  @override
  String get loadPosition => 'Wczytaj ustawienie';

  @override
  String get isPrivate => 'Prywatny';

  @override
  String reportXToModerators(String param) {
    return 'Zgłoś $param do moderatora';
  }

  @override
  String profileCompletion(String param) {
    return 'Kompletność profilu: $param';
  }

  @override
  String xRating(String param) {
    return 'ranking $param';
  }

  @override
  String get ifNoneLeaveEmpty => 'Jeśli nie masz, zostaw puste';

  @override
  String get profile => 'Profil';

  @override
  String get editProfile => 'Edycja profilu';

  @override
  String get realName => 'Prawdziwe nazwisko';

  @override
  String get setFlair => 'Ustaw swój emblemat';

  @override
  String get flair => 'Emblemat';

  @override
  String get youCanHideFlair => 'Istnieje ustawienie, pozwalające ukryć wszystkie emblematy użytkowników na lichess.';

  @override
  String get biography => 'O mnie';

  @override
  String get countryRegion => 'Kraj lub region';

  @override
  String get thankYou => 'Dziękujemy!';

  @override
  String get socialMediaLinks => 'Linki do mediów społecznościowych';

  @override
  String get oneUrlPerLine => 'Jeden adres URL na linię.';

  @override
  String get inlineNotation => 'Notacja ciągła';

  @override
  String get makeAStudy => 'Aby bezpiecznie zapamiętać i udostępniać, rozważ stworzenie opracowania.';

  @override
  String get clearSavedMoves => 'Usuń ruchy';

  @override
  String get previouslyOnLichessTV => 'Poprzednio w Lichess TV';

  @override
  String get onlinePlayers => 'Gracze online';

  @override
  String get activePlayers => 'Aktywni gracze';

  @override
  String get bewareTheGameIsRatedButHasNoClock => 'Miej na uwadze, że partia jest rankingowa, ale nie ma limitu czasu!';

  @override
  String get success => 'Sukces';

  @override
  String get automaticallyProceedToNextGameAfterMoving => 'Po ruchu automatycznie przejdź do kolejnej partii';

  @override
  String get autoSwitch => 'Przełącz po ruchu';

  @override
  String get puzzles => 'Zadania szachowe';

  @override
  String get onlineBots => 'Boty online';

  @override
  String get name => 'Nazwa';

  @override
  String get description => 'Opis';

  @override
  String get descPrivate => 'Prywatny opis';

  @override
  String get descPrivateHelp => 'Tekst widoczny tylko dla członków klubu. Jeśli jest ustawiony, zastępuje publiczny opis dla członków klubu.';

  @override
  String get no => 'Nie';

  @override
  String get yes => 'Tak';

  @override
  String get website => 'Strona internetowa';

  @override
  String get mobile => 'Aplikacja mobilna';

  @override
  String get help => 'Porada:';

  @override
  String get createANewTopic => 'Załóż nowy temat';

  @override
  String get topics => 'Liczba tematów';

  @override
  String get posts => 'Liczba wpisów';

  @override
  String get lastPost => 'Ostatni wpis';

  @override
  String get views => 'Wyświetleń';

  @override
  String get replies => 'Odpowiedzi';

  @override
  String get replyToThisTopic => 'Odpowiedz w tym temacie';

  @override
  String get reply => 'Odpowiedz';

  @override
  String get message => 'Wiadomość';

  @override
  String get createTheTopic => 'Załóż temat';

  @override
  String get reportAUser => 'Zgłoś użytkownika';

  @override
  String get user => 'Użytkownik';

  @override
  String get reason => 'Powód';

  @override
  String get whatIsIheMatter => 'Jakie to ma znaczenie?';

  @override
  String get cheat => 'Oszust';

  @override
  String get troll => 'Natręt (troll)';

  @override
  String get other => 'Inne';

  @override
  String get reportCheatBoostHelp => 'Wklej link do partii i wytłumacz, co złego jest w zachowaniu tego użytkownika. Nie pisz tylko \"on oszukiwał\", lecz napisz jak doszedłeś/aś do tego wniosku.';

  @override
  String get reportUsernameHelp => 'Wytłumacz, co w nazwie użytkownika jest obraźliwe. Nie pisz tylko \"nazwa jest obraźliwa\", lecz napisz jak doszedłeś/aś do tego wniosku, zwłaszcza jeśli jest mało znany, nie po angielsku, slangowy lub odniesieniem do kultury/historii.';

  @override
  String get reportProcessedFasterInEnglish => 'Twoje zgłoszenie będzie sprawdzone szybciej, jeśli zostanie napisane po angielsku.';

  @override
  String get error_provideOneCheatedGameLink => 'Podaj przynajmniej jeden odnośnik do gry, w której oszukiwano.';

  @override
  String by(String param) {
    return 'autor $param';
  }

  @override
  String importedByX(String param) {
    return 'Zaimportowane przez $param';
  }

  @override
  String get thisTopicIsNowClosed => 'Ten temat został zamknięty.';

  @override
  String get blog => 'Blog';

  @override
  String get notes => 'Notatki';

  @override
  String get typePrivateNotesHere => 'Pisz tutaj notatki prywatne';

  @override
  String get writeAPrivateNoteAboutThisUser => 'Napisz prywatną notatkę o tym użytkowniku';

  @override
  String get noNoteYet => 'Brak notatek';

  @override
  String get invalidUsernameOrPassword => 'Niepoprawne nazwa użytkownika lub hasło';

  @override
  String get incorrectPassword => 'Nieprawidłowe hasło';

  @override
  String get invalidAuthenticationCode => 'Nieprawidłowy kod uwierzytelniający';

  @override
  String get emailMeALink => 'Wyślij mi link';

  @override
  String get currentPassword => 'Aktualne hasło';

  @override
  String get newPassword => 'Nowe hasło';

  @override
  String get newPasswordAgain => 'Powtórz nowe hasło';

  @override
  String get newPasswordsDontMatch => 'Nowe hasła nie są takie same';

  @override
  String get newPasswordStrength => 'Siła hasła';

  @override
  String get clockInitialTime => 'Początkowy czas zegara';

  @override
  String get clockIncrement => 'Przyrost czasu';

  @override
  String get privacy => 'Prywatność';

  @override
  String get privacyPolicy => 'Polityka prywatności';

  @override
  String get letOtherPlayersFollowYou => 'Inni gracze mogą Cię obserwować';

  @override
  String get letOtherPlayersChallengeYou => 'Zezwól na zaproszenia od innych graczy';

  @override
  String get letOtherPlayersInviteYouToStudy => 'Inni gracze mogą zapraszać Cię do opracowania';

  @override
  String get sound => 'Dźwięk';

  @override
  String get none => 'Brak';

  @override
  String get fast => 'Szybko';

  @override
  String get normal => 'Normalnie';

  @override
  String get slow => 'Wolno';

  @override
  String get insideTheBoard => 'Na szachownicy';

  @override
  String get outsideTheBoard => 'Poza szachownicą';

  @override
  String get allSquaresOfTheBoard => 'Wszystkie pola szachownicy';

  @override
  String get onSlowGames => 'W wolniejszych partiach';

  @override
  String get always => 'Zawsze';

  @override
  String get never => 'Nigdy';

  @override
  String xCompetesInY(String param1, String param2) {
    return '$param1 przystąpił do turnieju $param2';
  }

  @override
  String get victory => 'Wygrana';

  @override
  String get defeat => 'Przegrana';

  @override
  String victoryVsYInZ(String param1, String param2, String param3) {
    return '$param1 z $param2 ($param3)';
  }

  @override
  String defeatVsYInZ(String param1, String param2, String param3) {
    return '$param1 z $param2 ($param3)';
  }

  @override
  String drawVsYInZ(String param1, String param2, String param3) {
    return '$param1 z $param2 ($param3)';
  }

  @override
  String get timeline => 'Historia';

  @override
  String get starting => 'Zaczynają się:';

  @override
  String get allInformationIsPublicAndOptional => 'Wszystkie informacje są publiczne i opcjonalne';

  @override
  String get biographyDescription => 'Napisz coś o sobie: dlaczego grasz w szachy, twoje ulubione otwarcia, partie, szachiści…';

  @override
  String get listBlockedPlayers => 'Lista zablokowanych przez Ciebie graczy';

  @override
  String get human => 'Człowiek';

  @override
  String get computer => 'Komputer';

  @override
  String get side => 'Strona';

  @override
  String get clock => 'Zegar';

  @override
  String get opponent => 'Przeciwnik';

  @override
  String get learnMenu => 'Nauka';

  @override
  String get studyMenu => 'Opracowania';

  @override
  String get practice => 'Ćwiczenia';

  @override
  String get community => 'Społeczność';

  @override
  String get tools => 'Narzędzia';

  @override
  String get increment => 'Czas dodawany';

  @override
  String get error_unknown => 'Nieprawidłowa wartość';

  @override
  String get error_required => 'To pole jest wymagane';

  @override
  String get error_email => 'Ten adres e-mail jest nieprawidłowy';

  @override
  String get error_email_acceptable => 'Ten adres e-mail jest niedopuszczalny. Sprawdź go i spróbuj ponownie.';

  @override
  String get error_email_unique => 'Adres e-mail jest nieprawidłowy lub jest już w użyciu';

  @override
  String get error_email_different => 'To jest już Twój adres e-mail';

  @override
  String error_minLength(String param) {
    return 'Minimalna długość to $param';
  }

  @override
  String error_maxLength(String param) {
    return 'Maksymalna długość to $param';
  }

  @override
  String error_min(String param) {
    return 'Musi być dłuższe lub równe $param';
  }

  @override
  String error_max(String param) {
    return 'Musi być krótsze lub równe $param';
  }

  @override
  String ifRatingIsPlusMinusX(String param) {
    return 'O rankingu ±$param';
  }

  @override
  String get ifRegistered => 'Tylko zarejestrowani';

  @override
  String get onlyExistingConversations => 'Tylko istniejące rozmowy';

  @override
  String get onlyFriends => 'Tylko znajomi';

  @override
  String get menu => 'Menu';

  @override
  String get castling => 'Roszada';

  @override
  String get whiteCastlingKingside => 'Białe O-O';

  @override
  String get blackCastlingKingside => 'Czarne O-O';

  @override
  String tpTimeSpentPlaying(String param) {
    return 'Łączny czas gry: $param';
  }

  @override
  String get watchGames => 'Oglądaj partie';

  @override
  String tpTimeSpentOnTV(String param) {
    return 'Czas w TV: $param';
  }

  @override
  String get watch => 'Oglądaj';

  @override
  String get videoLibrary => 'Wideoteka';

  @override
  String get streamersMenu => 'Streamerzy';

  @override
  String get mobileApp => 'Aplikacja mobilna';

  @override
  String get webmasters => 'Webmasterzy';

  @override
  String get about => 'Informacje o';

  @override
  String aboutX(String param) {
    return 'Informacje o $param';
  }

  @override
  String xIsAFreeYLibreOpenSourceChessServer(String param1, String param2) {
    return '$param1 jest darmowym ($param2), wolnym, bez reklam, otwartym serwerem szachowym.';
  }

  @override
  String get really => 'naprawdę';

  @override
  String get contribute => 'Wsparcie';

  @override
  String get termsOfService => 'Regulamin';

  @override
  String get sourceCode => 'Kod źródłowy';

  @override
  String get simultaneousExhibitions => 'Symultany';

  @override
  String get host => 'Symultanista';

  @override
  String hostColorX(String param) {
    return 'Kolor symultanisty: $param';
  }

  @override
  String get yourPendingSimuls => 'Twoje oczekujące symultany';

  @override
  String get createdSimuls => 'Nowe symultany';

  @override
  String get hostANewSimul => 'Nowa symultana';

  @override
  String get signUpToHostOrJoinASimul => 'Dołącz do simultany';

  @override
  String get noSimulFound => 'Nie znaleziono symultany';

  @override
  String get noSimulExplanation => 'Taka symultana nie istnieje';

  @override
  String get returnToSimulHomepage => 'Wróć do do strony głównej symultan';

  @override
  String get aboutSimul => 'Symultana to równoczesna gra z wieloma przeciwnikami.';

  @override
  String get aboutSimulImage => 'Grając na 50 szachownicach Fischer wygrał 47 partii, zremisował dwie i przegrał jedną.';

  @override
  String get aboutSimulRealLife => 'Pomysł został zaczerpnięty z rzeczywistych rozgrywek. Symultanista przemieszcza się pomiędzy szachownicami wykonując na nich posunięcia.';

  @override
  String get aboutSimulRules => 'Gdy symultana się rozpocznie, każdy gracz rozgrywa partię przeciwko symultaniście. Symultanista gra zawsze białymi. Symultana kończy się po zakończeniu wszystkich partii.';

  @override
  String get aboutSimulSettings => 'Symultany są zawsze grami towarzyskimi. Rewanż, cofanie ruchów i dodawanie czasu nie są dostępne.';

  @override
  String get create => 'Utwórz';

  @override
  String get whenCreateSimul => 'W symultanie będziesz grał równocześnie z kilkoma przeciwnikami.';

  @override
  String get simulVariantsHint => 'Gdy zaznaczysz kilka wariantów gry, każdy przeciwnik będzie mógł wybrać, który wariant chce grać.';

  @override
  String get simulClockHint => 'Ustawienia zegara Fischera. W przypadku większej liczby graczy możesz potrzebować więcej czasu.';

  @override
  String get simulAddExtraTime => 'Aby ułatwić sobie rozegranie symultany możesz ustawić dodatkowy czas dla siebie.';

  @override
  String get simulHostExtraTime => 'Dodatkowy czas dla symultanisty';

  @override
  String get simulAddExtraTimePerPlayer => 'Dodaj początkowy czas do zegara dla każdego gracza dołączającego do symultany.';

  @override
  String get simulHostExtraTimePerPlayer => 'Dodatkowy czas dla symultanisty za każdego gracza';

  @override
  String get lichessTournaments => 'Turnieje Lichess';

  @override
  String get tournamentFAQ => 'Turnieje typu Arena FAQ';

  @override
  String get timeBeforeTournamentStarts => 'Czas do rozpoczęcia turnieju';

  @override
  String get averageCentipawnLoss => 'Średnia strata w centypionach';

  @override
  String get accuracy => 'Dokładność';

  @override
  String get keyboardShortcuts => 'Skróty klawiaturowe';

  @override
  String get keyMoveBackwardOrForward => 'idź wstecz/do przodu';

  @override
  String get keyGoToStartOrEnd => 'idź na początek/koniec';

  @override
  String get keyCycleSelectedVariation => 'Powtarzaj wybrany wariant';

  @override
  String get keyShowOrHideComments => 'pokaż/ukryj komentarze';

  @override
  String get keyEnterOrExitVariation => 'wejdź/opuść wariant';

  @override
  String get keyRequestComputerAnalysis => 'Poproś o analizę komputerową, ucz się na swoich błędach';

  @override
  String get keyNextLearnFromYourMistakes => 'Następny (Ucz się na swoich błędach)';

  @override
  String get keyNextBlunder => 'Następny błąd';

  @override
  String get keyNextMistake => 'Następna pomyłka';

  @override
  String get keyNextInaccuracy => 'Następna niedokładność';

  @override
  String get keyPreviousBranch => 'Poprzedni wariant';

  @override
  String get keyNextBranch => 'Następny wariant';

  @override
  String get toggleVariationArrows => 'Pokaż strzałki wariantów';

  @override
  String get cyclePreviousOrNextVariation => 'Powtarzaj poprzedni/następny wariant';

  @override
  String get toggleGlyphAnnotations => 'Przełącz adnotacje symbolami';

  @override
  String get togglePositionAnnotations => 'Przełącz adnotacje pozycji';

  @override
  String get variationArrowsInfo => 'Strzałki wariantów pozwalają nawigować bez użycia listy posunięć.';

  @override
  String get playSelectedMove => 'wykonaj wybrane posunięcie';

  @override
  String get newTournament => 'Nowy turniej';

  @override
  String get tournamentHomeTitle => 'Turnieje szachowe z możliwością rozgrywki w różnym tempie i odmianach szachów';

  @override
  String get tournamentHomeDescription => 'Weź udział w turniejach szachowych online! Dołącz do istniejącego turnieju lub stwórz własny. Błyskawiczne, szybkie, klasyczne, Fishera, król w centrum, trzy szachy i wiele innych opcji, aby szachowa zabawa trwała w nieskończoność.';

  @override
  String get tournamentNotFound => 'Nie znaleziono turnieju';

  @override
  String get tournamentDoesNotExist => 'Taki turniej nie istnieje.';

  @override
  String get tournamentMayHaveBeenCanceled => 'Mógł zostać anulowany, jeżeli wszyscy gracze wycofali się przed jego rozpoczęciem.';

  @override
  String get returnToTournamentsHomepage => 'Wróć do turnieju';

  @override
  String weeklyPerfTypeRatingDistribution(String param) {
    return 'Tygodniowy rozkład rankingu w wariancie $param';
  }

  @override
  String yourPerfTypeRatingIsRating(String param1, String param2) {
    return 'Twój ranking ($param1) to $param2.';
  }

  @override
  String youAreBetterThanPercentOfPerfTypePlayers(String param1, String param2) {
    return 'Grasz lepiej niż $param1 graczy ($param2).';
  }

  @override
  String userIsBetterThanPercentOfPerfTypePlayers(String param1, String param2, String param3) {
    return '$param1 gra lepiej niż $param2 graczy $param3.';
  }

  @override
  String betterThanPercentPlayers(String param1, String param2) {
    return 'Jesteś lepszy niż $param1 z $param2 graczy';
  }

  @override
  String youDoNotHaveAnEstablishedPerfTypeRating(String param) {
    return 'Nie masz jeszcze ustalonego rankingu ($param).';
  }

  @override
  String get yourRating => 'Twój ranking';

  @override
  String get cumulative => 'Łącznie';

  @override
  String get glicko2Rating => 'Ranking Glicko-2';

  @override
  String get checkYourEmail => 'Sprawdź swoją skrzynkę e-mail';

  @override
  String get weHaveSentYouAnEmailClickTheLink => 'Wysłaliśmy do Ciebie wiadomość e-mail. Kliknij w link znajdujący się w e-mailu aby aktywować swoje konto.';

  @override
  String get ifYouDoNotSeeTheEmailCheckOtherPlaces => 'Jeśli nie widzisz wiadomości e-mail, sprawdź inne możliwe miejsca, takie jak kosz, spam lub inne foldery.';

  @override
  String weHaveSentYouAnEmailTo(String param) {
    return 'Wysłaliśmy wiadomość e-mail na adres $param. Skorzystaj z odnośnika znajdującego się w wiadomości, aby zresetować swoje hasło.';
  }

  @override
  String byRegisteringYouAgreeToBeBoundByOur(String param) {
    return 'Rejestrując się wyrażasz zgodę na przestrzeganie $param.';
  }

  @override
  String readAboutOur(String param) {
    return 'Przeczytaj o $param w naszym serwisie.';
  }

  @override
  String get networkLagBetweenYouAndLichess => 'Opóźnienie sieci między Tobą a lichess';

  @override
  String get timeToProcessAMoveOnLichessServer => 'Czas przetwarzania ruchu na serwerze lichess';

  @override
  String get downloadAnnotated => 'Pobierz z komentarzem';

  @override
  String get downloadRaw => 'Pobierz bez komentarza';

  @override
  String get downloadImported => 'Pobierz zaimportowane';

  @override
  String get crosstable => 'Wyniki spotkań';

  @override
  String get youCanAlsoScrollOverTheBoardToMoveInTheGame => 'Możesz także przewijać nad szachownicą, by zmieniać postęp partii.';

  @override
  String get scrollOverComputerVariationsToPreviewThem => 'Przewiń po wariantach komputera, aby je podglądać.';

  @override
  String get analysisShapesHowTo => 'Kliknij podczas trzymania Shift lub przytrzymaj prawy przycisk myszy aby rysować okręgi i strzałki na szachownicy.';

  @override
  String get letOtherPlayersMessageYou => 'Zezwól na wiadomości od innych graczy';

  @override
  String get receiveForumNotifications => 'Otrzymuj powiadomienia, kiedy ktoś wspomni o Tobie na forum';

  @override
  String get shareYourInsightsData => 'Udostępniaj szczegółowe statystyki';

  @override
  String get withNobody => 'Nikomu';

  @override
  String get withFriends => 'Tylko znajomym';

  @override
  String get withEverybody => 'Każdemu';

  @override
  String get kidMode => 'Tryb dla dzieci';

  @override
  String get kidModeIsEnabled => 'Tryb dla dzieci jest włączony.';

  @override
  String get kidModeExplanation => 'Chodzi o bezpieczeństwo. W trybie dla dzieci możliwość komunikacji w serwisie jest wyłączona. Włącz go na rzecz swoich dzieci, czy uczniów, by chronić ich przed możliwymi zagrożeniami ze strony innych użytkowników internetu.';

  @override
  String inKidModeTheLichessLogoGetsIconX(String param) {
    return 'W trybie dla dzieci logo lichess ma dodatkową ikonę $param, wiesz wtedy, że Twoje dziecko jest chronione.';
  }

  @override
  String get askYourChessTeacherAboutLiftingKidMode => 'Twoim kontem zarządza nauczyciel. Poproś go o przekazanie zarządzania Tobie.';

  @override
  String get enableKidMode => 'Włącz tryb dla dzieci';

  @override
  String get disableKidMode => 'Wyłącz tryb dla dzieci';

  @override
  String get security => 'Bezpieczeństwo';

  @override
  String get sessions => 'Sesje';

  @override
  String get revokeAllSessions => 'unieważnić wszystkie sesje';

  @override
  String get playChessEverywhere => 'Graj w szachy wszędzie';

  @override
  String get asFreeAsLichess => 'Darmowa jak całe lichess';

  @override
  String get builtForTheLoveOfChessNotMoney => 'Stworzona z miłości do szachów, nie dla pieniędzy';

  @override
  String get everybodyGetsAllFeaturesForFree => 'Wszystkie funkcje za darmo dla każdego';

  @override
  String get zeroAdvertisement => 'Brak reklam';

  @override
  String get fullFeatured => 'Bez ograniczeń';

  @override
  String get phoneAndTablet => 'Telefon i tablet';

  @override
  String get bulletBlitzClassical => 'Superbłyskawiczne, błyskawiczne, klasyczne';

  @override
  String get correspondenceChess => 'Szachy korespondencyjne';

  @override
  String get onlineAndOfflinePlay => 'Gra online i offline';

  @override
  String get viewTheSolution => 'Zobacz rozwiązanie';

  @override
  String get followAndChallengeFriends => 'Obserwowanie i gra ze znajomymi';

  @override
  String get gameAnalysis => 'Analiza partii';

  @override
  String xHostsY(String param1, String param2) {
    return '$param1 utworzył $param2';
  }

  @override
  String xJoinsY(String param1, String param2) {
    return '$param1 dołączył do $param2';
  }

  @override
  String xLikesY(String param1, String param2) {
    return '$param1 polubił $param2';
  }

  @override
  String get quickPairing => 'Szybkie parowanie';

  @override
  String get lobby => 'Poczekalnia';

  @override
  String get anonymous => 'Anonimowy';

  @override
  String yourScore(String param) {
    return 'Twój wynik: $param';
  }

  @override
  String get language => 'Język';

  @override
  String get background => 'Tło';

  @override
  String get light => 'Jasne';

  @override
  String get dark => 'Ciemne';

  @override
  String get transparent => 'Przezroczyste';

  @override
  String get deviceTheme => 'Motyw urządzenia';

  @override
  String get backgroundImageUrl => 'Adres do obrazu tła:';

  @override
  String get board => 'Szachownica';

  @override
  String get size => 'Rozmiar';

  @override
  String get opacity => 'Przezroczystość';

  @override
  String get brightness => 'Jasność';

  @override
  String get hue => 'Odcień';

  @override
  String get boardReset => 'Przywróć domyślne kolory';

  @override
  String get pieceSet => 'Zestaw bierek';

  @override
  String get embedInYourWebsite => 'Osadź na swojej stronie internetowej';

  @override
  String get usernameAlreadyUsed => 'Ta nazwa użytkownika jest już zajęta, wybierz inną.';

  @override
  String get usernamePrefixInvalid => 'Nazwa użytkownika musi zaczynać się literą.';

  @override
  String get usernameSuffixInvalid => 'Nazwa użytkownika musi kończyć się literą lub cyfrą.';

  @override
  String get usernameCharsInvalid => 'Nazwa użytkownika może zawierać tylko litery, cyfry, znaki podkreślenia i myślniki.';

  @override
  String get usernameUnacceptable => 'Ta nazwa użytkownika jest niedozwolona.';

  @override
  String get playChessInStyle => 'Graj w szachy z klasą';

  @override
  String get chessBasics => 'Podstawy gry';

  @override
  String get coaches => 'Trenerzy';

  @override
  String get invalidPgn => 'Nieprawidłowy PGN';

  @override
  String get invalidFen => 'Nieprawidłowy FEN';

  @override
  String get custom => 'Niestandardowa';

  @override
  String get notifications => 'Powiadomienia';

  @override
  String notificationsX(String param1) {
    return 'Powiadomienia: $param1';
  }

  @override
  String perfRatingX(String param) {
    return 'Ranking: $param';
  }

  @override
  String get practiceWithComputer => 'Trening z komputerem';

  @override
  String anotherWasX(String param) {
    return 'Możliwe było $param';
  }

  @override
  String bestWasX(String param) {
    return 'Najlepsze było $param';
  }

  @override
  String get youBrowsedAway => 'Oddalono się';

  @override
  String get resumePractice => 'Wznów trening';

  @override
  String get drawByFiftyMoves => 'Partia została zremisowana przez regułę pięćdziesięciu ruchów.';

  @override
  String get theGameIsADraw => 'Partia zakończona remisem.';

  @override
  String get computerThinking => 'Komputer szuka ruchu…';

  @override
  String get seeBestMove => 'Zobacz najlepszy ruch';

  @override
  String get hideBestMove => 'Ukryj najlepszy ruch';

  @override
  String get getAHint => 'Pokaż podpowiedź';

  @override
  String get evaluatingYourMove => 'Ocenianie Twojego ruchu…';

  @override
  String get whiteWinsGame => 'Wygrana białych';

  @override
  String get blackWinsGame => 'Wygrana czarnych';

  @override
  String get learnFromYourMistakes => 'Ucz się na swoich błędach';

  @override
  String get learnFromThisMistake => 'Ucz się na tym błędzie';

  @override
  String get skipThisMove => 'Pomiń ten ruch';

  @override
  String get next => 'Dalej';

  @override
  String xWasPlayed(String param) {
    return 'Zagrano $param';
  }

  @override
  String get findBetterMoveForWhite => 'Znajdź lepszy ruch dla białych';

  @override
  String get findBetterMoveForBlack => 'Znajdź lepszy ruch dla czarnych';

  @override
  String get resumeLearning => 'Wznów naukę';

  @override
  String get youCanDoBetter => 'Możesz zrobić to lepiej';

  @override
  String get tryAnotherMoveForWhite => 'Znajdź inny ruch dla białych';

  @override
  String get tryAnotherMoveForBlack => 'Znajdź inny ruch dla czarnych';

  @override
  String get solution => 'Rozwiązanie';

  @override
  String get waitingForAnalysis => 'Oczekiwanie na wynik analizy';

  @override
  String get noMistakesFoundForWhite => 'Nie znaleziono błędów białych';

  @override
  String get noMistakesFoundForBlack => 'Nie znaleziono błędów czarnych';

  @override
  String get doneReviewingWhiteMistakes => 'Przejrzano błędy białych';

  @override
  String get doneReviewingBlackMistakes => 'Przejrzano błędy czarnych';

  @override
  String get doItAgain => 'Zrób to jeszcze raz';

  @override
  String get reviewWhiteMistakes => 'Przejrzyj błędy białych';

  @override
  String get reviewBlackMistakes => 'Przejrzyj błędy czarnych';

  @override
  String get advantage => 'Przewaga';

  @override
  String get opening => 'Otwarcie';

  @override
  String get middlegame => 'Gra środkowa';

  @override
  String get endgame => 'Końcówka';

  @override
  String get conditionalPremoves => 'Ruchy warunkowe';

  @override
  String get addCurrentVariation => 'Dodaj bieżący wariant';

  @override
  String get playVariationToCreateConditionalPremoves => 'Zagraj wariant, by utworzyć ruchy warunkowe';

  @override
  String get noConditionalPremoves => 'Brak ruchów warunkowych';

  @override
  String playX(String param) {
    return 'Zagraj $param';
  }

  @override
  String get showUnreadLichessMessage => 'Otrzymałeś prywatną wiadomość od Lichess.';

  @override
  String get clickHereToReadIt => 'Kliknij tutaj, aby ją odczytać';

  @override
  String get sorry => 'Przykro nam :(';

  @override
  String get weHadToTimeYouOutForAWhile => 'Na pewien czas musieliśmy wykluczyć Cię z gry.';

  @override
  String get why => 'Dlaczego?';

  @override
  String get pleasantChessExperience => 'Naszym celem jest zapewnienie wszystkim przyjemności z gry.';

  @override
  String get goodPractice => 'W tym celu musimy zapewnić przestrzeganie dobrych praktyk przez wszystkich graczy.';

  @override
  String get potentialProblem => 'Ten komunikat jest wyświetlany po wykryciu potencjalnego problemu.';

  @override
  String get howToAvoidThis => 'Jak uniknąć takiej sytuacji?';

  @override
  String get playEveryGame => 'Podejmuj grę w każdej rozpoczętej partii.';

  @override
  String get tryToWin => 'Staraj się wygrywać (lub przynajmniej remisować) każdą rozgrywaną partię.';

  @override
  String get resignLostGames => 'Poddawaj przegrane partie (nie czekaj na upłynięcie czasu gry).';

  @override
  String get temporaryInconvenience => 'Przepraszamy za chwilowe niedogodności,';

  @override
  String get wishYouGreatGames => 'i życzymy Ci samych udanych partii na lichess.org.';

  @override
  String get thankYouForReading => 'Dziękujemy za przeczytanie!';

  @override
  String get lifetimeScore => 'Wynik wszystkich partii';

  @override
  String get currentMatchScore => 'Wynik bieżącego meczu';

  @override
  String get agreementAssistance => 'Zgadzam się nie korzystać z pomocy podczas gry (programów szachowych, książek, baz danych, czy innych osób).';

  @override
  String get agreementNice => 'Zgadzam się odnosić zawsze z szacunkiem do innych graczy.';

  @override
  String agreementMultipleAccounts(String param) {
    return 'Zgadzam się, że nie będę tworzyć wielu kont (z wyjątkiem powodów podanych w $param).';
  }

  @override
  String get agreementPolicy => 'Zgadzam się przestrzegać wszystkich zasad Lichess.';

  @override
  String get searchOrStartNewDiscussion => 'Szukaj lub rozpocznij nową rozmowę';

  @override
  String get edit => 'Edytuj';

  @override
  String get bullet => 'Bullet';

  @override
  String get blitz => 'Blitz';

  @override
  String get rapid => 'Szybkie';

  @override
  String get classical => 'Klasyczne';

  @override
  String get ultraBulletDesc => 'Partie szalenie szybkie: mniej niż 30 sekund';

  @override
  String get bulletDesc => 'Partie bardzo szybkie: mniej niż 3 minuty';

  @override
  String get blitzDesc => 'Partie szybkie: 3 do 8 minut';

  @override
  String get rapidDesc => 'Partie szybkie: 8 do 25 minut';

  @override
  String get classicalDesc => 'Partie klasyczne: 25 minut i więcej';

  @override
  String get correspondenceDesc => 'Partie korespondencyjne: jeden lub kilka dni na każdy ruch';

  @override
  String get puzzleDesc => 'Trener taktyk szachowych';

  @override
  String get important => 'Ważne';

  @override
  String yourQuestionMayHaveBeenAnswered(String param1) {
    return 'Twoje pytanie może już mieć odpowiedź $param1';
  }

  @override
  String get inTheFAQ => 'w F.A.Q.';

  @override
  String toReportSomeoneForCheatingOrBadBehavior(String param1) {
    return 'Aby zgłosić użytkownika za oszustwo lub złe zachowanie, $param1';
  }

  @override
  String get useTheReportForm => 'użyj formularza raportu';

  @override
  String toRequestSupport(String param1) {
    return 'Aby poprosić o pomoc, $param1';
  }

  @override
  String get tryTheContactPage => 'użyj strony kontaktowej';

  @override
  String makeSureToRead(String param1) {
    return 'Koniecznie przeczytaj $param1';
  }

  @override
  String get theForumEtiquette => 'etykieta forum';

  @override
  String get thisTopicIsArchived => 'Ten temat został zarchiwizowany i nie można już na niego odpowiedzieć.';

  @override
  String joinTheTeamXToPost(String param1) {
    return 'Dołącz do $param1, aby publikować na tym forum';
  }

  @override
  String teamNamedX(String param1) {
    return 'Klub $param1';
  }

  @override
  String get youCannotPostYetPlaySomeGames => 'Nie możesz jeszcze publikować na forach. Rozegraj najpierw kilka partii!';

  @override
  String get subscribe => 'Subskrybuj';

  @override
  String get unsubscribe => 'Zakończ subskrybcję';

  @override
  String mentionedYouInX(String param1) {
    return 'wspomniał o tobie w \"$param1\".';
  }

  @override
  String xMentionedYouInY(String param1, String param2) {
    return '$param1 wspomniał o tobie w \"$param2\".';
  }

  @override
  String invitedYouToX(String param1) {
    return 'zaprosił Cię do \"$param1\".';
  }

  @override
  String xInvitedYouToY(String param1, String param2) {
    return '$param1 zaprosił się do \"$param2\".';
  }

  @override
  String get youAreNowPartOfTeam => 'Należysz teraz do klubu.';

  @override
  String youHaveJoinedTeamX(String param1) {
    return 'Dołączono do \"$param1\".';
  }

  @override
  String get someoneYouReportedWasBanned => 'Konto kogoś, kogo zgłosiłeś/aś, zostało zablokowane';

  @override
  String get congratsYouWon => 'Gratulacje, wygrałeś/aś!';

  @override
  String gameVsX(String param1) {
    return 'Partia przeciwko $param1';
  }

  @override
  String resVsX(String param1, String param2) {
    return '$param1 vs $param2';
  }

  @override
  String get lostAgainstTOSViolator => 'Przegrałeś/aś z kimś, kto naruszył warunki użytkowania Lichess';

  @override
  String refundXpointsTimeControlY(String param1, String param2) {
    return 'Zwrot: $param1 $param2 punktów rankingu.';
  }

  @override
  String get timeAlmostUp => 'Czas prawie minął!';

  @override
  String get clickToRevealEmailAddress => '[Kliknij, aby ujawnić adres e-mail]';

  @override
  String get download => 'Pobierz';

  @override
  String get coachManager => 'Menedżer trenera';

  @override
  String get streamerManager => 'Menedżer streamera';

  @override
  String get cancelTournament => 'Anuluj turniej';

  @override
  String get tournDescription => 'Opis turnieju';

  @override
  String get tournDescriptionHelp => 'Czy chcesz powiedzieć coś szczególnego uczestnikom? Pisz krótko i na temat. Istnieje możliwość dodania odnośników: [text](https://url)';

  @override
  String get ratedFormHelp => 'Partie wpływają\nna ranking graczy';

  @override
  String get onlyMembersOfTeam => 'Tylko członkowie klubu';

  @override
  String get noRestriction => 'Bez ograniczeń';

  @override
  String get minimumRatedGames => 'Minimalna liczba partii rankingowych';

  @override
  String get minimumRating => 'Minimalny ranking';

  @override
  String get maximumWeeklyRating => 'Maksymalny tygodniowy ranking';

  @override
  String positionInputHelp(String param) {
    return 'Wklej poprawny FEN, aby rozpocząć każdą partię z danej pozycji.\nDziała tylko dla standardowych gier, nie działa dla wariantów.\nMożesz użyć $param , aby wygenerować pozycję FEN, a następnie wkleić ją tutaj.\nPozostaw puste, aby rozpoczynać partie z normalnej pozycji początkowej.';
  }

  @override
  String get cancelSimul => 'Anuluj symultanę';

  @override
  String get simulHostcolor => 'Kolor prowadzącego symultanę dla każdej partii';

  @override
  String get estimatedStart => 'Szacowany czas rozpoczęcia';

  @override
  String simulFeatured(String param) {
    return 'Dostępna na $param';
  }

  @override
  String simulFeaturedHelp(String param) {
    return 'Pokaż symultanę wszystkim na $param. Wyłącz dla prywatnych symultan.';
  }

  @override
  String get simulDescription => 'Opis symultany';

  @override
  String get simulDescriptionHelp => 'Wiadomość do przekazania uczestnikom';

  @override
  String markdownAvailable(String param) {
    return '$param jest dostępny dla bardziej zaawansowanej składni.';
  }

  @override
  String get embedsAvailable => 'Wklej adres URL partii lub adres URL rozdziału opracowania, aby go osadzć.';

  @override
  String get inYourLocalTimezone => 'W Twojej lokalnej strefie czasowej';

  @override
  String get tournChat => 'Czat turniejowy';

  @override
  String get noChat => 'Wyłącz czat';

  @override
  String get onlyTeamLeaders => 'Tylko liderzy klubu';

  @override
  String get onlyTeamMembers => 'Tylko członkowie klubu';

  @override
  String get navigateMoveTree => 'Nawiguj drzewo ruchów';

  @override
  String get mouseTricks => 'Gesty myszy';

  @override
  String get toggleLocalAnalysis => 'Włącz/wyłącz analizę lokalnego komputera';

  @override
  String get toggleAllAnalysis => 'Włącz/wyłącz analizę komputera';

  @override
  String get playComputerMove => 'Zagraj najlepszy ruch komputera';

  @override
  String get analysisOptions => 'Opcje analizy';

  @override
  String get focusChat => 'Aktywuj czat';

  @override
  String get showHelpDialog => 'Pokaż okno pomocy';

  @override
  String get reopenYourAccount => 'Otwórz ponownie swoje konto';

  @override
  String get closedAccountChangedMind => 'Jeśli zamknąłeś/aś swoje konto, ale zmieniłeś/aś zdanie, otrzymasz jedną szansę na jego odzyskanie.';

  @override
  String get onlyWorksOnce => 'To zadziała tylko raz.';

  @override
  String get cantDoThisTwice => 'Jeśli zamkniesz swoje konto po raz drugi, nie będzie możliwości jego odzyskania.';

  @override
  String get emailAssociatedToaccount => 'Adres e-mail powiązany z kontem';

  @override
  String get sentEmailWithLink => 'Wysłaliśmy Ci wiadomość e-mail z linkiem.';

  @override
  String get tournamentEntryCode => 'Kod dostępu do turnieju';

  @override
  String get hangOn => 'Zaczekaj!';

  @override
  String gameInProgress(String param) {
    return 'Rozgrywasz partię z $param.';
  }

  @override
  String get abortTheGame => 'Przerwij partię';

  @override
  String get resignTheGame => 'Poddaj się';

  @override
  String get youCantStartNewGame => 'Nie możesz rozpocząć nowej partii, dopóki ta nie zostanie zakończona.';

  @override
  String get since => 'Od';

  @override
  String get until => 'Do';

  @override
  String get lichessDbExplanation => 'Partie rankingowe pobrane od wszystkich graczy Lichess';

  @override
  String get switchSides => 'Zmień kolor';

  @override
  String get closingAccountWithdrawAppeal => 'Zamknięcie konta spowoduje wycofanie Twojego odwołania';

  @override
  String get ourEventTips => 'Nasze wskazówki dotyczące organizacji wydarzeń';

  @override
  String get instructions => 'Instrukcje';

  @override
  String get showMeEverything => 'Pokaż mi wszystko';

  @override
  String get lichessPatronInfo => 'Lichess jest organizacją niedochodową i całkowicie darmowym otwartym oprogramowaniem.\nWszystkie koszty operacyjne, rozwój i treści są finansowane wyłącznie z darowizn użytkowników.';

  @override
  String get nothingToSeeHere => 'W tej chwili nie ma nic do zobaczenia.';

  @override
  String get stats => 'Statystyki';

  @override
  String opponentLeftCounter(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Przeciwnik opuścił grę. Możesz ogłosić wygraną za $count sekund.',
      many: 'Przeciwnik opuścił grę. Możesz ogłosić wygraną za $count sekund.',
      few: 'Przeciwnik opuścił grę. Możesz ogłosić wygraną za $count sekundy.',
      one: 'Przeciwnik opuścił grę. Możesz ogłosić wygraną za $count sekundę.',
    );
    return '$_temp0';
  }

  @override
  String mateInXHalfMoves(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Mat w $count posunięciach',
      many: 'Mat w $count posunięciach',
      few: 'Mat w $count posunięciach',
      one: 'Mat w $count posunięciu',
    );
    return '$_temp0';
  }

  @override
  String nbBlunders(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count błędów',
      many: '$count błędów',
      few: '$count błędy',
      one: '$count błąd',
    );
    return '$_temp0';
  }

  @override
  String nbMistakes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count pomyłek',
      many: '$count pomyłek',
      few: '$count pomyłki',
      one: '$count pomyłka',
    );
    return '$_temp0';
  }

  @override
  String nbInaccuracies(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count niedokładności',
      many: '$count niedokładności',
      few: '$count niedokładności',
      one: '$count niedokładność',
    );
    return '$_temp0';
  }

  @override
  String nbPlayers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count graczy',
      many: '$count graczy',
      few: '$count graczy',
      one: '$count gracz',
    );
    return '$_temp0';
  }

  @override
  String nbGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count partii',
      many: '$count partii',
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
      other: '$count ranking na podstawie $param2 partii',
      many: '$count ranking na podstawie $param2 partii',
      few: '$count ranking na podstawie $param2 partii',
      one: '$count ranking na podstawie $param2 partii',
    );
    return '$_temp0';
  }

  @override
  String nbBookmarks(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ulubionych partii',
      many: '$count ulubiona partii',
      few: '$count ulubiona partie',
      one: '$count ulubiona partia',
    );
    return '$_temp0';
  }

  @override
  String nbDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count dni',
      many: '$count dni',
      few: '$count dni',
      one: '$count dzień',
    );
    return '$_temp0';
  }

  @override
  String nbHours(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count godzin',
      many: '$count godzin',
      few: '$count godziny',
      one: '$count godzina',
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
      other: 'Ranking jest aktualizowany co $count minut',
      many: 'Ranking jest aktualizowany co $count minut',
      few: 'Ranking jest aktualizowany co $count minuty',
      one: 'Ranking jest aktualizowany co minutę',
    );
    return '$_temp0';
  }

  @override
  String nbPuzzles(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count zadań',
      many: '$count zadań',
      few: '$count zadania',
      one: '$count zadanie',
    );
    return '$_temp0';
  }

  @override
  String nbGamesWithYou(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count partii z Tobą',
      many: '$count partii z Tobą',
      few: '$count partie z Tobą',
      one: '$count partia z Tobą',
    );
    return '$_temp0';
  }

  @override
  String nbRated(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count rankingowych',
      many: '$count rankingowych',
      few: '$count rankingowe',
      one: '$count rankingowa',
    );
    return '$_temp0';
  }

  @override
  String nbWins(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count wygranych',
      many: '$count wygranych',
      few: '$count wygrane',
      one: '$count wygrana',
    );
    return '$_temp0';
  }

  @override
  String nbLosses(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count przegranych',
      many: '$count przegranych',
      few: '$count przegrane',
      one: '$count przegrana',
    );
    return '$_temp0';
  }

  @override
  String nbDraws(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count remisów',
      many: '$count remisów',
      few: '$count remisy',
      one: '$count remis',
    );
    return '$_temp0';
  }

  @override
  String nbPlaying(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count w toku',
      many: '$count w toku',
      few: '$count w toku',
      one: '$count w toku',
    );
    return '$_temp0';
  }

  @override
  String giveNbSeconds(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Dodaj $count sekund',
      many: 'Dodaj $count sekund',
      few: 'Dodaj $count sekundy',
      one: 'Dodaj $count sekundę',
    );
    return '$_temp0';
  }

  @override
  String nbTournamentPoints(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count punktów turniejowych',
      many: '$count punktów turniejowych',
      few: '$count punkty turniejowe',
      one: '$count punkt turniejowy',
    );
    return '$_temp0';
  }

  @override
  String nbStudies(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count opracowań',
      many: '$count opracowań',
      few: '$count opracowania',
      one: '$count opracowanie',
    );
    return '$_temp0';
  }

  @override
  String nbSimuls(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count symultan',
      many: '$count symultan',
      few: '$count symultany',
      one: '$count symultana',
    );
    return '$_temp0';
  }

  @override
  String moreThanNbRatedGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '≥ $count partii rankingowych',
      many: '≥ $count partii rankingowych',
      few: '≥ $count partie rankingowe',
      one: '≥ $count partia rankingowa',
    );
    return '$_temp0';
  }

  @override
  String moreThanNbPerfRatedGames(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Przynajmniej $count partii rankingowych ($param2)',
      many: 'Przynajmniej $count partii rankingowych ($param2)',
      few: 'Przynajmniej $count partie rankingowe ($param2)',
      one: 'Przynajmniej $count partia rankingowa ($param2)',
    );
    return '$_temp0';
  }

  @override
  String needNbMorePerfGames(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Musisz rozegrać jeszcze $count partie rankingowe ($param2)',
      many: 'Musisz rozegrać jeszcze $count partie rankingowe ($param2)',
      few: 'Musisz rozegrać jeszcze $count partie rankingowe ($param2)',
      one: 'Musisz rozegrać jeszcze $count partię rankingową ($param2)',
    );
    return '$_temp0';
  }

  @override
  String needNbMoreGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Musisz rozegrać jeszcze $count partii rankingowych',
      many: 'Musisz rozegrać jeszcze $count partii rankingowych',
      few: 'Musisz rozegrać jeszcze $count partie rankingowe',
      one: 'Musisz rozegrać jeszcze $count partię rankingową',
    );
    return '$_temp0';
  }

  @override
  String nbImportedGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count zaimportowana partii',
      many: '$count zaimportowana partii',
      few: '$count zaimportowana partie',
      one: '$count zaimportowana partia',
    );
    return '$_temp0';
  }

  @override
  String nbFriendsOnline(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count znajomych online',
      many: '$count znajomych online',
      few: '$count znajomych online',
      one: '$count znajomy online',
    );
    return '$_temp0';
  }

  @override
  String nbFollowers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count obserwujących',
      many: '$count obserwujących',
      few: '$count obserwujących',
      one: '$count obserwujący',
    );
    return '$_temp0';
  }

  @override
  String nbFollowing(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count obserwowanych',
      many: '$count obserwowanych',
      few: '$count obserwowanych',
      one: '$count obserwowany',
    );
    return '$_temp0';
  }

  @override
  String lessThanNbMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Poniżej $count minut',
      many: 'Poniżej $count minut',
      few: 'Poniżej $count minut',
      one: 'Poniżej $count minuty',
    );
    return '$_temp0';
  }

  @override
  String nbGamesInPlay(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count partii w toku',
      many: '$count partii w toku',
      few: '$count partie w toku',
      one: '$count partia w toku',
    );
    return '$_temp0';
  }

  @override
  String maximumNbCharacters(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Maksymalnie: $count znaków.',
      many: 'Maksymalnie: $count znaków.',
      few: 'Maksymalnie: $count znaki.',
      one: 'Maksymalnie: $count znak.',
    );
    return '$_temp0';
  }

  @override
  String blocks(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count zablokowanych',
      many: '$count zablokowanych',
      few: '$count zablokowanych',
      one: '$count zablokowany',
    );
    return '$_temp0';
  }

  @override
  String nbForumPosts(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count wpisów na forum',
      many: '$count wpisów na forum',
      few: '$count wpisy na forum',
      one: '$count wpis na forum',
    );
    return '$_temp0';
  }

  @override
  String nbPerfTypePlayersThisWeek(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count graczy ($param2) w tym tygodniu.',
      many: '$count graczy w tym tygodniu ($param2).',
      few: '$count graczy w tym tygodniu ($param2).',
      one: '$count gracz w tym tygodniu ($param2).',
    );
    return '$_temp0';
  }

  @override
  String availableInNbLanguages(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Dostępna w $count językach!',
      many: 'Dostępna w $count językach!',
      few: 'Dostępna w $count językach!',
      one: 'Dostępna w $count języku!',
    );
    return '$_temp0';
  }

  @override
  String nbSecondsToPlayTheFirstMove(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count sekund na wykonanie pierwszego ruchu',
      many: '$count sekund na wykonanie pierwszego ruchu',
      few: '$count sekundy na wykonanie pierwszego ruchu',
      one: '$count sekunda na wykonanie pierwszego ruchu',
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
      other: 'i zapisz $count wariantów warunkowych',
      many: 'i zapisz $count wariantów warunkowych',
      few: 'i zapisz $count warianty warunkowe',
      one: 'i zapisz wariant warunkowy',
    );
    return '$_temp0';
  }

  @override
  String get stormMoveToStart => 'Wykonaj ruch, aby zacząć';

  @override
  String get stormYouPlayTheWhitePiecesInAllPuzzles => 'Grasz białymi we wszystkich łamigłówkach';

  @override
  String get stormYouPlayTheBlackPiecesInAllPuzzles => 'We wszystkich zadaniach grasz czarnymi';

  @override
  String get stormPuzzlesSolved => 'liczba rozwiązanych zadań';

  @override
  String get stormNewDailyHighscore => 'Nowy rekord dnia!';

  @override
  String get stormNewWeeklyHighscore => 'Nowy rekord tygodnia!';

  @override
  String get stormNewMonthlyHighscore => 'Nowy rekord miesiąca!';

  @override
  String get stormNewAllTimeHighscore => 'Nowy rekord!';

  @override
  String stormPreviousHighscoreWasX(String param) {
    return 'Poprzedni rekord wynosił $param';
  }

  @override
  String get stormPlayAgain => 'Zagraj ponownie';

  @override
  String stormHighscoreX(String param) {
    return 'Rekord: $param';
  }

  @override
  String get stormScore => 'Wynik';

  @override
  String get stormMoves => 'Posunięcia';

  @override
  String get stormAccuracy => 'Dokładność';

  @override
  String get stormCombo => 'Seria poprawnych posunięć';

  @override
  String get stormTime => 'Czas';

  @override
  String get stormTimePerMove => 'Czas na posunięcie';

  @override
  String get stormHighestSolved => 'Najtrudniejsze rozwiązane zadanie';

  @override
  String get stormPuzzlesPlayed => 'Rozwiązywane zadania';

  @override
  String get stormNewRun => 'Nowa seria (klawisz skrótu: spacja)';

  @override
  String get stormEndRun => 'Koniec (klawisz skrótu: Enter)';

  @override
  String get stormHighscores => 'Najlepsze wyniki';

  @override
  String get stormViewBestRuns => 'Zobacz najlepsze serie';

  @override
  String get stormBestRunOfDay => 'Najlepsza seria dnia';

  @override
  String get stormRuns => 'Serie zadań';

  @override
  String get stormGetReady => 'Przygotuj się!';

  @override
  String get stormWaitingForMorePlayers => 'Oczekiwanie na dołączenie większej liczby graczy...';

  @override
  String get stormRaceComplete => 'Wyścig zakończony!';

  @override
  String get stormSpectating => 'Obserwowanie';

  @override
  String get stormJoinTheRace => 'Dołącz do wyścigu!';

  @override
  String get stormStartTheRace => 'Rozpocznij wyścig';

  @override
  String stormYourRankX(String param) {
    return 'Twoja pozycja: $param';
  }

  @override
  String get stormWaitForRematch => 'Poczekaj na rewanż';

  @override
  String get stormNextRace => 'Następny wyścig';

  @override
  String get stormJoinRematch => 'Dołącz do rewanżu';

  @override
  String get stormWaitingToStart => 'Oczekiwanie na rozpoczęcie';

  @override
  String get stormCreateNewGame => 'Utwórz nową grę';

  @override
  String get stormJoinPublicRace => 'Dołącz do publicznego wyścigu';

  @override
  String get stormRaceYourFriends => 'Ścigaj się ze znajomymi';

  @override
  String get stormSkip => 'pomiń';

  @override
  String get stormSkipHelp => 'W każdym wyścigu możesz pominąć jeden ruch:';

  @override
  String get stormSkipExplanation => 'Pomiń ten ruch aby zachować serię! Działa tylko raz na wyścig.';

  @override
  String get stormFailedPuzzles => 'Zadania nieudane';

  @override
  String get stormSlowPuzzles => 'Zadania bez limitu czasu';

  @override
  String get stormSkippedPuzzle => 'Pominięte zadania';

  @override
  String get stormThisWeek => 'W tym tygodniu';

  @override
  String get stormThisMonth => 'W tym miesiącu';

  @override
  String get stormAllTime => 'Od początku';

  @override
  String get stormClickToReload => 'Kliknij, aby przeładować';

  @override
  String get stormThisRunHasExpired => 'To uruchomienie wygasło!';

  @override
  String get stormThisRunWasOpenedInAnotherTab => 'To uruchomienie zostało już otwarte w innej karcie!';

  @override
  String stormXRuns(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count prób',
      many: '$count prób',
      few: '$count próby',
      one: '1 próba',
    );
    return '$_temp0';
  }

  @override
  String stormPlayedNbRunsOfPuzzleStorm(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Rozegrano $count sesji $param2',
      many: 'Rozegrano $count sesji $param2',
      few: 'Rozegrano $count sesje $param2',
      one: 'Rozegrano jedną sesję $param2',
    );
    return '$_temp0';
  }

  @override
  String get streamerLichessStreamers => 'Streamerzy Lichess';

  @override
  String get studyPrivate => 'Prywatne';

  @override
  String get studyMyStudies => 'Moje opracowania';

  @override
  String get studyStudiesIContributeTo => 'Opracowania, które współtworzę';

  @override
  String get studyMyPublicStudies => 'Moje publiczne opracowania';

  @override
  String get studyMyPrivateStudies => 'Moje prywatne opracowania';

  @override
  String get studyMyFavoriteStudies => 'Moje ulubione opracowania';

  @override
  String get studyWhatAreStudies => 'Czym są opracowania?';

  @override
  String get studyAllStudies => 'Wszystkie opracowania';

  @override
  String studyStudiesCreatedByX(String param) {
    return 'Opracowanie stworzone przez $param';
  }

  @override
  String get studyNoneYet => 'Jeszcze brak.';

  @override
  String get studyHot => 'Hity';

  @override
  String get studyDateAddedNewest => 'Data dodania (od najnowszych)';

  @override
  String get studyDateAddedOldest => 'Data dodania (od najstarszych)';

  @override
  String get studyRecentlyUpdated => 'Ostatnio aktualizowane';

  @override
  String get studyMostPopular => 'Najpopularniejsze';

  @override
  String get studyAlphabetical => 'Alfabetycznie';

  @override
  String get studyAddNewChapter => 'Dodaj nowy rozdział';

  @override
  String get studyAddMembers => 'Dodaj uczestników';

  @override
  String get studyInviteToTheStudy => 'Zaproś do opracowania';

  @override
  String get studyPleaseOnlyInvitePeopleYouKnow => 'Zapraszaj do opracowania tylko znajomych, którzy chcą w nim aktywnie uczestniczyć.';

  @override
  String get studySearchByUsername => 'Szukaj wg nazwy użytkownika';

  @override
  String get studySpectator => 'Obserwator';

  @override
  String get studyContributor => 'Współautor';

  @override
  String get studyKick => 'Wyrzuć';

  @override
  String get studyLeaveTheStudy => 'Opuść opracowanie';

  @override
  String get studyYouAreNowAContributor => 'Jesteś teraz współautorem';

  @override
  String get studyYouAreNowASpectator => 'Jesteś teraz obserwatorem';

  @override
  String get studyPgnTags => 'Znaczniki PGN';

  @override
  String get studyLike => 'Lubię to';

  @override
  String get studyUnlike => 'Cofnij polubienie';

  @override
  String get studyNewTag => 'Nowy znacznik';

  @override
  String get studyCommentThisPosition => 'Skomentuj tę pozycję';

  @override
  String get studyCommentThisMove => 'Skomentuj ten ruch';

  @override
  String get studyAnnotateWithGlyphs => 'Dodaj adnotacje symbolami';

  @override
  String get studyTheChapterIsTooShortToBeAnalysed => 'Rozdział jest zbyt krótki do analizy.';

  @override
  String get studyOnlyContributorsCanRequestAnalysis => 'Tylko współautorzy opracowania mogą prosić o analizę komputerową.';

  @override
  String get studyGetAFullComputerAnalysis => 'Uzyskaj pełną, zdalną analizę komputerową głównego wariantu.';

  @override
  String get studyMakeSureTheChapterIsComplete => 'Upewnij się, że rozdział jest kompletny. O jego analizę możesz poprosić tylko raz.';

  @override
  String get studyAllSyncMembersRemainOnTheSamePosition => 'Wszyscy zsynchronizowani uczestnicy pozostają na tej samej pozycji';

  @override
  String get studyShareChanges => 'Współdzielenie zmian z obserwatorami i ich zapis na serwerze';

  @override
  String get studyPlaying => 'W toku';

  @override
  String get studyShowEvalBar => 'Paski ewaluacji';

  @override
  String get studyFirst => 'Pierwszy';

  @override
  String get studyPrevious => 'Poprzedni';

  @override
  String get studyNext => 'Następny';

  @override
  String get studyLast => 'Ostatni';

  @override
  String get studyShareAndExport => 'Udostępnianie i eksport';

  @override
  String get studyCloneStudy => 'Powiel';

  @override
  String get studyStudyPgn => 'PGN opracowania';

  @override
  String get studyDownloadAllGames => 'Pobierz wszystkie partie';

  @override
  String get studyChapterPgn => 'PGN rozdziału';

  @override
  String get studyCopyChapterPgn => 'Kopiuj PGN';

  @override
  String get studyDownloadGame => 'Pobierz partię';

  @override
  String get studyStudyUrl => 'Link do opracowania';

  @override
  String get studyCurrentChapterUrl => 'URL bieżącego rozdziału';

  @override
  String get studyYouCanPasteThisInTheForumToEmbed => 'Możesz wkleić to, aby osadzić na forum';

  @override
  String get studyStartAtInitialPosition => 'Rozpocznij z pozycji początkowej';

  @override
  String studyStartAtX(String param) {
    return 'Rozpocznij od $param';
  }

  @override
  String get studyEmbedInYourWebsite => 'Udostępnij na swojej stronie lub na blogu';

  @override
  String get studyReadMoreAboutEmbedding => 'Dowiedz się więcej o osadzaniu';

  @override
  String get studyOnlyPublicStudiesCanBeEmbedded => 'Tylko publiczne opracowania mogą być osadzane!';

  @override
  String get studyOpen => 'Otwórz';

  @override
  String studyXBroughtToYouByY(String param1, String param2) {
    return '$param1 przygotowane przez $param2';
  }

  @override
  String get studyStudyNotFound => 'Nie znaleziono opracowania';

  @override
  String get studyEditChapter => 'Edytuj rozdział';

  @override
  String get studyNewChapter => 'Nowy rozdział';

  @override
  String studyImportFromChapterX(String param) {
    return 'Zaimportuj z $param';
  }

  @override
  String get studyOrientation => 'Orientacja';

  @override
  String get studyAnalysisMode => 'Rodzaj analizy';

  @override
  String get studyPinnedChapterComment => 'Przypięty komentarz';

  @override
  String get studySaveChapter => 'Zapisz rozdział';

  @override
  String get studyClearAnnotations => 'Usuń adnotacje';

  @override
  String get studyClearVariations => 'Wyczyść warianty';

  @override
  String get studyDeleteChapter => 'Usuń rozdział';

  @override
  String get studyDeleteThisChapter => 'Usunąć ten rozdział? Nie będzie można tego cofnąć!';

  @override
  String get studyClearAllCommentsInThisChapter => 'Usunąć wszystkie komentarze i oznaczenia w tym rozdziale?';

  @override
  String get studyRightUnderTheBoard => 'Pod szachownicą, po prawej stronie';

  @override
  String get studyNoPinnedComment => 'Brak';

  @override
  String get studyNormalAnalysis => 'Normalna';

  @override
  String get studyHideNextMoves => 'Ukryj następne posunięcia';

  @override
  String get studyInteractiveLesson => 'Lekcja interaktywna';

  @override
  String studyChapterX(String param) {
    return 'Rozdział $param';
  }

  @override
  String get studyEmpty => 'Pusty';

  @override
  String get studyStartFromInitialPosition => 'Rozpocznij z pozycji początkowej';

  @override
  String get studyEditor => 'Edytor';

  @override
  String get studyStartFromCustomPosition => 'Rozpocznij z ustawionej pozycji';

  @override
  String get studyLoadAGameByUrl => 'Zaimportuj partię z linku';

  @override
  String get studyLoadAPositionFromFen => 'Zaimportuj partię z FEN';

  @override
  String get studyLoadAGameFromPgn => 'Zaimportuj partię z PGN';

  @override
  String get studyAutomatic => 'Automatycznie';

  @override
  String get studyUrlOfTheGame => 'Link do partii';

  @override
  String studyLoadAGameFromXOrY(String param1, String param2) {
    return 'Zaimportuj partię z $param1 lub $param2';
  }

  @override
  String get studyCreateChapter => 'Stwórz rozdział';

  @override
  String get studyCreateStudy => 'Stwórz opracowanie';

  @override
  String get studyEditStudy => 'Edytuj opracowanie';

  @override
  String get studyVisibility => 'Widoczność';

  @override
  String get studyPublic => 'Publiczne';

  @override
  String get studyUnlisted => 'Niepubliczne';

  @override
  String get studyInviteOnly => 'Tylko zaproszeni';

  @override
  String get studyAllowCloning => 'Pozwól kopiować';

  @override
  String get studyNobody => 'Nikt';

  @override
  String get studyOnlyMe => 'Tylko ja';

  @override
  String get studyContributors => 'Współautorzy';

  @override
  String get studyMembers => 'Uczestnicy';

  @override
  String get studyEveryone => 'Każdy';

  @override
  String get studyEnableSync => 'Włącz synchronizację';

  @override
  String get studyYesKeepEveryoneOnTheSamePosition => 'Tak: utrzymaj wszystkich w tej samej pozycji';

  @override
  String get studyNoLetPeopleBrowseFreely => 'Nie: pozwól oglądać wszystkim';

  @override
  String get studyPinnedStudyComment => 'Przypięte komentarze';

  @override
  String get studyStart => 'Rozpocznij';

  @override
  String get studySave => 'Zapisz';

  @override
  String get studyClearChat => 'Wyczyść czat';

  @override
  String get studyDeleteTheStudyChatHistory => 'Usunąć historię czatu opracowania? Nie będzie można tego cofnąć!';

  @override
  String get studyDeleteStudy => 'Usuń opracowanie';

  @override
  String studyConfirmDeleteStudy(String param) {
    return 'Usunąć opracowanie? Nie będzie można go odzyskać! Wpisz nazwę opracowania, aby potwierdzić operację: $param';
  }

  @override
  String get studyWhereDoYouWantToStudyThat => 'Gdzie chcesz się tego uczyć?';

  @override
  String get studyGoodMove => 'Dobry ruch';

  @override
  String get studyMistake => 'Pomyłka';

  @override
  String get studyBrilliantMove => 'Świetny ruch';

  @override
  String get studyBlunder => 'Błąd';

  @override
  String get studyInterestingMove => 'Interesujący ruch';

  @override
  String get studyDubiousMove => 'Wątpliwy ruch';

  @override
  String get studyOnlyMove => 'Jedyny ruch';

  @override
  String get studyZugzwang => 'Zugzwang';

  @override
  String get studyEqualPosition => 'Równa pozycja';

  @override
  String get studyUnclearPosition => 'Niejasna pozycja';

  @override
  String get studyWhiteIsSlightlyBetter => 'Białe stoją nieznacznie lepiej';

  @override
  String get studyBlackIsSlightlyBetter => 'Czarne stoją nieznacznie lepiej';

  @override
  String get studyWhiteIsBetter => 'Białe stoją lepiej';

  @override
  String get studyBlackIsBetter => 'Czarne stoją lepiej';

  @override
  String get studyWhiteIsWinning => 'Białe wygrywają';

  @override
  String get studyBlackIsWinning => 'Czarne wygrywają';

  @override
  String get studyNovelty => 'Nowość';

  @override
  String get studyDevelopment => 'Rozwój';

  @override
  String get studyInitiative => 'Inicjatywa';

  @override
  String get studyAttack => 'Atak';

  @override
  String get studyCounterplay => 'Przeciwdziałanie';

  @override
  String get studyTimeTrouble => 'Problem z czasem';

  @override
  String get studyWithCompensation => 'Z rekompensatą';

  @override
  String get studyWithTheIdea => 'Z pomysłem';

  @override
  String get studyNextChapter => 'Następny rozdział';

  @override
  String get studyPrevChapter => 'Poprzedni rozdział';

  @override
  String get studyStudyActions => 'Opcje opracowań';

  @override
  String get studyTopics => 'Tematy';

  @override
  String get studyMyTopics => 'Moje tematy';

  @override
  String get studyPopularTopics => 'Popularne tematy';

  @override
  String get studyManageTopics => 'Zarządzaj tematami';

  @override
  String get studyBack => 'Powrót';

  @override
  String get studyPlayAgain => 'Odtwórz ponownie';

  @override
  String get studyWhatWouldYouPlay => 'Co byś zagrał w tej pozycji?';

  @override
  String get studyYouCompletedThisLesson => 'Gratulacje! Ukończono tę lekcję.';

  @override
  String studyPerPage(String param) {
    return '$param na stronie';
  }

  @override
  String studyNbChapters(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count rozdziałów',
      many: '$count rozdziałów',
      few: '$count rozdziały',
      one: '$count rozdział',
    );
    return '$_temp0';
  }

  @override
  String studyNbGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count partii',
      many: '$count partii',
      few: '$count partie',
      one: '$count partia',
    );
    return '$_temp0';
  }

  @override
  String studyNbMembers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count uczestników',
      many: '$count uczestników',
      few: '$count uczestników',
      one: '$count uczestnik',
    );
    return '$_temp0';
  }

  @override
  String studyPasteYourPgnTextHereUpToNbGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Wklej tutaj swój PGN, max $count partii',
      many: 'Wklej tutaj swój PGN, max $count partii',
      few: 'Wklej tutaj swój PGN, max $count partie',
      one: 'Wklej tutaj swój PGN, max $count partię',
    );
    return '$_temp0';
  }

  @override
  String get timeagoJustNow => 'właśnie teraz';

  @override
  String get timeagoRightNow => 'w tej chwili';

  @override
  String get timeagoCompleted => 'ukończone';

  @override
  String timeagoInNbSeconds(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'za $count sekund',
      many: 'za $count sekund',
      few: 'za $count sekundy',
      one: 'za $count sekundę',
    );
    return '$_temp0';
  }

  @override
  String timeagoInNbMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'za $count minut',
      many: 'za $count minuty',
      few: 'za $count minuty',
      one: 'za $count minutę',
    );
    return '$_temp0';
  }

  @override
  String timeagoInNbHours(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'za $count godzin',
      many: 'za $count godzin',
      few: 'za $count godziny',
      one: 'za $count godzinę',
    );
    return '$_temp0';
  }

  @override
  String timeagoInNbDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'za $count dni',
      many: 'za $count dni',
      few: 'za $count dni',
      one: 'za $count dzień',
    );
    return '$_temp0';
  }

  @override
  String timeagoInNbWeeks(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'za $count tygodni',
      many: 'za $count tygodni',
      few: 'za $count tygodnie',
      one: 'za $count tydzień',
    );
    return '$_temp0';
  }

  @override
  String timeagoInNbMonths(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'za $count miesięcy',
      many: 'za $count miesięcy',
      few: 'za $count miesiące',
      one: 'za $count miesiąc',
    );
    return '$_temp0';
  }

  @override
  String timeagoInNbYears(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'za $count lat',
      many: 'za $count lat',
      few: 'za $count lata',
      one: 'za $count rok',
    );
    return '$_temp0';
  }

  @override
  String timeagoNbMinutesAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count minut temu',
      many: '$count minut temu',
      few: '$count minuty temu',
      one: '$count minutę temu',
    );
    return '$_temp0';
  }

  @override
  String timeagoNbHoursAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count godzin temu',
      many: '$count godzin temu',
      few: '$count godziny temu',
      one: '$count godzinę temu',
    );
    return '$_temp0';
  }

  @override
  String timeagoNbDaysAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count dni temu',
      many: '$count dni temu',
      few: '$count dni temu',
      one: '$count dzień temu',
    );
    return '$_temp0';
  }

  @override
  String timeagoNbWeeksAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count tygodni temu',
      many: '$count tygodni temu',
      few: '$count tygodnie temu',
      one: '$count tydzień temu',
    );
    return '$_temp0';
  }

  @override
  String timeagoNbMonthsAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count miesięcy temu',
      many: '$count miesięcy temu',
      few: '$count miesiące temu',
      one: '$count miesiąc temu',
    );
    return '$_temp0';
  }

  @override
  String timeagoNbYearsAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count lat temu',
      many: '$count lat temu',
      few: '$count lata temu',
      one: '$count rok temu',
    );
    return '$_temp0';
  }

  @override
  String timeagoNbMinutesRemaining(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Pozostało $count minut',
      many: 'Pozostało $count minut',
      few: 'Pozostały $count minuty',
      one: 'Pozostała $count minuta',
    );
    return '$_temp0';
  }

  @override
  String timeagoNbHoursRemaining(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Pozostało $count godzin',
      many: 'Pozostało $count godzin',
      few: 'Pozostały $count godziny',
      one: 'Pozostała $count godzina',
    );
    return '$_temp0';
  }
}
