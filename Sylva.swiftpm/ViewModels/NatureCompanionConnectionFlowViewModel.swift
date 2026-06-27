import SwiftUI
import SwiftData
import AVFoundation

// This is implemented to facilitate the four steps of finding, capturing, naming and conversing with the nature object in the ConnectionFlowView
@MainActor
@available(iOS 26.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
class NatureCompanionConnectionFlowViewModel: ObservableObject {
    
    // Enums
    enum NatureConnectionStage {
        case findingNatureCompanion
        case capturingCompanionImage
        case namingNatureCompanion
        case reflectingWithCompanion
    }
    
    // Properties
    @Published var activeTaskIndex: Int = 0
    @Published var currentConnectionStage: NatureConnectionStage = .findingNatureCompanion
    @Published var natureCompanionName: String = ""
    
    @Published var isCameraPresented: Bool = false
    @Published var capturedCompanionImage: UIImage? = nil
    @Published var isSampleImagePickerPresented: Bool = false
    
    @Published var isRecordingUserVoice: Bool = false
    @Published var previousConversationHistory: [ChatExchange] = []
    @Published var mostRecentUserPrompt: String = ""
    @Published var typedUserMessage: String = ""
    
    // Services
    let voiceInputService = VoiceInputService()
    let natureIntelligenceService = NatureIntelligenceService()
    
    // Data
    let availableNatureTasks: [NatureTask]
    let selectedEmotionName: String
    private let dismissFlowAction: () -> Void
    
    init(natureTasks: [NatureTask], emotionName: String, onClose: @escaping () -> Void) {
        self.availableNatureTasks = natureTasks
        self.selectedEmotionName = emotionName
        self.dismissFlowAction = onClose
    }
    
    var activeNatureTask: NatureTask {
        guard !availableNatureTasks.isEmpty else {
            // Fallback safety, though view handles empty state
            return NatureTask(id: "fallback", feelingName: "", natureObject: "", title: "", findPrompt: "", icon: "")
        }
        return availableNatureTasks[activeTaskIndex % availableNatureTasks.count]
    }
    
    func proceedToNextNatureTask() {
        withAnimation { activeTaskIndex += 1 }
    }
    
    func advanceToImageCaptureStage() {
        withAnimation { currentConnectionStage = .capturingCompanionImage }
    }
    
    func advanceToCompanionNamingStage() {
        withAnimation { currentConnectionStage = .namingNatureCompanion }
    }
    
    func advanceToCompanionReflectionStage() {
        withAnimation { currentConnectionStage = .reflectingWithCompanion }
    }
    
    func dismissConnectionFlow() {
        if isRecordingUserVoice { stopRecordingUserVoice() }
        natureIntelligenceService.resetSession()
        previousConversationHistory.removeAll()
        dismissFlowAction()
    }
    
    func toggleVoiceRecordingState() {
        withAnimation {
            if isRecordingUserVoice {
                stopRecordingAndGenerateIntelligenceResponse()
            } else {
                startRecordingUserVoice()
            }
        }
    }
    
    func startRecordingUserVoice() {
        natureIntelligenceService.generatedResponse = nil
        voiceInputService.resetTranscript()
        voiceInputService.startTranscribing()
        isRecordingUserVoice = true
    }
    
    func stopRecordingAndGenerateIntelligenceResponse() {
        voiceInputService.stopTranscribing()
        isRecordingUserVoice = false
        
        Task {
            let transcribedText = voiceInputService.transcript
            mostRecentUserPrompt = transcribedText
            
            if !mostRecentUserPrompt.isEmpty {
                natureIntelligenceService.generatedResponse = nil
                natureIntelligenceService.isThinking = true
                await natureIntelligenceService.generateAdvice(natureObject: natureCompanionName, feeling: selectedEmotionName, userPrompt: mostRecentUserPrompt)
                
                if let intelligenceResponse = natureIntelligenceService.generatedResponse {
                    previousConversationHistory.append(ChatExchange(userPrompt: mostRecentUserPrompt, response: intelligenceResponse))
                }
            }
        }
    }
    
    func submitTypedUserMessage() {
        let trimmedUserMessage = typedUserMessage.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedUserMessage.isEmpty else { return }
        
        mostRecentUserPrompt = trimmedUserMessage
        typedUserMessage = ""
        isRecordingUserVoice = false
        
        Task {
            natureIntelligenceService.generatedResponse = nil // 👈 Clear old response so UI shows thinking
            natureIntelligenceService.isThinking = true
            await natureIntelligenceService.generateAdvice(natureObject: natureCompanionName, feeling: selectedEmotionName, userPrompt: mostRecentUserPrompt)
            
            if let intelligenceResponse = natureIntelligenceService.generatedResponse {
                previousConversationHistory.append(ChatExchange(userPrompt: mostRecentUserPrompt, response: intelligenceResponse))
            }
        }
    }
    
    func stopRecordingUserVoice() {
        voiceInputService.stopTranscribing()
        isRecordingUserVoice = false
    }
    
    func saveJourneyMomentToStore(journalStore: JournalStore, modelContext: ModelContext) async {
        let selectedEmotion = JournalStore.emotions.first(where: { $0.name == selectedEmotionName }) ?? Emotion(name: selectedEmotionName, icon: "star")
        let compressedImageData = capturedCompanionImage?.jpegData(compressionQuality: 0.8)
        
        var finalizedConversationHistory = previousConversationHistory
        if let currentIntelligenceResponse = natureIntelligenceService.generatedResponse {
            if finalizedConversationHistory.isEmpty || finalizedConversationHistory.last?.response != currentIntelligenceResponse {
                 finalizedConversationHistory.append(ChatExchange(userPrompt: mostRecentUserPrompt, response: currentIntelligenceResponse))
            }
        }
        
        await journalStore.saveMoment(
            context: modelContext,
            feeling: selectedEmotion,
            objectName: natureCompanionName,
            conversation: finalizedConversationHistory,
            imageData: compressedImageData
        )
        
        dismissConnectionFlow()
    }
}
