import WidgetKit
import SwiftUI
import Intents


struct CountdownLockScreenViewProvider: IntentTimelineProvider {
    typealias Entry = PrayerEntry
    typealias Intent = ConfigurationIntent
    
    func placeholder(in context: Context) -> PrayerEntry {
        PrayerEntry(date: Date(), configuration: ConfigurationIntent(), nextPrayer: PrayerData(name: "Fajr", date: Date()), previousPrayer: PrayerData(name: "Fajr", date: Date()) )
    }
    
    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (PrayerEntry) -> ()) {
        let entry = PrayerEntry(date: Date(), configuration: configuration, nextPrayer: PrayerData(name: "Fajr", date: Date()), previousPrayer: PrayerData(name: "Fajr", date: Date()))
        completion(entry)
    }
    
    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<PrayerEntry>) -> ()) {
        var _: [PrayerEntry] = []
        let prayerService = PrayerDataService()
        let showSunrise = configuration.showSunrise as! Bool?
        let nextPrayer = prayerService.getNextPrayer(showSunrise: showSunrise ?? true) ?? PrayerData(name: "GET NOT WOKRING", date: Date())
        let previousPrayer = prayerService.getPreviousPrayer(showSunrise: showSunrise ?? true) ?? PrayerData(name: "GET NOT WOKRING", date: Date())
        let currentDate = Date()
        
        let nextUpdateDate = calculateNextUpdateDate(currentDate: currentDate, nextPrayerDate: nextPrayer.date, previousPrayerDate: previousPrayer.date)
        
        let entry = PrayerEntry(date: currentDate,configuration: configuration, nextPrayer: nextPrayer, previousPrayer: previousPrayer)
        let timeline = Timeline(entries: [entry], policy: .after(nextUpdateDate))
        let dateformat = DateFormatter()
        dateformat.dateFormat = "h:mm a"
        
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

@available(iOSApplicationExtension 16.0, *)
struct PrayerCountdownLockScreenView: View {
    var entry: CountdownLockScreenViewProvider.Entry
    
    // get the widget family
    @Environment(\.widgetFamily)
    var family
    var body: some View {
        switch family {
        case .accessoryRectangular:
            RectangularView(entry: entry)
        case .accessoryCircular:
            CircularView(entry: entry)
        default:
            Text("Select a family")
        }
    }
    
}
@available(iOSApplicationExtension 16.0, *)
struct RectangularView: View {
    var entry: CountdownLockScreenViewProvider.Entry
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                AccessoryWidgetBackground()
                    .cornerRadius(6)
                dataToShow(entry: entry, geometry: geometry)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .frame(width: (geometry.size.width / 4) * 2.4, height: (geometry.size.height / 4) * 2.5)
        }
    }
}

@available(iOSApplicationExtension 16.0, *)
struct CircularView: View {
    var entry: CountdownLockScreenViewProvider.Entry
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                AccessoryWidgetBackground()
                dataToShow(entry: entry, geometry: geometry)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}

func dataToShow(entry: CountdownLockScreenViewProvider.Entry, geometry: GeometryProxy) -> some View {
    Group {
        if let nextPrayer = entry.nextPrayer, let previousPrayer = entry.previousPrayer {
            // Check if the previous prayer was within the last 30 minutes
            if Calendar.current.dateComponents([.minute], from: previousPrayer.date, to: Date()).minute ?? 0 < 30 && (entry.configuration.showTimer == true) {
                VStack {
                    Text(previousPrayer.name)
                        .multilineTextAlignment(.center)
                        .font(.system(size: geometry.size.width * 0.2))
                    Text(previousPrayer.date, style: .timer)
                        .multilineTextAlignment(.center)
                        .lineLimit(1)
                        .minimumScaleFactor(0.4)
                        .font(.system(size: geometry.size.width * 0.2))
                }
            }
            else {
                VStack {
                    Text(nextPrayer.name)
                        .font(.system(size: geometry.size.width * 0.2))
                        .lineLimit(1)
                        .minimumScaleFactor(0.5)
                    
                    
                    if Calendar.current.dateComponents([.minute], from: Date(), to: nextPrayer.date).minute ?? 0 <= 60 && (entry.configuration.showTimer == true) {
                        Text(nextPrayer.date, style: .timer)
                            .multilineTextAlignment(.center)
                            .lineLimit(1)
                            .minimumScaleFactor(0.5)
                            .font(.system(size: geometry.size.width * 0.2))
                    }
                    else {
                        Text(nextPrayer.date, style: .time)
                            .lineLimit(1)
                            .minimumScaleFactor(0.5)
                            .font(.system(size: geometry.size.width * 0.2))
                    }
                }
            }
        }
    }
}

@available(iOSApplicationExtension 16.0, *)
struct PrayerCountdownLockScreenWidget: Widget {
    // TODO: keep track of the widget kind so we can use it to update the widget
    // in case the user changes the location
    let kind: String = "PrayerCountdownLockScreenWidget"
    
    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            PrayerCountdownLockScreenView(entry: entry)
        }
        .configurationDisplayName("Lock screen Next prayer with timer")
        .description("This widget will show the next prayer and time. \nit will show a countdonw 60 mintues before the prayer. \nit will countup for 30min after the prayer")
        .supportedFamilies([.accessoryCircular, .accessoryRectangular])
        
    }
}

@available(iOSApplicationExtension 16.0, *)
struct PrayerCountdownLockScreenView_Previews: PreviewProvider {
    static var previews: some View {
        PrayerCountdownLockScreenView(entry: PrayerEntry(date: Date(), configuration: ConfigurationIntent(), nextPrayer: PrayerData(name: "Maghrib", date: Date()), previousPrayer: PrayerData(name: "Maghrib", date: Date())))
            .previewContext(WidgetPreviewContext(family: .accessoryCircular))
    }
}
