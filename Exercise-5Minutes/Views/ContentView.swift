import SwiftUI

// Import ExerciseManager

// MARK: - Views
struct ContentView: View {
    // MARK: - State
    @State private var isCountingDown = false
    @State private var countdownSeconds = 5
    @State private var timer: Timer?
    @State private var isWorkoutStarted = false
    @StateObject private var exerciseManager = ExerciseManager.shared
    
    // Force start from Day 1 for now
    @State private var currentDay: Int = 1  // Hardcode to Day 1
    
    // MARK: - Sample Exercises
    var exercises: [Exercise] {
        exerciseManager.getCurrentDayExercises()
    }
    
    // Helper to get day title
    private func getDayTitle() -> String {
        switch currentDay {
        case 1: return "Chest, Triceps, Abs"  // Monday
        case 2: return "Back, Biceps, Abs"    // Tuesday
        case 3: return "Legs, Abs"            // Wednesday
        case 4: return "Shoulders, Abs"        // Thursday
        case 5: return "HIIT, Abs"            // Friday
        case 6: return "Yoga"                 // Saturday
        case 7: return "Rest-Walk"            // Sunday
        default: return ""
        }
    }
    
    // MARK: - Body
    var body: some View {
        if isWorkoutStarted {
            WorkoutView(exercises: exercises)
        } else {
            VStack {
                // App title
                Text("5-Minute Exercise")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.top, 40)
                
                if isCountingDown {
                    // Countdown view with exercises
                    VStack(spacing: 20) {
                        Text("\(countdownSeconds)")
                            .font(.system(size: 72, weight: .bold))
                            .foregroundColor(countdownSeconds <= 5 ? .red : .primary)
                            .onAppear {
                                startCountdown()
                            }
                        
                        Text("Get Ready!")
                            .font(.title2)
                            .foregroundColor(.gray)
                        
                        // Day's workout title
                        Text("Day \(currentDay): \(getDayTitle())")
                            .font(.headline)
                            .foregroundColor(.blue)
                            .padding(.top)
                            
                        // Exercise list preview
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Today's Exercises:")
                                .font(.headline)
                                .padding(.horizontal)
                            
                            ScrollView {
                                LazyVStack(alignment: .leading, spacing: 8) {
                                    ForEach(exercises) { exercise in
                                        HStack {
                                            Text("• \(exercise.name)")
                                                .font(.subheadline)
                                            Spacer()
                                            Text("\(exercise.duration)s")
                                                .font(.caption)
                                                .foregroundColor(.gray)
                                        }
                                        .padding(.horizontal)
                                    }
                                }
                            }
                            .frame(maxHeight: 200)
                        }
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(10)
                        .padding()
                    }
                } else {
                    Spacer()
                    
                    // Go button
                    Button(action: {
                        isCountingDown = true
                    }) {
                        Text("Go")
                            .font(.system(size: 48, weight: .bold))
                            .foregroundColor(.white)
                            .frame(width: 200, height: 200)
                            .background(Color.blue)
                            .clipShape(Circle())
                            .shadow(radius: 10)
                    }
                    
                    Spacer()
                }
            }
        }
    }
    
    // MARK: - Methods
    private func startCountdown() {
        // Debug log for countdown start
        print("DEBUG: Starting 30-second countdown")
        
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if countdownSeconds > 0 {
                countdownSeconds -= 1
                // Debug log for countdown progress
                print("DEBUG: Countdown: \(countdownSeconds)s remaining")
            } else {
                timer?.invalidate()
                isWorkoutStarted = true
                // Debug log for countdown completion
                print("DEBUG: Countdown finished - Ready to start workout")
            }
        }
    }
}

// MARK: - Preview
#Preview {
    ContentView()
} 