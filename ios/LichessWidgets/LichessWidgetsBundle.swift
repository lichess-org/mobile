import WidgetKit
import SwiftUI

@main
struct LichessWidgetsBundle: WidgetBundle {
    var body: some Widget {
        DailyPuzzleLargeWidget()
        DailyPuzzleSmallWidget()
        BroadcastWidget()
        CommunityBlogWidget()
        UserBlogFeedWidget()
        OfficialBlogWidget()
    }
}
