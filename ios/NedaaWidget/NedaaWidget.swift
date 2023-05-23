import WidgetKit
import SwiftUI
let  _appGroupId = "group.io.nedaa.nedaaApp";
var nextUpdate: String = "NO DATE YET"
struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), nextPrayer:  PrayerData(name: "PlaceHolder", date: Date()), previousPrayer: PrayerData(name: "PlaceHolder", date: Date()))
    }
    
    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), nextPrayer:  PrayerData(name: "SNAP SHOT", date: Date()), previousPrayer: PrayerData(name: "PlaceHolder", date: Date()))
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<SimpleEntry>) -> ()) {
        var _: [SimpleEntry] = []
        let prayerService = PrayerDataService()
        let nextPrayer = prayerService.getNextPrayer() ?? PrayerData(name: "GET NOT WOKRING", date: Date())
        let previousPrayer = prayerService.getPreviousPrayer() ?? PrayerData(name: "GET NOT WOKRING", date: Date())
        let currentDate = Date()
        debugPrint("Current Date")
        debugPrint(currentDate)
        debugPrint("Next Prayer  Date")
        debugPrint(nextPrayer.date)
     
        let nextUpdateDate = calculateNextUpdateDate(currentDate: currentDate, nextPrayerDate: nextPrayer.date, previousPrayerDate: previousPrayer.date)
        
        let entry = SimpleEntry(date: currentDate, nextPrayer: nextPrayer, previousPrayer: previousPrayer)
        let timeline = Timeline(entries: [entry], policy: .after(nextUpdateDate))
        let dateformat = DateFormatter()
            dateformat.dateFormat = "h:mm a"
        nextUpdate = dateformat.string(from: nextUpdateDate)
        debugPrint("Next update at")
        debugPrint(nextUpdateDate)
        completion(timeline)
    }
    
    func calculateNextUpdateDate(currentDate: Date, nextPrayerDate: Date, previousPrayerDate: Date) -> Date {
        let timeIntervalToNextPrayer = nextPrayerDate.timeIntervalSince(currentDate)
        let timeIntervalSincePreviousPrayer = currentDate.timeIntervalSince(previousPrayerDate)
        
        if timeIntervalSincePreviousPrayer < 1800 {
            // If the previous prayer was less than 30 minutes ago, update 30 minutes after the previous prayer
            return previousPrayerDate.addingTimeInterval(1800)
        } else if timeIntervalToNextPrayer > 3600 {
            // If the next prayer is more than 1 hour away, update 60 minutes before the next prayer
            return nextPrayerDate.addingTimeInterval(-3600)
        } else {
            // Otherwise, update 30 minutes after the next prayer
            return nextPrayerDate.addingTimeInterval(1800)
        }
    }


    
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let nextPrayer: PrayerData?
    let previousPrayer: PrayerData?
}

struct NedaaWidgetEntryView : View {
    var entry: Provider.Entry
    let data = UserDefaults.init(suiteName:_appGroupId)
    
    var body: some View {
        Text(entry.date, style: .time)
    }
}

struct NedaaWidget: Widget {
    let kind: String = "NedaaWidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            // NedaaWidgetEntryView(entry: entry)
            PrayerCountdownView(entry: entry)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}

struct NedaaWidget_Previews: PreviewProvider {
    static var previews: some View {
        NedaaWidgetEntryView(entry: SimpleEntry(date: Date(), nextPrayer: PrayerData(name: "SIM", date: Date()), previousPrayer: PrayerData(name: "SIM", date: Date())))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
