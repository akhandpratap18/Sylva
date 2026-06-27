import SwiftUI

@available(iOS 26.0, *)
struct SettingsView: View {
    @AppStorage("isDarkMode") private var isDarkMode = false
    @EnvironmentObject var themeManager: ThemeManager
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Appearance")) {
                    Toggle("Dark Mode", isOn: $isDarkMode)
                        .tint(themeManager.currentTheme.primaryColor)
                        .accessibilityHint("Switches the app between light and dark visual modes.") // 👈 Added context for the toggle
                        .accessibilityLabel("Dark Mode")
                    
                    Picker("Theme", selection: $themeManager.currentTheme) {
                        ForEach(AppTheme.allCases) { theme in
                            Text(theme.displayName).tag(theme)
                        }
                    }
                    .tint(themeManager.currentTheme.primaryColor)
                    .accessibilityHint("Chooses the color theme of the app.") //Added context for the picker
                    .accessibilityLabel("Theme")
                }
                
                // Updated Accessibility Section
                Section(
                    header: Text("Accessibility"),
                    footer: Text("This app automatically supports native iOS accessibility features like VoiceOver.")
                ) {
                    HStack {
                        Image(systemName: "accessibility")
                            .foregroundColor(themeManager.currentTheme.primaryColor)
                            .accessibilityHidden(true) //Hides the decorative icon from VoiceOver
                        Text("Native Accessibility Supported")
                    }
                    .accessibilityElement(children: .combine) //Reads the entire row as one cohesive element
                    .accessibilityLabel("Native Accessibility Supported")
                }
                
                Section(header: Text("About")) {
                    HStack {
                        Text("Version")
                        Spacer()
                        Text("SSC'26").foregroundColor(.secondary)
                    }
                    .accessibilityElement(children: .combine) // Reads "Version SSC'26" cleanly together
                }
            }
            .navigationTitle("Settings")
        }
    }
}
