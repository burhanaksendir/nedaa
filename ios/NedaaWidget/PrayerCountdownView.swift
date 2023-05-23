import SwiftUI

struct PrayerCountdownView: View {
    var entry: Provider.Entry
    
    var body: some View {
        VStack {
            if let nextPrayer = entry.nextPrayer, let previousPrayer = entry.previousPrayer {
                // Check if the previous prayer was within the last 30 minutes
                if Calendar.current.dateComponents([.minute], from: previousPrayer.date, to: Date()).minute ?? 0 < 30 {
                    Text(previousPrayer.name)
                    Text(previousPrayer.date, style: .timer)
                        .frame(maxWidth: .infinity, alignment: .center)
                }
                else {
                    Text(nextPrayer.name)
                    if Calendar.current.dateComponents([.minute], from: Date(), to: nextPrayer.date).minute ?? 0 <= 60 {
                        Text(nextPrayer.date, style: .timer)
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                    else {
                        Text(nextPrayer.date, style: .time)
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                }
                Text(nextUpdate)
            } else {
                Text("No upcoming prayers")
            }
        }
    }
}



struct PrayerCountdownView_Previews: PreviewProvider {
    static var previews: some View {
        PrayerCountdownView(entry: SimpleEntry(date: Date(), nextPrayer: PrayerData(name: "Isha", date: Date()), previousPrayer: PrayerData(name: "Isha", date: Date())))
    }
}
