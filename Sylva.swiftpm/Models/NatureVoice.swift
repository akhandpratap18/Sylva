import Foundation
import FoundationModels

//To get a structured, guided and expected response from Appe Intelligence Model for the user prompt
struct NatureVoice: Codable, Hashable {
    let start: String
    let response: String
    let example: String?
}

//Casual responses are made for general conversations like hello, hi, how was your day etc.
@available(iOS 26.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
@Generable
struct CasualVoice {
    @Guide(description: "A sweet, endearing opening. IF this is the first message, greet them with tender warmth (e.g., 'Hello, beautiful soul', 'Greetings, sweet friend', 'Hi there, little spark'). IF this is after the first message, response with some genuine reaction related to user's prompt.")
    let start: String
    
    @Guide(description: "Your main reply. Speak like a gentle, loving spirit of nature. Keep it bright, joyful, and sweet. Share a tiny, beautiful detail about your surroundings (a resting butterfly, a warm sunbeam, a dancing leaf). End with a caring question.")
    let response: String
}

//Deep responses are made for philosophical conversations like how do I cope up with my problems etc.
@available(iOS 26.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
@Generable
struct DeepVoice {
    @Guide(description: "A tender, comforting opening that wraps the user in a gentle embrace.")
    let start: String
    
    @Guide(description: "Sweet, loving wisdom using gentle nature metaphors (new blooms after rain, the patience of seeds). Offer hope and comfort.")
    let response: String
    
    @Guide(description: "A sweet, quiet memory of healing or peace from your past.")
    let ancientStory: String
}

@available(iOS 26.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
@Generable
enum ConversationIntent: String {
    case casual
    case deep
}
