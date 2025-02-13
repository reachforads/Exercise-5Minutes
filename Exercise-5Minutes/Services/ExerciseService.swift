import Foundation
import UIKit

class ExerciseService: ObservableObject {
    static let shared = ExerciseService()
    
    private let baseURL = "https://firebasestorage.googleapis.com/v0/b/exercise-5minutes-fecad.firebasestorage.app/o/Exercises"
    private let cache = NSCache<NSString, UIImage>()
    
    @Published var isLoading = false
    @Published var error: Error?
    
    // MARK: - Exercise Data
    func fetchExercises(for category: Exercise.Category) async throws -> [Exercise] {
        let url = URL(string: "\(baseURL)/\(category.rawValue.lowercased())")!
        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode([Exercise].self, from: data)
    }
    
    // MARK: - GIF Loading
    func loadGIF(from url: URL) async throws -> UIImage? {
        // Check cache first
        let cacheKey = NSString(string: url.absoluteString)
        if let cachedImage = cache.object(forKey: cacheKey) {
            print("DEBUG: Found cached GIF for: \(url)")
            return cachedImage
        }
        
        // Download GIF data
        print("DEBUG: Downloading GIF from: \(url)")
        let (data, _) = try await URLSession.shared.data(from: url)
        
        // Convert to animated image
        if let animatedImage = UIImage.gifImageWithData(data) {
            // Cache the image
            cache.setObject(animatedImage, forKey: cacheKey)
            return animatedImage
        }
        
        return nil
    }
} 