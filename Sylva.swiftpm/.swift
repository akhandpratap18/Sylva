import SwiftUI
import SwiftData

// MARK: - 1. The Feeling Enum (Updated with your specific list)
enum Feeling: String, CaseIterable, Codable {
    // Negative / Difficult
    case exhaustion = "Exhaustion / Tired"
    case lowHope = "Low Hope / Fragile"
    case anxiety = "Anxiety / Stuck"
    case overwhelmed = "Overwhelmed"
    case isolated = "Isolated"
    
    // Positive / Uplifting
    case happy = "Happy"
    case joy = "Joy"
    case excited = "Excited"
    case proud = "Proud"
    case calm = "Calm / Gratitude"
    
    // UI Helpers: Icons & Colors
    var icon: String {
        switch self {
        case .exhaustion: return "bed.double.fill"
        case .lowHope: return "cloud.drizzle.fill"
        case .anxiety: return "tornado"
        case .overwhelmed: return "smoke.fill"
        case .isolated: return "person.fill.questionmark"
        case .happy: return "sun.max.fill"
        case .joy: return "wind"
        case .excited: return "figure.run"
        case .proud: return "crown.fill"
        case .calm: return "drop.fill"
        }
    }
    
    var color: Color {
        switch self {
        case .exhaustion: return .gray
        case .lowHope: return .indigo
        case .anxiety: return .purple
        case .overwhelmed: return .orange
        case .isolated: return .brown
        case .happy: return .yellow
        case .joy: return .mint
        case .excited: return .red
        case .proud: return .gold // Custom gold (defined below) or use .orange
        case .calm: return .teal
        }
    }
}

// Extension for custom colors if needed
extension Color {
    static let gold = Color(red: 1.0, green: 0.84, blue: 0.0)
}

// MARK: - 2. The Content Structure
// This defines what a "Journey Card" looks like// MARK: - 2. The Content Structure (UPDATED for Fallbacks)
struct JourneyContent {
    // We now have a PRIMARY option and ALTERNATIVE options
    struct NatureOption {
        let name: String // e.g., "A Rock"
        let microtasks: [String] // Tasks specific to this object
    }
    
    let options: [NatureOption] // List of objects to find (Primary + Fallbacks)
    let conversationBridges: [String] // These usually work for any object in the category
}

