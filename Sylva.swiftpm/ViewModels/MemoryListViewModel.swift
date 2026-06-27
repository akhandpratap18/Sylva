import SwiftUI
import SwiftData

//This is for filtering and picking memories for a specific emotion
@MainActor
@available(iOS 26.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
class MemoryListViewModel: ObservableObject {
    @Published var selectedEmotion: String? = nil
    @Published var showOnlyFavorites: Bool = false
    
    func filterChips(emotions: [Emotion]) -> [FilterChipData] {
        var chips: [FilterChipData] = [
            FilterChipData(id: "all", title: "All", icon: "square.grid.2x2.fill", isSelected: selectedEmotion == nil && !showOnlyFavorites),
            FilterChipData(id: "favorites", title: "Favorites", icon: "heart.fill", isSelected: showOnlyFavorites)
        ]
        
        let emotionChips = emotions.map { emotion in
            FilterChipData(
                id: emotion.id,
                title: emotion.name,
                icon: emotion.icon,
                isSelected: selectedEmotion == emotion.name && !showOnlyFavorites
            )
        }
        chips.append(contentsOf: emotionChips)
        return chips
    }
    
    func selectEmotion(_ name: String?) {
        withAnimation {
            if name == "Favorites" {
                showOnlyFavorites.toggle()
                if showOnlyFavorites { selectedEmotion = nil }
            } else {
                showOnlyFavorites = false
                if selectedEmotion == name {
                    selectedEmotion = nil
                } else {
                    selectedEmotion = name
                }
            }
        }
    }
    
    func filteredMoments(from allMoments: [NatureMoment]) -> [NatureMoment] {
        if showOnlyFavorites {
            return allMoments.filter { $0.isFavorite }
        }
        guard let filter = selectedEmotion else { return allMoments }
        return allMoments.filter { $0.feeling.name == filter }
    }
}

struct FilterChipData: Identifiable {
    let id: String
    let title: String
    let icon: String
    let isSelected: Bool
}
