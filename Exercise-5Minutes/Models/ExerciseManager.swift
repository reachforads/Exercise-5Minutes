import Foundation
import SwiftUI

class ExerciseManager: ObservableObject {
    static let shared = ExerciseManager()
    
    // MARK: - Types
    enum Difficulty: String {
        case easy = "Easy"
        case hard = "Hard"
    }
    
    // MARK: - Properties
    @Published var selectedDifficulty: Difficulty = .easy
    @Published private(set) var dailyExercises: [Exercise] = []
    
    // Cache validation
    private var lastCacheDate: Date?
    
    // MARK: - Exercise Data
    private let exercises: [Exercise.Category: [Exercise]] = [
        .chest: [
            Exercise(name: "Push-ups", duration: 30, category: .chest, 
                    easyGifName: "push_ups_easy.gif", hardGifName: "push_ups_hard.gif"),
            Exercise(name: "Chest Press", duration: 30, category: .chest, 
                    easyGifName: "chest_press_easy.gif", hardGifName: "chest_press_hard.gif"),
            Exercise(name: "Chest Flys", duration: 30, category: .chest, 
                    easyGifName: "chest_flys_easy.gif", hardGifName: "chest_flys_hard.gif")
        ],
        .triceps: [
            Exercise(name: "Tricep Dips", duration: 30, category: .triceps, 
                    easyGifName: "tricep_dips_easy.gif", hardGifName: "tricep_dips_hard.gif"),
            Exercise(name: "Tricep Extensions", duration: 30, category: .triceps, 
                    easyGifName: "tricep_extensions_easy.gif", hardGifName: "tricep_extensions_hard.gif")
        ],
        .back: [
            Exercise(name: "Rows", duration: 30, category: .back, 
                    easyGifName: "rows_easy.gif", hardGifName: "rows_hard.gif"),
            Exercise(name: "Lat Pulldowns", duration: 30, category: .back, 
                    easyGifName: "lat_pulldowns_easy.gif", hardGifName: "lat_pulldowns_hard.gif")
        ],
        .biceps: [
            Exercise(name: "Bicep Curls", duration: 30, category: .biceps, 
                    easyGifName: "bicep_curls_easy.gif", hardGifName: "bicep_curls_hard.gif"),
            Exercise(name: "Hammer Curls", duration: 30, category: .biceps, 
                    easyGifName: "hammer_curls_easy.gif", hardGifName: "hammer_curls_hard.gif")
        ],
        .abs: [
            Exercise(name: "Crunches", duration: 30, category: .abs, 
                    easyGifName: "crunches_easy.gif", hardGifName: "crunches_hard.gif"),
            Exercise(name: "Plank", duration: 30, category: .abs, 
                    easyGifName: "plank_easy.gif", hardGifName: "plank_hard.gif"),
            Exercise(name: "Leg Raises", duration: 30, category: .abs, 
                    easyGifName: "leg_raises_easy.gif", hardGifName: "leg_raises_hard.gif")
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
        
        // Get all exercises for the day's categories
        let allExercises = categories.flatMap { category in
            exercises[category] ?? []
        }
        
        // Randomly select and cache 10 exercises
        return Array(allExercises.shuffled().prefix(10))
    }
    
    func getCurrentDayExercises() -> [Exercise] {
        // If we already have exercises for today, return them
        if let lastDate = lastCacheDate, Calendar.current.isDateInToday(lastDate) && !dailyExercises.isEmpty {
            print("DEBUG: Returning cached exercises for today")
            return dailyExercises
        }
        
        // Otherwise, get new exercises for day 1
        print("DEBUG: Selecting new exercises for today")
        dailyExercises = getExercisesForDay(1)  // Hardcode to Day 1
        lastCacheDate = Date()
        return dailyExercises
    }
    
    func updateDifficulty(_ difficulty: Difficulty) {
        selectedDifficulty = difficulty
        // Debug log for difficulty change
        print("DEBUG: Updated difficulty to \(difficulty.rawValue)")
    }
} 