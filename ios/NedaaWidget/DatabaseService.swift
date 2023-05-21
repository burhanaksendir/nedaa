import Foundation
import SQLite3




struct PrayerData: Decodable {
    let prayerTimes: PrayerTimes
    let date: String
    let calculationMethod: Int
    let timezone: String
}

struct PrayerTimes: Decodable {
    let Fajr: String
    let Sunrise: String
    let Dhuhr: String
    let Asr: String
    let Maghrib: String
    let Isha: String
}

func parsePrayerData(jsonString: String) -> PrayerData? {
    let data = jsonString.data(using: .utf8)
    let decoder = JSONDecoder()
    do {
        let prayerData = try decoder.decode(PrayerData.self, from: data!)
        return prayerData
    } catch {
        print("Error decoding JSON: \(error)")
        return nil
    }
}

class DatabaseService {
    private let appGroupId = "group.io.nedaa.nedaaApp"
    private let dbPath: String = "nedaa.db"
    
    let columnDate = "date"
    let columnContent = "content"
    
    let prayerTimesTable = "PrayerTimes"
    
    private var db: OpaquePointer?
    
    
    
    // Function to get timezone
    func getTimezone() -> String? {
        let query = "SELECT content from \(prayerTimesTable) LIMIT 1"
        let queryResult = executeSingleResultQuery(query)
        let parsedData = parsePrayerData(jsonString: queryResult ?? "")
        return parsedData?.timezone
    }
    
    // Function to get prayer times for a specific date
    func getDayPrayerTimes(dateInt: Int) -> PrayerTimes? {
        let query = "SELECT content FROM \(prayerTimesTable) WHERE \(columnDate) = ?"
        let queryResult = executeSingleResultQuery(query, withParameter: Int32(dateInt))
        let parsedData = parsePrayerData(jsonString: queryResult ?? "")
        return parsedData?.prayerTimes
    }
    
    // Function to execute a query with a single result
    private func executeSingleResultQuery(_ query: String, withParameter parameter: Int32? = nil) -> String? {
        if !openDB() { return nil }
        // Closing db: not closing it will cause an issue when we open the app
        // as it will be locked
        defer { closeDB() }
        
        var statement: OpaquePointer?
        defer {
            sqlite3_finalize(statement)
        }
        
        if sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK {
            if let parameter = parameter {
                sqlite3_bind_int(statement, 1, parameter)
            }
            
            if sqlite3_step(statement) == SQLITE_ROW {
                let contentJson = String(cString: sqlite3_column_text(statement, 0))
                return contentJson
            }
        } else {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            debugPrint("Error preparing SELECT statement: \(errmsg)")
        }
        
        return nil
    }
    
    
    func parsePrayerData(jsonString: String) -> PrayerData? {
        guard let data = jsonString.data(using: .utf8) else {
            return nil
        }
        
        do {
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            let prayerData = try decoder.decode(PrayerData.self, from: data)
            return prayerData
        } catch {
            debugPrint("Error parsing JSON: \(error)")
            return nil
        }
    }
    
    
    
    // Function to open the database connection
    private func openDB() -> Bool {
        let fileManager = FileManager.default
        let directory = fileManager.containerURL(forSecurityApplicationGroupIdentifier: appGroupId)
        let dbFile = directory!.appendingPathComponent(dbPath)
        if sqlite3_open(dbFile.path, &db) != SQLITE_OK {
            debugPrint("Error opening database")
            return false
        } else {
            debugPrint("Successfully opened connection to database at \(dbPath)")
            return true
        }
    }
    
    private func closeDB() {
        if sqlite3_close(self.db) != SQLITE_OK {
            debugPrint("Error closing database")
        } else {
            debugPrint("Successfully closed connection to database at \(dbPath)")
        }
    }
}
