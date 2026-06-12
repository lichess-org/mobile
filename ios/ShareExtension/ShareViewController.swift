import UIKit
import UniformTypeIdentifiers

/// Silent Share Extension: extracts a shared PGN, writes it to the shared App
/// Group container, and opens the host app via the `org.lichess.mobile://shared-pgn`
/// deeplink. The main app (`SharePlugin`) reads the file back and routes it to the
/// PGN import screen. No UI is presented.
class ShareViewController: UIViewController {
  private let appGroupId = "group.org.lichess.mobileV2.share"
  private let sharedFileName = "shared.pgn"
  private let hostAppURL = "org.lichess.mobile://shared-pgn"
  private let pgnTypeIdentifier = "org.lichess.pgn"

  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .clear
    handleShare()
  }

  private func handleShare() {
    guard
      let item = extensionContext?.inputItems.first as? NSExtensionItem,
      let attachment = item.attachments?.first(where: {
        $0.hasItemConformingToTypeIdentifier(pgnTypeIdentifier)
      }) ?? item.attachments?.first
    else {
      completeRequest()
      return
    }

    let typeIdentifier =
      attachment.hasItemConformingToTypeIdentifier(pgnTypeIdentifier)
      ? pgnTypeIdentifier : UTType.plainText.identifier

    attachment.loadItem(forTypeIdentifier: typeIdentifier, options: nil) { [weak self] data, _ in
      guard let self else { return }
      if let pgn = self.pgnString(from: data) {
        self.savePgn(pgn)
      }
      DispatchQueue.main.async {
        self.openHostApp {
          DispatchQueue.main.async { self.completeRequest() }
        }
      }
    }
  }

  private func pgnString(from data: Any?) -> String? {
    if let url = data as? URL, url.isFileURL {
      guard let bytes = try? Data(contentsOf: url) else { return nil }
      return decodePgn(bytes)
    }
    if let text = data as? String { return text }
    if let raw = data as? Data { return decodePgn(raw) }
    return nil
  }

  /// Decodes PGN bytes tolerantly. PGN files are usually UTF-8 but legacy files
  /// may use ISO-8859-1 (e.g. for player names), so we fall back to Latin-1 —
  /// which maps every byte to a code point and never fails — rather than silently
  /// dropping a file that isn't valid UTF-8.
  private func decodePgn(_ data: Data) -> String {
    if let utf8 = String(data: data, encoding: .utf8) { return utf8 }
    return String(data: data, encoding: .isoLatin1) ?? String(decoding: data, as: UTF8.self)
  }

  private func savePgn(_ pgn: String) {
    guard
      let container = FileManager.default.containerURL(
        forSecurityApplicationGroupIdentifier: appGroupId)
    else { return }
    let fileURL = container.appendingPathComponent(sharedFileName)
    try? pgn.write(to: fileURL, atomically: true, encoding: .utf8)
  }

  /// Opens the host app via the custom URL scheme. We prefer the sanctioned
  /// `NSExtensionContext.open(_:)`; if the system declines it (Share extensions
  /// historically may not support it), we fall back to walking the responder chain
  /// and invoking the `openURL:` selector — the long-standing technique for share
  /// extensions, since `UIApplication.open` is unavailable to app extensions.
  private func openHostApp(completion: @escaping () -> Void) {
    guard let url = URL(string: hostAppURL), let context = extensionContext else {
      completion()
      return
    }
    context.open(url) { [weak self] success in
      if !success { self?.openURLViaResponderChain(url) }
      completion()
    }
  }

  private func openURLViaResponderChain(_ url: URL) {
    let selector = sel_registerName("openURL:")
    var responder: UIResponder? = self
    while let current = responder {
      if current.responds(to: selector) {
        current.perform(selector, with: url)
        return
      }
      responder = current.next
    }
  }

  private func completeRequest() {
    extensionContext?.completeRequest(returningItems: [], completionHandler: nil)
  }
}
