import AppIntents
import WidgetKit

struct DailyPuzzleIntent: WidgetConfigurationIntent {
    static var title: LocalizedStringResource = "Daily Puzzle"
    static var description = IntentDescription("Configure the Daily Puzzle widget.")

    @Parameter(title: "Show Rating", default: true)
    var showRating: Bool

    static var parameterSummary: some ParameterSummary {
        Summary("Show rating: \(\.$showRating)")
    }
}

struct DailyPuzzleProvider: AppIntentTimelineProvider {
    private let fetcher = DailyPuzzleFetcher()

    func placeholder(in context: Context) -> DailyPuzzleEntry {
        .placeholder
    }

    func snapshot(for configuration: DailyPuzzleIntent, in context: Context) async -> DailyPuzzleEntry {
        if context.isPreview { return .placeholder }
        return await fetcher.fetchEntry(showRating: configuration.showRating)
    }

    func timeline(for configuration: DailyPuzzleIntent, in context: Context) async -> Timeline<DailyPuzzleEntry> {
        let entry = await fetcher.fetchEntry(showRating: configuration.showRating)
        // Retry in an hour if the fetch failed; otherwise wait until the next daily puzzle.
        let nextUpdate = entry.error == nil
            ? DailyPuzzleFetcher.nextUpdateDate
            : Calendar.current.date(byAdding: .hour, value: 1, to: .now)!
        return Timeline(entries: [entry], policy: .after(nextUpdate))
    }
}
