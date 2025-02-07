import SwiftUI

// Import ExerciseManager

// MARK: - Views
struct ContentView: View {
    // MARK: - State
    @State private var isCountingDown = false
    @State private var countdownSeconds = 30
    @State private var timer: Timer?
    @State private var isWorkoutStarted = false
    @StateObject private var exerciseManager = ExerciseManager.shared
    
    // MARK: - Sample Exercises
    var exercises: [Exercise] {
        exerciseManager.getCurrentDayExercises()
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
                    // Countdown view
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
                    
                    // Difficulty selector
                    Menu {
                        Button(action: {
                            exerciseManager.updateDifficulty(.easy)
                        }) {
                            HStack {
                                Text("Easy")
                                if exerciseManager.selectedDifficulty == .easy {
                                    Image(systemName: "checkmark")
                                }
                            }
                        }
                        
                        Button(action: {
                            exerciseManager.updateDifficulty(.hard)
                        }) {
                            HStack {
                                Text("Hard")
                                if exerciseManager.selectedDifficulty == .hard {
                                    Image(systemName: "checkmark")
                                }
                            }
                        }
                    } label: {
                        Text("Difficulty: \(exerciseManager.selectedDifficulty.rawValue)")
                            .font(.headline)
                            .foregroundColor(.blue)
                            .padding()
                    }
                    
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