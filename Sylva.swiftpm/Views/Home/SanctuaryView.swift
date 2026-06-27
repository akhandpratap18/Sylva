import SwiftUI

@available(iOS 26.0, *)
struct SanctuaryView: View {
    @EnvironmentObject var themeManager: ThemeManager
    
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    
    var body: some View {
        ZStack {
            GeometryReader { geo in
                Image(themeManager.currentTheme.backgroundImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: geo.size.width, height: geo.size.height, alignment: themeManager.currentTheme.imageAlignment)
                    .scaleEffect(themeManager.currentTheme.imageScale)
                    .offset(themeManager.currentTheme.imageOffset)
                    .clipped()
            }
            .ignoresSafeArea()
            
            if !reduceMotion {
                SnowfallView()
                    .ignoresSafeArea()
            }
        }
        .accessibilityHidden(true)
    }
}
