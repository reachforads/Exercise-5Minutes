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
    
    // Base URL for exercise GIFs
    private let baseGifURL = "https://firebasestorage.googleapis.com/v0/b/exercise-5minutes-fecad.firebasestorage.app/o"
    
    // MARK: - URL Helpers
    private func makeGifURL(category: Exercise.Category, difficulty: Difficulty, filename: String) -> URL {
        // Create and encode each path component separately
        let pathComponents = [
            "Exercises",
            category.rawValue,
            difficulty.rawValue,
            filename
        ]
        
        // Join components with forward slashes and encode the entire path
        let path = pathComponents.joined(separator: "/")
        let encodedPath = path.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed.subtracting(CharacterSet(charactersIn: "/"))) ?? path
        
        print("DEBUG: Original path - \(path)")
        print("DEBUG: Encoded path - \(encodedPath)")
        
        // Add query parameters
        let queryItems = [
            URLQueryItem(name: "alt", value: "media"),
            URLQueryItem(name: "token", value: "81d652dc-4a08-4cea-94a5-d16ba55431a4")
        ]
        
        // Construct URL components
        var components = URLComponents(string: "\(baseGifURL)/\(encodedPath)")!
        components.queryItems = queryItems
        
        // Debug log for URL construction
        print("DEBUG: Constructed URL - \(components.url?.absoluteString ?? "invalid URL")")
        
        return components.url!
    }
    
    // MARK: - Exercise Data
    private lazy var exercises: [Exercise.Category: [Exercise]] = [
        .chest: [
            Exercise(id: UUID(), 
                    name: "Push-ups", 
                    duration: 5, 
                    category: .chest,
                    easyGifURL: makeGifURL(category: .chest, difficulty: .easy, filename: "push_ups_easy.gif"),
                    hardGifURL: makeGifURL(category: .chest, difficulty: .hard, filename: "push_ups_hard.gif")),
            Exercise(id: UUID(), 
                    name: "Chest Press", 
                    duration: 5, 
                    category: .chest,
                    easyGifURL: makeGifURL(category: .chest, difficulty: .easy, filename: "chest_press_easy.gif"),
                    hardGifURL: makeGifURL(category: .chest, difficulty: .hard, filename: "chest_press_hard.gif")),
            Exercise(id: UUID(), 
                    name: "Chest Flys", 
                    duration: 5, 
                    category: .chest,
                    easyGifURL: makeGifURL(category: .chest, difficulty: .easy, filename: "chest_flys_easy.gif"),
                    hardGifURL: makeGifURL(category: .chest, difficulty: .hard, filename: "chest_flys_hard.gif"))
        ],
        .triceps: [
            Exercise(id: UUID(), 
                    name: "Tricep Dips", 
                    duration: 5, 
                    category: .triceps,
                    easyGifURL: makeGifURL(category: .triceps, difficulty: .easy, filename: "tricep_dips_easy.gif"),
                    hardGifURL: makeGifURL(category: .triceps, difficulty: .hard, filename: "tricep_dips_hard.gif")),
            Exercise(id: UUID(), 
                    name: "Tricep Extensions", 
                    duration: 5, 
                    category: .triceps,
                    easyGifURL: makeGifURL(category: .triceps, difficulty: .easy, filename: "tricep_extensions_easy.gif"),
                    hardGifURL: makeGifURL(category: .triceps, difficulty: .hard, filename: "tricep_extensions_hard.gif"))
        ],
        .back: [
            Exercise(id: UUID(), 
                    name: "Rows", 
                    duration: 5, 
                    category: .back,
                    easyGifURL: makeGifURL(category: .back, difficulty: .easy, filename: "rows_easy.gif"),
                    hardGifURL: makeGifURL(category: .back, difficulty: .hard, filename: "rows_hard.gif")),
            Exercise(id: UUID(), 
                    name: "Lat Pulldowns", 
                    duration: 5, 
                    category: .back,
                    easyGifURL: makeGifURL(category: .back, difficulty: .easy, filename: "lat_pulldowns_easy.gif"),
                    hardGifURL: makeGifURL(category: .back, difficulty: .hard, filename: "lat_pulldowns_hard.gif"))
        ],
        .biceps: [
            Exercise(id: UUID(), 
                    name: "Bicep Curls", 
                    duration: 5, 
                    category: .biceps,
                    easyGifURL: makeGifURL(category: .biceps, difficulty: .easy, filename: "bicep_curls_easy.gif"),
                    hardGifURL: makeGifURL(category: .biceps, difficulty: .hard, filename: "bicep_curls_hard.gif")),
            Exercise(id: UUID(), 
                    name: "Hammer Curls", 
                    duration: 5, 
                    category: .biceps,
                    easyGifURL: makeGifURL(category: .biceps, difficulty: .easy, filename: "hammer_curls_easy.gif"),
                    hardGifURL: makeGifURL(category: .biceps, difficulty: .hard, filename: "hammer_curls_hard.gif"))
        ],
        .abs: [
            Exercise(id: UUID(), 
                    name: "Crunches", 
                    duration: 5, 
                    category: .abs,
                    easyGifURL: makeGifURL(category: .abs, difficulty: .easy, filename: "crunches_easy.gif"),
                    hardGifURL: makeGifURL(category: .abs, difficulty: .hard, filename: "crunches_hard.gif")),
            Exercise(id: UUID(), 
                    name: "Plank", 
                    duration: 5, 
                    category: .abs,
                    easyGifURL: makeGifURL(category: .abs, difficulty: .easy, filename: "plank_easy.gif"),
                    hardGifURL: makeGifURL(category: .abs, difficulty: .hard, filename: "plank_hard.gif")),
            Exercise(id: UUID(), 
                    name: "Leg Raises", 
                    duration: 5, 
                    category: .abs,
                    easyGifURL: makeGifURL(category: .abs, difficulty: .easy, filename: "leg_raises_easy.gif"),
                    hardGifURL: makeGifURL(category: .abs, difficulty: .hard, filename: "leg_raises_hard.gif"))
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