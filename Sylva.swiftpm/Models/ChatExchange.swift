import Foundation

// To store the conversation between user and nature object
struct ChatExchange: Identifiable, Codable, Hashable {
    var id: String = UUID().uuidString
    var userPrompt: String
    var response: NatureVoice
}
