import WidgetKit
import SwiftUI

let appGroupId = "group.io.nedaa.nedaaApp"

@main
struct NedaaWidgetBundle: WidgetBundle {
    var body: some Widget {
//        NedaaWidget()
        PrayerCountdownWidget()
//        NedaaWidgetLiveActivity()
    }
}
