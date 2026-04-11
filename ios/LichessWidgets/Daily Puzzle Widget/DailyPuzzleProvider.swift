import WidgetKit

struct DailyPuzzleProvider: TimelineProvider {
    private let fetcher = DailyPuzzleFetcher()

    func placeholder(in context: Context) -> DailyPuzzleEntry {
        .placeholder
    }

    func getSnapshot(in context: Context, completion: @escaping (DailyPuzzleEntry) -> Void) {
        if context.isPreview { completion(.placeholder); return }
        Task { completion(await fetcher.fetchEntry()) }
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<DailyPuzzleEntry>) -> Void) {
        Task {
            let entry = await fetcher.fetchEntry()
            // Retry in an hour if the fetch failed; otherwise wait until the next daily puzzle.
            let nextUpdate = entry.error == nil
                ? DailyPuzzleFetcher.nextUpdateDate
                : Calendar.current.date(byAdding: .hour, value: 1, to: .now)!
            completion(Timeline(entries: [entry], policy: .after(nextUpdate)))
        }
    }
}
