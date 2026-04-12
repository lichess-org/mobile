import SwiftUI

struct RoundedCorner: Shape {
    let radius: CGFloat
    let corners: UIRectCorner
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect,
                                byRoundingCorners: corners,
                                cornerRadii: CGSize(width: radius,
                                                    height: radius))
        return Path(path.cgPath)
    }
}

extension View {
    func roundedCornerWithBorder<S>(lineWidth: CGFloat,
                                    style: S,
                                    radius: CGFloat,
                                    corners: UIRectCorner = .allCorners) -> some View where S : ShapeStyle {
        clipShape(RoundedCorner(radius: radius, corners: corners) )
            .overlay(RoundedCorner(radius: radius, corners: corners)
                .stroke(style, lineWidth: lineWidth))
    }
}
