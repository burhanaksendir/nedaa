import SwiftUI

struct PrayerCountdownView: View {
    var entry: Provider.Entry
    
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
                        if Calendar.current.dateComponents([.minute], from: previousPrayer.date, to: Date()).minute ?? 0 < 30 {
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
                            if Calendar.current.dateComponents([.minute], from: Date(), to: nextPrayer.date).minute ?? 0 <= 60 {
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

struct PrayerCountdownView_Previews: PreviewProvider {
    static var previews: some View {
        PrayerCountdownView(entry: PrayerEntry(date: Date(), configuration: ConfigurationIntent(), nextPrayer: PrayerData(name: "Isha", date: Date()), previousPrayer: PrayerData(name: "Isha", date: Date())))
    }
}
