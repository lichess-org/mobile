import WidgetKit

struct BroadcastEntry: TimelineEntry {
    let date: Date
    let items: [BroadcastItem]
    let filter: BroadcastFilterOption
    let error: String?

    var headerTitle: String {
        filter == .top ? "Top Broadcasts" : "Broadcasts"
    }
}
