import Foundation
import SwiftUI

struct Theme {
    let primaryColor: Color
    let secondaryColor: Color
    let tertiaryColor: Color
    let backgroundColor: Color
    

    static let light = Theme(
        primaryColor: Color(hex: "#537188"),
        secondaryColor: Color(hex: "#CBB279"),
        tertiaryColor: Color(hex: "#E1D4BB"),
        backgroundColor: Color(hex: "#EEEEEE")
    )
    
    static let dark = Theme(
        primaryColor: Color(hex: "#CBB279"),
        secondaryColor: Color(hex: "#EEEEEE"),
        tertiaryColor: Color(hex: "#E1D4BB"),
        backgroundColor: Color(hex: "#537188")
    )
    
    
 
}

func getTheme(colorScheme: ColorScheme) -> Theme {
    return colorScheme == .dark ? Theme.dark : Theme.light
}



extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (r, g, b) = ((int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (r, g, b) = (int >> 16, int >> 8 & 0xFF, int & 0xFF)
        default:
            (r, g, b) = (1, 1, 1) // Invalid, use white color
        }
        self.init(red: Double(r) / 255, green: Double(g) / 255, blue: Double(b) / 255)
    }
}
