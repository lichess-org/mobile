import AppIntents
import SwiftUI
import WidgetKit

// MARK: - Filter option

enum BroadcastFilterOption: String, AppEnum {
    case all
    case top

    static var typeDisplayRepresentation: TypeDisplayRepresentation = "Broadcasts Filter"
    static var caseDisplayRepresentations: [BroadcastFilterOption: DisplayRepresentation] = [
        .all: "All Broadcasts",
        .top: "Top Broadcasts",
    ]
}

// MARK: - Widget intent

struct BroadcastWidgetIntent: WidgetConfigurationIntent {
    static var title: LocalizedStringResource = "Broadcasts"
    static var description = IntentDescription("Configure which broadcasts to display.")

    @Parameter(title: "Filter", default: .all)
    var filter: BroadcastFilterOption

    static var parameterSummary: some ParameterSummary {
        Summary("Show \(\.$filter)")
    }
}

// MARK: - Widget definition

struct BroadcastWidget: Widget {
    let kind = "BroadcastWidget"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(
            kind: kind,
            intent: BroadcastWidgetIntent.self,
            provider: BroadcastProvider()
        ) { entry in
            BroadcastWidgetEntryView(entry: entry)
                .containerBackground(.background, for: .widget)
        }
        .configurationDisplayName("Broadcasts")
        .description("Shows ongoing and upcoming chess broadcasts.")
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
    }
}
