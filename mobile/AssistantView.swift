import SwiftUI

// MARK: - ViewModel
// Demonstrates MVVM pattern and Reactive handling of AI state
class AssistantViewModel: ObservableObject {
    @Published var isListening = false
    @Published var aiResponse = ""
    @Published var assistantStatus = "Idle"
    
    // Logic for interacting with the Node.js backend
    func processVoiceCommand() {
        self.isListening = true
        self.assistantStatus = "Thinking..."
        
        // Simulating an asynchronous AI stream from your Node.js server
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.aiResponse = "Command processed. I have updated the Unity 3D state to 'Happy'."
            self.assistantStatus = "Ready"
            self.isListening = false
            
            // Critical Bridge Call: This sends data from SwiftUI to the Unity Engine
            self.updateUnityState(intent: "HAPPY")
        }
    }
    
    private func updateUnityState(intent: String) {
        // In a live app, this calls UnityFramework.getInstance().sendMessageToGO(...)
        print("Architectural Bridge: Sending intent '\(intent)' to Unity Engine.")
    }
}

// MARK: - View
struct AssistantView: View {
    @StateObject private var viewModel = AssistantViewModel()
    
    var body: some View {
        ZStack {
            // Background Layer: Reserved for the Unity 3D rendering engine
            Color.black.ignoresSafeArea()
            
            VStack {
                Text("Unity 3D Context Active")
                    .font(.caption2)
                    .foregroundColor(.green)
                    .padding(6)
                    .background(Color.green.opacity(0.1))
                    .cornerRadius(4)
                    .padding(.top, 10)
                Spacer()
            }
            
            // UI Overlay
            VStack(spacing: 20) {
                Spacer()
                
                // AI Feedback Card
                VStack(alignment: .leading, spacing: 8) {
                    Text(viewModel.assistantStatus.uppercased())
                        .font(.system(size: 10, weight: .black))
                        .foregroundColor(.blue)
                    
                    Text(viewModel.aiResponse.isEmpty ? "Ready for voice command..." : viewModel.aiResponse)
                        .font(.callout)
                        .foregroundColor(.white)
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(.ultraThinMaterial) // High-end glassmorphism effect
                .cornerRadius(16)
                .padding(.horizontal)
                
                // Voice Activation Button
                Button(action: { viewModel.processVoiceCommand() }) {
                    Circle()
                        .fill(viewModel.isListening ? .red : .blue)
                        .frame(width: 72, height: 72)
                        .overlay(
                            Image(systemName: viewModel.isListening ? "waveform" : "mic.fill")
                                .foregroundColor(.white)
                                .font(.title2)
                        )
                        .shadow(color: (viewModel.isListening ? .red : .blue).opacity(0.5), radius: 15)
                }
                .padding(.bottom, 40)
            }
        }
    }
}
