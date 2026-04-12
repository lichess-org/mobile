import WidgetKit
import SwiftUI

@main
struct LichessWidgetsBundle: WidgetBundle {
    var body: some Widget {
        DailyPuzzleLargeWidget()
        DailyPuzzleSmallWidget()
        CommunityBlogWidget()
        UserBlogFeedWidget()
        OfficialBlogWidget()
    }
}
