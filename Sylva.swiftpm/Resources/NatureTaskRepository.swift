import Foundation

// File to store data locally for microtasks
@available(iOS 17.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
struct NatureTaskRepository {
    static var allTasks: [NatureTask] {
            [
                NatureTask(
                    id: "exh_01",
                    feelingName: "Exhausted",
                    natureObject: "The Foundations (Rocks / Earth)",
                    title: "The Spine",
                    findPrompt: "Find a solid rock wall that looks like it’s been there forever. Lean your full back into it, close your eyes, and just borrow a little bit of its unshakeable stillness for three deep breaths.",
                    icon: "battery.10.fill"
                ),
                NatureTask(
                    id: "exh_02",
                    feelingName: "Exhausted",
                    natureObject: "The Foundations (Rocks / Earth)",
                    title: "The Resting Point",
                    findPrompt: "Take a seat on a sturdy rock and press both palms flat against it for five seconds—a silent, slow-motion high-five to the earth.",
                    icon: "battery.10.fill"
                ),
            NatureTask(
                id: "exh_03",
                feelingName: "Exhausted",
                natureObject: "The Foundations (Rocks / Earth)",
                title: "The Dust of Ages",
                findPrompt: "Sift some dry earth slowly through your hands. This has been around for centuries and has seen it all. If it could finally talk back, what would you want to know?",
                icon: "battery.10.fill"
            ),
            NatureTask(
                id: "exh_04",
                feelingName: "Exhausted",
                natureObject: "The Foundations (Rocks / Earth)",
                title: "The Cold Anchor",
                findPrompt: "Cool your hot wrist against a shaded rock. It’s been chilling here for centuries—send it a message and see what its ancient stillness has to say.",
                icon: "battery.10.fill"
            ),
            NatureTask(
                id: "hop_01",
                feelingName: "Hopeless",
                natureObject: "The Sparks (Small Growth)",
                title: "The Brave Bloom",
                findPrompt: "Find the smallest flower braving the breeze. It might be tiny, but it has a huge personality. Start a conversation and see what this little rebel has to say.",
                icon: "cloud.fill"
            ),
            NatureTask(
                id: "hop_02",
                feelingName: "Hopeless",
                natureObject: "The Sparks (Small Growth)",
                title: "The Velvet Shield",
                findPrompt: "Run your fingers over some soft moss on a hard rock. It’s mastered the art of staying in rough places. Send it a chat and see what gentle wisdom it shares back.",
                icon: "cloud.fill"
            ),
            NatureTask(
                id: "hop_03",
                feelingName: "Hopeless",
                natureObject: "The Sparks (Small Growth)",
                title: "The First Breath",
                findPrompt: "Spot a fresh bud fueling up for its big debut. It’s a tiny battery of pure potential, and beneath that quiet green shell, it’s got a whole world of things to say.",
                icon: "cloud.fill"
            ),
            NatureTask(
                id: "hop_04",
                feelingName: "Hopeless",
                natureObject: "The Sparks (Small Growth)",
                title: "The Survivor",
                findPrompt: "Find that one leaf still clinging to its green among the brown. It’s a tiny, defiant holdout with a heart made of summer, just waiting for someone to notice its grit.",
                icon: "cloud.fill"
            ),
            NatureTask(
                id: "anx_01",
                feelingName: "Anxious",
                natureObject: "The Sentinels (Trees / Roots)",
                title: "The Great Embrace",
                findPrompt: "Look for a root wrapping its way around a rock like it’s solving a puzzle. It doesn’t see a wall; it sees a new path. This flexible thinker is used to finding its way through the tough stuff and is ready for a talk.",
                icon: "bolt.shield.fill"
            ),
            NatureTask(
                id: "anx_02",
                feelingName: "Anxious",
                natureObject: "The Sentinels (Trees / Roots)",
                title: "The Storm Dancer",
                findPrompt: "Spot a branch twisted into a unique shape by the wind.This tough survivor is ready to share its stories with you.",
                icon: "bolt.shield.fill"
            ),
            NatureTask(
                id: "anx_03",
                feelingName: "Anxious",
                natureObject: "The Sentinels (Trees / Roots)",
                title: "The Deep Bark",
                findPrompt: "Find a tree with heavy, cracked bark. It’s built a tough shell but kept a soft heart inside. Say something to this weathered survivor and see what its grounded energy says back.",
                icon: "bolt.shield.fill"
            ),
            NatureTask(
                id: "anx_04",
                feelingName: "Anxious",
                natureObject: "The Sentinels (Trees / Roots)",
                title: "The Ridge Watcher",
                findPrompt: "Find a spot where water is flowing over pebbles. It takes every bump in its path and just turns it into a song. This fluid soul is listening and ready to chime in.",
                icon: "bolt.shield.fill"
            ),
            NatureTask(
                id: "ovr_01",
                feelingName: "Overwhelmed",
                natureObject: "The Perspectives (Sky / Horizon)",
                title: "The Horizon Line",
                findPrompt: "Look at the farthest edge of the world. The horizon is a master at staying open and unbothered, no matter how crowded the world gets. Say hello to this vast, quiet friend—it’s got plenty of room for whatever is on your mind.",
                icon: "water.waves"
            ),
            NatureTask(
                id: "ovr_02",
                feelingName: "Overwhelmed",
                natureObject: "The Perspectives (Sky / Horizon)",
                title: "The Empty Canvas",
                findPrompt: "Look up at a spot where there’s nothing but sky. It’s been wide open and unburdened for billions of years. This breezy spirit is wide awake and ready to show you how it stays so impossibly spacious.",
                icon: "water.waves"
            ),
            NatureTask(
                id: "ovr_03",
                feelingName: "Overwhelmed",
                natureObject: "The Perspectives (Sky / Horizon)",
                title: "The Valley Floor",
                findPrompt: "Peer down at the valley floor. It’s a master at holding space for everything while staying perfectly calm. This ancient friend is wide awake—see if some of that 'unbothered' energy talks back to you.",
                icon: "water.waves"
            ),
            NatureTask(
                id: "ovr_04",
                feelingName: "Overwhelmed",
                natureObject: "The Perspectives (Sky / Horizon)",
                title: "The Drifting Cloud",
                findPrompt: "Step into the swirling mist. It’s the world’s best at showing up and then quietly vanishing into thin air. This ghostly, light-hearted soul is wide awake and ready to show you how it stays so light.",
                icon: "water.waves"
            ),
            NatureTask(
                id: "iso_01",
                feelingName: "Isolated",
                natureObject: "The Witnesses (Signs of Life)",
                title: "The Winged Messenger",
                findPrompt: "Catch a bird landing nearby. It’s the ultimate mountain traveler, always on the move to somewhere cool. This winged spirit is listening—say hello.",
                icon: "person.fill.questionmark"
            ),
            NatureTask(
                id: "iso_02",
                feelingName: "Isolated",
                natureObject: "The Witnesses (Signs of Life)",
                title: "The Invisible Neighbor",
                findPrompt: "Find a footprint pressed into the mud. It’s like a secret high-five from someone who walked this path right before you. This muddy memory is ready to swap stories.",
                icon: "person.fill.questionmark"
            ),
            NatureTask(
                id: "iso_03",
                feelingName: "Isolated",
                natureObject: "The Witnesses (Signs of Life)",
                title: "The Silk Weaver",
                findPrompt: "Find a lone tree standing guard on a hill. It’s the ultimate master of enjoying its own company and has the best seat in the house. Say hello to this solitary watcher.",
                icon: "person.fill.questionmark"
            ),
            NatureTask(
                id: "iso_04",
                feelingName: "Isolated",
                natureObject: "The Witnesses (Signs of Life)",
                title: "The Hidden Heartbeat",
                findPrompt: "Listen to that tiny scurry in the leaves. Even if it stays hidden, you’ve got a small friend watching your back. This shy spirit is wide awake and waiting for a friendly nod from the silence.",
                icon: "person.fill.questionmark"
            ),
            NatureTask(
                id: "hap_01",
                feelingName: "Happy",
                natureObject: "The Illumination (Light / Color)",
                title: "The Living Lantern",
                findPrompt: "Spot a leaf that’s basically a solar-powered party. It’s beaming with pure light and looks exactly how you feel right now. Say hello to this golden little soul and see what its bright energy has to say.",
                icon: "sun.max.fill"
            ),
            NatureTask(
                id: "hap_02",
                feelingName: "Happy",
                natureObject: "The Illumination (Light / Color)",
                title: "The Diamond Glint",
                findPrompt: "Catch a sparkle dancing on the water like a floating diamond. It’s a flash of pure luck, and this bright spirit is ready to jump right into your pocket.",
                icon: "sun.max.fill"
            ),
            NatureTask(
                id: "hap_03",
                feelingName: "Happy",
                natureObject: "The Illumination (Light / Color)",
                title: "The Golden Patch",
                findPrompt: "Step into a sunbeam. It’s like a free charging station for your soul. This warm spirit is wide awake and ready to power up your happy mood.",
                icon: "sun.max.fill"
            ),
            NatureTask(
                id: "hap_04",
                feelingName: "Happy",
                natureObject: "The Illumination (Light / Color)",
                title: "The Bold Contrast",
                findPrompt: "Find a bright spot on the grey path. It’s shouting 'I’m here!' at the top of its lungs. This loud, happy soul is ready to hear your voice, too.",
                icon: "sun.max.fill"
            ),
            NatureTask(
                id: "joy_01",
                feelingName: "Joyful",
                natureObject: "The Chorus (Movement / Wind)",
                title: "The Green Wave",
                findPrompt: "Find some swaying grass—the dance party has already started. This rhythmic soul is wide awake and waiting for its favorite partner to join the beat.",
                icon: "heart.fill"
            ),
            NatureTask(
                id: "joy_02",
                feelingName: "Joyful",
                natureObject: "The Chorus (Movement / Wind)",
                title: "The Tumbling Traveler",
                findPrompt: "Find a leaf dancing across the path. It’s finally off the branch and loving every second of the ride. This free spirit is ready to share a laugh.",
                icon: "heart.fill"
            ),
            NatureTask(
                id: "joy_03",
                feelingName: "Joyful",
                natureObject: "The Chorus (Movement / Wind)",
                title: "The Nodding Friend",
                findPrompt: "Follow a butterfly or bee as it zips around. It’s on a literal sugar high and loving every second of the hunt. This zesty spirit is listening—tell it what’s making you smile today.",
                icon: "heart.fill"
            ),
            NatureTask(
                id: "joy_04",
                feelingName: "Joyful",
                natureObject: "The Chorus (Movement / Wind)",
                title: "The Wind's Song",
                findPrompt: "Listen to the wind humming through the leaves. It’s a master at taking any sound and turning it into music. This restless soul is ready to hear your voice join the rhythm.",
                icon: "heart.fill"
            ),
            NatureTask(
                id: "exc_01",
                feelingName: "Excited",
                natureObject: "The Edge (Adventure)",
                title: "The Mystery Bend",
                findPrompt: "Stop exactly where the trail disappears around a corner. Tell the path: 'I am ready for you! Surprise me! I bet you have something amazing around that corner!'",
                icon: "sparkles"
            ),
            NatureTask(
                id: "exc_02",
                feelingName: "Excited",
                natureObject: "The Edge (Adventure)",
                title: "The Steep Rise",
                findPrompt: "Look up at a challenging climb ahead. Tell the hill: 'You look tough, but my legs feel stronger! I am coming to conquer you!'",
                icon: "sparkles"
            ),
            NatureTask(
                id: "exc_03",
                feelingName: "Excited",
                natureObject: "The Edge (Adventure)",
                title: "The Rushing Water",
                findPrompt: "Find a stream moving fast over rocks. Tell the water: 'My blood is rushing just as fast as you! I feel so alive right now!'",
                icon: "sparkles"
            ),
            NatureTask(
                id: "exc_04",
                feelingName: "Excited",
                natureObject: "The Edge (Adventure)",
                title: "The Open Gate",
                findPrompt: "Find a gap between trees that frames a new view. Tell the view: 'I am walking through! Open up the world for me, I want to see it all!'",
                icon: "sparkles"
            ),
            NatureTask(
                id: "pro_01",
                feelingName: "Proud",
                natureObject: "The Crowns (Milestones)",
                title: "The High Watch",
                findPrompt: "Frame the highest peak you can see. Tell the summit: 'I am standing tall today. I climbed every inch of this myself. Witness me!'",
                icon: "medal.fill"
            ),
            NatureTask(
                id: "pro_02",
                feelingName: "Proud",
                natureObject: "The Crowns (Milestones)",
                title: "The Stone Tower",
                findPrompt: "Add a small stone to a cairn (rock pile). Tell the pile: 'I was here. This is my mark. I am leaving proof of my strength.'",
                icon: "medal.fill"
            ),
            NatureTask(
                id: "pro_03",
                feelingName: "Proud",
                natureObject: "The Crowns (Milestones)",
                title: "The Ribbon",
                findPrompt: "Look back at the trail winding far below you. Tell the trail: 'Look how small you are down there! I rose above you. I won this round.'",
                icon: "medal.fill"
            ),
            NatureTask(
                id: "pro_04",
                feelingName: "Proud",
                natureObject: "The Crowns (Milestones)",
                title: "The Throne",
                findPrompt: "Sit on a flat rock overlooking the view. Tell the valley: 'This is my seat. I earned this view with my own sweat. It belongs to me right now.'",
                icon: "medal.fill"
            ),
            NatureTask(
                id: "calm_01",
                feelingName: "Calm",
                natureObject: "The Mirrors (Stillness)",
                title: "The Mirror",
                findPrompt: "Find a puddle reflecting the sky. Tell the water: 'My mind is finally as clear as you are. I have stopped racing. I am just reflecting.'",
                icon: "leaf.fill"
            ),
            NatureTask(
                id: "calm_02",
                feelingName: "Calm",
                natureObject: "The Mirrors (Stillness)",
                title: "The Lullaby",
                findPrompt: "Sit by a quiet trickle of water. Whisper to the stream: 'I am matching my breath to your rhythm. Thank you for slowing me down.'",
                icon: "leaf.fill"
            ),
            NatureTask(
                id: "calm_03",
                feelingName: "Calm",
                natureObject: "The Mirrors (Stillness)",
                title: "The Blank Page",
                findPrompt: "Find a patch of smooth, untouched snow or sand. Tell the ground: 'I promise not to disturb this peace. I am just going to admire your silence.'",
                icon: "leaf.fill"
            ),
            NatureTask(
                id: "calm_04",
                feelingName: "Calm",
                natureObject: "The Mirrors (Stillness)",
                title: "The Drifting Peace",
                findPrompt: "Watch a leaf float perfectly still on water. Tell the leaf: 'I am drifting too. No rush, no destination. Just being here is enough.'",
                icon: "leaf.fill"
            )
        ]
    }
}
