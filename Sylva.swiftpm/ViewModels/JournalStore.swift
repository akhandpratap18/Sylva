import SwiftUI
import SwiftData
import Foundation

// Took the help of AI tool to fix this file as I wanted some data to be seeded into local storage of any device this runs into.
//This is to save the memory you just created with a nature object for your reflections tab
@MainActor
@available(iOS 26.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
class JournalStore: ObservableObject {
    static let emotions: [Emotion] = [
        Emotion(name: "Happy", icon: "sun.max.fill"),
        Emotion(name: "Joyful", icon: "party.popper.fill"),
        Emotion(name: "Excited", icon: "sparkles"),
        Emotion(name: "Proud", icon: "medal.fill"),
        Emotion(name: "Calm", icon: "leaf.fill"),
        Emotion(name: "Exhausted", icon: "powersleep"),
        Emotion(name: "Hopeless", icon: "cloud.fill"),
        Emotion(name: "Anxious", icon: "bolt.shield.fill"),
        Emotion(name: "Overwhelmed", icon: "water.waves"),
        Emotion(name: "Isolated", icon: "person.fill.questionmark")
    ]
    
    var memoryWeaver = MemoryWeaverService()
    
    func seedNatureTasks(context: ModelContext) {
        do {
            let descriptor = FetchDescriptor<NatureTask>()
            let existingTasks = try context.fetch(descriptor)
            
            if existingTasks.count > 0 {
                // If the database is already seeded, check if we need to migrate old emotion names
                var needsUpdate = false
                for task in existingTasks {
                    if task.feelingName == "Joy" {
                        task.feelingName = "Joyful"
                        needsUpdate = true
                    } else if task.feelingName == "Low Hope" {
                        task.feelingName = "Hopeless"
                        needsUpdate = true
                    } else if task.feelingName == "Anxiety" {
                        task.feelingName = "Anxious"
                        needsUpdate = true
                    }
                }
                if needsUpdate {
                    try context.save()
                    print("Updated old emotion names in database.")
                }
                return
            }
            
            print("Seeding database...")
            for task in NatureTaskRepository.allTasks {
                context.insert(task)
            }
            
            // Seed the default NatureMoment to showcase entry on gallery view on any device
            let momentDescriptor = FetchDescriptor<NatureMoment>()
            if try context.fetchCount(momentDescriptor) == 0 {
                print("Seeding initial Daisy journal entry...")
                if let daisyImage = UIImage(named: "sample4")?.jpegData(compressionQuality: 0.8) {
                    
                    let daisyExchange = ChatExchange(
                        userPrompt: "Hey Daisy, I feel slight low in hope",
                        response: NatureVoice(
                            start: "Hey there, dear friend.",
                            response: "It's okay to feel low sometimes, like a cloud passing by. But remember, even after rain, flowers bloom brighter. Just like me, you too will find your sunshine again. Hold on, for brighter days are ahead.",
                            example: "Once, in a sun-drenched meadow, I stood tall through a gentle storm. When the skies cleared, my petals shone brighter than ever."
                        )
                    )
                    
                    let daisyMoment = NatureMoment(
                        date: Calendar.current.date(from: DateComponents(year: Calendar.current.component(.year, from: Date()), month: 2, day: 21)) ?? Date(),
                        feeling: Emotion(name: "Hopeless", icon: "cloud.fill"),
                        objectName: "Daisy",
                        conversation: [daisyExchange],
                        imageData: daisyImage,
                        memorySummary: "Hopeful sunshine after gentle rain."
                    )
                    
                    context.insert(daisyMoment)
                }
                
                
                if let bellaImage = UIImage(named: "sample1")?.jpegData(compressionQuality: 0.8) {
                    
                    let bellaExchange1 = ChatExchange(
                        userPrompt: "Hey Bella, what a beautiful day it is",
                        response: NatureVoice(
                            start: "Hello, radiant soul!",
                            response: "What a lovely day to feel so happy! The sun is shining brightly, casting golden rays that make everything feel alive and vibrant. Just like you, it brings warmth and joy wherever it goes. How are you feeling today, dear friend?",
                            example: nil
                        )
                    )
                    
                    let bellaExchange2 = ChatExchange(
                        userPrompt: "Amazing, how do you always keep yourself happy?",
                        response: NatureVoice(
                            start: "I'm happy because I live to spread joy and kindness wherever I can. Just like the sun that rises every morning, bringing light and warmth to the world.",
                            response: "Your happiness is like a gentle breeze that carries warmth and joy to all around. It's a beautiful gift, isn't it? How do you nurture your happiness every day?",
                            example: nil
                        )
                    )
                    
                    let bellaMoment = NatureMoment(
                        date: Calendar.current.date(from: DateComponents(year: Calendar.current.component(.year, from: Date()), month: 2, day: 21, hour: 16, minute: 35)) ?? Date(),
                        feeling: Emotion(name: "Happy", icon: "sun.max.fill"),
                        objectName: "Bella",
                        conversation: [bellaExchange1, bellaExchange2],
                        imageData: bellaImage,
                        memorySummary: "Joyful sunlit warmth, spreading kindness like a gentle breeze."
                    )
                    
                    context.insert(bellaMoment)
                }
            }
            
            try context.save()
            print("Seeding complete.")
        } catch {
            print("Error seeding data: \(error)")
        }
    }

    
    func saveMoment(
        context: ModelContext,
        feeling: Emotion,
        objectName: String,
        conversation: [ChatExchange],
        imageData: Data?
    ) async {
        
        // 1. Generate Summary
        await memoryWeaver.generateSummary(from: conversation)
        let generatedSummary = memoryWeaver.summaryResponse?.summary
        
        if let summary = generatedSummary {
            print("Generated summary: \(summary)")
        }
        
        // 2. Create and Insert Entry
        let entry = NatureMoment(
            feeling: feeling,
            objectName: objectName,
            conversation: conversation,
            imageData: imageData,
            memorySummary: generatedSummary
        )

        context.insert(entry)
        try? context.save()
        memoryWeaver.resetSession()
    }
    
    func toggleFavorite(moment: NatureMoment) {
        moment.isFavorite.toggle()
    }

    func deleteMoment(moment: NatureMoment, context: ModelContext) {
        context.delete(moment)
    }
    
    func getTasks(for feeling: Emotion, context: ModelContext) -> [NatureTask] {
        // Clean the string OUTSIDE the predicate to prevent SwiftData macro crashes
        let selectedName = feeling.name.trimmingCharacters(in: .whitespacesAndNewlines)
        
        let descriptor = FetchDescriptor<NatureTask>(
            predicate: #Predicate { $0.feelingName == selectedName }
        )
        
        do {
            return try context.fetch(descriptor)
        } catch {
            print("Error fetching tasks: \(error)")
            return []
        }
    }
}
