import WidgetKit
import SwiftUI

let appGroupId = "group.io.nedaa.nedaaApp"

@main
struct NedaaWidgetBundle: WidgetBundle {
    var body: some Widget {
        if #available(iOS 16.0, *) {
            PrayerCountdownLockScreenWidget()
        }
        //        NedaaWidget()
        PrayerCountdownWidget()
        AllPrayersWidget()
        //        NedaaWidgetLiveActivity()
        
    }
}
