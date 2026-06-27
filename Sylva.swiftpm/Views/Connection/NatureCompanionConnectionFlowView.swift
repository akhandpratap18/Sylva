import SwiftUI
import AVFoundation
import SwiftData

@available(iOS 26.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
struct NatureCompanionConnectionFlowView: View {
    @Environment(\.modelContext) private var modelContext
    @EnvironmentObject private var journalStore: JournalStore
    @EnvironmentObject private var themeManager: ThemeManager

    
    @StateObject var viewModel: NatureCompanionConnectionFlowViewModel
    @AccessibilityFocusState private var isHeaderFocused: Bool
    @State private var isSaved = false
    

    var body: some View {
        if viewModel.availableNatureTasks.isEmpty {
            emptyStateView
        } else {
            flowView
        }
    }
    

    private var emptyStateView: some View {
        VStack(spacing: 16) {
            Image(systemName: "sparkles")
                .font(.largeTitle)
                .foregroundColor(.white.opacity(0.5))
                .accessibilityHidden(true)
            Text("No tasks found for \(viewModel.selectedEmotionName)")
                .foregroundColor(.white)
                .font(.headline)
            
            Text("This shouldn't happen if database is seeded.")
                .font(.caption)
                .foregroundColor(.white.opacity(0.5))
            
            Button("Close") { viewModel.dismissConnectionFlow() }
                .padding()
                .background(.ultraThinMaterial)
                .cornerRadius(10)
        }
        .frame(maxWidth: .infinity, maxHeight: 300)
        .background(RoundedRectangle(cornerRadius: 30).fill(Color.mountainIndigo.opacity(0.5)))
        .padding(24)
        .accessibilityElement(children: .contain)
        .accessibilityFocused($isHeaderFocused)
        .onAppear { isHeaderFocused = true }
    }
    
    private var flowView: some View {
        let task = viewModel.activeNatureTask
        
        return VStack(alignment: .leading, spacing: 20) {
            headerView(for: task)
            
            Group {
                switch viewModel.currentConnectionStage {
                case .findingNatureCompanion: findStageView(task: task)
                case .capturingCompanionImage: captureStageView()
                case .namingNatureCompanion: nameStageView()
                case .reflectingWithCompanion: reflectStageView()
                }
            }
        }
        .padding(24)
        .background(
            ZStack {
                RoundedRectangle(cornerRadius: 30).fill(.ultraThinMaterial)
                RoundedRectangle(cornerRadius: 30)
                    .stroke(LinearGradient(colors: [.white.opacity(0.5), .clear], startPoint: .topLeading, endPoint: .bottomTrailing), lineWidth: 1)
            }
        )
        .padding(.horizontal, 20)
        .padding(.bottom, 40)
        .shadow(color: Color.mountainIndigo.opacity(0.1), radius: 20, x: 0, y: 10)
        .onAppear { isHeaderFocused = true }
        .onDisappear { if viewModel.isRecordingUserVoice { viewModel.stopRecordingUserVoice() } }
        .fullScreenCover(isPresented: $viewModel.isCameraPresented) { CameraPicker(image: $viewModel.capturedCompanionImage).ignoresSafeArea() }
        .sheet(isPresented: $viewModel.isSampleImagePickerPresented) { SampleImagePicker(selectedImage: $viewModel.capturedCompanionImage) }
    }
    
    private func headerView(for task: NatureTask) -> some View {
        HStack(alignment: .center) {
            if viewModel.currentConnectionStage == .reflectingWithCompanion {
                VStack(alignment: .leading, spacing: 2) {
                    Text("Step 4: Conversation")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(.white.opacity(0.7))
                        .textCase(.uppercase)
                    
                    Text("Talk to \(viewModel.natureCompanionName)")
                        .font(.system(.headline, design: .serif))
                        .foregroundColor(.white)
                }
                .accessibilityElement(children: .combine) //Groups the step number and title
                .accessibilityAddTraits(.isHeader)
                .accessibilityFocused($isHeaderFocused)
            } else {
                HStack(spacing: 10) {
                    Image(systemName: task.icon == "battery.10.fill" ? "battery.25" : task.icon)
                        .font(.title3)
                        .foregroundColor(.white)
                        .accessibilityHidden(true) //Hides the decorative icon unconditionally
                    
                    Text(task.title)
                        .font(.system(.headline, design: .serif))
                        .foregroundColor(.white)
                }
                .accessibilityElement(children: .combine)
                .accessibilityAddTraits(.isHeader)
                .accessibilityFocused($isHeaderFocused)
            }
            Spacer()
            Button { viewModel.dismissConnectionFlow() } label: {
                Image(systemName: "xmark")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(.white.opacity(0.7))
                    .padding(8)
                    .background(Circle().fill(.ultraThinMaterial))
            }
            .accessibilityLabel("Close flow") // Gives context to the X button
        }
    }
    
    // MARK: - STAGE 1: FIND
    private func findStageView(task: NatureTask) -> some View {
        VStack(alignment: .leading, spacing: 18) {
            Text("Find your companion")
                .font(.system(size: 12, weight: .bold))
                .foregroundColor(.white.opacity(0.6))
                .textCase(.uppercase)
                .accessibilityHidden(true) // Hidden as it's redundant with the prompt below
            
            Text(task.findPrompt)
                .font(.system(.body, design: .serif))
                .foregroundColor(.white.opacity(0.9))
                .lineSpacing(4)
            
            HStack(spacing: 12) {
                if viewModel.availableNatureTasks.count > 1 {
                    Button { viewModel.proceedToNextNatureTask() } label: {
                        Text("Skip").fontWeight(.bold)
                            .foregroundColor(.white.opacity(0.6))
                            .frame(width: 80, height: 48)
                            .background(Capsule().stroke(Color.mountainIndigo.opacity(0.2), lineWidth: 1))
                    }
                    .accessibilityHint("Skips to the next nature companion task.")
                }
                Button { viewModel.advanceToImageCaptureStage() } label: {
                    Text("I've Found It")
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, maxHeight: 48)
                        .background(themeManager.currentTheme.primaryColor)
                        .cornerRadius(14)
                }
                // Unconditional native accessibility labels
                .accessibilityLabel("I have found the \(viewModel.availableNatureTasks[max(0, min(viewModel.activeTaskIndex, viewModel.availableNatureTasks.count - 1))].title)")
                .accessibilityHint("Proceeds to the camera to take a photo.")
            }
        }
    }
    
    private func captureStageView() -> some View {
        VStack(alignment: .leading, spacing: 15) {
            ZStack {
                if let image = viewModel.capturedCompanionImage {
                    Button {
                        viewModel.isCameraPresented = true
                    } label: {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFill()
                            .frame(height: 200)
                            .frame(maxWidth: .infinity)
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                            .contentShape(RoundedRectangle(cornerRadius: 20))
                            .overlay(RoundedRectangle(cornerRadius: 20).stroke(.white.opacity(0.5), lineWidth: 1))
                    }
                    .buttonStyle(.plain)
                    .accessibilityLabel("Captured photo")
                    .accessibilityHint("Retakes the picture.")
                } else {
                    Button {
                        viewModel.isCameraPresented = true
                    } label: {
                        RoundedRectangle(cornerRadius: 20).fill(Color.mountainIndigo.opacity(0.05))
                            .frame(height: 200)
                            .overlay(
                                VStack(spacing: 12) {
                                    Image(systemName: "camera.viewfinder").font(.largeTitle).foregroundColor(.white.opacity(0.5))
                                        .accessibilityHidden(true)
                                    Text("Capture your new friend").font(.caption).foregroundColor(.white.opacity(0.7))
                                }
                            )
                    }
                    .buttonStyle(.plain)
                    .accessibilityElement(children: .ignore)
                    .accessibilityLabel("Open Camera")
                    .accessibilityHint("Opens the camera to take a picture.")
                }
            }
            
            HStack {
                if viewModel.capturedCompanionImage == nil {
                    Button { viewModel.isSampleImagePickerPresented = true } label: {
                        Label("Use Sample", systemImage: "photo.on.rectangle")
                            .font(.caption).bold().padding(.horizontal, 12).padding(.vertical, 8)
                            .background(Capsule().fill(Color.mountainIndigo.opacity(0.1)))
                            .foregroundColor(.white)
                    }
                    .accessibilityHint("Choose a pre-selected image instead of taking a photo.")
                }
                Spacer()
                Button { viewModel.advanceToCompanionNamingStage() } label: {
                    Text("Captured")
                        .fontWeight(.bold).foregroundColor(.white)
                        .padding(.horizontal, 30).frame(height: 48)
                        .background(viewModel.capturedCompanionImage != nil ? themeManager.currentTheme.primaryColor : Color.gray.opacity(0.3))
                        .cornerRadius(14)
                }
                .disabled(viewModel.capturedCompanionImage == nil)
                .accessibilityHint("Proceeds to the naming step.")
            }
        }
    }
    
    private func nameStageView() -> some View {
        VStack(alignment: .leading, spacing: 18) {
            
            Text("Give your friend a name")
                .font(.caption)
                .bold()
                .foregroundColor(.white.opacity(0.6))
                .accessibilityHidden(true) //Hidden, as the text field label will handle this
            
            TextField("e.g., Daisy, Bella", text: $viewModel.natureCompanionName)
                .font(.headline)
                .foregroundColor(.white)
                .padding()
                .background(RoundedRectangle(cornerRadius: 14).fill(.white.opacity(0.2)))
                .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color.mountainIndigo.opacity(0.1), lineWidth: 1))
                .tint(themeManager.currentTheme.primaryColor)
                .accessibilityLabel("Give your friend a name") //Explicit label for the text field
            
            Button {
                viewModel.advanceToCompanionReflectionStage()
            } label: {
                Text("Next Step")
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
            }
            .background(!viewModel.natureCompanionName.isEmpty ? themeManager.currentTheme.primaryColor : Color.gray.opacity(0.3))
            .cornerRadius(16)
            .disabled(viewModel.natureCompanionName.isEmpty)
        }
        .frame(maxWidth: .infinity)
    }
    private func reflectStageView() -> some View {
        VStack(alignment: .leading, spacing: 15) {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 15) {
                    if let result = viewModel.natureIntelligenceService.generatedResponse {
                        chatResponseView(result: result)
                    } else if viewModel.natureIntelligenceService.isThinking {
                        thinkingIndicator
                    } else if let chatError = viewModel.natureIntelligenceService.error {
                        errorView(chatError: chatError)
                    } else if viewModel.isRecordingUserVoice || !viewModel.voiceInputService.transcript.isEmpty {
                        transcriptionView
                    } else {
                        Text("Speak your current feelings to **\(viewModel.natureCompanionName)**. What is on your mind?")
                            .font(.body).foregroundColor(.white.opacity(0.7))
                    }
                }
            }
            .frame(height: viewModel.natureIntelligenceService.generatedResponse != nil ? 180 : 120)
            .animation(.spring(response: 0.5, dampingFraction: 0.7), value: viewModel.natureIntelligenceService.generatedResponse)
            
            HStack(spacing: 12) {
                if viewModel.natureIntelligenceService.generatedResponse != nil && !viewModel.isRecordingUserVoice {
                    saveButton
                }
                talkButton
            }
        }
    }

    private func chatResponseView(result: NatureVoice) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            if !viewModel.mostRecentUserPrompt.isEmpty {
                Text(viewModel.mostRecentUserPrompt)
                    .font(.system(size: 14))
                    .foregroundColor(.white)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(RoundedRectangle(cornerRadius: 12).fill(Color.mountainIndigo.opacity(0.4)))
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .accessibilityLabel("You said: \(viewModel.mostRecentUserPrompt)") //Distinguishes who said what
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text(result.start)
                    .font(.system(.headline, design: .serif))
                    .foregroundColor(.white)
                
                Text(result.response)
                    .font(.body)
                    .foregroundColor(.white.opacity(0.9))
                    .lineSpacing(4)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .accessibilityElement(children: .combine)
            .accessibilityLabel("\(viewModel.natureCompanionName) replied: \(result.start) \(result.response)")
            
            if let exampleText = result.example {
                HStack(alignment: .top, spacing: 10) {
                    Image(systemName: "sparkles")
                        .foregroundColor(themeManager.currentTheme.primaryColor)
                        .accessibilityHidden(true)
                    
                    Text(exampleText)
                        .font(.system(.subheadline, design: .serif).italic())
                        .foregroundColor(.white.opacity(0.8))
                        .multilineTextAlignment(.leading)
                }
                .padding(14)
                .background(Color.mountainIndigo.opacity(0.1))
                .cornerRadius(14)
                .accessibilityElement(children: .combine)
                .accessibilityLabel("Suggestion: \(exampleText)")
            }
        }
    }
    
    private var thinkingIndicator: some View {
        HStack {
            ProgressView().tint(.white)
            Text("\(viewModel.natureCompanionName) is thinking...")
                .font(.subheadline).italic()
                .foregroundColor(.white.opacity(0.7))
        }
        .frame(maxWidth: .infinity).padding(.vertical, 20)
        .accessibilityElement(children: .combine) //Reads as one element
    }
    
    private func errorView(chatError: Error) -> some View {
        VStack(spacing: 8) {
            Image(systemName: "exclamationmark.triangle").foregroundColor(.yellow)
                .accessibilityHidden(true)
            Text("The wind is silent. Please ensure Apple Intelligence is enabled and downloaded.")
                .font(.subheadline).foregroundColor(.white.opacity(0.8))
            Text(chatError.localizedDescription)
                .font(.caption).foregroundColor(.red.opacity(0.8))
                .multilineTextAlignment(.center).padding(.top, 5)
        }
        .frame(maxWidth: .infinity, alignment: .center).padding()
        .accessibilityElement(children: .combine)
    }
    
    private var transcriptionView: some View {
        Text(viewModel.voiceInputService.transcript.isEmpty ? "Listening..." : viewModel.voiceInputService.transcript)
            .foregroundColor(.white)
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(RoundedRectangle(cornerRadius: 15).fill(Color.mountainIndigo.opacity(0.1)))
            .accessibilityLabel("Live Transcription: \(viewModel.voiceInputService.transcript.isEmpty ? "Listening" : viewModel.voiceInputService.transcript)")
    }
    
    private var saveButton: some View {
        Button {
            isSaved = true
            Task {
                await viewModel.saveJourneyMomentToStore(journalStore: journalStore, modelContext: modelContext)
            }
        } label: {
            Image(systemName: isSaved ? "bookmark.fill" : "bookmark")
                .foregroundColor(.white)
                .frame(width: 54, height: 54)
                .background(Circle().fill(Color.mountainIndigo.opacity(0.1)))
        }
        .accessibilityLabel("Save memory")
        .accessibilityHint("Saves this conversation and photo to your memories.")
    }
    
    private var talkButton: some View {
            HStack(spacing: 8) {
                if !viewModel.isRecordingUserVoice {
                    TextField(viewModel.natureIntelligenceService.generatedResponse != nil ? "Reply..." : "Message \(viewModel.natureCompanionName)...", text: $viewModel.typedUserMessage)
                        .font(.body)
                        .foregroundColor(.white)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 14)
                        .background(RoundedRectangle(cornerRadius: 16).fill(.white.opacity(0.15)))
                        .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.mountainIndigo.opacity(0.1), lineWidth: 1))
                        .tint(themeManager.currentTheme.primaryColor)
                        .onSubmit {
                            viewModel.submitTypedUserMessage()
                        }
                        .disabled(viewModel.natureIntelligenceService.isThinking)
                        .accessibilityLabel("Message to \(viewModel.natureCompanionName)")
                    
                    Button {
                        let text = viewModel.typedUserMessage.trimmingCharacters(in: .whitespacesAndNewlines)
                        if text.isEmpty {
                            viewModel.toggleVoiceRecordingState()
                        } else {
                            viewModel.submitTypedUserMessage()
                        }
                    } label: {
                        let isTextEmpty = viewModel.typedUserMessage.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
                        Image(systemName: isTextEmpty ? "mic.fill" : "arrow.up")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.white)
                            .frame(width: 52, height: 52)
                            .background(themeManager.currentTheme.primaryColor)
                            .clipShape(Circle())
                            .accessibilityHidden(true)
                    }
                    .disabled(viewModel.natureIntelligenceService.isThinking)
                    .accessibilityLabel(viewModel.typedUserMessage.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? "Start Recording Voice" : "Send Message")
                    .accessibilityHint(viewModel.typedUserMessage.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? "Begins recording your voice." : "Sends your typed response.")
                } else {
                    Button {
                        viewModel.toggleVoiceRecordingState()
                    } label: {
                        HStack {
                            Image(systemName: "stop.fill")
                                .accessibilityHidden(true)
                            Text("I'm Done")
                        }
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(Color.red.opacity(0.7))
                        .cornerRadius(16)
                    }
                    .accessibilityLabel("Stop recording")
                    .accessibilityHint("Stops the microphone and sends your message.")
                }
            }
            .animation(.easeInOut(duration: 0.3), value: viewModel.isRecordingUserVoice)
            .animation(.easeInOut(duration: 0.3), value: viewModel.typedUserMessage.isEmpty)
        }
}

