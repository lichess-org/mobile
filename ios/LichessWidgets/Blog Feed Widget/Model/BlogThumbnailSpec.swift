import Foundation

struct BlogThumbnailSpec {
    let width: CGFloat
    let aspectRatio: CGFloat // height = width * aspectRatio
    var height: CGFloat { width * aspectRatio }
}
