import Foundation
import SwiftUI

class ExerciseManager: ObservableObject {
    static let shared = ExerciseManager()
    
    // MARK: - Properties
    @Published var selectedDifficulty: Exercise.Difficulty = .easy
    
    // MARK: - Exercise Data
    private let exercises: [Exercise.Category: [Exercise]] = [
        .chest: [
            Exercise(name: "Push-ups", duration: 30, category: .chest, difficulty: .easy, gifName: "push_ups_easy.gif"),
            Exercise(name: "Chest Press", duration: 30, category: .chest, difficulty: .easy, gifName: "chest_press_easy.gif"),
            Exercise(name: "Chest Flys", duration: 30, category: .chest, difficulty: .easy, gifName: "chest_flys_easy.gif")
        ],
        .triceps: [
            Exercise(name: "Tricep Dips", duration: 30, category: .triceps, difficulty: .easy, gifName: "tricep_dips_easy.gif"),
            Exercise(name: "Tricep Extensions", duration: 30, category: .triceps, difficulty: .easy, gifName: "tricep_extensions_easy.gif")
        ],
        .back: [
            Exercise(name: "Rows", duration: 30, category: .back, difficulty: .easy, gifName: "rows_easy.gif"),
            Exercise(name: "Lat Pulldowns", duration: 30, category: .back, difficulty: .easy, gifName: "lat_pulldowns_easy.gif")
        ],
        .biceps: [
            Exercise(name: "Bicep Curls", duration: 30, category: .biceps, difficulty: .easy, gifName: "bicep_curls_easy.gif"),
            Exercise(name: "Hammer Curls", duration: 30, category: .biceps, difficulty: .easy, gifName: "hammer_curls_easy.gif")
        ],
        .abs: [
            Exercise(name: "Crunches", duration: 30, category: .abs, difficulty: .easy, gifName: "crunches_easy.gif"),
            Exercise(name: "Plank", duration: 30, category: .abs, difficulty: .easy, gifName: "plank_easy.gif"),
            Exercise(name: "Leg Raises", duration: 30, category: .abs, difficulty: .easy, gifName: "leg_raises_easy.gif")
        ]
    ]
    
    // MARK: - Methods
    func getExercisesForDay(_ day: Int) -> [Exercise] {
        let categories: [Exercise.Category]
        
        switch day {
        case 1: categories = [.chest, .triceps, .abs]
        case 2: categories = [.back, .biceps, .abs]
        case 3: categories = [.legs, .abs]
        case 4: categories = [.shoulders, .abs]
        case 5: categories = [.hiit, .abs]
        case 6: categories = [.yoga]
        case 7: categories = [.restWalk]
        default: categories = []
        }
        
        // Debug log for day's workout
        print("DEBUG: Getting exercises for day \(day): \(categories.map { $0.rawValue })")
        
        return categories.flatMap { category in
            exercises[category] ?? []
        }
    }
    
    func getCurrentDayExercises() -> [Exercise] {
        let calendar = Calendar.current
        let dayOfWeek = calendar.component(.weekday, from: Date())
        return getExercisesForDay(dayOfWeek)
    }
    
    func updateDifficulty(_ difficulty: Exercise.Difficulty) {
        selectedDifficulty = difficulty
        // Debug log for difficulty change
        print("DEBUG: Updated difficulty to \(difficulty.rawValue)")
    }
} 