struct CameraPicker: UIViewControllerRepresentable {
    @Binding var image: UIImage?
    @Environment(\.dismiss) private var dismiss
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = UIImagePickerController.isSourceTypeAvailable(.camera) ? .camera : .photoLibrary
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    func makeCoordinator() -> Coordinator { Coordinator(self) }
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: CameraPicker
        init(_ parent: CameraPicker) { self.parent = parent }
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let uiImage = info[.originalImage] as? UIImage { parent.image = uiImage }
            parent.dismiss()
        }
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.dismiss()
        }
    }
}

struct SampleImagePicker: View {
    @Binding var selectedImage: UIImage?
    @Environment(\.dismiss) private var dismiss
    
    private let sampleNames = ["sample1", "sample2", "sample3", "sample4"]
    private let columns = [GridItem(.flexible()), GridItem(.flexible())]
    
    private func loadImage(named name: String) -> UIImage? {
        if let image = UIImage(named: name) { return image }
        let extensions = ["jpg", "jpeg", "png", "heic"]
        for ext in extensions {
            if let url = Bundle.main.url(forResource: name, withExtension: ext),
               let data = try? Data(contentsOf: url),
               let image = UIImage(data: data) { return image }
        }
        return nil
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(sampleNames, id: \.self) { name in
                        let image = loadImage(named: name)
                        
                        Button {
                            if let image {
                                selectedImage = image
                                dismiss()
                            }
                        } label: {
                            if let image {
                                Image(uiImage: image)
                                    .resizable().scaledToFill()
                                    .frame(height: 120).clipShape(RoundedRectangle(cornerRadius: 12))
                                    .accessibilityLabel("Sample image \(name)") // 👈 Identifies which sample is which
                            } else {
                                RoundedRectangle(cornerRadius: 12).fill(Color.red.opacity(0.1)).frame(height: 120)
                                    .overlay(Text("Missing: \(name)").font(.caption).foregroundColor(.red))
                            }
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("Choose Token")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) { Button("Cancel") { dismiss() } }
            }
        }
    }
}
