//import SwiftUI
//import SwiftData
//
//@available(iOS 26.0, *)
//struct TaskPreviewView: View {
//    let emotion: Emotion
//    
//    // Fetch directly from our repository instead of query for preview
//    private var task: NatureTask? {
//        NatureTaskRepository.allTasks.first { $0.feelingName == emotion.name }
//    }
//    
//    var body: some View {
//        VStack(spacing: 24) {
//            if let task {
//                
//                // Task Icon & Title
//                VStack(spacing: 12) {
//                    Image(systemName: task.icon)
//                        .font(.system(size: 56, weight: .medium))
//                        .foregroundStyle(.tint)
//                    
//                    Text(task.title)
//                        .font(.title2.bold())
//                }
//                .padding(.top, 10)
//
//                // The Three Steps
//                VStack(alignment: .leading, spacing: 24) {
//                    StepView(stepNumber: 1, title: "Find", desc: task.findPrompt, icon: "magnifyingglass")
//                    StepView(stepNumber: 2, title: "Capture", desc: "Take a photo of the object", icon: "camera.fill")
//                    StepView(stepNumber: 3, title: "Name", desc: "Give your object a meaningful name", icon: "pencil")
//                }
//                .padding(20)
//                .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 20))
//                
//                Spacer()
//                
//                // Action Button
//                Button(action: {
//                    // Logic to start the camera goes here
//                }) {
//                    Text("Start Journey")
//                        .font(.headline)
//                        .frame(maxWidth: .infinity)
//                }
//                .buttonStyle(.borderedProminent)
//                .controlSize(.large)
//                
//            } else {
//                ContentUnavailableView(
//                    "No Task Found",
//                    systemImage: "exclamationmark.magnifyingglass",
//                    description: Text("We couldn't find a task for \(emotion.name).")
//                )
//            }
//        }
//        .padding()
//        .navigationTitle(emotion.name)
//        .navigationBarTitleDisplayMode(.inline)
//    }
//}
//
//// MARK: - Step View
//struct StepView: View {
//    let stepNumber: Int
//    let title: String
//    let desc: String
//    let icon: String
//    
//    var body: some View {
//        HStack(alignment: .top, spacing: 16) {
//            
//            Image(systemName: "\(stepNumber).circle.fill")
//                .font(.title3)
//                .foregroundStyle(.tint)
//            
//            VStack(alignment: .leading, spacing: 4) {
//                Label(title, systemImage: icon)
//                    .font(.headline)
//                    .foregroundStyle(.primary)
//                
//                Text(desc)
//                    .font(.subheadline)
//                    .foregroundStyle(.secondary)
//                    .fixedSize(horizontal: false, vertical: true)
//            }
//        }
//    }
//}
