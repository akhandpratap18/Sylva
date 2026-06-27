import SwiftData
import Foundation

//To store the saved reflections
@Model
@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
class NatureMoment {
    @Attribute(.unique) var id: String
    var date: Date
    var feeling: Emotion
    var objectName: String
    var conversation: [ChatExchange]
    @Attribute(.externalStorage) var imageData: Data?
    var memorySummary: String?
    var isFavorite: Bool

    init(
        id: String = UUID().uuidString,
        date: Date = Date(),
        feeling: Emotion,
        objectName: String,
        conversation: [ChatExchange],
        imageData: Data? = nil,
        memorySummary: String? = nil,
        isFavorite: Bool = false
    ) {
        self.id = id
        self.date = date
        self.feeling = feeling
        self.objectName = objectName
        self.conversation = conversation
        self.imageData = imageData
        self.memorySummary = memorySummary
        self.isFavorite = isFavorite
    }
}
