import WidgetKit

struct BroadcastProvider: AppIntentTimelineProvider {
    private let fetcher = BroadcastFetcher()

    func placeholder(in context: Context) -> BroadcastEntry {
        BroadcastPlaceholder.entry(filter: .all, family: context.family)
    }

    func snapshot(for configuration: BroadcastWidgetIntent, in context: Context) async -> BroadcastEntry {
        if context.isPreview { return placeholder(in: context) }
        return await fetcher.fetchEntry(filter: configuration.filter, family: context.family)
    }

    func timeline(for configuration: BroadcastWidgetIntent, in context: Context) async -> Timeline<BroadcastEntry> {
        let entry = await fetcher.fetchEntry(filter: configuration.filter, family: context.family)
        return Timeline(entries: [entry], policy: .after(BroadcastFetcher.nextUpdateDate))
    }
}
