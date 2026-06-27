import SwiftUI
import SwiftData

@main
@available(iOS 26.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
struct MyApp: App {
    let container: ModelContainer
    
    init() {
        //Configuring model container for Swift Data
        do {
            let config = ModelConfiguration(
                isStoredInMemoryOnly: false
            )
            container = try ModelContainer(
                for: NatureMoment.self, NatureTask.self,
                configurations: config
            )
        } catch {
            fatalError("Failed to initialize SwiftData container: \(error)")
        }
    }
    @StateObject private var themeManager = ThemeManager()
        
    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(themeManager)
        }
        .modelContainer(container)
    }
}
