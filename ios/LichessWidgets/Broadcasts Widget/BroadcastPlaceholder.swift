import Foundation
import WidgetKit

/// Static placeholder data shown in the widget gallery and while a widget loads.
enum BroadcastPlaceholder {
    static func entry(filter: BroadcastFilterOption, family: WidgetFamily) -> BroadcastEntry {
        BroadcastEntry(
            date: .now,
            items: Array(items.prefix(family.broadcastMaxItems)),
            filter: filter,
            error: nil
        )
    }

    private static let items: [BroadcastItem] = [
        BroadcastItem(
            id: "1",
            title: "FIDE World Championship",
            roundName: "Round 5",
            tourSlug: "fide-world-championship",
            roundSlug: "round-5",
            isLive: true,
            startsAt: nil,
            imageData: nil,
            tier: 5
        ),
        BroadcastItem(
            id: "2",
            title: "Tata Steel Chess",
            roundName: "Round 12",
            tourSlug: "tata-steel-chess",
            roundSlug: "round-12",
            isLive: true,
            startsAt: nil,
            imageData: nil,
            tier: 4
        ),
        BroadcastItem(
            id: "3",
            title: "Candidates Tournament",
            roundName: "Round 7",
            tourSlug: "candidates-tournament",
            roundSlug: "round-7",
            isLive: false,
            startsAt: hoursFromNow(2),
            imageData: nil,
            tier: 5
        ),
        BroadcastItem(
            id: "4",
            title: "Norway Chess",
            roundName: "Round 3",
            tourSlug: "norway-chess",
            roundSlug: "round-3",
            isLive: false,
            startsAt: hoursFromNow(5),
            imageData: nil,
            tier: 4
        ),
//        BroadcastItem(
//            id: "5",
//            title: "Prague Chess Festival",
//            roundName: "Round 1",
//            tourSlug: "prague-chess-festival",
//            roundSlug: "round-1",
//            isLive: false,
//            startsAt: hoursFromNow(24),
//            imageData: nil,
//            tier: 3
//        ),
    ]

    private static func hoursFromNow(_ hours: Int) -> Date? {
        Calendar.current.date(byAdding: .hour, value: hours, to: .now)
    }
}
