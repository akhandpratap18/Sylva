import SwiftUI
import SwiftData

//This is the RootView managing all the changes to theme, background colors for each tab.
@available(iOS 26.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
struct RootView: View {
    @Environment(\.modelContext) private var modelContext
    @StateObject private var journalStore = JournalStore()
    @EnvironmentObject var themeManager: ThemeManager
    
    @AppStorage("isDarkMode") private var isDarkMode = false
    @State private var showEmotionSheet = false
    @State private var selectedEmotion: Emotion?
    @State private var selectedTab = 0
    
    var body: some View {
        ZStack(alignment: .bottom) {
            TabView(selection: $selectedTab) {
                NavigationStack {
                    homeTab
                }
                .tabItem { Label("Moment", systemImage: "snowflake") }
                .tag(0)

                MemoryGalleryView()
                    .tabItem { Label("Reflections", systemImage: "book.closed.fill") }
                    .tag(1)

                NavigationStack {
                    SettingsView()
                }
                .tabItem { Label("Settings", systemImage: "gear") }
                .tag(2)
            }
            .id("\(themeManager.currentTheme.id)-\(isDarkMode)")

            if selectedEmotion == nil && selectedTab == 0 {
                floatingActionButton
            }
        }

        .accessibilityScrollAction { edge in
            withAnimation {
                if edge == .trailing && selectedTab < 2 {
                    selectedTab += 1
                } else if edge == .leading && selectedTab > 0 {
                    selectedTab -= 1
                }
            }
        }
        .environmentObject(journalStore)
        .sheet(isPresented: $showEmotionSheet) {
            EmotionPickerView { emotion in
                withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                    selectedEmotion = emotion
                }
            }
            .presentationDetents([.medium, .large])
            .presentationDragIndicator(.visible)
        }
        .onAppear {
            journalStore.seedNatureTasks(context: modelContext)
            setupTabBarAppearance(themeColor: themeManager.currentTheme.uiColor)
        }
        .onChange(of: themeManager.currentTheme) { oldTheme, newTheme in
            setupTabBarAppearance(themeColor: newTheme.uiColor)
        }
        .onChange(of: isDarkMode) { oldVal, newVal in
            setupTabBarAppearance(themeColor: themeManager.currentTheme.uiColor)
        }
        .preferredColorScheme(isDarkMode ? .dark : .light)
    }

    var homeTab: some View {
        ZStack(alignment: .top) {
            SanctuaryView()
                .ignoresSafeArea()
                .accessibilityHidden(true)
            
            Text("How are you feeling? Tell your nature companion.")
                            .font(.system(.subheadline, design: .serif))
                            .fontWeight(.medium)
                            .foregroundColor(.primary)
                            .multilineTextAlignment(.center)
                            .padding(.vertical, 12)
                            .padding(.horizontal, 24)
                            .background(.thinMaterial, in: Capsule())
                            .overlay {
                                Capsule()
                                    .stroke(.primary.opacity(0.1), lineWidth: 0.5)
                            }
                            .padding(.top, 40)
                            .padding(.horizontal, 40)
                            .frame(maxWidth: .infinity)
                            .opacity(selectedEmotion == nil ? 1 : 0)
                            .animation(.easeInOut(duration: 0.3), value: selectedEmotion)
                            .accessibilityAddTraits(.isHeader)
                            // Hides the text from VoiceOver when it fades out
                            .accessibilityHidden(selectedEmotion != nil)
            
            if let emotion = selectedEmotion {
                let tasksForMood = journalStore.getTasks(for: emotion, context: modelContext)
                
                NatureCompanionConnectionFlowView(
                    viewModel: NatureCompanionConnectionFlowViewModel(
                        natureTasks: tasksForMood,
                        emotionName: emotion.name,
                        onClose: {
                            withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
                                selectedEmotion = nil
                            }
                        }
                    )
                )
                .transition(.move(edge: .bottom).combined(with: .opacity))
                .zIndex(1)
                .padding(.top, 140)
            }
        }
        .navigationTitle("Moment")
    }

        var floatingActionButton: some View {
            Button {
                showEmotionSheet = true
            } label: {
                ZStack(alignment: .bottomTrailing) {
                    Image(systemName: "face.smiling.fill")
                        .font(.system(size: 26))
                        .accessibilityHidden(true)
                    
                    Image(systemName: "pencil.circle.fill")
                        .font(.system(size: 14))
                        .foregroundColor(.white)
                        .background(Circle().fill(themeManager.currentTheme.primaryColor))
                        .offset(x: 4, y: 4)
                        .accessibilityHidden(true)
                }
                    .foregroundColor(.white)
                    .frame(width: 65, height: 65)
                    .background(themeManager.currentTheme.primaryColor)
                    .clipShape(Circle())
                    .shadow(radius: 6)
            }
            .padding(.bottom, 70)
            .transition(.scale)
            .accessibilityAddTraits(.isButton)
            // Kept the label, but made the hint result-oriented per Apple HIG
            .accessibilityLabel("Start Conversation")
            .accessibilityHint("Opens the emotion picker.")
            // Ensures users with massive text sizes can still see what this button does
            .accessibilityShowsLargeContentViewer {
                Label("Start Conversation", systemImage: "face.smiling.fill")
            }
            .accessibilityIdentifier("start_conversation_fab")
        }

    func setupTabBarAppearance(themeColor: UIColor) {
        let appearance = UITabBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundColor = .clear
        appearance.backgroundEffect = nil
        appearance.shadowImage = UIImage()
        appearance.shadowColor = .clear
        
        appearance.selectionIndicatorTintColor = themeColor.withAlphaComponent(0.3)
        
        appearance.stackedLayoutAppearance.selected.iconColor = themeColor
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: themeColor]
        
        // Dynamically choose the unselected color based on your mode
        let unselectedColor = isDarkMode ? UIColor.white : UIColor.black
        
        appearance.stackedLayoutAppearance.normal.iconColor = unselectedColor
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [.foregroundColor: unselectedColor]
        
        appearance.stackedLayoutAppearance.normal.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: 4)
        appearance.stackedLayoutAppearance.selected.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: 4)
        
        UITabBar.appearance().itemPositioning = .centered
        UITabBar.appearance().itemSpacing = 20
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }
}
