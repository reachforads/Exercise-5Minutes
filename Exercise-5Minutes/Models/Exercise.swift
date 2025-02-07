import Foundation

struct Exercise: Identifiable {
    let id = UUID()
    let name: String
    let duration: Int // in seconds
    let category: Category
    let easyGifName: String
    let hardGifName: String
    
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
    
    var easyGifPath: String {
        "Exercises/\(category.rawValue)/Easy/\(easyGifName)"
    }
    
    var hardGifPath: String {
        "Exercises/\(category.rawValue)/Hard/\(hardGifName)"
    }
} 