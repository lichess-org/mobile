import WidgetKit
import SwiftUI

@main
struct LichessWidgetsBundle: WidgetBundle {
    var body: some Widget {
        DailyPuzzleWidget()
        BroadcastWidget()
        CommunityBlogWidget()
        UserBlogFeedWidget()
        OfficialBlogWidget()
    }
}
