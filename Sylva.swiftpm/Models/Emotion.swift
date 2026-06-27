import SwiftUI
import SwiftData
import Foundation

//To store the emotion with icon for sheetpicker, fetching right microtask and filterchip
struct Emotion: Identifiable, Hashable, Codable {
    var id: String = UUID().uuidString
    var name: String
    var icon: String
}
