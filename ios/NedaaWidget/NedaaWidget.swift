import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    let prayerService: PrayerDataService
    
    init() {
        prayerService = PrayerDataService()
        let nextPrayer = prayerService.getNextPrayer()
        debugPrint(nextPrayer?.date)
        // convet date to local time
        let localDate = nextPrayer?.date.toLocalTime(timezone: TimeZone.current)
        debugPrint(TimeZone.current)
        debugPrint(localDate)
    }
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date())
    }
    
    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date())
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []
        
        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate)
            entries.append(entry)
        }
        
        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
}

struct NedaaWidgetEntryView : View {
    var entry: Provider.Entry
    
    var body: some View {
        Text(entry.date, style: .time)
    }
}

struct NedaaWidget: Widget {
    let kind: String = "NedaaWidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            NedaaWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}

struct NedaaWidget_Previews: PreviewProvider {
    static var previews: some View {
        NedaaWidgetEntryView(entry: SimpleEntry(date: Date()))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
