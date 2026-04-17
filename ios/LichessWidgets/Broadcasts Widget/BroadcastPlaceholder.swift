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
            title: "European Individual Chess Championship",
            roundName: "Round 10",
            tourSlug: "european-individual-chess-championship",
            roundSlug: "round-10",
            isLive: true,
            startsAt: nil,
            imageData: nil,
            thumbnailImageName: "BroadcastPlaceholderImage1"
        ),
        BroadcastItem(
            id: "2",
            title: "Bangkok Chess Club Open",
            roundName: "Round 7",
            tourSlug: "bangkok-chess-club-open",
            roundSlug: "round-7",
            isLive: true,
            startsAt: nil,
            imageData: nil,
            thumbnailImageName: "BroadcastPlaceholderImage2"
        ),
        BroadcastItem(
            id: "3",
            title: "Austrian Bundesliga",
            roundName: "Round 8",
            tourSlug: "austrian-bundesliga",
            roundSlug: "round-8",
            isLive: false,
            startsAt: hoursFromNow(2),
            imageData: nil,
            thumbnailImageName: "BroadcastPlaceholderImage3"
        ),
        BroadcastItem(
            id: "4",
            title: "Clash of Generations III",
            roundName: "Round 6",
            tourSlug: "clash-of-generations-iii",
            roundSlug: "round-6",
            isLive: false,
            startsAt: hoursFromNow(5),
            imageData: nil,
            thumbnailImageName: "BroadcastPlaceholderImage4"
        ),
    ]

    private static func hoursFromNow(_ hours: Int) -> Date? {
        Calendar.current.date(byAdding: .hour, value: hours, to: .now)
    }
}
