import Foundation


struct PrayerDataService {
    var dbService = DatabaseService()
    
    // Function to get prayer times for a specific date
    func getDayPrayerTimes(for date: Date) -> PrayerTimes? {
        guard let timeZoneString = dbService.getTimezone(),
              let timeZone = TimeZone(identifier: timeZoneString) else {
            print("Error: Could not retrieve timezone")
            return nil
        }
        
        let dateInt = getDateInt(for: date, in: timeZone)
        guard let prayerTimes = dbService.getDayPrayerTimes(dateInt: dateInt) else {
            print("Error: No data found for date: \(date)")
            return nil
        }
        return prayerTimes
    }
    
    // Function to get today's prayer times
    func getTodaysPrayerTimes() -> PrayerTimes? {
        guard let timeZoneString = dbService.getTimezone(),
              let timeZone = TimeZone(identifier: timeZoneString) else {
            print("Error: Could not retrieve timezone")
            return nil
        }
        let today = Date().toLocalTime(timezone: timeZone)
        return getDayPrayerTimes(for: today)
    }
    
    // Function to get tomorrow's prayer times
    func getTomorrowsPrayerTimes() -> PrayerTimes? {
        guard let timeZoneString = dbService.getTimezone(),
              let timeZone = TimeZone(identifier: timeZoneString),
              let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: Date().toLocalTime(timezone: timeZone)) else {
            print("Error: Could not calculate tomorrow's date")
            return nil
        }
        return getDayPrayerTimes(for: tomorrow)
    }

    // Function to get yesterday's prayer times
    func getYesterdaysPrayerTimes() -> PrayerTimes? {
        guard let timeZoneString = dbService.getTimezone(),
              let timeZone = TimeZone(identifier: timeZoneString),
              let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: Date().toLocalTime(timezone: timeZone)) else {
            print("Error: Could not calculate yesterday's date")
            return nil
        }
        return getDayPrayerTimes(for: yesterday)
    }

    // Function to get date as an integer in the format YYYYMMDD
    private func getDateInt(for date: Date, in timeZone: TimeZone) -> Int {
        var calendar = Calendar.current
        calendar.timeZone = timeZone
        let components = calendar.dateComponents([.year, .month, .day], from: date)
        return components.year! * 10000 + components.month! * 100 + components.day!
    }

}


extension Date {
    func toLocalTime(timezone: TimeZone) -> Date {
        let timezoneOffset = TimeInterval(timezone.secondsFromGMT(for: self))
        return self.addingTimeInterval(timezoneOffset)
    }
}
