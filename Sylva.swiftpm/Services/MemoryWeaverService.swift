import Foundation
import FoundationModels

//Foundation Model Framework is used to generate
@MainActor
@available(iOS 26.0, *)
final class MemoryWeaverService {

    private var session: LanguageModelSession?
    var error: Error?
    var summaryResponse: MemorySummary?

    func generateSummary(from text: [ChatExchange]) async {
        
        // Clear any previous errors before starting a new request
        self.error = nil

        // Initialize session if it doesn't exist
        if session == nil {
            let instructions = """
            ROLE: You are a master of brevity.
            
            RULES:
            - MAX 5-7 words.
            - Fragment sentences okay.
            - Focus on the feeling.
            - Keep it meaningful and related to conversation
            - Example: "Quiet peace in shifting winds."
            """
            session = LanguageModelSession(instructions: instructions)
        }
        
        // Safely unwrap the session to avoid force-unwrapping crashes (!)
        guard let currentSession = session else { return }

        do {
            let prompt = """
            Convert the following interaction into a short emotional memory.
            
            TEXT:
            \(text)
            """
            
            // Perform the request
            let response = try await currentSession.respond(
                to: prompt,
                generating: MemorySummary.self
            )
            
            let result = response.content
            
            self.summaryResponse = result
            
        } catch {
            self.error = error
        }
    }

    func resetSession() {
        session = nil
    }
}

