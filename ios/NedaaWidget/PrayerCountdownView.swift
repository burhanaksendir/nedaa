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
    @Environment(\.colorScheme) var colorScheme
    var entry: CountdownViewProvider.Entry
    var theme: Theme {
        getTheme(colorScheme: colorScheme)
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                theme.backgroundColor.edgesIgnoringSafeArea(.all)
                VStack(spacing: 0) {
                    if let nextPrayer = entry.nextPrayer, let previousPrayer = entry.previousPrayer {
                        // Display previous prayer
                        ZStack {
                            VStack {
                                Text(previousPrayer.name)
                                    .font(.caption)
                                    .fontWeight(.regular)
                                    .foregroundColor(colorScheme == .dark ? theme.backgroundColor : theme.primaryColor)
                                    .minimumScaleFactor(0.5)
                                // Display previous prayer time
                                Text(previousPrayer.date, style: .time)
                                    .font(.caption)
                                    .bold()
                                    .foregroundColor(colorScheme == .dark ? theme.backgroundColor : theme.primaryColor)
                                    .minimumScaleFactor(0.5)
                            }
                        }
                        .frame(maxWidth: geometry.size.width * 0.8 , alignment: .center)
                        .frame(maxHeight: geometry.size.height * 0.6 , alignment: .center)
                        .background(theme.tertiaryColor)
                        .cornerRadius(10)
                        .padding(EdgeInsets(top: CGFloat(8),
                                            leading: CGFloat(0),
                                            bottom: CGFloat(0),
                                            trailing: CGFloat(0)))
                        .layoutPriority(-1)
                        
                        // Custom curved divider
                        CurvedDivider(color: theme.primaryColor)
                            .padding(.bottom, 0)
                        
                        // Display next prayer
                        VStack(spacing: 0) {
                            Text(nextPrayer.name)
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(theme.primaryColor)
                                .minimumScaleFactor(0.5)
                            
                            // Display next prayer time or timer
                            if Calendar.current.dateComponents([.minute], from: Date(), to: nextPrayer.date).minute ?? 0 <= 60 && (entry.configuration.showTimer == true) {
                                Text(nextPrayer.date, style: .timer)
                                    .font(.title2)
                                    .fontWeight(.semibold)
                                    .foregroundColor(theme.secondaryColor)
                                    .multilineTextAlignment(.center)
                                    .minimumScaleFactor(0.5)
                            }
                            else {
                                Text(nextPrayer.date, style: .time)
                                    .font(.title2)
                                    .fontWeight(.semibold)
                                    .foregroundColor(theme.secondaryColor)
                                    .minimumScaleFactor(0.5)
                            }
                        }
                        .layoutPriority(1)
                        .padding(.top, 0)
                    } else {
                        Text("No upcoming prayers")
                            .font(.caption)
                            .fontWeight(.regular)
                            .foregroundColor(theme.primaryColor)
                    }
                    Spacer()
                }
            }
        }
    }
}

// Custom curved divider
struct CurvedDivider: View {
    var color: Color
    
    var body: some View {
        GeometryReader { geometry in
            Path { path in
                path.move(to: CGPoint(x: 0, y: 0))
                path.addQuadCurve(to: CGPoint(x: geometry.size.width, y: 0), control: CGPoint(x: geometry.size.width / 2, y: 30))
            }
            .stroke(color, lineWidth: 3)
        }
        .frame(height: 30)
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
        PrayerCountdownView(entry: PrayerEntry(date: Date(), configuration: ConfigurationIntent(), nextPrayer: PrayerData(name: "Isha", date: Date()), previousPrayer: PrayerData(name: "Maghrib", date: Date())))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
