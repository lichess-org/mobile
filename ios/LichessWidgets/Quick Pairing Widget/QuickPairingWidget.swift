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
		.supportedFamilies([.systemSmall, .systemMedium])
	}
}

struct QuickPairingWidgetEntryView: View {
	let entry: QuickPairingEntry

	@Environment(\.widgetFamily) private var family

	var body: some View {
		if entry.isKidMode {
			unavailableView(icon: "lock.fill", message: "Not available in Kid Mode")
		} else if let seek = entry.seek,
				  let url = seek.deepLinkURL {
			Link(destination: url) {
				pairingView(seek: seek)
			}
			.buttonStyle(.plain)
		} else {
			unavailableView(icon: "clock.badge.questionmark", message: "Play once to set Quick Pairing")
		}
	}

	private func pairingView(seek: QuickPairingSeek) -> some View {
		VStack(alignment: .leading, spacing: 8) {
			Label("Quick Pairing", systemImage: "bolt.fill")
				.font(.headline)
				.foregroundStyle(.primary)

			Text(seek.displayTimeControl)
				.font(family == .systemSmall ? .system(size: 30, weight: .bold) : .system(size: 36, weight: .bold))
				.lineLimit(1)
				.minimumScaleFactor(0.7)

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

	private func unavailableView(icon: String, message: String) -> some View {
		VStack(spacing: 8) {
			Image(systemName: icon)
				.font(.system(size: 20))
				.foregroundStyle(.secondary)
			Text(message)
				.font(.caption)
				.foregroundStyle(.secondary)
				.multilineTextAlignment(.center)
		}
		.frame(maxWidth: .infinity, maxHeight: .infinity)
	}
}
