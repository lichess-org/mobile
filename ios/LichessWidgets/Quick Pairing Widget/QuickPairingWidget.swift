import SwiftUI
import WidgetKit

struct QuickPairingWidget: Widget {
	let kind = "QuickPairingWidget"

	var body: some WidgetConfiguration {
		StaticConfiguration(kind: kind, provider: QuickPairingProvider()) { entry in
			QuickPairingWidgetEntryView(entry: entry)
				.containerBackground(.background, for: .widget)
		}
		.configurationDisplayName("Quick Pairing")
		.description("Start your last used time control from the Home Screen.")
		.supportedFamilies([.systemSmall])
	}
}

struct QuickPairingWidgetEntryView: View {
	let entry: QuickPairingEntry

	@Environment(\.widgetFamily) private var family

	var body: some View {
    if let seek = entry.seek,
				  let url = seek.deepLinkURL {
			Link(destination: url) {
				pairingView(seek: seek)
			}
			.buttonStyle(.plain)
		} else {
			defaultPairingView()
		}
	}

  private var timeControlFont: Font {
    family == .systemSmall ? .system(size: 30, weight: .bold) : .system(size: 36, weight: .bold)
  }

  private var timeControlIconFont: Font {
    family == .systemSmall ? .custom("LichessIcons", size: 22) : .custom("LichessIcons", size: 24)
  }

  private func timeControlIcon(_ glyph: String) -> some View {
    Text(glyph)
      .font(timeControlIconFont)
      .foregroundStyle(.primary)
      .padding(.leading, 6)
      .accessibilityHidden(true)
  }
  
  private func defaultPairingView() -> some View {
    VStack(alignment: .leading, spacing: 0) {
      HStack(spacing: QuickPairingWidgetLayout.headerSpacing) {
        Image("LichessLogo")
          .resizable()
          .frame(width: QuickPairingWidgetLayout.logoSize, height: QuickPairingWidgetLayout.logoSize)
        HStack(alignment: .lastTextBaseline, spacing: 0) {
          Text("Play")
            .font(.system(size: QuickPairingWidgetLayout.titleFontSize, weight: .semibold))
            .foregroundStyle(.primary)
            .lineLimit(1)
        }
      }
      Divider()
          .padding(.top, BlogFeedWidgetLayout.itemTopPadding)
      HStack(alignment: .lastTextBaseline, spacing: 0) {
        Text("5+3")
          .font(timeControlFont)
          .lineLimit(1)
          .minimumScaleFactor(0.7)
        timeControlIcon(QuickPairingSeek.defaultTimeControlIconGlyph)
      }
      
      Text("Rated • Standard")
        .font(.subheadline)
        .foregroundStyle(.secondary)
        .lineLimit(1)
        .minimumScaleFactor(0.8)

      Spacer(minLength: 0)

      Label("Tap to pair", systemImage: "arrow.forward.circle.fill")
        .font(.caption)
        .foregroundStyle(.secondary)
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
  }

	private func pairingView(seek: QuickPairingSeek) -> some View {
		VStack(alignment: .leading, spacing: 0) {
      HStack(spacing: QuickPairingWidgetLayout.headerSpacing) {
        Image("LichessLogo")
          .resizable()
          .frame(width: QuickPairingWidgetLayout.logoSize, height: QuickPairingWidgetLayout.logoSize)
        HStack(alignment: .lastTextBaseline, spacing: 0) {
          Text("Play")
            .font(.system(size: QuickPairingWidgetLayout.titleFontSize, weight: .semibold))
            .foregroundStyle(.primary)
            .lineLimit(1)
        }
      }
      Divider()
          .padding(.top, BlogFeedWidgetLayout.itemTopPadding)
      HStack(alignment: .lastTextBaseline, spacing: 0) {
        Text(seek.displayTimeControl)
          .font(timeControlFont)
          .lineLimit(1)
          .minimumScaleFactor(0.7)
        timeControlIcon(seek.timeControlIconGlyph)
      }
			
			Text("\(seek.ratedLabel) • \(seek.variantDisplayName)")
				.font(.subheadline)
				.foregroundStyle(.secondary)
				.lineLimit(1)
				.minimumScaleFactor(0.8)

			Spacer(minLength: 0)

			Label("Tap to pair", systemImage: "arrow.forward.circle.fill")
				.font(.caption)
				.foregroundStyle(.secondary)
		}
		.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
	}
}
