import Foundation



struct PrayerDataService {
    var dbService = DatabaseService()
    
    func getDayPrayerTimes(for date: Date) -> [PrayerData]? {
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
    
    func getTodaysPrayerTimes() -> [PrayerData]? {
        guard let timeZoneString = dbService.getTimezone(),
              let timeZone = TimeZone(identifier: timeZoneString) else {
            print("Error: Could not retrieve timezone")
            return nil
        }
        let today = Date().toLocalTime(timezone: timeZone)
        return getDayPrayerTimes(for: today)
    }
    
    func getTomorrowsPrayerTimes() -> [PrayerData]? {
        guard let timeZoneString = dbService.getTimezone(),
              let timeZone = TimeZone(identifier: timeZoneString),
              let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: Date().toLocalTime(timezone: timeZone)) else {
            print("Error: Could not calculate tomorrow's date")
            return nil
        }
        return getDayPrayerTimes(for: tomorrow)
    }
    
    func getYesterdaysPrayerTimes() -> [PrayerData]? {
        guard let timeZoneString = dbService.getTimezone(),
              let timeZone = TimeZone(identifier: timeZoneString),
              let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: Date().toLocalTime(timezone: timeZone)) else {
            print("Error: Could not calculate yesterday's date")
            return nil
        }
        return getDayPrayerTimes(for: yesterday)
    }
    
    func getNextPrayer() -> PrayerData? {
        let currentDate = Date()
        guard let prayerTimes = getTodaysPrayerTimes() else {
            return nil
        }
        
        
        
        // Sort the prayer times by date
        let sortedPrayerTimes = prayerTimes.sorted(by: { $0.date < $1.date })
        
        // Find the first prayer time that is later than the current date
        for prayer in sortedPrayerTimes {
            if prayer.date > currentDate {
                return prayer
            }
        }
        
        // If no prayer times are later than the current date, return the first prayer time of the next day
        guard let firstPrayerNextDay = getTomorrowsPrayerTimes()?.sorted(by: { $0.date < $1.date }).first else {
            // Handle error here
            return nil
        }
        
        return firstPrayerNextDay
    }
    
    
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
