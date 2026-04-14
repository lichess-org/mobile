import WidgetKit

struct DailyPuzzleProvider: TimelineProvider {
    func placeholder(in context: Context) -> DailyPuzzleEntry {
        .placeholder
    }

    func getSnapshot(in context: Context, completion: @escaping (DailyPuzzleEntry) -> Void) {
        // Always return the placeholder — snapshot is called for the widget gallery
        // and edit sheet, where a fast static preview is more appropriate than a
        // live network fetch.
        completion(.placeholder)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<DailyPuzzleEntry>) -> Void) {
        Task {
            let entry = await DailyPuzzleFetcher.fetchEntry()
            completion(Timeline(entries: [entry], policy: .after(DailyPuzzleFetcher.nextUpdate(for: entry))))
        }
    }
}
