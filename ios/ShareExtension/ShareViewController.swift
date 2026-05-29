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
        self.openHostApp()
        self.completeRequest()
      }
    }
  }

  private func pgnString(from data: Any?) -> String? {
    if let url = data as? URL, url.isFileURL {
      return try? String(contentsOf: url, encoding: .utf8)
    }
    if let text = data as? String { return text }
    if let raw = data as? Data { return String(data: raw, encoding: .utf8) }
    return nil
  }

  private func savePgn(_ pgn: String) {
    guard
      let container = FileManager.default.containerURL(
        forSecurityApplicationGroupIdentifier: appGroupId)
    else { return }
    let fileURL = container.appendingPathComponent(sharedFileName)
    try? pgn.write(to: fileURL, atomically: true, encoding: .utf8)
  }

  /// Opens the host app. `UIApplication.open` is unavailable to app extensions,
  /// so we walk the responder chain to the shared application and invoke the
  /// `openURL:` selector — the long-standing technique for share extensions.
  private func openHostApp() {
    guard let url = URL(string: hostAppURL) else { return }
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
