import Foundation

struct Exercise: Identifiable {
    let id = UUID()
    let name: String
    let duration: Int // in seconds
    let category: Category
    let difficulty: Difficulty
    let gifName: String
    
    enum Category: String, CaseIterable {
        case chest = "Chest"
        case triceps = "Triceps"
        case back = "Back"
        case biceps = "Biceps"
        case legs = "Legs"
        case shoulders = "Shoulders"
        case abs = "Abs"
        case hiit = "HIIT"
        case yoga = "Yoga"
        case restWalk = "Rest-Walk"
    }
    
    enum Difficulty: String {
        case easy = "Easy"
        case hard = "Hard"
    }
    
    var gifPath: String {
        "Exercises/\(category.rawValue)/\(difficulty.rawValue)/\(gifName)"
    }
} 