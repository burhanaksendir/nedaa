import Foundation



struct PrayerDataService {
    var dbService = DatabaseService()
    
    func getDayPrayerTimes(for date: Date) -> [PrayerData]? {
        if dbService.timeZone.isEmpty {
            dbService.getTimezone()
        }
        
        guard let timeZoneObj = TimeZone(identifier: dbService.timeZone) else {
            debugPrint("Error: Could not retrieve timezone")
            
            return nil
            
        };
        let dateInt = getDateInt(for: date, in: timeZoneObj)
        guard let prayerTimes = dbService.getDayPrayerTimes(dateInt: dateInt) else {
            print("Error: No data found for date: \(date)")
            return nil
        }
        return prayerTimes
    }
    
    func getTodaysPrayerTimes() -> [PrayerData]? {
        if dbService.timeZone.isEmpty {
            dbService.getTimezone()
        }
        
        guard let timeZoneObj = TimeZone(identifier: dbService.timeZone) else {
            debugPrint("Error: Could not retrieve timezone")
            
            return nil
            
        };
        let today = Date().toLocalTime(timezone: timeZoneObj)
        return getDayPrayerTimes(for: today)
    }
    
    func getTomorrowsPrayerTimes() -> [PrayerData]? {
        if dbService.timeZone.isEmpty {
            dbService.getTimezone()
        }
        
        guard let timeZoneObj = TimeZone(identifier: dbService.timeZone) else {
            debugPrint("Error: Could not retrieve timezone")
            
            return nil
            
        };
        
        guard let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: Date().toLocalTime(timezone: timeZoneObj)) else {
            print("Error: Could not calculate tomorrow's date")
            return nil
        }
        
        return getDayPrayerTimes(for: tomorrow)
    }
    
    func getYesterdaysPrayerTimes() -> [PrayerData]? {
        if dbService.timeZone.isEmpty {
            dbService.getTimezone()
        }
        
        guard let timeZoneObj = TimeZone(identifier: dbService.timeZone) else {
            debugPrint("Error: Could not retrieve timezone")
            
            return nil
            
        };
        
        guard let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: Date().toLocalTime(timezone: timeZoneObj)) else {
            print("Error: Could not calculate yesterday's date")
            return nil
        };
        return getDayPrayerTimes(for: yesterday)
    }
    
    func getNextPrayer(showSunrise: Bool = true) -> PrayerData? {
        let currentDate = Date()
        guard let prayerTimes = getTodaysPrayerTimes() else {
            return nil
        }
        
        
        
        // Sort the prayer times by date
        let sortedPrayerTimes = prayerTimes.sorted(by: { $0.date < $1.date })
        
        // Find the first prayer time that is later than the current date
        for prayer in sortedPrayerTimes {
            // If the prayer is sunrise and we don't want to show sunrise, skip it
            if prayer.name == "Sunrise" && !showSunrise {
                continue
            }
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
    
    func getPreviousPrayer(showSunrise: Bool = true) -> PrayerData? {
        let currentDate = Date()
        guard let prayerTimes = getTodaysPrayerTimes() else {
            return nil
        }
        
        // Sort the prayer times by date
        let sortedPrayerTimes = prayerTimes.sorted(by: { $0.date < $1.date })
        
        // Find the last prayer time that is earlier than the current date
        for prayer in sortedPrayerTimes.reversed() {
            // If the prayer is sunrise and we don't want to show sunrise, skip it
            if prayer.name == "Sunrise" && !showSunrise {
                continue
            }
            if prayer.date < currentDate {
                return prayer
            }
        }
        
        // If no prayer times are earlier than the current date, return the last prayer time of the previous day
        guard let lastPrayerPreviousDay = getYesterdaysPrayerTimes()?.sorted(by: { $0.date < $1.date }).last else {
            // Handle error here
            return nil
        }
        
        return lastPrayerPreviousDay
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
