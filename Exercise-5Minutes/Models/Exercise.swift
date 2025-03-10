import Foundation

struct Exercise: Identifiable, Codable {
    let id: UUID
    let name: String
    let duration: Int // in seconds
    let category: Category
    let easyGifURL: URL
    let hardGifURL: URL
    
    enum Category: String, Codable, CaseIterable {
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
} 