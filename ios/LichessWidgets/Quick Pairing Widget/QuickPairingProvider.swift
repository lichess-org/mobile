import Foundation
import WidgetKit

struct QuickPairingSeek {
	let timeSeconds: Int
	let incrementSeconds: Int
	let rated: Bool
	let variant: String

	static let defaultTimeControlIconGlyph = QuickPairingSpeed.blitz.iconGlyph

	var displayTimeControl: String {
		"\(clockLabelInMinutes(timeSeconds))+\(incrementSeconds)"
	}

	var ratedLabel: String {
		rated ? "Rated" : "Casual"
	}

	var variantDisplayName: String {
		switch variant {
		case "chess960": return "Chess960"
		case "fromPosition": return "From Position"
		case "antichess": return "Antichess"
		case "kingOfTheHill": return "King of the Hill"
		case "threeCheck": return "Three Check"
		case "atomic": return "Atomic"
		case "horde": return "Horde"
		case "racingKings": return "Racing Kings"
		case "crazyhouse": return "Crazyhouse"
		default: return "Standard"
		}
	}

	var estimatedDurationSeconds: Int {
		timeSeconds + incrementSeconds * 40
	}

	var timeControlIconGlyph: String {
		timeControlSpeed.iconGlyph
	}

	private var timeControlSpeed: QuickPairingSpeed {
		switch estimatedDurationSeconds {
		case 1 ... 29:
			.ultrabullet
		case 30 ... 179:
			.bullet
		case 180 ... 479:
			.blitz
		case 480 ... 1499:
			.rapid
		default:
			.classical
		}
	}

	var deepLinkURL: URL? {
		var components = URLComponents()
		components.scheme = "org.lichess.mobile"
		components.host = "quick-pair"
		components.queryItems = [
			URLQueryItem(name: "time", value: "\(timeSeconds)"),
			URLQueryItem(name: "increment", value: "\(incrementSeconds)"),
			URLQueryItem(name: "rated", value: rated ? "true" : "false"),
			URLQueryItem(name: "variant", value: variant),
		]
		return components.url
	}
}

private enum QuickPairingSpeed {
	case ultrabullet
	case bullet
	case blitz
	case rapid
	case classical

	var iconGlyph: String {
		switch self {
		case .ultrabullet:
			"\u{e806}"
		case .bullet:
			"\u{e804}"
		case .blitz:
			"\u{e802}"
		case .rapid:
			"\u{e805}"
		case .classical:
			"\u{e803}"
		}
	}
}

struct QuickPairingEntry: TimelineEntry {
	let date: Date
	let seek: QuickPairingSeek?
	let isKidMode: Bool

	static let placeholder = QuickPairingEntry(
		date: .now,
		seek: QuickPairingSeek(timeSeconds: 300, incrementSeconds: 3, rated: false, variant: "standard"),
		isKidMode: false
	)
}

struct QuickPairingProvider: TimelineProvider {
	func placeholder(in context: Context) -> QuickPairingEntry {
		.placeholder
	}

	func getSnapshot(in context: Context, completion: @escaping (QuickPairingEntry) -> Void) {
		if context.isPreview {
			completion(.placeholder)
			return
		}

		completion(makeEntry())
	}

	func getTimeline(in context: Context, completion: @escaping (Timeline<QuickPairingEntry>) -> Void) {
		let entry = makeEntry()
		if entry.isKidMode {
			completion(Timeline(entries: [entry], policy: .never))
			return
		}

		let nextUpdate = Calendar.current.date(byAdding: .minute, value: 30, to: .now) ?? .now
		completion(Timeline(entries: [entry], policy: .after(nextUpdate)))
	}

	private func makeEntry() -> QuickPairingEntry {
		if LichessAppGroup.isKidModeActive {
			return QuickPairingEntry(date: .now, seek: nil, isKidMode: true)
		}

		guard let defaults = UserDefaults(suiteName: LichessAppGroup.id) else {
			return QuickPairingEntry(date: .now, seek: nil, isKidMode: false)
		}

		guard let timeSeconds = defaults.object(forKey: LichessAppGroup.quickPairingSeekTimeKey) as? Int,
			  let incrementSeconds = defaults.object(
				forKey: LichessAppGroup.quickPairingSeekIncrementKey
			  ) as? Int,
			  timeSeconds >= 0,
			  incrementSeconds >= 0
		else {
			return QuickPairingEntry(date: .now, seek: nil, isKidMode: false)
		}

		let rated = defaults.object(forKey: LichessAppGroup.quickPairingSeekRatedKey) as? Bool ?? false
		let variant = defaults.string(forKey: LichessAppGroup.quickPairingSeekVariantKey) ?? "standard"

		return QuickPairingEntry(
			date: .now,
			seek: QuickPairingSeek(
				timeSeconds: timeSeconds,
				incrementSeconds: incrementSeconds,
				rated: rated,
				variant: variant
			),
			isKidMode: false
		)
	}
}

private func clockLabelInMinutes(_ seconds: Int) -> String {
	switch seconds {
	case 0: return "0"
	case 45: return "¾"
	case 30: return "½"
	case 15: return "¼"
	default:
		let minutes = Double(seconds) / 60
		if minutes.rounded(.towardZero) == minutes {
			return "\(Int(minutes))"
		}
		return String(format: "%.2f", minutes).replacingOccurrences(of: ".00", with: "")
	}
}

