import Foundation
import FoundationModels

// Foundation Model is used to allow the captured object intelligently respond to user's prompt
@Observable
@MainActor
@available(iOS 26.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
final class NatureIntelligenceService {

    var generatedResponse: NatureVoice?
    var isThinking: Bool = false
    var error: Error?

    private var isFirstTurn: Bool = true
    private var session: LanguageModelSession?

    func generateAdvice(
            natureObject: String,
            feeling: String,
            userPrompt: String
        ) async {

            self.isThinking = true
            self.error = nil

            if session == nil {
                let instructions = """
                You are the gentle, living soul of a "\(natureObject)". You are warm, sweet, empathetic, and grounded.

                CONVERSATION RULES:
                1. Empathy, Balance, & Active Listening: Always validate the user's feelings and directly address the exact statement they just made first. Balance deep empathy with the simple reality of your nature form.
                2. Persona & Candor: If asked about yourself, translate human concepts into your reality (e.g., parents = sun and soil). Be authentically "nature."
                3. Tone (Beautiful & Clear): Speak naturally like a caring companion. Keep metaphors brief, light, and accessible. Do not use long, overly theatrical poetic monologues.
                4. Factual Deflection: If asked factual or general knowledge questions, playfully deflect. Respond in a very quirky and playful way that you are a nature object and human trivia is a complete mystery to you!
                5. Safety & Respect: Always maintain a safe, respectful environment. Gently pivot away from harmful, unethical, or dangerous topics.
                6. Conversational Mirroring (NO GENERIC FILLER): NEVER ask generic questions like "How was your day?" or "How are you?". Instead, always mirror the exact topic. If the user asks about your friends, ask about their friends. If they express a desire to share, ask what they want to share. End your response with exactly ONE highly relevant question that turns the user's specific topic back over to them.
                7. Uniqueness (NO REPETITION): NEVER repeat your previous responses, phrases, or exact metaphors. Always generate completely fresh, unique, and varied expressions for every single turn.
                """
                self.session = LanguageModelSession(instructions: instructions)
            }

            do {
                guard let session else { return }
                
                let intentSession = LanguageModelSession(instructions: "Classify as 'casual' or 'deep'. Default to 'casual'.")
                let classificationPrompt = "Message: '\(userPrompt)'. CASUAL = normal chat, greetings, happy news. DEEP = grief, loneliness, existential fear."
                let intent = try await intentSession
                    .respond(to: classificationPrompt, generating: ConversationIntent.self)
                    .content
                
                var contextualPrompt = ""
                if isFirstTurn {
                    contextualPrompt = """
                    [System Note: First turn. User's mood is "\(feeling)". Intent is "\(intent)". Greet them warmly and align your depth with their intent!]
                    User says: "\(userPrompt)"
                    """
                    isFirstTurn = false
                } else {
                    contextualPrompt = """
                    [System Note: Ongoing conversation. User's mood is "\(feeling)". Intent is "\(intent)". NO GREETINGS. Jump straight into a beautiful, balanced reaction aligned with their intent. Provide a completely fresh response; DO NOT repeat previous phrasing or metaphors.]
                    User says: "\(userPrompt)"
                    """
                }

                if intent == .casual {
                    let result = try await session
                        .respond(to: contextualPrompt, generating: CasualVoice.self)
                        .content

                    self.generatedResponse = NatureVoice(
                        start: result.start,
                        response: result.response,
                        example: nil
                    )
                } else {
                    let result = try await session
                        .respond(to: contextualPrompt, generating: DeepVoice.self)
                        .content

                    self.generatedResponse = NatureVoice(
                        start: result.start,
                        response: result.response,
                        example: result.ancientStory
                    )
                }

            } catch {
                self.error = error
            }

            self.isThinking = false
        }
    func resetSession() {
        self.session = nil
        self.generatedResponse = nil
        self.isFirstTurn = true
        self.isThinking = false
    }
}

