import WidgetKit
import SwiftUI

private let appGroupId = "group.org.lichess.mobileV2"

struct DailyPuzzleEntry: TimelineEntry {
    let date: Date
    let puzzleId: String?
    let sideToMove: String?
    let plays: Int?
    let boardImagePath: String?
    let displaySize: CGSize
}

struct DailyPuzzleProvider: TimelineProvider {
    private var userDefaults: UserDefaults? {
        UserDefaults(suiteName: appGroupId)
    }

    func placeholder(in context: Context) -> DailyPuzzleEntry {
        DailyPuzzleEntry(
            date: Date(),
            puzzleId: nil,
            sideToMove: nil,
            plays: nil,
            boardImagePath: nil,
            displaySize: context.displaySize
        )
    }

    func getSnapshot(in context: Context, completion: @escaping (DailyPuzzleEntry) -> Void) {
        let entry = makeEntry(displaySize: context.displaySize)
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<DailyPuzzleEntry>) -> Void) {
        let entry = makeEntry(displaySize: context.displaySize)
        let nextUpdate = Calendar.current.date(byAdding: .hour, value: 1, to: Date())!
        let timeline = Timeline(entries: [entry], policy: .after(nextUpdate))
        completion(timeline)
    }

    private func makeEntry(displaySize: CGSize) -> DailyPuzzleEntry {
        let defaults = userDefaults
        return DailyPuzzleEntry(
            date: Date(),
            puzzleId: defaults?.string(forKey: "puzzle_id"),
            sideToMove: defaults?.string(forKey: "puzzle_side_to_move"),
            plays: defaults?.object(forKey: "puzzle_plays") as? Int,
            boardImagePath: defaults?.string(forKey: "puzzle_board_image"),
            displaySize: displaySize
        )
    }
}

struct DailyPuzzleWidgetEntryView: View {
    var entry: DailyPuzzleProvider.Entry

    @Environment(\.widgetFamily) var family

    private var deepLinkURL: URL? {
        guard let id = entry.puzzleId else { return nil }
        return URL(string: "https://lichess.org/training/\(id)")
    }

    var body: some View {
        Group {
            if entry.puzzleId != nil {
                puzzleContent
            } else {
                placeholderContent
            }
        }
        .widgetURL(deepLinkURL)
    }

    private var puzzleContent: some View {
        GeometryReader { geometry in
            switch family {
            case .systemSmall:
                smallWidget(size: geometry.size)
            case .systemMedium:
                mediumWidget(size: geometry.size)
            default:
                smallWidget(size: geometry.size)
            }
        }
    }

    private func smallWidget(size: CGSize) -> some View {
        VStack(spacing: 4) {
            Text("Daily Puzzle")
                .font(.caption2)
                .fontWeight(.semibold)
                .foregroundColor(.secondary)

            if let image = loadBoardImage() {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(1, contentMode: .fit)
                    .cornerRadius(4)
            }

            if let side = entry.sideToMove {
                HStack(spacing: 4) {
                    Circle()
                        .fill(side == "white" ? Color.white : Color.black)
                        .frame(width: 8, height: 8)
                        .overlay(
                            Circle().stroke(Color.gray, lineWidth: 0.5)
                        )
                    Text(side == "white" ? "White to play" : "Black to play")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding(8)
    }

    private func mediumWidget(size: CGSize) -> some View {
        HStack(spacing: 12) {
            if let image = loadBoardImage() {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(1, contentMode: .fit)
                    .cornerRadius(4)
            }

            VStack(alignment: .leading, spacing: 6) {
                Text("Daily Puzzle")
                    .font(.headline)
                    .fontWeight(.bold)

                if let side = entry.sideToMove {
                    HStack(spacing: 4) {
                        Circle()
                            .fill(side == "white" ? Color.white : Color.black)
                            .frame(width: 10, height: 10)
                            .overlay(
                                Circle().stroke(Color.gray, lineWidth: 0.5)
                            )
                        Text(side == "white" ? "White to play" : "Black to play")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }

                if let plays = entry.plays {
                    Text("\(plays) plays")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }

                Spacer()

                Text("Tap to solve")
                    .font(.caption2)
                    .foregroundColor(.accentColor)
            }
            .padding(.vertical, 4)

            Spacer()
        }
        .padding(12)
    }

    private var placeholderContent: some View {
        VStack(spacing: 8) {
            Image(systemName: "puzzlepiece.extension")
                .font(.largeTitle)
                .foregroundColor(.secondary)
            Text("Daily Puzzle")
                .font(.caption)
                .foregroundColor(.secondary)
            Text("Open Lichess to load")
                .font(.caption2)
                .foregroundColor(.secondary)
        }
        .padding()
    }

    private func loadBoardImage() -> UIImage? {
        guard let path = entry.boardImagePath else { return nil }
        return UIImage(contentsOfFile: path)
    }
}

@main
struct DailyPuzzleWidget: Widget {
    let kind: String = "DailyPuzzleWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: DailyPuzzleProvider()) { entry in
            if #available(iOS 17.0, *) {
                DailyPuzzleWidgetEntryView(entry: entry)
                    .containerBackground(.fill.tertiary, for: .widget)
            } else {
                DailyPuzzleWidgetEntryView(entry: entry)
                    .padding()
                    .background()
            }
        }
        .configurationDisplayName("Daily Puzzle")
        .description("Today's chess puzzle from Lichess")
        .supportedFamilies([.systemSmall, .systemMedium])
        .contentMarginsDisabled()
    }
}
