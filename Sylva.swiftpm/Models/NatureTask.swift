import SwiftData
import Foundation

//To store the microtasks to be assigned for a specific feeling
@Model
@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
class NatureTask {
    @Attribute(.unique) var id: String
    var feelingName: String
    var natureObject: String
    var title: String
    var findPrompt: String
    var icon: String
    
    init(id: String, feelingName: String, natureObject: String, title: String, findPrompt: String, icon: String) {
        self.id = id
        self.feelingName = feelingName
        self.natureObject = natureObject
        self.title = title
        self.findPrompt = findPrompt
        self.icon = icon
    }
}
