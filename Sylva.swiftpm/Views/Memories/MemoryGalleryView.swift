import SwiftUI
import SwiftData

//This is for the memorygalleryview that appears in form of 2x2 cards on reflections tab.
@available(iOS 26.0, *)
struct MemoryGalleryView: View {
    @EnvironmentObject var journalStore: JournalStore
    @StateObject private var viewModel = MemoryListViewModel()
    
    // Sort by date descending (newest first)
    @Query(sort: \NatureMoment.date, order: .reverse) var allMoments: [NatureMoment]
    
    private let columns: [GridItem] = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {

                    // Filter Chips
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 10) {
                            ForEach(viewModel.filterChips(emotions: JournalStore.emotions)) { chip in
                                EmotionFilterChip(data: chip) {
                                    viewModel.selectEmotion(chip.id == "all" ? nil : chip.title)
                                }
                            }
                        }
                        .padding(.horizontal)
                    }

                    // Memory Grid
                    let filteredMoments = viewModel.filteredMoments(from: allMoments)
                    LazyVGrid(columns: columns, spacing: 18) {
                        if filteredMoments.isEmpty {
                            EmptyStateView(isFilterActive: viewModel.selectedEmotion != nil)
                                .gridCellColumns(2)
                        } else {
                            ForEach(filteredMoments) { moment in
                                NavigationLink {
                                    MemoryDetailView(moment: moment)
                                } label: {
                                    MemoryCard(moment: moment)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 120)
                }
                .padding(.top, 16)
            }
            .scrollIndicators(.hidden)
            .background(SanctuaryView().ignoresSafeArea())
            .navigationTitle("Reflections")
        }
    }
}

@available(iOS 17.0, *)
struct EmotionFilterChip: View {
    @EnvironmentObject var themeManager: ThemeManager
    
    let data: FilterChipData
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 6) {
                Image(systemName: data.icon)
                    .font(.caption2)
                    .accessibilityHidden(true) //Hide decorative icon
                
                Text(data.title)
                    .font(.caption)
                    .fontWeight(.bold)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background {
                if data.isSelected {
                    Capsule().fill(themeManager.currentTheme.primaryColor)
                } else {
                    Capsule().fill(.ultraThinMaterial)
                }
            }
            .overlay(
                Capsule()
                    .stroke(Color.white.opacity(0.3), lineWidth: data.isSelected ? 0 : 1)
            )
            .foregroundColor(data.isSelected ? .white : .primary)
            .shadow(color: data.isSelected ? themeManager.currentTheme.primaryColor.opacity(0.4) : .clear, radius: 8, x: 0, y: 4)
        }
        //Proper traits and dynamic hints
        .accessibilityLabel("\(data.title) filter")
        .accessibilityAddTraits(data.isSelected ? .isSelected : [])
        .accessibilityHint(data.isSelected ? "Removes the filter." : "Filters memories by this mood.")
    }
}

@available(iOS 17.0, *)
struct MemoryCard: View {
    let moment: NatureMoment
    // Deleted the custom accessibility toggle

    var body: some View {
        ZStack(alignment: .topTrailing) {

            // Glass Background
            RoundedRectangle(cornerRadius: 26, style: .continuous)
                .fill(.ultraThinMaterial)
                .background(
                    RoundedRectangle(cornerRadius: 26)
                        .fill(Color.white.opacity(0.38))
                )
                .shadow(color: .black.opacity(0.06), radius: 10, y: 5)

            VStack(alignment: .leading, spacing: 6) {
                
                // Date
                Text(moment.date.formatted(.dateTime.day().month()))
                    .font(.caption2.weight(.semibold))
                    .foregroundColor(.secondary)
                
                // Divider Line
                Rectangle()
                    .fill(Color.white.opacity(0.35))
                    .frame(width: 30, height: 1)
                
                // Object name
                Text(moment.objectName)
                    .font(.headline.weight(.heavy))
                    .foregroundColor(.primary)
                    .lineLimit(1)
                
                // Mood
                HStack(spacing: 4) {
                    Image(systemName: moment.feeling.icon)
                    Text(moment.feeling.name)
                }
                .font(.caption2)
                .foregroundColor(.secondary)
                
                Spacer(minLength: 8)
                
                // Memory Summary
                if let summary = moment.memorySummary, !summary.isEmpty {
                    Text(summary)
                        .font(.system(size: 13, weight: .medium, design: .serif))
                        .foregroundColor(.primary.opacity(0.85))
                        .lineSpacing(2)
                        .lineLimit(3, reservesSpace: true)
                } else {
                    Text("Remembering...")
                    .font(.caption2)
                    .foregroundColor(.secondary.opacity(0.5))
                    .italic()
                    .lineLimit(3, reservesSpace: true)
                }
            }
            .padding(14)
            .frame(maxWidth: .infinity, alignment: .topLeading)
            
            // Image Signature
            if let data = moment.imageData,
               let uiImage = UIImage(data: data) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 38, height: 38)
                    .clipShape(Circle())
                    .overlay(
                        Circle()
                            .stroke(.white.opacity(0.55), lineWidth: 1)
                    )
                    .shadow(radius: 4)
                    .padding(12)
            }
        }
        .overlay(
            RoundedRectangle(cornerRadius: 26)
                .stroke(Color.white.opacity(0.15), lineWidth: 0.5)
        )
        // Ignore the scattered text inside, and provide one clean sentence
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("Memory of \(moment.objectName) on \(moment.date.formatted(.dateTime.day().month())). Mood: \(moment.feeling.name). \(moment.memorySummary ?? "Remembering...")")
        // Removed the gesture from the hint
        .accessibilityHint("Opens memory details.")
    }
}

// If memories are not available for selected filter chip
struct EmptyStateView: View {
    var isFilterActive: Bool = false
    
    var body: some View {
        VStack(spacing: 14) {
            Image(systemName: isFilterActive ? "magnifyingglass" : "sparkles.rectangle.stack")
                .font(.system(size: 40))
                .foregroundColor(.white.opacity(0.8))
                .accessibilityHidden(true) // Hide decorative icon

            Text(isFilterActive ? "No memories found with this mood" : "No memories yet")
                .font(.body.weight(.medium))
                .foregroundColor(.white.opacity(0.85))
        }
        .padding(.vertical, 60)
        .frame(maxWidth: .infinity)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 24))
        .accessibilityElement(children: .combine) // Group the element
    }
}