// MARK: - 3. The Data Source (UPDATED)
extension Feeling {
    var content: JourneyContent {
        switch self {
        case .exhaustion:
            return JourneyContent(
                options: [
                    .init(name: "A Rock or Stone Wall", microtasks: [
                        "The Stone Spine: Lean your full back against it.",
                        "The Cold Anchor: Press your hot forehead against the cool surface.",
                        "The Resting Point: Sit on it and place hands flat on the rough surface."
                    ]),
                    .init(name: "The Earth / Ground", microtasks: [
                        "The Dust of Ages: Sift dry earth or pebbles slowly through your fingers.",
                        "The Grounding: Take off one shoe and press your foot into the dirt.",
                        "The Gravity: Lie flat or sit and feel the earth holding your weight."
                    ]),
                    .init(name: "A Large Tree Trunk", microtasks: [
                        "The Spine Support: Lean back against the sturdy bark.",
                        "The Root Seat: Sit between the roots like a chair."
                    ])
                ],
                conversationBridges: [
                    "Ask it: 'You carry weight every day. How do you hold it without crumbling?'",
                    "Ask it: 'Teach my body how to be as still and heavy as you are right now.'",
                    "Ask it: 'Can you show me how to slow down?'"
                ]
            )
            
        case .lowHope:
            return JourneyContent(
                options: [
                    .init(name: "A Small Flower", microtasks: [
                        "The Brave Bloom: Find the smallest flower surviving in the wind.",
                        "The Color Spot: Focus entirely on the center color of the bloom."
                    ]),
                    .init(name: "Moss or Lichen", microtasks: [
                        "The Velvet Shield: Touch soft moss growing on a hard surface.",
                        "The Micro-Forest: Look continuously closely at the tiny textures."
                    ]),
                    .init(name: "A Green Leaf", microtasks: [
                        "The Survivor: Find one green leaf among brown, fallen ones.",
                        "The First Breath: Find a tiny green bud just starting to open."
                    ])
                ],
                conversationBridges: [
                    "Ask it: 'I feel like I'm fading. How do you keep your color so bright?'",
                    "Ask it: 'The world feels hard today. How do you stay so soft?'",
                    "Ask it: 'Where do you find the strength to keep growing?'"
                ]
            )
            
        case .anxiety:
            return JourneyContent(
                options: [
                    .init(name: "Tree Roots", microtasks: [
                        "The Great Embrace: Find roots wrapping around a rock.",
                        "The Deep Grip: Trace where the root enters the ground."
                    ]),
                    .init(name: "A Twisted Branch", microtasks: [
                        "The Storm Dancer: Find a branch twisted by the wind.",
                        "The Knot: Press your thumb into a knot in the wood."
                    ]),
                    .init(name: "Rough Bark", microtasks: [
                        "The Deep Map: Trace the deepest cracks in the trunk.",
                        "The Friction: Rub your palm specifically against the texture."
                    ])
                ],
                conversationBridges: [
                    "Ask it: 'How did you learn to grow around obstacles instead of fighting them?'",
                    "Ask it: 'My thoughts are twisting. How do you stay standing when the wind pulls?'",
                    "Ask it: 'How did you build such thick skin to protect yourself?'"
                ]
            )
            
        case .overwhelmed:
            return JourneyContent(
                options: [
                    .init(name: "The Horizon Line", microtasks: [
                        "The Trace: Trace the exact line where land meets sky.",
                        "The Distance: Find the absolutely farthest thing you can see."
                    ]),
                    .init(name: "The Sky", microtasks: [
                        "The Empty Canvas: Find a patch of blue with zero clouds.",
                        "The Deep Breath: Look up and match your breath to the openness."
                    ]),
                    .init(name: "A Single Cloud", microtasks: [
                        "The Drifter: Lock eyes on one cloud until it changes shape.",
                        "The Release: Imagine putting your worry on the cloud and watching it float off."
                    ])
                ],
                conversationBridges: [
                    "Ask it: 'My head is crowded. How do you stretch so far without running out of room?'",
                    "Ask it: 'Can you teach me how to be empty and open like you?'",
                    "Ask it: 'How do I learn to just let things drift by?'"
                ]
            )
            
        case .isolated:
            return JourneyContent(
                options: [
                    .init(name: "A Bird", microtasks: [
                        "The Messenger: Wait for a bird to fly across your path.",
                        "The Song: Close your eyes and locate exactly where the bird is singing."
                    ]),
                    .init(name: "An Insect / Web", microtasks: [
                        "The Silk Weaver: Watch a spider or bug working on a leaf.",
                        "The Busy Worker: Watch an ant carrying something."
                    ]),
                    .init(name: "Footprints", microtasks: [
                        "The Invisible Neighbor: Find a track (paw/boot) in the mud.",
                        "The Trail: Look for bent grass where someone walked."
                    ])
                ],
                conversationBridges: [
                    "Ask it: 'I feel like no one sees me. Where are you going?'",
                    "Ask it: 'Who were you? Tell me I am not the only one walking this road.'",
                    "Ask it: 'I know you are hiding, but I hear you. Can we just sit together?'"
                ]
            )
            
        case .happy:
            return JourneyContent(
                options: [
                    .init(name: "Sunlight on Leaves", microtasks: [
                        "The Living Lantern: Find a leaf backlit by sun so it glows.",
                        "The Translucence: Look at the veins glowing inside the leaf."
                    ]),
                    .init(name: "Sparkling Water/Stone", microtasks: [
                        "The Diamond Glint: Catch the sparkle of light on wet stone or water.",
                        "The Flash: Move your head until you catch the brightest reflection."
                    ]),
                    .init(name: "A Bright Color", microtasks: [
                        "The Pop: Find a bright color standing out against grey surroundings.",
                        "The Match: Find something that matches the color of your shirt."
                    ])
                ],
                conversationBridges: [
                    "Tell it: 'I feel just as bright inside as you look right now!'",
                    "Tell it: 'I am soaking this up. Thank you for matching my energy.'",
                    "Tell it: 'We are both here to be seen today!'"
                ]
            )
            
        case .joy:
            return JourneyContent(
                options: [
                    .init(name: "Moving Grass/Flower", microtasks: [
                        "The Green Wave: Watch tall grass swaying in the breeze.",
                        "The Dance: Mimic the swaying motion with your hand."
                    ]),
                    .init(name: "A Blowing Leaf", microtasks: [
                        "The Traveler: Watch a leaf blowing freely across the ground.",
                        "The Chase: Follow the leaf with your eyes as far as you can."
                    ]),
                    .init(name: "Sound of Wind", microtasks: [
                        "The Mountain’s Song: Record the sound of wind in the trees.",
                        "The Whoosh: Close eyes and feel the wind pass your ears."
                    ])
                ],
                conversationBridges: [
                    "Tell it: 'I feel like dancing today too!'",
                    "Tell it: 'I feel just as free as you! Let's see where the wind goes.'",
                    "Tell it: 'Here is my song! Add my voice to the choir!'"
                ]
            )
            
        case .excited:
            return JourneyContent(
                options: [
                    .init(name: "A Bend in the Path", microtasks: [
                        "The Mystery: Stop exactly where the trail disappears.",
                        "The Guess: Imagine what is around the corner before you turn."
                    ]),
                    .init(name: "Running Water", microtasks: [
                        "The Rush: Find a stream moving fast over rocks.",
                        "The Race: Drop a leaf in and watch how fast it goes."
                    ]),
                    .init(name: "A Steep Hill", microtasks: [
                        "The Rise: Look up at a climb ahead.",
                        "The Charge: Run or walk briskly up a short section."
                    ])
                ],
                conversationBridges: [
                    "Tell it: 'I am ready for you! Surprise me!'",
                    "Tell it: 'My blood is rushing just as fast as you!'",
                    "Tell it: 'I am coming to conquer you!'"
                ]
            )
            
        case .proud:
            return JourneyContent(
                options: [
                    .init(name: "A High Peak", microtasks: [
                        "The High Watch: Frame the highest point you can see.",
                        "The Scale: Compare your hand size to the mountain."
                    ]),
                    .init(name: "A Rock Pile (Cairn)", microtasks: [
                        "The Tower: Add a small stone to a pile.",
                        "The Mark: Create a small arrow on the ground pointing your way."
                    ]),
                    .init(name: "The View Behind", microtasks: [
                        "The Ribbon: Look back at the trail winding below you.",
                        "The Distance: Point to where you started."
                    ])
                ],
                conversationBridges: [
                    "Tell it: 'I am standing tall today. Witness me!'",
                    "Tell it: 'I was here. This is my mark.'",
                    "Tell it: 'Look how small the start is. I rose above it.'"
                ]
            )
            
        case .calm:
            return JourneyContent(
                options: [
                    .init(name: "Still Water", microtasks: [
                        "The Mirror: Find a puddle reflecting the sky.",
                        "The Surface: Watch for ripples or total stillness."
                    ]),
                    .init(name: "Smooth Snow/Sand", microtasks: [
                        "The Blank Page: Find a patch of untouched ground.",
                        "The Palm: Place your palm flat on the smooth surface."
                    ]),
                    .init(name: "A Floating Leaf", microtasks: [
                        "The Drifter: Watch a leaf float perfectly still.",
                        "The Breath: Blow gently on it to see it move."
                    ])
                ],
                conversationBridges: [
                    "Tell it: 'My mind is finally as clear as you are.'",
                    "Tell it: 'I promise not to disturb this peace.'",
                    "Tell it: 'No rush, no destination. Just being here is enough.'"
                ]
            )
        }
    }
}

@Model
class JourneyEntry {
    var date: Date
    var feeling: Feeling
    var note: String // Optional user notes
    
    // We can also store WHICH specific microtask they chose to do, if you want
    var selectedTaskIndex: Int?
    
    init(date: Date = Date(), feeling: Feeling, note: String = "", selectedTaskIndex: Int? = nil) {
        self.date = date
        self.feeling = feeling
        self.note = note
        self.selectedTaskIndex = selectedTaskIndex
    }
}
