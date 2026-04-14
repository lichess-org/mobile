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
    func placeholder(in context: Context) -> DailyPuzzleEntry {
        .placeholder
    }

    func snapshot(for configuration: DailyPuzzleIntent, in context: Context) async -> DailyPuzzleEntry {
        // Always return the placeholder — snapshot is called for the widget gallery
        // and edit sheet, where a fast static preview is more appropriate than a
        // live network fetch.
        .placeholder
    }

    func timeline(for configuration: DailyPuzzleIntent, in context: Context) async -> Timeline<DailyPuzzleEntry> {
        let entry = await DailyPuzzleFetcher.fetchEntry(showRating: configuration.showRating)
        return Timeline(entries: [entry], policy: .after(DailyPuzzleFetcher.nextUpdate(for: entry)))
    }
}
