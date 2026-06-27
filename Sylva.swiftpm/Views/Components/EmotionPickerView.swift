import SwiftUI

//This is a sheetpicker that appears from bottom when we tap the smiley-pencil button on memories tab.
@available(iOS 26.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
struct EmotionPickerView: View {
    @Environment(\.dismiss) private var dismiss
    @AccessibilityFocusState private var isDoneFocused: Bool
    @State private var selectedEmotion: Emotion? = nil
    
    let onSelect: (Emotion) -> Void
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(spacing: 14) {
                    ForEach(JournalStore.emotions) { emotion in
                        emotionRow(for: emotion)
                    }
                }
                .padding()
            }
            .navigationTitle("How are you feeling?")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                        .accessibilityHint("Dismisses the emotion picker without saving.")
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    if let selectedEmotion {
                        Button("Done") {
                            onSelect(selectedEmotion)
                            dismiss()
                        }
                        .fontWeight(.bold)
                        .foregroundColor(.themeBlue)
                        .accessibilityHint("Confirms your selected emotion.")
                        .accessibilityFocused($isDoneFocused)
                    }
                }
            }
        }
    }
    
    private func emotionRow(for emotion: Emotion) -> some View {
        let isSelected = selectedEmotion?.id == emotion.id
        
        return Button {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                if isSelected {
                    onSelect(emotion)
                    dismiss()
                } else {
                    selectedEmotion = emotion
                }
            }
        } label: {
            HStack(spacing: 18) {
                Image(systemName: emotion.icon)
                    .font(.title2)
                    .frame(width: 30)
                    .foregroundColor(isSelected ? .themeBlue : .gray)
                    .accessibilityHidden(true)
                
                Text(emotion.name)
                    .font(.system(.body, design: .serif))
                    .foregroundColor(.primary)
                
                Spacer()
                
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.themeBlue)
                        .accessibilityHidden(true)
                }
            }
            .padding(.vertical, 12)
            .padding(.horizontal, 16)
            .background {
                RoundedRectangle(cornerRadius: 14)
                    .fill(isSelected ? Color.themeBlue.opacity(0.1) : Color(.secondarySystemBackground))
            }
            .overlay {
                RoundedRectangle(cornerRadius: 14)
                    .stroke(isSelected ? Color.themeBlue : Color.clear, lineWidth: 2)
            }
        }
        .buttonStyle(.plain)
        .accessibilityElement(children: .combine)
        .accessibilityLabel(emotion.name)
        .accessibilityAddTraits(isSelected ? .isSelected : [])
        // Dynamic hint that changes based on selection state
        .accessibilityHint(isSelected ? "Double tap again to confirm and close." : "Double tap to select.")
    }
}
