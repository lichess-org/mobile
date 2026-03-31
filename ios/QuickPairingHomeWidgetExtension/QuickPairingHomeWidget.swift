import SwiftUI
import WidgetKit

private let widgetGroupId = "group.org.lichess.mobileV2.homewidget"
private let widgetLaunchUri = "org.lichess.mobile://home-widget/start-last-pairing?homeWidget=1"
private let widgetTitleKey = "widget_title"
private let widgetPrimaryTextKey = "widget_primary_text"
private let widgetSecondaryTextKey = "widget_secondary_text"
private let widgetLaunchUriKey = "widget_launch_uri"

struct QuickPairingHomeWidgetEntry: TimelineEntry {
  let date: Date
  let title: String
  let primaryText: String
  let secondaryText: String
  let launchUri: String
}

struct QuickPairingHomeWidgetProvider: TimelineProvider {
  func placeholder(in context: Context) -> QuickPairingHomeWidgetEntry {
    QuickPairingHomeWidgetEntry(
      date: Date(),
      title: "Quick pairing",
      primaryText: "5+0",
      secondaryText: "Casual",
      launchUri: widgetLaunchUri
    )
  }

  func getSnapshot(
    in context: Context,
    completion: @escaping (QuickPairingHomeWidgetEntry) -> Void
  ) {
    completion(makeEntry())
  }

  func getTimeline(
    in context: Context,
    completion: @escaping (Timeline<QuickPairingHomeWidgetEntry>) -> Void
  ) {
    completion(Timeline(entries: [makeEntry()], policy: .never))
  }

  private func makeEntry() -> QuickPairingHomeWidgetEntry {
    let defaults = UserDefaults(suiteName: widgetGroupId)

    return QuickPairingHomeWidgetEntry(
      date: Date(),
      title: defaults?.string(forKey: widgetTitleKey) ?? "Quick pairing",
      primaryText: defaults?.string(forKey: widgetPrimaryTextKey) ?? "5+0",
      secondaryText: defaults?.string(forKey: widgetSecondaryTextKey) ?? "Casual",
      launchUri: defaults?.string(forKey: widgetLaunchUriKey) ?? widgetLaunchUri
    )
  }
}

struct QuickPairingHomeWidgetEntryView: View {
  var entry: QuickPairingHomeWidgetProvider.Entry

  private let backgroundColor = Color(red: 247 / 255, green: 243 / 255, blue: 232 / 255)
  private let titleColor = Color(red: 21 / 255, green: 18 / 255, blue: 13 / 255)
  private let secondaryColor = Color(red: 81 / 255, green: 71 / 255, blue: 51 / 255)
  private let brandColor = Color(red: 107 / 255, green: 92 / 255, blue: 62 / 255)

  var body: some View {
    Group {
      if #available(iOSApplicationExtension 17.0, *) {
        content
          .containerBackground(for: .widget) {
            backgroundColor
          }
      } else {
        ZStack {
          backgroundColor
          content
        }
      }
    }
    .widgetURL(URL(string: entry.launchUri))
  }

  private var content: some View {
    VStack(alignment: .leading, spacing: 6) {
      Text("lichess.org")
        .font(.caption)
        .foregroundStyle(brandColor)

      Text(entry.title)
        .font(.headline)
        .foregroundStyle(titleColor)

      Spacer(minLength: 0)

      Text(entry.primaryText)
        .font(.system(size: 30, weight: .bold, design: .rounded))
        .foregroundStyle(titleColor)

      Text(entry.secondaryText)
        .font(.subheadline)
        .foregroundStyle(secondaryColor)
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
    .padding(16)
  }
}

@main
struct QuickPairingHomeWidget: Widget {
  private let kind = "QuickPairingHomeWidget"

  var body: some WidgetConfiguration {
    StaticConfiguration(kind: kind, provider: QuickPairingHomeWidgetProvider()) { entry in
      QuickPairingHomeWidgetEntryView(entry: entry)
    }
    .configurationDisplayName("Quick pairing")
    .description("Start your next lichess game from the home screen.")
    .supportedFamilies([.systemSmall, .systemMedium])
  }
}
