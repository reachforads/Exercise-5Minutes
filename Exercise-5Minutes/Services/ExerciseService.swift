import Foundation
import UIKit
import SDWebImageSwiftUI

class ExerciseService: ObservableObject {
    static let shared = ExerciseService()
    
    private let baseURL = "https://firebasestorage.googleapis.com/v0/b/exercise-5minutes-fecad.firebasestorage.app/o"
    
    // MARK: - Cache Configuration
    private let cacheDuration: TimeInterval = 7 * 24 * 60 * 60 // 7 days in seconds
    private let maxCacheSize: UInt = 100 * 1024 * 1024  // 100MB
    
    init() {
        configureCache()
    }
    
    private func configureCache() {
        // Configure SDWebImage cache
        let cache = SDImageCache.shared
        
        // Set memory cache config
        cache.config.maxMemoryCost = 50 * 1024 * 1024  // 50MB memory cache
        cache.config.maxMemoryCount = 30  // Max number of images in memory
        
        // Set disk cache config
        cache.config.maxDiskSize = maxCacheSize
        cache.config.maxDiskAge = cacheDuration
        
        // Configure SDWebImage default options
        SDWebImageManager.shared.optionsProcessor = SDWebImageOptionsProcessor { url, options, context in
            var mutableOptions = options
            // Always use disk cache and retry failed downloads
            mutableOptions.insert(.fromCacheOnly)
            mutableOptions.insert(.retryFailed)
            return SDWebImageOptionsResult(options: mutableOptions, context: context)
        }
        
        print("DEBUG: Cache configured - Max size: \(maxCacheSize/1024/1024)MB, Duration: \(cacheDuration/24/60/60) days")
    }
    
    // MARK: - Cache Management
    func clearCache() async {
        SDImageCache.shared.clearMemory()
        await withCheckedContinuation { continuation in
            SDImageCache.shared.clearDisk {
                print("DEBUG: Cache cleared")
                continuation.resume()
            }
        }
    }
    
    func getCacheSize() -> UInt {
        return SDImageCache.shared.totalDiskSize()
    }
    
    func getCacheCount() -> UInt {
        return SDImageCache.shared.totalDiskCount()
    }
    
    // Optional: Clear old cache entries
    func cleanupCache() async {
        await withCheckedContinuation { continuation in
            SDImageCache.shared.deleteOldFiles {
                print("DEBUG: Old cache entries cleaned up")
                continuation.resume()
            }
        }
    }
    
    // MARK: - Exercise Data
    func fetchExercises(for category: Exercise.Category) async throws -> [Exercise] {
        let url = URL(string: "\(baseURL)/\(category.rawValue.lowercased())")!
        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode([Exercise].self, from: data)
    }
    
    // MARK: - GIF Loading
    func loadGIF(from url: URL) async throws -> UIImage? {
        // Check cache first
        let cacheKey = url.absoluteString
        if let cachedImage = SDImageCache.shared.imageFromCache(forKey: cacheKey) {
            print("DEBUG: Found cached GIF for: \(url)")
            return cachedImage
        }
        
        // Download GIF data
        print("DEBUG: Downloading GIF from: \(url)")
        let (data, _) = try await URLSession.shared.data(from: url)
        
        // Convert to animated image
        if let animatedImage = await UIImage.gifImageWithData(data) {
            // Cache the image
            await withCheckedContinuation { continuation in
                SDImageCache.shared.store(animatedImage, forKey: cacheKey, toDisk: true) {
                    continuation.resume()
                }
            }
            return animatedImage
        }
        
        return nil
    }
}

// MARK: - UIImage Extension
extension UIImage {
    class func gifImageWithData(_ data: Data) async -> UIImage? {
        await withCheckedContinuation { continuation in
            DispatchQueue.global(qos: .userInitiated).async {
                guard let source = CGImageSourceCreateWithData(data as CFData, nil) else {
                    print("DEBUG: Failed to create image source")
                    continuation.resume(returning: nil)
                    return
                }
                
                let count = CGImageSourceGetCount(source)
                guard count > 1 else {
                    print("DEBUG: Not an animated image")
                    continuation.resume(returning: UIImage(data: data))
                    return
                }
                
                var images = [UIImage]()
                var duration = 0.0
                
                for i in 0..<count {
                    if let cgImage = CGImageSourceCreateImageAtIndex(source, i, nil) {
                        let image = UIImage(cgImage: cgImage)
                        images.append(image)
                        
                        if let properties = CGImageSourceCopyPropertiesAtIndex(source, i, nil) as? [String: Any],
                           let gifProperties = properties[kCGImagePropertyGIFDictionary as String] as? [String: Any],
                           let delayTime = gifProperties[kCGImagePropertyGIFDelayTime as String] as? Double {
                            duration += delayTime
                        }
                    }
                }
                
                let finalDuration = duration > 0 ? duration : Double(count) * 0.1
                let animatedImage = UIImage.animatedImage(with: images, duration: finalDuration)
                continuation.resume(returning: animatedImage)
            }
        }
    }
} 