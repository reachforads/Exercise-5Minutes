import SwiftUI

struct WorkoutView: View {
    // MARK: - Properties
    let exercises: [Exercise]
    @State private var currentExerciseIndex = 0
    @State private var exerciseTimeRemaining = 30
    @State private var timer: Timer?
    @State private var isWorkoutComplete = false
    @StateObject private var exerciseManager = ExerciseManager.shared
    
    // MARK: - Body
    var body: some View {
        VStack(spacing: 20) {
            // Progress and difficulty selector
            HStack {
                // Progress bar
                ProgressView(value: Double(currentExerciseIndex), total: Double(exercises.count))
                
                Spacer()
                
                // Difficulty toggle
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
                    Label(exerciseManager.selectedDifficulty.rawValue, systemImage: "slider.horizontal.3")
                        .foregroundColor(.blue)
                }
            }
            .padding()
            
            // Current exercise
            if !exercises.isEmpty {
                Text(exercises[currentExerciseIndex].name)
                    .font(.system(size: 32, weight: .bold))
                
                Text(exercises[currentExerciseIndex].category.rawValue)
                    .font(.title2)
                    .foregroundColor(.blue)
                
                // Timer
                Text("\(exerciseTimeRemaining)")
                    .font(.system(size: 64, weight: .bold))
                    .foregroundColor(exerciseTimeRemaining <= 5 ? .red : .primary)
                    .onAppear {
                        startExerciseTimer()
                    }
                
                // Next up preview
                if currentExerciseIndex < exercises.count - 1 {
                    VStack(alignment: .leading) {
                        Text("Next up:")
                            .font(.headline)
                            .foregroundColor(.gray)
                        Text(exercises[currentExerciseIndex + 1].name)
                            .font(.title3)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                }
            }
            
            Spacer()
            
            // Exercise list
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 8) {
                    ForEach(Array(exercises.enumerated()), id: \.element.id) { index, exercise in
                        HStack {
                            Text("• \(exercise.name)")
                                .font(.subheadline)
                                .foregroundColor(index == currentExerciseIndex ? .blue : 
                                               index < currentExerciseIndex ? .gray : .primary)
                            Spacer()
                            if index < currentExerciseIndex {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.green)
                            }
                        }
                        .padding(.horizontal)
                    }
                }
            }
            .frame(maxHeight: 200)
            .background(Color.gray.opacity(0.1))
            .cornerRadius(10)
            .padding()
        }
        .padding()
        .onDisappear {
            timer?.invalidate()
        }
        .sheet(isPresented: $isWorkoutComplete) {
            WorkoutCompleteView()
        }
    }
    
    // MARK: - Methods
    private func startExerciseTimer() {
        guard !exercises.isEmpty else { return }
        
        // Debug log for exercise start
        print("DEBUG: Starting exercise: \(exercises[currentExerciseIndex].name)")
        
        exerciseTimeRemaining = exercises[currentExerciseIndex].duration
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if exerciseTimeRemaining > 0 {
                exerciseTimeRemaining -= 1
                // Debug log for exercise progress
                print("DEBUG: Exercise time remaining: \(exerciseTimeRemaining)s")
            } else {
                moveToNextExercise()
            }
        }
    }
    
    private func moveToNextExercise() {
        timer?.invalidate()
        if currentExerciseIndex < exercises.count - 1 {
            currentExerciseIndex += 1
            // Debug log for exercise transition
            print("DEBUG: Moving to next exercise: \(exercises[currentExerciseIndex].name)")
            startExerciseTimer()
        } else {
            isWorkoutComplete = true
            // Debug log for workout completion
            print("DEBUG: Workout complete!")
        }
    }
}

// MARK: - Workout Complete View
struct WorkoutCompleteView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack(spacing: 20) {
            Text("🎉 Workout Complete! 🎉")
                .font(.title)
                .fontWeight(.bold)
            
            Text("Great job! Would you like to continue for 2 more minutes?")
                .multilineTextAlignment(.center)
                .padding()
            
            Button("Extend Workout") {
                // TODO: Implement extend workout functionality
                print("DEBUG: User chose to extend workout")
            }
            .font(.headline)
            .foregroundColor(.white)
            .padding()
            .background(Color.blue)
            .cornerRadius(10)
            
            Button("Finish") {
                dismiss()
                print("DEBUG: User finished workout")
            }
            .font(.headline)
            .padding()
        }
    }
} 