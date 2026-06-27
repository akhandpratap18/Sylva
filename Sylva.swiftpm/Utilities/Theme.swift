import SwiftUI

// This is implemented to adjusted the theme of the app according to the background selected and mode(light/dark)
extension Color {
    static let mountainIndigo = Color(red: 0.28, green: 0.35, blue: 0.55)
    static let sakuraPink = Color(red: 0.9, green: 0.45, blue: 0.55)
    static let themeBlue = Color(red: 0.35, green: 0.55, blue: 0.9)
    static let mapleOrangeBrown = Color(red: 0.85, green: 0.45, blue: 0.20)
}

extension UIColor {
    static let sakuraPink = UIColor(red: 0.9, green: 0.45, blue: 0.55, alpha: 1.0)
    static let mapleOrangeBrown = UIColor(red: 0.85, green: 0.45, blue: 0.20, alpha: 1.0)
}


enum AppTheme: String, CaseIterable, Identifiable {
    case cherryBlossom, snowyMountains, autumnFox
    
    var id: String { rawValue }
    
    //Computed property for displaying the name in settings
    var displayName: String {
        switch self {
        case .cherryBlossom: return "Cherry Blossom"
        case .snowyMountains: return "Snowy Mountains"
        case .autumnFox: return "Autumn Fox"
        }
    }
    
    //Computed property for choosing theme color based on selected theme
    var primaryColor: Color {
        switch self {
        case .cherryBlossom: return .sakuraPink
        case .snowyMountains: return .themeBlue
        case .autumnFox: return .mapleOrangeBrown
        }
    }
    
    var uiColor: UIColor {
        switch self {
        case .cherryBlossom: return .sakuraPink
        case .snowyMountains: return UIColor(red: 0.35, green: 0.55, blue: 0.9, alpha: 1.0)
        case .autumnFox: return .mapleOrangeBrown
        }
    }
    
    //Computed property for displaying the image in background
    var backgroundImage: String {
        switch self {
        case .cherryBlossom: return "backgroundImage3"
        case .snowyMountains: return "backgroundImage2"
        case .autumnFox: return "backgroundImage4"
        }
    }
    
    //Computed property for aligning image
    var imageAlignment: Alignment {
        switch self {
        case .cherryBlossom: return .leading
        case .snowyMountains: return .center
        case .autumnFox: return .bottomTrailing
        }
    }
    
    //Computed property for zoom
    var imageScale: CGFloat {
        switch self {
        case .cherryBlossom: return 1.1
        case .snowyMountains: return 1.3
        case .autumnFox: return 1.04
        }
    }
    
    //Computed property for displaying the exact view from the image
    var imageOffset: CGSize {
        switch self {
        case .cherryBlossom: return CGSize(width: -30, height: 15)
        case .snowyMountains: return CGSize(width: -500, height: 10)
        // Nudge the image left (-x) or right (+x) to frame the fox perfectly
        case .autumnFox: return CGSize(width: 220, height:15)
        }
    }
}

// Helps switch between themes
@available(iOS 17.0, *)
class ThemeManager: ObservableObject {
    @AppStorage("selectedTheme") private var storedTheme: String = AppTheme.cherryBlossom.rawValue
    
    @Published var currentTheme: AppTheme {
        didSet {
            storedTheme = currentTheme.rawValue
        }
    }
    
    init() {
        self.currentTheme = AppTheme(rawValue: UserDefaults.standard.string(forKey: "selectedTheme") ?? AppTheme.cherryBlossom.rawValue) ?? .cherryBlossom
    }
}

