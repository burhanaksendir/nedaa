import WidgetKit
import SwiftUI
import Intents

struct CountdownViewProvider: IntentTimelineProvider {
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

struct PrayerCountdownView: View {
    var entry: CountdownViewProvider.Entry
    
    let primaryColor = Color(red: 0x12 / 255, green: 0x55 / 255, blue: 0x79 / 255)
    let secondaryColor = Color(red: 0xB1 / 255, green: 0x8A / 255, blue: 0x37 / 255)
    let tertiaryColor = Color(red: 0x62 / 255, green: 0x9A / 255, blue: 0xA2 / 255)
    let backgroundColor = Color(red: 0x00 / 255, green: 0x7A / 255, blue: 0x97 / 255)
    let white = Color(red: 0xFF / 255, green: 0xFF / 255, blue: 0xFF / 255)
    
    var body: some View {
        GeometryReader { _ in
            ZStack {
                primaryColor.edgesIgnoringSafeArea(.all)
                VStack {
                    Spacer()
                    if let nextPrayer = entry.nextPrayer, let previousPrayer = entry.previousPrayer {
                        // Check if the previous prayer was within the last 30 minutes
                        if Calendar.current.dateComponents([.minute], from: previousPrayer.date, to: Date()).minute ?? 0 < 30 && (entry.configuration.showTimer == true) {
                            Text(previousPrayer.name)
                                .foregroundColor(white)
                            Text(previousPrayer.date, style: .timer)
                                .fontWeight(.bold)
                                .foregroundColor(secondaryColor)
                                .multilineTextAlignment(.center)
                        }
                        else {
                            Text(nextPrayer.name)
                                .foregroundColor(white)
                            if Calendar.current.dateComponents([.minute], from: Date(), to: nextPrayer.date).minute ?? 0 <= 60 && (entry.configuration.showTimer == true) {
                                Text(nextPrayer.date, style: .timer)
                                    .fontWeight(.bold)
                                    .foregroundColor(secondaryColor)
                                    .multilineTextAlignment(.center)
                            }
                            else {
                                Text(nextPrayer.date, style: .time)
                                    .fontWeight(.bold)
                                    .foregroundColor(tertiaryColor)
                            }
                        }
                    } else {
                        Text("No upcoming prayers")
                            .foregroundColor(primaryColor)
                    }
                    Spacer()
                }
            }
        }
    }
}

struct PrayerCountdownWidget: Widget {
    // TODO: keep track of the widget kind so we can use it to update the widget
    // in case the user changes the location
    let kind: String = "PrayerCountdownWidget"
    
    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            PrayerCountdownView(entry: entry)
        }
        .configurationDisplayName("Next prayer with timer")
        .description("This widget will show the next prayer and time. \nit will show a countdonw 60 mintues before the prayer. \nit will countup for 30min after the prayer")
        .supportedFamilies([.systemSmall])
        
    }
}

struct PrayerCountdownView_Previews: PreviewProvider {
    static var previews: some View {
        PrayerCountdownView(entry: PrayerEntry(date: Date(), configuration: ConfigurationIntent(), nextPrayer: PrayerData(name: "Isha", date: Date()), previousPrayer: PrayerData(name: "Isha", date: Date())))
    }
}
