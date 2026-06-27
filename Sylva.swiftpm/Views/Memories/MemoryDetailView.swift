import SwiftUI
import SwiftData

//This is for the detailed view that opens up once you tap on the memorygallerycard present on the reflections tab.
@available(iOS 26.0, *)
struct MemoryDetailView: View {
    let moment: NatureMoment
    @EnvironmentObject var journalStore: JournalStore
    @EnvironmentObject var themeManager: ThemeManager
    
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss
    @State private var showDeleteAlert = false

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {

                heroSection
                statsRow

                Divider().padding(.horizontal, 24)

                descriptionSection
                conversationSection
            }
            .padding(.bottom, 40)
        }
        .background(Color(uiColor: .systemBackground))
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            leadingToolbar
            trailingToolbar
        }
        .alert("Delete Memory?", isPresented: $showDeleteAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                journalStore.deleteMoment(moment: moment, context: modelContext)
                dismiss()
            }
        } message: {
            Text("This action cannot be undone.")
        }
    }
}

@available(iOS 26.0, *)
private extension MemoryDetailView {

    var heroSection: some View {
        ZStack(alignment: .bottomLeading) {

            if let data = moment.imageData,
               let uiImage = UIImage(data: data) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
            } else {
                LinearGradient(
                    colors: [.indigo.opacity(0.6), .purple.opacity(0.6)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            }

            LinearGradient(
                colors: [.black.opacity(0.75), .clear],
                startPoint: .bottom,
                endPoint: .center
            )

            VStack(alignment: .leading, spacing: 4) {
                Text("Memory from \(moment.date.formatted(.dateTime.day().month().year()))")
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.85))
            }
            .padding(24)
        }
        .frame(height: 380)
        .clipShape(RoundedRectangle(cornerRadius: 32, style: .continuous))
        .shadow(color: .black.opacity(0.15), radius: 20, y: 10)
        .padding(.horizontal)
        .padding(.top, 16)
    }
}

@available(iOS 26.0, *)
private extension MemoryDetailView {

    var statsRow: some View {
        HStack(spacing: 16) {
            // Image first
            Image(systemName: moment.feeling.icon)
                .font(.system(size: 26))
                .frame(width: 56, height: 56)
                .background(Color.secondary.opacity(0.12))
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .accessibilityHidden(true) // 👈 Hide decorative icon

            // Mood second
            VStack(alignment: .leading, spacing: 4) {
                Text(moment.feeling.name)
                    .font(.headline)
                Text("Mood")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            Spacer()

            // Time third
            VStack(alignment: .leading, spacing: 4) {
                Text(moment.date.formatted(date: .omitted, time: .shortened))
                    .font(.headline)
                Text("Time")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.horizontal, 24)
        //Unconditionally override the children to read a clean sentence
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("Mood recorded as \(moment.feeling.name) at \(moment.date.formatted(date: .omitted, time: .shortened))")
    }
}

@available(iOS 26.0, *)
private extension MemoryDetailView {

    var descriptionSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            
            // 1. MEMORY ESSENCE
            if let summary = moment.memorySummary {
                VStack(alignment: .leading, spacing: 8) {
                    HStack(spacing: 6) {
                        Image(systemName: "sparkles")
                            .font(.caption2)
                            .accessibilityHidden(true) //Hide decorative icon
                        
                        Text("Memory Essence")
                            .font(.caption)
                            .fontWeight(.bold)
                            .textCase(.uppercase)
                            .tracking(1)
                    }
                    .foregroundColor(themeManager.currentTheme.primaryColor)
                    
                    Text(summary)
                        .font(.system(.body, design: .serif))
                        .italic()
                        .foregroundColor(.primary.opacity(0.8))
                        .lineSpacing(6)
                        .padding(16)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(themeManager.currentTheme.primaryColor.opacity(0.08))
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(themeManager.currentTheme.primaryColor.opacity(0.2), lineWidth: 0.5)
                        )
                }
                //Unconditionally combine the children so it reads smoothly
                .accessibilityElement(children: .combine)
            } else {
                Text("A quiet moment captured in time.")
                    .font(.body)
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }

            // 2. CONVERSATION HEADER
            HStack {
                Rectangle()
                    .fill(Color.secondary.opacity(0.2))
                    .frame(height: 1)
                    .accessibilityHidden(true) //Hide decorative lines
                
                Text("Conversation Record")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.secondary)
                    .fixedSize()
                    .accessibilityAddTraits(.isHeader) //Mark this text as a header for easy navigation
                
                Rectangle()
                    .fill(Color.secondary.opacity(0.2))
                    .frame(height: 1)
                    .accessibilityHidden(true) //Hide decorative lines
            }
            .padding(.top, 16)
        }
        .padding(.horizontal, 24)
    }
}

@available(iOS 26.0, *)
private extension MemoryDetailView {

    var conversationSection: some View {
        VStack(spacing: 24) {
            ForEach(moment.conversation) { exchange in
                ReflectionBlock(exchange: exchange)
            }
        }
    }
}

@available(iOS 26.0, *)
private extension MemoryDetailView {

    var leadingToolbar: some ToolbarContent {
        ToolbarItem(placement: .navigationBarLeading) {
            Button {
                dismiss()
            } label: {
                Image(systemName: "chevron.left")
            }
            .accessibilityLabel("Back")
        }
    }

    var trailingToolbar: some ToolbarContent {
        ToolbarItemGroup(placement: .navigationBarTrailing) {

            Button {
                journalStore.toggleFavorite(moment: moment)
            } label: {
                Image(systemName: moment.isFavorite ? "heart.fill" : "heart")
                    .foregroundColor(.red)
            }
            //Dynamic label based on current state
            .accessibilityLabel(moment.isFavorite ? "Remove from favorites" : "Add to favorites")

            Button {
                showDeleteAlert = true
            } label: {
                Image(systemName: "trash")
            }
            .accessibilityLabel("Delete memory")
        }
    }
}

@available(iOS 26.0, *)
struct ReflectionBlock: View {
    let exchange: ChatExchange

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            VStack(alignment: .leading, spacing: 8) {
                Text("Your thought")
                    .font(.caption)
                    .foregroundColor(.secondary)

                Text(exchange.userPrompt)
                    .font(.body)
            }

            Divider()

            VStack(alignment: .leading, spacing: 12) {
                Text(exchange.response.start)
                    .font(.headline)

                Text(exchange.response.response)
                    .font(.body)
                    .lineSpacing(5)

                if let example = exchange.response.example {
                    Text(example)
                        .font(.subheadline.italic())
                        .foregroundColor(.secondary)
                        .padding()
                        .background(Color.green.opacity(0.05))
                        .cornerRadius(16)
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 24)
                .fill(Color(uiColor: .secondarySystemBackground))
        )
        .padding(.horizontal)
        //Groups the entire block so it reads fluidly as one conversational unit
        .accessibilityElement(children: .combine)
    }
}
